
local PlayerMeta = FindMetaTable( "Player" )
local EntityMeta = FindMetaTable( "Entity" )

GMS.Processes = {}

function GMS.RegisterProcess( name, tbl )
	GMS.Processes[ name ] = tbl
end

GM.ProcessThinkHookTable = {}
hook.Add( "Think", "gms_ProcessThinkHooks", function()
	for k, v in pairs( GAMEMODE.ProcessThinkHookTable ) do

		local think
		if ( v.Think ) then think = v:Think() end

		local basethink = v:BaseThink()

		if ( think or basethink or IsStopped ) then
			if ( v.Owner and v.Owner != NULL and v.Owner:IsValid() ) then 
				v.Owner:Freeze( false )
				v.Owner:StopProcessBar()
				v.Owner.InProcess = false
				v.Owner:SendMessage( "Cancelled.", 3, Color( 200, 0, 0, 255 ) )
			end

			v.IsStopped = true
			timer.Destroy( "GMS_ProcessTimer_" .. v.TimerID )
			GAMEMODE:RemoveProcessThink( v )
		end
	end
end )

function GM:RemoveProcessThink( tbl )
	for k, v in pairs( self.ProcessThinkHookTable ) do
		if ( v == tbl ) then table.remove( self.ProcessThinkHookTable, k ) break end
	end
end

function PlayerMeta:DoProcess( name, time, data )
	if ( self.InProcess ) then self:SendMessage( "You can't do this much at once.", 3, Color( 200, 0, 0, 255 ) ) return end
	if ( self:GetNWBool( "AFK" ) ) then self:SendMessage( "You can't do this while afk.", 3, Color( 200, 0, 0, 255 ) ) return end
	if ( self:GetNWBool( "Sleeping" ) ) then self:SendMessage( "You can't do this while sleeping.", 3, Color( 200, 0, 0, 255 ) ) return end

	self.ProcessTable = table.Merge( table.Copy( GMS.Processes.BaseProcess ), table.Copy( GMS.Processes[ name ] ) )
	self.ProcessTable.Owner = self
	self.ProcessTable.Time = time
	self.ProcessTable.StartTime = CurTime()
	self.ProcessTable.TimerID = self:UniqueID()
	if ( data ) then self.ProcessTable.Data = data end

	self.InProcess = true
	if ( self.ProcessTable.Freeze ) then self:Freeze( true ) end
	if ( self.ProcessTable.OnStart ) then self.ProcessTable:OnStart() end

	table.insert( GAMEMODE.ProcessThinkHookTable, self.ProcessTable )

	timer.Create( "GMS_ProcessTimer_" .. self:UniqueID(), time, 1, function() self:StopProcess() end )
end

function PlayerMeta:MakeProcessBar( name, time, cancel )
	umsg.Start( "gms_MakeProcessBar", self )
	umsg.String( name )
	umsg.Short( time )
	umsg.Bool( cancel )
	umsg.End()
end

function PlayerMeta:StopProcessBar()
	umsg.Start( "gms_StopProcessBar", self )
	umsg.End()
end

function PlayerMeta:StopProcess()
	if ( !IsValid( self ) or self.ProcessTable == nil ) then return end

	local bool = self.ProcessTable:BaseStop()
	if ( self.ProcessTable.Freeze ) then self:Freeze( false ) end
	if ( self.ProcessTable.OnStop ) then self.ProcessTable:OnStop() end
	if ( self.ProcessTable.Think ) then GAMEMODE:RemoveProcessThink( self.ProcessTable ) end

	self.InProcess = false
	self.ProcessTable = nil
end

function PlayerMeta:CancelProcess()
	if ( !self.InProcess ) then return end

	local v = self.ProcessTable
	if ( !v.Cancel ) then return end

	if ( v.Owner and v.Owner != NULL and IsValid( v.Owner ) ) then 
		v.Owner:Freeze( false )
		v.Owner:StopProcessBar()
		v.Owner.InProcess = false
		v.Owner:SendMessage( "Cancelled.", 3, Color( 200, 0, 0, 255 ) )
	end

	v.IsStopped = true
	timer.Destroy( "GMS_ProcessTimer_" .. v.TimerID )
	GAMEMODE:RemoveProcessThink( v )
end

/* Base process */
local PROCESS = {}

function PROCESS:BaseThink()
	if ( IsValid( ent ) ) then
		if ( self == nil or self.Owner == nil ) then return true end
		if ( !self.Owner:IsValid() or !self.Owner:IsConnected() or !self.Owner:Alive() ) then return true end
	end
end

function PROCESS:BaseStop()
	if ( !IsValid( self.Owner ) or !self.Owner:Alive() ) then return false end
	self.Owner:StopProcessBar()
	return true
end

PROCESS.Cancel = true
PROCESS.Freeze = true

GMS.Processes.BaseProcess = PROCESS

/* Stealing */
local PROCESS = {}

function PROCESS:OnStart()
	self.Owner:MakeProcessBar( "Stealing", self.Time, self.Cancel )
end

function PROCESS:OnStop()
	if ( !self.Data.Ent ) then return end

	SPropProtection.PlayerMakePropOwner( self.Owner, self.Data.Ent )
	self.Owner:IncXP( "Stealing", math.Clamp( math.Round( self.Time * 5 / self.Owner:GetSkill( "Stealing" ) ), 1, 1000 ) )

	self.Owner:SendMessage( "Successfully stolen.", 3, Color( 50, 200, 50, 255 ) )
end

GMS.RegisterProcess( "Steal", PROCESS )

/* Fruit eating process */
local PROCESS = {}

PROCESS.SideGain = {}
PROCESS.SideGain["melon"] = "Melon_Seeds"
PROCESS.SideGain["orange"] = "Orange_Seeds"
PROCESS.SideGain["banana"] = "Banana_Seeds"

function PROCESS:OnStart()
	self.Owner:MakeProcessBar( "Eating Fruit", self.Time, self.Cancel )

	self.Owner:EmitSound( Sound( "stranded/eat.wav" ) )

	local owner = nil
	local ent = self.Data.Entity
	local plant = ent.PlantParent

	if ( plant ) then owner = plant:GetNWEntity( "plantowner" ) end

	if ( self.Data.Entity:GetModel() == "models/props_junk/watermelon01.mdl" ) then
		self.SideGain = "Melon_Seeds"
	elseif ( self.Data.Entity:GetModel() == "models/props/cs_italy/orange.mdl" ) then
		self.SideGain = "Orange_Seeds"
	elseif ( self.Data.Entity:GetModel() == "models/props/cs_italy/bananna_bunch.mdl" ) then
		self.SideGain = "Banana_Seeds"
	end

	if ( plant ) then
		plant.Children = plant.Children - 1
		if ( plant.Children <= 0 ) then
			plant:Fadeout()
			if ( IsValid( owner ) ) then owner:SetNWInt( "plants", owner:GetNWInt( "plants" ) - 1 ) end
		end
	end

	self.Data.Entity:Fadeout( 2 )
