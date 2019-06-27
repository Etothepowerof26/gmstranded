
/* ToolMenuButton */
local PANEL = {}

AccessorFunc( PANEL, "m_bAlt", "Alt" )
AccessorFunc( PANEL, "m_bSelected", "Selected" )

function PANEL:Init()
	self:SetContentAlignment( 4 ) 
	self:SetTextInset( 5, 0 )
	self:SetTall( 15 )
end

function PANEL:Paint()
	if ( !self.m_bSelected ) then
		if ( !self.m_bAlt ) then
			surface.SetDrawColor( Color( 255, 255, 255, 200 ) )
		else
			surface.SetDrawColor( Color( 255, 255, 255, 150 ) )
		end
	else
		surface.SetDrawColor( Color( 50, 150, 255, 250 ) )
	end

	self:DrawFilledRect()
end

function PANEL:OnMousePressed( mcode )
	if ( mcode == MOUSE_LEFT ) then
		self:OnSelect()
	end
end

function PANEL:OnCursorMoved( x, y )
	if ( input.IsMouseDown( MOUSE_LEFT ) ) then
		self:OnSelect()
	end
end

function PANEL:OnSelect()
end

function PANEL:PerformLayout()
	if ( self.Checkbox ) then
		self.Checkbox:AlignRight( 4 )
		self.Checkbox:CenterVertical()
	end
end

function PANEL:AddCheckBox( strConVar )
	if ( !self.Checkbox ) then 
		self.Checkbox = vgui.Create( "DCheckBox", self )
	end

	self.Checkbox:SetConVar( strConVar )
	self:InvalidateLayout()
end

vgui.Register( "ToolMenuButton", PANEL, "DButton" )

/* DPropSpawnMenu */
local PANEL = {}

function PANEL:Init()
	self:SetSpacing( 5 )
	self:SetPadding( 5 )
	self:EnableHorizontal( false )
	self:EnableVerticalScrollbar( true )  
	function self:Paint()
		draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 75, 75, 75 ) )
	end

	for k, v in SortedPairs( GMS_SpawnLists ) do
		local cat = vgui.Create( "DCollapsibleCategory", self )
		cat:SetExpanded( 0 )
		cat:SetLabel( k )

		local IconList = vgui.Create( "DPanelList", cat )
		IconList:EnableVerticalScrollbar( true ) 
		IconList:EnableHorizontal( true ) 
		IconList:SetAutoSize( true )
		IconList:SetSpacing( 5 )
		IconList:SetPadding( 5 )

		cat:SetContents( IconList )
		self:AddItem( cat )

		for key, value in pairs( v ) do
			local Icon = vgui.Create( "SpawnIcon", IconList )
			Icon:SetModel( value )
			Icon.DoClick = function( Icon ) RunConsoleCommand( "gm_spawn", value, 0 ) end
			--Icon:SetIconSize( 64 ) 
			Icon:InvalidateLayout( true ) 
			Icon:SetToolTip( Format( "%s", value ) ) 
			IconList:AddItem( Icon )
		end
	end
end

vgui.Register( "stranded_propspawn", PANEL, "DPanelList" )

/* DToolMenu */
local PANEL = {}

function PANEL:Init()
	self.Tools = vgui.Create( "DPanelList", self )
	self.Tools:EnableVerticalScrollbar( true )
	self.Tools:SetAutoSize( false )
	self.Tools:SetSpacing( 5 )
	self.Tools:SetPadding( 5 )
	function self.Tools:Paint()
		draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 75, 75, 75 ) )
	end

	self.ContextPanel = vgui.Create( "DPanelList", self )
	self.ContextPanel:EnableVerticalScrollbar( false )
	self.ContextPanel:SetSpacing( 0 )
	self.ContextPanel:SetPadding( 5 )
	function self.ContextPanel:Paint()
		draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 255, 255, 255, 150 ) )
	end
  
	if ( ToolsLoad == false || ToolsLoad == nil || ToolsLoad == NULL || ToolsLoad == "" ) then
		AllTools = spawnmenu.GetTools()
		local ToolsLoad = true
	end

	local ToolTables = AllTools

	if ( !ToolTables ) then LocalPlayer():ChatPrint( "ERROR: Tools List could not be loaded." ) return end

	for k, v in pairs( ToolTables[1].Items ) do 
		if ( type( v ) == "table" ) then
			local Name = v.ItemName 
			local Label = v.Text 
			v.ItemName = nil 
			v.Text = nil 
			self:AddCategory( Name, Label, v ) 
		end
	end
end

