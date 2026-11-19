//=============================================================================
// Base Serapede behavior
//
// base behavior for the serapede centipede scary creepy face thing
//
// Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
//=============================================================================

class AICmd_Base_Serapede extends AICommand_Base_Combat
	within GearAI_Serapede;

var AIReactCond_GenericCallDelegate NewEnemyReaction;

var array<Vector> LookPoints;
var int SuccessfulLooks;

/** min dot of angle between current forward dir and direction we're going to look at */
var float Min_LookPt_Angle_dot;
/** range of times to use when pausing at each look point */
var vector2D LookPtTimeRange;

var float DesiredLookTime;

function Pushed()
{
	Super.Pushed();
	NewEnemyReaction = new(outer) class'AIReactCond_GenericCallDelegate';
	NewEnemyReaction.AutoSubscribeChannels.AddItem('NewEnemy');
	NewEnemyReaction.AutoSubscribeChannels.AddItem('Sight');
	NewEnemyReaction.AutoSubscribeChannels.AddItem('Hearing');
	NewEnemyReaction.OutputFunction = SawNewEnemy;
	NewEnemyReaction.bAlwaysNotify=true;
	NewEnemyReaction.Initialize();
	TryLookAround();
}

function Paused(GameAICommand NewCommand)
{
	Super.Paused(NewCommand);
	NewEnemyReaction.Suppress();
	Serapede.SetRearUp(false);
}

function Resumed( Name OldCommandName )
{
	Super.Resumed(OldCommandName);

	SelectEnemy();

	if(HasValidEnemy() && IsEnemyVisible(Enemy))
	{
		GotoState('LookAtNewTarget');
	}
	else
	{
		NewEnemyReaction.UnSuppress();
		TryLookAround();
	}
}

// we don't want them to look around when there are enemies around. 
// do more checks before really sending to look around
// there is child version of this, and both works different because this is another command
// if you change this, change AICmd_Serapede_LostEnemy version as well
function TryLookAround()
{
	// if enemy is visible, do not look around
	if ( IsEnemyVisible(Enemy) )
	{
		GotoState('LookAtNewTarget');
	}
	// if any visible enemy around, try to find new target as him
	else if ( IsAnyEnemyVisible() )
	{
		// select new target
		SetEnemy(none);
		SelectEnemy();

		if ( IsEnemyVisible(Enemy) )
		{
			GotoState('LookAtNewTarget');			
		}
		else // this happens when the visible target is DBNOed, then it's okay to look around
		{
			GotoState('LookAround');
		}
	}
	else
	{
		GotoState('LookAround');
	}
}

function Popped()
{
	Super.Popped();
	ClearReactions();
}

function ClearReactions()
{
	NewEnemyReaction.UnsubscribeAll();
	NewEnemyReaction=none;
}

function SawNewEnemy(Actor EventInstigator, AIReactChannel OrigChannel)
{
	if (EventInstigator != Enemy && !IsInState('LookAtNewTarget'))
	{
		SetEnemy(Pawn(EventInstigator));
		// if he's looking around, do not interrupt but wait, it will transfer if enemy exists after rear down
		if (!IsInState('LookAround'))
		{
			GotoState('LookAtNewTarget');
		}
	}
}

// when found new target, do not rear up, just charge
state LookAtNewTarget `DEBUGSTATE
{
	function BeginState(Name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);

		Serapede.PlayNewTargetAcquired();
	}

	function EndState(Name NextStateName)
	{
		Super.EndState(NextStateName);
	}
Begin:
	// if can charge, go for it
	if ( CanCharge() )
	{
		class'AICmd_Attack_Serapede_Charge'.static.Charge(outer,Enemy);
	}
};

// rear up and look around
state LookAround `DEBUGSTATE
{
	function BeginState(Name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);

		Serapede.SetRearUp(true);
	}

	function EndState(Name NextStateName)
	{
		Super.EndState(NextStateName);
		Serapede.SetRearUp(false);
	}

	function GetLookPoints(out array<Vector> out_lookpoints)
	{
		local int i;
		local int i_rand;
		local vector Tmp;

		NavigationHandle.GetValidPositionsForBox(Pawn.Location,1024.f,vect(72,72,72),true,out_lookpoints,128,900,Pawn.GetCollisionExtent());
		// shuffle them
		for(i=0;i<out_lookpoints.length;++i)
		{
			i_rand = rand(out_lookpoints.length);
			Tmp = out_lookpoints[i_rand];
			out_lookpoints[i_rand]=out_lookpoints[i];
			out_lookpoints[i]=Tmp;
		}

	}

	function bool IsValidLookPt(vector LookPt)
	{
		local vector Fwd;
		Fwd = Vector(Pawn.Rotation);

		return (Fwd dot Normal(LookPt - Pawn.Location) >= Min_LookPt_Angle_dot);
	}

	function GotoNextState()
	{
		// if has valid enemy, go to lookat new target
		if( HasValidEnemy() )
		{
			GotoState('LookAtNewTarget');
		}
		else
		{
			GotoState('Roam');
		}
	}

Begin:
	GetLookPoints(LookPoints);
	SuccessfulLooks=0;
	if(LookPoints.length > 0)
	{
		while(LookPoints.length > 0)
		{
			if(IsValidLookPt(LookPoints[LookPoints.length-1]))
			{
				SuccessfulLooks++;
				SetFocalPoint(LookPoints[LookPoints.length-1]);
				LookPoints.Remove(LookPoints.length-1,1);
				Serapede.PlayHeadMoveSound();
				Sleep(RandRange(LookPtTimeRange.X,LookPtTimeRange.Y));
				if( HasValidEnemy() )
				{
					GotoNextState();
				}
			}
			else
			{
				LookPoints.Remove(LookPoints.length-1,1);
			}
		}
	}

	// if rear up, look
	if ( Serapede.bRearUp )
	{
		Sleep(Max(0,DesiredLookTime - (SuccessfulLooks*(LookPtTimeRange.X+LookPtTimeRange.Y)*0.5)));
	}

	GotoNextState();
}

state Roam `DEBUGSTATE
{
	function BeginState(Name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);
	}

	function bool GenerateRoamPath( )
	{
		local Pawn ClosestEnemy;
		ClosestEnemy=GetClosestEnemy();
		if(ClosestEnemy != none)
		{
			class'NavMeshPath_Toward'.static.TowardGoal(NavigationHandle,ClosestEnemy);
		}

		class'NavMeshPath_WithinTraversalDist'.static.DontExceedMaxDist(NavigationHandle,2*MaxRoamDist,FALSE);
		class'NavMeshPath_WithinDistanceEnvelope'.static.StayWithinEnvelopeToLoc(NavigationHandle,Pawn.Location,MaxRoamDist,MinRoamDist,FALSE,,TRUE);
		class'NavMeshGoal_PolyEncompassesAI'.static.MakeSureAIFits(NavigationHandle);
		class'NavMeshGoal_Null'.static.GoUntilBust( NavigationHandle, 1024 );
		return NavigationHandle.FindPath();
	}
Begin:

	if(GenerateRoamPath( ))
	{
		SetMovePoint(NavigationHandle.PathCache_GetGoalPoint(),,,,TRUE);
	}

	Sleep(RandRange(LookPtTimeRange.X,LookPtTimeRange.Y));
	TryLookAround();
};



defaultproperties
{
	Min_LookPt_Angle_dot=0
	LookPtTimeRange=(X=1.0,Y=2.0)
	DesiredLookTime=6
}



