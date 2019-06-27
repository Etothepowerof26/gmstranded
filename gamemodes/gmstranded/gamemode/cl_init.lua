
include( "shared.lua" )

include( "cl_qmenu.lua" )
include( "cl_scoreboard.lua" )
include( "cl_panels.lua" )
include( "cl_hud.lua" )

-- HUD Theme
StrandedColorTheme = Color( 0, 0, 0, 240 )
StrandedBorderTheme = Color( 0, 0, 0, 180 )

StrandedBackgroundColor = Color( 0, 0, 0, 180 )
StrandedForegroundColor = Color( 0, 128, 176, 220 )
StrandedBorderColor = Color( 0, 0, 0, 150 )
StrandedTextColor = color_white
StrandedTextShadowColor = Color( 100, 100, 100, 140 )

StrandedHealthColor = Color( 176, 0, 0, 240 )
StrandedHungerColor = Color( 0, 176, 0, 240 )
StrandedThirstColor = Color( 0, 0, 176, 240 )
StrandedFatigueColor = Color( 176, 0, 176, 240 )
StrandedOxygenColor = Color( 0, 200, 200, 220 )
StrandedPowerColor = Color( 200, 200, 0, 220 )

-- Clientside player variables
Tribes = Tribes or {}
Skills = Skills or {}
Resources = Resources or {}
Experience = Experience or {}
FeatureUnlocks = FeatureUnlocks or {}
MaxResources = MaxResources or 25
CampFires = CampFires or {}

Sleepiness = Sleepiness or 1000
Hunger = Hunger or 1000
Thirst = Thirst or 1000
Oxygen = Oxygen or 1000
Power = Power or 50

/* Language */
language.Add( "gms_stonefurnace", "Stone Furnace" )
language.Add( "gms_stoneworkbench", "Stone Workbench" )
language.Add( "gms_copperfurnace", "Copper Furnace" )
language.Add( "gms_copperworkbench", "Copper Workbench" )
language.Add( "gms_ironfurnace", "Iron Furnace" )
language.Add( "gms_ironworkbench", "Iron Workbench" )
language.Add( "gms_techworkbench", "Tech Workbench" )
language.Add( "gms_factory", "Factory" )
language.Add( "gms_fridge", "Fridge" )
language.Add( "gms_gunlab", "Gun Lab" )
language.Add( "gms_gunchunks", "Gun Chunks" )
language.Add( "gms_resourcepack", "Resource Pack" )
language.Add( "gms_grindingstone", "Grinding Stone" )
language.Add( "gms_waterfountain", "Water Fountain" )
language.Add( "gms_stove", "Stove" )

/* The chat hints */
HintsRus = {
	"Держите Ваши ресурсы в ресурс паке, чтобы их не украли ночью.",
	"А знаете ли Вы, что ресурсы в меню ресурсов ( F2 ) нажимаемы мышью?",
	"Храните Вашу еду в холодильнике, чтобы она не портилась.",
	"Чтобы племя могло использовать вещи друг друга, это племя должно иметь пароль.",
	"Чтобы использовать фонарь, Вам нужно его сделать.",
	"Чем больше у Вас батареек, тем больше у Вас энергии для фонаря.", 
	"Шанс поймать что-то без наживки ( Baits ) в 4 раза ниже, чем с наживкой.",
	"Чтобы добыть железо ( Iron ) или медь ( Copper ) вам нужна кирка.",
	"Проблемы? Прочтите !help для получения базовой информации об этом игровом режиме.",
	"Чтобы пригласить игрока в племя, напишите !invite <имя игрока>"
}

HintsEng = {
	"Store your resources in resource pack, so they wont get stolen at night.",
	"Did you know that resources in Resources menu ( F2 ) are clickable?",
	"Keep your food in fridge, so it does not spoil.",
	"In order to share items within a tribe, the tribe must have a password.",
	"In order to use flashlight, you need to craft it.",
	"The more batteries you have, the more flashlight power you have.",
	"Chance to catch something without Baits is 4 times lower, then with Baits.",
	"In order to get Iron or Copper you need a pickaxe.",
	"Having trouble? Read !help to learn the basics of this gamemode.",
	"In order to invite a player into a tribe, type !invite <player name>"
}

