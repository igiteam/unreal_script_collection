/**
 * Hammerburst for Reaver riders
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearWeap_LocustAssaultRifle_Reaver extends GearWeap_LocustAssaultRifle;

var float TracerAdvance;

/**
 * Generate the tracer effect for the weapon
 *
 * @param bIsActiveReload - whether this is an active reload shot or not
 * @param bIsLocalPlayer - whether this is a local player or not
 * @param SpawnLocation - tracer originates here
 * @param SpawnRotation - tracer orientation
 * @param TargetLoc - where the tracer is ending up
 * @param InInstigator - optional actor that triggered this
 *
 * @return the projectile that is the tracer
 */
simulated static function GearProj_BulletTracer GetTracer(bool bIsActiveReload, bool bIsLocalPlayer, vector SpawnLocation, rotator SpawnRotation, vector TargetLoc,optional Actor InInstigator)
{
	local WorldInfo WI;
	local GearProj_BulletTracer NewTracer;

	if( InInstigator.Base != None )
	{
		WI = class'Engine'.static.GetCurrentWorldInfo();
		NewTracer = GearEmitterPool(WI.MyEmitterPool).SpawnTracer(default.TracerType, SpawnLocation + (InInstigator.Velocity * default.TracerAdvance), SpawnRotation, TargetLoc, bIsLocalPlayer, TargetLoc);
		NewTracer.bAllowTracersMovingFromTarget = true;
	}
	else
	{
		return Super.GetTracer(bIsActiveReload, bIsLocalPlayer, SpawnLocation, SpawnRotation, TargetLoc, InInstigator);
	}

	return NewTracer;
}

defaultproperties
{
	TracerType=WTT_Hammerburst_Reaver
	TracerTypeAR=WTT_Hammerburst_Reaver

	TracerAdvance=1
	bAlwaysSpawnTracerSmoke=false
}