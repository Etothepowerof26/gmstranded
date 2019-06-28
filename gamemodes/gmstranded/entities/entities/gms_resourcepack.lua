
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

if CLIENT then return end

function ENT:StartTouch( ent )
	if ( ent:GetClass() == "gms_resourcedrop" ) then
		big_gms_combineresourcepack( self, ent )
	end
	if ( ent:GetClass() == "gms_buildsite" ) then 
		gms_addbuildsiteresourcePack( self, ent )
	end
end
