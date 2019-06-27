/* ------------------------------------------------------------------------
	Tech workbench
------------------------------------------------------------------------ */

local COMBI = {}

COMBI.Name = "Batteries"
COMBI.Description = "These self-rechargeable batteries are used to craft stunstick, toolgun and flashlight.\nAlso the more batteries you have, the longer you can use your flashlight."

COMBI.Req = {}
COMBI.Req["Copper"] = 3
COMBI.Req["Iron"] = 3

COMBI.Results = {}
COMBI.Results["Batteries"] = 1

GMS.RegisterCombi(COMBI, "gms_techworkbench")

------------------------------------------------------------------------

local COMBI = {}

COMBI.Name = "Toolgun"
COMBI.Description = "Vital to long term survival, it allows you to easily build complex structures."
COMBI.Entity = "gms_techworkbench"

COMBI.Req = {}
COMBI.Req["Iron"] = 30
COMBI.Req["Wood"] = 20
COMBI.Req["Glass"] = 5
COMBI.Req["Batteries"] = 2

COMBI.SkillReq = {}
COMBI.SkillReq["Weapon_Crafting"] = 10

COMBI.Texture = "gms_icons/gms_weapon.png"
COMBI.SwepClass = "gmod_tool"

GMS.RegisterCombi(COMBI, "gms_techworkbench")

------------------------------------------------------------------------

local COMBI = {}

COMBI.Name = "Flashlight"
COMBI.Description = "Grants ability to use flashlight."

COMBI.Req = {}
COMBI.Req["Iron"] = 15
COMBI.Req["Glass"] = 5
COMBI.Req["Batteries"] = 3

COMBI.Results = {}
COMBI.Results["Flashlight"] = 1

GMS.RegisterCombi(COMBI, "gms_techworkbench")

------------------------------------------------------------------------

local COMBI = {}

COMBI.Name = "Stunstick"
COMBI.Description = "This highly advanced, effective melee weapon is useful for hunting down animals and fellow stranded alike."
COMBI.Entity = "gms_techworkbench"

COMBI.Req = {}
COMBI.Req["Iron"] = 40
COMBI.Req["Batteries"] = 4

COMBI.SkillReq = {}
COMBI.SkillReq["Weapon_Crafting"] = 11
COMBI.SkillReq["Hunting"] = 5

COMBI.Texture = "gms_icons/gms_weapon.png"
COMBI.SwepClass = "weapon_stunstick"

GMS.RegisterCombi(COMBI, "gms_techworkbench")

------------------------------------------------------------------------

local COMBI = {}

COMBI.Name = "Wrist Watch"
COMBI.Description = "See the time whereever you go."
COMBI.Entity = "gms_techworkbench"

COMBI.Results = {}
COMBI.Results["Wrist_Watch"] = 1

COMBI.Req = {}
COMBI.Req["Iron"] = 5
COMBI.Req["Glass"] = 5
COMBI.Req["Batteries"] = 2

GMS.RegisterCombi(COMBI, "gms_techworkbench")