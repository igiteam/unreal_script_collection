/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ModifyAudioScene extends SequenceAction;

/** Whether or not the Audio Scene is active **/
var() bool bIsActive;


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 50;
}


/**
 * Called when this event is activated.
 */
event Activated()
{
	NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).NASM.bActive = bIsActive;
}



defaultproperties
{
	ObjName="Modify Audio Scene"
	ObjCategory="Nano Procedural"

    bCallHandler=FALSE
	VariableLinks.Empty()
}