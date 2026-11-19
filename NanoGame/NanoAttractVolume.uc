/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoAttractVolume extends NanoPhysicsVolume
	implements(NanoInterface_Attraction)
	native;

/** Actor to move any touching actors towards */
var() Actor AttractActor;
/** If specified the actor will be attracted to the cloest point on the line between this and AttractActor */
var() Actor AttractActor_End;

/** If TRUE only affect actors in PHYS_Falling */
var() bool bOnlyAffectFalling;

/** How quickly to move the actors towards the AttractActor */
var() float AttractStrength;

native function vector GetZoneVelocityForActor(Actor TheActor);

simulated function bool ShouldAttractActor(Actor TestActor)
{
	if (!bOnlyAffectFalling || (TestActor.Physics == PHYS_Falling && TestActor.Velocity.Z <= 0))
	{
		return TRUE;
	}
	return FALSE;
}

simulated function Actor GetAttractionActor()
{
	if (AttractActor != None)
	{
		return AttractActor;
	}
	//@todo - figure out a way to handle the line attraction if AttractActor_End != None
	return self;
}

simulated event vector GetAttractionLocationOffset();

simulated function bool AttractingPawn(NanoPawn NP);

defaultproperties
{
	AttractStrength=24.f
	bOnlyAffectFalling=TRUE
}
