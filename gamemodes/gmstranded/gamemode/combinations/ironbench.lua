/* ------------------------ Iron Workbench ------------------------*/

/* Sickle */
local COMBI = {}

COMBI.Name = "Sickle"
COMBI.Description = "This tool effectivizes harvesting."
COMBI.Entity = "gms_ironworkbench"

COMBI.Req = {}
COMBI.Req["Iron"] = 5
COMBI.Req["Wood"] = 15

COMBI.SkillReq = {}
COMBI.SkillReq["Weapon_Crafting"] = 7

COMBI.Texture = "gms_icons/gms_weapon.png"
COMBI.SwepClass = "gms_sickle"

GMS.RegisterCombi(COMBI, "gms_ironworkbench")

/* Strainer */
local COMBI = {}

COMBI.Name = "Strainer"
COMBI.Description = "This tool can filter the earth for resources."
COMBI.Entity = "gms_ironworkbench"

COMBI.Req = {}
COMBI.Req["Iron"] = 5
COMBI.Req["Wood"] = 5

COMBI.SkillReq = {}
COMBI.SkillReq["Weapon_Crafting"] = 10

COMBI.Texture = "gms_icons/gms_weapon.png"
COMBI.SwepClass = "gms_strainer"

GMS.RegisterCombi(COMBI, "gms_ironworkbench")

/* Advanced Fishing rod */
local COMBI = {}

COMBI.Name = "Advanced Fishing rod"
COMBI.Description = "With this Fishing rod you can catch rare fish even faster. You might even catch something big."
COMBI.Entity = "gms_ironworkbench"

COMBI.Req = {}
COMBI.Req["Iron"] = 25
COMBI.Req["Wood"] = 30
COMBI.Req["Rope"] = 2

COMBI.SkillReq = {}
COMBI.SkillReq["Weapon_Crafting"] = 15
COMBI.SkillReq["Fishing"] = 5

COMBI.Texture = "gms_icons/gms_weapon.png"
COMBI.SwepClass = "gms_advancedfishingrod"

GMS.RegisterCombi(COMBI, "gms_ironworkbench")

/* Iron Pickaxe */
local COMBI = {}

COMBI.Name = "Iron Pickaxe"
COMBI.Description = "This iron pickaxe is used for effectively mining stone, copper ore and iron ore."
COMBI.Entity = "gms_ironworkbench"

COMBI.Req = {}
COMBI.Req["Iron"] = 25
COMBI.Req["Wood"] = 5
COMBI.Texture = "gms_icons/gms_weapon.png"
COMBI.SwepClass = "gms_ironpickaxe"

GMS.RegisterCombi(COMBI, "gms_ironworkbench")

/* Iron Hatchet */
local COMBI = {}

COMBI.Name = "Iron Hatchet"
COMBI.Description = "This iron axe is ideal for chopping down trees."
COMBI.Entity = "gms_ironworkbench"

COMBI.Req = {}
COMBI.Req["Iron"] = 25
COMBI.Req["Wood"] = 5

COMBI.Texture = "gms_icons/gms_weapon.png"
COMBI.SwepClass = "gms_ironhatchet"

GMS.RegisterCombi(COMBI, "gms_ironworkbench")