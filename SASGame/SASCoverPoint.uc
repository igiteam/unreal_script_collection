//=============================================================================
// SASCoverPoint.uc
//
//=============================================================================

class SASCoverPoint extends SASAIMapObj
	native
	placeable;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

//-----------------------------------------------------------------------------
// Constants

const SPINOUT_ATTACK_OFS_STAND_LEFT			= 57.0;
const SPINOUT_ATTACK_OFS_STAND_RIGHT		= 44.0;
const SPINOUT_ATTACK_OFS_SQUAT_LEFT			= 58.0;
const SPINOUT_ATTACK_OFS_SQUAT_RIGHT		= 49.0;

const MAX_COVER_HIDE_ADJUST_INCREMENTS		= 2;
const COVER_HIDE_ADJUST_INCREMENT_SIZE		= 16.0f;

//-----------------------------------------------------------------------------
// Enums

enum ECoverSetting
{
	COVER_None,
	COVER_Low,
	COVER_Medium,
	COVER_High,
};


//-----------------------------------------------------------------------------
// Structs

struct native EPCoverInfo
{
	var NavigationPoint	FirstVisibleNav;
	var bool			bNavInCoverArc;
};



//-----------------------------------------------------------------------------
// Member Vars

var Material mCoverTextures[4];

var(TacticalPoint) ESASStance		meFireStance;
var(TacticalPoint) bool				mbDuckWhenCrouched;
var(TacticalPoint) EFirePosAdjust	meFirePosAdjust;
var(TacticalPoint) bool				mbSpinoutPoint;
var(TacticalPoint) EWpnHoldingPose	meWpnHoldingPose;
var(TacticalPoint) float			mUndisciplinedFireChance;
var(TacticalPoint) float			mUndisciplinedFireThreatRange;
var(TacticalPoint) bool				mbCanFireRoundCover;
var(TacticalPoint) bool				mbCanFireOverCover;
var(TacticalPoint) bool				mbAllowTerrorists;			
var(TacticalPoint) bool				mbAllowHostages;			//
var(TacticalPoint) float			mArcOfCover;				// Angle either side of CP rotation over which cover is effective 
var float			mCoverValue;				// Measure of degree of protection provided by CP
var(TacticalPoint) ECoverSetting	meCoverSetting;
var(TacticalPoint) float			mFireOfsLeft;
var(TacticalPoint) float			mFireOfsRight;
var(TacticalPoint) edfindable SASScriptedSequence	mScript;	// Scripted sequence to run on pawn at this CP
var(TacticalPoint) bool				mbScriptPlayOnlyOnce;		// Run script only on first time CP is reached
var(TacticalPoint) edfindable array<SASGrenadePoint>	mGrenadePoints;	// Grenade points that can be thrown at from this CP
var	array<EFirePosAdjust>			mGrenadeThrowPositions;
var(TacticalPoint) float			mGrenadeThrowProbability;	// Chance of throwing grenade from this CP on first attack from the CP
var(TacticalPoint) float			mGrenadeThrowProbSuccessive;	// Chance of throwing grenade from this CP on successive attacks
var const array<EPCoverInfo>		mEPCoverInfo;

var int					mMaxHideAdjustIncrementLeft;
var int					mMaxHideAdjustIncrementRight;

var	vector				mFirePosLeft;
var	vector				mFirePosRight;
var	bool				mbScriptPlayed;
var bool				mbCurOwnerPlayedScript;	
var float				mLastTerroristInvestigateTime;			// Last time CP was investigated by a terrorist.


//-----------------------------------------------------------------------------
// Native Functions

native(754) final function NavigationPoint GetFocalNavPointFromEP(
	SASEntryPoint	aEP );

//-----------------------------------------------------------------------------
// Exec Functions

