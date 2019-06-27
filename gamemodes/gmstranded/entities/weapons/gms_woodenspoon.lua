
AddCSLuaFile()

SWEP.Slot = 1
SWEP.SlotPos = 1

SWEP.Base = "gms_base_weapon"
SWEP.PrintName = "Wooden Spoon"
SWEP.ViewModel = "models/Weapons/v_hands.mdl"
SWEP.WorldModel = "models/props_interiors/pot02a.mdl"

SWEP.Purpose = "For eating fruits"
SWEP.Instructions = "Eat some fruits"

SWEP.HoldType = "knife"

function SWEP:PrimaryAttack()
end

SWEP.FixWorldModel = true
SWEP.FixWorldModelPos = Vector( -1, -4, -4 )
SWEP.FixWorldModelAng = Angle( 90, 90, 0 )
SWEP.FixWorldModelScale = 0.6
