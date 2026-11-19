/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
 
class SeqAct_SetTrafficLightState extends SequenceAction;

/** State to change light into */
var() ETrafficLightState  NewState;

defaultproperties
{
	NewState=ETLS_Red

	ObjName="Set Traffic Light State"
	ObjCategory="Nano"
}