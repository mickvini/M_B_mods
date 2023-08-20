do 
    function CheckConsumptionChange()
		
        while true do
		
			local totalbr = 0
			local totaldps = 0
			local totalHp = 0
			local massCost = 0
			local energyCost = 0
			
			for index, unit in GetSelectedUnits() or {} do
			
				-- Energy and mass cost
				if not unit:IsInCategory('COMMAND') then
                    massCost = massCost + unit:GetBlueprint().Economy.BuildCostMass
                    energyCost = energyCost + unit:GetBlueprint().Economy.BuildCostEnergy
                end
				
				-- Build Rate
				local br = 0				
				if unit:IsInCategory('ENGINEER') then
					br = unit:GetBlueprint().Economy.BuildRate
				end
				if unit:IsInCategory('COMMAND') then
					br = unit:GetBuildRate()
				end
				
				-- DPS
				local weapons = unit:GetBlueprint().Weapon
				local dps = 0
				
				-- foreach weapons
				for i, weapon in weapons or {} do
					
					-- if unit is ACU
					if unit:IsInCategory('COMMAND') then
						dps = 100
					else
						local ppof = weapon.ProjectilesPerOnFire
						
						if ppof == nil then
							ppof = 1
						end
						
						local dmg = weapon.Damage
						
						if dmg == nil then
							dmg = 0
						elseif weapon.WeaponCategory == 'Death' then
							dmg = 0							
						end
													
						if weapon.RateOfFire ~= nil then
							dps = dps + (dmg * weapon.RateOfFire * ppof)	
						else
							dps = 0
						end
					end					
				end
				
				-- Total
				totalbr = totalbr + br
				totaldps = totaldps + dps
				totalHp = totalHp + unit:GetHealth()
            end
			
			-- Set texts
			buildRateLine:SetText(string.format('Total BP: %d', totalbr))
			dpsLine:SetText(string.format('Total DPS: %d', totaldps))
			hpLine:SetText(string.format('Total HP: %d', totalHp))
			massCostLine:SetText(string.format('Mass Cost: %d', massCost));
			energyCostLine:SetText(string.format('Energy Cost: %d', energyCost));
			
            WaitSeconds(0.1)
        end
    end
      
	function CreateUIFrame()
		
		local lightGreen = 'FFB8F400'
		local green = 'FF1DD300'
		local red = 'FFFF3100'
		local orange = 'FFF8C000'
		local yellow = 'FFFFFF00'
	
        --Setup reclaim window style frame
        statsForm = Bitmap(GetFrame(0))
        statsForm:SetTexture('/textures/ui/common/game/economic-overlay/econ_bmp_m.dds')
        statsForm.Depth:Set(99)
        statsForm.Height:Set(66)
        statsForm.Width:Set(110)
        statsForm:DisableHitTest(true)
        LayoutHelpers.AtLeftTopIn(statsForm, GetFrame(0), 520, 8)
        
        local titleLine = UIUtil.CreateText(statsForm, 'Selection Info', 10, UIUtil.bodyFont)
        LayoutHelpers.CenteredAbove(titleLine, statsForm, -12)
        titleLine:DisableHitTest(true)
        
        buildRateLine = UIUtil.CreateText(statsForm, '', 10, UIUtil.bodyFont)
        buildRateLine:SetColor(yellow)
        LayoutHelpers.AtLeftTopIn(buildRateLine, statsForm, 4, 10)
        buildRateLine:DisableHitTest(true)
        
		dpsLine = UIUtil.CreateText(statsForm, '', 10, UIUtil.bodyFont)
        dpsLine:SetColor(red)
        LayoutHelpers.AtLeftTopIn(dpsLine, statsForm, 4, 20)
        dpsLine:DisableHitTest(true)
		
		hpLine = UIUtil.CreateText(statsForm, '', 10, UIUtil.bodyFont)
        hpLine:SetColor(green)
        LayoutHelpers.AtLeftTopIn(hpLine, statsForm, 4, 30)
        hpLine:DisableHitTest(true)
		
		massCostLine = UIUtil.CreateText(statsForm, '', 10, UIUtil.bodyFont)
        massCostLine:SetColor(lightGreen)
        LayoutHelpers.AtLeftTopIn(massCostLine, statsForm, 4, 40)
        massCostLine:DisableHitTest(true)
		
		energyCostLine = UIUtil.CreateText(statsForm, '', 10, UIUtil.bodyFont)
        energyCostLine:SetColor(orange)
        LayoutHelpers.AtLeftTopIn(energyCostLine, statsForm, 4, 50)
        energyCostLine:DisableHitTest(true)
        
    end
    	  
    local OldCreateUI = CreateUI
    function CreateUI(isReplay)
        OldCreateUI(isReplay)
		CreateUIFrame()
        ForkThread(CheckConsumptionChange)
    end
end