/**
 * Base class for all ballistic damage types (shotgun, rifles, etc)
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NDT_Ballistic extends NanoDamageType
	abstract;

// this should be promoted to GameFramework


/** Max distance for gibbing */
var config const float MaxGibDistance;

static function bool ShouldGib(Pawn TestPawn, Pawn Instigator)
{
	local bool bCompetitiveGameType;

	bCompetitiveGameType = TestPawn.WorldInfo.GRI.IsMultiplayerGame();

	if ((bCompetitiveGameType || TestPawn.GetTeamNum() != 0) && default.MaxGibDistance > 0 && Instigator != None && TestPawn != None && VSize(Instigator.Location - TestPawn.Location) <= default.MaxGibDistance)
	{
		return TRUE;
	}

	return FALSE;
}



static function bool ShouldPlayForceFeedback( Pawn DamagedPawn )
{
	return Super.ShouldPlayForceFeedback( DamagedPawn );
}

defaultproperties
{
	//DamageHeavyGUDEvent=GUDEvent_DamagedEnemyHeavy

	KDamageImpulse=100
	bCausesFracture=TRUE
}
