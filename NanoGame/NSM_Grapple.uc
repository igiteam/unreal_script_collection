/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Grapple extends NanoSpecialMove
	native(Inherit);

/** Target to which we'll grapple to */
var transient Actor GrappleTarget;

/** Current location that the GrappleTarget wants to attract us to */
var transient vector GrappleTargetLocation;

/** Handle to the NI_Grapple of the current GrappleTarget */
var transient NanoInterface_Grapple GrappleInterface;

/** Current distance to the GrappleTarget */
var transient float DistanceToActor;

/** Mass to use for physics calculations for the pawn */
var float GrappleMass;

/** The acceleration that the pawn should have towards the grapple point */
var float GrappleAcceleration;
var float MaxGrappleVelocity;
/** Current velocity towards the grapple point */
var transient float CurrGrappleVelocity;

/** A multiplier on the velocity of the GrappleTarget that will be used to simulate drag (not physically accurate, but looks good for gameplay) */
var float   DragFactor;

/** Damping to add to the velocity close to the end of the tethering to ensure that the final approach doesn't fly around due to angular momentum */
var float   EndOfGrappleDamping;

/** If a tethering range is specified by the grapple target, when at that range, apply this damping to the motion to make a smooth dragging tether */
var float   TetheringDampingFactor;

/** Active mantles attempted when DistanceToActor is less than this will be successful */
var float ActiveMantleRange;

/** If TRUE, then perform an active mantle (handspring) at the end of the mantle */
var transient bool bActiveMantleQueued;

/** The maximum distance we should consider for grapple target checks */
var const float MaxGrappleDistance;

/** True if we've finished grappling, and are waiting for anims to finish up before ending */
var transient bool bFinishedGrappling;

/** Animations to play while grappling.  Can be overridden by the specific grapple target if needed */
var Name   StartAnimToPlay;
var Name   LoopAnimToPlay;
var Name   EndAnimToPlay;

cpptext
{
	/** Performs the actual grappling physics */
	virtual void TickSpecialMove(FLOAT DeltaTime);
};

protected function bool InternalCanDoSpecialMove()
{
	if( MyNP.Physics != PHYS_Falling )
	{
		return FALSE;
	}
	return Super.InternalCanDoSpecialMove();
}

function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	local float AnimDuration;

	Super.SpecialMoveStarted( bForced, PrevMove );

	GrappleTarget = MyNP.InteractionActor;
	GrappleInterface = NanoInterface_Grapple(MyNP.InteractionActor);
	GrappleTargetLocation = GrappleInterface.GetGrappleLocation(MyNP);
	DistanceToActor = VSize(PawnOwner.Location - GrappleTargetLocation);

	PawnOwner.SetCollision(FALSE, FALSE, TRUE);
	PawnOwner.SetPhysics(PHYS_None);
	MyNP.DeactivateSkill(class'NanoSkill_Jump');

	bFinishedGrappling = FALSE;
	CurrGrappleVelocity = 0.f;
	GrappleAcceleration = default.GrappleAcceleration;

	// Play the attraction animation
	StartAnimToPlay = default.StartAnimToPlay;
	LoopAnimToPlay  = default.LoopAnimToPlay; 
	EndAnimToPlay   = default.EndAnimToPlay;

	GrappleInterface.GetGrappleAnims(MyNP.Location.Z > GrappleTargetLocation.Z, StartAnimToPlay, LoopAnimToPlay, EndAnimToPlay);

	AnimDuration = MyNP.FullBodySlot.PlayCustomAnim(StartAnimToPlay, GetSpeedModifier(), 0.25f, 0.0f, FALSE, TRUE, 0.f);
	MyNP.SetTimer(AnimDuration, FALSE, nameof(PlayAnimLoop), self);

	MyNP.BeginGrappleEffects(GrappleTarget);
	
	bActiveMantleQueued = FALSE;

	GrappleInterface.NotifyBeginGrappled(MyNP);
}

