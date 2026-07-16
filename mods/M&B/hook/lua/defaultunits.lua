local Game = import('/lua/game.lua')
--local Buff = import('/mods/M&B/hook/lua/sim/Buff.lua')
--------------------------------------------------------------------------------
MK = {  }
do
    for i = 1, 8 do
        table.insert(MK,
        {{Aeon =0, UEF = 0, Cybran = 0, Seraphim = 0}, {Aeon =0, UEF = 0, Cybran = 0, Seraphim = 0},
         {Aeon =0, UEF = 0, Cybran = 0, Seraphim = 0}, {Aeon =0, UEF = 0, Cybran = 0, Seraphim = 0},
         {Aeon =0, UEF = 0, Cybran = 0, Seraphim = 0}, {Aeon =0, UEF = 0, Cybran = 0, Seraphim = 0},
         {Aeon =0, UEF = 0, Cybran = 0, Seraphim = 0}, {Aeon =0, UEF = 0, Cybran = 0, Seraphim = 0},
         {Aeon =0, UEF = 0, Cybran = 0, Seraphim = 0}, {Aeon =0, UEF = 0, Cybran = 0, Seraphim = 0},
         {Aeon =0, UEF = 0, Cybran = 0, Seraphim = 0}, {Aeon =0, UEF = 0, Cybran = 0, Seraphim = 0},
         {Aeon =0, UEF = 0, Cybran = 0, Seraphim = 0}, {Aeon =0, UEF = 0, Cybran = 0, Seraphim = 0},
         {Aeon =1, UEF = 1, Cybran = 1, Seraphim = 1},})
    end
end 


countingResearchsToUnlockTECH = function(unit, army, tech)        
    local unitBp = unit:GetBlueprint()   
    MK[army][tonumber(string.sub(tech, 4 , 6))][unitBp.General.FactionName] = MK[army][tonumber(string.sub(tech, 4 , 6))][unitBp.General.FactionName] + 1 

    local currTechLevel = MK[army][15][unitBp.General.FactionName]  
    --LOG("cur: " .. currTechLevel) 
    --LOG(MK[army][tonumber(string.sub(tech, 4 , 6))][unitBp.General.FactionName])
     
    local factions = { Aeon = 'sar9', UEF = 'ser9', Cybran = 'srr9', Seraphim = 'ssr9' } 
    local techWithoutLetters =  string.sub(tech, 3)
    --LOG(techWithoutLetters)    
    --LOG(string.sub(techWithoutLetters, 1, 1))
    if (tonumber(techWithoutLetters) + 100) < 515 and (tonumber(currTechLevel) > tonumber(string.sub(techWithoutLetters, 1, 1)))then
        RemoveBuildRestriction(army, categories[factions[unitBp.General.FactionName].. (tonumber(string.sub(tech, 3)) + 100) .. '00'])
    end
    local pos = unit:GetPosition()
    local updateTargets = GetUnitsInRect(pos[1] - 100, pos[3] - 100, pos[1] + 100, pos[3] + 100)
    for i, units in updateTargets do
        if (units) then 
            if IsAlly(army, units:GetArmy()) then
                local unitsBp = units:GetBlueprint()
                local factionCat = unitsBp.General.FactionName
                if table.find(unitsBp.Categories, 'STRUCTURE') or (unitsBp.General.UnitName == '<LOC url0401_name>Scathis') then
                    if MK[army][1][factionCat] > 0 and not table.find(unitsBp.Categories, 'DEFENSE') and not table.find(unitsBp.Categories, 'ARTILLERY') and not table.find(unitsBp.Categories, 'ENGINEERSTATION') then
                        SetMarkLevel(units, 'StructureHealthMod' .. MK[army][1][factionCat], 1, MK[army][1][factionCat])
                    end                    
                    if MK[army][3][factionCat] > 0  and( table.find(unitsBp.Categories, 'STATIONASSISTPOD') or table.find(unitsBp.Categories, 'ENGINEERSTATION')) then
                        SetMarkLevel(units, 'EngineerStationMod' .. MK[army][3][factionCat], 3, MK[army][3][factionCat])
                    end
                    if MK[army][13][factionCat] > 0 and (table.find(unitsBp.Categories, 'DEFENSE') or table.find(unitsBp.Categories, 'ARTILLERY')) then
                        SetMarkLevel(units, 'WeaponBuffTurret' .. MK[army][13][factionCat], 13, MK[army][13][factionCat])
                    end
                    if MK[army][14][factionCat] > 0 and (table.find(unitsBp.Categories, 'DEFENSE') or table.find(unitsBp.Categories, 'ARTILLERY'))  then
                        SetMarkLevel(units, 'HealthBuffTurret' .. MK[army][14][factionCat], 14, MK[army][14][factionCat])
                    end                   
                elseif ((not table.find(unitsBp.Categories, 'SUBCOMMANDER')) and (not table.find(unitsBp.Categories, 'COMMAND'))) and table.find(unitsBp.Categories, 'MOBILE') and table.find(unitsBp.Categories, 'ENGINEER') then
                    if MK[army][2][factionCat] > 0 then
                        SetMarkLevel(units, 'ConstrctionBotMod' .. MK[army][2][factionCat], 2, MK[army][2][factionCat])
                    end
                end
            end
        end
    end
end



SetMarkLevel = function(self, buffName, tech, techLevel)
    local army = self:GetArmy() 
    if MK[army][tech][self:GetBlueprint().General.FactionName] ~= self.MarkLevel[tech] then  
        if not self:IsBeingBuilt() then
            --LOG('1')
            Buff.ApplyBuff(self ,  buffName) 
            self.MarkLevel[tech] = techLevel   
        else
            --LOG('2')
        end                   
    end      
end


--Update existing defaultunits classes   


local oldStructureUint = StructureUnit
local oldConstructionUnit = ConstructionUnit
local oldWalkingLandUnit = WalkingLandUnit
local oldSubUnit = SubUnit
local oldAirUnit = AirUnit
local oldSeaUnit = SeaUnit

