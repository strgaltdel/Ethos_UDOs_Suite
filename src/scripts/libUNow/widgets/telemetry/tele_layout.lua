
	
function defineLayout(display)


	local layoutSettings = {}
	
	layoutSettings [1]= {
																			-- X20
		["type"] 		=	"X20",															
	-- offsets
		["offTele1"]	= 	26,					-- offset telemetry values (right alignment)
		["TabL1"] 		= 	0,					-- tabulator left value column (%)
		["TabR1"] 		= 	1,					-- tabulator left value column (%)
	}
	
	layoutSettings [2]= {													-- X18
		["type"] 		=	"X18",	
	-- offsets
		["offTele1"] 	= 	27,					-- offset telemetry values (right alignment)
		["TabL1"] 		= 	1,					-- tabulator offset left value column (%)
		["TabR1"] 		= 	4,					-- tabulator offset right value column (%)
	}
	
	

	print("LAYOUT:",display)
	return(layoutSettings [display])

end
