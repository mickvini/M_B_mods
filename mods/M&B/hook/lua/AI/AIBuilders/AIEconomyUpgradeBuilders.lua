#***************************************************************************
#*
#**  File     :  /lua/ai/AIEconomyUpgradeBuilders.lua
#**
#**  Summary  : Default economic builders for skirmish
#**
#**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local BBTmplFile = '/lua/basetemplates.lua'
local BuildingTmpl = 'BuildingTemplates'
local BaseTmpl = 'BaseTemplates'
local ExBaseTmpl = 'ExpansionBaseTemplates'
local Adj2x2Tmpl = 'Adjacency2x2'
local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local MIBC = '/lua/editor/MiscBuildConditions.lua'
local MABC = '/lua/editor/MarkerBuildConditions.lua'
local IBC = '/lua/editor/InstantBuildConditions.lua'
local OAUBC = '/lua/editor/OtherArmyUnitCountBuildConditions.lua'
local EBC = '/lua/editor/EconomyBuildConditions.lua'
local PCBC = '/lua/editor/PlatoonCountBuildConditions.lua'
local SAI = '/lua/ScenarioPlatoonAI.lua'
local TBC = '/lua/editor/ThreatBuildConditions.lua'
local PlatoonFile = '/lua/platoon.lua'

BuilderGroup {
    BuilderGroupName = 'ExtractorUpgrades',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'T1 Mass Extractor Upgrade',
        PlatoonTemplate = 'T1MassExtractorUpgrade',
        InstanceCount = 1,
        Priority = 1000,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconIncome',  { 2.4, 20}},
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            { MIBC, 'GreaterThanGameTime', { 480 } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'MASSEXTRACTION TECH2', 'MASSEXTRACTION' } },
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },

		# In case economy becomes locked under the normal income required
		# look and see if there is enough mass stored to push through the upgrade
    Builder {
        BuilderName = 'T1 Mass Extractor Upgrade Time Limit Based',
        PlatoonTemplate = 'T1MassExtractorUpgrade',
        InstanceCount = 1,
        Priority = 1000,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { MIBC, 'GreaterThanGameTime', { 540 } },
            { EBC, 'GreaterThanEconStorageCurrent', { 600, 0 } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'MASSEXTRACTION TECH2', 'MASSEXTRACTION' } },
            
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },

    #Builder {
    #    BuilderName = 'T1 Mass Extractor Upgrade Time Limit Based',
    #    PlatoonTemplate = 'T1MassExtractorUpgrade',
    #    InstanceCount = 1,
    #    Priority = 1000,
    #    BuilderConditions = {
    #        { IBC, 'BrainNotLowPowerMode', {} },
    #        { EBC, 'GreaterThanEconIncome',  { 5, 20}},
    #        { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},                        
    #        
    #    },
    #    FormRadius = 10000,
    #    BuilderType = 'Any',
    #},    
    Builder {
        BuilderName = 'T2 Mass Extractor Upgrade',
        PlatoonTemplate = 'T2MassExtractorUpgrade',
        Priority = 1000,
        BuilderConditions = {
            #{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH2, ENERGYPRODUCTION TECH3' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'MASSEXTRACTION TECH3', 'MASSEXTRACTION' } },            
            { EBC, 'GreaterThanEconIncome', { 7, 50 } },
            { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 5, 'MASSEXTRACTION TECH2', 'MASSEXTRACTION' }},
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },   
}

BuilderGroup {
    BuilderGroupName = 'Time Exempt Extractor Upgrades Expansion',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'T1 Mass Extractor Upgrade Timeless Single Expansion',
        PlatoonTemplate = 'T1MassExtractorUpgrade',
        InstanceCount = 2,
        Priority = 1000,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconIncome',  { 3.5, 10}},
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.6, 1.2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 2, 'MASSEXTRACTION TECH2', 'MASSEXTRACTION' } },
            { UCBC, 'UnitsGreaterAtLocation', { 'MAIN', 3, 'MASSEXTRACTION TECH2', 'MASSEXTRACTION' } },
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'T2 Mass Extractor Upgrade Timeless Single Expansion',
        PlatoonTemplate = 'T2MassExtractorUpgrade',
        InstanceCount = 2,
        Priority = 1000,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconIncome',  { 20, 10}},
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.6, 1.2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 2, 'MASSEXTRACTION TECH2', 'MASSEXTRACTION' } },
            { UCBC, 'UnitsGreaterAtLocation', { 'MAIN', 3, 'MASSEXTRACTION TECH3', 'MASSEXTRACTION' } },
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },    
    Builder {
        BuilderName = 'T2 Mass Extractor Upgrade Timeless Multiple Expansion',
        PlatoonTemplate = 'T2MassExtractorUpgrade',
        InstanceCount = 4,
        Priority = 1000,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconIncome',  { 35, 10}},
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.6, 1.2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 3, 'MASSEXTRACTION TECH2', 'MASSEXTRACTION' } },
            { UCBC, 'UnitsGreaterAtLocation', { 'MAIN', 3, 'MASSEXTRACTION TECH3', 'MASSEXTRACTION' } },
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },       
}
   
