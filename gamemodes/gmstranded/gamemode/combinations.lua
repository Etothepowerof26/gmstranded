
GMS.Combinations = {}
function GMS.RegisterCombi( tbl, group )
	if ( !GMS.Combinations[ group ] ) then GMS.Combinations[ group ] = {} end
	GMS.Combinations[ group ][ string.Replace( tbl.Name, " ", "_" ) ] = tbl
end


/* ------------------------ Combinations ------------------------*/

/* Flour */
local COMBI = {}

COMBI.Name = "Flour"
COMBI.Description = "Flour can be used for making dough."

COMBI.Req = {}
COMBI.Req["Stone"] = 1
COMBI.Req["Grain_Seeds"] = 2

COMBI.Results = {}
COMBI.Results["Flour"] = 1
COMBI.Results["Stone"] = 1

GMS.RegisterCombi( COMBI, "Combinations" )

/* Spice */
local COMBI = {}

COMBI.Name = "Spices"
COMBI.Description = "Spice can be used for various meals."

COMBI.Req = {}
COMBI.Req["Stone"] = 1
COMBI.Req["Herbs"] = 2

COMBI.Results = {}
COMBI.Results["Spices"] = 1
COMBI.Results["Stone"] = 1

GMS.RegisterCombi( COMBI, "Combinations" )

/* Dough */
local COMBI = {}

COMBI.Name = "Dough"
COMBI.Description = "Dough is used for baking."

COMBI.Req = {}
COMBI.Req["Water_Bottles"] = 1
COMBI.Req["Flour"] = 2

COMBI.Results = {}
COMBI.Results["Dough"] = 1

GMS.RegisterCombi( COMBI, "Combinations" )

/* Dough x10 */
local COMBI = {}

COMBI.Name = "Dough 10x"
COMBI.Description = "Dough is used for baking."

COMBI.Req = {}
COMBI.Req["Water_Bottles"] = 7
COMBI.Req["Flour"] = 15

COMBI.Results = {}
COMBI.Results["Dough"] = 10

GMS.RegisterCombi( COMBI, "Combinations" )

/* Rope */
local COMBI = {}

COMBI.Name = "Rope"
COMBI.Description = "Allows you to use Rope tool ( Using Rope Tool will consume the Rope ) and used in fishing rod crafting."

COMBI.Req = {}
COMBI.Req["Herbs"] = 5
COMBI.Req["Wood"] = 2
COMBI.Req["Water_Bottles"] = 1

COMBI.Results = {}
COMBI.Results["Rope"] = 1

GMS.RegisterCombi( COMBI, "Combinations" )

/* Welder */
local COMBI = {}

COMBI.Name = "Welder"
COMBI.Description = "Allows you to use Weld Tool. You still need the Tool Gun though."

COMBI.Req = {}
COMBI.Req[ "Wood" ] = 10
COMBI.Req[ "Stone" ] = 10
COMBI.Req[ "Water_Bottles" ] = 1

COMBI.Results = {}
COMBI.Results[ "Welder" ] = 1

GMS.RegisterCombi( COMBI, "Combinations" )

/* Concrete */
local COMBI = {}

COMBI.Name = "Concrete"
COMBI.Description = "Concrete can be used for spawning concrete props."

COMBI.Req = {}
COMBI.Req["Sand"] = 5
COMBI.Req["Water_Bottles"] = 2

COMBI.Results = {}
COMBI.Results["Concrete"] = 1

GMS.RegisterCombi( COMBI, "Combinations" )

/* Urine */
local COMBI = {}

COMBI.Name = "Urine"
COMBI.Description = "Drink some water and wait, used in gunpowder production."

COMBI.Req = {}
COMBI.Req["Water_Bottles"] = 2

COMBI.Results = {}
COMBI.Results["Urine_Bottles"] = 1

GMS.RegisterCombi( COMBI, "Combinations" )

/* Urine 10x */
local COMBI = {}

COMBI.Name = "Urine 10x"
COMBI.Description = "Drink loads of water and wait, messy, but used in gunpowder production."

COMBI.Req = {}
COMBI.Req["Water_Bottles"] = 20

COMBI.Results = {}
COMBI.Results["Urine_Bottles"] = 10

GMS.RegisterCombi( COMBI, "Combinations" )

/* Medicine */
local COMBI = {}

COMBI.Name = "Medicine"
COMBI.Description = "To restore your health."

COMBI.Req = {}
COMBI.Req["Water_Bottles"] = 2
COMBI.Req["Herbs"] = 5
COMBI.Req["Urine_Bottles"] = 1

COMBI.Results = {}
COMBI.Results["Medicine"] = 1

GMS.RegisterCombi( COMBI, "Combinations" )


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

GMS.RegisterCombi( COMBI, "Structures" )

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

GMS.RegisterCombi( COMBI, "Structures" )

