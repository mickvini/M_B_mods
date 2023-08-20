
do
    for i = 1, 5 do
        if i ~= 4 then
            BuffBlueprint {
                Name = 'ResearchItemBuff' .. i, DisplayName = 'ResearchItemBuff' .. i,
                BuffType = 'RESEARCH', Stacks = 'ALWAYS', Duration = -1,
                Affects = {
                    BuildRate    = {Add = (i/100), Mult = 1},
                    EnergyActive = {Add = 0, Mult = 1-(i/100)},
                    MassActive   = {Add = 0, Mult = 1-(i/100)},
                },
            }
        end
    end
end

BuffBlueprint {
    Name = 'ResearchAIxBuff', DisplayName = 'ResearchAIxBuff',
    BuffType = 'RESEARCH', Stacks = 'ALWAYS', Duration = -1,
    Affects = {
        --Research buffs are passed on as upgrades, so the final upgrade gets 3 instances of these.
        BuildRate = {Add = 0, Mult = 1 + (0.10 / 3)},
        EnergyActive = {Add = -0.2, Mult = 1},
        MassActive = {Add = -0.2, Mult = 1},
    },
}

BuffBlueprint {
    Name = 'ResearchAIBuff', DisplayName = 'ResearchAIBuff',
    BuffType = 'RESEARCH', Stacks = 'ALWAYS', Duration = -1,
    Affects = {
        --Research buffs are passed on as upgrades, so the final upgrade gets 3 instances of these.
        EnergyActive = {Add = -0.1, Mult = 1},
        MassActive = {Add = -0.1, Mult = 1},
    },
}
BuffBlueprint {
    Name = 'StructureHealthMod' .. 5, DisplayName = 'StructureHealthMod' .. 5,
    BuffType = 'StructureHealthBuff', Stacks = 'REPLACE', Duration = -1,
    Affects = {        
        MaxHealth = {Add = 0, Mult = 1 + 0.6},        
    },
}
BuffBlueprint {
    Name = 'ConstrctionBotMod' .. 5, DisplayName = 'ConstrctionBotMod' .. 5,
    BuffType = 'ConstrctionBuildRateAndHealthMod', Stacks = 'REPLACE', Duration = -1,
    Affects = {        
        MaxHealth = {Add = 0, Mult = 1 + 1},
        BuildRate = {Add = 0, Mult = 1 + 0.6},        
    },
}
BuffBlueprint {
    Name = 'EngineerStationMod' .. 5, DisplayName = 'EngineerStationMod' .. 5,
    BuffType = 'EngineerStationMod', Stacks = 'REPLACE', Duration = -1,
    Affects = {        
        MaxHealth = {Add = 0, Mult = 1 + 1.2},
        BuildRate = {Add = 0, Mult = 1 + 0.8},        
    },
}
BuffBlueprint {
    Name = 'HealthBuffLand' .. 5, DisplayName = 'HealthBuffLand' .. 5,
    BuffType = 'HealthBuffLand', Stacks = 'REPLACE', Duration = -1,
    Affects = {        
        MaxHealth = {Add = 0, Mult = 1 + 1.5},  
        Regen = {Add = 15, Mult = 1},              
    },
}
BuffBlueprint {
    Name = 'WeaponBuffLand' .. 5, DisplayName = 'WeaponBuffLand' .. 5,
    BuffType = 'WeaponBuffLand', Stacks = 'REPLACE', Duration = -1,
    Affects = {        
        --Damage = {Add = 0, Mult = 1 + i/10*4},  
        DamageRadius = {Add = 0, Mult = 1 + 0.3},  
        MaxRadius = {Add = 0, Mult = 1 + 0.2},
        RateOfFire = {Add = 0, Mult = 1 - 0.55},            
    },
}
BuffBlueprint {
    Name = 'HealthBuffAir' .. 5, DisplayName = 'HealthBuffAir' .. 5,
    BuffType = 'HealthBuffAir', Stacks = 'REPLACE', Duration = -1,
    Affects = {        
        MaxHealth = {Add = 0, Mult = 1 + 0.5},  
        Regen = {Add = 8, Mult = 1},              
    },
}
BuffBlueprint {
    Name = 'MobileBuffNaval' .. 5, DisplayName = 'MobileBuffNaval' .. 5,
    BuffType = 'MobileBuffNaval', Stacks = 'REPLACE', Duration = -1,
    Affects = {        
        MoveMult = {Add = 0, Mult = 1 + 0.08},  
        AccMult = {Add = 0, Mult = 1 + 0.25}, 
        TurnMult = {Add = 0, Mult = 1 + 0.08},             
    },
}
BuffBlueprint {
    Name = 'HealthBuffTurret'.. 5, DisplayName = 'HealthBuffTurret'.. 5,
    BuffType = 'HealthBuffTurret', Stacks = 'REPLACE', Duration = -1,
    Affects = {        
        MaxHealth = {Add = 0, Mult = 1 + 1.4},  
        --Regen = {Add = 1 + i/10, Mult = 1 + i/10},              
    },
}

