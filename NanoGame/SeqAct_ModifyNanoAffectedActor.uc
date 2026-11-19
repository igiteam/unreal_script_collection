/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ModifyNanoAffectedActor extends SequenceAction;


/** This is the state which this kismet action will set the targeted actor to.  If that actor implements NanoInterface_PowerAffect **/
var() ENanoState NanoStateToBe;



defaultproperties
{
	ObjName="Modify Nano State"
	ObjCategory="Nano"

}