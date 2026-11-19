/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class LadderMarker extends NavigationPoint
	native(TG);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var Trigger_LadderInteraction LadderTrigger;
/** Indicates if this trigger is hooked up to the top of the ladder */
var() bool bIsTopOfLadder;

simulated event string GetDebugAbbrev()
{
	return "LM";
}

