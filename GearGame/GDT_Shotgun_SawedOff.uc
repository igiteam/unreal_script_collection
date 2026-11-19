/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_Shotgun_SawedOff extends GDT_Ballistic
	abstract;

static function bool ShouldGib(Pawn TestPawn, Pawn Instigator)
{
	local bool bCompetitiveGameType;

	bCompetitiveGameType = TestPawn.WorldInfo.GRI.IsMultiplayerGame() && !TestPawn.WorldInfo.GRI.IsCoopMultiplayerGame();
	if ((bCompetitiveGameType || TestPawn.GetTeamNum() != TEAM_COG) && default.MaxGibDistance > 0 && Instigator != None && TestPawn != None)
	{
		return (VSize(Instigator.Location - TestPawn.Location) <= default.MaxGibDistance);
	}
	else
	{
		return false;
	}
}

static function HandleDamageFX(GearPawn DamagedPawn, const out TakeHitInfo HitInfo)
{
	local GearPC PC;

	Super.HandleDamageFX(DamagedPawn, HitInfo);

	if ( DamagedPawn.WorldInfo.GRI.ShouldShowGore() && HitInfo.InstigatedBy != None && HitInfo.Damage >= DamagedPawn.DefaultHealth &&
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
	ImpactTypeBallisticID=ITB_SawedOff
	KDamageImpulse=300.0
	KDeathUpKick=250.0
	KilledByIcon=(Texture=Texture2D'Warfare_HUD.HUD.Gears_DeathIcons',U=314,V=0,UL=77,VL=29)
	WeaponID=WC_SawedOffShotgun

	// We'll either play generic kill or multi kill manually in the weapon fire code
	KillGUDEvent=GUDEvent_None

	// This GUD stomps the multi kill GUD
	bPlayDamagedEnemyHeavyGUD=FALSE
}
