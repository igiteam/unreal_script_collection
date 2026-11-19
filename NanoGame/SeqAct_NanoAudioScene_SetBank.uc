/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_NanoAudioScene_SetBank extends SequenceAction;


/** The new bank to have the NanoResponseSystemAudio utilize. **/
var() NanoAudioSceneBank NewBank;


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

/**
 * Called when this event is activated.
 */
event Activated()
{
	NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).NASM.ActiveBank = NewBank;
}



defaultproperties
{
	ObjName="Nano Audio Scene Set Bank"
	ObjCategory="Nano Procedural"

	bCallHandler=FALSE

	VariableLinks.Empty()
}