StructureUnit = Class(oldStructureUint) {

	OnCreate = function(self)
		oldStructureUint.OnCreate(self)
		local unitBp = self:GetBlueprint()  
		--M&B: boost the bot's power generators PROPORTIONALLY across tiers (T0 280->500, T1 760->1400, T2 1780->3000) so the bot needs far fewer pgens (energy is maintenance-only in M&B). Boost ALL tiers (not just T0) so each upgrade is a BIG jump — otherwise the smart bot dismantles cheap pgens to rebuild marginally-better ones for almost no gain, wasting mass. Player pgens unchanged; bot only; hydrocarbons excluded (separate).
		if self:GetAIBrain().BrainType ~= 'Human' and not table.find(unitBp.Categories, 'HYDROCARBON') then
			local iMNBProd = unitBp.Economy.ProductionPerSecondEnergy or 0
			local iMNBBoost = nil
			if iMNBProd > 0 and iMNBProd <= 300 then iMNBBoost = 500
			elseif iMNBProd > 300 and iMNBProd <= 800 then iMNBBoost = 1400
			elseif iMNBProd > 800 and iMNBProd <= 1800 then iMNBBoost = 3000
			elseif iMNBProd > 1800 and iMNBProd <= 5000 then iMNBBoost = 7800
			elseif iMNBProd > 5000 then iMNBBoost = 15000 end
			if iMNBBoost then self:SetProductionPerSecondEnergy(iMNBBoost) end
		end
		if (unitBp.General.Category == 'Defense' or table.find(unitBp.Categories, 'ARTILLERY')) and unitBp.General.Classification ~= 'RULEUC_MiscSupport' and not table.find(unitBp.Economy.BuildableCategory, 'FACTORYUEFLL') then
        	self.BaseRateOfFire = {}
        	for i = 1, self:GetWeaponCount() do   
        		local wep = self:GetWeapon(i)
                local wepbp = wep:GetBlueprint()
                local weprof = wepbp.RateOfFire     
                table.insert(self.BaseRateOfFire, weprof)
            end
        	local ReduceTurretsRateOfFireThread = ForkThread(self.ReduceTurretsRateOfFire, self)
        	self.Trash:Add(ReduceTurretsRateOfFireThread) 
        end
	end,

    OnStopBeingBuilt = function(self, builder, layer)
        oldStructureUint.OnStopBeingBuilt(self,builder,layer)
        
        self:SetMaintenanceConsumptionActive()
        local army = self:GetArmy() 
        local unitBp = self:GetBlueprint()        
        
        local factionCat = unitBp.General.FactionName        
        if MK[army][1][factionCat] > 0 and table.find(unitBp.Categories, 'STRUCTURE') and  not table.find(unitBp.Categories, 'DEFENSE') and not table.find(unitBp.Categories, 'ENGINEERSTATION') then
            SetMarkLevel(self, 'StructureHealthMod' .. MK[army][1][factionCat], 1, MK[army][1][factionCat])
        end
        if MK[army][3][factionCat] > 0 and table.find(unitBp.Categories, 'ENGINEERSTATION') then
            SetMarkLevel(self, 'EngineerStationMod' .. MK[army][3][factionCat], 3, MK[army][3][factionCat])
        end
        if MK[army][13][factionCat] > 0 and (table.find(unitBp.Categories, 'DEFENSE') or table.find(unitBp.Categories, 'ARTILLERY')) then
            SetMarkLevel(self, 'WeaponBuffTurret' .. MK[army][13][factionCat], 13, MK[army][13][factionCat])
        end
        if MK[army][14][factionCat] > 0 and (table.find(unitBp.Categories, 'DEFENSE') or table.find(unitBp.Categories, 'ARTILLERY')) then
            SetMarkLevel(self, 'HealthBuffTurret' .. MK[army][14][factionCat], 14, MK[army][14][factionCat])
        end
    end,

    ReduceTurretsRateOfFire = function (self)
    	local aiBrain = GetArmyBrain(self:GetArmy())        
        
        while not self.Dead do        	
        	local EconomyRate = aiBrain:GetEconomyIncome('ENERGY') / aiBrain:GetEconomyRequested('ENERGY')
        	--LOG(EconomyRate)
            --LOG()
            if aiBrain:GetEconomyStored('ENERGY') <= 0.00001 then
            	if EconomyRate < 1 then
                    --LOG('<1')
            		for i = 1, self:GetWeaponCount() do  
            			 
            			local wep = self:GetWeapon(i)        
                        if(EconomyRate == 0 or EconomyRate < 0.2) 	then	
                            wep:SetWeaponEnabled(false)
                        else        			        			
                            wep:SetWeaponEnabled(true)
                    	    wep:ChangeRateOfFire( self.BaseRateOfFire[i] * EconomyRate)
                        end
                    end
                end
            else
                for i = 1, self:GetWeaponCount() do
                		--LOG('==1')  
            			local wep = self:GetWeapon(i)          
                        wep:SetWeaponEnabled(true)				    
                    	wep:ChangeRateOfFire(self.BaseRateOfFire[i])                	 
                end                                
            end
            WaitSeconds(5)
        end
    end,

}
--M&B: hook EnergyCreationUnit (the class pgens/hydro use; StructureUnit.OnCreate doesnt fire for them, which is why the earlier StructureUnit boost gave no effect) to boost the bot's power generators proportionally: T0 280->500, T1 760->1400, T2 1780->3000. Bot only; hydrocarbons excluded. So the bot needs far fewer pgens and each tier-up is a big jump (no wasteful dismantle-and-rebuild for marginal gain). Player pgens unchanged.
local oldEnergyCreationUnit = EnergyCreationUnit
EnergyCreationUnit = Class(oldEnergyCreationUnit) {
    OnCreate = function(self)
        oldEnergyCreationUnit.OnCreate(self)
        local unitBp = self:GetBlueprint()
        if self:GetAIBrain().BrainType ~= 'Human' and not table.find(unitBp.Categories, 'HYDROCARBON') then
            local iMNBProd = unitBp.Economy.ProductionPerSecondEnergy or 0
            local iMNBBoost = nil
            if iMNBProd > 0 and iMNBProd <= 300 then iMNBBoost = 500
            elseif iMNBProd > 300 and iMNBProd <= 800 then iMNBBoost = 1400
            elseif iMNBProd > 800 and iMNBProd <= 1800 then iMNBBoost = 3000
            elseif iMNBProd > 1800 and iMNBProd <= 5000 then iMNBBoost = 7800
            elseif iMNBProd > 5000 then iMNBBoost = 15000 end
            if iMNBBoost then self:SetProductionPerSecondEnergy(iMNBBoost) end
        end
    end,
}

local oldFactoryUnit = FactoryUnit
FactoryUnit = Class(oldFactoryUnit)
{
    OnCreate = function(self)
        oldFactoryUnit.OnCreate(self)
        local unitBp = self:GetBlueprint()  
        
        self.BaseBuildRate = self:GetBuildRate()

        -- M&B: boost ONLY the AI bot's research lab (50 -> 75) so research/tiers unlock a bit faster for the bot. 75 (not 100) so the lab doesnt hoard all the mass and starve army/factory/exp construction - the game is about war, not a science contest. Player labs stay at 50. Gate on RESEARCHCENTRE so land/air/naval factories are unaffected; BrainType~='Human' targets only the bot (this mod is M28-only). ReduceFactoryBuildRate still throttles this on mass/energy stall, so the boost self-limits to whatever the bot can mass-feed.
        local bIsLab = false
        for iCat, sCat in unitBp.Categories or {} do
            if sCat == 'RESEARCHCENTRE' then bIsLab = true; break end
        end
        if bIsLab and self:GetAIBrain().BrainType ~= 'Human' then
            self.BaseBuildRate = 100
        end

        -- LOG(self.BaseBuildRate)
        -- LOG(self:GetBlueprint().BlueprintId)
        --if(not table.find(self:GetBlueprint().Economy.BuildableCategory, 'FACTORYUEFLL')) then
            local ReduceFactoryBuildRate = ForkThread(self.ReduceFactoryBuildRate, self)
            self.Trash:Add(ReduceFactoryBuildRate) 
        --end
        
        
    end,
    ReduceFactoryBuildRate = function (self)
        local aiBrain = GetArmyBrain(self:GetArmy())        
        
        while not self.Dead do          
            local EconomyRate = aiBrain:GetEconomyIncome('ENERGY') / aiBrain:GetEconomyRequested('ENERGY')
            local MassRate = aiBrain:GetEconomyIncome('MASS') / aiBrain:GetEconomyRequested('MASS')
            --LOG(EconomyRate)
            if aiBrain:GetEconomyStored('MASS') <= 10 and aiBrain:GetEconomyStored('ENERGY') <= 10 then
                if EconomyRate < 1 and MassRate < 1 then                 
                    --LOG('<1') 
                    --LOG('Масса и Энергия закончилась')    
                    --LOG("Потери: " .. self.BaseBuildRate * EconomyRate * MassRate)                                                                         
                    self:SetBuildRate(self.BaseBuildRate * 0.9 * EconomyRate * MassRate)  
                    self:UpdateConsumptionValues()                              
                elseif aiBrain:GetEconomyStoredRatio('MASS') > 0.05 and aiBrain:GetEconomyStoredRatio('ENERGY') > 0.05 then               
                    --LOG('==1')
                    --LOG("Начальное значение: " .. self.BaseBuildRate)               
                    self:SetBuildRate(self.BaseBuildRate)    
                    self:UpdateConsumptionValues()               
                end   
            elseif aiBrain:GetEconomyStored('MASS') <= 10 then                
                if MassRate < 1 then                 
                    --LOG('<1') 
                    --LOG('Масса закончилась')    
                    --LOG("Потери: " .. self.BaseBuildRate * MassRate)                                                                         
                    self:SetBuildRate(self.BaseBuildRate * 0.9 * MassRate)  
                    self:UpdateConsumptionValues()                              
                elseif aiBrain:GetEconomyStoredRatio('MASS') > 0.05 then    
                    --LOG('==1')
                    --LOG("Начальное значение: " .. self.BaseBuildRate)               
                    self:SetBuildRate(self.BaseBuildRate)    
                    self:UpdateConsumptionValues()   
                end
            elseif aiBrain:GetEconomyStored('ENERGY') <= 10 then
                --LOG('Энергия закончилась')
                if EconomyRate < 1 then                 
                    --LOG('<1') 
                    --LOG('Энергия закончилась')    
                    --LOG("Потери: " .. self.BaseBuildRate * EconomyRate )                                                                         
                    self:SetBuildRate(self.BaseBuildRate * 0.9 * EconomyRate)  
                    self:UpdateConsumptionValues()                              
                elseif aiBrain:GetEconomyStoredRatio('ENERGY') > 0.05 then               
                    --LOG('==1')
                    --LOG("Начальное значение: " .. self.BaseBuildRate)               
                    self:SetBuildRate(self.BaseBuildRate)    
                    self:UpdateConsumptionValues()    
                -- Действия при закончившейся энергии
                end
            else       
                --LOG('==1')
                --LOG("Начальное значение: " .. self.BaseBuildRate)               
                self:SetBuildRate(self.BaseBuildRate)    
                self:UpdateConsumptionValues()    
            -- Действия при закончившейся энергии
                
            end
            WaitTicks(10)
        end
    end,
}

