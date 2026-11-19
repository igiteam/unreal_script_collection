
/**
 * KActor_SilverbackLoaderCrate
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class KActor_SilverbackLoaderCrateBase extends GearKActor
	native
	abstract;

cpptext
{
	/**
	 * Don't do any of the KActor::ShouldTrace, it creates problems getting into a silverback holding a large crate
	 * 
	 * @param Primitive - the primitive to trace against
	 * 
	 * @param SourceActor - the actor doing the trace
	 * 
	 * @param TraceFlags - misc flags describing the trace
	 *
	 * @return TRUE if the trace should happen
	 */
	virtual UBOOL ShouldTrace(UPrimitiveComponent* Primitive, AActor *SourceActor, DWORD TraceFlags);
}

var() CylinderComponent CollisionCylinder;

/** True if this object can be picked up by the loader, false otherwise */
var() bool bEnabled;

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
}

simulated event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	local GearPawn_SilverbackLoaderBase SilverbackLoader;

	SilverbackLoader = GearPawn_SilverbackLoaderBase(Other);
	if( SilverbackLoader != None && bEnabled )
	{
		SilverbackLoader.TouchingCrate = Self;
	}
}

simulated event UnTouch( Actor Other )
{
	local GearPawn_SilverbackLoaderBase SilverbackLoader;

	SilverbackLoader = GearPawn_SilverbackLoaderBase(Other);
	if( SilverbackLoader != None )
	{
		SilverbackLoader.TouchingCrate = None;
	}
}

/** Toggles the ability to pick up the object */
simulated function OnToggle(SeqAct_Toggle Action)
{
	local GearPawn_SilverbackLoaderBase SilverbackLoader;

	Super.OnToggle(Action);

	// Turn ON
	if( Action.InputLinks[0].bHasImpulse )
	{
		bEnabled = TRUE;
	}
	// Turn OFF
	else if( Action.InputLinks[1].bHasImpulse )
	{
		bEnabled = FALSE;
	}
	// Toggle
	else if( Action.InputLinks[2].bHasImpulse )
	{
		bEnabled = !bEnabled;
	}

	// If we're enabled, give any touching loader's a reference to us
	if( bEnabled )
	{
		foreach TouchingActors(class'GearPawn_SilverbackLoaderBase', SilverbackLoader)
		{
			SilverbackLoader.TouchingCrate = self;
		}
	}
	// If we're disabled, remove any touching loader's reference to us
	else
	{
		foreach TouchingActors(class'GearPawn_SilverbackLoaderBase', SilverbackLoader)
		{
			SilverbackLoader.TouchingCrate = None;
		}
	}
}

defaultproperties
{
	bPathColliding=false
	bEnabled=true
	Physics=PHYS_None

	Begin Object Class=CylinderComponent NAME=CollisionCylinder0
		CollisionRadius=+00100.000000
		CollisionHeight=+00020.000000
		CollideActors=true
		HiddenGame=FALSE
	End Object
	Components.Add(CollisionCylinder0)
	CollisionCylinder=CollisionCylinder0

	SupportedEvents.Add(class'SeqEvent_LoaderCratePickedUp')
}
