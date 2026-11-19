/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ModifyTurbine extends SequenceAction
		dependson(NanoTurbineBase);


/** The new fan speed **/
var() bool bIsActive;



static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}



defaultproperties
{
	ObjName="Modify Turbine"
	ObjCategory="Nano"

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="NanoFanBase",PropertyName=Targets)

	
}
