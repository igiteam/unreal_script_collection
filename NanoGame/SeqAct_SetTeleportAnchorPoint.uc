/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_SetTeleportAnchorPoint extends SequenceAction;

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

defaultproperties
{
	ObjName="Set Teleport Anchor Point"
	ObjCategory="Nano"
}