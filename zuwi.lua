script_name('zuwi')
script_authors('PanSeek')
version_script = '1.4'
script_properties('work-in-pause')
require 'lib.moonloader'
local result, fa = pcall(require, 'fAwesome5') if not result then error('Lib "fAwesome5" not found') end
local result, imgui = pcall(require, 'mimgui') if not result then error('Lib "mimgui" not found') end
local result, key = pcall(require, 'vkeys') if not result then error('Lib "vkeys" not found') end
local result, sampev = pcall(require, 'lib.samp.events') if not result then error('Lib "SAMP Events" not found') end
local result, inicfg = pcall(require, 'inicfg') if not result then error('Lib "inicfg" not found') end
local ffi = require "ffi"
local dlstatus = require('moonloader').download_status
local samem = require 'SAMemory'
local mem = require 'memory'
local Matrix3X3 = require 'matrix3x3'
local Vector3D = require 'vector3d'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local new, str, sizeof = imgui.new, ffi.string, ffi.sizeof
local getBonePosition = ffi.cast("int (__thiscall*)(void*, float*, int, bool)", 0x5E4280)

local mainIni = inicfg.load({
	actor = {
		infRun 					= true,
		infSwim 				= true,
		infOxygen 				= true,
		suicide 				= false,
		megaJump 				= false,
		fastSprint 				= false,
		unfreeze 				= false,
		noFall 					= false,
		GM 						= false,
		antiStun				= false
	},
	vehicle = {
		flip180 				= false,
		flipOnWheels 			= false,
		megaJumpBMX				= false,
		hop 					= false,
		boom 					= false,
		fastExit 				= false,
		AntiBikeFall 			= false,
		GM 						= false,
		GMDefault 				= false,
		GMWheels 				= false,
		fixWheels 				= false,
		speedhack 				= false,
		speedhackMaxSpeed 		= 100.0,
		speedhackSmooth			= 85,
		perfectHandling 		= false,
		allCarsNitro 			= false,
		onlyWheels 				= false,
		tankMode				= false,
		carsFloatWhenHit		= false,
		driveOnWater 			= false,
		restoreHealth 			= false,
		engineOn 				= false,
		antiboom_upside			= false
	},
	weapon = {
		infAmmo 				= false,
		fullSkills				= false,
		plusC					= false,
		noReload				= false,
		aim						= false
	},
	misc = {
		FOV 					= false,
		FOVvalue 				= 70.0,
		antibhop 				= false,
		AirBrake 				= false,
		AirBrakeSpeed 			= 1.0,
		AirBrakeKeys			= 1,
		quickMap 				= false,
		blink 					= false,
		blinkDist 				= 15.0,
		sensfix 				= false,
		clearScreenshot 		= false,
		clearScreenshotDelay	= 1000,
		WalkDriveUnderWater 	= false,
		ClickWarp 				= false,
		reconnect 				= false,
		reconnect_delay			= 1
	},
	visual = {
		nameTag 				= false,
		skeleton				= false,
		keyWH					= false,
		infoBar 				= false,
		infbar_actor_airbrake	= true,
		infbar_actor_wh			= true,
		infbar_actor_gm			= true,
		infbar_actor_antibhop	= true,
		infbar_actor_plusc		= true,
		infbar_veh_airbrake		= true,
		infbar_veh_wh			= true,
		infbar_veh_gm			= true,
		infbar_veh_vgm			= true,
		infbar_veh_engine		= true,
		infbar_actor_interior	= true,
		infbar_actor_coords		= true,
		infbar_actor_pid		= true,
		infbar_actor_php		= true,
		infbar_actor_pap		= true,
		infbar_actor_ping		= true,
		infbar_actor_fps		= true,
		infbar_veh_coords		= true,
		infbar_veh_pid			= true,
		infbar_veh_vid			= true,
		infbar_veh_php			= true,
		infbar_veh_pap			= true,
		infbar_veh_vhp			= true,
		infbar_veh_ping			= true,
		infbar_veh_fps			= true,
		doorLocks				= false,
		distanceDoorLocks		= 30,
		search3dText 			= false,
		traserBullets			= false
	},
	menu = {
		checkUpdate 			= true,
		language				= 1,
		language_menu 			= false,
		language_chat 			= false,
		language_dialogs 		= false,
		language_visual			= false,
		autoSave 				= true,
		iStyle 					= 0
	},
	notifications = {
		notifications			= false,
		NactorGM 				= false,
		NvehGM 					= false,
		NplusC					= false,
		Nairbrake				= false,
		Nwh 					= false
	},
	developers = {
		dialogId				= false,
		textdraw				= false,
		gametext				= false,
		animations				= false
	},
	reventrp = {
		fixchat					= false,
		venable					= false,
		vline					= false,
		searchCorpse			= false,
		searchHorseshoe			= false,
		searchTotems			= false,
		searchContainers		= false
	},
	arizonarp = {
		passAcc					= '',
		pincode					= 0,
		report					= false,
		venable					= false,
		vline					= false,
		searchGuns 				= false,
		searchSeed 				= false,
		searchDeer				= false,
		searchDrugs 			= false,
		searchGift 				= false,
		searchTreasure 			= false,
		searchMats 				= false,
		autoSkipReport			= false,
		emulateLauncher 		= false
	}
}, 'zuwi')

--teleports
tpList = {
	["Teleports interior/Телепорты в интерьеры"] = {
		["Interior: Burning Desire House"] = {2338.32, -1180.61, 1027.98, 5},
		["Interior: RC Zero's Battlefield"] = {-975.5766, 1061.1312, 1345.6719, 10},
		["Interior: Liberty City"] = {-750.80, 491.00, 1371.70, 1},
		["Interior: Unknown Stadium"] = {-1400.2138, 106.8926, 1032.2779, 1},
		["Interior: Secret San Fierro Chunk"] = {-2015.6638, 147.2069, 29.3127, 14},
		["Interior: Jefferson Motel"] = {2220.26, -1148.01, 1025.80, 15},
		["Interior: Jizzy's Pleasure Dome"] = {-2660.6185, 1426.8320, 907.3626, 3},
		["Four Dragons' Managerial Suite"] = {2003.1178, 1015.1948, 33.008, 11},
		["Ganton Gym"] = {770.8033, -0.7033, 1000.7267, 5},
		["Brothel"] = {974.0177, -9.5937, 1001.1484, 3},
		["Brothel2"] = {961.9308, -51.9071, 1001.1172, 3},
		["Inside Track Betting"] = {830.6016, 5.9404, 1004.1797, 3},
		["Blastin' Fools Records"] = {1037.8276, 0.397, 1001.2845, 3},
		["The Big Spread Ranch"] = {1212.1489, -28.5388, 1000.9531, 3},
		["Stadium: Bloodbowl"] = {-1394.20, 987.62, 1023.96, 15},
		["Stadium: Kickstart"] = {-1410.72, 1591.16, 1052.53, 14},
		["Stadium: 8-Track Stadium"] = {-1417.8720, -276.4260, 1051.1910, 7},
		["24/7 Store: Big - L-Shaped"] = {-25.8844, -185.8689, 1003.5499, 17},
		["24/7 Store: Big - Oblong"] = {6.0911, -29.2718, 1003.5499, 10},
		["24/7 Store: Med - Square"] = {-30.9469, -89.6095, 1003.5499, 18},
		["24/7 Store: Med - Square"] = {-25.1329, -139.0669, 1003.5499, 16},
		["Warehouse 1"] = {1290.4106, 1.9512, 1001.0201, 18},
		["Warehouse 2"] = {1412.1472, -2.2836, 1000.9241, 1},
		["B Dup's Apartment"] = {1527.0468, -12.0236, 1002.0971, 3},
		["B Dup's Crack Palace"] = {1523.5098, -47.8211, 1002.2699, 2},
		["Wheel Arch Angels"] = {612.2191, -123.9028, 997.9922, 3},
		["OG Loc's House"] = {512.9291, -11.6929, 1001.5653, 3},
		["Barber Shop"] = {418.4666, -80.4595, 1001.8047, 3},
		["24/7 Store: Sml - Long"] = {-27.3123, -29.2775, 1003.5499, 4},
		["24/7 Store: Sml - Square"] = {-26.6915, -55.7148, 1003.5499, 6},
		["Airport: Ticket Sales"] = {-1827.1473, 7.2074, 1061.1435, 14},
		["Airport: Baggage Claim"] = {-1855.5687, 41.2631, 1061.1435, 14},
		["Airplane: Shamal Cabin"] = {2.3848, 33.1033, 1199.8499, 1},
		["Airplane: Andromada Cargo hold"] = {315.8561, 1024.4964, 1949.7973, 9},
		["Planning Department"] = {386.5259, 173.6381, 1008.3828, 3},
		["Las Venturas Police Department"] = {288.4723, 170.0647, 1007.1794, 3},
		["Pro-Laps"] = {206.4627, -137.7076, 1003.0938, 3},
		["Sex Shop"] = {-100.2674, -22.9376, 1000.7188, 3},
		["Las Venturas Tattoo parlor"] = {-201.2236, -43.2465, 1002.2734, 3},
		["Lost San Fierro Tattoo parlor"] = {-202.9381, -6.7006, 1002.2734, 17},
		["24/7 (version 1)"] = {-25.7220, -187.8216, 1003.5469, 17},
		["Diner 1"] = {454.9853, -107.2548, 999.4376, 5},
		["Pizza Stack"] = {372.5565, -131.3607, 1001.4922, 5},
		["Rusty Brown's Donuts"] = {378.026, -190.5155, 1000.6328, 17},
		["Ammu-nation"] = {315.244, -140.8858, 999.6016, 7},
		["Victim"] = {225.0306, -9.1838, 1002.218, 5},
		["Loco Low Co"] = {611.3536, -77.5574, 997.9995, 2},
		["San Fierro Police Department"] = {246.0688, 108.9703, 1003.2188, 10},
		["24/7 (version 2 - large)"] = {6.0856, -28.8966, 1003.5494, 10},
		["Below The Belt Gym (Las Venturas)"] = {773.7318, -74.6957, 1000.6542, 7},
		["Transfenders"] = {621.4528, -23.7289, 1000.9219, 1},
		["World of Coq"] = {445.6003, -6.9823, 1000.7344, 1},
		["Ammu-nation (version 2)"] = {285.8361, -39.0166, 1001.5156, 1},
		["SubUrban"] = {204.1174, -46.8047, 1001.8047, 1},
		["Denise's Bedroom"] = {245.2307, 304.7632, 999.1484, 1},
		["Helena's Barn"] = {290.623, 309.0622, 999.1484, 3},
		["Barbara's Love nest"] = {322.5014, 303.6906, 999.1484, 5},
		["San Fierro Garage"] = {-2041.2334, 178.3969, 28.8465, 1},
		["Oval Stadium"] = {-1402.6613, 106.3897, 1032.2734, 1},
		["8-Track Stadium"] = {-1403.0116, -250.4526, 1043.5341, 7},
		["The Pig Pen (strip club 2)"] = {1204.6689, -13.5429, 1000.9219, 2},
		["Four Dragons"] = {2016.1156, 1017.1541, 996.875, 10},
		["Liberty City"] = {-741.8495, 493.0036, 1371.9766, 1},
		["Ryder's house"] = {2447.8704, -1704.4509, 1013.5078, 2},
		["Sweet's House"] = {2527.0176, -1679.2076, 1015.4986, 1},
		["RC Battlefield"] = {-1129.8909, 1057.5424, 1346.4141, 10},
		["The Johnson House"] = {2496.0549, -1695.1749, 1014.7422, 3},
		["Burger shot"] = {366.0248, -73.3478, 1001.5078, 10},
		["Caligula's Casino"] = {2233.9363, 1711.8038, 1011.6312, 1},
		["Katie's Lovenest"] = {269.6405, 305.9512, 999.1484, 2},
		["Barber Shop 2 (Reece's)"] = {414.2987, -18.8044, 1001.8047, 2},
		["Angel \"Pine Trailer\""] = {1.1853, -3.2387, 999.4284, 2},
		["24/7 (version 3)"] = {-30.9875, -89.6806, 1003.5469, 18},
		["Zip"] = {161.4048, -94.2416, 1001.8047, 18},
		["The Pleasure Domes"] = {-2638.8232, 1407.3395, 906.4609, 3},
		["Madd Dogg's Mansion"] = {1267.8407, -776.9587, 1091.9063, 5},
		["Big Smoke's Crack Palace"] = {2536.5322, -1294.8425, 1044.125, 2},
		["Burning Desire Building"] = {2350.1597, -1181.0658, 1027.9766, 5},
		["Wu-Zi Mu's"] = {-2158.6731, 642.09, 1052.375, 1},
		["Abandoned AC tower"] = {419.8936, 2537.1155, 10.0, 10},
		["Wardrobe/Changing room"] = {256.9047, -41.6537, 1002.0234, 14},
		["Didier Sachs"] = {204.1658, -165.7678, 1000.5234, 14},
		["Casino (Redsands West)"] = {1133.35, -7.8462, 1000.6797, 12},
		["Kickstart Stadium"] = {-1420.4277, 1616.9221, 1052.5313, 14},
		["Club"] = {493.1443, -24.2607, 1000.6797, 17},
		["Atrium"] = {1727.2853, -1642.9451, 20.2254, 18},
		["Los Santos Tattoo Parlor"] = {-202.842, -24.0325, 1002.2734, 16},
		["Safe House group 1"] = {2233.6919, -1112.8107, 1050.8828, 5},
		["Safe House group 2"] = {1211.2484, 1049.0234, 359.941, 6},
		["Safe House group 3"] = {2319.1272, -1023.9562, 1050.2109, 9},
		["Safe House group 4"] = {2261.0977, -1137.8833, 1050.6328, 10},
		["Sherman Dam"] = {-944.2402, 1886.1536, 5.0051, 17},
		["24/7 (version 4)"] = {-26.1856, -140.9164, 1003.5469, 16},
		["Jefferson Motel"] = {2217.281, -1150.5349, 1025.7969, 15},
		["Jet Interior"] = {1.5491, 23.3183, 1199.5938, 1},
		["The Welcome Pump"] = {681.6216, -451.8933, -25.6172, 1},
		["Burglary House X1"] = {234.6087, 1187.8195, 1080.2578, 3},
		["Burglary House X2"] = {225.5707, 1240.0643, 1082.1406, 2},
		["Burglary House X3"] = {224.288, 1289.1907, 1082.1406, 1},
		["Burglary House X4"] = {239.2819, 1114.1991, 1080.9922, 5},
		["Binco"] = {207.5219, -109.7448, 1005.1328, 15},
		["4 Burglary houses"] = {295.1391, 1473.3719, 1080.2578, 15},
		["Blood Bowl Stadium"] = {-1417.8927, 932.4482, 1041.5313, 15},
		["Budget Inn Motel Room"] = {446.3247, 509.9662, 1001.4195, 12},
		["Lil' Probe Inn"] = {-227.5703, 1401.5544, 27.7656, 18},
		["Pair of Burglary Houses"] = {446.626, 1397.738, 1084.3047, 2},
		["Crack Den"] = {227.3922, 1114.6572, 1080.9985, 5},
		["Burglary House X11"] = {227.7559, 1114.3844, 1080.9922, 5},
		["Burglary House X12"] = {261.1165, 1287.2197, 1080.2578, 4},
		["Ammu-nation (version 3)"] = {291.7626, -80.1306, 1001.5156, 4},
		["Jay's Diner"] = {449.0172, -88.9894, 999.5547, 4},
		["24/7 (version 5)"] = {-27.844, -26.6737, 1003.5573, 4},
		["Michelle's Love Nest*"] = {306.1966, 307.819, 1003.3047, 4},
		["Burglary House X14"] = {24.3769, 1341.1829, 1084.375, 10},
		["Sindacco Abatoir"] = {963.0586, 2159.7563, 1011.0303, 1},
		["Burglary House X13"] = {221.6766, 1142.4962, 1082.6094, 4},
		["Unused Safe House"] = {2323.7063, -1147.6509, 1050.7101, 12},
		["Millie's Bedroom"] = {344.9984, 307.1824, 999.1557, 6},
		["Barber Shop"] = {411.9707, -51.9217, 1001.8984, 12},
		["Dirtbike Stadium"] = {-1421.5618, -663.8262, 1059.5569, 4},
		["Cobra Gym"] = {773.8887, -47.7698, 1000.5859, 6},
		["Los Santos Police Department"] = {246.6695, 65.8039, 1003.6406, 6},
		["Los Santos Airport"] = {-1864.9434, 55.7325, 1055.5276, 14},
		["Burglary House X15"] = {-262.1759, 1456.6158, 1084.3672, 4},
		["Burglary House X16"] = {22.861, 1404.9165, 1084.4297, 5},
		["Burglary House X17"] = {140.3679, 1367.8837, 1083.8621, 5},
		["Bike School"] = {1494.8589, 1306.48, 1093.2953, 3},
		["Francis International Airport"] = {-1813.213, -58.012, 1058.9641, 14},
		["Vice Stadium"] = {-1401.067, 1265.3706, 1039.8672, 16},
		["Burglary House X18"] = {234.2826, 1065.229, 1084.2101, 6},
		["Burglary House X19"] = {-68.5145, 1353.8485, 1080.2109, 6},
		["Zero's RC Shop"] = {-2240.1028, 136.973, 1035.4141, 6},
		["Ammu-nation (version 4)"] = {297.144, -109.8702, 1001.5156, 6},
		["Ammu-nation (version 5)"] = {316.5025, -167.6272, 999.5938, 6},
		["Burglary House X20"] = {-285.2511, 1471.197, 1084.375, 15},
		["24/7 (version 6)"] = {-26.8339, -55.5846, 1003.5469, 6},
		["Secret Valley Diner"] = {442.1295, -52.4782, 999.7167, 6},
		["Rosenberg's Office in Caligulas"] = {2182.2017, 1628.5848, 1043.8723, 2},
		["Fanny Batter's Whore House"] = {748.4623, 1438.2378, 1102.9531, 6},
		["Colonel Furhberger's"] = {2807.3604, -1171.7048, 1025.5703, 8},
		["Cluckin' Bell"] = {366.0002, -9.4338, 1001.8516, 9},
		["The Camel's Toe Safehouse"] = {2216.1282, -1076.3052, 1050.4844, 1},
		["Caligula's Roof"] = {2268.5156, 1647.7682, 1084.2344, 1},
		["Old Venturas Strip Casino"] = {2236.6997, -1078.9478, 1049.0234, 2},
		["Driving School"] = {-2031.1196, -115.8287, 1035.1719, 3},
		["Verdant Bluffs Safehouse"] = {2365.1089, -1133.0795, 1050.875, 8},
		["Andromada"] = {315.4544, 976.5972, 1960.8511, 9},
		["Four Dragons' Janitor's Office"] = {1893.0731, 1017.8958, 31.8828, 10},
		["Bar"] = {501.9578, -70.5648, 998.7578, 11},
		["Burglary House X21"] = {-42.5267, 1408.23, 1084.4297, 8},
		["Willowfield Safehouse"] = {2283.3118, 1139.307, 1050.8984, 11},
		["Burglary House X22"] = {84.9244, 1324.2983, 1083.8594, 9},
		["Burglary House X23"] = {260.7421, 1238.2261, 1084.2578, 9}
	},
	["Others teleports/Остальные телепорты"] = {
		["Transfender near Wang Cars in Doherty"] = {-1935.77, 228.79, 34.16, 0},
		["Wheel Archangels in Ocean Flats"] = {-2707.48, 218.65, 4.93, 0},
		["LowRider Tuning Garage in Willowfield"] = {2645.61, -2029.15, 14.28, 0},
		["Transfender in Temple"] = {1041.26, -1036.77, 32.48, 0},
		["Transfender in come-a-lot"] = {2387.55, 1035.70, 11.56, 0},
		["Eight Ball Autos near El Corona"] = {1836.93, -1856.28, 14.13, 0},
		["Welding Wedding Bomb-workshop in Emerald Isle"] = {2006.11, 2292.87, 11.57, 0},
		["Michelles Pay 'n' Spray in Downtown"] = {-1787.25, 1202.00, 25.84, 0},
		["Pay 'n' Spray in Dillimore"] = {720.10, -470.93, 17.07, 0},
		["Pay 'n' Spray in El Quebrados"] = {-1420.21, 2599.45, 56.43, 0},
		["Pay 'n' Spray in Fort Carson"] = {-100.16, 1100.79, 20.34, 0},
		["Pay 'n' Spray in Idlewood"] = {2078.44, -1831.44, 14.13, 0},
		["Pay 'n' Spray in Juniper Hollow"] = {-2426.89, 1036.61, 51.14, 0},
		["Pay 'n' Spray in Redsands East"] = {1957.96, 2161.96, 11.56, 0},
		["Pay 'n' Spray in Santa Maria Beach"] = {488.29, -1724.85, 12.01, 0},
		["Pay 'n' Spray in Temple"] = {1025.08, -1037.28, 32.28, 0},
		["Pay 'n' Spray near Royal Casino"] = {2393.70, 1472.80, 11.42, 0},
		["Pay 'n' Spray near Wang Cars in Doherty"] = {-1904.97, 268.51, 41.04, 0},
		["Player Garage: Verdant Meadows"] = {403.58, 2486.33, 17.23, 0},
		["Player Garage: Las Venturas Airport"] = {1578.24, 1245.20, 11.57, 0},
		["Player Garage: Calton Heights"] = {-2105.79, 905.11 ,77.07, 0},
		["Player Garage: Derdant Meadows"] = {423.69, 2545.99, 17.07, 0},
		["Player Garage: Dillimore "] = {785.79, -513.12, 17.44, 0},
		["Player Garage: Doherty"] = {-2027.34, 141.02, 29.57, 0},
		["Player Garage: El Corona"] = {1698.10, -2095.88, 14.29, 0},
		["Player Garage: Fort Carson"] = {-361.10, 1185.23, 20.49, 0},
		["Player Garage: Hashbury"] = {-2463.27, -124.86, 26.41, 0},
		["Player Garage: Johnson House"] = {2505.64, -1683.72, 14.25, 0},
		["Player Garage: Mulholland"] = {1350.76, -615.56, 109.88, 0},
		["Player Garage: Palomino Creek"] = {2231.64, 156.93, 27.63, 0},
		["Player Garage: Paradiso"] = {-2695.51, 810.70, 50.57, 0},
		["Player Garage: Prickle Pine"] = {1293.61, 2529.54, 11.42, 0},
		["Player Garage: Redland West"] = {1401.34, 1903.08, 11.99, 0},
		["Player Garage: Rockshore West"] = {2436.50, 698.43, 11.60, 0},
		["Player Garage: Santa Maria Beach"] = {322.65, -1780.30, 5.55, 0},
		["Player Garage: Whitewood Estates"] = {917.46, 2012.14, 11.65, 0},
		["Commerce Region Loading Bay"] = {1641.14 ,-1526.87, 14.30, 0},
		["San Fierro Police Garage"] = {-1617.58, 688.69, -4.50, 0},
		["Los Santos Cemetery"] = {837.05, -1101.93, 23.98, 0},
		["Grove Street"] = {2536.08, -1632.98, 13.79, 0},
		["4D casino"] = {1992.93, 1047.31, 10.82, 0},
		["LS Hospital"] = {2033.00, -1416.02, 16.99, 0},
		["SF Hospital"] = {-2653.11, 634.78, 14.45, 0},
		["LV Hospital"] = {1580.22, 1768.93, 10.82, 0},
		["SF Export"] = {-1550.73, 99.29, 17.33, 0},
		["Otto's Autos"] = {-1658.1656, 1215.0002, 7.25, 0},
		["Wang Cars"] = {-1961.6281, 295.2378, 35.4688, 0},
		["Palamino Bank"] = {2306.3826, -15.2365, 26.7496, 0},
		["Palamino Diner"] = {2331.8984, 6.7816, 26.5032, 0},
		["Dillimore Gas Station"] = {663.0588, -573.6274, 16.3359, 0},
		["Torreno's Ranch"] = {-688.1496, 942.0826, 13.6328, 0},
		["Zombotech - lobby area"] = {-1916.1268, 714.8617, 46.5625, 0},
		["Crypt in LS cemetery (temple)"] = {818.7714, -1102.8689, 25.794, 0},
		["Blueberry Liquor Store"] = {255.2083, -59.6753, 1.5703, 0},
		["Warehouse 3"] = {2135.2004, -2276.2815, 20.6719, 0},
		["K.A.C.C. Military Fuels Depot"] = {2548.4807, 2823.7429, 10.8203, 0},
		["Area 69"] = {215.1515, 1874.0579, 13.1406, 0},
		["Bike School"] = {1168.512, 1360.1145, 10.9293, 0}
	}
}

