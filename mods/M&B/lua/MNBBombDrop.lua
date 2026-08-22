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

MNBMakeBombDropper = function(baseClass)
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
                        local lead = ((salvo - 1) * speed * gap) / 2

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

        MnbReleaseStick = function(self, tpos, salvo, dirX, dirZ)
            local unit = self.unit
            local bp = self:GetBlueprint()
            local muzzles = nil
            if bp.RackBones and bp.RackBones[1] and bp.RackBones[1].MuzzleBones then
                muzzles = bp.RackBones[1].MuzzleBones
            end
            local mCount = table.getn(muzzles or {})
            for i = 1, salvo do
                if unit:IsDead() then break end
                -- engine order: muzzles fire one by one in turn, so multi-rack
                -- bombers (Cybran T1) keep their vanilla rows
                local bone = nil
                if mCount > 0 then
                    bone = muzzles[math.mod(i - 1, mCount) + 1]
                end
                self.MnbManualDrop = true
                local proj = self:CreateProjectileAtMuzzle(bone)
                self.MnbManualDrop = nil
                -- measure the real engine gap between bombs once, so the
                -- release lead is truthful instead of a guess
                if i == 1 then
                    self.MnbStickT1 = GetGameTimeSeconds()
                elseif i == 2 and self.MnbStickT1 then
                    local measured = GetGameTimeSeconds() - self.MnbStickT1
                    if measured > 0.01 then
                        self.MnbBombGap = measured
                    end
                    self.MnbStickT1 = nil
                end
                if proj and not proj:BeenDestroyed() then
                    -- fixed forward direction for the whole stick
                    proj:SetVelocity(MNB_BOMB_SPEED * dirX, 0, MNB_BOMB_SPEED * dirZ)
                    proj:SetBallisticAcceleration(-MNB_BOMB_GRAVITY)
                end
                -- engine cadence between bombs of the salvo
                if i < salvo and not unit:IsDead() then
                    WaitSeconds(bp.MuzzleSalvoDelay or 0.01)
                end
            end
        end,
    }
end
