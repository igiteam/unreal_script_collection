
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Berserker_Charge extends GearSpecialMove;

/** Desired Rotation to use when charging. */
var	Rotator	DesiredChargeRot;
/** If TRUE, perform rotation interpolation */
var	bool	bInterpolateRotation;
/** Time given for rotation interpolation */
var	float	RotationInterpolationTime;

var() GearPawn.BodyStance BS_PlayedStance, BS_Idle2ChargeFd, BS_Idle2ChargeBd, BS_Idle2ChargeLt, BS_Idle2ChargeRt;

/** Cache the reference to the berserker pawn */
var GearPawn_LocustBerserkerBase BerserkerPawn;

/** The time we started this animation (used so we can loop part of the animation */
var float AnimationStartTime;

/** Times we are to loop the roaring back to per animation */
var const float LoopStartTimeForward;
var const float LoopStartTimeBackward;
var const float LoopStartTimeLeft;
var const float LoopStartTimeRight;

/** Whether we are restarted the charge or not */
var bool bRestartCharge;

/**
 * Can the special move be chained after the current one finishes?
 */
function bool CanChainMove(ESpecialMove NextMove)
{
	return (NextMove == SM_Berserker_ChargeMantle);
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

	PawnOwner.ZeroMovementVariables();
	bInterpolateRotation = FALSE;

	//`log(GetFuncName() @ GearPawnOwner.WorldInfo.TimeSeconds );

	// Cache the pawn
	BerserkerPawn = GearPawn_LocustBerserkerBase(PawnOwner);

	if (BerserkerPawn != None)
	{
		BerserkerPawn.ChargeBreakCount = BerserkerPawn.default.ChargeBreakCount;
		BerserkerPawn.ChargeHitList.Length = 0;
	}

	bRestartCharge = (PawnOwner.SpecialMoveFlags > 0);

	if (bRestartCharge)
	{
		RestartCharge();
	}
	// If we have a direction set, start charging right away!
	else if (BerserkerPawn != None &&
			 BerserkerPawn.HasValidDesiredRootRotation())
	{
		StartCharging();
	}
}


function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	//`log(GetFuncName() @ GearPawnOwner.WorldInfo.TimeSeconds );

	PawnOwner.bForceMaxAccel = FALSE;
	PawnOwner.ClearTimer(nameof(ChargeStartFullWeight), Self);
	PawnOwner.ClearTimer(nameof(ChargeWarnAI), self);

	// Stop transition instantly
	if (PawnOwner.BS_IsPlaying(BS_PlayedStance))
	{
		PawnOwner.BS_Stop(BS_PlayedStance, 0.4f);
		CleanupStartAnimation();
	}
	else if (bRestartCharge)
	{
		CleanupStartAnimation();
	}
}

/** Restart the charging after mantling most likely */
simulated function RestartCharge()
{
	// Activate HeadLook Control
	PawnOwner.HeadTrackSkelControl.SetSkelControlActive(TRUE);
	// Turn on Root motion on mesh. Use RMM_Accel, to drive full movement.
	PawnOwner.Mesh.RootMotionMode = RMM_Accel;
	PawnOwner.Mesh.RootMotionRotationMode = RMRM_RotateActor;
	PawnOwner.bForceMaxAccel = TRUE;
}

