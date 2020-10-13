script_name('zuwi')
script_authors('PanSeek')
version_script = '0.928'
script_properties('work-in-pause')

--ToggleButton 49 последняя
--local wm = require 'lib.windows.message'
require 'lib.moonloader'
local sf = require 'sampfuncs'
local dlstatus = require('moonloader').download_status
local lanes = require('lanes').configure()
local imgui = require 'imgui'
local key = require 'vkeys'
local imadd = require 'imgui_addons'
local rkeys = require 'rkeys'
local fa = require 'faIcons'
local sampev = require 'lib.samp.events'
local samem = require 'SAMemory'
local Matrix3X3 = require 'matrix3x3'
local Vector3D = require 'vector3d'
local mem = require 'memory'
local inicfg = require 'inicfg'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
-- if not doesDirectoryExist("moonloader\\config\\zuwi") then
-- 	createDirectory("moonloader\\config\\zuwi")
-- end 
local ps = {
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
		-- allVehNitro = false,
		-- onlyWheels = false,
		-- tankMode = false,
		-- vehFloatAwayWhenHit = false,
		driveOnWater 		= false,
		restoreHealth 		= false,
		engineOn 			= false
	},
	weapon = {
		infAmmo 			= false
		-- fullAiming = false
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
		--reconnectDelay = 1
	},
	visual = {
		nameTag 			= false,
		infoBar 			= false,
		adminBar 			= false,
		friendBar 			= false
	},
	menu = {
		checkUpdate 		= true,
		language_menu 		= false,
		language_chat 		= false,
		language_dialogs 	= false,
		autoSave 			= false,
		iStyle 				= 0
	},
	admintools = {
		adminChat 			= false,
		newCMD 				= false,
		shortCMD 			= false
	}--,
	-- commands = {
	-- 	z_authors = 'zauthors',
	-- 	z_date = 'zdate',
	-- 	z_menu = 'zmenu',
	-- 	z_suicide = 'zsuicide',
	-- 	z_coord = 'zcoord',
	-- 	z_getmoney = 'zgetmoney',
	-- 	z_fakerepair = 'zfakerepair',
	-- 	z_togall = 'ztogall',
	-- 	z_errors = 'zerrors',
	-- 	z_time = 'ztime',
	-- 	z_weather = 'zweather',
	-- 	z_setmark = 'zsetmark',
	-- 	z_tpmark = 'ztpmark',
	-- 	z_clearchat = 'zcc',
	-- 	z_version = 'zversion',
	-- 	z_update = 'zupdate',
	-- 	z_checktime = 'zchecktime',
	-- 	z_help = 'zhelp',
	-- 	z_helpcmdsamp = 'zhelpcmdsamp',
	-- 	z_reload = 'zreload'
	--}
}
dirIni = inicfg.load(ps, "zuwi.lua.ini") --.. "\\zuwi\\settings.ini"

