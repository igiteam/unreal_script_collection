////
//ZMLCmdFont - Process the action commands, to display the button corresponding to a game command (like "use", "fire", etc.)
////
class ZMLCmdFont extends ZMLCommand;

function DoRender(string arg, Canvas c, ZMLRender ZMLDevice)
{
	//local font f;

	SetFontFromString(arg, c);
}


function SetFontFromString(string arg, Canvas c)
{
	switch (arg)
	{
		case "WB":
		case "W":
		case "WW":
			class'ZombieFontDescriptor'.static.SetNormalFont(c);
			return;


		case "BW":
			class'ZombieFontDescriptor'.static.SetNormalFont(c);
			return;

	}

	return;
}

event float GetWidth(string command, ZMLRender ZMLDevice)
{
	return 0;
}


// Decompiled with UE Explorer.
defaultproperties
{
    CommandString="font"
}