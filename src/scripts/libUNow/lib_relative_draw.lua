-- ***************************************************************************************************
-- *******************          draw relative to widget sizing              **************************
-- ****************************************************************************************************

--- The lua library "lib_relative_draw.lua" is licensed under the 3-clause BSD license (aka "new BSD")
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

-- Feb 2023
-- Rev 1.1





																			-- ************************************************
																			-- ***		      lcd equivalents  			*** 
																			-- ***         for rel. addressed drawings		***
																			-- ***				within a frame/widget		***
																			-- ***  frme.x	> x Position of frame  		***
																			-- ***  frme.y  > y position of frame			***
																			-- ***  frme.w  > frame widht  					***
																			-- ***  frme.h	> frame height  				***																	
																			-- ************************************************
frame = {} 






															
function frame.drawFilledRectangle(xRel,yRel,wRel,hRel, frme)
	local xx   = round(xRel/100*frme.w + frme.x)
	local yy   = round(yRel/100*frme.h + frme.y)
	local wid  = round(wRel/100*frme.w)
	local heig = round(hRel/100*frme.h )
	lcd.drawFilledRectangle(xx, yy, wid, heig)	
end


function frame.drawFilledCircle(xRel,yRel,radiusRel,frme)
	local xx   		= round(xRel/100*frme.w + frme.x)
	local yy   		= round(yRel/100*frme.h + frme.y)
	local radius  	= round(radiusRel/100*frme.w)

	lcd.drawFilledCircle(xx, yy, radius)	
end



function frame.drawFilledRectangleRnd(xRel,yRel,wRel,hRel, frme, rnd)
	
	local radius = round(rnd/100*frme.h)			-- radius dep. from frame height
	local xx   	= round(xRel/100*frme.w + frme.x)
	local x1   	= round(xx+radius)
	local yy   	= round(yRel/100*frme.h + frme.y)
	
	local wid  = round(wRel/100*frme.w)
	local heig = round(hRel/100*frme.h )

	lcd.drawFilledCircle((xx+radius),		(yy+radius),		radius)			-- upper left
	lcd.drawFilledCircle((xx+radius),		(yy+heig-radius),	radius)
	lcd.drawFilledCircle((xx+wid-radius),	(yy+radius),		radius)			-- upper right
	lcd.drawFilledCircle((xx+wid-radius),	(yy+heig-radius),	radius)	
	
	lcd.drawFilledRectangle(xx, 		yy+radius,			wid, 			heig-2*radius)	
	lcd.drawFilledRectangle(xx+radius,	yy, 				wid-2*radius, 	2*radius)
	lcd.drawFilledRectangle(xx+radius,	yy+heig-2*radius+1, wid-2*radius, 	2*radius)		
	
end



function frame.drawRectangle(xRel,yRel,wRel,hRel, frme)
	local xx   = round(xRel/100*frme.w + frme.x)
	local yy   = round(yRel/100*frme.h + frme.y)
	local wid  = round(wRel/100*frme.w)
	local heig = round(hRel/100*frme.h )
	lcd.drawRectangle(xx, yy, wid, heig)	
end

function frame.drawRectangle2(xRel,yRel,wRel,hRel, frme, thick)
	local xx   = round(xRel/100*frme.w + frme.x)
	local yy   = round(yRel/100*frme.h + frme.y)
	local wid  = round(wRel/100*frme.w)
	local heig = round(hRel/100*frme.h )
	
	for i=0,thick-1 do
		lcd.drawRectangle(xx+i, yy+i, wid-2*i, heig-2*i)
	end
end

function frame.drawLine(xRel,yRel,x2Rel,y2Rel, frme,thick)
	local xx   = xRel/100*frme.w + frme.x
	local yy   = yRel/100*frme.h + frme.y
	local x2   = x2Rel/100*frme.w + frme.x
	local y2   = y2Rel/100*frme.h + frme.y
	if thick == nil then thick = 0 end
	lcd.drawLine(xx, yy, x2, y2)
	for i= 0,thick-1 do
		local tmp =1
		if i/2 == math.floor(i/2) then tmp = -1 end
		local x1 =tmp*math.floor(i/2+0.5)
		lcd.drawLine(xx+x1, yy, x2+x1, y2)
		
	end
end



function frame.drawText(xRel,yRel,text,flags, frme)
	if flags == nil then
		flags = LEFT
	end
	
	if frme.w ~= nil then							-- supress "jump start" before widgetinit finished
		local xx   = xRel/100*frme.w + frme.x
		local yy   = yRel/100*frme.h + frme.y
		lcd.drawText(xx,yy,text,flags)	
	end
	

end



function frame.drawNumber(xRel,yRel,value,unit,decimals, flags, frme)
	if unit==nil then
		unit=0
	end
	if decimals == nil then
		decimals = nil
	end
	
	if flags == nil then
		flags = RIGHT
	end
	if frme.w ~= nil then	
		local xx   = xRel/100*frme.w + frme.x
		local yy   = yRel/100*frme.h + frme.y
		lcd.drawNumber(xx,yy,value,unit,decimals, flags)
	end
end



function frame.drawBitmap(xRel,yRel,bitmap,wRel,hRel, frme)
--print(frme.x,frme.y,frme.w,frme.h,wrel,hrel)
	local xx   = math.floor(xRel/100*frme.w + frme.x)
	local yy   = math.floor(yRel/100*frme.h + frme.y)
--	local wid  = math.floor(wRel/100*frme.w)
	local wid  = math.floor(wRel/100*frme.w)			-- prevent calc failure in ethos
	local heig = math.floor(hRel/100*frme.h)
	lcd.drawBitmap(xx, yy, bitmap, wid, heig)
--	print("DRAW REL BMP ",xx,yy,wid,heig)
--	print("DRAW REL BMP ",wid,heig)
end

function frame.drawImage(xRel,yRel,bitmap,wid,hei, frme)
--print(frme.x,frme.y,frme.w,frme.h,wrel,hrel)
	local xx   = math.floor(xRel/100*frme.w + frme.x)
	local yy   = math.floor(yRel/100*frme.h + frme.y)
--	local wid  = math.floor(wRel/100*frme.w)
	--local wid  = math.floor(wRel/100*frme.w)			-- prevent calc failure in ethos
	--local heig = math.floor(hRel/100*frme.h)
	lcd.drawBitmap(xx, yy, bitmap, wid, hei)
	--lcd.drawBitmap(xx, yy, bitmap, wid, heig)
	--print("DRAW REL BMP ",xx,yy,wid,heig)

end

function frame.drawBitmapNative(xRel,yRel,bitmap, frme)
	local xx   = math.floor(xRel/100*frme.w + frme.x)
	local yy   = math.floor(yRel/100*frme.h + frme.y)
	lcd.drawBitmap(xx, yy, bitmap)
end

function frame.drawMask(xRel,yRel,mask, frme)
	local xx   = xRel/100*frme.w + frme.x
	local yy   = hRel/100*frme.h + frme.y
	lcd.drawMask(xx, yy, mask)
end



