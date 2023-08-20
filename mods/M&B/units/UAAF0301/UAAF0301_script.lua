local AAirUnit = import('/lua/aeonunits.lua').AAirUnit
local WeaponsFile = import ('/lua/aeonweapons.lua')
local AAAZealotMissileWeapon = import('/lua/aeonweapons.lua').AAAZealotMissileWeapon
local AAAAutocannonQuantumWeapon = import('/lua/aeonweapons.lua').AAAAutocannonQuantumWeapon

UAAF0301 = Class(AAirUnit) {
    Weapons = {
        AutoCannon1 = Class(AAAAutocannonQuantumWeapon) {},
        Missile = Class(AAAZealotMissileWeapon) {},
        Missile2 = Class(AAAZealotMissileWeapon) {},
    },
}

TypeClass = UAAF0301