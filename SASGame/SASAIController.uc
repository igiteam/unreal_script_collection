//=============================================================================
// SASAIController.uc
//=============================================================================

class SASAIController extends AIController
	dependson(SASClimbPoint)
	native;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

//-----------------------------------------------------------------------------
// Constants

// Max grenades aware of at any one time.
const MAX_DETECTED_GRENADES			= 3;	

const SEEK_COVER_DEFAULT_RANGE		= 480.0f;
const SEEK_COVER_MAX_RANGE			= 960.0f;

const FIRING_RECHECK_INTERVAL		= 0.1f;
const LOF_CHECK_INTERVAL_NOT_FIRING	= 0.3f;
const LOF_CHECK_INTERVAL_FIRING		= 0.5f;
const MAX_BLOCKED_LOF_TIME			= 0.8f;
const BURST_FIRING_MIN_DIST			= 250.0f;

const MAX_DIST_FACING_WALL			= 150.0f;

const ALERTING_RANGE				= 1400.0f;

const STEPPING_ASIDE_MAX_TIME		= 2.0f;
const WALK_TO_POINT_DIST			= 80.0f;		// Changed from 150 by AF

const VERTICAL_AIMING_ACQUISITION_THRESHOLD	= 1820;
const AIM_AT_HEAD_MAX_DIST			= 150.0f;


//-----------------------------------------------------------------------------
// Enums

enum ELatentUpdateDestStage
{
	UPDATEDESTSTAGE_Queued,
	UPDATEDESTSTAGE_FindAnchors,
	UPDATEDESTSTAGE_FindPath,
	UPDATEDESTSTAGE_End,
};

enum EStepAsidePriority
{
	STEPASIDEPRIORITY_Low,
	STEPASIDEPRIORITY_Medium,
	STEPASIDEPRIORITY_High,
};


//-----------------------------------------------------------------------------
// Structs

// Info on a detected grenade.
struct native GrenadeInfo
{
	var SASGrenadeProjectile	Grenade;
	var float					MinReactLevelTime;
};

//-----------------------------------------------------------------------------
// Member Variables

// General
var SASPawn					mSASPawn;					// Cached ptr to our pawn cast to an SASPawn.
var name					mNextState;					// Used by some states to specify a follow on state. 
var name					mNextLabel;					// Used by some states to specify a follow on state label.
var bool					mbIsAlert;					// Flag set on first becoming aware of threats etc.
var float					mStunnedThreshold;			// 
var bool					mbCanSeeEndOfGun;

// Timers used by all AI controllers.
var int						mTimerFiring;				// Timer used to repeatedly attempt to fire at target.
var int						mTimerCheckDoor;			// Timer used when waiting for door to open to check things are progressing.
var int						mTimerAvoiding;				// Timer used during avoiding state to reevaluate avoidance situ.
var int						mTimerReassess;				// Timer used for general reassessing of state.
var int						mTimerSpeech;

// Senses
var bool					mbCanSee;					// To turn on/off sight detection (evaluated in native code)
var bool					mbCanHear;					// To turn on/off sound detection (evaluated in native code)
var bool					mbCanFeelDamage;			// To turn on/off damage response
var bool					mbIgnoreEnemy;				// Will ignore sighted enemy when set - moved from SASSoldierController

// Movement
var Actor					mGoalActor;					// Destination actor when in MovingState state.
var Vector					mGoalLocation;				// Dest location when in MovingState state (used when mGoalActor == None)
var ESASPace				meMovingStatePace;			// If true should walk when in MovingState
var ESASStance				meMovingStance;				// Stance during move in MovingState state.
var Actor					mMovingFocalActor;			// Actor to focus on when in MovingState state.
var Vector					mMovingFocalPoint;			// Point to focus on when in Moving state if mMovingFocalActor undefined.
var float					mGoalDestOffset;			// Optional goal offset range threshold when moving moving to actor.
var bool					mbPreciseReachGoal;			// If true, should do precision move to accurately reach goal location.
var float					mCutCornerTimer;			// Timer to control checking corner cutting when path-following.
var float					mUpdateDestLatentStartTime;
var ELatentUpdateDestStage	meUpdateDestLatentStage;
var bool					mbMoveFound;
var bool					mbFailedMoveToPoint;		// Set to true if fail to reach destination during MovingState state.
var float					mStuckTestStartTime;
var Vector					mStuckTestStartLocation;
var SASAssaultVolume		mMovingStateAvoidVolume;

var const bool				mbMonitoringAssaultVol;		// 
var const SASAssaultVolume	mLastMonitoredAssaultVol;

// Navigation
var SASDoorMover			mInteractDoor;				// Door currently openning.
var bool					mbOpeningDoor;
var SASClimbPoint			mClimbStart;				// Climb point at when in climbing state.
//var SASEntryPoint			mEPRouteCache[8];			// Route cache of EPs in last route found.
var float					mApproachingClosedDoorTimer;

// Avoidance
var byte					mStepAsideForPawnTypesAlways;		// Bitfield of types of pawn we should always step aside for.  
var byte					mStepAsideForPawnTypesLowPriority;	// Bitfiend of other pawn types we can give way to if in low priority action.
var Vector					mStepAsidePoint;	
var float					mStepAsideStartTime;
var Actor					mSteppingAsideFor;
var bool					mbIgnoreDoorBump;
var bool					mbIgnorePawnBump;

// Scripting
var SASScriptInterface		mScriptInterface;			// Scripting interface object.
var SASScriptedSequence		mPendingScript;				// Pending script to activate after delay 
var float					mPendingScriptTimer;		// Pending script delay timer
var float					mScriptTimerActionTimeToTrigger;

// Detected grenades
var const GrenadeInfo		mDetectedGrenades[MAX_DETECTED_GRENADES];	// Array of all grenades the controller is aware of
var const int				mNumGrenadesDetected;		// Num detected grenades the controller is aware of
var bool					mbIgnoreGrenades;
var bool					mbIgnoreGasGrenades;
var float					mLastGasGrenadeIgnoreTime;

// Weapon related vars
var float					mFiringDurationTimer;		// Countdown to ending firing.
var bool					mbBurstFiring;				// True if in burst firing mode.
var bool					mbStartedBurst;				// True after firing first shot of a burst
var bool					mbBurstToggleFlag;			// If true then trying to fire a burst else in interval before next burst.
var int						mPreferredAimSpot;			// Aim location we'd like to aim at (but possibly dont have LoF to).
var int						mAimSpot;					// Location (chest/head etc) to aim weapon at.
var float					mRetryPreferredAimSpotTimer; // Timer to reattempt firing at the preferred aim spot if not doing so. 
var bool					mbUseTargetPoint;			// If true then will fire at mTargetPoint location rather than Target actor.
var Vector					mTargetPoint;				// Location to fire at when mbUseTargetPoint is true.
var SASGrenadePoint			mGrenadePoint;				// Point to aim at when throwing grenade.
var EGrenadeCategory		mThrowGrenadeType;			// Category of grenade to throw in ThrowingGrenade state.
var bool					mbThrownGrenade;
var bool					mbTestLineOfFire;			// If true then checks for clear line of fire before firing.
var bool					mbHasLineOfFire;			// True if had line of fire to target when last checked.
var float					mLineOfFireCounter;			// Timer used for re-checking line of fire (updating above flag).
var float					mLastLoFFailTime;			// Level time of last LoF failure.
var Vector					mLastLoFFailPos;			// Our position at last LoF failure.
var Actor					mLastLoFFailTarget;			// Target at last LoF failure.
var Vector					mLastLoFFailTargetPos;		// Target position at last LoF failure.
var float					mBlockedLoFTimer;			// Timer for notifying AI when line of fire blocked for a duration of time.
var float					mBlockedLoFStartTime;		// Level time at which LoF first became blocked while repeat firing.
var int						mNumRoundsToFire;			// Number of rounds remaining in current burst of rounds
var bool					mbCanFireEmpty;				// If true then will fire weapon empty for the remainder of the current burst rather than reload immediately. 
var float					mFireEmptyEndTime;

// Aiming params
var name					mTargetBone;				// Bone to aim at

// Strategic points
var SASCoverPoint			mCoverPoint;				// Current cover point.
var SASCoverPoint			mPrevCoverPoint;			// Previous cover point.
var bool					mbAttackedFromCover;		// Have we fired since reaching this CP.		
var float					mCoverReachedTime;			// Level time when reached current CP.
var NavigationPoint			mGrenadeRetreatNavPoint;	// Point to run to when running from grenades if can't find cover.

// Transition state vars
var name					mTransitionAnim;
var float					mTransitionAnimRate;
var name					mTransitionReturnState;			// State to go to once transition animation is complete
var name					mTransitionReturnLabel;			// Optional label to go to in the return state
var	ESASStance				mTransitionReturnStance;		// Stance to be in once transition animation is complete
var	bool					mbTransitionReturnIgnoreEnemy;	// Ignore enemy on return ?
var bool					mbTransitionRootMotion;			// Use RMP in transition anim?

// Sunned/gassed headless chicken wander
var int						mHeadlessChickenDir;		// Rotating clockwise or anticlockwise during wander.
var float					mHeadlessChickenDirTimer;	// Timer used to reverse wandering rotation. 
var int						mHeadlessChickenNumBumps;	// Number of times bumped into things during wandering.

// Going prone
var bool					mbProneDirOnFlatGround;		// True if prone direction is on flat ground.
var Vector					mProneFocalDir;				// Direction for pawn to face when going prone.
var Vector					mLastGoProneTestLoc;		// Last location pawn was when trying to go prone.


//-----------------------------------------------------------------------------
// Native Functions

///////////////////////////////////////////////////////////////////////////////
// CanSeePawn
//
// Returns true if have line of sight to a pawn. Generally cheaper than a 
// line of sight check if the pawn is also the Enemy (or in the case of 
// terrorists, one of the terrorist's mThreats) as it first checks the cached
// enemy last sighting time and assumes the target is visible if seen within
// the sight checking period.
native(601) final function bool CanSeePawn(
	SASPawn			aOther,
	optional bool	abSimpleLineTest );	


///////////////////////////////////////////////////////////////////////////////
// FindLocationToMoveAwayFromBlockingDoor
//
native(602) final function bool FindLocationToMoveAwayFromBlockingDoor( 
	out Vector	aMoveLoc );


///////////////////////////////////////////////////////////////////////////////
// CheckDoorwayClear
//
native(603) final function bool CheckDoorwayClear(
	SASDoorMover	aDoor );


///////////////////////////////////////////////////////////////////////////////
// AddDetectedGrenade
//
// Add grenade to array of detected grenades.
native(604) final function AddDetectedGrenade(
	SASGrenadeProjectile	aGrenade );


///////////////////////////////////////////////////////////////////////////////
// RemoveDetectedGrenade
//
// Remove grenade from array of detected grenades.
native(605) final function RemoveDetectedGrenade(
	SASGrenadeProjectile	aGrenade );


///////////////////////////////////////////////////////////////////////////////
// AwareOfGrenade
//
// Returns true if grenade is already in the list of detected grenades.
native(606) final function bool AwareOfGrenade(
	SASGrenadeProjectile	aGrenade );


///////////////////////////////////////////////////////////////////////////////
// AwareOfGrenadesOfType
//
// Returns true if aware of any grenades of a specified category.
native(607) final function bool AwareOfGrenadesOfType(
	EGrenadeCategory		aeGrenadeType );


///////////////////////////////////////////////////////////////////////////////
// FriendliesUnawareOfNearbyGrenade
//
// Returns true if any nearby allies have not detected grenade 'aGrenade'.  
native(608) final function bool FriendliesUnawareOfNearbyGrenade(
	SASGrenadeProjectile	aGrenade );
	

///////////////////////////////////////////////////////////////////////////////
// IsPawnInFriendlyFireCone
//
native(609) final function bool IsPawnInFriendlyFireCone(
	SASPawn		aOther,
	Vector		aFireDir,
	float		aFireDistSq );


///////////////////////////////////////////////////////////////////////////////
// MonitorAssaultVolChange
//
native(610) final function MonitorAssaultVolChange(
	bool	abEnable );


///////////////////////////////////////////////////////////////////////////////
// SeekClosestCoverInRange
//
// Find closest cover point to pawn within a specified range. 
native(611) final function SASCoverPoint SeekClosestCoverInRange(
	float			aSeekRange,
	optional bool	abOnlyInSameAV );


///////////////////////////////////////////////////////////////////////////////
// SeekCoverFromActor
//
// Find CP which provides cover from a specified actor's location. 
native(612) final function SASCoverPoint SeekCoverFromActor(
	Actor			aOther,
	float			aSeekRange,
	optional bool	abOnlyInSameAV );


///////////////////////////////////////////////////////////////////////////////
// PointCloseToEntryPoint
//
native(613) final function bool PointCloseToEntryPoint(
	Vector	aTestPoint );


///////////////////////////////////////////////////////////////////////////////
// GetClosestVisibleEPInRange
//
native(614) final function SASEntryPoint GetClosestVisibleEPInRange(
	float	aRange );


///////////////////////////////////////////////////////////////////////////////
// CoverPointExposedTo
//
// Returns True if current cover point is exposed to pawn aOther.
native(615) final function bool CoverPointExposedTo(
	SASPawn	aOther );


///////////////////////////////////////////////////////////////////////////////
// FindGrenadeRetreatPoint
//
native(616) final function Actor FindGrenadeRetreatPoint();


///////////////////////////////////////////////////////////////////////////////
// GrenadeRetreatPointIsSafe
//
native(617) final function bool IsSafePointFromGrenades(
	Actor	aPoint,
	float	aSafetyThresholdDist );


///////////////////////////////////////////////////////////////////////////////
// AllDetectedGrenadesAtRest
//
native(618) final function bool AllDetectedGrenadesAtRest();


///////////////////////////////////////////////////////////////////////////////
// FindStepAsidePoint
//
native(619) final function bool FindStepAsidePoint(
	Actor		aOther,
	out Vector	aStepAsidePt );


///////////////////////////////////////////////////////////////////////////////
// StepAsidePointStillSuitable
//
native(620) final function bool StepAsidePointStillSuitable();


///////////////////////////////////////////////////////////////////////////////
// CheckKeepSteppingAside
//
native(621) final function bool CheckKeepSteppingAside();


///////////////////////////////////////////////////////////////////////////////
// FindAdjustAroundPoint
//
native(622) final function bool FindAdjustAroundPoint(
	Pawn		aOther,
	out Vector	aAdjustAroundPt );


///////////////////////////////////////////////////////////////////////////////
// PredictEntryPointFor
//
// Predict entry point into aDestActor's current AV that another pawn starting
// from aStartActor location or aStartLoc will enter through.
// Returns the index into the assault volumes mEntryPoints array (-1 if failed
// to find one).
native(623) final function int PredictEntryPointFor(
	Actor				aDestActor,
	optional	Actor	aStartActor,
	optional	Vector	aStartLoc );


///////////////////////////////////////////////////////////////////////////////
// FindCoverPointOnRouteTo
//
native(624) final function SASCoverPoint FindCoverPointOnRouteTo(
	NavigationPoint				aGoalNP,
	FLOAT						aSeekRange,
	optional out SASEntryPoint	aFirstEPOnRoute );


///////////////////////////////////////////////////////////////////////////////
// GetClosestReachableNavTo
//
// Returns the closest navigation point to aOther for which out pawn can reach
// aOther from.
native(625) final function NavigationPoint GetClosestReachableNavTo(
	Actor	aOther );


///////////////////////////////////////////////////////////////////////////////
// IsNavPointAValidAnchorForActor
//
native(626) final function bool IsNavPointAValidAnchorForActor(
	NavigationPoint	aAnchorPoint,
	Actor			aTestActor );


///////////////////////////////////////////////////////////////////////////////
// FindDirectionToGoProne
//
native(627) final function bool FindDirectionToGoProne(
	optional int	aAnimAngleAdjust );


///////////////////////////////////////////////////////////////////////////////
// GetAIAimLocation
//
native(628) final function Vector GetAIAimLocation( Actor aOther );


///////////////////////////////////////////////////////////////////////////////
// StartRepeatFiring
//
// Makes controller repeatedly attempt to fire at its current target until
// aNumShots have been fired or StopRepeatFiring() is called.
native(629) final function StartRepeatFiring(
	optional int	aNumShots,
	optional float	aFiringDuration,
	optional bool	abNoLineOfFireTest );


///////////////////////////////////////////////////////////////////////////////
// StartRepeatFiringAtPoint
//
// Makes controller repeatedly attempt to fire at location 'aPoint' until
// aNumShots have been fired or StopRepeatFiring() is called.
native(630) final function StartRepeatFiringAtPoint(
	vector			aPoint,
	optional int	aNumShots,
	optional float	aFiringDuration,
	optional bool	abNoLineOfFireTest );


///////////////////////////////////////////////////////////////////////////////
// StopRepeatFiring
//
native(631) final function StopRepeatFiring();


///////////////////////////////////////////////////////////////////////////////
// InitBurstFiringParams
//
native(632) final function InitBurstFiringParams();


///////////////////////////////////////////////////////////////////////////////
// StartBurstFiring
//
native(633) final function StartBurstFiring(
	optional bool	abNoLineOfFireTest );


///////////////////////////////////////////////////////////////////////////////
// StartBurstFiringAtPoint
//
native(634) final function StartBurstFiringAtPoint(
	vector			aPoint,
	optional bool	abNoLineOfFireTest );


///////////////////////////////////////////////////////////////////////////////
// StartBurstFiringAtPoint
//
native(635) final function StopBurstFiring();


///////////////////////////////////////////////////////////////////////////////
// InitEmptyFiringTimer
//
native(636) final function InitEmptyFiringTimer();


///////////////////////////////////////////////////////////////////////////////
// EnableFiringEmpty
//
native(637) final function EnableFiringEmpty(
	bool abEnable );


///////////////////////////////////////////////////////////////////////////////
// TryingToFire
//
// Returns true if AI is currently attempting to fire weapon using the repeat
// fire mechanism.
native(638) final function bool TryingToFire();


///////////////////////////////////////////////////////////////////////////////
// UpdateRepeatFiring
//
native(639) final function UpdateRepeatFiring(
	float	aDeltaTime );


///////////////////////////////////////////////////////////////////////////////
// FireWeaponAtTarget
//
native(640) final function FireWeaponAtTarget(
	float		aDeltaTime,
	SASWeapon	aWeapon,
	bool		abCheckLineOfFire );


///////////////////////////////////////////////////////////////////////////////
// PointIsInAcquisitionAngle
//
native(641) final function bool PointIsInAcquisitionAngle(
	vector	aPoint );


native(642) final function UpdateDestinationImmediate(
	optional bool abOnlyUnobstructedPath );

native(643) final latent function UpdateDestinationLatent(); 
// native(644) reserved for execPollUpdateDestinationLatent

///////////////////////////////////////////////////////////////////////////////
// StopMoving
// 
native(645) final function StopMoving();

native(646) final function bool FindUnobstructedPath();

//-----------------------------------------------------------------------------
// Exec Functions

//-----------------------------------------------------------------------------
// Functions

function ChangeTeam ( int aTeamID, bool aBool );
function WeaponPointedAt (Pawn aWeaponOwner);

///////////////////////////////////////////////////////////////////////////////
// DisplayDebug
//
function DisplayDebug(
	Canvas		aCanvas, 
	out float	aYL, 
	out float	aYPos )
{
	local string	T;

	Super.DisplayDebug( aCanvas, aYL, aYPos );

	aCanvas.SetDrawColor( 255, 255, 0 );

	aCanvas.DrawText( "SASAIController:" );
	aYPos +=aYL;
	aCanvas.SetPos( 32, aYPos );

	aCanvas.DrawText( "Focus: "$Focus$", FocalPoint: "$FocalPoint );
	aYPos += aYL;
	aCanvas.SetPos( 32, aYPos );

	aCanvas.DrawText( "CanSee: "$mbCanSee$", CanHear: "$mbCanHear$", CanFeelDamage: "$mbCanFeelDamage );
	aYPos += aYL;
	aCanvas.SetPos( 32, aYPos );

	aCanvas.DrawText( "Sight Flags: "$mSightFlags );
	aYPos += aYL;
	aCanvas.SetPos( 4, aYPos );

	T = "Aim point: ";
	switch ( mAimSpot )
	{
	case AIM_Chest:
		T = T$"Chest";
		break;

	case AIM_Head:
		T = T$"Head";
		break;

	case AIM_Centre:
		T = T$"Centre";
		break;
	}

	T = T$", Preferred aim spot: ";
	switch ( mPreferredAimSpot )
	{
	case AIM_Chest:
		T = T$"Chest";
		break;

	case AIM_Head:
		T = T$"Head";
		break;

	case AIM_Centre:
		T = T$"Centre";
		break;
	}
	aCanvas.DrawText( T );
	aYPos += aYL;
	aCanvas.SetPos( 4, aYPos );
}


