#****************************************************************************
#**
#**  File     :  /cdimage/lua/formations.lua
#**  Author(s): Mickvini
#**
#**  Summary  :
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
#
# Basic create formation scripts
#

SurfaceFormations = {
    'AttackFormation',
    'GrowthFormation',
    'ScatterFormation',
    'BlockFormation',
    'ClusterFormation',
    'DMSCircleFormation',
}

AirFormations = {
    'AttackFormation',
    'GrowthFormation',
    'ScatterFormation',
    'BlockFormation',
    'ClusterFormation',
    'DMSCircleFormation',
}

ComboFormations = {
    'AttackFormation',
    'GrowthFormation',
    'ScatterFormation',
    'BlockFormation',
    'DMSCircleFormation',
}

local AntiAir = ( categories.ANTIAIR - ( categories.EXPERIMENTAL + categories.DIRECTFIRE ) ) * categories.LAND
local Artillery = ( categories.ARTILLERY + categories.INDIRECTFIRE - categories.ANTIAIR ) * categories.LAND
local Construction = ( categories.COMMAND + categories.CONSTRUCTION + categories.ENGINEER ) * categories.LAND - categories.EXPERIMENTAL
local DirectFire = (( categories.DIRECTFIRE - categories.CONSTRUCTION ) ) * categories.LAND
local ShieldCat = categories.SHIELD + categories.ANTIMISSILE
local UtilityCat = (( ( categories.RADAR + categories.COUNTERINTELLIGENCE ) - categories.DIRECTFIRE ) + categories.SCOUT) * categories.LAND

local DFExp = DirectFire * categories.EXPERIMENTAL


--=== TECH LEVEL LAND CATEGORIES ===#
LandCategories = {
    Bot1 = (DirectFire * categories.TECH1) * categories.BOT - categories.SCOUT,
    Bot2 = (DirectFire * categories.TECH2) * categories.BOT - categories.SCOUT,
    Bot3 = (DirectFire * categories.TECH3 + categories.EXPERIMENTAL) * categories.BOT - categories.SCOUT,

    Tank1 = (DirectFire * categories.TECH1) - categories.BOT - categories.SCOUT,
    Tank2 = (DirectFire * categories.TECH2) - categories.BOT - categories.SCOUT,
    Tank3 = (DirectFire * categories.TECH3 + categories.EXPERIMENTAL) - categories.BOT - categories.SCOUT,

    Art1 = Artillery * categories.TECH1,
    Art2 = Artillery * categories.TECH2,
    Art3 = Artillery * (categories.TECH3 + categories.EXPERIMENTAL),

    AA = AntiAir,

    Com = Construction,

    Util = UtilityCat,

    Shields = ShieldCat,        

    Experimentals = DFExp,

    RemainingCategory = categories.LAND - ( DirectFire + Construction + Artillery + AntiAir + UtilityCat + DFExp + ShieldCat )
}

--=== SUB GROUP ORDERING ===#
Bots = { 'Bot3', 'Bot2', 'Bot1', }
Tanks = { 'Tank3', 'Tank2', 'Tank1', }
DF = { 'Tank3', 'Bot3', 'Tank2', 'Bot2', 'Tank1', 'Bot1',}
Art = { 'Art1', 'Art2', 'Art3', }
AA = { 'AA' }
Util = { 'Util' }
Com = { 'Com' }
Shield = { 'Shields' }
Experimental = { 'Experimentals', }
    
--=== LAND BLOCK TYPES =#
DFFirst = { Experimental, DF, Art, AA, Shield, Com, Util, RemainingCategory }
TankFirst = { Experimental, Tanks, Bots, Art, AA, Shield, Com, Util, RemainingCategory }
ShieldFirst = { Shield, AA, Art, DF, Com, Util, RemainingCategory }
AAFirst = { AA, DF, Art, Shield, Com, Util, RemainingCategory }
ArtFirst = { Art, AA, DF, Shield, Com, Util, RemainingCategory }
UtilFirst = { Util, AA, DF, Art, Shield, Com, Util, RemainingCategory }

ThreeWideGrowthFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, },
    -- second row
    { DFFirst, DFFirst, DFFirst, },
}

--=== 4 Wide Growth Block / 16 Units ===#
FourWideGrowthFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, },
    -- second row
    { UtilFirst, ShieldFirst, ShieldFirst, UtilFirst, },
    -- third row
    { UtilFirst, ShieldFirst, ShieldFirst, UtilFirst, },
    -- fourth Row
    { AAFirst, ArtFirst, ArtFirst, AAFirst,  },
}

--=== 5 Wide Growth Block/ 25 Units ===#
FiveWideGrowthFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, },
    -- second row
    { DFFirst, ShieldFirst, UtilFirst, ShieldFirst, DFFirst, },
    -- third row
    { UtilFirst, ShieldFirst, DFFirst, ShieldFirst,  UtilFirst, },
    -- fourth row
    { DFFirst, ShieldFirst, UtilFirst, ShieldFirst, DFFirst, },
    -- fifth row
    { AAFirst, ArtFirst, DFFirst, ArtFirst, AAFirst, },
}

--=== 6 Wide Growth Block/ 36 Units ===#
SixWideGrowthFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, },
    -- second row
    { DFFirst, ShieldFirst, UtilFirst, DFFirst, ShieldFirst, DFFirst, },
    -- third row
    { UtilFirst, AAFirst, DFFirst, DFFirst, AAFirst,  UtilFirst, },
    -- fourth row
    { AAFirst, ShieldFirst, ArtFirst, ArtFirst, ShieldFirst, AAFirst, },
    -- fifth row
    { DFFirst, ShieldFirst, UtilFirst, DFFirst, ShieldFirst, DFFirst, },
    -- sixth row
    { DFFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, DFFirst, },
}

--=== 7 Wide Growth Block/ 42 Units ===#
SevenWideGrowthFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, },
    -- second Row
    { DFFirst, ShieldFirst, DFFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, },
    -- third row
    { UtilFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, UtilFirst, },
    -- fourth row
    { AAFirst, ShieldFirst, AAFirst, ArtFirst, ShieldFirst, AAFirst, DFFirst, },
    -- fifth row
    { DFFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, DFFirst, },
    -- sixth row
    { UtilFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, UtilFirst, },
}

--=== 8 Wide Growth Block/ 56 Units ===#
EightWideGrowthFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, },
    -- second Row
    { DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, },
    -- third row
    { DFFirst, UtilFirst, AAFirst, DFFirst, DFFirst, AAFirst, UtilFirst, DFFirst, },
    -- fourth row
    { DFFirst, AAFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, },
    -- fifth row
    { DFFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, DFFirst, },
    -- sixth row
    { UtilFirst, AAFirst, ShieldFirst, ArtFirst, ArtFirst, ShieldFirst, AAFirst, UtilFirst, },
    -- seventh row
    { DFFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, DFFirst, },
}

