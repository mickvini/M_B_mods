local SWalkingLandUnit = import('/lua/seraphimunits.lua').SWalkingLandUnit
local SDFThauCannon = import('/lua/seraphimweapons.lua').SDFThauCannon

WSL0302 = Class(SWalkingLandUnit) {
    Weapons = {
        MainGun = Class(SDFThauCannon) {},
    },
   
}
TypeClass = WSL0302