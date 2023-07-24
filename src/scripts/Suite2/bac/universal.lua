
-- to do
-- splash screen

-- tele01
-- topbar
-- announce 
-- gv
-- hud



--[[ how to add widget:

(1) load lua file in section "load "widgets / functions" "
		loaded_chunk = assert(loadfile("/scripts/libUnow/tele1.lua"))
		loaded_chunk()
		
(2) assign widget to frame in section "assign all available widgets to corresponding frames"
			[TOP_1] 	= {func = function(frame,page) tele1(frame,page) 		end, maxpage = 1} >> TOP= first widget (TOP,CENTER,BOTTOM) _1=LEFT Frame (_2=right frame); or choose "TOPLINE" for header

(3) in case widget should be shown by start >> assign in section "assign start condition "
			local startwidgetL = TOP_1			-- L = left frame

-- done

 ]]

demoMode  = true

tmptmp = 0

debug1 		= false			-- monitor create
--local debug2 <const> 		= false			-- monitor paint
debug2  	= true			-- monitor paint
debug3  	= true			-- monitor event handler
debug4 	= false			-- sport timeout
debug5  	= true			-- sport request 
debug6 	= true			-- handler
debug7 	= true			-- print demoMode


layoutSet = {}
widgetconfLine= {}
widgetconfArray= {}


