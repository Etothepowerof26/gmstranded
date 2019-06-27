-- module("umsg", package.seeall)

umsg.LastPlayer = nil

function umsg.Start(string, ply)
	if util.NetworkStringToID(string) == 0 then
		util.AddNetworkString(string)
	end
	
	net.Start(string)
	LastPlayer = ply
end

function umsg.End()
	if not umsg.LastPlayer then
		error("wtf you doing")
	end
	
	local ply = umsg.LastPlayer
	net.Send(ply)
end

function umsg.Angle(ang)        net.WriteAngle(ang) end
function umsg.Bool(bool)        net.WriteBool(bool) end
function umsg.Char(char)        net.WriteString(char) end
function umsg.Entity(ent)       net.WriteEntity(ent) end
function umsg.Float(float)      net.WriteFloat(float) end
function umsg.Long(long)        net.WriteInt(short, 64) end
function umsg.Short(short)      net.WriteInt(short, 32) end
function umsg.String(str)       net.WriteString(str) end
function umsg.Vector(vec)       net.WriteVector(vec) end
function umsg.VectorNormal(vec) net.WriteVector(vec) end