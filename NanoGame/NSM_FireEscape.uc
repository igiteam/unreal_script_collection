/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_FireEscape extends NanoSpecialMove;

/** Fire escape that we're based on */
var transient   NanoFireEscapeBase FireEscape;

/** Time when the perch was started */
var transient   float     PerchStartTime;

/** How long the player has to end the special move for maximum velocity boost */
var()           float     SweetSpotWindow;

/** The floor we're heading towards / currently at */
var transient   int       TargetFloor;
/** The location we're shooting for */
var transient   vector    TargetLocation;
/** The rotation we're shooting for */
var transient   rotator   TargetRotation;
/** Z-velocity for this move.  Note that this does not necessarily correspond to the pawn's actual velocity when stationary at a floor */
var transient   float     ZVelocity;

/** Are we jumping between floors? */
var transient   bool      bTraversingFloors;

/** If TRUE, we've already begun blending to the perching animation */
var transient   bool      bPlayingPerchingAnim;

/** Animation to play when hanging out at a level */
var()           Name      PerchingAnimToPlay;

var()           Name      NormalJumpAnim;
var()           Name      NormalJumpLoopAnim;
var()           Name      NormalJumpLandAnim;

var()           Name      ActiveJumpAnim;
var()           Name      ActiveJumpLoopAnim;
var()           Name      ActiveJumpLandAnim;

/** If true, the next time HeadToTargetFloor() is called, the jump beginning animation won't be played (set for the first floor traversed) */
var transient   bool      bSkipInitialJumpAnimation;

/** If true, the current traversal is an active mantle */
var transient   bool      bIsActiveMantle;

/** If we've began the jump, but are waiting for the animation to catch up */
var transient   bool      bWaitingForLaunch;

/** If we've landed, but are still completing the landing animation and can't begin another jump yet */
var transient   bool      bLanding;

/** If we hit the jump button while we were landing, this is TRUE, and will cause HeadToFloor() to be called as soon as the pawn is landed */
var transient   bool      bQueuedJump;


