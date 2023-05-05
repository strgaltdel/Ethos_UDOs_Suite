
--- The lua script "setCurve" is licensed under the 3-clause BSD license (aka "new BSD")
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


--  setCurve
--  suite edition
--  Feb 2023
--  Rev 1.1


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



-- *******************************************************
--   these constants can be customized by user preferences
-- *******************************************************

local SIM_TRIM					= true							-- simulate Trims by switches (used in sim on PC)

local GVAR_SET <const>			= 1								-- GVAR dataset
 


-- *******************************************************
--            declare "global" widget variables once 
-- *******************************************************

local libPath <const>  			= "/scripts/libUNow/"
local widgetPath <const>  		= "/scripts/libUNow/widgets/"
local localPath <const>  		= "/scripts/libUNow/widgets/gvar"

local LABEL <const>  			= 2
local SOUNDFILE <const>  		= 3


local IDLE <const> 				= 0								-- some handler
local CHANGING <const> 			= 1
local SAVED <const> 			= 2

local BOLD <const> 				= 2
local BOLDX <const> 			= 3
local BOLDXX <const> 			= 5

local PLAYNUM <const> 			= false							-- announce y Value of selected point
local CRVyOffset <const> 		= 10

local nextSound 				= 0								-- timestamp to play sound 
																

																
local LEFT <const> 				= 1								-- trim position
local RIGHT <const>				= 2								-- trim position
local NEUTRAL <const>			= 0								-- trim position
																
																
local MODE_MOMENTARY <const> 	= 0								-- pt selector "momentary"
local MODE_TRIM <const>			= 1								-- .. via "Trim"
local MODE_LSW <const>			= 2								-- .. via "LSW"


	

	

local gvVar =  {}
	gvVar.array			= {}									-- dataset of GV's to be changed inflight, defined in ded. config file
	gvVar.array_org 	= {}									-- hosts original gv variable values (actual FM)
	gvVar.array_edit	= {}									-- !!needed ?  hosts edited/changed gv variable values
	gvVar.armReset 		= true									-- needed to inhibit repeatment of sounds
	gvVar.selectorVal	= 0
	gvVar.numItems		= 0										-- number of GVars
--	gvVar.actual_GV		= {1,"start"}							-- actual GV-index & GV-label
	
	gvVar.snd= {}
		gvVar.snd = {}									
		gvVar.snd.checkAnn 			= false						-- flag  announcement imminent
