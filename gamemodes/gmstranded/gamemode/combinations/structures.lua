/* ------------------------ Structures ------------------------*/

/* Resource Pack */
local COMBI = {}

COMBI.Name = "Resource Pack"
COMBI.Description = "You can use the resource pack to store multiple resources in it. Highly recommended."

COMBI.Req = {}
COMBI.Req["Wood"] = 20
COMBI.Req["Stone"] = 10

COMBI.Results = "gms_resourcepack"
COMBI.Texture = "gms_icons/gms_resourcepack.png"
COMBI.BuildSiteModel = "models/items/item_item_crate.mdl"

GMS.RegisterCombi(COMBI, "Structures")

------------------------------------------------------------------------

local COMBI = {}

COMBI.Name = "Clock"
COMBI.Description = "Shows you world time."

COMBI.Req = {}
COMBI.Req["Iron"] = 10
COMBI.Req["Glass"] = 10

COMBI.Results = "gms_clock_big"
COMBI.Texture = "gms_icons/gms_clock_big.png"
COMBI.BuildSiteModel = "models/props_trainstation/trainstation_clock001.mdl"

GMS.RegisterCombi(COMBI, "Structures")

/* Fridge */
local COMBI = {}

COMBI.Name = "Fridge"
COMBI.Description = "You can use the fridge to store food in it. It will not spoil inside. Highly recommended."

COMBI.Req = {}
COMBI.Req["Iron"] = 20

COMBI.Results = "gms_fridge"
COMBI.Texture = "gms_icons/gms_fridge.png"
COMBI.BuildSiteModel = "models/props_c17/FurnitureFridge001a.mdl"

GMS.RegisterCombi(COMBI, "Structures")

/* Stone Workbench */
local COMBI = {}

COMBI.Name = "Stone Workbench"
COMBI.Description = "This stone table has various fine specialized equipment used in crafting basic items."

COMBI.Req = {}
COMBI.Req["Wood"] = 20
COMBI.Req["Stone"] = 30

COMBI.Results = "gms_stoneworkbench"
COMBI.Texture = "gms_icons/gms_stoneworkbench.png"
COMBI.BuildSiteModel = "models/props/de_piranesi/pi_merlon.mdl"

GMS.RegisterCombi(COMBI, "Structures")

/* Copper Workbench */
local COMBI = {}

COMBI.Name = "Copper Workbench"
COMBI.Description = "This Copper table has various fine specialized equipment used in crafting quality items."

COMBI.Req = {}
COMBI.Req["Copper"] = 30
COMBI.Req["Stone"] = 10
COMBI.Req["Wood"] = 20

COMBI.Results = "gms_copperworkbench"
COMBI.Texture = "gms_icons/gms_copperworkbench.png"
COMBI.BuildSiteModel = "models/props_combine/breendesk.mdl"

GMS.RegisterCombi(COMBI, "Structures")

/* Iron Workbench */
local COMBI = {}

COMBI.Name = "Iron Workbench"
COMBI.Description = "This iron table has various fine specialized equipment used in crafting advanced items."

COMBI.Req = {}
COMBI.Req["Iron"] = 30
COMBI.Req["Stone"] = 20
COMBI.Req["Wood"] = 10

COMBI.Results = "gms_ironworkbench"
COMBI.Texture = "gms_icons/gms_ironworkbench.png"
COMBI.BuildSiteModel = "models/props_wasteland/controlroom_desk001b.mdl"

GMS.RegisterCombi(COMBI, "Structures")

/* Tech Workbench */
local COMBI = {}

COMBI.Name = "Tech Workbench"
COMBI.Description = "This tech workbench will help you with all your electronic needs."

COMBI.Req = {}
COMBI.Req["Iron"] = 30
COMBI.Req["Copper"] = 20
COMBI.Req["Glass"] = 10

COMBI.Results = "gms_techworkbench"
COMBI.Texture = "gms_icons/gms_techworkbench.png"
COMBI.BuildSiteModel = "models/props_lab/reciever_cart.mdl"

GMS.RegisterCombi(COMBI, "Structures")

/* Drinking Fountain */
local COMBI = {}

COMBI.Name = "Drinking Fountain"
COMBI.Description = "PORTABLE WATER?!"

COMBI.Req = {}
COMBI.Req["Copper"] = 50
COMBI.Req["Iron"] = 50
COMBI.Req["Water_Bottles"] = 50

COMBI.Results = "gms_waterfountain"
COMBI.Texture = "gms_icons/gms_waterfountain.png"
COMBI.BuildSiteModel = "models/props/de_inferno/fountain.mdl"

