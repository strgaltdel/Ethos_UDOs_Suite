--  Udos Ethos Suite
--  Rev 1.2

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

-- Revisions
-- 1.0	initial test roll out
-- 1.1	try to avoid multiple lib loads (require won't work !)
-- 1.2  2023 August
--		major switch to one codebase for single / dual / dual&topbar application
--		support of topBar frames  
--		choice of multiple topbars including parameters
--		layout variant adopted for 3 frames / fullscreen support (bad performance scaling of running multiple lua widgets on a "heavy" model template, so create "one 4 all")
--		enable widget dependent background handler
--		support of default app-config parameters
--		minor optimization of the data model
--		some performance optimization
--		config handler now stores slot directly, not ListIndex of app
-- 		solved bug in case user starts with app02 and leaves app01-slot empty
--		some optimization of data persistence
--		delete older remark & debug lines
--		some index rework




--		to do:  
--					consolidate indizes
--					delete unn. prints


--		finished
--					index failure on app deletion, 
--					background failure
--					dedicated topBar choiceList,
--					delete App1r		>> execute remains 
--					change app into modelfinder >> background failure / lib not loaded
--					no app, only top defined >> error
--					no topBar refresh
--					more index rework
--					check single codebase usage
--					predef standard values for widgets
--					TEXT const for topBar / snapfl.. timer ..
--					consolidate topBar libs
--					garbage collection
--					after very 1st config restart needed		>> 1438 attempt to indexnil value
--					handle neg timers
--					parametric background function call
--					modelfind save/load routines
--					topbar full: exchange fixed lsw# vs name
--					right widget navigation ??

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
-- setCurve                  	not used
-- **************************************************************************************************






--[[ how to add widget:

(1) load lua file in section "load "widgets / functions" "
		loaded_chunk = assert(loadfile("/scripts/libUnow/tele1.lua"))
		loaded_chunk()
		
(2) assign widget to frame in section "assign all available widgets to corresponding frames"
			[TOP_1] 	= {func = function(frame,page) tele1(frame,page) 		end, maxpage = 1} >> TOP= first widget (TOP,CENTER,BOTTOM) _1=LEFT Frame (_2=right frame); or choose "TOPLINE" for header

(3) in case widget should be shown by start >> assign in section "assign start condition "
			local startwidgetL = TOP_1			-- L = left frame




** indizes  *******
	 
	  appUID				1..x 			uID for apps
	  confIndx				1..y 			sequential index/order of saved items, read/write handler
	  slot/assignment		1,2..6 &7		a selected app is assigned to a fixed slot which determines the "position" of the app within the frames 
											we have a max of 7 slots, so it has a value between 1 and 7
											Left frame: TOP_1 (1), CENTER_1 (2), BOTTOM_1 (3),      RIGHT frame: TOP_2 (4)......TOPBAR (7)
											used by handler & layout array etc..
	  appListIndex			1..name			used in selection list of apps which can be choosen
											position of app doesn't represent appUID, so we have to use another index
													
	  appList/choiceList		1..x		choice list index see "defApplist()", which supports backward search; 1="---"

 
** arrays  **********
	
  	  widgetList:									unsorted list of available apps; including some parameters , 
	  widgetAssignment								every "frame" has his own "app-range" with "slots"
													e.g. one frame, so we have three apps in slots "Top_1", "Center_1", "Bottom1"  equals slot 1,2,3
													these "slots" like "1","2"...are assigned to apps by widgetAssigment array
													
													another possible config (three frames in a fullscreen environment) could be		(future development)			
													topwidget	: slot "Topline"		(only one app possible)
													left Frame	: slot "Top1..Bottom1"	(three apps)
													rightFrame	: slot "Top2..Bottom2"	(three apps)
	

	  widget.conf									main configuration "Formlines"; some major parameter (theme etc..) and  which apps are selected in which slots
	  widget.subForm [index][line]					"description" of additional app Parameters; sourced from function getSubForm (file suite_conf.lua) 
	  widget.subConf [index] [formlineValue]		sub-configuration of apps (dedicated variables/params) of an app in form (config handler) 
													filled during read model & config handler
													
 	  widgetArray									the indizez of the single "slots": local widArray = {TOPLINE, TOP_1,CENTER_1 ,BOTTOM_1,TOP_2,CENTER_2 ,BOTTOM_2 } ; kind of lookup table
 
 


 
 ]]

 local PERFMON <const> = false					-- true = activate performance measurements
  
 local SINGLE_WID <const>	 = 1
 local Dual_WID <const>		 = 2
 local TOPBAR_WID <const>	 = 3
												-- defines global "management" mode of this "wrapper":
 --local WIDGET_MODE <const>	 = Dual_WID
 local WIDGET_MODE <const>	 = TOPBAR_WID
											--		1 = single frame (e.g. half area of the screen)
											--		2 = two frames within one ethos widget, e.g. fullscreen with/without TOPLINE
											--		3 = two frames AND an individual topline , Ethos 100% fullscreen  
  
  
 local KEY 					= ""			-- Mode dependent Widget key (used by init)
 local NAME					= ""			-- Mode dependent Widget name
 
 if 	WIDGET_MODE == 1 then
		KEY  = "unowS1"
		NAME = "Udos Suite 1"
 elseif	WIDGET_MODE == 2 then
 		KEY  = "unowS2"
		NAME = "Udos Suite 2"
 else
		KEY  = "unowS3"
		NAME = "Udos Suite 3"
 end 
 
  
  
  
 local OFFSET <const> 			= 1			-- # config -header items in widget configuration: only one (theme)
 local NumAPPS <const>  		= 6			-- summed number of apps in main frames (excluding topbar which hosts one)
 local NumAppsPerFrm <const> 	= 3			-- number of apps per Frame (is NumAPPS x 2)
 


local MULTI 		= false					-- widget runs in "Multi frame mode" ; more than one frame
local TOP_MODE 	= false					-- widget handles topbar frame
local TOP_OFFSET = 0						-- #additional "header" Parameters in case topbar is hosted 
  
-- so let's calculate running mode of the widget
if WIDGET_MODE > SINGLE_WID then
	MULTI = true
end
  
if WIDGET_MODE == TOPBAR_WID then
	TOP_MODE = true
	TOP_OFFSET   = 1			-- additional Offset in header used by topBar entries
end

 


-- flags to show some debug infos

 local debug1 	= false			-- monitor create
 local debug2  	= false			-- monitor paint
 local debug3  	= false			-- monitor event handler
 local debug4 	= false			-- 
 local debug5   = false			--  
 local debug6 	= false			-- handler
 local debug7 	= false			-- print demoMode
 local debug8	= false			-- FormBuilt
 local debugConf= false			-- write/read config
 local debugReas= false			-- reassign new params/config to widget
 local debugLay = false			-- print layout array parameter
 local debugdump= true			-- dump config in several functions (config etc..)
 
 -- perfmonitor
 local PM_NUM_ENTRIES <const>		= 10					-- averaging over n entries
 local PM_array 					= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
 local PM_last_start				= os.clock()
 local PM_interval					= 0
 local PM_pointer					= 1
 local PM_display					= false
 
 
-- some pathes
local libPath <const>  			= "/scripts/libUNow/"
local widgetPath <const>  		= "/scripts/libUNow/widgets/"
local localPath <const>  		= "/scripts/Modelfind_UN"



local 	fields = {}						-- form fields array

local layout = {}						-- global widget layout-array, defined on 1st run
local layoutSet 		= {}
local widgetconfLine	= {}
local widgetconfArray	= {}
local widgetList 		= {}

local sensors = {}
local param 			= {}	-- only used in topbar / safety widget as global var

--!!local wpath = "/scripts/Tools1/"
local suitePath = "/scripts/libUNow/suite/"

local initAppConfig = false					-- flag config has changed, so init apps 
local tmpSrc = nil


-- globals:
-- handler (don't change)
local LEFT_1  <const>  		= 51				-- left  widget "prev page"
local RIGHT_1 <const>		= 52				-- right widget "next page"
local LEFT_2  <const>  		= 53
local RIGHT_2 <const>		= 54


-- slotIndex left  1-3:		1..3 (automated calc in loops)
-- slotIndex right 1-3:		4..6 (automated calc in loops)
-- TOPBAR
local TOP_1  <const>		= 1
local CENTER_1 <const>  	= 2
local BOTTOM_1 <const> 		= 3

local TOP_2   <const>		= 4
local CENTER_2 <const> 		= 5
local BOTTOM_2 <const>  	= 6

local TOPLINE <const>		= 7	
local TOPLINEslot  <const>  = 7

-- display handler
local DISP_X20   <const>	= 1
local DISP_X18   <const>	= 2
local DISP_HORUS <const>	= 3


local NIL <const> 			= 1

local THEMEidx <const>		= 1				-- theme is defined in formline # THEMEidx

local APPidxNil <const>	= 98			-- represent no configured app in slot

-- seq. list of widget handler (needed for loops)
local widArray = {TOPLINEslot, TOP_1,CENTER_1 ,BOTTOM_1,TOP_2,CENTER_2 ,BOTTOM_2 }

local widgetAssignment = {}			-- assignment / definition sub widgets
local handler = 0

					


																			-- ************************************************
																			-- ***		     name widget					*** 
																			-- ************************************************
local translations = {en=NAME}

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
		
		TOPLINEslot,		-- TopBar		
	} 
  return lookup[index]
end


																			-- ************************************************
																			-- ***	        debug purpose                 *** 
																			-- ***       dump actual subApp Config          *** 
																			-- ************************************************
local function dumpHeaderConf(widget)
	print("----------   dump actualheader/main config  ----------")
	local hdrIndex = #widget.conf
	for i = 1,hdrIndex do							-- loop slot
		print("dump HdrConf  index, item, value",i,widget.conf[i][1],widget.conf[i][3])
	end
end


																			-- ************************************************
																			-- ***	        debug purpose                 *** 
																			-- ***       dump actual subApp Config          *** 
																			-- ************************************************
local function dumpSubConf(widget)

	print("----------   dump actual app config  ----------")
	local slot,item
	for slot = 1,NumAPPS do							-- loop slot
		print("    slot, nums (subForm):",slot,#widget.subForm[slot])
		for item = 1,#widget.subForm[slot] do		-- loop FormLines per app
			print("dump appConf  slot, item, value"," ",slot,item,widget.subConf[slot][item])
		end
	end
	
	if WIDGET_MODE == TOPBAR_WID then
		
		for item = 1,#widget.subForm[TOPLINE] do		-- loop FormLines per app
			print("dump appConf  slot, item, value"," ",TOPLINE,item,widget.subConf[TOPLINE][item])
		end
	end

end

local function dumpConf(widget)
--	dumpHeaderConf(widget)
--	dumpSubConf(widget)
end



local function dumplayout(slot,widget,subCnfOffset )
	local frm="left"
	if slot > BOTTOM_1 and slot < TOPLINE then
		frm = "right"		
	end
	
	print("frame",frm)
	print("layout:",		slot)
	print("function:",		widgetAssignment[slot].mainfunc)
	print("configured:",	widget.appConfigured[slot])
	print("txt sample:",	widget.appTxt[slot])	
	print("  idx:",			widget.widgetSelect[frm].selected+subCnfOffset)
	print("  subConf:",		widget.subConf[widget.widgetSelect[frm].selected+subCnfOffset])
	print("conf:",			widget.conf[widget.widgetSelect[frm].selected+OFFSET][3])
	print("maxpage:",		widgetAssignment[slot].maxpage)
	
	if slot == TOPLINE then
		print("TOPLINE EXTRA")
		print("sensors",sensors)
		print("para",widget.param[TOPLINE][1])
	end
end


local function loadApp(file)
				loaded_chunk = assert(loadfile(file ))
		--[[		
				local fLen = string.len(file)
				file = string.sub(file,1,fLen-4)
				require(widget.wpath.. file)
		--]]	   
				loaded_chunk()
				
end





local function assignLayout(widget)
 -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!     this is the main declaration of the whole wrapper     !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	local subCnfOffset = 0 						-- offset sunbconf index for right widget
	
	if debugLay then
		dumplayout(TOPLINE,widget,subCnfOffset)
	end

	if not pcall(function() 
						local lookup = defApplist()
						-- *******************************                         assign all selected widgets to corresponding frames (top,left,right) incl.parameters                                                                       ***************************		
						layout = {
							-- call widget specific function from global namespace  			
				--			[appSlot]				= {func = function(frame,page) >> call     functionName							(frame,page,widget.layout 		.... end, maxpage = 1},				--  [*_1] = frame-left: list of "widgets"

							[TOPLINE]				= {func = function(frame,page)	return(_G[widgetAssignment[TOPLINE].mainfunc](frame,page,	widget.layout,widget.theme,widget.touch,widget.evnt,widget.subConf[TOPLINE],	widget.appConfigured[TOPLINE],	widget.appTxt[TOPLINE],		widget,sensors,widget.param[TOPLINE]																																))	end, maxpage = 1},		-- call widget specific function from globa

							}
							
						if widget.actualWidget.left.typ > 0 then			-- check if there is a "startwidget" evaluated
							layout[TOP_1] 			= {func = function(frame,page)	return(_G[widgetAssignment[TOP_1   ].mainfunc]	(frame,page, 	widget.layout,widget.theme,widget.touch,widget.evnt,	widget.subConf[widget.widgetSelect["left"].selected],				widget.appConfigured[TOP_1],	widget.appTxt[TOP_1],		widget, widget.conf[widget.widgetSelect["left"].selected+OFFSET][3]	))	end, maxpage = widgetAssignment[TOP_1   ].maxpage}
							layout[CENTER_1]		= {func = function(frame,page)	return(_G[widgetAssignment[CENTER_1].mainfunc]	(frame,page,	widget.layout,widget.theme,widget.touch,widget.evnt,	widget.subConf[widget.widgetSelect["left"].selected],				widget.appConfigured[CENTER_1],	widget.appTxt[CENTER_1],	widget, widget.conf[widget.widgetSelect["left"].selected+OFFSET][3]	))	end, maxpage = widgetAssignment[CENTER_1].maxpage}
							layout[BOTTOM_1]		= {func = function(frame,page)	return(_G[widgetAssignment[BOTTOM_1].mainfunc]	(frame,page,	widget.layout,widget.theme,widget.touch,widget.evnt,	widget.subConf[widget.widgetSelect["left"].selected],				widget.appConfigured[BOTTOM_1],	widget.appTxt[BOTTOM_1],	widget, widget.conf[widget.widgetSelect["left"].selected+OFFSET][3]	))	end, maxpage = widgetAssignment[BOTTOM_1].maxpage}
						end
						
						if MULTI and widget.actualWidget.right.typ > BOTTOM_1 then
							layout[TOP_2]			= {func = function(frame,page)	return(_G[widgetAssignment[TOP_2  ].mainfunc](frame,page,	widget.layout,widget.theme,widget.touch,widget.evnt,	widget.subConf[widget.widgetSelect["right"].selected+subCnfOffset],	widget.appConfigured[TOP_2],	widget.appTxt[TOP_2],		widget, widget.conf[widget.widgetSelect["right"].selected+OFFSET][3]	))	end, maxpage = widgetAssignment[TOP_2].maxpage}				--  [*_2] = frame-right:  list of "widgets"
							layout[CENTER_2]		= {func = function(frame,page)	return(_G[widgetAssignment[CENTER_2].mainfunc](frame,page,	widget.layout,widget.theme,widget.touch,widget.evnt,	widget.subConf[widget.widgetSelect["right"].selected+subCnfOffset],	widget.appConfigured[CENTER_2],	widget.appTxt[CENTER_2],	widget, widget.conf[widget.widgetSelect["right"].selected+OFFSET][3]	))	end, maxpage = widgetAssignment[CENTER_2].maxpage}
							layout[BOTTOM_2]		= {func = function(frame,page)	return(_G[widgetAssignment[BOTTOM_2].mainfunc](frame,page,	widget.layout,widget.theme,widget.touch,widget.evnt,	widget.subConf[widget.widgetSelect["right"].selected+subCnfOffset],	widget.appConfigured[BOTTOM_2],	widget.appTxt[BOTTOM_2],	widget, widget.conf[widget.widgetSelect["right"].selected+OFFSET][3]	))	end, maxpage = widgetAssignment[BOTTOM_2].maxpage}
						end		

				end ) then
					print("********************  ERROR layout definition   ***********************")
	end

	return layout
end


																			-- ****************************************************
																			-- ***   which is the 1st configures app in frame?	***									
																			-- ****************************************************	

local function checkStart(widget,frame)

	local confIndex = 0
	local startApp  = 0
	local startIndex = OFFSET + TOP_OFFSET	+1			-- here starts index in left frame
	
	if frame == "right" then
		startIndex = startIndex + 3						-- add offset of 3 apps in left frame
	end

	for confIndex = startIndex+2,startIndex,-1 do		-- backwards check to detect 1st configured app in frame
		--print("   ***   check startapp loop, idx,appID",confIndex,widget.conf[confIndex][3])
		if widget.conf[confIndex][3] ~= APPidxNil then
			startApp = confIndex- OFFSET - TOP_OFFSET
		end
		
	end

	return startApp
end


																			-- ************************************************
																			-- ***   determine start conditions 
																			-- ***   (which app in which slot should be started on first loop)		***									
																			-- ***  (I)  select first configured app in configuration     
																			-- ***  (II) configure actual widget  																			
																			-- ************************************************	


local function initLayout(widget)
		
		widget.actualWidget["left"]		= {typ=0 , page = 0, 	maxpage = 0  }			-- init
		widget.actualWidget["right"] 	= {typ=0 , page = 0, 	maxpage = 0  }			-- init
		
		widget.widgetSelect.left.running 	= checkStart(widget,"left")	
		widget.widgetSelect.left.selected	= widget.widgetSelect.left.running
		
		local startwidgetL = widget.widgetSelect.left.running

		if startwidgetL > 0 then
			widget.actualWidget["left"] 		= {typ=startwidgetL , page = 1, 	maxpage = widgetAssignment[startwidgetL].maxpage  }
		end
		
		-- same for right frame
		if MULTI then
			widget.widgetSelect.right.running 	= checkStart(widget,"right")
			widget.widgetSelect.right.selected	= widget.widgetSelect.right.running
			
			local startwidgetR = widget.widgetSelect.right.running			
			if startwidgetR > BOTTOM_1 then 
				widget.actualWidget["right"] 		= {typ=startwidgetR , page = 1, 	maxpage = widgetAssignment[startwidgetR].maxpage  }
			end
			
		end

		-- assign "slotted" array (=layout) with descriptions / parameters of all configured apps in corresponding widget frames 
		layout = assignLayout(widget)
end





																			-- ************************************************
																			-- *** dedicated handling for app selector line	*** 
																			-- *** needed because line value is not 		***
																			-- *** 			"what you see" in form			***
																			-- *** sequence defApplist doesn' correspondent ***
																			-- ***    				to appUID				***
																			-- ***  every List gets his 
																			-- ************************************************
local function getAppSelectionValue(parameter)
  local appUID = parameter[3]
  local search = "standard"
  local appListIndex = defApplist(appUID,search,nil)
  return appListIndex
end


local function getTopBarSelectionValue(parameter)
  local appUID = parameter[3]
  local search = "standard"
  local appListIndex = defTopBarlist(appUID,search,nil)
  return appListIndex
end



																			-- ************************************************
																			-- ***   begin of form handling functions		***									
																			-- ************************************************		

local function getValue(parameter)
  if parameter[4] == nil then
    return parameter[4]							--default
  else
    return parameter[3]
  end
end

																			
-- called by "createXY" formline to set a value
local function setValue(parameter, value)
  parameter[3] = value
  initAppConfig = false						-- trigger re init of apps
end



-- for future use; expands array
local function insertArray(tableSrc,index,inserts)
	for i=1,#inserts do
		table.insert(tableSrc,index,inserts[i])	
	end
	return tablesrc
end



-- "reset" subForm in case new app was choosen
local function clearSubConf(slot,widget)
		if debug8 then print("execute CLEAR SUBCONF for Slot#",slot) end
		if slot ~= nil then
			widget.subConf[slot] ={}
			for i= 1,10 do
				widget.subConf[slot][i]=nil			-- INIT
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

-- LSW choice list handling
-- we want to store the LSW uid, so that lsw's can be rearanged
-- we want a choice list of names, which returns a number if an entry was choosen
-- so we have to convert vice / versa
local function createChoiceLSWField(line, parameter)
   local field = form.addChoiceField(line, nil, parameter[5], 	function() 
																-- get: convert lsw-uid(stored val) into entry num (src:member) of lsw-ChoiceList
																	local value 	= getValue(parameter):member()
																	return value
																end, 
																-- set: convert selected return value (lsw, int) of lsw-ChoiceList into lsw-uid
																function(lsw) 
																	local value = system.getSource({category=CATEGORY_LOGIC_SWITCH, member=lsw})
																	setValue(parameter, value) 
																end)
	return field
end


local function createChoiceAppField(line, parameter)
   local field = form.addChoiceField(line, nil, parameter[5], function() return getValue(parameter) end, function(value) setValue(parameter, value) end)
	return field
end

local function createTextButton(line, parameter)
  local field = form.addTextButton(line, nil, parameter[4], function() return setValue(parameter,0) end)
  return field
end

local function createTextField(line, parameter)
  local field = form.addTextField(line, nil, function()   return getValue(parameter) end, function(newValue)   setValue(parameter, newValue) end)
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


local function createColorPicker(line, parameter)
  form.addColorField(line, nil, function()   return getValue(parameter) end, function(newValue)  setValue(parameter, newValue) end)  
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
	end
	return chArray
end



-- ************************************************
-- "helper" for "getCurves()" to sum up existent curves
-- ************************************************
local function entryExists(entry)
 if entry ~= nil then 
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
		local input =  model.getCurve(i-1)					-- try to get a curve

		if entryExists(input) then								-- successfull ?
			chArray[i][1]=input:name()
			chArray[i][2]=i										-- choice list must start using 1 !! >> in curve you will have to substract value by !
		else
		--print("nil",i)
		end
	end
	return chArray
end



-- ************************************************
-- create LSW choice list
-- ************************************************
local function getLSWs()
	local index = 0
	local chArray = {}
	for i=1,100 do												-- choice list must start using 1 !!
		chArray[i]={}
		local input =  system.getSource({category=CATEGORY_LOGIC_SWITCH, member=i})				-- try to get a lsw

		if entryExists(input) then								-- successfull ?
			chArray[i][1]=input:name()							-- store name
			chArray[i][2]=i										-- choice list must start using 1 !! >> in curve you will have to substract value by !
		else
		--print("nil",i)
		end
	end
	return chArray
end



-- *******************************************************************************
-- translates/converts table entries from file (config form definitions) into functional ones
-- unfortunately direct processing of create... statements not possible
-- called by subFormBuilt, createSubWidgetField, read handler
-- *******************************************************************************
local function migrateForm(formTbl)
	
  local channelList={}
  local lookup ={
	-- suite.conf		= translated into lua form.method
	createNumberField 	= createNumberField	,
	createTextButton 	= createTextButton	,
	createBooleanField 	= createBooleanField,
	createChoiceField 	= createChoiceField	,
	createCurveChoice	= createChoiceField	,
	createChannelChoice	= createChoiceField	,
	createLswChoice		= createChoiceLSWField,
	createSourceField	= createSourceField	,
	createFilePicker	= createFilePicker ,
	createSwitchField	= createSwitchField ,
	createTextOnly 		= createTextOnly,
	createTextField		= createTextField,
	createColorPicker	= createColorPicker,
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
					
				elseif  func == "createLswChoice" then
					print("----------------    detected LSW choice")
					formTbl[i][5] =getLSWs()							-- "inject" actual curve list as choicelists
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



local function assignEmpty(widget,slot)								-- "subFunction" to assign an empty slot
		widgetAssignment[slot] 		= widgetList[APPidxNil]			--"empty" index in widgetlist
		widget.appTxt[slot] 		= widgetList[APPidxNil].txt
		widget.subForm[slot]	= {}
end



--  refresh widget assignment:
--	txt fields in slot gets corresponding text
--	subform items are prepared 						widget.subForm[slot]
--  slot is assigned to the new app					widgetAssignment[slot]
local function reAssignWidgets(configIndex,appUID,widget)

		local slot = configIndex-OFFSET	-TOP_OFFSET					-- index which starts by 1 (=Appo1L); o identifies topline
		if slot == 0 then slot = TOPLINE end

		if debugReas then print("   REASSIGN WAS CALLED configIndex,appUID,slot",configIndex,appUID,slot) end
		
		if appUID ~= APPidxNil then													-- represents choice list index: so get corresponding subForm if something was selected (1=nothing)
			widgetAssignment[slot] 	= widgetList[appUID]			-- assignindex e.g. "Top_1" slot  =  widgetList[#6]  .label = "setcurve" (#6 = setcurve App)
			widget.appTxt[slot] 	= widgetList[appUID].txt		-- here we load lang specific text !
			if debugReas then print("     assign (slot,appUID..): ",slot,appUID,widgetList[appUID].label) end
			widget.subForm[slot]=migrateForm(getSubForm(appUID,widgetAssignment[slot].txt,widget.language))
		else														-- fill empty assignment with dummy data to ensure persistency
			assignEmpty(widget,slot)
		end
		
end


-- ******************************************************************
-- create a "choose topBar" line in config-Form; 
-- calls some functions, so it has to be placed somewhere further below other create functions
-- ******************************************************************
local function createTopChoiceField(line, parameter,widget)						-- "special" handling in get/set due to defApllist returns not slot value 
   local field = form.addChoiceField(line, nil, parameter[5], 
									function() 
										return getTopBarSelectionValue(parameter)	
									end, 
									
									function(choice)
										local lookup = defTopBarlist()	
										local appUID = lookup[choice] [2]
										local configIndex = OFFSET+1
										setValue(parameter, appUID)
										reAssignWidgets(configIndex,appUID,widget)
										loadApp(widget.wpath.. widgetAssignment[widArray[1] ].File)	-- widgetArray[1] = TOPLINE
										initLayout(widget)
									end
								)
		return field
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
--local function subFormBuilt(parameter,widget,fields,configIndex,appListIdx,slot)
local function subFormBuilt(widget,fields,slot)

--	local widgetIndex = configIndex - OFFSET - TOP_OFFSET
--	if widgetIndex == 0 then widgetIndex = TOPLINE end

	fields[#fields + 1] = field	

	if debug8 then print("       730 subFormBuilt got  slot,  configIndex,  appListIdx:  ".. slot,appListIdx) end

	if #widget.subForm[slot] >0 then															-- subForm=evaluated during "createwidgetfield" ; check if formlines do exist
		for index = 1, #widget.subForm[slot] do													-- browse through lines
			local value = widget.subConf[slot][index]

			widget.subForm[slot][index][3] = value												-- set cached value 
			paraSub 	= widget.subForm[slot][index]											-- get subform line [appEntryNum][corresp.SubFormLine][SubFormLine.Item]

			if not pcall(function() paraSub[3] = widget.subConf[slot][index]  end ) then			-- value "injection" into paraSub[3]
				print("ERROR Config injection")
				paraSub[3] 	= nil
			end

			if paraSub[3] == nil then				-- on 1st built, no value set, so default
					print ("---- subVal empty, default:",widget.subForm[slot][index].default)
					paraSub[3] = widget.subForm[slot][index].default
			end				

			local line 	= form.addLine("   " .. paraSub[1])												-- get line label
			local tmp	= paraSub[2]																	-- type to create
			field		= paraSub[2](line, paraSub) 													-- finally, create field

			if debug8 then print("  648       create appIdx, index,subField,val ", slot, index,line) end

			fields[#fields + 1] = field				
		end
	else
		print("             found empty slot during subForm Built, no subItems defined in widget # "..slot)
	end

end



-- **************************************************************************************************
-- needed in case you want to choose a sub-widget in a FormLine
-- this creates all additional, subWidget dependent Formlines (subForm) after choosing a new sub-Widget
-- subForm definition is loaded prior from file
-- **************************************************************************************************
local function createSubWidgetField(line, parameter,widget,configIndex,slot)							

	if debug8 then  
		print("   770 createSubWidgetField // AppField configIndex, field,val",configIndex,parameter[1],parameter[3])		--para[1] = label, para[3] = value
	end
	
	-- ***** this is the "app main" entry / which app is selected:
	local paraSub = {}
	local field = form.addChoiceField(line, nil, parameter[5], 										-- here we built "main" choiceField for app "line"
			function()																				-- read app selection value
				local returnVal
					
				if slot == TOPLINE then
					returnVal = getTopBarSelectionValue(parameter)
				else
					returnVal = getAppSelectionValue(parameter)
				end
				return returnVal end,
					
			function(choice) 																		-- setValue / set app >> user input induced change of value; so we have to built the whole formsheet from skratch
				local lookup
				if slot == TOPLINE then
					lookup = defTopBarlist()
				else
					lookup = defApplist()
				end

				local appUID = lookup[choice] [2]
				
				setValue(parameter, appUID) 														-- appUID = Choice = selected item from choicelist/defApplist table: 1= nothing
																									-- Part1: "redefine" now actual "Formline" entries (reassign..):
				widget.configured = false																	-- enforce new frontend configure				
																											-- new app was selected, so refresh config menu by using new "app/subwidget" config
				form.clear()																				-- erase old form
				form.invalidate()																			-- request new form			
				clearSubConf(slot,widget)															-- init cache array of actual "app" subValues / configuration		
				reAssignWidgets(configIndex,appUID,widget)
				
				
																									-- Part2: if an app with "additional parameter config" was selected >> evaluate subform entries & create complete new Form (recursive:		
				for configIndex=1,#widget.conf do															-- configIndex: loop all form items, starting with item1 = theme

					parameter = widget.conf[configIndex]													-- get complete configIndex
					if debug8 then print("   1090 create main-configIndex recursive !!",configIndex,parameter[1],createSubWidgetField,parameter[2]) end
					
					if pcall(function() print("** subNums",#widget.subForm[configIndex]) end)  then
						-- OK
					else
						-- ERR
					end
					
					if parameter[2] == createSubWidgetField then											-- here we got an "subform needed"  indication from "widget.conf ", but maybe choosen app has no further params ? 
					
						local slot = configIndex - OFFSET													-- slot for recursive call

						if TOP_MODE then
							slot =	slot -1																	-- one more entry due to TopBar; substract 1 because TopBar(slot7) is placed at first, so 2nd entry must be slot1
							if slot == 0 then slot = TOPLINE end
						end

						local value 		= parameter[3]													-- actual/cached App selection			
						line 				= form.addLine(parameter[1])									-- >> built "app" line	
						local field 		= createSubWidgetField(line, parameter,widget,configIndex,slot)	-- create app configIndex//  Choice-line including functions to refresh form in case of set new "item";  offset because of header items (=1)
						local appListIdx 	= widget.conf[configIndex][3] 			

						if debug8 then 
							print("   858 createSubWidgetField //subFormlines tmp_slot,widgetIndex2 ",slot)
							print("       ******** due to user change, call subformBuilt: para1 , configIndex, slot, appIdx  ",parameter[1],configIndex,slot, appListIdx) 
						end

--						subFormBuilt(parameter,widget,fields,configIndex, appListIdx,slot)	 
						subFormBuilt(widget,fields,slot)
					else
						line = form.addLine(widget.conf[configIndex][1])								-- create main form entries
						field = parameter[2](line, parameter) 
						fields[#fields + 1] = field		
					end	
				end	

	end  )
	return field

end




-- ******************************************************************************************************************************************
-- called by configure: creates one line for app selection and dependent sub-Lines for configuration of choosen app (in case an App was selected)
-- ******************************************************************************************************************************************

local function handleWidgetTree(parameter,widget,fields,configIndex)									-- index = formline sequence
	if debug8 then print("   990 handle widget tree START with index",index) end
	
	local slot = configIndex - OFFSET - TOP_OFFSET														-- 1=app1L..6=app3R; offset because of #header items / 0=topBar >> extra index
	if slot == 0 then 
		slot = TOPLINE 
	end		
	
	local lookup = defApplist()																			-- get ChoiceList

	if widget.conf[configIndex][3] == nil then 															-- on very first run, initiatlize selection
		widget.conf[configIndex][3] = 1																	-- nothing selected
	end
	
	local appUID = widget.conf[configIndex][3]															-- read appUID

	if debug8 then print("   1000 handle widget tree create form level1     configIndex, widgetIdx, slot,  appUID:",configIndex,slot,slot,appUID) end
	
																										-- here we define & call the main entry of the app (app choice)
	line = form.addLine(parameter[1])																	-- >> line label
	local field = createSubWidgetField(line, parameter,widget,configIndex,slot)							-- creates Choice-line including functions to refresh form in case of set new "item";  offset because of header items (=1)
																										-- and now we have to create the app dependent sub entries
	--subFormBuilt(parameter,widget,fields,configIndex,appUID,slot)
	subFormBuilt(widget,fields,slot)
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
	
	local slot, item
	for slot = 1,NumAPPS do													-- loop all apps
	  if #widget.subForm[slot] > 0 then										-- subform exists?
		for item = 1,#widget.subForm[slot] do									-- loop all params in app
			widget.subConf[slot][item] = widget.subForm[slot][item][3]		-- ensure data persistence>> cache formValues Para[3] = value of subform item !!
			if debug8 then print("reconf ",slot,item,widget.subConf[slot][item]) end
		end
	  end
	end
	
	widget.appConfigured[TOPLINE] 	= false	
		
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
--[[		
	require(suitePath.."suite_conf")												-- sub-widget/ "apps"  assignment & config		
	require(libPath.."lib_standards")												-- basic functions
	require(libPath.."lib_relative_draw")											-- functions for "relative draw" / use of percent values instead of absolut pixels / so x,y : 100,100 would be right down corner of a frame
	require(libPath.."lib_getTele")													-- telemetry functions 
	require(libPath.."lib_drawIcons")	
	require(libPath.."lib_FileIO")													-- file IO
--]]

	if not(LIB_SuiteConf) then
		loaded_chunk = assert(loadfile(suitePath.."suite_conf.lua"))						-- sub-widget/ "apps"  assignment & config
		loaded_chunk()
	end
	
	if not(LIB_Standards) then
		loaded_chunk = assert(loadfile("/scripts/libUnow/lib_standards.lua"))
		loaded_chunk()
	end

	if not(LIB_RelDraw) then
		loaded_chunk = assert(loadfile("/scripts/libUnow/lib_relative_draw.lua"))			-- functions for "relative draw"
		loaded_chunk()																		-- use of percent values instead of absolut pixels
																							-- so x,y : 100,100 would be right down corner of a frame	
	else
		print(" ----------    SUITE1: reldraw loaded before -----------")
	end																	
	
																	  
			   

	if not(LIB_GetTele) then
		loaded_chunk = assert(loadfile("/scripts/libUnow/lib_getTele.lua"))					-- telemetry functions 
		loaded_chunk()	
	end
	
	if not(LIB_DrawIcons) then	
		loaded_chunk = assert(loadfile("/scripts/libUnow/lib_drawIcons.lua"))
		loaded_chunk()
	end
	
	if not(LIB_FileIO) then
		loaded_chunk = assert(loadfile("/scripts/libUnow/lib_FileIO.lua"))
		loaded_chunk()
	end
	

	loaded_chunk = assert(loadfile("/scripts/libUNow/widgets/tele_global/sensorlist.lua"))
	loaded_chunk()		
	sensors = defineSensors(widget)

	
	
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
	for i=1,NumAPPS do
		subForm[i]={}																	-- formLines
		subConf[i]={}																	-- cache formLine-values during refresh
		for j= 1,10 do
			subConf[i][j]=nil															-- INIT cache
		end
	end
	subForm[TOPLINE]={}																	-- dedicated TOPLINE (fixed index) handling
	subConf[TOPLINE]={}
	for j= 1,10 do
		subConf[TOPLINE][j]=nil			
	end
	
	local apps = {}																		-- available apps & index
	local apps_template = defApplist()													-- app selection list (temp only)
	for i= 1,#apps_template do
		apps[i] =  {apps_template[i][1],i}												-- >> app selection list including ondex
	end
	
	local topbars = {}	
	local topbars_template = defTopBarlist()
	for i= 1,#topbars_template do
		topbars[i] =  {topbars_template[i][1],i}										-- >> topbar selection list including ondex
	end
	
	local confTxt = {																	-- configuration text 
	--	   de				en
		{"Schema",		"Theme"}
		}
	

	-- ******************   This is the definition of our "main" Config Form :   ********************************************	
	--*******************	para 3 in App fields will contain the widget # (number of choicelist )
	-- unfortunately no lua lib to "append arrays" so "brute force" dedicated defs:
	local conf = {}
	if TOP_MODE then
		conf = {					
			{confTxt[1][language], 		createChoiceField,				nil,	1,	 	{{"dark",1},{"bright",2}}},	
			
--			{"TopLine", 				createTopChoiceField,			nil,	1,		topbars	},
			{"TopLine", 				createSubWidgetField,			nil,	1,		topbars	},
			
			{"App 01L", 				createSubWidgetField,			nil,	1,		apps	},
			{"App 02L", 				createSubWidgetField,			nil,	1,		apps	},	
			{"App 03L", 				createSubWidgetField,			nil,	1,		apps	},
			
			{"App 01R", 				createSubWidgetField,			nil,	1,		apps	},
			{"App 02R", 				createSubWidgetField,			nil,	1,		apps	},	
			{"App 03R", 				createSubWidgetField,			nil,	1,		apps	}
		}
	elseif MULTI then
		conf = {	
			{confTxt[1][language], 		createChoiceField,				nil,	1,	 	{{"dark",1},{"bright",2}}},	
						
			{"App 01L", 				createSubWidgetField,			nil,	1,		apps	},
			{"App 02L", 				createSubWidgetField,			nil,	1,		apps	},	
			{"App 03L", 				createSubWidgetField,			nil,	1,		apps	},
			
			{"App 01R", 				createSubWidgetField,			nil,	1,		apps	},
			{"App 02R", 				createSubWidgetField,			nil,	1,		apps	},	
			{"App 03R", 				createSubWidgetField,			nil,	1,		apps	}
		}
	else
		conf = {		
			{confTxt[1][language], 		createChoiceField,				nil,	1,	 	{{"dark",1},{"bright",2}}},	
						
			{"App 01L", 				createSubWidgetField,			nil,	1,		apps	},
			{"App 02L", 				createSubWidgetField,			nil,	1,		apps	},	
			{"App 03L", 				createSubWidgetField,			nil,	1,		apps	},
		}	
	end
	
	local appTxt = {							-- app specific text, multi language
			TOPLINE	 = {},
	
			LEFT_1 	 = {},
			CENTER_1 = {},
			RIGHT_1	 = {},

			LEFT_2 	 = {},
			CENTER_2 = {},
			RIGHT_2	 = {}			
			}

	local appConfigured = {}					--  app is configured ? if false ; run onetime app-frontendconfigure (called every time anorther app was selectes on frontend) 
			appConfigured[TOPLINE] 	= false
	
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
		widgetSelect.right.selected = 1			-- on start running = selected		
	end	
		
	local touch	= {}							-- widget touch data
	local evnt 	= {}							-- widget event data
		evnt.wheeldwn 	= false
		evnt.wheelup 	= false

	local theme = {}							-- theme definition	
	local com 	= {}							-- com parameters (e.g. touch evnt evaluated in app triggers functon in background)
	
	local numItems = #conf						-- number of lines in "main" form


	local lastWidget = nil						-- widget which was selected on last run

	local layout= {}							-- App/widget specific layout (e.g. topbar)
	local param = {}							-- widget specific parameters / variables (e.g. topbar)
			param[TOPLINEslot]	={}
			param[TOP_1]	={}
			param[CENTER_1]	={}
			param[BOTTOM_1]	={}		
			param[TOP_2]	={}
			param[CENTER_2]	={}
			param[BOTTOM_2]	={}	
	  
	param[TOPLINEslot]["TOP_SafetyTime"] = 0
	
	local timer ={								-- timer for cyclic events
					garbage 	= os.clock(),
		}
	
	local enable = {
		left = true,
		right = true
		}
	
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
		language 	 = language,
		layout 	 	 = layout,
		param		 = param,
		com			 = com,						-- "commmunication" variables between "background" tasks // wakeup calls
		timer		 = timer,
		}
end



-- run once at first paint loop :
local function frontendConfigure(widget)

	widget.w, widget.h = lcd.getWindowSize()

	if widget.w> 0 then
	-- **********************************************    general layout    ******************************

		local topBarHeight, blank, widgetHeight, widgetWidth = getFrameSizing(WIDGET_MODE,TOPBAR_WID,Dual_WID)		

																						-- rough screen layout:
		frameLeft = {																	-- frame layouts: for compatibility reasons, only "left" is declared
			name= "left",																-- name
			x = 0,																					-- x-position
			y = (topBarHeight+blank)*widget.h,														-- y-position (abs)
			w = widget.w*widgetWidth,																-- width
			h = widget.h*widgetHeight																-- height
			}
		frameRight = {																	-- frame layouts: for compatibility reasons, only "left" is declared
			name= "right",																-- name
			x = widget.w*(0.5+(0.5-widgetWidth)/2),																		-- x-position
			y = (topBarHeight+blank)*widget.h,														-- y-position (abs)
			w = widget.w*widgetWidth,																-- width
			h = widget.h*widgetHeight																-- height
			}
		frameTop = {																	-- frame layouts: for compatibility reasons, only "left" is declared
			name= "top",																-- name
			x = 0,																		-- x-position
			y = 0,																		-- y-position (abs)
			w = widget.w,																-- width
			h = widget.h*topBarHeight																-- height
			}

	-- **********************************************    load basics    ******************************
--[[
-		require(libPath.."conf_displaySets")				-- evaluate tx type and set font size etc..
		require(libPath.."/themes/theme1")					-- color schemes
--]]

		if not(LIB_ConfDisp) then
			loaded_chunk = assert(loadfile("/scripts/libUnow/conf_displaySets.lua"))			-- evaluate tx type and set font size etc..
			loaded_chunk()
		end

		if not(LIB_Theme1) then
			loaded_chunk = assert(loadfile(libPath .."/themes/theme1.lua"))						-- color schemes
			loaded_chunk()
		end
			
		widget.theme = initTheme(evalTheme(widget))												-- ensure theme change will be activated

--		local start = 2																			-- slot 1= TopBar; index 2 = App01L
--		if TOP_MODE then start = 1 end
		
																								-- load selected apps / subWidgets (configuration in file "_conf"); #loops = #widgets:
		for i=1,NumAPPS+1 do

			local label = ""

			if pcall(function() label = widgetAssignment[widArray[i] ].label return end ) then
				if  widgetAssignment[widArray[i] ].label ~= "EMPTY" then						-- pcall OK >> persistent data, so check for app
					loadApp(widget.wpath.. widgetAssignment[widArray[i] ].File)
				--[[		
						local fLen = string.len(file)
						file = string.sub(file,1,fLen-4)
						require(widget.wpath.. file)
				--]]	   
				end
			else																				-- pcall fail >> very first widget run, init ...
				local slot = widArray[i]
				assignEmpty(widget,slot)
			end
		end

																								-- define sub-widget specific config line:	
		for i=2,NumAPPS+1 do																	
			local configWidgetCall="conf_".. widgetAssignment[widArray[i] ].label				-- call widget dependent function to get config string
		end


		-- *******************************    evaluate display specific settings   ***************************		
		-- only on 1st loop
		if widget.display == nil then
			widget.display 	= evaluate_display()
			widget.layout 	= defineSuite_Layout(widget.display)
		end
		
		txtSize = {}
		txtSize.Xsml, txtSize.sml, txtSize.std, txtSize.big = defineTeleSize(widget.display)

		widget.touch.X = nil
		widget.touch.Y = nil
		
		initLayout(widget)
		
		collectgarbage("collect")																-- housekeeping after init

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

-- ******** call actual left widget

local function w_left(widget)
	if not pcall(layout[widget.actualWidget.left.typ] ~= nil) then								-- typ=startwidgetL , page = 1, maxpage = layout[startwidgetL ].maxpage
		
		local slot 	= widget.widgetSelect["left"].selected										-- we are running  app#
		local confItem 		= slot+OFFSET+TOP_OFFSET
		local assignment 	= widget.conf[confItem][3]
		
		if assignment < 90 then
			widget.appConfigured[slot]=layout[widget.actualWidget.left.typ].func(frameLeft,widget.actualWidget.left.page,widget.appConfigured[slot])		-- func = function(frame,page)  		end, maxpage = 1
		end 
		
	else
		print("---------  Error w_left")
	end
end

-- 	>> look at frontendconfigure for specific paras: _G[widgetAssignment[TOP_1].mainfunc](frame,page,widget.layout,widget.theme,widget.touch,widget.evnt,widget)	

-- ******** call actual right widget
local function w_right(widget)
	if not pcall( layout[widget.actualWidget.right.typ] ~= nil) then	

		local slot 	= widget.widgetSelect["right"].selected										-- we are running in app#
		local confItem 		= slot +OFFSET+TOP_OFFSET
		local assignment 	= widget.conf[confItem][3]											-- this is item # of config items (read/write)
		
		if assignment < 90 then																	-- APPidxNil = 98 !
			widget.appConfigured[slot]=layout[widget.actualWidget.right.typ].func(frameRight,widget.actualWidget.right.page,widget.appConfigured[slot])
		else
			print("---------  Error w_right")
		end
	end
end



-- ******** call topBar
local function w_top(widget)
	if not pcall( layout[TOPLINE] ~= nil) then	
		local slot = TOPLINE
		widget.appConfigured[slot]=layout[TOPLINEslot].func(frameTop,1,widget.appConfigured[TOPLINEslot])
	else
		print("Error calling TopBar")
	end

end



																			-- ************************************************
																			-- ***		     "display handler"					*** 
																			-- ************************************************
local function paint(widget)

	if not(widget.configured) then											-- one time config; cant be executed during create cause window size not availabe then
		widget.configured = frontendConfigure(widget)	
	else																	-- run apps only in case main was configured

		-- main "frame" calls:	
		if widget.widgetSelect.left.running > 0 then 						-- ensure at minimum one app was configured in frame (checkStart..)
			w_left(widget) 
		end
		
		if MULTI and widget.widgetSelect.right.running > 0 then				-- two frame mode and ensure at minimum one app was configured in frame (checkStart..)			
			w_right(widget)
		end
		
		if TOP_MODE then
			w_top(widget)
		end
		
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
	local configIndex = 0
	
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
	if debug8 		then print("**** 1600 config with appConfig :") end
	if debugdump 	then dumpConf(widget) end
	for configIndex=1,#widget.conf do
		parameter = widget.conf[configIndex]											-- get complete Formline
		if debug8 then print("1670  configure index, subwid?:",configIndex,parameter[1])	end											   
		local idx2 = configIndex

		if parameter[2] == createSubWidgetField then									-- we got an app with subFields 
			handleWidgetTree(parameter,widget,fields,configIndex)
--[[	if TOP_MODE then															-- we have a topbar item in the form, so other index:
				if debug8 then print("1610 call widTree (topbar mode) with confIndex",   configIndex) end
				handleWidgetTree(parameter,widget,fields,configIndex)					-- built complete "app incl. subform" fields			
			else
				if debug8 then print("1615call widTree no top with confIndex",   configIndex) end
				handleWidgetTree(parameter,widget,fields,configIndex)			
			end
		]]
		else																			-- here we go with the header entries (theme, topline..)
			line = form.addLine(widget.conf[configIndex][1])	

			if configIndex == OFFSET +1 then											-- topBar selection field
				field = parameter[2](line, parameter,widget) 
			else
				field = parameter[2](line, parameter) 
			end
			
			fields[#fields + 1] = field		
		end
	
	end
	
end


																			-- ****************************************************
																			-- ***		 change to new selected app				*** 
																			-- ****************************************************
local function changeApp(frm,selected,widget)																		-- reset app config status
	widget.actualWidget[frm] 			= {typ=handler , page = 1, 	maxpage = layout[handler ].maxpage  }			-- set actual app parameters ; typ = top/center/bottom etc..
	widget.widgetSelect[frm].running	= selected																	-- flag change app was finished
end
	

																			-- ****************************************************
																			-- ***		 if app needs background activities		*** 
																			-- ***				 for future use					*** 	
																			-- ***	  by now we have functions in "widget lua"	*** 																			
																			-- ****************************************************	
local function loadBackGroundLibs(widget)
		-- *** load background libs if needed
	local start = OFFSET + TOP_OFFSET
	local confIndex = 0
	local search = "label"																				-- set search flag for sefApplist
																										-- rough example:
	for confIndex = start,start+NumAPPS	do																-- loop slot indizes
		if widget.conf[confIndex][3] == defApplist("Model Finder",search,nil) then						-- detect app that need background task
				loaded_chunk = assert(loadfile("/scripts/libUnow/widgets/Modelfind/backgrnd_mf.lua"))
				loaded_chunk()																			-- load lib
		end
	end

end		
		
--[[		
		
																			-- ****************************************************
																			-- ***		 some apps initiate bg activities		*** 
																			-- ***	 this function detects & execute calls 		*** 
																			-- ****************************************************			
local function backGround(widget)
	local start = OFFSET + TOP_OFFSET

	for i = start,start+NumAPPS	do																			-- loop "slots"		
			local appUID = widget.conf[i][3]																-- get app UID in frame assignment
			if appUID ~= APPidxNil and widget.widgetList[appUID].bgFunc ~= nil then						-- app was assigned and needs bg activities:										-- determine which apps are configured & call corresponding background tasks	
				--print("********** bg found in appuid",appUID)
				local slot = lookupAppHndl(i-start)															-- get handler (TOP_1...) where app is installed
				if widget.appConfigured[slot] == false then
					MF_frontendConfigure(widget,widget.appTxt[slot])											-- if app not "first run configured" >> do
							collectgarbage("collect")	
				end
--				local checkBGcall																				
--				if pcall(function() widget.modelfind.com = bg_MFinder(widget.modelfind.com) return end) then
--				if pcall(function() checkBGcall = bg_MFinder(widget) return end) then
				if pcall(function() _G[widget.widgetList[appUID].bgFunc](widget) return end) then				-- call background function from global namespace
					-- OK
				else
					-- failure
					-- loadBackGroundLibs(widget)		(in case future developments needs dedicated "background libs" )
				end
		end
	end
end
]]

																			-- ****************************************************
																			-- ***		 some apps initiate bg activities		*** 
																			-- ***	 this function detects & execute calls 		*** 
																			-- ****************************************************			
local function backGround(widget)

	for i = 1, NumAPPS	do																					-- loop "slots"		(without TOPBAR)
			local appUID = widget.conf[i+OFFSET + TOP_OFFSET][3]											-- get app UID in frame assignment
			local check
			pcall( function() check = (appUID ~= APPidxNil and widget.widgetList[appUID].bgFunc ~= nil) return end )
			if check then							-- app was assigned and needs bg activities:										-- determine which apps are configured & call corresponding background tasks	
				if widget.appConfigured[i] == false then
					MF_frontendConfigure(widget,widget.appTxt[i])											-- if app not "first run configured" >> do
							collectgarbage("collect")	
				end
				if pcall(function() _G[widget.widgetList[appUID].bgFunc](widget) return end) then			-- call background function from global namespace
					-- OK
				else
					-- failure
				end
		end
	end
end


																				-- ************************************************
																				-- ***		     "background loop"				*** 
																				-- ************************************************

local function wakeup(widget)

	if os.clock() > widget.timer.garbage + 5 then																-- housekeeping every x seconds
		widget.timer.garbage = os.clock()
		collectgarbage("collect")	
	end
	
	if PERFMON then
		PM_t_start 					= os.clock()																-- handler start time
		PM_array[PM_pointer] 		= PM_t_start - PM_last_start 												-- store interval time

		PM_pointer 					= PM_pointer +1																-- increment pointer
		if PM_pointer > PM_NUM_ENTRIES then																		-- check array boundaries
			PM_pointer = 1
			PM_display = true																					-- activate avg calculation
		end

		if PM_display then
			local PM_sum=0
			for i =1,PM_NUM_ENTRIES do
				PM_sum = PM_sum + PM_array[i]		
			end
			local avg_cycleTime = PM_sum/PM_NUM_ENTRIES
			print("*****************    cycle time Suite3:   avg,  actual  ",avg_cycleTime,PM_t_start - PM_last_start) 

		end
		PM_last_start				= PM_t_start
	end

	if initAppConfig == false then																				-- in case user changed configuration during runtime >> trigger reconfig of sub-apps
			resetAppConfigFlag(widget)
			initAppConfig = true
	end
		
		
	local frmList ={
					"left"
					}
	if WIDGET_MODE ~= SINGLE_WID then 																			-- add entry in case multi frame handling
		frmList[2] = "right"
	end
	


	if handler > 0 then 
		-- **********   new page selected:
		
		if handler == LEFT_1 then																				-- frame1 left: page -1
			widget.actualWidget.left.page = widget.actualWidget.left.page - 1
			if widget.actualWidget.left.page < 1  then
				widget.actualWidget.left.page =  widget.actualWidget.left.maxpage
			end
			
		elseif handler == RIGHT_1 then																			-- frame1 right: page +1
			widget.actualWidget.left.page = widget.actualWidget.left.page + 1
			if widget.actualWidget.left.page > widget.actualWidget.left.maxpage then
				widget.actualWidget.left.page = 1
			end

		elseif handler == LEFT_2 then																			-- frame2 left: page -1
			widget.actualWidget.right.page = widget.actualWidget.right.page - 1
			if widget.actualWidget.right.page < 1  then
				widget.actualWidget.right.page =  widget.actualWidget.right.maxpage
			end
			
		elseif handler == RIGHT_2 then																			-- frame2 right: page +1
			widget.actualWidget.right.page = widget.actualWidget.right.page + 1
			if widget.actualWidget.right.page > widget.actualWidget.right.maxpage then
				widget.actualWidget.right.page = 1
			end
			
		end
	

	
		for i = 1,#frmList do
			local frm = frmList[i]
			if widget.widgetSelect[frm].running ~= widget.widgetSelect[frm].selected then						-- change ("left" frame) app detection
				changeApp(frm,widget.widgetSelect[frm].selected,widget)											-- call change of active app
			end
		end
	end
	
	backGround(widget)																							-- call background tasks so no further need for some src scripts
	
	handler =  0																								-- reset handler
	lcd.invalidate()

end



local function menu(widget)					-- menu handler
	return
end


-- read subform of "slot" index 1..x
local function read_subForm(slot,OFFSET,widget)

	if slot == NumAPPS+1 then slot = TOPLINE end
	local tmpSrc
	local indx2
	
	if #widget.subForm[slot] > 0 then												-- only if entries exist (nothing in case slot = 1)
			for indx2 = 1,#widget.subForm[slot]	do
	
				if widget.subForm[slot][indx2][1] == "  Cv Input-Src" then			-- handling source
					tmpSrc = storage.read("source")
					
					widget.subForm[slot][indx2][3]  = tmpSrc
					widget.subConf[slot][indx2] 	= tmpSrc

				else
					local readVal 						= storage.read("dummy")
					widget.subForm[slot][indx2][3] 	= readVal
					if debugConf then print("1980 read subconf appIndx, itmIdx, Val:",slot,indx2, readVal) end
					widget.subConf[slot][indx2] 	= readVal

					if readVal == nil then
						if debugConf then print("read was nil; SO DEFAULT	",widget.subForm[slot][indx2].default) end
						readVal = widget.subForm[slot][indx2].default
					end
				end
			end
	end
end

																			-- ****************************************************
																			-- ***		     read widget config             *** 
																			-- ***	if subApp identified, load lang file     ***
																			-- ****************************************************
local function read(widget)
--	require(suitePath.."suite_conf")																							  
	local configIndex,indx2
	local lookup = defApplist()
	local topBarOffs = 0
	if WIDGET_MODE == TOPBAR_WID then
		topBarOffs = 1
	end

	--************************	
	--   read header lines
	--************************	
	for configIndex = 1,OFFSET do							
		widget.conf[configIndex][3] = storage.read(widget.conf[configIndex][1])	
		if debugConf then print("2015 read header widConfIdx, val",configIndex,widget.conf[configIndex][3]) end
	end

	--************************	
	--   read App selection lines, max from TopBar to App03R, depends of suite mode
	--************************		

	local numSubFormItems	= #widget.conf	- OFFSET									-- number of choice lines (subWidgets / Apps..) with dependent forms

	
	for configIndex = 1+OFFSET,OFFSET+numSubFormItems do								--  Apps fields	
		widget.conf[configIndex][3] = storage.read(widget.conf[configIndex][1])			-- read Value; represents return value of widget choice list	

		local appUID = widget.conf[configIndex][3]
		if debugConf then print("2030 read main confIdx: "..configIndex,"  ","App: "..widget.conf[configIndex][1],"  ","slot:  "..configIndex-OFFSET-TOP_OFFSET,"  ","appUID:",appUID) end

		 reAssignWidgets(configIndex,appUID,widget)										-- assign subApp 
	end
	
	
	
	local slot
	
	--************************	
	--   read app specific sub-formlines
	--************************		
	for slot = 1,#widget.subForm do													--  loop app specific sub-config; 1=app01, 3=app03 ....; defined by reAssignWidgets
		-- print("call subform (slot)",slot)
		read_subForm(slot,OFFSET,widget)
	end

	

	local dumpResult = true
	if dumpResult then
		print("**** read finished with result of appConfig :")
		print("****     Header config")
		dumpHeaderConf(widget)
		print("****  App Conf starting with index 1 = App01 Left")
		dumpSubConf(widget)
	end
	
end		


-- write subform data of app
local function write_subform(slot,widget)
	local indx2
	if slot == NumAPPS+1 then slot = TOPLINE end
	for indx2 = 1,#widget.subForm[slot]	do							-- browse through all subform lines of an app
				local subItem = widget.subForm[slot][indx2][1]						-- get Item
				if subItem ~= nil then
					local value = widget.subForm[slot][indx2][3]	
					if value == nil then 										-- write dummy in case no subform items
						--value = "no subItem" 
						value = widget.subForm[slot][indx2]
					end
					
					if debugConf then print("   subconf Val",slot,indx2,widget.subConf[slot][indx2], "Val:",value) end
					widget.subConf[slot][indx2] = value						-- cache saved value in case of form refresh
					storage.write(subItem, value)								-- save item
				end
	end
end


																			-- ************************************************
																			-- ***		     write widget config 	   		*** 
																			-- ************************************************
local function write(widget)
	local index,indx2,slot

	--************************	
	--   write header lines
	--************************
	for index = 1,OFFSET do
		local value = widget.conf[index][3]									
		if value == nil then value = APPidxNil end
		storage.write(widget.conf[index][1], value)
		if debugConf then  print("write header",widget.conf[index][1],  "Val:",value) end
		
	end

	--************************	
	--   write App selection lines
	--************************			
	for index = 1+OFFSET,widget.numItems do										-- selective items (apps)
		value = widget.conf[index][3]	
		if value == nil or value == 1 then value = APPidxNil end									-- 1=nothing selected
		if debugConf then print("write App",widget.conf[index][1], "Val:", value) end
		storage.write(widget.conf[index][1], value)
	end

	--************************	
	--   write app specific formlines
	--************************		
	for slot = 1, #widget.subForm do										-- browse through all subforms
		if #widget.subForm[slot] > 0 then										-- only if entries exist (nothing in case slot = 1 = noApp)
			write_subform(slot,widget)
		end
	end

end



--[[
local function  appSelector(selection,running,frame)
	local lookupTbl = {}
	lookupTbl["left"] 	= {TOP_1,CENTER_1,BOTTOM_1}
	lookupTbl["right"]	= {TOP_2,CENTER_2,BOTTOM_2}
	
	local ok = false
	local selected = running
	local result = nil
	
	local offset = 0
	if running > NumAppsPerFrm then offset = NumAppsPerFrm	end											-- offset to detect "undercut" on right frame

	print("!!! called pageselect with para ",selection,"actual running slot"..running, "offset "..offset)
	if selection == "prev" then
		repeat								-- select previous "available" app (jump nil assigments)
			selected = selected - 1	
			if selected - offset == 0 then
				selected = NumAppsPerFrm		-- jump to last one					
			end
			-- print("label prev",selected,widgetAssignment[lookupTbl[frame][selected] ].label)
			if widgetAssignment[lookupTbl[frame][selected] ].label ~= "EMPTY" then ok = true end
		until ok
	else
		repeat								-- select previous "available" app (jump nil assigments)
			selected = selected + 1	
			if selected - offset > NumAppsPerFrm then
				selected = 1							
			end
			-- print("label nxt",selected,widgetAssignment[lookupTbl[frame][selected] ].label)
			if widgetAssignment[lookupTbl[frame][selected] ].label ~= "EMPTY" then ok = true end
		until ok		
	end
	handler = lookupTbl[frame][selected]
	selected = selected + offset
	print("!!! will return new slot ",selected)

--	return selected
	return selected
end
--]]


local function  appSelector(selection,running,frame)
	local lookupTbl = {}
	lookupTbl = {TOP_1,CENTER_1,BOTTOM_1,TOP_2,CENTER_2,BOTTOM_2}								-- "revolver" array

	
	local ok = false
	local selected = running
	local result = nil
	
	local offset = 0
	if running > NumAppsPerFrm then 
		selected 	= selected - NumAppsPerFrm	
		offset 		= NumAppsPerFrm
	end																							-- offset to detect "undercut" on right frame

	-- print("!!! called pageselect with para ",selection,"actual running slot"..running, "offset "..offset)
	if selection == "prev" then
		repeat																					-- select previous "available" app (jump nil assigments)
			selected 	= selected - 1				
			if selected  == 0 then			
				selected = NumAppsPerFrm															-- jump to last one	
			end
			result 		= selected+offset
			if widgetAssignment[lookupTbl[result] ].label ~= "EMPTY" then ok = true end
		until ok
	else
		repeat																					-- select next "available" app (jump nil assigments)
			selected = selected + 1	
			if selected > NumAppsPerFrm then
				selected = 1																		-- jump to 1st one	
			end
			result = selected+offset
			print(selected,result)
			if widgetAssignment[lookupTbl[result] ].label ~= "EMPTY" then ok = true end
		until ok		
	end
	handler = lookupTbl[result]

	return result
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
		widget.touch.editActiveSince = getTime()											-- refresh edit active timeout
		if debug3 then print("Event wheelRight   evt_left/right:",ROTARY_RIGHT) end	
	elseif category == 0 and value == ROTARY_LEFT then 
		widget.evnt.wheeldwn = true
		widget.touch.editActiveSince = getTime()											-- refresh edit active timeout
		if debug3 then print("Event wheelLeft   evt_left/right:",ROTARY_LEFT) end
	end
	
    if category == EVT_KEY and value == KEY_ENTER then
        if debug3 then print("    event KEY_ENTER:", category, value, x, y) end	
        return true
		
    elseif category == EVT_TOUCH then
		widget.touch.editActiveSince = getTime()											-- store for timeout recognition (edit field activation/deactivation)
 
		if debug3 then 
			if 		value == KEY_ENTER_LONG then  print("    value key_long:",  value, x, y) 
			elseif	value == KEY_ENTER_SHORT then  print("    value key_short:",  value, x, y)
			elseif	value == TOUCH_END then  print("    value touch_end:",  value, x, y)
			elseif	value == TOUCH_START then  print("    value touch_start:",  value, x, y)
			else	print("    vTOUCH value:",  value, x, y)
			end
		end	
		
		if value == TOUCH_END then															-- touch determined: evaluate menu handler
		
			-- store coordinates
			widget.touch.X=x
			widget.touch.Y=y
			
			-- ****    define touch area:	  		*******			
			-- ****   y area of widget selection  	*******
			local y1 = 		widget.h * 0.2													-- prev widget: y-touched between 0% ..  y1  ; 1.0=100%										
			local y2 = 		widget.h * 0.8													-- next widget: y-touched between y2 .. y3				
			local y3 = 		widget.h		
				
									--    page selection
			local yy1 = 		widget.h * 0.4				-- y "bar" yy1..yy2								
			local yy2 = 		widget.h * 0.6												
			local yy3 = 		widget.h		

			---- definitions in case of mode=SINGLE_WID			
			---- select widget#1 nxt / prev. WIDGET) x- area
			local xWidth= 	0.3		
				
			local x0 = 0
			local x1 = 		widget.w  * 0.4											
			local x2 = 		widget.w  * 0.6											
			local x3 = 		widget.w
				
			---- select widget#1 nxt / prev. PAGE) x- area
			local xx0 = 0
			local xx1 = 		widget.w  * 0.2				
			local xx2 = 		widget.w  * 0.8			
			local xx3 = 		widget.w				
			
			if WIDGET_MODE ~= SINGLE_WID then 												-- adopt touch area for 2 widget use

				-- eval area for dual widget mode
				-- select widget#2 nxt / prev. widget area
				 xWidth= 	0.3 * widget.w /2												-- touch "width" of frame where event should be triggered, e.g 0.3; too much can influence button click availability
				
				 x0 	= 	0
				 xEnd 	= 	widget.w /2
				 x1 	= 	(x0+xEnd)/2  - xWidth/2											-- center of frame - half of width								
				 x2 	= 	x1+ xWidth										

				 xx0	= 	xEnd
				 xxEnd	= 	widget.w			
				 xx1 	= 	(xx0+xxEnd)/2  - xWidth/2			
				 xx2 	= 	xx1+ xWidth
			
			end																			
			
			
			-- ****     check if other app was selected "left" / single widget   ********
			
			if x > x1 and x < x2	then											
				print("App actual LEFT",widget.widgetSelect["left"].selected)
				if 		y < y1  			then 										--  "prev widget" was pressed
					widget.widgetSelect["left"].selected = appSelector("prev",widget.widgetSelect["left"].running,"left")
					return true
				elseif	y > y2 and y < y3 	then 										-- "next" choosen
					widget.widgetSelect["left"].selected = appSelector("next",widget.widgetSelect["left"].running,"left")
					return true
				end		
			end

	
			-- ****     check if other app was selected "right" widget  ********

			if WIDGET_MODE ~= SINGLE_WID and x > xx1 and x < xx2	then											-- check if other app was selected "left"
			--print("App actual RIGHT",	widget.widgetSelect["right"].selected)
			if 		y < y1  			then 									--  "prev widget" was pressed
					widget.widgetSelect["right"].selected = appSelector("prev",widget.widgetSelect["right"].running,"right")
					return true
				elseif	y > y2 and y < y3 	then 									-- "next" choosen
					widget.widgetSelect["right"].selected = appSelector("next",widget.widgetSelect["right"].running,"right")
					return true
				end					
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

																			-- ************************************************
																			-- ***			     init widget	 	  		*** 
																			-- ************************************************
local function init()
 system.registerWidget({key=KEY, name=name, create=create, wakeup=wakeup, paint = paint, configure=configure, event=event, read=read, write = write})
end

return {init=init}