tpListRVRP = {
	["Фракции"] = {
		["LSPD"] = {1543.4442, -1675.2795, 13.5565, 0},
		["SFPD"] = {-1606.9584, 720.8036, 12.2308, 0},
		["LVPD"] = {2287.3582, 2421.3423, 10.8203, 0},
		["Больница LS"] = {1178.7211, -1326.7101, 14.1560, 0},
		["Больница SF"] = {-2662.2585, 625.6224, 14.4531, 0},
		["Больница LV"] = {1632.9490, 1821.7103, 10.8203, 0},
		["ФБР"] = {1046.4518, 1026.6058, 10.9978, 0},
		["Правительство"] = {1407.8854, -1788.0032, 13.5469, 0},
		["Radio LS"] = {760.8872, -1358.9816, 13.5198, 0},
		["Radio LV"] = {947.7136, 1743.1909, 8.8516, 0},
		["Автошкола"] = {-2037.7787, -99.7488, 35.1641, 0},
		["Отдел лицензирования"] = {1910.5309, 2343.3171, 10.8203, 0},
		["Нац. гвардия"] = {312.4188, 1959.1595, 17.6406, 0},
		["Русская мафия"] = {-2723.7395, -313.8499, 7.1860, 0},
		["Якудза"] = {1492.9370, 724.5159, 10.8203, 0},
		["Aztecas"] = {1673.0597, -2113.4204, 13.5469, 0},
		["Grove"] = {2493.1980, -1673.9980, 13.3359, 0},
		["Ballas"] = {2629.8752, -1077.4902, 69.6170, 0},
		["Vagos"] = {2658.0203, -1991.8776, 13.5546, 0},
		["Rifa"] = {2179.6760, -1001.7764, 62.9305, 0},
		["Comrades MC"] = {157.9299, -172.9156, 1.5781, 0},
		["Warlock MC"] = {-862.3333, 1539.7640, 22.5562, 0}
	},
	["Работы"] = {
		["Нефтянная вышка"] = {815.8508, 604.5477, 11.8305, 0},
		["Грузчик"] = {2788.3308, -2437.6555, 13.6335, 0},
		["Автоцех"] = {-49.9263, -277.9673, 5.4297, 0},
		["Автоцех (Интерьер)"] = {-570.5103, -82.4685, 3001.0859, 1},
		["Дальнобойщик"] = {-504.6666, -545.2240, 25.5234, 0},
		["Лесоруб"] = {-555.8159, -189.0762, 78.4063, 0},
		["Мойщик улиц"] = {-2586.7097, 608.1636, 14.4531, 0},
		["Инкасатор"] = {2168.6331, 998.6193, 10.8203, 0}
	},
	["Остальное"] = {
		["Маяк"] = {154.9556, -1939.6304, 3.7734, 0},
		["Колесо обозрения"] = {381.6406, -2044.5220, 7.8359, 0},
		["Банк"] = {1457.3635, -1027.2981, 23.8281, 0},
		["Чиллиад"] = {-2242.5701, -1731.3767, 480.3250, 0},
		["Биржа труда"] = {554.2763, -1500.1908, 14.5191, 0},
		["Черный рынок"] = {341.1162, -97.6198, 1.4143, 0},
		["Автосалон"] = {-2447.2839, 750.6021, 35.1719, 0},
		["БУ рынок"] = {1492.5591, 2809.7349, 10.8203, 0},
		["ЖДЛС"] = {1707.0590, -1895.5723, 13.5685, 0},
		["ЖДСФ"] = {-1975.0864, 141.7100, 27.6873, 0},
		["ЖДЛВ"] = {2839.9119, 1286.1318, 11.3906, 0},
		["Кладбище LS"] = {936.1039, -1101.4722, 24.3431, 0},
		["Торговый центр"] = {1306.2538, -1331.6825, 13.6422, 0},
		["Страховая"] = {2129.5217, -1139.7073, 25.2925, 0},
		["Аренда авто LS"] = {568.2047, -1290.3613, 17.2422, 0},
		["Аренда авто SF"] = {-1972.5128, 257.3625, 35.1719, 0},
		["Аренда авто LV"] = {2257.1780, 2033.8057, 10.8203, 0},
		["Аренда авто LV (Возле казино)"] = {1897.5586, 949.3096, 10.8203, 0},
		["Карьер"] = {626.8690, 853.0729, -42.9609, 0},
		["Автосервис"] = {617.2724, -1520.0159, 15.2100, 0},
		["Департамент администрации"] = {635.7059, -565.4893, 16.3359, 0},
		["Военкомат"] = {-2449.4761, 498.7346, 30.0873, 0},
		["Казино"] = {2031.1218, 1006.4854, 10.8203, 0},
		["Казино-мини"] = {1015.9720, -1127.6450, 23.8574, 0},
		["Разборка LV"] = {-1506.7286, 2623.1606, 55.8359, 0},
		["Разборка LS-SF"] = {-2110.1580, -2431.3657, 30.6250, 0},
		["Заброшенный завод"] = {1044.2622, 2078.8237, 10.8203, 0},
		["Тренировочный комлпекс"] = {2478.8884, -2108.2769, 13.5469, 0},
		["Состязательная арена"] = {1088.4347, -900.3381, 42.7011, 0},
		["Остров \"Невезения\""] = {616.4134, -3549.7146, 86.9716, 0},
		["Экспорт ТС"] = {-1549.0760, 121.4793, 3.5547, 0},
		["Тир"] = {-2689.1277, 0.0403, 6.1328, 0},
		["Трущобы"] = {-2541.6707, 25.9529, 16.4438, 0},
		["Аэропорт LS"] = {1449.0017, -2461.8296, 13.5547, 0},
		["Аэропорт SF"] = {-1654.5244, -173.4216, 14.1484, 0},
		["Аэропорт LV"] = {1337.8947, 1303.8196, 10.8203, 0}
	},
	["Остальное (Интерьеры)"] = {
		["Старый деморган"] = {1281.1638, -1.8006, 1001.0133, 18},
		["Банк"] = {1463.0361, -1009.3804, 34.4652, 0},
		["Биржа труда"] = {1561.1443, -1518.2223, 3001.5188, 15},
		["Черный рынок"] = {1696.5221, -1586.8097, 2875.2939, 1},
		["Черный рынок (пропуск)"] = {1569.4727, 1230.9999, 1055.1804, 1},
		["Автосалон"] = {2489.1558, -1017.1227, 1033.1460, 1},
		["Департамент администрации"] = {-265.7054, 725.4685, 1000.0859, 5},
		["Военкомат"] = {223.4714, 1540.9908, 3001.0859, 1},
		["Казино"] = {1888.7018, 1049.5775, 996.8770, 1},
		["Казино-мини"] = {1411.5062, -586.6498, 1607.3579, 1},
		["Тренировочный комлпекс"] = {2365.9114, -1943.3044, 919.4700, 1},
		["Состязательная арена"] = {825.7631, -1578.9291, 3001.0823, 3},
		["Тир"] = {285.8546, -78.9205, 1001.5156, 4},
		["Торговый центр"] = {1359.7142, -27.9618, 1000.9163, 1},
		["Страховая"] = {1707.3676, 636.4663, 3001.0859, 1}
	}
}
--params
local colors = {
	hex = {
		main = '{888EA0}',
		main2 = '{F9D82F}',
		blue = '{0984D2}',
		red = '{B31A06}',
		green = '{0E8604}'
	},
	chat = {
		main = 0x888EA0,
		main2 = 0xF9D82F,
		blue = 0x0984D2,
		red = 0xB31A06,
		green = 0x0E8604
	}
}