/* Fridge */
local COMBI = {}

COMBI.Name = "Fridge"
COMBI.Description = "You can use the fridge to store food in it. It will not spoil inside. Highly recommended."

COMBI.Req = {}
COMBI.Req["Iron"] = 20

COMBI.Results = "gms_fridge"
COMBI.Texture = "gms_icons/gms_fridge.png"
COMBI.BuildSiteModel = "models/props_c17/FurnitureFridge001a.mdl"

GMS.RegisterCombi( COMBI, "Structures" )

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

GMS.RegisterCombi( COMBI, "Structures" )

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

GMS.RegisterCombi( COMBI, "Structures" )

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

GMS.RegisterCombi( COMBI, "Structures" )

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

GMS.RegisterCombi( COMBI, "Structures" )

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

GMS.RegisterCombi( COMBI, "Structures" )

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

GMS.RegisterCombi( COMBI, "Structures" )

/* Stone Furnace */
local COMBI = {}

COMBI.Name = "Stone Furnace"
COMBI.Description = "You can use the furnace to smelt resources into another, such as Copper Ore into Copper."

COMBI.Req = {}
COMBI.Req["Stone"] = 35

COMBI.Results = "gms_stonefurnace"
COMBI.Texture = "gms_icons/gms_stonefurnace.png"
COMBI.BuildSiteModel = "models/props/de_inferno/ClayOven.mdl"

GMS.RegisterCombi( COMBI, "Structures" )

/* Copper Furnace */
local COMBI = {}

COMBI.Name = "Copper Furnace"
COMBI.Description = "You can use the furnace to smelt resources into another, such as Iron Ore into Iron."

COMBI.Req = {}
COMBI.Req["Copper"] = 35

COMBI.Results = "gms_copperfurnace"
COMBI.Texture = "gms_icons/gms_copperfurnace.png"
COMBI.BuildSiteModel = "models/props/cs_militia/furnace01.mdl"

GMS.RegisterCombi( COMBI, "Structures" )

/* Iron Furnace */
local COMBI = {}

COMBI.Name = "Iron Furnace"
COMBI.Description = "You can use the furnace to smelt resources into another, such as Sand into Glass."

COMBI.Req = {}
COMBI.Req["Iron"] = 35

COMBI.Results = "gms_ironfurnace"
COMBI.Texture = "gms_icons/gms_ironfurnace.png"
COMBI.BuildSiteModel = "models/props_c17/furniturefireplace001a.mdl"

GMS.RegisterCombi( COMBI, "Structures" )

/* Grinding Stone */
local COMBI = {}

COMBI.Name = "Grinding Stone"
COMBI.Description = "You can use the grinding stone to smash resources into smaller things, such as stone into sand."

COMBI.Req = {}
COMBI.Req["Stone"] = 40

COMBI.Results = "gms_grindingstone"
COMBI.Texture = "gms_icons/gms_grindingstone.png"
COMBI.BuildSiteModel = "models/props_combine/combine_mine01.mdl"

GMS.RegisterCombi( COMBI, "Structures" )

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

GMS.RegisterCombi( COMBI, "Structures" )

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

GMS.RegisterCombi( COMBI, "Structures" )

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

GMS.RegisterCombi( COMBI, "Structures" )

/* ------------------------ Stone Furnace ------------------------*/

/* Copper Ore to Copper*/
local COMBI = {}

COMBI.Name = "Copper"
COMBI.Description = "Copper can be used to create more advanced buildings and tools."
COMBI.Entity = "gms_stonefurnace"

COMBI.Req = {}
COMBI.Req["Copper_Ore"] = 1

COMBI.Results = {}
COMBI.Results["Copper"] = 1

GMS.RegisterCombi( COMBI, "gms_stonefurnace" )

/* Copper Ore to Copper x5 */
local COMBI = {}

COMBI.Name = "Copper 5x"
COMBI.Description = "Copper can be used to create more advanced buildings and tools."
COMBI.Entity = "gms_stonefurnace"

COMBI.Req = {}
COMBI.Req["Copper_Ore"] = 5

COMBI.Results = {}
COMBI.Results["Copper"] = 5

GMS.RegisterCombi( COMBI, "gms_stonefurnace" )

/* Copper Ore to Copper x10 */
local COMBI = {}

COMBI.Name = "Copper 10x"
COMBI.Description = "Copper can be used to create more advanced buildings and tools."
COMBI.Entity = "gms_stonefurnace"

COMBI.Req = {}
COMBI.Req["Copper_Ore"] = 10

COMBI.Results = {}
COMBI.Results["Copper"] = 10

GMS.RegisterCombi( COMBI, "gms_stonefurnace" )

/* Copper Ore to Copper x25 */
local COMBI = {}

