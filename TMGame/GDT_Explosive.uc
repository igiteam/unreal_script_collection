/**
 * Base class for all explosive damage types.
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class GDT_Explosive extends GDT_Environment
	config(TGWeapon);

/** Distance to skip DBNO and gib directly */
var() config float GibDistance;

/** Overridden to allow 50% damage if the victim is evading at time of explosion. */
static function ModifyDamage(Pawn Victim, Controller InstigatedBy, out int Damage, TraceHitInfo HitInfo, vector HitLocation, vector Momentum)
{
	local TGPawn GP;
	GP = TGPawn(Victim);
	if (GP != None && GP.IsEvading())
	{
		Damage *= 0.5f;
	}
	Super.ModifyDamage(Victim,InstigatedBy,Damage,HitInfo,HitLocation,Momentum);
}

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
		//bCompetitiveGameType = TestPawn.WorldInfo.GRI.IsMultiplayerGame() && !ClassIsChildOf(TestPawn.WorldInfo.GRI.GameClass, class'GearGameHorde_Base');
		bCompetitiveGameType = TestPawn.WorldInfo.GRI.IsMultiplayerGame();// && !ClassIsChildOf(TestPawn.WorldInfo.GRI.GameClass, class'GearGameHorde_Base');
		if (bCompetitiveGameType)
		{
			if (Instigator == None || Instigator == TestPawn || TestPawn.GetTeamNum() != Instigator.GetTeamNum() || TGGRI(TestPawn.WorldInfo.GRI).bAllowFriendlyFire)
			{
				return FALSE;
			}
		}
		else
		{
			// locust never DBNO from grenades in coop games
			if (TestPawn.GetTeamNum() == 1)
			{
				return FALSE;
			}
			else if (TGPRI(TestPawn.PlayerReplicationInfo).Difficulty.default.bCanDBNO)
			{
				// if player can go DBNO from difficulty then don't gib them
				return TRUE;
			}
		}
	}
	return Super.ShouldDBNO(TestPawn,Instigator,HitLocation,HitInfo);
}

