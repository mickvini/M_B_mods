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
local M28Team = import('/mods/M&B/lua/AI/M28Team.lua')

--M&B: true field-built experimentals are NEEDMOBILEBUILD (NOT categories.EXPERIMENTAL, which is M&B's T4 factory units).
--Using refCategoryLandExperimental (EXPERIMENTAL) wrongly treats T4 factory tanks as experimentals -> excludes them
--from the spare pool and flags them pending-strike -> no escorts for strikes -> army piles at base. This separates them.
local refCategoryMNBFieldExp = categories.NEEDMOBILEBUILD * categories.MOBILE * categories.LAND
--M&B: T4 factory-built indirect-fire artillery (e.g. SRL0311 Cybran rocket artillery). It slips through M28's
--combat categories (indirect only counts as T1 in refCategoryLandCombat; and it's subtracted from
--refCategoryLandExperimental), so the bot builds it but only the REACTIVE M28 indirect logic touches it -> it
--idles on the rear base instead of marching with the army. Adding it to the strike spare pool marches it to the
--front; being slow + long-range it naturally trails behind the main force, as artillery should.
local refCategoryMNBT4Artillery = categories.EXPERIMENTAL * categories.INDIRECTFIRE * categories.MOBILE * categories.LAND - categories.DIRECTFIRE

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
local MAX_PENDING_EXPS = 5  -- cap experimentals held 'pending-strike' so they dont ALL pile at base if no strike forms (e.g. bot has 0 tanks)
local RIFT_STRIKE_SIZE = 15  --M&B: rift-gate (BSB2402) free units are ~0 mass, so M28 undervalues their threat and leaves them idle at the gate. Once this many rift bots gather, send them as their own wave to the enemy base (ignoring the defense reserve - they're free).
local ARTILLERY_STRIKE_MIN = 3  --M&B: T4 factory artillery (SRL0311 etc.) gets its OWN wave to the front once this many gather, separate from the 30-slot strike (which left spare nearly empty -> arty piled on the base). Slow + long-range, so it trails behind the main force.
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

-- Mark an enemy base (by rounded position key) as defeated by this brain so it isnt re-targeted.
local function MarkBaseDefeated(aiBrain, tPos)
    if not tPos then return end
    if not aiBrain.tMNBDefeatedBases then aiBrain.tMNBDefeatedBases = {} end
    aiBrain.tMNBDefeatedBases[(math.floor(tPos[1] or 0)) .. '_' .. (math.floor(tPos[3] or 0))] = true
end

-- Distinct enemy base start-positions known to the team (deduped by rounded position).
local function GetDistinctEnemyBases(iTeam)
    local tDistinct = {}
    local tSeen = {}
    if M28Map.tAllPlateaus then
        for iPlateau, tPlateau in M28Map.tAllPlateaus do
            local tLandZones = tPlateau and tPlateau[M28Map.subrefPlateauLandZones]
            if tLandZones then
                for iLZ, tLZData in tLandZones do
                    local tLZTeamData = tLZData and tLZData[M28Map.subrefLZTeamData] and tLZData[M28Map.subrefLZTeamData][iTeam]
                    local tPos = tLZTeamData and tLZTeamData[M28Map.reftClosestEnemyBase]
                    if tPos then
                        local sKey = (math.floor(tPos[1] or 0)) .. '_' .. (math.floor(tPos[3] or 0))
                        if not tSeen[sKey] then tSeen[sKey] = true; table.insert(tDistinct, tPos) end
                    end
                end
            end
        end
    end
    return tDistinct
end

-- Team-coordinated target SPLIT: each active M28 brain gets a DISTINCT enemy base (round-robin by brain
-- order), skipping bases THIS brain has already cleared. Recomputed each call (no stale cache) so a cleared
-- base is dropped immediately and the bot moves to the next opponent. Teammates attack different players
-- instead of both piling on one.
local function GetAssignedEnemyBase(aiBrain, iTeam)
    local tTeamData = M28Team.tTeamData and M28Team.tTeamData[iTeam]
    if not tTeamData then return nil end
    local tDistinct = GetDistinctEnemyBases(iTeam)
    local tDefeated = aiBrain.tMNBDefeatedBases
    local tAvail = {}
    for i, tPos in tDistinct do
        local sKey = (math.floor(tPos[1] or 0)) .. '_' .. (math.floor(tPos[3] or 0))
        if not(tDefeated and tDefeated[sKey]) then table.insert(tAvail, tPos) end
    end
    local iCount = table.getn(tAvail)
    if iCount == 0 then return nil end
    local tBrains = tTeamData[M28Team.subreftoFriendlyActiveM28Brains]
    if not tBrains then return tAvail[1] end
    local iMyArmy = aiBrain:GetArmyIndex()
    local iMyIndex, iTotal = 0, 0
    for iBrain, oBrain in tBrains do
        iTotal = iTotal + 1
        if oBrain:GetArmyIndex() == iMyArmy then iMyIndex = iTotal end
    end
    if iMyIndex == 0 then return tAvail[1] end
    return tAvail[math.mod(iMyIndex - 1, iCount) + 1]
end

-- THIS brain's strike target = its team-assigned (distinct, not-yet-cleared) enemy base, so teammates split
-- opponents. Falls back to the closest enemy base if no assignment is available.
local function GetEnemyBasePos(aiBrain, iTeam)
    local tAssigned = GetAssignedEnemyBase(aiBrain, iTeam)
    if tAssigned then return tAssigned end
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

-- Closest alive enemy ACU to tFromPos (ACU kill = win in M&B). Sourced from M28's team enemy-ACU tracking.
local function GetClosestEnemyACU(iTeam, tFromPos)
    local tTeamData = M28Team.tTeamData and M28Team.tTeamData[iTeam]
    if not tTeamData then return nil end
    local tACUs = tTeamData[M28Team.reftEnemyACUs]
    if not tACUs then return nil end
    local oClosest, iClosestDist = nil, nil
    for i, oACU in tACUs do
        if oACU and not(oACU.Dead) and M28UnitInfo.IsUnitValid(oACU) then
            local iDist = (tFromPos and M28Utilities.GetDistanceBetweenPositions(oACU:GetPosition(), tFromPos)) or 0
            if (not iClosestDist) or (iDist < iClosestDist) then
                iClosestDist = iDist
                oClosest = oACU
            end
        end
    end
    return oClosest
end

-- Spare (unassigned, complete, valid) land-combat units owned by the brain. Experimentals excluded (handled separately).
local function GetSpareCombatUnits(aiBrain)
    local tOut = {}
    --M&B: include T4 factory-built indirect artillery (e.g. SRL0311) so the strike system marches it to the
    --front with the army instead of leaving it idle on the base (it falls outside refCategoryLandCombat).
    local tUnits = aiBrain:GetListOfUnits(M28UnitInfo.refCategoryLandCombat + refCategoryMNBT4Artillery, false, false)
    if tUnits then
        for i, oUnit in tUnits do
            if oUnit and not(oUnit.Dead) and M28UnitInfo.IsUnitValid(oUnit)
                    and oUnit[refiMNBBGroup] == nil
                    and oUnit:GetFractionComplete() >= 1
                    and not(EntityCategoryContains(refCategoryMNBFieldExp, oUnit.UnitId)) then
                table.insert(tOut, oUnit)
            end
        end
    end
    return tOut
end

-- Idle experimentals flagged 'pending-strike' (waiting for a strike group to escort them).
local function GetPendingStrikeExps(aiBrain)
    local tOut = {}
    local tUnits = aiBrain:GetListOfUnits(refCategoryMNBFieldExp, false, false)
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

-- Enemy mexes across ALL enemy bases (intel-limited), deduped, not already under raid, and INTERLEAVED
-- across bases so raid parties spread to different enemies (eco pressure on every player, not piled on one).
local function GetRaidableMexes(aiBrain, iTeam, tGroups)
    local tUnderRaid = {}
    for i, tG in tGroups do
        if tG.role == 'raid' and tG.targetUnit and not(tG.targetUnit.Dead) then
            tUnderRaid[tG.targetUnit.EntityId] = true
        end
    end
    local tSeenMex = {}
    local tBases = GetDistinctEnemyBases(iTeam)
    local tPerBase = {}
    for iBase, tBasePos in tBases do
        local tMexes = aiBrain:GetUnitsAroundPoint(M28UnitInfo.refCategoryMex, tBasePos, RAID_RADIUS, 'Enemy')
        local tFiltered = {}
        if tMexes then
            for i, oMex in tMexes do
                if oMex and not(oMex.Dead) and not(tUnderRaid[oMex.EntityId]) and not(tSeenMex[oMex.EntityId]) then
                    tSeenMex[oMex.EntityId] = true
                    table.insert(tFiltered, oMex)
                end
            end
        end
        if table.getn(tFiltered) > 0 then table.insert(tPerBase, tFiltered) end
    end
    -- round-robin across bases so successive raids hit different enemies
    local tOut = {}
    local bAny = true
    while bAny do
        bAny = false
        for iBase, tMexes in tPerBase do
            if table.getn(tMexes) > 0 then
                table.insert(tOut, table.remove(tMexes, 1))
                bAny = true
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

--M&B: an active artillery wave (role 'artillery') is tracked separately so it doesn't gate the main strike.
local function HasActiveArtillery(tGroups)
    for i, tG in tGroups do
        if tG.role == 'artillery' then return true end
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
            elseif tG.role == 'artillery' then
                --M&B: artillery wave - free its roster once wiped or after a long engagement so the pool can
                --reform and re-march (no escalation size; the whole arty pool is re-sent each cycle).
                if bWiped or (iNow - tG.launchTime) > STRIKE_LONG then
                    DBG('artillery wave resolved (wiped=' .. tostring(bWiped) .. ') -> freeing roster')
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

    --M&B: rift-gate free-army strike. Rift bots (bsl0310/bsl0003, from the Seraphim BSB2402 gate) are nearly
    --mass-free, so M28's mass-based threat rating undervalues them (~0) and leaves them idling at the gate
    --instead of attacking. Pull them out of the spare pool and send them as their OWN wave once enough gather,
    --ignoring the defense reserve (they're free -> throw them all). Below the threshold they stay in spare so the
    --normal strike/raid logic can still use them. (BUILTBYRIFTGATE isnt a registered Lua category, so we identify
    --rift bots by ID; only the LAND rift bots end up in the land-combat spare pool anyway.)
    if M28Utilities.IsMBModActive() then
        local rMNBRiftCat = categories.bsl0310 + categories.bsl0003
        local tRiftPool = {}
        for i = table.getn(tSpare), 1, -1 do
            local oU = tSpare[i]
            if oU and EntityCategoryContains(rMNBRiftCat, oU.UnitId) then
                table.insert(tRiftPool, oU)
                table.remove(tSpare, i)
            end
        end
        if table.getn(tRiftPool) >= RIFT_STRIKE_SIZE then
            local tG = { role = 'strike', targetPos = tEnemyBasePos, basePos = tEnemyBasePos, huntingACU = false, roster = tRiftPool, launchedCount = table.getn(tRiftPool), launchTime = GetGameTimeSeconds(), state = 'launched' }
            for i, oUnit in tRiftPool do
                oUnit[refiMNBBGroup] = tG
                M28Orders.IssueTrackedAggressiveMove(oUnit, tEnemyBasePos, 6, false, 'MNBRiftStrike')
            end
            table.insert(tGroups, tG)
            DBG('rift-gate strike launched: ' .. table.getn(tRiftPool) .. ' free units -> enemy base')
        else
            -- not enough yet; put them back so the normal strike/raid logic can still grab them
            for i, oU in tRiftPool do table.insert(tSpare, oU) end
        end
    end

    --M&B: separate ARTILLERY wave. T4 factory artillery (SRL0311 etc.) sits in the spare pool, but the main
    --strike only takes ~30 mixed units and spare is often nearly empty (directfire T4 already marched via M28),
    --so the arty piled on the base. Give it its OWN wave (role 'artillery' so it doesn't block the main strike
    --gate); march all of it to the front. Being slow + long-range it trails behind the main force, as artillery should.
    if M28Utilities.IsMBModActive() and not HasActiveArtillery(tGroups) then
        local tArtPool = {}
        for i = table.getn(tSpare), 1, -1 do
            local oU = tSpare[i]
            if oU and EntityCategoryContains(refCategoryMNBT4Artillery, oU.UnitId) then
                table.insert(tArtPool, oU)
                table.remove(tSpare, i)
            end
        end
        if table.getn(tArtPool) >= ARTILLERY_STRIKE_MIN then
            local tG = { role = 'artillery', targetPos = tEnemyBasePos, basePos = tEnemyBasePos, huntingACU = false, roster = tArtPool, launchedCount = table.getn(tArtPool), launchTime = GetGameTimeSeconds(), state = 'launched' }
            for i, oUnit in tArtPool do
                oUnit[refiMNBBGroup] = tG
                M28Orders.IssueTrackedAggressiveMove(oUnit, tEnemyBasePos, 6, false, 'MNBArtStrike')
            end
            table.insert(tGroups, tG)
            DBG('T4 artillery strike launched: ' .. table.getn(tArtPool) .. ' units -> enemy base')
        else
            for i, oU in tArtPool do table.insert(tSpare, oU) end
        end
    end

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
                local tG = { role = 'strike', targetPos = tEnemyBasePos, basePos = tEnemyBasePos, huntingACU = false, roster = tRoster, launchedCount = table.getn(tRoster), launchTime = GetGameTimeSeconds(), state = 'launched' }
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
    local tMexes = GetRaidableMexes(aiBrain, iTeam, tGroups)
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
    local tUnits = aiBrain:GetListOfUnits(refCategoryMNBFieldExp, false, false)
    if not tUnits then return end
    -- count experimentals already held pending-strike; cap so excess exps go to M28 (prevent pile-up)
    local iPending = 0
    for i, oExp in tUnits do
        if oExp and not(oExp.Dead) and oExp[refiMNBBGroup] == 'pending-strike' then iPending = iPending + 1 end
    end
    for i, oExp in tUnits do
        if oExp and not(oExp.Dead) and M28UnitInfo.IsUnitValid(oExp)
                and oExp[refiMNBBGroup] == nil
                and oExp:GetFractionComplete() >= 1 then
            if iPending < MAX_PENDING_EXPS then
                AttachExperimentalToStrikeGroup(oExp, aiBrain.M28Team)
                if oExp[refiMNBBGroup] == 'pending-strike' then iPending = iPending + 1 end
            end
            -- else: leave the exp unflagged -> M28 handles it (doesnt pile at base waiting for a strike)
        end
    end
end

-- Strike doctrine (per user): RAZE THE BASE FIRST. Only once the base point has no remaining targets
-- (structures/units cleared) does the strike switch to hunting the enemy ACU (to finish the kill) -- so the
-- base stays under pressure and the enemy cant rebuild. If the ACU is then gone too, free the roster.
local function UpdateStrikes(aiBrain, iTeam)
    local tGroups = aiBrain.tMNBBattlegroups
    if not tGroups then return end
    local iKeep = {}
    for i, tG in tGroups do
        if tG.role ~= 'strike' then
            table.insert(iKeep, tG)
        elseif tG.huntingACU then
            -- already hunting the ACU: keep chasing its current position
            local oACU = GetClosestEnemyACU(iTeam, tG.targetPos)
            if oACU then
                local tNewPos = oACU:GetPosition()
                if (not tG.targetPos) or (M28Utilities.GetDistanceBetweenPositions(tNewPos, tG.targetPos) > 30) then
                    tG.targetPos = tNewPos
                    for j, oUnit in tG.roster do
                        if oUnit and not(oUnit.Dead) then
                            M28Orders.IssueTrackedAggressiveMove(oUnit, tNewPos, 6, false, 'MNBStrikeRT')
                        end
                    end
                    DBG('strike hunting ACU -> reposition')
                end
                table.insert(iKeep, tG)
            else
                -- ACU gone (dead or lost): objective done -> mark this base defeated so the bot moves on to the next opponent
                MarkBaseDefeated(aiBrain, tG.basePos)
                FreeRoster(tG.roster)
                aiBrain.iMNBStrikeRequired = STRIKE_BASE
                aiBrain.MNBEnemyBasePos = nil
                DBG('ACU gone after base clear -> freeing roster for next threat')
            end
        else
            -- pressing the BASE: keep going while targets remain; switch to ACU only once it's cleared
            local tEnemiesNear = aiBrain:GetUnitsAroundPoint(M28UnitInfo.refCategoryMobileLand + M28UnitInfo.refCategoryStructure, tG.targetPos, 70, 'Enemy')
            if M28Utilities.IsTableEmpty(tEnemiesNear) then
                local oACU = GetClosestEnemyACU(iTeam, tG.targetPos)
                if oACU then
                    tG.huntingACU = true
                    tG.targetPos = oACU:GetPosition()
                    for j, oUnit in tG.roster do
                        if oUnit and not(oUnit.Dead) then
                            M28Orders.IssueTrackedAggressiveMove(oUnit, tG.targetPos, 6, false, 'MNBStrikeACU')
                        end
                    end
                    DBG('base cleared -> strike now hunting ACU')
                    table.insert(iKeep, tG)
                else
                    MarkBaseDefeated(aiBrain, tG.basePos)
                    FreeRoster(tG.roster)
                    aiBrain.iMNBStrikeRequired = STRIKE_BASE
                    aiBrain.MNBEnemyBasePos = nil
                    DBG('base cleared, ACU unknown -> freeing roster for next threat')
                end
            else
                table.insert(iKeep, tG)  -- base still has targets; keep pressing
            end
        end
    end
    aiBrain.tMNBBattlegroups = iKeep
end

local function TickSafe(aiBrain)
    local iTeam = aiBrain.M28Team
    if not iTeam then return end
    if not aiBrain.tMNBBattlegroups then aiBrain.tMNBBattlegroups = {} end
    if not aiBrain.iMNBStrikeRequired then aiBrain.iMNBStrikeRequired = STRIKE_BASE end
    if not aiBrain.iMNBRaidRequired then aiBrain.iMNBRaidRequired = RAID_BASE end

    ResolveGroups(aiBrain, aiBrain.tMNBBattlegroups)
    ClaimIdleExperimentals(aiBrain)
    UpdateStrikes(aiBrain, iTeam)
    local tGroups = aiBrain.tMNBBattlegroups
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
                --NOTE: do NOT free M&B-flagged units on error. Freeing them = falling back to vanilla M28,
                --which CANT play the M&B mod (wrong economy/tiers/energy model). Better to leave units in
                --their groups (with their last orders) and let the manager retry next tick.
            end
        end
        WaitSeconds(TICK)
    end
end
