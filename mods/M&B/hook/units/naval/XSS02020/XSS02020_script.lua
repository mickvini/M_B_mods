#****************************************************************************
#**
#**  File     :  /units/XSS0202/XSS0202_script.lua
#**  Author(s):  Drew Staltman, Gordon Duclos, Aaron Lundquist
#**
#**  Summary  :  Seraphim Cruiser Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local SeraphimWeapons = import('/lua/seraphimweapons.lua')
local SSeaUnit = import('/lua/seraphimunits.lua').SSeaUnit
local SLaanseMissileWeapon = SeraphimWeapons.SLaanseMissileWeapon
local SAAOlarisCannonWeapon = SeraphimWeapons.SAAOlarisCannonWeapon
local SAAShleoCannonWeapon = SeraphimWeapons.SAAShleoCannonWeapon
local SAMElectrumMissileDefense = SeraphimWeapons.SAMElectrumMissileDefense
local SDFUltraChromaticBeamGenerator = SeraphimWeapons.SDFUltraChromaticBeamGenerator02

XSS0202 = Class(SSeaUnit) {
    Weapons = {
        FrontTurret = Class(SDFUltraChromaticBeamGenerator) {},
        BackTurret = Class(SDFUltraChromaticBeamGenerator) {},
        Missile = Class(SLaanseMissileWeapon) {},
		RightAAGun = Class(SAAShleoCannonWeapon) {},
		LeftAAGun = Class(SAAOlarisCannonWeapon) {},
        AntiMissile = Class(SAMElectrumMissileDefense) {},
    },
    OnKilled = function(self, instigator, type, overkillRatio)
        local wep1 = self:GetWeaponByLabel('FrontTurret')
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
        local wep2 = self:GetWeaponByLabel('BackTurret')
        local bp2 = wep2:GetBlueprint()
        if bp2.Audio.BeamStop then
            wep2:PlaySound(bp1.Audio.BeamStop)
        end
        if bp2.Audio.BeamLoop and wep2.Beams[1].Beam then
            wep2.Beams[1].Beam:SetAmbientSound(nil, nil)
        end
        for k, v in wep2.Beams do
            v.Beam:Disable()
        end     
        SSeaUnit.OnKilled(self, instigator, type, overkillRatio)
    end,

    BackWakeEffect = {},
}

TypeClass = XSS0202