/** Cleanup the animations that was playing */
simulated function CleanupStartAnimation()
{
	// Turn off HeadLook Control
	PawnOwner.HeadTrackSkelControl.SetSkelControlActive(FALSE);

	// Turn off rotation interpolation if it didn't finish
	bInterpolateRotation = FALSE;

	// Restore default root motion mode
	PawnOwner.Mesh.RootMotionMode = PawnOwner.Mesh.default.RootMotionMode;

	// Turn off Root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(BS_PlayedStance, RBA_Discard, RBA_Discard, RBA_Discard);
	PawnOwner.BS_SetRootRotationOption(BS_PlayedStance, RRO_Discard);
	// Turn off anim end notify
	PawnOwner.BS_SetAnimEndNotify(BS_PlayedStance, FALSE);

	// How far we are from the end of the animation.
	// 	TimeAdjustment = SeqNode.AnimSeq.SequenceLength - SeqNode.CurrentTime - ExcessTime;
	// 	`log(GetFuncName() @ PawnOwner.WorldInfo.TimeSeconds @ "TimeAdjustment:" @ TimeAdjustment @ "PlayedTime:" @ PlayedTime @ "ExcessTime:" @ ExcessTime);
	// Position our charge animation well, taking into account excess time for seamless transition.
	// 	BerserkerPawn.ChargeNode.SetPosition(BerserkerPawn.ChargeNode.AnimSeq.SequenceLength - TimeAdjustment * BerserkerPawn.ChargeNode.GetGlobalPlayRate(), false);

	// And since the charge is sync'd, set the whole group to that position.
	// 	PawnOwner.AnimTreeRootNode.ForceGroupRelativePosition(BerserkerPawn.ChargeNode.SynchGroupName, BerserkerPawn.ChargeNode.GetGroupRelativePosition());
}

simulated function StartCharging()
{
	PlayChargeIntro();

	// Let the pawn know we are charging so it can perform any effect or sounds necessary
	if (BerserkerPawn != None)
	{
 		BerserkerPawn.StartedChargingNotify();

		// Warn nearby enemy AI of the attack
		BerserkerPawn.WarnAttackIncoming(BerserkerPawn.Location + Vector(BerserkerPawn.Rotation) * 100.f);
	}
}

/** Get Animation Play Rate */
simulated function float GetAnimPlayRate()
{
	local float Modifier;
	local GearPawn_LocustBerserkerLambentBase LambentBerserker;

	Modifier = SpeedModifier;

	// When heated up, animations play faster
	if (BerserkerPawn != None &&
		BerserkerPawn.bVulnerableToDamage)
	{
		Modifier = BerserkerPawn.HeatedUpSpeedScale * SpeedModifier;

		LambentBerserker = GearPawn_LocustBerserkerLambentBase(BerserkerPawn);
		if (LambentBerserker != None &&
			LambentBerserker.CurrentPhase < LambentBerserker.PhaseInfo.length)
		{
			Modifier *= LambentBerserker.PhaseInfo[LambentBerserker.CurrentPhase].AnimSpeed;
		}
	}

	return Modifier;
}

simulated function PlayChargeIntro()
{
	local float DeltaYaw, AnimRate;

	// Convert Yaw into a full rotator
	DesiredChargeRot.Yaw = NormalizeRotAxis(BerserkerPawn.DesiredYawRootRotation);

	// Activate HeadLook Control
	PawnOwner.HeadTrackSkelControl.SetSkelControlActive(TRUE);
	PawnOwner.HeadTrackSkelControl.TargetLocation = PawnOwner.Location + Vector(DesiredChargeRot) * 65536.f;
	PawnOwner.HeadTrackSkelControl.DesiredTargetLocation = PawnOwner.HeadTrackSkelControl.TargetLocation;

	// How much we have to turn to face proper direction.
	DeltaYaw = NormalizeRotAxis(DesiredChargeRot.Yaw - PawnOwner.Rotation.Yaw);

// 	`log(GetFuncName() @ PawnOwner.WorldInfo.TimeSeconds );
// 	`log("DeltaYaw:" @ DeltaYaw @ "DesiredChargeRot:" @ DesiredChargeRot.Yaw @ "PawnRot:" @ PawnOwner.Rotation.Yaw);

	// Play proper turn animation depending on where we're turning.

	// Forward -45d + 45d
	if( DeltaYaw >= -16384 && DeltaYaw < 16384 )
	{
		BS_PlayedStance = BS_Idle2ChargeFd;
		//`log("Play Turn Fd" @ IntroAnimTime );
	}
	// Right, +45d, +135d
	else if( DeltaYaw >= 16384 && DeltaYaw < 49152 )
	{
		BS_PlayedStance = BS_Idle2ChargeRt;
		//`log("Play Turn Rt" @ IntroAnimTime );
	}
	// Left, -135d, -45d
	else if( DeltaYaw >= -49152 && DeltaYaw < -16384)
	{
		BS_PlayedStance = BS_Idle2ChargeLt;
		//`log("Play Turn Lt" @ IntroAnimTime );
	}
	// Back, +135d, -135d
	else
	{
		BS_PlayedStance = BS_Idle2ChargeBd;
		//`log("Play Turn Bd" @ IntroAnimTime );
	}

	AnimRate = GetAnimPlayRate();
	PawnOwner.BS_Play(BS_PlayedStance, AnimRate, 0.3f/AnimRate, 0.3f/AnimRate, FALSE, TRUE);
	// Get notification when anim ends, so we can properly chain the run_fwd loop.
	PawnOwner.BS_SetAnimEndNotify(BS_PlayedStance, TRUE);
	PawnOwner.SetTimer(0.2f/AnimRate, FALSE, nameof(ChargeStartFullWeight), Self);

	// Keep track of when this animation started
	AnimationStartTime = PawnOwner.WorldInfo.TimeSeconds;

	// Have animation forward root motion.
	PawnOwner.BS_SetRootBoneAxisOptions(BS_PlayedStance, RBA_Translate, RBA_Translate);
	// Turn on Root motion on mesh. Use RMM_Accel, to drive full movement.
	PawnOwner.Mesh.RootMotionMode = RMM_Accel;

	// Discard rotation from root bone.
	PawnOwner.BS_SetRootRotationOption(BS_PlayedStance, RRO_Extract);
	PawnOwner.Mesh.RootMotionRotationMode = RMRM_RotateActor;
}

