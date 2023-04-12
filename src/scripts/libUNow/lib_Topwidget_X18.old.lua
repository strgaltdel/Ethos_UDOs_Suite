-- **************************************************************************************
-- ***********************          several top bar widgets         *********************
-- **************************************************************************************

--local RECT_WIDTH <const>  	= 8.5  -- percentage
tmpClockTop = 0

-- *************************      specific TopLine draw functions ***********************
function soundAlarm()
	system.playTone(1600,120)
end

function displayTeleTop(sensor,x,y,frameX,theme)					-- display telemetry values; sizing in standard 2x4 arrangement (2 cols / 4 rows)

	lcd.color(theme.c_textStd)
	local value, valueStrg
	

-- ***************************   exception handling **********************************************
	
--	if sensor.xh == false then										-- exception handler ?

		if demoMode == true then									-- demo mode ?
			--if debug7 then print("demoMode print TestVala") end
			value = sensor.testVal
		else
			value = sensor.val
		end	
				

		
		valueStrg = string.format("%." .. sensor.dec .. "f",value)		-- format decimals								
		frame.drawText(x, y,  valueStrg, RIGHT ,  frameX)				-- print value


--	end

	
end



function displayTeleBMP(sensor,x,y,iconsize,frameX,theme)					-- display telemetry values; sizing in standard 2x4 arrangement (2 cols / 4 rows)
	frame.drawBitmap(x,  y,  sensor.bmp,  iconsize.width,  iconsize.height,  frameX)
	
	--print("BMP",sensor.name,x,y,iconsize.width,iconsize.width,frameX.x,frameX.y,frameX.w,frameX.h)
	
end


-- **************************************************************************************
-- *************************      top bar   widgets      ********************************
-- **************************************************************************************



-- ***********   					receiver strength

function top_RecStrenght(xx,Y1,Y2,Yoffset, frameX,theme,iconsize)
	local televal = "rssi"
--	local col_Value = lcd.RGB(255, 255, 255)
	lcd.color(theme.c_textStd)
	
	lcd.font(txtSize.big)
	displayTeleTop(sensors["VFR"],xx+3, 		Y1 , frameX,theme, dy)
	--displayTeleBMP(sensors["rssi"],xx+4, 	Y1 + Yoffset, iconsize, frameX)
	displayTeleTop(sensors["rssi"],xx+15, 	Y1 , frameX,theme, dy)
	displayTeleBMP(sensors["RxBt"],xx+1, 	Yoffset, iconsize, frameX,theme)
	
	
	lcd.color(theme.c_textgrey1)
	lcd.font(txtSize.Xsml)
	frame.drawText(xx +2, 		87,  "VFR", RIGHT ,  frameX)
	frame.drawText(xx +14, 		87,  "RSSI", RIGHT ,  frameX)	
	
	
end




-- ***********   					ls stati
-- called by 	top_status(xx,Y1,Y2,Yoffset, frameX, "ls10","ls11", "Flaperon","snapflap")

function top_status(xx,Y1,Y2,Yoffset, frameX,theme, layout, lsTop, lsBot,labeltop, labelbottom)
	local colortmp, xTxt, yTxt
	colortmp = theme.c_indOn
	lcd.color(colortmp)
	
	frame.drawFilledRectangleRnd(xx,Yoffset+Y1,layout.width01,Yoffset+Y2-Y1-10, frameX,8)

	
	colortmp = theme.c_indOff
	lcd.color(colortmp)
	frame.drawFilledRectangleRnd(xx,Yoffset+Y2,layout.width01,Yoffset+Y2-Y1-10, frameX,8)
	
	lcd.color(theme.c_textStd)
	lcd.font(txtSize.Xsml)
	xTxt = xx+0.3
	
	yTxt = Yoffset+Y1+4+(Y2-Y1)/255
	frame.drawText(	xTxt, yTxt,  labeltop, LEFT ,  frameX)
	
	yTxt = Yoffset+Y2+4+(Y2-Y1)/255
	frame.drawText(	xTxt, yTxt,  labelbottom, LEFT ,  frameX)

end


-- ***********   					name


function top_text(xx,Y1,Yoffset, frameX,theme, layout, text,col)

	lcd.color(col)
	lcd.font(txtSize.sml)
	
	yTxt = Yoffset+Y1
	frame.drawText(	xx, yTxt,  text, LEFT ,  frameX)
	


