-- future enhancements:
-- dynamic calculation of num pages & rows per page 


local layout_T01 	= {}
local pageLayout	= {}
local dspType 
	
local sensors = {}	

---------------
-- Define config string (read some configs, which are written during runtime, from file)
---------------
--[[ future use, maybe
function conf_teleEl()
	widgetconfLine["teleEl"]="!tele,void"		-- no special configuration
end
]]



																	-- convert timer value into string hh:mm:ss
function timer2strg(value)										
	local hour 		= math.floor(value/3600)
	local minute 	= math.floor((value-hour*3600)/60)
	local second	= value -hour*3600 -minute*60

	hour 	= string.format("%.2d", hour)	
	minute 	= string.format("%.2d", minute)
	second 	= string.format("%.2d", second)
	
	local valueStrg = hour .. ":" .. minute .. ":" .. second
	return valueStrg
end


function timer2strg2(value)										-- convert timer value to string  (short version without hour)
	local hour 		= math.floor(value/3600)
	local minute 	= math.floor((value-hour*3600)/60)
	local second	= value -hour*3600 -minute*60

	--hour 	= string.format("%.2d", hour)	
	minute 	= string.format("%.2d", minute)
	second 	= string.format("%.2d", second)
	
	local valueStrg = minute .. ":" .. second
	return valueStrg
end







