-- mods/M&B/lua/AI/MNBBattlegroups.lua
-- M&B multi-group attack doctrine.
--   Strike group (~30 tanks) -> enemy main base (sized wave, not a trickle).
--   Raid groups (~10 tanks)   -> specific enemy mass extractors (multiple, eco pressure).
--   Adaptive sizing: if a group is wiped it escalates x2 next attempt (caps apply); reset to base on success.
--   Experimentals attach to the strike group (escorted) instead of lone-rushing.
-- Per-brain periodic manager. Assigned units carry oUnit[refiMNBBGroup] so M28's per-zone
-- combat logic (M28Land.lua collection loop) skips them (mirrors the raider split pattern).
-- M&B-gated (IsMBModActive). All numbers tunable below.

local M28Utilities = import('/mods/M&B/lua/AI/M28Utilities.lua')
local M28UnitInfo = import('/mods/M&B/lua/AI/M28UnitInfo.lua')
local M28Orders = import('/mods/M&B/lua/AI/M28Orders.lua')
local M28Map = import('/mods/M&B/lua/AI/M28Map.lua')

-- ===== Tunables =====
local TICK = 5              -- seconds between manager ticks
local STARTUP_WAIT = 12     -- seconds to wait before first tick (let team/map data populate)
local RAID_BASE = 10        -- base raid party size
local STRIKE_BASE = 30      -- base strike group size
local ESCALATE_X = 2        -- multiply required size by this on failure
local RAID_CAP = 80         -- max raid party size
local STRIKE_CAP = 120      -- max strike group size
local FAIL_GRACE = 25       -- min seconds after launch before a wipe counts as failure
local STRIKE_LONG = 90      -- strike that survives longer than this is treated as success (reset)
local RAID_RADIUS = 220     -- radius around enemy base to search for raidable mexes
local MIN_RESERVE = 16      -- min spare land-combat units to leave unassigned (defense/M28)
local MAX_RAID_GROUPS = 4   -- max concurrent raid parties per brain
local ROSTER_DEAD_RATIO = 0.3  -- alive ratio below this => group considered wiped
local EXP_STRIKE_ESCORT_MIN = 10  -- if an exp is waiting, form a strike with at least this many tanks
local bDebug = true

-- Per-unit flag. Also referenced by M28Land.lua skip; keep the key string in sync.
refiMNBBGroup = 'MNBBGroup'

local function DBG(sMsg)
    if bDebug then LOG('M&B BG: ' .. sMsg) end
end

local function CountAlive(tRoster)
    local iAlive = 0
    if tRoster then
        for i, oUnit in tRoster do
            if oUnit and not(oUnit.Dead) and M28UnitInfo.IsUnitValid(oUnit) then
                iAlive = iAlive + 1
            end
        end
    end
    return iAlive
end

local function FreeRoster(tRoster)
    if not tRoster then return end
    for i, oUnit in tRoster do
        if oUnit and not(oUnit.Dead) then
            oUnit[refiMNBBGroup] = nil
        end
    end
end

local function LaunchedRosterSize(tG)
    return tG.launchedCount or (tG.roster and table.getn(tG.roster)) or 1
end

-- Find the enemy base position. Cached on the brain. Scans team zones for reftClosestEnemyBase.
local function GetEnemyBasePos(aiBrain, iTeam)
    if aiBrain.MNBEnemyBasePos then return aiBrain.MNBEnemyBasePos end
    if not(M28Map.tAllPlateaus) then return nil end
    for iPlateau, tPlateau in M28Map.tAllPlateaus do
        local tLandZones = tPlateau and tPlateau[M28Map.subrefPlateauLandZones]
        if tLandZones then
            for iLZ, tLZData in tLandZones do
                local tLZTeamData = tLZData and tLZData[M28Map.subrefLZTeamData] and tLZData[M28Map.subrefLZTeamData][iTeam]
                if tLZTeamData and tLZTeamData[M28Map.reftClosestEnemyBase] then
                    aiBrain.MNBEnemyBasePos = tLZTeamData[M28Map.reftClosestEnemyBase]
                    return aiBrain.MNBEnemyBasePos
                end
            end
        end
    end
    return nil
