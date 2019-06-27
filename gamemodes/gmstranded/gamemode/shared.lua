
/*
	Authors! The Stranded Team!
	jA_cOp, prop_dynamic, Chewgum, Wokkel, robotboy655

	READ THIS:
	If you want to add custom content or edit anything in gamemode - DO NOT. Please read customcontent.lua!

	ПРОЧТИ ЭТО:
	Если ты собираешься тут что либо изменять - НЕ ДЕЛАЙ ЭТОГО. Прочти файл customcontent.lua!
*/

DeriveGamemode( "sandbox" )

GM.Name = "Garry's Mod Stranded"
GM.Author = "Stranded Team"
GM.Email = "robotboy655@gmail.com"
GM.Website = ""

team.SetUp( 1, "The Stranded", Color( 200, 200, 0, 255 ) )
team.SetUp( 2, "Survivalists", Color( 255, 255, 255, 255 ) )
team.SetUp( 3, "Anonymous", Color( 0, 121, 145, 255 ) )
team.SetUp( 4, "The Gummies", Color( 255, 23, 0, 255 ) )
team.SetUp( 5, "The Dynamics", Color( 0, 72, 255, 255 ) )
team.SetUp( 6, "Scavengers", Color( 8, 255, 0, 255 ) )

GMS = GMS or {}

include( "spp/sh_spp.lua" )
include( "time_weather.lua" )

-- Shared includes
include( "unlocks.lua" )
include( "combinations.lua" )

/* ----------------------------------------------------------------------------------------------------
	Utility functions
---------------------------------------------------------------------------------------------------- */

function string.Capitalize( str )
	local str = string.Explode( "_", str )
	for k, v in pairs( str ) do
		str[ k ] = string.upper( string.sub( v, 1, 1 ) ) .. string.sub( v, 2 )
	end

	str = string.Implode( "_", str )
	return str
end

function player.FindByName( str )
	if ( str == nil or str == "" ) then return false end
	for id, ply in pairs( player.GetAll() ) do
		if ( string.find( string.lower( ply:Name() ), string.lower( str ) ) != nil ) then
			return ply
		end
	end
	return false
end

function GMS_IsAdminOnlyModel( mdl )
	if ( mdl == GMS.SmallRockModel ) then return true end
	if ( table.HasValue( GMS.EdibleModels, mdl ) ) then return true end
	if ( table.HasValue( GMS.RockModels, mdl ) ) then return true end
	if ( table.HasValue( GMS.AdditionalRockModels, mdl ) ) then return true end
	if ( table.HasValue( GMS.TreeModels, mdl ) ) then return true end
	if ( table.HasValue( GMS.AdditionalTreeModels, mdl ) ) then return true end
	return false
end

function GMS.ClassIsNearby( pos, class, range )
	local nearby = false
	for k, v in pairs( ents.FindInSphere( pos, range ) ) do
		if ( v:GetClass() == class and ( pos - Vector( v:LocalToWorld( v:OBBCenter() ).x, v:LocalToWorld( v:OBBCenter() ).y, pos.z ) ):Length() <= range ) then
			nearby = true
		end
	end

	return nearby
end

function GMS.IsInWater( pos )
	local trace = {}
	trace.start = pos
	trace.endpos = pos + Vector( 0, 0, 1 )
	trace.mask = bit.bor( MASK_WATER, MASK_SOLID )

	local tr = util.TraceLine( trace )
	return tr.Hit
end

/* ----------------------------------------------------------------------------------------------------
	Player Functions
---------------------------------------------------------------------------------------------------- */

local PlayerMeta = FindMetaTable( "Player" )

function PlayerMeta:IsDeveloper()
	if ( self:SteamID() == "STEAM_0:0:18313012" ) then return true end
	return false
end

/* ----------------------------------------------------------------------------------------------------
	Entity Functions
---------------------------------------------------------------------------------------------------- */

local EntityMeta = FindMetaTable( "Entity" )

function EntityMeta:IsTreeModel()
	if ( !IsValid( self ) || !self.GetModel || !self:GetModel() ) then return false end

	for k, v in pairs( GMS.TreeModels ) do
		if ( string.lower( v ) == string.lower( self:GetModel() ) or string.gsub( string.lower( v ), "/", "\\" ) == string.lower( self:GetModel() ) ) then return true end
	end

	for k, v in pairs( GMS.AdditionalTreeModels ) do
		if ( string.lower( v ) == string.lower( self:GetModel() ) or string.gsub( string.lower( v ), "/", "\\" ) == string.lower( self:GetModel() ) ) then return true end
	end

	-- Experemental
	if ( SERVER && string.find( self:GetModel(), "tree" ) && self:CreatedByMap() ) then return true end 

	return false
end

function EntityMeta:IsRockModel()
	if ( !IsValid( self ) ) then return false end

	local mdl = string.lower( self:GetModel() )

	if ( mdl == string.lower( GMS.SmallRockModel ) ) then return true end

	for k, v in pairs( GMS.RockModels ) do
		if ( string.lower( v ) == mdl or string.gsub( string.lower( v ), "/", "\\" ) == mdl ) then return true end
	end

	for k, v in pairs( GMS.AdditionalRockModels ) do
		if ( string.lower( v ) == mdl or string.gsub( string.lower( v ), "/", "\\" ) == mdl ) then return true end
	end
	
	-- Experemental
	if ( SERVER && string.find( self:GetModel(), "rock" ) && self:CreatedByMap() ) then return true end 

	return false
end

