/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_StabMantle extends NanoSpecialMove;

/** Cached reference to the nanoperchpoint the pawn is based on */
var NanoPerchPoint  PerchPoint;

/** Whether or not ApproachingStabTarget() has attached us to the mantle target yet */
var transient bool  bIsDoingMantleUp;

var() float			PrepareStabMantleAnimRate;

var protected SoundCue AttachedToTargetCue;

function bool CanChainMove( Name NextMove )
{
	if( NextMove == 'NSM_PerchOnPoint' )
	{
		return TRUE;
	}
	return FALSE;
}

function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	local NanoSkill_Jump JumpSkill;

	Super.SpecialMoveStarted( bForced, PrevMove );

	JumpSkill = MyNP.GetSkill(class'NanoSkill_Jump');
	if( JumpSkill != None )
	{
		JumpSkill.DeactivateSkill();
	}

	MyNP.SetPhysics(PHYS_Falling);
	MyNP.bIsSwordDashing = TRUE;
	MyNP.bIsDoingStabMantle = TRUE;

	bIsDoingMantleUp = FALSE;

	// Notify Kismet
	MyNP.TriggerEventClass(class'SeqEvt_NanoActionPerformed', MyNP, 14);
}

function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	local NanoInterface_StabMantle NISM;
	local NanoPC NPC;

	Super.SpecialMoveEnded( PrevMove, NextMove );

	if( MyNP.IsAttachedToPerch() )
	{
		MyNP.SetCollision(TRUE,TRUE,FALSE);
		MyNP.bStabMantling = FALSE;

		MyNP.bIsSwordDashing = FALSE;
		MyNP.bIsDoingStabMantle = FALSE;
		MyNP.bPreparingStabMantle = FALSE;

		MyNP.Mesh.RootMotionMode = RMM_Ignore;
		MyNP.FullBodySlot.SetRootBoneAxisOption(RBA_Discard, RBA_Discard, RBA_Discard);
		MyNP.FullBodySlot.StopCustomAnim( 0.1f );
		MyNP.FullBodySlot.SetRootBoneRotationOption(RRO_Default, RRO_Default, RRO_Default);

		MyNP.FallingFullBodySlot.StopCustomAnim( 0.1f );

		MyNP.StartFallingTime = MyNP.WorldInfo.TimeSeconds - 2.1; // DEMO_HACK

		NISM = NanoInterface_StabMantle(MyNP.Base);
		if( NISM != None )
		{
			NISM.NotifyFinishedStabMantle( MyNP );
		}
	}

	MyNP.UpdatePerchMode();

	NPC = NanoPC(MyNP.Controller);
	if( NPC != None )
	{
		NPC.SetTargetedActor(None);
	}
}

simulated function Tick( float DeltaTime )
{
	local float DistToTarget;
	local Rotator ClampedRot;

	Super.Tick( DeltaTime );

	// Make sure every client gets its chance to finish the Approach, and call the mounting animations
	if( MyNP.bIsDoingStabMantle && !bIsDoingMantleUp )
	{
		DistToTarget = VSize2D(MyNP.InteractionActor.Location - MyNP.Location);
		ApproachingStabTarget(DistToTarget);
	}

	
	if( MyNP.bStabMantling && (NanoVehicle_ElevatorBase(MyNP.Base) != None) )
	{
 		if( MyNP.GetTimerCount( nameof(ReleaseStabMantle), self ) > 1.25f )
 		{
 			// After we've released the sword, blend to the final rotation
 			MyNP.SetRelativeRotation( RInterpTo(MyNP.Rotation, MyNP.Base.Rotation, DeltaTime, 20000, TRUE) - MyNP.Base.Rotation);
 		}
 		else
 		{
 			// Otherwise, clamp the rotation so that we don't attach at too crazy of an angle
 			ClampedRot = MyNP.Rotation;
 			ClampedRot.Yaw = ClampRotAxisFromBase(ClampedRot.Yaw, MyNP.Base.Rotation.Yaw, 8192);

 			MyNP.SetRelativeRotation(ClampedRot - MyNP.Base.Rotation);
 		}
	}
}

