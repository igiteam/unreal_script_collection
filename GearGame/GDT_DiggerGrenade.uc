/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_DiggerGrenade extends GDT_Explosive
	abstract;

static function ModifyDamage(Pawn Victim, Controller InstigatedBy, out int Damage, const out TraceHitInfo HitInfo, vector HitLocation, vector Momentum, Actor DamageCauser)
{
	local GearPawn GP;

	// in SP do 60% damage if the user is in low cover (because they're too low to get the full force of the blast)
	GP = GearPawn(Victim);
	if ( GP != None && GP.IsInCover() && GP.CoverType == CT_MidLevel && GP.GetTeamNum() == 0 &&
		(!GP.WorldInfo.GRI.IsMultiplayerGame() || GP.WorldInfo.GRI.IsCoopMultiplayerGame()) )
	{
		Damage *= 0.6f;
	}
	Super.ModifyDamage(Victim, InstigatedBy, Damage, HitInfo, HitLocation, Momentum, DamageCauser);
}

static function bool ShouldHeadShotGib(Pawn TestPawn, Pawn Instigator)
{
	local GearPawn GP;

	// this damage type is at head level so it blows off their head if they are standing
	GP = GearPawn(TestPawn);
	return (GP != None && (!GP.IsInCover() || GP.CoverType == CT_Standing));
}

static function HandleDeathFX(GearPawn DeadPawn)
{
	local GearPC PC;

	if (DeadPawn.ShotgunCameraLensEffectTemplate != None && ShouldHeadShotGib(DeadPawn, None))
	{
		foreach DeadPawn.LocalPlayerControllers(class'GearPC', PC)
		{
			if (PC.Pawn != None && VSize(PC.Pawn.Location - DeadPawn.Location) < 256.0 && PC.IsAimingAt(DeadPawn, 0.1))
			{
				PC.ClientSpawnCameraLensEffect(DeadPawn.ShotgunCameraLensEffectTemplate);
			}
		}
	}
}

defaultproperties
{
	ImpactTypeExplosionID=ITE_GrenadeFrag
	KilledByIcon=(Texture=Texture2D'Warfare_HUD.HUD.Gears_DeathIcons',U=236,V=0,UL=77,VL=29)

	BRadialDamageVelChange=true

	KDamageImpulse=200
	KDeathUpKick=250
	KDeathVel=200
	RadialDamageImpulse=100
	bEnvironmentalDamage=false
	WeaponID=WC_DiggerLauncher
	bCausesFracture=true

	// Don't play the headshot animation, let the impulse do its thing
	bForceRagdollDeath=true
}