--ТЕГИ И ПРОЧЕЕ
local tag = '{F9D82F}zuwi {888EA0}- '
local authorsRUS = [[{B31A06}PanSeek {888EA0}- {F9D82F}Автор

{0E8604}Благодарности{888EA0}:
{B31A06}fran9 {888EA0}- {F9D82F}Помогал с цветами/расположением меню/AdminTools для Revent-RP
{B31A06}FYP {888EA0}- {F9D82F}Исходный код
{B31A06}FBenz {888EA0}- {F9D82F}Помогал в некоторых вопросах/советовал
{B31A06}cover {888EA0}- {F9D82F}Исходный код

{0E8604}А также спасибо всем, кто тестировал скрипт и сообщал о некоторых проблемах/багах]]
local authorsENG = [[{B31A06}PanSeek {888EA0}- {F9D82F}Author

{0E8604}Thanks{888EA0}:
{B31A06}fran9 {888EA0}- {F9D82F}Helped with colors/location menu/AdminTools for Revent-RP
{B31A06}FYP {888EA0}- {F9D82F}Source
{B31A06}FBenz {888EA0}- {F9D82F}Helped in some questions/advised
{B31A06}cover {888EA0}- {F9D82F}Source

{0E8604}And also thanks to everyone who tested the script and reported some problems/bugs]]
imgIntGameRUS = {[[Приветствуем Вас, дорогой пользователь! В данном проекте есть вспомогательные функции для Вашей игры в SA-MP.
Поможем Вам разобраться в zuwi: Вы сверху видите вкладки, такие как, "Персонаж", "Транспорт", "Оружие" и т.д.
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
Для пожеланий и прочего, пишите в группу ВК: vk.com/creationpanseek или в тему на Blast.hk: URL.
Если Вы хотите помочь данному проекту материально, можете сделать это через группу ВК -> "Донат".
Будем очень благодарны за любую помощь! С любовью проект zuwi :3]]}
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
For suggestions and other things, write to VK group: vk.com/creationpanseek or to the topic on Blast.hk: URL.
If you want to help this project financially, you can do it through the VK group -> "Донат".
We will be very grateful for any help! With love project zuwi: 3]]}
--ERRORS
local errorRUS = {tag..'{B31A06}Ошибка #1 {888EA0}({F9D82F}Ваш игрок мертв/не существует{888EA0})',
tag..'{B31A06}Ошибка #2 {888EA0}({F9D82F}Ваш игрок не в транспорте{888EA0})',
tag..'{B31A06}Ошибка #3 {888EA0}({F9D82F}Открыт игровой чат{888EA0})',
tag..'{B31A06}Ошибка #4 {888EA0}({F9D82F}Открыт SampFuncs чат{888EA0})',
tag..'{B31A06}Ошибка #5 {888EA0}({F9D82F}Открыт диалог{888EA0})',
tag..'{B31A06}Ошибка #6 {888EA0}({F9D82F}Ваш игрок мертв/не существует или не в транспорте{888EA0})',
tag..'{B31A06}Ошибка #7 {888EA0}({F9D82F}У Вас открыт игровой чат/SampFuncs чат/диалог{888EA0})',
tag..'{B31A06}Ошибка #8 {888EA0}({F9D82F}Ваш игрок не в транспорте или у Вас открыт игровой чат/SampFuncs чат/диалог{888EA0})',
tag..'{B31A06}Ошибка #9 {888EA0}({F9D82F}Ваш игрок мертв/не существует или у Вас открыт игровой чат/SampFuncs чат/диалог{888EA0})',
tag..'{B31A06}Ошибка #10 {888EA0}({F9D82F}Транспорт не найден{888EA0})',
tag..'{B31A06}Ошибка #11 {888EA0}({F9D82F}Уже открыт другой диалог{888EA0})',
tag..'{B31A06}Ошибка #12 {888EA0}(Не найдено время. Напишите: {F9D82F}/z_time 0-23{888EA0})',
tag..'{B31A06}Ошибка #13 {888EA0}(Погода не найдена. Напишите: {F9D82F}/z_weather 0-45{888EA0})',
tag..'{B31A06}Ошибка #14 {888EA0}({F9D82F}Метка не создана{888EA0})',
tag..'{B31A06}Ошибка #15 {888EA0}({F9D82F}Вы находитесь в интерьере{888EA0})'}
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
local helpcmdsampRUS = [[{F9D82F}/headmove - {0984d2}Включает/Выключает {888EA0}поворот головы
{F9D82F}/timestamp {888EA0}- {0984d2}Включает/Выключает {888EA0}время возле каждого сообщения
{F9D82F}/pagesize {888EA0}- Устанавливает количество строк в чате
{F9D82F}/quit (/q) {888EA0}- Быстрый выход из игры
{F9D82F}/save [комментарий] {888EA0}- Сохранение координат в {F9D82F}savedposition.txt
{F9D82F}/fpslimit {888EA0}- Устанавливает лимит кадров в секунду
{F9D82F}/dl {888EA0}- {0984d2}Включает/Выключает {888EA0}подробную информацию о транспорте по близости
{F9D82F}/interior {888EA0}- Выводит в чат текущий интерьер
{F9D82F}/rs {888EA0}- Сохранение координат в {F9D82F}rawposition.txt
{F9D82F}/mem {888EA0}- Отображает сколько памяти использует SA-MP]]
local helpcmdsampENG = [[{F9D82F}/headmove - {0984d2}On/Off {888EA0}head rotation
{F9D82F}/timestamp {888EA0}- {0984d2}On/Off {888EA0}time near each message
{F9D82F}/pagesize {888EA0}- Set the number of lines in the chat
{F9D82F}/quit (/q) {888EA0}- Quick exit from the game
{F9D82F}/save [комментарий] {888EA0}- Save coordinates to {F9D82F}savedposition.txt
{F9D82F}/fpslimit {888EA0}- Set the frames per second limit
{F9D82F}/dl {888EA0}- {0984d2}On/Off {888EA0}detailed information about near vehicle
{F9D82F}/interior {888EA0}- Current interior to chat
{F9D82F}/rs {888EA0}- Save coordinates to {F9D82F}rawposition.txt
{F9D82F}/mem {888EA0}- How much memory SA-MP uses]]
local errorslistRUS = [[{B31A06}#1 {888EA0}- {F9D82F}Ваш игрок мертв/не существует
{B31A06}#2 {888EA0}- {F9D82F}Ваш игрок не в транспорте
{B31A06}#3 {888EA0}- {F9D82F}Открыт игровой чат
{B31A06}#4 {888EA0}- {F9D82F}Открыт SampFuncs чат
{B31A06}#5 {888EA0}- {F9D82F}Открыт диалог
{B31A06}#6 {888EA0}- {F9D82F}Ваш игрок мертв/не существует или не в транспорте
{B31A06}#7 {888EA0}- {F9D82F}У Вас открыт игровой чат/SampFuncs чат/диалог
{B31A06}#8 {888EA0}- {F9D82F}Ваш игрок не в транспорте или у Вас открыт игровой чат/SampFuncs чат/диалог
{B31A06}#9 {888EA0}- {F9D82F}Ваш игрок мертв/не существует или у Вас открыт игровой чат/SampFuncs чат/диалог
{B31A06}#10 {888EA0}- {F9D82F}Транспорт не найден
{B31A06}#11 {888EA0}- {F9D82F}Уже открыт другой диалог
{B31A06}#12 {888EA0}- {F9D82F}Время не найдено
{B31A06}#13 {888EA0}- {F9D82F}Погода не найдена
{B31A06}#14 {888EA0}- {F9D82F}Метка не создана
{B31A06}#15 {888EA0}- {F9D82F}Вы находитесь в интерьере]]
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
--переменные
local checkTabs = 'zuwi'
local active = true
reduceZoom = true
enabled = true
CheckLangMenu = false
CheckLangChat = false
CheckLangDialogs = false
CheckAirBrake = false
CheckGMactor = false
CheckGMveh = false
CheckGMWveh = false
checkClickwarp = false
Admin = false
local airBrakeCoords = {}
langIG = {}
--Настройки imgui
local btn_size = imgui.ImVec2(-0.1, 0)
local sw, sh = getScreenResolution()
--Настройки меню (imgui)
main_window_state 								= imgui.ImBool(false)
local show_imgui_infRun 						= imgui.ImBool(dirIni.actor.infRun)
local show_imgui_infSwim 						= imgui.ImBool(dirIni.actor.infSwim)
local show_imgui_infOxygen 						= imgui.ImBool(dirIni.actor.infOxygen)
local show_imgui_megajumpActor 					= imgui.ImBool(dirIni.actor.megaJump)
local show_imgui_fastsprint 					= imgui.ImBool(dirIni.actor.fastSprint)
local show_imgui_suicideActor 					= imgui.ImBool(dirIni.actor.suicide)
local show_imgui_unfreeze 						= imgui.ImBool(dirIni.actor.unfreeze)
local show_imgui_nofall 						= imgui.ImBool(dirIni.actor.noFall)
local show_imgui_gmActor 						= imgui.ImBool(dirIni.actor.GM)
local show_imgui_engineOnVeh 					= imgui.ImBool(dirIni.vehicle.engineOn)
local show_imgui_restHealthVeh 					= imgui.ImBool(dirIni.vehicle.restoreHealth)
local show_imgui_megajumpBMX 					= imgui.ImBool(dirIni.vehicle.megaJumpBMX)
local show_imgui_flip180 						= imgui.ImBool(dirIni.vehicle.flip180)
local show_imgui_flipOnWheels 					= imgui.ImBool(dirIni.vehicle.flipOnWheels)
local show_imgui_suicideVeh 					= imgui.ImBool(dirIni.vehicle.boom)
local show_imgui_hopVeh 						= imgui.ImBool(dirIni.vehicle.hop)
local show_imgui_fastexit 						= imgui.ImBool(dirIni.vehicle.fastExit)
local show_imgui_gmWheels 						= imgui.ImBool(dirIni.vehicle.gmWheels)
local show_imgui_antiBikeFall 					= imgui.ImBool(dirIni.vehicle.AntiBikeFall)
local show_imgui_gmVeh 							= imgui.ImBool(dirIni.vehicle.GM)
local show_imgui_fixWheels 						= imgui.ImBool(dirIni.vehicle.fixWheels)
local show_imgui_speedhack 						= imgui.ImBool(dirIni.vehicle.speedhack)
local SpeedHackMaxSpeed 						= imgui.ImFloat(dirIni.vehicle.speedhackMaxSpeed)
local show_imgui_perfectHandling 				= imgui.ImBool(dirIni.vehicle.perfectHandling)
local show_imgui_driveOnWater 					= imgui.ImBool(dirIni.vehicle.driveOnWater)
-- local show_imgui_allCarsNitro				= imgui.ImBool(dirIni.vehicle.allVehNitro)
-- local show_imgui_carsFloatWhenHit 			= imgui.ImBool(dirIni.vehicle.vehFloatAwayWhenHit)
-- local show_imgui_tankMode					= imgui.ImBool(dirIni.vehicle.tankMode)
-- local show_imgui_onlyWheels					= imgui.ImBool(dirIni.vehicle.onlyWheels)
local show_imgui_infAmmo 						= imgui.ImBool(dirIni.weapon.infAmmo)
-- local show_imgui_fullaiming					= imgui.ImBool(dirIni.weapon.fullAiming)
local show_imgui_UnderWater 					= imgui.ImBool(dirIni.misc.WalkDriveUnderWater)
local show_imgui_FOV 							= imgui.ImBool(dirIni.misc.FOV)
local FOV_value 								= imgui.ImFloat(dirIni.misc.FOVvalue)
local show_imgui_antibhop 						= imgui.ImBool(dirIni.misc.antibhop)
local show_imgui_AirBrake 						= imgui.ImBool(dirIni.misc.AirBrake)
local AirBrake_Speed 							= imgui.ImFloat(dirIni.misc.AirBrakeSpeed)
local show_imgui_quickMap 						= imgui.ImBool(dirIni.misc.quickMap)
local show_imgui_blink 							= imgui.ImBool(dirIni.misc.blink)
local blink_dist								= imgui.ImFloat(dirIni.misc.blinkDist)
local show_imgui_sensfix 						= imgui.ImBool(dirIni.misc.sensfix)
local show_imgui_reconnect 						= imgui.ImBool(dirIni.misc.reconnect)
local show_imgui_clrScr 						= imgui.ImBool(dirIni.misc.clearScreenshot)
local show_imgui_clickwarp						= imgui.ImBool(dirIni.misc.ClickWarp)
local show_imgui_nametag 						= imgui.ImBool(dirIni.visual.nameTag)
local infbar 									= imgui.ImBool(dirIni.visual.infoBar)
local checkupdate 								= imgui.ImBool(dirIni.menu.checkUpdate)
local lang_menu 								= imgui.ImBool(dirIni.menu.language_menu) --false - english/true - russian
local lang_chat 								= imgui.ImBool(dirIni.menu.language_chat) --false - english/true - russian
local lang_dialogs 								= imgui.ImBool(dirIni.menu.language_dialogs) --false - english/true - russian
local AutoSave 									= imgui.ImBool(dirIni.menu.autoSave)
local comboStyle 								= imgui.ImInt(dirIni.menu.iStyle)
local at_chat									= imgui.ImBool(dirIni.admintools.adminChat)
local at_scmd									= imgui.ImBool(dirIni.admintools.shortCMD)
local at_ncmd									= imgui.ImBool(dirIni.admintools.newCMD)

-- local cmd_authors2 = imgui.ImBuffer(tostring(dirIni.commands.z_authors), 16)
-- local cmd_date2 = imgui.ImBuffer(tostring(dirIni.commands.z_date), 16)
-- local cmd_imgui2 = imgui.ImBuffer(tostring(dirIni.commands.z_menu), 16)
-- local cmd_suicide2 = imgui.ImBuffer(tostring(dirIni.commands.z_suicide), 16)
-- local cmd_coord2 = imgui.ImBuffer(tostring(dirIni.commands.z_coord), 16)
-- local cmd_getmoney2 = imgui.ImBuffer(tostring(dirIni.commands.z_getmoney), 16)
-- local cmd_fakerepair2 = imgui.ImBuffer(tostring(dirIni.commands.z_fakerepair), 16)
-- local cmd_togall2 = imgui.ImBuffer(tostring(dirIni.commands.z_togall), 16)
-- local cmd_errors2 = imgui.ImBuffer(tostring(dirIni.commands.z_errors), 16)
-- local cmd_time2 = imgui.ImBuffer(tostring(dirIni.commands.z_time), 16)
-- local cmd_weather2 = imgui.ImBuffer(tostring(dirIni.commands.z_weather), 16)
-- local cmd_setmark2 = imgui.ImBuffer(tostring(dirIni.commands.z_setmark), 16)
-- local cmd_tpmark2 = imgui.ImBuffer(tostring(dirIni.commands.z_tpmark), 16)
-- local cmd_clearchat2 = imgui.ImBuffer(tostring(dirIni.commands.z_clearchat), 16)
-- local cmd_version2 = imgui.ImBuffer(tostring(dirIni.commands.z_version), 16)
-- local cmd_update2 = imgui.ImBuffer(tostring(dirIni.commands.z_update), 16)
-- local cmd_checktime2 = imgui.ImBuffer(tostring(dirIni.commands.z_checktime), 16)
-- local cmd_help2 = imgui.ImBuffer(tostring(dirIni.commands.z_help), 16)
-- local cmd_helpcmdsamp2 = imgui.ImBuffer(tostring(dirIni.commands.z_helpcmdsamp), 16)
-- local cmd_reload2 = imgui.ImBuffer(tostring(dirIni.commands.z_reload), 16)
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
		colors[clr.Text] 				= ImVec4(0.80, 0.80, 0.83, 1.00)
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
setInterfaceStyle(dirIni.menu.iStyle)

function imgui.OnDrawFrame(args)
	if main_window_state.v then
		imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(875, 470), imgui.Cond.FirstUseEver)
		imgui.Begin('zuwi | Version: '.. version_script, main_window_state, imgui.WindowFlags.NoResize)
		-- if lang_menu == 2 then
		-- 	imgui.Text(u8'Выберите язык/Select language')
		-- 	if imgui.Button(u8'Русский') then lang_menu.v = not lang_menu.v end
		-- 	imgui.SameLine(nil,x)
		-- 	if imgui.Button('English') then lang_menu.v = not lang_menu.v end
		if not lang_menu.v then
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
		elseif lang_menu.v then
			imgui.CenterTextColoredRGB(checkTabs)
			if imgui.Button(fa.ICON_STREET_VIEW .. u8' Персонаж', imgui.ImVec2(100, 0)) then checkTabs = 'zuwi -> Персонаж' act1 = 1 end
			imgui.SameLine(nil, x)
			if imgui.Button(fa.ICON_CAR .. u8' Транспорт', imgui.ImVec2(100, 0)) then checkTabs = 'zuwi -> Транспорт' act1 = 2 end
			imgui.SameLine(nil, x)
			if imgui.Button(fa.ICON_BOMB .. u8' Оружие', imgui.ImVec2(100, 0)) then checkTabs = 'zuwi -> Оружие' act1 = 3 end
			imgui.SameLine(nil, x)
			if imgui.Button(fa.ICON_ADJUST .. u8' Разное', imgui.ImVec2(100, 0)) then checkTabs = 'zuwi -> Разное' act1 = 4 end
			imgui.SameLine(nil, x)
			if imgui.Button(fa.ICON_EYE .. u8' Визуалы', imgui.ImVec2(100, 0)) then checkTabs = 'zuwi -> Визуалы' act1 = 5 end
			imgui.SameLine(nil, x)
			if imgui.Button(fa.ICON_COG .. u8' Настройки', imgui.ImVec2(100, 0)) then checkTabs = 'zuwi -> Настройки' act1 = 6 end
			imgui.SameLine(nil, x)
			if imgui.Button(fa.ICON_INFO .. u8' Помощь', imgui.ImVec2(100, 0)) then checkTabs = 'zuwi -> Помощь' act1 = 8 end
		end
		-- imgui.SameLine(nil,x)
		-- if imgui.Button(fa.ICON_INFO .. ' Log In', imgui.ImVec2(70,0)) then checkTabs = 'zuwi -> Log In' act1 = 10 end
		if imgui.Button(fa.ICON_SERVER .. ' Revent-RP', imgui.ImVec2(100, 0)) then checkTabs = 'zuwi -> Revent-RP' act1 = 9 end
		imgui.SameLine(nil, x)
		if imgui.Button(fa.ICON_SERVER .. ' Online-RP', imgui.ImVec2(100, 0)) then checkTabs = 'zuwi -> Online-RP' act1 = 10 end		

		if act1 == 1 then --ACTOR IMGUI
			imgui.BeginChild('1', imgui.ImVec2(855, 370), true)
			if lang_menu.v then
				imgui.ToggleButton('1', 'Бесконечная выносливость (бег)', show_imgui_infRun)
				imgui.ToggleButton('32', 'Бесконечная выносливость (плавание)', show_imgui_infSwim)
				imgui.ToggleButton('2', 'Бесконечный кислород', show_imgui_infOxygen)
				imgui.ToggleButton('3', 'Мега прыжок', show_imgui_megajumpActor)
				imgui.ToggleButton('4', 'Быстрый бег', show_imgui_fastsprint)
				imgui.ToggleButton('5', 'Без падений', show_imgui_nofall)
				imgui.ToggleButton('6', 'Разморозить', show_imgui_unfreeze)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8"Если функция включена, используйте: /")
				imgui.ToggleButton('7', 'Суицид', show_imgui_suicideActor)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8"Если функция включена, используйте: F3\nЕсли функция 'Взрыв транспорта' включен во вкладке 'Транспорт' то произойдет только суицид\nЕсли обе функции включены, то произойдет взрыв транспорта, а если Вы не в транспорте, то Вы совершите суицид")
				imgui.ToggleButton('37', 'Бесконечное здоровье', show_imgui_gmActor)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8"Если функция включена, используйте: Insert")
			elseif not lang_menu.v then
				imgui.ToggleButton('1', 'Infinity stamina (run)', show_imgui_infRun)
				imgui.ToggleButton('32', 'Infinity stamina (swim)', show_imgui_infSwim)
				imgui.ToggleButton('2', 'Infinity oxygen', show_imgui_infOxygen)
				imgui.ToggleButton('3', 'Mega jump', show_imgui_megajumpActor)
				imgui.ToggleButton('4', 'Fast sprint', show_imgui_fastsprint)
				imgui.ToggleButton('5', 'No fall', show_imgui_nofall)
				imgui.ToggleButton('6', 'Unfreeze', show_imgui_unfreeze)
					imgui.SameLine(nil, x)
					imgui.TextQuestion("If function enabled then use key: /")
				imgui.ToggleButton('7', 'Suicide', show_imgui_suicideActor)
					imgui.SameLine(nil, x)
					imgui.TextQuestion("If function enabled then use key: F3\nIf function 'Boom vehicle' enabled in tab 'Vehicle' then will be only suicide\nThat is, if both functions are enabled, then you will boom vehicle, and not in vehicle will suicide")
				imgui.ToggleButton('37', 'GM', show_imgui_gmActor)
					imgui.SameLine(nil, x)
					imgui.TextQuestion("If function enabled then use key: Insert")
			end
			imgui.EndChild()

		elseif act1 == 2 then --VEHICLE IMGUI
			imgui.BeginChild('2', imgui.ImVec2(855, 370), true)
			if lang_menu.v then
				imgui.ToggleButton('31', 'SpeedHack', show_imgui_speedhack)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8"Если функция включена, используйте: ALT")
					imgui.SameLine(nil, x)
					imgui.SliderFloat(u8'Максимальная скорость', SpeedHackMaxSpeed, 80, 300, '%.f', 0.5)
				imgui.ToggleButton('8', 'Переворот на 180', show_imgui_flip180)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8"Если функция включена, используйте: Backspace")
				imgui.ToggleButton('9', 'Переворот на колеса', show_imgui_flipOnWheels)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8"Если функция включена, используйте: Delete")
				imgui.ToggleButton('10', 'Прыжочек', show_imgui_hopVeh)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8"Если функция включена, используйте: B")
				imgui.ToggleButton('11', 'Взрыв транспорта', show_imgui_suicideVeh)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8"Если функция включена, используйте: F3\nЕсли функция 'Суицид' включена во вкладке 'Персонаж' то произойдет только взрыв транспорта\nЕсли обе функции включены, то произойдет взрыв транспорта, а если Вы не в транспорте, то Вы совершите суицид")
				imgui.ToggleButton('12', 'Быстрый выход', show_imgui_fastexit)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8"Если функция включена, используйте: N")
				imgui.ToggleButton('13', 'Починить колеса', show_imgui_fixWheels)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8"Если функция включена, используйте: Z+1")
				imgui.ToggleButton('14', 'Anti-bike fall', show_imgui_antiBikeFall)
				imgui.ToggleButton('15', 'Мега BMX прыжок', show_imgui_megajumpBMX)
				imgui.ToggleButton('34', 'Идеальная езда', show_imgui_perfectHandling)
				-- imgui.ToggleButton('45', 'У всего транспорта нитро', show_imgui_allCarsNitro)
				-- imgui.ToggleButton('46', 'Только колеса', show_imgui_onlyWheels)
				-- imgui.ToggleButton('47', 'Танк мод', show_imgui_tankMode)
				-- imgui.ToggleButton('48', 'Транспорт отлетает если в него стрельнуть', show_imgui_carsFloatWhenHit)
				imgui.ToggleButton('35', 'Езда по воде', show_imgui_driveOnWater)
				imgui.ToggleButton('38', 'Починить транспорт', show_imgui_restHealthVeh)
					imgui.SameLine(nil,x)
					imgui.TextQuestion(u8'Если функция включена, используйте: 1')
				imgui.ToggleButton('39', 'Двигатель включен', show_imgui_engineOnVeh)
				imgui.Separator()
				imgui.TextColoredRGB('{0984d2}GM')
				imgui.ToggleButton('16', 'Обычный', show_imgui_gmVeh)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8"Если функция включена, используйте: Home+1")
				imgui.SameLine(nil, x)
				imgui.ToggleButton('17', 'Колеса', show_imgui_gmWheels)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8"Если функция включена, используйте: Home+2")
			elseif not lang_menu.v then
				imgui.ToggleButton('31', 'SpeedHack', show_imgui_speedhack)
					imgui.SameLine(nil, x)
					imgui.TextQuestion("If function enabled then use key: ALT")
					imgui.SameLine(nil, x)
					imgui.SliderFloat('Max speed', SpeedHackMaxSpeed, 80, 300, '%.f', 0.5)
				imgui.ToggleButton('8', 'Flip 180', show_imgui_flip180)
					imgui.SameLine(nil, x)
					imgui.TextQuestion("If function enabled then use key: Backspace")
				imgui.ToggleButton('9', 'Flip on wheels', show_imgui_flipOnWheels)
					imgui.SameLine(nil, x)
					imgui.TextQuestion("If function enabled then use key: Delete")
				imgui.ToggleButton('10', 'Hop', show_imgui_hopVeh)
					imgui.SameLine(nil, x)
					imgui.TextQuestion("If function enabled then use key: B\n")
				imgui.ToggleButton('11', 'Boom vehicle', show_imgui_suicideVeh)
					imgui.SameLine(nil, x)
					imgui.TextQuestion("If function enabled then use key: F3\nIf function 'Suicide' enabled in tab 'Actor' then will be only boom vehicle\nThat is, if both functions are enabled, then you will boom vehicle, and not in transport will suicide")
				imgui.ToggleButton('12', 'Fast exit', show_imgui_fastexit)
					imgui.SameLine(nil, x)
					imgui.TextQuestion("If function enabled then use key: N")
				imgui.ToggleButton('13', 'Restore wheels', show_imgui_fixWheels)
					imgui.SameLine(nil, x)
					imgui.TextQuestion("If function enabled then use keys: Z+1")
				imgui.ToggleButton('14', 'Anti-bike fall', show_imgui_antiBikeFall)
				imgui.ToggleButton('15', 'Mega BMX jump', show_imgui_megajumpBMX)
				imgui.ToggleButton('34', 'Perfect handling', show_imgui_perfectHandling)
				-- imgui.ToggleButton('45', 'All cars have nitro', show_imgui_allCarsNitro)
				-- imgui.ToggleButton('46', 'Only wheels', show_imgui_onlyWheels)
				-- imgui.ToggleButton('47', 'Tank mode', show_imgui_tankMode)
				-- imgui.ToggleButton('48', 'Vehicle float away when hit', show_imgui_carsFloatWhenHit)
				imgui.ToggleButton('35', 'Drive on water', show_imgui_driveOnWater)
				imgui.ToggleButton('38', 'Restore health', show_imgui_restHealthVeh)
					imgui.SameLine(nil,x)
					imgui.TextQuestion('If function enabled then use key: 1')
				imgui.ToggleButton('39', 'Engine on', show_imgui_engineOnVeh)
				imgui.Separator()
				imgui.TextColoredRGB('{0984d2}GM')
				imgui.ToggleButton('16', 'Default', show_imgui_gmVeh)
					imgui.SameLine(nil, x)
					imgui.TextQuestion("If function enabled then use keys: Home+1")
				imgui.SameLine(nil, x)
				imgui.ToggleButton('17', 'Wheels', show_imgui_gmWheels)
					imgui.SameLine(nil, x)
					imgui.TextQuestion("If function enabled then use keys: Home+2")
			end
			imgui.EndChild()

		elseif act1 == 3 then --WEAPON IMGUI
			imgui.BeginChild('3', imgui.ImVec2(855, 370), true)
			if lang_menu.v then
				imgui.ToggleButton('18', 'Бесконечные патроны, без перезарядки', show_imgui_infAmmo)
				-- imgui.ToggleButton('49', 'Полное прицеливание', show_imgui_fullaiming)
			elseif not lang_menu.v then
				imgui.ToggleButton('18', 'Infinity ammo and no reload', show_imgui_infAmmo)
				-- imgui.ToggleButton('49', 'Full aiming', show_imgui_fullaiming)
			end
			imgui.EndChild()

		elseif act1 == 4 then --MISC IMGUI
			imgui.BeginChild('4', imgui.ImVec2(855, 370), true)
			if lang_menu.v then
				if imgui.Button(fa.ICON_GLOBE .. u8' Главное') then checkTabs = 'zuwi -> Разное -> Главное' act4 = 1 end
				imgui.SameLine(nil, x)
				if imgui.Button(fa.ICON_LOCATION_ARROW .. u8' Телепорты') then checkTabs = 'zuwi -> Разное -> Телепорты' act4 = 2 end
				imgui.Separator()
				if act4 == 1 then
					imgui.ToggleButton('19', 'AirBrake', show_imgui_AirBrake)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8"Если функция включена, используйте: RShift")
					imgui.SameLine(nil, 79)
					imgui.SliderFloat(u8'Скорость', AirBrake_Speed, 0.1, 14.9, '%.1f', 1.5)
					imgui.ToggleButton('20', 'Поле зрения', show_imgui_FOV)
					imgui.SameLine(nil, x)
					imgui.SliderFloat(u8'Значение', FOV_value, 70.0, 108.0, '%.f', 0.5)
					imgui.ToggleButton('21', 'Быстрый телепорт', show_imgui_blink)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8"Если функция включена, используйте: X\nВас телепортирует на определенное количество метров вперед")
					imgui.SameLine(nil, 18)
					imgui.SliderFloat(u8'Дистанция', blink_dist, 1, 150, '%.f', 1.5)
					imgui.ToggleButton('43', 'ClickWarp', show_imgui_clickwarp)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8"Если функция включена, используйте: Колесо мыши")
					imgui.ToggleButton('22', 'Анти BHop', show_imgui_antibhop)
					imgui.ToggleButton('23', 'Быстрая карта', show_imgui_quickMap)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8"Если функция включена, используйте: M")
					imgui.ToggleButton('24', 'Исправление чувствительности', show_imgui_sensfix)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8'Функция не тестировалась')
					imgui.ToggleButton('25', 'Перезаход', show_imgui_reconnect)
					imgui.SameLine(nil, x)
					imgui.TextQuestion(u8'Если функция включена, используйте: LSHFIT+0')
					imgui.ToggleButton('33', 'Чистрый скриншот', show_imgui_clrScr)
					imgui.ToggleButton('36', 'Езда/Ходьба под водой', show_imgui_UnderWater)
				elseif act4 == 2 then
					if imgui.CollapsingHeader(u8'Телепорты в интерьеры') then
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
					if imgui.CollapsingHeader(u8'Остальные телепорты') then
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

			elseif not lang_menu.v then
				if imgui.Button(fa.ICON_GLOBE ..' Main') then checkTabs = 'zuwi -> Misc -> Main' act4 = 1 end
				imgui.SameLine(nil, x)
				if imgui.Button(fa.ICON_LOCATION_ARROW ..' Teleports') then checkTabs = 'zuwi -> Misc -> Teleports' act4 = 2 end
				imgui.Separator()
				if act4 == 1 then
					imgui.ToggleButton('19', 'AirBrake', show_imgui_AirBrake)
					imgui.SameLine(nil, x)
					imgui.TextQuestion("If function enabled then use key: RShift")
					imgui.SameLine(nil, 9)
					imgui.SliderFloat('Speed', AirBrake_Speed, 0.1, 14.9, '%.1f', 1.5)
					imgui.ToggleButton('20', 'FOV changer', show_imgui_FOV)
					imgui.SameLine(nil, x)
					imgui.SliderFloat('Value', FOV_value, 70.0, 108.0, '%.f', 0.5)
					imgui.ToggleButton('21', 'Blink', show_imgui_blink)
					imgui.SameLine(nil, x)
					imgui.TextQuestion("If function enabled then use key: X\nYou teleport a certain number of meters ahead")
					imgui.SameLine(nil, 29)
					imgui.SliderFloat('Distance', blink_dist, 1, 150, '%.f', 1.5)
					imgui.ToggleButton('43', 'ClickWarp', show_imgui_clickwarp)
					imgui.SameLine(nil, x)
					imgui.TextQuestion("If function enabled then use key: Mouse wheels")
					imgui.ToggleButton('22', 'Anti BHop', show_imgui_antibhop)
					imgui.ToggleButton('23', 'Quick map', show_imgui_quickMap)
					imgui.SameLine(nil, x)
					imgui.TextQuestion("If function enabled then use key: M")
					imgui.ToggleButton('24', 'Sensetivity fix', show_imgui_sensfix)
					imgui.SameLine(nil, x)
					imgui.TextQuestion('Function do not tested')
					imgui.ToggleButton('25', 'Reconnect', show_imgui_reconnect)
					imgui.SameLine(nil, x)
					imgui.TextQuestion('If function enabled then use key: LSHFIT+0')
					imgui.ToggleButton('33', 'Clear screenshot', show_imgui_clrScr)
					imgui.ToggleButton('36', 'Drive/Walk under water', show_imgui_UnderWater)
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
			if lang_menu.v then
				if imgui.Button(fa.ICON_WINDOW_MAXIMIZE .. u8' Главное') then checkTabs = 'zuwi -> Визуалы -> Главное' act5 = 1 end
				imgui.SameLine(nil, x)
				if imgui.Button(fa.ICON_STREET_VIEW .. u8' Игроки') then checkTabs = 'zuwi -> Визуалы -> Игроки' act5 = 2 end
				imgui.Separator()
				if act5 == 1 then
					imgui.ToggleButton('40', 'Информационная панель', infbar)
					-- imgui.Spacing()
					-- imgui.ToggleButton('', 'Проверка администрации', admbar)
					-- imgui.SameLine(nil,x)
					-- imgui.ToggleButton('', 'Проверка друзей', frdbar)
				elseif act5 == 2 then
					if imgui.CollapsingHeader('WallHack') then
						imgui.ToggleButton('31', 'Name tag', show_imgui_nametag)
					end
				end
			elseif not lang_menu.v then
				if imgui.Button(fa.ICON_WINDOW_MAXIMIZE ..' Main') then checkTabs = 'zuwi -> Visual -> Main' act5 = 1 end
				imgui.SameLine(nil, x)
				if imgui.Button(fa.ICON_STREET_VIEW ..' Players') then checkTabs = 'zuwi -> Visual -> Players' act5 = 2 end
				imgui.Separator()
				if act5 == 1 then
					imgui.ToggleButton('40', 'Info bar', infbar)
					-- imgui.Spacing()
					-- imgui.ToggleButton('', 'Check administrations', admbar)
					-- imgui.SameLine(nil,x)
					-- imgui.ToggleButton('', 'Check friends', frdbar)
				elseif act5 == 2 then
					if imgui.CollapsingHeader('WallHack') then
						imgui.ToggleButton('31', 'Name tag', show_imgui_nametag)
					end
				else act5 = 1 end
			end
			imgui.EndChild()

		elseif act1 == 6 then --SETTINGS IMGUI
			imgui.BeginChild('6', imgui.ImVec2(855, 370), true)
			if lang_menu.v then
				if imgui.Button(fa.ICON_WINDOW_MAXIMIZE .. u8' Меню') then checkTabs = 'zuwi -> Настройки -> Меню' act6 = 1 end
				imgui.SameLine(nil, x)
				if imgui.Button(fa.ICON_CLOUD_DOWNLOAD .. u8' Обновления') then checkTabs = 'zuwi -> Настройки -> Обновления' act6 = 2 end
				imgui.SameLine(nil, x)
				if imgui.Button(fa.ICON_CODE .. u8' Команды') then checkTabs = 'zuwi -> Настройки -> Команды' act6 = 3 end
				imgui.Separator()
			elseif not lang_menu.v then
				if imgui.Button(fa.ICON_WINDOW_MAXIMIZE ..' Menu') then checkTabs = 'zuwi -> Settings -> Menu' act6 = 1 end
				imgui.SameLine(nil, x)
				if imgui.Button(fa.ICON_CLOUD_DOWNLOAD ..' Updates') then checkTabs = 'zuwi -> Settings -> Updates' act6 = 2 end
				imgui.SameLine(nil, x)
				if imgui.Button(fa.ICON_CODE ..' Commands') then checkTabs = 'zuwi -> Settings -> Commands' act6 = 3 end
				imgui.Separator()
			end
			if act6 == 1 then
				if lang_menu.v then
					imgui.TextColoredRGB('{0984d2}F11 {888EA0}- {0E8604}Включить{888EA0}/{B31A06}Выключить {C39932}курсор')
					imgui.Spacing()
					imgui.Spacing()
					if imgui.CollapsingHeader(u8'Язык') then
						if imgui.ToggleButton('26', 'Меню', lang_menu) then CheckLangMenu = not CheckLangMenu end
						imgui.SameLine(nil, x)
						if imgui.ToggleButton('27', 'Чат', lang_chat) then CheckLangChat = not CheckLangChat end
						imgui.SameLine(nil, x)
						if imgui.ToggleButton('28', 'Диалоги', lang_dialogs) then CheckLangDialogs = not CheckLangDialogs end
						imgui.TextColoredRGB("{0984d2}Если включено, то работает на все вкладки кроме 'Серверы'. Осторожно. Настройка находится только для настройки и сохранения.")
						imgui.TextColoredRGB("{0984d2}Постоянно переключать язык будет неудобно")
						imgui.Separator()
					end
					imgui.Spacing() imgui.Spacing() imgui.Spacing()
					imgui.TextColoredRGB('{0984d2}Настройка стилей:')
				elseif not lang_menu.v then
					imgui.TextColoredRGB('{0984d2}F11 {888EA0}- {0E8604}On{888EA0}/{B31A06}Off {C39932}cursor')
					imgui.Spacing()
					imgui.Spacing()
					if imgui.CollapsingHeader('Language') then
						if imgui.ToggleButton('26', 'Menu', lang_menu) then CheckLangMenu = not CheckLangMenu end
						imgui.SameLine(nil, x)
						if imgui.ToggleButton('27', 'Chat', lang_chat) then CheckLangChat = not CheckLangChat end
						imgui.SameLine(nil, x)
						if imgui.ToggleButton('28', 'Dialogs', lang_dialogs) then CheckLangDialogs = not CheckLangDialogs end
						imgui.TextColoredRGB("{0984d2}If enabled, it works on all tabs except the 'Servers' tab. Caution. The setting is only for setting and saving.")
						imgui.TextColoredRGB("{0984d2}Constantly switching the language will be inconvenient")
						imgui.Separator()
					end
					imgui.Spacing() imgui.Spacing() imgui.Spacing()
					imgui.TextColoredRGB('{0984d2}Style settings:')
				end
				local styles = {"Androvira", "Light Blue", "Light Purple"}
				if imgui.Combo("##styleedit", comboStyle, styles, imgui.PushItemWidth(120)) then
					ps.menu.iStyle = comboStyle.v
					setInterfaceStyle(dirIni.menu.iStyle)
				end
				imgui.Spacing()
				imgui.Spacing()
				imgui.Spacing()
				imgui.CenterTextColoredRGB('{0984d2}Config{888EA0}:')
				imgui.Spacing()
				if imgui.Button('Save settings') then
					if not doesFileExist("zuwi.lua.ini") then
						local ps = {
							actor = {
								infRun = show_imgui_infRun.v,
								infSwim = show_imgui_infSwim.v,
								infOxygen = show_imgui_infOxygen.v,
								suicide = show_imgui_suicideActor.v,
								megaJump = show_imgui_megajumpActor.v,
								fastSprint = show_imgui_fastsprint.v,
								unfreeze = show_imgui_unfreeze.v,
								noFall = show_imgui_nofall.v,
								GM = show_imgui_gmActor.v
							},
							vehicle = {
								flip180 = show_imgui_flip180.v,
								flipOnWheels = show_imgui_flipOnWheels.v,
								megaJumpBMX = show_imgui_megajumpBMX.v,
								hop = show_imgui_hopVeh.v,
								boom = show_imgui_suicideVeh.v,
								fastExit = show_imgui_fastexit.v,
								gmWheels = show_imgui_gmWheels.v,
								AntiBikeFall = show_imgui_antiBikeFall.v,
								GM = show_imgui_gmVeh.v,
								fixWheels = show_imgui_fixWheels.v,
								speedhack = show_imgui_speedhack.v,
								speedhackMaxSpeed = SpeedHackMaxSpeed.v,
								perfectHandling = show_imgui_perfectHandling.v,
								-- allVehNitro = show_imgui_allCarsNitro.v,
								-- onlyWheels = show_imgui_onlyWheels.v,
								-- tankMode = show_imgui_tankMode.v,
								-- vehFloatAwayWhenHit = show_imgui_carsFloatWhenHit.v,
								driveOnWater = show_imgui_driveOnWater.v,
								restoreHealth = show_imgui_restHealthVeh.v,
								engineOn = show_imgui_engineOnVeh.v
							},
							weapon = {
								infAmmo = show_imgui_infAmmo.v
								-- fullAiming = show_imgui_fullaiming.v
							},
							misc = {
								FOV = show_imgui_FOV.v,
								FOVvalue = FOV_value.v,
								antibhop = show_imgui_antibhop.v,
								AirBrake = show_imgui_AirBrake.v,
								AirBrakeSpeed = AirBrake_Speed.v,
								quickMap = show_imgui_quickMap.v,
								nameTag = show_imgui_nametag.v,
								blink = show_imgui_blink.v,
								blinkDist = blink_dist.v,
								sensfix = show_imgui_sensfix.v,
								clearScreenshot = show_imgui_clrScr.v,
								WalkDriveUnderWater = show_imgui_UnderWater.v,
								ClickWarp = show_imgui_clickwarp.v,
								reconnect = show_imgui_reconnect.v
								--reconnectDelay = recon_delay.v
							},
							visual = {
								nameTag = show_imgui_nametag.v,
								infoBar = infbar.v
							},
							menu = {
								checkUpdate = checkupdate.v,
								language_menu = lang_menu.v,
								language_chat = lang_chat.v,
								language_dialogs = lang_dialogs.v,
								autoSave = AutoSave.v,
								iStyle = comboStyle.v
							},
							admintools = {
								adminChat = at_chat.v,
								newCMD = at_ncmd.v,
								shortCMD = at_scmd.v
							}
						}
						if inicfg.save(ps) then
							if lang_chat.v then sampAddChatMessage(tag..'Настройки {0E8604}успешно{888EA0} сохранены', main_color)
							elseif not lang_chat.v then sampAddChatMessage(tag..'Settings {0E8604}successfully{888EA0} save', main_color) end
						else
							if lang_chat.v then sampAddChatMessage(tag..'Настройки {B31A06}не успешно{888EA0} сохранены', main_color)
							elseif lang_chat.v then sampAddChatMessage(tag..'Settings {B31A06}not successfully {888EA0}save', main_color) end
						end
					else
						if inicfg.save(ps) then
							if lang_chat.v then sampAddChatMessage(tag..'Настройки {0E8604}успешно{888EA0} сохранены', main_color)
							elseif not lang_chat.v then sampAddChatMessage(tag..'Settings {0E8604}successfully{888EA0} save', main_color) end
						else
							if lang_chat.v then sampAddChatMessage(tag..'Настройки {B31A06}не успешно{888EA0} сохранены', main_color)
							elseif not lang_chat.v then sampAddChatMessage(tag..'Settings {B31A06}not successfully {888EA0}save', main_color) end
						end
					end
				end
				imgui.SameLine(nil, x)
				if not lang_menu.v then imgui.ToggleButton('29', 'Auto save', AutoSave)
				elseif lang_menu.v then imgui.ToggleButton('29', 'Автосохранение', AutoSave) end
			elseif act6 == 2 then
				if not lang_menu.v then
					imgui.ToggleButton('30', 'Check update', checkupdate)
					imgui.SameLine(nil, x)
					if imgui.Button('Download last update') then
						downloadUrlToFile('https://github.com/PanSeek/zuwi/blob/master/zuwi.lua', 'moonloader/zuwi.lua')
						if lang_chat.v then sampAddChatMessage(tag..'Обновление {0E8604}загружено', main_color)
						elseif not lang_chat.v then sampAddChatMessage(tag..'Update {0E8604}download', main_color) end
					end
					imgui.Spacing()
					if imgui.CollapsingHeader('List updates') then
						imgui.NewLine()
						imgui.SameLine(nil, 10)
						if imgui.CollapsingHeader(u8'dd.mm.2020 (когда из армейки приду))) - v1.0') then
							imgui.NewLine()
							imgui.SameLine(nil, 10)
							imgui.TextColoredRGB('{0E8604}Release')
						end
					end
				elseif lang_menu.v then
					imgui.ToggleButton('30', 'Проверка обновлений', checkupdate)
					imgui.SameLine(nil, x)
					if imgui.Button(u8'Скачать последнее обновление') then
						downloadUrlToFile('https://github.com/PanSeek/zuwi/blob/master/zuwi.lua', 'moonloader/zuwi.lua')
						if lang_chat.v then sampAddChatMessage(tag..'Обновление {0E8604}загружено', main_color)
						elseif not lang_chat.v then sampAddChatMessage(tag..'Update {0E8604}download', main_color) end
					end
					imgui.Spacing()
					if imgui.CollapsingHeader(u8'Список обновлений') then
						imgui.NewLine()
						imgui.SameLine(nil, 10)
						if imgui.CollapsingHeader(u8'dd.mm.2020 (когда из армейки приду))) - v1.0') then
							imgui.NewLine()
							imgui.SameLine(nil, 10)
							imgui.TextColoredRGB('{0E8604}Релиз')
						end
					end
				end
			elseif act6 == 3 then
				if lang_menu.v then
					imgui.Text(u8'В разработке')
				elseif not lang_menu.v then
					imgui.Text('In developing')
				end
			else act6 = 1 end
			imgui.EndChild()

		elseif act1 == 8 then --HELP IMGUI
			imgui.BeginChild('8', imgui.ImVec2(855, 370), true)
			if lang_menu.v then
				if imgui.CollapsingHeader(u8'Команды') then
					imgui.TextColoredRGB('{C39932}/z_help {888EA0}- Помощь по скрипту')
					imgui.TextColoredRGB('{C39932}/z_authors {888EA0}- Авторство и благодарности')
					imgui.TextColoredRGB('{C39932}/z_date {888EA0}- Сегодняшняя дата')
					imgui.TextColoredRGB('{C39932}/z_menu {888EA0}- {0984d2}Открытие/Закрытие {888EA0}меню')
					imgui.TextColoredRGB('{C39932}/z_coord {888EA0}- Отмечает Ваши координаты')
					imgui.TextColoredRGB('{C39932}/z_getmoney {888EA0}- Выдает 1.000$ ({B31A06}Визуально{888EA0})')
					imgui.TextColoredRGB('{C39932}/z_fakerepair {888EA0}- Чинит транспорт ({B31A06}Для Revent-Rp{888EA0})')
					imgui.TextColoredRGB('{C39932}/z_togall {888EA0}- {0984d2}Выключает/Включает {888EA0}все чаты которые возможно ({B31A06}Для Revent-Rp{888EA0})')
					imgui.TextColoredRGB('{C39932}/z_time {888EA0}- Поменять время')
					imgui.TextColoredRGB('{C39932}/z_weather {888EA0}- Поменять погоду')
					imgui.TextColoredRGB('{C39932}/z_setmark {888EA0}- Поставить метку')
					imgui.TextColoredRGB('{C39932}/z_tpmark {888EA0}- Телепортироваться к метке')
					imgui.TextColoredRGB('{C39932}/z_cc {888EA0}- Очистка чата')
					imgui.TextColoredRGB('{C39932}/z_version {888EA0}- Версия скрипта')
					imgui.TextColoredRGB('{C39932}/z_update {888EA0}- Обновить скрипт')
					imgui.TextColoredRGB('{C39932}/z_checktime {888EA0}- Точное время по МСК')
					imgui.TextColoredRGB('{C39932}/z_suicide {888EA0}- Суицид (Если в транспорте, то взрывает транспорт. Если пешком, то убивает Вас)')
					imgui.TextColoredRGB('{C39932}/z_errors {888EA0}- Список ошибок')
					imgui.TextColoredRGB('{C39932}/z_cmdsamp {888EA0}- Список команд SA-MP')
					imgui.TextColoredRGB('{C39932}/z_reload {888EA0}- Перезагружает данный скрипт')
					imgui.TextColoredRGB('{C39932}/z_fps {888EA0}- Выводит FPS')
				end
				if imgui.CollapsingHeader(u8'Ошибки') then
					imgui.TextColoredRGB('{B31A06}#1 {888EA0}- {C39932}Ваш игрок мертв/не существует')
					imgui.TextColoredRGB('{B31A06}#2 {888EA0}- {C39932}Ваш игрок не в транспорте')
					imgui.TextColoredRGB('{B31A06}#3 {888EA0}- {C39932}Открыт игровой чат')
					imgui.TextColoredRGB('{B31A06}#4 {888EA0}- {C39932}Открыт SampFuncs чат')
					imgui.TextColoredRGB('{B31A06}#5 {888EA0}- {C39932}Открыт диалог')
					imgui.TextColoredRGB('{B31A06}#6 {888EA0}- {C39932}Ваш игрок мертв/не существует или не в транспорте')
					imgui.TextColoredRGB('{B31A06}#7 {888EA0}- {C39932}У Вас открыт игровой чат/SampFuncs чат/диалог')
					imgui.TextColoredRGB('{B31A06}#8 {888EA0}- {C39932}Ваш игрок не в транспорте или у Вас открыт игровой чат/SampFuncs чат/диалог')
					imgui.TextColoredRGB('{B31A06}#9 {888EA0}- {C39932}Ваш игрок мертв/не существует или у Вас открыт игровой чат/SampFuncs чат/диалог')
					imgui.TextColoredRGB('{B31A06}#10 {888EA0}- {C39932}Транспорт не найден')
					imgui.TextColoredRGB('{B31A06}#11 {888EA0}- {C39932}Уже открыт другой диалог')
					imgui.TextColoredRGB('{B31A06}#12 {888EA0}- {C39932}Время не найдено')
					imgui.TextColoredRGB('{B31A06}#13 {888EA0}- {C39932}Погода не найдена')
					imgui.TextColoredRGB('{B31A06}#14 {888EA0}- {C39932}Метка не создана')
					imgui.TextColoredRGB('{B31A06}#15 {888EA0}- {C39932}Вы находитесь в интерьере')
				end
				if imgui.CollapsingHeader(u8'Авторство и благодарности') then
					imgui.TextColoredRGB('{B31A06}PanSeek {888EA0}- {C39932}Автор')
					imgui.Spacing()
					imgui.CenterTextColoredRGB('{0E8604}Благодарности{888EA0}:')
					imgui.TextColoredRGB('{B31A06}fran9 {888EA0}- {C39932}Помогал с цветами/расположением меню/AdminTools для Revent-RP')
					imgui.TextColoredRGB('{B31A06}FYP {888EA0}- {C39932}Исходный код')
					imgui.TextColoredRGB('{B31A06}FBenz {888EA0}- {C39932}Помогал в некоторых вопросах/советовал')
					imgui.TextColoredRGB('{B31A06}cover {888EA0}- {C39932}Исходный код')
					imgui.Spacing()
					imgui.TextColoredRGB('{0E8604}А также спасибо всем, кто тестировал скрипт и сообщал о некоторых проблемах/багах')
				end
			elseif not lang_menu.v then
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
					imgui.TextColoredRGB('{B31A06}PanSeek {888EA0}- {C39932}Author')
					imgui.Spacing()
					imgui.CenterTextColoredRGB('{0E8604}Thanks{888EA0}:')
					imgui.TextColoredRGB('{B31A06}fran9 {888EA0}- {C39932}Helped with colors/location menu/AdminTools for Revent-RP')
					imgui.TextColoredRGB('{B31A06}FYP {888EA0}- {C39932}Source')
					imgui.TextColoredRGB('{B31A06}FBenz {888EA0}- {C39932}Helped in some questions/advised')
					imgui.TextColoredRGB('{B31A06}cover {888EA0}- {C39932}Source')
					imgui.Spacing()
					imgui.TextColoredRGB('{0E8604}And also thanks to everyone who tested the script and reported some problems/bugs')
				end
			end
			imgui.EndChild()

		elseif act1 == 9 then --REVENT-RP IMGUI
			imgui.BeginChild('9', imgui.ImVec2(855, 370), true)
			if imgui.Button(fa.ICON_GLOBE .. u8' Главное') then checkTabs = 'zuwi -> Revent-RP -> Главное' act9 = 1 end
			imgui.SameLine(nil, x)
			if imgui.Button(fa.ICON_STREET_VIEW .. u8' Боты') then checkTabs = 'zuwi -> Revent-RP -> Боты' act9 = 2 end
			imgui.SameLine(nil, x)
			if imgui.Button(fa.ICON_LOCATION_ARROW .. u8' Телепорты') then checkTabs = 'zuwi -> Revent-RP -> Телепорты' act9 = 3 end
			if Admin then
				imgui.SameLine(nil, x)
				if imgui.Button(fa.ICON_ADDRESS_CARD ..' Admin Tools') then checkTabs = 'zuwi -> Revent-RP -> Admin Tools' act9 = 4 end
			end
			imgui.Separator()
			if act9 == 1 then
				imgui.Text(u8'В разработке')
			elseif act9 == 2 then
				imgui.Text(u8'В разработке')
			elseif act9 == 3 then
				if imgui.CollapsingHeader(u8'Фракции и организации') then
					imgui.Indent(15)
					if imgui.CollapsingHeader(u8'Интерьеры') then
						imgui.Columns(3)
						if imgui.Button('LSPD') then teleportInterior(PLAYER_PED,2633.8281,1054.9259,1025.7860,10) end
						if imgui.Button('SFPD') then teleportInterior(PLAYER_PED,2631.7517,1052.0356,1025.7860,10) end
						if imgui.Button('LVPD') then teleportInterior(PLAYER_PED,2632.2693,1053.0416,1025.7860,10) end
						if imgui.Button(u8'Больница LS') then teleportInterior(PLAYER_PED,1389.7893,-18.2846,1000.9153,1) end
						if imgui.Button(u8'Больница SF') then teleportInterior(PLAYER_PED,1993.3247,1828.4985,1036.4240,1) end
						if imgui.Button(u8'Больница LV') then teleportInterior(PLAYER_PED,-2149.7686,678.9402,1000.8959,1) end
						if imgui.Button(u8'ФБР') then teleportInterior(PLAYER_PED,-807.6865,-286.6179,994.1849,15) end
						if imgui.Button(u8'Правительство') then teleportInterior(PLAYER_PED,2545.4111,1179.0635,1041.9678,3) end
						imgui.NextColumn()
						if imgui.Button('Radio LS') then teleportInterior(PLAYER_PED,1906.0597,-4.9029,1000.9819,1) end
						if imgui.Button('Radio LV') then teleportInterior(PLAYER_PED,911.8922,1464.3600,999.5259,1) end
						if imgui.Button(u8'Автошкола') then teleportInterior(PLAYER_PED,1907.9076,1772.4630,1044.3833,1) end
						if imgui.Button(u8'Отдел лицензирования') then teleportInterior(PLAYER_PED,-54.1390,1379.4974,943.4575,100) end
						if imgui.Button(u8'Нац. гвардия') then teleportInterior(PLAYER_PED,-1833.1125,1920.4862,918.4860,1) end
						if imgui.Button(u8'Русская мафия') then teleportInterior(PLAYER_PED,2.5189,2279.8877,947.1949,2) end
						if imgui.Button(u8'Якудза') then teleportInterior(PLAYER_PED,1356.0793,2.4012,932.7360,5) end
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
					if imgui.CollapsingHeader(u8'Возле интерьера') then
						imgui.Columns(3)
						if imgui.Button('LSPD') then teleportInterior(PLAYER_PED, 1543.4442, -1675.2795, 13.5565, 0) end
						if imgui.Button('SFPD') then teleportInterior(PLAYER_PED,-1606.9584,720.8036,12.2308,0) end
						if imgui.Button('LVPD') then teleportInterior(PLAYER_PED,2287.3582,2421.3423,10.8203,0) end
						if imgui.Button(u8'Больница LS') then teleportInterior(PLAYER_PED, 1178.7211, -1326.7101, 14.1560, 0) end
						if imgui.Button(u8'Больница SF') then teleportInterior(PLAYER_PED,-2662.2585,625.6224,14.4531,0) end
						if imgui.Button(u8'Больница LV') then teleportInterior(PLAYER_PED,1632.9490,1821.7103,10.8203,0) end
						if imgui.Button(u8'ФБР') then teleportInterior(PLAYER_PED,1046.4518,1026.6058,10.9978,0) end
						if imgui.Button(u8'Правительство') then teleportInterior(PLAYER_PED, 1407.8854,-1788.0032,13.5469,0) end
						imgui.NextColumn()
						if imgui.Button('Radio LS') then teleportInterior(PLAYER_PED, 760.8872,-1358.9816,13.5198,0) end
						if imgui.Button('Radio LV') then teleportInterior(PLAYER_PED,947.7136,1743.1909,8.8516,0) end
						if imgui.Button(u8'Автошкола') then teleportInterior(PLAYER_PED, -2037.7787,-99.7488,35.1641,0) end
						if imgui.Button(u8'Отдел лицензирования') then teleportInterior(PLAYER_PED,1910.5309,2343.3171,10.8203,0) end
						if imgui.Button(u8'Нац. гвардия') then teleportInterior(PLAYER_PED, 312.4188,1959.1595,17.6406, 0) end
						if imgui.Button(u8'Русская мафия') then teleportInterior(PLAYER_PED, -2723.7395,-313.8499,7.1860,0) end
						if imgui.Button(u8'Якудза') then teleportInterior(PLAYER_PED, 1492.9370,724.5159,10.8203,0) end
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
				if imgui.CollapsingHeader(u8'Работы') then
					imgui.Columns(2)
					if imgui.Button(u8'Нефтянная вышка') then teleportInterior(PLAYER_PED,815.8508,604.5477,11.8305,0) end
					if imgui.Button(u8'Грузчик') then teleportInterior(PLAYER_PED,2788.3308,-2437.6555,13.6335,0) end
					if imgui.Button(u8'Автоцех') then teleportInterior(PLAYER_PED,-49.9263,-277.9673,5.4297,0) end
					if imgui.Button(u8'Автоцех (Интерьер)') then teleportInterior(PLAYER_PED,-570.5103,-82.4685,3001.0859,1) end
					imgui.NextColumn()
					if imgui.Button(u8'Дальнобойщик') then teleportInterior(PLAYER_PED,-504.6666,-545.2240,25.5234,0) end
					if imgui.Button(u8'Лесоруб') then teleportInterior(PLAYER_PED,-555.8159,-189.0762,78.4063,0) end
					if imgui.Button(u8'Мойщик улиц') then teleportInterior(PLAYER_PED,-2586.7097,608.1636,14.4531,0) end
					if imgui.Button(u8'Инкасатор') then teleportInterior(PLAYER_PED,2168.6331,998.6193,10.8203,0) end
				end
				imgui.Columns(1)
				imgui.Spacing()
				if imgui.CollapsingHeader(u8'Остальные телепорты') then
					imgui.Indent(15)
					if imgui.CollapsingHeader(u8'Интерьеры ') then
						imgui.Columns(3)
						if imgui.Button(u8'Старый деморган') then teleportInterior(PLAYER_PED,1281.1638,-1.8006,1001.0133,18) end
						if imgui.Button(u8'Банк') then teleportInterior(PLAYER_PED,1463.0361,-1009.3804,34.4652,0) end
						if imgui.Button(u8'Биржа труда') then teleportInterior(PLAYER_PED,1561.1443,-1518.2223,3001.5188,15) end
						if imgui.Button(u8'Черный рынок') then teleportInterior(PLAYER_PED,1696.5221,-1586.8097,2875.2939,1) end
						if imgui.Button(u8'Черный рынок (пропуск)') then teleportInterior(PLAYER_PED,1569.4727,1230.9999,1055.1804,1) end
						imgui.NextColumn()
						if imgui.Button(u8'Автосалон') then teleportInterior(PLAYER_PED,2489.1558,-1017.1227,1033.1460,1) end
						if imgui.Button(u8'Департамент администрации') then teleportInterior(PLAYER_PED,-265.7054,725.4685,1000.0859,5) end
						if imgui.Button(u8'Военкомат') then teleportInterior(PLAYER_PED,223.4714,1540.9908,3001.0859,1) end
						if imgui.Button(u8'Казино') then teleportInterior(PLAYER_PED,1888.7018,1049.5775,996.8770,1) end
						if imgui.Button(u8'Казино-мини') then teleportInterior(PLAYER_PED,1411.5062,-586.6498,1607.3579,1) end
						imgui.NextColumn()
						if imgui.Button(u8'Тренировочный комлпекс') then teleportInterior(PLAYER_PED,2365.9114,-1943.3044,919.4700,1) end
						if imgui.Button(u8'Состязательная арена') then teleportInterior(PLAYER_PED,825.7631,-1578.9291,3001.0823,3) end
						if imgui.Button(u8'Тир') then teleportInterior(PLAYER_PED,285.8546,-78.9205,1001.5156,4) end
						if imgui.Button(u8'Торговый центр') then teleportInterior(PLAYER_PED,1359.7142,-27.9618,1000.9163,1) end
						if imgui.Button(u8'Страховая') then teleportInterior(PLAYER_PED,1707.3676,636.4663,3001.0859,1) end
					end
					imgui.Columns(1)
					if imgui.CollapsingHeader(u8'Остальное') then
						imgui.Columns(3)
						if imgui.Button(u8'Маяк') then teleportInterior(PLAYER_PED,154.9556,-1939.6304,3.7734,0) end
						if imgui.Button(u8'Колесо обозрения') then teleportInterior(PLAYER_PED,381.6406,-2044.5220,7.8359,0) end
						if imgui.Button(u8'Банк') then teleportInterior(PLAYER_PED,1457.3635,-1027.2981,23.8281,0) end
						if imgui.Button(u8'Чиллиад') then teleportInterior(PLAYER_PED,-2242.5701,-1731.3767,480.3250,0) end
						if imgui.Button(u8'Биржа труда') then teleportInterior(PLAYER_PED,554.2763,-1500.1908,14.5191,0) end
						if imgui.Button(u8'Черный рынок') then teleportInterior(PLAYER_PED,341.1162,-97.6198,1.4143,0) end
						if imgui.Button(u8'Автосалон') then teleportInterior(PLAYER_PED,-2447.2839,750.6021,35.1719,0) end
						if imgui.Button(u8'БУ рынок') then teleportInterior(PLAYER_PED,1492.5591,2809.7349,10.8203,0) end
						if imgui.Button(u8'ЖДЛС') then teleportInterior(PLAYER_PED,1707.0590,-1895.5723,13.5685,0) end
						if imgui.Button(u8'ЖДСФ') then teleportInterior(PLAYER_PED,-1975.0864,141.7100,27.6873,0) end
						if imgui.Button(u8'ЖДЛВ') then teleportInterior(PLAYER_PED,2839.9119,1286.1318,11.3906,0) end
						if imgui.Button(u8'Кладбище LS') then teleportInterior(PLAYER_PED,936.1039,-1101.4722,24.3431,0) end
						imgui.NextColumn()
						if imgui.Button(u8'Торговый центр') then teleportInterior(PLAYER_PED,1306.2538,-1331.6825,13.6422,0) end
						if imgui.Button(u8'Страховая') then teleportInterior(PLAYER_PED,2129.5217,-1139.7073,25.2925,0) end
						if imgui.Button(u8'Аренда авто LS') then teleportInterior(PLAYER_PED,568.2047,-1290.3613,17.2422,0) end
						if imgui.Button(u8'Аренда авто SF') then teleportInterior(PLAYER_PED,-1972.5128,257.3625,35.1719,0) end
						if imgui.Button(u8'Аренда авто LV') then teleportInterior(PLAYER_PED,2257.1780,2033.8057,10.8203,0) end
						if imgui.Button(u8'Аренда авто LV (Возле казино)') then teleportInterior(PLAYER_PED,1897.5586,949.3096,10.8203,0) end
						if imgui.Button(u8'Карьер') then teleportInterior(PLAYER_PED,626.8690,853.0729,-42.9609,0) end
						if imgui.Button(u8'Автосервис') then teleportInterior(PLAYER_PED,617.2724,-1520.0159,15.2100,0) end
						if imgui.Button(u8'Департамент администрации') then teleportInterior(PLAYER_PED,635.7059,-565.4893,16.3359,0) end
						if imgui.Button(u8'Военкомат') then teleportInterior(PLAYER_PED,-2449.4761,498.7346,30.0873,0) end
						if imgui.Button(u8'Казино') then teleportInterior(PLAYER_PED,2031.1218,1006.4854,10.8203,0) end
						if imgui.Button(u8'Казино-мини') then teleportInterior(PLAYER_PED,1015.9720,-1127.6450,23.8574,0) end
						imgui.NextColumn()
						if imgui.Button(u8'Разборка LV') then teleportInterior(PLAYER_PED,-1506.7286,2623.1606,55.8359,0) end
						if imgui.Button(u8'Разборка LS-SF') then teleportInterior(PLAYER_PED,-2110.1580,-2431.3657,30.6250,0) end
						if imgui.Button(u8'Заброшенный завод') then teleportInterior(PLAYER_PED,1044.2622,2078.8237,10.8203,0) end
						if imgui.Button(u8'Тренировочный комлпекс') then teleportInterior(PLAYER_PED,2478.8884,-2108.2769,13.5469,0) end
						if imgui.Button(u8'Состязательная арена') then teleportInterior(PLAYER_PED,1088.4347,-900.3381,42.7011,0) end
						if imgui.Button(u8'Остров "Невезения"') then teleportInterior(PLAYER_PED,616.4134,-3549.7146,86.9716,0) end
						if imgui.Button(u8'Экспорт ТС') then teleportInterior(PLAYER_PED,-1549.0760,121.4793,3.5547,0) end
						if imgui.Button(u8'Тир') then teleportInterior(PLAYER_PED,-2689.1277,0.0403,6.1328,0) end
						if imgui.Button(u8'Трущобы') then teleportInterior(PLAYER_PED,-2541.6707,25.9529,16.4438,0) end
						if imgui.Button(u8'Аэропорт LS') then teleportInterior(PLAYER_PED,1449.0017,-2461.8296,13.5547,0) end
						if imgui.Button(u8'Аэропорт SF') then teleportInterior(PLAYER_PED,-1654.5244,-173.4216,14.1484,0) end
						if imgui.Button(u8'Аэропорт LV') then teleportInterior(PLAYER_PED,1337.8947,1303.8196,10.8203,0) end
					end
					imgui.Unindent(15)
					imgui.Columns(1)
				end

			elseif act9 == 4 then
				imgui.ToggleButton('41', 'Сокращенные команды', at_scmd)
				imgui.SameLine(nil, x)
				imgui.ToggleButton('42', 'Новые команды', at_ncmd)
				imgui.Spacing()
				if imgui.CollapsingHeader(u8'Чаты') then
					imgui.Indent(10)
					imgui.ToggleButton('44', 'Административный чат', at_chat)
					imgui.Unindent(10)
				end
				imgui.Spacing()
				if imgui.CollapsingHeader(u8'Помощь') then
					imgui.NewLine()
					imgui.SameLine(nil, 10)
					if imgui.CollapsingHeader('AHELP') then
						imgui.Indent(20)
						if imgui.CollapsingHeader('ALVL 1', btn_size) then
							imgui.TextColoredRGB('{B31A06}/a {888EA0}- {0E8604}админ чат')
							imgui.TextColoredRGB('{B31A06}/admins {888EA0}- {0E8604}просмотр админов онлайн')
							imgui.TextColoredRGB('{B31A06}/an {888EA0}- {0E8604}ответить на репорт')
							imgui.TextColoredRGB('{B31A06}/spec {888EA0}- {0E8604}следить за игроком')
							imgui.TextColoredRGB('{B31A06}/specoff {888EA0}- {0E8604}перестать следить')
							imgui.TextColoredRGB('{B31A06}/jail {888EA0}- {0E8604}посадить в тюрьму')
							imgui.TextColoredRGB('{B31A06}/kick {888EA0}- {0E8604}кикнуть игрока')
							imgui.TextColoredRGB('{B31A06}/check{888EA0} -{0E8604} просмотр статистики персонажа')
							imgui.TextColoredRGB('{B31A06}/anames{888EA0} -{0E8604} история ник-неймов')
							imgui.TextColoredRGB('{B31A06}/tp {888EA0}-{0E8604} телепорт')
							imgui.TextColoredRGB('{B31A06}/ftp {888EA0}- {0E8604}телепорт к организациям')
							imgui.TextColoredRGB('{B31A06}/goto{888EA0} - {0E8604}телепорт к игроку')
							imgui.TextColoredRGB('{B31A06}/fixveh{888EA0} -{0E8604} починить транспорт')
				 		  imgui.TextColoredRGB('{B31A06}/spawncar{888EA0} -{0E8604} заспавнить ID транспорта (/dl)')
							imgui.TextColoredRGB('{B31A06}/checkad{888EA0} -{0E8604} проверка объявлений')
							imgui.TextColoredRGB('{B31A06}/cheaters{888EA0} - {0E8604}игроки у которых установлен собейт')
							imgui.TextColoredRGB('{B31A06}/getcar{888EA0} - {0E8604}призвать ID транспорта (/dl)')
							imgui.TextColoredRGB('{B31A06}/aen {888EA0}- {0E8604}проверить вкл/выкл двигатель транспорта')
							imgui.TextColoredRGB('{B31A06}/hit {888EA0}- {0E8604}проверить урон попаданий игрока, выстрелы')
							imgui.TextColoredRGB('{B31A06}/zz{888EA0} - {0E8604}как /o, только со скобками и другим цветом')
							imgui.TextColoredRGB('{B31A06}/deleteobjects{888EA0} - {0E8604}удалить все объекты ПД')
						end
						if imgui.CollapsingHeader('ALVL 2', btn_size) then
							imgui.TextColoredRGB('{B31A06}/ban{888EA0} - {0E8604}забанить игрока')
							imgui.TextColoredRGB('{B31A06}/prison {888EA0}- {0E8604}посадить в присон на 3500 секунд')
							imgui.TextColoredRGB('{B31A06}/warn {888EA0}- {0E8604}дать предупреждение')
							imgui.TextColoredRGB('{B31A06}/mute{888EA0} - {0E8604}дать молчанку')
							imgui.TextColoredRGB('{B31A06}/spawn {888EA0}- {0E8604}отправить игрока на спавн')
							imgui.TextColoredRGB('{B31A06}/abizz {888EA0}- {0E8604}просмотр информации про все бизнессы штата')
							imgui.TextColoredRGB('{B31A06}/ajobs {888EA0}-{0E8604} просмотр трудовой книги игрока')
							imgui.TextColoredRGB('{B31A06}/biz {888EA0}- {0E8604}тп в биз')
							imgui.TextColoredRGB('{B31A06}/house {888EA0}- {0E8604}тп в дом')
							imgui.TextColoredRGB('{B31A06}/garage {888EA0}- {0E8604}тп в гараж')
							imgui.TextColoredRGB('{B31A06}/destroycar {888EA0}- {0E8604}уничтожить созданный транспорт')
							imgui.TextColoredRGB('{B31A06}/fillveh {888EA0}- {0E8604}заправить транспорт')
							imgui.TextColoredRGB('{B31A06}/gethere{888EA0} -{0E8604} тп к себе игрока')
							imgui.TextColoredRGB('{B31A06}/sban {888EA0}- {0E8604}тихо забанить игрока')
							imgui.TextColoredRGB('{B31A06}/skick {888EA0}- {0E8604}тихо кикнуть игрока')
							imgui.TextColoredRGB('{B31A06}/amembers {888EA0}- {0E8604}проверить онлайн во фракции')
							imgui.TextColoredRGB('{B31A06}/o{888EA0} - {0E8604}чат видный всем игрокам')
							imgui.TextColoredRGB('{B31A06}/setsex {888EA0}- {0E8604}смена пола игроку')
							imgui.TextColoredRGB('{B31A06}/setnat {888EA0}- {0E8604}смена расы игроку')
							imgui.TextColoredRGB('{B31A06}/auron{888EA0} -{0E8604} показывает кому игрок последний раз нанёс урон и от кого получил')
						end
						if imgui.CollapsingHeader('ALVL 3', btn_size) then
							imgui.TextColoredRGB('{B31A06}/mpgo {888EA0}- {0E8604}начать мероприятие')
							imgui.TextColoredRGB('{B31A06}/ainvite {888EA0}- {0E8604}инвайтнуть себя во фракцию')
							imgui.TextColoredRGB('{B31A06}/mark {888EA0}- {0E8604}поставить метку')
							imgui.TextColoredRGB('{B31A06}/gotomark{888EA0} - {0E8604}тп на метку')
							imgui.TextColoredRGB('{B31A06}/unprison{888EA0} -{0E8604} выпустить из присона')
							imgui.TextColoredRGB('{B31A06}/unjail{888EA0} - {0E8604}выпустить из тюрьмы')
							imgui.TextColoredRGB('{B31A06}/sethp {888EA0}- {0E8604}изменить здоровье игроку')
							imgui.TextColoredRGB('{B31A06}/veh {888EA0}- {0E8604}создать транспорт (не забыть удалить)')
							imgui.TextColoredRGB('{B31A06}/dellveh {888EA0}- {0E8604}удалить весь созданный транспорт за сервере')
							imgui.TextColoredRGB('{B31A06}/slap {888EA0}- {0E8604}слапнуть игрока')
							imgui.TextColoredRGB('{B31A06}/freeze {888EA0}- {0E8604}заморозить игрока')
							imgui.TextColoredRGB('{B31A06}/unfreeze {888EA0}-{0E8604} разморозить игрока')
							imgui.TextColoredRGB('{B31A06}/spawncars{888EA0} -{0E8604} заспавнить весь транспорт')
							imgui.TextColoredRGB('{B31A06}/fuelcars{888EA0} - {0E8604}заправить весь транспорт')
							imgui.TextColoredRGB('{B31A06}/disarm {888EA0}- {0E8604}обезоружить игрока')
							imgui.TextColoredRGB('{B31A06}/cc {888EA0}- {0E8604}очистить чат')
							imgui.TextColoredRGB('{B31A06}/cc2 {888EA0}- {0E8604}очистить чат игроку')
							imgui.TextColoredRGB('{B31A06}/kickjob {888EA0}- {0E8604}уволить с работы')
							imgui.TextColoredRGB('{B31A06}/mpskin {888EA0}- {0E8604}выдать временный скин')
							imgui.TextColoredRGB('{B31A06}/rspawncars {888EA0}-{0E8604} заспавнить транспорт в радиусе')
							imgui.TextColoredRGB('{B31A06}/dmzone{888EA0} - {0E8604}запустить страйкбол')
							imgui.TextColoredRGB('{B31A06}/aobject{888EA0} - {0E8604}создать объект (нужен 8 ранг в ПД)')
						end
						if imgui.CollapsingHeader('ALVL 4', btn_size) then
							imgui.TextColoredRGB('{B31A06}/getip{888EA0} - {0E8604}IP игрока')
							imgui.TextColoredRGB('{B31A06}/alock {888EA0}- {0E8604}открыть транспорт')
							imgui.TextColoredRGB('{B31A06}/alock2 {888EA0}- {0E8604}закрыть транспорт')
							imgui.TextColoredRGB('{B31A06}/setname {888EA0}- {0E8604}сменить ник-нейм игроку')
							imgui.TextColoredRGB('{B31A06}/setnames{888EA0} - {0E8604}заявки на смену ник-нейма')
							imgui.TextColoredRGB('{B31A06}/agl{888EA0} - {0E8604}выдать лицензию')
							imgui.TextColoredRGB('{B31A06}/int{888EA0} - {0E8604}сменить интерьер в доме')
							imgui.TextColoredRGB('{B31A06}/tpto{888EA0} - {0E8604} игрока к другому игроку')
							imgui.TextColoredRGB('{B31A06}/kickinvite {888EA0}-{0E8604} уволить с фракции')
							imgui.TextColoredRGB('{B31A06}/take {888EA0}- {0E8604}отбор лицензий')
							imgui.TextColoredRGB('{B31A06}/unban{888EA0} - {0E8604}разбанить аккаунт')
							imgui.TextColoredRGB('{B31A06}/razborka1 {888EA0}- {0E8604}перекрасить разборку байкеров')
							imgui.TextColoredRGB('{B31A06}/unwarn {888EA0}- {0E8604}снять варн')
						end
						if imgui.CollapsingHeader('ALVL 5', btn_size) then
							imgui.TextColoredRGB('{B31A06}/apark {888EA0}- {0E8604}припарковать транспорт')
							imgui.TextColoredRGB('{B31A06}/mole {888EA0}- {0E8604}написать всем игрокам СМС от лица сервера')
							imgui.TextColoredRGB('{B31A06}/glrp {888EA0}- {0E8604}прослушка чатов')
							imgui.TextColoredRGB('{B31A06}/agiverank {888EA0}- {0E8604}сменить ранг игроку')
							imgui.TextColoredRGB('{B31A06}/givegun {888EA0}- {0E8604}дать игроку оружие')
							imgui.TextColoredRGB('{B31A06}/setarmor {888EA0}- {0E8604}сменить состояние брони игроку')
							imgui.TextColoredRGB('{B31A06}/explode{888EA0} -{0E8604} взорвать игрока')
							imgui.TextColoredRGB('{B31A06}/unslot{888EA0} - {0E8604}очистить слоты транспортов игрока')
							imgui.TextColoredRGB('{B31A06}/weather {888EA0}-{0E8604} сменить погоду')
							imgui.TextColoredRGB('{B31A06}/sethprad {888EA0}- {0E8604}выдать хп всем в опр. радиусе')
							imgui.TextColoredRGB('{B31A06}/mpskinrad {888EA0}- {0E8604}выдать всем скин в опр. радиусе')
							imgui.TextColoredRGB('{B31A06}/givegunrad {888EA0}- {0E8604}выдать всем оружие в опр. радиусе')
							imgui.TextColoredRGB('{B31A06}/setarmorrad {888EA0}-{0E8604} выдать всех броню в опр. радиусе')
							imgui.TextColoredRGB('{B31A06}/1gungame {888EA0}- {0E8604}запустить ""Гонку Вооружений"')
							imgui.TextColoredRGB('{B31A06}/stopattack{888EA0} -{0E8604} прекратить капт')
							imgui.TextColoredRGB('{B31A06}/giveport{888EA0} -{0E8604} выдать порт мафии')
							imgui.TextColoredRGB('{B31A06}/admtack {888EA0}- {0E8604}cнять кд на капт у банды')
							imgui.TextColoredRGB('{B31A06}/givegz {888EA0}- {0E8604}дать гангзону другой банде')
							imgui.TextColoredRGB('{B31A06}/zaprosip {888EA0}- {0E8604}посмотреть аккаунты на опр. IP')
						end
						if imgui.CollapsingHeader('ALVL 6', btn_size) then
							imgui.TextColoredRGB('{B31A06}/sethpall {888EA0}- {0E8604}изменить хп всем игрокам')
							imgui.TextColoredRGB('{B31A06}/unbanip {888EA0}-{0E8604} разбанить IP')
							imgui.TextColoredRGB('{B31A06}/alllic {888EA0}- {0E8604}дать все лицензии игроку')
							imgui.TextColoredRGB('{B31A06}/aengine {888EA0}-{0E8604} отключить систему двигателей на сервере(больше нагрузки, ддос)')
							imgui.TextColoredRGB('{B31A06}/acapture{888EA0} -{0E8604} отключить захваты(мероприятия и прочее)')
							imgui.TextColoredRGB('{B31A06}/rasform {888EA0}- {0E8604}полная расформировка гетто (общаки, репутация, количество убийств)')
							imgui.TextColoredRGB('{B31A06}/rasformbiker{888EA0} - {0E8604}расформировка общаков байкеров')
							imgui.TextColoredRGB('{B31A06}/givevip {888EA0}-{0E8604} выдать VIP')
							imgui.TextColoredRGB('{B31A06}/makehelper {888EA0}-{0E8604} выдать хелперку')
						end
						if imgui.CollapsingHeader('ALVL 7', btn_size) then
							imgui.TextColoredRGB('{B31A06}/banip{888EA0} - {0E8604}забанить IP')
							imgui.TextColoredRGB('{B31A06}/asellcar {888EA0}- {0E8604}продать транспорт (авторыночный)')
							imgui.TextColoredRGB('{B31A06}/asellbiz {888EA0}- {0E8604}продать биз')
							imgui.TextColoredRGB('{B31A06}/asellsbiz {888EA0}- {0E8604}продать сбиз')
							imgui.TextColoredRGB('{B31A06}/asellhouse {888EA0}- {0E8604}продать дом')
							imgui.TextColoredRGB('{B31A06}/kickmarriage {888EA0}- {0E8604}развести игрока')
							imgui.TextColoredRGB('{B31A06}/noooc{888EA0} - {0E8604}включить OOC чат')
							imgui.TextColoredRGB('{B31A06}/makedrugs {888EA0}- {0E8604}дать наркотики игроку')
							imgui.TextColoredRGB('{B31A06}/setskin {888EA0}- {0E8604}выдать скин')
							imgui.TextColoredRGB('{B31A06}/setskinslot {888EA0}- {0E8604}выдать скин на опр. слот')
						end
						imgui.Unindent(20)
					end
					imgui.Indent(10)
					if imgui.CollapsingHeader(u8'ID фракций') then
						imgui.CenterTextColoredRGB('{0E8604}Государственные фракции{888EA0}:')
						imgui.Spacing()
						imgui.TextColoredRGB('{888EA0}Полиция ЛС - {C39932}1')
						imgui.TextColoredRGB('{888EA0}Полиция СФ - {C39932}20')
						imgui.TextColoredRGB('{888EA0}Полиция ЛВ - {C39932}21')
						imgui.Spacing()
						imgui.TextColoredRGB('{888EA0}Госпиталь ЛС - {C39932}2')
						imgui.TextColoredRGB('{888EA0}Госпиталь СФ - {C39932}23')
						imgui.TextColoredRGB('{888EA0}Госпиталь ЛВ - {C39932}24')
						imgui.Spacing()
						imgui.TextColoredRGB('{888EA0}ФБР - {C39932}22')
						imgui.Spacing()
						imgui.TextColoredRGB('{888EA0}Правительство - {C39932}3')
						imgui.Spacing()
						imgui.TextColoredRGB('{888EA0}Нац.гвардия - {C39932}6')
						imgui.Spacing()
						imgui.TextColoredRGB('{888EA0}Лицензеры - {C39932}5')
						imgui.Spacing()
						imgui.TextColoredRGB('{888EA0}СМИ ЛС - {C39932}4')
						imgui.TextColoredRGB('{888EA0}СМИ ЛВ - {C39932}25')
						imgui.Spacing()
						imgui.CenterTextColoredRGB('{B31A06}Банды/мафии/байкеры{888EA0}:')
						imgui.Spacing()
						imgui.TextColoredRGB('{888EA0}Русская мафия - {C39932}7')
						imgui.TextColoredRGB('{888EA0}Якудза - {C39932}8')
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
					if imgui.CollapsingHeader(u8'Команды') then
						imgui.CenterTextColoredRGB('Сокращенные команды:')
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
						imgui.CenterTextColoredRGB('Новые команды')
						imgui.TextColoredRGB('{C39932}/hp {888EA0}- Устанавливает Вам 150 единиц здоровья')
						imgui.TextColoredRGB('{C39932}/ffveh {888EA0}- Чинит и заправяет ТС')
						imgui.TextColoredRGB('{C39932}/gg [id] {888EA0}- Желаете игроку приятной игры')
						imgui.TextColoredRGB('{C39932}/piarask {888EA0}- Пишет в общий чат про хелперов')
						imgui.TextColoredRGB('{C39932}/fraklvl [id] {888EA0}- Пишет игроку какие фракции с какого уровня')
						imgui.TextColoredRGB('{C39932}/dm [id] {888EA0}- Выдает jail игроку на 20 минут с причиной, "DM"')
						imgui.TextColoredRGB('{C39932}/bike [num] {888EA0}- Создает велосипед (1 - Mountain; 2 - BMX; 3 - Bike)')
					end
					imgui.Unindent(10)
				end
			end --else act9 = 1 end (ВСЕ РАБОТАЕТ, ПРОСТО ПОКА act9 = 1 В РАЗРАБОТКЕ. КОГДА БУДЕТ ГОТОВО, ЕБАНУТЬ НА 	ЭТО)
			imgui.EndChild()

		elseif act1 == 10 then --ONLINERP IMGUI
			imgui.BeginChild('10', imgui.ImVec2(855, 370), true)
			imgui.Text(u8('В разработке'))
			imgui.EndChild()

		else
			actEnterInGame = 1
			imgui.BeginChild('0', imgui.ImVec2(855, 370), true)
			imgui.Text(u8'Select language/Выберите язык:')
			imgui.SameLine(nil,x)
			if imgui.Button('English') then langIG[1] = true langIG[2] = false end
			imgui.SameLine(nil,x)
			if imgui.Button(u8'Русский') then langIG[1] = false langIG[2] = true end
			if langIG[1] then
				imgui.Text(u8(imgIntGameENG[1]))
				if imgui.CollapsingHeader('More about tabs') then
					imgui.Text(u8(imgIntGameENG[2]))
					imgui.Separator()
				end
				imgui.Text(u8(imgIntGameENG[3]))
			elseif langIG[2] then
				imgui.Text(u8(imgIntGameRUS[1]))
				if imgui.CollapsingHeader(u8'Подробнее про вкладки') then
					imgui.Text(u8(imgIntGameRUS[2]))
					imgui.Separator()
				end
				imgui.Text(u8(imgIntGameRUS[3]))
			end 
			imgui.EndChild()
		end
	end

	-- if admbar.v then
	-- 	imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
	-- 	imgui.SetNextWindowSize(imgui.ImVec2(200, 300), imgui.Cond.FirstUseEver)
	-- 	imgui.Begin('', admbar, imgui.WindowFlags.NoTitleBar)
	-- 	if not lang_menu.v then
	-- 		imgui.Text('test')
	-- 	elseif lang_menu.v then
	-- 		imgui.Text('test')
	-- 	end
	-- end

	-- if frdbar.v then
	-- 	imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
	-- 	imgui.SetNextWindowSize(imgui.ImVec2(200, 300), imgui.Cond.FirstUseEver)
	-- 	imgui.Begin('', frdbar, imgui.WindowFlags.NoTitleBar)
	-- 	if not lang_menu.v then
	-- 		imgui.Text('test')
	-- 	elseif lang_menu.v then
	-- 		imgui.Text('test')
	-- 	end
	-- end

	imgui.End()