BuilderGroup {
    BuilderGroupName = 'Time Exempt Extractor Upgrades',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'T1 Mass Extractor Upgrade Timeless Single',
        PlatoonTemplate = 'T1MassExtractorUpgrade',
        InstanceCount = 1,
        Priority = 1000,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconIncome',  { 2.2, 10}},
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.6, 1.2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'MASSEXTRACTION TECH2', 'MASSEXTRACTION' } },
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },

    Builder {
        BuilderName = 'T1 Mass Extractor Upgrade Timeless Two',
        PlatoonTemplate = 'T1MassExtractorUpgrade',
        InstanceCount = 2,
        Priority = 1000,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconIncome',  { 6, 10}},
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.6, 1.2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 2, 'MASSEXTRACTION TECH2', 'MASSEXTRACTION' } },
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },

    Builder {
        BuilderName = 'T1 Mass Extractor Upgrade Timeless LOTS',
        PlatoonTemplate = 'T1MassExtractorUpgrade',
        InstanceCount = 4,
        Priority = 1000,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconIncome',  { 15, 10}},
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.6, 1.2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 4, 'MASSEXTRACTION TECH2', 'MASSEXTRACTION' } },
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },    
    Builder {
        BuilderName = 'T2 Mass Extractor Upgrade Timeless',
        PlatoonTemplate = 'T2MassExtractorUpgrade',
        Priority = 1000,
        InstanceCount = 1,
        BuilderConditions = {
            #{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH2, ENERGYPRODUCTION TECH3' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'MASSEXTRACTION TECH3', 'MASSEXTRACTION' } },            
            { EBC, 'GreaterThanEconIncome', { 13, 50 } },
            { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            #{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 5, 'MASSEXTRACTION TECH2', 'MASSEXTRACTION' }},
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },  
    
    Builder {
        BuilderName = 'T2 Mass Extractor Upgrade Timeless Multiple',
        PlatoonTemplate = 'T2MassExtractorUpgrade',
        Priority = 1000,
        InstanceCount = 3,
        BuilderConditions = {
            #{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH2, ENERGYPRODUCTION TECH3' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 3, 'MASSEXTRACTION TECH3', 'MASSEXTRACTION' } },            
            { EBC, 'GreaterThanEconIncome', { 20, 50 } },
            { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},            
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },      
}

BuilderGroup {
    BuilderGroupName = 'SpeedExtractorUpgrades',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'T1 Mass Extractor Upgrade Speed',
        PlatoonTemplate = 'T1MassExtractorUpgrade',
        InstanceCount = 1,
        Priority = 800,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconIncome',  { 2.0, 20}},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 2, 'MASSEXTRACTION TECH2', 'MASSEXTRACTION' } },
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'T1 Mass Extractor Upgrade 2 Speed',
        PlatoonTemplate = 'T1MassExtractorUpgrade',
        InstanceCount = 1,
        Priority = 800,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 5, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3' }},
            { EBC, 'GreaterThanEconIncome',  { 4.0, 35}},
            { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 2, 'MASSEXTRACTION TECH2', 'MASSEXTRACTION' } },
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },

    Builder {
        BuilderName = 'T2 Mass Extractor Upgrade Speed',
        PlatoonTemplate = 'T2MassExtractorUpgrade',
        Priority = 800,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH2, ENERGYPRODUCTION TECH3' } },
            { EBC, 'GreaterThanEconIncome', { 6.0, 95 } },
            { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 2, 'MASSEXTRACTION TECH3', 'MASSEXTRACTION' } },
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'T2 Mass Extractor Upgrade 2 Speed',
        PlatoonTemplate = 'T2MassExtractorUpgrade',
        Priority = 800,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 5, 'MASSEXTRACTION TECH3' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH2, ENERGYPRODUCTION TECH3' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 2, 'MASSEXTRACTION TECH3', 'MASSEXTRACTION' } },
            { EBC, 'GreaterThanEconIncome', { 9.0, 120 } },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },
}

