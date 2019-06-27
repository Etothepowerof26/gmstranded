
AddCSLuaFile()

SWEP.Slot = 3
SWEP.SlotPos = 1

SWEP.Base = "gms_base_weapon"
SWEP.PrintName = "Sickle"
SWEP.ViewModel = "models/Weapons/v_hands.mdl"
SWEP.WorldModel = "models/props_c17/tools_pliers01a.mdl"

SWEP.Purpose = "Effectivizes harvesting processes"
SWEP.Instructions = "Harvest when active"

SWEP.HoldType = "melee"

function SWEP:PrimaryAttack()
end

SWEP.FixWorldModel = true
SWEP.FixWorldModelPos = Vector( 5, -3, -2 )
SWEP.FixWorldModelAng = Angle( 90, 0, -10 )
SWEP.FixWorldModelScale = 1
