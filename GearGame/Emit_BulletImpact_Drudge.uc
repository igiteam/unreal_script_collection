/** 
 * Blood Spray Emitter
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class Emit_BulletImpact_Drudge extends Emit_CameraLensEffectBase
	config(Weapon);


defaultproperties
{
	LifeSpan=3.f
	PS_CameraEffect=ParticleSystem'CameraBlood.FX.P_Locust_Lambent_Splatter'
	PS_CameraEffectNonExtremeContent=ParticleSystem'CameraBlood.FX.P_Locust_Lambent_Splatter'
	bAllowMultipleInstances=TRUE
}