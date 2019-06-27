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

GMS.RegisterCombi(COMBI, "Cooking")

/* Fried meat */
local COMBI = {}

COMBI.Name = "Fried Meat"
COMBI.Description = "Simple fried meat."
COMBI.Entity = "gms_stove"

COMBI.Req = {}
COMBI.Req["Meat"] = 1

COMBI.FoodValue = 250

GMS.RegisterCombi(COMBI, "Cooking")

/* Sushi */
local COMBI = {}

COMBI.Name = "Sushi"
COMBI.Description = "For when you like your fish raw."
COMBI.Entity = "gms_stove"

COMBI.Req = {}
COMBI.Req["Bass"] = 2

COMBI.FoodValue = 300

GMS.RegisterCombi(COMBI, "Cooking")

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

GMS.RegisterCombi(COMBI, "Cooking")

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

GMS.RegisterCombi(COMBI, "Cooking")

/* Fried fish */
local COMBI = {}

COMBI.Name = "Fried Fish"
COMBI.Description = "Simple fried fish."
COMBI.Entity = "gms_stove"

COMBI.Req = {}
COMBI.Req["Bass"] = 1
COMBI.FoodValue = 200

GMS.RegisterCombi(COMBI, "Cooking")

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

GMS.RegisterCombi(COMBI, "Cooking")

/* Rock cake */
local COMBI = {}
 
COMBI.Name = "Rock Cake"
COMBI.Description = "Crunchy!"
COMBI.Entity = "gms_stove"
 
COMBI.Req = {}
COMBI.Req["Iron"] = 2
COMBI.Req["Herbs"] = 1
COMBI.FoodValue = 50
 
GMS.RegisterCombi(COMBI, "Cooking")

/* Salad */
local COMBI = {}
 
COMBI.Name = "Salad"
COMBI.Description = "Everything for survival, I guess."
COMBI.Entity = "gms_stove"
 
COMBI.Req = {}
COMBI.Req["Herbs"] = 2
COMBI.FoodValue = 100
 
GMS.RegisterCombi(COMBI, "Cooking")

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
 
GMS.RegisterCombi(COMBI, "Cooking")

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

GMS.RegisterCombi(COMBI, "Cooking")

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

GMS.RegisterCombi(COMBI, "Cooking")

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
 
GMS.RegisterCombi(COMBI, "Cooking")