
-- NEXT STEP:

-- curve
	--trim support
	--100% limit
	
	--modelfind
	--green button
	

	
	
-- App OFFset as para for subApps
-- disclaimer
-- new lib versioning
-- clean up setcurve & modelfind 
-- standard nomenclatur Paint call Apps
		
		
		
-- NextGen

--	multi pics (app01 & 03) needs dedicated app conf storage




-- OK:


-- bugs config

	-- 1 >> modelfind
	-- 2 >> picture & define pics
	-- 3 >> as soon curve >> pic def disapperar!!
	--	!!! 663 appIndex imme rnur von line der 1. Änerung !!!
	
	
	-- changeing several appSelector
		-- >> subforms messed up

	-- start mit 1>pic sonst nix
	--  change 1  auf Mfind
	--  914 "TOP! " not callable
	
	
-- prepare app-mainCall for single "paint" call like modelfind
-- cv POD / Selector >> source
-- evaluation: 
		--	create(): purpose widSetup//					-- app specific setup // defined by config handler
		--    actualWidget ={}								-- actual subWidget/app  ["left"] "lean" DATA: typ,page,maxpage  typ=selection
-- full dark & bright theme
-- lean subform code Phase2
-- cleanUp debug code main()
-- redesign curve
-- convert all to lang file support incl. forms
-- cv SOURCE !!
-- new widget producec config errors // index nil field 644
-- 1.4.6 source ??
-- bmp update
-- change app01 (modfind) resets app02 settings ??ß ggf done!
-- refresh setting after reconfig in actual widget
-- on "change app0x" in Form config:  only active after 2nd config call
-- optimize fileselector & number picloads in pic1
-- debud picload (mutli loads)
-- lean subform code Phase1
-- use standards if no settings in formlines on read
-- multi lang support in conf files / Formlines
-- jump "NIL" app
-- use passed conf in apps
-- modelfinf button color
-- basic picture function
-- get widgetlist from file, not from main source
-- curve >> better estimate of curve; dyn selection, not "static"; crvExists(crv); source ??
-- pic: >> picture selectable from file list (fileselector?) https://github.com/FrSkyRC/ETHOS-Feedback-Community/issues/1468




--  Udos Ethos Suite
--  Rev 1.0

--  this is the very first release  of a lua "suite" for ethos
--  main idea is to run multiple widgets (also named "sub-Apps , Apps or sub-Widgets") in one widget frame
--  you can configure a max of three apps in one frame
--  let the user choose which app he wants to see by touch on the upper or bottom area of a frame
--  one widget can consist of several pages, touch on the left or right area will scroll the pages

-- in Rev 1.0 we will start with three availabe apps
-- setcurve >> "inflight" tuning of curves; "modelfinder" adopted from the standAlone widget, "picture" >> let you show your models image (png) on a background you want.

--- The lua script "Udos Ethos Suite" is licensed under the 3-clause BSD license (aka "new BSD")
---
-- Copyright (c) 2022, Udo Nowakowksi
-- All rights reserved.
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--	 * Redistributions of source code must retain the above copyright
--	   notice, this list of conditions and the following disclaimer.
--	 * Redistributions in binary form must reproduce the above copyright
--	   notice, this list of conditions and the following disclaimer in the
--	   documentation and/or other materials provided with the distribution.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL SPEEDATA GMBH BE LIABLE FOR ANY
-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
-- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



-- **************************************************************************************************
-- suite "event-handler range" Feb 2023
-- event handler needs. first handler-Ids for buttons (e.g. 501..503 in modelfind / 3 buttons)
--
-- app                start         end      prefix
--
-- modelfind           500          520      MFind
-- announce            520          540                   ??? under construction
-- teleEl	                                                ??? under construction
-- picture	                   not used
-- setCurve                  not used
-- **************************************************************************************************






--[[ how to add widget:

(1) load lua file in section "load "widgets / functions" "
		loaded_chunk = assert(loadfile("/scripts/libUnow/tele1.lua"))
		loaded_chunk()
		
(2) assign widget to frame in section "assign all available widgets to corresponding frames"
			[TOP_1] 	= {func = function(frame,page) tele1(frame,page) 		end, maxpage = 1} >> TOP= first widget (TOP,CENTER,BOTTOM) _1=LEFT Frame (_2=right frame); or choose "TOPLINE" for header

(3) in case widget should be shown by start >> assign in section "assign start condition "
			local startwidgetL = TOP_1			-- L = left frame




 

 
 
	widgetList:									unsorted list of available apps; including some parameters , 
	widgetAssignment							every "subwidgetframe" has his own "app-range" with "slots"
													here one fame, so we have three apps in slots "Top_1", "Center_1", "Bottom1"
													these "slots" like "11","21"...are assigned to apps by widgetAssigment array
													
													another possible config (three frames in a fullscreen environment) could be		(future development)			
													topwidget	: slot "Topline"		(only one app possible)
													left Frame	: slot "Top1..Bottom1"	(three apps)
													rightFrame	: slot "Top2..Bottom2"	(three apps)
	
	widgetArray									the indizez of the single "slots": local widArray = {TOPLINE, TOP_1,CENTER_1 ,BOTTOM_1,TOP_2,CENTER_2 ,BOTTOM_2 } ; kind of lookup table
	widget.conf									main configuration "Formlines"; which apps are selected and some major parameter (theme etc..)
	widget.subForm [index][line]					sub-configuration FORMLINES, sourced from function getSubForm (file suite_conf.lua)
	
	widget.subConf [index] [formlineValue]		sub-configuration VALUES, got from app specific subForm in config menu; index1 = app01 3=app03; used in func handlewidgetTree etc.. 
 
 
 
 indizes
 
 
 index/appIndex			app01..app03
 slot/assign		11,21,31...	
 appList			1..name	6=setcurve
 ChoiceList		1="---", subset in formlines
 
 ]]

 local OFFSET <const> 		= 1			-- # config -header items in widget configuration: only one (theme)
 
 local SINGLE_WID <const>	 = 1
 local Dual_WID <const>		 = 2
 local TOPBAR_WID <const>	 = 3
 
 local WIDGET_MODE <const>	 = Dual_WID	-- defines global "management" mode of this "wrapper":
										--		1 = single frame (e.g. half area of the screen)
										--		2 = two frames within one ethos widget, e.g. fullscreen with/without TOPLINE
										--		3 = two frames AND an individual topline , Ethos 100% fullscreen 
  local MULTI 		= false
  local TOP_MODE 	= false
  if WIDGET_MODE > SINGLE_WID then
	MULTI = true
  end
  if WIDGET_MODE == TOPBAR_WID then
	TOP_MODE = true
  end

-- demoMode  = true

 local tmptmp = 0

 local debug1 		= false			-- monitor create
--local debug2 <const> 		= false			-- monitor paint
 local debug2  	= true			-- monitor paint
 local debug3  	= true			-- monitor event handler
 local debug4 	= false			-- sport timeout
 local vdebug5  	= true			-- sport request 
 local debug6 	= true			-- handler
 local debug7 	= true			-- print demoMode
 local debugConf= false			-- write/read config
 local debugReas= false			-- reassign new params/config to widget
 
-- some pathes
local libPath <const>  			= "/scripts/libUNow/"
local widgetPath <const>  		= "/scripts/libUNow/widgets/"
local localPath <const>  		= "/scripts/Modelfind_UN"

local numApps <const>  		= 6

local 	fields = {}						-- form fields array

local layout = {}
local layoutSet 		= {}
local widgetconfLine	= {}
local widgetconfArray	= {}
local widgetList 		= {}

