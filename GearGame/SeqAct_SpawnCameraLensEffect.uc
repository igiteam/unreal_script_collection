/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_SpawnCameraLensEffect extends SequenceAction
	native(Sequence);

/** This is the CameraLensEffect to spawn on the player(s) attached. **/
var() class<Emit_CameraLensEffectBase> LensEffectToSpawn;


defaultproperties
{
	ObjName="Screen Effect"
	ObjCategory="Camera"
}
