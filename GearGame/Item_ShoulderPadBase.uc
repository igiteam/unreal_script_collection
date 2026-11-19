/**
 * NOTE:  for the AttachSocketName we use the base part of the name which does not include the 'left' or 'right' suffix
 * (e.g. armorupperarm instead of armorupperarmleft)  Then in the function to attach to the specifc arm we append 'left' or 'right'
 * So: this means content need to make their shoulderpads work on either left or right of the mesh
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class Item_ShoulderPadBase extends ItemSpawnable
	abstract;

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
		// Must be for the shoulder
		if (Slot == eATTACHTYPE_ShoulderLeft || Slot == eATTACHTYPE_ShoulderRight )
		{
			return True;
		}
	}
	return False;
}


defaultproperties
{
	ImpactingGround=SoundCue'Foley_BodyMoves.BodyMoves.Helmet_ImpactCue'
}
