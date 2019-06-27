
surface.CreateFont( "DefaultBold", { 
	font = "Tahoma",
	size = 16,
	weight = 1000,
	antialias = true,
	additive = false
} )

surface.CreateFont( "GMSUnlockDescription", { 
	font = "Tahoma",
	size = 14,
	weight = 500,
	antialias = true,
	additive = false
} )

/*---------------------------------------------------------
	Unlock window
---------------------------------------------------------*/

local PANEL = {}

function PANEL:Init()
	self:SetTitle( "You have unlocked a new ability!" )
	self:MakePopup()

	self.Name = "Name"
	self.Description = ""

	self:SetSize( ScrW() / 3, 250 )
	self:Center()

	self.DescWindow = vgui.Create( "DLabel", self )
	self.DescWindow:SetPos( 5, 100 )
	self.DescWindow:SetSize( self:GetWide() - 10, self:GetTall() - 140 )
	self.DescWindow:SetFont( "GMSUnlockDescription" )
	self.DescWindow:SetWrap( true )
	self.DescWindow:SetText( "" )

	self.Okay = vgui.Create( "DButton", self )
	self.Okay:SetSize( self:GetWide() - 10, 30 )
	self.Okay:SetPos( 5, self:GetTall() - 35 )
	self.Okay:SetText( "Okay" )
	self.Okay.DoClick = function() self:Close() end
end

function PANEL:PaintOver( w, h )
	draw.SimpleTextOutlined( self.Name, "ScoreboardHead", self:GetWide() / 2, 60, Color( 10, 200, 10 ), 1, 1, 0.5, Color( 100, 100, 100, 160 ) )
	//draw.SimpleText( self.Description, "GMSUnlockDescription", self:GetWide() / 2, 140, Color( 200, 200, 200 ), 1, 1 )
end

function PANEL:SetUnlock( text )
	local unlock = GMS.FeatureUnlocks[ text ]
	if ( !unlock ) then return end

	self.Name = unlock.Name
	self.Description = unlock.Description
	self.DescWindow:SetText( unlock.Description )
end

vgui.Register( "GMS_UnlockWindow", PANEL, "DFrame" )

/*---------------------------------------------------------
	Tribe Menu
---------------------------------------------------------*/

local PANEL = {}

function PANEL:Init()
	self:SetTitle( "Create-A-Tribe" )
	self:SetSize( 275, 305 )
	self:MakePopup()
	self:Center()

	local tnamelabel = vgui.Create( "DLabel", self )
	tnamelabel:SetPos( 5, 21 )
	tnamelabel:SetText( "Tribe name" )

	local tname = vgui.Create( "DTextEntry", self )
	tname:SetSize( self:GetWide() - 10, 20 )
	tname:SetPos( 5, 40 )

	local tpwlabel = vgui.Create( "DLabel", self )
	tpwlabel:SetPos( 5, 65 )
	tpwlabel:SetText( "Tribe password ( Optional )" )
	tpwlabel:SizeToContents()

	local tpw = vgui.Create( "DTextEntry", self )
	tpw:SetSize( self:GetWide() - 10, 20 )
	tpw:SetPos( 5, 80 )

	local tcollabel = vgui.Create( "DLabel", self )
	tcollabel:SetPos( 5, 105 )
	tcollabel:SetText( "Tribe color" )

	local tcolor = vgui.Create( "DColorMixer", self )
	tcolor:SetSize( self:GetWide() - 15, 150 )
	tcolor:SetPos( 5, 125 )

	local button = vgui.Create( "DButton", self )
	button:SetSize( self:GetWide() - 10, 20 )
	button:SetPos( 5, 280 )
	button:SetText( "Create Tribe!" )
	button.DoClick = function()
		RunConsoleCommand( "gms_createtribe", tname:GetValue(), tcolor:GetColor().r, tcolor:GetColor().g, tcolor:GetColor().b, tpw:GetValue() )
		self:SetVisible( false )
	end
end
vgui.Register( "GMS_TribeMenu", PANEL, "DFrame" )

/*---------------------------------------------------------
	Tribes List
---------------------------------------------------------*/

local PANEL = {}

