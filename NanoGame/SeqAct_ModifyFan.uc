/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ModifyFan extends SequenceAction
		dependson(NanoFanBase);


/** The new fan speed **/
var() EFanSpeed FanSpeed;

/** Over how long to interp to that speed **/
var() float InterpSpeed;


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}



defaultproperties
{
	ObjName="Modify Fan"
	ObjCategory="Nano"

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="NanoFanBase",PropertyName=Targets)

	FanSpeed=FS_Off
	InterpSpeed=1.0f
}
