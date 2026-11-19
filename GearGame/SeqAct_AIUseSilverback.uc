
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_AIUseSilverback extends SequenceAction;

/** AI should teleport and attach to Silverback instead of running to it */
var() bool bTeleportToSilverback;
var() GearPawn_SilverbackBase Silverback;

defaultproperties
{
	ObjName="AI: Use Silverback"
	ObjCategory="AI"

	InputLinks(0)=(LinkDesc="Enter")
	InputLinks(1)=(LinkDesc="Exit")

	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Silverback",PropertyName=Silverback)
}
