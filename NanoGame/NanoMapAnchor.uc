/** 
 *	Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 *	Used to indicate top-left and bottom-right corner of world.
 *	TopLeft (NW) Max X, Min Y
 *	BottomRight (SE) Min X, Max Y
 */

class NanoMapAnchor extends Info	
	placeable;

/** Indicates which corner this anchor marks */
var() enum ENanoMapCorner
{
	MC_TopLeft_NW_MaxX_MinY,
	MC_BottomRight_SE_MinX_MaxY
} Corner;


/** Whether or not this is the default map anchor **/
var() bool bDefaultMapAnchor;

defaultproperties
{
	Begin Object NAME=Sprite
		Sprite=Texture2D'EditorResources.S_Keypoint'
	End Object
	
	bEdShouldSnap=true

	bDefaultMapAnchor=TRUE
}
