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

--M&B: the panel's kill row (the little icon + number at the bottom, driven by statFuncs[3])
--reads info.kills -- which mirrors the KILLS stat, and in M&B that stat holds killed MASS, so
--the number just duplicated the veterancy bar. Show the real kill COUNT instead: the sim keeps
--a per-unit tally in the 'MNBKills' stat (+1 to the finisher per kill, hook/lua/sim/Unit.lua).
--statFuncs is a local of the base unitview.lua chunk, reachable here as an upvalue.
statFuncs[3] = function(info)
    local iMNBKillCount = 0
    if info.userUnit and info.userUnit.GetStat then
        local tMNBKc = info.userUnit:GetStat('MNBKills', 0)
        if tMNBKc and tMNBKc.Value then iMNBKillCount = tMNBKc.Value end
    end
    if iMNBKillCount > 0 then
        return string.format('%d', iMNBKillCount)
    end
    return false
end

local oldUpdateWindow = UpdateWindow
function UpdateWindow(info)
    oldUpdateWindow(info)

    -- Nothing to add for placeholder / blueprint-only rollovers.
    if info == nil or info.userUnit == nil then return end

    local bp = info.userUnit:GetBlueprint()

    -- (3) M&B: veterancy display, faithful port of FAF's unitview veterancy block (their
    --     unitview.lua ~541-609 + the layout files): a thin progress bar filling towards the
    --     NEXT veteran level, with FAF's own texture pair (healthbar_bg + fuelbar fill), a
    --     "current / next threshold" readout in FAF's K/M formatting, and the total mass killed
    --     once max level is reached. The vanilla veterancy stars (controls.vetIcons) are LEFT
    --     ALONE (user 2026-09-11: wanted them back -- the bar alone hid the level at a glance).
    --     KILLS holds accumulated MASS in M&B, so info.kills serves as both the level and the
    --     progress value for both the stars and the bar.
    --     MUST run before the GAZ_UI deferral below.
    --M&B: info.kills is the ENGINE's own kill COUNT (built by the engine for the info table) --
    --it is NOT our KILLS stat, which holds accumulated killed MASS. Read the stat straight off
    --the userUnit proxy instead (the very same client-side GetStat channel MnbShieldMax already
    --uses), so the bar tracks killed MASS, matching the world veterancy levels.
    local killsMass = info.kills or 0
    if info.userUnit and info.userUnit.GetStat then
        local tMNBKills = info.userUnit:GetStat('KILLS', 0)
        if tMNBKills and tMNBKills.Value then killsMass = tMNBKills.Value end
    end
    if killsMass then
        local veterancyLevels = bp.Veteran or veterancyDefaults
        local level = 0
        for i = 1, 5 do
            if killsMass >= (veterancyLevels[string.format('Level%d', i)] or math.huge) then level = i end
        end

        if controls.mnbVetBar == nil then
            controls.mnbVetBar = StatusBar(controls.bg, 0, 1, false, false, nil, nil, true)
            -- Exact FAF geometry (their layouts/unitview_mini.lua): a SHORT 56x3 bar in the
            -- panel's top-right corner -- NOT a full-width strip -- with the readout right under it.
            LayoutHelpers.AtLeftTopIn(controls.mnbVetBar, controls.bg, 192, 68)
            controls.mnbVetBar.Width:Set(56)
            controls.mnbVetBar.Height:Set(3)
            controls.mnbVetBar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/healthbar_bg.dds'))
            controls.mnbVetBar._bar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/fuelbar.dds'))
            controls.mnbVetText = UIUtil.CreateText(controls.mnbVetBar, '', 10, UIUtil.bodyFont)
            controls.mnbVetText:SetDropShadow(true)
            LayoutHelpers.Below(controls.mnbVetText, controls.mnbVetBar)
        end

        -- FAF text ladder: 1.2K/4.5K above 10k, plain numbers below.
        local function MNBVetNum(v)
            if v >= 1000000 then
                return string.format('%.2fM', v / 1000000)
            elseif v >= 10000 then
                return string.format('%.1fK', v / 1000)
            end
            return string.format('%d', v)
        end

        local progress = nil
        local text = ''
        if level < 5 then
            local lo = 0
            if level > 0 then lo = veterancyLevels[string.format('Level%d', level)] or 0 end
            local hi = veterancyLevels[string.format('Level%d', level + 1)] or 0
            if hi > lo then
                progress = (killsMass - lo) / (hi - lo)
                text = MNBVetNum(killsMass) .. '/' .. MNBVetNum(hi)
            end
        else
            progress = 1
            text = MNBVetNum(killsMass)
        end
        if progress then
            controls.mnbVetBar:SetValue(progress)
            controls.mnbVetText:SetText(text)
            controls.mnbVetBar:Show()
            controls.mnbVetText:Show()
        else
            controls.mnbVetBar:Hide()
            controls.mnbVetText:Hide()
        end
    end

    -- (4) M&B: lab war readout (user 2026-09-11; 2026-09-14 rename): two STACKED lines --
    --     lifetime KILLED mass (war income, kills only) on top, the DIVIDEND under it:
    --     how much real mass the army has received from the 20% kill conversion ("награда
    --     за голову"; user 2026-09-11: "убито смести левее, запас -- под убито"). White
    --     fill with a black outline: the MAUI text control has no stroke of its own, so
    --     the outline is four black copies at the diagonals under the white text. Same
    --     client-side GetStat channel as the shield max; the lab mirrors both brain
    --     values onto its stats once a second from MNBLabelFeedThread.
    if table.find(bp.Categories or {}, 'RESEARCHCENTRE') and info.userUnit.GetStat then
        if controls.mnbWarK == nil then
            local function MNBWarCreateLine()
                local tMNBBG = {}
                for iMNBIdx = 1, 4 do
                    tMNBBG[iMNBIdx] = UIUtil.CreateText(controls.bg, '', 10, UIUtil.bodyFont)
                    tMNBBG[iMNBIdx]:SetColor('ff000000')
                end
                local oMNBFG = UIUtil.CreateText(controls.bg, '', 10, UIUtil.bodyFont)
                oMNBFG:SetColor('ffffffff')
                return tMNBBG, oMNBFG
            end
            controls.mnbWarKB, controls.mnbWarK = MNBWarCreateLine()
            controls.mnbWarPB, controls.mnbWarP = MNBWarCreateLine()
            LayoutHelpers.AtLeftTopIn(controls.mnbWarK, controls.bg, 180, 82)
            LayoutHelpers.AtLeftTopIn(controls.mnbWarP, controls.bg, 180, 93)
            local tMNBOff = { {1, 1}, {1, -1}, {-1, 1}, {-1, -1} }
            for iMNBIdx = 1, 4 do
                LayoutHelpers.AtLeftTopIn(controls.mnbWarKB[iMNBIdx], controls.mnbWarK, tMNBOff[iMNBIdx][1], tMNBOff[iMNBIdx][2])
                LayoutHelpers.AtLeftTopIn(controls.mnbWarPB[iMNBIdx], controls.mnbWarP, tMNBOff[iMNBIdx][1], tMNBOff[iMNBIdx][2])
            end
        end
        local function MNBWarNum(v)
            if v >= 1000000 then
                return string.format('%.2fM', v / 1000000)
            elseif v >= 10000 then
                return string.format('%.1fK', v / 1000)
            end
            return string.format('%d', v)
        end
        local tMNBWarK = info.userUnit:GetStat('MNBWarKilled', 0)
        local tMNBWarP = info.userUnit:GetStat('MNBDividend', 0)
        local iMNBWarK = (tMNBWarK and tMNBWarK.Value) or 0
        local iMNBWarP = (tMNBWarP and tMNBWarP.Value) or 0
        local sMNBWarK = 'убито ' .. MNBWarNum(iMNBWarK)
        local sMNBWarP = 'дивиденды ' .. MNBWarNum(iMNBWarP)
        --SetText only on change: UpdateWindow runs hot, six controls should not churn
        if sMNBWarK ~= (controls.mnbWarKLast or '') then
            controls.mnbWarKLast = sMNBWarK
            controls.mnbWarK:SetText(sMNBWarK)
            for iMNBIdx = 1, 4 do controls.mnbWarKB[iMNBIdx]:SetText(sMNBWarK) end
        end
        if sMNBWarP ~= (controls.mnbWarPLast or '') then
            controls.mnbWarPLast = sMNBWarP
            controls.mnbWarP:SetText(sMNBWarP)
            for iMNBIdx = 1, 4 do controls.mnbWarPB[iMNBIdx]:SetText(sMNBWarP) end
        end
        controls.mnbWarK:Show()
        controls.mnbWarP:Show()
        for iMNBIdx = 1, 4 do
            controls.mnbWarKB[iMNBIdx]:Show()
            controls.mnbWarPB[iMNBIdx]:Show()
        end
    elseif controls.mnbWarK ~= nil then
        controls.mnbWarK:Hide()
        controls.mnbWarP:Hide()
        for iMNBIdx = 1, 4 do
            controls.mnbWarKB[iMNBIdx]:Hide()
            controls.mnbWarPB[iMNBIdx]:Hide()
        end
    end

    -- GAZ_UI detailed unit view owns the health/shield readouts -- defer those to avoid duplicate
    -- text (its hook mirrors our regen/shield formulas). Only sections (1)/(2) are skipped.
    if controls.shieldText ~= nil then return end

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
        --M&B: the veterancy level must come from the KILLS stat (killed MASS), not info.kills
        --(the engine hover's kills is a plain kill COUNT that never reaches our mass
        --thresholds, so "+regen/s" all but never counted the veterancy regen)
        local killsMassRegen = info.kills or 0
        if info.userUnit and info.userUnit.GetStat then
            local tMNBKr = info.userUnit:GetStat('KILLS', 0)
            if tMNBKr and tMNBKr.Value then killsMassRegen = tMNBKr.Value end
        end
        local vetRegen = 0
        local veterancyLevels = bp.Veteran or veterancyDefaults
        if killsMassRegen >= veterancyLevels[string.format('Level%d', 1)] then
            local lvl = 1
            for i = 2, 5 do
                if killsMassRegen >= veterancyLevels[string.format('Level%d', i)] then
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
            -- script-granted shields (engineer/factory research domes) have no blueprint shield spec:
            -- their max comes from the live stat alone and they ALWAYS use the dynamic regen model
            local bpRegen = shieldBp and shieldBp.ShieldRegenRate or nil
            if not shieldBp then bpRegen = 1 end
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
