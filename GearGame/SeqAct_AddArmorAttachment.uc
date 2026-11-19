
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class SeqAct_AddArmorAttachment extends SequenceAction;

/** Armor slot to attach to */
var()	EAttachmentType	ArmorSlot;
/** Type of armor to attach */
var() class<ItemSpawnable> AttachmentType;

defaultproperties
{
	ObjName="Add Armor Attachment"
	ObjCategory="Gear"
}