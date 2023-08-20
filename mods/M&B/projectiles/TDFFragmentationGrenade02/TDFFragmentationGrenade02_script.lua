#****************************************************************************
#**
#**  File     :  TDFFragmentationGrenade02_script.lua
#**  Author(s):  Resin_Smoker
#**
#**  Summary  :  UEF Fragmentation Shells, UEL0107
#**
#**  Copyright © 2008 4th Dimension.  All rights reserved.
#****************************************************************************
local TFragmentationGrenade = import('/lua/terranprojectiles.lua').TFragmentationGrenade
local EffectTemplate = import('/lua/EffectTemplates.lua')

TDFFragmentationGrenade02 = Class(TFragmentationGrenade) {
}

TypeClass = TDFFragmentationGrenade02