end		

function main()
	if not isSampLoaded() and not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(500) end
	ifont = renderCreateFont("Verdana", 9, 5)--("Comic Sans MS", 9, 1)
	clickfont = renderCreateFont("Tahoma", 10, FCR_BOLD + FCR_BORDER)

	_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	nick = sampGetPlayerNickname(id)

	-- tag_time = tostring(os.date('%H:%M:%S'))
	-- if tonumber(os.date('%H')) < 6 then tag_greeting = 'Доброй ночи. '
	-- elseif tonumber(os.date('%H')) > 6 and tonumber(os.date('%H')) < 12 then tag_greeting = 'Доброе утро. '
	-- elseif tonumber(os.date('%H')) > 12 and tonumber(os.date('%H')) < 18 then tag_greeting = 'Добрый день. '
	-- elseif tonumber(os.date('%H')) > 18 and tonumber(os.date('%H')) < 23 then tag_greeting = 'Добрый вечер. '
	-- else tag_greeting = 'Доброго времени суток. ' end

	--https://raw.githubusercontent.com/PanSeek/zuwi/master/version.txt
		if checkupdate.v then
			async_http_request('GET', 'https://raw.githubusercontent.com/PanSeek/zuwi/master/version.txt', nil, function(response)
				if version_script ==  response.text then
					if lang_chat.v then sampAddChatMessage(tag..'Вы используете {0E8604}актуальную {888EA0}версию скрипта', main_color)
					elseif not lang_chat.v then sampAddChatMessage(tag..'You are using {0E8604}the current {888EA0}version of the script', main_color) end
				elseif version_script <  response.text then
					if lang_chat.v then sampAddChatMessage(tag..'Вы используете {B31A06}неактуальную {888EA0}версию скрипта. Для обновления, введите: {F9D82F}/z_update', main_color)
					elseif not lang_chat.v then sampAddChatMessage(tag..'You are using an {B31A06}irrelevant {888EA0}version of the script. To update, write: {F9D82F}/z_update', main_color) end
				elseif version_script > response.text then
					if lang_chat.v then sampAddChatMessage(tag..'Вы используете {F9D82F}тестовую {888EA0}версию скрипта', main_color) --{0984D2}
					elseif not lang_chat.v then sampAddChatMessage(tag..'You are using a {F9D82F}test {888EA0}version of the script', main_color) end
				end
			 	end,
			 	function(err)
					if lang_chat.v then sampAddChatMessage(tag..'{B31A06}Не удалось {888EA0}проверить версию скрипта', main_color)
					elseif not lang_chat.v then sampAddChatMessage(tag..'{B31A06}Failed {888EA0}to check the version of the script', main_color) end
				end)
		elseif not checkupdate.v then sampAddChatMessage(tag..'У Вас выключено автообновление. Вы используете версию: {F9D82F}'..version_script, main_color) end

	imgui.Process = false

	sampRegisterChatCommand('z_authors', cmd_authors);sampRegisterChatCommand('zauthors', cmd_authors)--;sampRegisterChatCommand(cmd_authors2.v, cmd_authors)
	sampRegisterChatCommand('z_date', cmd_date);sampRegisterChatCommand('zdate', cmd_date)--;sampRegisterChatCommand(cmd_date2.v, cmd_date)
	sampRegisterChatCommand('z_menu', cmd_imgui);sampRegisterChatCommand('zmenu', cmd_imgui)--;sampRegisterChatCommand(cmd_imgui2.v, cmd_imgui)
	sampRegisterChatCommand('z_suicide', cmd_suicide);sampRegisterChatCommand('zsuicide', cmd_suicide)--;sampRegisterChatCommand(cmd_suicide2.v, cmd_suicide)
	sampRegisterChatCommand('z_coord', cmd_coord);sampRegisterChatCommand('zcoord', cmd_coord)--;sampRegisterChatCommand(cmd_coord2.v, cmd_coord)
	sampRegisterChatCommand('z_getmoney', cmd_getmoney);sampRegisterChatCommand('zgetmoney', cmd_getmoney)--;sampRegisterChatCommand(cmd_getmoney2.v, cmd_getmoney)
	sampRegisterChatCommand('z_fakerepair', cmd_fakerepair);sampRegisterChatCommand('zfakerepair', cmd_fakerepair)--;sampRegisterChatCommand(cmd_fakerepair2.v, cmd_fakerepair)
	sampRegisterChatCommand('z_togall', cmd_togall);sampRegisterChatCommand('ztogall', cmd_togall)--;sampRegisterChatCommand(cmd_togall2.v, cmd_togall)
	sampRegisterChatCommand('z_errors', cmd_errors);sampRegisterChatCommand('zerrors', cmd_errors)--;sampRegisterChatCommand(cmd_errors2.v, cmd_errors)
	sampRegisterChatCommand('z_time', cmd_time);sampRegisterChatCommand('ztime', cmd_time)--;sampRegisterChatCommand(cmd_time2.v, cmd_time)
	sampRegisterChatCommand('z_weather', cmd_weather);sampRegisterChatCommand('zweather', cmd_weather)--;sampRegisterChatCommand(cmd_weather2.v, cmd_weather)
	sampRegisterChatCommand('z_help', cmd_help);sampRegisterChatCommand('zhelp', cmd_help)--;sampRegisterChatCommand(cmd_help2.v, cmd_help)
	sampRegisterChatCommand('z_setmark', cmd_setmark);sampRegisterChatCommand('zsetmark', cmd_setmark)--;sampRegisterChatCommand(cmd_setmark2.v, cmd_setmark)
	sampRegisterChatCommand('z_tpmark', cmd_tpmark);sampRegisterChatCommand('ztpmark', cmd_tpmark)--;sampRegisterChatCommand(cmd_tpmark2.v, cmd_tpmark)
	sampRegisterChatCommand('z_cc', cmd_clearchat);sampRegisterChatCommand('zcc', cmd_clearchat)--;sampRegisterChatCommand(cmd_clearchat2.v, cmd_clearchat)
	sampRegisterChatCommand('z_version', cmd_version);sampRegisterChatCommand('zversion', cmd_version)--;sampRegisterChatCommand(cmd_version2.v, cmd_version)
	sampRegisterChatCommand('z_update', cmd_update);sampRegisterChatCommand('zupdate', cmd_update)--;sampRegisterChatCommand(cmd_update2.v, cmd_update)
	sampRegisterChatCommand('z_checktime', cmd_checktime);sampRegisterChatCommand('zchecktime', cmd_checktime)--;sampRegisterChatCommand(cmd_checktime2.v, cmd_checktime)
	sampRegisterChatCommand('z_cmdsamp', cmd_helpcmdsamp);sampRegisterChatCommand('zcmdsamp', cmd_helpcmdsamp)--;sampRegisterChatCommand(cmd_helpcmdsamp2.v, cmd_helpcmdsamp)
	sampRegisterChatCommand('z_reload', cmd_reload);sampRegisterChatCommand('zreload', cmd_reload)--;sampRegisterChatCommand(cmd_reload2.v, cmd_reload)
	sampRegisterChatCommand('z_at', cmd_at);sampRegisterChatCommand('zat', cmd_at)
	sampRegisterChatCommand('z_fps', cmd_fps);sampRegisterChatCommand('zfps', cmd_fps)
	--sampRegisterChatCommand('z_tpmark_gta', cmd_tpmark_gta);sampRegisterChatCommand('ztpmark_gta', cmd_tpmark_gta)

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
		imgui.Process = main_window_state.v

		if time then
			setTimeOfDay(time, 0)
		end

	end
