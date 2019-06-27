
SPropProtection[ "Props" ] = SPropProtection[ "Props" ] or {}

if ( cleanup ) then
	local Clean = cleanup.Add
	function cleanup.Add( ply, Type, ent )
		if ( IsValid( ent ) && ply:IsPlayer() ) then SPropProtection.PlayerMakePropOwner( ply, ent ) end
		Clean( ply, Type, ent )
	end
end

local Meta = FindMetaTable("Player")
if ( Meta.AddCount ) then
	local Backup = Meta.AddCount
	function Meta:AddCount( Type, ent )
		SPropProtection.PlayerMakePropOwner( self, ent )
		Backup( self, Type, ent )
	end
end

function SPropProtection.NofityAll( Text )
	for k, ply in pairs( player.GetAll() ) do
		SPropProtection.Nofity( ply, Text )
	end
end

function SPropProtection.Nofity( ply, Text )
	ply:SendLua("GAMEMODE:AddNotify(\"" .. Text .. "\", NOTIFY_GENERIC, 5); surface.PlaySound(\"ambient/water/drip" .. math.random(1, 4) .. ".wav\")")
	ply:PrintMessage( HUD_PRINTCONSOLE, Text )
end

function SPropProtection.PlayerMakePropOwner( ply, ent )
	if ( !IsValid( ent ) or ent:IsPlayer() ) then return end

	if ( ply && type( ply ) == "table" ) then
		SPropProtection[ "Props" ][ ent:EntIndex() ] = { ply.SteamID, ent }
		ent:SetNWString( "Owner", ply.Nick )
		ent:SetNWInt( "OwnerID", ply.EntIndex )
		ent:SetNWInt( "TribeID", ply.Team )
		return true
	end

	if ( !IsValid( ply ) or !ply:IsPlayer() ) then return end

	SPropProtection[ "Props" ][ ent:EntIndex() ] = { ply:SteamID(), ent }
	ent:SetNWString( "Owner", ply:Nick() )
	ent:SetNWInt( "OwnerID", ply:EntIndex() )
	ent:SetNWInt( "TribeID", ply:Team() )
	gamemode.Call( "CPPIAssignOwnership", ply, ent )
	return true
end

function SPropProtection.PlayerIsPropOwner( ply, ent )
	if ( !IsValid( ent ) or ent:IsPlayer() ) then return false end
	if ( !SPropProtection[ "Props" ][ ent:EntIndex() ] ) then return false end

	if ( SPropProtection[ "Props" ][ ent:EntIndex() ][ 1 ] == ply:SteamID() && ent:GetNWString( "Owner" ) == ply:Nick() && ent:GetNWInt( "OwnerID" ) == ply:EntIndex() ) then
		return true
	else
		return false
	end
end

function SPropProtection.IsBuddy( ply, ent )
	if ( SPropProtection.PlayerIsPropOwner( ply, ent ) ) then return true end
	if ( ply:IsAdmin() && GetConVarNumber( "spp_admin" ) == 1 && ent:GetNWString( "Owner" ) != "World" ) then return true end
	if ( ply:IsAdmin() && GetConVarNumber( "spp_admin_wp" ) == 1 && ent:GetNWString( "Owner" ) == "World" ) then return true end
	if ( ply:Team() == ent:GetNWInt( "TribeID", 1 ) && GAMEMODE.FindTribeByID( ply:Team() ).password != false ) then return true end
	if ( ent:IsPlayer() or ent:IsNPC() ) then return false end
	if ( ent:GetNWString( "Owner" ) == "World" ) then return false end

	for k, v in pairs( player.GetAll() ) do
		if ( IsValid( v ) && v != ply ) then
			if ( !SPropProtection[ "Props" ][ ent:EntIndex() ] ) then continue end
			if ( SPropProtection[ "Props" ][ ent:EntIndex() ][ 1 ] == v:SteamID() ) then
				if ( !SPropProtection[ v:SteamID() ] ) then return false end

				if ( table.HasValue( SPropProtection[ v:SteamID() ], ply:SteamID() ) ) then
					return true
				else
					return false
				end
			end
		end
	end	
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

	if ( ( !ent:GetNWString( "Owner" ) or ent:GetNWString( "Owner" ) == "" ) && !ent:IsPlayer() ) then
		SPropProtection.PlayerMakePropOwner( ply, ent )
		SPropProtection.Nofity( ply, "You now own this prop" )
		return true
	end

	if ( ply:IsAdmin() && GetConVarNumber( "spp_admin" ) == 1 && ent:GetNWString( "Owner" ) != "World" ) then return true end
	if ( ply:IsAdmin() && GetConVarNumber( "spp_admin_wp" ) == 1 && ent:GetNWString( "Owner" ) == "World" ) then return true end
	if ( SPropProtection.IsBuddy( ply, ent ) ) then return true end
	if ( SPropProtection[ "Props" ][ ent:EntIndex() ] != nil && SPropProtection[ "Props" ][ ent:EntIndex() ][ 1 ] == ply:SteamID() ) then
		return true
	end

	return false
