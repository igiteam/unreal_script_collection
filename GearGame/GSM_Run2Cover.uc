
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_Run2Cover extends GearSpecialMove
	native(SpecialMoves);

var()	GearPawn.BodyStance	BS_TravelAnimation;
var()	GearPawn.BodyStance	BS_TravelAnimationMirrored;
var()	GearPawn.BodyStance	BS_ImpactAnimation;
var		GearPawn.BodyStance BS_Animation;

var()	float	MinTravelAnimDuration;

/** TRUE if joystick monitoring is allowed */
var bool	bEnableJoystickMonitoring;

/** Monitor how long player is holding down joystick */
var	float	HoldingRight, HoldingLeft, HoldingBack;

/** Minimum time required to hold joystick in one direction, to have the player face that way. */
var float	MinHoldTimeToSwitchMirroring;

var config	float	AISpeedModifier;
var config	float	ImpactAnimSpeedModifier;

var float	AnimDefaultLength;
var bool	bGotAnimDefaultLength;
var bool	bCanMonitorBlocked;
var bool bPlayWallHitEffects;

/** Cover Transition Animation Index */
enum CoverTransitionAnim
{
	CTA_Invalid,  // dummy value to fill up 0
	CTA_Default,
	CTA_ShortDistance,
	CTA_Max
};

/** Cover Transition Animation Index */
var CoverTransitionAnim TransitionAnimation;

// C++ functions
cpptext
{
	virtual void TickSpecialMove(FLOAT DeltaTime);
	virtual void PostProcessPhysics(FLOAT DeltaTime);
}

simulated function bool CanChainMove(ESpecialMove NextMove)
{
	// allow all the cover transition moves after run2cover
	return ( NextMove == SM_CoverSlip || NextMove == SM_CoverRun || NextMove == SM_MantleKick ||
		NextMove == SM_MidLvlJumpOver || NextMove == SM_MantleUpLowCover || NextMove == SM_StdLvlSwatTurn );
}


/**
 * Event called when Special Move is started.
 */
function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	bCanMonitorBlocked = FALSE;
	bGotAnimDefaultLength = FALSE;
	bEnableJoystickMonitoring = FALSE;

	Super.SpecialMoveStarted(bForced,PrevMove);

	CheckSpecialMoveReadyToBegin();

	if (PCOwner != None)
	{
		// force a release of the button since we're acquiring cover
		PCOwner.ForceButtonRelease(GB_A, true);
	}
}