end

-- Spare (unassigned, complete, valid) land-combat units owned by the brain. Experimentals excluded (handled separately).
local function GetSpareCombatUnits(aiBrain)
    local tOut = {}
    local tUnits = aiBrain:GetListOfUnits(M28UnitInfo.refCategoryLandCombat, false, false)
    if tUnits then
        for i, oUnit in tUnits do
            if oUnit and not(oUnit.Dead) and M28UnitInfo.IsUnitValid(oUnit)
                    and oUnit[refiMNBBGroup] == nil
                    and oUnit:GetFractionComplete() >= 1
                    and not(EntityCategoryContains(M28UnitInfo.refCategoryLandExperimental, oUnit.UnitId)) then
                table.insert(tOut, oUnit)
            end
        end
    end
    return tOut
end

-- Idle experimentals flagged 'pending-strike' (waiting for a strike group to escort them).
local function GetPendingStrikeExps(aiBrain)
    local tOut = {}
    local tUnits = aiBrain:GetListOfUnits(M28UnitInfo.refCategoryLandExperimental, false, false)
    if tUnits then
        for i, oUnit in tUnits do
            if oUnit and not(oUnit.Dead) and M28UnitInfo.IsUnitValid(oUnit)
                    and oUnit[refiMNBBGroup] == 'pending-strike' then
                table.insert(tOut, oUnit)
            end
        end
    end
    return tOut
end

-- Enemy mexes near the enemy base (intel-limited) not already under raid.
local function GetRaidableMexes(aiBrain, tEnemyBasePos, tGroups)
    if not tEnemyBasePos then return {} end
    local tSeen = {}
    for i, tG in tGroups do
        if tG.role == 'raid' and tG.targetUnit and not(tG.targetUnit.Dead) then
            tSeen[tG.targetUnit.EntityId] = true
        end
    end
    local tOut = {}
    local tMexes = aiBrain:GetUnitsAroundPoint(M28UnitInfo.refCategoryMex, tEnemyBasePos, RAID_RADIUS, 'Enemy')
    if tMexes then
        for i, oMex in tMexes do
            if oMex and not(oMex.Dead) and not(tSeen[oMex.EntityId]) then
                table.insert(tOut, oMex)
            end
        end
    end
    return tOut
end

local function NumRaidGroups(tGroups)
    local iN = 0
    for i, tG in tGroups do
        if tG.role == 'raid' then iN = iN + 1 end
    end
    return iN
end

local function HasActiveStrike(tGroups)
    for i, tG in tGroups do
        if tG.role == 'strike' then return true end
    end
    return false
end

-- Resolve launched groups: detect success/failure, escalate or reset required sizes, free rosters.
local function ResolveGroups(aiBrain, tGroups)
    local iNow = GetGameTimeSeconds()
    local iKeep = {}
    for i, tG in tGroups do
        local bDrop = false
        if tG.state == 'launched' and tG.launchTime and (iNow - tG.launchTime) > FAIL_GRACE then
            local iAlive = CountAlive(tG.roster)
            local iLaunched = LaunchedRosterSize(tG)
            local bWiped = (iAlive < math.max(1, math.floor(iLaunched * ROSTER_DEAD_RATIO)))
            if tG.role == 'raid' then
                local oMex = tG.targetUnit
                if (not oMex) or oMex.Dead or not(M28UnitInfo.IsUnitValid(oMex)) then
                    -- success: mex destroyed
                    aiBrain.iMNBRaidRequired = RAID_BASE
                    DBG('raid SUCCESS -> reset raid size to ' .. RAID_BASE)
                    bDrop = true
                elseif bWiped then
                    -- failure: double raid size (capped)
                    aiBrain.iMNBRaidRequired = math.min(RAID_CAP, (aiBrain.iMNBRaidRequired or RAID_BASE) * ESCALATE_X)
                    DBG('raid FAILED (wiped) -> raid size now ' .. (aiBrain.iMNBRaidRequired or RAID_BASE))
                    bDrop = true
                end
            elseif tG.role == 'strike' then
                if bWiped then
                    aiBrain.iMNBStrikeRequired = math.min(STRIKE_CAP, (aiBrain.iMNBStrikeRequired or STRIKE_BASE) * ESCALATE_X)
                    DBG('strike FAILED (wiped) -> strike size now ' .. (aiBrain.iMNBStrikeRequired or STRIKE_BASE))
                    bDrop = true
                elseif (iNow - tG.launchTime) > STRIKE_LONG then
                    -- survived a long engagement: treat as success, reset
                    aiBrain.iMNBStrikeRequired = STRIKE_BASE
                    DBG('strike survived > ' .. STRIKE_LONG .. 's -> reset strike size to ' .. STRIKE_BASE)
                    bDrop = true
                end
            end
        end
        if bDrop then
            FreeRoster(tG.roster)
        else
            table.insert(iKeep, tG)
        end
    end
    -- replace group list with survivors (also drop stale groups whose roster is fully dead/nil)
    aiBrain.tMNBBattlegroups = iKeep
