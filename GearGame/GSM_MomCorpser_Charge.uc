
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_MomCorpser_Charge extends GearSpecialMove;

/** Desired Rotation to use when charging. */
var	Rotator	DesiredChargeRot;
/** If TRUE, perform rotation interpolation */
var	bool bInterpolateRotation;
/** Time given for rotation interpolation */
var	float RotationInterpolationTime;

var() GearPawn.BodyStance BS_PlayedStance, BS_Idle2ChargeFd, BS_Idle2ChargeBd, BS_Idle2ChargeLt, BS_Idle2ChargeRt;

/** Cache the reference to the pawn */
var GearPawn_LocustMomCorpserBase CorpserPawn;


function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

	PawnOwner.ZeroMovementVariables();
	bInterpolateRotation = FALSE;

	// Cache the pawn
	CorpserPawn = GearPawn_LocustMomCorpserBase(PawnOwner);

	// If we have a direction set, start charging right away!
	if (CorpserPawn != None &&
		CorpserPawn.HasValidDesiredRootRotation())
	{
		StartCharging();
	}
}

/** Do intro and notify pawn */
simulated function StartCharging()
{
	// Let the pawn know we are charging so it can perform any effect or sounds necessary
	if (CorpserPawn != None)
	{
		CorpserPawn.SetTimer( 0.25f, TRUE, nameof(ChargeWarnAI), self );

		CorpserPawn.StartedChargingNotify();
		if (!CorpserPawn.bIsRampaging)
		{
			PlayChargeIntro();
		}
		else
		{
			DesiredChargeRot.Yaw = NormalizeRotAxis(CorpserPawn.DesiredYawRootRotation);
			PawnOwner.SetDesiredRotation(DesiredChargeRot, TRUE, TRUE);
			StartRootMotion();
			TurnAnimationEnded();
			ChargeStartFullWeight();
		}
	}
}

/** Get Animation Play Rate */
simulated function float GetAnimPlayRate()
{
	return SpeedModifier;
}

/** Plays the charge scream intro before chargine */
function PlayChargeIntro()
{
	local float DeltaYaw, AnimRate;

	// Convert Yaw into a full rotator
	DesiredChargeRot.Yaw = NormalizeRotAxis(CorpserPawn.DesiredYawRootRotation);

	// How much we have to turn to face proper direction.
	DeltaYaw = NormalizeRotAxis(DesiredChargeRot.Yaw - PawnOwner.Rotation.Yaw);

	// 	`log(GetFuncName() @ PawnOwner.WorldInfo.TimeSeconds );
	// 	`log("DeltaYaw:" @ DeltaYaw @ "DesiredChargeRot:" @ DesiredChargeRot.Yaw @ "PawnRot:" @ PawnOwner.Rotation.Yaw);

	// Play proper turn animation depending on where we're turning.

	// Forward -30d + 30d
	if( DeltaYaw >= -5461 && DeltaYaw < 5461 )
	{
		BS_PlayedStance = BS_Idle2ChargeFd;
		PawnOwner.SetDesiredRotation( DesiredChargeRot, TRUE );
		//`log("Play Turn Fd" @ IntroAnimTime );
	}
	// Right, +45d, +135d
	else if( DeltaYaw >= 5461 && DeltaYaw < 24576 )
	{
		BS_PlayedStance = BS_Idle2ChargeRt;
		//`log("Play Turn Rt" @ IntroAnimTime );
	}
	// Left, -135d, -45d
	else if( DeltaYaw >= -24576 && DeltaYaw < -5461 )
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

	// Have animation forward root motion.
	PawnOwner.BS_SetRootBoneAxisOptions(BS_PlayedStance, RBA_Translate, RBA_Translate);

	// Discard rotation from root bone.
	PawnOwner.BS_SetRootRotationOption(BS_PlayedStance, RRO_Extract);

	ChargeStartFullWeight();

	StartRootMotion();

	// FIGURE OUT WHEN TO END SPECIAL MOVE 
	// SET BOTH RootMotionMode & RootMotionRotationMOde back to Pawn.default.Mesh.*
}

