
AddCSLuaFile()

ENT.Base = "gms_base_entity"
ENT.PrintName = "Stone Furnace"

ENT.Model = "models/props/de_inferno/ClayOven.mdl"

if ( CLIENT ) then return end

function ENT:OnUse( ply )
	ply:OpenCombiMenu( "gms_stonefurnace" )
end