LandFactoryUnit = Class(FactoryUnit) {

    OnStopBeingBuilt = function(self, builder, layer)        
        self.MaintenceUnit = {}
        self.MaintenceConsumption = self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergy or 0
        --LOG(self.MaintenceConsumption)       
        local myOrientation = self:GetOrientation()
        local location = self:GetPosition()           
        local maintenceUnit = CreateUnit('bsb00021',  self:GetArmy(), location[1], location[2], location[3]+2, myOrientation[1], myOrientation[2], myOrientation[3], myOrientation[4], 'Land') 
        table.insert(self.MaintenceUnit, maintenceUnit)
        maintenceUnit:SetParent(self, self:GetBlueprint().BlueprintId)
        maintenceUnit:SetCreator(self)         
        maintenceUnit:SetConsumptionActive(false)
        self.Trash:Add(maintenceUnit)
        FactoryUnit.OnStopBeingBuilt(self, builder, layer)
        --LOG(4)     
    end,            
    OnStopBuild = function(self, unitBeingBuilt, order )        
        self.MaintenceUnit[1]:SetConsumptionPerSecondEnergy(self.MaintenceConsumption)           
        self:SetMaintenanceConsumptionActive()
        self.MaintenceUnit[1]:SetConsumptionActive(false)
        FactoryUnit.OnStopBuild(self, unitBeingBuilt, order ) 
        self.MaintenceConsumption = self:GetConsumptionPerSecondEnergy()       
    end,

    OnStartBuild = function(self, unitBeingBuilt, order )
        FactoryUnit.OnStartBuild(self, unitBeingBuilt, order )
        self.MaintenceUnit[1]:SetConsumptionPerSecondEnergy(self.MaintenceConsumption) 
        --LOG(self.MaintenceConsumption)            
        self:SetMaintenanceConsumptionInactive()
        self.MaintenceUnit[1]:SetConsumptionActive(true)
    end,    

}

AirFactoryUnit = Class(FactoryUnit) {
    OnStopBeingBuilt = function(self, builder, layer)        
        self.MaintenceUnit = {}
        self.MaintenceConsumption = self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergy or 0
        --LOG(self.MaintenceConsumption)       
        local myOrientation = self:GetOrientation()
        local location = self:GetPosition()           
        local maintenceUnit = CreateUnit('bsb00021',  self:GetArmy(), location[1], location[2], location[3]+2, myOrientation[1], myOrientation[2], myOrientation[3], myOrientation[4], 'Land') 
        table.insert(self.MaintenceUnit, maintenceUnit)
        maintenceUnit:SetParent(self, self:GetBlueprint().BlueprintId)
        maintenceUnit:SetCreator(self)         
        maintenceUnit:SetConsumptionActive(false)
        self.Trash:Add(maintenceUnit)
        FactoryUnit.OnStopBeingBuilt(self, builder, layer)
        --LOG(4)     
    end,            
    OnStopBuild = function(self, unitBeingBuilt, order )        
        self.MaintenceUnit[1]:SetConsumptionPerSecondEnergy(self.MaintenceConsumption)           
        self:SetMaintenanceConsumptionActive()
        self.MaintenceUnit[1]:SetConsumptionActive(false)
        FactoryUnit.OnStopBuild(self, unitBeingBuilt, order ) 
        self.MaintenceConsumption = self:GetConsumptionPerSecondEnergy()       
    end,

    OnStartBuild = function(self, unitBeingBuilt, order )
        FactoryUnit.OnStartBuild(self, unitBeingBuilt, order )
        self.MaintenceUnit[1]:SetConsumptionPerSecondEnergy(self.MaintenceConsumption) 
        --LOG(self.MaintenceConsumption)            
        self:SetMaintenanceConsumptionInactive()
        self.MaintenceUnit[1]:SetConsumptionActive(true)
    end, 

}

SeaFactoryUnit = Class(FactoryUnit) {
    # Disable the default rocking behavior
    StartRocking = function(self)
    end,

    StopRocking = function(self)
    end,

    OnStopBeingBuilt = function(self, builder, layer)        
        self.MaintenceUnit = {}
        self.MaintenceConsumption = self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergy or 0
        --LOG(self.MaintenceConsumption)       
        local myOrientation = self:GetOrientation()
        local location = self:GetPosition()           
        local maintenceUnit = CreateUnit('bsb00021',  self:GetArmy(), location[1], location[2], location[3]+2, myOrientation[1], myOrientation[2], myOrientation[3], myOrientation[4], 'Land') 
        table.insert(self.MaintenceUnit, maintenceUnit)
        maintenceUnit:SetParent(self, self:GetBlueprint().BlueprintId)
        maintenceUnit:SetCreator(self)         
        maintenceUnit:SetConsumptionActive(false)
        self.Trash:Add(maintenceUnit)
        FactoryUnit.OnStopBeingBuilt(self, builder, layer)
        --LOG(4)     
    end,            
    OnStopBuild = function(self, unitBeingBuilt, order )        
        self.MaintenceUnit[1]:SetConsumptionPerSecondEnergy(self.MaintenceConsumption)           
        self:SetMaintenanceConsumptionActive()
        self.MaintenceUnit[1]:SetConsumptionActive(false)
        FactoryUnit.OnStopBuild(self, unitBeingBuilt, order ) 
        self.MaintenceConsumption = self:GetConsumptionPerSecondEnergy()       
    end,

    OnStartBuild = function(self, unitBeingBuilt, order )
        FactoryUnit.OnStartBuild(self, unitBeingBuilt, order )
        self.MaintenceUnit[1]:SetConsumptionPerSecondEnergy(self.MaintenceConsumption) 
        --LOG(self.MaintenceConsumption)            
        self:SetMaintenanceConsumptionInactive()
        self.MaintenceUnit[1]:SetConsumptionActive(true)
    end, 
}




