local UIUtil = import('/lua/ui/uiutil.lua')
local LayoutHelpers = import('/lua/maui/layouthelpers.lua')
local Bitmap = import('/lua/maui/bitmap.lua').Bitmap
local GameMain = import('/lua/ui/game/gamemain.lua')
local Button = import('/lua/maui/button.lua').Button
local Checkbox = import('/lua/maui/checkbox.lua').Checkbox
local Dragger = import('/lua/maui/dragger.lua').Dragger
local StatusBar = import('/lua/maui/statusbar.lua').StatusBar
local Prefs = import('/lua/user/prefs.lua')--preferences
local IntegerSlider = import('/lua/maui/slider.lua').IntegerSlider
local ToolTip = import('/lua/ui/game/tooltip.lua')

local switchThread
local updateThread
local fabList = {}
local percentOnSlider = false
local totalFabs = false
local savedPrefs
local mouseover = false

-- If energy stored will last longer than OnTime seconds and energy storage ratio is greater than  then OnStorage then we try turning fabs on
-- If energy stored will last less than OffTime seconds or energy storage ratio is less than OffStorage then start turning fabs off
local OnTime = 30
local OffTime = 20
local OnStorage = 0.5
local OffStorage = 0.25

local HelpText = {
	OnTime = {
		Title = "On Time",
		Body = "If energy stored will last longer than OnTime seconds, and energy storage is over OnStorage% full then fabs will start turning on.",
	},
	OffTime = {
		Title = "Off Time",
		Body = "If energy stored will last less than OffTime seconds, then fabs will start turning off.",
	},
	OnStorage = {
		Title = "On Storage",
		Body = "If energy stored will last longer than OnTime seconds, and energy storage is over OnStorage% full then fabs will start turning on.",
	},
	OffStorage = {
		Title = "Off Storage",
		Body = "If energy stored is below OffStorage% then fabs will start turning off.",
	},
	AddBtn = {
		Title = "Add Fab",
		Body = "Sets currently selected fabricators to auto switch.",
	},
	RemoveBtn = {
		Title = "Remove Fab",
		Body = "Disables auto switching on currently selected fabricators.",
	},
	AddAllBtn = {
		Title = "Add All Fabs",
		Body = "Left Click: Sets all fabs to auto switch. Right Click: Automatically sets any new fabs to auto switch.",
	},
	OptionsBtn = {
		Title = "Options",
		Body = "Configure auto switching behaviour.",
	},
	Slider = {
		Title = "Fabs On",
		Body = "Shows what percentage of fabs are currently on.",
	},
	TotalFabs = {
		Title = "Total Fabs",
		Body = "Shows the total number of fabs being monitored.",
	},
}

function CreateToolTip(control, data, togglebutton)
	if not Prefs.GetOption('tooltips') then return end
	if mouseover then mouseover:Destroy() mouseover = false end
	local text = data.Title
	local body = data.Body
	mouseover = ToolTip.CreateExtendedToolTip(control, text, body)
	mouseover.Top:Set(function() return control.Top() + 2 end)
	mouseover.Left:Set(function() return control.Right() - 1 end)
	mouseover:SetAlpha(0, true)
	mouseover:SetNeedsFrameUpdate(true)
	
	local delayTime = 0.5
	local totaltime = 0
	mouseover.OnFrame = function(self, deltaTime)
		if totaltime > delayTime then
			local alpha = self:GetAlpha() + (deltaTime * 4)
			if alpha < 1 then
				self:SetAlpha(alpha, true)
			else
				self:SetAlpha(1, true)
				self:SetNeedsFrameUpdate(false)
			end
		end
		totaltime = totaltime + deltaTime
	end
end
		
function CloseToolTip()
	if mouseover then mouseover:Destroy() mouseover = false end
end

