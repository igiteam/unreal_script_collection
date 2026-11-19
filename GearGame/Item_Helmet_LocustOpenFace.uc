/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class Item_Helmet_LocustOpenFace extends Item_HelmetBase;

//Overridden to allow face pieces
simulated static function bool IsCompatible(GearPawn_Infantry Infantry, EAttachmentType Slot)
{
	if (Super(ItemSpawnable).IsCompatible(Infantry,Slot))
	{
		// Must be for the head and you CAN be wearing any face pieces except the up goggles
		if (Slot == eATTACHTYPE_Helmet
			&&  Infantry.AttachmentClasses[eATTACHTYPE_Face] != class'Item_Face_LocustGogglesUp') 
		{
			return True;
		}
	}
	return False;
}

defaultproperties
{
	SpawnableData=( AttachSocketName="Head", TheMesh=StaticMesh'Locust_Grunt.locust_grunt_helmet_soc_none' )
}



