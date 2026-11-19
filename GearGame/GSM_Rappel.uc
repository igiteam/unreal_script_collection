/**
 * Rappelling special move
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_Rappel extends GearSpecialMove
	native(SpecialMoves);

/** The jump animation */
var BodyStance BS_JumpToRope;

/** The idle animation */
var BodyStance BS_Idle;

/** The landing animation */
var BodyStance BS_Land;

/** This is the saved off value of bNoEncroachCheck which is restored at the end of the move. **/
var bool bSavedOffbNoEncroachCheck;

/** The maximum speed the rappelling pawn should go vertically */
var config float MaxZVelocity;

/** Make sure the pawn has jumped before allowing the move to end */
var bool bOnRope;

/** Spline loft actor at the start of the rope */
var Gear_RappelRopeBase RopeStart;

/** Spline loft actor at the end of the rope */
var Gear_RappelRopeBase RopeEnd;

cpptext
{
	/**
	 * Clamp the rappelling velocity
	 * 
	 * @param DeltaTime - the length of the last frame
	 */
	virtual void PrePerformPhysics(FLOAT DeltaTime);
}

/** 
 * Get the pawn ready for climbing animations
 * 
 * @param bForced - whether this was a forced special move
 * 
 * @param PrevMove - the previous special move executed
 */
function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local rotator NewRotation;

	Super.SpecialMoveStarted(bForced,PrevMove);

	bSavedOffbNoEncroachCheck = PawnOwner.bNoEncroachCheck;
	PawnOwner.bNoEncroachCheck = TRUE;

	// Free our pawn from the GearBasePlatform dungeon
	PawnOwner.ClampedBase = None;

	NewRotation = PawnOwner.CurrentGrapplingMarker.Rotation;
	NewRotation.Yaw += 32768;
	PawnOwner.SetRotation(NewRotation);
	JumpToRope();

	RopeStart = PawnOwner.CurrentGrapplingMarker.Spawn(PawnOwner.RappelRopeClass, PawnOwner.CurrentGrapplingMarker,,,,, TRUE);
	RopeStart.SetHardAttach(TRUE);
	RopeStart.SetBase(PawnOwner.CurrentGrapplingMarker);
	RopeStart.SetRelativeLocation(vect(0,0,50));
	RopeStart.SplineActorTangent = vect(-300,0,400);

	RopeEnd = PawnOwner.CurrentGrapplingMarker.Spawn(PawnOwner.RappelRopeClass, PawnOwner.CurrentGrapplingMarker,,,,, TRUE);
	RopeEnd.SetHardAttach(TRUE);
	RopeEnd.SetBase(PawnOwner,, PawnOwner.Mesh, PawnOwner.LeftHandSocketName);
	RopeEnd.SetRelativeLocation(vect(0,0,0));
	RopeEnd.SplineActorTangent = vect(0,0,0);

	RopeStart.AddConnectionTo(RopeEnd);
}

/** Play the idle animation and turn off root motion */
function TransitionToIdle()
{	
	PawnOwner.bCollideWorld = TRUE;
	PawnOwner.SetCollision(TRUE, TRUE);
	PawnOwner.BS_SetAnimEndNotify(BS_JumpToRope, FALSE);
	PawnOwner.BS_SetRootRotationOption(BS_JumpToRope, RRO_Discard);
	PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;
	PawnOwner.Mesh.RootMotionRotationMode = PawnOwner.default.Mesh.RootMotionRotationMode;

	PawnOwner.Velocity.X = 0;
	PawnOwner.Velocity.Y = 0;
	PawnOwner.Velocity.Z = MaxZVelocity;
	PawnOwner.Acceleration.X = 0;
	PawnOwner.Acceleration.Y = 0;

	PawnOwner.BS_Play(BS_Idle, 1.0f, 0.2f, 0.2f, TRUE);
	PawnOwner.SetPhysics(PHYS_Falling);
	bOnRope = TRUE;
}

