
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Tempest_VentInAir extends GearSpecialMove;


/** Body stances needed for this special move */
var	GearPawn.BodyStance	BS_Open;
var	GearPawn.BodyStance	BS_VentLoop;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);
	
	PawnOwner.BS_Play(BS_Open, 1.0, 0.2, 0.2);
	
	// Enable end of animation notification. This is going to call SpecialMoveEnded()
	PawnOwner.BS_SetAnimEndNotify(BS_Open, TRUE);
}

/**
 * Notification called when body stance animation finished playing.
 * @param	SeqNode		- Node that finished playing. You can get to the SkeletalMeshComponent by looking at SeqNode->SkelComponent
 * @param	PlayedTime	- Time played on this animation. (play rate independent).
 * @param	ExcessTime	- how much time overlapped beyond end of animation. (play rate independent).
 */
function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	local GearPawn_LocustTempestBase Tempest;
	
	if (PawnOwner.BS_SeqNodeBelongsTo(SeqNode, BS_Open))
	{
		PawnOwner.BS_Play(BS_VentLoop, 1.0, 0.2, 0.2, TRUE);
		
		Tempest = GearPawn_LocustTempestBase(PawnOwner);		
		Tempest.ReleasePod(TRUE);
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	// Stop animation if it's still playing
	PawnOwner.BS_Stop(BS_VentLoop, 0.2f);

	// Disable end of animation notification.
	PawnOwner.BS_SetAnimEndNotify(BS_Open, FALSE);

	Super.SpecialMoveEnded(PrevMove, NextMove);
}


defaultproperties
{
	BS_Open=(Stance=((Slot=BS_FullBody,AnimName="PodRelease_Start")))
	BS_VentLoop=(Stance=((Slot=BS_FullBody,AnimName="PodRelease_Loop")))
}