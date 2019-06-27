
AddCSLuaFile()

ENT.Base = "gms_base_entity"
ENT.PrintName = "Water Fountain"

ENT.Model = "models/props/de_inferno/fountain.mdl"

if ( CLIENT ) then return end

function ENT:OnUse( ply )
	if ( ply.Thirst >= 950 ) then
		ply.Thirst = 1000
		ply:UpdateNeeds()
		if ( ply.Hasdrunk == false or ply.Hasdrunk == nil ) then
			ply:EmitSound( Sound( "npc/barnacle/barnacle_gulp" .. math.random( 1, 2 ) .. ".wav" ) )
			ply.Hasdrunk = true
			timer.Simple( 0.9, function() ply.Hasdrunk = false end )
		end
	elseif ( ply.Thirst < 950 )  then
		ply.Thirst = ply.Thirst + 50
		if ( ply.Hasdrunk == false or ply.Hasdrunk == nil ) then
			ply:EmitSound( Sound( "npc/barnacle/barnacle_gulp" .. math.random( 1, 2 ) .. ".wav" ) )
			ply.Hasdrunk = true
			timer.Simple( 0.9, function() ply.Hasdrunk = false end )
		end
		ply:UpdateNeeds()
	end
end
