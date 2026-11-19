/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_PolypSpit extends GDT_Explosive;

defaultproperties
{
	ImpactTypeExplosionID=ITE_DrudgeSpit
	KDamageImpulse=100
	RadialDamageImpulse=400
	bRadialDamageVelChange=TRUE
	KDeathUpKick=400
	KilledByIcon=(Texture=Texture2D'Warfare_HUD.HUD.Gears_DeathIcons',U=0,V=180,UL=77,VL=29)
	bEnvironmentalDamage=FALSE
	bSuppressPlayExplosiveRadialDamageEffects=TRUE
}
