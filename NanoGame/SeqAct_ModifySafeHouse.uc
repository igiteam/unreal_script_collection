/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ModifySafeHouse extends SequenceAction
		dependson(NanoTurbineBase);


/** Whether or not to unlock this safe house **/
var() bool bUnlocked;



static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}



defaultproperties
{
	ObjName="Modify Safe House"
	ObjCategory="Nano"

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Safe House",PropertyName=Targets)

}
