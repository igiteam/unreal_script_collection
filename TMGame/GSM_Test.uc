
/**
 * Base Special Move to play a single animation, 
 * and end itself once it's done playing. 
 *
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Test extends TGSpecialMove;

/** Animation to play */
var()	TGPawn.BodyStance	BS_Drop;
var()	TGPawn.BodyStance	BS_Getup;
var		FLOAT				BlendInTime;
var		FLOAT				BlendOutTime;

var		bool	bPlayStartAnimation;
/** Name of camera animation to play when this special move starts. */
//var protected array<CameraBoneAnimation> SpecialMoveCameraBoneAnims;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced, PrevMove);

	// Play animation
	bPlayStartAnimation = TRUE;

	// Play Evade Start Animation.
	PawnOwner.BS_Play(BS_Drop, SpeedModifier, 0.1f/SpeedModifier, -1.f, FALSE, TRUE);

	// Enable end of animation notification. This is going to call SpecialMoveEnded()
	PawnOwner.BS_SetAnimEndNotify(BS_Drop, TRUE);

	// Turn on Root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Drop, RBA_Translate, RBA_Translate, RBA_Translate);

	PawnOwner.Mesh.RootMotionMode = RMM_Accel;
}

/** Notification called when body stance animation finished playing */
simulated function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	if( bPlayStartAnimation )
	{
		bPlayStartAnimation = FALSE;

		PawnOwner.BS_Stop(BS_Drop);
		PawnOwner.BS_SetAnimEndNotify(BS_Drop, FALSE);

		// Set Evade End animation.
		PawnOwner.BS_Play(BS_Getup, SpeedModifier, 0.f, -1.f, FALSE, TRUE);

		// Set correct position for transition.
		PawnOwner.BS_SetPosition(BS_Getup, ExcessTime * PawnOwner.BS_GetPlayRate(BS_Getup));

		// Enable end of animation notification. This is going to call SpecialMoveEnded()
		PawnOwner.BS_SetAnimEndNotify(BS_Getup, TRUE);

		// Turn on Root motion on animation node
		PawnOwner.BS_SetRootBoneAxisOptions(BS_Getup, RBA_Translate, RBA_Translate, RBA_Translate);
	}
	else
	{
		PawnOwner.EndSpecialMove();
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	PawnOwner.ClearTimer('CheckTransitionToAnotherMove', Self);

	// Stop stances
	PawnOwner.BS_Stop(BS_Drop, 0.25f);
	PawnOwner.BS_Stop(BS_Getup, 0.25f);

	// Disable end of animation notification.
	PawnOwner.BS_SetAnimEndNotify(BS_Drop, FALSE);
	PawnOwner.BS_SetAnimEndNotify(BS_Getup, FALSE);

	// Restore original root motion
	PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;
}

