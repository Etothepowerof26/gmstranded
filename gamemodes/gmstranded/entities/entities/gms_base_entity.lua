
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "GMS Base Entity"
ENT.Author = "Stranded Team"
ENT.Spawnable = false

ENT.Model = "models/props/de_inferno/ClayOven.mdl"

function ENT:Initialize()
	if ( SERVER ) then
		self:SetModel( self.Model )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )

		if ( self.Color ) then self:SetColor( self.Color ) end
		if ( self.DoWake ) then self:Wake() end
		if ( self.DoFreeze ) then self:DoFreeze() end
	end

	self:OnInitialize()
end

function ENT:OnInitialize()
end

if ( CLIENT ) then return end

function ENT:Use( ply )
	if ( !ply:KeyPressed( IN_USE ) ) then return end
	if ( !SPropProtection.PlayerCanTouch( ply, self ) && GetConVarNumber( "spp_use" ) >= 1 ) then return end
	self:OnUse( ply )
end

function ENT:Wake()
	local phys = self:GetPhysicsObject()
	if ( IsValid( phys ) ) then phys:Wake() end
end

function ENT:Freeze()
	local phys = self:GetPhysicsObject()
	if ( IsValid( phys ) ) then phys:EnableMotion( false ) end
end

function ENT:OnTakeDamage( dmg )
	self:TakePhysicsDamage( dmg )
end

function ENT:OnUse( ply )
end
