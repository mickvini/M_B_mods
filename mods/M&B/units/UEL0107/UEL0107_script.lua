#****************************************************************************
#**
#**  File     :  UEL0107_script.lua
#**  Author(s):  Ebola (Unit LOD & Textures) Resin_Smoker(BP & unit Scripts)
#**
#**  Summary  :  UEF T1 Morty Hover Tank Script
#**
#**  Copyright © 2008 4th Dimension  All rights reserved.
#****************************************************************************

local EffectTemplate = import('/lua/EffectTemplates.lua')
local THoverLandUnit = import('/lua/terranunits.lua').THoverLandUnit
local TIFFragLauncherWeapon = import('/lua/terranweapons.lua').TDFFragmentationGrenadeLauncherWeapon

UEL0107 = Class(THoverLandUnit) {
    Weapons = {
        Grenade = Class(TIFFragLauncherWeapon) {}

    },

    OnStopBeingBuilt = function(self,builder,layer)
        # After being  built this script sets the units speed multi based 
        # upon what it's built on as it should be faster on land then water
        local layer = self:GetCurrentLayer()
        if(layer == 'Water') then
            # Enables Land multi
            self:SetSpeedMult(0.75)
            self:SetAccMult(1.0)
            self:SetTurnMult(1.0)
        elseif (layer == 'Land') then
            # Enables Sea multi
            self:SetSpeedMult(1.0)
            self:SetAccMult(1.25)
            self:SetTurnMult(1.25)
        end
        THoverLandUnit.OnStopBeingBuilt(self,builder,layer)
    end,

    OnLayerChange = function(self, new, old)
        # Detects the layer trasition and adjusts the units speed accordingly
        THoverLandUnit.OnLayerChange(self, new, old)
        if( new == 'Water' ) then
            # Enables Land multi
            self:SetSpeedMult(0.75)
            self:SetAccMult(1.0)
            self:SetTurnMult(1.0)
        elseif ( new == 'Land' ) then
            # Enables Sea multi
            self:SetSpeedMult(1.0)
            self:SetAccMult(1.25)
            self:SetTurnMult(1.25)
        end
    end,
}

TypeClass = UEL0107