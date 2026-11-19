/**
 * This class is the base class for the shotgun damage type.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_Shotgun extends GDT_Ballistic
	config(Weapon);

/** Overridden to eliminate headshots at a distance */
static function ModifyDamage(Pawn Victim, Controller InstigatedBy, out int Damage, const out TraceHitInfo HitInfo, vector HitLocation, vector Momentum, Actor DamageCauser)
{
	local int PreModifyDamage;
	local GearPawn GP;

	PreModifyDamage = Damage;
	Super.ModifyDamage(Victim, InstigatedBy, Damage, HitInfo, HitLocation, Momentum, DamageCauser);
	GP = GearPawn(Victim);
	if (GP != None && GP.bLastHitWasHeadShot)
	{
		if (InstigatedBy == None || InstigatedBy.Pawn == None || VSize2D(InstigatedBy.Pawn.Location - GP.Location) > default.MaxGibDistance)
		{
			GP.bLastHitWasHeadShot = false;
			Damage = PreModifyDamage;
		}
	}
}

/** Overridden to add a blood effect to the victim's camera */
static function HandleDamageFX(GearPawn DamagedPawn, const out TakeHitInfo HitInfo)
{
	local GearPC PC;

	Super.HandleDamageFX(DamagedPawn, HitInfo);

	if ( DamagedPawn.WorldInfo.GRI.ShouldShowGore() && HitInfo.InstigatedBy != None && HitInfo.Damage >= 600 &&
		DamagedPawn.DefaultHealth >= 600 && DamagedPawn.Health <= 0 &&
		DamagedPawn.ShotgunCameraLensEffectTemplate != None &&
		!DamagedPawn.IsA('Vehicle') && !DamagedPawn.IsA('GearPawn_SilverbackBase') &&
		VSize(HitInfo.InstigatedBy.Location - DamagedPawn.Location) <= default.MaxGibDistance )
	{
		PC = DamagedPawn.GetPC();
		if (PC != None && LocalPlayer(PC.Player) != None)
		{
			PC.ClientSpawnCameraLensEffect(DamagedPawn.ShotgunCameraLensEffectTemplate);
		}
		PC = GearPC(HitInfo.InstigatedBy.Controller);
		if (PC != None && LocalPlayer(PC.Player) != None)
		{
			PC.ClientSpawnCameraLensEffect(DamagedPawn.ShotgunCameraLensEffectTemplate);
		}
	}
}

defaultproperties
{
	ImpactTypeBallisticID=ITB_Gnasher
	KDamageImpulse=200
	KDeathUpKick=250
	KilledByIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=78,V=90,UL=77,VL=29)
	WeaponID=WC_Gnasher
	OnDamageCameraShakeScale=1.f
}
