/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_GunkerDeathExplode extends GDT_Explosive;

defaultproperties
{
	ImpactTypeExplosionID=ITE_GunkerGunk
	KDamageImpulse=200
	RadialDamageImpulse=400
	bRadialDamageVelChange=TRUE
	KDeathUpKick=400
	KilledByIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=0,V=180,UL=77,VL=29)
	bEnvironmentalDamage=FALSE
	bSuppressPlayExplosiveRadialDamageEffects=TRUE
	WeaponID=WC_Boomshot
}
