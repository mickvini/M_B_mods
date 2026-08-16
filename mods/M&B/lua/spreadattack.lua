------------------------------------------------------------------------
--                                                                    --
-- File           : /mods/M&B/lua/spreadattack.lua                    --
-- Author         : Magic Power (original per-unit shuffle version)   --
-- Rework         : M&B 2026-08                                       --
--                                                                    --
-- Summary  : Pools the queued orders of every selected unit and      --
--            deals them evenly across the selection on G/Shift+G.    --
--            Supported: Move, Attack, AggressiveMove, Build,         --
--            Repair, Reclaim, Capture. Units that also hold any      --
--            other order type (Guard, Patrol, Ferry, factory         --
--            production, ...) are left completely untouched, so no   --
--            order is ever silently lost.                            --
--                                                                    --
-- Optimization notes: no threads, no polling, no per-tick work. The  --
-- shadow copy is one small table insert per issued command; the      --
-- redistribution is a single one-shot SimCallback.                   --
--                                                                    --
------------------------------------------------------------------------

-- Shadow copy of issued orders, per unit id.
ShadowOrders = {}

-- Types we can safely re-issue on the sim side; Form* variants are
-- translated to their plain counterparts. Anything not listed here is
-- stored as a marker that excludes the unit from redistribution.
local Distributable = {
    Move               = 'Move',
    Attack             = 'Attack',
    AggressiveMove     = 'AggressiveMove',
    Build              = 'Build',
    BuildMobile        = 'Build',   -- engineer structure placement (real engine name, verified in playtest)
    Repair             = 'Repair',
    Reclaim            = 'Reclaim',
    Capture            = 'Capture',
    FormMove           = 'Move',
    FormAttack         = 'Attack',
    FormAggressiveMove = 'AggressiveMove',
    -- NOT mapped on purpose: BuildFactory = factory production orders,
    -- None = junk type. Units holding them are excluded from spreading.
}

-- Hard cap on unique orders per press, keeps the SimCallback payload small.
local MaxOrdersPerPress = 1000

-- Unknown order types are logged once per type per session, so one playtest
-- is enough to learn the exact engine name of a new order type.
local SeenUnknownTypes = {}

-- Histogram of every echo the engine sent us this session, per type, with a
-- "+clear" marker when the echo wiped the shadow queue. Answers "which echo
-- emptied the copy" in one log line instead of guesswork.
local EchoCounts = {}

-- Blueprint of the last active build ghost. Filled by the commandmode hook
-- the moment the build mode STARTS: by the time the engine echoes the
-- placement command the mode may already have ended (without Shift it ends
-- on the very next UI beat), and the echo's own Blueprint is always empty.
local BuildModeName

function RememberBuildModeName(name)
    BuildModeName = name
end

-- Recent attack clicks (target entity + position at click time). The real
-- queue holds only the target POSITION; a target that moved since the
-- click no longer matches the shadow position, so the entity id gets lost
-- and a unit-tracking attack would degrade into a flight to a stale point.
-- The nearest recently attacked target recovers the entity id.
local RecentAttacks = {}

-- While Shift is held, keep a live attack blip on every queued attack
-- target of the selection. The engine's shift-view draws only entries with
-- a ground position, so unit-targeted attacks stay invisible there --
-- selecting the squad later and holding Shift must still show WHO is
-- attacked (user, 2026-08-16: ten bombers, an eleventh joins, which one is
-- uncovered?). Re-drawn every ~0.7s to match the blip fade.
local OverlayBeat = 0
function MNBAttackOverlayBeat()
    if not IsKeyDown('Shift') then
        return
    end
    OverlayBeat = OverlayBeat + 1
    if math.mod(OverlayBeat, 40) ~= 0 then
        return
    end
    local selection = GetSelectedUnits()
    if not selection then
        return
    end
    local seenPos = {}
    local drawn = 0
    for _, unit in selection do
        if drawn >= 50 then break end
        local ok, q = pcall(function() return unit:GetCommandQueue() end)
        if ok and q then
            for _, c in q do
                if drawn >= 50 then break end
                local t = tostring(c.type)
                local p = c.position
                if (t == 'Attack' or t == 'FormAttack') and p then
                    local key = math.floor((p.x or p[1] or 0) + 0.5) .. '_' ..
                        math.floor((p.z or p[3] or 0) + 0.5)
                    if not seenPos[key] then
                        seenPos[key] = true
                        drawn = drawn + 1
                        AddCommandFeedbackBlip({
                            Position = { x = p.x or p[1], y = p.y or p[2], z = p.z or p[3] },
                            MeshName = '/meshes/game/Attack_lod0.scm',
                            TextureName = '/meshes/game/Attack_albedo.dds',
                            ShaderName = 'CommandFeedback',
                            UniformScale = 0.125,
                        }, 0.7)
                    end
                end
            end
        end
    end