COMBI.Name = "Copper 25x"
COMBI.Description = "Copper can be used to create more advanced buildings and tools."
COMBI.Entity = "gms_stonefurnace"

COMBI.Req = {}
COMBI.Req["Copper_Ore"] = 25

COMBI.Results = {}
COMBI.Results["Copper"] = 25

GMS.RegisterCombi( COMBI, "gms_stonefurnace" )

/* Allsmelt Copper */
local COMBI = {}

COMBI.Name = "All Copper"
COMBI.Description = "Copper can be used to create more advanced buildings and tools."
COMBI.Entity = "gms_stonefurnace"

COMBI.Req = {}
COMBI.Req["Copper_Ore"] = 1

COMBI.Results = {}
COMBI.Results["Copper"] = 1

COMBI.AllSmelt = true
COMBI.Max = 35

GMS.RegisterCombi( COMBI, "gms_stonefurnace" )

/* ------------------------ Copper Furnace ------------------------*/

/* Iron Ore to Iron */
local COMBI = {}

COMBI.Name = "Iron"
COMBI.Description = "Iron can be used to create more advanced buildings and tools."
COMBI.Entity = "gms_copperfurnace"

COMBI.Req = {}
COMBI.Req["Iron_Ore"] = 1

COMBI.Results = {}
COMBI.Results["Iron"] = 1

GMS.RegisterCombi( COMBI, "gms_copperfurnace" )

/* Iron Ore to Iron x5 */
local COMBI = {}

COMBI.Name = "Iron 5x"
COMBI.Description = "Iron can be used to create more advanced buildings and tools."
COMBI.Entity = "gms_copperfurnace"

COMBI.Req = {}
COMBI.Req["Iron_Ore"] = 5

COMBI.Results = {}
COMBI.Results["Iron"] = 5

GMS.RegisterCombi( COMBI, "gms_copperfurnace" )

/* Iron Ore to Iron x10 */
local COMBI = {}

COMBI.Name = "Iron 10x"
COMBI.Description = "Iron can be used to create more advanced buildings and tools."
COMBI.Entity = "gms_copperfurnace"

COMBI.Req = {}
COMBI.Req["Iron_Ore"] = 10

COMBI.Results = {}
COMBI.Results["Iron"] = 10

GMS.RegisterCombi( COMBI, "gms_copperfurnace" )

/* Iron Ore to Iron x25 */
local COMBI = {}

COMBI.Name = "Iron 25x"
COMBI.Description = "Iron can be used to create more advanced buildings and tools."
COMBI.Entity = "gms_copperfurnace"

COMBI.Req = {}
COMBI.Req["Iron_Ore"] = 25

COMBI.Results = {}
COMBI.Results["Iron"] = 25

GMS.RegisterCombi( COMBI, "gms_copperfurnace" )

/* Allsmelt Iron  */
local COMBI = {}

COMBI.Name = "All Iron"
COMBI.Description = "Iron can be used to create more advanced buildings and tools."
COMBI.Entity = "gms_copperfurnace"

COMBI.Req = {}
COMBI.Req["Iron_Ore"] = 1

COMBI.Results = {}
COMBI.Results["Iron"] = 1

COMBI.AllSmelt = true
COMBI.Max = 50

GMS.RegisterCombi( COMBI, "gms_copperfurnace" )

/* Sulphur */
local COMBI = {}

COMBI.Name = "Sulphur 5x"
COMBI.Description = "Used in the production of gunpowder, refine from rocks."
COMBI.Entity = "gms_copperfurnace"

COMBI.Req = {}
COMBI.Req["Stone"] = 10

COMBI.Results = {}
COMBI.Results["Sulphur"] = 5

GMS.RegisterCombi( COMBI, "gms_copperfurnace" )

/* Sulphur 10 */
local COMBI = {}

COMBI.Name = "Sulphur 10x"
COMBI.Description = "Used in the production of gunpowder, refine from rocks."
COMBI.Entity = "gms_copperfurnace"

COMBI.Req = {}
COMBI.Req["Stone"] = 20

COMBI.Results = {}
COMBI.Results["Sulphur"] = 10

GMS.RegisterCombi( COMBI, "gms_copperfurnace" )

/* ------------------------ Iron Furnace ------------------------*/

/* Glass */
local COMBI = {}

COMBI.Name = "Glass"
COMBI.Description = "Glass can be used for making bottles and lighting."
COMBI.Entity = "gms_ironfurnace"

COMBI.Req = {}
COMBI.Req["Sand"] = 2

COMBI.Results = {}
COMBI.Results["Glass"] = 1

GMS.RegisterCombi( COMBI, "gms_ironfurnace" )

/* Charcoal */
local COMBI = {}

COMBI.Name = "Charcoal"
COMBI.Description = "Used in the production of gunpowder."
COMBI.Entity = "gms_ironfurnace"