end

-- Pick N units off the front of tPool (mutating tPool) and return them.
local function TakeUnits(tPool, iN)
    local tTaken = {}
    while table.getn(tTaken) < iN and table.getn(tPool) > 0 do
        local oUnit = table.remove(tPool, 1)
        if oUnit then table.insert(tTaken, oUnit) end
    end
    return tTaken
end

-- Form new strike / raid groups from spare units (respecting the defense reserve).
local function FormGroups(aiBrain, iTeam, tGroups, tSpare, tEnemyBasePos)
    if not tEnemyBasePos then return end
    local iRaidReq = aiBrain.iMNBRaidRequired or RAID_BASE
    local iStrikeReq = aiBrain.iMNBStrikeRequired or STRIKE_BASE

    -- STRIKE: form if none active and (enough spares, OR an exp is waiting with a smaller escort)
    if not HasActiveStrike(tGroups) then
        local tPendingExps = GetPendingStrikeExps(aiBrain)
        local bExpWaiting = (table.getn(tPendingExps) > 0)
        local iNeed = iStrikeReq
        if bExpWaiting and iNeed > EXP_STRIKE_ESCORT_MIN then iNeed = EXP_STRIKE_ESCORT_MIN end
        if (table.getn(tSpare) - iNeed) >= MIN_RESERVE then
            local tRoster = TakeUnits(tSpare, iNeed)
            -- attach waiting experimentals to the wave
            for i, oExp in tPendingExps do
                table.insert(tRoster, oExp)
            end
            if table.getn(tRoster) > 0 then
                local tG = { role = 'strike', targetPos = tEnemyBasePos, roster = tRoster, launchedCount = table.getn(tRoster), launchTime = GetGameTimeSeconds(), state = 'launched' }
                for i, oUnit in tRoster do
                    oUnit[refiMNBBGroup] = tG
                    M28Orders.IssueTrackedAggressiveMove(oUnit, tEnemyBasePos, 6, false, 'MNBStrike')
                end
                table.insert(tGroups, tG)
                DBG('strike group launched: ' .. table.getn(tRoster) .. ' units -> enemy base')
            end
        end
    end

    -- RAIDS: form parties for unraided enemy mexes while reserve allows
    local tMexes = GetRaidableMexes(aiBrain, tEnemyBasePos, tGroups)
    for i, oMex in tMexes do
        if NumRaidGroups(tGroups) >= MAX_RAID_GROUPS then break end
        if (table.getn(tSpare) - iRaidReq) < MIN_RESERVE then break end
        local tRoster = TakeUnits(tSpare, iRaidReq)
        if table.getn(tRoster) < iRaidReq then
            -- not enough this tick; put them back and stop
            for j, oU in tRoster do table.insert(tSpare, oU) end
            break
        end
        local tG = { role = 'raid', targetUnit = oMex, targetPos = oMex:GetPosition(), roster = tRoster, launchedCount = table.getn(tRoster), launchTime = GetGameTimeSeconds(), state = 'launched' }
        for j, oUnit in tRoster do
            oUnit[refiMNBBGroup] = tG
            M28Orders.IssueTrackedAttack(oUnit, oMex, false, 'MNBRaid')
        end
        table.insert(tGroups, tG)
        DBG('raid party launched: ' .. table.getn(tRoster) .. ' units -> mex ' .. (oMex.UnitId or '?'))
    end