function PANEL:Init()
	self:SetTitle( "Join-A-Tribe" )
	self:MakePopup()

	local width = ScrW() / 4

	for id, tabl in pairs( Tribes ) do
		surface.SetFont( "DefaultBold" )
		local w = surface.GetTextSize( tabl.name )
		width = math.max( width, w + 16 + 10 + 20 )
	end

	for id, tabl in pairs( Tribes ) do

		local button = vgui.Create( "GMS_TribeButton", self )
		button:SetSize( width - 16, 16 )
		button:SetPos( 8, 10 + id * 21 )
		button:SetInfo( tabl )

	end

	self:SetSize( width, #Tribes * 21 + 35 )
	self:Center()
end

vgui.Register( "GMS_TribesList", PANEL, "DFrame" )

----------------------------------------------------------------------------------------------------

local PANEL = {}

function PANEL:Init()
	self:SetText( "" )
	self.Tribe = {}
end

function PANEL:Paint()

	surface.SetDrawColor( self.Tribe.color )
	surface.DrawRect( 0, 0, self:GetTall(), self:GetTall() )

	surface.SetDrawColor( 0, 0, 0, 200 )
	if ( self.Hovered ) then surface.SetDrawColor( 255, 255, 255, 64 ) end
	surface.DrawRect( self:GetTall(), 0, self:GetWide() - self:GetTall(), self:GetTall() )

	surface.SetFont( "DefaultBold" )
	local w = surface.GetTextSize( self.Tribe.name )
	draw.SimpleText( self.Tribe.name, "DefaultBold", ( self:GetWide() - 16 ) / 2 + 16, 0, color_white , 1 )

end

function PANEL:DoClick()
	if ( self.Tribe.pass ) then
		local name = self.Tribe.name
		Derma_StringRequest( "Please enter password", "Please enter password for the tribe.", "", function( text ) RunConsoleCommand( "gms_join", name, text ) end )
	else
		RunConsoleCommand( "gms_join", self.Tribe.name )
	end
	self:GetParent():Close()
end

function PANEL:SetInfo( tbl )
	self.Tribe = tbl
end

vgui.Register( "GMS_TribeButton", PANEL, "DButton" )

/*---------------------------------------------------------
	Skills panel
---------------------------------------------------------*/

local PANEL = {}

function PANEL:Init()
	self:SetPos( 1, 0 )
	self:SetSize( ScrW() / 6, 34 )

	self:SetVisible( true )

	self.Extended = false
	self.SkillLabels = {}

	self:RefreshSkills()
end

function PANEL:Paint()

	surface.SetDrawColor( StrandedBackgroundColor )
	surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )

	surface.SetDrawColor( StrandedBorderColor )
	surface.DrawLine( self:GetWide() - 1, 0, self:GetWide() - 1, self:GetTall() ) -- Nice line instead of messy outlined rect
	surface.DrawLine( 0, self:GetTall() - 1, self:GetWide(), self:GetTall() - 1 )
	surface.DrawLine( 0, 0, 0, self:GetTall() )
	if ( self.Extended ) then 
		surface.DrawLine( 0, 33, self:GetWide(), 33 )
	end

	draw.SimpleText( "Skills ( F1 )", "ScoreboardSub", self:GetWide() / 2, 17, Color( 255, 255, 255, 255 ), 1, 1 )
	return true

end

function PANEL:RefreshSkills()
	for k, v in pairs( self.SkillLabels ) do v:Remove() end

	self.SkillLabels = {}
	self.Line = 39

	for k, v in SortedPairs( Skills ) do
		local lbl = vgui.Create( "gms_SkillPanel", self )
		lbl:SetPos( 0, self.Line )
		lbl:SetSize( self:GetWide(), 16 )
		local val = string.gsub( k, "_", " " )
		lbl:SetSkill( val )

		self.Line = self.Line + lbl:GetTall() + 5
		table.insert( self.SkillLabels, lbl )
		if ( !self.Extended ) then lbl:SetVisible( false ) end
	end

	if ( self.Extended ) then 
		self:SetSize( ScrW() / 6, 40 + ( table.Count( self.SkillLabels ) * 21 ) ) 
	end
end

function PANEL:ToggleExtend()
	if ( !self.Extended ) then
		self:SetSize( ScrW() / 6, 40 + ( table.Count( self.SkillLabels ) * 21 ) )
		self.Extended = true

		for k, v in pairs( self.SkillLabels ) do v:SetVisible( true ) end
	else
		self:SetSize( ScrW() / 6, 34 )
		self.Extended = false

		for k, v in pairs( self.SkillLabels ) do v:SetVisible( false ) end
	end
end

function PANEL:OnMousePressed( mc )
	if ( mc == 107 ) then
		self:ToggleExtend()
	end
end

vgui.Register( "gms_SkillsHud", PANEL, "Panel" )

/*---------------------------------------------------------
	Skill Sub-Panel
---------------------------------------------------------*/

local PANEL = {}

function PANEL:Init()
end

function PANEL:Paint()
	surface.SetDrawColor( 0, 0, 0, 178 ) -- XP bar background
	surface.DrawRect( 5, 0, self:GetWide() - 10, self:GetTall() )

	local XP = math.floor( Experience[ self.Skill ] / 100 * ( self:GetWide() - 10 ) )
	surface.SetDrawColor( 0, 128, 0, 220 ) -- XP bar
	if ( self.TxtSkill == "Survival" ) then
		surface.SetDrawColor( 0, 128, 176, 220 ) -- XP bar
	end
	surface.DrawRect( 5, 0, XP, self:GetTall() )

	draw.SimpleText( self.TxtSkill .. ": " .. Skills[ self.Skill ] .. " ( " .. Experience[ self.Skill ] .. " / 100 )", "DefaultBold", self:GetWide() / 2, self:GetTall() / 2 - 1, Color( 255, 255, 255, 255 ), 1, 1 )
	return true
end

function PANEL:SetSkill( str )
	self.TxtSkill = str
	self.Skill = string.gsub( str, " ", "_" )
end

vgui.Register( "gms_SkillPanel", PANEL, "Panel" )

/*---------------------------------------------------------
  Resource panel
---------------------------------------------------------*/

local PANEL = {}

function PANEL:Init()

	self:SetPos( ScrW() / 6 + 2, 0 )
	self:SetSize( ScrW() / 6, 34 )
	self:SetVisible( true )
	self.Extended = false
	self.ResourceLabels = {}

	self:RefreshResources()

end

