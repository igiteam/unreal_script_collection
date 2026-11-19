/**
 * A grapping hook climb special move that can go to arbitrary heights
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_GrapplingHook_DynamicClimb extends GearSpecialMove;

/** The throw animation */
var BodyStance		BS_Throw;

/** The climb animation loop */
var BodyStance	    BS_Climb;

/** The jumping animation */
var BodyStance      BS_JumpToRope;

/** The mantle animation */
var BodyStance      BS_Mantle_Rail, BS_Mantle_NoRail;
var bool            bMantleNoRail;

/** The location of the grapple destination */
var Vector			MarkerLocation;

/** The rotation of the grapple destination */
var Rotator			MarkerRotation;

/** The animation slot of the grappling hook actor */
var GearAnim_Slot	GrapplingHookSlot;
	
/** The distance covered by the root motion in the climbing animation */
var const float     ClimbDistancePerAnimLoop;

/** How far the hook throw animates up with no scaling */
var const float     HookThrowZRootMotion;

/** How far the hook throw animates up with no scaling */
var const float     HookThrowZRootMotionOffset;

/** This is the saved off value of bNoEncroachCheck which is restored at the end of the move. **/
var bool bSavedOffbNoEncroachCheck;

/** The height the jump animation is going to keep climbing up after BS_Climb is done */
var float MarkerZOffset;

enum EDynGrappleState
{
	GRAPPLE_Throw,
	GRAPPLE_JumpToRope,
	GRAPPLE_Climb,
	GRAPPLE_Mantle,
};
var() EDynGrappleState GrappleState;

/** 
 * Get the pawn ready for climbing animations
 * 
 * @param bForced - whether this was a forced special move
 * 
 * @param PrevMove - the previous special move executed
 */
function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

	bSavedOffbNoEncroachCheck = PawnOwner.bNoEncroachCheck;
	PawnOwner.bNoEncroachCheck = TRUE;

	// fixes some issues with complicated attachment setups and is unnecessary since the whole special move's location is based
	PawnOwner.bUpdateSimulatedPosition = false;

	PawnOwner.Mesh.bRootMotionExtractedNotify = TRUE;

	// Set Up Pawn so he's ready to climb
	SetupPawnToClimb();

	PlayGrappleThrow();
}

/** Prep the pawn and grappling hook actor */
function SetupPawnToClimb()
{
	PawnOwner.SetBase(None);
	PawnOwner.SetPhysics(PHYS_None);
	TogglePawnCollision(FALSE);

	UpdateMarkerInfo();

	PawnOwner.bCanDoStepsSmoothing = FALSE;

	// Make sure Pawn is facing proper rotation.
	ForcePawnRotation(PawnOwner, MarkerRotation);

	// Create Grappling Hook on updated Pawn position.
	PawnOwner.CreateGrapplingHook(PawnOwner.Location, MarkerRotation);
	GrapplingHookSlot = PawnOwner.GetGrapplingHookAnimSlot();

	bMantleNoRail = PawnOwner.CurrentGrapplingMarker.bNoRailing;
}

function UpdateMarkerInfo()
{
	MarkerLocation = PawnOwner.CurrentGrapplingMarker.Location;
	MarkerRotation = PawnOwner.CurrentGrapplingMarker.Rotation;

	MarkerLocation.Z -= MarkerZOffset;
}

/** Play the throw animation on the pawn and grappling hook */
function PlayGrappleThrow()
{
	local float AnimTime;
	local float MarkerZAtEndOfAnim;

	PawnOwner.bAnimForceVelocityFromBase = TRUE;
	PawnOwner.bCanRoadieRun = FALSE;
	PawnOwner.BS_Play(BS_Throw, SpeedModifier, 0.2f / SpeedModifier, -1.f);
	PawnOwner.BS_SetAnimEndNotify(BS_Throw, TRUE);

	AnimTime = GrapplingHookSlot.PlayCustomAnim('GP_Release', SpeedModifier, 0.f, -1.f);
	GrapplingHookSlot.SetRootBoneAxisOption(RBA_Translate, RBA_Translate, RBA_Translate);
	GrapplingHookSlot.SkelComponent.RootMotionMode = RMM_Translate;

	// Toss the hook to the location it will need to latch onto as the base moves
	MarkerZAtEndOfAnim = MarkerLocation.Z;
	if( PawnOwner.CurrentGrapplingMarker.Base != None )
	{
		// Assumes constant velocity thru entire throw animation
		MarkerZAtEndOfAnim += PawnOwner.CurrentGrapplingMarker.Base.Velocity.Z * AnimTime;
	}

	GrapplingHookSlot.SkelComponent.RootMotionAccelScale.Z = (MarkerZAtEndOfAnim - PawnOwner.GrapplingHook.Location.Z + HookThrowZRootMotionOffset) / HookThrowZRootMotion;

	GrappleState = GRAPPLE_Throw;
}

