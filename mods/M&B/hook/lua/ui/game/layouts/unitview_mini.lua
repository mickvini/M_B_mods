-- M&B: make room on the unit info panel for a shield-regen text line, ONLY when GAZ_UI's detailed
-- unit view is NOT active.
--
-- The vanilla mini layout has no free row for shield text (the 2px shield bar sits on the bottom edge
-- of the health bar and the stat icons start right below). GAZ_UI solves this with its own layout
-- hook on this same file that lifts the health bar up and drops the shield bar onto its own line.
-- We mirror that arrangement here for M&B's own controls.mnbShieldText, so the panel reads well
-- without GAZ_UI.
--
-- COEXISTENCE: when GAZ_UI's detailed view is on it has already created controls.shieldText and its
-- own layout hook (in this same file, chained ahead of or behind us) has arranged things. We detect
-- that with `controls.shieldText ~= nil` and return early, so the two mods never fight over the
-- layout. SetLayout always runs AFTER the full CreateUI chain (see SetupUnitViewLayout in
-- unitview.lua: CreateUI() then SetLayout()), so the shieldText-existence check reliably tells us
-- whether GAZ_UI owns the panel, regardless of mod load order.

local oldSetLayout = SetLayout
SetLayout = function()
    oldSetLayout()

    local controls = import('/lua/ui/game/unitview.lua').controls

    -- GAZ_UI detailed view active -> it made the room and owns the shield text. Defer.
    if controls.shieldText ~= nil then return end

    -- Create M&B's own shield text once, parented to the panel background.
    if controls.mnbShieldText == nil then
        controls.mnbShieldText = UIUtil.CreateText(controls.bg, '', 13, UIUtil.bodyFont)
        controls.mnbShieldText:SetDropShadow(true)
        controls.mnbShieldText:Hide()
    end

    -- Lift the health bar up and drop the shield bar onto its own line just beneath it, leaving a
    -- clear row for the shield text. Mirrors GAZ_UI's arrangement (proven to read well). These only
    -- re-bind the Top/Left layout closures, so Width/Height set by the base layout are preserved.
    -- Resulting rows: health text ~y33, shield bar y41-43, shield text y45-58, stat icons y60.
    LayoutHelpers.AtLeftTopIn(controls.healthBar, controls.bg, 66, 25)
    LayoutHelpers.Below(controls.shieldBar, controls.healthBar)
    LayoutHelpers.CenteredBelow(controls.mnbShieldText, controls.shieldBar, 2)
end