function PANEL:Paint()

	surface.SetDrawColor( StrandedBackgroundColor )
	surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )

	surface.SetDrawColor( StrandedBorderColor )
	surface.DrawLine( 0, 0, 0, self:GetTall() )
	surface.DrawLine( self:GetWide() - 1, 0, self:GetWide() - 1, self:GetTall() )
	surface.DrawLine( 0, self:GetTall() - 1, self:GetWide(), self:GetTall() - 1 )
	if ( self.Extended ) then
		surface.DrawLine( 0, 33, self:GetWide(), 33 )
	end

	draw.SimpleText( "Resources ( F2 )", "ScoreboardSub", self:GetWide() / 2, 17, StrandedTextColor, 1, 1 )
	return true

end

function PANEL:RefreshResources()
	if ( IsValid( GAMEMODE.ResourcePackFrame ) ) then GAMEMODE.ResourcePackFrame:Update() end
	for k, v in pairs( self.ResourceLabels ) do v:Remove() end

	self.ResourceLabels = {}
	self.Line = 39
	self.Resourcez = 0

	for k, v in SortedPairs( Resources ) do
		if ( v > 0 ) then
			local lbl = vgui.Create( "gms_ResourcePanel", self )
			lbl:SetPos( 0, self.Line )
			lbl:SetSize( self:GetWide(), 16 )
			lbl:SetResource( k )
			self.Resourcez = self.Resourcez + v

			self.Line = self.Line + lbl:GetTall() + 5
			table.insert( self.ResourceLabels, lbl )
			if ( !self.Extended ) then lbl:SetVisible( false ) end
		end
	end
	
	self.Line = self.Line + 21
	
	local lblT = vgui.Create( "gms_ResourcePanelTotal", self )
	lblT:SetPos( 0, self.Line )
	lblT:SetSize( self:GetWide(), 16 )
	lblT:SetResources( self.Resourcez )

	table.insert( self.ResourceLabels, lblT )
	if ( !self.Extended ) then lblT:SetVisible( false ) end

	if ( self.Extended ) then 
		self:SetSize( ScrW() / 6, 40 + ( ( table.Count( self.ResourceLabels ) + 1 ) * 21 ) ) 
	end
	
	if ( GAMEMODE.CommandsHud ) then GAMEMODE.CommandsHud:SetPos( ScrW() / 6 + 2, self:GetTall() ) end
end

function PANEL:ToggleExtend()
	self:SetExtended( !self.Extended )
end

function PANEL:SetExtended( bool )
	if ( bool ) then
		self:SetSize( ScrW() / 6, 40 + ( ( table.Count( self.ResourceLabels ) + 1 ) * 21 ) )
		self.Extended = true
		for k,v in pairs( self.ResourceLabels ) do
			v:SetVisible( true )
		end
	else
		self:SetSize( ScrW() / 6, 34 )
		self.Extended = false
		for k, v in pairs( self.ResourceLabels ) do
			v:SetVisible( false )
		end
	end
	if ( GAMEMODE.CommandsHud ) then GAMEMODE.CommandsHud:SetPos( ScrW() / 6 + 2, self:GetTall() ) end
end

function PANEL:OnMousePressed( mc )
	if ( mc == 107 ) then self:ToggleExtend() end
end
vgui.Register( "gms_ResourcesHud", PANEL, "Panel" )

/*---------------------------------------------------------
	Resource Sub-Panel
---------------------------------------------------------*/

local PANEL = {}

PANEL.GroundActions = {}
PANEL.GroundActions[ "Sprouts" ] = { cmd = "gms_planttree", name = "Plant" }
PANEL.GroundActions[ "Banana_Seeds" ] = { cmd = "gms_plantbanana", name = "Plant" }
PANEL.GroundActions[ "Orange_Seeds" ] = { cmd = "gms_plantorange", name = "Plant" }
PANEL.GroundActions[ "Grain_Seeds" ] = { cmd = "gms_plantgrain", name = "Plant" }
PANEL.GroundActions[ "Melon_Seeds" ] = { cmd = "gms_plantmelon", name = "Plant" }
PANEL.GroundActions[ "Berries" ] = { cmd = "gms_plantbush", name = "Plant" }

PANEL.NormalActions = {}
PANEL.NormalActions[ "Berries" ] = { cmd = "gms_EatBerry", name = "Eat" }
PANEL.NormalActions[ "Medicine" ] = { cmd = "gms_TakeMedicine", name = "Take" }
PANEL.NormalActions[ "Water_Bottles" ] = { cmd = "gms_DrinkBottle", name = "Drink" }

function PANEL:Init()
	self:SetText( "" )
end

function PANEL:Paint()
	surface.SetDrawColor( 0, 0, 0, 178 ) -- Resource bar background
	surface.DrawRect( 5, 0, self:GetWide() - 10, self:GetTall() )

	local XP = math.floor( Resources[ self.Resource ] / MaxResources * ( self:GetWide() - 10 ) )
	surface.SetDrawColor( 0, 128, 0, 200 ) -- Resource bar
	surface.DrawRect( 5, 0, XP, self:GetTall() )

	if ( self.Hovered ) then
		surface.SetDrawColor( 255, 255, 255, 64 ) -- Resource bar background
		surface.DrawRect( 5, 0, self:GetWide() - 10, self:GetTall() )
	end

	draw.SimpleText( self.TxtResource .. ": " .. Resources[ self.Resource ], "DefaultBold", self:GetWide() / 2, self:GetTall() / 2 - 1, Color( 255, 255, 255, 255 ), 1, 1 )
	return true
end