/** The the root motion going */
simulated function StartRootMotion()
{
	// Turn on Root motion on mesh. Use RMM_Accel, to drive full movement.
	PawnOwner.Mesh.RootMotionMode = RMM_Accel;
	PawnOwner.Mesh.RootMotionRotationMode = RMRM_RotateActor;
}

simulated function ChargeStartFullWeight()
{
	// This along with bPreciseDestination (set in GearAI_MomCorpser) will push the pawn at full speed.
	// Do this when the charge start animation has full weight, so the movementnode is not affected before the animation starts.
	PawnOwner.bForceMaxAccel = TRUE;
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

/** Charge intro had ended so send the corpser into the run */
function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	TurnAnimationEnded();
}

/** Handles the animation ending */
function TurnAnimationEnded()
{
	local GearAI_MomCorpser CorpserController;

	CorpserController = GearAI_MomCorpser(PawnOwner.Controller);
	if (CorpserController != None)
	{
		CorpserController.ChargeStartedNotify();
	}

	// Turn off rotation interpolation if it didn't finish
	bInterpolateRotation = false;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	// Turn off Root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(BS_PlayedStance, RBA_Discard, RBA_Discard, RBA_Discard);
	PawnOwner.BS_SetRootRotationOption(BS_PlayedStance, RRO_Discard);

	// Turn off anim end notify
	PawnOwner.BS_SetAnimEndNotify(BS_PlayedStance, FALSE);

	//`log(GetFuncName() @ GearPawnOwner.WorldInfo.TimeSeconds );

	// Restore default root motion mode
	PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;
	PawnOwner.Mesh.RootMotionRotationMode = PawnOwner.default.Mesh.RootMotionRotationMode;
	PawnOwner.bForceMaxAccel = FALSE;

	PawnOwner.LockDesiredRotation( FALSE );
	PawnOwner.SetDesiredRotation( PawnOwner.Rotation );
	PawnOwner.ZeroMovementVariables();

	PawnOwner.ClearTimer( nameof(ChargeWarnAI), self );

	// Stop transition instantly
	if( PawnOwner.BS_IsPlaying(BS_PlayedStance) )
	{
		`warn("aborting charge start animation");
		PawnOwner.BS_Stop(BS_PlayedStance, 0.4f);
	}
}

simulated function Tick( float DeltaTime )
{
	local int YawDiff; 

	Super.Tick( DeltaTime );

	if( !PawnOwner.IsDesiredRotationLocked() )
	{
		YawDiff = NormalizeRotAxis(PawnOwner.Rotation.Yaw - DesiredChargeRot.Yaw);
		if( Abs(YawDiff) < 910 )
		{
			PawnOwner.Mesh.RootMotionRotationMode = PawnOwner.default.Mesh.RootMotionRotationMode;
			PawnOwner.SetDesiredRotation( DesiredChargeRot, TRUE );
		}
	}
}

function ChargeWarnAI()
{
	CorpserPawn.WarnAttackIncoming( CorpserPawn.Location + Vector(CorpserPawn.Rotation) * 1024.f );
}

defaultproperties
{
	bRestoreMovementAfterMove=FALSE

	BS_Idle2ChargeFd=(Stance=((Slot=BS_FullBody,AnimName="Idle2Charge_Fwd")))
	BS_Idle2ChargeBd=(Stance=((Slot=BS_FullBody,AnimName="Idle2Charge_Bwd")))
	BS_Idle2ChargeLt=(Stance=((Slot=BS_FullBody,AnimName="Idle2Charge_Left")))
	BS_Idle2ChargeRt=(Stance=((Slot=BS_FullBody,AnimName="Idle2Charge_Right")))
}