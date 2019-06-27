
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "gms_base_entity"
ENT.PrintName = "Food"
ENT.Purpose = "To eat."
ENT.Instructions = "Press use to eat."

ENT.Model = "models/props_c17/metalpot002a.mdl"

if ( CLIENT ) then

local PendingFoodDrops = PendingFoodDrops or {}

usermessage.Hook( "gms_SetFoodDropInfo", function( um )
	local index = um:ReadString()
	local type = um:ReadString()
	local ent = ents.GetByIndex( index )

	if ( ent == NULL or !ent ) then
		local tbl = {}
		tbl.Type = type
		tbl.Index = index
		table.insert( PendingFoodDrops, tbl )

		//error("This happened: PendingFoodDrops")
	else
		ent.Food = type
	end
end )

hook.Add( "Think", "gms_CheckForPendingFoodDrops", function()
	for k, tbl in pairs( PendingFoodDrops ) do
		local ent = ents.GetByIndex( tbl.Index )
		if ( ent != NULL ) then
			ent.Food = tbl.Type
			table.remove( PendingFoodDrops, k )
		end
	end
end )

if ( !GMS ) then return end

local texLogo = surface.GetTextureID("vgui/modicon")
function ENT:OnInitialize()
	self.AddAngle = Angle( 0, 0, 90 )
	self.FoodIcons = {}
	for k, v in pairs( GMS.Combinations[ "Cooking" ] ) do
		if ( v.Texture ) then self.FoodIcons[ k ] = surface.GetTextureID( v.Texture ) end
	end
end


function ENT:Draw()
	self:DrawModel()

	local food = self.Food or "Loading..."
	local tex = self.FoodIcons[ string.gsub( food, " ", "_" ) ] or texLogo

	cam.Start3D2D( self:GetPos() + Vector( 0, 0, 20 ), self.AddAngle, 0.01 )
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.SetTexture( tex )
		surface.DrawTexturedRect( -500, -500, 1000, 1000 )
	cam.End3D2D()

	cam.Start3D2D( self:GetPos() + Vector( 0, 0, 20 ), self.AddAngle + Angle( 0, 180, 0 ), 0.01 )
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.SetTexture( tex )
		surface.DrawTexturedRect( -500, -500, 1000, 1000 )
	cam.End3D2D()

	cam.Start3D2D( self:GetPos() + Vector( 0, 0, 25 ), self.AddAngle, 0.2)
		draw.SimpleText( food, "ScoreboardText", 0, 0, Color( 255, 255, 255, 255 ), 1, 1 )
	cam.End3D2D()

	cam.Start3D2D(self:GetPos() + Vector( 0, 0, 25 ), self.AddAngle + Angle( 0, 180, 0 ), 0.2 )
		draw.SimpleText( food, "ScoreboardText", 0, 0, Color( 255, 255, 255, 255 ), 1, 1 )
	cam.End3D2D()
end

function ENT:Think()
	self.AddAngle = self.AddAngle + Angle( 0, 2, 0 )
end

return end

function ENT:OnInitialize()
	self.Food = "Food"
end

function ENT:StartTouch( ent )
	if ( ent:GetClass() == "gms_resourcedrop" ) then
		big_gms_combineresourcepack( self, ent )
	end
	if ( ent:GetClass() == "gms_buildsite" ) then 
		gms_addbuildsiteresourcePack( self, ent )
	end
end
