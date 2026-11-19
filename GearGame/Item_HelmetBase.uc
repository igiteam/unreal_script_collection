/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class Item_HelmetBase extends ItemSpawnable
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
		// Must be for the head and you can't be wearing any face pieces
		if (Slot == eATTACHTYPE_Helmet 
			&& (Infantry.AttachmentClasses[eATTACHTYPE_Face] == None 
				|| Infantry.AttachmentClasses[eATTACHTYPE_Face] == class'ItemSpawnable'
				|| Infantry.AttachmentClasses[eATTACHTYPE_Face] == class'Item_Face_None' ) 
			)
		{
			return True;
		}
	}
	return False;
}

defaultproperties
{
	// Locust_Grunt.Emissive.Geist_Grunt_EmissivehelmetRED_Mat: New Red Helmet Shader
    BeingShotOffSound=SoundCue'Foley_BodyMoves.BodyMoves.Helmet_RipOffGameyBCue' // 'Foley_BodyMoves.BodyMoves.Helmet_RipOffCue'
	ImpactingGround=SoundCue'Foley_BodyMoves.BodyMoves.Helmet_ImpactCue'
}



