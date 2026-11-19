
/**
 * Savage Drone ROAR animation.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_SavageDrone_ROAR extends GSM_BasePlaySingleAnim;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced, PrevMove);

	// Keep track of when we play this special move.
	GearGRI(PawnOwner.WorldInfo.GRI).LastSavageDroneROAR = PawnOwner.WorldInfo.TimeSeconds;
}

defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="ADD_Roar")))
	BlendInTime=0.33f
	BlendOutTime=0.33f

	DefaultAICommand=class'AICmd_Base_PushedBySpecialMove'
	bDisableTurnInPlace=TRUE
	bShouldAbortWeaponReload=TRUE
	bCanFireWeapon=FALSE
	bDisableMovement=TRUE
	bLockPawnRotation=TRUE
	bDisableAI=TRUE
	bRestoreMovementAfterMove=TRUE
}
