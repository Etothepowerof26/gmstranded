
AddCSLuaFile()

ENT.Base = "gms_base_entity"
ENT.PrintName = "Gun Lab"

ENT.Model = "models/props/cs_militia/gun_cabinet.mdl"

if ( CLIENT ) then return end

function ENT:OnUse( ply )
	ply:OpenCombiMenu( "gms_gunlab" )
end
