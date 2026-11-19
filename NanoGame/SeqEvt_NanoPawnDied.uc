/**
 * Activated when any NanoPawn (of the supplied class) dies.
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqEvt_NanoPawnDied extends SequenceEvent
	native(Sequence);

var() class<NanoPawnBase> DiedPawnClass<AllowAbstract>;


cpptext
{
    /** Overridden to write out the EntityThatDied var.  **/
	virtual UBOOL CheckActivate(AActor *InOriginator, AActor *InInstigator, UBOOL bTest=FALSE, TArray<INT>* ActivateIndices = NULL, UBOOL bPushTop = FALSE);

}


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}



defaultproperties
{
	DiedPawnClass=class'NanoPawn_MetaCorp_SentryBotBase'

	ObjName="NanoPawn Died"
	ObjCategory="Nano"


	bPlayerOnly=FALSE
	MaxTriggerCount=0

	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="EntityThatDied",bWriteable=true)
}