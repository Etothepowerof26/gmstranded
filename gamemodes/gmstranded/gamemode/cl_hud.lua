
surface.CreateFont( "DefaultSmall", { 
	font = "Tahoma",
	size = ScreenScale( 7 ),
	weight = 500
} )

surface.CreateFont( "DefaultHealth", { 
	font = "Tahoma",
	size = ScreenScale( 30 ),
	weight = 900
} )

function GM:DrawStrandedHUD()

	local w = ScrW() / 6
	local h = 4 * 12 + 10

	if ( self.SkillsHud ) then self.SkillsHud:SetPos( 0, h ) end

	surface.SetDrawColor( StrandedBackgroundColor )
	surface.DrawRect( 0, 0, w, h )

	surface.SetDrawColor( StrandedBorderColor )
	surface.DrawLine( w - 1, 0, w - 1, h ) -- Nice line instead of messy outlined rect
	surface.DrawLine( 0, h - 1, w, h - 1 )

	local width = w - 10

	//Health
	local hp_w = math.floor( ( LocalPlayer():Health() / 200 ) * width )
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawRect( 5, 5, width, 10 )

	surface.SetDrawColor( 176, 0, 0, 255 )
	surface.DrawRect( 5, 5, math.min( hp_w, width ), 10 )

	draw.SimpleTextOutlined( "Health", "DefaultSmall", w / 2, 9, StrandedTextColor, 1, 1, 0.5, StrandedTextShadowColor )

	//Hunger
	local hunger_w = math.floor( ( Hunger / 1000 ) * width )
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawRect( 5, 17, width, 10 )

	surface.SetDrawColor( 0, 176, 0, 255 )
	surface.DrawRect( 5, 17, hunger_w, 10 )

	draw.SimpleTextOutlined( "Hunger","DefaultSmall", w / 2, 21, StrandedTextColor, 1, 1, 0.5, StrandedTextShadowColor )

	//Thirst
	local thrst_w = math.floor( ( Thirst / 1000 ) * width )
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawRect( 5, 29, width, 10 )

	surface.SetDrawColor( 0, 0, 176, 255 )
	surface.DrawRect( 5, 29, thrst_w, 10 )

	draw.SimpleTextOutlined( "Thirst", "DefaultSmall", w / 2, 33, StrandedTextColor, 1, 1, 0.5, StrandedTextShadowColor )

	//Fatigue
	local sleep_w = math.floor( math.min( Sleepiness / 1000, 1000 ) * width )
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawRect( 5, 41, width, 10 )

	surface.SetDrawColor( 176, 0, 176, 255 )
	surface.DrawRect( 5, 41, sleep_w, 10 )

	draw.SimpleTextOutlined( "Fatigue", "DefaultSmall", w / 2, 45, StrandedTextColor, 1, 1, 0.5, StrandedTextShadowColor )
end

