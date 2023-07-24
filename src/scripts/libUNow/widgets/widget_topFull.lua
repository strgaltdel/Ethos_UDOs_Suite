-- **************************************************************************************
-- *************************          top bar menue            **************************
-- **************************************************************************************
local LSW1 <const> 			= "ls10"
local LSW1name <const> 		= "Flaperon"
local LSW1txt <const> 		= "Flperon"
--local LSW1 <const> 			= nil
--local LSW1name <const> 		= nil





local LSW2 <const> 			= "ls11"
local LSW2name <const> 		= "Flaperon"
local LSW2txt <const>		= "snapflp"
--local LSW2 <const> 			= nil
--local LSW2name <const> 		= nil

local LSW_MotWarn <const> 	= "Mot Thr Warning"
local LSW_MotOn <const> 	= "Motor running"


-- *************************         load libs                 ***********************
--		loaded_chunk = assert(loadfile("/scripts/libUnow/lib_Topwidget_full.lua"))
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

function topfull(frameX,page,dummy,theme,touch,evnt,appConfigured,appTxt,widget,sensors,param)			--  page for future implementations

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


	



	-- switch stati
	--print("TopLayout: ",widget.layout.width01)
	top_status(widget.layout.topX1,Y1,Y2,Yoffset, frameX, theme, widget.layout,	LSW1name,LSW2name, 	LSW1txt,LSW2txt, 	LSW1,LSW2)
	
	-- safety switch Status	
	-- param=top_safety(widget.layout.topX2,Y1,Yoffset, frameX, theme,  widget.layout,appTxt ,"Engine_Safe","Engine_ON",param)
	param=top_safety(widget.layout.topX2,Y1,Yoffset, frameX, theme,  widget.layout,appTxt ,LSW_MotWarn,LSW_MotOn,param)
	-- model name	
	top_text(widget.layout.topX4,Y1+5,Yoffset, frameX, theme,  widget.layout,model.name(),theme.c_textGreen)	

	-- Bat Tx/Rx
	top_BatV2(widget.layout.topX5,Y1,Y2,Yoffset, frameX, theme, txMin, txMax, txVal, rxMin, rxMax, rxVal  )
	
	
	--  VFR & RSSI
	top_RecStrenght2(widget.layout.topX6,Y1,Y2,Yoffset, frameX, theme, iconsize,sensors)
	


	

	return(param)

--	return
	
end
