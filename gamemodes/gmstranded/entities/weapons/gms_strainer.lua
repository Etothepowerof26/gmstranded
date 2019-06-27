
AddCSLuaFile()

SWEP.Slot = 3
SWEP.SlotPos = 1

SWEP.Base = "gms_base_weapon"
SWEP.PrintName = "Strainer"
SWEP.ViewModel = "models/Weapons/v_hands.mdl"
SWEP.WorldModel = "models/props_junk/PlasticCrate01a.mdl"

SWEP.Purpose = "Get fine materials"
SWEP.Instructions = "Use on/with some materials to filter them"

SWEP.HoldType = "slam"

function SWEP:OnHit( tr )

	if ( !tr.HitWorld || CLIENT ) then return end

	if ( tr.MatType == MAT_DIRT || tr.MatType == MAT_GRASS || tr.MatType == MAT_SAND ) then
		self.Owner:DoProcess( "FilterGround", 3 )
	end

end

SWEP.FixWorldModel = true
SWEP.FixWorldModelPos = Vector( 2, -10, 0 )
SWEP.FixWorldModelAng = Angle( 30, 30, 0 )
SWEP.FixWorldModelScale = 0.6
