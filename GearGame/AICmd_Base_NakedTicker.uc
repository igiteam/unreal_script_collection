/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AICmd_Base_NakedTicker extends AICmd_Base_Ticker
	within GearAI_NakedTicker;

function Pushed()
{
	Super.Pushed();
	LastMeleeTime = WorldInfo.TimeSeconds;
	GotoState('InCombat');
}

state InCombat
{
	function bool MoveAwayFromEnemy()
	{
		local Vector EnemyLoc;

		EnemyLoc = GetEnemyLocation();

		class'NavMeshPath_AlongLine'.static.AlongLine(NavigationHandle, Normal(Pawn.Location - EnemyLoc));
		class'NavMeshGoal_AwayFromPosition'.static.FleeFrom(NavigationHandle, EnemyLoc, 4000.0f);
		if (NavigationHandle.FindPath())
		{
			SetMovePoint(NavigationHandle.PathCache_GetGoalPoint(),, false, 100.f, true, false, true);
			return true;
		}

		return false;
	}

Begin:

	if( !GearPawn_LocustNakedTickerBase(MyGearPawn).bEatenPickup && !Outer.bSeekingPickup )
	{
		SeekNearbyPickup();
	}

	if( !Outer.bSeekingPickup )
	{
		if( !SelectTarget() )
		{
			AutoAcquireEnemy();
			if( !SelectTarget() )
			{
				GotoState('DelayFailure');
			}
		}

		if( Enemy != None && ( `TimeSince(Outer.LastMeleeTime) > 4.0f || bHasBanzaiReTriggers ) )
		{
			class'AICmd_Attack_NakedTicker_Charge'.static.InitCommandUserActor(Outer, Enemy);
		}
		else
		{
 			NewCoverSpot();
			FinishRotation();
		}

		SetDesiredRotation(Rotator(Enemy.Location-Pawn.Location));
		Sleep(RandRange(MinWait,MaxWait));
	}

	Goto('Begin');
}

defaultproperties
{
	MinWait=0.5
	MaxWait=1.5
}
