--- The lua library "lib_standards.lua" is licensed under the 3-clause BSD license (aka "new BSD")
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




-- ************************************************************************************************************************
-- *******                          some unspecific widget functions                                      *****************
-- *******    introduce an "abstaction" layer to let the main script more independent from underlying LUA *****************
-- ************************************************************************************************************************

function round(value)
	value = math.floor(value+0.5)
	return value
end


function getValue(object)													-- get simple (telemetry) value
	local src  = system.getSource(object)
	local value = src:value()
	return(value)
end

function getAnalog(object)													-- get value from analog Input
	--print("get analog",name)
	local src  = system.getSource({category=CATEGORY_ANALOG, name=object})
	local value = src:value()
	return(value)
end

function getSwitch(object)													-- get value from switch
	local src  = system.getSource({category=CATEGORY_SWITCH, name=object})
	local value = src:value()
	return(value)
end

function getLSwitch(object)													-- get value from switch
	local src  = system.getSource({category=CATEGORY_LOGIC_SWITCH, name=object})
	local value = src:value()
	return(value)
end

function getchannel(object)
	local inputSrc =  system.getSource({category=CATEGORY_CHANNEL, name=object})	-- get channel value
	return (value)
end


function getchannelPerc(object)
	local inputSrc =  system.getSource({category=CATEGORY_CHANNEL, name=object})	-- get channel value in percent (base1024)
	local value = inputSrc:value()/10.24
	return (value)
end 

function getSource(object)
	local value =  object:value()	-- get channel value
	return (value)
end


function playSignal(freq,duration,option)									-- play tone
	system.playTone(freq,duration,18)
end


function playWav(file)														-- play twav file
	--print("TONE / Pieps",freq,duration)
	system.playFile(file)
end


function playNumber(number,decs,units)								-- play tone
	system.playFile(playNumber(number,units,decs))
end

function drawHeader(textline,frameX,theme)									-- draw "page" header
	lcd.color(theme.c_textHeader)
--	lcd.font(txtSize.big+FONT_BOLD)
	lcd.font(txtSize.sml)
	frame.drawText(50,  1,  textline,  CENTERED,  frameX)
end


function drawBackground(frameX,theme)										-- widget background frame
	lcd.color(theme.c_backgrWid)
	frame.drawFilledRectangleRnd(0,0,100,100, frameX,2)
end


function soundGeneral()														-- return array with general wav files
	local pathGen = "/scripts/libUnow/sounds"
	local soundfileGen = {}
	
	soundfileGen["on"] 		=  pathGen .. "ein.wav"
	soundfileGen["off"] 	=  pathGen .. "aus.wav"
	soundfileGen["reset"] 	=  pathGen .. "snafu.wav"
	soundfileGen["usrErr"] 	=  pathGen .. "usrerr.wav"
	
	return(soundfileGen)
end


function getWidgetPath()													-- return widget path
	return("/scripts/libUnow/widgets/widget_")
end

																			-- ************************************************
																			-- ***		     getime workaround           *** 
																			-- ************************************************
function getTime()
  return os.clock()		 
end


function timer2strg(val)
	local hour 		= math.floor(val/3600)
	local minute 	= math.floor((val -hour*3600)/60)
	local second	= val-hour*3600-minute*60
	local timerStrg  = string.format("%02d:%02d:%02d",hour,minute,second)				-- format decimals
	return timerStrg
end


																			-- ************************************************
																			-- ***    converts timer val into string        *** 
																			-- ************************************************

function timer2strgM(val)

	local pre =""
	local negative = false

	if val < 0 then
		negative = true
		val = -1*val
		pre = "-"
	end
	
	local hour = math.floor(val/3600)	
	local minute 	= math.floor((val -hour*3600)/60)
	local second	= val-hour*3600-minute*60

	local timerStrg  = string.format("  "..pre.." %02d:%02d",minute,second)				-- format decimals
	return timerStrg
end
																			-- ************************************************
																			-- ***		     round value                 	*** 
																			-- ************************************************		
function round(val,dec)			
  local mult = 10^(dec or 0)
  return math.floor(val * mult + 0.5) / mult
end


																			-- ************************************************
																			-- ***		     integer value                 	*** 
																			-- ************************************************		
function int(val)			
  return math.floor(val)
end

																			-- ************************************************
																			-- ***		     mem consumption                *** 
																			-- ************************************************	
function showmem()
	local mem = {}
	mem = system.getMemoryUsage()
	print("Main Stack: "..mem["mainStackAvailable"])
	print("RAM Avail: "..mem["ramAvailable"])
	print("LUA RAM Avail: "..mem["luaRamAvailable"])
	print("LUA BMP Avail: "..mem["luaBitmapsRamAvailable"])
end