COMBI.Req = {}
COMBI.Req["Wood"] = 5

COMBI.Results = {}
COMBI.Results["Charcoal"] = 1

GMS.RegisterCombi( COMBI, "gms_ironfurnace" )

/* Charcoal 10x */
local COMBI = {}

COMBI.Name = "Charcoal 10x"
COMBI.Description = "Used in the production of gunpowder."
COMBI.Entity = "gms_ironfurnace"

COMBI.Req = {}
COMBI.Req["Wood"] = 15

COMBI.Results = {}
COMBI.Results["Charcoal"] = 10

GMS.RegisterCombi( COMBI, "gms_ironfurnace" )

/*------------------------ Factory ------------------------*/

/* Glass ( 10 ) */
local COMBI = {}

COMBI.Name = "Glass 10x"
COMBI.Description = "Heats 25 sand together to form 10 glass."
COMBI.Entity = "gms_factory"

COMBI.Req = {}
COMBI.Req["Sand"] = 25

COMBI.Results = {}
COMBI.Results["Glass"] = 10

GMS.RegisterCombi( COMBI, "gms_factory" )

/* Glass ( 25 ) */
local COMBI = {}

COMBI.Name = "Glass 25x"
COMBI.Description = "Heats 50 sand together to form 25 glass."
COMBI.Entity = "gms_factory"

COMBI.Req = {}
COMBI.Req["Sand"] = 50

COMBI.Results = {}
COMBI.Results["Glass"] = 25

GMS.RegisterCombi( COMBI, "gms_factory" )

/* Glass ( 50 ) */
local COMBI = {}

COMBI.Name = "Glass 50x"
COMBI.Description = "Heats 75 sand together to form 50 glass."
COMBI.Entity = "gms_factory"

COMBI.Req = {}
COMBI.Req["Sand"] = 75

COMBI.Results = {}
COMBI.Results["Glass"] = 50

GMS.RegisterCombi( COMBI, "gms_factory" )

/* Iron from Stone ( 10 ) */
local COMBI = {}

COMBI.Name = "Iron 10x"
COMBI.Description = "Smelting together 25 stone forms 10 iron."
COMBI.Entity = "gms_factory"

COMBI.Req = {}
COMBI.Req["Stone"] = 25

COMBI.Results = {}
COMBI.Results["Iron"] = 10

GMS.RegisterCombi( COMBI, "gms_factory" )

/* Iron from Stone ( 25 ) */
local COMBI = {}

COMBI.Name = "Iron 25x"
COMBI.Description = "Smelting together 50 stone forms 25 iron."
COMBI.Entity = "gms_factory"

COMBI.Req = {}
COMBI.Req["Stone"] = 50

COMBI.Results = {}
COMBI.Results["Iron"] = 25

GMS.RegisterCombi( COMBI, "gms_factory" )

/* Iron from Stone ( 50 ) */
local COMBI = {}

COMBI.Name = "Iron 50x"
COMBI.Description = "Smelting together 75 stone forms 50 iron."
COMBI.Entity = "gms_factory"

COMBI.Req = {}
COMBI.Req["Stone"] = 75

COMBI.Results = {}
COMBI.Results["Iron"] = 50

GMS.RegisterCombi( COMBI, "gms_factory" )

/* Allsmelt Iron */
local COMBI = {}

COMBI.Name = "All Iron"
COMBI.Description = "Iron can be used to create more advanced buildings and tools."
COMBI.Entity = "gms_factory"

COMBI.Req = {}
COMBI.Req["Iron_Ore"] = 1

COMBI.Results = {}
COMBI.Results["Iron"] = 1

COMBI.AllSmelt = true
COMBI.Max = 200

GMS.RegisterCombi( COMBI, "gms_factory" )

/* Allsmelt Copper */
local COMBI = {}

COMBI.Name = "All Copper"
COMBI.Description = "Copper can be used to create more advanced buildings and tools."
COMBI.Entity = "gms_factory"

COMBI.Req = {}
COMBI.Req["Copper_Ore"] = 1

COMBI.Results = {}
COMBI.Results["Copper"] = 1

COMBI.AllSmelt = true
COMBI.Max = 200

GMS.RegisterCombi( COMBI, "gms_factory" )

/* Stone to Sand ( 10 ) */
local COMBI = {}

COMBI.Name = "Sand 10x"
COMBI.Description = "Crushes 10 stone to 10 sand."
COMBI.Entity = "gms_factory"

COMBI.Req = {}
COMBI.Req["Stone"] = 10

COMBI.Results = {}
COMBI.Results["Sand"] = 10

GMS.RegisterCombi( COMBI, "gms_factory" )

/* Stone to Sand ( 25 ) */
local COMBI = {}

COMBI.Name = "Sand 25x"
COMBI.Description = "Crushes 20 stone to 25 sand."
COMBI.Entity = "gms_factory"

