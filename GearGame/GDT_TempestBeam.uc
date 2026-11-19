/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_TempestBeam extends GDT_Fire;


/** Don't do camera effect */
static function DoCameraEffect(GearPawn DamagedPawn);

defaultproperties
{
	ImpactTypeBallisticID=ITB_Tempest
	bSuppressImpactFX=FALSE
	KDamageImpulse=100
	bCausesFracture=TRUE
	bEnvironmentalDamage=FALSE
}
