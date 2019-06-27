
AddCSLuaFile()

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.Base = "gms_base_weapon"
SWEP.PrintName = "Shovel"
SWEP.ViewModel = "models/weapons/c_gms_shovel.mdl"
SWEP.WorldModel = "models/weapons/w_gms_shovel.mdl"

SWEP.Purpose = "Dig"
SWEP.Instructions = "Use primary to dig"

SWEP.HoldType = "melee"
SWEP.UseHands = true

SWEP.Primary.Damage = 10
SWEP.Primary.Delay = 1.5
SWEP.HitDistance = 92

function SWEP:PlaySwingSound()
	self:PlaySound( "npc/vort/claw_swing" .. math.random( 1, 2 ) .. ".wav" )
end

function SWEP:PlayHitSound()
	self:PlaySound( "weapons/gms_shovel" .. math.random( 1, 4 ) .. ".wav" )
end

function SWEP:OnHit( tr )

	local ent = tr.Entity
	if ( SERVER && ent:Health() > 0 ) then
		if ( ent:IsNPC() ) then ent:TakeDamage( self.Primary.Damage, self.Owner, self ) end
		self:PlayHitSound()
	end

	if ( !tr.HitWorld || CLIENT ) then
		if ( tr.Hit && SERVER ) then self:PlayHitSound() end
	return end

	if ( tr.MatType == MAT_DIRT || tr.MatType == MAT_GRASS || tr.MatType == MAT_SAND ) then
		self.Owner:DoProcess( "Dig", 5, {
			Sand = ( tr.MatType == MAT_SAND )
		} )
	else
		self.Owner:SendMessage( "Can't dig on this terrain!", 3, Color( 200, 0, 0, 255 ) )
		self:PlayHitSound()
	end

end

function SWEP:DoAnimation( missed )
	if ( missed ) then self:SendWeaponAnim( ACT_VM_MISSCENTER ) return end
	self:SendWeaponAnim( ACT_VM_HITCENTER )
end

function SWEP:DoEffects( tr )
	if ( IsFirstTimePredicted() ) then
		self:PlaySwingAnimation( !tr.HitWorld )
		self:PlaySwingSound()
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		if ( !tr.HitWorld || ( tr.MatType != MAT_DIRT && tr.MatType != MAT_GRASS && tr.MatType != MAT_SAND ) ) then
			self:DoImpactEffects( tr )
		else
			util.Decal( "impact.sand", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal )
		end
	end
end
