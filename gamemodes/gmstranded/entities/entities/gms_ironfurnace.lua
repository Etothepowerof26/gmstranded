
AddCSLuaFile()

ENT.Base = "gms_base_entity"
ENT.PrintName = "Iron Furnace"

ENT.Model = "models/props_c17/furniturefireplace001a.mdl"

if ( CLIENT ) then return end

function ENT:OnUse( ply )
	ply:OpenCombiMenu( "gms_ironfurnace" )
end