end


-- ***********   					 top safety init via pcall
function initSfty(value)
	if value > 0 then
		return(true)
	end
end




-- ***********   					ls stati

function top_safety(xx,Y1,Yoffset, frameX,theme,layout,cond_safety,cond_engine,param)
	local condSafe		=  false
	local condArmed 		=  false
	local condAlarm		=  false
	local condRunning	=  false
	local safety,engineStatus
	
	
	if pcall( function ()initSfty(param["TOP_SaftyInit"]) end) then
		-- OK
	else
		-- one time initialisation
		param["TOP_SaftyInit"] = 1			-- flag "one time run" parameter
		param["TOP_SafetyTime"] = 0			-- flag "one time run" parameter
	end
	

	--source= system.getSource({categfory=CATEGORY_LOGIC_SWITCH, name="LSW1"})
	safety		= system.getSource({category=CATEGORY_LOGIC_SWITCH, name=cond_safety})
	engineStatus= system.getSource({category=CATEGORY_LOGIC_SWITCH, name=cond_engine})

	--if sourceSafe.value > 0 then condSafe = true end

	if  safety:value()						> 0		then  condSafe 		= true	end
	if  condSafe 		and  engineStatus:value() > 0 		then  condAlarm 		= true 	end	
	if not(condSafe) and not(condAlarm) 				then  condArmed 		= true	end
	if not(condSafe)	and engineStatus:value()  > 0		then  condRunning	= true 	end	

	--print("Safety:", safety:name(), condSafe,engineStatus:name() ,condAlarm )
	
	local xTxt = xx+1
	
	if condRunning then
		colortmp = theme.c_statusAlarm
		
		lcd.color(colortmp)
		frame.drawFilledRectangleRnd(xx,Yoffset,layout.width01+3,95, frameX,8)
		
		lcd.color(theme.c_textStd)
		lcd.font(txtSize.Xsml)
		frame.drawText(	xTxt, 40,  txt_.motorOn, LEFT ,  frameX)
		
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
			-- print("ALARM END")
			-- beep
			param.TOP_SafetyTime = tmp
			colIndex = math.abs(colIndex-1)						-- toggle colors
		 end	
		 
		 
		colortmp = colorR[colIndex+1]			
		lcd.color(colortmp)
		frame.drawFilledRectangleRnd(xx,Yoffset,layout.width01+3,95, frameX,8)

		colortmp = colorT[colIndex+1]	
		lcd.color(colortmp)
		lcd.font(txtSize.Xsml)
		frame.drawText(	xTxt, 40,  txt_.motorOn, LEFT ,  frameX)

		 --print("ALARM", tmp,tmpClockTop)
		 
	elseif condArmed then
		colortmp = theme.c_statusPrewarn
		lcd.color(colortmp)
		frame.drawFilledRectangleRnd(xx,Yoffset,layout.width01+3,95, frameX,8)
		
		lcd.color(theme.c_textRed)
		lcd.font(txtSize.Xsml)
		frame.drawText(	xTxt, 40,  txt_.motorArmed, LEFT ,  frameX)
	
	
	
	else
		colortmp = theme.c_statusOKOK
		lcd.color(colortmp)
		frame.drawFilledRectangleRnd(xx,Yoffset,layout.width01+3,95, frameX,8)
		
		lcd.color(theme.c_textStd)
		lcd.font(txtSize.Xsml)
		frame.drawText(	xTxt, 40,  txt_.motorSafe, LEFT ,  frameX)	
	
	end
	--[[
	lcd.color(theme.c_textStd)
	lcd.font(txtSize.Xsml)
	xTxt = xx+0.3
	
	yTxt = Yoffset+Y1+4+(Y2-Y1)/255
	frame.drawText(	xTxt, yTxt,  labeltop, LEFT ,  frameX)
	
	yTxt = Yoffset+Y2+4+(Y2-Y1)/255
	frame.drawText(	xTxt, yTxt,  labelbottom, LEFT ,  frameX)
	]]
	return (param)
end








-- ***********   					Tx/Rx Voltage (vertical Bat)

