/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NAM_ExplosiveBullets extends NanoAmmoModifier;

struct ExplosiveBulletDatum
{
	/** Amount of extra damage to cause */
	var() float ExtraDamage;
	/** How much Z boost to give */
	var() ParticleSystem ExplosionPS;
};
var() config array<ExplosiveBulletDatum> ModLevel;

/** Returns max number of pips available for this modifier */
static function int GetMaxModLevel()
{
	return default.ModLevel.Length-1;
}

/** Returns max number of pips available for this modifier for the UI */
static function int GetMaxModLevelUI()
{
	return default.ModLevel.Length;
}

static function HandleAmmoImpact( int AmmoModLevel, Actor Victim, Controller InstigatedBy, out int Damage, vector HitLocation, TraceHitInfo HitInfo )
{
	Damage += default.ModLevel[AmmoModLevel].ExtraDamage;
	Victim.WorldInfo.MyEmitterPool.SpawnEmitter( default.ModLevel[AmmoModLevel].ExplosionPS, HitLocation, rot(0,0,0) );
}



defaultproperties
{
	WeaponsThisCanModify=(class'NanoWeap_MP7')
}