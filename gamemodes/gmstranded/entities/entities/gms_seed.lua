
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "gms_base_entity"
ENT.PrintName = "Seed"

ENT.Model = "models/weapons/w_bugbait.mdl"
ENT.Color = Color( 0, 255, 0, 255 )

if ( CLIENT ) then return end

function ENT:OnInitialize()
	self:SetMoveType( MOVETYPE_NONE )
end

function ENT:Setup( plantType, time, ply )
	self.Type = plantType
	if ( plantType != "tree" ) then ply:SetNWInt( "plants", ply:GetNWInt( "plants" ) + 1 ) end
	self:SetOwner( ply )

	timer.Create( "GMS_SeedTimers_" .. self:EntIndex(), time, 1, function() self:Grow() end )
end

function ENT:Grow()
	local ply = self:GetOwner()
	local pos = self:GetPos()

	local num = 1
	if ( IsValid( ply ) && ply:HasUnlock( "Adept_Farmer" ) ) then num = num + math.random( 0, 1 ) end
	if ( IsValid( ply ) && ply:HasUnlock( "Expert_Farmer" ) ) then num = num + math.random( 0, 2 ) end

	if ( self.Type == "tree" ) then
		GAMEMODE.MakeTree( pos )
	elseif ( self.Type == "melon" ) then
		GAMEMODE.MakeMelon( pos, num, ply )
	elseif ( self.Type == "banana" ) then
		GAMEMODE.MakeBanana( pos, num, ply )
	elseif ( self.Type == "orange" ) then
		GAMEMODE.MakeOrange( pos, num, ply )
	elseif ( self.Type == "grain" ) then
		GAMEMODE.MakeGrain( pos, ply )
	elseif ( self.Type == "berry" ) then
		GAMEMODE.MakeBush( pos, ply )
	end

	self.Grown = true
	self:Fadeout()
end

function ENT:OnRemove()
	if ( !self.Grown && self.Type != "tree"  && IsValid( self:GetOwner() ) ) then
		self:GetOwner():SetNWInt( "plants", self:GetOwner():GetNWInt( "plants" ) - 1 )
	end
	timer.Destroy( "GMS_SeedTimers_" .. self:EntIndex() )
end

function GAMEMODE.MakeGenericPlant( ply, pos, mdl, isTree )
	local ent = ents.Create( "prop_dynamic" )
	ent:SetAngles( Angle( 0, math.random( 0, 360 ), 0 ) )
	ent:SetSolid( SOLID_VPHYSICS )
	ent:SetModel( mdl )
	ent:SetPos( pos )
	ent:Spawn()
	ent.IsPlant = true
	ent:SetName( "gms_plant" .. ent:EntIndex() )

	ent:Fadein()
	ent:RiseFromGround( 1, 50 )

	if ( !isTree && IsValid( ply ) ) then
		ent:SetNWEntity( "plantowner", ply )
		SPropProtection.PlayerMakePropOwner( ply, ent )
	else
		ent:SetNWString( "Owner", "World" )
	end

	local phys = ent:GetPhysicsObject()
	if ( IsValid( phys ) ) then phys:EnableMotion( false ) end
	ent.PhysgunDisabled = true

	return ent
end

function GAMEMODE.MakeGenericPlantChild( ply, pos, mdl, parent )
	local ent = ents.Create( "prop_physics" )
	ent:SetAngles( Angle( 0, math.random( 0, 360 ) , 0 ) )
	ent:SetModel( mdl )
	ent:SetPos( pos )
	ent:Spawn()
	ent.IsPlantChild = true

	ent:SetHealth( 99999 )
	ent:Fadein()

	local phys = ent:GetPhysicsObject()
	if ( phys ) then phys:EnableMotion( false ) end

	ent.PlantParent = parent
	ent.PlantParentName = parent:GetName()
	parent.Children = parent.Children + 1

	if ( IsValid( ply ) ) then
		SPropProtection.PlayerMakePropOwner( ply, ent )
	else
		ent:SetNWString( "Owner", "World" )
	end

	ent.PhysgunDisabled = true

	return ent
end

function GAMEMODE.MakeTree( pos )
	GAMEMODE.MakeGenericPlant( ply, pos, GMS.TreeModels[ math.random( 1, #GMS.TreeModels ) ], true )
end

function GAMEMODE.MakeGrain( pos, ply )
	GAMEMODE.MakeGenericPlant( ply, pos + Vector( math.random( -10, 10 ), math.random( -10, 10 ), 0 ), "models/props_foliage/cattails.mdl" )
end

function GAMEMODE.MakeBush( pos, ply )
	GAMEMODE.MakeGenericPlant( ply, pos + Vector( math.random( -10, 10 ), math.random( -10, 10 ), 16 ), "models/props/pi_shrub.mdl" )
end

function GAMEMODE.MakeBanana( pos, num, ply )
	local plant = GAMEMODE.MakeGenericPlant( ply, pos + Vector( 0, 0, -3 ), "models/props/de_dust/du_palm_tree01_skybx.mdl" )
	plant.Children = 0

	for i = 1, num do
		GAMEMODE.MakeGenericPlantChild( ply, pos + Vector( math.random( -7, 7 ), math.random( -7, 7 ), math.random( 48, 55 ) ), "models/props/cs_italy/bananna_bunch.mdl", plant )
	end
end

function GAMEMODE.MakeMelon( pos, num, ply )
	local plant = GAMEMODE.MakeGenericPlant( ply, pos + Vector( 0, 0, 13 ), "models/props/CS_militia/fern01.mdl" )
	plant.Children = 0

	for i = 1, num do
		GAMEMODE.MakeGenericPlantChild( ply, pos + Vector( math.random( -25, 25 ), math.random( -25, 25 ), math.random( 5, 7 ) ), "models/props_junk/watermelon01.mdl", plant )
	end
end

function GAMEMODE.MakeOrange( pos, num, ply )
	local plant = GAMEMODE.MakeGenericPlant( ply, pos + Vector( 0, 0, -12 ), "models/props/cs_office/plant01_p1.mdl" )
	plant.Children = 0

	plant:SetCollisionGroup( 0 )
	plant:SetSolid( SOLID_NONE )
	plant.Children = 0

	for i = 1, num do
		GAMEMODE.MakeGenericPlantChild( ply, pos + Vector( math.random( -5, 5 ), math.random( -5, 5 ), math.random( 13, 30 ) ), "models/props/cs_italy/orange.mdl", plant )
	end
end
