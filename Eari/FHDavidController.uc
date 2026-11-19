class FHDavidController extends AIController;

// variables to hold the monster and player
var Pawn     monster;
var FHPlayer player;

var float    ClosenessThreshold;

// the speeds that the monster can move at 
var float idle_search_speed;
var float chase_speed;
// the position of the player where the monster last saw him
var Vector LastKnownGoodPlayerLocation;
var() Vector TempDest;

var Vector offset;
var Vector tempVec;


event Possess(Pawn inPawn, bool bVehicleTransition)
{
	monster = inPawn;
	Super.Possess(inPawn, bVehicleTransition);
	inPawn.SetMovementPhysics();
}

function SetPawn(Pawn Possess)
{
}

// set the pawn this controller is controlling
function FHPlayer FindPlayer()
{
	local FHPlayer temp_player;

  	ForEach DynamicActors(class'FHPlayer', temp_player)
	{
		Worldinfo.Game.Broadcast(self, "FHMonster>>> Found player");
		return temp_player;
	}
	
	Worldinfo.Game.Broadcast(self, "FHMonster>>> Could NOT find player");
	return none;
}


function bool PlayerIsVisible()
    {
    local FHPlayer lPlayer;

    foreach VisibleActors (class'FHPlayer', lPlayer)
        {
        return true;
        }
    return false;
    }

// generate path to a point
function bool GeneratePathToPoint(Vector v)
    {
	if( NavigationHandle == none ) return false;
	
	// Clear cache and constraints (ignore recycling for the moment)
	NavigationHandle.PathConstraintList = none;
	NavigationHandle.PathGoalList = none;

	// Create constraints
	class'NavMeshPath_Toward'.static.TowardPoint( NavigationHandle, v );
	class'NavMeshGoal_At'.static.AtLocation( NavigationHandle, v, ClosenessThreshold, true );

	return NavigationHandle.FindPath();
    }

function bool GeneratePathToActor2(Actor a)
    {
	if( a == none ) return false;
	if( NavigationHandle == none ) return false;
	
	// Clear cache and constraints (ignore recycling for the moment)
	NavigationHandle.PathConstraintList = none;
	NavigationHandle.PathGoalList = none;

	// Create constraints
	class'NavMeshPath_Toward'.static.TowardGoal( NavigationHandle, a );
	class'NavMeshGoal_At'.static.AtActor( NavigationHandle, a, 10, false );

	return NavigationHandle.FindPath();
}

function Tick(float DeltaTime)
{
	super.Tick(DeltaTime);
	if( player.bIsDead )
		GotoState('DoNothing');
}

function bool GeneratePathToPlayer()
{
    // Clear cache and constraints (ignore recycling for the moment)
    NavigationHandle.PathConstraintList = none;
    NavigationHandle.PathGoalList = none;

    // Create constraints
    class'NavMeshPath_Toward'.static.TowardGoal( NavigationHandle,player );
    class'NavMeshGoal_At'.static.AtActor( NavigationHandle, player,32 );

    // Find path
    return NavigationHandle.FindPath();
}

function bool GeneratePathToLastKnownGood()
{
    // Clear cache and constraints (ignore recycling for the moment)
    NavigationHandle.PathConstraintList = none;
    NavigationHandle.PathGoalList = none;

    // Create constraints
    class'NavMeshPath_Toward'.static.TowardGoal( NavigationHandle,player );
    class'NavMeshGoal_At'.static.AtLocation( NavigationHandle, LastKnownGoodPlayerLocation,32 );

    // Find path
    return NavigationHandle.FindPath();
}

state Follow
{
    ignores SeePlayer;
Begin:

    if( NavigationHandle.ActorReachable( player) )
    {
        //FlushPersistentDebugLines();
        //Direct move
		monster.GroundSpeed = chase_speed;
        MoveToward( player,player );
    }
    else if( GeneratePathToPlayer() )
    {
		LastKnownGoodPlayerLocation = player.Location;

        //NavigationHandle.SetFinalDestination(player.Location);
        //FlushPersistentDebugLines();
        //NavigationHandle.DrawPathCache(,TRUE);
        
        // move to the first node on the path
        if( NavigationHandle.GetNextMoveLocation( TempDest, Pawn.GetCollisionRadius()) )
        {
            ////DrawDebugLine(Pawn.Location,TempDest,255,0,0,true);
           // //DrawDebugSphere(TempDest,16,20,255,0,0,true);

			monster.GroundSpeed = idle_search_speed;
            MoveTo( TempDest, player );
        }
    }
    else
    {
        //We can't follow, so get the hell out of this state, otherwise we'll enter an infinite loop.
        //GotoState('Idle');
		GotoState('ohFuck');
    }
    goto 'Begin';
}

