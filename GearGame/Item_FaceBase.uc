/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class Item_FaceBase extends ItemSpawnable
	abstract;
/** Base class for face attachments */

/** Function to allow this item to determine if it is compatible with the other attachments on a gearpawn 
 *	@param Infantry	- The guy we want to check to see if this attachment is compatible with
 *	@param Slot - The attachment slot that this item is attempting to go into
 *	@return	Whether or not it is compatible
 *
 *	At this level it only checks to make sure that the slot it wants to go in is not already being used.
 */
simulated static function bool IsCompatible(GearPawn_Infantry Infantry, EAttachmentType Slot)
{
	if (Super.IsCompatible(Infantry,Slot))
	{
		// Must be for the face and you can't be wearing any helmets other than the ones specified below
		if (Slot == eATTACHTYPE_Face 
			&& (Infantry.AttachmentClasses[eATTACHTYPE_Helmet] == None 
				|| Infantry.AttachmentClasses[eATTACHTYPE_Helmet] == class'ItemSpawnable'
				|| Infantry.AttachmentClasses[eATTACHTYPE_Helmet] == class'Item_Helmet_None'
				|| Infantry.AttachmentClasses[eATTACHTYPE_Helmet] == class'Item_Helmet_LocustOpenFace' ) 
			)
		{
			return True;
		}
	}
	return False;
}

defaultproperties
{
	bCanBeShotOff=FALSE
}



