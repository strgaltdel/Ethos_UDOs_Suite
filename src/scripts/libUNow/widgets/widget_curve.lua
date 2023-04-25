
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




-- **************************************************************************************
-- *************************    unspecific Tele draw functions **************************
-- **************************************************************************************


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


-- these constants can be customized by user preferences
local DELAY_PNT <const>			= 0.8							-- delay ouf point announcement after new one was selected (prevent "announcement stakkato" in case you browse through several points)
 
local MARK_OUTER <const>		= 19							-- definition of marker range (optical / audio "feedback") >>  percent values	
local MARK_INNER <const>		= 14
local MARK_HIT <const>			= 08

local SIM_TRIM					= true							-- simulate Trims by switches (used in sim on PC)
	

	
-- *******************************************************
--            declare "global" widget variables once 
-- *******************************************************
local cvVar =  {}												-- hosts cv variables (this scipt only)
	cvVar.curve_org 	= {}
	cvVar.armReset 		= true									-- needed to inhibit repeatment of sounds
	cvVar.selectorVal	= 0
	
	cvVar.snd= {}
		cvVar.snd = {}									
		cvVar.snd.checkAnn 			= false						-- flag  announcement imminent
		cvVar.snd.wav				= ""						-- which wav to play
		cvVar.snd.preLoadTime		= 0 						-- time when point was selcted (you'll have to add a delay in case you browse through several points, so only last one should be played)
		
		


local vars  =  {}												-- hosts vars which (and depending function coding) may also be used in other scripts

local var 	=  {}


local pre <const> = "/scripts/libUNow/audio/de/"				-- sounds for widget
local sound = {}
  sound.tune	= pre .."tuning.wav"
  sound.set		= pre .."set.wav"
  sound.go		= pre .."go.wav"
  sound.reset	= pre .."reset.wav"
  sound.pod2zero= pre .."pod2zero.wav"
  sound.pnt		={
				pre.."P01.wav",
				pre.."P02.wav",
				pre.."P03.wav",				
				pre.."P04.wav",				
				pre.."P05.wav",
				pre.."P06.wav",
				pre.."P07.wav",
				pre.."P08.wav",
				pre.."P09.wav",
				pre.."P10.wav"	}

		
				
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
local function  resetPntAnn()
	local ArmSound = {}
		ArmSound.preLoadTime	=	0 							-- time when announcement was selcted 
		ArmSound.wav			= 	""							-- which wav to play
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
--	elseif	mode == MODE_TRIM then								-- needs separate function
--		newValue  = getTrim(switch)
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
local function dumpCRV(curve)
	local nP=curve:pointsCount()
	local x,y
	for i=0,nP-1 do
		x,y = curve:point(i)
		print("original crv Pt,x,y",i,x,y)
	end
end


---------------
-- backup original curve
---------------	
local function backupCurve(curve)
	cvVar.curve_org = model.getCurve("backupCRV")
	if cvVar.curve_org == nil then
		cvVar.curve_org = model.createCurve()
		cvVar.curve_org:name("backupCRV")
	end

	local typ 	= curve:type()
	local nP	= curve:pointsCount()

	cvVar.curve_org:type(typ)
	cvVar.curve_org:pointsCount(nP)	
	for i=0,nP-1 do
		x,y = curve:point(i)
		cvVar.curve_org:point(i,x,y)
	end
end


---------------
-- restore oiginal curve
---------------	
local function restoreCurve(actual,old)

	local typ 	= old:type()
	local nP	= old:pointsCount()

	actual:type(typ)
	actual:pointsCount(nP)	
	for i=0,nP-1 do
		x,y = old:point(i)
		actual:point(i,x,y)
	end
	-- play wav "Potnot zero"
	return actual
end


---------------
-- eval nearest point from cursor, not used 
---------------
local function evalNextPoint(xRef,crv)
  	local nP=crv:pointsCount()
	local delta=200			-- >100 at startCRVyOffset
	local nextPoint

	for i=0,nP-1 do
		local x,y = crv:point(i)
		local deltaTmp = math.abs(xRef-x)
		if deltaTmp < delta then 
			delta = deltaTmp
			nextPoint = i
		end
	end

	return nextPoint,delta
end

---------------
-- store original Y value as "base" for new one
---------------
local function storeOldValue()
	local tmp
	local crvTmp = model.getCurve(cvVar.targetCurve)
	tmp,var.itmOldVal = crvTmp:point(var.itmActual)							-- store old value
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



---------------
-- draw curve-point
---------------	
local function drawPoint(xA,yA,n,frameX,theme)
		if n == var.itmActual then
			if var.itmHandle == CHANGING then
				lcd.color(RED)													-- we are in edit mode
			else
				lcd.color(ORANGE)					
			end
			frame.drawFilledCircle(xA,yA, 1.6,frameX )
		else
			lcd.color(GREEN)
			frame.drawFilledCircle(xA,yA, 1.2,frameX )
		end


end


---------------
-- draw curve
---------------	
local function drawCurve (crv,Cv, frameX,theme)
	local i,xA,yA,xB,yB 
	
	-- center lines
	lcd.color(theme.c_textdark)
	frame.drawLine(Cv.xLeft, CRVyOffset + Cv.yCntr,	Cv.xRight,		CRVyOffset + Cv.yCntr,		frameX)			-- x axis
	frame.drawLine(50,		 CRVyOffset + Cv.yUp,		50,			CRVyOffset + Cv.yDwn,		frameX)			-- y axis
	
	

	local nP=crv:pointsCount()
	for i=0,nP-2 do
		xA,yA = crv:point(i)
		xA = 		 50	+ xA/2*Cv.scaleX							-- calc relative x Pos
		yA = Cv.yCntr	- yA/2*Cv.scaleY +CRVyOffset
		xB,yB = crv:point(i+1)
		xB = 		50	+ xB/2*Cv.scaleX							-- calc relative x Pos
		yB = Cv.yCntr	- yB/2*Cv.scaleY +CRVyOffset
		
		lcd.color(theme.c_light1)
		frame.drawLine(xA,yA,xB,yB,frameX)							-- draw line
		
		drawPoint(xA,yA,i,frameX,theme)								-- crv points

	end
	
	i=nP-1
	drawPoint(xB,yB,i,frameX,theme)									-- edit point
		
	
end

---------------
-- draw cursor
---------------	
local function drawCursor(x,y,x2,y2, frameX, thickness,theme)
	if thickness == BOLDXX then										-- draw cursor
		lcd.color(RED)
	elseif thickness == BOLDX then
		lcd.color(ORANGE)
	else
		lcd.color(theme.c_frontAll	)								-- clean white / black
	end	
	frame.drawLine(x,y+CRVyOffset,x2,y2+CRVyOffset, frameX, thickness)		
end


---------------
-- eval cursow thickness
---------------	
local function evalThick(x,y,xCursor,marker)
	local delta = math.abs(xCursor-x)
	local thick
	if delta < marker.outer then
		if delta < marker.hit then 
			thick = BOLDXX
		elseif delta < marker.inner then 
			thick = BOLDX
		else
			thick = BOLD
		end
	else 
		thick = 1
	end
	return thick
end


---------------
-- "user radar"
---------------	
local function playCurSignal(delta)

	local time0 	= os.clock()
	local tmeDelta 	= 0.1	
	if time0 > nextSound then
--[[
		--    variant 1:	acoustic signal by entering outer marker
		if delta == BOLDX or delta == BOLDXX then 						-- inner marker
			playSignal(100,110)		
			nextSound = time0 + tmeDelta
		elseif delta == BOLD then										-- outer marker
			playSignal(200,110)
			nextSound = time0 + tmeDelta
		end
--]]
--[[--]]
		--    variant 2:	acoustic signal by entering inner marker
		if delta == BOLDXX then 										-- hit marker
			playSignal(100,110)		
			nextSound = time0 + tmeDelta
		elseif delta == BOLDX then										-- inner marker
			playSignal(200,110)
			nextSound = time0 + tmeDelta
		end


	end

end


---------------
-- draw "highlighted" area -2
---------------	
local function drawVBar( bitmp ,x,y,width,height,frameX)
	local bitmpHght =  math.floor(bitmp:height() / bitmp:width())*width

	frame.drawBitmap(x,y+CRVyOffset,bitmp,width,bitmpHght,frameX)
	frame.drawBitmap(x,y+CRVyOffset+height-bitmpHght,bitmp,width,bitmpHght,frameX)

end


-- ***********************************************
--     draw highlightet area -1
-- ***********************************************
local function highlightBar(point,crv,range,height,scale,frameX)	
	local Pnt_X,Pnt_Y = crv:point(point)						 				-- get coordinates
	if cvVar.crv1Bmp1 == nil then

	else
			local yy = 0
			local xx = math.floor((50+((Pnt_X-range)*scale/2)))
			local width = (range)
			drawVBar(cvVar.crv1Bmp1,	xx,	yy, width, height,frameX)
	end	
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
				if var.itmActual == Numitems-1 then
					var.itmActual=0
				else												
					var.itmActual= var.itmActual+1												-- increment
				end
			else																				-- long press >> prev. point
				if var.itmActual == 0 then
					var.itmActual =Numitems-1
				else												
					var.itmActual = var.itmActual-1												-- decrement
				end
			end
			cvVar.snd = armAnnouncent(sound.pnt[var.itmActual+1])								-- "preload" call out
			storeOldValue()																		-- remember "original" value as base point
		
			
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
		
		if newValue and  var.itmSwTime == 0 then													-- trim is nitially pressed, further investigation:
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
			cvVar.snd = armAnnouncent(sound.pnt[var.itmActual+1])								-- "preload" call out
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
	
	
	
	
	
-- ***********************************************
--    select item using "momentary hold" ; short ++  long --
-- ***********************************************
local function itmSelect(switch,Numitems,var,selMode)
	local trimA = "T5"
	local trimB = "T6"


	local member1
	local member2

	local newValue
	print("503 selMode",selMode)
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


function CRV_frontendConfigure(widget,appTxt,curve)		
	var={
		itmActual		= nil,																-- point to highlight 
--		itmActualshadow = nil 																-- used by trim button handling (prprocessing)
		itmSwValue		= 0,																-- former point selector value
		itmSwTime		= 0,
		itmChngeActive	= false,
		itmPotNeutral	= false,
		itmOldVal		= 0,
		itmHandle		= SAVED	,															-- start condition
		itmTrimDir		= NEUTRAL																	-- used by trim button handling (direction handler)
		}
		
	widget.setCurve ={}
	widget.setCurve.txt = appTxt
	backupCurve(curve)

	return true
end


function checklimits(value,minimum,maximum)
	if value > maximum then
		return maximum
	elseif value < minimum then
		return minimum
	end
	
	return value

end

-- **************************************************************************************
-- *************************      main function **************************
-- **************************************************************************************


-- function setCurve(frameX,page,layout,theme,touch,evnt,subConf,appConfigured,appTxt,widget)
function setCurve(frameX,page,layout,theme,touch,evnt,subConf,appConfigured,txt,widget)
	lookupPot={								-- !!! analog input name; sequence / index MUST CORRESPOND TO FORM CHOICELIST // Config handler !!!!!  >> file suite_conf.lua
		"Pot1",								-- could be done more elegant, but so we have a tiny/easy choice List
		"Pot2",	
		"Pot3",	
		"Pot4",
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
	cvVar.targetCurve	= subConf[1]-1						-- curve
	cvVar.input 		= subConf[2]						-- input
	cvVar.trimPot		= lookupPot[subConf[3]]				-- trim 
	cvVar.ptSelector	= lookupSel[subConf[4]]				-- point selector
	cvVar.SW_restore	= subConf[5]						-- restore switch

	crv = model.getCurve(cvVar.targetCurve)
	
	-- print("714 trimmer:",cvVar.trimPot)
	-- print("715 switch det:",cvVar.ptSelector)
	if cvVar.ptSelector=="SH"  or cvVar.ptSelector=="SI" or cvVar.ptSelector=="SJ" then	--determn selector mode
		cvVar.selMode = MODE_MOMENTARY
	elseif cvVar.ptSelector=="T5" or cvVar.ptSelector=="T6" then
		cvVar.selMode = MODE_TRIM
	else
		cvVar.selMode = MODE_LSW
	end

	-- print("725 determine ",cvVar.selMode)
												-- one time config; cant be executed during create cause window size not availabe then
	if not(appConfigured) then	
		-- ***************************    "init"       *********************************************************
		appConfigured 		= CRV_frontendConfigure(widget,txt,crv)
		cvVar.crv1Bmp1		= lcd.loadBitmap("/scripts/libUnow/bmp/Vbar2.png")
	--	cvVar.selectorVal 	= getSwitch(cvVar.ptSelector)

			
	end	
																					-- refresh language in case changed during runtime
	if system.getLocale() =="de" then
		lan = 1
	else
		lan = 2 																		-- not supported language, so has to be "en" 
	end


	local Cv = {}

	Cv.xLeft 		= 5						-- left border
	Cv.xRight 		= 95					-- right border
	Cv.xWidth 		= (Cv.xRight-Cv.xLeft)	-- centerline
	
	Cv.yUp			= 0						-- startline drawing area
	Cv.yDwn			= 70					-- endline
	Cv.yCntr		= (Cv.yDwn-Cv.yUp)/2	-- y centerline
	Cv.yWidth		= Cv.yDwn-Cv.yUp
	
	Cv.thickness = 1
	Cv.PotNeutral	= false

	Cv.scaleX 		= Cv.xWidth/100
	Cv.scaleY 		= Cv.yWidth/100
	
	Cv.PotVal,Cv.PotNeutral		= getPotVal(cvVar.trimPot)							-- get value & status of Pot
	
	
	Cv["marker"] = {}																-- definition of marker (optical / audio "feedback") >>  percent values														
		Cv.marker.outer		= MARK_OUTER													-- "wide"
		Cv.marker.inner 	= MARK_INNER													-- "narrow"
		Cv.marker.hit		= MARK_HIT														-- "hit curve point"

	

	if var.itmActual == nil then
--		var.itmActual = crv:pointsCount()-1													-- start condition (first or last point etc..)
		var.itmActual = 0															-- 1st point
		storeOldValue()
	end	
	
-- ***************************    some checks on start   (user activities )   ******************************************
	
	if cvVar.snd.checkAnn then														-- announcement imminent, check if it should be triggered
		--print("testann")
		if getTime() - cvVar.snd.preLoadTime > DELAY_PNT then								-- wait some time, so "browsing" doesn't sound repeats
			playWav(cvVar.snd.wav)
			cvVar.snd = resetPntAnn()												-- reset ann
		end	
	end

--  ---------

	local cv_X, cv_Y = crv:point(var.itmActual)										-- get actual XY coordinates of curve-point you want to trim	
	
	--	*******					"selector / switch",		"numbers",			"data"		
	checkSaveVal(cvVar.ptSelector,cvVar.selMode)
	var.itmActual = itmSelect(cvVar.ptSelector,  crv:pointsCount() ,var, cvVar.selMode)  			-- get actual "trim/tuning"-item number (here: point of curve you want to change)				
	var.itmHandle = itmCheckActive(cvVar.trimPot,Cv.PotNeutral)						-- determine working mode (handler:  idle / tuning / saved)	

	if getSource(cvVar.SW_restore) > 0	then										-- check if masterReset was requested
		if cvVar.armReset then														-- must be true to ensure one time call, so: reset
			crv = restoreCurve(crv,cvVar.curve_org)
			playWav(sound.reset)
			cvVar.armReset = false													-- ensure one time call
		else
																					-- .. future use
		end
	else																			-- if not: go ahead
		cvVar.armReset = true
		if var.itmHandle == CHANGING then												-- when in changing mode: new curve points
			local cvX,cvY 	= crv:point(var.itmActual)									-- get old "generic" X/Y values
			local cvYnew 	= 0.35*Cv.PotVal	+ var.itmOldVal							-- change Y to new value, for safety reasons: 35% range as limit ;  cvVar.chngePntVal = value at start of tuning !
			--print("845 newval",var.itmOldVal	,cvYnew)
			cvYnew = checklimits(cvYnew,(-100),(100))
			crv:point(var.itmActual,cvX,cvYnew)											-- save new value
		end
	end	
	
	
-- ***************************    "GO"       *********************************************************
	

	

	
	local Xvalue	= cvVar.input:value()/1024*100									-- input-value in percent
	Cv.thickness 		= evalThick(cv_X, cv_Y,Xvalue,Cv.marker)							-- calculate thickness of cursor
	playCurSignal(Cv.thickness)														-- play "Catch" signal; corresponds to cursor thickness
	
	local xA = 50	+ Xvalue/2*Cv.scaleX											-- Cursor: calc relative x position in widget


	-- ***************************    "PAINT"       *********************************************************
	
	-- widget,theme,frameX, Cv  (var=global!!)
	lcd.invalidate()																-- on every call full refresh
	lcd.color(widget.theme.c_backgrAll )											-- clear screen
	lcd.drawFilledRectangle(1,1,widget.w,widget.h)
	
	highlightBar(var.itmActual,crv,Cv.marker.outer,Cv.yWidth,Cv.scaleX ,frameX) 	-- highlight tuning area
				
	drawCursor(xA,Cv.yUp,xA,Cv.yDwn, frameX, Cv.thickness,theme)					-- draw Cursor	
	drawCurve(crv,Cv,frameX,theme)													-- draw curve
	
	local headline = widget.setCurve.txt.crvname[lan] .. " "..crv:name()			-- built text for curvename / headline string
	drawInfo(Cv,cv_X,cv_Y,headline,theme,frameX)									-- draw text/numerical infos

	return(appConfigured)
end

