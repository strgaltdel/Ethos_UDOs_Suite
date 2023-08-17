--- The lua library "lib_getTele.lua" is licensed under the 3-clause BSD license (aka "new BSD")
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


-- Rev 0.3, Feb 2023

function defineSensorLine(sensorX)
			local tele={}
			local bmpTmp 
			
			if not(sensorX.bmppath == nil) then 
				bmpTmp = lcd.loadBitmap(sensorX.bmppath) 
			else 
				bmpTmp =nil 
			end
		
			tele = {name = sensorX.name, 	bmp = bmpTmp,	val=sensorX.testVal , options = sensorX.options	}			
			return(tele)
end




function getTeleValues()
	local TeleValues ={
	}
	


end

function getTele(TeleSensor,option)
	local sensor
	if TeleSensor == "TxBt" then				-- tx voltage is other category !
		sensor = system.getSource({category=CATEGORY_SYSTEM, member=MAIN_VOLTAGE})
	else
		sensor = system.getSource({category=CATEGORY_TELEMETRY, name=TeleSensor, options=option} )
	end
	
	if sensor ~= nil then
		val = sensor:value()
		return val
	else
		return false
	end

end
