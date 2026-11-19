
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GDT_CorpserLarvaMelee extends GDT_Explosive;

defaultproperties
{
	ImpactTypeExplosionID=ITE_CorpserLarvaMelee
	KilledByIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=69,V=349,UL=77,VL=29)

	BRadialDamageVelChange=TRUE

	KDamageImpulse=200
	KDeathUpKick=250
	KDeathVel=200
	RadialDamageImpulse=100
	bEnvironmentalDamage=FALSE
	bPlayDamagedEnemyHeavyGUD=FALSE
}
