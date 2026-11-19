/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_PerchOnPoint extends NanoSpecialMove;

/** Cached reference to the nanoperchpoint the pawn is based on */
var NanoPerchPoint      PerchPoint;

/** Cached reference to the nanoperchpole we're on, if any */
var NanoPerchPole_Base  PerchPole;

/** If this is a perch pole special move, play these animations when the pawn begins to dense charge */
var Name            DenseChargeAnim;
var Name            DenseChargeAnimLoop;
/** Animation to play when a dense pole launches us */
var Name            DenseLaunchAnim;

var transient bool  bQueuedRelease;


/** True if we're dense charging on a pole */
var transient bool  bDenseCharging;

/** True when we've already begun the uninterruptable launch process */
var transient bool  bPawnLaunched;

/** Internal.  Ugly workaround for SkeletalMeshComponent not taking a rate variable. */
simulated protected function PlayPerchPoleAnim(Name AnimName, float Rate)
{
	local AnimNodeSequence AnimNode;

	AnimNode = AnimNodeSequence(PerchPole.SkeletalMeshComponent.Animations);
	if (AnimNode == None && PerchPole.SkeletalMeshComponent.Animations.IsA('AnimTree'))
	{
		AnimNode = AnimNodeSequence(AnimTree(PerchPole.SkeletalMeshComponent.Animations).Children[0].Anim);
	}

	if (AnimNode != None)
	{
		AnimNode.SetAnim(AnimName);
		AnimNode.PlayAnim( FALSE, Rate, 0.f );
	}
}

function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	local vector AttachPos;
	local rotator AttachRot;

	Super.SpecialMoveStarted( bForced, PrevMove );

	PerchPoint = NanoPerchPoint(MyNP.InteractionActor);

	if( PerchPoint != None )
	{
		PerchPoint.LockedPawn = MyNP;
		PerchPoint.bLockedPawnRotationComplete = FALSE;

		// tell pole, if present
		PerchPole = NanoPerchPole_Base(PerchPoint.Base);
		if( PerchPole != None )
		{
			PerchPole.PawnLockedToPerch(MyNP);

			// Let pole decide which way to point pawn when landed
			AttachRot = PerchPole.GetPerchPawnDir();
		}
		else
		{
			AttachRot = MyNP.Rotation; // Don't change rotation
		}

		// Determine the attach position for the point
		AttachPos = PerchPoint.Location;
		AttachPos.Z += MyNP.CylinderComponent.CollisionHeight; // Move up so feet are on perch point
		AttachPos.Z += 10.0; // Allow some space above point
		
		// We have, in effect, landed - want to handle that stuff
		MyNP.Landed(vect(0,0,1), PerchPoint);

		// do attachment stuff
		if( PerchPoint.bLockPawnRotation )
		{
			MyNP.SetPhysics(PHYS_None);
		}
		else
		{
			MyNP.SetPhysics(PHYS_Custom);
		}

		if( MyNP.IsLocallyControlled() && MyNP.IsHumanControlled() )
		{
			MyNP.GetCamera().Default3pCam.PerchOriginLocOffset = PerchPoint.CamOffset;

			if( PerchPoint.bLockPlayerLook )
			{
				NanoPC(MyNP.Controller).IgnoreLookInput( TRUE );
				NanoPC(MyNP.Controller).IgnoreMoveInput( TRUE );
			}
		}
		
		MyNP.SetCollision(TRUE, FALSE, PerchPoint.bIgnoreEncroachers);
		MyNP.SetLocation(AttachPos);
		MyNP.SetDesiredRotation(AttachRot);
		MyNP.Velocity = vect(0.f, 0.f, 0.f);
		MyNP.SetHardAttach( FALSE );
		MyNP.SetBase(PerchPoint);
		MyNP.ClampedBase = PerchPoint;
		MyNP.TargetedAttractionActor = None;
		MyNP.UpdatePerchMode();
		
		// Play landing animation
		MyNP.BlendFallNode.ChangeFallState(FBT_Land);

		// tell kismet action
		MyNP.TriggerEventClass(class'SeqEvt_NanoActionPerformed', PerchPoint, 16);

		bDenseCharging = FALSE;
		bPawnLaunched = FALSE;
	}
}

