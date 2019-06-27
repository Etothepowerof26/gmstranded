/* ------------------------ Copper Workbench ------------------------*/

/* Copper Hatchet */
local COMBI = {}

COMBI.Name = "Copper Hatchet"
COMBI.Description = "This copper axe is ideal for chopping down trees."
COMBI.Entity = "gms_copperworkbench"

COMBI.Req = {}
COMBI.Req["Copper"] = 10
COMBI.Req["Wood"] = 10

COMBI.Texture = "gms_icons/gms_weapon.png"
COMBI.SwepClass = "gms_copperhatchet"

GMS.RegisterCombi(COMBI, "gms_copperworkbench")

/* Copper Hammer */
local COMBI = {}

COMBI.Name = "Wrench"
COMBI.Description = "This wrench is ideal for crafting weapons."
COMBI.Entity = "gms_copperworkbench"

COMBI.Req = {}
COMBI.Req["Copper"] = 10
COMBI.Req["Wood"] = 10

COMBI.SkillReq = {}
COMBI.SkillReq["Weapon_Crafting"] = 5

COMBI.Texture = "gms_icons/gms_weapon.png"
COMBI.SwepClass = "gms_wrench"

GMS.RegisterCombi(COMBI, "gms_copperworkbench")

/* Copper Pickaxe */
local COMBI = {}

COMBI.Name = "Copper Pickaxe"
COMBI.Description = "This copper pickaxe is used for effectively mining stone, copper ore and iron ore."
COMBI.Entity = "gms_copperworkbench"

COMBI.Req = {}
COMBI.Req["Copper"] = 15
COMBI.Req["Wood"] = 5

COMBI.Texture = "gms_icons/gms_weapon.png"
COMBI.SwepClass = "gms_copperpickaxe"

GMS.RegisterCombi(COMBI, "gms_copperworkbench")

/* Frying pan */
local COMBI = {}

COMBI.Name = "Frying Pan"
COMBI.Description = "This kitchen tool is used for more effective cooking."
COMBI.Entity = "gms_copperworkbench"

COMBI.Req = {}
COMBI.Req["Copper"] = 20
COMBI.Req["Wood"] = 5

COMBI.SkillReq = {}
COMBI.SkillReq["Weapon_Crafting"] = 5

COMBI.Texture = "gms_icons/gms_weapon.png"
COMBI.SwepClass = "gms_fryingpan"

GMS.RegisterCombi(COMBI, "gms_copperworkbench")

/* Shovel */
local COMBI = {}

COMBI.Name = "Shovel"
COMBI.Description = "This tool can dig up rocks, and decreases forage times."
COMBI.Entity = "gms_copperworkbench"

COMBI.Req = {}
COMBI.Req["Copper"] = 15
COMBI.Req["Wood"] = 15

COMBI.SkillReq = {}
COMBI.SkillReq["Weapon_Crafting"] = 8

COMBI.Texture = "gms_icons/gms_weapon.png"
COMBI.SwepClass = "gms_shovel"

GMS.RegisterCombi(COMBI, "gms_copperworkbench")

/* Crowbar */
local COMBI = {}

COMBI.Name = "Crowbar"
COMBI.Description = "This weapon is initially a tool, but pretty useless for it's original purpose on a stranded Island."
COMBI.Entity = "gms_copperworkbench"

COMBI.Req = {}
COMBI.Req["Copper"] = 20
COMBI.Req["Iron"] = 20

COMBI.SkillReq = {}
COMBI.SkillReq["Weapon_Crafting"] = 6

COMBI.Texture = "gms_icons/gms_weapon.png"
COMBI.SwepClass = "weapon_crowbar"

GMS.RegisterCombi(COMBI, "gms_copperworkbench")