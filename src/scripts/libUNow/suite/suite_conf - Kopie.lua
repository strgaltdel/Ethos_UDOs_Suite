-- ********      how to add an app    *********
-- (1) extend local w_XYZ index		;suite1conf(), create index label & corresp. index
-- (2) extend widgetList			;suite1conf(), use former created index label
-- (3) extend "apps_template"  		;defApplist(), pairing choice list entry & index number
-- (3) extend subFrm  				;getSubForm(), add index label like step (1) and create subform entries

local NIL <const> = 1
local PICTURE <const> = 2
local CurveEDIT <const> = 3
local ModelFINDER <const> = 4
local Tele01 <const> = 5


function getWidgetPath()
	return("/scripts/libUnow/")
end

--local function modelAnn()
function conf_EMPTY()
	widgetconfLine["EMPTY"]="EMPTY"			-- dummy config for empty widget slots
end	



-- function tool1conf()
function suite1conf()

	local w_TOPa  			= 1			-- human readable format
	local w_ANNOUNCE    	= 2
	local w_TELEEL   		= 3
	local w_TELE01   		= 4
	local w_TELE2   		= 5
	local w_SETCURVE		= 6
	local w_MODELFIND		= 7
	local w_Picture			= 8
	local w_GVAR			= 9
	local w_EMPTY   		= 99

	local widgetPath <const>  		= "/scripts/libUNow/widgets/"
-----------------------------------------
--- list/definition of available widgets
-----------------------------------------
	local widgetList = {
--		indexer] 	=	label/name,			widget Filename, 				mainfunction call,				maxpage =1, widgetCall ={top1(frame,page,xxx) }},
		[w_SETCURVE]	=	{label="SetCurve",	File="curve.lua", 			mainfunc="setCurve",		maxpage =1,	active = false,  txt = dofile(widgetPath.."SetCurve/lang.lua"),		index = w_SETCURVE },
		[w_ANNOUNCE]	=	{label="ann",		File="ann.lua", 			mainfunc="announce",		maxpage =1,	active = false},
		[w_TELEEL] 		=	{label="teleEl",	File="teleElectro1.lua", 	mainfunc="teleElectro1",	maxpage =3,	active = false},
		[w_TELE01] 		=	{label="tele01",	File="tele01.lua", 			mainfunc="tele01",			maxpage =3,	active = false,  txt = dofile(widgetPath.."tele01/lang.lua"),		index = w_TELE01},
		[w_TELE2] 		=	{label="tele2",		File="tele2.lua", 			mainfunc="tele2",			maxpage =1,	active = false},
		[w_MODELFIND] 	=	{label="Modelfind",	File="modelfind.lua", 		mainfunc="main_MFinder",	maxpage =1,	active = false,  txt = dofile(widgetPath.."Modelfind/lang.lua"),	index = w_MODELFIND},	
		[w_Picture] 	=	{label="Picture",	File="picture1.lua", 		mainfunc="main_Picture1",	maxpage =1,	active = false,  txt = dofile(widgetPath.."picture1/lang.lua"),		index = w_Picture},	
		[w_GVAR] 		=	{label="GVar",		File="gvar.lua", 			mainfunc="main_gvar",		maxpage =1,	active = false,  txt = dofile(widgetPath.."gvar/lang.lua"),			index = w_GVAR},	

		--[w_EMPTY] 	=	{label="EMPTY"}
		[w_EMPTY] 		=	{label="EMPTY",		File="void.lua", 			mainfunc="void",			maxpage =1,}
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



function defApplist(index,revers)
	local apps_template = {										-- list of subwidgets /apps 
		{"---",99},	
		{"Picture",8},
		{"Curve Edit",6},
		{"Model Finder",7},
		{"GVAR",9},
		{"Tele01",4}
	}
	if revers then
		for i = 2, #apps_template do
			if apps_template[i][2] == index then return apps_template[i][1] end		
		end
	else
		if index==nil then				-- request complete array
			return apps_template
		else							-- request  app index
			return apps_template[index][2]
		end
	end
end



function getSubForm(index,txt,lang)
--print("getsubform called",index,lang)
--print("indizes:  2=pic  3=curve   4=mFind")
	local w_TOPa  			= 1			-- human readable format
	local w_ANNOUNCE    	= 2
	local w_TELEEL   		= 3
	local w_TELE01   		= 4
	local w_TELE2   		= 5
	local w_SETCURVE		= 6
	local w_MODELFIND		= 7
	local w_Picture			= 8
	local w_GVAR			= 9
	local w_EMPTY   		= 99
	
	
	local subFrm= {}

	if index ==w_Picture then
--		print("sample1",txt.conf[1][lang])
--		print("sample2",txt.conf[2][lang])
		subFrm= {		
			{txt.conf[1][lang], 	"createFilePicker",		nil,	"/images"			, "any"		,default="blanko.png"},
			{txt.conf[2][lang], 	"createFilePicker",		nil,	"/images/background", "any"		,default="blanko.png"		}
			}			
	elseif index == w_SETCURVE then
		subFrm= {
			{txt.conf[1][lang], 	"createCurveChoice",		nil,	1,	 	{{dummy,1},{dummy,2}},	default="C1"	},	
			{txt.conf[2][lang], 	"createSourceField",		nil,	1,	 	{{dummy,1},{dummy,2}},	default=60	},
			{txt.conf[3][lang],		"createChoiceField",		nil,	1,	 	{{"Pot1",1},{"Pot2",2},{"Pot3",3},{"Pot4",4},{"Slider Left",5},{"Slider Right",6}}	,default=1	},	
			{txt.conf[4][lang],		"createChoiceField",		nil,	1,		{{"SH",1},{"SI",2},{"SJ",3},{"Trim5",4},{"Trim6",5}}			,default=1		},
			{txt.conf[5][lang],		"createSwitchField",		nil,	1,	 										}	

	
			}
	elseif index == w_MODELFIND then
		subFrm= {	
--			{"TESTmode", 	"createBooleanField",	nil,	true		},					-- testmode		
			{txt.conf[1][lang], 	"createBooleanField",	nil,	true	,default=false	},					-- testmode
			}
	elseif index == w_TELE01  then
		subFrm= {	
--			{"TESTmode", 	"createBooleanField",	nil,	true		},					-- testmode		
--			{"TESTmode", 	"createBooleanField",	nil,	true		},					-- testmode		
			{txt.conf[1][lang], 	"createBooleanField",	nil,	true	,default=false	},															-- testmode
			{txt.conf[2][lang],		"createChoiceField",	nil,	1,	 	{{"Neuron & oXs",1},{"YGE & oXs",2},{"oXs (GPS)",2},{"G-Rx",2},{"minimal",2}}	,default=1	},		-- choose Sensor set
			}
	elseif index == w_GVAR  then
		subFrm= {	
--			{"TESTmode", 	"createBooleanField",	nil,	true		},					-- testmode		
			{txt.conf[1][lang], 	"createChoiceField",		nil,	1,	 	{{"Std Electro",1},{"Std Glider",2},{"Scale1",3},{"Scale2",4}}	,default=1	},	
			{txt.conf[2][lang],		"createChoiceField",		nil,	1,	 	{{"Pot1",1},{"Pot2",2},{"Slider Left",3},{"Slider Right",4}}	,default=1	},	
			{txt.conf[3][lang],		"createChoiceField",		nil,	1,		{{"SH",1},{"SI",2},{"SJ",3},{"Trim5",4},{"Trim6",5}}			,default=1	},
			{txt.conf[4][lang],		"createSwitchField",		nil,	1,	 	}
			}
	end

	return subFrm


end


