/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_InkGrenade extends GearDamageType;

var() protected const class<Emit_CameraLensEffectBase> LensEffectClass;

static function ModifyDamage(Pawn Victim, Controller InstigatedBy, out int Damage, const out TraceHitInfo HitInfo, vector HitLocation, vector Momentum, Actor DamageCauser)
{
	// ink doesn't hurt vehicles
	if (Vehicle(Victim) != None || GearPawnRidable_Base(Victim) != None)
	{
		Damage = 0;
	}
	// don't allow ink to execute in Horde regardless of distance to enemy
	else if ( GearPawn(Victim) != None && GearPawn(Victim).IsDBNO() &&
		(!Victim.WorldInfo.GRI.IsMultiplayerGame() || Victim.WorldInfo.GRI.IsCoopMultiplayerGame()) && Victim.GetTeamNum() == 0 )
	{
		Damage = 0;
	}
	Super.ModifyDamage(Victim, InstigatedBy, Damage, HitInfo, HitLocation, Momentum, DamageCauser);
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

static function bool ShouldIgnoreExecutionRules( Pawn TestPawn, Pawn Instigator )
{
	return true;
}

defaultproperties
{
	ImpactTypeExplosionID=ITE_GrenadeInk
	LensEffectClass=class'Emit_CameraInk'
	KilledByIcon=(Texture=Texture2D'Warfare_HUD.HUD.Gears_DeathIcons',U=0,V=90,UL=77,VL=29)
	KDamageImpulse=0.0

	bSuppressImpactFX=TRUE
	WeaponID=WC_InkGrenade
}
