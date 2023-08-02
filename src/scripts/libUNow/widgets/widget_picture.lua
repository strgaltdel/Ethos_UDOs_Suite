
--- The lua script "Picture1" is licensed under the 3-clause BSD license (aka "new BSD")
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


--  Picture1
--  suite edition
--  Rev 1.1


-- **************************************************************************************************
-- suite "event-handler range" Feb 2023
-- event handler needs. first handler-Ids for buttons (e.g. 501..503 in modelfind / 3 buttons)
--
-- app				start		end			prefix
--
-- modelfind		500			520			MFind
-- announce			520			540						??? under construction
-- teleEl												??? under construction
-- picture1				not used
-- setCurve				not used
-- **************************************************************************************************
local TMRidx <const> = 3		-- subconf index timer display enabled
local COLidx <const> = 4		-- subconf index timer color

local imagePath <const> = "/images/"

function pic1_frontendConfigure(subConf,widget)

	if subConf[1]~= nil and subConf[2]~= nil then
		widget.modelpic = {
			mdl 	= lcd.loadBitmap(imagePath .. "models/" 		.. subConf[1]..".png"),
			back 	= lcd.loadBitmap(imagePath .. "background/" 	.. subConf[2]..".png"),
			refresh = true
			}
	end

	return true
end


local function drawPic(modelpic,frameX)
	if modelpic~=nil then
		if modelpic.back ~= nil then
			frame.drawBitmap(0,0,modelpic.back,100,100,frameX)	
		end		
		if modelpic.mdl ~= nil then
			frame.drawBitmap(0,0,modelpic.mdl,100,100,frameX)
		end
	end
	return true
end


local function drawTmr(frameX,color,go1,go2)
	lcd.color(color)
	lcd.font(FONT_XL)	


	local t1 = model.getTimer(0):value()
	frame.drawText(95,	10,  timer2strg(t1),  RIGHT ,	frameX)
	
	local t2 = model.getTimer(1):value()
	frame.drawText(95,	78,  timer2strgM(t2),  RIGHT,	frameX)

	return true
end

-- **************************************************************************************
-- *************************      main function **************************
-- **************************************************************************************
--function main_Picture1(frameX,page,appConfigured,layout,theme,touch,evnt,subConf,widget)
function main_Picture(frameX,page,layout,theme,touch,evnt,subConf,appConfigured,appTxt,widget)

	-- ***************************    "init"       *********************************************************
	if not(appConfigured) then												-- one time config; cant be executed during create cause window size not availabe then
		appConfigured = pic1_frontendConfigure(subConf,widget)

	end	

	--  ***************     "paint"     **********************
	if widget.modelpic~=nil then
		widget.modelpic.refresh = drawPic(widget.modelpic,frameX)
	end
	
	if subConf[TMRidx] then
		local colTimer = subConf[COLidx]
		drawTmr(frameX,colTimer)
	end
	
	return(appConfigured)		
end

