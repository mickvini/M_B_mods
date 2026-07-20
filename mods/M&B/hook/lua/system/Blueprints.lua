--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

function NotAirCrashWeapon(weapon)
    return weapon.DisplayName ~= 'Air Crash'
end

function NotDeathNukeWeapon(weapon)
    return weapon.DisplayName ~= 'Death Nuke'
end

function NotDeath(weapon)
    return weapon.WeaponCategory ~= 'Death'
end

function IsTank(bp)
    if bp.Description ~= nil then
        return string.find(bp.Description, 'танк')          
    end
end

function IsBot(bp)
    if bp.Description ~= nil then
        return string.find(bp.Description, 'бот')          
    end
end

function IsHover(bp)
    if bp.Description ~= nil then
        return string.find(bp.Description, 'ховер')          
    end
end

function ChangeWeaponDamage(bp, damageMod)
    if IsBot(bp) or IsTank(bp) or IsHover(bp) then
        if bp.Weapon ~= nil then
            for _, weapon in bp.Weapon do
                if NotDeath(weapon) or NotAirCrashWeapon(weapon) or NotDeathNukeWeapon(weapon) then
                    weapon.Damage = weapon.Damage * damageMod
                end
            end
        end
    end
end

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)
    OldModBlueprints(all_blueprints)
    -- local damageMod = 1.0
    -- for _, bp in all_blueprints.Unit do
    --     ChangeWeaponDamage(bp, damageMod)
    -- end
    RNDPrepareScript(all_blueprints.Unit)
    -- RNDPrepareScriptFORTECH4(all_blueprints.Unit)
    -- RestrictExistingBlueprints(all_blueprints.Unit)
    --RNDDefineNewFactoryBuildCategories(all_blueprints.Unit)
    GenerateResearchItemBPs(all_blueprints.Unit)
    -- for id, bp in all_blueprints.Unit do
    --    if table.find(bp.Categories, 'MASSEXTRACTION') and table.find(bp.Categories, 'EXPERIMENTAL') then
    --         LOG(unpack(bp.Categories))
    --         table.removeByValue(bp.Categories, 'BUILTBYTIER3ENGINEER')
    --         table.removeByValue(bp.Categories, 'BUILTBYTIER3COMMANDER')
           
    --    end
        
    -- end
    GenerateNavalWreckage(all_blueprints)
    
end
function GenerateNavalWreckage(all_blueprints)
    for id, bp in pairs(all_blueprints.Unit) do             
        
            local cats = {}

            if bp.Categories then
                
                for k,cat in pairs(bp.Categories) do
                    cats[cat] = true
                end
            
                if cats.NAVAL then
                
                    if not bp.Wreckage then
                    
                        bp.Wreckage = {
                            Blueprint = '/props/DefaultWreckage/DefaultWreckage_prop.bp',
                            EnergyMult = 0.3,
                            HealthMult = 0.9,
                            LifeTime = 720, -- give naval wreckage a lifetime value of 12 minutes
                            MassMult = 0.5,
                            ReclaimTimeMultiplier = 1.2,
                            
                            WreckageLayers = {
                                Air = false,
                                Land = false,
                                Seabed = true,
                                Sub = true,
                                Water = true,
                            };
                        }
                    else
                        local wl = bp.Wreckage.WreckageLayers
                        wl.Seabed = true
                        wl.Sub = true
                        wl.Water = true
                        bp.Wreckage.LifeTime = 720
                    end
                    
                else
                
                    if bp.Wreckage then
                    
                        if not bp.Wreckage.LifeTime then

                            bp.Wreckage.LifeTime = 900
                            
                        end
                        
                        if bp.Wreckage.MassMult and bp.Wreckage.MassMult > 0.2 then
                        
                            bp.Wreckage.MassMult = bp.Wreckage.MassMult * 0.5
                            
                            bp.Wreckage.ReclaimTimeMultiplier = 1.2
                            
                        end
                    end
                end
            end
    end
end
--function WikiBlueprints(all_blueprints)
  --  for id, bp in pairs(all_blueprints.Unit) do
   --     local t = table.find(bp.Categories, 'TECH4') and 4 or table.find(bp.Categories, 'TECH3') and 3 or table.find(bp.Categories, 'TECH2') and 2 or table.find(bp.Categories, 'TECH1') and 1
   --     if TableFindSubstrings(bp.Categories, 'BUILTBY', 'FACTORY') and bp.Physics then
   --         if bp.Physics.MotionType == 'RULEUMT_Hover' or bp.Physics.MotionType == 'RULEUMT_AmphibiousFloating' then
    --            for i = t, 3 do
   --                 table.insert(bp.Categories, 'BUILTBYTIER'..i..'SURFACEFACTORY')
   --             end
    --        elseif bp.Physics.MotionType == 'RULEUMT_Amphibious' then
    --            for i = t, 3 do
   --                 table.insert(bp.Categories, 'BUILTBYTIER'..i..'SEABEDFACTORY')
   --             end
   --         end
   --     end
   --     local catIndex = table.find(bp.Categories, 'BUILTBYENGINEER')
  --      if catIndex then
  --          bp.Categories[catIndex] = 'BUILTBYTIER1ENGINEER'
 --           table.insert(bp.Categories, 'BUILTBYTIER2ENGINEER')
  --          table.insert(bp.Categories, 'BUILTBYTIER3ENGINEER')
  --      end
  --  end
--end

--------------------------------------------------------------------------------
-- Things in preparation of RND
--------------------------------------------------------------------------------
function RNDPrepareScript(all_bps)
    for id, bp in all_bps do
        --Hard link upgrades, instead of soft-category linking, to prevent splurged links
        --If they don't have a buildable category, we probably don't want to mess with it, and the upgrade tag is probably a mistake. Also make sure the thing exists.
        
        if bp.Categories and id ~= 'zzz6969' then -- zzz6969 is a cat dump unit for compatibility
            --Create extended tech 1 restriction and allow the ACU to build them after the research
            if table.find(bp.Categories, 'BUILTBYTIER1ENGINEER') and not table.find(bp.Categories, 'BUILTBYCOMMANDER') then
                table.insert(bp.Categories, 'RESEARCHLOCKEDTECH1')
                table.insert(bp.Categories, 'BUILTBYCOMMANDER')
            end
            --CategoryArrayRemoveTierN(all_bps, bp.Economy.BuildableCategory)
            --CategoryArrayRemoveTierN(all_bps, bp.Categories)
            if table.find(bp.Categories, 'CONSTRUCTIONSORTDOWN') then
                table.removeByValue(bp.Categories, 'CONSTRUCTIONSORTDOWN')
            end
            if table.find(bp.Categories, 'BUILTBYCOMMANDER') and not table.find(bp.Categories, 'BUILTBYTIER1ENGINEER') then
                table.insert(bp.Categories, 'BUILTBYTIER1ENGINEER')
            elseif not table.find(bp.Categories, 'BUILTBYCOMMANDER') and table.find(bp.Categories, 'BUILTBYTIER1ENGINEER') then
                table.insert(bp.Categories, 'BUILTBYCOMMANDER')
            end
        end
        --if bp.General.UpgradesTo and bp.Economy.BuildableCategory and not table.find(bp.Economy.BuildableCategory, bp.General.UpgradesTo) and all_bps[bp.General.UpgradesTo] then
        --    table.insert(bp.Economy.BuildableCategory, bp.General.UpgradesTo)
        --    table.remove(all_bps[bp.General.UpgradesTo].Categories, TableFindSubstrings(all_bps[bp.General.UpgradesTo].Categories, 'BUILTBY', 'FACTORY'))
        --end
       
    end
