-- M&B: research label plate above labs, identical on every machine.
--
-- History: the sim-side SetCustomName never leaves the host in multiplayer,
-- and the byte-packed name transfer through unit stats turned out dead even
-- on a single machine (huge doubles do not survive the stat pipeline; small
-- integers do). The working channels are exactly three small numbers:
-- MNBPct (paid percent, -1 = idle), MNBQueue (waiting orders), MNBRsch
-- (index into the sorted sr9 research list). Every machine can resolve the
-- research NAME from that index on its own side - the UI sees the full
-- blueprint set with full LOC support (the build menu does the same).
--
-- So the label is now a proper UI element of our own: a semi-transparent
-- plate anchored under the lab's health bar, built the way the engine builds
-- its floating damage text (unittext.lua): a control parented to the world
-- view, re-projected every frame with view:Project(worldPos), and hidden
-- when the camera zooms out (user: it must vanish with distance or it gets
-- in the way). The engine's own floating text uses the same zoom cutoff.
--
-- Lab discovery, three merged sources:
--   * the engine idle-factory list (the lab's engine queue is empty by
--     design, so a lab counts as idle - GetIdleFactories);
--   * labs the player has ever selected (the war pool panel selection);
--   * OTHER armies' labs from the shared Sync board (Sync.MNBLabs, posted
--     sim-side by every lab brain): unit stats never leave the focus army,
--     the Sync table does. Allies get their plate unconditionally; an enemy
--     lab only for armies that scouted it (blip check, done sim-side).
-- An OWN lab is recognized by carrying the MNBDividend stat.
--
-- A throttled heartbeat line goes to the log (counts + raw stat reads of
-- the first candidate + error counter) so field issues are visible without
-- a debugger.

local UIUtil = import('/lua/ui/uiutil.lua')
local Bitmap = import('/lua/maui/bitmap.lua').Bitmap
local WorldViewMod = import('/lua/ui/game/worldview.lua')

local MNB_LABEL_PERIOD = 1    -- seconds between label refreshes
local MNB_DEBUG_PERIOD = 15   -- seconds between heartbeat log lines
local MNB_PLATE_MAXZOOM = 130 -- hide plates when the camera is farther out
local MNB_PLATE_OFF_Y = 30    -- pixels below the lab's screen point
local MNB_PLATE_FONT = 13

local running = false

-- entity id -> true, labs ever seen (selection or idle sweep)
local known = {}

-- entity id -> plate record: { views = { {plate, text, st, view} }, text }
local plates = {}

local nextDebug = 0

local function Stat(unit, key, default)
    --UserUnit:GetStat hands back a TABLE with a .Value field (the war pool
    --panel reads tMNBWarP.Value) - unwrap it, or every check misfires
    local ok, val = pcall(function() return unit:GetStat(key, default) end)
    if ok then
        if type(val) == 'table' then
            val = val.Value
        end
        return val
    end
    return default
end

local function StatNum(unit, key, default)
    local val = Stat(unit, key, default)
    if type(val) == 'string' then
        val = tonumber(val)
    end
    if type(val) ~= 'number' then
        return default
    end
    return val
end

-- labs discovered by CLICKING them (where the war pool panel lives)
function NoteSelection(units)
    if not units then
        return
    end
    for _, unit in units do
        if unit then
            local pool = Stat(unit, 'MNBDividend', nil)
            if pool ~= nil then
                local id = unit:GetEntityId()
                if not known[id] then
                    known[id] = true
                    LOG('M&B lablabels: selection registered lab ' .. tostring(id))
                end
            end
        end
    end
end

