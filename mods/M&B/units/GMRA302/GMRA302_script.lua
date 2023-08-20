local CAirUnit = import('/lua/cybranunits.lua').CAirUnit

local Weapon = import('/lua/sim/Weapon.lua').Weapon
local WeaponFile = import('/lua/sim/defaultweapons.lua')
local CybranWeaponsFile = import('/lua/cybranweapons.lua')

local CollisionBeamFile = import('/lua/defaultcollisionbeams.lua')
local DefaultBeamWeapon = WeaponFile.DefaultBeamWeapon

CDFMicrowaveLaserGenerator = Class(DefaultBeamWeapon) {
    BeamType = CollisionBeamFile.MicrowaveLaserCollisionBeam02,
    FxMuzzleFlash = {},
}


GMRA302 = Class(CAirUnit) {
    Weapons = {
        Turret1 = Class(CDFMicrowaveLaserGenerator) {
            FxMuzzleFlash = {},
            OnWeaponFired = function(self)
                if self.unit:IsIntelEnabled('Cloak') then
                    self:ForkThread(self.DecloakForTimeout)
                end
            end,
			
            DecloakForTimeout = function(self)
                self.unit:DisableUnitIntel('Cloak')
                WaitSeconds(self.unit:GetBlueprint().Intel.RecloakAfterFiringDelay or 10)
                self.unit:EnableUnitIntel('Cloak')
            end, 
        },
        Turret2 = Class(CDFMicrowaveLaserGenerator) {
            FxMuzzleFlash = {},
            OnWeaponFired = function(self)
                if self.unit:IsIntelEnabled('Cloak') then
                    self:ForkThread(self.DecloakForTimeout)
                end
            end,
			
            DecloakForTimeout = function(self)
                self.unit:DisableUnitIntel('Cloak')
                WaitSeconds(self.unit:GetBlueprint().Intel.RecloakAfterFiringDelay or 10)
                self.unit:EnableUnitIntel('Cloak')
            end, 
        },
    },

    OnStopBeingBuilt = function(self,builder,layer)
        CAirUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetMaintenanceConsumptionActive()
        self:RequestRefreshUI()
    end,
}

TypeClass = GMRA302