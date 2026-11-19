/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Base_Kantus extends AICommand_Base_Combat
	within GearAI_Kantus;

var AIReactCond_GenericCallDelegate SeeEnemyStopCond;

function Pushed()
{
	Super.Pushed();
	GotoState('InCombat');
}

function Popped()
{
	Super.Popped();

	bShouldRoadieRun = FALSE;
}


state Roaming `DEBUGSTATE
{
	function bool GenerateRoamPath( Actor Target )
	{
		local bool Ret;
		local Vector SearchStartPt;

		// take squad centroid and project back away from enemy so we go "behind" the squad
		SearchStartPt = Squad.GetSquadCentroid();
		SearchStartPt += Normal(SearchStartPt - Target.Location) * EnemyDistance_Short;

		// move toward squad centroid, but be sure to move a bit each time
		class'NavMeshPath_Toward'.static.TowardPoint(NavigationHandle,SearchStartPt);

		//Pawn.FlushPersistentDebugLines();
		//Pawn.DrawDebugCoordinateSystem(SearchStartPt,rot(0,0,0),100.f,TRUE);
		`AILog("trying to search toward"@SearchStartPt@"MaxRoamDist:"@MaxRoamDist@EnemyDistance_Short@EnemyDistance_Medium);

		//class'Path_AvoidanceVolumes'.static.AvoidThoseVolumes( Pawn );
		class'NavMeshPath_WithinTraversalDist'.static.DontExceedMaxDist(NavigationHandle,MaxRoamDist,FALSE);

		// envelope to keep us in our desired range to enemy
		class'NavMeshPath_WithinDistanceEnvelope'.static.StayWithinEnvelopeToLoc(NavigationHandle,Enemy.Location,EnemYDistance_Long,EnemyDistance_Short,TRUE,500.0);

		class'NavMeshGoal_Null'.static.GoUntilBust(NavigationHandle,512);

		Ret = NavigationHandle.FindPath(Target);
		NavigationHandle.ClearConstraints();
		return Ret;
	}

	function bool RoamTowardEnemy()
	{
		// skip path search if we're not allowed to move
		if(!AllowedToMove())
		{
			`AILog("Not roaming because AllowedToMove() returned false");
			return false;
		}

		if(GenerateRoamPath(Enemy))
		{
			SetMovePoint(NavigationHandle.PathCache_GetGoalPoint(),,,,TRUE);
			return true;
		}

		return false;
	}
Begin:

	`AILog("Roaming toward enemy...");
	if(Enemy == none || !RoamTowardEnemy())
	{
		`AILog("Failed to find roam location for "$Enemy);
		Sleep(1.5f);
	}

	`AILog("Done roaming");

	// if we can't see our enemy from here, roam again!
	if(!IsEnemyVisible(Enemy))
	{
		`AILog("Enemy wasn't visible, reacquiring");
		GotoState('Reacquire');
	}
	GotoState('InCombat');

}


function SawEnemyAgain(Actor EventInstigator, AIReactChannel OriginatingChannel)
{
	`AILog("Saw enemy, aborting move");
	AbortCommand(none,class'AICmd_MoveToEnemy');
}

state Reacquire `DEBUGSTATE
{
	function BeginState(Name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);
		SeeEnemyStopCond = new(outer) class'AIReactCond_GenericCallDelegate';
		SeeEnemyStopCond.AutoSubscribeChannels[0]='sight';
		SeeEnemyStopCond.OutputFunction = SawEnemyAgain;
		SeeEnemyStopCond.bOneTimeOnly = TRUE;
		SeeEnemyStopCond.Initialize();
	}

	function EndState(Name NextStateName)
	{
		Super.EndState(NextStateName);
		SeeEnemyStopCond.UnsubscribeAll();
		SeeEnemyStopCond = none;
	}

Begin:
	`AILog("Moving toward enemy until we see him");
	SetEnemyMoveGoal(TRUE);
	Sleep(0.1f);
	`AILog("SetEnemyMoveGoal finished.. going back to incombat");
	GotoState('InCombat');

};

state InCombat
{
	function BeginState(Name PreviousStateName)
	{
		InvalidateCover();
	}

Begin:
	//debug
	`AILog( "BEGIN TAG", 'State' );

	// check for any interrupt transitions
	CheckInterruptCombatTransitions();
	// select the best enemy
	SelectEnemy();
	FireTarget = Enemy;

	if (!HasValidEnemy())
	{
		//debug
		`AILog("No enemy");

		Sleep(1.f);
		Goto('Begin');
	}

	while( IsReloading() )
	{
		//debug
		`AILog("Waiting on reload",'Loop');

		Sleep(0.25f);
	}

	// Fire from open, infinite burst
	FireFromOpen(-1);

	Sleep( 0.25f );

	CheckInterruptCombatTransitions();
	GotoState('Roaming');
}

defaultproperties
{
}