function GM:DrawStrandedHUD()
	local w = ScrW() / 12
	local h = ScrW() / 22
	local x = 5
	local y = ScrH() - h - 5

	local w_bar = ScrW() / 8
	local h_bar = ScrW() / 80
	local x_bar = x + w + 5
	local bar_spacing = ScrW() / 300

	surface.SetDrawColor( StrandedBackgroundColor )
	surface.DrawRect( x, y, w, h )

	surface.SetDrawColor( StrandedBorderColor )
	surface.DrawOutlinedRect( x, y, w, h )

	local hpColor = StrandedTextColor
	if ( LocalPlayer():Health() < 25 ) then hpColor = StrandedHealthColor end
	draw.SimpleTextOutlined( tostring( LocalPlayer():Health() ), "DefaultHealth", x + w / 2, y + h / 2, hpColor, 1, 1, 0.5, StrandedBorderColor )

	local bar_y = y + h / 2 - h_bar / 2 - h_bar - bar_spacing
	local hunger_w = math.floor( ( Hunger / 1000 ) * w_bar )
	surface.SetDrawColor( StrandedBackgroundColor )
	surface.DrawRect( x_bar, bar_y, w_bar, h_bar )

	surface.SetDrawColor( StrandedHungerColor )
	surface.DrawRect( x_bar, bar_y, hunger_w, h_bar )

	surface.SetDrawColor( StrandedBorderColor )
	surface.DrawOutlinedRect( x_bar, bar_y, w_bar, h_bar )

	draw.SimpleTextOutlined( "Hunger","DefaultSmall", x_bar + w_bar / 2, bar_y + h_bar / 2, StrandedTextColor, 1, 1, 0.5, StrandedTextShadowColor )

	local bar_y = y + h / 2 - h_bar / 2
	local thrst_w = math.floor( ( Thirst / 1000 ) * w_bar )
	surface.SetDrawColor( StrandedBackgroundColor )
	surface.DrawRect( x_bar, bar_y, w_bar, h_bar )

	surface.SetDrawColor( StrandedThirstColor )
	surface.DrawRect( x_bar, bar_y, thrst_w, h_bar )

	surface.SetDrawColor( StrandedBorderColor )
	surface.DrawOutlinedRect( x_bar, bar_y, w_bar, h_bar )

	draw.SimpleTextOutlined( "Thirst", "DefaultSmall", x_bar + w_bar / 2, bar_y + h_bar / 2, StrandedTextColor, 1, 1, 0.5, StrandedTextShadowColor )

	local bar_y = y + h / 2 - h_bar / 2 + h_bar + bar_spacing
	local sleep_w = math.floor( math.min( Sleepiness / 1000, 1000 ) * w_bar )
	surface.SetDrawColor( StrandedBackgroundColor )
	surface.DrawRect( x_bar, bar_y, w_bar, h_bar )

	surface.SetDrawColor( StrandedFatigueColor )
	surface.DrawRect( x_bar, bar_y, sleep_w, h_bar )

	surface.SetDrawColor( StrandedBorderColor )
	surface.DrawOutlinedRect( x_bar, bar_y, w_bar, h_bar )

	draw.SimpleTextOutlined( "Fatigue", "DefaultSmall", x_bar + w_bar / 2, bar_y + h_bar / 2, StrandedTextColor, 1, 1, 0.5, StrandedTextShadowColor )
end

function GM:DrawWristWatch()

	if ( GetConVarNumber( "gms_daynight" ) <= 0 || !Resources[ "Wrist_Watch" ] || Resources[ "Wrist_Watch" ] < 1 ) then return end

	local w = ScrW() / 12
	local h = ScrH() / 25
	local x = 5//ScrW() - ScrH() / 16 - w
	local y = ScrH() - ScrW() / 22 - 10 - h //ScrH() / 16

	surface.SetDrawColor( StrandedBackgroundColor )
	surface.DrawRect( x, y, w, h )

	surface.SetDrawColor( StrandedBorderColor )
	surface.DrawOutlinedRect( x, y, w, h )

	local hours = os.date( "%M", Time )
	local mins = os.date( "%S", Time )
	draw.SimpleTextOutlined( hours .. ":" .. mins, "ScoreboardSub", x + w / 2, y + h / 2, StrandedTextColor, 1, 1, 0.5, StrandedTextShadowColor )

end

function GM:DrawOxygenBar()

	if ( Oxygen >= 1000 ) then return end

	local w = ScrW() / 5
	local h = ScrH() / 48
	local x = ScrW() / 2 - w / 2
	local y = ScrH() / 6 

	surface.SetDrawColor( StrandedBackgroundColor )
	surface.DrawRect( x, y, w, h )

	surface.SetDrawColor( StrandedOxygenColor )
	surface.DrawRect( x, y, math.min( math.floor( math.min( Oxygen / 1000, 1000 ) * w ), w ), h )

	surface.SetDrawColor( StrandedBorderColor )
	surface.DrawOutlinedRect( x, y, w, h )

	draw.SimpleTextOutlined( "Oxygen", "DefaultSmall", x + w / 2, y + h / 2, StrandedTextColor, 1, 1, 0.5, StrandedTextShadowColor )

end

