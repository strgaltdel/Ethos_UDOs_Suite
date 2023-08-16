initTelevoice = false



---------------
-- Define modelspecific standard environment
---------------
--local function modelAnn()
function conf_ann()
--  choose model specific standard announcement
	local Announcement_standard   = {}
	local Announcement_alternate = {}
	local Announcement = {}
	local plane = {}
								-- get actual model
	plane.name = model.name()

	if plane.name == "Comet K" then
		Announcement["std"]  = {
			-- sensor, status, cycTime, offset, next ann time
			{"Alt","on",45,10,0,false},
			{"RSSI","on",20,1,0,true},
			{"Dist","off",20,0,0,true},
			{"Ccon","off",210,2,0,true},
			{"RxBt","off",30,4,0,false}}
	elseif plane.name == "Discus Top" then
		Announcement["std"] = {
			{"Alt","on",45,10,0,false},
			{"RSSI","on",33,1,0,true},
			{"Dist","on",65,0,0,true},
			{"Ccon","off",210,2,0,false},
			{"RxBt","off",30,4,0,true}}
	else

		Announcement["std"] = {
			--[[
			{"Alt","on",45,0,0},
			{"RSSI","off",15,1,0},
			{"Ccon","on",222,3,0},
			{"Dist","off",180,2,0},
			{"VFAS","on",306,4,0}}
	--]]
			{"Alt","on",15,0,0,false},
			{"RSSI","off",15,1,0,true},
			{"Ccon","on",4,3,0,true},
			{"Dist","off",180,2,0,true},
			{"VFAS","on",7,4,0,false}}
	
	end
	Announcement["alt"] = {
			{"Alt","on",5,0,0,false},
			{"RSSI","on",2,1,0,true}
	}

		widgetconfLine["ann"]="!anno,Alt,on,45,RSSI,off,15,Ccon,on,222,Dist,off,180,VFAS,on,306"
	
	
	local pathGen = "/scripts/libUnow/sounds"
	
	-- cycTime = sysTime in seconds, beginning at 00:00 today
	local cycTime = sysTime
	--print("Time:",cycTime)
	soundFile = {}
	soundFile["Alt"] = 	{pathGen .. "0140.wav" ,"  ",cycTime,1}
	soundFile["Dist"] = 	{pathGen .. "0146.wav" ,"/SOUNDS/de/System/meter0.wav",cycTime,0}
	soundFile["Ccon"] = 	{pathGen .. "0152.wav" ," ",cycTime,0}
	soundFile["VFAS"] = 	{pathGen .. "0150.wav" ," ",cycTime,1}
	soundFile["Tmp1"] = 	{pathGen .. "0143.wav" ," ",cycTime,0, "/SOUNDS/de/System/0001.wav"}
	soundFile["Tmp2"] = 	{pathGen .. "0143.wav" ," ",cycTime,0, "/SOUNDS/de/System/0002.wav"}
	soundFile["ASpd"] = 	{pathGen .. "0145.wav" ," ",cycTime,0}
	soundFile["Curr"] = 	{pathGen .. "0151.wav" ," ",cycTime,0}
	soundFile["RxBt"] = 	{pathGen .. "0150.wav" ," ",cycTime,1, "/SOUNDS/de/System/0137.wav"}
	soundFile["RSSI"] = 	{pathGen .. "0137.wav" ," ",cycTime,0}
	soundFile["RPM"] = 	{pathGen .. "0141.wav" ," ",cycTime,0}
	
	

	
	
	return((Announcement) )
end


---------------
-- Define modelspecific runtime environment at start
---------------
local function copyAnnouncement(Announcement_standard)

	Announcement_active = {}
	local l,m
	local actTime = getTime()
	for m=1,5,1 do
		Announcement_active[m] = {}
		Announcement_tmp[m] = {}
		for l=1,4,1 do
			Announcement_active[m][l] = Announcement_standard[m][l]
			Announcement_tmp[m][l] = Announcement_standard[m][l]
		end
		Announcement_active[m][5] = getTime()+  Announcement_standard[m][3]+  Announcement_standard[m][4]
	end
	return(Announcement_active)
 end

 
 ---------------
-- toggle cyclic announcement status
---------------

