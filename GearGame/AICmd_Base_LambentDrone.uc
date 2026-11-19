/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Base_LambentDrone extends AICommand_Base_Combat
	within GearAI_LambentDrone;

var AIReactCond_GenericCallDelegate SeeEnemyStopCond;
var AIReactCond_EnemyCloseAndVisible EnemyCloseMelee;

var transient float NextScreamTime;

function Pushed()
{
	Super.Pushed();
	NextScreamTime = WorldInfo.TimeSeconds + MinTimeBetweenScreams + RandRange(0.0,5.0);
	bTurtle=true;

	EnemyCloseMelee = new(outer) class'AIReactCond_EnemyCloseAndVisible';
	EnemyCloseMelee.AutoSubscribeChannels.AddItem('Hearing');
	EnemyCloseMelee.OutputChannelName = 'EnemyWithinMeleeDistance';
	EnemyCloseMelee.DistanceThreshold=EnemyDistance_Melee;
	EnemyCloseMelee.bAlwaysNotify=true;
	EnemyCloseMelee.MinTimeBetweenActivations = 3.0;
	EnemyCloseMelee.Initialize();
}

function Popped()
{
	Super.Popped();
	if( SeeEnemyStopCond != none)
	{
		SeeEnemyStopCond.UnsubscribeAll();
		SeeEnemyStopCond = none;
	}

	if(EnemyCloseMelee != none)
	{
		EnemyCloseMelee.UnsubscribeAll();
		EnemyCloseMelee = none;
	}
}

function CheckCloseIn()
{
	local float MinDist;
	MinDist = GetMinDistanceToAnyEnemy();
	`AILog(GetFuncName()@`showvar(ClosingDistance)@`showvar(MinDist));

	if( MinDist > ClosingDistance )
	{
		`AILog("Not close enough to any enemies, going to closing behavior!!");
		class'AICmd_Base_LambentDrone_CloseIn'.static.InitCommand(outer);
	}

}

auto state InCombat
{
	function BeginState(Name PreviousStateName)
	{
		InvalidateCover();
	}

Begin:
	//debug
	`AILog( "BEGIN TAG", 'State' );

	CheckProximityToOtherDrudges();

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

	CheckCloseIn();

	// Throw some random screams in 
	if(WorldInfo.TimeSeconds >= NextScreamTime)
	{
		NextScreamTime = WorldInfo.TimeSeconds + MinTimeBetweenScreams + RandRange(0.0,5.0);
		Sleep(0.25f);
		class'AICmd_Attack_LambentDroneScream'.static.InitCommand(Outer);
	}
	else
	{
		StartFiring();
		Sleep(RandRange(RoamWaitMin, RoamWaitMax));
	}

	// Fire from open
	FireFromOpen();

	CheckInterruptCombatTransitions();
	
	if (IsTethered())
	{
		//debug
		`AILog("Tethered, stay in combat");

		Sleep(1.f);
		Goto('Begin');
	}

	GotoState('Roaming');
}

state Roaming `DEBUGSTATE
{
	function bool GenerateRoamPath( Vector Goal )
	{
		local float DistToGoal;

		DistToGoal = VSize(Pawn.Location - Goal);
		class'NavMeshPath_Toward'.static.TowardPoint( NavigationHandle, Goal );
		class'NavMeshPath_WithinTraversalDist'.static.DontExceedMaxDist(NavigationHandle,MaxRoamDist,FALSE);
		class'NavMeshPath_WithinCombatZone'.static.WithinCombatZone(NavigationHandle);
		class'NavMeshPath_WithinDistanceEnvelope'.static.StayWithinEnvelopeToLoc(NavigationHandle,Goal,DistToGoal,Min(DistToGoal,RoamEnvelopeInner),FALSE,,TRUE);
		class'NavMeshGoal_PolyEncompassesAI'.static.MakeSureAIFits(NavigationHandle);
		class'NavMeshGoal_InCombatZone'.static.InCombatZone(NavigationHandle, Outer);
		class'NavMeshGoal_Null'.static.GoUntilBust( NavigationHandle, 1024 );

		return NavigationHandle.FindPath();
	}

	function bool RoamTowardEnemy()
	{
		if(GenerateRoamPath(GetEnemyLocation(,LT_Known)))
		{
			StartFiring();
			SetMovePoint(NavigationHandle.PathCache_GetGoalPoint(),Enemy,,,true, true);
			StopFiring();
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
	AbortCommand( None, class'AICmd_MoveToGoal_Mesh');
	GotoState('Roaming');
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
	
	CheckCloseIn();
	StartFiring();
	Sleep(1.0f);
	SelectTarget();
	SetMovePoint(GetEnemyLocation(,LT_Known));
	Goto('Begin');
	
};

defaultproperties
{
}
