do
	Callbacks.GiveOrders = import('/mods/M&B/lua/spreadattack.lua').GiveOrders
end

-- === skuf: sim side of the personal Economy Helper UI mod ===
-- The player's skuf mod is UI-ONLY (works without others having it), so it cannot
-- carry sim code. Instead it calls these callbacks: every client has M&B, so the
-- callback exists and executes identically on every machine (kept deterministic ->
-- no desync). Features only ever touch the army passed in from the player's UI.
do
local SkufVanillaPrefix = { uef = 'ueb', aeon = 'uab', cybran = 'urb', seraphim = 'xsb' }
local SkufT4Prefix = { uef = 'seb', aeon = 'sab', cybran = 'srb', seraphim = 'ssb' }

-- vanilla ids: mex T1=1103 T2=1202 T3=1302, hydro=1102, pgens 1101/1201/1301;
-- storages: mass=1106, energy=1105; M&B T4 mex = x1312
local function SkufMexTier(sId)
    if string.find(sId, '1312') then return 4 end
    if string.find(sId, '1302') then return 3 end
    if string.find(sId, '1202') then return 2 end
    if string.find(sId, '1103') then return 1 end
    return nil
end

local function SkufNextMexId(unit)
    local bp = unit:GetBlueprint()
    local id = bp.BlueprintId or ''
    local faction = string.lower(bp.General.FactionName or 'uef')
    if string.find(id, '1103') then return (SkufVanillaPrefix[faction] or 'ueb') .. '1202' end
    if string.find(id, '1202') then return (SkufVanillaPrefix[faction] or 'ueb') .. '1302' end
    if string.find(id, '1302') then return (SkufT4Prefix[faction] or 'seb') .. '1312' end
    return nil
end

local function SkufTargetTier(brain)
    -- M&B research flags: [3]=T2 (ser9200), [4]=T3 (ser9300), [5]=T4 (ser9400)
    local t = brain.MNB_TechUnlocked
    if not t then return 1 end
    if t[5] then return 4 end
    if t[4] then return 3 end
    if t[3] then return 2 end
    return 1
end

local function SkufDistToSegment(px, pz, ax, az, bx, bz)
    local function d2(x1, z1, x2, z2)
        local ddx = x1 - x2
        local ddz = z1 - z2
        return math.sqrt(ddx * ddx + ddz * ddz)
    end
    local dx = bx - ax
    local dz = bz - az
    local len2 = dx * dx + dz * dz
    if len2 <= 0 then
        return d2(px, pz, ax, az)
    end
    local t = ((px - ax) * dx + (pz - az) * dz) / len2
    if t < 0 then t = 0 end
    if t > 1 then t = 1 end
    return d2(px, pz, ax + t * dx, az + t * dz)
end

-- Issue build orders tiling storages along all four sides of the target:
-- a 2x2 skirt (mex) gets 4 storages, a 6x6 skirt (hydro) gets 3 per side = 12
local function SkufDoSurround(target, engs)
    if not target or target.Dead or table.getn(engs) == 0 then return end
    local bp = target:GetBlueprint()
    local pos = target:GetPosition()
    local faction = string.lower(bp.General.FactionName or 'uef')
    local prefix = SkufVanillaPrefix[faction] or 'ueb'
    -- NOTE: IsInCategory does NOT exist on sim units (UI-only method) -> use EntityCategoryContains
    local storeBp = prefix .. (EntityCategoryContains(categories.MASSEXTRACTION, target) and '1106' or '1105')
    local sSkirt = 2 -- storage skirt
    local skirtX = bp.Physics.SkirtSizeX or 2
    local skirtZ = bp.Physics.SkirtSizeZ or 2
    local offX = skirtX / 2 + sSkirt / 2
    local offZ = skirtZ / 2 + sSkirt / 2
    local function sideOffsets(n)
        local list = {}
        for i = 0, n - 1 do
            table.insert(list, (i - (n - 1) / 2) * sSkirt)
        end
        return list
    end
    local xs = sideOffsets(math.max(1, skirtX / sSkirt))
    local zs = sideOffsets(math.max(1, skirtZ / sSkirt))
    -- spots are FULL {x,y,z} vectors: y from the target's ground position
    local spots = {}
    for _, d in zs do
        table.insert(spots, { pos[1] - offX, pos[2], pos[3] + d })
        table.insert(spots, { pos[1] + offX, pos[2], pos[3] + d })
    end
    for _, d in xs do
        table.insert(spots, { pos[1] + d, pos[2], pos[3] - offZ })
        table.insert(spots, { pos[1] + d, pos[2], pos[3] + offZ })
    end
    local brain = GetArmyBrain(target:GetArmy())
    -- occupancy check is done lua-side (distance to own structures): GetUnitsAroundPoint
    -- kept throwing "attempt to get as number a nil value" from the C side here
    local structs = brain:GetListOfUnits(categories.STRUCTURE, false, true) or {}
    local issued = 0
    for _, spot in spots do
        local blocked = false
        for _, s in structs do
            if not s.Dead then
                local sp = s:GetPosition()
                if sp then
                    -- plain math instead of VDist2 (its arg format is inconsistent here)
                    local dx = sp[1] - spot[1]
                    local dz = sp[3] - spot[3]
                    if dx * dx + dz * dz < 4 then
                        blocked = true
                        break
                    end
                end
            end
        end
        if not blocked then
            IssueBuildMobile(engs, spot, storeBp, {})
            issued = issued + 1
        end
    end
    LOG('SKUF surround ' .. (bp.BlueprintId or '?') .. ' engs=' .. table.getn(engs) .. ' issued=' .. issued .. ' bp=' .. storeBp)