ConstructionUnit = Class(oldConstructionUnit){
    OnStopBeingBuilt = function(self, builder, layer)
        oldConstructionUnit.OnStopBeingBuilt(self,builder,layer)
        local army = self:GetArmy()    
        local unitBp = self:GetBlueprint()
        local factionCat = unitBp.General.FactionName
        if MK[army][2][factionCat] > 0 then
            SetMarkLevel(self, 'ConstrctionBotMod' .. MK[army][2][factionCat], 2, MK[army][2][factionCat])
        end
    end,
    OnCreate = function(self)
        oldConstructionUnit.OnCreate(self)
        local army = self:GetArmy()    
        local unitBp = self:GetBlueprint()
        local factionCat = unitBp.General.FactionName
        if MK[army][3][factionCat] > 0  and table.find(unitBp.Categories, 'STATIONASSISTPOD') then
            SetMarkLevel(self, 'EngineerStationMod' .. MK[army][3][factionCat], 3, MK[army][3][factionCat])
        end
    end,
}
-- Attack units
WalkingLandUnit = Class(oldWalkingLandUnit) {
    OnStopBeingBuilt = function(self, builder, layer)
        oldWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
        local army = self:GetArmy()   
        local bp = self:GetBlueprint()
        local factionCat = bp.General.FactionName
        if (not table.find(bp.Categories, 'SUBCOMMANDER')) and (not table.find(bp.Categories, 'COMMAND')) then
            if MK[army][4][factionCat] > 0 then
                SetMarkLevel(self, 'MobileBuffLand' .. MK[army][4][factionCat], 4, MK[army][4][factionCat])
            end
            if MK[army][5][factionCat] > 0 then
                SetMarkLevel(self, 'HealthBuffLand' .. MK[army][5][factionCat], 5, MK[army][5][factionCat])
            end        
            if MK[army][6][factionCat] > 0 then
                SetMarkLevel(self, 'WeaponBuffLand' .. MK[army][6][factionCat], 6, MK[army][6][factionCat])
            end
        end
    end,
}

LandUnit = Class(MobileUnit) {
    OnStopBeingBuilt = function(self, builder, layer)
        MobileUnit.OnStopBeingBuilt(self, builder, layer)
        local army = self:GetArmy()    
        local general = self:GetBlueprint().General
        local factionCat = general.FactionName
        if general.UnitName == '<LOC url0401_name>Scathis' then
            if MK[army][13][factionCat] > 0 then
                SetMarkLevel(self, 'WeaponBuffTurret' .. MK[army][13][factionCat], 13, MK[army][13][factionCat])
            end
            if MK[army][14][factionCat] > 0 then
                SetMarkLevel(self, 'HealthBuffTurret' .. MK[army][14][factionCat], 14, MK[army][14][factionCat])
            end
        else
            if MK[army][4][factionCat] > 0 then
                SetMarkLevel(self, 'MobileBuffLand' .. MK[army][4][factionCat], 4, MK[army][4][factionCat])
            end
            if MK[army][5][factionCat] > 0 then
                SetMarkLevel(self, 'HealthBuffLand' .. MK[army][5][factionCat], 5, MK[army][5][factionCat])
            end        
            if MK[army][6][factionCat] > 0 then
                SetMarkLevel(self, 'WeaponBuffLand' .. MK[army][6][factionCat], 6, MK[army][6][factionCat])
            end
        end

    end,
}

HoverLandUnit = Class(MobileUnit) {
    OnStopBeingBuilt = function(self, builder, layer)
        MobileUnit.OnStopBeingBuilt(self, builder, layer)
        local army = self:GetArmy()    
        local factionCat = self:GetBlueprint().General.FactionName
        if MK[army][4][factionCat] > 0 then
            SetMarkLevel(self, 'MobileBuffLand' .. MK[army][4][factionCat], 4, MK[army][4][factionCat])
        end
        if MK[army][5][factionCat] > 0 then
            SetMarkLevel(self, 'HealthBuffLand' .. MK[army][5][factionCat], 5, MK[army][5][factionCat])
        end        
        if MK[army][6][factionCat] > 0 then
            SetMarkLevel(self, 'WeaponBuffLand' .. MK[army][6][factionCat], 6, MK[army][6][factionCat])
        end
    end,
}

AirUnit = Class(oldAirUnit) {
    OnStopBeingBuilt = function(self, builder, layer)
        oldAirUnit.OnStopBeingBuilt(self, builder, layer)
        local army = self:GetArmy() 
        local factionCat = self:GetBlueprint().General.FactionName
        if MK[army][7][factionCat] > 0 then
            SetMarkLevel(self, 'MobileBuffAir' .. MK[army][7][factionCat], 7, MK[army][7][factionCat])
        end
        if MK[army][8][factionCat] > 0 then
            SetMarkLevel(self, 'HealthBuffAir' .. MK[army][8][factionCat], 8, MK[army][8][factionCat])
        end        
        if MK[army][9][factionCat] > 0 then
            SetMarkLevel(self, 'WeaponBuffAir' .. MK[army][9][factionCat], 9, MK[army][9][factionCat])
        end
    end,
}

SeaUnit = Class(oldSeaUnit) {
    OnStopBeingBuilt = function(self, builder, layer)
        oldSeaUnit.OnStopBeingBuilt(self, builder, layer)
        local army = self:GetArmy()    
        local factionCat = self:GetBlueprint().General.FactionName
        if MK[army][10][factionCat] > 0 then
            SetMarkLevel(self, 'MobileBuffNaval' .. MK[army][10][factionCat], 10, MK[army][10][factionCat])
        end
        if MK[army][11][factionCat] > 0 then
            SetMarkLevel(self, 'HealthBuffNaval' .. MK[army][11][factionCat], 11, MK[army][11][factionCat])
        end        
        if MK[army][12][factionCat] > 0 then
            SetMarkLevel(self, 'WeaponBuffNaval' .. MK[army][12][factionCat], 12, MK[army][12][factionCat])
        end
    end,
}

SubUnit = Class(oldSubUnit) {
    OnStopBeingBuilt = function(self, builder, layer)
        oldSubUnit.OnStopBeingBuilt(self, builder, layer)
        local army = self:GetArmy() 
        local factionCat = self:GetBlueprint().General.FactionName
        if MK[army][10][factionCat] > 0 then
            SetMarkLevel(self, 'MobileBuffNaval' .. MK[army][10][factionCat], 1, MK[army][1][factionCat])
        end
        if MK[army][11][factionCat] > 0 then
            SetMarkLevel(self, 'HealthBuffNaval' .. MK[army][11][factionCat], 1, MK[army][1][factionCat])
        end        
        if MK[army][12][factionCat] > 0 then
            SetMarkLevel(self, 'WeaponBuffNaval' .. MK[army][12][factionCat], 1, MK[army][1][factionCat])
        end
    end,
    OnLayerChange = function( self, new, old )
        oldSubUnit.OnLayerChange(self, new, old)
        if new == 'Water' then
            self:SetSpeedMult(1.1)
        elseif new == 'Sub' then
            self:SetSpeedMult(1)
        end
    end,
}
    

