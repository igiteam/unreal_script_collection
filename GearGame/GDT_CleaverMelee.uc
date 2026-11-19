/**
 * Cleaver melee damage type
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_CleaverMelee extends GDT_Melee;

/** Cleaver melee should not gib */
static function bool ShouldGib(Pawn TestPawn, Pawn Instigator)
{
	return false;
}

/** Cleaver melee should not DBNO. */
static function bool ShouldDBNO(Pawn TestPawn, Pawn Instigator, vector HitLocation,TraceHitInfo HitInfo)
{
	return false;
}

/** Force a headshot and force the pawn to take enough damage to kill them hopefully */
static function ModifyDamage(Pawn Victim, Controller InstigatedBy, out int Damage, const out TraceHitInfo HitInfo, vector HitLocation, vector Momentum, Actor DamageCauser)
{
	local GearPawn GP;

	Super.ModifyDamage(Victim, InstigatedBy, Damage, HitInfo, HitLocation, Momentum, DamageCauser);

	// always say we were hit with a head shot if we have a head bone
	GP = GearPawn(Victim);
	if (GP != None && GP.HeadBoneNames.length > 0 && GP.Mesh.MatchRefBone(GP.HeadBoneNames[0]) != INDEX_NONE)
	{
		GP.bLastHitWasHeadShot = true;
	}
}

/** Force the head to gib */
static function bool ShouldHeadShotGib(Pawn TestPawn, Pawn Instigator)
{
	return true;
}

defaultproperties
{
	ImpactTypeBallisticID=ITB_CleaverMelee
	WeaponID=WC_Cleaver
}
