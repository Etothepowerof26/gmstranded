/*------------------------ Factory ------------------------*/

/* Glass (10) */
local COMBI = {}

COMBI.Name = "Glass 10x"
COMBI.Description = "Heats 25 sand together to form 10 glass."
COMBI.Entity = "gms_factory"

COMBI.Req = {}
COMBI.Req["Sand"] = 25

COMBI.Results = {}
COMBI.Results["Glass"] = 10

GMS.RegisterCombi(COMBI, "gms_factory")

/* Glass (25) */
local COMBI = {}

COMBI.Name = "Glass 25x"
COMBI.Description = "Heats 50 sand together to form 25 glass."
COMBI.Entity = "gms_factory"

COMBI.Req = {}
COMBI.Req["Sand"] = 50

COMBI.Results = {}
COMBI.Results["Glass"] = 25

GMS.RegisterCombi(COMBI, "gms_factory")

/* Glass (50) */
local COMBI = {}

COMBI.Name = "Glass 50x"
COMBI.Description = "Heats 75 sand together to form 50 glass."
COMBI.Entity = "gms_factory"

COMBI.Req = {}
COMBI.Req["Sand"] = 75

COMBI.Results = {}
COMBI.Results["Glass"] = 50

GMS.RegisterCombi(COMBI, "gms_factory")

/* Iron from Stone (10) */
local COMBI = {}

COMBI.Name = "Iron 10x"
COMBI.Description = "Smelting together 25 stone forms 10 iron."
COMBI.Entity = "gms_factory"

COMBI.Req = {}
COMBI.Req["Stone"] = 25

COMBI.Results = {}
COMBI.Results["Iron"] = 10

GMS.RegisterCombi(COMBI, "gms_factory")

/* Iron from Stone (25) */
local COMBI = {}

COMBI.Name = "Iron 25x"
COMBI.Description = "Smelting together 50 stone forms 25 iron."
COMBI.Entity = "gms_factory"

COMBI.Req = {}
COMBI.Req["Stone"] = 50

COMBI.Results = {}
COMBI.Results["Iron"] = 25

GMS.RegisterCombi(COMBI, "gms_factory")

/* Iron from Stone (50) */
local COMBI = {}

COMBI.Name = "Iron 50x"
COMBI.Description = "Smelting together 75 stone forms 50 iron."
COMBI.Entity = "gms_factory"

COMBI.Req = {}
COMBI.Req["Stone"] = 75

COMBI.Results = {}
COMBI.Results["Iron"] = 50

GMS.RegisterCombi(COMBI, "gms_factory")

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

GMS.RegisterCombi(COMBI, "gms_factory")

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

GMS.RegisterCombi(COMBI, "gms_factory")

/* Stone to Sand (10) */
local COMBI = {}

COMBI.Name = "Sand 10x"
COMBI.Description = "Crushes 10 stone to 10 sand."
COMBI.Entity = "gms_factory"

COMBI.Req = {}
COMBI.Req["Stone"] = 10

COMBI.Results = {}
COMBI.Results["Sand"] = 10

GMS.RegisterCombi(COMBI, "gms_factory")

/* Stone to Sand (25) */
local COMBI = {}

COMBI.Name = "Sand 25x"
COMBI.Description = "Crushes 20 stone to 25 sand."
COMBI.Entity = "gms_factory"

COMBI.Req = {}
COMBI.Req["Stone"] = 20

COMBI.Results = {}
COMBI.Results["Sand"] = 25

GMS.RegisterCombi(COMBI, "gms_factory")

/* Stone to Sand (50) */
local COMBI = {}

COMBI.Name = "Sand 50x"
COMBI.Description = "Crushes 30 stone to 50 sand."
COMBI.Entity = "gms_factory"

COMBI.Req = {}
COMBI.Req["Stone"] = 30

COMBI.Results = {}
COMBI.Results["Sand"] = 50

GMS.RegisterCombi(COMBI, "gms_factory")

/* Resin (5) */
local COMBI = {}

COMBI.Name = "Resin 5x"
COMBI.Description = "Extracts the resin from the wood."
COMBI.Entity = "gms_factory"

COMBI.Req = {}
COMBI.Req["Wood"] = 15
COMBI.Req["Water_Bottles"] = 1

COMBI.Results = {}
COMBI.Results["Resin"] = 5

GMS.RegisterCombi(COMBI, "gms_factory")

/* Resin (10) */
local COMBI = {}

COMBI.Name = "Resin 10x"
COMBI.Description = "Extracts the resin from the wood."
COMBI.Entity = "gms_factory"

COMBI.Req = {}
COMBI.Req["Wood"] = 25
COMBI.Req["Water_Bottles"] = 2

COMBI.Results = {}
COMBI.Results["Resin"] = 10

GMS.RegisterCombi(COMBI, "gms_factory")

/* Resin (25) */
local COMBI = {}

COMBI.Name = "Resin 25x"
COMBI.Description = "Extracts the resin from the wood."
COMBI.Entity = "gms_factory"

COMBI.Req = {}
COMBI.Req["Wood"] = 50
COMBI.Req["Water_Bottles"] = 4

COMBI.Results = {}
COMBI.Results["Resin"] = 25

GMS.RegisterCombi(COMBI, "gms_factory")

/* Plastic (10) */
local COMBI = {}

COMBI.Name = "Plastic 10x"
COMBI.Description = "Solidifies the Resin, creating a natural plastic."
COMBI.Entity = "gms_factory"

COMBI.Req = {}
COMBI.Req["Resin"] = 10

COMBI.Results = {}
COMBI.Results["Plastic"] = 10

GMS.RegisterCombi(COMBI, "gms_factory")

/* Plastic (25) */
local COMBI = {}

COMBI.Name = "Plastic 25x"
COMBI.Description = "Solidifies the Resin, creating a natural plastic."
COMBI.Entity = "gms_factory"

COMBI.Req = {}
COMBI.Req["Resin"] = 20

COMBI.Results = {}
COMBI.Results["Plastic"] = 25

GMS.RegisterCombi(COMBI, "gms_factory")