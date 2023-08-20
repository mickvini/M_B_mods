local TerranWeaponFile = import('/lua/terranweapons.lua')
local TWalkingLandUnit = import('/lua/terranunits.lua').TWalkingLandUnit
local TDFHeavyPlasmaCannonWeapon = TerranWeaponFile.TDFHeavyPlasmaCannonWeapon
local TSAMLauncher = TerranWeaponFile.TSAMLauncher
local TAALinkedRailgun = TerranWeaponFile.TAALinkedRailgun
local Buff = import('/lua/sim/Buff.lua')

WEL03021 = Class(TWalkingLandUnit) {

    Weapons = {
        HeavyPlasma01 = Class(TDFHeavyPlasmaCannonWeapon) {},
        MissileLauncher = Class(TSAMLauncher) {},
		AAGun = Class(TAALinkedRailgun) {},
    },
	
	OnCreate = function(self)
        TWalkingLandUnit.OnCreate(self)
		self:SetWeaponEnabledByLabel('AAGun', false)
        self:HideBone('AATurret01', true)
		
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        TWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetWeaponEnabledByLabel('AAGun', false)
        self:HideBone('AATurret01', true)
    end,
	
	CreateEnhancement = function(self, enh)
        TWalkingLandUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
        #AA Gun
        if enh == 'AAEnhancment' then
            self:SetWeaponEnabledByLabel('AAGun', true)
			self:ShowBone('AATurret01', true)
        elseif enh == 'AAEnhancmentRemove' then
			self:SetWeaponEnabledByLabel('AAGun', false)
			self:HideBone('AATurret01', true)
		 #Heat Sink Augmentation
        elseif enh == 'HeatSink' then
            local wep = self:GetWeaponByLabel('HeavyPlasma01')
            wep:ChangeRateOfFire(bp.NewRateOfFire or 4)
        elseif enh == 'HeatSinkRemove' then
            local wep = self:GetWeaponByLabel('HeavyPlasma01')
            local bpDisrupt = self:GetBlueprint().Weapon[1].RateOfFire
            wep:ChangeRateOfFire(bpDisrupt or 3)
		elseif enh =='DamageStablization' then
            if not Buffs['UEFACUT2BuildRate'] then
                BuffBlueprint {
                    Name = 'UEFACUT2BuildRate',
                    DisplayName = 'UEFACUT2BuildRate',
                    BuffType = 'ACUBUILDRATE',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
                        Regen = {
                            Add = bp.NewRegenRate,
                            Mult = 1.0,
                        },
                    },
                }
            end
            Buff.ApplyBuff(self, 'UEFACUT2BuildRate')
        elseif enh =='DamageStablizationRemove' then
            local bp = self:GetBlueprint().Economy.BuildRate
            if not bp then return end
            if Buff.HasBuff( self, 'UEFACUT2BuildRate' ) then
                Buff.RemoveBuff( self, 'UEFACUT2BuildRate' )
            end
        end
    end,
    
}

TypeClass = WEL03021