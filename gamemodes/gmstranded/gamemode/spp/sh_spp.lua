
AddCSLuaFile( "sh_cppi.lua" )
AddCSLuaFile( "sh_spp.lua" )
AddCSLuaFile( "cl_init.lua" )

SPropProtection = SPropProtection or {}
SPropProtection.Version = 2

CPPI = CPPI or {}
CPPI_NOTIMPLEMENTED = 26
CPPI_DEFER = 16

include( "sh_cppi.lua" )

if ( SERVER ) then
	include( "sv_init.lua" )
else
	include( "cl_init.lua" )
end

/* ----------------------------------------------
	Keep these shared, so client can predict
------------------------------------------------ */

function SPropProtection.PhysGravGunPickup( ply, ent )
	if ( !IsValid( ent ) && ent:GetClass() != "worldspawn") then return end
	if ( ent:GetNWString( "Owner" ) == "World" && ply:IsAdmin() && GetConVarNumber( "spp_admin_wp" ) == 1 ) then return true end
	if ( SPropProtection.PlayerCanTouch( ply, ent ) ) then return true end
end
/*hook.Add( "GravGunPunt", "SPropProtection.GravGunPunt", PhysGravGunPickup )
hook.Add( "GravGunPickupAllowed", "SPropProtection.GravGunPickupAllowed", PhysGravGunPickup )
hook.Add( "PhysgunPickup", "SPropProtection.PhysgunPickup", PhysGravGunPickup )
hook.Add( "CanTool", "SPropProtection.CanTool", PhysGravGunPickup )*/

/* ----------------------------------------------
	SPP Console Variables
------------------------------------------------ */

if ( SPPCVars ) then return end -- Auto-Refresh protection

SPPCVars = {}

function CreateSPPCVar( name, def )
	if ( SERVER ) then

		table.insert( SPPCVars, "spp_" .. name )
		CreateConVar( "spp_" .. name, def, FCVAR_ARCHIVE )

		cvars.AddChangeCallback( "spp_" .. name, function( cvar, old, new )

			if ( math.floor( old ) == math.floor( new ) ) then return end
			for id, pl in pairs( player.GetAll() ) do pl:ConCommand( "spp_" .. name .. " " .. math.floor( new ) ) end

		end )

	else

		CreateConVar( "spp_" .. name, def )
		cvars.AddChangeCallback( "spp_" .. name, function( cvar, old, new )

			if ( math.floor( old ) == math.floor( new ) ) then return end
			timer.Destroy( "spp_update" .. name )
			timer.Create("spp_update" .. name, 2, 1, function() RunConsoleCommand( "spp_update", name, math.floor( new ) ) end )

		end )

	end
end

CreateSPPCVar( "enabled", "1" )
CreateSPPCVar( "admin", "0" )
CreateSPPCVar( "admin_wp", "0" )
CreateSPPCVar( "use", "1" )
CreateSPPCVar( "entdmg", "1" )
CreateSPPCVar( "del_disconnected", "1" )
CreateSPPCVar( "del_adminprops", "1" )
CreateSPPCVar( "del_delay", "120" )

if ( CLIENT ) then return end

concommand.Add( "spp_update", function( ply, cmd, args )

	if ( !ply:IsAdmin() ) then return end

	local cmd = args[ 1 ]
	local val = args[ 2 ]

	if ( math.floor( GetConVarNumber( "spp_" .. cmd ) ) == math.floor( val ) ) then return end

	RunConsoleCommand( "spp_" .. cmd, math.floor( val ) )

end )

hook.Add( "PlayerInitialSpawn", "spp.sync_cvars", function( ply )
	for id, cvar in pairs( SPPCVars ) do ply:ConCommand( cvar .. " " .. math.floor( GetConVarNumber( cvar ) ) ) end
end )
