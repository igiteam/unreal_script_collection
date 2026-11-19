// The AI for a Visual Monster
// Basically the same (atm) as a Seeker Monster, except
// the visual monster (currently) stands still in one place 
// until he spots the player, then he begins hunting.

class FHVisualMonsterController extends FHMonsterController;

// the speeds that the monster can move at 
var float idle_search_speed;
var float chase_speed;

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
		    Sleep(0.25);
	        }
	
	    last_player_point = player.location;
	    GotoState('ChasingLastPlayerDest');
    }


// this is the state where the monster has seen the player at a point he cannot directly reach
// the Monster will sprint to that destination
state ChasingLastPlayerDest
    {
	event SeePlayer( Pawn p ) { OnMonsterSeesPlayer (player); }
	
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
			    Sleep(0.25);
		        }
	        }
	    GotoState('IdleSearching');
    }

// this state represents the monster navigating through the maze toward the player.
// The monster moves straight toward the player at a rate slower than the player can move.
state IdleSearching
    {
	event SeePlayer( Pawn p ) { OnMonsterSeesPlayer (player); }
	
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
		    Sleep( 0.5 );
	        }
    }

    // Initial state, only leaves when player sighted
auto state idle
    {
	event SeePlayer( Pawn p ) { OnMonsterSeesPlayer (player); }

	Begin:
	    player = none;
	
	    while ( true )
	        {
		    if( player == none ) player = FindPlayer();
		    Sleep( 0.25 );
	        }
    }

function OnMonsterSeesPlayer (Pawn p)
    {
    local FHPlayer lPlayer;
    if (player == none) return;

    lPlayer = FHPlayer (p);
    if (lPlayer == none) return; // it was not our player he saw

    Enemy = lPlayer;
	GotoState( 'ChasingPlayer' );
    }


// Decompiled with UE Explorer.
defaultproperties
{
    idle_search_speed=800.0000000
    chase_speed=700.0000000
}