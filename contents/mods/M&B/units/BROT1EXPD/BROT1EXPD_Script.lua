#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB2301/UEB2301_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Heavy Gun Tower Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local TMWeaponsFile = import('/mods/M&B/lua/weapons.lua')
local TMAmizurabluelaserweapon = TMWeaponsFile.TMAmizurabluelaserweapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local TMEffectTemplate = import('/mods/M&B/lua/EffectTemplates.lua')
local EffectUtils = import('/lua/effectutilities.lua')

BROT1EXPD = Class(TStructureUnit) {
    Weapons = {
        laserblue = Class(TMAmizurabluelaserweapon) {

	},
        laserblue2 = Class(TMAmizurabluelaserweapon) {

	},
        laserblue3 = Class(TMAmizurabluelaserweapon) {

	},
        laserblue4 = Class(TMAmizurabluelaserweapon) {

	},
    },
OnKilled = function(self,builder,layer)
        TStructureUnit.OnKilled(self,builder,layer)
        self:CreatTheEffectsDeath()  
    end,

CreatTheEffectsDeath = function(self)
	local army =  self:GetArmy()
	for k, v in TMEffectTemplate['AeonUnitDeathRing03'] do
		CreateAttachedEmitter(self, 'BROT1EXPD', army, v):ScaleEmitter(0.85)
	end
end,
}

TypeClass = BROT1EXPD