///////////////////////////////////////////////////////////////////////////////
// PostBeginPlay
//
event PostBeginPlay()
{
	Super.PostBeginPlay();

	// Create script interface object.
	if ( mScriptInterface == None )
	{
		mScriptInterface = new(None) class'SASScriptInterface';
		mScriptInterface.SetInterfaceActor( self );
	}

	// Init timers.
	mTimerFiring	= AddMultiTimer();
	mTimerCheckDoor	= AddMultiTimer();
	mTimerAvoiding	= AddMultiTimer();
	mTimerReassess	= AddMultiTimer();
	mTimerSpeech	= AddMultiTimer();
}


///////////////////////////////////////////////////////////////////////////////
// Possess
//
function Possess(
	Pawn	aPawn )
{
	Super.Possess( aPawn );

	// Store ptr to SASPawn so no need to repeatedly cast from Pawn to SASPawn.
	mSASPawn = SASPawn( aPawn );
	if ( mSASPawn == None )
	{
		Warn( "SASAIController.Possess(): Possessed pawn is not an SASPawn." );
		return;
	}

	aPawn.SetPhysics( PHYS_Falling );

	mSASPawn.memRegister ();

	if ( mSASPawn.bStartInactive )
	{
		GotoState( 'Inactive' );
	}
	else
	{
		PawnActivated();
	}
}


///////////////////////////////////////////////////////////////////////////////
// PawnActivated
//
// Called when pawns are first activated - either at beginning of game or for
// bStartInactive pawns, when they are spawned into level.
event PawnActivated()
{
	// AI controlled pawns are always net relevant.
	mSASPawn.bAlwaysRelevant = true;

	// If match has not started go into waiting state.
	if ( Level.Game.bWaitingToStartMatch )
	{
		GotoState( 'WaitingToStart' );
	}
	else
	{
		EnterStartState();
	}
}


///////////////////////////////////////////////////////////////////////////////
// EnterStartState
//
// Called to go into default initial state at start of game or when spawned.
// Overriden in all child classes.
function EnterStartState();


///////////////////////////////////////////////////////////////////////////////
// PawnDied
//
function PawnDied(
	Pawn	aPawn )
{
	if ( Pawn != aPawn )
	{
		return;
	}

	// Turn off stunned/gassed flags in pawn otherwise it will try to play these 
	// anims when dead when killed with the flags set ( see SASPawn.AnimEnd() ).
	mSASPawn.mbGassed = false;
	mSASPawn.mbStunned = false;

	RelinquishCoverPoint();
	Super.PawnDied( aPawn );
	Destroy();
}


///////////////////////////////////////////////////////////////////////////////
// Destroyed
//
event Destroyed()
{
	RelinquishCoverPoint();

	Super.Destroyed();
}


////////////////////////////////////////////////////////////////////////////////
// IgnoreEnemy
//
function IgnoreEnemy(
	bool abNewIgnore )
{
	mbIgnoreEnemy = abNewIgnore;
}


///////////////////////////////////////////////////////////////////////////////
// RequestWeaponPose
//
// Returns the weapon pose the pawn should be using.
function EWpnHoldingPose RequestWeaponPose()
{
	// About to open a door? Port weapon.
	if ( mInteractDoor != None || ((Level.TimeSeconds - mApproachingClosedDoorTimer) < 3.0) )
	{
		return WPNPOSE_PortedHigh;
	}

	// If trying to fire always put weapon in aimed pose.
	if ( TryingToFire() )
	{
		return WPNPOSE_Aimed;
	}

	// If at a cover point use the cover-points specified pose.
	if ( (mCoverPoint != None) && (mCoverReachedTime != -1.0) )
	{
		return mCoverPoint.meWpnHoldingPose;
	}

	// Terrorists that can't see end of gun, waiting for a door or avoiding should port weapon high
	if (	!mbCanSeeEndOfGun ||
			(PendingMover != None) || 
			IsInState( 'SteppingAside' ) )
	{
		return WPNPOSE_PortedHigh;
	}
	
	return Super.RequestWeaponPose();
}


/*
///////////////////////////////////////////////////////////////////////////////
//
// checkRotation
//
// Determine if we need to go to a specific rotation state or if the automatic
// incremental rotation code can handle it
function checkRotation ()
{
	local vector dir;
	local Float yawOffset;
	local vector targetPoint;

	// We don't have major turn anims for kneeling, so don't bother 
	if (mSASPawn.meStance != STANCE_Standing)
	{
		return;
	} // if

	// Find correct focus point
	if (Focus != None)
	{
		targetPoint = Focus.Location;
	} // if
	else
	{
		targetPoint = FocalPoint;
	} // else

	// Find offset from current rotation to desired target point
	dir = targetPoint - Pawn.Location;
	yawOffset = GetYaw (dir) - Pawn.Rotation.Yaw;
	if (yawOffset < -MAX_ANGLE)
	{
		yawOffset += DEGREES_360;
	} // if
	else if (yawOffset > MAX_ANGLE)
	{
		yawOffset -= DEGREES_360;
	} // else

	// If large rotation, goto specific turn state
	if (Abs (yawOffset) > Degrees (20))
	{
		GotoState ('rotateToFace');
	} // if
} // checkRotation
*/

///////////////////////////////////////////////////////////////////////////////
// SetFocus
//
event SetFocus(
	Actor	aNewFocus )
{
	local SASPawn	pawnFocus;
	
	// Stop focus being set when trying to fire at a leaning player. In this case
	// the FireWeaponAtTarget will set the FocalPoint to the bone we are aiming at.
	if ( (aNewFocus == Target) && TryingToFire() )
	{
		pawnFocus = SASPawn( aNewFocus );
		if (	pawnFocus != None && 
				pawnFocus.Controller != None &&
				pawnFocus.Controller.mType == CONTROLLER_Player )
		{
			if ( Abs( pawnFocus.mCurrentLeanTilt ) > 910.0 )
			{
				Focus = None;
				return;
			}
		}
	}
	
	Focus = aNewFocus;

	//checkRotation ();
}


///////////////////////////////////////////////////////////////////////////////
// SetFocalPoint
//
event SetFocalPoint(
   Vector	aNewFP )
{
	Focus = None;
	FocalPoint = aNewFP;

	//checkRotation ();
}


///////////////////////////////////////////////////////////////////////////////
// SetFocalPointFromDir
//
// Helper function to set the focal point for our pawn to face given a 
// direction vector.
event SetFocalPointFromDir(
	Vector	aDir )
{
	if ( Pawn != None )
	{
		SetFocalPoint( Pawn.Location + (10000.0 * aDir) );

		//checkRotation ();
	}
}


///////////////////////////////////////////////////////////////////////////////
// FixCurrentFacing
//
event FixCurrentFacing()
{
	if ( Pawn != None )
	{
		SetFocalPointFromDir( Pawn.YawDirection() ); 
	}
}


///////////////////////////////////////////////////////////////////////////////
// DisableAllSenses
//
function DisableAllSenses(
	bool	abDisable )
{
	mbCanSee		= !abDisable;
	mbCanHear		= !abDisable;
	mbCanFeelDamage	= !abDisable;
}


///////////////////////////////////////////////////////////////////////////////
// SetAlert
//
function SetAlert(
	bool	abNewAlert )
{
	mbIsAlert = abNewAlert;
}


///////////////////////////////////////////////////////////////////////////////
// PawnSpawned
//
// Event received when a new pawn is spawned into the level. 
event PawnSpawned(
	SASPawn	aSpawned );


///////////////////////////////////////////////////////////////////////////////
// AssaultVolChange
//
// Event received when pawn changes assault volume if assault volume monitoring
// is enabled (by calling MonitorAssaultVolChange() ).
// AV change monitoring should only be enabled when needed (when enabled, the 
// pawn's current AV is tested every frame rather than only when requested).
event AssaultVolChange(
	SASAssaultVolume	aPrevAV );


