#****************************************************************************
#**
#**  File     :  /cdimage/units/UAS0202/UAS0202_script.lua
#**  Author(s):  David Tomandl
#**
#**  Summary  :  Aeon Cruiser Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AeonWeapons = import('/lua/aeonweapons.lua')
local ASeaUnit = import('/lua/aeonunits.lua').ASeaUnit
local WeaponFile = import('/lua/terranweapons.lua')
local AAAZealotMissileWeapon = AeonWeapons.AAAZealotMissileWeapon
local ADFCannonOblivionWeapon = AeonWeapons.ADFCannonOblivionWeapon
local TDFGaussCannonWeapon = WeaponFile.TDFGaussCannonWeapon
local AANChronoTorpedoWeapon = AeonWeapons.AANChronoTorpedoWeapon
local AAASonicPulseBatteryWeapon = AeonWeapons.AAASonicPulseBatteryWeapon

BROST1DESTR = Class(ASeaUnit) {
    Weapons = {
        AAGun = Class(AAASonicPulseBatteryWeapon) {
            FxMuzzleScale = 2.25,
        },
        AAGun2 = Class(AAASonicPulseBatteryWeapon) {
            FxMuzzleScale = 2.25,
        },
        FrontTurret = Class(ADFCannonOblivionWeapon) {},
        FrontTurret2 = Class(ADFCannonOblivionWeapon) {},
        torp01 = Class(AANChronoTorpedoWeapon) {},
        autoattack = Class(TDFGaussCannonWeapon) {
			            FxMuzzleFlashScale = 0.0, 
    },
    },

    BackWakeEffect = {},

    OnStopBeingBuilt = function(self,builder,layer)
        ASeaUnit.OnStopBeingBuilt(self,builder,layer)
        self.Trash:Add(CreateRotator(self, 'Sonar', 'y', nil, 90, 0, 0))
        self.Trash:Add(CreateRotator(self, 'Sonar01', 'y', nil, 130, 0, 0))

        ASeaUnit.OnStopBeingBuilt(self,builder,layer)
      
      if self:GetAIBrain().BrainType == 'Human' and IsUnit(self) then
         self:SetWeaponEnabledByLabel('autoattack', false)
      else
         self:SetWeaponEnabledByLabel('autoattack', true)
      end      
    end,
}

TypeClass = BROST1DESTR