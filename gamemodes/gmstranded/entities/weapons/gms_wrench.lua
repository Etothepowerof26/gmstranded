
AddCSLuaFile()

SWEP.Slot = 2
SWEP.SlotPos = 5

SWEP.Base = "gms_base_weapon"
SWEP.PrintName = "Wrench"
SWEP.ViewModel = "models/Weapons/v_hands.mdl"
SWEP.WorldModel = "models/props_c17/tools_wrench01a.mdl"

SWEP.Purpose = "Shortens down weapon crafting time"
SWEP.Instructions = "Craft weapons faster"

SWEP.HoldType = "knife"

function SWEP:PrimaryAttack()
end

SWEP.FixWorldModel = true
SWEP.FixWorldModelPos = Vector( -1.5, 1, -3 )
SWEP.FixWorldModelAng = Angle( 90, 90, 0 )
SWEP.FixWorldModelScale = 1
