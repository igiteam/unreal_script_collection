
/**
 * SpecialMove played by the Silverback Driver when getting out. 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Silverback_GetOut extends GearSpecialMove;

var GearPawn_SilverbackBase Silverback;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced, PrevMove);

	Silverback = GearPawn_SilverbackBase(PawnOwner.InteractionPawn);
	if (Silverback != None)
	{
		Silverback.PlayDriverLeaveSound();

		// Make sure Driver is doing his special move...
		if (Silverback.Driver != None && !Silverback.Driver.IsDoingSpecialMove(GSM_Silverback_GetOut))
		{
			Silverback.Driver.DoSpecialMove(GSM_Silverback_GetOut, TRUE, Silverback);
		}

		// Turn off IK on Driver's hands
		Silverback.DriverRightHandIK.SetSkelControlActive(FALSE);
		Silverback.DriverLeftHandIK.SetSkelControlActive(FALSE);
	}
}

defaultproperties
{
	DefaultAICommand=class'AICmd_Base_PushedBySpecialMove'

	bCanFireWeapon=FALSE
	bLockPawnRotation=TRUE
	bDisableMovement=TRUE
}