end
-- function RNDPrepareScriptFORTECH4(all_bps)
--     for id, bp in all_bps do
--         --Hard link upgrades, instead of soft-category linking, to prevent splurged links
--         --If they don't have a buildable category, we probably don't want to mess with it, and the upgrade tag is probably a mistake. Also make sure the thing exists.
--         if bp.General.UpgradesTo and bp.Economy.BuildableCategory and not table.find(bp.Economy.BuildableCategory, bp.General.UpgradesTo) and all_bps[bp.General.UpgradesTo] then
--             table.insert(bp.Economy.BuildableCategory, bp.General.UpgradesTo)
--             table.remove(all_bps[bp.General.UpgradesTo].Categories, TableFindSubstrings(all_bps[bp.General.UpgradesTo].Categories, 'BUILTBY', 'FACTORY'))
--         end
--         if bp.Categories and id ~= 'zzz6969' then -- zzz6969 is a cat dump unit for compatibility
--             --Create extended tech 1 restriction and allow the ACU to build them after the research
--             if table.find(bp.Categories, 'EXPERIMENTAL') and not table.find(bp.Categories, 'NEEDMOBILEBUILD') then
--                 table.insert(bp.Categories, 'TECH4')             
--             end
--             CategoryArrayRemoveTierN(all_bps, bp.Economy.BuildableCategory)
--             CategoryArrayRemoveTierN(all_bps, bp.Categories)
--             if table.find(bp.Categories, 'CONSTRUCTIONSORTDOWN') then
--                 table.removeByValue(bp.Categories, 'CONSTRUCTIONSORTDOWN')
--             end           
--         end
--         if bp.General.UpgradesTo and bp.Economy.BuildableCategory and not table.find(bp.Economy.BuildableCategory, bp.General.UpgradesTo) and all_bps[bp.General.UpgradesTo] then
--             table.insert(bp.Economy.BuildableCategory, bp.General.UpgradesTo)
--             table.remove(all_bps[bp.General.UpgradesTo].Categories, TableFindSubstrings(all_bps[bp.General.UpgradesTo].Categories, 'BUILTBY', 'FACTORY'))
--         end
       
--     end
-- end

--------------------------------------------------------------------------------
-- Restrict a few vanilla units
--------------------------------------------------------------------------------
-- function RestrictExistingBlueprints(all_bps)
--     local restrict = {        
--         'zzz6969',-- 'uab1101', 'urb1101', 'xsb1101', --Tech 1 power generators.
--         --'ueb1106', 'uab1106', 'urb1106', 'xsb1106', -- tech 1 mass storage
--         --'ueb2106', 'uab2106', 'urb2106', 'xsb2106', -- tech 2 mass storage
--         --'ueb3106', 'uab3106', 'urb3106', 'xsb3106', -- tech 3 mass storage
--         --'urb0101', 'ueb0101', 'uab0101', 'xsb0101', -- tier 0 land factories  
--         --'uab1104', 'ueb1104', 'urb1104', 'xsb1104', -- T2 mass fabs
--         --'uab1304', 'ueb1304', 'urb1304', 'xsb1304', -- T3 mass fabs      
--         --'ueb1201', 'uab1201', 'urb1201', 'xsb1201',--Tech 2 power generators, slow down tech 2 with the half reactors.
--         --'ueb1301', 'uab1301', 'urb1301', 'xsb1301',--Tech 3 power generators, slow down tech 2 with the half reactors.
--         --'seb1201', 'sab1201', 'srb1201', 'ssb1201',
--         --uef vanilla air
--         --'uea0101', 'uea0102', 'uea0103', 'uea0204',
--         --'uea0203', 'uea0206', 'uea0302', 'uea0304',
-- 		--'uea0303',
-- 		--cybran vanilla air
--         --'ura0101', 'ura0102', 'ura0103', 'ura0204',
--         --'ura0203', 'ura0206', 'ura0302', 'ura0304',
-- 		--'ura0303', 'xra0105',
-- 		--aeon vanilla air
-- 		--'uaa0101', 'uaa0102', 'uaa0103', 'uaa0204',
--         --'uaa0203', 'uaa0206', 'uaa0302', 'uaa0304',
-- 		--'uaa0303', 'xaa0202', 'daa0206', 'xaa0306',
-- 		--'xaa0305',
--         --seraph vanilla air
--         --'xsa0101', 'xsa0102', 'xsa0103', 'xsa0204',
--         --'xsa0203', 'xsa0206', 'xsa0302', 'xsa0304',
-- 		--'xsa0303', 
-- 		--uef vanilla land
-- 		--'uel0104', 'uel0103',
-- 		--'uel0202', 'uel0107', 'uel0307', 'uel0111',
-- 		--'uel0203', 'uel0303', 'uel0305', 'uel0304', 
-- 		--'uel0308',
-- 		--cybran vanilla land
-- 		--'url0104', 'url0103',
-- 		--'drl0204', 'url0203', 'url0111', 'url0205', 
-- 		--'xrl0305', 'url0303', 'url0305', 'url0306', 
-- 		--'url0304',
-- 		--aeon vanilla land
-- 		--'ual0107', 'ual0103', 'ual0104', 
-- 		--'ual0201', 'ual0205', 'xal0203', 'ual0111', 
-- 		--'ual0204', 'ual0302', 'ual0304', 'ual0310',
-- 		--'dal0310',
-- 		-- serphim vanilla land
-- 		--'xsl0104', 'xsl0201', 'xsl0103',
-- 		--'xsl0202', 'xsl0203', 'xsl0205', 'xsl0111',
-- 		--'ssl0222', 'xsl0303', 'xsl0304', 'xsl0307', 
-- 		--'xsl0305', 'xsl0310a'        
--     }
--     for i, id in restrict do
--         if all_bps[id] then
--             table.insert(all_bps[id].Categories, 'RESEARCHLOCKED')
--         end
--     end
-- end

--------------------------------------------------------------------------------
-- Create build categories for the amphib/sub/seaplane factories
--------------------------------------------------------------------------------
function RNDDefineNewFactoryBuildCategories(all_bps)
    for id, bp in all_bps do
        if TableFindSubstrings(bp.Categories, 'BUILTBY', 'FACTORY') and bp.Physics then
            if bp.Physics.MotionType == 'RULEUMT_Hover' or bp.Physics.MotionType == 'RULEUMT_AmphibiousFloating' then
                table.insert(bp.Categories, 'BUILTBYSURFACEFACTORY')
            elseif bp.Physics.MotionType == 'RULEUMT_Amphibious' then
                table.insert(bp.Categories, 'BUILTBYSEABEDFACTORY')
            end
        end
    end
end

