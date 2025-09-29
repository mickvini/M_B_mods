#****************************************************************************
#**
#**  File     :  /cdimage/units/XELbob01/XELbob01_script.lua
#**
#**  Summary  :  UEF Siege Assault Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local WeaponsFile = import('/lua/terranweapons.lua')
local TerranWeaponFile = import('/lua/terranweapons.lua')
local TWalkingLandUnit = import('/lua/terranunits.lua').TWalkingLandUnit
local TDFMachineGunWeapon = WeaponsFile.TDFMachineGunWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtils = import('/lua/effectutilities.lua')
local TMEffectTemplate = import('/mods/M&B/lua/EffectTemplates.lua')
local TIFCommanderDeathWeapon = TerranWeaponFile.TIFCommanderDeathWeapon

XELbob01 = Class(TWalkingLandUnit) {

    Weapons = {
        HeavyFlamer = Class(TDFMachineGunWeapon) {},
		DeathWeapon = Class(TIFCommanderDeathWeapon) {},
    },
	

}

TypeClass = XELbob01