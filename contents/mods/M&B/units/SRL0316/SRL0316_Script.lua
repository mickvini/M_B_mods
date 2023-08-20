--------------------------------------------------------------------------------
-- Summary  :  Cybran Cloakable Mobile Radar Stealth Script
--------------------------------------------------------------------------------
local CLandUnit = import('/lua/cybranunits.lua').CLandUnit
local EffectUtil = import('/lua/EffectUtilities.lua')

SRL0316 = Class(CLandUnit) {
    ShieldEffects = {'/mods/M&B/effects/emitters/ex_cybran_shieldgen_01_emit.bp'},
    OnStopBeingBuilt = function(self,builder,layer)
        CLandUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetMaintenanceConsumptionActive()
        --Force update of the cloak effect if there is a cloak mesh. For FAF graphics
        if self:GetBlueprint().Display.CloakMeshBlueprint then
            self:ForkThread(
                function()
                    WaitTicks(1)
                    self:UpdateCloakEffect(true, 'Cloak')
                end
            )
        end
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

TypeClass = SRL0316