--------------------------------------------------------------------------------
-- Make some research items
--------------------------------------------------------------------------------
function GenerateResearchItemBPs(all_bps)
    local tablesize = 0
    for id, bp in all_bps do
        tablesize = tablesize + 1
        if bp.Categories and table.find(bp.Categories, 'RESEARCHLOCKED') then
            local newid = id .. 'rnd'
            RNDGenerateBaseResearchItemBlueprint(all_bps, newid, id, bp)

            RNDGiveCategoriesAndDefineCosts(all_bps, newid, bp)
            RNDGiveIndicativeAbilities(all_bps, newid, bp)
            RNDGiveUniqueMeshBlueprints(all_bps, newid, bp)
        end
    end

    if tablesize > 10 then
        local techresearch = {
            RESEARCHLOCKEDTECH1 = {
                techid = 1,
                BuildIconSortPriority = 0,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 2800,
                    BuildTime = 1400,
                    ResearchMult = 1,
                },
                Categories = {'TECH1'},
                Description = 'Исследование Т1',
            },
            TECH2 = {
                techid = 2,
                BuildIconSortPriority = 0,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 4600,
                    BuildTime = 2000,
                    ResearchMult = 1,
                },
                Categories = {'TECH2'},
                Description = 'Исследование Т2',
            },
            TECH3 = {
                techid = 3,
                BuildIconSortPriority = 0,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 16400,
                    BuildTime = 3000,
                    ResearchMult = 1,
                },
                Categories = {'TECH3'},
                Description = 'Исследование Т3',
            },
            EXPERIMENTAL = {
                techid = 4,
                BuildIconSortPriority = 0,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 42400,
                    BuildTime = 3600,
                    ResearchMult = 1,
                },
                Categories = {'EXPERIMENTAL'},
                Description = 'Исследование экспериментального теча Т4',
            },
            TECH4 = {
                techid = 5,
                BuildIconSortPriority = 0,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 40000,
                    BuildTime = 900,
                    ResearchMult = 1,
                },
                Categories = {'EXPERIMENTAL'},
                Description = 'Исследования Т4',
            },
            MK101 = {
                techid = 101,
                BuildIconSortPriority = 1,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 1000,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH1'},
                Description = 'Усиление заводов 1-й уровень',
            },
            MK102 = {
                techid = 102,
                BuildIconSortPriority = 2,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 1200,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH1'},
                Description = 'Усиление инженеров 1-й уровень',
            },
            MK103 = {
                techid = 103,
                BuildIconSortPriority = 3,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 1440,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH1'},
                Description = 'Усиление инженерных дронов 1-й уровень',
            },
            MK104 = {
                techid = 104,
                BuildIconSortPriority = 4,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 1320,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH1'},
                Description = 'Усиление мобильности наземных юнитов 1-й уровень',
            },
            MK105 = {
                techid = 105,
                BuildIconSortPriority = 5,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 1760,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH1'},
                Description = 'Усиления очков прочности и регена наземных юнитов 1-й уровень',
            },
            MK106 = {
                techid = 106,
                BuildIconSortPriority = 6,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 2200,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH1'},
                Description = 'Оружейное усиление наземных юнитов 1-й уровень',
            },
            MK107 = {
                techid = 107,
                BuildIconSortPriority = 7,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 1320,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH1'},
                Description = 'Усиление мобильности воздушных юнитов 1-й уровень',
            },
            MK108 = {
                techid = 108,
                BuildIconSortPriority = 8,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 1760,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH1'},
                Description = 'Увеличение очков прочности и регена воздушных юнитов 1-й уровень',
            },
            MK109 = {
                techid = 109,
                BuildIconSortPriority = 9,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 2200,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH1'},
                Description = 'Оружейное усиление воздушных юнитов 1-й уровень',
            },
            MK110 = {
                techid = 110,
                BuildIconSortPriority = 10,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 1050,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH1'},
                Description = 'Улучшение мобильности водных юнитов 1-й уровень',
            },
            MK111 = {
                techid = 111,
                BuildIconSortPriority = 11,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 3200,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH1'},
                Description = 'Увеличение очков прочности и регена водных юнитов 1-й уровень',
            },
            MK112 = {
                techid = 112,
                BuildIconSortPriority = 12,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 2640,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH1'},
                Description = 'Оружейное усиление водных юнитов 1-й уровень',
            },
            MK113 = {
                techid = 113,
                BuildIconSortPriority = 13,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 2200,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH1'},
                Description = 'Усиление стационарных турелей 1-й уровень',
            },
            MK114 = {
                techid = 114,
                BuildIconSortPriority = 14,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 1760,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH1'},
                Description = 'Увеличение прочности стационарных турелей 1-й уровень',
            },                        
            MK201 = {
                techid = 201,
                BuildIconSortPriority = 1,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 1400,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH2'},
                Description = 'Усиление заводов 2-й уровень',
            },
            MK202 = {
                techid = 202,
                BuildIconSortPriority = 2,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 2400,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH2'},
                Description = 'Усиление инженеров 2-й уровень',
            },            
            MK203 = {
                techid = 203,
                BuildIconSortPriority = 3,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 2880,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH2'},
                Description = 'Улучшение инженерных дронов 2-й уровень',
            },
            MK204 = {
                techid = 204,
                BuildIconSortPriority = 4,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 1980,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH2'},
                Description = 'Усиление мобильности наземных юнитов 2-й уровень',
            },
            MK205 = {
                techid = 205,
                BuildIconSortPriority = 5,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 2640,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH2'},
                Description = 'Увеличение прочности та регена наземных юнитов 2-й уровень',
            },
            MK206 = {
                techid = 206,
                BuildIconSortPriority = 6,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 3300,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH2'},
                Description = 'Усиление оружия наземных юнитов 2-й уровень',
            },
            MK207 = {
                techid = 207,
                BuildIconSortPriority = 7,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 1980,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH2'},
                Description = 'Усиление мобильности воздушных юнитов  2-й уровень',
            },
            MK208 = {
                techid = 208,
                BuildIconSortPriority = 8,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 2640,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH2'},
                Description = 'увелиение прочности и регена воздушных юнитов 2-й уровень',
            },
            MK209 = {
                techid = 209,
                BuildIconSortPriority = 9,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 3300,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH2'},
                Description = 'Усиление оружия воздушных юнитов 2-й уровень',
            },
            MK210 = {
                techid = 210,
                BuildIconSortPriority = 10,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 1600,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH2'},
                Description = 'Улучшение мобильности водных юнитов 2-й уровень',
            },
            MK211 = {
                techid = 211,
                BuildIconSortPriority = 11,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 4800,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH2'},
                Description = 'Увеличение очков прочности и регена водных юнитов 2-й уровень',
            },
            MK212 = {
                techid = 212,
                BuildIconSortPriority = 12,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 3960,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH2'},
                Description = 'Усиление оружейной мощи водных юнитов 2-й уровень',
            },
            MK213 = {
                techid = 213,
                BuildIconSortPriority = 13,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 3300,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH2'},
                Description = 'Усиление оружейной мощи стационарных турелей 2-й уровень',
            },
            MK214 = {
                techid = 214,
                BuildIconSortPriority = 14,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 2640,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH2'},
                Description = 'Увеличение очков прочности стационарных турелей 2-й уровень',
            },
            MK301 = {
                techid = 301,
                BuildIconSortPriority = 1,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 1960,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH3'},
                Description = 'Усиление заводов 3-й уровень',
            },
            MK302 = {
                techid = 302,
                BuildIconSortPriority = 2,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 4320,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH3'},
                Description = 'Усиление инженеров 3-й уровень',
            },            
            MK303 = {
                techid = 303,
                BuildIconSortPriority = 3,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 5200,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH3'},
                Description = 'Усиление инженерных дронов 3-й уровень',
            },
            MK304 = {
                techid = 304,
                BuildIconSortPriority = 4,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 3300,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH3'},
                Description = 'Усиление мобильности наземных юнитов 3-й уровень',
            },
            MK305 = {
                techid = 305,
                BuildIconSortPriority = 5,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 4400,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH3'},
                Description = 'Увеличение очков прочности и регена наземных юнитов 3-й уровень',
            },
            MK306 = {
                techid = 306,
                BuildIconSortPriority = 6,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 5500,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH3'},
                Description = 'Усиление оружейной мощи наземных юнитов 3-й уровень',
            },
            MK307 = {
                techid = 307,
                BuildIconSortPriority = 7,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 3300,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH3'},
                Description = 'Усиление мобильности воздушных юнитов 3-й уровень',
            },
            MK308 = {
                techid = 308,
                BuildIconSortPriority = 8,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 4400,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH3'},
                Description = 'увелиение прочности и регена воздушных юнитов 3-й уровень',
            },
            MK309 = {
                techid = 309,
                BuildIconSortPriority = 9,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 5500,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH3'},
                Description = 'Усиление оружия воздушных юнитов 3-й уровень',
            },
            MK310 = {
                techid = 310,
                BuildIconSortPriority = 10,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 2600,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH3'},
                Description = 'Улучшение мобильности водных юнитов 3-й уровень',
            },
            MK311 = {
                techid = 311,
                BuildIconSortPriority = 11,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 8000,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH3'},
                Description = 'Увеличение очков прочности и регена водных юнитов 3-й уровень',
            },
            MK312 = {
                techid = 312,
                BuildIconSortPriority = 12,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 6600,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH3'},
                Description = 'Усиление оружейной мощи водных юнитов 3-й уровень',
            },
            MK313 = {
                techid = 313,
                BuildIconSortPriority = 13,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 5500,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH3'},
                Description = 'Усиление оружейной мощи стационарных турелей 3-й уровень',
            },
            MK314 = {
                techid = 314,
                BuildIconSortPriority = 14,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 4400,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'TECH3'},
                Description = 'Увеличение очков прочности стационарных турелей 3-й уровень',
            },
            MK401 = {
                techid = 401,
                BuildIconSortPriority = 1,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 2800,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'EXPERIMENTAL'},
                Description = 'Усиление заводов 4-й уровень',
            },
            MK402 = {
                techid = 402,
                BuildIconSortPriority = 2,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 6900,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'EXPERIMENTAL'},
                Description = 'Усиление инженеров 4-й уровень',
            },            
            MK403 = {
                techid = 403,
                BuildIconSortPriority = 3,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 8280,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'EXPERIMENTAL'},
                Description = 'Усиление инженерных дронов 4-й уровень',
            },
            MK404 = {
                techid = 404,
                BuildIconSortPriority = 4,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 6600,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'EXPERIMENTAL'},
                Description = 'Усиление мобильности наземных юнитов 4-й уровень',
            },
            MK405 = {
                techid = 405,
                BuildIconSortPriority = 5,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 8800,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'EXPERIMENTAL'},
                Description = 'Увеличение очков прочности и регена наземных юнитов 4-й уровень',
            },
            MK406 = {
                techid = 406,
                BuildIconSortPriority = 6,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 11000,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'EXPERIMENTAL'},
                Description = 'Усиление оружейной мощи наземных юнитов 4-й уровень',
            },
            MK407 = {
                techid = 407,
                BuildIconSortPriority = 7,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 6600,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'EXPERIMENTAL'},
                Description = 'Усиление мобильности воздушных юнитов 4-й уровень',
            },
            MK408 = {
                techid = 408,
                BuildIconSortPriority = 8,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 8800,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'EXPERIMENTAL'},
                Description = 'Увелиение прочности и регена воздушных юнитов 4-й уровень',
            },
            MK409 = {
                techid = 409,
                BuildIconSortPriority = 9,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 11000,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'EXPERIMENTAL'},
                Description = 'Усиление оружия воздушных юнитов 4-й уровень',
            },
            MK410 = {
                techid = 410,
                BuildIconSortPriority = 10,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 5200,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'EXPERIMENTAL'},
                Description = 'Улучшение мобильности водных юнитов 4-й уровень',
            },
            MK411 = {
                techid = 411,
                BuildIconSortPriority = 11,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 16000,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'EXPERIMENTAL'},
                Description = 'Увеличение очков прочности и регена водных юнитов 4-й уровень',
            },
            MK412 = {
                techid = 412,
                BuildIconSortPriority = 12,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 13200,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'EXPERIMENTAL'},
                Description = 'Усиление оружейной мощи водных юнитов 4-й уровень',
            },
            MK413 = {
                techid = 413,
                BuildIconSortPriority = 13,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 11000,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'EXPERIMENTAL'},
                Description = 'Усиление оружейной мощи стационарных турелей 4-й уровень',
            },
            MK414 = {
                techid = 414,
                BuildIconSortPriority = 14,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 8800,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'EXPERIMENTAL'},
                Description = 'Увеличение очков прочности стационарных турелей 4-й уровень',
            },
            -- MK501 = {
            --     techid = 501,
            --     BuildIconSortPriority = 1,
            --     Economy = {
            --      BuildCostEnergy = 0,
            --         BuildCostMass = 900,
            --         BuildTime = 600,
            --         ResearchMult = 1,
            --     },
            --     Categories = {'EXPERIMENTAL'},
            --     Description = 'Усиление заводов 5-й уровень',
            -- },
            MK502 = {
                techid = 502,
                BuildIconSortPriority = 2,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 9660,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'EXPERIMENTAL'},
                Description = 'Усиление инженеров 5-й уровень',
            },            
            MK503 = {
                techid = 503,
                BuildIconSortPriority = 3,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 11600,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'EXPERIMENTAL'},
                Description = 'Усиление инженерных дронов 5-й уровень',
            },
            MK504 = {
                techid = 504,
                BuildIconSortPriority = 4,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 16500,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'EXPERIMENTAL'},
                Description = 'Усиление мобильности наземных юнитов 5-й уровень',
            },
            MK505 = {
                techid = 505,
                BuildIconSortPriority = 5,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 22000,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'EXPERIMENTAL'},
                Description = 'Увеличение очков прочности и регена наземных юнитов 5-й уровень',
            },
            MK506 = {
                techid = 506,
                BuildIconSortPriority = 6,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 27500,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'EXPERIMENTAL'},
                Description = 'Усиление оружейной мощи наземных юнитов 5-й уровень',
            },
            MK507 = {
                techid = 507,
                BuildIconSortPriority = 7,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 16500,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'EXPERIMENTAL'},
                Description = 'Усиление мобильности воздушных юнитов 5-й уровень',
            },
            MK508 = {
                techid = 508,
                BuildIconSortPriority = 8,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 22000,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'EXPERIMENTAL'},
                Description = 'Увелиение прочности и регена воздушных юнитов 5-й уровень',
            },
            MK509 = {
                techid = 509,
                BuildIconSortPriority = 9,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 27500,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'EXPERIMENTAL'},
                Description = 'Усиление оружия воздушных юнитов 5-й уровень',
            },
            MK510 = {
                techid = 410,
                BuildIconSortPriority = 10,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 13200,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'EXPERIMENTAL'},
                Description = 'Улучшение мобильности водных юнитов 5-й уровень',
            },
            MK511 = {
                techid = 511,
                BuildIconSortPriority = 11,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 39600,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'EXPERIMENTAL'},
                Description = 'Увеличение очков прочности и регена водных юнитов 5-й уровень',
            },
            MK512 = {
                techid = 512,
                BuildIconSortPriority = 12,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 33000,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'EXPERIMENTAL'},
                Description = 'Усиление оружейной мощи водных юнитов 5-й уровень',
            },
            MK513 = {
                techid = 513,
                BuildIconSortPriority = 13,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 27500,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'EXPERIMENTAL'},
                Description = 'Усиление оружейной мощи стационарных турелей 5-й уровень',
            },
            MK514 = {
                techid = 514,
                BuildIconSortPriority = 14,
                Economy = {
                    BuildCostEnergy = 0,
                    BuildCostMass = 22000,
                    BuildTime = 600,
                    ResearchMult = 1,
                },
                Categories = {'EXPERIMENTAL'},
                Description = 'Увеличение очков прочности стационарных турелей 5-й уровень',
            },
        }
        for tech, bp in techresearch do
        	if bp.techid > 10 then
                table.insert(bp.Categories, 'MOD')
            end
            table.insert(bp.Categories, '')            
            table.insert(bp.Categories, 'SORTCONSTRUCTION')            
            if bp.BuildIconSortPriority >=1 and bp.BuildIconSortPriority <=3  then
            	bp.Categories[4] = 'SORTECONOMY'
            elseif bp.BuildIconSortPriority > 3 and bp.BuildIconSortPriority <=12 then
            	bp.Categories[4] = 'SORTSTRATEGIC'
            elseif bp.BuildIconSortPriority >= 13 and bp.BuildIconSortPriority <= 14 then
            	bp.Categories[4] = 'SORTDEFENSE'    
            end               
            if tech ~= 'RESEARCHLOCKEDTECH1' and bp.techid < 10  then
                if tech ~= 'TECH4' then
                    table.insert(bp.Categories,'CONSTRUCTIONSORTDOWN') 
                end                                                    
            end

            for faction, uid in {Aeon = 'sar9', UEF = 'ser9', Cybran = 'srr9', Seraphim = 'ssr9'} do
                local newid = uid .. bp.techid .. '00'
                local id = tech
                bp.Categories[3] =  string.upper(faction)
                
                -- if string.find(tech, 'MK') then

                -- 	table.removeByValue(bp.Categories, 'CONSTRUCTIONSORTDOWN')
                -- end
                
                if not bp.General then
                    bp.General = {}
                end
                if not bp.Display then
                    bp.Display = {}
                end                
                
                bp.Display.IconName = newid
                bp.General.FactionName = faction
                RNDGenerateBaseResearchItemBlueprint(all_bps, newid, id, bp)
                RNDGiveCategoriesAndDefineCosts(all_bps, newid, bp)
                all_bps[newid].Display.BuildMeshBlueprint = '/mods/M&B/meshes/tech'..bp.techid..'_mesh'
                all_bps[newid].Display.MeshBlueprint = '/mods/M&B/meshes/tech'..bp.techid..'_mesh'
                if bp.tecid > 100  and bp.techid < 200 then
                    all_bps[newid].Display.BuildMeshBlueprint = '/mods/M&B/meshes/tech'.. 1 ..'_mesh'
                    all_bps[newid].Display.MeshBlueprint = '/mods/M&B/meshes/tech'.. 1 ..'_mesh'
                elseif bp.techid>200 and bp.techid < 300  then
                    all_bps[newid].Display.BuildMeshBlueprint = '/mods/M&B/meshes/tech'.. 2 ..'_mesh'
                    all_bps[newid].Display.MeshBlueprint = '/mods/M&B/meshes/tech'.. 2 ..'_mesh'
                elseif bp.techid>300 and bp.techid < 400  then
                    all_bps[newid].Display.BuildMeshBlueprint = '/mods/M&B/meshes/tech'.. 3 ..'_mesh'
                    all_bps[newid].Display.MeshBlueprint = '/mods/M&B/meshes/tech'.. 3 ..'_mesh'
                else
                    all_bps[newid].Display.BuildMeshBlueprint = '/mods/M&B/meshes/tech'.. 4 ..'_mesh'
                    all_bps[newid].Display.MeshBlueprint = '/mods/M&B/meshes/tech'.. 4 ..'_mesh'
                end
                -- LOG(repr(all_bps[newid]))
            end            
            
        end
    end
