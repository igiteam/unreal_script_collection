/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AICmd_Base_Bloodmount extends AICommand_Base_Combat
	within GearAI_Bloodmount;

var AIReactCond_GenericCallDelegate SeeEnemyStopCond;

function Pushed()
{
	Super.Pushed();
	RoamStartTime=WorldInfo.TimeSeconds;
	GotoState('InCombat');
}

state InCombat
{
Begin:
	
	if( !SelectTarget() )
	{
		`AILog(self@"Could not select target!");
		CheckCombatTransition();
		Sleep(0.5f);
	}

	if(Enemy == none)
	{
		Sleep(0.25f);
		Goto('Begin');
	}

	if(ShouldCharge())
	{
		Charge();
	}
	else
	{
		GotoState('Roaming');
	}

	Sleep(0.1f);
	Goto('Begin');
}

state Roaming `DEBUGSTATE
{
	function bool GenerateRoamPath( Actor Goal )
	{
		local float DistToGoal;

		DistToGoal = VSize(Pawn.Location - Goal.Location);
		class'NavMeshPath_Toward'.static.TowardGoal( NavigationHandle, Goal );
		class'NavMeshPath_WithinTraversalDist'.static.DontExceedMaxDist(NavigationHandle,MaxRoamDist,FALSE);
		
		// real one with soft distances
		class'NavMeshPath_WithinDistanceEnvelope'.static.StayWithinEnvelopeToLoc(NavigationHandle,Goal.Location,RoamEnvelopeOuter,Min(DistToGoal,RoamEnvelopeInner),FALSE,,TRUE);
		
		class'NavMeshGoal_PolyEncompassesAI'.static.MakeSureAIFits(NavigationHandle);
		class'NavMeshGoal_Null'.static.GoUntilBust( NavigationHandle, 1024 );


		
		return NavigationHandle.FindPath( Goal );
	}

	function bool RoamTowardEnemy()
	{
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
		GotoState('Reacquire');
	}

	`AILog("Done roaming");

	// if we can't see our enemy from here, roam again!
	if(!IsPawnVisibleViaTrace(Enemy))
	{
		`AILog("Enemy wasn't visible, reacquiring");
		GotoState('Reacquire');
	}

	`AILog("Enemy was visible, rotating toward him");
	Focus = Enemy;
	SetFocalPoint(vect(0,0,0));
	Focus = MoveFocus;
	
	FinishRotation();
	`AILog("Finished rotating, waiting a bit to let our driver pwn his arse");
	Sleep(RandRange(RoamWaitMin,RoamWaitMax));
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
		RoamStartTime=WorldInfo.TimeSeconds;
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

defaultproperties
{
}