COMBI.Req = {}
COMBI.Req["Stone"] = 20

COMBI.Results = {}
COMBI.Results["Sand"] = 25

GMS.RegisterCombi( COMBI, "gms_factory" )

/* Stone to Sand ( 50 ) */
local COMBI = {}

COMBI.Name = "Sand 50x"
COMBI.Description = "Crushes 30 stone to 50 sand."
COMBI.Entity = "gms_factory"

COMBI.Req = {}
COMBI.Req["Stone"] = 30

COMBI.Results = {}
COMBI.Results["Sand"] = 50

GMS.RegisterCombi( COMBI, "gms_factory" )

/* Resin ( 5 ) */
local COMBI = {}

COMBI.Name = "Resin 5x"
COMBI.Description = "Extracts the resin from the wood."
COMBI.Entity = "gms_factory"

COMBI.Req = {}
COMBI.Req["Wood"] = 15
COMBI.Req["Water_Bottles"] = 1

COMBI.Results = {}
COMBI.Results["Resin"] = 5

GMS.RegisterCombi( COMBI, "gms_factory" )

/* Resin ( 10 ) */
local COMBI = {}

COMBI.Name = "Resin 10x"
COMBI.Description = "Extracts the resin from the wood."
COMBI.Entity = "gms_factory"

COMBI.Req = {}
COMBI.Req["Wood"] = 25
COMBI.Req["Water_Bottles"] = 2

COMBI.Results = {}
COMBI.Results["Resin"] = 10

GMS.RegisterCombi( COMBI, "gms_factory" )

/* Resin ( 25 ) */
local COMBI = {}

COMBI.Name = "Resin 25x"
COMBI.Description = "Extracts the resin from the wood."
COMBI.Entity = "gms_factory"

COMBI.Req = {}
COMBI.Req["Wood"] = 50
COMBI.Req["Water_Bottles"] = 4

COMBI.Results = {}
COMBI.Results["Resin"] = 25

GMS.RegisterCombi( COMBI, "gms_factory" )

/* Plastic ( 10 ) */
local COMBI = {}

COMBI.Name = "Plastic 10x"
COMBI.Description = "Solidifies the Resin, creating a natural plastic."
COMBI.Entity = "gms_factory"

COMBI.Req = {}
COMBI.Req["Resin"] = 10

COMBI.Results = {}
COMBI.Results["Plastic"] = 10

GMS.RegisterCombi( COMBI, "gms_factory" )

/* Plastic ( 25 ) */
local COMBI = {}

COMBI.Name = "Plastic 25x"
COMBI.Description = "Solidifies the Resin, creating a natural plastic."
COMBI.Entity = "gms_factory"

COMBI.Req = {}
COMBI.Req["Resin"] = 20

COMBI.Results = {}
COMBI.Results["Plastic"] = 25

GMS.RegisterCombi( COMBI, "gms_factory" )

/* ------------------------ Grinding Stone ------------------------*/

/* Stone to Sand x1 */
local COMBI = {}

COMBI.Name = "Sand"
COMBI.Description = "Converts 1 stone to 1 sand."
COMBI.Entity = "gms_grindingstone"

COMBI.Req = {}
COMBI.Req["Stone"] = 1

COMBI.Results = {}
COMBI.Results["Sand"] = 1

GMS.RegisterCombi( COMBI, "gms_grindingstone" )

/* Stone to Sand x5 */
local COMBI = {}

COMBI.Name = "Sand 5x"
COMBI.Description = "Converts 5 stone to 5 sand."
COMBI.Entity = "gms_grindingstone"

COMBI.Req = {}
COMBI.Req["Stone"] = 5

COMBI.Results = {}
COMBI.Results["Sand"] = 5

GMS.RegisterCombi( COMBI, "gms_grindingstone" )

/* Stone to Sand x10 */
local COMBI = {}

COMBI.Name = "Sand10"
COMBI.Description = "Converts 10 stone to 10 sand."
COMBI.Entity = "gms_grindingstone"

COMBI.Req = {}
COMBI.Req["Stone"] = 10

COMBI.Results = {}
COMBI.Results["Sand"] = 10

GMS.RegisterCombi( COMBI, "gms_grindingstone" )

/* Grain to Flour x1 */
local COMBI = {}

COMBI.Name = "Flour"
COMBI.Description = "Converts 2 Grain Seeds to 1 Flour."
COMBI.Entity = "gms_grindingstone"

COMBI.Req = {}
COMBI.Req["Grain_Seeds"] = 2

COMBI.Results = {}
COMBI.Results["Flour"] = 1

GMS.RegisterCombi( COMBI, "gms_grindingstone" )

/* Grain to Flour x5 */
local COMBI = {}