end

------------------
-- Function Init()
------------------

-- Hooks G and Shift+G. Vanilla binds neither, so both stay free.
function Init()
    -- ONE combo, ONE behavior (user: "I have always pressed the combo"):
    -- many unique orders -> split evenly; a single order -> the whole
    -- selection receives it ("everyone to the one point", e.g. the whole
    -- air force onto a running enemy ACU).
    IN_AddKeyMapTable({['G']       = {action = 'ui_lua import("/mods/M&B/lua/spreadattack.lua").SpreadOrders()'},})
    IN_AddKeyMapTable({['Shift-G'] = {action = 'ui_lua import("/mods/M&B/lua/spreadattack.lua").SpreadOrders()'},})
    -- The build ghost name is captured through the OFFICIAL extension point
    -- (commandmode's start behaviors) instead of wrapping StartCommandMode:
    -- wrapping shared UI globals is exactly the kind of change that breaks
    -- unrelated input, and the wrap is the prime suspect for the cheat menu
    -- digit breakage reported right after it was added.
    import('/lua/ui/game/commandmode.lua').AddStartBehavior(function(mode, data)
        if mode == 'build' and data and type(data.name) == 'string' and data.name ~= '' then
            import('/mods/M&B/lua/spreadattack.lua').RememberBuildModeName(data.name)
        end
    end)
    -- Live attack markers while Shift is held (see MNBAttackOverlayBeat).
    import('/lua/ui/game/gamemain.lua').AddBeatFunction(MNBAttackOverlayBeat)
    -- Version marker: one glance at the log tells which iteration is running.
    LOG('MNB SpreadOrders: key binding installed (G / Shift-G) [v31: unit attacks broadcast to all with rotation, ground attacks divided]')
end

-----------------------------------------
-- Function MakeShadowCopyOrders(command)
-----------------------------------------

function MakeShadowCopyOrders(command)

    local echoKey = tostring(command.CommandType) .. (command.Clear == true and '+clear' or '')
    EchoCounts[echoKey] = (EchoCounts[echoKey] or 0) + 1

    -- Clear bit set: the engine wiped the queue (this also covers Stop).
    -- EXCEPT for type None: log-proven, a None echo with Clear set does NOT
    -- wipe the real queue (16 builds survived it) -- it is engine
    -- bookkeeping, and honoring it desynced the shadow from reality.
    if command.Clear == true and command.CommandType ~= 'None' then
        for _, unit in command.Units do
            ShadowOrders[unit:GetEntityId()] = {}
        end
    end

    local translated = Distributable[command.CommandType]
    local order

    if translated then
        local pos = command.Target.Position
        local b = command.Blueprint
        -- Build placements are issued by the ENGINE (C++), not by Lua, and
        -- the echo arrives with an EMPTY Blueprint (playtest-proven: every
        -- reissued build was the empty string and the engine ignored it).
        -- The id lives in the active build command mode data instead
        -- (buildmode/construction start it as {name = bpId}).
        if translated == 'Build' and (not b or b == '') then
            -- Two sources, tried in order: the still-active build mode, then
            -- the name remembered when the mode started (it may already have
            -- ended by the time this echo arrives).
            local cmdMode = import('/lua/ui/game/commandmode.lua').GetCommandMode()
            local name
            if cmdMode[1] == 'build' and cmdMode[2] and cmdMode[2].name ~= '' then
                name = cmdMode[2].name
            end
            if not name then
                name = BuildModeName
            end
            if type(name) == 'string' and name ~= ''
                and __blueprints[name]
                and (EntityCategoryContains(categories.STRUCTURE, name)
                     or EntityCategoryContains(categories.NEEDMOBILEBUILD, name)) then
                b = name
            elseif not SeenUnknownTypes.BuildBpDebug then
                -- One detailed line per session: whatever killed the
                -- recovery (wrong mode, missing name, unknown bp) shows here.
                SeenUnknownTypes.BuildBpDebug = true
                LOG('MNB SpreadOrders: bp recovery failed: mode=' .. tostring(cmdMode[1]) ..
                    ' modeName=' .. tostring(cmdMode[2] and cmdMode[2].name) ..
                    ' remembered=' .. tostring(BuildModeName) ..
                    ' isBp=' .. tostring(BuildModeName ~= nil and __blueprints[BuildModeName] ~= nil))
            end
        end
        -- Array form {x, y, z}: the engine's Issue* functions accept an
        -- entity, a Vec3 or an array-indexed table, but NOT a keyed table.
        -- ATTACK orders keep the echo's RAW entity id (original-mod
        -- mechanism, playtested for years: sim GetEntityById accepts it and
        -- IssueAttack follows the exact clicked unit -- validation on that
        -- object only produced false fallbacks, v23-v25). Other types try
        -- the UI-side id conversion; when that fails the id is DROPPED,
        -- never passed on raw.
        local e = command.Target.EntityId
        if e and translated ~= 'Attack' then
            local okU, uTgt = pcall(GetUnitById, e)
            local okE, eReal
            if okU and uTgt then
                okE, eReal = pcall(function() return uTgt:GetEntityId() end)
            end
            if okE and type(eReal) == 'number' and eReal > 0 and eReal < 10000000 then
                -- Real sim entity id (a small number). The echo's raw value is
                -- a huge engine handle (~8e8): passing it to the sim resolves
                -- to a garbage table and every attack dies as an area order.
                e = eReal
            else
                -- Unresolved: drop the id entirely. A raw handle must never
                -- travel to the sim (playtest v25: it did, and attacks fell
                -- into the ground). The attack still carries its position,
                -- and the sim re-finds the target there.
                if not SeenUnknownTypes.ConvFail then
                    SeenUnknownTypes.ConvFail = true
                    LOG('MNB SpreadOrders: id conversion failed: raw=' .. tostring(e) ..
                        ' okU=' .. tostring(okU) ..
                        ' uTgt=' .. tostring(uTgt ~= nil) ..
                        ' okE=' .. tostring(okE) ..
                        ' eReal=' .. tostring(eReal))
                end
                e = nil
            end
        end
        order = {
            t = translated,
            p = { pos.x, pos.y, pos.z },
            e = e,
            b = b,
        }
        if translated == 'Attack' and not SeenUnknownTypes.AtkEchoProbe then
            -- Ground truth, once per session: what the attack echo's
            -- Target really holds and whether GetUnitById resolves it.
            SeenUnknownTypes.AtkEchoProbe = true
            local parts = {}
            for k, v in command.Target do
                table.insert(parts, tostring(k) .. '=' .. tostring(v))
            end
            local okU, uT = pcall(GetUnitById, command.Target.EntityId)
            LOG('MNB SpreadOrders: attack echo probe: Target={' ..
                table.concat(parts, ' ') .. '} GetUnitById=' ..
                tostring(okU and uT ~= nil and 'unit' or 'fail'))
        end
        if translated == 'Attack' and order.e then
            table.insert(RecentAttacks, { e = order.e, p = order.p })
            if table.getn(RecentAttacks) > 100 then
                table.remove(RecentAttacks, 1)
            end
        end
    elseif command.CommandType == 'None' then
        -- Typeless engine-internal orders: sim-side issued commands (skuf
        -- auto-reclaim reassigns engineers like this) and rally points.
        -- The engine sends Blueprint as an EMPTY STRING on echoes: '' is
        -- truthy in Lua, so without the ~= '' check every typeless echo
        -- got recorded as a build with no blueprint and poisoned the unit.
        if command.Blueprint and command.Blueprint ~= ''
            and command.Target and command.Target.Position then
            -- A None order carrying a build blueprint is the echo of a
            -- sim-issued build order (our own spread reissue works like
            -- this). Record it so the shadow queue keeps matching reality:
            -- later presses then redistribute old + new tasks together
            -- instead of silently dropping the already assigned builds.
            local pos = command.Target.Position
            order = { t = 'Build', p = { pos.x, pos.y, pos.z }, e = nil, b = command.Blueprint }
        else
            -- Plain typeless order: ignore, it must not exclude the unit.
            return
        end
    else
        -- Unsupported type: remembered so SpreadOrders skips this unit.
        order = { t = 'Other' }
        if not SeenUnknownTypes[command.CommandType] then
            SeenUnknownTypes[command.CommandType] = true
            LOG('MNB SpreadOrders: unhandled order type "' .. tostring(command.CommandType) .. '" (such units are excluded)')
        end
    end

    for _, unit in command.Units do
        local id = unit:GetEntityId()
        if not ShadowOrders[id] then
            ShadowOrders[id] = {}
        end
        table.insert(ShadowOrders[id], order)
        -- Shadows grow forever now (None+clear no longer wipes them) and
        -- the per-press metadata index is linear in shadow size: cap it.
        -- The oldest entries are long-finished structures, worthless as
        -- metadata anyway.
        local shadow = ShadowOrders[id]
        if table.getn(shadow) > 400 then
            for _ = 1, 200 do
                table.remove(shadow, 1)
            end
        end
    end
