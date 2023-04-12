-- **************************************************************************************
-- *************************          top bar menue            **************************
-- **************************************************************************************


-- *************************         load libs                 ***********************
		loaded_chunk = assert(loadfile("/scripts/libUnow/lib_Topwidget.lua"))
		loaded_chunk()

---------------
-- Define config string
---------------
function conf_topa()
	widgetconfLine["topa"]	=	"!topa,void"		-- no special configuration
end


-- **************************************************************************************
-- *************************         draw TopLine                 ***********************
-- **************************************************************************************

function top1(frameX,page,layout,theme,touch,param)			--  page for future implementations
--print("hello top1")
-- some constants for layout purpose
	local Y1 = 5								-- define line 1 and line2 Y-Position (%)
	local Y2 = 50
	local iconsize = {width=layout.topIconW, height = layout.topIconH}	-- define iconsize (in % of frame height, display dependent)	
	local Yoffset = 2							-- Y Offset (%)
	
	
	local xx,yy	
	local televal
	
	local txMin = 9
	local txMax = 10.4
	local txVal = 10.10
	local rxMin = 4.9
	local rxMax = 5.5
	local rxVal = 5.0	
	
	


	-- ************   draw background  ***************
	lcd.color(theme.c_backgrTop)

	if topBackground == nil then
		--print("**************load bitmap")
		topBackground = lcd.loadBitmap("/scripts/libUnow/bmp/topback1.png") 
	end
	
	frame.drawBitmap(0,  0,  topBackground,  100,  100,  frameX)
	-- background = nil
	--frame.drawFilledRectangle(0,0,100,100,frameTop)	
	
	
	

	


	-- timer flight & Motor
	top_timer(layout.topX1,Y1,Y2,Yoffset, frameX, theme, 1, "Flgt:",2,"Mot:")

	-- switch stati
	top_status(layout.topX2,Y1,Y2,Yoffset, frameX, theme, layout, "ls10","ls11", "Flaperon","snapflap")
	
	-- safety switch Status	
	top_safety(layout.topX3,Y1,Yoffset, frameX, theme,  layout,"Engine_Safe","Engine_ON",param)
	
	-- model name	
	top_text(layout.topX4,Y1+5,Yoffset, frameX, theme,  layout,model.name(),theme.c_textGreen)	

	-- Bat Tx/Rx
	xx= x4
	top_BatV(layout.topX5,Y1,Y2,Yoffset, frameX, theme, txMin, txMax, txVal, rxMin, rxMax, rxVal  )
	
	
	--  VFR & RSSI
	xx = x5		-- x Position
	top_RecStrenght(layout.topX6,Y1,Y2,Yoffset, frameX, theme, iconsize)
	
	-- paint model image (centered)
	--local widTmp,HeiTmp = lcd.getWindowSize()
	--frame.drawImage(40, 50,  theme.Image,widTmp/5, HeiTmp/6,  frameX)

	

	return(param)
	
	
end
