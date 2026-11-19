/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqEvt_ObstacleMantled extends SequenceEvent;

/** Wall normal where the mantle occurred */
var transient editconst Vector WallNormal;

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

defaultproperties
{
	ObjName="Obstacle Mantled"
	ObjCategory="Nano"
	
	VariableLinks(1)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Wall Normal",PropertyName=WallNormal,bWriteable=true)

	bPlayerOnly=FALSE
	
	MaxTriggerCount=0
}