end

function SPropProtection.DRemove( SteamID, PlayerName )
	for k, v in pairs( SPropProtection[ "Props" ] ) do
		if ( v[ 1 ] == SteamID and IsValid( v[ 2 ] ) ) then
			v[ 2 ]:Remove()
			SPropProtection[ "Props" ][ k ] = nil
		end
	end
	SPropProtection.NofityAll( tostring( PlayerName ) .. "'s props have been cleaned up" )
end

/* Tribe PP */

SPropProtection.EmptifiedTribes = SPropProtection.EmptifiedTribes or {}
function SPropProtection.RemoveTribeProps( TribeID )
	for k, v in pairs( SPropProtection[ "Props" ] ) do
		if ( IsValid(v[2]) and tonumber(v[2]:GetNWInt( "TribeID" ) ) == TribeID ) then
			v[2]:Remove()
			SPropProtection["Props"][k] = nil
		end
	end
	SPropProtection.NofityAll( "Props of " .. GAMEMODE.FindTribeByID( TribeID ).name .. " have been cleaned up" )
	SPropProtection.EmptifiedTribes[ TribeID ] = true
end

function SPropProtection.CheckForEmptyTribes()
	for id, t in pairs( GAMEMODE.Tribes ) do
		if ( team.NumPlayers( id ) == 0 && t.password != false && !timer.Exists( "SPropProtection.RemoveTribeProps: " .. id ) && !SPropProtection.EmptifiedTribes[ id ] ) then
			timer.Create( "SPropProtection.RemoveTribeProps: " .. id, GetConVarNumber( "spp_del_delay" ), 1, function() SPropProtection.RemoveTribeProps( id ) end )
		elseif ( team.NumPlayers( id ) > 0 ) then
			SPropProtection.EmptifiedTribes[ id ] = false
			timer.Remove( "SPropProtection.RemoveTribeProps: " .. id )
		end
	end
end

function SPropProtection.TribePP( ply )
	for k, v in pairs( SPropProtection[ "Props" ] ) do
		if ( v[ 1 ] == ply:SteamID() && IsValid( v[ 2 ] ) ) then
			v[ 2 ]:SetNWInt( "TribeID", ply:Team() )

			timer.Remove( "SPropProtection.RemoveTribeProps: " .. ply:Team() )
			SPropProtection.CheckForEmptyTribes()
		end
	end
end

/* Hooks */

hook.Add( "PlayerInitialSpawn", "SPropProtection.PlayerInitialSpawn", function( ply )
	ply:SetNWString( "SPPSteamID", string.gsub( ply:SteamID(), ":", "_" ) )
	SPropProtection[ ply:SteamID() ] = {}
	SPropProtection.LoadBuddies( ply )
	SPropProtection.TribePP( ply )

	timer.Remove( "SPropProtection.DRemove: " .. ply:SteamID() )
end )

hook.Add( "PlayerDisconnected", "SPropProtection.Disconnect", function( ply )
	if ( GetConVarNumber( "spp_del_disconnected" ) == 0 ) then return end
	if ( ply:IsAdmin() && GetConVarNumber( "spp_del_adminprops" ) <= 0 ) then return end
	if ( GAMEMODE.FindTribeByID( ply:Team() ).password == false ) then
		local nick = ply:Nick()
		local id = ply:SteamID()
		timer.Create( "SPropProtection.DRemove: " .. ply:SteamID(), GetConVarNumber( "spp_del_delay" ), 1, function() SPropProtection.DRemove( id, nick ) end )
	end
	SPropProtection.CheckForEmptyTribes()
end )