COMBI.Name = "Flour 5x"
COMBI.Description = "Converts 5 Grain Seeds to 3 Flour."
COMBI.Entity = "gms_grindingstone"

COMBI.Req = {}
COMBI.Req["Grain_Seeds"] = 5

COMBI.Results = {}
COMBI.Results["Flour"] = 3

GMS.RegisterCombi( COMBI, "gms_grindingstone" )

/* Grain to Flour x10 */
local COMBI = {}

COMBI.Name = "Flour 10x"
COMBI.Description = "Converts 10 Grain Seeds to 7 Flour."
COMBI.Entity = "gms_grindingstone"

COMBI.Req = {}
COMBI.Req["Grain_Seeds"] = 10

COMBI.Results = {}
COMBI.Results["Flour"] = 7

GMS.RegisterCombi( COMBI, "gms_grindingstone" )

/* All Grain to Flour*/
local COMBI = {}

COMBI.Name = "All Flour"
COMBI.Description = "Converts Grain Seeds to Flour ( 10:6 )."
COMBI.Entity = "gms_grindingstone"

COMBI.Req = {}
COMBI.Req["Grain_Seeds"] = 1

COMBI.Results = {}
COMBI.Results["Flour"] = 1

COMBI.AllSmelt = true
COMBI.Max = 25

GMS.RegisterCombi( COMBI, "gms_grindingstone" )

/*------------------------ Cooking ------------------------*/

/* Casserole */
local COMBI = {}

COMBI.Name = "Casserole"
COMBI.Description = "Put a little spiced trout over the fire to make this delicious casserole."
COMBI.Entity = "gms_stove"

COMBI.Req = {}
COMBI.Req["Trout"] = 1
COMBI.Req["Herbs"] = 3
COMBI.FoodValue = 400

GMS.RegisterCombi( COMBI, "Cooking" )

/* Fried meat */
local COMBI = {}

COMBI.Name = "Fried Meat"
COMBI.Description = "Simple fried meat."
COMBI.Entity = "gms_stove"

COMBI.Req = {}
COMBI.Req["Meat"] = 1

COMBI.FoodValue = 250

GMS.RegisterCombi( COMBI, "Cooking" )

/* Sushi */
local COMBI = {}

COMBI.Name = "Sushi"
COMBI.Description = "For when you like your fish raw."
COMBI.Entity = "gms_stove"

COMBI.Req = {}
COMBI.Req["Bass"] = 2

COMBI.FoodValue = 300

GMS.RegisterCombi( COMBI, "Cooking" )

/* Fish soup */
local COMBI = {}

COMBI.Name = "Fish Soup"
COMBI.Description = "Fish soup, pretty good!"
COMBI.Entity = "gms_stove"

COMBI.Req = {}
COMBI.Req["Bass"] = 1
COMBI.Req["Trout"] = 1
COMBI.Req["Spices"] = 2
COMBI.Req["Water_Bottles"] = 2

COMBI.SkillReq = {}
COMBI.SkillReq["Cooking"] = 2

COMBI.FoodValue = 400

GMS.RegisterCombi( COMBI, "Cooking" )

/* Meatballs */
local COMBI = {}

COMBI.Name = "Meatballs"
COMBI.Description = "Processed meat."
COMBI.Entity = "gms_stove"

COMBI.Req = {}
COMBI.Req["Meat"] = 1
COMBI.Req["Spices"] = 1
COMBI.Req["Water_Bottles"] = 1

COMBI.SkillReq = {}
COMBI.SkillReq["Cooking"] = 2

COMBI.FoodValue = 400

GMS.RegisterCombi( COMBI, "Cooking" )

/* Fried fish */
local COMBI = {}

COMBI.Name = "Fried Fish"
COMBI.Description = "Simple fried fish."
COMBI.Entity = "gms_stove"

COMBI.Req = {}
COMBI.Req["Bass"] = 1
COMBI.FoodValue = 200

GMS.RegisterCombi( COMBI, "Cooking" )

/* Berry Pie */
local COMBI = {}

COMBI.Name = "Berry Pie"
COMBI.Description = "Yummy, berry pie reminds me of home!"
COMBI.Entity = "gms_stove"

COMBI.Req = {}
COMBI.Req["Dough"] = 2
COMBI.Req["Water_Bottles"] = 2
COMBI.Req["Berries"] = 5

COMBI.SkillReq = {}
COMBI.SkillReq["Cooking"] = 5

COMBI.FoodValue = 700

GMS.RegisterCombi( COMBI, "Cooking" )

/* Rock cake */
local COMBI = {}
 
COMBI.Name = "Rock Cake"
COMBI.Description = "Crunchy!"
COMBI.Entity = "gms_stove"
 
COMBI.Req = {}
COMBI.Req["Iron"] = 2
COMBI.Req["Herbs"] = 1
COMBI.FoodValue = 50
 
