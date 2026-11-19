// The AI for a Smell Monster
// Basically the same (atm) as a Seeker Monster, except
// the smell monster (currently) stands still in one place 
// until he smells the player, then he begins hunting.
// Smelling is radius based.

class FHSmellMonsterController extends FHMonsterController;

// the speeds that the monster can move at 
var float idle_search_speed;
var float chase_speed;

var float engageDistance;
var float disengageDistance;
var bool  bHasPlayerScent;

var Vector last_player_point;   // the position of the player where the monster last saw him

// used temporarily for navigating
var Vector temp_dest;

// this is the state where the monster is chasing straight at the player, with no obstacles inbetween
state ChasingPlayer
    {
    Begin:
		monster.GroundSpeed = default.chase_speed;
	    while(Pawn != none && player != none && NavigationHandle.ActorReachable(player))
	        {
		    MoveToward(player);
            if (!MonsterSmellsPlayer ()) GotoState ('Idle');
		    Sleep(0.25);
	        }
	
	    last_player_point = player.location;
	    GotoState('ChasingLastPlayerDest');
    }


// this is the state where the monster has seen the player at a point he cannot directly reach
// the Monster will sprint to that destination
state ChasingLastPlayerDest
    {
    Begin:
		monster.GroundSpeed = default.chase_speed;
	    if( GeneratePathToPoint( last_player_point ) )
	        {
		    while( !ReachedPoint(last_player_point) )
		        {
			    if( NavigationHandle.GetNextMoveLocation( temp_dest, ClosenessThreshold ) )
			        {
				    if (!NavigationHandle.SuggestMovePreparation( temp_dest, self ))
				        {
					    MoveTo(temp_dest);
				        }
			        }
                if (!MonsterSmellsPlayer ()) GotoState ('Idle');
			    Sleep(0.25);
		        }
	        }
	    GotoState('IdleSearching');
    }

// this state represents the monster navigating through the maze toward the player.
// The monster moves straight toward the player at a rate slower than the player can move.
state IdleSearching
    {
	Begin:
		monster.GroundSpeed = default.idle_search_speed;
	    while(Pawn != none && player != none)
	        {
		    if( GeneratePathToActor2( player ) )
		        {
			    if( NavigationHandle.GetNextMoveLocation( temp_dest, ClosenessThreshold ) )
			        {
				    if ( !NavigationHandle.SuggestMovePreparation( temp_dest,self ) )
				        {
					    MoveTo( temp_dest );
				        }
			        }
		        }
            if (!MonsterSmellsPlayer ()) GotoState ('Idle');
		    Sleep( 0.5 );
	        }
    }

    // Initial state, only leaves when player smelt
auto state Idle
    {
	Begin:
	    while ( true )
	        {
            if (player != none)
                {
                if (MonsterSmellsPlayer ()) GotoState( 'ChasingPlayer' );
                }
            else player = FindPlayer ();
		    Sleep( 0.25 );
	        }
    }

function float DistanceToPlayer ()
    {
    local float lDistance;

    if (player  == none) return -1;
    if (monster == none) return -1;
    lDistance = VSize (monster.location - player.location);
    return lDistance;
    }

function bool MonsterSmellsPlayer ()
    {
    local float lDistance;

    if (player == none) return false;
    lDistance = DistanceToPlayer ();
    if (bHasPlayerScent) bHasPlayerScent = lDistance <= disengageDistance;
    else                 bHasPlayerScent = lDistance <= engageDistance;
    return bHasPlayerScent;
    }


// Decompiled with UE Explorer.
defaultproperties
{
    idle_search_speed=800.0000000
    chase_speed=700.0000000
    engageDistance=2000.0000000
    disengageDistance=2500.0000000
}