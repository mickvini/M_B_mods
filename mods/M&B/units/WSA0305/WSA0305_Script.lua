local SAirUnit = import('/lua/seraphimunits.lua').SAirUnit
local SAALosaareAutoCannonWeapon = import('/lua/seraphimweapons.lua').SAALosaareAutoCannonWeaponAirUnit


WSA0305 = Class(SAirUnit) {
    Weapons = {
        AutoCannon1 = Class(SAALosaareAutoCannonWeapon) {},
        AutoCannon2 = Class(SAALosaareAutoCannonWeapon) {},
    },
}

TypeClass = WSA0305