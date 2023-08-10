--- The lua library "lib_Topwidget.lua" is licensed under the 3-clause BSD license (aka "new BSD")
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

-- Rev 0.5, Oct 2022


-- local demoMode <const> = true
local demoMode <const> = false

local OK <const> 		= 1
local WARNING <const>	= 2
local ALARM <const> 	= 3

local bmpPath <const> = "/scripts/libUnow/bmp/X18/"

local bmp_rec 	={}
	bmp_rec[OK] 	= lcd.loadBitmap(bmpPath .. "Ant_ok.png")
	bmp_rec[WARNING]= lcd.loadBitmap(bmpPath .. "Ant_warn.png")
	bmp_rec[ALARM] 	= lcd.loadBitmap(bmpPath .. "Ant_alarm.png")
	
--[[
local bmp_rec = {
				{lcd.loadBitmap("/scripts/libUnow/bmp/X18/Ant_ok.png")},
				{lcd.loadBitmap("/scripts/libUnow/bmp/X18/Ant_warn.png")},
				{lcd.loadBitmap("/scripts/libUnow/bmp/X18/Ant_alarm.png") },
		}
	
local bmp_RecOK 	= lcd.loadBitmap("/scripts/libUnow/bmp/X18/Ant_ok.png")
local bmp_RecWarn 	= lcd.loadBitmap("/scripts/libUnow/bmp/X18/Ant_warn.png")
local bmp_RecAlarm 	= lcd.loadBitmap("/scripts/libUnow/bmp/X18/Ant_alarm.png") 
--]]	

-- **************************************************************************************
-- *****                   several top bar widgets                         **************
-- *****    use case: full screen widget with autonomous widget mgmt       **************
-- **************************************************************************************

--local RECT_WIDTH <const>  	= 8.5  -- percentage
tmpClockTop = 0

-- *************************      specific TopLine draw functions ***********************
function soundAlarm()
	system.playTone(1600,250)
	--system.playNumber(1)
	 print("SOUND")
end






function displayTeleTop(value,decimals,x,y,frameX,theme)					-- display telemetry values; sizing in standard 2x4 arrangement (2 cols / 4 rows)

	lcd.color(theme.c_textStd)


		valueStrg = string.format("%." .. decimals .. "f",value)		-- format decimals								
		frame.drawText(x, y,  valueStrg, RIGHT ,  frameX)				-- print value
--	end
end



function displayTeleBMP(sensor,x,y,iconsize,frameX,theme,icon)					-- display telemetry values; sizing in standard 2x4 arrangement (2 cols / 4 rows)
	--print("disp icon x y w h:",x,y, iconsize.width,  iconsize.height)

	if icon == nil then																				-- use std sensor bitmap
		frame.drawBitmap(x,  y,  sensor.bmp,  iconsize.width,  iconsize.height,  frameX)

		else																							-- use alternate bitmap
--		if sensors.name == "RSSI" then
			frame.drawBitmap(x,  y,  icon,  iconsize.width,  iconsize.height,  frameX)
--		end
	end
	--print("BMP",sensor.name,x,y,iconsize.width,iconsize.width,frameX.x,frameX.y,frameX.w,frameX.h)
	
end


-- **************************************************************************************
-- *************************      top bar   widgets      ********************************
-- **************************************************************************************


--[[
-- ***********   					receiver strength

function top_RecStrenght(xx,Y1,Y2,Yoffset, frameX,theme,iconsize)
	local televal = "rssi"
	local yTxt1, yTxt2 
	yTxt1 = Yoffset+Y1+(Y2-Y1)/255
	yTxt2 = Yoffset+Y2+4+(Y2-Y1)/255
--	local col_Value = lcd.RGB(255, 255, 255)
	lcd.color(theme.c_textStd)
	
	lcd.font(txtSize.big)
	displayTeleTop(sensors["VFR"],xx+3, 		Y1 , frameX,theme, dy)
--	displayTeleTop(sensors["VFR"],xx+3, 	yTxt1 , frameX,theme, dy)
--  displayTeleBMP(sensors["rssi"],xx+4, 	Y1 + Yoffset, iconsize, frameX)
--	displayTeleTop(sensors["rssi"],xx+15, yTxt2 , frameX,theme, dy)

--	displayTeleTop(sensors["rssi"],xx+15, 	Y1 , frameX,theme, dy)
--	displayTeleBMP(sensors["RxBt"],xx+1, 	Yoffset, iconsize, frameX,theme)
	
	
	lcd.color(theme.c_textgrey1)
	lcd.font(txtSize.Xsml)
	frame.drawText(xx +2, 		87,  "VFR", RIGHT ,  frameX)
	frame.drawText(xx +14, 		87,  "RSSI", RIGHT ,  frameX)	
	
	
end
--]]

