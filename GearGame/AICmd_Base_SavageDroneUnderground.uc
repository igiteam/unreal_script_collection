
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Base_SavageDroneUnderground extends AICommand_Base_Combat
	within GearAI_SavageDroneUnderground;

/** Pointer to Corpser pawn */
var transient GearPawn_LocustDroneSavageUndergroundBase SavageSpawner;
/** Time that we started roaming */
var transient float RoamStartTime;

function PrePushed(GameAIController AI)
{
	if( SavageSpawner != AI.Pawn )
	{	
		SavageSpawner = GearPawn_LocustDroneSavageUndergroundBase(AI.Pawn);
	}

	Super.PrePushed(AI);
}

function Pushed()
{
	Super.Pushed();
	bAllowCombatTransitions=false;
	GotoState('Roaming');
}


state Roaming `DEBUGSTATE
{
	function BeginState(Name PreviousStateName)
	{
		RoamStartTime = WorldInfo.TimeSeconds;
		Super.BeginState(PreviousStateName);
	}

	function bool GenerateRoamPath(Actor Goal)
	{
		local float DistToGoal;

		DistToGoal = VSize(Pawn.Location - Goal.Location);
		class'NavMeshPath_Toward'.static.TowardGoal( NavigationHandle, Goal );
		class'NavMeshPath_WithinCombatZone'.static.WithinCombatZone(NavigationHandle);
		class'NavMeshPath_WithinDistanceEnvelope'.static.StayWithinEnvelopeToLoc(NavigationHandle, Goal.Location, RoamEnvelopeOuter, Min(DistToGoal,RoamEnvelopeInner), FALSE,, TRUE);
		class'NavMeshGoal_InCombatZone'.static.InCombatZone(NavigationHandle, Outer);
		class'NavMeshGoal_Null'.static.GoUntilBust( NavigationHandle, 1024 );

		return NavigationHandle.FindPath( Goal );
	}

	function bool RoamTowardEnemy()
	{
		if( GenerateRoamPath(Enemy) )
		{
			SetMovePoint(NavigationHandle.PathCache_GetGoalPoint(), Enemy, , 100.f, , FALSE, TRUE);
			return true;
		}

		return false;
	}
Begin:
	`AILog("Roaming toward enemy...");
	if( Enemy == none || !RoamTowardEnemy() )
	{
		`AILog("Failed to find roam location for "$Enemy);
		Sleep(1.5f);
		ForceUpdateOfEnemies();
	}

	if( SavageSpawner.NumSpawned == 0 )
	{
		if( IsPawnVisibleViaTrace(Enemy) )
		{
			if( SavageSpawner.NumSpawned == 0 &&
				WorldInfo.TimeSeconds - RoamStartTime > MaxRoamTime ||
				VSizeSq(Enemy.Location - MyGearPawn.Location) < RoamEnvelopeInner*RoamEnvelopeInner )
			{
				`AILog("Done roaming - check if we can emerge");
				SavageSpawner.BeginEmerge();
				Sleep(0.01);
			}
		}
		else
		{
			`AILog("Enemy wasn't visible, reacquiring");
			ForceUpdateOfEnemies();
		}
	}

	Goto('Begin');
}


defaultproperties
{
}
