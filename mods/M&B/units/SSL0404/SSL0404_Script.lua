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
			OnWeaponFired = function(self, target)
				SDFUltraChromaticBeamGenerator.OnWeaponFired(self, target)
				ChangeState( self.unit, self.unit.VisibleState )
			end,

			OnLostTarget = function(self)
				SDFUltraChromaticBeamGenerator.OnLostTarget(self)
				if not self.unit:IsUnitState('Busy') then
				    ChangeState( self.unit, self.unit.InvisState )
				end
			end,
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
            WaitSeconds(5)
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
        ChangeState( self, self.InvisState ) -- If spawned in we want the unit to be invis, normally the unit will immediately start moving
		

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

    InvisState = State() {
        Main = function(self)
            self.Cloaked = false
            local bp = self:GetBlueprint()
            if bp.Intel.StealthWaitTime then
                WaitSeconds( bp.Intel.StealthWaitTime )
            end
			self:EnableUnitIntel('RadarStealth')
			self:EnableUnitIntel('Cloak')
			self.Cloaked = true
            if bp.Display.CloakMeshBlueprint then
                self:SetMesh(bp.Display.CloakMeshBlueprint, true)
            end
        end,

        OnMotionHorzEventChange = function(self, new, old)
            if new != 'Stopped' then
                ChangeState( self, self.VisibleState )
            end
            SWalkingLandUnit.OnMotionHorzEventChange(self, new, old)
        end,
    },

    VisibleState = State() {
        Main = function(self)
            if self.Cloaked then
                self:DisableUnitIntel('RadarStealth')
			    self:DisableUnitIntel('Cloak')
                local bp = self:GetBlueprint()
                if bp.Display.CloakMeshBlueprint then
                    self:SetMesh(bp.Display.MeshBlueprint, true)
                end
    			self.Cloaked = false
			end
        end,

        OnMotionHorzEventChange = function(self, new, old)
            if new == 'Stopped' then
                ChangeState( self, self.InvisState )
            end
            SWalkingLandUnit.OnMotionHorzEventChange(self, new, old)
        end,
    },
}

TypeClass = SSL0404
