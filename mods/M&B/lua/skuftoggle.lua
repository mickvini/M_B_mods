------------------------------------------------------------------------
--                                                                    --
-- File           : /mods/M&B/lua/skuftoggle.lua                      --
--                                                                    --
-- Summary  : Master switch for the skuf economy helper. The helper   --
--            is OFF by default in every game; Alt-E turns it on,     --
--            another Alt-E turns it back off. All skuf UI hooks and  --
--            the sim watcher check this flag, so with the switch     --
--            off the game behaves exactly like plain M&B.            --
--                                                                    --
------------------------------------------------------------------------

-- Module-global on purpose: the ui_lua key action imports this module
-- and calls Toggle(); the flag must live as long as the UI session.
SkufEnabled = false

function IsEnabled()
    return SkufEnabled
end

function Toggle()
    SkufEnabled = not SkufEnabled
    local army = GetFocusArmy()
    if SkufEnabled then
        -- Start the sim-side watcher (idempotent: guarded by
        -- brain.SkufWatcherStarted). The army is passed explicitly --
        -- sim code must never call GetFocusArmy() there (MP desync).
        SimCallback({ Func = 'SkufInit', Args = { army = army } }, true)
    end
    SimCallback({ Func = 'SkufSetEnabled', Args = { army = army, enabled = SkufEnabled } }, false)
    LOG('MNB skuf: ' .. (SkufEnabled and 'ON' or 'OFF') .. ' (Alt-E)')
end

-- Installed from gamemain's CreateUI hook, next to SpreadOrders.
function Install()
    -- Alt-E is unbound in vanilla (the shipped keymap has no Alt-E entry;
    -- nearest neighbors are Alt-L lifebars and Ctrl-Alt-E debug windows).
    IN_AddKeyMapTable({ ['Alt-E'] = { action = 'ui_lua import("/mods/M&B/lua/skuftoggle.lua").Toggle()' }, })
    LOG('MNB skuf: Alt-E key binding installed')
end
