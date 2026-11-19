/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoAttractVolume_Spawnable extends NanoAttractVolume
	native;

var	CylinderComponent	CylinderComp;

defaultproperties
{
	Components.Remove(BrushComponent0)	
	
	Begin Object Class=CylinderComponent NAME=CylinderComp0
		HiddenGame=FALSE	
		CollideActors=TRUE
		BlockActors=FALSE
		BlockZeroExtent=FALSE
		BlockNonZeroExtent=TRUE
		CollisionRadius=+0080.000000
		CollisionHeight=+0080.000000
	End Object
	BrushComponent=None
	CylinderComp=CylinderComp0
	CollisionComponent=CylinderComp0
	Components.Add(CylinderComp0)

	bHidden=FALSE	
	bHardAttach=TRUE
	bNoDelete=FALSE
	bPlaceableFromClassBrowser=TRUE
}
