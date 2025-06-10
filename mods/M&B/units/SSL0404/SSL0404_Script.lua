local SWalkingLandUnit = import('/lua/seraphimunits.lua').SWalkingLandUnit
local SDFUltraChromaticBeamGenerator = import('/lua/seraphimweapons.lua').SDFUltraChromaticBeamGenerator
local Buff = import('/lua/sim/Buff.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')
local Entity = import('/lua/sim/Entity.lua').Entity
local AIUtils = import('/lua/AI/aiutilities.lua')

SSL0404 = Class(SWalkingLandUnit) {

    Weapons = {
        MainGun = Class(SDFUltraChromaticBeamGenerator) {},
        MainTracer = Class(SDFUltraChromaticBeamGenerator) {
			
        },
    },

    GetUnitsToBuff = function(self, bp)
        local unitCat = ParseEntityCategory(bp.UnitCategory or 'BUILTBYTIER3FACTORY + BUILTBYQUANTUMGATE + NEEDMOBILEBUILD')
        local brain = self:GetAIBrain()
        local all = brain:GetUnitsAroundPoint(unitCat, self:GetPosition(), bp.Radius, 'Ally')
        local units = {}

        for _, u in all do
            if not u.Dead and not u:IsBeingBuilt() then
                table.insert(units, u)
            end
        end

        return units
    end,

    RegenBuffThread = function(self)
        local bp = self:GetBlueprint().RegenAura
        local buff = 'SeraphimACU'

        while not self.Dead do
            local units = self:GetUnitsToBuff(bp)
            for _,unit in units do
                Buff.ApplyBuff(unit, buff)
                unit:RequestRefreshUI()
            end
            WaitSeconds(50)
        end
    end,

    StartBeingBuiltEffects = function(self, builder, layer)
		SWalkingLandUnit.StartBeingBuiltEffects(self, builder, layer)
		self:ForkThread( EffectUtil.CreateSeraphimExperimentalBuildBaseThread, builder, self.OnBeingBuiltEffectsBag )
    end,

    OnAnimCollision = function(self, bone, x, y, z)
        SWalkingLandUnit.OnAnimCollision(self, bone, x, y, z)
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        SWalkingLandUnit.OnStopBeingBuilt(self, builder, layer)

        --These start enabled, so before going to InvisState, disabled them.. they'll be reenabled shortly
        self:DisableUnitIntel('RadarStealth')
		self:DisableUnitIntel('Cloak')
		self.Cloaked = false
        --ChangeState( self, self.InvisState ) -- If spawned in we want the unit to be invis, normally the unit will immediately start moving
		

        self.ShieldEffectsBag = {}
        local bp = self:GetBlueprint().RegenAura
        local buff
		
		buff = 'SeraphimACU'
		
        if not Buffs[buff] then
            local buff_bp = {
                Name = buff,
                DisplayName = buff,
                BuffType = 'COMMANDERAURA',
                Stacks = 'REPLACE',
                Duration = 5,                
                Affects = {
                        Regen = {
                            Add = 0,
                            Mult = bp.RegenPerSecond,
                            Floor = bp.RegenFloor,
                            BPCeilings = {
                                TECH1 = bp.RegenCeilingT1,
                                TECH2 = bp.RegenCeilingT2,
                                TECH3 = bp.RegenCeilingT3,
                                EXPERIMENTAL = bp.RegenCeilingT4,
                                SUBCOMMANDER = bp.RegenCeilingSCU,
                            },
                        },                      
                },
            }
			
			    buff_bp.Affects.MaxHealth = {
                    Add = 0,
                    Mult = bp.MaxHealthFactor,
                    DoNotFill = true,
                }

                BuffBlueprint(buff_bp)
        end

        table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 'Body', self:GetArmy(), '/effects/emitters/seraphim_regenerative_aura_01_emit.bp' ) )
        self.RegenThreadHandle = self:ForkThread(self.RegenBuffThread)
    end,    
        
}
TypeClass = SSL0404