-- language file for fullscreen "universal" widget
-- udo nowakowski
-- 8.august.2022


function initLang()
	local text_ = {}
	txt_ = {}

	text_.en = {

		["motorArmed"]	=	"Armed",			 		-- status armed
		["motorOn"]		=	"Motor\n  ON",				-- status motor running
		["motorSafe"]	=	"Safe",			 		-- status motor running
		["flaperon"]	=	"flaperon",			 		-- label flaperon
		["snapflap"]	=	"snapflap",			 		-- label snapflap
		["Rx"]			=	" Rx",			 		 	-- label Rx
		["Tx"]			=	"Tx",			 		 	-- label Tx
	
		["annHeader"]	=	"Announcements",		 	-- header widget "cyclic announcements"
	
		["telePg1"]		=	"Telemetry 1/3",			-- widget telemetry: page1 header
		["telePg2"]		=	"Telemetry 2/3",			-- widget telemetry: page2 header
		["telePg3"]		=	"Telemetry 3/3",			-- widget telemetry: page3 header
	
		["end"]			=	"end"			 		 	-- label end
	}


--[[
local optionLan = {
{{{"Aus", 0}, {"freie Zuordnung", 1}},			{{"Off", 0}, {"free Choice", 1}}			},	-- map on PWM
{{{"Standard", 0}, {"nicht invertiert", 1}},	{{"standard", 0}, {"non inverted", 1}}		}	-- Sbus inverted
}

	local headers = {

		{"Parameter 1"	,			"Parameter 1"		},
		{"Parameter 2"	,			"Parameter 2"		},
		{"Kanalzuordnung 1"	,		"Channel mapping 1"	},
		{"Kanalzuordnung 2"	,		"Channel mapping 2"	},
		{"Kanalzuordnung 3"	,		"Channel mapping 3"	},
		{"Kanalzuordnung 4"	,		"Channel mapping 4"	},
		{"dedizierte Servo 18ms",	"dedicated 18ms"	}
	}
]]
		txt_= text_.en				-- assign language block

end