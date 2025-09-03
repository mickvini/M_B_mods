local SLandUnit = import('/lua/seraphimunits.lua').SLandUnit
local SDFUnstablePhasonBeam = import('/lua/seraphimweapons.lua').SDFUnstablePhasonBeam
local EffectTemplate = import('/lua/EffectTemplates.lua')
local xsl0310a_LightningWeapon = import('/mods/m&b/lua/weapons.lua').xsl0310a_LightningWeapon
GMSB403a = Class(SLandUnit) {
    Weapons = {
        PhasonBeam = Class(xsl0310a_LightningWeapon) {},        
        

            
    },
    
    OnCreate = function(self)
        SLandUnit.OnCreate(self)        
        self:HideBone(0,true)        
    end,

}
TypeClass = GMSB403a