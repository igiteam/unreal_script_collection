/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_BloodyLyrikHands extends SequenceAction;


/** Whether or not the hands should be bloodied**/
var() bool bShouldBloodyHands;


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 4;
}


defaultproperties
{
	ObjName="Bloody Lyrik Hands"
	ObjCategory="Nano"

	bShouldBloodyHands=TRUE
}