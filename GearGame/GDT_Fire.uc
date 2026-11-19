/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class GDT_Fire extends GDT_Environment
	dependson(GearSoundGroup);

/** Which lens effect to play when damaged by fire. */
var() protected const class<Emit_CameraLensEffectBase> LensEffectClass;

var() protected const config float	SelfInflictedDamageScale;

var() protected const float MediumScreamHeatThreshold;

var protected const bool bHeatSkin;

var() protected const float PawnIgnitionThreshold_Burning;


/** Overridden to reduce self-damage. */
static function ModifyDamage(Pawn Victim, Controller InstigatedBy, out int Damage, const out TraceHitInfo HitInfo, vector HitLocation, vector Momentum, Actor DamageCauser)
{
	local GearPawn VictimGP;

	Super.ModifyDamage(Victim, InstigatedBy, Damage, HitInfo, HitLocation, Momentum, DamageCauser);

	VictimGP = GearPawn(Victim);
	if (VictimGP != None)
	{
		VictimGP.HeatDamageInstigator = InstigatedBy;
	}

	// Nerf damage to yourself and any damage coming from something you are riding.
	if ( InstigatedBy != none && (Victim == InstigatedBy.Pawn || Victim.Base == InstigatedBy.Pawn))
	{
		Damage *= default.SelfInflictedDamageScale;

		if (VictimGP != None && Victim.WorldInfo.TimeSeconds - VictimGP.LastWeaponBlindFireTime < 0.5f)
		{
			// for recent blindfires, reduce damage even more
			Damage *= 0.5f;
		}
	}

}

/** Overridden to ignite players on death */
static function HandleKilledPawn(Pawn KilledPawn, Pawn Instigator)
{
	local GearPawn GP;
	GP = GearPawn(KilledPawn);
	// if player hasn't ignited yet but died by fire, start smoldering
	if (GP != None)
	{
		GP.IgnitePawn(POF_Blazing, Instigator.Controller,, 6.f);
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

/** Does the camera effect for being on fire */
static function DoCameraEffect(GearPawn DamagedPawn)
{
	local GearPC PC;

	if (default.LensEffectClass != None && DamagedPawn.IsHumanControlled())
	{
		// spawn camera lens effect
		PC = DamagedPawn.GetPC();
		if (PC != None)
		{
			PC.ClientSpawnCameraLensEffect(default.LensEffectClass);
		}
	}
}

/** Overridden to add camera effect, skin effects. */
static function HandleDamageFX(GearPawn DamagedPawn, const out TakeHitInfo HitInfo)
{
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
	DoCameraEffect(DamagedPawn);

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
		DamagePct = HitInfo.Damage / float(DamagedPawn.Health);
		HeatPct =  FClamp(DamagePct / DamagedPawn.default.SkinHeatDamagePctToFullyHeat, 0.f, 1.f);
		DamagedPawn.HeatSkin(HeatPct);
		DamagedPawn.CharSkin(HeatPct*2.f);		// char double, since it's less noticeable

		// Heated skin causes damage, make sure the correct instigator is set
		if (HitInfo.InstigatedBy != None && DamagedPawn.OnFireState == POF_None)
		{
			DamagedPawn.OnFireDamageInstigator = HitInfo.InstigatedBy.Controller;
		}

		if ( (DamagedPawn.Health > 0.f) && (DamagedPawn.CurrentIgnitionSkinHeat >= default.PawnIgnitionThreshold_Burning) )
		{
			DamagedPawn.IgnitePawn(POF_Burning, DamagedPawn.HeatDamageInstigator,, 0.5f);
		}
 	}
}


// TODO: replace this for gears3 to work with vehicles nicely
/** Overridden to add camera effect, skin effects. */
static function HandleFireDamageForReavers( Vehicle_Reaver_Base DamagedPawn, const float Damage )
{
	local float HeatPct, DamagePct;
	local bool bDoPainFX;

	// do this before the super so we can handle pain sounds ourself
	bDoPainFX = (DamagedPawn.WorldInfo.TimeSeconds - DamagedPawn.LastPainTime > 0.95f);
	if (bDoPainFX)
	{
		DamagedPawn.LastPainTime = DamagedPawn.WorldInfo.TimeSeconds;
	}

	if (default.bHeatSkin)
	{
		// fire damage causes skin "heating" effect
		DamagePct = Damage / float(DamagedPawn.default.DefaultReaverHealth);
		HeatPct =  DamagePct / DamagedPawn.default.SkinHeatDamagePctToFullyHeat;
		DamagedPawn.HeatSkin(HeatPct);
		DamagedPawn.CharSkin(HeatPct*2.f);		// char double, since it's less noticeable
	}
}

defaultproperties
{
	bSuppressImpactFX=TRUE
	ImpactTypeBallisticID=ITB_Scorcher
	LensEffectClass=class'Emit_CameraScorch'
	bCausedByWorld=false

	DeathScreamEffortID=GearEffort_OnFireDeath

	KilledByIcon=(Texture=Texture2D'Warfare_HUD.HUD.Gears_DeathIcons',U=0,V=30,UL=77,VL=29)

	// @tweak
	MediumScreamHeatThreshold=0.2f

	bHeatSkin=TRUE
	PawnIgnitionThreshold_Burning=0.75f

	WeaponID=WC_Scorcher
	KDamageImpulse = 0.f
}