function PANEL:AddCategory( Name, Label, ToolItems )
	self.Category = vgui.Create( "DCollapsibleCategory" ) 
	self.Tools:AddItem( self.Category )
	self.Category:SetLabel( Label ) 
	self.Category:SetCookieName( "ToolMenu." .. tostring( Name ) ) 

	self.CategoryContent = vgui.Create( "DPanelList" ) 
	self.CategoryContent:SetAutoSize( true ) 
	self.CategoryContent:SetDrawBackground( false ) 
	self.CategoryContent:SetSpacing( 0 ) 
	self.CategoryContent:SetPadding( 0 ) 
	self.Category:SetContents( self.CategoryContent ) 

	local bAlt = true
	local NumTools = 0

	for k, v in pairs( ToolItems ) do
		if ( table.HasValue( GMS.ProhibitedStools, v.ItemName ) && !LocalPlayer():IsAdmin() ) then continue end
		NumTools = NumTools + 1

		local Item = vgui.Create( "ToolMenuButton", self ) 
		Item:SetText( v.Text ) 
		Item.OnSelect = function( button ) self:EnableControlPanel( button ) end 
		concommand.Add( Format( "tool_%s", v.ItemName ), function() Item:OnSelect() end ) 

		if ( v.SwitchConVar ) then 
			Item:AddCheckBox( v.SwitchConVar ) 
		end 

		Item.ControlPanelBuildFunction = v.CPanelFunction 
		Item.Command = v.Command 
		Item.Name = v.ItemName 
		Item.Controls = v.Controls 
		Item.Text = v.Text 

		Item:SetAlt( bAlt ) 
		bAlt = !bAlt 

		self.CategoryContent:AddItem( Item )
	end

	if ( NumTools <= 0 ) then
		self.Category:Remove()
		self.CategoryContent:Remove()
	end
end

function PANEL:EnableControlPanel( button ) 
	if ( self.LastSelected ) then 
		self.LastSelected:SetSelected( false )
	end 

	button:SetSelected( true ) 
	self.LastSelected = button 

	local cp = controlpanel.Get( button.Name ) 
	if ( !cp:GetInitialized() ) then 
		cp:FillViaTable( button ) 
	end 

	self.ContextPanel:Clear() 
	self.ContextPanel:AddItem( cp ) 
	self.ContextPanel:Rebuild() 

	g_ActiveControlPanel = cp 

	if ( button.Command ) then 
		LocalPlayer():ConCommand( button.Command ) 
	end 
end

function PANEL:Paint()
end

function PANEL:PerformLayout()
	self:StretchToParent( 0, 21, 0, 5 )
	self.Tools:SetPos( 5, 5 )
	self.Tools:SetSize( self:GetWide() * 0.35, self:GetTall() - 5 )
	self.ContextPanel:SetPos( self:GetWide() * 0.35 + 10, 5 )
	self.ContextPanel:SetSize( self:GetWide() - ( self:GetWide() * 0.35 ) - 14, self:GetTall() - 5 )
end

vgui.Register( "stranded_toolmenu", PANEL, "DPanel" )

/* DCommandsMenu */
local PANEL = {}

PANEL.SmallButs = {}
PANEL.SmallButs["Sleep"] = "gms_sleep"
PANEL.SmallButs["Wake up"] = "gms_wakeup"
PANEL.SmallButs["Drop weapon"] = "gms_dropweapon"
PANEL.SmallButs["Steal"] = "gms_steal"
PANEL.SmallButs["Make campfire"] = "gms_makefire"
PANEL.SmallButs["Drink bottle of water"] = "gms_drinkbottle"
PANEL.SmallButs["Take medicine"] = "gms_takemedicine"
PANEL.SmallButs["Combinations"] = "gms_combinations"
PANEL.SmallButs["Structures"] = "gms_structures"
PANEL.SmallButs["Help"] = "gms_help"
PANEL.SmallButs["Drop all resources"] = "gms_dropall"
PANEL.SmallButs["Salvage prop"] = "gms_salvage"
PANEL.SmallButs["Eat some berries"] = "gms_eatberry"
PANEL.SmallButs["RESET CHARACTER"] = "gms_resetcharacter"

PANEL.BigButs = {}
PANEL.BigButs["Tribe: Create"] = "gms_tribemenu"
PANEL.BigButs["Tribe: Join"] = "gms_tribes"
PANEL.BigButs["Tribe: Leave"] = "gms_leave"
PANEL.BigButs["Save character"] = "gms_savecharacter"

PANEL.Plantables = {}
PANEL.Plantables["Plant Melon"] = "gms_plantmelon"
PANEL.Plantables["Plant Banana"] = "gms_plantbanana"
PANEL.Plantables["Plant Orange"] = "gms_plantorange"
PANEL.Plantables["Plant Tree"] = "gms_planttree"
PANEL.Plantables["Plant Grain"] = "gms_plantgrain"
PANEL.Plantables["Plant BerryBush"] = "gms_plantbush"

