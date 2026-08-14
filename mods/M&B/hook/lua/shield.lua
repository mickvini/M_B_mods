#****************************************************************************
#**
#**  File     :  /lua/shield.lua
#**  Author(s):  John Comes, Gordon Duclos
#**
#**  Summary  : Shield lua module
#**
#**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local Entity = import('/lua/sim/Entity.lua').Entity
local EffectTemplate = import('/lua/EffectTemplates.lua')
local Util = import('utilities.lua')

-- === M&B: gap-based shield regen + energy spent only on regen ===
local MNB_SHIELD_REGEN_FRACTION = 0.05    -- regenerates 5% of the gap (max - current) per second
local MNB_SHIELD_REGEN_FLOOR    = 2       -- but at least 2 HP/sec, so it always tops up to 100%
local MNB_BREAK_DELAY_BASE      = 10      -- downtime after a break: base seconds (small shields don't pop back instantly)
local MNB_BREAK_DELAY_PER_1K    = 1       -- ...plus 1 second per full 1000 HP, rounded up (13200 HP -> 24s)
local MNB_BREAK_SEED_FRACTION   = 0.05    -- after the pause the shield starts at ~5% and stretches up at 5%/s; not 0, or any scratch would re-break it
local MNB_SHIELD_ENERGY_PER_HP  = 3       -- regen cost: 1 HP = 3 energy (no energy -> shield does not fall, it just stops healing)

LOG('MNB shield.lua: dynamic shield hook loaded (gap-based regen, no passive energy drain)')

local oldShield = Shield
Shield = Class(oldShield) {
    -- M&B: dynamic regen -- % of the gap (max - current) per second, never below FLOOR.
    -- The thread is NOT reset by incoming hits: regen runs continuously until the shield is full or broken.
    -- Energy cost is a VISIBLE maintenance drain (1 HP = 1 energy), NOT TakeResource: TakeResource only taps
    -- the energy STORAGE buffer, which is invisible in the +/- rate and effectively free while there is surplus.
    RegenStartThread = function(self)
        WaitSeconds(self.RegenStartTime)
        local unit = self.Owner
        while self:GetHealth() < self:GetMaxHealth() do
            local gap = self:GetMaxHealth() - self:GetHealth()
            local desired = math.max(gap * MNB_SHIELD_REGEN_FRACTION, MNB_SHIELD_REGEN_FLOOR)
            desired = math.min(desired, gap)

            -- Ask for `desired` energy/s as a maintenance cost -- this shows up in the +/- rate.
            -- For units with their own energy upkeep (mass fabricators: MaintenanceConsumptionPerSecondEnergyFab)
            -- the regen price is ADDED on top, not replaced -- otherwise a fabricator under fire loses its own
            -- upkeep (and with it mass production) while the shield stretches back up.
            local ownMaint = 0
            local econ = unit:GetBlueprint().Economy
            if econ.MaintenanceConsumptionPerSecondEnergyFab and unit.Prodon ~= false then
                ownMaint = econ.MaintenanceConsumptionPerSecondEnergyFab
            end
            unit:SetEnergyMaintenanceConsumptionOverride(ownMaint + desired * MNB_SHIELD_ENERGY_PER_HP)
            unit:SetMaintenanceConsumptionActive()

            -- Heal only by as much energy as the unit actually receives this tick:
            -- GetResourceConsumed = 1.0 at full power, < 1.0 when energy-starved. Low power -> less heal,
            -- but the shield never collapses (OnState does not drop it on low energy).
            local frac = unit:GetResourceConsumed()
            local healed = desired * frac
            LOG('MNB shield regen: hp '..math.floor(self:GetHealth())..'/'..self:GetMaxHealth()..' want='..desired..' power='..tostring(frac)..' healed='..math.floor(healed))
            if healed > 0 then
                self:AdjustHealth(self.Owner, healed)
                self:UpdateShieldRatio(-1)
            end
            WaitSeconds(1)
        end
        self:StopRegen()
        self.RegenThread = nil
    end,

    -- M&B: stop charging energy for regen (maintenance override back to 0, consumption flag off).
    -- Called when regen ends (shield full), and when the shield breaks, so the unit never keeps draining
    -- after regen stops. The manual-off case is handled in hook/lua/sim/Unit.lua (OnShieldDisabled).
    -- EXCEPTION: mass fabricators (MaintenanceConsumptionPerSecondEnergyFab in their blueprint) run their
    -- own upkeep/production logic tied to the maintenance flag -- deactivating maintenance here stops their
    -- mass production outright (SAB1313 bug: produced for ~1s, then went silent). For them, hand control
    -- back to their script: active production = Fab upkeep; a paused fabricator (Prodon=false) is left alone.
    StopRegen = function(self)
        local unit = self.Owner
        if unit and not unit.Dead then
            local econ = unit:GetBlueprint().Economy
            if econ.MaintenanceConsumptionPerSecondEnergyFab then
                if unit.Prodon ~= false then
                    unit:SetEnergyMaintenanceConsumptionOverride(econ.MaintenanceConsumptionPerSecondEnergyFab)
                    unit:SetMaintenanceConsumptionActive()
                end
            else
                unit:SetEnergyMaintenanceConsumptionOverride(0)
                unit:SetMaintenanceConsumptionInactive()
            end
        end
    end,

    -- M&B: hits no longer reset regen -- the shield recovers even while under fire.
    -- The regen thread is started once (if not already running) and lives until the shield is
    -- fully charged or broken.
    OnDamage = function(self, instigator, amount, vector, type)
        local absorbed = self:OnGetDamageAbsorption(instigator, amount, type)

        if self.PassOverkillDamage then
            local overkill = self:GetOverkill(instigator, amount, type)
            if self.Owner and IsUnit(self.Owner) and overkill > 0 then
                self.Owner:DoTakeDamage(instigator, overkill, vector, type)
            end
        end

        self:AdjustHealth(instigator, -absorbed)
        self:UpdateShieldRatio(-1)

        if self:GetHealth() <= 0 then
            -- broken: stop regen and go to recharge
            if self.RegenThread then
                KillThread(self.RegenThread)
                self.RegenThread = nil
            end
            self:StopRegen()
            ChangeState(self, self.DamageRechargeState)
        else
            if self.OffHealth < 0 then
                ForkThread(self.CreateImpactEffect, self, vector)
                -- start regen only if it isn't already running
                if self.RegenRate > 0 and self.RegenThread == nil then
                    self.RegenThread = ForkThread(self.RegenStartThread, self)
                    self.Owner.Trash:Add(self.RegenThread)
                end
            else
                self:UpdateShieldRatio(0)
            end
        end
    end,

    -- M&B: charge the bar at a fixed rate (10 ticks = 1 second -> exactly `time` seconds).
    -- Vanilla derived the speed from GetResourceConsumed, which became unpredictable once the
    -- passive drain was removed.
    ChargingUp = function(self, curProgress, time)
        while curProgress < time do
            curProgress = math.min(curProgress + 0.1, time)
            self:UpdateShieldRatio(curProgress / time)
            WaitTicks(1)
        end
    end,

    -- M&B: an enabled shield NO LONGER drains energy passively. Energy is spent only inside
    -- RegenStartThread (on healing). The shield also no longer collapses on low energy -- it just
    -- sits at its current health until energy is available again.
    -- NOTE: the passive drain was actually switched off in hook/lua/sim/Unit.lua (OnShieldEnabled),
    -- not here -- this OnState still calls self.Owner:OnShieldEnabled() for the sound/event.
    OnState = State {
        Main = function(self)
            -- Turning back on after a manual toggle: short bar charge-up
            if self.OffHealth >= 0 then
                self:ChargingUp(0, self.ShieldEnergyDrainRechargeTime)
            end
            self.OffHealth = -1

            self:UpdateShieldRatio(-1)
            self.Owner:OnShieldEnabled()
            self:CreateShieldMesh()

            -- Always start regen when the shield isn't full: covers both manual re-enable and
            -- recovery from a break (then it stretches up from ~5% at 5%/s, spending energy).
            if self:GetHealth() < self:GetMaxHealth() and self.RegenRate > 0 and self.RegenThread == nil then
                self.RegenThread = ForkThread(self.RegenStartThread, self)
                self.Owner.Trash:Add(self.RegenThread)
            end

            -- Hold the state until the shield is toggled off or broken.
            while true do
                WaitSeconds(1)
                -- M&B: while the shield is NOT regenerating it must not drain energy. Personal shields
                -- (ACU/SACU) have their enhancement script re-enable a flat maintenance drain on install;
                -- cancelling it here every second while idle keeps energy spent only on actual regen (handled
                -- in RegenStartThread). Harmless for structure shields, which are already inactive when idle.
                if self.RegenThread == nil then
                    self:StopRegen()
                end
                self:UpdateShieldRatio(-1)
            end
        end,

        IsOn = function(self)
            return true
        end,
    },

    -- M&B: downtime after a break = 10s + 1s per full 1000 HP (rounded up):
    -- 1000 HP -> 11s, 10000 HP -> 20s, 13200 HP -> 24s, 20000 HP -> 30s.
    -- After the pause the shield does NOT come back full -- it starts at ~5% and stretches up at 5%/s
    -- (spending energy). So a big shield doesn't revive too fast, and a small one doesn't wait forever.
    DamageRechargeState = State {
        Main = function(self)
            self:RemoveShield()
            local pause = MNB_BREAK_DELAY_BASE + math.ceil(self:GetMaxHealth() / 1000) * MNB_BREAK_DELAY_PER_1K
            self:ChargingUp(0, pause)
            self:SetHealth(self, math.max(1, self:GetMaxHealth() * MNB_BREAK_SEED_FRACTION))
            ChangeState(self, self.OnState)
        end
    },

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

-- M&B: apply the SAME dynamic regen to PERSONAL shields (ACU / SACU / Czar). The base UnitShield inherits
-- the VANILLA Shield states (it was built from the base Shield before this hook wrapped it), so without this
-- its regen is still the fixed linear kind -- exactly the "fixed shield regen" seen on an upgraded ACU.
-- IMPORTANT: we CANNOT reuse Shield's State objects (OnState / DamageRechargeState) by reference -- class.lua
-- asserts that a class spec never holds an already-built State (getmetatable(v) ~= State), which crashed
-- shield.lua on load and stopped the game from starting. Plain function methods are reused by reference (that
-- is fine); the States are re-declared fresh below with the same bodies. Personal shields differ only in
-- collision and mesh handling (UnitShield's own OnCreate / CreateShieldMesh / RemoveShield), which this wrap
-- leaves untouched. CzarShield below extends this wrapped UnitShield, so it becomes dynamic too.
local oldUnitShield = UnitShield
UnitShield = Class(oldUnitShield) {
    RegenStartThread = Shield.RegenStartThread,
    StopRegen = Shield.StopRegen,
    OnDamage = Shield.OnDamage,
    ChargingUp = Shield.ChargingUp,
    OnState = State {
        Main = function(self)
            if self.OffHealth >= 0 then
                self:ChargingUp(0, self.ShieldEnergyDrainRechargeTime)
            end
            self.OffHealth = -1
            self:UpdateShieldRatio(-1)
            self.Owner:OnShieldEnabled()
            self:CreateShieldMesh()
            if self:GetHealth() < self:GetMaxHealth() and self.RegenRate > 0 and self.RegenThread == nil then
                self.RegenThread = ForkThread(self.RegenStartThread, self)
                self.Owner.Trash:Add(self.RegenThread)
            end
            while true do
                WaitSeconds(1)
                if self.RegenThread == nil then
                    self:StopRegen()
                end
                self:UpdateShieldRatio(-1)
            end
        end,
        IsOn = function(self)
            return true
        end,
    },
    DamageRechargeState = State {
        Main = function(self)
            self:RemoveShield()
            local pause = MNB_BREAK_DELAY_BASE + math.ceil(self:GetMaxHealth() / 1000) * MNB_BREAK_DELAY_PER_1K
            self:ChargingUp(0, pause)
            self:SetHealth(self, math.max(1, self:GetMaxHealth() * MNB_BREAK_SEED_FRACTION))
            ChangeState(self, self.OnState)
        end
    },
}

CzarShield = Class(UnitShield) {
    OnCreate = function(self, spec)
        self.Trash = TrashBag()
        self.Owner = spec.Owner
        self.MeshBp = spec.Mesh
        self.ImpactMeshBp = spec.ImpactMesh
        self.ImpactMeshBigBp = spec.ImpactMeshBig

        self.ImpactEffects = EffectTemplate[spec.ImpactEffects]
        self.CollisionSizeX = spec.CollisionSizeX or 1
        self.CollisionSizeY = spec.CollisionSizeY or 1
        self.CollisionSizeZ = spec.CollisionSizeZ or 1
        self.CollisionCenterX = spec.CollisionCenterX or 0
        self.CollisionCenterY = spec.CollisionCenterY or 0
        self.CollisionCenterZ = spec.CollisionCenterZ or 0
        self.OwnerShieldMesh = spec.OwnerShieldMesh or ''

        self:SetSize(spec.Size)
        self:SetType('Personal')

        self:SetMaxHealth(spec.ShieldMaxHealth)
        self:SetHealth(self, spec.ShieldMaxHealth)

        -- Show our 'lifebar'
        self:UpdateShieldRatio(1.0)

        self:SetRechargeTime(spec.ShieldRechargeTime or 5, spec.ShieldEnergyDrainRechargeTime or 5)
        self:SetVerticalOffset(spec.ShieldVerticalOffset)

        self:SetVizToFocusPlayer('Always')
        self:SetVizToEnemies('Intel')
        self:SetVizToAllies('Always')
        self:SetVizToNeutrals('Always')

        self:AttachBoneTo(-1, spec.Owner, -1)

        self:SetShieldRegenRate(spec.ShieldRegenRate)
        self:SetShieldRegenStartTime(spec.ShieldRegenStartTime)

        self.PassOverkillDamage = spec.PassOverkillDamage

        ChangeState(self, self.OnState)
    end,


    CreateImpactEffect = function(self, vector)
        if not self or self.Owner.Dead then return end
        local army = self:GetArmy()
        local OffsetLength = Util.GetVectorLength(vector)
        local ImpactMesh = Entity {Owner = self.Owner}
        local pos = self:GetPosition()

        -- Shield has non-standard form (ellipsoid) and no collision, so we need some magic to make impacts look good
        -- All impacts from above and below (>1 & <1) cause big pulses in the center of shield
        -- Projectiles that come from same elevation (ASF etc.) cause small pulses on the edge of shield using
        -- standard effect from static shields
        if vector.y > 1 then
            Warp(ImpactMesh, {pos[1], pos[2] + 9.5, pos[3]})

            ImpactMesh:SetMesh(self.ImpactMeshBigBp)
            ImpactMesh:SetDrawScale(self.Size)
            ImpactMesh:SetOrientation(OrientFromDir(Vector(0, -30, 0)), true)
        elseif vector.y < -1 then
            Warp(ImpactMesh, {pos[1], pos[2] - 9.5, pos[3]})

            ImpactMesh:SetMesh(self.ImpactMeshBigBp)
            ImpactMesh:SetDrawScale(self.Size)
            ImpactMesh:SetOrientation(OrientFromDir(Vector(0, 30, 0)), true)
        else
            Warp(ImpactMesh, {pos[1], pos[2], pos[3]})

            ImpactMesh:SetMesh(self.ImpactMeshBp)
            ImpactMesh:SetDrawScale(self.Size)
            ImpactMesh:SetOrientation(OrientFromDir(Vector(-vector.x, -vector.y, -vector.z)), true)
        end

        for _, v in self.ImpactEffects do
            CreateEmitterAtBone(ImpactMesh, -1, army, v):OffsetEmitter(0, 0, OffsetLength)
        end

        WaitSeconds(5)
        ImpactMesh:Destroy()
    end,

    CreateShieldMesh = function(self)
        -- Personal shields (unit shields) don't handle collisions anymore.
        -- This is done in the Unit's OnDamage function instead.
        self:SetCollisionShape('None')

        self:SetMesh(self.MeshBp)
        self:SetParentOffset(Vector(0, self.ShieldVerticalOffset, 0))
        self:SetDrawScale(self.Size)
    end,

    OnDestroy = function(self)
        Shield.OnDestroy(self)
    end,

    RemoveShield = function(self)
        Shield.RemoveShield(self)
        self:SetCollisionShape('None')
    end,
}

-- === M28AI hook merged (was separate M28AI mod; paths rewritten in Phase 2) ===
---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by maudlin27.
--- DateTime: 02/12/2022 09:07
---
local M28Events = import('/mods/M&B/lua/AI/M28Events.lua')

do --Per Balthazaar - encasing the code in do .... end means that you dont have to worry about using unique variables
    local M28OldShield = Shield
    Shield = Class(M28OldShield) {
        OnDamage = function(self, instigator, amount, vector, dmgType)
            M28OldShield.OnDamage(self, instigator, amount, vector, dmgType)
            ForkThread(M28Events.OnShieldBubbleDamaged, self, instigator)
        end,
        IsUp = function(self)
            if M28OldShield.IsUp then return M28OldShield.IsUp(self)
            else
                return (self:IsOn() and self.Enabled)
            end
        end,
    }
end