function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	Super.SpecialMoveEnded( PrevMove, NextMove );

	// Clear any timers that may be hanging around
	MyNP.ClearTimer(nameof(PlayAnimLoop), self);
	MyNP.ClearTimer(nameof(FinishEndAnim), self);

	GrappleTarget = None;

	PawnOwner.SetCollision(TRUE, TRUE, FALSE);
	PawnOwner.SetPhysics(PHYS_Falling);
	
	// Blend out of the custom animation
	MyNP.FullBodySlot.StopCustomAnim(0.25f);

	MyNP.EndGrappleEffects();

	if( bActiveMantleQueued )
	{
		// If we're doing an active mantle, set the landing time to prevent the pawn from trying to do mantles
		MyNP.LastLandingTime = MyNP.WorldInfo.TimeSeconds;
		NanoPC(MyNP.Controller).SpecialMove_FocusCameraOnPawn();
	}

	GrappleInterface.NotifyEndGrappled(MyNP);
}

function bool CanChainMove( Name NextMove )
{
	return (NextMove == 'NSM_WireSlide');
}

event float GetMinimumDistance()
{
	return GrappleInterface.GetMinimumGrappleDistance();
}

event DestinationReached()
{
	local float AnimDuration;
	
	if( EndAnimToPlay != '' )
	{
		MyNP.ClearTimer(nameof(PlayAnimLoop), self);
		AnimDuration = MyNP.FullBodySlot.PlayCustomAnim(EndAnimToPlay, GetSpeedModifier(), 0.2f, 0.f, FALSE);
		MyNP.SetTimer(AnimDuration, FALSE, nameof(FinishEndAnim), self);
	}

	FinishEndAnim();
	bFinishedGrappling = TRUE;
}

simulated function PlayAnimLoop()
{
	MyNP.FullBodySlot.PlayCustomAnim(LoopAnimToPlay, GetSpeedModifier(), 0.f, 0.f, TRUE);
}

simulated function FinishEndAnim()
{
	MyNP.LocalEndSpecialMove('NSM_Grapple');

	if( bActiveMantleQueued )
	{
		// Fake the ending mantle state, so that the jump code will let us do a handspring transition
		MyNP.MantleState = MANTLE_EndingMantle;

		if( NanoPlayerInput(PlayerController(MyNP.Controller).PlayerInput).AttemptJump() )
		{
			MyNP.bHandspringJump = true;
			MyNP.MantleState = MANTLE_FlipJump;
			MyNP.BlendFallNode.CopyAnimsFromSetByName('FlipJump');
			MyNP.BlendFallNode.bResetFall = TRUE;
			MyNP.BlendFallNode.ChangeFallState( FBT_Up );
			MyNP.bHandspringJump = false;
			MyNP.Velocity = GrappleInterface.GetActiveGrappleVelocity();
		}
	}
}

event UpdateGrappleTargetLocation()
{
	// Update the target location so physics attracts us to the proper spot
	GrappleTargetLocation = GrappleInterface.GetGrappleLocation(MyNP);
}

event bool ShouldOverrideDesiredRotation(out rotator NewRotation)
{
	return GrappleInterface.ShouldOverrideDesiredRotation(MyNP, NewRotation, DistanceToActor);
}

/** Check for an active mantle button press! */
function bool FilterButtonInput(Name ButtonName,bool bPressed,int ButtonIdx)
{
	if( ButtonName == 'A' && bPressed )
	{
		if( GrappleInterface.SupportsActiveGrapple() && (DistanceToActor <= ActiveMantleRange) )
		{
			bActiveMantleQueued = TRUE;
		}

		return TRUE;
	}

	return FALSE;
}

defaultproperties
{
	bLockMeshTranslationOffset=TRUE

	GrappleMass=1.f

	GrappleAcceleration=350.f
	MaxGrappleVelocity=1000.f

	ActiveMantleRange=512.f

	MaxGrappleDistance=512.f

	DragFactor=2.5f
	TetheringDampingFactor=0.01f
	EndOfGrappleDamping=0.85f

	StartAnimToPlay=NW_Grapple_Start
	LoopAnimToPlay=NW_Grapple_Loop
}