--=== 9 Wide Growth Block/ 72 Units ===#
NineWideGrowthFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, UtilFirst, DFFirst, DFFirst, DFFirst, DFFirst, },
    -- second Row
    { DFFirst, DFFirst, ShieldFirst, DFFirst, AAFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, },
    -- third row
    { DFFirst, UtilFirst, AAFirst, DFFirst, ShieldFirst, DFFirst, AAFirst, UtilFirst, DFFirst, },
    -- fourth row
    { DFFirst, AAFirst, ShieldFirst, DFFirst, UtilFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, },
    -- fifth row
    { DFFirst, ArtFirst, AAFirst, ArtFirst, ShieldFirst, ArtFirst, AAFirst, ArtFirst, DFFirst, },
    -- sixth row
    { UtilFirst, AAFirst, ShieldFirst, ArtFirst, UtilFirst, ArtFirst, ShieldFirst, AAFirst, UtilFirst, },
    -- seventh row
    { DFFirst, ArtFirst, AAFirst, ArtFirst, ShieldFirst, ArtFirst, AAFirst, ArtFirst, DFFirst, },
    -- eighth row
    { DFFirst, ArtFirst, AAFirst, ArtFirst, ShieldFirst, ArtFirst, AAFirst, ArtFirst, DFFirst, },
}

--=== Travelling Block ===#
TravelSlot = { Experimental, Bots, Tanks, AA, Art, Shield, Util, Com }

TravelFormationBlock = {
    HomogenousRows = true,
    UtilBlocks = true,
    RowBreak = 0.25,
    { TravelSlot, TravelSlot, },
    { TravelSlot, TravelSlot, },
    { TravelSlot, TravelSlot, },
    { TravelSlot, TravelSlot, },
    { TravelSlot, TravelSlot, },
}

--=== 2 Row Attack Block - 8 units wide ===#
TwoRowAttackFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst },
    -- second row
    { UtilFirst, AAFirst, ShieldFirst, ArtFirst, ArtFirst, ShieldFirst, AAFirst, UtilFirst },
}

--=== 3 Row Attack Block - 10 units wide ===#
ThreeRowAttackFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst },
    -- second row
    { DFFirst, ShieldFirst, UtilFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, UtilFirst, ShieldFirst, DFFirst },
    -- third row
    { DFFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, ArtFirst, AAFirst, DFFirst },  
}

--=== 4 Row Attack Block - 12 units wide ===#
FourRowAttackFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst },
    -- second row
    { DFFirst, ShieldFirst, UtilFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, UtilFirst, ShieldFirst, DFFirst },
    -- third row
    { DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, UtilFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst },
    -- fourth row
    { AAFirst, ShieldFirst, AAFirst, ArtFirst, ShieldFirst, ArtFirst, UtilFirst, ShieldFirst, ArtFirst, AAFirst, ShieldFirst, AAFirst },   
}

--=== 5 Row Attack Block - 14 units wide ===#
FiveRowAttackFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst },
    -- second row
    { DFFirst, ShieldFirst, DFFirst, UtilFirst, ShieldFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, UtilFirst, DFFirst, ShieldFirst, DFFirst },
    -- third row
    { DFFirst, AAFirst, DFFirst, AAFirst, DFFirst, UtilFirst, DFFirst, DFFirst, DFFirst, DFFirst, AAFirst, DFFirst, AAFirst, DFFirst },
    -- fourth row
    { AAFirst, DFFirst, ShieldFirst, DFFirst, UtilFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, UtilFirst, DFFirst, AAFirst, ShieldFirst, AAFirst },  
    -- five row
    { ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst },  
}

--=== 6 Row Attack Block - 16 units wide ===#
SixRowAttackFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst },
    -- second row
    { DFFirst, ShieldFirst, DFFirst, UtilFirst, ShieldFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, UtilFirst, DFFirst, ShieldFirst, DFFirst },
    -- third row
    { DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst },
    -- fourth row
    { DFFirst, ShieldFirst, UtilFirst, AAFirst, ShieldFirst, AAFirst, ShieldFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst, UtilFirst, ShieldFirst, DFFirst },
    -- fifth row
    { DFFirst, AAFirst, DFFirst, DFFirst, UtilFirst, DFFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, UtilFirst, DFFirst, DFFirst, AAFirst, DFFirst },  
    -- sixth row
    { AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst },  
}

--=== 7 Row Attack Block - 18 units wide ===#
SevenRowAttackFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst },
    -- second row
    { UtilFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, UtilFirst },
    -- third row
    { DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst },
    -- fourth row
    { AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst },
    -- fifth row
    { UtilFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, UtilFirst },  
    -- sixth row
    { AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst },  
    -- seventh row
    { ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst },  
}

--=== 8 Row Attack Block - 18 units wide ===#
EightRowAttackFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst },
    -- second row
    { UtilFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, UtilFirst },
    -- third row
    { DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst },
    -- fourth row
    { AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst },
    -- fifth row
    { UtilFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, AAFirst, UtilFirst },  
    -- sixth row
    { AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst },  
    -- seventh row
    { DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, DFFirst, DFFirst, DFFirst },  
    -- eight row
    { AAFirst, ShieldFirst, ArtFirst, AAFirst, ShieldFirst, ArtFirst, AAFirst, ShieldFirst, ArtFirst, ShieldFirst, AAFirst, ArtFirst, ShieldFirst, AAFirst, ArtFirst, ShieldFirst, AAFirst, ArtFirst, ShieldFirst, AAFirst },  
}

--=== 9 Row Attack Block - 18+ units wide ===#
NineRowAttackFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst },
    -- second row
    { UtilFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, UtilFirst },
    -- third row
    { DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst },
    -- fourth row
    { AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst },
    -- fifth row
    { UtilFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, AAFirst, UtilFirst },  
    -- sixth row
    { AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst },  
    -- seventh row
    { DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, DFFirst, DFFirst, DFFirst },  
    -- eight row
    { AAFirst, ShieldFirst, ArtFirst, AAFirst, ShieldFirst, ArtFirst, AAFirst, ShieldFirst, ArtFirst, ShieldFirst, AAFirst, ArtFirst, ShieldFirst, AAFirst, ArtFirst, ShieldFirst, AAFirst, ArtFirst, ShieldFirst, AAFirst },  
}

--================ AIR DATA ===============#

--=== AIR CATEGORIES ===#

