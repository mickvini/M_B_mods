--M&B: Alt+O auto-overcharge toggle for the player's ACU (off by default every
--session, like the Alt-E economy helper). Same plumbing as skuftoggle.lua:
--SimCallback down into the sim; the flag lands on the player's commanders.

AutoOCEnabled = false

function Toggle()
    AutoOCEnabled = not AutoOCEnabled
    SimCallback({ Func = 'MNB_AutoOCSet', Args = { army = GetFocusArmy(), enabled = AutoOCEnabled } })
    print('M&B auto-overcharge: ' .. (AutoOCEnabled and 'ON' or 'OFF'))
end

function Install()
    IN_AddKeyMapTable({
        ['Alt-O'] = {
            action = 'ui_lua import("/mods/M&B/lua/autooctoggle.lua").Toggle()',
        },
    })
end
