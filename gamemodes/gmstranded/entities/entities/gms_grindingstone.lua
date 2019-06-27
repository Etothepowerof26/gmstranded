
AddCSLuaFile()

ENT.Base = "gms_base_entity"
ENT.PrintName = "Grinding Stone"

ENT.Model = "models/props_combine/combine_mine01.mdl"

if ( CLIENT ) then return end

function ENT:OnUse( ply )
	ply:OpenCombiMenu( "gms_grindingstone" )
end