function PANEL:DoRightClick()
	local menu = DermaMenu()

	if ( self.GroundActions[ self.Resource ] ) then
		menu:AddOption( self.GroundActions[ self.Resource ].name, function()
			if ( self.GroundActions ) then
				RunConsoleCommand( self.GroundActions[ self.Resource ].cmd )
			end
		end )
	end

	if ( self.NormalActions[ self.Resource ] ) then
		menu:AddOption( self.NormalActions[ self.Resource ].name, function()
			if ( self.NormalActions ) then
				RunConsoleCommand( self.NormalActions[ self.Resource ].cmd )
			end
		end )
	end

	menu:AddSpacer()

	menu:AddOption( "Drop x1", function() RunConsoleCommand( "gms_DropResources", self.Resource, " 1" ) end )
	menu:AddOption( "Drop x10", function() RunConsoleCommand( "gms_DropResources", self.Resource, " 10" ) end )
	menu:AddOption( "Drop All", function() RunConsoleCommand( "gms_DropResources", self.Resource ) end )
	menu:AddOption( "Cancel", function() end )
	menu:Open()
end

function PANEL:DoClick()
	local tr = util.TraceLine( {
		start = LocalPlayer():GetShootPos(),
		endpos = LocalPlayer():GetShootPos() + LocalPlayer():GetAimVector() * 150,
		filter = LocalPlayer()
	} )

	if ( self.GroundActions && self.GroundActions[ self.Resource ] && tr.HitWorld ) then
		RunConsoleCommand( self.GroundActions[ self.Resource ].cmd )
	elseif ( self.NormalActions && self.NormalActions[ self.Resource ] ) then
		RunConsoleCommand( self.NormalActions[ self.Resource ].cmd )
	end
end

function PANEL:SetResource( str )
	self.TxtResource = string.gsub( str, "_", " " )
	self.Resource = str
end

vgui.Register( "gms_ResourcePanel", PANEL, "DButton" )

/*---------------------------------------------------------
  Resource Total Sub-Panel
---------------------------------------------------------*/
local PANEL = {}

function PANEL:Init()
	self.Res = 0
end

function PANEL:Paint()
	surface.SetDrawColor( 0, 0, 0, 178 ) -- Resource bar background
	surface.DrawRect( 5, 0, self:GetWide() - 10, self:GetTall() )

	local XP = math.floor( self.Res / MaxResources * ( self:GetWide() - 10 ) )
	surface.SetDrawColor( 0, 128, 176, 220 ) -- Resource bar
	surface.DrawRect( 5, 0, XP, self:GetTall() )

	draw.SimpleText( "Total: " .. self.Res .. " / " .. MaxResources, "DefaultBold", self:GetWide() / 2, self:GetTall() / 2 - 1, Color( 255, 255, 255, 255 ), 1, 1 )
	return true
end

function PANEL:SetResources( num )
	self.Res = num
end

vgui.Register( "gms_ResourcePanelTotal", PANEL, "Panel" )

/*---------------------------------------------------------
	Command panel
---------------------------------------------------------*/

local PANEL = {}

function PANEL:Init()

	self:SetPos( ScrW() / 6 + 2, 33 )
	self:SetSize( ScrW() / 6, 34 )
	self:SetVisible( false )
	self.Extended = true
	self.CommandLabels = {}

	self:RefreshCommands()

end

function PANEL:Paint()

	surface.SetDrawColor( StrandedBackgroundColor )
	surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )

	surface.SetDrawColor( StrandedBorderColor )

	surface.DrawLine( self:GetWide() - 1, 0, self:GetWide() - 1, self:GetTall() )
	surface.DrawLine( 0, 0, 0, self:GetTall() )
	surface.DrawLine( 0, self:GetTall() - 1, self:GetWide(), self:GetTall() - 1 )
	if ( self.Extended ) then surface.DrawLine( 0, 33, self:GetWide(), 33 ) end

	draw.SimpleText( "Commands", "ScoreboardSub", self:GetWide() / 2, 17, Color( 255, 255, 255, 255 ), 1, 1 )
	return true

end

function PANEL:CreateButton( x, y, w, h, cmd, txt, clr )
	local line = vgui.Create( "gms_CommandPanel", self )
	line:SetPos( x, y )
	line:SetSize( w, h )
	line:SetCommand( cmd, txt, clr )

	if ( !self.Extended ) then line:SetVisible( false ) end
	table.insert( self.CommandLabels, line )

	return line
end

