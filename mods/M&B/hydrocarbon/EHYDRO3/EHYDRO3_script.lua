#****************************************************************************
#**
#**  File     :  /cdimage/units/EHYDRO3/EHYDRO3_script.lua
#**  Author(s):  Jessica St. Croix
#**
#**  Summary  :  UEF Hydrocarbon Power Plant Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TEnergyCreationUnit = import('/lua/terranunits.lua').TEnergyCreationUnit
EHYDRO3 = Class(TEnergyCreationUnit) {
    AirEffects = {'/effects/emitters/hydrocarbon_smoke_01_emit.bp',},
    AirEffectsBones = {'Exhaust01'},
    WaterEffects = {'/effects/emitters/underwater_idle_bubbles_01_emit.bp',},
    WaterEffectsBones = {'Exhaust01'},

    OnStopBeingBuilt = function(self,builder,layer)
        TEnergyCreationUnit.OnStopBeingBuilt(self,builder,layer)
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

TypeClass = EHYDRO3