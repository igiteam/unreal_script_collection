class FHMonsterController extends AIController;

// variables to hold the monster and player
var Pawn     monster;
var FHPlayer player;

var float    ClosenessThreshold;


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
		//Worldinfo.Game.Broadcast(self, "FHMonster>>> Found player");
		return temp_player;
	}
	
	//Worldinfo.Game.Broadcast(self, "FHMonster>>> Could NOT find player");
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


function bool ReachedPoint (Vector v)
    {
	return (VSize(v - monster.Location) <= ClosenessThreshold);
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


// Decompiled with UE Explorer.
defaultproperties
{
    ClosenessThreshold=75.0000000
}