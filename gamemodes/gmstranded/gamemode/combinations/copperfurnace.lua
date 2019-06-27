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

GMS.RegisterCombi(COMBI, "gms_copperfurnace")

/* Iron Ore to Iron x5 */
local COMBI = {}

COMBI.Name = "Iron 5x"
COMBI.Description = "Iron can be used to create more advanced buildings and tools."
COMBI.Entity = "gms_copperfurnace"

COMBI.Req = {}
COMBI.Req["Iron_Ore"] = 5

COMBI.Results = {}
COMBI.Results["Iron"] = 5

GMS.RegisterCombi(COMBI, "gms_copperfurnace")

/* Iron Ore to Iron x10 */
local COMBI = {}

COMBI.Name = "Iron 10x"
COMBI.Description = "Iron can be used to create more advanced buildings and tools."
COMBI.Entity = "gms_copperfurnace"

COMBI.Req = {}
COMBI.Req["Iron_Ore"] = 10

COMBI.Results = {}
COMBI.Results["Iron"] = 10

GMS.RegisterCombi(COMBI, "gms_copperfurnace")

/* Iron Ore to Iron x25 */
local COMBI = {}

COMBI.Name = "Iron 25x"
COMBI.Description = "Iron can be used to create more advanced buildings and tools."
COMBI.Entity = "gms_copperfurnace"

COMBI.Req = {}
COMBI.Req["Iron_Ore"] = 25

COMBI.Results = {}
COMBI.Results["Iron"] = 25

GMS.RegisterCombi(COMBI, "gms_copperfurnace")

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

GMS.RegisterCombi(COMBI, "gms_copperfurnace")

/* Sulphur */
local COMBI = {}

COMBI.Name = "Sulphur 5x"
COMBI.Description = "Used in the production of gunpowder, refine from rocks."
COMBI.Entity = "gms_copperfurnace"

COMBI.Req = {}
COMBI.Req["Stone"] = 10

COMBI.Results = {}
COMBI.Results["Sulphur"] = 5

GMS.RegisterCombi(COMBI, "gms_copperfurnace")

/* Sulphur 10 */
local COMBI = {}

COMBI.Name = "Sulphur 10x"
COMBI.Description = "Used in the production of gunpowder, refine from rocks."
COMBI.Entity = "gms_copperfurnace"

COMBI.Req = {}
COMBI.Req["Stone"] = 20

COMBI.Results = {}
COMBI.Results["Sulphur"] = 10

GMS.RegisterCombi(COMBI, "gms_copperfurnace")