local StdAirUnits = categories.AIR - categories.EXPERIMENTAL - categories.TRANSPORTFOCUS + categories.uea0203
local T4AirUnits = categories.AIR * categories.EXPERIMENTAL - categories.TRANSPORTFOCUS
local TransportationAir = categories.AIR * categories.TRANSPORTFOCUS


--=== TECH LEVEL AIR CATEGORIES ===#
-- this has been greatly simplified
AirCategories = { StdAirUnits = StdAirUnits, T4AirUnits = T4AirUnits }

--    RemainingCategory = categories.AIR - ( GroundAttackAir + TransportationAir + BomberAir + AAAir + AntiNavyAir + IntelAir + ExperimentalAir )
--    Ground2 = GroundAttackAir * categories.TECH2,
--    Ground3 = GroundAttackAir * categories.TECH3,
--    Bomb2 = BomberAir * categories.TECH2,
--    Bomb3 = BomberAir * categories.TECH3,
--    AA2 = AAAir * categories.TECH2,
--    AA3 = AAAir * categories.TECH3,
--    AN2 = AntiNavyAir * categories.TECH2,
--    AN3 = AntiNavyAir * categories.TECH3,
--    AIntel2 = IntelAir * categories.TECH2,
--    AIntel3 = IntelAir * categories.TECH3,


local AirTransportCategories = {
    Trans1 = TransportationAir * categories.TECH1,
    Trans2 = TransportationAir * categories.TECH2,
    Trans3 = TransportationAir * categories.TECH3,
    Trans4 = TransportationAir * categories.EXPERIMENTAL,
}


--=== SUB GROUP ORDERING ===#
local AirUnits = { 'StdAirUnits', 'T4AirUnits' }
local Transports = { 'Trans1', 'Trans2', 'Trans3', 'Trans4', }

--local GroundAttack = {'Ground' }
--local Bombers = { 'Bomb' }
--local AntiAir = { 'AA' }
--local AntiNavy = {'AN' }
--local Intel = { 'AIntel' }
--local Remaining = { 'RemainingCategory' }

--=== Air Block Arrangement ===#

ChevronSlot = { AirUnits }
local TransportSlot = { Transports }

InitialChevronBlock = {
    RepeatAllRows = false,
    HomogenousBlocks = true,
    ChevronSize = 3,
    { ChevronSlot },
    { ChevronSlot, ChevronSlot },
}

StaggeredChevronBlock = {
    RepeatAllRows = true,
    HomogenousBlocks = true,
    { ChevronSlot, ChevronSlot, ChevronSlot, },
    { ChevronSlot, ChevronSlot, },
}


--=== Transport Formations ===#
local TwoWideTransportGrowthFormation = {
    LineBreak = 1,
    { TransportSlot, TransportSlot, },    
    { TransportSlot, TransportSlot, },
}

local ThreeWideTransportGrowthFormation = {
    LineBreak = 1,
    { TransportSlot, TransportSlot, TransportSlot, },    
    { TransportSlot, TransportSlot, TransportSlot, },
    { TransportSlot, TransportSlot, TransportSlot, },    
}

local FourWideTransportGrowthFormation = {
    LineBreak = 1,
    { TransportSlot, TransportSlot, TransportSlot, TransportSlot, },    
    { TransportSlot, TransportSlot, TransportSlot, TransportSlot, },
    { TransportSlot, TransportSlot, TransportSlot, TransportSlot, },    
    { TransportSlot, TransportSlot, TransportSlot, TransportSlot, },    
}

local FiveWideTransportGrowthFormation = {
    LineBreak = 1,
    { TransportSlot, TransportSlot, TransportSlot, TransportSlot, TransportSlot },    
    { TransportSlot, TransportSlot, TransportSlot, TransportSlot, TransportSlot },    
    { TransportSlot, TransportSlot, TransportSlot, TransportSlot, TransportSlot },    
    { TransportSlot, TransportSlot, TransportSlot, TransportSlot, TransportSlot },    
    { TransportSlot, TransportSlot, TransportSlot, TransportSlot, TransportSlot },    
}



--=========================================#
--============== NAVAL DATA ===============#

--=== BASIC GROUPS ===#

LightAttackNaval = categories.LIGHTBOAT
FrigateNaval = categories.FRIGATE
SubNaval = categories.SUBMARINE
DestroyerNaval = categories.DESTROYER
CruiserNaval = categories.CRUISER
BattleshipNaval = categories.BATTLESHIP
CarrierNaval = categories.CARRIER
--local NukeSubNaval = categories.NUKE
MobileSonar = categories.MOBILESONAR
DefensiveBoat = categories.DEFENSIVEBOAT
RemainingNaval = categories.NAVAL - ( LightAttackNaval + FrigateNaval + SubNaval + DestroyerNaval + CruiserNaval + BattleshipNaval + CarrierNaval + DefensiveBoat + MobileSonar)

-- Naval formation blocks #####

NavalSpacing = 1.1

--[[
local StandardNavalBlock = {
    { { {0, 0}, }, { 'Carriers', 'Battleships', 'Cruisers', 'Destroyers', 'Frigates', 'Submarines' }, },
    { { {-1, 1.5}, {1, 1.5}, }, { 'Destroyers', 'Cruisers', 'Frigates', 'Submarines'}, },
    { { {-2.5, 0}, {2.5, 0}, }, { 'Cruisers', 'Battleships', 'Destroyers', 'Frigates', 'Submarines' }, },
    { { {-1, -1.5}, {1, -1.5}, }, { 'Frigates', 'Battleships', 'Submarines' }, },
    { { {-3, 2}, {3, 2}, {-3, 0}, {3, 0}, }, { 'Submarines', }, },
}
--]]

--=== PRIMARY SUB-GROUPS ===#

-- surface ships --
NavalCategories = {

    LightCount = LightAttackNaval,
    FrigateCount = FrigateNaval,
    CruiserCount = CruiserNaval,
    DestroyerCount = DestroyerNaval,
    BattleshipCount = BattleshipNaval,
    CarrierCount = CarrierNaval,
    --NukeSubCount = NukeSubNaval,
    MobileSonarCount = MobileSonar + DefensiveBoat,     

    RemainingCategory = RemainingNaval,
}

-- all submarines --
SubmarineCategories = {
    SubCount = SubNaval,
}


--=== SUB GROUPS ===#

Frigates = { 'FrigateCount', 'LightCount', }
Destroyers = { 'DestroyerCount', }
Cruisers = { 'CruiserCount', }
Battleships = { 'BattleshipCount', }
Subs = { 'SubCount', }
Space = { }
--local NukeSubs = { 'NukeSubCount', }
Carriers = { 'CarrierCount', }
Sonar = {'MobileSonarCount', }


--=== UNIT ORDERING ===#