function Init()
	--get settings from prefs, create them if they don't exist
	local savedPrefs = Prefs.GetFromCurrentProfile("UIMassFabManager_settings")
	if not savedPrefs then
		savedPrefs = {
			Left = 100,
			Top = 100,
			OnTime = 30,
			OffTime = 20,
			OnStorage = 0.5,
			OffStorage = 0.25,
		}
		Prefs.SetToCurrentProfile("UIMassFabManager_settings", savedPrefs)
		Prefs.SavePreferences()
	else
		OnTime = savedPrefs.OnTime
		OffTime = savedPrefs.OffTime
		OnStorage = savedPrefs.OnStorage
		OffStorage = savedPrefs.OffStorage
	end
	
	--start the main management thread
	switchThread = ForkThread(SwitchFabs)

	--set up the interface
	MassFabSwitchContainer = Bitmap(GetFrame(0))
	MassFabSwitchContainer:SetTexture('/mods/uimassfabmanager/textures/panel.dds')
	MassFabSwitchContainer.Depth:Set(10000)
	if savedPrefs.Left < GetFrame(0).Right and savedPrefs.Top < GetFrame(0).Bottom then
		LayoutHelpers.AtLeftTopIn(MassFabSwitchContainer, GetFrame(0), savedPrefs.Left, savedPrefs.Top)
	else
		LayoutHelpers.AtLeftTopIn(MassFabSwitchContainer, GetFrame(0), savedPrefs.Left, savedPrefs.Top)
	end
	MassFabSwitchContainer.HandleEvent = function(self, event)
		if event.Type == 'ButtonPress' then
			local drag = Dragger()
			local offX = event.MouseX - self.Left()
			local offY = event.MouseY - self.Top()
			drag.OnMove = function(dragself, x, y)
				self.Left:Set(x - offX)
				self.Top:Set(y - offY)
				GetCursor():SetTexture(UIUtil.GetCursor('MOVE_WINDOW'))
			end
			drag.OnRelease = function(dragself)
				local tempPrefs = Prefs.GetFromCurrentProfile("UIMassFabManager_settings")
				tempPrefs.Left = self.Left()
				tempPrefs.Top = self.Top()
				Prefs.SetToCurrentProfile("UIMassFabManager_settings", tempPrefs)
				Prefs.SavePreferences()
				GetCursor():Reset()
				drag:Destroy()
			end
			PostDragger(self:GetRootFrame(), event.KeyCode, drag)
		elseif event.Type == 'MouseExit' then
			CloseToolTip()
		end
	end

    local AddFabButton = Button(MassFabSwitchContainer, '/mods/uimassfabmanager/textures/add_up.dds', '/mods/uimassfabmanager/textures/add_down.dds', '/mods/uimassfabmanager/textures/add_over.dds', '/mods/uimassfabmanager/textures/add_up.dds', "UI_Menu_MouseDown_Sml", "UI_Menu_MouseDown_Sml")
    LayoutHelpers.AtLeftTopIn(AddFabButton, MassFabSwitchContainer, 1, 13)
    local RemoveFabButton = Button(MassFabSwitchContainer, '/mods/uimassfabmanager/textures/remove_up.dds', '/mods/uimassfabmanager/textures/remove_down.dds', '/mods/uimassfabmanager/textures/remove_over.dds', '/mods/uimassfabmanager/textures/remove_up.dds', "UI_Menu_MouseDown_Sml", "UI_Menu_MouseDown_Sml")
    LayoutHelpers.AtLeftTopIn(RemoveFabButton, MassFabSwitchContainer, 19, 13)
    local AddAllFabsButton = Checkbox(MassFabSwitchContainer, '/mods/uimassfabmanager/textures/addall_up.dds', '/mods/uimassfabmanager/textures/addall_down.dds', '/mods/uimassfabmanager/textures/addall_over.dds', '/mods/uimassfabmanager/textures/addall_over.dds', '/mods/uimassfabmanager/textures/addall_up.dds', '/mods/uimassfabmanager/textures/addall_up.dds', "UI_Menu_MouseDown_Sml", "UI_Menu_MouseDown_Sml")
    LayoutHelpers.AtLeftTopIn(AddAllFabsButton, MassFabSwitchContainer, 1, 30)
    local OptionsButton = Button(MassFabSwitchContainer, '/mods/uimassfabmanager/textures/options_up.dds', '/mods/uimassfabmanager/textures/options_down.dds', '/mods/uimassfabmanager/textures/options_over.dds', '/mods/uimassfabmanager/textures/options_up.dds', "UI_Menu_MouseDown_Sml", "UI_Menu_MouseDown_Sml")
    LayoutHelpers.AtLeftTopIn(OptionsButton, MassFabSwitchContainer, 19, 30)

	
	AddFabButton.oldHandleEvent = AddFabButton.HandleEvent
	AddFabButton.HandleEvent = function(self, event)
		if event.Type == 'ButtonPress' then
			local selection = GetSelectedUnits() or {}
			for i, unit in selection do
				if unit:IsInCategory('MASSFABRICATION') and unit:IsInCategory('STRUCTURE') then
					fabList[unit:GetEntityId()] = unit
				end
			end
		elseif event.Type == 'MouseEnter' then
			CreateToolTip(MassFabSwitchContainer, {Title = HelpText.AddBtn.Title, Body = HelpText.AddBtn.Body})
		end
		AddFabButton.oldHandleEvent(self, event)
	end

	RemoveFabButton.oldHandleEvent = RemoveFabButton.HandleEvent
	RemoveFabButton.HandleEvent = function(self, event)
		if event.Type == 'ButtonPress' then
			local selection = GetSelectedUnits() or {}
			for i, unit in selection do
				if unit:IsInCategory('MASSFABRICATION') and unit:IsInCategory('STRUCTURE') then
					fabList[unit:GetEntityId()] = nil
				end
			end
		elseif event.Type == 'MouseEnter' then
			CreateToolTip(MassFabSwitchContainer, {Title = HelpText.RemoveBtn.Title, Body = HelpText.RemoveBtn.Body})
		end
		RemoveFabButton.oldHandleEvent(self, event)
	end
	
	AddAllFabsButton.OnClick = function(self) end
	AddAllFabsButton.oldHandleEvent = AddAllFabsButton.HandleEvent
	AddAllFabsButton.HandleEvent = function(self, event)
		if event.Type == 'ButtonPress' then
			if event.Modifiers.Left then
				local selection = GetSelectedUnits()
				local mflist = UISelectionByCategory("MASSFABRICATION * STRUCTURE", false, false, false, false)
				local mflist = GetSelectedUnits() or {}
				for i, unit in mflist do
					fabList[unit:GetEntityId()] = unit
				end
				SelectUnits(selection)
			else
				if self:IsChecked() then
					KillThread(updateThread)
					self:SetCheck(false)
				else
					updateThread = ForkThread(UpdateFabs)
					self:SetCheck(true)
				end
			end
		elseif event.Type == 'MouseEnter' then
			CreateToolTip(MassFabSwitchContainer, {Title = HelpText.AddAllBtn.Title, Body = HelpText.AddAllBtn.Body})
		end
		AddAllFabsButton.oldHandleEvent(self, event)
	end
	
	OptionsButton.oldHandleEvent = OptionsButton.HandleEvent
	OptionsButton.HandleEvent = function(self, event)
		if event.Type == 'ButtonPress' then
			OptionsPanel(MassFabSwitchContainer)
		elseif event.Type == 'MouseEnter' then
			CreateToolTip(MassFabSwitchContainer, {Title = HelpText.OptionsBtn.Title, Body = HelpText.OptionsBtn.Body})
		end
		OptionsButton.oldHandleEvent(self, event)
	end

	percentOnSlider = StatusBar(MassFabSwitchContainer, 0, 1, false, false, '/mods/uimassfabmanager/textures/slider_bg.dds', '/mods/uimassfabmanager/textures/slider_fg.dds', false)
    LayoutHelpers.AtLeftTopIn(percentOnSlider, MassFabSwitchContainer, 3, 3)
	percentOnSlider:SetMinimumSlidePercentage(4/29)
	percentOnSlider.oldHandleEvent = percentOnSlider.HandleEvent
	percentOnSlider.HandleEvent = function(self, event)
		if event.Type == 'MouseEnter' then
			CreateToolTip(MassFabSwitchContainer, {Title = HelpText.Slider.Title, Body = HelpText.Slider.Body})
		end
		percentOnSlider.oldHandleEvent(self, event)
	end
	
	totalFabs = UIUtil.CreateText(MassFabSwitchContainer, "0", 11, UIUtil.bodyFont)
	LayoutHelpers.AtLeftTopIn(totalFabs, MassFabSwitchContainer, 28, 1)
	totalFabs.HandleEvent = function(self, event)
		if event.Type == 'MouseEnter' then
			CreateToolTip(MassFabSwitchContainer, {Title = HelpText.TotalFabs.Title, Body = HelpText.TotalFabs.Body})
		end
	end

