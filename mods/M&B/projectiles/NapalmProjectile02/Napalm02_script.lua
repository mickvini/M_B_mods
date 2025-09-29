#
# Flamethrower Projectile
#
local NapalmProjectile02 = import('/mods/M&B/lua/BlackOpsprojectiles.lua').NapalmProjectile02
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat

Napalm = Class(NapalmProjectile02) {}
TypeClass = Napalm