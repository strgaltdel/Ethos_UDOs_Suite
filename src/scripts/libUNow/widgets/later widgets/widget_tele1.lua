
---------------
-- Define config string
---------------
function conf_tele1()
	widgetconfLine["tele1"]	=	"!tel1,void"		-- no special configuration
end

function tele1(frameX)
	conf_tele1()
	lcd.color(BLUE)
	frame.drawFilledRectangle(5,5,80,8, frameX)

	lcd.color(RED)
	frame.drawRectangle(10,18,60,8, frameX)

	lcd.color(WHITE)
	frame.drawLine(20,30,30,30, frameX)


end