function EntityMeta:IsBerryBushModel()
	if ( !IsValid( self ) ) then return false end

	local mdl = "models/props/pi_shrub.mdl"
	if ( mdl == self:GetModel() or string.gsub( mdl, "/", "\\" ) == self:GetModel() ) then return true end

	return false
end

function EntityMeta:IsGrainModel()
	if ( !IsValid( self ) ) then return false end

	local mdl = "models/props_foliage/cattails.mdl"
	if ( mdl == self:GetModel() or string.gsub( mdl, "/", "\\" ) == self:GetModel() ) then return true end

	return false
end

function EntityMeta:IsFoodModel()
	if ( !IsValid( self ) ) then return false end

	for k, v in pairs( GMS.EdibleModels ) do
		if ( string.lower( v ) == string.lower( self:GetModel() ) or string.gsub( string.lower( v ), "/", "\\" ) == string.lower( self:GetModel() ) ) then
			return true
		end
	end

	return false
end

function EntityMeta:IsProp()
	if ( !IsValid( self ) ) then return false end

	local cls = self:GetClass()
	if ( cls == "prop_physics" or cls == "prop_physics_multiplayer" or cls == "prop_dynamic" ) then return true end

	return false
end

function EntityMeta:GetVolume()
	local min, max = self:OBBMins(), self:OBBMaxs()
	local vol = math.abs( max.x - min.x ) * math.abs( max.y - min.y ) * math.abs( max.z - min.z )
	return vol / ( 16 ^ 3 )
end

function EntityMeta:IsSleepingFurniture()
	for _, v in ipairs( GMS.SleepingFurniture ) do
		if ( string.lower( v ) == self:GetModel() or string.gsub( string.lower( v ), "/", "\\" ) == self:GetModel() ) then
			return true
		end
	end

	return false
end

function EntityMeta:IsPickupProhibitedModel()
	if ( !IsValid( self ) ) then return end
	return table.HasValue( GMS.PickupProhibitedClasses, self:GetClass() )
end

/* ----------------------------------------------------------------------------------------------------
	Shared Hooks ( for prediction )
---------------------------------------------------------------------------------------------------- */

function GM:PlayerNoClip( pl, on )
	if ( pl:InVehicle() ) then return false end
	if ( pl:IsDeveloper() || game.SinglePlayer() ) then return true end
	return false
end

function GM:PhysgunPickup( ply, ent )
	if ( !IsValid( ent ) ) then return self.BaseClass.PhysgunPickup( self, ply, ent ) end 
	if ( ent:IsRockModel() || ent:IsNPC() || ent:IsTreeModel() || ent:IsPlayer() || ent:IsFoodModel() || ent:IsPickupProhibitedModel() ) then return false end
	
	if ( !SPropProtection.PhysGravGunPickup( ply, ent ) ) then return false end
	
	return self.BaseClass.PhysgunPickup( self, ply, ent )
end

function GM:GravGunPunt( ply, ent )
	if ( !IsValid( ent ) ) then return self.BaseClass.GravGunPunt( self, ply, ent ) end 
	if ( ent:IsRockModel() || ent:IsNPC() || ent:IsTreeModel() || ent:IsPlayer() || ent:IsFoodModel() || ent:IsPickupProhibitedModel() || ent:GetClass() == "gms_buildsite" ) then return false end
	
	if ( !SPropProtection.PhysGravGunPickup( ply, ent ) ) then return false end
	
	return self.BaseClass.GravGunPunt( self, ply, ent )
end

function GM:GravGunPickupAllowed( ply, ent )
	if ( !IsValid( ent ) ) then return self.BaseClass.GravGunPickupAllowed( self, ply, ent ) end 
	if ( ent:IsRockModel() || ent:IsNPC() || ent:IsTreeModel() || ent:IsPlayer() || ent:IsFoodModel() || ent:IsPickupProhibitedModel() || ent:GetClass() == "gms_buildsite" ) then return false end
	
	if ( !SPropProtection.PhysGravGunPickup( ply, ent ) ) then return false end
	
	return self.BaseClass.GravGunPickupAllowed( self, ply, ent )
end

function GM:CanTool( ply, tr, mode )

	if ( mode == "gms_rope" ) then
		if ( SERVER && ply:GetResource( "Rope" ) < 1 ) then ply:SendMessage( "You need rope to use this tool.", 3, Color( 200, 0, 0, 255 ) ) return false end
		if ( CLIENT && ( !Resources[ "Rope" ] || Resources[ "Rope" ] < 1 ) ) then return false end
	end

	if ( mode == "weld" ) then
		if ( SERVER && ply:GetResource( "Welder" ) < 1 ) then ply:SendMessage( "You need a Welder to use this tool.", 3, Color( 200, 0, 0, 255 ) ) return false end
		if ( CLIENT && ( !Resources[ "Welder" ] || Resources[ "Welder" ] < 1 ) ) then return false end
	end

	if ( table.HasValue( GMS.ProhibitedStools, mode ) && !ply:IsAdmin() ) then ply:SendMessage( "This tool is prohibited.", 3, Color( 200, 0, 0, 255 ) ) return false end

	local ent = tr.Entity
	if ( !IsValid( ent ) && ent:GetClass() != "worldspawn" ) then return end 
	
	if ( !SPropProtection.PhysGravGunPickup( ply, ent ) ) then return false end

	if ( ent:IsRockModel() || ent:IsNPC() || ent:IsTreeModel() || ent:IsPlayer() || ent:IsFoodModel() || ent:IsPickupProhibitedModel() || ent:GetClass() == "gms_buildsite" ) then return false end

	return true
end