local checkfuncs = {
	main = {
		activecursor = true,
		enabled = true,
		locked = false
	},
	others = {
		AirBrake = false,
		GMactor = false,
		GMveh = false,
		GMWveh = false,
		Clickwarp = false,
		PlusC = false,
		KeyWH = false
	}
}
local tag = '{F9D82F}zuwi {888EA0}- '
local VGMtext = '{B22C2C}VGM'
local airBrakeCoords = {}
local langIG = {}
--tags
local imgIntGameRUS = {[[Приветствуем Вас, дорогой пользователь! В данном проекте есть вспомогательные функции для Вашей игры в SA:MP.
Поможем Вам разобраться в zuwi - сверху видите вкладки, такие как, "Персонаж", "Транспорт", "Оружие" и другие.
Эти вкладки отвечают за определенную "сферу".]],
[[*Персонаж - эта вкладка отвечает за "читы" для Вашего игрока, другие здесь не касаются;
*Транспорт - эта вкладка отвечает за "читы" для Вашего транспорта, в котором вы находитесь;
*Оружие - эта вкладка отвечает за "читы" только для Вашего оружия, которое у Вас в руках;
*Разное - эта вкладка отвечает за прочие функции, они могут быть как "читы", или чтобы, "глазу было приятно".
Также есть подвкладка "Телепорты", там Вы сможете телепортироваться на любое место, которое есть в списке;
*Визуалы - эта вкладка отвечает за любую отрисовку в zuwi. То есть вне игровые отрисовки, к примеру,
открыты ли транспортные средства или же нет и тому подобное;
*Настройки - эта вкладка отвечает за Ваши настройки zuwi.
Там Вы можете настроить все что возможно, также обратите внимания на подвкладки;
*Помощь - эта вкладка отвечает за Вашу помощь. Если Вы забыли что-либо, либо же не понимаете что-то,
можете открывать данную вкладку и там Вы скорее всего найдете решение Вашей проблемы;
*Еще есть вкладки ниже под всеми основными вкладками. Там находятся сервера.
Вы можете нажать на вкладку Вашего сервера и там будут некоторые полезные функции.]],
[[
Это краткая помощь. Надеемся на то, что Вы разберетесь в данном творении.
Помните, что за "читы" могут выдать наказания, за которые мы не несем ответственности, используйте на свой СТРАХ И РИСК!
Будем очень благодарны за любую помощь! С любовью проект zuwi :3]]}
local imgIntGameENG = {[[Welcome, dear user! In this project there are support functions for your game in SA:MP.
We will help you understand zuwi - can see tabs from the top, such as, "Actor", "Vehicle", "Weapon", etc.
These tabs are responsible for a certain "sphere".]],
[[*Actor - this tab is responsible for the "cheats" for your player, others do not concern here;
*Vehicle - this tab is responsible for the "cheats" for your vehicle in which you are located;
*Weapon - this tab is responsible for the "cheats" only for your weapon, which is in your hands;
*Misc - this tab is responsible for other functions, they can be like "cheats", or so that "the eye is pleasant."
There is also a sub-tab "Teleports", where you can teleport to any place that is on the list;
*Visual - this tab is responsible for any drawing in zuwi. That is, outside the game renders, for example,
whether the vehicles are open or not;
*Settings - this tab is responsible for your zuwi settings.
There you can customize everything that is possible, also pay attention to the sub-tabs;
*Help - this tab is responsible for your help. If you have forgotten something, or do not understand something,
You can open this tab and there you will most likely find a solution to your problem;
*There are still tabs below all the main tabs. There are servers.
You can click on your server tab and there will be some useful features.]],
[[
This is a brief help. We hope that you will understand this creation.
Remember that for "cheats" can give punishments for which we are not responsible, use at your own risk and risk!
We will be very grateful for any help! With love project zuwi: 3]]}
local errorRUS = {'{B31A06}Ошибка #1 {888EA0}- Ваш игрок мертв/не существует',
'{B31A06}Ошибка #2 {888EA0}- Ваш игрок не в транспорте',
'{B31A06}Ошибка #3 {888EA0}- Открыт игровой чат',
'{B31A06}Ошибка #4 {888EA0}- Открыт SampFuncs чат',
'{B31A06}Ошибка #5 {888EA0}- Открыт диалог',
'{B31A06}Ошибка #6 {888EA0}- Ваш игрок мертв/не существует или не в транспорте',
'{B31A06}Ошибка #7 {888EA0}- У Вас открыт игровой чат/SampFuncs чат/диалог',
'{B31A06}Ошибка #8 {888EA0}- Ваш игрок не в транспорте или у Вас открыт игровой чат/SampFuncs чат/диалог',
'{B31A06}Ошибка #9 {888EA0}- Ваш игрок мертв/не существует или у Вас открыт игровой чат/SampFuncs чат/диалог',
'{B31A06}Ошибка #10 {888EA0}- Транспорт не найден',
'{B31A06}Ошибка #11 {888EA0}- Уже открыт другой диалог',
'{B31A06}Ошибка #12 {888EA0}- Не найдено время. Используйте: {0984d2}/z_time 0-23',
'{B31A06}Ошибка #13 {888EA0}- Погода не найдена. Используйте: {0984d2}/z_weather 0-45',
'{B31A06}Ошибка #14 {888EA0}- Метка не создана',
'{B31A06}Ошибка #15 {888EA0}- Вы находитесь в интерьере'}
local errorENG = {'{B31A06}Error #1 {888EA0}- You are player is dead/not playing',
'{B31A06}Error #2 {888EA0}- You are player is not in vehicle',
'{B31A06}Error #3 {888EA0}- Open game chat',
'{B31A06}Error #4 {888EA0}- Open SampFuncs chat',
'{B31A06}Error #5 {888EA0}- Open dialog',
'{B31A06}Error #6 {888EA0}- You are player is dead/not playing or is not in vehicle',
'{B31A06}Error #7 {888EA0}- Open game chat/SampFuncs chat/dialog',
'{B31A06}Error #8 {888EA0}- You are player is not in vehicle or open game chat/SampFuncs chat/dialog',
'{B31A06}Error #9 {888EA0}- You are player is dead/not playing or open game chat/SampFuncs chat/dialog',
'{B31A06}Error #10 {888EA0}- Vehicle not found',
'{B31A06}Error #11 {888EA0}- Another dialog open',
'{B31A06}Error #12 {888EA0}- Time not found. Use: {0984d2}/z_time 0-23{888EA0})',
'{B31A06}Error #13 {888EA0}- Weather not found. Use: {0984d2}/z_weather 0-45',
'{B31A06}Error #14 {888EA0}- Mark not create',
'{B31A06}Error #15 {888EA0}- You are in the interior'}
local helpcmdsampRUS = [[{F9D82F}/headmove {888EA0}- {0984d2}Включает/Выключает {888EA0}поворот головы
{F9D82F}/timestamp {888EA0}- {0984d2}Включает/Выключает {888EA0}время возле каждого сообщения
{F9D82F}/pagesize {888EA0}- Устанавливает количество строк в чате
{F9D82F}/fontsize {888EA0}- Устанавливает толщину чата
{F9D82F}/quit (/q) {888EA0}- Быстрый выход из игры
{F9D82F}/save [комментарий] {888EA0}- Сохранение координат в {0984d2}savedposition.txt
{F9D82F}/fpslimit {888EA0}- Устанавливает лимит кадров в секунду
{F9D82F}/dl {888EA0}- {0984d2}Включает/Выключает {888EA0}подробную информацию о транспорте по близости
{F9D82F}/interior {888EA0}- Выводит в чат текущий интерьер
{F9D82F}/rs {888EA0}- Сохранение координат в {0984d2}rawposition.txt
{F9D82F}/mem {888EA0}- Отображает сколько памяти использует SA:MP]]
local helpcmdsampENG = [[{F9D82F}/headmove {888EA0}- {0984d2}On/Off {888EA0}head rotation
{F9D82F}/timestamp {888EA0}- {0984d2}On/Off {888EA0}time near each message
{F9D82F}/pagesize {888EA0}- Set the number of lines in the chat
{F9D82F}/fontsize {888EA0}- Set wide in the chat
{F9D82F}/quit (/q) {888EA0}- Quick exit from the game
{F9D82F}/save [комментарий] {888EA0}- Save coordinates to {0984d2}savedposition.txt
{F9D82F}/fpslimit {888EA0}- Set the frames per second limit
{F9D82F}/dl {888EA0}- {0984d2}On/Off {888EA0}detailed information about near vehicle
{F9D82F}/interior {888EA0}- Current interior to chat
{F9D82F}/rs {888EA0}- Save coordinates to {0984d2}rawposition.txt
{F9D82F}/mem {888EA0}- How much memory SA:MP uses]]
local errorslistRUS = [[{B31A06}#1 {888EA0}- Ваш игрок мертв/не существует
{B31A06}#2 {888EA0}- Ваш игрок не в транспорте
{B31A06}#3 {888EA0}- Открыт игровой чат
{B31A06}#4 {888EA0}- Открыт SampFuncs чат
{B31A06}#5 {888EA0}- Открыт диалог
{B31A06}#6 {888EA0}- Ваш игрок мертв/не существует или не в транспорте
{B31A06}#7 {888EA0}- У Вас открыт игровой чат/SampFuncs чат/диалог
{B31A06}#8 {888EA0}- Ваш игрок не в транспорте или у Вас открыт игровой чат/SampFuncs чат/диалог
{B31A06}#9 {888EA0}- Ваш игрок мертв/не существует или у Вас открыт игровой чат/SampFuncs чат/диалог
{B31A06}#10 {888EA0}- Транспорт не найден
{B31A06}#11 {888EA0}- Уже открыт другой диалог
{B31A06}#12 {888EA0}- Время не найдено
{B31A06}#13 {888EA0}- Погода не найдена
{B31A06}#14 {888EA0}- Метка не создана
{B31A06}#15 {888EA0}- Вы находитесь в интерьере]]
local errorslistENG = [[{B31A06}#1 {888EA0}- You player is dead/not playing
{B31A06}#2 {888EA0}- You are player is not in vehicle
{B31A06}#3 {888EA0}- Open game chat
{B31A06}#4 {888EA0}- Open SampFuncs chat
{B31A06}#5 {888EA0}- Open dialog
{B31A06}#6 {888EA0}- You are player is dead/not playing or is not in vehicle
{B31A06}#7 {888EA0}- Open game chat/SampFuncs chat/dialog
{B31A06}#8 {888EA0}- You are player is not in vehicle or ppen game chat/SampFuncs chat/dialog
{B31A06}#9 {888EA0}- You are player is dead/not playing or ppen game chat/SampFuncs chat/dialog
{B31A06}#10 {888EA0}- Vehicle not found
{B31A06}#11 {888EA0}- Another open dialog
{B31A06}#12 {888EA0}- Time not found
{B31A06}#13 {888EA0}- Weather not found
{B31A06}#14 {888EA0}- Mark not create
{B31A06}#15 {888EA0}- You are in the interior]]
--others
local BulletSync = {lastId = 0, maxLines = 15}
for i = 1, BulletSync.maxLines do
	BulletSync[i] = {enable = false, o = {x, y, z}, t = {x, y, z}, time = 0, tType = 0}
end

local ltime = {
	mseconds = 0,
	minutes = 0,
	seconds = 0,
	hours = 0
}
--params mimgui
local pw, ph = getScreenResolution()
local sw, sh = 800, 400
local array = {
main_window_state 						= new.bool(false),

show_imgui_infRun 						= new.bool(mainIni.actor.infRun),
show_imgui_infSwim 						= new.bool(mainIni.actor.infSwim),
show_imgui_infOxygen 					= new.bool(mainIni.actor.infOxygen),
show_imgui_megajumpActor 				= new.bool(mainIni.actor.megaJump),
show_imgui_fastsprint 					= new.bool(mainIni.actor.fastSprint),
show_imgui_suicideActor 				= new.bool(mainIni.actor.suicide),
show_imgui_unfreeze 					= new.bool(mainIni.actor.unfreeze),
show_imgui_nofall 						= new.bool(mainIni.actor.noFall),
show_imgui_gmActor 						= new.bool(mainIni.actor.GM),
show_imgui_antistun						= new.bool(mainIni.actor.antiStun),

show_imgui_engineOnVeh 					= new.bool(mainIni.vehicle.engineOn),
show_imgui_restHealthVeh 				= new.bool(mainIni.vehicle.restoreHealth),
show_imgui_megajumpBMX 					= new.bool(mainIni.vehicle.megaJumpBMX),
show_imgui_flip180 						= new.bool(mainIni.vehicle.flip180),
show_imgui_flipOnWheels 				= new.bool(mainIni.vehicle.flipOnWheels),
show_imgui_suicideVeh 					= new.bool(mainIni.vehicle.boom),
show_imgui_hopVeh 						= new.bool(mainIni.vehicle.hop),
show_imgui_fastexit 					= new.bool(mainIni.vehicle.fastExit),
show_imgui_antiBikeFall 				= new.bool(mainIni.vehicle.AntiBikeFall),
show_imgui_gmVeh 						= new.bool(mainIni.vehicle.GM),
show_imgui_gmVehDefault					= new.bool(mainIni.vehicle.GMDefault),
show_imgui_gmVehWheels					= new.bool(mainIni.vehicle.GMWheels),
show_imgui_fixWheels 					= new.bool(mainIni.vehicle.fixWheels),
show_imgui_speedhack 					= new.bool(mainIni.vehicle.speedhack),
SpeedHackMaxSpeed 						= new.float(mainIni.vehicle.speedhackMaxSpeed),
SpeedHackSmooth							= new.int(mainIni.vehicle.speedhackSmooth),
show_imgui_perfectHandling 				= new.bool(mainIni.vehicle.perfectHandling),
show_imgui_allCarsNitro					= new.bool(mainIni.vehicle.allCarsNitro),
show_imgui_onlyWheels					= new.bool(mainIni.vehicle.onlyWheels),
show_imgui_tankMode						= new.bool(mainIni.vehicle.tankMode),
show_imgui_carsFloatWhenHit				= new.bool(mainIni.vehicle.carsFloatWhenHit),
show_imgui_driveOnWater 				= new.bool(mainIni.vehicle.driveOnWater),
antiboom_upside							= new.bool(mainIni.vehicle.antiboom_upside),

show_imgui_infAmmo 						= new.bool(mainIni.weapon.infAmmo),
show_imgui_fullskills					= new.bool(mainIni.weapon.fullSkills),
show_imgui_plusC						= new.bool(mainIni.weapon.plusC),
show_imgui_noreload						= new.bool(mainIni.weapon.noReload),
show_imgui_aim							= new.bool(mainIni.weapon.aim),

show_imgui_UnderWater 					= new.bool(mainIni.misc.WalkDriveUnderWater),
show_imgui_FOV 							= new.bool(mainIni.misc.FOV),
FOV_value 								= new.float(mainIni.misc.FOVvalue),
show_imgui_antibhop 					= new.bool(mainIni.misc.antibhop),
show_imgui_AirBrake 					= new.bool(mainIni.misc.AirBrake),
AirBrake_Speed 							= new.float(mainIni.misc.AirBrakeSpeed),
AirBrake_keys							= new.int(mainIni.misc.AirBrakeKeys),
show_imgui_quickMap 					= new.bool(mainIni.misc.quickMap),
show_imgui_blink 						= new.bool(mainIni.misc.blink),
blink_dist								= new.float(mainIni.misc.blinkDist),
show_imgui_sensfix 						= new.bool(mainIni.misc.sensfix),
show_imgui_reconnect 					= new.bool(mainIni.misc.reconnect),
recon_delay								= new.int(mainIni.misc.reconnect_delay),
show_imgui_clrScr 						= new.bool(mainIni.misc.clearScreenshot),
clrScr_delay							= new.int(mainIni.misc.clearScreenshotDelay),
show_imgui_clickwarp					= new.bool(mainIni.misc.ClickWarp),

show_imgui_nametag 						= new.bool(mainIni.visual.nameTag),
show_imgui_skeleton						= new.bool(mainIni.visual.skeleton),
show_imgui_keyWH						= new.bool(mainIni.visual.keyWH),
infbar 									= new.bool(mainIni.visual.infoBar),
infbar_actor_airbrake					= new.bool(mainIni.visual.infbar_actor_airbrake),
infbar_actor_wh							= new.bool(mainIni.visual.infbar_actor_wh),
infbar_actor_gm							= new.bool(mainIni.visual.infbar_actor_gm),
infbar_actor_antibhop					= new.bool(mainIni.visual.infbar_actor_antibhop),
infbar_actor_plusc						= new.bool(mainIni.visual.infbar_actor_plusc),
infbar_veh_airbrake						= new.bool(mainIni.visual.infbar_veh_airbrake),
infbar_veh_wh							= new.bool(mainIni.visual.infbar_veh_wh),
infbar_veh_gm							= new.bool(mainIni.visual.infbar_veh_gm),
infbar_veh_vgm							= new.bool(mainIni.visual.infbar_veh_vgm),
infbar_veh_engine						= new.bool(mainIni.visual.infbar_veh_engine),
infbar_actor_interior					= new.bool(mainIni.visual.infbar_actor_coords),
infbar_actor_coords						= new.bool(mainIni.visual.infbar_actor_coords),
infbar_actor_pid						= new.bool(mainIni.visual.infbar_actor_pid),
infbar_actor_php						= new.bool(mainIni.visual.infbar_actor_php),
infbar_actor_pap						= new.bool(mainIni.visual.infbar_actor_pap),
infbar_actor_ping						= new.bool(mainIni.visual.infbar_actor_ping),
infbar_actor_fps						= new.bool(mainIni.visual.infbar_actor_fps),
infbar_veh_coords						= new.bool(mainIni.visual.infbar_veh_coords),
infbar_veh_pid							= new.bool(mainIni.visual.infbar_veh_pid),
infbar_veh_vid							= new.bool(mainIni.visual.infbar_veh_vid),
infbar_veh_php							= new.bool(mainIni.visual.infbar_veh_php),
infbar_veh_pap							= new.bool(mainIni.visual.infbar_veh_pap),
infbar_veh_vhp							= new.bool(mainIni.visual.infbar_veh_vhp),
infbar_veh_ping							= new.bool(mainIni.visual.infbar_veh_ping),
infbar_veh_fps							= new.bool(mainIni.visual.infbar_veh_fps),
show_imgui_doorlocks					= new.bool(mainIni.visual.doorLocks),
distDoorLocks							= new.int(mainIni.visual.distanceDoorLocks),
srch3dtext								= new.bool(mainIni.visual.search3dText),
traserbull								= new.bool(mainIni.visual.traserBullets),

checkupdate 							= new.bool(mainIni.menu.checkUpdate),
lang 									= new.int(mainIni.menu.language),
lang_menu 								= new.bool(mainIni.menu.language_menu), --0/1 - eng/rus
lang_chat 								= new.bool(mainIni.menu.language_chat), --0/1 - eng/rus
lang_dialogs 							= new.bool(mainIni.menu.language_dialogs), --0/1 - eng/rus
lang_visual								= new.bool(mainIni.menu.language_visual), --0/1 - eng/rus
AutoSave 								= new.bool(mainIni.menu.autoSave),
comboStyle 								= new.int(mainIni.menu.iStyle),

notifications							= new.bool(mainIni.notifications.notifications),
NactorGM								= new.bool(mainIni.notifications.NactorGM),
NvehGM									= new.bool(mainIni.notifications.NvehGM),
NplusC									= new.bool(mainIni.notifications.NplusC),
Nairbrake								= new.bool(mainIni.notifications.Nairbrake),
Nwh										= new.bool(mainIni.notifications.Nwh),

dev_dialogid							= new.bool(mainIni.developers.dialogId),
dev_textdraw							= new.bool(mainIni.developers.textdraw),
dev_gametext							= new.bool(mainIni.developers.gametext),
dev_anim								= new.bool(mainIni.developers.animations),

rv_fixchat								= new.bool(mainIni.reventrp.fixchat),
rv_venable								= new.bool(mainIni.reventrp.venable),
rv_line									= new.bool(mainIni.reventrp.vline),
rvsearchCorpse							= new.bool(mainIni.reventrp.searchCorpse),
rvsearchHorseshoe						= new.bool(mainIni.reventrp.searchHorseshoe),
rvsearchTotems							= new.bool(mainIni.reventrp.searchTotems),
rvsearchCont							= new.bool(mainIni.reventrp.searchContainers),

arz_passacc								= new.char[33](mainIni.arizonarp.passAcc),
arz_pincode								= new.int(mainIni.arizonarp.pincode),
arz_fastreport							= new.bool(mainIni.arizonarp.report),
arz_venable								= new.bool(mainIni.arizonarp.venable),
arz_vline								= new.bool(mainIni.arizonarp.vline),
arzsearchGuns							= new.bool(mainIni.arizonarp.searchGuns),
arzsearchSeed							= new.bool(mainIni.arizonarp.searchSeed),
arzsearchDeer							= new.bool(mainIni.arizonarp.searchDeer),
arzsearchDrugs							= new.bool(mainIni.arizonarp.searchDrugs),
arzsearchGift							= new.bool(mainIni.arizonarp.searchGift),
arzsearchTreasure						= new.bool(mainIni.arizonarp.searchTreasure),
arzsearchMats							= new.bool(mainIni.arizonarp.searchMats),
arz_autoskiprep							= new.bool(mainIni.arizonarp.autoSkipReport),
arz_launcher							= new.bool(mainIni.arizonarp.emulateLauncher)
}

function setInterfaceStyle(id)
	imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	local ImVec2 = imgui.ImVec2
	style.WindowPadding         = imgui.ImVec2(8, 8)
    style.WindowRounding        = 15
    style.ChildRounding   		= 5
    style.FramePadding          = imgui.ImVec2(5, 3)
    style.FrameRounding         = 3.0
    style.IndentSpacing         = 21
    style.ScrollbarSize         = 10.0
    style.ScrollbarRounding     = 13
    style.GrabMinSize           = 8
    style.GrabRounding          = 1
    style.WindowTitleAlign      = imgui.ImVec2(0.5, 0.5)
    style.ButtonTextAlign       = imgui.ImVec2(0.0, 0.5)
	if id == 0 then
		colors[clr.Text] 					= ImVec4(0.80, 0.80, 0.83, 1.00)
		colors[clr.TextDisabled] 			= ImVec4(0.24, 0.23, 0.29, 1.00)
		colors[clr.WindowBg] 				= ImVec4(0.06, 0.05, 0.07, 1.00)
		colors[clr.ChildBg] 				= ImVec4(0.07, 0.07, 0.09, 1.00)
		colors[clr.PopupBg]				 	= ImVec4(0.07, 0.07, 0.09, 1.00)
		colors[clr.Border]					= ImVec4(0.80, 0.80, 0.83, 0.88)
		colors[clr.BorderShadow] 			= ImVec4(0.92, 0.91, 0.88, 0.00)
		colors[clr.FrameBg] 				= ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.FrameBgHovered] 			= ImVec4(0.24, 0.23, 0.29, 1.00)
		colors[clr.FrameBgActive] 			= ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[clr.TitleBg] 				= ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.TitleBgCollapsed] 		= ImVec4(1.00, 0.98, 0.95, 0.75)
		colors[clr.TitleBgActive] 			= ImVec4(0.07, 0.07, 0.09, 1.00)
		colors[clr.MenuBarBg] 				= ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.ScrollbarBg] 			= ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.ScrollbarGrab] 			= ImVec4(0.80, 0.80, 0.83, 0.31)
		colors[clr.ScrollbarGrabHovered] 	= ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[clr.ScrollbarGrabActive] 	= ImVec4(0.06, 0.05, 0.07, 1.00)
		colors[clr.CheckMark]				= ImVec4(0.80, 0.80, 0.83, 0.31)
		colors[clr.SliderGrab] 				= ImVec4(0.80, 0.80, 0.83, 0.31)
		colors[clr.SliderGrabActive] 		= ImVec4(0.06, 0.05, 0.07, 1.00)
		colors[clr.Button]					= ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.ButtonHovered] 			= ImVec4(0.24, 0.23, 0.29, 1.00)
		colors[clr.ButtonActive] 			= ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[clr.Header] 					= ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.HeaderHovered] 			= ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[clr.HeaderActive] 			= ImVec4(0.06, 0.05, 0.07, 1.00)
		colors[clr.Separator]            	= ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.SeparatorHovered]     	= ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[clr.SeparatorActive]      	= ImVec4(0.06, 0.05, 0.07, 1.00)
		colors[clr.ResizeGrip] 				= ImVec4(0.00, 0.00, 0.00, 0.00)
		colors[clr.ResizeGripHovered] 		= ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[clr.ResizeGripActive] 		= ImVec4(0.06, 0.05, 0.07, 1.00)
		colors[clr.PlotLines] 				= ImVec4(0.40, 0.39, 0.38, 0.63)
		colors[clr.PlotLinesHovered] 		= ImVec4(0.25, 1.00, 0.00, 1.00)
		colors[clr.PlotHistogram]			= ImVec4(0.40, 0.39, 0.38, 0.63)
		colors[clr.PlotHistogramHovered] 	= ImVec4(0.25, 1.00, 0.00, 1.00)
		colors[clr.TextSelectedBg]			= ImVec4(0.25, 1.00, 0.00, 0.43)
		colors[clr.ModalWindowDimBg]		= ImVec4(1.00, 0.98, 0.95, 0.73)
	elseif id == 1 then
		colors[clr.Text]   				  = ImVec4(0.00, 0.00, 0.00, 0.85)
		colors[clr.TextDisabled]  		  = ImVec4(0.24, 0.24, 0.24, 1.00)
		colors[clr.WindowBg]              = ImVec4(0.90, 0.90, 0.90, 1.00)
		colors[clr.ChildBg]        		  = ImVec4(0.86, 0.86, 0.86, 1.00)
		colors[clr.PopupBg]               = ImVec4(0.82, 0.82, 0.82, 1.00)
		colors[clr.Border]                = ImVec4(0.76, 0.76, 0.76, 1.00)
		colors[clr.BorderShadow]          = ImVec4(0.00, 0.00, 0.00, 0.40)
		colors[clr.FrameBg]               = ImVec4(0.78, 0.78, 0.78, 1.00)
		colors[clr.FrameBgHovered]        = ImVec4(0.72, 0.72, 0.72, 1.00)
		colors[clr.FrameBgActive]         = ImVec4(0.66, 0.66, 0.66, 1.00)
		colors[clr.TitleBg]               = ImVec4(0.00, 0.45, 1.00, 0.82)
		colors[clr.TitleBgCollapsed]      = ImVec4(0.00, 0.45, 1.00, 0.82)
		colors[clr.TitleBgActive]         = ImVec4(0.00, 0.45, 1.00, 0.82)
		colors[clr.MenuBarBg]             = ImVec4(0.00, 0.37, 0.78, 1.00)
		colors[clr.ScrollbarBg]           = ImVec4(0.00, 0.00, 0.00, 0.00)
		colors[clr.ScrollbarGrab]         = ImVec4(0.00, 0.35, 1.00, 0.78)
		colors[clr.ScrollbarGrabHovered]  = ImVec4(0.00, 0.33, 1.00, 0.84)
		colors[clr.ScrollbarGrabActive]   = ImVec4(0.00, 0.31, 1.00, 0.88)
		colors[clr.CheckMark]             = ImVec4(0.00, 0.49, 1.00, 0.59)
		colors[clr.SliderGrab]            = ImVec4(0.00, 0.49, 1.00, 0.59)
		colors[clr.SliderGrabActive]      = ImVec4(0.00, 0.39, 1.00, 0.71)
		colors[clr.Button]                = ImVec4(0.00, 0.49, 1.00, 0.59)
		colors[clr.ButtonHovered]         = ImVec4(0.00, 0.49, 1.00, 0.71)
		colors[clr.ButtonActive]          = ImVec4(0.00, 0.49, 1.00, 0.78)
		colors[clr.Header]                = ImVec4(0.00, 0.49, 1.00, 0.78)
		colors[clr.HeaderHovered]         = ImVec4(0.00, 0.49, 1.00, 0.71)
		colors[clr.HeaderActive]          = ImVec4(0.00, 0.49, 1.00, 0.78)
		colors[clr.Separator]             = ImVec4(0.00, 0.49, 1.00, 0.78)
		colors[clr.SeparatorHovered]      = ImVec4(0.00, 0.49, 1.00, 0.71)
		colors[clr.SeparatorActive]       = ImVec4(0.00, 0.49, 1.00, 0.78)
		colors[clr.ResizeGrip]            = ImVec4(0.00, 0.39, 1.00, 0.59)
		colors[clr.ResizeGripHovered]     = ImVec4(0.00, 0.27, 1.00, 0.59)
		colors[clr.ResizeGripActive]      = ImVec4(0.00, 0.25, 1.00, 0.63)
		colors[clr.PlotLines]             = ImVec4(0.00, 0.39, 1.00, 0.75)
		colors[clr.PlotLinesHovered]      = ImVec4(0.00, 0.39, 1.00, 0.75)
		colors[clr.PlotHistogram]         = ImVec4(0.00, 0.39, 1.00, 0.75)
		colors[clr.PlotHistogramHovered]  = ImVec4(0.00, 0.35, 0.92, 0.78)
		colors[clr.TextSelectedBg]        = ImVec4(0.00, 0.47, 1.00, 0.59)
		colors[clr.ModalWindowDimBg]  	  = ImVec4(0.20, 0.20, 0.20, 0.35)
	elseif id == 2 then
		colors[clr.Text]   				  = ImVec4(0.00, 0.00, 0.00, 0.80)
		colors[clr.TextDisabled]  		  = ImVec4(0.24, 0.24, 0.24, 1.00)
		colors[clr.WindowBg]              = ImVec4(0.90, 0.90, 0.90, 1.00)
		colors[clr.ChildBg]         	  = ImVec4(0.86, 0.86, 0.86, 1.00)
		colors[clr.PopupBg]               = ImVec4(0.82, 0.82, 0.82, 1.00)
		colors[clr.Border]                = ImVec4(0.76, 0.76, 0.76, 1.00)
		colors[clr.BorderShadow]          = ImVec4(0.00, 0.00, 0.00, 0.40)
		colors[clr.FrameBg]               = ImVec4(0.78, 0.78, 0.78, 1.00)
		colors[clr.FrameBgHovered]        = ImVec4(0.72, 0.72, 0.72, 1.00)
		colors[clr.FrameBgActive]         = ImVec4(0.66, 0.66, 0.66, 1.00)
		colors[clr.TitleBg]               = ImVec4(0.45, 0.00, 1.00, 0.82)
		colors[clr.TitleBgCollapsed]      = ImVec4(0.45, 0.00, 1.00, 0.82)
		colors[clr.TitleBgActive]         = ImVec4(0.45, 0.00, 1.00, 0.82)
		colors[clr.MenuBarBg]             = ImVec4(0.37, 0.00, 0.78, 1.00)
		colors[clr.ScrollbarBg]           = ImVec4(0.00, 0.00, 0.00, 0.00)
		colors[clr.ScrollbarGrab]         = ImVec4(0.35, 0.00, 1.00, 0.78)
		colors[clr.ScrollbarGrabHovered]  = ImVec4(0.33, 0.00, 1.00, 0.84)
		colors[clr.ScrollbarGrabActive]   = ImVec4(0.31, 0.00, 1.00, 0.88)
		colors[clr.CheckMark]             = ImVec4(0.49, 0.00, 1.00, 0.59)
		colors[clr.SliderGrab]            = ImVec4(0.49, 0.00, 1.00, 0.59)
		colors[clr.SliderGrabActive]      = ImVec4(0.39, 0.00, 1.00, 0.71)
		colors[clr.Button]                = ImVec4(0.49, 0.00, 1.00, 0.59)
		colors[clr.ButtonHovered]         = ImVec4(0.49, 0.00, 1.00, 0.71)
		colors[clr.ButtonActive]          = ImVec4(0.49, 0.00, 1.00, 0.78)
		colors[clr.Header]                = ImVec4(0.49, 0.00, 1.00, 0.78)
		colors[clr.HeaderHovered]         = ImVec4(0.49, 0.00, 1.00, 0.71)
		colors[clr.HeaderActive]          = ImVec4(0.49, 0.00, 1.00, 0.78)
		colors[clr.Separator]             = ImVec4(0.49, 0.00, 1.00, 0.78)
		colors[clr.SeparatorHovered]      = ImVec4(0.49, 0.00, 1.00, 0.71)
		colors[clr.SeparatorActive]       = ImVec4(0.49, 0.00, 1.00, 0.78)
		colors[clr.ResizeGrip]            = ImVec4(0.39, 0.00, 1.00, 0.59)
		colors[clr.ResizeGripHovered]     = ImVec4(0.27, 0.00, 1.00, 0.59)
		colors[clr.ResizeGripActive]      = ImVec4(0.25, 0.00, 1.00, 0.63)
		colors[clr.PlotLines]             = ImVec4(0.39, 0.00, 1.00, 0.75)
		colors[clr.PlotLinesHovered]      = ImVec4(0.39, 0.00, 1.00, 0.75)
		colors[clr.PlotHistogram]         = ImVec4(0.39, 0.00, 1.00, 0.75)
		colors[clr.PlotHistogramHovered]  = ImVec4(0.35, 0.00, 0.92, 0.78)
		colors[clr.TextSelectedBg]        = ImVec4(0.47, 0.00, 1.00, 0.59)
		colors[clr.ModalWindowDimBg]  = ImVec4(0.20, 0.20, 0.20, 0.35)
	elseif id == 3 then
		colors[clr.Text] = ImVec4(0.95, 0.96, 0.98, 1.00)
		colors[clr.TextDisabled] = ImVec4(0.36, 0.42, 0.47, 1.00)
		colors[clr.WindowBg] = ImVec4(0.11, 0.15, 0.17, 1.00)
		colors[clr.ChildBg] = ImVec4(0.15, 0.18, 0.22, 1.00)
		colors[clr.PopupBg] = ImVec4(0.08, 0.08, 0.08, 0.94)
		colors[clr.Border] = ImVec4(0.43, 0.43, 0.50, 0.50)
		colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
		colors[clr.FrameBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
		colors[clr.FrameBgHovered] = ImVec4(0.12, 0.20, 0.28, 1.00)
		colors[clr.FrameBgActive] = ImVec4(0.09, 0.12, 0.14, 1.00)
		colors[clr.TitleBg] = ImVec4(0.09, 0.12, 0.14, 0.65)
		colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.00, 0.00, 0.51)
		colors[clr.TitleBgActive] = ImVec4(0.08, 0.10, 0.12, 1.00)
		colors[clr.MenuBarBg] = ImVec4(0.15, 0.18, 0.22, 1.00)
		colors[clr.ScrollbarBg] = ImVec4(0.02, 0.02, 0.02, 0.39)
		colors[clr.ScrollbarGrab] = ImVec4(0.20, 0.25, 0.29, 1.00)
		colors[clr.ScrollbarGrabHovered] = ImVec4(0.18, 0.22, 0.25, 1.00)
		colors[clr.ScrollbarGrabActive] = ImVec4(0.09, 0.21, 0.31, 1.00)
		colors[clr.CheckMark] = ImVec4(0.28, 0.56, 1.00, 1.00)
		colors[clr.SliderGrab] = ImVec4(0.28, 0.56, 1.00, 1.00)
		colors[clr.SliderGrabActive] = ImVec4(0.37, 0.61, 1.00, 1.00)
		colors[clr.Button] = ImVec4(0.20, 0.25, 0.29, 1.00)
		colors[clr.ButtonHovered] = ImVec4(0.28, 0.56, 1.00, 1.00)
		colors[clr.ButtonActive] = ImVec4(0.06, 0.53, 0.98, 1.00)
		colors[clr.Header] = ImVec4(0.20, 0.25, 0.29, 0.55)
		colors[clr.HeaderHovered] = ImVec4(0.26, 0.59, 0.98, 0.80)
		colors[clr.HeaderActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
		colors[clr.Separator]             = ImVec4(0.20, 0.25, 0.29, 0.55)
		colors[clr.SeparatorHovered]      = ImVec4(0.26, 0.59, 0.98, 0.80)
		colors[clr.SeparatorActive]       = ImVec4(0.26, 0.59, 0.98, 1.00)
		colors[clr.ResizeGrip] = ImVec4(0.26, 0.59, 0.98, 0.25)
		colors[clr.ResizeGripHovered] = ImVec4(0.26, 0.59, 0.98, 0.67)
		colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
		colors[clr.PlotLines] = ImVec4(0.61, 0.61, 0.61, 1.00)
		colors[clr.PlotLinesHovered] = ImVec4(1.00, 0.43, 0.35, 1.00)
		colors[clr.PlotHistogram] = ImVec4(0.90, 0.70, 0.00, 1.00)
		colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
		colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
		colors[clr.ModalWindowDimBg] = ImVec4(1.00, 0.98, 0.95, 0.73)
	elseif id == 4 then
		colors[clr.Text] = ImVec4(0.860, 0.930, 0.890, 0.78)
		colors[clr.TextDisabled] = ImVec4(0.860, 0.930, 0.890, 0.28)
		colors[clr.WindowBg] = ImVec4(0.13, 0.14, 0.17, 1.00)
		colors[clr.ChildBg] = ImVec4(0.200, 0.220, 0.270, 0.58)
		colors[clr.PopupBg] = ImVec4(0.200, 0.220, 0.270, 0.9)
		colors[clr.Border] = ImVec4(0.31, 0.31, 1.00, 0.00)
		colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
		colors[clr.FrameBg] = ImVec4(0.200, 0.220, 0.270, 1.00)
		colors[clr.FrameBgHovered] = ImVec4(0.455, 0.198, 0.301, 0.78)
		colors[clr.FrameBgActive] = ImVec4(0.455, 0.198, 0.301, 1.00)
		colors[clr.TitleBg] = ImVec4(0.232, 0.201, 0.271, 1.00)
		colors[clr.TitleBgActive] = ImVec4(0.502, 0.075, 0.256, 1.00)
		colors[clr.TitleBgCollapsed] = ImVec4(0.200, 0.220, 0.270, 0.75)
		colors[clr.MenuBarBg] = ImVec4(0.200, 0.220, 0.270, 0.47)
		colors[clr.ScrollbarBg] = ImVec4(0.200, 0.220, 0.270, 1.00)
		colors[clr.ScrollbarGrab] = ImVec4(0.09, 0.15, 0.1, 1.00)
		colors[clr.ScrollbarGrabHovered] = ImVec4(0.455, 0.198, 0.301, 0.78)
		colors[clr.ScrollbarGrabActive] = ImVec4(0.455, 0.198, 0.301, 1.00)
		colors[clr.CheckMark] = ImVec4(0.71, 0.22, 0.27, 1.00)
		colors[clr.SliderGrab] = ImVec4(0.47, 0.77, 0.83, 0.14)
		colors[clr.SliderGrabActive] = ImVec4(0.71, 0.22, 0.27, 1.00)
		colors[clr.Button] = ImVec4(0.47, 0.77, 0.83, 0.14)
		colors[clr.ButtonHovered] = ImVec4(0.455, 0.198, 0.301, 0.86)
		colors[clr.ButtonActive] = ImVec4(0.455, 0.198, 0.301, 1.00)
		colors[clr.Header] = ImVec4(0.455, 0.198, 0.301, 0.76)
		colors[clr.HeaderHovered] = ImVec4(0.455, 0.198, 0.301, 0.86)
		colors[clr.HeaderActive] = ImVec4(0.502, 0.075, 0.256, 1.00)
		colors[clr.Separator]             = ImVec4(0.455, 0.198, 0.301, 0.76)
		colors[clr.SeparatorHovered]      = ImVec4(0.455, 0.198, 0.301, 0.86)
		colors[clr.SeparatorActive]       = ImVec4(0.502, 0.075, 0.256, 1.00)
		colors[clr.ResizeGrip] = ImVec4(0.47, 0.77, 0.83, 0.04)
		colors[clr.ResizeGripHovered] = ImVec4(0.455, 0.198, 0.301, 0.78)
		colors[clr.ResizeGripActive] = ImVec4(0.455, 0.198, 0.301, 1.00)
		colors[clr.PlotLines] = ImVec4(0.860, 0.930, 0.890, 0.63)
		colors[clr.PlotLinesHovered] = ImVec4(0.455, 0.198, 0.301, 1.00)
		colors[clr.PlotHistogram] = ImVec4(0.860, 0.930, 0.890, 0.63)
		colors[clr.PlotHistogramHovered] = ImVec4(0.455, 0.198, 0.301, 1.00)
		colors[clr.TextSelectedBg] = ImVec4(0.455, 0.198, 0.301, 0.43)
		colors[clr.ModalWindowDimBg] = ImVec4(0.200, 0.220, 0.270, 0.73)
	end
end

function main()
	if not isSampLoaded() and not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(40) end
	if not doesFileExist('moonloader/config/zuwi.ini') then inicfg.save(mainIni, 'zuwi.ini') end
	ifont = renderCreateFont("Verdana", (((pw == 1680 or pw == 1600 or pw == 1440) and 8) or ((pw == 1366 or pw == 1360 or pw == 1280 or pw == 1152 or pw == 1024) and 7) or ((pw == 800 or pw == 720 or pw == 640) and 6)) or 9, 5)
	ibY = (((pw == 1366 or pw == 1360) and 17) or ((pw == 1366 or pw == 1360) and 17) or ((pw == 1280 or pw == 1152 or pw == 1024) and 16) or ((pw == 800 or pw == 720 or pw == 640) and 14)) or 18
	clickfont = renderCreateFont("Tahoma", 10, FCR_BOLD + FCR_BORDER)

	if array.checkupdate[0] then autoupdate('https://raw.githubusercontent.com/PanSeek/zuwi/master/version.json', '##autoupdate', 'https://raw.githubusercontent.com/PanSeek/zuwi/master/version.json')
	else sampAddChatMessage(tag..(array.lang_chat[0] and 'У Вас выключено автообновление. Вы используете версию: {F9D82F}'..version_script..' {888EA0}| Меню: {F9D82F}F10' or 'You have disabled autoupdate. You are using version: {F9D82F}'..version_script..' {888EA0}| Menu: {F9D82F}F10') ,colors.chat.main) end

	sampRegisterChatCommand({'z_date', 'zdate'}, function() sampAddChatMessage(os.date(array.lang_chat[0] and tag..'Сегодняшняя дата: {F9D82F}%d.%m.%Y' or tag..'Todays date: {F9D82F}%d.%m.%Y'), colors.chat.main) end)
	sampRegisterChatCommand({'z_menu', 'zmenu'}, function() array.main_window_state[0] = not array.main_window_state[0] sampAddChatMessage(tag..(array.lang_chat[0] and 'Вы {F9D82F}открыли/закрыли {888EA0}меню скрипта. Это можно сделать без команды, используйте клавишу {F9D82F}F10' or 'You is {F9D82F}open/close {888EA0}script menu. This can be done without a command, using the key {F9D82F}F10'), colors.chat.main) end)
	sampRegisterChatCommand({'z_suicide', 'zsuicide'}, cmd_suicide)
	sampRegisterChatCommand({'z_coord', 'zcoord'}, cmd_coord)
	sampRegisterChatCommand({'z_getmoney', 'zgetmoney'}, cmd_getmoney)
	sampRegisterChatCommand({'z_repair', 'zrepair'}, cmd_repair)
	sampRegisterChatCommand({'z_togall', 'ztogall'}, cmd_togall)
	sampRegisterChatCommand({'z_errors', 'zerrors'}, cmd_errors)
	sampRegisterChatCommand({'z_time', 'ztime'}, cmd_time)
	sampRegisterChatCommand({'z_weather', 'zweather'}, cmd_weather)
	sampRegisterChatCommand({'z_help', 'zhelp'}, function() if not array.main_window_state[0] then array.main_window_state[0] = true act1 = 8 elseif array.main_window_state[0] then act1 = 8 end end)
	sampRegisterChatCommand({'z_setmark', 'zsetmark'}, cmd_setmark)
	sampRegisterChatCommand({'z_tpmark', 'ztpmark'}, cmd_tpmark)
	sampRegisterChatCommand({'z_cc', 'zcc'}, function() mem.fill(sampGetChatInfoPtr() + 306, 0x0, 25200) mem.write(sampGetChatInfoPtr() + 306, 25562, 4, 0x0) mem.write(sampGetChatInfoPtr() + 0x63DA, 1, 1) end)
	sampRegisterChatCommand({'z_update', 'zupdate'}, cmd_update)
	sampRegisterChatCommand({'z_checktime', 'zchecktime'}, function() local time = getTime(0) sampAddChatMessage(tag..(array.lang_chat[0] and 'Точное время по МСК: {F9D82F}' or 'Exact time to MSK: {F9D82F}')..os.date('%H{888EA0}:{F9D82F}%M{888EA0}:{F9D82F}%S', time), colors.chat.main) end)
	sampRegisterChatCommand({'z_cmdsamp', 'zcmdsamp'}, cmd_helpcmdsamp)
	sampRegisterChatCommand({'z_reload', 'zreload'}, function() thisScript():reload() end)
	sampRegisterChatCommand({'z_fps', 'zfps'}, function() local ifps = string.format('%d', mem.getfloat(0xB7CB50, 4, false)) sampAddChatMessage(tag..(array.lang_chat[0] and 'Сейчас FPS: {F9D82F}'..ifps or 'FPS now: {F9D82F}'..ifps), colors.chat.main) end)
	--sampRegisterChatCommand('z_tpmark_gta', cmd_tpmark_gta)
	--arizona-rp
	sampRegisterChatCommand({'report', 'rep'}, cmd_arz_report)

	while true do
		wait(0)
		if isKeyJustPressed(key.VK_F12) then
			checkfuncs.main.enabled = not checkfuncs.main.enabled
			if array.main_window_state[0] then
				array.main_window_state[0] = false
			end
		end
		
		if checkfuncs.main.enabled then
			check_keys()
			main_funcs()
			waitfuncs()

			if not isGamePaused() then
				ltime.mseconds = ltime.mseconds + 1
				if ltime.mseconds == 60 and ltime.seconds then
					ltime.seconds = ltime.seconds + 1
					ltime.mseconds = 0
				end
				if ltime.seconds == 60 and ltime.minutes then
					ltime.minutes = ltime.minutes + 1
					ltime.seconds = 0
				end
				if ltime.minutes == 60 then
					ltime.hours = ltime.hours + 1
					ltime.minutes = 0
				end
			end
	
			if time then
				setTimeOfDay(time, 0)
			end
		end
	end
end

imgui.OnInitialize(function()
	imgui.GetIO().IniFilename = nil

    local config = imgui.ImFontConfig()
    config.MergeMode, config.PixelSnapH = true, true
    local glyph_ranges = imgui.GetIO().Fonts:GetGlyphRangesCyrillic()
	local iconRanges = new.ImWchar[3](fa.min_range, fa.max_range, 0)

	imgui.GetIO().Fonts:AddFontFromFileTTF('Arial.ttf', 14.0, nil, glyph_ranges)
    icon = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/lib/fa-solid-900.ttf', 14.0, config, iconRanges)

    setInterfaceStyle(mainIni.menu.iStyle)
end)

local mainFrame = imgui.OnFrame(
    function() return array.main_window_state[0] end,
    function(self)
		if not checkfuncs.main.activecursor then self.HideCursor = true else self.HideCursor = false end
        if not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() then
            imgui.SetNextWindowPos(imgui.ImVec2(pw / 2, ph / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(sw, sh), imgui.Cond.FirstUseEver)
			imgui.Begin('zuwi | Version: ' .. version_script, array.main_window_state, imgui.WindowFlags.NoResize)
			imgui.BeginChild('##tabs', imgui.ImVec2(115, sh-40), true)
			if imgui.ButtonActivated(act1 == 1, fa.ICON_STREET_VIEW .. (array.lang_menu[0] and u8' Персонаж' or ' Actor'), imgui.ImVec2(100, 0)) then act1 = 1 end
			if imgui.ButtonActivated(act1 == 2, fa.ICON_CAR .. (array.lang_menu[0] and u8' Транспорт' or ' Vehicle'), imgui.ImVec2(100, 0)) then act1 = 2 end
			if imgui.ButtonActivated(act1 == 3, fa.ICON_BOMB .. (array.lang_menu[0] and u8' Оружие' or ' Weapon'), imgui.ImVec2(100, 0)) then act1 = 3 end
			if imgui.ButtonActivated(act1 == 4, fa.ICON_CHART_PIE .. (array.lang_menu[0] and u8' Разное' or ' Misc'), imgui.ImVec2(100, 0)) then act1 = 4 end
			if imgui.ButtonActivated(act1 == 5, fa.ICON_EYE .. (array.lang_menu[0] and u8' Визуалы' or ' Visual'), imgui.ImVec2(100, 0)) then act1 = 5 end
			if imgui.ButtonActivated(act1 == 6, fa.ICON_COG .. (array.lang_menu[0] and u8' Настройки' or ' Settings'), imgui.ImVec2(100, 0)) then act1 = 6 end
			if imgui.ButtonActivated(act1 == 8, ' ' .. fa.ICON_INFO .. (array.lang_menu[0] and u8'  Помощь' or '  Help'), imgui.ImVec2(100, 0)) then act1 = 8 end
			-- imgui.CenterTextColored(imgui.GetStyle().Colors[imgui.Col.Text], fa.ICON_SERVER .. (array.lang_menu[0] and u8' Серверы' or ' Servers'))
			imgui.Spacing()
			if getServer('arizona') then if imgui.ButtonActivated(act1 == 10, fa.ICON_SERVER .. ' Arizona-RP', imgui.ImVec2(100, 0)) then act1 = 10 end
			elseif getServer('revent') then if imgui.ButtonActivated(act1 == 9, fa.ICON_SERVER .. ' Revent-RP', imgui.ImVec2(100, 0)) then act1 = 9 end end
			imgui.CenterTextColored(imgui.GetStyle().Colors[imgui.Col.Text], 'Uptime: '..ltime.hours..':'..ltime.minutes..':'..ltime.seconds)
			imgui.EndChild()
			imgui.SameLine()
            if act1 == 1 then
                imgui.BeginChild('##actor', imgui.ImVec2(sw-140, sh-40), true)
				imgui.ToggleButton(array.lang_menu[0] and u8'Бесконечная выносливость (бег)' or 'Infinity stamina (run)', array.show_imgui_infRun)
				imgui.ToggleButton(array.lang_menu[0] and u8'Бесконечная выносливость (плавание)' or 'Infinity stamina (swim)', array.show_imgui_infSwim)
				imgui.ToggleButton(array.lang_menu[0] and u8'Бесконечный кислород' or 'Infinity oxygen', array.show_imgui_infOxygen)
				imgui.ToggleButton(array.lang_menu[0] and u8'Мега прыжок' or 'Mega jump', array.show_imgui_megajumpActor)
				imgui.ToggleButton(array.lang_menu[0] and u8'Быстрый бег' or 'Fast sprint', array.show_imgui_fastsprint)
				imgui.ToggleButton(array.lang_menu[0] and u8'Без падений' or 'No fall', array.show_imgui_nofall)
				imgui.ToggleButton(array.lang_menu[0] and u8'Разморозить' or 'Unfreeze', array.show_imgui_unfreeze)
				imgui.TextQuestion('##unfreeze', array.lang_menu[0] and u8"Если функция включена, используйте: /" or "If function enabled then use key: /")
				imgui.ToggleButton(array.lang_menu[0] and u8'Суицид' or 'Suicide', array.show_imgui_suicideActor)
				imgui.TextQuestion('#suicideactor', array.lang_menu[0] and u8"Если функция включена, используйте: F3\nЕсли функция 'Взрыв транспорта' включен во вкладке 'Транспорт' то произойдет только суицид\nЕсли обе функции включены, то произойдет взрыв транспорта, а если Вы не в транспорте, то Вы совершите суицид" or "If function enabled then use key: F3\nIf function 'Boom vehicle' enabled in tab 'Vehicle' then will be only suicide\nThat is, if both functions are enabled, then you will boom vehicle, and not in vehicle will suicide")
				imgui.ToggleButton(array.lang_menu[0] and u8'Бесконечное здоровье' or 'GM', array.show_imgui_gmActor)
				imgui.TextQuestion('##gmactor', array.lang_menu[0] and u8"Если функция включена, используйте: Insert" or "If function enabled then use key: Insert")
				imgui.ToggleButton('Antistun', array.show_imgui_antistun)
                imgui.EndChild()
            elseif act1 == 2 then
                imgui.BeginChild('##vehicle', imgui.ImVec2(sw-140, sh-40), true)
				imgui.ToggleButton('SpeedHack', array.show_imgui_speedhack)
				imgui.TextQuestion('#sh', array.lang_menu[0] and u8'Если функция включена, используйте: ALT\nЧем выше "Плавность", тем плавнее "SpeedHack"' or 'If function enabled then use key: ALT\nThe higher the "Smooth", the smoother "SpeedHack"')
				imgui.SameLine()
				imgui.Text(fa.ICON_COG)
				if imgui.IsItemClicked() then
					imgui.OpenPopup(array.lang_menu[0] and u8'Настройки Speedhack' or 'Settings Speedhack')
				end
				if imgui.BeginPopup(array.lang_menu[0] and u8'Настройки Speedhack' or 'Settings Speedhack') then
					imgui.PushItemWidth(250)
					imgui.SliderFloat(array.lang_menu[0] and u8'Максимальная скорость' or 'Max speed', array.SpeedHackMaxSpeed, 80, 300, '%.f', 0.5)
					imgui.SliderInt(array.lang_menu[0] and u8'Плавность' or 'Smooth', array.SpeedHackSmooth, 5, 150)
					imgui.PopItemWidth()
					imgui.EndPopup()
				end
				imgui.ToggleButton(array.lang_menu[0] and u8'Переворот на 180' or 'Flip 180', array.show_imgui_flip180)
				imgui.TextQuestion('##flip180', array.lang_menu[0] and u8"Если функция включена, используйте: Backspace" or "If function enabled then use key: Backspace")
				imgui.ToggleButton(array.lang_menu[0] and u8'Переворот на колеса' or 'Flip on wheels', array.show_imgui_flipOnWheels)
				imgui.TextQuestion('#fliponwheels', array.lang_menu[0] and u8"Если функция включена, используйте: Delete" or "If function enabled then use key: Delete")
				imgui.ToggleButton(array.lang_menu[0] and u8'Прыжочек' or 'Hop', array.show_imgui_hopVeh)
				imgui.TextQuestion('##hop', array.lang_menu[0] and u8"Если функция включена, используйте: B" or "If function enabled then use key: B")
				imgui.ToggleButton(array.lang_menu[0] and u8'Взрыв транспорта' or 'Boom vehicle', array.show_imgui_suicideVeh)
				imgui.TextQuestion('##suicideveh', array.lang_menu[0] and u8"Если функция включена, используйте: F3\nЕсли функция 'Суицид' включена во вкладке 'Персонаж' то произойдет только взрыв транспорта\nЕсли обе функции включены, то произойдет взрыв транспорта, а если Вы не в транспорте, то Вы совершите суицид" or "If function enabled then use key: F3\nIf function 'Suicide' enabled in tab 'Actor' then will be only boom vehicle\nThat is, if both functions are enabled, then you will boom vehicle, and not in transport will suicide")
				imgui.ToggleButton(array.lang_menu[0] and u8'Быстрый выход' or 'Fast exit', array.show_imgui_fastexit)
				imgui.TextQuestion('##fastexit', array.lang_menu[0] and u8"Если функция включена, используйте: N" or "If function enabled then use key: N")
				imgui.ToggleButton(array.lang_menu[0] and u8'Починить колеса' or 'Restore wheels', array.show_imgui_fixWheels)
				imgui.TextQuestion('##repairwheels', array.lang_menu[0] and u8"Если функция включена, используйте: Z+2" or "If function enabled then use keys: Z+2")
				imgui.ToggleButton('Anti-bike fall', array.show_imgui_antiBikeFall)
				imgui.ToggleButton(array.lang_menu[0] and u8'Мега BMX прыжок' or 'Mega BMX jump', array.show_imgui_megajumpBMX)
				imgui.ToggleButton(array.lang_menu[0] and u8'Идеальная езда' or 'Perfect handling', array.show_imgui_perfectHandling)
				imgui.ToggleButton(array.lang_menu[0] and u8'У всего транспорта нитро' or 'All cars have nitro', array.show_imgui_allCarsNitro)
				imgui.ToggleButton(array.lang_menu[0] and u8'Танк мод' or 'Tank mode', array.show_imgui_tankMode)
				imgui.ToggleButton(array.lang_menu[0] and u8'Транспорт отлетает если в него стрельнуть' or 'Vehicle float away when hit', array.show_imgui_carsFloatWhenHit)
				imgui.ToggleButton(array.lang_menu[0] and u8'Езда по воде' or 'Drive on water', array.show_imgui_driveOnWater)
				imgui.ToggleButton(array.lang_menu[0] and u8'Починить транспорт' or 'Restore health', array.show_imgui_restHealthVeh)
				imgui.TextQuestion('##repaircar', array.lang_menu[0] and u8'Если функция включена, используйте: 1' or 'If function enabled then use key: 1')
				imgui.ToggleButton(array.lang_menu[0] and u8'Двигатель включен' or 'Engine on', array.show_imgui_engineOnVeh)
				imgui.ToggleButton(array.lang_menu[0] and u8'Не взрывается при перевороте' or 'Does not explode on coup', array.antiboom_upside)
				imgui.TextQuestion('##antiboom_upside', array.lang_menu[0] and u8'Осторожно!\nБудет ставить Вашему ТС 1000 HP при перевороте\nЕсли играете на RP сервере - напишется об этом администрации' or 'Caution!\nWill put your vehicle 1000 HP when you flip\nIf you play on the RP server, the administration will write about it')
				imgui.ToggleButton(array.lang_menu[0] and u8'Бесконечное здоровье' or 'GM', array.show_imgui_gmVeh)
				imgui.TextQuestion('##gmveh', array.lang_menu[0] and u8'Если функция включена, используйте: Home\nНеобходимо выбрать "Обычный" или(и) "Колеса"' or 'If function enabled then use keys: Home\nYou must select "Default" or(and) "Wheels"')
				imgui.SameLine()
				imgui.Text(fa.ICON_COG)
				if imgui.IsItemClicked() then
					imgui.OpenPopup(array.lang_menu[0] and u8'Настройки GMVeh' or 'Settings GMVeh')
				end
				if imgui.BeginPopup(array.lang_menu[0] and u8'Настройки GMVeh' or 'Settings GMVeh') then
					imgui.ToggleButton(array.lang_menu[0] and u8'Обычный' or 'Default', array.show_imgui_gmVehDefault)
					imgui.ToggleButton(array.lang_menu[0] and u8'Колеса' or 'Wheels', array.show_imgui_gmVehWheels)
					imgui.EndPopup()
				end
                imgui.EndChild()
            elseif act1 == 3 then
                imgui.BeginChild('##weapon', imgui.ImVec2(sw-140, sh-40), true)
				imgui.ToggleButton(array.lang_menu[0] and u8'Бесконечные патроны' or 'Infinity ammo', array.show_imgui_infAmmo)
				imgui.ToggleButton(array.lang_menu[0] and u8'Без перезарядки' or 'No reload', array.show_imgui_noreload)
				imgui.ToggleButton(array.lang_menu[0] and u8'Полное умение' or 'Full skills', array.show_imgui_fullskills)
				imgui.ToggleButton('+C', array.show_imgui_plusC)
				imgui.TextQuestion('##plusC', array.lang_menu[0] and u8'Если функция включена, используйте: R\nТолько для Deagle' or 'If function enabled then use key: R\nOnly for Deagle')
				imgui.ToggleButton('Aim', array.show_imgui_aim)
                imgui.EndChild()
            elseif act1 == 4 then
                imgui.BeginChild('##misc', imgui.ImVec2(sw-140, sh-40), true)
				if imgui.ButtonActivated(act4 == 1, fa.ICON_GLOBE .. (array.lang_menu[0] and u8' Главное' or ' Main')) then act4 = 1 end
				imgui.SameLine()
				if imgui.ButtonActivated(act4 == 2, fa.ICON_LOCATION_ARROW .. (array.lang_menu[0] and u8' Телепорты' or ' Teleports')) then act4 = 2 end
                imgui.Separator()
                if act4 == 1 then
                    imgui.ToggleButton('AirBrake', array.show_imgui_AirBrake)
                    imgui.TextQuestion('##airbrake', array.lang_menu[0] and u8"Если функция включена, используйте: RShift" or "If function enabled then use key: RShift")
					imgui.SameLine()
					imgui.Text(fa.ICON_COG)
					if imgui.IsItemClicked() then
						imgui.OpenPopup(array.lang_menu[0] and u8'Настройки AirBrake' or 'Settings AirBrake')
					end
					if imgui.BeginPopup(array.lang_menu[0] and u8'Настройки AirBrake' or 'Settings AirBrake') then
						imgui.PushItemWidth(250)
						imgui.SliderFloat(array.lang_menu[0] and u8'Скорость' or 'Speed', array.AirBrake_Speed, 0.1, 14.9, '%.1f', 1.5)
						imgui.PopItemWidth()
						imgui.Text(array.lang_menu[0] and u8'Клавиши:' or 'Keys:')
						imgui.SameLine()
						imgui.RadioButtonIntPtr(array.lang_menu[0] and u8'Вверх & Вниз' or 'Up & Down', array.AirBrake_keys, 1)
						imgui.SameLine()
						imgui.RadioButtonIntPtr(array.lang_menu[0] and u8'Пробел & LShift' or 'Space & LShift', array.AirBrake_keys, 2)
						imgui.EndPopup()
					end
                    imgui.ToggleButton(array.lang_menu[0] and u8'Поле зрения' or 'FOV changer', array.show_imgui_FOV)
					imgui.SameLine()
					imgui.Text(fa.ICON_COG)
					if imgui.IsItemClicked() then
						imgui.OpenPopup(array.lang_menu[0] and u8'Настройки FOV' or 'Settings FOV')
					end
					if imgui.BeginPopup(array.lang_menu[0] and u8'Настройки FOV' or 'Settings FOV') then
						imgui.PushItemWidth(250)
						imgui.SliderFloat(array.lang_menu[0] and u8'Значение' or 'Value', array.FOV_value, 70.0, 108.0, '%.f', 0.5)
						imgui.PopItemWidth()
						imgui.EndPopup()
					end
                    imgui.ToggleButton(array.lang_menu[0] and u8'Быстрый телепорт' or 'Blink', array.show_imgui_blink)
                    imgui.TextQuestion('##blink', array.lang_menu[0] and u8"Если функция включена, используйте: X\nВас телепортирует на определенное количество метров вперед" or "If function enabled then use key: X\nYou teleport a certain number of meters ahead")
					imgui.SameLine()
					imgui.Text(fa.ICON_COG)
					if imgui.IsItemClicked() then
						imgui.OpenPopup(array.lang_menu[0] and u8'Настройки Blink' or 'Settings Blink')
					end
					if imgui.BeginPopup(array.lang_menu[0] and u8'Настройки Blink' or 'Settings Blink') then
						imgui.PushItemWidth(250)
						imgui.SliderFloat(array.lang_menu[0] and u8'Дистанция' or 'Distance', array.blink_dist, 1, 150, '%.f', 1.5)
						imgui.PopItemWidth()
						imgui.EndPopup()
					end
                    imgui.ToggleButton('ClickWarp', array.show_imgui_clickwarp)
                    imgui.TextQuestion('##clickwarp', array.lang_menu[0] and u8"Если функция включена, используйте: Колесо мыши" or "If function enabled then use key: Mouse wheels")
                    imgui.ToggleButton('Anti-BHop', array.show_imgui_antibhop)
                    imgui.ToggleButton(array.lang_menu[0] and u8'Быстрая карта' or 'Quick map', array.show_imgui_quickMap)
                    imgui.TextQuestion('##quickmap', array.lang_menu[0] and u8"Если функция включена, используйте: M" or "If function enabled then use key: M")
                    imgui.ToggleButton(array.lang_menu[0] and u8'Исправление чувствительности' or 'Sensetivity fix', array.show_imgui_sensfix)
                    imgui.ToggleButton(array.lang_menu[0] and u8'Перезаход' or 'Reconnect', array.show_imgui_reconnect)
					imgui.TextQuestion('##reconnect', array.lang_menu[0] and u8'Если функция включена, используйте: LSHFIT+0' or 'If function enabled then use key: LSHFIT+0')
					imgui.SameLine()
					imgui.Text(fa.ICON_COG)
					if imgui.IsItemClicked() then
						imgui.OpenPopup(array.lang_menu[0] and u8'Настройки Перезаходж' or 'Settings Reconnect')
					end
					if imgui.BeginPopup(array.lang_menu[0] and u8'Настройки Перезаходж' or 'Settings Reconnect') then
						imgui.PushItemWidth(250)
						imgui.SliderInt(array.lang_menu[0] and u8'Задержка (секунды)' or 'Delay (seconds)', array.recon_delay, 1, 30)
						imgui.PopItemWidth()
						imgui.EndPopup()
					end
                    imgui.ToggleButton(array.lang_menu[0] and u8'Чистрый скриншот' or 'Clear screenshot', array.show_imgui_clrScr)
					imgui.SameLine()
					imgui.Text(fa.ICON_COG)
					if imgui.IsItemClicked() then
						imgui.OpenPopup(array.lang_menu[0] and u8'Настройки clrScr' or 'Settings clrScr')
					end
					if imgui.BeginPopup(array.lang_menu[0] and u8'Настройки clrScr' or 'Settings clrScr') then
						imgui.PushItemWidth(250)
						imgui.SliderInt(array.lang_menu[0] and u8'Задержка' or 'Delay', array.clrScr_delay, 800, 3000)
						imgui.PopItemWidth()
						imgui.EndPopup()
					end
                    imgui.ToggleButton(array.lang_menu[0] and u8'Езда/Ходьба под водой' or 'Drive/Walk under water', array.show_imgui_UnderWater)
                elseif act4 == 2 then
                    for structure, tOrg in pairs(tpList) do
                        if imgui.CollapsingHeader(u8(structure)) then
                            imgui.Columns(3)
                            for orgName, tCoords in pairs(tOrg) do
                                if imgui.Button(u8(orgName), imgui.ImVec2(-1, 20)) then
                                    teleportInterior(PLAYER_PED, tCoords[1], tCoords[2], tCoords[3], tCoords[4])
                                end
                                imgui.NextColumn()
                            end
                            imgui.Columns(1)
                        end
                    end
                else act4 = 1 end
                imgui.EndChild()
            elseif act1 == 5 then
                imgui.BeginChild('##visual', imgui.ImVec2(sw-140, sh-40), true)
				if imgui.ButtonActivated(act5 == 1, fa.ICON_GLOBE .. (array.lang_menu[0] and u8' Главное' or ' Main')) then act5 = 1 end
				imgui.SameLine()
				if imgui.ButtonActivated(act5 == 2, fa.ICON_STREET_VIEW .. (array.lang_menu[0] and u8' Игроки' or ' Players')) then act5 = 2 end
				imgui.SameLine()
				if imgui.ButtonActivated(act5 == 3, fa.ICON_CAR .. (array.lang_menu[0] and u8' Транспорт' or ' Vehicle')) then act5 = 3 end
				imgui.Separator()
				if act5 == 1 then
					imgui.ToggleButton(array.lang_menu[0] and u8'Информационная панель' or 'Information bar', array.infbar)
					imgui.SameLine()
					imgui.Text(fa.ICON_COG)
					if imgui.IsItemClicked() then
						imgui.OpenPopup(array.lang_menu[0] and u8'Настройки Информационная панель' or 'Settings Information bar')
					end
					imgui.SetNextWindowSize(imgui.ImVec2(500, -1))
					if imgui.BeginPopup(array.lang_menu[0] and u8'Настройки Информационная панель' or 'Settings Information bar') then
						imgui.Columns(4)
						imgui.Text(array.lang_menu[0] and u8'Персонаж' or 'Actor')
						imgui.ToggleButton(array.lang_menu[0] and u8'Интерьер' or 'Interior', array.infbar_actor_interior)
						imgui.ToggleButton(array.lang_menu[0] and u8'Координаты##1' or 'Coords##1', array.infbar_actor_coords)
						imgui.ToggleButton('ID##1', array.infbar_actor_pid)
						imgui.ToggleButton(array.lang_menu[0] and u8'Здоровье##1' or 'HP##1', array.infbar_actor_php)
						imgui.ToggleButton(array.lang_menu[0] and u8'Броня##1' or 'Armor##1', array.infbar_actor_pap)
						imgui.ToggleButton(array.lang_menu[0] and u8'Пинг##1' or 'Ping##1', array.infbar_actor_ping)
						imgui.ToggleButton('FPS##1', array.infbar_actor_fps)
						imgui.NextColumn()
						imgui.NewLine()
						imgui.ToggleButton('AirBrake##1', array.infbar_actor_airbrake)
						imgui.ToggleButton('WH##1', array.infbar_actor_wh)
						imgui.ToggleButton('GM##1', array.infbar_actor_gm)
						imgui.ToggleButton(array.lang_menu[0] and u8'Анти-BHop' or 'Anti-BHop', array.infbar_actor_antibhop)
						imgui.ToggleButton('+C', array.infbar_actor_plusc)
						imgui.NextColumn()
						imgui.Text(array.lang_menu[0] and u8'Транспорт' or 'Vehicle')
						imgui.ToggleButton(array.lang_menu[0] and u8'Координаты##2' or 'Coords##2', array.infbar_veh_coords)
						imgui.ToggleButton('ID##2', array.infbar_veh_pid)
						imgui.ToggleButton('VID', array.infbar_veh_vid)
						imgui.ToggleButton(array.lang_menu[0] and u8'Здоровье##2' or 'HP##2', array.infbar_veh_php)
						imgui.ToggleButton(array.lang_menu[0] and u8'Броня##2' or 'Armor##2', array.infbar_veh_pap)
						imgui.ToggleButton(array.lang_menu[0] and u8'ТЗдоровье' or 'VHP', array.infbar_veh_vhp)
						imgui.ToggleButton(array.lang_menu[0] and u8'Пинг##2' or 'Ping##2', array.infbar_veh_ping)
						imgui.ToggleButton('FPS##2', array.infbar_veh_fps)
						imgui.NextColumn()
						imgui.NewLine()
						imgui.ToggleButton('AirBrake##2', array.infbar_veh_airbrake)
						imgui.ToggleButton('WH##2', array.infbar_veh_wh)
						imgui.ToggleButton('GM##2', array.infbar_veh_gm)
						imgui.ToggleButton('VGM', array.infbar_veh_vgm)
						imgui.ToggleButton(array.lang_menu[0] and u8'Двигатель' or 'Engine', array.infbar_veh_engine)
						imgui.EndPopup()
					end
					imgui.ToggleButton(array.lang_menu[0] and u8'Поиск 3D текстов' or 'Search 3D text', array.srch3dtext)
					imgui.ToggleButton(array.lang_menu[0] and u8'Трейсер пуль' or 'Traser bullets', array.traserbull)
					imgui.ToggleButton(array.lang_menu[0] and u8'Уведомления' or 'Notifications', array.notifications)
					imgui.SameLine()
					imgui.Text(fa.ICON_COG)
					if imgui.IsItemClicked() then
						imgui.OpenPopup(array.lang_menu[0] and u8'Настройки Уведомления' or 'Settings Notifications')
					end
					if imgui.BeginPopup(array.lang_menu[0] and u8'Настройки Уведомления' or 'Settings Notifications') then
						imgui.ToggleButton(array.lang_menu[0] and u8'GM персонаж' or 'GM actor', array.NactorGM)
						imgui.ToggleButton(array.lang_menu[0] and u8'GM транспорт' or 'GM vehicle', array.NvehGM)
						imgui.ToggleButton('WH', array.Nwh)
						imgui.TextQuestion('##wh_notif', array.lang_menu[0] and u8'"Name tag"/"Скелет"' or '"Name tag"/"Skeleton"')
						imgui.ToggleButton('AirBrake', array.Nairbrake)
						imgui.ToggleButton('+C', array.NplusC)
						imgui.EndPopup()
					end
				elseif act5 == 2 then
					imgui.ToggleButton(array.lang_menu[0] and u8'По клавише' or 'On key', array.show_imgui_keyWH)
					imgui.TextQuestion('##keywh', array.lang_menu[0] and u8'Если включено, то для включения "Name tag"/"Скелет", используйте: 5' or 'If enabled, then to include "Name tag"/"Skeleton", use: 5')
					imgui.ToggleButton('Name tag', array.show_imgui_nametag)
					imgui.ToggleButton(array.lang_menu[0] and u8'Скелет' or 'Skeleton', array.show_imgui_skeleton)
				elseif act5 == 3 then
					imgui.ToggleButton(array.lang_menu[0] and u8'Только колеса' or 'Only wheels', array.show_imgui_onlyWheels)
					imgui.TextQuestion('##onlywheels', array.lang_menu[0] and u8'Если Вы находитесь в транспорте' or 'If you are in vehicle')
					imgui.ToggleButton(array.lang_menu[0] and u8'Проверка дверей' or 'Check doors', array.show_imgui_doorlocks)
					imgui.SameLine()
					imgui.Text(fa.ICON_COG)
					if imgui.IsItemClicked() then
						imgui.OpenPopup(array.lang_menu[0] and u8'Настройки Проверка дверей' or 'Settings Check doors')
					end
					if imgui.BeginPopup(array.lang_menu[0] and u8'Настройки Проверка дверей' or 'Settings Check doors') then
						imgui.SliderInt(array.lang_menu[0] and u8'Дистанция' or 'Distance', array.distDoorLocks, 5, 200)
						imgui.EndPopup()
					end
				else act5 = 1 end
                imgui.EndChild()
            elseif act1 == 6 then
                imgui.BeginChild('##settings', imgui.ImVec2(sw-140, sh-40), true)
				imgui.TextColoredRGB(array.lang_menu[0] and u8'Включить/Отключить курсор - {0984d2}F11' or 'On/Off cursor - {0984d2}F11')
				imgui.TextColoredRGB(array.lang_menu[0] and u8'{0984d2}Язык:' or '{0984d2}Language:') imgui.SameLine()
				imgui.RadioButtonIntPtr(u8'Русский', array.lang, 1) imgui.SameLine()
				imgui.RadioButtonIntPtr('English', array.lang, 2) imgui.SameLine()
				imgui.RadioButtonIntPtr(array.lang_menu[0] and u8'Пользовательский' or 'Custom', array.lang, 3)
				if array.lang[0] == 3 then
					imgui.SameLine()
					imgui.Text(fa.ICON_COG)
					if imgui.IsItemClicked() then
						imgui.OpenPopup(array.lang_menu[0] and u8'Настройки Пользовательский' or 'Settings Custom')
					end
					if imgui.BeginPopup(array.lang_menu[0] and u8'Настройки Пользовательский' or 'Settings Custom') then
						imgui.ToggleButton(array.lang_menu[0] and u8'Меню' or 'Menu', array.lang_menu)
						imgui.ToggleButton(array.lang_menu[0] and u8'Чат' or 'Chat', array.lang_chat)
						imgui.ToggleButton(array.lang_menu[0] and u8'Диалоги' or 'Dialogs', array.lang_dialogs)
						imgui.ToggleButton(array.lang_menu[0] and u8'Визуалы' or 'Visual', array.lang_visual)
						imgui.Text('* ENG <-> RUS')
						imgui.EndPopup()
					end
				end
				imgui.TextColoredRGB(array.lang_menu[0] and u8'{0984d2}Настройка стилей:' or '{0984d2}Style settings:')
				imgui.SameLine()
				styles = {"Androvira", "Light Blue", "Light Purple", "Gray ~Blue", "Cherry"}
				arr_styles = imgui.new['const char*'][#styles](styles)
				imgui.PushItemWidth(150)
				if imgui.Combo('##Styles', array.comboStyle, arr_styles, #styles) then
					mainIni.menu.iStyle = array.comboStyle[0]
					setInterfaceStyle(mainIni.menu.iStyle)
				end
				imgui.PopItemWidth()
				imgui.TextColoredRGB('{0984d2}Config:')
				imgui.Spacing()
				if imgui.Button(array.lang_menu[0] and u8'Сохранить настройки' or 'Save settings') then
					saveini()
					sampAddChatMessage(tag..(array.lang_chat[0] and 'Настройки {0E8604}успешно{888EA0} сохранены' or 'Settings {0E8604}successfully {888EA0}save'), colors.chat.main)
				end
				imgui.SameLine()
				imgui.ToggleButton(array.lang_menu[0] and u8'Авто-сохранение' or 'Auto-save', array.AutoSave)
				imgui.Spacing()
				if imgui.Button(array.lang_menu[0] and u8'Выгрузка' or 'Unload') then
					thisScript():unload()
				end
				imgui.IntSpacing(3)
				imgui.Text(array.lang_menu[0] and u8'Обратная связь:' or 'FeedBack:')
				imgui.TextColoredRGB('- Telegram: {0984d2}t.me/panseek'); imgui.ClickCopy('t.me/panseek')
				imgui.TextColoredRGB((array.lang_menu[0] and u8'- Тема на Blast.Hack: {0984d2}' or '- Topic on Blast.Hack: {0984d2}')..'blast.hk/threads/66295'); imgui.ClickCopy('blast.hk/threads/66295')
				imgui.TextColoredRGB((array.lang_menu[0] and u8'- Поддержка: {0984d2}' or '- Donate: {0984d2}')..'boosty.to/panseek'); imgui.ClickCopy('boosty.to/panseek')
				imgui.Text(array.lang_menu[0] and u8'* Кликните по тексту для копирования ссылки в буфер обмена' or '* Click on the text to copy the link to the clipboard')
				imgui.IntSpacing(3)
				imgui.ToggleButton(array.lang_menu[0] and u8'Проверка обновлений' or 'Check updates', array.checkupdate)
				imgui.SameLine()
				imgui.Indent(300)
				if imgui.Selectable(array.lang_menu[0] and u8'Список изменений' or 'List updates') then
					listupdate = not listupdate
				end
				imgui.Unindent(300)
				if listupdate then
					imgui.OpenPopup("##listupdate")
					imgui.SetNextWindowSize(imgui.ImVec2(1000, 600), imgui.Cond.FirstUseEver)
					if imgui.BeginPopupModal('##listupdate', false, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize) then
						local wx = imgui.GetWindowWidth()
						imgui.SetCursorPosX(wx / 2)
						if imgui.Button(array.lang_menu[0] and u8'Закрыть##1' or 'Close##1') then
							listupdate = false
						end
						imgui.Text('06.03.2021 - v1.4')
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Все меню переписано на mimgui' or 'All menu rewritten to mimgui'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Меню подверглось изменению, оно стало красивее' or 'The menu has undergone a change, it has become more beautiful'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Убран путь в меню' or 'Removed menu path'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Убраны команды: "/z_authors" и "/z_version"' or 'Removed commands: "/z_authors" and "/z_version"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Переименована команда "/z_fakerepair", теперь она "/z_repair"' or 'The command "/z_fakerepair" has been renamed, now it is "/z_repair"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Добавлены подсвеченые вкладки (вместо старого пути)' or 'Added highlighted tabs (instead of the old path)'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Добавлена задержка для функции "Перезаход" во вкладке "Разное"' or 'Added a delay for the "Restart" function in the "Misc" tab'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Добавлена кастомизация для "Информационная панель" во вкладке "Визуалы"' or 'Added customization for "Information bar" in the "Visual" tab'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Добавлены "Инструменты для разработчиков" во вкладке "Настройки"' or 'Added "Tools for Developers" in the "Settings" tab'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Теперь у функции "AirBrake" во вкладке "Разное" имеется выбор клавиш для управления вверх/вниз' or 'Now the "AirBrake" function in the "Misc" tab has a selection of up/down keys'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Теперь на разных разрешениях экрана будет адекватно смотреться "Информационная панель"' or 'Now the "Information bar" will look adequate at different screen resolutions'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Добавлена функция "Не взрывается при перевороте" во вкладке "Транспорт"' or 'Added the function "Does not explode on coup" in the "Vehicle" tab'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Убрана подвкладка "Обновления" во вкладке "Настройки". Теперь информация об этом находится внизу вкладки "Настройки"' or 'Removed the "Updates" sub-tab in the "Settings" tab. Now information about this is at the bottom of the "Settings" tab'))
							if array.lang_menu[0] then
								imgui.Text(u8'- Убрана подвкладка "Визуалы" во вкладке "Arizona-RP" и функционал перенесен в основную вкладку')
								imgui.Text(u8'- Добавлен "Авто-пинкод" и "Авто-логин" во вкладке "Arizona-RP"')
								imgui.Text(u8'- Добавлено "Контейнеры" к функции "Поиск" во вкладке "Revent-RP"')
								imgui.Text(u8'- Теперь на определенном сервере, будет показываться сервер на который существуют функции, также на других серверах эти функции работать не будут')
							else
								imgui.Text('- Added and deletes more functions for Russian servers')
							end
							imgui.Text('- ' .. (array.lang_menu[0] and u8'На кнопку F12 - Включить/Выключить скрипт' or 'On the F12 button - On/Off the script'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Прочие исправления' or 'Miscellaneous fixes'))
							imgui.NewLine()
						imgui.Text('25.12.2020 - v1.3')
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Добавлены "Уведомления" во вкладку "Визуалы"' or 'Added "Notifications" to the "Visual"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Добавлены телепорты во вкладку "Разное" -> "Телепорты"' or 'Added teleports to the "Misc" -> "Teleports"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Функция "Оружие" -> "+C" теперь на кнопку "R"' or 'Function "Weapon" -> "+C" is now on the button "R"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Добавлена функция "Aim" в "Оружие"' or 'Adder function "Aim" in "Weapon"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'В информационной панеле теперь "NameTag" поменяно на "WH" (Также реагирует и на "Скелет")' or 'In the information panel, now "NameTag" is changed to "WH" (Also reacts to "Skeleton")'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Теперь "Визуалы" -> "WH" можно активировать на "5" (По желанию)' or 'Now "Visual" -> "WH" can be activated to "5" (Optional)'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Добавлена функция "Трейсер пуль" в "Визуалы"' or 'Adder function "Traser bullets" in "Visual"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Теперь "Транспорт" -> "GM" обычный/колеса активируется на "Home"' or 'Now "Vehicle" -> "GM" default/wheel is activated on "Home"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Исправлено автосохранение' or 'Fixed autosave'))
							if array.lang_menu[0] then
								imgui.Text(u8'- Создана вкладка "Arizona-RP"')
								imgui.Text(u8'- Во вкладке "Arizona-RP" создана подвкладка "Визуалы" и "Основное"')
								imgui.Text(u8'- Добавлены функции "Пропуск диалогового окна при ответе администрации на Ваш /report", "Эмуляция лаунчера" и"Быстрый /rep(ort)" в "Arizona-RP" -> "Основное"')
								imgui.Text(u8'- Добавлена функция "Поиск" в "Arizona-RP" -> "Визуалы"')
								imgui.Text(u8'- Добавлена функция "Revent-RP" -> "Исправления чата"')
								imgui.Text(u8'- Добавлена вкладка "Визуалы" для "Revent-RP"')
								imgui.Text(u8'- Добавлена функция "Поиск" в "Revent-RP" -> "Визуалы"')
								imgui.Text(u8'- Добавлена функция "Исправления чата" в "Revent-RP" -> "Основное"')
								imgui.Text(u8'- Убран весь функционал "Admin Tools" и "Helper Tools" для "Revent-RP"')
							else
								imgui.Text('- Added and deletes more functions for Russian servers')
							end
							imgui.NewLine()
						imgui.Text('26.11.2020 - v1.2')
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Поменяно название функции "Оружие"  -> "Бесконечные патроны, без перезарядки" ->  "Бесконечные патроны"' or 'Changed the name of the "Weapon" function -> "Infinite ammo, no reloading" -> "Infinite ammo"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Добавлена "Плавность" в "Транспорт" -> "SpeedHack"' or 'Added "Smooth" to "Vehicle" -> "SpeedHack"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Добавлена функция "Персонаж" -> "Antistun"' or 'Added function "Actor" -> "Antistun"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Добавлена функция "Оружие" -> "+C"' or 'Added function "Weapon" -> "+C"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Добавлена функция "Оружие" -> "Без перезарядки"' or 'Added function "Weapon" -> "No reload"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Добавлена функция "Визуалы" -> "Скелет"' or 'Added function "Visual" -> "Skeleton"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Добавлена функция "Визуалы" -> "Поиск 3D текстов"' or 'Added function "Visual" -> "Search 3D text"'))
							if array.lang_menu[0] then
								imgui.Text(u8'- Добавлена "Revent-RP" -> "Helper tools"')
								imgui.Text(u8'- Добавлены функции в "Revent-RP" -> "Helper Tools", "Хелперский чат" и "Возможные ответы"')
								imgui.Text(u8'- Добавлена функции в "Revent-RP" -> "Admin Tools", "Возможные ответы"')
								imgui.Text(u8'- Добавлена команда /ahelp (Если включено "Revent-RP" -> "Admin Tools" -> "Новые команды")')
							else
								imgui.Text('- Added more functions for Russian servers')
							end
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Добавлен Uptime справа от всех вкладок' or 'Added Uptime to the right of all tabs'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Добавлены несколько стилей ImGui' or 'Added several ImGui styles'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Мелкие исправления' or 'Minor fixes'))
							imgui.NewLine()
						imgui.Text('23.10.2020 - v1.1.1')
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Исправлена кодировка в автообновлении' or 'Fixed encoding in autoupdate'))
							imgui.NewLine()
						imgui.Text('21.10.2020 - v1.1')
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Добавлена функция "Проверка дверей" в "Визуалы" -> "Транспорт"' or 'Added "Check doors" function to "Visuals" -> "Vehicle"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Добавлена смена языка для "Визуалы"' or 'Added language change for "Visuals"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Функция "Оружия" -> "Полное прицеливание" изменило название на "Полное умение"' or 'Function "Weapons" -> "Full aiming" changed name to "Full skill"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Функция "Транспорт" -> "Только колеса" перенесена во вкладку "Визуалы" -> "Транспорт"' or 'The function "Vehicle" -> "Only wheels" moved to the tab "Visuals" -> "Vehicle"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Исправлена функция "Разное" -> "Поле зрение"' or 'Fixed function "Misc" -> "FOV changer"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Исправлена функция "Транспорт" -> "SpeedHack"' or 'Fixed function "Vehicle" -> "SpeedHack"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Исправлена функция "Транспорт" -> "Переворот на колеса"' or 'Fixed function "Vehicle" -> "Flip on wheels"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Исправлено автообновление' or 'Fixed autoupdate'))
							imgui.NewLine()
						imgui.Text('16.10.2020 - v1.0')
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Добавлены функции в "Транспорт": У всего транспорта нитро; Только колеса; Танк мод; Транспорт отлетает если в него стрельнуть' or 'Added functions to "Transport": All vehicles have nitro; Wheels only; Tank mod; Vehicle float when hit'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Добавлены контакты в "Настройки"' or 'Added contacts to "Settings'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Убрана команда /z_at (теперь доступен функционал без данной команды)' or 'Removed the /z_at (functionality without this command is now available)'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Мелкие исправления и доработки' or 'Minor fixes and improvements'))
							imgui.NewLine()
						imgui.Text('13.10.2020 - v0.928')
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Релиз' or 'Release'))
						imgui.SetCursorPosX(wx / 2)
						if imgui.Button(array.lang_menu[0] and u8'Закрыть##2' or 'Close##2') then
							listupdate = false
						end
						imgui.EndPopup()
					end
				end
				if imgui.Button(array.lang_menu[0] and u8'Скачать последнее обновление' or 'Download last update') then
					downloadUrlToFile(updatelink, 'moonloader/zuwi.lua')
					sampAddChatMessage(tag..(array.lang_chat[0] and 'Обновление {0E8604}загружено' or 'Update {0E8604}download'), colors.chat.main)
				end
				imgui.SameLine()
				imgui.Indent(300)
				if imgui.CollapsingHeader(array.lang_menu[0] and u8'Инструменты для разработчиков' or 'Tools for developers') then
					imgui.ToggleButton(array.lang_menu[0] and u8'Информация диалогов в консоли SF' or 'Dialog info in SF console', array.dev_dialogid)
					imgui.ToggleButton(array.lang_menu[0] and u8'Отображать ID Textdraw' or 'Display ID Textdraw', array.dev_textdraw)
					imgui.ToggleButton(array.lang_menu[0] and u8'Информация GameText в консоли SF' or 'GameText info in SF console', array.dev_gametext)
					imgui.ToggleButton(array.lang_menu[0] and u8'Информация анимаций в консоли SF' or  'Animations info in SF console', array.dev_anim)
				end
				imgui.Unindent(300)
                imgui.EndChild()
    
            elseif act1 == 8 then
                imgui.BeginChild('##help', imgui.ImVec2(sw-140, sh-40), true)
				if imgui.CollapsingHeader(array.lang_menu[0] and u8'Команды' or 'Commands') then
					imgui.TextColoredRGB('{0984d2}/z_help {ffffff}- ' .. (array.lang_menu[0] and u8'Помощь по скрипту' or 'Script help'))
					imgui.TextColoredRGB('{0984d2}/z_date {ffffff}- ' .. (array.lang_menu[0] and u8'Сегодняшняя дата' or 'Todays date'))
					imgui.TextColoredRGB('{0984d2}/z_menu {ffffff}- ' .. (array.lang_menu[0] and u8'{008900}Открытие/Закрытие {ffffff}меню' or '{008900}Open/Close {ffffff}menu'))
					imgui.TextColoredRGB('{0984d2}/z_coord {ffffff}- ' .. (array.lang_menu[0] and u8'Отмечает Ваши координаты' or 'You are coords'))
					imgui.TextColoredRGB('{0984d2}/z_getmoney {ffffff}- ' .. (array.lang_menu[0] and u8'Выдает 1.000$ (Визуально)' or 'Give cash 1.000$ (Visual)'))
					imgui.TextColoredRGB('{0984d2}/z_time {ffffff}- ' .. (array.lang_menu[0] and u8'Поменять время' or 'Change time'))
					imgui.TextColoredRGB('{0984d2}/z_weather {ffffff}- ' .. (array.lang_menu[0] and u8'Поменять погоду' or 'Change weather'))
					imgui.TextColoredRGB('{0984d2}/z_setmark {ffffff}- ' .. (array.lang_menu[0] and u8'Поставить метку' or 'Create mark'))
					imgui.TextColoredRGB('{0984d2}/z_tpmark {ffffff}- ' .. (array.lang_menu[0] and u8'Телепортироваться к метке' or 'Teleport to mark'))
					imgui.TextColoredRGB('{0984d2}/z_cc {ffffff}- ' .. (array.lang_menu[0] and u8'Очистка чата' or 'Clear chat'))
					imgui.TextColoredRGB('{0984d2}/z_update {ffffff}- ' .. (array.lang_menu[0] and u8'Обновить скрипт' or 'Update script'))
					imgui.TextColoredRGB('{0984d2}/z_checktime {ffffff}- ' .. (array.lang_menu[0] and u8'Точное время по МСК' or 'Exact time by MSK'))
					imgui.TextColoredRGB('{0984d2}/z_suicide {ffffff}- ' .. (array.lang_menu[0] and u8'Суицид (Если в транспорте, то взрывает транспорт. Если пешком, то убивает Вас)' or 'Suicide (If you are in vehicle, then boom vehicle. If walking, it kills you)'))
					imgui.TextColoredRGB('{0984d2}/z_errors {ffffff}- ' .. (array.lang_menu[0] and u8'Список ошибок' or 'List errors'))
					imgui.TextColoredRGB('{0984d2}/z_cmdsamp {ffffff}- ' .. (array.lang_menu[0] and u8'Список команд SA:MP' or 'List commands SA:MP'))
					imgui.TextColoredRGB('{0984d2}/z_reload {ffffff}- ' .. (array.lang_menu[0] and u8'Перезагружает данный скрипт' or 'Reload this is script'))
					imgui.TextColoredRGB('{0984d2}/z_fps {ffffff}- ' .. (array.lang_menu[0] and u8'Выводит FPS' or 'Displays FPS'))
					if getServer('revent') then
						imgui.TextColoredRGB(u8'{0984d2}/z_togall {ffffff}- {008900}Выключает/Включает {ffffff}все чаты которые возможно (Для Revent-RP)')
						imgui.TextColoredRGB(u8'{0984d2}/z_repair {ffffff}- Чинит Ваш транспорт и пишет, что якобы Вы починились в "починке" (Для Revent-RP)')
					else
						imgui.TextColoredRGB('{0984d2}/z_repair {ffffff}- ' .. (array.lang_menu[0] and u8'Чинит транспорт' or 'Fixed vehicle'))
					end
				end
				if imgui.CollapsingHeader(array.lang_menu[0] and u8'Ошибки' or 'Errors') then
					imgui.TextColoredRGB('{B31A06}#1 {ffffff}- ' .. (array.lang_menu[0] and u8'Ваш игрок мертв/не существует' or 'You player is dead/not playing'))
					imgui.TextColoredRGB('{B31A06}#2 {ffffff}- ' .. (array.lang_menu[0] and u8'Ваш игрок не в транспорте' or 'You are player is not in vehicle'))
					imgui.TextColoredRGB('{B31A06}#3 {ffffff}- ' .. (array.lang_menu[0] and u8'Открыт игровой чат' or 'Open game chat'))
					imgui.TextColoredRGB('{B31A06}#4 {ffffff}- ' .. (array.lang_menu[0] and u8'Открыт SampFuncs чат' or 'Open SampFuncs chat'))
					imgui.TextColoredRGB('{B31A06}#5 {ffffff}- ' .. (array.lang_menu[0] and u8'Открыт диалог' or 'Open dialog'))
					imgui.TextColoredRGB('{B31A06}#6 {ffffff}- ' .. (array.lang_menu[0] and u8'Ваш игрок мертв/не существует или не в транспорте' or 'You are player is dead/not playing or is not in vehicle'))
					imgui.TextColoredRGB('{B31A06}#7 {ffffff}- ' .. (array.lang_menu[0] and u8'У Вас открыт игровой чат/SampFuncs чат/диалог' or 'Open game chat/SampFuncs chat/dialog'))
					imgui.TextColoredRGB('{B31A06}#8 {ffffff}- ' .. (array.lang_menu[0] and u8'Ваш игрок не в транспорте или у Вас открыт игровой чат/SampFuncs чат/диалог' or 'You are player is not in vehicle or ppen game chat/SampFuncs chat/dialog'))
					imgui.TextColoredRGB('{B31A06}#9 {ffffff}- ' .. (array.lang_menu[0] and u8'Ваш игрок мертв/не существует или у Вас открыт игровой чат/SampFuncs чат/диалог' or 'You are player is dead/not playing or ppen game chat/SampFuncs chat/dialog'))
					imgui.TextColoredRGB('{B31A06}#10 {ffffff}- ' .. (array.lang_menu[0] and u8'Транспорт не найден' or 'Vehicle not found'))
					imgui.TextColoredRGB('{B31A06}#11 {ffffff}- ' .. (array.lang_menu[0] and u8'Уже открыт другой диалог' or 'Another open dialog'))
					imgui.TextColoredRGB('{B31A06}#12 {ffffff}- ' .. (array.lang_menu[0] and u8'Время не найдено' or 'Time not found'))
					imgui.TextColoredRGB('{B31A06}#13 {ffffff}- ' .. (array.lang_menu[0] and u8'Погода не найдена' or 'Weather not found'))
					imgui.TextColoredRGB('{B31A06}#14 {ffffff}- ' .. (array.lang_menu[0] and u8'Метка не создана' or 'Mark not create'))
					imgui.TextColoredRGB('{B31A06}#15 {ffffff}- ' .. (array.lang_menu[0] and u8'Вы находитесь в интерьере' or 'You are in the interior'))
					imgui.Separator()
				end
				imgui.TextColoredRGB(array.lang_menu[0] and u8'{008900}Авторство:\n{0984d2}PanSeek {ffffff}- Создатель\n{0984d2}Cosmo {ffffff}& {0984d2}FYP {ffffff}& {0984d2}cover {ffffff}& {0984d2}AppleThe {ffffff}& {0984d2}hnnssy {ffffff}& {0984d2}deddosouru {ffffff}& {0984d2}SR_team {ffffff}& {0984d2}qrlk {ffffff}- Исходный код/Помощь\n{0984d2}Warhhogg {ffffff}& {0984d2}frannya {ffffff}- Спасибо за идеи\n{0984d2}LNQZ {ffffff}- Логотип' or '{008900}Authorship:\n{0984d2}PanSeek {ffffff}- Creator\n{0984d2}Cosmo {ffffff}& {0984d2}FYP {ffffff}& {0984d2}cover {ffffff}& {0984d2}AppleThe {ffffff}& {0984d2}hnnssy {ffffff}& {0984d2}deddosouru {ffffff}& {0984d2}SR_team {ffffff}& {0984d2}qrlk {ffffff}- Source/Helped\n{0984d2}Warhhogg {ffffff}& {0984d2}frannya {ffffff}- Thanks for the ideas\n{0984d2}LNQZ {ffffff}- Logo')
				imgui.TextColoredRGB(array.lang_menu[0] and u8'{008900}А также спасибо всем, кто тестировал скрипт и сообщал о некоторых проблемах/багах' or '{008900}And also thanks to everyone who tested the script and reported some problems/bugs')
                imgui.EndChild()
            
            elseif act1 == 10 then
                imgui.BeginChild('##arizonarp', imgui.ImVec2(sw-140, sh-40), true)
				imgui.PushItemWidth(150)
				imgui.InputText(u8'Авто-логин', array.arz_passacc, sizeof(array.arz_passacc), not showPass1 and imgui.InputTextFlags.Password or 0)
				imgui.SameLine()
				if not showPass1 then if imgui.Button(fa.ICON_EYE..'##1') then showPass1 = not showPass1 end
				else if imgui.Button(fa.ICON_EYE_SLASH..'##1') then showPass1 = not showPass1 end end
				imgui.SameLine()
				if imgui.Button(u8'Очистить ##1') then imgui.StrCopy(array.arz_passacc, '') end
				imgui.InputInt(u8'Пин-код', array.arz_pincode, 0, 0, not showPass2 and imgui.InputTextFlags.Password or 0)
				imgui.PopItemWidth()
				imgui.SameLine(nil, 26)
				if not showPass2 then if imgui.Button(fa.ICON_EYE..'##2') then showPass2 = not showPass2 end
				else if imgui.Button(fa.ICON_EYE_SLASH..'##2') then showPass2 = not showPass2 end end
				imgui.SameLine()
				if imgui.Button(u8'Очистить ##2') then imgui.StrCopy(array.arz_pincode, '') end
				imgui.ToggleButton(u8'Эмуляция лаунчера', array.arz_launcher)
				imgui.ToggleButton(u8'Быстрый /rep(ort)', array.arz_fastreport)
				imgui.TextQuestion('##arz_fastreport', u8'При использовании команды /rep(ort) вызывается диалоговое окно, если посылаете жалобу/вопрос,\nто окно не появляется, а сразу отправляется администрации Ваша жалоба/вопрос\nНапример, /report Как открыть инвентарь? - Отправиться сразу администрации данное сообщение')
				imgui.ToggleButton(u8'Пропуск диалогового окна при ответе администрации на Ваш /report', array.arz_autoskiprep)
				imgui.ToggleButton(u8'Поиск объектов', array.arz_venable)
				imgui.SameLine()
				imgui.Text(fa.ICON_COG)
				if imgui.IsItemClicked() then
					imgui.OpenPopup('Настройки Поиск ARZ')
				end
				imgui.SetNextWindowSize(imgui.ImVec2(-1, -1))
				if imgui.BeginPopup('Настройки Поиск ARZ') then
					imgui.ToggleButton(u8'Рисовать линию', array.arz_vline)
					imgui.Separator()
					imgui.ToggleButton(u8'Оружия', array.arzsearchGuns)
					imgui.ToggleButton(u8'Семена', array.arzsearchSeed)
					imgui.ToggleButton(u8'Олени', array.arzsearchDeer)
					imgui.ToggleButton(u8'Наркотики', array.arzsearchDrugs)
					imgui.ToggleButton(u8'Подарки', array.arzsearchGift)
					imgui.ToggleButton(u8'Клады', array.arzsearchTreasure)
					imgui.ToggleButton(u8'Материалы', array.arzsearchMats)
					imgui.EndPopup()
				end
				imgui.TextQuestion('##arz_venable', u8'Работает в зоне стрима. Рисует дистанцию и наименование поиска')
                imgui.EndChild()
    
            elseif act1 == 9 then
                imgui.BeginChild('##reventrp', imgui.ImVec2(sw-140, sh-40), true)
                if imgui.ButtonActivated(act9 == 1, fa.ICON_WINDOW_MAXIMIZE .. u8' Основное') then act9 = 1 end
                imgui.SameLine()
                if imgui.ButtonActivated(act9 == 3, fa.ICON_LOCATION_ARROW .. u8' Телепорты') then act9 = 2 end
                imgui.Separator()
				if act9 == 1 then
					imgui.ToggleButton(u8'Поиск объектов', array.rv_venable)
					imgui.TextQuestion('##rv_venable', u8'Работает в зоне стрима. Рисует дистанцию и наименование поиска')
					imgui.SameLine()
					imgui.Text(fa.ICON_COG)
					if imgui.IsItemClicked() then
						imgui.OpenPopup('Настройки Поиск RVRP')
					end
					imgui.SetNextWindowSize(imgui.ImVec2(-1, -1))
					if imgui.BeginPopup('Настройки Поиск RVRP') then
						imgui.ToggleButton(u8'Рисовать линию', array.rv_line)
						imgui.Separator()
						imgui.ToggleButton(u8'Трупы', array.rvsearchCorpse)
                        imgui.ToggleButton(u8'Подковы', array.rvsearchHorseshoe)
                        imgui.ToggleButton(u8'Тотемы', array.rvsearchTotems)
						imgui.ToggleButton(u8'Контейнеры', array.rvsearchCont)
						imgui.TextQuestion('##cont', u8'Могут быть не семейные контейнеры')
						imgui.EndPopup()
					end
                    imgui.ToggleButton(u8'Исправление чата', array.rv_fixchat)
					imgui.TextQuestion('##rv_fixchat', u8'БЕТА!\nНа чат теперь более приятно смотреть')
                elseif act9 == 2 then
                    for structure, tOrg in pairs(tpListRVRP) do
						if imgui.CollapsingHeader(u8(structure)) then
							imgui.Columns(3)
							for orgName, tCoords in pairs(tOrg) do
								if imgui.Button(u8(orgName), imgui.ImVec2(-1, 20)) then
									teleportInterior(playerPed, tCoords[1], tCoords[2], tCoords[3], tCoords[4])
								end
								imgui.NextColumn()
							end
							imgui.Columns(1)
						end
					end
                else act9 = 1 end
                imgui.EndChild()
            else
                actEnterInGame = 1
                imgui.BeginChild('0', imgui.ImVec2(sw-140, sh-40), true)
                imgui.Text(u8'Select language/Выберите язык:')
                imgui.SameLine()
                if imgui.Button('English') then langIG[1] = true langIG[2] = false end
                imgui.SameLine()
                if imgui.Button(u8'Русский') then langIG[1] = false langIG[2] = true end
                imgui.Text(langIG[1] and u8(imgIntGameENG[1]) or u8(imgIntGameRUS[1]))
				if imgui.CollapsingHeader(langIG[1] and 'More about tabs' or u8'Подробнее про вкладки') then
					imgui.Text(langIG[1] and u8(imgIntGameENG[2]) or u8(imgIntGameRUS[2]))
					imgui.Separator()
				end
				imgui.Text(langIG[1] and u8(imgIntGameENG[3]) or u8(imgIntGameRUS[3]))
                imgui.EndChild()
            end
        end
        imgui.End()
    end
)

function check_keys()
	if array.lang[0] == 1 then
		array.lang_menu[0], array.lang_chat[0], array.lang_dialogs[0], array.lang_visual[0] = true, true, true, true
	elseif array.lang[0] == 2 then
		array.lang_menu[0], array.lang_chat[0], array.lang_dialogs[0], array.lang_visual[0] = false, false, false, false
	end

	if not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() then

		if isKeyJustPressed(key.VK_F10) then array.main_window_state[0] = not array.main_window_state[0] end
		if isKeyJustPressed(key.VK_F11) then checkfuncs.main.activecursor = not checkfuncs.main.activecursor end

		if isKeyJustPressed(key.VK_RSHIFT) and array.show_imgui_AirBrake[0] then
			checkfuncs.others.AirBrake = not checkfuncs.others.AirBrake
			if checkfuncs.others.AirBrake then
				local posX, posY, posZ = getCharCoordinates(PLAYER_PED)
				airBrakeCoords = {posX, posY, posZ, 0.0, 0.0, getCharHeading(PLAYER_PED)}
			end
			if array.notifications[0] and array.Nairbrake[0] then
				printStringNow(checkfuncs.others.AirBrake and 'AirBrake ~g~ON' or 'AirBrake ~r~OFF', 1000)
			end
		end

		if isKeyJustPressed(key.VK_MBUTTON) and array.show_imgui_clickwarp[0] then
			checkfuncs.others.Clickwarp = not checkfuncs.others.Clickwarp
			if checkfuncs.others.Clickwarp then sampSetCursorMode(2) else sampSetCursorMode(0) end
		end

		if isKeyJustPressed(key.VK_INSERT) and array.show_imgui_gmActor[0] then
			checkfuncs.others.GMactor = not checkfuncs.others.GMactor
			if array.notifications[0] and array.NactorGM[0] then
				printStringNow(checkfuncs.others.GMactor and 'Actor GM ~g~ON' or 'Actor GM ~r~OFF', 1000)
			end
		end

		if isKeyJustPressed(key.VK_R) and array.show_imgui_plusC[0] then
			checkfuncs.others.PlusC = not checkfuncs.others.PlusC
			if array.notifications[0] and array.NplusC[0] then
				printStringNow(checkfuncs.others.PlusC and '+C ~g~ON' or '+C ~r~OFF', 1000)
			end
		end

		if array.show_imgui_gmVeh[0] and isKeyJustPressed(key.VK_HOME) then
			checkfuncs.others.GMveh = not checkfuncs.others.GMveh
			checkfuncs.others.GMWveh = not checkfuncs.others.GMWveh
			if array.notifications[0] and array.NvehGM[0] then
				printStringNow((checkfuncs.others.GMveh or checkfuncs.others.GMWveh) and 'Vehicle GM ~g~ON' or 'Vehicle GM ~r~OFF', 1000)
			end
		end

		if isKeyJustPressed(key.VK_5) and array.show_imgui_keyWH[0] then
			checkfuncs.others.KeyWH = not checkfuncs.others.KeyWH
			if array.notifications[0] and array.Nwh[0] then
				printStringNow(checkfuncs.others.KeyWH and 'WH ~g~ON' or 'WH ~r~OFF', 1000)
			end
		end
	end
end

function main_funcs()
---------------------ACTOR-------------------------
	mem.setint8(0xB7CEE4, (((array.show_imgui_infRun[0] and not isCharInWater(PLAYER_PED)) or (array.show_imgui_infSwim[0] and isCharInWater(PLAYER_PED))) and 1 or 0), false)
	mem.setint8(0x96916E, (array.show_imgui_infOxygen[0] and 1 or 0), false)
	mem.setint8(0x96916C, (array.show_imgui_megajumpActor[0] and 1 or 0), false)

	GMtext = checkfuncs.others.GMactor and '{29C730}GM' or '{B22C2C}GM'
	if array.show_imgui_gmActor[0] then
		if checkfuncs.others.GMactor then
			setCharProofs(PLAYER_PED, true, true, true, true, true)
		else
			setCharProofs(PLAYER_PED, false, false, false, false, false)
		end
	end

	if array.show_imgui_nofall[0] and (isCharPlayingAnim(PLAYER_PED, 'KO_SKID_BACK') or isCharPlayingAnim(PLAYER_PED, 'FALL_COLLAPSE')) then
		clearCharTasksImmediately(PLAYER_PED)
	end

	if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and not isPlayerDead(PLAYER_PED) then
		if array.show_imgui_unfreeze[0] and isKeyJustPressed(key.VK_OEM_2) then
			if isCharInAnyCar(PLAYER_PED) then
				freezeCarPosition(storeCarCharIsInNoSave(PLAYER_PED), false)
			else
				setPlayerControl(PLAYER_HANDLE, true)
				freezeCharPosition(PLAYER_PED, false)
				clearCharTasksImmediately(PLAYER_PED)
			end
			restoreCameraJumpcut()
		end

		if array.show_imgui_suicideActor[0] and isKeyJustPressed(key.VK_F3) then
			if not isCharInAnyCar(PLAYER_PED) then
				setCharHealth(PLAYER_PED, 0)
			end
		end
	end

	if array.show_imgui_antistun[0] then
		local anims = {'DAM_armL_frmBK', 'DAM_armL_frmFT', 'DAM_armL_frmLT', 'DAM_armR_frmBK', 'DAM_armR_frmFT', 'DAM_armR_frmRT', 'DAM_LegL_frmBK', 'DAM_LegL_frmFT', 'DAM_LegL_frmLT', 'DAM_LegR_frmBK', 'DAM_LegR_frmFT', 'DAM_LegR_frmRT', 'DAM_stomach_frmBK', 'DAM_stomach_frmFT', 'DAM_stomach_frmLT', 'DAM_stomach_frmRT'}
		for key, aniname in pairs(anims) do
			if isCharPlayingAnim(PLAYER_PED, aniname) then
				setCharAnimSpeed(PLAYER_PED, aniname, 999)
			end
		end
	end
-----------------VEHICLE--------------------
	samem.require 'CVehicle'
	samem.require 'CTrain'
	local player_veh = samem.cast('CVehicle **', samem.player_vehicle)
	if isCharInAnyCar(PLAYER_PED) and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and not isPlayerDead(PLAYER_PED) then
		if array.show_imgui_flip180[0] and isKeyJustPressed(key.VK_BACK) then
			local veh = player_veh[0]
			if veh ~= samem.nullptr then
				if veh.nVehicleClass == 6 then
					local train = samem.cast('CTrain *', veh)
					train.fTrainSpeed = -train.fTrainSpeed
					return
				end
				local matrix = veh.pMatrix
				matrix.up = -matrix.up
				matrix.right = -matrix.right
				veh.vMoveSpeed = -veh.vMoveSpeed
			end
			markCarAsNoLongerNeeded(veh)
		end

		if array.show_imgui_fastexit[0] and isKeyJustPressed(key.VK_N) then
			local posX, posY, posZ = getCarCoordinates(storeCarCharIsInNoSave(PLAYER_PED))
			warpCharFromCarToCoord(PLAYER_PED, posX, posY, posZ)
		end

		if array.antiboom_upside[0] then
			local veh = storeCarCharIsInNoSave(PLAYER_PED)
			if isCarUpsidedown(veh) then
				setCarHealth(veh, 1000)
			end
		end

		if array.show_imgui_hopVeh[0] and isKeyJustPressed(key.VK_B) then
			local cVecX, cVecY, cVecZ = getCarSpeedVector(storeCarCharIsInNoSave(PLAYER_PED))
			if cVecZ < 7.0 then applyForceToCar(storeCarCharIsInNoSave(PLAYER_PED), 0.0, 0.0, 0.2, 0.0, 0.0, 0.0) end
		end

		if array.show_imgui_flipOnWheels[0] and isKeyJustPressed(key.VK_DELETE) then
			local veh = storeCarCharIsInNoSave(PLAYER_PED)
            local oX, oY, oZ = getOffsetFromCarInWorldCoords(veh, 0.0,  0.0,  0.0)
			setCarCoordinates(veh, oX, oY, oZ)
			markCarAsNoLongerNeeded(veh)
		end

		if isKeyJustPressed(key.VK_F3) then
			if array.show_imgui_suicideVeh[0] then
				local myCar = storeCarCharIsInNoSave(PLAYER_PED)
				setCarHealth(myCar, 0)
				for i = 0, 3 do burstCarTire(myCar, i) end
				markCarAsNoLongerNeeded(myCar)
			else
				sampAddChatMessage(tag..(array.lang_chat[0] and errorRUS[6] or errorENG[6]), colors.chat.main)
			end
		end

		setCharCanBeKnockedOffBike(PLAYER_PED, array.show_imgui_antiBikeFall[0] and true or false)

		VGMtext = (checkfuncs.others.GMveh or checkfuncs.others.GMWveh) and '{29C730}VGM' or '{B22C2C}VGM'
		if array.show_imgui_gmVeh[0] then
			if array.show_imgui_gmVehDefault[0] and checkfuncs.others.GMveh then
				setCarProofs(storeCarCharIsInNoSave(PLAYER_PED), true, true, true, true, true)
			end
			if array.show_imgui_gmVehWheels[0] and checkfuncs.others.GMWveh then
				setCanBurstCarTires(storeCarCharIsInNoSave(PLAYER_PED), false)
			end
		end

		if array.show_imgui_restHealthVeh[0] and isKeyJustPressed(key.VK_1) then
			fixCar(storeCarCharIsInNoSave(PLAYER_PED))
		end

		if array.show_imgui_fixWheels[0] then
			local veh = storeCarCharIsInNoSave(PLAYER_PED)
			if wasKeyPressed(key.VK_2) and wasKeyPressed(key.VK_Z) then
				for i = 0, 3 do fixCarTire(veh, i) end
			end
		end

		if array.show_imgui_engineOnVeh[0] then
			switchCarEngine(storeCarCharIsInNoSave(PLAYER_PED), true)
		end
		EngineText = array.show_imgui_engineOnVeh[0] and (array.lang_visual[0] and '{29C730}Двигатель' or '{29C730}Engine') or (array.lang_visual[0] and '{B22C2C}Двигатель' or '{B22C2C}Engine')

		if array.show_imgui_speedhack[0] and isKeyDown(key.VK_LMENU) then
			if getCarSpeed(storeCarCharIsInNoSave(PLAYER_PED)) * 2.01 <= array.SpeedHackMaxSpeed[0] then
				local cVecX, cVecY, cVecZ = getCarSpeedVector(storeCarCharIsInNoSave(PLAYER_PED))
				local heading = getCarHeading(storeCarCharIsInNoSave(PLAYER_PED))
				local turbo = fps_correction() / array.SpeedHackSmooth[0]
				local xforce, yforce, zforce = turbo, turbo, turbo
				local Sin, Cos = math.sin(-math.rad(heading)), math.cos(-math.rad(heading))
				if cVecX > -0.01 and cVecX < 0.01 then xforce = 0.0 end
				if cVecY > -0.01 and cVecY < 0.01 then yforce = 0.0 end
				if cVecZ < 0 then zforce = -zforce end
				if cVecZ > -2 and cVecZ < 15 then zforce = 0.0 end
				if Sin > 0 and cVecX < 0 then xforce = -xforce end
				if Sin < 0 and cVecX > 0 then xforce = -xforce end
				if Cos > 0 and cVecY < 0 then yforce = -yforce end
				if Cos < 0 and cVecY > 0 then yforce = -yforce end
				applyForceToCar(storeCarCharIsInNoSave(PLAYER_PED), xforce * Sin, yforce * Cos, zforce / 2, 0.0, 0.0, 0.0)
			end
		end
	end

	mem.setint8(0x96914C, (array.show_imgui_perfectHandling[0] and 1 or 0), false)
	mem.setint8(0x969161, (array.show_imgui_megajumpBMX[0] and 1 or 0), false)
	mem.setint8(0x969165, (array.show_imgui_allCarsNitro[0] and 1 or 0), false)
	mem.setint8(0x96914B, (array.show_imgui_onlyWheels[0] and 1 or 0), false)
	mem.setint8(0x969164, (array.show_imgui_tankMode[0] and 1 or 0), false)
	mem.setint8(0x969166, (array.show_imgui_carsFloatWhenHit[0] and 1 or 0), false)
	mem.setint8(0x969152, (array.show_imgui_driveOnWater[0] and not isCharOnAnyBike(PLAYER_PED) and 1 or 0), false)

----------------WEAPONS--------------
	pCtext = array.show_imgui_plusC[0] and checkfuncs.others.PlusC and '{29C730}+C' or '{B22C2C}+C'
	if isCharShooting(PLAYER_PED) then
		mem.setint8(0x969178, (array.show_imgui_infAmmo[0] and 1 or 0), false)
		mem.setint8(0x969179, (array.show_imgui_fullskills[0] and 1 or 0), false)

		if array.show_imgui_noreload[0] then
			local weap = getCurrentCharWeapon(PLAYER_PED)
			local nbs = raknetNewBitStream()
			raknetBitStreamWriteInt32(nbs, weap)
			raknetBitStreamWriteInt32(nbs, 0)
			raknetEmulRpcReceiveBitStream(22, nbs)
			raknetDeleteBitStream(nbs)
		end
	end
----------------MISC-----------------
	mem.setint8(0x6C2759, (array.show_imgui_UnderWater[0] and 1 or 0), false)

	if array.show_imgui_sensfix[0] then
		local asf = mem.read (0xB6EC1C, 4, false)
		local bsf = mem.read (0xB6EC18, 4, false)
		if not asf == bsf then --float
			writeMemory (0xB6EC18, 4, asf, false)
		end
	end

	if array.show_imgui_AirBrake[0] and checkfuncs.others.AirBrake then
		if isCharInAnyCar(PLAYER_PED) then heading = getCarHeading(storeCarCharIsInNoSave(PLAYER_PED))
		else heading = getCharHeading(PLAYER_PED) end
		local camCoordX, camCoordY, camCoordZ = getActiveCameraCoordinates()
		local targetCamX, targetCamY, targetCamZ = getActiveCameraPointAt()
		local angle = getHeadingFromVector2d(targetCamX - camCoordX, targetCamY - camCoordY)
		if isCharInAnyCar(PLAYER_PED) then difference = 0.79 else difference = 1.0 end
		if isKeyDown(key.VK_W) then
			if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
				airBrakeCoords[1] = airBrakeCoords[1] + array.AirBrake_Speed[0] * math.sin(-math.rad(angle))
				airBrakeCoords[2] = airBrakeCoords[2] + array.AirBrake_Speed[0] * math.cos(-math.rad(angle))
				setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - difference)
				if not isCharInAnyCar(PLAYER_PED) then setCharHeading(PLAYER_PED, angle)
				else setCarHeading(storeCarCharIsInNoSave(PLAYER_PED), angle) end
			else setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - 1.0) end
		elseif isKeyDown(key.VK_S) then
			if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
				airBrakeCoords[1] = airBrakeCoords[1] - array.AirBrake_Speed[0] * math.sin(-math.rad(heading))
				airBrakeCoords[2] = airBrakeCoords[2] - array.AirBrake_Speed[0] * math.cos(-math.rad(heading))
				setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - difference)
			else setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - 1.0) end
		end
		if isKeyDown(key.VK_A) then
			if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
				airBrakeCoords[1] = airBrakeCoords[1] - array.AirBrake_Speed[0] * math.sin(-math.rad(heading - 90))
				airBrakeCoords[2] = airBrakeCoords[2] - array.AirBrake_Speed[0] * math.cos(-math.rad(heading - 90))
				setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - difference)
			else setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - 1.0) end
		elseif isKeyDown(key.VK_D) then
			if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
				airBrakeCoords[1] = airBrakeCoords[1] - array.AirBrake_Speed[0] * math.sin(-math.rad(heading + 90))
				airBrakeCoords[2] = airBrakeCoords[2] - array.AirBrake_Speed[0] * math.cos(-math.rad(heading + 90))
				setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - difference)
			else setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - 1.0) end
		end
		if (array.AirBrake_keys[0] == 1 and isKeyDown(key.VK_UP)) or (array.AirBrake_keys[0] == 2 and isKeyDown(key.VK_SPACE)) then
			if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
				airBrakeCoords[3] = airBrakeCoords[3] + array.AirBrake_Speed[0]  / 2.0
				setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - difference)
			else setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - 1.0) end
		end
		if (array.AirBrake_keys[0] == 1 and isKeyDown(key.VK_DOWN)) or (array.AirBrake_keys[0] == 2 and isKeyDown(key.VK_LSHIFT)) and airBrakeCoords[3] > -95.0 then
			if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
				airBrakeCoords[3] = airBrakeCoords[3] - array.AirBrake_Speed[0]  / 2.0
				setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - difference)
			else setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - 1.0) end
		end
		if not isKeyDown(key.VK_W) and not isKeyDown(key.VK_S) and not isKeyDown(key.VK_A) and not isKeyDown(key.VK_D) and (array.AirBrake_keys[0] == 1 and not isKeyDown(key.VK_UP) and not isKeyDown(key.VK_DOWN)) or (array.AirBrake_keys[0] == 2 and not isKeyDown(key.VK_SPACE) and not isKeyDown(key.VK_LSHIFT)) then
			setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - 1.0)
		end
	end

	if array.show_imgui_blink[0] and not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() then
		blinkDist = array.blink_dist[0]
		local camCoordX, camCoordY, camCoordZ = getActiveCameraCoordinates()
		local targetCamX, targetCamY, targetCamZ = getActiveCameraPointAt()
		local angle = getHeadingFromVector2d(targetCamX - camCoordX, targetCamY - camCoordY)
		local posX, posY, posZ = getCharCoordinates(PLAYER_PED)
		blink = {posX, posY, posZ}
		if isCharInAnyCar(PLAYER_PED) then difference = 0.79
		else difference = 1.0 end
		if isKeyJustPressed(key.VK_X) then
			if not isCharInAnyCar(PLAYER_PED) then setCharHeading(PLAYER_PED, angle)
			else setCarHeading(storeCarCharIsInNoSave(PLAYER_PED), angle) end
			blink[1] = blink[1] + array.blink_dist[0] * math.sin(-math.rad(angle))
			blink[2] = blink[2] + array.blink_dist[0] * math.cos(-math.rad(angle))
			setCharCoordinates(PLAYER_PED, blink[1], blink[2], blink[3] - difference)
		end
	end

	if array.show_imgui_clrScr[0] and isKeyJustPressed(key.VK_F8) then
		wait(array.clrScr_delay[0])
		if array.infbar[0] then array.infbar[0] = false array.infbar[0] = true end
		if array.show_imgui_skeleton[0] then array.show_imgui_skeleton[0] = false array.show_imgui_skeleton[0] = true end
		if array.show_imgui_nametag[0] then nameTagOff() nameTagOn() end
        if array.srch3dtext[0] then array.srch3dtext[0] = false array.srch3dtext[0] = true end
		if array.main_window_state[0] then array.main_window_state[0] = false array.main_window_state[0] = true end
		if checkfuncs.others.Clickwarp then checkfuncs.others.Clickwarp = false checkfuncs.others.Clickwarp = true end
	end
