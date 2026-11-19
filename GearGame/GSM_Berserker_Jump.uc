
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Berserker_Jump extends GearSpecialMove;

var() GearPawn.BodyStance BS_JumpUpTelegraph, BS_JumpUpStart, BS_JumpUpLoop, BS_JumpDownLoop, BS_JumpDownLand;

/** Cache the reference to the berserker pawn */
var GearPawn_LocustBerserkerLambentBase BerserkerPawn;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

	// Cache the pawn
	BerserkerPawn = GearPawn_LocustBerserkerLambentBase(PawnOwner);

	// Special move flag having 1 in it means to skip the telegraph!
	if (PawnOwner.SpecialMoveFlags > 0)
	{
		StartJumping();
	}
	else
	{
		StartTelegraph();
	}

	GearAI_BerserkerLambent(BerserkerPawn.Controller).bForceJumpAttack = false;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	PawnOwner.bForceMaxAccel = FALSE;

	if( PawnOwner.IsTimerActive(nameof(self.JumpLandingFinished), self) )
	{
		JumpLandingFinished();
		PawnOwner.ClearTimer(nameof(self.JumpLandingFinished), self);
	}

	// Make sure all the animations started here are stopped.
	PawnOwner.BS_Stop(BS_JumpUpTelegraph, 0.3f);
	PawnOwner.BS_Stop(BS_JumpUpStart, 0.3f);
	PawnOwner.BS_Stop(BS_JumpUpLoop, 0.3f);
	PawnOwner.BS_Stop(BS_JumpDownLoop, 0.3f);
	PawnOwner.BS_Stop(BS_JumpDownLand, 0.3f);

	// Force the chest to close on the lambent (if the anim gets aborted we need to make sure the chest closes)
	if (BerserkerPawn != None)
	{
		BerserkerPawn.ForceChestClose();
	}

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

/** Get Animation Play Rate */
simulated function float GetAnimPlayRate(bool bShouldUsePhaseModifier)
{
	local float Modifier;

	Modifier = SpeedModifier;

	// When heated up, animations play faster
	if (BerserkerPawn != None &&
		BerserkerPawn.bVulnerableToDamage)
	{
		Modifier = BerserkerPawn.HeatedUpSpeedScale * SpeedModifier;
// 		if (bShouldUsePhaseModifier &&
// 			BerserkerPawn.CurrentPhase < BerserkerPawn.PhaseInfo.length)
// 		{
// 			Modifier *= BerserkerPawn.PhaseInfo[BerserkerPawn.CurrentPhase].AnimSpeed;
// 		}
	}

	return Modifier;
}

/** Plays the telegraph animation first and then will call StartJumping */
simulated function StartTelegraph()
{
	local float	AnimRate;
	local float AnimTime;

	// This along with bPreciseDestination (set in GearAI_Berserker) will push the pawn at full speed.
	PawnOwner.bForceMaxAccel = TRUE;

	AnimRate = GetAnimPlayRate(true);
	AnimTime = PawnOwner.BS_Play(BS_JumpUpTelegraph, AnimRate, 0.3f/AnimRate, 0.f, FALSE, TRUE);

	// Have animation forward root motion.
	PawnOwner.BS_SetRootBoneAxisOptions(BS_JumpUpTelegraph, RBA_Translate, RBA_Translate);

	// Turn on Root motion on mesh. Use RMM_Accel, to drive full movement.
	PawnOwner.Mesh.RootMotionMode = RMM_Accel;

	// Set timer for starting the jump
	PawnOwner.SetTimer(AnimTime, false, nameof(FinishedTelegraph), self);
}

/** Telegraph finished and we're ready for the start */
simulated function FinishedTelegraph()
{
	// Stop transition instantly
	PawnOwner.BS_Stop(BS_JumpUpTelegraph);
	// Start the jump normally
	StartJumping();
}

/** Plays the jump start anim and sets a timer to start playing the jump loop anim */
simulated function StartJumping()
{
	local float	AnimRate;

	// This along with bPreciseDestination (set in GearAI_Berserker) will push the pawn at full speed.
	PawnOwner.bForceMaxAccel = TRUE;

	AnimRate = GetAnimPlayRate(true);
	PawnOwner.BS_Play(BS_JumpUpStart, AnimRate, 0.3f/AnimRate, 0.f, FALSE, TRUE);
	PawnOwner.BS_SetAnimEndNotify(BS_JumpUpStart, TRUE);

	// Have animation forward root motion.
	PawnOwner.BS_SetRootBoneAxisOptions(BS_JumpUpStart, RBA_Translate, RBA_Translate);

	// Turn on Root motion on mesh. Use RMM_Accel, to drive full movement.
	PawnOwner.Mesh.RootMotionMode = RMM_Accel;

	PawnOwner.SetTimer(0.5f, FALSE, nameof(JumpWarnAI), self);
}

