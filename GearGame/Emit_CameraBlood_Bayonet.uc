/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class Emit_CameraBlood_Bayonet extends Emit_CameraLensEffectBase
	config(Weapon);


defaultproperties
{
	PS_CameraEffect=ParticleSystem'CameraBlood.FX.P_CameraBlood_Retro_Charge_Stab'
	PS_CameraEffectNonExtremeContent=none
	bAllowMultipleInstances=TRUE
}



