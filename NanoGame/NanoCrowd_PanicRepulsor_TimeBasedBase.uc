/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoCrowd_PanicRepulsor_TimeBasedBase extends GameCrowdRepulsor
	config(Game)
	abstract;

/** how big the panic radius is for this crowd repulsor **/
var config float RadiusOfPanic;

/** Duration of how long this repulsor will last **/
var config float DurationOfPanic;


event PostBeginPlay()
{
	Super.PostBeginPlay();

	CylinderComponent.SetCylinderSize( RadiusOfPanic, 200.0f );


	if( DurationOfPanic > 0.0f )
	{
		SetTimer( DurationOfPanic, FALSE, nameof(DestroySelf) );
	}

}


function DestroySelf()
{
	LifeSpan = 0.001f;
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