//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DrawDebug
//
function DrawDebug(
	HUD		aHUD )
{
	local vector	dir;
	local rotator	rotn;
	local Color		lineCol;

	lineCol = class'Canvas'.Static.MakeColor(255,0,0);

	rotn = Rotation;
	rotn.Roll = 0.0;
	rotn.Pitch = 0.0;
	
	rotn.Yaw -= mArcOfCover;
	dir = Vector(rotn);
	aHUD.Draw3DLine (Location, Location + (dir*CollisionRadius), lineCol);

	rotn.Yaw += 2*mArcOfCover;
	dir = Vector(rotn);
	aHUD.Draw3DLine (Location, Location + (dir*CollisionRadius), lineCol);
}


///////////////////////////////////////////////////////////////////////////////
// PostBeginPlay
//
event PostBeginPlay()
{
	local Vector	right; 

	Super.PostBeginPlay();

	// Calculate and store fire position vectors.
	right.X = -mDirection2D.Y;
	right.Y = mDirection2D.X;

	// Left firing position
	mFirePosLeft = Location - (right * mFireOfsLeft);

	// Right firing position
	mFirePosRight = Location + (right * mFireOfsRight );

	// Cant fire over if cover point stance is not crouched.
	if ( meStance != STANCE_Crouched )
	{
		mbCanFireOverCover = false;
	}
}


///////////////////////////////////////////////////////////////////////////////
// Acquire
//
event bool Acquire(
	Pawn	aTaker )
{
	if ( !Super.Acquire( aTaker ) )
	{
		return false;
	}

	mbCurOwnerPlayedScript = false;

	return true;
}


///////////////////////////////////////////////////////////////////////////////
// GetFiringLocation
//
function Vector GetFiringLocation(
	EFirePosAdjust aeFireOffset )
{
	if ( aeFireOffset == FPA_Left )
	{
		return mFirePosLeft;
	}
	else if ( aeFireOffset == FPA_Right )
	{
		return mFirePosRight;
	}
	else
	{
		return Location;
	}
}


///////////////////////////////////////////////////////////////////////////////
// ReachedPlayScript
//
function bool ReachedPlayScript()
{
	// Can't play script if no script or controller to play script on
	if ( (mScript == None) 
		|| (mOwner == None)
		|| (mOwner.Controller == None)
		|| (SASAIController(mOwner.Controller) == None) )
	{
		return false;
	}

	// Can't play script if it has already been played and script can only
	// be played once.
	if ( (mbScriptPlayed && mbScriptPlayOnlyOnce) || mbCurOwnerPlayedScript )
	{
		return false;
	}

	mbScriptPlayed = true;
	mbCurOwnerPlayedScript = true;
	mScript.RunScriptOnAIController( SASAIController( mOwner.Controller ) );

	return true;
}


function Vector GetCoverAdjustPos(
	int aIncrement )
{
	local Vector	right;

	if ( aIncrement == 0 )
	{
		return Location;
	}

	right.X = -mDirection2D.Y;
	right.Y = mDirection2D.X;
	
	if ( aIncrement < 0 )
	{
		if ( aIncrement < mMaxHideAdjustIncrementLeft )
		{
			return Location;
		}
	}
	else
	{
		if ( aIncrement > mMaxHideAdjustIncrementRight )
		{
			return Location;
		}
	}

	return Location + (right * (aIncrement * COVER_HIDE_ADJUST_INCREMENT_SIZE)); 
}


//-----------------------------------------------------------------------------
// States

//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mCoverTextures[0]=Texture'EditorTx.S_CoverNone'
    mCoverTextures[1]=Texture'EditorTx.S_CoverLow'
    mCoverTextures[2]=Texture'EditorTx.S_CoverMed'
    mCoverTextures[3]=Texture'EditorTx.S_CoverHigh'
    mbDuckWhenCrouched=true
    meWpnHoldingPose=2
    mUndisciplinedFireThreatRange=500.0000000
    mbAllowTerrorists=true
    mbAllowHostages=true
    mArcOfCover=8192.0000000
    mCoverValue=-1.0000000
    meCoverSetting=2
    mFireOfsLeft=32.0000000
    mFireOfsRight=32.0000000
    Texture=Texture'EditorTx.S_Cover'
}