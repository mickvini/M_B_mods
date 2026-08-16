--------------------------------------------------------------------------------
--  Summary  :  Laser Eye Point Defence script
--------------------------------------------------------------------------------
local AStructureUnit = import('/lua/aeonunits.lua').AStructureUnit
local ADFPhasonLaser = import('/lua/aeonweapons.lua').ADFPhasonLaser

-- MNB 2026-08-17: removed the "lazy eye" idle rotators. They drifted the Head
-- bone, which is also the weapon's aim bone (TurretBoneYaw/Pitch = 'Head'),
-- so the turret could never settle on target and mostly refused to fire.
SAB2306 = Class(AStructureUnit) {
    Weapons = {
        EyeWeapon = Class(ADFPhasonLaser) {},
    },

    OnKilled = function(self, instigator, type, overkillRatio)
        AStructureUnit.OnKilled(self, instigator, type, overkillRatio)
        local wep = self:GetWeaponByLabel('EyeWeapon')
        local bp = wep:GetBlueprint()
        if bp.Audio.BeamStop then
            wep:PlaySound(bp.Audio.BeamStop)
        end
        if bp.Audio.BeamLoop and wep.Beams[1].Beam then
            wep.Beams[1].Beam:SetAmbientSound(nil, nil)
        end
        for k, v in wep.Beams do
            v.Beam:Disable()
        end
    end,
}
TypeClass = SAB2306
