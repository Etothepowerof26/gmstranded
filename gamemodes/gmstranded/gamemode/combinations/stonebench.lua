/* ------------------------ Stone Workbench ------------------------*/

/* Stone Hatchet */
local COMBI = {}

COMBI.Name = "Stone Hatchet"
COMBI.Description = "This small stone axe is ideal for chopping down trees."
COMBI.Entity = "gms_stoneworkbench"

COMBI.Req = {}
COMBI.Req["Stone"] = 5
COMBI.Req["Wood"] = 10

COMBI.Texture = "gms_icons/gms_weapon.png"
COMBI.SwepClass = "gms_stonehatchet"

GMS.RegisterCombi(COMBI, "gms_stoneworkbench")

/* Wooden Spoon */
local COMBI = {}

COMBI.Name = "Wooden Spoon"
COMBI.Description = "Allows you to salvage more seeds from consumed fruit."
COMBI.Entity = "gms_stoneworkbench"

COMBI.Req = {}
COMBI.Req["Wood"] = 12

COMBI.SkillReq = {}
COMBI.SkillReq["Weapon_Crafting"] = 3

COMBI.Texture = "gms_icons/gms_weapon.png"
COMBI.SwepClass = "gms_woodenspoon"

GMS.RegisterCombi(COMBI, "gms_stoneworkbench")

/* Stone Pickaxe */
local COMBI = {}

COMBI.Name = "Stone Pickaxe"
COMBI.Description = "This stone pickaxe is used for effectively mining stone and copper ore."
COMBI.Entity = "gms_stoneworkbench"

COMBI.Req = {}
COMBI.Req["Stone"] = 10
COMBI.Req["Wood"] = 5
COMBI.Texture = "gms_icons/gms_weapon.png"
COMBI.SwepClass = "gms_stonepickaxe"

GMS.RegisterCombi(COMBI, "gms_stoneworkbench")

/* Fishing rod */
local COMBI = {}

COMBI.Name = "Wooden Fishing Rod"
COMBI.Description = "This rod of wood can be used to fish from a lake."
COMBI.Entity = "gms_stoneworkbench"

COMBI.Req = {}
COMBI.Req["Rope"] = 1
COMBI.Req["Wood"] = 20

COMBI.SkillReq = {}
COMBI.SkillReq["Weapon_Crafting"] = 4

COMBI.Texture = "gms_icons/gms_weapon.png"
COMBI.SwepClass = "gms_woodenfishingrod"

GMS.RegisterCombi(COMBI, "gms_stoneworkbench")