/** Called once a player is close to the stab mantle target */
simulated function ApproachingStabTarget( float DistToTarget )
{
	local vector FaceDir, AttachOffset, AttachPos, TargetX, TargetY, TargetZ;
	local Rotator AttachRot;
	local NanoPC NPC;
	local bool bRightSide;
	local NanoInterface_StabMantle NISM;
	local float TimeToTarget, VelMag, MantleTime, AnimPlayRate;
	local name AnimToUseName;
	local NanoVehicleAgent NVA;

	// Check we have a Target, and we are not moving away from it
	NISM = NanoInterface_StabMantle(MyNP.InteractionActor);
	if( NISM == None || !NISM.IsValidStabMantleTarget() )
	{
		AbortStabMantle();
		return;
	}

	// Make a guesstimate for time to reach Target
	VelMag = VSize2D(MyNP.Velocity);
	if( VelMag < 0.1 )
	{
		TimeToTarget = 100000.0;
	}
	else
	{
		TimeToTarget = (DistToTarget - 300.0) / VelMag;
	}
	//`log("DistToTarget"@DistToTarget@"TimeToTarget"@TimeToTarget);

	// See if we are right at Target
	if( DistToTarget < 512.f )
	{
		bIsDoingMantleUp = TRUE;

		NVA = NanoVehicleAgent(MyNP.InteractionActor);

		FaceDir = vector(MyNP.Rotation);

		AttachRot = MyNP.InteractionActor.Rotation;
		AttachRot.Roll = 0;

		// See if we should attach to left or right side of Target
		GetAxes( AttachRot, TargetX, TargetY, TargetZ );
		bRightSide = (TargetY Dot FaceDir) < 0.0;

		// Turn off collision before moving pawn into position
		MyNP.SetCollision(FALSE,FALSE,FALSE);

		if( NVA != None )
		{
			// If this is a vehicle, give us a chance to damage it based on our velocity
			NVA.DoAttachingDamage( MyNP, MyNP.Velocity );
		}

		// Calc local space attach pos
		AttachOffset = NISM.GetStabAttachOffset();
		
		if( !bRightSide )
		{
			AttachOffset.Y *= -1.f;
		}
		// Then transform into world space
		AttachPos = MyNP.InteractionActor.Location + ((AttachOffset - MyNP.Mesh.Translation) >> AttachRot);

		//DrawDebugLine(NPC.TargetedActor.Location, AttachPos, 255,0,0, TRUE);
		// And move actor
		MyNP.SetLocation(AttachPos);

		// Rotate to face into the Target
		AttachRot.Yaw = bRightSide ? (AttachRot.Yaw - 16384) : (AttachRot.Yaw + 16384);
		MyNP.SetRotation(AttachRot);

		if( MyNP.IsLocallyControlled() )
		{
			MyNP.Controller.SetRotation(AttachRot);
		}

		// Turn off all collision for now and attach
		MyNP.SetPhysics( PHYS_None );
		MyNP.SetHardAttach( TRUE );
		MyNP.SetBase( NISM );

		MyNP.bIsSkydiving = FALSE;

		MyNP.FallingFullBodySlot.StopCustomAnim( 0.1f );
		//`log("BBBBASED ON Target!!!!");

		// Use root motion anim to climb onto Target
		AnimToUseName = NISM.GetStabMantleAnim(bRightSide);

		MyNP.FullBodySlot.bEarlyAnimEndNotify = TRUE;
		AnimPlayRate = NISM.GetStabMantleAnimRate() * GetSpeedModifier();
		MantleTime = MyNP.FullBodySlot.PlayCustomAnim(AnimToUseName, AnimPlayRate, 0.1, 0.0);
		MyNP.SetTimer( MantleTime-0.2, FALSE, nameof(ReleaseStabMantle), self );
		MyNP.FullBodySlot.SetActorAnimEndNotification(TRUE); // want notify

		MyNP.FullBodySlot.SetRootBoneAxisOption(RBA_Translate, RBA_Translate, RBA_Translate);
		MyNP.FullBodySlot.SetRootBoneRotationOption(RRO_Extract, RRO_Extract, RRO_Extract);
		MyNP.Mesh.RootMotionMode = RMM_Relative;
		MyNP.Mesh.RootMotionRotationMode = RMRM_RotateActor;

		// Doing Target mantle root motion anim
		MyNP.bStabMantling = TRUE;

		// Play sound
		NPC = NanoPC(MyNP.Controller);
		if( NPC != None && MyNP.Role < ROLE_Authority )
		{
			NPC.PlaySound( AttachedToTargetCue );

			// Stop targeting anything
			NPC.SetTargetedActor( None );
		}

		// Clear preparing stab state
		MyNP.bPreparingStabMantle = FALSE;

		// clear failsafe
		MyNP.ClearTimer(nameof(AbortStabMantle), self);

		NISM.NotifySomeoneAttached( MyNP );
	}
	// See if we are close
	else if( !MyNP.bPreparingStabMantle && (TimeToTarget < (0.8/PrepareStabMantleAnimRate)) )
	{
		// Play anim getting ready to stab
		AnimToUseName = NISM.GetStabMantleApproachAnim();
		MyNP.FallingFullBodySlot.PlayCustomAnim(AnimToUseName, PrepareStabMantleAnimRate, 0.1, -1.0);
		MyNP.bPreparingStabMantle = TRUE;

		// failsafe in case we don't reach the target in 5 seconds
		MyNP.SetTimer( 5.0, FALSE, nameof(AbortStabMantle), self );
	}
}

simulated function AbortStabMantle()
{
	// We got in here due to dubious circumstances...figure out what happened!
	ScriptTrace();

	ReleaseStabMantle();
}

/** Called when you finish stab-mantle move up . */
simulated function ReleaseStabMantle()
{
	if( MyNP.IsLocallyControlled() )
	{
		MyNP.LocalEndSpecialMove( 'NSM_StabMantle' );
	}
}


defaultproperties
{
	bUseUnsynchedServerMove=true
	bIgnoreServerBaseChange=true

	PrepareStabMantleAnimRate=1.f

	AttachedToTargetCue=SoundCue'Weapon_Sword.Sword.Sword_Surface_StickIn_Cue'
}