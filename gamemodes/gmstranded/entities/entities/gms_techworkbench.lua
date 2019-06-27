
AddCSLuaFile()

ENT.Base = "gms_base_entity"
ENT.PrintName = "Tech Workbench"

ENT.Model = "models/props_lab/reciever_cart.mdl"

if ( CLIENT ) then return end

function ENT:OnUse( ply )
	ply:OpenCombiMenu( "gms_techworkbench" )
end
