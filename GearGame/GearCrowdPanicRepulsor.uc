/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearCrowdPanicRepulsor extends GameCrowdRepulsor
	native;

/** Radius within which to cause panic */
var() float PanicRadius;
/** Minimum delay between radius checks for causing panic */
var() float MinCausePanicInterval;

/** Last time we did a radius check for causing panic */
var transient float LastCausePanicTime;

simulated native function CausePanic();

defaultproperties
{
	bNoDelete=false
	PanicRadius=1500.f
	MinCausePanicInterval=1.0f;

	Begin Object NAME=CollisionCylinder
		CollideActors=false
	End Object
}
