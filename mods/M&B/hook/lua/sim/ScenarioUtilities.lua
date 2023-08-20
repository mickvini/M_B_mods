--------------------------------------------------------------------------------
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
do
    local OldCreateInitialArmyGroup = CreateInitialArmyGroup
    local Entity = import('/lua/sim/Entity.lua').Entity

    function CreateInitialArmyGroup(strArmy, createCommander)    	
        AddBuildRestriction(strArmy, categories.MOD + categories.RESEARCHLOCKEDTECH1 + categories.TECH2 + categories.TECH3 + categories.EXPERIMENTAL)
        return OldCreateInitialArmyGroup(strArmy, createCommander)
    end

    function CreateArmyUnit(strArmy,strUnit)
        local tblUnit = FindUnit(strUnit,Scenario.Armies[strArmy].Units)
        local brain = GetArmyBrain(strArmy)
        if not brain.IgnoreArmyCaps then
            SetIgnoreArmyUnitCap(brain:GetArmyIndex(), true)
        end
        if brain.BrainType == 'Human' then
            if nil ~= tblUnit then
                if string.sub(tblUnit.type, 1, 7) == 'ual0001' then
                    tblUnit.type = 'eal0001'
                elseif string.sub(tblUnit.type, 1, 7) == 'uel0001' then
                    tblUnit.type = 'eel0001'
                elseif string.sub(tblUnit.type, 1, 7) == 'url0001' then
                    tblUnit.type = 'erl0001'
                end
                local unit = CreateUnitHPR(
                    tblUnit.type,
                    strArmy,
                    tblUnit.Position[1], tblUnit.Position[2], tblUnit.Position[3],
                    tblUnit.Orientation[1], tblUnit.Orientation[2], tblUnit.Orientation[3]
                )
                if unit:GetBlueprint().Physics.FlattenSkirt then
                    unit:CreateTarmac(true, true, true, false, false)
                end             
                local platoon
                local brain = GetArmyBrain(strArmy)
                if tblUnit.platoon ~= nil and tblUnit.platoon ~= '' then
                    local i = 3
                    while i <= table.getn(Scenario.Platoons[tblUnit.platoon]) do
                        if tblUnit.Type == currTemplate[i][1] then
                            platoon = brain:MakePlatoon('None', 'None')
                            brain:AssignUnitsToPlatoon(platoon, {unit}, currTemplate[i][4], currTemplate[i][5])
                            break
                        end
                        i = i + 1
                    end
                end
                local armyIndex = brain:GetArmyIndex()
                if ScenarioInfo.UnitNames[armyIndex] then
                    ScenarioInfo.UnitNames[armyIndex][strUnit] = unit
                end
                unit.UnitName = strUnit
                if not brain.IgnoreArmyCaps then
                    SetIgnoreArmyUnitCap(brain:GetArmyIndex(), false)
                end
                return unit, platoon, tblUnit.platoon        
            elseif nil ~= tblUnit then
                local unit = CreateUnitHPR(
                    tblUnit.type,
                    strArmy,
                    tblUnit.Position[1], tblUnit.Position[2], tblUnit.Position[3],
                    tblUnit.Orientation[1], tblUnit.Orientation[2], tblUnit.Orientation[3]
                )
                if unit:GetBlueprint().Physics.FlattenSkirt then
                    unit:CreateTarmac(true, true, true, false, false)
                end             
                local platoon
                local brain = GetArmyBrain(strArmy)
                if tblUnit.platoon ~= nil and tblUnit.platoon ~= '' then
                    local i = 3
                    while i <= table.getn(Scenario.Platoons[tblUnit.platoon]) do
                        if tblUnit.Type == currTemplate[i][1] then
                            platoon = brain:MakePlatoon('None', 'None')
                            brain:AssignUnitsToPlatoon(platoon, {unit}, currTemplate[i][4], currTemplate[i][5])
                            break
                        end
                        i = i + 1
                    end
                end
                local armyIndex = brain:GetArmyIndex()
                if ScenarioInfo.UnitNames[armyIndex] then
                    ScenarioInfo.UnitNames[armyIndex][strUnit] = unit
                end
                unit.UnitName = strUnit
                if not brain.IgnoreArmyCaps then
                    SetIgnoreArmyUnitCap(brain:GetArmyIndex(), false)
                end
                return unit, platoon, tblUnit.platoon            
            end
            if not brain.IgnoreArmyCaps then
                SetIgnoreArmyUnitCap(brain:GetArmyIndex(), false)
            end
        return nil
    end    
end
end
-- categories.MK11 + categories.MK12+ categories.MK13+ categories.MK14+ categories.MK15+ categories.MK16 + categories.MK17 