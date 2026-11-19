//=============================================================================
// SASTerroristMgr.uc
//
// Arbitrator used to determine which terrorists are allowed to be in attacking
// state at any one time.
//=============================================================================

class SASTerroristMgr extends Actor
	native
	notplaceable;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.


//-----------------------------------------------------------------------------
// Constants

const MAX_ATTACKING_TERRORISTS			= 8;					// Max number of attacking terrorists at any one time.
const MAX_TERRORIST_GROUPS				= 4;					// Max terrorist groups.
const GROUPING_UPDATE_PERIOD			= 2.0;					// Time between reassessing dynamic terrorist grouping.
const GROUP_MERGE_OR_BALANCE_INTERVAL	= 2.0;

const TERR_GROUP_MAX_RADIUS				= 500.0;	// ~10m		// Max radius of a terrorist group.
const TERR_GROUP_OPTIMAL_SIZE_MIN		= 4;					// Min/max optimal number of members in a group 
const TERR_GROUP_OPTIMAL_SIZE_MAX		= 6;					//
const TERR_GROUP_SIZE_MAX				= 8;					// Max number of members in a group.

const MIN_TIME_BETWEEN_TERRORIST_CALL_BACKUP	= 2.0;

const MAX_INVESTIGATING_TERRORISTS		= 2;
const MIN_TIME_BETWEEN_INVESTIGATIONS	= 3.0;

const MIN_TIME_BETWEEN_INVESTIGATIONS_ATTACKING = 10.0;

//-----------------------------------------------------------------------------
// Enums


enum EGroupUpdateStage
{
	GROUPUPDATE_Attract,	// Existing groups attract ungrouped terrorists.
	GROUPUPDATE_Form,		// Still ungrouped terrorists try to form new groups.
	//GROUPUPDATE_Exchange,	// Exchange members in overlapping groups.
	GROUPUPDATE_Merge,		// Check for groups which can entirely merge together.
	GROUPUPDATE_Balance,	// Swap members between groups to even out numbers.
	GROUPUPDATE_End,
};

enum EGroupAttractStage
{
	GROUPATTRACT_Begin,
	GROUPATTRACT_Seek,
	GROUPATTRACT_CheckGroupContact,
	GROUPATTRACT_Enrol,
	GROUPATTRACT_End,
};

enum EGroupFormStage
{
	GROUPFORM_Begin,
	GROUPFORM_CheckContacts,
	GROUPFORM_Form,
	GROUPFORM_End,
};

enum EGroupMergeStage
{
	GROUPMERGE_Begin,
	GROUPMERGE_CheckContacts,
	GROUPMERGE_Merge,
	GROUPMERGE_End,
};

enum EGroupBalanceStage
{
	GROUPBALANCE_Begin,
	GROUPBALANCE_Seek,
	GROUPBALANCE_CheckGroupContact,
	GROUPBALANCE_Transfer,
	GROUPBALANCE_End,
};


//-----------------------------------------------------------------------------
// Structs

struct native GroupMergePair
{
	var int	GroupIDs[2];
	var int	NumContacts;
};


//-----------------------------------------------------------------------------
// Member variables

var SASTerroristController			mTerroristList;	// List of live terrorists in the level.

// Attacking terrorist list.
var const SASTerroristController	mAttackingTerrorists[MAX_ATTACKING_TERRORISTS];		// Array of attacking terrorists.
var const int						mNumAttackingTerrorists;							// Current number of attacking terrorists in level.

// Terrorist grouping vars.										 
var const SASTerroristGroup			mActiveGroupList;					// Ptr to head of linked list of currently active groups.
var const SASTerroristGroup			mInactiveGroupList;					// Ptr to head of linked list of free groups. 

// Progressive grouping control parameters.
var const EGroupUpdateStage			meGroupUpdateStage;					// Current grouping update stage.
var const EGroupAttractStage		meGroupAttractStage;				// Current substage of 'attract' update stage.
var const EGroupFormStage			meGroupFormStage;					// Current substage of 'form' update stage.
var const EGroupMergeStage			meGroupMergeStage;					// Current substage of 'merge' update stage.
var const EGroupBalanceStage		meGroupBalanceStage;				// Current substage of 'balance' update stage.
var const bool						mbMergeOrBalanceFlag;				// Toggled flag to indicate if should try to merge or balance groups next.  
var const float						mNextGroupMergeOrBalanceTime;		// Next level time after which a merge or balance stage can occur.
var const int						mGroupUpdatePrimaryTag;				
var const int						mGroupUpdateSecondaryTag;
var const int						mCurGroupUpdateGroupID;				// ID of current group being processed during group update.
var const float						mClosestUngroupedContactDistSq;		// Dist (squared) bewtween closest ungrouped terrorist pair (used during group form stage).
var const SASTerroristController	mClosestUngroupedContactPair[2];	// Ptrs to closest ungrouped terrorist pairs.
var const array<GroupMergePair>		mMergePairs;						// Array of potential groups to merge.
var const int						mMergePairCheckingIdx;