function top_BatV(xx,Y1,Y2,Yoffset, frameX,theme, txMin, txMax, txVal, rxMin, rxMax, rxVal)
	local col_txt = lcd.RGB(120, 120, 120)
	if txVal > txMax then txVal= txMax end
	lcd.font(txtSize.sml)
-- TX
	lcd.color(theme.c_textStd)
	displayTeleTop(sensors["TxBt"],	xx+4, Y1 , frameX,theme)						-- PRINT VALUE
	lcd.color(theme.c_textgrey1)
	frame.drawText(					xx+0, Y2,   txt_.Tx, LEFT ,  frameX)			-- print LABEL
	--draw vertical Bat symbol (PosX, PosY, width (%), height (%), tickness lines, frame,  minV, maxV, value)
	drawBat_V(xx+ 0.5,5,4,95,2,frameX,txMin,txMax,txVal)
	--drawBat_V2(xx+5,Yoffset+1,4,95,2,frameX,txMin,txMax,txVal)

-- RX	
	if rxVal > rxMax then rxVal= rxMax end
	lcd.color(theme.c_textStd)	
	displayTeleTop(sensors["RxBt"],	xx+15.1, 	Y1 , frameX,theme)
	lcd.color(theme.c_textgrey1)	
	--frame.drawText(					xx+17.5, 	Y2,  " Rx", RIGHT ,  frameX)
	frame.drawText(					xx+14.6 ,	Y2,  txt_.Rx, RIGHT ,  frameX)
	drawBat_V(xx+4.3,5,4,95,2,frameX,rxMin,rxMax,rxVal)
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

	displayTeleTop(sensors["TxBt"],xx+6, 		Y1, frameX,theme)
	drawBat_H(xx-3,Y2,batlength,50,2,frameX,txMin, txMax, txVal)
	

	displayTeleTop(sensors["RxBt"],xx+16, 	Y1, frameX,theme)	
	drawBat_H(xx+8,Y2,batlength,50,2,frameX,rxMin, rxMax, rxVal)

end


-- ***********   					Timer


function top_timer(xx,Y1,Y2,Yoffset, frameX,theme, tmr1, tmrTxt1, tmr2, tmrTxt2)
	lcd.font(txtSize.sml)
	

	local col_txt = lcd.RGB(120, 120, 120)
	local tim1 	= model.getTimer(tmr1)
	local t1Val	= tim1.value(tim1)
	local tim2 	= model.getTimer(tmr2)
	local t2Val = tim2.value(tim2)
	
	local xOffs = 6

	
	--****************    timer 1 formatting   **********************
	
	local hourVal = math.floor(t1Val/3600)
	local hour = string.format("%i", hourVal)
	if hourVal < 10 then hour = "0"..hour end
	
	local minuteVal = math.floor((t1Val-(hour*3600))/60)
	local minute =string.format("%i",  minuteVal)
	if minuteVal < 10 then minute = "0"..minute end
	
	local secVal =  t1Val - (minute*60) - (hour*3600)
	local sec =string.format("%i", secVal)
	if secVal < 10 then sec = "0"..sec end

	local timerTxt1 = minute..":"..sec					-- format mm:ss
	
	--****************    timer 2 formatting   **********************
	
	hourVal = math.floor(t2Val/3600)
	hour = string.format("%i", hourVal)
	if hourVal < 10 then hour = "0"..hour end
	
	minuteVal = math.floor((t2Val-(hour*3600))/60)
	minute =string.format("%i",  minuteVal)
	if minuteVal < 10 then minute = "0"..minute end
	
	secVal =  t2Val - (minute*60) - (hour*3600)
	sec =string.format("%i", secVal)
	if secVal < 10 then sec = "0"..sec end
	
	local timerTxt2 = minute..":"..sec					-- format mm:ss
	
	--print("timer",timerTxt1,timerTxt2)
	lcd.color(theme.c_textgrey1)
	frame.drawText(xx+xOffs, 	Y1,  tmrTxt1 , 	RIGHT ,  frameX)
	frame.drawText(xx+xOffs, 	Y2,  tmrTxt2 , 	RIGHT ,  frameX)	
	lcd.color(theme.c_textStd)	
	frame.drawText(xx+xOffs +0.5, 	Y1,  timerTxt1, LEFT ,  frameX)
	frame.drawText(xx+xOffs +0.5, 	Y2,  timerTxt2, LEFT ,  frameX)
	

end