-- **************************************************************************************
-- *************************      top bar   widgets      ********************************
-- **************************************************************************************

-- helper: determine warn level
local function statusRec(vfrVal,rssiVal)
	local status
	if vfrVal < 50 or rssiVal < 45 then
		status = ALARM
	elseif vfrVal < 70 or rssiVal < 65 then
		status = WARNING		
	else
		status = OK
	end
	return status
end

-- helper: get telemetry or simulated value
function getTopValue(sensor)
	local value
	if demoMode == true then									-- demo mode ?
			value = sensor.testVal
	else
			value = getTele(sensor.name)
	end	
	return value
end

-- ***********   					receiver strength

function top_RecStrenght2(xx,Y1,Y2,Yoffset, frameX,theme,iconsize,sensors,isVFR,dispType)
	local televal = "rssi"
	local yTxt1, yTxt2 
	yTxt1 = Yoffset+Y1+(Y2-Y1)/255
	yTxt2 = Yoffset+Y2+4+(Y2-Y1)/255
	
	local offsVFR = 2
	local offsBMP = -0.5
	local offsRSSI = 15
	
	local trim = {}
--	local col_Value = lcd.RGB(255, 255, 255)
--	print("95 libTop",sensors["rssi"].name)
	if dispType == "x20" then
		trim ={
			vfr 	=    2,
			bmp 	= -0.5,
			rssi 	=   15,
			yDelta =    -1,
		}
	else
		trim ={
			vfr 	=   4,
			bmp 	=  2,
			rssi 	=  18,
			yDelta 	=   8,
		}
	
	end
	
	local vfrVal 	= getTele(sensors["VFR"].name)
	local rssiVal	= getTele(sensors["rssi"].name)
--	local rssiDec	= sensors["rssi"].dec
	
--	local bmpREC = bmp_rec[statusRec(vfrVal,rssiVal)]					-- get warning level and determine corresponding bitmap

	vfrVal 	= 50	+(system.getSource({category=CATEGORY_ANALOG, name="Rudder",  }):value())/1024	*50
	rssiVal = 50	+(system.getSource({category=CATEGORY_ANALOG, name="Aileron", }):value())/1024	*50

	
	
	lcd.color(theme.c_textStd)
	lcd.font(txtSize.big)

--	if isVFR then displayTeleTop(sensors["VFR"], xx+trim.vfr, 	Y1 , frameX,theme, dy)	end				-- VFR Value
	if isVFR then displayTeleTop(vfrVal,0, xx+trim.vfr, 	Y1 , frameX,theme, dy)	end				-- VFR Value
	displayTeleBMP(sensors["rssi"],xx+trim.bmp, 	Y1 + Yoffset, iconsize, frameX,theme,bmp_rec[statusRec(vfrVal,rssiVal)])
	displayTeleTop(rssiVal,0,xx+trim.rssi, 	Y1 , frameX,theme, dy)
--	displayTeleTop(sensors["rssi"],xx+15, yTxt2 , frameX,theme, dy)

--	displayTeleBMP(sensors["RxBt"],xx+offsBMP, 	Yoffset, iconsize, frameX,theme)
	
	
	lcd.color(theme.c_textgrey1)
	lcd.font(txtSize.Xsml)
	if isVFR then frame.drawText(xx +trim.vfr  -1, 		87 + trim.yDelta,  "VFR", RIGHT ,  frameX) end
	frame.drawText(xx +trim.rssi -1, 		87 + trim.yDelta,  "RSSI", RIGHT ,  frameX)	
	
	
end

function getColor(status,theme)
	local color,colorTxt
	if status > 0 then
		return theme.c_indOn,theme.c_textindOn
	else
		return theme.c_indOff,theme.c_textindOff
	end
	
end


-- ***********   					ls stati
-- called by 	top_status(xx,Y1,Y2,Yoffset, frameX, "ls10","ls11", "Flaperon","snapflap")