end
--KEYS FUNCTION
function check_keys()
	if not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() then
		if isKeyJustPressed(key.VK_F10) then --open/close menu imgui
			main_window_state.v = not main_window_state.v
		end

		if isKeyJustPressed(key.VK_RSHIFT) then --airbrake RSHIFT key
			CheckAirBrake = not CheckAirBrake
			if CheckAirBrake then
				local posX, posY, posZ = getCharCoordinates(PLAYER_PED)
				airBrakeCoords = {posX, posY, posZ, 0.0, 0.0, getCharHeading(PLAYER_PED)}
			else
			end
		end

		if isKeyJustPressed(key.VK_MBUTTON) and show_imgui_clickwarp.v then
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

		if wasKeyPressed(key.VK_F11) then --on/off cursor
			active = not active
			imgui.ShowCursor = active
		end

	end
end

function main_funcs()
---------------------ACTOR-------------------------
	if show_imgui_infRun.v and not isCharInWater(PLAYER_PED) then --Infinity run
		mem.setint8(0xB7CEE4, 1, false)
	elseif show_imgui_infSwim.v and isCharInWater(PLAYER_PED) then --Infinity swim
		mem.setint8(0xB7CEE4, 1, false)
	else
		mem.setint8(0xB7CEE4, 0, false)
	end

	if show_imgui_gmActor.v and CheckGMactor then --gm
		GMtext = '{29C730}GM'
		setCharProofs(playerPed, true, true, true, true, true)
	else
		GMtext = '{B22C2C}GM'
		setCharProofs(playerPed, false, false, false, false, false)
	end

	if show_imgui_infOxygen.v then --Infinity oxygen
		mem.setint8(0x96916E, 1, false)
	else
		mem.setint8(0x96916E, 0, false)
	end

	if show_imgui_megajumpActor.v then --Mega Jump
		mem.setint8(0x96916C, 1, false)
	else
		mem.setint8(0x96916C, 0, false)
	end

	if show_imgui_nofall.v then --No fall
		if isCharPlayingAnim(PLAYER_PED, 'KO_SKID_BACK') or isCharPlayingAnim(PLAYER_PED, 'FALL_COLLAPSE') then
			clearCharTasksImmediately(PLAYER_PED)
		end
	end

	if isKeyJustPressed(key.VK_OEM_2) and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and not isPlayerDead(PLAYER_PED) then -- unfreeze
		if show_imgui_unfreeze.v then
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

	if wasKeyPressed(key.VK_F3) and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and not isPlayerDead(PLAYER_PED) then	--suicideActor
		if show_imgui_suicideActor.v then
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

		if wasKeyPressed(key.VK_BACK) and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and not isPlayerDead(PLAYER_PED) then --flip180
			if show_imgui_flip180.v then
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

		if isKeyJustPressed(key.VK_N) and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and not isPlayerDead(PLAYER_PED) then -- fast exit
			if show_imgui_fastexit.v then
				local posX, posY, posZ = getCarCoordinates(storeCarCharIsInNoSave(PLAYER_PED))
				warpCharFromCarToCoord(PLAYER_PED, posX, posY, posZ)
			end
		end

		if wasKeyPressed(key.VK_B) and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and not isPlayerDead(PLAYER_PED) then --hop
			if show_imgui_hopVeh.v then
				local cVecX, cVecY, cVecZ = getCarSpeedVector(storeCarCharIsInNoSave(PLAYER_PED))
				if cVecZ < 7.0 then applyForceToCar(storeCarCharIsInNoSave(PLAYER_PED), 0.0, 0.0, 0.2, 0.0, 0.0, 0.0) end
			end
		end

		if wasKeyPressed(key.VK_DELETE) and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and not isPlayerDead(PLAYER_PED) then --flipOnWheels
			if show_imgui_flipOnWheels.v then
				local veh = player_veh[0]
				if veh ~= samem.nullptr then
					local matrix = veh.pMatrix
					matrix.right = -matrix.right
				end
			markCarAsNoLongerNeeded(veh)
			end
		end

		if wasKeyPressed(key.VK_F3) and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and not isPlayerDead(PLAYER_PED) then --suicideVeh
			if show_imgui_suicideVeh.v then
				local myCar = storeCarCharIsInNoSave(PLAYER_PED)
				setCarHealth(myCar, 0)
				for i = 0, 3 do burstCarTire(myCar, i) end
				markCarAsNoLongerNeeded(myCar)
			else
				if lang_chat.v then sampAddChatMessage(errorRUS[6], main_color)
				elseif not lang_chat.v then sampAddChatMessage(errorENG[6], main_color) end
			end
		end

		if show_imgui_antiBikeFall.v then --anti bike fall
			setCharCanBeKnockedOffBike(PLAYER_PED, true)
		else
			setCharCanBeKnockedOffBike(PLAYER_PED, false)
		end

		if show_imgui_gmVeh.v and CheckGMveh then --GM
			VGMtext = '{29C730}VGM'
			setCarProofs(storeCarCharIsInNoSave(playerPed), true, true, true, true, true)
			setCharCanBeKnockedOffBike(playerPed, true)
			setCanBurstCarTires(storeCarCharIsInNoSave(playerPed), false)
		else
			VGMtext = '{B22C2C}VGM'
		end

		if show_imgui_restHealthVeh.v and isKeyJustPressed(key.VK_1) then fixCar(storeCarCharIsInNoSave(PLAYER_PED)) end --restore health

		if show_imgui_fixWheels.v then -- restore wheels
			local veh = storeCarCharIsInNoSave(PLAYER_PED)
				if wasKeyPressed(key.VK_1) and wasKeyPressed(key.VK_Z) then
				for i = 0, 3 do
				fixCarTire(veh, i)
				end
			end
		end

		if show_imgui_engineOnVeh.v then --engineOn
			EngineText = '{29C730}Engine'
			switchCarEngine(storeCarCharIsInNoSave(PLAYER_PED), true)
		else
			EngineText = '{B22C2C}Engine'
		end

		if show_imgui_speedhack.v and isKeyDown(VK_LMENU) then -- speedhack
			speedhackMaxSpeed = SpeedHackMaxSpeed.v
			if getCarSpeed(storeCarCharIsInNoSave(playerPed)) * 2.01 <= SpeedHackMaxSpeed.v then
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

		if show_imgui_megajumpBMX.v then
			mem.setint8(0x969161, 1, false)
		else
			mem.setint8(0x969161, 0, false)
		end

		if show_imgui_gmWheels.v and CheckGMWveh then
			VGMWheelstext = '{29C730}VGMWheels'
			local veh = storeCarCharIsInNoSave(PLAYER_PED)
			setCanBurstCarTires(veh, false)
		else
			VGMWheelstext = '{B22C2C}VGMWheels'
		end

		if show_imgui_perfectHandling.v then
			mem.setint8(0x96914C, 1, false)
		else
			mem.setint8(0x96914C, 0, false)
		end

		-- if show_imgui_allCarsNitro.v then
		-- 	mem.setint8(0x969165, 1, false)
		-- else
		-- 	mem.setint8(0x969165, 0, false)
		-- end

		-- if show_imgui_onlyWheels.v then
		-- 	mem.setint8(0x96914B, 1, false)
		-- else
		-- 	mem.setint8(0x96914B, 0, false)
		-- end

		-- if show_imgui_tankMode.v then
		-- 	mem.setint8(0x969164, 1, false)
		-- else
		-- 	mem.setint8(0x969164, 0, false)
		-- end

		-- if show_imgui_carsFloatWhenHit.v then
		-- 	mem.setint8(0x969166, 1, false)
		-- else
		-- 	mem.setint8(0x969166, 0, false)
		-- end

		if show_imgui_driveOnWater.v then
			mem.setint8(0x969152, 1, false)
		else
			mem.setint8(0x969152, 0, false)
		end
	end
	----------------WEAPONS--------------
	if show_imgui_infAmmo.v then -- Inf ammo, no reload
		mem.setint8(0x969178, 1, false)
	else
		mem.setint8(0x969178, 0, false)
	end

	-- if show_imgui_fullaiming.v then -- FULL AIMING
	-- 	mem.setint8(0x969179, 1, false)
	-- else
	-- 	mem.setint8(0x969179, 0, false)
	-- end
	----------------MISC-----------------
	if show_imgui_UnderWater.v then
		mem.setint8(0x6C2759, 1, false)
	else
		mem.setint8(0x6C2759, 0, false)
	end

	if show_imgui_FOV.v then --FOV CHANGER
		cameraSetLerpFov(FOV_value.v, 0.1, 1000, 1)
	end

	if show_imgui_sensfix.v then
		local asf = mem.read (0xB6EC1C, 4, false)
		local bsf = mem.read (0xB6EC18, 4, false)
		if not asf == bsf then --float
			writeMemory (0xB6EC18, 4, asf, false)
		end
	end

	if show_imgui_reconnect.v then
		local ip, port = sampGetCurrentServerAddress()
		local sname = sampGetCurrentServerName()
		--recon_delay.v = os.clock() * 1000
		if --[[recon_delay.v and]] wasKeyPressed(key.VK_0) and wasKeyPressed(key.VK_LSHIFT) then
			sampConnectToServer(ip, port)
			if lang_chat.v then sampAddChatMessage(tag.. 'Вы перезашли на сервер: {F9D82F}' ..sname.. ' {888EA0}IP: {F9D82F}' ..ip.. ':' ..port, main_color)
			elseif not lang_chat.v then sampAddChatMessage(tag.. 'You are logged on: {F9D82F}' ..sname.. ' {888EA0}IP: {F9D82F}' ..ip.. ':' ..port, main_color) end
		end
	end

	if show_imgui_AirBrake.v and CheckAirBrake then--AirBrake
		ABtext = '{29C730}AirBrake'
		AirBrakeSpeed = AirBrake_Speed.v --Speed
		if isCharInAnyCar(PLAYER_PED) then heading = getCarHeading(storeCarCharIsInNoSave(PLAYER_PED))
		else heading = getCharHeading(PLAYER_PED) end
		local camCoordX, camCoordY, camCoordZ = getActiveCameraCoordinates()
		local targetCamX, targetCamY, targetCamZ = getActiveCameraPointAt()
		local angle = getHeadingFromVector2d(targetCamX - camCoordX, targetCamY - camCoordY)
		if isCharInAnyCar(PLAYER_PED) then difference = 0.79 else difference = 1.0 end
		if isKeyDown(key.VK_W) then
			if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
				airBrakeCoords[1] = airBrakeCoords[1] + AirBrake_Speed.v * math.sin(-math.rad(angle))
				airBrakeCoords[2] = airBrakeCoords[2] + AirBrake_Speed.v * math.cos(-math.rad(angle))
				setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - difference)
				if not isCharInAnyCar(PLAYER_PED) then setCharHeading(PLAYER_PED, angle)
				else setCarHeading(storeCarCharIsInNoSave(PLAYER_PED), angle) end
			else setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - 1.0) end
		elseif isKeyDown(key.VK_S) then
			if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
				airBrakeCoords[1] = airBrakeCoords[1] - AirBrake_Speed.v * math.sin(-math.rad(heading))
				airBrakeCoords[2] = airBrakeCoords[2] - AirBrake_Speed.v * math.cos(-math.rad(heading))
				setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - difference)
			else setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - 1.0) end
		end
		if isKeyDown(key.VK_A) then
			if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
				airBrakeCoords[1] = airBrakeCoords[1] - AirBrake_Speed.v * math.sin(-math.rad(heading - 90))
				airBrakeCoords[2] = airBrakeCoords[2] - AirBrake_Speed.v * math.cos(-math.rad(heading - 90))
				setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - difference)
			else setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - 1.0) end
		elseif isKeyDown(key.VK_D) then
			if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
				airBrakeCoords[1] = airBrakeCoords[1] - AirBrake_Speed.v * math.sin(-math.rad(heading + 90))
				airBrakeCoords[2] = airBrakeCoords[2] - AirBrake_Speed.v * math.cos(-math.rad(heading + 90))
				setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - difference)
			else setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - 1.0) end
		end
		if isKeyDown(key.VK_UP) then
			if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
				airBrakeCoords[3] = airBrakeCoords[3] + AirBrake_Speed.v  / 2.0
				setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - difference)
			else setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - 1.0) end
		end
		if isKeyDown(key.VK_DOWN) and airBrakeCoords[3] > -95.0 then
			if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
				airBrakeCoords[3] = airBrakeCoords[3] - AirBrake_Speed.v  / 2.0
				setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - difference)
			else setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - 1.0) end
		end
		if not isKeyDown(key.VK_W) and not isKeyDown(key.VK_S) and not isKeyDown(key.VK_A) and not isKeyDown(key.VK_D) and not isKeyDown(key.VK_UP) and not isKeyDown(key.VK_DOWN) then
			setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - 1.0)
		end
	else
		ABtext = '{B22C2C}AirBrake'
	end

	if show_imgui_blink.v and not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() then --Blink
		blinkDist = blink_dist.v -- distance
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
			blink[1] = blink[1] + blink_dist.v * math.sin(-math.rad(angle))
			blink[2] = blink[2] + blink_dist.v * math.cos(-math.rad(angle))
			setCharCoordinates(PLAYER_PED, blink[1], blink[2], blink[3] - difference)
		end
	end

	if show_imgui_clickwarp.v and checkClickwarp then
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
					renderFontDrawText(clickfont, string.format('Distance: %0.2f', dist), sx - (renderGetFontDrawTextLength(clickfont, string.format('Distance: %0.2f', dist)) / 2) + 6, sy - hoffs, 0xFFFFFFFF)
					local tpIntoCar = nil
					if colpoint.entityType == 2 then
						local car = getVehiclePointerHandle(colpoint.entity)
						if doesVehicleExist(car) and (not isCharInAnyCar(playerPed) or storeCarCharIsInNoSave(playerPed) ~= car) then
							if isKeyJustPressed(key.VK_LBUTTON) and isKeyJustPressed(key.VK_RBUTTON) then tpIntoCar = car end
							renderFontDrawText(clickfont, '{0984d2}Push RButton for {FFFFFF}warp to car', sx - (renderGetFontDrawTextLength(clickfont, '{0984d2}Push RButton for {FFFFFF}warp to car') / 2) + 6, sy - hoffs * 2, -1)
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

	if show_imgui_nametag.v then
		NTtext = '{29C730}NameTag'
		nameTagOn()
	else
		NTtext = '{B22C2C}NameTag'
		nameTagOff()
	end

	if show_imgui_quickMap.v and isPlayerPlaying(PLAYER_HANDLE) then -- quick map (FYP)
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

	if show_imgui_fastsprint.v and isPlayerPlaying(PLAYER_HANDLE) and not isCharInAnyCar(PLAYER_PED) then -- fast sprint
		if isButtonPressed(PLAYER_HANDLE, 16) then
			setGameKeyState(16, 255)
			wait(3)
			setGameKeyState(16, 0)
		end
	end
	--------------------VISUAL-----------------------------
	if show_imgui_clrScr.v and isKeyJustPressed(key.VK_F8) then -- clear screenshot
		if show_imgui_nametag.v then
			nameTagOff()
			wait(1000)
			nameTagOn()
		end
		if imgui.Process == true then
			imgui.Process = false
			wait(1000)
			imgui.Process = true
		end
		if infbar.v then
			infbar.v = not infbar.v
			wait(1000)
			infbar.v = not infbar.v
		end
		if checkClickwarp then
			checkClickwarp = not checkClickwarp
			wait(1000)
			checkClickwarp = not checkClickwarp
		end
	end

	if show_imgui_antibhop.v then ABHtext = '{29C730}Anti-BHop' else ABHtext = '{B22C2C}Anti-BHop' end --text antibhop for infoBar

	if isPlayerPlaying(PLAYER_HANDLE) and not isPauseMenuActive() and infbar.v then --infobar
		local posX, posY = getScreenResolution()
		local playerposX, playerposY, playerposZ = getCharCoordinates(playerPed)
		local ifps = mem.getfloat(0xB7CB50, 4, false)
		renderDrawBoxWithBorder(-1, posY - 18, posX + 2, 20, 0x44888EA0, 1, 0xFFF9D82F)
		if not isCharInAnyCar(PLAYER_PED) then
			local playerInterior, playerID, playerHP, playerAP, playerPing  = getPlayerOnFootInfo()
			local text = string.format("{888EA0}Int:{F9D82F} %d {888EA0}| [{F9D82F}%.2f{888EA0}] [{F9D82F}%.2f{888EA0}] [{F9D82F}%.2f{888EA0}] {FF0000}| {888EA0}ID:{F9D82F} %d {888EA0}| Health:{F9D82F} %d {888EA0}| Armor:{F9D82F} %d {888EA0}| Ping:{F9D82F} %d {888EA0}| FPS:{F9D82F} %d",
				playerInterior, playerposX, playerposY, playerposZ, playerID, playerHP, playerAP, playerPing, ifps)
			local screenW, screenH = getScreenResolution()
			local fontlen = renderGetFontDrawTextLength(ifont, text)
			renderFontDrawText(ifont, text, screenW / 999, screenH - 17, 0xFF0984D2)

			local checkFunc = string.format("{888EA0}["..ABtext.."{888EA0}] ["..NTtext.."{888EA0}] ["..GMtext.."{888EA0}] ["..ABHtext.."{888EA0}]")
			renderFontDrawText(ifont,  checkFunc, screenW / 2, screenH - 17, 0xFF0984D2)
			
		elseif isCharInAnyCar(PLAYER_PED) then
			local playerID, vehID, playerHP, playerAP, vehHP, playerPing = getPlayerInCarInfo()
			local text = string.format("[{F9D82F}%.2f{888EA0}] [{F9D82F}%.2f{888EA0}] [{F9D82F}%.2f{888EA0}] {FF0000}| {888EA0}ID:{F9D82F} %d {888EA0}| VID:{F9D82F} %d {888EA0}| Health:{F9D82F} %d {888EA0}| Armor:{F9D82F} %d {888EA0}| VHealth:{F9D82F} %d {888EA0}| Ping:{F9D82F} %d {888EA0}| FPS:{F9D82F} %d",
				playerposX, playerposY, playerposZ, playerID, vehID, playerHP, playerAP, vehHP, playerPing, ifps)
			local screenW, screenH = getScreenResolution()
			local fontlen = renderGetFontDrawTextLength(ifont, text)
			renderFontDrawText(ifont, text, screenW / 999, screenH - 17, 0xFF0984D2)

			local checkFunc = string.format("{888EA0}["..ABtext.."{888EA0}] ["..NTtext.."{888EA0}] ["..GMtext.."{888EA0}] ["..VGMtext.."{888EA0}] ["..VGMWheelstext.."{888EA0}] ["..EngineText.."{888EA0}]")
			renderFontDrawText(ifont,  checkFunc, screenW / 2, screenH - 17, 0xFF0984D2)
		end
	end
