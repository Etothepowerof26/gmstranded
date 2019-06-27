
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "gms_base_entity"
ENT.PrintName = "Resource Pack"
ENT.Purpose = "To store resources."
ENT.Instructions = "Press use to open menu."

ENT.Model = "models/items/item_item_crate.mdl"

function ENT:OnInitialize()
	self.Resources = {}
end

if ( CLIENT ) then

local PendingRPDrops = PendingRPDrops or {}

usermessage.Hook( "gms_SetResPackInfo", function( um )
	local index = um:ReadString()
	local type = um:ReadString()
	local int = um:ReadShort()
	local ent = ents.GetByIndex( index )

	if ( int <= 0 ) then int = nil end

	if ( ent == NULL or !ent ) then
		local tbl = {}
		tbl.Type = type
		tbl.Amount = int
		tbl.Index = index
		table.insert( PendingRPDrops, tbl )

		//error("This happened: PendingRPDrops")
	else
		if ( !ent.Resources ) then ent.Resources = {} end
		ent.Resources[ type ] = int
		
		if ( IsValid( GAMEMODE.ResourcePackFrame ) ) then
			GAMEMODE.ResourcePackFrame:Update()
		end
	end
end )

hook.Add( "Think", "gms_CheckForPendingRPDrops", function()
	for k, tbl in pairs( PendingRPDrops ) do
		local ent = ents.GetByIndex( tbl.Index )
		if ( IsValid( ent ) ) then
			if ( !ent.Resources ) then ent.Resources = {} end
			ent.Resources[ tbl.Type ] = tbl.Amount
			table.remove( PendingRPDrops, k )

			if ( IsValid( GAMEMODE.ResourcePackFrame ) ) then
				GAMEMODE.ResourcePackFrame:Update()
			end
		end
	end
end )

return end

function ENT:StartTouch( ent )
	if ( ent:GetClass() == "gms_resourcedrop" ) then
		big_gms_combineresourcepack( self, ent )
	end
	if ( ent:GetClass() == "gms_buildsite" ) then 
		gms_addbuildsiteresourcePack( self, ent )
	end
end
