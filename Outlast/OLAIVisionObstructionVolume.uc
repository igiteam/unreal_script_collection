/**
 * AI Vision Obstruction Volume
 * -Prevents to AI from seeing through this volume 
 * except when the player is using his nightvision.
 *
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLAIVisionObstructionVolume extends OLGameplayVolume
	native
	placeable;

simulated function OnToggle(SeqAct_Toggle Action)
{
	// Turn ON
	if (Action.InputLinks[0].bHasImpulse)
	{
		bEnabled = true;
	}
	// Turn OFF
	else if (Action.InputLinks[1].bHasImpulse)
	{
		bEnabled = false;
	}
	// Toggle
	else if (Action.InputLinks[2].bHasImpulse)
	{
		bEnabled = !bEnabled;
	}

	Super.OnToggle( Action );
}

defaultproperties
{
}
