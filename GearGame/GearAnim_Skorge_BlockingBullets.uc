
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * GearAnim_Skorge_BlockingBullets
 */

class GearAnim_Skorge_BlockingBullets extends GearAnim_BlendList
	deprecated;

defaultproperties
{
	bFixNumChildren=TRUE
	Children(0)=(Name="Normal")
	Children(1)=(Name="BlockingBullets")

	ChildBlendInTime(0)=0.25
	ChildBlendInTime(1)=0.25
}
