/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class KryllProtectionVolume extends Volume
	placeable;

/** Whether we should be protecting from kryll now */
var() bool bEnabled;

/**
 * Handling Toggle event from Kismet.
 * 
 * @param Action - the kismet action that is toggling us
 */
simulated function OnToggle(SeqAct_Toggle Action)
{
	// Turn ON
	if (Action.InputLinks[0].bHasImpulse)
	{
		bEnabled = TRUE;
	}
	// Turn OFF
	else if (Action.InputLinks[1].bHasImpulse)
	{
		bEnabled = FALSE;
	}
	// Toggle
	else if (Action.InputLinks[2].bHasImpulse)
	{		
		bEnabled = !bEnabled;
	}
}

defaultproperties
{
	bEnabled=TRUE

	// volume properties
	bColored=true
	BrushColor=(R=255,G=128,B=0,A=255)

	bProcessAllActors=TRUE
	bStatic=FALSE
	Physics=PHYS_Interpolating
}