function PANEL:RefreshCommands()
	for k, v in pairs( self.CommandLabels ) do v:Remove() end

	self.CommandLabels = {}
	self.Line = 39
	self.Lines = 7

	local halfsize = self:GetWide() / 2
	local threesize = self:GetWide() / 4

	local line1 = self:CreateButton( 0, self.Line, halfsize, 16, "gms_sleep", "Sleep", Color( 0, 128, 255, 176 ) )
	local line1b = self:CreateButton( halfsize, self.Line, halfsize, 16, "gms_wakeup", "Wake up", Color( 0, 128, 255, 176 ) )

	self.Line = self.Line + line1:GetTall() + 5

	local line2 = self:CreateButton( 0, self.Line, halfsize, 16, "gms_combinations", "Combinations", Color( 200, 200, 0, 176 ) )
	local line2b = self:CreateButton( halfsize, self.Line, halfsize, 16, "gms_structures", "Structures", Color( 200, 200, 0, 176 ) )

	self.Line = self.Line + line2:GetTall() + 5

	local line3 = self:CreateButton( 0, self.Line, halfsize, 16, "gms_dropweapon", "Drop: Weapon", Color( 255, 0, 0, 176 ) )
	local line3b = self:CreateButton( halfsize, self.Line, halfsize, 16, "gms_dropall", "All resources", Color( 255, 0, 0, 176 ) )

	self.Line = self.Line + line3:GetTall() + 5

	local line4 = self:CreateButton( 0, self.Line, halfsize, 16, "gms_salvage", "Prop: Salvage",  Color( 200, 0, 0, 176 ) )
	local line4b = self:CreateButton( halfsize, self.Line, halfsize, 16, "gms_steal", "Steal",  Color( 200, 0, 0, 176 ) )

	self.Line = self.Line + line4:GetTall() + 5

	local line5 = self:CreateButton( 0, self.Line, halfsize, 16, "gms_savecharacter", "Save", Color( 0, 200, 0, 176 ) )
	local line5b = self:CreateButton( halfsize, self.Line, halfsize, 16, "gms_afk", "Toggle AFK", Color( 0, 200, 0, 176 ) )

	self.Line = self.Line + line5:GetTall() + 5

	local line6 = self:CreateButton( 0, self.Line, halfsize, 16, "gms_makefire", "Make Campfire", Color( 255, 128, 0, 176 ) )
	local line6b = self:CreateButton( halfsize, self.Line, halfsize, 16, "gms_help", "Help", Color( 255, 128, 0, 176 ) )

	self.Line = self.Line + line6:GetTall() + 5

	local line7a = self:CreateButton( 0, self.Line, halfsize, 16, "gms_tribemenu", "Tribe: Create", Color( 200, 0, 200, 176 ) )
	local line7b = self:CreateButton( halfsize, self.Line, threesize, 16, "gms_tribes", "Join", Color( 200, 0, 200, 176 ) )
	local line7c = self:CreateButton( halfsize + threesize, self.Line, threesize, 16, "gms_leave", "Leave", Color( 200, 0, 200, 176 ) )

	if ( self.Extended ) then 
		self:SetSize( ScrW() / 6, 40 + ( self.Lines * 21 ) ) 
	end
end

function PANEL:ToggleExtend( b )
	//self:SetExtended( !self.Extended, b )
end

function PANEL:SetExtended( bool ,b )
	if ( bool ) then
		self:SetSize( ScrW() / 6, 40 + ( self.Lines * 21 ) )
		self.Extended = true
		self:SetVisible( true )
		for k,v in pairs( self.CommandLabels ) do v:SetVisible( true ) end
	else
		self:SetSize( ScrW() / 6, 34 )
		self.Extended = false
		self:SetVisible( false )
		for k, v in pairs( self.CommandLabels ) do v:SetVisible( false ) end
	end
end

vgui.Register( "gms_CommandsHud", PANEL, "Panel" )

/*---------------------------------------------------------
	Command Sub-Panel
---------------------------------------------------------*/

local PANEL = {}

function PANEL:Init()
	self:SetText( "" )
	self.Cmd = ""
	self.Text = ""
	self.Clr = Color( 0, 128, 0, 178 )
end

function PANEL:Paint()
	surface.SetDrawColor( self.Clr.r, self.Clr.g, self.Clr.b, self.Clr.a ) -- Resource bar background
	surface.DrawRect( 5, 0, self:GetWide() - 10, self:GetTall() )

	local colr = Color( 255, 255, 255, 255 )
	if ( self.Clr.r >= 200 and self.Clr.g >= 200 and self.Clr.b >= 200 ) then colr = Color( 0, 0, 0, 255 ) end

	draw.SimpleText( self.Text, "DefaultBold", self:GetWide() / 2, self:GetTall() / 2 - 1, colr, 1, 1 )

	if ( self.Hovered ) then
		surface.SetDrawColor( 255, 255, 255, 64 )
		surface.DrawRect( 5, 0, self:GetWide() - 10, self:GetTall() )
	end

	return true
end

function PANEL:DoClick()
	RunConsoleCommand( self.Cmd )
end

function PANEL:SetCommand( str, text, clr )
	self.Cmd = str
	self.Text = text
	self.Clr = clr
end

vgui.Register( "gms_CommandPanel", PANEL, "DButton" )

/*---------------------------------------------------------
	Loading bar
---------------------------------------------------------*/

local PANEL = {}

function PANEL:Init()
	self:SetSize( ScrW() / 2.7, ScrH() / 10 )
	self:SetPos( ScrW() / 2 - ( self:GetWide() / 2 ), ScrH() / 2 - ( self:GetTall() / 2 ) )

	self.Dots = "."
	self.Message = ""
end

function PANEL:Paint()
	draw.RoundedBox( 8, 0, 0, self:GetWide(), self:GetTall(), Color( 100, 100, 100, 150 ) ) //Background

	//Text
	draw.SimpleText( "Loading" .. self.Dots, "ScoreboardHead", self:GetWide() / 2, self:GetTall() / 2, Color( 255, 255, 255, 255 ), 1, 1 )
	draw.SimpleText( self.Text, "ScoreboardText", self:GetWide() / 2, self:GetTall() / 1.2, Color( 255, 255, 255, 255 ), 1, 1 )
	return true
end

function PANEL:Show( msg )
	self.IsStopped = false

	self.Text = msg
	timer.Simple( 0.5, function() self:UpdateDots() end )
	self:SetVisible( true )
