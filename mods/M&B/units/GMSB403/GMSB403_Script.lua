local SStructureUnit = import('/lua/seraphimunits.lua').SStructureUnit
local SIFSuthanusArtilleryCannon = import('/lua/seraphimweapons.lua').SIFSuthanusArtilleryCannon
local SIFCommanderDeathWeapon = import('/lua/seraphimweapons.lua').SIFCommanderDeathWeapon

GMSB403 = Class(SStructureUnit) {
    Weapons = {
        DeathWeapon = Class(SIFCommanderDeathWeapon) {},
        MainGun = Class(SIFSuthanusArtilleryCannon) {
		CreateProjectileAtMuzzle = function(self, muzzle)
		numProjectiles = 5
		for i = 0, (numProjectiles -1) do
		local proj = SIFSuthanusArtilleryCannon.CreateProjectileAtMuzzle(self, muzzle)
		end
	end,
        },
    },
}
TypeClass = GMSB403