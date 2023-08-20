#****************************************************************************
#**
#**  File     :  /data/units/XRS0205/XRS0205_script.lua
#**  Author(s):  Jessica St. Croix
#**
#**  Summary  :  Cybran Counter-Intelligence Boat Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CSeaUnit = import('/lua/cybranunits.lua').CSeaUnit
local CIFSmartCharge = import('/lua/cybranweapons.lua').CIFSmartCharge

XRS0205 = Class(CSeaUnit) {

    Weapons = {
        AntiTorpedo = Class(CIFSmartCharge) {},
    },
    ShieldEffects = {'/mods/M&B/effects/emitters/ex_cybran_shieldgen_01_emit.bp'},

    OnStopBeingBuilt = function(self,builder,layer)
    
        CSeaUnit.OnStopBeingBuilt(self,builder,layer)        
        
        self.ShieldEffectsBag = {}
    end,
    
    OnShieldEnabled = function(self)
    
        CSeaUnit.OnShieldEnabled(self)
        
        
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
            self.ShieldEffectsBag = {}
        end
        
        for k, v in self.ShieldEffects do
            table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 'ShieldEffect', self.Army, v ) )
        end
    end,

    OnShieldDisabled = function(self)
    
        CSeaUnit.OnShieldDisabled(self)        
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
            self.ShieldEffectsBag = {}
        end
    end,
}

TypeClass = XRS0205