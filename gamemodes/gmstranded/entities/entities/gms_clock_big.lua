
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Clock"
ENT.Category = "Robotboy655's Entities"

ENT.Spawnable = true

function ENT:Initialize()
	if ( CLIENT ) then return end
	self:SetModel( "models/props_trainstation/trainstation_clock001.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
end

function ENT:SpawnFunction( ply, tr )
	if ( !tr.Hit ) then return end

	local ent = ents.Create( ClassName )
	ent:SetPos( tr.HitPos + tr.HitNormal * 2 )
	ent:Spawn()
	ent:Activate()

	local phys = ent:GetPhysicsObject()
	if ( IsValid( phys ) ) then phys:Wake() end

	return ent
end

if ( SERVER ) then return end

surface.CreateFont( "Default_Clock", {
	font="Tahoma",
	size = 70,
	weight = 800
} )

function ENT:Draw()

	self:DrawModel()

	local ang = self:GetAngles()

	ang:RotateAroundAxis( ang:Right(), -90 )
	ang:RotateAroundAxis( ang:Up(), 90 )

	local pos = self:GetPos() + self:GetRight() * 15.5 + self:GetUp() * 15.5 + self:GetForward() * -0.9

	local hours = os.date( "%M", Time )
	local mins = os.date( "%S", Time )

	cam.Start3D2D( pos, ang, 0.0604 )

		draw.RoundedBox( 4, 100, 350, 305, 105, Color( 0, 0, 0, 255 ) )
		draw.SimpleText( hours .. ":" .. mins, "Default_Clock", 250, 400, Color( 255, 255, 255, 255 ) , 1, 1 )

		surface.SetDrawColor( Color( 0, 0, 0, 255 ) )

		-- Trigonometry, bitch
		mins = ( mins - 15 ) / 30 * math.pi
		hours = ( hours - 3 ) / 6 * math.pi
		surface.DrawLine( 256, 256, 256 + math.cos( mins ) * 350, 256 + math.sin( mins ) * 350 )
		surface.DrawLine( 256, 256, 256 + math.cos( hours ) * 250, 256 + math.sin( hours ) * 250 )

	cam.End3D2D()

end
