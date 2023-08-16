-- **************************************************************************************
-- *************************          top bar menue            **************************
-- **************************************************************************************



--local LSW_MotWarn <const> 	= "Mot Thr Warning"
--local LSW_MotOn <const> 	= "Motor running"


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

function topfull(frameX,page,dummy,theme,touch,evnt,subConf,appConfigured,appTxt,widget,sensors,param)			--  page for future implementations

	local lsTop 			= subConf[1]		-- src LSW
	local lsTopLabel 		= subConf[2]

	local lsBot 			= subConf[3]		-- src LSW
	local lsBotLabel		= subConf[4]

	local isVFR				= subConf[5]		-- bool VFR to be displayed
	
	local lsMotSafe			= subConf[6]		-- src LSW: "kill switch" / disarm Motor
	local lsMotPreArmed		= subConf[7]		-- src LSW: motor input active 
	local lsMotRunning		= subConf[8]		-- src LSW:	motor IS running !

	
	
	local Y1 = 5																		-- define line 1 and line2 Y-Position (%)
	local Y2 = 50

	local iconsize = {width=widget.layout.topIconW, height = widget.layout.topIconH}	-- define iconsize (in % of frame height, display dependent)	
	local Yoffset = 2																	-- Y Offset (%)
	
	
	local xx,yy	
	local televal

	txVal = getTele(sensors["TxBt"].name)						-- get tx voltage
	rxVal = getTele(sensors["RxBt"].name)						-- get rx voltage
	if rxVal == nil or rxVal == false then rxVal = 0 end		-- plausibility

																-- ************   draw background  ***************
	lcd.color(theme.c_backgrTop)
	
	paintTopBG(frameX,theme)
	
	--[[
	-- load background pattern
	if topBackground == nil then
		topBackground = lcd.loadBitmap("/scripts/libUnow/bmp/topback1.png") 
	end

	-- draw 
	local scale = 1.3
	local loops = 12
	local step = 100/(loops+1)
	for i=0,loops do
		frame.drawBitmap(i*step,  0,  topBackground,  step*scale,  100*scale,  frameX)
	end
	]]
																-- ************   call "subwidgets"  ***************

	-- some switch/LSW stati
	top_status(widget.layout.topX1,Y1,Y2,Yoffset+10, frameX, theme, widget.layout, 	 lsTop, lsBot, lsTopLabel, lsBotLabel)
	
	-- safety switch Status	
	param=top_safety(widget.layout.topX2,Y1,Yoffset+10, frameX, theme,  widget.layout,appTxt ,lsMotSafe,lsMotPreArmed,lsMotRunning,param)
	
	-- model name
	local colTxt = theme.c_textgrey2
	--local colTxt = theme.c_textGreen
	top_text(widget.layout.topX4,Y1+10,Yoffset, frameX, theme,  widget.layout,model.name(),colTxt)	

	-- Bat Tx/Rx
	top_BatV2(widget.layout.topX5,Y1,Y2,Yoffset, frameX, theme, txVal, rxVal  )
	
	
	--  VFR & RSSI
	top_RecStrenght2(widget.layout.topX6,Y1,Y2,Yoffset, frameX, theme, iconsize,sensors,isVFR)
		

	return(param)
	
end
