-- ********      how to add an app    *********
-- (1) extend local w_XYZ index		;suite1conf(), create index label & corresp. index
-- (2) extend widgetList			;suite1conf(), use former created index label
-- (3) extend "apps_template"  		;defApplist(), pairing choice list entry & index number
-- (3) extend subFrm  				;getSubForm(), add index label like step (1) and create subform entries

local NIL <const> 			=  1
local PICTURE <const> 		=  2
local CurveEDIT <const> 	=  3
local ModelFINDER <const> 	=  4
local Tele01 <const> 		=  5

local w_TOPa <const> 		=  1			-- widget index, human readable format
local w_ANNOUNCE <const>   	=  2
local w_TELEEL <const>  	=  3
local w_TELE01 <const>   	=  4
local w_TELE2 <const>   	=  5
local w_SETCURVE <const>	=  6
local w_MODELFIND <const>	=  7
local w_Picture <const>		=  8
local w_GVAR <const>		=  9
local w_TopFull <const>		= 30
local w_TopStd <const>		= 31
local w_TopLight <const>	= 32
local w_DEMO <const>		= 97
local w_EMPTY <const>   	= 98
	




function getWidgetPath()
	return("/scripts/libUnow/")
end

--local function modelAnn()
function conf_EMPTY()
	widgetconfLine["EMPTY"]="EMPTY"			-- dummy config for empty widget slots
end	


function void()								-- dummy config for empty widget slots
	return
end

-- function tool1conf()
function suite1conf()

--[[
	local w_TOPa  			= 1			-- human readable format
	local w_ANNOUNCE    	= 2
	local w_TELEEL   		= 3
	local w_TELE01   		= 4
	local w_TELE2   		= 5
	local w_SETCURVE		= 6
	local w_MODELFIND		= 7
	local w_Picture			= 8
	local w_GVAR			= 9
--	local w_Top1			= 10		-- no subform
	local w_TopFull			= 30
	local w_TopStd			= 31
	local w_TopLight		= 32
	local w_DEMO   			= 97
	local w_EMPTY   		= 98
	
]]	

	local widgetPath <const>  		= "/scripts/libUNow/widgets/"
-----------------------------------------
--- list/definition of available widgets
-----------------------------------------
	local widgetList = {
--		indexer] 	=	label/name,			widget Filename, 				mainfunction call,			background call,	maxpage =1, widgetCall ={top1(frame,page,xxx) }},
		[w_SETCURVE]	=	{label="SetCurve",	File="curve.lua", 			mainfunc="setCurve",		bgFunc = nil,			maxpage =1,	active = false,  txt = dofile(widgetPath.."SetCurve/lang.lua"),		index = w_SETCURVE },
		[w_ANNOUNCE]	=	{label="ann",		File="ann.lua", 			mainfunc="announce",		bgFunc = nil,			maxpage =1,	active = false},
--		[w_TELEEL] 		=	{label="teleEl",	File="teleElectro1.lua", 	mainfunc="teleElectro1",							maxpage =3,	active = false},
		[w_TELE01] 		=	{label="Telemetry",	File="telemetry.lua", 		mainfunc="main_telemetry",	bgFunc = nil,			maxpage =3,	active = false,  txt = dofile(widgetPath.."telemetry/lang.lua"),		index = w_TELE01},
