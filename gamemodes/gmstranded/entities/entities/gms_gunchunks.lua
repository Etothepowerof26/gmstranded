
AddCSLuaFile()

ENT.Base = "gms_base_entity"
ENT.PrintName = "Gun Chunks"

ENT.Model = "models/Gibs/airboat_broken_engine.mdl"

if ( CLIENT ) then return end

function ENT:OnUse( ply )
	ply:OpenCombiMenu( "gms_gunchunks" )
end