function GM:DrawPowerBar()

	if ( !Resources[ "Flashlight" ] or Resources[ "Flashlight" ] < 1 ) then return end

	local maxPower = 50
	if ( Resources[ "Batteries" ] ) then maxPower = math.min( maxPower + Resources[ "Batteries" ] * 50, 500 ) end

	if ( Power >= maxPower ) then return end

	local w = ScrW() / 6
	local h = ScrH() / 48
	local x = ScrW() / 2 - w / 2
	local y = ScrH() - ScrH() / 16 - h * 2

	surface.SetDrawColor( StrandedBackgroundColor )
	surface.DrawRect( x, y, w, h )

	surface.SetDrawColor( StrandedPowerColor )
	surface.DrawRect( x, y, math.min( math.floor( math.min( Power / maxPower, maxPower ) * w ), w ), h )

	surface.SetDrawColor( StrandedBorderColor )
	surface.DrawOutlinedRect( x, y, w, h )

	draw.SimpleTextOutlined( "Flashlight Power", "DefaultSmall", x + w / 2, y + h / 2.5, StrandedTextColor, 1, 1, 0.5, StrandedTextShadowColor )

end

function GM:DrawProcessBar()
	if ( !ProcessCompleteTime ) then return end

	local w = ScrW() / 3.2
	local h = ScrH() / 30
	local x = ScrW() / 2 - w / 2
	local y = ScrH() / 8

	local width = math.min( ( CurTime() - ProcessStart ) / ProcessCompleteTime * w, w )
	if ( width > w ) then GAMEMODE.StopProgressBar() end

	surface.SetDrawColor( StrandedBackgroundColor )
	surface.DrawRect( x, y, w, h )

	surface.SetDrawColor( StrandedForegroundColor )
	surface.DrawRect( x, y, width, h )

	surface.SetDrawColor( StrandedBorderColor )
	surface.DrawOutlinedRect( x, y, w, h )

	local txt = CurrentProcess
	if ( ProcessCancelAble ) then txt = txt .. " ( F4 to Cancel )" end

	draw.SimpleText( txt, "ScoreboardText", x + w / 2, y + h / 2, StrandedTextColor, 1, 1 )

end

function GM:HUDDrawTargetID()
	local tr = util.GetPlayerTrace( LocalPlayer() )
	local trace = util.TraceLine( tr )
	if (!trace.Hit) then return end
	if (!trace.HitNonWorld) then return end

	local text = "ERROR"
	local font = "TargetID"

	if (trace.Entity:IsPlayer()) then
		text = trace.Entity:Nick()
	else
		return
	end

	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )

	local MouseX, MouseY = gui.MousePos()

	if ( MouseX == 0 && MouseY == 0 ) then
		MouseX = ScrW() / 2
		MouseY = ScrH() / 2
	end

	local x = MouseX
	local y = MouseY

	x = x - w / 2
	y = y + 30

	-- The fonts internal drop shadow looks lousy with AA on
	draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,120) )
	draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,50) )
	draw.SimpleText( text, font, x, y, self:GetTeamColor( trace.Entity ) )

	y = y + h

	local text = trace.Entity:Team()
	local font = "TargetIDSmall"
	
	for id, tabl in pairs( Tribes ) do
		if ( id == text ) then text = tabl.name end
	end

	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )
	local x =  MouseX - w / 2

	draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,120) )
	draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,50) )
	draw.SimpleText( text, font, x, y, self:GetTeamColor( trace.Entity ) )

	y = y + h + 5

	local text = trace.Entity:Health() .. "%"
	local font = "TargetIDSmall"

	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )
	local x =  MouseX - w / 2

	draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,120) )
	draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,50) )
	draw.SimpleText( text, font, x, y, self:GetTeamColor( trace.Entity ) )
end