--
end
-------SAMP EVENTS-------
function sampev.onSendPlayerSync(data)
	if show_imgui_antibhop.v then --antiBHop (IMGUI)
		if bit.band(data.keysData, 0x28) == 0x28 then
			data.keysData = bit.bxor(data.keysData, 0x20)
		end
	end
end

function sampev.onServerMessage(color, text) 
	if string.find(text, "Вы вошли, как администратор") then
		Admin = not Admin --tipa vidacha adminki
	end
	if at_chat.v then -- color adm chat = 15180346
		admchat = text:gsub('Админ (%d+)', '[ALVL %1]')
		--sampAddChatMessage(text:gsub('[ALVL %1]', admchat), blueA_color)
		return {color, admchat}
	end
end

-- function sampev.onSendChat(msg)
-- 	if autoaccent.v then
-- 		return {'[Мексиканский акцент]: ' .. msg}
-- 	end
-- end
---------------------------------КОМАНДЫ-------------------------------------
function cmd_update()
	async_http_request('GET', 'https://raw.githubusercontent.com/PanSeek/zuwi/master/version.txt', nil, function(response)
	if version_script == response.text then
		if lang_chat.v then sampAddChatMessage(tag..'Вы используете {0E8604}актуальную {888EA0}версию скрипта', main_color)
		elseif not lang_chat.v then sampAddChatMessage(tag..'You are using {0E8604}the current {888EA0}version of the script', main_color) end
	elseif version_script ~= response.text then
		if lang_chat.v then sampAddChatMessage(tag..'{0E8604}Обновляемся..', main_color)
		elseif not lang_chat.v then sampAddChatMessage(tag..'{0E8604}Updating..', main_color) end
		downloadUrlToFile('https://github.com/PanSeek/zuwi/blob/master/zuwi.lua', 'moonloader/zuwi.lua', function(id, status)
			if status == dlstatus.STATUS_DOWNLOADINGDATA then
			elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
				if lang_chat.v then sampAddChatMessage(tag..'Загрузка обновления {0E8604}завершена', main_color)
				elseif not lang_chat.v then sampAddChatMessage(tag..'Download update {0E8604}complete', main_color) end
				thisScript():reload()
			end
		end)
	end
	end,
		function(err)
		if lang_chat.v then sampAddChatMessage(tag..'{B31A06}Не удалось {888EA0}проверить версию скрипта', main_color)
		elseif not lang_chat.v then sampAddChatMessage(tag..'{B31A06}Failed {888EA0}to check the version of the script', main_color) end
	end)
