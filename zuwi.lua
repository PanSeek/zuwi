script_name('zuwi')
script_authors('PanSeek')
version_script = '1.1'
script_properties('work-in-pause')

--ToggleButton 51 last
require 'lib.moonloader'
local sf = require 'sampfuncs'
local dlstatus = require('moonloader').download_status
local fa = require 'faIcons'
local imgui = require 'imgui'
local imadd = require 'imgui_addons'
local key = require 'vkeys'
local rkey = require 'rkeys'
local sampev = require 'lib.samp.events'
local samem = require 'SAMemory'
local mem = require 'memory'
local Matrix3X3 = require 'matrix3x3'
local Vector3D = require 'vector3d'
local inicfg = require 'inicfg'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

mainIni = inicfg.load({
	actor = {
		infRun 				= true,
		infSwim 			= true,
		infOxygen 			= true,
		suicide 			= false,
		megaJump 			= false,
		fastSprint 			= false,
		unfreeze 			= false,
		noFall 				= false,
		GM 					= false
	},
	vehicle = {
		flip180 			= false,
		flipOnWheels 		= false,
		megaJumpBMX			= false,
		hop 				= false,
		boom 				= false,
		fastExit 			= false,
		gmWheels 			= false,
		AntiBikeFall 		= false,
		GM 					= false,
		fixWheels 			= false,
		speedhack 			= false,
		speedhackMaxSpeed 	= 100.0,
		perfectHandling 	= false,
		allCarsNitro 		= false,
		onlyWheels 			= false,
		tankMode			= false,
		carsFloatWhenHit	= false,
		driveOnWater 		= false,
		restoreHealth 		= false,
		engineOn 			= false
	},
	weapon = {
		infAmmo 			= false,
		fullSkills			= false
	},
	misc = {
		FOV 				= false,
		FOVvalue 			= 70.0,
		antibhop 			= false,
		AirBrake 			= false,
		AirBrakeSpeed 		= 1.0,
		quickMap 			= false,
		blink 				= false,
		blinkDist 			= 15.0,
		sensfix 			= false,
		clearScreenshot 	= false,
		WalkDriveUnderWater = false,
		ClickWarp 			= false,
		reconnect 			= false
	},
	visual = {
		nameTag 			= false,
		infoBar 			= false,
		doorLocks			= false,
		distanceDoorLocks	= 30
	},
	menu = {
		checkUpdate 		= true,
		language_menu 		= false,
		language_chat 		= false,
		language_dialogs 	= false,
		language_visual		= false,
		autoSave 			= false,
		iStyle 				= 0
	},
	admintools = {
		adminChat 			= false,
		newCMD 				= false,
		shortCMD 			= false
	}
}, 'zuwi.ini')
if not doesFileExist('zuwi.ini') then inicfg.save(mainIni, 'zuwi.ini') end

--ÒÅÃÈ È ÏÐÎ×ÅÅ
local tag = '{F9D82F}zuwi {888EA0}- '
local authorsRUS = [[{B31A06}PanSeek {888EA0}- {F9D82F}Ñîçäàòåëü

{0E8604}Áëàãîäàðíîñòè{888EA0}:
{B31A06}fran9 {888EA0}- {F9D82F}Ïîìîãàë ñ öâåòàìè è ðàñïîëîæåíèåì ìåíþ/AdminTools äëÿ Revent-RP
{B31A06}FBenz {888EA0}- {F9D82F}Ïîìîãàë â íåêîòîðûõ âîïðîñàõ/ñîâåòîâàë
{B31A06}qrlk {888EA0}- {F9D82F}Àâòîîáíîâëåíèå
{B31A06}FYP {888EA0}- {F9D82F}Èñõîäíûé êîä
{B31A06}cover {888EA0}- {F9D82F}Èñõîäíûé êîä

{0E8604}À òàêæå ñïàñèáî âñåì, êòî òåñòèðîâàë ñêðèïò è ñîîáùàë î íåêîòîðûõ ïðîáëåìàõ/áàãàõ]]
local authorsENG = [[{B31A06}PanSeek {888EA0}- {F9D82F}Creator

{0E8604}Thanks{888EA0}:
{B31A06}fran9 {888EA0}- {F9D82F}Helped with colors and location menu/AdminTools for Revent-RP
{B31A06}FBenz {888EA0}- {F9D82F}Helped in some questions/advised
{B31A06}qrlk {888EA0}- {F9D82F}Autoupdate
{B31A06}FYP {888EA0}- {F9D82F}Source
{B31A06}cover {888EA0}- {F9D82F}Source

{0E8604}And also thanks to everyone who tested the script and reported some problems/bugs]]
imgIntGameRUS = {[[Ïðèâåòñòâóåì Âàñ, äîðîãîé ïîëüçîâàòåëü! Â äàííîì ïðîåêòå åñòü âñïîìîãàòåëüíûå ôóíêöèè äëÿ Âàøåé èãðû â SA-MP.
Ïîìîæåì Âàì ðàçîáðàòüñÿ â zuwi: Âû ñâåðõó âèäèòå âêëàäêè, òàêèå êàê, "Ïåðñîíàæ", "Òðàíñïîðò", "Îðóæèå" è ò.ä.
Ýòè âêëàäêè îòâå÷àþò çà îïðåäåëåííóþ "ñôåðó".]],
[[*Ïåðñîíàæ - ýòà âêëàäêà îòâå÷àåò çà "÷èòû" äëÿ Âàøåãî èãðîêà, äðóãèå çäåñü íå êàñàþòñÿ;
*Òðàíñïîðò - ýòà âêëàäêà îòâå÷àåò çà "÷èòû" äëÿ Âàøåãî òðàíñïîðòà, â êîòîðîì âû íàõîäèòåñü;
*Îðóæèå - ýòà âêëàäêà îòâå÷àåò çà "÷èòû" òîëüêî äëÿ Âàøåãî îðóæèÿ, êîòîðîå ó Âàñ â ðóêàõ;
*Ðàçíîå - ýòà âêëàäêà îòâå÷àåò çà ïðî÷èå ôóíêöèè, îíè ìîãóò áûòü êàê "÷èòû", èëè ÷òîáû, "ãëàçó áûëî ïðèÿòíî".
Òàêæå åñòü ïîäâêëàäêà "Òåëåïîðòû", òàì Âû ñìîæåòå òåëåïîðòèðîâàòüñÿ íà ëþáîå ìåñòî, êîòîðîå åñòü â ñïèñêå;
*Âèçóàëû - ýòà âêëàäêà îòâå÷àåò çà ëþáóþ îòðèñîâêó â zuwi. Òî åñòü âíå èãðîâûå îòðèñîâêè, ê ïðèìåðó,
îòêðûòû ëè òðàíñïîðòíûå ñðåäñòâà èëè æå íåò è òîìó ïîäîáíîå;
*Íàñòðîéêè - ýòà âêëàäêà îòâå÷àåò çà Âàøè íàñòðîéêè zuwi.
Òàì Âû ìîæåòå íàñòðîèòü âñå ÷òî âîçìîæíî, òàêæå îáðàòèòå âíèìàíèÿ íà ïîäâêëàäêè;
*Ïîìîùü - ýòà âêëàäêà îòâå÷àåò çà Âàøó ïîìîùü. Åñëè Âû çàáûëè ÷òî-ëèáî, ëèáî æå íå ïîíèìàåòå ÷òî-òî,
ìîæåòå îòêðûâàòü äàííóþ âêëàäêó è òàì Âû ñêîðåå âñåãî íàéäåòå ðåøåíèå Âàøåé ïðîáëåìû;
*Åùå åñòü âêëàäêè íèæå ïîä âñåìè îñíîâíûìè âêëàäêàìè. Òàì íàõîäÿòñÿ ñåðâåðà.
Âû ìîæåòå íàæàòü íà âêëàäêó Âàøåãî ñåðâåðà è òàì áóäóò íåêîòîðûå ïîëåçíûå ôóíêöèè.]],
[[
Ýòî êðàòêàÿ ïîìîùü. Íàäååìñÿ íà òî, ÷òî Âû ðàçáåðåòåñü â äàííîì òâîðåíèè.
Ïîìíèòå, ÷òî çà "÷èòû" ìîãóò âûäàòü íàêàçàíèÿ, çà êîòîðûå ìû íå íåñåì îòâåòñòâåííîñòè, èñïîëüçóéòå íà ñâîé ÑÒÐÀÕ È ÐÈÑÊ!
Áóäåì î÷åíü áëàãîäàðíû çà ëþáóþ ïîìîùü! Ñ ëþáîâüþ ïðîåêò zuwi :3]]}
imgIntGameENG = {[[Welcome, dear user! In this project there are support functions for your game in SA-MP.
We will help you understand zuwi: You can see tabs from the top, such as, "Actor", "Vehicle", "Weapon", etc.
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
--ERRORS
local errorRUS = {tag..'{B31A06}Îøèáêà #1 {888EA0}({F9D82F}Âàø èãðîê ìåðòâ/íå ñóùåñòâóåò{888EA0})',
tag..'{B31A06}Îøèáêà #2 {888EA0}({F9D82F}Âàø èãðîê íå â òðàíñïîðòå{888EA0})',
tag..'{B31A06}Îøèáêà #3 {888EA0}({F9D82F}Îòêðûò èãðîâîé ÷àò{888EA0})',
tag..'{B31A06}Îøèáêà #4 {888EA0}({F9D82F}Îòêðûò SampFuncs ÷àò{888EA0})',
tag..'{B31A06}Îøèáêà #5 {888EA0}({F9D82F}Îòêðûò äèàëîã{888EA0})',
tag..'{B31A06}Îøèáêà #6 {888EA0}({F9D82F}Âàø èãðîê ìåðòâ/íå ñóùåñòâóåò èëè íå â òðàíñïîðòå{888EA0})',
tag..'{B31A06}Îøèáêà #7 {888EA0}({F9D82F}Ó Âàñ îòêðûò èãðîâîé ÷àò/SampFuncs ÷àò/äèàëîã{888EA0})',
tag..'{B31A06}Îøèáêà #8 {888EA0}({F9D82F}Âàø èãðîê íå â òðàíñïîðòå èëè ó Âàñ îòêðûò èãðîâîé ÷àò/SampFuncs ÷àò/äèàëîã{888EA0})',
tag..'{B31A06}Îøèáêà #9 {888EA0}({F9D82F}Âàø èãðîê ìåðòâ/íå ñóùåñòâóåò èëè ó Âàñ îòêðûò èãðîâîé ÷àò/SampFuncs ÷àò/äèàëîã{888EA0})',
tag..'{B31A06}Îøèáêà #10 {888EA0}({F9D82F}Òðàíñïîðò íå íàéäåí{888EA0})',
tag..'{B31A06}Îøèáêà #11 {888EA0}({F9D82F}Óæå îòêðûò äðóãîé äèàëîã{888EA0})',
tag..'{B31A06}Îøèáêà #12 {888EA0}(Íå íàéäåíî âðåìÿ. Íàïèøèòå: {F9D82F}/z_time 0-23{888EA0})',
tag..'{B31A06}Îøèáêà #13 {888EA0}(Ïîãîäà íå íàéäåíà. Íàïèøèòå: {F9D82F}/z_weather 0-45{888EA0})',
tag..'{B31A06}Îøèáêà #14 {888EA0}({F9D82F}Ìåòêà íå ñîçäàíà{888EA0})',
tag..'{B31A06}Îøèáêà #15 {888EA0}({F9D82F}Âû íàõîäèòåñü â èíòåðüåðå{888EA0})'}
local errorENG = {tag..'{B31A06}Error #1 {888EA0}({F9D82F}You are player is dead/not playing{888EA0})',
tag..'{B31A06}Error #2 {888EA0}({F9D82F}You are player is not in vehicle{888EA0})',
tag..'{B31A06}Error #3 {888EA0}({F9D82F}Open game chat{888EA0})',
tag..'{B31A06}Error #4 {888EA0}({F9D82F}Open SampFuncs chat{888EA0})',
tag..'{B31A06}Error #5 {888EA0}({F9D82F}Open dialog{888EA0})',
tag..'{B31A06}Error #6 {888EA0}({F9D82F}You are player is dead/not playing or is not in vehicle{888EA0})',
tag..'{B31A06}Error #7 {888EA0}({F9D82F}Open game chat/SampFuncs chat/dialog{888EA0})',
tag..'{B31A06}Error #8 {888EA0}({F9D82F}You are player is not in vehicle or open game chat/SampFuncs chat/dialog{888EA0})',
tag..'{B31A06}Error #9 {888EA0}({F9D82F}You are player is dead/not playing or open game chat/SampFuncs chat/dialog{888EA0})',
tag..'{B31A06}Error #10 {888EA0}({F9D82F}Vehicle not found{888EA0})',
tag..'{B31A06}Error #11 {888EA0}({F9D82F}Another dialog open{888EA0})',
tag..'{B31A06}Error #12 {888EA0}(Time not found. Write: {F9D82F}/z_time 0-23{888EA0})',
tag..'{B31A06}Error #13 {888EA0}(Weather not found. Write: {F9D82F}/z_weather 0-45{888EA0})',
tag..'{B31A06}Error #14 {888EA0}({F9D82F}Mark not create{888EA0})',
tag..'{B31A06}Error #15 {888EA0}({F9D82F}You are in the interior{888EA0})'}
--LISTS&DIALOGS
local helpcmdsampRUS = [[{F9D82F}/headmove - {0984d2}Âêëþ÷àåò/Âûêëþ÷àåò {888EA0}ïîâîðîò ãîëîâû
{F9D82F}/timestamp {888EA0}- {0984d2}Âêëþ÷àåò/Âûêëþ÷àåò {888EA0}âðåìÿ âîçëå êàæäîãî ñîîáùåíèÿ
{F9D82F}/pagesize {888EA0}- Óñòàíàâëèâàåò êîëè÷åñòâî ñòðîê â ÷àòå
{F9D82F}/quit (/q) {888EA0}- Áûñòðûé âûõîä èç èãðû
{F9D82F}/save [êîììåíòàðèé] {888EA0}- Ñîõðàíåíèå êîîðäèíàò â {F9D82F}savedposition.txt
{F9D82F}/fpslimit {888EA0}- Óñòàíàâëèâàåò ëèìèò êàäðîâ â ñåêóíäó
{F9D82F}/dl {888EA0}- {0984d2}Âêëþ÷àåò/Âûêëþ÷àåò {888EA0}ïîäðîáíóþ èíôîðìàöèþ î òðàíñïîðòå ïî áëèçîñòè
{F9D82F}/interior {888EA0}- Âûâîäèò â ÷àò òåêóùèé èíòåðüåð
{F9D82F}/rs {888EA0}- Ñîõðàíåíèå êîîðäèíàò â {F9D82F}rawposition.txt
{F9D82F}/mem {888EA0}- Îòîáðàæàåò ñêîëüêî ïàìÿòè èñïîëüçóåò SA-MP]]
local helpcmdsampENG = [[{F9D82F}/headmove - {0984d2}On/Off {888EA0}head rotation
{F9D82F}/timestamp {888EA0}- {0984d2}On/Off {888EA0}time near each message
{F9D82F}/pagesize {888EA0}- Set the number of lines in the chat
{F9D82F}/quit (/q) {888EA0}- Quick exit from the game
{F9D82F}/save [êîììåíòàðèé] {888EA0}- Save coordinates to {F9D82F}savedposition.txt
{F9D82F}/fpslimit {888EA0}- Set the frames per second limit
{F9D82F}/dl {888EA0}- {0984d2}On/Off {888EA0}detailed information about near vehicle
{F9D82F}/interior {888EA0}- Current interior to chat
{F9D82F}/rs {888EA0}- Save coordinates to {F9D82F}rawposition.txt
{F9D82F}/mem {888EA0}- How much memory SA-MP uses]]
local errorslistRUS = [[{B31A06}#1 {888EA0}- {F9D82F}Âàø èãðîê ìåðòâ/íå ñóùåñòâóåò
{B31A06}#2 {888EA0}- {F9D82F}Âàø èãðîê íå â òðàíñïîðòå
{B31A06}#3 {888EA0}- {F9D82F}Îòêðûò èãðîâîé ÷àò
{B31A06}#4 {888EA0}- {F9D82F}Îòêðûò SampFuncs ÷àò
{B31A06}#5 {888EA0}- {F9D82F}Îòêðûò äèàëîã
{B31A06}#6 {888EA0}- {F9D82F}Âàø èãðîê ìåðòâ/íå ñóùåñòâóåò èëè íå â òðàíñïîðòå
{B31A06}#7 {888EA0}- {F9D82F}Ó Âàñ îòêðûò èãðîâîé ÷àò/SampFuncs ÷àò/äèàëîã
{B31A06}#8 {888EA0}- {F9D82F}Âàø èãðîê íå â òðàíñïîðòå èëè ó Âàñ îòêðûò èãðîâîé ÷àò/SampFuncs ÷àò/äèàëîã
{B31A06}#9 {888EA0}- {F9D82F}Âàø èãðîê ìåðòâ/íå ñóùåñòâóåò èëè ó Âàñ îòêðûò èãðîâîé ÷àò/SampFuncs ÷àò/äèàëîã
{B31A06}#10 {888EA0}- {F9D82F}Òðàíñïîðò íå íàéäåí
{B31A06}#11 {888EA0}- {F9D82F}Óæå îòêðûò äðóãîé äèàëîã
{B31A06}#12 {888EA0}- {F9D82F}Âðåìÿ íå íàéäåíî
{B31A06}#13 {888EA0}- {F9D82F}Ïîãîäà íå íàéäåíà
{B31A06}#14 {888EA0}- {F9D82F}Ìåòêà íå ñîçäàíà
{B31A06}#15 {888EA0}- {F9D82F}Âû íàõîäèòåñü â èíòåðüåðå]]
local errorslistENG = [[{B31A06}#1 {888EA0}- {F9D82F}You player is dead/not playing
{B31A06}#2 {888EA0}- {F9D82F}You are player is not in vehicle
{B31A06}#3 {888EA0}- {F9D82F}Open game chat
{B31A06}#4 {888EA0}- {F9D82F}Open SampFuncs chat
{B31A06}#5 {888EA0}- {F9D82F}Open dialog
{B31A06}#6 {888EA0}- {F9D82F}You are player is dead/not playing or is not in vehicle
{B31A06}#7 {888EA0}- {F9D82F}Open game chat/SampFuncs chat/dialog
{B31A06}#8 {888EA0}- {F9D82F}You are player is not in vehicle or ppen game chat/SampFuncs chat/dialog
{B31A06}#9 {888EA0}- {F9D82F}You are player is dead/not playing or ppen game chat/SampFuncs chat/dialog
{B31A06}#10 {888EA0}- {F9D82F}Vehicle not found
{B31A06}#11 {888EA0}- {F9D82F}Another open dialog
{B31A06}#12 {888EA0}- {F9D82F}Time not found
{B31A06}#13 {888EA0}- {F9D82F}Weather not found
{B31A06}#14 {888EA0}- {F9D82F}Mark not create
{B31A06}#15 {888EA0}- {F9D82F}You are in the interior]]
--COLORS
local main_color = 8949408  	-- {888EA0}
local main2_color = 16373807 	-- {F9D82F}
local red_color = 11737606 		-- {B31A06}
local green_color = 951812 		-- {0E8604}
local blueA_color = 623826 		-- {0984d2}
local pink_color = '{F84CE0}'
local purple_color = '{9B0690}'
local imgui_main2_color = '{C39932}'
--ïåðåìåííûå
local checkTabs = 'zuwi'
local active = true
reduceZoom = true
enabled = true
local locked = false
CheckLangMenu = false
CheckLangChat = false
CheckLangDialogs = false
CheckLangVisuals = false
CheckAirBrake = false
CheckGMactor = false
CheckGMveh = false
CheckGMWveh = false
checkClickwarp = false
local airBrakeCoords = {}
langIG = {}
--Íàñòðîéêè imgui
local btn_size = imgui.ImVec2(-0.1, 0)
local sw, sh = getScreenResolution()
--Íàñòðîéêè ìåíþ (imgui)
array = {
main_window_state 						= imgui.ImBool(false),

show_imgui_infRun 						= imgui.ImBool(mainIni.actor.infRun),
show_imgui_infSwim 						= imgui.ImBool(mainIni.actor.infSwim),
show_imgui_infOxygen 					= imgui.ImBool(mainIni.actor.infOxygen),
show_imgui_megajumpActor 				= imgui.ImBool(mainIni.actor.megaJump),
show_imgui_fastsprint 					= imgui.ImBool(mainIni.actor.fastSprint),
show_imgui_suicideActor 				= imgui.ImBool(mainIni.actor.suicide),
show_imgui_unfreeze 					= imgui.ImBool(mainIni.actor.unfreeze),
show_imgui_nofall 						= imgui.ImBool(mainIni.actor.noFall),
show_imgui_gmActor 						= imgui.ImBool(mainIni.actor.GM),

show_imgui_engineOnVeh 					= imgui.ImBool(mainIni.vehicle.engineOn),
show_imgui_restHealthVeh 				= imgui.ImBool(mainIni.vehicle.restoreHealth),
show_imgui_megajumpBMX 					= imgui.ImBool(mainIni.vehicle.megaJumpBMX),
show_imgui_flip180 						= imgui.ImBool(mainIni.vehicle.flip180),
show_imgui_flipOnWheels 				= imgui.ImBool(mainIni.vehicle.flipOnWheels),
show_imgui_suicideVeh 					= imgui.ImBool(mainIni.vehicle.boom),
show_imgui_hopVeh 						= imgui.ImBool(mainIni.vehicle.hop),
show_imgui_fastexit 					= imgui.ImBool(mainIni.vehicle.fastExit),
show_imgui_gmWheels 					= imgui.ImBool(mainIni.vehicle.gmWheels),
show_imgui_antiBikeFall 				= imgui.ImBool(mainIni.vehicle.AntiBikeFall),
show_imgui_gmVeh 						= imgui.ImBool(mainIni.vehicle.GM),
show_imgui_fixWheels 					= imgui.ImBool(mainIni.vehicle.fixWheels),
show_imgui_speedhack 					= imgui.ImBool(mainIni.vehicle.speedhack),
SpeedHackMaxSpeed 						= imgui.ImFloat(mainIni.vehicle.speedhackMaxSpeed),
show_imgui_perfectHandling 				= imgui.ImBool(mainIni.vehicle.perfectHandling),
show_imgui_allCarsNitro					= imgui.ImBool(mainIni.vehicle.allCarsNitro),
show_imgui_onlyWheels					= imgui.ImBool(mainIni.vehicle.onlyWheels),
show_imgui_tankMode						= imgui.ImBool(mainIni.vehicle.tankMode),
show_imgui_carsFloatWhenHit				= imgui.ImBool(mainIni.vehicle.carsFloatWhenHit),
show_imgui_driveOnWater 				= imgui.ImBool(mainIni.vehicle.driveOnWater),						

show_imgui_infAmmo 						= imgui.ImBool(mainIni.weapon.infAmmo),
show_imgui_fullskills					= imgui.ImBool(mainIni.weapon.fullSkills),

show_imgui_UnderWater 					= imgui.ImBool(mainIni.misc.WalkDriveUnderWater),
show_imgui_FOV 							= imgui.ImBool(mainIni.misc.FOV),
FOV_value 								= imgui.ImFloat(mainIni.misc.FOVvalue),
show_imgui_antibhop 					= imgui.ImBool(mainIni.misc.antibhop),
show_imgui_AirBrake 					= imgui.ImBool(mainIni.misc.AirBrake),
AirBrake_Speed 							= imgui.ImFloat(mainIni.misc.AirBrakeSpeed),
show_imgui_quickMap 					= imgui.ImBool(mainIni.misc.quickMap),
show_imgui_blink 						= imgui.ImBool(mainIni.misc.blink),
blink_dist								= imgui.ImFloat(mainIni.misc.blinkDist),
show_imgui_sensfix 						= imgui.ImBool(mainIni.misc.sensfix),
show_imgui_reconnect 					= imgui.ImBool(mainIni.misc.reconnect),
show_imgui_clrScr 						= imgui.ImBool(mainIni.misc.clearScreenshot),
show_imgui_clickwarp					= imgui.ImBool(mainIni.misc.ClickWarp),

show_imgui_nametag 						= imgui.ImBool(mainIni.visual.nameTag),
infbar 									= imgui.ImBool(mainIni.visual.infoBar),
show_imgui_doorlocks					= imgui.ImBool(mainIni.visual.doorLocks),
distDoorLocks							= imgui.ImInt(mainIni.visual.distanceDoorLocks),

checkupdate 							= imgui.ImBool(mainIni.menu.checkUpdate),
lang_menu 								= imgui.ImBool(mainIni.menu.language_menu), --false - english/true - russian
lang_chat 								= imgui.ImBool(mainIni.menu.language_chat), --false - english/true - russian
lang_dialogs 							= imgui.ImBool(mainIni.menu.language_dialogs), --false - english/true - russian
lang_visual								= imgui.ImBool(mainIni.menu.language_visual), --false - english/true - russian
AutoSave 								= imgui.ImBool(mainIni.menu.autoSave),
comboStyle 								= imgui.ImInt(mainIni.menu.iStyle),

at_chat									= imgui.ImBool(mainIni.admintools.adminChat),
at_scmd									= imgui.ImBool(mainIni.admintools.shortCMD),
at_ncmd									= imgui.ImBool(mainIni.admintools.newCMD)
}
--IMGUI
function apply_custom_style()
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4

	colors[clr.Text]   				  = ImVec4(0.00, 0.00, 0.00, 0.85) --= ImVec4(0.00, 0.00, 0.00, 0.51)
	colors[clr.TextDisabled]  		  = ImVec4(0.24, 0.24, 0.24, 1.00)
	colors[clr.WindowBg]              = ImVec4(0.90, 0.90, 0.90, 1.00)
	colors[clr.ChildWindowBg]         = ImVec4(0.86, 0.86, 0.86, 1.00)
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
	colors[clr.ComboBg]               = ImVec4(0.82, 0.82, 0.82, 1.00)
	colors[clr.CheckMark]             = ImVec4(0.00, 0.49, 1.00, 0.59)
	colors[clr.SliderGrab]            = ImVec4(0.00, 0.49, 1.00, 0.59)
	colors[clr.SliderGrabActive]      = ImVec4(0.00, 0.39, 1.00, 0.71)
	colors[clr.Button]                = ImVec4(0.00, 0.49, 1.00, 0.59)
	colors[clr.ButtonHovered]         = ImVec4(0.00, 0.49, 1.00, 0.71)
	colors[clr.ButtonActive]          = ImVec4(0.00, 0.49, 1.00, 0.78)
	colors[clr.Header]                = ImVec4(0.00, 0.49, 1.00, 0.78)
	colors[clr.HeaderHovered]         = ImVec4(0.00, 0.49, 1.00, 0.71)
	colors[clr.HeaderActive]          = ImVec4(0.00, 0.49, 1.00, 0.78)
	colors[clr.ResizeGrip]            = ImVec4(0.00, 0.39, 1.00, 0.59)
	colors[clr.ResizeGripHovered]     = ImVec4(0.00, 0.27, 1.00, 0.59)
	colors[clr.ResizeGripActive]      = ImVec4(0.00, 0.25, 1.00, 0.63)
	colors[clr.CloseButton]           = ImVec4(0.00, 0.35, 0.96, 0.71)
	colors[clr.CloseButtonHovered]    = ImVec4(0.00, 0.31, 0.88, 0.69)
	colors[clr.CloseButtonActive]     = ImVec4(0.00, 0.25, 0.88, 0.67)
	colors[clr.PlotLines]             = ImVec4(0.00, 0.39, 1.00, 0.75)
	colors[clr.PlotLinesHovered]      = ImVec4(0.00, 0.39, 1.00, 0.75)
	colors[clr.PlotHistogram]         = ImVec4(0.00, 0.39, 1.00, 0.75)
	colors[clr.PlotHistogramHovered]  = ImVec4(0.00, 0.35, 0.92, 0.78)
	colors[clr.TextSelectedBg]        = ImVec4(0.00, 0.47, 1.00, 0.59)
	colors[clr.ModalWindowDarkening]  = ImVec4(0.20, 0.20, 0.20, 0.35)
end
apply_custom_style()

function setInterfaceStyle(id)
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	if id == 0 then
	colors[clr.Text] 					= ImVec4(0.80, 0.80, 0.83, 1.00)
    colors[clr.TextDisabled] 			= ImVec4(0.24, 0.23, 0.29, 1.00)
    colors[clr.WindowBg] 				= ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.ChildWindowBg] 			= ImVec4(0.07, 0.07, 0.09, 1.00)
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
    colors[clr.ComboBg] 				= ImVec4(0.19, 0.18, 0.21, 1.00)
    colors[clr.CheckMark]				= ImVec4(0.80, 0.80, 0.83, 0.31)
    colors[clr.SliderGrab] 				= ImVec4(0.80, 0.80, 0.83, 0.31)
    colors[clr.SliderGrabActive] 		= ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.Button]					= ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.ButtonHovered] 			= ImVec4(0.24, 0.23, 0.29, 1.00)
    colors[clr.ButtonActive] 			= ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.Header] 					= ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.HeaderHovered] 			= ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.HeaderActive] 			= ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.ResizeGrip] 				= ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.ResizeGripHovered] 		= ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.ResizeGripActive] 		= ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.CloseButton] 			= ImVec4(0.40, 0.39, 0.38, 0.16)
    colors[clr.CloseButtonHovered] 		= ImVec4(0.40, 0.39, 0.38, 0.39)
    colors[clr.CloseButtonActive] 		= ImVec4(0.40, 0.39, 0.38, 1.00)
    colors[clr.PlotLines] 				= ImVec4(0.40, 0.39, 0.38, 0.63)
    colors[clr.PlotLinesHovered] 		= ImVec4(0.25, 1.00, 0.00, 1.00)
    colors[clr.PlotHistogram]			= ImVec4(0.40, 0.39, 0.38, 0.63)
    colors[clr.PlotHistogramHovered] 	= ImVec4(0.25, 1.00, 0.00, 1.00)
    colors[clr.TextSelectedBg]			= ImVec4(0.25, 1.00, 0.00, 0.43)
    colors[clr.ModalWindowDarkening]	= ImVec4(1.00, 0.98, 0.95, 0.73)
	elseif id == 1 then
		apply_custom_style()
	elseif id == 2 then
		colors[clr.Text]   				  = ImVec4(0.00, 0.00, 0.00, 0.80)
		colors[clr.TextDisabled]  		  = ImVec4(0.24, 0.24, 0.24, 1.00)
		colors[clr.WindowBg]              = ImVec4(0.90, 0.90, 0.90, 1.00)
		colors[clr.ChildWindowBg]         = ImVec4(0.86, 0.86, 0.86, 1.00)
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
		colors[clr.ComboBg]               = ImVec4(0.82, 0.82, 0.82, 1.00)
		colors[clr.CheckMark]             = ImVec4(0.49, 0.00, 1.00, 0.59)
		colors[clr.SliderGrab]            = ImVec4(0.49, 0.00, 1.00, 0.59)
		colors[clr.SliderGrabActive]      = ImVec4(0.39, 0.00, 1.00, 0.71)
		colors[clr.Button]                = ImVec4(0.49, 0.00, 1.00, 0.59)
		colors[clr.ButtonHovered]         = ImVec4(0.49, 0.00, 1.00, 0.71)
		colors[clr.ButtonActive]          = ImVec4(0.49, 0.00, 1.00, 0.78)
		colors[clr.Header]                = ImVec4(0.49, 0.00, 1.00, 0.78)
		colors[clr.HeaderHovered]         = ImVec4(0.49, 0.00, 1.00, 0.71)
		colors[clr.HeaderActive]          = ImVec4(0.49, 0.00, 1.00, 0.78)
		colors[clr.ResizeGrip]            = ImVec4(0.39, 0.00, 1.00, 0.59)
		colors[clr.ResizeGripHovered]     = ImVec4(0.27, 0.00, 1.00, 0.59)
		colors[clr.ResizeGripActive]      = ImVec4(0.25, 0.00, 1.00, 0.63)
		colors[clr.CloseButton]           = ImVec4(0.35, 0.00, 0.96, 0.71)
		colors[clr.CloseButtonHovered]    = ImVec4(0.31, 0.00, 0.88, 0.69)
		colors[clr.CloseButtonActive]     = ImVec4(0.25, 0.00, 0.88, 0.67)
		colors[clr.PlotLines]             = ImVec4(0.39, 0.00, 1.00, 0.75)
		colors[clr.PlotLinesHovered]      = ImVec4(0.39, 0.00, 1.00, 0.75)
		colors[clr.PlotHistogram]         = ImVec4(0.39, 0.00, 1.00, 0.75)
		colors[clr.PlotHistogramHovered]  = ImVec4(0.35, 0.00, 0.92, 0.78)
		colors[clr.TextSelectedBg]        = ImVec4(0.47, 0.00, 1.00, 0.59)
		colors[clr.ModalWindowDarkening]  = ImVec4(0.20, 0.20, 0.20, 0.35)
	end