/* ----------------------------------------------------------------------------------------------------
	Config
---------------------------------------------------------------------------------------------------- */

GMS_SpawnLists = GMS_SpawnLists or {}

GMS_SpawnLists[ "Wood - Tables / Desks" ] = {
	"models/props_c17/FurnitureDrawer003a.mdl",
	"models/props_c17/FurnitureDrawer002a.mdl",
	"models/props_c17/FurnitureTable003a.mdl",
	"models/props_c17/FurnitureDrawer001a.mdl",
	"models/props_c17/FurnitureTable001a.mdl",
	"models/props_c17/FurnitureTable002a.mdl",
	"models/props_interiors/Furniture_Desk01a.mdl",
	"models/props_interiors/Furniture_Vanity01a.mdl",
	"models/props_wasteland/cafeteria_table001a.mdl"
}

GMS_SpawnLists[ "Wood - Shelving / Storage" ] = {
	"models/props_c17/FurnitureShelf001b.mdl",
	"models/props_wasteland/prison_shelf002a.mdl",
	"models/props_junk/wood_crate001a.mdl",
	"models/props_junk/wood_crate001a_damaged.mdl",
	"models/props_junk/wood_crate002a.mdl",
	"models/props_wasteland/laundry_cart002.mdl",
	"models/props_c17/FurnitureShelf001a.mdl",
	"models/props_interiors/Furniture_shelf01a.mdl",
	"models/props_c17/shelfunit01a.mdl",
	"models/props_c17/FurnitureDresser001a.mdl"
}

GMS_SpawnLists[ "Wood - Seating" ] = {
	"models/props_c17/FurnitureChair001a.mdl",
	"models/props_interiors/Furniture_chair01a.mdl",
	"models/props_c17/playground_swingset_seat01a.mdl",
	"models/props_c17/playground_teetertoter_seat.mdl",
	"models/props_wasteland/cafeteria_bench001a.mdl",
	"models/props_trainstation/BenchOutdoor01a.mdl",
	"models/props_c17/bench01a.mdl",
	"models/props_trainstation/bench_indoor001a.mdl"
}

GMS_SpawnLists[ "Wood - Doors / Plating / Beams" ] = {
	"models/props_debris/wood_board02a.mdl",
	"models/props_debris/wood_board04a.mdl",
	"models/props_debris/wood_board06a.mdl",
	"models/props_debris/wood_board01a.mdl",
	"models/props_debris/wood_board03a.mdl",
	"models/props_debris/wood_board05a.mdl",
	"models/props_debris/wood_board07a.mdl",
	"models/props_junk/wood_pallet001a.mdl",
	"models/props_wasteland/wood_fence02a.mdl",
	"models/props_wasteland/wood_fence01a.mdl",
	"models/props_c17/Frame002a.mdl",
	"models/props_wasteland/barricade001a.mdl",
	"models/props_wasteland/barricade002a.mdl",
	"models/props_docks/channelmarker_gib01.mdl",
	"models/props_docks/channelmarker_gib04.mdl",
	"models/props_docks/channelmarker_gib03.mdl",
	"models/props_docks/channelmarker_gib02.mdl",
	"models/props_docks/dock01_pole01a_128.mdl",
	"models/props_docks/dock02_pole02a_256.mdl",
	"models/props_docks/dock01_pole01a_256.mdl",
	"models/props_docks/dock02_pole02a.mdl",
	"models/props_docks/dock03_pole01a_256.mdl",
	"models/props_docks/dock03_pole01a.mdl"
}

GMS_SpawnLists[ "Iron - Kitchen/Appliances" ] = {
	"models/props_interiors/SinkKitchen01a.mdl",
	"models/props_interiors/Radiator01a.mdl",
	"models/props_c17/FurnitureWashingmachine001a.mdl",
	"models/props_c17/FurnitureFridge001a.mdl",
	"models/props_interiors/refrigerator01a.mdl",
	"models/props_c17/FurnitureBoiler001a.mdl",
	"models/props_c17/FurnitureFireplace001a.mdl",
	"models/props_wasteland/kitchen_counter001d.mdl",
	"models/props_wasteland/kitchen_counter001b.mdl",
	"models/props_wasteland/kitchen_counter001a.mdl",
	"models/props_wasteland/kitchen_counter001c.mdl",
	"models/props_wasteland/kitchen_stove001a.mdl",
	"models/props_wasteland/kitchen_stove002a.mdl",
	"models/props_wasteland/kitchen_fridge001a.mdl",
	"models/props_wasteland/laundry_dryer001.mdl",
	"models/props_wasteland/laundry_dryer002.mdl",
	"models/props_wasteland/laundry_washer003.mdl",
	"models/props_wasteland/laundry_washer001a.mdl",
	"models/props_wasteland/laundry_basket001.mdl",
	"models/props_wasteland/laundry_basket002.mdl"
}

GMS_SpawnLists[ "Iron - Shelving/Storage" ] = {
	"models/props_c17/FurnitureShelf002a.mdl",
	"models/props_lab/filecabinet02.mdl",
	"models/props_wasteland/controlroom_filecabinet002a.mdl",
	"models/props_wasteland/controlroom_storagecloset001a.mdl",
	"models/props_wasteland/kitchen_shelf002a.mdl",
	"models/props_wasteland/kitchen_shelf001a.mdl",
	"models/props_c17/display_cooler01a.mdl"
}