end

-- Called from M28Land.lua (~7226) to route an idle experimental into a strike group instead of lone-attacking.
function AttachExperimentalToStrikeGroup(oUnit, iTeam)
    if not oUnit or oUnit.Dead then return end
    local aiBrain = oUnit:GetAIBrain()
    if not aiBrain then return end
    if not aiBrain.tMNBBattlegroups then aiBrain.tMNBBattlegroups = {} end
    -- already assigned?
    if oUnit[refiMNBBGroup] ~= nil then return end
    -- find an active strike group to join
    local tStrike = nil
    for i, tG in aiBrain.tMNBBattlegroups do
        if tG.role == 'strike' then tStrike = tG break end
    end
    if tStrike and tStrike.targetPos then
        oUnit[refiMNBBGroup] = tStrike
        table.insert(tStrike.roster, oUnit)
        tStrike.launchedCount = (tStrike.launchedCount or 0) + 1
        M28Orders.IssueTrackedAggressiveMove(oUnit, tStrike.targetPos, 6, false, 'MNBExpStrike')
        DBG('experimental ' .. (oUnit.UnitId or '?') .. ' attached to active strike group')
    else
        -- no strike group yet: hold the exp so it doesn't lone-rush (manager will escort it when a strike forms)
        oUnit[refiMNBBGroup] = 'pending-strike'
        DBG('experimental ' .. (oUnit.UnitId or '?') .. ' held for next strike group')
    end
end

-- Claim idle experimentals (not yet M&B-managed) into the strike system so they don't lone-rush.
local function ClaimIdleExperimentals(aiBrain)
    local tUnits = aiBrain:GetListOfUnits(M28UnitInfo.refCategoryLandExperimental, false, false)
    if not tUnits then return end
    for i, oExp in tUnits do
        if oExp and not(oExp.Dead) and M28UnitInfo.IsUnitValid(oExp)
                and oExp[refiMNBBGroup] == nil
                and oExp:GetFractionComplete() >= 1 then
            AttachExperimentalToStrikeGroup(oExp, aiBrain.M28Team)
        end
    end
end

local function TickSafe(aiBrain)
    local iTeam = aiBrain.M28Team
    if not iTeam then return end
    if not aiBrain.tMNBBattlegroups then aiBrain.tMNBBattlegroups = {} end
    if not aiBrain.iMNBStrikeRequired then aiBrain.iMNBStrikeRequired = STRIKE_BASE end
    if not aiBrain.iMNBRaidRequired then aiBrain.iMNBRaidRequired = RAID_BASE end

    ResolveGroups(aiBrain, aiBrain.tMNBBattlegroups)
    local tGroups = aiBrain.tMNBBattlegroups

    ClaimIdleExperimentals(aiBrain)
    local tEnemyBasePos = GetEnemyBasePos(aiBrain, iTeam)
    local tSpare = GetSpareCombatUnits(aiBrain)
    FormGroups(aiBrain, iTeam, tGroups, tSpare, tEnemyBasePos)
end

-- Thread entry (forked from aibrain.lua OnCreateAI).
function ManageBattlegroups(aiBrain)
    WaitSeconds(STARTUP_WAIT)
    while aiBrain and not(aiBrain.Dead) do
        if M28Utilities.IsMBModActive() then
            local bOk, sErr = pcall(TickSafe, aiBrain)
            if not bOk then
                DBG('tick error: ' .. tostring(sErr))
            end
        end
        WaitSeconds(TICK)
    end
end
