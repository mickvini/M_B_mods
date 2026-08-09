do
    local Prefs = import('/lua/user/prefs.lua')
    local options = Prefs.GetFromCurrentProfile('options')
    if options.gui_scu_manager != 0 then
        local originalUpdateWindow = UpdateWindow
        function UpdateWindow(info)
            originalUpdateWindow(info)
            controls.SCUType:Hide()
            if info.userUnit.SCUType then
                controls.SCUType:SetTexture('/mods/GAZ_UI/textures/scumanager/'..info.userUnit.SCUType..'_icon.dds')
                controls.SCUType:Show()
            end
        end

        local originalCreateUI = CreateUI
        function CreateUI()
            originalCreateUI()
            controls.SCUType = Bitmap(controls.bg)
            LayoutHelpers.AtRightIn(controls.SCUType, controls.icon)
            LayoutHelpers.AtBottomIn(controls.SCUType, controls.icon)
        end
    end

    if options.gui_enhanced_unitview != 0 then
        local originalCreateUI = CreateUI
        local originalUpdateWindow = UpdateWindow
        function CreateUI()
            originalCreateUI()
            local oldBGOnFrame = controls.bg.OnFrame
            controls.bg.OnFrame = function(self, delta)
                local info = GetRolloverInfo()
                -- If no rollover, then see if we have a single unit selected
                if not info and import("/mods/GAZ_UI/modules/selectedinfo.lua").SelectedInfoOn then
                    local selUnits = GetSelectedUnits()
                    if selUnits and table.getn(selUnits) == 1 and import('/lua/ui/game/unitviewDetail.lua').View.Hiding then
                        info = import("/mods/GAZ_UI/modules/selectedinfo.lua").GetUnitRolloverInfo(selUnits[1])
                        --LOG(repr(import('/lua/enhancementcommon.lua').GetEnhancements(info.entityId)))
                    end
                end
                -- Original function code
                if info then
                    UpdateWindow(info)
                    if self:GetAlpha() < 1 then
                        self:SetAlpha(math.min(self:GetAlpha() + (delta*3), 1), true)
                    end
                    import(UIUtil.GetLayoutFilename('unitview')).PositionWindow()
                elseif self:GetAlpha() > 0 then
                    self:SetAlpha(math.max(self:GetAlpha() - (delta*3), 0), true)
                end
            end
        end

        function UpdateWindow(info)
            originalUpdateWindow(info)
            -- Replace fuel bar with progress bar
            if info.blueprintId ~= 'unknown' then
                controls.fuelBar:Hide()
                if info.workProgress > 0 then
                    controls.fuelBar:Show()
                    controls.fuelBar:SetValue(info.workProgress)
                end
            end
        end
    end
    if options.gui_detailed_unitview != 0 then
        local TV = import('/mods/GAZ_UI/modules/tvcheck.lua').Init()
        if TV == false then
            local OldUpdateWindow = UpdateWindow
            function UpdateWindow(info)
                OldUpdateWindow(info)
                if info.blueprintId != 'unknown' then
                    controls.Buildrate:Hide()
                    controls.shieldText:Hide()
-- works properly but i've yet to find a good spot to put that data in

--    if info.userUnit != nil and info.userUnit:GetBlueprint().Economy.StorageMass > 0 and info.userUnit:GetBlueprint().Economy.StorageEnergy > 0 then
--       controls.StorageMass:SetText(string.format("%d",math.floor(info.userUnit:GetBlueprint().Economy.StorageMass)))
--       controls.StorageEnergy:SetText(string.format("%d",math.floor(info.userUnit:GetBlueprint().Economy.StorageEnergy)))
--       controls.StorageMass:Show()
--       controls.StorageEnergy:Show()
--    else
--       controls.StorageMass:Hide()
--       controls.StorageEnergy:Hide()
--    end

--evilnewcode
                    local getEnh = import('/lua/enhancementcommon.lua')
                    if info.userUnit != nil then
                        local bp = info.userUnit:GetBlueprint()
                        -- M&B: ACU regen ADDS UP from several sources -- the blueprint base RegenRate, EVERY
                        -- installed enhancement that carries a NewRegenRate (in M&B the engineering, shield and
                        -- weapon lines all grant regen), plus veterancy. The old code only kept ONE enhancement's
                        -- NewRegenRate (it overwrote enhRegen each loop), so the displayed number was far too low.
                        -- Sum all installed enhancements here so the UI matches the sim-side total.
                        local enhRegen = 0
                        local installed = getEnh.GetEnhancements(info.entityId)
                        if installed != nil then
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
                            for i = 2,5 do
                                if info.kills >= veterancyLevels[string.format('Level%d', i)] then
                                    lvl = i
                                end
                            end
                            if bp.Buffs and bp.Buffs.Regen then
                                vetRegen = math.floor(bp.Buffs.Regen[string.format('Level%d', lvl)] or 0)
                            end
                        end

                        local totalRegen = baseRegen + enhRegen + vetRegen
                        if info.health and totalRegen > 0 then
                            controls.health:SetText(string.format("%d / %d +%d/s", info.health, info.maxHealth, totalRegen))
                        end
                    end