end
setInterfaceStyle(mainIni.menu.iStyle)

function imgui.OnDrawFrame(args)
	if array.main_window_state.v then
		imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(875, 470), imgui.Cond.FirstUseEver)
		imgui.Begin('zuwi | Version: '.. version_script, array.main_window_state, imgui.WindowFlags.NoResize)
		if not array.lang_menu.v then
			imgui.CenterTextColoredRGB(checkTabs)
			if imgui.Button(fa.ICON_STREET_VIEW ..' Actor', imgui.ImVec2(100, 0)) then checkTabs = 'zuwi -> Actor' act1 = 1 end
			imgui.SameLine(nil, x)
			if imgui.Button(fa.ICON_CAR ..' Vehicle', imgui.ImVec2(100, 0)) then checkTabs = 'zuwi -> Vehicle' act1 = 2 end
			imgui.SameLine(nil, x)
			if imgui.Button(fa.ICON_BOMB ..' Weapon', imgui.ImVec2(100, 0)) then checkTabs = 'zuwi -> Weapon' act1 = 3 end
			imgui.SameLine(nil, x)
			if imgui.Button(fa.ICON_ADJUST ..' Misc', imgui.ImVec2(100, 0)) then checkTabs = 'zuwi -> Misc' act1 = 4 end
			imgui.SameLine(nil, x)
			if imgui.Button(fa.ICON_EYE ..' Visual', imgui.ImVec2(100, 0)) then checkTabs = 'zuwi -> Visual' act1 = 5 end
			imgui.SameLine(nil, x)
			if imgui.Button(fa.ICON_COG ..' Settings', imgui.ImVec2(100, 0)) then checkTabs = 'zuwi -> Settings' act1 = 6 end
			imgui.SameLine(nil, x)
			if imgui.Button(fa.ICON_INFO ..' Help', imgui.ImVec2(100, 0)) then checkTabs = 'zuwi -> Help' act1 = 8 end
		elseif array.lang_menu.v then
			imgui.CenterTextColoredRGB(checkTabs)
			if imgui.Button(fa.ICON_STREET_VIEW .. u8' Ïåðñîíàæ', imgui.ImVec2(100, 0)) then checkTabs = 'zuwi -> Ïåðñîíàæ' act1 = 1 end
			imgui.SameLine(nil, x)
			if imgui.Button(fa.ICON_CAR .. u8' Òðàíñïîðò', imgui.ImVec2(100, 0)) then checkTabs = 'zuwi -> Òðàíñïîðò' act1 = 2 end
			imgui.SameLine(nil, x)
			if imgui.Button(fa.ICON_BOMB .. u8' Îðóæèå', imgui.ImVec2(100, 0)) then checkTabs = 'zuwi -> Îðóæèå' act1 = 3 end
			imgui.SameLine(nil, x)
			if imgui.Button(fa.ICON_ADJUST .. u8' Ðàçíîå', imgui.ImVec2(100, 0)) then checkTabs = 'zuwi -> Ðàçíîå' act1 = 4 end
			imgui.SameLine(nil, x)
			if imgui.Button(fa.ICON_EYE .. u8' Âèçóàëû', imgui.ImVec2(100, 0)) then checkTabs = 'zuwi -> Âèçóàëû' act1 = 5 end
			imgui.SameLine(nil, x)
			if imgui.Button(fa.ICON_COG .. u8' Íàñòðîéêè', imgui.ImVec2(100, 0)) then checkTabs = 'zuwi -> Íàñòðîéêè' act1 = 6 end
			imgui.SameLine(nil, x)
			if imgui.Button(fa.ICON_INFO .. u8' Ïîìîùü', imgui.ImVec2(100, 0)) then checkTabs = 'zuwi -> Ïîìîùü' act1 = 8 end
		end
		if imgui.Button(fa.ICON_SERVER .. ' Revent-RP', imgui.ImVec2(100, 0)) then checkTabs = 'zuwi -> Revent-RP' act1 = 9 end	

		if act1 == 1 then --ACTOR IMGUI
			imgui.BeginChild('1', imgui.ImVec2(855, 370), true)
			if array.lang_menu.v then
				imgui.ToggleButton('1', 'Áåñêîíå÷íàÿ âûíîñëèâîñòü (áåã)', array.show_imgui_infRun)
				imgui.ToggleButton('32', 'Áåñêîíå÷íàÿ âûíîñëèâîñòü (ïëàâàíèå)', array.show_imgui_infSwim)
				imgui.ToggleButton('2', 'Áåñêîíå÷íûé êèñëîðîä', array.show_imgui_infOxygen)
				imgui.ToggleButton('3', 'Ìåãà ïðûæîê', array.show_imgui_megajumpActor)
				imgui.ToggleButton('4', 'Áûñòðûé áåã', array.show_imgui_fastsprint)
				imgui.ToggleButton('5', 'Áåç ïàäåíèé', array.show_imgui_nofall)
				imgui.ToggleButton('6', 'Ðàçìîðîçèòü', array.show_imgui_unfreeze)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8"Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: /")
				imgui.ToggleButton('7', 'Ñóèöèä', array.show_imgui_suicideActor)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8"Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: F3\nÅñëè ôóíêöèÿ 'Âçðûâ òðàíñïîðòà' âêëþ÷åí âî âêëàäêå 'Òðàíñïîðò' òî ïðîèçîéäåò òîëüêî ñóèöèä\nÅñëè îáå ôóíêöèè âêëþ÷åíû, òî ïðîèçîéäåò âçðûâ òðàíñïîðòà, à åñëè Âû íå â òðàíñïîðòå, òî Âû ñîâåðøèòå ñóèöèä")
				imgui.ToggleButton('37', 'Áåñêîíå÷íîå çäîðîâüå', array.show_imgui_gmActor)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8"Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: Insert")
			elseif not array.lang_menu.v then
				imgui.ToggleButton('1', 'Infinity stamina (run)', array.show_imgui_infRun)
				imgui.ToggleButton('32', 'Infinity stamina (swim)', array.show_imgui_infSwim)
				imgui.ToggleButton('2', 'Infinity oxygen', array.show_imgui_infOxygen)
				imgui.ToggleButton('3', 'Mega jump', array.show_imgui_megajumpActor)
				imgui.ToggleButton('4', 'Fast sprint', array.show_imgui_fastsprint)
				imgui.ToggleButton('5', 'No fall', array.show_imgui_nofall)
				imgui.ToggleButton('6', 'Unfreeze', array.show_imgui_unfreeze)
					imgui.SameLine(nil, x)
					imgui.TextQuestion("If function enabled then use key: /")
				imgui.ToggleButton('7', 'Suicide', array.show_imgui_suicideActor)
					imgui.SameLine(nil, x)
					imgui.TextQuestion("If function enabled then use key: F3\nIf function 'Boom vehicle' enabled in tab 'Vehicle' then will be only suicide\nThat is, if both functions are enabled, then you will boom vehicle, and not in vehicle will suicide")
				imgui.ToggleButton('37', 'GM', array.show_imgui_gmActor)
					imgui.SameLine(nil, x)
					imgui.TextQuestion("If function enabled then use key: Insert")
			end
			imgui.EndChild()

		elseif act1 == 2 then --VEHICLE IMGUI
			imgui.BeginChild('2', imgui.ImVec2(855, 370), true)
			if array.lang_menu.v then
				imgui.ToggleButton('31', 'SpeedHack', array.show_imgui_speedhack)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8"Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: ALT")
					imgui.SameLine(nil, x)
					imgui.SliderFloat(u8'Ìàêñèìàëüíàÿ ñêîðîñòü', array.SpeedHackMaxSpeed, 80, 300, '%.f', 0.5)
				imgui.ToggleButton('8', 'Ïåðåâîðîò íà 180', array.show_imgui_flip180)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8"Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: Backspace")
				imgui.ToggleButton('9', 'Ïåðåâîðîò íà êîëåñà', array.show_imgui_flipOnWheels)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8"Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: Delete")
				imgui.ToggleButton('10', 'Ïðûæî÷åê', array.show_imgui_hopVeh)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8"Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: B")
				imgui.ToggleButton('11', 'Âçðûâ òðàíñïîðòà', array.show_imgui_suicideVeh)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8"Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: F3\nÅñëè ôóíêöèÿ 'Ñóèöèä' âêëþ÷åíà âî âêëàäêå 'Ïåðñîíàæ' òî ïðîèçîéäåò òîëüêî âçðûâ òðàíñïîðòà\nÅñëè îáå ôóíêöèè âêëþ÷åíû, òî ïðîèçîéäåò âçðûâ òðàíñïîðòà, à åñëè Âû íå â òðàíñïîðòå, òî Âû ñîâåðøèòå ñóèöèä")
				imgui.ToggleButton('12', 'Áûñòðûé âûõîä', array.show_imgui_fastexit)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8"Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: N")
				imgui.ToggleButton('13', 'Ïî÷èíèòü êîëåñà', array.show_imgui_fixWheels)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8"Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: Z+1")
				imgui.ToggleButton('14', 'Anti-bike fall', array.show_imgui_antiBikeFall)
				imgui.ToggleButton('15', 'Ìåãà BMX ïðûæîê', array.show_imgui_megajumpBMX)
				imgui.ToggleButton('34', 'Èäåàëüíàÿ åçäà', array.show_imgui_perfectHandling)
				imgui.ToggleButton('46', 'Ó âñåãî òðàíñïîðòà íèòðî', array.show_imgui_allCarsNitro)
				imgui.ToggleButton('48', 'Òàíê ìîä', array.show_imgui_tankMode)
				imgui.ToggleButton('49', 'Òðàíñïîðò îòëåòàåò åñëè â íåãî ñòðåëüíóòü', array.show_imgui_carsFloatWhenHit)
				imgui.ToggleButton('35', 'Åçäà ïî âîäå', array.show_imgui_driveOnWater)
				imgui.ToggleButton('38', 'Ïî÷èíèòü òðàíñïîðò', array.show_imgui_restHealthVeh)
					imgui.SameLine(nil,x)
					imgui.TextQuestion(u8'Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: 1')
				imgui.ToggleButton('39', 'Äâèãàòåëü âêëþ÷åí', array.show_imgui_engineOnVeh)
				imgui.Separator()
				imgui.TextColoredRGB('{0984d2}GM')
				imgui.ToggleButton('16', 'Îáû÷íûé', array.show_imgui_gmVeh)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8"Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: Home+1")
				imgui.SameLine(nil, x)
				imgui.ToggleButton('17', 'Êîëåñà', array.show_imgui_gmWheels)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8"Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: Home+2")
			elseif not array.lang_menu.v then
				imgui.ToggleButton('31', 'SpeedHack', array.show_imgui_speedhack)
					imgui.SameLine(nil, x)
					imgui.TextQuestion("If function enabled then use key: ALT")
					imgui.SameLine(nil, x)
					imgui.SliderFloat('Max speed', array.SpeedHackMaxSpeed, 80, 300, '%.f', 0.5)
				imgui.ToggleButton('8', 'Flip 180', array.show_imgui_flip180)
					imgui.SameLine(nil, x)
					imgui.TextQuestion("If function enabled then use key: Backspace")
				imgui.ToggleButton('9', 'Flip on wheels', array.show_imgui_flipOnWheels)
					imgui.SameLine(nil, x)
					imgui.TextQuestion("If function enabled then use key: Delete")
				imgui.ToggleButton('10', 'Hop', array.show_imgui_hopVeh)
					imgui.SameLine(nil, x)
					imgui.TextQuestion("If function enabled then use key: B\n")
				imgui.ToggleButton('11', 'Boom vehicle', array.show_imgui_suicideVeh)
					imgui.SameLine(nil, x)
					imgui.TextQuestion("If function enabled then use key: F3\nIf function 'Suicide' enabled in tab 'Actor' then will be only boom vehicle\nThat is, if both functions are enabled, then you will boom vehicle, and not in transport will suicide")
				imgui.ToggleButton('12', 'Fast exit', array.show_imgui_fastexit)
					imgui.SameLine(nil, x)
					imgui.TextQuestion("If function enabled then use key: N")
				imgui.ToggleButton('13', 'Restore wheels', array.show_imgui_fixWheels)
					imgui.SameLine(nil, x)
					imgui.TextQuestion("If function enabled then use keys: Z+1")
				imgui.ToggleButton('14', 'Anti-bike fall', array.show_imgui_antiBikeFall)
				imgui.ToggleButton('15', 'Mega BMX jump', array.show_imgui_megajumpBMX)
				imgui.ToggleButton('34', 'Perfect handling', array.show_imgui_perfectHandling)
				imgui.ToggleButton('46', 'All cars have nitro', array.show_imgui_allCarsNitro)
				imgui.ToggleButton('48', 'Tank mode', array.show_imgui_tankMode)
				imgui.ToggleButton('49', 'Vehicle float away when hit', array.show_imgui_carsFloatWhenHit)
				imgui.ToggleButton('35', 'Drive on water', array.show_imgui_driveOnWater)
				imgui.ToggleButton('38', 'Restore health', array.show_imgui_restHealthVeh)
					imgui.SameLine(nil,x)
					imgui.TextQuestion('If function enabled then use key: 1')
				imgui.ToggleButton('39', 'Engine on', array.show_imgui_engineOnVeh)
				imgui.Separator()
				imgui.TextColoredRGB('{0984d2}GM')
				imgui.ToggleButton('16', 'Default', array.show_imgui_gmVeh)
					imgui.SameLine(nil, x)
					imgui.TextQuestion("If function enabled then use keys: Home+1")
				imgui.SameLine(nil, x)
				imgui.ToggleButton('17', 'Wheels', array.show_imgui_gmWheels)
					imgui.SameLine(nil, x)
					imgui.TextQuestion("If function enabled then use keys: Home+2")
			end
			imgui.EndChild()

		elseif act1 == 3 then --WEAPON IMGUI
			imgui.BeginChild('3', imgui.ImVec2(855, 370), true)
			if array.lang_menu.v then
				imgui.ToggleButton('18', 'Áåñêîíå÷íûå ïàòðîíû, áåç ïåðåçàðÿäêè', array.show_imgui_infAmmo)
				imgui.ToggleButton('45', 'Ïîëíîå óìåíèå', array.show_imgui_fullskills)
			elseif not array.lang_menu.v then
				imgui.ToggleButton('18', 'Infinity ammo and no reload', array.show_imgui_infAmmo)
				imgui.ToggleButton('45', 'Full skills', array.show_imgui_fullskills)
			end
			imgui.EndChild()

		elseif act1 == 4 then --MISC IMGUI
			imgui.BeginChild('4', imgui.ImVec2(855, 370), true)
			if array.lang_menu.v then
				if imgui.Button(fa.ICON_GLOBE .. u8' Ãëàâíîå') then checkTabs = 'zuwi -> Ðàçíîå -> Ãëàâíîå' act4 = 1 end
				imgui.SameLine(nil, x)
				if imgui.Button(fa.ICON_LOCATION_ARROW .. u8' Òåëåïîðòû') then checkTabs = 'zuwi -> Ðàçíîå -> Òåëåïîðòû' act4 = 2 end
				imgui.Separator()
				if act4 == 1 then
					imgui.ToggleButton('19', 'AirBrake', array.show_imgui_AirBrake)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8"Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: RShift")
					imgui.SameLine(nil, 79)
					imgui.SliderFloat(u8'Ñêîðîñòü', array.AirBrake_Speed, 0.1, 14.9, '%.1f', 1.5)
					imgui.ToggleButton('20', 'Ïîëå çðåíèÿ', array.show_imgui_FOV)
					imgui.SameLine(nil, 76)
					imgui.SliderFloat(u8'Çíà÷åíèå', array.FOV_value, 70.0, 108.0, '%.f', 0.5)
					imgui.ToggleButton('21', 'Áûñòðûé òåëåïîðò', array.show_imgui_blink)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8"Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: X\nÂàñ òåëåïîðòèðóåò íà îïðåäåëåííîå êîëè÷åñòâî ìåòðîâ âïåðåä")
					imgui.SameLine(nil, 18)
					imgui.SliderFloat(u8'Äèñòàíöèÿ', array.blink_dist, 1, 150, '%.f', 1.5)
					imgui.ToggleButton('43', 'ClickWarp', array.show_imgui_clickwarp)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8"Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: Êîëåñî ìûøè")
					imgui.ToggleButton('22', 'Àíòè BHop', array.show_imgui_antibhop)
					imgui.SameLine(nil, x)
					imgui.TextQuestion('Îñòîðîæíî ñ ýòîé ôóíêöèåé! Ìîãóò äàòü áàí!')
					imgui.ToggleButton('23', 'Áûñòðàÿ êàðòà', array.show_imgui_quickMap)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8"Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: M")
					imgui.ToggleButton('24', 'Èñïðàâëåíèå ÷óâñòâèòåëüíîñòè', array.show_imgui_sensfix)
					imgui.ToggleButton('25', 'Ïåðåçàõîä', array.show_imgui_reconnect)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8'Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: LSHFIT+0')
					imgui.ToggleButton('33', '×èñòðûé ñêðèíøîò', array.show_imgui_clrScr)
					imgui.ToggleButton('36', 'Åçäà/Õîäüáà ïîä âîäîé', array.show_imgui_UnderWater)
				elseif act4 == 2 then
					if imgui.CollapsingHeader(u8'Òåëåïîðòû â èíòåðüåðû') then
						imgui.Columns(3, true)
						if imgui.Button("Interior: Burning Desire House") then teleportInterior(PLAYER_PED, 2338.32, -1180.61, 1027.98, 5) end
						if imgui.Button("Interior: RC Zero's Battlefield") then teleportInterior(PLAYER_PED, -975.5766, 1061.1312, 1345.6719, 10) end
						if imgui.Button("Interior: Liberty City") then teleportInterior(PLAYER_PED, -750.80, 491.00, 1371.70, 1) end
						if imgui.Button("Interior: Unknown Stadium") then teleportInterior(PLAYER_PED, -1400.2138, 106.8926, 1032.2779, 1) end
						if imgui.Button("Interior: Secret San Fierro Chunk") then teleportInterior(PLAYER_PED, -2015.6638, 147.2069, 29.3127, 14) end
						if imgui.Button("Interior: Jefferson Motel") then teleportInterior(PLAYER_PED, 2220.26, -1148.01, 1025.80, 15) end
						if imgui.Button("Interior: Jizzy's Pleasure Dome") then teleportInterior(PLAYER_PED, -2660.6185, 1426.8320, 907.3626, 3) end
						imgui.NextColumn(1)
						if imgui.Button("Stadium: Bloodbowl") then teleportInterior(PLAYER_PED, -1394.20, 987.62, 1023.96, 15) end
						if imgui.Button("Stadium: Kickstart") then teleportInterior(PLAYER_PED, -1410.72, 1591.16, 1052.53, 14) end
						if imgui.Button("Stadium: 8-Track Stadium") then teleportInterior(PLAYER_PED, -1417.8720, -276.4260, 1051.1910, 7) end
						if imgui.Button("24/7 Store: Big - L-Shaped") then teleportInterior(PLAYER_PED, -25.8844, -185.8689, 1003.5499, 17) end
						if imgui.Button("24/7 Store: Big - Oblong") then teleportInterior(PLAYER_PED, 6.0911, -29.2718, 1003.5499, 10) end
						if imgui.Button("24/7 Store: Med - Square") then teleportInterior(PLAYER_PED, -30.9469, -89.6095, 1003.5499, 18) end
						if imgui.Button("24/7 Store: Med - Square") then teleportInterior(PLAYER_PED, -25.1329, -139.0669, 1003.5499, 16) end
						imgui.NextColumn(0)
						if imgui.Button("24/7 Store: Sml - Long") then teleportInterior(PLAYER_PED, -27.3123, -29.2775, 1003.5499, 4) end
						if imgui.Button("24/7 Store: Sml - Square") then teleportInterior(PLAYER_PED, -26.6915, -55.7148, 1003.5499, 6) end
						if imgui.Button("Airport: Ticket Sales") then teleportInterior(PLAYER_PED, -1827.1473, 7.2074, 1061.1435, 14) end
						if imgui.Button("Airport: Baggage Claim") then teleportInterior(PLAYER_PED, -1855.5687, 41.2631, 1061.1435, 14) end
						if imgui.Button("Airplane: Shamal Cabin") then teleportInterior(PLAYER_PED, 2.3848, 33.1033, 1199.8499, 1) end
						if imgui.Button("Airplane: Andromada Cargo hold") then teleportInterior(PLAYER_PED, 315.8561, 1024.4964, 1949.7973, 9) end
					end
					imgui.Columns(1, true)
					if imgui.CollapsingHeader(u8'Îñòàëüíûå òåëåïîðòû') then
						imgui.Columns(3, true)
						if imgui.Button("Transfender near Wang Cars in Doherty") then teleportInterior(PLAYER_PED, -1935.77, 228.79, 34.16, 0) end
						if imgui.Button("Wheel Archangels in Ocean Flats") then teleportInterior(PLAYER_PED, -2707.48, 218.65, 4.93, 0) end
						if imgui.Button("LowRider Tuning Garage in Willowfield") then teleportInterior(PLAYER_PED, 2645.61, -2029.15, 14.28, 0) end
						if imgui.Button("Transfender in Temple") then teleportInterior(PLAYER_PED, 1041.26, -1036.77, 32.48, 0) end
						if imgui.Button("Transfender in come-a-lot") then teleportInterior(PLAYER_PED, 2387.55, 1035.70, 11.56, 0) end
						if imgui.Button("Eight Ball Autos near El Corona") then teleportInterior(PLAYER_PED, 1836.93, -1856.28, 14.13, 0) end
						if imgui.Button("Welding Wedding Bomb-workshop in Emerald Isle") then teleportInterior(PLAYER_PED, 2006.11, 2292.87, 11.57, 0) end
						if imgui.Button("Michelles Pay 'n' Spray in Downtown") then teleportInterior(PLAYER_PED, -1787.25, 1202.00, 25.84, 0) end
						if imgui.Button("Pay 'n' Spray in Dillimore") then teleportInterior(PLAYER_PED, 720.10, -470.93, 17.07, 0) end
						if imgui.Button("Pay 'n' Spray in El Quebrados") then teleportInterior(PLAYER_PED, -1420.21, 2599.45, 56.43, 0) end
						if imgui.Button("Pay 'n' Spray in Fort Carson") then teleportInterior(PLAYER_PED, -100.16, 1100.79, 20.34, 0) end
						if imgui.Button("Pay 'n' Spray in Idlewood") then teleportInterior(PLAYER_PED, 2078.44, -1831.44, 14.13, 0) end
						if imgui.Button("Pay 'n' Spray in Juniper Hollow") then teleportInterior(PLAYER_PED, -2426.89, 1036.61, 51.14, 0) end
						if imgui.Button("Pay 'n' Spray in Redsands East") then teleportInterior(PLAYER_PED, 1957.96, 2161.96, 11.56, 0) end
						if imgui.Button("Pay 'n' Spray in Santa Maria Beach") then teleportInterior(PLAYER_PED, 488.29, -1724.85, 12.01, 0) end
						imgui.NextColumn(1)
						if imgui.Button("Pay 'n' Spray in Temple") then teleportInterior(PLAYER_PED, 1025.08, -1037.28, 32.28, 0) end
						if imgui.Button("Pay 'n' Spray near Royal Casino") then teleportInterior(PLAYER_PED, 2393.70, 1472.80, 11.42, 0) end
						if imgui.Button("Pay 'n' Spray near Wang Cars in Doherty") then teleportInterior(PLAYER_PED, -1904.97, 268.51, 41.04, 0) end
						if imgui.Button("Player Garage: Verdant Meadows") then teleportInterior(PLAYER_PED, 403.58, 2486.33, 17.23, 0) end
						if imgui.Button("Player Garage: Las Venturas Airport") then teleportInterior(PLAYER_PED, 1578.24, 1245.20, 11.57, 0) end
						if imgui.Button("Player Garage: Calton Heights") then teleportInterior(PLAYER_PED, -2105.79, 905.11 ,77.07, 0) end
						if imgui.Button("Player Garage: Derdant Meadows") then teleportInterior(PLAYER_PED, 423.69, 2545.99, 17.07, 0) end
						if imgui.Button("Player Garage: Dillimore ") then teleportInterior(PLAYER_PED, 785.79, -513.12, 17.44, 0) end
						if imgui.Button("Player Garage: Doherty") then teleportInterior(PLAYER_PED, -2027.34, 141.02, 29.57, 0) end
						if imgui.Button("Player Garage: El Corona") then teleportInterior(PLAYER_PED, 1698.10, -2095.88, 14.29, 0) end
						if imgui.Button("Player Garage: Fort Carson") then teleportInterior(PLAYER_PED, -361.10, 1185.23, 20.49, 0) end
						if imgui.Button("Player Garage: Hashbury") then teleportInterior(PLAYER_PED, -2463.27, -124.86, 26.41, 0) end
						if imgui.Button("Player Garage: Johnson House") then teleportInterior(PLAYER_PED, 2505.64, -1683.72, 14.25, 0) end
						if imgui.Button("Player Garage: Mulholland") then teleportInterior(PLAYER_PED, 1350.76, -615.56, 109.88, 0) end
						if imgui.Button("Player Garage: Palomino Creek") then teleportInterior(PLAYER_PED, 2231.64, 156.93, 27.63, 0) end
						imgui.NextColumn(0)
						if imgui.Button("Player Garage: Paradiso") then teleportInterior(PLAYER_PED, -2695.51, 810.70, 50.57, 0) end
						if imgui.Button("Player Garage: Prickle Pine") then teleportInterior(PLAYER_PED, 1293.61, 2529.54, 11.42, 0) end
						if imgui.Button("Player Garage: Redland West") then teleportInterior(PLAYER_PED, 1401.34, 1903.08, 11.99, 0) end
						if imgui.Button("Player Garage: Rockshore West") then teleportInterior(PLAYER_PED, 2436.50, 698.43, 11.60, 0) end
						if imgui.Button("Player Garage: Santa Maria Beach") then teleportInterior(PLAYER_PED, 322.65, -1780.30, 5.55, 0) end
						if imgui.Button("Player Garage: Whitewood Estates") then teleportInterior(PLAYER_PED, 917.46, 2012.14, 11.65, 0) end
						if imgui.Button("Commerce Region Loading Bay") then teleportInterior(PLAYER_PED, 1641.14 ,-1526.87, 14.30, 0) end
						if imgui.Button("San Fierro Police Garage") then teleportInterior(PLAYER_PED, -1617.58, 688.69, -4.50, 0) end
						if imgui.Button("Los Santos Cemetery") then teleportInterior(PLAYER_PED, 837.05, -1101.93, 23.98, 0) end
						if imgui.Button("Grove Street") then teleportInterior(PLAYER_PED, 2536.08, -1632.98, 13.79, 0) end
						if imgui.Button("4D casino") then teleportInterior(PLAYER_PED, 1992.93, 1047.31, 10.82, 0) end
						if imgui.Button("LS Hospital") then teleportInterior(PLAYER_PED, 2033.00, -1416.02, 16.99, 0) end
						if imgui.Button("SF Hospital") then teleportInterior(PLAYER_PED, -2653.11, 634.78, 14.45, 0) end
						if imgui.Button("LV Hospital") then teleportInterior(PLAYER_PED, 1580.22, 1768.93, 10.82, 0) end
						if imgui.Button("SF Export") then teleportInterior(PLAYER_PED, -1550.73, 99.29, 17.33, 0) end
					end
				else act4 = 1 end

			elseif not array.lang_menu.v then
				if imgui.Button(fa.ICON_GLOBE ..' Main') then checkTabs = 'zuwi -> Misc -> Main' act4 = 1 end
				imgui.SameLine(nil, x)
				if imgui.Button(fa.ICON_LOCATION_ARROW ..' Teleports') then checkTabs = 'zuwi -> Misc -> Teleports' act4 = 2 end
				imgui.Separator()
				if act4 == 1 then
					imgui.ToggleButton('19', 'AirBrake', array.show_imgui_AirBrake)
					imgui.SameLine(nil, x)
					imgui.TextQuestion("If function enabled then use key: RShift")
					imgui.SameLine(nil, 9)
					imgui.SliderFloat('Speed', array.AirBrake_Speed, 0.1, 14.9, '%.1f', 1.5)
					imgui.ToggleButton('20', 'FOV changer', array.show_imgui_FOV)
					imgui.SameLine(nil, x)
					imgui.SliderFloat('Value', array.FOV_value, 70.0, 108.0, '%.f', 0.5)
					imgui.ToggleButton('21', 'Blink', array.show_imgui_blink)
					imgui.SameLine(nil, x)
					imgui.TextQuestion("If function enabled then use key: X\nYou teleport a certain number of meters ahead")
					imgui.SameLine(nil, 29)
					imgui.SliderFloat('Distance', array.blink_dist, 1, 150, '%.f', 1.5)
					imgui.ToggleButton('43', 'ClickWarp', array.show_imgui_clickwarp)
					imgui.SameLine(nil, x)
					imgui.TextQuestion("If function enabled then use key: Mouse wheels")
					imgui.ToggleButton('22', 'Anti BHop', array.show_imgui_antibhop)
					imgui.SameLine(nil, x)
					imgui.TextQuestion("Be careful with this function! They can give a ban!")
					imgui.ToggleButton('23', 'Quick map', array.show_imgui_quickMap)
					imgui.SameLine(nil, x)
					imgui.TextQuestion("If function enabled then use key: M")
					imgui.ToggleButton('24', 'Sensetivity fix', array.show_imgui_sensfix)
					imgui.ToggleButton('25', 'Reconnect', array.show_imgui_reconnect)
					imgui.SameLine(nil, x)
					imgui.TextQuestion('If function enabled then use key: LSHFIT+0')
					imgui.ToggleButton('33', 'Clear screenshot', array.show_imgui_clrScr)
					imgui.ToggleButton('36', 'Drive/Walk under water', array.show_imgui_UnderWater)
				elseif act4 == 2 then
					if imgui.CollapsingHeader('Teleports in interior') then
						imgui.Columns(3, true)
						if imgui.Button("Interior: Burning Desire House") then teleportInterior(PLAYER_PED, 2338.32, -1180.61, 1027.98, 5) end
						if imgui.Button("Interior: RC Zero's Battlefield") then teleportInterior(PLAYER_PED, -975.5766, 1061.1312, 1345.6719, 10) end
						if imgui.Button("Interior: Liberty City") then teleportInterior(PLAYER_PED, -750.80, 491.00, 1371.70, 1) end
						if imgui.Button("Interior: Unknown Stadium") then teleportInterior(PLAYER_PED, -1400.2138, 106.8926, 1032.2779, 1) end
						if imgui.Button("Interior: Secret San Fierro Chunk") then teleportInterior(PLAYER_PED, -2015.6638, 147.2069, 29.3127, 14) end
						if imgui.Button("Interior: Jefferson Motel") then teleportInterior(PLAYER_PED, 2220.26, -1148.01, 1025.80, 15) end
						if imgui.Button("Interior: Jizzy's Pleasure Dome") then teleportInterior(PLAYER_PED, -2660.6185, 1426.8320, 907.3626, 3) end
						imgui.NextColumn(1)
						if imgui.Button("Stadium: Bloodbowl") then teleportInterior(PLAYER_PED, -1394.20, 987.62, 1023.96, 15) end
						if imgui.Button("Stadium: Kickstart") then teleportInterior(PLAYER_PED, -1410.72, 1591.16, 1052.53, 14) end
						if imgui.Button("Stadium: 8-Track Stadium") then teleportInterior(PLAYER_PED, -1417.8720, -276.4260, 1051.1910, 7) end
						if imgui.Button("24/7 Store: Big - L-Shaped") then teleportInterior(PLAYER_PED, -25.8844, -185.8689, 1003.5499, 17) end
						if imgui.Button("24/7 Store: Big - Oblong") then teleportInterior(PLAYER_PED, 6.0911, -29.2718, 1003.5499, 10) end
						if imgui.Button("24/7 Store: Med - Square") then teleportInterior(PLAYER_PED, -30.9469, -89.6095, 1003.5499, 18) end
						if imgui.Button("24/7 Store: Med - Square") then teleportInterior(PLAYER_PED, -25.1329, -139.0669, 1003.5499, 16) end
						imgui.NextColumn(0)
						if imgui.Button("24/7 Store: Sml - Long") then teleportInterior(PLAYER_PED, -27.3123, -29.2775, 1003.5499, 4) end
						if imgui.Button("24/7 Store: Sml - Square") then teleportInterior(PLAYER_PED, -26.6915, -55.7148, 1003.5499, 6) end
						if imgui.Button("Airport: Ticket Sales") then teleportInterior(PLAYER_PED, -1827.1473, 7.2074, 1061.1435, 14) end
						if imgui.Button("Airport: Baggage Claim") then teleportInterior(PLAYER_PED, -1855.5687, 41.2631, 1061.1435, 14) end
						if imgui.Button("Airplane: Shamal Cabin") then teleportInterior(PLAYER_PED, 2.3848, 33.1033, 1199.8499, 1) end
						if imgui.Button("Airplane: Andromada Cargo hold") then teleportInterior(PLAYER_PED, 315.8561, 1024.4964, 1949.7973, 9) end
					end
					imgui.Columns(1, true)
					if imgui.CollapsingHeader('Other teleports') then
						imgui.Columns(3, true)
						if imgui.Button("Transfender near Wang Cars in Doherty") then teleportInterior(PLAYER_PED, -1935.77, 228.79, 34.16, 0) end
						if imgui.Button("Wheel Archangels in Ocean Flats") then teleportInterior(PLAYER_PED, -2707.48, 218.65, 4.93, 0) end
						if imgui.Button("LowRider Tuning Garage in Willowfield") then teleportInterior(PLAYER_PED, 2645.61, -2029.15, 14.28, 0) end
						if imgui.Button("Transfender in Temple") then teleportInterior(PLAYER_PED, 1041.26, -1036.77, 32.48, 0) end
						if imgui.Button("Transfender in come-a-lot") then teleportInterior(PLAYER_PED, 2387.55, 1035.70, 11.56, 0) end
						if imgui.Button("Eight Ball Autos near El Corona") then teleportInterior(PLAYER_PED, 1836.93, -1856.28, 14.13, 0) end
						if imgui.Button("Welding Wedding Bomb-workshop in Emerald Isle") then teleportInterior(PLAYER_PED, 2006.11, 2292.87, 11.57, 0) end
						if imgui.Button("Michelles Pay 'n' Spray in Downtown") then teleportInterior(PLAYER_PED, -1787.25, 1202.00, 25.84, 0) end
						if imgui.Button("Pay 'n' Spray in Dillimore") then teleportInterior(PLAYER_PED, 720.10, -470.93, 17.07, 0) end
						if imgui.Button("Pay 'n' Spray in El Quebrados") then teleportInterior(PLAYER_PED, -1420.21, 2599.45, 56.43, 0) end
						if imgui.Button("Pay 'n' Spray in Fort Carson") then teleportInterior(PLAYER_PED, -100.16, 1100.79, 20.34, 0) end
						if imgui.Button("Pay 'n' Spray in Idlewood") then teleportInterior(PLAYER_PED, 2078.44, -1831.44, 14.13, 0) end
						if imgui.Button("Pay 'n' Spray in Juniper Hollow") then teleportInterior(PLAYER_PED, -2426.89, 1036.61, 51.14, 0) end
						if imgui.Button("Pay 'n' Spray in Redsands East") then teleportInterior(PLAYER_PED, 1957.96, 2161.96, 11.56, 0) end
						if imgui.Button("Pay 'n' Spray in Santa Maria Beach") then teleportInterior(PLAYER_PED, 488.29, -1724.85, 12.01, 0) end
						imgui.NextColumn(1)
						if imgui.Button("Pay 'n' Spray in Temple") then teleportInterior(PLAYER_PED, 1025.08, -1037.28, 32.28, 0) end
						if imgui.Button("Pay 'n' Spray near Royal Casino") then teleportInterior(PLAYER_PED, 2393.70, 1472.80, 11.42, 0) end
						if imgui.Button("Pay 'n' Spray near Wang Cars in Doherty") then teleportInterior(PLAYER_PED, -1904.97, 268.51, 41.04, 0) end
						if imgui.Button("Player Garage: Verdant Meadows") then teleportInterior(PLAYER_PED, 403.58, 2486.33, 17.23, 0) end
						if imgui.Button("Player Garage: Las Venturas Airport") then teleportInterior(PLAYER_PED, 1578.24, 1245.20, 11.57, 0) end
						if imgui.Button("Player Garage: Calton Heights") then teleportInterior(PLAYER_PED, -2105.79, 905.11 ,77.07, 0) end
						if imgui.Button("Player Garage: Derdant Meadows") then teleportInterior(PLAYER_PED, 423.69, 2545.99, 17.07, 0) end
						if imgui.Button("Player Garage: Dillimore ") then teleportInterior(PLAYER_PED, 785.79, -513.12, 17.44, 0) end
						if imgui.Button("Player Garage: Doherty") then teleportInterior(PLAYER_PED, -2027.34, 141.02, 29.57, 0) end
						if imgui.Button("Player Garage: El Corona") then teleportInterior(PLAYER_PED, 1698.10, -2095.88, 14.29, 0) end
						if imgui.Button("Player Garage: Fort Carson") then teleportInterior(PLAYER_PED, -361.10, 1185.23, 20.49, 0) end
						if imgui.Button("Player Garage: Hashbury") then teleportInterior(PLAYER_PED, -2463.27, -124.86, 26.41, 0) end
						if imgui.Button("Player Garage: Johnson House") then teleportInterior(PLAYER_PED, 2505.64, -1683.72, 14.25, 0) end
						if imgui.Button("Player Garage: Mulholland") then teleportInterior(PLAYER_PED, 1350.76, -615.56, 109.88, 0) end
						if imgui.Button("Player Garage: Palomino Creek") then teleportInterior(PLAYER_PED, 2231.64, 156.93, 27.63, 0) end
						imgui.NextColumn(0)
						if imgui.Button("Player Garage: Paradiso") then teleportInterior(PLAYER_PED, -2695.51, 810.70, 50.57, 0) end
						if imgui.Button("Player Garage: Prickle Pine") then teleportInterior(PLAYER_PED, 1293.61, 2529.54, 11.42, 0) end
						if imgui.Button("Player Garage: Redland West") then teleportInterior(PLAYER_PED, 1401.34, 1903.08, 11.99, 0) end
						if imgui.Button("Player Garage: Rockshore West") then teleportInterior(PLAYER_PED, 2436.50, 698.43, 11.60, 0) end
						if imgui.Button("Player Garage: Santa Maria Beach") then teleportInterior(PLAYER_PED, 322.65, -1780.30, 5.55, 0) end
						if imgui.Button("Player Garage: Whitewood Estates") then teleportInterior(PLAYER_PED, 917.46, 2012.14, 11.65, 0) end
						if imgui.Button("Commerce Region Loading Bay") then teleportInterior(PLAYER_PED, 1641.14 ,-1526.87, 14.30, 0) end
						if imgui.Button("San Fierro Police Garage") then teleportInterior(PLAYER_PED, -1617.58, 688.69, -4.50, 0) end
						if imgui.Button("Los Santos Cemetery") then teleportInterior(PLAYER_PED, 837.05, -1101.93, 23.98, 0) end
						if imgui.Button("Grove Street") then teleportInterior(PLAYER_PED, 2536.08, -1632.98, 13.79, 0) end
						if imgui.Button("4D casino") then teleportInterior(PLAYER_PED, 1992.93, 1047.31, 10.82, 0) end
						if imgui.Button("LS Hospital") then teleportInterior(PLAYER_PED, 2033.00, -1416.02, 16.99, 0) end
						if imgui.Button("SF Hospital") then teleportInterior(PLAYER_PED, -2653.11, 634.78, 14.45, 0) end
						if imgui.Button("LV Hospital") then teleportInterior(PLAYER_PED, 1580.22, 1768.93, 10.82, 0) end
						if imgui.Button("SF Export") then teleportInterior(PLAYER_PED, -1550.73, 99.29, 17.33, 0) end
					end
				else act4 = 1 end
			end
			imgui.EndChild()

		elseif act1 == 5 then --VISUAL IMGUI
			imgui.BeginChild('5', imgui.ImVec2(855, 370), true)
			if array.lang_menu.v then
				if imgui.Button(fa.ICON_WINDOW_MAXIMIZE .. u8' Ãëàâíîå') then checkTabs = 'zuwi -> Âèçóàëû -> Ãëàâíîå' act5 = 1 end
				imgui.SameLine(nil, x)
				if imgui.Button(fa.ICON_STREET_VIEW .. u8' Èãðîêè') then checkTabs = 'zuwi -> Âèçóàëû -> Èãðîêè' act5 = 2 end
				imgui.SameLine(nil, x)
				if imgui.Button(fa.ICON_CAR .. u8' Òðàíñïîðò') then CheckTabs = 'zuwi -> Âèçóàëû -> Òðàíñïîðò' act5 = 3 end
				imgui.Separator()
				if act5 == 1 then
					imgui.ToggleButton('40', 'Èíôîðìàöèîííàÿ ïàíåëü', array.infbar)
				elseif act5 == 2 then
					imgui.ToggleButton('31', 'Name tag', array.show_imgui_nametag)
				elseif act5 == 3 then
					imgui.ToggleButton('47', 'Òîëüêî êîëåñà', array.show_imgui_onlyWheels)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8'Åñëè Âû íàõîäèòåñü â òðàíñïîðòå')
					imgui.ToggleButton('50', 'Ïðîâåðêà äâåðåé', array.show_imgui_doorlocks)
					imgui.SameLine(nil, x)
					imgui.SliderInt(u8'Äèñòàíöèÿ', array.distDoorLocks, 5, 200)
				end
			elseif not array.lang_menu.v then
				if imgui.Button(fa.ICON_WINDOW_MAXIMIZE ..' Main') then checkTabs = 'zuwi -> Visual -> Main' act5 = 1 end
				imgui.SameLine(nil, x)
				if imgui.Button(fa.ICON_STREET_VIEW ..' Players') then checkTabs = 'zuwi -> Visual -> Players' act5 = 2 end
				imgui.SameLine(nil, x)
				if imgui.Button(fa.ICON_CAR .. u8' Vehicle') then CheckTabs = 'zuwi -> Visual -> Vehicle' act5 = 3 end
				imgui.Separator()
				if act5 == 1 then
					imgui.ToggleButton('40', 'Info bar', array.infbar)
				elseif act5 == 2 then
					imgui.ToggleButton('31', 'Name tag', array.show_imgui_nametag)
				elseif act5 == 3 then
					imgui.ToggleButton('47', 'Only wheels', array.show_imgui_onlyWheels)
					imgui.SameLine(nil, x)
					imgui.TextQuestion('If you are in vehicle')
					imgui.ToggleButton('50', 'Check doors', array.show_imgui_doorlocks)
					imgui.SameLine(nil, x)
					imgui.SliderInt('Distance', array.distDoorLocks, 5, 200)
				else act5 = 1 end
			end
			imgui.EndChild()

		elseif act1 == 6 then --SETTINGS IMGUI
			imgui.BeginChild('6', imgui.ImVec2(855, 370), true)
			if array.lang_menu.v then
				if imgui.Button(fa.ICON_WINDOW_MAXIMIZE .. u8' Ìåíþ') then checkTabs = 'zuwi -> Íàñòðîéêè -> Ìåíþ' act6 = 1 end
				imgui.SameLine(nil, x)
				if imgui.Button(fa.ICON_CLOUD_DOWNLOAD .. u8' Îáíîâëåíèÿ') then checkTabs = 'zuwi -> Íàñòðîéêè -> Îáíîâëåíèÿ' act6 = 2 end
				--imgui.SameLine(nil,x)
				--if imgui.Button(fa.ICON_KEY .. u8' Ãîðÿ÷èå êëàâèøè') then checkTabs = 'zwui -> Íàñòðîéêè -> Ãîðÿ÷èå êëàâèøè' act6 = 3 end
				imgui.Separator()
			elseif not array.lang_menu.v then
				if imgui.Button(fa.ICON_WINDOW_MAXIMIZE ..' Menu') then checkTabs = 'zuwi -> Settings -> Menu' act6 = 1 end
				imgui.SameLine(nil, x)
				if imgui.Button(fa.ICON_CLOUD_DOWNLOAD ..' Updates') then checkTabs = 'zuwi -> Settings -> Updates' act6 = 2 end
				--imgui.SameLine(nil,x)
				--if imgui.Button(fa.ICON_KEY ..' Hotkeys') then checkTabs = 'zwui -> Settings -> Hotkeys' act6 = 3 end
				imgui.Separator()
			end
			if act6 == 1 then
				if array.lang_menu.v then
					imgui.TextColoredRGB('{0984d2}F11 {888EA0}- {0E8604}Âêëþ÷èòü{888EA0}/{B31A06}Âûêëþ÷èòü {C39932}êóðñîð')
					imgui.Spacing()
					imgui.Spacing()
					if imgui.CollapsingHeader(u8'ßçûê') then
						if imgui.ToggleButton('26', 'Ìåíþ', array.lang_menu) then CheckLangMenu = not CheckLangMenu end
						imgui.SameLine(nil, x)
						if imgui.ToggleButton('27', '×àò', array.lang_chat) then CheckLangChat = not CheckLangChat end
						imgui.SameLine(nil, x)
						if imgui.ToggleButton('28', 'Äèàëîãè', array.lang_dialogs) then CheckLangDialogs = not CheckLangDialogs end
						imgui.SameLine(nil, x)
						if imgui.ToggleButton('51', 'Âèçóàëû', array.lang_visual) then CheckLangVisuals = not CheckLangVisuals end
						imgui.TextColoredRGB("{0984d2}Åñëè âêëþ÷åíî, òî ðàáîòàåò íà âñå âêëàäêè êðîìå 'Ñåðâåðû'.")
						imgui.Separator()
					end
					imgui.Spacing() imgui.Spacing() imgui.Spacing()
					imgui.TextColoredRGB('{0984d2}Íàñòðîéêà ñòèëåé:')
				elseif not array.lang_menu.v then
					imgui.TextColoredRGB('{0984d2}F11 {888EA0}- {0E8604}On{888EA0}/{B31A06}Off {C39932}cursor')
					imgui.Spacing()
					imgui.Spacing()
					if imgui.CollapsingHeader('Language') then
						if imgui.ToggleButton('26', 'Menu', array.lang_menu) then CheckLangMenu = not CheckLangMenu end
						imgui.SameLine(nil, x)
						if imgui.ToggleButton('27', 'Chat', array.lang_chat) then CheckLangChat = not CheckLangChat end
						imgui.SameLine(nil, x)
						if imgui.ToggleButton('28', 'Dialogs', array.lang_dialogs) then CheckLangDialogs = not CheckLangDialogs end
						imgui.SameLine(nil, x)
						if imgui.ToggleButton('51', 'Visual', array.lang_visual) then CheckLangVisuals = not CheckLangVisuals end
						imgui.TextColoredRGB("{0984d2}If enabled, it works on all tabs except the 'Servers' tab.")
						imgui.Separator()
					end
					imgui.Spacing() imgui.Spacing() imgui.Spacing()
					imgui.TextColoredRGB('{0984d2}Style settings:')
				end
				local styles = {"Androvira", "Light Blue", "Light Purple"}
				if imgui.Combo("##styleedit", array.comboStyle, styles, imgui.PushItemWidth(120)) then
					mainIni.menu.iStyle = array.comboStyle.v
					setInterfaceStyle(mainIni.menu.iStyle)
				end
				imgui.Spacing()
				imgui.Spacing()
				imgui.Spacing()
				imgui.TextColoredRGB('{0984d2}Config{888EA0}:')
				imgui.Spacing()
				if imgui.Button('Save settings') then
					if not doesFileExist('zuwi.ini') then
						 if inicfg.save(mainIni, 'zuwi.ini') then
							mainIni = {
								actor = {
									infRun = array.show_imgui_infRun.v,
									infSwim = array.show_imgui_infSwim.v,
									infOxygen = array.show_imgui_infOxygen.v,
									suicide = array.show_imgui_suicideActor.v,
									megaJump = array.show_imgui_megajumpActor.v,
									fastSprint = array.show_imgui_fastsprint.v,
									unfreeze = array.show_imgui_unfreeze.v,
									noFall = array.show_imgui_nofall.v,
									GM = array.show_imgui_gmActor.v
								},
								vehicle = {
									flip180 = array.show_imgui_flip180.v,
									flipOnWheels = array.show_imgui_flipOnWheels.v,
									megaJumpBMX = array.show_imgui_megajumpBMX.v,
									hop = array.show_imgui_hopVeh.v,
									boom = array.show_imgui_suicideVeh.v,
									fastExit = array.show_imgui_fastexit.v,
									gmWheels = array.show_imgui_gmWheels.v,
									AntiBikeFall = array.show_imgui_antiBikeFall.v,
									GM = array.show_imgui_gmVeh.v,
									fixWheels = array.show_imgui_fixWheels.v,
									speedhack = array.show_imgui_speedhack.v,
									speedhackMaxSpeed = array.SpeedHackMaxSpeed.v,
									perfectHandling = array.show_imgui_perfectHandling.v,
									allCarsNitro = array.show_imgui_allCarsNitro.v,
									onlyWheels = array.show_imgui_onlyWheels.v,
									tankMode = array.show_imgui_tankMode.v,
									carsFloatWhenHit = array.show_imgui_carsFloatWhenHit.v,
									driveOnWater = array.show_imgui_driveOnWater.v,
									restoreHealth = array.show_imgui_restHealthVeh.v,
									engineOn = array.show_imgui_engineOnVeh.v
								},
								weapon = {
									infAmmo = array.show_imgui_infAmmo.v,
									fullSkills = array.show_imgui_fullskills.v
								},
								misc = {
									FOV = array.show_imgui_FOV.v,
									FOVvalue = array.FOV_value.v,
									antibhop = array.show_imgui_antibhop.v,
									AirBrake = array.show_imgui_AirBrake.v,
									AirBrakeSpeed = array.AirBrake_Speed.v,
									quickMap = array.show_imgui_quickMap.v,
									nameTag = array.show_imgui_nametag.v,
									blink = array.show_imgui_blink.v,
									blinkDist = array.blink_dist.v,
									sensfix = array.show_imgui_sensfix.v,
									clearScreenshot = array.show_imgui_clrScr.v,
									WalkDriveUnderWater = array.show_imgui_UnderWater.v,
									ClickWarp = array.show_imgui_clickwarp.v,
									reconnect = array.show_imgui_reconnect.v
								},
								visual = {
									nameTag = array.show_imgui_nametag.v,
									infoBar = array.infbar.v,
									doorLocks = array.show_imgui_doorlocks.v,
									distanceDoorLocks = array.distDoorLocks.v
								},
								menu = {
									checkUpdate = array.checkupdate.v,
									language_menu = array.lang_menu.v,
									language_chat = array.lang_chat.v,
									language_dialogs = array.lang_dialogs.v,
									language_visual = array.lang_visual.v,
									autoSave = array.AutoSave.v
								},
								admintools = {
									adminChat = array.at_chat.v,
									newCMD = array.at_ncmd.v,
									shortCMD = array.at_scmd.v
								}
							} inicfg.save(mainIni, 'zuwi.ini')
							if array.lang_chat.v then sampAddChatMessage(tag..'Íàñòðîéêè {0E8604}óñïåøíî{888EA0} ñîõðàíåíû', main_color)
							elseif not array.lang_chat.v then sampAddChatMessage(tag..'Settings {0E8604}successfully{888EA0} save', main_color) end
						else
							if array.lang_chat.v then sampAddChatMessage(tag..'Íàñòðîéêè {B31A06}íå óñïåøíî{888EA0} ñîõðàíåíû', main_color)
							elseif array.lang_chat.v then sampAddChatMessage(tag..'Settings {B31A06}not successfully {888EA0}save', main_color) end
						end
					else
						if inicfg.save(mainIni, 'zuwi.ini') then
							if array.lang_chat.v then sampAddChatMessage(tag..'Íàñòðîéêè {0E8604}óñïåøíî{888EA0} ñîõðàíåíû', main_color)
							elseif not array.lang_chat.v then sampAddChatMessage(tag..'Settings {0E8604}successfully{888EA0} save', main_color) end
						else
							if array.lang_chat.v then sampAddChatMessage(tag..'Íàñòðîéêè {B31A06}íå óñïåøíî{888EA0} ñîõðàíåíû', main_color)
							elseif not array.lang_chat.v then sampAddChatMessage(tag..'Settings {B31A06}not successfully {888EA0}save', main_color) end
						end
					end
				end
				imgui.SameLine(nil, x)
				if not array.lang_menu.v then imgui.ToggleButton('29', 'Auto save', array.AutoSave)
				elseif array.lang_menu.v then imgui.ToggleButton('29', 'Àâòîñîõðàíåíèå', array.AutoSave) end
				imgui.Spacing()
				imgui.Spacing()
				imgui.Spacing()
				if not array.lang_menu.v then
					imgui.TextColoredRGB('{0984d2}Contacts{888EA0}:')
					imgui.TextColoredRGB('{888EA0}Telegram: {0E8604}https://t.me/panseek')
					imgui.TextColoredRGB('{888EA0}VK group: {0E8604}https://vk.com/creationpanseek')
					imgui.TextColoredRGB('{888EA0}Topic on Blast.Hack: {0E8604}https://www.blast.hk/threads/66295')
					imgui.TextColoredRGB('{888EA0}Donate: {0E8604}https://www.donationalerts.com/r/panseek')
				elseif array.lang_menu.v then
					imgui.TextColoredRGB('{0984d2}Êîíòàêòû{888EA0}:')
					imgui.TextColoredRGB('{888EA0}Telegram: {0E8604}https://t.me/panseek')
					imgui.TextColoredRGB('{888EA0}VK ãðóïïà: {0E8604}https://vk.com/creationpanseek')
					imgui.TextColoredRGB('{888EA0}Òåìà íà Blast.Hack: {0E8604}https://www.blast.hk/threads/66295')
					imgui.TextColoredRGB('{888EA0}Ïîæåðòâîâàíèÿ: {0E8604}https://www.donationalerts.com/r/panseek')
				end
			elseif act6 == 2 then
				if not array.lang_menu.v then
					imgui.ToggleButton('30', 'Check update', array.checkupdate)
					imgui.SameLine(nil, x)
					if imgui.Button('Download last update') then
						downloadUrlToFile('https://raw.githubusercontent.com/PanSeek/zuwi/master/zuwi.lua', 'moonloader/zuwi.lua')
						if array.lang_chat.v then sampAddChatMessage(tag..'Îáíîâëåíèå {0E8604}çàãðóæåíî', main_color)
						elseif not array.lang_chat.v then sampAddChatMessage(tag..'Update {0E8604}download', main_color) end
					end
					imgui.Spacing()
					if imgui.CollapsingHeader('List updates') then
						imgui.Indent(10)
						if imgui.CollapsingHeader('21.10.2020 - v1.1') then
							imgui.TextColoredRGB('{888EA0}Added {C39932}"Check doors" {888EA0}function to {C39932}"Visuals" {888EA0}-> {C39932}"Vehicle"')
							imgui.TextColoredRGB('{888EA0}Added language change for {C39932}"Visuals"')
							imgui.TextColoredRGB('{888EA0}Function {C39932}"Weapons" {888EA0}-> {C39932}"Full aiming" {888EA0}changed name to {C39932}"Full skill"')
							imgui.TextColoredRGB('{888EA0}The function {C39932}"Vehicle" {888EA0}-> {C39932}"Only wheels" {888EA0}moved to the tab {C39932}"Visuals" {888EA0}-> {C39932}"Vehicle"')
							imgui.TextColoredRGB('{888EA0}Fixed function {C39932}"Misc" {888EA0}-> {C39932}"FOV changer"')
							imgui.TextColoredRGB('{888EA0}Fixed function {C39932}"Vehicle" {888EA0}-> {C39932}"SpeedHack"')
							imgui.TextColoredRGB('{888EA0}Fixed function {C39932}"Vehicle" {888EA0}-> {C39932}"Flip on wheels"')
							imgui.TextColoredRGB('{888EA0}Fixed autoupdate')
						end
						if imgui.CollapsingHeader('16.10.2020 - v1.0') then
							imgui.TextColoredRGB('{888EA0}Added functions to {C39932}"Transport"{888EA0}: {C39932}All vehicles have nitro{888EA0}; {C39932}Wheels only{888EA0}; {C39932}Tank mod{888EA0}; {C39932}Vehicle float when hit')
							imgui.TextColoredRGB('{888EA0}Added contacts to {C39932}"Settings"')
							imgui.TextColoredRGB('{888EA0}Removed the {C39932}/z_at {888EA0}(functionality without this command is now available)')
							imgui.TextColoredRGB('{888EA0}Minor fixes and improvements')
						end
						if imgui.CollapsingHeader('13.10.2020 - v0.928') then
							imgui.TextColoredRGB('{C39932}Release')
						end
						imgui.Unindent(10)
					end
				elseif array.lang_menu.v then
					imgui.ToggleButton('30', 'Ïðîâåðêà îáíîâëåíèé', array.checkupdate)
					imgui.SameLine(nil, x)
					if imgui.Button(u8'Ñêà÷àòü ïîñëåäíåå îáíîâëåíèå') then
						downloadUrlToFile('https://raw.githubusercontent.com/PanSeek/zuwi/master/zuwi.lua', 'moonloader/zuwi.lua')
						if array.lang_chat.v then sampAddChatMessage(tag..'Îáíîâëåíèå {0E8604}çàãðóæåíî', main_color)
						elseif not array.lang_chat.v then sampAddChatMessage(tag..'Update {0E8604}download', main_color) end
					end
					imgui.Spacing()
					if imgui.CollapsingHeader(u8'Ñïèñîê îáíîâëåíèé') then
						imgui.Indent(10)
						if imgui.CollapsingHeader('21.10.2020 - v1.1') then
							imgui.TextColoredRGB('{888EA0}Äîáàâëåíà ôóíêöèÿ {C39932}"Ïðîâåðêà äâåðåé" {888EA0}â {C39932}"Âèçóàëû" {888EA0}-> {C39932}"Òðàíñïîðò"')
							imgui.TextColoredRGB('{888EA0}Äîáàâëåíà ñìåíà ÿçûêà äëÿ {C39932}"Âèçóàëû"')
							imgui.TextColoredRGB('{888EA0}Ôóíêöèÿ {C39932}"Îðóæèÿ" {888EA0}-> {C39932}"Ïîëíîå ïðèöåëèâàíèå" {888EA0}èçìåíèëî íàçâàíèå íà {C39932}"Ïîëíîå óìåíèå"')
							imgui.TextColoredRGB('{888EA0}Ôóíêöèÿ {C39932}"Òðàíñïîðò" {888EA0}-> {C39932}"Òîëüêî êîëåñà" {888EA0}ïåðåíåñåíà âî âêëàäêó {C39932}"Âèçóàëû" {888EA0}-> {C39932}"Òðàíñïîðò"')
							imgui.TextColoredRGB('{888EA0}Èñïðàâëåíà ôóíêöèÿ {C39932}"Ðàçíîå" {888EA0}-> {C39932}"Ïîëå çðåíèå"')
							imgui.TextColoredRGB('{888EA0}Èñïðàâëåíà ôóíêöèÿ {C39932}"Òðàíñïîðò" {888EA0}-> {C39932}"SpeedHack"')
							imgui.TextColoredRGB('{888EA0}Èñïðàâëåíà ôóíêöèÿ {C39932}"Òðàíñïîðò" {888EA0}-> {C39932}"Ïåðåâîðîò íà êîëåñà"')
							imgui.TextColoredRGB('{888EA0}Èñïðàâëåíî àâòîîáíîâëåíèå')
						end
						if imgui.CollapsingHeader('16.10.2020 - v1.0') then
							imgui.TextColoredRGB('{888EA0}Äîáàâëåíû ôóíêöèè â {C39932}"Òðàíñïîðò"{888EA0}: {C39932}"Ó âñåãî òðàíñïîðòà íèòðî"{888EA0}; {C39932}"Òîëüêî êîëåñà"{888EA0}; {C39932}"Òàíê ìîä"{888EA0}; {C39932}"Òðàíñïîðò îòëåòàåò åñëè â íåãî ñòðåëüíóòü"')
							imgui.TextColoredRGB('{888EA0}Äîáàâëåíû êîíòàêòû â {C39932}"Íàñòðîéêè"')
							imgui.TextColoredRGB('{888EA0}Óáðàíà êîìàíäà {C39932}/z_at {888EA0}(òåïåðü äîñòóïåí ôóíêöèîíàë áåç äàííîé êîìàíäû)')
							imgui.TextColoredRGB('{888EA0}Ìåëêèå èñïðàâëåíèÿ è äîðàáîòêè')
						end
						if imgui.CollapsingHeader('13.10.2020 - v0.928') then
							imgui.TextColoredRGB('{C39932}Ðåëèç')
						end
						imgui.Unindent(10)
					end
				end
			--[[elseif act6 == 3 then
				if not array.lang_menu.v then
				elseif array.lang_menu.v then
				end]]--
			else act6 = 1 end
			imgui.EndChild()

		elseif act1 == 8 then --HELP IMGUI
			imgui.BeginChild('8', imgui.ImVec2(855, 370), true)
			if array.lang_menu.v then
				if imgui.CollapsingHeader(u8'Êîìàíäû') then
					imgui.TextColoredRGB('{C39932}/z_help {888EA0}- Ïîìîùü ïî ñêðèïòó')
					imgui.TextColoredRGB('{C39932}/z_authors {888EA0}- Àâòîðñòâî è áëàãîäàðíîñòè')
					imgui.TextColoredRGB('{C39932}/z_date {888EA0}- Ñåãîäíÿøíÿÿ äàòà')
					imgui.TextColoredRGB('{C39932}/z_menu {888EA0}- {0984d2}Îòêðûòèå/Çàêðûòèå {888EA0}ìåíþ')
					imgui.TextColoredRGB('{C39932}/z_coord {888EA0}- Îòìå÷àåò Âàøè êîîðäèíàòû')
					imgui.TextColoredRGB('{C39932}/z_getmoney {888EA0}- Âûäàåò 1.000$ ({B31A06}Âèçóàëüíî{888EA0})')
					imgui.TextColoredRGB('{C39932}/z_fakerepair {888EA0}- ×èíèò òðàíñïîðò ({B31A06}Äëÿ Revent-Rp{888EA0})')
					imgui.TextColoredRGB('{C39932}/z_togall {888EA0}- {0984d2}Âûêëþ÷àåò/Âêëþ÷àåò {888EA0}âñå ÷àòû êîòîðûå âîçìîæíî ({B31A06}Äëÿ Revent-Rp{888EA0})')
					imgui.TextColoredRGB('{C39932}/z_time {888EA0}- Ïîìåíÿòü âðåìÿ')
					imgui.TextColoredRGB('{C39932}/z_weather {888EA0}- Ïîìåíÿòü ïîãîäó')
					imgui.TextColoredRGB('{C39932}/z_setmark {888EA0}- Ïîñòàâèòü ìåòêó')
					imgui.TextColoredRGB('{C39932}/z_tpmark {888EA0}- Òåëåïîðòèðîâàòüñÿ ê ìåòêå')
					imgui.TextColoredRGB('{C39932}/z_cc {888EA0}- Î÷èñòêà ÷àòà')
					imgui.TextColoredRGB('{C39932}/z_version {888EA0}- Âåðñèÿ ñêðèïòà')
					imgui.TextColoredRGB('{C39932}/z_update {888EA0}- Îáíîâèòü ñêðèïò')
					imgui.TextColoredRGB('{C39932}/z_checktime {888EA0}- Òî÷íîå âðåìÿ ïî ÌÑÊ')
					imgui.TextColoredRGB('{C39932}/z_suicide {888EA0}- Ñóèöèä (Åñëè â òðàíñïîðòå, òî âçðûâàåò òðàíñïîðò. Åñëè ïåøêîì, òî óáèâàåò Âàñ)')
					imgui.TextColoredRGB('{C39932}/z_errors {888EA0}- Ñïèñîê îøèáîê')
					imgui.TextColoredRGB('{C39932}/z_cmdsamp {888EA0}- Ñïèñîê êîìàíä SA-MP')
					imgui.TextColoredRGB('{C39932}/z_reload {888EA0}- Ïåðåçàãðóæàåò äàííûé ñêðèïò')
					imgui.TextColoredRGB('{C39932}/z_fps {888EA0}- Âûâîäèò FPS')
				end
				if imgui.CollapsingHeader(u8'Îøèáêè') then
					imgui.TextColoredRGB('{B31A06}#1 {888EA0}- {C39932}Âàø èãðîê ìåðòâ/íå ñóùåñòâóåò')
					imgui.TextColoredRGB('{B31A06}#2 {888EA0}- {C39932}Âàø èãðîê íå â òðàíñïîðòå')
					imgui.TextColoredRGB('{B31A06}#3 {888EA0}- {C39932}Îòêðûò èãðîâîé ÷àò')
					imgui.TextColoredRGB('{B31A06}#4 {888EA0}- {C39932}Îòêðûò SampFuncs ÷àò')
					imgui.TextColoredRGB('{B31A06}#5 {888EA0}- {C39932}Îòêðûò äèàëîã')
					imgui.TextColoredRGB('{B31A06}#6 {888EA0}- {C39932}Âàø èãðîê ìåðòâ/íå ñóùåñòâóåò èëè íå â òðàíñïîðòå')
					imgui.TextColoredRGB('{B31A06}#7 {888EA0}- {C39932}Ó Âàñ îòêðûò èãðîâîé ÷àò/SampFuncs ÷àò/äèàëîã')
					imgui.TextColoredRGB('{B31A06}#8 {888EA0}- {C39932}Âàø èãðîê íå â òðàíñïîðòå èëè ó Âàñ îòêðûò èãðîâîé ÷àò/SampFuncs ÷àò/äèàëîã')
					imgui.TextColoredRGB('{B31A06}#9 {888EA0}- {C39932}Âàø èãðîê ìåðòâ/íå ñóùåñòâóåò èëè ó Âàñ îòêðûò èãðîâîé ÷àò/SampFuncs ÷àò/äèàëîã')
					imgui.TextColoredRGB('{B31A06}#10 {888EA0}- {C39932}Òðàíñïîðò íå íàéäåí')
					imgui.TextColoredRGB('{B31A06}#11 {888EA0}- {C39932}Óæå îòêðûò äðóãîé äèàëîã')
					imgui.TextColoredRGB('{B31A06}#12 {888EA0}- {C39932}Âðåìÿ íå íàéäåíî')
					imgui.TextColoredRGB('{B31A06}#13 {888EA0}- {C39932}Ïîãîäà íå íàéäåíà')
					imgui.TextColoredRGB('{B31A06}#14 {888EA0}- {C39932}Ìåòêà íå ñîçäàíà')
					imgui.TextColoredRGB('{B31A06}#15 {888EA0}- {C39932}Âû íàõîäèòåñü â èíòåðüåðå')
				end
				if imgui.CollapsingHeader(u8'Àâòîðñòâî è áëàãîäàðíîñòè') then
					imgui.TextColoredRGB('{B31A06}PanSeek {888EA0}- {C39932}Ñîçäàòåëü')
					imgui.Spacing()
					imgui.CenterTextColoredRGB('{0E8604}Áëàãîäàðíîñòè{888EA0}:')
					imgui.TextColoredRGB('{B31A06}fran9 {888EA0}- {C39932}Ïîìîãàë ñ öâåòàìè/ðàñïîëîæåíèåì ìåíþ/AdminTools äëÿ Revent-RP')
					imgui.TextColoredRGB('{B31A06}FBenz {888EA0}- {C39932}Ïîìîãàë â íåêîòîðûõ âîïðîñàõ/ñîâåòîâàë')
					imgui.TextColoredRGB('{B31A06}qrlk {888EA0}- {C39932}Àâòîîáíîâëåíèå')
					imgui.TextColoredRGB('{B31A06}FYP {888EA0}- {C39932}Èñõîäíûé êîä')
					imgui.TextColoredRGB('{B31A06}cover {888EA0}- {C39932}Èñõîäíûé êîä')
					imgui.Spacing()
					imgui.TextColoredRGB('{0E8604}À òàêæå ñïàñèáî âñåì, êòî òåñòèðîâàë ñêðèïò è ñîîáùàë î íåêîòîðûõ ïðîáëåìàõ/áàãàõ')
				end
			elseif not array.lang_menu.v then
				if imgui.CollapsingHeader('Commands') then
					imgui.TextColoredRGB('{C39932}/z_help {888EA0}- Script help')
					imgui.TextColoredRGB('{C39932}/z_authors {888EA0}- Authors and thanks')
					imgui.TextColoredRGB('{C39932}/z_date {888EA0}- Todays date')
					imgui.TextColoredRGB('{C39932}/z_menu {888EA0}- {0984d2}Open/Close {888EA0}menu')
					imgui.TextColoredRGB('{C39932}/z_coord {888EA0}- You are coords')
					imgui.TextColoredRGB('{C39932}/z_getmoney {888EA0}- Give cash 1.000$ ({B31A06}Visual{888EA0})')
					imgui.TextColoredRGB('{C39932}/z_fakerepair {888EA0}- Repair vehicle ({B31A06}For Revent-Rp{888EA0})')
					imgui.TextColoredRGB('{C39932}/z_togall {888EA0}- {0984d2}On/Off {888EA0}on all chats that are possible ({B31A06}For Revent-Rp{888EA0})')
					imgui.TextColoredRGB('{C39932}/z_time {888EA0}- Change time')
					imgui.TextColoredRGB('{C39932}/z_weather {888EA0}- Change weather')
					imgui.TextColoredRGB('{C39932}/z_setmark {888EA0}- Create mark')
					imgui.TextColoredRGB('{C39932}/z_tpmark {888EA0}- Teleport to mark')
					imgui.TextColoredRGB('{C39932}/z_cc {888EA0}- Clear chat')
					imgui.TextColoredRGB('{C39932}/z_version {888EA0}- Version script')
					imgui.TextColoredRGB('{C39932}/z_update {888EA0}- Update script')
					imgui.TextColoredRGB('{C39932}/z_checktime {888EA0}- Exact time by MSK')
					imgui.TextColoredRGB('{C39932}/z_suicide {888EA0}- Suicide (If you are in vehicle, then boom vehicle. If walking, it kills you)')
					imgui.TextColoredRGB('{C39932}/z_errors {888EA0}- List errors')
					imgui.TextColoredRGB('{C39932}/z_cmdsamp {888EA0}- List commands SA-MP')
					imgui.TextColoredRGB('{C39932}/z_reload {888EA0}- Reload this is script')
					imgui.TextColoredRGB('{C39932}/z_fps {888EA0}- Displays FPS')
				end
				if imgui.CollapsingHeader('Errors') then
					imgui.TextColoredRGB('{B31A06}#1 {888EA0}- {C39932}You player is dead/not playing')
					imgui.TextColoredRGB('{B31A06}#2 {888EA0}- {C39932}You are player is not in vehicle')
					imgui.TextColoredRGB('{B31A06}#3 {888EA0}- {C39932}Open game chat')
					imgui.TextColoredRGB('{B31A06}#4 {888EA0}- {C39932}Open SampFuncs chat')
					imgui.TextColoredRGB('{B31A06}#5 {888EA0}- {C39932}Open dialog')
					imgui.TextColoredRGB('{B31A06}#6 {888EA0}- {C39932}You are player is dead/not playing or is not in vehicle')
					imgui.TextColoredRGB('{B31A06}#7 {888EA0}- {C39932}Open game chat/SampFuncs chat/dialog')
					imgui.TextColoredRGB('{B31A06}#8 {888EA0}- {C39932}You are player is not in vehicle or ppen game chat/SampFuncs chat/dialog')
					imgui.TextColoredRGB('{B31A06}#9 {888EA0}- {C39932}You are player is dead/not playing or ppen game chat/SampFuncs chat/dialog')
					imgui.TextColoredRGB('{B31A06}#10 {888EA0}- {C39932}Vehicle not found')
					imgui.TextColoredRGB('{B31A06}#11 {888EA0}- {C39932}Another open dialog')
					imgui.TextColoredRGB('{B31A06}#12 {888EA0}- {C39932}Time not found')
					imgui.TextColoredRGB('{B31A06}#13 {888EA0}- {C39932}Weather not found')
					imgui.TextColoredRGB('{B31A06}#14 {888EA0}- {C39932}Mark not create')
					imgui.TextColoredRGB('{B31A06}#15 {888EA0}- {C39932}You are in the interior')
				end
				if imgui.CollapsingHeader('Authors and thanks') then
					imgui.TextColoredRGB('{B31A06}PanSeek {888EA0}- {C39932}Creator')
					imgui.Spacing()
					imgui.CenterTextColoredRGB('{0E8604}Thanks{888EA0}:')
					imgui.TextColoredRGB('{B31A06}fran9 {888EA0}- {C39932}Helped with colors/location menu/AdminTools for Revent-RP')
					imgui.TextColoredRGB('{B31A06}FBenz {888EA0}- {C39932}Helped in some questions/advised')
					imgui.TextColoredRGB('{B31A06}qrlk {888EA0}- {C39932}Autoupdate')
					imgui.TextColoredRGB('{B31A06}FYP {888EA0}- {C39932}Source')
					imgui.TextColoredRGB('{B31A06}cover {888EA0}- {C39932}Source')
					imgui.Spacing()
					imgui.TextColoredRGB('{0E8604}And also thanks to everyone who tested the script and reported some problems/bugs')
				end
			end
			imgui.EndChild()

		elseif act1 == 9 then --REVENT-RP IMGUI
			imgui.BeginChild('9', imgui.ImVec2(855, 370), true)
			if imgui.Button(fa.ICON_LOCATION_ARROW .. u8' Òåëåïîðòû') then checkTabs = 'zuwi -> Revent-RP -> Òåëåïîðòû' act9 = 1 end
			imgui.SameLine(nil, x)
			if imgui.Button(fa.ICON_ADDRESS_CARD ..' Admin Tools') then checkTabs = 'zuwi -> Revent-RP -> Admin Tools' act9 = 2 end
			imgui.Separator()
			if act9 == 1 then
				if imgui.CollapsingHeader(u8'Ôðàêöèè è îðãàíèçàöèè') then
					imgui.Indent(15)
					if imgui.CollapsingHeader(u8'Èíòåðüåðû') then
						imgui.Columns(3)
						if imgui.Button('LSPD') then teleportInterior(PLAYER_PED,2633.8281,1054.9259,1025.7860,10) end
						if imgui.Button('SFPD') then teleportInterior(PLAYER_PED,2631.7517,1052.0356,1025.7860,10) end
						if imgui.Button('LVPD') then teleportInterior(PLAYER_PED,2632.2693,1053.0416,1025.7860,10) end
						if imgui.Button(u8'Áîëüíèöà LS') then teleportInterior(PLAYER_PED,1389.7893,-18.2846,1000.9153,1) end
						if imgui.Button(u8'Áîëüíèöà SF') then teleportInterior(PLAYER_PED,1993.3247,1828.4985,1036.4240,1) end
						if imgui.Button(u8'Áîëüíèöà LV') then teleportInterior(PLAYER_PED,-2149.7686,678.9402,1000.8959,1) end
						if imgui.Button(u8'ÔÁÐ') then teleportInterior(PLAYER_PED,-807.6865,-286.6179,994.1849,15) end
						if imgui.Button(u8'Ïðàâèòåëüñòâî') then teleportInterior(PLAYER_PED,2545.4111,1179.0635,1041.9678,3) end
						imgui.NextColumn()
						if imgui.Button('Radio LS') then teleportInterior(PLAYER_PED,1906.0597,-4.9029,1000.9819,1) end
						if imgui.Button('Radio LV') then teleportInterior(PLAYER_PED,911.8922,1464.3600,999.5259,1) end
						if imgui.Button(u8'Àâòîøêîëà') then teleportInterior(PLAYER_PED,1907.9076,1772.4630,1044.3833,1) end
						if imgui.Button(u8'Îòäåë ëèöåíçèðîâàíèÿ') then teleportInterior(PLAYER_PED,-54.1390,1379.4974,943.4575,100) end
						if imgui.Button(u8'Íàö. ãâàðäèÿ') then teleportInterior(PLAYER_PED,-1833.1125,1920.4862,918.4860,1) end
						if imgui.Button(u8'Ðóññêàÿ ìàôèÿ') then teleportInterior(PLAYER_PED,2.5189,2279.8877,947.1949,2) end
						if imgui.Button(u8'ßêóäçà') then teleportInterior(PLAYER_PED,1356.0793,2.4012,932.7360,5) end
						if imgui.Button('Aztecas') then teleportInterior(PLAYER_PED,1400.1066,948.5361,940.6245,15) end
						imgui.NextColumn()
						if imgui.Button('Grove') then teleportInterior(PLAYER_PED,-32.1703,-18.1900,1003.5374,3) end
						if imgui.Button('Ballas') then teleportInterior(PLAYER_PED,369.8038,116.5514,1510.8972,8) end
						if imgui.Button('Vagos') then teleportInterior(PLAYER_PED,951.9052,947.2039,950.6279,6) end
						if imgui.Button('Rifa') then teleportInterior(PLAYER_PED,861.1476,-29.0339,1001.2050,3) end
						if imgui.Button('Comrades MC') then teleportInterior(PLAYER_PED,688.0435,-477.7151,3001.0859,1) end
						if imgui.Button('Warlock MC') then teleportInterior(PLAYER_PED,-851.0549,1528.1084,3029.6042,1) end
					end
					imgui.Columns(1)
					if imgui.CollapsingHeader(u8'Âîçëå èíòåðüåðà') then
						imgui.Columns(3)
						if imgui.Button('LSPD') then teleportInterior(PLAYER_PED, 1543.4442, -1675.2795, 13.5565, 0) end
						if imgui.Button('SFPD') then teleportInterior(PLAYER_PED,-1606.9584,720.8036,12.2308,0) end
						if imgui.Button('LVPD') then teleportInterior(PLAYER_PED,2287.3582,2421.3423,10.8203,0) end
						if imgui.Button(u8'Áîëüíèöà LS') then teleportInterior(PLAYER_PED, 1178.7211, -1326.7101, 14.1560, 0) end
						if imgui.Button(u8'Áîëüíèöà SF') then teleportInterior(PLAYER_PED,-2662.2585,625.6224,14.4531,0) end
						if imgui.Button(u8'Áîëüíèöà LV') then teleportInterior(PLAYER_PED,1632.9490,1821.7103,10.8203,0) end
						if imgui.Button(u8'ÔÁÐ') then teleportInterior(PLAYER_PED,1046.4518,1026.6058,10.9978,0) end
						if imgui.Button(u8'Ïðàâèòåëüñòâî') then teleportInterior(PLAYER_PED, 1407.8854,-1788.0032,13.5469,0) end
						imgui.NextColumn()
						if imgui.Button('Radio LS') then teleportInterior(PLAYER_PED, 760.8872,-1358.9816,13.5198,0) end
						if imgui.Button('Radio LV') then teleportInterior(PLAYER_PED,947.7136,1743.1909,8.8516,0) end
						if imgui.Button(u8'Àâòîøêîëà') then teleportInterior(PLAYER_PED, -2037.7787,-99.7488,35.1641,0) end
						if imgui.Button(u8'Îòäåë ëèöåíçèðîâàíèÿ') then teleportInterior(PLAYER_PED,1910.5309,2343.3171,10.8203,0) end
						if imgui.Button(u8'Íàö. ãâàðäèÿ') then teleportInterior(PLAYER_PED, 312.4188,1959.1595,17.6406, 0) end
						if imgui.Button(u8'Ðóññêàÿ ìàôèÿ') then teleportInterior(PLAYER_PED, -2723.7395,-313.8499,7.1860,0) end
						if imgui.Button(u8'ßêóäçà') then teleportInterior(PLAYER_PED, 1492.9370,724.5159,10.8203,0) end
						if imgui.Button('Aztecas') then teleportInterior(PLAYER_PED, 1673.0597,-2113.4204,13.5469,0) end
						imgui.NextColumn()
						if imgui.Button('Grove') then teleportInterior(PLAYER_PED, 2493.1980,-1673.9980,13.3359,0) end
						if imgui.Button('Ballas') then teleportInterior(PLAYER_PED, 2629.8752,-1077.4902,69.6170,0) end
						if imgui.Button('Vagos') then teleportInterior(PLAYER_PED, 2658.0203,-1991.8776,13.5546,0) end
						if imgui.Button('Rifa') then teleportInterior(PLAYER_PED, 2179.6760,-1001.7764,62.9305,0) end
						if imgui.Button('Comrades MC') then teleportInterior(PLAYER_PED, 157.9299,-172.9156,1.5781,0) end
						if imgui.Button('Warlock MC') then teleportInterior(PLAYER_PED, -862.3333,1539.7640,22.5562,0) end
					end
					imgui.Unindent(15)
					imgui.Columns(1)
				end
				imgui.Spacing()
				if imgui.CollapsingHeader(u8'Ðàáîòû') then
					imgui.Columns(2)
					if imgui.Button(u8'Íåôòÿííàÿ âûøêà') then teleportInterior(PLAYER_PED,815.8508,604.5477,11.8305,0) end
					if imgui.Button(u8'Ãðóç÷èê') then teleportInterior(PLAYER_PED,2788.3308,-2437.6555,13.6335,0) end
					if imgui.Button(u8'Àâòîöåõ') then teleportInterior(PLAYER_PED,-49.9263,-277.9673,5.4297,0) end
					if imgui.Button(u8'Àâòîöåõ (Èíòåðüåð)') then teleportInterior(PLAYER_PED,-570.5103,-82.4685,3001.0859,1) end
					imgui.NextColumn()
					if imgui.Button(u8'Äàëüíîáîéùèê') then teleportInterior(PLAYER_PED,-504.6666,-545.2240,25.5234,0) end
					if imgui.Button(u8'Ëåñîðóá') then teleportInterior(PLAYER_PED,-555.8159,-189.0762,78.4063,0) end
					if imgui.Button(u8'Ìîéùèê óëèö') then teleportInterior(PLAYER_PED,-2586.7097,608.1636,14.4531,0) end
					if imgui.Button(u8'Èíêàñàòîð') then teleportInterior(PLAYER_PED,2168.6331,998.6193,10.8203,0) end
				end
				imgui.Columns(1)
				imgui.Spacing()
				if imgui.CollapsingHeader(u8'Îñòàëüíûå òåëåïîðòû') then
					imgui.Indent(15)
					if imgui.CollapsingHeader(u8'Èíòåðüåðû ') then
						imgui.Columns(3)
						if imgui.Button(u8'Ñòàðûé äåìîðãàí') then teleportInterior(PLAYER_PED,1281.1638,-1.8006,1001.0133,18) end
						if imgui.Button(u8'Áàíê') then teleportInterior(PLAYER_PED,1463.0361,-1009.3804,34.4652,0) end
						if imgui.Button(u8'Áèðæà òðóäà') then teleportInterior(PLAYER_PED,1561.1443,-1518.2223,3001.5188,15) end
						if imgui.Button(u8'×åðíûé ðûíîê') then teleportInterior(PLAYER_PED,1696.5221,-1586.8097,2875.2939,1) end
						if imgui.Button(u8'×åðíûé ðûíîê (ïðîïóñê)') then teleportInterior(PLAYER_PED,1569.4727,1230.9999,1055.1804,1) end
						imgui.NextColumn()
						if imgui.Button(u8'Àâòîñàëîí') then teleportInterior(PLAYER_PED,2489.1558,-1017.1227,1033.1460,1) end
						if imgui.Button(u8'Äåïàðòàìåíò àäìèíèñòðàöèè') then teleportInterior(PLAYER_PED,-265.7054,725.4685,1000.0859,5) end
						if imgui.Button(u8'Âîåíêîìàò') then teleportInterior(PLAYER_PED,223.4714,1540.9908,3001.0859,1) end
						if imgui.Button(u8'Êàçèíî') then teleportInterior(PLAYER_PED,1888.7018,1049.5775,996.8770,1) end
						if imgui.Button(u8'Êàçèíî-ìèíè') then teleportInterior(PLAYER_PED,1411.5062,-586.6498,1607.3579,1) end
						imgui.NextColumn()
						if imgui.Button(u8'Òðåíèðîâî÷íûé êîìëïåêñ') then teleportInterior(PLAYER_PED,2365.9114,-1943.3044,919.4700,1) end
						if imgui.Button(u8'Ñîñòÿçàòåëüíàÿ àðåíà') then teleportInterior(PLAYER_PED,825.7631,-1578.9291,3001.0823,3) end
						if imgui.Button(u8'Òèð') then teleportInterior(PLAYER_PED,285.8546,-78.9205,1001.5156,4) end
						if imgui.Button(u8'Òîðãîâûé öåíòð') then teleportInterior(PLAYER_PED,1359.7142,-27.9618,1000.9163,1) end
						if imgui.Button(u8'Ñòðàõîâàÿ') then teleportInterior(PLAYER_PED,1707.3676,636.4663,3001.0859,1) end
					end
					imgui.Columns(1)
					if imgui.CollapsingHeader(u8'Îñòàëüíîå') then
						imgui.Columns(3)
						if imgui.Button(u8'Ìàÿê') then teleportInterior(PLAYER_PED,154.9556,-1939.6304,3.7734,0) end
						if imgui.Button(u8'Êîëåñî îáîçðåíèÿ') then teleportInterior(PLAYER_PED,381.6406,-2044.5220,7.8359,0) end
						if imgui.Button(u8'Áàíê') then teleportInterior(PLAYER_PED,1457.3635,-1027.2981,23.8281,0) end
						if imgui.Button(u8'×èëëèàä') then teleportInterior(PLAYER_PED,-2242.5701,-1731.3767,480.3250,0) end
						if imgui.Button(u8'Áèðæà òðóäà') then teleportInterior(PLAYER_PED,554.2763,-1500.1908,14.5191,0) end
						if imgui.Button(u8'×åðíûé ðûíîê') then teleportInterior(PLAYER_PED,341.1162,-97.6198,1.4143,0) end
						if imgui.Button(u8'Àâòîñàëîí') then teleportInterior(PLAYER_PED,-2447.2839,750.6021,35.1719,0) end
						if imgui.Button(u8'ÁÓ ðûíîê') then teleportInterior(PLAYER_PED,1492.5591,2809.7349,10.8203,0) end
						if imgui.Button(u8'ÆÄËÑ') then teleportInterior(PLAYER_PED,1707.0590,-1895.5723,13.5685,0) end
						if imgui.Button(u8'ÆÄÑÔ') then teleportInterior(PLAYER_PED,-1975.0864,141.7100,27.6873,0) end
						if imgui.Button(u8'ÆÄËÂ') then teleportInterior(PLAYER_PED,2839.9119,1286.1318,11.3906,0) end
						if imgui.Button(u8'Êëàäáèùå LS') then teleportInterior(PLAYER_PED,936.1039,-1101.4722,24.3431,0) end
						imgui.NextColumn()
						if imgui.Button(u8'Òîðãîâûé öåíòð') then teleportInterior(PLAYER_PED,1306.2538,-1331.6825,13.6422,0) end
						if imgui.Button(u8'Ñòðàõîâàÿ') then teleportInterior(PLAYER_PED,2129.5217,-1139.7073,25.2925,0) end
						if imgui.Button(u8'Àðåíäà àâòî LS') then teleportInterior(PLAYER_PED,568.2047,-1290.3613,17.2422,0) end
						if imgui.Button(u8'Àðåíäà àâòî SF') then teleportInterior(PLAYER_PED,-1972.5128,257.3625,35.1719,0) end
						if imgui.Button(u8'Àðåíäà àâòî LV') then teleportInterior(PLAYER_PED,2257.1780,2033.8057,10.8203,0) end
						if imgui.Button(u8'Àðåíäà àâòî LV (Âîçëå êàçèíî)') then teleportInterior(PLAYER_PED,1897.5586,949.3096,10.8203,0) end
						if imgui.Button(u8'Êàðüåð') then teleportInterior(PLAYER_PED,626.8690,853.0729,-42.9609,0) end
						if imgui.Button(u8'Àâòîñåðâèñ') then teleportInterior(PLAYER_PED,617.2724,-1520.0159,15.2100,0) end
						if imgui.Button(u8'Äåïàðòàìåíò àäìèíèñòðàöèè') then teleportInterior(PLAYER_PED,635.7059,-565.4893,16.3359,0) end
						if imgui.Button(u8'Âîåíêîìàò') then teleportInterior(PLAYER_PED,-2449.4761,498.7346,30.0873,0) end
						if imgui.Button(u8'Êàçèíî') then teleportInterior(PLAYER_PED,2031.1218,1006.4854,10.8203,0) end
						if imgui.Button(u8'Êàçèíî-ìèíè') then teleportInterior(PLAYER_PED,1015.9720,-1127.6450,23.8574,0) end
						imgui.NextColumn()
						if imgui.Button(u8'Ðàçáîðêà LV') then teleportInterior(PLAYER_PED,-1506.7286,2623.1606,55.8359,0) end
						if imgui.Button(u8'Ðàçáîðêà LS-SF') then teleportInterior(PLAYER_PED,-2110.1580,-2431.3657,30.6250,0) end
						if imgui.Button(u8'Çàáðîøåííûé çàâîä') then teleportInterior(PLAYER_PED,1044.2622,2078.8237,10.8203,0) end
						if imgui.Button(u8'Òðåíèðîâî÷íûé êîìëïåêñ') then teleportInterior(PLAYER_PED,2478.8884,-2108.2769,13.5469,0) end
						if imgui.Button(u8'Ñîñòÿçàòåëüíàÿ àðåíà') then teleportInterior(PLAYER_PED,1088.4347,-900.3381,42.7011,0) end
						if imgui.Button(u8'Îñòðîâ "Íåâåçåíèÿ"') then teleportInterior(PLAYER_PED,616.4134,-3549.7146,86.9716,0) end
						if imgui.Button(u8'Ýêñïîðò ÒÑ') then teleportInterior(PLAYER_PED,-1549.0760,121.4793,3.5547,0) end
						if imgui.Button(u8'Òèð') then teleportInterior(PLAYER_PED,-2689.1277,0.0403,6.1328,0) end
						if imgui.Button(u8'Òðóùîáû') then teleportInterior(PLAYER_PED,-2541.6707,25.9529,16.4438,0) end
						if imgui.Button(u8'Àýðîïîðò LS') then teleportInterior(PLAYER_PED,1449.0017,-2461.8296,13.5547,0) end
						if imgui.Button(u8'Àýðîïîðò SF') then teleportInterior(PLAYER_PED,-1654.5244,-173.4216,14.1484,0) end
						if imgui.Button(u8'Àýðîïîðò LV') then teleportInterior(PLAYER_PED,1337.8947,1303.8196,10.8203,0) end
					end
					imgui.Unindent(15)
					imgui.Columns(1)
				end

			elseif act9 == 2 then
				imgui.ToggleButton('41', 'Ñîêðàùåííûå êîìàíäû', array.at_scmd)
				imgui.SameLine(nil, x)
				imgui.ToggleButton('42', 'Íîâûå êîìàíäû', array.at_ncmd)
				imgui.Spacing()
				if imgui.CollapsingHeader(u8'×àòû') then
					imgui.Indent(10)
					imgui.ToggleButton('44', 'Àäìèíèñòðàòèâíûé ÷àò', array.at_chat)
					imgui.Unindent(10)
				end
				imgui.Spacing()
				if imgui.CollapsingHeader(u8'Ïîìîùü') then
					imgui.NewLine()
					imgui.SameLine(nil, 10)
					if imgui.CollapsingHeader('AHELP') then
						imgui.Indent(20)
						if imgui.CollapsingHeader('ALVL 1', btn_size) then
							imgui.TextColoredRGB('{B31A06}/a {888EA0}- {0E8604}àäìèí ÷àò')
							imgui.TextColoredRGB('{B31A06}/admins {888EA0}- {0E8604}ïðîñìîòð àäìèíîâ îíëàéí')
							imgui.TextColoredRGB('{B31A06}/an {888EA0}- {0E8604}îòâåòèòü íà ðåïîðò')
							imgui.TextColoredRGB('{B31A06}/spec {888EA0}- {0E8604}ñëåäèòü çà èãðîêîì')
							imgui.TextColoredRGB('{B31A06}/specoff {888EA0}- {0E8604}ïåðåñòàòü ñëåäèòü')
							imgui.TextColoredRGB('{B31A06}/jail {888EA0}- {0E8604}ïîñàäèòü â òþðüìó')
							imgui.TextColoredRGB('{B31A06}/kick {888EA0}- {0E8604}êèêíóòü èãðîêà')
							imgui.TextColoredRGB('{B31A06}/check{888EA0} -{0E8604} ïðîñìîòð ñòàòèñòèêè ïåðñîíàæà')
							imgui.TextColoredRGB('{B31A06}/anames{888EA0} -{0E8604} èñòîðèÿ íèê-íåéìîâ')
							imgui.TextColoredRGB('{B31A06}/tp {888EA0}-{0E8604} òåëåïîðò')
							imgui.TextColoredRGB('{B31A06}/ftp {888EA0}- {0E8604}òåëåïîðò ê îðãàíèçàöèÿì')
							imgui.TextColoredRGB('{B31A06}/goto{888EA0} - {0E8604}òåëåïîðò ê èãðîêó')
							imgui.TextColoredRGB('{B31A06}/fixveh{888EA0} -{0E8604} ïî÷èíèòü òðàíñïîðò')
				 		  imgui.TextColoredRGB('{B31A06}/spawncar{888EA0} -{0E8604} çàñïàâíèòü ID òðàíñïîðòà (/dl)')
							imgui.TextColoredRGB('{B31A06}/checkad{888EA0} -{0E8604} ïðîâåðêà îáúÿâëåíèé')
							imgui.TextColoredRGB('{B31A06}/cheaters{888EA0} - {0E8604}èãðîêè ó êîòîðûõ óñòàíîâëåí ñîáåéò')
							imgui.TextColoredRGB('{B31A06}/getcar{888EA0} - {0E8604}ïðèçâàòü ID òðàíñïîðòà (/dl)')
							imgui.TextColoredRGB('{B31A06}/aen {888EA0}- {0E8604}ïðîâåðèòü âêë/âûêë äâèãàòåëü òðàíñïîðòà')
							imgui.TextColoredRGB('{B31A06}/hit {888EA0}- {0E8604}ïðîâåðèòü óðîí ïîïàäàíèé èãðîêà, âûñòðåëû')
							imgui.TextColoredRGB('{B31A06}/zz{888EA0} - {0E8604}êàê /o, òîëüêî ñî ñêîáêàìè è äðóãèì öâåòîì')
							imgui.TextColoredRGB('{B31A06}/deleteobjects{888EA0} - {0E8604}óäàëèòü âñå îáúåêòû ÏÄ')
						end
						if imgui.CollapsingHeader('ALVL 2', btn_size) then
							imgui.TextColoredRGB('{B31A06}/ban{888EA0} - {0E8604}çàáàíèòü èãðîêà')
							imgui.TextColoredRGB('{B31A06}/prison {888EA0}- {0E8604}ïîñàäèòü â ïðèñîí íà 3500 ñåêóíä')
							imgui.TextColoredRGB('{B31A06}/warn {888EA0}- {0E8604}äàòü ïðåäóïðåæäåíèå')
							imgui.TextColoredRGB('{B31A06}/mute{888EA0} - {0E8604}äàòü ìîë÷àíêó')
							imgui.TextColoredRGB('{B31A06}/spawn {888EA0}- {0E8604}îòïðàâèòü èãðîêà íà ñïàâí')
							imgui.TextColoredRGB('{B31A06}/abizz {888EA0}- {0E8604}ïðîñìîòð èíôîðìàöèè ïðî âñå áèçíåññû øòàòà')
							imgui.TextColoredRGB('{B31A06}/ajobs {888EA0}-{0E8604} ïðîñìîòð òðóäîâîé êíèãè èãðîêà')
							imgui.TextColoredRGB('{B31A06}/biz {888EA0}- {0E8604}òï â áèç')
							imgui.TextColoredRGB('{B31A06}/house {888EA0}- {0E8604}òï â äîì')
							imgui.TextColoredRGB('{B31A06}/garage {888EA0}- {0E8604}òï â ãàðàæ')
							imgui.TextColoredRGB('{B31A06}/destroycar {888EA0}- {0E8604}óíè÷òîæèòü ñîçäàííûé òðàíñïîðò')
							imgui.TextColoredRGB('{B31A06}/fillveh {888EA0}- {0E8604}çàïðàâèòü òðàíñïîðò')
							imgui.TextColoredRGB('{B31A06}/gethere{888EA0} -{0E8604} òï ê ñåáå èãðîêà')
							imgui.TextColoredRGB('{B31A06}/sban {888EA0}- {0E8604}òèõî çàáàíèòü èãðîêà')
							imgui.TextColoredRGB('{B31A06}/skick {888EA0}- {0E8604}òèõî êèêíóòü èãðîêà')
							imgui.TextColoredRGB('{B31A06}/amembers {888EA0}- {0E8604}ïðîâåðèòü îíëàéí âî ôðàêöèè')
							imgui.TextColoredRGB('{B31A06}/o{888EA0} - {0E8604}÷àò âèäíûé âñåì èãðîêàì')
							imgui.TextColoredRGB('{B31A06}/setsex {888EA0}- {0E8604}ñìåíà ïîëà èãðîêó')
							imgui.TextColoredRGB('{B31A06}/setnat {888EA0}- {0E8604}ñìåíà ðàñû èãðîêó')
							imgui.TextColoredRGB('{B31A06}/auron{888EA0} -{0E8604} ïîêàçûâàåò êîìó èãðîê ïîñëåäíèé ðàç íàí¸ñ óðîí è îò êîãî ïîëó÷èë')
						end
						if imgui.CollapsingHeader('ALVL 3', btn_size) then
							imgui.TextColoredRGB('{B31A06}/mpgo {888EA0}- {0E8604}íà÷àòü ìåðîïðèÿòèå')
							imgui.TextColoredRGB('{B31A06}/ainvite {888EA0}- {0E8604}èíâàéòíóòü ñåáÿ âî ôðàêöèþ')
							imgui.TextColoredRGB('{B31A06}/mark {888EA0}- {0E8604}ïîñòàâèòü ìåòêó')
							imgui.TextColoredRGB('{B31A06}/gotomark{888EA0} - {0E8604}òï íà ìåòêó')
							imgui.TextColoredRGB('{B31A06}/unprison{888EA0} -{0E8604} âûïóñòèòü èç ïðèñîíà')
							imgui.TextColoredRGB('{B31A06}/unjail{888EA0} - {0E8604}âûïóñòèòü èç òþðüìû')
							imgui.TextColoredRGB('{B31A06}/sethp {888EA0}- {0E8604}èçìåíèòü çäîðîâüå èãðîêó')
							imgui.TextColoredRGB('{B31A06}/veh {888EA0}- {0E8604}ñîçäàòü òðàíñïîðò (íå çàáûòü óäàëèòü)')
							imgui.TextColoredRGB('{B31A06}/dellveh {888EA0}- {0E8604}óäàëèòü âåñü ñîçäàííûé òðàíñïîðò çà ñåðâåðå')
							imgui.TextColoredRGB('{B31A06}/slap {888EA0}- {0E8604}ñëàïíóòü èãðîêà')
							imgui.TextColoredRGB('{B31A06}/freeze {888EA0}- {0E8604}çàìîðîçèòü èãðîêà')
							imgui.TextColoredRGB('{B31A06}/unfreeze {888EA0}-{0E8604} ðàçìîðîçèòü èãðîêà')
							imgui.TextColoredRGB('{B31A06}/spawncars{888EA0} -{0E8604} çàñïàâíèòü âåñü òðàíñïîðò')
							imgui.TextColoredRGB('{B31A06}/fuelcars{888EA0} - {0E8604}çàïðàâèòü âåñü òðàíñïîðò')
							imgui.TextColoredRGB('{B31A06}/disarm {888EA0}- {0E8604}îáåçîðóæèòü èãðîêà')
							imgui.TextColoredRGB('{B31A06}/cc {888EA0}- {0E8604}î÷èñòèòü ÷àò')
							imgui.TextColoredRGB('{B31A06}/cc2 {888EA0}- {0E8604}î÷èñòèòü ÷àò èãðîêó')
							imgui.TextColoredRGB('{B31A06}/kickjob {888EA0}- {0E8604}óâîëèòü ñ ðàáîòû')
							imgui.TextColoredRGB('{B31A06}/mpskin {888EA0}- {0E8604}âûäàòü âðåìåííûé ñêèí')
							imgui.TextColoredRGB('{B31A06}/rspawncars {888EA0}-{0E8604} çàñïàâíèòü òðàíñïîðò â ðàäèóñå')
							imgui.TextColoredRGB('{B31A06}/dmzone{888EA0} - {0E8604}çàïóñòèòü ñòðàéêáîë')
							imgui.TextColoredRGB('{B31A06}/aobject{888EA0} - {0E8604}ñîçäàòü îáúåêò (íóæåí 8 ðàíã â ÏÄ)')
						end
						if imgui.CollapsingHeader('ALVL 4', btn_size) then
							imgui.TextColoredRGB('{B31A06}/getip{888EA0} - {0E8604}IP èãðîêà')
							imgui.TextColoredRGB('{B31A06}/alock {888EA0}- {0E8604}îòêðûòü òðàíñïîðò')
							imgui.TextColoredRGB('{B31A06}/alock2 {888EA0}- {0E8604}çàêðûòü òðàíñïîðò')
							imgui.TextColoredRGB('{B31A06}/setname {888EA0}- {0E8604}ñìåíèòü íèê-íåéì èãðîêó')
							imgui.TextColoredRGB('{B31A06}/setnames{888EA0} - {0E8604}çàÿâêè íà ñìåíó íèê-íåéìà')
							imgui.TextColoredRGB('{B31A06}/agl{888EA0} - {0E8604}âûäàòü ëèöåíçèþ')
							imgui.TextColoredRGB('{B31A06}/int{888EA0} - {0E8604}ñìåíèòü èíòåðüåð â äîìå')
							imgui.TextColoredRGB('{B31A06}/tpto{888EA0} - {0E8604} èãðîêà ê äðóãîìó èãðîêó')
							imgui.TextColoredRGB('{B31A06}/kickinvite {888EA0}-{0E8604} óâîëèòü ñ ôðàêöèè')
							imgui.TextColoredRGB('{B31A06}/take {888EA0}- {0E8604}îòáîð ëèöåíçèé')
							imgui.TextColoredRGB('{B31A06}/unban{888EA0} - {0E8604}ðàçáàíèòü àêêàóíò')
							imgui.TextColoredRGB('{B31A06}/razborka1 {888EA0}- {0E8604}ïåðåêðàñèòü ðàçáîðêó áàéêåðîâ')
							imgui.TextColoredRGB('{B31A06}/unwarn {888EA0}- {0E8604}ñíÿòü âàðí')
						end
						if imgui.CollapsingHeader('ALVL 5', btn_size) then
							imgui.TextColoredRGB('{B31A06}/apark {888EA0}- {0E8604}ïðèïàðêîâàòü òðàíñïîðò')
							imgui.TextColoredRGB('{B31A06}/mole {888EA0}- {0E8604}íàïèñàòü âñåì èãðîêàì ÑÌÑ îò ëèöà ñåðâåðà')
							imgui.TextColoredRGB('{B31A06}/glrp {888EA0}- {0E8604}ïðîñëóøêà ÷àòîâ')
							imgui.TextColoredRGB('{B31A06}/agiverank {888EA0}- {0E8604}ñìåíèòü ðàíã èãðîêó')
							imgui.TextColoredRGB('{B31A06}/givegun {888EA0}- {0E8604}äàòü èãðîêó îðóæèå')
							imgui.TextColoredRGB('{B31A06}/setarmor {888EA0}- {0E8604}ñìåíèòü ñîñòîÿíèå áðîíè èãðîêó')
							imgui.TextColoredRGB('{B31A06}/explode{888EA0} -{0E8604} âçîðâàòü èãðîêà')
							imgui.TextColoredRGB('{B31A06}/unslot{888EA0} - {0E8604}î÷èñòèòü ñëîòû òðàíñïîðòîâ èãðîêà')
							imgui.TextColoredRGB('{B31A06}/weather {888EA0}-{0E8604} ñìåíèòü ïîãîäó')
							imgui.TextColoredRGB('{B31A06}/sethprad {888EA0}- {0E8604}âûäàòü õï âñåì â îïð. ðàäèóñå')
							imgui.TextColoredRGB('{B31A06}/mpskinrad {888EA0}- {0E8604}âûäàòü âñåì ñêèí â îïð. ðàäèóñå')
							imgui.TextColoredRGB('{B31A06}/givegunrad {888EA0}- {0E8604}âûäàòü âñåì îðóæèå â îïð. ðàäèóñå')
							imgui.TextColoredRGB('{B31A06}/setarmorrad {888EA0}-{0E8604} âûäàòü âñåõ áðîíþ â îïð. ðàäèóñå')
							imgui.TextColoredRGB('{B31A06}/1gungame {888EA0}- {0E8604}çàïóñòèòü ""Ãîíêó Âîîðóæåíèé"')
							imgui.TextColoredRGB('{B31A06}/stopattack{888EA0} -{0E8604} ïðåêðàòèòü êàïò')
							imgui.TextColoredRGB('{B31A06}/giveport{888EA0} -{0E8604} âûäàòü ïîðò ìàôèè')
							imgui.TextColoredRGB('{B31A06}/admtack {888EA0}- {0E8604}cíÿòü êä íà êàïò ó áàíäû')
							imgui.TextColoredRGB('{B31A06}/givegz {888EA0}- {0E8604}äàòü ãàíãçîíó äðóãîé áàíäå')
							imgui.TextColoredRGB('{B31A06}/zaprosip {888EA0}- {0E8604}ïîñìîòðåòü àêêàóíòû íà îïð. IP')
						end
						if imgui.CollapsingHeader('ALVL 6', btn_size) then
							imgui.TextColoredRGB('{B31A06}/sethpall {888EA0}- {0E8604}èçìåíèòü õï âñåì èãðîêàì')
							imgui.TextColoredRGB('{B31A06}/unbanip {888EA0}-{0E8604} ðàçáàíèòü IP')
							imgui.TextColoredRGB('{B31A06}/alllic {888EA0}- {0E8604}äàòü âñå ëèöåíçèè èãðîêó')
							imgui.TextColoredRGB('{B31A06}/aengine {888EA0}-{0E8604} îòêëþ÷èòü ñèñòåìó äâèãàòåëåé íà ñåðâåðå(áîëüøå íàãðóçêè, ääîñ)')
							imgui.TextColoredRGB('{B31A06}/acapture{888EA0} -{0E8604} îòêëþ÷èòü çàõâàòû(ìåðîïðèÿòèÿ è ïðî÷åå)')
							imgui.TextColoredRGB('{B31A06}/rasform {888EA0}- {0E8604}ïîëíàÿ ðàñôîðìèðîâêà ãåòòî (îáùàêè, ðåïóòàöèÿ, êîëè÷åñòâî óáèéñòâ)')
							imgui.TextColoredRGB('{B31A06}/rasformbiker{888EA0} - {0E8604}ðàñôîðìèðîâêà îáùàêîâ áàéêåðîâ')
							imgui.TextColoredRGB('{B31A06}/givevip {888EA0}-{0E8604} âûäàòü VIP')
							imgui.TextColoredRGB('{B31A06}/makehelper {888EA0}-{0E8604} âûäàòü õåëïåðêó')
						end
						if imgui.CollapsingHeader('ALVL 7', btn_size) then
							imgui.TextColoredRGB('{B31A06}/banip{888EA0} - {0E8604}çàáàíèòü IP')
							imgui.TextColoredRGB('{B31A06}/asellcar {888EA0}- {0E8604}ïðîäàòü òðàíñïîðò (àâòîðûíî÷íûé)')
							imgui.TextColoredRGB('{B31A06}/asellbiz {888EA0}- {0E8604}ïðîäàòü áèç')
							imgui.TextColoredRGB('{B31A06}/asellsbiz {888EA0}- {0E8604}ïðîäàòü ñáèç')
							imgui.TextColoredRGB('{B31A06}/asellhouse {888EA0}- {0E8604}ïðîäàòü äîì')
							imgui.TextColoredRGB('{B31A06}/kickmarriage {888EA0}- {0E8604}ðàçâåñòè èãðîêà')
							imgui.TextColoredRGB('{B31A06}/noooc{888EA0} - {0E8604}âêëþ÷èòü OOC ÷àò')
							imgui.TextColoredRGB('{B31A06}/makedrugs {888EA0}- {0E8604}äàòü íàðêîòèêè èãðîêó')
							imgui.TextColoredRGB('{B31A06}/setskin {888EA0}- {0E8604}âûäàòü ñêèí')
							imgui.TextColoredRGB('{B31A06}/setskinslot {888EA0}- {0E8604}âûäàòü ñêèí íà îïð. ñëîò')
						end
						imgui.Unindent(20)
					end
					imgui.Indent(10)
					if imgui.CollapsingHeader(u8'ID ôðàêöèé') then
						imgui.CenterTextColoredRGB('{0E8604}Ãîñóäàðñòâåííûå ôðàêöèè{888EA0}:')
						imgui.Spacing()
						imgui.TextColoredRGB('{888EA0}Ïîëèöèÿ ËÑ - {C39932}1')
						imgui.TextColoredRGB('{888EA0}Ïîëèöèÿ ÑÔ - {C39932}20')
						imgui.TextColoredRGB('{888EA0}Ïîëèöèÿ ËÂ - {C39932}21')
						imgui.Spacing()
						imgui.TextColoredRGB('{888EA0}Ãîñïèòàëü ËÑ - {C39932}2')
						imgui.TextColoredRGB('{888EA0}Ãîñïèòàëü ÑÔ - {C39932}23')
						imgui.TextColoredRGB('{888EA0}Ãîñïèòàëü ËÂ - {C39932}24')
						imgui.Spacing()
						imgui.TextColoredRGB('{888EA0}ÔÁÐ - {C39932}22')
						imgui.Spacing()
						imgui.TextColoredRGB('{888EA0}Ïðàâèòåëüñòâî - {C39932}3')
						imgui.Spacing()
						imgui.TextColoredRGB('{888EA0}Íàö.ãâàðäèÿ - {C39932}6')
						imgui.Spacing()
						imgui.TextColoredRGB('{888EA0}Ëèöåíçåðû - {C39932}5')
						imgui.Spacing()
						imgui.TextColoredRGB('{888EA0}ÑÌÈ ËÑ - {C39932}4')
						imgui.TextColoredRGB('{888EA0}ÑÌÈ ËÂ - {C39932}25')
						imgui.Spacing()
						imgui.CenterTextColoredRGB('{B31A06}Áàíäû/ìàôèè/áàéêåðû{888EA0}:')
						imgui.Spacing()
						imgui.TextColoredRGB('{888EA0}Ðóññêàÿ ìàôèÿ - {C39932}7')
						imgui.TextColoredRGB('{888EA0}ßêóäçà - {C39932}8')
						imgui.Spacing()
						imgui.TextColoredRGB('{888EA0}West Side Grove Gang - {C39932}11')
						imgui.TextColoredRGB('{888EA0}East Side Ballas Gang - {C39932}12')
						imgui.TextColoredRGB('{888EA0}Varios Los Aztecas - {C39932}13')
						imgui.TextColoredRGB('{888EA0}Saints Vagos Gang - {C39932}14')
						imgui.TextColoredRGB('{888EA0}Los Santos Rifa Gang - {C39932}15')
						imgui.Spacing()
						imgui.TextColoredRGB('{888EA0}Comrades MC - {C39932}17')
						imgui.TextColoredRGB('{888EA0}Warlocks MC - {C39932}18')
					end
					if imgui.CollapsingHeader(u8'Êîìàíäû') then
						imgui.CenterTextColoredRGB('Ñîêðàùåííûå êîìàíäû:')
						imgui.Spacing()
						imgui.TextColoredRGB('{C39932}/sp {888EA0}- /spec')
						imgui.TextColoredRGB('{C39932}/spoff {888EA0}- /specoff')
						imgui.TextColoredRGB('{C39932}/fix {888EA0}- /fixveh')
						imgui.TextColoredRGB('{C39932}/deleteobjects {888EA0}- /dellobjs')
						imgui.TextColoredRGB('{C39932}/gh {888EA0}- /gethere')
						imgui.TextColoredRGB('{C39932}/dcar {888EA0}- /destroycar')
						imgui.TextColoredRGB('{C39932}/fz {888EA0}- /freeze')
						imgui.TextColoredRGB('{C39932}/ufz {888EA0}- /unfreeze')
						imgui.TextColoredRGB('{C39932}/ggun {888EA0}- /givegun')
						imgui.TextColoredRGB('{C39932}/arank {888EA0}- /agiverank')
						imgui.TextColoredRGB('{C39932}/ainv {888EA0}- /ainvite')
						imgui.TextColoredRGB('{C39932}/gc {888EA0}- /getcar')
						imgui.TextColoredRGB('{C39932}/rscars {888EA0}- /rspawncars')
						imgui.TextColoredRGB('{C39932}/kinv {888EA0}- /kickinvite')
						imgui.Spacing()
						imgui.CenterTextColoredRGB('Íîâûå êîìàíäû')
						imgui.TextColoredRGB('{C39932}/hp {888EA0}- Óñòàíàâëèâàåò Âàì 150 åäèíèö çäîðîâüÿ')
						imgui.TextColoredRGB('{C39932}/ffveh {888EA0}- ×èíèò è çàïðàâÿåò ÒÑ')
						imgui.TextColoredRGB('{C39932}/gg [id] {888EA0}- Æåëàåòå èãðîêó ïðèÿòíîé èãðû')
						imgui.TextColoredRGB('{C39932}/piarask {888EA0}- Ïèøåò â îáùèé ÷àò ïðî õåëïåðîâ')
						imgui.TextColoredRGB('{C39932}/fraklvl [id] {888EA0}- Ïèøåò èãðîêó êàêèå ôðàêöèè ñ êàêîãî óðîâíÿ')
						imgui.TextColoredRGB('{C39932}/dm [id] {888EA0}- Âûäàåò jail èãðîêó íà 20 ìèíóò ñ ïðè÷èíîé, "DM"')
						imgui.TextColoredRGB('{C39932}/bike [num] {888EA0}- Ñîçäàåò âåëîñèïåä (1 - Mountain; 2 - BMX; 3 - Bike)')
					end
					imgui.Unindent(10)
				end
			end
			imgui.EndChild()

		else
			actEnterInGame = 1
			imgui.BeginChild('0', imgui.ImVec2(855, 370), true)
			imgui.Text(u8'Select language/Âûáåðèòå ÿçûê:')
			imgui.SameLine(nil,x)
			if imgui.Button('English') then langIG[1] = true langIG[2] = false end
			imgui.SameLine(nil,x)
			if imgui.Button(u8'Ðóññêèé') then langIG[1] = false langIG[2] = true end
			if langIG[1] then
				imgui.Text(u8(imgIntGameENG[1]))
				if imgui.CollapsingHeader('More about tabs') then
					imgui.Text(u8(imgIntGameENG[2]))
					imgui.Separator()
				end
				imgui.Text(u8(imgIntGameENG[3]))
			elseif langIG[2] then
				imgui.Text(u8(imgIntGameRUS[1]))
				if imgui.CollapsingHeader(u8'Ïîäðîáíåå ïðî âêëàäêè') then
					imgui.Text(u8(imgIntGameRUS[2]))
					imgui.Separator()
				end
				imgui.Text(u8(imgIntGameRUS[3]))
			end 
			imgui.EndChild()
		end
	end

	imgui.End()
