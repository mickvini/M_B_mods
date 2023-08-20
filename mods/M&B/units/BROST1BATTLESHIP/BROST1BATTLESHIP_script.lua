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
local ADFCannonQuantumWeapon = AeonWeapons.ADFCannonQuantumWeapon
local TDFGaussCannonWeapon = WeaponFile.TDFGaussCannonWeapon

BROST1BATTLESHIP = Class(ASeaUnit) {
    Weapons = {
        FrontTurret = Class(ADFCannonQuantumWeapon) {},
        FrontTurret2 = Class(ADFCannonQuantumWeapon) {},
        FrontTurret3 = Class(ADFCannonQuantumWeapon) {},
        FrontTurret4 = Class(ADFCannonQuantumWeapon) {},
        AntiAirMissiles01 = Class(AAAZealotMissileWeapon) {},
        AntiAirMissiles02 = Class(AAAZealotMissileWeapon) {},
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

TypeClass = BROST1BATTLESHIP