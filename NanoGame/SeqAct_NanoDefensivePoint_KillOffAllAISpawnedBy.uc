/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_NanoDefensivePoint_KillOffAllAISpawnedBy extends SequenceAction;




static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 3;
}



defaultproperties
{
	ObjName="NanoDefensivePoint Kill Off All AI Spawned By"
	ObjCategory="Nano Procedural"


	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="NanoDefensivePoint",PropertyName=Targets)
}