/** Handle the looping within this animation to give the player time to hurt the berserker */
simulated function HandleChargeLoop()
{
	local float TotalAnimatingTime;
	local float NewAnimTime;
	local GearPawn_LocustBerserkerLambentBase LambentPawn;

	// We only want to do this looping for the lambent berserker
	LambentPawn = GearPawn_LocustBerserkerLambentBase(BerserkerPawn);
	if (LambentPawn != None &&
		LambentPawn.CurrentPhase < LambentPawn.PhaseInfo.Length &&
		LambentPawn.PhaseInfo[LambentPawn.CurrentPhase].ChargeVulnerableTime > 0.0f)
	{
		switch (BS_PlayedStance.Stance[0].AnimName)
		{
			case BS_Idle2ChargeFd.Stance[0].AnimName:
				NewAnimTime = LoopStartTimeForward;
				break;
			case BS_Idle2ChargeBd.Stance[0].AnimName:
				NewAnimTime = LoopStartTimeBackward;
				break;
			case BS_Idle2ChargeLt.Stance[0].AnimName:
				NewAnimTime = LoopStartTimeLeft;
				break;
			case BS_Idle2ChargeRt.Stance[0].AnimName:
				NewAnimTime = LoopStartTimeRight;
				break;
			default:
				return;
		}

		TotalAnimatingTime = PawnOwner.WorldInfo.TimeSeconds - AnimationStartTime;
		if (TotalAnimatingTime < LambentPawn.PhaseInfo[LambentPawn.CurrentPhase].ChargeVulnerableTime)
		{
			PawnOwner.BS_SetPosition(BS_PlayedStance, NewAnimTime);
			PawnOwner.BS_SetPlayRate(BS_PlayedStance, 0.5f);
		}
		else
		{
			PawnOwner.BS_SetPlayRate(BS_PlayedStance, GetAnimPlayRate());
		}
	}
}

function ChargeStartFullWeight()
{
	// This along with bPreciseDestination (set in GearAI_Berserker) will push the pawn at full speed.
	// Do this when the charge start animation has full weight, so the movementnode is not affected before the animation starts.
	PawnOwner.bForceMaxAccel = TRUE;

	// Rotate Pawn.
// 	PawnOwner.SetDesiredRotation(DesiredChargeRot, TRUE, TRUE);
// 	if( AIOwner != None )
// 	{
// 		AIOwner.SetFocalPoint(PawnOwner.Location + vector(DesiredChargeRot) * 16384, TRUE);
// 	}
}

