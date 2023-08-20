#****************************************************************************
#**
#**  File     :  /cdimage/units/URL0306/URL0306_script.lua
#**  Author(s):  Jessica St. Croix
#**
#**  Summary  :  Cybran Mobile Radar Jammer Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CLandUnit = import('/lua/cybranunits.lua').CLandUnit
local EffectUtil = import('/lua/EffectUtilities.lua')

URL0306 = Class(CLandUnit) {

	ShieldEffects = {'/mods/M&B/effects/emitters/ex_cybran_shieldgen_01_emit.bp'},

    OnStopBeingBuilt = function(self,builder,layer)
        CLandUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetMaintenanceConsumptionActive()
        self.ShieldEffectsBag = {}
    end,
    
    IntelEffects = {
		{
			Bones = {
				'AttachPoint',
			},
			Offset = {
				0,
				0.3,
				0,
			},
			Scale = 0.2,
			Type = 'Jammer01',
		},
    },
    
    OnIntelEnabled = function(self)
        CLandUnit.OnIntelEnabled(self)
        if self.IntelEffects then
			self.IntelEffectsBag = {}
			self.CreateTerrainTypeEffects( self, self.IntelEffects, 'FXIdle',  self:GetCurrentLayer(), nil, self.IntelEffectsBag )
		end
    end,

    OnIntelDisabled = function(self)
        CLandUnit.OnIntelDisabled(self)
        EffectUtil.CleanupEffectBag(self,'IntelEffectsBag')
    end,    
    OnShieldEnabled = function(self)
    
        CLandUnit.OnShieldEnabled(self)        
        
        
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
		    self.ShieldEffectsBag = {}
		end
        
        for k, v in self.ShieldEffects do
            table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 'AttachPoint', self.Army, v ) )
        end
    end,

    OnShieldDisabled = function(self)
    
        CLandUnit.OnShieldDisabled(self)
        
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
		    self.ShieldEffectsBag = {}
		end
    end,
    
}

TypeClass = URL0306