FrigatesOnly = { Frigates }
FrigatesFirst = { Frigates, Destroyers, RemainingCategory }
DestroyersFirst = { Destroyers, Cruisers, RemainingCategory }
CruisersFirst = { Cruisers, Destroyers, Battleships, Sonar, RemainingCategory }
BattleshipsFirst = { Battleships, Cruisers, Destroyers, Carriers, Sonar, Frigates, RemainingCategory }
CarriersFirst = { Carriers, Battleships, Cruisers, Destroyers, Sonar, RemainingCategory }

Subs = { Subs, RemainingCategory }

local SonarOnly = { Sonar, RemainingCategory }
SonarFirst = { Sonar, Frigates, Destroyers, Cruisers, Battleships, Carriers, RemainingCategory }


--========================================#
--======= Naval Growth Formations ========#
--========================================#

ThreeNavalGrowthFormation = {

    LineBreak = 0.3,
    
    {                                                           FrigatesOnly,                                                                   },
    {                                       FrigatesOnly,       SonarOnly,          FrigatesOnly                                                },  
    {                   FrigatesFirst,      Space,              DestroyersFirst,    Space,              FrigatesFirst                           },
    { FrigatesOnly,     SonarFirst,         CruisersFirst,      Space,              CruisersFirst,      SonarFirst,         FrigatesOnly        },
    {                   DestroyersFirst,    Space,              BattleshipsFirst,   Space,              CruisersFirst                           },
    
}

FiveNavalGrowthFormation = {

    LineBreak = 0.3,

    { FrigatesOnly,     Space,              Space,              FrigatesOnly,       Space,              Space,              FrigatesOnly        },  
    { Space,            DestroyersFirst,    SonarOnly,          DestroyersFirst,    Space,              DestroyersFirst,    Space               },
    { FrigatesFirst,    SonarFirst,         CruisersFirst,      SonarFirst,         CruisersFirst,      SonarFirst,         FrigatesFirst       },
    { Space,            BattleshipsFirst,   Space,              BattleshipsFirst,   Space,              BattleshipsFirst,   Space               },
    { FrigatesFirst,    Space,              CarriersFirst,      Space,              BattleshipsFirst,   Space,              FrigatesFirst       },
    { Space,            DestroyersFirst,    SonarFirst,         DestroyersFirst,    SonarFirst,         DestroyersFirst,    Space               },  
}

SevenNavalGrowthFormation = {

    LineBreak = 0.28,
    {                                                                               Space,                                                                                          },
    { FrigatesOnly,     Space,              Space,              Space,              FrigatesOnly,       Space,              Space,              Space,              FrigatesOnly    },
    { Space,            DestroyersFirst,    SonarFirst,         CruisersFirst,      Space,              CruisersFirst,      SonarFirst,         DestroyersFirst,    Space           },
    { FrigatesOnly,     Space,              CruisersFirst,      Space,              BattleshipsFirst,   Space,              CruisersFirst,      Space,              FrigatesOnly    },
    { SonarOnly,        DestroyersFirst,    SonarOnly,          BattleshipsFirst,   Space,              BattleshipsFirst,   SonarOnly,          DestroyersFirst,    SonarOnly       },
    { FrigatesFirst,    Space,              DestroyersFirst,    Space,              CarriersFirst,      Space,              DestroyersFirst,    Space,              FrigatesFirst   },
    { SonarFirst,       CruisersFirst,      SonarFirst,         BattleshipsFirst,   Space,              BattleshipsFirst,   SonarFirst,         CruisersFirst,      SonarFirst      },
    { FrigatesFirst,    SonarOnly,          BattleshipsFirst,   Space,              BattleshipsFirst,   Space,              BattleshipsFirst,   SonarOnly,          FrigatesFirst   },
    { SonarFirst,       BattleshipsFirst,   SonarFirst,         CarriersFirst,      SonarFirst,         CarriersFirst,      SonarFirst,         BattleshipsFirst,   SonarFirst      },      
}


--============================================#
--========= Naval Attack Formations ==========#
--============================================#

FiveWideNavalAttackFormation = {

    LineBreak = 0.35,
    
    { Space,            FrigatesOnly,       Space,              FrigatesOnly,       Space               },
    { FrigatesFirst,    Space,              FrigatesFirst,      Space,              FrigatesFirst       },
    { Space,            DestroyersFirst,    Space,              DestroyersFirst,    Space               },
    { DestroyersFirst,  SonarFirst,         CarriersFirst,      SonarFirst,         DestroyersFirst     },
    { Space,            BattleshipsFirst,   Space,              BattleshipsFirst,   Space               },

}

SevenWideNavalAttackFormation = {

    LineBreak = 0.3,

    { FrigatesOnly,     Space,              Space,              FrigatesOnly,       Space,              Space,              FrigatesOnly        },  
    { Space,            DestroyersFirst,    SonarOnly,          DestroyersFirst,    Space,              DestroyersFirst,    Space               },
    { FrigatesFirst,    SonarFirst,         CruisersFirst,      SonarFirst,         CruisersFirst,      SonarFirst,         FrigatesFirst       },
    { Space,            BattleshipsFirst,   Space,              BattleshipsFirst,   Space,              BattleshipsFirst,   Space               },
    { FrigatesFirst,    Space,              CarriersFirst,      Space,              BattleshipsFirst,   Space,              FrigatesFirst       },
    { Space,            DestroyersFirst,    SonarFirst,         DestroyersFirst,    SonarFirst,         DestroyersFirst,    Space               },  

}

NineWideNavalAttackFormation = {

    LineBreak = 0.28,
    
    {                                                                               Space,                                                                                          },
    { FrigatesOnly,     Space,              Space,              Space,              FrigatesOnly,       Space,              Space,              Space,              FrigatesOnly    },
    { Space,            DestroyersFirst,    SonarFirst,         CruisersFirst,      Space,              CruisersFirst,      SonarFirst,         DestroyersFirst,    Space           },
    { FrigatesOnly,     Space,              CruisersFirst,      Space,              BattleshipsFirst,   Space,              CruisersFirst,      Space,              FrigatesOnly    },
    { SonarOnly,        DestroyersFirst,    SonarOnly,          BattleshipsFirst,   Space,              BattleshipsFirst,   SonarOnly,          DestroyersFirst,    SonarOnly       },
    { FrigatesFirst,    Space,              DestroyersFirst,    Space,              CarriersFirst,      Space,              DestroyersFirst,    Space,              FrigatesFirst   },
    { SonarFirst,       CruisersFirst,      SonarFirst,         BattleshipsFirst,   Space,              BattleshipsFirst,   SonarFirst,         CruisersFirst,      SonarFirst      },
    { FrigatesFirst,    SonarOnly,          BattleshipsFirst,   Space,              BattleshipsFirst,   Space,              BattleshipsFirst,   SonarOnly,          FrigatesFirst   },
    { SonarFirst,       BattleshipsFirst,   SonarFirst,         CarriersFirst,      SonarFirst,         CarriersFirst,      SonarFirst,         BattleshipsFirst,   SonarFirst      },
    
}

