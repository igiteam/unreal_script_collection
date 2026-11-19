/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoProj_EMP_NoNanoDrain extends NanoProj_EMP;


defaultproperties
{
	TrailTemplate=ParticleSystem'Nano_WeaponFX.Missile.Effects.P_FX_MissileContrail_White_Cheap'
  	ProximitySound=SoundCue'Weapon_MetaRocket.MetaRocket.MetaRocket_WhizByCue'
	InFlightSoundTemplate=SoundCue'Weapon_MetaRocket.MetaRocket.MetaRocket_InAir_LoopCue'
	EMPImpactSound=SoundCue'Weapon_MetaRocket.MetaRocket.MetaRocket_Impact_StereoCue'
	FireSound=SoundCue'Weapon_MetaRocket.MetaRocket.MetaRocket_FireCue'
	HitWallImpactEffect=ParticleSystem'Nano_WeaponFX.EMP.Effects.P_Nano_FX_EMPImpact_NoElec' 
}
