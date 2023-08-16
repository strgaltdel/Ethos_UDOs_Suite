-- language file for topbar widget
-- udo nowakowski
-- 8.Feb.2023


local txt_Fields = {

--					de														en

	motorSafe		= {"SICHER",											"SAFE"			}, 
	motorON			= {"Mot EIN",											"ON"			}, 
	motorArmed		= {"Scharf!",											"Armed"			}, 
	motorPreArmed	= {"Gas !",												"Danger!"		}, 

	
--  config Form	
	conf	= 	{
					{"Status1, LSW:", 										"Status1, LSW:" 									},					
					{"Status1, label",										"Status1, label"									},											
					{"Status2, LSW:", 										"Status2, LSW:" 									},			
					{"Status2, label",										"Status2, label"									},	
					{"VFR Wert",											"VFR value"											},			-- display VFR / access feature	
					{"MotSchutz ..status \"Sicher\",LSW:",					"Mot Safety status \"SAFE\",LSW:"				},			
					{"        ..status \"Scharf\",LSW:",					"     status \"WARN/pre-engaged\",LSW:"	},														
					{"     Motor LÄUFT",									"     Motor RUNNING",			},				
				}

}



return txt_Fields