end

function RNDGenerateBaseResearchItemBlueprint(all_bps, newid, id, bp)
    local sizescale = math.max( ((bp.Physics.SkirtSizeX or bp.SizeX or 4) / 2), ((bp.Physics.SkirtSizeZ or bp.SizeZ or 4) / 2) )
    all_bps[newid] = {
        BlueprintId = newid,
        ResearchId = id,
        BuildIconSortPriority = bp.BuildIconSortPriority or 5,
        Categories = {
            'BUILTBYRESEARCH',
            -- Engine stuff?
            'VISIBLETORECON',
            'BENIGN',
            -- And now some lies.
            'SELECTABLE',
            --'MOBILE',
        },
        Defense = {
            ArmorType = 'Normal',
            Health = 5000,
            MaxHealth = 5000,
        },
        Description = bp.Description,
        Display = {
            Abilities = {
                '<LOC ability_rnd_unlock>Research Unlock',
            },
            --IconName = id,
            UniformScale = (bp.Display.UniformScale or 0.2) / sizescale, --calculate properly based on footprint size
        },
        Footprint = {
            SizeX = 2,
            SizeZ = 2,
        },
        Economy = {
            BuildCostEnergy = bp.Economy.BuildCostEnergy * (bp.Economy.ResearchMultEnergy or bp.Economy.ResearchMult or  1),
            BuildCostMass = bp.Economy.BuildCostMass * (bp.Economy.ResearchMultMass or bp.Economy.ResearchMult or  1),
            BuildTime = bp.Economy.BuildTime * 10 * (bp.Economy.ResearchMultTime or bp.Economy.ResearchMult or  1),
        },
        Interface = {
            HelpText = bp.Description,
        },
        LifeBarHeight = 0.075,
        LifeBarOffset = 1.25,
        LifeBarSize = 2.5,
        General = {
            CapCost = 0,
            FactionName = bp.General.FactionName,
            Icon = bp.General.Icon or 'air',
            TechLevel = 'RULEUTL_Advanced',
            UnitName = bp.General.UnitName,
            UnitWeight = 1,
        },
        Physics = {
            MeshExtentsX = (bp.Physics.MeshExtentsX or bp.SizeX or sizescale * 2) / sizescale,
            MeshExtentsY = (bp.Physics.MeshExtentsY or bp.SizeY or sizescale) / sizescale,
            MeshExtentsZ = (bp.Physics.MeshExtentsZ or bp.SizeZ or sizescale * 2) / sizescale,
            --And now some more lies.
            MaxSpeed = 1,
            MotionType = 'RULEUMT_Amphibious',
        },
        ScriptClass = 'ResearchItem',
        ScriptModule = '/lua/defaultunits.lua',
        SizeX = 2,
        SizeY = (bp.SizeY or sizescale) / sizescale,
        SizeZ = 2,
        Source = bp.Source or all_bps.seb9101.Source,
        StrategicIconName = bp.StrategicIconName,
    }
    if not all_bps[newid].Display.IconName then
        all_bps[newid].Display.IconName = id
    end
