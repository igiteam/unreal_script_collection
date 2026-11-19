/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_FragGrenade extends GDT_Explosive;

defaultproperties
{
	ImpactTypeExplosionID=ITE_GrenadeFrag
	KilledByIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=78,V=120,UL=77,VL=29)

	BRadialDamageVelChange=TRUE

	KDamageImpulse=200
	KDeathUpKick=250
	KDeathVel=200
	RadialDamageImpulse=100
	bEnvironmentalDamage=FALSE
	WeaponID=WC_FragGrenade
}
