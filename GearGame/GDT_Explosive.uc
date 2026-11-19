/**
 * Base class for all explosive damage types.
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GDT_Explosive extends GDT_Environment
	config(Weapon);

/** whether this damage type causes the shield to be dropped if it blocks damage of this type */
var bool bCausesShieldDrop;
/** Distance to skip DBNO and gib directly */
var() config float GibDistance;

/** Overridden to enforce default gibbing for explosive damage. */
static function bool ShouldGib(Pawn TestPawn, Pawn Instigator)
{
	return TRUE;
}

static function bool ShouldDBNO(Pawn TestPawn, Pawn Instigator, vector HitLocation,TraceHitInfo HitInfo)
{
	local bool bCompetitiveGameType;
	// force gibbage for competitive (respecting ff/suicide) or locust in SP/horde
	if (VSize(HitLocation - TestPawn.Location) <= default.GibDistance)
	{
		bCompetitiveGameType = TestPawn.WorldInfo.GRI.IsMultiplayerGame() && !ClassIsChildOf(TestPawn.WorldInfo.GRI.GameClass, class'GearGameHorde_Base');
		if (bCompetitiveGameType)
		{
			if (Instigator == None || Instigator == TestPawn || TestPawn.GetTeamNum() != Instigator.GetTeamNum() || GearGRI(TestPawn.WorldInfo.GRI).bAllowFriendlyFire)
			{
				return FALSE;
			}
		}
		else
		{
			// locust never DBNO from grenades in coop games
			if (TestPawn.GetTeamNum() != TEAM_COG)
			{
				return FALSE;
			}
		}
	}
	return Super.ShouldDBNO(TestPawn,Instigator,HitLocation,HitInfo);
}

defaultproperties
{
	KilledByIcon=(Texture=Texture2D'Warfare_HUD.HUD.Gears_DeathIcons',U=156,V=90,UL=77,VL=29)

	DeathScreamEffortID=GearEffort_SuddenDeathScream
	bPlayDamagedEnemyHeavyGUD=true

	RadialDamageImpulse=400.0
	bRadialDamageVelChange=true
	bSuppressImpactFX=true
	bCausedByWorld=false
	bCausesShieldDrop=true

	Begin Object Name=ForceFeedbackWaveform1
	End Object

	DamagedFFWaveform=ForceFeedbackWaveform1
	KilledFFWaveform=ForceFeedbackWaveform1
}
