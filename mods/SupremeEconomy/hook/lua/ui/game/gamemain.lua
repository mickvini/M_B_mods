local originalCreateUI = CreateUI
local originalOnSelectionChanged = OnSelectionChanged
local modFolder = 'SupremeEconomy'
local UpdateAllUnits = import('/mods/' .. modFolder .. '/modules/mciallunits.lua').UpdateAllUnits
local IsAutoSelection = import('/mods/' .. modFolder .. '/modules/mciallunits.lua').IsAutoSelection

function OnSelectionChanged(oldSelection, newSelection, added, removed)
	if not IsAutoSelection() then
		originalOnSelectionChanged(oldSelection, newSelection, added, removed)
	end
end

function CreateUI(isReplay)
	originalCreateUI(isReplay)

	local parent = import('/lua/ui/game/borders.lua').GetMapGroup()

	AddBeatFunction(UpdateAllUnits)
	import('/mods/' .. modFolder .. '/modules/resourceusage.lua').CreateModUI(isReplay, parent)
	import('/mods/' .. modFolder .. '/modules/mexes.lua').CreateModUI(isReplay, parent)
end
