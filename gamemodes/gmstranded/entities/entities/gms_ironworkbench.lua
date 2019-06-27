
AddCSLuaFile()

ENT.Base = "gms_base_entity"
ENT.PrintName = "Iron Workbench"

ENT.Model = "models/props_wasteland/controlroom_desk001b.mdl"

if ( CLIENT ) then return end

function ENT:OnUse( ply )
	ply:OpenCombiMenu( "gms_ironworkbench" )
end