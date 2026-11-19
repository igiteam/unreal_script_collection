
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_EvadeRt extends GSM_Evade;

/** If TRUE, we are doing a mirroring transition. */
var bool				bDoMirroringTransition;

protected function bool InternalCanDoSpecialMove()
{
	return InternalCanDoSpecialMoveEvade_Worker(SM_EvadeRt);
}

simulated function PreProcessInput(GearPlayerInput Input)
{
	// call the super class's version
	Super.PreProcessInput(Input);

	// force running to the right
	Input.aStrafe	= default.AccelScale;
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local Vector	Direction, X, Y, Z;

	// Play proper animations depending on mirroring or not
	if( PawnOwner.bIsMirrored )
	{
		bDoMirroringTransition = TRUE;
	}
	else
	{
		bDoMirroringTransition = FALSE;
	}

	Super.SpecialMoveStarted(bForced,PrevMove);

	if( bDoMirroringTransition )
	{
		// Play animation mirrored
		PawnOwner.BS_SetMirrorOptions(BS_EvadeStart, FALSE, TRUE, TRUE);

		// This is a super hack to not trigger the mirror transition blend out just now.
		// We want to play 2 animations in a row. ugh!
		PawnOwner.MirrorNode.bLockBlendOut = TRUE;
	}

	// for players, turn wto face direction he's trying to move
	if (PCOwner != None && PCOwner.bAllow360Evade)
	{
		GetAxes( PCOwner.Rotation, X, Y, Z );

		// go in direction stick is pointing, properly offset to deal with fact we are evading right
		Direction = Normal((PCOwner.RemappedJoyUp * -Y) + (PCOwner.RemappedJoyRight * X) );
		if( !IsZero(Direction) )
		{
			SetLockPawnRotation(false);
			PawnOwner.FaceRotation(Rotator(Direction), 9999.f);		// large val to snap
			SetLockPawnRotation(true);
		}
	}
}



/** Notification called when body stance animation finished playing */
simulated function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	if( bPlayStartAnimation )
	{
		// Turn off mirroring on this node.
		PawnOwner.BS_SetMirrorOptions(BS_EvadeStart, FALSE, FALSE, FALSE);
	}

	Super.BS_AnimEndNotify(SeqNode, PlayedTime, ExcessTime);

	if( PawnOwner.bIsMirrored )
	{
		// Play animation mirrored
		PawnOwner.BS_SetMirrorOptions(BS_EvadeEnd, FALSE, TRUE, TRUE);
	}
}


function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	if( bDoMirroringTransition )
	{
		// This is a super hack to not trigger the mirror transition blend out just now.
		// We want to play 2 animations in a row. ugh!
		PawnOwner.MirrorNode.bLockBlendOut = FALSE;
	}

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

defaultproperties
{
	BS_EvadeStart=(Stance=((Slot=BS_FullBody,AnimName="AR_Evade_Rt_Start")))
	BS_EvadeEnd=(Stance=((Slot=BS_FullBody,AnimName="AR_Evade_Rt_End")))

	bCoverExitMirrorTransition=TRUE
}
