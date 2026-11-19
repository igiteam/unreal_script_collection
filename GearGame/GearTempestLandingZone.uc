
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearTempestLandingZone extends NavigationPoint
	native
	placeable;
	
var float CylinderHeight;
var float CylinderRadius;

cpptext
{
	virtual void Validate();
}


defaultproperties
{
	Begin Object Name=Sprite
		Sprite=Texture2D'EditorResources.S_Thruster'
	End Object
	
	Begin Object Name=CollisionCylinder
		CollisionRadius=+0000.000000
		CollisionHeight=+0000.000000
	End Object
	
	CylinderHeight=700
	CylinderRadius=400
	
	
	//Component that draws the special debug lines
	Begin Object Class=TempestLandingZoneRenderingComponent Name=SpawnRenderer
	End Object
	Components.Add(SpawnRenderer)
}