/** Remove anim notifies and restore some of the pawn's defaults */
function CleanUpGrappleThrow()
{
	PawnOwner.BS_SetAnimEndNotify(BS_Throw, FALSE);
	PawnOwner.bAnimForceVelocityFromBase = PawnOwner.default.bAnimForceVelocityFromBase;
	PawnOwner.bCanRoadieRun = PawnOwner.default.bCanRoadieRun;
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
	UpdateMarkerInfo();

	if( PawnOwner.BS_SeqNodeBelongsTo(SeqNode, BS_Throw) )
	{
		CleanUpGrappleThrow();
		PlayJumpToRopeAnimation();
	}
	else if (PawnOwner.BS_SeqNodeBelongsTo(SeqNode, BS_JumpToRope))
	{
		PlayClimbingAnimation();
	}
	else if (PawnOwner.BS_SeqNodeBelongsTo(SeqNode, BS_Climb))
	{
		if (abs(PawnOwner.Location.Z - MarkerLocation.Z) > 10.0f)
		{
			PlayClimbingAnimation();
		}
		else
		{
			PlayMantleAnimation();
		}
	}
	else
	{
		PawnOwner.EndSpecialMove();
	}
}

/** Don't have proper animations for a mantle yet, just teleport hack */
function PlayMantleAnimation()
{
	if( bMantleNoRail )
	{
		PawnOwner.BS_Play(BS_Mantle_NoRail, SpeedModifier, 0.2f / SpeedModifier, 0.2f / SpeedModifier);
		PawnOwner.BS_SetAnimEndNotify(BS_Mantle_NoRail, TRUE);
		PawnOwner.BS_SetRootBoneAxisOptions(BS_Mantle_NoRail, RBA_Translate, RBA_Translate, RBA_Translate);
	}
	else
	{
		PawnOwner.BS_Play(BS_Mantle_Rail, SpeedModifier, 0.2f / SpeedModifier, 0.2f / SpeedModifier);
		PawnOwner.BS_SetAnimEndNotify(BS_Mantle_Rail, TRUE);
		PawnOwner.BS_SetRootBoneAxisOptions(BS_Mantle_Rail, RBA_Translate, RBA_Translate, RBA_Translate);
	}
	PawnOwner.Mesh.RootMotionMode = RMM_Translate;
	PawnOwner.Mesh.RootMotionAccelScale = Vect(1,1,1);
	
	MantleOverNotify();

	GrappleState = GRAPPLE_Mantle;
}

/** Play the hop up animation to grasp the rope */
function PlayJumpToRopeAnimation()
{
	PawnOwner.BS_Play(BS_JumpToRope, SpeedModifier, 0.2f / SpeedModifier, 0.2f / SpeedModifier);
	PawnOwner.BS_SetAnimEndNotify(BS_JumpToRope, TRUE);
	PawnOwner.BS_SetRootBoneAxisOptions(BS_JumpToRope, RBA_Translate, RBA_Translate, RBA_Translate);
	PawnOwner.Mesh.RootMotionMode = RMM_Translate;
	PawnOwner.Mesh.RootMotionAccelScale = Vect(1,1,1);

	// Base Pawn and Hook on whatever the marker is based on.
	PawnOwner.SetBase(PawnOwner.CurrentGrapplingMarker.Base);
	PawnOwner.GrapplingHook.SetBase(PawnOwner.Base);

	GrappleState = GRAPPLE_JumpToRope;
}

