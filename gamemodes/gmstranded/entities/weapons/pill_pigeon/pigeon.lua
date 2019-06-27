
CROW = {}

CROW.BURROWIN = 1
CROW.BURROWOUT = 2
CROW.BURROWED = 3

CROW.damage = 25
CROW.model = Model( "models/crow.mdl" )
CROW.sounds = {}
CROW.sounds.attack = Sound( "Weapon_Bugbait.Splat" )
CROW.sounds.attackHit = Sound( "Weapon_Crowbar.Melee_Hit" )
CROW.sounds.banghowdy = Sound( "Weapon_Bugbait.Splat" )
CROW.sounds.burrowIn = Sound( "NPC_CROW.BurrowIn" )
CROW.sounds.burrowOut = Sound( "NPC_CROW.BurrowOut" )

CROW.Hooks = {}

function CROW.SetSpeeds( ply, run, sprint, crouch )
	ply:SetWalkSpeed( run )
	ply:SetRunSpeed( sprint )
	ply:SetCrouchedWalkSpeed( crouch )
end

function CROW.Enable( ply )
	if ( ply.CROW ) then return end
	if ( CLIENT ) then
		ply.CROW = true
		return
	end

	CROW.BangHowdy( ply )
	ply.CROW = {}
	ply.CROW.burrowed = nil
	ply.CROW.burrowedTimer = 0

	ply.CROW.model = ply:GetModel()
	ply.CROW.color = ply:GetColor()
	ply.CROW.speeds = { run = ply:GetWalkSpeed(), sprint = ply:GetRunSpeed(), crouch = ply:GetCrouchedWalkSpeed() }

	CROW.SetSpeeds( ply, 100, 100, 100 )
	ply:SetHull( Vector( -16, -16, 0 ), Vector( 16, 16, 32 ) )
	ply:SetHullDuck( Vector( -16, -16, 0 ), Vector( 16, 16, 32 ) )

	ply:SetModel( CROW.model )
	ply:SetRenderMode( RENDERMODE_TRANSALPHA )
	ply:SetColor( Color( 255, 255, 255, 0 ) )

	ply.CROW.ghost = CROW.Ghost( ply )
	ply:SetNetworkedEntity( "CROW.ghost", ply.CROW.ghost )
	if ( !ply.CROWHasPrinted ) then
		ply:PrintMessage( HUD_PRINTTALK, "You're a Crow! AWESOME!\nJump to start flying and then jump again to speed up.\nSprint to hop forward.\nReload to make a cute noise.\nMouse 1 or 2 to eat some ground and gain health.\n" )
		ply.CROWHasPrinted = true
	end
	ply.CROW.LastEatenTimer = CurTime() + 15
end

function CROW.Disable( ply )
	ply:ResetHull()

	if ( CLIENT ) then
		ply.CROW = false
		return
	end

	if ( !ply.CROW ) then return end
	CROW.BangHowdy( ply )
	ply.CROW.ghost:Remove()
	ply:SetNetworkedEntity( "CROW.ghost", nil )
	ply:SetModel( ply.CROW.model )
	ply:SetColor( ply.CROW.color )
	CROW.SetSpeeds( ply, ply.CROW.speeds.run, ply.CROW.speeds.sprint, ply.CROW.speeds.crouch )
	ply:SetMoveType( MOVETYPE_WALK )
	ply.CROW = nil

	/*if ( ply:HasUnlock( "Sprinting_II" ) ) then
		GAMEMODE:SetPlayerSpeed( ply, 400, 100 )
	elseif ( ply:HasUnlock( "Sprinting_I" ) ) then
		GAMEMODE:SetPlayerSpeed( ply, 250, 400 )
	else
		GAMEMODE:SetPlayerSpeed( ply, 250, 250 )
	end*/
end