# ================================= #
#     BALANCED FACTORY UPGRADES
# ================================= #
BuilderGroup {
    BuilderGroupName = 'T1BalancedUpgradeBuilders',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'Balanced T1 Land Factory Upgrade Initial',
        PlatoonTemplate = 'T1LandFactoryUpgrade',
        Priority = 500,
        InstanceCount = 1,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1, 'FACTORY TECH2, FACTORY TECH3'}},
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY TECH2, FACTORY TECH3' } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH2, FACTORY TECH3' } },		            
                #{ EBC, 'GreaterThanEconIncome',  { 2.4, 50}},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'BalancedT1AirFactoryUpgradeInitial',
        PlatoonTemplate = 'T1AirFactoryUpgrade',
        Priority = 400,
        InstanceCount = 1,
        FormDebugFunction = nil,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1, 'FACTORY TECH2, FACTORY TECH3'}},
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY TECH2, FACTORY TECH3' } },
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH2, FACTORY TECH3' } },
                { EBC, 'GreaterThanEconIncome',  { 3.5, 75}},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'Balanced T1 Land Factory Upgrade',
        PlatoonTemplate = 'T1LandFactoryUpgrade',
        Priority = 400,
        InstanceCount = 1,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY TECH3, FACTORY TECH2' } },
                #{ UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 1, 'FACTORY LAND' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 7, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH2, FACTORY TECH3' } },
                #{ EBC, 'GreaterThanEconIncome',  { 4.0, 75}},
                #{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 1.4} },
                { IBC, 'BrainNotLowPowerMode', {} },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'BalancedT1AirFactoryUpgrade',
        PlatoonTemplate = 'T1AirFactoryUpgrade',
        Priority = 400,
        InstanceCount = 1,
        FormDebugFunction = nil,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY TECH3, FACTORY TECH2' } },
                { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 1, 'FACTORY AIR' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH2, FACTORY TECH3' } },
                { EBC, 'GreaterThanEconIncome',  { 3.5, 75}},
                { IBC, 'BrainNotLowPowerMode', {} },
                { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 1.4} },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'Balanced T1 Sea Factory Upgrade',
        PlatoonTemplate = 'T1SeaFactoryUpgrade',
        Priority = 400,
        InstanceCount = 1,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY TECH3, FACTORY TECH2' } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 1, 'NAVAL' } },
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH3, FACTORY TECH2' } },
                { EBC, 'GreaterThanEconIncome',  { 4.5, 80}},
                { IBC, 'BrainNotLowPowerMode', {} },
                { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 1.4} },
            },
        BuilderType = 'Any',
    },
}

BuilderGroup {
    BuilderGroupName = 'T2BalancedUpgradeBuilders',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'Balanced T2 Land Factory Upgrade',
        PlatoonTemplate = 'T2LandFactoryUpgrade',
        Priority = 600,
        InstanceCount = 1,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY TECH3, FACTORY TECH2' } },
                #{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'MASSEXTRACTION TECH3'}},
                { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 2, 'FACTORY TECH3, FACTORY TECH2' } },
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH3' } },
                { UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 7, 'MOBILE LAND'}},
                { EBC, 'GreaterThanEconIncome',  { 6.0, 180}},
                { IBC, 'BrainNotLowPowerMode', {} },
                #{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'Balanced T2 Air Factory Upgrade',
        PlatoonTemplate = 'T2AirFactoryUpgrade',
        Priority = 600,
        InstanceCount = 1,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY TECH3, FACTORY TECH2' } },
                { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 2, 'FACTORY TECH3, FACTORY TECH2' } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'MASSEXTRACTION TECH3'} },
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH3' } },
                { EBC, 'GreaterThanEconIncome',  { 7.0, 180}},
                { IBC, 'BrainNotLowPowerMode', {} },
                { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 1.2 }},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'Balanced T2 Sea Factory Upgrade',
        PlatoonTemplate = 'T2SeaFactoryUpgrade',
        Priority = 600,
        InstanceCount = 1,
        BuilderConditions = {
                { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 2, 'FACTORY TECH3, FACTORY TECH2' } },
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY TECH3, FACTORY TECH2' } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, 'MASSEXTRACTION TECH3'} },
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH3' } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'MASSEXTRACTION TECH3'} },
                { EBC, 'GreaterThanEconIncome',  { 11.0, 300}},
                { IBC, 'BrainNotLowPowerMode', {} },
                { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            },
        BuilderType = 'Any',
    },
}