end

--panel for setting up prefs
function OptionsPanel(parent)
	local window = Bitmap(parent)
	window:SetTexture('/mods/uimassfabmanager/textures/configwindow.dds')
	LayoutHelpers.AtLeftTopIn(window, parent)
	window.Depth:Set(function() return parent.Depth() + 10 end)
	
	savedPrefs = Prefs.GetFromCurrentProfile("UIMassFabManager_settings")
	
	CreateOptionsSlider(window, "OnTime", 5, 6, 1)
	CreateOptionsSlider(window, "OffTime", 5, 29, 1)
	CreateOptionsSlider(window, "OnStorage", 5, 52, 100)
	CreateOptionsSlider(window, "OffStorage", 5, 75, 100)
	
	local okButton = UIUtil.CreateButtonStd(window, '/widgets/small', 'OK', 16)
	LayoutHelpers.AtLeftTopIn(okButton, window, 160, 103)
	okButton.OnClick = function(self)
		Prefs.SetToCurrentProfile("UIMassFabManager_settings", savedPrefs)
		Prefs.SavePreferences()
		window:Destroy()
	end
	
	local cancelButton = UIUtil.CreateButtonStd(window, '/widgets/small', 'Cancel', 16)
	LayoutHelpers.AtLeftTopIn(cancelButton, window, 8, 103)
	cancelButton.OnClick = function(self)
		window:Destroy()
	end
