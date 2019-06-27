
AddCSLuaFile()

SWEP.Slot = 3
SWEP.SlotPos = 1

SWEP.Base = "gms_base_weapon"
SWEP.PrintName = "Iron Pickaxe"
SWEP.ViewModel = "models/weapons/c_gms_pickaxe.mdl"
SWEP.WorldModel = "models/weapons/w_gms_pickaxe.mdl"

SWEP.Purpose = "Effective mining tool"
SWEP.Instructions = "Primary fire: Mine from a rock or rocky surface"

SWEP.HoldType = "melee"

SWEP.Primary.Damage = 10
SWEP.Primary.Delay = 1
SWEP.UseHands = true
SWEP.Skin = 2

function SWEP:PlaySwingSound()
	self:PlaySound( "weapons/iceaxe/iceaxe_swing1.wav" )
end

function SWEP:PlayHitSound()
	self:PlaySound( "physics/glass/glass_bottle_impact_hard" .. math.random( 1, 3 ) .. ".wav" )
end

function SWEP:DoToolHit( ent )
	if ( ent:IsRockModel() ) then
		self.Owner:DoProcess( "Mining", 2, {
			Entity = ent,
			Chance = 70,
			MinAmount = 3,
			MaxAmount = 7
		} )
	else
		self:PlayHitSound()
	end
end