// Other stuff.
var float							mLastCallForBackupTime;
var const float						mUpdateInvestigateTime;
var float							mMinGrenadeShoutTime;

var const SASTerroristController	mInvestigatingTerrorists[MAX_INVESTIGATING_TERRORISTS];
var const int						mNumInvestigatingTerrorists;
var const float						mLastInvestigatingAtCapacityTime;

var const float						mLastInvestigateOrAttackingTime;

// DEBUGGING VARS
struct native TerrGroupMergeInfo
{
	var SASTerroristGroup	Groups[2];
	var Vector				PreMergeLocs[2];
	var float				PreMergeRadii[2];
	var Vector				MergedLoc;
	var float				MergedRadius;
	var float				MergeTime;
};
var const TerrGroupMergeInfo	mDbgMergeInfo[MAX_TERRORIST_GROUPS];
var const int					mDbgNextMergeInfoIdx;


//-----------------------------------------------------------------------------
// Native functions


///////////////////////////////////////////////////////////////////////////////
// AddTerrorist
//
// Add a terrorist to our linked list of terrorists in the level.
native final function AddTerrorist(
	SASTerroristController	aNewTC );


///////////////////////////////////////////////////////////////////////////////
// RemoveTerrorist
//
// Remove a terrorist from our linked list of terrorists in the level.
native final function RemoveTerrorist(
	SASTerroristController	aTCToRemove );


///////////////////////////////////////////////////////////////////////////////
// RequestBeginAttack
//
// Called by a terrorist controller when it wishes to commence an attack. 
// If the max number of attacking terrorists is less than the max or this terrorist
// takes attack precedence over a currently attacking terrorist then returns true,
// else returns false - terrorist must fallback.
native(800) final function bool RequestBeginAttack( 
	SASTerroristController	aRequesting );


///////////////////////////////////////////////////////////////////////////////
// EndingAttack
//
// Called when a terrorist leaves an attacking state.
native(801) final function EndingAttack(
	SASTerroristController	aEnding );


///////////////////////////////////////////////////////////////////////////////
// RequestInvestigate
//
// Called by terrorist when it wants to investigate a noise it has heard.
// On next frame, manager will select best requesting terrorists to send. 
native(802) final function RequestInvestigate(
	SASTerroristController	aRequesting,
	SASPawn					aThreatToInvestigate );


///////////////////////////////////////////////////////////////////////////////
// StartInvestigating
//
native(803) final function bool StartInvestigating( 
	SASTerroristController	aTC );


native(804) final function bool EndInvestigating(
	SASTerroristController	aTC );



//-----------------------------------------------------------------------------
// Functions

function bool CheckGrenadeShout(
	SASGrenadeProjectile	aGrenade )
{
	if ( aGrenade == None )
	{
		return false;
	}

	// Don't allow grenade shouts to repeat too frequently.
	if ( Level.TimeSeconds < mMinGrenadeShoutTime )
	{
		return false;
	}

	// Only shout if an alert has not been made about this grenade or not close to it's current location.
	if (	(aGrenade.mLastShoutLocation == vect(0,0,0)) ||
			VSizeSq( aGrenade.Location - aGrenade.mLastShoutLocation ) > Square( 1000.0 ) )
	{
		aGrenade.mLastShoutLocation = aGrenade.Location;

		mMinGrenadeShoutTime = Level.TimeSeconds + RandRange( 1.0, 1.5 );

		return true;
	}

	return false;
}


