
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "gms_base_entity"
ENT.PrintName = "Buildsite"
ENT.Purpose = "To build."
ENT.Instructions = "Press use to add resources."

ENT.Model = ""
ENT.Color = Color( 90, 167, 243, 255 )

if ( CLIENT ) then return end

function ENT:OnInitialize()
	self:DropToFloor()
	self:SetMoveType( MOVETYPE_NONE )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
 	self:SetMaterial( "models/wireframe" )
 	self.LastUsed = CurTime()
end

function ENT:AddResource( res, int )
	self.Costs[ res ] = self.Costs[ res ] - int
	if ( self.Costs[ res ] <= 0 ) then self.Costs[ res ] = nil end

	local str = ":"
	for k, v in pairs( self.Costs ) do
		str = str .. "\n" .. string.Replace( k, "_", " " ) .. " ( " .. v .. "x )"
	end
	self:SetNetworkedString( "Resources", str )
end

function ENT:Setup( model, class )
	self:SetModel( model )
	self.ResultClass = class

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	local phys = self:GetPhysicsObject()
	if ( phys != NULL && phys ) then phys:EnableMotion( false ) end
end

function ENT:Finish()
	if ( self.ResultClass ) then
		local ent = ents.Create( self.ResultClass )
		if ( self.NormalProp == true ) then ent.NormalProp = true end
		ent:SetPos( self:GetPos() )
		ent:SetAngles( self:GetAngles() )
		ent:SetModel( self:GetModel() )
		ent.Player = self.Player
		ent:SetNWString( "Name", self.Name )
		ent:Spawn()

		local owner = ent.Player
		if ( !IsValid( owner ) ) then
			owner = Entity( self:GetNWInt( "OwnerID" ) )
			if ( IsValid( owner ) && self:GetNWString( "Owner" ) != owner:Nick() ) then owner = NULL end
		end
		if ( !IsValid( owner ) ) then owner = self.OwnerTable end
		SPropProtection.PlayerMakePropOwner( owner, ent )

		ent:Fadein()
	end

	if ( IsValid( self ) ) then
		if ( IsValid( self.Player ) ) then self.Player.HasBuildingSite = false end
		self:Remove()
	end
end

function ENT:OnUse( ply )
	if ( CurTime() - self.LastUsed < 0.5 ) then return end
	self.LastUsed = CurTime()

	-- Prevent fools from trapping other players inside just-built structures/props
	for id, ply in pairs( player.GetAll() ) do
		local mindist = self:OBBMaxs() - self:OBBMins()
		mindist = ( mindist.x + mindist.y + mindist.z ) / 3

		if ( ply:GetPos():Distance( self:LocalToWorld( self:OBBCenter() ) ) < mindist ) then
			ply:SendMessage( "Too close to other players!", 3, Color( 200, 10, 10, 255 ) )
			return
		end
	end

	if ( self.Costs ) then
		for k, v in pairs( self.Costs ) do
			if ( ply:GetResource( k ) >= 0 ) then
				if ( ply:GetResource( k ) < v ) then
					self:AddResource( k, ply:GetResource( k ) )
					ply:DecResource( k, ply:GetResource( k ) )
				else
					self:AddResource( k, v )
					ply:DecResource( k, v )
				end
			end
		end

		if ( table.Count( self.Costs ) > 0 ) then
			local str = "You need:"
			for k, v in pairs( self.Costs ) do
				str = str .. " " .. string.Replace( k, "_", " " ) .. " ( " .. v .. "x )"
			end
			str = str .. " to finish."
			ply:SendMessage( str, 5, Color( 255, 255, 255, 255 ) )
		else
			self:Finish()
			ply:SendMessage( "Finished!", 3, Color( 10, 200, 10, 255 ) )
		end
	else
		self:Finish()
		ply:SendMessage( "Finished!", 3, Color( 10, 200, 10, 255 ) )
	end
end
