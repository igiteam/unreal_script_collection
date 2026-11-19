
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Berserker_Slide extends GearSpecialMove;

var()	GearPawn.BodyStance	BS_Animation;

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

	// Play Slide animation
	PawnOwner.BS_Play(BS_Animation, AnimRate, 0.2f/AnimRate, 0.3f/AnimRate, FALSE, TRUE);

	// Enable end of animation notification. This is going to call SpecialMoveEnded()
	PawnOwner.BS_SetAnimEndNotify(BS_Animation, TRUE);

	// Have animation forward root motion.
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Animation, RBA_Translate, RBA_Translate, RBA_Translate);
	// Turn on Root motion on mesh. Use RMM_Accel, to drive full movement.
	PawnOwner.Mesh.RootMotionMode = RMM_Accel;

	// Use root rotation to rotate the actor.
	PawnOwner.BS_SetRootRotationOption(BS_Animation, RRO_Extract);
	PawnOwner.Mesh.RootMotionRotationMode = RMRM_RotateActor;

	// Notify the berserker that she is sliding past her target
	GearPawn_LocustBerserkerBase(PawnOwner).ChargingPastTargetNotify();

	// Warn nearby enemy AI of the attack
	GearPawn_LocustBerserkerBase(PawnOwner).WarnAttackIncoming(PawnOwner.Location + Vector(PawnOwner.Rotation) * 256.f);
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	// Reset root rotation
	PawnOwner.BS_SetRootRotationOption(BS_Animation, RRO_Discard);
	PawnOwner.Mesh.RootMotionRotationMode = RMRM_Ignore;

	// Disable end of animation notification.
	PawnOwner.BS_SetAnimEndNotify(BS_Animation, FALSE);

	// Turn off Root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Animation, RBA_Discard, RBA_Discard, RBA_Discard);

	// Restore default root motion mode
	PawnOwner.Mesh.OldPendingRMM = PawnOwner.Mesh.RootMotionMode;
	PawnOwner.Mesh.PendingRMM = PawnOwner.Mesh.default.RootMotionMode;
// 	PawnOwner.Mesh.RootMotionMode = PawnOwner.Mesh.default.RootMotionMode;

	// Stop animation if it's still playing
	PawnOwner.BS_Stop(BS_Animation, 0.3f);
	PawnOwner.ZeroMovementVariables();

	Super.SpecialMoveEnded(PrevMove, NextMove);

	// Let the pawn know we are no longer charging so it can perform any effects or sounds necessary
	GearPawn_LocustBerserkerBase(PawnOwner).StoppedChargingNotify();
}

defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="Charge_Miss")))
	bRestoreMovementAfterMove=FALSE
	bLockPawnRotation=TRUE
	bDisableAI=TRUE
}