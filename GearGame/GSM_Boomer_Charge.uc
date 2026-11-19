/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_Boomer_Charge extends GearSpecialMove;

/** SpeedModifier increased in DefaultPawn.ini */

simulated function PreProcessInput(GearPlayerInput Input)
{
	// force running forwards
	Input.aBaseY = 1.0;

	// strafe becomes turning
	Input.aTurn = (Input.aStrafe * 0.33);
	Input.aStrafe = 0.0;
}

defaultproperties
{
	bCanFireWeapon=false
}