local wpath = "/scripts/Tools1/"
local suitePath = "/scripts/libUNow/suite/"

local initAppConfig = false					-- flag config has changed, so init apps 
local tmpSrc = nil

-- globals:
-- handler (don't change)
local TOPLINE <const>		= 99			-- (no handler neccessary)
local LEFT_1  <const>  		= 1
local TOP_1   <const>		= 11
local CENTER_1 <const>  	= 21
local BOTTOM_1 <const> 		= 31
local RIGHT_1   <const>		= 2

local LEFT_2  <const>  		= 3
local TOP_2   <const>		= 41
local CENTER_2 <const> 		= 51
local BOTTOM_2 <const>  	= 61
local RIGHT_2   <const>		= 4

-- display handler
local DISP_X20   <const>	= 1
local DISP_X18   <const>	= 2
local DISP_HORUS <const>	= 3


local NIL <const> 			= 1
local PICTURE <const> 		= 2
local CurveEDIT <const> 	= 3
local ModelFINDER <const> 	= 4

local NUMWIDGETS <const> 	= 3				-- number of widgets
local THEMEidx <const>		= 1				-- theme is defined in formline # THEMEidx

-- seq. list of widget handler (needed for loops)
local widArray = {TOPLINE, TOP_1,CENTER_1 ,BOTTOM_1,TOP_2,CENTER_2 ,BOTTOM_2 }

local widgetAssignment = {}			-- assignment / definition sub widgets

-- some bitmap vars:
-- local topBackground
-- local batOK_bmp, batWarn_bmp, batAlarm_bmp



local handler = 0

--local txtFields,optionLan,header = dofile("Tools1_lang.lua")		-- get language file

function round(val,dec)
  local mult = 10^(dec or 0)
  return math.floor(val * mult + 0.5) / mult
end
	


																			-- ************************************************
																			-- ***		     name widget					*** 
																			-- ************************************************
local translations = {en="Udos Suite 2.0"}

local function name(widget)					-- name script
  local locale = system.getLocale()
	 return translations[locale] or translations["en"]
end

local function getLang()
	if system.getLocale() == "de" then
		return 1							-- german txt 
	else
		return 2							-- en txt
	end
end																			-- ************************************************
																			-- ***	returns handler for app#				*** 
																			-- ************************************************
local function lookupAppHndl(index)
	local lookup = {
		TOP_1,				-- LEFT app01
		CENTER_1,			-- LEFT app02
		BOTTOM_1,			-- LEFT app03
		
		TOP_2,				-- RIGHT app01
		CENTER_2,			-- RIGHT app02
		BOTTOM_3,			-- RIGHT app03
	} 

  return lookup[index]
end


																			-- ************************************************
																			-- ***	        debug purpose                 *** 
																			-- ***       dump actual subApp Config          *** 
																			-- ************************************************
local function dumpSubConf(widget)
	print("----------   dump actual app config  ----------")
	local appIndex,item
	for appIndex = 1,3 do							-- loop appIndex
		for item = 1,#widget.subForm[appIndex] do		-- loop FormLines per app
			print("dump appConf  app#, item, value",appIndex,item,widget.subConf[appIndex][item])
		end
	end


end

local function declare_left()
end

local function assignLayout(widget)
 -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!     this is the main declaration of the whole wrapper     !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	local subCnfOffset = 3 						-- offset sunbconf index for right widget
	if not pcall(function() 
		local lookup = defApplist()

		-- *******************************                         assign all selected widgets to corresponding frames (top,left,right) incl.parameters                                                                       ***************************
			-- frame	
		--	mainfunc functionCall		(arguments,see "call frame dependent widgets " below)				
		layout = {
			-- call widget specific function from global namespace  			
--			[MAIN] 		= {func = function(frame,page) >> call     functionName							(frame,page,widget.layout 		.... end, maxpage = 1},				--  [*_1] = frame-left: list of "widgets"
			[TOP_1] 	= {func = function(frame,page)	return(_G[widgetAssignment[TOP_1   ].mainfunc](frame,page, 	widget.layout,widget.theme,widget.touch,widget.evnt,widget.subConf[widget.widgetSelect["left"].selected],	widget.appConfigured[TOP_1],	widget.appTxt[TOP_1],		widget, lookup[widget.conf[widget.widgetSelect["left"].selected+OFFSET][3]	][2]))	end, maxpage = widgetAssignment[TOP_1   ].maxpage},
			[CENTER_1]	= {func = function(frame,page)	return(_G[widgetAssignment[CENTER_1].mainfunc](frame,page,	widget.layout,widget.theme,widget.touch,widget.evnt,widget.subConf[widget.widgetSelect["left"].selected],	widget.appConfigured[CENTER_1],	widget.appTxt[CENTER_1],	widget, lookup[widget.conf[widget.widgetSelect["left"].selected+OFFSET][3]	][2]))	end, maxpage = widgetAssignment[CENTER_1].maxpage},
			[BOTTOM_1]	= {func = function(frame,page)	return(_G[widgetAssignment[BOTTOM_1].mainfunc](frame,page,	widget.layout,widget.theme,widget.touch,widget.evnt,widget.subConf[widget.widgetSelect["left"].selected],	widget.appConfigured[BOTTOM_1],	widget.appTxt[BOTTOM_1],	widget, lookup[widget.conf[widget.widgetSelect["left"].selected+OFFSET][3]	][2]))	end, maxpage = widgetAssignment[BOTTOM_1].maxpage}
			}
		  if MULTI then
			layout[TOP_2]		= {func = function(frame,page)	return(_G[widgetAssignment[TOP_2  ].mainfunc](frame,page,	widget.layout,widget.theme,widget.touch,widget.evnt,widget.subConf[widget.widgetSelect["right"].selected+subCnfOffset],	widget.appConfigured[TOP_2],	widget.appTxt[TOP_2],		widget, lookup[widget.conf[widget.widgetSelect["right"].selected+OFFSET][3]	][2]))	end, maxpage = widgetAssignment[TOP_2].maxpage}				--  [*_2] = frame-right:  list of "widgets"
			layout[CENTER_2]	= {func = function(frame,page)	return(_G[widgetAssignment[CENTER_2].mainfunc](frame,page,	widget.layout,widget.theme,widget.touch,widget.evnt,widget.subConf[widget.widgetSelect["right"].selected+subCnfOffset],	widget.appConfigured[CENTER_2],	widget.appTxt[CENTER_2],	widget, lookup[widget.conf[widget.widgetSelect["right"].selected+OFFSET][3]	][2]))	end, maxpage = widgetAssignment[CENTER_2].maxpage}
			layout[BOTTOM_2]	= {func = function(frame,page)	return(_G[widgetAssignment[BOTTOM_2].mainfunc](frame,page,	widget.layout,widget.theme,widget.touch,widget.evnt,widget.subConf[widget.widgetSelect["right"].selected+subCnfOffset],	widget.appConfigured[BOTTOM_2],	widget.appTxt[BOTTOM_2],	widget, lookup[widget.conf[widget.widgetSelect["right"].selected+OFFSET][3]	][2]))	end, maxpage = widgetAssignment[BOTTOM_2].maxpage}
		  end
	

		end ) then
				print("********************  ERROR layout definition   ***********************")
				print("********************  -----------------------   ***********************")
	end
		-- ******* assign start condition 
	print("-----------", widgetAssignment[TOP_1  ].mainfunc,widgetAssignment[TOP_2  ].mainfunc)
	local startwidgetL = TOP_1			-- left widgets starts with Top1 assigned app
	local startwidgetR = TOP_2			-- right widgets starts with Top2 assigned app	
	
	--print("maxpage",layout[startwidgetL ].maxpage)
										-- ******** definition of actual widgets on start (top, left right):
--	widget.actualWidget["left"] 		= {typ=startwidgetL , page = 1, 	maxpage = 1  }
--	widget.actualWidget["right"] 		= {typ=startwidgetR , page = 1, 	maxpage = 1  }
	widget.actualWidget["left"] 		= {typ=startwidgetL , page = 1, 	maxpage = layout[startwidgetL ].maxpage  }
	widget.actualWidget["right"] 		= {typ=startwidgetR , page = 1, 	maxpage = layout[startwidgetR ].maxpage  }
	return layout
end
																			-- ************************************************
																			-- ***		     form value-functions		*** 
																			-- ************************************************
-- called by "createXY" formline to get a value
local function getValue(parameter)
  if parameter[4] == nil then
    return parameter[4]		--default
  else
    return parameter[3]
  end
end

-- called by "createXY" formline to set a value
local function setValue(parameter, value)
  parameter[3] = value
  initAppConfig = false					-- trigger re init of apps
end

-- for future use; expands array
local function insertArray(tableSrc,index,inserts)
	for i=1,#inserts do
		table.insert(tableSrc,index,inserts[i])	
	end
	return tablesrc
end

-- "reset" subForm in case new app was choosen
local function clearSubConf(appIndex,widget)
		print("execute CLEAR SUNCONF for App#",appIndex)
		if appIndex ~= nil then
			widget.subConf[appIndex] ={}
			for i= 1,10 do
				widget.subConf[appIndex][i]=nil			-- INIT
			end
		else
			print("clear subconf called with index nil!")
		end
end

																			-- ************************************************
																			-- ***		    create new form line   	 *** 
																			-- ***         return new "field line"		 ***
																			-- ***  ensure that 3rd parameter is value***
																			-- ************************************************
															
local function createNumberField(line, parameter)
  local field = form.addNumberField(line, nil, parameter[5], parameter[6], function() return getValue(parameter) end, function(value) setValue(parameter, value) end)
	return field
end


local function createBooleanField(line, parameter)
  local field = form.addBooleanField(line, nil, function() return getValue(parameter) end, function(value) setValue(parameter, value)  end)
--  local field = form.addBooleanField(line, nil, function() print("got",parameter[1],parameter[3]) return getValue(parameter)  end, function(value) setValue(parameter, value) print("set",parameter[1],value) end)
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


local function createSwitchField(line, parameter)
  local field = form.addSwitchField(line, nil,  function() return getValue(parameter) end, function(value) setValue(parameter, value)  end)
  return field
end


local function createFilePicker(line, parameter)
  form.addFileField(line, nil, parameter[4], parameter[5], function()   return getValue(parameter) end, function(newValue)   setValue(parameter, newValue) end)  
  return field
end



local function createSourceField(line, parameter)
	local field = form.addSourceField(line, nil, 
		-- read / return source
		function() 									-- this function corresponds to "parameter[3]"
			return getValue(parameter)
		end, 
		-- choose / set	source
		function(newValue) 
			source = newValue 
			setValue(parameter, source)
		end		)
  return field
end

																									-- **********************************************************************
																									-- *****                                                            *****
																									-- *****     some functions to create formlines in config menu      *****
																									-- *****                                                            *****																									
																									-- **********************************************************************
																																																		

-- ************************************************************************************************************
-- built channel array which you can use in choice field as selection list 
-- ************************************************************************************************************
local function getChannels()
	local index = 0
	local chArray = {}
	for i=0,63 do
		chArray[i]={}
		local inputSrc =  system.getSource({category=CATEGORY_CHANNEL, member = i})
		chArray[i][1]=inputSrc:name()
		chArray[i][2]=i
	--	print("Channel",chArray[i][1])
	end
	return chArray
end

-- ************************************************
-- "helper" for "getCurves()" to sum up existent curves
-- ************************************************
local function crvExists(crv)
 if crv ~= nil then 
	return(true) 
 else
	return(false)
 end

end


-- ************************************************
-- create curve choice list
-- ************************************************
local function getCurves()
	local index = 0
	local chArray = {}
	for i=1,64 do												-- choice list must start using 1 !!
		chArray[i]={}
		local inputCrv =  model.getCurve(i-1)					-- try to get a curve

		if crvExists(inputCrv) then								-- successfull ?
			chArray[i][1]=inputCrv:name()
			chArray[i][2]=i										-- choice list must start using 1 !! >> in curve you will have to substract value by !
		else
		--print("nil",i)
		end
	end
	return chArray
end



-- *******************************************************************************
-- translates table entries from file (config form definitions) into functional ones
-- unfortunately direct processing of create... statements not possible
-- called by subFormBuilt, createSubWidgetField, read handler
-- *******************************************************************************
local function migrateForm(formTbl)
	
  local channelList={}
  local lookup ={
	createNumberField 	= createNumberField	,
	createTextButton 	= createTextButton	,
	createBooleanField 	= createBooleanField	,
	createChoiceField 	= createChoiceField	,
	createCurveChoice	= createChoiceField	,
	createChannelChoice	= createChoiceField	,
	createSourceField	= createSourceField	,
	createFilePicker	= createFilePicker ,
	createSwitchField	= createSwitchField ,
	createTextOnly 		= createTextOnly	
	}
	
  local formArray = {}
	for i= 1,#formTbl do												-- browse through all lines of one subform
		formArray[i] = {}												-- now we got  "a line"
		for j =1,#formTbl[i] do											-- browse through all items of a form line definition
			if j==2 then												-- assign function: if second item: "special handling" in some cases (moestly in case objects should be "dynamically" injected)
				local func = formTbl[i][j]								-- get function string from table
				if func == "createChannelChoice" then
					formTbl[i][5] =getChannels()						-- "inject" actual channel list as choicelists into formline
					
				elseif  func == "createCurveChoice" then
					formTbl[i][5] =getCurves()							-- "inject" actual curve list as choicelists
					for x=1,#formTbl[i][5] do
					end
				end
				formArray[i][j] = lookup[func]							-- conversion/mapping
			else
				formArray[i][j] = formTbl[i][j]							-- mapping 1:1
			end
		end
		formArray[i].default = formTbl[i].default
	end
	
	return formArray
end

-- refresh widget assignment:
-- 	slot gets new AppIndex
--	txt fields in slot gets corresponding text
--	subform items are prepared

local function reAssignWidgets(value,index,appIndex,widget)
		print("REASSIGN WAS CALLED value,index",value,index)
		local offset = 0													-- 0= left, 30= right widget	in case of multi frame environtment			
		--if index > 4 then offset = 30 end									-- index 1-3: left frame/widget
		print("offset",offset)
		
		local appIndex = index-OFFSET									-- index which starts by 1
		local slot = appIndex*10+offset+1								-- Top_1, Center_1, Bottom_1 ..
		if debugReas then print("REASSIGN WAS CALLED value,index,appIndedx,slot",value,index,appIndex,slot) end
		if value >1 then													-- represents choice list index: so get corresponding subForm if something was selected (1=nothing)
					
--			local assignment = lookup[value][2]									-- get the "appindex" (widgetList index); we to substract 1 because choicefield returns 2 as first valid app
			local assignment = value
			print("NEW assignment",slot,widgetList[assignment].txt)
			widgetAssignment[slot] 	= widgetList[assignment]			-- assignindex e.g. "Top_1" slot  =  widgetList[#6]  .label = "setcurve" (#6 = setcurve App)
			widget.appTxt[slot] 	= widgetList[assignment].txt		-- here we load lang specific text !
			if debugReas then print("assign: ",slot,assignment,widgetList[assignment].label,widgetList[assignment].mainfunc) end
			widget.subForm[appIndex]=migrateForm(getSubForm(value,widgetAssignment[slot].txt,widget.language))
--		--	print("set subform for app ".. appIndex .. "   with number of items:  ",#widget.subForm[appIndex])
		else
			widgetAssignment[slot] = widgetList[99]		--"empty" index in wisdgetlist
--		--	print("slot empty",slot,"99",widgetAssignment[slot].label)
		end
	--	print("checkpoint built formline, label:",widget.subForm[appIndex][1][1])

end


-- ******************************************************************
-- check if static formline (like text only) , so no other variable to set
-- ******************************************************************
local function checkStatic(formType)
	if formType == createTextOnly then
		return true
	end
	return false

end


-- ************************************************
--          built all app-specific subForm lines
--          called by "handleWidgetTree" (user started "config")
--          and "createSubWidgetField" (during set function call; so user changed app selection)
-- ************************************************
local function subFormBuilt(parameter,widget,fields,index,appListIdx,slot)
	local appIndex = index - OFFSET		
	fields[#fields + 1] = field	
							
--	widgetAssignment[slot].txt	= widgetList[appListIdx].txt													-- here we load lang specific text for this app, so subForm can be filled with labels !
--	widget.subForm[appIndex]	= migrateForm(getSubForm(appListIdx,widgetAssignment[slot].txt,widget.language))		
--	widgetAssignment[slot] 		= widgetList[appListIdx]														-- the new app has to be declared into corresponding "app slot"

--	print("-----  CCC SuvFormBuilt  slot,index,appListIdx:  ".. slot,index,appListIdx,defApplist(appListIdx,true))
	--dumpSubConf(widget)
	
	if #widget.subForm[appIndex] >0 then															-- subForm=evaluated during "createwidgetfield" ; check if formlines do exist
		for index = 1, #widget.subForm[appIndex] do													-- browse through lines

			widget.subForm[appIndex][index][3] = widget.subConf[appIndex][index]					-- set cached value 

			paraSub 	= widget.subForm[appIndex][index]											-- get subform line [appEntryNum][corresp.SubFormLine][SubFormLine.Item]
			if not pcall(function() paraSub[3] = widget.subConf[appIndex][index]  end ) then		-- value "injection" into paraSub[3]
				print("ERROR Config injection")
				paraSub[3] 	= nil
			end

			local line = form.addLine("   " .. paraSub[1])											-- get line label
			local tmp=paraSub[2]																	-- type to create
--			print("---- CC create line ",paraSub[1])
			field = paraSub[2](line, paraSub) 														-- finally, create field
			fields[#fields + 1] = field			
		end
	else
		print("ERROR during subForm Built, no ITEMS / Lines defined !")
	end
--	print("-----  CCC  END  SubFormBuilt")
end





-- **************************************************************************************************
-- needed in case you want to choose a sub-widget in a FormLine
-- this creates all additional, subWidget dependent Formlines (subForm) after choosing a new sub-Widget
-- subForm definition is loaded prior from file
-- **************************************************************************************************
local function createSubWidgetField(line, parameter,widget,index, appIndex)							-- appIndex: 1=app01, 2=app02...

	local lookup = defApplist()																		-- get choiceList
	local paraSub = {}
	local field = form.addChoiceField(line, nil, parameter[5], 										-- here we built "main" choiceField for appN
			function() return getValue(parameter) end,												-- getVal >> returns value when "reding"

			function(choice) 																		-- setVal>> user input inducec change of value; so we have to built the whole formsheet from skratch
				setValue(parameter, choice) 														-- value = Choice = selected item from choicelist: 1= nothing

				-- Part1: redefine actual "Formline" App:
				widget.configured = false															-- enforce new frontend configure
				-- new subwidget was selected, so refresh config menu by using new "subwidget" config
				form.clear()
				form.invalidate()

				local lookupA={																		-- some calcs to get actual txt / lang dependent
					11,				-- left top 	// app01
					21,				-- left center  // app02
					31,				-- left bottom  // app03
					
					41,				-- right top 	// app01
					51,
					61
					}

				local lookup = defApplist()	
				value = lookup[parameter[3]] [2]
--				print("$$$$$$$$$$$$$$$$$     subwidgetFIELD create",value,index,appIndex,widget)
				dumpSubConf(widget)
				reAssignWidgets(value,index,appIndex,widget)										-- reassign new App to slot
--				print("*****************     CALL From SUBCREATE appIndex   ***********",appIndex)
				clearSubConf(appIndex,widget)														-- init cache array of actual "app" subValues / configuration		
	--[[			
				-- Part2: cache other SubForm Values
				for i = 1,3 do																-- browse through "AppLines"
					if i ~= appIndex then													-- cache values for "not new selected" Apps
						for j = 1,#widget.subConf[i] do
							widget.subConf[i][j] = widget.subForm[i][j][3]	
							print("cache ",i,j,widget.subConf[i][j])
						end
					end									
				end
				
]]
				-- Part2: create complete new Form:
		
				for formLine=1,#widget.conf do
					parameter = widget.conf[formLine]												-- get complete Formline
--					print("3333 create fLine",formLine,parameter[1])
					if parameter[2] == createSubWidgetField then									-- we got an subwidget choice field
					
						local tmp_appIndex =formLine - OFFSET										-- "appIndex" for rekursive call
						
						-- built "select subApp" line
						local value = parameter[3]													-- actual / new SubApp selection
						line = form.addLine(parameter[1])											-- >> line label					
						local field = createSubWidgetField(line, parameter,widget,formLine,tmp_appIndex)	-- creates Choice-line including functions to refresh form in case of set new "item";  offset because of header items (=1)

						-- prepare to built dependent / subApp specific Lines						
						local appIndex2 = formLine - OFFSET											-- app1..app3; offset because of #header items 
						local lookup = defApplist()													-- get ChoiceList
						local appListIdx = lookup[widget.conf[formLine][3] ][2]						-- appList : field[#idx,3],2 = fieldValue of app selector ( choice List) >> widget formLine, e.g. 6 =setcurve
						local offset = 0															-- 0= left, 30= right widget	in case of multi frame environtment			

						local slot = appIndex2*10+offset+1											-- "handler" Top_1, Center_1, Bottom_1 ..	11,21,31 ....

						-- built specific subForm  !!! ERROR index !!!
						subFormBuilt(parameter,widget,fields,formLine, appListIdx,slot)

					else
						line = form.addLine(widget.conf[formLine][1])								-- create main form entries
						field = parameter[2](line, parameter) 
						fields[#fields + 1] = field		
					end	

				end	
			
--				print("$$$$$$$$$$$$$$$$$     subwidgetFIELD END",value,index,appIndex,widget)
	end  )
	return field
end





-- ******************************************************************************************************************************************
-- called by configure: creates one line for app selection and dependent sub-Lines for configuration of choosen app (in case an App was selected)
-- ******************************************************************************************************************************************

local function handleWidgetTree(parameter,widget,fields,index)										-- index = formline sequence
	print("-----  BBB  BEGIN  handle widget tree")
	local appIndex = index - OFFSET																	-- app1..app3; offset because of #header items 
	local lookup = defApplist()																		-- get ChoiceList
											
	if widget.conf[index][3] == nil then 															-- on very first run, initiatlize selection
		widget.conf[index][3] = 1																	-- nothing selected
	end
	local appListIdx = lookup[widget.conf[index][3] ][2]											-- appList : field[#idx,3],2 = fieldValue of app selector ( choice List) >> widget index, e.g. 6 =setcurve
	local offset = 0																				-- 0= left, 30= right widget	in case of multi frame environtment			
	local slot = appIndex*10+offset+1																-- "handler" Top_1, Center_1, Bottom_1 ..	11,21,31 ....
	
--	form.beginExpansionPanel("App 0".. tostring(appIndex))											-- just a test, layout declined
	line = form.addLine(parameter[1])																-- >> line label
--	print("///////////   call subwidgetField index,appIndex:  ",index,appIndex)
	local field = createSubWidgetField(line, parameter,widget,index,appIndex)						-- creates Choice-line including functions to refresh form in case of set new "item";  offset because of header items (=1)
--	print("<<<<<<<<<<<   return from subwidgetfield built")
	subFormBuilt(parameter,widget,fields,index,appListIdx,slot)
--	print("-----  BBB  END  handle widget tree")
--	form.endExpansionPanel()																		-- just a test, layout declined
end



																			-- ************************************************
																			-- ***		   reset event cache             *** 
																			-- ************************************************
local function resetEvnt(widget)
		widget.evnt.wheelup = false
		widget.evnt.wheeldwn= false
		if  widget.touch.editActiveSince ~= nil and getTime() - widget.touch.editActiveSince > 5 then
			widget.touch.X=nil
			widget.touch.Y=nil
		end
end



local function evalTheme(widget)
	return  widget.conf[THEMEidx][3]										-- 1= dark, 2=bright // selection list
end

																			-- **************************************************************
																			-- ***        config changed, so reset all flags              *** 
																			-- ***  cache Config data (form will be rebuilt from skratch  *** 																			
																			-- ***         to trigger app reconfiguration                 *** 
																			-- ***         called by paint & config handler               *** 
																			-- **************************************************************
local function resetAppConfigFlag(widget)
	
	if widget.display ~= nil then
		widget.theme = initTheme(evalTheme(widget))										-- ensure theme change will be activated (not until diplay is initialized)
	end
	
	local appIdx, item
	for appIdx = 1,numApps do															-- loop all apps
		for item = 1,#widget.subForm[appIdx] do									-- loop all params in app
			widget.subConf[appIdx][item] = widget.subForm[appIdx][item][3]		-- ensure data persistence>> cache formValues Para[3] = value of subform item !!
			print("reconf ",appIdx,item,widget.subConf[appIdx][item])
		end
	end
	
	widget.appConfigured[TOP_1] 	= false	
	widget.appConfigured[CENTER_1]	= false	
	widget.appConfigured[BOTTOM_1] 	= false
	
	widget.appConfigured[TOP_2] 	= false	
	widget.appConfigured[CENTER_2]	= false	
	widget.appConfigured[BOTTOM_2] 	= false
	
	return true
end

																			-- ************************************************
																			-- ***		    startup (onetime) handler		*** 
																			-- ***	         returns widget vars			*** 
																			-- ************************************************
local function create()

	local language = getLang()
	---------------------------
	---- load standard libs --- 
	---------------------------			
	txt = dofile(suitePath.."suite_lang.lua")	
			
	loaded_chunk = assert(loadfile(suitePath.."suite_conf.lua"))						-- sub-widget/ "apps"  assignment & config
	loaded_chunk()

	loaded_chunk = assert(loadfile("/scripts/libUnow/lib_standards.lua"))
	loaded_chunk()

	loaded_chunk = assert(loadfile("/scripts/libUnow/lib_relative_draw.lua"))			-- functions for "relative draw"
	loaded_chunk()																		-- use of percent values instead of absolut pixels
																						-- so x,y : 100,100 would be right down corner of a frame	
	loaded_chunk = assert(loadfile("/scripts/libUnow/lib_getTele.lua"))					-- telemetry functions 
	loaded_chunk()	
	
	loaded_chunk = assert(loadfile("/scripts/libUnow/lib_drawIcons.lua"))
	loaded_chunk()

	loaded_chunk = assert(loadfile("/scripts/libUnow/lib_FileIO.lua"))
	loaded_chunk()
	
	---------------------------
	----   var declaration  --- 
	---------------------------			
	widgetList = suite1conf()
	
	local wpath = getWidgetPath()														-- definiton widget path
	
	local 	w,h		= nil																-- display size (evaluated on 1st paint run)	
	local 	display = X20																-- display type def at start

	-- init subForm array (sub-widget config menue) 
	local subForm={}																	-- array specific app formlines
	local subConf={}																	-- array specific app formlines value cache
	for i=1,numApps do
		subForm[i]={}																	-- formLines
		subConf[i]={}																	-- cache formLine-values during refresh
		for j= 1,10 do
			subConf[i][j]=nil															-- INIT cache
		end
	end

	
	local apps = {}																		-- available apps & index
	local apps_template = defApplist()													-- app selection list (temp only)
	for i= 1,#apps_template do
		apps[i] =  {apps_template[i][1],i}												-- >> app selection list including ondex
	end
	

	
	
	local confTxt = {																	-- configuration text 
	--	   de				en
		{"Schema",		"Theme"}
		}
	

	-- ******************   This is the definition of our "main" Config Form :   ********************************************	
	--*******************	para 3 in App fields will contain the widget # (number of choicelist )
	local conf = {					
--		{txt.theme[lan], 	createChoiceField,							nil,	1,		 	{txt.themeDark[lan],1},{txt.themeBright[lan],2}},		
		{confTxt[1][language], 	createChoiceField,				nil,	1,	 	{{"dark",1},{"bright",2}}},	
--		{"TEST", 	createChoiceField,				nil,	1,	 	{{"dark",1},{"bright",2}}},	
		
		{"App 01L", 				createSubWidgetField,			nil,	1,		apps	},
		{"App 02L", 				createSubWidgetField,			nil,	1,		apps	},	
		{"App 03L", 				createSubWidgetField,			nil,	1,		apps	},
		
		{"App 01R", 				createSubWidgetField,			nil,	1,		apps	},
		{"App 02R", 				createSubWidgetField,			nil,	1,		apps	},	
		{"App 03R", 				createSubWidgetField,			nil,	1,		apps	}
	}	
	

	
	local appTxt = {							-- app specific text, multi language
			LEFT_1 	 = {},
			CENTER_1 = {},
			RIGHT_1	 = {},

			LEFT_2 	 = {},
			CENTER_2 = {},
			RIGHT_2	 = {}			
			}

	local appConfigured = {}					--  app is configured ? if false ; run onetime app-frontendconfigure (called every time anorther app was selectes on frontend) 
			appConfigured[TOP_1] 	= false
			appConfigured[CENTER_1] = false
			appConfigured[BOTTOM_1] = false
			
			appConfigured[TOP_2] 	= false
			appConfigured[CENTER_2] = false
			appConfigured[BOTTOM_2] = false			
			
			
	local maxpage = {}							-- max number og pages of active App
	
	local actualWidget ={}						-- actual subWidget/app  DATA;´
	local widgetSelect ={}						-- needed for existent & selected app avaluation (by event handler, user selects another app)
		widgetSelect.left ={}
		widgetSelect.left.running 	= 1			-- start with 1= TOP_1 widget		
		widgetSelect.left.selected 	= 1			-- on start running = selected
	
	if MULTI then
		widgetSelect.right ={}
		widgetSelect.right.running 	= 1			-- start with 1= TOP_2 widget		
		widgetSelect.right.selected 	= 1		-- on start running = selected		
	end	
		
	local touch	= {}							-- widget touch data
	local evnt 	= {}							-- widget event data
		evnt.wheeldwn 	= false
		evnt.wheelup 	= false

	local theme = {}							-- theme definition	
	
	local numItems = #conf						-- number of lines in "main" form


	local lastWidget = nil						-- widget which was selected on last run

	
  return{	
		numItems	 = numItems, 				-- number of lines in "main" form
		conf		 = conf, 					-- main configuration "Formlines"; which apps are selected and some major parameter (theme etc..)
		subForm 	 = subForm, 				-- sub-configuration FORMLINES, sourced from function getSubForm (file suite_conf.lua)
		subConf 	 = subConf, 				-- sub-configuration VALUES, got from app specific subForm in config menu; index1 = app01 3=app03; used in func handlewidgetTree etc.. 
		actualWidget = actualWidget, 			-- actual subWidget/app  DATA;´
		lastWidget 	 = lastWidget, 		--??	-- widget which was selected on last run
		touch		 = touch,					-- widget touch data (may be passed to apps)
		evnt		 = evnt, 					-- widget event data (may be passed to apps)
		txt			 = txt, 					-- main widget "wrapper" specific localized text aray
		appTxt		 = appTxt,					-- app specific (Top1_1, Center_1...)localized text aray 
		maxpage		 = maxpage,					-- my number of pages in an app
		w			 = 0, 						-- frame width (Ethos widget frame)
		h			 = 0, 						-- frame high  (Ethos widget frame)
		topbarH		 = nil, 					-- no purpose in suite 1, later use
		spaceY		 = nil, 					-- no purpose in suite 1, later use 
		spaceX		 = nil, 					-- no purpose in suite 1, later use 
		wigdetH		 = nil, 					-- no purpose in suite 1, later use 
		margin		 = nil, 					-- no purpose in suite 1, later use 
		widgetW 	 = nil, 					-- no purpose in suite 1, later use 
		widgetList 	 = widgetList, 				-- unsorted list of available apps; including some parameters , 
		widgetSelect = widgetSelect, 			-- needed for existent & selected app avaluation (by event handler)
		configured 	 = false,					-- flag if main widget / "wrapper" is configured (one time init in sub-call) 
		appConfigured= appConfigured, 			-- flag if specific (actual running) app is configured ? if false ; run onetime app-frontendconfigure (called every time anorther app was selectes on frontend) 
		theme		 = theme, 					-- selected theme (dark, bright ...)
		display 	 = display , 				-- display type (x20/x18..) to optimize / finetune visualization
		wpath		 = wpath,					-- path of subwidgets / apps
		language 	 = language
		}
end





-- run once at first paint loop :
local function frontendConfigure(widget)

	widget.w, widget.h = lcd.getWindowSize()
	print("*****************************   FRONTEND widgetsize AA:",widget.w,widget.h)
	if widget.w> 0 then
	-- **********************************************    general layout    ******************************
	--local a,b =lcd.getWindowSize()
																						-- rough screen layout:
		frameLeft = {																	-- frame layouts: for compatibility reasons, only "left" is declared
			name= "left",																-- name
			x = 0,																		-- x-position
			y = 0,																		-- y-position (percent)
			w = widget.w*0.48,																-- width
			h = widget.h																-- height
			}
		frameRight = {																	-- frame layouts: for compatibility reasons, only "left" is declared
			name= "right",																-- name
			x = widget.w*0.5,																		-- x-position
			y = 0,																		-- y-position (percent)
			w = widget.w*0.48,																-- width
			h = widget.h																-- height
			}

	-- **********************************************    load basics    ******************************
		loaded_chunk = assert(loadfile("/scripts/libUnow/conf_displaySets.lua"))		-- evaluate tx type and set font size etc..
		loaded_chunk()

		loaded_chunk = assert(loadfile(libPath .."/themes/theme1.lua"))					-- color schemes
		loaded_chunk()
	
	widget.theme = initTheme(evalTheme(widget))												-- ensure theme change will be activated


    -- load selected apps / subWidgets (configuration in file "_conf"); #loops = #widgets:
	for i=2,numApps+1 do
		if  widgetAssignment[widArray[i] ].label ~= "EMPTY" then
			loaded_chunk = assert(loadfile(widget.wpath.. widgetAssignment[widArray[i] ].File ))
			loaded_chunk()
		end
	end

	-- define sub-widget specific config line:	
	for i=2,numApps+1 do																	-- start with 2 because of compatibility reasons to "fullscreen" suite ; 1= Topline, 2..4 LEFT widget
		-- print("slot assignment",i,widgetAssignment[widArray[i] ].label)
		local configWidgetCall="conf_".. widgetAssignment[widArray[i] ].label		-- call widget dependent function to get config string

	end

		
	-- *******************************    evaluate display specific settings   ***************************		
	widget.display 	= evaluate_display()
	txtSize = {}
	txtSize.Xsml, txtSize.sml, txtSize.std, txtSize.big = defineTeleSize(widget.display)
	--	print("size",txtSize.Xsml, txtSize.sml, txtSize.std, txtSize.big)

	widget.touch.X = nil
	widget.touch.Y = nil
	print("*****************************   FRONTEND widgetsize:",widget.w,widget.h)
	
	layout = assignLayout(widget)

	return(true)
	
	else
		return false
	end
end

local function shw_call(widget,frame)
	local handlerX = widget.actualWidget[frame].typ
	print("call       ",frame,handlerX)
	print("   func   :",layout[widget.actualWidget[frame].typ].func)
	print("    fName :", widgetAssignment[handlerX].mainfunc)
end

																			-- ***********************************************************************************
																			-- ****************************   call frame dependent widgets   *********************
																			-- ***********************************************************************************

-- call actual left widget

local function w_left(widget)
	-- shw_call(widget,"right")

	if not pcall(layout[widget.actualWidget.left.typ] ~= nil) then												-- typ=startwidgetL , page = 1, maxpage = layout[startwidgetL ].maxpage
	
		local appIdx 		= widget.widgetSelect["left"].selected								-- we are running in app#
		local slot = appIdx*10 +1
		
		local choiceIdx 	= widget.conf[appIdx+OFFSET][3]	
		local lookup = defApplist()
		local assignment = lookup[choiceIdx][2]
		
		--print("check left call: typ slot appidx assignment",widget.actualWidget.left.typ,slot,appIdx,assignment,widget.appConfigured[slot],layout[widget.actualWidget.left.typ])
		if assignment < 90 then
			widget.appConfigured[slot]=layout[widget.actualWidget.left.typ].func(frameLeft,widget.actualWidget.left.page,widget.appConfigured[slot])		-- func = function(frame,page)  		end, maxpage = 1
		end 
	else
		print("---------  Error w_left")
	end
end
-- 	>> look at frontendconfigure for specific paras: _G[widgetAssignment[TOP_1].mainfunc](frame,page,widget.layout,widget.theme,widget.touch,widget.evnt,widget)	



-- call actual right widget
local function w_right(widget)

	if not pcall( layout[widget.actualWidget.right.typ] ~= nil) then	
		local appIdx 		= widget.widgetSelect["right"].selected								-- we are running in app#
		local slot = appIdx*10 +1 +30
		
		local choiceIdx 	= widget.conf[appIdx+OFFSET][3]	
		local lookup = defApplist()
		local assignment = lookup[choiceIdx][2]	
		
--[[	
		print("right func call",widgetAssignment[TOP_2   ].mainfunc)
		print("1 para idx:",widget.widgetSelect["right"].selected+3, "(subconf[])")
		print("2 para #1 :",widget.subConf[widget.widgetSelect["right"].selected+3][1])
]]
		if assignment < 90 then

			-- here we call the widget & set "appconfigured" flag from false >> true on 1st run:
			widget.appConfigured[slot]=layout[widget.actualWidget.right.typ].func(frameRight,widget.actualWidget.right.page,widget.appConfigured[slot])
		else
			print("---------  Error w_right")
		end
	end
--			tele2(widget)
end




																			-- ************************************************
																			-- ***		     "display handler"					*** 
																			-- ************************************************
local function paint(widget)
	
	if not(widget.configured) then											-- one time config; cant be executed during create cause window size not availabe then
		widget.configured = frontendConfigure(widget)	
	else																	-- run apps only in case main was configured

		-- main calls:	
		w_left(widget)
		w_right(widget)
		resetEvnt(widget)													-- delete event stati not needed
		
	end
end



																			-- ************************************************
																			-- ***		     configure widget				*** 
																			-- ************************************************
local function configure(widget)

	widget.language = getLang()															-- refresh config language
	local line
	local panel
	local parameter ={}	
	local paraSub={}	
	local value
	
	resetAppConfigFlag(widget)															-- enforce re-init, things may have changed

	-- **************   waiting for 1.5 implementation   *************
--[[
	-- https://github.com/FrSkyRC/ETHOS-Feedback-Community/issues/2073
	https://github.com/FrSkyRC/ETHOS-Feedback-Community/issues/1349				.. invalidate/wakeup
	line = form.addLine("Line1 before panel")

	panel = form.addExpansionPanel("Line1")
		line = form.addLine("Line1 inside panel", panel)
		line = form.addLine("Line2 inside panel", panel)
		--panel:open(false) -- by default the panel is open, let's keep it closed!
]]

	for index=1,#widget.conf do
		parameter = widget.conf[index]											-- get complete Formline
		if parameter[2] == createSubWidgetField then							-- we got an subwidget choice field
			handleWidgetTree(parameter,widget,fields,index)						-- built complete "app incl. subform" fields
		else
			line = form.addLine(widget.conf[index][1])	
			field = parameter[2](line, parameter) 
			fields[#fields + 1] = field		
		end
	
	end
	
end


																			-- ************************************************
																			-- ***		 change to new selected app			*** 
																			-- ************************************************
local function changeApp(frm,selected,widget)
																	-- reset app config status
	widget.actualWidget[frm] 			= {typ=handler , page = 1, 	maxpage = layout[handler ].maxpage  }			-- set actual app parameters ; typ = top/center/bottom etc..
	widget.widgetSelect[frm].running	= selected																	-- flag change app was finished

end
		


																			-- ************************************************
																			-- ***		     "background loop"				*** 
																			-- ************************************************

local function wakeup(widget)


	if initAppConfig == false then											-- in case user changed configuration during runtime >> trigger reconfig of sub-apps
			resetAppConfigFlag(widget)
			initAppConfig = true
	end
		
		
	local frmList ={
					"left"
					}
	if WIDGET_MODE ~= SINGLE_WID then 						-- add entry in case multi frame handling
		frmList[2] = "right"
	end
	
	

	if handler > 0 then 
		-- **********   new page selected:
		
		if handler == LEFT_1 then																	-- frame1 left: page -1
			widget.actualWidget.left.page = widget.actualWidget.left.page - 1
			if widget.actualWidget.left.page < 1  then
				widget.actualWidget.left.page =  widget.actualWidget.left.maxpage
			end
			
		elseif handler == RIGHT_1 then																-- frame1 right: page +1
			widget.actualWidget.left.page = widget.actualWidget.left.page + 1
			if widget.actualWidget.left.page > widget.actualWidget.left.maxpage then
				widget.actualWidget.left.page = 1
			end

		elseif handler == LEFT_2 then																	-- frame2 left: page -1
			widget.actualWidget.right.page = widget.actualWidget.right.page - 1
			if widget.actualWidget.right.page < 1  then
				widget.actualWidget.right.page =  widget.actualWidget.right.maxpage
			end
			
		elseif handler == RIGHT_2 then																-- frame2 right: page +1
			widget.actualWidget.right.page = widget.actualWidget.right.page + 1
			if widget.actualWidget.right.page > widget.actualWidget.right.maxpage then
				widget.actualWidget.right.page = 1
			end
			
		end
	

	
		for i = 1,#frmList do
			local frm = frmList[i]
			if widget.widgetSelect[frm].running ~= widget.widgetSelect[frm].selected then			-- change ("left" frame) app detection
				changeApp(frm,widget.widgetSelect[frm].selected,widget)								-- call change of active app
			end
		end
	end
	
	handler =  0																					-- reset handler
	lcd.invalidate()

end



local function menu(widget)					-- menu handler

end

																			-- ****************************************************
																			-- ***		     read widget config             *** 
																			-- ***	if subApp identified, load lang file     ***
																			-- ****************************************************
local function read(widget)
	local index,indx2
	local lookup = defApplist()


	--************************	
	--   read header lines
	--************************	
	for index = 1,OFFSET do							
		widget.conf[index][3] = storage.read(widget.conf[index][1])	
		if debugConf then print("read header",index,widget.conf[index][3]) end
	end

	--************************	
	--   read App selection lines
	--************************		

--	local numSubFormItems	= 6												-- number of choice lines (subWidgets / Apps..) with dependent forms
	local numSubFormItems	= #widget.conf	- OFFSET						-- number of choice lines (subWidgets / Apps..) with dependent forms

	
	for index = 1+OFFSET,OFFSET+numSubFormItems do							--  Apps fields	
		widget.conf[index][3] = storage.read(widget.conf[index][1])			-- read Value; represents return value of widget choice list	

		local value = lookup[widget.conf[index][3]][2]						-- value represents return value of widget choice list
		if debugConf then print("read App:",index,widget.conf[index][3],"Value:",value) end
		reAssignWidgets(value,index,appIndex,widget)										-- assign subApp
	end
	
	
	--************************	
	--   read app specific formlines
	--************************		
	for index = 1,#widget.subForm do										--  loop app specific sub-config; 1=app01, 3=app03 ....
		if #widget.subForm[index] > 0 then									-- only if entries exist (nothing in case appindex = 1)
			for indx2 = 1,#widget.subForm[index]	do	
				local appIndex = index-OFFSET

			if widget.subForm[index][indx2][1] == "  Cv Input-Src" then			-- handling source
				tmpSrc = storage.read("souce")
				
				widget.subForm[index][indx2][3] = tmpSrc
				widget.subConf[index][indx2] 	= tmpSrc

			else
--				widget.subForm[index][indx2][3] = widget.subForm[index][indx2][1])
				local readVal = storage.read("dummy")
				widget.subForm[index][indx2][3] = readVal
				if debugConf then print(" read subconf Val",index,indx2, readVal) end
				widget.subConf[index][indx2] = readVal
				-- widget.subConf[index][indx2] = widget.subForm[index][indx2][3]
				-- local readVal = widget.subForm[index][indx2][3]

				if readVal == nil then
					readVal = widget.subForm[index][indx2].default
				end

			end

			end
		end
	end
													
end		


																			-- ************************************************
																			-- ***		     write widget config 	   		*** 
																			-- ************************************************
local function write(widget)
	local index,indx2

	--************************	
	--   write header lines
	--************************
	for index = 1,OFFSET do
		local value = widget.conf[index][3]									
		if value == nil then value = 1 end
		storage.write(widget.conf[index][1], value)
		if debugConf then  print("write header",widget.conf[index][1],  "Val:",value) end
		
	end

	--************************	
	--   write App selection lines
	--************************			
	for index = 1+OFFSET,widget.numItems do										-- selective items (apps)
		value = widget.conf[index][3]	
		if value == nil then value = 1 end									-- 1=nothing selected
		if debugConf then print("write App",widget.conf[index][1], "Val:", value) end
		storage.write(widget.conf[index][1], value)
	end

	--************************	
	--   write app specific formlines
	--************************		
	for index = 1, #widget.subForm do										-- browse through all subforms
		if #widget.subForm[index] > 0 then										-- only if entries exist (nothing in case appindex = 1 = noApp)
			for indx2 = 1,#widget.subForm[index]	do							-- browse through all subform lines of an app
				--if debugConf then 	print("write sub index",index,indx2) end
				subItem = widget.subForm[index][indx2][1]						-- get Item
				if subItem ~= nil then
					value = widget.subForm[index][indx2][3]	
					if value == nil then 
--						value = 1 
					end
					-- if debugConf then print("writeSub",index, subItem, value) end
					if debugConf then print("   subconf Val",index,indx2,widget.subConf[index][indx2], "Val:",value) end
					widget.subConf[index][indx2] = value						-- cache saved value in case of form refresh
					storage.write(subItem, value)								-- save item
				end
			end
		end
	end

end




local function  appSelector(selection,running,frame)
	local lookupTbl = {}
	lookupTbl["left"] 	= {TOP_1,CENTER_1,BOTTOM_1}
	lookupTbl["right"]	= {TOP_2,CENTER_2,BOTTOM_2}
	
	local ok = false
	local selected = running

	
	if selection == "prev" then
		repeat								-- select previous "available" app (jump nil assigments)
			selected = selected - 1	
			if selected == 0 then
				selected = NUMWIDGETS		-- jump to last one					
			end
			print("label prev",selected,widgetAssignment[lookupTbl[frame][selected]].label)
			if widgetAssignment[lookupTbl[frame][selected]].label ~= "EMPTY" then ok = true end
		until ok
	else
		repeat								-- select previous "available" app (jump nil assigments)
			selected = selected + 1	
			if selected > NUMWIDGETS then
				selected = 1							
			end
			print("label nxt",selected,widgetAssignment[lookupTbl[frame][selected]].label)
			if widgetAssignment[lookupTbl[frame][selected]].label ~= "EMPTY" then ok = true end
		until ok		
	end
	handler = lookupTbl[frame][selected]
	return selected
end



local function widgetevent(category,value,x,y)
	local evnt = { 	category = category,
					value = value,
					x = x,
					y=y
					}

	return evnt
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
		if value == TOUCH_END then													-- evaluate menu handler
			widget.touch.X=x
			widget.touch.Y=y
			-- ****    define touch area   *******
			
					--    widget selection
			local y1 = 		widget.h * 0.2											
			local y2 = 		widget.h * 0.8											
			local y3 = 		widget.h		
				
									--    page selection
			local yy1 = 		widget.h * 0.4												
			local yy2 = 		widget.h * 0.6												
			local yy3 = 		widget.h
				

			---- definitions in case of mode=SINGLE_WID
				-- select widget#1 nxt / prev. widget) area
				local xWidth= 	0.3		
				
				local x0 = 0
				local x1 = 		widget.w  * 0.4											
				local x2 = 		widget.w  * 0.6											
				local x3 = 		widget.w
				

				local xx0 = 0
				local xx1 = 		widget.w  * 0.2				
				local xx2 = 		widget.w  * 0.8			
				local xx3 = 		widget.w				
			
			if WIDGET_MODE ~= SINGLE_WID then 								-- adopt touch area

				-- eval area for dual widget mode
				-- select widget#2 nxt / prev. widget area
				 xWidth= 	0.15
				
				 x0 	= 	0
				 xEnd 	= 	widget.w /2
				 x1 	= 	x0+ (widget.w * xWidth)										
				 x2 	= 	xEnd - (widget.w * xWidth)										

				

				 xx0	= 	xEnd
				 xxEnd	= 	widget.w			
				 xx1 	= 	xx0+ (widget.w * xWidth)			
				 xx2 	= 	xxEnd - (widget.w * xWidth)


			
			end																			
			
			
			-- ****     check if other app was selected "left" / single widget   ********
			
			if x > x1 and x < x2	then											
			print("App actual LEFT",widget.widgetSelect["left"].selected)
				if 		y < y1  			then 									--  "prev widget" was pressed
					widget.widgetSelect["left"].selected = appSelector("prev",widget.widgetSelect["left"].running,"left")
					--widget.appConfigured = false										-- enforce re-init of active (maybe config of non active has changed interim)
				elseif	y > y2 and y < y3 	then 									-- "next" choosen
					widget.widgetSelect["left"].selected = appSelector("next",widget.widgetSelect["left"].running,"left")
				--	widget.appConfigured = false											-- enforce re-init of active
				end					
				print("AppSel LEFT",handler,widget.widgetSelect["left"].selected)
				return true
			end

			
			-- ****     check if other app was selected "right" widget  ********

			if WIDGET_MODE ~= SINGLE_WID and x > xx1 and x < xx2	then											-- check if other app was selected "left"
			print("App actual RIGHT",	widget.widgetSelect["right"].selected)
			if 		y < y1  			then 									--  "prev widget" was pressed
					widget.widgetSelect["right"].selected = appSelector("prev",widget.widgetSelect["right"].running,"right")
					--widget.appConfigured = false									-- enforce re-init of active (maybe config of non active has changed interim)
				elseif	y > y2 and y < y3 	then 									-- "next" choosen
					widget.widgetSelect["right"].selected = appSelector("next",widget.widgetSelect["right"].running,"right")
				--	widget.appConfigured = false										-- enforce re-init of active
				end					
				print("AppSel RIGHT",handler,widget.widgetSelect["right"].selected)
				return true
			end


			-- ****     check if another page was selected within a widget widget  ********	
			
			if	y > y1 and y < y2 	then 											-- check if new page was selected 
				print("check new page",x,y,x < x1,x > x2 and x < xEnd,	x > xx0 and x < xx1,x > xx2 and x < xxEnd)
				if 	x < x1 then 
					handler = LEFT_1												-- so check x axis and decide if "next page" was pressed
				elseif 	x > x2 and x < xEnd then 
					handler = RIGHT_1	
				elseif 	x > xx0 and x < xx1 then 	
					handler = LEFT_2
				elseif 	x > xx2 and x < xxEnd then 
					handler = RIGHT_2					
				end
				widget.evnt = { category = category, value = value,	x = x,	y=y	}  	-- cache events for apps / sub widgets
				return true
			end	
			
			
		end
      --  return true
    else
     --   return false
    end
	
	if handler == 0 then
		widget.evnt = { category = category, value = value,	x = x,	y=y	}  			-- cache events for apps / sub widgets
		return true
	else
		return true
	end
end


																			-- ***		     init widget	   		*** 
																			-- ************************************************
local function init()
 system.registerWidget({key="unow01", name=name, create=create, wakeup=wakeup, paint = paint, configure=configure, event=event, read=read, write = write})
end

return {init=init}