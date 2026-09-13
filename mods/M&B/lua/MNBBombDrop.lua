-- M&B scripted bomb release for T1-T3 bombers.
--
-- Problem: the engine releases bombs only when its own drop solution converges
-- (target inside MaxRadius AND heading inside FiringTolerance). On many passes
-- the window never opens, so bombers overfly the target and drop nothing.
--
-- Fix: the engine keeps the attack order, the aiming and the attack runs
-- exactly as vanilla - the weapon just never releases on its own (OnFire
-- no-op + CreateProjectileAtMuzzle gate; blueprint side: NeedToComputeBombDrop
-- =false, FiringTolerance=180, PredictAheadForBombDrop=0). A watch thread in
-- the weapon is the bombardier: it waits for the release point and drops the
-- stick from whatever height the plane is at:
--   * every bomb gets a FIXED horizontal speed and a FIXED gravity, so the arc
--     is identical on every pass regardless of plane speed, dives or hills;
--   * the release point is computed from the actual height over the target,
--     so bombs still land on the target when flying up/downhill;
--   * the whole stick flies ONE fixed direction (forward along the attack
--     run); bombs leave the muzzles in the engine's own order and cadence,
--     so multi-rack bombers keep their vanilla dense rows.
-- Not touched: torpedo bombers, missile bombers (Cybran T2), experiments.

local MNB_BOMB_SPEED = 6      -- fixed horizontal bomb speed
local MNB_BOMB_GRAVITY = 15   -- fixed bomb gravity; from height 17 fall time ~1.5s
local MNB_MIN_HEIGHT = 3      -- clamp for height over target (valley approach)
local MNB_TERRAIN_CLEAR = 10  -- block the stick when ground ahead rises this close
local MNB_TICK_EST = 0.15     -- fallback seconds between bombs; real gap is measured on the first stick
local MNB_POLL = 0.1          -- watch thread poll interval
local MNB_MIN_COOLDOWN = 3    -- min seconds between sticks

-- T1 profile: the stick is released in symmetric PAIRS (two bombs per
-- cadence tick), so the stripe is twice as short. Each pair gets a SMALL
-- FIXED sideways offset in opposite directions, so the bombs still fall as
-- a forward stripe - just two thin lines slightly apart (Cybran look).
-- LatStep is the fixed sideways speed; with the ~1.5 s fall, 0.67 gives
-- about 1 m of landing offset per side (user, 2026-09-13: was 1.5 m - too wide).
-- Jitter adds a tiny ALTERNATING error INSIDE each stripe: bomb 1 of the
-- stripe a touch left, bomb 2 a touch right, bomb 3 left again - the lines
-- stop looking ruler-straight while staying on target (user, 2026-09-13).
MNB_T1_SPREAD = {
    LatStep = 0.67,
    Jitter = 0.2,
}

-- Cybran T1 profile (user, 2026-09-13): its native stripe width was fine -
-- the two racks already drop two lines - so no pair offset at all, ONLY the
-- in-stripe jitter was missing. LatStep = 0 still selects the paired 'spread'
-- release (short stripe + jitter), just without widening the lines.
MNB_T1_JITTER = {
    LatStep = 0,
    Jitter = 0.2,
}

-- T2/T3 profile: the whole stick (blueprint MuzzleSalvoSize, at most 4)
-- is released in ONE tick, each bomb aimed at its own corner of a square
-- centered on the target. Square is the half-side in meters (3 x 3 m).
-- Bomb damage is scaled in the unit blueprints so the SALVO total damage
-- stays exactly what it was with the old bomb count.
MNB_SQUARE = {
    Square = 1.5,
}

-- square corners: {forward offset, right offset} in half-sides
MNB_SQUARE_CORNERS = {
    { -1, -1 }, { -1, 1 }, { 1, -1 }, { 1, 1 },
}

