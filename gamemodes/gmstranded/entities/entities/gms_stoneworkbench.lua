
AddCSLuaFile()

ENT.Base = "gms_base_entity"
ENT.PrintName = "Stone Workbench"

ENT.Model = "models/props/de_piranesi/pi_merlon.mdl"

if ( CLIENT ) then return end

function ENT:OnUse( ply )
	ply:OpenCombiMenu( "gms_stoneworkbench" )
end
