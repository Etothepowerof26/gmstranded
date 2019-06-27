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

GMS.RegisterCombi(COMBI, "gms_grindingstone")

/* Stone to Sand x5 */
local COMBI = {}

COMBI.Name = "Sand 5x"
COMBI.Description = "Converts 5 stone to 5 sand."
COMBI.Entity = "gms_grindingstone"

COMBI.Req = {}
COMBI.Req["Stone"] = 5

COMBI.Results = {}
COMBI.Results["Sand"] = 5

GMS.RegisterCombi(COMBI, "gms_grindingstone")

/* Stone to Sand x10 */
local COMBI = {}

COMBI.Name = "Sand10"
COMBI.Description = "Converts 10 stone to 10 sand."
COMBI.Entity = "gms_grindingstone"

COMBI.Req = {}
COMBI.Req["Stone"] = 10

COMBI.Results = {}
COMBI.Results["Sand"] = 10

GMS.RegisterCombi(COMBI, "gms_grindingstone")

/* Grain to Flour x1 */
local COMBI = {}

COMBI.Name = "Flour"
COMBI.Description = "Converts 2 Grain Seeds to 1 Flour."
COMBI.Entity = "gms_grindingstone"

COMBI.Req = {}
COMBI.Req["Grain_Seeds"] = 2

COMBI.Results = {}
COMBI.Results["Flour"] = 1

GMS.RegisterCombi(COMBI, "gms_grindingstone")

/* Grain to Flour x5 */
local COMBI = {}

COMBI.Name = "Flour 5x"
COMBI.Description = "Converts 5 Grain Seeds to 3 Flour."
COMBI.Entity = "gms_grindingstone"

COMBI.Req = {}
COMBI.Req["Grain_Seeds"] = 5

COMBI.Results = {}
COMBI.Results["Flour"] = 3

GMS.RegisterCombi(COMBI, "gms_grindingstone")

/* Grain to Flour x10 */
local COMBI = {}

COMBI.Name = "Flour 10x"
COMBI.Description = "Converts 10 Grain Seeds to 7 Flour."
COMBI.Entity = "gms_grindingstone"

COMBI.Req = {}
COMBI.Req["Grain_Seeds"] = 10

COMBI.Results = {}
COMBI.Results["Flour"] = 7

GMS.RegisterCombi(COMBI, "gms_grindingstone")

/* All Grain to Flour*/
local COMBI = {}

COMBI.Name = "All Flour"
COMBI.Description = "Converts Grain Seeds to Flour (10:6)."
COMBI.Entity = "gms_grindingstone"

COMBI.Req = {}
COMBI.Req["Grain_Seeds"] = 1

COMBI.Results = {}
COMBI.Results["Flour"] = 1

COMBI.AllSmelt = true
COMBI.Max = 25

GMS.RegisterCombi(COMBI, "gms_grindingstone")