end

---------------------------
-- Function SpreadOrders()
---------------------------

-- Types as they appear in the REAL queue entries (UI-side GetCommandQueue
-- returns readable tables with .type and .position -- uiprobe-proven).
-- The real queue is the authoritative task list; the shadow copy only
-- supplies metadata (blueprint, entity id) the queue entries lack.
local QueueTypeMap = {
    Move               = 'Move',
    Attack             = 'Attack',
    AggressiveMove     = 'AggressiveMove',
    BuildMobile        = 'Build',
    Build              = 'Build',
    Repair             = 'Repair',
    Reclaim            = 'Reclaim',
    Capture            = 'Capture',
    FormMove           = 'Move',
    FormAttack         = 'Attack',
    FormAggressiveMove = 'AggressiveMove',
    -- Deliberately absent: BuildFactory (factory production), Guard,
    -- Patrol, Ferry, Transport, Upgrade... a queue holding them excludes
    -- the unit, exactly like the shadow 'Other' marker always did.
}

-- Rounded position key: matches a real queue entry to the shadow order
-- recorded for the same spot (metadata lookup).
local function PosKey(p)
    if not p then
        return nil
    end
    return math.floor((p.x or p[1]) + 0.5) .. '_' .. math.floor((p.z or p[3]) + 0.5)