# ============================================ #
#     BALANCED FACTORY UPGRADES EXPANSIONS
# ============================================ #
BuilderGroup {
    BuilderGroupName = 'T1BalancedUpgradeBuildersExpansion',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'Balanced T1 Land Factory Upgrade Expansion',
        PlatoonTemplate = 'T1LandFactoryUpgrade',
        Priority = 400,
        InstanceCount = 1,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY TECH3, FACTORY TECH2' } },
                { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 1, 'FACTORY LAND' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'FACTORY TECH2'}},
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH2, FACTORY TECH3' } },
                { EBC, 'GreaterThanEconIncome',  { 6.0, 75}},
                { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 1.4} },
                { IBC, 'BrainNotLowPowerMode', {} },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY TECH2'}},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'BalancedT1AirFactoryUpgrade Expansion',
        PlatoonTemplate = 'T1AirFactoryUpgrade',
        Priority = 400,
        InstanceCount = 1,
        FormDebugFunction = nil,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY TECH3, FACTORY TECH2' } },
                { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 1, 'FACTORY AIR' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH2, FACTORY TECH3' } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'FACTORY TECH2'}},
                { EBC, 'GreaterThanEconIncome',  { 5.5, 75}},
                { IBC, 'BrainNotLowPowerMode', {} },
                { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 1.4} },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY TECH2'}},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'Balanced T1 Sea Factory Upgrade Expansion',
        PlatoonTemplate = 'T1SeaFactoryUpgrade',
        Priority = 400,
        InstanceCount = 1,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY TECH3, FACTORY TECH2' } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 1, 'NAVAL' } },
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH3, FACTORY TECH2' } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'FACTORY TECH2'}},
                { EBC, 'GreaterThanEconIncome',  { 6.5, 80}},
                { IBC, 'BrainNotLowPowerMode', {} },
                { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 1.4} },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY TECH2'}},
            },
        BuilderType = 'Any',
    },
}

BuilderGroup {
    BuilderGroupName = 'T2BalancedUpgradeBuildersExpansion',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'Balanced T2 Land Factory Upgrade Expansion',
        PlatoonTemplate = 'T2LandFactoryUpgrade',
        Priority = 500,
        InstanceCount = 1,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY TECH3, FACTORY TECH2' } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'FACTORY TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'MASSEXTRACTION TECH3'}},
                { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, 'FACTORY TECH2 LAND' }},
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH3, FACTORY TECH2' } },
                { UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 7, 'MOBILE LAND'}},
                { EBC, 'GreaterThanEconIncome',  { 11.0, 180}},
                { IBC, 'BrainNotLowPowerMode', {} },
                { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.3} },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'Balanced T2 Air Factory Upgrade Expansion',
        PlatoonTemplate = 'T2AirFactoryUpgrade',
        Priority = 500,
        InstanceCount = 1,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY TECH3, FACTORY TECH2' } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'FACTORY TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'MASSEXTRACTION TECH3'}},
                { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, 'FACTORY TECH2 AIR' }},
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH3, FACTORY TECH2' } },
                { EBC, 'GreaterThanEconIncome',  { 11.0, 180}},
                { IBC, 'BrainNotLowPowerMode', {} },
                { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.3} },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'Balanced T2 Sea Factory Upgrade Expansion',
        PlatoonTemplate = 'T2SeaFactoryUpgrade',
        Priority = 500,
        InstanceCount = 1,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY TECH3, FACTORY TECH2' } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'FACTORY TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'MASSEXTRACTION TECH3'}},
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH3, FACTORY TECH2' } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'MASSEXTRACTION TECH3'}},
                { EBC, 'GreaterThanEconIncome',  { 11.0, 300}},
                { IBC, 'BrainNotLowPowerMode', {} },
                { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.3} },
            },
        BuilderType = 'Any',
    },
}

