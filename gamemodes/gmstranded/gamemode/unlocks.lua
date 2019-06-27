
GMS.FeatureUnlocks = {}

function GMS.RegisterUnlock( tbl )
	GMS.FeatureUnlocks[ string.Replace( tbl.Name, " ", "_" ) ] = tbl
end

----------------------------------------------------------------------------------------------------

local UNLOCK = {}

UNLOCK.Name = "Sprinting I"
UNLOCK.Description = "You can now hold down shift to sprint."

UNLOCK.Req = {}
UNLOCK.Req[ "Survival" ] = 4

function UNLOCK.OnUnlock( ply )
	if ( !ply:HasUnlock( "Sprinting_II" ) ) then
		if ( ply.CROW ) then ply.CROW.speeds.run = 250 ply.CROW.speeds.sprint = 400 return end
		GAMEMODE:SetPlayerSpeed( ply, 250, 400 )
	end
end

GMS.RegisterUnlock( UNLOCK )

----------------------------------------------------------------------------------------------------

local UNLOCK = {}

UNLOCK.Name = "Sprinting II"
UNLOCK.Description = "Your movement speed has got permanent increase. Also, your sprint is now walk."

UNLOCK.Req = {}
UNLOCK.Req[ "Survival" ] = 12

function UNLOCK.OnUnlock( ply )
	if ( ply.CROW ) then ply.CROW.speeds.run = 400 ply.CROW.speeds.sprint = 100 return end
	GAMEMODE:SetPlayerSpeed( ply, 400, 100 )
end

GMS.RegisterUnlock( UNLOCK )

----------------------------------------------------------------------------------------------------

local UNLOCK = {}

UNLOCK.Name = "Adept Survivalist"
UNLOCK.Description = "Your max health has been increased by 50%."

UNLOCK.Req = {}
UNLOCK.Req[ "Survival" ] = 16

function UNLOCK.OnUnlock( ply )
	if ( ply:GetMaxHealth() < 150 ) then ply:SetMaxHealth( 150 ) end
	ply:Heal( 50 )
end

GMS.RegisterUnlock( UNLOCK )

----------------------------------------------------------------------------------------------------

local UNLOCK = {}

UNLOCK.Name = "Master Survivalist"
UNLOCK.Description = "Your max health has been increased by 33%."

UNLOCK.Req = {}
UNLOCK.Req[ "Survival" ] = 32

function UNLOCK.OnUnlock( ply )
	ply:SetMaxHealth( 200 )
	ply:Heal( 50 )
end

GMS.RegisterUnlock( UNLOCK )

----------------------------------------------------------------------------------------------------

local UNLOCK = {}

UNLOCK.Name = "Extreme Survivalist"
UNLOCK.Description = "You can now become a crow and fly around."

UNLOCK.Req = {}
UNLOCK.Req[ "Survival" ] = 48

function UNLOCK.OnUnlock( ply )
	ply:Give( "pill_pigeon" )
end

GMS.RegisterUnlock( UNLOCK )

----------------------------------------------------------------------------------------------------

local UNLOCK = {}

UNLOCK.Name = "Sprout Collecting"
UNLOCK.Description = "You can now press use on a tree to attempt to loosen a sprout.\nSprouts can be planted if you have the skill, and they will grow into trees."

UNLOCK.Req = {}
UNLOCK.Req[ "Lumbering" ] = 5
UNLOCK.Req[ "Harvesting" ] = 5

GMS.RegisterUnlock( UNLOCK )

----------------------------------------------------------------------------------------------------

local UNLOCK = {}

UNLOCK.Name = "Grain Planting"
UNLOCK.Description = "You can now plant grain."

UNLOCK.Req = {}
UNLOCK.Req[ "Planting" ] = 3

GMS.RegisterUnlock( UNLOCK )

----------------------------------------------------------------------------------------------------

local UNLOCK = {}

UNLOCK.Name = "Sprout Planting"
UNLOCK.Description = "You can now plant sprouts, which will grow into trees."

UNLOCK.Req = {}
UNLOCK.Req[ "Planting" ] = 5

GMS.RegisterUnlock( UNLOCK )

----------------------------------------------------------------------------------------------------

local UNLOCK = {}

UNLOCK.Name = "Adept Farmer"
UNLOCK.Description = "Your melon, orange and banana vines can now carry up to 2 fruits instead of one."

UNLOCK.Req = {}
UNLOCK.Req[ "Planting" ] = 12

GMS.RegisterUnlock( UNLOCK )

----------------------------------------------------------------------------------------------------

local UNLOCK = {}

UNLOCK.Name = "Expert Farmer"
UNLOCK.Description = "Your melon, orange and banana vines can now carry up to 3 fruits instead of one."

UNLOCK.Req = {}
UNLOCK.Req[ "Planting" ] = 24

GMS.RegisterUnlock( UNLOCK )
