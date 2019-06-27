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

GMS.RegisterCombi(COMBI, "gms_stonefurnace")

/* Copper Ore to Copper x5 */
local COMBI = {}

COMBI.Name = "Copper 5x"
COMBI.Description = "Copper can be used to create more advanced buildings and tools."
COMBI.Entity = "gms_stonefurnace"

COMBI.Req = {}
COMBI.Req["Copper_Ore"] = 5

COMBI.Results = {}
COMBI.Results["Copper"] = 5

GMS.RegisterCombi(COMBI, "gms_stonefurnace")

/* Copper Ore to Copper x10 */
local COMBI = {}

COMBI.Name = "Copper 10x"
COMBI.Description = "Copper can be used to create more advanced buildings and tools."
COMBI.Entity = "gms_stonefurnace"

COMBI.Req = {}
COMBI.Req["Copper_Ore"] = 10

COMBI.Results = {}
COMBI.Results["Copper"] = 10

GMS.RegisterCombi(COMBI, "gms_stonefurnace")

/* Copper Ore to Copper x25 */
local COMBI = {}

COMBI.Name = "Copper 25x"
COMBI.Description = "Copper can be used to create more advanced buildings and tools."
COMBI.Entity = "gms_stonefurnace"

COMBI.Req = {}
COMBI.Req["Copper_Ore"] = 25

COMBI.Results = {}
COMBI.Results["Copper"] = 25

GMS.RegisterCombi(COMBI, "gms_stonefurnace")

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

GMS.RegisterCombi(COMBI, "gms_stonefurnace")