# ====================== #
#     SPEED UPGRADES     #
# ====================== #
BuilderGroup {
    BuilderGroupName = 'T1SpeedUpgradeBuilders',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'T1 Land Factory Upgrade Speed',
        PlatoonTemplate = 'T1LandFactoryUpgrade',
        Priority = 400,
        InstanceCount = 1,
        BuilderConditions = {
                { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 1, 'FACTORY' } },
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY TECH3, FACTORY TECH2' } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                #{ UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH3, FACTORY TECH2' } },
                #{ EBC, 'GreaterThanEconIncome',  { 3.5, 50}},
                { IBC, 'BrainNotLowPowerMode', {} },
                #{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
                #{ EBC, 'MassIncomeToUnitRatio', { 7, '>=', 'FACTORY TECH1 STRUCTURE' } },
                #{ EBC, 'MassIncomeToUnitRatio', { 14, '>=', 'FACTORY TECH2 STRUCTURE' } },
                #{ EBC, 'MassIncomeToUnitRatio', { 19, '>=', 'FACTORY TECH3 STRUCTURE' } },
                { EBC, 'GreaterThanMassIncomeToFactory', { 6, 15, 22.5 } },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'T1AirFactoryUpgrade Speed',
        PlatoonTemplate = 'T1AirFactoryUpgrade',
        Priority = 400,
        InstanceCount = 1,
        FormDebugFunction = nil,
        BuilderConditions = {
                { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 1, 'FACTORY' } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY TECH3, FACTORY TECH2' } },
                #{ UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH3, FACTORY TECH2' } },
                { EBC, 'GreaterThanEconIncome',  { 3.0, 50}},
                { IBC, 'BrainNotLowPowerMode', {} },
                { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            { EBC, 'MassIncomeToUnitRatio', { 7, '>=', 'FACTORY TECH1 STRUCTURE' } },
            { EBC, 'MassIncomeToUnitRatio', { 14, '>=', 'FACTORY TECH2 STRUCTURE' } },
            { EBC, 'MassIncomeToUnitRatio', { 19, '>=', 'FACTORY TECH3 STRUCTURE' } },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'T1 Sea Factory Upgrade Speed',
        PlatoonTemplate = 'T1SeaFactoryUpgrade',
        Priority = 400,
        InstanceCount = 1,
        BuilderConditions = {
                { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, 'FACTORY TECH1 NAVAL' }},
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY TECH3, FACTORY TECH2' } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                #{ UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH3, FACTORY TECH2' } },
                { EBC, 'GreaterThanEconIncome',  { 4.5, 50}},
                { IBC, 'BrainNotLowPowerMode', {} },
                { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            { EBC, 'MassIncomeToUnitRatio', { 7, '>=', 'FACTORY TECH1 STRUCTURE' } },
            { EBC, 'MassIncomeToUnitRatio', { 14, '>=', 'FACTORY TECH2 STRUCTURE' } },
            { EBC, 'MassIncomeToUnitRatio', { 19, '>=', 'FACTORY TECH3 STRUCTURE' } },
            },
        BuilderType = 'Any',
    },
 }
 
BuilderGroup {
    BuilderGroupName = 'T2SpeedUpgradeBuilders',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'T2 Land Factory Upgrade Speed',
        PlatoonTemplate = 'T2LandFactoryUpgrade',
        Priority = 500,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY TECH3' } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'MASSEXTRACTION TECH3'}},
                { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 1, 'FACTORY' } },
                { UCBC, 'EngineerGreaterAtLocation', { 'LocationType', 3, 'ENGINEER TECH2' } },
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH3, FACTORY TECH2' } },
                { EBC, 'GreaterThanEconIncome',  { 6.0, 120}},
                { IBC, 'BrainNotLowPowerMode', {} },
                { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            { EBC, 'MassIncomeToUnitRatio', { 7, '>=', 'FACTORY TECH1 STRUCTURE' } },
            { EBC, 'MassIncomeToUnitRatio', { 14, '>=', 'FACTORY TECH2 STRUCTURE' } },
            { EBC, 'MassIncomeToUnitRatio', { 19, '>=', 'FACTORY TECH3 STRUCTURE' } },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'T2 Air Factory Upgrade Speed',
        PlatoonTemplate = 'T2AirFactoryUpgrade',
        Priority = 500,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY TECH3' } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'MASSEXTRACTION TECH3'}},
                { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 1, 'FACTORY' } },
                { UCBC, 'EngineerGreaterAtLocation', { 'LocationType', 3, 'ENGINEER TECH2' } },
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH3, FACTORY TECH2' } },
                { EBC, 'GreaterThanEconIncome',  { 6.0, 120}},
                { IBC, 'BrainNotLowPowerMode', {} },
                { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            { EBC, 'MassIncomeToUnitRatio', { 7, '>=', 'FACTORY TECH1 STRUCTURE' } },
            { EBC, 'MassIncomeToUnitRatio', { 14, '>=', 'FACTORY TECH2 STRUCTURE' } },
            { EBC, 'MassIncomeToUnitRatio', { 19, '>=', 'FACTORY TECH3 STRUCTURE' } },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'T2 Sea Factory Upgrade Speed',
        PlatoonTemplate = 'T2SeaFactoryUpgrade',
        Priority = 500,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY TECH3' } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'MASSEXTRACTION TECH3'}},
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH3, FACTORY TECH2' } },
                { EBC, 'GreaterThanEconIncome',  { 7.0, 150}},
                { IBC, 'BrainNotLowPowerMode', {} },
                { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            { EBC, 'MassIncomeToUnitRatio', { 7, '>=', 'FACTORY TECH1 STRUCTURE' } },
            { EBC, 'MassIncomeToUnitRatio', { 14, '>=', 'FACTORY TECH2 STRUCTURE' } },
            { EBC, 'MassIncomeToUnitRatio', { 19, '>=', 'FACTORY TECH3 STRUCTURE' } },
            },
        BuilderType = 'Any',
    },
}


