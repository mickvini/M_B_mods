local CStructureUnit = import('/lua/cybranunits.lua').CStructureUnit

local CybranWeaponsFile = import('/lua/cybranweapons.lua')
local CIFArtilleryWeapon = import('/lua/cybranweapons.lua').CIFArtilleryWeapon
local DefaultProjectileWeapon = import('/lua/sim/DefaultWeapons.lua').DefaultProjectileWeapon
local CIFCommanderDeathWeapon = CybranWeaponsFile.CIFCommanderDeathWeapon

local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtils = import('/lua/effectutilities.lua')
local utilities = import('/lua/utilities.lua')

local muzzleBones = { 'Muzzle1', 'Muzzle2', 'Muzzle3', 'Muzzle4' } 
local recoilgroup1 = { 'Barrel11', 'Barrel12', 'Barrel13', 'Barrel14' } 
local recoilgroup2 = { 'Barrel21', 'Barrel22', 'Barrel23', 'Barrel24' } 

GMRB302 = Class(CStructureUnit) {    
    Weapons = {
        DeathWeapon = Class(CIFCommanderDeathWeapon) {},
	QuadCannon = Class(CIFArtilleryWeapon) { 
            FxMuzzleFlashScale = 0.25,
            FxMuzzleFlash = { 
            	'/effects/emitters/proton_artillery_muzzle_01_emit.bp',
            	'/effects/emitters/proton_artillery_muzzle_03_emit.bp',
                '/effects/emitters/cybran_artillery_muzzle_smoke_01_emit.bp',                                
            }, 
            FxScale = 0.3,
            FxGroundEffect = EffectTemplate.CDisruptorGroundEffect,
	    FxVentEffect = EffectTemplate.CDisruptorVentEffect,
	    FxMuzzleEffect = EffectTemplate.CElectronBolterMuzzleFlash01,
	    FxCoolDownEffect = EffectTemplate.CDisruptorCoolDownEffect,                       
            
            OnCreate = function(self) 
                CIFArtilleryWeapon.OnCreate(self) 
                self.CurrentBarrel = 1 
                self.CurrentGoal = 90                              
            end, 
            
	    PlayFxMuzzleSequence = function(self, muzzle)
		local army = self.unit:GetArmy()
		        
	        for k, v in self.FxGroundEffect do
                    CreateAttachedEmitter(self.unit, 'XQB2202', army, v):ScaleEmitter(0.4)
                end
  	        for k, v in self.FxVentEffect do
                    CreateAttachedEmitter(self.unit, recoilgroup1[self.CurrentBarrel], army, v):ScaleEmitter(0.1)
                end
  	        for k, v in self.FxMuzzleEffect do
                    CreateAttachedEmitter(self.unit, muzzleBones[self.CurrentBarrel], army, v):ScaleEmitter(0.1)
                end
                CIFArtilleryWeapon.PlayFxMuzzleSequence(self, muzzle)
  	            for k, v in self.FxCoolDownEffect do
                    CreateAttachedEmitter(self.unit, recoilgroup2[self.CurrentBarrel], army, v):ScaleEmitter(0.1)
                end 
            end,                       
                      
            PlayRackRecoil = function(self, rackList)
                local recoilTbl = {} 

                recoilTbl.MuzzleBones = muzzleBones[self.CurrentBarrel]                
                recoilTbl.RackBone = recoilgroup1[self.CurrentBarrel] 
                recoilTbl.TelescopeBone = recoilgroup2[self.CurrentBarrel]              
                table.insert( rackList, recoilTbl ) 
                                
                CIFArtilleryWeapon.PlayRackRecoil(self, rackList)
                if not self.SpinManip then 
                    self.SpinManip = CreateRotator(self.unit, 'Rotator', 'z', self.CurrentGoal, 200, 200, 200) 
                    self.unit.Trash:Add(self.SpinManip)
                else
                    self.SpinManip:SetGoal(self.CurrentGoal) 
                    self.SpinManip:SetAccel(200) 
                    self.SpinManip:SetTargetSpeed(200)                 
                end              

                self.CurrentBarrel = self.CurrentBarrel + 1
                self.CurrentGoal = self.CurrentGoal + 90 
                if self.CurrentBarrel > 4 then 
                    self.CurrentBarrel = 1
                    self.CurrentGoal = 90  
                end               
            end,            

            OnLostTarget = function(self) 
                if not self.unit:IsDead() and self.SpinManip then      
                    for k, v in muzzleBones do 
                        self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, v, self.unit:GetArmy(), EffectTemplate.WeaponSteam01 )
                    end                     
                end 
                CIFArtilleryWeapon.OnLostTarget(self) 
            end,
            
            PlayFxWeaponPackSequence = function(self) 
                if self.SpinManip then 
                    self.SpinManip:SetTargetSpeed(0)
                    for k, v in muzzleBones do 
                        self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, v, self.unit:GetArmy(), EffectTemplate.WeaponSteam01 ) 
                    end
                end 
                CIFArtilleryWeapon.PlayFxWeaponPackSequence(self) 
            end,           
        },
    },
}
TypeClass = GMRB302