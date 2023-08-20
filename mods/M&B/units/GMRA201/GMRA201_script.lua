local CAirUnit = import('/lua/cybranunits.lua').CAirUnit

local CIFBombNeutronWeapon = import('/lua/cybranweapons.lua').CIFBombNeutronWeapon
local CIFNaniteTorpedoWeapon = import('/lua/cybranweapons.lua').CIFNaniteTorpedoWeapon

GMRA201 = Class(CAirUnit) {
    Weapons = {
        Bomb = Class(CIFBombNeutronWeapon) {},
        Torpedo = Class(CIFNaniteTorpedoWeapon) {},		
    },
}

TypeClass = GMRA201