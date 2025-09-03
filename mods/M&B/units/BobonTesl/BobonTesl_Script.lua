local SLandUnit = import('/lua/seraphimunits.lua').SLandUnit
local WeaponsFile = import('/lua/seraphimweapons.lua')
local SDFThauCannon = WeaponsFile.SDFThauCannon
local SDFAireauBolter = WeaponsFile.SDFAireauBolterWeapon
local SANUallCavitationTorpedo = WeaponsFile.SANUallCavitationTorpedo
local EffectUtil = import('/lua/EffectUtilities.lua')
local SAMElectrumMissileDefense = WeaponsFile.SAMElectrumMissileDefense
local CDFParticleCannonWeapon = import('/lua/cybranweapons.lua').CDFParticleCannonWeapon
local xsl0310a_LightningWeapon = import('/mods/m&b/lua/weapons.lua').xsl0310a_LightningWeapon
BobonTesl = Class(SLandUnit) {
    Weapons = {
        MainTurret = Class(xsl0310a_LightningWeapon) {
                                  
        },
        LeftTurret = Class(SDFAireauBolter) {},
        RightTurret = Class(SDFAireauBolter) {},
        AntiMissileLeft = Class(SAMElectrumMissileDefense) {},
        AntiMissileRight = Class(SAMElectrumMissileDefense) {},
    },
    OnStopBeingBuilt = function(self, ...)
        SLandUnit.OnStopBeingBuilt(self, unpack(arg))
        self:SetMaintenanceConsumptionActive()
        --self:CreateOrbEntity()
        self.WeaponsActive = true
        self:CreateTeslaChargeEffects()
    end,
    CreateTeslaChargeEffects = function(self)
        self.TeslaEffectsBag = {}
        self:ForkThread(function()
            local gun = self:GetWeaponByLabel('MainTurret')
            local gunbp = gun:GetBlueprint()
            while true do
                if self.WeaponsActive and (gunbp.Effects.ParticalStackIntervalTicks or 30) * (gunbp.Effects.ParticalStacksMax or 30) > GetGameTick() then
                    self.Trash:Add(table.insert(self.TeslaEffectsBag, CreateAttachedEmitter( self, 'MainTurretMuzzle', self:GetArmy(), '/effects/emitters/cybran_t2power_ambient_01_emit.bp' ):OffsetEmitter(0,0.75,-.5):ScaleEmitter(math.random(10,15)*0.1 ) ) )
                end
                WaitTicks((gunbp.Effects.ParticalStackIntervalTicks or 30) + 1)
            end
        end)
    end,
}

TypeClass = BobonTesl