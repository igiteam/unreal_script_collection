class ZombieAINode extends PathNode
	native
	placeable;

// max distance to cover
const MAX_COVER_DIST = 255;
// max yaw for cover node in unreal units
const MAX_YAW_UNREAL = 12000;
// max yaw for cover node in radians
const MAX_YAW_RADIAN = 1.150485590914231;
// divide an unreal angle by this to get the angle in radians
const UNR_TO_RADIANS = 10435.668789808917;

// Flags defining type of AINode
var() bool bIsCoverNode,                      // Should be used for cover
           bIsPatrolNode;                     // Should be used for patrol

var bool   bUsingAsCover,
           bUsingAsPatrol;

// cover information
var( CoverInfo )  bool   bLeftCorner;
var( CoverInfo )  bool   bRightCorner;
var( CoverInfo )  bool   bShouldCrouch;
var( CoverInfo )  bool   bCanFireOver;
var( CoverInfo )  bool   bCanThrowGrenades;   // only valid if bCanFireOver is true
var( CoverInfo )  byte   CoverYawArc;         // 0 - 255 defining scale of 0 to 16384
var( CoverInfo )  byte   CoverDist;           // 0 - 255
var( CoverInfo )  float  MoveDisableTime;     // Amount of time a bot must wait until finding new cover
var( CoverInfo )  float  DeathDisableTime;    // Amount of time a cover node will be disabled when a bot dies there

// patrol information
var( PatrolInfo ) bool   bRandomLook;
var( PatrolInfo ) name   LookTargetTag;
var( PatrolInfo ) float  WaitTimeMin,
                         WaitTimeMax;

// internal data
var int                  YawArc;              // integer value - offset from node rotation
var float                YawArcRadians;       // value in radians
var array<LookTarget>    LookTargets;         // array of possible focal points for this node when using as patrol
var float                BotArrivalTime;      // game time in seconds when the bot arrived at this node
var float                DisableTimeOnDeath;  // game time in seconds that the cover node will be disabled when a bot dies there

var() name               AIManagerTag[5];     // Tags of the AIManagers that this node will belong to

// Node uses - for help in making guys go to different places
var int                  CoverUses,           // Total times since startup that this node has been used as cover
                         PatrolUses;          // Total times since startup that this node has been used for patrol

var ZombieBot            CurrentUser;         // Bot that is current moving to or standing at this node

//
// Bot native interface
//

// returns true if this is a good cover spot for DangerLocation
native function bool IsGoodCoverFor ( vector DangerLocation );
// returns true if the DangerLocation is more to the right of the middle
native function bool RightOfCover ( vector DangerLocation );

// why does this feel so dirty?
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

function PreBeginPlay ( )
{
	local LookTarget Temp;
	// store usable data
	YawArc = int (float(CoverYawArc) * (MAX_YAW_UNREAL / 255.0)); // Unreal Units
	YawArcRadians = YawArc / UNR_TO_RADIANS;                      // Radians

	// gather look targets
	if( bIsPatrolNode )
	{
		if( LookTargetTag != 'None' )
		{
			foreach AllActors( class'LookTarget', Temp, LookTargetTag )
			{
				// put it in the list
				LookTargets[LooKTargets.Length] = Temp;
			}
		}
	}
}

//
// Bot Script Interface
//

// sets the node as taken and increments CoverUses
function bool UseAsCover ( ZombieBot NewUser )
{
	// not in use
	if ( CurrentUser == None )
	{
		// store as user
		CurrentUser = NewUser;
		CoverUses++;
		// experimental
		AddExtraCost ( 500 );
		bUsingAsCover = true;
	}
	// user trying to use again
	else if ( CurrentUser == NewUser )
	{
		// success
		return true;
	}
	// fail
	return false;
}

// set the node as taken and increments PatrolUses
function bool UseAsPatrol ( ZombieBot NewUser )
{
	// not in use
	if ( CurrentUser == None )
	{
		// store as user
		CurrentUser = NewUser;
		PatrolUses++;
		// experimental
		AddExtraCost ( 500 );
		bUsingAsPatrol = true;
	}
	// user trying to use again
	else if ( CurrentUser == NewUser )
	{
		// success
		return true;
	}
	// fail
	return false;
}

// allow others to use this node
function ReleaseNode ( ZombieBot User )
{
	// make sure we have a user and it's the guy who is freeing the node
	if ( CurrentUser != None && CurrentUser == User )
	{
		// clear the user
		CurrentUser = None;
		// experimental
		AddExtraCost ( 0 );
		bUsingAsCover = false;
		bUsingAsPatrol = false;
	}
}

// returns a focal point for this node when used as Patrol
function LookTarget GetPatrolLookPoint( )
{
	if( LookTargets.Length > 0 )
	{
		return LookTargets[Rand( LookTargets.Length )];
	}
	else
	{
		return None;
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    bIsCoverNode=true
    bLeftCorner=true
    bRightCorner=true
    CoverYawArc=128
    CoverDist=96
    MoveDisableTime=3.0000000
    DeathDisableTime=15.0000000
    bRandomLook=true
    WaitTimeMin=2.0000000
    WaitTimeMax=4.0000000
    Texture=Texture'CBT_DYN_Icons.AI.Worker_node'
    DrawScale=-2.0000000
}