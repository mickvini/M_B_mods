do
    local GTEEOT = import('/lua/editor/EconomyBuildConditions.lua').GreaterThanEconEfficiencyOverTime
    local OldAIBrain = AIBrain

    AIBrain = Class(OldAIBrain) {
        OnCreateAI = function(self, planName)
            OldAIBrain.OnCreateAI(self, planName)
            ------------------------------------------------------------------------
            self.BrewRND = {
                Init = function(self)

                    --Init for AI research manager
                    if self.BrainType ~= 'Human' then
                        local f = self:GetFactionIndex()
                        local fname = {'UEF', 'Aeon', 'Cybran', 'Seraphim'}--[f]
                        fname = fname[f]

                        --Generate the full research lists
                        self.BrewRND.ResearchList = {}      --Populated with all research options for the faction now
                                                            --Looks like an array of id's
                                                            --Items are removed as they are finished.

                        self.BrewRND.CategoryResearch = {}  --Populated with all category research options now
                                                            --keyed with id's values are categories
                                                            --Items are removed as they are requested, or finished if they weren't requested.

                        for id, bp in __blueprints do
                            if bp.Categories then
                                if bp.General.FactionName == fname and table.find(bp.Categories, 'BUILTBYRESEARCH') and not table.find(self.BrewRND.ResearchList, bp.BlueprintId) then
                                    table.insert(self.BrewRND.ResearchList, bp.BlueprintId)
                                    if not __blueprints[bp.ResearchId] then
                                        self.BrewRND.CategoryResearch[bp.BlueprintId] = bp.ResearchId
                                    end
                                end
                            end
                        end

                        --Initialise the table to recieve requests.
                        self.BrewRND.ResearchRequests = {}  --Populated with research items as other managers need things.
                                                            --Looks like an array of id's
                                                            --Items are removed as they are finished.
                    end
                    --Housekeeping
                    self.BrewRND.Init = nil
                end,

                -- Is there anything left to research?
                IsResearchRemaining = function(self)
                    if self.BrewRND.ResearchList[1] then
                        return true
                    else
                        self.BrewResearchIsComplete = true
                        self.BrewRND = nil
                        return false
                    end
                end,

                --Check if we should research
                IsAbleToResearch = function(self)
                    return GTEEOT(self, 0.8, 1.2)
                end,

                --Return the first thing we can deal with from the requests list, or a random thing off the full list.
                    -- Research items self restrict, so there is no danger of repeat items.
                GetResearchItem = function(self, center)
                    --Check the requests list first for things they can currently do
                    if self.BrewRND.ResearchRequests[1] then
                        for i, id in self.BrewRND.ResearchRequests do
                            if __blueprints[id] and center:CanBuild(id) then
                                return self.BrewRND.ResearchRequests[i]
                            end
                        end
                    end

                    --Check the full list for anything they can currently do
                    local currentResearch = {}
                    for i, id in self.BrewRND.ResearchList do
                        if __blueprints[id] and center:CanBuild(id) then
                            table.insert(currentResearch, id)
                        end
                    end
                    --Return something at random from the current list.
                    local choice = currentResearch[math.random(1, table.getn(currentResearch))]

                    --LOG("AI starting research for " .. (__blueprints[choice].Description or choice or "unknown research item") .. ".")
                    return choice
                end,

                --Request something be researched. Must be valid for this faction, and not already researched.
                AddResearchRequest = function(self, item)
                    --if this request isn't already on the table, then...
                    local AddResearch = function(self, item)
                        if not table.find(self.BrewRND.ResearchRequests, item) and table.find(self.BrewRND.ResearchList, item) then
                            --LOG("AI research requesting " .. item)
                            table.insert(self.BrewRND.ResearchRequests, item)
                            return true
                        end
                    end

                    -- Try it as written
                    if not AddResearch(self, item) then
                        -- Try it as with rnd
                        if not AddResearch(self, item .. 'rnd') then
                            -- Try searching for a cat research
                            local bp = __blueprints[item]
                            if bp and bp.Categories then
                                for id, cat in self.BrewRND.CategoryResearch do
                                    if table.find(bp.Categories, cat) then
                                        if AddResearch(self, id) then
                                            --if this this works, nil the entry so we don't search for this cat research again.
                                            --The request wont go away until it's completed.
                                            self.BrewRND.CategoryResearch[id] = nil
                                        end
                                    end
                                end
                            end
                        end
                    end
                end,

                --Tell the manager it is done. This is called by the actual research item unit, and doesn't need calling elsewhere
                MarkResearchComplete = function(self, item)
                    for i, array in {self.BrewRND.ResearchList, self.BrewRND.ResearchRequests} do
                        local f = table.find(array, item)
                        if f then
                            table.remove(array, f)
                        end
                    end
                    self.BrewRND.CategoryResearch[item] = nil
                end,
            }
            ------------------------------------------------------------------------
            self.BrewRND.Init(self)
        end,

        CreateBrainShared = function(self, planName)
            OldAIBrain.CreateBrainShared(self, planName)
            --Init for pre-completed starting research
            --to match starting tech level research to starting units
            self:ForkThread(function(self)
                WaitTicks(3)
                local AIUtils = import('/lua/ai/aiutilities.lua')
                local pos = {ScenarioInfo.size[1]/2, 0, ScenarioInfo.size[2]/2}
                local radius = ScenarioInfo.size[1]

                --This section could be updated to use the self.BrewRND.CategoryResearch list

                -- variable for tracking max tech level owned
                local maxtech = 0
                --go through the categories in order to see if we have any.
                for i, cat in {categories.TECH1, categories.TECH2, categories.TECH3, categories.EXPERIMENTAL} do
                    --arbirary all-map pos, becaues I can't find a function that returns all a brains units.
                    if AIUtils.GetOwnUnitsAroundPoint( self, cat * (categories.ENGINEER + categories.FACTORY), pos, radius)[1] then
                        -- index == tech level
                        maxtech = math.max(maxtech, i)
                    end
                end

                --spawn all tech level research units of the faction, up to what we already have.
                if maxtech > 0 then
                    local factions = {'e','a','r','s'}
                    local f = factions[self:GetFactionIndex()]
                    for i = 1, maxtech do
                        CreateUnitHPR('s' .. f .. 'r9' .. i .. '00', self:GetArmyIndex(),0,0,0,0,0,0)
                    end
                end

                --If they have a specifically research locked unit already, unlock it. If anything, most likely prebuilt units are on, and they have a t1 pgen.
                for i, unit in AIUtils.GetOwnUnitsAroundPoint( self, categories.RESEARCHLOCKED, pos, radius) do
                    CreateUnitHPR(unit:GetBlueprint().BlueprintId .. 'rnd', self:GetArmyIndex(),0,0,0,0,0,0)
                end
            end)
        end,

    }