ResearchItem = Class(DummyUnit) {
    OnCreate = function(self)
        local bp = self.BpId and __blueprints[self.BpId] or self:GetBlueprint()
        DummyUnit.OnCreate(self)
        --Restrict me, the RND item, to one being built at a time.        
        AddBuildRestriction(self:GetArmy(), categories[bp.BlueprintId] )                               
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        local bp = self:GetBlueprint()
        local army = self:GetArmy()
        factionCat = categories[string.upper(bp.General.FactionName or 'SELECTABLE')]
        
        -- Enable what we were supposed to allow.
        if bp.ResearchId == string.lower(bp.ResearchId) then --This wont work for any units without letters in the ID.
            if self:CheckBuildRestrictionsAllow(bp.ResearchId) then
                RemoveBuildRestriction(army, categories[bp.ResearchId] - categories.MOD)
            else
                WARN("Research item for " .. bp.ResearchId .. " was just completed, however lobby restrictions forbid it. Item shouldn't have been researchable.")
            end
        elseif bp.ResearchId == 'RESEARCHLOCKEDTECH1' then
            RemoveBuildRestriction(army, categories.TECH2 * factionCat * categories.CONSTRUCTIONSORTDOWN - categories.MOD)                       
            self:UnlockMKResearchForTech(army, 2, bp.General.FactionName)
            
        elseif bp.ResearchId == 'TECH2' then
            RemoveBuildRestriction(army, categories.TECH3 * factionCat * categories.CONSTRUCTIONSORTDOWN - categories.MOD)
            self:UnlockMKResearchForTech(army, 3, bp.General.FactionName)          
            
        elseif bp.ResearchId == 'TECH3' then
            RemoveBuildRestriction(army, categories.EXPERIMENTAL * factionCat * categories.CONSTRUCTIONSORTDOWN - categories.BUILTBYRESEARCH * categories.MOD)
            self:UnlockMKResearchForTech(army, 4, bp.General.FactionName)            
            
        elseif bp.ResearchId == 'EXPERIMENTAL' then
            RemoveBuildRestriction(army, categories[bp.ResearchId] * factionCat + categories.EXPERIMENTALMEX - categories.BUILTBYRESEARCH - categories.CONSTRUCTIONSORTDOWN - categories.RESEARCHLOCKED - categories.MOD - categories[bp.BlueprintId])
            self:UnlockMKResearchForTech(army, 5, bp.General.FactionName)  
        elseif string.find(bp.ResearchId, 'MK') then
            countingResearchsToUnlockTECH(self, army, bp.ResearchId)            
        end
        
        if not string.find(bp.ResearchId, 'MK') then
            RemoveBuildRestriction(army, categories[bp.ResearchId] * factionCat - categories.BUILTBYRESEARCH - categories.MASSEXTRACTION * categories.EXPERIMENTALMEX - categories.CONSTRUCTIONSORTDOWN - categories.RESEARCHLOCKED - categories.MOD - categories[bp.BlueprintId])
        end

        --M&B: expose the unlocked tech tier on our brain so the AI (M28) can see what's researched. M28's IsUnitRestricted is blind to per-army AddBuildRestriction, so it needs this explicit signal to know which tiers are available (otherwise it spams 'Dont have a valid upgrade ID').
        do
            local oMNBBrain = self:GetAIBrain()
            if oMNBBrain then
                oMNBBrain.MNB_TechUnlocked = oMNBBrain.MNB_TechUnlocked or {}
                local iMNBTier = ({RESEARCHLOCKEDTECH1=2, TECH2=3, TECH3=4, EXPERIMENTAL=5})[bp.ResearchId]
                if iMNBTier then
                    --Research is sequential, so unlocking tier N implies all lower tiers are also unlocked; carry them forward.
                    for iMNB = 2, iMNBTier do oMNBBrain.MNB_TechUnlocked[iMNB] = true end
                    --A tier unlock also unlocks that tier's MK boost-research (UnlockMKResearchForTech), so flag that boosts are now studyable. M28 uses this to decide a 2nd lab is worth building (for boosts), instead of a tier milestone.
                    oMNBBrain.MNB_BoostsAvailable = true
                    LOG('M&B: tech tier '..iMNBTier..' unlocked for army '..tostring(army)..' ('..tostring(bp.General.FactionName)..')')
                    --M&B: the instant a tier unlocks, put EVERY extractor on upgrade in parallel (mass-first economy; mexes self-upgrade so no one-at-a-time throttle). AI brains only - a human controls their own mexes. M28Economy isnt a global, its only reachable via import, so lazy-import it here and run the sweep after a tiny delay so RemoveBuildRestriction has settled.
                    if oMNBBrain.BrainType ~= 'Human' then
                        --M&B: event-driven mass kickstart. 9200 (tier 3) flat 2000; 9300 (tier 4) STAGGERED 5x2000 over 30s = 10000 total (user: the 9300->9400 push is mass-heavy - 9400 research + T3 generators + factory upgrades all at once - a flat grant overflows the ~2000 mass storage or drains mid-build, so stagger to arrive in step); 9400 (tier 5) flat 5000.
                        if iMNBTier == 4 then
                            oMNBBrain:GiveResource('Mass', 2000)
                            LOG('M&B: gave 2000 mass (1/5) on tier 4 (9300) unlock to '..tostring(army))
                            ForkThread(function()
                                for iKick = 2, 5 do
                                    WaitSeconds(30)
                                    if oMNBBrain and not(oMNBBrain:IsDefeated()) then oMNBBrain:GiveResource('Mass', 2000); LOG('M&B: gave 2000 mass ('..iKick..'/5) for tier 4 (9300) at GameTime '..GetGameTimeSeconds()) end
                                end
                            end)
                        else
                            local iMNBKick = ({[3]=2000, [5]=5000})[iMNBTier]
                            if iMNBKick then
                                oMNBBrain:GiveResource('Mass', iMNBKick)
                                LOG('M&B: gave '..iMNBKick..' mass on tier '..iMNBTier..' unlock to '..tostring(army))
                            end
                        end
                        ForkThread(function()
                            WaitSeconds(3)
                            local M28Economy = import('/mods/M&B/lua/AI/M28Economy.lua')
                            if M28Economy and oMNBBrain and not(oMNBBrain.Dead) then
                                if M28Economy.MNBSweepMexUpgrades then M28Economy.MNBSweepMexUpgrades(oMNBBrain) end
                                --M&B: also push T1 radars to T2 now that the tier is unlocked (M28 has no T1->T2 radar upgrade of its own).
                                if M28Economy.MNBSweepRadarUpgrades then M28Economy.MNBSweepRadarUpgrades(oMNBBrain) end
                            end
                        end)
                    end
                end
            end
        end

        -- Tell the manager this is done if we're an AI and presumably have a manager.
       

        -- Before the rest, because the rest is Destroy(self)
        DummyUnit.OnStopBeingBuilt(self, builder, layer)
    end,

    UnlockMKResearchForTech = function(self, army, techLevel, factionName)
        
        -- Определяем префикс фракции для исследований
        local factionPrefix
        if factionName == "Aeon" then
            factionPrefix = "sar9"
        elseif factionName == "UEF" then
            factionPrefix = "ser9"
        elseif factionName == "Cybran" then
            factionPrefix = "srr9"
        elseif factionName == "Seraphim" then
            factionPrefix = "ssr9"
        else
            return
        end
        
        -- Разблокируем все MK исследования для данного уровня техники
        local researchId
        for mkLevel = 1, 14 do -- Предполагаем, что есть 14 уровней MK исследований
            if mkLevel < 10 then
                researchId = factionPrefix .. techLevel .. '0' .. mkLevel .. '00' 
            else
                researchId = factionPrefix .. techLevel .. mkLevel .. '00' 
            end
            
            --LOG(researchId)
            --LOG(MK[army][mkLevel][factionName])
            if(MK[army][mkLevel][factionName] >= techLevel - 1) then
                RemoveBuildRestriction(army, categories[researchId])
            end
            --RemoveBuildRestriction(army, categories[factions[unitBp.General.FactionName].. (tonumber(string.sub(tech, 3)) + 100) .. '00'])


        end
        MK[army][15][factionName] = techLevel
        --LOG(MK[army][15][factionName])
    end,

    CheckBuildRestrictionsAllow = function(self, WorkID)
        local Restrictions = ScenarioInfo.Options.RestrictedCategories
        if not Restrictions or not next(Restrictions) then
            return true        
        else
            local restrictedData = import('/lua/ui/lobby/restrictedunitsdata.lua').restrictedUnits
            for i, group in Restrictions do
                local tablefind = table.find
                for j, cat in restrictedData[group].categories do --
                    if WorkID == cat or tablefind(__blueprints[WorkID].Categories, cat) then
                        return false
                    end
                end
            end
        end
        return true
    end,

    BuildRestrictionCategories = function(self)
        local Restrictions = ScenarioInfo.Options.RestrictedCategories
        if not Restrictions or table.getn(Restrictions) == 0 then
            --No restrictions
            return categories.NOTHINGIMPORTANT -- DE NADA
        elseif VersionIsFAF then
            --FAF restrictions
            local restrictedCategories = categories.NOTHINGIMPORTANT
            for id, bool in Game.GetRestrictions().Global do
                restrictedCategories = restrictedCategories + categories[id]
                --Also restrict research items of blocked things.
                --The there is no easy way to do this the other ways.
                --So FAF actually functions better here.
                if __blueprints[id .. 'rnd'] then
                    restrictedCategories = restrictedCategories + categories[id .. 'rnd']
                end
            end
            return restrictedCategories
        else
            local restrictedData = import('/lua/ui/lobby/restrictedunitsdata.lua').restrictedUnits
            local restrictedCategories = categories.NOTHINGIMPORTANT
            for i, group in Restrictions do
                for j, cat in restrictedData[group].categories do
                    restrictedCategories = restrictedCategories + categories[cat]
                end
            end
            return restrictedCategories
        end
    end,

    OnKilled = function(self, instigator, type, overKillRatio)
        local bp = self.BpId and __blueprints[self.BpId] or self:GetBlueprint()
        --Allow restarting of me, the RND item, if I was never finished.
        if self:GetFractionComplete() < 1 then
            RemoveBuildRestriction(self:GetArmy(), categories[bp.BlueprintId] )
        end
        DummyUnit.OnKilled(self, instigator, type, overKillRatio)
    end,

    OnDestroy = function(self)
        local bp = self.BpId and __blueprints[self.BpId] or self:GetBlueprint()
        --Allow restarting of me, the RND item, if I was never finished. In case of reclaim.
        if self:GetFractionComplete() < 1 then
            RemoveBuildRestriction(self:GetArmy(), categories[bp.BlueprintId] )
        end
        DummyUnit.OnDestroy(self)
    end,
}