end

function RNDGiveCategoriesAndDefineCosts(all_bps, newid, ref)
    local bp = all_bps[newid]
    local cats = {
        'TECH1', 'TECH2', 'TECH3', 'EXPERIMENTAL', 'UEF', 'CYBRAN', 'SERAPHIM', 'AEON',
        'SORTSTRATEGIC', 'SORTCONSTRUCTION', 'SORTDEFENSE', 'SORTECONOMY', 'SORTINTEL',
        'CONSTRUCTIONSORTDOWN', 'RESEARCHLOCKEDTECH1', 'AIR', 'LAND', 'NAVAL'
    }
    for i, v in cats do
        if table.find(ref.Categories, v) then
            -- If the source has the cat, the research item also needs it.
            table.insert(bp.Categories, v)
            if i < 5 then -- if I is less than 5 we are dealing with T1, T2, T3, or Experimental
                local CostMults = {1, 1, 1, 1} -- Resource cost multiplier per tech level.
               -- local maxOutput = { -- Maximum research output of a tech 1
                --    {5, 50},
                --    {5, 100},
                --    {5, 150},
                --    {5, 200},
                --}
                -- If we haven't got a pre-defined cost multiplier, then we use the defaults defined in CostMults.
                -- Units should only exist in one of the first four cats, so this shouldn't stack, except for mods that dont count Experimental as == Tech 4
                if not (ref.Economy.ResearchMultEnergy or ref.Economy.ResearchMult) then
                    bp.Economy.BuildCostEnergy = bp.Economy.BuildCostEnergy * CostMults[1]
                end
                if not (ref.Economy.ResearchMultMass or ref.Economy.ResearchMult) then
                    bp.Economy.BuildCostMass = bp.Economy.BuildCostMass * CostMults[1]
                end
                -- Research times based on max cost per second instead.
                --bp.Economy.BuildTime = math.floor(math.max(bp.Economy.BuildCostMass / maxOutput[i][1] * 50, bp.Economy.BuildCostEnergy / maxOutput[i][2] * 50 ))
            end
        end
    end