--==============================================#
--============ Sub Growth Formations ===========#
--==============================================#

ThreeWideSubGrowthFormation = {

    LineBreak = 0.25,
    
    { Subs, Space, Subs },
    { Space, Subs, Space },     
    
}

FiveWideSubGrowthFormation = {

    LineBreak = 0.25,
    
    { Subs, Space, Subs, Space, Subs },
    { Space, Subs, Space, Subs, Space },
    
}

SevenWideSubGrowthFormation = {

    LineBreak = 0.25,
    
    { Space, Subs, Space, Subs, Space, Subs, Space },
    { Subs, Space, Subs, Space, Subs, Space, Subs },
    { Space, Subs, Space, Subs, Space, Subs, Space },

}

NineWideSubGrowthFormation = {

    LineBreak = 0.25,
    
    { Space, Subs, Space, Subs, Space, Subs, Space },
    { Subs, Space, Subs, Space, Subs, Space, Subs },
    { Space, Subs, Space, Subs, Space, Subs, Space },
    { Subs, Space, Subs, Space, Subs, Space, Subs },    

}

--==============================================#
--============ Sub Attack Formations ===========#  
--==============================================#

FiveWideSubAttackFormation = {

    LineBreak = 0.25,
    
    { Subs, Subs, Subs, Subs, Subs },    

}

SevenWideSubAttackFormation = {

    LineBreak = 0.5,
    
    { Subs, Subs, Subs, Subs, Subs, Subs, Subs },
    { Subs, Subs, Subs, Subs, Subs, Subs, Subs },

}

NineWideSubAttackFormation = {

    LineBreak = 0.5,
    
    { Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs },
    { Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs },

}
function AttackFormation( formationUnits )

    local FormationPos = {}

    local landUnitsList = CategorizeLandUnits( formationUnits )
    local seaUnitsList = CategorizeSeaUnits( formationUnits )
    local airUnitsList = CategorizeAirUnits( formationUnits )
    local TransportUnitsList = CategorizeTransportUnits( formationUnits )

    local UnitTotal = landUnitsList.UnitTotal or 0

    if UnitTotal > 0 then
    
        local landBlock
        local defaultspacing = 1.2
    
        if UnitTotal <= 16 then       -- 8 wide
            landBlock = TwoRowAttackFormationBlock
            
        elseif UnitTotal <= 30 then   -- 10 wide
            landBlock = ThreeRowAttackFormationBlock
            defaultspacing = 1.1            
            
        elseif UnitTotal <= 48 then   -- 12 wide
            landBlock = FourRowAttackFormationBlock
            defaultspacing = 1.02
            
        elseif UnitTotal <= 70 then   -- 14 wide
            landBlock = FiveRowAttackFormationBlock
            defaultspacing = 0.96
            
        elseif UnitTotal <= 96 then   -- 16 wide
            landBlock = SixRowAttackFormationBlock
            defaultspacing = 0.92
            
        elseif UnitTotal <= 126 then  -- 18 wide
            landBlock = SevenRowAttackFormationBlock
            defaultspacing = 0.90            
            
        elseif UnitTotal <= 160 then  -- 20 wide
            landBlock = EightRowAttackFormationBlock
            defaultspacing = 0.84            
        else
            landBlock = NineRowAttackFormationBlock
            defaultspacing = 0.82            
        end
    
        BlockBuilderLand(landUnitsList, landBlock, LandCategories, FormationPos, defaultspacing)
    
    end

    UnitTotal = seaUnitsList.UnitTotal or 0

    -- if there are sea units --
    if UnitTotal > 0 then
    
        local seaBlock
        local subBlock
        
        local subUnitsList = {}
        
        subUnitsList.UnitTotal = seaUnitsList.SubCount
        subUnitsList.SubCount = seaUnitsList.SubCount

        -- do submarine formations --
        if subUnitsList.UnitTotal > 0 then
        
            if subUnitsList.UnitTotal <= 3 then
        
                subBlock = ThreeWideSubGrowthFormation
            
            elseif subUnitsList.UnitTotal <= 6 then
        
                subBlock = FiveWideSubGrowthFormation
            
            else
        
                subBlock = NineWideSubAttackFormation
            
            end 
        
            BlockBuilderLand( subUnitsList, subBlock, SubmarineCategories, FormationPos, 0.7 )
            
            seaUnitsList.UnitTotal = seaUnitsList.UnitTotal - subUnitsList.UnitTotal
            seaUnitsList.SubCount = 0
            
        end

        -- remove the submarine count from the total count -- 
        UnitTotal = UnitTotal - seaUnitsList.SubCount
        
        -- do surface unit formations --
        if UnitTotal > 0 then
        
            if UnitTotal <= 12 then
        
                seaBlock = FiveWideNavalAttackFormation
            
            elseif UnitTotal <= 28 then
        
                seaBlock = SevenWideNavalAttackFormation
            
            else
        
                seaBlock = NineWideNavalAttackFormation
            
            end
        
            BlockBuilderLand( seaUnitsList, seaBlock, NavalCategories, FormationPos, 0.90 )
            
        end
        
    end

    if airUnitsList.UnitTotal > 0 then
        BlockBuilderAir(airUnitsList, StaggeredChevronBlock, FormationPos)
    end

    UnitTotal = TransportUnitsList.UnitTotal or 0

    if UnitTotal > 0 then
    
        if UnitTotal <= 4 then
        
            BlockBuilderLand(TransportUnitsList, TwoWideTransportGrowthFormation, AirTransportCategories, FormationPos)
            
        elseif UnitTotal <= 9 then
        
            BlockBuilderLand(TransportUnitsList, ThreeWideTransportGrowthFormation, AirTransportCategories, FormationPos)
            
        elseif UnitTotal <= 16 then
        
            BlockBuilderLand(TransportUnitsList, FourWideTransportGrowthFormation, AirTransportCategories, FormationPos)            
            
        elseif UnitTotal <= 25 then
        
            BlockBuilderLand(TransportUnitsList, FiveWideTransportGrowthFormation, AirTransportCategories, FormationPos)
        end
    end 

    return FormationPos
end

