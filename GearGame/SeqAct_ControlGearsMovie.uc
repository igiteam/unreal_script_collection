/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ControlGearsMovie extends SeqAct_ControlGameMovie;


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

defaultproperties
{
	ObjName="Control Gears Movie"
	ObjCategory="Cinematic"

} 