/*GMS_SpawnLists[ "Iron - Cargo/Tanks" ] = {
	"models/props_wasteland/cargo_container01.mdl",
	"models/props_wasteland/cargo_container01b.mdl",
	"models/props_wasteland/cargo_container01c.mdl",
	"models/props_wasteland/horizontalcoolingtank04.mdl",
	"models/props_wasteland/coolingtank02.mdl",
	"models/props_wasteland/coolingtank01.mdl",
	"models/props_junk/TrashDumpster01a.mdl",
	"models/props_junk/TrashDumpster02.mdl"
}

GMS_SpawnLists[ "Iron - Lighting" ] = {
	"models/props_c17/light_cagelight02_on.mdl",
	"models/props_c17/light_cagelight01_on.mdl",
	"models/props_wasteland/prison_lamp001c.mdl",
	"models/props_wasteland/prison_lamp001a.mdl",
	"models/props_wasteland/prison_lamp001b.mdl",
	"models/props_c17/lamp_standard_off01.mdl",
	"models/props_c17/lamp_bell_on.mdl",
	"models/props_c17/light_decklight01_on.mdl",
	"models/props_c17/light_floodlight02_off.mdl",
	"models/props_wasteland/light_spotlight02_base.mdl",
	"models/props_wasteland/light_spotlight02_lamp.mdl",
	"models/props_wasteland/light_spotlight01_base.mdl",
	"models/props_wasteland/light_spotlight01_lamp.mdl",
	"models/props_trainstation/Column_Light001b.mdl",
	"models/props_trainstation/Column_Light001a.mdl",
	"models/props_trainstation/light_128wallMounted001a.mdl",
	"models/props_c17/LampFixture01a.mdl",
	"models/props_c17/lamppost03a_on.mdl",
	"models/props_c17/Traffic_Light001a.mdl",
	"models/props_trainstation/TrackLight01.mdl",
	"models/props_trainstation/light_Signal002a.mdl",
	"models/props_trainstation/light_Signal001a.mdl",
	"models/props_trainstation/light_Signal001b.mdl"
}*/

GMS_SpawnLists[ "Iron - Containers" ] = {
	"models/props_junk/garbage_metalcan001a.mdl",
	"models/props_junk/garbage_metalcan002a.mdl",
	"models/props_junk/PopCan01a.mdl",
	"models/props_interiors/pot01a.mdl",
	"models/props_c17/metalPot002a.mdl",
	"models/props_interiors/pot02a.mdl",
	"models/props_c17/metalPot001a.mdl",
	"models/props_junk/metal_paintcan001a.mdl",
	"models/props_junk/metalgascan.mdl",
	"models/props_junk/MetalBucket01a.mdl",
	"models/props_junk/MetalBucket02a.mdl",
	"models/props_trainstation/trashcan_indoor001b.mdl",
	"models/props_trainstation/trashcan_indoor001a.mdl",
	"models/props_c17/oildrum001.mdl",
	"models/props_c17/canister01a.mdl",
	"models/props_c17/canister02a.mdl",
	"models/props_c17/canister_propane01a.mdl"
}

GMS_SpawnLists[ "Iron - Signs" ] = {
	"models/props_c17/streetsign005d.mdl",
	"models/props_c17/streetsign005c.mdl",
	"models/props_c17/streetsign005b.mdl",
	"models/props_c17/streetsign004f.mdl",
	"models/props_c17/streetsign004e.mdl",
	"models/props_c17/streetsign003b.mdl",
	"models/props_c17/streetsign002b.mdl",
	"models/props_c17/streetsign001c.mdl",
	"models/props_trainstation/TrackSign01.mdl",
	"models/props_trainstation/clock01.mdl",
	"models/props_trainstation/trainstation_clock001.mdl"
}

GMS_SpawnLists[ "Copper - Signs" ] = {
	"models/props_trainstation/TrackSign02.mdl",
	"models/props_trainstation/TrackSign03.mdl",
	"models/props_trainstation/TrackSign10.mdl",
	"models/props_trainstation/TrackSign09.mdl",
	"models/props_trainstation/TrackSign08.mdl",
	"models/props_trainstation/TrackSign07.mdl"
}

GMS_SpawnLists[ "Iron - Rails" ] = {
	"models/props_trainstation/handrail_64decoration001a.mdl",
	"models/props_c17/Handrail04_short.mdl",
	"models/props_c17/Handrail04_Medium.mdl",
	"models/props_c17/Handrail04_corner.mdl",
	"models/props_c17/Handrail04_long.mdl",
	"models/props_c17/Handrail04_SingleRise.mdl",
	"models/props_c17/Handrail04_DoubleRise.mdl"
}

GMS_SpawnLists[ "Copper - Fencing" ] = {
	"models/props_wasteland/interior_fence002a.mdl",
	"models/props_wasteland/interior_fence002e.mdl",
	"models/props_wasteland/interior_fence001g.mdl",
	"models/props_wasteland/interior_fence002f.mdl",
	"models/props_wasteland/interior_fence002c.mdl",
	"models/props_wasteland/interior_fence002d.mdl",
	"models/props_wasteland/interior_fence004b.mdl",
	"models/props_wasteland/interior_fence004a.mdl",
	"models/props_wasteland/exterior_fence002a.mdl",
	"models/props_wasteland/exterior_fence003a.mdl",
	"models/props_wasteland/exterior_fence003b.mdl",
	"models/props_wasteland/exterior_fence002c.mdl",
	"models/props_wasteland/exterior_fence002d.mdl",
	"models/props_wasteland/exterior_fence001a.mdl",
	"models/props_wasteland/exterior_fence002e.mdl"
}