function CheckSpecialMoveReadyToBegin()
{
	if( !IsSpecialMoveReadyToBegin() )
	{
		`warn("Cover missing for Run2Cover - likely to see hitches going to cover: " @ PawnOwner.CoverType @ PawnOwner.AcquiredCoverInfo.Link @ PawnOwner.CurrentLink);
		PawnOwner.SetTimer(1/60.f, FALSE, 'CheckSpecialMoveReadyToBegin', Self);
	}
	else
	{
		BeginSpecialMove();
	}
}

function bool IsSpecialMoveReadyToBegin()
{
	// Make sure Pawn is in cover before we can start.
	return PawnOwner != None && PawnOwner.CoverType != CT_None && PawnOwner.CurrentLink!=none && PawnOwner.AcquiredCoverInfo.Link == PawnOwner.CurrentLink;
}

function BeginSpecialMove()
{
	if( PawnOwner.IsLocallyControlled() )
	{
		if( PCOwner != None )
		{
			bEnableJoystickMonitoring = TRUE;
			HoldingRight = 0.f;
			HoldingLeft = 0.f;
			HoldingBack = 0.f;
			GearPlayerInput(PCOwner.PlayerInput).ForcePitchCentering(TRUE,, 0.f, 10.f);
		}
	}

	// Disable root motion for run 2 cover
	PawnOwner.Mesh.RootMotionMode = RMM_Ignore;

	if( PawnOwner.Controller != None )
	{
		SetReachPreciseDestination(PawnOwner.AcquiredCoverInfo.Location);
		PawnOwner.bForceMaxAccel = FALSE;
	}
	PlayTransitionAnimation();

	bPlayWallHitEffects = VSizeSq(PawnOwner.AcquiredCoverInfo.Location - PawnOwner.Location) > 2500.0;
}

// /**
//  * Overridden to not replicate this move - it is instead simulated by receipt of GearPawn.AcquiredCoverInfo, since we can't properly execute
//  * this move w/o that information.
//  */
// function bool ShouldReplicate()
// {
// 	return FALSE;
// }

/**
 * Returns proper Travel BodyStance
 * If mirrored, return mirrored animation
 * This is partially to add more variations for travel animations
  **/
function GearPawn.BodyStance GetTravelAnimation(bool bMirrored)
{
	if ( bMirrored )
	{
		return BS_TravelAnimationMirrored;
	}

	return BS_TravelAnimation;
}

/**
 * Returns proper Impact BodyStance
 * This is partially to add more variations for impact animations
  **/
function GearPawn.BodyStance GetImpactAnimation()
{
	return BS_ImpactAnimation;
}

protected function bool InternalCanDoSpecialMove()
{
	// make sure we're in cover
	return (PawnOwner.CoverType != CT_None && PawnOwner.AcquiredCoverInfo.Link != None);
}

/** Decide which animation to use */
function SetupTransitionAnimation()
{
	TransitionAnimation = CTA_Default;
}

function PlayTransitionAnimation()
{
	local bool		bShouldBeMirrored;
	local float		PlayDuration, BlendInTime, Rate;

	// if special move flags == 0, then I need to decide what to play
	if (PawnOwner.SpecialMoveFlags == 0)
	{
		SetupTransitionAnimation();
		// Update SpecialMoveFlags
		PawnOwner.SpecialMoveFlags = TransitionAnimation;
	}
	else
	{
		TransitionAnimation = CoverTransitionAnim(PawnOwner.SpecialMoveFlags);
	}

	// Need to use GetMaxSpeedModifier, as it's doing more voodoo than just GroundSpeed * SpeedModifier.
	Rate = PawnOwner.GetMaxSpeedModifier();

	// Based on distance from cover, figure out the time it would take to travel there.
	PlayDuration	= VSize(PawnOwner.AcquiredCoverInfo.Location - PawnOwner.Location) / (PawnOwner.GroundSpeed * Rate);
	// Need a minium of time...
	PlayDuration	= FMax(PlayDuration, GetMinTravelAnimDuration());

	// Adjust BlendInTime, so animation can be blended fully
	BlendInTime		= FMin(0.2f/Rate, PlayDuration * 0.5f);

	PawnOwner.SetTimer(FMax(default.MinTravelAnimDuration/2.f, 0.1f), FALSE, 'EnableBlockMonitoring', Self);

	// if we are sliding into the wall at a decent distance play the wall impact sound
	if( PlayDuration > 0.25f )
	{
		PawnOwner.PlaySlidingSound();
	}

	// TRUE = play animation. FALSE, bypass anim, just use standard running.
	if( TRUE )
	{
		// See if we should acquire cover being mirrored
		bShouldBeMirrored = (PawnOwner.FindBestCoverSideFor(PawnOwner.AcquiredCoverInfo) == CD_Left);

		if( bShouldBeMirrored )
		{
			BS_Animation = GetTravelAnimation(TRUE);
			PawnOwner.BS_PlayByDuration(BS_Animation, PlayDuration, BlendInTime, -1.f, FALSE, TRUE);

			// Play animation mirrored
			PawnOwner.BS_SetMirrorOptions(BS_Animation, TRUE, TRUE, FALSE);

			// If weapon is a heavy weapon, then don't do an early blend out. We need the animation to be over before we can re-enable IK Controllers.
			if( PawnOwner.MyGearWeapon != None && PawnOwner.MyGearWeapon.WeaponType == WT_Heavy )
			{
				PawnOwner.BS_SetEarlyAnimEndNotify(BS_Animation, FALSE);
			}
		}
		else
		{
			BS_Animation = GetTravelAnimation(FALSE);
			// Play Animation
			PawnOwner.BS_PlayByDuration(BS_Animation, PlayDuration, BlendInTime, -1.f, FALSE, TRUE);
		}

		// Get animation default length;
		AnimDefaultLength = PawnOwner.BS_GetAnimDefaultLength(BS_Animation);
		bGotAnimDefaultLength = TRUE;
	}

	// Use SetFacePreciseRotation - InterpolatePawnRotation does not work for AI
	SetFacePreciseRotation(Rotator(-PawnOwner.AcquiredCoverInfo.Normal), PlayDuration);
}

/**
 * Called from GearPawn when his AnimSets have been updated. To recache animation information if necessary.
 * Because our movement is based on the animation timing, if the animation changes, it can change the timing, and abort the special move too late or too early.
 * So we might need to adjust the play rate.
 */
function AnimSetsUpdated()
{
	local float NewLength, Scale;

	if( bGotAnimDefaultLength )
	{
		NewLength = PawnOwner.BS_GetAnimDefaultLength(BS_Animation);
		Scale = NewLength / AnimDefaultLength;
		PawnOwner.BS_ScalePlayRate(BS_Animation, Scale);
		PawnOwner.BS_SetPosition(BS_Animation, PawnOwner.BS_GetPosition(BS_Animation) * Scale);
		AnimDefaultLength = NewLength;
	}
}

function EnableBlockMonitoring()
{
	bCanMonitorBlocked = TRUE;
}

/** Event called when the Pawn is blocked/stopped */
event PawnIsBlocked()
{
// 	`log("PawnIsBlocked");
	bCanMonitorBlocked = FALSE;

	// only owning client and server end the special move themselves
	// non-owning clients wait for the server to tell us when we're done
	if (PawnOwner.Controller != None)
	{
		PawnOwner.EndSpecialMove();
	}
}

function EndRun2Cover()
{
	PawnOwner.EndSpecialMove();
}

/**
 * Joystick has been held long enough during transition,
 * So mirror ahead of time, before impact, so i can be properly replicated.
 */
simulated event JoystickHeldLongEnough(GearPC PC)
{
	// stop monitoring the joystick
	bEnableJoystickMonitoring = FALSE;

	// if holding back then abort the special move and cover
	if (HoldingBack > 0.f)
	{
		PC.AbortRun2Cover();
	}
	else
	{
		// otherwise set the pawn side to match the joystick direction
		PawnOwner.SetMirroredSide( HoldingLeft >= MinHoldTimeToSwitchMirroring );
	}
}

/**
* Return TRUE if using Impact Animation
* For shorter distance cover entering, we ignore impact animation as it doesn't need that dramatic hitting effect.
**/
function bool UseImpactAnimation()
{
	return TRUE;
}

/**
* Get Mini Travel Anim Duration
* This is the time it takes to travel to the target cover slot
* Min time can fluctuate if in combat or out of combat (slow) or so
* to reflect intensity of the scene.
**/
function float GetMinTravelAnimDuration()
{
	return default.MinTravelAnimDuration;
}

/**
* Get Blend Out time for run2 cover
* When you don't have impact animation, you'd like to use blend
* This also fluctuate as situation
**/
function float GetBlendOutTime()
{
	return 0.1f;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local vector	CamLoc;
	local rotator	CamRot;
	local bool		bForceNoBlend;
	local bool		bRun2CoverWasSuccessful;
	local BodyStance StanceFalse,StanceTrue;
	local BodyStance ImpactStance;

	PawnOwner.ClearTimer('CheckSpecialMoveReadyToBegin', Self);

	// Make sure rotation interpolation is finished so it doesn't mess any moves such mantles over cover.
	if( IsPawnRotationLocked() || PawnOwner.PawnRotationBlendTimeToGo > 0.f )
	{
		PawnOwner.PawnRotationBlendTimeToGo = 0.f;
		PawnOwner.FaceRotation(PawnOwner.Rotation, 0.f);
	}

	// Restore default root motion mode
	PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;
	SetReachPreciseDestination(vect(0,0,0), TRUE);
	PawnOwner.bForceMaxAccel = FALSE;

	if( PCOwner != None && GearPlayerInput(PCOwner.PlayerInput) != None )
	{
		GearPlayerInput(PCOwner.PlayerInput).ForcePitchCentering(FALSE);
	}

	// Can't do a blend out with heavy weapons when mirrored. argh.
	bForceNoBlend = (PawnOwner.MyGearWeapon != None && PawnOwner.MyGearWeapon.WeaponType == WT_Heavy);

	// Blend out from travel animation.
//@todo -- This code is needlessly slow
	StanceFalse = GetTravelAnimation(FALSE);
	PawnOwner.BS_Stop(StanceFalse, bForceNoBlend ? 0.f : GetBlendOutTime());
//@todo -- This code is needlessly slow
	StanceTrue = GetTravelAnimation(TRUE);
	PawnOwner.BS_Stop(StanceTrue, bForceNoBlend ? 0.f : GetBlendOutTime());

	//`log(self@GetFuncName()@PawnOwner.AcquiredCoverInfo.Link);
	if (PawnOwner.AcquiredCoverInfo.Link != None)
	{
		// reset the cover time to avoid issues w/ immediately pushing out of cover
		PawnOwner.LastCoverTime = PawnOwner.WorldInfo.TimeSeconds;

		// Play Wall impact effects
		if (bPlayWallHitEffects)
		{
			PawnOwner.DoRun2CoverWallHitEffects();
		}

		// Turn off mirroring
		PawnOwner.BS_SetMirrorOptions(StanceFalse, FALSE, FALSE, FALSE);

		// Turn off AnimEnd notification
		PawnOwner.BS_SetAnimEndNotify(StanceFalse, FALSE);

		// See if player was holding stick at the moment of impact.
		if( bEnableJoystickMonitoring && PCOwner != None )
		{
			if( HoldingLeft > 0.f )
			{
				PawnOwner.SetMirroredSide(TRUE);
			}
			else if( HoldingRight > 0.f )
			{
				PawnOwner.SetMirroredSide(FALSE);
			}
		}

		// Play wall impact effect only if there is no mirror transition pending,
		// For better responsiveness.
		if( UseImpactAnimation() )
		{
//@todo -- This code is needlessly slow
			ImpactStance = GetImpactAnimation();
			// Play Animation
			PawnOwner.BS_Play(ImpactStance, ImpactAnimSpeedModifier, bForceNoBlend ? 0.f : 0.05f, 0.33f/ImpactAnimSpeedModifier, FALSE, TRUE);
		}

		if( PCOwner != None && PCOwner.IsInCoverState() )
		{
			// remap controls once we've actually gotten into cover, to account for any rotation between start/end of anim
			PCOwner.GetPlayerViewPoint(CamLoc, CamRot);
			PCOwner.ControlsRemapRotation = CamRot;

			// if they're holding 'a' still try another special move at this point
			if( PCOwner.IsHoldingActionButton() )
			{
				PCOwner.TryASpecialMove(FALSE);
			}
		}

		// Clear movement, otherwise it triggers a move2idle transition when getting in cover.
		PawnOwner.ZeroMovementVariables();

		// Send event telling Pawn cover slot has been reached.
		if( PawnOwner.CurrentSlotPct == 0.f || PawnOwner.CurrentSlotPct == 1.f )
		{
			PawnOwner.ReachedCoverSlot(PawnOwner.CurrentSlotIdx);
		}
	}

	Super.SpecialMoveEnded(PrevMove, NextMove);

	// Doing this on LocallyControlled Pawns, because on Server might lag behind clients and fail this test.
	if( PawnOwner.IsLocallyControlled() )
	{
		// This cover is probably moving, recalculate Location vector.
		if (InterpActor_GearBasePlatform(PawnOwner.Base) != None)
		{
			PawnOwner.SetCoverPosVectors(PawnOwner.AcquiredCoverInfo);
		}

		// If run2cover wasn't successful, then break from cover
		bRun2CoverWasSuccessful = (VSize2D(PawnOwner.Location - PawnOwner.AcquiredCoverInfo.Location) <= PawnOwner.GetCollisionRadius());
		if( !bRun2CoverWasSuccessful )
		{
			// If not playing impact animation, do a gentle blend out
			PawnOwner.BS_Stop(StanceFalse, 0.33f);
			PawnOwner.BS_Stop(StanceTrue, 0.33f);

			BreakFromCover();
		}
	}
}

defaultproperties
{
	MinTravelAnimDuration=0.2f
	MinHoldTimeToSwitchMirroring=0.25f

	bForcePrecisePosition=TRUE
	bCanFireWeapon=FALSE
	bLockPawnRotation=TRUE
	bDisableMovement=TRUE

	bDisableAI=TRUE

	bDeferWeaponSwitch=TRUE
}
