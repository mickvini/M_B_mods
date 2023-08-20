#**************************************************************************** 
#** 
#**  File     :  UEA0206_script.lua 
#**  Author(s):  Resin_Smoker / Vissroid 
#** 
#**  Summary  :  UEF Thrasher Script 
#** 
#**  Copyright © 2009 4th Dimension 
#**************************************************************************** 

#### Localy imported files #### 
local TAirUnit = import('/lua/terranunits.lua').TAirUnit 
local EffectUtil = import('/lua/EffectUtilities.lua') 

#### Weapon local files #### 
local TAirToAirLinkedRailgun = import('/lua/terranweapons.lua').TAirToAirLinkedRailgun 
local ZealotMissileWeapon = import('/lua/aeonweapons.lua').AAAZealot02MissileWeapon 

UEA0206 = Class(TAirUnit) { 
    Weapons = { 
        MachineGun = Class(TAirToAirLinkedRailgun) {}, 
        Missile_L = Class(ZealotMissileWeapon) {}, 
        Missile_R = Class(ZealotMissileWeapon) {}, 
    }, 

### File pathing and special paramiters called ########################### 

    ### Afterburner and exhaust effect pathing 

    BeamAfterBurner = '/effects/emitters/missile_exhaust_fire_beam_01_emit.bp', 
    ExhaustSmoke = '/effects/emitters/missile_smoke_exhaust_02_emit.bp', 
    
########################################################################## 

    OnStopBeingBuilt = function(self,builder,layer)
    TAirUnit.OnStopBeingBuilt(self,builder,layer)    
        if not self:IsDead() then 
            ### Global Varibles 
            self.BeamExhaustEffectsBag = {} 
            self.BurnerActive = false
            self.Evade = false
            self.MyWeapon = self:GetWeaponByLabel('MachineGun')
            self.MyMaxSpeed = self:GetBlueprint().Air.MaxAirspeed
            self.WepRng = self.MyWeapon:GetBlueprint().MaxRadius 
                        
            ### Start of heartbeat event
            self:ForkThread(self.HeartBeatDistanceCheck)
        end 
    end, 
   
    HeartBeatDistanceCheck = function(self)
        while self and not self:IsDead() do
            local myFuel = self:GetFuelRatio()
            ### Make sure we have a target and we have fuel
            if self.MyWeapon:GetCurrentTarget() and myFuel > 0 then
                local myTarget = self.MyWeapon:GetCurrentTarget()
                
                ### Verify that our current target is a valid air target
                if table.find(myTarget:GetBlueprint().Categories,'HIGHALTAIR') and not table.find(myTarget:GetBlueprint().Categories,'EXPERIMENTAL') then
                
                    ### Get the distance to our target
                    local myPos = self:GetPosition()
                    local tarPos = myTarget:GetPosition()
                    local distance = VDist2(myPos[1], myPos[3], tarPos[1], tarPos[3])
                    local myTargetSpeed = myTarget:GetBlueprint().Air.MaxAirspeed

                    ### Sets the fighter max speed to that of the target to help prevent overshoot.
                    if distance <= self.WepRng and self.Evade == false then
                        
                        ### Engine effects clean up 
                        if self.BeamExhaustEffectsBag then                                                   
                            EffectUtil.CleanupEffectBag(self,'BeamExhaustEffectsBag') 
                        end 
                                                                  
                        ### Compute the speed of the target and match it
                        self:SetSpeedMult(myTargetSpeed / self.MyMaxSpeed)
                        self:SetAccMult(1.0)
                        self:SetTurnMult(1.5)
                        
                    ### If our target is out of weapons range then engage afterburner                                          
                    elseif distance > self.WepRng and self.BurnerActive == false then
                        
                        ### Set flag to true 
                        self.BurnerActive = true 
                      
                        ### Kick off Afterburner multi and effects 
                        self:ForkThread(self.Afterburner)      
                    end
                end
            end
            
            ### Delay between checks
            WaitSeconds(0.25)
        end
    end,
    
    OnDamage = function(self, instigator, amount, vector, damagetype) 
        TAirUnit.OnDamage(self, instigator, amount, vector, damagetype) 
        if self:IsDead() == false and instigator and IsUnit(instigator) then 
            local myFuel = self:GetFuelRatio()
            if self.BurnerActive == false and myFuel > 0 then 
                
                ### Set flags to true 
                self.BurnerActive = true 
                self.Evade = true
                
                ### Kick off Afterburner multi and effects 
                self:ForkThread(self.Afterburner)                            
            end    
        end 
    end, 

    Afterburner = function(self) 
        if not self:IsDead() then 
            if self.BeamExhaustEffectsBag then 
                ### Engine effects clean up 
                EffectUtil.CleanupEffectBag(self,'BeamExhaustEffectsBag') 
            end 
            ### Engage Afterburn speed and turn rates 
            self:SetSpeedMult(2.0) 
            self:SetAccMult(2.0) 
            self:SetTurnMult(0.5) 
            
            ### Afterburn effects and smoke 
            table.insert(self.BeamExhaustEffectsBag, CreateBeamEmitterOnEntity( self, 'afterburner', self:GetArmy(), self.BeamAfterBurner):ScaleEmitter(2.0)) 
            table.insert(self.BeamExhaustEffectsBag, CreateAttachedEmitter(self, 'exhaust', self:GetArmy(), self.ExhaustSmoke):ScaleEmitter(0.5)) 
            
            ### Play Afterburner sound effects 
            self:PlayUnitSound('Afterburn') 
            
            ### Get current fuel levels
            local preBurnFuel = self:GetFuelRatio()
            
            ### Duration of Afterburn
            WaitSeconds(2)
            
            ### Get the fuel levels post Afterburner
            local postBurnFuel = self:GetFuelRatio()

            ### Fuel calculations and Afterburn effect clean up
            if not self:IsDead() then
      
                ### Calculate new fuel levels as per *** BIGO's New ASF MOD ***
                local newFuelLvl = preBurnFuel - (10 *(preBurnFuel - postBurnFuel))
                
                if newFuelLvl > 0 then
                    self:SetFuelRatio(newFuelLvl)
                end
            
                if self.BeamExhaustEffectsBag then 
                    ### Engine effects clean up 
                    EffectUtil.CleanupEffectBag(self,'BeamExhaustEffectsBag') 
                end 

                ### Resets the speed and turn rates 
                self:SetSpeedMult(1.0) 
                self:SetAccMult(1.0) 
                self:SetTurnMult(1.0) 
                
                ### Short pause between Afterburns 
                WaitSeconds(2) 
                
                ###Resets Afterburn and Evade triggers      
                if not self:IsDead() then 
                    self.BurnerActive = false
                    self.Evade = false
                end 
            end 
        end 
    end, 
    
    OnKilled = function(self, instigator, type, overkillRatio)
        if self.BeamExhaustEffectsBag then 
            ### Engine effects clean up 
            EffectUtil.CleanupEffectBag(self,'BeamExhaustEffectsBag') 
        end 

        ### Final command to finish off the fighters death event 
        TAirUnit.OnKilled(self, instigator, type, overkillRatio) 
    end, 
    
} 

TypeClass = UEA0206 