if ( CLIENT ) then
	usermessage.Hook( "CROW.enable", function( um )
		if ( !IsValid( LocalPlayer() ) || !LocalPlayer().GetActiveWeapon ) then return end
		local weapon = LocalPlayer():GetActiveWeapon()
		if ( !IsValid( weapon ) or !weapon:IsWeapon() or weapon:GetClass() != "pill_pigeon" ) then return end
		CROW.Enable( LocalPlayer() )
	end )

	usermessage.Hook( "CROW.disable", function( um )
		if ( !IsValid( LocalPlayer() ) || !LocalPlayer().GetActiveWeapon ) then return end
		local weapon = LocalPlayer():GetActiveWeapon()
		if ( IsValid( weapon ) and weapon:IsWeapon() and weapon:GetClass() == "pill_pigeon" ) then return end
		CROW.Disable( LocalPlayer() )
	end )
end

function CROW.BangHowdy( ply )
	local ed = EffectData()
	ed:SetOrigin( ply:GetPos() )
	ed:SetStart( ply:GetPos() )
	ed:SetScale( 1000 )
	util.Effect( "cball_explode", ed )
	ply:EmitSound( CROW.sounds.banghowdy )
end

function CROW.Burrow( ply )
	if ( ply.CROW.burrowed != CROW.BURROWED and CurTime() < ply.CROW.burrowedTimer ) then return end
	if ( !ply.CROW.burrowed ) then
		if ( ply.CROW.attacking or not ply:OnGround() ) then return end 
		local t = {}
		t.start = ply:GetPos()
		t.endpos = t.start + Vector( 0, 0, -20 )
		t.filter = ply
		local tr = util.TraceLine( t )
		if ( !tr.HitWorld or !( tr.MatType == MAT_DIRT or tr.MatType == MAT_FOLIAGE or tr.MatType == MAT_SAND ) ) then
			ply:PrintMessage( HUD_PRINTTALK, "You can't eat that. Look for some dirt!" )
			return
		end
		ply:EmitSound( CROW.sounds.burrowIn )
		ply:SetMoveType( MOVETYPE_WALK )
		ply.CROW.burrowed = CROW.BURROWIN
		ply.CROW.burrowedTimer = CurTime() + 0.5
	else
		ply:EmitSound( CROW.sounds.burrowOut )
		ply:DrawShadow( true )
		ply.CROW.ghost:DrawShadow( true )
		ply.CROW.burrowed = CROW.BURROWOUT
		ply.CROW.burrowedTimer = CurTime() + 0.5
	end
	ply.CROW.LastEatenTimer = CurTime() + 15
end

function CROW.BurrowThink( ply )
	local health = ply:Health()
	if ( health >= ply:GetMaxHealth() ) then
		ply.CROW.burrowed = false
	end
	if ( !ply.CROW.burrowed ) then return end
	if ( CurTime() >= ply.CROW.burrowedTimer ) then
		if ( ply.CROW.burrowed == CROW.BURROWIN ) then
			ply:DrawShadow( false )
			ply.CROW.ghost:DrawShadow( false )
			ply.CROW.burrowed = CROW.BURROWED
		elseif ( ply.CROW.burrowed == CROW.BURROWOUT ) then
			ply:SetMoveType( MOVETYPE_WALK )
			ply.CROW.burrowed = false
		elseif ( ply.CROW.burrowed == CROW.BURROWED ) then
			if ( health < ply:GetMaxHealth() ) then ply:SetHealth( math.min( health + 2, ply:GetMaxHealth() ) ) end
			ply.CROW.burrowedTimer = CurTime() + 1
		end
	end
end

function CROW.Ghost( ply )
	local e = ents.Create( "prop_dynamic" )
	e:SetAngles( ply:GetAngles() )
	e:SetPos( ply:GetPos() )
	e:SetModel( CROW.model )
	e:SetCollisionGroup( COLLISION_GROUP_NONE )
	e:SetMoveType( MOVETYPE_NONE )
	e:SetSolid( SOLID_NONE )
	e:SetParent( ply )
	e:Spawn()
	return e
end

