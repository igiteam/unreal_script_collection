
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_Sentry_HitReact extends GSM_BasePlaySingleAnim;

defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="Spin_Loop")))
	BlendInTime=0.4
	BlendOutTime=1.0

	bCanFireWeapon=FALSE
	bLockPawnRotation=TRUE
	bDisableMovement=TRUE
	bRestoreMovementAfterMove=TRUE
}