function PANEL:Init()

	self.SmallButtons = vgui.Create( "DPanelList", self )
	self.SmallButtons:EnableVerticalScrollbar( true )
	self.SmallButtons:SetSpacing( 5 )
	self.SmallButtons:SetPadding( 5 )
	function self.SmallButtons:Paint()
		draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 75, 75, 75 ) )
	end

	for txt, cmd in SortedPairs( self.SmallButs ) do
		local button = vgui.Create( "gms_CommandButton" )
		button:SetConCommand( cmd )
		button:SetText( txt )
		button:SetTall( 26 )
		self.SmallButtons:AddItem( button )
	end

	self.BigButtons = vgui.Create( "DPanelList", self )
	self.BigButtons:EnableVerticalScrollbar( false )
	self.BigButtons:SetAutoSize( false )
	self.BigButtons:SetSpacing( 5 )
	self.BigButtons:SetPadding( 5 )
	function self.BigButtons:Paint()
		draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 75, 75, 75 ) )
	end

	for txt, cmd in SortedPairs( self.BigButs ) do
		local button = vgui.Create( "gms_CommandButton" )
		button:SetConCommand( cmd )
		button:SetText( txt )
		button:SetTall( 64 )
		self.BigButtons:AddItem( button )
	end

	self.Planting = vgui.Create( "DPanelList", self )
	self.Planting:EnableVerticalScrollbar( false )
	self.Planting:SetSpacing( 5 )
	self.Planting:SetPadding( 5 )
	function self.Planting:Paint()
		draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 75, 75, 75 ) )
	end

	for txt, cmd in SortedPairs( self.Plantables ) do
		local button = vgui.Create( "gms_CommandButton" )
		button:SetConCommand( cmd )
		button:SetText( txt )
		button:SetTall( 26 )
		self.Planting:AddItem( button )
	end
end

function PANEL:Paint()
end

function PANEL:PerformLayout()
	self:StretchToParent( 0, 21, 0, 5 )
	self.SmallButtons:SetPos( 5, 5 )
	self.SmallButtons:SetSize( self:GetWide() * 0.45, self:GetTall() - 5 )

	self.BigButtons:SetPos( self:GetWide() * 0.45 + 10, 5 )
	self.BigButtons:SetSize( self:GetWide() - ( self:GetWide() * 0.45 ) - 14, self:GetTall() / 2 - 5 )

	self.Planting:SetPos( self:GetWide() * 0.45 + 10, self:GetTall() / 2 + 5 )
	self.Planting:SetSize( self:GetWide() - ( self:GetWide() * 0.45 ) - 14, self:GetTall() / 2 - 5 )
end

vgui.Register( "stranded_commands", PANEL, "DPanel" )

/* DSPP Menu */
local PANEL = {}

PANEL.LastThink = CurTime()
PANEL.Settings = {
	{ text = "Enable Prop Protection", elem = "DCheckBoxLabel", cmd = "spp_enabled" },
	{ text = "Enable use key protection", elem = "DCheckBoxLabel", cmd = "spp_use" },
	{ text = "Enable entity damage protection", elem = "DCheckBoxLabel", cmd = "spp_entdmg" },
	{ text = "", elem = "DLabel" },
	{ text = "Admins can touch other player props", elem = "DCheckBoxLabel", cmd = "spp_admin" },
	{ text = "Admins can touch world props", elem = "DCheckBoxLabel", cmd = "spp_admin_wp" },
	{ text = "", elem = "DLabel" },
	{ text = "Delete disconnected admins entities", elem = "DCheckBoxLabel", cmd = "spp_del_adminprops" },
	{ text = "Delete disconnected players entities", elem = "DCheckBoxLabel", cmd = "spp_del_disconnected" },
	{ text = "Deletion delay in seconds", elem = "DNumSlider", cmd = "spp_del_delay", min = 10, max = 600 },
}

function PANEL:Init()
	if ( !LocalPlayer():IsAdmin() ) then
		self.Settings = {
			{ text = "You are not an admin.", elem = "DLabel" }
		}
	end

	self.Buddies = vgui.Create( "DPanelList", self )
	self.Buddies:EnableVerticalScrollbar( true )
	self.Buddies:SetSpacing( 5 )
	self.Buddies:SetPadding( 5 )
	function self.Buddies:Paint()
		draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 75, 75, 75 ) )
	end

	self.AdminSettings = vgui.Create( "DPanelList", self )
	self.AdminSettings:EnableVerticalScrollbar( true )
	self.AdminSettings:SetSpacing( 5 )
	self.AdminSettings:SetPadding( 5 )
	function self.AdminSettings:Paint()
		draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 75, 75, 75 ) )
	end

	self.AdminCleanUp = vgui.Create( "DPanelList", self )
	self.AdminCleanUp:EnableVerticalScrollbar( true )
	self.AdminCleanUp:SetSpacing( 5 )
	self.AdminCleanUp:SetPadding( 5 )
	function self.AdminCleanUp:Paint()
		draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 75, 75, 75 ) )
	end

	/* Admin settings */
	for txt, t in pairs( self.Settings ) do
		local item = vgui.Create( t.elem )
		item:SetText( t.text )

		if ( t.elem != "DLabel" ) then
			item:SetConVar( t.cmd )
		end

		if ( t.elem == "DNumSlider" ) then
			item:SetMin( t.min )
			item:SetMax( t.max )
			item:SetDecimals( 0 )
			item.TextArea:SetTextColor( Color( 200, 200, 200 ) )
		end

		self.AdminSettings:AddItem( item )
	end

	/* Admin cleanup */
	for i, p in pairs( player.GetAll() ) do
		local item = vgui.Create( "DButton" )
		item:SetConsoleCommand( "spp_cleanup_props", p:GetNWString( "SPPSteamID" ) )
		item:SetText( p:Name() )
		item:SetTall( 26 )
		self.AdminCleanUp:AddItem( item )
	end

	local item = vgui.Create( "DButton" )
	item:SetConsoleCommand( "spp_cleanup_props_left" )
	item:SetText( "Cleanup disconnected players props" )
	item:SetTall( 26 )
	self.AdminCleanUp:AddItem( item )

	/* Client */
	for i, p in pairs( player.GetAll() ) do
		if ( p != LocalPlayer() ) then
			local item = vgui.Create( "DCheckBoxLabel" )

			local BCommand = "spp_buddy_" .. p:GetNWString( "SPPSteamID" )
			if ( !LocalPlayer():GetInfo( BCommand ) ) then CreateClientConVar( BCommand, 0, false, true ) end
			item:SetConVar( BCommand )
			item:SetText( p:Name() )
			item:SetTextColor( Color( 255, 255, 255, 255 ) )
			self.Buddies:AddItem( item )
		end
	end

	local item = vgui.Create( "DButton" )
	item:SetConsoleCommand( "spp_apply_buddies" )
	item:SetText( "Apply settings" )
	item:SetTall( 26 )
	self.Buddies:AddItem( item )
	
	local item = vgui.Create( "DButton" )
	item:SetConsoleCommand( "spp_clear_buddies" )
	item:SetText( "Clear all buddies" )
	item:SetTall( 26 )
	self.Buddies:AddItem( item )