end

function PROCESS:OnStop()
	if ( self.SideGain ) then
		local numto = 1
		local numstart = 0
		if ( IsValid( self.Owner:GetActiveWeapon() ) && self.Owner:GetActiveWeapon():GetClass() == "gms_woodenspoon" ) then 
			numto = numto + 2 
			numstart = numstart + 1
		end
		local num = math.random( numstart, numto )
		if ( num ~= 0 ) then
			self.Owner:IncResource( self.SideGain, num )
			self.Owner:SendMessage( string.gsub( self.SideGain, "_", " " ) .. " ( " .. num .. "x )", 3, Color( 10, 200, 10, 255 ) )
			self.Owner:EmitSound( Sound( "items/ammo_pickup.wav" ) )
		end
	end

	self.Owner:SetFood( self.Owner.Hunger + 250 )
	self.Owner:SendMessage( "You feel a little less hungry now.", 3, Color( 255, 255, 255, 255 ) )
end

PROCESS.Cancel = false

GMS.RegisterProcess( "EatFruit", PROCESS )

/* Food eating process */
local PROCESS = {}

function PROCESS:OnStart()
	self.Owner:MakeProcessBar( "Eating", self.Time, self.Cancel )
	self.Owner:EmitSound( Sound( "stranded/eat.wav" ) )

	local ent = self.Data.Entity
	self.Value = ent.Value
	ent:Fadeout( 2 )
end

function PROCESS:OnStop()
	self.Owner:SendMessage( "Restored " .. tostring( ( self.Value / 1000 ) * 100 ) .. "% food.", 3, Color( 10, 200, 10, 255 ) )
	self.Owner:SetFood( self.Owner.Hunger + self.Value )
	self.Owner:Heal( self.Value / 20 )
	self.Owner:SendMessage( "Regained " .. tostring( self.Value / 20 ) .. " hp.", 3, Color( 255, 0, 0, 255 ) )

	self.Owner:SetFood( self.Owner.Hunger + 250 )
	self.Owner:SendMessage( "You feel a little less hungry now.", 3, Color( 255, 255, 255, 255 ) )
end

PROCESS.Cancel = false

GMS.RegisterProcess( "EatFood", PROCESS )

/*---------------------------------------------------------
  Eat Berry
---------------------------------------------------------*/
local PROCESS = {}

function PROCESS:OnStart()
	self.Owner:MakeProcessBar( "Eating some berries", self.Time, self.Cancel )
	self.StartTime = CurTime()

	self.Owner:EmitSound( Sound( "stranded/eat.wav" ) )
end

function PROCESS:OnStop()
	self.Owner:DecResource( "Berries", 1 )
	self.Owner:SendMessage( "You're a little less hungry and thirsty now.", 3, Color( 10, 200, 10, 255 ) )
	if ( self.Owner.Hunger <= 900 ) then
		self.Owner:SetFood( self.Owner.Hunger + 100 )
	elseif ( self.Owner.Hunger >= 900 ) then
		self.Owner:SetFood( 1000 )
	end
	
	if ( self.Owner.Thirst <= 900 ) then
		self.Owner:SetThirst( self.Owner.Thirst + 100 )
	elseif ( self.Owner.Thirst >= 900 ) then
		self.Owner:SetThirst( 1000 )
	end
end

PROCESS.Cancel = false

GMS.RegisterProcess( "EatBerry", PROCESS )

/*---------------------------------------------------------
  Foraging process
---------------------------------------------------------*/
local PROCESS = {}

PROCESS.Results = {}
PROCESS.Results[1] = "Melon Seeds"
PROCESS.Results[2] = "Banana Seeds"
PROCESS.Results[3] = "Orange Seeds"
PROCESS.Results[4] = "Grain Seeds"
PROCESS.Results[5] = "Herbs"
PROCESS.Results[6] = "Berries"
PROCESS.Results[7] = "Baits"

function PROCESS:OnStart()
	self.Owner:MakeProcessBar( "Foraging", self.Time, self.Cancel )
end