GMS.RegisterCombi( COMBI, "Cooking" )

/* Salad */
local COMBI = {}
 
COMBI.Name = "Salad"
COMBI.Description = "Everything for survival, I guess."
COMBI.Entity = "gms_stove"
 
COMBI.Req = {}
COMBI.Req["Herbs"] = 2
COMBI.FoodValue = 100
 
GMS.RegisterCombi( COMBI, "Cooking" )

/* Meal */
local COMBI = {}
 
COMBI.Name = "Meal"
COMBI.Description = "The ultimate meal. Delicious!"
COMBI.Entity = "gms_stove"
 
COMBI.Req = {}
COMBI.Req["Herbs"] = 5
COMBI.Req["Salmon"] = 1
COMBI.Req["Meat"] = 2
COMBI.Req["Spices"] = 3

COMBI.SkillReq = {}
COMBI.SkillReq["Cooking"] = 20

COMBI.FoodValue = 1000
 
GMS.RegisterCombi( COMBI, "Cooking" )

/* Shark soup */
local COMBI = {}

COMBI.Name = "Shark Soup"
COMBI.Description = "Man this is good."
COMBI.Entity = "gms_stove"

COMBI.Req = {}
COMBI.Req["Shark"] = 2
COMBI.Req["Herbs"] = 3
COMBI.Req["Spices"] = 2

COMBI.SkillReq = {}
COMBI.SkillReq["Cooking"] = 15

COMBI.FoodValue = 850

GMS.RegisterCombi( COMBI, "Cooking" )

/* Bread */
local COMBI = {}
 
COMBI.Name = "Bread"
COMBI.Description = "Good old bread."
COMBI.Entity = "gms_stove"
 
COMBI.Req = {}
COMBI.Req["Dough"] = 2
COMBI.Req["Water_Bottles"] = 1

COMBI.SkillReq = {}
COMBI.SkillReq["Cooking"] = 5

COMBI.FoodValue = 800

GMS.RegisterCombi( COMBI, "Cooking" )

/* Hamburger */
local COMBI = {}
 
COMBI.Name = "Hamburger"
COMBI.Description = "A hamburger! Yummy!"
COMBI.Entity = "gms_stove"
 
COMBI.Req = {}
COMBI.Req["Dough"] = 2
COMBI.Req["Water_Bottles"] = 1
COMBI.Req["Meat"] = 2

COMBI.SkillReq = {}
COMBI.SkillReq["Cooking"] = 3

COMBI.FoodValue = 850
 
GMS.RegisterCombi( COMBI, "Cooking" )

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

GMS.RegisterCombi( COMBI, "gms_stoneworkbench" )

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

GMS.RegisterCombi( COMBI, "gms_stoneworkbench" )

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

GMS.RegisterCombi( COMBI, "gms_stoneworkbench" )

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

GMS.RegisterCombi( COMBI, "gms_stoneworkbench" )

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

GMS.RegisterCombi( COMBI, "gms_copperworkbench" )

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

GMS.RegisterCombi( COMBI, "gms_copperworkbench" )

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

GMS.RegisterCombi( COMBI, "gms_copperworkbench" )

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

GMS.RegisterCombi( COMBI, "gms_copperworkbench" )

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

GMS.RegisterCombi( COMBI, "gms_copperworkbench" )

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

GMS.RegisterCombi( COMBI, "gms_copperworkbench" )

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

GMS.RegisterCombi( COMBI, "gms_ironworkbench" )

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

GMS.RegisterCombi( COMBI, "gms_ironworkbench" )

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

GMS.RegisterCombi( COMBI, "gms_ironworkbench" )

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

GMS.RegisterCombi( COMBI, "gms_ironworkbench" )

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

GMS.RegisterCombi( COMBI, "gms_ironworkbench" )


/*------------------------ Gun Lab ------------------------*/

/* Smg */
local COMBI = {}

COMBI.Name = "Sub Machine Gun"
COMBI.Description = "Will blow the head off the target"
COMBI.Entity = "gms_gunlab"

COMBI.Req = {}
COMBI.Req["Gunslide"] = 3
COMBI.Req["Gungrip"] = 2
COMBI.Req["Gunbarrel"] = 3
COMBI.Req["Gunmagazine"] = 3

COMBI.SkillReq = {}
COMBI.SkillReq["Weapon_Crafting"] = 20
COMBI.SkillReq["Hunting"] = 20

COMBI.Texture = "gms_icons/weapon_smg1.png"
COMBI.SwepClass = "weapon_smg1"

GMS.RegisterCombi( COMBI, "gms_gunlab" )

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
COMBI.SkillReq["Weapon_Crafting"] = 13
COMBI.SkillReq["Hunting"] = 10

COMBI.Texture = "gms_icons/weapon_pistol.png"
COMBI.SwepClass = "weapon_pistol"

