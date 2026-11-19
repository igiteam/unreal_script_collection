/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoCrowd_PanicRepulsor extends GameCrowdRepulsor;

event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	local NanoCrowd_PedestrianBase Agent;
	
	Agent = NanoCrowd_PedestrianBase(Other);
	if ( Agent != None )
	{
		Agent.SetPanic(self, true);
	}
	super.Touch(Other, OtherComp, HitLocation, HitNormal);
}

defaultproperties
{
	bNoDelete=false

	Begin Object NAME=CollisionCylinder
		CollisionRadius=+1500.000000
	End Object
	
}
