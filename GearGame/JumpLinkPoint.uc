/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class JumpLinkPoint extends KeyPoint
	notplaceable
	native(AI);

/** Sprite to use when this is a start point */
var SpriteComponent StartPointSprite;
/** Sprite to use when this is an end point */
var SpriteComponent EndPointSprite;

cpptext
{
	virtual void PostEditMove(UBOOL bFinished);
}

defaultproperties
{
	Begin Object Name=Sprite
		Sprite=Texture2D'EditorMaterials.JumpLinkStartPoint'
		HiddenEditor=True
		Scale=0.5
	End Object
	StartPointSprite=Sprite

	Begin Object Class=SpriteComponent Name=SpriteEnd
		Sprite=Texture2D'EditorMaterials.JumpLinkEndPoint'
		HiddenGame=True
		HiddenEditor=True
		AlwaysLoadOnClient=False
		AlwaysLoadOnServer=False
		Scale=0.5
	End Object
	Components.Add(SpriteEnd)
	EndPointSprite=SpriteEnd

	Begin Object Class=CylinderComponent Name=CollisionCylinder
		CollisionRadius=+0050.000000
		CollisionHeight=+0080.000000
	End Object
	CollisionComponent=CollisionCylinder
	Components.Add(CollisionCylinder)

	Begin Object Class=JumpLinkRenderingComponent Name=JumpLinkRenderingComponent0
	End Object
	Components.Add(JumpLinkRenderingComponent0)

	bStatic=false
	bNoDelete=true
	bMovable=true
	bHidden=false
}