end

function PANEL:Paint()
end

function PANEL:Think()
	if ( CurTime() >= self.LastThink + 3 )then
		self.LastThink = CurTime()
		self.AdminCleanUp:Clear( true )
		self.Buddies:Clear( true )
		
		/* Admin cleanup */
		if ( LocalPlayer():IsAdmin() ) then
			for i, p in pairs( player.GetAll() ) do
				local item = vgui.Create( "DButton" )
				item:SetConsoleCommand( "spp_cleanup_props", p:GetNWString( "SPPSteamID" ) )
				item:SetTall( 26 )
				item:SetText( p:Name() )
				self.AdminCleanUp:AddItem( item )
			end

			local item = vgui.Create( "DButton" )
			item:SetConsoleCommand( "spp_cleanup_props_left" )
			item:SetTall( 26 )
			item:SetText( "Cleanup disconnected players props" )
			self.AdminCleanUp:AddItem( item )
	
			self.AdminSettings:SetVisible( true )
			self.AdminCleanUp:SetVisible( true )
		else
			local item = vgui.Create( "DLabel" )
			item:SetText( "You are not an admin." )
			self.AdminCleanUp:AddItem( item )
			
			self.AdminSettings:SetVisible( false )
			self.AdminCleanUp:SetVisible( false )
		end
		
		/* Client */
		for i, p in pairs( player.GetAll() ) do
			if ( p != LocalPlayer() ) then
				local item = vgui.Create( "DCheckBoxLabel" )

				local BCommand = "spp_buddy_" .. p:GetNWString( "SPPSteamID" )
				if ( !LocalPlayer():GetInfo( BCommand ) ) then CreateClientConVar( BCommand, 0, false, true ) end
				item:SetConVar( BCommand )
				item:SetText( p:Name() )
				self.Buddies:AddItem( item )
			end
		end
		
		local item = vgui.Create( "DButton" )
		item:SetConsoleCommand( "spp_apply_buddies" )
		item:SetText( "Apply settings" )
		item:SetTall( 26 )
		self.Buddies:AddItem( item )
		
		local item = vgui.Create( "DButton" )
		item:SetConsoleCommand( "spp_clear_buddies" )
		item:SetText( "Clear all buddies" )
		item:SetTall( 26 )
		self.Buddies:AddItem( item )
	end
end

function PANEL:PerformLayout()
	self:StretchToParent( 0, 21, 0, 5 )

	self.Buddies:SetPos( 5, 5 )
	self.Buddies:SetSize( self:GetWide() * 0.45, self:GetTall() - 5 )

	self.AdminSettings:SetPos( self:GetWide() * 0.45 + 10, 5 )
	self.AdminSettings:SetSize( self:GetWide() - ( self:GetWide() * 0.45 ) - 14, self:GetTall() / 2 - 5 )

	self.AdminCleanUp:SetPos( self:GetWide() * 0.45 + 10, self:GetTall() / 2 + 5 )
	self.AdminCleanUp:SetSize( self:GetWide() - ( self:GetWide() * 0.45 ) - 14, self:GetTall() / 2 - 5 )
end

vgui.Register( "stranded_sppmenu", PANEL, "DPanel" )

/* Admin Menu */
local PANEL = {}

PANEL.SpawningCmds = {
	{ text = "Spawn tree", cmd = "gms_admin_maketree" },
	{ text = "Spawn rock", cmd = "gms_admin_makerock" },
	{ text = "Spawn food", cmd = "gms_admin_makefood" },
	{ text = "Save all characters", cmd = "gms_admin_saveallcharacters" },
	{ text = "Plant random plant", cmd = "gms_admin_makeplant" },
	{ text = "Plant melons", cmd = "gms_admin_makeplant 1" },
	{ text = "Plant banana tree", cmd = "gms_admin_makeplant 2" },
	{ text = "Plant oranges", cmd = "gms_admin_makeplant 3" },
	{ text = "Plant berry bush", cmd = "gms_admin_makeplant 4" },
	{ text = "Plant grain", cmd = "gms_admin_makeplant 5" }
}