hook.Add( "EntityTakeDamage", "SPropProtection.EntityTakeDamage", function( ent, inflictor, attacker, amount, dmginfo )
	if ( !IsValid( ent ) || !IsValid( attacker ) ) then return end
	if ( string.find( ent:GetClass(), "npc_" ) ) then return end
	if ( GetConVarNumber( "spp_entdmg" ) == 0 ) then return end
	if ( ent:IsPlayer() or !attacker:IsPlayer() ) then return end
	if ( !SPropProtection.PlayerCanTouch( attacker, ent ) ) then
		local total = ent:Health() + amount
		if ( ent:GetMaxHealth() > total ) then ent:SetMaxHealth( total ) else ent:SetHealth( total ) end
	end
end )

hook.Add( "PlayerUse", "SPropProtection.PlayerUse", function(ply, ent)
	if ( ent:IsValid() && GetConVarNumber( "spp_use" ) >= 1 ) then
		return SPropProtection.PlayerCanTouch( ply, ent )
	end
end )

hook.Add( "OnPhysgunReload", "SPropProtection.OnPhysgunReload", function( weapon, ply )
	local tr = ply:GetEyeTrace()
	if ( !tr.HitNonWorld or !IsValid( tr.Entity ) or tr.Entity:IsPlayer() ) then return end
	if ( !SPropProtection.PlayerCanTouch( ply, tr.Entity ) ) then return false end
end )

hook.Add( "EntityRemoved", "SPropProtection.EntityRemoved", function( ent )
	SPropProtection[ "Props" ][ ent:EntIndex() ] = nil
end )

hook.Add( "PlayerSpawnedSENT", "SPropProtection.PlayerSpawnedSENT", function( ply, ent )
	SPropProtection.PlayerMakePropOwner( ply, ent )
end )

hook.Add( "PlayerSpawnedVehicle", "SPropProtection.PlayerSpawnedVehicle", function( ply, ent )
	SPropProtection.PlayerMakePropOwner( ply, ent )
end )

hook.Add( "InitPostEntity", "spp_map_ents", function()
	local WorldEnts = 0
	for k, v in pairs( ents.GetAll() ) do
		if ( !v:IsPlayer() and !v:GetNWString( "Owner", false ) ) then
			v:SetNetworkedString( "Owner", "World" )
			WorldEnts = WorldEnts + 1
		end
	end
	MsgC( Color( 64, 176, 255 ), "\n[ Simple Prop Protection ] " .. tostring( WorldEnts ) .. " props belong to world\n\n" )
end )

/* Commands */

concommand.Add( "spp_cleanup_props_left", function( ply, cmd, args )
	if ( !ply:IsAdmin() ) then return end
	for k1, v1 in pairs( SPropProtection[ "Props" ] ) do
		local FoundUID = false
		for k2, v2 in pairs( player.GetAll() ) do
			if( v1[ 1 ] == v2:SteamID() ) then
				FoundUID = true
			end
		end
		if ( FoundUID == false and IsValid( v1[ 2 ] ) ) then
			v1[ 2 ]:Remove()
			SPropProtection[ "Props" ][ k1 ] = nil
		end
	end
	SPropProtection.NofityAll("Disconnected players props have been cleaned up")
end )

concommand.Add( "spp_cleanup_props", function( ply, cmd, args )
	if ( !args[1] or args[1] == "" ) then
		for k, v in pairs( SPropProtection["Props"] ) do
			if (v[1] == ply:SteamID()) then
				if (v[2]:IsValid()) then
					v[2]:Remove()
					SPropProtection["Props"][k] = nil
				end
			end
		end
		SPropProtection.Nofity(ply, "Your props have been cleaned up")
	elseif ( ply:IsAdmin() ) then
		for k, v in pairs(player.GetAll()) do
			local NWSteamID = v:GetNWString( "SPPSteamID" )
			if ( args[1] == NWSteamID or args[2] == NWSteamID or string.find( string.Implode( " ", args ), NWSteamID ) != nil) then
				for a, b in pairs( SPropProtection[ "Props" ] ) do
					if ( b[1] == v:SteamID() && IsValid( b[ 2 ] ) ) then
						b[2]:Remove()
						SPropProtection[ "Props" ][ a ] = nil
					end
				end
				SPropProtection.NofityAll( v:Nick() .. "'s props have been cleaned up" )
			end
		end
	end
	ply:SetNWInt( "plants", 0 )
end )