# ================================= #
#     SPEED UPGRADES EXPANSIONS     #
# ================================= #
BuilderGroup {
    BuilderGroupName = 'T1SpeedUpgradeBuildersExpansions',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'T1 Land Factory Upgrade Speed Expansions',
        PlatoonTemplate = 'T1LandFactoryUpgrade',
        Priority = 400,
        InstanceCount = 1,
        BuilderConditions = {
                { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 1, 'FACTORY' } },
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY TECH3, FACTORY TECH2' } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY TECH3'}},
                #{ UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH3, FACTORY TECH2' } },
                #{ EBC, 'GreaterThanEconIncome',  { 3.5, 50}},
                { IBC, 'BrainNotLowPowerMode', {} },
                #{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'T1AirFactoryUpgrade Speed Expansions',
        PlatoonTemplate = 'T1AirFactoryUpgrade',
        Priority = 400,
        InstanceCount = 1,
        FormDebugFunction = nil,
        BuilderConditions = {
                { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 1, 'FACTORY' } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY TECH3, FACTORY TECH2' } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY TECH3'}},
                #{ UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH3, FACTORY TECH2' } },
                { EBC, 'GreaterThanEconIncome',  { 3.0, 50}},
                { IBC, 'BrainNotLowPowerMode', {} },
                { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'T1 Sea Factory Upgrade Speed Expansions',
        PlatoonTemplate = 'T1SeaFactoryUpgrade',
        Priority = 400,
        InstanceCount = 1,
        BuilderConditions = {
                { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, 'FACTORY TECH1 NAVAL' }},
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY TECH3, FACTORY TECH2' } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY TECH2, FACTORY TECH3'}},
                #{ UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH3, FACTORY TECH2' } },
                { EBC, 'GreaterThanEconIncome',  { 4.5, 50}},
                { IBC, 'BrainNotLowPowerMode', {} },
                { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            },
        BuilderType = 'Any',
    },
 }
 
