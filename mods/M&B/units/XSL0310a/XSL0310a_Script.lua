#****************************************************************************
#**
#**  File     :  /units/XSL0310a/XSL0310a_script.lua
#**
#**  Summary  :  Seraphim Airborne Heavy Bot Script
#**
#**  Copyright © 2009 4th Dimension Mod; EbolaSoup, Resin Smoker, Optimus Prime  All rights reserved.
#****************************************************************************

#### Localy imported files ####
local SWalkingLandUnit = import('/lua/seraphimunits.lua').SWalkingLandUnit

#### Weapon local files ####
local WeaponsFile = import('/lua/seraphimweapons.lua')
local xsl0310a_LightningWeapon = import('/mods/m&b/lua/weapons.lua').xsl0310a_LightningWeapon
local SDFThauCannon = WeaponsFile.SDFThauCannon
local SIFThunthoCannonWeapon = import('/lua/seraphimweapons.lua').SIFThunthoCannonWeapon
local SLaanseMissileWeapon = WeaponsFile.SLaanseMissileWeapon

XSL0310a = Class(SWalkingLandUnit) {
    Weapons = {
		LeftGun = Class(xsl0310a_LightningWeapon) {},
		
		RightGun = Class(SDFThauCannon) {},
		
		MissileRack = Class(SLaanseMissileWeapon) {},          
    },
    
    OnCreate = function(self, builder, layer)
        SWalkingLandUnit. OnCreate(self,builder,layer)
        self.MotionStatus = nil
    end,     
        
    OnScriptBitSet = function(self, bit)
        SWalkingLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 then    	    
    	    self:ForkThread(self.SpawnFlyingBot)    	    
    	end
    end,
    
    ReceiveKills = function(self, unitKills)
        if not self:IsDead() then
            self.AddKills(self, unitKills) 
        end   
    end,  
    
    OnMotionHorzEventChange = function(self, new, old) 
        SWalkingLandUnit.OnMotionHorzEventChange(self, new, old)     
        if not self:IsDead() and new != old then
            self.MotionStatus = new
        end                
    end,      
    
    SpawnFlyingBot = function(self)
       if not self:IsDead() then  
                
           ### Disables user control and weapons 
           self:SetUnSelectable(false) 
           self:SetWeaponEnabledByLabel('LeftGun', false)
           self:SetWeaponEnabledByLabel('RightGun', false)
           self:SetWeaponEnabledByLabel('MissileRack', false) 
           
           ### Removes the toggle after activation 
           self:RemoveToggleCap('RULEUTC_WeaponToggle')                                 
           
           ### Removes all commands
           IssueClearCommands({self}) 
           
           ### Forces the land bot to stop
           IssueStop({self})
           
           ### Waits for the bot to come to a complete stop before transforming
           while not self:IsDead() and self.MotionStatus != 'Stopped' and self.MotionStatus != nil  do          
               WaitSeconds(0.1)
           end                    
                                
           ### Spawns the flying bot                  
           local myOrientation = self:GetOrientation()
           local location = self:GetPosition()
           local health = self:GetHealth()
           local unitKills = self:GetStat('KILLS', 0).Value        
           local flyingBot = CreateUnit('XSL0310b', self:GetArmy(), location[1], location[2], location[3], myOrientation[1], myOrientation[2], myOrientation[3], myOrientation[4], 'Air')
           
           ### Update Stats and veterancy
           if unitKills > 0 then
               flyingBot.ReceiveKills(flyingBot, unitKills) 
           end  
           flyingBot:SetHealth(self,health)                
                    
           ### Remove the old unit
           flyingBot = nil
           self:Destroy()
       end
   end,                
}
TypeClass = XSL0310a