end

local function SkufUnitsFromIds(ids)
    local out = {}
    local list = ids or {}
    for _, id in list do
        local u = GetEntityById(id)
        if u and not u.Dead and not EntityCategoryContains(categories.STRUCTURE, u) then
            table.insert(out, u)
        end
    end
    return out
end

Callbacks.SkufSurround = function(data)
    local target = GetEntityById(data.unit)
    if not target or target.Dead then return end
    SkufDoSurround(target, SkufUnitsFromIds(data.units))
end

Callbacks.SkufCorridorReclaim = function(data)
    local engs = SkufUnitsFromIds(data.units)
    if table.getn(engs) == 0 then return end
    local a = data.a
    local b = data.b
    if not a or not b then return end
    -- corridor half-width = best build/reclaim reach of the group, plus a small pad
    local r = 0
    for _, u in engs do
        local eBp = u:GetBlueprint().Economy
        local br = eBp.BuildRadius or eBp.MaxBuildDistance or 6
        if br > r then r = br end
    end
    r = r + 2
    local props = GetReclaimablesInRect(math.min(a[1], b[1]) - r, math.min(a[2], b[2]) - r, math.max(a[1], b[1]) + r, math.max(a[2], b[2]) + r) or {}
    local issued = 0
    for _, p in props do
        if SkufIsProp(p) then
            pcall(function()
                local pp = p:GetPosition()
                if pp and SkufDistToSegment(pp[1], pp[3], a[1], a[2], b[1], b[2]) <= r then
                    IssueReclaim(engs, p)
                    issued = issued + 1
                end
            end)
        end
    end
    LOG('SKUF corridor r=' .. r .. ' props=' .. table.getn(props) .. ' issued=' .. issued)
end

