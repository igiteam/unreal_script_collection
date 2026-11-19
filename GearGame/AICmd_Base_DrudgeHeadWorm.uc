//=============================================================================
// Base Drudge Head Worm behavior
//
// Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
//=============================================================================

class AICmd_Base_DrudgeHeadWorm extends AICommand_Base_Combat
	within GearAI_DrudgeHeadWorm;

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
	NewEnemyReaction.OutputFunction = SawNewEnemy;
	NewEnemyReaction.bAlwaysNotify=true;
	NewEnemyReaction.Initialize();
	GotoState('Roam');
}

function Paused(GameAICommand NewCommand)
{
	Super.Paused(NewCommand);
	NewEnemyReaction.Suppress();
}

function Resumed( Name OldCommandName )
{
	Super.Resumed(OldCommandName);

	SelectEnemy();
	
	if(HasValidEnemy())
	{
		GotoState('LookAtNewTarget');
	}
	else
	{
		NewEnemyReaction.UnSuppress();
		GotoState('Roam');
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
	SetEnemy(Pawn(EventInstigator));
	GotoState('LookAtNewTarget');
}

/** Find valid retreat position
 *  Since drudgehead needs certain angle to attack
 *  Sometimes it looks stupid to try to attack in the close distance but can't
 *  So that case, retreat and attack again
 */
function vector FindValidRetreatPosition()
{
	local array<Vector> out_ValidPositions;
	local array<int>    Ratings;
	local int ValidPosIdx;
	local vector OutPos, ToEnemyFromPos, ToPosFromMe, ToEnemyFromMe, CurOutPos;
	local float MaxRating;
	
	// initialize as current location
	OutPos = Pawn.Location;
	//FlushPersistentDebugLines();

	// find new position, run away and find where I can face enemy and attack correctly
	// Randomly choose from player's position or my position - otherwise if player isn't moving, it's always same position
	if ( FRand() > 0.5f )
	{
		NavigationHandle.GetValidPositionsForBox(Enemy.Location,1024.f,vect(72,72,72),false,out_ValidPositions,10,500,Pawn.GetCollisionExtent());
	}
	else
	{
		NavigationHandle.GetValidPositionsForBox(Pawn.Location,1024.f,vect(72,72,72),false,out_ValidPositions,10,500,Pawn.GetCollisionExtent());
	}

	Ratings.Length = out_ValidPositions.Length;
	ToEnemyFromMe = Normal(Enemy.Location - Pawn.Location);

	// this is to find position where I can shoot from but run away from player
	for (ValidPosIdx=0; ValidPosIdx<out_ValidPositions.Length; ++ValidPosIdx)
	{
		CurOutPos = out_ValidPositions[ValidPosIdx];
		ToEnemyFromPos = Normal(Enemy.Location - CurOutPos);
		ToPosFromMe = Normal(CurOutPos-Pawn.Location);

		if ( FastTrace(Enemy.Location, CurOutPos) )
		{
			Ratings[ValidPosIdx] = -10;
			//DrawDebugSphere(CurOutPos, 30, 5, 255, 255, 255, TRUE);
		}
		else
		{
			Ratings[ValidPosIdx] = 0;
			//DrawDebugSphere(CurOutPos, 30, 5, 0, 0, 0, TRUE);
		}

		// if I need to cross enemy to get there, that's bad, so make sure "from me to enemy", isn't facing same way as "from enemy to pos"
		// if facing same way, give -2.
		if ( ToPosFromMe dot -ToEnemyFromPos > 0.5f )
		{
			Ratings[ValidPosIdx] -= 2.f;
		}

		// if from me to enemy and if from me to pos isn't facing same way, good to run away to
		if ( ToEnemyFromMe dot ToPosFromMe < 0.f )
		{
			Ratings[ValidPosIdx] += 3.f;
		}

	}

	MaxRating = -100;
	
	for (ValidPosIdx=0; ValidPosIdx<Ratings.Length; ++ValidPosIdx)
	{
		if ( Ratings[ValidPosIdx] > MaxRating )
		{
			OutPos = out_ValidPositions[ValidPosIdx];
			MaxRating = Ratings[ValidPosIdx];
		}
		// randomly choose something else within the same rating
		else if ( Ratings[ValidPosIdx] == MaxRating && FRand() > 0.5f)
		{
			OutPos = out_ValidPositions[ValidPosIdx];
		}
	}

	//DrawDebugSphere(OutPos, 30, 5, 255, 0, 0, TRUE);
	return OutPos;
}

state LookAtNewTarget `DEBUGSTATE
{
Begin:
	// look at enemy for a bit
	Pawn.LockDesiredRotation(false);
	SetFocalPoint(Enemy.Location);

	// if can fire, just fire
	if( VSizeSq(Enemy.Location - Pawn.Location) < EnemyDistance_Melee*EnemyDistance_Melee)
	{
		if (CanFireSprayOn())
		{
			// give a chnace to fire
			StartFireSpray();
			Sleep(1.0f);
			Goto('Begin');
		}
		// if can't fire, but I can see him and within the radius, run away
		else if ( FastTrace(Enemy.Location, Pawn.Location) )
		{
			// if I am too close, but can't fire
			// run to another point where I can attack back- 
			SetMovePoint(FindValidRetreatPosition());
		}
	}
	else
	{
		// otherwise, try to get to enemy again
		SetEnemyMoveGoal(true, EnemyDistance_Melee,,,TRUE);
	}

	Sleep(FRand());
	Goto('Begin');
};

state Roam `DEBUGSTATE
{
	function bool GenerateRoamPath()
	{
		class'NavMeshPath_WithinTraversalDist'.static.DontExceedMaxDist(NavigationHandle,MaxRoamDist,FALSE);
		class'NavMeshPath_WithinDistanceEnvelope'.static.StayWithinEnvelopeToLoc(NavigationHandle,Pawn.Location,MaxRoamDist,MinRoamDist,FALSE,,TRUE);
		class'NavMeshGoal_PolyEncompassesAI'.static.MakeSureAIFits(NavigationHandle);
		class'NavMeshGoal_Null'.static.GoUntilBust( NavigationHandle, 1024 );
		return NavigationHandle.FindPath();
	}
Begin:

	if( GenerateRoamPath() )
	{
		SetMovePoint(NavigationHandle.PathCache_GetGoalPoint(), Enemy,,,TRUE);
	}

	Sleep(RandRange(LookPtTimeRange.X,LookPtTimeRange.Y));
	Goto('Begin');
};



defaultproperties
{
	Min_LookPt_Angle_dot=0
	LookPtTimeRange=(X=0.5,Y=0.7)
	DesiredLookTime=7.5
}



