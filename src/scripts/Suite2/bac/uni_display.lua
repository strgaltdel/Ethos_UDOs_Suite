
function defineLayout(display)


	local layoutSettings = {}
	
	layoutSettings [1]= {
																			-- X20
		["type"] 		=	"X20",															
	--sizings
		["width01"] 		=	11,				-- topbar rectangles 1 (status snapflap ...)
		["width02"] 		=	10,					-- topbar rectangles 1 (safety)	
		["topIconW"]	= 	10,					-- scaling imgages in TopBar (percent of screen)
		["topIconH"]	= 	95,
	-- offsets
		["offTele1"]	= 	26,					-- offset icons <-> telemetry values
	-- placements
		["topX1"] 		= 	01,					-- x-coordinates for TopBar sub-widgets (percent of displ width)
		["topX2"] 		= 	16,
		["topX3"] 		= 	28,
		["topX4"] 		= 	43,
		["topX5"] 		= 	64,
		["topX6"]		= 	85
	}
	
	layoutSettings [2]= {													-- X18
		["type"] 		=	"X18",	
	--sizings
		["width01"] 		=	11.8,					-- topbar rectangles 1 (status snapflap ...)
		["width02"] 		=	10,					-- topbar rectangles 1 (safety)
		["topIconW"]	= 	10,					-- scaling imgages in TopBar (percent of screen)
		["topIconH"]	= 	95,
	-- offsets
		["offTele1"] 	= 	30,					-- offset icons <-> telemetry values
	-- placements
		["topX1"] 		= 	01,					-- x-coordinates for TopBar sub-widgets (percent of displ width)
		["topX2"] 		= 	16.3,
		["topX3"] 		= 	29,
		["topX4"] 		= 	44,
		["topX5"]		= 	62,
		["topX6"]		= 	85
	}
	
	layoutSettings [3]= {														-- Horus	
		["type"] 		=	"HORUS",	
	--sizings
		["width01"] 		=	11,					-- topbar rectangles 1 (status snapflap ...)
		["width02"] 		=	11,					-- topbar rectangles 1 (safety)		
		["topIconW"]	= 	10,					-- scaling imgages in TopBar (percent of screen)
		["topIconH"]	= 	115,
	-- offsets
		["offTele1"]	 = 	30,					-- offset icons <-> telemetry values
	-- placements
		["topX1"] 		= 	01,					-- x-coordinates for TopBar sub-widgets (percent of displ width)
		["topX2"] 		= 	18,
		["topX3"] 		= 	32,
		["topX4"] 		= 	54,
		["topX5"]		= 	84,
		["topX6"]		= 	85
	}	
	--	print("LAYOUT:",display)
	return(layoutSettings [display])

end
