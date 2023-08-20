local SLandUnit = import('/lua/seraphimunits.lua').SLandUnit
local WeaponsFile = import('/lua/seraphimweapons.lua')
local SDFThauCannon = WeaponsFile.SDFThauCannon
local SDFAireauBolter = WeaponsFile.SDFAireauBolterWeapon
local SANUallCavitationTorpedo = WeaponsFile.SANUallCavitationTorpedo
local EffectUtil = import('/lua/EffectUtilities.lua')
local SAMElectrumMissileDefense = WeaponsFile.SAMElectrumMissileDefense

GMSL312 = Class(SLandUnit) {
    Weapons = {
        MainTurret = Class(SDFThauCannon) {},
        LeftTurret = Class(SDFAireauBolter) {},
        RightTurret = Class(SDFAireauBolter) {},
        AntiMissileLeft = Class(SAMElectrumMissileDefense) {},
        AntiMissileRight = Class(SAMElectrumMissileDefense) {},
    },
}

TypeClass = GMSL312