function CROW.Hooks.KeyPress( ply, key )
	local health = ply:Health()
	if ( !ply.CROW ) then return end

	if ( ply.CROW.burrowed ) then
		ply:SetMoveType( 0 )
		return
	end

	if ( health < 30 ) then
		GAMEMODE:SetPlayerSpeed( ply, 50, 100 )
	end

	if ( health >= 30 ) then
		if ( key == IN_JUMP and ply:IsOnGround() ) then
			ply:SetMoveType( 4 )
			ply:SetVelocity( ply:GetForward() * 300 + Vector( 0, 0, 100 ) )
		elseif ( key == IN_JUMP and ply:IsOnGround() ) then
			ply:SetMoveType( 2 )
		elseif ( key == IN_JUMP and !ply:IsOnGround() ) then
			ply:SetVelocity( ply:GetForward() * 300 + ply:GetAimVector() )
		elseif ply:IsOnGround() then
			ply:SetMoveType( 2 )
		elseif ( !ply:IsOnGround() and key == IN_WALK ) then
			ply:SetMaxSpeed( 250 )
		else
			ply:SetMoveType( 0 )
		end
	else
		ply:SetMoveType( 0 )
	end

	if ( health < 50 ) then return end

	if ( ply:OnGround() and key == IN_SPEED ) then
		ply:SetVelocity( ply:GetForward() * 1500 + Vector( 0, 0, 100 ) )
		ply:SetMoveType( 2 )
	end
end

function CROW.Hooks.UpdateAnimation( ply )
	if ( !ply.CROW ) then return end

	local sequence = "idle01"
	local rate = 1
	local speed = ply:GetVelocity():Length()

	if ( !ply.CROW.burrowed ) then
		if ( ply:IsOnGround() ) then
			ply:SetMoveType( 2 )
			if ( speed > 0 ) then
				sequence = "Walk"
				rate = 2
				ply:SetMaxSpeed( 200 )
				if ( speed > 200 ) then
					sequence = "Run"
				end
			end
		elseif ( !ply:IsOnGround() ) then
			ply:SetMoveType( 4 )
			ply:SetMaxSpeed( 100 )
			sequence = "Soar"
			if ( speed > 400 ) then sequence = "Fly01" end

			if ( ply:Health() < 30 ) then
				ply:SetMoveType( 2 )
				sequence = "Ragdoll"
			end
		elseif ( ply:WaterLevel() > 1 ) then
			sequence = "Soar"
		end
	elseif ( ply.CROW.burrowed == CROW.BURROWED ) then
		sequence = "Eat_a"
	end

	local sequenceIndex = ply:LookupSequence( sequence )
	if ( ply:GetSequence() != sequenceIndex ) then
		ply:Fire( "setanimation", sequence, 0 )
	end
	sequenceIndex = ply.CROW.ghost:LookupSequence( sequence )
	if ( ply.CROW.ghost:GetSequence() != sequenceIndex ) then
		ply.CROW.ghost:Fire( "setanimation", sequence, 0 )
	end
	ply:SetPlaybackRate( rate )
	ply.CROW.ghost:SetPlaybackRate( rate )
end

if ( CLIENT ) then return end

hook.Add( "KeyPress", "CROW.KeyPress", CROW.Hooks.KeyPress )
hook.Add( "UpdateAnimation", "CROW.UpdateAnimation", CROW.Hooks.UpdateAnimation )
hook.Add( "PlayerSetModel", "CROW.PlayerSetModel", function( ply ) if ( ply.CROW ) then return false end end )
hook.Add( "SetPlayerAnimation", "CROW.SetPlayerAnimation", function( ply, animation ) if ( ply.CROW ) then return false end end )
hook.Add( "PlayerHurt", "CROW.PlayerHurt", function( ply, attacker )
	if ( ply.CROW ) then ply:EmitSound( Sound( "npc/crow/pain" .. math.random( 1, 2 ) .. ".wav", 100, math.random( 95, 105 ) ) ) end
end )