end

function RNDGiveIndicativeAbilities(all_bps, newid, ref)
    local bp = all_bps[newid]
    local TFS = TableFindSubstrings
    local TF = table.find
    local CATs = ref.Categories
    if ref.General.UpgradesFrom then
        table.insert(bp.Display.Abilities,'<LOC ability_rnd_updade>Built as upgrade')
    end
    if TFS(CATs,'BUILTBY','ENGINEER') then
        table.insert(bp.Display.Abilities,'<LOC ability_rnd_engineer>Built by engineer')
    end
    if TFS(CATs,'BUILTBY','FIELD')
    or TFS(CATs,'BUILTBY','ENGINEER') and (TF(CATs, 'DEFENSE') or TF(CATs, 'INDIRECTFIRE'))
    then
        table.insert(bp.Display.Abilities,'<LOC ability_rnd_field>Built by field engineer')
    end
    if TFS(CATs,'BUILTBY','COMMANDER') then
        table.insert(bp.Display.Abilities,'<LOC ability_rnd_command>Built by command unit')
    end
    if TFS(CATs,'BUILTBY','FACTORY') then
        table.insert(bp.Display.Abilities,'<LOC ability_rnd_factory>Built by factory')
    end
    if TF(CATs, 'BUILTBYGANTRY') or TF(CATs, 'BUILTBYIENGINE') or TF(CATs, 'BUILTBYARTHROLAB') or TF(CATs, 'BUILTBYSOUIYA') then
        table.insert(bp.Display.Abilities,'<LOC ability_rnd_gantry>Built by experimental factory')
    end
    if TFS(CATs,'BUILTBY','WALL') then
        table.insert(bp.Display.Abilities,'<LOC ability_rnd_wall>Built on wall')
    end
end

function TableFindSubstrings(array, string1, string2)
    if array then
        for i, cat in ipairs(array) do
            if string.find(cat,string1) and string.find(cat,string2 or string1) then
                return i
            end
        end
    end
end

--Making unique mesh, so it can be a glowy hologram
function RNDGiveUniqueMeshBlueprints(all_bps, newid, ref)
    local bp = all_bps[newid]
    for i, mesh in {'BuildMeshBlueprint', 'MeshBlueprint'} do
        local refid = ref.Display[mesh]
        local meshbp = original_blueprints.Mesh[refid]
        if meshbp then
            local dupebp = table.deepcopy(meshbp)
            dupebp.BlueprintId = refid .. 'rnd'
            for i, lod in dupebp.LODs do
                dupebp.LODs[i].ShaderName = 'PhalanxEffect'
            end
            bp.Display[mesh] = dupebp.BlueprintId
            MeshBlueprint(dupebp)
        end
    end
    bp.Display.Mesh = {
        BlueprintId = bp.Display.MeshBlueprint,
        IconFadeInZoom = 130,
        Source = ref.Display.Mesh.Source,
    }    
end

--This isn't nessessary for its original purpose, but it doesn't hurt to keep it around
--It's also a mess for cleanup, since it leaves table floating nowhere. Possible memory leak?
function CleanupDuplicateArrayKeys(array)
    local original = array
    local new = {}
    for i, v in array do
        if v and not table.find(new, v) then
            table.insert(new, v)
        end
    end
    return new
end

function CategoryArrayRemoveTierN(all_bps, table)
    if type(table) == "table" and table[1] and TableFindSubstrings(table, 'BUILTBY', 'TIER') then
        for i, cat in table do
            if string.find(cat, 'BUILTBY') and string.find(cat, 'TIER') and string.find(cat, 'COMMANDER') then
                DumpOldBuiltByCategories(all_bps, cat)
                --table[i] = string.gsub(cat, "TIER%d", "")
            end
        end
    end
end

function DumpOldBuiltByCategories(all_bps, cat)
    --This dumping of old categories is so that they remain valid categories, but categories that do nothing when other mods affect and reference them.
    if not all_bps.zzz6969 then all_bps.zzz6969 = {BlueprintId = 'zzz6969',Categories = {'NOTHINGIMPORTANT', 'UNSPAWNABLE'}} end
    if all_bps.zzz6969 and not table.find(all_bps.zzz6969.Categories, cat) then
        table.insert(all_bps.zzz6969.Categories, cat)
    end
end


