-- **************************************************************************************
-- *************************          top bar menue            **************************
-- **************************************************************************************
--local TMR1txt <const> = "Flgt:"
--local TMR2txt <const> = "Mot:"

print("*******  LOAD LUA: TOPBAR STD")

-- *************************         load libs                 ***********************
		loaded_chunk = assert(loadfile("/scripts/libUnow/lib_Topwidget.lua"))
		loaded_chunk()
sensors = defineSensors(widget)
---------------
-- Define config string
---------------
function conf_topa()
	widgetconfLine["topa"]	=	"!topa,void"		-- no special configuration
end


-- **************************************************************************************
-- *************************         draw TopLine                 ***********************
-- **************************************************************************************

function topstd(frameX,page,dummy,theme,touch,evnt,subConf,appConfigured,appTxt,widget,sensors,param)			--  page for future implementations

	local timerA 	= subConf[1]
	local timerAtxt	= subConf[2]..":"
	local timerB 	= subConf[3]
	local timerBtxt	= subConf[4]..":"

	local Y1 = 5								-- define line 1 and line2 Y-Position (%)
	local Y2 = 50

	local iconsize = {width=widget.layout.topIconW, height = widget.layout.topIconH}	-- define iconsize (in % of frame height, display dependent)	
	local Yoffset = 2							-- Y Offset (%)
	
	
	local xx,yy	
	local televal
	
	local txMin = 9
	local txMax = 10.4
	local txVal = 10.10
	local rxMin = 4.9
	local rxMax = 5.5
	local rxVal = 5.0	

--	if pcall(sensors["VFR"].name) then
--	else
--		sensors["VFR"].bmp = lcd.loadBitmap(sensors["VFR"].path .. "X20/" .. sensors["VFR"].icon)			
--	end

	-- ************   draw background  ***************
	lcd.color(theme.c_backgrTop)

	if topBackground == nil then
		--print("**************load bitmap")
		topBackground = lcd.loadBitmap("/scripts/libUnow/bmp/topback1.png") 
	end

	local scale = 1.3
	local loops = 12
	local step = 100/(loops+1)
	for i=0,loops do
		--print("draw topBack",i*step)
		frame.drawBitmap(i*step,  0,  topBackground,  step*scale,  100*scale,  frameX)
	end
	-- background = nil
	--frame.drawFilledRectangle(0,0,100,100,frameTop)	
	
	if pcall(function() if sensors["rssi"].name == "rssi" then end end) then			-- rssi sensor definition ?
		if sensors["rssi"].bmp== nil then												-- if yes, does bmp exist ?

			print("77 Topsensor: no rssi bmp")
			sensors["rssi"].bmp = lcd.loadBitmap(sensors["rssi"].path .. "X20/" .. sensors["rssi"].icon)			
		end	
	else
		sensors["rssi"].bmp = lcd.loadBitmap(sensors["rssi"].path .. "X20/" .. sensors["rssi"].icon)			-- if nothing, get bitmap
	end


	


	-- timer flight & Motor
	--			layout				y1,y2,offset,	frame,theme,tmr#1,txt,tmr#2,txt
	top_timer(widget.layout.topX1+2,Y1,Y2,Yoffset, frameX, 	theme, timerA, 	timerAtxt,	timerB,	timerBtxt)

	-- switch stati
	--print("TopLayout: ",widget.layout.width01)
	--top_status(widget.layout.topX1,Y1,Y2,Yoffset, frameX, theme, widget.layout, "ls10","ls11", "Flaperon","snapflap")
	
	-- safety switch Status	
	--param=top_safety(widget.layout.topX2,Y1,Yoffset, frameX, theme,  widget.layout,appTxt ,"Engine_Safe","Engine_ON",param)
	
	-- model name	
	top_text(widget.layout.topX4-5,Y1+5,Yoffset, frameX, theme,  widget.layout,model.name(),theme.c_textGreen)	

	-- Bat Tx/Rx
	top_BatV2(widget.layout.topX5,Y1,Y2,Yoffset, frameX, theme, txMin, txMax, txVal, rxMin, rxMax, rxVal  )
	
	
	--  VFR & RSSI
	top_RecStrenght2(widget.layout.topX6,Y1,Y2,Yoffset, frameX, theme, iconsize,sensors)
	


	

	return(param)

--	return
	
end