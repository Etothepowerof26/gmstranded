
AddCSLuaFile()

SWEP.Slot = 1
SWEP.SlotPos = 1

SWEP.Base = "gms_base_weapon"
SWEP.PrintName = "Fists"
SWEP.ViewModel = "models/weapons/v_gms_fists.mdl"
SWEP.WorldModel = ""

SWEP.Purpose = "Pick up stuff, as well as poor harvesting."
SWEP.Instructions = "Primary fire: Attack/Harvest"
SWEP.HitDistance = 54

function SWEP:DoAnimation()
	self:SendWeaponAnim( ACT_VM_HITCENTER )
end