GMS.RegisterCombi(COMBI, "Structures")

/* Stove */
local COMBI = {}

COMBI.Name = "Stove"
COMBI.Description = "Using a stove, you can cook without having to light a fire."

COMBI.Req = {}
COMBI.Req["Copper"] = 35
COMBI.Req["Iron"] = 35
COMBI.Req["Wood"] = 35

COMBI.Results = "gms_stove"
COMBI.Texture = "gms_icons/gms_stove.png"
COMBI.BuildSiteModel = "models/props_c17/furniturestove001a.mdl"

GMS.RegisterCombi(COMBI, "Structures")

/* Stone Furnace */
local COMBI = {}

COMBI.Name = "Stone Furnace"
COMBI.Description = "You can use the furnace to smelt resources into another, such as Copper Ore into Copper."

COMBI.Req = {}
COMBI.Req["Stone"] = 35

COMBI.Results = "gms_stonefurnace"
COMBI.Texture = "gms_icons/gms_stonefurnace.png"
COMBI.BuildSiteModel = "models/props/de_inferno/ClayOven.mdl"

GMS.RegisterCombi(COMBI, "Structures")

/* Copper Furnace */
local COMBI = {}

COMBI.Name = "Copper Furnace"
COMBI.Description = "You can use the furnace to smelt resources into another, such as Iron Ore into Iron."

COMBI.Req = {}
COMBI.Req["Copper"] = 35

COMBI.Results = "gms_copperfurnace"
COMBI.Texture = "gms_icons/gms_copperfurnace.png"
COMBI.BuildSiteModel = "models/props/cs_militia/furnace01.mdl"

GMS.RegisterCombi(COMBI, "Structures")

/* Iron Furnace */
local COMBI = {}

COMBI.Name = "Iron Furnace"
COMBI.Description = "You can use the furnace to smelt resources into another, such as Sand into Glass."

COMBI.Req = {}
COMBI.Req["Iron"] = 35

COMBI.Results = "gms_ironfurnace"
COMBI.Texture = "gms_icons/gms_ironfurnace.png"
COMBI.BuildSiteModel = "models/props_c17/furniturefireplace001a.mdl"

GMS.RegisterCombi(COMBI, "Structures")

/* Grinding Stone */
local COMBI = {}

COMBI.Name = "Grinding Stone"
COMBI.Description = "You can use the grinding stone to smash resources into smaller things, such as stone into sand."

COMBI.Req = {}
COMBI.Req["Stone"] = 40

COMBI.Results = "gms_grindingstone"
COMBI.Texture = "gms_icons/gms_grindingstone.png"
COMBI.BuildSiteModel = "models/props_combine/combine_mine01.mdl"

GMS.RegisterCombi(COMBI, "Structures")

/* Factory */
local COMBI = {}

COMBI.Name = "Factory"
COMBI.Description = "You can use the factory to smelt resources into another and extract resources out of other resources."

COMBI.Req = {}
COMBI.Req["Iron"] = 200
COMBI.Req["Copper"] = 100
COMBI.Req["Stone"] = 50

COMBI.Results = "gms_factory"
COMBI.Texture = "gms_icons/gms_factory.png"
COMBI.BuildSiteModel = "models/props_c17/factorymachine01.mdl"

GMS.RegisterCombi(COMBI, "Structures")

/* Gunlab */
local COMBI = {}

COMBI.Name = "Gunlab"
COMBI.Description = "For making the components of guns with relative ease."

COMBI.Req = {}
COMBI.Req["Iron"] = 100
COMBI.Req["Wood"] = 150

COMBI.Results = "gms_gunlab"
COMBI.Texture = "gms_icons/gms_gunlab.png"
COMBI.BuildSiteModel = "models/props/cs_militia/gun_cabinet.mdl"

GMS.RegisterCombi(COMBI, "Structures")

/* GunChunks */
local COMBI = {}

COMBI.Name = "Gun Chunks"
COMBI.Description = "For making the components of guns with relative ease."

COMBI.Req = {}
COMBI.Req["Iron"] = 50
COMBI.Req["Copper"] = 25
COMBI.Req["Wood"] = 25

COMBI.Results = "gms_gunchunks"
COMBI.Texture = "gms_icons/gms_gunchunks.png"
COMBI.BuildSiteModel = "models/Gibs/airboat_broken_engine.mdl"

GMS.RegisterCombi(COMBI, "Structures")