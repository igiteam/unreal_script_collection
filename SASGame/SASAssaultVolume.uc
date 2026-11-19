//=============================================================================
// SASAssaultVolume.uc
//
// Volume used to define an assault area - usually one per room.
// The class holds information about the area - e.g. cover point, entry points.
// It is also used by the AI for determining room locations of other
// pawns.
//=============================================================================

class SASAssaultVolume extends Volume
	native;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Structs


//-----------------------------------------------------------------------------
// Member variables

var() int							mRoomIndex;			// Used for room clearance (is associated with assault point groups, domination points, room clear order, etc.)
var () bool							mLargeVolume;		// True if this is a special-case exterior or large interior volume

var const SASAssaultVolume			mNextAssaultVolume;	// Link to next assault volume in level's linked list
var const array<SASEntryPoint>		mEntryPoints;		// Array of entry points linked to this volume
var const array<SASCoverPoint>		mCoverPoints;		// Array of cover points in this volume
var const array<SASDominationPoint>	mDominationPoints;	// Array of domination points in this volume
var const array<NavigationPoint>	mNavPoints;			// Array of navigation points in this volume
var bool							mbPathEndAV;
var float							mLastTerroristInvestigateTime;	// Level time this AV was last investigated by a terrorist.

var const array<byte>				mShortestPathMatrix;	// Pre-calculated path data for this AV.				

// Vars for AV->AV path finding.
var const int						mVisitedWeight;
var const SASAssaultVolume			mNextOrdered;	
var const SASAssaultVolume			mPrevOrdered;	
var const SASAssaultVolume			mPreviousPath;

// Hostage speech control.
var int								mNumTerroristIdents;
var int								mNumBombIdents;


//-----------------------------------------------------------------------------
// Native Functions

///////////////////////////////////////////////////////////////////////////////
// GetClosestCoverPoint
//
// Find closest cover point in this assault volume to specified pawn.
native(760) final function SASCoverPoint GetClosestCoverPointToPawn(
	Pawn	aPawn );

native(761) final function SASDominationPoint GetClosestDominationPointToActor(
	Actor	aOther,
	int		aExclusionFlags );

native(762) final function SASDominationPoint GetClosestDominationPointToPosition(
	Vector	aPoint,
	int		aExclusionFlags );

native(763) final function SASDominationPoint GetSecondClosestDominationPointToActor(
	Actor	aOther,
	int		aExclusionFlags );

native(764) final function SASEntryPoint GetSharedEntryPoint(
	SASAssaultVolume	aOther );

native(765) final function SASEntryPoint GetClosestSharedEntryPoint(
	Actor				aActor,
	SASAssaultVolume	aOther,
	optional bool		abOnlyUnblockedEPs );

native(766) final function SASEntryPoint GetClosestEntryPointToPawn(
	Pawn				aPawn,
	optional bool		abOnlyUnblockedEPs );

native(767) final function ResetClearFlags();

native(768) final function SASAssaultVolume IsPointWithinConnectedVolume(
	Vector aTestPoint );

native(769) final function bool IsPawnTypeInVolume(
	byte	aPawnType );


//-----------------------------------------------------------------------------
// Exec Functions

//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// PreBeginPlay
//
event PreBeginPlay()
{
	local SASGameInfo	gi;

	Super.PreBeginPlay();

	// Add self to the level's SASGameInfo object
	gi = SASGameInfo( Level.Game );
	if (gi == None)
	{
		warn("Can't add assault volume to game info's list. SASGameInfo object does not exist.");
		return;
	}

	gi.AddAssaultVolume( self );
}


///////////////////////////////////////////////////////////////////////////////
// Destroyed
//
event Destroyed()
{
	local SASGameInfo	gi;

	Super.Destroyed();

	// Remove self from the level's SASGameInfo object
	gi = SASGameInfo( Level.Game );
	if (gi == None)
	{
		warn("Can't remove destroyed assault volume from game info's list. SASGameInfo object does not exist.");
		return;
	}

	gi.RemoveAssaultVolume( self );
}


//-----------------------------------------------------------------------------
// States

//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    BrushColor=(R=32,G=243,B=239,A=255)
    bColored=true
}