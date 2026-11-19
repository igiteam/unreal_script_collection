
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Wretch_EmergePod extends GSM_Emerge;


function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced, PrevMove);
	PawnOwner.bCollideWorld = TRUE;
}

defaultproperties
{
	StanceArray(0)=(Stance=((Slot=BS_FullBody,AnimName="swipe")))
	StanceArray(1)=(Stance=((Slot=BS_FullBody,AnimName="swipe")))
	StanceArray(2)=(Stance=((Slot=BS_FullBody,AnimName="swipe")))
	StanceArray(3)=(Stance=((Slot=BS_FullBody,AnimName="swipe")))
}
