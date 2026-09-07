------------------------------------------------------------------------
--                                                                    --
-- Hook into File : /lua/ui/controls/worldview.lua                    --
-- Origin         : skuf (Economy Helper) mod, merged into M&B        --
--                                                                    --
-- Summary  : One-click economy, gated by the Alt-E master switch     --
--            (/mods/M&B/lua/skuftoggle.lua):                         --
--              * click own mex/hydro with an engineer/ACU selected   --
--                -> full storage surround (sim tiles it, no ghost);  --
--              * Alt+Shift + two clicks in reclaim mode -> corridor  --
--                reclaim;                                            --
--              * click empty ground in reclaim mode -> auto-reclaim; --
--              * hover a free deposit marker -> build mode with the  --
--                right mex/hydro in hand (OneClickWonder mechanic).  --
--            Switch OFF -> the vanilla handler runs untouched.       --
--                                                                    --
------------------------------------------------------------------------

do
	local CM = import('/lua/ui/game/commandmode.lua')
	local SkufToggle = import('/mods/M&B/lua/skuftoggle.lua')

	local deposit_markers = nil	--	it's nil instead of an empty table so we can accomodate for
								--	the possibility of no markers and not thrash the Scenario table.

	CalculateFracValues()

	local function round(num)
		return tonumber(string.format("%." .. 0 .. "f", num))
	end

	local oldWorldView = WorldView
	WorldView = Class(oldWorldView)
	{
		HandleEvent = function(self, ev)

			-- Alt-E master switch off: nothing skuf happens, vanilla only
			if not SkufToggle.IsEnabled() then
				return oldWorldView.HandleEvent(self, ev)
			end

			-- skuf: left click on our own mex/hydro with an engineer/ACU selected ->
			-- order the full surround centered on that building (sim side tiles storages
			-- along its skirt and skips occupied spots). No blueprint, no command mode,
			-- nothing to drag or misplace; sim orders append, so clicking several
			-- mexes in a row queues all of them.
			-- NOTE: engine click event type is 'ButtonPress' with ev.Modifiers.Left/Right
			local skufConsumed = false
			if ev.Type == 'ButtonPress' and ev.Modifiers and ev.Modifiers.Left then
				local skufSel = GetSelectedUnits()
				if skufSel and table.getn(skufSel) > 0
					and table.getn(EntityCategoryFilterDown(categories.ENGINEER + categories.COMMAND, skufSel)) > 0 then
					local ro = GetRolloverInfo()
					if ro and ro.userUnit and ro.userUnit.GetArmy and ro.userUnit:GetArmy() == GetFocusArmy()
						and (ro.userUnit:IsInCategory('MASSEXTRACTION') or ro.userUnit:IsInCategory('HYDROCARBON')) then
						local ids = {}
						for _, u in skufSel do
							table.insert(ids, u:GetEntityId())
						end
						SimCallback({ Func = 'SkufSurround', Args = { unit = ro.userUnit:GetEntityId(), units = ids } }, false)
						skufConsumed = true
					end
				end
			end
			-- skuf: corridor reclaim -- Shift+Alt+left click two points while the reclaim
			-- order mode is up; consuming the clicks keeps that mode alive between them.
			if not skufConsumed and ev.Type == 'ButtonPress' then
				local skufSel = GetSelectedUnits()
				if skufSel and table.getn(skufSel) > 0 then
					local skufCM = CM.GetCommandMode()
					local skufInReclaim = skufCM[1] == 'order' and skufCM[2] and skufCM[2].name == 'RULEUCC_Reclaim'
					if not skufInReclaim then
						self.SkufCorridorA = nil
					end
					local skufEngs = EntityCategoryFilterDown(categories.ENGINEER - categories.STRUCTURE, skufSel)
					if skufInReclaim and ev.Modifiers and ev.Modifiers.Left and IsKeyDown('Menu') and IsKeyDown('Shift') and table.getn(skufEngs) > 0 then
						local m = GetMouseWorldPos()
						if not self.SkufCorridorA then
							self.SkufCorridorA = { m[1], m[3] }
						else
							local ids = {}
							for _, u in skufEngs do
								table.insert(ids, u:GetEntityId())
							end
							SimCallback({ Func = 'SkufCorridorReclaim', Args = { a = self.SkufCorridorA, b = { m[1], m[3] }, units = ids } }, false)
							self.SkufCorridorA = nil
							CM.EndCommandMode(true)
						end
						skufConsumed = true
					end
				end
			end
			-- skuf: left press in reclaim order mode -> sim side decides: a rock/wreck
			-- near the click = normal single reclaim (the engine's own order stands,
			-- we do nothing); EMPTY ground = the engineer enters auto-reclaim mode
			-- (finds and queues reclaimables on its own).
			-- NOTE: ButtonRelease never reaches this handler, so a click cannot be told
			-- apart from the start of an area-drag; a drag starting far from any rock
			-- also arms auto mode.
			if not skufConsumed and ev.Type == 'ButtonPress' then
				local skufSel2 = GetSelectedUnits()
				if skufSel2 and table.getn(skufSel2) > 0 then
					local skufCM2 = CM.GetCommandMode()
					local skufInReclaim2 = skufCM2[1] == 'order' and skufCM2[2] and skufCM2[2].name == 'RULEUCC_Reclaim'
					if skufInReclaim2 and ev.Modifiers and ev.Modifiers.Left then
						local m = GetMouseWorldPos()
						local ids = {}
						for _, u in skufSel2 do
							table.insert(ids, u:GetEntityId())
						end
						SimCallback({ Func = 'SkufReclaimClick', Args = { pos = { m[1], m[2], m[3] }, units = ids } }, false)
					end
				end
			end
			if skufConsumed then
				return true
			end

			local res = oldWorldView.HandleEvent(self, ev)


			if not deposit_markers then

				local saveData = {}

				doscript('/lua/dataInit.lua', saveData)
				doscript(SessionGetScenarioInfo().save, saveData)

				--SPEW('processed Scenario Info.')

				deposit_markers = {}

				for markerName, markerTable in saveData.Scenario.MasterChain['_MASTERCHAIN_'].Markers do
					if markerTable.type == 'Mass' or markerTable.type == 'Hydrocarbon' then
						AddDividedTable(deposit_markers, markerTable, markerTable.position[1], markerTable.position[3])
					end
				end

				--SPEW('Built marker table.')
				for id, col in deposit_markers do
					for ik, row in col do
						--SPEW(table.getn(row))
					end
					--SPEW('------')
				end
			end

			local selectedUnits = GetSelectedUnits()
			local rollOver = GetRolloverInfo()
			local currentCM = CM.GetCommandMode()

			local numTotal = 0
			local numT2 = 0
			local numT3 = 0
			if not (selectedUnits == nil) then
				numTotal = table.getn(selectedUnits)
				numT2 = table.getn(EntityCategoryFilterDown(categories.TECH2, selectedUnits))
				numT3 = table.getn(EntityCategoryFilterDown(categories.TECH3, selectedUnits))
			end

			--SPEW(1)

			local availableOrders, availableToggles, buildableCategories = GetUnitCommandData(selectedUnits or {})

			--	if we mouse-over any of our structures, add it.
			if rollOver and rollOver.userUnit and rollOver.userUnit.GetArmy and rollOver.userUnit:GetArmy() == GetFocusArmy() and rollOver.userUnit:IsInCategory('STRUCTURE') then
				--SPEW('added a moused-over structure.')
				CM.AddAliveStruct(rollOver.userUnit)
			end

			if selectedUnits and rollOver then
				if CM.IsAutoMode() and not currentCM[2].name == 'RULEUCC_Repair' then
					--SPEW("BLURK!")
					CM.EndCommandMode(true)
				end

				--	ALT+Left repairs any unit/structure (instead of Right issuing a guard/assist).
				if IsKeyDown('Menu') and table.inverse(availableOrders)['RULEUCC_Repair'] and (rollOver.workProgress < 1 or rollOver.health < rollOver.maxHealth) then
					CM.StartCommandMode('order', { name = 'RULEUCC_Repair' }, true )
					--SPEW("rep")
				end

				return res
			end	--	save time, don't process the following for no gain.

		--	SPEW(2)

			if not buildableCategories then return res end	--	since we can't build *anything* skip all this.

			local buildableUnits = table.inverse(EntityCategoryGetUnitList(buildableCategories))

			local m = GetMouseWorldPos()

			local rebuildBP = CM.GetDeadStructs()[GetPositionHash(math.floor(m[1]), math.floor(m[3]))]
			local buildBP = nil

		--	SPEW(3)

			if IsKeyDown('Menu') and rebuildBP and buildableUnits[rebuildBP] then
				buildBP = rebuildBP
			else
				local zoom = 1.5 + 7.0 * GetCamera(self._cameraName):GetZoom() / GetCamera(self._cameraName):GetMaxZoom()

				--	walk the deposit_markers list for any markers near the cursor.
				for markerName, markerTable in GetDividedTable(deposit_markers, m[1], m[3]) do
					if VDist2(markerTable.position[1], markerTable.position[3], m[1], m[3]) < zoom then	--	this mapping roughly works like the snap-to trickery the engine does for deposits.

						--	If we;ve found a deposit in the marker list, check the alive
						--	structs list to seeif we've got something built on it already.
						for id, struct in CM.GetAliveStructsAround(m) do
							if struct.pos[1] == markerTable.position[1] and struct.pos[3] == markerTable.position[3] then
							--	SPEW('found a mex there')
								return res
							end
						end



						if markerTable.type == 'Hydrocarbon' then
							buildBP = EntityCategoryGetUnitList(buildableCategories * categories.HYDROCARBON * categories.TECH1)[1]
						else
							if numT3 == numTotal then
								buildBP = EntityCategoryGetUnitList(buildableCategories * categories.MASSEXTRACTION * categories.TECH3)[1]
							elseif (numT2+numT3 == numTotal) then
								buildBP = EntityCategoryGetUnitList(buildableCategories * categories.MASSEXTRACTION * categories.TECH2)[1]
							else
								buildBP = EntityCategoryGetUnitList(buildableCategories * categories.MASSEXTRACTION * categories.TECH1)[1]
							end
						end

						break
					end
				end
			end

		--	SPEW(4)

			if buildBP then
				if not currentCM[1] then
					CM.StartCommandMode('build', { name = buildBP }, true )
				end
			else
				if CM.IsAutoMode() then
					CM.EndCommandMode(true)
				end
			end

			return res
		end,
	}
end