--------------------VISUAL-----------------------------
	if isPlayerPlaying(PLAYER_HANDLE) and not isPauseMenuActive() then
		if array.dev_textdraw[0] then
			for a = 0, 2304	do
				if sampTextdrawIsExists(a) then
					x, y = sampTextdrawGetPos(a)
					x1, y1 = convertGameScreenCoordsToWindowScreenCoords(x, y)
					renderFontDrawText(ifont, a, x1, y1, 0xFFFFFFFF)
				end
			end
		end
		if array.srch3dtext[0] then
			local screenW, screenH = getScreenResolution()
			if isPlayerPlaying(PLAYER_HANDLE) then
				local posX, posY, posZ = getCharCoordinates(PLAYER_PED)
				local res, text, color, x, y, z, distance, ignoreWalls--[[, player, vehicle]] = Search3Dtext(posX, posY, posZ, 50.0, "")
				if res then
					renderFontDrawText(ifont, string.format(array.lang_visual[0] and "%s \nДистанция: %.2f" or "%s \nDistance: %.2f", text, distance), screenW / 2 + 600, screenH / 2 + 250, color)
				end
			end
		end

		local oTime = os.time()
		if array.traserbull[0] then
			for i = 1, BulletSync.maxLines do
				if BulletSync[i].enable == true and oTime <= BulletSync[i].time then
					local o, t = BulletSync[i].o, BulletSync[i].t
					if isPointOnScreen(o.x, o.y, o.z) and
					isPointOnScreen(t.x, t.y, t.z) then
						local sx, sy = convert3DCoordsToScreen(o.x, o.y, o.z)
						local fx, fy = convert3DCoordsToScreen(t.x, t.y, t.z)
						renderDrawLine(sx, sy, fx, fy, 1, BulletSync[i].tType == 0 and 0xFFFFFFFF or 0xFFFFC700)
						renderDrawPolygon(fx, fy-1, 3, 3, 4.0, 10, BulletSync[i].tType == 0 and 0xFFFFFFFF or 0xFFFFC700)
					end
				end
			end
		end

		if (array.show_imgui_skeleton[0] and not array.show_imgui_keyWH[0]) or (array.show_imgui_skeleton[0] and array.show_imgui_keyWH[0] and checkfuncs.others.KeyWH) then
			for i = 0, sampGetMaxPlayerId() do
				if sampIsPlayerConnected(i) then
					local result, cped = sampGetCharHandleBySampPlayerId(i)
					local color = sampGetPlayerColor(i)
					local aa, rr, gg, bb = explode_argb(color)
					local color = join_argb(255, rr, gg, bb)
					if result then
						if doesCharExist(cped) and isCharOnScreen(cped) then
							local t = {3, 4, 5, 51, 52, 41, 42, 31, 32, 33, 21, 22, 23, 2}
							for v = 1, #t do
								pos1X, pos1Y, pos1Z = getBodyPartCoordinates(t[v], cped)
								pos2X, pos2Y, pos2Z = getBodyPartCoordinates(t[v] + 1, cped)
								pos1, pos2 = convert3DCoordsToScreen(pos1X, pos1Y, pos1Z)
								pos3, pos4 = convert3DCoordsToScreen(pos2X, pos2Y, pos2Z)
								renderDrawLine(pos1, pos2, pos3, pos4, 1, color)
							end
							for v = 4, 5 do
								pos2X, pos2Y, pos2Z = getBodyPartCoordinates(v * 10 + 1, cped)
								pos3, pos4 = convert3DCoordsToScreen(pos2X, pos2Y, pos2Z)
								renderDrawLine(pos1, pos2, pos3, pos4, 1, color)
							end
							local t = {53, 43, 24, 34, 6}
							for v = 1, #t do
								posX, posY, posZ = getBodyPartCoordinates(t[v], cped)
								pos1, pos2 = convert3DCoordsToScreen(posX, posY, posZ)
							end
						end
					end
				end
			end
		end

		if array.show_imgui_clickwarp[0] and checkfuncs.others.Clickwarp then
			if sampGetCursorMode() == 0 then sampSetCursorMode(2) end
			local sx, sy = getCursorPos()
			local sw, sh = getScreenResolution()
			if sx >= 0 and sy >= 0 and sx < sw and sy < sh then
				local posX, posY, posZ = convertScreenCoordsToWorld3D(sx, sy, 700.0)
				local camX, camY, camZ = getActiveCameraCoordinates()
				local result, colpoint = processLineOfSight(camX, camY, camZ, posX, posY, posZ, true, true, false, true, false, false, false)
				if result and colpoint.entity ~= 0 then
					local normal = colpoint.normal
					local pos = Vector3D(colpoint.pos[1], colpoint.pos[2], colpoint.pos[3]) - (Vector3D(normal[1], normal[2], normal[3]) * 0.1)
					local zOffset = 300
					if normal[3] >= 0.5 then zOffset = 1 end
					local result, colpoint2 = processLineOfSight(pos.x, pos.y, pos.z + zOffset, pos.x, pos.y, pos.z - 0.3,
						true, true, false, true, false, false, false)
					if result then
						pos = Vector3D(colpoint2.pos[1], colpoint2.pos[2], colpoint2.pos[3] + 1)
						local curX, curY, curZ = getCharCoordinates(PLAYER_PED)
						local dist = getDistanceBetweenCoords3d(curX, curY, curZ, pos.x, pos.y, pos.z)
						local hoffs = renderGetFontDrawHeight(clickfont)
						sy = sy - 2
						sx = sx - 2
						renderFontDrawText(clickfont, string.format(array.lang_visual[0] and 'Дистанция: %0.2f' or 'Distance: %0.2f', dist), sx - (renderGetFontDrawTextLength(clickfont, string.format(array.lang_visual[0] and 'Дистанция: %0.2f' or 'Distance: %0.2f', dist)) / 2) + 6, sy - hoffs, 0xFFFFFFFF)
						local tpIntoCar = nil
						if colpoint.entityType == 2 then
							local car = getVehiclePointerHandle(colpoint.entity)
							if doesVehicleExist(car) and (not isCharInAnyCar(PLAYER_PED) or storeCarCharIsInNoSave(PLAYER_PED) ~= car) then
								if isKeyJustPressed(key.VK_LBUTTON) and isKeyJustPressed(key.VK_RBUTTON) then tpIntoCar = car end
								renderFontDrawText(clickfont, array.lang_visual[0] and '{0984d2}Зажмите ПКМ чтобы {FFFFFF}сесть в транспорт' or '{0984d2}Push RBM for {FFFFFF}warp to vehicle', sx - (renderGetFontDrawTextLength(clickfont, array.lang_visual[0] and '{0984d2}Зажмите ПКМ чтобы {FFFFFF}сесть в транспорт' or '{0984d2}Push RBM for {FFFFFF}warp to vehicle') / 2) + 6, sy - hoffs * 2, -1)
							end
						end
						-- createPointMarker(pos.x, pos.y, pos.z)
						if isKeyJustPressed(key.VK_LBUTTON) then
							if tpIntoCar then
								if not jumpIntoCar(tpIntoCar) then
									teleportPlayer(pos.x, pos.y, pos.z)
								end
							else
								if isCharInAnyCar(PLAYER_PED) then
									local norm = Vector3D(colpoint.normal[1], colpoint.normal[2], 0)
									local norm2 = Vector3D(colpoint2.normal[1], colpoint2.normal[2], colpoint2.normal[3])
									rotateCarAroundUpAxis(storeCarCharIsInNoSave(PLAYER_PED), norm2)
									pos = pos - norm * 1.8
									pos.z = pos.z - 1.1
								end
								teleportPlayer(pos.x, pos.y, pos.z)
							end
							-- removePointMarker()
							sampSetCursorMode(0)
							checkfuncs.others.Clickwarp = false
						end
					end
				end
			end
		end
		
		if (array.show_imgui_nametag[0] and not array.show_imgui_keyWH[0]) or (array.show_imgui_nametag[0] and array.show_imgui_keyWH[0] and checkfuncs.others.KeyWH) then
			WHtext = '{29C730}WH'
			nameTagOn()
		else
			WHtext = '{B22C2C}WH'
			nameTagOff()
		end

		if array.show_imgui_doorlocks[0] then
			for k, v in pairs(getAllVehicles()) do
				local x, y, z = getCarCoordinates(v)
				local positionX, positionY, positionZ = getCharCoordinates(PLAYER_PED)
				local DoorsStats = getCarDoorLockStatus(v)
				local wposX, wposY = convert3DCoordsToScreen(x, y, z)
				local strStatus = ''
				if DoorsStats == 0 then
					strStatus = array.lang_visual[0] and '{00FF00}Открыто' or '{00FF00}Open'
				elseif DoorsStats == 2 then
					strStatus = array.lang_visual[0] and '{FF0000}Закрыто' or '{FF0000}Closed'
				end
				local dist = getDistanceBetweenCoords3d(positionX, positionY, positionZ, x, y, z)
				if isPointOnScreen(x, y, z, 0) and dist < array.distDoorLocks[0] then
					renderFontDrawText(ifont, strStatus, wposX, wposY - 20, 0xFF0984D2)
				end
			end
		end

		ABtext = array.show_imgui_AirBrake[0] and checkfuncs.others.AirBrake and '{29C730}AirBrake' or '{B22C2C}AirBrake'
		ABHtext = array.show_imgui_antibhop[0] and '{29C730}Anti-BHop' or '{B22C2C}Anti-BHop'

		if array.infbar[0] then
			local posX, posY = getScreenResolution()
			local playerposX, playerposY, playerposZ = getCharCoordinates(PLAYER_PED)
			local ifps = mem.getfloat(0xB7CB50, 4, false)
			renderDrawBoxWithBorder(-1, posY - ibY, posX + 2, 20, 0x44888EA0, 1, 0xFFF9D82F)
			if not isCharInAnyCar(PLAYER_PED) then
				local playerInterior, playerID, playerHP, playerAP, playerPing  = getPlayerOnFootInfo()
				local textInt = string.format(array.lang_visual[0] and 'Инт:{F9D82F} %d {B31A06}| {888EA0}' or '{888EA0}Int:{F9D82F} %d {B31A06}| {888EA0}', playerInterior)
				local textCoords = string.format('[{F9D82F}%.2f{888EA0}] [{F9D82F}%.2f{888EA0}] [{F9D82F}%.2f{888EA0}] {B31A06}| {888EA0}', playerposX, playerposY, playerposZ)
				local textPid = string.format('{888EA0}ID:{F9D82F} %d {B31A06}| {888EA0}', playerID)
				local textPhp = string.format(array.lang_visual[0] and 'Здоровье:{F9D82F} %d {B31A06}| {888EA0}' or 'Health:{F9D82F} %d {B31A06}| {888EA0}', playerHP)
				local textPap = string.format(array.lang_visual[0] and 'Броня:{F9D82F} %d {B31A06}| {888EA0}' or 'Armor:{F9D82F} %d {B31A06}| {888EA0}', playerAP)
				local textPing = string.format(array.lang_visual[0] and 'Пинг:{F9D82F} %d {B31A06}| {888EA0}' or 'Ping:{F9D82F} %d {B31A06}| {888EA0}', playerPing)
				local textFps = string.format('{888EA0}FPS:{F9D82F} %d', ifps)

				local text = '{888EA0}'..(array.infbar_actor_interior[0] and textInt or '')..(array.infbar_actor_coords[0] and textCoords or '')..(array.infbar_actor_pid[0] and textPid or '')..(array.infbar_actor_php[0] and textPhp or '')..(array.infbar_actor_pap[0] and textPap or '')..(array.infbar_actor_ping[0] and textPing or '')..(array.infbar_actor_fps[0] and textFps or '')
				local screenW, screenH = getScreenResolution()
				local fontlen = renderGetFontDrawTextLength(ifont, text)
				
				renderFontDrawText(ifont, text, screenW / 999, screenH - (ibY-1), 0xFF0984D2)
				local checkFunc = (array.infbar_actor_airbrake[0] and "{888EA0}["..ABtext.."{888EA0}]" or '')..(array.infbar_actor_wh[0] and "{888EA0}["..WHtext.."{888EA0}]" or '')..(array.infbar_actor_gm[0] and "{888EA0}["..GMtext.."{888EA0}]" or '')..(array.infbar_actor_antibhop[0] and "{888EA0}["..ABHtext.."{888EA0}]" or '')..(array.infbar_actor_plusc[0] and "{888EA0}["..pCtext.."{888EA0}]" or '')
				renderFontDrawText(ifont,  checkFunc, screenW / 2, screenH - (ibY-1), 0xFF0984D2)
				
			elseif isCharInAnyCar(PLAYER_PED) then 
				local playerID, vehID, playerHP, playerAP, vehHP, playerPing = getPlayerInCarInfo()
				local playerInterior, playerID, playerHP, playerAP, playerPing  = getPlayerOnFootInfo()
				local textCoords = string.format('[{F9D82F}%.2f{888EA0}] [{F9D82F}%.2f{888EA0}] [{F9D82F}%.2f{888EA0}] {B31A06}| {888EA0}', playerposX, playerposY, playerposZ)
				local textPid = string.format('{888EA0}ID:{F9D82F} %d {B31A06}| {888EA0}', playerID)
				local textVid = string.format('{888EA0}VID:{F9D82F} %d {B31A06}| {888EA0}', vehID)
				local textPhp = string.format(array.lang_visual[0] and 'Здоровье:{F9D82F} %d {B31A06}| {888EA0}' or 'Health:{F9D82F} %d {B31A06}| {888EA0}', playerHP)
				local textPap = string.format(array.lang_visual[0] and 'Броня:{F9D82F} %d {B31A06}| {888EA0}' or 'Armor:{F9D82F} %d {B31A06}| {888EA0}', playerAP)
				local textVhp = string.format(array.lang_visual[0] and 'ТЗдоровье:{F9D82F} %d {B31A06}| {888EA0}' or 'VHealth:{F9D82F} %d {B31A06}| {888EA0}', vehHP)
				local textPing = string.format(array.lang_visual[0] and 'Пинг:{F9D82F} %d {B31A06}| {888EA0}' or 'Ping:{F9D82F} %d {B31A06}| {888EA0}', playerPing)
				local textFps = string.format('{888EA0}FPS:{F9D82F} %d', ifps)
				
				local text = '{888EA0}'..(array.infbar_veh_coords[0] and textCoords or '')..(array.infbar_veh_pid[0] and textPid or '')..(array.infbar_veh_vid[0] and textVid or '')..(array.infbar_veh_php[0] and textPhp or '')..(array.infbar_veh_pap[0] and textPap or '')..(array.infbar_veh_vhp[0] and textVhp or '')..(array.infbar_veh_ping[0] and textPing or '')..(array.infbar_veh_fps[0] and textFps or '')
				local screenW, screenH = getScreenResolution()
				local fontlen = renderGetFontDrawTextLength(ifont, text)
				renderFontDrawText(ifont, text, screenW / 999, screenH - (ibY-1), 0xFF0984D2)
				local checkFunc = (array.infbar_veh_airbrake[0] and "{888EA0}["..ABtext.."{888EA0}]" or '')..(array.infbar_veh_wh[0] and "{888EA0}["..WHtext.."{888EA0}]" or '')..(array.infbar_veh_gm[0] and "{888EA0}["..GMtext.."{888EA0}]" or '')..(array.infbar_veh_vgm[0] and "{888EA0}["..VGMtext.."{888EA0}]" or '')..(array.infbar_veh_engine[0] and "{888EA0}["..EngineText.."{888EA0}]" or '')
				renderFontDrawText(ifont,  checkFunc, screenW / 2, screenH - (ibY-1), 0xFF0984D2)
			end
		end
	end
