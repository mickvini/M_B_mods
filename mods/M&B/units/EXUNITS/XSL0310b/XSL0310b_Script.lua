#****************************************************************************
#**
#**  File     :  /units/XSL0310b/XSL0310b_script.lua
#**
#**  Summary  :  Seraphim Airborne Heavy Bot Script
#**
#**  Copyright © 2009 4th Dimension Mod; EbolaSoup, Resin Smoker, Optimus Prime  All rights reserved.
#****************************************************************************

#### Localy imported files ####
local SAirUnit = import('/lua/seraphimunits.lua').SAirUnit
local EffectTemplate = import('/lua/EffectTemplates.lua')

XSL0310b = Class(SAirUnit) {

	IsDead = function(self)
        return self.Dead
    end,

    OnCreate = function(self, builder, layer)
        SAirUnit. OnCreate(self,builder,layer)
        self.AnimManip = CreateAnimator(self)
        self.AnimManip:SetPrecedence(0)
        self.Trash:Add(self.AnimManip)
        
        ### Gunship transform animation        
        self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationXformFly, false):SetRate(2)
        
        ### Create the takeoff special effects
        self.FxGroundEffect = EffectTemplate.CDisruptorGroundEffect       
 	    for k, v in self.FxGroundEffect do
            CreateAttachedEmitter(self, 'XSL0310', self:GetArmy(), v):ScaleEmitter(0.25)
        end             
    end, 
                            
    OnScriptBitSet = function(self, bit)
        SAirUnit.OnScriptBitSet(self, bit)
        if bit == 1 then
    	    self:ForkThread(self.SpawnLandBot)
    	end
    end,
	
	OnDamage = function(self, instigator, amount, vector, damagetype)
        local damageReduction = 8
        amount = math.ceil(amount * damageReduction)
        SAirUnit.OnDamage(self, instigator, amount, vector, damagetype)
    end,
    
    ReceiveKills = function(self, mass)
        if not self.Dead then
            self.VeterancyDispersal(self, mass)
        end   
    end,    
    
    SpawnLandBot = function(self)
       if not self.Dead then 
          
           ### Disables user control and weapons 
           self:SetUnSelectable(false) 
           
           ### Removes the toggle after activation 
           self:RemoveToggleCap('RULEUTC_WeaponToggle')            
           
           ### Removes all commands
           IssueClearCommands({self}) 
           
           ### Forces the unit to stop and land
           IssueStop({self})
           
           ### Walker transform animation
           self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationXformLand, false):SetRate(2)
           
           ### Allow the animation to finish
           WaitFor(self.AnimManip) 
           
           ### Loops till the unit is on the "Land" Layer
           while not self.Dead and self:GetCurrentLayer() != 'Land' do
               WaitSeconds(0.1)
           end        
                             
           ### Spawns the land bot 
           if not self.Dead then                  
               local myOrientation = self:GetOrientation()
               local location = self:GetPosition()
               local health = self:GetHealth()
               local unitKills = self:GetStat('KILLS', 0).Value               
               local landBot = CreateUnit('XSL0310a1', self:GetArmy(), location[1], location[2], location[3], myOrientation[1], myOrientation[2], myOrientation[3], myOrientation[4], 'Land')
               
               ### Update Stats and veterancy
               if unitKills > 0 then                            
                   landBot.ReceiveKills(landBot, unitKills)
               end
               landBot:SetHealth(self,health)                
                              
               ### Remove the old unit               
               landBot = nil
               self:Destroy()
           end
       end
   end,          
}
TypeClass = XSL0310b