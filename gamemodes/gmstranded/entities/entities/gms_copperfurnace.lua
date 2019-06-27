
AddCSLuaFile()

ENT.Base = "gms_base_entity"
ENT.PrintName = "Copper Furnace"

ENT.Model = "models/props/cs_militia/furnace01.mdl"

if ( CLIENT ) then return end

function ENT:OnUse( ply )
	ply:OpenCombiMenu( "gms_copperfurnace" )
end
