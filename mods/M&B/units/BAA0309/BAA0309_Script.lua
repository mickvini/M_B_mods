#****************************************************************************
#**
#**  File     :  /cdimage/units/BAA0309/BAA0309_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix, Gordon Duclos
#**
#**  Summary  :  Aeon T2 Transport Script
#**
#**  Copyright � 2006 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AAirUnit = import('/lua/aeonunits.lua').AAirUnit
local explosion = import('/lua/defaultexplosions.lua')
local util = import('/lua/utilities.lua')
local aWeapons = import('/lua/aeonweapons.lua')
local AAASonicPulseBatteryWeapon = aWeapons.AAASonicPulseBatteryWeapon

BAA0309 = Class(AAirUnit) {

    AirDestructionEffectBones = { 'Exhaust', 'Wing_Right', 'Wing_Left', 'Turret_Right', 'Turret_Left',
                                  'Slots_Left01', 'Slots_Left02', 'Slots_Right01', 'Slots_Right02',
                                  'Right_AttachPoint01', 'Right_AttachPoint02', 'Right_AttachPoint03', 'Right_AttachPoint04',
                                  'Left_AttachPoint01', 'Left_AttachPoint02', 'Left_AttachPoint03', 'Left_AttachPoint04', },

    Weapons = {
        SonicPulseBattery1 = Class(AAASonicPulseBatteryWeapon) {},
        SonicPulseBattery2 = Class(AAASonicPulseBatteryWeapon) {},
        SonicPulseBattery3 = Class(AAASonicPulseBatteryWeapon) {},
        SonicPulseBattery4 = Class(AAASonicPulseBatteryWeapon) {},
    },

    # Override air destruction effects so we can do something custom here
    CreateUnitAirDestructionEffects = function( self, scale )
        self:ForkThread(self.AirDestructionEffectsThread, self )
    end,

    AirDestructionEffectsThread = function( self )
        local numExplosions = math.floor( table.getn( self.AirDestructionEffectBones ) * 0.5 )
        for i = 0, numExplosions do
            explosion.CreateDefaultHitExplosionAtBone( self, self.AirDestructionEffectBones[util.GetRandomInt( 1, numExplosions )], 0.5 )
            WaitSeconds( util.GetRandomFloat( 0.2, 0.9 ))
        end
    end,
    
    --M&B (user 15.09): decay aura replacing teleport - same 5 Hz DoT scheme as
    --the Aeon ACU maelstrom aura, but it hits enemy AIR units ONLY
    MNBAirDecayAuraThread = function(self)
        local iRadius, iDmg = 50, 10    --5 ticks/sec x 10 dmg = 50 dps
        local brain = self:GetAIBrain()
        local army = self:GetArmy()
        while not self.Dead do
            local pos = self:GetPosition()
            --M&B: AIR category only - ground/naval/structures are never touched
            local tTargets = brain:GetUnitsAroundPoint(categories.AIR, pos, iRadius, 'Enemy')
            if tTargets then
                for _, tgt in tTargets do
                    if tgt and not tgt.Dead and tgt:GetFractionComplete() >= 1 and IsEnemy(army, tgt:GetArmy()) then
                        Damage(self, pos, tgt, iDmg, 'Normal')
                    end
                end
            end
            WaitSeconds(0.2)   --constant 5 ticks/sec
        end
    end,

    OnStopBeingBuilt = function(self,builder,layer)
    	AAirUnit.OnStopBeingBuilt(self,builder,layer)
    	self:DisableUnitIntel('CloakField')
        --M&B: aura visuals - the same emitters the Aeon ACU maelstrom field uses
        self.MNBAuraEffects = {}
        table.insert( self.MNBAuraEffects, CreateAttachedEmitter(self, 'UAA0104', self:GetArmy(), '/mods/M&B/effects/emitters/exmaelstrom_aura_01_emit.bp'):ScaleEmitter(1):OffsetEmitter(0, 0, 0) )
        table.insert( self.MNBAuraEffects, CreateAttachedEmitter(self, 'UAA0104', self:GetArmy(), '/mods/M&B/effects/emitters/exmaelstrom_aura_02_emit.bp'):ScaleEmitter(1):OffsetEmitter(0, 0, 0) )
        self:ForkThread(self.MNBAirDecayAuraThread)
    end,
}

TypeClass = BAA0309