--------------------------------------------------------------------------------
-- Research Center AI
--------------------------------------------------------------------------------
local Buff = {}
--Wizardry to make FA buff scripts not break the game on original SupCom.
if not string.sub(GetVersion(),1,3) == '1.1' or string.sub(GetVersion(),1,3) == '1.0' then Buff = import('/lua/sim/Buff.lua') else Buff.ApplyBuff = function() end end
--------------------------------------------------------------------------------

ResearchFactoryUnit = Class(FactoryUnit) {	
	
    
	
    SetupComplete = true,

    OnPreCreate = function(self)
        FactoryUnit.OnPreCreate(self)
        if not self.BpId then
            self.BpId = self:GetBlueprint().BlueprintId
        end        
    end,

    OnStartBeingBuilt = function(self, creator, layer)
        local AIBrain = self:GetAIBrain()
        if AIBrain.BrainType ~= 'Human' and AIBrain:GetListOfUnits(categories[self.BpId], false)[1] then
            self:Destroy()
        end
        FactoryUnit.OnStartBeingBuilt(self, creator, layer)
    end,

    OnStartBuild = function(self, unitBeingBuilt, order)
     	self:ChangeBlinkingLights('Yellow')
     	local bp = unitBeingBuilt:GetBlueprint()   		
        StructureUnit.OnStartBuild(self, unitBeingBuilt, order )
        self.BuildingUnit = true        
        self.FactoryBuildFailed = false
        self.MaintenceUnit[1]:SetConsumptionPerSecondEnergy(self.MaintenceConsumption) 
        --LOG(self.MaintenceConsumption)            
        self:SetMaintenanceConsumptionInactive()
        self.MaintenceUnit[1]:SetConsumptionActive(true)
    end,
   		
    OnStopBeingBuilt = function(self, builder, layer)
        --If we're an AI
        local AIBrain = self:GetAIBrain()
        if AIBrain.BrainType ~= 'Human' then
            self.ResearchThread = self:ForkThread(self.ResearchThread) --Create the research thread
            self:AICheatsBuffs()                 --CHEAT!
        end
        self.MaintenceUnit = {}
        self.MaintenceConsumption = self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergy or 0
        --LOG(self.MaintenceConsumption)       
        local myOrientation = self:GetOrientation()
        local location = self:GetPosition()           
        local maintenceUnit = CreateUnit('bsb00021',  self:GetArmy(), location[1], location[2], location[3]+2, myOrientation[1], myOrientation[2], myOrientation[3], myOrientation[4], 'Land') 
        table.insert(self.MaintenceUnit, maintenceUnit)
        maintenceUnit:SetParent(self, self:GetBlueprint().BlueprintId)
        maintenceUnit:SetCreator(self)         
        maintenceUnit:SetConsumptionActive(false)
        self.Trash:Add(maintenceUnit)
        FactoryUnit.OnStopBeingBuilt(self, builder, layer)       

    end,

    OnStopBuild = function(self, unitbuilding, order)
        --Give buff based on what we researched        
        if unitbuilding.GetFractionComplete and unitbuilding:GetFractionComplete() == 1 then
            local n = EntityCategoryContains(categories.EXPERIMENTAL, unitbuilding) and 5 or
                      EntityCategoryContains(categories.TECH3, unitbuilding) and 3 or
                      EntityCategoryContains(categories.TECH2, unitbuilding) and 2 or 1
            Buff.ApplyBuff(self, 'ResearchItemBuff'..n)
        end
        
        self.MaintenceUnit[1]:SetConsumptionPerSecondEnergy(self.MaintenceConsumption)           
        self:SetMaintenanceConsumptionActive()
        self.MaintenceUnit[1]:SetConsumptionActive(false)
        FactoryUnit.OnStopBuild(self, unitbuilding, order ) 
        self.MaintenceConsumption = self:GetConsumptionPerSecondEnergy()       
    end,                
       

    UpgradingState = State(FactoryUnit.UpgradingState) {
        OnStopBuild = function(self, unitbuilding, order)
            --Pass on buffs to the replacement
            if unitbuilding.GetFractionComplete and unitbuilding:GetFractionComplete() == 1 and order == 'Upgrade' then
                if self.Buffs.BuffTable.RESEARCH then
                    for buff, data in self.Buffs.BuffTable.RESEARCH do
                        if Buffs[buff] then --Ensure that the data structure is the same as we are expecting.
                            for i = 1, (data.Count or 1) do
                                Buff.ApplyBuff(unitbuilding, buff)
                            end
                        end
                    end
                end
            end
            FactoryUnit.UpgradingState.OnStopBuild(self, unitbuilding, order)
        end,
    },

    ----------------------------------------------------------------------------
    -- AI research control
    ----------------------------------------------------------------------------

    -- Persistent research thread
    -- "Decides" when to do research
        -- Checks every 5 seconds if we are idle
        -- Checks with the AI brain if we're allowed to research
        -- then research
    ResearchThread = function(self)
        local AIBrain = self:GetAIBrain()
        -- BrewRND (LOUD-AI research manager) was removed from the mod; M28 drives the lab via M28Factory.lua instead.
        if not AIBrain.BrewRND then return end
        while not self.Dead and not AIBrain.BrewResearchIsComplete and AIBrain.BrewRND and AIBrain.BrewRND.IsResearchRemaining(AIBrain) do
            if self:IsIdleState() and AIBrain.BrewRND.IsAbleToResearch(AIBrain) then
                self:Research()
                coroutine.yield(10)
            else
                coroutine.yield(100)
            end
        end
        WARN("An AI has finished researching.")
    end,

    -- Ran every time "ResearchThread" decides we need to research
        -- Prioritises upgrading if it's available
        -- else calls GetResearchItem to decide what to research
    Research = function(self)
        local AIBrain = self:GetAIBrain()
        local bp = self.BpId and __blueprints[self.BpId] or self:GetBlueprint()
        --Upgrade if we can first
        if bp.General.UpgradesTo and __blueprints[bp.General.UpgradesTo] and self:CanBuild(bp.General.UpgradesTo) then
            IssueUpgrade({self}, bp.General.UpgradesTo)
        elseif AIBrain.BrewRND then
            AIBrain:BuildUnit(self, AIBrain.BrewRND.GetResearchItem(AIBrain, self), 1)
        end
    end,

    --Applied OnStopBeingBuilt.
    --Passed on with the other buffs on upgrade.
    AICheatsBuffs = function(self)
        local AIBrain = self:GetAIBrain()
        if AIBrain.CheatEnabled then
            Buff.ApplyBuff(self, 'ResearchAIxBuff')
        else
            Buff.ApplyBuff(self, 'ResearchAIBuff')
        end
    end
}

