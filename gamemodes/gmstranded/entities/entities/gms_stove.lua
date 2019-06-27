
AddCSLuaFile()

ENT.Base = "gms_base_entity"
ENT.PrintName = "Stove"

ENT.Model = "models/props_c17/furniturestove001a.mdl"

if ( CLIENT ) then return end

function ENT:OnUse( ply )
	ply:OpenCombiMenu( "Cooking" )
end