function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	local float OriginalRate, JumpTime;

	if (PawnOwner.BS_SeqNodeBelongsTo(SeqNode, BS_JumpUpStart))
	{
		// End of start anim
		OriginalRate = PawnOwner.BS_GetPlayRate(BS_JumpUpStart);
		// Restore default root motion mode
		PawnOwner.Mesh.RootMotionMode = PawnOwner.Mesh.default.RootMotionMode;
		// Turn off Root motion on animation node
		PawnOwner.BS_SetRootBoneAxisOptions(BS_JumpUpStart, RBA_Discard, RBA_Discard, RBA_Discard);
		// Stop transition instantly
		PawnOwner.BS_Stop(BS_JumpUpStart);

		// Do the jump
		GearPawn_LocustBerserkerLambentBase(PawnOwner).DoJumpAttack();

		// Estimate when Pawn will hit the Apex of the jump, and scale animation by that amount.
		JumpTime = Abs(PawnOwner.Velocity.Z / PawnOwner.GetGravityZ());
		PawnOwner.BS_PlayByDuration(BS_JumpUpLoop, JumpTime, 0.f, -1.f);
		PawnOwner.BS_SetPosition(BS_JumpUpLoop, ExcessTime * OriginalRate);
		PawnOwner.BS_SetAnimEndNotify(BS_JumpUpLoop, TRUE);
	}
	else if( PawnOwner.BS_SeqNodeBelongsTo(SeqNode, BS_JumpUpLoop) )
	{
		// End of jumping up animation
		OriginalRate = PawnOwner.BS_GetPlayRate(BS_JumpUpLoop);
		PawnOwner.BS_Stop(BS_JumpUpLoop, 0.f);
		PawnOwner.BS_Play(BS_JumpDownLoop, OriginalRate, 0.f, -1.f);
		PawnOwner.BS_SetPosition(BS_JumpDownLoop, ExcessTime * OriginalRate);

		// Let the berserker know she is falling
		GearPawn_LocustBerserkerLambentBase(PawnOwner).StartDescendingFromJumpNotify();
	}
}

function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);

	// Ramp down play rate.
	if( PawnOwner.BS_IsPlaying(BS_JumpDownLoop) )
	{
		PawnOwner.BS_ScalePlayRate(BS_JumpDownLoop, 0.9f);
	}
}

/** Called from the pawn when the berserker has landed */
simulated function JumpLanding()
{
	local float AnimRate;
	local float AnimTime;

	PawnOwner.BS_Stop(BS_JumpDownLoop, 0.2f);

	AnimRate = GetAnimPlayRate(true);
	AnimTime = PawnOwner.BS_Play(BS_JumpDownLand, AnimRate, 0.2f, 0.3f, FALSE, TRUE);
	PawnOwner.SetTimer(AnimTime, FALSE, nameof(self.JumpLandingFinished), self);
	// Have animation forward root motion.
	PawnOwner.BS_SetRootBoneAxisOptions(BS_JumpDownLand, RBA_Translate, RBA_Translate);

	// Turn on Root motion on mesh. Use RMM_Accel, to drive full movement.
	PawnOwner.Mesh.RootMotionMode = RMM_Accel;
}

/** Called when the landing anim is finished playing */
simulated function JumpLandingFinished()
{
	// Restore default root motion mode
	PawnOwner.Mesh.RootMotionMode = PawnOwner.Mesh.default.RootMotionMode;

	// Turn off Root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(BS_JumpDownLand, RBA_Discard, RBA_Discard, RBA_Discard);

	PawnOwner.BS_Stop(BS_JumpDownLand, 0.3f);
	PawnOwner.EndSpecialMove(SM_Berserker_Jump);
}

/** Warn enemy AI in front of us that the jump attack is coming */
function JumpWarnAI()
{
	BerserkerPawn.WarnAttackIncoming(BerserkerPawn.JumpTargetLocation);
}

defaultproperties
{
	bLockPawnRotation=TRUE
	bDisableAI=TRUE
	bRestoreMovementAfterMove=FALSE

	BS_JumpUpTelegraph=(Stance=((Slot=BS_FullBody,AnimName="jump_up_intro")))
	BS_JumpUpStart=(Stance=((Slot=BS_FullBody,AnimName="Jump_Up_Start")))
	BS_JumpUpLoop=(Stance=((Slot=BS_FullBody,AnimName="Jump_Up")))
	BS_JumpDownLoop=(Stance=((Slot=BS_FullBody,AnimName="Jump_Fall_Loop")))
	BS_JumpDownLand=(Stance=((Slot=BS_FullBody,AnimName="Jump_Fall_Land")))
}
