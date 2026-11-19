/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqEvent_CommandCenter extends SequenceEvent;

/** upgrade level of the fortification that triggered this event */
var int UpgradeLevel;

event Activated()
{
	UpgradeLevel = GearFortificationMarker(Originator).SpawnedFortification.UpgradeLevel;
}

defaultproperties
{
	ObjName="Command Center Triggered"
	ObjCategory="Gear"

	bAutoActivateOutputLinks=true
	MaxTriggerCount=0

	VariableLinks[1]=(ExpectedType=class'SeqVar_Int',LinkDesc="Upgrade Level",bWriteable=true,PropertyName=UpgradeLevel)
}
