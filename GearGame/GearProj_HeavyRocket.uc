/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearProj_HeavyRocket extends GearProj_ExplosiveBase
	abstract;

/** after exploding, how long the smoke cloud stays around */
var config float SmokeCloudDuration;


simulated function GearExplosionActor TriggerExplosion(vector HitLocation, vector HitNormal, Actor HitActor)
{
	local Emit_SmokeGrenade Smoke;

	if (!bHasExploded && SmokeEmitterClass != None)
	{
		Smoke = Spawn(SmokeEmitterClass,,, HitLocation + HitNormal * 3.0, rotator(HitNormal));
		if (Smoke != None)
		{
			Smoke.bTriggeredByMartyr = false;
			Smoke.bTriggeredBySticky = false;
			Smoke.InstigatorController = InstigatorController;
			Smoke.SetEmissionDuration(SmokeCloudDuration);
		}
	}

	return Super.TriggerExplosion(HitLocation, HitNormal, HitActor);
}

defaultproperties
{
	Speed=3000.0
	MaxSpeed=3000.0
}
