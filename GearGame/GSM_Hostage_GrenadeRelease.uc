/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_Hostage_GrenadeRelease extends GSM_InteractionPawnFollower_Base;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced, PrevMove);

	// allow doomed hostages to fall
	if (PawnOwner.Controller == None)
	{
		PawnOwner.bCanJump = true;
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	PawnOwner.bCanJump = PawnOwner.default.bCanJump;
}

defaultproperties
{
	bUseUnsynchedServerMove=true
	bOnlyInteractionPawnCanDamageMe=true
}
