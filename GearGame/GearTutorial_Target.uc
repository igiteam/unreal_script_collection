/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearTutorial_Target extends GearTutorial_Base
	config(Game);


/** Whether the trigger is held down right now */
var transient bool bTriggerHeld;

/** Amount of time aiming to determine this tutorial finished */
var config float TotalTimeHeldForCompletetion;

/** Total amount of time aiming since this tutorial was started */
var float TotalTimeAiming;

/** Start time of when the aiming started */
var float AimingStartTime;

/************************************************************************/
/* Script functions                                                     */
/************************************************************************/

/** Called every tick so that the tutorial has a chance to update itself */
event Update()
{
	local GearPlayerInput_Base PInput;
	local GearPC GPC;
	
	GPC = GearPC(Outer);
	PInput = GearPlayerInput_Base(GPC.PlayerInput);
	if (PInput != None)
	{
		if (PInput.IsButtonActive(RemapGameButton(GB_LeftTrigger)))
		{
			if (!bTriggerHeld)
			{
				bTriggerHeld = true;
				AimingStartTime = GPC.WorldInfo.TimeSeconds;
			}
			else
			{
				TotalTimeAiming += GPC.WorldInfo.TimeSeconds - AimingStartTime;
				AimingStartTime = GPC.WorldInfo.TimeSeconds;
			}
		}
		else
		{
			bTriggerHeld = false;
		}
	}

	if (TotalTimeAiming > TotalTimeHeldForCompletetion)
	{
		OnTutorialCompleted();
	}

	Super.Update();
}

defaultproperties
{
	TutorialType=GEARTUT_Target
}
