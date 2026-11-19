/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearKelpStaticMeshActor extends StaticMeshActor;

simulated event PreBeginPlay()
{
	local GearMapSpecificInfo GearMapInfo;

	Super.PreBeginPlay();

	GearMapInfo = GearMapSpecificInfo(WorldInfo.GetMapInfo());
	if (GearMapInfo == None)
	{
		// need a GearMapSpecificInfo for this to work
		GearMapInfo = new(None) class'GearMapSpecificInfo';
		WorldInfo.SetMapInfo(GearMapInfo);
	}
	GearMapInfo.RegisterKelpStaticMesh(self);
}

defaultproperties
{
	bRouteBeginPlayEvenIfStatic=true
}