BuffBlueprint {
    Name = 'WeaponBuffTurret' .. 5, DisplayName = 'WeaponBuffTurret' .. 5,
    BuffType = 'WeaponBuffTurret', Stacks = 'REPLACE', Duration = -1,
    Affects = {        
        --Damage = {Add = 0, Mult = 1 + i/10},  
        DamageRadius = {Add = 0, Mult = 1 + 0.4},  
        MaxRadius = {Add = 0, Mult = 1 + 0.24},
        RateOfFire = {Add = 0, Mult = 1 - 0.6},            
    },
}    
do
    for i = 1,4 do 
        BuffBlueprint {
            Name = 'StructureHealthMod' .. i, DisplayName = 'StructureHealthMod' .. i,
            BuffType = 'StructureHealthBuff', Stacks = 'REPLACE', Duration = -1,
            Affects = {        
                MaxHealth = {Add = 0, Mult = 1 + i/10},        
            },
        }
        BuffBlueprint {
            Name = 'ConstrctionBotMod' .. i, DisplayName = 'ConstrctionBotMod' .. i,
            BuffType = 'ConstrctionBuildRateAndHealthMod', Stacks = 'REPLACE', Duration = -1,
            Affects = {        
                MaxHealth = {Add = 0, Mult = 1 + i/10*2},
                BuildRate = {Add = 0, Mult = 1 + i/10},        
            },
        }
        BuffBlueprint {
            Name = 'EngineerStationMod' .. i, DisplayName = 'EngineerStationMod' .. i,
            BuffType = 'EngineerStationMod', Stacks = 'REPLACE', Duration = -1,
            Affects = {        
                MaxHealth = {Add = 0, Mult = 1 + i/5},
                BuildRate = {Add = 0, Mult = 1 + i/10},        
            },
        }
        BuffBlueprint {
            Name = 'HealthBuffLand' .. i, DisplayName = 'HealthBuffLand' .. i,
            BuffType = 'HealthBuffLand', Stacks = 'REPLACE', Duration = -1,
            Affects = {        
                MaxHealth = {Add = 0, Mult = 1 + i/10*2.5},  
                Regen = {Add = 2*i, Mult = 1},              
            },
        }        
        BuffBlueprint {
            Name = 'WeaponBuffLand' .. i, DisplayName = 'WeaponBuffLand' .. i,
            BuffType = 'WeaponBuffLand', Stacks = 'REPLACE', Duration = -1,
            Affects = {        
                --Damage = {Add = 0, Mult = 1 + i/10*4},  
                DamageRadius = {Add = 0, Mult = 1 + i/20},  
                MaxRadius = {Add = 0, Mult = 1 + i/10*0.4},
                RateOfFire = {Add = 0, Mult = 1 - 0.05 - i/10},            
            },
        }
        BuffBlueprint {
            Name = 'HealthBuffAir' .. i, DisplayName = 'HealthBuffAir' .. i,
            BuffType = 'HealthBuffAir', Stacks = 'REPLACE', Duration = -1,
            Affects = {        
                MaxHealth = {Add = 0, Mult = 1 + i/10},  
                Regen = {Add = 1*i, Mult = 1},              
            },
        }
        BuffBlueprint {
            Name = 'MobileBuffNaval' .. i, DisplayName = 'MobileBuffNaval' .. i,
            BuffType = 'MobileBuffNaval', Stacks = 'REPLACE', Duration = -1,
            Affects = {        
                MoveMult = {Add = 0, Mult = 1 + 0.01 +i/100},  
                AccMult = {Add = 0, Mult = 1 + i/20}, 
                TurnMult = {Add = 0, Mult = 1 + 0.01 +i/100},             
            },
        }
        BuffBlueprint {
            Name = 'HealthBuffTurret'.. i, DisplayName = 'HealthBuffTurret'.. i,
            BuffType = 'HealthBuffTurret', Stacks = 'REPLACE', Duration = -1,
            Affects = {        
                MaxHealth = {Add = 0, Mult = 1 + i/5},  
                --Regen = {Add = 1 + i/10, Mult = 1 + i/10},              
            },
        }

        BuffBlueprint {
            Name = 'WeaponBuffTurret' .. i, DisplayName = 'WeaponBuffTurret' .. i,
            BuffType = 'WeaponBuffTurret', Stacks = 'REPLACE', Duration = -1,
            Affects = {        
                --Damage = {Add = 0, Mult = 1 + i/10},  
                DamageRadius = {Add = 0, Mult = 1 + 0.05 + i/20},  
                MaxRadius = {Add = 0, Mult = 1 + i/25},
                RateOfFire = {Add = 0, Mult = 1 - 0.05- i/10},            
            },
        }    
    end