///////////////////////////////////////////////////////////////////////////////
// NotifyPlayerAboutToBump
//
// Event received just before a player controlled pawn is about to bump into 
// us. Used to make NPCs move out of the way before they are bumped into.
event NotifyPlayerAboutToBump(
	SASPlayerController	aPlayer )
{
	local Vector	dest;

	if ( (aPlayer.Pawn != None) && ShouldStepAsideFor( aPlayer.Pawn, true ) )
	{
		if ( FindStepAsidePoint( aPlayer.Pawn, dest ) )
		{
			DoStepAside( aPlayer.Pawn, dest );
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// DoStaggerBackward
// 
function bool DoStaggerBackward(
	SASPawn	aHitPawn );


///////////////////////////////////////////////////////////////////////////////
// NotifyDoorOpening
//
function NotifyDoorOpening(
	SASDoorMover	aDoor,
	Pawn			aOpener );

///////////////////////////////////////////////////////////////////////////////
// AllowDoorEncroach
//
function bool AllowDoorEncroach(
	SASDoorMover	aDoor )
{
	return false;
}

///////////////////////////////////////////////////////////////////////////////
// NotifyBump
//
event bool NotifyBump(
	Actor	aBumped )
{
	local Pawn		bumpedPawn;
	local Vector	dest;
		
	if (	ShouldStepAsideFor( aBumped ) &&
			FindStepAsidePoint( aBumped, dest ) )
	{
		DoStepAside( aBumped, dest );
	}
	else 
	{
		if ( !mSASPawn.IsStationary() )
		{
			bumpedPawn = Pawn( aBumped );
			if ( (bumpedPawn != None) 
				/*&& !OtherIsStepingAside( bumpedPawn )*/
				&& FindAdjustAroundPoint( bumpedPawn, dest ) )
			{
				bAdjusting = true;
				AdjustLoc = dest;
			}
		}
	}

	return false;
}


///////////////////////////////////////////////////////////////////////////////
// SetStepAsidePawnTypes
//
function SetStepAsidePawnTypes(
	byte				aPawnTypesAlways,
	optional byte		aPawnTypesLow )
{
	mStepAsideForPawnTypesAlways		= aPawnTypesAlways;
	mStepAsideForPawnTypesLowPriority	= aPawnTypesLow;
}


///////////////////////////////////////////////////////////////////////////////
// CanStepAside
//
function bool CanStepAside()
{
	return true;
}

///////////////////////////////////////////////////////////////////////////////
// WillPawnStepAsideForMe
//
// Check to see whether another pawn will step aside for me if I bump them.
event bool WillPawnStepAsideForMe(
	SASPawn	aOther )
{
	local SASAIController	otherAI;

	// Not if other is human controlled.
	if ( aOther.Controller == None || aOther.Controller.mType == CONTROLLER_Player )
	{
		return false;
	}
	
	otherAI = SASAIController( aOther.Controller );
	
	if ( !CanStepAside() )
	{
		return false;
	}

	// Is other already stepping aside for me?
	if ( otherAI.IsInState( 'SteppingAside' ) && otherAI.mSteppingAsideFor == mSASPawn )
	{
		return true;
	}

	return otherAI.CanStepAsideForPawn( mSASPawn );
}


///////////////////////////////////////////////////////////////////////////////
// CanStepAsideForPawn
//
function bool CanStepAsideForPawn(
	SASPawn	aOtherPawn )
{
	local SASAIController	otherAI;

	if ( !CanStepAside() )
	{
		return false;
	}

	if ( aOtherPawn.Controller.mType != CONTROLLER_Player )
	{
		otherAI = SASAIController( aOtherPawn.Controller );
	}

	// Is other pawn AI controlled and currently stepping aside?
	if ( otherAI != None && otherAI.IsInState( 'SteppingAside' ) )
	{
		// Always step aside for other if they are avoiding a mover.
		if ( otherAI.mSteppingAsideFor.IsA( 'Mover' ) )
		{
			return true;
		}

		// Other is stepping aside for someone else, if we are not stepping aside 
		// then should do so.
		if ( !IsInState( 'SteppingAside' ) )
		{
			return true;
		}
	}

	// Check if we don't always step aside for other pawn type.
	if ( (mStepAsideForPawnTypesAlways & aOtherPawn.mPawnType) == 0x0 )
	{
		// Now check if we don't sometimes step aside for other type OR we are not 
		// in a low priority state which would let us step aside for them.
		if (	((mStepAsideForPawnTypesLowPriority & aOtherPawn.mPawnType) == 0x0) ||
				!IsInLowPriorityActionForAvoidance() )
		{
			return false;
		}
	}

	return true;
}


///////////////////////////////////////////////////////////////////////////////
// ShouldStepAsideForPawn
//
// Returns true if should step aside for another pawn when we bump into each other.
function bool ShouldStepAsideForPawn( 
	SASPawn	aOtherPawn )
{
	local float				dp;
	local SASAIController	otherAI;
	local Vector			myDestOfs,
							otherDestOfs;

	if ( !CanStepAside() )
	{
		return false;
	}

	if ( aOtherPawn.Controller == None )
	{
		return false;
	}

	if ( aOtherPawn.Controller.mType != CONTROLLER_Player )
	{
		otherAI = SASAIController( aOtherPawn.Controller );
	}

	// Is other pawn AI controlled and currently stepping aside?
	if ( otherAI != None && otherAI.IsInState( 'SteppingAside' ) )
	{
		// Don't step aside for other pawn if it's already doing so for me.
		if ( otherAI.mSteppingAsideFor == mSASPawn )
		{
			return false;
		}

		// Always step aside for other if they are avoiding a mover.
		if ( otherAI.mSteppingAsideFor.IsA( 'Mover' ) )
		{
			return true;
		}

		// Other is stepping aside for someone else, if we are not stepping aside 
		// then should do so.
		if ( !IsInState( 'SteppingAside' ) )
		{
			return true;
		}
	}

	if ( !CanStepAsideForPawn( aOtherPawn ) )
	{
		return false;
	}

	// Ok, we can potentially step aside for this pawn type - if they won't for my pawn tpye
	// then I must step aside.
	if ( otherAI != None )
	{
		if ( (otherAI.mStepAsideForPawnTypesAlways & mSASPawn.mPawnType) == 0x0 )
		{
			// Now check if we don't sometimes step aside for other type OR we are not 
			// in a low priority state which would let us step aside for them.
			if (	((otherAI.mStepAsideForPawnTypesLowPriority & mSASPawn.mPawnType) == 0x0) ||
					!otherAI.IsInLowPriorityActionForAvoidance() )
			{
				return true;
			}
		}
	}

	// Always give way to human players (unless currently doing so anyway and 
	// current step point is still ok.
	if ( aOtherPawn.IsHumanControlled() )
	{
		if (	IsInState( 'SteppingAside' ) && 
				(mSteppingAsideFor == aOtherPawn) && 
				!mSASPawn.IsStationary() && 
				(Level.TimeSeconds < (mStepAsideStartTime + 0.1)) && 
				StepAsidePointStillSuitable() )
		{
			return false;
		}

		return true;
	}

	// Already stepping aside?
	if ( IsInState( 'SteppingAside' ) )
	{
		// Is other the current actor stepping aside for?
		if ( (aOtherPawn != mSteppingAsideFor) )
		{
			// No, don't change ste aside actor for 0.5 secs.
			if ( Level.TimeSeconds < (mStepAsideStartTime + 0.5) )
			{
				return false;
			}
		}
		else
		{
			// Don't reevaluate current step aside point for same bumped actor to frequently.
			if ( Level.TimeSeconds < (mStepAsideStartTime + 0.2) )
			{
				return false;
			}

			// Only change current step aside point if it's no longer suitable.
			if ( !mSASPawn.IsStationary() && StepAsidePointStillSuitable() )
			{
				return false;
			}
		}
	}

	// Assess whether avoidance is necessary based on where each pawn is trying to move.
	if ( !mSASPawn.IsStationary() && !aOtherPawn.IsStationary() )
	{
		myDestOfs = Destination - mSASPawn.Location;
		otherDestOfs = aOtherPawn.Controller.Destination - aOtherPawn.Location;

		dp = myDestOfs Dot otherDestOfs;
		if ( dp > 0.0 )
		{
			return false;
		}

		myDestOfs = Normal( myDestOfs );
		otherDestOfs = Normal( otherDestOfs );
		dp = myDestOfs Dot otherDestOfs;
		if ( dp > -0.423 )
		{
			return false;
		}
	}

	// If other pawn is moving with approx the same velocity then don't bother avoiding.
	/*if ( !mSASPawn.IsStationary() && !aOtherPawn.IsStationary() )
	{
		dp = Pawn.Velocity Dot otherPawn.Velocity;
		if ( dp > 0.0 )
		{
			speedSq = Max( VSizeSq( Pawn.Velocity ), VSizeSq( aOtherPawn.Velocity )  );
			if ( Abs( dp - speedSq ) < Min( Square( 50.0 ), (speedSq * 0.01) ) )
			{
				return false;
			}
		}
	}*/

	// Avoid other if its trying to move faster than me.
	if ( !aOtherPawn.IsStationary() && (aOtherPawn.mePace > mSASPawn.mePace) )
	{
		return true;
	}

	// Give way depending on relative velocity.
	if (	(!aOtherPawn.IsStationary() && mSASPawn.IsStationary()) ||
			VSizeSq( aOtherPawn.Velocity ) >= VSizeSq( Pawn.Velocity ) )
	{
		return true;
	}

	return false;
}


///////////////////////////////////////////////////////////////////////////////
// ShouldStepAsideFor
//
// Returns true if we should do step-aside avoidance move to get out of the 
// way of other actor.
function bool ShouldStepAsideFor( 
	Actor			aOther,				// Actor to consider avoiding (either a pawn or a mover).
	optional bool	abConsiderStationaryActors )	// If true then consider stepping aside even if other not moving.
{
	local SASPawn	otherPawn;
	local Mover		otherMover;

	// Only a walking pawn can step aside.
	if ( mSASPawn.Physics != PHYS_Walking )
	{
		return false;
	} 

	if ( !CanStepAside() )
	{
		return false;
	}

	// Is other a door?
	otherMover = Mover( aOther );
	if (	(otherMover != None) && 
			otherMover.bAvoidMe && 
			!otherMover.bClosed &&
			!otherMover.IsFullyOpen() &&
			!mbIgnoreDoorBump )
	{
		// Is door the actor we are currently stepping aside for?
		if ( aOther == mSteppingAsideFor )
		{
			// Only retry avoiding the same door every 0.5 seconds.
			if ( Level.TimeSeconds < (mStepAsideStartTime + 0.5) )
			{
				return false;
			}
		}

		// Avoid it.
		return true;
	}

	// It's not a door, is it a pawn?
	otherPawn = SASPawn( aOther );
	if ( (otherPawn == None) || (otherPawn.Controller == None) || mbIgnorePawnBump)
	{
		// It's not a door or a pawn - they are the only things we avoid.
		return false;
	}

	// Don't step aside for stationary pawns unless told to do so.
	if ( !abConsiderStationaryActors && otherPawn.IsStationary() )
	{
		return false;
	}

	return ShouldStepAsideForPawn( otherPawn );
}


///////////////////////////////////////////////////////////////////////////////
// IsInLowPriorityActionForAvoidance
//
// Returns true if the current AI action/objective is low priority in terms 
// of stepping aside for other pawns.
// By default returns false - inherited controller classes override this 
// function.
function bool IsInLowPriorityActionForAvoidance()
{
	return false;
}

/*
///////////////////////////////////////////////////////////////////////////////
// StepAsideForType
//
// Returns true if should step aside for pawn with type 'aeOtherType'.
function bool StepAsideForType(
	SASPawn		aOther )
{
	local int otherType;

	otherType = aOther.mPawnType;

	switch ( mSASPawn.mPawnType )
	{
		// Soldiers step aside for other soldiers only.
	case PAWN_Soldier:
		return otherType == PAWN_Soldier;

		// Terrorists step aside for all types if surrendered, else only other terrorists and AI soldiers.
	case PAWN_Terrorist:
		if ( SASTerrorist( mSASPawn ).mbSurrendered && SASTerrorist( mSASPawn ).mbPlayedSurrendering )
		{
			return true;
		}
		if ( aOther.Controller != None && aOther.Controller.mType == CONTROLLER_AISoldier )
		{
			return true;
		}
		return otherType == PAWN_Terrorist;

		// Hostages step aside for everyone.
	case PAWN_Hostage:
	case PAWN_Scripted:
	default:
		return true;
	}

}
*/

///////////////////////////////////////////////////////////////////////////////
// MultiTimer
//
event MultiTimer(
	int	aTimerIdx )
{
	switch ( aTimerIdx )
	{
	case mTimerFiring:
		UpdateRepeatFiring( mMultiTimers[mTimerFiring].Interval );
		break;

	default:
		Super.MultiTimer( aTimerIdx );
	}
}


///////////////////////////////////////////////////////////////////////////////
// SeeDeadBody
//
// Event called from native code when sighting a dead body.
// Will only occur if SIGHT_DeadBodies is set in our sight flags.
// Event only happens for the first instance that we see each dead body.
event SeeDeadBody(
	SASPawn	aDeadPawn );


///////////////////////////////////////////////////////////////////////////////
// SeeGrenade
//
// Event called when we see a grenade. Only gets called if the grenade is not
// in our detected grenades list.
event SeeGrenade(
	SASGrenadeProjectile	aGrenade )
{
	AddDetectedGrenade( aGrenade );
}


///////////////////////////////////////////////////////////////////////////////
// NotifyHitByGrenade
//
function NotifyHitByGrenade(
	SASGrenadeProjectile	aGrenade )
{
	if ( mbCanSee )
	{
		SeeGrenade( aGrenade );
	}
}


///////////////////////////////////////////////////////////////////////////////
// GrenadeExploded
//
// Event called when a grenade in our detected list has finished exploding.
// Grenade gets removed from detected list before this event is received.
event GrenadeExploded(
	SASGrenadeProjectile	aGrenade );


///////////////////////////////////////////////////////////////////////////////
// AlertFriendliesOfGrenade
// 
function AlertFriendliesOfGrenade(
	SASGrenadeProjectile	aGrenade )
{
	local SASPawn	other;

	// First check to see if there are any allies in range of the grenade.
	if ( FriendliesUnawareOfNearbyGrenade( aGrenade ) )
	{
		// Alert all in audible range.
		foreach mSASPawn.GetGame().RadiusSASPawns(
			class'SASPawn', 
			other,
			Pawn.Location,
			ALERTING_RANGE )
		{
			if ( (other.Controller != None) && (SASAIController( other.Controller ) != None) )
			{
				SASAIController( other.Controller ).AlertedToGrenade( aGrenade, mSASPawn );
			}
		}	
	}
}


///////////////////////////////////////////////////////////////////////////////
// AlertedToGrenade
//
// Called by SAS AI controllers when they detect a grenade and are broadcasting
// it to others in their proximity.
function AlertedToGrenade(
	SASGrenadeProjectile	aGrenade,
	SASPawn					aAlerter )
{
	// Do nothing if already aware of this grenade
	if ( AwareOfGrenade( aGrenade ) )
	{
		return;
	}

	AddDetectedGrenade( aGrenade );
}


///////////////////////////////////////////////////////////////////////////////
// NotifyTakeHit
//
// Identical to Controller.NotifyTakeHit except does nothing if sensing damage 
// is turned off.
function NotifyTakeHit(
	Pawn				aInstigatedBy, 
	vector				aHitLocation, 
	int					aDamage, 
	class<DamageType>	aDamageType)
{
	if ( !mbCanFeelDamage )
	{
		return;
	}

	if ( (aInstigatedBy != None) && (aInstigatedBy != Pawn) )
	{
		DamageAttitudeTo( aInstigatedBy, aDamage );
	}
} 


///////////////////////////////////////////////////////////////////////////////
// NotifyOtherChangedSide
//
// Called when a pawn is made to change sides via scripting system.
function NotifyOtherChangedSide(
	SASPawn		aOther );


///////////////////////////////////////////////////////////////////////////////
// SwitchToBestWeapon
//
function SwitchToBestWeapon()
{
	local SASWeapon	wpn;
	
	wpn = mSASPawn.GetWeaponOfCategory( WPNCAT_Primary );
	if ( wpn != None )
	{
		mSASPawn.SelectWeapon( WPNCAT_Primary );
		return;
	}

	wpn = mSASPawn.GetWeaponOfCategory( WPNCAT_Secondary );
	if ( wpn != None )
	{
		mSASPawn.SelectWeapon( WPNCAT_Secondary );
	}
}


///////////////////////////////////////////////////////////////////////////////
// IsHoldingGun
//
// Returns true if pawn has a weapon and its not a grenade.
function bool IsHoldingGun()
{
	if ( Pawn == None || Pawn.Weapon == None )
	{
		return false;
	}

	switch ( SASWeapon ( Pawn.Weapon ).mCategory )
	{
	case WPNCAT_Primary:
	case WPNCAT_Secondary:
		return true;
	}

	return false;
}


///////////////////////////////////////////////////////////////////////////////
// PendingWeaponIsGun
//
// Returns true if pawn has a new weapon pending and its not a grenade.
function bool PendingWeaponIsGun()
{
	if ( Pawn == None || Pawn.PendingWeapon == None )
	{
		return false;
	}

	switch ( SASWeapon ( Pawn.PendingWeapon ).mCategory )
	{
	case WPNCAT_Primary:
	case WPNCAT_Secondary:
		return true;
	}

	return false;
}


///////////////////////////////////////////////////////////////////////////////
// SetWeaponFireMode
//
// Sets firing mode on pawn's current weapon.
// Value of aWeaponFireModeName is name equivalent of the SASWeapon FIREMODE_xxx 
// const values.
function SetWeaponFireMode(
	name	aWeaponFireModeName )
{
	local SASWeapon		myWeap;

	if ( Pawn.Weapon != None )
	{
		myWeap = SASWeapon( Pawn.Weapon );
		if ( myWeap != None )
		{
			myWeap.SetFireMode( aWeaponFireModeName );
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// TargetLost
//
// Function called when trying to fire weapon at target using repeated fire
// functionality but target is None or has zero health. Gives controller the
// opportunity to select new target or choose another action. If Target is still
// None after returning from this function then repeat firing is turned off.
event TargetLost()
{
	Target = None;
	mSASPawn.mInterestItem = None;
}


///////////////////////////////////////////////////////////////////////////////
// NotifyWeaponFired
//
// Event received from weapon each time it fires.
function NotifyWeaponFired()
{
	// If firing a specified number of rounds then check for completion.
	if ( mNumRoundsToFire > 0 )
	{
		mNumRoundsToFire--;

		if ( mNumRoundsToFire == 0 )
		{
			StopRepeatFiring();
		}
	}

	// Flag that burst firing has started if in that mode.
	if ( mbBurstFiring && !mbStartedBurst )
	{
		mbStartedBurst = true;
	}
}


///////////////////////////////////////////////////////////////////////////////
// NotifyBurstFired
//
// Function to notify AI that it's burst firing duration has ended. 
// If true returns then burst firing will continue.
event bool NotifyBurstFired()
{
	return true;
}


///////////////////////////////////////////////////////////////////////////////
// NotifyLineOfFireAcquired
// 
// Event received on first getting a line of fire to current enemy.
// Event received each time the LoF is acquired after being lost.
event NotifyLineOfFireAcquired();


///////////////////////////////////////////////////////////////////////////////
// NotifyLineOfFireBlocked
// 
// Event received when line of fireto current target has been blocked for
// longer than MAX_BLOCKED_LOF_TIME.
event NotifyLineOfFireBlocked();


///////////////////////////////////////////////////////////////////////////////
// CheckFriendlyFireCone
//
// Checks intersection of firing cone against friendly pawns. Returns false
// if any friendlies lie within the cone. 

/*function bool CheckFriendlyFireCone(
	Vector	aLineOfFire )
{
	local float		fireDistSq;
	local Vector	fireDir;
	local SASPawn	other;	

	// GP: Skipping test for now as it does not yet take into account if friendlies
	// are inside ff cone but are shielded from fire (other side of walls).
	return true;

	fireDistSq = VSizeSq( aLineOfFire );
	fireDir = Normal( aLineOfFire );

	foreach SASGameInfo( Level.Game ).AllSASPawns( class'SASPawn', other )
	{
		if ( (other != mSASPawn) && mSASPawn.IsFriendly( other ) )
		{
			if ( IsPawnInFriendlyFireCone( other, fireDir, fireDistSq ) )
			{
				return false;
			}
		}
	}

	// No friendlies in fire cone.
	return true;
}*/


///////////////////////////////////////////////////////////////////////////////
// CheckGunSelected
//
function CheckGunSelected()
{
	local int				primaryRoundsInMag,
							secondaryRoundsInMag;
	local SASWeapon			primary,
							secondary;
	local EWeaponCategory	curWpnCat;

	curWpnCat = WPNCAT_None;

	if ( mSASPawn.PendingWeapon != None )
	{
		curWpnCat = SASWeapon( mSASPawn.PendingWeapon ).mCategory;
	}
	else if ( mSASPawn.Weapon != None )
	{
		curWpnCat = SASWeapon( mSASPawn.Weapon ).mCategory;
	}

	if ( curWpnCat != WPNCAT_Primary && curWpnCat != WPNCAT_Secondary )
	{
		primary = mSASPawn.GetWeaponOfCategory( WPNCAT_Primary );
		if (	(primary != None) && 
				primary.HasAmmo() )
		{
			primaryRoundsInMag = primary.mNumInMag;
		}
		else
		{
			primary = None;
		}

		secondary = mSASPawn.GetWeaponOfCategory( WPNCAT_Secondary );
		if (	(secondary != None) && 
				secondary.HasAmmo() )
		{
			secondaryRoundsInMag = secondary.mNumInMag;
		}
		else
		{
			secondary = None;
		}

		if ( primary != None )
		{
			if ( (secondary == None) || (primaryRoundsInMag >= secondaryRoundsInMag) )
			{
				mSASPawn.SelectWeapon( WPNCAT_Primary );
			}
			else
			{
				mSASPawn.SelectWeapon( WPNCAT_Secondary );
			}
		}
		else if ( secondary != None )
		{
			mSASPawn.SelectWeapon( WPNCAT_Secondary );
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// NotifyClipEmpty
//
// Called at the point the current weapon empties its clip. Instigates correct
// action (pull secondary weapon, reload etc).
function NotifyClipEmpty()
{
	local SASWeapon	otherWpn;

	// GPTODO: If unthreatened, want to reload primary even when secondary is ready to use.
	// Also want to do this when current weapon clip not empty - squad ad terrorists will need
	// to assess if unthreatened and sort their weapons out.
	// Also consider reloading both primary and secondary weapons when completely safe.

	// Try to select best other weapon being carried if it has ammo.

	if ( SASWeapon ( Pawn.Weapon ).mCategory != WPNCAT_Primary )
	{
		// Try to select primary weapon if we have one and it has ammo.
		otherWpn = mSASPawn.GetWeaponOfCategory( WPNCAT_Primary );
		if ( otherWpn != None && otherWpn.HasAmmo() )
		{
			// Always select primary weapon even if it needs reloading. 
			mSASPawn.SelectWeapon( WPNCAT_Primary );
			return;
		}
		else
		{
			otherWpn = None;
		}
	}
	else if ( SASWeapon ( Pawn.Weapon ).mCategory != WPNCAT_Secondary )
	{
		// Try to select secondary weapon if it has ammo and doesn't need to be reloaded.
		otherWpn = mSASPawn.GetWeaponOfCategory( WPNCAT_Secondary );
		if ( otherWpn != None && otherWpn.HasAmmo() )
		{
			// If secondary has ammo ready in clip then select it.
			if ( !otherWpn.NeedsToReload() )
			{
				mSASPawn.SelectWeapon( WPNCAT_Secondary );
				return;
			}
		}
		else
		{
			otherWpn = None;
		}
	}

	if ( Pawn.Weapon.HasAmmo() || otherWpn != None ) // If otherWpn not None at this point then it has ammo.
	{
		// Dont have another weapon with ammo ready in clip, but do a have at least one weapon 
		// with ammo available.
		// Selecting the correct weapon to reload happens in the reloading state.
		DoReloading();
		return;
	}

	// Don't have weapon with ammo!
	return;
}


///////////////////////////////////////////////////////////////////////////////
// DoReloading
//
// Base behaviour when need to reload weapon - just do it.
function DoReloading (optional bool forceReload)
{
	if ( mSASPawn.Weapon != None )
	{
		// Try to swap to primary weapon if available.
		if ( (SASWeapon(mSASPawn.Weapon).mCategory != WPNCAT_Primary)
			&& (mSASPawn.GetWeaponOfCategory( WPNCAT_Primary ) != None) )
		{
			mSASPawn.SelectWeapon( WPNCAT_Primary );
		}
		else
		{
			mSASPawn.Weapon.Reload();
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// CheckReloading
//
// Returns true if weapon needs reloading or is currently reloading.
// If the weapon needs to reload and is not currently then 
event bool CheckReloading()
{
	if ( (Pawn.Weapon == None) || !Pawn.Weapon.NeedsToReload() )
	{
		return false;
	}

	if ( !SASWeapon( Pawn.Weapon ).mbIsReloading )
	{
		DoReloading();
	}

	return true;
}


///////////////////////////////////////////////////////////////////////////////
// NeedToTurnToFace
//
// Checks whether angle from our possessed pawn to aTargetLoc is within
// firing constraints.
function bool NeedToTurnToFace(
	vector	aTargetLoc )
{
	local vector lookDir, aimDir;

	lookDir = Vector( Pawn.GetUpperBodyRotation() );
	lookDir.Z = 0;
	lookDir = Normal( LookDir );

	aimDir = aTargetLoc - Pawn.Location;
	aimDir.Z = 0;
	aimDir = Normal( aimDir );

	return ((lookDir Dot aimDir) < 0.93);
}


///////////////////////////////////////////////////////////////////////////////
// ChooseDirectionNotFacingWall
// 
function Vector ChooseDirectionNotFacingWall(
	Vector	aInitialDir )
{
	local int		i;
	local vector	testDir;
	local vector	bestDir;
	local vector	eyeLoc;
	local vector	endTrace;
	local vector	hitLoc, hitNorm;
	local float		distSq;
	local float		bestDistSq;
	local float		tmp;
	local Actor		hitActor;

	eyeLoc = Pawn.Location + Pawn.EyePosition();
	
	testDir = aInitialDir;
	bestDir = aInitialDir;
	bestDistSq = 0.0;

	// Test forward, right, behind, and left directions in turn.
	// If any facing direction is not to close to a wall then choose this 
	// direction as the best to face. Otherwise choose the direction 
	for ( i = 0; i < 4; ++i)
	{
		endTrace = eyeLoc + (testDir * MAX_DIST_FACING_WALL);
		hitActor = Trace( 
			hitLoc, 
			hitNorm, 
			endTrace, 
			eyeLoc, 
			false,,,	// Don't check non-world geometry
			true );		// Ignore transparent walls

		if ( hitActor == None )
		{
			bestDir = testDir;
			break;
		}
		else
		{
			distSq = VSizeSq( hitLoc - eyeLoc );
			if ( distSq > bestDistSq )
			{
				bestDir = testDir;
				bestDistSq = distSq;
			}
		}

		// Rotate test direction 90 deg clockwise.
		tmp = testDir.X;
		testDir.X = -testDir.Y;
		testDir.Y = tmp;
	}

	return bestDir;
}


///////////////////////////////////////////////////////////////////////////////
// AcquireCoverPoint
// 
event bool AcquireCoverPoint(
	SASCoverPoint	aCP )
{
	if ( (aCP != None) && (aCP == mCoverPoint) )
	{
		// Already have it.
		return true;
	}

	// Give up current CP
	RelinquishCoverPoint();

	if ( aCP != None )
	{
		if ( aCP.Acquire( Pawn ) )
		{
			mCoverPoint = aCP;
			mbAttackedFromCover = false;
			return true;
		}
	}

	return false;
}


///////////////////////////////////////////////////////////////////////////////
// RelinquishCoverPoint
// 
event RelinquishCoverPoint()
{
	if ( mCoverPoint != None )
	{
		mPrevCoverPoint = mCoverPoint;
		mCoverPoint.Relinquish( Pawn );
		mCoverPoint = None;
	}

	// Reset the cover reached time.
	mCoverReachedTime = -1.0;
}


///////////////////////////////////////////////////////////////////////////////
// ReachedCover
// 
function ReachedCover()
{
	if ( mCoverReachedTime == -1.0 )
	{
		mCoverReachedTime = Level.TimeSeconds;
	}
}


///////////////////////////////////////////////////////////////////////////////
// SeekClosestCoverAroundOther
// 
// Searches for closest CP to aSearchAround within range aSearchAroundRange and
// acquires the point. 
// If abOnlyInSameVolume is true then only seeks points within the same assault
// volume. 
// Returns true on success.
function bool SeekClosestCoverAroundOther(
	SASPawn			aSearchAround,
	float			aSearchAroundRange,
	optional float	aRangeFromSelf )
{
	local int				i, j,
							numSearchAVs;
	local SASAssaultVolume	searchAVs[2];
	local SASCoverPoint		CP,	
							closestCP;
	local float				closestDistSq,
							distSqSelfToCP,
							distSqOtherToCP;

	if ( mSASPawn == None )
	{
		return false;
	}

	if ( aRangeFromSelf == 0.0 )
	{
		closestDistSq = Square( 99999.9 );
	}
	else
	{
		closestDistSq = Square( aRangeFromSelf );
	}

	if ( mSASPawn.GetAssaultVolume() != None )
	{
		searchAVs[0] = mSASPawn.GetAssaultVolume();
		numSearchAVs++;
	}
	if (	aSearchAround.GetAssaultVolume() != None && 
			aSearchAround.GetAssaultVolume() != mSASPawn.GetAssaultVolume() )
	{
		searchAVs[numSearchAVs] = aSearchAround.GetAssaultVolume();
		numSearchAVs++;
	}
	for ( i = 0; i < numSearchAVs; ++i )
	{
		for ( j = 0; j < searchAVs[i].mCoverPoints.Length; ++j )
		{
			CP = searchAVs[i].mCoverPoints[j];
			if ( CP != None )
			{
				// Are hostages disqualified here?
				if ( (mType == CONTROLLER_AIHostage) && !CP.mbAllowHostages )
				{
					continue;
				}

				// Are terrorists disqualified here?
				if ( (mType == CONTROLLER_AITerrorist) && !CP.mbAllowTerrorists )
				{
					continue;
				}

				// Only consider unoccupied CPs or CP already occupied by this pawn.
				if ( CP.mOwner == None || CP.mOwner == mSASPawn )
				{
					// Check distances from 'search around actor' and self.
					distSqSelfToCP = VSizeSq( CP.Location - mSASPawn.Location );
					if ( distSqSelfToCP < closestDistSq )
					{
						distSqOtherToCP = VSizeSq( CP.Location - aSearchAround.Location );
						if ( distSqOtherToCP < Square( aSearchAroundRange ) )
						{
							closestCP = CP;
							closestDistSq = distSqSelfToCP;
						}
					}
				}
			}
		}
	}
	

	if ( closestCP != None && AcquireCoverPoint( closestCP ) )
	{
		return true;
	}

	return false;
}


///////////////////////////////////////////////////////////////////////////////
// ReactToGrenade
//
event ReactToGrenade(
	SASGrenadeProjectile	aGrenade )
{
	if ( mbIgnoreGrenades || IsIncapacitated() )
	{
		return;
	}

	GotoState( 'RetreatFromGrenades' );
}


///////////////////////////////////////////////////////////////////////////////
// GotoAtGrenadeCoverState
//
// Function to instigate AI controller type specific specific state on reaching a
// grenade retreat point.
function GotoAtGrenadeCoverState();


///////////////////////////////////////////////////////////////////////////////
// NotifyCaptured
//
function NotifyCaptured();


///////////////////////////////////////////////////////////////////////////////
// NotifyStartedCuffing
//
function NotifyStartedCuffing();


///////////////////////////////////////////////////////////////////////////////
// NotifyStoppedCuffing
//
function NotifyStoppedCuffing();


///////////////////////////////////////////////////////////////////////////////
// DoSurrender
//
function DoSurrender();


///////////////////////////////////////////////////////////////////////////////
// DoSprayFire
//
function DoSprayFire();


///////////////////////////////////////////////////////////////////////////////
// DoThrowGrenade
//
function bool DoThrowGrenade(
	EGrenadeCategory	aGrenadeCategory,	// Type of grenade to throw (see GRENADECAT_xxx types in SASGrenadeWeapon.uc)
	SASGrenadePoint		aGP,				// Grenade point to throw at
	name				aNextState,			// State to go to after throwing.
	name				aNextLabel )		// State label to go to after throwing.
{
	mbThrownGrenade		= false;
	mGrenadePoint		= None;
	mThrowGrenadeType	= GRENADECAT_None;

	if ( aGP == None )
	{
		return false;
	}

	// Pawn must have required grenade type in inventory.
	if ( mSASPawn.GetWeaponOfCategory( WPNCAT_Grenade, aGrenadeCategory ) == None )
	{
		return false;
	}

	mNextState = aNextState;
	mNextLabel = aNextLabel;

	mGrenadePoint		= aGP;
	mThrowGrenadeType	= aGrenadeCategory;
	GotoState( 'ThrowingGrenade' );

	return true;
}


///////////////////////////////////////////////////////////////////////////////
// CanBeScripted
//
function bool CanBeScripted()
{
	return !IsIncapacitated();
}


///////////////////////////////////////////////////////////////////////////////
// SetNewScript
//
// Sets up controller ready to run specified script. Returns false if 
// scripting is currently disabled.
function bool SetNewScript(
	SASScriptedSequence	aNewScript )
{
	if ( !CanBeScripted() )
	{
		return false;
	}
	return mScriptInterface.SetNewScript( aNewScript );
}


///////////////////////////////////////////////////////////////////////////////
// StartScripting
//
function StartScripting()
{
	if ( !CanBeScripted() )
	{
		mScriptInterface.ClearScript();
		mScriptInterface.mScript = None;
		return;
	}

	HandleChangeToScripting();	
	GotoState( 'Scripting' );
}


///////////////////////////////////////////////////////////////////////////////
// ResumeScripting
//
function bool ResumeScripting()
{
	if ( mScriptInterface.mScript == None )
	{
		return false;
	}

	if ( !CanBeScripted() )
	{
		mScriptInterface.ClearScript();
		mScriptInterface.mScript = None;
		return false;
	}
	
	GotoState( 'Scripting', 'ResumeScripting' );
	return true;
}


///////////////////////////////////////////////////////////////////////////////
// HandleChangeToScripting
//
// Called just before switching to scripting state to allow controller to 
// do anything it need to ready itself for scripting (e.g. Store state to return
// to after script has completed).
function HandleChangeToScripting();


///////////////////////////////////////////////////////////////////////////////
// ResumeObjective
//
function ResumeObjective();


///////////////////////////////////////////////////////////////////////////////
// LeaveScripting
//
// Called when leaving scriting state to allow controller to switch to correct
// follow-on action.
function LeaveScripting()
{
	mScriptInterface.ClearScript();
	mScriptInterface.mScript = None;
	
	DisableAllSenses( false );

	GotoState( '' );
}


///////////////////////////////////////////////////////////////////////////////
// InitHeadlessChickenMove
// 
// Init 'headless chicken' random wander movement destination.
function InitHeadlessChickenMove()
{
	local int		randAng;
	local Rotator	rotn;
	
	mHeadlessChickenNumBumps = 0;
	mHeadlessChickenDir = 1;
	if ( FRand() < 0.5 )
	{
		mHeadlessChickenDir = -mHeadlessChickenDir;
	}
	mHeadlessChickenDirTimer = RandRange( 0.3, 0.8 );

	rotn.Yaw = mSASPawn.Rotation.Yaw;
	rotn.Pitch	= 0;
	rotn.Roll	= 0;

	// Choose random angle to start moving in.
	// If currently moving then reduce in
	// direction as current rotation, else take the pawn rotation.g 
	if ( (mSASPawn.Acceleration.X != 0.0) || (mSASPawn.Acceleration.Y != 0.0) )
	{
		// Direction change smaller if already moving.
		randAng = 3641 + Rand( 4551 );		// 20->45deg
	} 
	else
	{
		randAng = Rand( 65535 );	// 0->360deg
	}

	if ( FRand() < 0.5 )
	{
		randAng = -randAng;
	}

	// Rotate curent facing/moving direction by random angle and choose new direction
	// along that vector.
	rotn.Yaw += randAng;
	Destination = Pawn.Location + (Vector( rotn ) * 10000.0);
}


///////////////////////////////////////////////////////////////////////////////
// ChooseHeadlessChickenDest
// 
// Update 'headless chicken' random wander movement destination.
function UpdateHeadlessChickenDest(
	bool	abJustBumped,
	float	aTimeSinceLastUpdate )
{
	local int		randAng;
	local Rotator	rotn;

	if ( abJustBumped )
	{
		mHeadlessChickenNumBumps++;

		// Only allow between 1 and 2 bumps before stopping moving
		if ( mHeadlessChickenNumBumps > Rand(2) )
		{
			mSASPawn.mbHeadlessChicken = false;
			return;
		}
	}

	// Update rotation direction - but not if updating dest immediately after a bump.
	if ( !abJustBumped )
	{
		mHeadlessChickenDirTimer -= aTimeSinceLastUpdate;
		if ( mHeadlessChickenDirTimer < 0.0 )
		{
			mHeadlessChickenDir = -mHeadlessChickenDir;
			mHeadlessChickenDirTimer = RandRange( 0.5, 1.5 );
		}
	}

	// If moving (or trying to move - e.g. running into wall) then take moving
	// direction as current rotation, else take the pawn rotation.
	if ( (mSASPawn.Acceleration.X != 0.0) || (mSASPawn.Acceleration.Y != 0.0) )
	{
		rotn = Rotator( mSASPawn.Acceleration );
	} 
	else
	{
		rotn.Yaw = mSASPawn.Rotation.Yaw;
	}
	rotn.Pitch	= 0;
	rotn.Roll	= 0;

	// If just bumped into something, change direction by at least 100deg
	if ( abJustBumped )
	{
		randAng = 18204 + Rand( 6372 );	// 100->135deg
		if ( FRand() < 0.5 )
		{
			randAng = -randAng;
		}
	}
	else
	{
		// No bump, only make slight adjustment to 'wandering' direction.
		randAng = (910 + Rand(910)) * mHeadlessChickenDir;
	}

	// Rotate curent facing/moving direction by random angle and choose new direction
	// along that vector.
	rotn.Yaw += randAng;
	Destination = Pawn.Location + (Vector( rotn ) * 10000.0);
}


///////////////////////////////////////////////////////////////////////////////
// DoStunned
//
function DoStunned(
	float	aStunTime );


///////////////////////////////////////////////////////////////////////////////
// DoTransition
//
// Controls the playing of transition animations (kneel-to-stand, stand-to-crouch etc)
// Stores the previous state and animation required once the transition animation has
// completed so that the Pawn can return to its previous state with the minimum of fuss.
function DoTransition(
	name				aTransitionAnim,		// Anim to use as transition
	name				aReturnState,			// State to go to once transition is complete
	optional name		aReturnLabel,			// Label to go to in the return state
	optional ESASStance	aeReturnStance,			// Anim to play once transition is complete
	optional float		aAnimRate,				// Rate of playing animation
	optional bool		abUseRootMotion )		// Root motion physics?
{
	// Even if we're already in a transition state, update these so we come out 
	// into the more recent state and anim.
	mTransitionReturnState			= aReturnState;
	mTransitionReturnLabel			= aReturnLabel;
	mTransitionReturnStance			= aeReturnStance;
	mbTransitionReturnIgnoreEnemy	= mbIgnoreEnemy;

	// Catch trying to transition with a return state of 'Transition' which will 
	// cause an infinite loop of the state.
	if ( aReturnState == 'Transition' )
	{
		return;
	}

	if ( aAnimRate <= 0.0 )
	{
		aAnimRate = 1.0;
	}

	mTransitionAnim			= aTransitionAnim;
	mTransitionAnimRate		= aAnimRate;
	mbTransitionRootMotion	= abUseRootMotion;
	
	GotoState ( 'Transition' );
} 


///////////////////////////////////////////////////////////////////////////////
// DoStanceTransition
//
// Play a stance transition between pawn current stance and aNewStance using 
// the Transition state. If transition anim does not exist then stance changes
// immediately.
function DoStanceTransition(
	ESASStance			aNewStance,
	name				aReturnState,
	optional name		aReturnLabel,
	optional float		aRate )
{
	local name	anim;

	if ( aNewStance == mSASPawn.meStance )
	{
		// No transition required.
		return;
	}

	anim = mSASPawn.GetStanceTransitionAnimName( mSASPawn.meStance, aNewStance );
	if ( anim != 'None' )
	{
		if ( aRate == 0.0 )
		{
			aRate = RandRange( 0.9, 1.1 );
		}

		DoTransition(
			anim,
			aReturnState,
			aReturnLabel,
			aNewStance,
			aRate );
	}
	else
	{
		// No anim available, just perform the stance change without anim.
		mSASPawn.ChangeStanceImmediate( aNewStance );
		mSASPawn.ChangeAnimation();
	}
}


///////////////////////////////////////////////////////////////////////////////
// DoGassed
//
// Reaction to being in CS gas cloud
function DoGassed (
	float duration)
{
	if ( duration > 0.0 )
	{
		StopMoving ();
		StopRepeatFiring ();
		SetTimer( duration, false );
		mSASPawn.mbGassed = true;
		GotoState ('Gassed');
	} // if
} // DoGassed


///////////////////////////////////////////////////////////////////////////////
// IsIncapacitated
//
function bool IsIncapacitated()
{
	if ( mSASPawn == None )
	{
		return false;
	}

	return mSASPawn.mbIsIncapacitated;
} 


///////////////////////////////////////////////////////////////////////////////
// DoIncapacitated
//
// Reaction to being seriously hurt - to the extent that we can't do anything
function DoIncapacitated (optional Pawn causedBy)
{
	local Controller	C;
	local SASPRI		pri;

	if ( IsIncapacitated() )
	{
		return;
	}

	// Tell the game's controlling entities what's happened
	mSASPawn.GetGRI ().PawnIncapacitated (mSASPawn, SASPawn (causedBy));

	// Record incapacitated by stats to player. 
	if (	(causedBy != None) &&
			(causedBy.Controller != None) && 
			(causedBy.Controller.mType == CONTROLLER_Player) )
	{
		pri = SASPRI( causedBy.Controller.PlayerReplicationInfo );
		if ( pri != None )
		{
			if ( mSASPawn.mPawnType == PAWN_Terrorist )
			{
				pri.mPlayerEnemiesIncapacitated++;
			}
		}
	}		

	// Tell AI controllers in level that we are incapacitated.
	for ( C = Level.ControllerList; C != None; C = C.nextController )
	{
		C.NotifyIncapacitated( mSASPawn );
	}

	// Play death speech (always play if already in combat incapable state).
	mSASPawn.PlaySpeech( SPEECH_GenDeath, !mSASPawn.mbIsCombatCapable );

	mSASPawn.mbIsIncapacitated = true;	// replicated to clients via pawn ...
	mSASPawn.mIncapacitationTime = Level.TimeSeconds;
	mSASPawn.SetCombatCapable( false );

	StopMoving ();
	StopRepeatFiring ();
	mSASPawn.StopAiming();

	GotoState( 'Incapacitated' );
}


///////////////////////////////////////////////////////////////////////////////
// DoClimbing
//
function bool DoClimbing(
	SASClimbPoint	aStartPoint,
	name			aNextState,
	name			aNextLabel )
{
	if ( (aStartPoint == None) 
		|| (aStartPoint.mLinkedPoint == None)
		|| (aStartPoint.meClimbType == CLIMB_None) )
	{
		return false;
	}

	mNextState	= aNextState;
	mNextLabel	= aNextLabel;

	mClimbStart	= aStartPoint;
	GotoState( 'Climbing' );
	return true;
}


///////////////////////////////////////////////////////////////////////////////
// StartClimbing
//
function bool StartClimbing(
	SASClimbPoint	aStartPoint )
{
	return DoClimbing( aStartPoint, GetStateName(), 'Begin' );
}


///////////////////////////////////////////////////////////////////////////////
// DoStepAside
//
function DoStepAside(
	Actor	aStepAsideFor,
	Vector	aStepAsideDest )
{
	mSteppingAsideFor	= aStepAsideFor;
	mStepAsidePoint		= aStepAsideDest;

	GotoState( 'SteppingAside', 'Begin' );
}


///////////////////////////////////////////////////////////////////////////////
// DoBlockedByDoor
//
function DoBlockedByDoor(
	SASDoorMover	aBlockingDoor )
{
	mInteractDoor = aBlockingDoor;
	GotoState( 'BlockedByDoor' );
}


///////////////////////////////////////////////////////////////////////////////
// OrderCaptivesDown
//
// Order all hostages and surrendered terrorist down.
//::static function OrderCaptivesDown(
//::	SASPawn		aCommander )
//::{
//::	local SASPawn			other;
//::	local SASAssaultVolume	commandersAV;
//::
//::	commandersAV = aCommander.GetAssaultVolume();
//::	if ( commandersAV == None )
//::	{
//::		return;
//::	}
//::
//::	foreach aCommander.GetGame().RadiusSASPawns( class'SASPawn', other, aCommander.Location, 1000.0 )
//::	{
//::		if ( other.Controller != None )
//::		{
//::			if ( other.Controller.mType == CONTROLLER_AIHostage )
//::			{
//::				if ( other.GetAssaultVolume() == commandersAV )
//::				{
//::					SASHostageController( other.Controller ).PlayerOrder( HOSTAGEORDER_GetDown, aCommander );
//::				}
//::			}
//::			else if ( other.Controller.mType == CONTROLLER_AITerrorist )
//::			{
//::				if ( SASTerrorist( other ).mbSurrendered && (other.GetAssaultVolume() == commandersAV) )
//::				{
//::					SASTerroristController( other.Controller ).DoOrderedDown();
//::				}
//::			}
//::		}
//::	}
//::}


///////////////////////////////////////////////////////////////////////////////
// CheckCanBePunched
//
// Called on server side by ServerDoPunchedByPlayer to check if controlled pawn 
// is punchable. 
// NOTE: This fn is overriden in various AI states to deal with specific controller
// states/behaviour which affect punchability.
function bool CheckCanBePunched()
{
	// Only server can do this.
	if ( Role != ROLE_Authority )
	{
		return false;
	}

	// Is pawn punchable?
	return mSASPawn.CanBePunched();
}


///////////////////////////////////////////////////////////////////////////////
// ServerDoPunchedByPlayer
//
// Reaction to being hit by player. Called from SASPawn.ServerDoPunchedByPlayer.
function ServerDoPunchedByPlayer(
	SASPawn aHitBy )
{
	if ( CheckCanBePunched() )
	{
		DoPunchedByPlayer( aHitBy );
	}
}


///////////////////////////////////////////////////////////////////////////////
// DoPunchedByPlayer
//
// Trigger pucnh reaction on server side.
function DoPunchedByPlayer( 
	SASPawn	aHitBy )
{
	local name anim;

	anim = mSASPawn.GetPunchedAnim();
	if ( anim != 'None' )
	{
		StopMoving();

		// Just do this via a transition anim
		DoTransition( anim, GetStateName(), '', mSASPawn.meStance );
	}

	// Sound effect.
	mSASPawn.PlaySpeech( SPEECH_GenHit, true );
}

//-----------------------------------------------------------------------------
// States

function DoMoveToActor(
	Actor						aGoalActor,				// Goal actor to move to.
	optional ESASPace			aePace,					// Movement pace (defaults to running
	optional ESASStance			aeStance,				// Stance (defaults to normal standing).
	optional Actor				aFocalActor,			// Focal actor during move.
	optional Vector				aFocalPoint,			// Focal point during move.
	optional float				aDestOffset,			// Destination offset
	optional bool				abPreciseReachGoal,		// If true, must be precise on reaching goal location.
	optional SASAssaultVolume	aAvoidVolume );			// Assault volume to avoid moving through. 
function DoMoveToPoint(
	Vector						aGoalLoc,				// Goal location to move to.
	optional ESASPace			aePace,					// Movement pace (defaults to running).
	optional ESASStance			aeStance,				// Stance (defaults to normal standing).
	optional Actor				aFocalActor,			// Focal actor during move.
	optional Vector				aFocalPoint,			// Focal point during move.
	optional bool				abPreciseReachGoal,		// If true, must be precise on reaching goal location.
	optional SASAssaultVolume	aAvoidVolume );			// Assault volume to avoid moving through. 
function SetupMovingStateCommonParameters(
	ESASPace			aePace,					// Movement pace (defaults to running
	ESASStance			aeStance,				// Stance (defaults to normal standing).
	Actor				aFocalActor,			// Focal actor during move.
	Vector				aFocalPoint,			// Focal point during move.
	bool				abPreciseReachGoal,		// If true, must be precise on reaching goal location.
	SASAssaultVolume	aAvoidVolume );			// Assault volume to avoid moving through. 
function CompleteMove();
function OpenedDoor();
function ReachedPathIntermediatePoint(
	Actor	aPoint );
function NotifyCompletedMove();
function bool ShouldDoPreciseMoveTo(
	Actor	aDestActor );
function bool WithinWalkDistance( 
	Vector	aMoveLocation );
function StopSteppingAside();
function bool ShouldKeepSteppingAside();
function bool CanEndSteppingAside();
function EndBlockedByDoor();
function FinishClimb();
function bool CheckHoldingCorrectGrenade();
function DeselectGrenadeWeapon();
function bool IsReadyToThrow();
function FinishThrowingGrenade();
function ShoutGrenade();
function GetRetreatPoint();
function UpdateRetreatPoint();
function AbortScript();
function MoveToNextAction();
function CheckScriptTimers();
function CompleteLatentAction();
function CheckFiring();
function bool CheckPlayingAnimFromStunned(
	bool	abAnimEnd );
function bool CheckPlayingAnimFromGassed();
event CompleteTransition();
function bool StepAsideChainEndsInPlayerOrMover( int recurseLevel );


///////////////////////////////////////////////////////////////////////////////
// IsOtherPawnStandingAtMyGoalLocation
//
function bool IsOtherPawnStandingAtMyGoalLocation(
	SASPawn	aOtherPawn )
{
	return false;
}

///////////////////////////////////////////////////////////////////////////////
// NotifyGoalLocationIsBlocked
//
// Event received when we can't get onto our goal location because another
// pawn is standing there. Returns true if we do something as a response
// (e.g. find another goal location/give up trying to reach goal).
function  bool NotifyGoalLocationIsBlocked(
	SASPawn	aObstructor )
{
	return false;
}

///////////////////////////////////////////////////////////////////////////////
// NotifyObstructedDuringMove
//
event bool NotifyObstructedDuringMove(
	SASPawn		aObstructor );


///////////////////////////////////////////////////////////////////////////////
// RequestUnobstructAction
//
function bool RequestUnobstructAction(
	Pawn	aObstructing )
{
	return false;
}


///////////////////////////////////////////////////////////////////////////////
// STATE MovingState
//
state MovingState
{
	ignores WeaponPointedAt;

	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	//
	event BeginState()
	{
		mInteractDoor = None;
		mbOpeningDoor = false;
	}

	///////////////////////////////////////////////////////////////////////////////
	// EndState
	//
	event EndState()
	{
		mbOpeningDoor = false;

		// Don't need these timers running when not in this state.
		StopMultiTimer( mTimerCheckDoor );
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyHitWall
	//
	event bool NotifyHitWall(
		vector	aHitNormal, 
		Actor	aWall )
	{
		if ( bAdjusting )
		{
			bAdjusting = false;
		}

		return false;
	}


	///////////////////////////////////////////////////////////////////////////////
	// SetupMovingStateCommonParameters
	//
	function SetupMovingStateCommonParameters(
		ESASPace			aePace,					// Movement pace (defaults to running
		ESASStance			aeStance,				// Stance (defaults to normal standing).
		Actor				aFocalActor,			// Focal actor during move.
		Vector				aFocalPoint,			// Focal point during move.
		bool				abPreciseReachGoal,		// If true, must be precise on reaching goal location.
		SASAssaultVolume	aAvoidVolume )			// Assault volume to avoid moving through. 
	{
		mbFailedMoveToPoint = false;

		// Check stance parameter is valid moving stance.
		// e.g. Hostages cannot do crouched moves.
		switch ( aeStance )
		{
		case STANCE_Standing:
			// Standing stance always valid.
			break;

		case STANCE_Crouched:
			// Crouched stance only valid if can move while crouching.
			if ( !mSASPawn.mbCanMoveCrouched )
			{
				aeStance = STANCE_Standing;
			}	
			break;

		case STANCE_Prone:
			Warn( "DoMoveToActor called with invalid stance <"$aeStance$">" );
			aeStance = STANCE_Standing;
			break;

		default:
			Warn( "DoMoveToActor called with unrecognised stance <"$aeStance$">" );
			aeStance = STANCE_Standing;
			break;
		}

		meMovingStatePace	= aePace;
		meMovingStance		= aeStance;
		mMovingFocalActor	= aFocalActor;
		if ( (aFocalActor == None) && (aFocalPoint != vect(0,0,0)) )
		{
			mMovingFocalPoint = aFocalPoint;
		}
		else
		{
			mMovingFocalPoint = vect(0,0,0);
		}
		mbPreciseReachGoal		= abPreciseReachGoal;
		mMovingStateAvoidVolume = aAvoidVolume;

		switch ( aePace )
		{
		case PACE_Walking:
			meMovingStatePace = PACE_Walking;
			break;

		case PACE_Running:
			if ( mSASPawn.GetMaxPace() == PACE_Walking )
			{
				meMovingStatePace = PACE_Walking;
			}
			else
			{
				meMovingStatePace = PACE_Running;
			}
			break;

		case PACE_Charging:
			meMovingStatePace = mSASPawn.GetMaxPace();
			break;
		}
	}

	
	///////////////////////////////////////////////////////////////////////////////
	// DoMoveToActor
	//
	function DoMoveToActor(
		Actor						aGoalActor,				// Goal actor to move to.
		optional ESASPace			aePace,					// Movement pace (defaults to running
		optional ESASStance			aeStance,				// Stance (defaults to normal standing).
		optional Actor				aFocalActor,			// Focal actor during move.
		optional Vector				aFocalPoint,			// Focal point during move.
		optional float				aDestOffset,			// Destination offset
		optional bool				abPreciseReachGoal,		// If true, must be precise on reaching goal location.
		optional SASAssaultVolume	aAvoidVolume )			// Assault volume to avoid moving through. 
	{
		if ( aGoalActor == None )
		{
			Warn( "DoMoveToActor called with NULL goal actor in state <"$GetStateName()$">." );
		}
		
		// Only clear cached GoalAnchor nav point if new goal actor is different to previous one.
		if ( aGoalActor != mGoalActor )
		{
			GoalAnchor = None;	
		}

		mGoalActor			= aGoalActor;
		mGoalLocation		= vect(0, 0, 0);
		mGoalDestOffset		= aDestOffset;

		SetupMovingStateCommonParameters(
			aePace,		
			aeStance,	
			aFocalActor,
			aFocalPoint,
			abPreciseReachGoal,
			aAvoidVolume );
		
		// If already at point then jump straight to move end label.
		if ( mSASPawn.ReachedDestination( mGoalActor, ShouldDoPreciseMoveTo( mGoalActor ) ) )
		{
			GotoState( , 'MTP_NoMoveRequired' );
		}
		// If already have correct stance, start moving.
		else if ( aeStance == mSASPawn.meStance )
		{
			GotoState( , 'MTP_StartMoving' );
		}
		// Need to adjust stance before moving.
		else
		{	
			DoStanceTransition( aeStance, GetStateName(), 'MTP_StartMoving' );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// DoMoveToPoint
	//
	function DoMoveToPoint(
		Vector						aGoalLoc,				// Goal location to move to.
		optional ESASPace			aePace,					// Movement pace (defaults to running).
		optional ESASStance			aeStance,				// Stance (defaults to normal standing).
		optional Actor				aFocalActor,			// Focal actor during move.
		optional Vector				aFocalPoint,			// Focal point during move.
		optional bool				abPreciseReachGoal,		// If true, must be precise on reaching goal location.
		optional SASAssaultVolume	aAvoidVolume )			// Assault volume to avoid moving through. 
	{
		// Only clear cached GoalAnchor nav point if new goal location is different to previous one.
		if ( (mGoalActor != None) || (aGoalLoc != mGoalLocation) )
		{
			GoalAnchor = None;	
		}

		mGoalActor			= None;
		mGoalLocation		= aGoalLoc;
		mGoalDestOffset		= 0.0;
		mSASPawn.DestinationOffset = 0.0;

		SetupMovingStateCommonParameters(
			aePace,		
			aeStance,	
			aFocalActor,
			aFocalPoint,
			abPreciseReachGoal,
			aAvoidVolume );

		// If already at point then jump straight to move end label.
		if ( mSASPawn.ReachedPoint( mGoalLocation ) )
		{
			GotoState( , 'MTP_NoMoveRequired' );
		}
		// If already have correct stance, start moving.
		else if ( aeStance == mSASPawn.meStance )
		{
			GotoState( , 'MTP_StartMoving' );
		}
		// Need to adjust stance before moving.
		else
		{	
			DoStanceTransition( aeStance, GetStateName(), 'MTP_StartMoving' );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// StartClimbing
	//
	function bool StartClimbing(
		SASClimbPoint	aStartPoint )
	{
		return DoClimbing( aStartPoint, GetStateName(), 'MTP_KeepMoving' );
	}


	///////////////////////////////////////////////////////////////////////////////
	// CompleteMove
	//
	// Called on either failing or completing move. Jumps to MTP_FinishedMove' label
	// in the controller's sub-state.
	function CompleteMove()
	{
		StopMoving();
		/*if ( Pawn.Physics == PHYS_Walking )
		{
			Pawn.SetPhysics( PHYS_None );
		}*/
	
		mInteractDoor = None;
		mbOpeningDoor = false;

		GotoState( GetStateName(), 'MTP_FinishedMove' );
	}


	///////////////////////////////////////////////////////////////////////////////
	// MoverFinished
	//
	// Called when the mover we are waiting to open (PendingMover) has done so.
	event MoverFinished()
	{
		Global.MoverFinished();

		// Continue moving to goal.
		OpenedDoor();
	}


	///////////////////////////////////////////////////////////////////////////////d
	// MultiTimer
	//
	event MultiTimer(
		int	aTimerIdx )
	{
		switch( aTimerIdx )
		{
		case mTimerCheckDoor:
			if ( PendingMover == None )
			{
				// Lost the pointer to the mover we are waiting on, try to resume moving.
				Warn( "PendingMover==None while waiting for door to open in SASAIController Moving state" );
				OpenedDoor();
			}

			// TODO: Check door is actually opening.
			break;

		default:
			Global.MultiTimer( aTimerIdx );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// OpenedDoor
	//
	function OpenedDoor()
	{
		// Stop timer checking for problems in door opening.
		mbOpeningDoor = false;
		StopMultiTimer( mTimerCheckDoor );

		mInteractDoor = None;
		mApproachingClosedDoorTimer = -1.0;
		mSASPawn.ChangeAnimation();

		// Continue moving to goal.
		GotoState( GetStateName(), 'MTP_StartMoving' );
	}


	///////////////////////////////////////////////////////////////////////////////
	// UnderLift
	//
	// Called when any mover (not just lifts) encroaches the pawn 
	// - just ignore the event.
	function UnderLift(
		Mover aMover )
	{
		// Do nothing.
	}


	///////////////////////////////////////////////////////////////////////////////
	// LatentFindNavAnchors
	//
	/*function LatentFindNavAnchors()
	{
		local bool	bMoveToGoalAnchor;

		bGoalReachable = false;
		EmtyAnchorLists();

		if ( mGoalActor != None )
		{
			// Moving to an actor rather than a vector location...

			// If we have a goal anchor nav point cached and its still valid for the goal actor (actor
			// hasn't moved significantly) and we haven't yet reached the anchor then flag that should
			// move to the anchor point first.
			if (	(GoalAnchor != None) &&
					IsNavPointAValidAnchorForActor( GoalAnchor, mGoalActor ) &&
					!mSASPawn.ReachedDestination( GoalAnchor ) )
			{
				bMoveToGoalAnchor = true;
			}

			if ( bMoveToGoalAnchor )
			{
				if ( !ValidAnchor() )
				{
					BuildStartAnchorList();
				}
				if ( !mGoalActor->GetNavAnchor() )
				{
					BuildEndAnchorList();
				}
			}
			else
			{
				if ( ActorReachable( mGoalActor, mbPreciseReachGoal ) )
				{
					bGoalReachable = true;
					return;
				}
				else
				{
					if ( !ValidAnchor() )
					{
						BuildStartAnchorList();
					}
					if ( !mGoalActor->GetNavAnchor() )
					{
						BuildEndAnchorList();
					}
				}
			}
		}
		else if ( mGoalLocation != vect(0,0,0) )
		{
			// Moving to a vector location rather than an actor...

			// If we have a goal anchor nav point cached and we haven't yet reached the anchor 
			// then flag that should move to the anchor point first.
			if ( (GoalAnchor != None) 
				&& !GoalAnchor.bBlocked
				&& !mSASPawn.ReachedDestination( GoalAnchor ) )
			{
				bMoveToGoalAnchor = true;
			}

			if ( bMoveToGoalAnchor )
			{
				// We have a valid anchor nav point for the goal actor and we are not yet within range of
				// it so move to that rather than the goal actor.
				if ( !ValidAnchor() )
				{
					BuildStartAnchorList();
				}
				if ( !mGoalActor->GetNavAnchor() )
				{
					BuildEndAnchorList();
				}
			}
			else
			{
				if ( PointReachable( mGoalLocation, mbPreciseReachGoal ) )
				{
					bGoalReachable = true;
					MoveTarget = None;
					return true;
				}
				else
				{
					// Can't reach goal location directly, search for path to...
					if ( !ValidAnchor() )
					{
						BuildStartAnchorList();
					}
					if ( !mGoalActor->GetNavAnchor() )
					{
						BuildEndAnchorList();
					}
				}
			}
		}

		// If have start and end anchor lists - work out how many frames we need to 
		// process across.
		numAnchors = 
	}*/


	///////////////////////////////////////////////////////////////////////////////
	// ReachedPathIntermediatePoint
	//
	// Callback to notify we've reached an intermediate nav point on the path 
	// to the current goal.
	function ReachedPathIntermediatePoint(
		Actor	aPoint );


	///////////////////////////////////////////////////////////////////////////////
	// NotifyCompletedMove
	//
	function NotifyCompletedMove();


	///////////////////////////////////////////////////////////////////////////////
	// ShouldDoPreciseMoveTo
	//
	function bool ShouldDoPreciseMoveTo(
		Actor	aDestActor )
	{
		if ( (aDestActor == mGoalActor) && mbPreciseReachGoal )
		{
			return true;
		}

		return aDestActor.PreciseMoveTo();
	}


	///////////////////////////////////////////////////////////////////////////////
	// WithinWalkDistance
	//
	function bool WithinWalkDistance( 
		Vector	aMoveLocation )
	{
		local float distSq;

		if ( SASHostage( Pawn ) != None )
		{
			return false;
		}

		// HACK: Investigating terrorists shouldn't walk
		if ( GetStateName() == 'Investigating' )
		{
			return false;
		}

		distSq = VSizeHorizSq( Pawn.Location - aMoveLocation );

		if ( distSq < Square( WALK_TO_POINT_DIST ) )
		{
			return true;
		}

		return false;
	}


	///////////////////////////////////////////////////////////////////////////////
	// IsOtherPawnStandingAtMyGoalLocation
	//
	function bool IsOtherPawnStandingAtMyGoalLocation(
		SASPawn	aOtherPawn )
	{
		local Vector	goalLoc,
						offset;

		// Is pawn standing on my goal location?
		if ( mGoalActor != None )
		{
			goalLoc = mGoalActor.Location; 
		}
		else
		{
			goalLoc = mGoalLocation;
		}

		offset = goalLoc - aOtherPawn.Location;

		// Test horizontal overlap.
		if ( VSizeHorizSq( offset ) < Square( aOtherPawn.CollisionRadius ) )
		{
			// Test vertical overlap.
			if ( Abs( offset.Z ) < aOtherPawn.CollisionHeight )
			{
				return true;
			}
		}

		return false;
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyBump
	//
	event bool NotifyBump(
		Actor	aBumped )
	{
		local SASPawn	bumpedPawn;

		// If bumped into is a pawn standing on my destination point and they
		// won't step aside for me then choose what to do (stop now, choose new
		// destination etc).
		bumpedPawn = SASPawn( aBumped );
		if ( bumpedPawn != None )
		{
			// Can't be blocked if goalactor is the pawn we've bumped into.
			if ( mGoalActor == None || mGoalActor != bumpedPawn )
			{
				if ( IsOtherPawnStandingAtMyGoalLocation( bumpedPawn ) )
				{
					// Yes other pawn is blocking, if it won't step aside then consider
					// another action.
					if ( !WillPawnStepAsideForMe( bumpedPawn ) )
					{	
						NotifyGoalLocationIsBlocked( bumpedPawn );
					}
				}
			}
		}

		return Global.NotifyBump( aBumped );
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyObstructedDuringMove
	//
	event bool NotifyObstructedDuringMove(
		SASPawn		aObstructor )
	{
		// If obstructing pawn is on our goal point then notify pawn that goal is blocked.
		if ( IsOtherPawnStandingAtMyGoalLocation( aObstructor ) )
		{
			// Notify self that can't get to goal - if returns true then we are responding
			// so don't need to try anything else.
			if ( NotifyGoalLocationIsBlocked( aObstructor ) )
			{
				return true;
			}
		}

		// If obstructing pawn is AI controlled then check if it can do something
		// to get out of my way.
		if ( aObstructor.Controller.RequestUnobstructAction( Pawn ) )
		{
			// How kind, it's going to try to get out of the way after all.
			return true;
		}
			
		// Seek alternate path avoiding obstructing pawns.
		if ( FindUnobstructedPath() )
		{
			GotoState( , 'MTP_PostUpdateDest' );
			return true;
		}

		return false;
	}


MTP_StartMoving:
	if ( mSASPawn.Physics == PHYS_Falling )
	{
		WaitForLanding();	
	}
	mSASPawn.SetPhysics( PHYS_Walking );
	mSASPawn.ChangeAnimation();

MTP_KeepMoving:

	mInteractDoor = None;
	mbOpeningDoor = false;

	// If trying to fire always try to look at he target.
	if ( TryingToFire() )
	{
		// If firing at a point or the target is None then set the focus to None - it will be set to
		// something else later on. Else focus on the Target.
		if ( mbUseTargetPoint || (Target == None) )
		{
			Focus = None;
		}
		else
		{
			SetFocus (Target);
		}
	}
	else
	{
		// Focus on the specified moving focus if we have one.
		// TF - soldiers only do this if the focal actor is in our volume. This is to fix a very
		// specific bug of soldiers looking at odd targets.
		if (	(SASPawn( mMovingFocalActor ) == None) ||
				(mType != CONTROLLER_AISoldier) ||
				(SASPawn( mMovingFocalActor ).GetAssaultVolume() == mSASPawn.GetAssaultVolume()) )
		{
			SetFocus( mMovingFocalActor );
		} 
		else
		{
			Focus = None;
		} 
	}

	// Make sure using correct stance.
	Pawn.ChangeStanceImmediate( meMovingStance );

	// Update next immediate point to move to on path to destination.

	// If pawn is stationary we can take a short while to process this. If moving
	// then get next dest immediately as we don't want to have moved before
	// the result comes back.
	mbMoveFound = false;
	if ( mSASPawn.IsStationary() )
	{
		UpdateDestinationLatent();
	}
	else
	{
		UpdateDestinationImmediate();
	}
	
MTP_PostUpdateDest:

	if ( mbMoveFound )
	{
		if ( mInteractDoor != None )
		{
			Goto( 'MTP_MoveToDoorInteractLocation' );
		}

		mSASPawn.SetPace( meMovingStatePace );

		if ( MoveTarget != None )
		{
			// If moving focus has not been specified then choose one.
			if ( Focus == None )
			{
				// If trying to fire at a point foucs one it.
				if ( TryingToFire() && mbUseTargetPoint )
				{
					FocalPoint = mTargetPoint;
				}
				// Else If a moving focal point has been specified use that.
				else if ( mMovingFocalPoint != vect(0,0,0) )
				{
					FocalPoint = mMovingFocalPoint;
				}
				// Else if about to turn a corner face the nav point beyond the corner.
				else if ( mbApproachingCorner && (RouteCache[1] != None) )
				{
					SetFocus (RouteCache[1]);
				}
				// Else just face the next immediate move target.
				else
				{
					SetFocus (MoveTarget);
				}
			}

			if ( MoveTarget == mGoalActor )
			{
				// If not currently moving and MoveTarget is the goal and goal is only a short distance away then
				// walk to goal.
				if (	(Enemy == None) && 
						(Pawn.mePace == PACE_Running) &&
						(Pawn.Velocity == vect(0,0,0)) && 
						WithinWalkDistance( MoveTarget.Location ) )
				{
					Pawn.SetPace( PACE_Walking );
				}

				MoveToward( 
					MoveTarget, 
					Focus,
					FocalPoint,
					mGoalDestOffset, 
					/*bUseStrafing*/, 
					Pawn.mePace, 
					ShouldDoPreciseMoveTo( MoveTarget ) );
			}	
			else
			{
				// If not currently moving and dist to goal is only a short dist away then walk to goal.
				if (	(Enemy == None) && 
						(Pawn.mePace == PACE_Running) &&
						(Pawn.Velocity == vect(0,0,0)) && 
						(RouteDist < WALK_TO_POINT_DIST) )
				{
					Pawn.SetPace( PACE_Walking );
				}

				MoveToward( 
					MoveTarget, 
					Focus,
					/*Focal point*/,
					/*dest offset*/, 
					/*bUseStrafing*/, 
					Pawn.mePace,
					ShouldDoPreciseMoveTo( MoveTarget ) );
			}

			if ( Pawn.ReachedDestination( MoveTarget, ShouldDoPreciseMoveTo( MoveTarget ) ) )
			{
				if ( MoveTarget != mGoalActor )
				{
					// Callback to sub-state to notify we have reached a point along the path.
					ReachedPathIntermediatePoint( MoveTarget );

					// Keep going...
					Goto( 'MTP_KeepMoving' );
				}
			}
			else
			{
				// Clear cached anchor - we may be trying to get to it but for some reason its
				// become blocked - need to redo the ActorReachable check.
				GoalAnchor = None;

				// Keep going...
				Goto( 'MTP_KeepMoving' );
			}
		}
		else if ( mGoalLocation != Vect(0,0,0) )
		{
			if ( Focus == None )
			{
				if ( mMovingFocalPoint != vect(0,0,0) )
				{
					SetFocalPoint( mMovingFocalPoint );
				}
				else
				{
					SetFocalPoint( mGoalLocation );
				}
			}

			// If not currently moving and goal is only a short distance away then walk to goal.
			if (	(Enemy == None) && 
					(Pawn.mePace == PACE_Running) &&
					(Pawn.Velocity == vect(0,0,0)) && 
					WithinWalkDistance( mGoalLocation ) )
			{
				Pawn.SetPace( PACE_Walking );
			}

			MoveTo( mGoalLocation, Focus, FocalPoint, Pawn.mePace, mbPreciseReachGoal );

			if ( !Pawn.ReachedPoint( mGoalLocation, mbPreciseReachGoal ) )
			{
				// Clear cached anchor - we may be trying to get to it but for some reason its
				// become blocked - need to redo the ActorReachable check.
				GoalAnchor = None;

				Goto( 'MTP_KeepMoving' );
			}
		}
		else
		{
			LogHuman( Pawn$" has move target of (0,0,0)" );
		} 
	}
	else
	{
		if ( (Pawn.Anchor == None) && (mInteractDoor != None) )
		{
			DoBlockedByDoor( mInteractDoor );
		}

		// Flag failure so follow-on state can handle it.
		Log( Pawn$" failed to reach destination in state <"$GetStateName()$">." );
		mbFailedMoveToPoint = true;
	}


MTP_EndMoving:

	// If goal actor is our current CP and we have successfully reached it then update the CP 
	// arival time.
	if (	(mGoalActor != None) &&
			((mGoalActor == mCoverPoint) || (SASCoverPoint( mGoalActor ) != None)) &&
			mSASPawn.ReachedDestination( mGoalActor, true ) )
	{
		ReachedCover();
	}

	// Notify completed move before going further - to allow controller to possibly 
	// update the move goal location before stopping the pawn in CompleteMove() below.
	NotifyCompletedMove();

	CompleteMove();
	
	Warn( "MovingState: Failed to complete move." );
	Stop;

MTP_NoMoveRequired:

	// Arrive at this point in code when we try to commence a move when already at the destination. 
	// Using Sleep (which forces the script to idle for 1 frame) to prevent any runaway 
	// loops when repeatedly trying to move to the same location.
	Sleep( 0.01 );
	Goto( 'MTP_EndMoving' );

MTP_MoveToDoorInteractLocation:

	mbOpeningDoor = true;
	
	// Change animation makes the pawn port his weapon when opening doors. Do this to help prevent
	// weapons poking though the door when opening.
	mSASPawn.ChangeAnimation();

	// Move toward the door interact offest position.
	// TODO: Make this use the find path functionality incase there isn't a direct path.
	Focus = None;
	MoveToward( mInteractDoor.GetInteractPointForPawn( Pawn ), None, mInteractDoor.mClosedWorldCentrePos, /*DestinationOffset*/, /*bUseStrafing*/, Pawn.mePace );
	StopMoving();

MTP_OpenDoor:

	Pawn.ChangeStanceImmediate( STANCE_Standing );
	SetFocalPoint( mInteractDoor.mClosedWorldCentrePos );
	//SetFocus( mInteractDoor );
	FinishRotation();

	mbOpeningDoor = false;

	// Trigger door to open and wait for it to complete.
	mInteractDoor.Trigger( self, Pawn );

	WaitForMover( mInteractDoor );

	// Timer used as safety check that we don't end up waiting forever for door open event.
	SetMultiTimer( mTimerCheckDoor, 1.0, true );

	Stop;

MTP_FinishedMove:

	Warn( "MovingState: Error - at MTP_FinishedMove label in base state. State="$GetStateName() );
	Stop;

MTP_StuckBehindDoor:

	if ( mInteractDoor == None )
	{

	}
}


///////////////////////////////////////////////////////////////////////////////
// STATE SteppingAside
//
// Doing stepping out of way of other pawn avoidance move.
state SteppingAside extends MovingState
{
	// Don't care about preempting player bump while stepping aside.
	ignores NotifyPlayerAboutToBump;

	///////////////////////////////////////////////////////////////////////////////
	// DisplayDebug
	//
	function DisplayDebug(
		Canvas		aCanvas, 
		out float	aYL, 
		out float	aYPos )
	{
		Global.DisplayDebug( aCanvas, aYL, aYPos );

		aCanvas.DrawText( "Stepping aside for actor <"$mSteppingAsideFor$"> to location "$mStepAsidePoint$". Duration="$(Level.TimeSeconds-mStepAsideStartTime) );
		aYPos += aYL;
		aCanvas.SetPos( 32, aYPos );
	}

	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	//
	event BeginState()
	{
		Super.BeginState();

		if ( mSteppingAsideFor == None )
		{
			Warn( self$" entered SteppingAside state without actor to step aside from." );
			StopSteppingAside();
		}

		// Stop waiting for doors to open.
		if ( PendingMover != None )
		{
			MoverFinished();
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndState
	//
	event EndState()
	{
		Super.EndState();

		if ( mSASPawn != None )
		{
			mSASPawn.bIgnoreSpine = false;
			mSASPawn.bDisableTurnAnims = false;
		}

		// Clear stepping aside data.
		mSteppingAsideFor = None;
		StopMultiTimer( mTimerAvoiding );
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyHitWall
	//
	event bool NotifyHitWall(
		vector	aHitNormal, 
		Actor	aWall )
	{
		// End avoidance move on hitting wall.
		CompleteMove();
		return false;
	}

	///////////////////////////////////////////////////////////////////////////////
	// MultiTimer
	//
	event MultiTimer(
		int	aTimerIdx )
	{
		switch( aTimerIdx )
		{
		case mTimerAvoiding:
			if ( CanEndSteppingAside() )
			{
				StopSteppingAside();
			}
			break;

		default:
			Super.MultiTimer( aTimerIdx );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// StopSteppingAside
	//
	function StopSteppingAside()
	{
		CompleteMove();
		ResumeObjective();
	}


	///////////////////////////////////////////////////////////////////////////////
	// StepAsideChainEndsInPlayerOrMover
	//
	function bool StepAsideChainEndsInPlayerOrMover( int recurseLevel )
	{
		local Pawn	stepAsideForPawn;

		if ( recurseLevel > 10 )
		{
			return false;
		}

		if ( Mover( mSteppingAsideFor ) != None )
		{
			return true;
		}

		if ( Pawn( mSteppingAsideFor ) != None )
		{
			stepAsideForPawn = Pawn( mSteppingAsideFor );
			if ( stepAsideForPawn.Controller.mType == CONTROLLER_Player )
			{
				return true;
			}

			if ( stepAsideForPawn.Controller.IsInState( 'SteppingAside' ) )
			{
				return SASAIController( stepAsideForPawn.Controller ).StepAsideChainEndsInPlayerOrMover( ++recurseLevel );
			}
		}

		return false; 
	}

	///////////////////////////////////////////////////////////////////////////////
	// ShouldKeepSteppingAside
	//
	function bool ShouldKeepSteppingAside()
	{
		local Vector	dest;

		// Check if need to keep moving (if other is still heading towards us).
		if ( !CheckKeepSteppingAside() )
		{
			return false;
		}

		// Try to find an avoidance dest.
		if ( FindStepAsidePoint( mSteppingAsideFor, dest ) )
		{
			// New point found must be greater than collision radius away for move to actually happen. 
			if ( mSASPawn.ReachedPoint( dest ) )
			{
				return false;
			}

			mStepAsidePoint = dest;
			return true;
		}

		// Couldn't find new dest.
		return false;
	}


	///////////////////////////////////////////////////////////////////////////////
	// CanEndSteppingAside
	//
	// Check if we can end avoidance move.
	function bool CanEndSteppingAside()
	{
		local float		distSqToOther;
		local SASPawn	avoidingPawn;
		local Mover		avoidingMover;
		local Vector	vecToOther,
						otherVel;

		// Lost ptr to avoiding actor?
		if ( mSteppingAsideFor == None )
		{
			return true;
		}

		// Avoidance move timed out?
		if ( Level.TimeSeconds > (mStepAsideStartTime + STEPPING_ASIDE_MAX_TIME) )
		{
			return true;
		}

		avoidingPawn = SASPawn( mSteppingAsideFor );
		avoidingMover = Mover( mSteppingAsideFor );
		if ( (avoidingPawn == None) && (avoidingMover == None) )
		{
			return true;
		}

		if ( avoidingMover != None )
		{
			// Is door not one to avoid or closed or fully open?
			if (	!avoidingMover.bAvoidMe ||
					avoidingMover.bClosed ||
					avoidingMover.IsFullyOpen() )
			{
				return true;
			}
		}
		else
		{
			// Is pawn we are avoiding dead?
			if (	!avoidingPawn.IsAlive() || 
					avoidingPawn.mbIsIncapacitated )
			{
				return true;
			}

			vecToOther = avoidingPawn.Location - Pawn.Location;
			distSqToOther = VSizeHorizSq( vecToOther );

			// Avoiding pawn out of range?
			if ( distSqToOther > Square( (Pawn.CollisionRadius + avoidingPawn.CollisionRadius) * 1.5 ) )
			{
				return true;
			}

			// Avoiding pawn moving away from us?
			otherVel = avoidingPawn.Acceleration;
			if (	(otherVel != vect(0,0,0)) && 
					(distSqToOther > Square( Pawn.CollisionRadius + avoidingPawn.CollisionRadius + 16.0 )) &&
					((otherVel Dot vecToOther) > 0.0) )
			{
				return true;
			}
		}

		return false;
	}

Begin:

StartSteppingAside:

	mStepAsideStartTime = Level.TimeSeconds;

	// Set timer to check avoidance completion conditions.
	SetMultiTimer( mTimerAvoiding, 0.3, true );

KeepSteppingAside:
	
	// HACK: Surrendered terrorists should not rotate during step aside move (no rotate while surrendered anims).
	if ( (mType == CONTROLLER_AITerrorist) && SASTerrorist( mSASPawn ).mbSurrendered )
	{
		FixCurrentFacing();
		mSASPawn.bIgnoreSpine = true;
		mSASPawn.bDisableTurnAnims = true;
	}

	// Maintain current facing direction when stepping aside.
	if ( Focus != None )
	{
		DoMoveToPoint( mStepAsidePoint,, mSASPawn.meStance, Focus );
	}
	else
	{
		DoMoveToPoint( mStepAsidePoint,, mSASPawn.meStance,, FocalPoint );
	}

MTP_FinishedMove:

	// Check if should keep avoiding if pawn we are avoiding is about to hit us again.
	if ( mSASPawn.ReachedPoint( mStepAsidePoint ) && ShouldKeepSteppingAside() )
	{
		GotoState( , 'KeepSteppingAside' );
	}

	// Set timer to check avoidance completion conditions.
	SetMultiTimer( mTimerAvoiding, 0.3, true );

	Sleep( 0.25 );

	if ( (mType != CONTROLLER_AITerrorist) /*|| !SASTerrorist( mSASPawn ).mbSurrendered*/ )
	{
		SetFocalPointFromDir( ChooseDirectionNotFacingWall( vector(Pawn.Rotation) ) );
	}
}


///////////////////////////////////////////////////////////////////////////////
// STATE BlockedByDoor
//
state BlockedByDoor
{
	ignores NotifyPlayerAboutToBump;

	///////////////////////////////////////////////////////////////////////////////
	// DisplayDebug
	//
	function DisplayDebug(
		Canvas		aCanvas, 
		out float	aYL, 
		out float	aYPos )
	{
		Global.DisplayDebug( aCanvas, aYL, aYPos );

		aCanvas.DrawText( "Stuck behind door <"$mInteractDoor$">" );
		aYPos += aYL;
		aCanvas.SetPos( 32, aYPos );
	}


	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	//
	event BeginState()
	{
		Super.BeginState();

		if ( mInteractDoor == None )
		{
			Warn( self$" entered BlockedByDoor state without door to interact with." );
			EndBlockedByDoor();
			return;
		}

		// Stop waiting for doors to open.
		if ( PendingMover != None )
		{
			MoverFinished();
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// AllowDoorEncroach
	//
	function bool AllowDoorEncroach(
		SASDoorMover	aDoor )
	{
		if ( aDoor == mInteractDoor )
		{
			return true;
		}

		return false;
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndBlockedByDoor
	//
	function EndBlockedByDoor()
	{
		ResumeObjective();
	}

Begin:

CheckCloseDoor:

	if ( FindLocationToMoveAwayFromBlockingDoor( Destination ) )
	{
		Sleep( 0.1 );
		MoveTo( Destination,,, mSASPawn.mePace );
	}
	else
	{
		Sleep( 0.5 );
	}

	// Is door closed/closing?
	if ( mInteractDoor.IsClosedOrClosing() )
	{
		EndBlockedByDoor();
	}

	// Can only close blocking door if there is nobody in the way.
	if ( CheckDoorwayClear( mInteractDoor ) )
	{
		// Close door.
		mInteractDoor.Untrigger( self, Pawn ); 
	}
	
	// Wait a short while for door to close.
	Sleep( 0.5 );
	Goto( 'CheckCloseDoor' );
}


///////////////////////////////////////////////////////////////////////////////
// STATE Climbing
//
state Climbing
{
	ignores NotifyBump,
			NotifyPlayerAboutToBump,
			DoStepAside,
			SetFocus,
			SetFocalPoint,
			ReactToGrenade,
			DoGassed,
			DoStunned,
			DoStaggerBackward;

	event Tick(float dt)
	{
		// HACK to get rootmotion working when pawn not rendered!
		local Coords dummyCoords;
		dummyCoords = Pawn.GetBoneCoords( SPINE_BONE );
	}

	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	//
	event BeginState()
	{
		// Check we have a start point and are located on it.
		if ( (mClimbStart == None) || (mClimbStart != Pawn.Anchor)
			|| !Pawn.ReachedDestination( mClimbStart, true ) )
		{
			Warn( Pawn$" entered climbing state when not anchored on a SASClimbStart nav point. Leaving state." );
			FinishClimb();
		}

		Enable('Tick');
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndState
	//
	event EndState()
	{
		// Allow pawn to proceed with movement
		bPreparingMove = false;
		bControlAnimations = false;
		mClimbStart = None;

		if ( mSASPawn != None )
		{
			mSASPawn.bIgnoreSpine = false;
			mSASPawn.EndPlayClimbing();
		}

		Disable('Tick');
	}


	///////////////////////////////////////////////////////////////////////////////
	// FinishClimb
	//
	// Move onto climbing follow-on state.
	function FinishClimb()
	{
		if ( mNextState != 'None' )
		{
			GotoState( mNextState, mNextLabel );
		}
		else
		{
			ResumeObjective();
		}
	}

	
Begin:

	StopMoving();
	StopRepeatFiring();

	// Rotate to direction of climb start.
	mSASPawn.bIgnoreSpine = true;
	Focus = None;
	FocalPoint = mSASPawn.Location + (Vector( mClimbStart.Rotation ) * 1000.0);
	FinishRotation();

	//mSASPawn.bRotateToDesired = false;
	bControlAnimations = true;

	if ( !mSASPawn.PlayClimbing( mClimbStart.meClimbType ) )
	{
		FinishClimb();
	}

	FinishAnim( ANIMCHANNEL_ACTION );

	if ( mClimbStart.meClimbType == CLIMB_OverWall )
	{
		// Rotate pawn -90deg on completion of vault anim.
		mSASPawn.SetRotation( mSASPawn.Rotation + Rot(0,-16384,0) );
	}

Climbed:

	if ( Pawn.ReachedDestination( mClimbStart.mLinkedPoint ) )
	{
		Pawn.Anchor = mClimbStart.mLinkedPoint;
	}
	FinishClimb();
}


///////////////////////////////////////////////////////////////////////////////
// STATE ThrowingGrenade
//
state ThrowingGrenade
{
	ignores NotifyBump,
			NotifyPlayerAboutToBump,
			DoStepAside,
			DoStaggerBackward;

	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	//
	event BeginState()
	{
		if ( mGrenadePoint == None )
		{
			Warn( Pawn$" entered ThrowingGrenade state without a grenade-point." );
			FinishThrowingGrenade();
		}

		StopRepeatFiring();

		// Make sure we have the correct weapon selected, otherwise select it.
		CheckHoldingCorrectGrenade();

		mbAttackedFromCover = true;
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndState
	//
	event EndState()
	{
		mThrowGrenadeType	= GRENADECAT_None;
		mGrenadePoint		= None;

		// Ensure we stop trying to throw and have a normal weapon on leaving state.
		StopRepeatFiring();
		DeselectGrenadeWeapon();
		AnimBlendToAlpha( ANIMCHANNEL_Firing, 0, 0.2 );
		mSASPawn.ChangeAnimation();

		Disable( 'Tick' );
	}


	///////////////////////////////////////////////////////////////////////////////
	// CheckHoldingCorrectGrenade
	//
	// Returns true if currently selected weapon is a grenade weapon of the type
	// we  want to throw. If this is not the case then attempts to select the 
	// correct weapon.
	function bool CheckHoldingCorrectGrenade()
	{	
		local SASWeapon myWpn;
			
		if ( Pawn.Weapon != None )
		{
			myWpn = SASWeapon( Pawn.Weapon );
		}

		if ( (myWpn != None) 
			&& (myWpn.mCategory == WPNCAT_Grenade)
			&& (SASGrenadeWeapon( myWpn ).mGrenadeCategory == mThrowGrenadeType) )
		{
			return true;
		}

		if ( !mSASPawn.SelectGrenadeWeapon( mThrowGrenadeType ) )
		{
			Warn( Pawn$" in ThrowingGrenade state without correct grenade type available." );
			FinishThrowingGrenade();
		}
		
		return false;
	}


	///////////////////////////////////////////////////////////////////////////////
	// DeselectGrenadeWeapon
	//
	function DeselectGrenadeWeapon()
	{
		// Try to select previous weapon. If prev weapon not the primary or secondary
		// weapon then choose our best weapon.
		if (	(mSASPawn != None) && 
				(mSASPawn.mPrevWeapon != None) && 
				((mSASPawn.mPrevWeapon.mCategory == WPNCAT_Primary) || 
					(mSASPawn.mPrevWeapon.mCategory == WPNCAT_Secondary)) )
		{
			mSASPawn.PendingWeapon = mSASPawn.mPrevWeapon;
			mSASPawn.Weapon.PutDown();
		}
		else
		{
			SwitchToBestWeapon();
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// GrenadeReadyToThrow
	//
	function GrenadeReadyToThrow()
	{
		local SASGrenadeWeapon gw;

		if ( mbThrownGrenade )
		{
			Warn( Pawn$" received GrenadeReadyToThrow event after throwing grenade. " );
			FinishThrowingGrenade();
			return;
		}

		gw = SASGrenadeWeapon( Pawn.Weapon );
		if ( gw != None )
		{
			gw.ThrowGrenade();		
		}
		else
		{
			Warn( Pawn$" received GrenadeReadyToThrow event when not holding a grenade weapon." );
			FinishThrowingGrenade();
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyClipEmpty
	//
	// Event received when current weapon needs reloading.
	function NotifyClipEmpty()
	{
		if ( !mbThrownGrenade )
		{
			mSASPawn.Weapon.Reload();
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyClipEmpty
	//
	// Event received when weapon is idle and is loaded.
	function WeaponReadyToFire()
	{
		if ( !mbThrownGrenade )
		{
			// Check current weapon is actually the grenade type we want to throw. If
			// not then select the correct one.
			if ( CheckHoldingCorrectGrenade() )
			{
				// Have grenade ready, thorw it.
				GotoState( GetStateName(), 'Throw' );
			}
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// CanThrowNow
	//
	function bool IsReadyToThrow()
	{
		if ( !mbThrownGrenade )
		{
			if ( CheckHoldingCorrectGrenade() && Pawn.Weapon.IsIdle() )
			{
				return true;
			}
		}

		return false;
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyWeaponFired
	//
	function NotifyWeaponFired()
	{
		if ( SASGrenadeWeapon( Pawn.Weapon ) != None )
		{
			mbThrownGrenade = true;
			
			// Don't want to throw again.
			StopRepeatFiring();

			GotoState( GetStateName(), 'Released' );
		}
		else
		{
			Warn( Pawn$" received NotifyWeaponFired event when not holding a grenade weapon." );
			FinishThrowingGrenade();
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// Tick
	//
	event Tick( 
		float	aDeltaTime )
	{
		// Check for grenade weapon becoming idle after throwing grenade.
		if ( mbThrownGrenade 
			&& (Pawn.Weapon == None || Pawn.Weapon.IsIdle() || (SASGrenadeWeapon( Pawn.Weapon ) == None)) )
		{
			FinishThrowingGrenade();
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// FinishThrowingGrenade
	//
	function FinishThrowingGrenade()
	{
		DeselectGrenadeWeapon();

		if ( mNextState != 'None' )
		{
			GotoState( mNextState, mNextLabel );
		}
		else
		{
			Warn( "Next state not specified in ThrowingGrenade state for "$Pawn );

			ResumeObjective();
		}
	}

	///////////////////////////////////////////////////////////////////////////////
	// If a soldier threw a frag grenade, shout a warning (doesn't apply to flash-bangs or gas grenades)
	function ShoutGrenade()
	{
		local SASSoldier soldier;
		local SASGrenadeWeapon grenade;

		// SAS only - terrorists are far too indisciplined
		soldier = SASSoldier (mSASPawn);

		if ( soldier == None )
		{
			return;
		} 

		// Ensure this is the correct grenade type
		grenade = SASGrenadeWeapon( Pawn.Weapon );
		if ( grenade == None || grenade.mGrenadeCategory != GRENADECAT_Explosive )
		{
			return;
		} 

		mSASPawn.PlaySpeech( SPEECH_SquadThrowGrenade );
	}


Begin:

	if ( mbThrownGrenade )
	{
		Goto( 'Released' );
	}

	// Turn to face point to throw at.
	SetFocus (mGrenadePoint);

	// If at cover, stay hidden until grenade ready to throw.
	/*if ( (mCoverPoint != None) && mSASPawn.ReachedDestination( mCoverPoint ) )
	{
		mSASPawn.ChangeStanceImmediate( mCoverPoint.meStance );
	}*/

	if ( !IsReadyToThrow() )
	{
		Stop;
	}

Throw:

	FinishRotation();

	if ( mSASPawn.meStance != STANCE_Standing )
	{
		if ( mSASPawn.PlayStanceTransitionAnim( STANCE_Standing ) )
		{
			mSASPawn.ChangeStanceImmediate( STANCE_Standing );
			FinishAnim( ANIMCHANNEL_ACTION );
			mSASPawn.ChangeAnimation();
		}
		else
		{
			mSASPawn.ChangeStanceImmediate( STANCE_Standing );
		}
	}

	// If at cover, need to be stood up to throw grenade.
	/*if ( (mCoverPoint != None) && mSASPawn.ReachedDestination( mCoverPoint ) )
	{
		if ( CP firing stance not same as current stance )
		{
			mSASPawn.ChangeStanceImmediate( mCoverPoint.meFiringStance );
			// Wait til in correct stance.
			Sleep( 0.3 );
		}
	}*/

	ShoutGrenade ();

	Target = mGrenadePoint;
	StartRepeatFiring( 1,, true );
	Stop;

Released:

	// Check for weapon becoming idle.
	Enable( 'Tick' );
}


state GrenadeAvoidanceState extends MovingState
{
	event ReactToGrenade(
		SASGrenadeProjectile	aGrenade );

	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	// 
	event BeginState()
	{
		Super.BeginState();

		// Set timer to reassess destination safety.
		SetTimer( 0.5, true );
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndState
	// 
	event EndState()
	{
		Super.EndState();
		SetTimer( 0.0, false );
	}


	///////////////////////////////////////////////////////////////////////////////
	// GrenadeExploded
	// 
	event GrenadeExploded(
		SASGrenadeProjectile	aGrenade )
	{
		if ( mNumGrenadesDetected == 0 )
		{
			// TODO: Reassess what to do next.
			ResumeObjective();
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// Timer
	// 
	event Timer()
	{
		local Actor destActor;

		if ( mNumGrenadesDetected == 0 )
		{
			// TODO: Reassess what to do next.
			ResumeObjective();
			return;
		}

		if ( mCoverPoint != None )
		{
			destActor = mCoverPoint;
		}
		else
		{
			destActor = mGrenadeRetreatNavPoint;
		}

		// Reassess if current retreat goal is still viable.
		if ( !IsSafePointFromGrenades( destActor, 0.0 ) )
		{
			GotoState( , 'Begin' );
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// STATE RetreatFromGrenades
//
state RetreatFromGrenades extends GrenadeAvoidanceState
{
	ignores SeePlayer,
			HearNoise,
			DamageAttitudeTo;

	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	// 
	event BeginState()
	{
		Super.BeginState();

		mGrenadeRetreatNavPoint = None;
		RelinquishCoverPoint();

		// Set timer to check for better retreat destination even if current one is ok.
		SetMultiTimer( mTimerReassess, 0.7, true );
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndState
	// 
	event EndState()
	{
		Super.EndState();

		// Set timer to check for better retreat destination even if current one is ok.
		StopMultiTimer( mTimerReassess );
	}


	///////////////////////////////////////////////////////////////////////////////
	// MultiTimer
	// 
	event MultiTimer(
		int	aTimerIdx )
	{
		switch ( aTimerIdx )
		{
		case mTimerReassess:
			UpdateRetreatPoint();
			SetMultiTimer( mTimerReassess, RandRange( 0.85, 1.15 ), true ); 
			break;

		default:
			Super.MultiTimer( aTimerIdx );
			break;
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// GetRetreatPoint
	// 
	function GetRetreatPoint()
	{
		local Actor	point;

		RelinquishCoverPoint();
		mGrenadeRetreatNavPoint = None;

		point = FindGrenadeRetreatPoint();
		if ( point != None )
		{
			if ( SASCoverPoint( point ) != None )
			{
				AcquireCoverPoint( SASCoverPoint( point ) );
			}
			else
			{
				mGrenadeRetreatNavPoint = NavigationPoint( point );
				if ( mGrenadeRetreatNavPoint == None )
				{
					LogHuman( "GetGrenadeRetreatPoint: Unexpected actor type found - "$point );
				}
			}
		}
	}
	

	///////////////////////////////////////////////////////////////////////////////
	// UpdateRetreatPoint
	// 
	function UpdateRetreatPoint()
	{
		local SASCoverPoint		oldCP;
		local NavigationPoint	oldNP;
		local Actor				newDest;

		oldCP = mCoverPoint;
		oldNP = mGrenadeRetreatNavPoint;
	
		GetRetreatPoint();

		// If failed to find a cover point or a retreat tgt nav point then
		// revert to what we were heading to before.
		if ( (mCoverPoint == None) && (mGrenadeRetreatNavPoint == None) )
		{
			if ( (oldCP == None) || !AcquireCoverPoint( oldCP ) )
			{
				mGrenadeRetreatNavPoint = oldNP;
			}
		}

		if ( mCoverPoint != None )
		{
			newDest = mCoverPoint;
		}
		else
		{
			newDest = mGrenadeRetreatNavPoint;
		}

		if ( (newDest == None) || (newDest != mGoalActor) )
		{
			GotoState( , 'RunToRetreatPoint' );
		}
	}

Begin:

	GetRetreatPoint();

RunToRetreatPoint:

	if ( mCoverPoint != None )
	{
		DoMoveToActor( mCoverPoint, mSASPawn.GetMaxPace() );
	}
	else if ( mGrenadeRetreatNavPoint != None )
	{
		DoMoveToActor( mGrenadeRetreatNavPoint, mSASPawn.GetMaxPace() );
	}
	else
	{
		Goto( 'MTP_FinishedMove' );
	}

MTP_FinishedMove:

	if ( mSASPawn.meStance != STANCE_Crouched )
	{
		if ( mSASPawn.PlayStanceTransitionAnim( STANCE_Crouched ) )
		{
			mSASPawn.ChangeStanceImmediate( STANCE_Crouched );
			FinishAnim( ANIMCHANNEL_ACTION );
			mSASPawn.ChangeAnimation();
		}
		else
		{
			mSASPawn.ChangeStanceImmediate( STANCE_Crouched );
		}
	}

CrouchedAtCover:

	// Goto relevant state for AI type for waiting at grenade avoidance point.
	GotoAtGrenadeCoverState();
}



///////////////////////////////////////////////////////////////////////////////
// STATE Scripting
//
state Scripting extends MovingState
{
	///////////////////////////////////////////////////////////////////////////////
	// DisplayDebug
	//
	function DisplayDebug(
		Canvas		aCanvas, 
		out float	aYL, 
		out float	aYPos )
	{
		Global.DisplayDebug( aCanvas, aYL, aYPos );

		mScriptInterface.DisplayDebug( aCanvas, aYL, aYPos );
	}


	///////////////////////////////////////////////////////////////////////////////
	// ShouldStepAsideFor
	//
	function bool ShouldStepAsideFor(
		Actor			aOther,							// Actor to consider avoiding (either a pawn or a mover).
		optional bool	abConsiderStationaryActors )	// If true then consider stepping aside even if other not moving.
	{
		// Only avoid if action allows it.
		if ( mScriptInterface.mCurLatentScriptAction.CanDoAvoidance() )
		{
			return Global.ShouldStepAsideFor( aOther, abConsiderStationaryActors );
		}

		return false;
	}


	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	//
	event BeginState()
	{
		Super.BeginState();

		// Make sure firing timer not running
		SetTimer( 0.0, false );
		StopMultiTimer( mTimerFiring );

		// Make sure we dont have a grenade point otherwise scripting code 
		// uses this to detect if we are doing a grenade throwing action.
		mGrenadePoint = None;
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndState
	//
	event EndState()
	{
		Super.EndState();

		// Ensure animation control returned to pawn when leaving scripting.
		bControlAnimations = false;
		if ( Pawn != None )
		{
			if ( Pawn.Physics == PHYS_RootMotion )
			{
				Pawn.SetPhysics( PHYS_Walking );
			}
		}

		// Stop timers.
		SetTimer( 0.0, false );
		StopMultiTimer( mTimerFiring );
	}


	///////////////////////////////////////////////////////////////////////////////
	// AbortScript
	//
	function AbortScript()
	{
		Warn( Pawn$": Script aborted" );
		LeaveScripting();
	}


	///////////////////////////////////////////////////////////////////////////////
	// MoveToNextAction
	//
	function MoveToNextAction()
	{
		mScriptInterface.ExecuteScript();

		// If a latent action is not pending then script has completed
		if ( /*!IsInState( 'Scripting' ) ||*/ mScriptInterface.FinishedScript() )
		{
			log( Pawn$" finished script" );
			LeaveScripting();
			return;
		}

		if ( !IsInState( 'Scripting' ) )
		{
			LeaveScripting();
			return;
		}

		CheckScriptTimers();

		// Make sure script animation data is cleared if we do not have a scripted
		// animation running.
		if ( mScriptInterface.mScriptAnimAction == None )
		{
			mScriptInterface.ClearScriptAnim( false );
		}

		// A tad hacky:
		// If our grenade point has been setup then do grenade throwing action.
		if ( mGrenadePoint != None )
		{
			// further hackery.
			CompleteLatentAction();

			DoThrowGrenade( 
				mThrowGrenadeType, 
				mGrenadePoint, 
				GetStateName(),
				'ResumeScripting' );
		}
 	}


	///////////////////////////////////////////////////////////////////////////////
	// CheckScriptTimers
	//
	function CheckScriptTimers()
	{
		local float	time;

		if ( mScriptInterface.mbScriptFiring || mScriptInterface.mbEngageWhileScripting )
		{
			SetMultiTimer( mTimerFiring, FIRING_RECHECK_INTERVAL, true );
		}

		// Enable Tick for tick dependant actions.
		if ( mScriptInterface.mCurLatentScriptAction.TickedAction() )
		{
			Enable( 'Tick' );
		}

		// Reenable Timer if turned off by temporarily leaving scripting (for avoidance etc).
		if ( mScriptInterface.mCurLatentScriptAction.CompleteWhenTimer() )
		{
			time = mScriptTimerActionTimeToTrigger - Level.TimeSeconds;
			if ( time <= 0.0 )
			{
				time = 0.01;
			}
			SetTimer( time, false );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// CompleteLatentAction
	//
	function CompleteLatentAction()
	{
		mScriptInterface.mbEngageWhileScripting = false;
		Disable( 'Tick' );

		mScriptInterface.mScriptActionNum++;
		GotoState( 'Scripting', 'Begin' );
	}


	///////////////////////////////////////////////////////////////////////////////
	// Trigger
	//
	// Recieves trigger events with same tag as the controller
	function Trigger( 
		Actor	aOther, 
		Pawn	aEventInstigator )
	{
		if ( mScriptInterface.mCurLatentScriptAction.CompleteWhenTriggered() )
		{
			CompleteLatentAction();
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// Timer
	//
	event Timer()
	{
		if ( mScriptInterface.mCurLatentScriptAction.CompleteWhenTimer() )
		{
			CompleteLatentAction();
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// Tick
	//
	event Tick(
		float	aDeltaTime )
	{
		if ( (mScriptInterface.mCurLatentScriptAction == None) 
			|| !mScriptInterface.mCurLatentScriptAction.StillTicking( mScriptInterface, aDeltaTime ) )
		{
			Disable( 'Tick' );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// AnimEnd
	//
	event AnimEnd(
		int	aChannel )
	{
		if ( aChannel == 0 )
		{
			if ( (mScriptInterface.mScriptAnimAction != None) 
				&& mScriptInterface.mScriptAnimAction.RepeatAction( mScriptInterface ) )
			{
				return;
			}

			mScriptInterface.ClearScriptAnim( false );
		}

		if ( mScriptInterface.mCurLatentScriptAction.CompleteOnAnimEnd( aChannel ) )
		{
			CompleteLatentAction();
		}

		Pawn.AnimEnd( aChannel );
	}


	///////////////////////////////////////////////////////////////////////////////
	// MultiTimer
	//
	event MultiTimer(
		int	aTimerIndex )
	{
		switch ( aTimerIndex )
		{
		case mTimerFiring:

			// Update line of fire checking counter.
			mLineOfFireCounter -= mMultiTimers[mTimerFiring].Interval;

			// Make sure aiming is active if we want it to be.
			mSASPawn.CheckAiming();

			if ( mScriptInterface.mbScriptFiring )
			{
				// Scripted to fire at an object.
				Target = mScriptInterface.mScriptFocus;
				FireWeaponAtTarget( 
					mMultiTimers[mTimerFiring].Interval, 
					SASWeapon( mSASPawn.Weapon ),
					true );
			}
			else if ( mScriptInterface.mbEngageWhileScripting )
			{
				// Scripted to fire at threats while scripting.
				if ( Enemy != None )
				{
					Target = Enemy;
					FireWeaponAtTarget( 
						mMultiTimers[mTimerFiring].Interval, 
						SASWeapon( mSASPawn.Weapon ),
						true );
				}
			}
			else
			{
				StopMultiTimer( mTimerFiring );
				mSASPawn.StopAiming();
			}
			break;

		default:
			Super.MultiTimer( aTimerIndex );
			break;
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// PawnSpawned
	//
	event PawnSpawned(
		SASPawn	aSpawned )
	{
		if ( mScriptInterface.mCurLatentScriptAction.CompleteOnActorSpawned( aSpawned ) )
		{
			CompleteLatentAction();
		}
	}

	
	///////////////////////////////////////////////////////////////////////////////
	// CheckFiring
	//
	function CheckFiring()
	{
		if ( mScriptInterface.mbScriptFiring 
			&& (mScriptInterface.mScriptFiringNumShots > 0) )
		{
			Target = mScriptInterface.mScriptFocus;
			FireWeaponAtTarget( 
				0.0, 
				SASWeapon( mSASPawn.Weapon ),
				true );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyWeaponFired
	//
	// Callback from controller pawns weapon to notify that a single shot has been 
	// fired.
	// Used to track number of shots fired when doing scripted firing.
	function NotifyWeaponFired()
	{
		if ( mScriptInterface.mbScriptFiring 
			&& (mScriptInterface.mScriptFiringNumShots != -1) )
		{
			mScriptInterface.mScriptFiringNumShots--;
			if ( mScriptInterface.mScriptFiringNumShots < 1 )
			{
				mScriptInterface.ClearScriptFiring();

				if ( mScriptInterface.mCurLatentScriptAction.CompleteOnEndFiring() )
				{
					CompleteLatentAction();
				}
			}
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyClipEmpty
	//
	function NotifyClipEmpty()
	{
		// AIController version of function instigates reloading or changing weapon
		// if out of ammo.
		Super(AIController).NotifyClipEmpty();
	}


Begin:

	MoveToNextAction();

Proceed:

	if ( mScriptInterface.mCurLatentScriptAction.MoveToGoal() )
	{
		WaitForLanding();
		SetPhysics( PHYS_Walking );

		if ( mScriptInterface.mScriptMoveTarget == None )
		{
			Warn( "Scripting MoveToGoal action - No move target specified for "$Pawn);
			AbortScript();
			Stop;
		}

		Focus = None;
		mScriptInterface.SetControllerFocus();

		if ( mScriptInterface.mbScriptWalking )
		{
			mSASPawn.SetPace( PACE_Walking );
		}
		else
		{
			mSASPawn.SetPace( PACE_Running );
		}
		DoMoveToActor(
			mScriptInterface.mScriptMoveTarget,
			mSASPawn.mePace,
			/*mSASPawn.meStance*/,
			Focus );

MTP_FinishedMove:

		CompleteLatentAction();
	}
	else if ( mScriptInterface.mCurLatentScriptAction.TurnToGoal() )
	{
		SetPhysics( PHYS_Walking );

		if ( !mScriptInterface.SetControllerFocus() )
		{
			// Maintain current rotation.
			FixCurrentFacing();
		}

		FinishRotation();
		
		CompleteLatentAction();
	}
	else
	{
		StopMoving();

		if ( !mScriptInterface.SetControllerFocus() )
		{
			// Maintain current rotation.
			FixCurrentFacing();
		}
		
		FinishRotation();

		CheckFiring();
	}

	Stop;

ResumeScripting:

	CheckScriptTimers();

	if ( mScriptInterface.mCurLatentScriptAction.ShouldSkipOnScriptResume() )
	{
		CompleteLatentAction();
	}

	if (	(SASTriggeredScriptAction( mScriptInterface.mCurLatentScriptAction ) != None) &&
			SASTriggeredScriptAction( mScriptInterface.mCurLatentScriptAction ).mbTriggered )
	{
		CompleteLatentAction();
	}

	Goto( 'Proceed' );
}


///////////////////////////////////////////////////////////////////////////////
// CanHeadlessChicken
//
function bool CanHeadlessChicken()
{
	// Don't allow stunned/gassed headless chicken move while scripting.
	if ( mScriptInterface.mScript != None )
	{
		return false;
	}

	return true;
}


///////////////////////////////////////////////////////////////////////////////
// STATE Stunned
//
state Stunned
{
	ignores SeePlayer, 
			HearNoise, 
			DamageAttitudeTo,
			EnemyNotVisible,
			NotifyPlayerAboutToBump,
			DoStepAside,
			CanStepAside,
			SeeGrenade,
			ReactToGrenade;

	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	// 
	event BeginState()
	{
		mSASPawn.mbHeadlessChicken = false;
		mbIsAlert = true;

		StopMultiTimer( mTimerReassess );

		// Hack - Make sure timer is running.
		if ( TimerRate == 0.0 )
		{
			SetTimer( 0.1, false );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndState
	// 
	event EndState()
	{
		mSASPawn.EndPlayActionAnim( 0.2 );

		StopMultiTimer( mTimerReassess );
		SetTimer( 0.0, false );

		Enable( 'NotifyBump' );
		Enable( 'NotifyHitWall' );

		mSASPawn.mbStunned = false;
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyBump
	// 
	event bool NotifyBump(
		Actor	aOther )
	{
		// If not stationary react to bump by changing direction
		if ( mSASPawn.mbHeadlessChicken )
		{
			GotoState( , 'HeadlessChickenBump' );
		}

		return false;
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyHitWall
	//
	event bool NotifyHitWall(
		vector	aHitNormal, 
		Actor	aWall )
	{
		NotifyBump( None );
		return false;
	}


	///////////////////////////////////////////////////////////////////////////////
	// AnimEnd
	// 
	event AnimEnd(
		int	aChannel )
	{
		if ( aChannel == ANIMCHANNEL_ACTION )
		{
			if ( !mSASPawn.mbStunned )
			{
				CheckPlayingAnimFromStunned( true );
				GotoState( , 'EndStunned' );
				return;
			}
		}
		
		Pawn.AnimEnd( aChannel );
	}


	///////////////////////////////////////////////////////////////////////////////
	// CheckPlayingAnimFromStunned
	// 
	function bool CheckPlayingAnimFromStunned(
		bool	abAnimEnd )
	{
		local name	transitionAnim,
					curAnim;
		local float	frame,
					rate;

		transitionAnim = mSASPawn.GetTranisitionFromStunnedAnim();
		if ( transitionAnim == 'None' )
		{
			return false;
		}

		mSASPawn.GetAnimParams( ANIMCHANNEL_Action, curAnim, frame, rate );
		if ( curAnim != transitionAnim )
		{
			mSASPawn.AnimateFromStunned();
			return true;
		}

		return !abAnimEnd;
	}


	///////////////////////////////////////////////////////////////////////////////
	// Timer
	// 
	event Timer()
	{
		mSASPawn.mbStunned = false;
		//SetTimer( 0.0, false );
	}


	///////////////////////////////////////////////////////////////////////////////
	// MultiTimer
	//
	event MultiTimer(
		int	aTimerIdx )
	{
		switch ( aTimerIdx )
		{
		case mTimerReassess:
			UpdateHeadlessChickenDest( false, mMultiTimers[mTimerReassess].Interval );
			GotoState( , 'HeadlessChickenWander' );
			break;

		default:
			Global.MultiTimer( aTimerIdx );
			break;
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// CanHeadlessChicken
	//
	function bool CanHeadlessChicken()
	{
		return Global.CanHeadlessChicken();
	}


Begin:

	if ( !mSASPawn.mbStunned )
	{
		ResumeObjective();
		Stop;
	}

	// Stop moving and fix facing direction.
	StopMoving();
	FixCurrentFacing();
	mSASPawn.ChangeStanceImmediate( STANCE_Standing );

	// Randomly decide if can run about. 
	if ( CanHeadlessChicken() && FRand() > 0.35 )
	{
		mSASPawn.mbHeadlessChicken = true;
	}
	else
	{
		mSASPawn.mbHeadlessChicken = false;
	}

	// Transition to stunned anim (fullbody anim if not running about while stunned).
	mSASPawn.AnimateToStunned();

	if ( !mSASPawn.mbHeadlessChicken )
	{
		StopMultiTimer( mTimerReassess );
		Stop;
	}

	// Sleep for random time before moving.
	Sleep( RandRange( 0.4, 0.8 ) );

	InitHeadlessChickenMove();

	mSASPawn.SetPace( PACE_Running );

HeadlessChickenWander:

	// Set timer before changing wander direction.
	SetMultiTimer( mTimerReassess, RandRange( 0.05, 0.1 ), true );

	// Detect for hitting stuff.
	Enable( 'NotifyBump' );
	Enable( 'NotifyHitWall' );

	// Move toward randomly selected location.
	MoveTo( Destination,,, mSASPawn.mePace );
	StopMoving();
	Stop;

HeadlessChickenBump:

	// Stop and pause for a moment before moving trying to move in another direction.

	UpdateHeadlessChickenDest( true, 0.0 );
	StopMoving();

	// Stop choosing wander direction while not moving.
	StopMultiTimer( mTimerReassess );

	// Stop detecting bumps while not moving.
	Disable( 'NotifyBump' );
	Disable( 'NotifyHitWall' );

	if ( !mSASPawn.mbHeadlessChicken )
	{
		// If UpdateHeadlessChickenDest() turned off wandering then stop.
		Stop;
	}

	// Wait for a while before resuming wandering.
	Sleep( RandRange( 0.8, 1.4 ) );

	// Roughly point in direction of travel if not spray firing before resuming wander.
	if ( !mSASPawn.mbSprayFiring || !TryingToFire() )
	{
		SetFocalPoint( Destination );
		FinishRotation( 8192 );	
	}

	Goto( 'HeadlessChickenWander' );

EndStunned:

	// Check playing transition out and wait for its completion before resuming normal AI.
	if ( CheckPlayingAnimFromStunned( false ) )
	{
		FinishAnim( ANIMCHANNEL_ACTION );
	}
	
	// Return to normal AI.
	ResumeObjective();
}


///////////////////////////////////////////////////////////////////////////////
// STATE Gassed
//
state Gassed
{
	ignores SeePlayer, 
			HearNoise, 
			EnemyNotVisible,
			DamageAttitudeTo,
			NotifyPlayerAboutToBump,
			SeeGrenade,
			ReactToGrenade,
			DoStunned,
			DoStepAside,
			CanStepAside;

	
	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	// 
	event BeginState()
	{
		Enemy = None;

		mbIsAlert = true;
		mSASPawn.mbHeadlessChicken = false;

		StopMultiTimer( mTimerReassess );
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndState
	// 
	event EndState()
	{
		StopMoving();

		mSASPawn.mbGassed = false;

		mSASPawn.EndPlayActionAnim( 0.2 );
		mSASPawn.ChangeAnimation ();

		Enable( 'NotifyBump' );
		Enable( 'NotifyHitWall' );
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyBump
	// 
	event bool NotifyBump(
		Actor	aOther )
	{
		// If not stationary react to bump by changing direction
		if ( mSASPawn.mbHeadlessChicken )
		{
			GotoState( , 'HeadlessChickenBump' );
		}

		return false;
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyHitWall
	//
	event bool NotifyHitWall(
		vector	aHitNormal, 
		Actor	aWall )
	{
		NotifyBump( None );
		return false;
	}


	///////////////////////////////////////////////////////////////////////////////
	// AnimEnd
	// 
	event AnimEnd(
		int	aChannel )
	{
		if ( aChannel == ANIMCHANNEL_ACTION)
		{
			if ( !mSASPawn.mbGassed )
			{
				CheckPlayingAnimFromGassed();
				GotoState( , 'EndGassed' );
				return;
			}
		}
		
		Pawn.AnimEnd( aChannel );
	}


	///////////////////////////////////////////////////////////////////////////////
	// DoGassed
	//
	// Reaction to being in CS gas cloud
	function DoGassed (
		float duration)
	{
		local name	curAnim;
		local float	frame,
					rate;

		if ( duration > TimerRate )
		{
			// If mbGassed is false then we are due to end this state once animations
			// have completed. Need to check if should replay the to gassed transition anim.
			if ( !mSASPawn.mbGassed )
			{
				// If currently playing the tranistion from gassed anim then transition back into
				// gassed animation by beginning the state again.
				mSASPawn.GetAnimParams( ANIMCHANNEL_Action, curAnim, frame, rate );
				if ( curAnim == mSASPawn.GetTranisitionFromGassedAnim() )
				{
					GotoState( , 'Begin' );
				}
			}

			mSASPawn.mbGassed = true;
			SetTimer( duration, false );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// CheckPlayingAnimFromGassed
	// 
	function bool CheckPlayingAnimFromGassed()
	{
		local name	transitionAnim,
					curAnim;
		local float	frame,
					rate;

		transitionAnim = mSASPawn.GetTranisitionFromGassedAnim();
		if ( transitionAnim == 'None' )
		{
			return false;
		}

		mSASPawn.GetAnimParams( ANIMCHANNEL_Action, curAnim, frame, rate );
		if ( curAnim != transitionAnim )
		{
			mSASPawn.AnimateFromGassed();
		}

		return true;
	}


	///////////////////////////////////////////////////////////////////////////////
	// Timer
	// 
	event Timer()
	{
		mSASPawn.mbGassed = false;
		SetTimer( 0.0, false );
	}


	///////////////////////////////////////////////////////////////////////////////
	// MultiTimer
	//
	event MultiTimer(
		int	aTimerIdx )
	{
		switch ( aTimerIdx )
		{
		case mTimerReassess:
			UpdateHeadlessChickenDest( false, mMultiTimers[mTimerReassess].Interval );
			GotoState( , 'HeadlessChickenWander' );
			break;

		default:
			Global.MultiTimer( aTimerIdx );
			break;
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// CanHeadlessChicken
	//
	function bool CanHeadlessChicken()
	{
		return Global.CanHeadlessChicken();
	}


Begin:

	if ( !mSASPawn.mbGassed )
	{
		ResumeObjective();
		Stop;
	}

	// Stop moving and fix facing direction.
	StopMoving();
	FixCurrentFacing();
	mSASPawn.ChangeStanceImmediate( STANCE_Standing );

	// Randomly decide to run about.
	if ( CanHeadlessChicken() && (FRand() > 0.35) )
	{
		mSASPawn.mbHeadlessChicken = true;
	}
	else
	{
		mSASPawn.mbHeadlessChicken = false;
	}

	// Transition to stunned anim (fullbody anim if not running about while stunned).
	mSASPawn.AnimateToGassed();

	if ( !mSASPawn.mbHeadlessChicken )
	{
		StopMultiTimer( mTimerReassess );
		Stop;
	}

	// Sleep for random time before moving.
	Sleep( RandRange( 0.4, 0.8 ) );

	InitHeadlessChickenMove();

	// Randomly choose to run or walk.
	mSASPawn.SetPace( PACE_Running );
	

HeadlessChickenWander:

	// Set timer before changing wander direction.
	SetMultiTimer( mTimerReassess, RandRange( 0.05, 0.1 ), true );

	// Detect for hitting stuff.
	Enable( 'NotifyBump' );
	Enable( 'NotifyHitWall' );

	// Move toward randomly selected location.
	MoveTo( Destination,,, mSASPawn.mePace );
	StopMoving();
	Stop;


HeadlessChickenBump:

	// Stop and pause for a moment before moving trying to move in another direction.

	UpdateHeadlessChickenDest( true, 0.0 );
	StopMoving();

	// Stop choosing wander direction while not moving.
	StopMultiTimer( mTimerReassess );

	// Stop detecting bumps while not moving.
	Disable( 'NotifyBump' );
	Disable( 'NotifyHitWall' );

	if ( !mSASPawn.mbHeadlessChicken )
	{
		// If UpdateHeadlessChickenDest() turned off wandering then stop.
		Stop;
	}

	// Wait for a while before resuming wandering.
	Sleep( RandRange( 0.8, 1.4 ) );

	// Roughly point in direction of travel before resuming wander.
	SetFocalPoint( Destination );
	FinishRotation( 8192 );	

	Goto( 'HeadlessChickenWander' );

EndGassed:

	// Check playing transition from gassed anima and wait for it to end.
	if ( CheckPlayingAnimFromGassed() )
	{
		FinishAnim( ANIMCHANNEL_Action );
	}

	// Resume normal AI
	ResumeObjective();
} // state Gassed


///////////////////////////////////////////////////////////////////////////////
// STATE Incapacitated
//
// What happens to characters who have been injured badly enough to be no longer
// combat effective
//
state Incapacitated
{
	ignores SeePlayer,
			SeeDeadBody,
			HearNoise, 
			SeeGrenade,
			NotifyBump,
			NotifyPlayerAboutToBump,
			DoStepAside,
			CanStepAside,
			DoStunned,
			DoGassed,
			ReactToGrenade,
			ServerDoPunchedByPlayer,
			WeaponPointedAt,
			Bump,
			EnemyNotVisible,
			Trigger,
			HitWall,
			HeadVolumeChange,
			PhysicsVolumeChange,
			Falling,
			DamageAttitudeTo,
			DoStaggerBackward;

	function DoIncapacitated (Pawn causedBy);


	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	// 
	event BeginState()
	{
		StopMultiTimer( mTimerReassess );
		mSASPawn.mbIncapCanBeCuffed = false;
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndState
	// 
	event EndState()
	{
		// Switch on collision tests with other pawns
		if ( mSASPawn != None )
		{
			mSASPawn.SetNonZeroExtentTraces( true );
			mSASPawn.bIgnoreSpine = false;
		}
		
		StopMultiTimer( mTimerReassess );
	}


	///////////////////////////////////////////////////////////////////////////////
	// MultiTimer
	// 
	event MultiTimer (int aTimerIdx)
	{
		switch (aTimerIdx)
		{
		case mTimerReassess:
			mSASPawn.PlaySpeech( SPEECH_GenIncapacitated );
			SetMultiTimer( mTimerReassess, RandRange( mSASPawn.mMinIncapTimer, mSASPawn.mMaxIncapTimer ), true );
			break;

		default:
			Global.MultiTimer( aTimerIdx );
			break;
		}
	}

Begin :

	// Attempt to nullify all sorts of things that can make the Pawn act outside of this state
	Enemy = None;
	Target = None;
	Focus = None;

	mGoalActor = None;
	mGoalLocation = Pawn.Location;
	mMovingFocalActor = None;

	mSASPawn.mInterestItem = None;
	mSASPawn.mInterestAngle = 0;
	mSASPawn.mInhibitHeadMovement = true;

	StopRepeatFiring();
	StopMoving ();
	mSASPawn.bDisableTurnAnims = true;

	FindDirectionToGoProne( -4550 );
	mSASPawn.bIgnoreSpine = true;
	SetFocalPointFromDir( mProneFocalDir );

	// Play transition animation.
	if ( mSASPawn.AnimateToIncapacitated() )
	{
		mSASPawn.ZeroMovementChannelBlendAlpha();
		FinishAnim( ANIMCHANNEL_Action );
	}

	mSASPawn.StopAnimating( true );

	// Into prone stance.
	mSASPawn.mbIncapCanBeCuffed = true;
	mSASPawn.ChangeStanceImmediate( STANCE_Prone );
	mSASPawn.ChangeAnimation( true );

	// Switch off collision tests with other pawns
	mSASPawn.SetNonZeroExtentTraces ( false );

	// Set up timer for screaming sounds
	SetMultiTimer( mTimerReassess, RandRange( mSASPawn.mMinIncapTimer, mSASPawn.mMaxIncapTimer ), true );
} 


///////////////////////////////////////////////////////////////////////////////
// STATE Inactive
// 
// State used for AI waiting to be activated (spawned) into level.
state Inactive
{
	ignores SeePlayer,
			HearNoise,
			SeeGrenade,
			ReactToGrenade,
			ReceiveWarning,
			NotifyLanded,
			NotifyPhysicsVolumeChange,
			NotifyHeadVolumeChange,
			NotifyHitWall,
			NotifyBump,
			DoStepAside,
			Trigger,
			DamageAttitudeTo;
}


///////////////////////////////////////////////////////////////////////////////
// STATE WaitingToStart
// 
// Used when waiting for game to start.
state WaitingToStart
{
	ignores SeePlayer,
			HearNoise,
			SeeGrenade,
			ReactToGrenade,
			ReceiveWarning,
			NotifyLanded,
			NotifyPhysicsVolumeChange,
			NotifyHeadVolumeChange,
			NotifyHitWall,
			NotifyBump,
			DoStepAside,
			Trigger,
			DamageAttitudeTo;

	function MatchStarting()
	{
		EnterStartState();
	}
}

state PermanentSleep
{
ignores	GotoState,
		SeePlayer,
		EnemyNotVisible,
		HearNoise,
		ReceiveWarning,
		NotifyLanded,
		NotifyPhysicsVolumeChange,
		NotifyHeadVolumeChange,
		NotifyLanded,
		NotifyHitWall,
		NotifyBump,
		DoStepAside,
		CanStepAside,
		DoStaggerBackward;

	function BeginState ()
	{
		StopMoving ();
		StopRepeatFiring();
		DisableAllSenses ( true );
	}
}

// TODO: move this state into relevent area (MP) ...
state Dead
{
ignores SeePlayer,
		EnemyNotVisible,
		HearNoise,
		ReceiveWarning,
		NotifyLanded,
		NotifyPhysicsVolumeChange,
		NotifyHeadVolumeChange,
		NotifyLanded,
		NotifyHitWall,
		NotifyBump,
		DoStepAside,
		DoStaggerBackward;

	function Timer() {}

	function BeginState()
	{
/*
		if ( (GoalScript != None) && (HoldSpot(GoalScript) == None) )
		{
			FreeScript();
		}
		if ( NavigationPoint(MoveTarget) != None )
		{
			NavigationPoint(MoveTarget).FearCost = 2 * NavigationPoint(MoveTarget).FearCost + 600;
		}
		Enemy = None;
		StopFiring();
		bFrustrated = false;
		BlockedPath = None;
		bInitLifeMessage = false;
		bReachedGatherPoint = false;
		bFinalStretch = false;
		bWasNearObjective = false;
		bPreparingMove = false;
		bEnemyEngaged = false;
		bPursuingFlag = false;
*/
	}
	
Begin:
	if ( Level.Game.bGameEnded )
	{
		GotoState ( 'GameEnded' );
	}
	Sleep ( 0.2 );

TryAgain:
//	if ( SASMPGame.SASMPGameInfo ( Level.Game ) == None )
	if ( SASGameInfo ( Level.Game ) == None )
	{
		destroy ();
	}
	else
	{
//		Sleep ( 0.25 + SASMPGame.SASMPGameInfo ( Level.Game ).SpawnWait ( self ) );
		Sleep ( 0.25 + FRand () );
//		LastRespawnTime = Level.TimeSeconds;
		Level.Game.ReStartPlayer ( self );
		Goto ( 'TryAgain' );
	}
	
MPStart:
	Sleep ( 0.75 + FRand () );
	Level.Game.ReStartPlayer ( self );
	Goto ( 'TryAgain' );
}

///////////////////////////////////////////////////////////////////////////////
//
// STATE rotateToFace
//
// Rotate the character to face his focus or focal point using the large rotation
// anims (Rot90 and Rot180)
//
/*STATE rotateToFace
{
	function BeginState ()
	{
		local Vector direction;
		local Vector targetPoint;
		local Float yawOffset;
		local name anim;

		if (Focus != None)
		{
			targetPoint = Focus.Location;
		} // if
		else
		{
			targetPoint = FocalPoint;
		} // else

		// Work out how far we have to rotate - are we using the 90 or 180 degree anims, CW or CCW ?
		direction = targetPoint - mSASPawn.Location;
		yawOffset = GetYaw (direction) - mSASPawn.Rotation.Yaw;

		if (yawOffset < -DEGREES_180)
		{
			yawOffset += DEGREES_360;
		} // if
		else if (yawOffset > DEGREES_180)
		{
			yawOffset -= DEGREES_360;
		} // if

		// Clockwise)
		if (yawOffset < 0)
		{
			// Very small rotation - don't change anim
			if (yawOffset > Degrees (-20))
			{
			} // if

			// Up to 125 degrees use 90 degree rotation and correct by modifying actual facing
			else if (yawOffset > Degrees (-125))
			{
				anim = mSASPawn.mTurnLeft90Anim;
			} // else if

			// over 125 degrees use 180 rotation
			else
			{
				anim = mSASPawn.mTurnLeft180Anim;
			} // else
		} // if

		// Anti-clockwise
		else
		{
			// Very small rotation - don't change anim
			if (yawOffset < Degrees (20))
			{
			} // if

			// Up to 125 degrees use 90 degree rotation and correct by modifying actual facing
			else if (yawOffset < Degrees (125))
			{
				anim = mSASPawn.mTurnRight90Anim;
			} // else if

			// over 125 degrees use 180 rotation
			else
			{
				anim = mSASPawn.mTurnRight180Anim;
			} // else
		} // else

		if (anim != 'None' && mSASPawn.GetNamedAnimDuration (anim) > 0.0)
		{
			// Stop moving and switch off the automatic physics-based turning
			StopMoving ();
			mSASPawn.bRotateToDesired = false;
			bControlAnimations = true;

			mSASPawn.PlayActionAnim (anim, RandRange (0.9, 1.1), 0.15, false );
			mSASPawn.SetPhysics (PHYS_RootMotion);

//			Pawn.PlayAnim (anim, 1.0, 0.25);
		} // if

		// Can't find anim ? 
		else
		{
			//Warn (" -- can't find anim or no duration");
			GotoState ('Idle');
			return;
		} // else
	} // BeginState

	function EndState ()
	{
		// Switch automatic rotation back on again
		mSASPawn.SetPhysics (PHYS_Walking);
		mSASPawn.EndPlayActionAnim( 0.0 );
		mSASPawn.bRotateToDesired = false;
		bControlAnimations = false;
	} // EndState

	function AnimEnd (int channel)
	{
		if (channel == ANIMCHANNEL_ACTION)
		{
			GotoState ('Idle');
		} // if
		//else
		//{
		//	Pawn.AnimEnd( channel );
		//}
	} // AnimEnd
} // rotateToFace
*/

///////////////////////////////////////////////////////////////////////////////
// STATE Transition
//
state Transition
{
	ignores	SeePlayer,
			HearNoise,
			NotifyBump,
			NotifyPlayerAboutToBump,
			DoStepAside,
			CanStepAside,
			DoStunned,
			DoGassed,
			ReactToGrenade,
			ServerDoPunchedByPlayer,
			CheckCanBePunched,
			WeaponPointedAt,
			DoStaggerBackward;


	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	// 
	event BeginState()
	{
		Enable( 'Tick' );
	}

	///////////////////////////////////////////////////////////////////////////////
	// EndState
	// 
	event EndState()
	{
		Disable( 'Tick' );

		mSASPawn.EndPlayActionAnim( 0.2 );
		mbTransitionRootMotion = false;
	}


	///////////////////////////////////////////////////////////////////////////////
	// CompleteTransition
	//
	event CompleteTransition()
	{
		local bool bNoAnimBlend;

		IgnoreEnemy( mbTransitionReturnIgnoreEnemy );

		mSASPawn.EndPlayActionAnim( 0.2 );
		
		mSASPawn.ChangeStanceImmediate( mTransitionReturnStance );
		if ( mTransitionReturnStance == STANCE_Prone )
		{
			bNoAnimBlend = true;
		}
		mSASPawn.ChangeAnimation( bNoAnimBlend );
		
		GotoState( mTransitionReturnState, mTransitionReturnLabel );
	}


	///////////////////////////////////////////////////////////////////////////////
	// AnimEnd
	//
	event AnimEnd( 
		int aChannel )
	{
		if ( (aChannel == ANIMCHANNEL_ACTION) || (Pawn.GetCurrentAnim( ANIMCHANNEL_ACTION ) == 'None') )
		{
			CompleteTransition();
		}
		else
		{
			mSASPawn.AnimEnd( aChannel );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// Tick
	//
	event Tick(
		float	aDeltaTime )
	{
		local name	AnimName;
		local float	frame,
					rate;

		// For stance change transitions, do the stance change half way through the anim.
		mSASPawn.GetAnimParams( ANIMCHANNEL_Action, animName, frame, rate );
		if ( frame >= 0.5 )
		{
			mSASPawn.ChangeStanceImmediate( mTransitionReturnStance );	
		}
	}


Begin:

	// Blend out hit animation while playing transitions.
	mSASPawn.AnimBlendToAlpha( ANIMCHANNEL_Hit, 0.0, 0.1 );

	// Stop current animation on action channel immediately.
	mSASPawn.EndPlayActionAnim( 0.0 );

	if ( mTransitionAnim != 'None' )
	{
		mSASPawn.AnimBlendParams( ANIMCHANNEL_Action, 1.0, 0.0, 0 );
		mSASPawn.PlayActionAnim( mTransitionAnim, mTransitionAnimRate, 0.15, false );

		if ( mbTransitionRootMotion )
		{
			mSASPawn.SetPhysics( PHYS_RootMotion );
			FinishAnim( ANIMCHANNEL_Action );

			if ( mSASPawn.Physics == PHYS_RootMotion )
			{
				mSASPawn.SetPhysics( PHYS_Walking );
			}
		}
	} 
	else
	{
		CompleteTransition();
	}
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mbCanSee=true
    mbCanHear=true
    mbCanFeelDamage=true
    mCoverReachedTime=-1.0000000
    bIsPlayer=true
    RotationRate=(Pitch=3072,Yaw=65000,Roll=2048)
}