end
--https://raw.githubusercontent.com/PanSeek/zuwi/master/zuwi.lua

function cmd_time(param)
	local hour = tonumber(param)
	if hour ~= nil and hour >= 0 and hour <= 23 then
		time = hour
		patch_samp_time_set(true)
		if lang_chat.v then sampAddChatMessage(tag..'Время изменено на {F9D82F}' .. time, main_color)
		elseif not lang_chat.v then sampAddChatMessage(tag..'Time change to {F9D82F}' .. time, main_color) end
	else
		patch_samp_time_set(false)
		time = nil
		if lang_chat.v then sampAddChatMessage(errorRUS[12], main_color)
		elseif not lang_chat.v then sampAddChatMessage(errorENG[12], main_color) end
	end
end

function cmd_fps()
	local fps = mem.getfloat(0xB7CB50, 4, false)
	local ifps = string.format('%d', fps)
	if lang_chat.v then sampAddChatMessage(tag..'Сейчас FPS: {F9D82F}'..ifps, main_color)
	elseif not lang_chat.v then sampAddChatMessage(tag..'FPS now: {F9D82F}'..ifps, main_color) end
end

-- function cmd_tpmark_gta()
--   relust, posX, posY, posZ = SearchMarker()
--   if result then
--     --activate = true
--     requestCollision(posX, posY)
--     loadScene(posX, posY, posZ)
--     setCharCoordinates(PLAYER_PED, posX, posY, posZ)
--     sampRequestClass()
--     wait(2000)
--     --activate = false
--   else
--     sampAddChatMessage(tag..'ты типа нихуя не тпшнулся нахуй сука блять {FF5555}сдохни {FF0000}мразь', main_color)
--   end
-- end

