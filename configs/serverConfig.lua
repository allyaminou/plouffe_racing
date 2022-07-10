Races = {}

Races.Zones = {
	vehicle_scratch_1 = {
		name = 'vehicle_scratch_1',
		coords = {
			vector3(-348.99716186523, -138.70626831055, 39.009616851807),
			vector3(-344.40472412109, -121.8943939209, 39.034160614014),
			vector3(-319.39401245117, -130.97459411621, 38.991317749023),
			vector3(-324.78295898438, -147.92260742188, 39.55082321167)
		}
	},

	vehicle_scratch_2 = {
		name = 'vehicle_scratch_2',
		coords = {
			vector3(738.52972412109, -1094.8333740234, 22.169044494629),
			vector3(724.35986328125, -1092.1561279297, 22.16944694519),
			vector3(724.88446044922, -1064.1010742188, 22.168918609619),
			vector3(738.52856445313, -1063.6656494141, 22.037792205811)
		}
	},

	vehicle_scratch_3 = {
		name = 'vehicle_scratch_3',
		coords = {
			vector3(-1157.4705810547, -2026.3215332031, 13.173720359802),
			vector3(-1171.0513916016, -2013.9453125, 13.682103157043),
			vector3(-1151.7176513672, -1994.8616943359, 13.180263519287),
			vector3(-1139.1729736328, -2007.1804199219, 13.205163002014)
		}
	},

	bring_back_wanted = {
		name = "bring_back_wanted",
		coords = {
			vector3(-427.49188232422, -1676.8974609375, 19.029090881348),
			vector3(-417.01452636719, -1680.9716796875, 19.029088973999),
			vector3(-423.89193725586, -1698.8552246094, 19.097520828247),
			vector3(-433.8639831543, -1696.9600830078, 18.97710609436)
		},
		isZone = true,
		vehicle = true,
		label = "Retourner un véhicule rechercher",
		keyMap = {
			key = "E",
			event = "plouffe_racing:bringback_wanted"
		}
	},

	onHackingTool = {
		name = "onHackingTool",
		coords = vector3(471.03662109375, -1307.7209472656, 32.94730758667),
		distance = 2.0,
		isZone = true,
		label = "Acheter un outil de hacking",
		keyMap = {
			key = "E",
			event = "plouffe_racing:onTool"
		},
		ped = {
			coords = vector3(471.12524414063, -1307.6293945313, 32.94730758667),
			heading = 27.365640640259,
			model = 'JokerThug1',
		}
	}
}

Boosts = {}
Boosts.boostIntervall = 1000 * 60 * 60 * 1
Boosts.activeBoosts = nil
Boosts.avaibleBoosts = {}
Boosts.deliverys = {}

Boosts.Hacks = {
	["S+"] = 25,
	["S"] = 25,
	["A"] = 20,
	["B"] = 20,
	["C"] = 15
}

