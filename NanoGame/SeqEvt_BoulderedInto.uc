/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqEvt_BoulderedInto extends SequenceEvent
	native(Sequence);

/** Speed you must be moving to generate this event */
var()	EDashPip	BoulderDashPip;

cpptext
{
	virtual UBOOL CheckActivate(AActor *InOriginator, AActor *InInstigator, UBOOL bTest=FALSE, TArray<INT>* ActivateIndices = NULL, UBOOL bPushTop = FALSE);
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 0;
}

defaultproperties
{
	ObjName="Bouldered Into"
	ObjCategory="Nano"

	BoulderDashPip=EDP_Dash2

	bPlayerOnly=FALSE
}