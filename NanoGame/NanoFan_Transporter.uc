/**
 * This class is for fans that suck you in at one point, and spit you out at a completely different point
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoFan_Transporter extends NanoFan_ThroughBase
	native(Inherit);

/** This is the actor where you'll be spit out of the fan */
var(NanoFan) Actor TransportDestination;

/** If set, the fan will try to fling the player to this location after exiting */
var(NanoFan) Actor LaunchDestination;

/** How long it takes to transport the pawn from the fan to the exit point to spit them out */
var(NanoFan) float  TripTime;

/** Velocity to spit the pawn out of the end at */
var(NanoFan) vector EjectionVelocity;

/** Volume where the pawn will be attracted towards the fan */
var(NanoFan) TriggerVolume CaptureVolume;

/** Pawn that we're currently transporting */
var transient NanoPawn CapturedPawn;

/** If TRUE, the CapturedPawn still needs to be sucked into the fan */
var transient bool bCapturingPawn;

/** Interp speed to bring the pawn in at when it's being sucked into the fan */
var(NanoFan) float SuckInInterpSpeed;

/** Time the pawn started their trip through the fan */
var transient float TimeCapturedPawn;

/** Potential pawns to suck into the fan */
var transient array<NanoPawn> PotentialPawns;

cpptext
{
	virtual void TickSpecial( FLOAT DeltaSeconds );
};

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	// Register us with the trigger volume so that we receive Touch / Untouch events
	CaptureVolume.AssociatedActor = self;
	CaptureVolume.GotoState('AssociatedTouch');
}

event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	local NanoPawn TouchingPawn;

	TouchingPawn = NanoPawn(Other);

	if( (TouchingPawn != None) && (PotentialPawns.Find(TouchingPawn) == INDEX_NONE) )
	{
		// Add the touching pawn to the PotentialPawn list, where it will be checked for dusting in the tick
		PotentialPawns.AddItem(TouchingPawn);
	}
}

event Untouch( Actor Other )
{
	if(Other != None)
	{
		// Remove the potential pawn from the list, so it will no longer be checked for attraction
		PotentialPawns.RemoveItem(Other);
	}
}

simulated event SuckInPawn(NanoPawn PawnToCapture)
{
	// Capture a pawn if we're not already capturing one, and that we have a valid destination
	if( (CapturedPawn == None) && (TransportDestination != None))
	{
		// Make sure the pawn is dusted
		if( PawnToCapture.IsDusted() )
		{
			TimeCapturedPawn = WorldInfo.TimeSeconds;

			// Prepare the pawn to be moved by the fan
			PawnToCapture.SetCollision(FALSE, FALSE, FALSE);
			PawnToCapture.SetPhysics(PHYS_Interpolating);
			NanoPC(PawnToCapture.Controller).IgnoreLookInput(TRUE);
		
			// Tell the pawn they've been captured, so we can play full body animations, etc
			PawnToCapture.NotifySuckedIntoFan();
			
			CapturedPawn = PawnToCapture;
			bCapturingPawn = TRUE;
		}
	}
}

simulated event EjectPawn()
{
	local vector LaunchVel;

	// Set the player to the ejection target location
	CapturedPawn.SetLocation(TransportDestination.Location);
	// Restore collision
	CapturedPawn.SetCollision(TRUE, TRUE, FALSE);
	// Unhide the pawn
	CapturedPawn.SetHidden(FALSE);
	NanoPC(CapturedPawn.Controller).IgnoreLookInput(FALSE);
	CapturedPawn.NotifyEjectedFromFan();

	// If there's a target, try to calc a velocity to launch the player there
	if( LaunchDestination != None && CapturedPawn.AttemptBigJumpToActor(LaunchDestination, 2.f))
	{
		CapturedPawn.UpdateJumpAnimSet('Sprint_Jump');

		// Launched the pawn!  We're done.
		CapturedPawn = None;
		return;
	}
	
	// If there's not an overriding launch velocity, use the default
	LaunchVel = EjectionVelocity;
	// Launch the pawn!
	CapturedPawn.Velocity = LaunchVel;
	// Launch the player out at the finishing velocity
	CapturedPawn.SetPhysics(PHYS_Falling);

	CapturedPawn = None;
}

defaultproperties
{
	Rotation=(Pitch=-16384)
	bAbleToGhostThroughBase=FALSE

	Components.Remove(PlumeComp)
	Plume=None
	NumberOfUnitsToTranslatePlumeAndVolumeDown=0

	TripTime=2.f
	EjectionVelocity=(Z=1000.f)
	SuckInInterpSpeed=5.f//1500.f
}