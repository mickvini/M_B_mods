T1PowerGeneratorAdjacencyMODBuffs = {
    'T1PowerEnergyBuildMODBonusSize4',
    'T1PowerEnergyBuildMODBonusSize8',
    'T1PowerEnergyBuildMODBonusSize12',
    'T1PowerEnergyBuildMODBonusSize16',
    'T1PowerEnergyBuildMODBonusSize20',
    'T1PowerEnergyWeaponMODBonusSize4',
    'T1PowerEnergyWeaponMODBonusSize8',
    'T1PowerEnergyWeaponMODBonusSize12',
    'T1PowerEnergyWeaponMODBonusSize16',
    'T1PowerEnergyWeaponMODBonusSize20',
    'T1PowerEnergyMaintenanceMODBonusSize4',
    'T1PowerEnergyMaintenanceMODBonusSize8',
    'T1PowerEnergyMaintenanceMODBonusSize12',
    'T1PowerEnergyMaintenanceMODBonusSize16',
    'T1PowerEnergyMaintenanceMODBonusSize20',
    -- 'T1PowerRateOfFireMODBonusSize4',
    -- 'T1PowerRateOfFireMODBonusSize8',
    -- 'T1PowerRateOfFireMODBonusSize12',
    -- 'T1PowerRateOfFireMODBonusSize16',
    -- 'T1PowerRateOfFireMODBonusSize20',
}

##################################################################
## ENERGY BUILD MODBonus - TIER 1 POWER GENS
##################################################################