end
do
    function ExtractCloakMeshBlueprint(bp)
        local meshid = bp.Display.MeshBlueprint
        if not meshid then return end

        local meshbp = original_blueprints.Mesh[meshid]
        if not meshbp then return end

        local shadernameE = 'ShieldCybran'
        local shadernameA = 'ShieldAeon'
        local shadernameC = 'ShieldCybran'
        local shadernameS = 'ShieldAeon'

        local cloakmeshbp = table.deepcopy(meshbp)
        if cloakmeshbp.LODs then
            for i,cat in bp.Categories do
            if cat == 'UEF' then
                for i,lod in cloakmeshbp.LODs do
                    lod.ShaderName = shadernameE
                end
            elseif cat == 'AEON' then
                for i,lod in cloakmeshbp.LODs do
                    lod.ShaderName = shadernameA
                end
            elseif cat == 'CYBRAN' then
                for i,lod in cloakmeshbp.LODs do
                    lod.ShaderName = shadernameC
                end
            elseif cat == 'SERAPHIM' then
                for i,lod in cloakmeshbp.LODs do
                    lod.ShaderName = shadernameS
                end
            end
            end
        end
        cloakmeshbp.BlueprintId = meshid .. '_cloak'
        bp.Display.CloakMeshBlueprint = cloakmeshbp.BlueprintId
        MeshBlueprint(cloakmeshbp)
    end

    function ExtractPhaseMeshBlueprint(bp)
        local meshid = bp.Display.MeshBlueprint
        if not meshid then return end

        local meshbp = original_blueprints.Mesh[meshid]
        if not meshbp then return end

        local shadernameP1 = 'ShieldUEF'
        local shadernameP2 = 'AlphaFade'
        local shadernameP12 = 'PhalanxEffect'
        local shadernameP22 = 'AlphaFade'

        local phase1meshbp = table.deepcopy(meshbp)
        if phase1meshbp.LODs then
            for i,cat in bp.Categories do
            if cat == 'UEF' then
                for i,lod in phase1meshbp.LODs do
                    lod.ShaderName = shadernameP1
                end
            elseif cat == 'AEON' then
                for i,lod in phase1meshbp.LODs do
                    lod.ShaderName = shadernameP1
                end
            elseif cat == 'CYBRAN' then
                for i,lod in phase1meshbp.LODs do
                    lod.ShaderName = shadernameP12
                end
            elseif cat == 'SERAPHIM' then
                for i,lod in phase1meshbp.LODs do
                    lod.ShaderName = shadernameP12
                end
            end
            end
        end
        local phase2meshbp = table.deepcopy(meshbp)
        if phase2meshbp.LODs then
            for i,cat in bp.Categories do
            if cat == 'UEF' then
                for i,lod in phase2meshbp.LODs do
                    lod.ShaderName = shadernameP2
                end
            elseif cat == 'AEON' then
                for i,lod in phase2meshbp.LODs do
                    lod.ShaderName = shadernameP2
                end
            elseif cat == 'CYBRAN' then
                for i,lod in phase2meshbp.LODs do
                    lod.ShaderName = shadernameP22
                end
            elseif cat == 'SERAPHIM' then
                for i,lod in phase2meshbp.LODs do
                    lod.ShaderName = shadernameP22
                end
            end
            end
        end
        phase1meshbp.BlueprintId = meshid .. '_phase1'
        phase2meshbp.BlueprintId = meshid .. '_phase2'
        bp.Display.Phase1MeshBlueprint = phase1meshbp.BlueprintId
        bp.Display.Phase2MeshBlueprint = phase2meshbp.BlueprintId
        MeshBlueprint(phase1meshbp)
        MeshBlueprint(phase2meshbp)
    end

    local OldModBlueprints = ModBlueprints
    function ModBlueprints(all_blueprints)
        OldModBlueprints(all_blueprints)
        for id,bp in all_blueprints.Unit do
            ExtractCloakMeshBlueprint(bp)
            ExtractPhaseMeshBlueprint(bp)
            if table.find(bp.Categories, 'SUBCOMMANDER') then
                table.insert(bp.Categories, 'ANTITELEPORT')
            end
        end
    end
end

do
    local oldModBlueprints = ModBlueprints
    function ModBlueprints(all_bps)
        oldModBlueprints(all_bps)
        for id, bp in all_bps.Unit do
            if bp.Weapon then
                for ik, wep in bp.Weapon do
                    if wep.RangeCategory == 'UWRC_AntiAir' then
                        if not wep.AntiSat == true then
                            wep.TargetRestrictDisallow = wep.TargetRestrictDisallow .. ', SATELLITE'
                            --LOG('*ADDING RESTRICTION : ' .. bp.BlueprintId .. " : " .. wep.DisplayName)
                        end
                    end
                end
            end
        end
    end
end