local function changestatus(Announcement_active,num)
	--print("change status",num)
	if Announcement_active[num][2] == "on" then
		Announcement_active[num][2] = "off"
		--system.playFile(sound_off)
	else
		Announcement_active[num][2] = "on"
		--system.playFile(sound_on)
	end
	--print("finished",Announcement_active[num][1],Announcement_active[num][2],Announcement_active[num][3]   )
end


---------------
-- switch to announcement "zero"
---------------
local function copyAnnouncement_zero()
  local l,m
  for m=1,5,1 do
	for l=1,4,1 do
	 -- copy actual setting to _tmp
	 Announcement_tmp[m][l] = Announcement_active[m][l]
--	 	 Announcement_tmp = Announcement_active
	 -- activate "zero" setting
	 Announcement_active[m][l] = silence[m][l]
--	 Announcement_active = Announcement_zero
	end
  end
  
 end
 
---------------
-- switch back to last announcement settings
---------------
local function copyAnnouncement_tmp(Announcement_active)
  local l,m
  for m=1,5,1 do
	for l=1,4,1 do
	 -- activate last known settings
	 Announcement_active[m][l] = Announcement_tmp[m][l]
	end
  end
  
 end
 
 
---------------
-- play sensor name
---------------
local function play_sensor_name(num)

		-- play sensor name
		system.playFile(soundFile[Announcement_active[num][1]][1])
	
		-- check if a second file has to be played for sensor announcement
		if  Announcement_active[num][1] == "RxBt" or Announcement_active[num][1] == "Tmp1" or Announcement_active[num][1] == "Tmp2" then
			system.playFile(soundFile[Announcement_active[num][1]][5])
		end
		
end
 
 
---------------
-- play sensor value
---------------
local function play_sensor_val(num,t_stamp)

	local val


		
		-- get sensor value :
		--val = getValue(Announcement_active[num][1])
		
		-- check if dec. places should be played
		if soundFile[Announcement_active[num][1]][4] == 1 then
			system.playNumber((10*val),0,PREC1)
			
		else
			system.playNumber(val,0)
		end
		
		-- play unit:
		playFile(soundFile[Announcement_active[num][1]][2])
		-- write timestamp:
		soundFile[Announcement_active[num][1]][3] = t_stamp

end


---------------
-- check for cyclic announcements
---------------
local function check_play_cyclic(Announcement_active,actTime)

	local k
	
	for k=1,#Announcement_active  do			--loop number of ann items
		--print("ann" ,actTime,Announcement_active[k][2], Announcement_active[k][5] )
		if 	Announcement_active[k][2] == "on" then
			local nextAnn = Announcement_active[k][5]
			if  actTime >= nextAnn then
				--print("***************    ann  -----",Announcement_active[k][1],Announcement_active[k][5])
				Announcement_active[k][5] = actTime + Announcement_active[k][3]

			end
		end
	end

end


function backgroundX(myZone)

local tmp
-- mainrun only if no error in init()

	mute_ann = (getValue(mute))

--  if err_Anndef == 0 then 
  
	--get systime and convert into seconds
	sysTime = getTime()
	cycTime = sysTime
	
	copyAnnouncement_tmp()





	-------------------------------------
	-----   change cycle time  -------------
	-------------------------------------	
	
	-- sw-Request pushed >> toggle status of cyclic ann.  (sw-Request: -1000)
	if getValue(val_off) < 0 and toggleOff_last ~= getValue(val_off) and pos > 0 then
		changestatus(pos)
	end
	
	
	-- sw-Request pulled >> announce value "on request" (sw-Request: +1000)
--	if pos > 0 then
		if getValue(val_req) > 0 and toggleReq_last ~= getValue(val_req) and cycTime ~= soundFile[Announcement_active[pos][1]][3] then
			play_sensor_name(pos)
			play_sensor_val(pos,cyctime)
		end
--	end

--[[	
	-- sw-vario pulled >> announce altitude "on request" (sw-vario: +1000)

	if getValue(sw_Vario) > 0 and last_variopos ~= getValue(sw_Vario) then
		playFile(soundFile["Alt"][1])
		playNumber(getValue("Alt"),0)
	end
]]	
	
	-- calc seconds since last position change