Boosts.BoostsVehicle = {
	["S+"] = {
		{
			model = "gst512",
			label = "Ferrari 512 Lw",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
        {
			model = "euros2",
			label = "300 ZX",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "rmod240sx",
			label = "240 Sx",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "488lb",
			label = "Ferrari 488 Lb",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "a80",
			label = "Supra Mk4",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "rmodatlantic",
			label = "Buggati Atlantic",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "bt62r",
			label = "Brabham 62 R",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "ferrari812super",
			label = "Ferrari 812 Super",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "C7",
			label = "Corvette C7",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "c8daytona",
			label = "Corvette C8 Daytona",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "ccx",
			label = "Koenigsegg CCX",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "chevelless",
			label = "Chevelle SS",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "cp9a",
			label = "Evo IX (Rhd)",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "DEMON",
			label = "Dodge Demon",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "evo9",
			label = "Evo IX",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "exigev6",
			label = "Lotus Exige",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "rmodgtr50",
			label = "Nissan Gtr-50",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "GTRC",
			label = "Mercedes Gtr-C",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "610lb",
			label = "Huracan Lb",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "ie",
			label = "Appollo IE",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "ie",
			label = "Appollo IE",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "IMOLA",
			label = "Pagani Imola",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "IMOLA",
			label = "Pagani Imola",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "jesko",
			label = "Koenigsegg Jesko",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "JESTGPR",
			label = "Jester GPR",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "lexlfa10",
			label = "Lexus LFA",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "lp770",
			label = "Lamborghini Centenario 770",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "lpi8004",
			label = "Lamborghini Countach",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "mansm8",
			label = "Bmw M8 Mans",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "MH8GCP",
			label = "Bmw M8 Manhart",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "mansrs6",
			label = "Bmw Rs6-r Mans",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "manssrt",
			label = "Charger Srt Mans",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "manssupersnake",
			label = "Mustang SuperSnake Mans",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "monza",
			label = "Ferrari Monza",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "NA1",
			label = "Honda Nsx 1993",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "NC1",
			label = "Honda Nsx 2020",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "rmodsuprapandem",
			label = "Supra Pandem",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "PD458WB",
			label = "Ferrari 458 Prior",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "r8hycade",
			label = "Audi R8 Hycade",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "R32",
			label = "Skyline R32",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "r35",
			label = "Skyline R35 (Rhd)",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "LWGTR",
			label = "Nissan R35 Lw",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "rmodsuprapandem",
			label = "Supra Pandem",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "REAGPR",
			label = "Reaper GPR",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "rmodsianr",
			label = "Lamborghini Sian FKP 37",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "rs6abtp",
			label = "Rs6 ABT",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "RS7R",
			label = "Audi Rs7-R",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "fd",
			label = "Rx7 (Rhd)",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "gxs15",
			label = "S15",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "SUNRISE1",
			label = "Sunrise",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "wyccvt",
			label = "Austin Martin Victor",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "zagatosb",
			label = "Aston Martin Zagato",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},
		{
			model = "ZRGPR",
			label = "Zr-GPR",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		}
    },

    ["S"] = {
		{
			model = "4444",
			label = "G-Wagon",
			boostPrice = {min = 350, max = 400},
			scratchPrice = {min = 600, max = 800},
			value = {min = 200, max = 250}
		},

		{
			model = "wildtrak",
			label = "Ford Bronco",
			boostPrice = {min = 350, max = 400},
			scratchPrice = {min = 600, max = 800},
			value = {min = 200, max = 250}
		},

		{
			model = "chevelless",
			label = "Chevelle SS",
			boostPrice = {min = 350, max = 400},
			scratchPrice = {min = 600, max = 800},
			value = {min = 200, max = 250}
		},

		{
			model = "gt86",
			label = "Toyota Gt86",
			boostPrice = {min = 350, max = 400},
			scratchPrice = {min = 600, max = 800},
			value = {min = 200, max = 250}
		},

		{
			model = "bchighcountry",
			label = "Silverado High Country",
			boostPrice = {min = 350, max = 400},
			scratchPrice = {min = 600, max = 800},
			value = {min = 200, max = 250}
		},

		{
			model = "na6",
			label = "Mazda Miata",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},

		{
			model = "raid",
			label = "Challenger RAID",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},

		{
			model = "rmodrover",
			label = "Range Rover Mansory",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		},

		{
			model = "RCF",
			label = "Lexus RCF",
			boostPrice = {min = 400, max = 450},
			scratchPrice = {min = 700, max = 900},
			value = {min = 250, max = 300}
		}
    },

	["A"] = {
		{
			model = "adder",
			label = "Adder",
			boostPrice = {min = 250, max = 300},
			scratchPrice = {min = 350, max = 400},
			value = {min = 150, max = 175}
		},
		{
			model = "autarch",
			label = "Autarch",
			boostPrice = {min = 250, max = 300},
			scratchPrice = {min = 350, max = 400},
			value = {min = 150, max = 175}
		},
		{
			model = "bullet",
			label = "Bullet",
			boostPrice = {min = 250, max = 300},
			scratchPrice = {min = 350, max = 400},
			value = {min = 150, max = 175}
		},
		{
			model = "cheetah",
			label = "Cheetah",
			boostPrice = {min = 250, max = 300},
			scratchPrice = {min = 350, max = 400},
			value = {min = 150, max = 175}
		},
		{
			model = "entity2",
			label = "Entity",
			boostPrice = {min = 250, max = 300},
			scratchPrice = {min = 350, max = 400},
			value = {min = 150, max = 175}
		},
		{
			model = "entityxf",
			label = "Entity XF",
			boostPrice = {min = 250, max = 300},
			scratchPrice = {min = 350, max = 400},
			value = {min = 150, max = 175}
		},
		{
			model = "fmj",
			label = "Fmj",
			boostPrice = {min = 250, max = 300},
			scratchPrice = {min = 350, max = 400},
			value = {min = 150, max = 175}
		},
		{
			model = "gp1",
			label = "Gp1",
			boostPrice = {min = 250, max = 300},
			scratchPrice = {min = 350, max = 400},
			value = {min = 150, max = 175}
		},
		{
			model = "italigtb",
			label = "Itali Gtb",
			boostPrice = {min = 250, max = 300},
			scratchPrice = {min = 350, max = 400},
			value = {min = 150, max = 175}
		},
		{
			model = "italigtb2",
			label = "Itali Gtb R",
			boostPrice = {min = 250, max = 300},
			scratchPrice = {min = 350, max = 400},
			value = {min = 150, max = 175}
		},
		{
			model = "le7b",
			label = "Le 7B",
			boostPrice = {min = 250, max = 300},
			scratchPrice = {min = 350, max = 400},
			value = {min = 150, max = 175}
		},
		{
			model = "nero",
			label = "Nero",
			boostPrice = {min = 250, max = 300},
			scratchPrice = {min = 350, max = 400},
			value = {min = 150, max = 175}
		},
		{
			model = "nero2",
			label = "Nero S",
			boostPrice = {min = 250, max = 300},
			scratchPrice = {min = 350, max = 400},
			value = {min = 150, max = 175}
		},
		{
			model = "osiris",
			label = "Osiris",
			boostPrice = {min = 250, max = 300},
			scratchPrice = {min = 350, max = 400},
			value = {min = 150, max = 175}
		},
		{
			model = "penetrator",
			label = "Penetrator",
			boostPrice = {min = 250, max = 300},
			scratchPrice = {min = 350, max = 400},
			value = {min = 150, max = 175}
		},
		{
			model = "pfister811",
			label = "Pfister 811",
			boostPrice = {min = 250, max = 300},
			scratchPrice = {min = 350, max = 400},
			value = {min = 150, max = 175}
		},
		{
			model = "prototipo",
			label = "Prototipo",
			boostPrice = {min = 250, max = 300},
			scratchPrice = {min = 350, max = 400},
			value = {min = 150, max = 175}
		},
		{
			model = "reaper",
			label = "Reaper",
			boostPrice = {min = 250, max = 300},
			scratchPrice = {min = 350, max = 400},
			value = {min = 150, max = 175}
		},
		{
			model = "sc1",
			label = "Sc1",
			boostPrice = {min = 250, max = 300},
			scratchPrice = {min = 350, max = 400},
			value = {min = 150, max = 175}
		},
		{
			model = "t20",
			label = "T20",
			boostPrice = {min = 250, max = 300},
			scratchPrice = {min = 350, max = 400},
			value = {min = 150, max = 175}
		},
		{
			model = "taipan",
			label = "Taipan",
			boostPrice = {min = 250, max = 300},
			scratchPrice = {min = 350, max = 400},
			value = {min = 150, max = 175}
		},
		{
			model = "tempesta",
			label = "Tempesta",
			boostPrice = {min = 250, max = 300},
			scratchPrice = {min = 350, max = 400},
			value = {min = 150, max = 175}
		},
		{
			model = "turismor",
			label = "Turismo R",
			boostPrice = {min = 250, max = 300},
			scratchPrice = {min = 350, max = 400},
			value = {min = 150, max = 175}
		},
		{
			model = "tyrant",
			label = "Tyrant",
			boostPrice = {min = 250, max = 300},
			scratchPrice = {min = 350, max = 400},
			value = {min = 150, max = 175}
		},
		{
			model = "tyrus",
			label = "Tyrus",
			boostPrice = {min = 250, max = 300},
			scratchPrice = {min = 350, max = 400},
			value = {min = 150, max = 175}
		},
		{
			model = "vacca",
			label = "Vacca",
			boostPrice = {min = 250, max = 300},
			scratchPrice = {min = 350, max = 400},
			value = {min = 150, max = 175}
		},
		{
			model = "vagner",
			label = "Vagner",
			boostPrice = {min = 250, max = 300},
			scratchPrice = {min = 350, max = 400},
			value = {min = 150, max = 175}
		},
		{
			model = "visione",
			label = "Visione",
			boostPrice = {min = 250, max = 300},
			scratchPrice = {min = 350, max = 400},
			value = {min = 150, max = 175}
		},
		{
			model = "xa21",
			label = "Xa21",
			boostPrice = {min = 250, max = 300},
			scratchPrice = {min = 350, max = 400},
			value = {min = 150, max = 175}
		},
		{
			model = "zentorno",
			label = "Zentorno",
			boostPrice = {min = 250, max = 300},
			scratchPrice = {min = 350, max = 400},
			value = {min = 150, max = 175}
		},
		-- Not Super but still high tier
		{
			model = "cheetah2",
			label = "Cheetah classic",
			boostPrice = {min = 200, max = 250},
			scratchPrice = {min = 250, max = 300},
			value = {min = 100, max = 125}
		},
		{
			model = "infernus2",
			label = "Infernus classic",
			boostPrice = {min = 200, max = 250},
			scratchPrice = {min = 250, max = 300},
			value = {min = 100, max = 125}
		},
		{
			model = "swinger",
			label = "Swinger",
			boostPrice = {min = 200, max = 250},
			scratchPrice = {min = 250, max = 300},
			value = {min = 100, max = 125}
		},
		{
			model = "torero",
			label = "Torero",
			boostPrice = {min = 200, max = 250},
			scratchPrice = {min = 250, max = 300},
			value = {min = 100, max = 125}
		},
		{
			model = "turismo2",
			label = "Turismo classic",
			boostPrice = {min = 200, max = 250},
			scratchPrice = {min = 250, max = 300},
			value = {min = 100, max = 125}
		},
		{
			model = "viseris",
			label = "Viseris",
			boostPrice = {min = 200, max = 250},
			scratchPrice = {min = 250, max = 300},
			value = {min = 100, max = 125}
		},
		{
			model = "ztype",
			label = "Z Type",
			boostPrice = {min = 200, max = 250},
			scratchPrice = {min = 250, max = 300},
			value = {min = 100, max = 125}
		},
		{
			model = "deveste",
			label = "Deveste",
			boostPrice = {min = 200, max = 250},
			scratchPrice = {min = 250, max = 300},
			value = {min = 100, max = 125}
		},
		{
			model = "emerus",
			label = "Emerus",
			boostPrice = {min = 200, max = 250},
			scratchPrice = {min = 250, max = 300},
			value = {min = 100, max = 125}
		},
		{
			model = "furia",
			label = "Furia",
			boostPrice = {min = 200, max = 250},
			scratchPrice = {min = 250, max = 300},
			value = {min = 100, max = 125}
		},
		{
			model = "krieger",
			label = "Krieger",
			boostPrice = {min = 200, max = 250},
			scratchPrice = {min = 250, max = 300},
			value = {min = 100, max = 125}
		},
		{
			model = "thrax",
			label = "Thrax",
			boostPrice = {min = 200, max = 250},
			scratchPrice = {min = 250, max = 300},
			value = {min = 100, max = 125}
		},
		{
			model = "tigon",
			label = "Tigon",
			boostPrice = {min = 200, max = 250},
			scratchPrice = {min = 250, max = 300},
			value = {min = 100, max = 125}
		},
		{
			model = "zorrusso",
			label = "Zorrusso",
			boostPrice = {min = 200, max = 250},
			scratchPrice = {min = 250, max = 300},
			value = {min = 100, max = 125}
		},
		{
			model = "italirsx",
			label = "Itali Rsx",
			boostPrice = {min = 200, max = 250},
			scratchPrice = {min = 250, max = 300},
			value = {min = 100, max = 125}
		}
	},

	["B"] = {
		{
			model = "cogcabrio",
			label = "Cognoscenti cabrio",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "f620",
			label = "F620",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "sentinel",
			label = "Sentinel",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "zion",
			label = "Zion",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "buccaneer",
			label = "Buccaneer",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "coquette3",
			label = "Coquette classic",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "deviant",
			label = "Deviant",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "dominator",
			label = "Dominator",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "ellie",
			label = "Ellie",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "hermes",
			label = "Hermes",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "hotknife",
			label = "Hotknife",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "hustler",
			label = "Hustler",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "nightshade",
			label = "Nightshade",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "phoenix",
			label = "Phoenix",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "sabregt",
			label = "Sabre Gt",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "vamos",
			label = "Vamos",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "toros",
			label = "Toros",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "alpha",
			label = "Alpha",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "banshee",
			label = "Banshee",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "bestiagts",
			label = "Bestiagts",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "coquette",
			label = "Coquette",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "comet2",
			label = "Comet",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "comet3",
			label = "Comet classic",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "comet5",
			label = "Comet SR",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "coquette",
			label = "Coquette",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "elegy2",
			label = "Elegy",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "feltzer2",
			label = "Feltzer",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "furoregt",
			label = "Furore Gt",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "italigto",
			label = "Itali Gto",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "jester",
			label = "Jester",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "kuruma",
			label = "Kuruma",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "lynx",
			label = "Lynx",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "massacro",
			label = "Massacro",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "neon",
			label = "Neon",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "ninef",
			label = "Ninef",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "pariah",
			label = "Pariah",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "ruston",
			label = "Ruston",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "schafter4",
			label = "Schafter V12",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "schlagen",
			label = "Schlagen",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "seven70",
			label = "Seven 70",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "specter2",
			label = "Specter course",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "verlierer2",
			label = "Verlierer",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "gt500",
			label = "Gt 500",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "mamba",
			label = "Mamba",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "rapidgt3",
			label = "Rapid Gt classic",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "stingergt",
			label = "Stinger Gt",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "z190",
			label = "190z",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "banshee2",
			label = "Banshee 900R",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "voltic",
			label = "Voltic",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "sultanrs",
			label = "Sultan Rs",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "locust",
			label = "Locust",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "neo",
			label = "Neo",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		},
		{
			model = "drafter",
			label = "Drafter",
			boostPrice = {min = 100, max = 150},
			scratchPrice = {min = 150, max = 200},
			value = {min = 50, max = 75}
		}
	},

	["C"] = {
		{
			model = "brioso",
			label = "Brioso",
			boostPrice = {min = 50, max = 75},
			scratchPrice = {min = 75, max = 100},
			value = {min = 25, max = 50}
		},
		{
			model = "rhapsody",
			label = "Rhapsody",
			boostPrice = {min = 50, max = 75},
			scratchPrice = {min = 75, max = 100},
			value = {min = 25, max = 50}
		},
		{
			model = "moonbeam",
			label = "Moonbeam",
			boostPrice = {min = 50, max = 75},
			scratchPrice = {min = 75, max = 100},
			value = {min = 25, max = 50}
		},
		{
			model = "ruiner",
			label = "Ruiner",
			boostPrice = {min = 50, max = 75},
			scratchPrice = {min = 75, max = 100},
			value = {min = 25, max = 50}
		},
		{
			model = "stalion",
			label = "Stalion",
			boostPrice = {min = 50, max = 75},
			scratchPrice = {min = 75, max = 100},
			value = {min = 25, max = 50}
		},
		{
			model = "vigero",
			label = "Vigero",
			boostPrice = {min = 50, max = 75},
			scratchPrice = {min = 75, max = 100},
			value = {min = 25, max = 50}
		},
		{
			model = "virgo3",
			label = "Virgo3",
			boostPrice = {min = 50, max = 75},
			scratchPrice = {min = 75, max = 100},
			value = {min = 25, max = 50}
		},
		{
			model = "voodoo",
			label = "Voodoo",
			boostPrice = {min = 50, max = 75},
			scratchPrice = {min = 75, max = 100},
			value = {min = 25, max = 50}
		},
		{
			model = "bfinjection",
			label = "BF Injection",
			boostPrice = {min = 50, max = 75},
			scratchPrice = {min = 75, max = 100},
			value = {min = 25, max = 50}
		},
		{
			model = "freecrawler",
			label = "Freecrawler",
			boostPrice = {min = 50, max = 75},
			scratchPrice = {min = 75, max = 100},
			value = {min = 25, max = 50}
		},
		{
			model = "rebel2",
			label = "Rebel",
			boostPrice = {min = 50, max = 75},
			scratchPrice = {min = 75, max = 100},
			value = {min = 25, max = 50}
		},
		{
			model = "trophytruck",
			label = "Trophy Truck",
			boostPrice = {min = 50, max = 75},
			scratchPrice = {min = 75, max = 100},
			value = {min = 25, max = 50}
		},
		{
			model = "riata",
			label = "Riata",
			boostPrice = {min = 50, max = 75},
			scratchPrice = {min = 75, max = 100},
			value = {min = 25, max = 50}
		},
		{
			model = "contender",
			label = "Contender",
			boostPrice = {min = 50, max = 75},
			scratchPrice = {min = 75, max = 100},
			value = {min = 25, max = 50}
		},
		{
			model = "fq2",
			label = "Fq2",
			boostPrice = {min = 50, max = 75},
			scratchPrice = {min = 75, max = 100},
			value = {min = 25, max = 50}
		},
		{
			model = "granger",
			label = "Granger",
			boostPrice = {min = 50, max = 75},
			scratchPrice = {min = 75, max = 100},
			value = {min = 25, max = 50}
		},
		{
			model = "primo2",
			label = "Primo custom",
			boostPrice = {min = 50, max = 75},
			scratchPrice = {min = 75, max = 100},
			value = {min = 25, max = 50}
		},
		{
			model = "warrener",
			label = "Warrener",
			boostPrice = {min = 50, max = 75},
			scratchPrice = {min = 75, max = 100},
			value = {min = 25, max = 50}
		},
		{
			model = "tailgater",
			label = "Tailgater",
			boostPrice = {min = 50, max = 75},
			scratchPrice = {min = 75, max = 100},
			value = {min = 25, max = 50}
		},
		{
			model = "superd",
			label = "Super diamond",
			boostPrice = {min = 50, max = 75},
			scratchPrice = {min = 75, max = 100},
			value = {min = 25, max = 50}
		},
		{
			model = "fusilade",
			label = "Fusilade",
			boostPrice = {min = 50, max = 75},
			scratchPrice = {min = 75, max = 100},
			value = {min = 25, max = 50}
		},
		{
			model = "sentinel3",
			label = "Sentinel classic",
			boostPrice = {min = 50, max = 75},
			scratchPrice = {min = 75, max = 100},
			value = {min = 25, max = 50}
		},
		{
			model = "manana",
			label = "Manana",
			boostPrice = {min = 50, max = 75},
			scratchPrice = {min = 75, max = 100},
			value = {min = 25, max = 50}
		},
		{
			model = "michelli",
			label = "Michelli",
			boostPrice = {min = 50, max = 75},
			scratchPrice = {min = 75, max = 100},
			value = {min = 25, max = 50}
		},
		{
			model = "tornado5",
			label = "Tornado",
			boostPrice = {min = 50, max = 75},
			scratchPrice = {min = 75, max = 100},
			value = {min = 25, max = 50}
		},
		{
			model = "superd",
			label = "Super diamond",
			boostPrice = {min = 50, max = 75},
			scratchPrice = {min = 75, max = 100},
			value = {min = 25, max = 50}
		}
	}
}

Boosts.VehicleColours = {
	{id = 0, label = "Metallic Black"},
	{id = 1, label = "Metallic Graphite Black"},
	{id = 2, label = "Metallic Black Steal"},
	{id = 3, label = "Metallic Dark Silver"},
	{id = 4, label = "Metallic Silver"},
	{id = 5, label = "Metallic Blue Silver"},
	{id = 6, label = "Metallic Steel Gray"},
	{id = 7, label = "Metallic Shadow Silver"},
	{id = 8, label = "Metallic Stone Silver"},
	{id = 9, label = "Metallic Midnight Silver"},
	{id = 10, label = "Metallic Gun Metal"},
	{id = 11, label = "Metallic Anthracite Grey"},
	{id = 12, label = "Matte Black"},
	{id = 13, label = "Matte Gray"},
	{id = 14, label = "Matte Light Grey"},
	{id = 15, label = "Util Black"},
	{id = 16, label = "Util Black Poly"},
	{id = 17, label = "Util Dark silver"},
	{id = 18, label = "Util Silver"},
	{id = 19, label = "Util Gun Metal"},
	{id = 20, label = "Util Shadow Silver"},
	{id = 21, label = "Worn Black"},
	{id = 22, label = "Worn Graphite"},
	{id = 23, label = "Worn Silver Grey"},
	{id = 24, label = "Worn Silver"},
	{id = 25, label = "Worn Blue Silver"},
	{id = 26, label = "Worn Shadow Silver"},
	{id = 27, label = "Metallic Red"},
	{id = 28, label = "Metallic Torino Red"},
	{id = 29, label = "Metallic Formula Red"},
	{id = 30, label = "Metallic Blaze Red"},
	{id = 31, label = "Metallic Graceful Red"},
	{id = 32, label = "Metallic Garnet Red"},
	{id = 33, label = "Metallic Desert Red"},
	{id = 34, label = "Metallic Cabernet Red"},
	{id = 35, label = "Metallic Candy Red"},
	{id = 36, label = "Metallic Sunrise Orange"},
	{id = 37, label = "Metallic Classic Gold"},
	{id = 38, label = "Metallic Orange"},
	{id = 39, label = "Matte Red"},
	{id = 40, label = "Matte Dark Red"},
	{id = 41, label = "Matte Orange"},
	{id = 42, label = "Matte Yellow"},
	{id = 43, label = "Util Red"},
	{id = 44, label = "Util Bright Red"},
	{id = 45, label = "Util Garnet Red"},
	{id = 46, label = "Worn Red"},
	{id = 47, label = "Worn Golden Red"},
	{id = 48, label = "Worn Dark Red"},
	{id = 49, label = "Metallic Dark Green"},
	{id = 50, label = "Metallic Racing Green"},
	{id = 51, label = "Metallic Sea Green"},
	{id = 52, label = "Metallic Olive Green"},
	{id = 53, label = "Metallic Green"},
	{id = 54, label = "Metallic Gasoline Blue Green"},
	{id = 55, label = "Matte Lime Green"},
	{id = 56, label = "Util Dark Green"},
	{id = 57, label = "Util Green"},
	{id = 58, label = "Worn Dark Green"},
	{id = 59, label = "Worn Green"},
	{id = 60, label = "Worn Sea Wash"},
	{id = 61, label = "Metallic Midnight Blue"},
	{id = 62, label = "Metallic Dark Blue"},
	{id = 63, label = "Metallic Saxony Blue"},
	{id = 64, label = "Metallic Blue"},
	{id = 65, label = "Metallic Mariner Blue"},
	{id = 66, label = "Metallic Harbor Blue"},
	{id = 67, label = "Metallic Diamond Blue"},
	{id = 68, label = "Metallic Surf Blue"},
	{id = 69, label = "Metallic Nautical Blue"},
	{id = 70, label = "Metallic Bright Blue"},
	{id = 71, label = "Metallic Purple Blue"},
	{id = 72, label = "Metallic Spinnaker Blue"},
	{id = 73, label = "Metallic Ultra Blue"},
	{id = 74, label = "Metallic Bright Blue"},
	{id = 75, label = "Util Dark Blue"},
	{id = 76, label = "Util Midnight Blue"},
	{id = 77, label = "Util Blue"},
	{id = 78, label = "Util Sea Foam Blue"},
	{id = 79, label = "Util Lightning blue"},
	{id = 80, label = "Util Maui Blue Poly"},
	{id = 81, label = "Util Bright Blue"},
	{id = 82, label = "Matte Dark Blue"},
	{id = 83, label = "Matte Blue"},
	{id = 84, label = "Matte Midnight Blue"},
	{id = 85, label = "Worn Dark blue"},
	{id = 86, label = "Worn Blue"},
	{id = 87, label = "Worn Light blue"},
	{id = 88, label = "Metallic Taxi Yellow"},
	{id = 89, label = "Metallic Race Yellow"},
	{id = 90, label = "Metallic Bronze"},
	{id = 91, label = "Metallic Yellow Bird"},
	{id = 92, label = "Metallic Lime"},
	{id = 93, label = "Metallic Champagne"},
	{id = 94, label = "Metallic Pueblo Beige"},
	{id = 95, label = "Metallic Dark Ivory"},
	{id = 96, label = "Metallic Choco Brown"},
	{id = 97, label = "Metallic Golden Brown"},
	{id = 98, label = "Metallic Light Brown"},
	{id = 99, label = "Metallic Straw Beige"},
	{id = 100, label = "Metallic Moss Brown"},
	{id = 101, label = "Metallic Biston Brown"},
	{id = 102, label = "Metallic Beechwood"},
	{id = 103, label = "Metallic Dark Beechwood"},
	{id = 104, label = "Metallic Choco Orange"},
	{id = 105, label = "Metallic Beach Sand"},
	{id = 106, label = "Metallic Sun Bleeched Sand"},
	{id = 107, label = "Metallic Cream"},
	{id = 108, label = "Util Brown"},
	{id = 109, label = "Util Medium Brown"},
	{id = 110, label = "Util Light Brown"},
	{id = 111, label = "Metallic White"},
	{id = 112, label = "Metallic Frost White"},
	{id = 113, label = "Worn Honey Beige"},
	{id = 114, label = "Worn Brown"},
	{id = 115, label = "Worn Dark Brown"},
	{id = 116, label = "Worn straw beige"},
	{id = 117, label = "Brushed Steel"},
	{id = 118, label = "Brushed Black steel"},
	{id = 119, label = "Brushed Aluminium"},
	{id = 120, label = "Chrome"},
	{id = 121, label = "Worn Off White"},
	{id = 122, label = "Util Off White"},
	{id = 123, label = "Worn Orange"},
	{id = 124, label = "Worn Light Orange"},
	{id = 125, label = "Metallic Securicor Green"},
	{id = 126, label = "Worn Taxi Yellow"},
	{id = 127, label = "police car blue"},
	{id = 128, label = "Matte Green"},
	{id = 129, label = "Matte Brown"},
	{id = 130, label = "Worn Orange"},
	{id = 131, label = "Matte White"},
	{id = 132, label = "Worn White"},
	{id = 133, label = "Worn Olive Army Green"},
	{id = 134, label = "Pure White"},
	{id = 135, label = "Hot Pink"},
	{id = 136, label = "Salmon pink"},
	{id = 137, label = "Metallic Vermillion Pink"},
	{id = 138, label = "Orange"},
	{id = 139, label = "Green"},
	{id = 140, label = "Blue"},
	{id = 141, label = "Mettalic Black Blue"},
	{id = 142, label = "Metallic Black Purple"},
	{id = 143, label = "Metallic Black Red"},
	{id = 144, label = "hunter green"},
	{id = 145, label = "Metallic Purple"},
	{id = 146, label = "Metaillic V Dark Blue"},
	{id = 148, label = "Matte Purple"},
	{id = 149, label = "Matte Dark Purple"},
	{id = 150, label = "Metallic Lava Red"},
	{id = 151, label = "Matte Forest Green"},
	{id = 152, label = "Matte Olive Drab"},
	{id = 153, label = "Matte Desert Brown"},
	{id = 154, label = "Matte Desert Tan"},
	{id = 155, label = "Matte Foilage Green"},
	{id = 157, label = "Epsilon Blue"},
	{id = 158, label = "Pure Gold"},
	{id = 159, label = "Brushed Gold"}
}

Boosts.Wanted = {}