/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoCrowd_Civilian extends NanoCrowd_Pedestrian
		implements( NanoInterface_CanAffectChaos )
		placeable;



defaultproperties
{
	DodgeVel=500.0
	
	PanicBehaviors(0)=(BehaviorArchetype=Nano_Proto_Crowd.Behaviors.RunFromPanic)
}