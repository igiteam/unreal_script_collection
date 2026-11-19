/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ModifyNanoTargetPoint extends SequenceAction;


/** Whether or not this TargetPoint is active. **/
var() bool bIsActive;


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 3;
}



defaultproperties
{
	ObjName="Modify Nano Target Point"
	ObjCategory="Nano Procedural"


	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="NanoTargetPoint",PropertyName=Targets)
}