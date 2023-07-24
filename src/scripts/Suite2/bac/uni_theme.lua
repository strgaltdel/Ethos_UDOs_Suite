function initTheme()

	theme ={}
	local themeTemplate={}

	themeTemplate.dark = {
	-- colors
		--c_backgrAll 	= lcd.RGB(80,   30,   0),
		c_backgrAll 	= lcd.RGB(  0,   0,   0),
		c_backgrWid 	= lcd.RGB( 70,  70,  70),
		c_backgrEDT	= lcd.RGB(120, 120, 120),
		c_backgrTop 	= lcd.RGB(100,  10,  10),
		
	-- Text	
		-- monochrome
		c_textStd		= lcd.RGB(255, 255, 255),
		c_textHeader	= lcd.RGB(140, 140, 140),
		c_textgrey1		= lcd.RGB(120, 120, 120),
		c_textdark		= lcd.RGB(100, 100, 100),
		-- color
		c_textRed		= lcd.RGB(255,   30,   30),
		c_textGreen		= lcd.RGB( 30,   255,   30),
		-- buttontext
		c_textindOn		= lcd.RGB( 30,   100,   30),
		c_textindOff	= lcd.RGB(170,  170,    170),
		c_textindAlarm	= lcd.RGB(210,    40,    40),
		
	-- div stati	
		c_statusOKOK	= lcd.RGB( 30, 240,  30),
		c_statusOK		= lcd.RGB(  0, 100,   0),
		c_statusPrewarn	= lcd.RGB(255, 200,   40),		
		c_statusWarn	= lcd.RGB(180,  90,  90),
		c_statusAlarm	= lcd.RGB(255,  10,  10),
		
	-- Buttons & "indicators"
		c_indOff		= lcd.RGB(100, 100, 100),
		c_indOn			= lcd.RGB( 30, 240,  30),
		c_indWarn		= lcd.RGB(255,  10,  10),
		c_indAlarm		= lcd.RGB(255,  10,  10),
		
		Image 			= lcd.loadBitmap("/scripts/libUnow/img/Euro1.png")
			
		}
	
		return(themeTemplate.dark)
end