end

function waitfuncs()
	lua_thread.create(function()
		if array.show_imgui_FOV[0] then
			if isCurrentCharWeapon(PLAYER_PED, 34) and isKeyDown(2) then
				if not checkfuncs.main.locked then
					cameraSetLerpFov(70.0, 70.0, 1000, 1)
					checkfuncs.main.locked = true
				end
			else
				cameraSetLerpFov(array.FOV_value[0], 0.1, 1000, 1)
				checkfuncs.main.locked = false
			end
		end
		--servers
		local rv_tabl = {
			{array.rvsearchCorpse[0], 2907, 'Труп'},
			{array.rvsearchHorseshoe[0], 954, 'Подкова'},
			{array.rvsearchTotems[0], 1276, 'Статуя-тотем'},
			{array.rvsearchCont[0], 2935, 'Контейнер'},
			{array.rvsearchCont[0], 3571, 'Контейнер'},
			{array.rvsearchCont[0], 19321, 'Контейнер'}
		}
		local arz_tabl = {
			{array.arzsearchSeed[0], 859, 'Семена'},
			{array.arzsearchDeer[0], 19315, 'Олень'},
			{array.arzsearchDrugs[0], 1575, 'Наркотики'},
			{array.arzsearchDrugs[0], 1576, 'Наркотики'},
			{array.arzsearchDrugs[0], 1577, 'Наркотики'},
			{array.arzsearchDrugs[0], 1578, 'Наркотики'},
			{array.arzsearchDrugs[0], 1579, 'Наркотики'},
			{array.arzsearchDrugs[0], 1580, 'Наркотики'},
			{array.arzsearchGift[0], 19054, 'Подарок'},
			{array.arzsearchGift[0], 19055, 'Подарок'},
			{array.arzsearchGift[0], 19056, 'Подарок'},
			{array.arzsearchGift[0], 19057, 'Подарок'},
			{array.arzsearchGift[0], 19058, 'Подарок'},
			{array.arzsearchTreasure[0], 2680, 'Клад'},
			{array.arzsearchMats[0], 1279, 'Материалы'},
			{array.arzsearchGuns[0], 346, 'Pistol 9mm'},
			{array.arzsearchGuns[0], 347, 'Silenced pistol'},
			{array.arzsearchGuns[0], 348, 'Deagle'},
			{array.arzsearchGuns[0], 349, 'Shotgun'},
			{array.arzsearchGuns[0], 351, 'Combat Shotgun'},
			{array.arzsearchGuns[0], 352, 'UZI'},
			{array.arzsearchGuns[0], 353, 'MP5'},
			{array.arzsearchGuns[0], 355, 'AK47'},
			{array.arzsearchGuns[0], 356, 'M4'},
			{array.arzsearchGuns[0], 357, 'Rifle'},
			{array.arzsearchGuns[0], 358, 'Sniper'}
		}
		if not isPauseMenuActive() and ((array.arz_venable[0] and getServer('arizona')) or (array.rv_venable[0] and getServer('revent'))) then
			for _, v in pairs(getAllObjects()) do
				if sampGetObjectSampIdByHandle(v) ~= -1 then
					o = sampGetObjectSampIdByHandle(v)
				end
				local model = getObjectModel(v)
				if isObjectOnScreen(v) then
					local model = getObjectModel(v)
					local _, x, y, z = getObjectCoordinates(v)
					local x1, y1 = convert3DCoordsToScreen(x,y,z)
					local x2,y2,z2 = getCharCoordinates(PLAYER_PED)
					local x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
					local distance = string.format("%.0f", getDistanceBetweenCoords3d(x, y, z, x2, y2, z2))
					if array.arz_venable[0] and getServer('arizona') then
						for _, v2 in ipairs(arz_tabl) do
							if v2[2] == model and v2[1] then
								renderFontDrawText(ifont, (v2[3] .. ' ['..distance..']' or ''), x1, y1, -1)
								if array.arz_vline[0] then
									renderDrawLine(x10, y10, x1, y1, 1.0, -1)
								end
							end
						end
					end
					if array.rv_venable[0] and getServer('revent') then
						for _, v3 in ipairs(rv_tabl) do
							if v3[2] == model and v3[1] then
								renderFontDrawText(ifont, (v3[3] .. ' ['..distance..']' or ''), x1, y1, -1)
								if array.rv_line[0] then
									renderDrawLine(x10, y10, x1, y1, 1.0, -1)
								end
							end
						end
					end
				end
			end
		end
		--others
		if isPlayerPlaying(PLAYER_HANDLE) and not isPauseMenuActive() and not sampIsChatInputActive() and not sampIsDialogActive() then
			if array.show_imgui_quickMap[0] then -- quick map (FYP)
				local menuPtr = 0x00BA6748
				if isKeyCheckAvailable() and isKeyDown(key.VK_M) then
					writeMemory(menuPtr + 0x33, 1, 1, false) -- activate menu
					wait(0)
					writeMemory(menuPtr + 0x15C, 1, 1, false) -- textures loaded
					writeMemory(menuPtr + 0x15D, 1, 5, false) -- current menu
					while isKeyDown(key.VK_M) do
						wait(80)
					end
					writeMemory(menuPtr + 0x32, 1, 1, false) -- close menu
				end
			end

			if array.show_imgui_aim[0] then
				if isKeyDown(1) then
					local _, ped = storeClosestEntities(1)
					if ped ~= -1 then
						local x, y, z = getCharCoordinates(ped)
						targetAtCoords(x, y, z)
					end
				end
			end

			if array.show_imgui_reconnect[0] then
				local ip, port = sampGetCurrentServerAddress()
				local sname = sampGetCurrentServerName()
				if wasKeyPressed(key.VK_0) and wasKeyPressed(key.VK_LSHIFT) then
					sampAddChatMessage(tag..(array.lang_chat[0] and 'Вы перезаходите на сервер. Зайдете через {F9D82F}'..array.recon_delay[0]..'{888EA0} секунд' or 'You go to the server. Come through {F9D82F}'..array.recon_delay[0]..'{888EA0} seconds'), colors.chat.main)
					sampConnectToServer(nil, nil)
					wait(array.recon_delay[0] * 1000)
					sampConnectToServer(ip, port)
					sampAddChatMessage(tag..(array.lang_chat[0] and 'Вы перезашли на сервер: {F9D82F}' ..sname.. ' {888EA0}IP: {F9D82F}' ..ip.. ':' ..port or 'You are logged on: {F9D82F}' ..sname.. ' {888EA0}IP: {F9D82F}' ..ip.. ':' ..port), colors.chat.main)
				end
			end

			if array.show_imgui_fastsprint[0] and not isCharInAnyCar(PLAYER_PED) then
				if isButtonPressed(PLAYER_HANDLE, 16) then
					setGameKeyState(16, 255)
					wait(5)
					setGameKeyState(16, 0)
				end
			end

			if array.show_imgui_plusC[0] and checkfuncs.others.PlusC then
				gun = getCurrentCharWeapon(PLAYER_PED)
				if isCharShooting(PLAYER_PED) and gun == 24 then
					setCharAnimSpeed(PLAYER_PED, "python_fire", 1.0)
					setGameKeyState(17, 255)
					wait(50)
					setGameKeyState(6, 0)
					setGameKeyState(18, 255)
					setCharAnimSpeed(PLAYER_PED, "python_fire", 1.0)
				end
			end
		end
	end)
