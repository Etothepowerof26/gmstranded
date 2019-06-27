
-- Send clientside files
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_scoreboard.lua" )
AddCSLuaFile( "cl_qmenu.lua" )
AddCSLuaFile( "cl_panels.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "unlocks.lua" )
AddCSLuaFile( "combinations.lua" )
AddCSLuaFile( "time_weather.lua" )

include( "shared.lua" )
include( "processes.lua" )
include( "chatcommands.lua" )
-- include( "resources.lua" )

--Vars
GM.NextSaved = 0
GM.NextLoaded = 0

--Locals
local PlayerMeta = FindMetaTable( "Player" )
local EntityMeta = FindMetaTable( "Entity" )

--Tribes table
if ( !GM.Tribes ) then
	GM.Tribes = GM.Tribes or {}
	table.insert( GM.Tribes, { name = "The Stranded", color = Color( 200, 200, 0 ), password = false } )
	table.insert( GM.Tribes, { name = "Survivalists", color = Color( 225, 225, 225 ), password = false } )
	table.insert( GM.Tribes, { name = "Anonymous", color = Color( 0, 145, 145 ), password = false } )
	table.insert( GM.Tribes, { name = "The Gummies", color = Color( 255, 23, 0 ), password = false } )
	table.insert( GM.Tribes, { name = "The Dynamics", color = Color( 0, 72, 255 ), password = false } )
	table.insert( GM.Tribes, { name = "Scavengers", color = Color( 8, 255, 0 ), password = false } )
end

GM.AntlionBarrowSpawns = {}
GM.AntlionBarrowSpawns[ "gm_construct" ] = { Vector( -4321.8149, -2551.3449, 257.5130 ) }
GM.AntlionBarrowSpawns[ "gms_rollinghills" ] = { Vector( 3131.2876, -980.5972, 519.5605 ), Vector( -4225.0200, 6009.3516, 513.1411 ) }
GM.AntlionBarrowSpawns[ "gms_rollinghills_daynight" ] = GM.AntlionBarrowSpawns[ "gms_rollinghills" ]
GM.AntlionBarrowSpawns[ "gms_rollinghills_daynight_b1" ] = GM.AntlionBarrowSpawns[ "gms_rollinghills" ]

GM.AntlionBarrowSpawns[ "gms_nowhere2" ] = { Vector( 3918.7753, 5111.8149, 7.5218 ), Vector( -2061.3061, 4842.8325, 7.6148 ) }
GM.AntlionBarrowSpawns[ "gms_minisurvival_v2" ] = { Vector( -2818.7075, 3132.7507, -529.3529 ), Vector( -1423.5445, -1801.8461, -521.4026 ) }

-- Custom anlion barrow auto placement
hook.Add( "InitPostEntity", "gms_custom_antspawns", function()
	if ( !GAMEMODE.AntlionBarrowSpawns[ game.GetMap() ] ) then return end
	for id, pos in pairs( GAMEMODE.AntlionBarrowSpawns[ game.GetMap() ] ) do
		local ent = ents.Create( "gms_antlionbarrow" )
		ent:SetPos( pos )
		ent:Spawn()
		ent.GMSAutoSpawned = true
		ent:SetNetworkedString( "Owner", "World" )
	end
end )

-- Find tribe by ID
function GM.FindTribeByID( id )
	for tid, tabl in pairs( GAMEMODE.Tribes ) do
		if ( tid == id ) then return tabl end
	end
	return false
end

-- Cancel process
concommand.Add( "gms_cancelprocess", function( ply, cmd, args ) ply:CancelProcess() end )

/* Menu toggles */
function GM:ShowHelp( ply ) end
function GM:ShowTeam( ply ) end
function GM:ShowSpare1( ply ) end

function GM:ShowSpare2( ply )
	if ( ply:GetNWBool( "AFK" ) ) then
		GAMEMODE.AFK( ply, "gms_afk", {} )
	elseif ( ply:GetNWBool( "Sleeping" ) ) then
		ply:Wakeup()
	end
	ply:CancelProcess()
end


/* ----------------------------------------------------------------------------------------------------
	Player Functions
---------------------------------------------------------------------------------------------------- */

function PlayerMeta:SendMessage( text, duration, color )
	if ( !IsValid( self ) ) then return end
	local duration = duration or 3
	local color = color or color_white

	umsg.Start( "gms_sendmessage", self )
		umsg.String( text )
		umsg.Short( duration )
		umsg.String( color.r .. "," .. color.g .. "," .. color.b .. "," .. color.a )
	umsg.End()
end

function PlayerMeta:OpenCombiMenu( str )
	umsg.Start( "gms_OpenCombiMenu", self )
		umsg.String( str )
	umsg.End()
end

function PlayerMeta:SendAchievement( text )
	umsg.Start( "gms_sendachievement", self )
		umsg.String( text )
	umsg.End()

	local sound = CreateSound( self, Sound( "music/hl1_song11.mp3" ) )
	sound:Play()
	timer.Simple( 5.5, function() sound:Stop() end )
end

function PlayerMeta:SetSkill( skill, int )
	skill = string.Capitalize( skill )
	if ( !self.Skills[ skill ] ) then self.Skills[ skill ] = 0 end

	if ( skill != "Survival" ) then
		int = math.Clamp( int, 0, 200 )
	else
		self.MaxResources = ( int * 5 ) + 25
	end
	self.Skills[ skill ] = int

	umsg.Start( "gms_SetSkill", self )
		umsg.String( skill )
		umsg.Short( self:GetSkill( skill ) )
	umsg.End()
end

function PlayerMeta:GetSkill( skill )
	skill = string.Capitalize( skill )
	if ( skill == "Survival" ) then self:SetNWInt( skill, self.Skills[skill] ) end
	return self.Skills[ skill ] or 0
end

function PlayerMeta:IncSkill( skill, int )
	skill = string.Capitalize( skill )
	if ( !self.Skills[ skill ] ) then self:SetSkill( skill, 0 ) end
	if ( !self.Experience[ skill ] ) then self:SetXP( skill, 0 ) end

	if ( skill != "Survival" ) then
		int = math.Clamp( int, 0, 200 )
		for id = 1, int do self:IncXP( "Survival", 20 ) end
		self:SendMessage( string.Replace( skill, "_", " " ) .. " +" .. int, 3, Color( 10, 200, 10, 255 ) )
	else
		self.MaxResources = self.MaxResources + 5
		self:SendAchievement( "Level Up!" )
	end

	self.Skills[skill] = self.Skills[skill] + int

	umsg.Start( "gms_SetSkill", self )
	umsg.String( skill )
	umsg.Short( self:GetSkill( skill ) )
	umsg.End()

	self:CheckForUnlocks()
end

function PlayerMeta:DecSkill( skill, int )
	skill = string.Capitalize( skill )
	self.Skills[skill] = math.max( self.Skills[skill] - int, 0 )

	umsg.Start( "gms_SetSkill", self )
		umsg.String( skill )
		umsg.Short( self:GetSkill( skill ) )
	umsg.End()
end

function PlayerMeta:SetXP( skill, int )
	skill = string.Capitalize( skill )
	if ( !self.Skills[skill] ) then self:SetSkill( skill, 0 ) end
	if ( !self.Experience[skill] ) then self.Experience[skill] = 0 end

	self.Experience[skill] = int

	umsg.Start( "gms_SetXP", self )
		umsg.String( skill )
		umsg.Short( self:GetXP( skill ) )
	umsg.End()
end

function PlayerMeta:GetXP( skill )
	skill = string.Capitalize( skill )
	return self.Experience[skill] or 0
end

function PlayerMeta:IncXP( skill, int )
	skill = string.Capitalize( skill )
	if ( !self.Skills[skill] ) then self.Skills[skill] = 0 end
	if ( !self.Experience[skill] ) then self.Experience[skill] = 0 end

	if ( self.Experience[skill] + int >= 100 ) then
		self.Experience[skill] = 0
		self:IncSkill( skill, 1 )
	else
		self.Experience[skill] = self.Experience[skill] + int
	end

	umsg.Start( "gms_SetXP", self )
		umsg.String( skill )
		umsg.Short( self:GetXP( skill ) )
	umsg.End()
end

function PlayerMeta:DecXP( skill, int )
	skill = string.Capitalize( skill )
	self.Experience[skill] = self.Experience[skill] - int

	umsg.Start( "gms_SetXP", self )
		umsg.String( skill )
		umsg.Short( self:GetXP( skill ) )
	umsg.End()
end

function PlayerMeta:SetResource( resource, int )
	resource = string.Capitalize( resource )
	if ( !self.Resources[resource] ) then self.Resources[resource] = 0 end
	

	self.Resources[resource] = int

	umsg.Start( "gms_SetResource", self )
		umsg.String( resource )
		umsg.Short( int )
	umsg.End()
end

function PlayerMeta:GetResource( resource )
	resource = string.Capitalize( resource )
	return self.Resources[ resource ] or 0
end

function PlayerMeta:IncResource( resource, int )
	resource = string.Capitalize( resource )

	if ( !self.Resources[resource] ) then self.Resources[resource] = 0 end
	local all = self:GetAllResources()
	local max = self.MaxResources

	if ( all + int > max ) then
		self.Resources[resource] = self.Resources[resource] + ( max - all )
		self:DropResource( resource, ( all + int ) - max )
		self:SendMessage( "You can't carry anymore!", 3, Color( 200, 0, 0, 255 ) )
	else
		self.Resources[resource] = self.Resources[resource] + int
	end

	umsg.Start( "gms_SetResource", self )
		umsg.String( resource )
		umsg.Short( self:GetResource( resource ) )
	umsg.End()
end

function PlayerMeta:DecResource( resource, int )
	if ( !self.Resources[resource] ) then self.Resources[resource] = 0 end
	self.Resources[resource] = self.Resources[resource] - int

	local r = self.Resources[resource]
	if ( resource == "Flashlight" and r < 1 ) then self:Flashlight( false ) end
	if ( resource == "Batteries" ) then
		local maxPow = 50
		if ( r ) then maxPow = math.min( maxPow + r * 50, 500 ) end
		self.Power = math.min( self.Power, maxPow )
		self:UpdateNeeds()
	end
	
	umsg.Start( "gms_SetResource", self )
		umsg.String( resource )
		umsg.Short( self:GetResource( resource ) )
	umsg.End()
end

function PlayerMeta:GetAllResources()
	local num = 0

	for k, v in pairs( self.Resources ) do
		num = num + v
	end

	return num
end

function PlayerMeta:CreateBuildingSite( pos, angle, model, class, cost )
	local rep = ents.Create( "gms_buildsite" )
	rep:SetPos( pos )
	rep:SetAngles( angle )
	rep.Costs = cost
	rep:Setup( model, class )
	rep:Spawn()

	rep.Player = self
	rep.OwnerTable = { Team = self:Team(), SteamID = self:SteamID(), Name = self:Name(), EntIndex = self:EntIndex() }

	self:SetNetworkedEntity( "Hasbuildingsite", rep )

	SPropProtection.PlayerMakePropOwner( self , rep )
	return rep
end

local NoDropModels = {
	"models/props_c17/furniturefireplace001a.mdl",
	"models/props_c17/factorymachine01.mdl",
	"models/Gibs/airboat_broken_engine.mdl",
	"models/props_c17/furniturestove001a.mdl",
	"models/props_wasteland/controlroom_desk001b.mdl",
	"models/props_c17/FurnitureFridge001a.mdl",
	"models/props_lab/reciever_cart.mdl",
	"models/props_trainstation/trainstation_clock001.mdl"
}

function PlayerMeta:CreateStructureBuildingSite( pos, angle, model, class, cost, name )
	local rep = ents.Create( "gms_buildsite" )
	local str = ":"
	for k, v in pairs( cost ) do
		str = str .. "\n" .. string.Replace( k, "_", " " ) .. " ( " .. v .. "x )"
	end

	rep:SetAngles( angle )
	rep.Costs = cost
	rep:Setup( model, class )
	rep:SetPos( pos )
	rep.Name = name
	rep:SetNWString( "Name", name )
	rep:SetNWString( "Resources", str )
	rep:Spawn()

	local cormin, cormax = rep:WorldSpaceAABB()
	local offset = cormax - cormin

	if ( model == "models/props_c17/FurnitureFridge001a.mdl" ) then pos = pos + Vector( 0, 0, 10 ) end
	rep:SetPos( Vector( pos.x, pos.y, pos.z + ( offset.z / 2 ) ) )
	if ( !table.HasValue( NoDropModels, model )  ) then
		rep:DropToGround()
	end

	self:SetNWEntity( "Hasbuildingsite", rep )
	rep.Player = self
	rep.OwnerTable = { Team = self:Team(), SteamID = self:SteamID(), Name = self:Name(), EntIndex = self:EntIndex() }
	SPropProtection.PlayerMakePropOwner( self, rep )
	return rep
end

function PlayerMeta:GetBuildingSite()
	return self:GetNWEntity( "Hasbuildingsite" )
end

function PlayerMeta:DropResource( resource, int )
	local nearby = {}

	for k, v in pairs( ents.FindByClass( "gms_resource*" ) ) do
		if ( v:GetPos():Distance( self:GetPos() ) < 150 ) then
			if ( v:GetClass() == "gms_resourcedrop" and v.Type != resource ) then
			else
				table.insert( nearby, v )
			end
		end
	end

	for id, ent in pairs( nearby ) do
		if ( !SPropProtection.PlayerCanTouch( self, ent ) ) then continue end
		if ( ent:GetClass() == "gms_resourcedrop" ) then
			ent.Amount = ent.Amount + int
			ent:SetResourceDropInfoInstant( ent.Type, ent.Amount )
			return
		else
			if ( !ent.Resources ) then ent.Resources = {} end

			if ( ent.Resources[ resource ] ) then
				ent.Resources[ resource ] = ent.Resources[ resource ] + int
			else
				ent.Resources[ resource ] = int
			end

			ent:SetResPackInfo( resource, ent.Resources[ resource ] )
			return
		end
	end

	local ent = ents.Create( "gms_resourcedrop" )
	ent:SetPos( self:TraceFromEyes( 60 ).HitPos + Vector( 0, 0, 15 ) )
	ent:SetAngles( self:GetAngles() )
	ent:Spawn()

	ent:GetPhysicsObject():Wake()

	ent.Type = resource
	ent.Amount = int

	ent:SetResourceDropInfo( ent.Type, ent.Amount )
	SPropProtection.PlayerMakePropOwner( self, ent )
end

function PlayerMeta:SetFood( int )
	if ( int > 1000 ) then
		int = 1000
	end

	self.Hunger = int
	self:UpdateNeeds()
end

function PlayerMeta:SetThirst( int )
	if ( int > 1000 ) then
		int = 1000
	end

	self.Thirst = int
	self:UpdateNeeds()
end

function PlayerMeta:Heal( int )
	self:SetHealth( math.min( self:Health() + int, self:GetMaxHealth() ) )
end

function PlayerMeta:AddUnlock( text )
	self.FeatureUnlocks[text] = 1

	umsg.Start( "gms_AddUnlock", self )
		umsg.String( text )
	umsg.End()

	if ( GMS.FeatureUnlocks[text].OnUnlock ) then GMS.FeatureUnlocks[text].OnUnlock( self ) end
end

function PlayerMeta:HasUnlock( text )
	if ( self.FeatureUnlocks and self.FeatureUnlocks[text] ) then return true end
	return false
end

function PlayerMeta:CheckForUnlocks()
	for k, unlock in pairs( GMS.FeatureUnlocks ) do
		if ( !self:HasUnlock( k ) ) then
			local NrReqs = 0

			for skill, value in pairs( unlock.Req ) do
				if ( self:GetSkill( skill ) >= value ) then
					NrReqs = NrReqs + 1
				end
			end

			if ( NrReqs == table.Count( unlock.Req ) ) then
				self:AddUnlock( k )
			end
		end
	end
end

function PlayerMeta:TraceFromEyes( dist )
	return util.TraceLine( {
		start = self:GetShootPos(),
		endpos = self:GetShootPos() + ( self:GetAimVector() * dist ),
		filter = self
	} )
end

function PlayerMeta:UpdateNeeds()
	umsg.Start( "gms_setneeds", self )
		umsg.Short( self.Sleepiness )
		umsg.Short( self.Hunger )
		umsg.Short( self.Thirst )
		umsg.Short( self.Oxygen )
		umsg.Short( self.Power )
		umsg.Short( Time )
	umsg.End()
end

function PlayerMeta:PickupResourceEntity( ent )
	if ( !SPropProtection.PlayerCanTouch( self, ent ) ) then return end

	local int = ent.Amount
	local room = self.MaxResources - self:GetAllResources()

	if ( room <= 0 ) then self:SendMessage( "You can't carry anymore!", 3, Color( 200, 0, 0, 255 ) ) return end
	if ( room < int ) then int = room end
	ent.Amount = ent.Amount - int
	if ( ent.Amount <= 0 ) then ent:Fadeout() else ent:SetResourceDropInfo( ent.Type, ent.Amount ) end

	self:IncResource( ent.Type, int )
	self:SendMessage( "Picked up " .. string.Replace( ent.Type, "_", " " ) .. " ( " .. int .. "x )", 4, Color( 10, 200, 10, 255 ) )
end

function PlayerMeta:PickupResourceEntityPack( ent )
	if ( !SPropProtection.PlayerCanTouch( self, ent ) ) then return end

	if ( table.Count( ent.Resources ) > 0 ) then
		for res, int in pairs( ent.Resources ) do
			local room = self.MaxResources - self:GetAllResources()

			if ( room <= 0 ) then self:SendMessage( "You can't carry anymore!", 3, Color( 200, 0, 0, 255 ) ) return end
			if ( room < int ) then int = room end
			ent.Resources[res] = ent.Resources[res] - int

			ent:SetResPackInfo( res, ent.Resources[res] )
			if ( ent.Resources[res] <= 0 ) then ent.Resources[res] = nil end

			self:IncResource( res, int )
			self:SendMessage( "Picked up " .. string.Replace( res, "_", " " ) .. " ( " .. int .. "x )", 4, Color( 10, 200, 10, 255 ) )
		end
	end
end

function PlayerMeta:MakeLoadingBar( msg )
	umsg.Start( "gms_MakeLoadingBar", self )
		umsg.String( msg )
	umsg.End()
end

function PlayerMeta:StopLoadingBar()
	umsg.Start( "gms_StopLoadingBar",self )
	umsg.End()
end

function PlayerMeta:MakeSavingBar( msg )
	umsg.Start( "gms_MakeSavingBar", self )
		umsg.String( msg )
	umsg.End()
end

function PlayerMeta:StopSavingBar()
	umsg.Start( "gms_StopSavingBar", self )
	umsg.End()
end

function PlayerMeta:AllSmelt( ResourceTable )
	local resourcedata = {}
	resourcedata.Req = {}
	resourcedata.Results = {}
	local AmountReq = 0
	for k, v in pairs( ResourceTable.Req ) do
		if ( self:GetResource( k ) > 0 ) then
			if ( self:GetResource( k ) <= ResourceTable.Max ) then
				resourcedata.Req[k] = self:GetResource( k )
				AmountReq = AmountReq + self:GetResource( k )
			else
				resourcedata.Req[k] = ResourceTable.Max
				AmountReq = AmountReq + ResourceTable.Max
				self:SendMessage( "You can only do " .. tostring( ResourceTable.Max ) .. " " .. string.Replace( k, "_", " " ) .. " at a time.", 3, Color( 200, 0, 0, 255 ) )
			end
		else
			resourcedata.Req[k] = 1
		end
	end
	for k, v in pairs( ResourceTable.Results ) do
		resourcedata.Results[k] = AmountReq
	end
	return resourcedata
end

function PlayerMeta:Sleep()
	if ( !self:Alive() or self:GetNWBool( "Sleeping" ) or self:GetNWBool( "AFK" ) ) then return end
	if ( self.Sleepiness > 700 ) then self:SendMessage( "You're not tired enough.", 3, Color( 255, 255, 255, 255 ) ) return end

	self:SetNWBool( "Sleeping", true )
	self:Freeze( true )

	-- Check for shelter
	local tr = util.TraceLine( {
		start = self:GetShootPos(),
		endpos = self:GetShootPos() + ( self:GetUp() * 300 ),
		filter = self
	} )

	self.NeedShelter = false
	if ( !tr.HitWorld and !tr.HitNonWorld ) then
		self.NeedShelter = true
	end
	
	self:EmitSound( "stranded/start_sleeping.wav" )
end

function PlayerMeta:Wakeup()
	if ( !self:GetNWBool( "Sleeping" ) ) then return end
	self:SetNWBool( "Sleeping", false )
	self:Freeze( false )

	--Check for shelter
	local trace = {}
	trace.start = self:GetShootPos()
	trace.endpos = trace.start + ( self:GetUp() * 300 )
	trace.filter = self

	local tr = util.TraceLine( trace )

	if ( self.NeedShelter ) then
		self:SendMessage( "I should get something to sleep under next time...", 6, Color( 200, 0, 0, 255 ) )
	else
		self:SendMessage( "Ah, nothing like a good nights sleep!", 5, Color( 255, 255, 255, 255 ) )
	end
end

/* ----------------------------------------------------------------------------------------------------
	Entity Functions
---------------------------------------------------------------------------------------------------- */

function EntityMeta:SetResourceDropInfo( strType, int )
	timer.Simple( 0.5, function() self:SetResourceDropInfoInstant( strType, int ) end )
end

function EntityMeta:SetResourceDropInfoInstant( strType, int )
	for k, v in pairs( player.GetAll() ) do
		local strType = strType or "Error"
		umsg.Start( "gms_SetResourceDropInfo", v )
		umsg.String( self:EntIndex() )
		umsg.String( string.gsub( strType, "_", " " ) )
		umsg.Short( self.Amount )
		umsg.End()
	end
end

function EntityMeta:SetResPackInfo( strType, int )
	for k, v in pairs( player.GetAll() ) do
		local strType = strType or "Error"
		umsg.Start( "gms_SetResPackInfo", v )
		umsg.String( self:EntIndex() )
		umsg.String( string.gsub( strType, "_", " " ) )
		umsg.Short( int )
		umsg.End()
	end
end


function EntityMeta:SetFoodInfo( strType )
	timer.Simple( 0.5, function() self:SetFoodInfoInstant( strType ) end )
end

function EntityMeta:SetFoodInfoInstant( strType )
	for k, v in pairs( player.GetAll() ) do
		local strType = strType or "Error"
		umsg.Start( "gms_SetFoodDropInfo", v )
			umsg.String( self:EntIndex() )
			umsg.String( string.gsub( strType, "_", " " ) )
		umsg.End()
	end
end

function EntityMeta:DropToGround()
	local trace = {}
	trace.start = self:GetPos()
	trace.endpos = trace.start + Vector( 0, 0, -100000 )
	trace.mask = MASK_SOLID_BRUSHONLY
	trace.filter = self

	local tr = util.TraceLine( trace )

	self:SetPos( tr.HitPos )
end

function GM.ReproduceTrees()
	local GM = GAMEMODE
	if ( GetConVarNumber( "gms_ReproduceTrees" ) == 1 ) then
		local trees = {}
		for k, v in pairs( ents.GetAll() ) do
			if ( v:IsTreeModel() ) then
				table.insert( trees, v )
			end
		end

		if ( #trees < GetConVarNumber( "gms_MaxReproducedTrees" ) ) then
			for k, ent in pairs( trees ) do
				local num = math.random( 1, 3 )

				if ( num == 1 ) then
					local nearby = {}
					for k, v in pairs( ents.FindInSphere( ent:GetPos(), 50 ) ) do
						if ( v:GetClass() == "gms_seed" or v:IsProp() ) then
							table.insert( nearby, v )
						end
					end

					if ( #nearby < 3 ) then
						local pos = ent:GetPos() + Vector( math.random( -500, 500 ), math.random( -500, 500 ), 0 )
						local retries = 50

						while ( ( pos:Distance( ent:GetPos() ) < 200 or GMS.ClassIsNearby( pos, "prop_physics", 100 ) ) and retries > 0 ) do
							pos = ent:GetPos() + Vector( math.random( -300, 300 ),math.random( -300, 300 ), 0 )
							retries = retries - 1
						end

						local pos = pos + Vector( 0, 0, 500 )

						local seed = ents.Create( "gms_seed" )
						seed:SetPos( pos )
						seed:DropToGround()
						seed:Setup( "tree", 180 )
						seed:SetNetworkedString( "Owner", "World" )
						seed:Spawn()
					end
				end
			end
		end
		if ( #trees == 0 ) then
			local info = {}
			for i = 1, 20 do
				info.pos = Vector( math.random( -10000, 10000 ), math.random( -10000, 10000 ), 1000 )
				info.Retries = 50

				--Find pos in world
				while ( util.IsInWorld( info.pos ) == false and info.Retries > 0 ) do
					info.pos = Vector( math.random( -10000, 10000 ),math.random( -10000, 10000 ), 1000 )
					info.Retries = info.Retries - 1
				end

				--Find ground
				local trace = {}
				trace.start = info.pos
				trace.endpos = trace.start + Vector( 0, 0, -100000 )
				trace.mask = MASK_SOLID_BRUSHONLY

				local groundtrace = util.TraceLine( trace )

				--Assure space
				local nearby = ents.FindInSphere( groundtrace.HitPos, 200 )
				info.HasSpace = true

				for k, v in pairs( nearby ) do
					if ( v:IsProp() ) then
						info.HasSpace = false
					end
				end

				--Find sky
				local trace = {}
				trace.start = groundtrace.HitPos
				trace.endpos = trace.start + Vector( 0, 0, 100000 )

				local skytrace = util.TraceLine( trace )

				--Find water?
				local trace = {}
				trace.start = groundtrace.HitPos
				trace.endpos = trace.start + Vector( 0, 0, 1 )
				trace.mask = MASK_WATER

				local watertrace = util.TraceLine( trace )

				--All a go, make entity
				if ( info.HasSpace and skytrace.HitSky and !watertrace.Hit and ( groundtrace.MatType == MAT_DIRT or groundtrace.MatType == MAT_GRASS or groundtrace.MatType == MAT_SAND ) ) then
					local seed = ents.Create( "gms_seed" )
					seed:SetPos( groundtrace.HitPos )
					seed:DropToGround()
					seed:Setup( "tree", 180 + math.random( -20, 20 ) )
					seed:SetNetworkedString( "Owner", "World" )
					seed:Spawn()
				end
			end
		end
	end

	timer.Simple( math.random( 1, 3 ) * 60, function() GM.ReproduceTrees() end )
end
timer.Simple( 60, function() GAMEMODE.ReproduceTrees() end )

GMS.LootableNPCs = { "npc_antlion", "npc_antlionguard", "npc_crow", "npc_seagull", "npc_pigeon", "npc_zombie" }

function EntityMeta:IsLootableNPC()
	return table.HasValue( GMS.LootableNPCs, self:GetClass() )
end

function EntityMeta:MakeCampfire()
	if ( GetConVarNumber( "gms_campfire" ) <= 0 ) then return end

	local min, max = self:OBBMins(), self:OBBMaxs()
	local vol = math.abs( max.x - min.x ) * math.abs( max.y - min.y ) * math.abs( max.z - min.z )
	local mul = math.min( math.sqrt( vol ) / 200, 1 )

	if ( !self.CampFire ) then self:SetHealth( 1337 ) end
	self.CampFire = true

	timer.Create( "gms_removecampfire_" .. self:EntIndex(), 480 * mul, 1, function() if ( IsValid( self ) ) then self:Fadeout() end end )

	if ( GetConVarNumber( "gms_SpreadFire" ) >= 1 ) then
		self:Ignite( 360, ( self:OBBMins() - self:OBBMaxs() ):Length() + 10 )
	else
		self:Ignite( 360, 0.001 )
	end
end

/* ----------------------------------------------------------------------------------------------------
	Entity Fading
---------------------------------------------------------------------------------------------------- */

GMS.FadingOutProps = {}
GMS.FadingInProps = {}

function EntityMeta:Fadeout( speed )
	if ( !IsValid( self ) ) then return end
	local speed = speed or 1

	for k, v in pairs( player.GetAll() ) do
		umsg.Start( "gms_CreateFadingProp", v )
			umsg.String( self:GetModel() )
			umsg.Vector( self:GetPos() )
			local ang = self:GetAngles()
			umsg.Vector( Vector( ang.p, ang.y, ang.r ) )
			local col = self:GetColor()
			umsg.Vector( Vector( col.r, col.g, col.b ) )
			umsg.Short( math.Round( speed ) )
		umsg.End()
	end

	self:Remove()
end

--Fadein is serverside
function EntityMeta:Fadein( speed )
	self.AlphaFade = 0
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	self:SetColor( Color( 255, 255, 255, 0 ) )
	self.FadeInSpeed = speed or 4
	table.insert( GMS.FadingInProps, self )
end

hook.Add( "Think", "gms_FadePropsThink", function()
	for k, ent in pairs( GMS.FadingInProps ) do
		if ( !ent or ent == NULL ) then
			table.remove( GMS.FadingInProps, k )
		elseif ( !IsValid( ent ) ) then
			table.remove( GMS.FadingInProps, k )
		elseif ( ent.AlphaFade >= 255 ) then
			table.remove( GMS.FadingInProps, k )
		else
			ent.AlphaFade = ent.AlphaFade + ent.FadeInSpeed
			ent:SetColor( Color( 255, 255, 255, ent.AlphaFade ) )
		end
	end
end )

/* ----------------------------------------------------------------------------------------------------
	Entity rising / lowering ( Used by gms_seed )
---------------------------------------------------------------------------------------------------- */

GM.RisingProps = {}
GM.SinkingProps = {}

function EntityMeta:RiseFromGround( speed, altmax )
	local speed = speed or 1
	local max;

	if ( !altmax ) then
		min, max = self:WorldSpaceAABB()
		max = max.z
	else
		max = altmax
	end

	local tbl = {}
	tbl.Origin = self:GetPos().z
	tbl.Speed = speed
	tbl.Entity = self

	self:SetPos( self:GetPos() + Vector( 0, 0, -max + 10 ) )
	table.insert( GAMEMODE.RisingProps, tbl )
end

function EntityMeta:SinkIntoGround( speed )
	local speed = speed or 1

	local tbl = {}
	tbl.Origin = self:GetPos().z
	tbl.Speed = speed
	tbl.Entity = self
	tbl.Height = max

	table.insert( GAMEMODE.SinkingProps, tbl )
end

hook.Add( "Think", "gms_RiseAndSinkPropsHook", function()
	for k, tbl in pairs( GAMEMODE.RisingProps ) do
		if ( !IsValid( tbl.Entity ) || tbl.Entity:GetPos().z >= tbl.Origin ) then
			table.remove( GAMEMODE.RisingProps, k )
		else
			tbl.Entity:SetPos( tbl.Entity:GetPos() + Vector( 0, 0, 1 * tbl.Speed ) )
		end
	end

	for k, tbl in pairs( GAMEMODE.SinkingProps ) do
		if ( !IsValid( tbl.Entity ) || tbl.Entity:GetPos().z <= tbl.Origin - tbl.Height ) then
			table.remove( GAMEMODE.SinkingProps, k )
			tbl.Entity:Remove()
		else
			tbl.Entity:SetPos( tbl.Entity:GetPos() + Vector( 0, 0, -1 * tbl.Speed ) )
		end
	end
end )

/* ----------------------------------------------------------------------------------------------------
	Admin commands
---------------------------------------------------------------------------------------------------- */

concommand.Add( "gms_admin_maketree", function( ply )
	if ( IsValid( ply ) && !ply:IsAdmin() ) then ply:SendMessage( "You need admin rights for this!", 3, Color( 200, 0, 0, 255 ) ) return end
	local tr = ply:TraceFromEyes( 10000 )
	GAMEMODE.MakeTree( tr.HitPos )
end )

concommand.Add( "gms_admin_makerock", function( ply )
	if ( IsValid( ply ) && !ply:IsAdmin() ) then ply:SendMessage( "You need admin rights for this!", 3, Color( 200, 0, 0, 255 ) ) return end
	local tr = ply:TraceFromEyes( 10000 )
	GAMEMODE.MakeGenericPlant( ply, tr.HitPos, GMS.RockModels[ math.random( 1, #GMS.RockModels ) ], true )
end )

concommand.Add( "gms_admin_makefood", function( ply )
	if ( IsValid( ply ) && !ply:IsAdmin() ) then ply:SendMessage( "You need admin rights for this!", 3, Color( 200, 0, 0, 255 ) ) return end
	local tr = ply:TraceFromEyes( 10000 )
	local ent = ents.Create( "prop_physics" )
	ent:SetAngles( Angle( 0, math.random( 1, 360 ), 0 ) )
	ent:SetModel( GMS.EdibleModels[math.random( 1, #GMS.EdibleModels )] )
	ent:SetPos( tr.HitPos + Vector( 0, 0, 10 ) )
	ent:Spawn()
	SPropProtection.PlayerMakePropOwner( ply, ent )
end )

concommand.Add( "gms_admin_makeantlionbarrow", function( ply, cmd, args )
	if ( IsValid( ply ) && !ply:IsAdmin() ) then ply:SendMessage( "You need admin rights for this!", 3, Color( 200, 0, 0, 255 ) ) return end
	if ( !args[1] ) then ply:SendMessage( "Specify max antlions!", 3, Color( 200, 0, 0, 255 ) ) return end
	local tr = ply:TraceFromEyes( 10000 )
	local ent = ents.Create( "gms_antlionbarrow" )
	ent:SetPos( tr.HitPos )
	ent:Spawn()
	ent:SetNetworkedString( "Owner", "World" )
	ent:SetKeyValue( "MaxAntlions", args[1] )
end )

concommand.Add( "gms_admin_makeplant", function( ply, cmd, args )
	if ( IsValid( ply ) && !ply:IsAdmin() ) then ply:SendMessage( "You need admin rights for this!", 3, Color( 200, 0, 0, 255 ) ) return end

	local tr = ply:TraceFromEyes( 10000 )
	local typ = tonumber( args[ 1 ] ) or math.random( 1, 5 )
	local pos = tr.HitPos

	if ( typ == 1 ) then
		GAMEMODE.MakeMelon( pos, math.random( 1, 3 ), ply )
	elseif ( typ == 2 ) then
		GAMEMODE.MakeBanana( pos, math.random( 1, 3 ), ply )
	elseif ( typ == 3 ) then
		GAMEMODE.MakeOrange( pos, math.random( 1, 3 ), ply )
	elseif ( typ == 4 ) then
		GAMEMODE.MakeBush( pos, ply )
	elseif ( typ == 5 ) then
		GAMEMODE.MakeGrain( pos, ply )
	end
end )

concommand.Add( "gms_admin_populatearea", function( ply, cmd, args )
	if ( IsValid( ply ) && !ply:IsAdmin() ) then ply:SendMessage( "You need admin rights for this!", 3, Color( 200, 0, 0, 255 ) ) return end
	if ( !args[1] or !args[2] or !args[3] ) then ply:SendMessage( "You need to specify <type> <amount> <radius>", 3, Color( 200, 0, 0, 255 ) ) return end

	for k, v in pairs( player.GetAll() ) do
		v:SendMessage( "Populating area...", 3, Color( 255, 255, 255, 255 ) )
	end

	--Population time
	local Amount = tonumber( args[2] ) or 10
	local info = {}
	info.Amount = Amount

	if ( Amount > 200 ) then 
		ply:SendMessage( "Auto-capped at 200 props.", 3, Color( 200, 0, 0, 255 ) )
		info.Amount = 200
	end

	local Type = args[1]
	local Amount = info.Amount
	local Radius = tonumber( args[3] ) or 1000

	--Find playertrace
	local plytrace = ply:TraceFromEyes( 10000 )

	for i = 1, Amount do
		info.pos = plytrace.HitPos + Vector( math.random( -Radius, Radius ), math.random( -Radius, Radius ), 1000 )
		info.Retries = 50

		--Find pos in world
		while ( util.IsInWorld( info.pos ) == false and info.Retries > 0 ) do
			info.pos = plytrace.HitPos + Vector( math.random( -Radius, Radius ), math.random( -Radius, Radius ), 1000 )
			info.Retries = info.Retries - 1
		end

		--Find ground
		local trace = {}
		trace.start = info.pos
		trace.endpos = trace.start + Vector( 0, 0, -100000 )
		trace.mask = MASK_SOLID_BRUSHONLY

		local groundtrace = util.TraceLine( trace )

		--Assure space
		local nearby = ents.FindInSphere( groundtrace.HitPos, 200 )
		info.HasSpace = true

		for k, v in pairs( nearby ) do
			if ( v:IsProp() ) then
				info.HasSpace = false
			end
		end

		--Find sky
		local trace = {}
		trace.start = groundtrace.HitPos
		trace.endpos = trace.start + Vector( 0, 0, 100000 )

		local skytrace = util.TraceLine( trace )

		--Find water?
		local trace = {}
		trace.start = groundtrace.HitPos
		trace.endpos = trace.start + Vector( 0, 0, 1 )
		trace.mask = MASK_WATER

		local watertrace = util.TraceLine( trace )

		--All a go, make entity
		if ( Type == "Trees" ) then
			if ( info.HasSpace and skytrace.HitSky and !watertrace.Hit and ( groundtrace.MatType == MAT_DIRT or groundtrace.MatType == MAT_GRASS or groundtrace.MatType == MAT_SAND ) ) then
				GAMEMODE.MakeTree( groundtrace.HitPos )
			end
		elseif ( Type == "Rocks" ) then
			if ( !watertrace.Hit and ( groundtrace.MatType == MAT_DIRT or groundtrace.MatType == MAT_GRASS or groundtrace.MatType == MAT_SAND ) ) then
				local ent = ents.Create( "prop_physics" )
				ent:SetAngles( Angle( 0, math.random( 1, 360 ), 0 ) )
				ent:SetModel( GMS.RockModels[math.random( 1, #GMS.RockModels )] )
				ent:SetPos( groundtrace.HitPos )
				ent:Spawn()
				ent:SetNetworkedString( "Owner", "World" )
				ent:Fadein()
				ent.PhysgunDisabled = true
				ent:GetPhysicsObject():EnableMotion( false )
			end
		elseif ( Type == "Random_Plant" and info.HasSpace ) then
			if ( !watertrace.Hit and ( groundtrace.MatType == MAT_DIRT or groundtrace.MatType == MAT_GRASS or groundtrace.MatType == MAT_SAND ) ) then
				local typ = math.random( 1, 5 )
				local pos = groundtrace.HitPos

				if ( typ == 1 ) then
					GAMEMODE.MakeMelon( pos,math.random( 1, 2 ), ply )
				elseif ( typ == 2 ) then
					GAMEMODE.MakeBanana( pos,math.random( 1, 2 ), ply )
				elseif ( typ == 3 ) then
					GAMEMODE.MakeOrange( pos,math.random( 1, 2 ), ply )
				elseif ( typ == 4 ) then
					GAMEMODE.MakeBush( pos, ply )
				elseif ( typ == 5 ) then
					GAMEMODE.MakeGrain( pos, ply )
				end
			end
		end
	end

	--Finished
	for k, v in pairs( player.GetAll() ) do
		v:SendMessage( "Done!", 3, Color( 255, 255, 255, 255 ) )
	end
end )

concommand.Add( "gms_admin_clearmap", function( ply )
	if ( IsValid( ply ) && !ply:IsAdmin() ) then ply:SendMessage( "You need admin rights for this!", 3, Color( 200, 0, 0, 255 ) ) return end

	for k, v in pairs( ents.GetAll() ) do
		if ( v:IsRockModel() or v:IsTreeModel() ) then
			for k, tbl in pairs( GAMEMODE.RisingProps ) do
				if ( tbl.Entity == v ) then
					table.remove( GAMEMODE.RisingProps, k )
				end
			end
			for k, tbl in pairs( GAMEMODE.SinkingProps ) do
				if ( tbl.Entity == v ) then
					table.remove( GAMEMODE.SinkingProps, k )
				end
			end
			for k, ent in pairs( GAMEMODE.FadingInProps ) do
				if ( ent == v ) then
					table.remove( GAMEMODE.FadingInProps, k )
				end
			end
			v:Fadeout()
		end
	end

	for k, v in pairs( player.GetAll() ) do v:SendMessage( "Cleared map.", 3, Color( 255, 255, 255, 255 ) ) end
end )

concommand.Add( "gms_admin_saveallcharacters", function( ply )
	if ( IsValid( ply ) && !ply:IsAdmin() ) then ply:SendMessage( "You need admin rights for this!", 3, Color( 200, 0, 0, 255 ) ) return end

	for k, v in pairs( player.GetAll() ) do
		v:SaveCharacter()
	end

	ply:SendMessage( "Saved characters on all current players.", 3, Color( 255, 255, 255, 255 ) )
end )

function GM.ADropResource( ply, cmd, args )
	if ( IsValid( ply ) && !ply:IsAdmin() ) then ply:SendMessage( "You need admin rights for this!", 3, Color( 200, 0, 0, 255 ) ) return end
	if ( args == nil or args[1] == nil ) then ply:SendMessage( "You need to at least give a resource type!", 3, Color( 200, 0, 0, 255 ) ) return end

	args[1] = string.Capitalize( args[1] )
	if ( args[2] == nil or string.lower( args[2] ) == "all" ) then args[2] = tostring( ply:GetResource( args[1] ) ) end
	if ( tonumber( args[2] ) <= 0 ) then ply:SendMessage( "No zeros/negatives!", 3, Color( 200, 0, 0, 255 ) ) return end

	local int = tonumber( args[2] )
	local Type = args[1] 

	ply:DropResource( Type, int )
	ply:SendMessage( "Dropped " .. string.Replace( Type, "_", " " ) .. " ( " .. int .. "x )", 3, Color( 10, 200, 10, 255 ) )
end
concommand.Add( "gms_ADropResources", GM.ADropResource )

/* ----------------------------------------------------------------------------------------------------
	Console Commands
---------------------------------------------------------------------------------------------------- */

concommand.Add( "gms_dropall", function( ply )
	local DeltaTime = 0
	for k, v in pairs( ply.Resources ) do
		if ( v > 0 ) then
			timer.Simple( DeltaTime, function() ply:DecResource( k, v ) ply:DropResource( k, v ) end, ply, k, v )
			DeltaTime = DeltaTime + 0.2
		end
	end
	ply.NextSpawnTime = CurTime() + DeltaTime + 0.5
end )

concommand.Add( "gms_salvage", function( ply )
	if ( ply.InProcess ) then return end

	local tr = ply:TraceFromEyes( 100 )
	if ( !tr.HitNonWorld ) then return end

	local ent = tr.Entity

	if ( ent:GetClass() != "gms_buildsite" && ( table.HasValue( GMS.StructureEntities, ent:GetClass() ) || ent.NormalProp == true ) && SPropProtection.PlayerCanTouch( ply, ent ) ) then
		ply:DoProcess( "Salvage", 6, { Entity = ent, MatType = tr.MatType } )
	else
		ply:SendMessage( "Cannot salvage this kind of prop.", 5, Color( 255, 255, 255, 255 ) )
	end
end )

concommand.Add( "gms_steal", function( ply, cmd, args )
	local tr = ply:TraceFromEyes( 100 )
	local ent = tr.Entity

	if ( ply:GetSkill( "Survival" ) < 30 ) then ply:SendMessage( "You can only steal at survival level 30+.", 3, Color( 200, 0, 0, 255 ) ) return end
	if ( !IsValid( ent ) || !tr.HitNonWorld || ent:IsNPC() || ent:IsPlayer() || ent:GetClass() == "gms_buildsite" || ent:GetClass() == "gms_seed" || ent:GetNWString( "Owner", "None" ) == "World" || SPropProtection.PlayerCanTouch( ply, ent ) ) then
		ply:SendMessage( "You can't steal this.", 3, Color( 200, 0, 0, 255 ) )
		return
	end

	local cls = ent:GetClass()
	local time = math.max( ent:GetVolume(), 1 )
	if ( cls == "gms_resourcedrop" ) then
		time = ent.Amount * 0.5
	elseif ( cls == "gms_resourcepack" or cls == "gms_fridge" ) then
		for r, n in pairs( ent.Resources ) do
			time = time + ( n * 0.25 )
		end
	end

	time = math.max( time - math.floor( ply:GetSkill( "Stealing" ) / 3 ), math.max( time * 0.25, 2 ) )
	ply:DoProcess( "Steal", time, { Ent = ent } )
end )

function GM.PlantMelon( ply, cmd, args )
	if ( ply:GetNWInt( "plants" ) >= GetConVarNumber( "gms_PlantLimit" ) ) then 
		ply:SendMessage( "You have hit the plant limit.", 3, Color( 200, 0, 0, 255 ) )
		return 
	end
	local tr = ply:TraceFromEyes( 150 )

	if ( tr.HitWorld ) then
		if ( tr.MatType == MAT_DIRT or tr.MatType == MAT_GRASS or tr.MatType == MAT_SAND ) and !GMS.IsInWater( tr.HitPos ) then
			if ( ply:GetResource( "Melon_Seeds" ) >= 1 ) then
				if ( !GMS.ClassIsNearby( tr.HitPos, "gms_seed", 30 ) and !GMS.ClassIsNearby( tr.HitPos, "prop_physics", 50 ) ) then
					local data = {}
					data.Pos = tr.HitPos
					ply:DoProcess( "PlantMelon", 3, data )
				else
					ply:SendMessage( "You need more distance between seeds/props.", 3, Color( 200, 0, 0, 255 ) )
				end
			else
				ply:SendMessage( "You need a watermelon seed.", 3, Color( 200, 0, 0, 255 ) )
			end
		else
			ply:SendMessage( "You cannot plant on this terrain.", 3, Color( 200, 0, 0, 255 ) )
		end
	else
		ply:SendMessage( "Aim at the ground to plant.", 3, Color( 200, 0, 0, 255 ) )
	end
end
concommand.Add( "gms_plantmelon", GM.PlantMelon )

function GM.PlantBanana( ply, cmd, args )
	if ( ply:GetNWInt( "plants" ) >= GetConVarNumber( "gms_PlantLimit" ) ) then ply:SendMessage( "You have hit the plant limit.", 3, Color( 200, 0, 0, 255 ) ) return end
	local tr = ply:TraceFromEyes( 150 )

	if ( tr.HitWorld ) then
		if ( ( tr.MatType == MAT_DIRT or tr.MatType == MAT_GRASS or tr.MatType == MAT_SAND ) and !GMS.IsInWater( tr.HitPos ) ) then
			if ( ply:GetResource( "Banana_Seeds" ) >= 1 ) then
				if ( !GMS.ClassIsNearby( tr.HitPos, "gms_seed", 30 ) and !GMS.ClassIsNearby( tr.HitPos, "prop_physics", 50 ) ) then
					ply:DoProcess( "PlantBanana", 3, { Pos = tr.HitPos } )
				else
					ply:SendMessage( "You need more distance between seeds/props.", 3, Color( 200, 0, 0, 255 ) )
				end
			else
				ply:SendMessage( "You need a banana seed.", 3, Color( 200, 0, 0, 255 ) )
			end
		else
			ply:SendMessage( "You cannot plant on this terrain.", 3, Color( 200, 0, 0, 255 ) )
		end
	else
		ply:SendMessage( "Aim at the ground to plant.", 3, Color( 200, 0, 0, 255 ) )
	end
end
concommand.Add( "gms_plantbanana", GM.PlantBanana )

function GM.PlantOrange( ply, cmd, args )
	if ( ply:GetNWInt( "plants" ) >= GetConVarNumber( "gms_PlantLimit" ) ) then ply:SendMessage( "You have hit the plant limit.",3,Color( 200,0,0,255 ) ) return end
	local tr = ply:TraceFromEyes( 150 )

	if ( tr.HitWorld ) then
		if ( ( tr.MatType == MAT_DIRT or tr.MatType == MAT_GRASS or tr.MatType == MAT_SAND ) and !GMS.IsInWater( tr.HitPos ) ) then
			if ( ply:GetResource( "Orange_Seeds" ) >= 1 ) then
				if ( !GMS.ClassIsNearby( tr.HitPos, "gms_seed", 30 ) and !GMS.ClassIsNearby( tr.HitPos, "prop_physics", 50 ) ) then
					ply:DoProcess( "PlantOrange", 3, { Pos = tr.HitPos } )
				else
					ply:SendMessage( "You need more distance between seeds/props.", 3, Color( 200, 0, 0, 255 ) )
				end
			else
				ply:SendMessage( "You need an orange seed.", 3, Color( 200, 0, 0, 255 ) )
			end
		else
			ply:SendMessage( "You cannot plant on this terrain.", 3, Color( 200, 0, 0, 255 ) )
		end
	else
		ply:SendMessage( "Aim at the ground to plant.", 3, Color( 200 ,0, 0, 255 ) )
	end
end
concommand.Add( "gms_plantorange", GM.PlantOrange )

function GM.PlantGrain( ply, cmd, args )
	if ( !ply:HasUnlock( "Grain_Planting" ) ) then ply:SendMessage( "You need more planting skill.", 3, Color( 200, 0, 0, 255 ) ) return end
	if ( ply:GetNWInt( "plants" ) >= GetConVarNumber( "gms_PlantLimit" ) ) then ply:SendMessage( "You have hit the plant limit.", 3, Color( 200, 0, 0, 255 ) ) return end
	local tr = ply:TraceFromEyes( 150 )

	if ( tr.HitWorld ) then
		local nearby = false

		for k, v in pairs( ents.FindInSphere( tr.HitPos, 50 ) ) do
			if ( ( v:IsGrainModel() or v:IsProp() or v:GetClass() == "gms_seed" ) and ( tr.HitPos-Vector( v:LocalToWorld( v:OBBCenter() ).x, v:LocalToWorld( v:OBBCenter() ).y, tr.HitPos.z ) ):Length() <= 50 ) then
				nearby = true
			end
		end

		if ( ( tr.MatType == MAT_DIRT or tr.MatType == MAT_GRASS or tr.MatType == MAT_SAND ) and !GMS.IsInWater( tr.HitPos ) ) then
			if ( ply:GetResource( "Grain_Seeds" ) >= 1 ) then
				if ( !nearby ) then
					ply:DoProcess( "PlantGrain", 3, { Pos = tr.HitPos } )
				else
					ply:SendMessage( "You need more distance between seeds/props.", 3, Color( 200, 0, 0, 255 ) )
				end
			else
				ply:SendMessage( "You need a grain seed.", 3, Color( 200, 0, 0, 255 ) )
			end
		else
			ply:SendMessage( "You cannot plant on this terrain.", 3, Color( 200, 0, 0, 255 ) )
		end
	else
		ply:SendMessage( "Aim at the ground to plant.", 3, Color( 200, 0, 0, 255 ) )
	end
end
concommand.Add( "gms_plantgrain", GM.PlantGrain )

function GM.PlantBush( ply, cmd, args )
	if ( ply:GetNWInt( "plants" ) >= GetConVarNumber( "gms_PlantLimit" ) ) then ply:SendMessage( "You have hit the plant limit.", 3, Color( 200, 0, 0, 255 ) ) return end
	local tr = ply:TraceFromEyes( 150 )

	if ( tr.HitWorld ) then
		local nearby = false

		for k, v in pairs( ents.FindInSphere( tr.HitPos, 50 ) ) do
			if ( ( v:IsBerryBushModel() or v:IsProp() or v:GetClass() == "gms_seed" ) and ( tr.HitPos-Vector( v:LocalToWorld( v:OBBCenter() ).x, v:LocalToWorld( v:OBBCenter() ).y, tr.HitPos.z ) ):Length() <= 50 ) then
				nearby = true
			end
		end

		if ( ( tr.MatType == MAT_DIRT or tr.MatType == MAT_GRASS or tr.MatType == MAT_SAND ) and !GMS.IsInWater( tr.HitPos ) ) then
			if ( ply:GetResource( "Berries" ) >= 1 ) then
				if ( !nearby ) then
					ply:DoProcess( "PlantBush", 3, { Pos = tr.HitPos } )
				else
					ply:SendMessage( "You need more distance between seeds/props.", 3, Color( 200, 0, 0, 255 ) )
				end
			else
				ply:SendMessage( "You need a berry.", 3, Color( 200, 0, 0, 255 ) )
			end
		else
			ply:SendMessage( "You cannot plant on this terrain.", 3, Color( 200, 0, 0, 255 ) )
		end
	else
		ply:SendMessage( "Aim at the ground to plant.", 3, Color( 200, 0, 0, 255 ) )
	end
end
concommand.Add( "gms_plantbush", GM.PlantBush )

function GM.PlantTree( ply, cmd, args )
	if ( !ply:HasUnlock( "Sprout_Planting" ) ) then ply:SendMessage( "You need more planting skill.", 3, Color( 200, 0, 0, 255 ) ) return end
	local tr = ply:TraceFromEyes( 150 )

	if ( tr.HitWorld ) then 
		if ( ( tr.MatType == MAT_DIRT or tr.MatType == MAT_GRASS or tr.MatType == MAT_SAND ) and !GMS.IsInWater( tr.HitPos ) ) then
			if ( ply:GetResource( "Sprouts" ) >= 1 ) then
				ply:DoProcess( "PlantTree", 5, { Pos = tr.HitPos } )
			else
				ply:SendMessage( "You need a sprout.", 3, Color( 200, 0, 0, 255 ) )
			end
		else
			ply:SendMessage( "You cannot plant on this terrain.", 3, Color( 200, 0, 0, 255 ) )
		end
	else
		ply:SendMessage( "Aim at the ground to plant.", 3, Color( 200, 0, 0, 255 ) )
	end
end
concommand.Add( "gms_planttree", GM.PlantTree )

function GM.DrinkFromBottle( ply, cmd, args )
	if ( ply:GetResource( "Water_Bottles" ) < 1 ) then ply:SendMessage( "You need a water bottle.", 3, Color( 200, 0, 0, 255 ) ) return end
	ply:DoProcess( "DrinkBottle", 1.5 )
end
concommand.Add( "gms_drinkbottle", GM.DrinkFromBottle )

function GM.EatBerry( ply, cmd, args )
	if ( ply:GetResource( "Berries" ) < 1 ) then ply:SendMessage( "You need some berries.", 3, Color( 200, 0, 0, 255 ) ) return end
	ply:DoProcess( "EatBerry", 1.5 )
end
concommand.Add( "gms_eatberry", GM.EatBerry )

function GM.TakeAMedicine( ply, cmd, args )
	if ( ply:GetResource( "Medicine" ) < 1 ) then ply:SendMessage( "You need Medicine.", 3, Color( 200, 0, 0, 255 ) ) return end
	ply:DoProcess( "TakeMedicine", 1.5 )
end
concommand.Add( "gms_takemedicine", GM.TakeAMedicine )

function GM.DropWeapon( ply, cmd, args )
	if ( !ply:Alive() ) then return end
	if ( table.HasValue( GMS.NonDropWeapons, ply:GetActiveWeapon():GetClass() ) ) then
		ply:SendMessage( "You cannot drop this!", 3, Color( 200, 0, 0, 255 ) )
	else
		ply:DropWeapon( ply:GetActiveWeapon() )
	end
end
concommand.Add( "gms_dropweapon", GM.DropWeapon )

function GM.DropResource( ply, cmd, args )
	if ( args == nil or args[1] == nil ) then ply:SendMessage( "You need to at least give a resource type!", 3, Color( 200, 0, 0, 255 ) ) return end

	args[1] = string.Capitalize( args[1] )
	if ( !ply.Resources[args[1]] or ply.Resources[args[1]] == 0 ) then ply:SendMessage( "You don't have this kind of resource.", 3, Color( 200, 0, 0, 255 ) ) return end
	if ( args[2] == nil or string.lower( args[2] ) == "all" ) then args[2] = tonumber( ply:GetResource( args[1] ) ) end

	if ( !tonumber( args[2] ) || tonumber( args[2] ) <= 0 ) then ply:SendMessage( "No zeros/negatives!", 3, Color( 200, 0, 0, 255 ) ) return end

	local int = tonumber( args[2] )
	local Type = args[1]
	local res = ply:GetResource( Type )

	if ( int > res ) then
		int = res
	end
	ply:DropResource( Type, int )
	ply:DecResource( Type, int )

	ply:SendMessage( "Dropped " .. string.Replace( Type, "_", " " ) .. " ( " .. int .. "x )", 3, Color( 10, 200, 10, 255 ) )
end
concommand.Add( "gms_DropResources", GM.DropResource )

function GM.TakeResource( ply, cmd, args )
	if ( ply.InProcess ) then return end

	local takeAll = false
	if ( args == nil or args[ 1 ] == nil ) then takeAll = true end

	local int = tonumber( args[ 2 ] ) or 99999
	local typ = string.Capitalize( args[ 1 ] or "" )

	if ( int <= 0 ) then ply:SendMessage( "No zeros/negatives!", 3, Color( 200, 0, 0, 255 ) ) return end

	local tr = ply:TraceFromEyes( 150 )
	local ent = tr.Entity

	if ( !IsValid( ent ) ) then return end

	local cls = ent:GetClass()

	if ( cls != "gms_resourcedrop" && cls != "gms_resourcepack" && cls != "gms_fridge" ) then return end
	if ( !SPropProtection.PlayerCanTouch( ply, ent ) ) then return end
	if ( ( ply:GetPos() - ent:LocalToWorld( ent:OBBCenter() ) ):Length() >= 100 ) then return end

	if ( cls == "gms_resourcedrop" ) then
		if ( ent.Type != typ && !takeAll ) then return end
		local room = ply.MaxResources - ply:GetAllResources()
		if ( room <= 0 ) then return end
		if ( int >= ent.Amount ) then int = ent.Amount end
		if ( room < int ) then int = room end
		ent.Amount = ent.Amount - int
		if ( ent.Amount <= 0 ) then ent:Fadeout() else ent:SetResourceDropInfo( ent.Type, ent.Amount ) end

		ply:IncResource( ent.Type, int )
		ply:SendMessage( "Picked up " .. string.Replace( ent.Type, "_", " " ) .. " ( " .. int .. "x )", 4, Color( 10, 200, 10, 255 ) )
	end

	if ( cls == "gms_resourcepack" ) then
		for res, num in pairs( ent.Resources ) do
			if ( res == typ or takeAll ) then
				local totake = int
				local room = ply.MaxResources - ply:GetAllResources()
				if ( room <= 0 ) then return end
				if ( totake >= num ) then totake = num end
				if ( room < totake ) then totake = room end
				ent.Resources[ res ] = num - totake
				ent:SetResPackInfo( res, ent.Resources[ res ] ) 
				if ( ent.Resources[ res ] <= 0 ) then ent.Resources[ res ] = nil end

				ply:IncResource( res, totake )
				ply:SendMessage( "Picked up " .. string.Replace( res, "_", " " ) .. " ( " .. totake .. "x )", 4, Color( 10, 200, 10, 255 ) )
			end
		end
	end

	if ( takeAll ) then return end

	if ( cls == "gms_fridge" ) then
		for res, num in pairs( ent.Resources ) do
			if ( res == args[ 1 ] ) then
				ent.Resources[ res ] = num - 1
				ent:SetResPackInfo( res, ent.Resources[ res ] ) 
				if ( ent.Resources[ res ] <= 0 ) then ent.Resources[ res ] = nil end

				local food = ents.Create( "gms_food" )
				food:SetPos( ent:GetPos() + Vector( 0, 0, ent:OBBMaxs().z + 16 ) )
				SPropProtection.PlayerMakePropOwner( ply, food )
				food.Value = GMS.Combinations[ "Cooking" ][ string.Replace( res, " ", "_" ) ].FoodValue
				food.Name = res
				food:Spawn()
				food:SetFoodInfo( res )
				
				timer.Simple( 300, function( food ) if ( IsValid( food ) ) then food:Fadeout( 2 ) end end, food )
			end
		end
	end
end
concommand.Add( "gms_TakeResources", GM.TakeResource ) // ply:PickupResourceEntityPack( ent )

concommand.Add( "gms_structures", function( ply )
	ply:OpenCombiMenu( "Structures" )
end )

concommand.Add( "gms_combinations", function( ply )
	ply:OpenCombiMenu( "Combinations" )
end )

concommand.Add( "gms_MakeCombination", function( ply, cmd, args )
	if ( !args[1] or !args[2] ) then ply:SendMessage( "Please specify a valid combination.", 3, Color( 255, 255, 255, 255 ) ) return end

	local group = args[1]
	local combi = args[2]

	if ( !GMS.Combinations[ group ] ) then return end
	if ( !GMS.Combinations[ group ][ combi ] ) then return end

	local tbl = GMS.Combinations[ group ][ combi ]

	if ( group == "Cooking" and tbl.Entity ) then
		local nearby = false

		for k, v in pairs( ents.FindInSphere( ply:GetPos(), 100 ) ) do
			if ( ( v:IsProp() and v:IsOnFire() ) or v:GetClass() == tbl.Entity ) then nearby = true end
		end

		if ( !nearby ) then ply:SendMessage( "You need to be close to a fire!", 3, Color( 200, 0 ,0, 255 ) ) return end
	elseif ( tbl.Entity ) then
		local nearby = false

		for k, v in pairs( ents.FindInSphere( ply:GetPos(), 100 ) ) do
			if ( v:GetClass() == tbl.Entity ) then nearby = true end
		end

		if ( !nearby ) then ply:SendMessage( "You need to be close to a " .. tbl.Entity .. "!", 3, Color( 200, 0, 0, 255 ) ) return end
	end

	--Check for skills
	local numreq = 0

	if ( tbl.SkillReq ) then
		for k, v in pairs( tbl.SkillReq ) do
			if ( ply:GetSkill( k ) >= v ) then
				numreq = numreq + 1
			end
		end

		if ( numreq < table.Count( tbl.SkillReq ) ) then ply:SendMessage( "Not enough skill.", 3, Color( 200, 0, 0, 255 ) ) return end
	end

	--Check for resources
	local numreq = 0

	for k, v in pairs( tbl.Req ) do
		if ( ply:GetResource( k ) ) >= v then
			numreq = numreq + 1
		end
	end

	if ( numreq < table.Count( tbl.Req ) and group != "Structures" ) then ply:SendMessage( "Not enough resources.", 3, Color( 200, 0, 0, 255 ) ) return end

	--All well, make stuff:
	if ( group == "Cooking" ) then
		local data = {}
		data.Name = tbl.Name
		data.FoodValue = tbl.FoodValue
		data.Cost = table.Copy( tbl.Req )
		local time = 5

		if ply:GetActiveWeapon():GetClass() == "gms_fryingpan" then
			time = 2
		end

		ply:DoProcess( "Cook", time, data )
	elseif ( group == "Combinations" ) then
		local data = {}
		data.Name = tbl.Name
		data.Res = tbl.Results
		data.Cost = table.Copy( tbl.Req )
		local time = 5

		ply:DoProcess( "MakeGeneric", time, data )
	elseif ( group == "gms_gunlab" or group == "gms_gunchunks" ) then
		local data = {}
		data.Name = tbl.Name
		if ( tbl.AllSmelt == true ) then
			local sourcetable = ply:AllSmelt( tbl )
			data.Res  = sourcetable.Results
			data.Cost = table.Copy( sourcetable.Req )
		else
			data.Res = tbl.Results
			data.Cost = table.Copy( tbl.Req )
		end
		local timecount = 1
		for k, v in pairs( data.Cost ) do
			timecount  = timecount + v
		end 
		local time = timecount * 0.3

		if ( tbl.SwepClass != nil ) then
			data.Class = tbl.SwepClass
			ply:DoProcess( "MakeWeapon", time, data )
		else
			ply:DoProcess( "Processing", time, data )
		end
	elseif ( group == "gms_factory" ) then
		local data = {}
		data.Name = tbl.Name
		if ( tbl.AllSmelt == true ) then
			local sourcetable = ply:AllSmelt( tbl )
			data.Res = sourcetable.Results
			data.Cost = table.Copy( sourcetable.Req )
		else
			data.Res = tbl.Results
			data.Cost = table.Copy( tbl.Req )
		end
		local timecount = 1
		for k, v in pairs( data.Cost ) do
			timecount  = timecount + v
		end 
		local time = timecount * 0.3

		local smelt = false
		for r,n in pairs( data.Res ) do
			if ( r == "Iron" or r == "Copper" ) then smelt = true end
		end
		
		if ( tbl.SwepClass != nil ) then
			data.Class = tbl.SwepClass
			ply:DoProcess( "MakeWeapon", time, data )
		elseif ( smelt ) then
			time = math.max( time - math.floor( ply:GetSkill( "Smelting" ) / 5 ), math.max( timecount * 0.15, 2 ) )
			ply:DoProcess( "Smelt", time, data )
		else
			ply:DoProcess( "Processing", time, data )
		end
	elseif ( group == "gms_stoneworkbench" or group == "gms_copperworkbench" or group == "gms_ironworkbench" ) then
		local data = {}
		data.Name = tbl.Name
		data.Class = tbl.SwepClass
		data.Cost = table.Copy( tbl.Req )
		
		local time = 10
		if ( ply:GetActiveWeapon():GetClass() == "gms_wrench" ) then time = 7 end
		time = math.max( time - math.floor( math.max( ply:GetSkill( "Weapon_Crafting" ) - 8, 0 ) / 4 ), 4 )

		ply:DoProcess( "MakeWeapon", time, data )
	elseif ( group == "gms_techworkbench" ) then
		local data = {}
		data.Name = tbl.Name
		data.Cost = table.Copy( tbl.Req )

		if ( tbl.SwepClass != nil ) then
			local time = 10
			if ( ply:GetActiveWeapon():GetClass() == "gms_wrench" ) then time = 7 end
			time = math.max( time - math.floor( math.max( ply:GetSkill( "Weapon_Crafting" ) - 8, 0 ) / 4 ), 4 )
			data.Class = tbl.SwepClass
			ply:DoProcess( "MakeWeapon", time, data )
		else
			data.Res = tbl.Results
			local time = 5
			ply:DoProcess( "MakeGeneric", time, data )
		end
	elseif ( group == "Structures" ) then
		local trs = ply:TraceFromEyes( 250 )
		if ( !trs.HitWorld ) then ply:SendMessage( "Aim at the ground to construct a structure.", 3, Color( 200, 0, 0, 255 ) ) return end

		ply:DoProcess( "MakeBuilding", 20, {
			Name = tbl.Name,
			Class = tbl.Results,
			Cost = table.Copy( tbl.Req ),
			BuildSiteModel = tbl.BuildSiteModel,
			Pos = trs.HitPos
		} )

	elseif ( group == "gms_stonefurnace" ) then
		local data = {}
		data.Name = tbl.Name
		if ( tbl.AllSmelt == true ) then
			local sourcetable = ply:AllSmelt( tbl )
			data.Res  = sourcetable.Results
			data.Cost = table.Copy( sourcetable.Req )
		else
			data.Res = tbl.Results
			data.Cost = table.Copy( tbl.Req )
		end
		local timecount = 1
		for k, v in pairs( data.Cost ) do
			timecount = timecount + v
		end 
		
		local time = timecount * 0.5
		time = math.max( time - math.floor( ply:GetSkill( "Smelting" ) / 5 ), math.max( timecount * 0.25, 2 ) )

		ply:DoProcess( "Smelt", time, data )
	elseif ( group == "gms_copperfurnace" ) then
		local data = {}
		data.Name = tbl.Name
		if ( tbl.AllSmelt == true ) then
			local sourcetable = ply:AllSmelt( tbl )
			data.Res  = sourcetable.Results
			data.Cost = table.Copy( sourcetable.Req )
		else
			data.Res = tbl.Results
			data.Cost = table.Copy( tbl.Req )
		end
		local timecount = 1
		for k, v in pairs( data.Cost ) do
			timecount = timecount + v
		end 
		local time = timecount * 0.6
		time = math.max( time - math.floor( ply:GetSkill( "Smelting" ) / 5 ), math.max( timecount * 0.3, 2 ) )

		ply:DoProcess( "Smelt", time, data )
	elseif ( group == "gms_ironfurnace" ) then
		local data = {}
		data.Name = tbl.Name
		if ( tbl.AllSmelt == true ) then
			local sourcetable = ply:AllSmelt( tbl )
			data.Res  = sourcetable.Results
			data.Cost = table.Copy( sourcetable.Req )
		else
			data.Res = tbl.Results
			data.Cost = table.Copy( tbl.Req )
		end
		local timecount = 1
		for k, v in pairs( data.Cost ) do
			timecount = timecount + v
		end 
		local time = timecount * 0.7
		time = math.max( time - math.floor( ply:GetSkill( "Smelting" ) / 5 ), math.max( timecount * 0.35, 2 ) )

		ply:DoProcess( "Smelt", time, data )
	elseif ( group == "gms_grindingstone" ) then
		local data = {}
		data.Name = tbl.Name
		if ( tbl.AllSmelt == true ) then
			local sourcetable = ply:AllSmelt( tbl )

			for r, n in pairs( sourcetable.Results ) do
				if ( r == "Flour" ) then sourcetable.Results[r] = math.floor( n * 0.6 ) end
			end
			
			data.Res = sourcetable.Results
			data.Cost = table.Copy( sourcetable.Req )
		else
			data.Res = tbl.Results
			data.Cost = table.Copy( tbl.Req )
		end
		local timecount = 1
		for k, v in pairs( data.Cost ) do
			timecount = timecount + v
		end 
		local time = timecount * 0.75

		ply:DoProcess( "Crush", time, data )
	end
end )

concommand.Add( "gms_sleep", function( ply, cmd, args ) ply:Sleep() end )
concommand.Add( "gms_wakeup", function( ply, cmd, args ) ply:Wakeup() end )

function GM.AFK( ply, cmd, args )
	if ( ply:GetNWBool( "Sleeping" ) or !ply:Alive() ) then return end
	if ( ply.InProcess ) then return end
	if ( !ply:GetNWBool( "AFK", false ) ) then
		ply:SetNWBool( "AFK", true )
	else
		ply:SetNWBool( "AFK", false )
	end

	ply:Freeze( ply:GetNWBool( "AFK" ) )
end
concommand.Add( "gms_afk", GM.AFK )

function GM.PlayerStuck( ply, cmd, args )
	if ( ply.InProcess ) then return end
	if ( ply.Spam == true ) then ply:SendMessage( "No spamming!", 3, Color( 200, 0, 0, 255 ) ) return end
	if ( ply.Spam == false or ply.Spam == nil ) then ply:SetPos( ply:GetPos() + Vector( 0, 0, 64 ) ) end

	ply.Spam = true
	timer.Simple( 0.2, function() ply.Spam = false end )
end
concommand.Add( "gms_stuck", GM.PlayerStuck )

function GM.MakeCampfire( ply, cmd, args )
	if ( GetConVarNumber( "gms_campfire" ) == 1 ) then
		local tr = ply:TraceFromEyes( 150 )

		if ( !tr.HitNonWorld or !tr.Entity ) then ply:SendMessage( "Aim at the prop( s ) to use for campfire.", 3, Color( 255, 255, 255, 255 ) ) return end

		local ent = tr.Entity
		local cls = tr.Entity:GetClass()

		if ( ent:IsOnFire() or cls != "prop_physics" and cls != "prop_physics_multiplayer" and cls != "prop_dynamic" ) then
			ply:SendMessage( "Aim at the prop( s ) to use for campfire.", 3, Color( 255, 255, 255, 255 ) )
			return
		end

		local mat = tr.MatType

		if ( ply:GetResource( "Wood" ) < 5 ) then ply:SendMessage( "You need at least 5 wood to make a fire.", 5, Color( 255, 255, 255, 255 ) ) return end

		if ( mat != MAT_WOOD ) then ply:SendMessage( "Prop has to be wood, or if partially wood, aim at the wooden part.", 5, Color( 255, 255, 255, 255 ) ) return end

		local data = {}
		data.Entity = ent

		if ( SPropProtection.PlayerCanTouch( ply, ent ) ) then
			ply:DoProcess( "Campfire", 5, data )
			return
		end
	end
end
concommand.Add( "gms_makefire", GM.MakeCampfire )

/* ----------------------------------------------------------------------------------------------------
	Player spawn
---------------------------------------------------------------------------------------------------- */

function GM:PlayerInitialSpawn( ply )
	ply:SetTeam( 1 )

	ply.Skills = {}
	ply.Resources = {}
	ply.Experience = {}
	ply.FeatureUnlocks = {}

	ply:SetSkill( "Survival", 0 )
	ply:SetXP( "Survival", 0 )
	ply.MaxResources = 25
	ply.Loaded = true

	-- Admin info, needed clientside
	if ( ply:IsAdmin() ) then
		for k, v in pairs( file.Find( "gmstranded/gamesaves/*.txt", "DATA" ) ) do
			local name = string.sub( v, 1, string.len( v ) - 4 )

			if ( string.Right( name, 5 ) != "_info" ) then
				umsg.Start( "gms_AddLoadGameToList", ply )
					umsg.String( name )
				umsg.End()
			end
		end
	end

	-- Character loading
	if ( file.Exists( "gmstranded/saves/" .. ply:UniqueID() .. ".txt", "DATA" ) ) then
		local tbl = util.JSONToTable( file.Read( "gmstranded/saves/" .. ply:UniqueID() .. ".txt", "DATA" ) )

		if ( tbl[ "skills" ] ) then
			for k, v in pairs( tbl[ "skills" ] ) do ply:SetSkill( k, v ) end
		end

		if ( tbl[ "experience" ] ) then
			for k, v in pairs( tbl["experience"] ) do ply:SetXP( k, v ) end
		end

		/*if ( tbl["unlocks"] ) then 
			for k, v in pairs( tbl["unlocks"] ) do ply.FeatureUnlocks[ k ] = v end
		end*/

		if ( tbl["resources"] ) then
			for k, v in pairs( tbl["resources"] ) do ply:SetResource( k, v ) end
		end

		if ( tbl["weapons"] ) then
			for k, v in pairs( tbl["weapons"] ) do ply:Give( v ) end
		end

		ply:StripAmmo()

		if ( tbl[ "ammo" ] ) then
			for k, v in pairs( tbl[ "ammo" ] ) do ply:GiveAmmo( v, k ) end
		end

		if ( !ply.Skills[ "Survival" ] ) then ply.Skills[ "Survival" ] = 0 end

		ply.FeatureUnlocks = tbl["unlocks"]
		ply.MaxResources = ( ply.Skills["Survival"] * 5 ) + 25

		ply:SendMessage( "Loaded character successfully.", 3, Color( 255, 255, 255, 255 ) )
		ply:SendMessage( "Last visited on " .. tbl.date .. ", enjoy your stay.", 10, Color( 255, 255, 255, 255 ) )
	end

	ply:SetNWInt( "plants", 0 )
	for k, v in pairs( ents.GetAll() ) do
		if ( v and IsValid( v ) and v:GetNWEntity( "plantowner" ) and IsValid( v:GetNWEntity( "plantowner" ) ) and v:GetNWEntity( "plantowner" ) == ply ) then
			ply:SetNWInt( "plants", ply:GetNWInt( "plants" ) + 1 )
		end
	end

	local time = 2

	local rp = RecipientFilter()
	rp:AddPlayer( ply )

	for id, t in pairs( GAMEMODE.Tribes ) do
		timer.Simple( time, function()
			umsg.Start( "sendTribe", rp )
				umsg.Short( id )
				umsg.String( t.name )
				umsg.Vector( Vector( t.color.r, t.color.g, t.color.b ) )
				if ( t.password == false ) then 
					umsg.Bool( false )
				else
					umsg.Bool( true )
				end
			umsg.End()

		end )
		time = time + 0.1
	end

	for _, v in ipairs( ents.FindByClass( "gms_resourcedrop" ) ) do
		timer.Simple( time, function()
			umsg.Start( "gms_SetResourceDropInfo", rp )
			umsg.String( v:EntIndex() )
			umsg.String( string.gsub( v.Type or "Error!", "_", " " ) )
			umsg.Short( v.Amount )
			umsg.End()
		end )
		time = time + 0.1
	end

	for _, v in ipairs( table.Add( ents.FindByClass( "gms_resourcepack" ), ents.FindByClass( "gms_fridge" ) ) ) do
		for res, num in pairs( v.Resources ) do
			timer.Simple( time, function()
				umsg.Start( "gms_SetResPackInfo", rp )
				umsg.String( v:EntIndex() )
				umsg.String( string.gsub( res, "_", " " ) )
				umsg.Short( num )
				umsg.End()
			end )
			time = time + 0.1
		end
		time = time + 0.1
	end

	for _, v in ipairs( ents.FindByClass( "gms_food" ) ) do
		timer.Simple( time, function()
			umsg.Start( "gms_SetFoodDropInfo", ply )
				umsg.String( v:EntIndex() )
				umsg.String( string.gsub( v.Name or "ERROR", "_", " " ) )
			umsg.End()
		end )
		time = time + 0.1
	end
end

local SpawnClasses = {
	"info_player_deathmatch", "info_player_combine", "info_player_combine",
	"info_player_rebel", "info_player_counterterrorist", "info_player_terrorist",
	"info_player_axis", "info_player_allies", "gmod_player_start",
	"info_player_teamspawn", "ins_spawnpoint", "aoc_spawnpoint",
	"dys_spawn_point", "info_player_pirate", "info_player_viking",
	"info_player_knight", "diprip_start_team_blue", "diprip_start_team_red",
	"info_player_red", "info_player_blue", "info_player_coop",
	"info_player_human", "info_player_zombie", "info_player_deathmatch",
	"info_player_zombiemaster"
}

function GM:PlayerSelectSpawn( pl )
	if ( GAMEMODE.TeamBased ) then
		local ent = GAMEMODE:PlayerSelectTeamSpawn( pl:Team(), pl )
		if ( IsValid( ent ) ) then return ent end
	end

	if ( !IsTableOfEntitiesValid( self.SpawnPoints ) ) then
		self.LastSpawnPoint = 0
		self.SpawnPoints = ents.FindByClass( "info_player_start" )
		for id, cl in pairs( SpawnClasses ) do
			self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( cl ) )
		end
	end

	local count = table.Count( self.SpawnPoints )
	if ( count == 0 ) then
		MsgN( "[PlayerSelectSpawn] Error! No spawn points!" )
		return nil 
	end

	local ChosenSpawnPoint = nil

	for id, ChosenSpawnPoint in pairs( self.SpawnPoints ) do

		if ( IsValid( ChosenSpawnPoint ) && ChosenSpawnPoint:IsInWorld() ) then
			if ( GAMEMODE:IsSpawnpointSuitable( pl, ChosenSpawnPoint, id == count ) ) then
				return ChosenSpawnPoint
			end
		end

	end

	return ChosenSpawnPoint
end

function GM:PlayerSpawn( ply )

	self:SetPlayerSpeed( ply, 250, 250 )
	ply:SetMaxHealth( 100 )
	ply:UnSpectate()

	for k, v in pairs( GMS.FeatureUnlocks ) do
		if ( ply:HasUnlock( k ) && v.OnUnlock ) then v.OnUnlock( ply ) end
	end

	hook.Call("PlayerLoadout", self, ply)
	hook.Call("PlayerSetModel", self, ply)

	ply.Sleepiness = 1000
	ply.Hunger = 1000
	ply.Thirst = 1000
	ply.Oxygen = 1000
	ply.Power = 50

	ply.Resources = ply.Resources or {}

	if ( ply.Resources[ "Batteries" ] ) then ply.Power = math.min( ply.Power + ply.Resources[ "Batteries" ] * 50, 500 ) end

	/* GMOD CUSTOMIZATION */
	ply:UpdatePlayerColor()

	local col = ply:GetInfo( "cl_weaponcolor" )
	ply:SetWeaponColor( Vector( col ) )

	ply:SetupHands()

	ply:UpdateNeeds()
end

function GM:PlayerSetModel( ply )
	local cl_playermodel = ply:GetInfo( "cl_playermodel" )
	local modelname = player_manager.TranslatePlayerModel( cl_playermodel )
	util.PrecacheModel( modelname )
	ply:SetModel( modelname )
end

function GM:PlayerSetHandsModel( ply, ent )

	local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
	local info = player_manager.TranslatePlayerHands( simplemodel )
	if ( info ) then
		ent:SetModel( info.model )
		ent:SetSkin( info.skin )
		ent:SetBodyGroups( info.body )
	end

end

function GM:PlayerLoadout( ply )
	ply:Give( "gms_fists" )
	ply:Give( "weapon_physcannon" )
	ply:Give( "weapon_physgun" )

	ply:SelectWeapon( "weapon_physgun" )
	ply:SelectWeapon( "gms_fists" )

	if ( GetConVarNumber( "gms_AllTools" ) == 1 ) then
		for id, wep in pairs( GMS.AllWeapons ) do ply:Give( wep ) end
	end

	if ( ply:IsDeveloper() ) then ply:Give( "gmod_tool" ) ply:Give( "pill_pigeon" ) end
end

function GM:PlayerCanPickupWeapon( ply, wep )
	if ( ply:HasWeapon( wep:GetClass() ) ) then return false end
	return true
end

function GM:CanProperty( pl, property, ent )
	if ( !IsValid( ent ) ) then return false end
	if ( !pl:IsAdmin() ) then return false end

	if ( ent.m_tblToolsAllowed ) then
		local vFound = false
		for k, v in pairs( ent.m_tblToolsAllowed ) do
			if ( property == v ) then vFound = true end
		end

		if ( !vFound ) then return false end
	end

	if ( property == "bonemanipulate" ) then
		if ( game.SinglePlayer() ) then return true end

		if ( ent:IsNPC() ) then return GetConVarNumber( "sbox_bonemanip_npc" ) != 0 end
		if ( ent:IsPlayer() ) then return GetConVarNumber( "sbox_bonemanip_player" ) != 0 end

		return GetConVarNumber( "sbox_bonemanip_misc" ) != 0
	end

	return true
end

hook.Add( "PlayerDeath", "Death", function( ply )
	ply:ConCommand( "gms_dropall" )

	for _, v in pairs( ply:GetWeapons() ) do
		if ( !table.HasValue( GMS.NonDropWeapons, v:GetClass() ) && GetConVarNumber( "gms_AllTools" ) != 1 ) then
			ply:DropWeapon( v )
			SPropProtection.PlayerMakePropOwner( ply, v )
		end
	end

	ply:CancelProcess()

	if ( ply:GetNWBool("AFK") ) then
		ply:Freeze( false )
		ply:SetNWBool( "AFK", false )
	end
end )

timer.Create( "GMS.AutoSaveAllCharacters", math.Clamp( GetConVarNumber( "gms_AutoSaveTime" ), 1, 60 ) * 60, 0, function()
	if ( GetConVarNumber( "gms_AutoSave" ) == 1 ) then
		for k, v in pairs( player.GetAll() ) do
			v:SendMessage( "Autosaving..", 3, Color( 255, 255, 255, 255 ) )
			v:SaveCharacter()
		end
	end
end )

function GM:PlayerDisconnected( ply )
	Msg( "Saving character of disconnecting player " .. ply:Nick() .. "...\n" )
	ply:SaveCharacter()
end

function GM:ShutDown()
	for k, v in pairs( player.GetAll() ) do v:SaveCharacter() end
end

function PlayerMeta:UpdatePlayerColor()
	local col = self:GetInfo( "cl_playercolor" )
	if ( GetConVarNumber( "gms_TeamColors" ) > 0 ) then
		local tcol = team.GetColor( self:Team() )
		col = tcol.r / 255 .. " " .. tcol.g / 255 .. " " .. tcol.b / 255
	end
	self:SetPlayerColor( Vector( col ) )
end

function PlayerMeta:ResetCharacter()

	self.Skills = {}
	self.Resources = {}
	self.Experience = {}
	self.FeatureUnlocks = {}

	self:SetSkill( "Survival", 0 )
	self:SetXP( "Survival", 0 )
	self.MaxResources = 25

	self:SaveCharacter()

	umsg.Start( "gms_ResetPlayer", ply )
	umsg.End()

end

function PlayerMeta:SaveCharacter()
	if ( !file.IsDir( "gmstranded", "DATA" ) ) then file.CreateDir( "gmstranded" ) end
	if ( !file.IsDir( "gmstranded/saves", "DATA" ) ) then file.CreateDir( "gmstranded/saves" ) end
	if ( !self.Loaded ) then
		print( "Player " .. self:Name() .. " tried to save before he has loaded!" )
		self:SendMessage( "Character save failed: Not yet loaded!", 3, Color( 255, 50, 50, 255 ) )
		return
	end

	local tbl = {}
	tbl["date"] = os.date( "%A %m/%d/%y" )
	tbl["name"] = self:Nick()

	tbl["skills"] = self.Skills
	tbl["experience"] = self.Experience
	tbl["unlocks"] = self.FeatureUnlocks

	tbl["resources"] = {}
	tbl["weapons"] = {}
	tbl["ammo"] = {}

	for k, v in pairs( self.Resources ) do
		if ( v > 0 ) then tbl["resources"][ k ] = v end
	end

	for id, wep in pairs( self:GetWeapons() ) do
		if ( wep:GetClass() != "gms_fists" || wep:GetClass() != "weapon_physgun" || wep:GetClass() != "weapon_physcannon" ) then
			table.insert( tbl[ "weapons" ], wep:GetClass() )
		end
	end

	local ammo_types = { "ar2", "smg1", "pistol", "buckshot", "357", "grenade", "alyxgun", "xbowbolt", "AlyxGun", "RPG_Round","SMG1_Grenade", "SniperRound",
		"SniperPenetratedRound", "Grenade", "Thumper", "Gravity", "Battery", "GaussEnergy", "CombineCannon", "AirboatGun", "StriderMinigun", "StriderMinigunDirect",
		"HelicopterGun", "AR2AltFire", "Grenade", "Hopwire", "CombineHeavyCannon", "ammo_proto1"
	}

	for id, str in pairs( ammo_types ) do
		local ammo = self:GetAmmoCount( str )
		if ( ammo > 0 ) then tbl[ "ammo" ][ str ] = ammo end
	end

	file.Write( "gmstranded/saves/" .. self:UniqueID() .. ".txt", util.TableToJSON( tbl ) )
	self:SendMessage( "Saved character!", 3, Color( 255, 255, 255 ) )
end

concommand.Add( "gms_savecharacter", function( ply, cmd, args )
	if ( ply.GMSLastSave && ply.GMSLastSave > CurTime() ) then ply:SendMessage( "You must wait " .. math.floor( ply.GMSLastSave - CurTime() ) .. " seconds before saving again.", 3, Color( 255, 50, 50, 255 ) ) return end
	ply.GMSLastSave = CurTime() + 30
	ply:SaveCharacter()
end )

concommand.Add( "gms_resetcharacter", function( ply, cmd, args )
	if ( !args[ 1 ] ) then ply:ConCommand( "gms_resetcharacter_verify" ) return end
	if ( args[ 1 ] != "I agree" ) then ply:ChatPrint( "You didn't type what was asked." ) return end
	ply:ResetCharacter()
end )

/*------------------------ Prop spawning ------------------------*/

function GM:PlayerSpawnProp( ply, model )
	if ( ply.InProcess ) then return false end
	if ( ply.NextSpawn && ply.NextSpawn > CurTime() ) then ply:SendMessage( "No spamming!", 3, Color( 200, 0, 0, 255 ) ) return false end -- No spamming
	if ( !ply:IsAdmin() && GMS_IsAdminOnlyModel( model ) ) then ply:SendMessage( "You cannot spawn this prop unless you're admin.", 5, Color( 200, 0, 0, 255 ) ) return false end
	return true //LimitReachedProcess( ply, "props" )
end

function GM:PlayerSpawnedProp( ply, mdl, ent )
	ply.NextSpawn = CurTime() + 1
	SPropProtection.PlayerMakePropOwner( ply, ent )

	if ( GetConVarNumber( "gms_FreeBuild" ) == 1 ) then return end
	if ( GetConVarNumber( "gms_FreeBuildSA" ) == 1 and ply:IsAdmin() ) then return end

	ent.NormalProp = true

	timer.Simple( 0.2, function() self:PlayerSpawnedPropDelay( ply, mdl, ent ) end )
end

function GM:PlayerSpawnedPropDelay( ply, mdl, ent )
	if ( !IsValid( ent ) ) then return end

	--Trace
	ent.EntOwner = ply

	-- Do volume in cubic "feet"
	local vol = ent:GetVolume()

	local x = 0
	local trace = nil
	local tr = nil
	trace = {}
	trace.start = ent:GetPos() + Vector( ( math.random() * 200 ) - 100, ( math.random() * 200 ) - 100, ( math.random() * 200 ) - 100 )
	trace.endpos = ent:GetPos()
	tr = util.TraceLine( trace )

	while ( tr.Entity != ent and x < 5 ) do
		x = x + 1
		trace = {}
		trace.start = ent:GetPos() + Vector( ( math.random() * 200 ) - 100, ( math.random() * 200 ) - 100, ( math.random() * 200 ) - 100 )
		trace.endpos = ent:GetPos()
		tr = util.TraceLine( trace )
	end

	--Faulty trace
	if ( tr.Entity != ent ) then ent:Remove() ply:SendMessage( "You need more space to spawn.", 3, Color( 255, 255, 255, 255 ) ) return end

	if ( !GMS.MaterialResources[ tr.MatType ] ) then
		MsgC( Color( 255, 0, 0 ), "WARNING! Can't detect material of " .. mdl .. "!\n" )
		tr.MatType = MAT_CONCRETE
	end

	local res = GMS.MaterialResources[ tr.MatType ]
	//local cost = math.ceil( vol * ( GetConVarNumber( "gms_CostsScale" ) / 2 ) )
	local cost = math.ceil( vol * 0.5 )

	if ( cost > ply:GetResource( res ) ) then
		if ( IsValid( ply:GetBuildingSite() ) ) then ply:GetBuildingSite():Remove() end
		local site = ply:CreateBuildingSite( ent:GetPos(), ent:GetAngles(), ent:GetModel(), ent:GetClass() )
		local tbl = site:GetTable()
		site.EntOwner = ply
		site.NormalProp = true
		local costtable = {}
		costtable[ res ] = cost

		tbl.Costs = table.Copy( costtable )
		ply:DoProcess( "Assembling", math.max( 2, math.min( cost / 100, 120 ) ) )
		ply:SendMessage( "Not enough resources, creating buildsite.", 3, Color( 255, 255, 255, 255 ) )
		local str = ":"
		for k, v in pairs( site.Costs ) do
			str = str .. " " .. string.Replace( k, "_", " " ) .. " ( " .. v .. "x )"
		end
		site:SetNWString( "Resources", str )
		local Name = "Prop"
		site:SetNWString( "Name", Name )
		ent:Remove()
		return
	end

	-- Resource cost
	if ply:GetResource( res ) < cost then
		ent:Remove()
		ply:SendMessage( "You need " .. string.Replace( res, "_", " " ) .. " ( " .. cost .. "x ) to spawn this prop.", 3, Color( 200, 0, 0, 255 ) )
	else
		ply:DecResource( res, cost )
		ply:SendMessage( "Used " .. string.Replace( res, "_", " " ) .. " ( " .. cost .. "x ) to spawn this prop.", 3, Color( 255, 255, 255, 255 ) )
		ply:DoProcess( "Assembling", math.max( 2, math.min( cost / 100, 120 ) ) )
	end
end

-- No Ragdolls, Effects, SENTs, NPCs, SWEPs or Vehicles in Stranded.

function GM:PlayerSpawnRagdoll( ply, model )
	return false
end

function GM:PlayerSpawnEffect( ply, model )
	return false
end

function GM:PlayerSpawnSENT( ply, name )
	return false
end

function GM:PlayerSpawnNPC( ply, npc_type, equipment )
	return false
end

function GM:PlayerSpawnSWEP( ply, wname, wtable )
	return false
end

function GM:PlayerGiveSWEP( ply, wname, wtable )
	return false
end

function GM:PlayerSpawnVehicle( ply, model, vname, vtable )
	return false
end
 
/*------------------------ Needs ------------------------*/

timer.Create( "GMS.SubtractNeeds", 3, 0, function()
	for k, ply in pairs( player.GetAll() ) do
		if ( ply:Alive() ) then
			local AddHunger = -3
			local AddThirst = -6

			-- Sleeping
			if ( ply:GetNWBool( "Sleeping" ) ) then
				if ( ply.Sleepiness <= 950 ) then
					local trace = {}
					trace.start = ply:GetShootPos()
					trace.endpos = trace.start - ( ply:GetUp() * 300 )
					trace.filter = ply

					local tr = util.TraceLine( trace )
					if ( IsValid( tr.Entity ) and tr.Entity:IsSleepingFurniture() ) then
						ply.Sleepiness = math.Clamp( ply.Sleepiness + 100, 0, 1000 )
					else
						ply.Sleepiness = math.Clamp( ply.Sleepiness + 50, 0, 1000 )
					end
				elseif ( ply.Sleepiness > 950 ) then
					ply.Sleepiness = 1000
					ply:Wakeup()
				end

				AddThirst = -20
				AddHunger = -20

				if ( ply.NeedShelter ) then
					if ( ply:Health() >= 11 ) then
						ply:SetHealth( ply:Health() - 10 )
					else
						ply:Kill()
						for k, v in pairs( player.GetAll() ) do v:SendMessage( ply:Nick() .. " died in sleep.", 3, Color( 170, 0, 0, 255 ) ) end
					end
				end
			end

			if ( !ply:GetNWBool( "AFK" ) ) then

				// Oxygen
				if ( ply:WaterLevel() > 2 ) then
					if ( ply.Oxygen > 0 ) then
						ply.Oxygen = math.max( ply.Oxygen - math.min( 1600 / ply:GetSkill( "Swimming" ), 500 ), 0 )
						ply:IncXP( "Swimming", math.Clamp( math.Round( 50 / ply:GetSkill( "Swimming" ) ), 1, 1000 ) )
					end
				else
					if ( ply.Oxygen < 1000 ) then ply.Oxygen = math.min( ply.Oxygen + 100, 1000 ) end
				end 

				// Flashlight
				if ( ply:FlashlightIsOn() ) then
					if ( ply.Power > 0 ) then
						ply.Power = math.max( ply.Power - 5, 0 )
						if ( ply.Power < 5 ) then ply:Flashlight( false ) end
					end
				else
					local maxPow = 50
					if ( ply.Resources["Batteries"] ) then maxPow = math.min( maxPow + ply.Resources["Batteries"] * 50, 500 ) end
					if ( ply.Power < maxPow ) then ply.Power = math.min( ply.Power + 10, maxPow ) end
				end

				if ( ply.Sleepiness > 0 ) then ply.Sleepiness = math.Clamp( ply.Sleepiness - 2, 0, 1000 ) end
				if ( ply.Thirst > 0 ) then ply.Thirst = math.Clamp( ply.Thirst + AddThirst, 0, 1000 ) end
				if ( ply.Hunger > 0 ) then ply.Hunger = math.Clamp( ply.Hunger + AddHunger, 0, 1000 ) end
			end

			ply:UpdateNeeds()

			--Are you dying?
			if ( ply.Sleepiness <= 0 or ply.Thirst <= 0 or ply.Hunger <= 0 ) then
				if ( ply:Health() >= 3 ) then
					ply:SetHealth( ply:Health() - 2 )
					ply:ScreenFade( SCREENFADE.IN, Color( 255, 0, 0 ), 0.7, 0 )
					ply:ViewPunch( Angle( math.random( 6, -6 ), math.random( 4, -4 ), 0 ) )
				else
					ply:Kill()
					for k, v in pairs( player.GetAll() ) do v:SendMessage( ply:Nick() .. " didn't survive.", 3, Color( 170, 0, 0, 255 ) ) end
				end
			end
			
			if ( ply.Oxygen <= 0 ) then
				if ( ply:Health() >= 9 ) then
					ply:SetHealth( ply:Health() - 8 )
					ply:EmitSound( "player/pl_drown" .. math.random( 1, 3 ) .. ".wav", 100, math.random( 95, 105 ) )
					ply:ScreenFade( SCREENFADE.IN, Color( 0, 0, 255 ), 0.7, 0)
					ply:ViewPunch( Angle( math.random( 6, -6 ), 0, 0 ) )
				else
					ply:Kill()
					for k, v in pairs( player.GetAll() ) do v:SendMessage( ply:Nick() .. " has drowned.", 3, Color( 170, 0, 0, 255 ) ) end
				end
			end
		end
	end
end )

/* NPC Looting and hunting */

function GM:OnNPCKilled( npc, killer, weapon )

	if ( npc != killer ) then self.BaseClass.OnNPCKilled( self, npc, killer, weapon ) end
	npc:Fadeout( 5 )

	if ( !killer:IsPlayer() ) then return end
	killer:SetFrags( killer:Frags() + 1 )

	if ( !npc:IsLootableNPC() ) then return end

	local loot = ents.Create( "gms_loot" )
	SPropProtection.PlayerMakePropOwner( killer, loot )

	loot.Resources = { Meat = math.random( 1, 3 ) } 
	loot:SetPos( npc:GetPos() + Vector( 0, 0, 64 ) )
	loot:Spawn()
	timer.Simple( 180, function() if ( loot:IsValid() ) then loot:Fadeout( 2 ) end end )

	killer:IncXP( "Hunting", math.Clamp( math.Round( 50 / killer:GetSkill( "Hunting" ) ), 1, 1000 ) )
end

/* Use Hook */
hook.Add( "KeyPress", "GMS_UseKeyHook", function( ply, key )
	if ( key != IN_USE ) then return end
	if ( ply:KeyDown( 1 ) ) then return end

	local tr = ply:TraceFromEyes( 128 )
	if ( tr.HitNonWorld && IsValid( tr.Entity ) && !GMS.IsInWater( tr.HitPos ) ) then
		local ent = tr.Entity
		local mdl = tr.Entity:GetModel()
		local cls = tr.Entity:GetClass()

		if ( ( ent:IsFoodModel() or cls == "gms_food" ) and ( ( ply:GetPos() - ent:LocalToWorld( ent:OBBCenter() ) ):Length() <= 128 ) and SPropProtection.PlayerCanTouch( ply, ent ) ) then
			if ( cls == "gms_food" ) then
				ply:DoProcess( "EatFood", 3, { Entity = ent } )
			else
				ply:DoProcess( "EatFruit", 2, { Entity = ent } )
			end
		elseif ( ent:IsTreeModel() ) then
			if ( !ply:HasUnlock( "Sprout_Collecting" ) ) then ply:SendMessage( "You don't have enough skill.", 3, Color( 200, 0, 0, 255 ) ) return end
			ply:DoProcess( "SproutCollect", 5 )
		elseif ( cls == "gms_resourcedrop" and ( ply:GetPos() - tr.HitPos ):Length() <= 128 and SPropProtection.PlayerCanTouch( ply, ent ) ) then
			ply:PickupResourceEntity( ent )
		elseif ( ( cls == "gms_resourcepack" or cls == "gms_fridge" ) and ( ply:GetPos() - tr.HitPos ):Length() <= 128 and SPropProtection.PlayerCanTouch( ply, ent ) ) then
			ply:ConCommand( "gms_openrespackmenu" )
		elseif ( ent:IsOnFire() && SPropProtection.PlayerCanTouch( ply, ent ) ) then
			if ( GetConVarNumber( "gms_campfire" ) == 1 ) then ply:OpenCombiMenu( "Cooking" ) end
		end
	elseif ( tr.HitWorld ) then
		for k, v in pairs( ents.FindInSphere( tr.HitPos, 100 ) ) do
			if ( v:IsGrainModel() && SPropProtection.PlayerCanTouch( ply, v ) ) then
				ply:DoProcess( "HarvestGrain", 3, { Entity = v } )
				return
			elseif ( v:IsBerryBushModel() && SPropProtection.PlayerCanTouch( ply, v ) ) then
				ply:DoProcess( "HarvestBush", 3, { Entity = v } )
				return
			end
		end
		if ( ( tr.MatType == MAT_DIRT or tr.MatType == MAT_GRASS or tr.MatType == MAT_SAND or tr.MatType == MAT_SNOW ) and !GMS.IsInWater( tr.HitPos ) ) then
			local time = 5
			if ( IsValid( ply:GetActiveWeapon() ) && ply:GetActiveWeapon():GetClass() == "gms_shovel" ) then time = 2 end
			ply:DoProcess( "Foraging", time )
		end
	end

	local trace = {}
	trace.start = ply:GetShootPos()
	trace.endpos = trace.start + ( ply:GetAimVector() * 150 )
	trace.mask = bit.bor( MASK_WATER, MASK_SOLID )
	trace.filter = ply

	local tr2 = util.TraceLine( trace )
	if ( ( tr2.Hit && tr2.MatType == MAT_SLOSH && ply:WaterLevel() > 0 ) or ply:WaterLevel() == 3 ) then
		ply.Thirst = math.min( ply.Thirst + 50, 1000 )
		if ( !ply.Hasdrunk ) then
			ply:EmitSound( Sound( "npc/barnacle/barnacle_gulp" .. math.random( 1, 2 ) .. ".wav" ), 100, math.random( 95, 105 ) )
			ply.Hasdrunk = true
			timer.Simple( 0.9, function() ply.Hasdrunk = false end, ply )
		end
		ply:UpdateNeeds()
	elseif ( GMS.IsInWater( tr.HitPos ) && !tr.HitNonWorld ) then
		ply:DoProcess( "BottleWater", 3 )
	end
end )

/* Saving / loading functions */

-- Commands
concommand.Add( "gms_admin_savemap", function( ply, cmd, args )
	if ( IsValid( ply ) && !ply:IsAdmin() ) then ply:SendMessage( "You need admin rights for this!", 3, Color( 200, 0, 0, 255 ) ) return end
	if ( !args[ 1 ] or string.Trim( args[ 1 ] ) == "" ) then return end
	GAMEMODE:PreSaveMap( string.Trim( args[1] ) )
end )

concommand.Add( "gms_admin_loadmap", function( ply, cmd, args )
	if ( IsValid( ply ) && !ply:IsAdmin() ) then ply:SendMessage( "You need admin rights for this!", 3, Color( 200, 0 ,0, 255 ) ) return end
	if ( !args[ 1 ] or string.Trim( args[ 1 ] ) == "" ) then return end
	GAMEMODE:PreLoadMap( string.Trim( args[ 1 ] ) )
end )

concommand.Add( "gms_admin_deletemap", function( ply, cmd, args )
	if ( IsValid( ply ) && !ply:IsAdmin() ) then ply:SendMessage( "You need admin rights for this!", 3, Color( 200, 0, 0, 255 ) ) return end
	if ( !args[ 1 ] or string.Trim( args[ 1 ] ) == "" ) then return end
	GAMEMODE:DeleteSavegame( string.Trim( args[ 1 ] ) )
end )

--Delete map
function GM:DeleteSavegame( name )
	if ( !file.Exists( "gmstranded/gamesaves/" .. name .. ".txt", "DATA" ) ) then return end
	file.Delete( "gmstranded/gamesaves/" .. name .. ".txt" )
	if ( file.Exists( "gmstranded/gamesaves/" .. name .. "_info.txt", "DATA" ) ) then file.Delete( "gmstranded/gamesaves/" .. name .. "_info.txt" ) end

	for k, ply in pairs( player.GetAll() ) do
		if( ply:IsAdmin() ) then
			umsg.Start( "gms_RemoveLoadGameFromList", ply )
				umsg.String( name )
			umsg.End()
		end
	end
end

--Save map
function GM:PreSaveMap( name )
	if ( CurTime() < 3 ) then return end
	if ( CurTime() < self.NextSaved ) then return end

	for k, ply in pairs( player.GetAll() ) do
		ply:MakeSavingBar( "Saving game as \"" .. name .. "\"" )
	end

	self.NextSaved = CurTime() + 0.6
	timer.Simple( 0.5, function() self:SaveMap( name ) end )
end

function GM:SaveMap( name )
	local savegame = {}
	savegame["name"] = name
	savegame["entries"] = {}

	savegame_info = {}
	savegame_info["map"] = game.GetMap()
	savegame_info["date"] = os.date( "%A %m/%d/%y" )

	for k, ent in pairs( ents.GetAll() ) do
		if ( !IsValid( ent ) || ent:CreatedByMap() || !table.HasValue( GMS.SavedClasses, ent:GetClass() ) ) then continue end
		if ( ent.GMSAutoSpawned ) then continue end
		local entry = {}

		entry["class"] = ent:GetClass()
		entry["model"] = ent:GetModel()

		entry["owner"] = ent:GetNWString( "Owner" )
		entry["ownerid"] = ent:GetNWInt( "OwnerID" )
		entry["tribeid"] = ent:GetNWInt( "TribeID" )

		if ( ent.Children != nil ) then entry[ "Children" ] = ent.Children end
		if ( ent.IsPlantChild ) then entry["PlantParentName"] = ent.PlantParentName end
		if ( ent.IsPlant ) then entry["PlantName"] = ent:GetName() end

		entry["color"] = ent:GetColor()
		entry["pos"] = ent:GetPos()
		entry["angles"] = ent:GetAngles()
		entry["material"] = ent:GetMaterial() or "0"
		entry["keyvalues"] = ent:GetKeyValues()
		entry["table"] = ent:GetTable()
		entry["solid"] = ent:GetSolid()

		local phys = ent:GetPhysicsObject()

		if ( IsValid( phys ) ) then
			entry["freezed"] = phys:IsMoveable()
			entry["sleeping"] = phys:IsAsleep()
		end

		if ( entry["class"] == "gms_resourcedrop" ) then entry["type"] = ent.Type entry["amount"] = ent.Amount end // ResDrop

		table.insert( savegame["entries"], entry )

	end

	if ( !file.IsDir( "gmstranded", "DATA" ) ) then file.CreateDir( "gmstranded" ) end
	if ( !file.IsDir( "gmstranded/gamesaves", "DATA" ) ) then file.CreateDir( "gmstranded/gamesaves" ) end

	file.Write( "gmstranded/gamesaves/" .. name .. ".txt", util.TableToJSON( savegame ) )
	file.Write( "gmstranded/gamesaves/" .. name .. "_info.txt", util.TableToJSON( savegame_info ) )

	for k, ply in pairs( player.GetAll() ) do
		ply:SendMessage( "Saved game \"" .. name .. "\".", 3, Color( 255, 255, 255, 255 ) )
		ply:StopSavingBar()

		if ( ply:IsAdmin() ) then
			umsg.Start( "gms_AddLoadGameToList", ply )
			umsg.String( name )
			umsg.End()
		end
	end
end

--Load map
function GM:PreLoadMap( name )
	if ( CurTime() < 3 ) then return end
	if ( CurTime() < self.NextLoaded ) then return end
	if ( !file.Exists( "gmstranded/gamesaves/" .. name .. ".txt", "DATA" ) ) then return end

	game.CleanUpMap()
	
	for k, ply in pairs( player.GetAll() ) do ply:MakeLoadingBar( "Savegame \"" .. name .. "\"" ) end

	self.NextLoaded = CurTime() + 0.6
	timer.Simple( 0.5, function() self:LoadMap( name ) end )
end

function GM:LoadMap( name )
	local savegame = util.JSONToTable( file.Read( "gmstranded/gamesaves/" .. name .. ".txt" ) )
	local num = table.Count( savegame["entries"] )

	if ( num == 0 ) then
		for k, ply in pairs( player.GetAll() ) do
			ply:SendMessage( "This savegame is empty!", 3, Color( 255, 255, 255, 255 ) )
			ply:StopLoadingBar()
		end
	return end
	
	Time = DayTime

	self:LoadMapEntity( savegame, num, 1 )
end

--Don't load it all at once
function GM:LoadMapEntity( savegame, max, k )
	local entry = savegame["entries"][k]

	local ent = ents.Create( entry["class"] )
	
	if ( !entry["model"] ) then
		print( "WARNING! " .. entry["class"] .. " doesn't have a model!" )
	else
		ent:SetModel( entry["model"] )
	end
	

	ent:SetColor( entry["color"] )
	ent:SetPos( entry["pos"] )
	ent:SetAngles( entry["angles"] )

	if ( entry["Children"] ) then ent.Children = entry[ "Children" ] end
	if ( entry["PlantParentName"] ) then ent.PlantParentName = entry["PlantParentName"] end
	if ( entry["PlantName"] ) then ent:SetName( entry["PlantName"] ) end
	if ( entry["material"] != "0" ) then ent:SetMaterial( entry["material"] ) end
	if ( entry["solid"] ) then ent:SetSolid( entry["solid"] ) end

	for k, v in pairs( entry["keyvalues"] ) do ent:SetKeyValue( k, v ) end
	for k, v in pairs( entry["table"] ) do ent[ k ] = v end

	ent:Spawn()

	if ( entry["table"].Resources ) then
		ent.Resources = {}
		for k1, v1 in pairs( entry["table"].Resources ) do ent.Resources[ k1 ] = tonumber( v1 ) end
	end

	if ( player.FindByName( entry["owner"] ) ) then
		if ( ent.IsPlant ) then ent:SetNWEntity( "plantowner", player.FindByName( entry["owner"] ) ) end
		SPropProtection.PlayerMakePropOwner( player.FindByName( entry["owner"] ), ent )
	elseif ( entry["owner"] == "World" ) then
		ent:SetNetworkedString( "Owner", entry["owner"] )
	end

	if ( entry["class"] == "gms_resourcedrop" ) then // RP
		ent.Type = entry["type"]
		ent.Amount = entry["amount"]
		ent:SetResourceDropInfo( ent.Type, ent.Amount )
	end

	local phys = ent:GetPhysicsObject()
	if ( phys and phys != NULL and phys:IsValid() ) then
		phys:EnableMotion( entry["freezed"] )
		if ( entry["sleeping"] ) then phys:Sleep() else phys:Wake() end
	end

	if ( k >= max ) then
		for k, ply in pairs( player.GetAll() ) do
			ply:SendMessage( "Loaded game \"" .. savegame[ "name" ] .. "\" ( " .. max .. " entries )", 3, Color( 255, 255, 255, 255 ) )
			ply:StopLoadingBar()
		end

		-- Fix all plants
		for id, ent in pairs( ents.GetAll() ) do
			if ( ent.IsPlantChild ) then
				ent.PlantParent = ents.FindByName( ent.PlantParentName )[ 1 ]
				if ( !IsValid( ent.PlantParent ) ) then continue end
				ent.PlantParent:SetName( "gms_plant" .. ent.PlantParent:EntIndex() )
				ent.PlantParentName = ent.PlantParent:GetName()
			end
		end

		local time = 0
		for _, v in ipairs( table.Add( ents.FindByClass( "gms_resourcepack" ), ents.FindByClass( "gms_fridge" ) ) ) do
			for res, num in pairs( v.Resources ) do
				timer.Simple( time, function()
					umsg.Start( "gms_SetResPackInfo", rp )
					umsg.String( v:EntIndex() )
					umsg.String( string.gsub( res, "_", " " ) )
					umsg.Short( num )
					umsg.End()
				end )
				time = time + 0.1
			end
			time = time + 0.1
		end
	else
		timer.Simple( 0.05, function() self:LoadMapEntity( savegame, max, k + 1 ) end )
	end
end

/* Misc functions */
hook.Add( "Think", "GM_WaterExtinguish", function()
	for _, v in ipairs( ents.FindByClass( "prop_phy*" ) ) do
		if ( v:WaterLevel() > 0 and v:IsOnFire() ) then
			v:Extinguish()
			timer.Remove( "gms_removecampfire_" .. v:EntIndex() )
		end 
	end
end )

function GM:PlayerSwitchFlashlight( ply, SwitchOn )
	return ( ply.Power > 25 && ply.Resources[ "Flashlight" ] != nil && ply.Resources[ "Flashlight" ] > 0 ) or !SwitchOn
end

local AlertSoundsHunger = { "stranded/need_hunger1.wav", "stranded/need_hunger2.wav" }
local AlertSoundsThirst = { "stranded/need_thirst1.wav" }
local AlertSoundsSleep = { "stranded/need_sleepiness1.wav", "stranded/need_sleepiness2.wav", "stranded/need_sleepiness3.wav", "stranded/need_sleepiness4.wav" }

/* Alert Messages */
timer.Create( "AlertTimer", 6, 0, function()
	//if ( GetConVarNumber( "gms_alerts" ) != 1 ) then return end
	for k, ply in pairs( player.GetAll() ) do 
		if ( !ply:Alive() ) then continue end
		if ( ply.Hunger < 125 ) then ply:EmitSound( Sound( AlertSoundsHunger[ math.random( 1, #AlertSoundsHunger ) ] ), 100, math.random( 95, 105 ) ) end
		if ( ply.Thirst < 125 ) then ply:EmitSound( Sound( AlertSoundsThirst[ math.random( 1, #AlertSoundsThirst ) ] ), 100, math.random( 95, 105 ) ) end
		if ( ply.Sleepiness < 125 ) then ply:EmitSound( Sound( AlertSoundsSleep[ math.random( 1, #AlertSoundsSleep ) ] ), 100, math.random( 95, 105 ) ) end
	end
end )

/* Tribe system */
function CreateTribe( ply, name, red, green, blue, password )

	name = string.Trim( name )
	if ( name == "" ) then ply:SendMessage( "You should enter tribe name!", 5, Color( 255, 50, 50, 255 ) ) return end
	for id, tribe in pairs( GAMEMODE.Tribes ) do
		if ( tribe.name == name ) then ply:SendMessage( "Tribe with this name already exists!", 5, Color( 255, 50, 50, 255 ) ) return end
	end

	local id = table.insert( GAMEMODE.Tribes, {
		name = name,
		color = Color( red, green, blue ),
		password = password or false
	} )

	local rp = RecipientFilter()
	rp:AddAllPlayers()

	umsg.Start( "sendTribe", rp )
		umsg.Short( id )
		umsg.String( name )
		umsg.Vector( Vector( red, green, blue ) )
		if ( Password == false ) then
			umsg.Bool( false )
		else
			umsg.Bool( true )
		end
	umsg.End()

	team.SetUp( id, name, Color( red, green, blue ) )
	ply:SetTeam( id )
	ply:UpdatePlayerColor()
	SPropProtection.TribePP( ply )
	ply:SendMessage( "Successfully created " .. name .. ".", 5, Color( 255, 255, 255, 255 ) )
	
end

function GM.CreateTribeCmd( ply, cmd, args, argv )
	if ( !args[4] or args[4] == "" ) then ply:ChatPrint( "Syntax is: gms_createtribe \"tribename\" red green blue [password( optional )]" ) return end
	if ( args[5] and args[5] != "" ) then
		CreateTribe( ply, args[1], args[2], args[3], args[4], args[5] )
	else
		CreateTribe( ply, args[1], args[2], args[3], args[4], "" )
	end
end
concommand.Add( "gms_createtribe", GM.CreateTribeCmd )

function GM.JoinTribeCmd( ply, cmd, args )
	if ( !args[ 1 ] || args[ 1 ] == "" ) then ply:ChatPrint( "Syntax is: gms_join \"tribename\" [password( if needed )]" ) return end
	for id, v in pairs( GAMEMODE.Tribes ) do
		if ( string.lower( v.name ) != string.lower( args[1] ) ) then continue end

		if ( v.password && v.password != args[ 2 ] ) then ply:SendMessage( "Incorrcet tribal password", 3, Color( 255, 50, 50, 255 ) ) return end
		
		ply:SetTeam( id )
		ply:UpdatePlayerColor()
		SPropProtection.TribePP( ply )
		ply:SendMessage( "Joined " .. v.name .. ".", 5, Color( 255, 255, 255, 255 ) )
		for id, pl in pairs( player.GetAll() ) do
			if ( pl:Team() == ply:Team() && pl != ply ) then pl:SendMessage( ply:Name() .. " joined the tribe.", 5, Color( 255, 255, 255, 255 ) ) end
		end
	end
	SPropProtection.CheckForEmptyTribes()
end
concommand.Add( "gms_join", GM.JoinTribeCmd )

function GM.LeaveTribeCmd( ply, cmd, args )
	ply:SetTeam( 1 )
	SPropProtection.TribePP( ply )
	ply:SendMessage( "Left the tribe.", 5, Color( 255, 255, 255, 255 ) )
	SPropProtection.CheckForEmptyTribes()

	for id, pl in pairs( player.GetAll() ) do
		if ( pl:Team() == ply:Team() && pl != ply ) then pl:SendMessage( ply:Name() .. " left the tribe.", 5, Color( 255, 255, 255, 255 ) ) end
	end
end
concommand.Add( "gms_leave", GM.LeaveTribeCmd )

/* Resource Box Touch */
function big_gms_combineresource( ent_a, ent_b )
	local ent_a_owner = ent_a:GetNWString( "Owner" )
	local ent_b_owner = ent_b:GetNWString( "Owner" )
	local ply = player.GetByID( ent_a:GetNWInt( "OwnerID" ) )
	local plyb = player.GetByID( ent_b:GetNWInt( "OwnerID" ) )

	if ( ent_a_owner != nil and ent_b_owner != nil and ply != nil ) then
		if ( ent_a_owner == ent_b_owner or ( SPropProtection.PlayerCanTouch( ply, ent_b ) and SPropProtection.PlayerCanTouch( plyb, ent_a ) ) ) then
			ent_a.Amount = ent_a.Amount + ent_b.Amount
			ent_a:SetResourceDropInfoInstant( ent_a.Type, ent_a.Amount )
			ent_b:Remove()
		end
	end
end

/* Resource box touches Resource pack */
function big_gms_combineresourcepack( respack, ent_b )
	local ent_a_owner = respack:GetNWString( "Owner" )
	local ent_b_owner = ent_b:GetNWString( "Owner" )
	local ply = player.GetByID( respack:GetNWInt( "OwnerID" ) )
	local plyb = player.GetByID( ent_b:GetNWInt( "OwnerID" ) )

	if ( ent_a_owner != nil and ent_b_owner != nil and ply != nil ) then
		if ( ent_a_owner == ent_b_owner or ( SPropProtection.PlayerCanTouch( ply, ent_b ) and SPropProtection.PlayerCanTouch( plyb, respack ) ) ) then
			if ( respack.Resources[ ent_b.Type ] ) then
				respack.Resources[ ent_b.Type ] = respack.Resources[ ent_b.Type ] + ent_b.Amount
			else
				respack.Resources[ ent_b.Type ] = ent_b.Amount
			end
			respack:SetResPackInfo( ent_b.Type, respack.Resources[ ent_b.Type ] )
			ent_b:Remove()
		end
	end
end

/* Food touches Fridge */
function big_gms_combinefood( fridge, food )
	local ent_a_owner = fridge:GetNWString( "Owner" )
	local ent_b_owner = food:GetNWString( "Owner" )
	local ply = player.GetByID( fridge:GetNWInt( "OwnerID" ) )
	local plyb = player.GetByID( food:GetNWInt( "OwnerID" ) )
	local foodname = string.gsub( food.Name, " ", "_" )

	if ( ent_a_owner != nil and ent_b_owner != nil and ply != nil ) then
		if ( ent_a_owner == ent_b_owner or ( SPropProtection.PlayerCanTouch( ply, food ) and SPropProtection.PlayerCanTouch( plyb, fridge ) ) ) then
			if ( fridge.Resources[ foodname ] ) then
				fridge.Resources[ foodname ] = fridge.Resources[ foodname ] + 1
			else
				fridge.Resources[ foodname ] = 1
			end
			fridge:SetResPackInfo( foodname, fridge.Resources[ foodname ] )
			food:Remove()
		end
	end
end

/* Resource Box Buildsite Touch */
function gms_addbuildsiteresource( ent_resourcedrop, ent_buildsite )
	local ent_resourcedrop_owner = ent_resourcedrop:GetNWString( "Owner" )
	local ent_buildsite_owner = ent_buildsite:GetNWString( "Owner" )
	local ply = player.GetByID( ent_resourcedrop:GetNWInt( "OwnerID" ) )

	if ( ent_resourcedrop_owner != nil and ent_buildsite_owner != nil and ply != nil and ent_resourcedrop:IsPlayerHolding() ) then
		if ( SPropProtection.PlayerCanTouch( ply, ent_buildsite ) )  then
			if ( ent_resourcedrop.Amount > ent_buildsite.Costs[ent_resourcedrop.Type] ) then
				ent_resourcedrop.Amount = ent_resourcedrop.Amount - ent_buildsite.Costs[ent_resourcedrop.Type]
				ent_resourcedrop:SetResourceDropInfo( ent_resourcedrop.Type, ent_resourcedrop.Amount )
				ent_buildsite.Costs[ent_resourcedrop.Type] = nil
			elseif ( ent_resourcedrop.Amount <= ent_buildsite.Costs[ent_resourcedrop.Type] ) then
				ent_buildsite.Costs[ent_resourcedrop.Type] = ent_buildsite.Costs[ent_resourcedrop.Type] - ent_resourcedrop.Amount
				ent_resourcedrop:Remove() 
			end
			for k, v in pairs( ent_buildsite.Costs ) do
				if ( ent_buildsite.Costs[ent_resourcedrop.Type] ) then
					if ( ent_buildsite.Costs[ent_resourcedrop.Type] <= 0 ) then
						ent_buildsite.Costs[ent_resourcedrop.Type] = nil
					end
				end
			end 

			if ( table.Count( ent_buildsite.Costs ) > 0 ) then
				local str = "You need: "
				for k, v in pairs( ent_buildsite.Costs ) do
					str = str .. " " .. string.Replace( k, "_", " " ) .. " ( " .. v .. "x )"
				end

				str = str .. " to finish."
				ply:SendMessage( str, 5, Color( 255, 255, 255, 255 ) )
			else
				ply:SendMessage( "Finished!", 3, Color( 10, 200, 10, 255 ) )
				ent_buildsite:Finish()
			end
			
			local str = ":"
			for k, v in pairs( ent_buildsite.Costs ) do
				str = str .. " " .. string.Replace( k, "_", " " ) .. " ( " .. v .. "x )"
			end
			ent_buildsite:SetNetworkedString( "Resources", str )
		end
	end
end

/* Resource Pack Buildsite Touch */
function gms_addbuildsiteresourcePack( ent_resourcepack, ent_buildsite )
	local ent_resourcedrop_owner = ent_resourcepack:GetNWString( "Owner" )
	local ent_buildsite_owner = ent_buildsite:GetNWString( "Owner" )
	local ply = player.GetByID( ent_resourcepack:GetNWInt( "OwnerID" ) )

	if ( ent_resourcedrop_owner != nil and ent_buildsite_owner != nil and ply != nil and ent_resourcepack:IsPlayerHolding() ) then
		if ( SPropProtection.PlayerCanTouch( ply, ent_buildsite ) )  then
			for res, num in pairs( ent_resourcepack.Resources ) do
				if ( ent_buildsite.Costs[res] and num > ent_buildsite.Costs[res] ) then	
					ent_resourcepack.Resources[res] = num - ent_buildsite.Costs[res]
					ent_resourcepack:SetResPackInfo( res, ent_resourcepack.Resources[res] )
					ent_buildsite.Costs[res] = nil
				elseif ( ent_buildsite.Costs[res] and num <= ent_buildsite.Costs[res] ) then
					ent_buildsite.Costs[res] = ent_buildsite.Costs[res] - num
					ent_resourcepack:SetResPackInfo( res, 0 )
					ent_resourcepack.Resources[res] = nil
				end
				for k, v in pairs( ent_buildsite.Costs ) do
					if ( ent_buildsite.Costs[res] ) then
						if ( ent_buildsite.Costs[res] <= 0 ) then
							ent_buildsite.Costs[res] = nil
						end
					end
				end
			end

			if ( table.Count( ent_buildsite.Costs ) > 0 ) then
				local str = "You need: "
				for k, v in pairs( ent_buildsite.Costs ) do
					str = str .. " " .. string.Replace( k, "_", " " ) .. " ( " .. v .. "x )"
				end

				str = str .. " to finish."
				ply:SendMessage( str, 5, Color( 255, 255, 255, 255 ) )
			else
				ply:SendMessage( "Finished!", 3, Color( 10, 200, 10, 255 ) )
				ent_buildsite:Finish()
			end
			
			local str = ":"
			for k, v in pairs( ent_buildsite.Costs ) do
				str = str .. " " .. string.Replace( k, "_", " " ) .. " ( " .. v .. "x )"
			end
			ent_buildsite:SetNetworkedString( "Resources", str )
		end
	end
end

/* Resource Box versus Player Damage */
hook.Add( "PlayerShouldTakeDamage", "playershouldtakedamage", function( victim, attacker )
	if ( victim:IsPlayer() and ( attacker:GetClass() == "gms_resourcedrop" or attacker:IsPlayerHolding() or attacker:GetClass() == "gms_resourcepack" or attacker:GetClass() == "gms_fridge" or attacker:GetClass() == "gms_food" ) ) then
		return false
	end
	return true
end )
