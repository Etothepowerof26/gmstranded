
function SPropProtection.PlayerIsPropOwner( ply, ent )
	if ( !IsValid( ent ) or ent:IsPlayer() ) then return false end

	if ( ent:GetNWString( "Owner" ) == ply:Nick() && ent:GetNWInt( "OwnerID" ) == ply:EntIndex() ) then
		return true
	end

	local HisTribe = GAMEMODE.FindTribeByID( ent:GetNWString( "TribeID" ) )

	if ( !HisTribe ) then return false end
	
	if ( ent:GetNWString( "TribeID" ) == ply:Team() && HisTribe.pass == true ) then return true end
	if ( ent:GetNWString( "TribeID" ) == ply:Team() && HisTribe.pass == true ) then return true end

	return false
end

function SPropProtection.PlayerCanTouch( ply, ent )
	if ( GetConVarNumber( "spp_enabled" ) == 0 or ent:GetClass() == "worldspawn" ) then return true end
	if ( ent:IsPlayer() or ent:IsNPC() ) then return false end

	/* Stranded Plants & Respacks*/
	local isResource = ent:GetClass() == "gms_resourcepack" or ent:GetClass() == "gms_resourcedrop" or ent:GetClass() == "gms_fridge"
	local isPlant = ent:IsBerryBushModel() or ent:IsGrainModel() or ent:IsFoodModel()
	if ( ( ent:GetNWString( "Owner" ) == "World" or GetConVarNumber( "spp_use" ) <= 0 ) && ( isResource or isPlant ) ) then
		return true
	end

	if ( ply:IsAdmin() && GetConVarNumber( "spp_admin" ) == 1 && ent:GetNWString( "Owner" ) != "World" ) then return true end
	if ( ply:IsAdmin() && GetConVarNumber( "spp_admin_wp" ) == 1 && ent:GetNWString( "Owner" ) == "World" ) then return true end

	if ( SPropProtection.PlayerIsPropOwner( ply, ent ) ) then return true end

	-- Find the player
	if ( !SPropProtection[ ply:SteamID() ] ) then return false end
	for id, p in pairs( player.GetAll() ) do
		if ( p:EntIndex() == ent:GetNWString( "OwnerID" ) ) then
			if ( table.HasValue( SPropProtection[ ply:SteamID() ], p:SteamID() ) ) then return true end
		end 
	end

	return false
end

local UndoneStuff = {}
hook.Add( "HUDPaint", "spp.hudpaint", function()
	if ( !IsValid( LocalPlayer() ) ) then return end
	if ( #UndoneStuff > 0 ) then for id, s in pairs( UndoneStuff ) do table.insert( SPropProtection[ LocalPlayer():SteamID() ], s ) end end
	local tr = LocalPlayer():GetEyeTrace()

	if ( !tr.HitNonWorld ) then return end
	local ent = tr.Entity

	if ( !IsValid( ent ) || ent:IsPlayer() || ent:IsNPC() || LocalPlayer():InVehicle() ) then return end

	local OwnerName = ent:GetNWString( "Owner", "None" )
	local OwnerObj = ent:GetNWEntity( "OwnerObj" )
	if ( IsValid( OwnerObj ) ) then OwnerName = OwnerObj:Name() end

	local TribeOwner = false
	local PropOwner = "Owner: " .. OwnerName
	local PropOwnerTribe = "Owner tribe: "

	local HisTribe = GAMEMODE.FindTribeByID( ent:GetNWInt( "TribeID", 1 ) )
	if ( HisTribe && HisTribe.pass == true ) then TribeOwner = true PropOwnerTribe = PropOwnerTribe .. HisTribe.name end

	surface.SetFont( "DefaultBold" )
	local tw = surface.GetTextSize( PropOwner )
	local tw2 = surface.GetTextSize( PropOwnerTribe )

	local w = math.max( ScrW() / 5, tw + 20, tw2 + 20 )
	local h = ScrH() / 24
	local x = ScrW() / 2 - w / 2
	local y = ScrH() - ScrH() / 16

	if ( TribeOwner ) then h = ScrH() / 18 end

	surface.SetDrawColor( StrandedBackgroundColor )
	surface.DrawRect( x, y, w, h )

	surface.SetDrawColor( StrandedBorderColor )
	surface.DrawOutlinedRect( x, y, w, h )

	if ( TribeOwner ) then
		draw.SimpleTextOutlined( PropOwner, "DefaultBold", x + w / 2, y + h / 4, StrandedTextColor, 1, 1, 0.5, StrandedTextShadowColor )
		draw.SimpleTextOutlined( PropOwnerTribe, "DefaultBold", x + w / 2, y + h / 1.5, StrandedTextColor, 1, 1, 0.5, StrandedTextShadowColor )
	else
		draw.SimpleTextOutlined( PropOwner, "DefaultBold", x + w / 2, y + h / 2, StrandedTextColor, 1, 1, 0.5, StrandedTextShadowColor )
	end
end )

usermessage.Hook( "spp_addbuddy", function( um )
	if ( !IsValid( LocalPlayer() ) || !LocalPlayer().SteamID ) then table.insert( UndoneStuff, um:ReadString() ) return end
	table.insert( SPropProtection[ LocalPlayer():SteamID() ], um:ReadString() )
end )

usermessage.Hook( "spp_clearbuddy", function( um )
	if ( !IsValid( LocalPlayer() ) || !LocalPlayer().SteamID ) then UndoneStuff = {} return end
	SPropProtection[ LocalPlayer():SteamID() ] = {}
end )
