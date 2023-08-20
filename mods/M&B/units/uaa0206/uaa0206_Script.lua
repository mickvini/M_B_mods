#****************************************************************************
#**
#**  File     :  UAA0206_script.lua
#**  Author(s):  Resin_Smoker / Vissroid
#**
#**  Summary  :  Aeon Abolisher Script
#**
#**  Copyright © 2009 4th Dimension
#****************************************************************************

local AAirUnit = import('/lua/aeonunits.lua').AAirUnit
local IonWeapon = import('/lua/terranweapons.lua').TDFHiroPlasmaCannon
local ZealotMissileWeapon = import('/lua/aeonweapons.lua').AAAZealot02MissileWeapon

UAA0206 = Class(AAirUnit) {
    Weapons = {
        Ion_Beam = Class(IonWeapon) {},
        Missile_L = Class(ZealotMissileWeapon) {},
        Missile_R = Class(ZealotMissileWeapon) {},
    },

    OnKilled = function(self)
        local wep1 = self:GetWeaponByLabel('Ion_Beam')
        local bp1 = wep1:GetBlueprint()
        if bp1.Audio.BeamStop then
            wep1:PlaySound(bp1.Audio.BeamStop)
        end
        if bp1.Audio.BeamLoop and wep1.Beams[1].Beam then
            wep1.Beams[1].Beam:SetAmbientSound(nil, nil)
        end
        for k, v in wep1.Beams do
            v.Beam:Disable()
        end     
                        
        AAirUnit.OnKilled(self)
    end, 

}

TypeClass = UAA0206

