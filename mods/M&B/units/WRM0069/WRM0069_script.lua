local SLandUnit = import('/lua/defaultunits.lua').MobileUnit

local WeaponsFile = import ('/lua/aeonweapons.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')

local ADFTractorClaw = WeaponsFile.ADFTractorClaw
local EffectUtil = import('/lua/EffectUtilities.lua')

WRM0069 = Class(SLandUnit) {

    BpId = 'wrm0069',

    Weapons = {        
        LeftArmTractor = Class(ADFTractorClaw) {
            
            GetRealTarget = function(self, target)
                if target and not IsUnit(target) then
                    local unitTarget = target:GetSource()
                    local unitPos = unitTarget:GetPosition()
                    local reconPos = target:GetPosition()
                    local dist = VDist2(unitPos[1], unitPos[3], reconPos[1], reconPos[3])
                    if dist < 3 then                  
                        return unitTarget
                    end
                end
                return target      
            end,

            TractorThread = function(self, target)
                self.unit.Trash:Add(target)
                local beam = self.Beams[1].Beam
                if not beam then return end

                local bp = self:GetBlueprint()
                local muzzle = self:GetBlueprint().MuzzleSpecial
                if not muzzle then return end

                target:SetDoNotTarget(true)
                local pos0 = beam:GetPosition(0)
                local pos1 = beam:GetPosition(1)
                local dist = VDist3(pos0, pos1)

                self.Slider = CreateSlider(self.unit, muzzle, 0, 0, dist, -1, true)

                WaitTicks(1)
                WaitFor(self.Slider)
                if not self.Animator and bp.AnimationAttack then
                    self.Animator = CreateAnimator(self.unit)            
                    self.unit.Trash:Add(self.Animator)            
                end
                self.Animator:PlayAnim(bp.AnimationAttack, false):SetRate(1.5)

                # just in case attach fails...
                target:SetDoNotTarget(false)
                target:AttachBoneTo(-1, self.unit, muzzle)
                target:SetDoNotTarget(true)
                
                self.AimControl:SetResetPoseTime(10)

                self.Slider:SetSpeed(15)
                self.Slider:SetGoal(0,0,0)
                
                WaitTicks(1)
                WaitFor(self.Animator)
                WaitFor(self.Slider)

                if not target:IsDead() then
                    target.DestructionExplosionWaitDelayMin = 0
                    target.DestructionExplosionWaitDelayMax = 0
                    
                    
                    
                    target:Kill(self.unit, 'Damage', 100)
                end
                
                self.AimControl:SetResetPoseTime(2)
            end,
       },
    },

    OnStartBeingBuilt = function(self, builder, layer)
        SLandUnit.OnStartBeingBuilt(self, builder, layer)
        
    end,

    StartBeingBuiltEffects = function(self, builder, layer)
		SLandUnit.StartBeingBuiltEffects(self, builder, layer)
		
    end,
    OnCreate = function(self)
        SLandUnit.OnCreate(self)
        --This animator is kept around and could eventyally be used for the water/land transitions
        
        self.MaelstromEffects01 = {}
        if self.MaelstromEffects01 then
                for k, v in self.MaelstromEffects01 do
                    v:Destroy()
                end
            self.MaelstromEffects01 = {}
        end
        --table.insert( self.MaelstromEffects01, CreateAttachedEmitter( self, 'Spinner_Ball', self:GetArmy(), '/mods/M&B/effects/emitters/genmaelstrom_aura_01_emit.bp' ):ScaleEmitter(0.2):OffsetEmitter(0, -2, 0) )
        --table.insert( self.MaelstromEffects01, CreateAttachedEmitter( self, 'Spinner_Ball', self:GetArmy(), '/mods/M&B/effects/emitters/genmaelstrom_aura_02_emit.bp' ):ScaleEmitter(0.2):OffsetEmitter(0, -2, 0) )
        table.insert( self.MaelstromEffects01, CreateAttachedEmitter( self, 'shy_hulu', self:GetArmy(), '/effects/Emitters/weather_sand_02_emit.bp' ):ScaleEmitter(0.5):OffsetEmitter(0, 0, 0))    
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        SLandUnit.OnStopBeingBuilt(self, builder, layer)
       
    end,

    OnAnimCollision = function(self, bone, x, y, z)
        SLandUnit.OnAnimCollision(self, bone, x, y, z)
    end,

    OnScriptBitSet = function(self, bit)
        SLandUnit.OnScriptBitSet(self, bit)        
    end,

    OnScriptBitClear = function(self, bit)
        SLandUnit.OnScriptBitClear(self, bit)        
    end,    

    OnKilled = function(self, instigator, type, overkillRatio)
        
        SLandUnit.OnKilled(self, instigator, type, overkillRatio)
        
    end,    

}

TypeClass = WRM0069
