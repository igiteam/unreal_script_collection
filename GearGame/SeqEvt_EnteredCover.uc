/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqEvt_EnteredCover extends SequenceEvent
   	native(Sequence);

cpptext
{
	UBOOL RegisterEvent();
}

defaultproperties
{
	ObjName="Entered Cover"
	ObjCategory="Misc"
}
