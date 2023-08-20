#****************************************************************************
#**
#**  File     :  /ZAB0205_script.lua
#**  Author(s):  Packer
#**
#**  Summary  :  Reclaim Turret
#****************************************************************************
local AConstructionStructureUnit = import('/lua/aeonunits.lua').AConstructionUnit

ZAB0205 = Class(AConstructionStructureUnit) 
{
    OnCreate = function(self)        
        AConstructionStructureUnit.OnCreate(self)
        self:DisableUnitIntel('Radar')
    end,

    OnStartReclaim = function(self, target)     
        if IsUnit(target) then
            if not IsAlly(self:GetArmy(), target:GetArmy()) and not target:IsCapturable() then
                AConstructionStructureUnit.OnStartReclaim(self, target)
            else
                IssueClearCommands({self})
            end
        else
            AConstructionStructureUnit.OnStartReclaim(self, target)
        end
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        AConstructionStructureUnit.OnStopBeingBuilt(self, builder, layer)        
        local reclaimThread = ForkThread(self.ReclaimerThread, self)
        self.Trash:Add(reclaimThread)   
    end,

    ReclaimCheck = function(self, unit, blacklist)
        if blacklist[unit] then
            return
        else
            IssueReclaim({self}, unit)
            blacklist[unit] = true            
        end
    end,

    ReclaimerThread = function(self)
        local aiBrain = GetArmyBrain(self:GetArmy())
        local bp = self:GetBlueprint().Economy.MaxBuildDistance
        local pos = self:GetPosition()
        local curMass = 0
        local blacklist = {}

        while not self.Dead do           
            local reclaimTargets = GetReclaimablesInRect(pos[1] - bp, pos[3] - bp, pos[1] + bp, pos[3] + bp)

            -- Clear blacklist if finished reclaiming everything or if reclaim targets greater than blacklist
            if table.getn(reclaimTargets) <= 0 or table.getn(reclaimTargets) > table.getn(blacklist) then
                IssueClearCommands({self})
                blacklist = {}
            end

            for _, unit in reclaimTargets do
                -- Check unit is properly defined
                if unit then
                    WaitTicks(6) -- Wait 8 ticks (0.8 seconds)
                    -- Check range to target
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
                end
            end 

            WaitSeconds(10)                                 
        end
    end,
}

TypeClass = ZAB0205