end

--events
function sampev.onSendPlayerSync(data)
	if checkfuncs.main.enabled then
		if array.show_imgui_antibhop[0] then
			if data.keysData == 40 then
				data.keysData = 32
			end
		end
	end
end

function sampev.onBulletSync(playerid, data)
	if checkfuncs.main.enabled then
		if array.traserbull[0] then
			if data.target.x == -1 or data.target.y == -1 or data.target.z == -1 then
				return true
			end
			BulletSync.lastId = BulletSync.lastId + 1
			if BulletSync.lastId < 1 or BulletSync.lastId > BulletSync.maxLines then
				BulletSync.lastId = 1
			end
			local id = BulletSync.lastId
			BulletSync[id].enable = true
			BulletSync[id].tType = data.targetType
			BulletSync[id].time = os.time() + 2
			BulletSync[id].o.x, BulletSync[id].o.y, BulletSync[id].o.z = data.origin.x, data.origin.y, data.origin.z
			BulletSync[id].t.x, BulletSync[id].t.y, BulletSync[id].t.z = data.target.x, data.target.y, data.target.z
		end
	end
end

function sampev.onServerMessage(color, text)
	if checkfuncs.main.enabled then
		if array.rv_fixchat[0] and getServer('revent') then
			if text:find(' Такой команды не существует, команды сервера Вы можете просмотреть в {10F441}/help') then
				return {color, '{B31A06}[Ошибка] {FFFFFF}Команды не существует, используйте: {10F441}/help'}
			end
			if not text:find('говорит') and (text:find('Вы не админ') or text:find('Вам не доступна эта функция') or text:find(' Не найдено') or text:find(' Вам недоступно!') or text:find('/madmin') or text:find('/makehelper') or text:find('/jail') or text:find('/kick') or text:find('/goto') or text:find('/getcar') or text:find('/warn') or text:find('/mute') or text:find('/spawn') or text:find('/skick') or text:find('/unjail') or text:find('/sethp') or text:find('Вы не уполномочены использовать эту команду!') or text:find('/freeze') or text:find('/unfreeze') or text:find('Вы не авторизованы для использование этой команды') or text:find('/disarm') or text:find('/mpskin') or text:find('Вы не Админ!') or text:find('/unwarn') or text:find('/agiverank') or text:find('/setarmor') or text:find('/explode') or text:find('/unslot') or text:find('/givegunrad') or text:find('/giveport') or text:find('/givegz') or text:find('У Вас нет прав для исп. данной команды') or text:find(' Доступно с 6 alvl!') or text:find('/asellbiz') or text:find('/asellhouse') or text:find('/setskin') or text:find('/setskinslot') or text:find('/givevip')) then
				return {color, '{B31A06}[Ошибка] {FFFFFF}Не найдена/недоступна данная команда'}
			end
			if not text:find('говорит') and (text:find('Вы не состоите в СМИ!') or text:find('Вы не коп.')) then
				return {color, '{B31A06}[Ошибка] {FFFFFF}Вы не состоите в определенной фракции'}
			end
			if not text:find('говорит') and text:find('AFK:%d+') then
				afkfix = text:gsub('AFK:(%d+)', 'AFK: %1')
				return {color, afkfix}
			end
		end

		if array.arz_fastreport[0] and getServer('arizona') then
			if text:find('Вам необходимо сформулировать свою жалобу корректно!') then 
				report_false = true
			end
		end
	end
