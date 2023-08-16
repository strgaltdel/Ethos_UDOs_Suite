local function gvarData(dataSet)

	local data = {}

	-- set standard
	data[1] = {
		{"Differenzierung",			"Diff"			,"diff.wav"},
		{"H�hentrim W�lbkl",		"Cmb 2 Ele"		,"mot2ele.wav"},		
		{"H�hentrim ButFl.",		"BFl 2 Ele"		,"bfl2ele.wav"},
		{"H�hentrim Motor",			"Mot 2 Ele"		,"mot2ele.wav"},
		{"Diff V Ltw",				"V Diff"		,"vdiff.wav"}		
--		{"H�hentrim Stoerkl",		"Brk 2 Ele"		,"brk2ele.wav"},
		}
	
	-- set extended 1
	data[2] = {
		{"Differenzierung",			"Diff"			,"diff.wav"},
		{"Rate Quer innen",			"Ail 2 Cmb"		,"ail2cmb.wav"},
		{"Rate W�lb aussen",		"Cmb 2 Ail"		,"cmb2ail.wav"},
		{"Rate snapflap",			"snapflap"		,"snapflap.wav"},
		{"H�hentrim W�lbkl",		"Cmb 2 Ele"		,"mot2ele.wav"},
		{"H�hentrim ButFl.",		"BFl 2 Ele"		,"bfl2ele.wav"},
		{"H�hentrim Motor",			"Mot 2 Ele"		,"mot2ele.wav"},
		{"Diff V Ltw",				"V Diff"		,"vdiff.wav"}		
--		{"H�hentrim Stoerkl",		"Brk 2 Ele"		,"brk2ele.wav"},
		}	
		
	-- set W�lbklappe
	data[3] = {
		{"Rate W�lben",				"Rate W�lb"		,"rate_cmb.wav"},
		{"Rate W�lb aussen",		"Cmb 2 Ail"		,"cmb2ail.wav"},
		{"H�hentrim W�lbkl",		"Cmb 2 Ele"		,"mot2ele.wav"}
		}

	-- set H�henruder
	data[4] = {
		{"HR Rate ziehen",			"Cmb 2 Ele"		,"ele_rate_up.wav"},		
		{"HR Rate dr�cken",			"BFl 2 Ele"		,"ele_rate_dn.wav"},
		{"HR Expo",					"BFl 2 Ele"		,"ele_expo.wav"},
		{"H�hentrim W�lbkl",		"Cmb 2 Ele"		,"mot2ele.wav"},		
		{"H�hentrim ButFl.",		"BFl 2 Ele"		,"bfl2ele.wav"},
		{"H�hentrim Motor",			"Mot 2 Ele"		,"mot2ele.wav"}
		}
		
	return data[dataSet]
end