function displayTele(label,sensor,x,y,iconsize,frameX,theme,dy,layout,layout_T01,bmpDraw,demoMode)					-- display telemetry values; sizing in standard 2x4 arrangement (2 cols / 4 rows)

	local col_Value 	= theme.c_textStd
	local col_Value2 	= theme.c_textgrey1
	lcd.color(col_Value)

	lcd.color(theme.c_textStd)
	lcd.font(txtSize.std)
	--lcd.font(FONT_XL_BOLD)	-- test
	local value, valueStrg
	local bmpY=0
	
	if iconsize.height < 14 then
		bmpY =12-iconsize.height
	end
	
	--  *************   Tab calculation    ***********
	local tmpOffset
	if x < 20 then					-- left column
		tmpOffset = layout_T01.TabL1	
	else
		tmpOffset = layout_T01.TabR1
	end
	local xB_offset = tmpOffset+sensor.alignB*frameX.w/1000
	local xV_offset = layout_T01.offTele1+tmpOffset+sensor.alignV*frameX.w/1000
	
	
																								-- **********************************************************************************************	
																								-- ***************************   exception handling **********************************************

	if sensor.xh == true then		
																									-- **************************		
			if label == "GPS+" or label == "GPS" then												-- ******   GPS     *********	
																									-- **************************				
				local value2,valHdop,valnSat,value2Strg
				--print("GPS detected")
				y = y + (frameX.h * 0.012)	+ 8																		-- corrective y-placement
				if bmpDraw and sensor.bmp ~= nil then
					frame.drawBitmapNative(x,  y,  sensor.bmp,  frameX)
				end
				
				if demoMode == true then							-- demo mode ?
						value 	= sensors["gpsLat"].testVal				-- lat
						value2 	= sensors["gpsLon"].testVal				-- lon
						valnSat = sensors.nSat.testVal					-- nSat
						valHdop	= sensors.HDOP.testVal					-- hdop
				else

						value 	= getTele(sensors["gpsLat"].name,sensors["gpsLat"].options)
						value2	= getTele(sensors["gpsLon"].name,sensors["gpsLon"].options)
						
						if label == "GPS+" then																		-- GPS additional data
							valnSat = getTele(sensors["nSat"].name)
							valHdop = getTele(sensors["HDOP"].name)
							if valnSat == false then valnSat = 0 end
							if valHdop == false then valHdop = 0 end					
							--print("valsat",valnSat)
							if valnSat > 100 then valnSat = valnSat-100 end

						end
				
				end
				
				-- gps coordinates
				valueStrg  = string.format("%." .. sensor.dec .. "f",value)											-- format decimals
				value2Strg = string.format("%." .. sensor.dec .. "f",value2)
				frame.drawText(89, y+0,  		valueStrg,  RIGHT ,  frameX)
				frame.drawText(89, y+0+dy*0.7, 	value2Strg, RIGHT ,  frameX)
				
				-- nsat & hdop
				if label == "GPS+" then	
					lcd.font(txtSize.sml)
					valueStrg  = string.format("%." .. sensors.nSat.dec .. "f",valnSat)								-- format decimals
					value2Strg = string.format("%." .. sensors.HDOP.dec .. "f",valHdop)
				
					local xTxt = 48					-- tab for additional data
					lcd.color(col_Value2)
					frame.drawText(xTxt, 		y-7, "nSat: ",  		RIGHT,	frameX)
					frame.drawText(xTxt+34, 	y-7, "hDop: ",  		RIGHT,  frameX)
					
					lcd.color(col_Value)
					frame.drawText(xTxt,		y-7,  valueStrg,  		LEFT , 	frameX)
					frame.drawText(xTxt+34, 	y-7,  value2Strg,		LEFT,  	frameX)
				end	
			

															
																									-- **************************																												
			elseif 	string.sub(label,1,5) == "Timer" then											-- ******   Timer   *********
																									-- **************************
				if label == "TimerX12" then
					local value2 
					local value2Strg
					if demoMode == true then																	-- demo mode ?
						valueStrg 	= sensors["TimerX12"].testVal
						value2Strg 	= "02:42"
					else
						value 		= model.getTimer(0):value()
						valueStrg 	= timer2strg2(value)	
						--print("T1",valueStrg )
							
						value2 		= model.getTimer(1):value()
						value2Strg 	= timer2strg2(value2)	
						--print("T2",value2Strg )
					end
					
					if valueStrg 	~= "" then frame.drawText(x+iconsize.width+xV_offset, y+2,  		valueStrg, RIGHT ,  frameX) end		-- timer1
					if value2Strg 	~= "" then frame.drawText(x+iconsize.width+xV_offset, y+2+dy*0.8,  value2Strg, RIGHT ,  frameX) end		-- timer2

					if bmpDraw and sensor.bmp ~= nil then						
						frame.drawBitmapNative(x+sensor.alignB*frameX.w/1000,  y+bmpY+dy*0.8,  sensor.bmp,  			frameX)		
						frame.drawBitmapNative(x+sensor.alignB*frameX.w/1000,  y+bmpY,  		sensors["TimerFR"].bmp,	frameX)					
					end
				else		
					local TimNo
					local TimNoTmp = string.sub(label,6,6)							-- get timer index
					if TimNoTmp == "F" then  
						TimNo = 1													-- tmr "Flight" = 1
					elseif 	TimNoTmp == "S" then  	
						TimNo = 2													-- tmr "Sustainer" = 2
					else		
						TimNo = tonumber(TimNoTmp)-1								-- get std timer index
					end		
					
					if bmpDraw and sensor.bmp ~= nil then	
						frame.drawBitmapNative(x+sensor.alignB*frameX.w/1000,  y+bmpY,  sensor.bmp,  frameX)
					end
					
					if demoMode == true then				-- demo mode ?
						valueStrg = string.sub(sensor.testVal,2,10)
					else
						value =  model.getTimer(TimNo):value()
						valueStrg = timer2strg(value)
					end
					frame.drawText(x+iconsize.width+xV_offset, y+2,  valueStrg, RIGHT ,  frameX)
				end
																									-- **************************
			elseif 	label == "TxBt" then															-- ******   Txbat   *********	
																									-- **************************
				if bmpDraw and sensor.bmp ~= nil then	
					frame.drawBitmapNative(x+sensor.alignB*frameX.w/1000,  y+bmpY,  sensor.bmp,  frameX)		-- bmp
				end
				
				if demoMode == true then																		-- demo mode ?
					valueStrg = string.sub(sensor.testVal,1,10)
				else
					value 		= system.getSource({category=CATEGORY_SYSTEM, member=MAIN_VOLTAGE}):value()
					valueStrg 	= tonumber(value)
				end
				frame.drawText(x+iconsize.width+xV_offset, y+2,  valueStrg, RIGHT ,  frameX)					-- Value
										
				local y_font = 5																				-- print Unit				
				tUnit = sensor.testUnit
				lcd.font(txtSize.Xsml)
				lcd.color(theme.c_textgrey1)
				frame.drawText(x+iconsize.width+xV_offset, y+2+y_font,  tUnit, LEFT ,  frameX)
			end
			
			
																			-- **********************************************************************************************
																			-- ***************************   standard handling **********************************************		
																			-- **********************************************************************************************		
	else
	
		if bmpDraw and sensor.bmp ~= nil then	
			frame.drawBitmapNative(x+xB_offset,  y+bmpY,   sensor.bmp,  frameX)					--	x=start + alignB=BitMap alignment 
		end
		
		if demoMode == true then																-- demo mode ?
			value = sensor.testVal		
		else
				value = getTele(sensor.name)