end		

function main()
	if not isSampLoaded() and not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(500) end
	ifont = renderCreateFont("Verdana", 9, 5)--("Comic Sans MS", 9, 1)
	clickfont = renderCreateFont("Tahoma", 10, FCR_BOLD + FCR_BORDER)

	_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	nick = sampGetPlayerNickname(id)

	if array.checkupdate.v then
		autoupdate('https://raw.githubusercontent.com/PanSeek/zuwi/master/version.json', '##autoupdate', 'https://raw.githubusercontent.com/PanSeek/zuwi/master/version.json')
	else
		if not array.lang_chat.v then sampAddChatMessage(tag..'You have disabled autoupdate. You are using version: {F9D82F}'..version_script, main_color)
		elseif array.lang_chat.v then sampAddChatMessage(tag..'Ó Âàñ âûêëþ÷åíî àâòîîáíîâëåíèå. Âû èñïîëüçóåòå âåðñèþ: {F9D82F}'..version_script, main_color) end
	end

	imgui.Process = false

	sampRegisterChatCommand('z_authors', cmd_authors);sampRegisterChatCommand('zauthors', cmd_authors)
	sampRegisterChatCommand('z_date', cmd_date);sampRegisterChatCommand('zdate', cmd_date)
	sampRegisterChatCommand('z_menu', cmd_imgui);sampRegisterChatCommand('zmenu', cmd_imgui)
	sampRegisterChatCommand('z_suicide', cmd_suicide);sampRegisterChatCommand('zsuicide', cmd_suicide)
	sampRegisterChatCommand('z_coord', cmd_coord);sampRegisterChatCommand('zcoord', cmd_coord)
	sampRegisterChatCommand('z_getmoney', cmd_getmoney);sampRegisterChatCommand('zgetmoney', cmd_getmoney)
	sampRegisterChatCommand('z_fakerepair', cmd_fakerepair);sampRegisterChatCommand('zfakerepair', cmd_fakerepair)
	sampRegisterChatCommand('z_togall', cmd_togall);sampRegisterChatCommand('ztogall', cmd_togall)
	sampRegisterChatCommand('z_errors', cmd_errors);sampRegisterChatCommand('zerrors', cmd_errors)
	sampRegisterChatCommand('z_time', cmd_time);sampRegisterChatCommand('ztime', cmd_time)
	sampRegisterChatCommand('z_weather', cmd_weather);sampRegisterChatCommand('zweather', cmd_weather)
	sampRegisterChatCommand('z_help', cmd_help);sampRegisterChatCommand('zhelp', cmd_help)
	sampRegisterChatCommand('z_setmark', cmd_setmark);sampRegisterChatCommand('zsetmark', cmd_setmark)
	sampRegisterChatCommand('z_tpmark', cmd_tpmark);sampRegisterChatCommand('ztpmark', cmd_tpmark)
	sampRegisterChatCommand('z_cc', cmd_clearchat);sampRegisterChatCommand('zcc', cmd_clearchat)
	sampRegisterChatCommand('z_version', cmd_version);sampRegisterChatCommand('zversion', cmd_version)
	sampRegisterChatCommand('z_update', cmd_update);sampRegisterChatCommand('zupdate', cmd_update)
	sampRegisterChatCommand('z_checktime', cmd_checktime);sampRegisterChatCommand('zchecktime', cmd_checktime)
	sampRegisterChatCommand('z_cmdsamp', cmd_helpcmdsamp);sampRegisterChatCommand('zcmdsamp', cmd_helpcmdsamp)
	sampRegisterChatCommand('z_reload', cmd_reload);sampRegisterChatCommand('zreload', cmd_reload)
	sampRegisterChatCommand('z_fps', cmd_fps);sampRegisterChatCommand('zfps', cmd_fps)
	--sampRegisterChatCommand('z_tpmark_gta', cmd_tpmark_gta);sampRegisterChatCommand('ztpmark_gta', cmd_tpmark_gta)
