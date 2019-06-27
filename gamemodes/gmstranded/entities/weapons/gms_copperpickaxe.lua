
AddCSLuaFile()

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.Base = "gms_base_weapon"
SWEP.PrintName = "Copper Pickaxe"
SWEP.ViewModel = "models/weapons/c_gms_pickaxe.mdl"
SWEP.WorldModel = "models/weapons/w_gms_pickaxe.mdl"

SWEP.Purpose = "Effective mining tool"
SWEP.Instructions = "Primary fire: Mine from a rock or rocky surface"

SWEP.HoldType = "melee"

SWEP.Primary.Damage = 8
SWEP.Primary.Delay = 1
SWEP.UseHands = true
SWEP.Skin = 1

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
			Chance = 60,
			MinAmount = 1,
			MaxAmount = 5
		} )
	else
		self:PlayHitSound()
	end
end
