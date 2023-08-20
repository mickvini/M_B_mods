#****************************************************************************
#**
#**  File     :  UAB2306_A_Script.lua
#**  Author(s):  Resin_Smoker
#**
#**  Summary  :  Aeon "Annihilator" Heavy Beam Turret Script
#**
#**  Copyright © 2008
#****************************************************************************

local AStructureUnit = import('/lua/aeonunits.lua').AStructureUnit
local BFGShellWeapon = import('/mods/M&B/lua/weapons.lua').BFGShellWeapon
local utilities = import('/lua/utilities.lua')

UAB2306_A = Class(AStructureUnit) {
    Weapons = {
		MainGun = Class(BFGShellWeapon) {},
    },

    OnStopBeingBuilt = function(self, builder, layer)
        AStructureUnit.OnStopBeingBuilt(self, builder, layer)
    #beam emitter rotator
        self.Trash:Add(CreateRotator(self, 'beam_emitter', 'z', nil, 0, 15, 80))
    #sphere effects
        self:HideBone('sphere', true)
    #sphere energy effects
        self.Trash:Add(CreateAttachedEmitter(self, 'sphere', self:GetArmy(), '/effects/emitters/quark_bomb2_02_emit.bp'))
    #energy beam effects
        self.Trash:Add(AttachBeamEntityToEntity(self, 'beam_emitter', self, 'sphere', self:GetArmy(), '/effects/emitters/zapper_beam_01_emit.bp'))
        self.Trash:Add(AttachBeamEntityToEntity(self, 'beam_point01', self, 'sphere', self:GetArmy(), '/effects/emitters/build_beam_02_emit.bp'))
        self.Trash:Add(AttachBeamEntityToEntity(self, 'beam_point02', self, 'sphere', self:GetArmy(), '/effects/emitters/build_beam_02_emit.bp'))
        self.Trash:Add(AttachBeamEntityToEntity(self, 'beam_point03', self, 'sphere', self:GetArmy(), '/effects/emitters/build_beam_02_emit.bp'))
    end,

    OnDestroy = function(self)
    	if self.Trash then
            self.Trash:Destroy()
        end
    end,
}

TypeClass = UAB2306_A