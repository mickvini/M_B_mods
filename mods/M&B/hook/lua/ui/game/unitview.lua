-- M&B: dynamic regen display on the unit info panel, WITHOUT needing GAZ_UI.
--
-- Two things are shown when the player hovers / selects a unit:
--   (1) Health regen appended to the health readout "h / max": base RegenRate + EVERY installed
--       enhancement that grants NewRegenRate + the veterancy regen buff. The vanilla panel and the
--       old GAZ_UI code only ever showed a single source, so the number was far too low.
--   (2) Dynamic shield regen "cur / max +regen/s" on M&B's own shield text -- 5% of the MISSING
--       shield HP per second, min 2, 0 when full. This mirrors the sim-side model in
--       hook/lua/shield.lua (MNB_SHIELD_REGEN_FRACTION = 0.05, MNB_SHIELD_REGEN_FLOOR = 2); keep the
--       two in sync.
--
-- COEXISTENCE WITH GAZ_UI: when GAZ_UI's detailed unit view is on it creates controls.shieldText and
-- drives BOTH displays itself (the same formulas are mirrored in mods/GAZ_UI/.../unitview.lua). We
-- detect that here with `controls.shieldText ~= nil` and do nothing, so running both mods at once
-- never produces doubled text. This check is reliable regardless of mod load order, because every
-- mod's CreateUI finishes before the first UpdateWindow call. The shield text control itself is
-- created by the layout hook (hook/lua/ui/game/layouts/unitview_mini.lua); here we only set its
-- value -- and create it defensively if some non-mini layout skipped the layout hook.

local MNB_UI_REGEN_FRACTION = 0.05   -- must match MNB_SHIELD_REGEN_FRACTION in hook/lua/shield.lua
local MNB_UI_REGEN_FLOOR    = 2      -- must match MNB_SHIELD_REGEN_FLOOR

local getEnh = import('/lua/enhancementcommon.lua')

local oldUpdateWindow = UpdateWindow
function UpdateWindow(info)
    oldUpdateWindow(info)

    -- Nothing to add for placeholder / blueprint-only rollovers.
    if info == nil or info.userUnit == nil then return end

    -- GAZ_UI detailed unit view owns the panel -- defer entirely to avoid duplicate text.
    if controls.shieldText ~= nil then return end

    local bp = info.userUnit:GetBlueprint()

    -- (1) Health regen: base + sum of installed enhancement NewRegenRate + veterancy.
    if info.health then
        local enhRegen = 0
        local installed = getEnh.GetEnhancements(info.entityId)
        if installed ~= nil then
            for k, enhName in installed do
                if enhName and bp.Enhancements[enhName] and bp.Enhancements[enhName].NewRegenRate then
                    enhRegen = enhRegen + bp.Enhancements[enhName].NewRegenRate
                end
            end
        end
        local baseRegen = math.floor(bp.Defense.RegenRate or 0)

        -- Veterancy regen: bp.Buffs.Regen['LevelN'] at the highest veteran level reached.
        local vetRegen = 0
        local veterancyLevels = bp.Veteran or veterancyDefaults
        if info.kills >= veterancyLevels[string.format('Level%d', 1)] then
            local lvl = 1
            for i = 2, 5 do
                if info.kills >= veterancyLevels[string.format('Level%d', i)] then
                    lvl = i
                end
            end
            if bp.Buffs and bp.Buffs.Regen then
                vetRegen = math.floor(bp.Buffs.Regen[string.format('Level%d', lvl)] or 0)
            end
        end

        local totalRegen = baseRegen + enhRegen + vetRegen
        if totalRegen > 0 then
            controls.health:SetText(string.format("%d / %d +%d/s", info.health, info.maxHealth, totalRegen))
        end
    end

    -- (2) Dynamic shield regen on M&B's own shield text.
    if info.shieldRatio > 0 then
        -- Resolve the shield max health + regen rate. Structure shields carry them on Defense.Shield;
        -- personal / enhancement shields (ACU, SACU) carry them on the installed back-slot enhancement.
        local shieldBp, shieldMaxHealth
        local sBp = bp.Defense.Shield
        if sBp and sBp.ShieldMaxHealth then
            shieldBp = sBp
            shieldMaxHealth = sBp.ShieldMaxHealth
        else
            local enh = getEnh.GetEnhancements(info.entityId)
            if enh and enh.Back and bp.Enhancements[enh.Back] then
                shieldBp = bp.Enhancements[enh.Back]
                shieldMaxHealth = shieldBp.ShieldMaxHealth
            end
        end

        -- M&B: prefer the LIVE buffed shield max health (synced from sim via the 'MnbShieldMax' stat) over
        -- the blueprint value. Adjacency/accumulator buffs grow the real max in hook/lua/sim/Buff.lua; the
        -- blueprint number never changes, so without this the panel shows a stale ceiling. The stat is absent
        -- (=0) when no buff has touched the shield, in which case the blueprint value set above is correct.
        -- Using the live max here also fixes the current/regen numbers, since both are derived from it.
        if info.userUnit.GetStat then
            local liveMax = info.userUnit:GetStat('MnbShieldMax', 0).Value or 0
            if liveMax > 0 then
                shieldMaxHealth = liveMax
            end
        end

        if shieldMaxHealth then
            -- Defensive: if the layout hook did not create the control (e.g. a non-mini layout), make it now.
            if controls.mnbShieldText == nil then
                controls.mnbShieldText = UIUtil.CreateText(controls.bg, '', 13, UIUtil.bodyFont)
                controls.mnbShieldText:SetDropShadow(true)
                LayoutHelpers.CenteredBelow(controls.mnbShieldText, controls.shieldBar, 2)
            end
            local curShield = math.floor(shieldMaxHealth * info.shieldRatio)
            local bpRegen = shieldBp.ShieldRegenRate
            if bpRegen and bpRegen > 0 then
                local gap = shieldMaxHealth - curShield
                local dynRegen = 0
                if gap > 0 then
                    dynRegen = math.min(math.max(gap * MNB_UI_REGEN_FRACTION, MNB_UI_REGEN_FLOOR), gap)
                end
                controls.mnbShieldText:SetText(string.format("%d / %d +%d/s", curShield, shieldMaxHealth, dynRegen))
            else
                controls.mnbShieldText:SetText(string.format("%d / %d", curShield, shieldMaxHealth))
            end
            controls.mnbShieldText:Show()
        end
    elseif controls.mnbShieldText ~= nil then
        controls.mnbShieldText:Hide()
    end
end
