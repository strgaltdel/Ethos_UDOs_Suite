


																			-- ************************************************
																			-- ***		     name widget					*** 
																			-- ************************************************
local translations = {en="Udos Suite 1.0"}
local function name(widget)					-- name script
  local locale = system.getLocale()
	 return translations[locale] or translations["en"]
end


																			-- ************************************************
																			-- ***		     create handler					*** 
																			-- ************************************************
local function create()
  return{	
		w			 = nil, 						-- frame width (Ethos widget frame)
		h			 = nil, 						-- frame high  (Ethos widget frame)
		configured	 = false
		}
end


-- run once at first paint loop :
local function frontendConfigure(widget)
	widget.w, widget.h = lcd.getWindowSize()
	print("*****************************   FRONTEND widgetsize SUITE:",widget.w,widget.h)
	if widget.w> 0 then
		return true	
	else
		return false
	end
end


																			-- ************************************************
																			-- ***		     "display handler"				*** 
																			-- ************************************************
local function paint(widget)
	if not(widget.configured) then											-- one time config; cant be executed during create cause window size not availabe then
		widget.configured = frontendConfigure(widget)	
	end
end


																			-- ************************************************
																			-- ***		     configure widget				*** 
																			-- ************************************************
local function configure(widget)
	
end

																			-- ************************************************
																			-- ***		     "background loop"				*** 
																			-- ************************************************

local function wakeup(widget)												
-- 	lcd.invalidate()
paint(widget)
end


																			-- ****************************************************
																			-- ***		     read widget config             *** 
																			-- ***	if subApp identified, load lang file     ***
																			-- ****************************************************
local function read(widget)
												
end		


																			-- ************************************************
																			-- ***		     write widget config 	   		*** 
																			-- ************************************************
local function write(widget)

end





																			-- ************************************************
																			-- ***		     monitor events		 	   		*** 
																			-- ************************************************
local function event(widget, category, value, x, y)

					

end

																			-- ************************************************
																			-- ***		     init widget			   		*** 
																			-- ************************************************
local function init()
 system.registerWidget({key="test04", name=name, create=create, wakeup=wakeup, paint = paint, configure=configure, event=event, read=read, write = write})
end

return {init=init}