function PROCESS:OnStop()
	local num = math.random( 1, 100 )

	if ( num > 50 - self.Owner:GetSkill( "Harvesting" ) ) then
		local res = self.Results[math.random( 1, #self.Results )]

		local amount = math.random( 1, 3 )
		self.Owner:IncResource( string.gsub( res, " ", "_" ), amount )
		self.Owner:IncXP( "Harvesting", math.Clamp( math.Round( 50 / self.Owner:GetSkill( "Harvesting" ) ), 1, 1000 ) )
		self.Owner:SendMessage( res .. " ( " .. amount .. "x )", 3, Color( 10, 200, 10, 255 ) )
		self.Owner:EmitSound( Sound( "items/ammo_pickup.wav" ) )
	else
		self.Owner:SendMessage( "Found nothing of interest", 3, Color( 255, 255, 255, 255 ) )
	end
end

GMS.RegisterProcess( "Foraging", PROCESS )

/*---------------------------------------------------------
  Looting process
---------------------------------------------------------*/
local PROCESS = {}

function PROCESS:OnStart()
	self.Owner:MakeProcessBar( "Looting", self.Time, self.Cancel )
end

function PROCESS:OnStop()
	self.Data.Entity:Fadeout( 2 )

	for k, v in pairs( self.Data.Resources ) do
		self.Owner:SendMessage( k .. " ( " .. v .. "x )", 3, Color( 10, 200, 10, 255 ) )
		self.Owner:IncResource( k, v )
	end

	self.Owner:EmitSound( Sound( "items/ammo_pickup.wav" ) )
end

GMS.RegisterProcess( "Loot", PROCESS )

/*---------------------------------------------------------
  Salvaging process
---------------------------------------------------------*/
local PROCESS = {}

function PROCESS:OnStart()
	self.Owner:MakeProcessBar( "Salvaging", self.Time, self.Cancel )
end

function PROCESS:OnStop()
	local ent = self.Data.Entity
	local ply = self.Owner

	if ( ent.NormalProp == true && SPropProtection.PlayerCanTouch( ply, ent ) ) then
		local vol = ent:GetVolume()

		local res = GMS.MaterialResources[ self.Data.MatType ]
		//local cost = math.Round( 0.6 * math.ceil( vol * ( GetConVarNumber( "gms_CostsScale" ) / 2 ) ) )
		local cost = math.Round( 0.6 * math.ceil( vol * 0.5 ) )
		ply:IncResource( res, cost )
		ply:SendMessage( "Gained " .. string.Replace( res, "_", " " ) .. " ( " .. cost .. "x ) from salvaging.", 3, Color( 255, 255, 255, 255 ) )
	elseif ( table.HasValue( GMS.StructureEntities, ent:GetClass() ) && SPropProtection.PlayerCanTouch( ply, ent ) ) then
		local structures = GMS.Combinations[ "Structures" ]
		local costs = {}
		for name, t in pairs( structures ) do
			if ( t.Results == ent:GetClass() ) then costs = t.Req end
		end

		for res, num in pairs( costs ) do
			local cost = math.Round( 0.6 * num )
			ply:IncResource( res, cost )
			ply:SendMessage( "Gained " .. string.Replace( res, "_", " " ) .. " ( " .. cost .. "x ) from salvaging.", 3, Color( 255, 255, 255, 255 ) )
		end
	end

	ent:Fadeout()

	ply:EmitSound( Sound( "items/ammo_pickup.wav" ) )
end

GMS.RegisterProcess( "Salvage", PROCESS )

/*---------------------------------------------------------
  Digging
---------------------------------------------------------*/
local PROCESS = {}

PROCESS.Rarities = {}
PROCESS.Rarities[1] = "Iron"
PROCESS.Rarities[2] = "Sand"
PROCESS.Rarities[3] = "Rope"
PROCESS.Rarities[4] = "Bass"
PROCESS.Rarities[5] = "Sand"
PROCESS.Rarities[6] = "Stone"

function PROCESS:OnStart()
	self.Owner:MakeProcessBar( "Digging", self.Time, self.Cancel )
	self.StartTime = CurTime()

	self:PlaySound()
end

function PROCESS:PlaySound()
	if ( CurTime() - self.StartTime > self.Time ) then return end
	if ( !self.Owner.InProcess || self.StartTime != self.Owner.ProcessTable.StartTime ) then return end

	if ( self.Owner:Alive() ) then
		self.Owner:GetActiveWeapon():DoEffects( self.Owner:GetEyeTrace() )
		self.Owner:EmitSound( Sound( "player/footsteps/gravel" .. math.random( 1, 4 ) .. ".wav" ) )

		timer.Simple( 1.5, function() self:PlaySound() end )
	end
end

function PROCESS:OnStop()
	local num = math.random( 1, 100 )

	if ( num < 10 ) then
		local res = self.Rarities[math.random( 1, #self.Rarities )]
		if ( self.Data and self.Data.Sand and math.random() > 0.50 ) then res = "Sand" end
		self.Owner:IncResource( res, 1 )
		self.Owner:SendMessage( res .. " ( 1x )", 3, Color( 10, 200, 10, 255 ) )
		self.Owner:SendMessage( "You found something weird!", 3, Color( 255, 255, 255, 255 ) )
		self.Owner:EmitSound( Sound( "items/ammo_pickup.wav" ) )
	elseif ( num > 10 and num < 40 ) then
		self.Owner:SendMessage( "Found nothing of interest", 3, Color( 255, 255, 255, 255 ) )
	else
		local tr = self.Owner:TraceFromEyes( 200 )

		local ent = ents.Create( "prop_physics" )
		ent:SetPos( tr.HitPos + Vector( 0, 0, 10 ) )
		ent:SetModel( GMS.SmallRockModel )
		ent:Spawn()
		SPropProtection.PlayerMakePropOwner( self.Owner, ent )

		ent:Fadein( 2 )
		ent.Uses = 10
	end
end

GMS.RegisterProcess( "Dig", PROCESS )

/*---------------------------------------------------------
  Filter ground process
---------------------------------------------------------*/
local PROCESS = {}
PROCESS.Results = {}
PROCESS.Results[1] = "Sand"
PROCESS.Results[2] = "Sand"
PROCESS.Results[3] = "Sand"
PROCESS.Results[4] = "Glass"

function PROCESS:OnStart()
	self.Owner:MakeProcessBar( "Filtering Ground", self.Time, self.Cancel )
end

function PROCESS:OnStop()
	local num = math.random( 1, 100 )

	if ( num > 50 - self.Owner:GetSkill( "Harvesting" ) ) then
		local res = self.Results[math.random( 1, #self.Results )]

		local amount = math.random( 1, 3 )
		self.Owner:IncResource( string.gsub( res, " ", "_" ), amount )
		self.Owner:IncXP( "Harvesting", math.Clamp( math.Round( 50 / self.Owner:GetSkill( "Harvesting" ) ), 1, 1000 ) )
		self.Owner:SendMessage( res .. " ( " .. amount .. "x )", 3, Color( 10, 200, 10, 255 ) )
		self.Owner:EmitSound( Sound( "items/ammo_pickup.wav" ) )
	else
		self.Owner:SendMessage( "Found nothing of interest", 3, Color( 200, 10, 10, 255 ) )
	end
end

GMS.RegisterProcess( "FilterGround", PROCESS )

/*---------------------------------------------------------
  Grain harvesting
---------------------------------------------------------*/
local PROCESS = {}

function PROCESS:OnStart()
	self.Owner:MakeProcessBar( "Harvesting Grain", self.Time, self.Cancel )

	local ent = self.Data.Entity

	if ( IsValid( ent ) && !ent.Uses ) then
		ent.Uses = math.random( 1, 3 )
	end
end

function PROCESS:OnStop()
	local num = math.random( 1, 100 )
	local add = 0
	if ( IsValid( self.Owner:GetActiveWeapon() ) && self.Owner:GetActiveWeapon():GetClass() == "gms_sickle" ) then add = add + 30 end

	if ( num > 50 - self.Owner:GetSkill( "Harvesting" ) - add ) then
		local amount = math.random( 1, 2 )
		self.Owner:IncResource( "Grain_Seeds", amount )
		self.Owner:IncXP( "Harvesting", math.Clamp( math.Round( 50 / self.Owner:GetSkill( "Harvesting" ) ), 1, 1000 ) )
		self.Owner:SendMessage( "Grain Seeds ( " .. amount .. "x )", 3, Color( 10, 200, 10, 255 ) )
		self.Owner:EmitSound( Sound( "items/ammo_pickup.wav" ) )
		local ent = self.Data.Entity
		local owner = ent:GetNWEntity( "plantowner" )

		if ( IsValid( ent ) && ent.Uses ) then
			ent.Uses = ent.Uses - 1
			if ( ent.Uses <= 0 ) then
				if ( IsValid( owner ) ) then owner:SetNWInt( "plants", owner:GetNWInt( "plants" ) - 1 ) end
				ent:Fadeout()
			end
		end
	else
		self.Owner:SendMessage( "Failed.", 3, Color( 200, 0, 0, 255 ) )
	end
end

GMS.RegisterProcess( "HarvestGrain", PROCESS )

/*---------------------------------------------------------
 Berry harvesting
---------------------------------------------------------*/
local PROCESS = {}

function PROCESS:OnStart()
	self.Owner:MakeProcessBar( "Harvesting Bush", self.Time, self.Cancel )
	local ent = self.Data.Entity

	if ( IsValid( ent ) && !ent.Uses ) then
		ent.Uses = math.random( 1, 3 )
	end
end

function PROCESS:OnStop()
	local num = math.random( 1, 100 )

	local add = 0
	if ( IsValid( self.Owner:GetActiveWeapon() ) && self.Owner:GetActiveWeapon():GetClass() == "gms_sickle" ) then add = add + 25 end
	if ( num > 50 - self.Owner:GetSkill( "Harvesting" ) - add ) then
		local amount = math.random( 1, 2 )
		self.Owner:IncResource( "Berries", amount )
		self.Owner:IncXP( "Harvesting", math.Clamp( math.Round( 50 / self.Owner:GetSkill( "Harvesting" ) ), 1, 1000 ) )
		self.Owner:SendMessage( "Berries ( " .. amount .. "x )", 3, Color( 10, 200, 10, 255 ) )
		self.Owner:EmitSound( Sound( "items/ammo_pickup.wav" ) )
		local ent = self.Data.Entity
		local owner = ent:GetNWEntity( "plantowner" )

		if ( IsValid( ent ) && ent.Uses ) then
			ent.Uses = ent.Uses - 1
			if ( ent.Uses <= 0 ) then
				if ( IsValid( owner ) ) then owner:SetNWInt( "plants", owner:GetNWInt( "plants" ) - 1 ) end
				ent:Fadeout()
			end
		end
	else
		self.Owner:SendMessage( "Failed.", 3, Color( 200, 0, 0, 255 ) )
	end
end

GMS.RegisterProcess( "HarvestBush", PROCESS )

/*---------------------------------------------------------
  Make Campfire process
---------------------------------------------------------*/
local PROCESS = {}

function PROCESS:OnStart()
	if ( GetConVarNumber( "gms_campfire" ) <= 0 ) then return end
	self.Owner:MakeProcessBar( "Making Campfire", self.Time, self.Cancel )
	self.Owner:EmitSound( "stranded/start_campfire.wav" )
end

function PROCESS:OnStop()
	if ( GetConVarNumber( "gms_campfire" ) <= 0 ) then return end
	local num = math.random( 1, 3 )

	if ( num == 1 ) then
		self.Owner:SendMessage( "Failed.", 3, Color( 200, 0, 0, 255 ) )
	else
		self.Data.Entity:MakeCampfire()
		self.Owner:SendMessage( "Made campfire.", 5, Color( 10, 200, 100, 255 ) )
		self.Owner:DecResource( "Wood", 5 )
	end
end

GMS.RegisterProcess( "Campfire", PROCESS )

/*---------------------------------------------------------
  Wood cutting
---------------------------------------------------------*/
local PROCESS = {}

function PROCESS:OnStart()
	self.Owner:MakeProcessBar( "Chopping Wood", self.Time, self.Cancel )

	self.StartTime = CurTime()

	self:PlaySound()
	if ( !self.Data.Entity.Uses ) then self.Data.Entity.Uses = 100 end
end

function PROCESS:PlaySound()
	if ( CurTime() - self.StartTime > self.Time ) then return end
	if ( !self.Owner.InProcess || self.StartTime != self.Owner.ProcessTable.StartTime ) then return end

	if ( self.Owner:Alive() ) then
		self.Owner:GetActiveWeapon():DoEffects( self.Owner:GetEyeTrace() )
		self.Owner:EmitSound( Sound( "physics/wood/wood_solid_impact_bullet" .. tostring( math.random( 1, 5 ) ) .. ".wav" ) )

		timer.Simple( 1.5, function() self:PlaySound() end )
	end
end

function PROCESS:OnStop()
	local num = math.random( 1, 100 )

	if ( num < self.Data.Chance + self.Owner:GetSkill( "Lumbering" ) ) then
		local num2 = math.random( self.Data.MinAmount, self.Data.MaxAmount )
		self.Owner:IncResource( "Wood", num2 )
		self.Owner:IncXP( "Lumbering", math.Clamp( math.Round( 50 / self.Owner:GetSkill( "Lumbering" ) ), 1 , 1000 ) )
		self.Owner:SendMessage( "Wood ( " .. num2 .. "x )", 3, Color( 10, 200, 10, 255 ) )
		self.Owner:EmitSound( Sound( "items/ammo_pickup.wav" ) )

		if ( self.Data.Entity and self.Data.Entity.Uses ) then self.Data.Entity.Uses = self.Data.Entity.Uses - num2 end
	else
		self.Owner:SendMessage( "Failed.", 3, Color( 200, 0, 0, 255 ) )
	end

	if ( self.Data.Entity != NULL ) then
		if ( self.Data.Entity.Uses <= 0 ) then
			self.Data.Entity:EmitSound( "stranded/tree_fall.wav" )
			self.Data.Entity:Fadeout()
		end
	end
end

GMS.RegisterProcess( "WoodCutting", PROCESS )

/* ---------------------------------------------------------
	Mining
--------------------------------------------------------- */

local PROCESS = {}

function PROCESS:OnStart()
	self.Owner:MakeProcessBar( "Mining", self.Time, self.Cancel )
	self.StartTime = CurTime()

	self:PlaySound()
	if ( !self.Data.Entity.Uses ) then self.Data.Entity.Uses = 250 end
end

function PROCESS:PlaySound()
	if ( CurTime() - self.StartTime > self.Time ) then return end
	if ( !self.Owner.InProcess || self.StartTime != self.Owner.ProcessTable.StartTime ) then return end

	if ( self.Owner:Alive() ) then
		self.Owner:GetActiveWeapon():DoEffects( self.Owner:GetEyeTrace() )
		self.Owner:EmitSound( Sound( "physics/glass/glass_bottle_impact_hard" .. tostring( math.random( 1, 3 ) ) .. ".wav" ) )

		timer.Simple( 1.5, function() self:PlaySound() end )
	end
end

function PROCESS:OnStop()
	local num = math.random( 1, 100 )
	local num2 = 1

	if ( num < self.Data.Chance + self.Owner:GetSkill( "Mining" ) ) then
		if ( IsValid( self.Owner:GetActiveWeapon() ) && self.Owner:GetActiveWeapon():GetClass() == "gms_stonepickaxe" ) then 
			num2 = math.random( 1, 2 )
		elseif ( IsValid( self.Owner:GetActiveWeapon() ) && self.Owner:GetActiveWeapon():GetClass() == "gms_copperpickaxe" ) then 
			num2 = math.random( 1, 3 )
		elseif ( IsValid( self.Owner:GetActiveWeapon() ) && self.Owner:GetActiveWeapon():GetClass() == "gms_ironpickaxe" ) then 
			num2 = math.random( 1, 4 )
		end

		local num3 = math.random( self.Data.MinAmount, self.Data.MaxAmount )

		if ( num2 == 1 ) then
			self.Owner:IncResource( "Stone", num3 )
			self.Owner:SendMessage( "Stone ( " .. num3 .. "x )", 3, Color( 10, 200, 10, 255 ) )
		elseif ( num2 == 2 ) then
			self.Owner:IncResource( "Copper_Ore", num3 )
			self.Owner:SendMessage( "Copper Ore ( "..num3 .. "x )", 3, Color( 10, 200, 10, 255 ) )
		elseif ( num2 == 3 ) then
			self.Owner:IncResource( "Iron_Ore", num3 )
			self.Owner:SendMessage( "Iron Ore ( " .. num3 .. "x )", 3, Color( 10, 200, 10, 255 ) )
		elseif ( num2 == 4 ) then
			self.Owner:IncResource( "Iron_Ore", num3 )
			self.Owner:SendMessage( "Iron Ore ( " .. num3 .. "x )", 3, Color( 10, 200, 10, 255 ) )
		end

		self.Owner:IncXP( "Mining", math.Clamp( math.Round( 50 / self.Owner:GetSkill( "Mining" ) ), 1, 1000 ) )
		self.Owner:EmitSound( Sound( "items/ammo_pickup.wav" ) )
		if ( self.Data.Entity and self.Data.Entity.Uses ) then self.Data.Entity.Uses = self.Data.Entity.Uses - num3 end
	else
		self.Owner:SendMessage( "Failed.", 3, Color( 200, 0, 0, 255 ) )
	end

	if ( GetConVarNumber( "gms_FadeRocks" ) == 1 and self.Data.Entity != NULL ) then
		if ( self.Data.Entity.Uses <= 0 ) then
			self.Data.Entity:Fadeout()
		end
	end
end

GMS.RegisterProcess( "Mining", PROCESS )

/*---------------------------------------------------------
  Sprout collect
---------------------------------------------------------*/
local PROCESS = {}

function PROCESS:OnStart()
	if ( self.Owner:HasUnlock( "Sprout_Collecting" ) ) then
		self.Owner:MakeProcessBar( "Loosening sprout", self.Time, self.Cancel )
	else
		self.IsStopped = true
	end
end

function PROCESS:OnStop()
	local num = math.random( 1, 100 )
	local add = 0

	if ( IsValid( self.Owner:GetActiveWeapon() ) && self.Owner:GetActiveWeapon():GetClass() == "gms_sickle" ) then add = add + 30 end

	if ( num > 50 - self.Owner:GetSkill( "Harvesting" ) - add ) then
		self.Owner:IncResource( "Sprouts", 1 )
		self.Owner:IncXP( "Harvesting", math.Clamp( math.Round( 50 / self.Owner:GetSkill( "Harvesting" ) ), 1, 1000 ) )
		self.Owner:SendMessage( "Sprout ( 1x )", 3, Color( 10, 200, 10, 255 ) )
		self.Owner:EmitSound( Sound( "items/ammo_pickup.wav" ) )
	else
		self.Owner:SendMessage( "Failed.", 3, Color( 200, 0, 0, 255 ) )
	end
end

GMS.RegisterProcess( "SproutCollect", PROCESS )

/*---------------------------------------------------------
  Plant Melon
---------------------------------------------------------*/
local PROCESS = {}

function PROCESS:OnStart()
	self.Owner:MakeProcessBar( "Planting Watermelon", self.Time, self.Cancel )
end

function PROCESS:OnStop()
	self.Owner:DecResource( "Melon_Seeds", 1 )
	self.Owner:IncXP( "Planting", math.Clamp( math.Round( 50 / self.Owner:GetSkill( "Planting" ) ), 1, 1000 ) )
	self.Owner:SendMessage( "Successfully planted.", 3, Color( 10, 200, 10, 255 ) )

	local ent = ents.Create( "gms_seed" )
	SPropProtection.PlayerMakePropOwner( self.Owner, ent )
	ent:SetPos( self.Data.Pos )
	ent:Setup( "melon", 160 - math.Clamp( self.Owner:GetSkill( "Planting" ), 0, 60 ) + math.random( -20, 20 ), self.Owner )
	ent:Spawn()
end

GMS.RegisterProcess( "PlantMelon", PROCESS )

/*---------------------------------------------------------
  Plant Banana
---------------------------------------------------------*/
local PROCESS = {}

function PROCESS:OnStart()
	self.Owner:MakeProcessBar( "Planting Banana", self.Time, self.Cancel )
end

function PROCESS:OnStop()
	self.Owner:DecResource( "Banana_Seeds", 1 )
	self.Owner:IncXP( "Planting", math.Clamp( math.Round( 50 / self.Owner:GetSkill( "Planting" ) ), 1, 1000 ) )
	self.Owner:SendMessage( "Successfully planted.", 3, Color( 10, 200, 10, 255 ) )

	local ent = ents.Create( "gms_seed" )
	SPropProtection.PlayerMakePropOwner( self.Owner , ent )
	ent:SetPos( self.Data.Pos )
	ent:Setup( "banana", 160 - math.Clamp( self.Owner:GetSkill( "Planting" ), 0, 60 ) + math.random( -20, 20 ), self.Owner )
	ent:Spawn()
end

GMS.RegisterProcess( "PlantBanana", PROCESS )

/*---------------------------------------------------------
  Plant Orange
---------------------------------------------------------*/
local PROCESS = {}

function PROCESS:OnStart()
	self.Owner:MakeProcessBar( "Planting Orange", self.Time, self.Cancel )
end

function PROCESS:OnStop()
	self.Owner:DecResource( "Orange_Seeds", 1 )
	self.Owner:IncXP( "Planting", math.Clamp( math.Round( 50 / self.Owner:GetSkill( "Planting" ) ) , 1, 1000 ) )
	self.Owner:SendMessage( "Successfully planted.", 3, Color( 10, 200, 10, 255 ) )

	local ent = ents.Create( "gms_seed" )
	SPropProtection.PlayerMakePropOwner( self.Owner, ent )
	ent:SetPos( self.Data.Pos )
	ent:Setup( "orange", 160 - math.Clamp( self.Owner:GetSkill( "Planting" ), 0, 60 ) + math.random( -20, 20 ), self.Owner )
	ent:Spawn()
end

GMS.RegisterProcess( "PlantOrange", PROCESS )

/*---------------------------------------------------------
  Plant Grain
---------------------------------------------------------*/
local PROCESS = {}

function PROCESS:OnStart()
	self.Owner:MakeProcessBar( "Planting Grain", self.Time, self.Cancel )
end

function PROCESS:OnStop()
	self.Owner:DecResource( "Grain_Seeds", 1 )
	self.Owner:IncXP( "Planting", math.Clamp( math.Round( 50 / self.Owner:GetSkill( "Planting" ) ), 1, 1000 ) )
	self.Owner:SendMessage( "Successfully planted.", 3, Color( 10, 200, 10, 255 ) )

	local ent = ents.Create( "gms_seed" )
	SPropProtection.PlayerMakePropOwner( self.Owner, ent )
	ent:SetPos( self.Data.Pos )
	ent:Setup( "grain", 160 - math.Clamp( self.Owner:GetSkill( "Planting" ), 0, 60 ) + math.random( -20, 20 ), self.Owner )
	ent:Spawn()
end

GMS.RegisterProcess( "PlantGrain", PROCESS )

/*---------------------------------------------------------
  Plant Bush
---------------------------------------------------------*/
local PROCESS = {}

function PROCESS:OnStart()
	self.Owner:MakeProcessBar( "Planting Berry Bush", self.Time, self.Cancel )
end

function PROCESS:OnStop()
	self.Owner:DecResource( "Berries", 1 )
	self.Owner:IncXP( "Planting", math.Clamp( math.Round( 50 / self.Owner:GetSkill( "Planting" ) ), 1, 1000 ) )
	self.Owner:SendMessage( "Successfully planted.", 3, Color( 10, 200, 10, 255 ) )

	local ent = ents.Create( "gms_seed" )
	SPropProtection.PlayerMakePropOwner( self.Owner, ent )
	ent:SetPos( self.Data.Pos )
	ent:Setup( "berry", 160 - math.Clamp( self.Owner:GetSkill( "Planting" ), 0, 60 ) + math.random( -20, 20 ), self.Owner )
	ent:Spawn()
end

GMS.RegisterProcess( "PlantBush", PROCESS )

/*---------------------------------------------------------
  Plant Tree
---------------------------------------------------------*/
local PROCESS = {}

function PROCESS:OnStart()
	self.Owner:MakeProcessBar( "Planting Tree", self.Time, self.Cancel )
end

function PROCESS:OnStop()
	self.Owner:DecResource( "Sprouts", 1 )
	self.Owner:IncXP( "Planting", math.Clamp( math.Round( 50 / self.Owner:GetSkill( "Planting" ) ), 1, 1000 ) )
	self.Owner:SendMessage( "Successfully planted.", 3, Color( 10, 200, 10, 255 ) )

	local ent = ents.Create( "gms_seed" )
	SPropProtection.PlayerMakePropOwner( self.Owner, ent )
	ent:SetPos( self.Data.Pos )
	ent:Setup( "tree", 240 - math.Clamp( self.Owner:GetSkill( "Planting" ), 0, 60 ) + math.random( -20, 20 ), self.Owner )
	ent:Spawn()
end

GMS.RegisterProcess( "PlantTree", PROCESS )

/*---------------------------------------------------------
  Assembling
---------------------------------------------------------*/
local PROCESS = {}

function PROCESS:OnStart()
	self.Owner:MakeProcessBar( "Assembling", self.Time, self.Cancel )
end

function PROCESS:OnStop()
	self.Owner:SendMessage( "Assembly successful.", 3, Color( 10, 200, 10, 255 ) )
end

PROCESS.Cancel = false

GMS.RegisterProcess( "Assembling", PROCESS )

/*---------------------------------------------------------
  Fishing
---------------------------------------------------------*/
local PROCESS = {}

function PROCESS:OnStart()
	self.Owner:MakeProcessBar( "Fishing", self.Time, self.Cancel )
	self.Owner:EmitSound( "stranded/start_fishing.wav" )
end

function PROCESS:OnStop()
	local num = math.random( 1, 100 )
	
	if ( !self.Owner.Resources['Baits'] or self.Owner.Resources['Baits'] < 1 ) then
		self.Data.Chance = self.Data.Chance * 0.25
	end

	if ( num < self.Data.Chance + self.Owner:GetSkill( "Fishing" ) ) then
		if ( self.Owner.Resources['Baits'] and self.Owner.Resources['Baits'] > 0 ) then
			self.Owner:DecResource( "Baits", 1 )
		end
	
		if ( num < ( self.Data.Chance + self.Owner:GetSkill( "Fishing" ) ) / 1.5 ) then
			self.Owner:IncResource( "Bass", 1 )
			self.Owner:SendMessage( "Bass ( 1x )", 3, Color( 10, 200, 10, 255 ) )
		elseif ( num >= ( self.Data.Chance + self.Owner:GetSkill( "Fishing" ) ) / 1.5 && num < ( self.Data.Chance + self.Owner:GetSkill( "Fishing" ) ) / 1.2 ) then
			self.Owner:IncResource( "Trout", 1 )
			self.Owner:SendMessage( "Trout ( 1x )", 3, Color( 10, 200, 10, 255 ) )
		elseif ( num >= ( self.Data.Chance + self.Owner:GetSkill( "Fishing" ) ) / 1.2 && num < self.Data.Chance + self.Owner:GetSkill( "Fishing" ) ) then
			self.Owner:IncResource( "Salmon", 1 )
			self.Owner:SendMessage( "Salmon ( 1x )", 3, Color( 10, 200, 10, 255 ) )
		end

		self.Owner:IncXP( "Fishing", math.Clamp( math.Round( 50 / self.Owner:GetSkill( "Fishing" ) ), 1, 1000 ) )
		self.Owner:EmitSound( Sound( "ambient/water/water_splash" .. math.random( 1, 3 ) .. ".wav" ) )
	else
		self.Owner:SendMessage( "Failed.", 3, Color( 200, 0, 0, 255 ) )
	end
end

GMS.RegisterProcess( "Fishing", PROCESS )

/*---------------------------------------------------------
  Advanced Fishing
---------------------------------------------------------*/
local PROCESS = {}

function PROCESS:OnStart()
	self.Owner:MakeProcessBar( "Fishing", self.Time, self.Cancel )
	self.Owner:EmitSound( "stranded/start_fishing.wav" )
end

function PROCESS:OnStop()
	local num = math.random( 1, 100 )

	if ( !self.Owner.Resources['Baits'] or self.Owner.Resources['Baits'] < 1 ) then
		self.Data.Chance = self.Data.Chance * 0.25
	end
	
	if ( num < self.Data.Chance + self.Owner:GetSkill( "Fishing" ) ) then
		if ( self.Owner.Resources['Baits'] and self.Owner.Resources['Baits'] > 0 ) then
			self.Owner:DecResource( "Baits", 1 )
		end
	
		if ( num < ( self.Data.Chance + self.Owner:GetSkill( "Fishing" ) ) / 2 ) then
			self.Owner:IncResource( "Bass", 1 )
			self.Owner:SendMessage( "Bass ( 1x )", 3, Color( 10, 200, 10, 255 ) )
		elseif ( num >= ( self.Data.Chance + self.Owner:GetSkill( "Fishing" ) ) / 2 && num < ( self.Data.Chance + self.Owner:GetSkill( "Fishing" ) ) / 1.5 ) then
			self.Owner:IncResource( "Trout", 1 )
			self.Owner:SendMessage( "Trout ( 1x )", 3, Color( 10, 200, 10, 255 ) )
		elseif ( num >= ( self.Data.Chance + self.Owner:GetSkill( "Fishing" ) ) / 1.5 && num < ( self.Data.Chance + self.Owner:GetSkill( "Fishing" ) ) / 1.2 ) then
			self.Owner:IncResource( "Salmon", 1 )
			self.Owner:SendMessage( "Salmon ( 1x )", 3, Color( 10, 200, 10, 255 ) )
		elseif ( num >= ( self.Data.Chance + self.Owner:GetSkill( "Fishing" ) ) / 1.2 && num < self.Data.Chance + self.Owner:GetSkill( "Fishing" ) ) then
			self.Owner:IncResource( "Shark", 1 )
			self.Owner:SendMessage( "Shark ( 1x )", 3, Color( 10, 200, 10, 255 ) )
		end

		self.Owner:IncXP( "Fishing", math.Clamp( math.Round( 50 / self.Owner:GetSkill( "Fishing" ) ), 1, 1000 ) )
		self.Owner:EmitSound( Sound( "ambient/water/water_splash" .. math.random( 1, 3 ) .. ".wav" ) )
	else
		self.Owner:SendMessage( "Failed.", 3, Color( 200, 0, 0, 255 ) )
	end
end

GMS.RegisterProcess( "AdvancedFishing", PROCESS )

/*---------------------------------------------------------
  Bottle Water
---------------------------------------------------------*/
local PROCESS = {}

function PROCESS:OnStart()
	self.Owner:MakeProcessBar( "Bottling Water", self.Time, self.Cancel )
end

function PROCESS:OnStop()
	self.Owner:IncResource( "Water_Bottles", 1 )
	self.Owner:SendMessage( "Water Bottle ( 1x )", 3, Color( 10, 200, 10, 255 ) )
	self.Owner:EmitSound( Sound( "ambient/water/water_spray" .. math.random( 1, 3 ) .. ".wav" ) )
end

GMS.RegisterProcess( "BottleWater", PROCESS )

/*---------------------------------------------------------
  Drink bottle
---------------------------------------------------------*/
local PROCESS = {}

function PROCESS:OnStart()
	self.Owner:MakeProcessBar( "Drinking Bottle", self.Time, self.Cancel )
	self.StartTime = CurTime()

	self:PlaySound()
end

function PROCESS:PlaySound()
	if ( CurTime() - self.StartTime > self.Time ) then return end
	if ( !self.Owner.InProcess || self.StartTime != self.Owner.ProcessTable.StartTime ) then return end

	if ( self.Owner:Alive() ) then
		self.Owner:EmitSound( Sound( "npc/barnacle/barnacle_gulp" .. math.random( 1, 2 ) .. ".wav" ) )
		timer.Simple( 0.75, function() self:PlaySound() end )
	end
end

function PROCESS:OnStop()
	self.Owner:DecResource( "Water_Bottles", 1 )
	self.Owner:SendMessage( "You're a little less thirsty now.", 3, Color( 10, 200, 10, 255 ) )
	if ( self.Owner.Thirst <= 750 ) then
		self.Owner:SetThirst( self.Owner.Thirst + 250 )
	elseif ( self.Owner.Thirst >= 750 ) then
		self.Owner:SetThirst( 1000 )
	end
end

PROCESS.Cancel = false

GMS.RegisterProcess( "DrinkBottle", PROCESS )

/*---------------------------------------------------------
  Take Medicine
---------------------------------------------------------*/
local PROCESS = {}

function PROCESS:OnStart()
	if ( self.Owner:Health() >= 200 or ( self.Owner:Health() >= 150 and self.Owner:HasUnlock( "Master_Survivalist" ) != true ) or ( self.Owner:Health() >= 100 and self.Owner:HasUnlock( "Adept_Survivalist" ) != true ) ) then 
		self.Owner:SendMessage( "You're feeling good, why would you heal yourself.", 3, Color( 200, 0, 0, 255 ) )
	else
		self.Owner:MakeProcessBar( "Taking Medicine", self.Time, self.Cancel )
		self.Owner:EmitSound( Sound( "items/smallmedkit1.wav" ) )
	end
end

function PROCESS:OnStop()
	if ( self.Owner:Health() >= 200 or ( self.Owner:Health() >= 150 and self.Owner:HasUnlock( "Master_Survivalist" ) != true ) or ( self.Owner:Health() >= 100 and self.Owner:HasUnlock( "Adept_Survivalist" ) != true ) ) then return end 
	self.Owner:DecResource( "Medicine", 1 )
	self.Owner:SendMessage( "You're feeling a bit better now.", 3, Color( 10, 200, 10, 255 ) )
	self.Owner:Heal( 10 )
end

GMS.RegisterProcess( "TakeMedicine", PROCESS )

/*---------------------------------------------------------
  Cooking
---------------------------------------------------------*/
local PROCESS = {}

function PROCESS:OnStart()
	self.Owner:MakeProcessBar( "Cooking " .. self.Data.Name, self.Time, self.Cancel )
	self.Sound = CreateSound( self.Owner, Sound( "npc/headcrab/headcrab_burning_loop2.wav" ) )
	self.Sound:Play()
end

function PROCESS:OnStop()
	local num = math.random( 1, 100 )

	if ( num + self.Owner:GetSkill( "Cooking" ) >= 50 ) then
		self.Owner:SendMessage( "Successfully cooked.", 3, Color( 10, 200, 10, 255 ) )
		self.Owner:IncXP( "Cooking", math.Clamp( math.Round( 50 / self.Owner:GetSkill( "Cooking" ) ), 1, 1000 ) )

		local food = ents.Create( "gms_food" )
		food:SetPos( self.Owner:TraceFromEyes( 70 ).HitPos + Vector( 0, 0, 5 ) )
		SPropProtection.PlayerMakePropOwner( self.Owner, food )
		food.Value = self.Data.FoodValue
		food.Name = self.Data.Name
		food:Spawn()
		food:SetFoodInfo( self.Data.Name )

		timer.Simple( math.random( 240, 320 ), function() if ( IsValid( food ) ) then food:Fadeout( 2 ) end end )

		for k, v in pairs( self.Data.Cost ) do self.Owner:DecResource( k, v ) end
	else
		self.Owner:SendMessage( "Failed.", 3, Color( 200, 0, 0, 255 ) )

		local num = math.random( 1, 2 )

		if ( num == 1 ) then
			for k, v in pairs( self.Data.Cost ) do
				self.Owner:DecResource( k, v )
			end
			self.Owner:SendMessage( "The ingredients was wasted!", 3, Color( 200, 0, 0, 255 ) )
		end
	end

	self.Sound:Stop()
end

GMS.RegisterProcess( "Cook", PROCESS )

/*---------------------------------------------------------
  Make Weapon
---------------------------------------------------------*/
local PROCESS = {}

function PROCESS:OnStart()
	self.Owner:MakeProcessBar( "Crafting " .. self.Data.Name, self.Time, self.Cancel )
end

function PROCESS:OnStop()
	self.Owner:SendMessage( "Made a " .. self.Data.Name .. ".", 3, Color( 10, 200, 10, 255 ) )
	self.Owner:IncXP( "Weapon_Crafting", math.Clamp( math.Round( 50 / self.Owner:GetSkill( "Weapon_Crafting" ) ), 1, 1000 ) )

	if ( self.Owner:HasWeapon( self.Data.Class ) ) then
		local weap = ents.Create( self.Data.Class )
		weap:SetPos( self.Owner:TraceFromEyes( 100 ).HitPos + Vector( 0, 0, 15 ) )
		weap:Spawn()
		SPropProtection.PlayerMakePropOwner( self.Owner, weap )
	else
		self.Owner:Give( self.Data.Class )
	end

	for k, v in pairs( self.Data.Cost ) do
		self.Owner:DecResource( k, v )
	end
end

GMS.RegisterProcess( "MakeWeapon", PROCESS )

/*---------------------------------------------------------
  MakeGeneric
---------------------------------------------------------*/
local PROCESS = {}

function PROCESS:OnStart()
	self.Owner:MakeProcessBar( "Making " .. self.Data.Name, self.Time, self.Cancel )
end

function PROCESS:OnStop()
	for k, v in pairs( self.Data.Cost ) do
		self.Owner:DecResource( k, v )
	end

	for k, v in pairs( self.Data.Res ) do
		self.Owner:SendMessage( "Made " .. string.gsub( k, "_", " " ) .. " ( " .. v .. "x )", 3, Color( 10, 200, 10, 255 ) )
		self.Owner:IncResource( k, v )
	end
end

GMS.RegisterProcess( "MakeGeneric", PROCESS )

/*---------------------------------------------------------
  Make Building
---------------------------------------------------------*/
local PROCESS = {}

function PROCESS:OnStart()
	self.Owner:MakeProcessBar( "Setting up " .. self.Data.Name .. " site", self.Time, self.Cancel )
end

function PROCESS:OnStop()
	self.Owner:SendMessage( "Made a " .. self.Data.Name .. " site.", 3, Color( 10, 200, 10, 255 ) )

	if ( self.Owner:GetBuildingSite() and self.Owner:GetBuildingSite():IsValid() ) then
		ent = self.Owner:GetBuildingSite()
		ent:Remove()
	end

	local site = self.Owner:CreateStructureBuildingSite( self.Data.Pos, self.Owner:GetAngles(), self.Data.BuildSiteModel, self.Data.Class, self.Data.Cost, self.Data.Name )
end

GMS.RegisterProcess( "MakeBuilding", PROCESS )

/* Smelt */
local PROCESS = {}

function PROCESS:OnStart()
	self.Owner:MakeProcessBar( "Smelting " .. self.Data.Name, self.Time, self.Cancel )
end

function PROCESS:OnStop()
	for k, v in pairs( self.Data.Cost ) do
		self.Owner:DecResource( k, v )
	end

	for k, v in pairs( self.Data.Res ) do
		self.Owner:SendMessage( "Made " .. string.gsub( k, "_", " " ) .. " ( " .. v .. "x )", 3, Color( 10, 200, 10, 255 ) )
		self.Owner:IncResource( k, v )

		self.Owner:IncXP( "Smelting", math.Clamp( math.Round( ( v * 10 ) / self.Owner:GetSkill( "Smelting" ) ), 1, 1000 ) )
	end
end

GMS.RegisterProcess( "Smelt", PROCESS )

/* Crush */
local PROCESS = {}

function PROCESS:OnStart()
	self.Owner:MakeProcessBar( "Crushing " .. self.Data.Name, self.Time, self.Cancel )
end

function PROCESS:OnStop()
	for k, v in pairs( self.Data.Cost ) do
		self.Owner:DecResource( k, v )
	end

	for k, v in pairs( self.Data.Res ) do
		self.Owner:SendMessage( "Made " .. string.gsub( k, "_", " " ) .. " ( " .. v .. "x )", 3, Color( 10, 200, 10, 255 ) )
		self.Owner:IncResource( k, v )
	end
end

GMS.RegisterProcess( "Crush", PROCESS )

/* Processing */
local PROCESS = {}

function PROCESS:OnStart()
	self.Owner:MakeProcessBar( "Processing " .. self.Data.Name, self.Time, self.Cancel )
end

function PROCESS:OnStop()
	for k, v in pairs( self.Data.Cost ) do
		self.Owner:DecResource( k, v )
	end

	for k, v in pairs( self.Data.Res ) do
		self.Owner:IncXP( "Weapon_Crafting", math.Clamp( math.Round( 50 / self.Owner:GetSkill( "Weapon_Crafting" ) ), 1, 1000 ) )
		self.Owner:SendMessage( "Made " .. string.gsub( k, "_", " " ) .. " ( " .. v .. "x )", 3, Color( 10, 200, 10, 255 ) )
		self.Owner:IncResource( k, v )
	end
end

GMS.RegisterProcess( "Processing", PROCESS )
