do

	local oldOnSelectionChanged = OnSelectionChanged
	function OnSelectionChanged(old, new, added, removed)
        local CM = import('/lua/ui/game/commandmode.lua')
		
		for id, unit in added do
			--	build a list of the player's structures for rebuilding. 
			if unit:IsInCategory('STRUCTURE') then
				CM.AddAliveStruct(unit)
			--	SPEW('selected a structure ' .. table.getn(CM.GetAliveStructs()))
			end
			
			local focus = unit:GetFocus()
			
			if focus and focus:GetArmy() == unit:GetArmy() and focus:IsInCategory('STRUCTURE') then
				CM.AddAliveStruct(focus)
				--SPEW('selected unit has a focus structure ' .. table.getn(CM.GetAliveStructs()))
			end
		end
		
		oldOnSelectionChanged(old, new, added, removed)
	end
end