--ADMIN REVENTRP
	sampRegisterChatCommand('sp', cmd_spec);sampRegisterChatCommand('spoff', cmd_specoff);sampRegisterChatCommand('fix', cmd_fixveh);sampRegisterChatCommand('gg', cmd_gg)
	sampRegisterChatCommand('hp', cmd_sethpme);sampRegisterChatCommand('ffveh', cmd_FillFixVeh);sampRegisterChatCommand('dellobjs', cmd_deleteobjects);sampRegisterChatCommand('kinv', cmd_kickinvite)
	sampRegisterChatCommand('gh', cmd_gethere);sampRegisterChatCommand('dm', cmd_dm);sampRegisterChatCommand('bike', cmd_bike);sampRegisterChatCommand('dcar', cmd_destroycar)
	sampRegisterChatCommand('fraklvl', cmd_fraklvl);sampRegisterChatCommand('piarask', cmd_piarask);sampRegisterChatCommand('fz', cmd_freeze);sampRegisterChatCommand('ufz', cmd_unfreeze)
	sampRegisterChatCommand('ggun', cmd_givegun);sampRegisterChatCommand('arank', cmd_agiverank);sampRegisterChatCommand('ainv', cmd_ainvite);sampRegisterChatCommand('gc', cmd_getcar)
	sampRegisterChatCommand('rscars', cmd_rspawncars)

	thread = lua_thread.create_suspended(thread_function)

	while true do
		wait(0)
		if enabled then
			check_keys()
			main_funcs()
		end
		imgui.Process = array.main_window_state.v

		if time then
			setTimeOfDay(time, 0)
		end

	end