GMS_SpawnLists[ "Iron - Doors/Plating/Beams" ] = {
	"models/props_c17/door02_double.mdl",
	"models/props_c17/door01_left.mdl",
	"models/props_borealis/borealis_door001a.mdl",
	"models/props_interiors/refrigeratorDoor02a.mdl",
	"models/props_interiors/refrigeratorDoor01a.mdl",
	"models/props_building_details/Storefront_Template001a_Bars.mdl",
	"models/props_c17/gate_door01a.mdl",
	"models/props_c17/gate_door02a.mdl",
	"models/props_junk/ravenholmsign.mdl",
	"models/props_debris/metal_panel02a.mdl",
	"models/props_debris/metal_panel01a.mdl",
	"models/props_junk/TrashDumpster02b.mdl",
	"models/props_lab/blastdoor001a.mdl",
	"models/props_lab/blastdoor001b.mdl",
	"models/props_lab/blastdoor001c.mdl",
	"models/props_trainstation/trainstation_post001.mdl",
	"models/props_c17/signpole001.mdl",
	"models/props_junk/harpoon002a.mdl",
	"models/props_c17/metalladder002b.mdl",
	"models/props_c17/metalladder002.mdl",
	"models/props_c17/metalladder003.mdl",
	"models/props_c17/metalladder001.mdl",
	"models/props_junk/iBeam01a.mdl",
	"models/props_junk/iBeam01a_cluster01.mdl"
}

GMS_SpawnLists[ "Iron - Vehicles" ] = {
	"models/props_junk/Wheebarrow01a.mdl",
	"models/props_junk/PushCart01a.mdl",
	"models/props_wasteland/gaspump001a.mdl",
	"models/props_wasteland/wheel01.mdl",
	"models/props_wasteland/wheel01a.mdl",
	"models/props_wasteland/wheel03b.mdl",
	"models/props_wasteland/wheel02b.mdl",
	"models/props_wasteland/wheel02a.mdl",
	"models/props_wasteland/wheel03a.mdl",
	"models/props_citizen_tech/windmill_blade002a.mdl",
	"models/airboat.mdl",
	"models/buggy.mdl",
	"models/props_vehicles/car002a_physics.mdl",
	"models/props_vehicles/car001b_hatchback.mdl",
	"models/props_vehicles/car001a_hatchback.mdl",
	"models/props_vehicles/car003a_physics.mdl",
	"models/props_vehicles/car003b_physics.mdl",
	"models/props_vehicles/car004a_physics.mdl",
	"models/props_vehicles/car004b_physics.mdl",
	"models/props_vehicles/car005a_physics.mdl",
	"models/props_vehicles/car005b_physics.mdl",
	"models/props_vehicles/van001a_physics.mdl",
	"models/props_vehicles/truck003a.mdl",
	"models/props_vehicles/truck002a_cab.mdl",
	"models/props_vehicles/trailer002a.mdl",
	"models/props_vehicles/truck001a.mdl",
	"models/props_vehicles/generatortrailer01.mdl",
	"models/props_vehicles/apc001.mdl",
	"models/combine_apc_wheelcollision.mdl",
	"models/props_vehicles/trailer001a.mdl",
	"models/props_trainstation/train003.mdl",
	"models/props_trainstation/train002.mdl",
	"models/props_combine/combine_train02a.mdl",
	"models/props_combine/CombineTrain01a.mdl",
	"models/props_combine/combine_train02b.mdl",
	"models/props_trainstation/train005.mdl"
}

GMS_SpawnLists[ "Iron - Seating" ] = {
	"models/props_c17/chair_stool01a.mdl",
	"models/props_c17/chair02a.mdl",
	"models/props_c17/chair_office01a.mdl",
	"models/props_wasteland/controlroom_chair001a.mdl",
	"models/props_c17/chair_kleiner03a.mdl",
	"models/props_trainstation/traincar_seats001.mdl",
	"models/props_c17/FurnitureBed001a.mdl",
	"models/props_wasteland/prison_bedframe001b.mdl",
	"models/props_c17/FurnitureBathtub001a.mdl",
	"models/props_interiors/BathTub01a.mdl"
}

GMS_SpawnLists[ "Iron - Misc/Buttons" ] = {
	"models/props_c17/TrapPropeller_Lever.mdl",
	"models/props_c17/TrapPropeller_Engine.mdl",
	"models/props_c17/TrapPropeller_Blade.mdl",
	"models/props_junk/sawblade001a.mdl",
	"models/props_trainstation/payphone001a.mdl",
	"models/props_wasteland/prison_throwswitchlever001.mdl",
	"models/props_wasteland/prison_throwswitchbase001.mdl",
	"models/props_wasteland/tram_lever01.mdl",
	"models/props_wasteland/tram_leverbase01.mdl",
	"models/props_wasteland/panel_leverHandle001a.mdl",
	"models/props_wasteland/panel_leverBase001a.mdl",
	"models/props_lab/tpplug.mdl",
	"models/props_lab/tpplugholder_single.mdl",
	"models/props_lab/tpplugholder.mdl",
	"models/props_c17/cashregister01a.mdl"
}

