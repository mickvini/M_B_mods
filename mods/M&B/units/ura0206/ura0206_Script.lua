#**************************************************************************** 
#** 
#**  File     :  ura0206_script.lua 
#**  Author(s):  Resin_Smoker / Vissroid / Ebola
#** 
#**  Summary  :  Cybran Vampire Multi-Role Stealth Fighter 
#** 
#**  Copyright © 2009 4th Dimension 
#**************************************************************************** 

#### Localy imported files #### 
local CAirUnit = import('/lua/cybranunits.lua').CAirUnit 
local EffectUtil = import('/lua/EffectUtilities.lua')

#### Weapon local files ####
local CAAAutocannon = import('/lua/cybranweapons.lua').CAAAutocannon 

ura0206 = Class(CAirUnit) { 
    Weapons = {         
        AutoCannon = Class(CAAAutocannon) {    
                                                   
            OnWeaponFired = function(self)
                if not self.unit:IsDead() and self.unit.StealthEnabled == true then 
                    ### Disable cloak and start delay, delay time is equal to 1/2 of weapons rack reload time 
                    self.unit.DelayTime = self.unit:GetWeaponByLabel('AutoCannon'):GetBlueprint().RackReloadTimeout * 0.5 or 2
                    self.unit.WeaponFired = true
                    self.unit:ForkThread(self.unit.StealthDisable)                    
                end                            
            end,                                            
            
            OnLostTarget = function(self)
                ### Reset speed and turn rates
                if self.unit.Dodge == false then
                    self.unit:SetSpeedMult(1.0)                
                    self.unit:SetTurnMult(1.0)
                end
                CAAAutocannon.OnLostTarget(self)
            end,                                
        },                  
    }, 
    
    OnStopBeingBuilt = function(self,builder,layer) 
        CAirUnit.OnStopBeingBuilt(self,builder,layer)      
        ### Global Variables 
        self.BP = self:GetBlueprint() 
        self.DelayReset = (Random(1 , 3) * 0.1)          
        self.DelayTime = self.DelayReset 
         
        ### Global Booleans
        self.DmgMod = false       
        self.StealthEnabled = false
        self.WeaponFired = false         
        self.Dodge = false 

        ### Setup stealth and economy starting conditions
        self:SetMaintenanceConsumptionInactive()
        if self.BP.Intel.StealthStartsOn == true then
            self.ToggleStatus = true
        else
            self.ToggleStatus = false
        end        
        self:ForkThread(self.EconomyHeartBeat)                                                                       
    end,
    
    EconomyHeartBeat = function(self)        
        local eCost = self.BP.Economy.MaintenanceConsumptionPerSecondEnergy           
        while not self:IsDead() do               
        
            ### Short delay between checks
            WaitSeconds(self.DelayTime)       
            if not self:IsDead() then                      
                local econ = self:GetAIBrain():GetEconomyStored('Energy')
              
                ### Stealth control logic
                if econ < eCost or self.ToggleStatus == false then
                    if self.StealthEnabled == true and self.WeaponFired == false then         
                        self:ForkThread(self.StealthDisable)
                    end
                elseif econ > eCost or self.ToggleStatus == true then  
                    if self.StealthEnabled == false and self.WeaponFired == false then             
                        self:ForkThread(self.StealthEnable)                         
                    end
                end                       
                         
                ### Reset speed and turn rates
                if self.Dodge == false then
                    self:SetSpeedMult(1.0)                
                    self:SetTurnMult(1.0)
                end                                          
            
                ### Resets the delay back to default 
                if self.DelayTime > self.DelayReset and self.WeaponFired == false and self.Dodge == false then         
                    self.DelayTime = self.DelayReset 
                elseif self.WeaponFired == true then
                    self.WeaponFired = false   
                elseif self.Dodge == true then
                    self.Dodge = false                       
                end 
                
                if self:GetWeaponByLabel('AutoCannon'):GetCurrentTarget() and self.Dodge == false then 
                    local myWep = self:GetWeaponByLabel('AutoCannon') 
                    local myTarget = myWep:GetCurrentTarget() 
                    local myTargetSpeed = myTarget:GetBlueprint().Air.MaxAirspeed 
                    local myTargetTurn = myTarget:GetBlueprint().Air.KTurn 
                        
                    ### Get the distance to our target
                    local myPos = self:GetPosition()
                    local tarPos = myTarget:GetPosition()
                    local distance = VDist2(myPos[1], myPos[3], tarPos[1], tarPos[3])                        

                    ### Adjust speed and turn rates if within range
                    if distance <= (myWep:GetBlueprint().MaxRadius * 0.5) then
                        if table.find(myTarget:GetBlueprint().Categories,'HIGHALTAIR') and not table.find(myTarget:GetBlueprint().Categories,'EXPERIMENTAL') then 
                           self:SetSpeedMult(myTargetSpeed / self:GetBlueprint().Air.MaxAirspeed) 
                            self:SetTurnMult(myTargetTurn / self:GetBlueprint().Air.KTurn)                          
                        end
                    else
                        self:SetSpeedMult(1.0)                
                        self:SetTurnMult(1.0)                   
                    end
                end                                      
            end                          
        end
    end, 
            
    OnScriptBitSet = function(self, bit)
        ### UI Toggle that turns Stealth off
        if bit == 6 then
           self.ToggleStatus = false                   
        end
        CAirUnit.OnScriptBitSet(self, bit)
    end,     
     
    OnScriptBitClear = function(self, bit)
        ### UI Toggle that turns Stealth on    
       if bit == 6 then
            self.ToggleStatus = true
       end
       CAirUnit.OnScriptBitClear(self, bit)
    end,    
    
    StealthEnable = function(self)
        if not self:IsDead() and self.StealthEnabled == false then 
            self.StealthEnabled = true
            self:SetMaintenanceConsumptionActive() 
            self:EnableUnitIntel('Cloak') 
            self:SetMaintenanceConsumptionActive()
            self:SetMesh('/mods/4th_Dimension_212/units/ura0206/ura0206_stealth_mesh', true)
        end
    end,    
    
    StealthDisable = function(self)
        if not self:IsDead() and self.StealthEnabled == true then    
            self.StealthEnabled = false          
            self:SetMaintenanceConsumptionInactive() 
            self:DisableUnitIntel('Cloak') 
            self:SetMaintenanceConsumptionInactive() 
            self:SetMesh('/mods/4th_Dimension_212/units/ura0206/ura0206_standard_mesh', true)         
        end
    end,     
        
    OnDamage = function(self, instigator, amount, vector, damagetype) 
        CAirUnit.OnDamage(self, instigator, amount, vector, damagetype) 
        if not self:IsDead() and instigator and IsUnit(instigator) then 
            ### Increase speed and turn rates to dodge further fire 
            if self.Dodge == false then
                self:SetSpeedMult(1.2)
                self:SetTurnMult(2.0)                
                self.DelayTime = 2.5
                self.Dodge = true
            end 
            if self.StealthEnabled == true then 
                ### Disables cloak if required 
                self:ForkThread(self.StealthDisable) 
            end    
        end 
    end, 
          
    OnKilled = function(self, instigator, type, overkillRatio) 
        if self.CloakEnabled == true then 
            ### Disables cloak if required 
            self:ForkThread(self.MyCloakDisable) 
        end   
        
        ### Nil all Globals
        self.BP = nil
        self.DelayReset = nil
        self.DelayTime = nil
         
        ### Global Booleans
        self.DmgMod = nil       
        self.StealthEnabled = nil
        self.WeaponFired = nil         
        self.Dodge = nil                

        ### Final command to finish off the fighters death event 
        CAirUnit.OnKilled(self, instigator, type, overkillRatio) 
    end,             
} 
TypeClass = ura0206 