function top_status(xx,Y1,Y2,Yoffset, frameX,theme, layout, lsTop, lsBot,  lsTopLabel, lsBotLabel)
	local status1,status2
	if pcall (function() status1=lsTop:value() status2=lsBot:value() end)	  then
		local colortmp, xTxt, yTxt1, yTxt2 ,color1, color1Txt,color2,color2Txt, color,colorTxt
		local fontButtonSize = txtSize.sml
		local xTxt = xx+layout.width01/2
		--colortmp = theme.c_indOn
		
		local rectHeight = 50-Y1					-- height in %
		--yTxt1 = Yoffset+Y1+(Y2-Y1)/255
		--yTxt2 = Yoffset+Y2+4+(Y2-Y1)/255
		yTxt1 = Yoffset+rectHeight*0.03			-- yPos 1
		yTxt2 = Yoffset+Y2+rectHeight*0.03		-- yPos 2

		--local status1,status2


		--if lsTop ~= nil then																				
			--local lsNumTop = tonumber(string.sub(lsTop,3,6))
			--local lsNumBot = tonumber(string.sub(lsBot,3,6))
		--	status1	= lsTop:value()
		--	status2	= lsBot:value()	
		--else																								-- use lsw name
		--	status1	= system.getSource({category=CATEGORY_LOGIC_SWITCH, name="flaperon"}):value()
		--	status2	= system.getSource({category=CATEGORY_LOGIC_SWITCH, name="snapflp"}):value()
		
	--	end
		-- colors, status dependent:
		
		color1 			= theme.c_indOn
		color1Txt		= theme.c_textindOn
		color2			= theme.c_indOff
		color2Txt		= theme.c_textindOff
		--frame.drawFilledRectangleRnd(xx,Yoffset+Y1,layout.width01,Yoffset+Y2-Y1-10, frameX,8)
		
		lcd.font(fontButtonSize)
		color,colorTxt = getColor(status1,theme)
		lcd.color(color)
		frame.drawFilledRectangleRnd(xx,Yoffset,layout.width01,rectHeight, frameX,8)
		lcd.color(colorTxt)
		frame.drawText(	xTxt, yTxt1,   lsTopLabel,  CENTERED,  frameX)
		
		color,colorTxt = getColor(status2,theme)
		--colortmp = theme.c_indOff
		lcd.color(color)
		--frame.drawFilledRectangleRnd(xx,Yoffset+Y2,layout.width01,Yoffset+Y2-Y1-10, frameX,8)
		frame.drawFilledRectangleRnd(xx,Yoffset+Y2,layout.width01,rectHeight, frameX,8)
		
		lcd.color(colorTxt)
		lcd.font(fontButtonSize)
		--xTxt = xx+0.3

		
		frame.drawText(	xTxt, yTxt2,  lsBotLabel,  CENTERED ,  frameX)
	else
		print("failure TOBSTATUS lsw definition")
	end
end


-- ***********   					name


function top_text(xx,Y1,Yoffset, frameX,theme, layout, text,col)

	lcd.color(col)
	lcd.font(txtSize.sml)
	lcd.font( FONT_BOLD)
	
	yTxt = Yoffset+Y1
	frame.drawText(	xx, yTxt,  text, LEFT ,  frameX)
	


end


-- ***********   					 top safety init via pcall
function initSfty(value)
	if value > 0 then
		return(true)
	else
		return(false)
	end
end





-- ***********   					show safety switch status