function GM:DrawResourceDropsHUD()
	local ply = LocalPlayer()
	local str = nil
	local draw_loc = nil
	local w, h = nil, nil
	local tr = nil
	local cent = nil
	local pos = ply:GetShootPos()

	for _, v in ipairs( ents.GetAll() ) do
		if ( !IsValid( v ) ) then continue end
		local class = v:GetClass()

		if ( class == "gms_resourcedrop" ) then
			cent = v:LocalToWorld( v:OBBCenter() )

			tr = {
				start = pos,
				endpos = cent,
				filter = ply
			}

			if ( ( cent - pos ):Length() <= 200 && util.TraceLine( tr ).Entity == v ) then
				str = ( v.Res or "Loading" ) .. ": " .. tostring( v.Amount or 0 )
				draw_loc = cent:ToScreen()
				surface.SetFont( "ChatFont" )
				w, h = surface.GetTextSize( str )
 				draw.RoundedBox( 4, draw_loc.x - ( w / 2 ) - 3, draw_loc.y - ( h / 2 ) - 3, w + 6, h + 6, Color( 50, 50, 50, 200 ) )
				surface.SetTextColor( 255, 255, 255, 200 )
				surface.SetTextPos( draw_loc.x - ( w / 2 ), draw_loc.y -( h / 2 ) )
				surface.DrawText( str )
			end
			continue
		end

		if ( class == "gms_resourcepack" or class == "gms_fridge" ) then
			cent = v:LocalToWorld( v:OBBCenter() )

			tr = {
				start = pos,
				endpos = cent,
				filter = ply
			}

			if ( ( cent - pos ):Length() <= 200 and util.TraceLine( tr ).Entity == v ) then
				draw_loc = cent:ToScreen()
				surface.SetFont( "ChatFont" )
				str = "Resource pack"
				if ( class == "gms_fridge" ) then str = "Fridge" end
				for res, num in pairs( v.Resources or {} ) do
					str = str .. "\n" .. res .. ": " .. num
				end
				w, h = surface.GetTextSize( str )
 				draw.RoundedBox( 4, draw_loc.x - ( w / 2 ) - 3, draw_loc.y - ( h / 2 ) - 3, w + 6, h + 6, Color( 50, 50, 50, 200 ) )
				surface.SetTextColor( 255, 255, 255, 200 )
				for id, st in pairs( string.Explode( "\n", str ) ) do
					id = id - 1
					w2, h2 = surface.GetTextSize( st )
					surface.SetTextPos( draw_loc.x - ( w / 2 ), draw_loc.y - ( h / 2 ) + ( id * h2 ) )
					surface.DrawText( st )
				end
			end
			continue
		end

		if ( table.HasValue( GMS.StructureEntities, class ) ) then
			cent = v:LocalToWorld( v:OBBCenter() )
			local minimum = v:LocalToWorld( v:OBBMins() )
			local maximum = v:LocalToWorld( v:OBBMaxs() )
			local distance = ( maximum - minimum ):Length()
			if ( distance < 200 ) then distance = 200 end

			tr2 = {}
			tr2.start = pos
			tr2.endpos = Vector( cent.x, cent.y, pos.z )
			tr2.filter = ply

			if ( ( cent - pos ):Length() <= distance and ( util.TraceLine( tr2 ).Entity == v or !util.TraceLine( tr2 ).Hit ) ) then
				str = language.GetPhrase( class ) -- ( v:GetNWString( "Name" ) or "Loading" )
				if ( class == "gms_buildsite" ) then
					str = v:GetNWString( "Name" ) .. v:GetNWString( "Resources" )
				end

				draw_loc = cent:ToScreen()
				surface.SetFont( "ChatFont" )
				w, h = surface.GetTextSize( str )
 				draw.RoundedBox( 4, draw_loc.x - ( w / 2 ) - 3, draw_loc.y - ( h / 2 ) - 3, w + 6, h + 6, Color( 50, 50, 50, 200 ) )
				surface.SetTextColor( Color( 255, 255, 255, 200 ) )

				local strs = string.Explode( "\n", str )
				for id, str in pairs( strs ) do
					surface.SetTextPos( draw_loc.x - ( w / 2 ), draw_loc.y - ( h / 2 ) + ( id - 1 ) * 15 )
					surface.DrawText( str )
				end
			end
		end
	end
end


function GM:HUDPaint()
	self.BaseClass:HUDPaint()
	self:DrawResourceDropsHUD()

	self:DrawStrandedHUD()
	self:DrawWristWatch()
	self:DrawProcessBar()
	self:DrawOxygenBar()
	self:DrawPowerBar()
end

function GM:HUDShouldDraw( name )
	if ( name != "CHudHealth" && name != "CHudBattery" ) then
		return true
	end
end