PANEL.Settings = {
	{ text = "Force players to use Tribe color", elem = "DCheckBoxLabel", cmd = "gms_TeamColors" },
	{ text = "Allow players to damage each other with tools", elem = "DCheckBoxLabel", cmd = "gms_PVPDamage" },
	{ text = "Enable free build for everyone", elem = "DCheckBoxLabel", cmd = "gms_FreeBuild" },
	{ text = "Enable free build for super admins", elem = "DCheckBoxLabel", cmd = "gms_FreeBuildSa" },
	{ text = "Give all players all tools", elem = "DCheckBoxLabel", cmd = "gms_AllTools" },
	//{ text = "Enable low needs alerts ( coughing, etc )", elem = "DCheckBoxLabel", cmd = "gms_alerts" },
	{ text = "Spread fire", elem = "DCheckBoxLabel", cmd = "gms_SpreadFire" },
	{ text = "Fadeout rocks, just like trees", elem = "DCheckBoxLabel", cmd = "gms_FadeRocks" },
	{ text = "Enable campfires", elem = "DCheckBoxLabel", cmd = "gms_campfire" },
	{ text = "Spawn zombies at night", elem = "DCheckBoxLabel", cmd = "gms_zombies" },
	{ text = "Enable day/night cycle", elem = "DCheckBoxLabel", cmd = "gms_daynight" },
	//{ text = "Costs scale", elem = "DNumSlider", decimals = 1, cmd = "gms_CostsScale", min = 1, max = 4 },
	{ text = "Plant limit per player", elem = "DNumSlider", cmd = "gms_PlantLimit", min = 10, max = 35 },
	{ text = "", elem = "DLabel" },
	{ text = "Reproduce trees", elem = "DCheckBoxLabel", cmd = "gms_ReproduceTrees" },
	{ text = "Max reproduced trees", elem = "DNumSlider", cmd = "gms_MaxReproducedTrees", min = 1, max = 60 },
	{ text = "", elem = "DLabel" },
	{ text = "Autosave user profiles", elem = "DCheckBoxLabel", cmd = "gms_AutoSave" },
	{ text = "Autosave delay ( minutes )", elem = "DNumSlider", cmd = "gms_AutoSaveTime", min = 1, max = 30 },
}

