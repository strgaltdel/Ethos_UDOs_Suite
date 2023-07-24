	-- ********************************************************************
	-- *******              		Widget layout					*******
	-- ********************************************************************
	
	
	-- define layout number_cols x number_rows per page
	-- 3 pages
	-- use sensor labels !

function getValueSet(index)
	local electro1 	= 1
	local el_yge 	= 2
	local glider 	= 3

	local ValueSets = {}

	ValueSets[electro1] = {	
		rows=5,												-- overall layout; max number of rows
		{					
			{"General 1/3"},								-- page 1
			{"TxBt","alt"},
			{"VFR","rssi"},				
			{"EscV","CConN"},
--			{"Timer1","Ccon"},
			{"GPS+"}
		},		
						
		{	{"Sustainer 2/3"},								-- page 2
			{"VFR","rssi"},
			{"CConN","EscV"},
			{"VFAS","EscT"},	
			{"SBecV","SBecA"},
			{"Erpm","RxBt"}
		},	
		
		{	{"GPS 3/3"},								-- page 3
			{"Dist","GSpd"},
			{"GAlt","Hdg"},
			{"nSat","HDOP"},
			{"GPS"}
		}	
	}


	ValueSets[el_yge] = {	
		rows=5,												-- overall layout; max number of rows
		{
			{"General 1/3"},								-- page 1
			{"TxBt","alt"},
			{"VFR","rssi"},
			{"VFAS","CConN"},			
			{"GPS+"}
		},		
		
		{	{"Sustainer 2/3"},							-- page 2
			{"VFR","rssi"},
			{"CConN","VFAS"},
			{"EscA","Temp1"},	
			{"RPM","RxBt"}
		},	

		{	{"GPS 3/3"},								-- page 3
			{"Dist","GSpd"},
			{"GAlt","Hdg"},
			{"nSat","HDOP"},
			{"GPS"}
		}		
	}


		
	ValueSets[glider] = {	
		rows=5,												-- overall layout; max number of rows
		{	{"Page1"},								-- page 1 header
			{"RxBt","TxBt"},		
			{"VFR","rssi"},	
			{"EscV","CConN"},			
--			{"alt","Dist"},
			{nil,"TimerX12"}
		},		
		
		{	{"Page2"},								-- page 3 header
			{"Dist","GSpd"},
			{"GAlt","Hdg"},
			{"nSat","HDOP"},
--			{"rssi","Timer1"}		
			{"GPS"}
		}	
	}
	return ValueSets[index]
	
end