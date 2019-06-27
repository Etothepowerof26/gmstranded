
AddCSLuaFile()

ENT.Base = "gms_base_entity"
ENT.PrintName = "Copper Workbench"

ENT.Model = "models/props_combine/breendesk.mdl"

if ( CLIENT ) then return end

function ENT:OnUse( ply )
	ply:OpenCombiMenu( "gms_copperworkbench" )
end