MNBMakeBombDropper = function(baseClass, dropOpts)
    return Class(baseClass) {

        OnFire = function(self)
            -- Engine release blocked: drops are made by the watch thread below.
        end,

        CreateProjectileAtMuzzle = function(self, muzzle)
            -- Hard gate: only the manual release below may create bombs,
            -- no matter which engine path tries to fire.
            if not self.MnbManualDrop then
                return nil
            end
            return baseClass.CreateProjectileAtMuzzle(self, muzzle)
        end,

        OnCreate = function(self)
            baseClass.OnCreate(self)
            self.MnbDropOpts = dropOpts
            if not self.MnbThread then
                self.MnbThread = ForkThread(self.MnbWatchThread, self)
            end
        end,

        -- NOTE: do NOT drive unit:SetWorkProgress here - for fuel aircraft it
        -- visually replaces the fuel bar under the health bar.
        -- NOTE: do NOT add State(...) overrides to this spec - the weapon
        -- states already define OnFire inside their specs, and class.lua
        -- aborts the whole file ("field is ambiguous") when a spec carries
        -- both a direct OnFire and a derived state. The watch thread below
        -- sees GetCurrentTarget() on its own and needs no state hook.

        MnbWatchThread = function(self)
            local unit = self.unit
            while unit and not unit:IsDead() do
                local now = GetGameTimeSeconds()
                local pos = unit:GetPosition()

                local tpos = self:GetCurrentTargetPos()
                if tpos and not self.MnbReleasing
                    and now >= (self.MnbReadyAt or 0) then

                    -- skip dead entity targets (stale position of a corpse)
                    local ent = self:GetCurrentTarget()
                    if not (ent and ent.IsDead and ent:IsDead()) then

                        local bp = self:GetBlueprint()
                        local dx = tpos.x - pos.x
                        local dz = tpos.z - pos.z
                        local dist = math.sqrt(dx * dx + dz * dz)

                        local height = pos.y - tpos.y
                        if height < MNB_MIN_HEIGHT then
                            height = MNB_MIN_HEIGHT
                        end
                        -- horizontal distance a bomb covers while falling from this height
                        local dropDist = MNB_BOMB_SPEED * math.sqrt(2 * height / MNB_BOMB_GRAVITY)

                        -- plane ground speed and heading measured across the last poll
                        local speed = 10
                        local fdirX = 0
                        local fdirZ = 0
                        local haveFlight = false
                        if self.MnbPrevPos and self.MnbPrevTime and now > self.MnbPrevTime then
                            local mdx = pos.x - self.MnbPrevPos.x
                            local mdz = pos.z - self.MnbPrevPos.z
                            local moved = math.sqrt(mdx * mdx + mdz * mdz)
                            if moved > 0.01 then
                                speed = moved / (now - self.MnbPrevTime)
                                fdirX = mdx / moved
                                fdirZ = mdz / moved
                                haveFlight = true
                            end
                        end
                        local salvo = bp.MuzzleSalvoSize or 1
                        -- bombs leave one per engine tick, so the stick length scales
                        -- with plane speed; release early enough that the MIDDLE of
                        -- the stick lands on the target. Real gap between bombs is
                        -- measured on the first stick, not guessed.
                        local gap = self.MnbBombGap or MNB_TICK_EST
                        -- with a spread the stick is released in pairs, with a
                        -- square in one tick - the lead must match that cadence
                        local groups = salvo
                        if self.MnbDropOpts then
                            if self.MnbDropOpts.Square then
                                groups = 1
                            else
                                groups = math.ceil(salvo / 2)
                            end
                        end
                        local lead = ((groups - 1) * speed * gap) / 2

                        local dirX = 0
                        local dirZ = 0
                        local clear = true
                        if dist > 0.01 then
                            dirX = dx / dist
                            dirZ = dz / dist
                            -- corridor check: do not start a stick if the ground ahead
                            -- rises into it (approaching a slope head-on), otherwise
                            -- the plane climbs desperately mid-release
                            local s = 3
                            while s <= dist + lead do
                                if GetTerrainHeight(pos.x + dirX * s, pos.z + dirZ * s)
                                    > pos.y - MNB_TERRAIN_CLEAR then
                                    clear = false
                                    break
                                end
                                s = s + 3
                            end
                        end

                        -- release only while still APPROACHING the target, and the
                        -- stick always flies FORWARD along the flight direction
                        -- (never backwards at a target already passed)
                        local approaching = true
                        if haveFlight and dist > 0.01 then
                            approaching = (fdirX * dirX + fdirZ * dirZ) > 0
                        end
                        if not haveFlight then
                            fdirX = dirX
                            fdirZ = dirZ
                        end

                        if approaching and dist <= dropDist + lead + 0.3
                            and dist > 0.01 and clear then
                            self.MnbReleasing = true
                            self:MnbReleaseStick(tpos, salvo, fdirX, fdirZ)
                            self.MnbReleasing = nil
                            local cool = math.max(MNB_MIN_COOLDOWN, 1 / (bp.RateOfFire or 0.05))
                            self.MnbReadyAt = now + cool
                        end
                    end
                end
                self.MnbPrevPos = pos
                self.MnbPrevTime = now
                WaitSeconds(MNB_POLL)
            end
        end,

        MnbReleaseStick = function(self, tpos, salvo, fdirX, fdirZ)
            local unit = self.unit
            local bp = self:GetBlueprint()
            local muzzles = nil
            if bp.RackBones and bp.RackBones[1] and bp.RackBones[1].MuzzleBones then
                muzzles = bp.RackBones[1].MuzzleBones
            end
            local mCount = table.getn(muzzles or {})
            -- drop mode: nil = engine-cadence stick straight ahead (default),
            -- 'spread' = symmetric pairs fanning sideways (T1),
            -- 'square' = whole stick in one tick on square corners (T2/T3)
            local mode = nil
            if self.MnbDropOpts then
                if self.MnbDropOpts.Square then
                    mode = 'square'
                elseif self.MnbDropOpts.LatStep ~= nil then
                    -- explicit 0 counts too (Cybran: pairs + jitter, no offset)
                    mode = 'spread'
                end
            end
            -- right-hand vector perpendicular to the base direction
            local rX = -fdirZ
            local rZ = fdirX
            -- square geometry: bombs aim at corners of a square centered on the
            -- target, so the fall arc is recomputed from the actual height
            local dist = 0
            local T = 0
            local tX = fdirX
            local tZ = fdirZ
            if mode == 'square' then
                local pos = unit:GetPosition()
                local dx = tpos.x - pos.x
                local dz = tpos.z - pos.z
                dist = math.sqrt(dx * dx + dz * dz)
                local height = pos.y - tpos.y
                if height < MNB_MIN_HEIGHT then
                    height = MNB_MIN_HEIGHT
                end
                T = math.sqrt(2 * height / MNB_BOMB_GRAVITY)
                if dist > 0.01 then
                    tX = dx / dist
                    tZ = dz / dist
                    rX = -tZ
                    rZ = tX
                end
            end
            local half = (self.MnbDropOpts and self.MnbDropOpts.Square) or 0
            local step = (self.MnbDropOpts and self.MnbDropOpts.LatStep) or 0
            local jitter = (self.MnbDropOpts and self.MnbDropOpts.Jitter) or 0
            local perTick = 1
            if mode == 'spread' then
                perTick = 2
            elseif mode == 'square' then
                perTick = salvo
            end
            local idx = 0
            local i = 1
            while i <= salvo do
                if unit:IsDead() then break end
                local count = perTick
                if i + count - 1 > salvo then
                    count = salvo - i + 1
                end
                for j = 1, count do
                    idx = idx + 1
                    -- engine order: muzzles fire one by one in turn, so multi-rack
                    -- bombers (Cybran T1) keep their vanilla rows
                    local bone = nil
                    if mCount > 0 then
                        bone = muzzles[math.mod(idx - 1, mCount) + 1]
                    end
                    self.MnbManualDrop = true
                    local proj = self:CreateProjectileAtMuzzle(bone)
                    self.MnbManualDrop = nil
                    -- measure the real engine gap once so the release lead is
                    -- truthful: bomb-to-bomb by default, pair-to-pair for a fan
                    if idx == 1 then
                        self.MnbStickT1 = GetGameTimeSeconds()
                    elseif idx == 1 + perTick and self.MnbStickT1 then
                        local measured = GetGameTimeSeconds() - self.MnbStickT1
                        if measured > 0.01 then
                            self.MnbBombGap = measured
                        end
                        self.MnbStickT1 = nil
                    end
                    if proj and not proj:BeenDestroyed() then
                        if mode == 'square' and T > 0.01 then
                            -- corner of the square (cycled when salvo > 4)
                            local corner = math.mod(idx - 1, 4) + 1
                            local fOff = MNB_SQUARE_CORNERS[corner][1] * half
                            local rOff = MNB_SQUARE_CORNERS[corner][2] * half
                            local fwd = (dist + fOff) / T
                            local lat = rOff / T
                            proj:SetVelocity(fwd * tX + lat * rX, 0,
                                             fwd * tZ + lat * rZ)
                        else
                            -- fixed forward direction for the whole stick; the
                            -- spread offsets each pair sideways, and the jitter
                            -- wobbles bombs left/right INSIDE each stripe
                            local lateral = 0
                            if mode == 'spread' then
                                local side = 1
                                if j == 2 then side = -1 end
                                lateral = side * step
                                if jitter ~= 0 then
                                    -- position of this bomb inside ITS stripe
                                    -- (pairs share the stripes: idx 1,3,5.. = one,
                                    -- 2,4,6.. = the other)
                                    local laneNum = math.floor((idx + 1) / 2)
                                    local jside = 1
                                    if math.mod(laneNum, 2) == 1 then
                                        jside = -1
                                    end
                                    lateral = lateral + jside * jitter
                                end
                            end
                            proj:SetVelocity(MNB_BOMB_SPEED * fdirX + lateral * rX, 0,
                                             MNB_BOMB_SPEED * fdirZ + lateral * rZ)
                        end
                        proj:SetBallisticAcceleration(-MNB_BOMB_GRAVITY)
                    end
                end
                -- engine cadence between bombs (pairs) of the salvo
                if i + count <= salvo and not unit:IsDead() then
                    WaitSeconds(bp.MuzzleSalvoDelay or 0.01)
                end
                i = i + count
            end
            self.MnbStickT1 = nil
        end,
    }
end
