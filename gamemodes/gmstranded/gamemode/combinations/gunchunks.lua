/*------------------------ Gun Chunks ------------------------*/

/* Gunslide */
local COMBI = {}

COMBI.Name = "Gunslide"
COMBI.Description = "A piece of a gun"
COMBI.Entity = "gms_gunchunks"

COMBI.Req = {}
COMBI.Req["Wood"] = 25

COMBI.SkillReq = {}
COMBI.SkillReq["Weapon_Crafting"] = 6

COMBI.Results = {}
COMBI.Results["Gunslide"] = 1

GMS.RegisterCombi(COMBI, "gms_gunchunks")

/* Gunbarrel */
local COMBI = {}

COMBI.Name = "Gunbarrel"
COMBI.Description = "A piece of a gun"
COMBI.Entity = "gms_gunchunks"

COMBI.Req = {}
COMBI.Req["Iron"] = 30

COMBI.SkillReq = {}
COMBI.SkillReq["Weapon_Crafting"] = 6

COMBI.Results = {}
COMBI.Results["Gunbarrel"] = 1

GMS.RegisterCombi(COMBI, "gms_gunchunks")

/* Gungrip */
local COMBI = {}

COMBI.Name = "Gungrip"
COMBI.Description = "A piece of a gun"
COMBI.Entity = "gms_gunchunks"

COMBI.Req = {}
COMBI.Req["Iron"] = 30

COMBI.SkillReq = {}
COMBI.SkillReq["Weapon_Crafting"] = 6

COMBI.Results = {}
COMBI.Results["Gungrip"] = 1

GMS.RegisterCombi(COMBI, "gms_gunchunks")

/* Gunmagazine */
local COMBI = {}

COMBI.Name = "Gunmagazine"
COMBI.Description = "A piece of a gun"
COMBI.Entity = "gms_gunchunks"

COMBI.Req = {}
COMBI.Req["Iron"] = 15
COMBI.Req["Gunpowder"] = 5

COMBI.SkillReq = {}
COMBI.SkillReq["Weapon_Crafting"] = 6

COMBI.Results = {}
COMBI.Results["Gunmagazine"] = 1

GMS.RegisterCombi(COMBI, "gms_gunchunks")

/* Saltpetre */
local COMBI = {}

COMBI.Name = "Saltpetre"
COMBI.Description = "Used in making gunpowder"
COMBI.Entity = "gms_gunchunks"

COMBI.Req = {}
COMBI.Req["Urine_Bottles"] = 1

COMBI.Results = {}
COMBI.Results["Saltpetre"] = 1

GMS.RegisterCombi(COMBI, "gms_gunchunks")

/* Saltpetre x10 */
local COMBI = {}

COMBI.Name = "Saltpetre 10x"
COMBI.Description = "Used in making gunpowder"
COMBI.Entity = "gms_gunchunks"

COMBI.Req = {}
COMBI.Req["Urine_Bottles"] = 10

COMBI.Results = {}
COMBI.Results["Saltpetre"] = 10

GMS.RegisterCombi(COMBI, "gms_gunchunks")

/* Gunpowder */
local COMBI = {}

COMBI.Name = "Gunpowder"
COMBI.Description = "Explosive!"
COMBI.Entity = "gms_gunchunks"

COMBI.Req = {}
COMBI.Req["Sulphur"] = 5
COMBI.Req["Charcoal"] = 10
COMBI.Req["Saltpetre"] = 10

COMBI.Results = {}
COMBI.Results["Gunpowder"] = 10

GMS.RegisterCombi(COMBI, "gms_gunchunks")