-- Same enumeration as the sim side (MNBLabResearchIndex in defaultunits.lua):
-- all sr9 research ids, sorted. Both sides see the same blueprints, so the
-- index stat is enough to recover the research name locally.
local function BuildResearchNames()
    local order = {}
    for id, bp in __blueprints do
        if bp and string.find(id, '^s.r9') then
            table.insert(order, id)
        end
    end
    table.sort(order)
    local names = {}
    for i, id in order do
        local bp = __blueprints[id]
        local raw = ''
        --research bps are GENERATED (Blueprints.lua): unit-unlock researches
        --copy the unit's name into General.UnitName, but tier/MK researches
        --only carry their title in Interface.HelpText (HelpText = the source
        --entry's Description) - without that fallback every plate showed a
        --bare percent number with no name
        if bp then
            raw = (bp.General and bp.General.UnitName)
                or (bp.Interface and bp.Interface.HelpText)
                or (bp.General and bp.General.Description)
                or bp.Description
                or ''
        end
        -- UI context has full LOC support; on failure or a missing database
        -- the tag is stripped -> English text
        local clean = tostring(raw)
        local okLoc, loc = pcall(function() return LOC(clean) end)
        if okLoc and loc and loc ~= '' and loc ~= clean then
            clean = tostring(loc)
        end
        clean = string.gsub(clean, '^<LOC[^>]*>', '')
        names[i] = clean
    end
    return names
end

-- Label text from the three small numbers (index, percent, queue). Shared by
-- the own-lab sweep (reads them from unit stats) and the shared-board sweep
-- (reads them from Sync), so every plate looks identical no matter whose lab.
local function ComposeText(idx, pct, q, namesBox)
    local text = ''
    if pct >= 0 then
        -- the research name comes from the index, resolved LOCALLY (the UI
        -- has the blueprints and full LOC; nothing textual has to travel)
        if idx > 0 then
            --table writes inside a pcall'd call DO propagate (unlike writes
            --to outer locals), so the lazy name cache rides in a box table
            if not namesBox[1] then
                namesBox[1] = BuildResearchNames()
            end
            if namesBox[1][idx] and namesBox[1][idx] ~= '' then
                text = namesBox[1][idx]
            end
        end
        text = text .. ' ' .. pct .. '%'
        if q > 0 then
            text = text .. ' +' .. q
        end
    end
    return text
end

local function Describe(unit)
    -- raw reads for the log: types and values exactly as the C++ hands them
    local cat = '?'
    local okCat, res = pcall(function() return unit:IsInCategory('RESEARCHCENTRE') end)
    if okCat then
        cat = tostring(res)
    end
    return 'id=' .. tostring(unit:GetEntityId())
        .. ' research=' .. cat
        .. ' div=' .. tostring(Stat(unit, 'MNBDividend', '@nil'))
        .. ' pct=' .. tostring(Stat(unit, 'MNBPct', '@nil'))
        .. ' rsch=' .. tostring(Stat(unit, 'MNBRsch', '@nil'))
end

local function DestroyPlate(id)
    local rec = plates[id]
    if not rec then
        return
    end
    plates[id] = nil
    for _, e in rec.views do
        pcall(function() e.plate:Destroy() end)
    end
end

