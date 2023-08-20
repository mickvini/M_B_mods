#****************************************************************************
#**
#**  File     :  /lua/shield.lua
#**  Author(s):  John Comes, Gordon Duclos
#**
#**  Summary  : Shield lua module
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local Entity = import('/lua/sim/Entity.lua').Entity
local EffectTemplate = import('/lua/EffectTemplates.lua')
local Util = import('utilities.lua')
local oldShield = Shield
Shield = Class(oldShield) {   
    --This state happens only when the army has run out of power
    EnergyDrainRechargeState = State {
        Main = function(self)
            if(self.ShieldEnergyDrainRechargeTime ~= -1) then
                self:RemoveShield()
                
                self:ChargingUp(0, self.ShieldEnergyDrainRechargeTime)
                
                --If the unit is attached to a transport, make sure the shield goes to the off state
                --so the shield isn't turned on while on a transport
                if not self.Owner:IsUnitState('Attached') then
                    ChangeState(self, self.OnState)
                else
                    ChangeState(self, self.OffState)
                end
            end
        end
    },

}