local EffectUtil = import('/lua/EffectUtilities.lua')


ConstructionStructureUnit = Class(StructureUnit) {
    OnCreate = function(self)
        -- Structure stuff
        StructureUnit.OnCreate(self)

        --Construction stuff
        local bp = self:GetBlueprint()
        self.EffectsBag = {}
        if bp.General.BuildBones then
            self:SetupBuildBones()
        end

        -- Save build effect bones for faster access when creating build effects
        self.BuildEffectBones = bp.General.BuildBones.BuildEffectBones

        if bp.Display.AnimationOpen or bp.Display.AnimationBuild then
            self.BuildingOpenAnim = bp.Display.AnimationOpen or bp.Display.AnimationBuild
        end
        if self.BuildingOpenAnim then
            self.AnimationManipulator = CreateAnimator(self)
            self.AnimationManipulator:PlayAnim(self.BuildingOpenAnim, false):SetRate(0)
            self.Trash:Add(self.AnimationManipulator)
            if self.BuildArmManipulator then
                self.BuildArmManipulator:Disable()
            end
        end

        self.BuildingUnit = false
    end,

    OnStartBuild = function(self, unitBeingBuilt, order )
        self.UnitBeingBuilt = unitBeingBuilt
        self.UnitBuildOrder = order
        self.BuildingUnit = true
        if self.AnimationManipulator then
            self.AnimationManipulator:SetRate(1)
        end
        StructureUnit.OnStartBuild(self,unitBeingBuilt, order)
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
        -- If created with F2 on land, then play the transform anim.
        if self:GetCurrentLayer() == 'Water' then
            self.TerrainLayerTransitionThread = self:ForkThread(self.TransformThread, true)
        end
    end,

    -- This will only be called if not in StructureUnit's upgrade state
    OnStopBuild = function(self, unitBeingBuilt)
        StructureUnit.OnStopBuild(self, unitBeingBuilt)

        self.UnitBeingBuilt = nil
        self.UnitBuildOrder = nil

        if self.BuildingOpenAnimManip and self.BuildArmManipulator then
            self.StoppedBuilding = true
        elseif self.BuildingOpenAnimManip then
            self.AnimationManipulator:SetRate(-1)
        end

        self.BuildingUnit = false
    end,

    OnPaused = function(self)
        --When factory is paused take some action
        self:StopUnitAmbientSound( 'ConstructLoop' )
        StructureUnit.OnPaused(self)
        if self.BuildingUnit then
            self.StopBuildingEffects(self, self:GetUnitBeingBuilt())
        end
    end,

    OnUnpaused = function(self)
        if self.BuildingUnit then
            self:PlayUnitAmbientSound( 'ConstructLoop' )
            self.StartBuildingEffects(self, self:GetUnitBeingBuilt(), self.UnitBuildOrder)
        end
        StructureUnit.OnUnpaused(self)
    end,

    WaitForBuildAnimation = function(self, enable)
        if self.BuildArmManipulator then
            WaitFor(self.BuildingOpenAnimManip)
            if enable then
                self.BuildArmManipulator:Enable()
            end
        end
    end,

    OnPrepareArmToBuild = function(self)
        StructureUnit.OnPrepareArmToBuild(self)

        if self.BuildingOpenAnimManip then
            self.BuildingOpenAnimManip:SetRate(self:GetBlueprint().Display.AnimationBuildRate or 1)
            if self.BuildArmManipulator then
                self.StoppedBuilding = nil
                ForkThread( self.WaitForBuildAnimation, self, true )
            end
        end
    end,

    OnStopBuilderTracking = function(self)
        StructureUnit.OnStopBuilderTracking(self)

        if self.StoppedBuilding then
            self.StoppedBuilding = nil
            self.BuildArmManipulator:Disable()
            self.BuildingOpenAnimManip:SetRate(-(self:GetBlueprint().Display.AnimationBuildRate or 1))
        end
    end,

    CheckBuildRestriction = function(self, target_bp)
        return self:CanBuild(target_bp.BlueprintId)
    end,

    CreateReclaimEffects = function( self, target )
        EffectUtil.PlayReclaimEffects( self, target, self.BuildEffectBones or {0,}, self.ReclaimEffectsBag )
    end,

    CreateReclaimEndEffects = function( self, target )
        EffectUtil.PlayReclaimEndEffects( self, target )
    end,

    CreateCaptureEffects = function( self, target )
        EffectUtil.PlayCaptureEffects( self, target, self.BuildEffectBones or {0,}, self.CaptureEffectsBag )
    end,
}


-- === M28AI hook merged (was separate M28AI mod; paths rewritten in Phase 2) ===
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by maudlin27.
--- DateTime: 13/08/2022 18:01
---
---
local M28Events = import('/mods/M&B/lua/AI/M28Events.lua')
--safeGetGlobal provided by chatGPT
local function safeGetGlobal(varName)
    local success, value = pcall(function() return _G[varName] end)
    if success then
        return value
    else
        return nil
    end
end

local M28OldACUUnit = safeGetGlobal('ACUUnit') or function()  end
if safeGetGlobal('ACUUnit') then
    _G.ACUUnit = Class(M28OldACUUnit) {
        OnKilled = function(self, instigator, type, overkillRatio)
            M28Events.OnKilled(self, instigator, type, overkillRatio)
            M28OldACUUnit.OnKilled(self, instigator, type, overkillRatio)
        end,
        CreateEnhancement = function(self, enh)
            ForkThread(M28Events.OnEnhancementComplete, self, enh)
            return M28OldACUUnit.CreateEnhancement(self, enh)
        end
    }
end

