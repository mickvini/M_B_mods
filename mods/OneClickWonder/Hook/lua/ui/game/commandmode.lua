structs = { alive = {}, dead = {} }	--	alive is keyed by EntityId, and dead is keyed by position.

local automode

function GetAliveStructs()
	return structs.alive
end

function GetAliveStructsAround(pos)
	return GetDividedTable(structs.alive, pos[1], pos[3])
end

function AddAliveStruct(s)
	local p = s:GetPosition()
	AddDividedTable(structs.alive, { bp = s:GetUnitId(), pos = p }, p[1], p[3], s:GetEntityId())
end

function GetDeadStructs()
	return structs.dead
end

function IsAutoMode()
	return commandMode and automode
end

local oldStartCommandMode = StartCommandMode
function StartCommandMode(newCommandMode, data, auto)
	oldStartCommandMode(newCommandMode, data)
	
	automode = auto	--	all we want to do is take note if this was called bacause of the mouse being over a mex/wreck.
end

local oldOnCommandIssued = OnCommandIssued
function OnCommandIssued(command)
	oldOnCommandIssued(command)
	
	--local units = GetSelectedUnits()
	
	--SPEW(repr(command))
	
	local ent = command.Target.EntityId
	
	--	if a structure is being ordered on in any way shape or form, then add it.
	if not ent == nil then
		if ent and GetUnitById(ent):GetArmy() == command.Units[1]:GetArmy() and ent:IsInCategory('STRUCTURE') then
			AddAliveStruct(ent)
		end
	end
	
	for id, unit in command.Units do
		--	build a list of the player's structures for rebuilding. 
		if not unit == nil then
			if unit:IsInCategory('STRUCTURE') then
				AddAliveStruct(unit)
			--	SPEW('structure added itself ' .. table.getn(GetAliveStructs()))
			end
		end
		
		local focus = unit:GetFocus()
		
		if not focus == nil then
			if focus and focus:GetArmy() == unit:GetArmy() and focus:IsInCategory('STRUCTURE') then
				AddAliveStruct(focus)
				--SPEW('something added a structure ' .. table.getn(GetAliveStructs()))
			end
		end
	end
end
