-- === M&B order spreading (G / Shift+G): sim side ===
-- The UI sends the deduplicated order pool of the selection; this deals it
-- round-robin among the (alive, same-army) units and re-issues everything.
-- One SimCallback per keypress, no threads, no per-tick work.
do
	local MNBQueueDumped

	-- Who received builds at the last spread (entity ids only). The light
	-- assist watcher turns freed engineers into helpers of the busiest one
	-- (user design, 2026-08-16: "just append a support order for the
	-- neighboring engineer -- if he builds they help, if he is done too,
	-- everything is fine").
	local MNBDealtIds = {}
	local MNBHelpStarted

	-- Queue length (acceptance oracle: Issue* calls are synchronous, so a
	-- command the engine refuses simply never appears in the queue).
	-- Blueprint parsing was tried first and failed hard: M&B engineers
	-- carry 'BuildableCategory' (SINGULAR) with expression strings like
	-- 'BUILTBYTIER1ENGINEER AEON', so a plural-field reader concluded
	-- nobody could build anything and wiped every queue ('dealt 0').
	local function QueueLen(unit)
		local ok, q = pcall(function() return unit:GetCommandQueue() end)
		if ok and q then
			return table.getn(q)
		end
		return -1
	end

	local function ReissueOrder(unit, order, slot, slots)
		if order.t == 'Attack' then
			-- Path 1: the RAW echo id, straight through (original-mod
			-- mechanism, user directive 2026-08-16). GetEntityById accepts
			-- it and IssueAttack follows the exact clicked unit. NO
			-- validation on the returned object: it can be a bare entity
			-- table without lua methods, and asking it anything (v23-v25
			-- called IsDead) only produced false fallbacks into ground
			-- orders. The engine takes the target or drops the order
			-- silently -- proven behavior.
			if order.e then
				local victim = GetEntityById(order.e)
				if victim then
					IssueAttack({ unit }, victim)
					if not ReissueOrder.aLogged then
						ReissueOrder.aLogged = true
						LOG('MNB_SpreadOrders: sample attack unit=' .. unit:GetEntityId() ..
							' e=' .. tostring(order.e) .. ' (raw-handle order)')
					end
					return
				end
			end
			-- Path 2: an attack order FOLLOWS its target (user: "the order
			-- moves with it"), so the stored position IS the target's live
			-- position at press time. Re-find the nearest living enemy there
			-- and attack the UNIT -- never the ground.
			if order.p then
				local okR, victim = pcall(function()
					local brain = GetArmyBrain(unit:GetArmy())
					local cands = brain:GetUnitsAroundPoint(categories.ALLUNITS,
						order.p, 10, 'Enemy')
					local best, bestD2 = nil, 121 -- within 11 of the point
					for _, c in cands do
						if not c:IsDead() then
							local cp = c:GetPosition()
							local dx = cp[1] - order.p[1]
							local dz = cp[3] - order.p[3]
							local d2 = dx * dx + dz * dz
							if d2 < bestD2 then
								best, bestD2 = c, d2
							end
						end
					end
					return best
				end)
				if okR and victim then
					IssueAttack({ unit }, victim)
					if not ReissueOrder.pLogged then
						ReissueOrder.pLogged = true
						LOG('MNB_SpreadOrders: sample attack unit=' .. unit:GetEntityId() ..
							' target=' .. victim:GetEntityId() .. ' (pos-resolved)')
					end
					return
				end
				-- Nothing alive near the point: a true ground attack.
				IssueAggressiveMove({ unit }, order.p)
			end
		elseif order.t == 'Move' then
			IssueMove({ unit }, order.p)
		elseif order.t == 'AggressiveMove' then
			IssueAggressiveMove({ unit }, order.p)
		elseif order.t == 'Build' then
			-- Approach a point the engineer can BUILD FROM, never the site
			-- itself: standing on the footprint makes the engine silently
			-- drop the order (the v14 freeze). When he already reaches the
			-- site, no move at all -- he builds from where he stands (user
			-- design, 2026-08-16).
			local up = unit:GetPosition()
			local econ = unit:GetBlueprint().Economy
			local reach = econ.BuildRadius or econ.MaxBuildDistance or 6
			local stop = reach * 0.8
			-- Closer than the footprint half-size = standing on it.
			local skirt = 3
			local tBp = __blueprints[order.b]
			if tBp and tBp.Physics then
				local sx = (tBp.Physics.SkirtSizeX or 4) / 2
				local sz = (tBp.Physics.SkirtSizeZ or 4) / 2
				if sx > sz then
					skirt = sx + 1
				else
					skirt = sz + 1
				end
			end
			if slot and slots and slots > 1 then
				-- SHARED site (broadcast or doubling gave one site to
				-- several engineers): each takes a FIXED place on the ring
				-- around the footprint, so twenty of them spread around the
				-- structure instead of clumping every approach line onto
				-- the same bearing (playtest v23: "they stack waypoints
				-- next to the pgen in a heap").
				local a = (slot - 1) / slots * 2 * math.pi
				IssueMove({ unit }, { order.p[1] + math.cos(a) * stop,
					order.p[2], order.p[3] + math.sin(a) * stop })
			elseif up then
				local dx = up[1] - order.p[1]
				local dz = up[3] - order.p[3]
				local d = math.sqrt(dx * dx + dz * dz)
				if d < skirt or d >= stop then
					-- Land 'stop' short of the site, on his own side.
					local fx, fz
					if d > 0.3 then
						local k = stop / d
						fx = order.p[1] + dx * k
						fz = order.p[3] + dz * k
					else
						fx = order.p[1] + stop
						fz = order.p[3]
					end
					IssueMove({ unit }, { fx, order.p[2], fz })
				end
			else
				IssueMove({ unit }, order.p)
			end
			-- Acceptance oracle: measure AFTER the move (if the engine
			-- ignores a move to where the unit already stands, the baseline
			-- is still correct), then the build must grow the queue by 1.
			local len0 = QueueLen(unit)
			local ok, res = pcall(IssueBuildMobile, { unit }, order.p, order.b, {})
			if not ok then
				LOG('MNB_SpreadOrders: IssueBuildMobile error: ' .. tostring(res))
				return false
			end
			if QueueLen(unit) <= len0 then
				return false
			end
			-- One detailed sample per session: what exactly we asked for.
			if not ReissueOrder.bLogged then
				ReissueOrder.bLogged = true
				LOG('MNB_SpreadOrders: sample build unit=' .. unit:GetEntityId() ..
					' bp=' .. tostring(order.b) ..
					' pos=' .. tostring(order.p[1]) .. ',' .. tostring(order.p[3]))
			end
			return true
		elseif order.t == 'Repair' then
			local target = order.e and GetEntityById(order.e)
			if target and target.IsDead and not target:IsDead() then
				IssueRepair({ unit }, target)
			end
		elseif order.t == 'Reclaim' then
			local target = order.e and GetEntityById(order.e)
			if target then
				IssueReclaim({ unit }, target)
			end
		elseif order.t == 'Capture' then
			local target = order.e and GetEntityById(order.e)
			if target and target.IsDead and not target:IsDead() then
				IssueCapture({ unit }, target)
			end
		end
	end

	-- Light 5s watcher (user design, 2026-08-16): every engineer that got
	-- builds from a spread and has FINISHED his queue gets ONE area-assist
	-- order -- a patrol under his own feet ("finished -> patrol under
	-- himself"). A patrolling engineer auto-assists every construction and
	-- repair within arm's reach all by himself; the engine picks the
	-- targets, we enumerate nothing. The route is TWO points 10m apart: a
	-- single patrol point at/next to where the unit already stands was
	-- silently dropped by the engine (playtest v18). When the WHOLE job is
	-- over -- nobody of the group is building/repairing/reclaiming and
	-- nobody holds own queue orders, everyone just paces -- the patrol
	-- orders are taken back off so the engineers stand still instead of
	-- dashing around (user, 2026-08-16). Two idle ticks (10s) of
	-- hysteresis so a patrol is never cut off right before the engine
	-- latches the helper onto nearby work.
	local MNBIdleTicks = 0
	local function MNBHelpThread()
		while true do
			WaitSeconds(5)
			local ok, err = pcall(function()
				if not next(MNBDealtIds) then
					return
				end
				local anyBusy = false
				local pacers = {}
				for _, eid in MNBDealtIds do
					local u = GetEntityById(eid)
					if u and not u.Dead then
						local len = QueueLen(u)
						if len == 0 then
							-- Finished -> patrol under self. Acceptance
							-- oracle (same as for builds): the patrol must
							-- appear in the queue, else say so loudly.
							local p = u:GetPosition()
							if p then
								IssuePatrol({ u }, { p[1] - 5, p[2], p[3] })
								IssuePatrol({ u }, { p[1] + 5, p[2], p[3] })
								if QueueLen(u) > 0 then
									LOG('MNB_SpreadOrders: assist eng=' .. eid ..
										' patrol at ' .. math.floor(p[1]) .. ',' .. math.floor(p[3]))
								else
									LOG('MNB_SpreadOrders: patrol REFUSED eng=' .. eid ..
										' at ' .. math.floor(p[1]) .. ',' .. math.floor(p[3]))
								end
							end
							-- fresh orders: give the engine time to latch
							-- onto nearby work before counting him idle
							anyBusy = true
						elseif u:IsUnitState('Building') or u:IsUnitState('Repairing')
							or u:IsUnitState('Reclaiming') then
							anyBusy = true
						elseif not u:IsUnitState('Patrolling') then
							-- non-patrol orders still in the queue (the
							-- player's own): busy
							anyBusy = true
						else
							-- patrolling with nothing to do: a pacer
							table.insert(pacers, u)
						end
					end
				end
				if anyBusy then
					MNBIdleTicks = 0
				else
					MNBIdleTicks = MNBIdleTicks + 1
					if MNBIdleTicks >= 2 and table.getn(pacers) > 0 then
						for _, u in pacers do
							IssueClearCommands({ u })
						end
						LOG('MNB_SpreadOrders: assist done, released ' ..
							table.getn(pacers) .. ' eng (patrol removed)')
						MNBDealtIds = {}
						MNBIdleTicks = 0
					end
				end
			end)
			if not ok then
				LOG('MNB_SpreadOrders: assist watcher error: ' .. tostring(err))
			end
		end
	end

	Callbacks.MNB_SpreadOrders = function(data)
		-- First-line marker: proves the callback reached the sim at all.
		LOG('MNB_SpreadOrders: sim entered, units=' .. (data.units and table.getn(data.units) or 'nil') ..
			' orders=' .. (data.orders and table.getn(data.orders) or 'nil') ..
			' army=' .. tostring(data.army))

		if not data.units or not data.orders then
			return
		end

		local units = {}
		for _, id in data.units do
			local u = GetEntityById(id)
			if u and not u:IsDead() and u:GetArmy() == data.army then
				table.insert(units, u)
			end
		end
		local n = table.getn(units)
		if n < 2 then
			return
		end

		-- Empty order pool = the diagnostic probe from the UI: dump what the
		-- sim can really see in a unit's command queue (once per session).
		-- If entries expose blueprint+position, builds can later be taken
		-- straight from the queue instead of the unreliable UI echoes.
		if table.getn(data.orders) == 0 then
			if not MNBQueueDumped then
				MNBQueueDumped = true
				for i = 1, math.min(2, n) do
					local uid = units[i]:GetEntityId()
					local ok, q = pcall(function() return units[i]:GetCommandQueue() end)
					if not ok or not q then
						LOG('MNB_SpreadOrders: queueprobe u=' .. uid .. ' failed: ' .. tostring(q))
					elseif table.getn(q) == 0 then
						LOG('MNB_SpreadOrders: queueprobe u=' .. uid .. ' queue EMPTY')
					else
						-- Entries may be tables OR engine userdata: one bad entry
						-- must not kill the whole probe, so each dump is shielded.
						for j, c in q do
							local okD, errD = pcall(function()
								local keys = {}
								for k in c do
									table.insert(keys, tostring(k))
								end
								table.sort(keys)
								LOG('MNB_SpreadOrders: queueprobe u=' .. uid .. ' #' .. j ..
									' type=' .. tostring(c.type) ..
									' bp=' .. tostring(c.blueprint) ..
									' keys=' .. table.concat(keys, ','))
							end)
							if not okD then
								LOG('MNB_SpreadOrders: queueprobe u=' .. uid .. ' #' .. j ..
									' entry not a table: ' .. tostring(errD))
							end
						end
					end
				end
			end
			return
		end

		-- Drop entity-target orders whose target is no longer resolvable
		-- (Attack keeps going: it falls back to its stored position).
		local valid = {}
		local unitAtks = {} -- unit-click attacks: broadcast, not divided
		for _, order in data.orders do
			if order.e and order.t ~= 'Attack' then
				local tgt = GetEntityById(order.e)
				if tgt then
					table.insert(valid, order)
				end
			else
				if order.t == 'Attack' and order.e then
					order.uatk = true
					table.insert(unitAtks, order)
				end
				table.insert(valid, order)
			end
		end

		-- Bind every pooled GROUND-POINT attack (no target id) to a concrete
		-- enemy unit, ONCE per press and with UNIQUENESS: each click's point
		-- claims the nearest LIVING enemy that no other click has claimed
		-- yet. Without the uniqueness rule several nearby click points
		-- (targets clicked while still clustered) all snapped to the same
		-- nearest tank -- the whole selection became one pack instead of
		-- splitting (playtest v26: "went killing them one by one"). Unit
		-- clicks skip this: they carry their exact target id already.
		local claimed = {}
		local resLog = {}
		for _, order in valid do
			if order.t == 'Attack' and order.p and not order.e then
				local okR, victim = pcall(function()
					local brain = GetArmyBrain(data.army)
					local cands = brain:GetUnitsAroundPoint(categories.ALLUNITS,
						order.p, 20, 'Enemy')
					local best, bestD2 = nil, 441 -- within 21 of the point
					for _, c in cands do
						if not c:IsDead() then
							local cid = c:GetEntityId()
							if not claimed[cid] then
								local cp = c:GetPosition()
								local dx = cp[1] - order.p[1]
								local dz = cp[3] - order.p[3]
								local d2 = dx * dx + dz * dz
								if d2 < bestD2 then
									best, bestD2 = c, d2
								end
							end
						end
					end
					return best
				end)
				if okR and victim then
					claimed[victim:GetEntityId()] = true
					order.e = victim:GetEntityId()
				end
				table.insert(resLog, tostring(order.e or 'ground'))
			end
		end
		if table.getn(resLog) > 0 then
			LOG('MNB_SpreadOrders: attack res: ' .. table.concat(resLog, ','))
		end

		-- A single pooled order is fine: the doubling pass below hands it
		-- to EVERY unit -- "everyone to the one point" (catching a running
		-- ACU; user, 2026-08-16).
		if table.getn(valid) == 0 then
			return
		end

		local assigned = {}
		local cursor = 0
		local dealt = 0
		-- Builds are dealt in CONTIGUOUS chunks (pool order = placement
		-- order, so a wall drag gives each engineer his own stretch):
		-- round-robin scattered every 25th segment along the whole line,
		-- engineers spent the game crossing it and blocking each other's
		-- thin build sites -> holes. Other types keep the spread.
		local buildTotal = 0
		for _, order in valid do
			if order.t == 'Build' then
				buildTotal = buildTotal + 1
			end
		end
		local buildCap = math.ceil(buildTotal / n)
		local buildIdx = 0
		for _, order in valid do
			if not order.uatk then
				local idx
				if order.t == 'Build' and buildCap > 0 then
					buildIdx = buildIdx + 1
					idx = math.min(n, math.floor((buildIdx - 1) / buildCap) + 1)
				else
					idx = math.mod(cursor, n) + 1
				end
				if not assigned[idx] then
					assigned[idx] = {}
				end
				table.insert(assigned[idx], order)
				cursor = idx
				dealt = dealt + 1
			end
		end

		-- Unit-click attacks are BROADCAST, not divided (user, 2026-08-16:
		-- "after a kill the next enemy is known immediately -- with full
		-- division the killer is left without a target"). Every unit
		-- receives ALL clicked targets; each unit's list starts at its own
		-- rotation offset (deterministic shuffle, like the original mod's
		-- random swap but MP-safe), so the packs still spread over the
		-- targets at the start while everyone always has a next one queued.
		local na = table.getn(unitAtks)
		if na > 0 then
			for i = 1, n do
				if not assigned[i] then
					assigned[i] = {}
				end
				local rot = math.mod(i - 1, na)
				for j = 1, na do
					table.insert(assigned[i], unitAtks[math.mod(rot + j - 1, na) + 1])
				end
			end
			dealt = dealt + na
		end

		-- More units than orders: instead of parking the leftovers (air
		-- units would land), give them the same tasks again from the start,
		-- so everyone stays busy (20 bombers over 12 targets -> 8 doubled;
		-- ONE order over many units -> the whole selection receives it).
		local total = table.getn(valid)
		if total > 0 then
			local k = 0
			for i = 1, n do
				if not assigned[i] then
					assigned[i] = { valid[math.mod(k, total) + 1] }
					k = k + 1
				end
			end
		end

		local busy = 0
		for i = 1, n do
			if assigned[i] then
				busy = busy + 1
			end
		end

		-- Every unit in the pool had only distributable orders, so a full
		-- clear-then-reissue can never lose anything.
		-- Shared build sites (broadcast/doubling handed one site to several
		-- engineers): count per site, so the issue loop can give each
		-- engineer his own place on the ring around it.
		local ringKey = function(order)
			return order.b .. '_' .. math.floor(order.p[1] + 0.5) .. '_' ..
				math.floor(order.p[3] + 0.5)
		end
		local ringTotal = {}
		local ringCount = {}
		for i = 1, n do
			local list = assigned[i]
			if list then
				for _, order in list do
					if order.t == 'Build' then
						local k = ringKey(order)
						ringTotal[k] = (ringTotal[k] or 0) + 1
					end
				end
			end
		end
		local rejected = 0
		-- Engineers that actually took builds this press (assist watcher).
		local dealtIds = {}
		local dealtFlag = {}
		local function RecordBuild(unit)
			if not dealtFlag[unit:GetEntityId()] then
				dealtFlag[unit:GetEntityId()] = true
				table.insert(dealtIds, unit:GetEntityId())
			end
		end
		for i = 1, n do
			local unit = units[i]
			-- M28 uses a bare IssueClearCommands here (no IssueStop), and it
			-- reliably wipes the whole queue including the active order.
			IssueClearCommands({ unit })
			local list = assigned[i]
			if list then
				for _, order in list do
					local slot, slots
					if order.t == 'Build' then
						local k = ringKey(order)
						ringCount[k] = (ringCount[k] or 0) + 1
						slot = ringCount[k]
						slots = ringTotal[k]
					end
					local accepted = ReissueOrder(unit, order, slot, slots)
					if accepted == true then
						RecordBuild(unit)
					elseif accepted == false then
						-- The engine refused this unit the build (e.g. a
						-- combat unit in the selection): append it to
						-- another unit instead of losing it.
						local placed = false
						for step = 1, n - 1 do
							local j = math.mod(i + step - 1, n) + 1
							if ReissueOrder(units[j], order) then
								RecordBuild(units[j])
								placed = true
								break
							end
						end
						if not placed then
							rejected = rejected + 1
						end
					end
				end
			end
		end
		if table.getn(dealtIds) > 0 then
			MNBDealtIds = dealtIds
			if not MNBHelpStarted then
				MNBHelpStarted = true
				ForkThread(MNBHelpThread)
			end
		end
		-- Ground truth for the next playtest log: the real command queue
		-- length of every unit right after the reissue (expect = assigned).
		local qs = {}
		for i = 1, n do
			local ok, q = pcall(function() return units[i]:GetCommandQueue() end)
			-- Lua 5.0 table.concat takes STRINGS only: numbers crash the
			-- whole callback after the work is already done (playtest log).
			table.insert(qs, tostring(ok and q and table.getn(q) or '?'))
		end
		LOG('MNB_SpreadOrders: dealt ' .. dealt .. ' orders over ' .. n .. ' units (' .. busy .. ' busy)' ..
			' rejected=' .. rejected ..
			' queue lens=' .. table.concat(qs, ','))
	end
end

-- === skuf: sim side of the personal Economy Helper UI mod ===
-- The player's skuf mod is UI-ONLY (works without others having it), so it cannot
-- carry sim code. Instead it calls these callbacks: every client has M&B, so the
-- callback exists and executes identically on every machine (kept deterministic ->
-- no desync). Features only ever touch the army passed in from the player's UI.
do
local SkufVanillaPrefix = { uef = 'ueb', aeon = 'uab', cybran = 'urb', seraphim = 'xsb' }
local SkufT4Prefix = { uef = 'seb', aeon = 'sab', cybran = 'srb', seraphim = 'ssb' }

-- vanilla ids: mex T1=1103 T2=1202 T3=1302, hydro=1102, pgens 1101/1201/1301;
-- storages: mass=1106, energy=1105; M&B T4 mex = x1312
local function SkufMexTier(sId)
    if string.find(sId, '1312') then return 4 end
    if string.find(sId, '1302') then return 3 end
    if string.find(sId, '1202') then return 2 end
    if string.find(sId, '1103') then return 1 end
    return nil
end

local function SkufNextMexId(unit)
    local bp = unit:GetBlueprint()
    local id = bp.BlueprintId or ''
    local faction = string.lower(bp.General.FactionName or 'uef')
    if string.find(id, '1103') then return (SkufVanillaPrefix[faction] or 'ueb') .. '1202' end
    if string.find(id, '1202') then return (SkufVanillaPrefix[faction] or 'ueb') .. '1302' end
    if string.find(id, '1302') then return (SkufT4Prefix[faction] or 'seb') .. '1312' end
    return nil
end

local function SkufTargetTier(brain)
    -- M&B research flags: [3]=T2 (ser9200), [4]=T3 (ser9300), [5]=T4 (ser9400)
    local t = brain.MNB_TechUnlocked
    if not t then return 1 end
    if t[5] then return 4 end
    if t[4] then return 3 end
    if t[3] then return 2 end
    return 1
end

local function SkufDistToSegment(px, pz, ax, az, bx, bz)
    local function d2(x1, z1, x2, z2)
        local ddx = x1 - x2
        local ddz = z1 - z2
        return math.sqrt(ddx * ddx + ddz * ddz)
    end
    local dx = bx - ax
    local dz = bz - az
    local len2 = dx * dx + dz * dz
    if len2 <= 0 then
        return d2(px, pz, ax, az)
    end
    local t = ((px - ax) * dx + (pz - az) * dz) / len2
    if t < 0 then t = 0 end
    if t > 1 then t = 1 end
    return d2(px, pz, ax + t * dx, az + t * dz)
end

-- Issue build orders tiling storages along all four sides of the target:
-- a 2x2 skirt (mex) gets 4 storages, a 6x6 skirt (hydro) gets 3 per side = 12
local function SkufDoSurround(target, engs)
    if not target or target.Dead or table.getn(engs) == 0 then return end
    local bp = target:GetBlueprint()
    local pos = target:GetPosition()
    local faction = string.lower(bp.General.FactionName or 'uef')
    local prefix = SkufVanillaPrefix[faction] or 'ueb'
    -- NOTE: IsInCategory does NOT exist on sim units (UI-only method) -> use EntityCategoryContains
    local storeBp = prefix .. (EntityCategoryContains(categories.MASSEXTRACTION, target) and '1106' or '1105')
    local sSkirt = 2 -- storage skirt
    local skirtX = bp.Physics.SkirtSizeX or 2
    local skirtZ = bp.Physics.SkirtSizeZ or 2
    local offX = skirtX / 2 + sSkirt / 2
    local offZ = skirtZ / 2 + sSkirt / 2
    local function sideOffsets(n)
        local list = {}
        for i = 0, n - 1 do
            table.insert(list, (i - (n - 1) / 2) * sSkirt)
        end
        return list
    end
    local xs = sideOffsets(math.max(1, skirtX / sSkirt))
    local zs = sideOffsets(math.max(1, skirtZ / sSkirt))
    -- spots are FULL {x,y,z} vectors: y from the target's ground position
    local spots = {}
    for _, d in zs do
        table.insert(spots, { pos[1] - offX, pos[2], pos[3] + d })
        table.insert(spots, { pos[1] + offX, pos[2], pos[3] + d })
    end
    for _, d in xs do
        table.insert(spots, { pos[1] + d, pos[2], pos[3] - offZ })
        table.insert(spots, { pos[1] + d, pos[2], pos[3] + offZ })
    end
    local brain = GetArmyBrain(target:GetArmy())
    -- occupancy check is done lua-side (distance to own structures): GetUnitsAroundPoint
    -- kept throwing "attempt to get as number a nil value" from the C side here
    local structs = brain:GetListOfUnits(categories.STRUCTURE, false, true) or {}
    local issued = 0
    for _, spot in spots do
        local blocked = false
        for _, s in structs do
            if not s.Dead then
                local sp = s:GetPosition()
                if sp then
                    -- plain math instead of VDist2 (its arg format is inconsistent here)
                    local dx = sp[1] - spot[1]
                    local dz = sp[3] - spot[3]
                    if dx * dx + dz * dz < 4 then
                        blocked = true
                        break
                    end
                end
            end
        end
        if not blocked then
            IssueBuildMobile(engs, spot, storeBp, {})
            issued = issued + 1
        end
    end
    LOG('SKUF surround ' .. (bp.BlueprintId or '?') .. ' engs=' .. table.getn(engs) .. ' issued=' .. issued .. ' bp=' .. storeBp)
end

local function SkufUnitsFromIds(ids)
    local out = {}
    local list = ids or {}
    for _, id in list do
        local u = GetEntityById(id)
        if u and not u.Dead and not EntityCategoryContains(categories.STRUCTURE, u) then
            table.insert(out, u)
        end
    end
    return out
end

Callbacks.SkufSurround = function(data)
    local target = GetEntityById(data.unit)
    if not target or target.Dead then return end
    SkufDoSurround(target, SkufUnitsFromIds(data.units))
end

Callbacks.SkufCorridorReclaim = function(data)
    local engs = SkufUnitsFromIds(data.units)
    if table.getn(engs) == 0 then return end
    local a = data.a
    local b = data.b
    if not a or not b then return end
    -- corridor half-width = best build/reclaim reach of the group, plus a small pad
    local r = 0
    for _, u in engs do
        local eBp = u:GetBlueprint().Economy
        local br = eBp.BuildRadius or eBp.MaxBuildDistance or 6
        if br > r then r = br end
    end
    r = r + 2
    local props = GetReclaimablesInRect(math.min(a[1], b[1]) - r, math.min(a[2], b[2]) - r, math.max(a[1], b[1]) + r, math.max(a[2], b[2]) + r) or {}
    local issued = 0
    for _, p in props do
        if SkufIsProp(p) then
            pcall(function()
                local pp = p:GetPosition()
                if pp and SkufDistToSegment(pp[1], pp[3], a[1], a[2], b[1], b[2]) <= r then
                    IssueReclaim(engs, p)
                    issued = issued + 1
                end
            end)
        end
    end
    LOG('SKUF corridor r=' .. r .. ' props=' .. table.getn(props) .. ' issued=' .. issued)
end

local function SkufWatcherThread(brain)
    -- mex auto-upgrade (user's design, 2026-08-14):
    --   * when a tier is researched, upgrade ALL mexes below it AT ONCE;
    --   * stores running dry -> PAUSE everyone except one (SetPaused keeps the order
    --     AND its progress; NOTHING is ever canceled -> no mass is ever thrown away);
    --   * stores recovered -> unpause one per pass.
    -- IsUnitState('Upgrading') reports FALSE for mexes that ARE upgrading (log-proven),
    -- so outstanding orders are tracked OURSELVES; a flag clears only when the mex
    -- reaches the target tier or dies. Manual player cancels are respected.
    local issued = {}    -- eid -> true while an upgrade order we placed is outstanding
    local pausedUpg = {} -- eid -> true while WE paused its upgrade
    local ticks = 0
    while true do
        WaitSeconds(5)
        if brain:IsDefeated() then break end
        ticks = ticks + 1
        -- pcall keeps the watcher alive even if one pass hits a bad unit
        local ok, err = pcall(function()
            local target = SkufTargetTier(brain)
            if math.mod(ticks, 12) == 1 then
                LOG('SKUF watch tick=' .. ticks .. ' targetTier=' .. target .. ' researchFlags=' .. tostring(brain.MNB_TechUnlocked ~= nil))
            end
            if target >= 2 then
                -- Pause decision is based on STORAGE, not the +/- rate (user, 2026-08-14):
                -- a slightly negative trend with full stores is NOT a problem. Pause only
                -- when the stored mass is about to run dry (UIMassFabManager-style).
                local netMass = brain:GetEconomyTrend('MASS') or 0
                local storedMass = brain:GetEconomyStored('MASS') or 0
                local storedRatio = brain:GetEconomyStoredRatio('MASS') or 0
                local starving = netMass < 0 and (storedMass + netMass * 20 < 0 or storedRatio < 0.05)
                local mexes = brain:GetListOfUnits(categories.MASSEXTRACTION, false, true)
                local pending = {}
                for _, mex in mexes do
                    if not mex.Dead then
                        local eid = mex:GetEntityId()
                        local tier = SkufMexTier(mex:GetBlueprint().BlueprintId or '')
                        if tier and tier < target then
                            table.insert(pending, { mex = mex, eid = eid, tier = tier })
                        else
                            -- reached the target tier (or unrecognized): forget it entirely
                            issued[eid] = nil
                            pausedUpg[eid] = nil
                        end
                    end
                end
                -- drop tracking of units that died
                for eid in issued do
                    local u = GetEntityById(eid)
                    if not u or u.Dead then
                        issued[eid] = nil
                        pausedUpg[eid] = nil
                    end
                end

                if starving then
                    -- pause everyone except the single most-progressed one
                    local running = {}
                    for _, p in pending do
                        if issued[p.eid] and not pausedUpg[p.eid] then
                            table.insert(running, p)
                        end
                    end
                    table.sort(running, function(a, b)
                        return (a.mex:GetWorkProgress() or 0) > (b.mex:GetWorkProgress() or 0)
                    end)
                    for i = 2, table.getn(running) do
                        local p = running[i]
                        if not p.mex:IsPaused() then
                            p.mex:SetPaused(true)
                            LOG('SKUF pause upgrade (mass ' .. string.format('%.1f', netMass) .. ')')
                        end
                        pausedUpg[p.eid] = true
                    end
                else
                    -- stores are fine: unpause ONE held mex per pass (5s)
                    local released = 0
                    for _, p in pending do
                        if pausedUpg[p.eid] and released == 0 then
                            if p.mex:IsPaused() then
                                p.mex:SetPaused(false)
                                LOG('SKUF resume upgrade (mass +' .. string.format('%.1f', netMass) .. ')')
                            end
                            pausedUpg[p.eid] = nil
                            released = released + 1
                        end
                    end
                    -- issue upgrades: everything not held and not already issued goes at once
                    for _, p in pending do
                        local eid = p.eid
                        if not pausedUpg[eid] and not issued[eid] then
                            local nextId = SkufNextMexId(p.mex)
                            if nextId then
                                IssueUpgrade({ p.mex }, nextId)
                                issued[eid] = true
                                LOG('SKUF upgrade mex tier ' .. p.tier .. ' -> ' .. nextId)
                            end
                        end
                    end
                end
            end
        end)
        if not ok then
            LOG('SKUF watcher error: ' .. tostring(err))
        end
    end
end

-- === auto-reclaim engineer (user's design, 2026-08-14) ===
-- Reclaim order + click on EMPTY ground -> the click point is the engineer's
-- reference point: it FIRST drives to that point, THEN eats everything by the Reclaim
-- Turret (M&B Z?B0205) rules. Station-to-station: everything within (arm reach minus
-- a margin) of where it stands is queued at once; clean station -> explicit drive to
-- the nearest target = next station. Clean zone around the reference point -> radius
-- doubles (cleans outward).
-- Each target is CLAIMED by one engineer, so several auto-engineers never share a list.
local SKUF_ZONE_MIN = 20 -- starting circle around the click point: random in [MIN, MAX]
local SKUF_ZONE_MAXR = 40
local SKUF_ZONE_MAX = 150  -- work zone cap around the click point: bounds the
                           -- expensive "all reclaimables in rect" queries (640 covered
                           -- half the map per engineer per second = sim lag); when empty
                           -- within it the engineer goes home and waits for a new click
local SKUF_ZONE_BATCH = 12 -- max targets queued at one spot (safety cap only)
local SKUF_REACH_MARGIN = 0 -- queue radius = arm reach minus this; 0 = full reach +2 buffer
                            -- (the old -5 shrank stations to 1-3 rocks and caused hop spam;
                            -- the freeze it guarded against was zero-mass props, now mass-filtered)
local SKUF_RETRY_MAX = 3 -- same target re-issued this many times = engine refuses it
                         -- (island/cliff rock) -> mark bad, never pick again

local skufAutoEngs = {} -- eid -> { anchor={x,z}, radius, expect } while in auto-reclaim mode
local skufReclaimCandidates = {} -- eid -> click pos until the thread confirms it was NOT a rock click
local skufClaimed = {} -- target entity -> captor eid (one target belongs to one engineer)
local skufBadTargets = {} -- target entity -> {x, z of the engineer when marked}:
                          -- skipped while the engineer stays near that point; re-tried
                          -- once it actually gets elsewhere (e.g. ferried to the island)

-- TRUE props only (rocks and wrecks). GetReclaimablesInRect ALSO returns LIVE units
-- (own units are reclaimable in FA!), which made auto-engineers eat each other and the
-- hidden factory maintenance units -> skip anything that is a unit.
local function SkufIsProp(p)
    if p == nil then return false end
    local ok, isUnit = pcall(IsUnit, p)
    return ok and not isUnit
end

-- how much mass a target is worth: props carry it in ReclaimMassMax (rocks 10-50;
-- hydrocarbon deposits and decorations have 0/empty -- the engineer froze on one
-- for two minutes once), live units are worth their build cost
local function SkufTargetMass(p)
    local ok, mass = pcall(function()
        if SkufIsProp(p) then
            -- the live amount the engine maintains (wrecks get it at runtime);
            -- blueprint fallback -- note it lives under Economy, not top-level
            if p.MaxMassReclaim then return p.MaxMassReclaim end
            return p:GetBlueprint().Economy.ReclaimMassMax
        end
        return p:GetBlueprint().Economy.BuildCostMass
    end)
    return ok and (tonumber(mass) or 0) or 0
end

-- Reclaim Turret (M&B Z?B0205) target filter: props only if they actually hold
-- mass (zero-mass props = an order the engine silently drops = the freeze loop);
-- a unit only if it is an ENEMY one (not allied, not capturable) -- this is what
-- keeps the reclaimer from eating friendly units. Everything gated by mass storage.
local function SkufTurretWantsTarget(reclaimerArmy, target, brain)
    if (brain:GetEconomyStoredRatio('MASS') or 0) >= 0.95 then return false end
    if SkufIsProp(target) then return SkufTargetMass(target) > 0 end
    local ok, isUnit = pcall(IsUnit, target)
    if not ok or not isUnit then return false end
    local okA, isAlly = pcall(IsAlly, reclaimerArmy, target:GetArmy())
    local okC, capturable = pcall(function() return target:IsCapturable() end)
    return okA and okC and not isAlly and not capturable
end

local function SkufReleaseClaims(eid)
    for p, owner in skufClaimed do
        if owner == eid then
            skufClaimed[p] = nil
        end
    end
end

Callbacks.SkufReclaimClick = function(data)
    local engs = {}
    for _, u in SkufUnitsFromIds(data.units or {}) do
        if EntityCategoryContains(categories.ENGINEER, u) then
            table.insert(engs, u)
        end
    end
    if not data.pos then return end
    if table.getn(engs) == 0 then
        LOG('SKUF reclaim click: no engineers in the click')
        return
    end
    -- "rock click" vs "void click" is decided later by the auto thread: a click on a
    -- reclaimable makes the engine append a Reclaim order; empty ground appends nothing.
    -- Our callback runs BEFORE the engine has processed the click, so the candidate is
    -- parked and re-checked a second later when the engine's order is visible.
    for _, u in engs do
        skufReclaimCandidates[u:GetEntityId()] = { data.pos[1], data.pos[2], data.pos[3] }
    end
end

-- Station-to-station (user, 2026-08-15): arm reach minus a margin is the SCAN radius
-- around the spot the engineer stands on -- everything found there is queued at once
-- and is guaranteed to be within arm's reach (the engine does NOT walk the engineer
-- in on a bare out-of-reach reclaim order -- he stood frozen and the order was
-- re-issued every second, forever). When the station circle is clean, the engineer
-- drives to the nearest target in the (expanding) anchor zone = the next station.
-- Returns orders queued (0 = zone given up, auto mode turned off).
local function SkufScanAndQueue(eng, eid, entry)
    -- queue empty: everything we claimed is eaten or gone -> free the claims first
    SkufReleaseClaims(eid)
    local brain = GetArmyBrain(eng:GetArmy())
    local a = entry.anchor
    local ep = eng:GetPosition() or { a[1], 0, a[2] }
    local econ = eng:GetBlueprint().Economy
    local reach = (econ.BuildRadius or econ.MaxBuildDistance or 6) + 2
    local scanR = reach - SKUF_REACH_MARGIN
    local scan2 = scanR * scanR
    -- collect wanted unclaimed props in a rect, scored by distance from the engineer
    local function Collect(x0, z0, x1, z1)
        local out = {}
        local props = GetReclaimablesInRect(x0, z0, x1, z1) or {}
        for _, p in props do
            if p and not skufClaimed[p] and not skufBadTargets[p] then
                local okT, want = pcall(SkufTurretWantsTarget, eng:GetArmy(), p, brain)
                local okP, pp = pcall(function() return p:GetPosition() end)
                if okT and want and okP and pp then
                    local dx = pp[1] - ep[1]
                    local dz = pp[3] - ep[3]
                    table.insert(out, { p = p, pos = pp, d = dx * dx + dz * dz, m = SkufTargetMass(p) })
                end
            end
        end
        return out
    end
    -- anti-freeze (user, 2026-08-15): if the SAME target keeps being re-issued --
    -- the queue drains, we pick it again, the engine refuses the order again
    -- (island/cliff rock) -- after SKUF_RETRY_MAX tries mark it bad and move on
    local function StuckCheck(t)
        if entry.last == t.p then
            entry.tries = (entry.tries or 0) + 1
        else
            entry.last = t.p
            entry.tries = 1
        end
        if entry.tries >= SKUF_RETRY_MAX then
            skufBadTargets[t.p] = { ep[1], ep[3] }
            entry.last = nil
            entry.tries = 0
            LOG('SKUF auto-reclaim eng=' .. eid .. ' target refused ' .. SKUF_RETRY_MAX .. ' times (unreachable?), skipping')
            return true
        end
        return false
    end
    -- 1) station: everything within scanR of where the engineer stands right now.
    -- First, rehab: a bad-marked target only stays bad while the engineer is near
    -- the point where it was marked -- if it got elsewhere (ferried by transport
    -- to the island), the target is retried
    local near = GetReclaimablesInRect(ep[1] - scanR, ep[3] - scanR, ep[1] + scanR, ep[3] + scanR) or {}
    for _, p in near do
        local mark = skufBadTargets[p]
        if mark then
            local mx = ep[1] - mark[1]
            local mz = ep[3] - mark[2]
            if mx * mx + mz * mz > 900 then -- 30+ from the mark point
                skufBadTargets[p] = nil
                LOG('SKUF auto-reclaim eng=' .. eid .. ' bad target near a new position, retrying')
            end
        end
    end
    local station = {}
    for _, s in Collect(ep[1] - scanR, ep[3] - scanR, ep[1] + scanR, ep[3] + scanR) do
        if s.d <= scan2 then
            table.insert(station, s)
        end
    end
    if table.getn(station) > 0 then
        -- priority reclaim (user, 2026-08-15): fattest target first, nearest breaks
        -- ties -- on contested ground the big rocks must be grabbed first
        table.sort(station, function(x, y)
            if x.m ~= y.m then return x.m > y.m end
            return x.d < y.d
        end)
        if StuckCheck(station[1]) then
            table.remove(station, 1)
        end
    end
    if table.getn(station) > 0 then
        local issued = 0
        for i = 1, math.min(SKUF_ZONE_BATCH, table.getn(station)) do
            skufClaimed[station[i].p] = eid
            IssueReclaim({ eng }, station[i].p)
            issued = issued + 1
        end
        entry.expect = issued
        LOG('SKUF auto-reclaim station eng=' .. eid .. ' @' .. math.floor(ep[1]) .. ',' .. math.floor(ep[3]) .. ' targets=' .. issued .. ' top=' .. station[1].m)
        return issued
    end
    -- 2) station clean: drive to the NEAREST target in the expanding anchor zone.
    -- Fattest-first only decides the eating order INSIDE a station -- letting it
    -- pick the hop too sent the engineer zigzagging across the map after 75-mass
    -- rocks while whole fields of small ones waited (user, 2026-08-15)
    local hop = nil
    while hop == nil and entry.radius <= SKUF_ZONE_MAX do
        local cand = Collect(a[1] - entry.radius, a[2] - entry.radius, a[1] + entry.radius, a[2] + entry.radius)
        for _, s in cand do
            if hop == nil or s.d < hop.d then
                hop = s
            end
        end
        if hop ~= nil and StuckCheck(hop) then
            hop = nil -- just blacklisted: re-collect without it
        end
        if hop == nil then
            entry.radius = entry.radius * 2
            LOG('SKUF auto-reclaim eng=' .. eid .. ' circle clean, radius now ' .. entry.radius)
        end
    end
    if hop == nil then
        skufAutoEngs[eid] = nil
        -- zone given up: send the engineer home so the player does not have to
        -- hunt for it across the map (user, 2026-08-15)
        -- GetStartVector3f returns a plain {x, 0, z} table -- pass it straight through
        local okH, home = pcall(function() return brain:GetStartVector3f() end)
        if okH and home and home[1] then
            IssueMove({ eng }, home)
            LOG('SKUF auto-reclaim off: nothing left, going home')
        else
            LOG('SKUF auto-reclaim off: nothing left')
        end
        return 0
    end
    -- the hop target is claimed so other auto-engineers leave it alone during the drive
    skufClaimed[hop.p] = eid
    IssueMove({ eng }, hop.pos)
    entry.expect = 1
    LOG('SKUF auto-reclaim hop eng=' .. eid .. ' to ' .. math.floor(hop.pos[1]) .. ',' .. math.floor(hop.pos[3]) .. ' mass=' .. hop.m .. ' radius=' .. entry.radius)
    return 1
end

-- length of the unit's command queue (the only reliably readable thing about sim
-- commands: their .type field is UI-only and is nil sim-side)
local function SkufQueueCount(unit)
    local ok, q = pcall(function() return unit:GetCommandQueue() end)
    if ok and q then return table.getn(q) end
    return 0
end

local function SkufAutoReclaimThread()
    while true do
        -- 1s poll: targets are queued in small local batches, a 3s gap between rocks
        -- would leave the engineer standing around
        WaitSeconds(1)
        local ok, err = pcall(function()
            -- confirm pending click candidates: engine ordered a Reclaim by itself =
            -- the player clicked a rock (normal single reclaim, we stay out);
            -- no Reclaim in the queue = the click hit empty ground -> auto mode ON,
            -- the click point becomes the engineer's anchor/zone center
            for eid, cpos in skufReclaimCandidates do
                skufReclaimCandidates[eid] = nil
                local u = GetEntityById(eid)
                if u and not u.Dead then
                    if SkufQueueCount(u) > 0 then
                        LOG('SKUF reclaim click was on a rock: staying out')
                    elseif not skufAutoEngs[eid] then
                        skufAutoEngs[eid] = { anchor = { cpos[1], cpos[3] }, radius = math.random(SKUF_ZONE_MIN, SKUF_ZONE_MAXR), expect = 1, justArmed = true }
                        -- go to the click point FIRST; scavenging starts from there
                        IssueMove({ u }, cpos)
                        LOG('SKUF auto-reclaim ON eng=' .. eid .. ' anchor=' .. math.floor(cpos[1]) .. ',' .. math.floor(cpos[3]))
                    end
                end
            end
            for eid, entry in skufAutoEngs do
                local eng = GetEntityById(eid)
                if not eng or eng.Dead then
                    SkufReleaseClaims(eid)
                    skufAutoEngs[eid] = nil
                elseif entry.justArmed then
                    -- armed this very pass: skip one round so the engine registers the
                    -- move order we just issued before we start counting the queue
                    entry.justArmed = nil
                else
                    -- everything is tracked by the command queue LENGTH (sim commands
                    -- carry no readable type, but the count is reliable):
                    --   queue longer than what we issued = the player added an order;
                    --   queue drained = trip over / batch finished -> queue the next one;
                    --   otherwise = ours still being worked through, just wait.
                    local n = SkufQueueCount(eng)
                    if n > (entry.expect or 0) then
                        SkufReleaseClaims(eid)
                        skufAutoEngs[eid] = nil
                        LOG('SKUF auto-reclaim off: new order eng=' .. eid)
                    elseif n == 0 then
                        SkufScanAndQueue(eng, eid, entry)
                    else
                        entry.expect = n
                    end
                end
            end
        end)
        if not ok then
            LOG('SKUF auto-reclaim error: ' .. tostring(err))
        end
    end
end

Callbacks.SkufInit = function(data)
    -- data.army comes from the player's UI (their focus army). NEVER use GetFocusArmy
    -- here: in a networked game it returns a DIFFERENT army on every client, and the
    -- watcher must run for the same army everywhere or the game desyncs.
    if not data or not data.army then return end
    local brain = GetArmyBrain(data.army)
    LOG('SKUF init called, army=' .. tostring(data.army))
    if not brain or brain.SkufWatcherStarted then return end
    brain.SkufWatcherStarted = true
    ForkThread(SkufWatcherThread, brain)
    ForkThread(SkufAutoReclaimThread)
    LOG('SKUF watcher started')
end

end
