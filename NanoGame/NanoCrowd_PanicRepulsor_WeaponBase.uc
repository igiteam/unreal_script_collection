/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoCrowd_PanicRepulsor_WeaponBase extends GameCrowdRepulsor
	config(Game)
	abstract;

/** how big the panic radius is for this crowd repulsor **/
var config float RadiusOfPanic;


event PostBeginPlay()
{
	Super.PostBeginPlay();

	CylinderComponent.SetCylinderSize( RadiusOfPanic, 200.0f );
}



event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	local NanoCrowd_PedestrianBase Agent;
	
	Agent = NanoCrowd_PedestrianBase(Other);
	
	if( Agent != None )
	{
		Agent.SetPanic(self, true);
	}
	
	Super.Touch(Other, OtherComp, HitLocation, HitNormal);
}

defaultproperties
{
	bNoDelete=FALSE

	Begin Object NAME=CollisionCylinder
		CollisionRadius=0.0f
		bDrawBoundingBox=TRUE
		HiddenGame=FALSE
	End Object
	
}