--		[w_TELE2] 		=	{label="tele2",		File="tele2.lua", 			mainfunc="tele2",									maxpage =1,	active = false},
		[w_MODELFIND] 	=	{label="Modelfind",	File="modelfind.lua", 		mainfunc="main_MFinder",	bgFunc = "bg_MFinder",	maxpage =1,	active = false,  txt = dofile(widgetPath.."Modelfind/lang.lua"),	index = w_MODELFIND},	
		[w_Picture] 	=	{label="Picture",	File="picture.lua", 		mainfunc="main_Picture",	bgFunc = nil,			maxpage =1,	active = false,  txt = dofile(widgetPath.."picture/lang.lua"),		index = w_Picture},	
		[w_GVAR] 		=	{label="GVar",		File="gvar.lua", 			mainfunc="main_gvar",		bgFunc = nil,			maxpage =1,	active = false,  txt = dofile(widgetPath.."gvar/lang.lua"),			index = w_GVAR},	
		[w_DEMO] 		=	{label="Demo",		File="demo.lua", 			mainfunc="main_demo",		bgFunc = nil,			maxpage =1,	active = false,  txt = dofile(widgetPath.."gvar/lang.lua"),			index = w_GVAR},	

		
		[w_TopFull] 	=	{label="TopBar",	File="topfull.lua", 		mainfunc="topfull",			bgFunc = nil,			maxpage =1,	active = false,  txt = dofile(widgetPath.."topBar/lang.lua"),		index = w_TopFull},	
		[w_TopStd] 		=	{label="TopStd",	File="topStandard.lua",		mainfunc="topstd",			bgFunc = nil,			maxpage =1,	active = false,  txt = dofile(widgetPath.."topBar/lang.lua"),		index = w_TopStd},	
		[w_TopLight] 	=	{label="TopLight",	File="topLight.lua", 		mainfunc="toplight",		bgFunc = nil,			maxpage =1,	active = false,  txt = dofile(widgetPath.."topBar/lang.lua"),		index = w_TopLight},	

		--[w_EMPTY] 	=	{label="EMPTY"}
		[w_EMPTY] 		=	{label="EMPTY",		File="void99.lua", 			mainfunc="void",			bgFunc = nil,			maxpage =1,	active = false,  txt = {{"txt1","txt2"},{"txt3","txt4"}},			index = w_EMPTY}
	}

-------------------------------------
----   widget assignments  ----------
----    "which is where"   ----------
----    1=left   2=right   ----------
-------------------------------------

--[[
	
		[TOPLINE] 		=	widgetList[w_EMPTY],			-- topWidget
	
		[TOP_1] 		=	widgetList[w_SETCURVE],		-- left Frame
		[CENTER_1] 	=	widgetList[w_MODELFIND],
		[BOTTOM_1] 	=	widgetList[w_EMPTY],

		[TOP_2]		=	widgetList[w_EMPTY],			-- right frame
		[CENTER_2] 	=	widgetList[w_EMPTY],	
		[BOTTOM_2] 	=	widgetList[w_EMPTY],	
	

--]]

	return widgetList
end

function defTopBarlist(input,search)

	local apps_template = {										-- list of subwidgets /apps 
		{"---",			98},	
		{"Top full",	30},
		{"Top standard",31},
		{"Top light",	32},
	}
	if widget ~= nil then
		for i = 2,#apps_template do
			if apps_template[i][1] == input then					
				return i
			end
		end
		--print("return 0")
		return 0
	elseif search == "standard" then
		for i = 2, #apps_template do
			if apps_template[i][2] == input then return i end						-- input AppIndex >> return choiceListIndex
		end
	elseif search == "label" then
		for i = 2, #apps_template do
			if apps_template[i][1] == input then return apps_template[i][2] end		-- input AppLabel >> return appIndex	
		end
	else
		if input==nil then				-- request complete array
			return apps_template
		else							-- request  app index
			return apps_template[input][2]
		end
	end

end


function defApplist(input,search,widget)

	local apps_template = {										-- list of subwidgets /apps 
		{"---",98},	
		{"Tele01",4},
		{"Picture",8},
		{"Curve Edit",6},
		{"Model Finder",7},
		{"GVAR",9},
		{"Demo",97},
	}
	
	if widget ~= nil then
		for i = 2,#apps_template do
			if apps_template[i][1] == input then					
				return i
			end
		end
		--print("return 0")
		return 0
	elseif search == "standard" then
		for i = 2, #apps_template do
			if apps_template[i][2] == input then return i end						-- input AppIndex >> return choiceListIndex
		end
	elseif search == "label" then
		for i = 2, #apps_template do
			if apps_template[i][1] == input then return apps_template[i][2] end		-- input AppLabel >> return appIndex	
		end
	else
		if input==nil then				-- request complete array
			return apps_template
		else							-- request  app index
			return apps_template[input][2]
		end
	end
