#****************************************************************************
#**
#**  File     :  /ZAB0205_script.lua
#**  Author(s):  Packer
#**
#**  Summary  :  Reclaim Turret
#****************************************************************************
local TConstructionStructureUnit = import('/lua/terranunits.lua').TConstructionUnit

ZEB0205 = Class(TConstructionStructureUnit)
{
    OnCreate = function(self)
        TConstructionStructureUnit.OnCreate(self)
        self:DisableUnitIntel('Radar')
    end,

    OnStartReclaim = function(self, target)
        if IsUnit(target) then
            if not IsAlly(self:GetArmy(), target:GetArmy()) and not target:IsCapturable() then
                TConstructionStructureUnit.OnStartReclaim(self, target)
            else
                IssueClearCommands({self})
            end
        else
            TConstructionStructureUnit.OnStartReclaim(self, target)
        end
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        TConstructionStructureUnit.OnStopBeingBuilt(self, builder, layer)
        local reclaimThread = ForkThread(self.ReclaimerThread, self)
        self.Trash:Add(reclaimThread)
    end,

    -- Keep up to 10 outstanding reclaim orders, nearest first.
    -- The issued list IS the counter: the structure command queue cannot be
    -- used for counting (reads 1 even when idle). A target is never ordered
    -- twice while it exists; when a stone is gone (collected or taken),
    -- its slot frees up. No permanent blacklist.
    -- Cost model: ONE linear pass over the scan per second, no per-slot
    -- rescans, no pcall wrappers. Stale targets are never touched (calling
    -- methods on destroyed entities crashes); they are only compared by
    -- reference against the fresh scan.
    ReclaimerThread = function(self)
        local aiBrain = GetArmyBrain(self:GetArmy())
        local bp = self:GetBlueprint().Economy.MaxBuildDistance
        local pos = self:GetPosition()
        local issued = {}
        local loggedFull = false
        LOG('MNB_RC START uid=' .. tostring(self:GetEntityId()) .. ' pos=' .. tostring(math.floor(pos[1])) .. ',' .. tostring(math.floor(pos[3])))

        while not self.Dead do
            local reclaimTargets = GetReclaimablesInRect(pos[1] - bp, pos[3] - bp, pos[1] + bp, pos[3] + bp) or {}

            -- Prune issued targets that are absent from the fresh scan
            -- (collected or taken by someone else). Reference membership in
            -- a hash set; dead entities are never dereferenced here.
            local present = {}
            for _, unit in reclaimTargets do
                present[unit] = true
            end
            local stillIssued = {}
            for _, target in issued do
                if present[target] then
                    table.insert(stillIssued, target)
                end
            end
            issued = stillIssued

            if aiBrain:GetEconomyStoredRatio('MASS') < 0.95 then
                loggedFull = false
                local need = 10 - table.getn(issued)
                if need > 0 then
                    -- Collect the `need` nearest unissued targets in a single
                    -- pass (best stays sorted nearest-first), then issue
                    local issuedSet = {}
                    for _, target in issued do
                        issuedSet[target] = true
                    end
                    local best = {}
                    for _, unit in reclaimTargets do
                        if unit and not IsUnit(unit) and not issuedSet[unit] then
                            local targetPos = unit:GetPosition()
                            local dist = VDist2(pos[1], pos[3], targetPos[1], targetPos[3])
                            if dist <= bp then
                                local inserted = false
                                for i = 1, table.getn(best) do
                                    if dist < best[i].dist then
                                        table.insert(best, i, {unit = unit, dist = dist})
                                        inserted = true
                                        break
                                    end
                                end
                                if not inserted and table.getn(best) < need then
                                    table.insert(best, {unit = unit, dist = dist})
                                end
                                if table.getn(best) > need then
                                    table.remove(best)
                                end
                            end
                        end
                    end
                    for i = 1, table.getn(best) do
                        IssueReclaim({self}, best[i].unit)
                        table.insert(issued, best[i].unit)
                    end
                end
            elseif not loggedFull then
                loggedFull = true
                LOG('MNB_RC FULL uid=' .. tostring(self:GetEntityId()) .. ' mass storage >= 95%, reclaim paused')
            end

            WaitSeconds(1)
        end
    end,
}
TypeClass = ZEB0205