function PANEL:Init()

	self.MapSaving = vgui.Create( "DPanelList", self )
	self.MapSaving:EnableVerticalScrollbar( true )
	self.MapSaving:SetSpacing( 5 )
	self.MapSaving:SetPadding( 5 )
	function self.MapSaving:Paint()
		draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 75, 75, 75 ) )
	end

	self.Populating = vgui.Create( "DPanelList", self )
	self.Populating:EnableVerticalScrollbar( true )
	self.Populating:SetSpacing( 5 )
	self.Populating:SetPadding( 5 )
	function self.Populating:Paint()
		draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 75, 75, 75 ) )
	end

	self.AdminSettings = vgui.Create( "DPanelList", self )
	self.AdminSettings:EnableVerticalScrollbar( true )
	self.AdminSettings:SetSpacing( 5 )
	self.AdminSettings:SetPadding( 5 )
	function self.AdminSettings:Paint()
		draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 75, 75, 75 ) )
	end

	self.Spawning = vgui.Create( "DPanelList", self )
	self.Spawning:EnableVerticalScrollbar( true )
	self.Spawning:SetSpacing( 5 )
	self.Spawning:SetPadding( 5 )
	function self.Spawning:Paint()
		draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 75, 75, 75 ) )
	end

	for txt, t in pairs( self.Settings ) do
		local item = vgui.Create( t.elem )
		item:SetText( t.text )

		if ( t.elem == "DNumSlider" ) then
			item:SetMin( t.min )
			item:SetMax( t.max )
			item:SetDecimals( t.decimals or 0 )
			item.TextArea:SetTextColor( Color( 200, 200, 200 ) )
		end

		if ( t.elem != "DLabel" ) then item:SetConVar( t.cmd ) end

		self.AdminSettings:AddItem( item )
	end

	for txt, t in pairs( self.SpawningCmds ) do
		local item = vgui.Create( "DButton" )
		item:SetText( t.text )
		item:SetTall( 26 )
		item:SetConsoleCommand( t.cmd )
		self.Spawning:AddItem( item )
	end

	// POPULATE AREA
	local populatearea = vgui.Create( "DPanel", self )
	populatearea:SetTall( 100 )

	local label = vgui.Create( "DLabel", populatearea )
	label:SetPos( 10, 5 )
	label:SetDark( true )
	label:SetText( "Amount" )
	label:SizeToContents()

	self.PopulateAmount = vgui.Create( "DTextEntry", populatearea )
	self.PopulateAmount:SetPos( 10, 20 )
	self.PopulateAmount:SetTall( 24 )
	self.PopulateAmount:SetValue( "10" )
	populatearea.PopulateAmount = self.PopulateAmount

	local label = vgui.Create( "DLabel", populatearea )
	label:SetDark( true )
	label:SetText( "Max radius" )
	label:SizeToContents()

	self.PopulateRadius = vgui.Create( "DTextEntry", populatearea )
	self.PopulateRadius:SetValue( "1000" )
	self.PopulateRadius:SetTall( 24 )
	self.PopulateRadius.Label = label
	populatearea.PopulateRadius = self.PopulateRadius

	local label = vgui.Create( "DLabel", populatearea )
	label:SetPos( 10, 49 )
	label:SetDark( true )
	label:SetText( "Type" )
	label:SizeToContents()

	local typ = "Trees"
	self.PopulateType = vgui.Create( "DComboBox", populatearea )
	self.PopulateType:SetTall( 24 )
	self.PopulateType:SetPos( 10, 64 )
	self.PopulateType:AddChoice( "Trees", "Trees" )
	self.PopulateType:AddChoice( "Rocks", "Rocks" )
	self.PopulateType:AddChoice( "Random plants", "Random_Plant" )
	self.PopulateType:ChooseOptionID( 1 )
	function self.PopulateType:OnSelect( index, value, data ) typ = data end

	self.PopulateArea = vgui.Create( "gms_CommandButton", populatearea )
	self.PopulateArea:SetTall( 24 )
	self.PopulateArea:SetText( "Populate Area" )
	function self.PopulateArea:DoClick()
		local p = self:GetParent()
		RunConsoleCommand( "gms_admin_PopulateArea", typ, string.Trim( p.PopulateAmount:GetValue() ), string.Trim( p.PopulateRadius:GetValue() ) )
	end

	self.Populating:AddItem( populatearea )

	// POPULATE AREA: Antlions
	local populatearea = vgui.Create( "DPanel", self )
	populatearea:SetTall( 54 )

	local label = vgui.Create( "DLabel", populatearea )
	label:SetPos( 10, 5 )
	label:SetDark( true )
	label:SetText( "Amount" )
	label:SizeToContents()

	self.PopulateAmountAnt = vgui.Create( "DTextEntry", populatearea )
	self.PopulateAmountAnt:SetPos( 10, 20 )
	self.PopulateAmountAnt:SetTall( 24 )
	self.PopulateAmountAnt:SetValue( "5" )
	populatearea.PopulateAmountAnt = self.PopulateAmountAnt

	self.PopulateAreaAnt = vgui.Create( "gms_CommandButton", populatearea )
	self.PopulateAreaAnt:SetTall( 24 )
	self.PopulateAreaAnt:SetText( "Make Antlion Barrow" )
	function self.PopulateAreaAnt:DoClick()
		RunConsoleCommand( "gms_admin_MakeAntlionBarrow", string.Trim( self:GetParent().PopulateAmountAnt:GetValue() ) )
	end

	self.Populating:AddItem( populatearea )

	// Save map
	local populatearea = vgui.Create( "DPanel", self )
	populatearea:SetTall( 64 )

	self.MapName = vgui.Create( "DTextEntry", populatearea )
	self.MapName:SetPos( 5, 5 )
	self.MapName:SetTall( 24 )
	self.MapName:SetValue( "savename" )
	populatearea.MapName = self.MapName

	self.SaveMap = vgui.Create( "gms_CommandButton", populatearea )
	self.SaveMap:SetPos( 5, 34 )
	self.SaveMap:SetTall( 24 )
	self.SaveMap:SetText( "Save" )
	function self.SaveMap:DoClick()
		RunConsoleCommand( "gms_admin_savemap", string.Trim( self:GetParent().MapName:GetValue() ) )
	end

	self.MapSaving:AddItem( populatearea )

	// Load/delete map
	local populatearea = vgui.Create( "DPanel", self )
	populatearea:SetTall( 64 )

	local map = ""
	self.MapNameL = vgui.Create( "DComboBox", populatearea )
	self.MapNameL:SetTall( 24 )
	self.MapNameL:SetPos( 5, 5 )
	function self.MapNameL:OnSelect( index, value, data ) map = data end
	populatearea.MapNameL = self.MapNameL

	self.LoadMap = vgui.Create( "gms_CommandButton", populatearea )
	self.LoadMap:SetPos( 5, 34 )
	self.LoadMap:SetTall( 24 )
	self.LoadMap:SetText( "Load" )
	function self.LoadMap:DoClick()
		RunConsoleCommand( "gms_admin_loadmap", string.Trim( map ) )
	end

	self.DeleteMap = vgui.Create( "gms_CommandButton", populatearea )
	self.DeleteMap:SetTall( 24 )
	self.DeleteMap:SetText( "Delete" )
	function self.DeleteMap:DoClick()
		RunConsoleCommand( "gms_admin_deletemap", map )
	end

	self.MapSaving:AddItem( populatearea )

end

function PANEL:Paint()
end