GMS_SpawnLists[ "Wood - PHX" ] = {
	"models/props_phx/construct/wood/wood_boardx1.mdl",
	"models/props_phx/construct/wood/wood_boardx2.mdl",
	"models/props_phx/construct/wood/wood_boardx4.mdl",
	"models/props_phx/construct/wood/wood_panel1x1.mdl",
	"models/props_phx/construct/wood/wood_panel1x2.mdl",
	"models/props_phx/construct/wood/wood_panel2x2.mdl",
	"models/props_phx/construct/wood/wood_panel2x4.mdl",
	"models/props_phx/construct/wood/wood_panel4x4.mdl",
	"models/props_phx/construct/wood/wood_wire1x1.mdl",
	"models/props_phx/construct/wood/wood_wire1x1x1.mdl",
	"models/props_phx/construct/wood/wood_wire1x1x2.mdl",
	"models/props_phx/construct/wood/wood_wire1x1x2b.mdl",
	"models/props_phx/construct/wood/wood_wire1x2.mdl",
	"models/props_phx/construct/wood/wood_wire1x2b.mdl",
	"models/props_phx/construct/wood/wood_wire1x2x2b.mdl",
	"models/props_phx/construct/wood/wood_wire2x2.mdl",
	"models/props_phx/construct/wood/wood_wire2x2b.mdl",
	"models/props_phx/construct/wood/wood_wire2x2x2b.mdl"
}

GMS_SpawnLists[ "Iron - PHX" ] = {
	"models/props_phx/construct/metal_plate1.mdl",
	"models/props_phx/construct/metal_plate1x2.mdl",
	"models/props_phx/construct/metal_plate2x2.mdl",
	"models/props_phx/construct/metal_plate2x4.mdl",
	"models/props_phx/construct/metal_plate4x4.mdl",
	"models/props_phx/construct/metal_wire1x1.mdl",
	"models/props_phx/construct/metal_wire1x1x1.mdl",
	"models/props_phx/construct/metal_wire1x1x2.mdl",
	"models/props_phx/construct/metal_wire1x1x2b.mdl",
	"models/props_phx/construct/metal_wire1x2.mdl",
	"models/props_phx/construct/metal_wire1x2b.mdl",
	"models/props_phx/construct/metal_wire1x2x2b.mdl",
	"models/props_phx/construct/metal_wire2x2.mdl",
	"models/props_phx/construct/metal_wire2x2b.mdl",
	"models/props_phx/construct/metal_wire2x2x2b.mdl"
}

GMS.SleepingFurniture = {
	"models/props_interiors/Furniture_Couch01a.mdl",
	"models/props_c17/FurnitureCouch002a.mdl",
	"models/props_c17/FurnitureCouch001a.mdl",
	"models/props_c17/FurnitureBed001a.mdl",
	"models/props_wasteland/prison_bedframe001b.mdl",
	"models/props_trainstation/traincar_seats001.mdl"
}
GMS_SpawnLists[ "Mixed - Sleeping Furniture" ] = GMS.SleepingFurniture

GMS.TreeModels = {
	"models/props_foliage/oak_tree01.mdl",
	"models/props_foliage/tree_deciduous_01a-lod.mdl",
	"models/props_foliage/tree_deciduous_01a.mdl",
	"models/props_foliage/tree_deciduous_02a.mdl",
	"models/props_foliage/tree_deciduous_03a.mdl",
	"models/props_foliage/tree_deciduous_03b.mdl",
	"models/props_foliage/tree_poplar_01.mdl",

	"models/gm_forest/tree_oak1.mdl", -- These are in the content of the gamemode
	"models/gm_forest/tree_orientalspruce1.mdl"
}

// These models cannot be dynamically spawned. Because if someone doesn't have them.
GMS.AdditionalTreeModels = {
	"models/props_foliage/tree_cliff_01a.mdl", -- Half-Life 2, We don't want these to be plantable, they are weird
	"models/props_foliage/tree_cliff_02a.mdl",

	"models/props_foliage/tree_pine04.mdl", -- Episode 2
	"models/props_foliage/tree_pine05.mdl",
	"models/props_foliage/tree_pine06.mdl",
	"models/props_foliage/tree_dead01.mdl",
	"models/props_foliage/tree_dead02.mdl",
	"models/props_foliage/tree_dead03.mdl",
	"models/props_foliage/tree_dead04.mdl",
	"models/props_foliage/tree_dry01.mdl",
	"models/props_foliage/tree_dry02.mdl",
	"models/props_foliage/tree_pine_large.mdl",

	"models/props_foliage/tree_pine_01.mdl", -- Episode 1
	"models/props_foliage/tree_pine_02.mdl",
	"models/props_foliage/tree_pine_03.mdl",

	"models/props/de_inferno/tree_small.mdl", -- CSS
	"models/props/de_inferno/tree_large.mdl",
	"models/props/cs_militia/tree_large_militia.mdl",

	"models/jtwoods/woods_spruce.mdl", -- Models from gms_paradise_islands_v1 / gm_forest
	"models/gm_forest/trunk_a.mdl",
	"models/gm_forest/tree_commonlinden_1.mdl",
	"models/gm_forest/tree_alder.mdl",
	"models/gm_forest/tree_birch1.mdl",
	"models/gm_forest/tree_b.mdl",
	"models/gm_forest/tree_g.mdl"
}

GMS.EdibleModels = {
	"models/props/cs_italy/orange.mdl",
	"models/props_junk/watermelon01.mdl",
	"models/props/cs_italy/bananna_bunch.mdl"
}

