/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_BrumakCannon extends GDT_Explosive;

defaultproperties
{
	ImpactTypeExplosionID=ITE_BrumakMainGun
	KDamageImpulse=100
	RadialDamageImpulse=750
	bRadialDamageVelChange=TRUE
	KDeathUpKick=400
	bEnvironmentalDamage=FALSE
	WeaponID=WC_BrumakRocketExplosion
	
	KilledByIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=0,V=180,UL=77,VL=29)
}