function top_safety(xx,Y1,Yoffset, frameX,theme,layout,appTxt,	lsMotSafe,lsMotRunning,	param)
		local condSafe		=  false
		local condRunning	=  false
		
	if pcall(function() condRunning=(lsMotRunning:value() >0)   condSafe=(lsMotSafe:value()>0) end ) then
		local condArmed 	=  false
		local condAlarm		=  false

		
		local safety,engineStatus
		
		local fontButtonSize = txtSize.sml
		
		if system.getLocale() =="de" then
			lan = 1
		else
			lan = 2 																		-- not supported language, so has to be "en" 
		end
		
		if pcall( function ()initSfty(param["TOP_SaftyInit"]) end) then
			-- OK
		else
			-- one time initialisation
			param["TOP_SaftyInit"] = 1			-- flag "one time run" parameter
			param["TOP_SafetyTime"] = 0			-- flag "one time run" parameter
		end
		

		
	--	condRunning		= (lsMotRunning:value() >0)								-- eval if motor input will deliver "run" status
	--	condSafe 		= (lsMotSafe:value()	>0) and not(condRunning)		-- eval if safety/kill switch is active & "disconnects" any motor inputs
		condArmed		= not(condSafe) 			and not(condRunning)		-- eval if safety switch is inactive but no motor input recognized
		condAlarm		= condSafe 					and condRunning				-- eval if tx outputs "motor: run", only rx switched off state prevents engine from start


		

		
		local xTxt = xx+layout.width02/2			-- y centerline
		local yTxt1 = 15
		local yTxt2 = 30
		if condRunning then
			colortmp = theme.c_statusAlarm
			
			lcd.color(colortmp)
			frame.drawFilledRectangleRnd(xx,Yoffset,layout.width02,95, frameX,8)
			
			lcd.color(theme.c_textStd)
			lcd.font(fontButtonSize)
			frame.drawText(	xTxt, yTxt1,  appTxt.motorON[lan], CENTERED ,  frameX)
			
		elseif condAlarm then
			local  tmp = os.clock()
			local colorT={}
			local colorR={}
			local colIndex = 1
			colorR[1] = theme.c_statusAlarm
			colorT[1] = theme.c_textStd
			colorR[2] = theme.c_statusWarn
			colorT[2] = theme.c_textRed
			
			tmp = os.clock()
			if tmp-param.TOP_SafetyTime > 0.5 then
					soundAlarm()

				-- beep
				param.TOP_SafetyTime = tmp
				colIndex = math.abs(colIndex-1)						-- toggle colors
			 end	
			 
			 
			colortmp = colorR[colIndex+1]			
			lcd.color(colortmp)
			frame.drawFilledRectangleRnd(xx,Yoffset,layout.width02,95, frameX,8)

			colortmp = colorT[colIndex+1]	
			lcd.color(colortmp)
			lcd.font(fontButtonSize)
			frame.drawText(	xTxt, yTxt1,  appTxt.motorOn[lan], CENTERED ,  frameX)


			 
		elseif condArmed then
			colortmp = theme.c_statusPrewarn
			lcd.color(colortmp)
			frame.drawFilledRectangleRnd(xx,Yoffset,layout.width02,95, frameX,8)
			
			lcd.color(theme.c_textRed)
			lcd.font(fontButtonSize)
			frame.drawText(	xTxt, yTxt2,  appTxt.motorArmed[lan], CENTERED  ,  frameX)
		
		
		
		else
			colortmp = theme.c_statusOKOK
			lcd.color(colortmp)
			frame.drawFilledRectangleRnd(xx,Yoffset,layout.width02,95, frameX,8)
			
			lcd.color(theme.c_textStd)
			lcd.font(fontButtonSize)
			frame.drawText(	xTxt, yTxt2,  appTxt.motorSafe[lan], CENTERED  ,  frameX)	
		
		end
	else
		print("failure TOPSAFETY: ls definition")
	end
	return (param)
end




--[[


-- ***********   					Tx/Rx Voltage (vertical Bat)

function top_BatV(xx,Y1,Y2,Yoffset, frameX,theme, txMin, txMax, txVal, rxMin, rxMax, rxVal)
	local col_txt = lcd.RGB(120, 120, 120)
	if txVal > txMax then txVal= txMax end
	lcd.font(txtSize.sml)
-- TX
	lcd.color(theme.c_textStd)
	displayTeleTop(sensors["TxBt"],	xx+2.9, Y1 , frameX,theme)						-- PRINT VALUE
	lcd.color(theme.c_textgrey1)
	lcd.font(txtSize.sml)
	frame.drawText(					xx-0.7, Y2+5,   txt_.Tx, LEFT ,  frameX)			-- print LABEL
	--draw vertical Bat symbol (PosX, PosY, width (%), height (%), tickness lines, frame,  minV, maxV, value)
	drawBat_V(xx+ 0.5,5,4,95,2,frameX,txMin,txMax,txVal)
	--drawBat_V2(xx+5,Yoffset+1,4,95,2,frameX,txMin,txMax,txVal)

-- RX	
	if rxVal > rxMax then rxVal= rxMax end
	lcd.font(txtSize.sml)
	lcd.color(theme.c_textStd)	
	displayTeleTop(sensors["RxBt"],	xx+15.4, 	Y1 , frameX,theme)
	lcd.color(theme.c_textgrey1)	
	lcd.font(txtSize.sml)
	--frame.drawText(					xx+17.5, 	Y2,  " Rx", RIGHT ,  frameX)
	frame.drawText(					xx+14.8 ,	Y2+5,  txt_.Rx, RIGHT ,  frameX)
	drawBat_V(xx+4.3,5,4,95,2,frameX,rxMin,rxMax,rxVal)
	--drawBat_V2(xx+9.5,Yoffset+1,4,95,2,frameX,rxMin,rxMax,rxVal)
	
end
--]]




