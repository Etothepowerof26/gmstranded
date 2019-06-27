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

GMS.RegisterCombi(COMBI, "gms_ironfurnace")

/* Charcoal */
local COMBI = {}

COMBI.Name = "Charcoal"
COMBI.Description = "Used in the production of gunpowder."
COMBI.Entity = "gms_ironfurnace"

COMBI.Req = {}
COMBI.Req["Wood"] = 5

COMBI.Results = {}
COMBI.Results["Charcoal"] = 1

GMS.RegisterCombi(COMBI, "gms_ironfurnace")

/* Charcoal 10x */
local COMBI = {}

COMBI.Name = "Charcoal 10x"
COMBI.Description = "Used in the production of gunpowder."
COMBI.Entity = "gms_ironfurnace"

COMBI.Req = {}
COMBI.Req["Wood"] = 15

COMBI.Results = {}
COMBI.Results["Charcoal"] = 10

GMS.RegisterCombi(COMBI, "gms_ironfurnace")