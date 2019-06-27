
NightLight = string.byte( "a" )
DayLight = string.byte( "m" )

NextPattern = NextPattern or DayLight
CurrentPattern = CurrentPattern or DayLight

RiseTime = 300
DayTime = 480
SetTime = 960
NightTime = 1200

StealTime = 0
Time = Time or RiseTime + 1

IsNight = false

if ( CLIENT ) then
	timer.Simple( 5, function()
		RunConsoleCommand( "pp_sunbeams", "0" )
	end )

	hook.Add( "RenderScreenspaceEffects", "RenderSunbeams", function()
		if ( !render.SupportsPixelShaders_2_0() ) then return end
		local sun = util.GetSunInfo()

		if ( !sun ) then return end
		if ( sun.obstruction == 0 ) then return end

		local sunpos = EyePos() + sun.direction * 4096
		local scrpos = sunpos:ToScreen()

		local dot = ( sun.direction:Dot( EyeVector() ) - 0.8 ) * 5
		if ( dot <= 0 ) then return end

		DrawSunbeams( 0.85, 1 * dot * sun.obstruction, 0.25, scrpos.x / ScrW(), scrpos.y / ScrH() )
	end )

	timer.Create( "DayTime.TimerClient", 1, 0, function()
		if ( GetConVarNumber( "gms_daynight" ) <= 0 ) then return end

		Time = Time + 1
		if ( Time > 1440 ) then Time = 0 end
	end )
elseif ( SERVER ) then

	RunConsoleCommand( "sv_skyname", "painted" )

	local GMS_DayColorTop = Vector( 0.22, 0.51, 1.0 )
	local GMS_DayColorBottom = Vector( 0.92, 0.93, 0.99 )
	local GMS_DayColorDusk = Vector( 1.0, 0.2, 0.0 )
	local GMS_Clouds = "skybox/clouds"
	local GMS_Stars = "skybox/starfield"
	local GMS_StarFade = 1//0.5
	local GMS_StarScale = 1.75
	local GMS_StarSpeed = 0.03
	theSky = theSky or nil

	hook.Add( "InitPostEntity", "gms_create_skypaint", function()
		if ( table.Count( ents.FindByClass( "env_skypaint" ) ) >= 1 ) then theSky = ents.FindByClass( "env_skypaint" )[ 1 ] return end
		theSky = ents.Create( "env_skypaint" )
		theSky:Spawn()
	end )

	timer.Create( "DayTime.TimerServer", 1, 0, function()
		if ( GetConVarNumber( "gms_daynight" ) <= 0 ) then return end

		Time = Time + 1
		if ( Time > 1440 ) then Time = 0 end

		//Time = CurTime() - math.floor( CurTime() / 1440 ) * 1440

		for id, sun in pairs( ents.FindByClass( "env_sun" ) or {} ) do
			sun:SetKeyValue( "pitch", math.NormalizeAngle( ( Time / 1440 * 360 ) + 90 ) )
			sun:Activate()
		end

		local coef = 0
		if ( Time >= NightTime && Time < RiseTime ) then // Night
			IsNight = true
			coef = 0
		elseif ( Time >= RiseTime && Time < DayTime ) then // Sunrise
			IsNight = false
			coef = 1 - ( DayTime - Time ) / ( DayTime - RiseTime ) // Calculate progress
		elseif ( Time >= DayTime && Time < SetTime ) then // Day
			IsNight = false
			coef = 1
		elseif ( Time >= SetTime && Time < NightTime ) then // Sunset
			IsNight = false
			coef = ( NightTime - Time ) / ( NightTime - SetTime ) // Calculate progress
		end

		local dusk_coef = coef
		if ( dusk_coef > 0.5 ) then
			dusk_coef = 1 - dusk_coef
			if ( IsValid( theSky ) ) then
				if ( theSky:GetStarTexture() != GMS_Clouds ) then
					theSky:SetStarTexture( GMS_Clouds )
					theSky:SetStarScale( GMS_StarScale )
				end
			end
		else
			if ( IsValid( theSky ) ) then
				if ( theSky:GetStarTexture() != GMS_Stars ) then
					theSky:SetStarTexture( GMS_Stars )
					theSky:SetStarScale( 0.5 )
				end
			end
		end

		if ( IsValid( theSky ) ) then
			theSky:SetTopColor( GMS_DayColorTop * coef )
			theSky:SetBottomColor( GMS_DayColorBottom * coef )
			theSky:SetStarFade( GMS_StarFade * ( 0.5 - dusk_coef ) )
			theSky:SetSunSize( 1 )

			if ( IsNight ) then dusk_coef = 0 end
			theSky:SetDuskColor( GMS_DayColorDusk * dusk_coef )
		end

		NextPattern = math.Clamp( NightLight + math.ceil( ( DayLight - NightLight ) * coef ), NightLight, DayLight )

		if ( NextPattern != CurrentPattern ) then
			for _, light in pairs( ents.FindByClass( "light_environment" ) or {} ) do
				light:Fire( "FadeToPattern", string.char( NextPattern ) )
				light:Activate()
			end

			//engine.LightStyle( 0, string.char( NextPattern - 1 ) )
			//for id, ply in pairs( player.GetAll() ) do ply:SendLua( "render.RedownloadAllLightmaps()" ) end

			CurrentPattern = NextPattern
		end

		if ( Time == StealTime && GetConVarNumber( "gms_night_cleanup" ) >= 1 ) then
			local drops = ents.FindByClass( "gms_resourcedrop" )
			local weaps = ents.FindByClass( "gms_resourcedrop" )
			local msg = false

			if ( #drops > 8 ) then for id, ent in pairs( drops ) do msg = true ent:Fadeout() end end
			if ( #weaps > 4 ) then for id, ent in pairs( weaps ) do msg = true ent:Fadeout() end end

			if ( msg ) then
				for id, ply in pairs( player.GetAll() ) do
					ply:SendMessage( "Something happened outside...", 5, Color( 255, 10, 10, 255 ) )

					timer.Simple( 10, function()
						ply:SendMessage( "So they dont't get stolen at night.", 5, Color( 255, 150, 150, 255 ) )
						ply:SendMessage( "Remember to store your resources in resoucepack, ", 5, Color( 255, 150, 150, 255 ) )
					end )
				end
			end

			for i = 0, math.random( 2, 6 ) do
				local zombies = #ents.FindByClass( "npc_zombie" )
				local fzombies = #ents.FindByClass( "npc_fastzombie" )
				if ( zombies + fzombies > 14 ) then break end
				local pos = Vector( math.random( -6000, 6000 ), math.random( -6000, 6000 ), 1800 )
				local tr = util.TraceLine( {
					start = pos, endpos = pos - Vector( 0, 0, 9999 )
				} )

				if ( tr.HitWorld ) then
					local class = "npc_zombie"
					if ( math.random( 0, 100 ) < 25 ) then class = "npc_fastzombie" end
					local zombie = ents.Create( class )
					zombie:SetPos( tr.HitPos + Vector( 0, 0, 64 ) )
					zombie:SetHealth( 128 )
					zombie:SetNWString( "Owner", "World" )
					zombie:SetKeyValue( "spawnflags", "1280" )
					zombie:Spawn()
					zombie:Fire( "Wake" )
					zombie:Activate()
			
					local ourEnemy = player.GetByID( math.random( 1, #player.GetAll() ) )
					if ( IsValid( ourEnemy ) ) then
						zombie:SetEnemy( ourEnemy )
						zombie:SetLastPosition( ourEnemy:GetPos() )
						zombie:SetSchedule( SCHED_FORCED_GO )
					end
				end
			end
		end
	end )
end