end



function getSubForm(index,txt,lang)												-- only for apps, not used for topBars (no subform)
--print("getsubform called",index,lang)
--print("indizes:  2=pic  3=curve   4=mFind")
--[[
	local w_TOPa  			= 1			-- human readable format
	local w_ANNOUNCE    	= 2
	local w_TELEEL   		= 3
	local w_TELE01   		= 4
	local w_TELE2   		= 5
	local w_SETCURVE		= 6
	local w_MODELFIND		= 7
	local w_Picture			= 8
	local w_GVAR			= 9
--	local w_Top1			= 10		-- no subform
	local w_TopFull			= 30
	local w_TopStd			= 31
	local w_TopLight		= 32
	local w_DEMO   			= 97
	local w_EMPTY   		= 98
	
]]	
	local subFrm= {}

	if index ==w_Picture then
--		print("sample1",txt.conf[1][lang])
--		print("sample2",txt.conf[2][lang])
		subFrm= {		
			{txt.conf[1][lang], 	"createFilePicker",		nil,	"/images/models",			"any",		default="Storm"},
			{txt.conf[2][lang], 	"createFilePicker",		nil,	"/images/background", 		"any",		default="Simmel"		}
			}			
	elseif index == w_SETCURVE then
		subFrm= {
			{txt.conf[1][lang], 	"createCurveChoice",		nil,	1,	 	{{dummy,1},{dummy,2}},	default=1	},	
			{txt.conf[2][lang], 	"createSourceField",		nil,	1,	 	{{dummy,1},{dummy,2}},	default= system.getSource({name="Throttle", category = CATEGORY_ANALOG})	},
			{txt.conf[3][lang],		"createChoiceField",		nil,	1,	 	{{"Pot1",1},{"Pot2",2},{"Pot3",3},{"Pot4",4},{"Slider Left",5},{"Slider Right",6}}	,default=5	},	
			{txt.conf[4][lang],		"createChoiceField",		nil,	1,		{{"SH",1},{"SI",2},{"SJ",3},{"Trim5",4},{"Trim6",5}}			,default=4		},
			{txt.conf[5][lang],		"createSwitchField",		nil,	1,	 	default= system.getSource({member = 5, category = CATEGORY_SWITCH_POSITION})								}	

	
			}
	elseif index == w_MODELFIND then
		subFrm= {	
			{txt.conf[1][lang], 	"createBooleanField",		nil,	true	,default=true	},					-- testmode
			}
	elseif index == w_TELE01  then
		subFrm= {	
			{txt.conf[1][lang], 	"createBooleanField",		nil,	true	,default=true	},																					-- testmode
			{txt.conf[2][lang],		"createChoiceField",		nil,	1,	 	{{"Neuron & oXs",1},{"YGE & oXs",2},{"oXs (GPS)",2},{"G-Rx",2},{"minimal",2}}	,default=1	},		-- choose Sensor set
			}
	elseif index == w_GVAR  then
		subFrm= {	
--			{"TESTmode", 	"createBooleanField",	nil,	true		},					-- testmode		
			{txt.conf[1][lang], 	"createChoiceField",		nil,	1,	 	{{"Std Electro",1},{"Std Glider",2},{"Scale1",3},{"Scale2",4}}	,default=1	},	
			{txt.conf[2][lang],		"createChoiceField",		nil,	1,	 	{{"Pot1",1},{"Pot2",2},{"Slider Left",3},{"Slider Right",4}}	,default=3	},	
			{txt.conf[3][lang],		"createChoiceField",		nil,	1,		{{"SH",1},{"SI",2},{"SJ",3},{"Trim5",4},{"Trim6",5}}			,default=4	},
			{txt.conf[4][lang],		"createSwitchField",		nil,	1,	 	default= system.getSource({member = 5, category = CATEGORY_SWITCH_POSITION})}
			}
	elseif index == w_DEMO  then
		subFrm= {	
			{"Demo Test Bool", 		"createBooleanField",		nil,	true,												default=true	},																					-- testmode
			{"Demo you've choice:",	"createChoiceField",		nil,	1,	 	{{"good",1},{"OK",2},{"very Good",3}},		default=1		},												-- choice selection
			}
	elseif index == w_TopFull  then
		subFrm= {	
			{"Status1, LSW:", 								"createLswChoice",			nil,	1,		{{dummy,1},},								default= system.getSource({category=CATEGORY_LOGIC_SWITCH, name ="flaperon"})	},																					-- testmode
--			{"Status1, LSW:", 							"createSourceField",		nil,	1,		{{dummy,1},{dummy,2}},						default= system.getSource({category=CATEGORY_LOGIC_SWITCH, name ="flaperon"})	},																					-- testmode
			{"Status1, label",								"createTextField",			nil,	1,	 												default="flperon"	},											
			{"Status2, LSW:", 								"createSourceField",		nil,	1,		{{dummy,1},},								default= system.getSource({category=CATEGORY_LOGIC_SWITCH, name ="snapflp"})	},																						-- testmode
			{"Status2, label",								"createTextField",			nil,	1,	 												default="snpflap"	},	
			{"Motor Safety ..status \"safe\", LSW:",		"createLswChoice",			nil,	1,		{{dummy,1},},								default= system.getSource({category=CATEGORY_LOGIC_SWITCH, name ="Safe Mstr"})	},																						-- testmode
			{"               ..status \"pre-engaged\", LSW:","createLswChoice",			nil,	1,		{{dummy,1},},								default= system.getSource({category=CATEGORY_LOGIC_SWITCH, name ="Mot Warning"})	},																						-- testmode
			{"               ..status \"running\", LSW:",	"createLswChoice",			nil,	1,		{{dummy,1},},								default= system.getSource({category=CATEGORY_LOGIC_SWITCH, name ="Motor running"})	},																						-- testmode
			

			}
	elseif index == w_TopStd  then
		subFrm= {	
			{"TimerA select", 		 						"createChoiceField",		nil,	1,	 	{{"Timer 1",1},{"Timer 2",2},{"Timer3",3}},	default=1			},																					-- testmode
			{"TimerA, label (max 4Chars)",					"createTextField",			nil,	1,	 												default="Flgt"		},	
			{"TimerB select", 		 						"createChoiceField",		nil,	1,	 	{{"Timer 1",1},{"Timer 2",2},{"Timer3",3}},	default=2			},				
			{"TimerB, label (max 4Chars)",					"createTextField",			nil,	1,	 												default="Mot"		},	
			}
	else
		subFrm= {nil,"dummy",nil,nil,nil,nil}																																	-- no subforms
	
	end

	return subFrm