end

--KEYS FUNCTION
function check_keys()
	if not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() then

		if isKeyJustPressed(key.VK_F10) then
			array.main_window_state.v = not array.main_window_state.v
		end

		if isKeyJustPressed(key.VK_RSHIFT) then
			CheckAirBrake = not CheckAirBrake
			if CheckAirBrake then
				local posX, posY, posZ = getCharCoordinates(PLAYER_PED)
				airBrakeCoords = {posX, posY, posZ, 0.0, 0.0, getCharHeading(PLAYER_PED)}
			else
			end
		end

		if isKeyJustPressed(key.VK_MBUTTON) and array.show_imgui_clickwarp.v then
			checkClickwarp = not checkClickwarp
			if checkClickwarp then sampSetCursorMode(2) else sampSetCursorMode(0) end
		end

		if isKeyJustPressed(key.VK_INSERT) then
			CheckGMactor = not CheckGMactor
		end

		if isKeyJustPressed(key.VK_1) and isKeyJustPressed(key.VK_HOME) then
			CheckGMveh = not CheckGMveh
		end

		if isKeyJustPressed(key.VK_2) and isKeyJustPressed(key.VK_HOME) then
			CheckGMWveh = not CheckGMWveh
		end

		if wasKeyPressed(key.VK_F11) then --1/0 cursor
			active = not active
			imgui.ShowCursor = active
		end

	end
