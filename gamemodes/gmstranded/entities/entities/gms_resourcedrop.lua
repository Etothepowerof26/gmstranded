
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "gms_base_entity"
ENT.PrintName = "Resource Drop"
ENT.Purpose = "To store resources."
ENT.Instructions = "Press use to pick up."

ENT.Model = "models/items/item_item_crate.mdl"

if CLIENT then return end

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
