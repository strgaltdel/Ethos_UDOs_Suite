-- sensors file for telemetry widgets
-- udo nowakowski
-- 8.Feb.2023

-- sensorpool
-- you'll have to define a sensor here, in case you want to use it within the telemetry app:

function defineSensors(widget)
	local mini = -35
	local midi = -20
	
	local bmpPath = "/scripts/libUNow/bmp/"
	local frpPath = "/scripts/libUNow/freepic/"
	
	local sensors = {
  --  internal label	Ethos label/name  			icon filename				bitmap path,		Option Params,	  			Fieldlenght, decimals, alignV,  		alignB,	except.handle,	testvalue	
  --																																				icon vert		icon horiz.
		-- Tx
		["TxBt"] 	= 	{name = "TxBt", 			icon = ("Batt3.png"),		path=bmpPath,		options = nil,				f_lenght=5,	dec=1,	alignV=-20,		alignB=5,	xh=true,	testVal = 8.8 ,		testUnit = "V"},		
		
		-- Rx
		["rssi"] 	= 	{name = "RSSI", 			icon = ("rssi.png"),		path=bmpPath,		options =  nil,				f_lenght=5,	dec=0,	alignV= midi,	alignB=0,	xh=false,	testVal = 85,		testUnit = "" },
		["VFR"] 	= 	{name = "VFR", 				icon = ("VFR.png"),			path=frpPath,		options =  nil,				f_lenght=5,	dec=0,	alignV= midi,	alignB=0,	xh=false,	testVal = 93,		testUnit = "" },
		["SWR"] 	= 	{name = "SWR", 				icon = ("Ant_alarm.png"),	path=bmpPath,		options =  nil,				f_lenght=5,	dec=0,	alignV= midi,	alignB=0,	xh=false,	testVal = 98,		testUnit = "" },
		["RxBt"] 	= 	{name = "RxBatt", 			icon = ("Batt3.png"),		path=bmpPath,		options =  nil,				f_lenght=5,	dec=1,	alignV= midi,	alignB=0,	xh=false,	testVal = 5.05,		testUnit = "V" },		
		["RxNo"] 	= 	{name = "RX", 				icon = ("Ant_ok.png"),		path=bmpPath,		options =  nil,				f_lenght=5,	dec=1,	alignV= mini,	alignB=0,	xh=false,	testVal = 0,		testUnit = "" },	
		
		-- GPS
		["gpsLat"]	= 	{name = "GPS", 				icon = ("earth.png"),		path=frpPath,		options = OPTION_LATITUDE,	f_lenght=5,	dec=6,	alignV= 0,		alignB=0,	xh=false,	testVal = 50.430145,testUnit = "" },		-- placeholder single value
		["gpsLon"]	= 	{name = "GPS", 				icon = ("earth.png"),		path=frpPath,		options = OPTION_LONGITUDE,	f_lenght=5,	dec=6,	alignV= 0,		alignB=0,	xh=false,	testVal = 9.935628,	testUnit = "" },		-- placeholder single value
		["GPS"]		= 	{name = "GPS", 				icon = ("earth.png"),		path=frpPath,		options = OPTION_LATITUDE,	f_lenght=5,	dec=6,	alignV= 0,		alignB=0,	xh=true,	testVal = 50.430145,testUnit = "" },		-- placeholder standard GPS presentation
		["GPS+"]	= 	{name = "GPS", 				icon = ("earth.png"),		path=frpPath,		options = OPTION_LONGITUDE,	f_lenght=5,	dec=6,	alignV= 0,		alignB=0,	xh=true,	testVal = 9.935628,	testUnit = "" },		-- placeholder extended GPS presentation hdop/nsat
		["GAlt"]	= 	{name = "GPS Alt", 			icon = ("alti.png"),		path=bmpPath,		options =  nil,				f_lenght=5,	dec=0,	alignV= midi,	alignB=0,	xh=false,	testVal = 830,		testUnit = "m" },
		["GSpd"]	= 	{name = "GPS Speed",		icon = ("speedGPS.png"),	path=frpPath,		options =  nil,				f_lenght=5,	dec=1,	alignV= midi,	alignB=0,	xh=false,	testVal = 88.6,		testUnit = "km/h" },
		["Dist"]	= 	{name = "Distance", 		icon = ("dist.png"),		path=frpPath,		options =  nil,				f_lenght=5,	dec=0,	alignV= midi,	alignB=0,	xh=false,	testVal = 105,		testUnit = "m" },
		["Hdg"]		= 	{name = "GPS Course", 		icon = ("compass.png"),		path=frpPath,		options =  nil,				f_lenght=5,	dec=0,	alignV= midi,	alignB=0,	xh=false,	testVal = 242,		testUnit = "deg" },
		["nSat"]	= 	{name = "GPS nSat", 		icon = ("sat1_80.png"),		path=frpPath,		options =  nil,				f_lenght=5,	dec=0,	alignV= midi,	alignB=0,	xh=false,	testVal = 112,		testUnit = "" },
		["HDOP"]	= 	{name = "GPS hdop", 		icon = ("hdop.png"),		path=frpPath,		options =  nil,				f_lenght=5,	dec=0,	alignV= midi,	alignB=0,	xh=false,	testVal = 212,		testUnit = "" },

		-- ESC
			-- Neuron autodetect
		["SBecA"]	= 	{name = "SBEC A", 			icon = ("BatBecI.png"),		path=frpPath,		options =  nil,				f_lenght=5,	dec=1,	alignV=-10,		alignB=5,	xh=false,	testVal = 0.45,		testUnit = "mA" },
		["SBecV"]	= 	{name = "SBEC V", 			icon = ("BatBecV.png"),		path=frpPath,		options =  nil,				f_lenght=5,	dec=1,	alignV=-10,		alignB=5,	xh=false,	testVal = 5.67,		testUnit = "V" },
		["EscA"]	= 	{name = "ESC Current",		icon = ("currB1.png"),		path=bmpPath,		options =  nil,				f_lenght=5,	dec=1,	alignV=0,		alignB=0,	xh=false,	testVal = 40.3,		testUnit = "A" },
		["EscV"]	= 	{name = "ESC Voltage",	 	icon = ("LipoU.png"),		path=frpPath,		options =  nil,				f_lenght=5,	dec=1,	alignV=-4,		alignB=0,	xh=false,	testVal = 16.1,		testUnit = "V" },
		["EscT"]	= 	{name = "ESC Temp", 		icon = ("thermo3.png"),		path=frpPath,		options =  nil,				f_lenght=5,	dec=0,	alignV=-17,		alignB=0,	xh=false,	testVal = 50.3,		testUnit = "Cel" },
		["Erpm"]	= 	{name = "ESC RPM", 			icon = ("Prop.png"),		path=frpPath,		options =  nil,				f_lenght=5,	dec=0,	alignV=1,		alignB=0,	xh=false,	testVal = 4280,		testUnit = "" },
		["ECon"]	= 	{name = "ESC Consumption", 	icon = ("Batt3.png"),		path=bmpPath,		options =  nil,				f_lenght=5,	dec=0,	alignV=1,		alignB=0,	xh=false,	testVal = 1850,		testUnit = "mA" },		
		["CConN"]	= 	{name = "Consumption",		icon = ("Cap1.png"),		path=frpPath,		options =  nil,				f_lenght=5,	dec=0,	alignV=1,		alignB=0,	xh=false,	testVal = 1850,		testUnit = "mA" },
		["LiPo"]	= 	{name = "LiPo",	 			icon = ("LipoU.png"),		path=frpPath,		options =  nil,				f_lenght=5,	dec=1,	alignV= midi,	alignB=0,	xh=false,	testVal = 16.1,		testUnit = "V" },
			-- YGE autodetect
		["VFAS"]	= 	{name = "VFAS", 			icon = ("LipoU.png"),		path=frpPath,		options =  nil,				f_lenght=5,	dec=1,	alignV=-4,		alignB=0,	xh=false,	testVal = 16.1,		testUnit = "V" },
		["Current"]	= 	{name = "Current", 			icon = ("currB1.png"),		path=bmpPath,		options =  nil,				f_lenght=5,	dec=1,	alignV=0,		alignB=0,	xh=false,	testVal = 40.3,		testUnit = "A" },
		["BecA"]	= 	{name = "BecA", 			icon = ("BatBecI.png"),		path=frpPath,		options =  nil,				f_lenght=5,	dec=1,	alignV=-10,		alignB=5,	xh=false,	testVal = 0.45,		testUnit = "mA" },
		["BecV"]	= 	{name = "VBEC", 			icon = ("BatBecV.png"),		path=frpPath,		options =  nil,				f_lenght=5,	dec=1,	alignV=-10,		alignB=5,	xh=false,	testVal = 5.67,		testUnit = "V" },
		["EscTmp"]	= 	{name = "GASS Temp1", 		icon = ("thermo2.png"),		path=frpPath,		options =  nil,				f_lenght=5,	dec=0,	alignV=-17,		alignB=0,	xh=false,	testVal = 50.3,		testUnit = "Cel" },
		["CconY"]	= 	{name = "Ccon", 			icon = ("BatBecV.png"),		path=frpPath,		options =  nil,				f_lenght=5,	dec=0,	alignV=1,		alignB=0,	xh=false,	testVal = 1850,		testUnit = "mA" },
		["RPM"]		= 	{name = "RPM", 				icon = ("Prop.png"),		path=frpPath,		options =  nil,				f_lenght=5,	dec=0,	alignV=1,		alignB=0,	xh=false,	testVal = 4280,		testUnit = "" },
		["Temp1"]	= 	{name = "Temp1",			icon = ("thermo3.png"),		path=frpPath,		options =  nil,				f_lenght=5,	dec=0,	alignV=-17,		alignB=0,	xh=false,	testVal = 50.3,		testUnit = "Cel" },
		["Curr"]	= 	{name = "Curr", 			icon = ("currB1.png"),		path=bmpPath,		options =  nil,				f_lenght=5,	dec=1,	alignV=0,		alignB=0,	xh=false,	testVal = 40.3,		testUnit = "A" },
		
		-- Gyro	
		["Rotation"]= 	{name = "R.Angle", 			icon = ("Batt3.png"),		path=bmpPath,		options =  nil,				f_lenght=5,	dec=0,	alignV=1,		alignB=0,	xh=false,	testVal = 8.6,		testUnit = "deg" },
		["Pitch"]	= 	{name = "P.Angle", 			icon = ("Batt3.png"),		path=bmpPath,		options =  nil,				f_lenght=5,	dec=0,	alignV=1,		alignB=0,	xh=false,	testVal = 10.2,		testUnit = "deg" },
		["AccX"]	= 	{name = "AccX", 			icon = ("Batt3.png"),		path=bmpPath,		options =  nil,				f_lenght=5,	dec=0,	alignV=1,		alignB=0,	xh=false,	testVal = 1.0,		testUnit = "g" },
		["AccY"]	= 	{name = "AccY", 			icon = ("Batt3.png"),		path=bmpPath,		options =  nil,				f_lenght=5,	dec=0,	alignV=1,		alignB=0,	xh=false,	testVal = 1.0,		testUnit = "g" },		
		["AccZ"]	= 	{name = "AccZ", 			icon = ("Batt3.png"),		path=bmpPath,		options =  nil,				f_lenght=5,	dec=0,	alignV=1,		alignB=0,	xh=false,	testVal = 1.0,		testUnit = "g" },
		
		-- Vario / oXs
		["alt"] 	= 	{name = "Altitude",			icon = ("alti.png"),		path=bmpPath, 		options =  nil,				f_lenght=5,	dec=0,	alignV= midi,	alignB=0,	xh=false,	testVal = 72.82,	testUnit = "m" },
		["VSpeed"] 	= 	{name = "VSpeed",			icon = ("alti.png"),		path=bmpPath, 		options =  nil,				f_lenght=5,	dec=0,	alignV= midi,	alignB=0,	xh=false,	testVal = 72.82,	testUnit = "m/s" },
		["ASpd"]	= 	{name = "Air Speed",		icon = ("speedIAS.png"),	path=frpPath,		options =  nil,				f_lenght=5,	dec=1,	alignV=  0,		alignB=0,	xh=false,	testVal = 92.3,		testUnit = "km/h"  },
		
		-- oTx "labels"
		["alti"] 	= 	{name = "ALT",				icon = ("alti.png"),		path=bmpPath, 		options =  nil,				f_lenght=5,	dec=0,	alignV= midi,	alignB=0,	xh=false,	testVal = 72.82,	testUnit = "m" },
		["A_Spd"]	= 	{name = "ASpd", 			icon = ("speedIAS.png"),	path=frpPath,		options =  nil,				f_lenght=5,	dec=1,	alignV=0,		alignB=0,	xh=false,	testVal = 92.3,		testUnit = "km/h"  },
		
		
		-- "specials", no real telemetry
		["Timer1"]	= 	{name = "timer1", 			icon = ("timerF.png"),		path=frpPath,		options =  nil,				f_lenght=8,	dec=1,	alignV=22,	alignB=0,	xh=true,	testVal = "00:02:34" },
		["Timer2"]	= 	{name = "timer2", 			icon = ("timerS.png"),		path=frpPath,		options =  nil,				f_lenght=8,	dec=1,	alignV=22,	alignB=0,	xh=true,	testVal = "00:02:34" },
		["Timer3"]	= 	{name = "timer3", 			icon = ("timer3.png"),		path=frpPath,		options =  nil,				f_lenght=5,	dec=1,	alignV=0,	alignB=10,	xh=true,	testVal = "00:02:34" },
		["TimerFR"]	= 	{name = "timer1", 			icon = ("timerF.png"),		path=frpPath,		options =  nil,				f_lenght=8,	dec=1,	alignV=5,	alignB=-15,	xh=true,	testVal = "00:02:34" },	
		["TimerSR"]	= 	{name = "timer2", 			icon = ("timerS.png"),		path=frpPath,		options =  nil,				f_lenght=8,	dec=1,	alignV=5,	alignB=-15,	xh=true,	testVal = "00:02:34" },			
		["TimerX12"]= 	{name = "timer1", 			icon = ("timerS.png"),		path=frpPath,		options =  nil,				f_lenght=8,	dec=1,	alignV=2,	alignB=12,	xh=true,	testVal = "25:34" },			
	}
	
	
	--[[ 
	
	
	
	
	
	internal label:			internal use, this label/identifier is used withion this "suite" lua code
	Ethos label:			"official" Ethos telemetry label, used by "system.getSource" method as name
	bitmap path				bitmap file (including path) used form presentation of the telemetry value
	Option Params			some sensors (like GPS) transmit structures, so you need some more option parameters to extract a value, see lua manual
	Fieldlenght				"width" of the field in chars, in which value is displayed
	decimals				how much decimals should be displayed
	align V					Value alignment (horizontal)
	align B					Bitmap alignment (horizontal)
	exception handle		used to call a "special function / routine" (exeption handler) to procure display of the data, like GPS which displays several sensor values; can be true or false // boolean
	testmode				by running in testmode this data is presented; used for development in sim
	
	
	
	
	example how to procure:
	
	local tmp = "alt"
	sensors.tmp = sensors[tmp]
	print("SENSOR:  ",sensors.tmp.name)
	]]

		
print("return sensorlist")
	return sensors
	
end