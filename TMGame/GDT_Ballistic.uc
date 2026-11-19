/**
 * Base class for all ballistic damage types (shotgun, rifles, etc)
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class GDT_Ballistic extends TGDamageType;

/** Max distance for gibbing */
var config const float MaxGibDistance;

static function bool ShouldGib(Pawn TestPawn, Pawn Instigator)
{
	local bool bCompetitiveGameType;
	bCompetitiveGameType = TestPawn.WorldInfo.GRI.IsMultiplayerGame() && !ClassIsChildOf(TestPawn.WorldInfo.GRI.GameClass, class'TGGameHorde_Base');
	if ((bCompetitiveGameType || TestPawn.GetTeamNum() != TEAM_COG) && default.MaxGibDistance > 0 && Instigator != None && TestPawn != None && VSize(Instigator.Location - TestPawn.Location) <= default.MaxGibDistance)
	{
		return TRUE;
	}
	return FALSE;
}

/** Overridden to skip DBNO if MaxGibDistance would gib. */
static function bool ShouldDBNO(Pawn TestPawn, Pawn Instigator, vector HitLocation,TraceHitInfo HitInfo)
{
	return !ShouldGib(TestPawn,Instigator) && Super.ShouldDBNO(TestPawn,Instigator,HitLocation,HitInfo);
}

static function bool ShouldPlayForceFeedback( Pawn DamagedPawn )
{
	//if( TGPawn_LocustBrumakBase(DamagedPawn) != None )
	//{
	//	return FALSE;
	//}

	return Super.ShouldPlayForceFeedback( DamagedPawn );
}

