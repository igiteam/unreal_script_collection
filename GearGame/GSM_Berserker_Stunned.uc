
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Berserker_Stunned extends GearSpecialMove;

var()	GearPawn.BodyStance	BS_Impact, BS_Outro;


/** Get Animation Play Rate */
simulated function float GetAnimPlayRate()
{
	local GearPawn_LocustBerserkerBase	Berserker;
	local GearPawn_LocustBerserkerLambentBase LambentBerserker;
	local float Modifier;

	Modifier = SpeedModifier;
	Berserker = GearPawn_LocustBerserkerBase(PawnOwner);

	// When heated up, animations play faster
	if( Berserker != None && Berserker.bVulnerableToDamage )
	{
		Modifier = Berserker.HeatedUpSpeedScale * SpeedModifier;
		LambentBerserker = GearPawn_LocustBerserkerLambentBase(Berserker);
		if (LambentBerserker != None && LambentBerserker.CurrentPhase < LambentBerserker.PhaseInfo.length)
		{
			Modifier *= LambentBerserker.PhaseInfo[LambentBerserker.CurrentPhase].AnimSpeed;
		}
	}

	return Modifier;
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local float AnimRate;

	Super.SpecialMoveStarted(bForced,PrevMove);

	AnimRate = GetAnimPlayRate();

	// Play impact animation
	PawnOwner.BS_Play(BS_Impact, AnimRate, 0.3f/AnimRate, -1.f, FALSE, TRUE);

	// Have animation forward root motion.
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Impact, RBA_Translate, RBA_Translate, RBA_Translate);

	PawnOwner.BS_SetAnimEndNotify(BS_Impact, TRUE);

	// Turn on Root motion on mesh. Use RMM_Accel, to drive full movement.
	PawnOwner.Mesh.RootMotionMode = RMM_Accel;
}

simulated function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	local float AnimRate;

	if( PawnOwner.BS_IsPlaying(BS_Impact) )
	{
		// Stop previous animation
		PawnOwner.BS_Stop(BS_Impact, 0.3f);
		PawnOwner.BS_SetAnimEndNotify(BS_Impact, FALSE);
		PawnOwner.BS_SetRootBoneAxisOptions(BS_Impact, RBA_Discard, RBA_Discard, RBA_Discard);

		AnimRate = GetAnimPlayRate();

		// Play outro animation
		PawnOwner.BS_Play(BS_Outro, AnimRate, 0.3f/AnimRate, 0.3f/AnimRate, FALSE, TRUE);
		// Adjust position for seemless transition
		PawnOwner.BS_SetPosition(BS_Outro, ExcessTime * PawnOwner.BS_GetPlayRate(BS_Outro));

		// Have animation forward root motion.
		PawnOwner.BS_SetRootBoneAxisOptions(BS_Outro, RBA_Translate, RBA_Translate, RBA_Translate);

		// Enable end of animation notification. This is going to call SpecialMoveEnded()
		PawnOwner.BS_SetAnimEndNotify(BS_Outro, TRUE);
	}
	else
	{
		PawnOwner.EndSpecialMove();
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	// Turn off Root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Outro, RBA_Discard, RBA_Discard, RBA_Discard);
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Impact, RBA_Discard, RBA_Discard, RBA_Discard);

	// Disable end of animation notification.
	PawnOwner.BS_SetAnimEndNotify(BS_Outro, FALSE);
	PawnOwner.BS_SetAnimEndNotify(BS_Impact, FALSE);

	// Stop animation if it didn't already
	PawnOwner.BS_Stop(BS_Impact, 0.3f);
	PawnOwner.BS_Stop(BS_Outro, 0.3f);

	// Restore default root motion mode
	PawnOwner.Mesh.RootMotionMode = PawnOwner.Mesh.default.RootMotionMode;

	// Zero movement
	PawnOwner.ZeroMovementVariables();

	Super.SpecialMoveEnded(PrevMove, NextMove);
}


defaultproperties
{
	bLockPawnRotation=TRUE
	bDisableMovement=TRUE
	bDisableAI=TRUE
	bRestoreMovementAfterMove=FALSE
	BS_Impact=(Stance=((Slot=BS_FullBody,AnimName="hit_reaction_wall")))
	BS_Outro=(Stance=((Slot=BS_FullBody,AnimName="dazed_end")))
}
