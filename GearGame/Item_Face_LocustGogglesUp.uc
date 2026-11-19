/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class Item_Face_LocustGogglesUp extends Item_FaceBase;

//All helmets fail for this one
simulated static function bool IsCompatible(GearPawn_Infantry Infantry, EAttachmentType Slot)
{
	if (Infantry.AttachmentClasses[eATTACHTYPE_Helmet] != None 
		&& Infantry.AttachmentClasses[eATTACHTYPE_Helmet] != class'ItemSpawnable'
		&& Infantry.AttachmentClasses[eATTACHTYPE_Helmet] != class'Item_Helmet_None')
	{
		return False;
	}
	return Super.IsCompatible(Infantry,Slot);
}


defaultproperties
{
	SpawnableData=( AttachSocketName="Head", TheMesh=StaticMesh'Locust_Grunt.Mesh.Locust_Grunt_Goggles_UP_Mesh' )
	
	bCanBeShotOff=FALSE
}



