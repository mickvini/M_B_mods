--M&B bugfix: was MobileUnit - that base class skips the lab research buffs
--(health/speed/damage). LandUnit applies them on OnStopBeingBuilt like every
--other land combat unit.
local SLandUnit = import('/lua/defaultunits.lua').LandUnit

local WeaponsFile = import('/lua/seraphimweapons.lua')
local SDFThauCannon = WeaponsFile.SDFThauCannon


WSL0308 = Class(SLandUnit) {
    Weapons = {
        MainTurret = Class(SDFThauCannon) {},
    },
}
TypeClass = WSL0308