end

function main_funcs()
	---------------------ACTOR-------------------------
	if array.show_imgui_infRun.v and not isCharInWater(PLAYER_PED) then
		mem.setint8(0xB7CEE4, 1, false)
	elseif array.show_imgui_infSwim.v and isCharInWater(PLAYER_PED) then
		mem.setint8(0xB7CEE4, 1, false)
	else
		mem.setint8(0xB7CEE4, 0, false)
	end

	if array.show_imgui_infOxygen.v then
		mem.setint8(0x96916E, 1, false)
	else
		mem.setint8(0x96916E, 0, false)
	end

	if array.show_imgui_gmActor.v and CheckGMactor then
		GMtext = '{29C730}GM'
		setCharProofs(playerPed, true, true, true, true, true)
	else
		GMtext = '{B22C2C}GM'
		setCharProofs(playerPed, false, false, false, false, false)
	end

	if array.show_imgui_megajumpActor.v then
		mem.setint8(0x96916C, 1, false)
	else
		mem.setint8(0x96916C, 0, false)
	end

	if array.show_imgui_nofall.v then
		if isCharPlayingAnim(PLAYER_PED, 'KO_SKID_BACK') or isCharPlayingAnim(PLAYER_PED, 'FALL_COLLAPSE') then
			clearCharTasksImmediately(PLAYER_PED)
		end
	end

	if isKeyJustPressed(key.VK_OEM_2) and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and not isPlayerDead(PLAYER_PED) then
		if array.show_imgui_unfreeze.v then
			if isCharInAnyCar(PLAYER_PED) then
				freezeCarPosition(storeCarCharIsInNoSave(PLAYER_PED), false)
			else
				setPlayerControl(PLAYER_HANDLE, true)
				freezeCharPosition(PLAYER_PED, false)
				clearCharTasksImmediately(PLAYER_PED)
			end
			restoreCameraJumpcut()
		end
	end

	if wasKeyPressed(key.VK_F3) and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and not isPlayerDead(PLAYER_PED) then
		if array.show_imgui_suicideActor.v then
			if not isCharInAnyCar(PLAYER_PED) then
				setCharHealth(PLAYER_PED, 0)
			end
		end
	end
	-----------------VEHICLE--------------------
	samem.require 'CVehicle'
	samem.require 'CTrain'
	local player_veh = samem.cast('CVehicle **', samem.player_vehicle)
	if isCharInAnyCar(PLAYER_PED) then

		if array.show_imgui_flip180.v then
			if wasKeyPressed(key.VK_BACK) and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and not isPlayerDead(PLAYER_PED) then
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
		end

		if array.show_imgui_fastexit.v then
			if isKeyJustPressed(key.VK_N) and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and not isPlayerDead(PLAYER_PED) then
				local posX, posY, posZ = getCarCoordinates(storeCarCharIsInNoSave(PLAYER_PED))
				warpCharFromCarToCoord(PLAYER_PED, posX, posY, posZ)
			end
		end

		if array.show_imgui_hopVeh.v then
			if wasKeyPressed(key.VK_B) and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and not isPlayerDead(PLAYER_PED) then
				local cVecX, cVecY, cVecZ = getCarSpeedVector(storeCarCharIsInNoSave(PLAYER_PED))
				if cVecZ < 7.0 then applyForceToCar(storeCarCharIsInNoSave(PLAYER_PED), 0.0, 0.0, 0.2, 0.0, 0.0, 0.0) end
			end
		end

		if array.show_imgui_flipOnWheels.v then
			if wasKeyPressed(key.VK_DELETE) and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and not isPlayerDead(PLAYER_PED) then
				local veh = storeCarCharIsInNoSave(PLAYER_PED)
                local oX, oY, oZ = getOffsetFromCarInWorldCoords(veh, 0.0,  0.0,  0.0)
				setCarCoordinates(veh, oX, oY, oZ)
				markCarAsNoLongerNeeded(veh)
			end
		end

		if wasKeyPressed(key.VK_F3) and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and not isPlayerDead(PLAYER_PED) then --suicideVeh
			if array.show_imgui_suicideVeh.v then
				local myCar = storeCarCharIsInNoSave(PLAYER_PED)
				setCarHealth(myCar, 0)
				for i = 0, 3 do burstCarTire(myCar, i) end
				markCarAsNoLongerNeeded(myCar)
			else
				if array.lang_chat.v then sampAddChatMessage(errorRUS[6], main_color)
				elseif not array.lang_chat.v then sampAddChatMessage(errorENG[6], main_color) end
			end
		end

		if array.show_imgui_antiBikeFall.v then
			setCharCanBeKnockedOffBike(PLAYER_PED, true)
		else
			setCharCanBeKnockedOffBike(PLAYER_PED, false)
		end

		if array.show_imgui_gmVeh.v and CheckGMveh then
			VGMtext = '{29C730}VGM'
			setCarProofs(storeCarCharIsInNoSave(playerPed), true, true, true, true, true)
			setCharCanBeKnockedOffBike(playerPed, true)
			setCanBurstCarTires(storeCarCharIsInNoSave(playerPed), false)
		else
			VGMtext = '{B22C2C}VGM'
		end

		if array.show_imgui_restHealthVeh.v and isKeyJustPressed(key.VK_1) then fixCar(storeCarCharIsInNoSave(PLAYER_PED)) end

		if array.show_imgui_fixWheels.v then
			local veh = storeCarCharIsInNoSave(PLAYER_PED)
				if wasKeyPressed(key.VK_1) and wasKeyPressed(key.VK_Z) then
				for i = 0, 3 do
				fixCarTire(veh, i)
				end
			end
		end

		if array.show_imgui_engineOnVeh.v then
			if not array.lang_visual.v then EngineText = '{29C730}Engine'
			elseif array.lang_visual.v then EngineText = '{29C730}Äâèãàòåëü' end
			switchCarEngine(storeCarCharIsInNoSave(PLAYER_PED), true)
		else
			if not array.lang_visual.v then EngineText = '{B22C2C}Engine'
			elseif array.lang_visual.v then EngineText = '{B22C2C}Äâèãàòåëü' end
		end

		if array.show_imgui_speedhack.v and isKeyDown(VK_LMENU) then
			speedhackMaxSpeed = array.SpeedHackMaxSpeed.v
			if getCarSpeed(storeCarCharIsInNoSave(playerPed)) * 2.01 <= array.SpeedHackMaxSpeed.v then
				local cVecX, cVecY, cVecZ = getCarSpeedVector(storeCarCharIsInNoSave(playerPed))
				local heading = getCarHeading(storeCarCharIsInNoSave(playerPed))
				local turbo = fps_correction() / 85
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
				applyForceToCar(storeCarCharIsInNoSave(playerPed), xforce * Sin, yforce * Cos, zforce / 2, 0.0, 0.0, 0.0)
			end
		end

		if array.show_imgui_megajumpBMX.v then
			mem.setint8(0x969161, 1, false)
		else
			mem.setint8(0x969161, 0, false)
		end

		if array.show_imgui_gmWheels.v and CheckGMWveh then
			VGMWheelstext = '{29C730}VGMWheels'
			local veh = storeCarCharIsInNoSave(PLAYER_PED)
			setCanBurstCarTires(veh, false)
		else
			VGMWheelstext = '{B22C2C}VGMWheels'
		end

		if array.show_imgui_perfectHandling.v then
			mem.setint8(0x96914C, 1, false)
		else
			mem.setint8(0x96914C, 0, false)
		end

		if array.show_imgui_allCarsNitro.v then
		 	mem.setint8(0x969165, 1, false)
		else
		 	mem.setint8(0x969165, 0, false)
		end

		if array.show_imgui_onlyWheels.v then
			mem.setint8(0x96914B, 1, false)
		else
			mem.setint8(0x96914B, 0, false)
		end

		if array.show_imgui_tankMode.v then
			mem.setint8(0x969164, 1, false)
		else
			mem.setint8(0x969164, 0, false)
		end

		if array.show_imgui_carsFloatWhenHit.v then
		 	mem.setint8(0x969166, 1, false)
		else
		 	mem.setint8(0x969166, 0, false)
		end

		if array.show_imgui_driveOnWater.v then
			mem.setint8(0x969152, 1, false)
		else
			mem.setint8(0x969152, 0, false)
		end
	end
	----------------WEAPONS--------------
	if array.show_imgui_infAmmo.v then
		mem.setint8(0x969178, 1, false)
	else
		mem.setint8(0x969178, 0, false)
	end

	if array.show_imgui_fullskills.v then
	 	mem.setint8(0x969179, 1, false)
	 else
	 	mem.setint8(0x969179, 0, false)
	 end
	----------------MISC-----------------
	if array.show_imgui_UnderWater.v then
		mem.setint8(0x6C2759, 1, false)
	else
		mem.setint8(0x6C2759, 0, false)
	end

	if array.show_imgui_FOV.v then
		if isCurrentCharWeapon(PLAYER_PED, 34) and isKeyDown(2) then
			if not locked then
				cameraSetLerpFov(70.0, 70.0, 1000, 1)
				locked = true
			end
		else
			cameraSetLerpFov(array.FOV_value.v, 0.1, 1000, 1)
			locked = false
		end
	end

	if array.show_imgui_sensfix.v then
		local asf = mem.read (0xB6EC1C, 4, false)
		local bsf = mem.read (0xB6EC18, 4, false)
		if not asf == bsf then --float
			writeMemory (0xB6EC18, 4, asf, false)
		end
	end

	if array.show_imgui_reconnect.v then
		local ip, port = sampGetCurrentServerAddress()
		local sname = sampGetCurrentServerName()
		--recon_delay.v = os.clock() * 1000
		if --[[recon_delay.v and]] wasKeyPressed(key.VK_0) and wasKeyPressed(key.VK_LSHIFT) then
			sampConnectToServer(ip, port)
			if array.lang_chat.v then sampAddChatMessage(tag.. 'Âû ïåðåçàøëè íà ñåðâåð: {F9D82F}' ..sname.. ' {888EA0}IP: {F9D82F}' ..ip.. ':' ..port, main_color)
			elseif not array.lang_chat.v then sampAddChatMessage(tag.. 'You are logged on: {F9D82F}' ..sname.. ' {888EA0}IP: {F9D82F}' ..ip.. ':' ..port, main_color) end
		end
	end

	if array.show_imgui_AirBrake.v and CheckAirBrake then
		ABtext = '{29C730}AirBrake'
		AirBrakeSpeed = array.AirBrake_Speed.v
		if isCharInAnyCar(PLAYER_PED) then heading = getCarHeading(storeCarCharIsInNoSave(PLAYER_PED))
		else heading = getCharHeading(PLAYER_PED) end
		local camCoordX, camCoordY, camCoordZ = getActiveCameraCoordinates()
		local targetCamX, targetCamY, targetCamZ = getActiveCameraPointAt()
		local angle = getHeadingFromVector2d(targetCamX - camCoordX, targetCamY - camCoordY)
		if isCharInAnyCar(PLAYER_PED) then difference = 0.79 else difference = 1.0 end
		if isKeyDown(key.VK_W) then
			if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
				airBrakeCoords[1] = airBrakeCoords[1] + array.AirBrake_Speed.v * math.sin(-math.rad(angle))
				airBrakeCoords[2] = airBrakeCoords[2] + array.AirBrake_Speed.v * math.cos(-math.rad(angle))
				setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - difference)
				if not isCharInAnyCar(PLAYER_PED) then setCharHeading(PLAYER_PED, angle)
				else setCarHeading(storeCarCharIsInNoSave(PLAYER_PED), angle) end
			else setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - 1.0) end
		elseif isKeyDown(key.VK_S) then
			if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
				airBrakeCoords[1] = airBrakeCoords[1] - array.AirBrake_Speed.v * math.sin(-math.rad(heading))
				airBrakeCoords[2] = airBrakeCoords[2] - array.AirBrake_Speed.v * math.cos(-math.rad(heading))
				setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - difference)
			else setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - 1.0) end
		end
		if isKeyDown(key.VK_A) then
			if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
				airBrakeCoords[1] = airBrakeCoords[1] - array.AirBrake_Speed.v * math.sin(-math.rad(heading - 90))
				airBrakeCoords[2] = airBrakeCoords[2] - array.AirBrake_Speed.v * math.cos(-math.rad(heading - 90))
				setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - difference)
			else setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - 1.0) end
		elseif isKeyDown(key.VK_D) then
			if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
				airBrakeCoords[1] = airBrakeCoords[1] - array.AirBrake_Speed.v * math.sin(-math.rad(heading + 90))
				airBrakeCoords[2] = airBrakeCoords[2] - array.AirBrake_Speed.v * math.cos(-math.rad(heading + 90))
				setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - difference)
			else setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - 1.0) end
		end
		if isKeyDown(key.VK_UP) then
			if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
				airBrakeCoords[3] = airBrakeCoords[3] + array.AirBrake_Speed.v  / 2.0
				setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - difference)
			else setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - 1.0) end
		end
		if isKeyDown(key.VK_DOWN) and airBrakeCoords[3] > -95.0 then
			if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
				airBrakeCoords[3] = airBrakeCoords[3] - array.AirBrake_Speed.v  / 2.0
				setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - difference)
			else setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - 1.0) end
		end
		if not isKeyDown(key.VK_W) and not isKeyDown(key.VK_S) and not isKeyDown(key.VK_A) and not isKeyDown(key.VK_D) and not isKeyDown(key.VK_UP) and not isKeyDown(key.VK_DOWN) then
			setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - 1.0)
		end
	else
		ABtext = '{B22C2C}AirBrake'
	end

	if array.show_imgui_blink.v and not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() then
		blinkDist = array.blink_dist.v
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
			blink[1] = blink[1] + array.blink_dist.v * math.sin(-math.rad(angle))
			blink[2] = blink[2] + array.blink_dist.v * math.cos(-math.rad(angle))
			setCharCoordinates(PLAYER_PED, blink[1], blink[2], blink[3] - difference)
		end
	end

	if array.show_imgui_clickwarp.v and checkClickwarp then
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
					local curX, curY, curZ = getCharCoordinates(playerPed)
					local dist = getDistanceBetweenCoords3d(curX, curY, curZ, pos.x, pos.y, pos.z)
					local hoffs = renderGetFontDrawHeight(clickfont)
					sy = sy - 2
					sx = sx - 2
					if not array.lang_visual.v then
						renderFontDrawText(clickfont, string.format('Distance: %0.2f', dist), sx - (renderGetFontDrawTextLength(clickfont, string.format('Distance: %0.2f', dist)) / 2) + 6, sy - hoffs, 0xFFFFFFFF)
					elseif array.lang_visual.v then
						renderFontDrawText(clickfont, string.format('Äèñòàíöèÿ: %0.2f', dist), sx - (renderGetFontDrawTextLength(clickfont, string.format('Äèñòàíöèÿ: %0.2f', dist)) / 2) + 6, sy - hoffs, 0xFFFFFFFF)
					end
					local tpIntoCar = nil
					if colpoint.entityType == 2 then
						local car = getVehiclePointerHandle(colpoint.entity)
						if doesVehicleExist(car) and (not isCharInAnyCar(playerPed) or storeCarCharIsInNoSave(playerPed) ~= car) then
							if isKeyJustPressed(key.VK_LBUTTON) and isKeyJustPressed(key.VK_RBUTTON) then tpIntoCar = car end
							if not array.lang_visual.v then
								renderFontDrawText(clickfont, '{0984d2}Push RButton for {FFFFFF}warp to vehicle', sx - (renderGetFontDrawTextLength(clickfont, '{0984d2}Push RButton for {FFFFFF}warp to vehicle') / 2) + 6, sy - hoffs * 2, -1)
							elseif array.lang_visual.v then
								renderFontDrawText(clickfont, '{0984d2}Íàæìèòå RButton ÷òîáû {FFFFFF}ñåñòü â òðàíñïîðò', sx - (renderGetFontDrawTextLength(clickfont, '{0984d2}Íàæìèòå RButton ÷òîáû {FFFFFF}ñåñòü â òðàíñïîðò') / 2) + 6, sy - hoffs * 2, -1)
							end
						end
					end
					-- createPointMarker(pos.x, pos.y, pos.z)
					if isKeyJustPressed(key.VK_LBUTTON) then
						if tpIntoCar then
							if not jumpIntoCar(tpIntoCar) then
								teleportPlayer(pos.x, pos.y, pos.z)
							end
						else
							if isCharInAnyCar(playerPed) then
								local norm = Vector3D(colpoint.normal[1], colpoint.normal[2], 0)
								local norm2 = Vector3D(colpoint2.normal[1], colpoint2.normal[2], colpoint2.normal[3])
								rotateCarAroundUpAxis(storeCarCharIsInNoSave(playerPed), norm2)
								pos = pos - norm * 1.8
								pos.z = pos.z - 1.1
							end
							teleportPlayer(pos.x, pos.y, pos.z)
						end
						-- removePointMarker()
						sampSetCursorMode(0)
						checkClickwarp = false
					end
				end
			end
		end
	end

	if array.show_imgui_nametag.v then
		NTtext = '{29C730}NameTag'
		nameTagOn()
	else
		NTtext = '{B22C2C}NameTag'
		nameTagOff()
	end

	if array.show_imgui_quickMap.v and isPlayerPlaying(PLAYER_HANDLE) then -- quick map (FYP)
		local menuPtr = 0x00BA6748
		if isKeyCheckAvailable() and isKeyDown(key.VK_M) then
			writeMemory(menuPtr + 0x33, 1, 1, false) -- activate menu
			-- wait for a next frame
			wait(0)
			writeMemory(menuPtr + 0x15C, 1, 1, false) -- textures loaded
			writeMemory(menuPtr + 0x15D, 1, 5, false) -- current menu
			while isKeyDown(key.VK_M) do
				wait(80)
			end
			writeMemory(menuPtr + 0x32, 1, 1, false) -- close menu
		end
	end

	if array.show_imgui_fastsprint.v and isPlayerPlaying(PLAYER_HANDLE) and not isCharInAnyCar(PLAYER_PED) then
		if isButtonPressed(PLAYER_HANDLE, 16) then
			setGameKeyState(16, 255)
			wait(3)
			setGameKeyState(16, 0)
		end
	end
	--------------------VISUAL-----------------------------
	if array.show_imgui_clrScr.v and isKeyJustPressed(key.VK_F8) then
		if array.show_imgui_nametag.v then
			nameTagOff()
			wait(1000)
			nameTagOn()
		end
		if imgui.Process == true then
			imgui.Process = false
			wait(1000)
			imgui.Process = true
		end
		if array.infbar.v then
			array.infbar.v = not array.infbar.v
			wait(1000)
			array.infbar.v = not array.infbar.v
		end
		if checkClickwarp then
			checkClickwarp = not checkClickwarp
			wait(1000)
			checkClickwarp = not checkClickwarp
		end
	end

	if array.show_imgui_doorlocks.v and isPlayerPlaying(PLAYER_HANDLE) and not isPauseMenuActive() then
		for k, v in pairs(getAllVehicles()) do
			local x, y, z = getCarCoordinates(v)
			local positionX, positionY, positionZ = getCharCoordinates(PLAYER_PED)
			local DoorsStats = getCarDoorLockStatus(v)
			local wposX, wposY = convert3DCoordsToScreen(x,y,z)
			local strStatus = ''
			if not array.lang_visual.v then
				if DoorsStats == 0 then
					strStatus = '{00FF00}Open'
				elseif DoorsStats == 2 then
					strStatus = '{FF0000}Closed'
				end
			elseif array.lang_visual.v then
				if DoorsStats == 0 then
					strStatus = '{00FF00}Îòêðûòî'
				elseif DoorsStats == 2 then
					strStatus = '{FF0000}Çàêðûòî'
				end
			end
			local dist = getDistanceBetweenCoords3d(positionX, positionY, positionZ,x,y,z)
			if isPointOnScreen(x, y, z, 0) and dist < array.distDoorLocks.v then
				renderFontDrawText(ifont, strStatus, wposX, wposY, 0xFF0984D2)
			end
		end
	end

	if array.show_imgui_antibhop.v then ABHtext = '{29C730}Anti-BHop' else ABHtext = '{B22C2C}Anti-BHop' end

	if isPlayerPlaying(PLAYER_HANDLE) and not isPauseMenuActive() and array.infbar.v then
		local posX, posY = getScreenResolution()
		local playerposX, playerposY, playerposZ = getCharCoordinates(playerPed)
		local ifps = mem.getfloat(0xB7CB50, 4, false)
		renderDrawBoxWithBorder(-1, posY - 18, posX + 2, 20, 0x44888EA0, 1, 0xFFF9D82F)
		if not isCharInAnyCar(PLAYER_PED) then
			local playerInterior, playerID, playerHP, playerAP, playerPing  = getPlayerOnFootInfo()
			local textENG = string.format("{888EA0}Int:{F9D82F} %d {888EA0}| [{F9D82F}%.2f{888EA0}] [{F9D82F}%.2f{888EA0}] [{F9D82F}%.2f{888EA0}] {FF0000}| {888EA0}ID:{F9D82F} %d {888EA0}| Health:{F9D82F} %d {888EA0}| Armor:{F9D82F} %d {888EA0}| Ping:{F9D82F} %d {888EA0}| FPS:{F9D82F} %d",
				playerInterior, playerposX, playerposY, playerposZ, playerID, playerHP, playerAP, playerPing, ifps)
			local textRUS = string.format("{888EA0}Èíò:{F9D82F} %d {888EA0}| [{F9D82F}%.2f{888EA0}] [{F9D82F}%.2f{888EA0}] [{F9D82F}%.2f{888EA0}] {FF0000}| {888EA0}ID:{F9D82F} %d {888EA0}| Çäîðîâüå:{F9D82F} %d {888EA0}| Áðîíÿ:{F9D82F} %d {888EA0}| Ïèíã:{F9D82F} %d {888EA0}| FPS:{F9D82F} %d",
			playerInterior, playerposX, playerposY, playerposZ, playerID, playerHP, playerAP, playerPing, ifps)
			local screenW, screenH = getScreenResolution()
			local fontlen = renderGetFontDrawTextLength(ifont, textRUS)
			local fontlen = renderGetFontDrawTextLength(ifont, textENG)
			if array.lang_visual.v then
				renderFontDrawText(ifont, textRUS, screenW / 999, screenH - 17, 0xFF0984D2)
			elseif not array.lang_visual.v then
				renderFontDrawText(ifont, textENG, screenW / 999, screenH - 17, 0xFF0984D2)
			end

			local checkFunc = string.format("{888EA0}["..ABtext.."{888EA0}] ["..NTtext.."{888EA0}] ["..GMtext.."{888EA0}] ["..ABHtext.."{888EA0}]")
			renderFontDrawText(ifont,  checkFunc, screenW / 2, screenH - 17, 0xFF0984D2)
			
		elseif isCharInAnyCar(PLAYER_PED) then
			local playerID, vehID, playerHP, playerAP, vehHP, playerPing = getPlayerInCarInfo()
			local textENG = string.format("[{F9D82F}%.2f{888EA0}] [{F9D82F}%.2f{888EA0}] [{F9D82F}%.2f{888EA0}] {FF0000}| {888EA0}ID:{F9D82F} %d {888EA0}| VID:{F9D82F} %d {888EA0}| Health:{F9D82F} %d {888EA0}| Armor:{F9D82F} %d {888EA0}| VHealth:{F9D82F} %d {888EA0}| Ping:{F9D82F} %d {888EA0}| FPS:{F9D82F} %d",
				playerposX, playerposY, playerposZ, playerID, vehID, playerHP, playerAP, vehHP, playerPing, ifps)
			local textRUS = string.format("[{F9D82F}%.2f{888EA0}] [{F9D82F}%.2f{888EA0}] [{F9D82F}%.2f{888EA0}] {FF0000}| {888EA0}ID:{F9D82F} %d {888EA0}| VID:{F9D82F} %d {888EA0}| Çäîðîâüå:{F9D82F} %d {888EA0}| Áðîíÿ:{F9D82F} %d {888EA0}| ÒÇäîðîâüå:{F9D82F} %d {888EA0}| Ïèíã:{F9D82F} %d {888EA0}| FPS:{F9D82F} %d",
				playerposX, playerposY, playerposZ, playerID, vehID, playerHP, playerAP, vehHP, playerPing, ifps)
			local screenW, screenH = getScreenResolution()
			local fontlen = renderGetFontDrawTextLength(ifont, textRUS)
			local fontlen = renderGetFontDrawTextLength(ifont, textENG)
			if array.lang_visual.v then
				renderFontDrawText(ifont, textRUS, screenW / 999, screenH - 17, 0xFF0984D2)
			elseif not array.lang_visual.v then
				renderFontDrawText(ifont, textENG, screenW / 999, screenH - 17, 0xFF0984D2)
			end

			local checkFunc = string.format("{888EA0}["..ABtext.."{888EA0}] ["..NTtext.."{888EA0}] ["..GMtext.."{888EA0}] ["..VGMtext.."{888EA0}] ["..VGMWheelstext.."{888EA0}] ["..EngineText.."{888EA0}]")
			renderFontDrawText(ifont,  checkFunc, screenW / 2, screenH - 17, 0xFF0984D2)
		end
	end