GMS.RegisterCombi( COMBI, "gms_gunlab" )

/* Pistol ammo */
local COMBI = {}

COMBI.Name = "Pistol ammo"
COMBI.Description = "If you wanna keep using the pistol, you'll need this"
COMBI.Entity = "gms_gunlab"

COMBI.Req = {}
COMBI.Req["Iron"] = 5
COMBI.Req["Gunpowder"] = 5

COMBI.SkillReq = {}
COMBI.SkillReq["Weapon_Crafting"] = 13

COMBI.Texture = "gms_icons/item_ammo_pistol.png"
COMBI.SwepClass = "item_ammo_pistol"

GMS.RegisterCombi( COMBI, "gms_gunlab" )

/* Smg ammo */
local COMBI = {}

COMBI.Name = "SMG Ammo"
COMBI.Description = "If you wanna keep using the smg, you'll need this"
COMBI.Entity = "gms_gunlab"

COMBI.Req = {}
COMBI.Req["Iron"] = 10
COMBI.Req["Gunpowder"] = 10

COMBI.SkillReq = {}
COMBI.SkillReq["Weapon_Crafting"] = 20

COMBI.Texture = "gms_icons/item_ammo_smg1.png"
COMBI.SwepClass = "item_ammo_smg1"

GMS.RegisterCombi( COMBI, "gms_gunlab" )

/*------------------------ Gun Chunks ------------------------*/

/* Gunslide */
local COMBI = {}

COMBI.Name = "Gunslide"
COMBI.Description = "A piece of a gun"
COMBI.Entity = "gms_gunchunks"

COMBI.Req = {}
COMBI.Req["Wood"] = 25

COMBI.SkillReq = {}
COMBI.SkillReq["Weapon_Crafting"] = 9

COMBI.Results = {}
COMBI.Results["Gunslide"] = 1

GMS.RegisterCombi( COMBI, "gms_gunchunks" )

/* Gunbarrel */
local COMBI = {}

COMBI.Name = "Gunbarrel"
COMBI.Description = "A piece of a gun"
COMBI.Entity = "gms_gunchunks"

COMBI.Req = {}
COMBI.Req["Iron"] = 30

COMBI.SkillReq = {}
COMBI.SkillReq["Weapon_Crafting"] = 11

COMBI.Results = {}
COMBI.Results["Gunbarrel"] = 1

GMS.RegisterCombi( COMBI, "gms_gunchunks" )

/* Gungrip */
local COMBI = {}

COMBI.Name = "Gungrip"
COMBI.Description = "A piece of a gun"
COMBI.Entity = "gms_gunchunks"

COMBI.Req = {}
COMBI.Req["Iron"] = 30

COMBI.SkillReq = {}
COMBI.SkillReq["Weapon_Crafting"] = 7

COMBI.Results = {}
COMBI.Results["Gungrip"] = 1

GMS.RegisterCombi( COMBI, "gms_gunchunks" )

/* Gunmagazine */
local COMBI = {}

COMBI.Name = "Gunmagazine"
COMBI.Description = "A piece of a gun"
COMBI.Entity = "gms_gunchunks"

COMBI.Req = {}
COMBI.Req["Iron"] = 15
COMBI.Req["Gunpowder"] = 5

COMBI.SkillReq = {}
COMBI.SkillReq["Weapon_Crafting"] = 13

COMBI.Results = {}
COMBI.Results["Gunmagazine"] = 1

GMS.RegisterCombi( COMBI, "gms_gunchunks" )

/* Saltpetre */
local COMBI = {}

COMBI.Name = "Saltpetre"
COMBI.Description = "Used in making gunpowder"
COMBI.Entity = "gms_gunchunks"

COMBI.Req = {}
COMBI.Req["Urine_Bottles"] = 1

COMBI.Results = {}
COMBI.Results["Saltpetre"] = 1

GMS.RegisterCombi( COMBI, "gms_gunchunks" )

/* Saltpetre x10 */
local COMBI = {}

COMBI.Name = "Saltpetre 10x"
COMBI.Description = "Used in making gunpowder"
COMBI.Entity = "gms_gunchunks"

COMBI.Req = {}
COMBI.Req["Urine_Bottles"] = 10

COMBI.Results = {}
COMBI.Results["Saltpetre"] = 10

GMS.RegisterCombi( COMBI, "gms_gunchunks" )

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

GMS.RegisterCombi( COMBI, "gms_gunchunks" )

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

GMS.RegisterCombi( COMBI, "gms_techworkbench" )

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

GMS.RegisterCombi( COMBI, "gms_techworkbench" )

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

GMS.RegisterCombi( COMBI, "gms_techworkbench" )

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

GMS.RegisterCombi( COMBI, "gms_techworkbench" )

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

GMS.RegisterCombi( COMBI, "gms_techworkbench" )
