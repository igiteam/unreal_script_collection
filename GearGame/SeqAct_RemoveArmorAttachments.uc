
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class SeqAct_RemoveArmorAttachments extends SequenceAction;

// Choose armor attachment to be removed
var()	EAttachmentType	ArmorToRemove;

defaultproperties
{
	ObjName="Remove Armor Attachment"
	ObjCategory="Gear"
}