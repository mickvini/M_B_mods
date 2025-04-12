do
	--local GameMain = import('/lua/ui/game/gamemain.lua')
	--
	--SPEW('Init')

	function GetPositionHash(x, z)
		return tostring(x .. ',' .. z)
	end
	
	local divisions = 4	--	how many sub-tables do we divide the map dimensions into?
	--local fracX = divisions / SessionGetScenarioInfo().size[1]
	--local fracZ = divisions / SessionGetScenarioInfo().size[2]
	local fracX = nil
	local fracZ = nil
	
	function CalculateFracValues()
		fracX = divisions / SessionGetScenarioInfo().size[1]
		fracZ = divisions / SessionGetScenarioInfo().size[2]
	end
	
	function GetDividedTable(t, x, z)
		local u = math.floor(x * fracX)
		local v = math.floor(z * fracZ)
		
		local col = t[u] or {}
		
		return col[v] or {}
	end
	
	--	divide tables are always walked, we don't use keys here.
	function AddDividedTable(t, d, x, z, key)
		local u = math.floor(x * fracX)
		local v = math.floor(z * fracZ)
		
		if not t[u] then t[u] = {} end	--	
		
		if not t[u][v] then
			t[u][v] = {}
		end
		
		if key then
			t[u][v][key] = table.copy(d)
		else
			table.insert(t[u][v], table.copy(d))
		end
	end
	
	local oldOnSync = OnSync
	function OnSync()
		local CM = import('/lua/ui/game/commandmode.lua')
		
		for id, v in Sync.ReleaseIds do
		
		--	SPEW('BOOM ' .. id)
			
			local p = false
			
			for x, row in CM.GetAliveStructs() or {} do
				for y, col in row or {} do
					if col[id] then
						--	fuck yeah; hash functions!
						local h = GetPositionHash(math.floor(col[id].pos[1]), math.floor(col[id].pos[3]))
						
						CM.structs.dead[h] = col[id].bp
						
						col[id] = nil
						
						p = true
						
						break
					end
				end
				
				if p then break end
			end			
		end
		
		oldOnSync()
	end
end