end

function sampev.onShowDialog(dialogId, dialogStyle, dialogTitle, okButtonText, cancelButtonText, dialogText)
	if checkfuncs.main.enabled then
		if getServer('arizona') then
			if dialogId == 2 and str(array.arz_passacc) ~= '' then
				sampSendDialogResponse(2, 1, -1, str(array.arz_passacc))
				return false
			end
			if dialogId == 991 and array.arz_pincode[0] ~= '' then
				sampSendDialogResponse(991, 1, -1, array.arz_pincode[0])
				return false
			end
			if array.arz_autoskiprep[0] and dialogId == 1333 or dialogId == 1332 then
				sampSendDialogResponse(dialogId, 1, -1)
				return false
			end
			if array.arz_fastreport[0] and dialogId == 32 and report_false then
				report_false = false 
				return false
			end
		end
		if array.dev_dialogid[0] then
			print('[DIALOG] ID: '..dialogId..' | Style: '..dialogStyle..' | Title: '..dialogTitle)
		end
	end
end

function sampev.onApplyPlayerAnimation(playerId, animLib, animName, loop, lockX, lockY, freeze, time)
	if checkfuncs.main.enabled then
		if array.dev_anim[0] then
			print('[ANIMATIONS] Player ID: '..playerId..' | Lib: '..animLib..' | Name: '..animName)
		end
	end
end

function sampev.onSendClientJoin(version, mode, nickname, response, authKey, client, unk)
	if array.arz_launcher[0] then
		client = 'Arizona PC'
		return {version, mode, nickname, response, authKey, client, unk}
	end
end

function sampev.onDisplayGameText(style, time, text)
	if checkfuncs.main.enabled then
		if array.dev_gametext[0] then
			print('[GAMETEXT] Style: '..style..' | Time: '..time..' | Text: '..text)
		end
	end
end

--commands
function cmd_update()
		lua_thread.create(function(prefix)
		downloadUrlToFile(updatelink, thisScript().path,
			function(id3, status1, p13, p23)
			if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
				goupdatestatus = true
				lua_thread.create(function() wait(500) thisScript():reload() end)
			end
			if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
				if goupdatestatus == nil then
					sampAddChatMessage(tag..(array.lang_chat[0] and '{B31A06}Не удалось {888EA0}обновиться' or '{B31A06}Failed {888EA0}updating'), colors.chat.main)
					update = false
				end
			end
		end)
	end, prefix)
end

function cmd_time(param)
	local hour = tonumber(param)
	if hour ~= nil and hour >= 0 and hour <= 23 then
		time = hour
		patch_samp_time_set(true)
		sampAddChatMessage(tag..(array.lang_chat[0] and 'Время изменено на {F9D82F}'..time or 'Time change to {F9D82F}'..time), colors.chat.main)
	else
		patch_samp_time_set(false)
		time = nil
		sampAddChatMessage(tag..(array.lang_chat[0] and errorRUS[12] or errorENG[12]), colors.chat.main)
	end
end

function cmd_weather(param)
	local weather = tonumber(param)
	if weather ~= nil and weather >= 0 and weather <= 45 then
		forceWeatherNow(weather)
		sampAddChatMessage(tag..(array.lang_chat[0] and 'Погода изменена на {F9D82F}№'..weather or 'Weather change on {F9D82F}№'..weather), colors.chat.main)
	else
		sampAddChatMessage(tag..(array.lang_chat[0] and errorRUS[13] or errorENG[13]), colors.chat.main)
	end
end

function cmd_suicide()
	if not isPlayerDead(PLAYER_PED) then
		if not isCharInAnyCar(PLAYER_PED) then
			setCharHealth(PLAYER_PED, 0)
		else
			local myCar = storeCarCharIsInNoSave(PLAYER_PED)
			setCarHealth(myCar, -1)
			markCarAsNoLongerNeeded(myCar)
		end
	end
end

function cmd_coord()
	if not isPlayerDead(PLAYER_PED) then
		x, y, z = getCharCoordinates(PLAYER_PED)
		sampAddChatMessage(tag..(array.lang_chat[0] and 'Ваши координаты: X: {F9D82F}' .. math.floor(x) .. '{888EA0} | Y: {F9D82F}' .. math.floor(y) .. '{888EA0} | Z: {F9D82F}' .. math.floor (z) or 'You are coords: X: {F9D82F}' .. math.floor(x) .. '{888EA0} | Y: {F9D82F}' .. math.floor(y) .. '{888EA0} | Z: {F9D82F}' .. math.floor (z)), colors.chat.main)
	else
		sampAddChatMessage(tag..(array.lang_chat[0] and errorRUS[1] or errorENG[1]), colors.chat.main)
	end
end

function cmd_setmark()
	local interiorMark = getActiveInterior(PLAYER_PED)
	intMark = {getActiveInterior(PLAYER_PED)}
	local posX, posY, posZ = getCharCoordinates(PLAYER_PED)
	setmark = {posX, posY, posZ}
	sampAddChatMessage(tag..(array.lang_chat[0] and 'Создана метка по координатам: X: {F9D82F}'..math.floor(setmark[1])..'{888EA0} | Y: {F9D82F}'..math.floor(setmark[2])..'{888EA0} | Z: {F9D82F}'..math.floor(setmark[3]) or 'Create mark by coords: X: {F9D82F}'..math.floor(setmark[1])..'{888EA0} | Y: {F9D82F}'..math.floor(setmark[2])..'{888EA0} | Z: {F9D82F}'..math.floor(setmark[3])), colors.chat.main)
	sampAddChatMessage(tag..(array.lang_chat[0] and 'Интерьер: {F9D82F}'..interiorMark or 'Interior: {F9D82F}'..interiorMark), colors.chat.main)
end

function cmd_tpmark()
	if setmark then
		teleportInterior(PLAYER_PED, setmark[1], setmark[2], setmark[3], intMark[1])
		sampAddChatMessage(tag..(array.lang_chat[0] and 'Вы телепортировались по метке' or 'You are teleport to mark'), colors.chat.main)
	else
		sampAddChatMessage(tag..(array.lang_chat[0] and errorRUS[14] or errorENG[14]), colors.chat.main)
	end
end

function cmd_getmoney()
	if not isPlayerDead(PLAYER_PED) then
		local money = mem.getint32(0xB7CE50)
		mem.setint32(0xB7CE50, money + 1000, false)
		sampAddChatMessage(tag..(array.lang_chat[0] and 'Вам выдано: {F9D82F}1.000$ {888EA0}(Визуально)' or 'Issued to you: {F9D82F}1.000$ {888EA0}(Visual)'), colors.chat.main)
	else
		sampAddChatMessage(tag..(array.lang_chat[0] and errorRUS[1] or errorENG[1]), colors.chat.main)
	end
end

function cmd_errors()
	if not sampIsDialogActive() then
		sampShowDialog(1999, tag..(array.lang_dialogs[0] and 'Список {B31A06}ошибок' or 'List {B31A06}errors'), array.lang_dialogs[0] and errorslistRUS or errorslistENG, array.lang_dialogs[0] and 'Закрыть' or 'Close', '', 0)
	else
		sampAddChatMessage(tag..(array.lang_chat[0] and errorRUS[11] or errorENG[11]), colors.chat.main)
	end
end

function cmd_helpcmdsamp()
	if not sampIsDialogActive() then
		sampShowDialog(2005, tag..(array.lang_dialogs[0] and 'Список команд SA:MP' or 'List commands SA:MP'), array.lang_dialogs[0] and helpcmdsampRUS or helpcmdsampENG, array.lang_dialogs[0] and 'Закрыть' or 'Close', '', 0)
	else
		sampAddChatMessage(tag..(array.lang_chat[0] and errorRUS[11] or errorENG[11]), colors.chat.main)
	end
end
--arizona-rp cmds
function cmd_arz_report(text_rep)
	if array.arz_fastreport[0] and getServer('arizona') then
		if #text_rep == 0 then
			sampSendChat('/report')
		else
			report_false = true
			sampSendChat('/report')
			sampSendDialogResponse(32, 1, -1, text_rep)
		end
	end
end
--revent-rp cmds
function cmd_togall()
	if getServer('revent') then
		lua_thread.create(function()
			sampSendChat('/togfam')
			sampSendChat('/tognews')
			sampSendChat('/togd')
			sampSendChat('/togphone')
			sampSendChat('/togw')
			wait(250)
			sampAddChatMessage(tag..'Всевозможные и доступные для Вас команды {F9D82F}отключены/включены', colors.chat.main)
		end)
	end
end

function cmd_repair()
	if isPlayerPlaying(PLAYER_PED) and not isPlayerDead(PLAYER_PED) and isCharInAnyCar(PLAYER_PED) then
		local myCar = storeCarCharIsInNoSave(PLAYER_PED)
		fixCar(myCar)
		markCarAsNoLongerNeeded(myCar)
		if getServer('revent') then sampAddChatMessage(' Вы починили транспорт!', 16113331)
		else printStringNow('Fixed vehicle ~g~1000 HP') end
	else
		sampAddChatMessage(tag..(array.lang_chat[0] and errorRUS[6] or errorENG[6]), colors.chat.main)
	end
end