function GrowthFormation( formationUnits )

    local FormationPos = {}

    local landUnitsList = CategorizeLandUnits( formationUnits )
    local seaUnitsList = CategorizeSeaUnits( formationUnits )
    local airUnitsList = CategorizeAirUnits( formationUnits )
    local TransportUnitsList = CategorizeTransportUnits( formationUnits )

    local UnitTotal = landUnitsList.UnitTotal or 0

    if UnitTotal > 0 then
    
        local landBlock
    
        if UnitTotal <= 6 then
        
            landBlock = ThreeWideGrowthFormationBlock
            
        elseif UnitTotal <= 16 then
        
            landBlock = FourWideGrowthFormationBlock
            
        elseif UnitTotal <= 25 then
        
            landBlock = FiveWideGrowthFormationBlock
            
        elseif UnitTotal <= 36 then
        
            landBlock = SixWideGrowthFormationBlock
            
        elseif UnitTotal <= 42 then
        
            landBlock = SevenWideGrowthFormationBlock
            
        elseif UnitTotal <= 56 then
        
            landBlock = EightWideGrowthFormationBlock
            
        else
        
            landBlock = NineWideGrowthFormationBlock
            
        end
    
        BlockBuilderLand(landUnitsList, landBlock, LandCategories, FormationPos)
        
    end
    
    UnitTotal = seaUnitsList.UnitTotal or 0
    
    -- if there are sea units --
    if UnitTotal > 0 then
    
        local seaBlock
        local subBlock
        
        local subUnitsList = {}
        
        subUnitsList.UnitTotal = seaUnitsList.SubCount
        subUnitsList.SubCount = seaUnitsList.SubCount

        -- do submarine formations --
        if subUnitsList.UnitTotal > 0 then
        
            if subUnitsList.UnitTotal <= 3 then
        
                subBlock = ThreeWideSubGrowthFormation
            
            elseif subUnitsList.UnitTotal <= 6 then
        
                subBlock = FiveWideSubGrowthFormation
            
            elseif subUnitsList.UnitTotal <= 10 then
        
                subBlock = SevenWideSubGrowthFormation
            
            else
            
                subBlock = NineWideSubGrowthFormation
                
            end
        
            BlockBuilderLand( subUnitsList, subBlock, SubmarineCategories, FormationPos, 0.7 )
            
            seaUnitsList.UnitTotal = seaUnitsList.UnitTotal - subUnitsList.UnitTotal
            seaUnitsList.SubCount = 0
            
        end

        -- remove the submarine count from the total count -- 
        seaUnitsList.UnitTotal = seaUnitsList.UnitTotal - seaUnitsList.SubCount
        
        UnitTotal = seaUnitsList.UnitTotal or 0
        
        -- do surface unit formations --
        if UnitTotal > 0 then
        
            if UnitTotal <= 12 then
        
                seaBlock = ThreeNavalGrowthFormation
            
            elseif UnitTotal <= 24 then
        
                seaBlock = FiveNavalGrowthFormation
            
            else
        
                seaBlock = SevenNavalGrowthFormation
            
            end
        
            BlockBuilderLand( seaUnitsList, seaBlock, NavalCategories, FormationPos, 0.9 )
            
        end
        
    end
    
    if airUnitsList.UnitTotal > 0 then
    
        BlockBuilderAir(airUnitsList, StaggeredChevronBlock, FormationPos)
        
    end
    
    UnitTotal = TransportUnitsList.UnitTotal or 0
    
    if UnitTotal > 0 then
    
        if UnitTotal <= 4 then
        
            BlockBuilderLand(TransportUnitsList, TwoWideTransportGrowthFormation, AirTransportCategories, FormationPos)
            
        elseif UnitTotal <= 9 then
        
            BlockBuilderLand(TransportUnitsList, ThreeWideTransportGrowthFormation, AirTransportCategories, FormationPos)
            
        elseif UnitTotal <= 16 then
        
            BlockBuilderLand(TransportUnitsList, FourWideTransportGrowthFormation, AirTransportCategories, FormationPos)            
            
        elseif UnitTotal <= 25 then
        
            BlockBuilderLand(TransportUnitsList, FiveWideTransportGrowthFormation, AirTransportCategories, FormationPos)
            
        end
        
    end 
    
    return FormationPos
    
end

function BlockFormation( formationUnits )   

    local smallUnitsList = {}
    local largeUnitsList = {}
    local smallUnits = 0
    local largeUnits = 0
    
    local footPrintSize

    for i,u in formationUnits do
    
        footPrintSize = u:GetFootPrintSize()

        if footPrintSize > 2.75 then
        
            largeUnitsList[largeUnits] = { u }
            largeUnits = largeUnits + 1
        else
        
            smallUnitsList[smallUnits] = { u }
            smallUnits = smallUnits + 1
        end
        
    end

    local FormationPos = {}
    local counter = 0
    
    local rotate = true
    local ALLUNITS = categories.ALLUNITS
    local width = math.ceil( math.sqrt(smallUnits+largeUnits) )
    local length = (smallUnits+largeUnits) / width
    
    local adjIndex, offsetX, offsetY, Y

    -- Put small units (Size 1 through 3) in front of the formation
    for i in smallUnitsList do
    
        Y = math.floor(i/width)
    
        offsetX = (( math.mod(i,width)  - math.floor(width* 0.5) ) * 1.5) + 1
        offsetY = ( Y - math.floor(length* 0.5) ) * 1.5

        counter = counter + 1
        FormationPos[counter] = { offsetX, -offsetY, ALLUNITS, Y, rotate }
    end

    -- Put large units (Size >= 2.75) in the back of the formation
    for i in largeUnitsList do
    
        adjIndex = smallUnits + i
        Y = math.floor(adjIndex/width)
        
        offsetX = (( math.mod(adjIndex,width)  - math.floor(width* 0.5) ) * 1.5) + 1
        offsetY = ( Y - math.floor(length* 0.5) ) * 1.5

        counter = counter + 1
        FormationPos[counter] = { offsetX, -offsetY, ALLUNITS, Y, rotate }      
    end

    return FormationPos
    
end


function ScatterFormation( formationUnits )

    --LOG("*AI DEBUG Creating Scatter Formation")

    local rotate = false
    
    local FormationPos = {}
    
    local numUnits = table.getn(formationUnits)

    local naval = false
    local sizeMult = 3
    
    for k,v in formationUnits do
    
        if not v.Dead and EntityCategoryContains( categories.NAVAL * categories.MOBILE, v ) then
            naval = true
            sizeMult = 8
            break
            
        elseif v.Dead then
            formationUnits[v] = nil
        end

    end

    local ringChange = 5
    local unitCount = 1

    -- make circle around center point
    
    for i in formationUnits do
    
        if unitCount == ringChange then
        
            ringChange = ringChange + 5
            
            if naval then
                sizeMult = sizeMult + 8
            else
                sizeMult = sizeMult + 3
            end
            unitCount = 1
        end
        
        offsetX = sizeMult * math.sin( lerp( unitCount/ringChange, 0.0, math.pi * 2.0 ))
        offsetY = sizeMult * math.cos( lerp( unitCount/ringChange, 0.0, math.pi * 2.0 ))
        
        --LOG('*FORMATION DEBUG: X=' .. offsetX .. ', Y=' .. offsetY )
        
        table.insert(FormationPos, { offsetX, offsetY, categories.ALLUNITS, 0, rotate })
        unitCount = unitCount + 1
        
    end

    return FormationPos