-- globals:
-- handler (don't change)
TOPLINE		= 99			-- (no handler neccessary)
LEFT_1   		= 1
TOP_1  		= 11
CENTER_1  	= 21
BOTTOM_1 	= 31
RIGHT_1  	= 2

LEFT_2   		= 3
TOP_2  		= 41
CENTER_2 	= 51
BOTTOM_2  	= 61
RIGHT_2  	= 4

-- display handler
DISP_X20  	= 1
DISP_X18  	= 2
DISP_HORUS	= 3




-- seq. list of widget handler (needed for loops)
local widArray = {TOPLINE, TOP_1,CENTER_1 ,BOTTOM_1,TOP_2,CENTER_2 ,BOTTOM_2 }
local numWidgets = 7				--number of widgets

-- some bitmap vars:
local topBackground
local batOK_bmp, batWarn_bmp, batAlarm_bmp



local handler = 0

local txtFields,optionLan,header = dofile("uni_lang.lua")		-- get language file

function round(val,dec)
  local mult = 10^(dec or 0)
  return math.floor(val * mult + 0.5) / mult
end
	


																			-- ************************************************
																			-- ***		     name widget					*** 
																			-- ************************************************
local translations = {en="universal"}

local function name(widget)					-- name script
  local locale = system.getLocale()
	 return translations[locale] or translations["en"]
end


																		-- ************************************************
																			-- ***		     yaapus getime workaround		*** 
																			-- ************************************************
function getTime()
  return os.clock()		 
end

																			-- ************************************************
																			-- ***		     write configs into file	*** 
																			-- ************************************************
function writeConfNew(data,dataname)
	local path = "/scripts/libUnow/data/"
	local filename = path..model.name().."_"..dataname
	
	local numData = #data

	if numData >0 then
		file = io.open(filename , "w")
		local tmpData = data[1].."\r\n"
		if numData >1 then
			for i=2,numData do
				tmpData = tmpData..data[i].."\r\n"
			end
		io.write(file,tmpData)
		io.close(file)
		print(tmpData)
		end
	else
		print("no data to write in File")
	end

end			

																			-- ************************************************
																			-- ***		     form value-functions			*** 
																			-- ************************************************
local function getValue(parameter)
  if parameter[4] == nil then
    return parameter[4]		--default
  else
    return parameter[3]
  end
end

local function setValue(parameter, value)
  parameter[3] = value
end

																			-- ************************************************
																			-- ***		    create new form line   			*** 
																		-- ***         return new "field line"			***
																			-- ************************************************
															
local function createNumberField(line, parameter)
  local field = form.addNumberField(line, nil, parameter[5], parameter[6], function() return getValue(parameter) end, function(value) setValue(parameter, value) end)
	return field
end

																			-- ************************************************
																			-- ***		  create bool formline				*** 
																			-- ************************************************
local function createBooleanField(line, parameter)
  local field = form.addBooleanField(line, nil, function() return getValue(parameter) end, function(value) setValue(parameter, value) end)
	return field
end

local function createChoiceField(line, parameter)
   local field = form.addChoiceField(line, nil, parameter[5], function() return getValue(parameter) end, function(value) setValue(parameter, value) end)
	return field
end




local function createTextButton(line, parameter)
  local field = form.addTextButton(line, nil, parameter[4], function() return setValue(parameter,0) end)
  return field
end



local function createTextOnly(line, parameter)
  local field = form.addStaticText(line, nil, parameter[3])
  return field
end


local function resetEvnt(widget)
		widget.evnt.wheelup = false
		widget.evnt.wheeldwn= false
		if  widget.touch.editActiveSince ~= nil and getTime() - widget.touch.editActiveSince > 5 then
			widget.touch.X=nil
			widget.touch.Y=nil
		end
end



																			-- ************************************************
																			-- ***		     read sub-config widgets		*** 
																			-- ***without function /only callable from conf ***
																			-- ***	workaround: filelib						*** 
																			-- ************************************************

local function readSubConf(widget)

	local strg=""
	local tmp
	for index = 1,7 do												-- read sub-widget conf lines
		item="subconf"..tostring(index)								-- built config "label"
		tmp = storage.read(widgetconfArray[index])					-- read config string
		if tmp ~= nil then
			if string.sub(s, 1, 1) == "!" then
				widget.conf[item]= tmp									-- use stored data
			else	
				widget.conf[item]=widgetconfArray[index]				-- use standard sub widget data
			end
		else
			storage.write(item,widgetconfArray[index])
		end
		print("confRead",strg,widget.conf[strg])
	end

end

																			-- ************************************************
																			-- ***		     read widget config 	   		*** 
																			-- ************************************************
local function read(widget)


														-- on/off Stat items
	for index = 1,widget.numItems do
		widget.conf[index][3] = storage.read(widget.conf[index][1])
	end
													-- you want to know number of items to be displayed !	
end







																			-- ************************************************
																			-- ***		    startup (onetime) handler		*** 
																			-- ***	         returns widget vars			*** 
																			-- ************************************************
local function create()

	---------------------------
	---- load standard libs --- 
	---------------------------
			
	loaded_chunk = assert(loadfile("/scripts/universal/uni_conf.lua"))
	loaded_chunk()

	
	
	loaded_chunk = assert(loadfile("/scripts/libUnow/lib_standards.lua"))
	loaded_chunk()
		

	loaded_chunk = assert(loadfile("/scripts/libUnow/lib_relative_draw.lua"))			-- functions for "relative draw"
	loaded_chunk()																	-- use of percent values instead of absolut pixels
																					-- so x,y : 100,100 would be right down corner of a frame
	
	loaded_chunk = assert(loadfile("/scripts/libUnow/lib_getTele.lua"))					-- functions for "..."
	loaded_chunk()	

	
	loaded_chunk = assert(loadfile("/scripts/libUnow/lib_drawIcons.lua"))
	loaded_chunk()
		
		
	sensors = defineSensors()
	
	uniconf()			-- activate config
	local wpath = getWidgetPath()
	
	local numitems = 0																-- number of form items
	fields = {}																		-- form fields


	
	local 	w,h		= nil
	local	topbarH = nil										-- height topbar
	local	spaceY  = nil										-- space between topbar / widgets
	local	spaceX	= nil										-- space between widgets
	local	wigdetH = nil										-- height widgets
	local	margin  = nil										-- left/right margin
	local	widgetW = nil										-- widget widht
	local 	display = X20										-- display type
	
	local apps_template = {										-- not needed until direct calls/loads
		{"Telemetry sustainer",	"app.lua"},
		{"Telemetry general",	"app.lua"},
		{"Announcements",		"app.lua"},
		{"GV settings",			"app.lua"},
		{"HUD",					"app.lua"},
	}
	
	local apps = {}
	for i= 1,#apps_template do
		apps[i] =  {apps_template[i][1],i}
	end
	
	local conf = {				
		--{"App LEFT 01", 	createChoiceField,		nil,	1,		{{apps[1][1], 1}, {apps[2][1], 2}, {apps[3][1], 3},  {apps[4][1], 4}}	},
		{"App LEFT 01", 	createChoiceField,		nil,	1,		apps	},
		{"App LEFT 02", 	createChoiceField,		nil,	1,		apps	},	
		{"App LEFT 03", 	createChoiceField,		nil,	1,		apps	},	
		{"App RIGHT 01", 	createChoiceField,		nil,	1,		apps	},	
		{"App RIGHT 02", 	createChoiceField,		nil,	1,		apps	},	
		{"App RIGHT 03", 	createChoiceField,		nil,	1,		apps	},	
		
		{"bool", 	createBooleanField,				nil,	true				},	
		{"number", 	createNumberField,				nil,	11,		5, 40,10	},	
		{"Button", 	createTextButton,				nil,	"press"				},
		{"Text", 	createTextOnly,							"Hello"						}		
	}
	
	local maxpage = {}
	--[[
	maxpage[TELE_1] = 1
	maxpage[21] = 1
	maxpage[DEMO_1] = 1
	maxpage[51] = 1
	maxpage[61] = 1
	maxpage[71] = 1
	]]
	
	
	local actualWidget ={}
	local touch	= {}							-- widget touch data
	local evnt 	= {}							-- widget event data
		evnt.wheeldwn 	= false
		evnt.wheelup 	= false
	local param = {}
	local theme = {}
	
	local status = {						-- ??? really needed ?
		top = 1,
		left = 11,
		right = 21
		}
		

	local numItems = #conf-2
	local confWrite = true
		
  return{	numItems=numItems, conf=conf, status=status, actualWidget=actualWidget, touch=touch, evnt=evnt, maxpage=maxpage, confWrite=confWrite,
			w=nil, h=nil, topbarH=nil, spaceY=nil, spaceX=nil, wigdetH=nil, margin=nil, widgetW =nil, configured = false, theme=theme, display = display , param = param, wpath=wpath}
end



-- run once at first paint loop :

local function frontendConfigure(widget)

-- **********************************************    general layout    ******************************


		widget.w, widget.h = lcd.getWindowSize()
																						-- rough screen layout:
																						
																						
		widget.topbarH 	= math.floor(widget.h *0.11)										-- height topbar
		widget.spaceY  	= math.floor(widget.h*0.03)										-- space between topbar / widgets
		widget.spaceX	= math.floor(widget.w*0.02)										-- space between widgets
		widget.wigdetH 	= widget.h - widget.spaceY - widget.topbarH						-- height widgets
		widget.margin  	= math.floor(widget.w*0.01)										-- left/right margin
		widget.widgetW 	= math.floor((widget.w - widget.spaceX - 2*widget.margin)/2)	-- widget widht

		frameTop = {																	-- frame layouts
			name= "top",																-- name
			x = 0,																		-- x-position
			y = 4,																		-- y-position (percent)
			w = widget.w,																-- width
			h = widget.topbarH															-- heigh
			}
			
		frameLeft = {
			name= "left",		
			x = widget.margin,
			y = widget.topbarH + widget.spaceY,
			w = widget.widgetW,
			h = widget.wigdetH
			}
			
		frameRight = {
			name = "right",
			x = widget.margin  + widget.spaceX + widget.widgetW,
			y = widget.topbarH + widget.spaceY,
			w = widget.widgetW	,	
			h = widget.wigdetH
			}

			

-- **********************************************    load basics    ******************************

		loaded_chunk = assert(loadfile("/scripts/libUnow/conf_displaySets.lua"))		-- evaluate tx type and set font size etc..
		loaded_chunk()
		
		loaded_chunk = assert(loadfile("/scripts/universal/uni_display.lua"))			-- special widget layout parameters , x/display dependent
		loaded_chunk()
		
		loaded_chunk = assert(loadfile("/scripts/universal/uni_lang.lua"))				-- language file
		loaded_chunk()
		
		loaded_chunk = assert(loadfile("/scripts/universal/uni_theme.lua"))				-- color schemes
		loaded_chunk()

		
	widget.theme=initLang()
	widget.theme=initTheme()
-- load configured widgets (configuration in file "uni_conf"):

	for i=1,numWidgets do
	--print("wid",i,widgetAssignment[widArray[i]].label)
	--print("wid",i)
		if  widgetAssignment[widArray[i]].label ~= "EMPTY" then
			loaded_chunk = assert(loadfile(widget.wpath.. widgetAssignment[widArray[i]].File ))
			loaded_chunk()
			print("libload",widget.wpath.. widgetAssignment[widArray[i]].File )
		end
	end

-- define sub-widget specific config line:	
	for i=1,numWidgets do
		--print(i,widgetAssignment[widArray[i]].label)
		local configWidgetCall="conf_".. widgetAssignment[widArray[i]].label		-- call widget dependent function to get config string
		_G[configWidgetCall]()

		print(i,widgetconfLine[widgetAssignment[widArray[i]].label])
	end
	

	
	--[[
--	local function setWidgetConfLines()
	widgetconfArray[1] = widgetconfLine[TOPLINE.label]
	widgetconfArray[2] = widgetconfLine[TOP_1.label]
	widgetconfArray[3] = widgetconfLine[CENTER_1.label]
	widgetconfArray[4] = widgetconfLine[BOTTOM_1.label]
	widgetconfArray[5] = widgetconfLine[TOP_2.label]
	widgetconfArray[6] = widgetconfLine[CENTER_2.label]
	widgetconfArray[7] = widgetconfLine[BOTTOM_2.label]
]]

-- set sub-widget dependent conf lines
--	setWidgetConfLines()	-- get standard sub-widget settings

	--readSubConf(widget)
		
-- *******************************    evaluate display specific settings   ***************************	
	
	widget.display 	= evaluate_display()
	widget.layout	= defineLayout(widget.display)
	txtSize = {}
	txtSize.Xsml, txtSize.sml, txtSize.std, txtSize.big = defineTeleSize(widget.display)


 widget.touch.X = nil
 widget.touch.Y = nil
	
-- *******************************    assign all selected widgets to corresponding frames (top,left,right) incl.parameters   ***************************

			-- frame		default							functionCall(arguments,see "call frame dependent widgets " below)				
		layout = {
--			[TOPLINE]		= {func = function(frame,page) 	top1(frame,page,widget.layout) 			end, maxpage = 1},				-- example how to call widget "direct")
			[TOPLINE]	=  {func = function(frame,page)	widget.param= _G[widgetAssignment[TOPLINE].mainfunc](frame,page,widget.layout,widget.theme,widget.touch,widget.param)	end, maxpage = widgetAssignment[TOPLINE].maxpage},		-- call widget specific function from global namespace  
			
--			[TOP_1] 		= {func = function(frame,page) 	announce(frame,page,widget.layout) 		end, maxpage = 1},				--  [*_1] = frame-left: list of "widgets"
			[TOP_1] 		= {func = function(frame,page)	_G[widgetAssignment[TOP_1].mainfunc](frame,page,widget.layout,widget.theme,widget.touch,widget.evnt,widget)		end, maxpage = widgetAssignment[TOP_1].maxpage},
			[CENTER_1]	= {func = function(frame,page)	_G[widgetAssignment[CENTER_1].mainfunc](frame,page,widget.layout,widget.theme,widget.touch,widget)	end, maxpage = widgetAssignment[CENTER_1].maxpage},
			[BOTTOM_1]	= {func = function(frame,page)	_G[widgetAssignment[BOTTOM_1].mainfunc](frame,page,widget.layout,widget.theme,widget.touch,widget)	end, maxpage = widgetAssignment[BOTTOM_1].maxpage},
			
			[TOP_2]		= {func = function(frame,page)	_G[widgetAssignment[TOP_2].mainfunc](frame,page,widget.layout,widget.theme,widget.touch,widget)		end, maxpage = widgetAssignment[TOP_2].maxpage},				--  [*_2] = frame-right:  list of "widgets"
			[CENTER_2]	= {func = function(frame,page)	_G[widgetAssignment[CENTER_2].mainfunc](frame,page,widget.layout,widget.theme,widget.touch,widget)	end, maxpage = widgetAssignment[CENTER_2].maxpage},
			[BOTTOM_2]	= {func = function(frame,page)	_G[widgetAssignment[BOTTOM_2].mainfunc](frame,page,widget.layout,widget.theme,widget.touch,widget)	end, maxpage = widgetAssignment[BOTTOM_2].maxpage}
			}

