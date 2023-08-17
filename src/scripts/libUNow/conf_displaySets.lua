-- "Master" layout for widgets running under Ethos 
-- (1) detect kind of Tx / display
-- (2) set Text Sizing
--  udo nowakowski, 2023

-- Feb 2023
-- Rev 1.1a


function evaluate_display()
-- display handler

	local detectSys = system.getVersion()
	local DISP_X20 <const> 		= 1
	local DISP_X18 <const> 		= 2
	local DISP_HORUS <const> 	= 3
	--print("SYSTEM",detectSys.board)
	-- void
	if detectSys.board == "X12" or detectSys.board == "X10EXPRESS" then return(DISP_HORUS) end
	if detectSys.board == "X18S" or detectSys.board == "X18" then return(DISP_X18) end
	return(DISP_X20)
	
end


function defineTeleSize(display)
	local text_Xsml, text_sml, text_std, text_big
--print("disp:", display)
	
	if display == 3 then		-- 3=Horus
		text_Xsml	= FONT_S
		text_sml	= FONT_STD
		text_std 	= FONT_STD
		text_big	= FONT_XXL
		
	elseif display == 2 then	-- 2=X18
		text_Xsml	= FONT_S
		text_sml	= FONT_STD	-- value:0
		text_std 	= FONT_XL
--		text_big	= FONT_XL	-- nip
		text_big	= FONT_XXL
	else						-- X20
		text_Xsml	= FONT_S
		text_sml 	= FONT_STD
		text_std 	= FONT_XL
		text_big	= FONT_XXL
	end
	print("FONT:",FONT_XS, FONT_S,FONT_STD,FONT_L,FONT_XL, FONT_XXL)

	return text_Xsml, text_sml, text_std, text_big
end


