
AddCSLuaFile()

ENT.Base = "gms_base_entity"
ENT.PrintName = "Factory"

ENT.Model = "models/props_c17/factorymachine01.mdl"

if ( CLIENT ) then return end

function ENT:OnUse( ply )
	ply:OpenCombiMenu( "gms_factory" )
end
