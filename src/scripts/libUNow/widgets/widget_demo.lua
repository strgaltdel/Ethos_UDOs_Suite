--- The lua script "modelFinder" is licensed under the 3-clause BSD license (aka "new BSD")
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

--  null
--  suite edition
--  Rev 1.2



-- **************************************************************************************************
-- suite "event-handler range" Feb 2023
-- event handler needs. first handler-Ids for buttons (e.g. 501..503 in modelfind / 3 buttons)
--
-- app				start		end			prefix
--
-- modelfind		500			520			MFind
-- announce			520			540						??? under construction
-- demo				550
-- teleEl												??? under construction
-- picture				not used
-- setCurve				not used
-- **************************************************************************************************

local HANDLER_OFFSET <const>			= 550
local Null_handlerAction1 <const>		= HANDLER_OFFSET +1				-- action handler Button #1
local Null_handlerAction2 <const>		= HANDLER_OFFSET +2
local Null_handlerAction3 <const>		= HANDLER_OFFSET +3

local libPath <const>  			= "/scripts/libUNow/"
local widgetPath <const>  		= "/scripts/libUNow/widgets/"
local localPath <const>  		= "/scripts/libUNow/widgets/null"




-- ***************************************************************************************************************************
-- **********************************************        Here we start         ***********************************************
-- **********************************************     with the widget part      ***********************************************
-- **********************************************      (Udo Nowakowski)        ***********************************************
-- ***************************************************************************************************************************

---------------
-- Define config string
---------------

function conf_modelfind()
	widgetconfLine["null"]="!curv1,void"		-- no special configuration file
end



																			-- ************************************************
																			-- ***	     Config after widget call			  *** 
																			-- ************************************************
																	
function Demo_frontendConfigure(widget,appTxt)

	widget.modelfind = {}
	widget.modelfind.txt = appTxt

	createQR(widget)
	widget.modelfind.com = {status=0}
	

	-- **********************************************  				  load basics   			 ******************************
	

	widget.layout	= defineLayout(widget.display)		
	

	
	-- ******************     This is the definition of our buttons used in the widget:      ********************************************
	-- ******************   Definition is used in event handler to determine user actions    ********************************************
	-- ******************    for position & sizing you'll have to look into layout file      ********************************************
	
	local ButY =widget.layout.butLine1				-- yPos of buttons
	local ButH =widget.layout.butHeight				-- button height
	
	widget.Demo.button = {
	--		xRel (xPos),				yRel (yPos),	widthRel,	heightRel, 	"real"color, theme colorname std mode	complementary color		text,			txtAlternate			textCol
		{	xRel=widget.layout.tab0,	yRel=ButY,		wRel=30,	hRel=ButH, 	color=nil,	colorname="c_ButGrey",	color2="c_ButGreen",	txt="But1",		txtAlt="  Stop",	txtCol=widget.theme.c_textInvert},
		{	xRel=widget.layout.tab2,	yRel=ButY,		wRel=22,	hRel=ButH, 	color=nil,	colorname="c_ButRed",	color2="c_ButBluestd",	txt="But2",		txtAlt=nil,			txtCol=widget.theme.c_textInvert},
		{	xRel=widget.layout.tab3,	yRel=ButY,		wRel=22,	hRel=ButH, 	color=nil,	colorname="c_ButGrey",	color2="c_ButGreen",	txt="But3",		txtAlt=nil,			txtCol=widget.theme.c_textInvert}
	}
	

	-- **********************************************  				load theme as configured   			 ******************************

	for i=1,#widget.Demo.button do														-- refresh button colors
			widget.Demo.button[i].color	= widget.theme[widget.Demo.button[i].colorname]
			widget.Demo.button[i].txtCol	= widget.theme.c_textInvert
	end

		
	if widget.w > 0 then			-- eval succesfull ?

		return(true)
	else
		--print("Demo frontend NOT *******successful",widget.w)
		return(false)	
	end

end			


																			-- ************************************************
																			-- ***	     draw buttons from array Info		*** 
																			-- ************************************************
local function drawButton(but,frm,Xcolor,buttontext)							-- draw button
	local bText = but.txt
	local bCol = but.color

	if Xcolor ~=  nil then														-- handle nil parameter
		bCol = Xcolor
	end	
	if buttontext ~= nil then
		bText = buttontext
	end
	
	lcd.color(bCol)
	frame.drawFilledRectangleRnd(but.xRel,but.yRel,but.wRel,but.hRel, frm, 0.8)
	lcd.color(but.txtCol)
	frame.drawText(but.xRel+2,but.yRel+3,bText,LEFT, frm)
end	



local function patternLoad()
	--		widget.demo.mode1,		widget.demo.mode1,		widget.demo.mode1 
	return	true,					false,					false
end



																			-- ************************************************
																			-- ***		     draw demo HeaderInfos			*** 
																			-- ************************************************																		
local function drawButtons(widget,frm)
	
		lcd.color(widget.theme.c_backgrWid)
		drawBackground(frm,theme)

		
		lcd.color(widget.theme.c_textStd)
		lcd.font(txtSize.sml)										
		for i = 1, #widget.Demo.button do														-- ******  draw buttons  *******
			local color2 = widget.theme[widget.Demo.button[i].color2]
			if i== 1 then																		-- button 1														
					drawButton(widget.Demo.button[i],frm)
			elseif i == 2 then																	-- button 2
					drawButton(widget.Demo.button[i],frm)
			else																				-- button 3
					drawButton(widget.Demo.button[i],frm,color2)
			end
		end
		

