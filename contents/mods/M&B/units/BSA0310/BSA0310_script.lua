#****************************************************************************
#**
#**  File     :  /cdimage/units/UAA0203/UAA0203_script.lua
#**  Author(s):  Drew Staltman, Gordon Duclos
#**
#**  Summary  :  Seraphim Gunship Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local SAirUnit = import('/lua/seraphimunits.lua').SAirUnit
local SAALosaareAutoCannonWeapon = import('/lua/seraphimweapons.lua').SAALosaareAutoCannonWeaponAirUnit
local SLaanseMissileWeapon = import('/lua/seraphimweapons.lua').SLaanseMissileWeapon
local SDFThauCannon = import('/lua/seraphimweapons.lua').SDFThauCannon

BSA0310 = Class(SAirUnit) {
    Weapons = {
    	MainTurret = Class(SLaanseMissileWeapon) {},
        LeftTurret = Class(SDFThauCannon) {
        	CreateProjectileAtMuzzle = function(self, muzzle)
                local proj = SDFThauCannon.CreateProjectileAtMuzzle(self, muzzle)
                local data = self:GetBlueprint().DamageToShields
                if proj and not proj:BeenDestroyed() then
                    proj:PassData(data)
                end
            end,
        },
        RightTurret = Class(SDFThauCannon) {
        	CreateProjectileAtMuzzle = function(self, muzzle)
                local proj = SDFThauCannon.CreateProjectileAtMuzzle(self, muzzle)
                local data = self:GetBlueprint().DamageToShields
                if proj and not proj:BeenDestroyed() then
                    proj:PassData(data)
                end
            end,
        },
        CenterTurret = Class(SAALosaareAutoCannonWeapon) {},
    },
    OnStopBeingBuilt = function(self, builder, layer)
    SAirUnit.OnStopBeingBuilt(self,builder,layer)
        -- Are we dead?
        if not self.Dead then
 
            -- Start of launch special effects
            self:ForkThread(self.LaunchEffects)
            self:SetMaintenanceConsumptionActive()
            self:ForkThread(self.ResourceThread)
            self:SetVeterancy(5)

            -- Global Varibles--
            self.LaunchExhaustEffectsBag = {}
            self.DeathExhaustEffectsBag = {}
        end
    end,
    ResourceThread = function(self) 
        -- Only respawns the drones if the parent unit is not dead 
    --   LOG('*checkresource')
        if not self.Dead then
            local energy = self:GetAIBrain():GetEconomyStored('Energy')

            -- Check to see if the player has enough mass / energy
            if  energy <= 10 then 

                --Loops to check again
                self:ForkThread(self.KillFactory)

            else
                -- If the above conditions are not met we kill this unit
                self:ForkThread(self.EconomyWaitUnit)
            end
        end    
    end,

    EconomyWaitUnit = function(self)
        if not self.Dead then
        WaitSeconds(4)
    --LOG('*HAVE ENOUGH keep checking')
            if not self.Dead then
                self:ForkThread(self.ResourceThread)
            end
        end
    end,
    
    KillFactory = function(self)
    --LOG('*kill unit')
        self:Kill()
    end,
}
TypeClass = BSA0310