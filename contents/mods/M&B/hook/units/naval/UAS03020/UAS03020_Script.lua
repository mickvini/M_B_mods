#****************************************************************************
#**
#**  File     :  /cdimage/units/UAS0302/UAS0302_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Aeon Battleship Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local ASeaUnit = import('/lua/aeonunits.lua').ASeaUnit
local WeaponsFile = import('/lua/aeonweapons.lua')
local ADFCannonOblivionWeapon = WeaponsFile.ADFCannonOblivionWeapon
local AAAZealotMissileWeapon = WeaponsFile.AAAZealotMissileWeapon
local AAMWillOWisp = WeaponsFile.AAMWillOWisp

UAS03020 = Class(ASeaUnit) {
    FxDamageScale = 2,
    DestructionTicks = 400,

    Weapons = {
        BackTurret = Class(ADFCannonOblivionWeapon) {},
        FrontTurret = Class(ADFCannonOblivionWeapon) {},
        MidTurret = Class(ADFCannonOblivionWeapon) {},
        AntiMissile1 = Class(AAMWillOWisp) {},
        AntiMissile2 = Class(AAMWillOWisp) {},
        AntiAirMissiles01 = Class(AAAZealotMissileWeapon) {},
        AntiAirMissiles02 = Class(AAAZealotMissileWeapon) {},
    },
    
    OnCreate = function(self)
        ASeaUnit.OnCreate(self)
        for i = 1, 3 do
            self.Trash:Add(CreateAnimator(self):PlayAnim(self:GetBlueprint().Weapon[i].AnimationOpen))
        end
    end,
}

TypeClass = UAS03020