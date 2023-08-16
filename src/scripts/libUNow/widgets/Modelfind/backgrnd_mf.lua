-- "background" tasks for modelfinder


-- *******************************************
-- *******************************************
-- *******************************************
function saveGPStoFile()
	print("------------   Save Coordinates   ------------")
	local FPATH_COORD <const> = ("/scripts/SRC_Gps_UN/data/")
	local data = {}

	data[1]=LastGps.lat
	data[2]=LastGps.lon

	local fName = model.name()	
	local fileOld02	= FPATH_COORD .. fName .. ".02.txt"
	local fileOld01 	= FPATH_COORD .. fName .. ".01.txt"
	local filename	= FPATH_COORD .. fName .. ".txt"
	
	os.remove(fileOld02)
	renFile(fileOld01,fileOld02)
	renFile(filename, fileOld01)
	
	writeFile(filename,data)
	LastGps.changed		= false
	LastGps.mustPaint = false
	LastGps.stored 		= true
end


function readGPSfromFile()
	local FPATH_COORD <const> = ("/scripts/SRC_Gps_UN/data/")
	
	local data = {}
	local fName = model.name()	
	filename = FPATH_COORD.. fName..".txt"
	print("GPS READ CALLED",FPATH_COORD.. fName..".txt")
	data = ReadFile(filename)			
	LastGps.lat = tonumber(data[1])
	LastGps.lon = tonumber(data[2])
	LastGps.OldLat = LastGps.lat
	LastGps.OldLon = LastGps.lon 
	LastGps.fileLat = LastGps.lat
	LastGps.fileLon = LastGps.lon
	LastGps.fileWasRead = true
	LastGps.fileTme = os.clock()+0.4					-- add some time to give pauint handler chance to update before calc starts
	LastGps.changed		= false
	LastGps.mustPaint = true
	LastGps.stored 		= true
	print("file read ",LastGps.lat,  LastGps.lon)
end

function bg_MFinder(com)
	local lat= system.getSource({name="GPS", options=OPTION_LATITUDE})
	local lon= system.getSource({name="GPS", options=OPTION_LONGITUDE})
	
	if LastGps.testmode or pcall(function() if lat:value() == nil then end end)then			-- wether testMode or detect sensor was "OK"

		LastGps.lock	= true
	
		if LastGps.lat == nil then													-- ensure numbers (sensor exists, but no lock)
			LastGps.lat = 0
			LastGps.lon = 0
			LastGps.lock			= false
		end
				
		LastGps.OldLat = LastGps.lat
		LastGps.OldLon = LastGps.lon 
		
		-- testmode start 
		if LastGps.testmode then 												
			LastGps.lat = LastGps.lat + 0.00004
			LastGps.lon = LastGps.lon + 0.00001
			
			if LastGps.lat > 50.501 then
					LastGps.lat = 50.50
					LastGps.lon = 9.950950
			end
			if LastGps.lat < 50.50 then
					LastGps.lat = 50.50
					LastGps.lon = 9.950950
			end
		else																	-- testmode end
			local tmpLat = lat:value()
			if tmpLat ~= nil and tmpLat ~= 0 then
				LastGps.lat = lat:value()
				LastGps.lon = lon:value()
			elseif LastGps.fileLat ~= nil and LastGps.fileLat ~= 0 then			-- no sensor but file coord
				LastGps.lat = LastGps.fileLat
				LastGps.lon = LastGps.fileLon
				LastGps.mustPaint 	= false
				LastGps.lock		= false					
			else																-- we have nothing !
				LastGps.lat = 0
				LastGps.lon = 0	
				LastGps.mustPaint 	= false
				LastGps.lock		= false				
			end
		end
		
		
		if LastGps.lat == LastGps.OldLat and LastGps.lon == LastGps.OldLon then		-- static
			LastGps.changed = false
		else
			LastGps.changed 		= true
			LastGps.stored 		= false
			LastGps.mustPaint 	= true

		end
	end
	
	if  com.status == 1 then													-- save coordinates request
		saveGPStoFile()
		com.status =0
	end	
	
	if  com.status == 2 then													-- read coordinates from file request
		readGPSfromFile()
		com.status =0
	end
	return com
end





-- *******************************************