--	PosChange_lasttime = cycTime - PosChange_time
		
		
	-- evaluate for cyclic announcement if mute = off
	if mute_ann < 0 then
		check_play_cyclic(cycTime)
	end
	
	
	-- remember last switch positions
	toggleOff_last = getValue(val_off)
	toggleReq_last = getValue(val_req)
	last_pos = pos
	last_variopos = getValue(sw_Vario)
	
 --end
end

local function initTeleWidget()
	local Announcement_active={}
	Announcement_active = conf_ann()								-- define model dependent anns into "standard" array
	--copyAnnouncement(Announcement_standard)							-- fill _tmp & _actual anns
	return(Announcement_active)
end


local function checkToggle(x2,y1,y_delta,Announcement_active,frameX,widgetTouch)

	x1 = x2-10		-- width of touch area
	
	xT_relative = 100*(widgetTouch.X-frameX.x)/frameX.w		-- convert absolute touch coordinates into widget relatives
	yT_relative = 100*(widgetTouch.Y-frameX.y)/frameX.h
	--print("rel",xT_relative,yT_relative,x1,x2,y1)
	

	
	local j
	local notfound = true

	if xT_relative >x1 and xT_relative  < x2 and yT_relative> y1 then			-- toggle announcement
		for j=#Announcement_active,1,-1 do
			if notfound and yT_relative > y1+(j-1)*y_delta then
				changestatus(Announcement_active,j)
				notfound = false								-- ann was found
				widgetTouch.X=nil									-- clear touch cache
				widgetTouch.Y=nil	
				--print("switched",j,"to",Announcement_active[j][2])				
			end
		end
		return(true)
	end
	return(false)
end

-- **************************************************   drawtext

local function checkEdit(x2,y1,y_delta,Announcement_active,frameX,widgetTouch,widgetEvent,theme)

	x1 = x2-17		-- width of touch area
	
	xT_relative = 100*(widgetTouch.X-frameX.x)/frameX.w		-- convert absolute touch coordinates into widget relatives
	yT_relative = 100*(widgetTouch.Y-frameX.y)/frameX.h

	


	local j
	local notfound = true
	if xT_relative >x1 and xT_relative  < x2 and yT_relative> y1 then												-- edit Field ?
		for j=#Announcement_active,1,-1 do
			if notfound and yT_relative > y1+(j-1)*y_delta then													-- edit field detected, so:
				lcd.color(theme.c_backgrEDT	)																	-- "mark" field
				frame.drawFilledRectangleRnd(x1-1,y1+(j-1)*y_delta-3,x2-x1+2,y_delta, frameX,1)
				if widgetEvent.wheelup == true then															-- if rotary right >> count ++
					Announcement_active[j][3]=Announcement_active[j][3]+1
					widgetEvent.wheelup = false										-- requested action finished
				elseif  widgetEvent.wheeldwn == true then															-- if rotary left >> count --
					print("wheeldwn detected)")
					Announcement_active[j][3]=Announcement_active[j][3]-1
					widgetEvent.wheeldwn = false										-- requested action finished
				end
				lcd.color(theme.c_textRed)
				frame.drawText(x2, y1+(j-1)*y_delta,Announcement_active[j][3], 		RIGHT ,	frameX)				-- cycle time
				notfound = false								-- ann was found
			end
		end
		return(true)
	end
	return(false)
end


--****************************************************************************************
--                              main loop
--****************************************************************************************

