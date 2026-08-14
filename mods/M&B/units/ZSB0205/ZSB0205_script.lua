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

    ReclaimCheck = function(self, unit, blacklist)
        if blacklist[unit] then
            return
        else
            IssueReclaim({self}, unit)
            blacklist[unit] = true
            -- Diagnostic marker only, no logic change
            local p = unit:GetPosition()
            LOG('MNB_RC ISSUE uid=' .. tostring(self:GetEntityId()) .. ' tgt=' .. tostring(math.floor(p[1])) .. ',' .. tostring(math.floor(p[3])) .. ' unit=' .. tostring(IsUnit(unit)))
        end
    end,

    ReclaimerThread = function(self)
        local aiBrain = GetArmyBrain(self:GetArmy())
        local bp = self:GetBlueprint().Economy.MaxBuildDistance
        local pos = self:GetPosition()
        local curMass = 0
        local blacklist = {}
        -- Diagnostic marker only, no logic change
        LOG('MNB_RC START uid=' .. tostring(self:GetEntityId()) .. ' pos=' .. tostring(math.floor(pos[1])) .. ',' .. tostring(math.floor(pos[3])))

        while not self.Dead do
            local reclaimTargets = GetReclaimablesInRect(pos[1] - bp, pos[3] - bp, pos[1] + bp, pos[3] + bp)
            -- Diagnostic marker only, no logic change
            LOG('MNB_RC SCAN uid=' .. tostring(self:GetEntityId()) .. ' targets=' .. table.getn(reclaimTargets or {}) .. ' queue=' .. table.getn(self:GetCommandQueue() or {}) .. ' mass=' .. tostring(aiBrain:GetEconomyStoredRatio('MASS')))

            if table.getn(reclaimTargets) <= 0 then
                IssueClearCommands({self})
                blacklist = {}
            end

            for _, unit in reclaimTargets do
                if unit then
                    WaitTicks(6)
                    pcall(function()
                        local targetPos = unit:GetPosition()

                        if VDist2(pos[1], pos[3], targetPos[1], targetPos[3]) <= bp then
                            if IsUnit(unit) then
                                if not IsAlly(self:GetArmy(), unit:GetArmy()) and not unit:IsCapturable() and aiBrain:GetEconomyStoredRatio('MASS') < 0.95 then
                                    self:ReclaimCheck(unit, blacklist)
                                end
                            elseif aiBrain:GetEconomyStoredRatio('MASS') < 0.95 then
                                self:ReclaimCheck(unit, blacklist)
                            end
                        end
                    end)
                end
            end

            WaitSeconds(10)
        end
    end,
}
TypeClass = ZSB0205