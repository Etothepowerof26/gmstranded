
function GM:PlayerSay( ply, text, teamonly )
	local args = string.Explode( " ", text )
	if ( args == nil ) then args = {} end

	if ( teamonly ) then
		if ( GMS.RunChatCmd( ply, args ) != "" ) then
			for k, v in pairs( player.GetAll() ) do
				if ( IsValid( v ) && v:IsPlayer() && v:Team() == ply:Team() ) then
					v:PrintMessage( 3, "[TRIBE] " .. ply:Nick() .. ": " .. text )
				end
			end
		end
		return ""
	else
		return GMS.RunChatCmd( ply, args ) or text
	end
end

GMS.ChatCommands = {}
function GMS.RegisterChatCmd( tbl )
	GMS.ChatCommands[ tbl.Command ] = tbl
end

function GMS.RunChatCmd( ply, arg )
	if ( #arg > 0 && ( string.Left( arg[ 1 ], 1 ) == "/" or string.Left( arg[1], 1 ) == "!" ) ) then
		local cmd = string.sub( arg[ 1 ], 2, string.len( arg[ 1 ] ) )
		table.remove( arg, 1 )

		if ( ply:GetNWBool( "AFK" ) && cmd != "afk" ) then
			ply:SendMessage( "You can't do this while afk.", 3, Color( 200, 0, 0, 255 ) )
		elseif ( ply:GetNWBool( "Sleeping" ) && cmd != "wakeup" ) then
			ply:SendMessage( "You can't do this while sleeping.", 3, Color( 200, 0, 0, 255 ) )
		end

		if ( GMS.ChatCommands[ cmd ] != nil ) then
			GMS.ChatCommands[cmd]:Run( ply, arg )
			return ""
		end
	end
end

----------------------------------------------------------------------------------------------------

local CHATCMD = {}

CHATCMD.Command = "commands"
CHATCMD.Desc = "Prints all possible commands"

function CHATCMD:Run( ply )
	ply:PrintMessage( HUD_PRINTCONSOLE, "\n\n\nGarry's Mod Stranded chat commands:\n\n" )
	for _, v in pairs( GMS.ChatCommands ) do
		if ( v.Command != nil ) then
			local desc = v.Desc or "No description given."
			local syntax = v.Syntax or ""
			if ( syntax != "" ) then syntax = syntax .. " " end
			ply:PrintMessage( HUD_PRINTCONSOLE, v.Command .. " " .. syntax .. "- " .. v.Desc )
		end
	end
	ply:PrintMessage( HUD_PRINTCONSOLE, "\n<arg> - Required argument, [arg] - Optional argument\n" )
	ply:PrintMessage( HUD_PRINTCONSOLE, "All commands start with '!' or '/'." )
	ply:PrintMessage( HUD_PRINTCONSOLE, "For item names with spaces use '_', for example !drop Water_Bottles 5\n\n" )
	ply:PrintMessage( HUD_PRINTTALK, "All commands were printed into console (~)" )
end

GMS.RegisterChatCmd( CHATCMD )

----------------------------------------------------------------------------------------------------

local CHATCMD = {}

CHATCMD.Command = "help"
CHATCMD.Desc = "Open help menu"
CHATCMD.CCName = "gms_help"

function CHATCMD:Run( ply, args )
	ply:ConCommand( self.CCName )
end 

GMS.RegisterChatCmd( CHATCMD )

----------------------------------------------------------------------------------------------------

local CHATCMD = {}

CHATCMD.Command = "drop"
CHATCMD.Desc = "No amount will drop all"
CHATCMD.Syntax = "<Resource Type> [Amount]"
CHATCMD.CCName = "gms_dropresources"

function CHATCMD:Run( ply, args )
	GAMEMODE.DropResource( ply, self.CCName, args )
end 

GMS.RegisterChatCmd( CHATCMD )

----------------------------------------------------------------------------------------------------

local CHATCMD = {}

CHATCMD.Command = "sleep"
CHATCMD.Desc = "Goto sleep"
CHATCMD.CCName = "gms_sleep"

function CHATCMD:Run( ply )
	ply:Sleep()
end

GMS.RegisterChatCmd( CHATCMD )

----------------------------------------------------------------------------------------------------

local CHATCMD = {}

CHATCMD.Command = "stuck"
CHATCMD.Desc = "In case you are stuck"
CHATCMD.CCName = "gms_stuck"

function CHATCMD:Run( ply )
	GAMEMODE.PlayerStuck( ply )
end

GMS.RegisterChatCmd( CHATCMD )

----------------------------------------------------------------------------------------------------

local CHATCMD = {}

CHATCMD.Command = "adrop"
CHATCMD.Desc = "Drops a specified of resources out of nowhere. Admin only."
CHATCMD.Syntax = "<Resource Type> <Amount>"
CHATCMD.CCName = "gms_adropresources"

function CHATCMD:Run( ply, args )
	GAMEMODE.ADropResource( ply, self.CCName, args )
end

GMS.RegisterChatCmd( CHATCMD )

----------------------------------------------------------------------------------------------------

local CHATCMD = {}

CHATCMD.Command = "wakeup"
CHATCMD.Desc = "Wakeup from sleep."
CHATCMD.CCName = "gms_wakeup"

function CHATCMD:Run( ply )
	ply:Wakeup()
end

GMS.RegisterChatCmd( CHATCMD )

----------------------------------------------------------------------------------------------------

local CHATCMD = {}
CHATCMD.Command = "campfire"
CHATCMD.Desc = "Make a camp fire."
CHATCMD.CCName = "gms_makefire"

function CHATCMD:Run( ply )
	GAMEMODE.MakeCampfire( ply )
end
GMS.RegisterChatCmd( CHATCMD )

----------------------------------------------------------------------------------------------------

local CHATCMD = {}

CHATCMD.Command = "drink"
CHATCMD.Desc = "Drink a water bottle."
CHATCMD.CCName = "gms_drinkbottle"

function CHATCMD:Run( ply )
	GAMEMODE.DrinkFromBottle( ply )
end

GMS.RegisterChatCmd( CHATCMD )

----------------------------------------------------------------------------------------------------

local CHATCMD = {}

CHATCMD.Command = "melon"
CHATCMD.Desc = "Plant a watermelon."
CHATCMD.CCName = "gms_plantmelon"

function CHATCMD:Run( ply )
	GAMEMODE.PlantMelon( ply )
end

GMS.RegisterChatCmd( CHATCMD )

----------------------------------------------------------------------------------------------------

local CHATCMD = {}

CHATCMD.Command = "banana"
CHATCMD.Desc = "Plant a banana."
CHATCMD.CCName = "gms_plantbanana"

function CHATCMD:Run( ply )
	GAMEMODE.PlantBanana( ply )
end

GMS.RegisterChatCmd( CHATCMD )

----------------------------------------------------------------------------------------------------

local CHATCMD = {}

CHATCMD.Command = "orange"
CHATCMD.Desc = "Plant an orange."
CHATCMD.CCName = "gms_plantorange"

function CHATCMD:Run( ply )
	GAMEMODE.PlantOrange( ply )
end

GMS.RegisterChatCmd( CHATCMD )

----------------------------------------------------------------------------------------------------

local CHATCMD = {}

CHATCMD.Command = "grain"
CHATCMD.Desc = "Plant grain."
CHATCMD.CCName = "gms_plantgrain"

function CHATCMD:Run( ply )
	GAMEMODE.PlantGrain( ply )
end

GMS.RegisterChatCmd( CHATCMD )

----------------------------------------------------------------------------------------------------

local CHATCMD = {}

CHATCMD.Command = "berrybush"
CHATCMD.Desc = "Plant berry bush."
CHATCMD.CCName = "gms_plantbush"

function CHATCMD:Run( ply )
	GAMEMODE.PlantBush( ply )
end

GMS.RegisterChatCmd( CHATCMD )

----------------------------------------------------------------------------------------------------

local CHATCMD = {}

CHATCMD.Command = "tree"
CHATCMD.Desc = "Plant a tree."
CHATCMD.CCName = "gms_planttree"

function CHATCMD:Run( ply )
	GAMEMODE.PlantTree( ply )
end

GMS.RegisterChatCmd( CHATCMD )

----------------------------------------------------------------------------------------------------

local CHATCMD = {}

CHATCMD.Command = "dropweapon"
CHATCMD.Desc = "Drop your current weapon."
CHATCMD.CCName = "gms_dropweapon"

function CHATCMD:Run( ply )
	GAMEMODE.DropWeapon( ply )
end

GMS.RegisterChatCmd( CHATCMD )

----------------------------------------------------------------------------------------------------

local CHATCMD = {}

CHATCMD.Command = "take"
CHATCMD.Desc = "Take resources out of Resource Pack/Box."
CHATCMD.Syntax = "[Resource Type] [Amount]"
CHATCMD.CCName = "gms_takeresources"
function CHATCMD:Run( ply, args )
	GAMEMODE.TakeResource( ply, self.CCName, args )
end

GMS.RegisterChatCmd( CHATCMD )

----------------------------------------------------------------------------------------------------

local CHATCMD = {}

CHATCMD.Command = "medicine"
CHATCMD.Desc = "Take a Medicine."
CHATCMD.CCName = "gms_takemedicine"

function CHATCMD:Run( ply )
	GAMEMODE.TakeAMedicine( ply )
end

GMS.RegisterChatCmd( CHATCMD )

----------------------------------------------------------------------------------------------------

local CHATCMD = {}

CHATCMD.Command = "afk"
CHATCMD.Desc = "Go away from keyboard. ( Doesn't reduce your needs )"
CHATCMD.CCName = "gms_afk"

function CHATCMD:Run( ply, args )
	GAMEMODE.AFK( ply, self.CCName, args )
	ply:ConCommand("-menu")
end

GMS.RegisterChatCmd( CHATCMD )

----------------------------------------------------------------------------------------------------

local CHATCMD = {}

CHATCMD.Command = "rn"
CHATCMD.Syntax = "[Player]"
CHATCMD.Desc = "Reset your / someone's needs. Admin Only."

function CHATCMD:Run( ply, args )
	if ( !ply:IsAdmin() ) then return end
	if ( args && #args > 0 ) then
		pl = player.FindByName( args[ 1 ] )
		if ( !pl ) then ply:SendMessage( "Player not found!", 3, Color( 200, 10, 10, 255 ) ) return end
		pl.Hunger = 1000
		pl.Thirst = 1000
		pl.Sleepiness = 1000
		pl:UpdateNeeds()
	else
		ply.Hunger = 1000
		ply.Thirst = 1000
		ply.Sleepiness = 1000
		ply:UpdateNeeds()
	end
end

GMS.RegisterChatCmd( CHATCMD )

----------------------------------------------------------------------------------------------------

local CHATCMD = {}

CHATCMD.Command = "finish"
CHATCMD.Desc = "Finish the structure you are looking at."

function CHATCMD:Run( ply, args )
	if ( !ply:IsAdmin() || ply:GetEyeTrace().Entity:GetClass() != "gms_buildsite" ) then return end
	ply:GetEyeTrace().Entity:Finish()
end

GMS.RegisterChatCmd( CHATCMD )

----------------------------------------------------------------------------------------------------

local CHATCMD = {}

CHATCMD.Command = "r"
CHATCMD.Desc = "Give resources to yourself / someone"
CHATCMD.Syntax = "[player] <Resource> <Amount>"

function CHATCMD:Run(ply, arg)
	if ( !ply:IsAdmin() || !arg ) then return end
	if ( #arg > 2 ) then
		local pl = player.FindByName( arg[ 1 ] )
		if ( !pl ) then ply:SendMessage( "Player not found!", 3, Color( 200, 10, 10, 255 ) ) return end
		pl:IncResource( arg[ 2 ], tonumber( arg[ 3 ] ) )
	elseif ( #arg == 2 ) then
		ply:IncResource( arg[ 1 ], tonumber( arg[ 2 ] ) )
	end
end

GMS.RegisterChatCmd( CHATCMD )

----------------------------------------------------------------------------------------------------

local CHATCMD = {}

CHATCMD.Command = "steal"
CHATCMD.Desc = "Steal a prop."
CHATCMD.CCName = "gms_steal"

function CHATCMD:Run( ply )
	ply.ConCommand( ply, "gms_steal" )
end

GMS.RegisterChatCmd( CHATCMD )

----------------------------------------------------------------------------------------------------

local CHATCMD = {}

CHATCMD.Command = "createtribe"
CHATCMD.Desc = "Opens create tribe menu."
CHATCMD.CCName = "gms_tribemenu"

function CHATCMD:Run( ply, args )
	ply:ConCommand( self.CCName )
end

GMS.RegisterChatCmd( CHATCMD )

----------------------------------------------------------------------------------------------------

local CHATCMD = {}

CHATCMD.Command = "invite"
CHATCMD.Desc = "Invite someone to your tribe"
CHATCMD.Syntax = "<player>"

function CHATCMD:Run( ply, args )
	local him = player.FindByName( args[ 1 ] )
	if ( !him ) then ply:SendMessage( "Player not found!", 3, Color( 200, 10, 10, 255 ) ) return end
	if ( him == ply ) then ply:SendMessage( "Why invite yourself?", 3, Color( 200, 64, 10, 255 ) ) return end
	if ( him.LastInvite && him.LastInvite > CurTime() ) then ply:SendMessage( "Too much invitations to " .. him:Name() .. "! Wait " .. ( CurTime() - him.LastInvite)  .. " seconds.", 3, Color( 200, 10, 10, 255 ) ) return end
	local mahTribe = GAMEMODE.FindTribeByID( ply:Team() )

	him.LastInvite = CurTime() + 30

	if ( !mahTribe ) then ply:SendMessage( "Something went wrong! Report this to admins: " .. ply:Team(), 3, Color( 200, 10, 10, 255 ) ) return end

	ply:SendMessage( "Invitation sent!", 3, Color( 200, 200, 200, 255 ) ) 

	umsg.Start( "gms_invite", him )
		umsg.String( mahTribe.name )
		umsg.String( tostring( mahTribe.password ) )
	umsg.End()
end

GMS.RegisterChatCmd( CHATCMD )

----------------------------------------------------------------------------------------------------

local CHATCMD = {}

CHATCMD.Command = "join"
CHATCMD.Desc = "Opens join tribe menu."
CHATCMD.CCName = "gms_tribes"

function CHATCMD:Run( ply, args )
	ply:ConCommand( self.CCName )
end

GMS.RegisterChatCmd( CHATCMD )

----------------------------------------------------------------------------------------------------

local CHATCMD = {}

CHATCMD.Command = "leave"
CHATCMD.Desc = "Leave a tribe."
CHATCMD.CCName = "gms_leave"

function CHATCMD:Run( ply, args )
	GAMEMODE.LeaveTribeCmd( ply, self.CCName, args )
end

GMS.RegisterChatCmd( CHATCMD )
