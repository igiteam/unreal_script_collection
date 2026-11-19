/**
 * Offer up a weapon for other players to take
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class OverheadMapLocation extends Note
	hidecategories(Note,Physics,Collision,Advanced,Attachment)
	perobjectconfig;

/** Location name to appear on overhead map */
var() localized string LocationName;

/** Which color to draw the text in */
var() color StringColor;

/** What scale to draw the text at */
var() float StringScale;

simulated event PostBeginPlay()
{
	local GearMapSpecificInfo GearMapInfo;

	Super.PostBeginPlay();

	GearMapInfo = GearMapSpecificInfo(WorldInfo.GetMapInfo());
	if (GearMapInfo == None)
	{
		// need a GearMapSpecificInfo for this to work
		GearMapInfo = new(None) class'GearMapSpecificInfo';
		WorldInfo.SetMapInfo(GearMapInfo);
	}
	GearMapInfo.MapLocations.AddItem(self);
}

defaultproperties
{
	StringColor=(R=255,G=255,B=0,A=255)
	StringScale=1.0
	bRouteBeginPlayEvenIfStatic=true
}
