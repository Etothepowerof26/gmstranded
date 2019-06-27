
AddCSLuaFile()

ENT.Base = "gms_base_entity"
ENT.PrintName = "Loot"

ENT.Model = "models/weapons/w_bugbait.mdl"
ENT.DoWake = true
ENT.Color = Color( 255, 0, 0, 255 )

if ( CLIENT ) then return end

function ENT:OnUse( ply )
	ply:DoProcess( "Loot", 5, {
		Entity = self,
		Resources = self.Resources
	} )
end

function ENT:Think()
	local effectdata = EffectData()
	effectdata:SetOrigin( self:GetPos() )
	util.Effect( "gms_loot_effect", effectdata )
end
