/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_DrudgeSpit extends GDT_Explosive;

var() protected const class<Emit_CameraLensEffectBase> LensEffectClass;

/** Overridden to enforce default gibbing for explosive damage. */
static function bool ShouldGib(Pawn TestPawn, Pawn Instigator)
{
	return FALSE;
}

/** Overridden to add camera effect. */
static function HandleDamageFX(GearPawn DamagedPawn, const out TakeHitInfo HitInfo)
{
	local GearPC PC;
	Super.HandleDamageFX(DamagedPawn,HitInfo);

	if (DamagedPawn.IsHumanControlled())
	{
		// spawn camera lens effect
		PC = DamagedPawn.GetPC();
		if (PC != None)
		{
			PC.ClientSpawnCameraLensEffect(default.LensEffectClass);
		}
	}
}

defaultproperties
{
	ImpactTypeExplosionID=ITE_DrudgeSpit
	LensEffectClass=class'Emit_Camera_PolypSplat'
	KDamageImpulse=100
	RadialDamageImpulse=400
	bRadialDamageVelChange=TRUE
	KDeathUpKick=400
	KilledByIcon=(Texture=Texture2D'Warfare_HUD.HUD.Gears_DeathIcons',U=0,V=180,UL=77,VL=29)
	bEnvironmentalDamage=FALSE
	bSuppressPlayExplosiveRadialDamageEffects=TRUE
	bCausesShieldDrop=false
	WeaponID=WC_Boomshot
}