--				print("read real value",sensor.name,value)
		end
		
		if value ~= false then
			valueStrg = string.format("%." .. sensor.dec .. "f",value)							-- format decimals
			frame.drawText(x+iconsize.width+xV_offset, y+2,  valueStrg, RIGHT ,  frameX)		-- print value
			
			local y_font = 5																	-- print Unit			
			tUnit = sensor.testUnit
			lcd.font(txtSize.Xsml)
			lcd.color(theme.c_textgrey1)
			frame.drawText(x+iconsize.width+xV_offset, y+2+y_font,  tUnit, LEFT ,  frameX)
		end
	end
	
end


-- *********************************************************
-- ****	shrink global sensor list to sensors requested	****
-- *********************************************************
local function getActiveSensors(pageLayout,display)
	local page
	local line
	local entry_a
	local entry_b

	local sensorsCat	= {}	
	
	local pathLookup ={
		"X20/",
		"X18/"
		}
		

	sensorsCat 	= defineSensors()				-- read complete sensor catalog
	
	local sensorsTmp	= {}
	for page = 1,#pageLayout do
		for line = 2,#pageLayout[page] do		-- offset 1 for header !
			if pageLayout[page][line][1] ~= nil then
				entry_a = pageLayout[page][line][1]		-- "left column" sensor 
			end
			if pageLayout[page][line][2] ~= nil then
				entry_b = pageLayout[page][line][2]		-- "right column" sensor 
			end
			
			--print("got entries",entry_a,entry_b)		
			sensorsTmp[entry_a] 	= sensorsCat[entry_a]		-- get 1st col sensor		
			sensorsTmp[entry_b] 	= sensorsCat[entry_b]		-- get 2nd col sensor
			--print("readA",sensorsTmp[entry_a].name)
			sensorsTmp[entry_a].bmp = lcd.loadBitmap(sensorsCat[entry_a].path .. pathLookup[display] .. sensorsCat[entry_a].icon)	
			--print("readB",sensorsTmp[entry_b].name)
			sensorsTmp[entry_b].bmp = lcd.loadBitmap(sensorsCat[entry_b].path .. pathLookup[display] .. sensorsCat[entry_b].icon)			
			
			if string.sub(entry_a,1,3) == "GPS" or string.sub(entry_a,1,3) == "GPS" then		-- exception GPS >> get sub entries too
				sensorsTmp["gpsLat"] = sensorsCat["gpsLat"]
				sensorsTmp["gpsLon"] = sensorsCat["gpsLon"]
				sensorsTmp["nSat"] 	 = sensorsCat["nSat"]				
				sensorsTmp["HDOP"]   = sensorsCat["HDOP"]								
			end
		end
	end
	
	
	-- ensure these sensors are loaded under all circumstances
	sensorsTmp["TimerFR"] 		= sensorsCat["TimerFR"]			
	sensorsTmp["TimerFR"].bmp 	= lcd.loadBitmap(sensorsCat["TimerFR"].path .. pathLookup[display] .. sensorsCat["TimerFR"].icon)	
	
	return sensorsTmp
end

-- **************************************************************************************************
-- *************************    called on very first run / "init"  app     **************************
-- **************************************************************************************************
function tele_frontendConfigure(widget,sensorSet)		
	
	
	loaded_chunk = assert(loadfile("/scripts/libUnow/widgets/telemetry/value_sets.lua"))				-- different sets/suites of telemetry values
	loaded_chunk()

	loaded_chunk = assert(loadfile("/scripts/libUnow/widgets/tele_global/sensorlist.lua"))			-- special widget layout parameters , x/display dependent
	loaded_chunk()

	loaded_chunk = assert(loadfile("/scripts/libUnow/widgets/telemetry/tele_layout.lua"))			-- special widget layout parameters , x/display dependent
	loaded_chunk()
	
	local pagelayout = {}
	pageLayout = getValueSet(sensorSet)																-- load specific value set
	
	local sensors = {}	
	loaded_chunk = assert(loadfile("/scripts/libUnow/lib_getTele.lua"))								-- get telemetry functions
	loaded_chunk()	

	--print("W tele 310 run frontend")
	sensors 	= getActiveSensors(pageLayout,widget.display)			-- extract only those sensors we need to reduce mem load (bitmaps!)

	collectgarbage("collect")							-- garbage collection

	return true,sensors,pageLayout