-- ***********   					Tx/Rx Voltage (vertical Bat)

function top_BatV2(xx,Y1,Y2,Yoffset, frameX,theme, txMin, txMax, txVal, rxMin, rxMax, rxVal,dispType)
	local col_txt = lcd.RGB(120, 120, 120)
	if txVal > txMax then txVal= txMax end
	lcd.font(txtSize.sml)
	
	local batWid = 6
	local bathgt = 90
	local offsTx = -0.7
	local offsRx = 15.5
	
	if dispType == "x20" then
		trim ={
			yOff	=	  0,
			yDelta 	=	 -1,
			xTxt1	=	  2,
		}
	else
		trim ={
			yOff	=	 12,
			yDelta 	=	 -4,
			xTxt1	=	0.5,
		}
	
	end
	
	-- txVal = 8+(system.getSource({category=CATEGORY_ANALOG, name="Throttle", }):value())/1024
	-- rxVal = 5.2+(system.getSource({category=CATEGORY_ANALOG, name="Elevator", }):value())/2048

-- TX
	lcd.color(theme.c_textStd)
	displayTeleTop(txVal,1,	xx+2.9, 		Y1+trim.yOff , frameX,theme)			-- PRINT VALUE
	
	lcd.color(theme.c_textgrey1)
	lcd.font(txtSize.sml)	
	frame.drawText(		xx+offsTx, 				Y2+trim.yOff+trim.yDelta,   "Tx", LEFT ,  frameX)			-- print LABEL
	drawBat_V(			xx+ 2.5,				5+trim.yOff,		batWid,bathgt,2,frameX,txMin,txMax,txVal)
	
	--draw vertical Bat symbol (PosX, PosY, width (%), height (%), tickness lines, frame,  minV, maxV, value)
	--drawBat_V2(xx+5,Yoffset+1,4,95,2,frameX,txMin,txMax,txVal)

-- RX	
	if rxVal > rxMax then rxVal= rxMax end
	lcd.font(txtSize.sml)
	lcd.color(theme.c_textStd)	
	displayTeleTop(rxVal,1,	xx+offsRx, 	Y1 +trim.yOff, frameX,theme)				-- PRINT VALUE
	
	lcd.color(theme.c_textgrey1)	
	lcd.font(txtSize.sml)
	frame.drawText(		xx+15+trim.xTxt1, 	Y2+trim.yOff+trim.yDelta,  	" Rx", RIGHT ,  frameX)
	drawBat_V(			xx+6.5,					5+trim.yOff,		batWid,bathgt,2,frameX,rxMin,rxMax,rxVal)
	 
	 
--	frame.drawText(					xx+14.8 ,	Y2+5,  txt_.Rx, RIGHT ,  frameX)
--	frame.drawText(					xx+offsRx ,	Y2+5,  txt_.Rx, RIGHT ,  frameX)
-- bmp

	-- drawBat_V(xx+4.3,5,4,95,2,frameX,rxMin,rxMax,rxVal)
	--drawBat_V2(xx+9.5,Yoffset+1,4,95,2,frameX,rxMin,rxMax,rxVal)
	
end




-- ***********   					Tx/Rx Voltage (horizontal Bat)

function top_BatH(xx,Y1,Y2,Yoffset, frameX,theme, txMin, txMax, txVal, rxMin, rxMax, rxVal)

	--displayTeleBMP(sensors["RxBt"],xx+1, 	Y1 + Yoffset, iconsize, frameX, dy)	
	
	local batlength = 8		-- lenght in %
	lcd.color(theme.c_textgrey1)	
	lcd.font(txtSize.sml)
	frame.drawText(xx+0, 	Y1,  "Tx:", RIGHT ,  frameX)	
	frame.drawText(xx+12, 	Y1,  "Rx:", RIGHT ,  frameX)

	displayTeleTop(txVal,1,xx+6, 		Y1, frameX,theme)
	drawBat_H(xx-3,Y2,batlength,50,2,frameX,txMin, txMax, txVal)
	

	displayTeleTop(rxVal,1,xx+16, 	Y1, frameX,theme)	
	drawBat_H(xx+8,Y2,batlength,50,2,frameX,rxMin, rxMax, rxVal)

end


-- ***********   					Timer


