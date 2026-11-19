/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class ThrashballMantleVolume extends TriggerVolume
	placeable;

var() Rotator MantleRotation;
var transient float LastTimeSpecialMoveTriggered;
var float           SpecialMoveTriggerTimeInterval;

event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	local GearPawn_COGGear GP;

	GP = GearPawn_COGGear(Other);
	// like to make sure it doesn't retrigger if it didn't pass through volume yet
	if( GP != None && GP.IsDoingSpecialMove( SM_RoadieRun ) && WorldInfo.TimeSeconds - LastTimeSpecialMoveTriggered > SpecialMoveTriggerTimeInterval)
	{
		GP.ServerDoSpecialMove( SM_MidLvlJumpOver, TRUE );
		LastTimeSpecialMoveTriggered = WorldInfo.TimeSeconds;
	}	

	Super.Touch( Other, OtherComp, HitLocation, HitNormal );
}


defaultproperties
{
	SpecialMoveTriggerTimeInterval = 3.f
}
