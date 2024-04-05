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

--     
end
-- categories.MK11 + categories.MK12+ categories.MK13+ categories.MK14+ categories.MK15+ categories.MK16 + categories.MK17 