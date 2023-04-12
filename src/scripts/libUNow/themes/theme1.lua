-- "Master" theme templates for widgets running under Ethos 
-- (1) define themes 
-- (2) return the one which was choosen
--  udo nowakowski, 2022

-- Rev 1.0





function initTheme(choice)

	theme ={}
	local themeTemplate={}
	
	themeTemplate[1]= {								-- dark
	-- colors
			-- monochrome
		c_backgrAll 	= lcd.RGB(  0,   0,   0),
		c_backgrWid 	= lcd.RGB( 70,  70,  70),
		c_backgrEDT		= lcd.RGB(120, 120, 120),
		c_frontAll	 	= lcd.RGB(255, 255, 255),
			-- color
		c_backgrTop 	= lcd.RGB(100,  10,  10),
		c_light1		= lcd.RGB(255, 255,   0),


		
	-- Text	
			-- monochrome
		c_textStd		= lcd.RGB(255, 255, 255),
		c_textHeader	= lcd.RGB(140, 140, 140),
		c_textInvert	= lcd.RGB(0,   0,   0),
		c_textgrey1		= lcd.RGB(130, 130, 130),
		c_textdark		= lcd.RGB(190, 190, 190),
		-- color
		c_textRed		= lcd.RGB(255,  30,  30),
		c_textGreen		= lcd.RGB(  0, 160,   0),	
		c_textAlarm		= lcd.RGB(255,  30,  30),
		-- buttontext
		c_textindOn		= lcd.RGB( 30,  100,  30),
		c_textindOff	= lcd.RGB(170,  170, 170),
		c_textindAlarm	= lcd.RGB(210,   40,  40),
		
	-- Buttons	
		c_ButRed		= lcd.RGB(230,   0,   0),
		c_ButBluestd	= lcd.RGB( 50,  50, 200),
		c_ButBlueBright	= lcd.RGB(100, 100, 200),
		c_ButGreen		= lcd.RGB(  0, 180,   0),		
		c_ButGrey		= lcd.RGB(180, 180, 180),
	
	-- div stati	
		c_statusOKOK	= lcd.RGB( 30, 240,  30),
		c_statusOK		= lcd.RGB(  0, 100,   0),
		c_statusPrewarn	= lcd.RGB(255, 200,  40),		
		c_statusWarn	= lcd.RGB(180,  90,  90),
		c_statusAlarm	= lcd.RGB(255,  10,  10),

	-- "indicators"
		c_indOff		= lcd.RGB(100, 100, 100),
		c_indOn			= lcd.RGB( 30, 240,  30),
		c_indWarn		= lcd.RGB(255,  10,  10),
		c_indAlarm		= lcd.RGB(255,  10,  10),
		}	
	
	
	themeTemplate[2] = {									-- bright
	-- colors
			-- monochrome
		c_backgrAll 	= lcd.RGB(255, 255, 255),
		c_backgrWid 	= lcd.RGB(180, 180, 180),
		c_backgrEDT		= lcd.RGB(120, 120, 120),
		c_frontAll	 	= lcd.RGB(  0,   0,   0),		
			-- color
		c_backgrTop 	= lcd.RGB(150, 230, 230),
		c_light1		= lcd.RGB(255, 100,  80),

		
	-- Text	
			-- monochrome
		c_textStd		= lcd.RGB( 0,   0,   0),
		c_textHeader	= lcd.RGB(110, 110, 110),		
		c_textInvert	= lcd.RGB(255, 255, 255),
		c_textgrey1		= lcd.RGB(130, 130, 130),
		c_textdark		= lcd.RGB(140, 140, 140),
			-- color
		c_textRed		= lcd.RGB(255,  30,  30),
		c_textGreen		= lcd.RGB(  0, 160,   0),	
		c_textAlarm		= lcd.RGB(255,  30,  30),
		-- buttontext
		c_textindOn		= lcd.RGB( 30, 100,  30),
		c_textindOff	= lcd.RGB(170, 170, 170),
		c_textindAlarm	= lcd.RGB(210,  40,  40),		
		
		
	-- Buttons	
		c_ButRed		= lcd.RGB(230,   0,   0),
		c_ButBluestd	= lcd.RGB( 50,  50, 200),
		c_ButBlueBright	= lcd.RGB(100, 100, 200),
		c_ButGreen		= lcd.RGB(  0, 180,   0),		
		c_ButGrey		= lcd.RGB(180, 180, 180),
		
	-- div stati	
		c_statusOKOK	= lcd.RGB( 30, 240,  30),
		c_statusOK		= lcd.RGB(  0, 100,   0),
		c_statusPrewarn	= lcd.RGB(255, 200,  40),		
		c_statusWarn	= lcd.RGB(180,  90,  90),
		c_statusAlarm	= lcd.RGB(255,  10,  10),

	-- "indicators"
		c_indOff		= lcd.RGB(100, 100, 100),
		c_indOn			= lcd.RGB( 30, 240,  30),
		c_indWarn		= lcd.RGB(255,  10,  10),
		c_indAlarm		= lcd.RGB(255,  10,  10),

		
		}
	

	return (themeTemplate[choice])


end