/** Start the jump anim and turn on root motion */
function JumpToRope()
{
	PawnOwner.SetCollision(FALSE, FALSE);
	PawnOwner.bCollideWorld = FALSE;

	PawnOwner.BS_Play(BS_JumpToRope, 1.0f, 0.2f, 0.2f);
	PawnOwner.BS_SetAnimEndNotify(BS_JumpToRope, TRUE);
	PawnOwner.BS_SetRootBoneAxisOptions(BS_JumpToRope, RBA_Translate, RBA_Translate, RBA_Translate);
	PawnOwner.BS_SetRootRotationOption(BS_JumpToRope, RRO_Extract);
	PawnOwner.Mesh.RootMotionAccelScale = Vect(1,1,1);
	
	PawnOwner.Mesh.RootMotionMode = RMM_Translate;
	PawnOwner.Mesh.RootMotionRotationMode = RMRM_RotateActor;
	PawnOwner.SetPhysics(PHYS_Flying);
}

/** 
 * Transition to the next state based on the animation that just completed
 * 
 * @param SeqNode - the animation node sequence that just completed
 * 
 * @param PlayedTime - the length of the animation
 * 
 * @param ExcessTime - the overage time of the animation
 */
function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	if (PawnOwner.BS_SeqNodeBelongsTo(SeqNode, BS_JumpToRope))
	{
		TransitionToIdle();
	}
	else if (PawnOwner.BS_SeqNodeBelongsTo(SeqNode, BS_Land))
	{
		PawnOwner.BS_SetAnimEndNotify(BS_Land, FALSE);
		PawnOwner.EndSpecialMove();
	}
}

/**
 * Animate the rope if it's not already
 * 
 * @param PrevMove - the special move executed before this one
 * 
 * @param NextMove - the special move being transitioned to
 */
function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	if (RopeEnd.Base != PawnOwner.CurrentGrapplingMarker)
	{
		RopeEnd.SetBase(PawnOwner.CurrentGrapplingMarker);
		RopeEnd.StartXYRevolution(RopeEnd.RelativeLocation, 20, 30, RandRange(2,3));
	}

	// Clear CurrentGrapplingMarker 
	PawnOwner.CurrentGrapplingMarker = None;
	
	Super.SpecialMoveEnded(PrevMove, NextMove);
}

/** Force the pawn back into a good state and start the rope animating */
function TransitionToLand()
{
	RopeEnd.SetBase(PawnOwner.CurrentGrapplingMarker);
	RopeEnd.StartXYRevolution(RopeEnd.RelativeLocation, 20, 30, RandRange(2,3));

	bOnRope = FALSE;
	PawnOwner.BS_Play(BS_Land, 1.0f, 0.2f, 0.1f);
	PawnOwner.BS_SetAnimEndNotify(BS_Land, TRUE);
	PawnOwner.bNoEncroachCheck = bSavedOffbNoEncroachCheck;
}

/**
 * End the special move if the pawn hit the ground
 *
 * @param DeltaTime - the length of the last frame
 */ 
function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);

	if (PawnOwner.Physics != PHYS_Falling && bOnRope)
	{
		TransitionToLand();
	}
}

defaultproperties
{
	bLockPawnRotation=TRUE

	bDoMeshFloorConform=FALSE
	bDoIKFloorConform=FALSE
	bDoFootPlacement=FALSE

	bCanFireWeapon=FALSE
	
	BS_Land=(Stance=((Slot=BS_FullBody,AnimName="Emerge_Burst_land")))
	BS_Idle=(Stance=((Slot=BS_FullBody,AnimName="Rappel_Dangle")))
	BS_JumpToRope=(Stance=((Slot=BS_FullBody,AnimName="Rappel_JumpingDangle")))

	bShouldAbortWeaponReload=TRUE

	DefaultAICommand=class'AICmd_Base_PushedBySpecialMove'
	bDisableAI=TRUE
}