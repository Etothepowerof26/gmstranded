GMS.Combinations = {}
function GMS.RegisterCombi(tbl, group)
	if (!GMS.Combinations[group]) then GMS.Combinations[group] = {} end
	
	-- print("[stranded] Registerring combination", tbl.Name or "wat", "in group", group)
	GMS.Combinations[group][string.Replace(tbl.Name, " ", "_")] = tbl
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

GMS.RegisterCombi(COMBI, "Combinations")

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

GMS.RegisterCombi(COMBI, "Combinations")

/* Dough */
local COMBI = {}

COMBI.Name = "Dough"
COMBI.Description = "Dough is used for baking."

COMBI.Req = {}
COMBI.Req["Water_Bottles"] = 1
COMBI.Req["Flour"] = 2

COMBI.Results = {}
COMBI.Results["Dough"] = 1

GMS.RegisterCombi(COMBI, "Combinations")

/* Dough x10 */
local COMBI = {}

COMBI.Name = "Dough 10x"
COMBI.Description = "Dough is used for baking."

COMBI.Req = {}
COMBI.Req["Water_Bottles"] = 7
COMBI.Req["Flour"] = 15

COMBI.Results = {}
COMBI.Results["Dough"] = 10

GMS.RegisterCombi(COMBI, "Combinations")

/* Rope */
local COMBI = {}

COMBI.Name = "Rope"
COMBI.Description = "Allows you to use Rope tool (Using Rope Tool will consume the Rope) and used in fishing rod crafting."

COMBI.Req = {}
COMBI.Req["Herbs"] = 5
COMBI.Req["Wood"] = 2
COMBI.Req["Water_Bottles"] = 1

COMBI.Results = {}
COMBI.Results["Rope"] = 1

GMS.RegisterCombi(COMBI, "Combinations")

/* Welder */
local COMBI = {}

COMBI.Name = "Welder"
COMBI.Description = "Allows you to use Weld Tool. You still need the Tool Gun though."

COMBI.Req = {}
COMBI.Req["Wood"] = 10
COMBI.Req["Stone"] = 10
COMBI.Req["Water_Bottles"] = 1

COMBI.Results = {}
COMBI.Results["Welder"] = 1

GMS.RegisterCombi(COMBI, "Combinations")

/* Concrete */
local COMBI = {}

COMBI.Name = "Concrete"
COMBI.Description = "Concrete can be used for spawning concrete props."

COMBI.Req = {}
COMBI.Req["Sand"] = 5
COMBI.Req["Water_Bottles"] = 2

COMBI.Results = {}
COMBI.Results["Concrete"] = 1

GMS.RegisterCombi(COMBI, "Combinations")

/* Urine */
local COMBI = {}

COMBI.Name = "Urine"
COMBI.Description = "Drink some water and wait, used in gunpowder production."

COMBI.Req = {}
COMBI.Req["Water_Bottles"] = 2

COMBI.Results = {}
COMBI.Results["Urine_Bottles"] = 1

GMS.RegisterCombi(COMBI, "Combinations")

/* Urine 10x */
local COMBI = {}

COMBI.Name = "Urine 10x"
COMBI.Description = "Drink loads of water and wait, messy, but used in gunpowder production."

COMBI.Req = {}
COMBI.Req["Water_Bottles"] = 20

COMBI.Results = {}
COMBI.Results["Urine_Bottles"] = 10

GMS.RegisterCombi(COMBI, "Combinations")

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

GMS.RegisterCombi(COMBI, "Combinations")

local files, dirs = file.Find("gmstranded/gamemode/combinations/*.lua", "LUA")
for k,v in pairs(files) do
	if SERVER then
		AddCSLuaFile("gmstranded/gamemode/combinations/" .. v)
	end
	
	include("gmstranded/gamemode/combinations/" .. v)
end