GMS.RockModels = {
	"models/props_wasteland/rockgranite02a.mdl",
	"models/props_wasteland/rockgranite02b.mdl",
	"models/props_wasteland/rockgranite02c.mdl",
	"models/props_wasteland/rockgranite04b.mdl",
	"models/props_wasteland/rockcliff_cluster01b.mdl",
	"models/props_wasteland/rockcliff_cluster02a.mdl",
	"models/props_wasteland/rockcliff_cluster02b.mdl",
	"models/props_wasteland/rockcliff_cluster02c.mdl",
	"models/props_wasteland/rockcliff_cluster03a.mdl",
	"models/props_wasteland/rockcliff_cluster03b.mdl",
	"models/props_wasteland/rockcliff_cluster03c.mdl",
	"models/props_wasteland/rockcliff01b.mdl",
	"models/props_wasteland/rockcliff01c.mdl",
	"models/props_wasteland/rockcliff01e.mdl",
	"models/props_wasteland/rockcliff01f.mdl",
	"models/props_wasteland/rockcliff01g.mdl",
	"models/props_wasteland/rockcliff01J.mdl",
	"models/props_wasteland/rockcliff01k.mdl",
	"models/props_wasteland/rockcliff05a.mdl",
	"models/props_wasteland/rockcliff05b.mdl",
	"models/props_wasteland/rockcliff05e.mdl",
	"models/props_wasteland/rockcliff05f.mdl",
	"models/props_wasteland/rockcliff06d.mdl",
	"models/props_wasteland/rockcliff06i.mdl",
	"models/props_wasteland/rockcliff07b.mdl"
}

GMS.AdditionalRockModels = {
	"models/props_wasteland/rockgranite01a.mdl", -- Half-Life 2
	"models/props_wasteland/rockgranite01b.mdl",
	"models/props_wasteland/rockgranite01c.mdl",
	"models/props_wasteland/rockgranite03a.mdl",
	"models/props_wasteland/rockgranite03b.mdl",
	"models/props_wasteland/rockgranite03c.mdl",
	"models/props_wasteland/rockgranite04a.mdl",
	"models/props_wasteland/rockgranite04c.mdl",
	"models/props_canal/rock_riverbed01a.mdl",
	"models/props_canal/rock_riverbed01b.mdl",
	"models/props_canal/rock_riverbed01c.mdl",
	"models/props_canal/rock_riverbed01d.mdl",
	"models/props_canal/rock_riverbed02a.mdl",
	"models/props_canal/rock_riverbed02b.mdl",
	"models/props_canal/rock_riverbed02c.mdl",
	"models/props_lab/bigrock.mdl",

	"models/props_mining/caverocks_cluster01.mdl", -- Episode 2
	"models/props_mining/caverocks_cluster02.mdl",
	"models/Cliffs/rockcluster01.mdl",
	"models/Cliffs/rockcluster02.mdl",
	"models/Cliffs/rocks_large01.mdl",
	"models/Cliffs/rocks_large01_veg.mdl",
	"models/Cliffs/rocks_large02.mdl",
	"models/Cliffs/rocks_large02_veg.mdl",
	"models/cliffs/rocks_large03.mdl",
	"models/cliffs/rocks_large03_veg.mdl",
	"models/Cliffs/rocks_medium01.mdl",
	"models/Cliffs/rocks_medium01_veg.mdl",
	"models/Cliffs/rocks_xlarge01.mdl",
	"models/Cliffs/rocks_xlarge01_veg.mdl",
	"models/Cliffs/rocks_xlarge02.mdl",
	"models/Cliffs/rocks_xlarge02_veg.mdl",
	"models/Cliffs/rocks_xlarge03.mdl",
	"models/Cliffs/rocks_xlarge03_veg.mdl",

	"models/props/de_inferno/de_inferno_boulder_03.mdl", -- CSS
	"models/props_canal/rock_riverbed02b.mdl",
	"models/props/cs_militia/boulder01.mdl",
	"models/props/cs_militia/militiarock01.mdl",
	"models/props/cs_militia/militiarock02.mdl",
	"models/props/cs_militia/militiarock03.mdl",
	"models/props/cs_militia/militiarock05.mdl",
	"models/props_wasteland/rockcliff07e.mdl",
	"models/props_wasteland/rockcliff_cluster01a.mdl"
}

GMS.SmallRockModel = "models/props_junk/rock001a.mdl"

GMS.MaterialResources = {}
GMS.MaterialResources[ MAT_CONCRETE ] = "Concrete"
GMS.MaterialResources[ MAT_METAL ] = "Iron"
GMS.MaterialResources[ MAT_DIRT ] = "Wood"
GMS.MaterialResources[ MAT_VENT ] = "Copper"
GMS.MaterialResources[ MAT_GRATE ] = "Copper"
GMS.MaterialResources[ MAT_TILE ] = "Stone"
GMS.MaterialResources[ MAT_SLOSH ] = "Wood"
GMS.MaterialResources[ MAT_WOOD ] = "Wood"
GMS.MaterialResources[ MAT_COMPUTER ] = "Copper"
GMS.MaterialResources[ MAT_GLASS ] = "Glass"
GMS.MaterialResources[ MAT_FLESH ] = "Wood"
GMS.MaterialResources[ MAT_BLOODYFLESH ] = "Wood"
GMS.MaterialResources[ MAT_CLIP ] = "Wood"
GMS.MaterialResources[ MAT_ANTLION ] = "Wood"
GMS.MaterialResources[ MAT_ALIENFLESH ] = "Wood"
GMS.MaterialResources[ MAT_FOLIAGE ] = "Wood"
GMS.MaterialResources[ MAT_SAND ] = "Sand"
GMS.MaterialResources[ MAT_PLASTIC ] = "Plastic"

GMS.PickupProhibitedClasses = {
	"gms_seed"
}