end


																			-- ************************************************
																			-- ***		     "display handler"		*** 
																			-- ************************************************
local function paintDemo(widget,frm)
	--lcd.invalidate(0,0,310,100)
	local localID = system.getLocale()																-- refresh language in case changed during runtime
	if localID =="de" then
		lan = 1
	else
		lan = 2 																					-- not supported language, so has to be "en" 
	end


	
	

	drawButtons(widget,frm)																-- draw standard area (infos & buttons)

		

end




																			-- **************************************************** 
																			-- *** after evaluating event, values must be reset *** 																			
																			-- ****************************************************
local function resetWidHandler(widget)
	widget.evnt = { category = 0, value = 0,	x = nil,	y=nil	}  		-- reset
end

																			-- ************************************************
																			-- ***     substitude for main event handler    *** 
																			-- ***     evaluates from main passed events    *** 																			
																			-- ************************************************
																			
																			
																			
 local function eventDemo(category, value, x, y, frameW, frameH, xOffs, yOffs, button)
	local handler

	local MFindHandleroffset = HANDLER_OFFSET				-- only touch is relevant in this app, demo=hdl 550:
    if category == EVT_TOUCH then


        if debug3 then 
			if 		value == KEY_ENTER_LONG then  print("    value key_long:",  value, x, y) 
			elseif	value == KEY_ENTER_SHORT then  print("    value key_short:",  value, x, y)
			elseif	value == TOUCH_END then  print("    value touch_end:",  value, x, y)
			elseif	value == TOUCH_START then  print("    value touch_start:",  value, x, y)
			else	print("    vTOUCH value:",  value, x, y)
			end
		end	
	
		if value == TOUCH_END then												-- evaluate menu handler		

			for i = 1 ,#button do										-- button handler/ button touched ?
				--local button = button[i]


				local bXstart 		=  button[i].xRel/100*frameW 					+ xOffs
				local bXend 		=  (button[i].xRel+button[i].wRel)/100*frameW 	+ xOffs
				local bYstart 		=  button[i].yRel/100*frameH					+ yOffs
				local bYend 		=  (button[i].yRel+button[i].hRel)/100*frameH	+ yOffs
				
				print("check save idx,  x,y,  :",i," : ",	x,y,bXstart,bXend,bYstart,bYend)		
				if i== 2 then
						
					--	print("   butt  X..Y   :",bXstart,bXend,bYstart,bYend)
				end

				if  x >  bXstart  and x< bXend and y>bYstart and y<bYend then
					if debug3 then  print("Button pressed",i) end
					handler = MFindHandleroffset + i
					if debug4 then print("handler",handler,i) end
					if debug3 then print("handler",handler,i) end

				end
			end
		end
        return handler
		
    else
        return 0
    end
end




																						-- ****************************************************
																						-- ***		     "background" loop					*** 
																						-- ****************************************************

function main_demo(frameX,page,layout,theme,touch,evnt,subConf,appConfigured,appTxt,widget)
		print("demo was called")
		if not(appConfigured) then												-- o
			appConfigured = MF_frontendConfigure(widget,appTxt)
			for i = 1,#subConf do
				print("////// demo  conf passed:",i,subConf[i])
			end
			
		end	



		
																							-- ---------------------------------------------------
																							-- ***		  	handler mgmt 				***
																							-- ---------------------------------------------------
																							-- qr calc&refresh only in case user started cyclic calc manually 
																							-- he should stop qr refresh in case not needed anymore to avoid cpu load !!!!!!
																							-- maybe we can eval if widget is in "foreground" to prevent cpu load in case it's running in a not active page !!!!	
																							-- by now widget.gps.foreground flags auto calc (cyclic)
																							
																							
		if widget.Demo.handler == Null_handlerAction1 then												-- **********************    toggle manually start/stop   ****************************
			print(" Demo detected Button 1")
			widget.gps.handler = HANDLER_OFFSET															-- reset handler
		end	
		

		if widget.Demo.handler ==  Null_handlerAction2 then												-- **********************    toggle manually start/stop   ****************************
			print(" Demo detected Button 2")
			widget.gps.handler = HANDLER_OFFSET	
		end
		
		if widget.Demo.handler ==  Null_handlerAction2 then
			print(" Demo detected Button 2")
			widget.gps.handler = HANDLER_OFFSET	
		end
		


																-- enforce screen refresh / paint(widget)
		paintDemo(widget,frameX)
		return(appConfigured)
end




-- ***********************************************************************************************************************
-- ***********************************************************************************************************************
-- ***********************************************************************************************************************
-- ***********************************************************************************************************************



-- 										"background" tasks for modelfinder




local FPATH_COORD <const> = ("/scripts/libUNow/gpsData/")

-- *******************************************
-- *******************************************
-- *******************************************
function demo_bg1()


end


function demo_bg2()


end

function demo_bg3(widget)

	return true
end





-- *******************************************
