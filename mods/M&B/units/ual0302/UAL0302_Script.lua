#****************************************************************************
#**
#**  File     :  /UAL0302/UAL0302.*
#**  Author(s):  Optimus Prime
#**
#**  Summary  :  Aeon Super Heavy Assault Tank
#**
#****************************************************************************

local ALandUnit = import('/lua/aeonunits.lua').ALandUnit
local ADFCannonQuantumWeapon = import('/lua/aeonweapons.lua').ADFCannonQuantumWeapon
local WeaponsFile = import('/lua/terranweapons.lua')
local TDFGaussCannonWeapon = WeaponsFile.TDFGaussCannonWeapon
local AIFMortarWeapon = import('/lua/aeonweapons.lua').AIFMortarWeapon
local EffectTemplate = import('/mods/m&b/lua/EffectTemplates.lua')
local utilities = import('/lua/Utilities.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')
local AIFMissileTacticalSerpentineWeapon = import('/lua/aeonweapons.lua').AIFMissileTacticalSerpentineWeapon
local explosion = import('/lua/defaultexplosions.lua')

UAL0302 = Class(ALandUnit) {

    Weapons = {
        MainGun = Class(TDFGaussCannonWeapon) {},
        MissileRack1 = Class(AIFMissileTacticalSerpentineWeapon) {},
        MissileRack2 = Class(AIFMissileTacticalSerpentineWeapon) {},
        MissileRack3 = Class(AIFMissileTacticalSerpentineWeapon) {},
        MissileRack4 = Class(AIFMissileTacticalSerpentineWeapon) {},
        MissileRack5 = Class(AIFMissileTacticalSerpentineWeapon) {},
        MissileRack6 = Class(AIFMissileTacticalSerpentineWeapon) {},
    },

    OnCreate = function(self,builder,layer)
		ALandUnit.OnCreate(self)
        # Creating Global Variables
        Army = self:GetArmy()
    end,    
    
    OnStopBeingBuilt = function(self,builder,layer)
        ALandUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetMaintenanceConsumptionActive()
        local layer = self:GetCurrentLayer()
        # If created with F2 on land, then play the transform anim.
        if(layer == 'Land') then
            self:CreateUnitAmbientEffect(layer)
        elseif (layer == 'Seabed') then
        end
        self.WeaponsEnabled = true
    end,
    
	DestructionEffectBones = {
        'ExhastBig1','ExhastBig2','Exhaust3','Exhaust4','UAL0302','Turret','Sleeve','Barrel1','Barrel2','Barrel3','Barrel4',
        },    
    
    AmbientExhaustBones = {
		'ExhastBig1',
		'ExhastBig2',
    },
    
    AmbientExhaustBones2 = {
		'Exhaust3',
		'Exhaust4',
    },
    	
    
    AmbientLandExhaustEffects = {
		'/effects/emitters/hydrocarbon_smoke_01_emit.bp',			
	},

    CreateDamageEffects = function(self, bone, Army )
        for k, v in EffectTemplate.AMiasmaMunition02 do   
            CreateAttachedEmitter( self, bone, Army, v ):ScaleEmitter(0.7)
            
        end
        for k, v in EffectTemplate.AMiasmaField01 do   
            CreateAttachedEmitter( self, bone, Army, v ):ScaleEmitter(0.8)
        end        
    end,
    CreateExplosionDebris = function( self, bone, Army )
        for k, v in EffectTemplate.ExplosionEffectsSml01 do
            CreateAttachedEmitter( self, bone, Army, v ):ScaleEmitter(1.5)
        end
    end,
        	
	CreateFirePlumesAeons = function( self, Army, bones, yBoneOffset )
        local proj, position, offset, velocity
        local basePosition = self:GetPosition()
        for k, vBone in bones do
            position = self:GetPosition(vBone)
            offset = utilities.GetDifferenceVector( position, basePosition )
            velocity = utilities.GetDirectionVector( position, basePosition ) 
            velocity.x = velocity.x + utilities.GetRandomFloat(-1.15, 1.15)
            velocity.z = velocity.z + utilities.GetRandomFloat(-1.15, 1.15)
            velocity.y = velocity.y + utilities.GetRandomFloat( -1.15, 1.15)
            proj = self:CreateProjectile('/effects/entities/DestructionFirePlume01/DestructionFirePlume01_proj.bp', offset.x, offset.y + yBoneOffset, offset.z, velocity.x, velocity.y, velocity.z)
            proj:SetBallisticAcceleration(utilities.GetRandomFloat(-1, 1)):SetVelocity(utilities.GetRandomFloat(1, 2)):SetCollision(false)           
            local emitter = CreateEmitterOnEntity(proj, Army, '/mods/m&b/effects/emitters/destruction_explosion_fire_plume_03_emit.bp')
            local lifetime = utilities.GetRandomFloat( 5, 25 )
        end
    end,

	InitialRandomExplosionsAeons = function(self)
        local position = self:GetPosition()
        local numExplosions =  math.floor( table.getn( self.DestructionEffectBones ) * 0.5 )
		CreateAttachedEmitter(self, 0, self:GetArmy(), '/effects/emitters/nuke_concussion_ring_01_emit.bp'):ScaleEmitter(0.15)
        # Create small explosions all over
        self:PlayUnitSound('Destroyed')
        for i = 0, numExplosions do
            local ranBone = utilities.GetRandomInt( 1, numExplosions )
            local duration = utilities.GetRandomFloat( 0.2, 0.5 )
            self:CreateFirePlumesAeons( Army, {ranBone}, Random(0,1) )
            self:CreateDamageEffects( ranBone, Army )
            self:CreateExplosionDebris( Army )
            self:ShakeCamera(2, 0.5, 0.25, duration)
            WaitSeconds( duration )
            self:CreateFirePlumesAeons( Army, {ranBone}, Random(0,1) )
        end
        if Random (1, 10) > 5 then
        	self:PlayUnitSound('Destroyed')
        	explosion.CreateDebrisProjectiles(self, explosion.GetAverageBoundingXYZRadius(self), {self:GetUnitSizes()})
        end
    end,	
	
	CreateUnitAmbientEffect = function(self, layer)
	    if( self.AmbientEffectThread != nil ) then
	       self.AmbientEffectThread:Destroy()
        end	 
        if self.AmbientExhaustEffectsBag then
            EffectUtil.CleanupEffectBag(self,'AmbientExhaustEffectsBag')
        end        
        
        self.AmbientEffectThread = nil
        self.AmbientExhaustEffectsBag = {} 
	    if layer == 'Land' then
	        self.AmbientEffectThread = self:ForkThread(self.UnitLandAmbientEffectThread)        
	    end          
	end, 
	
	UnitLandAmbientEffectThread = function(self)
		while not self:IsDead() do
            local army = self:GetArmy()			
			
			for kE, vE in self.AmbientLandExhaustEffects do
				for kB, vB in self.AmbientExhaustBones do
					table.insert( self.AmbientExhaustEffectsBag, CreateAttachedEmitter(self, vB, army, vE ):ScaleEmitter(0.3):OffsetEmitter(0,0,0))
				end
			end
			WaitSeconds(2)
			EffectUtil.CleanupEffectBag(self,'AmbientExhaustEffectsBag')
			WaitSeconds(utilities.GetRandomFloat(1,3))
			for kE, vE in self.AmbientLandExhaustEffects do
				for kB, vB in self.AmbientExhaustBones2 do
					table.insert( self.AmbientExhaustEffectsBag, CreateAttachedEmitter(self, vB, army, vE ):ScaleEmitter(0.2):OffsetEmitter(0,0,0))
				end
			end
			WaitSeconds(3)	
			EffectUtil.CleanupEffectBag(self,'AmbientExhaustEffectsBag')	
			WaitSeconds(utilities.GetRandomFloat(5,15))
		end		
	end,    

	OnKilled = function(self, inst, type, okr)
        self.Trash:Destroy()
        self.Trash = TrashBag()
        if self.AmbientExhaustEffectsBag then
            EffectUtil.CleanupEffectBag(self,'AmbientExhaustEffectsBag')
        end
        ALandUnit.OnKilled(self, inst, type, okr)
    end,

    DeathThread = function( self, overkillRatio , instigator)
        # Create Initial explosion effects
        
        explosion.CreateScorchMarkSplat( self, 1.6, Army )
		explosion.CreateScorchMarkDecal( self, 1.6, Army )
        self:InitialRandomExplosionsAeons()   
     	
        if self.DeathAnimManip then
            WaitFor(self.DeathAnimManip)
        end
       WaitSeconds(1.5)
        self:DestroyAllDamageEffects()
        self:CreateWreckage( 1 )

        #Starts the corpse effects
		CreateAttachedEmitter(self, 0, self:GetArmy(), '/effects/emitters/nuke_concussion_ring_01_emit.bp'):ScaleEmitter(0.15)
        self:PlayUnitSound('Destroyed')
        self:InitialRandomExplosionsAeons()
        self:Destroy()
    end,
   	    
}

TypeClass = UAL0302