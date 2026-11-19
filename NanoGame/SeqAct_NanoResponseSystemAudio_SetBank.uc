/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_NanoResponseSystemAudio_SetBank extends SequenceAction;


/** The new bank to have the NanoResponseSystemAudio utilize. **/
var() NanoResponseSystemAudioBank NewBank;


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

/**
 * Called when this event is activated.
 */
event Activated()
{
	NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).NRSAM.ActiveBank = NewBank;
}



defaultproperties
{
	ObjName="Nano Response System Audio Set Bank"
	ObjCategory="Nano Procedural"

	bCallHandler=FALSE

	VariableLinks.Empty()
}