function PANEL:PerformLayout()
	self:StretchToParent( 0, 21, 0, 5 )

	self.MapSaving:SetPos( 5, 5 )
	self.MapSaving:SetSize( self:GetWide() * 0.45, self:GetTall() / 2 - 5 )

	self.Populating:SetPos( 5, self:GetTall() / 2 + 5 )
	self.Populating:SetSize( self:GetWide() - ( self:GetWide() * 0.45 ) - 14, self:GetTall() / 2 - 5 )

	self.AdminSettings:SetPos( self:GetWide() * 0.45 + 10, 5 )
	self.AdminSettings:SetSize( self:GetWide() - ( self:GetWide() * 0.45 ) - 14, self:GetTall() / 2 - 5 )

	self.Spawning:SetPos( self:GetWide() - ( self:GetWide() * 0.45 ) - 4, self:GetTall() / 2 + 5 )
	self.Spawning:SetSize( self:GetWide() * 0.45, self:GetTall() / 2 - 5 )

	/* POPULATION */
	self.PopulateAmount:SetWide( self.Populating:GetWide() / 2 - 20 )
	self.PopulateRadius:SetWide( self.Populating:GetWide() / 2 - 20 )
	self.PopulateRadius.Label:SetPos( self.Populating:GetWide() / 2, 5 )
	self.PopulateRadius:SetPos( self.Populating:GetWide() / 2, 20 )

	self.PopulateType:SetWide( self.Populating:GetWide() / 2 - 20 )
	self.PopulateArea:SetWide( self.Populating:GetWide() / 2 - 20 )
	self.PopulateArea:SetPos( self.Populating:GetWide() / 2, 64 )

	/* ANTLIONS */
	self.PopulateAmountAnt:SetWide( self.Populating:GetWide() / 2 - 20 )
	self.PopulateAreaAnt:SetWide( self.Populating:GetWide() / 2 - 20 )
	self.PopulateAreaAnt:SetPos( self.Populating:GetWide() / 2, 20 )

	// Save map
	self.MapName:SetWide( self.MapSaving:GetWide() - 20 )
	self.SaveMap:SetWide( self.MapSaving:GetWide() - 20 )
	
	// Load/delete map
	self.MapNameL:SetSize( self.MapSaving:GetWide() - 20, 24 )
	self.LoadMap:SetWide( self.MapSaving:GetWide() / 2 - 20 )
	self.DeleteMap:SetWide( self.MapSaving:GetWide() / 2 - 20 )
	self.DeleteMap:SetPos( self.MapSaving:GetWide() / 2 + 5, 34 )
end

vgui.Register( "stranded_adminmenu", PANEL, "DPanel" )

/* Spawnpanel */
local PANEL = {}

function PANEL:Init()
	self:SetTitle( "" )
	self:ShowCloseButton( false )

	self.m_bHangOpen = false

	self.ContentPanel = vgui.Create( "DPropertySheet", self )
	self.ContentPanel:AddSheet( "Props", vgui.Create( "stranded_propspawn", self.ContentPanel ), "icon16/brick.png", false, false )
	self.ContentPanel:AddSheet( "Tools", vgui.Create( "stranded_toolmenu", self.ContentPanel ), "icon16/wrench.png", true, true )
	self.ContentPanel:AddSheet( "Commands", vgui.Create( "stranded_commands", self.ContentPanel ), "icon16/application.png", true, true )
	self.ContentPanel:AddSheet( "Prop Protection", vgui.Create( "stranded_sppmenu", self.ContentPanel ), "icon16/shield.png", true, true )

	self.AdminMenu = vgui.Create( "stranded_adminmenu", self.ContentPanel )
	local tab = self.ContentPanel:AddSheet( "Admin menu", self.AdminMenu, "icon16/shield_add.png", true, true )
	self.AdminTab = tab.Tab
end

function PANEL:Paint()
end

function PANEL:Think()
	if ( !LocalPlayer():IsAdmin() ) then
		/*self.AdminMenu.MapSaving:SetVisible( false )
		self.AdminMenu.Populating:SetVisible( false )
		self.AdminMenu.AdminSettings:SetVisible( false )
		self.AdminMenu.Spawning:SetVisible( false )*/
		self.AdminTab:SetVisible( false )
	else
		/*self.AdminMenu.MapSaving:SetVisible( true )
		self.AdminMenu.Populating:SetVisible( true )
		self.AdminMenu.AdminSettings:SetVisible( true )
		self.AdminMenu.Spawning:SetVisible( true )*/
		self.AdminTab:SetVisible( true )
	end
end

function PANEL:StartKeyFocus( pPanel )

	self.m_pKeyFocus = pPanel
	self:SetKeyboardInputEnabled( true )
	self.m_bHangOpen = true

	g_ContextMenu:StartKeyFocus( pPanel )

end

function PANEL:EndKeyFocus( pPanel )

	if ( self.m_pKeyFocus != pPanel ) then return end
	self:SetKeyboardInputEnabled( false )

	g_ContextMenu:EndKeyFocus( pPanel )

end

function PANEL:PerformLayout()
	self:SetSize( ScrW() / 2.2 - 10, ScrH() - 10 )
	self:SetPos( ScrW() - ( ScrW() / 2.2 + 5 ), 5 )
	self.ContentPanel:StretchToParent( 0, 0, 0, 0 )

	DFrame.PerformLayout( self )
end

vgui.Register( "gms_menu", PANEL, "DFrame" )

/* Spawn menu override */

local ToAdd = {}
local function UpdateSavegames()
	gSpawnMenu.AdminMenu.MapNameL:Clear()
	for id, st in pairs( ToAdd ) do
		gSpawnMenu.AdminMenu.MapNameL:AddChoice( st, st, true )
	end
end