BuilderGroup {
    BuilderGroupName = 'T2SpeedUpgradeBuildersExpansions',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'T2 Land Factory Upgrade Speed Expansions',
        PlatoonTemplate = 'T2LandFactoryUpgrade',
        Priority = 400,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY TECH3, FACTORY TECH2' } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'MASSEXTRACTION TECH3'}},
                { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 1, 'FACTORY' } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY TECH3'}},
                { UCBC, 'EngineerGreaterAtLocation', { 'LocationType', 3, 'ENGINEER TECH2' } },
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH3, FACTORY TECH2' } },
                { EBC, 'GreaterThanEconIncome',  { 6.0, 120}},
                { IBC, 'BrainNotLowPowerMode', {} },
                { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'T2 Air Factory Upgrade Speed Expansions',
        PlatoonTemplate = 'T2AirFactoryUpgrade',
        Priority = 400,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY TECH3, FACTORY TECH2' } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'MASSEXTRACTION TECH3'}},
                { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 1, 'FACTORY' } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY TECH3'}},
                { UCBC, 'EngineerGreaterAtLocation', { 'LocationType', 3, 'ENGINEER TECH2' } },
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH3, FACTORY TECH2' } },
                { EBC, 'GreaterThanEconIncome',  { 6.0, 120}},
                { IBC, 'BrainNotLowPowerMode', {} },
                { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'T2 Sea Factory Upgrade Speed Expansions',
        PlatoonTemplate = 'T2SeaFactoryUpgrade',
        Priority = 400,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY TECH3, FACTORY TECH2' } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'MASSEXTRACTION TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY TECH3'}},
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH3, FACTORY TECH2' } },
                { EBC, 'GreaterThanEconIncome',  { 7.0, 150}},
                { IBC, 'BrainNotLowPowerMode', {} },
                { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            },
        BuilderType = 'Any',
    },
}


# ===================== #
#     SLOW UPGRADES     #
# ===================== #
BuilderGroup {
    BuilderGroupName = 'T1SlowUpgradeBuilders',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'T1 Land Factory Upgrade Slow',
        PlatoonTemplate = 'T1LandFactoryUpgrade',
        Priority = 400,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 1, 'FACTORY' } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH2' } },
            { EBC, 'GreaterThanEconIncome',  { 5.0, 50}},
            { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'T1AirFactoryUpgrade Slow',
        PlatoonTemplate = 'T1AirFactoryUpgrade',
        Priority = 400,
        InstanceCount = 1,
        FormDebugFunction = nil,
        BuilderConditions = {
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 1, 'FACTORY' } },
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH2' } },
            { EBC, 'GreaterThanEconIncome',  { 5.0, 40}},
            { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'T1 Sea Factory Upgrade Slow',
        PlatoonTemplate = 'T1SeaFactoryUpgrade',
        Priority = 400,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, 'FACTORY TECH1 NAVAL' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH2' } },
            { EBC, 'GreaterThanEconIncome',  { 6, 10}},
            { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
        },
        BuilderType = 'Any',
    },
 }
 
BuilderGroup {
    BuilderGroupName = 'T2SlowUpgradeBuilders',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'T2 Land Factory Upgrade Slow',
        PlatoonTemplate = 'T2LandFactoryUpgrade',
        Priority = 500,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'MASSEXTRACTION TECH3'}},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 1, 'FACTORY' } },
            { UCBC, 'EngineerGreaterAtLocation', { 'LocationType', 3, 'ENGINEER TECH2' } },
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH3' } },
            { EBC, 'GreaterThanEconIncome',  { 9, 100}},
            { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'T2 Air Factory Upgrade Slow',
        PlatoonTemplate = 'T2AirFactoryUpgrade',
        Priority = 500,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'MASSEXTRACTION TECH3'}},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 1, 'FACTORY' } },
            { UCBC, 'EngineerGreaterAtLocation', { 'LocationType', 3, 'ENGINEER TECH2' } },
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH3' } },
            { EBC, 'GreaterThanEconIncome',  { 9, 100}},
            { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'T2 Sea Factory Upgrade Slow',
        PlatoonTemplate = 'T2SeaFactoryUpgrade',
        Priority = 500,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'MASSEXTRACTION TECH3'}},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH3' } },
            { EBC, 'GreaterThanEconIncome',  { 12, 150}},
            { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
        },
        BuilderType = 'Any',
    },
}