print("frontendconf touchX",widget.touch.X)
	
-- ******* assign start condition 

	local startwidgetT = TOPLINE			-- top (static)
	local startwidgetL = TOP_1			-- left
	local startwidgetR = TOP_2			-- right
	
	
-- ******** definition of actual widgets on start (top, left right):
	widget.actualWidget["top"] 		= {typ=startwidgetT , page = 1, 	maxpage = 1 }									-- (static)
	widget.actualWidget["left"] 		= {typ=startwidgetL , page = 1, 	maxpage = layout[startwidgetL ].maxpage }
	widget.actualWidget["right"]	= {typ=startwidgetR , page = 1,	maxpage = layout[startwidgetR ].maxpage}		
		

	return(true)

end


local function getTelemetryValues()


	return
end


																			-- ***********************************************************************************
																			-- ****************************   call frame dependent widgets   *********************
																			-- ***********************************************************************************


local function w_top(widget)
	if layout[widget.actualWidget.top.typ] then													-- call top widget
		layout[widget.actualWidget.top.typ].func(frameTop,widget.actualWidget.top.page)		
	end

end

-- handle actual left widget

local function w_left(widget)
	if layout[widget.actualWidget.left.typ] then												-- typ=startwidgetL , page = 1, maxpage = layout[startwidgetL ].maxpage
		layout[widget.actualWidget.left.typ].func(frameLeft,widget.actualWidget.left.page)		-- func = function(frame,page)  		end, maxpage = 1
	end
