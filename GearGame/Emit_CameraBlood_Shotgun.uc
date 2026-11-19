/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class Emit_CameraBlood_Shotgun extends Emit_CameraLensEffectBase
	config(Weapon);



defaultproperties
{
	PS_CameraEffect=ParticleSystem'CameraBlood.FX.P_ShotgunBlood'
	PS_CameraEffectNonExtremeContent=none
	bAllowMultipleInstances=TRUE
}