function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	Super.SpecialMoveEnded( PrevMove, NextMove );

	// tell pole, if present
	if( PerchPole != None )
	{
		PerchPole.PawnUnlockedFromPerch(MyNP);
		PerchPole.SetLoad( 0.f );
	}

	if( bDenseCharging && !bPawnLaunched )
	{
		PlayPerchPoleAnim( DenseLaunchAnim, GetSpeedModifier() );
	}

	// unattach
	MyNP.ClampedBase = None;
	MyNP.SetBase(None);
	MyNP.SetHardAttach(MyNP.default.bHardAttach);
	MyNP.SetCollision(TRUE, TRUE, FALSE);
	MyNP.SetPhysics(PHYS_Falling);
	MyNP.UpdatePerchMode();

	if( MyNP.IsLocallyControlled() && MyNP.IsHumanControlled() )
	{
		MyNP.GetCamera().Default3pCam.PerchOriginLocOffset = MyNP.GetCamera().Default3pCam.default.PerchOriginLocOffset;
		
		if( PerchPoint.bLockPlayerLook )
		{
			NanoPC(MyNP.Controller).IgnoreLookInput( FALSE );
			NanoPC(MyNP.Controller).IgnoreMoveInput( FALSE );
		}
	}

	MyNP.FullBodySlot.StopCustomAnim(0.f);

	if( bDenseCharging )
	{
		// Line the player up to the target
		MyNP.LockDesiredRotation(FALSE, FALSE);

		// Set up the perch animation jump
 		MyNP.BlendFallNode.CopyAnimsFromSetByName('PerchJump');
 		MyNP.BlendFallNode.bResetFall = TRUE;
 		MyNP.BlendFallNode.ChangeFallState( FBT_Up );
	}
	else
	{
		MyNP.UpdateJumpAnimSet('Running_Jump');
	}


	// tell kismet
	MyNP.TriggerEventClass(class'SeqEvt_NanoActionPerformed', PerchPoint, 17);

	// note time we released
	MyNP.LastPerchReleaseTime = MyNP.WorldInfo.TimeSeconds;

	PerchPoint.LockedPawn = None;
	PerchPoint = None;
	PerchPole = None;
}

simulated function NotifyBeginDenseCharge()
{
	local float ChargeAnimDuration;

	if( bPawnLaunched )
	{
		// If we're already launching, don't worry about new charges
		return;
	}

	// Play appropriate animations on the pawn and the pole
	ChargeAnimDuration = MyNP.FullBodySlot.PlayCustomAnim(DenseChargeAnim, GetSpeedModifier(), 0.1f, 0.f, FALSE);
	PlayPerchPoleAnim(DenseChargeAnim, GetSpeedModifier());

	// Set a timer to play the sustaining animation
	MyNP.SetTimer(ChargeAnimDuration, FALSE, nameof(PlayDenseChargeSustain), self);
	
	bQueuedRelease = FALSE;
	bDenseCharging = TRUE;
}


simulated function PlayDenseChargeSustain()
{
	if( !bQueuedRelease )
	{
		// Play sustaining animations on the pawn and the pole
		MyNP.FullBodySlot.PlayCustomAnim(DenseChargeAnimLoop, GetSpeedModifier(), 0.1f, 0.f, TRUE);
		PlayPerchPoleAnim(DenseChargeAnimLoop, GetSpeedModifier());
	}
	else
	{
		// If there was a queued jump, skip the sustain and go right to the jump anim
		MyNP.ClearTimer(nameof(PlayDenseChargeSustain), self);  // Timer must be cleared, since NotifyLaunchPawn() is called before it gets cleared by the core timer code
		NotifyLaunchPawn();
	}
}

simulated function NotifyLaunchPawn()
{
	local float LaunchPawnTime;

	if( MyNP.IsTimerActive( nameof(PlayDenseChargeSustain), self) )
	{
		// If we're still trying to reach the bottom of the charge, queue a jump and then return
		bQueuedRelease = TRUE;
	}
	else if( !bPawnLaunched )
	{
		// If we're ready to launch, play the animation and set the timer to launch the pawn when we're done
		LaunchPawnTime = MyNP.FullBodySlot.PlayCustomAnim(DenseLaunchAnim, GetSpeedModifier(), 0.1f, 0.0f, FALSE);
		PlayPerchPoleAnim(DenseLaunchAnim, GetSpeedModifier());

		PerchPole.SetLoad(0.f);
		PerchPole.SetTimer(LaunchPawnTime, FALSE, nameof(PerchPole.ThrowLockedPawn), PerchPole);

		bPawnLaunched = TRUE;
	}
}

simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( bDenseCharging && !bPawnLaunched && !PerchPole.bDensePawnStanding)
	{
		NotifyLaunchPawn();
	}
}


defaultproperties
{
	// Keep this true so we can bob up and down on the perch pole without the server trying to correct us all the time
	bUseUnsynchedServerMove=true
	bSkipSimulatedPhysics=true

	bSkipOrbitCameraBlend=true

	DenseChargeAnim=NW_Perch_Dense_Jump_Start
	DenseChargeAnimLoop=NW_Perch_Dense_Jump_Start_Loop
	DenseLaunchAnim=NW_Perch_Dense_Jump_Up
}