/* Buddies */

function SPropProtection.SyncBuddies( ply )
	for id, pl in pairs( player.GetAll() ) do
		umsg.Start( "spp_clearbuddy", pl ) umsg.End()
		if ( table.HasValue( SPropProtection[ ply:SteamID() ], pl:SteamID() ) ) then
			umsg.Start( "spp_addbuddy", pl )
				umsg.String( ply:SteamID() )
			umsg.End()
		end
	end
end

function SPropProtection.LoadBuddies( ply )
	local PData = ply:GetPData( "SPPBuddies", "" )
	if ( PData == "" ) then return end
	for k, v in pairs( string.Explode( ";", PData ) ) do
		local v = string.Trim( v )
		if ( v != "" ) then table.insert( SPropProtection[ ply:SteamID() ], v ) end
	end

	SPropProtection.SyncBuddies( ply )
end

concommand.Add( "spp_apply_buddies", function( ply, cmd, args )
	if ( table.Count( player.GetAll() ) > 1 ) then
		local ChangedFriends = false
		for k, v in pairs( player.GetAll() ) do
			local PlayersSteamID = v:SteamID()
			local PData = ply:GetPData( "SPPBuddies", "" )
			if ( tonumber( ply:GetInfo( "spp_buddy_" .. v:GetNWString("SPPSteamID") ) ) == 1 ) then
				if ( !table.HasValue( SPropProtection[ ply:SteamID() ], PlayersSteamID ) ) then
					ChangedFriends = true
					table.insert( SPropProtection[ ply:SteamID() ], PlayersSteamID )
					if ( PData == "" ) then
						ply:SetPData( "SPPBuddies", PlayersSteamID .. ";")
					else
						ply:SetPData( "SPPBuddies", PData .. PlayersSteamID .. ";")
					end
				end
			else
				if ( table.HasValue( SPropProtection[ ply:SteamID() ], PlayersSteamID ) ) then
					for k2, v2 in pairs( SPropProtection[ply:SteamID() ] ) do
						if ( v2 == PlayersSteamID ) then
							ChangedFriends = true
							table.remove( SPropProtection[ ply:SteamID() ], k2 )
							ply:SetPData( "SPPBuddies", string.gsub( PData, PlayersSteamID .. ";", "" ) )
						end
					end
				end
			end
		end

		if ( ChangedFriends ) then
			local Table = {}
			for k, v in pairs( SPropProtection[ ply:SteamID() ] ) do
				for k2, v2 in pairs( player.GetAll() ) do
					if ( v == v2:SteamID() ) then
						table.insert( Table, v2 )
					end
				end
			end
			gamemode.Call( "CPPIFriendsChanged", ply, Table )
		end
	end

	SPropProtection.SyncBuddies( ply )
	SPropProtection.Nofity( ply, "Your buddies have been updated" )
end )

concommand.Add( "spp_clear_buddies", function( ply, cmd, args )
	local PData = ply:GetPData( "SPPBuddies", "" )
	if ( PData != "" ) then
		for k, v in pairs( string.Explode( ";", PData ) ) do
			local v = string.Trim( v )
			if ( v != "" ) then
				ply:ConCommand( "spp_buddy_" .. string.gsub( v, ":", "_" ) .. " 0\n" )
			end
		end
		ply:SetPData( "SPPBuddies", "" )
	end

	for k, v in pairs( SPropProtection[ ply:SteamID() ] ) do
		ply:ConCommand( "spp_buddy_" .. string.gsub( v, ":", "_" ) .. " 0\n" )
	end
	SPropProtection[ ply:SteamID() ] = {}

	SPropProtection.SyncBuddies( ply )
	SPropProtection.Nofity( ply, "Your buddies have been cleared" )
end )