-- The plate itself: one per world view, parented to that view. Position is
-- re-projected every frame (the camera never stops moving), exactly like
-- the engine's floating damage text. st is the shared per-view state table
-- (table writes survive across pcall boundaries, unlike outer-local writes).
local function CreatePlate(id, pos)
    local rec = { views = {}, text = '' }
    --the MAIN world view only (WorldViewMod.viewLeft, set by the engine's
    --SetViewLayout): iterating GetWorldViews() handed back entries without
    --Project/_cameraName in this build, and the plate died on them
    local view = WorldViewMod.viewLeft
    if not view or not view.Project then
        return nil
    end
    do
        --two anchor modes: OWN labs resolve their unit by id every frame
        --(pos == nil -> byId); BOARD labs (other armies) anchor to the world
        --position carried in the board entry - the UI has no unit proxy for
        --foreign units (GetUnitById returned nil for every foreign lab)
        local st = { want = false, byId = (pos == nil), pos = pos }
        local okE, plate, text = pcall(function()
            local plate = Bitmap(view)
            plate:SetSolidColor('AA000000')
            plate:DisableHitTest()
            local text = UIUtil.CreateText(plate, ' ', MNB_PLATE_FONT, UIUtil.bodyFont)
            text:SetColor('FFFFFFFF')
            text:DisableHitTest()
            -- plate size follows the text; MAUI layout is pull-based, so the
            -- plate re-measures itself whenever the label text changes
            plate.Width:Set(function() return text.Width() + 10 end)
            plate.Height:Set(function() return text.Height() + 4 end)
            text.Left:Set(function() return plate.Left() + 5 end)
            text.Top:Set(function() return plate.Top() + 2 end)
            -- anchor: installed fresh EVERY frame in OnFrame (engine pattern,
            -- see below)
            plate:SetNeedsFrameUpdate(true)
            plate.OnFrame = function(self)
                local okF, errF = pcall(function()
                    --anchor: own labs by unit id (dies -> plate destroyed),
                    --board labs by the static world position from the entry
                    local pos = nil
                    if st.byId then
                        local u = GetUnitById(id)
                        if not u then
                            DestroyPlate(id)
                            return
                        end
                        local okP, p = pcall(function() return u:GetPosition() end)
                        if okP and p then
                            pos = p
                        end
                    else
                        pos = st.pos
                    end
                    if not pos then
                        return
                    end
                    -- no label text (idle lab) or camera far out: hidden
                    if not st.want then
                        self:Hide()
                        return
                    end
                    --not every view carries a _cameraName in this engine
                    --build; the main camera is the only zoom the label needs
                    --(engine UI code queries it by the literal name below)
                    local camName = view._cameraName
                    if type(camName) ~= 'string' then
                        camName = 'WorldCamera'
                    end
                    local okC, zoom = pcall(function() return GetCamera(camName):GetTargetZoom() end)
                    if okC and zoom and zoom > MNB_PLATE_MAXZOOM then
                        self:Hide()
                        return
                    end
                    -- engine pattern (unittext.lua, floating damage text):
                    -- re-install the anchor closures EVERY frame with fresh
                    -- coords. A closure set once at creation never re-evaluates
                    -- on its own (only a Set call dirties the parameter), so
                    -- the plate used to move only when its text changed and
                    -- drifted all over the screen instead of sticking to the lab
                    local coords = view:Project(pos)
                    self.Left:Set(function() return coords[1] - self.Width() / 2 end)
                    self.Top:Set(function() return coords[2] + MNB_PLATE_OFF_Y end)
                    self:Show()
                end)
                if not okF then
                    LOG('M&B lablabels: plate frame error: ' .. tostring(errF))
                end
            end
            plate:Hide()
            return plate, text
        end)
        if okE and plate then
            table.insert(rec.views, { plate = plate, text = text, st = st, view = view })
        end
    end
    if table.getn(rec.views) == 0 then
        return nil
    end
    plates[id] = rec
    return rec
end

local function SetPlateText(id, text, pos)
    local rec = plates[id]
    if not rec then
        if text == '' then
            return
        end
        rec = CreatePlate(id, pos)
        if not rec then
            return
        end
    end
    if rec.text == text then
        return
    end
    rec.text = text
    for _, e in rec.views do
        e.st.want = (text ~= '')
        if text ~= '' then
            pcall(function() e.text:SetText(text) end)
        end
    end
end

-- One unit of the sweep. Returns (sampleForLog, isLab). Kept a separate
-- function on purpose: the caller wraps it in pcall, so ONE broken unit can
-- never kill the whole tick (a recorded failure mode of the old build).
local function HandleUnit(unit, namesBox)
    -- lab discriminator: the war-pool stat, proven to read on this side
    local pool = Stat(unit, 'MNBDividend', nil)
    if pool == nil then
        return '(not a lab) ' .. Describe(unit), false
    end
    local id = unit:GetEntityId()
    known[id] = true
    local text = ComposeText(StatNum(unit, 'MNBRsch', 0),
                             StatNum(unit, 'MNBPct', -1),
                             StatNum(unit, 'MNBQueue', 0),
                             namesBox)
    SetPlateText(id, text)
    return Describe(unit), true
end