end

-- handle actual right widget

local function w_right(widget)
	if  layout[widget.actualWidget.right.typ] then
		layout[widget.actualWidget.right.typ].func(frameRight,widget.actualWidget.right.page)
	end
--			tele2(widget)
end


																			-- ************************************************
																			-- ***		     "display handler"					*** 
																			-- ************************************************
local function paint(widget)

	
	if not(widget.configured) then											-- one time config; cant be executed during create cause window size not availabe then
		widget.configured = frontendConfigure(widget)
	end
	
	
	---  paint Background

		lcd.color(widget.theme.c_backgrAll)
		lcd.drawFilledRectangle(0,0,widget.w,widget.h)
		
	-- main calls:	
		w_left(widget)
		w_right(widget)
		w_top(widget)

		
		resetEvnt(widget)				-- delete event stati not needed

end




																			-- ************************************************
																			-- ***		     configure widget				*** 
																			-- ************************************************
local function configure(widget)

	local parameter ={}	
	for index = 1, #widget.conf do
		
		parameter = widget.conf[index]
		line = form.addLine(parameter[1])			
		local field = parameter[2](line, parameter)
		fields[#fields + 1] = field		
		
	end

	
	
end

																			-- ************************************************
																			-- ***		     "background loop"				*** 
																			-- ************************************************

local function wakeup(widget)
--[[
	local a = {}
	a = model.id()
	print("UID",a[1],a[2])
	
	local xx
	widget.source = system.getSource({name = "CH30"})
	local sValue = widget.source:value()
--	a.source= system.getSource({category=CATEGORY_LOGIC_SWITCH, member =1})
	if sValue >100 then
		widget.source:value(-100)
		print("--------------", widget.source:value())
	
	else
		widget.source:value(100)
		print("--------------", widget.source:value())
	end

	--]]
--	local source= system.getSource({category=CATEGORY_LOGIC_SWITCH, name="LSW2"})
--	print("--------------", source.value())
	-- browse page left/right:
	
	if handler > 0 then 
		if handler == LEFT_1 then															-- frame1 left: page -1
			widget.actualWidget.left.page = widget.actualWidget.left.page - 1
			if widget.actualWidget.left.page < 1  then
				widget.actualWidget.left.page =  widget.actualWidget.left.maxpage
			end
			print(widget.actualWidget.left.typ,widget.actualWidget.left.page)
			
		elseif handler == RIGHT_1 then														-- frame1 right: page +1
			widget.actualWidget.left.page = widget.actualWidget.left.page + 1
			if widget.actualWidget.left.page > widget.actualWidget.left.maxpage then
				widget.actualWidget.left.page = 1
			end
			print(widget.actualWidget.left.typ,widget.actualWidget.left.page)	
		elseif handler == LEFT_2 then														-- frame2 left: page -1
			widget.actualWidget.right.page = widget.actualWidget.right.page - 1
			if widget.actualWidget.right.page < 1  then
				widget.actualWidget.right.page =  widget.actualWidget.right.maxpage
			end
			print(widget.actualWidget.right.typ,widget.actualWidget.right.page)
		elseif handler == RIGHT_2 then														-- frame2 right: page +1
			widget.actualWidget.right.page = widget.actualWidget.right.page + 1
			if widget.actualWidget.right.page > widget.actualWidget.right.maxpage then
				widget.actualWidget.right.page = 1
			end
			print(widget.actualWidget.right.typ,widget.actualWidget.right.page)			
		end
		print("   handler:",handler) 
	end
	handler =  0												-- reset handler
	
	
	tele = getTelemetryValues()
	

	--read(widget)
	lcd.invalidate()
	

	-- write new config if changed 
	if  widget.configured and widget.confWrite then									-- write sub widget configs 
		local item=""
		local dataX ={}
	
		for index = 1,7 do																-- write one config line for every sub widget
			item ="subconf"..tostring(index)												-- built config "item"
			dataX[index]=  widgetconfLine[widgetAssignment[widArray[index]].label]		-- get data/config string
			-- print("confWrite",item,dataX[index],widgetAssignment[widArray[index]].label)
		end
	
		writeConfNew(dataX,"test.txt")												-- write complete data block
		widget.confWrite  = false														-- unflag
	end	
end



local function menu(widget)					-- pess long Enter
	--[[
    return {
        {"Test",
         function()
		
		
	end
         end},
    }
	]]
end


																			-- ************************************************
																			-- ***		     write widget config 	   		*** 
																			-- ************************************************
local function write(widget)

	local item=""
	local data
	for index = 1,7 do														-- write sub-widget conf lines
		item ="subconf"..tostring(index)										-- built config "item"
		data =  widgetconfLine[widgetAssignment[widArray[index]].label]		-- get data/config string
		storage.write(item,data)											-- write config string

		print("confWrite",item,data)
	end
	
	

	for index = 1,widget.numItems do
		print("write",widget.conf[index][1], widget.conf[index][3])
		storage.write(widget.conf[index][1], widget.conf[index][3])
	end

end

																			-- ************************************************
																			-- ***		     monitor events		 	   		*** 
																			-- ************************************************
local function event(widget, category, value, x, y)

	
	if debug3 then print("Event received:", category, value, x, y) end	
	--print("Evt key", EVT_KEY)
	--print("Evt rot ets", ROTARY_LEFT,ROTARY_RIGHT,KEY_ENTER_BREAK,KEY_ENTER_FIRST)
	--print("Evt touch", EVT_TOUCH )
	if category == 0 and value == ROTARY_RIGHT then 
		widget.evnt.wheelup = true
		widget.touch.editActiveSince = getTime()							-- refresh edit active timeout
		if debug3 then print("Event wheelRight   evt_left/right:",ROTARY_RIGHT) end	
	elseif category == 0 and value == ROTARY_LEFT then 
		widget.evnt.wheeldwn = true
		widget.touch.editActiveSince = getTime()							-- refresh edit active timeout
		if debug3 then print("Event wheelLeft   evt_left/right:",ROTARY_LEFT) end
	end
    if category == EVT_KEY and value == KEY_ENTER then
        if debug3 then print("    event KEY_ENTER:", category, value, x, y) end	
        return true
		
    elseif category == EVT_TOUCH then
		widget.touch.editActiveSince = getTime()						-- store for timeout recognition (edit field activation/deactivation)
        if debug3 then 
			if 		value == KEY_ENTER_LONG then  print("    value key_long:",  value, x, y) 
			elseif	value == KEY_ENTER_SHORT then  print("    value key_short:",  value, x, y)
			elseif	value == TOUCH_END then  print("    value touch_end:",  value, x, y)
			elseif	value == TOUCH_START then  print("    value touch_start:",  value, x, y)
			else	print("    vTOUCH value:",  value, x, y)
			end
		end	
		if value == TOUCH_END then				-- evaluate menu handler
			widget.touch.X=x
			widget.touch.Y=y
			-- define touch araea
			local y1 = widget.topbarH + widget.spaceY
			local y2 = y1 + widget.wigdetH/3
			local y3 = y2 + widget.wigdetH/3
			local x0 = 0
			local x1 = widget.spaceX + 	(widget.widgetW/3)
			local x2 = x1 + 			(widget.widgetW/3)
			local x3 = widget.w/2								-- x center axis
			local x4 = x3 + x1			
			local x5 = x3 + x2
			
			if y > y1 then
				if 		x < x1 then 		handler = LEFT_1							-- left frame: prev	page
				
				elseif	x < x2 then																								-- select frameLeft				
					if		y > y3 and widgetAssignment[BOTTOM_1].label ~= "EMPTY" then	handler = BOTTOM_1							-- 		Widget left3 "bottom touch" / ensure widget has definition / is not empty
					elseif	y > y2 then
						if	widgetAssignment[CENTER_1].label ~= "EMPTY" then			handler = CENTER_1	end						-- 		Widget left2 "mid touch"
					else															handler = TOP_1								-- 		Widget left1			
					end						
					widget.actualWidget["left"] 	= {typ=handler, page = 1, maxpage = layout[handler].maxpage }						-- 		assign actual widget (left)		
					
				elseif	x < x3 then			handler = RIGHT_1							-- left frame: next	page


				elseif	x < x4 then			handler = LEFT_2 							-- right frame prev	page		
				elseif	x < x5 then																								-- select frameRight			
					if		y > y3 and widgetAssignment[BOTTOM_2].label ~= "EMPTY" then	handler = BOTTOM_2				-- 		Widget right3
					elseif	y > y2 then
						if	widgetAssignment[CENTER_2].label ~= "EMPTY" then			handler = CENTER_2	end						-- 		Widget right2
					else															handler = TOP_2								-- 		Widget B1	
					end						
					widget.actualWidget["right"] 	= {typ=handler, page = 1, maxpage = layout[handler].maxpage }			-- select actual widget (left)					

				else 						handler = RIGHT_2 							-- B-page next
				end						
			else
				--menu(widget)
			end
		end
        return true
    else
        return false
    end
end
																			-- ************************************************
																			-- ***		     init widget		 	   		*** 
																			-- ************************************************
local function init()
 system.registerWidget({key="unow01", name=name, create=create, wakeup=wakeup, paint = paint, configure=configure, event=event, menu=menu, read=read, write=write})

end

return {init=init}