/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class AICmd_Wander extends AICommand
	within GearAI;

var() float MaxDist;
var() float MinDist;
var bool bPlayerStartWander;

static function bool Wander(GearAI AI, bool bInPlayerStartWander)
{
	local AICmd_Wander Cmd;

	if( AI != None )
	{
		Cmd = new(AI) class'AICmd_Wander';
		if( Cmd != None )
		{
			Cmd.bPlayerStartWander=bInPlayerStartWander;
			AI.PushCommand(Cmd);
			return TRUE;
		}
	}

	return FALSE;

}

function Pushed()
{
	Super.Pushed();
	ReactionManager.SuppressAll();
	bAllowCombatTransitions=false;
	GotoState('Wandering');
}

function Popped()
{
	Super.Popped();
	ReactionManager.UnSuppressAll();
	bAllowCombatTransitions=false;
	StopFiring();
}

function vector GetNextWanderPoint()
{
	local PlayerStart Start;
	local NavigationPoint NP;
	local Actor DestActor;
	local array<BiasedGoalActor> Actors;
	local int Index;


	if(!bPlayerStartWander)
	{
		class'NavMeshPath_WithinDistanceEnvelope'.static.StayWithinEnvelopeToLoc(NavigationHandle,Pawn.Location,2.0f*MaxDist,(RandRange(1.0f,2.0f))*MinDist,false,0.f,true);
		class'NavMeshGoal_AwayFromPosition'.static.FleeFrom(NavigationHandle,Pawn.Location,RandRange(0.75f,1.1f)*MaxDist);
		if( NavigationHandle.FindPath() )
		{
			`AIlog("Next wander point:"@NavigationHandle.PathCache_GetGoalPoint());		
			return NavigationHandle.PathCache_GetGoalPoint();
		}
	}
	else
	{
		foreach WorldInfo.AllNavigationPoints(class'PlayerStart', Start)
		{
				Index = Actors.Add(1);
				Actors[Index].Goal = Start;
				Actors[Index].ExtraCost = Rand(6000);
		}

		// if we couldn't find any player starts use all Navpts
		if(Actors.Length == 0)
		{
			foreach WorldInfo.AllNavigationPoints(class'NavigationPoint', NP)
			{
					Index = Actors.Add(1);
					Actors[Index].Goal = NP;
					Actors[Index].ExtraCost = Rand(6000);
			}

		}

		if (Actors.length > 0)
		{
			AddBasePathConstraints(false);

			// NOTE: heuristic points back to bot here because we are pathing backwards from our goals
			//class'NavMeshPath_Toward'.static.TowardPoint(NavigationHandle, Pawn.Location);
			//class'NavMeshGoal_ClosestActorInList'.static.ClosestActorInList(NavigationHandle, Actors);
			class'NavMeshGoal_FarthestNavInRange'.static.FarthestNavInRange(NavigationHandle,5000,Actors);
			NavigationHandle.FindPath(DestActor);
		}
		else
		{
			`AILog("Could not find any playerstarts to wander to!");
		}

		if (DestActor != None)
		{
			`AILog("Roaming toward"@DestActor);
			return DestActor.Location;
		}
	}
	`AILog("Failed to find wander point");
	return Pawn.Location;
}

state Wandering
{
Begin:
	`AILog("WANDERING!!!!!!!!!!!!!!!");
	SetMovePoint(GetNextWanderPoint());
	Sleep(RandRange(0.5,1.5));
	Goto('Begin');
}


defaultproperties
{
	MinDist=300.0f
	MaxDist=5500.0f
}
