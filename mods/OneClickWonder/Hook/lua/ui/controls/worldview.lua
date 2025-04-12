do
	local CM = import('/lua/ui/game/commandmode.lua')
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
			if rollOver and rollOver.userUnit:GetArmy() == GetFocusArmy() and rollOver.userUnit:IsInCategory('STRUCTURE') then
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