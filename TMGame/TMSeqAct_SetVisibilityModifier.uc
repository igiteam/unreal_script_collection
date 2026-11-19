/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

class TMSeqAct_SetVisibilityModifier extends SequenceAction;

var() float NewVisibilityModifier;

event Activated()
{
	local TMMapInfo MapInfo;

	MapInfo = TMMapInfo(GetWorldInfo().GetMapInfo());
	if (MapInfo == None)
	{
		ScriptLog("SetVisibilityModifier: Missing TMMapInfo!");
	}
	else
	{
		if ( NewVisibilityModifier < 1.0 )
			MapInfo.VisibilityModifier = 0.8 * NewVisibilityModifier;
		else
		MapInfo.VisibilityModifier = NewVisibilityModifier;
	}
}