end



-- *****************************
-- ****	layout definition	****
-- *****************************
local function rowLayout(rows,dy,Yoffset)
	local Yline  = {}	
--	print("Y Layout:" ,rows)
	if rows == 4 then				-- 4 rows max:
		Yline = {																									-- "fine definition" of row placement, display dependend, 								
			{0+Yoffset,	dy+Yoffset,	2*dy+Yoffset,	3*dy+Yoffset,	4*dy+Yoffset},			-- type X20
			{2+Yoffset,	26+Yoffset,	50+Yoffset,		74+Yoffset,		72+Yoffset	},			-- type X18
			{0+Yoffset,	dy+Yoffset,	2*dy+Yoffset,	3*dy+Yoffset, 	4*dy+Yoffset},			-- type Horus									
			}		
	
	elseif rows == 5 then
		-- 5 rows max:
		Yline = {																																	
			{0+Yoffset,	dy+Yoffset,	2*dy+Yoffset,	3*dy+Yoffset,	4*dy+Yoffset},			-- type X20
			{2+Yoffset,	18+Yoffset,	36+Yoffset,		54+Yoffset,		72+Yoffset	},			-- type X18
			{0+Yoffset,	dy+Yoffset,	2*dy+Yoffset,	3*dy+Yoffset, 	4*dy+Yoffset},			-- type Horus									
			}
	end
	return Yline
end





-- **************************************************************************************
-- *************************      specific Tele draw functions **************************
-- **************************************************************************************


function main_telemetry(frameX,page,layout,theme,touch,evnt,subConf,appConfigured,txt,widget,com)
	--print("garbage mem count returns",collectgarbage("count"))
	local bmpDraw = true									-- for further use
	--[[	
	if widget.tele01upd == nil then
		widget.tele01upd = os.clock()
		bmpDraw = true
	end
	
	if os.clock() > widget.tele01upd +2 then				-- bmp paint refresh
		widget.tele01upd = os.clock()
		bmpDraw = true
	end
	--]]


	local number_cols = 2
	local demoMode 	= subConf[1]
	local sensorSet = subConf[2]
	
	local xx,yy
	local Yoffset = frameX.h * 0.04
	local bmpSize <const> = 12	

	local number_rows = {}					-- define number of rows per page
	local Yline = {}						-- 

--	conf_teleEl()							-- define config string


													-- one time config; cant be executed during create cause window size not availabe then
	if not(appConfigured) then	
		-- ***************************    "init"       *********************************************************
		--for i = 1,#subConf do			-- no subconf here
		--end
		dspType = evaluate_display()											-- kind of display
		appConfigured,sensors,pageLayout 		= tele_frontendConfigure(widget,sensorSet)			-- call one time function
		
		layout_T01 					= defineLayout(dspType)						-- app specific tabs etc...
	end	
	
		if page > #pageLayout then 
		page = 1
	end
	

		
	for i = 1,#pageLayout  do					-- loop pages
		number_rows[i] = #pageLayout[i]-1		-- determine num of rows in page
	end
	
	local dy = (100 / (number_rows[page] +3))				-- insert "+n" virtual lines to compress on Y axis
	Yline = rowLayout(pageLayout.rows,dy,Yoffset)			-- determine row alignment
	

	-- draw header 
	drawBackground(frameX,theme)
	drawHeader(pageLayout[page][1][1],frameX,theme)
	
	
	
	-- ****************************************************	
	-- *******         		draw items				*******
	-- ****************************************************

	-- define iconsize (display dependent)
	local iconsize = {width=bmpSize, height = bmpSize}

	
	for col = 0,number_cols-1 do	
		for row = 0,number_rows[page]-1 do
	--		local dx = 100 / number_cols
			local dx = 50
			--if dx == 50 then dx=55 end										-- layout corrective x axis
			
			if not(pageLayout[page][row+2][col+1] == nil) then					-- there is a telemetry value configured in layout
			
				local tmp = pageLayout[page][row+2][col+1]						-- get "internal" telemetry label
				local sensorTmp=sensors[tmp]									-- get sensor structure (label, bitmap etc..), defined by  defineSensors(widget) in sensorlist.lua

				displayTele(tmp,sensorTmp,dx*col, Yline[dspType][row+1], iconsize, frameX,theme, dy,layout,layout_T01,bmpDraw,demoMode)
			end
		end
	end

--	collectgarbage("collect")							-- garbage collection	
	return appConfigured, page 	
end

