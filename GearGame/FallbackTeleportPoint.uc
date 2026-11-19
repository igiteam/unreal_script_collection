/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class FallbackTeleportPoint extends KeyPoint;

defaultproperties
{
	Begin Object Name=Sprite
		Sprite=Texture2D'GearsIcons.MeatflagIcon'
		Scale=0.35
	End Object

	Begin Object Class=ArrowComponent Name=Arrow
		ArrowColor=(R=150,G=200,B=255)
		ArrowSize=0.5
		bTreatAsASprite=TRUE
		HiddenGame=TRUE
		AlwaysLoadOnClient=FALSE
		AlwaysLoadOnServer=FALSE
	End Object
	Components.Add(Arrow)

	Begin Object Class=CylinderComponent Name=CollisionCylinder
		CollisionRadius=+0050.000000
		CollisionHeight=+0073.000000
	End Object
	CollisionComponent=CollisionCylinder
	Components.Add(CollisionCylinder)

	bStatic=FALSE
	bNoDelete=TRUE
	bMovable=TRUE

	bHidden=FALSE
}
