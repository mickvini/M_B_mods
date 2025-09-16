#****************************************************************************
#**
#**  File     :  /cdimage/units/UALBob01/UALBob01_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Aeon Heavy Mobile Artillery Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local ALandUnit = import('/lua/aeonunits.lua').ALandUnit
local AWeapons = import('/lua/aeonweapons.lua')
local AIFArtillerySonanceShellWeapon = AWeapons.AIFArtillerySonanceShellWeapon
local AAASonicPulseBatteryWeapon = AWeapons.AAASonicPulseBatteryWeapon
UALBob01 = Class(ALandUnit) {
    Weapons = {
        MainGun = Class(AIFArtillerySonanceShellWeapon) {
            FxMuzzleFlash = { 
                '/effects/emitters/aeon_heavy_artillery_flash_01_emit.bp', 
                '/effects/emitters/aeon_heavy_artillery_flash_02_emit.bp', 
            },
        },

        AAGunZ1 = Class(AAASonicPulseBatteryWeapon){},
        AAGunZ2 = Class(AAASonicPulseBatteryWeapon){},
        AAGunZ3 = Class(AAASonicPulseBatteryWeapon){},
        AAGunZ4 = Class(AAASonicPulseBatteryWeapon){},

    },
    BpId = 'ualbob01',

     OnStopBeingBuilt = function(self, builder, layer)
        ALandUnit.OnStopBeingBuilt(self, builder, layer)
        self:DisableShield()
        self:ToggleAAGuns(false)
    end,
    OnScriptBitSet = function(self, bit)
        ALandUnit.OnScriptBitSet(self, bit)
        if bit == 1 and self:GetCurrentLayer() == 'Land' then
            self:SetDefenseMode(true)
        elseif bit == 1 and self:GetCurrentLayer() ~= 'Land' then
            self:SetScriptBit('RULEUTC_WeaponToggle', false)
        end
    end,

    OnScriptBitClear = function(self, bit)
        ALandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then
            self:SetDefenseMode(nil)
        end
    end,

    GracefullyKillSpecAnim = function(self, handler, tracker)
        ---CleanGarbage
        if self['Grace'..handler] then KillThread(self['Grace'..handler]) end
        if self[handler] then
            self['Grace'..handler] = self:ForkThread(function()
                coroutine.yield(
                    self[handler]:GetAnimationDuration()
                    / self[handler]:GetRate()
                    * (1 - self[handler]:GetAnimationFraction())
                    * 10
                 )
                self[handler]:Destroy()
                self[handler] = nil
                if tracker then
                    self[tracker] = nil
                end
            end)
        end
    end,
   
    ToggleAAGuns = function(self, enable)
        for i = 1, self:GetWeaponCount() do
            local wep = self:GetWeapon(i)
            if wep:GetBlueprint()['WeaponCategory'] == 'Anti Air' then
                wep:SetWeaponEnabled(enable)
            end
                
        end
    end,

    SetDefenseMode = function(self, defenseMode)
        if defenseMode == nil then defenseMode = self:GetScriptBit('RULEUTC_WeaponToggle') end
        if defenseMode ~= self.DefenseMode then
            --------------------------------------------------------------------
            -- Setup
            --------------------------------------------------------------------
            local ChangeWeaponRadii = function(self, defenseModeMaxRadius, defenseModeRateOfFire)
                for i = 1, self:GetWeaponCount() do
                    local wep = self:GetWeapon(i)
                    if wep:GetBlueprint()[defenseModeMaxRadius] ~= nil then
                        wep:ChangeMaxRadius(wep:GetBlueprint()[defenseModeMaxRadius or 'MaxRadius'])
                    end
                    if wep:GetBlueprint()[defenseModeRateOfFire] ~= nil then
                        wep:ChangeRateOfFire(wep:GetBlueprint()[defenseModeRateOfFire or 'RateOfFire'])
                    end
                end
            end
            
            if not self.DefenseModeAnimator then
                self.DefenseModeAnimator = CreateAnimator(self)
                self.DefenseModeAnimator:PlayAnim(__blueprints[self.BpId].Display.AnimationToggleDefenseMode, false):SetRate(0)
            end
            self.DefenseMode = defenseMode
            --Psudo buff function
            
            --------------------------------------------------------------------
            -- Getting taller stuff
            --------------------------------------------------------------------
            local bp = __blueprints[self.BpId]
            if self.DefenseMode then

                self.DefenseModeAnimator:SetRate(0.2)

                self:SetSpeedMult(bp.Physics.DefenseModeMaxSpeedMult)
                self:SetTurnMult(bp.Physics.DefenseModeMaxSpeedMult)
                -- Do stuff we want to happen at the start of the animation
                self.DefenseModeForkThread = self:ForkThread(function()
                    coroutine.yield(50)                                    
                    self:EnableShield()
                    -- Large box that coveres top and bottom positions
                    self:SetCollisionShape( 'Box', bp.CollisionOffsetX or 0, (bp.CollisionOffsetY or 0) + bp.SizeY, bp.CollisionOffsetZ or 0,
                    bp.SizeX * 0.5, (bp.SizeY + (bp.CollisionOffsetYTall or 0) - (bp.CollisionOffsetY or 0) ) * 0.5, bp.SizeZ * 0.5)
                    self:SetIntelRadius('Vision', bp.Intel.DefenseModeVisionRadius)
                    self:SetMaintenanceConsumptionActive()
                    ChangeWeaponRadii(self, 'DefenseModeMaxRadius', 'DefenseModeRateOfFire')
                    self:ToggleAAGuns(true)
                end)
               
            else
                self.DefenseModeAnimator:SetRate(-0.2)
                self.DefenseModeForkThread = self:ForkThread(function()
                    coroutine.yield(50)
                    self:DisableShield()                    
                    self:SetIntelRadius('Vision', bp.Intel.VisionRadius)
                    self:SetSpeedMult(1)
                     self:SetTurnMult(1)
                    -- Large box that coveres top and bottom positions
                    self:SetCollisionShape( 'Box', bp.CollisionOffsetX or 0, (bp.CollisionOffsetY or 0) + bp.SizeY, bp.CollisionOffsetZ or 0,
                    bp.SizeX * 0.5, (bp.SizeY + (bp.CollisionOffsetYTall or 0) - (bp.CollisionOffsetY or 0) ) * 0.5, bp.SizeZ * 0.5)
                    ChangeWeaponRadii(self, 'MaxRadius', 'RateOfFire')
                    self:ToggleAAGuns(false)
                end)
                
                
            end
        end
    end,

}

TypeClass = UALBob01