function saveini()
	mainIni = {
		actor = {
			infRun = array.show_imgui_infRun[0],
			infSwim = array.show_imgui_infSwim[0],
			infOxygen = array.show_imgui_infOxygen[0],
			suicide = array.show_imgui_suicideActor[0],
			megaJump = array.show_imgui_megajumpActor[0],
			fastSprint = array.show_imgui_fastsprint[0],
			unfreeze = array.show_imgui_unfreeze[0],
			noFall = array.show_imgui_nofall[0],
			GM = array.show_imgui_gmActor[0],
			antiStun = array.show_imgui_antistun[0]
		},
		vehicle = {
			flip180 = array.show_imgui_flip180[0],
			flipOnWheels = array.show_imgui_flipOnWheels[0],
			megaJumpBMX = array.show_imgui_megajumpBMX[0],
			hop = array.show_imgui_hopVeh[0],
			boom = array.show_imgui_suicideVeh[0],
			fastExit = array.show_imgui_fastexit[0],
			AntiBikeFall = array.show_imgui_antiBikeFall[0],
			GM = array.show_imgui_gmVeh[0],
			GMDefault = array.show_imgui_gmVehDefault[0],
			GMWheels = array.show_imgui_gmVehWheels[0],
			fixWheels = array.show_imgui_fixWheels[0],
			speedhack = array.show_imgui_speedhack[0],
			speedhackMaxSpeed = array.SpeedHackMaxSpeed[0],
			speedhackSmooth = array.SpeedHackSmooth[0],
			perfectHandling = array.show_imgui_perfectHandling[0],
			allCarsNitro = array.show_imgui_allCarsNitro[0],
			onlyWheels = array.show_imgui_onlyWheels[0],
			tankMode = array.show_imgui_tankMode[0],
			carsFloatWhenHit = array.show_imgui_carsFloatWhenHit[0],
			driveOnWater = array.show_imgui_driveOnWater[0],
			restoreHealth = array.show_imgui_restHealthVeh[0],
			engineOn = array.show_imgui_engineOnVeh[0],
			antiboom_upside = array.antiboom_upside[0]
		},
		weapon = {
			infAmmo = array.show_imgui_infAmmo[0],
			fullSkills = array.show_imgui_fullskills[0],
			plusC = array.show_imgui_plusC[0],
			noReload = array.show_imgui_noreload[0],
			aim = array.show_imgui_aim[0]
		},
		misc = {
			FOV = array.show_imgui_FOV[0],
			FOVvalue = array.FOV_value[0],
			antibhop = array.show_imgui_antibhop[0],
			AirBrake = array.show_imgui_AirBrake[0],
			AirBrakeSpeed = array.AirBrake_Speed[0],
			AirBrakeKeys = array.AirBrake_keys[0],
			quickMap = array.show_imgui_quickMap[0],
			blink = array.show_imgui_blink[0],
			blinkDist = array.blink_dist[0],
			sensfix = array.show_imgui_sensfix[0],
			clearScreenshot = array.show_imgui_clrScr[0],
			clearScreenshotDelay = array.clrScr_delay[0],
			WalkDriveUnderWater = array.show_imgui_UnderWater[0],
			ClickWarp = array.show_imgui_clickwarp[0],
			reconnect = array.show_imgui_reconnect[0],
			reconnect_delay = array.recon_delay[0]
		},
		visual = {
			nameTag = array.show_imgui_nametag[0],
			skeleton = array.show_imgui_skeleton[0],
			keyWH = array.show_imgui_keyWH[0],
			infoBar = array.infbar[0],
			infbar_actor_airbrake = array.infbar_actor_airbrake[0],
			infbar_actor_wh = array.infbar_actor_wh[0],
			infbar_actor_gm = array.infbar_actor_gm[0],
			infbar_actor_antibhop = array.infbar_actor_antibhop[0],
			infbar_actor_plusc = array.infbar_actor_plusc[0],
			infbar_veh_airbrake = array.infbar_veh_airbrake[0],
			infbar_veh_wh = array.infbar_veh_wh[0],
			infbar_veh_gm = array.infbar_veh_gm[0],
			infbar_veh_vgm = array.infbar_veh_vgm[0],
			infbar_veh_engine = array.infbar_veh_engine[0],
			infbar_actor_interior = array.infbar_actor_interior[0],
			infbar_actor_coords = array.infbar_actor_coords[0],
			infbar_actor_pid = array.infbar_actor_pid[0],
			infbar_actor_php = array.infbar_actor_php[0],
			infbar_actor_pap = array.infbar_actor_pap[0],
			infbar_actor_ping = array.infbar_actor_ping[0],
			infbar_actor_fps = array.infbar_actor_fps[0],
			infbar_veh_coords = array.infbar_veh_coords[0],
			infbar_veh_pid = array.infbar_veh_pid[0],
			infbar_veh_vid = array.infbar_veh_vid[0],
			infbar_veh_php = array.infbar_veh_php[0],
			infbar_veh_pap = array.infbar_veh_pap[0],
			infbar_veh_vhp = array.infbar_veh_vhp[0],
			infbar_veh_ping	= array.infbar_veh_ping[0],
			infbar_veh_fps = array.infbar_veh_fps[0],
			doorLocks = array.show_imgui_doorlocks[0],
			distanceDoorLocks = array.distDoorLocks[0],
			search3dText = array.srch3dtext[0],
			traserBullets = array.traserbull[0]
		},
		menu = {
			checkUpdate = array.checkupdate[0],
			language = array.lang[0],
			language_menu = array.lang_menu[0],
			language_chat = array.lang_chat[0],
			language_dialogs = array.lang_dialogs[0],
			language_visual = array.lang_visual[0],
			autoSave = array.AutoSave[0],
			iStyle = array.comboStyle[0]
		},
		notifications = {
			notifications = array.notifications[0],
			NactorGM = array.NactorGM[0],
			NvehGM = array.NvehGM[0],
			NplusC = array.NplusC[0],
			Nairbrake = array.Nairbrake[0],
			Nwh = array.Nwh[0]
		},
		developers = {
			dialogId = array.dev_dialogid[0],
			textdraw = array.dev_textdraw[0],
			gametext = array.dev_gametext[0],
			animations = array.dev_anim[0]
		},
		reventrp = {
			fixchat = array.rv_fixchat[0],
			venable = array.rv_venable[0],
			vline = array.rv_line[0],
			searchCorpse = array.rvsearchCorpse[0],
			searchHorseshoe = array.rvsearchHorseshoe[0],
			searchTotems = array.rvsearchTotems[0],
			searchContainers = array.rvsearchCont[0]
		},
		arizonarp = {
			passAcc = str(array.arz_passacc),
			pincode = array.arz_pincode[0],
			report = array.arz_fastreport[0],
			venable = array.arz_venable[0],
			vline = array.arz_vline[0],
			searchGuns = array.arzsearchGuns[0],
			searchSeed = array.arzsearchSeed[0],
			searchDeer = array.arzsearchDeer[0],
			searchDrugs = array.arzsearchDrugs[0],
			searchGift = array.arzsearchGift[0],
			searchTreasure = array.arzsearchTreasure[0],
			searchMats = array.arzsearchMats[0],
			autoSkipReport = array.arz_autoskiprep[0],
			emulateLauncher = array.arz_launcher[0]
		}
	} inicfg.save(mainIni, 'zuwi.ini')
end

function onScriptTerminate(zuwiScript, quitGame)
	if zuwiScript == thisScript() then
		if array.AutoSave[0] then
			saveini()
            sampAddChatMessage(tag..(array.lang_chat[0] and 'Скрипт аварийно закончил работу. Настройки сохранены' or 'The script crashed. Settings have been saved'), colors.chat.main)
        else
            sampAddChatMessage(tag..(array.lang_chat[0] and 'Скрипт аварийно закончил работу' or 'The script crashed'), colors.chat.main)
		end
	end
end

--others imgui
function imgui.TextQuestion(...)
	imgui.SameLine()
	imgui.TextDisabled('(?)')
	local id = imgui.GetCursorPos()
	imgui.Hint(...)
end

function imgui.TextColoredRGB(text, shadow, wrapped)
	local style = imgui.GetStyle()
	local colors = style.Colors

	local designText = function(text)
		local pos = imgui.GetCursorPos()
		for i = 1, 1 do
			imgui.SetCursorPos(imgui.ImVec2(pos.x + i, pos.y))
			imgui.TextColored(imgui.ImVec4(0, 0, 0, 1), text)
			imgui.SetCursorPos(imgui.ImVec2(pos.x - i, pos.y))
			imgui.TextColored(imgui.ImVec4(0, 0, 0, 1), text)
			imgui.SetCursorPos(imgui.ImVec2(pos.x, pos.y + i))
			imgui.TextColored(imgui.ImVec4(0, 0, 0, 1), text)
			imgui.SetCursorPos(imgui.ImVec2(pos.x, pos.y - i))
			imgui.TextColored(imgui.ImVec4(0, 0, 0, 1), text)
		end
		imgui.SetCursorPos(pos)
	end

	text = text:gsub('{(%x%x%x%x%x%x)}', '{%1FF}')
	local render_func = wrapped and imgui_text_wrapped or function(clr, text)
		if clr then imgui.PushStyleColor(ffi.C.ImGuiCol_Text, clr) end
		if shadow then designText(text) end
		imgui.TextUnformatted(text)
		if clr then imgui.PopStyleColor() end
	end

	local split = function(str, delim, plain)
		local tokens, pos, i, plain = {}, 1, 1, not (plain == false)
		repeat
			local npos, epos = string.find(str, delim, pos, plain)
			tokens[i] = string.sub(str, pos, npos and npos - 1)
			pos = epos and epos + 1
			i = i + 1
		until not pos
		return tokens
	end

	local color = colors[ffi.C.ImGuiCol_Text]
	for _, w in ipairs(split(text, '\n')) do
		local start = 1
		local a, b = w:find('{........}', start)
		while a do
			local t = w:sub(start, a - 1)
			if #t > 0 then
				render_func(color, t)
				imgui.SameLine(nil, 0)
			end

			local clr = w:sub(a + 1, b - 1)
			if clr:upper() == 'STANDART' then color = colors[ffi.C.ImGuiCol_Text]
			else
				clr = tonumber(clr, 16)
				if clr then
					local r = bit.band(bit.rshift(clr, 24), 0xFF)
					local g = bit.band(bit.rshift(clr, 16), 0xFF)
					local b = bit.band(bit.rshift(clr, 8), 0xFF)
					local a = bit.band(clr, 0xFF)
					color = imgui.ImVec4(r / 255, g / 255, b / 255, a / 255)
				end
			end

			start = b + 1
			a, b = w:find('{........}', start)
		end
		imgui.NewLine()
		if #w >= start then
			imgui.SameLine(nil, 0)
			render_func(color, w:sub(start))
		end
	end
end

function imgui.CenterTextColored(clr, text)
	local width = imgui.GetWindowWidth()
	local lenght = imgui.CalcTextSize(text).x

	imgui.SetCursorPosX((width - lenght) / 2)
	imgui.TextColored(clr, text)
end

function imgui.Hint(str_id, hint, delay)
	local hovered = imgui.IsItemHovered()
	local col = imgui.GetStyle().Colors[imgui.Col.ButtonHovered]
	local animTime = 0.2
	local delay = delay or 0.00
	local show = true

	if not allHints then allHints = {} end
	if not allHints[str_id] then
		allHints[str_id] = {
			status = false,
			timer = 0
		}
	end

	if hovered then
		for k, v in pairs(allHints) do
			if k ~= str_id and os.clock() - v.timer <= animTime  then
				show = false
			end
		end
	end

	if show and allHints[str_id].status ~= hovered then
		allHints[str_id].status = hovered
		allHints[str_id].timer = os.clock() + delay
	end

	local showHint = function(text, alpha)
		imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, alpha)
		imgui.PushStyleVarFloat(imgui.StyleVar.WindowRounding, 5)
		imgui.BeginTooltip()
            imgui.TextColored(imgui.ImVec4(col.x, col.y, col.z, 1.00), fa.ICON_INFO_CIRCLE..(array.lang_menu[0] and u8' Подсказка:' or ' Help:'))
	        imgui.PushStyleVarVec2(imgui.StyleVar.ItemSpacing, imgui.ImVec2(0, 0))
	        imgui.TextColoredRGB(text, false, true)
	        imgui.PopStyleVar()
        imgui.EndTooltip()
        imgui.PopStyleVar(2)
	end

	if show then
		local btw = os.clock() - allHints[str_id].timer
		if btw <= animTime then
			local s = function(f) 
				return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f)
			end
			local alpha = hovered and s(btw / animTime) or s(1.00 - btw / animTime)
			showHint(hint, alpha)
		elseif hovered then
			showHint(hint, 1.00)
		end
	end
end

function imgui.ButtonActivated(activated, ...)
    if activated then
        imgui.PushStyleColor(imgui.Col.Button, imgui.GetStyle().Colors[imgui.Col.CheckMark])
        imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.GetStyle().Colors[imgui.Col.CheckMark])
        imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.GetStyle().Colors[imgui.Col.CheckMark])

            imgui.Button(...)

        imgui.PopStyleColor()
        imgui.PopStyleColor()
        imgui.PopStyleColor()

    else
        return imgui.Button(...)
    end
end

function imgui.ToggleButton(str_id, bool)
    local rBool = false

    if LastActiveTime == nil then
        LastActiveTime = {}
    end
    if LastActive == nil then
        LastActive = {}
    end

    local function ImSaturate(f)
        return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f)
    end
    
    local p = imgui.GetCursorScreenPos()
    local draw_list = imgui.GetWindowDrawList()

    local height = imgui.GetTextLineHeightWithSpacing()
    local width = height * 1.70
    local radius = height * 0.50
    local ANIM_SPEED = 0.15
    local butPos = imgui.GetCursorPos()

    if imgui.InvisibleButton(str_id, imgui.ImVec2(width, height)) then
        bool[0] = not bool[0]
        rBool = true
        LastActiveTime[tostring(str_id)] = os.clock()
        LastActive[tostring(str_id)] = true
    end

    imgui.SetCursorPos(imgui.ImVec2(butPos.x + width + 8, butPos.y + 2.5))
    imgui.Text( str_id:gsub('##.+', '') )

    local t = bool[0] and 1.0 or 0.0

    if LastActive[tostring(str_id)] then
        local time = os.clock() - LastActiveTime[tostring(str_id)]
        if time <= ANIM_SPEED then
            local t_anim = ImSaturate(time / ANIM_SPEED)
            t = bool[0] and t_anim or 1.0 - t_anim
        else
            LastActive[tostring(str_id)] = false
        end
    end

    local col_circle = bool[0] and imgui.ColorConvertFloat4ToU32(imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.ButtonActive])) or imgui.ColorConvertFloat4ToU32(imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.TextDisabled]))
    draw_list:AddRectFilled(p, imgui.ImVec2(p.x + width, p.y + height), imgui.ColorConvertFloat4ToU32(imgui.GetStyle().Colors[imgui.Col.FrameBg]), height * 0.5)
    draw_list:AddCircleFilled(imgui.ImVec2(p.x + radius + t * (width - radius * 2.0), p.y + radius), radius - 1.5, col_circle)

    return rBool
end

function imgui.ClickCopy(text)
	if imgui.IsItemClicked() then
		imgui.LogToClipboard()
		imgui.LogText(text)
		imgui.LogFinish()
	end
end

function imgui.IntSpacing(int)
	for i = 0, int do imgui.Spacing() end
end
--others
function teleportInterior(ped, posX, posY, posZ, int)
	setCharInterior(ped, int)
	setInteriorVisible(int)
	setCharCoordinates(ped, posX, posY, posZ)
end

function getPlayerOnFootInfo()
  local _, playerID = sampGetPlayerIdByCharHandle(PLAYER_PED)
  local playerHP = getCharHealth(PLAYER_PED)
	return getActiveInterior(),
		playerID,
		playerHP,
		getCharArmour(PLAYER_PED),
    sampGetPlayerPing(playerID)    
end

function getPlayerInCarInfo()
  local _, playerID = sampGetPlayerIdByCharHandle(PLAYER_PED)
  local playerHP = getCharHealth(PLAYER_PED)
  local playerCar = storeCarCharIsInNoSave(PLAYER_PED)
  local _, vehId = sampGetVehicleIdByCarHandle(playerCar)
	return playerID,
		vehId,
		playerHP,
    getCharArmour(PLAYER_PED),
    getCarHealth(playerCar),
		sampGetPlayerPing(playerID) 
end

function nameTagOn()
	local pStSet = sampGetServerSettingsPtr()
	-- NTdist = mem.getfloat(pStSet + 39)
	-- NTwalls = mem.getint8(pStSet + 47)
	-- NTshow = mem.getint8(pStSet + 56)
	mem.setfloat(pStSet + 39, 500.0)
	mem.setint8(pStSet + 47, 0)
	mem.setint8(pStSet + 56, 1)
end

function nameTagOff()
	local pStSet = sampGetServerSettingsPtr()
	mem.setfloat(pStSet + 39, 40.0)--onShowPlayerNameTag / NTdist
	mem.setint8(pStSet + 47, 1)
	mem.setint8(pStSet + 56, 1)
end

function onExitScript()
	if array.show_imgui_nametag[0] then nameTagOff() end
end

function patch_samp_time_set(enable)
	if enable and default == nil then
		default = readMemory(sampGetBase() + 0x9C0A0, 4, true)
		writeMemory(sampGetBase() + 0x9C0A0, 4, 0x000008C2, true)
	elseif enable == false and default ~= nil then
		writeMemory(sampGetBase() + 0x9C0A0, 4, default, true)
		default = nil
	end
end

function GetCoordinates()
    if isCharInAnyCar(PLAYER_PED) then
        local car = storeCarCharIsInNoSave(PLAYER_PED)
        return getCarCoordinates(car)
    else
        return getCharCoordinates(PLAYER_PED)
    end
end

function autoupdate(json_url, prefix, url)
	local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
	if doesFileExist(json) then os.remove(json) end
	downloadUrlToFile(json_url, json, function(id, status, p1, p2)
      	if status == dlstatus.STATUSEX_ENDDOWNLOAD then
			if doesFileExist(json) then
				local f = io.open(json, 'r')
				if f then
					local info = decodeJson(f:read('*a'))
					updatelink = info.updateurl
					updateversion = info.latest
					f:close()
					os.remove(json)
					if updateversion == version_script then	
						sampAddChatMessage(tag..(array.lang_chat[0] and 'Вы используете {0E8604}актуальную {888EA0}версию скрипта' or 'You are using {0E8604}the current {888EA0}version of the script'), colors.chat.main)
					elseif updateversion > version_script then
						sampAddChatMessage(tag..(array.lang_chat[0] and 'Вы используете {B31A06}неактуальную {888EA0}версию скрипта. Для обновления, введите: {F9D82F}/z_update' or 'You are using an {B31A06}irrelevant {888EA0}version of the script. To update, write: {F9D82F}/z_update'), colors.chat.main)
					elseif updateversion < version_script then
						sampAddChatMessage(tag..(array.lang_chat[0] and 'Вы используете{F9D82F} тестовую {888EA0}версию скрипта' or 'You are using {F9D82F}testing {888EA0}version of the script'), colors.chat.main)
					else
						update = false
					end
				end
			else
				sampAddChatMessage(tag..(array.lang_chat[0] and '{B31A06}Не удалось {888EA0}проверить версию скрипта' or '{B31A06}Failed {888EA0}to check the version of the script'), colors.chat.main)
				update = false
			end
		end
	end)
end

function enableDialog(bool)
    mem.setint32(sampGetDialogInfoPtr()+40, bool and 1 or 0, true)
    sampToggleCursor(bool)
end

function getTime(timezone)
  local https = require 'ssl.https'
  local time = https.request('http://alat.specihost.com/unix-time/')
  return time and tonumber(time:match('^Current Unix Timestamp: <b>(%d+)</b>')) + (timezone or 0) * 60 * 60
end

function WorkInBackground(work)
    if work then -- on
        mem.setuint8(7634870, 1)
        mem.setuint8(7635034, 1)
        mem.fill(7623723, 144, 8)
        mem.fill(5499528, 144, 6)
    else -- off
        mem.setuint8(7634870, 0)
        mem.setuint8(7635034, 0)
        mem.hex2bin('5051FF1500838500', 7623723, 8)
        mem.hex2bin('0F847B010000', 5499528, 6)
    end
end

function rotateCarAroundUpAxis(car, vec)
  local mat = Matrix3X3(getVehicleRotationMatrix(car))
  local rotAxis = Vector3D(mat.up:get())
  vec:normalize()
  rotAxis:normalize()
  local theta = math.acos(rotAxis:dotProduct(vec))
  if theta ~= 0 then
    rotAxis:crossProduct(vec)
    rotAxis:normalize()
    rotAxis:zeroNearZero()
    mat = mat:rotate(rotAxis, -theta)
  end
  setVehicleRotationMatrix(car, mat:get())
end

function readFloatArray(ptr, idx)
  return representIntAsFloat(readMemory(ptr + idx * 4, 4, false))
end

function writeFloatArray(ptr, idx, value)
  writeMemory(ptr + idx * 4, 4, representFloatAsInt(value), false)
end

function getVehicleRotationMatrix(car)
  local entityPtr = getCarPointer(car)
  if entityPtr ~= 0 then
    local mat = readMemory(entityPtr + 0x14, 4, false)
    if mat ~= 0 then
      local rx, ry, rz, fx, fy, fz, ux, uy, uz
      rx = readFloatArray(mat, 0)
      ry = readFloatArray(mat, 1)
      rz = readFloatArray(mat, 2)
      fx = readFloatArray(mat, 4)
      fy = readFloatArray(mat, 5)
      fz = readFloatArray(mat, 6)
      ux = readFloatArray(mat, 8)
      uy = readFloatArray(mat, 9)
      uz = readFloatArray(mat, 10)
      return rx, ry, rz, fx, fy, fz, ux, uy, uz
    end
  end
end

function setVehicleRotationMatrix(car, rx, ry, rz, fx, fy, fz, ux, uy, uz)
  local entityPtr = getCarPointer(car)
  if entityPtr ~= 0 then
    local mat = readMemory(entityPtr + 0x14, 4, false)
    if mat ~= 0 then
      writeFloatArray(mat, 0, rx)
      writeFloatArray(mat, 1, ry)
      writeFloatArray(mat, 2, rz)
      writeFloatArray(mat, 4, fx)
      writeFloatArray(mat, 5, fy)
      writeFloatArray(mat, 6, fz)
      writeFloatArray(mat, 8, ux)
      writeFloatArray(mat, 9, uy)
      writeFloatArray(mat, 10, uz)
    end
  end
end

function createPointMarker(x, y, z)
  pointMarker = createUser3dMarker(x, y, z + 0.3, 4)
end

function removePointMarker()
  if pointMarker then
    removeUser3dMarker(pointMarker)
    pointMarker = nil
  end
end

function displayVehicleName(x, y, gxt)
  x, y = convertWindowScreenCoordsToGameScreenCoords(x, y)
  useRenderCommands(true)
  setTextWrapx(640.0)
  setTextProportional(true)
  setTextJustify(false)
  setTextScale(0.33, 0.8)
  setTextDropshadow(0, 0, 0, 0, 0)
  setTextColour(255, 255, 255, 230)
  setTextEdge(1, 0, 0, 0, 100)
  setTextFont(1)
  displayText(x, y, gxt)
end

function getCarFreeSeat(car)
  if doesCharExist(getDriverOfCar(car)) then
    local maxPassengers = getMaximumNumberOfPassengers(car)
    for i = 0, maxPassengers do
      if isCarPassengerSeatFree(car, i) then return i + 1 end
    end return nil
  else return 0 end
end

function jumpIntoCar(car)
  local seat = getCarFreeSeat(car)
  if not seat then return false end
  if seat == 0 then warpCharIntoCar(PLAYER_PED, car)
  else warpCharIntoCarAsPassenger(PLAYER_PED, car, seat - 1)
  end restoreCameraJumpcut() return true
end

function teleportPlayer(x, y, z)
  if isCharInAnyCar(PLAYER_PED) then setCharCoordinates(PLAYER_PED, x, y, z) end
  setCharCoordinatesDontResetAnim(PLAYER_PED, x, y, z)
end

function setCharCoordinatesDontResetAnim(char, x, y, z)
  local ptr = getCharPointer(char) setEntityCoordinates(ptr, x, y, z)
end

function setEntityCoordinates(entityPtr, x, y, z)
  if entityPtr ~= 0 then
    local matrixPtr = readMemory(entityPtr + 0x14, 4, false)
    if matrixPtr ~= 0 then
      local posPtr = matrixPtr + 0x30
      writeMemory(posPtr + 0, 4, representFloatAsInt(x), false) -- X
      writeMemory(posPtr + 4, 4, representFloatAsInt(y), false) -- Y
      writeMemory(posPtr + 8, 4, representFloatAsInt(z), false) -- Z
    end
  end
end

function isKeyCheckAvailable()
  if not isSampfuncsLoaded() then
    return not isPauseMenuActive()
  end
  local result = not isSampfuncsConsoleActive() and not isPauseMenuActive()
  if isSampLoaded() and isSampAvailable() then
    result = result and not sampIsChatInputActive() and not sampIsDialogActive()
  end
  return result
end

function fps_correction()
	return representIntAsFloat(readMemory(0xB7CB5C, 4, false))
end

function getBodyPartCoordinates(id, handle)
	local pedptr = getCharPointer(handle)
	local vec = ffi.new("float[3]")
	getBonePosition(ffi.cast("void*", pedptr), vec, id, true)
	return vec[0], vec[1], vec[2]
end

function join_argb(a, r, g, b)
	local argb = b  -- b
	argb = bit.bor(argb, bit.lshift(g, 8))  -- g
	argb = bit.bor(argb, bit.lshift(r, 16)) -- r
	argb = bit.bor(argb, bit.lshift(a, 24)) -- a
	return argb
end
  
function explode_argb(argb)
	local a = bit.band(bit.rshift(argb, 24), 0xFF)
	local r = bit.band(bit.rshift(argb, 16), 0xFF)
	local g = bit.band(bit.rshift(argb, 8), 0xFF)
	local b = bit.band(argb, 0xFF)
	return a, r, g, b
end

function Search3Dtext(x, y, z, radius, patern)
    local text = ""
    local color = 0
    local posX = 0.0
    local posY = 0.0
    local posZ = 0.0
    local distance = 0.0
    local ignoreWalls = false
    local player = -1
    local vehicle = -1
    local result = false

    for id = 0, 2048 do
        if sampIs3dTextDefined(id) then
            local text2, color2, posX2, posY2, posZ2, distance2, ignoreWalls2, player2, vehicle2 = sampGet3dTextInfoById(id)
            if getDistanceBetweenCoords3d(x, y, z, posX2, posY2, posZ2) < radius then
                if string.len(patern) ~= 0 then
                    if string.match(text2, patern, 0) ~= nil then result = true end
                else
                    result = true
                end
                if result then
                    text = text2
                    color = color2
                    posX = posX2
                    posY = posY2
                    posZ = posZ2
                    distance = distance2
                    ignoreWalls = ignoreWalls2
                    player = player2
                    vehicle = vehicle2
                    radius = getDistanceBetweenCoords3d(x, y, z, posX, posY, posZ)
                end
            end
        end
    end

    return result, text, color, posX, posY, posZ, distance, ignoreWalls, player, vehicle
end

function targetAtCoords(x, y, z)
    local cx, cy, cz = getActiveCameraCoordinates()

    local vect = {
        fX = cx - x,
        fY = cy - y,
        fZ = cz - z
    }

    local screenAspectRatio = representIntAsFloat(readMemory(0xC3EFA4, 4, false))
    local crosshairOffset = {
        representIntAsFloat(readMemory(0xB6EC10, 4, false)),
        representIntAsFloat(readMemory(0xB6EC14, 4, false))
    }

    -- weird shit
    local mult = math.tan(getCameraFov() * 0.5 * 0.017453292)
    fz = 3.14159265 - math.atan2(1.0, mult * ((0.5 - crosshairOffset[1]) * (2 / screenAspectRatio)))
    fx = 3.14159265 - math.atan2(1.0, mult * 2 * (crosshairOffset[2] - 0.5))

    local camMode = readMemory(0xB6F1A8, 1, false)

    if not (camMode == 53 or camMode == 55) then -- sniper rifle etc.
        fx = 3.14159265 / 2
        fz = 3.14159265 / 2
    end

    local ax = math.atan2(vect.fY, -vect.fX) - 3.14159265 / 2
    local az = math.atan2(math.sqrt(vect.fX * vect.fX + vect.fY * vect.fY), vect.fZ)

    setCameraPositionUnfixed(az - fz, fx - ax)
end

local originalSampRegisterChatCommand = sampRegisterChatCommand
local originalSampUnregisterChatCommand = sampUnregisterChatCommand
function sampRegisterChatCommand(commands, callback)
  if type(commands) == "table" then
    local all_registered = true
    for i, v in ipairs(commands) do
      local temp = originalSampRegisterChatCommand(v, callback)
      all_registered = all_registered and temp
    end
    return all_registered
  else
    return originalSampRegisterChatCommand(commands, callback)
  end
end
function sampUnregisterChatCommand(commands)
  if type(commands) == "table" then
    local all_unregistered = true
    for i, v in ipairs(commands) do
      local temp = originalSampUnregisterChatCommand(v)
      all_unregistered = all_unregistered and temp
    end
    return all_unregistered
  else
    return originalSampUnregisterChatCommand(commands)
  end
end

function getServer(name)
	return sampGetCurrentServerName():lower():match(name)
end