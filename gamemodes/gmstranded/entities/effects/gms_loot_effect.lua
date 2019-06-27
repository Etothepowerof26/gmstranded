
AddCSLuaFile()

function EFFECT:Init( data )
	local pos = data:GetOrigin()
	local NumParticles = 8
	local emitter = ParticleEmitter( pos, true )
	local color = Color( 255, 255, 100, 255 )

	for i = 0, NumParticles do
		local offset = Vector( math.random( -16, 16 ), math.random( -16, 16 ), 0 )
		local particle = emitter:Add( "particle/fire", pos + offset )
		if ( particle ) then
			particle:SetLifeTime( 0 )
			particle:SetDieTime( 3 )

			particle:SetGravity( Vector( 0, 0, 32 ) )
			particle:SetVelocity( Vector( math.random( -16, 16 ), math.random( -16, 16 ), 0 ) )

			particle:SetStartSize( math.Rand( 3, 6 ) )
			particle:SetEndSize( 0 )

			particle:SetRoll( math.Rand( 0, 360 ) )
			particle:SetRollDelta( math.Rand( -4, 4 ) )

			local RandDarkness = math.Rand( 0, 0.5 )
			particle:SetColor( color.r * RandDarkness, color.g * RandDarkness, color.b * RandDarkness )
			particle:SetAngleVelocity( Angle( math.Rand( -180, 180 ), math.Rand( -180, 180 ), math.Rand( -180, 180 ) ) ) 
			//particle:SetLighting( true )
		end
	end

	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
