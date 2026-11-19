/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class Emit_Camera_WaterSplashLarge extends Emit_CameraLensEffectBase
	config(Weapon);


defaultproperties
{
	PS_CameraEffect=ParticleSystem'CameraBlood.FX.P_Water_Splash_Large'
	PS_CameraEffectNonExtremeContent=ParticleSystem'CameraBlood.FX.P_Water_Splash_Large'
	bAllowMultipleInstances=TRUE
}



