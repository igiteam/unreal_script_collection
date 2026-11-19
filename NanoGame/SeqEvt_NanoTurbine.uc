/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * Events relating to the nano turbine
 */
class SeqEvt_NanoTurbine extends SequenceEvent;

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 0;
}

defaultproperties
{
	ObjName="Nano Turbine"
	ObjCategory="Nano"

	OutputLinks(0)=(LinkDesc="Grabbed")
	OutputLinks(1)=(LinkDesc="Launched")

	bPlayerOnly=FALSE
	MaxTriggerCount=0
}