local function SkufWatcherThread(brain)
    -- mex auto-upgrade (user's design, 2026-08-14):
    --   * when a tier is researched, upgrade ALL mexes below it AT ONCE;
    --   * stores running dry -> PAUSE everyone except one (SetPaused keeps the order
    --     AND its progress; NOTHING is ever canceled -> no mass is ever thrown away);
    --   * stores recovered -> unpause one per pass.
    -- IsUnitState('Upgrading') reports FALSE for mexes that ARE upgrading (log-proven),
    -- so outstanding orders are tracked OURSELVES; a flag clears only when the mex
    -- reaches the target tier or dies. Manual player cancels are respected.
    local issued = {}    -- eid -> true while an upgrade order we placed is outstanding
    local pausedUpg = {} -- eid -> true while WE paused its upgrade
    local ticks = 0
    while true do
        WaitSeconds(5)
        if brain:IsDefeated() then break end
        ticks = ticks + 1
        -- pcall keeps the watcher alive even if one pass hits a bad unit
        local ok, err = pcall(function()
            local target = SkufTargetTier(brain)
            if math.mod(ticks, 12) == 1 then
                LOG('SKUF watch tick=' .. ticks .. ' targetTier=' .. target .. ' researchFlags=' .. tostring(brain.MNB_TechUnlocked ~= nil))
            end
            if target >= 2 then
                -- Pause decision is based on STORAGE, not the +/- rate (user, 2026-08-14):
                -- a slightly negative trend with full stores is NOT a problem. Pause only
                -- when the stored mass is about to run dry (UIMassFabManager-style).
                local netMass = brain:GetEconomyTrend('MASS') or 0
                local storedMass = brain:GetEconomyStored('MASS') or 0
                local storedRatio = brain:GetEconomyStoredRatio('MASS') or 0
                local starving = netMass < 0 and (storedMass + netMass * 20 < 0 or storedRatio < 0.05)
                local mexes = brain:GetListOfUnits(categories.MASSEXTRACTION, false, true)
                local pending = {}
                for _, mex in mexes do
                    if not mex.Dead then
                        local eid = mex:GetEntityId()
                        local tier = SkufMexTier(mex:GetBlueprint().BlueprintId or '')
                        if tier and tier < target then
                            table.insert(pending, { mex = mex, eid = eid, tier = tier })
                        else
                            -- reached the target tier (or unrecognized): forget it entirely
                            issued[eid] = nil
                            pausedUpg[eid] = nil
                        end
                    end
                end
                -- drop tracking of units that died
                for eid in issued do
                    local u = GetEntityById(eid)
                    if not u or u.Dead then
                        issued[eid] = nil
                        pausedUpg[eid] = nil
                    end
                end

                if starving then
                    -- pause everyone except the single most-progressed one
                    local running = {}
                    for _, p in pending do
                        if issued[p.eid] and not pausedUpg[p.eid] then
                            table.insert(running, p)
                        end
                    end
                    table.sort(running, function(a, b)
                        return (a.mex:GetWorkProgress() or 0) > (b.mex:GetWorkProgress() or 0)
                    end)
                    for i = 2, table.getn(running) do
                        local p = running[i]
                        if not p.mex:IsPaused() then
                            p.mex:SetPaused(true)
                            LOG('SKUF pause upgrade (mass ' .. string.format('%.1f', netMass) .. ')')
                        end
                        pausedUpg[p.eid] = true
                    end
                else
                    -- stores are fine: unpause ONE held mex per pass (5s)
                    local released = 0
                    for _, p in pending do
                        if pausedUpg[p.eid] and released == 0 then
                            if p.mex:IsPaused() then
                                p.mex:SetPaused(false)
                                LOG('SKUF resume upgrade (mass +' .. string.format('%.1f', netMass) .. ')')
                            end
                            pausedUpg[p.eid] = nil
                            released = released + 1
                        end
                    end
                    -- issue upgrades: everything not held and not already issued goes at once
                    for _, p in pending do
                        local eid = p.eid
                        if not pausedUpg[eid] and not issued[eid] then
                            local nextId = SkufNextMexId(p.mex)
                            if nextId then
                                IssueUpgrade({ p.mex }, nextId)
                                issued[eid] = true
                                LOG('SKUF upgrade mex tier ' .. p.tier .. ' -> ' .. nextId)
                            end
                        end
                    end
                end
            end
        end)
        if not ok then
            LOG('SKUF watcher error: ' .. tostring(err))
        end
    end
end

-- === auto-reclaim engineer (user's design, 2026-08-14) ===
-- Reclaim order + click on EMPTY ground -> the click point is the engineer's
-- reference point: it FIRST drives to that point, THEN eats everything by the Reclaim
-- Turret (M&B Z?B0205) rules. Station-to-station: everything within reach of where it
-- stands is queued at once; the nearest target beyond reach means a one-order hop to a
-- new spot. Clean circle around the reference point -> radius doubles (cleans outward).
-- Each target is CLAIMED by one engineer, so several auto-engineers never share a list.
local SKUF_ZONE_MIN = 20 -- starting circle around the click point: random in [MIN, MAX]
local SKUF_ZONE_MAXR = 40
local SKUF_ZONE_MAX = 640  -- give up when even this half-size circle is empty
local SKUF_ZONE_BATCH = 12 -- max targets queued at one spot (safety cap only)

local skufAutoEngs = {} -- eid -> { anchor={x,z}, radius, expect } while in auto-reclaim mode
local skufReclaimCandidates = {} -- eid -> click pos until the thread confirms it was NOT a rock click
local skufClaimed = {} -- target entity -> captor eid (one target belongs to one engineer)

-- TRUE props only (rocks and wrecks). GetReclaimablesInRect ALSO returns LIVE units
-- (own units are reclaimable in FA!), which made auto-engineers eat each other and the
-- hidden factory maintenance units -> skip anything that is a unit.
local function SkufIsProp(p)
    if p == nil then return false end
    local ok, isUnit = pcall(IsUnit, p)
    return ok and not isUnit
end

-- Reclaim Turret (M&B Z?B0205) target filter: props are always fair game;
-- a unit only if it is an ENEMY one (not allied, not capturable) -- this is what
-- keeps the reclaimer from eating friendly units. Everything gated by mass storage.
local function SkufTurretWantsTarget(reclaimerArmy, target, brain)
    if (brain:GetEconomyStoredRatio('MASS') or 0) >= 0.95 then return false end
    if SkufIsProp(target) then return true end
    local ok, isUnit = pcall(IsUnit, target)
    if not ok or not isUnit then return false end
    local okA, isAlly = pcall(IsAlly, reclaimerArmy, target:GetArmy())
    local okC, capturable = pcall(function() return target:IsCapturable() end)
    return okA and okC and not isAlly and not capturable
end

local function SkufReleaseClaims(eid)
    for p, owner in skufClaimed do
        if owner == eid then
            skufClaimed[p] = nil
        end
    end
end

Callbacks.SkufReclaimClick = function(data)
    local engs = {}
    for _, u in SkufUnitsFromIds(data.units or {}) do
        if EntityCategoryContains(categories.ENGINEER, u) then
            table.insert(engs, u)
        end
    end
    if not data.pos then return end
    if table.getn(engs) == 0 then
        LOG('SKUF reclaim click: no engineers in the click')
        return
    end
    -- "rock click" vs "void click" is decided later by the auto thread: a click on a
    -- reclaimable makes the engine append a Reclaim order; empty ground appends nothing.
    -- Our callback runs BEFORE the engine has processed the click, so the candidate is
    -- parked and re-checked a second later when the engine's order is visible.
    for _, u in engs do
        skufReclaimCandidates[u:GetEntityId()] = { data.pos[1], data.pos[2], data.pos[3] }
    end
end

-- scan the current circle around the anchor, claim and queue the nearest unclaimed
-- targets (turret rules). Doubles the radius while the circle is clean. Returns the
-- number of orders queued (0 = zone given up, auto mode turned off).
local function SkufScanAndQueue(eng, eid, entry)
    -- queue empty: everything we claimed is eaten or gone -> free the claims first
    SkufReleaseClaims(eid)
    local brain = GetArmyBrain(eng:GetArmy())
    local a = entry.anchor
    -- nearest is measured from the engineer's CURRENT spot, not from the anchor:
    -- that way it finishes the cluster it is standing in before going anywhere
    local ep = eng:GetPosition() or { a[1], 0, a[2] }
    local scored = {}
    while table.getn(scored) == 0 and entry.radius <= SKUF_ZONE_MAX do
        local props = GetReclaimablesInRect(a[1] - entry.radius, a[2] - entry.radius, a[1] + entry.radius, a[2] + entry.radius) or {}
        for _, p in props do
            if p and not skufClaimed[p] then
                local okT, want = pcall(SkufTurretWantsTarget, eng:GetArmy(), p, brain)
                local okP, pp = pcall(function() return p:GetPosition() end)
                if okT and want and okP and pp then
                    local dx = pp[1] - ep[1]
                    local dz = pp[3] - ep[3]
                    table.insert(scored, { p = p, d = dx * dx + dz * dz })
                end
            end
        end
        if table.getn(scored) == 0 then
            entry.radius = entry.radius * 2
            LOG('SKUF auto-reclaim eng=' .. eid .. ' circle clean, radius now ' .. entry.radius)
        end
    end
    table.sort(scored, function(x, y) return x.d < y.d end)
    -- station-to-station (user, 2026-08-14): everything within REACH of where the
    -- engineer stands is queued at once (it eats it all without moving); if even the
    -- nearest target is out of reach, only that ONE is queued -> the engineer drives
    -- to the new spot, and on arrival everything there is within reach again.
    local econ = eng:GetBlueprint().Economy
    local reach = (econ.BuildRadius or econ.MaxBuildDistance or 6) + 2
    local reach2 = reach * reach
    local issued = 0
    for i = 1, math.min(SKUF_ZONE_BATCH, table.getn(scored)) do
        local s = scored[i]
        if i > 1 and s.d > reach2 then break end
        skufClaimed[s.p] = eid
        IssueReclaim({ eng }, s.p)
        issued = issued + 1
    end
    if issued == 0 then
        skufAutoEngs[eid] = nil
        LOG('SKUF auto-reclaim off: nothing left')
    else
        entry.expect = issued
        LOG('SKUF auto-reclaim queue eng=' .. eid .. ' targets=' .. issued .. ' radius=' .. entry.radius)
    end
    return issued
end

-- length of the unit's command queue (the only reliably readable thing about sim
-- commands: their .type field is UI-only and is nil sim-side)
local function SkufQueueCount(unit)
    local ok, q = pcall(function() return unit:GetCommandQueue() end)
    if ok and q then return table.getn(q) end
    return 0
end

local function SkufAutoReclaimThread()
    while true do
        -- 1s poll: targets are queued in small local batches, a 3s gap between rocks
        -- would leave the engineer standing around
        WaitSeconds(1)
        local ok, err = pcall(function()
            -- confirm pending click candidates: engine ordered a Reclaim by itself =
            -- the player clicked a rock (normal single reclaim, we stay out);
            -- no Reclaim in the queue = the click hit empty ground -> auto mode ON,
            -- the click point becomes the engineer's anchor/zone center
            for eid, cpos in skufReclaimCandidates do
                skufReclaimCandidates[eid] = nil
                local u = GetEntityById(eid)
                if u and not u.Dead then
                    if SkufQueueCount(u) > 0 then
                        LOG('SKUF reclaim click was on a rock: staying out')
                    elseif not skufAutoEngs[eid] then
                        skufAutoEngs[eid] = { anchor = { cpos[1], cpos[3] }, radius = math.random(SKUF_ZONE_MIN, SKUF_ZONE_MAXR), expect = 1, justArmed = true }
                        -- go to the click point FIRST; scavenging starts from there
                        IssueMove({ u }, cpos)
                        LOG('SKUF auto-reclaim ON eng=' .. eid .. ' anchor=' .. math.floor(cpos[1]) .. ',' .. math.floor(cpos[3]))
                    end
                end
            end
            for eid, entry in skufAutoEngs do
                local eng = GetEntityById(eid)
                if not eng or eng.Dead then
                    SkufReleaseClaims(eid)
                    skufAutoEngs[eid] = nil
                elseif entry.justArmed then
                    -- armed this very pass: skip one round so the engine registers the
                    -- move order we just issued before we start counting the queue
                    entry.justArmed = nil
                else
                    -- everything is tracked by the command queue LENGTH (sim commands
                    -- carry no readable type, but the count is reliable):
                    --   queue longer than what we issued = the player added an order;
                    --   queue drained = trip over / batch finished -> queue the next one;
                    --   otherwise = ours still being worked through, just wait.
                    local n = SkufQueueCount(eng)
                    if n > (entry.expect or 0) then
                        SkufReleaseClaims(eid)
                        skufAutoEngs[eid] = nil
                        LOG('SKUF auto-reclaim off: new order eng=' .. eid)
                    elseif n == 0 then
                        SkufScanAndQueue(eng, eid, entry)
                    else
                        entry.expect = n
                    end
                end
            end
        end)
        if not ok then
            LOG('SKUF auto-reclaim error: ' .. tostring(err))
        end
    end
end

Callbacks.SkufInit = function(data)
    -- data.army comes from the player's UI (their focus army). NEVER use GetFocusArmy
    -- here: in a networked game it returns a DIFFERENT army on every client, and the
    -- watcher must run for the same army everywhere or the game desyncs.
    if not data or not data.army then return end
    local brain = GetArmyBrain(data.army)
    LOG('SKUF init called, army=' .. tostring(data.army))
    if not brain or brain.SkufWatcherStarted then return end
    brain.SkufWatcherStarted = true
    ForkThread(SkufWatcherThread, brain)
    ForkThread(SkufAutoReclaimThread)
    LOG('SKUF watcher started')
end

end
