/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLConsole extends Console
	native;

native function AddCustomCommandsToAutoComplete();

function bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE )
{
	local OLCheatManager CheatMgr;

	if ( Event == IE_Pressed )
	{
		bCaptureKeyInput = false;

		CheatMgr = class'OLCheatManager'.static.GetCheatManager();
		if (CheatMgr != None && CheatMgr.bCheatsEnabled)
		{
			if ( Key == ConsoleKey )
			{
				GotoState('Open');
				bCaptureKeyInput = true;
				return true;
			}
			else if ( Key == TypeKey )
			{
				GotoState('Typing');
				bCaptureKeyInput = true;
				return true;
			}
		}
	}

	return bCaptureKeyInput;
}

defaultproperties
{
}