end

function PANEL:Hide()
	self.IsStopped = true
	self:SetVisible( false )
end

function PANEL:UpdateDots()
	if ( self.IsStopped ) then return end

	if self.Dots == "...." then
		self.Dots = "."
	else
		self.Dots = self.Dots .. "."
	end

	timer.Simple( 0.5, function() self:UpdateDots() end )
end

vgui.Register( "gms_LoadingBar", PANEL, "Panel" )

/*---------------------------------------------------------
	Saving bar
---------------------------------------------------------*/

local PANEL = {}

function PANEL:Init()
	self:SetSize( ScrW() / 2.7, ScrH() / 10 )
	self:SetPos( ScrW() / 2 - ( self:GetWide() / 2 ), ScrH() / 2 - ( self:GetTall() / 2 ) )

	self.Dots = "."
	self.Message = ""
end

function PANEL:Paint()
	//Background
	draw.RoundedBox( 8, 0, 0, self:GetWide(), self:GetTall(), Color( 100, 100, 100, 150 ) )

	//Text
	draw.SimpleText( "Saving" .. self.Dots, "ScoreboardHead", self:GetWide() / 2, self:GetTall() / 2, Color( 255, 255, 255, 255 ), 1, 1 )
	draw.SimpleText( self.Text, "ScoreboardText", self:GetWide() / 2, self:GetTall() / 1.2, Color( 255, 255, 255, 255 ), 1, 1 )
	return true
end

function PANEL:Show( msg )
	self.IsStopped = false

	self.Text = msg
	timer.Simple( 0.5, function() self:UpdateDots() end )
	self:SetVisible( true )
end

function PANEL:Hide()
	self.IsStopped = true
	self:SetVisible( false )
end

function PANEL:UpdateDots()
	if ( self.IsStopped ) then return end

	if ( self.Dots == "...." ) then
		self.Dots = "."
	else
		self.Dots = self.Dots .. "."
	end

	timer.Simple( 0.5, function() self:UpdateDots() end )
end

vgui.Register( "gms_SavingBar", PANEL, "Panel" )

/*---------------------------------------------------------
	Command button
---------------------------------------------------------*/
local PANEL = {}

function PANEL:Init()
end

function PANEL:DoClick()
	LocalPlayer():ConCommand( self.Command .. "\n" )
	surface.PlaySound( Sound( "ui/buttonclickrelease.wav" ) )
end

function PANEL:SetConCommand( cmd )
	self.Command = cmd
end

function PANEL:OnCursorEntered()
	surface.PlaySound( Sound( "ui/buttonrollover.wav" ) )
end

vgui.Register( "gms_CommandButton", PANEL, "DButton" )

/*---------------------------------------------------------
	Combination Window
---------------------------------------------------------*/

local PANEL = {}

function PANEL:Init()
	self:SetSize( ScrW() / 1.3, ScrH() / 1.4 )
	self:SetDeleteOnClose( false )
	self:MakePopup()
	self:Center()

	self.CombiList = vgui.Create( "DPanelList", self )
	self.CombiList:SetPos( 5, 25 )
	self.CombiList:SetSize( self:GetWide() - 10, self:GetTall() * 0.55 )
	self.CombiList:SetSpacing( 5 )
	self.CombiList:SetPadding( 5 )
	self.CombiList:EnableHorizontal( true )
	self.CombiList:EnableVerticalScrollbar( true )

	self.Info = vgui.Create( "DPanel", self )
	self.Info:SetPos( 5, self.CombiList:GetTall() + 30 )
	self.Info:SetSize( self:GetWide() - 10, self:GetTall() - self.CombiList:GetTall() - 70 )

	self.Info.NameLabel = vgui.Create( "DLabel", self.Info )
	self.Info.NameLabel:SetPos( 5, 5 )
	self.Info.NameLabel:SetSize( self.Info:GetWide(), 20 )
	self.Info.NameLabel:SetFont( "ScoreboardSub" )
	self.Info.NameLabel:SetDark( true )
	self.Info.NameLabel:SetText( "Select a recipe" )

	self.Info.DescLabel = vgui.Create( "DLabel", self.Info )
	self.Info.DescLabel:SetPos( 5, 25 )
	self.Info.DescLabel:SetSize( self.Info:GetWide(), self.Info:GetTall() - 30 )
	self.Info.DescLabel:SetDark( true )
	self.Info.DescLabel:SetText( "" )

	self.button = vgui.Create( "gms_CommandButton", self )
	self.button:SetPos( 5, self:GetTall() - 35 )
	self.button:SetSize( self:GetWide() - 10, 30 )
	self.button:SetText( "Make" )
	self.button:SetDisabled( true )
	function self.button:DoClick()
		local p = self:GetParent()
		local combi = p.CombiGroupName or ""
		local active = p.ActiveCombi or ""
		p:Close()
		LocalPlayer():ConCommand( "gms_MakeCombination " .. combi .. " " .. active .. "\n" )
	end

	self.IconSize = 86
	self.CombiPanels = {}
end

function PANEL:SetTable( str )
	self:SetTitle( "#" .. str )
	self.CombiGroupName = str
	self.CombiGroup = GMS.Combinations[ str ]
	self:Clear()
	for name, tbl in SortedPairs( self.CombiGroup or {} ) do
		local icon = vgui.Create( "GMS_CombiIcon", self.CombiList )
		icon:SetSize( self.IconSize, self.IconSize )
		icon:SetInfo( name, tbl )
		self.CombiList:AddItem( icon )
		table.insert( self.CombiPanels, icon )
	end
	self:ClearActive()
