local SSeaUnit = import('/lua/defaultunits.lua').SeaUnit

local SIFSuthanusArtilleryCannon = import('/lua/seraphimweapons.lua').SIFSuthanusMobileArtilleryCannon
local SAAOlarisCannonWeapon = import('/lua/seraphimweapons.lua').SAAOlarisCannonWeapon

BSS0206 = Class(SSeaUnit) {
    Weapons = {
	
        DeckGun1 = Class(SIFSuthanusArtilleryCannon) {},
        DeckGun2 = Class(SIFSuthanusArtilleryCannon) {},
		AAGun = Class(SAAOlarisCannonWeapon) {},
		
    },

    BackWakeEffect = {},
}

TypeClass = BSS0206