function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	Super.SpecialMoveStarted( bForced, PrevMove );

	// Set up the pawn for the SM to control the physics
	FireEscape = NanoFireEscapeBase(MyNP.InteractionActor);
	PawnOwner.SetBase(FireEscape);
	PawnOwner.SetPhysics(PHYS_None);

	// Sanity check
	if( FireEscape == None )
	{
		`warn("FIREESCAPE IS NONE...plzfix");
	}

	bSkipInitialJumpAnimation = TRUE;
	bIsActiveMantle = FALSE;
	bLanding = FALSE;
	bQueuedJump = FALSE;

	// Find the target floor, and head there
	ExtractSpecialMoveFlags( MyNP.SpecialMoveFlags );
	HeadToTargetFloor();
}

function ExtractSpecialMoveFlags( int Flags )
{
	TargetFloor = Flags;
}

function HeadToTargetFloor()
{
	local name AnimToPlay;
	local float AnimDuration;
	local BoxSphereBounds MeshBounds;

	MyNP.ClearTimer(nameof(PlayIdleAnim), self);

	// Determine where we need to end up for the specified TargetFloor
	MeshBounds = FireEscape.GetFloorMeshBounds();
	TargetLocation = FireEscape.GetFloorTargetLocation(TargetFloor, PawnOwner.Location);
	TargetRotation = rotator(MeshBounds.Origin - TargetLocation);
	TargetRotation.Pitch = 0;
	TargetRotation.Roll = 0;

	// Calculate the required velocity to launch us up there with gravity.  Add on a magic multiplier to make things seem more blockbustery
	ZVelocity = 1.5f * sqrt( -2.f * PawnOwner.GetGravityZ() * abs(TargetLocation.Z - PawnOwner.Location.Z) );

	bTraversingFloors = TRUE;

	if( !bSkipInitialJumpAnimation && (MyNP.Location.Z < TargetLocation.Z) )
	{
		AnimToPlay = bIsActiveMantle ? ActiveJumpAnim : NormalJumpAnim;
		AnimDuration = MyNP.FullBodySlot.PlayCustomAnim(AnimToPlay, GetSpeedModifier(), 0.0f, 0.f, FALSE);
		MyNP.SetTimer(AnimDuration, FALSE, nameof(PlayJumpingLoopAnim), self);

		bWaitingForLaunch = TRUE;
	}
	else
	{
		// If we're skipping the initial animation (starting the special move), or are traversing downward, skip the pushoff
		MyNP.FullBodySlot.PlayCustomAnim(NormalJumpLoopAnim, GetSpeedModifier(), 0.1f, 0.f, TRUE);
		bSkipInitialJumpAnimation = FALSE;
	}

	bPlayingPerchingAnim = FALSE;
}

simulated function PlayJumpingLoopAnim()
{
	local name AnimToPlay;

	AnimToPlay = bIsActiveMantle ? ActiveJumpLoopAnim : NormalJumpLoopAnim;
	MyNP.FullBodySlot.PlayCustomAnim(AnimToPlay, GetSpeedModifier(), 0.f, 0.f, TRUE);
}

simulated function PlayIdleAnim()
{
	MyNP.FullBodySlot.PlayCustomAnim(PerchingAnimToPlay, GetSpeedModifier(), 0.f, 0.f, TRUE);
}

/** Fired from the anim notifies in the launch animations */
function bool MessageEvent( Name EventName, Object Sender )
{
	switch( EventName )
	{
	case 'ReadyToLaunch':
		ReadyToLaunch();
		return TRUE;

	case 'LandingComplete':
		LandingComplete();
		return TRUE;
	}
	
	Super.MessageEvent(EventName, Sender);
}

simulated function ReadyToLaunch()
{
	bWaitingForLaunch = FALSE;
}

simulated function LandingComplete()
{
	// Remove lock on taking off to the next floor
	bLanding = FALSE;

	// NOTE:  While we could tell the player to head to the next floor here, we do so in the tick because it is unsafe to invoke a new animation from an animnotify
}

simulated function Tick( float DeltaTime )
{
	local float MoveRemaining, StickDot, Gravity;
	local vector FinalMovePosition, OriginalLocation;
	local rotator FinalMoveRotation;

	Super.Tick( DeltaTime );

	// If we're done landing, and already have another jump to hit
	if( bQueuedJump && !bLanding )
	{
		HeadToTargetFloor();
		bQueuedJump = FALSE;
	}


	if( !bWaitingForLaunch )
	{
		if( PawnOwner.Rotation != TargetRotation )
		{
			FinalMoveRotation = RInterpTo(PawnOwner.Rotation, TargetRotation, DeltaTime, 2.f, FALSE);
			PawnOwner.SetRotation(FinalMoveRotation);
// 			if( PawnOwner.IsLocallyControlled() )
// 			{
// 				PawnOwner.Controller.SetRotation(FinalMoveRotation);
// 			}
		}

		if( PawnOwner.Location != TargetLocation )
		{
			OriginalLocation = PawnOwner.Location;

			// Interpolate the pawn towards the target, changing the interp velocity to behave like gravity
			MoveRemaining = ZVelocity * DeltaTime;
			Gravity = PawnOwner.GetGravityZ();
			ZVelocity += Gravity * DeltaTime;

			if( abs(PawnOwner.Location.Z - TargetLocation.Z) <= MoveRemaining )
			{
				// We're close enough, set the location!
				PawnOwner.SetLocation( TargetLocation );
			}
			else
			{
				// Flip the direction, if needed
				if( TargetLocation.Z < PawnOwner.Location.Z )
				{
					MoveRemaining *= -1.f;
				}
			
				// Interpolate the location per axis...X/Y to bring us into alignment with the target, and Z based on velocity
				FinalMovePosition = PawnOwner.Location;
				FinalMovePosition.X = FInterpTo(FinalMovePosition.X, TargetLocation.X, DeltaTime, 1.f);
				FinalMovePosition.Y = FInterpTo(FinalMovePosition.Y, TargetLocation.Y, DeltaTime, 1.f);
				FinalMovePosition.Z = PawnOwner.Location.Z + MoveRemaining;

				// Move pawn towards the target!
				PawnOwner.SetLocation( FinalMovePosition );
			}

			PawnOwner.Velocity = (PawnOwner.Location - OriginalLocation) / DeltaTime;
		}
		else if( PawnOwner.IsLocallyControlled() )
		{
			StickDot = GetStickToFireEscapeDot();

			// If we're here, and we don't want to drop through, play the arrival sound and animation
			if( bTraversingFloors )
			{
				// We've arrived at our destination
				ArrivedAtFloor();
				PawnOwner.Velocity = vect(0.f, 0.f, 0.f);
			}

			// If we're holding back, drop the player another floor
			if( StickDot <= -0.2f )
			{
				TargetFloor--;
				
				if( TargetFloor < 1 )
				{
					MyNP.LocalEndSpecialMove( 'NSM_FireEscape' );
				}
				else
				{
					HeadToTargetFloor();
				}
			}
		}
	}
}

/** Returns the dot product of the input stick direction, adjusted for camera rotation, and the center of the fire escape (if > 0.f, player is pressing towards the fire escape) */
function float GetStickToFireEscapeDot()
{
	local vector PawnToPerchPoint, StickDir, CamLoc;
	local rotator CamRot;
	local NanoPC NPC;
	local BoxSphereBounds MeshBounds;

	MeshBounds = FireEscape.GetFloorMeshBounds();
	PawnToPerchPoint = MeshBounds.Origin - PawnOwner.Location;
	PawnToPerchPoint.Z = 0.f;
	PawnToPerchPoint = Normal(PawnToPerchPoint);

	NPC = NanoPC(PawnOwner.Controller);
	NPC.GetActorEyesViewPoint(CamLoc,CamRot);
	StickDir.X = NPC.PlayerInput.RawJoyUp;
	StickDir.Y = NPC.PlayerInput.RawJoyRight;
	StickDir = StickDir >> CamRot;

	return StickDir dot PawnToPerchPoint;
}

function ArrivedAtFloor()
{
	local Name AnimToPlay;
	local float AnimDuration;

	if( PawnOwner.IsLocallyControlled() )
	{
		if( FireEscape.ActiveMantleBeginSound != None )
		{
			// Play the landing sound to notify players that they can perform an active reload
			PawnOwner.PlaySound(FireEscape.ActiveMantleBeginSound);
		}

		if( FireEscape.ActiveMantleCameraShake != None )
		{
			// Play the landing camera shake
			NanoPC(PawnOwner.Controller).ClientPlayCameraShake(FireEscape.ActiveMantleCameraShake, 0.5f);
		}
	}

	// Play the landing animation
	MyNP.ClearTimer(nameof(PlayJumpingLoopAnim), self);
	AnimToPlay = bIsActiveMantle ? ActiveJumpLandAnim : NormalJumpLandAnim;
	AnimDuration = MyNP.FullBodySlot.PlayCustomAnim(AnimToPlay, GetSpeedModifier(), 0.f, 0.f, FALSE);
	bLanding = TRUE;
	MyNP.SetTimer(AnimDuration, FALSE, nameof(PlayIdleAnim), self);

	// Record when we arrived, so that we can determine if this will be an "active" mantle
	PerchStartTime = PawnOwner.WorldInfo.TimeSeconds;

	bTraversingFloors = FALSE;
	bIsActiveMantle = FALSE;
}

function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	local vector BumpVel;
	local BoxSphereBounds MeshBounds;

	Super.SpecialMoveEnded( PrevMove, NextMove );

	// Reset physics to normal pawn behavior
	MyNP.ClearTimer(nameof(PlayIdleAnim), self);
	MyNP.ClearTimer(nameof(PlayJumpingLoopAnim), self);
	MyNP.FullBodySlot.StopCustomAnim(0.2f);
	PawnOwner.SetBase(None);
	PawnOwner.SetPhysics(PHYS_Falling);

 	// Give the pawn a little bump away from the fire escape
	MeshBounds = FireEscape.GetFloorMeshBounds();
 	BumpVel = PawnOwner.Location - MeshBounds.Origin;
 	BumpVel.Z = 0.f;
 	BumpVel = 200.f * Normal(BumpVel);
 	PawnOwner.Velocity = BumpVel;
}

function bool FilterButtonInput(Name ButtonName,bool bPressed,int ButtonIdx)
{
	local vector TargetLoc;
	local NanoInterface_LaunchTarget LT;
	local float JumpTime;
	local BoxSphereBounds MeshBounds;

	if( !bTraversingFloors && ButtonName == 'A' && bPressed )
	{
		// We're already at the top...
		if( TargetFloor == FireEscape.NumFloors )
		{
			// We're at the top, dismount!
			MyNP.LocalEndSpecialMove('NSM_FireEscape');

			if( FireEscape.DismountTarget != None )
			{
				// If we have a dismount target, go there!
				LT = NanoInterface_LaunchTarget(FireEscape.DismountTarget);
				TargetLoc = LT != None ? LT.GetLandingLocation() : FireEscape.DismountTarget.Location;
				JumpTime = 1.5f;
			}
			else
			{
				MeshBounds = FireEscape.GetFloorMeshBounds();
				TargetLoc = MeshBounds.Origin + MeshBounds.BoxExtent.Z * vect(0.f, 0.f, 1.f);
				JumpTime = 1.f;
			}

			// Jump to the location!
			MyNP.SetCollision(FALSE, FALSE, FALSE);
			MyNP.SetTimer(JumpTime - 0.2f, FALSE, nameof(MyNP.RestoreCollisionAfterLaunch));

			MyNP.AttemptBigJump(TargetLoc, JumpTime);

			return TRUE;
		}

		// See if we hit the sweet spot to perform an active mantle
		bIsActiveMantle = (`TimeSinceEx(PawnOwner, PerchStartTime) <= SweetSpotWindow);

		if( bIsActiveMantle && FireEscape.HasActiveMantleBranch(TargetFloor, PawnOwner.Location, TargetLoc, JumpTime) )
		{
			// Jump to the location of the branch if this was an active mantle on a branch floor!
			MyNP.LocalEndSpecialMove('NSM_FireEscape');

			MyNP.SetCollision(FALSE, FALSE, FALSE);
			MyNP.SetTimer(JumpTime, FALSE, nameof(MyNP.RestoreCollisionAfterLaunch));

			MyNP.AttemptBigJump(TargetLoc, JumpTime);
		}
		else
		{
			// There's no active mantle branch, pick a new floor to head to, based on whether or not we hit an active mantle, maxing out at the top floor
			TargetFloor += bIsActiveMantle ? FireEscape.ActiveMantleStories : FireEscape.NormalMantleStories;
			if( TargetFloor > FireEscape.NumFloors )
			{
				TargetFloor = FireEscape.NumFloors;
			}
			
			if( !bLanding )
			{
				HeadToTargetFloor();
			}
			else
			{
				bQueuedJump = TRUE;
			}
		}

		// Play the sound feedback to indicate if the player successfully active mantled
		if( bIsActiveMantle && FireEscape.ActiveMantleSuccessSound != None )
		{
			MyNP.PlaySound(FireEscape.ActiveMantleSuccessSound);
		}
		else if( !bIsActiveMantle && FireEscape.ActiveMantleFlubSound != None )
		{
			MyNP.PlaySound(FireEscape.ActiveMantleFlubSound);
		}

		return TRUE;
	}

	return FALSE;
}

defaultproperties
{
	bUseUnsynchedServerMove=TRUE
	bSkipSimulatedPhysics=TRUE

	SweetSpotWindow=0.33f

	PerchingAnimToPlay=NW_FireEscape_Idle

	NormalJumpAnim=NW_FireEscape_Jump_Up
	NormalJumpLoopAnim=NW_FireEscape_Jump_Up_Loop
	NormalJumpLandAnim=NW_FireEscape_Jump_Land
	ActiveJumpAnim=NW_FireEscape_JumpFlip_Up
	ActiveJumpLoopAnim=NW_FireEscape_JumpFlip_Up_Loop
	ActiveJumpLandAnim=NW_FireEscape_JumpFlip_Land
}