end


function defineSuite_Layout(display)


	local layoutSettings = {}
	
	layoutSettings [1]= {
																			-- X20
		["type"] 		=	"X20",															
	--sizings
		["width01"] 	=	12,				-- topbar rectangles 1 (status snapflap ...)
		["width02"] 	=	12,				-- topbar rectangles 2 (safety)	
		["topIconW"]	= 	10,					-- scaling imgages in TopBar (percent of screen)
		["topIconH"]	= 	95,
	-- offsets
		["offTele1"]	= 	26,					-- offset icons <-> telemetry values
	-- placements
		["topX1"] 		= 	01,					-- x-coordinates for TopBar sub-widgets (percent of displ width)
		["topX2"] 		= 	18,
		["topX3"] 		= 	28,
		["topX4"] 		= 	40,						-- name
		["topX5"] 		= 	50,						-- bat
		["topX6"]		= 	70,						-- vfr
		
	-- button specific
		["butLine1"] 	= 	19,	
		["butHeight"] 	= 	15,	
		
	-- offsets
		["yOffset"]	= 	0.36,						-- y placement QR
	}
	
	layoutSettings [2]= {													-- X18
		["type"] 		=	"X18",	
	--sizings
		["width01"] 	=	13,					-- topbar rectangles 1 (status snapflap ...)
		["width02"] 	=	13,					-- topbar rectangles 2 (safety)
		["topIconW"]	= 	10,					-- scaling imgages in TopBar (percent of screen)
		["topIconH"]	= 	95,
	-- offsets
		["offTele1"] 	= 	30,					-- offset icons <-> telemetry values
	-- placements
		["topX1"] 		= 	00,					-- x-coordinates for TopBar sub-widgets (percent of displ width)
		["topX2"] 		= 	15,
		["topX3"] 		= 	29,
		["topX4"] 		= 	35,					-- name
		["topX5"]		= 	56,					-- batt
		["topX6"]		= 	82,					-- rssi
		
		-- button specific
		["butLine1"] 	= 	18,	
		["butHeight"] 	= 	14,	
		
	-- offsets
		["yOffset"]	= 	0.36,						-- y placement QR
		--lines
		["line1"] 		= 	02,					-- x-coordinates for TopBar sub-widgets (percent of displ width)
		["line2"] 		= 	9,
		["lastline"] 	= 	94,
		-- tabs
		["tab0"] 		= 	03,
		["tab1"] 		= 	36,
		["tab2"] 		= 	52,
		["tab3"] 		= 	77,		
		["right2"] 		= 	99,
	}
	
	layoutSettings [3]= {														-- Horus	
		["type"] 		=	"HORUS",	
	--sizings
		["width01"] 	=	11,					-- topbar rectangles 1 (status snapflap ...)
		["width02"] 	=	11,					-- topbar rectangles 2 (safety)		
		["topIconW"]	= 	10,					-- scaling imgages in TopBar (percent of screen)
		["topIconH"]	= 	115,
	-- offsets
		["offTele1"]	 = 	30,					-- offset icons <-> telemetry values
	-- placements
		["topX1"] 		= 	01,					-- x-coordinates for TopBar sub-widgets (percent of displ width)
		["topX2"] 		= 	18,
		["topX3"] 		= 	32,
		["topX4"] 		= 	54,
		["topX5"]		= 	84,
		["topX6"]		= 	85,
		
		-- button specific
		["butLine1"] 	= 	18,	
		["butHeight"] 	= 	14,	
		
	-- offsets
		["yOffset"]	= 	0.36,						-- y placement QR
		-- tabs
		["tab0"] 		= 	03,		
		["tab1"] 		= 	40,
		["tab2"] 		= 	52,
		["tab3"] 		= 	77,		
		["right2"] 		= 	99,
	}
		print("**** LAYOUT returned:",display)
	return(layoutSettings [display])

end


-- ************************************************
-- ***    	returns frame&topbar  size paras	***
-- ***		  	depends on suite mode  			***
-- ************************************************
function getFrameSizing(WIDGET_MODE,TOPBAR_WID,Dual_WID)		
	local topBarHeight, blank, widgetHeight, widgetWidth
			
	if 		WIDGET_MODE == TOPBAR_WID then		-- dual frame & individual topbar
				topBarHeight 	= 0.1
				blank 			= 0.05
				widgetHeight 	= 1-blank-topBarHeight
				widgetWidth		= 0.485	
	
	elseif	WIDGET_MODE == Dual_WID then		-- dual frame & Ethos topBar
				topBarHeight 	= 0
				blank 			= 0.0
				widgetHeight 	= 1				-- 1 = 100%
				widgetWidth		= 0.485		
	
	else										-- single frame	
				topBarHeight 	= 0
				blank 			= 0
				widgetHeight 	= 1				-- 1 = 100%
				widgetWidth		= 1
	
	end

	return topBarHeight, blank, widgetHeight, widgetWidth
end

