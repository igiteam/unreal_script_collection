/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * Event mapped to controller input.
 */
class SeqEvt_NanoActionPerformed extends SequenceEvent
	native(Sequence);

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

defaultproperties
{
	ObjName="Nano Action Performed"
	ObjCategory="Nano"

	OutputLinks(0)=(LinkDesc="Jump")
	OutputLinks(1)=(LinkDesc="Triple Jump")
	OutputLinks(2)=(LinkDesc="Perform Tackle")
	OutputLinks(3)=(LinkDesc="Tackle Wall Smash")
	OutputLinks(4)=(LinkDesc="")
	OutputLinks(5)=(LinkDesc="Forge Gun") 
	OutputLinks(6)=(LinkDesc="Forge Sword") 
	OutputLinks(7)=(LinkDesc="Forge Ricochet Moon") 
	OutputLinks(8)=(LinkDesc="Holster") 

	OutputLinks(9)=(LinkDesc="Sword Attack High") 
	OutputLinks(10)=(LinkDesc="Sword Attack Low") 
	OutputLinks(11)=(LinkDesc="Sword Dash Attack") 
	OutputLinks(12)=(LinkDesc="Sword Block") 
	OutputLinks(13)=(LinkDesc="Wall Stab") 
	OutputLinks(14)=(LinkDesc="Car Dash Stab") 
	OutputLinks(15)=(LinkDesc="Fire Gun") 
	OutputLinks(16)=(LinkDesc="Perch Grab") 
	OutputLinks(17)=(LinkDesc="Perch Release")
	OutputLinks(18)=(LinkDesc="Hop to Car")

	bPlayerOnly=FALSE

	MaxTriggerCount=0
	ReTriggerDelay=0.01
}