/** The looped climbing animation that scales root motion to reach arbitrary heights */
function PlayClimbingAnimation()
{
	local float	DistanceScale;
	local float DistanceLeft;

	DistanceLeft = MarkerLocation.Z - PawnOwner.Location.Z;
	if (DistanceLeft > 1.66f * ClimbDistancePerAnimLoop)
	{
		DistanceScale = 1.0f;
	}
	else
	{
		DistanceScale = DistanceLeft / ClimbDistancePerAnimLoop;
	}

	PawnOwner.BS_Play(BS_Climb, SpeedModifier, 0.2f / SpeedModifier, 0.2f / SpeedModifier);
	PawnOwner.BS_SetAnimEndNotify(BS_Climb, TRUE);
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Climb, RBA_Translate, RBA_Translate, RBA_Translate);
	PawnOwner.Mesh.RootMotionMode = RMM_Translate;
	PawnOwner.Mesh.RootMotionAccelScale = Vect(1,1,1);
	PawnOwner.Mesh.RootMotionAccelScale.Z *= DistanceScale;

	GrappleState = GRAPPLE_Climb;
}

/** Restore the pawn to normal state and get rid of the grappling hook */
function PostClimbCleanup()
{
	PawnOwner.SetBase(None);
	PawnOwner.SetHardAttach(FALSE);
	PawnOwner.SetPhysics(PHYS_Falling);

	PawnOwner.bCanDoStepsSmoothing = PawnOwner.default.bCanDoStepsSmoothing;

	TogglePawnCollision(TRUE);

	PawnOwner.BS_SetAnimEndNotify(BS_Climb, FALSE);
	PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;

	PawnOwner.DestroyGrapplingHook();
}

/** Play the climbing effort */
function MantleOverNotify()
{
	PawnOwner.SoundGroup.PlayEffort(PawnOwner, GearEffort_GrapplingHookMantleOverEffort, true);
}

/**
 * Force the pawn back into a good state
 * 
 * @param PrevMove - the special move executed before this one
 * 
 * @param NextMove - the special move being transitioned to
 */
function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	PawnOwner.ClearTimer('MantleOverNotify', Self);
	CleanUpGrappleThrow();
	PostClimbCleanup();

	// Make sure frozen anim "Throw" has been stopped.
	PawnOwner.BS_Stop(BS_Throw);

	PawnOwner.bNoEncroachCheck = bSavedOffbNoEncroachCheck;
	PawnOwner.bUpdateSimulatedPosition = true;
	PawnOwner.Mesh.bRootMotionExtractedNotify = PawnOwner.default.Mesh.bRootMotionExtractedNotify;

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

function RootMotionExtracted(SkeletalMeshComponent SkelComp, out BoneAtom ExtractedRootMotionDelta)
{
	local Vector Dir;
	if( GrappleState == GRAPPLE_Mantle )
	{
		Dir = Vector(PawnOwner.Rotation);
		Dir *= ExtractedRootMotionDelta.Translation DOT Dir;
		ExtractedRootMotionDelta.Translation = (ExtractedRootMotionDelta.Translation - Dir) + Dir * PawnOwner.CurrentGrapplingMarker.MantleRootMotionScale;
	}
}

defaultproperties
{
	BS_Throw=(Stance=((Slot=BS_Std_Idle_Lower,AnimName="GP_Release"),(Slot=BS_Std_Up,AnimName="GP_Release")))
	BS_Climb=(Stance=((Slot=BS_FullBody,AnimName="GP_ClimbLoop")))
	BS_JumpToRope=(Stance=((Slot=BS_FullBody,AnimName="GP_JumpUp")))
	BS_Mantle_Rail=(Stance=((Slot=BS_FullBody,AnimName="GP_ClimbOverRail")))
	BS_Mantle_NoRail=(Stance=((Slot=BS_FullBody,AnimName="GP_ClimbNoRail")))

	bCanFireWeapon=FALSE
	bLockPawnRotation=TRUE
	bDisableMovement=TRUE
	bDisableTurnInPlace=TRUE
	bShouldAbortWeaponReload=TRUE

	DefaultAICommand=class'AICmd_Base_PushedBySpecialMove'
	bDisableAI=TRUE

	ClimbDistancePerAnimLoop=220.0f

	HookThrowZRootMotion=487.0f
	HookThrowZRootMotionOffset=150.0f

	MarkerZOffset=140
}