function top_timer(xx,Y1,Y2,Yoffset, frameX,theme, tmrA, tmrAtxt, tmrB, tmrBtxt)
	lcd.font(txtSize.sml)
	local tmrOffset <const>  = 1								-- set 1 in case timer 1 has index 0

	local col_txt 		= lcd.RGB(120, 120, 120)
	local col_negativ	= lcd.RGB(200, 0, 0)
	local timA 			= model.getTimer(tmrA-tmrOffset)
	local timA_val		= timA.value(timA)
	local timB 			= model.getTimer(tmrB-tmrOffset)
	local timB_val 		= timB.value(timB)
	
	local xOffs = 6
	local yTxt1, yTxt2 
	local rectHeight = 50-Y1					-- height in %
	yTxt1 = Yoffset+rectHeight*0.03
	yTxt2 = Yoffset+Y2+rectHeight*0.03
	
	--****************    timer 1 formatting   **********************
	
	local hourVal = math.floor(math.abs(timA_val)/3600)
	local hour = string.format("%i", hourVal)
	if hourVal < 10 then hour = "0"..hour end
	
	local minuteVal =math.floor((math.abs(timA_val)-(hourVal*3600))/60)
	local minute =string.format("%i",  minuteVal)
	if minuteVal < 10 then minute = "0"..minute end
	
	local secVal =  math.abs(timA_val) - (minuteVal*60) - (hourVal*3600)
	local sec =string.format("%i", secVal)
	if secVal < 10 then sec = "0"..sec end

	local timerTxtA = minute..":"..sec					-- format mm:ss
	
	--print("**************  TIMER1",timA_val,hourVal,minuteVal,secVal)
	--****************    timer 2 formatting   **********************
	
	hourVal = math.floor(math.abs(timB_val)/3600)
	hour = string.format("%i", hourVal)
	if hourVal < 10 then hour = "0"..hour end
	
	minuteVal = math.floor((math.abs(timB_val)-(hour*3600))/60)
	minute =string.format("%i",  minuteVal)
	if minuteVal < 10 then minute = "0"..minute end
	
	secVal =  math.abs(timB_val) - (minute*60) - (hour*3600)
	sec =string.format("%i", secVal)
	if secVal < 10 then sec = "0"..sec end
	
	local timerTxtB = minute..":"..sec										-- format mm:ss
--[[	
	--print("timer",timerTxtA,timerTxtB)
	lcd.color(theme.c_textgrey1)
	frame.drawText(xx+xOffs, 	Y1,  tmrAtxt , 	RIGHT ,  frameX)
	frame.drawText(xx+xOffs, 	Y2,  tmrBtxt , 	RIGHT ,  frameX)	
	lcd.color(theme.c_textStd)	
	frame.drawText(xx+xOffs +0.5, 	Y1,  timerTxtA, LEFT ,  frameX)
	frame.drawText(xx+xOffs +0.5, 	Y2,  timerTxtB, LEFT ,  frameX)
]]	
											-- text

	-- TIMER1							
	if timA_val <0 then 
		lcd.color(col_negativ) 
		frame.drawText(xx+xOffs, 		yTxt1, 	tmrAtxt , 	RIGHT ,  frameX)				-- text
		frame.drawText(xx+xOffs +0.5, 	yTxt1,  "-"..timerTxtA, 	LEFT ,  frameX)			-- time	
	else
		lcd.color(theme.c_textgrey1)	
		frame.drawText(xx+xOffs, 		yTxt1, 	tmrAtxt , 	RIGHT ,  frameX)				-- text
		lcd.color(theme.c_textStd)	
		frame.drawText(xx+xOffs +1.5, 	yTxt1,  timerTxtA, 	LEFT ,  frameX)					-- time		
	end
	
	
		-- TIMER2
	if timB_val <0 then 
		lcd.color(col_negativ)
		frame.drawText(xx+xOffs, 		yTxt2,	tmrBtxt , 	RIGHT ,  frameX)		
		frame.drawText(xx+xOffs +1.5, 	yTxt2,  "-"..timerTxtB, 	LEFT ,  frameX)		
	else
		lcd.color(theme.c_textgrey1)		
		frame.drawText(xx+xOffs, 		yTxt2,	tmrBtxt , 	RIGHT ,  frameX)	
		lcd.color(theme.c_textStd)	
		frame.drawText(xx+xOffs +1.5, 	yTxt2,  timerTxtB, 	LEFT ,  frameX)
	end

end

