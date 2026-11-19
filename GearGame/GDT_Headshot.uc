/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_Headshot extends GDT_Ballistic;


/** force a headshot and force the pawn to take enough damage to kil them hopefully **/
static function ModifyDamage(Pawn Victim, Controller InstigatedBy, out int Damage, const out TraceHitInfo HitInfo, vector HitLocation, vector Momentum, Actor DamageCauser)
{
	local GearPawn GP;

	Super.ModifyDamage(Victim, InstigatedBy, Damage, HitInfo, HitLocation, Momentum, DamageCauser);

	// always say we were hit with a head shot
	GP = GearPawn(Victim);
	if (GP != None)
	{
		Damage = GP.default.DefaultHealth * 10.0; // kill them!!
		GP.bLastHitWasHeadShot = true;
	}
}


static function bool ShouldHeadShotGib(Pawn TestPawn, Pawn Instigator)
{
	return true;
}

static function bool IsScriptedDamageType()
{
	return true;
}

defaultproperties
{
	KDamageImpulse=100
	WeaponID=WC_Longshot
}

