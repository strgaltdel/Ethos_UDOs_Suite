local function gvarData(dataSet)

	local data = {}

	-- set standard
	data[1] = {
		{"Differenzierung",			"Diff"			,"diff.wav"},
		{"Höhentrim Wölbkl",		"Cmb 2 Ele"		,"mot2ele.wav"},		
		{"Höhentrim ButFl.",		"BFl 2 Ele"		,"bfl2ele.wav"},
		{"Höhentrim Motor",			"Mot 2 Ele"		,"mot2ele.wav"},
		{"Diff V Ltw",				"V Diff"		,"vdiff.wav"}		
--		{"Höhentrim Stoerkl",		"Brk 2 Ele"		,"brk2ele.wav"},
		}
	
	-- set extended 1
	data[2] = {
		{"Differenzierung",			"Diff"			,"diff.wav"},
		{"Rate Quer innen",			"Ail 2 Cmb"		,"ail2cmb.wav"},
		{"Rate Wölb aussen",		"Cmb 2 Ail"		,"cmb2ail.wav"},
		{"Rate snapflap",			"snapflap"		,"snapflap.wav"},
		{"Höhentrim Wölbkl",		"Cmb 2 Ele"		,"mot2ele.wav"},
		{"Höhentrim ButFl.",		"BFl 2 Ele"		,"bfl2ele.wav"},
		{"Höhentrim Motor",			"Mot 2 Ele"		,"mot2ele.wav"},
		{"Diff V Ltw",				"V Diff"		,"vdiff.wav"}		
--		{"Höhentrim Stoerkl",		"Brk 2 Ele"		,"brk2ele.wav"},
		}	
		
	-- set Wölbklappe
	data[3] = {
		{"Rate Wölben",				"Rate Wölb"		,"rate_cmb.wav"},
		{"Rate Wölb aussen",		"Cmb 2 Ail"		,"cmb2ail.wav"},
		{"Höhentrim Wölbkl",		"Cmb 2 Ele"		,"mot2ele.wav"}
		}

	-- set Höhenruder
	data[4] = {
		{"HR Rate ziehen",			"Cmb 2 Ele"		,"ele_rate_up.wav"},		
		{"HR Rate drücken",			"BFl 2 Ele"		,"ele_rate_dn.wav"},
		{"HR Expo",					"BFl 2 Ele"		,"ele_expo.wav"},
		{"Höhentrim Wölbkl",		"Cmb 2 Ele"		,"mot2ele.wav"},		
		{"Höhentrim ButFl.",		"BFl 2 Ele"		,"bfl2ele.wav"},
		{"Höhentrim Motor",			"Mot 2 Ele"		,"mot2ele.wav"}
		}
		
	return data[dataSet]
end