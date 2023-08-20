local TAirUnit = import('/lua/terranunits.lua').TAirUnit

local TANTorpedoAngler = import('/lua/terranweapons.lua').TANTorpedoAngler
local TAAGinsuRapidPulseWeapon = import('/lua/terranweapons.lua').TAAGinsuRapidPulseWeapon

GMEA305 = Class(TAirUnit) {
    Weapons = {
        Torpedo = Class(TANTorpedoAngler) {},
        RightBeam = Class(TAAGinsuRapidPulseWeapon) {},
        LeftBeam = Class(TAAGinsuRapidPulseWeapon) {},
    },
}

TypeClass = GMEA305