end
function ClusterFormation( formationUnits )
	
    local rotate = false
	
    local FormationPos = {}
	local counter = 0
	
    local numUnits = table.getn(formationUnits)
    
    local ring = 0
    local ringChange = 1
    local unitCount = 0
    local sizeMult = 0 --LOUDMAX(1.0, ringChange * 0.2)
    
    #-- make rings around center point
    for i in formationUnits do
       
		
        offsetX = sizeMult * math.sin( lerp( unitCount/ringChange, 0.0, math.pi * 2.0 ) )
        offsetY = sizeMult * math.cos( lerp( unitCount/ringChange, 0.0, math.pi * 2.0 ) )
		
		counter = counter + 1
        FormationPos[counter] = { offsetX, offsetY, categories.ALLUNITS, 0, rotate }
		
        unitCount = unitCount + 1
		
		if unitCount == ringChange then
            numUnits = numUnits - ringChange
            
            ring = ring + 1
            ringChange = (ring * 5) + ring
            sizeMult = math.max(0, ringChange * 0.14)
			
            if ringChange > numUnits then
                ringChange = numUnits
            end
            unitCount = 0
        end
    end

    return FormationPos
end
function DMSCircleFormation( formationUnits )

    local rotate = false
	
    local FormationPos = {}
	local counter = 0
	
    local numUnits = table.getn(formationUnits)

	local sizeMult = math.max(1.0, numUnits * 0.2)

    #-- make circle around center point
    for i in formationUnits do
	
        offsetX = sizeMult * math.sin( lerp( i/numUnits, 0.0, math.pi * 2.0 ) )
        offsetY = sizeMult * math.cos( lerp( i/numUnits, 0.0, math.pi * 2.0 ) )
		
		counter = counter + 1
        FormationPos[counter] = { offsetX, offsetY, categories.ALLUNITS, 0, rotate }
		
    end

    return FormationPos
end

function BlockBuilderLand( unitsList, formationBlock, categoryTable, FormationPos, spacing, linespacing)

    local normalized_row_width, colSpot, colType, halfway_column_spot
    
    local function GetColSpot(rowLen, col)

        normalized_row_width = rowLen

        -- row width is normalized to the next even value
        if math.mod(rowLen,2) == 1 then
    
            normalized_row_width = rowLen + 1
        end
        
        -- default to left unless current fill number is even then it's right
        colType = 'left'
    
        if math.mod(col, 2) == 0 then
    
            colType = 'right'
        end
        
        -- which fill number we'on divided in half
        colSpot = math.floor(col * 0.5)
    
        -- the spot number which is the centre spot
        halfway_column_spot = normalized_row_width * 0.5
        
        -- we're either left or right of the centre position by a certain amount
        if colType == 'left' then
    
            return halfway_column_spot - colSpot
        else
    
            return halfway_column_spot + colSpot
        end
    
    end

    -- between units --
    local spacing = spacing or .8
    
    -- between lines of units --
    -- this feature not yet implemented --
    -- LineBreak should still work if it's part of the data
    local linespacing = spacing or .8
    
    local numRows = table.getn(formationBlock)
    
    local i = 1
    local whichRow = 1
    local whichCol = 1
    
    local currRowLen = table.getn(formationBlock[whichRow])
    local inserted = false
    local formationLength = 0    
    local rowType = false
    
    local currColSpot, currSlot, HomogenousRows
    
    --LOG("*AI DEBUG BlockBuilderLand for "..unitsList.UnitTotal.." units using "..repr(unitsList) )

    -- loop thru all the units until all are done
    while unitsList.UnitTotal >= i do
    
        -- if at the end of row (current column > rowlength) then advance the row counter
        if whichCol > currRowLen then
        
            -- if we're at the last row of the formation then reset the row to 1
            -- the length of the formation is incremented by one PLUS the RowBreak value (this makes it a break between repetitions of the whole formation)
            if whichRow == numRows then
            
                whichRow = 1
                
                if formationBlock.RowBreak then
                
                    formationLength = formationLength + 1 + formationBlock.RowBreak
                    
                else
                
                    formationLength = formationLength + 1
                    
                end
                
            -- otherwise we're just onto the next row of the formation 
            -- the length of the formation is incremented by one PLUS the LineBreak value (LineBreak controls the spacing between rows of units)
            else
            
                whichRow = whichRow + 1
                
                if formationBlock.LineBreak then
                
                    formationLength = formationLength + 1 + formationBlock.LineBreak
                    
                else
                
                    formationLength = formationLength + 1
                    
                end
                
                rowType = false
                
            end
            
            whichCol = 1
            
            currRowLen = table.getn(formationBlock[whichRow])
            
        end
        
        -- using the number of spots in a row, and which fill value we're on in this iteration - which spot we will use
        -- this routine fills the middle of the row and then right and then left and then right again and left again
        currColSpot = GetColSpot(currRowLen, whichCol)
        
        -- which categories will go into this spot in this row
        currSlot = formationBlock[whichRow][currColSpot]
        
        for _, unittype in currSlot do
        
            HomogenousRows = formationBlock.HomogenousRows
            
            local grp = false

            for _, group in unittype do
            
                grp = group
            
                if not HomogenousRows or (rowType == false or rowType == unittype) then
                
                    if unitsList[group] > 0 then
                    
                        local xPos
                        
                        if math.mod( currRowLen, 2 ) == 0 then
                        
                            xPos = math.ceil(whichCol* 0.5) - .5
                            
                            if not (math.mod(whichCol, 2) == 0) then
                            
                                xPos = xPos * -1
                            end
                        else
                        
                            if whichCol == 1 then
                            
                                xPos = 0
                            else
                            
                                xPos = math.ceil( ( (whichCol-1) * 0.5 ) )
                                
                                if not (math.mod(whichCol, 2) == 0) then
                                
                                    xPos = xPos * -1
                                end
                            end
                        end
                        
                        if HomogenousRows and not rowType then
                        
                            rowType = unittype
                        end
                        
                        -- notice the use of whichRow to determine the movement delay between rows --
                        -- each successive row will start moving 1 tick later than the one ahead of it --
                        table.insert( FormationPos, { xPos * spacing, -formationLength, categoryTable[group], (whichRow-1), true} )

                        inserted = true
                        
                        unitsList[group] = unitsList[group] - 1
                        
                        break
                    end
                end
            end
        
            if inserted then
        
                i = i + 1
                inserted = false
                
                break

            end
            
        end
        
        whichCol = whichCol + 1
    end

    return FormationPos