usermessage.Hook( "gms_AddLoadGameToList", function( um )
	local str = um:ReadString()
	if ( table.HasValue( ToAdd, str ) ) then return end
	table.insert( ToAdd, str )

	if ( !IsValid( gSpawnMenu ) ) then return end
	UpdateSavegames()
end )

usermessage.Hook( "gms_RemoveLoadGameFromList", function( um )
	local str = um:ReadString()
	for id, st in pairs( ToAdd ) do if ( st == str ) then table.remove( ToAdd, id ) break end end

	if ( !IsValid( gSpawnMenu ) ) then return end
	UpdateSavegames()
end )

function GM:OnSpawnMenuOpen()
	if ( LocalPlayer():GetNWBool( "AFK" ) ) then return end
	
	if ( !IsValid( gSpawnMenu ) ) then
		gSpawnMenu = vgui.Create( "gms_menu" )
		gSpawnMenu:SetVisible( false )
		
		UpdateSavegames()
	end
	
	gSpawnMenu.m_bHangOpen = false

	gSpawnMenu:MakePopup()
	gSpawnMenu:SetVisible( true )
	gSpawnMenu:SetKeyboardInputEnabled( false )
	gSpawnMenu:SetMouseInputEnabled( true )
	gSpawnMenu:SetAlpha( 255 )

	GAMEMODE.SkillsHud:MakePopup()
	GAMEMODE.ResourcesHud:MakePopup()
	GAMEMODE.CommandsHud:MakePopup()

	GAMEMODE.SkillsHud:SetKeyboardInputEnabled( false )
	GAMEMODE.ResourcesHud:SetKeyboardInputEnabled( false )
	GAMEMODE.CommandsHud:SetKeyboardInputEnabled( false )

	GAMEMODE.CommandsHud:SetVisible( true )

	gui.EnableScreenClicker( true )
	RestoreCursorPosition()
end

function GM:OnSpawnMenuClose()
	if ( gSpawnMenu.m_bHangOpen ) then 
		gSpawnMenu.m_bHangOpen = false
		return
	end

	if ( IsValid( gSpawnMenu ) and gSpawnMenu:IsVisible() ) then
		gSpawnMenu:SetVisible( false )
	end

	GAMEMODE.SkillsHud:SetMouseInputEnabled( false )
	GAMEMODE.ResourcesHud:SetMouseInputEnabled( false )
	GAMEMODE.CommandsHud:SetMouseInputEnabled( false )

	GAMEMODE.CommandsHud:SetVisible( false )

	RememberCursorPosition()
	gui.EnableScreenClicker( false )
end

hook.Add( "OnTextEntryGetFocus", "GMSSpawnMenuKeyboardFocusOn", function( pnl )

	if ( !IsValid( gSpawnMenu ) || !IsValid( g_ContextMenu ) ) then return end
	if ( IsValid( pnl ) && pnl.HasParent && !pnl:HasParent( gSpawnMenu ) && !pnl:HasParent( g_ContextMenu ) ) then return end

	gSpawnMenu:StartKeyFocus( pnl )

end )

hook.Add( "GUIMousePressed", "GMS_KindaFixWorldClicking", function()
	GAMEMODE.SkillsHud:MakePopup()
	GAMEMODE.ResourcesHud:MakePopup()
	GAMEMODE.CommandsHud:MakePopup()

	GAMEMODE.SkillsHud:SetKeyboardInputEnabled( false )
	GAMEMODE.ResourcesHud:SetKeyboardInputEnabled( false )
	GAMEMODE.CommandsHud:SetKeyboardInputEnabled( false )
end )

hook.Add( "OnTextEntryLoseFocus", "GMSSpawnMenuKeyboardFocusOff", function( pnl )

	if ( !IsValid( gSpawnMenu ) || !IsValid( g_ContextMenu ) ) then return end
	if ( IsValid( pnl ) && pnl.HasParent && !pnl:HasParent( gSpawnMenu ) && !pnl:HasParent( g_ContextMenu ) ) then return end

	gSpawnMenu:EndKeyFocus( pnl )

end )

function GM:SpawnMenuEnabled()
	return false
end

function GM:OnContextMenuOpen()
	self.BaseClass.OnContextMenuOpen( self )
	menubar.Control:SetVisible( false )

	GAMEMODE.SkillsHud:MakePopup()
	GAMEMODE.ResourcesHud:MakePopup()
	GAMEMODE.CommandsHud:MakePopup()

	GAMEMODE.SkillsHud:SetKeyboardInputEnabled( false )
	GAMEMODE.ResourcesHud:SetKeyboardInputEnabled( false )
	GAMEMODE.CommandsHud:SetKeyboardInputEnabled( false )

	GAMEMODE.CommandsHud:SetVisible( true )
end

function GM:OnContextMenuClose()
	self.BaseClass.OnContextMenuClose( self )
	menubar.Control:SetVisible( false )

	GAMEMODE.SkillsHud:SetMouseInputEnabled( false )
	GAMEMODE.ResourcesHud:SetMouseInputEnabled( false )
	GAMEMODE.CommandsHud:SetMouseInputEnabled( false )

	GAMEMODE.CommandsHud:SetVisible( false )
end
