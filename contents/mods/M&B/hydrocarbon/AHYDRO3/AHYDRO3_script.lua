#****************************************************************************
#**
#**  File     :  /cdimage/units/ahydro3/ahydro3_script.lua
#**  Author(s):  Jessica St. Croix, John Comes
#**
#**  Summary  :  Aeon Hydrocarbon Power Plant Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local CShieldStructureUnit = import('/lua/cybranunits.lua').CShieldStructureUnit
local Shield = import('/lua/shield.lua').Shield

local AEnergyCreationUnit = import('/lua/aeonunits.lua').AEnergyCreationUnit
ahydro3 = Class(AEnergyCreationUnit) {


    AirEffects = {'/effects/emitters/hydrocarbon_smoke_01_emit.bp',},
    AirEffectsBones = {'Extension02'},
    WaterEffects = {'/effects/emitters/underwater_idle_bubbles_01_emit.bp',},
    WaterEffectsBones = {'Extension02'},

    OnStopBeingBuilt = function(self,builder,layer)
        AEnergyCreationUnit.OnStopBeingBuilt(self,builder,layer)
        local effects = {}
        local bones = {}
        local scale = 0.75
        if self:GetCurrentLayer() == 'Land' then
            effects = self.AirEffects
            bones = self.AirEffectsBones
        elseif self:GetCurrentLayer() == 'Seabed' then
            effects = self.WaterEffects
            bones = self.WaterEffectsBones
            scale = 3
        end
        for keys, values in effects do
            for keysbones, valuesbones in bones do
                self.Trash:Add(CreateAttachedEmitter(self, valuesbones, self:GetArmy(), values):ScaleEmitter(scale):OffsetEmitter(0,-0.2,1))
            end
        end
    end,
}

TypeClass = ahydro3