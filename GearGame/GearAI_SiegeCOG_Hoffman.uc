/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAI_SiegeCOG_Hoffman extends GearAI_SiegeCOG;

var float LastHODAnnounceTime;

function NotifyHODThreat(Pawn Shooter, vector TargetingLocation)
{
	Super.NotifyHODThreat(Shooter, TargetingLocation);

	if (Shooter == MyGearPawn && MyGearPawn != None && WorldInfo.TimeSeconds - LastHODAnnounceTime > 10.0)
	{
		GearPawn_COGGear(MyGearPawn).AnnounceShot();
		LastHODAnnounceTime = WorldInfo.TimeSeconds;
	}
}

defaultproperties
{
	bCanActivateFortifications=true
}