end

-- Pools the REAL command queues of the selection (deduplicated) and hands
-- the unique order list to the sim side. MANY unique orders are dealt
-- evenly across the units; ONE unique order is given to every unit of the
-- selection ("everyone to the one point" -- catching a running ACU). Same
-- rule for every order type: moves, attacks, builds.
function SpreadOrders()

    local selection = GetSelectedUnits()
    if not selection then
        return
    end

    -- Once per session: dump the UI-side view of the REAL command queue of
    -- up to two selected units, plus the echo histogram. The sim-side probe
    -- proved sim queue entries are opaque engine objects (_c_object), but
    -- the UI proxy exposes .type/.position to vanilla code -- if UI entries
    -- also carry the build blueprint, builds can be read straight from the
    -- real queue and the whole echo shadow copy becomes unnecessary.
    if not SeenUnknownTypes.UIProbe then
        SeenUnknownTypes.UIProbe = true
        local dumped = 0
        for _, unit in selection do
            if dumped >= 2 then break end
            local ok, q = pcall(function() return unit:GetCommandQueue() end)
            if ok and q and table.getn(q) > 0 then
                dumped = dumped + 1
                local uid = unit:GetEntityId()
                for j = 1, math.min(3, table.getn(q)) do
                    local okE, errE = pcall(function()
                        local c = q[j]
                        local keys = {}
                        for k in c do
                            table.insert(keys, tostring(k))
                        end
                        table.sort(keys)
                        LOG('MNB SpreadOrders: uiprobe u=' .. uid .. ' #' .. j ..
                            ' type=' .. tostring(c.type) ..
                            ' bp=' .. tostring(c.blueprint) ..
                            ' keys=' .. table.concat(keys, ','))
                    end)
                    if not okE then
                        LOG('MNB SpreadOrders: uiprobe u=' .. uid .. ' #' .. j ..
                            ' unreadable: ' .. tostring(errE))
                    end
                end
            end
        end
        local echoParts = {}
        for t, cnt in EchoCounts do
            table.insert(echoParts, t .. '=' .. cnt)
        end
        table.sort(echoParts)
        LOG('MNB SpreadOrders: echo histogram: ' ..
            (table.getn(echoParts) > 0 and table.concat(echoParts, ' ') or 'nothing recorded'))
    end

    -- Once, on any LATER press than the first spread: dump what the sim
    -- reissued into the queue. Decisive for the Shift-held attack overlay:
    -- reissued Attack entries WITH a position are visible to it, entries
    -- without one only ever cover player-clicked attacks.
    if SeenUnknownTypes.SpreadDone and not SeenUnknownTypes.AfterProbe then
        SeenUnknownTypes.AfterProbe = true
        local dumped = 0
        for _, unit in selection do
            if dumped >= 2 then break end
            local ok, q = pcall(function() return unit:GetCommandQueue() end)
            if ok and q and table.getn(q) > 0 then
                dumped = dumped + 1
                local uid = unit:GetEntityId()
                for j = 1, math.min(2, table.getn(q)) do
                    local c = q[j]
                    local p = c.position
                    LOG('MNB SpreadOrders: afterprobe u=' .. uid .. ' #' .. j ..
                        ' type=' .. tostring(c.type) ..
                        ' pos=' .. tostring(p and (math.floor((p.x or p[1] or 0) + 0.5) ..
                            ',' .. math.floor((p.z or p[3] or 0) + 0.5)) or 'NONE'))
                end
            end
        end
    end

    local unitIds  = {}
    local seen     = {}
    local pool     = {}
    local count    = 0
    local excluded = 0

    for _, unit in selection do
        local id = unit:GetEntityId()
        local shadow = ShadowOrders[id] or {}
        local skip = false

        -- Old exclusion markers still apply (an unsupported order type the
        -- shadow saw, even one the queue has since drained).
        for _, o in shadow do
            if o.t == 'Other' then
                skip = true
            end
        end

        -- Position-keyed metadata index, built in ONE pass per unit.
        -- Scanning the whole shadow per queue entry instead went quadratic
        -- and visibly froze the game on long walls late in a session.
        local byPos = {}
        for _, o in shadow do
            if o.p then
                local k = PosKey(o.p)
                if k and not byPos[k] then
                    byPos[k] = o
                end
            end
        end

        -- The REAL queue is the task list. Reading it fresh at every press
        -- makes the fragile echo bookkeeping harmless: whatever wipes the
        -- shadow no longer changes what gets spread.
        local entries = {}
        local okQ, q = pcall(function() return unit:GetCommandQueue() end)
        if okQ and q then
            for _, c in q do
                local t = QueueTypeMap[tostring(c.type)]
                if not t then
                    skip = true
                    if not SeenUnknownTypes['Queue_' .. tostring(c.type)] then
                        SeenUnknownTypes['Queue_' .. tostring(c.type)] = true
                        LOG('MNB SpreadOrders: real queue holds unsupported type "' ..
                            tostring(c.type) .. '" (such units are excluded)')
                    end
                else
                    local p = c.position
                    local arr = p and { p.x or p[1], p.y or p[2], p.z or p[3] } or nil
                    -- Blueprint and entity ids live ONLY in the shadow:
                    -- look the entry up by its position.
                    local pk = PosKey(p)
                    local meta = pk and byPos[pk] or nil
                    if t == 'Build' then
                        local b = meta and meta.b
                        if (not b or b == '') and type(BuildModeName) == 'string'
                            and BuildModeName ~= '' and __blueprints[BuildModeName]
                            and (EntityCategoryContains(categories.STRUCTURE, BuildModeName)
                                 or EntityCategoryContains(categories.NEEDMOBILEBUILD, BuildModeName)) then
                            b = BuildModeName
                        end
                        if not b or b == '' or not arr then
                            -- A build that can never be reissued: exclude
                            -- the unit instead of dropping the order.
                            skip = true
                            if not SeenUnknownTypes.QueueBuildNoBP then
                                SeenUnknownTypes.QueueBuildNoBP = true
                                LOG('MNB SpreadOrders: real-queue build without a blueprint' ..
                                    ' (unit excluded) pos=' .. tostring(pk))
                            end
                        else
                            table.insert(entries, { t = 'Build', p = arr, e = nil, b = b })
                        end
                    elseif t == 'Attack' then
                        -- Entity if known, else ground attack at the position.
                        -- A moved target breaks the byPos metadata match, so
                        -- a missed lookup falls back to the nearest recent
                        -- attack target: attacks must track the UNIT, not a
                        -- stale point.
                        local e = meta and meta.e
                        if not e and arr then
                            -- An attack order FOLLOWS its target (user: the
                            -- order moves with it), so the queue position
                            -- is the target's LIVE position and may be far
                            -- from the click-time record: match generously.
                            local bestD2 = 900 -- 30 map units
                            for _, ra in RecentAttacks do
                                local dx = ra.p[1] - arr[1]
                                local dz = ra.p[3] - arr[3]
                                local d2 = dx * dx + dz * dz
                                if d2 < bestD2 then
                                    bestD2 = d2
                                    e = ra.e
                                end
                            end
                        end
                        if arr or e then
                            table.insert(entries, { t = 'Attack', p = arr, e = e, b = nil })
                        end
                    elseif t == 'Repair' or t == 'Reclaim' or t == 'Capture' then
                        -- Cannot be reissued without the target entity: keep
                        -- only those the shadow can still resolve.
                        if meta and meta.e then
                            table.insert(entries, { t = t, p = arr, e = meta.e, b = nil })
                        end
                    elseif arr then
                        -- Move / AggressiveMove.
                        table.insert(entries, { t = t, p = arr, e = nil, b = nil })
                    end
                end
            end
        end

        if skip then
            excluded = excluded + 1
        else
            table.insert(unitIds, id)
            for _, o in entries do
                local key
                if o.e then
                    key = o.t .. '#' .. o.e .. '#' .. (o.b or '')
                else
                    key = o.t .. '#' .. (o.b or '') .. '#' ..
                          math.floor(o.p[1] + 0.5) .. '_' .. math.floor(o.p[3] + 0.5)
                end
                if not seen[key] then
                    seen[key] = true
                    count = count + 1
                    if count <= MaxOrdersPerPress then
                        table.insert(pool, { t = o.t, p = o.p, e = o.e, b = o.b, s = count })
                    end
                end
            end
        end
    end

    -- Debug line covering every exit path: shows how many units were seen,
    -- how many are spreadable, how many unique orders were pooled and how
    -- many units were skipped (unsupported orders in their queue).
    -- The pool histogram tells what the selection actually held, so a
    -- unique=1 press explains itself in the log.
    local histo = {}
    for _, o in pool do
        histo[o.t] = (histo[o.t] or 0) + 1
    end
    local parts = {}
    for t, c in histo do
        table.insert(parts, t .. '=' .. c)
    end
    table.sort(parts)
    -- bp of the first pooled order: cross-check against the sim-side sample
    -- line (if UI shows it but sim gets nil, serialization dropped it).
    -- atkE: how many pooled attack orders carry a live target unit (the
    -- rest degrade to an aggressive move at a stale point).
    local bp0 = pool[1] and tostring(pool[1].b) or '-'
    local atkE = 0
    for _, o in pool do
        if o.t == 'Attack' and o.e then
            atkE = atkE + 1
        end
    end
    LOG('MNB SpreadOrders: selected=' .. table.getn(selection) ..
        ' spreadable=' .. table.getn(unitIds) ..
        ' unique=' .. count ..
        ' skipped=' .. excluded ..
        ' pool=[' .. table.concat(parts, ' ') .. ']' ..
        ' bp0=' .. bp0 ..
        ' atkE=' .. atkE)

    -- Needs at least two units. An EMPTY pool still goes to the sim once
    -- per session: the sim then dumps the real command queue entries of
    -- two units (the ground truth about what fields are readable
    -- sim-side). A single unique order is valid and goes through: the
    -- sim's doubling pass hands it to every unit.
    if table.getn(unitIds) < 2 then
        return
    end
    if count == 0 then
        if SeenUnknownTypes.QueueProbe then
            return
        end
        SeenUnknownTypes.QueueProbe = true
    end
    if count > MaxOrdersPerPress then
        LOG('MNB SpreadOrders: pool capped at ' .. MaxOrdersPerPress .. ' of ' .. count .. ' unique orders')
    end

    -- The engine does NOT add the army to the callback data automatically:
    -- it has to be passed explicitly (same as skuf does), because sim-side
    -- code must never use GetFocusArmy().
    SimCallback({ Func = 'MNB_SpreadOrders',
                  Args = { units  = unitIds,
                           orders = pool,
                           army   = GetFocusArmy() } }, false)

    -- Marks that this client has spread at least once, so the after-probe
    -- (below) only fires on a LATER press and dumps the reissued entries.
    SeenUnknownTypes.SpreadDone = true
end
