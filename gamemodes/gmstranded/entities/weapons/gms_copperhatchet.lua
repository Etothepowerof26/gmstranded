
AddCSLuaFile()

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.Base = "gms_base_weapon"
SWEP.PrintName = "Copper Hatchet"
SWEP.ViewModel = "models/weapons/c_gms_hatchet.mdl"
SWEP.WorldModel = "models/weapons/w_gms_hatchet.mdl"

SWEP.Purpose = "Effective woodcutting tool"
SWEP.Instructions = "Primary fire: Chop wood from a tree"

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
	if ( ent:IsTreeModel() ) then
		self.Owner:DoProcess( "WoodCutting", 2, {
			Entity = ent,
			Chance = 60,
			MinAmount = 2,
			MaxAmount = 7
		} )
	else
		self:PlayHitSound()
	end
end
