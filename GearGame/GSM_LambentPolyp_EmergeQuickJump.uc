/**
 * Special move for quickly jumping out of holes
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_LambentPolyp_EmergeQuickJump extends GSM_EmergeQuickJump;


function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced, PrevMove);
	PawnOwner.bCollideWorld = true;
}

defaultproperties
{
	BS_Jump=(Stance=((Slot=BS_FullBody,AnimName="mantle_over_start")))
	BS_Transition=(Stance=((Slot=BS_FullBody,AnimName="mantle_over_fall")))
	BS_Fall=(Stance=((Slot=BS_FullBody,AnimName="mantle_over_fall")))
	BS_Land=(Stance=((Slot=BS_FullBody,AnimName="mantle_over_land")))
	
	TakeoffVelocityHorizMin=500.0
	TakeoffVelocityHorizMax=600.0
	TakeoffVelocityVertMin=200.0
	TakeoffVelocityVertMax=300.0
}