/** Notification forwarded by GearAnimNotify_SpecialMove */
simulated function AnimNotify(AnimNodeSequence SeqNode, GearAnimNotify_SpecialMove NotifyObject)
{
	local int i, StartNotifyIndex, EndNotifyIndex;
	local GearAnimNotify_SpecialMove SMNotify;
	local bool bSuccessful;

// 	`log(GetFuncName() @ PawnOwner.WorldInfo.TimeSeconds @ NotifyObject.Info );

	if( NotifyObject.Info == 'RotStart' )
	{
		bSuccessful = FALSE;
		bInterpolateRotation = TRUE;
		RotationInterpolationTime = 0.f;

		StartNotifyIndex = -1;
		EndNotifyIndex = -1;

		if( SeqNode != None && SeqNode.AnimSeq != None )
		{
			for(i=0; i<SeqNode.AnimSeq.Notifies.Length; i++)
			{
				SMNotify = GearAnimNotify_SpecialMove(SeqNode.AnimSeq.Notifies[i].Notify);

				if( SMNotify != None )
				{
					if( SMNotify.Info == 'RotStart' )
					{
						StartNotifyIndex = i;
					}
					else if( SMNotify.Info == 'RotEnd' )
					{
						EndNotifyIndex = i;
					}
				}

				// If we're done, stop searching
				if( StartNotifyIndex != -1 && EndNotifyIndex != -1 )
				{
					break;
				}
			}

			if( StartNotifyIndex != -1 && EndNotifyIndex != -1 )
			{
				RotationInterpolationTime = SeqNode.AnimSeq.Notifies[EndNotifyIndex].Time - SeqNode.AnimSeq.Notifies[StartNotifyIndex].Time;
				RotationInterpolationTime = RotationInterpolationTime / (SeqNode.Rate * SeqNode.AnimSeq.RateScale);
// 				`log("SetDesiredRotation DesiredChargeRot:" @ DesiredChargeRot @ "RotationInterpolationTime:" @ RotationInterpolationTime);
				PawnOwner.SetDesiredRotation(DesiredChargeRot, TRUE, TRUE, RotationInterpolationTime);
				bSuccessful = TRUE;
			}
		}
		// If failed, still rotate pawn, and log a warning.
		if( !bSuccessful )
		{
			`warn(GetFuncName() @ PawnOwner.WorldInfo.TimeSeconds @ "Couldn't locate markers to rotate pawn in sync w/ animations");
			PawnOwner.SetDesiredRotation(DesiredChargeRot, TRUE, TRUE);
		}
	}
}


function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	local GearAI_BerserkerBase BerserkerController;

	BerserkerController = GearAI_BerserkerBase(PawnOwner.Controller);
	if( BerserkerController != None )
	{
		BerserkerController.ChargeStartedNotify();
		BerserkerPawn.PlayChargeTakeOffEffect(PawnOwner.Location, Normal(PawnOwner.Location - PawnOwner.HeadTrackSkelControl.TargetLocation) );
	}

	BerserkerPawn.SetTimer(0.17f, TRUE, nameof(ChargeWarnAI), self);

	CleanupStartAnimation();
}

simulated function PreProcessInput(GearPlayerInput Input)
{
	// force running forwards
	Input.aBaseY	= 1.f;

	// strafe becomes turning
	Input.aTurn		= Input.aStrafe * 0.33f;
	Input.aStrafe	= 0.f;
}

/** Warn enemy AI in front of us that the charge is coming */
function ChargeWarnAI()
{
	BerserkerPawn.WarnAttackIncoming(BerserkerPawn.Location + Vector(BerserkerPawn.Rotation) * 600.f);
}

defaultproperties
{
	bRestoreMovementAfterMove=FALSE

	BS_Idle2ChargeFd=(Stance=((Slot=BS_FullBody,AnimName="idle2run_fwd")))
	BS_Idle2ChargeBd=(Stance=((Slot=BS_FullBody,AnimName="idle2run_back")))
	BS_Idle2ChargeLt=(Stance=((Slot=BS_FullBody,AnimName="idle2run_lt")))
	BS_Idle2ChargeRt=(Stance=((Slot=BS_FullBody,AnimName="idle2run_rt")))

	LoopStartTimeForward=0.4f
	LoopStartTimeBackward=0.6f
	LoopStartTimeLeft=0.5f
	LoopStartTimeRight=0.5f
}