BuffBlueprint {
    Name = 'T1PowerEnergyBuildMODBonusSize4',
    DisplayName = 'T1PowerEnergyBuildMODBonus',
    BuffType = 'ENERGYBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE4',
    BuffCheckFunction = AdjBuffFuncs.EnergyBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyBuildBuffRemove,
    Affects = {
        EnergyActive = {
            Add = -0.2/4,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T1PowerEnergyBuildMODBonusSize8',
    DisplayName = 'T1PowerEnergyBuildMODBonus',
    BuffType = 'ENERGYBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE8',
    BuffCheckFunction = AdjBuffFuncs.EnergyBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyBuildBuffRemove,
    Affects = {
        EnergyActive = {
            Add = -0.2/8,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T1PowerEnergyBuildMODBonusSize12',
    DisplayName = 'T1PowerEnergyBuildMODBonus',
    BuffType = 'ENERGYBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE12',
    BuffCheckFunction = AdjBuffFuncs.EnergyBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyBuildBuffRemove,
    Affects = {
        EnergyActive = {
            Add = -0.2/12,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T1PowerEnergyBuildMODBonusSize16',
    DisplayName = 'T1PowerEnergyBuildMODBonus',
    BuffType = 'ENERGYBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE16',
    BuffCheckFunction = AdjBuffFuncs.EnergyBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyBuildBuffRemove,
    Affects = {
        EnergyActive = {
            Add = -0.2/16,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T1PowerEnergyBuildMODBonusSize20',
    DisplayName = 'T1PowerEnergyBuildMODBonus',
    BuffType = 'ENERGYBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE20',
    BuffCheckFunction = AdjBuffFuncs.EnergyBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyBuildBuffRemove,
    Affects = {
        EnergyActive = {
            Add = -0.2/20,
            Mult = 1.0,
        },
    },
}

##################################################################
## ENERGY MAINTENANCE MODBonus - TIER 1 POWER GENS
##################################################################

BuffBlueprint {
    Name = 'T1PowerEnergyMaintenanceMODBonusSize4',
    DisplayName = 'T1PowerEnergyMaintenanceMODBonus',
    BuffType = 'ENERGYMAINTENANCEBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE4',
    BuffCheckFunction = AdjBuffFuncs.EnergyMaintenanceBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyMaintenanceBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyMaintenanceBuffRemove,
    Affects = {
        EnergyMaintenance = {
            Add = -0.2/4,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T1PowerEnergyMaintenanceMODBonusSize8',
    DisplayName = 'T1PowerEnergyMaintenanceMODBonus',
    BuffType = 'ENERGYMAINTENANCEBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE8',
    BuffCheckFunction = AdjBuffFuncs.EnergyMaintenanceBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyMaintenanceBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyMaintenanceBuffRemove,
    Affects = {
        EnergyMaintenance = {
            Add = -0.2/8,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T1PowerEnergyMaintenanceMODBonusSize12',
    DisplayName = 'T1PowerEnergyMaintenanceMODBonus',
    BuffType = 'ENERGYMAINTENANCEBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE12',
    BuffCheckFunction = AdjBuffFuncs.EnergyMaintenanceBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyMaintenanceBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyMaintenanceBuffRemove,
    Affects = {
        EnergyMaintenance = {
            Add = -0.2/12,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T1PowerEnergyMaintenanceMODBonusSize16',
    DisplayName = 'T1PowerEnergyMaintenanceMODBonus',
    BuffType = 'ENERGYMAINTENANCEBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE16',
    BuffCheckFunction = AdjBuffFuncs.EnergyMaintenanceBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyMaintenanceBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyMaintenanceBuffRemove,
    Affects = {
        EnergyMaintenance = {
            Add = -0.2/16,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T1PowerEnergyMaintenanceMODBonusSize20',
    DisplayName = 'T1PowerEnergyMaintenanceMODBonus',
    BuffType = 'ENERGYMAINTENANCEBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE20',
    BuffCheckFunction = AdjBuffFuncs.EnergyMaintenanceBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyMaintenanceBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyMaintenanceBuffRemove,
    Affects = {
        EnergyMaintenance = {
            Add = -0.2/20,
            Mult = 1.0,
        },
    },
}

##################################################################
## ENERGY WEAPON MODBonus - TIER 1 POWER GENS
##################################################################

BuffBlueprint {
    Name = 'T1PowerEnergyWeaponMODBonusSize4',
    DisplayName = 'T1PowerEnergyWeaponMODBonus',
    BuffType = 'ENERGYWEAPOBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE4',
    BuffCheckFunction = AdjBuffFuncs.EnergyWeaponBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyWeaponBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyWeaponBuffRemove,
    Affects = {
        EnergyWeapon = {
            Add = -0.2/4,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T1PowerEnergyWeaponMODBonusSize8',
    DisplayName = 'T1PowerEnergyWeaponMODBonus',
    BuffType = 'ENERGYWEAPOBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE8',
    BuffCheckFunction = AdjBuffFuncs.EnergyWeaponBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyWeaponBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyWeaponBuffRemove,
    Affects = {
        EnergyWeapon = {
            Add = -0.2/8,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T1PowerEnergyWeaponMODBonusSize12',
    DisplayName = 'T1PowerEnergyWeaponMODBonus',
    BuffType = 'ENERGYWEAPOBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE12',
    BuffCheckFunction = AdjBuffFuncs.EnergyWeaponBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyWeaponBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyWeaponBuffRemove,
    Affects = {
        EnergyWeapon = {
            Add = -0.2/12,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T1PowerEnergyWeaponMODBonusSize16',
    DisplayName = 'T1PowerEnergyWeaponMODBonus',
    BuffType = 'ENERGYWEAPOBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE16',
    BuffCheckFunction = AdjBuffFuncs.EnergyWeaponBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyWeaponBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyWeaponBuffRemove,
    Affects = {
        EnergyWeapon = {
            Add = -0.2/16,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T1PowerEnergyWeaponMODBonusSize20',
    DisplayName = 'T1PowerEnergyWeaponMODBonus',
    BuffType = 'ENERGYWEAPOBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE20',
    BuffCheckFunction = AdjBuffFuncs.EnergyWeaponBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyWeaponBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyWeaponBuffRemove,
    Affects = {
        EnergyWeapon = {
            Add = -0.2/20,
            Mult = 1.0,
        },
    },
}

-- ##################################################################
-- ## RATE OF FIRE WEAPON MODBonus - TIER 1 POWER GENS
-- ##################################################################

-- BuffBlueprint {
--     Name = 'T1PowerRateOfFireMODBonusSize4',
--     DisplayName = 'T1PowerRateOfFireMODBonus',
--     BuffType = 'RATEOFFIREADJACENCY',
--     Stacks = 'ALWAYS',
--     Duration = -1,
--     EntityCategory = 'STRUCTURE SIZE4 ARTILLERY',
--     BuffCheckFunction = AdjBuffFuncs.RateOfFireBuffCheck,
--     OnBuffAffect = AdjBuffFuncs.RateOfFireBuffAffect,
--     OnBuffRemove = AdjBuffFuncs.RateOfFireBuffRemove,
--     Affects = {
--         RateOfFire = {
--             Add = -0.2/4,
--             Mult = 1.0,
--         },
--     },
-- }

-- BuffBlueprint {
--     Name = 'T1PowerRateOfFireMODBonusSize8',
--     DisplayName = 'T1PowerRateOfFireMODBonus',
--     BuffType = 'RATEOFFIREADJACENCY',
--     Stacks = 'ALWAYS',
--     Duration = -1,
--     EntityCategory = 'STRUCTURE SIZE8',
--     BuffCheckFunction = AdjBuffFuncs.RateOfFireBuffCheck,
--     OnBuffAffect = AdjBuffFuncs.RateOfFireBuffAffect,
--     OnBuffRemove = AdjBuffFuncs.RateOfFireBuffRemove,
--     Affects = {
--         RateOfFire = {
--             Add = -0.2/8,
--             Mult = 1.0,
--         },
--     },
-- }

-- BuffBlueprint {
--     Name = 'T1PowerRateOfFireMODBonusSize12',
--     DisplayName = 'T1PowerRateOfFireMODBonus',
--     BuffType = 'RATEOFFIREADJACENCY',
--     Stacks = 'ALWAYS',
--     Duration = -1,
--     EntityCategory = 'STRUCTURE SIZE12',
--     BuffCheckFunction = AdjBuffFuncs.RateOfFireBuffCheck,
--     OnBuffAffect = AdjBuffFuncs.RateOfFireBuffAffect,
--     OnBuffRemove = AdjBuffFuncs.RateOfFireBuffRemove,
--     Affects = {
--         RateOfFire = {
--             Add = -0.2/12,
--             Mult = 1.0,
--         },
--     },
-- }

-- BuffBlueprint {
--     Name = 'T1PowerRateOfFireMODBonusSize16',
--     DisplayName = 'T1PowerRateOfFireMODBonus',
--     BuffType = 'RATEOFFIREADJACENCY',
--     Stacks = 'ALWAYS',
--     Duration = -1,
--     EntityCategory = 'STRUCTURE SIZE16',
--     BuffCheckFunction = AdjBuffFuncs.RateOfFireBuffCheck,
--     OnBuffAffect = AdjBuffFuncs.RateOfFireBuffAffect,
--     OnBuffRemove = AdjBuffFuncs.RateOfFireBuffRemove,
--     Affects = {
--         RateOfFire = {
--             Add = -0.2/16,
--             Mult = 1.0,
--         },
--     },
-- }

-- BuffBlueprint {
--     Name = 'T1PowerRateOfFireMODBonusSize20',
--     DisplayName = 'T1PowerRateOfFireMODBonus',
--     BuffType = 'RATEOFFIREADJACENCY',
--     Stacks = 'ALWAYS',
--     Duration = -1,
--     EntityCategory = 'STRUCTURE SIZE20',
--     BuffCheckFunction = AdjBuffFuncs.RateOfFireBuffCheck,
--     OnBuffAffect = AdjBuffFuncs.RateOfFireBuffAffect,
--     OnBuffRemove = AdjBuffFuncs.RateOfFireBuffRemove,
--     Affects = {
--         RateOfFire = {
--             Add = -0.2/20,
--             Mult = 1.0,
--         },
--     },
-- }

T2LightPowerGeneratorAdjacencyBuffs = {
    -- 'T2LightPowerEnergyBuildBonusSize4',
    -- 'T2LightPowerEnergyMaintenanceBonusSize4',
    -- 'T2LightPowerEnergyWeaponBonusSize4',
    'T2LightPowerEnergyBuildBonusSize8',
    'T2LightPowerEnergyMaintenanceBonusSize8',
    'T2LightPowerEnergyWeaponBonusSize8',
    'T2LightPowerEnergyBuildBonusSize12',
    'T2LightPowerEnergyMaintenanceBonusSize12',
    'T2LightPowerEnergyWeaponBonusSize12',
    'T2LightPowerEnergyBuildBonusSize16',
    'T2LightPowerEnergyMaintenanceBonusSize16',
    'T2LightPowerEnergyWeaponBonusSize16',
    'T2LightPowerEnergyBuildBonusSize20',
    'T2LightPowerEnergyMaintenanceBonusSize20',
    'T2LightPowerEnergyWeaponBonusSize20',    
}

-- BuffBlueprint {
--     Name = 'T2LightPowerEnergyMaintenanceBonusSize4',
--     DisplayName = 'T2LightPowerEnergyMaintenanceBonus4',
--     BuffType = 'ENERGYMAINTENANCEBONUS',
--     Stacks = 'ALWAYS',
--     Duration = -1,
--     EntityCategory = 'STRUCTURE SIZE4',
--     BuffCheckFunction = AdjBuffFuncs.EnergyMaintenanceBuffCheck,
--     OnBuffAffect = AdjBuffFuncs.EnergyMaintenanceBuffAffect,
--     OnBuffRemove = AdjBuffFuncs.EnergyMaintenanceBuffRemove,
--     Affects = {
--         EnergyMaintenance = {
--             Add = -0.4/20,
--             Mult = 1,
--         },
--     },
-- }
# For Size 8 - ENERGYMAINTENANCEBONUS
BuffBlueprint {
    Name = 'T2LightPowerEnergyMaintenanceBonusSize8',
    DisplayName = 'T2LightPowerEnergyMaintenanceBonus8',
    BuffType = 'ENERGYMAINTENANCEBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE8',
    BuffCheckFunction = AdjBuffFuncs.EnergyMaintenanceBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyMaintenanceBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyMaintenanceBuffRemove,
    Affects = {
        EnergyMaintenance = {
            Add = -0.4/4,
            Mult = 1,
        },
    },
}
# For Size 12 - ENERGYMAINTENANCEBONUS
BuffBlueprint {
    Name = 'T2LightPowerEnergyMaintenanceBonusSize12',
    DisplayName = 'T2LightPowerEnergyMaintenanceBonus12',
    BuffType = 'ENERGYMAINTENANCEBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE12',
    BuffCheckFunction = AdjBuffFuncs.EnergyMaintenanceBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyMaintenanceBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyMaintenanceBuffRemove,
    Affects = {
        EnergyMaintenance = {
            Add = -0.4/4,
            Mult = 1,
        },
    },
}
# For Size 16 - ENERGYMAINTENANCEBONUS
BuffBlueprint {
    Name = 'T2LightPowerEnergyMaintenanceBonusSize16',
    DisplayName = 'T2LightPowerEnergyMaintenanceBonusSize16',
    BuffType = 'ENERGYMAINTENANCEBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE16',
    BuffCheckFunction = AdjBuffFuncs.EnergyMaintenanceBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyMaintenanceBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyMaintenanceBuffRemove,
    Affects = {
        EnergyMaintenance = {
            Add = -0.4/8,
            Mult = 1,
        },
    },
}
# For Size 20 - ENERGYMAINTENANCEBONUS
BuffBlueprint {
    Name = 'T2LightPowerEnergyMaintenanceBonusSize20',
    DisplayName = 'T2LightPowerEnergyMaintenanceBonusSize20',
    BuffType = 'ENERGYMAINTENANCEBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE20',
    BuffCheckFunction = AdjBuffFuncs.EnergyMaintenanceBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyMaintenanceBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyMaintenanceBuffRemove,
    Affects = {
        EnergyMaintenance = {
            Add = -0.4/8,
            Mult = 1,
        },
    },
}

-- BuffBlueprint {
--     Name = 'T2LightPowerEnergyBuildBonusSize4',
--     DisplayName = 'T2LightPowerEnergyBuildBonus4',
--     BuffType = 'ENERGYBUILDBONUS',
--     Stacks = 'ALWAYS',
--     Duration = -1,
--     EntityCategory = 'STRUCTURE SIZE4',
--     BuffCheckFunction = AdjBuffFuncs.EnergyBuildBuffCheck,
--     OnBuffAffect = AdjBuffFuncs.EnergyBuildBuffAffect,
--     OnBuffRemove = AdjBuffFuncs.EnergyBuildBuffRemove,
--     Affects = {
--         EnergyMaintenance = {
--             Add = -0.4/4,
--             Mult = 1,
--         },
--     },
-- }

# For Size 8 - ENERGYBUILDBONUS
BuffBlueprint {
    Name = 'T2LightPowerEnergyBuildBonusSize8',
    DisplayName = 'T2LightPowerEnergyBuildBonus8',
    BuffType = 'ENERGYBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE8',
    BuffCheckFunction = AdjBuffFuncs.EnergyBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyBuildBuffRemove,
    Affects = {
        EnergyBuildRate = {
            Add = -0.4/4,
            Mult = 1,
        },
    },
}

# For Size 12 - ENERGYBUILDBONUS
BuffBlueprint {
    Name = 'T2LightPowerEnergyBuildBonusSize12',
    DisplayName = 'T2LightPowerEnergyBuildBonus12',
    BuffType = 'ENERGYBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE12',
    BuffCheckFunction = AdjBuffFuncs.EnergyBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyBuildBuffRemove,
    Affects = {
        EnergyBuildRate = {
            Add = -0.4/4,
            Mult = 1,
        },
    },
}


# For Size 16 - ENERGYBUILDBONUS
BuffBlueprint {
    Name = 'T2LightPowerEnergyBuildBonusSize16',
    DisplayName = 'T2LightPowerEnergyBuildBonus',
    BuffType = 'ENERGYBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE16',
    BuffCheckFunction = AdjBuffFuncs.EnergyBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyBuildBuffRemove,
    Affects = {
        EnergyBuildRate = {
            Add = -0.4/8,
            Mult = 1,
        },
    },
}

# For Size 20 - ENERGYBUILDBONUS
BuffBlueprint {
    Name = 'T2LightPowerEnergyBuildBonusSize20',
    DisplayName = 'T2LightPowerEnergyBuildBonus',
    BuffType = 'ENERGYBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE20',
    BuffCheckFunction = AdjBuffFuncs.EnergyBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyBuildBuffRemove,
    Affects = {
        EnergyBuildRate = {
            Add = -0.4/8,
            Mult = 1,
        },
    },
}



-- BuffBlueprint {
--     Name = 'T2LightPowerEnergyWeaponBonusSize4',
--     DisplayName = 'T2LightPowerEnergyWeaponBonus4',
--     BuffType = 'ENERGYWEAPONBONUS',
--     Stacks = 'ALWAYS',
--     Duration = -1,
--     EntityCategory = 'STRUCTURE SIZE4',
--     BuffCheckFunction = AdjBuffFuncs.EnergyWeaponBuffCheck,
--     OnBuffAffect = AdjBuffFuncs.EnergyWeaponBuffAffect,
--     OnBuffRemove = AdjBuffFuncs.EnergyWeaponBuffRemove,
--     Affects = {
--         EnergyMaintenance = {
--             Add = -0.4/4,
--             Mult = 1,
--         },
--     },
-- }

# For Size 8 - ENERGYWEAPONBONUS
BuffBlueprint {
    Name = 'T2LightPowerEnergyWeaponBonusSize8',
    DisplayName = 'T2LightPowerEnergyWeaponBonus8',
    BuffType = 'ENERGYWEAPONBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE8',
    BuffCheckFunction = AdjBuffFuncs.EnergyWeaponBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyWeaponBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyWeaponBuffRemove,
    Affects = {
        EnergyWeaponRate = {
            Add = -0.4/4,
            Mult = 1,
        },
    },
}

# For Size 12 - ENERGYWEAPONBONUS
BuffBlueprint {
    Name = 'T2LightPowerEnergyWeaponBonusSize12',
    DisplayName = 'T2LightPowerEnergyWeaponBonus12',
    BuffType = 'ENERGYWEAPONBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE12',
    BuffCheckFunction = AdjBuffFuncs.EnergyWeaponBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyWeaponBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyWeaponBuffRemove,
    Affects = {
        EnergyWeaponRate = {
            Add = -0.4/4,
            Mult = 1,
        },
    },
}

# For Size 16 - ENERGYWEAPONBONUS
BuffBlueprint {
    Name = 'T2LightPowerEnergyWeaponBonusSize16',
    DisplayName = 'T2LightPowerEnergyWeaponBonus',
    BuffType = 'ENERGYWEAPONBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE16',
    BuffCheckFunction = AdjBuffFuncs.EnergyWeaponBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyWeaponBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyWeaponBuffRemove,
    Affects = {
        EnergyWeaponRate = {
            Add = -0.4/8,
            Mult = 1,
        },
    },
}

# For Size 20 - ENERGYWEAPONBONUS
BuffBlueprint {
    Name = 'T2LightPowerEnergyWeaponBonusSize20',
    DisplayName = 'T2LightPowerEnergyWeaponBonus',
    BuffType = 'ENERGYWEAPONBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE20',
    BuffCheckFunction = AdjBuffFuncs.EnergyWeaponBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyWeaponBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyWeaponBuffRemove,
    Affects = {
        EnergyWeaponRate = {
            Add = -0.4/8,
            Mult = 1,
        },
    },
}

T2PowerGeneratorAdjacencyMODBuffs = {
    --'T2PowerEnergyBuildMODBonusSize4',
    --'T2PowerEnergyBuildMODBonusSize8',
    'T2PowerEnergyBuildMODBonusSize12',
    'T2PowerEnergyBuildMODBonusSize16',
    'T2PowerEnergyBuildMODBonusSize20',
    --'T2PowerEnergyWeaponMODBonusSize4',
    --'T2PowerEnergyWeaponMODBonusSize8',
    'T2PowerEnergyWeaponMODBonusSize12',
    'T2PowerEnergyWeaponMODBonusSize16',
    'T2PowerEnergyWeaponMODBonusSize20',
    --'T2PowerEnergyMaintenanceMODBonusSize4',
    --'T2PowerEnergyMaintenanceMODBonusSize8',
    'T2PowerEnergyMaintenanceMODBonusSize12',
    'T2PowerEnergyMaintenanceMODBonusSize16',
    'T2PowerEnergyMaintenanceMODBonusSize20',    
}


##################################################################
## ENERGY BUILD BONUS - TIER 2 POWER GENS
##################################################################

BuffBlueprint {
    Name = 'T2PowerEnergyBuildMODBonusSize12',
    DisplayName = 'T2PowerEnergyBuildMODBonus',
    BuffType = 'ENERGYBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE12',
    BuffCheckFunction = AdjBuffFuncs.EnergyBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyBuildBuffRemove,
    Affects = {
        EnergyActive = {
            Add = -0.5/4,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T2PowerEnergyBuildMODBonusSize16',
    DisplayName = 'T2PowerEnergyBuildMODBonus',
    BuffType = 'ENERGYBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE16',
    BuffCheckFunction = AdjBuffFuncs.EnergyBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyBuildBuffRemove,
    Affects = {
        EnergyActive = {
            Add = -0.5/4,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T2PowerEnergyBuildMODBonusSize20',
    DisplayName = 'T2PowerEnergyBuildMODBonus',
    BuffType = 'ENERGYBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE20',
    BuffCheckFunction = AdjBuffFuncs.EnergyBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyBuildBuffRemove,
    Affects = {
        EnergyActive = {
            Add = -0.5/8,
            Mult = 1.0,
        },
    },
}

##################################################################
## ENERGY MAINTENANCE BONUS - TIER 2 POWER GENS
##################################################################

BuffBlueprint {
    Name = 'T2PowerEnergyMaintenanceMODBonusSize12',
    DisplayName = 'T2PowerEnergyMaintenanceMODBonus',
    BuffType = 'ENERGYMAINTENANCEBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE12',
    BuffCheckFunction = AdjBuffFuncs.EnergyMaintenanceBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyMaintenanceBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyMaintenanceBuffRemove,
    Affects = {
        EnergyMaintenance = {
            Add = -0.5/4,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T2PowerEnergyMaintenanceMODBonusSize16',
    DisplayName = 'T2PowerEnergyMaintenanceMODBonus',
    BuffType = 'ENERGYMAINTENANCEBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE16',
    BuffCheckFunction = AdjBuffFuncs.EnergyMaintenanceBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyMaintenanceBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyMaintenanceBuffRemove,
    Affects = {
        EnergyMaintenance = {
            Add = -0.5/4,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T2PowerEnergyMaintenanceMODBonusSize20',
    DisplayName = 'T2PowerEnergyMaintenanceMODBonus',
    BuffType = 'ENERGYMAINTENANCEBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE20',
    BuffCheckFunction = AdjBuffFuncs.EnergyMaintenanceBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyMaintenanceBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyMaintenanceBuffRemove,
    Affects = {
        EnergyMaintenance = {
            Add = -0.5/8,
            Mult = 1.0,
        },
    },
}

##################################################################
## ENERGY WEAPON BONUS - TIER 2 POWER GENS
##################################################################

BuffBlueprint {
    Name = 'T2PowerEnergyWeaponMODBonusSize12',
    DisplayName = 'T2PowerEnergyWeaponMODBonus',
    BuffType = 'ENERGYWEAPONBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE12',
    BuffCheckFunction = AdjBuffFuncs.EnergyWeaponBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyWeaponBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyWeaponBuffRemove,
    Affects = {
        EnergyWeapon = {
            Add = -0.5/4,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T2PowerEnergyWeaponMODBonusSize16',
    DisplayName = 'T2PowerEnergyWeaponMODBonus',
    BuffType = 'ENERGYWEAPONBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE16',
    BuffCheckFunction = AdjBuffFuncs.EnergyWeaponBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyWeaponBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyWeaponBuffRemove,
    Affects = {
        EnergyWeapon = {
            Add = -0.5/4,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T2PowerEnergyWeaponMODBonusSize20',
    DisplayName = 'T2PowerEnergyWeaponMODBonus',
    BuffType = 'ENERGYWEAPONBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE20',
    BuffCheckFunction = AdjBuffFuncs.EnergyWeaponBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyWeaponBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyWeaponBuffRemove,
    Affects = {
        EnergyWeapon = {
            Add = -0.5/8,
            Mult = 1.0,
        },
    },
}

##################################################################
## TIER 3 POWER GEN BUFF TABLE
##################################################################

T3PowerGeneratorAdjacencyMODBuffs = {
    -- 'T3PowerEnergyBuildMODBonusSize4',
    -- 'T3PowerEnergyBuildMODBonusSize8',
    -- 'T3PowerEnergyBuildMODBonusSize12',
    'T3PowerEnergyBuildMODBonusSize16',
    'T3PowerEnergyBuildMODBonusSize20',
    -- 'T3PowerEnergyWeaponMODBonusSize4',
    -- 'T3PowerEnergyWeaponMODBonusSize8',
    -- 'T3PowerEnergyWeaponMODBonusSize12',
    'T3PowerEnergyWeaponMODBonusSize16',
    'T3PowerEnergyWeaponMODBonusSize20',
    -- 'T3PowerEnergyMaintenanceMODBonusSize4',
    -- 'T3PowerEnergyMaintenanceMODBonusSize8',
    -- 'T3PowerEnergyMaintenanceMODBonusSize12',
    'T3PowerEnergyMaintenanceMODBonusSize16',
    'T3PowerEnergyMaintenanceMODBonusSize20',    
}


##################################################################
## ENERGY BUILD BONUS - TIER 3 POWER GENS
##################################################################

BuffBlueprint {
    Name = 'T3PowerEnergyBuildMODBonusSize16',
    DisplayName = 'T3PowerEnergyBuildMODBonus',
    BuffType = 'ENERGYBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE16',
    BuffCheckFunction = AdjBuffFuncs.EnergyBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyBuildBuffRemove,
    Affects = {
        EnergyActive = {
            Add = -0.6/4,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T3PowerEnergyBuildMODBonusSize20',
    DisplayName = 'T3PowerEnergyBuildMODBonus',
    BuffType = 'ENERGYBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE20',
    BuffCheckFunction = AdjBuffFuncs.EnergyBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyBuildBuffRemove,
    Affects = {
        EnergyActive = {
            Add = -0.6/4,
            Mult = 1.0,
        },
    },
}

##################################################################
## ENERGY MAINTENANCE BONUS - TIER 3 POWER GENS
##################################################################

BuffBlueprint {
    Name = 'T3PowerEnergyMaintenanceMODBonusSize16',
    DisplayName = 'T3PowerEnergyMaintenanceMODBonus',
    BuffType = 'ENERGYMAINTENANCEBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE16',
    BuffCheckFunction = AdjBuffFuncs.EnergyMaintenanceBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyMaintenanceBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyMaintenanceBuffRemove,
    Affects = {
        EnergyMaintenance = {
            Add = -0.6/4,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T3PowerEnergyMaintenanceMODBonusSize20',
    DisplayName = 'T3PowerEnergyMaintenanceMODBonus',
    BuffType = 'ENERGYMAINTENANCEBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE20',
    BuffCheckFunction = AdjBuffFuncs.EnergyMaintenanceBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyMaintenanceBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyMaintenanceBuffRemove,
    Affects = {
        EnergyMaintenance = {
            Add = -0.6/4,
            Mult = 1.0,
        },
    },
}

##################################################################
## ENERGY WEAPON BONUS - TIER 3 POWER GENS
##################################################################

BuffBlueprint {
    Name = 'T3PowerEnergyWeaponMODBonusSize16',
    DisplayName = 'T3PowerEnergyWeaponMODBonus',
    BuffType = 'ENERGYWEAPONBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE16',
    BuffCheckFunction = AdjBuffFuncs.EnergyWeaponBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyWeaponBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyWeaponBuffRemove,
    Affects = {
        EnergyWeapon = {
            Add = -0.6/4,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T3PowerEnergyWeaponMODBonusSize20',
    DisplayName = 'T3PowerEnergyWeaponMODBonus',
    BuffType = 'ENERGYWEAPONBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE20',
    BuffCheckFunction = AdjBuffFuncs.EnergyWeaponBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyWeaponBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyWeaponBuffRemove,
    Affects = {
        EnergyWeapon = {
            Add = -0.6/4,
            Mult = 1.0,
        },
    },
}

ScienceCentreResearchBuff = {
    'ResearchMassBuildBonus',
    'ResearchEnergyBuildNerf',
}

ManufacturingCentreResearchBuff = {
    'ResearchEnergyBuildBonus',
    'ResearchMassBuildBonusNerf',
}

BuffBlueprint {Name = 'Tier2ResearchEnergyBuildBonus',
    DisplayName = 'Tier2ResearchEnergyBuildBonus',
    BuffType = 'ENERGYBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE',
    ParsedEntityCategory = categories.STRUCTURE,
    BuffCheckFunction = AdjBuffFuncs.EnergyBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyBuildBuffRemove,
    Affects = {
        EnergyActive = {
            Add = -0.375/8,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {Name = 'ResearchEnergyBuildNerf',
    DisplayName = 'ResearchEnergyBuildNerf',
    BuffType = 'ENERGYBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE',
    ParsedEntityCategory = categories.STRUCTURE,
    BuffCheckFunction = AdjBuffFuncs.EnergyBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyBuildBuffRemove,
    Affects = {
        EnergyActive = {
            Add = 0.125/8,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {Name = 'Tier2ResearchMassBuildBonus',
    DisplayName = 'Tier2ResearchMassBuildBonus',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE',
    ParsedEntityCategory = categories.STRUCTURE,
    BuffCheckFunction = AdjBuffFuncs.MassBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.MassBuildBuffRemove,
    Affects = {
        MassActive = {
            Add = -0.375/8,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {Name = 'ResearchMassBuildBonusNerf',
    DisplayName = 'ResearchMassBuildBonusNerf',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE',
    ParsedEntityCategory = categories.STRUCTURE,
    BuffCheckFunction = AdjBuffFuncs.MassBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.MassBuildBuffRemove,
    Affects = {
        MassActive = {
            Add = 0.125/8,
            Mult = 1.0,
        },
    },
}

T4PowerGeneratorAdjacencyBuffs = {
    -- 'T4PowerEnergyBuildBonusSize4',
    -- 'T4PowerEnergyBuildBonusSize8',
    -- 'T4PowerEnergyBuildBonusSize12',
    -- 'T4PowerEnergyBuildBonusSize16',
    'T4PowerEnergyBuildBonusSize20',
    -- 'T4PowerEnergyWeaponBonusSize4',
    -- 'T4PowerEnergyWeaponBonusSize8',
    -- 'T4PowerEnergyWeaponBonusSize12',
    -- 'T4PowerEnergyWeaponBonusSize16',
    'T4PowerEnergyWeaponBonusSize20',
    -- 'T4PowerEnergyMaintenanceBonusSize4',
    -- 'T4PowerEnergyMaintenanceBonusSize8',
    -- 'T4PowerEnergyMaintenanceBonusSize12',
    -- 'T4PowerEnergyMaintenanceBonusSize16',
    'T4PowerEnergyMaintenanceBonusSize20',
    -- 'T4PowerRateOfFireBonusSize4',
    -- 'T4PowerRateOfFireBonusSize8',
    -- 'T4PowerRateOfFireBonusSize12',
    -- 'T4PowerRateOfFireBonusSize16',
    --'T4PowerRateOfFireBonusSize20',
}


##################################################################
## ENERGY BUILD BONUS - TIER 4 POWER GENS
##################################################################
BuffBlueprint {
    Name = 'T4PowerEnergyBuildBonusSize20',
    DisplayName = 'T4PowerEnergyBuildBonus',
    BuffType = 'ENERGYBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE20',
    BuffCheckFunction = AdjBuffFuncs.EnergyBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyBuildBuffRemove,
    Affects = {
        EnergyActive = {
            Add = -0.7/4,
            Mult = 1.0,
        },
    },
}

##################################################################
## ENERGY MAINTENANCE BONUS - TIER 4 POWER GENS
##################################################################
BuffBlueprint {
    Name = 'T4PowerEnergyMaintenanceBonusSize20',
    DisplayName = 'T4PowerEnergyMaintenanceBonus',
    BuffType = 'ENERGYMAINTENANCEBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE20',
    BuffCheckFunction = AdjBuffFuncs.EnergyMaintenanceBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyMaintenanceBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyMaintenanceBuffRemove,
    Affects = {
        EnergyMaintenance = {
            Add = -0.7/4,
            Mult = 1.0,
        },
    },
}

##################################################################
## ENERGY WEAPON BONUS - TIER 4 POWER GENS
##################################################################

BuffBlueprint {
    Name = 'T4PowerEnergyWeaponBonusSize20',
    DisplayName = 'T4PowerEnergyWeaponBonus',
    BuffType = 'ENERGYWEAPONBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE20',
    BuffCheckFunction = AdjBuffFuncs.EnergyWeaponBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyWeaponBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyWeaponBuffRemove,
    Affects = {
        EnergyWeapon = {
            Add = -0.7/4,
            Mult = 1.0,
        },
    },
}

T4MassFabricatorAdjacencyBuffs = {
    -- 'T4FabricatorMassBuildBonusSize4',
    -- 'T4FabricatorMassBuildBonusSize8',
    -- 'T4FabricatorMassBuildBonusSize12',
    -- 'T4FabricatorMassBuildBonusSize16',
    'T4FabricatorMassBuildBonusSize20',
}


##################################################################
## MASS BUILD BONUS - TIER 4 MASS FABRICATOR
##################################################################

BuffBlueprint {
    Name = 'T4FabricatorMassBuildBonusSize20',
    DisplayName = 'T4FabricatorMassBuildBonus',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE20',
    BuffCheckFunction = AdjBuffFuncs.MassBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.MassBuildBuffRemove,
    Affects = {
        MassActive = {
            Add = -0.7/4,
            Mult = 1.0,
        },
    },
}


T1EnergyStorageAdjacencyMODBuffs = {
    'T1EnergyStorageEnergyProductionMODBonusSize4',
    'T1EnergyStorageEnergyProductionMODBonusSize8',
    'T1EnergyStorageEnergyProductionMODBonusSize12',
    'T1EnergyStorageEnergyProductionMODBonusSize16',
    'T1EnergyStorageEnergyProductionMODBonusSize20',
    'T1EnergyStorageShieldRegenMODBonusSize4',
    'T1EnergyStorageShieldRegenMODBonusSize12',
    'T1EnergyStorageShieldRegenMODBonusSize16',
    'T1EnergyStorageShieldSizeMODBonusSize4',
    'T1EnergyStorageShieldSizeMODBonusSize12',
    'T1EnergyStorageShieldHealthMODBonusSize4',
    'T1EnergyStorageShieldHealthMODBonusSize12',
    'T1EnergyStorageShieldHealthMODBonusSize16',                   
}

BuffBlueprint {
    Name = 'T1EnergyStorageEnergyProductionMODBonusSize4',
    DisplayName = 'T1EnergyStorageEnergyProductionBonus',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE4',
    BuffCheckFunction = AdjBuffFuncs.EnergyProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyProductionBuffRemove,
    Affects = {
        EnergyProduction = {
            Add = 0.4/4,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T1EnergyStorageEnergyProductionMODBonusSize8',
    DisplayName = 'T1EnergyStorageEnergyProductionMODBonus',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE8',
    BuffCheckFunction = AdjBuffFuncs.EnergyProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyProductionBuffRemove,
    Affects = {
        EnergyProduction = {
            Add = 0.4/8,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T1EnergyStorageEnergyProductionMODBonusSize12',
    DisplayName = 'T1EnergyStorageEnergyProductionMODBonus',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE12',
    BuffCheckFunction = AdjBuffFuncs.EnergyProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyProductionBuffRemove,
    Affects = {
        EnergyProduction = {
            Add = 0.4/12,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T1EnergyStorageEnergyProductionMODBonusSize16',
    DisplayName = 'T1EnergyStorageEnergyProductionMODBonus',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE16',
    BuffCheckFunction = AdjBuffFuncs.EnergyProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyProductionBuffRemove,
    Affects = {
        EnergyProduction = {
            Add = 0.4/16,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T1EnergyStorageEnergyProductionMODBonusSize20',
    DisplayName = 'T1EnergyStorageEnergyProductionMODBonus',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE20',
    BuffCheckFunction = AdjBuffFuncs.EnergyProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyProductionBuffRemove,
    Affects = {
        EnergyProduction = {
            Add = 0.4/20,
            Mult = 1.0,
        },
    },
}


BuffBlueprint { Name = 'T1EnergyStorageShieldRegenMODBonusSize4',
    BuffType = 'SHIELDREGENBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE4',
    BuffCheckFunction = AdjBuffFuncs.ShieldRegenBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        ShieldRegeneration = {
            Add = 0.1/4,
            Mult = 1.0,
        },
    },
}

BuffBlueprint { Name = 'T1EnergyStorageShieldRegenMODBonusSize12',
    BuffType = 'SHIELDREGENBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE12',
    BuffCheckFunction = AdjBuffFuncs.ShieldRegenBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        ShieldRegeneration = {
            Add = 0.1/12,
            Mult = 1.0,
        },
    },
}

BuffBlueprint { Name = 'T1EnergyStorageShieldRegenMODBonusSize16',
    BuffType = 'SHIELDREGENBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE16',
    BuffCheckFunction = AdjBuffFuncs.ShieldRegenBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        ShieldRegeneration = {
            Add = 0.1/16,
            Mult = 1.0,
        },
    },
}

BuffBlueprint { Name = 'T1EnergyStorageShieldSizeMODBonusSize4',
    BuffType = 'SHIELDSIZEBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE4',
    BuffCheckFunction = AdjBuffFuncs.ShieldSizeBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        ShieldSize = {
            Add = 0.1/4,
            Mult = 1.0,
        },
    },
}

BuffBlueprint { Name = 'T1EnergyStorageShieldSizeMODBonusSize12',
    BuffType = 'SHIELDSIZEBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE12',
    BuffCheckFunction = AdjBuffFuncs.ShieldSizeBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        ShieldSize = {
            Add = 0.1/12,
            Mult = 1.0,
        },
    },
}

BuffBlueprint { Name = 'T1EnergyStorageShieldHealthMODBonusSize4',
    BuffType = 'SHIELDHEALTHBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE4',
    BuffCheckFunction = AdjBuffFuncs.ShieldHealthBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        ShieldHealth = {
            Add = 0.1/4,
            Mult = 1.0,
        },
    },
}

BuffBlueprint { Name = 'T1EnergyStorageShieldHealthMODBonusSize12',
    BuffType = 'SHIELDHEALTHBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE12',
    BuffCheckFunction = AdjBuffFuncs.ShieldHealthBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        ShieldHealth = {
            Add = 0.1/12,
            Mult = 1.0,
        },
    },
}

BuffBlueprint { Name = 'T1EnergyStorageShieldHealthMODBonusSize16',
    BuffType = 'SHIELDHEALTHBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE16',
    BuffCheckFunction = AdjBuffFuncs.ShieldHealthBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        ShieldHealth = {
            Add = 0.1/16,
            Mult = 1.0,
        },
    },
}
T2EnergyStorageAdjacencyMODBuffs = {
    'T2EnergyStorageEnergyProductionMODBonusSize4',
    'T2EnergyStorageEnergyProductionMODBonusSize8',
    'T2EnergyStorageEnergyProductionMODBonusSize12',
    'T2EnergyStorageEnergyProductionMODBonusSize16',
    'T2EnergyStorageEnergyProductionMODBonusSize20',
    'T2EnergyStorageShieldRegenMODBonusSize4',
    'T2EnergyStorageShieldRegenMODBonusSize8',
    'T2EnergyStorageShieldRegenMODBonusSize12',
    'T2EnergyStorageShieldRegenMODBonusSize16',
    'T2EnergyStorageShieldSizeMODBonusSize4',
    'T2EnergyStorageShieldSizeMODBonusSize8',
    'T2EnergyStorageShieldSizeMODBonusSize12',
    'T2EnergyStorageShieldHealthMODBonusSize4',
    'T2EnergyStorageShieldHealthMODBonusSize8',
    'T2EnergyStorageShieldHealthMODBonusSize12',
    'T2EnergyStorageShieldHealthMODBonusSize16',
}

-- Combo building gets T3 Shield Effects but only T2 Resource Adjacency and T2 Energy Weapon MODBonus


BuffBlueprint { Name = 'T2EnergyStorageEnergyProductionMODBonusSize4',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE4',
    BuffCheckFunction = AdjBuffFuncs.EnergyProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        EnergyProduction = {
            Add = 0.6/4,
            Mult = 1.0,
        },
    },
}
BuffBlueprint { Name = 'T2EnergyStorageEnergyProductionMODBonusSize8',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE8',
    BuffCheckFunction = AdjBuffFuncs.EnergyProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        EnergyProduction = {
            Add = 0.6/8,
            Mult = 1.0,
        },
    },
}

BuffBlueprint { Name = 'T2EnergyStorageEnergyProductionMODBonusSize12',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE12',
    BuffCheckFunction = AdjBuffFuncs.EnergyProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        EnergyProduction = {
            Add = 0.6/12,
            Mult = 1.0,
        },
    },
}

BuffBlueprint { Name = 'T2EnergyStorageEnergyProductionMODBonusSize16',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE16',
    BuffCheckFunction = AdjBuffFuncs.EnergyProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        EnergyProduction = {
            Add = 0.6/16,
            Mult = 1.0,
        },
    },
}

BuffBlueprint { Name = 'T2EnergyStorageEnergyProductionMODBonusSize20',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE20',
    BuffCheckFunction = AdjBuffFuncs.EnergyProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        EnergyProduction = {
            Add = 0.6/20,
            Mult = 1.0,
        },
    },
}

BuffBlueprint { Name = 'T2EnergyStorageShieldRegenMODBonusSize4',
    BuffType = 'SHIELDREGENBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE4',
    BuffCheckFunction = AdjBuffFuncs.ShieldRegenBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        ShieldRegeneration = {
            Add = 0.15/4,
            Mult = 1.0,
        },
    },
}
BuffBlueprint { Name = 'T2EnergyStorageShieldRegenMODBonusSize8',
    BuffType = 'SHIELDREGENBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE8',
    BuffCheckFunction = AdjBuffFuncs.ShieldRegenBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        ShieldRegeneration = {
            Add = 0.15/8,
            Mult = 1.0,
        },
    },
}

BuffBlueprint { Name = 'T2EnergyStorageShieldRegenMODBonusSize12',
    BuffType = 'SHIELDREGENBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE12',
    BuffCheckFunction = AdjBuffFuncs.ShieldRegenBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        ShieldRegeneration = {
            Add = 0.15/12,
            Mult = 1.0,
        },
    },
}

BuffBlueprint { Name = 'T2EnergyStorageShieldRegenMODBonusSize16',
    BuffType = 'SHIELDREGENBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE16',
    BuffCheckFunction = AdjBuffFuncs.ShieldRegenBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        ShieldRegeneration = {
            Add = 0.15/16,
            Mult = 1.0,
        },
    },
}

BuffBlueprint { Name = 'T2EnergyStorageShieldSizeMODBonusSize4',
    BuffType = 'SHIELDSIZEBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE4',
    BuffCheckFunction = AdjBuffFuncs.ShieldSizeBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        ShieldSize = {
            Add = 0.15/4,
            Mult = 1.0,
        },
    },
}
BuffBlueprint { Name = 'T2EnergyStorageShieldSizeMODBonusSize8',
    BuffType = 'SHIELDSIZEBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE8',
    BuffCheckFunction = AdjBuffFuncs.ShieldSizeBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        ShieldSize = {
            Add = 0.15/8,
            Mult = 1.0,
        },
    },
}

BuffBlueprint { Name = 'T2EnergyStorageShieldSizeMODBonusSize12',
    BuffType = 'SHIELDSIZEBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE12',
    BuffCheckFunction = AdjBuffFuncs.ShieldSizeBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        ShieldSize = {
            Add = 0.15/12,
            Mult = 1.0,
        },
    },
}

BuffBlueprint { Name = 'T2EnergyStorageShieldHealthMODBonusSize4',
    BuffType = 'SHIELDHEALTHBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE4',
    BuffCheckFunction = AdjBuffFuncs.ShieldHealthBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        ShieldHealth = {
            Add = 0.15/4,
            Mult = 1.0,
        },
    },
}
BuffBlueprint { Name = 'T2EnergyStorageShieldHealthMODBonusSize8',
    BuffType = 'SHIELDHEALTHBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE8',
    BuffCheckFunction = AdjBuffFuncs.ShieldHealthBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        ShieldHealth = {
            Add = 0.15/8,
            Mult = 1.0,
        },
    },
}

BuffBlueprint { Name = 'T2EnergyStorageShieldHealthMODBonusSize12',
    BuffType = 'SHIELDHEALTHBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE12',
    BuffCheckFunction = AdjBuffFuncs.ShieldHealthBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        ShieldHealth = {
            Add = 0.15/12,
            Mult = 1.0,
        },
    },
}

BuffBlueprint { Name = 'T2EnergyStorageShieldHealthMODBonusSize16',
    BuffType = 'SHIELDHEALTHBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE16',
    BuffCheckFunction = AdjBuffFuncs.ShieldHealthBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        ShieldHealth = {
            Add = 0.15/16,
            Mult = 1.0,
        },
    },
}


-- TIER 3 ENERGY STORAGE
T3EnergyStorageAdjacencyMODBuffs = {
    'T3EnergyStorageEnergyProductionMODBonusSize4',
    'T3EnergyStorageEnergyProductionMODBonusSize8',
    'T3EnergyStorageEnergyProductionMODBonusSize12',
    'T3EnergyStorageEnergyProductionMODBonusSize16',
    'T3EnergyStorageEnergyProductionMODBonusSize20',
    'T3EnergyStorageShieldRegenMODBonusSize4',
    'T3EnergyStorageShieldRegenMODBonusSize8',
    'T3EnergyStorageShieldRegenMODBonusSize12',
    'T3EnergyStorageShieldRegenMODBonusSize16',
    'T3EnergyStorageShieldSizeMODBonusSize4',
    'T3EnergyStorageShieldSizeMODBonusSize8',
    'T3EnergyStorageShieldSizeMODBonusSize12',
    'T3EnergyStorageShieldHealthMODBonusSize4',
    'T3EnergyStorageShieldHealthMODBonusSize8',
    'T3EnergyStorageShieldHealthMODBonusSize12',
    'T3EnergyStorageShieldHealthMODBonusSize16',
}

BuffBlueprint { Name = 'T3EnergyStorageEnergyProductionMODBonusSize4',
    BuffType = 'ENERGYBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE4',
    BuffCheckFunction = AdjBuffFuncs.EnergyProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        EnergyProduction = {
            Add = 0.8/4,
            Mult = 1.0,
        },
    },
}

BuffBlueprint { Name = 'T3EnergyStorageEnergyProductionMODBonusSize8',
    BuffType = 'ENERGYBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE8',
    BuffCheckFunction = AdjBuffFuncs.EnergyProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        EnergyProduction = {
            Add = 0.8/8,
            Mult = 1.0,
        },
    },
}
BuffBlueprint { Name = 'T3EnergyStorageEnergyProductionMODBonusSize12',
    BuffType = 'ENERGYBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE12',
    BuffCheckFunction = AdjBuffFuncs.EnergyProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        EnergyProduction = {
            Add = 0.8/12,
            Mult = 1.0,
        },
    },
}

BuffBlueprint { Name = 'T3EnergyStorageEnergyProductionMODBonusSize16',
    BuffType = 'ENERGYBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE16',
    BuffCheckFunction = AdjBuffFuncs.EnergyProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        EnergyProduction = {
            Add = 0.8/16,
            Mult = 1.0,
        },
    },
}

BuffBlueprint { Name = 'T3EnergyStorageEnergyProductionMODBonusSize20',
    BuffType = 'ENERGYBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE20',
    BuffCheckFunction = AdjBuffFuncs.EnergyProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        EnergyProduction = {
            Add = 0.8/20,
            Mult = 1.0,
        },
    },
}

BuffBlueprint { Name = 'T3EnergyStorageShieldRegenMODBonusSize4',
    BuffType = 'SHIELDREGENBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE4',
    BuffCheckFunction = AdjBuffFuncs.ShieldRegenBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        ShieldRegeneration = {
            Add = 0.2/4,
            Mult = 1.0,
        },
    },
}
BuffBlueprint { Name = 'T3EnergyStorageShieldRegenMODBonusSize8',
    BuffType = 'SHIELDREGENBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE8',
    BuffCheckFunction = AdjBuffFuncs.ShieldRegenBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        ShieldRegeneration = {
            Add = 0.2/8,
            Mult = 1.0,
        },
    },
}
BuffBlueprint { Name = 'T3EnergyStorageShieldRegenMODBonusSize12',
    BuffType = 'SHIELDREGENBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE12',
    BuffCheckFunction = AdjBuffFuncs.ShieldRegenBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        ShieldRegeneration = {
            Add = 0.2/12,
            Mult = 1.0,
        },
    },
}

BuffBlueprint { Name = 'T3EnergyStorageShieldRegenMODBonusSize16',
    BuffType = 'SHIELDREGENBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE16',
    BuffCheckFunction = AdjBuffFuncs.ShieldRegenBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        ShieldRegeneration = {
            Add = 0.2/16,
            Mult = 1.0,
        },
    },
}

BuffBlueprint { Name = 'T3EnergyStorageShieldSizeMODBonusSize4',
    BuffType = 'SHIELDSIZEBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE4',
    BuffCheckFunction = AdjBuffFuncs.ShieldSizeBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        ShieldSize = {
            Add = 0.2/4,
            Mult = 1.0,
        },
    },
}
BuffBlueprint { Name = 'T3EnergyStorageShieldSizeMODBonusSize8',
    BuffType = 'SHIELDSIZEBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE8',
    BuffCheckFunction = AdjBuffFuncs.ShieldSizeBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        ShieldSize = {
            Add = 0.2/8,
            Mult = 1.0,
        },
    },
}

BuffBlueprint { Name = 'T3EnergyStorageShieldSizeMODBonusSize12',
    BuffType = 'SHIELDSIZEBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE12',
    BuffCheckFunction = AdjBuffFuncs.ShieldSizeBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        ShieldSize = {
            Add = 0.2/12,
            Mult = 1.0,
        },
    },
}

BuffBlueprint { Name = 'T3EnergyStorageShieldHealthMODBonusSize4',
    BuffType = 'SHIELDHEALTHBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE4',
    BuffCheckFunction = AdjBuffFuncs.ShieldHealthBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        ShieldHealth = {
            Add = 0.2/4,
            Mult = 1.0,
        },
    },
}

BuffBlueprint { Name = 'T3EnergyStorageShieldHealthMODBonusSize8',
    BuffType = 'SHIELDHEALTHBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE8',
    BuffCheckFunction = AdjBuffFuncs.ShieldHealthBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        ShieldHealth = {
            Add = 0.2/8,
            Mult = 1.0,
        },
    },
}
BuffBlueprint { Name = 'T3EnergyStorageShieldHealthMODBonusSize12',
    BuffType = 'SHIELDHEALTHBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE12',
    BuffCheckFunction = AdjBuffFuncs.ShieldHealthBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        ShieldHealth = {
            Add = 0.2/12,
            Mult = 1.0,
        },
    },
}

BuffBlueprint { Name = 'T3EnergyStorageShieldHealthMODBonusSize16',
    BuffType = 'SHIELDHEALTHBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE16',
    BuffCheckFunction = AdjBuffFuncs.ShieldHealthBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        ShieldHealth = {
            Add = 0.2/16,
            Mult = 1.0,
        },
    },
}




##################################################################
## TIER 1 MASS STORAGE
##################################################################

T1MassStorageAdjacencyMODBuffs = {
    'T1MassStorageMassProductionMODBonusSize4',
    'T1MassStorageMassProductionMODBonusSize8',
    'T1MassStorageMassProductionMODBonusSize12',
    'T1MassStorageMassProductionMODBonusSize16',
    'T1MassStorageMassProductionMODBonusSize20',   
}

##################################################################
## MASS PRODUCTION BONUS - TIER 1 MASS STORAGE
##################################################################

BuffBlueprint {
    Name = 'T1MassStorageMassProductionMODBonusSize4',
    DisplayName = 'T1MassStorageMassProductionMODBonus',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE4',
    BuffCheckFunction = AdjBuffFuncs.MassProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.MassProductionBuffRemove,
    Affects = {
        MassProduction = {
            Add = 0.4/4,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T1MassStorageMassProductionMODBonusSize8',
    DisplayName = 'T1MassStorageMassProductionMODBonus',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE8',
    BuffCheckFunction = AdjBuffFuncs.MassProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.MassProductionBuffRemove,
    Affects = {
        MassProduction = {
            Add = 0.4/8,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T1MassStorageMassProductionMODBonusSize12',
    DisplayName = 'T1MassStorageMassProductionMODBonus',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE12',
    BuffCheckFunction = AdjBuffFuncs.MassProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.MassProductionBuffRemove,
    Affects = {
        MassProduction = {
            Add = 0.4/12,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T1MassStorageMassProductionMODBonusSize16',
    DisplayName = 'T1MassStorageMassProductionMODBonus',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE16',
    BuffCheckFunction = AdjBuffFuncs.MassProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.MassProductionBuffRemove,
    Affects = {
        MassProduction = {
            Add = 0.4/16,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T1MassStorageMassProductionMODBonusSize20',
    DisplayName = 'T1MassStorageMassProductionMODBonus',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE20',
    BuffCheckFunction = AdjBuffFuncs.MassProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.MassProductionBuffRemove,
    Affects = {
        MassProduction = {
            Add = 0.4/20,
            Mult = 1.0,
        },
    },
}

T2MassStorageAdjacencyMODBuffs = {
    'T2MassStorageMassProductionMODBonusSize4',
    'T2MassStorageMassProductionMODBonusSize8',
    'T2MassStorageMassProductionMODBonusSize12',
    'T2MassStorageMassProductionMODBonusSize16',
    'T2MassStorageMassProductionMODBonusSize20',
}

BuffBlueprint { Name = 'T2MassStorageMassProductionMODBonusSize4',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE4',
    BuffCheckFunction = AdjBuffFuncs.MassProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        MassProduction = {
            Add = 0.6/4,
            Mult = 1.0,
        },
    },
}
BuffBlueprint { Name = 'T2MassStorageMassProductionMODBonusSize8',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE8',
    BuffCheckFunction = AdjBuffFuncs.MassProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        MassProduction = {
            Add = 0.6/8,
            Mult = 1.0,
        },
    },
}

BuffBlueprint { Name = 'T2MassStorageMassProductionMODBonusSize12',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE12',
    BuffCheckFunction = AdjBuffFuncs.MassProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        MassProduction = {
            Add = 0.6/12,
            Mult = 1.0,
        },
    },
}
BuffBlueprint { Name = 'T2MassStorageMassProductionMODBonusSize16',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE16',
    BuffCheckFunction = AdjBuffFuncs.MassProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        MassProduction = {
            Add = 0.6/16,
            Mult = 1.0,
        },
    },
}

BuffBlueprint { Name = 'T2MassStorageMassProductionMODBonusSize20',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE20',
    BuffCheckFunction = AdjBuffFuncs.MassProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        MassProduction = {
            Add = 0.6/20,
            Mult = 1.0,
        },
    },
}

T3MassStorageAdjacencyMODBuffs = {
    'T3MassStorageMassProductionMODBonusSize4',
    'T3MassStorageMassProductionMODBonusSize8',
    'T3MassStorageMassProductionMODBonusSize12',
    'T3MassStorageMassProductionMODBonusSize16',
    'T3MassStorageMassProductionMODBonusSize20',
}

BuffBlueprint { Name = 'T3MassStorageMassProductionMODBonusSize4',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE4',
    BuffCheckFunction = AdjBuffFuncs.MassProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        MassProduction = {
            Add = 0.8/4,
            Mult = 1.0,
        },
    },
}
BuffBlueprint { Name = 'T3MassStorageMassProductionMODBonusSize8',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE8',
    BuffCheckFunction = AdjBuffFuncs.MassProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        MassProduction = {
            Add = 0.8/8,
            Mult = 1.0,
        },
    },
}
BuffBlueprint { Name = 'T3MassStorageMassProductionMODBonusSize12',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE12',
    BuffCheckFunction = AdjBuffFuncs.MassProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        MassProduction = {
            Add = 0.8/12,
            Mult = 1.0,
        },
    },
}
BuffBlueprint { Name = 'T3MassStorageMassProductionMODBonusSize16',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE16',
    BuffCheckFunction = AdjBuffFuncs.MassProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        MassProduction = {
            Add = 0.8/16,
            Mult = 1.0,
        },
    },
}
BuffBlueprint { Name = 'T3MassStorageMassProductionMODBonusSize20',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE20',
    BuffCheckFunction = AdjBuffFuncs.MassProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        MassProduction = {
            Add = 0.8/20,
            Mult = 1.0,
        },
    },
}
HydrocarbonAdjacencyMODBuffs = {
       --'T2PowerEnergyBuildMODBonusSize4',
    --'T2PowerEnergyBuildMODBonusSize8',
    'T2PowerEnergyBuildMODBonusSize12',
    'T2PowerEnergyBuildMODBonusSize16',
    'T2PowerEnergyBuildMODBonusSize20',
    --'T2PowerEnergyWeaponMODBonusSize4',
    --'T2PowerEnergyWeaponMODBonusSize8',
    'T2PowerEnergyWeaponMODBonusSize12',
    'T2PowerEnergyWeaponMODBonusSize16',
    'T2PowerEnergyWeaponMODBonusSize20',
    --'T2PowerEnergyMaintenanceMODBonusSize4',
    --'T2PowerEnergyMaintenanceMODBonusSize8',
    'T2PowerEnergyMaintenanceMODBonusSize12',
    'T2PowerEnergyMaintenanceMODBonusSize16',
    'T2PowerEnergyMaintenanceMODBonusSize20',      
}