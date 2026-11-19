/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoGrapplePointBase extends Keypoint
	implements(NanoInterface_Grapple)
	abstract
	placeable;

var() ParticleSystem                    PS_Ambient;
var transient ParticleSystemComponent   PSC_Ambient;

var() bool  bEnabled;

/** If TRUE, pressing A right before hitting the end of the grapple will perform a handspring mantle */
var() bool  bAllowActiveGrapple;

/** This velocity will be given to the pawn if they do an active grapple (and get this handspring boost) */
var() vector  ActiveGrappleVelocityBoost;

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	if( NanoGRI(WorldInfo.GRI) != None )
	{
		NanoGRI(WorldInfo.GRI).RegisterGrappleActor(self);
	}

	if( PS_Ambient != None )
	{
		PSC_Ambient = WorldInfo.MyEmitterPool.SpawnEmitter(PS_Ambient, Location, Rotation, self);
		PSC_Ambient.SetScale(4.f);
	}
}

event Destroyed()
{
	Super.Destroyed();

	if( PSC_Ambient != None )
	{
		PSC_Ambient.DeactivateSystem();
		PSC_Ambient = None;
	}
}

/** Is this actor currently able to be grappled? */
simulated function bool	IsGrapplable()
{
	return bEnabled;
}

/** Handling Toggle event from Kismet. */
simulated function OnToggle(SeqAct_Toggle Action)
{
	// Turn ON
	if (Action.InputLinks[0].bHasImpulse)
	{
		bEnabled = TRUE;
	}
	// Turn OFF
	else if (Action.InputLinks[1].bHasImpulse)
	{
		bEnabled = FALSE;
	}
	// Toggle
	else if (Action.InputLinks[2].bHasImpulse)
	{
		bEnabled = !bEnabled;
	}
}

simulated function vector GetGrappleLocation( NanoPawn Grappler )
{
	return Location;
}

/** If this returns TRUE, then NewRotation will be the target's desired rotation for the pawn */
simulated function bool ShouldOverrideDesiredRotation( NanoPawn Grappler, out rotator NewRotation, float DistanceToTarget );

/** Whether or not this location can be grapple to from above */
simulated function bool CanGrappleFromAbove()
{
	return FALSE;
}

simulated function GetGrappleAnims(bool bAboveTargetPoint, out name StartAnim, out name LoopAnim, out name EndAnim);

/** Called when someone begins grappling this actor */
simulated function NotifyBeginGrappled( NanoPawn Grappler );

/** Called when someone finishes grappling this actor */
simulated function NotifyEndGrappled( NanoPawn Grappler );

simulated function bool SupportsActiveGrapple()
{
	return bAllowActiveGrapple;
}

simulated function vector GetActiveGrappleVelocity()
{
	return ActiveGrappleVelocityBoost;
}

simulated function float GetMinimumGrappleDistance()
{
	return 0.f;
}

defaultproperties
{
	bStatic=FALSE
	bMovable=TRUE
	bTickIsDisabled=TRUE

	bEdShouldSnap=TRUE
	bEnabled=TRUE
	bAllowActiveGrapple=TRUE

	ActiveGrappleVelocityBoost=(Z=1500.f);
}