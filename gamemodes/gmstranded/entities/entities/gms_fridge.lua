
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "gms_base_entity"
ENT.PrintName = "Fridge"
ENT.Purpose = "To store food."
ENT.Instructions = "Press use to open food menu."

ENT.Model = "models/props_c17/FurnitureFridge001a.mdl"

function ENT:OnInitialize()
	self.Resources = {}
end

if ( CLIENT ) then return end

function ENT:StartTouch( ent )
	if ( ent:GetClass() == "gms_food" ) then
		big_gms_combinefood( self, ent )
	end
end
