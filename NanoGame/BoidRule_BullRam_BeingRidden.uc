/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class BoidRule_BullRam_BeingRidden extends BoidMovementRule within NanoAI
	native(AI)
    config(AI);


var config float FarDistance;
var config float NearDistance;

var config float AmountYouCanSteer;


cpptext
{
	virtual void ModifyPawnVelocity( ANanoPawnBase* P, FLOAT DeltaTime );
}

defaultproperties
{
}