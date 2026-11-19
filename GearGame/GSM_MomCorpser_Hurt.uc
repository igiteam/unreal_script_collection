
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_MomCorpser_Hurt extends GearSpecialMove;


var()	GearPawn.BodyStance	BS_Animation;
var()   GearPawn_LocustMomCorpserBase Corpser;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

	// Stop stab attack first to cancel any animations.
	GearPawn_LocustMomCorpserBase(PawnOwner).StopStabAttack();

	SpeedModifier = 2.0f;

	// Play body stance animation.
	PawnOwner.BS_Play(BS_Animation, SpeedModifier, 0.2f/SpeedModifier, 0.2f/SpeedModifier, FALSE, TRUE);

	// Enable end of animation notification. This is going to call SpecialMoveEnded()
	PawnOwner.BS_SetAnimEndNotify(BS_Animation, TRUE);

	
	Corpser = GearPawn_LocustMomCorpserBase(PawnOwner);
	if( Corpser != None )
	{
		Corpser.SetTimer(0.2f, FALSE, nameof(Corpser.StartPushAwayPlayers), Corpser);
	}
}


function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	// Disable end of animation notification. 
	PawnOwner.BS_SetAnimEndNotify(BS_Animation, FALSE);

	if( Corpser != None )
	{
		Corpser.StopPushAwayPlayers();
		Corpser.ClearTimer( nameof(Corpser.StartPushAwayPlayers), Corpser);
		Corpser.MeleeAttackEnded( None );
	}
}

defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_Std_Idle_Lower,AnimName="Scream")))

	bLockPawnRotation=TRUE
	bBreakFromCover=TRUE
	bDisableCollision=FALSE
	bDisableMovement=TRUE
	bDisablePhysics=TRUE
}