end

--============ AIR BLOCK BUILDING =============#
function BlockBuilderAir(unitsList, airBlock, FormationPos)

    local numRows = table.getn(airBlock)
    local i = 1
    local whichRow = 1
    local whichCol = 1
    local chevronPos = 1
    local currRowLen = table.getn(airBlock[whichRow])
    
    local longestRow = 1
    local longestLength = 0
    
    while i < numRows do
        if table.getn(airBlock[i]) > longestLength then
            longestLength = table.getn(airBlock[i])
            longestRow = i
        end
        i = i + 1
    end
    
    local chevronSize = airBlock.ChevronSize or 5    
    local chevronType = false
    
    local formationLength = 0
    
    local spacing = 1.15
 
    i = 1
    
    local currSlot
    local inserted = false
    local xPos, yPos
    
    -- loop thru the unittypes found in UnitsList
    for _, cat in AirUnits do
    
        -- we have to reset all the control variables each loop to insure we
        -- get the 'overlaying' effect we're looking for
        i = 1
        
        whichRow = 1
        whichCol = 1
        
        chevronPos = 1
        currRowLen = table.getn(airBlock[whichRow])
        chevronType = false
        
        formationLength = 0
        
        -- check if there are any in the unit count
        if unitsList[cat] > 0 then
            
            -- now we can execute the original code -- driven by the number of units in the category
            -- recylcing the formation each time
            while unitsList[cat] >= i do
            
                -- reset values if we've filled a chevron
                if chevronPos > chevronSize then
        
                    chevronPos = 1
                    chevronType = false
            
                    if whichCol == currRowLen then
            
                        if whichRow == numRows then
                
                            if airBlock.RepeatAllRows then
                                whichRow = 1
                                currRowLen = table.getn(airBlock[whichRow])
                            end
                    
                        else
                            whichRow = whichRow + 1
                            currRowLen = table.getn(airBlock[whichRow])
                        end
                
                        formationLength = formationLength + 1
                        whichCol = 1
                
                    else
                        whichCol = whichCol + 1
                    end
                end
        
                currSlot = airBlock[whichRow][whichCol]

                xPos, yPos = GetChevronPosition(chevronPos, whichCol, currRowLen, formationLength)

                table.insert(FormationPos, {xPos*spacing, yPos*spacing, AirCategories[cat], 0, true})

                i = i + 1
        
                chevronPos = chevronPos + 1
            end
        end
    end

    return FormationPos
end


function GetChevronPosition(chevronPos, currCol, currRowLen, formationLen)
        
    local offset = math.floor(chevronPos* 0.5) * .375
    local xPos = offset
    
    if math.mod(chevronPos,2) == 0 then
        xPos = -1 * offset
    end
    
    local yPos = -offset
    
    yPos = yPos + ( formationLen * -1.5 )
    
    local firstBlockOffset = -2
    
    if math.mod(currRowLen,2) == 1 then
        firstBlockOffset = -1
    end
    
    local blockOff = math.floor(currCol* 0.5) * 2
    
    if math.mod(currCol,2) == 1 then
        blockOff = -blockOff
    end
    
    xPos = xPos + blockOff + firstBlockOffset
    
    return xPos, yPos
end
function CategorizeAirUnits( formationUnits )

    local LOUDENTITY = EntityCategoryContains

    local unitsList = { StdAirUnits = 0, T4AirUnits = 0, UnitTotal = 0 }
    
    for i,u in formationUnits do
    
        if not u.Dead then
            
            for subcat,_ in AirCategories do
            
                if LOUDENTITY( AirCategories[subcat], u) then
                
                    unitsList[subcat] = unitsList[subcat] + 1
                    unitsList.UnitTotal = unitsList.UnitTotal + 1
                    break
                end
            end
        end
        
    end

    return unitsList
end

function CategorizeTransportUnits( formationUnits )

    local LOUDENTITY = EntityCategoryContains

    local unitsList = { Trans1 = 0, Trans2 = 0, Trans3 = 0, Trans4 = 0, UnitTotal = 0 }
    
    for i,u in formationUnits do
    
        if not u.Dead then
        
            for subcat,_ in AirTransportCategories do
            
                if LOUDENTITY(AirTransportCategories[subcat], u) then
                
                    unitsList[subcat] = unitsList[subcat] + 1
                    unitsList.UnitTotal = unitsList.UnitTotal + 1
                    break                               
                end
            end         
        end
    end

    return unitsList
end

function CategorizeSeaUnits( formationUnits )

    local LOUDENTITY = EntityCategoryContains

    local unitsList = { UnitTotal = 0, BattleshipCount = 0, CarrierCount = 0, CruiserCount = 0, DestroyerCount = 0, FrigateCount = 0, LightCount = 0, MobileSonarCount = 0, SubCount = 0, NukeSubCount = 0, RemainingCategory = 0 }

    for i,u in formationUnits do
    
        if not u.Dead then
        
            for navcat,_ in NavalCategories do
            
                if LOUDENTITY(NavalCategories[navcat], u) then
                
                    unitsList[navcat] = unitsList[navcat] + 1
                    unitsList.UnitTotal = unitsList.UnitTotal + 1
                    break
                end
            end
        
            -- categorize subs
            for subcat,_ in SubmarineCategories do
            
                if LOUDENTITY(SubmarineCategories[subcat], u) then
                
                    unitsList[subcat] = unitsList[subcat] + 1
                    unitsList.UnitTotal = unitsList.UnitTotal + 1
                    break                               
                end
            end
        end
    end
    
    return unitsList
end
function CategorizeLandUnits( formationUnits )

    local unitsList = { UnitTotal = 0 }
    
    local LOUDENTITY = EntityCategoryContains
    
    for i,u in formationUnits do
    
        if not u.Dead then
        
            for landcat,_ in LandCategories do

                if LOUDENTITY(LandCategories[landcat], u) then
                
                    if unitsList[landcat] then
                
                        unitsList[landcat] = unitsList[landcat] + 1
                        unitsList.UnitTotal = unitsList.UnitTotal + 1
                        break
                        
                    else

                        unitsList[landcat] = 1
                        unitsList.UnitTotal = unitsList.UnitTotal + 1
                        break
                    end
                    
                end
            end
        end
    end

    return unitsList
end