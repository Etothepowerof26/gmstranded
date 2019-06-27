
AddCSLuaFile()

ENT.Base = "gms_base_entity"
ENT.PrintName = "Antlion Barrow"

ENT.Model = "models/props_wasteland/antlionhill.mdl"
ENT.DoWake = true

if ( CLIENT ) then return end

function ENT:OnInitialize()
	self:SetNetworkedString( "Owner", "World" )

	self:SetMoveType( MOVETYPE_NONE )

	self.Antlions = {}
	self.MaxAntlions = 5
	self.Spawning = false

	timer.Create( "CheckSurroundings_" .. self:EntIndex(), 2, 0, function() self:CheckSurroundings() end )
end

function ENT:SpawnAntlion()
	local offset = Vector( math.random( -500, 500 ), math.random( -500, 500 ), 100 )
	local retries = 100

	while ( ( !util.IsInWorld( offset ) && retries > 0 ) || self:LocalToWorld( offset ):Distance( self:GetPos() ) < 100 ) do
		offset = Vector( math.random( -500, 500 ), math.random( -500, 500 ), 100 )
		retries = retries - 1
	end

	local tr = util.TraceLine( {
		start = self:GetPos() + offset,
		endpos = self:GetPos() + offset + Vector( 0, 0, -10000 ),
		mask = MASK_SOLID,
		filter = self
	} )

	local ant = ents.Create( "npc_antlion" )
	ant:SetPos( tr.HitPos + Vector( 0, 0, 16 ) )
	ant:SetNWString( "Owner", "World" )
	ant:SetKeyValue( "startburrowed", "1" )
	ant:Spawn()
	ant:SetHealth( 75 )
	ant:Fire( "Unburrow" )

	table.insert( self.Antlions, ant )
end

function ENT:CheckSurroundings()
	local max = self.MaxAntlions
	if ( IsNight ) then max = math.ceil( max * 1.4 ) end

	for k, v in pairs( self.Antlions ) do
		if ( !IsValid( v ) or ( !IsNight && #self.Antlions > max ) ) then
			if ( IsValid( v ) ) then v:Fire( "BurrowAway" ) end
			table.remove( self.Antlions, k )
		elseif ( v:WaterLevel() > 2 ) then
			timer.Simple( 8, function() if ( IsValid( v ) ) then v:SetHealth( 0 ) end end)
			table.remove( self.Antlions, k )
		else
			local enemy = v:GetEnemy()
			if ( ( IsValid( enemy ) && enemy:GetPos():Distance( self:GetPos() ) > 1500 ) or v:GetPos():Distance( self:GetPos() ) > 1500 ) then
				v:SetEnemy( nil )
				v:ClearEnemyMemory()
				local pos = self:GetPos() + Vector( math.random( -500, 500 ), math.random( -500, 500 ), 0 )
				while ( self:LocalToWorld( pos ):Distance( self:GetPos() ) < 100 ) do
					pos = self:GetPos() + Vector( math.random( -500, 500 ), math.random( -500, 500 ), 0 )
				end
				v:SetLastPosition( pos )
				v:SetSchedule( 71 )
			end
		end
	end

	if ( #self.Antlions < max and !self.Spawning ) then
		timer.Create( "gms_antlionspawntimers_" .. self:EntIndex(), math.random( 20, 60 ), 1, function() self:AddAntlion() end)
		self.Spawning = true
	end
end

function ENT:AddAntlion()
	self:SpawnAntlion()
	self.Spawning = false
end

function ENT:KeyValue( k, v )
	if ( k == "MaxAntlions" ) then
		self.MaxAntlions = tonumber( v ) or 5
	end
end

function ENT:OnRemove()
	for k, ant in pairs( self.Antlions ) do
		if ( IsValid( ant ) ) then ant:Fadeout() end
	end

	timer.Destroy( "CheckSurroundings_" .. self:EntIndex() )
	timer.Destroy( "gms_antlionspawntimers_" .. self:EntIndex() )
end
