class ZombieAIManager extends Actor
	hidecategories ( Actor, Advanced, Collision, Lighting, LightColor, Karma, Force, Sound )
	native
	placeable;

// list of cover nodes
var array<ZombieAINode>		CoverNodes;
// list of patrol nodes
var array<ZombieAINode>		PatrolNodes;
// list of active AI
//var array<ZombieBot>		Bots;

///////////////////
// Initialization
///////////////////

// called at startup
event PreBeginPlay ( )
{
	local ZombieAINode	CurrentNode;
	local ZombieBot		CurrentBot;
	local int			i;

	// gather all nodes marked at cover that are linked to me
	foreach AllActors ( class'ZombieAINode', CurrentNode )
	{
		// loop over all possible AIManagers
		for ( i = 0; i < 5; i++ )
		{		
			// does it belong to me?
			if ( CurrentNode.AIManagerTag[i] == Tag )
			{
				// add to cover node list
				if ( CurrentNode.bIsCoverNode )
				{
					CoverNodes [ CoverNodes.Length ] = CurrentNode;
				}
				// add to patrol node list
				if ( CurrentNode.bIsPatrolNode )
				{
					PatrolNodes [ PatrolNodes.Length ] = CurrentNode;
				}
			}
		}
	}

	// gather any existing AI that are linked to me
	foreach AllActors ( class'ZombieBot', CurrentBot )
	{
		// does it belong to me?
		if ( CurrentBot.AIManagerTag == Tag )
		{
			// add to list
			Level.Bots [ Level.Bots.Length ] = CurrentBot;
			// set me as the AIManager for this bot
			CurrentBot.AIManager = Self;
		}
	}
}

event Trigger ( Actor Other, Pawn EventInstigator )
{
	local int Index;
	local int Num;
	Num = 0;
	for ( Index = 0; Index < CoverNodes.Length; Index++ )
	{
		if ( CoverNodes [ Index ].CurrentUser != None )
		{
			Num++;
		}
	}
	log ( "ZombieAIManager."$Name@"Has"@Num@"CoverNodes in use." );
	Num = 0;
	for ( Index = 0; Index < PatrolNodes.Length; Index++ )
	{
		if ( CoverNodes [ Index ].CurrentUser != None )
		{
			Num++;
		}
	}
	log ( "ZombieAIManager."$Name@"Has"@Num@"PatrolNodes in use." );
}

//
// Bot Management functions
//

function RemoveBot ( ZombieBot Bot )
{
	local int Index;
	// loop over all
	for ( Index = 0; Index < Level.Bots.Length; Index++ )
	{
		// find him?
		if ( Level.Bots [ Index ] == Bot )
		{
			// remove!
			Level.Bots.Remove ( Index, 1 );
		}
	}
}

////////////////////
// Node interface
////////////////////

// Get the closest cover node for a user at UserLocation based on an enemy at EnemyLocation that is not equal to ManualExclude
native function ZombieAINode GetClosestCover ( vector UserLocation, vector EnemyLocation, optional ZombieAINode ManualExclude );
// Get the farthest cover node for a user at UserLocation based on an enemy at EnemyLocation that is not equal to ManualExclude
native function ZombieAINode GetRetreatCover ( vector UserLocation, vector EnemyLocation, optional ZombieAINode ManualExclude );
// Get the next closest node to enemy for a user at UserLocation based on an enemy at EnemyLocation that is not equal to ManualExclude
native function ZombieAINode GetCloserCover ( vector UserLocation, vector EnemyLocation, optional ZombieAINode ManualExclude );
// Get a patrol node for a user at UserLocation that is not equal to ManualExclude
native function ZombieAINode GetPatrolNodeFor( vector UserLocation, optional ZombieAINode ManualExclude );

////////////////////////////////
// Bot communication interface
////////////////////////////////

// alerts all teammates to provide covering fire
function NotifyStartMoving ( ZombieBot MovingBot )
{
	local int i;
	for( i = 0; i < Level.Bots.Length; i++ )
	{
		if( ZombieBot( Level.Bots [ i ] ) != MovingBot && ZombieBot( Level.Bots [ i ] ) != None )
			ZombieBot( Level.Bots [ i ] ).ProvideCoverFire( MovingBot );
	}
}

// alerts all teammates to cease covering fire
function NotifyDoneMoving ( ZombieBot MovingBot )
{
	local int i;
	for( i = 0; i < Level.Bots.Length; i++ )
	{
		if( ZombieBot( Level.Bots [ i ] ) != MovingBot && ZombieBot( Level.Bots [ i ] ) != None )
			ZombieBot( Level.Bots [ i ] ).EndCoverFire( MovingBot );
	}
}

// alerts all teammates to cease covering fire
event AlertTeammates( Pawn Ally, Pawn NewEnemy )
{
	local int i;
	for( i = 0; i < Level.Bots.Length; i++ )
	{
		if( Level != None && ZombieBot( Level.Bots[i] ) != None && ZombieBot( Level.Bots[i] ).Enemy == None )
		{
			ZombieBot( Level.Bots[i] ).SupportAlly( Ally, NewEnemy );
		}
	}
}
// defaults...

// Decompiled with UE Explorer.
defaultproperties
{
    bHidden=true
    DrawScale=2.0000000
}