GMS.SavedClasses = {
	"prop_physics",
	"prop_physics_override",
	"prop_physics_multiplayer",
	"prop_dynamic",
	"gms_stoneworkbench",
	"gms_copperworkbench",
	"gms_ironworkbench",
	"gms_techworkbench",
	"gms_stove",
	"gms_buildsite",
	"gms_fridge",
	"gms_resourcedrop",
	"gms_resourcepack",
	"gms_stonefurnace",
	"gms_copperfurnace",
	"gms_ironfurnace",
	"gms_antlionbarrow",
	"gms_loot",
	"gms_factory",
	"gms_gunchunks",
	"gms_gunlab",
	"gms_seed",
	"gms_grindingstone",
	"gms_waterfountain",
	"gms_clock_big"
}

GMS.StructureEntities = {
	"gms_stoneworkbench",
	"gms_stonefurnace",
	"gms_copperworkbench",
	"gms_copperfurnace",
	"gms_ironworkbench",
	"gms_ironfurnace",
	"gms_techworkbench",
	"gms_gunlab",
	"gms_gunchunks",
	"gms_stove",
	"gms_fridge",
	"gms_factory",
	"gms_grindingstone",
	"gms_waterfountain",
	"gms_resourcepack",
	"gms_buildsite"
}

GMS.ProhibitedStools = {
	"hydraulic",
	"motor",
	"muscle",
	"nail",
	"pulley",
	"slider",
	"balloon",
	"rope", // We use gms_rope
	"button",
	"duplicator",
	"dynamite",
	"emitter",
	"hoverball",
	"ignite",
	"keepupright",
	"magnetise",
	//"nocollide",
	"physprop",
	"spawner",
	"thruster",
	"turret",
	"wheel",
	"eyeposer",
	"faceposer",
	"finger",
	"inflator",
	"statue",
	"trails",
	"camera",
	"paint",
	"rtcamera",
	"rb655_lightsaber"
}

GMS.AllWeapons = {
	"gms_stonepickaxe",
	"gms_stonehatchet",
	"gms_copperpickaxe",
	"gms_wrench",
	"gms_copperhatchet",
	"gms_ironpickaxe",
	"gms_ironhatchet",
	"gms_woodenfishingrod",
	"gms_advancedfishingrod",
	"gms_fryingpan",
	"gms_shovel",
	"gms_strainer",
	"gms_sickle",
	"gms_woodenspoon",
	"gmod_tool",
	"weapon_crowbar",
	"weapon_stunstick",
	"weapon_pistol",
	"weapon_smg1"
}

GMS.NonDropWeapons = {
	"gms_fists",
	"gmod_tool",
	"gmod_camera",
	"weapon_physgun",
	"weapon_physcannon",
	"pill_pigeon"
}

/* ----------------------------------------------
	Console Variables
------------------------------------------------ */

if ( GMSCVars ) then return end -- Auto-Refresh protection

GMSCVars = {}

function CreateGMSCVar( name, def, flag )
	if ( SERVER ) then

		table.insert( GMSCVars, "gms_" .. name )
		CreateConVar( "gms_" .. name, def, flag )

		cvars.AddChangeCallback( "gms_" .. name, function( cvar, old, new )

			if ( math.floor( old ) == math.floor( new ) ) then return end
			for id, pl in pairs( player.GetAll() ) do pl:ConCommand( "gms_" .. name .. " " .. math.floor( new ) ) end

		end )

	else

		CreateConVar( "gms_" .. name, def )
		cvars.AddChangeCallback( "gms_" .. name, function( cvar, old, new )

			if ( math.floor( old ) == math.floor( new ) ) then return end
			timer.Destroy( "gms_update" .. name )
			timer.Create( "gms_update" .. name, 2, 1, function() RunConsoleCommand( "gms_update", name, math.floor( new ) ) end )

		end )

	end
end

CreateGMSCVar( "FreeBuild", "0" )
CreateGMSCVar( "FreeBuildSA", "0" )
CreateGMSCVar( "AllTools", "0", FCVAR_ARCHIVE )
CreateGMSCVar( "AutoSave", "1", FCVAR_ARCHIVE )
CreateGMSCVar( "AutoSaveTime", "3", FCVAR_ARCHIVE )
CreateGMSCVar( "ReproduceTrees", "3" )
CreateGMSCVar( "MaxReproducedTrees", "50", FCVAR_ARCHIVE )
CreateGMSCVar( "SpreadFire", "0" )
CreateGMSCVar( "FadeRocks", "0" )
//CreateGMSCVar( "CostsScale", "1" )
//CreateGMSCVar( "alerts", "1" )
CreateGMSCVar( "campfire", "1" )
CreateGMSCVar( "PlantLimit", "25", FCVAR_ARCHIVE )

CreateGMSCVar( "PVPDamage", "0", FCVAR_ARCHIVE )
CreateGMSCVar( "TeamColors", "1", FCVAR_ARCHIVE )

-- Daynight
CreateGMSCVar( "daynight", "1" )
CreateGMSCVar( "night_cleanup", "1" )
CreateGMSCVar( "zombies", "1" )

if ( CLIENT ) then return end

concommand.Add( "gms_update", function( ply, cmd, args )

	if ( !ply:IsAdmin() ) then return end

	local cmd = args[ 1 ]
	local val = args[ 2 ]

	if ( math.floor( GetConVarNumber( "gms_" .. cmd ) ) == math.floor( val ) ) then return end

	RunConsoleCommand( "gms_" .. cmd, math.floor( val ) )

end )

hook.Add( "PlayerInitialSpawn", "gms.sync_cvars", function( ply )
	for id, cvar in pairs( GMSCVars ) do ply:ConCommand( cvar .. " " .. math.floor( GetConVarNumber( cvar ) ) ) end
end )
