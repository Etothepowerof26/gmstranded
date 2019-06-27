/*------------------------ Gun Lab ------------------------*/

/* Smg */
local COMBI = {}

COMBI.Name = "Sub Machine Gun"
COMBI.Description = "Will blow the head off the target"
COMBI.Entity = "gms_gunlab"

COMBI.Req = {}
COMBI.Req["Gunslide"] = 2
COMBI.Req["Gungrip"] = 2
COMBI.Req["Gunbarrel"] = 2
COMBI.Req["Gunmagazine"] = 2

COMBI.SkillReq = {}
COMBI.SkillReq["Weapon_Crafting"] = 7
COMBI.SkillReq["Hunting"] = 10

COMBI.Texture = "gms_icons/weapon_smg1.png"
COMBI.SwepClass = "weapon_smg1"

GMS.RegisterCombi(COMBI, "gms_gunlab")

/* Pistol */
local COMBI = {}

COMBI.Name = "Pistol"
COMBI.Description = "It's not great, but it does the job"
COMBI.Entity = "gms_gunlab"

COMBI.Req = {}
COMBI.Req["Gunslide"] = 1
COMBI.Req["Gungrip"] = 1
COMBI.Req["Gunbarrel"] = 1
COMBI.Req["Gunmagazine"] = 1

COMBI.SkillReq = {}
COMBI.SkillReq["Weapon_Crafting"] = 6
COMBI.SkillReq["Hunting"] = 7

COMBI.Texture = "gms_icons/weapon_pistol.png"
COMBI.SwepClass = "weapon_pistol"

GMS.RegisterCombi(COMBI, "gms_gunlab")

/* Pistol ammo */
local COMBI = {}

COMBI.Name = "Pistol ammo"
COMBI.Description = "If you wanna keep using the pistol, you'll need this"
COMBI.Entity = "gms_gunlab"

COMBI.Req = {}
COMBI.Req["Iron"] = 5
COMBI.Req["Gunpowder"] = 5

COMBI.SkillReq = {}
COMBI.SkillReq["Weapon_Crafting"] = 5

COMBI.Texture = "gms_icons/item_ammo_pistol.png"
COMBI.SwepClass = "item_ammo_pistol"

GMS.RegisterCombi(COMBI, "gms_gunlab")

/* Smg ammo */
local COMBI = {}

COMBI.Name = "SMG Ammo"
COMBI.Description = "If you wanna keep using the smg, you'll need this"
COMBI.Entity = "gms_gunlab"

COMBI.Req = {}
COMBI.Req["Iron"] = 10
COMBI.Req["Gunpowder"] = 10

COMBI.SkillReq = {}
COMBI.SkillReq["Weapon_Crafting"] = 5

COMBI.Texture = "gms_icons/item_ammo_smg1.png"
COMBI.SwepClass = "item_ammo_smg1"

GMS.RegisterCombi(COMBI, "gms_gunlab")