end
do
    for i = 1,3 do
        BuffBlueprint {
            Name = 'MobileBuffAir' .. i, DisplayName = 'MobileBuffAir' .. i,
            BuffType = 'MobileBuffAir', Stacks = 'REPLACE', Duration = -1,
            Affects = {        
                MoveMult = {Add = 0, Mult = 1 + i/50},  
                AccMult = {Add = 0, Mult = 1 + i/20}, 
                TurnMult = {Add = 0, Mult = 1 + i/25},               
            },
        }
        BuffBlueprint {
            Name = 'HealthBuffNaval' .. i, DisplayName = 'HealthBuffNaval' .. i,
            BuffType = 'HealthBuffNaval', Stacks = 'REPLACE', Duration = -1,
            Affects = {        
                MaxHealth = {Add = 0, Mult = 1 + i/4},  
                Regen = {Add = 2 + i*4, Mult = 1},              
            },
        }
    end
end
BuffBlueprint {
    Name = 'MobileBuffAir' .. 4, DisplayName = 'MobileBuffAir' .. 4,
    BuffType = 'MobileBuffAir', Stacks = 'REPLACE', Duration = -1,
    Affects = {        
        MoveMult = {Add = 0, Mult = 1 + 0.08},  
        AccMult = {Add = 0, Mult = 1 + 0.2}, 
        TurnMult = {Add = 0, Mult = 1 + 0.2},               
    },
}
BuffBlueprint {
    Name = 'MobileBuffAir' .. 5, DisplayName = 'MobileBuffAir' .. 5,
    BuffType = 'MobileBuffAir', Stacks = 'REPLACE', Duration = -1,
    Affects = {        
        MoveMult = {Add = 0, Mult = 1 + 0.1},  
        AccMult = {Add = 0, Mult = 1 + 0.25}, 
        TurnMult = {Add = 0, Mult = 1 + 0.28},               
    },
}
BuffBlueprint {
    Name = 'HealthBuffNaval' .. 4, DisplayName = 'HealthBuffNaval' .. 4,
    BuffType = 'HealthBuffNaval', Stacks = 'REPLACE', Duration = -1,
    Affects = {        
        MaxHealth = {Add = 0, Mult = 1 + 1.2},  
        Regen = {Add = 20, Mult = 1},              
    },
}
BuffBlueprint {
    Name = 'HealthBuffNaval' .. 5, DisplayName = 'HealthBuffNaval' .. 5,
    BuffType = 'HealthBuffNaval', Stacks = 'REPLACE', Duration = -1,
    Affects = {        
        MaxHealth = {Add = 0, Mult = 1 + 1.8},  
        Regen = {Add = 25, Mult = 1},              
    },
}
do
    local maxRadiusPercent = {0.06, 0.09, 0.12, 0.15, 0.20}
    local rateOfFirePercent = {0.06, 0.09, 0.12, 0.15, 0.20}
    local damageRadiusPercent = {0.04, 0.08, 0.16, 0.24, 0.50}

    for i = 1, 5 do  
        BuffBlueprint {
            Name = 'WeaponBuffNaval' .. i, DisplayName = 'WeaponBuffNaval' .. i,
            BuffType = 'WeaponBuffNaval', Stacks = 'REPLACE', Duration = -1,
            Affects = {        
                MaxRadius = {Add = 0, Mult = 1 + maxRadiusPercent[i]},
                RateOfFire = {Add = 0, Mult = 1 - rateOfFirePercent[i]},  
                DamageRadius = {Add = 0, Mult = 1 + damageRadiusPercent[i]},              
            },
        }
    end
end

do
    for i = 1, 5 do  
        
        BuffBlueprint {
            Name = 'MobileBuffLand' .. i, DisplayName = 'MobileBuffLand' .. i,
            BuffType = 'MobileBuffLand' , Stacks = 'REPLACE', Duration = -1,
            Affects = {        
                MoveMult = {Add = 0, Mult = 1 + i/50},  
                AccMult = {Add = 0, Mult = 1 + i/20}, 
                TurnMult = {Add = 0, Mult = 1 + i/50},               
            },
        }     

        BuffBlueprint {
            Name = 'WeaponBuffAir' .. i, DisplayName = 'WeaponBuffAir' .. i,
            BuffType = 'WeaponBuffAir', Stacks = 'REPLACE', Duration = -1,
            Affects = {        
                --Damage = {Add = 0, Mult = 1.10 + i/10},  
                DamageRadius = {Add = 0, Mult = 1 + i/50},  
                MaxRadius = {Add = 0, Mult = 1 + i*3/100},
                RateOfFire = {Add = 0, Mult = 1 - i/20},            
            },
        }      
        
    end
end