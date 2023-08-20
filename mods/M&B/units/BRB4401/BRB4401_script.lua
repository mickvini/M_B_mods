#****************************************************************************
#**
#**  File     :  /cdimage/units/URB4203/URB4203_script.lua
#**  Author(s):  David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Radar Jammer Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CRadarJammerUnit = import('/lua/cybranunits.lua').CRadarJammerUnit

BRB4401 = Class(CRadarJammerUnit) {
    IntelEffects = {
		{
			Bones = {
				'Emitter',
			},
			Offset = {
				0,
				3,
				0,
			},
			Type = 'Jammer01',
		},
    },
	OnStopBeingBuilt = function(self, builder, layer)
        CRadarJammerUnit.OnStopBeingBuilt(self, builder, layer)
        local bp = self:GetBlueprint()
        local bpAnim = bp.Display.AnimationOpen
        if not bpAnim then return end
        if not self.OpenAnim then
            self.OpenAnim = CreateAnimator(self)
            self.OpenAnim:PlayAnim(bpAnim)
            self.Trash:Add(self.OpenAnim)
        end
    end,

    OnIntelEnabled = function(self)
        CRadarJammerUnit.OnIntelEnabled(self)
        if self.OpenAnim then
            self.OpenAnim:SetRate(1)
        end
    end,

    OnIntelDisabled = function(self)
        CRadarJammerUnit.OnIntelDisabled(self)
        if self.OpenAnim then
            self.OpenAnim:SetRate(-1)
        end
    end,

}

TypeClass = BRB4401