end

-- === M28AI hook merged (was separate M28AI mod; paths rewritten in Phase 2) ===
local M28Overseer = import('/mods/M&B/lua/AI/M28Overseer.lua')
local M28Utilities = import('/mods/M&B/lua/AI/M28Utilities.lua')
local M28Map = import('/mods/M&B/lua/AI/M28Map.lua')
local M28Profiler = import('/mods/M&B/lua/AI/M28Profiler.lua')
local M28Config = import('/mods/M&B/lua/M28Config.lua')
local M28Events = import('/mods/M&B/lua/AI/M28Events.lua')

--Note - looks like this logic may be moved to lua\aibrains\base-ai.lua at some point based on FAF develop (as at May 2023)
--In theory the below shouldt be needed once the FAF-Develop changes are integrated into FAF (expected June 2023), although probably no harm leaving for backwards compatibility
--Superceded from the June 2023 changes by M28Brain.lua and index.lua
    --V24 - removed the below as couldn't get the new appraoch (which requires map to be generated later than OnCreateAI triggers) to work with this code still here

M28AIBrainClass = AIBrain
AIBrain = Class(M28AIBrainClass) {

    OnDefeat = function(self)
        M28AIBrainClass.OnDefeat(self)
        if M28Utilities.bSteamActive then
            ForkThread(M28Events.OnPlayerDefeated, self)
        end
    end,

    OnCreateAI = function(self, planName)
        if M28Utilities.bSteamActive then
            local M28Conditions = import('/mods/M&B/lua/AI/M28Conditions.lua')
            --Apply M28 to any m28* personality (the M&B lobby only offers M28 variants), plus easy/normal as a fallback (e.g. campaign forces them)
            LOG('Brain OnCreateAI for brain'..self.Nickname..' with personality '..(self.Personality or ScenarioInfo.ArmySetup[self.Name].AIPersonality or 'nil'))
            local sPersonality = self.Personality or ScenarioInfo.ArmySetup[self.Name].AIPersonality
            if not(M28Conditions.IsCivilianBrain(self)) and (string.sub(sPersonality, 1, 3) == 'm28' or sPersonality == 'easy' or sPersonality == 'medium') then
                self.M28AI = true
                if sPersonality == 'easy' then self.M28Easy = true end
                M28Utilities.bM28AIInGame = true
                ForkThread(M28Events.OnCreateBrain, self, planName, false)--]]
                --M&B: role-balanced army roster thread. Forked here (unconditionally for m28 brains) because NewAIBrain.OnCreateAI in M28Brain.lua doesn't fire in this Steam/M&B setup; the thread waits then self-gates on IsMBModActive so __blueprints is populated before the M&B check.
                ForkThread(import('/mods/M&B/lua/AI/M28Factory.lua').MBRosterThread, self)
                --M&B: multi-group attack doctrine manager (strike force ~30 -> enemy base; raid parties ~10 -> enemy mexes; adaptive x2 sizing on failure; experimentals escorted with the strike wave). Self-gates on IsMBModActive; waits for team/map data inside the thread.
                ForkThread(import('/mods/M&B/lua/AI/MNBBattlegroups.lua').ManageBattlegroups, self)
                --M&B: mass kickstart is now EVENT-DRIVEN instead of the old flat 3000-at-GT120 (which didnt fit all maps): 2000 when the bot starts its first ACU upgrade (M28ACU.lua GetACUUpgradeWanted M&B return), and 2000/3000/5000 when it completes study 9200/9300/9400 (defaultunits.lua OnStopBeingBuilt). Granted in those event handlers, not here.
            else
                M28AIBrainClass.OnCreateAI(self, planName)
                ForkThread(M28Overseer.ConsiderSteamMessageIfNoM28)
            end
        else
            M28AIBrainClass.OnCreateAI(self, planName)
        end
        --[[if (ScenarioInfo.ArmySetup[self.Name].AIPersonality == 'm28ai' or ScenarioInfo.ArmySetup[self.Name].AIPersonality == 'm28aicheat') then
            self.M28AI = true
            M28Utilities.bM28AIInGame = true
        end
        if not(self.M28AI) then
            LOG('Running normal aiBrain creation code for brain '..(self.Nickname or 'nil'))
            M28AIBrainClass.OnCreateAI(self, planName)
        end
        ForkThread(M28Events.OnCreateBrain, self, planName, false)--]]
    end,

    --[[OnBeginSession = function(self)
        M28AIBrainClass.OnBeginSession(self)
        M28Overseer.bBeginSessionTriggered = true
        import("/lua/sim/NavUtils.lua").Generate()
    end,--]]

    OnCreateHuman = function(self, planName)
        M28AIBrainClass.OnCreateHuman(self, planName)
        if M28Utilities.bSteamActive then
            ForkThread(M28Events.OnCreateBrain, self, planName, true)
        end
    end,

    --Redundancy - make sure base AI doesnt run for M28AI
    InitializeSkirmishSystems = function(self)
        if self.M28AI then
            --Do nothing
            LOG('BaseAIHook - M28AI InitializeSkirmishSystems disabled')
        else
            --LOG('BaseAIHook - InitializeSkirmishSystems, self='..(self.Nickname or 'nil'))
            M28AIBrainClass.InitializeSkirmishSystems(self)
        end
    end,
    InitializeAttackManager = function(self, attackDataTable)
        if self.M28AI then
            --Do nothing
            LOG('BaseAIHook - M28AI InitializeAttackManager disabled')
        else
            --LOG('BaseAIHook - InitializeAttackManager, ai='..(self.Nickname or 'nil'))
            M28AIBrainClass.InitializeAttackManager(self, attackDataTable)
        end
    end,
    InitializePlatoonBuildManager = function(self)
        if self.M28AI then
            --Do nothing
            LOG('BaseAIHook - M28AI InitializePlatoonBuildManager disabled')
        else
            --LOG('BaseAIHook - InitializePlatoonBuildManager, ai='..(self.Nickname or 'nil'))
            M28AIBrainClass.InitializePlatoonBuildManager(self)
        end
    end,
    BaseMonitorInitialization = function(self, spec)
        if self.M28AI then
            --Do nothing
            LOG('BaseAIHook - M28AI BaseMonitorInitialization disabled')
        else
            --LOG('BaseAIHook - BaseMonitorInitialization, ai='..(self.Nickname or 'nil'))
            M28AIBrainClass.BaseMonitorInitialization(self, spec)
        end
    end,
    BaseMonitorInitializationSorian = function(self, spec)
        if self.M28AI then
            --Do nothing
            LOG('BaseAIHook - M28AI BaseMonitorInitializationSorian disabled')
        else
            --LOG('BaseAIHook - BaseMonitorInitializationSorian, ai='..(self.Nickname or 'nil'))
            M28AIBrainClass.BaseMonitorInitializationSorian(self, spec)
        end
    end,
}