end

function PANEL:SetActive( combi, tbl )
	self.ActiveCombi = combi
	self.ActiveTable = tbl
	self.Info.NameLabel:SetText( tbl.Name )

	local desc = tbl.Description

	if ( tbl.Req or tbl.SkillReq ) then
		desc = desc .. "\n\nYou need:"
	end
	
	if ( tbl.Req and table.Count( tbl.Req ) > 0 ) then
		for res, num in pairs( tbl.Req ) do
			if ( tbl.AllSmelt ) then
				desc = desc .. "\n" .. string.Replace( res, "_", " " ) .. " ( " .. tbl.Max .. " max )"
			else
				desc = desc .. "\n" .. string.Replace( res, "_", " " ) .. ": " .. num
			end
		end
	end

	if ( tbl.SkillReq and table.Count( tbl.SkillReq ) > 0 ) then
		for skill, num in pairs( tbl.SkillReq ) do
			desc = desc .. "\n" .. string.Replace( skill, "_", " " ) .. " level " .. num
		end
	end

	if ( tbl.FoodValue ) then
		desc = desc .. "\n\nFood initial quality: " .. math.floor( tbl.FoodValue / 10 ) .. "%"
	end

	self.Info.DescLabel:SetText( desc )
end

function PANEL:ClearActive()
	self.ActiveCombi = nil
	self.ActiveTable = nil 
	self.Info.NameLabel:SetText( "Select a recipe" )
	self.Info.DescLabel:SetText( "" )
end

function PANEL:Clear()
	for k, v in pairs( self.CombiPanels ) do
		v:Remove()
	end
	self.CombiPanels = {}
end
vgui.Register( "GMS_CombinationWindow", PANEL, "DFrame" )

/*---------------------------------------------------------
	Combi Icon
---------------------------------------------------------*/

local PANEL = {}
PANEL.TexID = Material( "gms_icons/gms_none.png" )
PANEL.BGTexID = Material( "gms_icons/gms_none_bg.png" )

function PANEL:Paint( w, h )

	surface.SetDrawColor( 200, 200, 200, 255 )
	//surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )*/

	surface.SetMaterial( self.BGTexID )
	surface.DrawTexturedRect( -( 128 - w ) / 2, -( 128 - h ) / 2, 128, 128 )

	surface.SetDrawColor( StrandedBorderColor )
	surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )

	local hasskill = true
	if ( self.CombiTable.SkillReq ) then
		for k, v in pairs( self.CombiTable.SkillReq ) do
			if ( GetSkill( k ) < v ) then hasskill = false end
		end
	end

	local hasres = true
	if ( self.CombiTable.Req ) then
		for k, v in pairs( self.CombiTable.Req ) do
			if ( GetResource( k ) < v ) then hasres = false end
		end
	end

	if ( !hasskill ) then
		surface.SetDrawColor( 200, 200, 0, 150 )
		surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
	elseif ( !hasres ) then
		surface.SetDrawColor( 200, 0, 0, 100 )
		surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
	end

	surface.SetDrawColor( 255, 255, 255, 255 )

	surface.SetMaterial( self.TexID )
	surface.DrawTexturedRect( -( 128 - w ) / 2, -( 128 - h ) / 2, 128, 128 )

	local y = self:GetTall() / 2 + self:GetTall() / 4
	draw.SimpleTextOutlined( self.CombiTable.Name, "DefaultSmall", self:GetWide() / 2, y, Color( 255, 255, 255, 255 ), 1, 1, 0.5, Color( 100, 100, 100, 140 ) )
	return true

end

function PANEL:SetInfo( name, tbl )
	if ( tbl.Texture && Material( tbl.Texture ) ) then self.TexID = Material( tbl.Texture ) end
	self.Combi = name
	self.CombiTable = tbl
end

function PANEL:OnMousePressed( mc )
	if ( mc != 107 ) then return end
	surface.PlaySound( Sound( "ui/buttonclickrelease.wav" ) )
	self:GetParent():GetParent():GetParent():SetActive( self.Combi, self.CombiTable )
	self:GetParent():GetParent():GetParent().button:SetDisabled( false )
end

function PANEL:OnCursorEntered()
	surface.PlaySound( Sound( "ui/buttonrollover.wav" ) )
end

vgui.Register( "GMS_CombiIcon", PANEL, "DPanel" )

/* Resource Pack GUI */

local PANEL = {}

function PANEL:Init()
	self.Text = ""
	self.Num = 0

	self.TakeX = vgui.Create( "gms_takeButton", self )
	self.TakeAll = vgui.Create( "gms_takeButton", self )
end

function PANEL:Paint()
	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 176, 176, 176, 255 ) )
	draw.SimpleText( self.Text .. ": " .. self.Num, "DefaultBold", 5, self:GetTall() / 2 - 1, Color( 255, 255, 255, 255 ), 0, 1 )
end

function PANEL:SetRes( str, num, isResPack )
	self.Text = str
	self.Num = num

	if ( isResPack ) then
		self.TakeX:SetRes( str, nil, false )
		self.TakeAll:SetRes( str, num, true, false )
	else
		self.TakeX:Remove()
		self.TakeX = nil
		self.TakeAll:SetRes( str, 1, true, true )
	end