function cmd_weather(param)
	local weather = tonumber(param)
	if weather ~= nil and weather >= 0 and weather <= 45 then
		forceWeatherNow(weather)
		if lang_chat.v then sampAddChatMessage(tag..'Погода изменена на {F9D82F}№' .. weather, main_color)
		elseif not lang_chat.v then sampAddChatMessage(tag..'Weather change on {F9D82F}№' .. weather, main_color) end
	else
		if lang_chat.v then sampAddChatMessage(errorRUS[13], main_color)
		elseif not lang_chat.v then sampAddChatMessage(errorENG[13], main_color) end
	end
end

function cmd_authors()
	if not sampIsDialogActive() then
		if lang_dialogs.v then sampShowDialog(2001, tag..'{F9D82F}Авторство {888EA0}и {0E8604}благодарности', authorsRUS, 'Закрыть', '', 0)
		elseif not lang_dialogs.v then sampShowDialog(2001, tag..'{F9d82f}Authors {888ea0}and {0e8604}thanks', authorsENG, 'Close', '', 0) end
	else sampAddChatMessage(errorRUS[11], main_color) end
end

function cmd_version()
	if lang_chat.v then sampAddChatMessage(tag.. 'Версия скрипта:{F9D82F} v' ..version_script, main_color)
	elseif not lang_chat.v then sampAddChatMessage(tag.. 'Version script:{F9D82F} v' ..version_script, main_color) end
end

function cmd_date()
	if lang_chat.v then sampAddChatMessage(os.date(tag..'Сегодняшняя дата: {F9D82F}%d.%m.%Y'), main_color)
	elseif not lang_chat.v then sampAddChatMessage(os.date(tag..'Todays date: {F9D82F}%d.%m.%Y'), main_color) end
end

function cmd_imgui()
	main_window_state.v = not main_window_state.v
	imgui.Process = main_window_state.v
	if lang_chat.v then sampAddChatMessage(tag..'Вы {F9D82F}открыли/закрыли {888EA0}меню скрипта. Это можно сделать без команды, с помощью клавиши {F9D82F}F10', main_color)
	elseif not lang_chat.v then sampAddChatMessage(tag..'You is {F9D82F}open/close {888EA0}script menu. This can be done without a command, using the key {F9D82F}F10', main_color) end
end

function cmd_help()
	if not main_window_state.v then
		main_window_state.v = not main_window_state.v
		imgui.Process = main_window_state.v
		act1 = 8
	elseif main_window_state.v then
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
		sampAddChatMessage(' Вы починили транспорт!', 16113331)
	else
		if lang_chat.v then sampAddChatMessage(errorRUS[6], main_color)
		elseif not lang_chat.v then sampAddChatMessage(errorENG[6], main_color) end
	end
end

function cmd_coord()
	if not isPlayerDead(PLAYER_PED) then
		x,y,z = getCharCoordinates(PLAYER_PED)
		if lang_chat.v then sampAddChatMessage(tag..'Ваши координаты: X: {F9D82F}' .. math.floor(x) .. '{888EA0} | Y: {F9D82F}' .. math.floor(y) .. '{888EA0} | Z: {F9D82F}' .. math.floor (z), main_color)
		elseif not lang_chat.v then sampAddChatMessage(tag..'You are coords: X: {F9D82F}' .. math.floor(x) .. '{888EA0} | Y: {F9D82F}' .. math.floor(y) .. '{888EA0} | Z: {F9D82F}' .. math.floor (z), main_color) end
	else
		if lang_chat.v then sampAddChatMessage(errorRUS[1], main_color)
		elseif not lang_chat.v then sampAddChatMessage(errorENG[1], main_color) end
	end
end