--NOTE: The below may not be needed for LOUD - added to try and resovle issue with Unit.lua not working, but when switched the Unit.lua hook of OnCreate to earlier on it resolved
--[[
local M28StructureUnit = safeGetGlobal('StructureUnit') or function()  end
if safeGetGlobal('StructureUnit') then
    _G.StructureUnit = Class(M28StructureUnit) {
        OnKilled = function(self, instigator, type, overkillRatio)
            LOG('StructureUnit OnKilled from default.units.lua')
            M28Events.OnKilled(self, instigator, type, overkillRatio)
            M28StructureUnit.OnKilled(self, instigator, type, overkillRatio)
        end,
        CreateEnhancement = function(self, enh)
            LOG('StructureUnit CreateEnhancement from default.units.lua')
            ForkThread(M28Events.OnEnhancementComplete, self, enh)
            return M28StructureUnit.CreateEnhancement(self, enh)
        end,
        OnReclaimed = function(self, reclaimer)
            LOG('StructureUnit OnReclaimed from default.units.lua')
            M28Events.OnKilled(self, reclaimer)
            M28StructureUnit.OnReclaimed(self, reclaimer)
        end,
        OnDecayed = function(self)
            LOG('StructureUnit OnDecayed from default.units.lua')
            LOG('OnDecayed: Time='..GetGameTimeSeconds()..'; self.UnitId='..(self.UnitId or 'nil'))
            M28Events.OnUnitDeath(self)
            M28StructureUnit.OnDecayed(self)
        end,
        OnKilledUnit = function(self, unitKilled, massKilled)
            LOG('StructureUnit OnKilledUnit from default.units.lua')
            M28Events.OnKilled(unitKilled, self)
            M28StructureUnit.OnKilledUnit(self, unitKilled, massKilled)
        end,
        OnDestroy = function(self)
            LOG('StructureUnit OnDestroy from default.units.lua')
            M28Events.OnUnitDeath(self) --Any custom code we want to run
            M28StructureUnit.OnDestroy(self) --Normal code
        end,
        OnDamage = function(self, instigator, amount, vector, damageType)
            LOG('StructureUnit OnDamage from default.units.lua')
            M28StructureUnit.OnDamage(self, instigator, amount, vector, damageType)
            M28Events.OnDamaged(self, instigator) --Want this after just incase our code messes things up
        end,
        OnSiloBuildEnd = function(self, weapon)
            LOG('StructureUnit OnSiloBuildEnd from default.units.lua')
            M28StructureUnit.OnSiloBuildEnd(self, weapon)
            M28Events.OnMissileBuilt(self, weapon)
        end,
        OnStartBuild = function(self, built, order, ...)
            LOG('StructureUnit OnStartBuild from default.units.lua')
            ForkThread(M28Events.OnConstructionStarted, self, built, order)
            return M28StructureUnit.OnStartBuild(self, built, order, unpack(arg))
        end,
        OnStartReclaim = function(self, target)
            LOG('StructureUnit OnStartReclaim from default.units.lua')
            ForkThread(M28Events.OnReclaimStarted, self, target)
            return M28StructureUnit.OnStartReclaim(self, target)
        end,
        OnStopReclaim = function(self, target)
            LOG('StructureUnit OnStopReclaim from default.units.lua')
            ForkThread(M28Events.OnReclaimFinished, self, target)
            return M28StructureUnit.OnStopReclaim(self, target)
        end,

        OnStopBuild = function(self, unit)
            LOG('StructureUnit OnStopBuild from default.units.lua')
            if unit and not(unit.Dead) and unit.GetFractionComplete and unit:GetFractionComplete() == 1 then
                ForkThread(M28Events.OnConstructed, self, unit)
            end
            return M28StructureUnit.OnStopBuild(self, unit)
        end,

        OnAttachedToTransport = function(self, transport, bone)
            ForkThread(M28Events.OnTransportLoad, self, transport, bone)
            return M28StructureUnit.OnAttachedToTransport(self, transport, bone)
        end,
        OnDetachedFromTransport = function(self, transport, bone)
            ForkThread(M28Events.OnTransportUnload, self, transport, bone)
            return M28StructureUnit.OnDetachedFromTransport(self, transport, bone)
        end,
        OnDetectedBy = function(self, index)

            ForkThread(M28Events.OnDetectedBy, self, index)
            return M28StructureUnit.OnDetectedBy(self, index)
        end,
        OnCreate = function(self)
            M28StructureUnit.OnCreate(self)
            ForkThread(M28Events.OnCreate, self)
        end,
        CreateEnhancement = function(self, enh)
            ForkThread(M28Events.OnEnhancementComplete, self, enh)
            return M28StructureUnit.CreateEnhancement(self, enh)
        end,
        OnMissileImpactTerrain = function(self, target, position)
            ForkThread(M28Events.OnMissileImpactTerrain, self, target, position)
            return M28StructureUnit.OnMissileImpactTerrain(self, target, position)
        end,
        OnMissileIntercepted = function(self, target, defense, position)
            ForkThread(M28Events.OnMissileIntercepted, self, target, defense, position)
            return M28StructureUnit.OnMissileIntercepted(self, target, defense, position)
        end,
        OnTeleportUnit = function(self, teleporter, location, orientation)
            ForkThread(M28Events.OnTeleportComplete, self, teleporter, location, orientation)
            return M28StructureUnit.OnTeleportUnit(self, teleporter, location, orientation)
        end,
        InitiateTeleportThread = function(self, teleporter, location, orientation)
            ForkThread(M28Events.OnStartTeleport, self, teleporter, location, orientation)
            return M28StructureUnit.InitiateTeleportThread(self, teleporter, location, orientation)
        end,
    }
end

local M28MobileUnit = safeGetGlobal('MobileUnit') or function()  end
if safeGetGlobal('MobileUnit') then
    _G.MobileUnit = Class(M28MobileUnit) {
        OnKilled = function(self, instigator, type, overkillRatio)
            M28Events.OnKilled(self, instigator, type, overkillRatio)
            M28MobileUnit.OnKilled(self, instigator, type, overkillRatio)
        end,
        CreateEnhancement = function(self, enh)
            ForkThread(M28Events.OnEnhancementComplete, self, enh)
            return M28MobileUnit.CreateEnhancement(self, enh)
        end,
        OnReclaimed = function(self, reclaimer)
            M28Events.OnKilled(self, reclaimer)
            M28MobileUnit.OnReclaimed(self, reclaimer)
        end,
        OnDecayed = function(self)
            LOG('OnDecayed: Time='..GetGameTimeSeconds()..'; self.UnitId='..(self.UnitId or 'nil'))
            M28Events.OnUnitDeath(self)
            M28MobileUnit.OnDecayed(self)
        end,
        OnKilledUnit = function(self, unitKilled, massKilled)
            M28Events.OnKilled(unitKilled, self)
            M28MobileUnit.OnKilledUnit(self, unitKilled, massKilled)
        end,
        OnDestroy = function(self)
            M28Events.OnUnitDeath(self) --Any custom code we want to run
            M28MobileUnit.OnDestroy(self) --Normal code
        end,
        OnDamage = function(self, instigator, amount, vector, damageType)
            M28MobileUnit.OnDamage(self, instigator, amount, vector, damageType)
            M28Events.OnDamaged(self, instigator) --Want this after just incase our code messes things up
        end,
        OnSiloBuildEnd = function(self, weapon)
            M28MobileUnit.OnSiloBuildEnd(self, weapon)
            M28Events.OnMissileBuilt(self, weapon)
        end,
        OnStartBuild = function(self, built, order, ...)
            ForkThread(M28Events.OnConstructionStarted, self, built, order)
            return M28MobileUnit.OnStartBuild(self, built, order, unpack(arg))
        end,
        OnStartReclaim = function(self, target)
            ForkThread(M28Events.OnReclaimStarted, self, target)
            return M28MobileUnit.OnStartReclaim(self, target)
        end,
        OnStopReclaim = function(self, target)
            ForkThread(M28Events.OnReclaimFinished, self, target)
            return M28MobileUnit.OnStopReclaim(self, target)
        end,

        OnStopBuild = function(self, unit)
            if unit and not(unit.Dead) and unit.GetFractionComplete and unit:GetFractionComplete() == 1 then
                ForkThread(M28Events.OnConstructed, self, unit)
            end
            return M28MobileUnit.OnStopBuild(self, unit)
        end,

        OnAttachedToTransport = function(self, transport, bone)
            ForkThread(M28Events.OnTransportLoad, self, transport, bone)
            return M28MobileUnit.OnAttachedToTransport(self, transport, bone)
        end,
        OnDetachedFromTransport = function(self, transport, bone)
            ForkThread(M28Events.OnTransportUnload, self, transport, bone)
            return M28MobileUnit.OnDetachedFromTransport(self, transport, bone)
        end,
        OnDetectedBy = function(self, index)

            ForkThread(M28Events.OnDetectedBy, self, index)
            return M28MobileUnit.OnDetectedBy(self, index)
        end,
        OnCreate = function(self)
            M28MobileUnit.OnCreate(self)
            ForkThread(M28Events.OnCreate, self)
        end,
        CreateEnhancement = function(self, enh)
            ForkThread(M28Events.OnEnhancementComplete, self, enh)
            return M28MobileUnit.CreateEnhancement(self, enh)
        end,
        OnMissileImpactTerrain = function(self, target, position)
            ForkThread(M28Events.OnMissileImpactTerrain, self, target, position)
            return M28MobileUnit.OnMissileImpactTerrain(self, target, position)
        end,
        OnMissileIntercepted = function(self, target, defense, position)
            ForkThread(M28Events.OnMissileIntercepted, self, target, defense, position)
            return M28MobileUnit.OnMissileIntercepted(self, target, defense, position)
        end,
        OnTeleportUnit = function(self, teleporter, location, orientation)
            ForkThread(M28Events.OnTeleportComplete, self, teleporter, location, orientation)
            return M28MobileUnit.OnTeleportUnit(self, teleporter, location, orientation)
        end,
        InitiateTeleportThread = function(self, teleporter, location, orientation)
            ForkThread(M28Events.OnStartTeleport, self, teleporter, location, orientation)
            return M28MobileUnit.InitiateTeleportThread(self, teleporter, location, orientation)
        end,
    }
end--]]