local function LabelTick()
    local dbgIdle = -1
    local dbgLabs = 0
    local dbgBoard = -1
    local dbgBoardSeen = 0
    local dbgBoardWhy = {}
    local dbgSample = ''
    local dbgErrors = 0
    local dbgLastErr = ''

    local units = {}
    local seen = {}
    local namesBox = {}

    -- source 1: the engine idle-factory sweep
    local okFact, factories = pcall(function() return GetIdleFactories() end)
    if okFact and factories then
        dbgIdle = table.getn(factories)
        for _, unit in factories do
            if unit then
                seen[unit:GetEntityId()] = true
                table.insert(units, unit)
            end
        end
    end

    -- source 2: labs remembered from selection (dead ids pruned here);
    -- skip ids the idle sweep already delivered
    for id in pairs(known) do
        local unit = GetUnitById(id)
        if unit then
            if not seen[id] then
                seen[id] = true
                table.insert(units, unit)
            end
        else
            known[id] = nil
        end
    end

    for _, unit in units do
        -- results come back through RETURNS, never through outer-local
        -- writes (Lua 5.0 silently creates an inner local inside a pcall'd
        -- closure -- a recorded trap of this engine)
        local okU, resU, isLab = pcall(HandleUnit, unit, namesBox)
        if okU then
            if isLab then
                dbgLabs = dbgLabs + 1
            end
            if dbgSample == '' and resU and resU ~= '' then
                dbgSample = resU
            end
        else
            dbgErrors = dbgErrors + 1
            dbgLastErr = tostring(resU)
        end
    end

    -- source 3: the shared Sync board - EVERY lab posts to Sync.MNBLabs sim-side
    -- (MNBLabelFeedThread). Own labs ride it too now: a PRODUCING lab never shows
    -- up in the engine's idle-factory list (source 1 only delivers idle labs), so
    -- the board is what keeps the own plate alive while research runs. Allies get
    -- their plate unconditionally; an enemy lab only while OUR army holds live
    -- sight on it (the sim stamps which armies see it right now).
    -- Every skip counts itself with a reason tag - the heartbeat then NAMES
    -- the gate that ate the plates instead of leaving us guessing.
    local okB, board = pcall(function() return Sync.MNBLabs end)
    if okB and type(board) == 'table' then
        dbgBoard = 0
        local focus = GetFocusArmy()
        local boardSeenT = {}
        for id, e in board do
            boardSeenT[id] = true
            dbgBoardSeen = dbgBoardSeen + 1
            local okE, shown, why = pcall(function()
                if type(e) ~= 'table' then
                    return false, 'notable'
                end
                --anchor position rides in the entry itself: the UI holds no
                --unit proxy for foreign armies' units (nounit was the failure)
                if type(e.x) ~= 'number' or type(e.z) ~= 'number' then
                    return false, 'nopos'
                end
                local pos = { e.x, e.y or 0, e.z }
                local bShow = true
                if e.a ~= focus and not IsAlly(focus, e.a) then
                    --enemy lab: v is keyed army index + 1 (sim side)
                    bShow = (type(e.v) == 'table') and (e.v[focus + 1] == true)
                end
                if bShow then
                    SetPlateText(id, ComposeText(e.r or 0, e.p or -1, e.q or 0, namesBox), pos)
                    if e.a == focus then
                        return true, 'own'
                    end
                    return true, 'shown'
                end
                SetPlateText(id, '')
                return false, 'noscout'
            end)
            if okE then
                if shown then
                    dbgBoard = dbgBoard + 1
                end
                if why then
                    dbgBoardWhy[why] = (dbgBoardWhy[why] or 0) + 1
                end
            else
                dbgErrors = dbgErrors + 1
                dbgLastErr = 'board: ' .. tostring(shown)
            end
        end
        --a foreign lab whose entry vanished (lab dead) must not keep a plate
        --floating forever: its anchor never resolves a unit, so nobody else
        --retires it. Only runs on ticks where the board actually arrived,
        --so the Sync drain window can never blink visible plates
        for pid, rec in plates do
            if rec.views[1] and not rec.views[1].st.byId and not boardSeenT[pid] then
                SetPlateText(pid, '')
            end
        end
    end

    -- throttled heartbeat so problems are visible in the game log; a failed
    -- unit COUNTS itself here instead of silencing the heartbeat
    local now = GetGameTimeSeconds()
    if now >= nextDebug then
        nextDebug = now + MNB_DEBUG_PERIOD
        local errPart = ''
        if dbgErrors > 0 then
            errPart = ' ERRORS=' .. dbgErrors .. ' last=' .. dbgLastErr
        end
        local whyPart = ''
        for k, v in dbgBoardWhy do
            whyPart = whyPart .. ' ' .. k .. '=' .. v
        end
        LOG('M&B lablabels: idle=' .. dbgIdle .. ' labs=' .. dbgLabs
            .. ' board=' .. dbgBoard .. '/' .. dbgBoardSeen
            .. whyPart
            .. errPart .. ' ' .. dbgSample)
    end
end

function Install()
    if running then
        return
    end
    running = true
    ForkThread(function()
        while true do
            WaitSeconds(MNB_LABEL_PERIOD)
            pcall(LabelTick)
        end
    end)
end