///////////////////////////////////////////////////////////////////////////////
// DisplayGroupDebug
//
function DisplayGroupDebug(
	Canvas		aCanvas,		// Canvas to render to 
	out float	aYL,			// Line spacing
	out float	aYPos )			// Current line y-position
{
	local SASTerroristGroup	group;

	aCanvas.SetDrawColor( 255, 255, 255 );

	aCanvas.SetPos( 32, aYPos );

	aCanvas.DrawText( "*** TERRORIST MANAGER ***" );
	aYPos +=aYL;
	aCanvas.SetPos( 32, aYPos );

	aCanvas.DrawText( "Num attacking = "$mNumAttackingTerrorists );
	aYPos +=aYL;
	aCanvas.SetPos( 32, aYPos );

	aCanvas.DrawText( "Num investigating = "$mNumInvestigatingTerrorists );
	aYPos +=aYL;
	aCanvas.SetPos( 32, aYPos );

	aCanvas.DrawText( "Grouping update stage = "$meGroupUpdateStage );
	aYPos +=aYL;
	aCanvas.SetPos( 32, aYPos );

	if ( mActiveGroupList != None )
	{
		aCanvas.DrawText( "Groups:");
		aYPos +=aYL;
		aCanvas.SetPos( 32, aYPos );

		group = mActiveGroupList;
		while ( group != None )
		{
			group.DisplayGroupDebug( aCanvas, aYL, aYPos );
			group = group.mNextGroup;
		}
	}
	else
	{	
		aCanvas.DrawText( "No active groups.");
		aYPos +=aYL;
		aCanvas.SetPos( 32, aYPos );
	}

	DisplayGroupUpdateStages( aCanvas, aYL,	aYPos ); 

	// Output info of recent group merges.
	/*mergeInfoIdx = (mDbgNextMergeInfoIdx-1) % MAX_TERRORIST_GROUPS;
	do
	{
		if ( mDbgMergeInfo[mergeInfoIdx].MergeTime == 0.0 )
		{
			break;
		}

		aCanvas.SetPos( 40, aYPos );

		aCanvas.DrawText( "Merged groups "$mDbgMergeInfo[mergeInfoIdx].Groups[0]$" and "$mDbgMergeInfo[mergeInfoIdx].Groups[1]$" at "$mDbgMergeInfo[mergeInfoIdx].MergeTime );
		aYPos +=aYL;
		aCanvas.SetPos( 40, aYPos );

		mergeInfoIdx = (mergeInfoIdx-1) % MAX_TERRORIST_GROUPS;
	} until ( mergeInfoIdx == mDbgNextMergeInfoIdx );*/
}


///////////////////////////////////////////////////////////////////////////////
// DisplayGroupUpdateStages
//
function DisplayGroupUpdateStages(
	Canvas		aCanvas,		// Canvas to render to 
	out float	aYL,			// Line spacing
	out float	aYPos )			// Current line y-position
{
	local EGroupUpdateStage	stage;

	aCanvas.SetPos( 32, aYPos );

	stage = GROUPUPDATE_Attract;
	while ( stage != GROUPUPDATE_End )
	{
		if ( stage == meGroupUpdateStage )
		{
			aCanvas.SetDrawColor( 0, 255, 0 );
		}
		else
		{
			aCanvas.SetDrawColor( 255, 255, 255 );
		}

		switch ( stage )
		{
		case GROUPUPDATE_Attract:
			aCanvas.DrawText( "ATTRACT" );
			stage = GROUPUPDATE_Form;
			break;
		case GROUPUPDATE_Form:
			aCanvas.DrawText( "FORM" );
			stage = GROUPUPDATE_Merge;
			break;
		//case GROUPUPDATE_Exchange:
		//	aCanvas.DrawText( "EXCHANGE" );
		//	break;
		case GROUPUPDATE_Merge:
			aCanvas.DrawText( "MERGE" );
			stage = GROUPUPDATE_Balance;
			break;
		case GROUPUPDATE_Balance:
			aCanvas.DrawText( "BALANCE" );
			stage = GROUPUPDATE_End;
			break;
		}
		aYPos +=aYL;
		aCanvas.SetPos( 32, aYPos );
	}
}


///////////////////////////////////////////////////////////////////////////////
// DisplayGroupWorldSpaceOverlays
//
function DisplayGroupWorldSpaceOverlays(
	HUD	aHUD )
{
	local SASTerroristGroup			group;
	local SASTerroristController	member;
	local SASTerroristController	centralMember;
	local Color						drawCol;
	
	drawCol = class'Canvas'.Static.MakeColor( 255, 255, 0 );

	group = mActiveGroupList;
	while ( group != None )
	{
		centralMember = group.GetClosestMemberToGroupCentre();
		if ( centralMember != None )
		{
			member = group.mMemberList;
			while ( member != None )
			{
				if ( member != centralMember )
				{
					aHUD.Draw3DLine( centralMember.Pawn.Location, member.Pawn.Location, drawCol );
				}

				member = member.mNextInGroup;
			}
		}

		group = group.mNextGroup;
	}
}


//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    bHidden=true
}