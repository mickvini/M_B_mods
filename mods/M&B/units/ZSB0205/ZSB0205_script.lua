#****************************************************************************
#**
#**  File     :  /ZSB0205_script.lua
#**  Author(s):  Packer
#**
#**  Summary  :  Reclaim Turret
#****************************************************************************
local SConstructionUnit = import('/lua/seraphimunits.lua').SConstructionUnit

ZSB0205 = Class(SConstructionUnit)
{
    OnCreate = function(self)
        SConstructionUnit.OnCreate(self)
        self:DisableUnitIntel('Radar')
    end,

    OnStartReclaim = function(self, target)
        if IsUnit(target) then
            if not IsAlly(self:GetArmy(), target:GetArmy()) and not target:IsCapturable() then
                SConstructionUnit.OnStartReclaim(self, target)
            else
                IssueClearCommands({self})
            end
        else
            SConstructionUnit.OnStartReclaim(self, target)
        end
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        SConstructionUnit.OnStopBeingBuilt(self, builder, layer)
        local reclaimThread = ForkThread(self.ReclaimerThread, self)
        self.Trash:Add(reclaimThread)
    end,

    -- Keep up to 10 outstanding reclaim orders, nearest first.
    -- The issued list IS the counter: the structure command queue cannot be
    -- used for counting (reads 1 even when idle). A target is never ordered
    -- twice while it exists; when a stone is gone (collected or taken),
    -- its slot frees up. No permanent blacklist.
    ReclaimerThread = function(self)
        local aiBrain = GetArmyBrain(self:GetArmy())
        local bp = self:GetBlueprint().Economy.MaxBuildDistance
        local pos = self:GetPosition()
        local issued = {}
        local loggedFull = false
        LOG('MNB_RC START uid=' .. tostring(self:GetEntityId()) .. ' pos=' .. tostring(math.floor(pos[1])) .. ',' .. tostring(math.floor(pos[3])))

        while not self.Dead do
            local reclaimTargets = GetReclaimablesInRect(pos[1] - bp, pos[3] - bp, pos[1] + bp, pos[3] + bp) or {}

            -- Prune issued targets that no longer exist in the fresh scan
            local stillIssued = {}
            for _, target in issued do
                for _, unit in reclaimTargets do
                    if unit == target then
                        table.insert(stillIssued, target)
                        break
                    end
                    local match = false
                    pcall(function()
                        if unit and target:GetEntityId() == unit:GetEntityId() then
                            match = true
                        end
                    end)
                    if match then
                        table.insert(stillIssued, target)
                        break
                    end
                end
            end
            issued = stillIssued

            if aiBrain:GetEconomyStoredRatio('MASS') < 0.95 then
                loggedFull = false
                -- Fill the queue up to 10 outstanding orders, nearest first
                while table.getn(issued) < 10 do
                    local best = nil
                    local bestDist = nil
                    for _, unit in reclaimTargets do
                        if unit and not IsUnit(unit) then
                            local skip = false
                            for _, target in issued do
                                if target == unit then
                                    skip = true
                                    break
                                end
                                local match = false
                                pcall(function()
                                    if target and target:GetEntityId() == unit:GetEntityId() then
                                        match = true
                                    end
                                end)
                                if match then
                                    skip = true
                                    break
                                end
                            end
                            if not skip then
                                pcall(function()
                                    local targetPos = unit:GetPosition()
                                    local dist = VDist2(pos[1], pos[3], targetPos[1], targetPos[3])
                                    if dist <= bp and (not bestDist or dist < bestDist) then
                                        best = unit
                                        bestDist = dist
                                    end
                                end)
                            end
                        end
                    end
                    if not best then
                        break
                    end
                    IssueReclaim({self}, best)
                    table.insert(issued, best)
                    local p = best:GetPosition()
                    LOG('MNB_RC ISSUE uid=' .. tostring(self:GetEntityId()) .. ' tgt=' .. tostring(math.floor(p[1])) .. ',' .. tostring(math.floor(p[3])) .. ' queued=' .. tostring(table.getn(issued)))
                end
            elseif not loggedFull then
                loggedFull = true
                LOG('MNB_RC FULL uid=' .. tostring(self:GetEntityId()) .. ' mass storage >= 95%, reclaim paused')
            end

            WaitSeconds(1)
        end
    end,
}
TypeClass = ZSB0205