function cmd_setmark()
	local interiorMark = getActiveInterior(PLAYER_PED)
	intMark = {getActiveInterior(PLAYER_PED)}
	local posX, posY, posZ = getCharCoordinates(PLAYER_PED)
	setmark = {posX, posY, posZ}
	if lang_chat.v then sampAddChatMessage(tag..'Создана метка по координатам: X: {F9D82F}' .. math.floor(setmark[1]) .. '{888EA0} | Y: {F9D82F}' .. math.floor(setmark[2]) .. '{888EA0} | Z: {F9D82F}' .. math.floor(setmark[3]), main_color)
		sampAddChatMessage(tag..'Интерьер: {F9D82F}' .. interiorMark, main_color)
	elseif not lang_chat.v then sampAddChatMessage(tag..'You are create mark by coords: X: {F9D82F}' .. math.floor(setmark[1]) .. '{888EA0} | Y: {F9D82F}' .. math.floor(setmark[2]) .. '{888EA0} | Z: {F9D82F}' .. math.floor(setmark[3]), main_color)
		sampAddChatMessage(tag..'Interior: {F9D82F}' .. interiorMark, main_color) end
end

function cmd_reload()
	thisScript():reload()
end

function cmd_tpmark()
	if setmark then		
		teleportInterior(PLAYER_PED, setmark[1], setmark[2], setmark[3], intMark[1])	
		-- setCharCoordinates(PLAYER_PED, setmark[1], setmark[2], setmark[3] - difference)
		if lang_chat.v then sampAddChatMessage(tag..'Вы телепортировались по метке', main_color)
		elseif not lang_chat.v then sampAddChatMessage(tag..'You are teleport to mark', main_color) end
	else
		if lang_chat.v then sampAddChatMessage(errorRUS[14], main_color)
		elseif not lang_chat.v then sampAddChatMessage(errorENG[14], main_color) end
	end
end

function cmd_getmoney()
	if not isPlayerDead(PLAYER_PED) then
		local money = mem.getint32(0xB7CE50)
		mem.setint32(0xB7CE50, money + 1000, false)
		if lang_chat.v then sampAddChatMessage(tag..'Вам выдано: {F9D82F}1.000$ {888EA0}(Визуально)', main_color)
		elseif not lang_chat.v then sampAddChatMessage(tag..'Issued to you: {F9D82F}1.000$ {888EA0}(Visual)', main_color) end
	else
		if lang_chat.v then sampAddChatMessage(errorRUS[1], main_color)
		elseif not lang_chat.v then sampAddChatMessage(errorENG[1], main_color) end
	end
end

function cmd_checktime()
	local time = getTime(0) -- MSK time
	if lang_chat.v then sampAddChatMessage(os.date(tag..'Точное время по МСК: {F9D82F}%H{888EA0}:{F9D82F}%M{888EA0}:{F9D82F}%S', time), main_color)
	elseif not lang_chat.v then sampAddChatMessage(os.date(tag..'Exact time to MSK: {F9D82F}%H{888EA0}:{F9D82F}%M{888EA0}:{F9D82F}%S', time), main_color) end
end

function cmd_errors()
	if not sampIsDialogActive() then
		if lang_dialogs.v then sampShowDialog(1999, tag..'Список {B31A06}ошибок', errorslistRUS, 'Закрыть', '', 0)
		elseif not lang_dialogs.v then sampShowDialog(1999, tag..'List {B31A06}errors', errorslistENG, 'Close', '', 0) end
	else
		if lang_chat.v then sampAddChatMessage(errorRUS[11], main_color)
		elseif not lang_chat.v then sampAddChatMessage(errorENG[11], main_color) end
	end
end

function cmd_helpcmdsamp()
	if not sampIsDialogActive() then
		if lang_dialogs.v then sampShowDialog(2005, tag..'Список команд SA-MP', helpcmdsampRUS, 'Закрыть', '', 0)
		elseif not lang_dialogs.v then sampShowDialog(2005, tag..'List commands SA-MP', helpcmdsampENG, 'Close', '', 0) end
	else
		if lang_chat.v then sampAddChatMessage(errorRUS[11], main_color)
		elseif not lang_chat.v then sampAddChatMessage(errorENG[11], main_color) end
	end
end

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
		sampAddChatMessage(tag..'Всевозможные и доступные для Вас команды {F9D82F}отключены/включены', main_color)
	end
end
-----------ADMIN (REVENT) COMMANDS----------------
function cmd_at()
	Admin = not Admin
end

function cmd_spec(param)
	if at_scmd.v then
		local id = tonumber(param)
		if id ~= nil and id >= 0 and id <= 1000 then
			sampSendChat('/spec '..id)
		else
			sampAddChatMessage(tag..'Используйте: {F9D82F}/sp [id]', main_color)
		end
	end
end

function cmd_freeze(param)
	if at_scmd.v then
		local id = tonumber(param)
		if id ~= nil and id >= 0 and id <= 1000 then
			sampSendChat('/freeze '..id)
		else
			sampAddChatMessage(tag..'Используйте: {F9D82F}/fz [id]', main_color)
		end
	end
end

function cmd_unfreeze(param)
	if at_scmd.v then
		local id = tonumber(param)
		if id ~= nil and id >= 0 and id <= 1000 then
			sampSendChat('/unfreeze '..id)
		else
			sampAddChatMessage(tag..'Используйте: {F9D82F}/ufz [id]', main_color)
		end
	end
end

function cmd_gg(param)
	if at_ncmd.v then
		local id = tonumber(param)
		if id ~= nil and id >= 0 and id <= 1000 then
			sampSendChat('/pm '..id..' Приятной игры и хорошего настроения на Revent Role Play!')
		else
			sampAddChatMessage(tag..'Используйте: {F9D82F}/gg [id]', main_color)
		end
	end
end

function cmd_fraklvl(param)
	local flvlmsg = {' ОПГ, больница, нац. гвардия, правительство - 1 LVL 2 EXP. Остальное - 2 LVL',
	' Больница, правительство, нац. гвардия, ОПГ - 1 LVL 2 EXP. Остальное - 2 LVL',
	' Нац. гвардия, больница, ОПГ, правительство - 1 LVL 2 EXP. Остальное - 2 LVL',
	' ОПГ, нац. гвардия, правительство, больница - 1 LVL 2 EXP. Остальное - 2 LVL',
	' Правительство, нац. гвардия, больница, ОПГ - 1 LVL 2 EXP. Остальное - 2 LVL'}
	if at_ncmd.v then
		local id = tonumber(param)
		if id ~= nil and id >= 0 and id <= 1000 then
			math.randomseed(os.time())
			sampSendChat('/an ' .. id .. flvlmsg[math.random(#flvlmsg)])
		else
			sampAddChatMessage(tag..'Используйте: {F9D82F}/fraklvl [id]', main_color)
		end
	end
end

function cmd_gethere(param)
	if at_scmd.v then
		local id = tonumber(param)
		if id ~= nil and id >= 0 and id <= 1000 then
			sampSendChat('/gethere '..id)
		else
			sampAddChatMessage(tag..'Используйте: {F9D82F}/gh [id]', main_color)
		end
	end
end

function cmd_kickinvite(param)
	if at_scmd.v then
		local id = tonumber(param)
		if id ~= nil and id >= 0 and id <= 1000 then
			sampSendChat('/kickinvite '..id)
		else
			sampAddChatMessage(tag..'Используйте: {F9D82F}/kinv [id]', main_color)
		end
	end
end

function cmd_getcar(param)
	if at_scmd.v then
		local vId = tonumber(param)
		if vId ~= nil and vId >= 0 and vId <= 2000 then
			sampSendChat('/getcar '..vId)
		else
			sampAddChatMessage(tag..'Используйте: {F9D82F}/gc [vId]', main_color)
		end
	end
end

function cmd_ainvite(param)
	if at_scmd.v then
		local idfrac = tonumber(param)
		if idfrac ~= nil and idfrac >= 0 and idfrac <= 25 then
			sampSendChat('/ainvite '..idfrac)
		else
			sampAddChatMessage(tag..'Используйте: {F9D82F}/ainv [id frac]', main_color)
		end
	end
end

function cmd_agiverank(param)
	if at_scmd.v then
		local id = tonumber(param)
		local rank = tonumber(param)
		if id ~= nil and id >= 0 and id <= 1000 and rank ~= nil and rank >= 0 and rank <= 18 then
			sampSendChat('/agiverank '..id..' '..rank)
		else
			sampAddChatMessage(tag..'Используйте: {F9D82F}/arank [id] [rank]', main_color)
		end
	end
end

function cmd_givegun(param1, param2, param3)
	if at_scmd.v then
		local id = tonumber(param1)
		local idgun = tonumber(param2)
		local ammo = tonumber(param3)
		if id ~= nil and id >= 0 and id <= 1000 and idgun ~= nil and idgun >= 0 and idgun <= 46 and ammo ~= nil and ammo >= 0 then
			sampSendChat('/givegun '..id..' '..idgun..' '..ammo)
		else
			sampAddChatMessage(tag..'Используйте: {F9D82F}/ggun [id] [id gun] [ammo]', main_color)
		end
	end
end

function cmd_dm(param)
	if at_ncmd.v then
		local id = tonumber(param)
		if id ~= nil and id >= 0 and id <= 1000 then
			sampSendChat('/jail '..id..' 20 DM')
		else
			sampAddChatMessage(tag..'Используйте: {F9D82F}/dm [id]', main_color)
		end
	end
end

function cmd_bike(param)
	if at_ncmd.v then
		local vid = tonumber(param)
		if vid ~= nil and vid == 1 then sampSendChat('/veh 510 1 1')
		elseif vid ~= nil and vid == 2 then sampSendChat('/veh 481 1 1')
		elseif vid ~= nil and vid == 3 then sampSendChat('/veh 509 1 1')
		else
			sampAddChatMessage(tag..'Используйте: {F9D82F}/bike [num]', main_color)
		end
	end
end

function cmd_sethpme()
	local isid, myid = sampGetPlayerIdByCharHandle(playerPed)
	local mynick = sampGetPlayerNickname(myid)
	if at_ncmd.v and isPlayerPlaying(PLAYER_HANDLE) then
		sampSendChat('/sethp '..myid..' 150')
	end
end

function cmd_piarask()
	local amsg = {'Возникли вопросы по игровому процессу? Наши хелперы готовы ответить на Ваши вопросы - /ask',
	'Есть вопросы по игровому моду? Задавайте их нашим хелперам - /ask',
	'Возник вопрос по игровому процессу? Задавайте его нашим хелперам - /ask',
	'Возникли вопросы по игровому процессу? Наши хелперы готовы Вам помочь - /ask'}
	if at_ncmd.v then
		math.randomseed(os.time())
		sampSendChat('/o ' .. amsg[math.random(#amsg)])
	end
end
function cmd_rspawncars() if at_scmd.v then sampSendChat('/rspawncars') end end
function cmd_deleteobjects() if at_scmd.v then sampSendChat('/deleteobjects') end end
function cmd_FillFixVeh() if at_ncmd.v then sampSendChat('/fixveh') sampSendChat('/fillveh') end end
function cmd_specoff() if at_scmd.v then sampSendChat('/specoff') end end
function cmd_fixveh() if at_scmd.v then sampSendChat('/fixveh') end end
function cmd_destroycar() if at_scmd.v then sampSendChat('/destroycar') end end
----------terminate-------------------------
function onScriptTerminate(zuwiScript, quitGame)
	if zuwiScript == thisScript() then
		if AutoSave.v and not doesFileExist("zuwi.lua.ini") then
			local ps = {
				actor = {
					infRun = show_imgui_infRun.v,
					infSwim = show_imgui_infSwim.v,
					infOxygen = show_imgui_infOxygen.v,
					suicide = show_imgui_suicideActor.v,
					megaJump = show_imgui_megajumpActor.v,
					fastSprint = show_imgui_fastsprint.v,
					unfreeze = show_imgui_unfreeze.v,
					noFall = show_imgui_nofall.v,
					GM = show_imgui_gmActor.v
				},
				vehicle = {
					flip180 = show_imgui_flip180.v,
					flipOnWheels = show_imgui_flipOnWheels.v,
					megaJumpBMX = show_imgui_megajumpBMX.v,
					hop = show_imgui_hopVeh.v,
					boom = show_imgui_suicideVeh.v,
					fastExit = show_imgui_fastexit.v,
					gmWheels = show_imgui_gmWheels.v,
					AntiBikeFall = show_imgui_antiBikeFall.v,
					GM = show_imgui_gmVeh.v,
					fixWheels = show_imgui_fixWheels.v,
					speedhack = show_imgui_speedhack.v,
					speedhackMaxSpeed = SpeedHackMaxSpeed.v,
					perfectHandling = show_imgui_perfectHandling.v,
					-- allVehNitro = show_imgui_allCarsNitro.v,
					-- onlyWheels = show_imgui_onlyWheels.v,
					-- tankMode = show_imgui_tankMode.v,
					-- vehFloatAwayWhenHit = show_imgui_carsFloatWhenHit.v,
					driveOnWater = show_imgui_driveOnWater.v,
					restoreHealth = show_imgui_restHealthVeh.v,
					engineOn = show_imgui_engineOnVeh.v
				},
				weapon = {
					infAmmo = show_imgui_infAmmo.v
					-- fullAiming = show_imgui_fullaiming.v
				},
				misc = {
					FOV = show_imgui_FOV.v,
					FOVvalue = FOV_value.v,
					antibhop = show_imgui_antibhop.v,
					AirBrake = show_imgui_AirBrake.v,
					AirBrakeSpeed = AirBrake_Speed.v,
					quickMap = show_imgui_quickMap.v,
					nameTag = show_imgui_nametag.v,
					blink = show_imgui_blink.v,
					blinkDist = blink_dist.v,
					sensfix = show_imgui_sensfix.v,
					clearScreenshot = show_imgui_clrScr.v,
					WalkDriveUnderWater = show_imgui_UnderWater.v,
					ClickWarp = show_imgui_clickwarp.v,
					reconnect = show_imgui_reconnect.v
					--reconnectDelay = recon_delay.v
				},
				visual = {
					nameTag = show_imgui_nametag.v,
					infoBar = infbar.v
				},
				menu = {
					checkUpdate = checkupdate.v,
					language_menu = lang_menu.v,
					language_chat = lang_chat.v,
					language_dialogs = lang_dialogs.v,
					autoSave = AutoSave.v
				},
				admintools = {
					adminChat = at_chat.v,
					newCMD = at_ncmd.v,
					shortCMD = at_scmd.v
				}
			} inicfg.save(ps)
		end
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
	if show_imgui_nametag.v then nameTagOff() end
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

function async_http_request(method, url, args, resolve, reject) -- асинхронные запросы, опасная штука местами, ибо при определенном использовании игра может улететь
	local request_lane = lanes.gen('*', {package = {path = package.path, cpath = package.cpath}}, function()
		local requests = require 'requests'
        local ok, result = pcall(requests.request, method, url, args)
        if ok then
            result.json, result.xml = nil, nil
            return true, result
        else
            return false, result
        end
    end)
    if not reject then reject = function() end end
    lua_thread.create(function()
        local lh = request_lane()
        while true do
            local status = lh.status
            if status == 'done' then
                local ok, result = lh[1], lh[2]
                if ok then resolve(result) else reject(result) end
                return
            elseif status == 'error' then
                return reject(lh[1])
            elseif status == 'killed' or status == 'cancelled' then
                return reject(status)
            end
            wait(0)
        end
    end)
end

function enableDialog(bool)
    mem.setint32(sampGetDialogInfoPtr()+40, bool and 1 or 0, true)
    sampToggleCursor(bool)
end

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

local fa_font = nil
local fa_glyph_ranges = imgui.ImGlyphRanges({ fa.min_range, fa.max_range })
function imgui.BeforeDrawFrame()
  if fa_font == nil then
    local font_config = imgui.ImFontConfig() -- to use 'imgui.ImFontConfig.new()' on error
    font_config.MergeMode = true
    fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fontawesome-webfont.ttf', 14.0, font_config, fa_glyph_ranges)
  end
end

-- function sampev.onPlayerJoin(id, color, isNpc, nickname)
-- 	 textLoggerRUS(u8'Игрок присоединился: {F9D82F}' .. nickname .. '[' .. id .. ']')
-- 	 textLoggerENG('Player connected: {F9D82F}' .. nickname .. '[' .. id .. ']')
-- end
--------------------------ВСЯКАЯ ПОЛЕЗНАЯ ХУЙНЯ В КОММЕНТАХ-------------------------
--local pVecX, pVecY, pVecZ = getCharVelocity(PLAYER_PED) --прыгать, как хоп в авто, только персонаж
--if pVecZ < 7.0 then
--	setCharVelocity(PLAYER_PED, 0.0, 0.0, 10.0)

-- function SearchMarker(posX, posY, posZ, radius, isRace)
--   local ret_posX = 0.0
--   local ret_posY = 0.0
--   local ret_posZ = 0.0
--   local radius = 0.0
--   local isFind = false
-- 	isRace = true
--   for id = 0, 31 do
--     local MarkerStruct = 0
--     if isRace then
-- 			MarkerStruct = 0xC7F168 + id * 56
-- 		else
-- 			MarkerStruct = 0xC7DD88 + id * 160
-- 		end
--     local MarkerPosX = representIntAsFloat(readMemory(MarkerStruct + 0, 4, false))
--     local MarkerPosY = representIntAsFloat(readMemory(MarkerStruct + 4, 4, false))
--     local MarkerPosZ = representIntAsFloat(readMemory(MarkerStruct + 8, 4, false))
--     if MarkerPosX ~= 0.0 or MarkerPosY ~= 0.0 or MarkerPosZ ~= 0.0 then
--       if getDistanceBetweenCoords3d(MarkerPosX, MarkerPosY, MarkerPosZ) > radius then
--         ret_posX = MarkerPosX
--         ret_posY = MarkerPosY
--         ret_posZ = MarkerPosZ
--         isFind = true
--       	radius = getDistanceBetweenCoords3d(MarkerPosX, MarkerPosY, MarkerPosZ)
--     	end
--     end
--   end
--   return isFind, ret_posX, ret_posY, ret_posZ
-- end
