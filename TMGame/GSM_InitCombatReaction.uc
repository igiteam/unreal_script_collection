
/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class GSM_InitCombatReaction extends TGSpecialMove;

/** Animation */
var const	array<TGPawn.BodyStance>	BS_List;
var			int							BSIdx;


protected function bool InternalCanDoSpecialMove()
{
	// Can't stumble if doing another special move
	if( PawnOwner.SpecialMove != SM_None && PawnOwner.SpecialMove != SM_ChainsawHold && !PawnOwner.IsDoingMove2IdleTransition() )
	{
		return FALSE;
	}

	return TRUE;
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

	PawnOwner.StopFiring();

	BSIdx = Rand(BS_List.Length);
	;

	// Play body stance animation.
	PawnOwner.BS_Play(BS_List[BSIdx], SpeedModifier, 0.2f/SpeedModifier, 0.3f/SpeedModifier, FALSE, TRUE);

	// Enable end of animation notification. This is going to call SpecialMoveEnded()
	PawnOwner.BS_SetAnimEndNotify(BS_List[BSIdx], TRUE);
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	PawnOwner.BS_SetAnimEndNotify(BS_List[BSIdx], FALSE);
}


