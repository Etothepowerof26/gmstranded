
AddCSLuaFile()
AddCSLuaFile( "pigeon.lua" )

include( "pigeon.lua" )

SWEP.PrintName = "Crow Pill"
SWEP.Slot = 5
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Author = "grea$emonkey"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = "Press reload to make a cute sound.\nJump to start flying, jump again to speed up."

SWEP.Spawnable = false

SWEP.Primary.ClipSize, SWEP.Secondary.ClipSize = -1, -1
SWEP.Primary.DefaultClip, SWEP.Secondary.DefaultClip = -1, -1
SWEP.Primary.Automatic, SWEP.Primary.Automatic = false, false
SWEP.Primary.Ammo, SWEP.Secondary.Ammo = "none", "none"
SWEP.ViewModel = Model( "models/weapons/v_hands.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_crowbar.mdl" )

function SWEP:Deploy()
	CROW.Enable( self.Owner )
	if ( CLIENT ) then return end
	self.Owner:DrawViewModel( false )
	timer.Simple( 0.01, function() self.Owner:DrawViewModel( false ) end )
	self.Owner:DrawWorldModel( false )
	umsg.Start( "CROW.enable", self.Owner )
	umsg.End()
	return true
end

function SWEP:Holster()
	CROW.Disable( self.Owner )
	if ( CLIENT ) then return end
	if ( self.Owner:Health() <= 0 ) then
		umsg.Start( "CROW.disable", self.Owner )
		umsg.End()
	end
	return true
end

if ( CLIENT ) then

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	draw.SimpleText( "5", "HL2MPTypeDeath", x + wide / 2, y + tall * 0.2, Color( 255, 210, 0, 255 ), TEXT_ALIGN_CENTER )
end

function SWEP:CalcView( ply, pos, ang, fov )
	if ( !ply.CROW ) then return end
	ang = ply:GetAimVector():Angle()
	local ghost = ply:GetNetworkedEntity( "CROW.ghost" )
	if ( ghost and ghost:IsValid() ) then
		if ( GetViewEntity() == ply ) then
			ghost:SetColor( Color( 255, 255, 255, 255 ) )
		else
			ghost:SetColor( Color( 255, 255, 255, 255 ) )
			return
		end
	end

	local t = {}
	t.start = ply:GetPos() + ang:Up() * 20
	t.endpos = t.start + ang:Forward() * -50
	t.filter = ply
	local tr = util.TraceLine( t )
	pos = tr.HitPos

	if ( tr.Fraction < 1 ) then pos = pos + tr.HitNormal * 2 end
	return pos, ang, fov
end

return end

function SWEP:Destroy()
	hook.Remove( "KeyPress","CROW.KeyPress" )
	hook.Remove( "PlayerHurt", "CROW.PlayerHurt" )
	hook.Remove( "PlayerSetModel", "CROW.PlayerSetModel" )
	hook.Remove( "SetPlayerAnimation", "CROW.SetPlayerAnimation" )
	hook.Remove( "UpdateAnimation", "CROW.UpdateAnimation" )
end

function SWEP:PrimaryAttack()
	CROW.Burrow( self.Owner )
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack()
end

SWEP.NextCrowTimer = 0
function SWEP:Reload()
	if ( CurTime() >= self.NextCrowTimer ) then
		self.NextCrowTimer = CurTime() + 2
		self.Owner:EmitSound( Sound( "npc/crow/idle" .. math.random( 1, 4 ) .. ".wav", 100, math.random( 90, 110 ) ) )
	end
end

function SWEP:Think()
	self.Owner.CROW.ghost:SetLocalAngles( self.Owner:GetAngles() )
	self.Owner.CROW.ghost:SetAngles( self.Owner:GetAngles() )
	CROW.BurrowThink( self.Owner )
end
