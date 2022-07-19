local fieldtools = {}
fieldtools.fids = {}

for i,v in pairs(game:GetService("ReplicatedStorage").SmallFieldIcons:GetChildren()) do
	if v.Name ~= "Ant Field" then
		fieldtools.fids[v.Name] = v.Texture
	end
end

local points = {
    ["dandmaxX"] = 38.5,
    ["dandmaxZ"] = 255,
    ["dandminX"] = -102,
    ["dandminZ"] = 185.5,

    ["rosemaxX"] = -270,
    ["rosemaxZ"] = 166.5,
    ["roseminX"] = -390,
    ["roseminZ"] = 90,

    ["pinetreemaxX"] = -285.5,
    ["pinetreemaxZ"] = -129,
    ["pinetreeminX"] = -375,
    ["pinetreeminZ"] = -250,

    ["sunmaxX"] = -175,
    ["sunmaxZ"] = 240,
    ["sunminX"] = -250,
    ["sunminZ"] = 110,

    ["mushmaxX"] = -30,
    ["mushmaxZ"] = 155,
    ["mushminX"] = -155,
    ["mushminZ"] = 65,

    ["clovermaxX"] = 205,
    ["clovermaxZ"] = 250,
    ["cloverminX"] = 105,
    ["cloverminZ"] = 140,

    ["blufmaxX"] = 230,
    ["blufmaxZ"] = 130,
    ["blufminX"] = 60,
    ["blufminZ"] = 65,

    ["bambmaxX"] = 205,
    ["bambmaxZ"] = 5,
    ["bambminX"] = 50,
    ["bambminZ"] = -65,

    ["spidermaxX"] = 10,
    ["spidermaxZ"] = 35,
    ["spiderminX"] = -100,
    ["spiderminZ"] = -60,

    ["strawmaxX"] = -135,
    ["strawmaxZ"] = 40,
    ["strawminX"] = -225,
    ["strawminZ"] = -60,

    ["pumpmaxX"] = -125,
    ["pumpmaxZ"] = -150,
    ["pumpminX"] = -255,
    ["pumpminZ"] = -220,

    ["cactmaxX"] = -125,
    ["cactmaxZ"] = -70,
    ["cactminX"] = -255,
    ["cactminZ"] = -140,

    ["pineapmaxX"] = 320,
    ["pineapmaxZ"] = -165,
    ["pineapminX"] = 190,
    ["pineapminZ"] = -255,

    ["stumpmaxX"] = 470,
    ["stumpmaxZ"] = -120,
    ["stumpminX"] = 370,
    ["stumpminZ"] = -230,

    ["mountmaxX"] = 125,
    ["mountmaxZ"] = -110,
    ["mountminX"] = 30,
    ["mountminZ"] = -225,

    ["cocomaxX"] = -200,
    ["cocomaxZ"] = 505,
    ["cocominX"] = -315,
    ["cocominZ"] = 425,

    ["pepmaxX"] = -450,
    ["pepmaxZ"] = 585,
    ["pepminX"] = -530,
    ["pepminZ"] = 480,
}

function inBetween(min,max,given)
    if given < max and given > min then
        return true
    else
        return false
    end
end

function fieldtools.isin(v)
	if inBetween(points["dandminX"], points["dandmaxX"], v.Position["X"]) and inBetween(points["dandminZ"], points["dandmaxZ"], v.Position["Z"]) then
        return "Dandelion Field"
    else if inBetween(points["roseminX"], points["rosemaxX"], v.Position["X"]) and inBetween(points["roseminZ"], points["rosemaxZ"], v.Position["Z"]) then
        return "Rose Field"
    else if inBetween(points["pinetreeminX"], points["pinetreemaxX"], v.Position["X"]) and inBetween(points["pinetreeminZ"], points["pinetreemaxZ"], v.Position["Z"]) then
        return "Pine Tree Forest"
    else if inBetween(points["sunminX"], points["sunmaxX"], v.Position["X"]) and inBetween(points["sunminZ"], points["sunmaxZ"], v.Position["Z"]) then
        return "Sunflower Field"
    else if inBetween(points["mushminX"], points["mushmaxX"], v.Position["X"]) and inBetween(points["mushminZ"], points["mushmaxZ"], v.Position["Z"]) then
        return "Mushroom Field"
    else if inBetween(points["cloverminX"], points["clovermaxX"], v.Position["X"]) and inBetween(points["cloverminZ"], points["clovermaxZ"], v.Position["Z"]) then
        return "Clover Field"
    else if inBetween(points["blufminX"], points["blufmaxX"], v.Position["X"]) and inBetween(points["blufminZ"], points["blufmaxZ"], v.Position["Z"]) then
        return "Blue Flower Field"
    else if inBetween(points["bambminX"], points["bambmaxX"], v.Position["X"]) and inBetween(points["bambminZ"], points["bambmaxZ"], v.Position["Z"]) then
        return "Bamboo Field"
    else if inBetween(points["spiderminX"], points["spidermaxX"], v.Position["X"]) and inBetween(points["spiderminZ"], points["spidermaxZ"], v.Position["Z"]) then
        return "Spider Field"
    else if inBetween(points["strawminX"], points["strawmaxX"], v.Position["X"]) and inBetween(points["strawminZ"], points["strawmaxZ"], v.Position["Z"]) then
        return "Strawberry Field"
    else if inBetween(points["pumpminX"], points["pumpmaxX"], v.Position["X"]) and inBetween(points["pumpminZ"], points["pumpmaxZ"], v.Position["Z"]) then
        return "Pumpkin Patch"
    else if inBetween(points["cactminX"], points["cactmaxX"], v.Position["X"]) and inBetween(points["cactminZ"], points["cactmaxZ"], v.Position["Z"]) then
        return "Cactus Field"
    else if inBetween(points["pineapminX"], points["pineapmaxX"], v.Position["X"]) and inBetween(points["pineapminZ"], points["pineapmaxZ"], v.Position["Z"]) then
        return "Pineapple Patch"
    else if inBetween(points["stumpminX"], points["stumpmaxX"], v.Position["X"]) and inBetween(points["stumpminZ"], points["stumpmaxZ"], v.Position["Z"]) then
		return "Stump Field"
    else if inBetween(points["mountminX"], points["mountmaxX"], v.Position["X"]) and inBetween(points["mountminZ"], points["mountmaxZ"], v.Position["Z"]) then
		return "Mountain Top Field"
    else if inBetween(points["cocominX"], points["cocomaxX"], v.Position["X"]) and inBetween(points["cocominZ"], points["cocomaxZ"], v.Position["Z"]) then
		return "Coconut Field"
    else if inBetween(points["pepminX"], points["pepmaxX"], v.Position["X"]) and inBetween(points["pepminZ"], points["pepmaxZ"], v.Position["Z"]) then
		return "Pepper Patch"
    else do
    	return false
    end end end end end end end end end end end end end end end end end end
end

function fieldtools.geticon(field)
	if not field then return false end
	if fieldtools.fids[field] then return fieldtools.fids[field], field end
end

return fieldtools