# ================================= #
#     NAVAL FACTORY UPGRADES
# ================================= #
BuilderGroup {
    BuilderGroupName = 'T1NavalUpgradeBuilders',
    BuildersType = 'PlatoonFormBuilder',
    
    # ================================= #
    #     INITIAL FACTORY UPGRADES
    # ================================= #
    Builder {
        BuilderName = 'Naval T1 Land Factory Upgrade Initial',
        PlatoonTemplate = 'T1LandFactoryUpgrade',
        Priority = 400,
        InstanceCount = 1,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1, 'FACTORY LAND TECH2, FACTORY LAND TECH3' } },
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY LAND TECH2, LAND FACTORY TECH3' } },
                #{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'FACTORY TECH2 NAVAL, FACTORY TECH3 NAVAL'}},
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH2, FACTORY TECH3' } },		            
                { EBC, 'GreaterThanEconIncome',  { 5, 75}},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'Naval T1 Air Factory Upgrade Initial',
        PlatoonTemplate = 'T1AirFactoryUpgrade',
        Priority = 400,
        InstanceCount = 1,
        FormDebugFunction = nil,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1, 'FACTORY AIR TECH2, FACTORY AIR TECH3'}},
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY TECH2, FACTORY TECH3' } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'FACTORY TECH2 NAVAL, FACTORY TECH3 NAVAL'}},
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY AIR TECH2, AIR FACTORY TECH3' } },
                { EBC, 'GreaterThanEconIncome',  { 5, 75}},
            },
        BuilderType = 'Any',
    },

    Builder {
        BuilderName = 'Naval T1 Naval Factory Upgrade Initial',
        PlatoonTemplate = 'T1SeaFactoryUpgrade',
        Priority = 440,
        InstanceCount = 1,
        FormDebugFunction = nil,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1, 'FACTORY NAVAL TECH2, FACTORY NAVAL TECH3'}},
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY NAVAL TECH2, FACTORY NAVAL TECH3' } },                                
                { EBC, 'GreaterThanEconIncome',  { 5, 75}},
            },
        BuilderType = 'Any',
    },    
    # ================================= #
    #     FACTORY UPGRADES AFTER INITIAL
    # ================================= #    
    Builder {
        BuilderName = 'Naval T1 Land Factory Upgrade',
        PlatoonTemplate = 'T1LandFactoryUpgrade',
        Priority = 220,
        InstanceCount = 1,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY LAND TECH3, FACTORY LAND TECH2' } },                
                #{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 7, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 2, 'FACTORY TECH2, FACTORY TECH3' } },
                { EBC, 'GreaterThanEconIncome',  { 10, 75}},
                { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 1.4} },
                { IBC, 'BrainNotLowPowerMode', {} },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'Naval T1 AirFactory Upgrade',
        PlatoonTemplate = 'T1AirFactoryUpgrade',
        Priority = 400,
        InstanceCount = 1,
        FormDebugFunction = nil,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY AIR TECH3, FACTORY AIR TECH2' } },
                #{ UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 1, 'FACTORY AIR' }},
                #{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                #{ UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY AIR TECH2, FACTORY AIR TECH3' } },
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 2, 'FACTORY TECH2, FACTORY TECH3' } },
                { EBC, 'GreaterThanEconIncome',  { 10, 75}},
                { IBC, 'BrainNotLowPowerMode', {} },
                { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 1.4} },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'Naval T1 Sea Factory Upgrade',
        PlatoonTemplate = 'T1SeaFactoryUpgrade',
        Priority = 440,
        InstanceCount = 1,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY NAVAL TECH3, FACTORY NAVAL TECH2' } },
                #{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                #{ UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 1, 'NAVAL' } },
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH2, FACTORY TECH3' } },
                { EBC, 'GreaterThanEconIncome',  { 8, 75}},
                { IBC, 'BrainNotLowPowerMode', {} },
                { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 1.4} },
            },
        BuilderType = 'Any',
    },
}

BuilderGroup {
    BuilderGroupName = 'T2NavalUpgradeBuilders',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'Naval T2 Land Factory Upgrade',
        PlatoonTemplate = 'T2LandFactoryUpgrade',
        Priority = 550,
        InstanceCount = 1,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 3, 'FACTORY LAND TECH3, FACTORY LAND TECH2' } },
                #{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'MASSEXTRACTION TECH3'}},
                #{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'FACTORY TECH3 NAVAL'}},
                #{ UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH3' } },
                #{ UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 7, 'MOBILE LAND'}},
                { EBC, 'GreaterThanEconIncome',  { 10, 0}},
                { IBC, 'BrainNotLowPowerMode', {} },
                { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'Naval T2 Air Factory Upgrade',
        PlatoonTemplate = 'T2AirFactoryUpgrade',
        Priority = 500,
        InstanceCount = 1,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 3, 'FACTORY TECH3, FACTORY TECH2' } },
                #{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'MASSEXTRACTION TECH3'} },
                #{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'FACTORY TECH3 NAVAL'}},
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH3' } },
                { EBC, 'GreaterThanEconIncome',  { 15, 0}},
                { IBC, 'BrainNotLowPowerMode', {} },
                { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'Naval T2 Sea Factory Upgrade',
        PlatoonTemplate = 'T2SeaFactoryUpgrade',
        Priority = 550,
        InstanceCount = 1,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY TECH3, FACTORY TECH2' } },                
                #{ UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH3' } },
                #{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'MASSEXTRACTION TECH3'} },
                { EBC, 'GreaterThanEconIncome',  { 20, 0}},
                { IBC, 'BrainNotLowPowerMode', {} },
                { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            },
        BuilderType = 'Any',
    },
}