--
end
-------SAMP EVENTS-------
function sampev.onSendPlayerSync(data)
	if array.show_imgui_antibhop.v then --antiBHop (IMGUI)
		if bit.band(data.keysData, 0x28) == 0x28 then
			data.keysData = bit.bxor(data.keysData, 0x20)
		end
	end
end

function sampev.onServerMessage(color, text) 
	if array.at_chat.v then -- color adm chat = 15180346
		admchat = text:gsub('Àäìèí (%d+)', '[ALVL %1]')
		return {color, admchat}
	end
end
---------------------------------ÊÎÌÀÍÄÛ-------------------------------------
function cmd_update()
		lua_thread.create(function(prefix)
		local dlstatus = require('moonloader').download_status
		downloadUrlToFile(updatelink, thisScript().path,
			function(id3, status1, p13, p23)
			if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
				goupdatestatus = true
				lua_thread.create(function() wait(500) thisScript():reload() end)
			end
			if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
				if goupdatestatus == nil then
					if array.lang_chat.v then sampAddChatMessage(tag..'{B31A06}Íå óäàëîñü {888EA0}îáíîâèòüñÿ', main_color)
					elseif not array.lang_chat.v then sampAddChatMessage(tag..'{B31A06}Failed {888EA0}updating', main_color) end
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
		if array.lang_chat.v then sampAddChatMessage(tag..'Âðåìÿ èçìåíåíî íà {F9D82F}' .. time, main_color)
		elseif not array.lang_chat.v then sampAddChatMessage(tag..'Time change to {F9D82F}' .. time, main_color) end
	else
		patch_samp_time_set(false)
		time = nil
		if array.lang_chat.v then sampAddChatMessage(errorRUS[12], main_color)
		elseif not array.lang_chat.v then sampAddChatMessage(errorENG[12], main_color) end
	end
end

function cmd_fps()
	local fps = mem.getfloat(0xB7CB50, 4, false)
	local ifps = string.format('%d', fps)
	if array.lang_chat.v then sampAddChatMessage(tag..'Ñåé÷àñ FPS: {F9D82F}'..ifps, main_color)
	elseif not array.lang_chat.v then sampAddChatMessage(tag..'FPS now: {F9D82F}'..ifps, main_color) end
end

function cmd_weather(param)
	local weather = tonumber(param)
	if weather ~= nil and weather >= 0 and weather <= 45 then
		forceWeatherNow(weather)
		if array.lang_chat.v then sampAddChatMessage(tag..'Ïîãîäà èçìåíåíà íà {F9D82F}¹' .. weather, main_color)
		elseif not array.lang_chat.v then sampAddChatMessage(tag..'Weather change on {F9D82F}¹' .. weather, main_color) end
	else
		if array.lang_chat.v then sampAddChatMessage(errorRUS[13], main_color)
		elseif not array.lang_chat.v then sampAddChatMessage(errorENG[13], main_color) end
	end
end

function cmd_authors()
	if not sampIsDialogActive() then
		if array.lang_chat.v then sampShowDialog(2001, tag..'{F9D82F}Àâòîðñòâî {888EA0}è {0E8604}áëàãîäàðíîñòè', authorsRUS, 'Çàêðûòü', '', 0)
		elseif not array.lang_chat.v then sampShowDialog(2001, tag..'{F9d82f}Authors {888ea0}and {0e8604}thanks', authorsENG, 'Close', '', 0) end
	else sampAddChatMessage(errorRUS[11], main_color) end
end

function cmd_version()
	if array.lang_chat.v then sampAddChatMessage(tag.. 'Âåðñèÿ ñêðèïòà:{F9D82F} v' ..version_script, main_color)
	elseif not array.lang_chat.v then sampAddChatMessage(tag.. 'Version script:{F9D82F} v' ..version_script, main_color) end
end

function cmd_date()
	if array.lang_chat.v then sampAddChatMessage(os.date(tag..'Ñåãîäíÿøíÿÿ äàòà: {F9D82F}%d.%m.%Y'), main_color)
	elseif not array.lang_chat.v then sampAddChatMessage(os.date(tag..'Todays date: {F9D82F}%d.%m.%Y'), main_color) end
end

function cmd_imgui()
	array.main_window_state.v = not array.main_window_state.v
	imgui.Process = main_window_state.v
	if array.lang_chat.v then sampAddChatMessage(tag..'Âû {F9D82F}îòêðûëè/çàêðûëè {888EA0}ìåíþ ñêðèïòà. Ýòî ìîæíî ñäåëàòü áåç êîìàíäû, ñ ïîìîùüþ êëàâèøè {F9D82F}F10', main_color)
	elseif not array.lang_chat.v then sampAddChatMessage(tag..'You is {F9D82F}open/close {888EA0}script menu. This can be done without a command, using the key {F9D82F}F10', main_color) end
end

function cmd_help()
	if not array.main_window_state.v then
		array.main_window_state.v = not array.main_window_state.v
		imgui.Process = array.main_window_state.v
		act1 = 8
	elseif array.main_window_state.v then
		act1 = 8
	end
end

function cmd_clearchat()
    mem.fill(sampGetChatInfoPtr() + 306, 0x0, 25200)
    mem.write(sampGetChatInfoPtr() + 306, 25562, 4, 0x0)
    mem.write(sampGetChatInfoPtr() + 0x63DA, 1, 1)
end

function cmd_suicide()
	if not isPlayerDead(PLAYER_PED) and not isPlayerDead(PLAYER_PED) then
		if not isCharInAnyCar(PLAYER_PED) then
			setCharHealth(PLAYER_PED, 0)
		else
			local myCar = storeCarCharIsInNoSave(PLAYER_PED)
			setCarHealth(myCar, -1)
			markCarAsNoLongerNeeded(myCar)
		end
	end
end

function cmd_fakerepair()
	if isPlayerPlaying(PLAYER_PED) and not isPlayerDead(PLAYER_PED) and isCharInAnyCar(PLAYER_PED) then
		local myCar = storeCarCharIsInNoSave(PLAYER_PED)
		fixCar(myCar)
		markCarAsNoLongerNeeded(myCar)
		sampAddChatMessage(' Âû ïî÷èíèëè òðàíñïîðò!', 16113331)
	else
		if array.lang_chat.v then sampAddChatMessage(errorRUS[6], main_color)
		elseif not array.lang_chat.v then sampAddChatMessage(errorENG[6], main_color) end
	end
end

function cmd_coord()
	if not isPlayerDead(PLAYER_PED) then
		x,y,z = getCharCoordinates(PLAYER_PED)
		if array.lang_chat.v then sampAddChatMessage(tag..'Âàøè êîîðäèíàòû: X: {F9D82F}' .. math.floor(x) .. '{888EA0} | Y: {F9D82F}' .. math.floor(y) .. '{888EA0} | Z: {F9D82F}' .. math.floor (z), main_color)
		elseif not array.lang_chat.v then sampAddChatMessage(tag..'You are coords: X: {F9D82F}' .. math.floor(x) .. '{888EA0} | Y: {F9D82F}' .. math.floor(y) .. '{888EA0} | Z: {F9D82F}' .. math.floor (z), main_color) end
	else
		if array.lang_chat.v then sampAddChatMessage(errorRUS[1], main_color)
		elseif not array.lang_chat.v then sampAddChatMessage(errorENG[1], main_color) end
	end
end

function cmd_setmark()
	local interiorMark = getActiveInterior(PLAYER_PED)
	intMark = {getActiveInterior(PLAYER_PED)}
	local posX, posY, posZ = getCharCoordinates(PLAYER_PED)
	setmark = {posX, posY, posZ}
	if array.lang_chat.v then sampAddChatMessage(tag..'Ñîçäàíà ìåòêà ïî êîîðäèíàòàì: X: {F9D82F}' .. math.floor(setmark[1]) .. '{888EA0} | Y: {F9D82F}' .. math.floor(setmark[2]) .. '{888EA0} | Z: {F9D82F}' .. math.floor(setmark[3]), main_color)
		sampAddChatMessage(tag..'Èíòåðüåð: {F9D82F}' .. interiorMark, main_color)
	elseif not array.lang_chat.v then sampAddChatMessage(tag..'You are create mark by coords: X: {F9D82F}' .. math.floor(setmark[1]) .. '{888EA0} | Y: {F9D82F}' .. math.floor(setmark[2]) .. '{888EA0} | Z: {F9D82F}' .. math.floor(setmark[3]), main_color)
		sampAddChatMessage(tag..'Interior: {F9D82F}' .. interiorMark, main_color) end
end

function cmd_reload()
	thisScript():reload()
end

function cmd_tpmark()
	if setmark then		
		teleportInterior(PLAYER_PED, setmark[1], setmark[2], setmark[3], intMark[1])	
		if array.lang_chat.v then sampAddChatMessage(tag..'Âû òåëåïîðòèðîâàëèñü ïî ìåòêå', main_color)
		elseif not array.lang_chat.v then sampAddChatMessage(tag..'You are teleport to mark', main_color) end
	else
		if array.lang_chat.v then sampAddChatMessage(errorRUS[14], main_color)
		elseif not array.lang_chat.v then sampAddChatMessage(errorENG[14], main_color) end
	end
end

function cmd_getmoney()
	if not isPlayerDead(PLAYER_PED) then
		local money = mem.getint32(0xB7CE50)
		mem.setint32(0xB7CE50, money + 1000, false)
		if array.lang_chat.v then sampAddChatMessage(tag..'Âàì âûäàíî: {F9D82F}1.000$ {888EA0}(Âèçóàëüíî)', main_color)
		elseif not array.lang_chat.v then sampAddChatMessage(tag..'Issued to you: {F9D82F}1.000$ {888EA0}(Visual)', main_color) end
	else
		if array.lang_chat.v then sampAddChatMessage(errorRUS[1], main_color)
		elseif not array.lang_chat.v then sampAddChatMessage(errorENG[1], main_color) end
	end
end

function cmd_checktime()
	local time = getTime(0) -- MSK time
	if array.lang_chat.v then sampAddChatMessage(os.date(tag..'Òî÷íîå âðåìÿ ïî ÌÑÊ: {F9D82F}%H{888EA0}:{F9D82F}%M{888EA0}:{F9D82F}%S', time), main_color)
	elseif not array.lang_chat.v then sampAddChatMessage(os.date(tag..'Exact time to MSK: {F9D82F}%H{888EA0}:{F9D82F}%M{888EA0}:{F9D82F}%S', time), main_color) end
end

function cmd_errors()
	if not sampIsDialogActive() then
		if array.lang_chat.v then sampShowDialog(1999, tag..'Ñïèñîê {B31A06}îøèáîê', errorslistRUS, 'Çàêðûòü', '', 0)
		elseif not array.lang_chat.v then sampShowDialog(1999, tag..'List {B31A06}errors', errorslistENG, 'Close', '', 0) end
	else
		if array.lang_chat.v then sampAddChatMessage(errorRUS[11], main_color)
		elseif not array.lang_chat.v then sampAddChatMessage(errorENG[11], main_color) end
	end
end

function cmd_helpcmdsamp()
	if not sampIsDialogActive() then
		if array.lang_chat.v then sampShowDialog(2005, tag..'Ñïèñîê êîìàíä SA-MP', helpcmdsampRUS, 'Çàêðûòü', '', 0)
		elseif not array.lang_chat.v then sampShowDialog(2005, tag..'List commands SA-MP', helpcmdsampENG, 'Close', '', 0) end
	else
		if array.lang_chat.v then sampAddChatMessage(errorRUS[11], main_color)
		elseif not array.lang_chat.v then sampAddChatMessage(errorENG[11], main_color) end
	end
end
-----------REVENTRP----------------
function cmd_togall()
	thread:run('z_togall')
end

function thread_function(option, arg)
	if option == 'z_togall' then
		sampSendChat('/togfam')
		sampSendChat('/tognews')
		sampSendChat('/togd')
		sampSendChat('/togphone')
		sampSendChat('/togw')
		wait(250)
		sampAddChatMessage(tag..'Âñåâîçìîæíûå è äîñòóïíûå äëÿ Âàñ êîìàíäû {F9D82F}îòêëþ÷åíû/âêëþ÷åíû', main_color)
	end
end

function cmd_spec(pid)
	if array.at_scmd.v then
		local id = tonumber(pid)
		if id ~= nil and id >= 0 and id <= 1000 then
			sampSendChat('/spec '..id)
		else
			sampAddChatMessage(tag..'Èñïîëüçóéòå: {F9D82F}/sp [id]', main_color)
		end
	end
end

function cmd_freeze(pid)
	if array.at_scmd.v then
		local id = tonumber(pid)
		if id ~= nil and id >= 0 and id <= 1000 then
			sampSendChat('/freeze '..id)
		else
			sampAddChatMessage(tag..'Èñïîëüçóéòå: {F9D82F}/fz [id]', main_color)
		end
	end
end

function cmd_unfreeze(pid)
	if array.at_scmd.v then
		local id = tonumber(pid)
		if id ~= nil and id >= 0 and id <= 1000 then
			sampSendChat('/unfreeze '..id)
		else
			sampAddChatMessage(tag..'Èñïîëüçóéòå: {F9D82F}/ufz [id]', main_color)
		end
	end
end

function cmd_gg(pid)
	if array.at_ncmd.v then
		local id = tonumber(pid)
		if id ~= nil and id >= 0 and id <= 1000 then
			sampSendChat('/pm '..id..' Ïðèÿòíîé èãðû è õîðîøåãî íàñòðîåíèÿ íà Revent Role Play!')
		else
			sampAddChatMessage(tag..'Èñïîëüçóéòå: {F9D82F}/gg [id]', main_color)
		end
	end
end

function cmd_fraklvl(pid)
	local flvlmsg = {' ÎÏÃ, áîëüíèöà, íàö. ãâàðäèÿ, ïðàâèòåëüñòâî - 1 LVL 2 EXP. Îñòàëüíîå - 2 LVL',
	' Áîëüíèöà, ïðàâèòåëüñòâî, íàö. ãâàðäèÿ, ÎÏÃ - 1 LVL 2 EXP. Îñòàëüíîå - 2 LVL',
	' Íàö. ãâàðäèÿ, áîëüíèöà, ÎÏÃ, ïðàâèòåëüñòâî - 1 LVL 2 EXP. Îñòàëüíîå - 2 LVL',
	' ÎÏÃ, íàö. ãâàðäèÿ, ïðàâèòåëüñòâî, áîëüíèöà - 1 LVL 2 EXP. Îñòàëüíîå - 2 LVL',
	' Ïðàâèòåëüñòâî, íàö. ãâàðäèÿ, áîëüíèöà, ÎÏÃ - 1 LVL 2 EXP. Îñòàëüíîå - 2 LVL'}
	if array.at_ncmd.v then
		local id = tonumber(pid)
		if id ~= nil and id >= 0 and id <= 1000 then
			math.randomseed(os.time())
			sampSendChat('/an ' .. id .. flvlmsg[math.random(#flvlmsg)])
		else
			sampAddChatMessage(tag..'Èñïîëüçóéòå: {F9D82F}/fraklvl [id]', main_color)
		end
	end
end

function cmd_gethere(pid)
	if array.at_scmd.v then
		local id = tonumber(pid)
		if id ~= nil and id >= 0 and id <= 1000 then
			sampSendChat('/gethere '..id)
		else
			sampAddChatMessage(tag..'Èñïîëüçóéòå: {F9D82F}/gh [id]', main_color)
		end
	end
end

function cmd_kickinvite(param)
	if array.at_scmd.v then
		local id = tonumber(param)
		if id ~= nil and id >= 0 and id <= 1000 then
			sampSendChat('/kickinvite '..id)
		else
			sampAddChatMessage(tag..'Èñïîëüçóéòå: {F9D82F}/kinv [id]', main_color)
		end
	end
end

function cmd_getcar(param)
	if array.at_scmd.v then
		local vId = tonumber(param)
		if vId ~= nil and vId >= 0 and vId <= 2000 then
			sampSendChat('/getcar '..vId)
		else
			sampAddChatMessage(tag..'Èñïîëüçóéòå: {F9D82F}/gc [vId]', main_color)
		end
	end
end

function cmd_ainvite(param)
	if array.at_scmd.v then
		local idfrac = tonumber(param)
		if idfrac ~= nil and idfrac >= 0 and idfrac <= 25 then
			sampSendChat('/ainvite '..idfrac)
		else
			sampAddChatMessage(tag..'Èñïîëüçóéòå: {F9D82F}/ainv [id frac]', main_color)
		end
	end
end

function cmd_agiverank(pid, prank)
	if array.at_scmd.v then
		local id = tonumber(pid)
		local rank = tonumber(prank)
		if id ~= nil and id >= 0 and id <= 1000 and rank ~= nil and rank >= 0 and rank <= 18 then
			sampSendChat('/agiverank '..id..' '..rank)
		else
			sampAddChatMessage(tag..'Èñïîëüçóéòå: {F9D82F}/arank [id] [rank]', main_color)
		end
	end
end

function cmd_givegun(pid, pidgun, pammo)
	if array.at_scmd.v then
		local id = tonumber(pid)
		local idgun = tonumber(pidgun)
		local ammo = tonumber(pammo)
		if id ~= nil and id >= 0 and id <= 1000 and idgun ~= nil and idgun >= 0 and idgun <= 46 and ammo ~= nil and ammo >= 0 then
			sampSendChat('/givegun '..id..' '..idgun..' '..ammo)
		else
			sampAddChatMessage(tag..'Èñïîëüçóéòå: {F9D82F}/ggun [id] [id gun] [ammo]', main_color)
		end
	end
end

function cmd_dm(param)
	if array.at_ncmd.v then
		local id = tonumber(param)
		if id ~= nil and id >= 0 and id <= 1000 then
			sampSendChat('/jail '..id..' 20 DM')
		else
			sampAddChatMessage(tag..'Èñïîëüçóéòå: {F9D82F}/dm [id]', main_color)
		end
	end
end

function cmd_bike(param)
	if array.at_ncmd.v then
		local vid = tonumber(param)
		if vid ~= nil and vid == 1 then sampSendChat('/veh 510 1 1')
		elseif vid ~= nil and vid == 2 then sampSendChat('/veh 481 1 1')
		elseif vid ~= nil and vid == 3 then sampSendChat('/veh 509 1 1')
		else
			sampAddChatMessage(tag..'Èñïîëüçóéòå: {F9D82F}/bike [num] {0984d2}(1 - Ãîðíûé; 2 - BMX; 3 - Îáû÷íûé)', main_color)
		end
	end
end

function cmd_sethpme()
	local isid, myid = sampGetPlayerIdByCharHandle(playerPed)
	local mynick = sampGetPlayerNickname(myid)
	if array.at_ncmd.v and isPlayerPlaying(PLAYER_HANDLE) then
		sampSendChat('/sethp '..myid..' 150')
	end
end

function cmd_piarask()
	local amsg = {'Âîçíèêëè âîïðîñû ïî èãðîâîìó ïðîöåññó? Íàøè õåëïåðû ãîòîâû îòâåòèòü íà Âàøè âîïðîñû - /ask',
	'Åñòü âîïðîñû ïî èãðîâîìó ìîäó? Çàäàâàéòå èõ íàøèì õåëïåðàì - /ask',
	'Âîçíèê âîïðîñ ïî èãðîâîìó ïðîöåññó? Çàäàâàéòå åãî íàøèì õåëïåðàì - /ask',
	'Âîçíèêëè âîïðîñû ïî èãðîâîìó ïðîöåññó? Íàøè õåëïåðû ãîòîâû Âàì ïîìî÷ü - /ask'}
	if array.at_ncmd.v then
		math.randomseed(os.time())
		sampSendChat('/o ' .. amsg[math.random(#amsg)])
	end
end
function cmd_rspawncars() if array.at_scmd.v then sampSendChat('/rspawncars') end end
function cmd_deleteobjects() if array.at_scmd.v then sampSendChat('/deleteobjects') end end
function cmd_FillFixVeh() if array.at_ncmd.v then sampSendChat('/fixveh') sampSendChat('/fillveh') end end
function cmd_specoff() if array.at_scmd.v then sampSendChat('/specoff') end end
function cmd_fixveh() if array.at_scmd.v then sampSendChat('/fixveh') end end
function cmd_destroycar() if array.at_scmd.v then sampSendChat('/destroycar') end end

-------------------------TERMINATE------------------------------
function onScriptTerminate(zuwiScript, quitGame)
	if zuwiScript == thisScript() then
		if array.AutoSave.v and not doesFileExist('zuwi.ini') then
			mainIni = {
				actor = {
					infRun = array.show_imgui_infRun.v,
					infSwim = array.show_imgui_infSwim.v,
					infOxygen = array.show_imgui_infOxygen.v,
					suicide = array.show_imgui_suicideActor.v,
					megaJump = array.show_imgui_megajumpActor.v,
					fastSprint = array.show_imgui_fastsprint.v,
					unfreeze = array.show_imgui_unfreeze.v,
					noFall = array.show_imgui_nofall.v,
					GM = array.show_imgui_gmActor.v
				},
				vehicle = {
					flip180 = array.show_imgui_flip180.v,
					flipOnWheels = array.show_imgui_flipOnWheels.v,
					megaJumpBMX = array.show_imgui_megajumpBMX.v,
					hop = array.show_imgui_hopVeh.v,
					boom = array.show_imgui_suicideVeh.v,
					fastExit = array.show_imgui_fastexit.v,
					gmWheels = array.show_imgui_gmWheels.v,
					AntiBikeFall = array.show_imgui_antiBikeFall.v,
					GM = array.show_imgui_gmVeh.v,
					fixWheels = array.show_imgui_fixWheels.v,
					speedhack = array.show_imgui_speedhack.v,
					speedhackMaxSpeed = array.SpeedHackMaxSpeed.v,
					perfectHandling = array.show_imgui_perfectHandling.v,
					allCarsNitro = array.show_imgui_allCarsNitro.v,
					onlyWheels = array.show_imgui_onlyWheels.v,
					tankMode = array.show_imgui_tankMode.v,
					carsFloatWhenHit = array.show_imgui_carsFloatWhenHit.v,
					driveOnWater = array.show_imgui_driveOnWater.v,
					restoreHealth = array.show_imgui_restHealthVeh.v,
					engineOn = array.show_imgui_engineOnVeh.v
				},
				weapon = {
					infAmmo = array.show_imgui_infAmmo.v,
					fullSkills = array.show_imgui_fullskills.v
				},
				misc = {
					FOV = array.show_imgui_FOV.v,
					FOVvalue = array.FOV_value.v,
					antibhop = array.show_imgui_antibhop.v,
					AirBrake = array.show_imgui_AirBrake.v,
					AirBrakeSpeed = array.AirBrake_Speed.v,
					quickMap = array.show_imgui_quickMap.v,
					nameTag = array.show_imgui_nametag.v,
					blink = array.show_imgui_blink.v,
					blinkDist = array.blink_dist.v,
					sensfix = array.show_imgui_sensfix.v,
					clearScreenshot = array.show_imgui_clrScr.v,
					WalkDriveUnderWater = array.show_imgui_UnderWater.v,
					ClickWarp = array.show_imgui_clickwarp.v,
					reconnect = array.show_imgui_reconnect.v
				},
				visual = {
					nameTag = array.show_imgui_nametag.v,
					infoBar = array.infbar.v,
					doorLocks = array.show_imgui_doorlocks.v,
					distanceDoorLocks = array.distDoorLocks.v
				},
				menu = {
					checkUpdate = array.checkupdate.v,
					language_menu = array.lang_menu.v,
					language_chat = array.lang_chat.v,
					language_dialogs = array.lang_dialogs.v,
					language_visual = array.lang_visual.v,
					autoSave = array.AutoSave.v
				},
				admintools = {
					adminChat = array.at_chat.v,
					newCMD = array.at_ncmd.v,
					shortCMD = array.at_scmd.v
				}
			} inicfg.save(mainIni, 'zuwi.ini')
		end
	end
end
-------------------------IMGUI------------------------------
function imgui.TextQuestion(text)
	imgui.TextDisabled('(?)')
	if imgui.IsItemHovered() then
	 	imgui.BeginTooltip()
	 	imgui.PushTextWrapPos(450)
	  	imgui.TextUnformatted(text)
	  	imgui.PopTextWrapPos()
	  	imgui.EndTooltip()
	end
end
  
function imgui.ToggleButton(val, text, bool)
	  imadd.ToggleButton(val, bool)
	  imgui.SameLine(nil, x)
	  imgui.Text(u8(text))
end
  
function imgui.TextColoredRGB(text)
	  local style = imgui.GetStyle()
	  local colors = style.Colors
	  local ImVec4 = imgui.ImVec4
	  local explode_argb = function(argb)
		  local a = bit.band(bit.rshift(argb, 24), 0xFF)
		  local r = bit.band(bit.rshift(argb, 16), 0xFF)
		  local g = bit.band(bit.rshift(argb, 8), 0xFF)
		  local b = bit.band(argb, 0xFF)
		  return a, r, g, b
	  end
	  local getcolor = function(color)
		  if color:sub(1, 6):upper() == 'SSSSSS' then
			  local r, g, b = colors[1].x, colors[1].y, colors[1].z
			  local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
			  return ImVec4(r, g, b, a / 255)
		  end
		  local color = type(color) == 'string' and tonumber(color, 16) or color
		  if type(color) ~= 'number' then return end
		  local r, g, b, a = explode_argb(color)
		  return imgui.ImColor(r, g, b, a):GetVec4()
	  end
	  local render_text = function(text_)
		  for w in text_:gmatch('[^\r\n]+') do
			  local text, colors_, m = {}, {}, 1
			  w = w:gsub('{(......)}', '{%1FF}')
			  while w:find('{........}') do
				  local n, k = w:find('{........}')
				  local color = getcolor(w:sub(n + 1, k - 1))
				  if color then
					  text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
					  colors_[#colors_ + 1] = color
					  m = n
				  end
				  w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
			  end
			  if text[0] then
				  for i = 0, #text do
					  imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
					  imgui.SameLine(nil, 0)
				  end
				  imgui.NewLine()
			  else imgui.Text(u8(w)) end
		  end
	  end
	  render_text(text)
end
  
function imgui.CenterTextColoredRGB(text)
	  local width = imgui.GetWindowWidth()
	  local style = imgui.GetStyle()
	  local colors = style.Colors
	  local ImVec4 = imgui.ImVec4
  
	  local explode_argb = function(argb)
		  local a = bit.band(bit.rshift(argb, 24), 0xFF)
		  local r = bit.band(bit.rshift(argb, 16), 0xFF)
		  local g = bit.band(bit.rshift(argb, 8), 0xFF)
		  local b = bit.band(argb, 0xFF)
		  return a, r, g, b
	  end
  
	  local getcolor = function(color)
		  if color:sub(1, 6):upper() == 'SSSSSS' then
			  local r, g, b = colors[1].x, colors[1].y, colors[1].z
			  local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
			  return ImVec4(r, g, b, a / 255)
		  end
		  local color = type(color) == 'string' and tonumber(color, 16) or color
		  if type(color) ~= 'number' then return end
		  local r, g, b, a = explode_argb(color)
		  return imgui.ImColor(r, g, b, a):GetVec4()
	  end
  
	  local render_text = function(text_)
		  for w in text_:gmatch('[^\r\n]+') do
			  local textsize = w:gsub('{.-}', '')
			  local text_width = imgui.CalcTextSize(u8(textsize))
			  imgui.SetCursorPosX( width / 2 - text_width .x / 2 )
			  local text, colors_, m = {}, {}, 1
			  w = w:gsub('{(......)}', '{%1FF}')
			  while w:find('{........}') do
				  local n, k = w:find('{........}')
				  local color = getcolor(w:sub(n + 1, k - 1))
				  if color then
					  text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
					  colors_[#colors_ + 1] = color
					  m = n
				  end
				  w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
			  end
			  if text[0] then
				  for i = 0, #text do
					  imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
					  imgui.SameLine(nil, 0)
				  end
				  imgui.NewLine()
			  else
				  imgui.Text(u8(w))
			  end
		  end
	  end
	  render_text(text)
end

--[[function imgui.HotKey(name, keys, lastkeys, width)
	  local width = width or 90
	  local name = tostring(name)
	  local lastkeys = lastkeys or {}
	  local keys, bool = keys or {}, false
	  lastkeys.v = keys.v
	  local sKeys = table.concat(getKeysName(keys.v), ' + ')
	  if #tHotKeyData.save > 0 and tostring(tHotKeyData.save[1]) == name then
		  keys.v = tHotKeyData.save[2]
		  sKeys = table.concat(getKeysName(keys.v), ' + ')
		  tHotKeyData.save = {}
		  bool = true
	  elseif tHotKeyData.edit ~= nil and tostring(tHotKeyData.edit) == name then
		  if #tKeys == 0 then
			  if os.clock() - tHotKeyData.lastTick > 0.5 then
			  tHotKeyData.lastTick = os.clock()
			  tHotKeyData.tickState = not tHotKeyData.tickState
		   end
		   sKeys = tHotKeyData.tickState and u8'Íåò' or ' '
		  else
			  sKeys = table.concat(getKeysName(tKeys), ' + ')
		  end
	  end
	  imgui.PushStyleColor(imgui.Col.Button, imgui.GetStyle().Colors[imgui.Col.Button])
	  imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.GetStyle().Colors[imgui.Col.ButtonHovered])
	  imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.GetStyle().Colors[imgui.Col.ButtonActive])
	  if imgui.Button((tostring(sKeys):len() == 0 and u8'Íåò' or sKeys)..name, imgui.ImVec2(width, 0)) then
		  tHotKeyData.edit = name
	  end
	  imgui.PopStyleColor(3)
	  return bool
end]]--
  
--[[function isKeysDown(keylist)
	  local tKeys = keylist
	  local bool = false
	  local isDownIndex = 0
	  local key = #tKeys < 2 and tonumber(tKeys[1]) or tonumber(tKeys[#tKeys])
	  if #tKeys < 2 then
		  if not isKeyDown(VK_RMENU) and not isKeyDown(VK_LMENU) and not isKeyDown(VK_LSHIFT) and not isKeyDown(VK_RSHIFT) and not isKeyDown(VK_LCONTROL) and not isKeyDown(VK_RCONTROL) then
			  if wasKeyPressed(key) then
				  bool = true
			  end
		  end
	  else
		  if isKeyDown(tKeys[1])  then
			  if isKeyDown(tKeys[2]) then
				  if tKeys[3] ~= nil then
					  if isKeyDown(tKeys[3]) then
						  if tKeys[4] ~= nil then
							  if isKeyDown(tKeys[4]) then
								  if tKeys[5] ~= nil then
									  if isKeyDown(tKeys[5]) then
										  if wasKeyPressed(key) then
											  bool = true
										  end
									  end
								  else
									  if wasKeyPressed(key) then
										  bool = true
									  end
								  end
							  end
						  else
							  if wasKeyPressed(key) then
								  bool = true
							  end
						  end
					  end
				  else
					  if wasKeyPressed(key) then
						  bool = true
					  end
				  end
			  end
		  end
	  end
	  if nextLockKey == keylist then
		  bool = false
		  nextLockKey = ""
	  end
	  return bool
end]]--
local fa_font = nil
local fa_glyph_ranges = imgui.ImGlyphRanges({ fa.min_range, fa.max_range })
function imgui.BeforeDrawFrame()
  if fa_font == nil then
    local font_config = imgui.ImFontConfig() -- to use 'imgui.ImFontConfig.new()' on error
    font_config.MergeMode = true
    fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fontawesome-webfont.ttf', 14.0, font_config, fa_glyph_ranges)
  end
end
-------------------------OTHERS------------------------------
function teleportInterior(ped, posX, posY, posZ, int)
	setCharInterior(ped, int)
	setInteriorVisible(int)
	setCharCoordinates(ped, posX, posY, posZ)
end

function getPlayerOnFootInfo()
  local _, playerID = sampGetPlayerIdByCharHandle(playerPed)
  local playerHP = getCharHealth(playerPed)
	return getActiveInterior(),
		playerID,
		playerHP,
		getCharArmour(playerPed),
    sampGetPlayerPing(playerID)    
end

function getPlayerInCarInfo()
  local _, playerID = sampGetPlayerIdByCharHandle(playerPed)
  local playerHP = getCharHealth(playerPed)
  local playerCar = storeCarCharIsInNoSave(playerPed)
  local _, vehId = sampGetVehicleIdByCarHandle(playerCar)
	return playerID,
		vehId,
		playerHP,
    getCharArmour(playerPed),
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
	if array.show_imgui_nametag.v then nameTagOff() end
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
	local dlstatus = require('moonloader').download_status
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
						if array.lang_chat.v then sampAddChatMessage(tag..'Âû èñïîëüçóåòå {0E8604}àêòóàëüíóþ {888EA0}âåðñèþ ñêðèïòà', main_color)
						elseif not array.lang_chat.v then sampAddChatMessage(tag..'You are using {0E8604}the current {888EA0}version of the script', main_color) end
					elseif updateversion > version_script then
						if array.lang_chat.v then sampAddChatMessage(tag..'Âû èñïîëüçóåòå {B31A06}íåàêòóàëüíóþ {888EA0}âåðñèþ ñêðèïòà. Äëÿ îáíîâëåíèÿ, ââåäèòå: {F9D82F}/z_update', main_color)
						elseif not array.lang_chat.v then sampAddChatMessage(tag..'You are using an {B31A06}irrelevant {888EA0}version of the script. To update, write: {F9D82F}/z_update', main_color) end
					elseif updateversion < version_script then
						if array.lang_chat.v then sampAddChatMessage(tag..'Âû èñïîëüçóåòå{F9D82F} òåñòîâóþ {888EA0}âåðñèþ ñêðèïòà', main_color)
						elseif not array.lang_chat.v then sampAddChatMessage(tag..'You are using {F9D82F}testing {888EA0}version of the script', main_color) end
					else
						update = false
					end
				end
			else
				if array.lang_chat.v then sampAddChatMessage(tag..'{B31A06}Íå óäàëîñü {888EA0}ïðîâåðèòü âåðñèþ ñêðèïòà', main_color)
				elseif not array.lang_chat.v then sampAddChatMessage(tag..'{B31A06}Failed {888EA0}to check the version of the script', main_color) end
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