end

function CreateOptionsSlider(parent, option, left, top, dividefactor)
	local title = UIUtil.CreateText(parent, option, 14, UIUtil.titleFont)
	LayoutHelpers.AtLeftTopIn(title, parent, left, top)
	title.HandleEvent = function(self, event)
		if event.Type == 'MouseEnter' then
			CreateToolTip(parent, {Title = HelpText[option].Title, Body = HelpText[option].Body})
		end
	end
	local slider = IntegerSlider(parent, false, 0,100, 1, UIUtil.SkinnableFile('/slider02/slider_btn_up.dds'), UIUtil.SkinnableFile('/slider02/slider_btn_over.dds'), UIUtil.SkinnableFile('/slider02/slider_btn_down.dds'), UIUtil.SkinnableFile('/slider02/slider-back_bmp.dds'))  
	LayoutHelpers.AtLeftTopIn(slider, parent, left + 85, top)
	local value = UIUtil.CreateText(parent, "0", 14, UIUtil.bodyFont)
	LayoutHelpers.RightOf(value, slider)
	slider:SetValue(savedPrefs[option]*dividefactor)
	value:SetText(math.floor(savedPrefs[option]*dividefactor+0.5))
	slider.OnValueChanged = function(self, newValue)
		savedPrefs[option] = newValue/dividefactor
		value:SetText(newValue)
	end
end

--remove dead fabs from the list
function cleanFabList()
	for i, fab in fabList do
		if fab:IsDead() then
			fabList[i] = nil
		end
	end
end

--auto update the fab list
UpdateFabs = function()
	while true do
		local selection = GetSelectedUnits()
		if selection then
			WaitSeconds(0.3)
		else
			local mflist = UISelectionByCategory("MASSFABRICATION * STRUCTURE", false, false, false, false)
			local mflist = GetSelectedUnits() or {}
			for i, unit in mflist do
				fabList[unit:GetEntityId()] = unit
			end
			SelectUnits(selection)
			WaitSeconds(5)
		end
	end
end