timer.Create( "Client.HINTS", 360, 0, function()
	if ( GetConVarString( "gmod_language" ) == "ru" ) then
		chat.AddText( Color( 50, 255, 50 ), "[HINT] ", Color( 255, 255, 255 ), HintsRus[ math.random( 1, #HintsRus ) ] )
	else
		chat.AddText( Color( 50, 255, 50 ), "[HINT] ", Color( 255, 255, 255 ), HintsEng[ math.random( 1, #HintsEng ) ] )
	end
end )

function GM.FindTribeByID( Tid )
	for id, tabl in pairs( Tribes ) do
		if ( tabl.id == Tid ) then return tabl end
	end
	return false
end

concommand.Add( "gms_resetcharacter_verify", function( ply, cmd, args )
	Derma_StringRequest( "Character Reset", "WARNING! This will reset all your skills and resources back to where you started.\nIf you are sure you want to do this, type 'I agree' into box below:", "", function( text )
		RunConsoleCommand( "gms_resetcharacter", text )
	end )
end )

/* Resource pack GUI */

GM.ResourcePackFrame = nil

concommand.Add( "gms_openrespackmenu", function( ply, cmd, args )
	local resPack = ply:GetEyeTrace().Entity

	if ( !IsValid( resPack ) ) then return end

	local frame = vgui.Create( "DFrame" )
	frame:SetSize( ScrW() / 1.5, ScrH() / 2 )
	frame:MakePopup()
	frame:Center()
	function frame:Update()
		// Left side
		for id, item in pairs( self.Resources:GetItems() ) do item:Remove() end
		for res, num in SortedPairs( self.ResourcePack.Resources or {} ) do
			local reso = vgui.Create( "gms_resourceLine" )
			if ( self.ResourcePack:GetClass() == "gms_fridge" ) then
				reso:SetRes( res, num, false )
			else
				reso:SetRes( res, num, true )
			end
			self.Resources:AddItem( reso )
		end

		// Right side
		if ( self.ResourcePack:GetClass() == "gms_fridge" || !IsValid( self.Inventory ) ) then return end
		timer.Simple( 0, function()
			if ( !IsValid( self.Inventory ) ) then return end
			for id, item in pairs( self.Inventory:GetItems() ) do item:Remove() end
			for res, num in SortedPairs( Resources or {} ) do
				if ( num <= 0 ) then continue end
				local reso = vgui.Create( "gms_resourceLineStore" )
				reso:SetRes( res, num )
				self.Inventory:AddItem( reso )
			end
		end )
	end

	local panelList = vgui.Create( "DPanelList", frame )
	panelList:SetPos( 5, 30 )
	panelList:SetSpacing( 5 )
	panelList:SetPadding( 5 )
	panelList:EnableHorizontal( false )
	panelList:EnableVerticalScrollbar( true )
	function panelList:Paint( w, h )
		draw.RoundedBox( 2, 0, 0, w, h, Color( 80, 80, 80 ) )
	end

	if ( resPack:GetClass() == "gms_fridge" ) then
		frame:SetSize( ScrW() / 2, ScrH() / 2 )
		frame:SetTitle( "Fridge" )
		frame:Center()
		panelList:SetSize( frame:GetWide() - 10, frame:GetTall() - 35 )
	else
		frame:SetTitle( "Resource pack" )
		panelList:SetSize( frame:GetWide() - 15 - ScrW() / 4, frame:GetTall() - 35 )
	end

	frame.Resources = panelList
	frame.ResourcePack = resPack

	if ( resPack:GetClass() != "gms_fridge" ) then
		local panelListInv = vgui.Create( "DPanelList", frame )
		panelListInv:SetPos( frame:GetWide() - 10 - ScrW() / 4 + 5, 30 )
		panelListInv:SetSize( ScrW() / 4, frame:GetTall() - 35 )
		panelListInv:SetSpacing( 5 )
		panelListInv:SetPadding( 5 )
		panelListInv:EnableHorizontal( false )
		panelListInv:EnableVerticalScrollbar( true )
		function panelListInv:Paint( w, h )
			draw.RoundedBox( 2, 0, 0, w, h, Color( 80, 128, 80 ) )
		end
		frame.Inventory = panelListInv
	end

	GAMEMODE.ResourcePackFrame = frame
	frame:Update()
end )

hook.Add( "Think", "CampFireLight", function()
	for id, e in pairs( ents.FindByClass("prop_p*") ) do
		if ( !e:IsOnFire() ) then continue end
		local campfire = DynamicLight( e:EntIndex() )
		if ( campfire ) then
			campfire.Pos = e:GetPos()
			campfire.r = math.random( 224, 255 )
			campfire.g = math.random( 128, 150 )
			campfire.b = 0
			campfire.Brightness = 2.4

			if ( !e.campfireSize ) then
				local min, max = e:OBBMins(), e:OBBMaxs()
				local vol = math.abs( max.x - min.x ) * math.abs( max.y - min.y ) * math.abs( max.z - min.z )
				e.campfireSize = vol / 5
			end

			campfire.Size = e.campfireSize
			campfire.Decay = 0
			campfire.DieTime = CurTime() + 0.25
		end
	end
end )

/* ----------------------------------------------------------------------------------------------------
	Hooks
---------------------------------------------------------------------------------------------------- */

function GM:Initialize()
	if ( !IsValid( self.SkillsHud ) ) then self.SkillsHud = vgui.Create( "gms_SkillsHud" ) end
	if ( !IsValid( self.ResourcesHud ) ) then self.ResourcesHud = vgui.Create( "gms_ResourcesHud" ) end
	if ( !IsValid( self.CommandsHud ) ) then self.CommandsHud = vgui.Create( "gms_CommandsHud" ) end
	if ( !IsValid( self.LoadingBar ) ) then self.LoadingBar = vgui.Create( "gms_LoadingBar" ) self.LoadingBar:SetVisible( false ) end
	if ( !IsValid( self.SavingBar ) ) then self.SavingBar = vgui.Create( "gms_SavingBar" ) self.SavingBar:SetVisible( false ) end
end

/* ----------------------------------------------------------------------------------------------------
	Skills, Resources & Experience
---------------------------------------------------------------------------------------------------- */

usermessage.Hook( "gms_MakeProcessBar", function( um )
	CurrentProcess = um:ReadString()
	ProcessStart = CurTime()
	ProcessCompleteTime = um:ReadShort()
	ProcessCancelAble = um:ReadBool()
end )

usermessage.Hook( "gms_ResetPlayer", function()
	Tribes = {}
	Skills = {}
	Skills[ "Survival" ] = 0
	Resources = {}
	Experience = {}
	Experience[ "Survival" ] = 0
	FeatureUnlocks = {}
	MaxResources = 25

	GAMEMODE.ResourcesHud:RefreshResources()
	GAMEMODE.SkillsHud:RefreshSkills()
end )

usermessage.Hook( "gms_StopProcessBar", function()
	ProcessCompleteTime = false
end )

usermessage.Hook( "gms_MakeLoadingBar", function( um )
	GAMEMODE.LoadingBar:Show( um:ReadString() )
end )

usermessage.Hook( "gms_StopLoadingBar", function( um )
	GAMEMODE.LoadingBar:Hide()
end )

usermessage.Hook( "gms_MakeSavingBar", function( um )
	GAMEMODE.SavingBar:Show( um:ReadString() )
end )

usermessage.Hook( "gms_StopSavingBar", function( um )
	GAMEMODE.SavingBar:Hide()
end )

usermessage.Hook( "gms_SetSkill", function( um )
	Skills[ um:ReadString() ] = um:ReadShort()
	MaxResources = 25 + ( GetSkill( "Survival" ) * 5 )
	GAMEMODE.SkillsHud:RefreshSkills()
end )

usermessage.Hook( "gms_SetXP", function( um )
	Experience[ um:ReadString() ] = um:ReadShort()
end )

usermessage.Hook( "gms_SetResource", function( um )
	local res = um:ReadString()
	local amount = um:ReadShort()

	Resources[res] = amount
	GAMEMODE.ResourcesHud:RefreshResources()
end )

usermessage.Hook( "gms_SetMaxResources", function( um )
	MaxResources = um:ReadShort()
	GAMEMODE.ResourcesHud:RefreshResources()
end )

usermessage.Hook( "gms_OpenCombiMenu", function( um )
	if ( GAMEMODE.CombiMenu ) then GAMEMODE.CombiMenu:Remove() end
	GAMEMODE.CombiMenu = vgui.Create( "GMS_CombinationWindow" )
	GAMEMODE.CombiMenu:SetTable( um:ReadString() )
end )

function GM:PlayerBindPress( ply, bind, pressed )
	if ( string.find( bind, "gm_showhelp" ) ) then GAMEMODE.SkillsHud:ToggleExtend() end
	if ( string.find( bind, "gm_showteam" ) ) then GAMEMODE.ResourcesHud:ToggleExtend() end
end

/* ----------------------------------------------------------------------------------------------------
	Functions
---------------------------------------------------------------------------------------------------- */

function GetSkill( skill )
	return Skills[ skill ] or 0
end

function GetXP( skill )
	return Experience[ skill ] or 0
end

function GetResource( res )
	return Resources[ res ] or 0
end

function TraceFromEyes( dist )
	local trace = {}
	trace.start = self:GetShootPos()
	trace.endpos = trace.start + ( self:GetAimVector() * dist )
	trace.filter = self

	return util.TraceLine( trace )
end

/* ----------------------------------------------------------------------------------------------------
	Messages
---------------------------------------------------------------------------------------------------- */

GM.InfoMessages = {}
GM.InfoMessageLine = 0

usermessage.Hook( "gms_sendmessage", function( um )
	local text = um:ReadString()
	local dur = um:ReadShort()
	local col = um:ReadString()
	local str = string.Explode( ",", col )
	local col = Color( tonumber( str[1] ), tonumber( str[2] ), tonumber( str[3] ), tonumber( str[4] ) )

	for k,v in pairs( GAMEMODE.InfoMessages ) do
		v.drawline = v.drawline + 1
	end

	local message = {}
	message.Text = text
	message.Col = col
	message.Tab = 5
	message.drawline = 1

	GAMEMODE.InfoMessages[#GAMEMODE.InfoMessages + 1] = message
	GAMEMODE.InfoMessageLine = GAMEMODE.InfoMessageLine + 1

	timer.Simple( dur, function() GAMEMODE.DropMessage( message ) end )
end )

hook.Add( "HUDPaint", "gms_drawmessages", function()
	for k,msg in pairs( GAMEMODE.InfoMessages ) do
		local txt = msg.Text
		local line = ScrH() / 2 + ( msg.drawline * 20 )
		local tab = msg.Tab
		local col = msg.Col
		draw.SimpleTextOutlined( txt, "ScoreboardText", tab, line, col, 0, 0, 0.5, Color( 100, 100, 100, 150 ) )

		if ( msg.Fading ) then
			msg.Tab = msg.Tab - ( msg.InitTab - msg.Tab - 0.05 )

			if ( msg.Tab > ScrW() + 10 ) then
				GAMEMODE.RemoveMessage( msg )
			end
		end
	end
end )

function GM.DropMessage( msg )
	msg.InitTab = msg.Tab
	msg.Fading = true
end

function GM.RemoveMessage( msg )
	for k, v in pairs( GAMEMODE.InfoMessages ) do
		if ( v == msg ) then
			GAMEMODE.InfoMessages[k] = nil
			GAMEMODE.InfoMessageLine = GAMEMODE.InfoMessageLine - 1
			table.remove( GAMEMODE.InfoMessages, k )
		end
	end
end

/* ----------------------------------------------------------------------------------------------------
	Prop Fading
---------------------------------------------------------------------------------------------------- */

GM.FadingProps = {}

usermessage.Hook( "gms_CreateFadingProp", function( um )
	local mdl = um:ReadString()
	local pos = um:ReadVector()
	local dir = um:ReadVector()
	local col = um:ReadVector()
	local speed = um:ReadShort()

	if ( !mdl or !pos or !dir or !speed ) then return end

	local ent = ents.CreateClientProp( mdl )
	ent:SetPos( pos )
	ent:SetColor( Color( col.x, col.y, col.z) )
	ent:SetAngles( Angle( dir.x, dir.y, dir.z ) )
	ent:Spawn()

	ent.Alpha = 255
	ent.Speed = speed

	table.insert( GAMEMODE.FadingProps, ent )
end )

hook.Add( "Think", "gms_FadeFadingPropsHook", function()
	for k, v in pairs( GAMEMODE.FadingProps ) do
		if ( v.Alpha ) then
			if ( v.Alpha <= 0 ) then
				v:Remove()
				table.remove( GAMEMODE.FadingProps, k )
			else
				v.Alpha = v.Alpha - v.Speed

				v:SetRenderMode( RENDERMODE_TRANSALPHA )
				local oldColor = v:GetColor()
				v:SetColor( Color( oldColor.r, oldColor.g, oldColor.b, math.min( math.max( v.Alpha, 0 ), 255 ) ) )
			end
		end
	end
end )

/* ----------------------------------------------------------------------------------------------------
	Achievement Messages
---------------------------------------------------------------------------------------------------- */

GM.AchievementMessages = {}

usermessage.Hook( "gms_sendachievement", function( um )
	local tbl = {}
	tbl.Text = um:ReadString()
	tbl.Alpha = 255

	table.insert( GAMEMODE.AchievementMessages, tbl )
end )

hook.Add( "HUDPaint", "gms_drawachievementmessages", function()
	for k, msg in pairs( GAMEMODE.AchievementMessages ) do
		msg.Alpha = msg.Alpha - 1
		draw.SimpleTextOutlined( msg.Text, "ScoreboardHead", ScrW() / 2, ScrH() / 2, Color( 255, 255, 255, msg.Alpha ), 1, 1, 0.5, Color( 100, 100, 100, msg.Alpha ) )

		if ( msg.Alpha <= 0 ) then
			table.remove( GAMEMODE.AchievementMessages, k )
		end
	end
end )

/* ----------------------------------------------------------------------------------------------------
	Needs
---------------------------------------------------------------------------------------------------- */

usermessage.Hook( "gms_setneeds", function( um )
	Sleepiness = um:ReadShort()
	Hunger = um:ReadShort()
	Thirst = um:ReadShort()
	Oxygen = um:ReadShort()
	Power = um:ReadShort()
	Time = um:ReadShort()
end )

/* ----------------------------------------------------------------------------------------------------
	Help menu
---------------------------------------------------------------------------------------------------- */

concommand.Add( "gms_help", function()
	if ( !LocalPlayer():GetNWBool( "AFK" ) ) then RunConsoleCommand( "gms_afk" ) end

	local HelpMenu = vgui.Create( "DFrame" )
	HelpMenu:MakePopup()
	HelpMenu:SetSize( ScrW() - 100, ScrH() - 100 )
	HelpMenu:Center()
	HelpMenu:SetTitle( "Garry's Mod Stranded Help" )
	function HelpMenu:OnClose()
		if ( LocalPlayer():GetNWBool( "AFK" ) ) then RunConsoleCommand( "gms_afk" ) end
	end

	HelpMenu.HTML = vgui.Create( "HTML", HelpMenu )
	HelpMenu.HTML:SetSize( HelpMenu:GetWide() - 10, HelpMenu:GetTall() - 30 )
	HelpMenu.HTML:SetPos( 5, 25 )
	HelpMenu.HTML:OpenURL( "http://steamcommunity.com/sharedfiles/filedetails/?id=135129872" )
	//HelpMenu.HTML:SetHTML( file.Read( "help/helpnew.htm", "GAME" ) )
end )

/* ----------------------------------------------------------------------------------------------------
	Sleep
---------------------------------------------------------------------------------------------------- */

local SleepFade = 0
hook.Add( "HUDPaint", "gms_sleepoverlay", function()
	if ( LocalPlayer():GetNWBool( "Sleeping" ) ) then
		SleepFade = math.min( SleepFade + 3, 254 )
	else
		SleepFade = math.max( SleepFade - 6, 0 )
	end

	if ( SleepFade == 0 ) then return end

	surface.SetDrawColor( 0, 0, 0, SleepFade )
	surface.DrawRect( 0, 0, ScrW(), ScrH() )

	draw.SimpleText( "Use the command \"!wakeup\" or press F4 to wake up.", "ScoreboardSub", ScrW() / 2, ScrH() / 1.5, Color( 255, 255, 255, SleepFade ), 1, 1 )
end )

/* ----------------------------------------------------------------------------------------------------
	AFK
---------------------------------------------------------------------------------------------------- */

local AFKFade = 0
hook.Add( "HUDPaint", "gms_afkoverlay", function()
	if ( LocalPlayer():GetNWBool( "AFK" ) ) then
		AFKFade = math.min( AFKFade + 3, 254 )
	else
		AFKFade = math.max( AFKFade - 6, 0 )
	end

	if ( AFKFade == 0 ) then return end

	surface.SetDrawColor( 0, 0, 0, AFKFade )
	surface.DrawRect( 0, 0, ScrW(), ScrH() )

	draw.SimpleText( "Use the command \"!afk\" or press F4 to stop being afk.", "ScoreboardSub", ScrW() / 2, ScrH() / 1.5, Color( 255, 255, 255, AFKFade ), 1, 1 )
end )

/* ----------------------------------------------------------------------------------------------------
	Unlocks
---------------------------------------------------------------------------------------------------- */

usermessage.Hook( "gms_AddUnlock", function( um )
	local UnlockWindow = vgui.Create( "GMS_UnlockWindow" )
	UnlockWindow:SetMouseInputEnabled( true )
	UnlockWindow:SetUnlock( um:ReadString() )
end )

/* ----------------------------------------------------------------------------------------------------
	Tribes
---------------------------------------------------------------------------------------------------- */

concommand.Add( "gms_tribemenu", function()
	if ( !GAMEMODE.TribeMenu ) then
		GAMEMODE.TribeMenu = vgui.Create( "GMS_TribeMenu" )
		GAMEMODE.TribeMenu:SetDeleteOnClose( false )
		GAMEMODE.TribeMenu:SetVisible( false )
	end

	GAMEMODE.TribeMenu:SetVisible( !GAMEMODE.TribeMenu:IsVisible() )
end )

concommand.Add( "gms_tribes", function()
	if ( #Tribes <= 0 ) then chat.AddText( Color( 255, 255, 255 ), "No tribes created so far. Why not create one?" ) return end
	local TribesMenu = vgui.Create( "GMS_TribesList" )
end )

usermessage.Hook( "gms_invite", function( data )
	local tn = data:ReadString()
	local p = data:ReadString()
	Derma_Query( "You are being invited to " .. tn .. ".\nChoose action below.", "Invitation",
		"Join", function() RunConsoleCommand( "gms_join", tn, p ) end,
		"Decline", function() RunConsoleCommand( "say", "I don't want to join " .. tn .. "." ) end
	)
end )

usermessage.Hook( "sendTribe", function( data )

	local id = data:ReadShort()
	local name = data:ReadString()
	local color = data:ReadVector()
	local hazpass = data:ReadBool()

	team.SetUp( id, name, Color( color.r, color.g, color.b ) )

	table.insert( Tribes, { name = name, pass = hazpass, id = id, color = Color( color.r, color.g, color.b ) } )

end )
