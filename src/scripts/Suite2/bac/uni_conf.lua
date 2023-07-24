function getWidgetPath()
	return("/scripts/libUnow/widget_")
end

--local function modelAnn()
function conf_EMPTY()
	widgetconfLine["EMPTY"]="EMPTY"			-- dummy config for empty widget slots
end	


function uniconf()

	local w_TOPa  		= 1			-- human readable format
	local w_ANNOUNCE    	= 2
	local w_TELEEL   		= 3
	local w_TELE1   		= 4
	local w_TELE2   		= 5
	local w_EMPTY   		= 99

-----------------------------------------
--- list/definition of available widgets
-----------------------------------------
	local widgetList = {
--		indexer] 	=	label/name,			widget Filename, 				mainfunction call,				maxpage =1, widgetCall ={top1(frame,page,xxx) }},
		[w_TOPa] 	=	{label="topa",		File="top18.lua", 			mainfunc="top18a",			maxpage =1,	active = false},
		[w_ANNOUNCE]=	{label="ann",		File="ann.lua", 				mainfunc="announce",		maxpage =1,	active = false},
		[w_TELEEL] 	=	{label="teleEl",	File="teleElectro1.lua", 	mainfunc="teleElectro1",	maxpage =3,	active = false},
		[w_TELE1] 	=	{label="tele1",		File="tele1.lua", 			mainfunc="tele1",			maxpage =3,	active = false},
		[w_TELE2] 	=	{label="tele2",		File="tele2.lua", 			mainfunc="tele2",			maxpage =1,	active = false},
	
		--[w_EMPTY] 	=	{label="EMPTY"}
		[w_EMPTY] 	=	{label="EMPTY",		File="void.lua", 			mainfunc="void",			maxpage =1,}
	}

-------------------------------------
----   widget assignments  ----------
----    "which is where"   ----------
----    1=left   2=right   ----------
-------------------------------------
	widgetAssignment = {
		[TOPLINE] 		=	widgetList[w_TOPa],

		[TOP_1] 			=	widgetList[w_ANNOUNCE],
		[CENTER_1] 		=	widgetList[w_EMPTY],
		[BOTTOM_1] 		=	widgetList[w_TELE1],

		[TOP_2]			=	widgetList[w_TELEEL],		
		[CENTER_2] 		=	widgetList[w_EMPTY],	
		[BOTTOM_2] 		=	widgetList[w_EMPTY],	
	}
end