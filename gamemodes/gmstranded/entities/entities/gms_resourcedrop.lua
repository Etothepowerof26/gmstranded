
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "gms_base_entity"
ENT.PrintName = "Resource Drop"
ENT.Purpose = "To store resources."
ENT.Instructions = "Press use to pick up."

ENT.Model = "models/items/item_item_crate.mdl"

if ( CLIENT ) then

local PendingRDrops = PendingRDrops or {}

usermessage.Hook( "gms_SetResourceDropInfo", function( um )
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
		table.insert( PendingRDrops, tbl )

		//error("This happened: PendingRDrops")
	else
		ent.Res = type
		ent.Amount = int
	end
end )

hook.Add( "Think", "gms_CheckForPendingRDrops", function()
	for k, tbl in pairs( PendingRDrops ) do
		local ent = ents.GetByIndex( tbl.Index )
		if ( ent != NULL ) then
			ent.Res = tbl.Type
            ent.Amount = tbl.Amount
			table.remove( PendingRDrops, k )
		end
	end
end )

return end

function ENT:OnInitialize()
	self.Type = "Resource"
 	self.Amount = 0
end

function ENT:StartTouch( ent )
	if ( ent:GetClass() == "gms_resourcedrop" && ent.Type == self.Type ) then
		big_gms_combineresource( self, ent )
	end
	if ( ent:GetClass() == "gms_buildsite" && ( ent.Costs[ self.Type ] != nil && ent.Costs[ self.Type ] > 0 ) ) then 
		gms_addbuildsiteresource( self, ent )
	end
end