--endevilnewcode

                    if info.shieldRatio > 0 and info.userUnit:GetBlueprint().Defense.Shield.ShieldMaxHealth then
                        local ShieldMaxHealth = info.userUnit:GetBlueprint().Defense.Shield.ShieldMaxHealth
                        -- M&B: show the LIVE buffed max (grown by adjacency/accumulator buffs, synced from sim
                        -- via the 'MnbShieldMax' stat) instead of the stale blueprint value. Also fixes the
                        -- current/regen numbers, since both are derived from this max. Stat is 0 when no buff
                        -- has touched the shield -> fall back to the blueprint value above.
                        if info.userUnit.GetStat then
                            local statMax = info.userUnit:GetStat('MnbShieldMax', 0).Value or 0
                            if statMax > 0 then ShieldMaxHealth = statMax end
                        end
                        local curShield = math.floor(ShieldMaxHealth * info.shieldRatio)
                        controls.shieldText:Show()
                        -- M&B: shield regen is dynamic (5% of the missing health per second, min 2, 0 when full),
                        -- NOT the static blueprint value. Keep these numbers in sync with M&B hook/lua/shield.lua
                        -- (MNB_SHIELD_REGEN_FRACTION = 0.05, MNB_SHIELD_REGEN_FLOOR = 2). Only shown for shields
                        -- that can regen at all (blueprint ShieldRegenRate > 0), matching the sim-side gate.
                        local bpRegen = info.userUnit:GetBlueprint().Defense.Shield.ShieldRegenRate
                        if bpRegen and bpRegen > 0 then
                            local gap = ShieldMaxHealth - curShield
                            local dynRegen = 0
                            if gap > 0 then
                                dynRegen = math.min(math.max(gap * 0.05, 2), gap)
                            end
                            controls.shieldText:SetText(string.format("%d / %d +%d/s", curShield, ShieldMaxHealth, dynRegen))
                        else
                            controls.shieldText:SetText(string.format("%d / %d", curShield, ShieldMaxHealth))
                        end
                    end
-- newcode
                    if info.shieldRatio > 0 and info.userUnit:GetBlueprint().Defense.Shield.ShieldMaxHealth == nil then
                        local enhBp = info.userUnit:GetBlueprint().Enhancements[getEnh.GetEnhancements(info.entityId).Back]
                        local ShieldMaxHealth = enhBp.ShieldMaxHealth
                        -- M&B: same live-buffed-max override as for structure shields (stat synced from sim).
                        if info.userUnit.GetStat then
                            local statMax = info.userUnit:GetStat('MnbShieldMax', 0).Value or 0
                            if statMax > 0 then ShieldMaxHealth = statMax end
                        end
                        local curShield = math.floor(ShieldMaxHealth * info.shieldRatio)
                        controls.shieldText:Show()
                        -- M&B: personal/enhancement shields (ACU, SACU) use the SAME dynamic regen model as
                        -- structure shields (see the UnitShield wrap in hook/lua/shield.lua), so show the dynamic
                        -- value here too -- 5% of the missing health, min 2, 0 when full. Keep in sync with
                        -- MNB_SHIELD_REGEN_FRACTION = 0.05, MNB_SHIELD_REGEN_FLOOR = 2.
                        local bpRegen = enhBp.ShieldRegenRate
                        if bpRegen and bpRegen > 0 then
                            local gap = ShieldMaxHealth - curShield
                            local dynRegen = 0
                            if gap > 0 then
                                dynRegen = math.min(math.max(gap * 0.05, 2), gap)
                            end
                            controls.shieldText:SetText(string.format("%d / %d +%d/s", curShield, ShieldMaxHealth, dynRegen))
                        else
                            controls.shieldText:SetText(string.format("%d / %d", curShield, ShieldMaxHealth))
                        end
                    end
--newcode
                    if info.userUnit != nil and info.userUnit:GetBuildRate() >= 2 then
                        controls.Buildrate:SetText(string.format("%d",math.floor(info.userUnit:GetBuildRate())))
                        controls.Buildrate:Show()
                    else
                        controls.Buildrate:Hide()
                    end
                end
            end
            local OldCreateUI = CreateUI
            function CreateUI()
                OldCreateUI()
                controls.shieldText = UIUtil.CreateText(controls.bg, '', 13, UIUtil.bodyFont)
                controls.Buildrate = UIUtil.CreateText(controls.bg, '', 12, UIUtil.bodyFont)
-- controls.StorageMass = UIUtil.CreateText(controls.bg, '', 12, UIUtil.bodyFont)
-- controls.StorageEnergy = UIUtil.CreateText(controls.bg, '', 12, UIUtil.bodyFont)
            end
        end
    end
end
