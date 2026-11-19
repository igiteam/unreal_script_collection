/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
/** special Lancer used by the Onyx Guard in Siege. Extra damage, ignores most resistances, special visuals */
class GearWeap_AssaultRifle_OnyxGuard extends GearWeap_AssaultRifle;

simulated function ProcessInstantHit(byte FiringMode, ImpactInfo Impact, optional int NumHits)
{
	local GearPawn GP;

	// onyx guard rifle damage ignores most mitigation effects
	GP = GearPawn(Impact.HitActor);
	if (GP != None)
	{
		GP.SetDontModifyDamage(true);
	}
	Super.ProcessInstantHit(FiringMode, Impact, NumHits);
	if (GP != None)
	{
		GP.SetDontModifyDamage(false);
	}
}

defaultproperties
{
	InstantHitDamageTypes(0)=class'GDT_AssaultRifle_OnyxGuard'
	TracerType=WTT_LancerOnyxGuard
	TracerTypeAR=WTT_LancerOnyxGuard
}
