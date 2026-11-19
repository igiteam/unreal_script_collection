//=============================================================================
// SASTerroristGroup.uc
//
//=============================================================================

class SASTerroristGroup extends Actor
	notplaceable
	native;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

//-----------------------------------------------------------------------------
// Constants

const MEMBER_FIRE_AND_MOVE_CHECK_INTERVAL	= 0.125f;
const MIN_TIME_BETWEEN_MEMBER_MOVES			= 2.0f;


//-----------------------------------------------------------------------------
// Enums

enum ETerroristMsgType
{
	TGMSG_ReachedCover,
	TGMSG_Firing,
	TGMSG_StoppedFiring,
	TGMSG_WantToMove,
	TGMSG_Moving,
	TGMSG_Reloading,
	TGMSG_FinishedReloading,
	TGMSG_JoinedGroup,
	TGMSG_LeavingGroup,
};


//-----------------------------------------------------------------------------
// Structs

//-----------------------------------------------------------------------------
// Variables

var const SASTerroristMgr			mTerroristMgr;	// Ptr to level terrorist manager.
var const int						mGroupID;		// Unique group ID.	
var const bool						mbLockedActive;	// If true, forces group to remain on terrorist manager's active group list even when empty. 
var const SASTerroristGroup			mNextGroup;		// Ptr to next group in linked list.
var const SASTerroristController	mMemberList;	// Ptr to head of linked list of group members.
var const int						mNumMembers;	// Num members in group.

var const Vector					mCachedCentrePos;		// Cached average group membe location.
var const float						mCachedRadius;			// Cached group radius.
var const float						mCachedCentrePosTime;	// Last level time the centre pos was assessed.		

var const float						mFireAndMoveCheckCtr;	// Counter for updating sending members to new CPs
var const float						mFireAndMoveCheckFlag;	// 
var const float						mLastMemberMoveTime;	// Level time when last member started a move to a new CP.


//-----------------------------------------------------------------------------
// Native Functions

///////////////////////////////////////////////////////////////////////////////
// AddMember
//
native final function AddMember(
	SASTerroristController	aNewMember );


///////////////////////////////////////////////////////////////////////////////
// RemoveMember
//
native final function RemoveMember(
	SASTerroristController	aMemberToRemove );


///////////////////////////////////////////////////////////////////////////////
// SendMessage
//
native final function SendMessage(
	SASTerroristController	aSender,
	ETerroristMsgType		aeMsgType,
	optional Actor			aOther );	


///////////////////////////////////////////////////////////////////////////////
// GetClosestMemberToGroupCentre
//
native final function SASTerroristController GetClosestMemberToGroupCentre();


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DisplayDebug
//
function DisplayDebug(
	Canvas		aCanvas,		// Canvas to render to 
	out float	aYL,			// Line spacing
	out float	aYPos )			// Current line y-position
{
	aCanvas.SetDrawColor( 255, 255, 255 );

	aCanvas.SetPos( 32, aYPos );

	aCanvas.DrawText( "Terrorist Group: "$self$", Num members = "$mNumMembers );
	aYPos +=aYL;
	aCanvas.SetPos( 32, aYPos );
}


///////////////////////////////////////////////////////////////////////////////
// DisplayGroupDebug
//
function DisplayGroupDebug(
	Canvas		aCanvas,		// Canvas to render to 
	out float	aYL,			// Line spacing
	out float	aYPos )			// Current line y-position
{
	local SASTerroristController TC;
	local float time;

	aCanvas.SetPos( 40, aYPos );

	aCanvas.DrawText( "Terrorist Group: "$self$", ID = "$mGroupID$", Num members = "$mNumMembers );
	aYPos +=aYL;
	aCanvas.SetPos( 40, aYPos );

	if ( mCachedCentrePosTime != -1.0 )
	{
		time = Level.TimeSeconds - mCachedCentrePosTime;
	}
	else
	{
		time = -1.0;
	}
	aCanvas.DrawText( "Cached centre pos: "$mCachedCentrePos$", cached radius: "$mCachedRadius$", time since updated: "$time  );
	aYPos +=aYL;
	aCanvas.SetPos( 44, aYPos );

	if ( mMemberList != None )
	{
		aCanvas.DrawText( "Group members:");
		aYPos +=aYL;
		aCanvas.SetPos( 44, aYPos );

		TC = mMemberList;
		while ( TC != None )
		{
			aCanvas.DrawText( TC.Pawn$", State = "$TC.GetStateName() );
			aYPos +=aYL;
			aCanvas.SetPos( 44, aYPos );

			TC = TC.mNextInGroup;
		}	
	}
	else
	{
		aCanvas.DrawText( "Group is empty and on active list!!!!" );
		aYPos +=aYL;
	}

	aCanvas.SetPos( 32, aYPos );
}


//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    bHidden=true
}