-- === M&B: veterancy by killed MASS -- per-class thresholds (WIP) ===
-- Engine promotes veteran levels when KILLS crosses Veteran.LevelN. sim/Unit.lua OnKilledUnit
-- credits the victim's BuildCostMass to the killer's KILLS. Here we set Veteran thresholds to
-- MASS amounts per class.
-- NOTE: the user's L1 is NOT the unit's BuildCostMass (checked: light tank mass 24 vs L1 40,
-- med 30 vs 60, heavy 48 vs 90), so thresholds can't be auto-derived from mass -- a per-class
-- table is needed (the user is computing it). Status:
--   * ACU (COMMAND) and SACU (SUBCOMMANDER): WIRED now via category (certain).
--   * Every other unit that already has a Veteran table: TEMPORARY placeholder =
--     BuildCostMass x {1,2,3,4,5}, so the game stays balanced.
--   * The user's full per-class table is captured in tMNBVetUser below and will be wired
--     class-by-class (matched by the unit's in-game Description label, e.g. all units labelled
--     "Тяжёлый танк T1" -> 90/180/270/360/450) in one verified pass once every class/tech is in.
--   * Structures without a Veteran table are untouched (still don't vet); adding veterancy to
--     turrets/static-AA etc. is a separate step.
-- Skipped on FAF (native mass veterancy).
do
    local bMNBIsFAF = DiskGetFileInfo and DiskGetFileInfo('/lua/sim/navutils.lua')
    if not bMNBIsFAF then

        -- User per-class thresholds: V[role][tech] = {L1,L2,L3,L4,L5}; tech in 0..4.
        -- commander/subcommander are flat rows (any tech). Roles are matched in Classify().
        local V = {
            commander   = {1200,2600,4800,7600,12800},
            subcommander= {1000,2200,3800,6600,9200},
            light       = { [0]={20,40,60,80,100}, [1]={40,80,120,160,200}, [2]={60,120,180,240,300}, [3]={80,160,240,320,400}, [4]={160,320,480,640,800} },
            med         = { [1]={60,120,180,240,300}, [2]={80,160,240,320,400}, [3]={120,240,360,480,600}, [4]={180,360,540,720,900} },
            heavy       = { [1]={90,180,270,360,450}, [2]={120,240,360,480,600}, [3]={160,320,480,640,800}, [4]={180,360,540,720,900} },
            mobile_arty = { [1]={120,240,360,480,600}, [2]={240,480,720,960,1200}, [3]={320,640,960,1280,1600}, [4]={600,1200,1800,2400,3000} },
            mobile_rocket={ [2]={320,640,960,1280,1600}, [3]={500,750,1000,1250,1500}, [4]={600,1200,1800,2400,3000} },
            mobile_aa   = { [1]={240,480,720,960,1200}, [2]={320,640,960,1280,1600}, [3]={400,800,1200,1400,1800}, [4]={400,800,1200,1400,1800} },
            light_turret= { [1]={60,120,180,240,300}, [2]={80,160,240,320,400}, [3]={120,240,360,480,600}, [4]={120,240,360,480,600} },
            heavy_turret= { [1]={90,180,270,360,450}, [2]={120,240,360,480,600}, [3]={160,320,480,640,800}, [4]={160,320,480,640,800} },
            static_aa   = { [1]={240,480,720,960,1200}, [2]={240,480,720,960,1200}, [3]={400,800,1200,1400,1800} },
            longrange_arty={ [1]={250,500,750,1000,1250}, [2]={500,750,1000,1250,1500}, [3]={2500,5000,7500,10000,12500} },
            rapid_arty  = { [1]={250,500,750,1000,1250}, [2]={500,750,1000,1250,1500}, [3]={2500,5000,7500,10000,12500} },
            tactical_missile={ [2]={2500,5000,7500,10000,12500} },
            exp_turret  = { [4]={2500,5000,7500,10000,12500} },
            experimental= { [1]={250,500,750,1000,1250}, [2]={500,750,1000,1250,1500}, [3]={2500,5000,7500,10000,12500}, [4]={5000,10000,15000,20000,25000} },
            light_fighter={ [1]={240,480,720,960,1200}, [2]={320,640,960,1280,1600}, [3]={400,800,1200,1400,1800} },
            heavy_fighter={ [1]={320,640,960,1280,1600}, [2]={400,800,1200,1400,1800}, [3]={500,750,1000,1250,1500} },
            interceptor = { [1]={240,480,720,960,1200}, [2]={320,640,960,1280,1600}, [3]={400,800,1200,1400,1800} },
            assault     = { [1]={90,180,270,360,450}, [2]={120,240,360,480,600}, [3]={160,320,480,640,800} },
            bomber      = { [1]={320,640,960,1280,1600}, [2]={500,1000,1500,2000,2500}, [3]={2500,5000,7500,10000,12500} },
            air_torpedo = { [1]={320,640,960,1280,1600}, [2]={500,1000,1500,2000,2500}, [3]={2500,5000,7500,10000,12500} },
            frigate     = { [1]={320,640,960,1280,1600} },
            submarine   = { [1]={400,800,1200,1600,2000}, [2]={500,1000,1500,2000,2500}, [3]={2500,5000,7500,10000,12500} },
            artyship    = { [2]={1000,2000,3000,4000,5000} },
            destroyer   = { [2]={500,1000,1500,2000,2500} },
            cruiser     = { [2]={500,1000,1500,2000,2500} },
            battleship  = { [3]={2500,5000,7500,10000,12500} },
            battlecruiser={ [3]={2500,5000,7500,10000,12500} },
            carrier     = { [3]={2500,5000,7500,10000,12500} },
        }
        -- explicit per-blueprint-id overrides (skip classification entirely)
        local VID = { ['xeb2402'] = {2500,5000,7500,10000,12500} }

        local function HasCat(bp, sCat)
            if not bp.Categories then return false end
            for i, v in bp.Categories do if v == sCat then return true end end
            return false
        end

        local function SetVet(bp, t)
            if not bp.Veteran then bp.Veteran = {} end
            bp.Veteran.Level1 = t[1]; bp.Veteran.Level2 = t[2]; bp.Veteran.Level3 = t[3]
            bp.Veteran.Level4 = t[4]; bp.Veteran.Level5 = t[5]
        end

        local function Placeholder(bp)
            local m = (bp.Economy and bp.Economy.BuildCostMass) or 0
            if m <= 0 then m = 60 end
            return { m, m * 2, m * 3, m * 4, m * 5 }
        end

        -- Map a unit bp to (role, tech). Category-primary; description keywords for role/weight.
        -- Handles Russian ("Тяжёлый танк T1") AND English ("Medium tank T1") labels. Returns
        -- nil role for units that arent one of the user's classes.
        local function Classify(bp)
            if HasCat(bp, 'SUBCOMMANDER') then return 'subcommander', nil end
            if HasCat(bp, 'COMMAND') then return 'commander', nil end

            local s = bp.Description or ''
            local p = string.find(s, '>')
            if p then s = string.sub(s, p + 1) end
            s = string.gsub(s, 'ё', 'е')
            s = string.gsub(s, 'Ё', 'Е')
            local sLow = string.lower(s)  -- ASCII-only lower (Russian bytes unchanged); for English kw

            local tech = nil
            local _, _, cap = string.find(sLow, 't([0-9])')
            if cap then tech = tonumber(cap)
            elseif HasCat(bp, 'TECH4') then tech = 4
            elseif HasCat(bp, 'TECH3') then tech = 3
            elseif HasCat(bp, 'TECH2') then tech = 2
            elseif HasCat(bp, 'TECH1') then tech = 1 end

            local function Has(sub) return string.find(s, sub, 1, true) ~= nil end
            local function HasL(sub) return string.find(sLow, sub, 1, true) ~= nil end

            if HasCat(bp, 'EXPERIMENTAL') then
                if HasCat(bp, 'STRUCTURE') then return 'exp_turret', (tech or 4) end
                return 'experimental', (tech or 4)
            end
            if HasCat(bp, 'STRUCTURE') then
                if HasCat(bp, 'ANTIAIR') then return 'static_aa', tech end
                if Has('тактич') or HasL('tactical') or HasL('missile') then return 'tactical_missile', tech end
                if Has('орудие') or HasL('turret') or HasL('point defense') then
                    if Has('Тяжел') or HasL('heavy') then return 'heavy_turret', tech end
                    return 'light_turret', tech
                end
                if Has('арта') or Has('артилл') or HasL('artillery') then
                    if Has('скорострельная') or HasL('rapid') then return 'rapid_arty', tech end
                    return 'longrange_arty', tech
                end
                return nil, nil
            end
            if HasCat(bp, 'AIR') then
                if Has('торпедник') or HasL('torpedo') then return 'air_torpedo', tech end
                if Has('бомбардировщик') or HasL('bomber') then return 'bomber', tech end
                if Has('штурмовик') or HasL('gunship') or HasL('assault') then return 'assault', tech end
                if Has('перехватчик') or HasL('interceptor') then return 'interceptor', tech end
                if Has('истребитель') or HasL('fighter') then
                    if Has('Тяжел') or HasL('heavy') then return 'heavy_fighter', tech end
                    return 'light_fighter', tech
                end
                return nil, nil
            end
            if HasCat(bp, 'NAVAL') then
                if Has('лодка') or HasL('submarine') then return 'submarine', tech end
                if Has('авианосец') or HasL('carrier') then return 'carrier', tech end
                if Has('линкор') or HasL('battleship') then
                    if Has('линейный') or HasL('battlecruiser') then return 'battlecruiser', tech end
                    return 'battleship', tech
                end
                if Has('артшип') or HasL('artillery') then return 'artyship', tech end
                if Has('крейсер') or HasL('cruiser') then return 'cruiser', tech end
                if Has('эсминец') or HasL('destroyer') then return 'destroyer', tech end
                if Has('фрегат') or HasL('frigate') then return 'frigate', tech end
                return nil, nil
            end
            -- LAND mobile
            if Has('зенитка') or HasL('anti-air') or HasL('flak') then return 'mobile_aa', tech end
            if Has('ракетниц') or HasL('rocket') then return 'mobile_rocket', tech end
            if Has('арта') or Has('артилл') or HasL('artillery') then return 'mobile_arty', tech end
            if Has('Тяжел') or HasL('heavy') then return 'heavy', tech end
            if Has('Средн') or HasL('medium') then return 'med', tech end
            if Has('Легк') or HasL('light') then return 'light', tech end
            return nil, nil
        end

        local oldModBlueprintsMNBVet = ModBlueprints
        ModBlueprints = function(all_blueprints)
            oldModBlueprintsMNBVet(all_blueprints)
            local nClass, nPlace, nNone = 0, 0, 0
            for id, bp in all_blueprints.Unit do
                local t = VID[bp.BlueprintId]   -- explicit id override first
                if not t then
                    local role, tech = Classify(bp)
                    if role then
                        local row = V[role]
                        if row then
                            if role == 'commander' or role == 'subcommander' then t = row
                            elseif tech then t = row[tech] end
                        end
                    end
                end
                if t then SetVet(bp, t); nClass = nClass + 1          -- user's value
                elseif bp.Veteran then SetVet(bp, Placeholder(bp)); nPlace = nPlace + 1  -- unclassified vetter
                else nNone = nNone + 1 end                            -- doesn't vet (unchanged)
            end
            LOG('M&B veterancy(mass): class='..nClass..' placeholder='..nPlace..' none='..nNone)
        end
    end
end

