#****************************************************************************
#**
#**  File     :  /units/XSLconcept/XSLconcept_script.lua
#**  Author(s):  Drew Staltman, Jessica St. Croix, Gordon Duclos
#**
#**  Summary  :  Seraphim Concept Script
#**
#**  Copyright � 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local SWalkingLandUnit = import('/lua/seraphimunits.lua').SWalkingLandUnit
local SeraphimWeapons = import('/lua/seraphimweapons.lua')
local WeaponsFileAutoAttack = import('/lua/terranweapons.lua')
local SDFAireauBolterWeapon = SeraphimWeapons.SDFAireauBolterWeapon02
local AutoAttackWeapon = WeaponsFileAutoAttack.TDFLandGaussCannonWeapon
local SDFThauCannon = SeraphimWeapons.SDFThauCannon
local SDFChronotronCannonWeapon = SeraphimWeapons.SDFChronotronCannonWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtils = import('/lua/effectutilities.lua')

BRPT2HVBOT = Class( SWalkingLandUnit ) {
    Weapons = {
            autoattack = Class(SDFAireauBolterWeapon) {
			            FxMuzzleFlashScale = 0.0, 
	},
        smallgun1 = Class(SDFAireauBolterWeapon) {
			            FxMuzzleFlashScale = 2.4, 
	},
        smallgun2 = Class(SDFAireauBolterWeapon) {
			            FxMuzzleFlashScale = 2.4, 
	},
        smallgun3 = Class(SDFAireauBolterWeapon) {
			            FxMuzzleFlashScale = 2.4, 
	},
        smallgun4 = Class(SDFAireauBolterWeapon) {
			            FxMuzzleFlashScale = 2.4, 
	},
        ChronotronCannon = Class(SDFChronotronCannonWeapon) {
	},
        ChronotronCannon2 = Class(SDFChronotronCannonWeapon) {
	},
        TauCannon01 = Class(SDFThauCannon){
			FxMuzzleFlashScale = 0.9,
        },
        TauCannon02 = Class(SDFThauCannon){
			FxMuzzleFlashScale = 0.9,
        },
    },
OnStopBeingBuilt = function(self,builder,layer)
        SWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
        self:CreatTheEffects()
        --M&B: paused -- testing the targeter-weapon route first (weapon #1, auto-initiate ON).
        --Re-enable this call if the weapon route fails again.
        --self:MNBSetupTorsoAim()
      if self:GetAIBrain().BrainType == 'Human' and IsUnit(self) then
         self:SetWeaponEnabledByLabel('autoattack', false)
      else
         self:SetWeaponEnabledByLabel('autoattack', true)
      end      
    end,

CreatTheEffects = function(self)
	local army =  self:GetArmy()
	for k, v in EffectTemplate['SDFSinnutheWeaponFXTrails01'] do
		CreateAttachedEmitter(self, 'aa01', army, v):ScaleEmitter(0.1)
	end
	for k, v in EffectTemplate['SDFSinnutheWeaponFXTrails01'] do
		CreateAttachedEmitter(self, 'aa02', army, v):ScaleEmitter(0.1)
	end
	for k, v in EffectTemplate['SDFSinnutheWeaponFXTrails01'] do
		CreateAttachedEmitter(self, 'aa03', army, v):ScaleEmitter(0.1)
	end
	for k, v in EffectTemplate['SDFSinnutheWeaponFXTrails01'] do
		CreateAttachedEmitter(self, 'aa04', army, v):ScaleEmitter(0.1)
	end
	for k, v in EffectTemplate['SDFSinnutheWeaponFXTrails01'] do
		CreateAttachedEmitter(self, 'eff01', army, v):ScaleEmitter(0.3)
	end
	for k, v in EffectTemplate['SDFSinnutheWeaponFXTrails01'] do
		CreateAttachedEmitter(self, 'eff02', army, v):ScaleEmitter(0.3)
	end
end,

OnKilled = function(self,builder,layer)
        SWalkingLandUnit.OnKilled(self,builder,layer)
        self:CreatTheEffectsDeath()  
    end,

CreatTheEffectsDeath = function(self)
	local army =  self:GetArmy()
	for k, v in EffectTemplate['SDFExperimentalPhasonProjHit01'] do
		CreateAttachedEmitter(self, 'BRPT2HVBOT', army, v):ScaleEmitter(2.3)
	end
end,

--M&B: torso aim -- rotate Torso01 toward the current ground/water target so the
--widely spaced guns (each only +/-40 deg yaw) can converge on close targets and
--keep firing backwards while the legs walk a retreat order. Speed 60 deg/s (user's choice).
MNBSetupTorsoAim = function(self)
	if self.MNBTorsoRot then return end
	self.MNBTorsoRot = CreateRotator(self, 'Torso01', 'y', 0, 60, 120, 60)
	self.Trash:Add(self.MNBTorsoRot)
	self:ForkThread(self.MNBTorsoAimThread)
end,

MNBTorsoTarget = function(self)
	--Prefer the unit's own attack target, then whatever gun currently tracks. Air excluded.
	local t = nil
	if self.GetTargetEntity then t = self:GetTargetEntity() end
	if t and IsUnit(t) and not t:IsDead() and t:GetCurrentLayer() ~= 'Air' then
		return t
	end
	local guns = {'TauCannon01', 'TauCannon02', 'ChronotronCannon', 'ChronotronCannon2'}
	for k, label in guns do
		local wep = self:GetWeaponByLabel(label)
		if wep then
			t = wep:GetCurrentTarget()
			if t and IsUnit(t) and not t:IsDead() and t:GetCurrentLayer() ~= 'Air' then
				return t
			end
		end
	end
	return nil
end,

MNBTorsoAimThread = function(self)
	while not self:IsDead() do
		WaitSeconds(0.2)
		local target = self:MNBTorsoTarget()
		if target then
			local tpos = target:GetPosition()
			if tpos then
				local pos = self:GetPosition('Torso01')
				--Bearing to the target vs the unit's heading, in degrees
				local want = math.deg(math.atan2(tpos.x - pos.x, tpos.z - pos.z))
				local ox, oy, oz, ow = self:GetOrientation()
				local heading
				if type(ox) == 'table' then
					--quaternion returned as a table {x=,y=,z=,w=}
					heading = math.deg(2 * math.atan2(ox.y, ox.w))
				else
					--quaternion returned as four numbers x, y, z, w
					heading = math.deg(2 * math.atan2(oy, ow))
				end
				local rel = want - heading
				--Normalize to [-180, 180]
				while rel > 180 do rel = rel - 360 end
				while rel < -180 do rel = rel + 360 end
				--If the torso turns the WRONG WAY: negate rel (mirror) or add 180 (faces away)
				self.MNBTorsoRot:SetGoal(rel)
			end
		else
			self.MNBTorsoRot:SetGoal(0)
		end
	end
end,
}

TypeClass = BRPT2HVBOT