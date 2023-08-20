local CAirUnit = import('/lua/cybranunits.lua').CAirUnit

local Weapon = import('/lua/sim/Weapon.lua').Weapon
local WeaponFile = import('/lua/sim/defaultweapons.lua')
local CybranWeaponsFile = import('/lua/cybranweapons.lua')

local CAAMissileNaniteWeapon = import('/lua/cybranweapons.lua').CAAMissileNaniteWeapon
local CAAAutocannon = import('/lua/cybranweapons.lua').CAAAutocannon

WRA0305 = Class(CAirUnit) {
    ExhaustBones = { 'Exhaust', },
    ContrailBones = { 'Contrail_L', 'Contrail_R','Contrail_L01', 'Contrail_R01', },
    Weapons = {
        Missiles = Class(CAAMissileNaniteWeapon) {},
        AutoCannon = Class(CAAAutocannon) {},
    },
   
}

TypeClass = WRA0305
