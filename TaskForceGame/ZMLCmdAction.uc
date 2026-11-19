////
//ZMLCmdAction - Process the action commands, to display the button corresponding to a game command (like "use", "fire", etc.)
////
class ZMLCmdAction extends ZMLCommand;

function DoRender(string arg, Canvas c, ZMLRender ZMLDevice)
{
	local int iconIdx;
	
	iconIdx = GetIconForAction(arg, ZMLDevice);

	if (iconIdx != -1)
	{
		//kkm--hardcoded offsets again... new icons appear too low
		class'HUDIconMgr'.static.DrawImageHW(c, iconIdx, c.curX, c.curY-8);
	}
	else
	{
		log( "%%%%%%%%%%NO iconIdx for"@arg );
	}
}


function int GetIconForAction(string action, ZMLRender ZMLDevice)
{
	local int cmdKey;
	local int iconIdx;

	iconIdx = -1;

	log( "guess you shouldn't have deleted this" );

//	if(ZMLDevice.HUDOwner.PlayerOwner.GetKeyBinding(action, cmdKey, 200))
//	{
//		//find the image for the key
//		//ZMLDevice.PawnOwner.ClientMessage("Found Binding: " $ cmdKey);
//
//		//
//		switch (cmdKey)
//		{
//			case 200:
//				iconIdx = HIM_CONTROLLER_A;
//				break;
//
//			case 201:
//				iconIdx = HIM_CONTROLLER_B;
//				break;
//
//			case 202:
//				iconIdx = HIM_CONTROLLER_X;
//				break;
//
//			case 203:
//				iconIdx = HIM_CONTROLLER_Y;
//				break;
//		}
//	}

	return IconIdx;
}

event float GetWidth(string command, ZMLRender ZMLDevice)
{
	local int iconIdx;

	iconIdx = GetIconForAction(GetArg(command), ZMLDevice);

	if (iconIdx != -1)
	{
		return class'HUDIconMgr'.default.ris[iconIdx].W;
	}
	return 0;
}


// Decompiled with UE Explorer.
defaultproperties
{
    CommandString="action"
}