// this state is where the monster is stuck in a wall ( or something... ) and path generation fails.
// We will attempt to move in 8 cardinal directions, and hopefully pathing will succeed.
state ohFuck
{
Begin:
	Sleep(1);
	tempVec = Location;
	offset.X = 0;
	offset.Y = 0;
	offset.Z = 0;// = tempVec.X = tempVec.Y = tempVec.Z = 0;
	
	offset.X = 16;
	SetLocation(tempVec + offset);
		if(   GeneratePathToLastKnownGood() )
			{
 			if( NavigationHandle.GetNextMoveLocation( TempDest, Pawn.GetCollisionRadius()) )
			{
				//DrawDebugLine(Pawn.Location,TempDest,255,0,0,true);
				//DrawDebugSphere(TempDest,16,20,255,0,0,true);

				MoveTo( TempDest, player );
			}
			GotoState('Follow');
		}

	offset.Y = 16;
	SetLocation( tempVec + offset);
		if(   GeneratePathToLastKnownGood() )
			{
			if( NavigationHandle.GetNextMoveLocation( TempDest, Pawn.GetCollisionRadius()) )
			{
				//DrawDebugLine(Pawn.Location,TempDest,255,0,0,true);
				//DrawDebugSphere(TempDest,16,20,255,0,0,true);

				MoveTo( TempDest, player );
			}
			GotoState('Follow');
		}

	offset.X = 0;
	SetLocation( tempVec + offset);
		if(   GeneratePathToLastKnownGood() )
			{
			if( NavigationHandle.GetNextMoveLocation( TempDest, Pawn.GetCollisionRadius()) )
			{
				//DrawDebugLine(Pawn.Location,TempDest,255,0,0,true);
				//DrawDebugSphere(TempDest,16,20,255,0,0,true);

				MoveTo( TempDest, player );
			}
			GotoState('Follow');
		}

	offset.X = -16;
	SetLocation( tempVec + offset);
		if(   GeneratePathToLastKnownGood() )
			{
			if( NavigationHandle.GetNextMoveLocation( TempDest, Pawn.GetCollisionRadius()) )
			{
				//DrawDebugLine(Pawn.Location,TempDest,255,0,0,true);
				//DrawDebugSphere(TempDest,16,20,255,0,0,true);

				MoveTo( TempDest, player );
			}
			GotoState('Follow');
		}

	offset.Y = 0;
	SetLocation( tempVec + offset);
		if(   GeneratePathToLastKnownGood() )
			{
			if( NavigationHandle.GetNextMoveLocation( TempDest, Pawn.GetCollisionRadius()) )
			{
				//DrawDebugLine(Pawn.Location,TempDest,255,0,0,true);
				//DrawDebugSphere(TempDest,16,20,255,0,0,true);

				MoveTo( TempDest, player );
			}
			GotoState('Follow');
		}

	offset.Y = -16;
	SetLocation( tempVec + offset);
		if(   GeneratePathToLastKnownGood() )
			{
			if( NavigationHandle.GetNextMoveLocation( TempDest, Pawn.GetCollisionRadius()) )
			{
				//DrawDebugLine(Pawn.Location,TempDest,255,0,0,true);
				//DrawDebugSphere(TempDest,16,20,255,0,0,true);

				MoveTo( TempDest, player );
			}
			GotoState('Follow');
		}

	offset.X = 0;
	SetLocation( tempVec + offset);
		if(   GeneratePathToLastKnownGood() )
			{
			if( NavigationHandle.GetNextMoveLocation( TempDest, Pawn.GetCollisionRadius()) )
			{
				//DrawDebugLine(Pawn.Location,TempDest,255,0,0,true);
				//DrawDebugSphere(TempDest,16,20,255,0,0,true);

				MoveTo( TempDest, player );
			}
			GotoState('Follow');
		}

	offset.X = 16;
	SetLocation( tempVec + offset);
		if(   GeneratePathToLastKnownGood() )
			{
			if( NavigationHandle.GetNextMoveLocation( TempDest, Pawn.GetCollisionRadius()) )
			{
				//DrawDebugLine(Pawn.Location,TempDest,255,0,0,true);
				//DrawDebugSphere(TempDest,16,20,255,0,0,true);

				MoveTo( TempDest, player );
			}
			GotoState('Follow');
		}

	SetLocation( tempVec );

	GotoState('Follow');

}

auto state idle
{
Begin:
	player = none;
	
	while ( true )
	{
		if( player == none )
		{
			player = FindPlayer();
		}
		if( player != none )
		{
			GotoState( 'Follow' );
		}
		Sleep( 1 );
	}
}
state DoNothing
{
Begin:
}


// Decompiled with UE Explorer.
defaultproperties
{
    ClosenessThreshold=75.0000000
    idle_search_speed=550.0000000
    chase_speed=550.0000000
}