function announce(frameX,page,widgetLayout,theme,widgetTouch,widgetEvent,widget)
	--lcd.font(txtSize.big)
	lcd.font(txtSize.sml)
	local k,dummy1,dummy2
	local numAnnouncemts = 5
	
	--local xOffset = 1
	--local Yoffset = 2
	local Yoffset = frameX.h * 0.04
	local y_delta = 14								-- SIZE OF TOUCH AREA
	local y_Data = 20
	
	--local x_cycleTime = 38
	--local x_status = 75
	
	if not (initTelevoice) then  			-- only on first run
		widget["announcement"] = {}
		widget["announcementAlt"] = {}
		widget["announcement"]=initTeleWidget() 
		initTelevoice = true
		print("VOICEINIT")
		
	end
	
	drawBackground(frameX,theme)
	drawHeader(txt_.annHeader,frameX,theme)
	--backgroundX()
	
	
	local dy = y_delta		
	-- display specific splacement:
	local Yline = {		
			{Yoffset,	dy+Yoffset,	2*dy+Yoffset,	3*dy+Yoffset,	4*dy+Yoffset},			-- type X20
			{Yoffset,	18+Yoffset,	36+Yoffset,		54+Yoffset,		72+Yoffset},			-- type X18
			{Yoffset,	dy+Yoffset,	2*dy+Yoffset,	3*dy+Yoffset,	4*dy+Yoffset},			-- type Horus											-- type X18
			}
	local Xtab = {
			{1,		38,	75},			-- type X20
			{1,		70,	95},			-- type X18											-- type X18
			{1,		38,	75}				-- type Horus
			}

	
	
	local dspType = evaluate_display()


	--frame.drawText(xOffset +5, 	Yoffset ,txt_.annHeader, 	LEFT, 	frameX)

	local Announcement_active  = {}
	Announcement_active =  widget.announcement.std
	
	for k=1,#Announcement_active  do																				-- loop announcements
		local colTmp
		-- some formatting
		if Announcement_active[k][1]== "Alt" then dummy1 = "    " end
		if Announcement_active[k][1]== "Dist" then dummy1 = "  " end
		if Announcement_active[k][1]== "RSSI" or Announcement_active[k][1]== "RxBt" then dummy1= " " end
		
		if k == pos then
			lcd.setColor(theme.c_textRed )
			frame.drawFilledRectangle(x_offset + 10, Yoffset  + (k-1)*y_delta, 10, 5, frameX)
		end	
		
		
		if Announcement_active[k][2] == "on" then 
			dummy2 = " " 
			colTmp=theme.c_textStd	
			--print("deci",Announcement_active[k][2],colTmp)
		else
			colTmp=theme.c_textdark

		end	
						--print("deci",Announcement_active[k][2],colTmp)		
		lcd.color(colTmp)
--		lcd.font(txtSize.std)
		lcd.font(txtSize.big)
		-- Tele Sensor & repetition
		--[[
		frame.drawText(xOffset , 				Yoffset   + y_Data + (k-1)*y_delta,Announcement_active[k][1]..dummy1, 		LEFT, 	frameX)			-- sensor
		frame.drawText(xOffset +x_cycleTime, 	Yoffset + y_Data + (k-1)*y_delta,Announcement_active[k][3], 				RIGHT ,	frameX)				-- cycle time
		frame.drawText(xOffset +x_status, 		Yoffset   + y_Data + (k-1)*y_delta,Announcement_active[k][2],			RIGHT ,	frameX)			-- announcement on/off
]]
		--print("Y:",Yline[dspType][k])
		frame.drawText(Xtab[dspType][1] , 	Yline[dspType][k],	Announcement_active[k][1]..dummy1,  	LEFT, 	frameX)			-- sensor
		frame.drawText(Xtab[dspType][2], 	Yline[dspType][k],	Announcement_active[k][3],  	RIGHT ,	frameX)			-- cycle time
		frame.drawText(Xtab[dspType][3], 	Yline[dspType][k],	Announcement_active[k][2],	RIGHT ,	frameX)			-- announcement on/off
		
		--print("TTOUCH",touch.x)
		if widgetTouch.X ~= nil then
--			if checkToggle(Xtab[dspType][3],Yoffset   + y_Data,y_delta,Announcement_active,frameX,widgetTouch)	~= true then						-- toggle status ?
--				checkEdit(Xtab[dspType][2],Yoffset   + y_Data,y_delta,Announcement_active,frameX,widgetTouch,widgetEvent,theme)						-- if not check value edit
--			end
			if checkToggle(Xtab[dspType][3],	Yline[dspType][k],	y_delta,Announcement_active,frameX,widgetTouch)	~= true then						-- toggle status ?
				checkEdit(Xtab[dspType][2],		Yline[dspType][k],	y_delta,Announcement_active,frameX,widgetTouch,widgetEvent,theme)						-- if not check value edit
			end
		end

		check_play_cyclic(Announcement_active,getTime())


	end	
	

			return(widget)
	
	
end