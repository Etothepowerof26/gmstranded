
AddCSLuaFile()

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.Base = "gms_base_weapon"
SWEP.PrintName = "Frying Pan"
SWEP.ViewModel = "models/Weapons/v_hands.mdl"
SWEP.WorldModel = "models/props_c17/metalPot002a.mdl"

SWEP.Purpose = "Shortens down cooking times"
SWEP.Instructions = "Cook normally"

SWEP.HoldType = "knife"

function SWEP:PrimaryAttack()
end

SWEP.FixWorldModel = true
SWEP.FixWorldModelPos = Vector( 10, -1, -3.7 )
SWEP.FixWorldModelAng = Angle( 0, 90, 0 )
SWEP.FixWorldModelScale = 1