--		gvVar.snd.wav				= ""						-- which actual wav to play
		gvVar.snd.preLoadTime		= 0 						-- time when point was selcted (you'll have to add a delay in case you browse through several points, so only last one should be played)
		
		


local vars  =  {}												-- hosts vars which (and depending function coding) may also be used in other scripts

local var 	=  {}												-- hosts data from actual selected GVar
																-- start conditions:  GVar_frontendConfigure()


		
local pre <const> = "/scripts/libUNow/audio/de/"				-- sounds for widget
local sound = {}
  sound.tune	= pre .."tuning.wav"
  sound.set		= pre .."set.wav"
  sound.go		= pre .."go.wav"
  sound.reset	= pre .."reset.wav"
  sound.pod2zero= pre .."pod2zero.wav"


		
-- **************************************************************************************
-- *************************    simulate 1.5x gvar lua funcs     **************************
-- **************************************************************************************		

-- later on conbfig via dedicated file:
local function gvarData(dataSet)

	local data = {}

	-- set standard
	data[1] = {
		{"Differenzierung",			"Diff"			,"diff.wav"},
		{"Höhentrim Wölbkl",		"Cmb 2 Ele"		,"mot2ele.wav"},		
		{"Höhentrim ButFl.",		"BFl 2 Ele"		,"bfl2ele.wav"},
		{"Höhentrim Motor",			"Mot 2 Ele"		,"mot2ele.wav"},
		{"Diff V Ltw",				"V Diff"		,"vdiff.wav"}		
--		{"Höhentrim Stoerkl",		"Brk 2 Ele"		,"brk2ele.wav"},
		}
	
	-- set extended 1
	data[2] = {
		{"Differenzierung",			"Diff"			,"diff.wav"},
		{"Rate Quer innen",			"Ail 2 Cmb"		,"ail2cmb.wav"},
		{"Rate Wölb aussen",		"Cmb 2 Ail"		,"cmb2ail.wav"},
		{"Rate snapflap",			"snapflap"		,"snapflap.wav"},
		{"Höhentrim Wölbkl",		"Cmb 2 Ele"		,"mot2ele.wav"},
		{"Höhentrim ButFl.",		"BFl 2 Ele"		,"bfl2ele.wav"},
		{"Höhentrim Motor",			"Mot 2 Ele"		,"mot2ele.wav"},
		{"Diff V Ltw",				"V Diff"		,"vdiff.wav"}		
--		{"Höhentrim Stoerkl",		"Brk 2 Ele"		,"brk2ele.wav"},
		}	
		
	-- set Wölbklappe
	data[3] = {
		{"Rate Wölben",				"Rate Wölb"		,"rate_cmb.wav"},
		{"Rate Wölb aussen",		"Cmb 2 Ail"		,"cmb2ail.wav"},
		{"Höhentrim Wölbkl",		"Cmb 2 Ele"		,"mot2ele.wav"}
		}

	-- set Höhenruder
	data[4] = {
		{"HR Rate ziehen",			"Cmb 2 Ele"		,"ele_rate_up.wav"},		
		{"HR Rate drücken",			"BFl 2 Ele"		,"ele_rate_dn.wav"},
		{"HR Expo",					"BFl 2 Ele"		,"ele_expo.wav"},
		{"Höhentrim Wölbkl",		"Cmb 2 Ele"		,"mot2ele.wav"},		
		{"Höhentrim ButFl.",		"BFl 2 Ele"		,"bfl2ele.wav"},
		{"Höhentrim Motor",			"Mot 2 Ele"		,"mot2ele.wav"}
		}
		
	return data[dataSet]
end


-- init values:
--[[local simGVar = {}
	simGVar = {
		{"Diff" 		,	3 },
		{"Cmb 2 Ele"	,	4 },
		{"Ail 2 Cmb"	,	5 },
		{"Cmb 2 Ail"	,	6 },
		{"V Diff"		,	7 },
		{"BFl 2 Ele"	,	8 },
		{"Mot 2 Ele"	,	9 },
		{"snapflap"		,	1 },
		{"Brk 2 Ele"	,	2 }
	}

	simGVar = {
		{"Diff" 		=	3 },
		{"Cmb 2 Ele"	=	4 },
		{"Ail 2 Cmb"	=	5 },
		{"Cmb 2 Ail"	=	6 },
		{"V Diff"		=	7 },
		{"BFl 2 Ele"	=	8 },
		{"Mot 2 Ele"	=	9 },
		{"snapflap"		=	1 },
		{"Brk 2 Ele"	=	2 }
	}
	]]
	
	local simGVar = {}
	simGVar = {
		["Diff"]		=	3 ,
		["Cmb 2 Ele"]	=	4 ,
		["Ail 2 Cmb"]	=	5 ,
		["Cmb 2 Ail"]	=	6 ,
		["V Diff"]		=	7 ,
		["BFl 2 Ele"]	=	8 ,
		["Mot 2 Ele"]	=	9 ,
		["snapflap"]	=	1 ,
		["Brk 2 Ele"]	=	2 
	}

--print("TESTVAL",simGVar["Diff"])



	
local function getGVar(gvar)
		--print("gotVar",gvar)
		return simGVar[gvar]
end

local function setGVar(gvar,value)
	simGVar[gvar] = value
	return true
end


	
-- **************************************************************************************
-- *************************       start with functions        **************************
-- **************************************************************************************

			
---------------
-- Define config string
---------------

function conf_SetCurve()
	widgetconfLine["curve01"]="!curv1,void"						-- no special configuration
end



-- --------------------------------------
--      handle announcements which
--         should be delayed
-- --------------------------------------
local function armAnnouncent(soundfile)
	local ArmSound = {}
		ArmSound.preLoadTime	= getTime()						-- store time when announcementwas selected
		ArmSound.wav			= soundfile						-- store wav to play
		ArmSound.checkAnn		= true							-- flag announcement imminent, so wait for some delay in main loop..
	return ArmSound
end

-- --------------------------------------
--      reset announcement (delayed)
-- --------------------------------------
local function  reset_Ann()
	local ArmSound = {}
		ArmSound.preLoadTime	=	0 							-- time when announcement was selcted 
--		ArmSound.wav			= 	""							-- which wav to play
		ArmSound.checkAnn		=  	false						-- reset flag 
	return ArmSound
end


-- --------------------------------------
--      get point selector value (via momentary / LSW)
-- --------------------------------------
local function  getSelectorVal(switch,mode)
	print("got mode",switch,mode)
	local newValue
	if 		mode == MODE_MOMENTARY then
		newValue  = getSwitch(switch)
	elseif	mode == MODE_TRIM then								-- needs separate function
		newValue  = getTrim(switch)
	else
		newValue  = getLSwitch(switch)
	end
	print("switchValue ",newvalue)
	return newValue
end


-- --------------------------------------
--      get point selector value (trim)
-- --------------------------------------

local function  getTrim_Val(switch)
	--print("178 enter getTrimval",switch)
	local valLeft
	local valRight
			
	if SIM_TRIM then
			-- sim "substitude" switch SC/SB:
			local srcLeft  = system.getSource({category = CATEGORY_SWITCH, name = "SC"})
			local srcRight = system.getSource({category = CATEGORY_SWITCH, name = "SB"})
			

			valLeft  = srcLeft:value()
			valRight = srcRight:value()
		
			if valLeft ~= 0 then
				valLeft = 1024				-- sim trim left
				valRight = 0
			elseif valRight ~= 0 then
				valRight = 1024			-- sim trim right
				valLeft = 0
			end		
	else
			if switch == trimA then
				member1 =  8				-- trim5 left
				member2 =  9				-- trim5
			else
				member1 = 10				-- trim6 left
				member2 = 11	
			end
		
			local srcLeft  = system.getSource({category = CATEGORY_TRIM_POSITION, member = member1})
			local srcRight = system.getSource({category = CATEGORY_TRIM_POSITION, member = member2})
			
			--local valLeft  = srcLeft:value() > 0				-- in case app logic demands for boolean
			--local valRight = srcRight:value() > 0
			
			valLeft  = srcLeft:value()
			valRight = srcRight:value()
	end
	print("return trim val",valLeft,valRight)
	return valLeft,valRight
end

-- --------------------------------------
-- get potvalue (relative, max = 100%, considers deadzone)
-- --------------------------------------
local function getPotVal(Pot)
	print("getpotVal",Pot)
	local deadzone = 4									-- deadzone in percent
	local position = getAnalog(Pot)/10.24
	if math.abs(position) < deadzone then 					
		return 0,true									-- within deadzone / neutral = true
	else
		position=(position/math.abs(position))*(math.abs(position)-deadzone)/((100-deadzone))*100		-- calc percent value (deadzone!)
		return position,false
	end

end



---------------
-- dump curve-points
---------------	
local function dumpGVars(array)
	for i=1, #array do
		print("GV:",array[i][1],array[i][2])
	end
end


---------------
-- backup original curve
---------------	
local function backupGVar(array)
	for i=1,gvVar.numItems do
		local gv_label = array[i][1]
		gvVar.array_org[i] = getGVar(gv_label)
	end
end



---------------
-- restore oiginal curve
---------------	
local function restoreGV_all(list,original)
	for i=1,gvVar.numItems do
		local gv_label = list[i][1]
		local gv_value = original[i]
		setGVar(gv_label,gv_value)
	end
	-- play wav "Potnot zero"
	return 
end



-- var.itmActualVal no longer needed ??
---------------
-- store original Y value as "base" for new one
---------------
local function storeOldValue()
	var.itmOldVal = var.itmActualVal							-- store old value
end 


---------------
-- user triggered "save"
---------------
local function handleSaveValue()
		var.itmHandle 		= SAVED															-- reset some values
		var.itmSwTime 		= 0																-- reset "switch was triggered time"
		storeOldValue()
		playWav(sound.set)
		playSignal(1500,400)
end 

-- set array of actual GVar parameters
local function setValArray(index)
	var={
		itmActual		= 1,																-- actual item index
		itmLabel		= gvVar.array[index][LABEL]	,										-- actual item label
--		itmActualshadow = nil 																-- used by trim button handling (prprocessing)
		itmSwValue		= 0,																-- former point selector value
		itmSwTime		= 0,
		itmChngeActive	= false,
		itmOldVal		= getGVar(gvVar.array[index][LABEL]),								-- "unchanged" value
		itmHandle		= SAVED	,															-- start condition
		itmTrimDir		= NEUTRAL,															-- used by trim button handling (direction handler)
		sound			= gvVar.array[index][SOUNDFILE],															-- item corresponding sound file
		image			= "xx.png",															-- item corresponding image 
		PotNeutral		= false	,															-- trim pot neutral ?
		PotVal			= 0	,																-- pot value in percent
		}

end




-- ***********************************************
--   check if user triggered "save value" and flag Vars
-- ***********************************************
local function checkSaveVal(switch,mode)

	local switchValue = 0
	
	if selMode == MODE_MOMENTARY then
		switchValue = getSelectorVal(switch,mode)
		
	elseif selMode == MODE_TRIM then
--[[
		if switch == trimA then
			member1 =  8				-- trim5 left
			member2 =  9				-- trim5
		else
			member1 = 10				-- trim6 left
			member2 = 11	
		end
		
		local srcLeft  = system.getSource({category = CATEGORY_TRIM_POSITION, member = member1})
		local srcRight = system.getSource({category = CATEGORY_TRIM_POSITION, member = member2})
		
		local valLeft  = srcLeft:value() > 0
		local valRight = srcRight:value() > 0
--]]		
--[[
		-- sim "substitude" switch SB:
		local srcLeft  = system.getSource({category = CATEGORY_SWITCH, name = "SB"})
		local srcRight = system.getSource({category = CATEGORY_SWITCH, name = "SB"})
		
		local valLeft  = srcLeft:value()
		local valRight = srcRight:value()	
--]]
		local valLeft,valRight = getTrim_Val(switch)
		switchValue  = valLeft + valRight
	end	

	if var.itmHandle == CHANGING then
		-- switch was pressed >> flag "save pending"
		if switchValue > 0  then											-- we are in "change" mode and user triggered save switch >> save value
			if var.itmSwTime == 0 then																-- start time measurement	/ flag "save value" pending ("save on release")
				var.itmSwTime = getTime()
			end
			
		-- switch was released & flag "save pending" >> "save" value		
		elseif var.itmSwTime > 0 and switchValue <= 0 then	
		print("save detected")
			handleSaveValue()
		end
	end
end
	

	
	
-- ***********************************************
--    standard routine for momentaries & LSW's
-- ***********************************************	
local function momentHandling(switch,Numitems,var,selMode)

	local newValue  = getSelectorVal(switch,selMode)

		if newValue > 0 then																	-- switch is activated
			if var.itmSwTime == 0 then															-- start time measurement	
				var.itmSwTime = getTime()
			end

		elseif var.itmSwTime > 0 and var.itmHandle == IDLE then									-- switch released & in "idle" mode:  so choose new item (new point)										-- switch released, value saved before >> select new item 																	-- momentary procedure
			local duration = getTime() - var.itmSwTime
			var.itmSwTime 		= 0		
			if duration <0.8 then																-- short press >> next point
				if var.itmActual == Numitems then
					var.itmActual=1
				else												
					var.itmActual= var.itmActual+1												-- increment
				end
			else																				-- long press >> prev. point
				if var.itmActual == 1 then
					var.itmActual =Numitems
				else												
					var.itmActual = var.itmActual-1												-- decrement
				end
			end
--			gvVar.snd = armAnnouncent(sound.pnt[var.itmActual+1])								-- "preload" call out
--			storeOldValue()																		-- remember "original" value as base point
			setValArray(var.itmActual)		
			
		elseif var.itmSwTime > 0 and var.itmHandle == SAVED then								-- switch released & in "saved" mode:  USER ERROR! Pot was not reset to neutral, so no action !
			var.itmSwTime 		= 0
			playWav(sound.pod2zero)
			playSignal(2000,100)
		end	




end
	
-- ***********************************************
--    routine for Trims
-- ***********************************************	
local function trimHandling(switch,Numitems,var,selMode)
--[[
local function trimHandling(member1,member2,Numitems,var,selMode)
		
		local srcLeft  = system.getSource({category = CATEGORY_TRIM_POSITION, member = member1})
		local srcRight = system.getSource({category = CATEGORY_TRIM_POSITION, member = member2})
		
		local valLeft  = srcLeft:value() > 0
		local valRight = srcRight:value() > 0
--]]	
--[[	
		-- sim "substitude" switch SB:
		local srcLeft  = system.getSource({category = CATEGORY_SWITCH, name = "SB"})
		local srcRight = system.getSource({category = CATEGORY_SWITCH, name = "SB"})
		
		local valLeft  = srcLeft:value() < 0
		local valRight = srcRight:value() > 0		
--]]			
		local valLeft,valRight = getTrim_Val(switch)
		
		newValue  = valLeft > 0 or valRight > 0															-- determine if trim is pressed
		print("514 trimhandling handle 0=idle, 1=changing, 2=saved", var.itmHandle)
		
		if newValue and  var.itmSwTime == 0 then													-- trim is intially pressed, further investigation:
			if valLeft>0 then 
				var.itmTrimDir = LEFT															-- determine trim position left/right
			else
				var.itmTrimDir = RIGHT
			end
			
	--		if var.itmSwTime == 0 then															-- start time measurement	
				var.itmSwTime = getTime()
	--		end

		elseif var.itmSwTime > 0 and var.itmHandle == IDLE then									-- trim was pressed & released & in "idle" mode (pod neutral):  so choose new item (new point)										-- switch released, value saved before >> select new item 																	-- momentary procedure
			--local duration = getTime() - var.itmSwTime
			var.itmSwTime 		= 0																-- reset time "counter"
			if var.itmTrimDir == RIGHT then														-- "right" pressed >> next point
				if var.itmActual == Numitems-1 then
					var.itmActual=0
				else												
					var.itmActual= var.itmActual+1												-- increment
				end
			else																				-- "LEFT" pressed >> prev. point
				if var.itmActual == 0 then
					var.itmActual =Numitems-1
				else												
					var.itmActual = var.itmActual-1												-- decrement
				end
			end
			gvVar.snd = armAnnouncent(sound.pnt[var.itmActual+1])								-- "preload" call out
			storeOldValue()																		-- remember "original" value as base point
			var.itmTrimDir = NEUTRAL															-- reset handler
			
		elseif var.itmSwTime > 0 and var.itmHandle == SAVED then								-- switch released & in "saved" mode:  USER ERROR! Pot was not reset to neutral, so no action !
			var.itmSwTime 		= 0
			playWav(sound.pod2zero)
			playSignal(2000,100)
			var.itmTrimDir = NEUTRAL															-- reset handler
		end				
--[[		
--]]




end	
	
	
	
	
	-- GVAR: exchange pts <> gvar	
-- ***********************************************
--    select item using "momentary hold" ; short ++  long --
-- ***********************************************
local function itmSelect(switch,Numitems,var,selMode)
	local trimA = "T5"
	local trimB = "T6"


	local member1
	local member2

	local newValue
	print("611 selMode",selMode)
	--   ***********************************************		
	--   *******         momentaries                ****	
	--   ***********************************************	
	if selMode == MODE_MOMENTARY or selMode == MODE_LSW then	
			print("508 enter mom")
			momentHandling(switch,Numitems,var,selMode)
		
--[[		
--]]		
	--   ***********************************************		
	--   *******              Trims                 ****	
	--   ***********************************************			
	
	elseif selMode == MODE_TRIM then
	--[[ñ
		if switch == trimA then
			member1 =  8				-- trim5 left
			member2 =  9				-- trim5
		else
			member1 = 10				-- trim6 left
			member2 = 11	
		end
			
		trimHandling(member1,member2,Numitems,var,selMode)
-- ]]
		trimHandling(switch,Numitems,var,selMode)
	
	end

	
	
--	print("ret",var.itmActual)
    return(var.itmActual)

end
	

---------------
-- determine mode
---------------	
local function itmCheckActive(Pot,isNeutral)
	if var.itmHandle == SAVED and isNeutral then												-- changed from saved to ready
		playWav(sound.go)
		return IDLE
	elseif  var.itmHandle==IDLE  and not(isNeutral) then									-- change from idle to tuning
		playWav(sound.tune)
		return CHANGING
	else
		return var.itmHandle																-- no changes
	end
end	


-- 	-- GVAR: maybe other Infos
---------------
-- fill info area
---------------	
local function drawInfo(Cv,cv_X,cv_Y,crvName ,theme,frameX)


	local row 	= (100-Cv.yDwn)/2+Cv.yDwn-1													-- calc y coord of y-row
	local row2 	= row +7																	-- row2

	
	lcd.color(theme.c_textStd)
	frame.drawText(50,0,crvName,CENTERED,frameX)											-- curve name 	
	lcd.color(theme.c_textgrey1	)
	frame.drawText(20, row, "Pnt ".. tostring(var.itmActual+1)	,nil,frameX)				-- point #
	frame.drawText(50, row, "X: " .. tostring(cv_X)				,nil,frameX)				-- point X coord
	if var.itmHandle == CHANGING then lcd.color(ORANGE) end
	frame.drawText(50, row2, "Y: " .. tostring(cv_Y)			,nil,frameX)				-- point Y coord

end



local function checklimits(value,minimum,maximum)
	if value > maximum then
		return maximum
	elseif value < minimum then
		return minimum
	end
	
	return value

end

local function checkA()
	for i=1,#gvVar.array do
	print("tst",gvVar.array[i][LABEL])
	end


end



local function upLoadGVset(dataSet)	
	gvVar.array = gvarData(dataSet)															-- load basic definitions (labels, sound files, etc..)
--	backupGVar(gvVar.array)																	-- save original values to array "org"
--	checkA()
	return true
end





	-- GVAR: ?? investigate
	-- load GVset
function GVar_frontendConfigure(widget,appTxt,GVset)		

	upLoadGVset(GVAR_SET)																	-- load GV Dataset

	backupGVar(gvVar.array)																-- make a backup of values in case user screwed up the hole thing
	gvVar.numItems = #gvVar.array															-- number of items / GVars
	
	setValArray(1)																			-- start with parameters / values of first GVar
	
	--	widget.setGVar ={}
	--widget.setGVar.txt = appTxt
	
	
	return true
end

local function lookupRowHeight(display)
	local height= {}
		
		height[1]		= {	[FONT_XS] = 14,		[FONT_S] = 16,		[FONT_STD] = 18, 	[FONT_L] = 20,	[FONT_XL] = 24,  	[FONT_XXL] = 28 }	-- row height X20
		height[2]		= {	[FONT_XS] = 12,		[FONT_S] = 14,		[FONT_STD] = 16, 	[FONT_L] = 18,	[FONT_XL] = 20, 	[FONT_XXL] = 24 }	-- row height X18	
		height[3]		= {	[FONT_XS] = 12,		[FONT_S] = 14,		[FONT_STD] = 16, 	[FONT_L] = 18,	[FONT_XL] = 20,  	[FONT_XXL] = 22 }	-- row height X12/X10

	return height[display]
end

local function disp_GV(gvIndex,i,fontSize,rwHeight,act_row,widget,frm)

--	lcd.color(widget.theme.c_textgrey1)
	lcd.color(lcd.RGB(170, 170, 170))
	lcd.font(fontSize)

	local Ystart 	= 5									-- yStart coordinate in %	
	local x1Col		= 3										-- xStart coordinate in % (label)
	local x2Col		= x1Col +80								-- ...GV value
	
	local gvlabel = gvVar.array[gvIndex][1]					-- label to be displayed
	local gvValue = getGVar(gvVar.array[gvIndex][2])		-- Value of GVar
	
		--			start line			+ delta
	local Y  = Ystart/100*frm.h  +i*rwHeight
	
	local yOffset = 0
	if i > act_row then
		yOffset = 10
	elseif i == act_row then
		yOffset = 3
		lcd.color(widget.theme.c_backgrEDT)
		lcd.drawFilledRectangle(0,Y,widget.w,rwHeight+8)
		--lcd.font(txtSize.std)
		lcd.font(FONT_L)
			lcd.color(widget.theme.c_textStd)		
	end
	

	
	
	local Y  =  Y +yOffset									-- absolute Y coord	
	local X1 =  x1Col/100*frm.w								-- absolute X coord
	local X2 =  x2Col/100*frm.w
	
	lcd.drawText(X1, Y,gvlabel ,LEFT)						-- finally, we print
	lcd.drawNumber(X2,Y, gvValue)
end

local function drawGVblock(widget,frm)

	local numItems 		= math.max(7,gvVar.numItems)		-- limit number of displays items
	local fontSize  	= txtSize.sml						-- select fontsize
	local rowHeight 	= lookupRowHeight(2)				-- get disp dep. height per font
	local rwHeight		= rowHeight[fontSize]				-- get height per line

	-- disp GVAR & Value

	local active_row = 4									-- which line should display active GV (revolver rotation)
	local delta = var.itmActual - active_row				-- so eval delta to actual gv index
	local start = 1
	
	if numItems < gvVar.numItems then
		start = round(numItems/2,0)+1						-- if numItems < "maxItems" (7) >> recalc startindex
	end
	
	for i = start,numItems do
		gvIndex = i + delta
		print("index",i,gvIndex,numItems)
		if gvIndex<1 then
			gvIndex = gvVar.numItems + gvIndex
		end

		disp_GV(gvIndex,i,fontSize,rwHeight,active_row,widget,frm)
	end


	return
end



	-- GVAR: adopt...

-- **************************************************************************************
-- *************************      main function **************************
-- **************************************************************************************


-- function setCurve(frameX,page,layout,theme,touch,evnt,subConf,appConfigured,appTxt,widget)
function main_gvar(frameX,page,layout,theme,touch,evnt,subConf,appConfigured,txt,widget)
	lookupPot={								-- !!! analog input name; sequence / index MUST CORRESPOND TO FORM CHOICELIST // Config handler !!!!!  >> file suite_conf.lua
		"Pot1",								-- could be done more elegant, but so we have a tiny/easy choice List
		"Pot2",	
--		"Pot3",	
--		"Pot4",
		"Slider left",
		"Slider right",
		"L1",
		"L2"

		}
	
	lookupSel = {							-- !!! MUST CORRESPOND TO FORM CHOICELIST  // Config handler !!!!!
		"SH",								-- keep in mind we ve three instances for ths definition: suite_conf.lua, this lookup table & itmSelect function !!
		"SI",
		"SJ",
		"T5",
		"T6",
--		"FSW 1/4",
--		"FSW 2/5",
--		"FSW 3/6",
		"LSW_curve"
		}
		
	-- "migrate" passed config to local (only cause: better readable)
	-- in future releases a plausibility check maybe a good idea
--	gvVar.targetCurve	= subConf[1]-1						-- curve
--	gvVar.input 		= subConf[2]						-- input
	gvVar.trimPot		= lookupPot[subConf[2]]				-- trim 
	gvVar.Selector		= lookupSel[subConf[3]]				-- item selector
	gvVar.SW_restore	= subConf[4]						-- restore switch

	
	-- print("714 trimmer:",gvVar.trimPot)
	-- print("715 switch det:",gvVar.Selector)
	if gvVar.Selector=="SH"  or gvVar.Selector=="SI" or gvVar.Selector=="SJ" then	--determine selector mode
		gvVar.selMode = MODE_MOMENTARY
	elseif gvVar.Selector=="T5" or gvVar.Selector=="T6" then
		gvVar.selMode = MODE_TRIM
	else
		gvVar.selMode = MODE_LSW
	end

	
	print("821 determine selMode ",gvVar.selMode)
	-- one time config; cant be executed during create cause window size not availabe then
	if not(appConfigured) then	
		-- ***************************    "init"       *********************************************************
		appConfigured 		= GVar_frontendConfigure(widget,txt,GVset)			
	end	
																					-- refresh language in case changed during runtime
	if system.getLocale() =="de" then
		lan = 1
	else
		lan = 2 																	-- not supported language, so has to be "en" 
	end
	
	var.PotVal,var.PotNeutral		= getPotVal(gvVar.trimPot)						-- get value & status of Pot
	
-- ***************************    some checks on start   (user activities )   ******************************************
	
	if gvVar.snd.checkAnn then														-- announcement imminent, check if it should be triggered
		--print("testann")
		if getTime() - gvVar.snd.preLoadTime > DELAY_PNT then						-- wait some time, so "browsing" doesn't sound repeats
			playWav(var.sound)
			gvVar.snd = reset_Ann()													-- reset ann
		end	
	end

--  ---------

--	local cv_X, cv_Y = crv:point(var.itmActual)										-- get actual XY coordinates of curve-point you want to trim	

	local gv_VAR = getGVar(var.itmLabel)											-- get actal GV value
	
	--	*******					"selector / switch",		"numbers",			"data"		
	checkSaveVal(gvVar.Selector,gvVar.selMode)
	var.itmActual = itmSelect(gvVar.Selector,  gvVar.numItems ,var, gvVar.selMode) 		-- get actual "trim/tuning"-item number (here: point of curve you want to change)				
	var.itmHandle = itmCheckActive(gvVar.trimPot,var.PotNeutral)						-- determine working mode (handler:  idle / tuning / saved)	

	if getSource(gvVar.SW_restore) > 0	then										-- check if masterReset was requested
		if gvVar.armReset then														-- must be true to ensure one time call, so: reset
			restoreGV_all(gvVar.array_edit,gvVar.array_org)							-- execute reset
			playWav(sound.reset)
			gvVar.armReset = false													-- ensure one time call
		else
																					-- .. future use
		end
	else																			-- if not: go ahead
		gvVar.armReset = true
		if var.itmHandle == CHANGING then												-- when in changing mode: 
--			local cvX,cvY 	= crv:point(var.itmActual)									-- get old "generic" X/Y values
			local GVnew 	= 0.35*var.PotVal	+ var.itmOldVal							-- "transform" PotVal to new value, for safety reasons: 35% range as limit ;  gvVar.chngePntVal = value at start of tuning !
			--print("845 newval",var.itmOldVal	,cvYnew)
			GVnew = checklimits(GVnew,(-200),(200))										-- limit GVAR range
			setGVvar(var.itmLabel ,GVnew)												-- save new value
		end
	end	
	
	
-- ***************************    "GO"       *********************************************************
	
--	local Xvalue	= gvVar.input:value()/1024*100									-- input-value in percent														-- play "Catch" signal; corresponds to cursor thickness



	-- ***************************    "PAINT"       *********************************************************
	
	-- widget,theme,frameX, Cv  (var=global!!)
	lcd.invalidate()																-- on every call full refresh
	lcd.color(widget.theme.c_backgrAll )											-- clear screen
	lcd.drawFilledRectangle(1,1,widget.w,widget.h)

-- !! GV presentation layer !!	
		
	drawGVblock(widget,frameX)																	-- draw GV labels & values

--	drawCurve(crv,Cv,frameX,theme)													-- draw curve
	
--	local headline = widget.setGVar.txt.crvname[lan] .. " "..crv:name()			-- built text for curvename / headline string
--	drawInfo(Cv,cv_X,cv_Y,headline,theme,frameX)									-- draw text/numerical infos

	return(appConfigured)
end