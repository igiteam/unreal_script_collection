/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ControlNanoMovie extends SeqAct_ControlGameMovie;


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 3;
}

defaultproperties
{
	ObjName="Control Nano Movie"
	ObjCategory="Cinematic"
} 