SwitchFabs = function()
	while true do
		cleanFabList()
		if table.getsize(fabList) > 0 then
			local econData = GetEconomyTotals()
			local MassStorageRatio = econData['stored']['MASS']/econData['maxStorage']['MASS']
			local EnergyStorageRatio = econData['stored']['ENERGY']/econData['maxStorage']['ENERGY']
			local EnergyTrend = (econData['income']['ENERGY'] - econData['lastUseActual']['ENERGY'])*10
			local EnergyStored = econData['stored']['ENERGY']
			if MassStorageRatio == 1 then
				if EnergyTrend < 0 then
					for i, fab in fabList do
						if not GetScriptBit({fab}, 4) then
							local thisFabEnergyUse = 1500
							if fab:IsInCategory('TECH1') then
								thisFabEnergyUse = 40
							end
							if EnergyStored + ((EnergyTrend - thisFabEnergyUse) * OffTime) < 0 then
								ToggleScriptBit({fab}, 4, false)
								WaitSeconds(0.6)
								local econDataNew = GetEconomyTotals()
								local EnergyTrendNew = (econDataNew['income']['ENERGY'] - econDataNew['lastUseActual']['ENERGY'])*10
								local EnergyStoredNew = econDataNew['stored']['ENERGY']
								if EnergyTrendNew > 0 then
									break
								end
							end
						end
					end
				end
			else
				-- If energy stored will last longer than OnTime seconds and energy storage ratio is greater than  then OnStorage check if we can turn any fabs on
				if EnergyStored + (EnergyTrend * OnTime) > 0 and EnergyStorageRatio > OnStorage then
					for i, fab in fabList do
						if GetScriptBit({fab}, 4) then
							local thisFabEnergyUse = 1500
							if fab:IsInCategory('TECH1') then
								thisFabEnergyUse = 40
							end
							if EnergyStored + ((EnergyTrend - thisFabEnergyUse) * OnTime) > 0 then
								ToggleScriptBit({fab}, 4, true)
								WaitSeconds(0.6)
								local econDataNew = GetEconomyTotals()
								local EnergyTrendNew = (econDataNew['income']['ENERGY'] - econDataNew['lastUseActual']['ENERGY'])*10
								if EnergyTrendNew < 0 then
									break
								end
							end
						end
					end
				-- If energy stored will last less than 4 seconds or energy storage ratio is less than 0.1 then panic, turn all fabs off
				elseif EnergyStored + (EnergyTrend * 4) < 0 or EnergyStorageRatio < 0.1 then
					for i, fab in fabList do
						ToggleScriptBit({fab}, 4, false)
					end
				-- If energy stored will last less than OffTime seconds or energy storage ratio is less than OffStorage then start turning fabs off
				elseif EnergyStored + (EnergyTrend * OffTime) < 0 or EnergyStorageRatio < OffStorage then
					for i, fab in fabList do
						if not GetScriptBit({fab}, 4) then
							local thisFabEnergyUse = 1500
							if fab:IsInCategory('TECH1') then
								thisFabEnergyUse = 40
							end
							if EnergyStored + ((EnergyTrend - thisFabEnergyUse) * OffTime) < 0 then
								ToggleScriptBit({fab}, 4, false)
								WaitSeconds(0.6)
								local econDataNew = GetEconomyTotals()
								local EnergyTrendNew = (econDataNew['income']['ENERGY'] - econDataNew['lastUseActual']['ENERGY'])*10
								local EnergyStorageRationNew = econData['stored']['ENERGY']/econData['maxStorage']['ENERGY']
								if EnergyTrendNew > 0 then
									break
								elseif EnergyStorageRationNew < 0.05 then
									for i2, fab2 in fabList do
										ToggleScriptBit({fab2}, 4, false)
									end
									break
								end
							end
						end
					end
				end
			end
			--set the percentage of fabs on slider
			local totalOn = 0
			for i, fab in fabList do
				if not GetScriptBit({fab}, 4) then
					totalOn = totalOn + 1
				end
			end
			percentOnSlider:SetValue(totalOn/table.getsize(fabList))
		end
		totalFabs:SetText(table.getsize(fabList) or 0)
		WaitSeconds(2)
	end
end
