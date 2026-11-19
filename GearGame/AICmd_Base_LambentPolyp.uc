/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AICmd_Base_LambentPolyp extends AICommand_Base_Combat
	within GearAI_LambentPolyp;


function Pushed()
{
	Super.Pushed();
	GotoState('InCombat');
}

state InCombat
{
Begin:

	// Don't allow the AI to do anything until it lands on the ground
	if (Pawn.Physics == PHYS_Falling)
	{
		Sleep(0.1);
		Goto('Begin');
	}

	if( !SelectTarget() )
	{
		`AILog(self@"Could not select target!");
		CheckCombatTransition();
		Sleep(0.5f);
	}

	if( Enemy == none )
	{
		Sleep(0.25f);
		Goto('Begin');
	}

	if( ShouldMelee() )
	{
		DoMeleeAttack();
	}
	GotoState('Roaming');
}

function Resumed( Name OldCommandName )
{
	Super.Resumed( OldCommandName );

	// If we somehow got off the navmesh
	if( ChildStatus == 'Failure' && NavigationHandle.LastPathError == PATHERROR_STARTPOLYNOTFOUND )
	{
		class'AICmd_MoveToMesh'.static.MoveToMesh(Outer);
	}
}

state Roaming `DEBUGSTATE
{
	function BeginState(Name PreviousStateName)
	{
		SetRoamEndTime();
		Super.BeginState(PreviousStateName);
	}

	/** Sets a time at which this polyp should stop roaming and do something more interesting */
	function SetRoamEndTime()
	{
		local float RoamDuration;

		// Roam for less time if there are less polyps in the squad
		if( Squad.SquadMembers.length > 6 )
		{   
			RoamDuration = RandRange(OverallRoamDurationMin, OverallRoamDurationMax);
		}
		else if( Squad.SquadMembers.length > 3 )
		{
			RoamDuration = RandRange(OverallRoamDurationMin, OverallRoamDurationMax) * 0.7f;
		}
		else
		{
			RoamDuration = RandRange(OverallRoamDurationMin, OverallRoamDurationMax) * 0.5f;
		}
		`AILog("Setting RoamDuration of"@RoamDuration@"with squad size"@Squad.SquadMembers.length);
		RoamEndTime = WorldInfo.TimeSeconds + RoamDuration;
	}

	function bool GenerateRoamPath(Actor Goal)
	{
		local float DistToGoal;

		DistToGoal = VSize(Pawn.Location - Goal.Location);
		class'NavMeshPath_Toward'.static.TowardGoal( NavigationHandle, Goal );
		class'NavMeshPath_WithinTraversalDist'.static.DontExceedMaxDist(NavigationHandle, MaxRoamDist, FALSE);
		class'NavMeshPath_WithinCombatZone'.static.WithinCombatZone(NavigationHandle);
		class'NavMeshPath_WithinDistanceEnvelope'.static.StayWithinEnvelopeToLoc(NavigationHandle, Goal.Location, RoamEnvelopeOuter, Min(DistToGoal,RoamEnvelopeInner));
		class'NavMeshPath_PreferWalls'.static.PreferWalls(NavigationHandle, 1000);
		class'NavMeshGoal_PolyEncompassesAI'.static.MakeSureAIFits(NavigationHandle);
		class'NavMeshGoal_InCombatZone'.static.InCombatZone(NavigationHandle, Outer);
		class'NavMeshGoal_Null'.static.GoUntilBust( NavigationHandle, 1024 );

		return NavigationHandle.FindPath( Goal );
	}

	function bool RoamTowardEnemy()
	{
		if( GenerateRoamPath(Enemy) )
		{
			SetMovePoint(NavigationHandle.PathCache_GetGoalPoint(), Enemy, , 100.f, TRUE, FALSE, TRUE);
			return true;
		}

		return false;
	}
Begin:
	`AILog("Roaming toward enemy...");
	ReleaseFireTicket();
	if( !SelectTarget() )
	{
		`AILog(self@"Could not select target!");
		CheckCombatTransition();
		Sleep(0.5f);
	}

	if(Enemy == none || !RoamTowardEnemy())
	{
		`AILog("Failed to find roam location for "$Enemy);
		Sleep(1.5f);
		ForceUpdateOfEnemies();
	}

	`AILog("Done roaming");

	// if we can't see our enemy from here, roam again!
	if(!IsPawnVisibleViaTrace(Enemy))
	{
		`AILog("Enemy wasn't visible, reacquiring");
		ForceUpdateOfEnemies();
	}

	`AILog("Enemy was visible, rotating toward him");
	Focus = Enemy;
	SetFocalPoint(vect(0,0,0));
	Focus = MoveFocus;

	FinishRotation();
	`AILog("Finished rotating, waiting a bit to let our driver pwn his arse");
	Sleep(RandRange(RoamWaitMin,RoamWaitMax));

	if( ShouldSpit() )
	{
		DoSpitAttack();
	}
	else if( ShouldMelee() )
	{
		DoMeleeAttack();
		SetRoamEndTime();
	}

	Goto('Begin');
}


defaultproperties
{
}
