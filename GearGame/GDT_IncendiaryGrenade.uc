/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_IncendiaryGrenade extends GearDamageType;

//@fixme, why isn't this derived from GDT_Fire?

var() protected const class<Emit_CameraLensEffectBase> LensEffectClass;

var() protected const float MediumScreamHeatThreshold;

var protected const bool bHeatSkin;
var() protected const float PawnIgnitionThreshold_Burning;


static function bool ShouldDBNO(Pawn TestPawn, Pawn Instigator, vector HitLocation,TraceHitInfo HitInfo)
{
	// don't execute players in horde or SP
	if ( TestPawn.GetTeamNum() == 0 && ( ClassIsChildOf(TestPawn.WorldInfo.GRI.GameClass, class'GearGameHorde_Base') ||
						(!TestPawn.WorldInfo.GRI.IsMultiplayerGame() && GearPRI(TestPawn.PlayerReplicationInfo).Difficulty.default.bCanDBNO) ) )
	{
		return true;
	}

	// IG never DBNOs
	return FALSE;
}


/** Overridden to ignite players on death */
static function HandleKilledPawn(Pawn KilledPawn, Pawn Instigator)
{
	local GearPawn GP;
	GP = GearPawn(KilledPawn);
	// if player hasn't ignited yet but died by fire, start smoldering
	if (GP != None)
	{
		GP.IgnitePawn(POF_Blazing, Instigator.Controller, default.Class, 6.f);
	}
	Super.HandleKilledPawn(KilledPawn,Instigator);
}

static function HandleDBNOPawn(Pawn DBNOPawn)
{
	local GearPawn GP;
	GP = GearPawn(DBNOPawn);
	// if player hasn't ignited yet but died by fire, start smoldering
	if (GP != None)
	{
		GP.IgnitePawn(POF_Smoldering);
	}
	Super.HandleDBNOPawn(DBNOPawn);
}

/** Overridden to add camera effect, skin effects. */
static function HandleDamageFX(GearPawn DamagedPawn, const out TakeHitInfo HitInfo)
{
	local GearPC PC;
	local float HeatPct, DamagePct, OldLastPainTime;
	local bool bDoPainFX;

	// do this before the super so we can handle pain sounds ourself
	bDoPainFX = (DamagedPawn.WorldInfo.TimeSeconds - DamagedPawn.LastPainTime > 0.95f);
	if (bDoPainFX)
	{
		OldLastPainTime = DamagedPawn.LastPainTime;
		DamagedPawn.LastPainTime = DamagedPawn.WorldInfo.TimeSeconds;
	}

	// do this last so we can override pain sounds above
	Super.HandleDamageFX(DamagedPawn,HitInfo);

	// camera fx
	if (DamagedPawn.IsHumanControlled())
	{
		// spawn camera lens effect
		PC = DamagedPawn.GetPC();
		if (PC != None)
		{
			PC.ClientSpawnCameraLensEffect(default.LensEffectClass);
		}
	}

	// scream!
	if ( bDoPainFX && (DamagedPawn.Health > 0) )
	{
		if (DamagedPawn.CurrentSkinHeat > default.MediumScreamHeatThreshold)
		{
			DamagedPawn.SoundGroup.PlayEffort(DamagedPawn, GearEffort_OnFirePain, true);
		}
		else
		{
			// reset LastPainTime to old value -- not enough sustained damage to scream, wait a sec
			DamagedPawn.LastPainTime = OldLastPainTime;
		}
	}

	if (default.bHeatSkin)
	{
		// fire damage causes skin "heating" effect
		DamagePct = HitInfo.Damage / float(DamagedPawn.default.DefaultHealth);
		HeatPct =  DamagePct / DamagedPawn.default.SkinHeatDamagePctToFullyHeat;
		DamagedPawn.HeatSkin(HeatPct);
		DamagedPawn.CharSkin(HeatPct * 3.0); // more than normal fire because targets die so fast
	}
}

static function bool ShouldIgnoreExecutionRules(Pawn TestPawn, Pawn Instigator)
{
	// don't execute players in horde or SP
	return (TestPawn.WorldInfo.GRI.IsMultiplayerGame() && !ClassIsChildOf(TestPawn.WorldInfo.GRI.GameClass, class'GearGameHorde_Base'));
}

static function ModifyDamage(Pawn Victim, Controller InstigatedBy, out int Damage, const out TraceHitInfo HitInfo, vector HitLocation, vector Momentum, Actor DamageCauser)
{
	// reduce damage to players in SP
	if (!Victim.WorldInfo.GRI.IsMultiplayerGame() && Victim.IsHumanControlled())
	{
		Damage /= 2;
	}

	Super.ModifyDamage(Victim, InstigatedBy, Damage, HitInfo, HitLocation, Momentum, DamageCauser);
}

defaultproperties
{
	ImpactTypeExplosionID=ITE_GrenadeIncendiary
	LensEffectClass=class'Emit_CameraScorch'
	KilledByIcon=(Texture=Texture2D'Warfare_HUD.HUD.Gears_DeathIcons',U=236,V=60,UL=77,VL=29)
	KDamageImpulse=0.0

	bSuppressImpactFX=TRUE
	WeaponID=WC_IncendiaryGrenade

	// @tweak
	MediumScreamHeatThreshold=0.2f

	bHeatSkin=TRUE
	PawnIgnitionThreshold_Burning=1.3f
}