end

function PANEL:PerformLayout()
	self.TakeAll:SetSize( 64, self:GetTall() - 4 )
	self.TakeAll:SetPos( self:GetWide() - 66, 2 )

	if ( self.TakeX and self.TakeX != NULL ) then
		self.TakeX:SetSize( 64, self:GetTall() - 4 )
		self.TakeX:SetPos( self:GetWide() - 132, 2 )
	end
end

vgui.Register( "gms_resourceLine", PANEL, "Panel" )

// Take button
local PANEL = {}

function PANEL:Init()
	self.Text = ""
	self.Num = 0
	self.IsAll = false
	self.IsFridge = false
	self:SetText( "" )
end

function PANEL:Paint()
	if ( self:GetDisabled() ) then
		draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 50, 50, 50, 255 ) )
	elseif ( self.Depressed /*|| self:GetSelected()*/ ) then
		draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 50, 50, 176, 255 ) )
	elseif ( self.Hovered ) then
		draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 100, 100, 255, 255 ) )
	else
		draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 100, 100, 100, 255 ) )
	end

	if ( self.IsFridge ) then
		draw.SimpleText( "Take", "DefaultBold", self:GetWide() / 2, self:GetTall() / 2 - 1, Color( 255, 255, 255, 255 ), 1, 1 )
	elseif ( self.IsAll ) then
		draw.SimpleText( "Take All", "DefaultBold", self:GetWide() / 2, self:GetTall() / 2 - 1, Color( 255, 255, 255, 255 ), 1, 1 )
	else
		draw.SimpleText( "Take X", "DefaultBold", self:GetWide() / 2, self:GetTall() / 2 - 1, Color( 255, 255, 255, 255 ), 1, 1 )
	end
end

function PANEL:DoClick()
	if ( self.IsAll ) then
		RunConsoleCommand( "gms_TakeResources", string.gsub( self.Text, " ", "_" ), self.Num )
		if ( self.IsFridge ) then self:GetParent():GetParent():GetParent():GetParent():Close() return end
	else
		local res = self.Text
		Derma_StringRequest( "Please enter amount", "Please enter amount of " ..  res .. " to take.", "", function( text )
			RunConsoleCommand( "gms_TakeResources", string.gsub( res, " ", "_" ), text )
		end )
	end
end

function PANEL:SetRes( str, num, isAll, isFridge )
	self.Text = str
	self.Num = num
	self.IsAll = isAll
	self.IsFridge = isFridge
end

vgui.Register( "gms_takeButton", PANEL, "DButton" )

// Store Line
local PANEL = {}

function PANEL:Init()
	self.Text = ""
	self.Num = 0

	self.StoreX = vgui.Create( "gms_StoreButton", self )
	self.StoreAll = vgui.Create( "gms_StoreButton", self )
end

function PANEL:Paint()
	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 176, 176, 176, 255 ) )
	draw.SimpleText( string.Replace( self.Text, "_", " " ) .. ": " .. self.Num, "DefaultBold", 5, self:GetTall() / 2 - 1, Color( 255, 255, 255, 255 ), 0, 1 )
end

function PANEL:SetRes( str, num )
	self.Text = str
	self.Num = num

	self.StoreX:SetRes( str, nil )
	self.StoreAll:SetRes( str, num, true )
end

function PANEL:PerformLayout()
	self.StoreAll:SetSize( 64, self:GetTall() - 4 )
	self.StoreAll:SetPos( self:GetWide() - 66, 2 )

	self.StoreX:SetSize( 64, self:GetTall() - 4 )
	self.StoreX:SetPos( self:GetWide() - 132, 2 )
end

vgui.Register( "gms_resourceLineStore", PANEL, "Panel" )

// Store button
local PANEL = {}

function PANEL:Init()
	self.Text = ""
	self.Num = 0
	self.IsAll = false
	self:SetText( "" )
end

function PANEL:Paint()
	if ( self:GetDisabled() ) then
		draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 50, 50, 50, 255 ) )
	elseif ( self.Depressed /*|| self:GetSelected()*/ ) then
		draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 50, 50, 176, 255 ) )
	elseif ( self.Hovered ) then
		draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 100, 100, 255, 255 ) )
	else
		draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 100, 100, 100, 255 ) )
	end

	if ( self.IsAll ) then
		draw.SimpleText( "Store All", "DefaultBold", self:GetWide() / 2, self:GetTall() / 2 - 1, Color( 255, 255, 255, 255 ), 1, 1 )
	else
		draw.SimpleText( "Store X", "DefaultBold", self:GetWide() / 2, self:GetTall() / 2 - 1, Color( 255, 255, 255, 255 ), 1, 1 )
	end
end

function PANEL:DoClick()
	if ( self.IsAll ) then
		RunConsoleCommand( "gms_DropResources", string.gsub( self.Text, " ", "_" ), self.Num )
	else
		local res = self.Text
		Derma_StringRequest( "Please enter amount", "Please enter amount of " ..  res .. " to store.", "", function( text )
			RunConsoleCommand( "gms_DropResources", string.gsub( res, " ", "_" ), text )
		end )
	end
end
function PANEL:SetRes( str, num, isAll )
	self.Text = str
	self.Num = num
	self.IsAll = isAll
end

vgui.Register( "gms_StoreButton", PANEL, "DButton" )