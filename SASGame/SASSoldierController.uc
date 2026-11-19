//=============================================================================
// SASSoldierController.uc
//=============================================================================

class SASSoldierController extends SASFighterController
	native;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

//-----------------------------------------------------------------------------
// Constants

const WINGMAN_TRACKING_DISTANCE				= 64.0;
const WINGMAN_MAX_TRACKING_DIST2D			= 128.0;
const WINGMAN_MAX_ATTACKING_DIST2D			= 900.0;	// ~18m
const WINGMAN_TRACKING_MAX_HEIGHT_DIFF		= 150.0;
const WINGMAN_DP_CAPTURE_THRESHOLD			= 0.3;		// Metres - roughly a foot

const DP_MAX_PLAYER_RANGE_DEFENSIVE			= 300.0;	// ~6m
const DP_MAX_PLAYER_RANGE_OFFENSIVE			= 750.0;	// ~15m

const ROTATION_ANIM_SPEED					= 2.0;

const WEAPON_POINTED_AT_TIMEOUT				= 2.0;

//-----------------------------------------------------------------------------
// Enums

enum ESASSoldierObjective
{
	SASOBJ_Idle,
	SASOBJ_Scripted,
	SASOBJ_LeaveScripted,
	SASOBJ_WingmanTrackPlayer,
	SASOBJ_AttackEnemy,
	SASOBJ_MoveToDP,
	SASOBJ_MoveToFirstDP,
	SASOBJ_StackingUp,
	SASOBJ_DoorBreach,
	SASOBJ_MoveToLocation,
	SASOBJ_ThreatenHostage,
	SASOBJ_Wait
};

//-----------------------------------------------------------------------------
// Structs

struct native SASObjectiveInfo
{
	var ESASSoldierObjective	ObjectiveType;
	var Actor				    TargetPoint;
};

struct native sSASBumpCount
{
	var SASPawn				mBumper;
	var Vector				mMoveTarget;
	var Vector				mBumperLocation;
	var float				mBumpTime;
	var bool				mShouted;
};

//-----------------------------------------------------------------------------
// Member Variables

var SASSoldier		        mSoldier;
var SASSquadManager         mSquadManager;
var bool					mbIsWingman;
var SASObjectiveInfo	    mCurrentObjective;

// Multitimers
var int						mAssaultTimer;
var int						mIdleTimer;
var int						mTargetCheckTimer;
var int						mIgnoreGrenadeTimer;
var int						mMoveReassessTimer;		// Continual reassessment of move targets
var int						mTorchTimer;			// Used to randomly delay switching on / off or torches
var int						mLaserTimer;			// Used to randomly delay switching on / off or torches
var int						mHostageUpdateTimer;	// Regular hostage updates
var int						mWingmanMonitorTimer;	// Wingman uses this to monitor player position
var int						mAttackTimer;			// Used to control double-tap timings
var int						mDelayTimer;			// Timer for delay
var int						mRestoreDoorBumpTimer;
var int						mRestorePawnBumpTimer;
var int						mWingmanStackupIngoreEnemyTimer;

var SASDominationPoint		mDominationPoint;
var bool					mbOnOffensive;			// TEMP: flag to indicate if we are moving to DP in offensive or defensive mode.
var SASMoveTarget			mAssaultPoint;			// TEMP: Until move to vector location is working in MovingState state.
var SASEntryPoint			mGuardingEP;
var SASEntryPoint			mWingmanAvoidEP;
var vector					mWingmanTrackPoint;
var float					mWingmanTrackPointThreshold;
var SASMoveTarget			mPlayerTracker;
var SASDoorMover			mAssaultDoor;
var bool					mBreachFiring;
var int						mDoorShotCount;
var int						mFireShotgunCount;
var SASAssaultVolume		mWingmanStackupIngoreEnemyPlayerAV;

var bool					mOrderAcknowledged;
var SASPawn					mLastWeaponPointedAt;	// Who pointed at us last ?
var float					mLastWeaponPointedTime;	// When last pointed at us ?

var sSASBumpCount			mBumpCount;				// Record of who we've bumped and where

var eSSAStackupMode			mStackupMode;			// Collision cylinder shrunk, change in weapon pose

// Quartering data
var bool					mbQuartering;			// Are we currently quartering?
var float					mQuarteringSpeed;
var float					mQuarteringCurDist;
var int						mQuarteringDir;			// -1 for left, +1 for right
var float					mQuarteringResumeTime;	// 

// Torch control
var () float				mMinTorchDelay;			// Shortest time delay in switching torch
var () float				mMaxTorchDelay;			// Longest time delay
var bool					mbNewTorchState;		// State to switch torch to	
var bool					mbNewLaserState;
// Combat data
var bool					mbInDoubleTap;			// Set when in between double-tap shots
var bool					mWeaponFired;			// Set when first round of double tap has gone
var () float				mMinDoubleTapPause;		// Shortest time pause in firing again
var () float				mMaxDoubleTapPause;		// Longest time pause
var () float				mDoubleTapDelay;		// Delay between the two shots of a double tap

var bool					mNoReassessment;		// We don't reassess our goals - only act on orders

var int						mTimerCounter;

// Sweeping control
var int						mSweepDirection;		// Which extermity of the sweep we're headed for (-1 / +1)
var bool					mbSweptFirstArc;
var bool					mbSweptSecondArc;
var name					mSweepAnim;				// Anim used to sweep DP
var float					mSweepAnimRate;
var bool					mbSweepShortestAngle;	// True if we're allowed to sweep the shortest way
var int						mSweepAngle;			// How far current sweep anim rotates.
var SASDominationPoint		mLastDPSwept;			// If of the last DP we swept

var ESASSoldierObjective	mObjectiveAfterWait;	// What to do after a wait
var Actor					mActorAfterWait;		// What to act on after wait
var bool					mPaused;

var float					mNextExteriorCheck;		// Time 'til we next check for exterior assault point

// Wingman
var vector					mLastFacing;			// Which way is a wingman facing
var vector					mFacingPosition;		// What position was the facing calculated for ?
var ESASStance				mFacingStance;			// What stance was facing calculated for ?
var SASEntryPoint			mWingmanAssaultEP;		// Current EP we're stacking up at / assaulting through
var SASEntryPoint			mWingmanLastAssaultEP;	// Last EP we assaulted
var SASAssaultVolume		mWingmanAssaultVolume;	// Current AV we're assaulting into
var SASMoveTarget			mWingmanInvisibleFriend;	// Used as the other guy in a room assault
var SASDominationPoint		mWingmanIFDP;			// Invisible Friend DP
var SASEntryPoint			mWingmanLastGoEP;		// EP I last shouted go at


// Hostage / terrorist shouting
var SASHostage				mAssignedHostage;		// Hostage we're shouting at
var float					mLastHostageShout;		// Time we last shouted at him
var float					mLastHostageUpdate;		// Time we last started hostage threaten state
var float					mMinHostageShoutInterval;	// Minimum time between shouts
var float					mMaxHostageShoutInterval;	// Maximum time between shouts

var float					mLastTerroristShout;		// Time we last shouted at a terrorist
var float					mMinTerroristShoutInterval;	// Minimum time between shouts
var float					mMaxTerroristShoutInterval;	// Maximum time between shouts

// Simple hearing reaction
var float					mLastNoiseHeardTime;	// Level time of last noise heard
var eNoiseType				mLastNoiseHeardType;	// Type of noise last heard
var Vector					mLastNoiseHeardLocation;	// Position last sound occurred at
var SASPawn					mLastNoiseHeardSource;	// Originator of sound
var float					mNoiseTimeout;			// Time before which noise become 'stale'
var bool					mReactingToSound;		// Are we currently facing a sound point
var Vector					mSoundPoint;			// Point we're staring at

//-----------------------------------------------------------------------------
// Native Functions

native(780) final function BeginQuartering();

native(781) final function EndQuartering();

native(782) final function SASDominationPoint SelectWingmanNextDP(
	optional SASDominationPoint aPrevDP );

native(783) final function CalculateUnobstructedFacing();

native(784) final function SelectTarget();

native function MemTick ();

//-----------------------------------------------------------------------------
// Exec Functions

//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DisplayDebug
//
simulated function DisplayDebug(
	Canvas		aCanvas, 
	out float	aYL, 
	out float	aYPos )
{
	Super.DisplayDebug( aCanvas, aYL, aYPos );

	aCanvas.SetDrawColor( 255,255,255 );

	aCanvas.DrawText( "Squad Manager Details" );
	aYPos += aYL;
	aCanvas.SetPos( 4, aYPos );

	if ( mSquadManager == None )
	{
		aCanvas.DrawText( "mSquadManager == None" );
		aYPos += aYL;
		aCanvas.SetPos( 4, aYPos);
	}
	else
	{
		mSquadManager.DisplayDebug( aCanvas, aYL, aYPos );
	}

	aCanvas.DrawText( "Current Objective Info:" );
	aYPos += aYL;
	aCanvas.SetPos( 4, aYPos);

	aCanvas.DrawText( "  Type = "$ObjectiveTypeToString( mCurrentObjective.ObjectiveType ) );
	aYPos += aYL;
	aCanvas.SetPos( 4, aYPos);

	aCanvas.DrawText( "  TargetPoint = "$mCurrentObjective.TargetPoint.Tag$" ("$mCurrentObjective.TargetPoint.GetDebugName()$") at "$mCurrentObjective.TargetPoint.Location );
	aYPos += aYL;
	aCanvas.SetPos( 4, aYPos );
	
	aCanvas.DrawText( "---END SASSoldierController---" );
	aYPos += aYL;
	aCanvas.SetPos( 4, aYPos );
}


///////////////////////////////////////////////////////////////////////////////
// PostBeginPlay
//
event PostBeginPlay()
{
	Super.PostBeginPlay();

	// TEMP: Moving to vector locations not currently working correctly in MovingState sub-states.
	// Therefore using an actor to move to instead.
	mAssaultPoint = Spawn( class'SASMoveTarget' );

	mTorchTimer				= AddMultiTimer ();
	mLaserTimer				= AddMultiTimer ();
	mAttackTimer			= AddMultiTimer ();
	mAssaultTimer			= AddMultiTimer ();
	mDelayTimer				= AddMultiTimer ();
	mRestoreDoorBumpTimer	= AddMultiTimer ();
	mRestorePawnBumpTimer	= AddMultiTimer ();
	mWingmanMonitorTimer	= AddMultiTimer ();
	mIdleTimer				= AddMultiTimer ();
	mTargetCheckTimer		= AddMultiTimer ();
	mIgnoreGrenadeTimer		= AddMultiTimer ();
	mHostageUpdateTimer		= AddMultiTimer ();
	mMoveReassessTimer		= AddMultiTimer ();
	mWingmanStackupIngoreEnemyTimer = AddMultiTimer();
}


///////////////////////////////////////////////////////////////////////////////
// DoIncapacitated
//
function DoIncapacitated(
	Pawn	aCausedBy )
{
	mSquadManager.AISquadMemberIncapacitated( mSoldier );
	EndQuartering();
	Super.DoIncapacitated( aCausedBy );
}


///////////////////////////////////////////////////////////////////////////////
// ChangeTeam
//
function ChangeTeam ( int aTeamID, bool aBool )
{
	SASGameInfo ( Level.Game ).ChangeTeam ( self, aTeamID, aBool );
}


///////////////////////////////////////////////////////////////////////////////
// InitSquadManager
//
function InitSquadManager()
{
	// Find the SASSquadManager
	foreach AllActors( class'SASSquadManager', mSquadManager )
	{ 
		break;
	}
}


///////////////////////////////////////////////////////////////////////////////
// AddToSquadManager
//
function AddToSquadManager()
{
	InitSquadManager ();
	mSquadManager.AddAISquadMember( mSoldier );
}


///////////////////////////////////////////////////////////////////////////////
// Possess
//
function Possess(
	Pawn aPawn )
{
	mSoldier = SASSoldier(aPawn);

	if (mSoldier == None)
	{
		warn ("SASSoldier.Possess: Possessed pawn is not an SASSoldier.");
		return;
	}

	// Init sight flags to see terrorists and hostages
	SetSightFlags( SIGHT_Terrorists|SIGHT_Hostages );

	// Only hear noises instigated by terrorists.
	SetHearingFlags( HEAR_Terrorists|HEAR_Hostages|HEAR_CombatEnemy|HEAR_Doors );

	// By default we always step aside for soldiers and will also step aside for
	// hostages when in low priority action.
	SetStepAsidePawnTypes( PAWN_Soldier, PAWN_Hostage );

	AddToSquadManager();

	Super.Possess( aPawn );

	aPawn.SetPace( PACE_Walking );
}


///////////////////////////////////////////////////////////////////////////////
// EnterStartState
//
simulated function EnterStartState()
{
	SetObjective( SASOBJ_Idle, None );
}


///////////////////////////////////////////////////////////////////////////////
// PawnDied
//
function PawnDied ( Pawn P )
{
	if ( mSASPawn != P )
	{
		return;
	}

	RelinquishDominationPoint();

	// Notify the Squad manager that we're dead.
	mSquadManager.AISquadMemberDied( mSoldier );

	Super.PawnDied( P );
}


///////////////////////////////////////////////////////////////////////////////
// AssignWingman
//
event AssignWingman()
{
	RelinquishDominationPoint();
	SetObjective( SASOBJ_Idle, None );
	SetMultiTimer( mWingmanMonitorTimer, 0.25, true );
	mbIsWingman = true;

	// We'll need this as wingman.
	if ( mPlayerTracker == None )
	{
		mPlayerTracker = Spawn( class'SASMoveTarget' );
	}
}


///////////////////////////////////////////////////////////////////////////////
// UnassignWingman
//
function UnassignWingman()
{
	SetObjective ( SASOBJ_Idle, None );
	mbIsWingman = false;
	mWingmanAssaultEP = None;
	mWingmanAssaultVolume = None;
	stopMultiTimer (mWingmanMonitorTimer);
}


///////////////////////////////////////////////////////////////////////////////
// HandleChangeToScripting
//
// Called just before switching to scripting state to allow controller to 
// do anything it need to ready itself for scripting (e.g. Store state to return
// to after script has completed).
function HandleChangeToScripting()
{
	SetObjective( SASOBJ_Scripted, None );
}


///////////////////////////////////////////////////////////////////////////////
// IgnorePawnBumps
//
// Ignore bump events from pawns for the specified period.
function IgnorePawnBumps(
	float	aDuration )
{
	mbIgnorePawnBump = true;
	SetMultiTimer( mRestorePawnBumpTimer, aDuration, false );
}


///////////////////////////////////////////////////////////////////////////////
// IgnoreDoorBumps
//
// Ignore bump events from doors for the specified period.
function IgnoreDoorBumps(
	float	aDuration )
{
	mbIgnoreDoorBump = true;
	SetMultiTimer( mRestoreDoorBumpTimer, aDuration, false );
}


///////////////////////////////////////////////////////////////////////////////
// NotifyDoorOpening
//
function NotifyDoorOpening(
	SASDoorMover	aDoor,
	Pawn			aOpener )
{
	// If I am a wingman and the opener is the wingman's player then 
	// temporarily stop attacking if not currently assaulting.
	if (	mbIsWingman && 
			aOpener == mSquadManager.GetWingmansPlayer( mSoldier ) &&
			mWingmanAssaultEP != None )
	{
		// Ignore the enemy for a short time and note which AV the player is in. If the 
		// player is still in the same AV after the time has expired then re-enable attacking.
		IgnoreEnemy( true );
		mWingmanStackupIngoreEnemyPlayerAV = mSquadManager.GetWingmansPlayer( mSoldier ).GetAssaultVolume();
		SetMultiTimer( mWingmanStackupIngoreEnemyTimer, 2.5, false );
	}
}


///////////////////////////////////////////////////////////////////////////////
// ChargeBumpedTerrorist
//
// Event received when bumping a terrorist when moving at charging pace.
function ChargeBumpedTerrorist(
	SASTerrorist	aTerrorist )
{
}


///////////////////////////////////////////////////////////////////////////////
// SetStackupMode
//
// Go into or out of stackup mode
function SetStackupMode(
	eSSAStackupMode		aNewMode )
{
	mStackupMode = aNewMode;

	switch ( aNewMode )
	{
		case SASSTACK_None :
			mSoldier.setCollisionSize (mSoldier.default.CollisionRadius, mSoldier.CollisionHeight);
			mSoldier.DestinationOffset = 0.0;
			break;

		case SASSTACK_One :
		case SASSTACK_Two :
			mSoldier.setCollisionSize (mSoldier.default.CollisionRadius / 2, mSoldier.CollisionHeight);
			mSoldier.DestinationOffset = mSoldier.default.CollisionRadius / 2;
			break;
	}
}


///////////////////////////////////////////////////////////////////////////////
// LeaveScripting
//
// Called when leaving scriting state to allow controller to switch to correct
// follow-on action.
function LeaveScripting()
{
	Super.LeaveScripting();
	SetObjective( SASOBJ_LeaveScripted, None );
}


///////////////////////////////////////////////////////////////////////////////
// ResetPitchAnimation
//
function ResetPitchAnimation()
{
	mSoldier.mDesiredAimPitch = 0;
	mSoldier.mAimPitch = 0;
	mSoldier.AnimBlendParams( ANIMCHANNEL_AIMING, 0.0, 0.0, 0, FIRING_BLENDBONE, true );
} 


///////////////////////////////////////////////////////////////////////////////
// CheckFocusTarget
//
// Check to see if our focus is a pawn and if so make sure he's alive. 
// If not, NULL him out.
function CheckFocusTarget()
{
	local SASPawn focalPawn;

	if ( Focus != None )
	{
		focalPawn = SASPawn( Focus );
	}

	// Only check on pawns.
	if ( focalPawn == None )
	{
		return;
	}

	// No longer a valid target if dead, incapacitated or out of sight (unless in our volume).
	if (	(focalPawn.Health <= 0) ||
			focalPawn.mbIsIncapacitated ||
			((focalPawn.GetAssaultVolume() != mSoldier.GetAssaultVolume()) && !mSoldier.PawnIsVisible( focalPawn )) )
	{
		if (mMovingFocalActor == Focus)
		{
			mMovingFocalActor = None;		// Have to catch the resets caused when moving
		}
		Focus = None;
	}
}


///////////////////////////////////////////////////////////////////////////////
// SetObjective
//
event SetObjective(	
	ESASSoldierObjective	aObjectiveType,
	Actor					aTargetActor )
{
	// Can't do any of this if incapacitated
	if ( IsIncapacitated() )
	{
		return;
	}

	if (	(mCurrentObjective.ObjectiveType == SASOBJ_Scripted) && 
			(aObjectiveType != SASOBJ_LeaveScripted) )
	{
		return;
	}

	CheckFocusTarget();

	//SetStackupMode (SASSTACK_None);

	switch( aObjectiveType )
	{
	case SASOBJ_Idle:
		//stackTrace ('AIDebug');
		mCurrentObjective.ObjectiveType = aObjectiveType;
		mCurrentObjective.TargetPoint = self;
		GotoState( 'Idle' );
		break;

	case SASOBJ_Scripted:
		RelinquishDominationPoint();
		SetStackupMode (SASSTACK_None);
		mCurrentObjective.ObjectiveType = aObjectiveType;
		mCurrentObjective.TargetPoint = self;
		GotoState( '' );
		break;

	case SASOBJ_LeaveScripted:
		mCurrentObjective.ObjectiveType = aObjectiveType;
		mCurrentObjective.TargetPoint = self;
		GotoState( 'Idle' );
		break;

	case SASOBJ_AttackEnemy:
		mCurrentObjective.ObjectiveType = aObjectiveType;
		mCurrentObjective.TargetPoint = aTargetActor;
		SetEnemy (aTargetActor);
		mSquadManager.notifyEngagingEnemy (mSoldier);
		GotoState('Attacking');
		break;

	case SASOBJ_WingmanTrackPlayer:
		SetStackupMode (SASSTACK_None);
		resetPitchAnimation	();
		RelinquishDominationPoint();
		mCurrentObjective.ObjectiveType = aObjectiveType;
		mCurrentObjective.TargetPoint = self;
		GotoState('WingmanTrackPlayer');
		break;

	case SASOBJ_MoveToFirstDP:
		//nobreak

	case SASOBJ_MoveToDP:
		
		if (mDominationPoint == None)
		{
			LogHuman ("Soldier " $Pawn$ " (SASOBJ_MoveToDP) has no DP");
			stackTrace ();
			return;
		} // if
		SetStackupMode (SASSTACK_None);
		resetPitchAnimation	();
		mCurrentObjective.ObjectiveType = aObjectiveType;
		mCurrentObjective.TargetPoint = mDominationPoint;
		EndQuartering ();
		GotoState('MovingToDominationPoint');
		break;

	case SASOBJ_StackingUp:
		SetStackupMode (SASSTACK_None);
		resetPitchAnimation	();
		RelinquishDominationPoint();
		mCurrentObjective.ObjectiveType = aObjectiveType;
		mCurrentObjective.TargetPoint = aTargetActor;
		GotoState( 'StackingUp' );
		break;

	case SASOBJ_DoorBreach:
		SetStackupMode (SASSTACK_None);
		resetPitchAnimation	();
		RelinquishDominationPoint ();
		mCurrentObjective.ObjectiveType = aObjectiveType;
		mCurrentObjective.TargetPoint = aTargetActor;
		GotoState( 'BreachDoor' );
		break;

	case SASOBJ_MoveToLocation:
		if (aTargetActor.Location == Vect (0, 0, 0))
		{
			LogHuman ("Soldier " $Pawn$ " (SASOBJ_MoveToLocation) has move target at " $aTargetActor.Location);
			stackTrace ();
			return;
		} // if
		SetStackupMode (SASSTACK_None);
		resetPitchAnimation	();
		RelinquishDominationPoint ();
		mCurrentObjective.ObjectiveType = aObjectiveType;
		mCurrentObjective.TargetPoint = aTargetActor;
		GotoState ('MoveToLocation');
		break;

	case SASOBJ_ThreatenHostage :
		mAssignedHostage = SASHostage (aTargetActor);
		GotoState ('ThreatenHostage');
		break;

	case SASOBJ_Wait :
		resetPitchAnimation	();
		GotoState ('Wait');
		break;
	}
}


///////////////////////////////////////////////////////////////////////////////
// SetObjectiveAfterDelay
//
function SetObjectiveAfterDelay(
	ESASSoldierObjective	aObjectiveType,
	optional Actor			aTargetActor,
	optional float			aDelay )
{
	if ( aDelay == 0.0 )
	{
		SetObjective (aObjectiveType, target);
	} 
	else
	{
		SetMultiTimer( mDelayTimer, aDelay, false );
		mObjectiveAfterWait = aObjectiveType;
		mActorAfterWait = aTargetActor;

		SetObjective( SASOBJ_Wait, None );
	}
}


///////////////////////////////////////////////////////////////////////////////
// GetObjective
// 
function ESASSoldierObjective GetObjective()
{
	return mCurrentObjective.ObjectiveType;
}


///////////////////////////////////////////////////////////////////////////////
// ResumeObjective
//
event ResumeObjective()
{
	local ESASSoldierObjective nextObjective;

	if ( ResumeScripting() )
	{
		return;
	}
	else if ( GetObjective() == SASOBJ_Scripted )
	{
		nextObjective = SASOBJ_LeaveScripted;
	}
	else
	{
		nextObjective = SASOBJ_Idle;
	}

	SetObjective( nextObjective, None );
}


///////////////////////////////////////////////////////////////////////////////
// ObjectiveTypeToString
//
function String ObjectiveTypeToString( 
	ESASSoldierObjective	aObjectiveType )
{
	switch ( aObjectiveType )
	{
		case SASOBJ_Idle:
			return "SASOBJ_Idle";

		case SASOBJ_Scripted:
			return "SASOBJ_Scripted";

		case SASOBJ_LeaveScripted:
			return "SASOBJ_LeaveScripted";

		case SASOBJ_WingmanTrackPlayer:
			return "SASOBJ_WingmanTrackPlayer";

		case SASOBJ_AttackEnemy:
			return "SASOBJ_AttackEnemy";

		case SASOBJ_MoveToDP:
			return "SASOBJ_MoveToDP";

		case SASOBJ_MoveToFirstDP:
			return "SASOBJ_MoveToFirstDP";

		case SASOBJ_StackingUp:
			return "SASOBJ_StackingUp";

		case SASOBJ_DoorBreach:
			return "SASOBJ_DoorBreach";

		case SASOBJ_MoveToLocation:
			return "SASOBJ_MoveToLocation";

		default:
			return "UNKNOWN";
	}
}


///////////////////////////////////////////////////////////////////////////////
// SeePlayer
// 
event SeePlayer( 
	Pawn aSeenPlayer )
{
	local SASPawn	seenSASPawn;

	if ( IsIncapacitated() || mbIgnoreEnemy )
	{
		return;
	}

	seenSASPawn = SASPawn( aSeenPlayer );
	if (	(seenSASPawn != None) && 
			(seenSASPawn.Controller != None) &&
			mSASPawn.IsAThreat( seenSASPawn ) )
	{
		// Report seen terrorist to squad.
		mSquadManager.UpdateSquadThreatInfo( seenSASPawn, self );
	}
}


///////////////////////////////////////////////////////////////////////////////
// SeeSASTarget
// 
event SeeSASTarget(
	SASTarget aSeenTarget )
{
	if ( IsIncapacitated() || mbIgnoreEnemy )
	{
		return;
	}

	// Ignore it if it's not in the same AV.
	if (	SASGameInfo( Level.Game ).GetEncompassingAssaultVolume( aSeenTarget.Location ) != 
			mSoldier.GetAssaultVolume() )
	{
		return;
	}

	// Report seen target to squad.
	mSquadManager.UpdateSquadThreatInfo( aSeenTarget, self );
}


///////////////////////////////////////////////////////////////////////////////
// EnemyNotVisible
//
// Basic functionality - set Enemy (and Target if that's the same) to None
event EnemyNotVisible()
{
	if ( Target == Enemy )
	{
		Target = None;
	} 
	TargetLost ();
	Enemy = None;
}


///////////////////////////////////////////////////////////////////////////////
// HearNoise
//
// Since the player has control over the primary actions of the SAS, they will
// not go running off after stray noises when they hear them. Instead, they
// simply turn to face noises if they have nothing better to do.
//
// Last noise hear is stored together with a time that it occurred. They will
// turn to face the source of the noise (or the nearest EP if it's in another
// volume) for a fixed period. If nothing appears in that time then they will
// go back to their default facing.
event HearNoise(
	 float			aLoudness,					// Loudness level of noise (0.0->1.0)
	 Actor			aNoiseInstigator,			// Noise making actor
	 ENoiseType		aeNoiseType, 				// Type of noise
	 Vector			aNoiseLoc )					// Noise Location
{
	local SASPawn	heardPawn;

	heardPawn = SASPawn( aNoiseInstigator );
	if (	heardPawn == None ||
			(heardPawn.mPawnType != PAWN_Terrorist && heardPawn.mPawnType != PAWN_Hostage) )
	{
		return;
	}

	// Ignore sounds caused by visible hostages
	//if (SASHostage (aNoiseInstigator) != None && mSoldier.pawnIsVisible (Pawn (aNoiseInstigator)))
	//{
	//	return;
	//} 

	// Report to the squad manager who assigns who listens to what
	if ( (aeNoiseType >= mLastNoiseHeardType) || ((Level.TimeSeconds - mLastNoiseHeardTime) > mNoiseTimeout) )
	{
		mLastNoiseHeardTime		= Level.TimeSeconds;
		mLastNoiseHeardType		= aeNoiseType;
		mLastNoiseHeardLocation = aNoiseLoc;
		mLastNoiseHeardSource	= heardPawn;
	} 
} 


///////////////////////////////////////////////////////////////////////////////
// DamageAttitudeTo
// 
// Called on taking damage.
function DamageAttitudeTo(
	Pawn	aDamageInstigator,			// Pawn that damaged us (eg. Pawn that fired the weapon) 
	float	aDamage )					// Damage amount
{
	local SASPawn	sasDamager;

	Super.DamageAttitudeTo( aDamageInstigator, aDamage );

	if ( IsIncapacitated() || mbIgnoreEnemy )
	{
		return;
	}

	sasDamager = SASPawn( aDamageInstigator );
	if ( (sasDamager != None) && mSoldier.IsAThreat( sasDamager ) )
	{
		// Report threat to squad.
		mSquadManager.UpdateSquadThreatInfo( sasDamager, self );
	}
}


///////////////////////////////////////////////////////////////////////////////
// RequestWeaponPose
//
// Returns the weapon pose the pawn should be using.
simulated function EWpnHoldingPose RequestWeaponPose()
{
	// If stacking up then used ported pose.
	if ( !TryingToFire() )
	{
		if ( mStackupMode == SASSTACK_One )
		{
			return WPNPOSE_PortedStackup;
		} 
		else if ( mStackupMode == SASSTACK_Two )
		{
			return WPNPOSE_Aimed;
		}
	}
	
	return Super.RequestWeaponPose();
}


///////////////////////////////////////////////////////////////////////////////
// AcquireDominationPoint
//
function bool AcquireDominationPoint(
	SASDominationPoint	aDP )
{
	// Ignore if this is our DP.
	if ( aDP == mDominationPoint )
	{
		return true;
	}

	// Give up current DP.
	RelinquishDominationPoint();

	if ( aDP != None )
	{
		if ( aDP.Acquire( Pawn ) )
		{
			mDominationPoint = aDP;
			return true;
		}
	}

	return false;
}


///////////////////////////////////////////////////////////////////////////////
// RelinquishDominationPoint
//
function RelinquishDominationPoint()
{
	if ( mDominationPoint != None )
	{
		mDominationPoint.Relinquish( Pawn );
		mDominationPoint = None;
	}
}


///////////////////////////////////////////////////////////////////////////////
// If we're close enough to our DP, set our facing from it. Otherwise choose an unobstructed
// facing
//
// Also check to see what stance we should adopt
function setFacingAndStance ()
{
	local vector FollowWaitDir;
	local name angleAnim;
	local SASAssaultVolume AV, noiseAV;
	local SASEntryPoint EP;

	// Stance - do this first as some facing clauses exit out of the function without getting to the end
	if ( Level.TimeSeconds < (mLastWeaponPointedTime + WEAPON_POINTED_AT_TIMEOUT) && weaponIsPointedAt ())
	{
		mSoldier.ChangeStanceImmediate (STANCE_Crouched);
	} // if
	else
	{
		if (mDominationPoint != None)
		{
			mSoldier.ChangeStanceImmediate (mDominationPoint.meStance);
		} // if
		else
		{
			mSoldier.ChangeStanceImmediate (STANCE_Standing);
		} // else
	} // else

	ignoreEnemy (false);

	// Check for noises
	mReactingToSound = false;

	// Check validity of current sound
	if (mLastNoiseHeardSource != None && 
		(mLastNoiseHeardSource.isDead () ||
		mLastNoiseHeardSource.mbIsIncapacitated))
	{
		mLastNoiseHeardLocation = Vect (0, 0, 0);
		mLastNoiseHeardSource = None;
	} // if

	if (/*(getLevelTime () - mLastNoiseHeardTime) < mNoiseTimeout &&*/
		mLastNoiseHeardLocation != Vect (0, 0, 0))
	{
		AV = mSoldier.getAssaultVolume ();
		mReactingToSound = true;

		// Point is within our assault volume ?
		if (AV.EncompassesPoint (mLastNoiseHeardLocation))
		{
			// Face the point
			SetFocalPoint (mLastNoiseHeardLocation);
			mSoundPoint = mLastNoiseHeardLocation;
		} // if

		// Point within neighbouring volume
		else
		{
			noiseAV = AV.IsPointWithinConnectedVolume (mLastNoiseHeardLocation);
			if (noiseAV != None)
			{
				// Find closest neighbouring EP to sound
				mAssaultPoint.SetLocation (mLastNoiseHeardLocation);		// Won't be using assault point if we are stationary
				EP = AV.GetClosestSharedEntryPoint (mAssaultPoint, noiseAV);
				mSoundPoint = EP.Location;
				mReactingToSound = true;

				// Face EP
				Focus = EP;
				return;
			} // if

			// Remove sound (otherwise we end up looking at very old sounds as we run round)
			else
			{
				mLastNoiseHeardLocation = Vect (0, 0, 0);
				mLastNoiseHeardSource = None;
			} // else
		} // else
	} // if

	// *TBD* - check for uncleared EPs

	if (mDominationPoint != None && VSizeHorizSq (mDominationPoint.Location - mSoldier.Location) < Square (mSoldier.default.CollisionRadius))
	{
		SetFocalPointFromDir (mDominationPoint.mDirection2D);

		// Check for up / down angles at DPs
		if (mDominationPoint.mLookAngle != LOOK_ANGLE_NORMAL)
		{
			if (mDominationPoint.mLookAngle == LOOK_ANGLE_UP)
			{
				angleAnim = mSoldier.GetAimWeaponAnimName( -1 );

				if (angleAnim != 'None')
				{
					mSoldier.mDesiredAimPitch = -mSoldier.MAX_AIM_PITCH;
					mSoldier.mAimPitch = -mSoldier.MAX_AIM_PITCH;
				} // if
			} // if
			else
			{
				angleAnim = mSoldier.GetAimWeaponAnimName( 1 );

				if (angleAnim != 'None')
				{
					mSoldier.mDesiredAimPitch = mSoldier.MAX_AIM_PITCH;
					mSoldier.mAimPitch = mSoldier.MAX_AIM_PITCH;
				} // if
			} // else

			if (angleAnim != 'None')
			{
				mSoldier.AnimBlendParams (ANIMCHANNEL_AIMING, 1.0, 0.0, 0, FIRING_BLENDBONE, true);
				mSoldier.LoopIfNeeded (angleAnim, 0.0, 0.0, ANIMCHANNEL_AIMING);
			} // if
			else
			{
				AnimBlendToAlpha( ANIMCHANNEL_AIMING, 0, 0.2 );
			} // else
		} // if
		else
		{
			resetPitchAnimation	();
		} // else
	} // if
	else if (!mbIsWingman && mSquadManager.mBackupSquadMode == BSM_INTERIOR_FOLLOW)
	{
		mSquadManager.getFollowWaitDirection (mSoldier, FollowWaitDir);
		setFacingAtPoint (mAssaultPoint.Location, FollowWaitDir);

		resetPitchAnimation	();
	} // else
	else
	{
		setUnobstructedFacing ();

		resetPitchAnimation	();
	} // else

	// *TBD* Fix this
	BeginQuartering();
} //  setFacingAndStance


///////////////////////////////////////////////////////////////////////////////
// CheckWeaponAndAmmo
//
// Check that we have our primary weapon selected, if not, switch to it
// Check that the weapon has sufficient ammo remaining
//
// This is to be called when unthreatened by enemies.
//
// Returns TRUE if we take any action, FALSE otherwise.
function bool checkWeaponAndAmmo ()
{
	local SASWeapon wpn,
					otherWpn;

	if ( IsIncapacitated() )
	{
		return false;
	}

	// Ignore if weapon is not idle.
	wpn = SASWeapon( mSoldier.Weapon );
	if ( !wpn.IsIdle() )
	{
		return false;
	}

	// If our current weapon is not our primary weapon, and the primary weapon has the minimum
	// amount of ammo remaining, select it
	if ( wpn.mCategory != WPNCAT_Primary )
 	{
		otherWpn = mSoldier.getWeaponOfCategory( WPNCAT_Primary );
		if ( otherWpn != None && otherWpn.HasAmmo() )
		{
			mSoldier.SelectWeapon( WPNCAT_Primary );
			return true;
		}
	}

	// If our current weapon has less than our minimum number of rounds, change the mag.
	if (	wpn.UsesAmmo && 
			(wpn.mNumInMag <= wpn.mReloadLevel) &&
			(wpn.AmmoType.AmmoAmount > wpn.mNumInMag) )
	{
		mSoldier.Weapon.Reload();
		return true;
	} 

	return false;
}

///////////////////////////////////////////////////////////////////////////////
// DoDefaultStationaryBehaviour
//
// This is what we do when standing at a captured DP with no enemies in sight.
//
// 1) Check to see if there any hostages we can harass.
// 2) Check the state of our weapons and ammo.
// 3) Take up the direction and stance of the DP.
//
// This is used in so many places (especially in idle::chooseAction) that it's
// worthwhile moving it out so that behaviour is consistent at all DPs
function doDefaultStationaryBehaviour (optional bool ignoreWeapon)
{
	StopMoving ();

	if (checkForHostage ())
	{
		return;
	} // if 

	if (!ignoreWeapon && CheckWeaponAndAmmo ())
	{
		return;
	} // if

	setFacingAndStance ();
} // if

///////////////////////////////////////////////////////////////////////////////
// If we're close enough to the defined point, use the supplied vector for our facing, otherwise
// choose an unobstructed view
function setFacingAtPoint (Vector point, Vector facing)
{
	if (point != Vect (0,0,0) && VSizeHorizSq (point - mSoldier.Location) < Square (mSoldier.default.CollisionRadius))
	{
		SetFocalPointFromDir (facing);
	} // if
	else
	{
		setUnobstructedFacing ();
	} // else
} //  setFacingAtPoint


///////////////////////////////////////////////////////////////////////////////
// IsIdle
event bool IsIdle()
{
	return false;
}


///////////////////////////////////////////////////////////////////////////////
// DoStackUp
//
event bool DoStackUp()
{
	local Vector stackUpLoc;

	if ( IsIncapacitated() )
	{
		return false;
	}

	if ( CheckForTargets() )
	{
		mSASPawn.PlayDelayedSpeech( SPEECH_SquadAcknowledgeNo, false );
		return false;
	}

	if ( mSquadManager.GetStackUpLocation( mSoldier, stackUpLoc ) )
	{
		EndQuartering();
		mAssaultPoint.SetLocation( stackUpLoc );
		SetObjective( SASOBJ_StackingUp, mAssaultPoint );
		if ( !mOrderAcknowledged )
		{
			mSASPawn.PlayDelayedSpeech( SPEECH_SquadAcknowledgeYes, false );
		} 
		mOrderAcknowledged = true;
		return true;
	}
	else
	{
		mSoldier.PlaySpeech( SPEECH_SquadAcknowledgeNo );
		return false;
	}
}


function bool IsStackingUp()
{
	return false;
}


///////////////////////////////////////////////////////////////////////////////
// Stop
//
// Stand idle at current position. Calling function is expected to handle setting up
// of suitable position.
function Stop()
{
	if (IsIncapacitated ())
	{
		return;
	}

	StopMoving();
	SetObjective (SASOBJ_Idle, None);
}

//------------------------------------------------------------------------------
//
// FUNCTION doMoveToDP
//
// Order move to DP. Can cope with DP of None, simply reverts to default
// stationary behaviour
function bool doMoveToDP (SASDominationPoint DP, optional float delay)
{
	if (IsIncapacitated ())
	{
		return false;
	} // if

	if (DP == None || !AcquireDominationPoint (DP))
	{
		doDefaultStationaryBehaviour ();
		return false;
	} // if

	// If this is a position we've tried to reach before but were blocked, check to see if the obstruction is still there
	if (VSizeSq (DP.Location - mBumpCount.mMoveTarget) < 16 &&
		VSizeSq (mBumpCount.mBumper.Location - mBumpCount.mBumperLocation) < 64)
	{
		return false;
	} // if

	if (!mSoldier.ReachedDestination (DP))
	{
		SetObjectiveAfterDelay (SASOBJ_MoveToDP, None, delay);
	} // if
	else
	{
		doDefaultStationaryBehaviour ();
	} // else

	return true;
} // doMoveToDP


state MovingState
{
	//------------------------------------------------------------------------------
	//
	function DoMoveToActor(
		Actor						aGoalActor,		// Goal actor to move to.
		optional ESASPace			aePace,			// Movement pace (defaults to running
		optional ESASStance			aeStance,		// Stance (defaults to normal standing).
		optional Actor				aFocalActor,	// Focal actor during move.
		optional Vector				aFocalPoint,	// Focal point during move.
		optional float				aDestOffset,	// Destination offset
		optional bool				abPreciseReachGoal, 	// If true, must be precise on reaching goal location.
		optional SASAssaultVolume	aAvoidVolume )			// Assault volume to avoid moving through. 
	{
		local SASAssaultVolume	avoidVolume;

		// If this is a position we've tried to reach before but were blocked, check to see if the obstruction is still there
		if ( !IsInState( 'StackingUp' ) &&
			VSizeSq (aGoalActor.Location - mBumpCount.mMoveTarget) < 16 &&
			VSizeSq (mBumpCount.mBumper.Location - mBumpCount.mBumperLocation) < 64)
		{
			mbFailedMoveToPoint = true;
			StopMoving();
			return;
		}

		if ( aAvoidVolume == None )
		{
			if ( !mSquadManager.CheckCanPathThroughBackupAssaultVolume( mSoldier ) )
			{
				avoidVolume = mSquadManager.mAssaultVolume;
			}
		}

		Super.DoMoveToActor (aGoalActor, aePace, aeStance, aFocalActor, aFocalPoint, aDestOffset, abPreciseReachGoal, avoidVolume );
	}
}



///////////////////////////////////////////////////////////////////////////////
// CallRoomClear
//
function CallRoomClear(
	optional bool bDelay )
{	
	local SASAssaultVolume	myAV;
	
	// Can't do any of this if incapacitated
	if ( IsIncapacitated() )
	{
		return;
	} 

	myAV = mSoldier.GetAssaultVolume();

	if ( bDelay )
	{
		if ( myAV != None && !myAV.mLargeVolume )
		{
			mSoldier.PlayDelayedSpeech( SPEECH_SquadClear, false );
		}
		else
		{
			mSoldier.PlayDelayedSpeech( SPEECH_SquadLargeVolumeClear, false );
		}
	}
	else
	{	
		if ( myAV != None && !myAV.mLargeVolume )
		{
			mSoldier.PlaySpeech( SPEECH_SquadClear);
		}
		else
		{
			mSoldier.PlaySpeech( SPEECH_SquadLargeVolumeClear);
		}
	}

	mSquadManager.ClearedRoom( mSoldier );
}


///////////////////////////////////////////////////////////////////////////////
// WeaponPointedAt
//
function WeaponPointedAt( 
	Pawn	aWpnOwner )
{	
	// Can't do any of this if incapacitated
	if ( IsIncapacitated() )
	{
		return;
	} 

	// Do nothing if moving.
	if ( !mSASPawn.IsStationary() )
	{
		return;
	}

	// Do nothing if getting ready for assault
	if ( mSquadManager.SoldierIsPartOfRoomAssault( mSoldier ) != ROOMASS_NONE )
	{
		return;
	}

	// Ignore if wingman and in assault stackup.
	if ( mbIsWingman && (mWingmanAssaultEP != None || mStackupMode != SASSTACK_None) )
	{
		return;
	} 

	mLastWeaponPointedAt = SASPawn( aWpnOwner );
	mLastWeaponPointedTime = Level.TimeSeconds;

	// If i can see the pointer-atter, then crouch.
	// Assume there is no level geometry blocking our view as otherwise should not have
	// received the WeaponPointedAt event.
	if (	mSASPawn.PawnWithinViewLimits( aWpnOwner ) && 
			(mSoldier.meStance != STANCE_Crouched) )
	{
		StopMultiTimer( mTargetCheckTimer );

		DoStanceTransition( STANCE_Crouched, GetStateName() );
	} 
}


///////////////////////////////////////////////////////////////////////////////
// WeaponIsPointedAt
// 
// Check to see if the last person to point their weapon at me is still doing so.
function bool WeaponIsPointedAt ()
{
	if ( (mLastWeaponPointedAt != None) && mLastWeaponPointedAt.isPointingWeaponAt( mSoldier ) )
	{
		mLastWeaponPointedTime = Level.TimeSeconds;
		return true;
	} 
	
	return false;
}


///////////////////////////////////////////////////////////////////////////////
// ShouldStepAsideFor
//
/*function bool ShouldStepAsideFor( 
	Actor			aOther,			
	optional bool	abConsiderStationaryActors )
{
	if (	mbIsWingman &&
			(aOther == mSquadManager.GetWingmansPlayer( mSoldier )) &&
			(mWingmanAssaultEP != None) &&
			(VSizeSq( mPlayerTracker.Location - mSoldier.Location ) < Square( Metres( 1.5 ) )) &&
			(VSizeSq( mWingmanAssaultEP.Location - mSoldier.Location ) > Square( Metres( 1.0 ) )) )
	{
		return false;
	} 
	
	return Super.ShouldStepAsideFor( aOther, abConsiderStationaryActors );
} */


///////////////////////////////////////////////////////////////////////////////
// NotifyBump 
//
event bool NotifyBump (
	Actor aOther )
{
	local float					soldier2stack, 
								soldier2EP, 
								player2EP;
	local Vector				moveTarget;
	local SASSoldier			bumpedSoldier;
	local SASSoldierController	bumpedSC;

	if ( mbIsWingman )
	{
		// Special cases for wingman bumping player when stacked up.
		if ( aOther == mSquadManager.GetWingmansPlayer( mSoldier ) )
		{
			// Should still avoid if player is pushing into me.
			if (	aOther.Acceleration == Vect(0,0,0) ||
					((aOther.Acceleration Dot (mSoldier.Location - aOther.Location)) < 0.0) )
			{
				// If stacking up and we bump the player, stop if we're in a reasonable place
				// (close enough to stackup point but not too close to door)
				if ( mWingmanAssaultEP != None && mWingmanAssaultVolume == None )
				{
					soldier2stack = VSizeSq (mPlayerTracker.Location - mSoldier.Location);
					soldier2EP = VSizeSq (mWingmanAssaultEP.Location - mSoldier.Location);
					player2EP = VSizeSq (mWingmanAssaultEP.Location - aOther.Location);

					if (soldier2stack < Square (Metres (1.2)) || soldier2EP > player2EP)
					{
						mPlayerTracker.SetLocation (mSoldier.Location);
						if (mDominationPoint != None && mSoldier.ReachedDestination (mDominationPoint) == false)
						{
							RelinquishDominationPoint ();
						} 
						SetObjective (SASOBJ_Idle, None);

						// Only play audio if EP has proper stack-up positions
						if (mWingmanAssaultEP != mWingmanLastGoEP &&
							mWingmanAssaultEP.hasValidStackup () &&
							mWingmanAssaultEP != mSquadManager.mAssaultEP)
						{
							mSoldier.mVoice.PlaySpeech (mSoldier, SPEECH_SquadGo);
							mWingmanLastGoEP = mWingmanAssaultEP;
						} 
						return false;
					} 
				} 

				// If we're tracking player and we bump him, we must be close enough!
				else if ( IsInState( 'WingmanTrackPlayer' ) )
				{
					mPlayerTracker.SetLocation (mSoldier.Location);
					if ( mDominationPoint != None && !mSoldier.ReachedDestination (mDominationPoint))
					{
						RelinquishDominationPoint();
					} 
					SetObjective(SASOBJ_Idle, None);
					return false;
				} 
			}
		}
	} 
	else // I'm not a wingman
	{
		// Special case for 2 stacking up AI's bumping each other - swap stackup points
		// if we are in each others way.
		
		// Am I stacking up?
		if ( IsStackingUp() )
		{
			bumpedSoldier = SASSoldier( aOther );

			// Is bumped pawn an AI soldier?
			if (	bumpedSoldier != None &&
					bumpedSoldier.Controller.mType == CONTROLLER_AISoldier )
			{
				bumpedSC = SASSoldierController( bumpedSoldier.Controller );
				
				// Is other stacking up?
				if ( bumpedSC != None && bumpedSC.IsStackingUp() )
				{
					// Check swap stackup points.
					if ( CheckSwapStackupPoints( bumpedSoldier ) )
					{
						return false;
					}
				}
			}
		}
	}

	// Otherwise, record this bump - it may be taken down and used in evidence later ...
	// Only record if we're trying to move
	if (inMovingState () && SASPawn (aOther) != None)
	{
		if (isInState ('MovingToDominationPoint'))
		{
			moveTarget = mDominationPoint.Location;
		} // if
		else if (isInState ('WingmanTrackPlayer'))
		{
			if (mDominationPoint == None)
			{
				moveTarget = mCurrentObjective.TargetPoint.Location;
			} // if
			else
			{
				moveTarget = mDominationPoint.Location;
			} // else
		} // else if
		else if (isInState ('StackingUp') ||
					isInState ('BreachDoor'))
		{
			moveTarget = mCurrentObjective.TargetPoint.Location;
		} // else if

		if (moveTarget != Vect (0, 0, 0))
		{
			// Is this the same bumper in the same place as the last time we tried to move to this point ?
			if (SASPawn (aOther) == mBumpCount.mBumper &&
				VSizeSq (mBumpCount.mBumperLocation - aOther.Location) < 64 &&
				VSizeSq (moveTarget - mBumpCount.mMoveTarget) < 16)
			{
				if (getLevelTime () - mBumpCount.mBumpTime > 1.0)
				{
					// Shout if we haven't already and this is the player we're bumping against
					if (mBumpCount.mShouted == false && SASPlayerController (SASPawn (aOther).Controller) != None)
					{
						mSoldier.mVoice.PlaySpeech (mSoldier, SPEECH_SquadAvoid);
						mBumpCount.mShouted = true;
					} // if
					stopMoving ();
					SetObjective (SASOBJ_Idle, None);
				} // if
			} // if

			// If not, start a new bump sequence
			else
			{
				mBumpCount.mBumper = SASPawn (aOther);
				mBumpCount.mMoveTarget = moveTarget;
				mBumpCount.mBumperLocation = aOther.Location;
				mBumpCount.mBumpTime = getLevelTime ();
				mBumpCount.mShouted = false;
			} // else
		} // if
	} // if

	return Super.NotifyBump (aOther);
} // NotifyBump


///////////////////////////////////////////////////////////////////////////////
// CheckSwapStackupPoints
//
function bool CheckSwapStackupPoints(
	SASSoldier	aOther )
{
	local Vector	stackupLoc,
					otherStackupLoc,
					vecToMyStackup,
					vecStackupToOtherStackup,
					vecToOther;
	
	if ( !mSquadManager.GetStackUpLocation( mSoldier, stackUpLoc ) )
	{
		return false;
	}
	vecToMyStackup = stackupLoc - mSoldier.Location;

	vecToOther = aOther.Location - mSoldier.Location;

	if ( (vecToMyStackup Dot vecToOther ) > 0.0 )
	{
		// Stackup is other side of other soldier.

		if ( !mSquadManager.GetStackUpLocation( aOther, otherStackupLoc ) )
		{
			return false;
		}

		// Is other's stackup this side of our current stackup.
		vecStackupToOtherStackup = otherStackupLoc - stackupLoc;

		if ( (vecStackupToOtherStackup Dot vecToMyStackup) < 0.0 )
		{
			// Yes, switch stackups.
			mSquadManager.SwapStackupPoints();
			return true;
		}
	}

	return false;
}


///////////////////////////////////////////////////////////////////////////////
// MultiTimer
//
function MultiTimer(
	int		aTimerIndex )
{
	// Can't do any of this if incapacitated.
	if ( IsIncapacitated() )
	{
		return;
	}

	switch ( aTimerIndex )
	{
	case mTorchTimer:
		if ( (mSoldier != None) && (mSoldier.Weapon != None) )
		{
			mSoldier.SetGunLight( mbNewTorchState );
		}
		StopMultiTimer( mTorchTimer );
		break;

	case mLaserTimer:
		if ( (mSoldier != None) && (mSoldier.Weapon != None) )
		{
			mSoldier.SetGunLaser( mbNewLaserState );
		}
		StopMultiTimer( mLaserTimer );
		break;
	case mAttackTimer:
		if ( mbInDoubleTap )
		{
			// Only start second round firing sequence when first round has gone
			if ( mWeaponFired )
			{
				if (IsInState ('Attacking') && Target != None)
				{
					//StartRepeatFiring (1, mMinDoubleTapPause);
					StartRepeatFiring (1);
				} // if

				SetMultiTimer (mAttackTimer, RandRange (mMinDoubleTapPause, mMaxDoubleTapPause), true);
				mbInDoubleTap = false;
			} // if
		} // if
		else
		{
			if (IsInState ('Attacking') && Target != None)
			{
				mWeaponFired = false;		// Reset first round flag
				//StartRepeatFiring (1, mDoubleTapDelay);
				StartRepeatFiring (1);
			} // if

			SetMultiTimer (mAttackTimer, mDoubleTapDelay, true);
			mbInDoubleTap = true;
		} // else
		break;

	case mDelayTimer:
		SetObjective (mObjectiveAfterWait, mActorAfterWait);
		mObjectiveAfterWait = SASOBJ_Idle;
		mActorAfterWait = None;
		stopMultiTimer (mDelayTimer);
		break;

	case mRestoreDoorBumpTimer :
		mbIgnoreDoorBump = false;
		mSoldier.setCollisionSize (mSoldier.default.CollisionRadius, mSoldier.CollisionHeight);
		break;

	case mRestorePawnBumpTimer :
		mbIgnorePawnBump = false;
		break;

	case mWingmanMonitorTimer :
		if (!mbIsWingman)
		{
			break;
		} // if

		wingmanMonitorPlayerPosition ();
		break;

	case mIgnoreGrenadeTimer :
		mbIgnoreGrenades = false;
		break;

	case mAssaultTimer :
		mPaused = false;
		break;

	case mWingmanStackupIngoreEnemyTimer:
		// Re-enable attacking if player is still in same AV as when timer was disabled.
		// NOTE: If player had changed AV then attacking woill be re-enabled when wingman
		// gets to first DP in next AV.
		if (	mWingmanStackupIngoreEnemyPlayerAV == 
				mSquadManager.GetWingmansPlayer( mSoldier ).GetAssaultVolume() )
		{
			IgnoreEnemy( false );
		}
		break;

	default :
		Super.MultiTimer (aTimerIndex);
	} 
} 


///////////////////////////////////////////////////////////////////////////////
// DelayedTorchToggle
//
// Toggle status of torch but with a time delay so that not all torches in a squad
// go at the same time.
function DelayedTorchToggle (
	bool bActivate )	
{
	// Switch on the torch multitimer.
	mbNewTorchState = bActivate;
	SetMultiTimer( mTorchTimer, RandRange( mMinTorchDelay, mMaxTorchDelay ), true );
}

///////////////////////////////////////////////////////////////////////////////
// DelayedLaserToggle
//
// Toggle status of torch but with a time delay so that not all torches in a squad
// go at the same time.
function DelayedLaserToggle (
	bool bActivate )	
{
	// Switch on the torch multitimer.
	mbNewLaserState = bActivate;
	SetMultiTimer( mLaserTimer, RandRange( mMinTorchDelay, mMaxTorchDelay ), true );
}

///////////////////////////////////////////////////////////////////////////////
// SetWingmanStackPose
//
// Stackup properly if our EP has valid stackup points and is not and EP that the
// backup team has gone through recently.
function SetWingmanStackPose()
{
	if (	!mWingmanAssaultEP.HasValidStackup() ||
			((mWingmanAssaultEP == mSquadManager.mAssaultEP) &&
				((mSquadManager.mBackupSquadMode == BSM_INTERIOR_GUARD) ||
					(mSquadManager.mBackupSquadMode == BSM_INTERIOR_ASSAULT))) )
	{
		SetStackupMode (SASSTACK_Two);
	} // if
	else
	{
		SetStackupMode (SASSTACK_One);
	} // else
}


///////////////////////////////////////////////////////////////////////////////
// IsDominationPointValid
//
function bool IsDominationPointValid(
	SASSoldier	aTrackingPlayer,
	float		aMaxPlayerRange )
{
	local Vector	vecPlayerToDP;

	if ( mDominationPoint == None )
	{
		return false;
	}

	if ( aTrackingPlayer == None )
	{
		return true;
	}

	vecPlayerToDP = mDominationPoint.Location - aTrackingPlayer.Location;
	if ( VSizeSq( vecPlayerToDP ) < Square( aMaxPlayerRange ) )
	{
		return true;
	}

	return false;
}


///////////////////////////////////////////////////////////////////////////////
// isWingmanLargeVolumeTrackPointValid
//
// Changed by AF so that wingman no longer tracks around the player - if he's close
// enough then he will stay put regardless of which direction the player looks in
function bool IsWingmanLargeVolumeTrackPointValid(
	Vector	aTrackingPos )
{
	local float				heightDiff,
							distSq;
	local Vector			ofs;
	local SASSoldier		playerPawn;
	local SASAssaultVolume	myAV;
	
	// Get player we are tracking.
	playerPawn = mSquadManager.GetWingmansPlayer( mSoldier );
	if ( playerPawn == None )
	{
		LogHuman( mSoldier$ " unable to find player" );
		return false;
	}

	// Check distance of tracking point from player.
	ofs = aTrackingPos - playerPawn.Location;
	heightDiff = ofs.Z;
	ofs.Z = 0.0;

	// Is point in horizontal tracking range?
	distSq = VSizeHorizSq( ofs );
	if ( distSq > Square( WINGMAN_MAX_TRACKING_DIST2D ) )
	{
		return false;
	} 

	// Is point in vertical tracking range?
	if ( Abs( heightDiff ) > WINGMAN_TRACKING_MAX_HEIGHT_DIFF )
	{
		return false;
	}

	myAV = mSoldier.GetAssaultVolume();

	// Wingman isn't allowed to be in an interior volume if the player is in a large volume and vice versa.
	// Wingman must be in same volume as player if in an interior volume.
	if (	(mSquadManager.mPlayerVolume.mLargeVolume != myAV.mLargeVolume) ||
			(!mSquadManager.mPlayerVolume.mLargeVolume && (mSquadManager.mPlayerVolume != myAV)) )
	{
		return false;
	} 

	// None of the above ? Must be OK then.
	return true;
}


///////////////////////////////////////////////////////////////////////////////
// function sortEP
//
// Decide which is the highest priority EP of the two supplied
// One with stackups takes priority over one without, otherwise
// sort is done on distance supplied as d0 and d1
function int sortEP (SASEntryPoint EP0, SASEntryPoint EP1, float d0, float d1)
{
	local bool stackup0, stackup1;

	stackup0 = EP0.hasValidStackup ();
	stackup1 = EP1.hasValidStackup ();

	if (stackup0 && !stackup1)
	{
		return 0;
	} // if
	else if (!stackup0 && stackup1)
	{
		return 1;
	} // if

	if (d0 < d1)
	{
		return 0;
	} // if
	else
	{
		return 1;
	} // else
} // sortEP

///////////////////////////////////////////////////////////////////////////////
// Function wingmanMonitorPlayerPosition
//
// Wingman monitors player's adjacency to EPs
//
// Go through all EPs in this AV and see if the player is within the EP's
// mAssaultRadius
function WingmanMonitorPlayerPosition()
{
	local SASEntryPoint			EP;
	local SASAssaultVolume		myAV,
								playerAV,
								otherAV;
	local float					dist;
	local int					i;
	local int					close [2];
	local float					closeDist [2];
	local int					closeCount;
	local SASSoldier			player;
	local Actor					reticuleTarget;
	local SASDominationPoint	DP;
	local name					curStateName;

	// Don't do this if we're attacking a target or in other non-disturbable states.
	curStateName = GetStateName();
	if (	curStateName == 'Transition' ||
			curStateName == 'SteppingAside' ||
			curStateName == 'Climbing' ||
			curStateName == 'Scripting' )
	{
		return;
	}

	// Abandon if we can't find our player.
	player = mSquadManager.GetWingmansPlayer( mSoldier );
	if ( player == None )
	{
		return;
	}

	// If in state attacking, follow player if not in the same AV. Otherwise exit and ignore
	myAV = mSoldier.GetAssaultVolume();
	if ( IsInState( 'Attacking' ) )
	{
		if ( myAV != mSquadManager.mPlayerVolume )
		{
			DP = mSquadManager.mPlayerVolume.GetClosestDominationPointToActor( player, DPCF_OCCUPIED );
			DoMoveToDP( DP );
		}
		return;
	} 

	// Ignore if currently involved in a room assault.
	if ( mSquadManager.SoldierIsPartOfRoomAssault( mSoldier ) != ROOMASS_NONE )
	{
		return;
	}

	// Special case for wingman assaults.
	if ( mWingmanAssaultVolume != None && mWingmanAssaultEP != None )
	{
		// If we're currently heading for one of the attached DPs and
		// haven't yet reached it, update the one we're heading for based on where the player is.
		if (	(mDominationPoint == None) ||
				((	(mDominationPoint == mWingmanAssaultEP.mDPLinks [0]) ||
					(mDominationPoint == mWingmanAssaultEP.mDPLinks [1]) ||
					(mDominationPoint == mWingmanAssaultEP.mDPLinks [2]) ||
					(mDominationPoint == mWingmanAssaultEP.mDPLinks [3])) &&
				!mSoldier.ReachedDestination( mDominationPoint ) ) )
		{
			DP = SelectWingmanNextDP();
			if ( DP == None )
			{
				SetObjective( SASOBJ_Idle, None );
				mWingmanAssaultVolume	= None;
				mWingmanAssaultEP		= None;
				mWingmanLastGoEP		= None;
			}
			else if ( mDominationPoint != DP && AcquireDominationPoint (DP))
			{
				DoMoveToDP( mDominationPoint );
			} 
			else if ( mDominationPoint != DP )
			{
				DP = mWingmanAssaultVolume.GetClosestDominationPointToActor( mSoldier, DPCF_OCCUPIED );
				if (DP != None && AcquireDominationPoint (DP))
				{
					SetObjective(SASOBJ_MoveToDP, None );
				} 
				else
				{
					DoWingmanTrackPlayer();
				} 
			} 
		}
	}
	// We're not in a room assault... 
	else
	{
		// If not in the same AV as the player, follow the player.
		if ( myAV != mSquadManager.mPlayerVolume )
		{
			// Already heading for a DP in the player's AV? That's OK, carry on ...
			if (	mDominationPoint != None && 
					mDominationPoint.mAssaultVol == mSquadManager.mPlayerVolume )
			{
				return;
			}

			// Otherwise, look for the nearest unoccupied DP to the player in this AV.
			DP = mSquadManager.mPlayerVolume.GetClosestDominationPointToActor( mSoldier, DPCF_OCCUPIED );
			if ( DP != None && AcquireDominationPoint( DP ) )
			{
				SetObjective( SASOBJ_MoveToDP, None );
			}
			else
			{
				DoWingmanTrackPlayer();
			}
		} 
	}

	// Don't monitor new EPs if we're already heading towards one but haven't reached it.
	/*if (	mWingmanAssaultEP != None && 
			mWingmanAssaultVolume == None && 
			!mSoldier.ReachedDestination( mPlayerTracker ) )
	{
		return;
	} */

	// Find closest 2 EPs for which the player is inside their assault radius.
	playerAV = mSquadManager.mPlayerVolume;

	for ( i = 0; i < playerAV.mEntryPoints.Length; i++ )
	{
		EP = playerAV.mEntryPoints[i];

		// Only counts if EP leads to an internal volume.
		otherAV = EP.GetOtherAssaultVolume( playerAV );
		if ( !otherAV.mLargeVolume && EP != mWingmanLastAssaultEP )
		{
			dist = VSizeSq( EP.Location - player.Location );

			if (dist < Square( EP.mAssaultRadius ) )
			{
				if ( closeCount < 2 )
				{
					close[closeCount] = i;
					closeDist[closeCount] = dist;
					closeCount++;
				}
				else
				{
					// Replace the furthest of the two current doors
					if ( SortEP( 
							playerAV.mEntryPoints[close[0]], 
							playerAV.mEntryPoints[close[1]], 
							closeDist[0], 
							closeDist[1] ) == 0 )					
					{
						if ( SortEP( 
								playerAV.mEntryPoints[close[1]], 
								playerAV.mEntryPoints[i], 
								closeDist[1], 
								dist ) == 1 )
						{
							close[1] = i;
							closeDist[1] = dist;
						} 
					}
					else
					{
						if ( SortEP(
								playerAV.mEntryPoints[close[0]],
								playerAV.mEntryPoints[i], 
								closeDist[0], 
								dist ) == 1 )
						{
							close[0] = i;
							closeDist[0] = dist;
						}
					} 
				} 
			} 
		} 
	} 

	// Player not close to any EPs? No further action required.
	if ( closeCount == 0 )
	{
		// Don't cancel EP if we're assaulting a volume - we need to retain the EP
		// we came through during an assault.
		if ( mWingmanAssaultVolume == None )
		{
			mWingmanAssaultEP = None;
		}

		mWingmanLastGoEP = None;
		return;
	}
	// Close to one EP? Use that one, then.
	else if ( closeCount == 1 )
	{
		EP = playerAV.mEntryPoints[close [0]];
	}
	// Close to more than one EP? Find the one the player is looking at.
	else
	{
		EP = None;

		// If current view target is a door, check to see if it is attached to ones of the
		// EPs we've identified as close
		reticuleTarget = SASPlayerController( player.Controller ).mReticuleTarget;
		if ( SASDoorMover( reticuleTarget ) != None)
		{
			EP = SASEntryPoint( SASDoorMover(reticuleTarget).myMarker );

			// If this isn't an EP we're looking for, can't use it
			if (	EP != playerAV.mEntryPoints[close[0]] &&
					EP != playerAV.mEntryPoints[close[1]] )
			{
				EP = None;
			} 
		} 

		// Not looking at an EP? Just use the closest one to the player
		if ( EP == None )
		{
			EP = playerAV.mEntryPoints[close[ SortEP( 
											playerAV.mEntryPoints[close[0]], 
											playerAV.mEntryPoints[close [1]], 
											closedist[0], 
											closedist[1] ) ]];
		}
	}

	// Only do this if the rest of the squad aren't stacking up on this EP.
	if (	(mSquadManager.mBackupSquadMode == BSM_INTERIOR_STACKUP ||
				mSquadManager.mBackupSquadMode == BSM_INTERIOR_ASSAULT) &&
			(mSquadManager.mAssaultEP == EP) )
	{
		mWingmanAssaultEP		= None;
		mWingmanAssaultVolume	= None;
		//mWingmanLastGoEP		= None;
		return;
	} 

	// So, we have an EP. We need to get to the second stack-up point for the EP (door) or, if that
	// is unavailable, one of the two attached DPs
	if ( EP != mWingmanAssaultEP )
	{
		// Cancel any existing assault.
		mWingmanAssaultVolume = None;
		DoWingmanStackup( playerAV, EP );
	} 
}


///////////////////////////////////////////////////////////////////////////////
// DoWingmanStackup
//
// When player approaches EP, wingman gets into stack up position, using either
// stack-up position #2 for the door or alternatively one of the two attached DPs
// if no stack-up is available
function DoWingmanStackup(
	SASAssaultVolume	AV, 
	SASEntryPoint		EP )
{
	local bool foundPoint;
	local SASDominationPoint DP;
	local float dist;
	local rotator r;
	local SASSoldier player;
	local int reachable [2];

	if (EP == None)
	{
		return;
	} // if

	if (AV == none)
	{
		return;
	} // if

	// Use tracker object to control moves. We also store the required rotation for the wingman in the
	// player tracker object's rotation
	if ( mPlayerTracker == None )
	{
		mPlayerTracker = Spawn (class'SASMoveTarget');
	} // if

	mWingmanAssaultEP = EP;

	// Give up any DP we already have.
	RelinquishDominationPoint();

	if ( EP.HasValidStackup() )
	{
		// Select a point to go to. If we can reach stackup point 2, use that
		if (EP.mAssaultVolLinks [0] == AV)
		{
			mPlayerTracker.setLocation (EP.mStackUpParams [0].Positions [1]);
			r.Yaw = EP.mStackUpParams [0].FacingAngles [1];
			mPlayerTracker.setRotation (r);
			foundPoint = true;
		} // if
		else
		{
			mPlayerTracker.setLocation (EP.mStackUpParams [1].Positions [1]);
			r.Yaw = EP.mStackUpParams [1].FacingAngles [1];
			mPlayerTracker.setRotation (r);
			foundPoint = true;
		} // else
	} // if

	// If we've found a stack-up point, ensure that the backup squad is clear of these points
	//if (foundPoint)
	//{
	//	mSquadManager.squadClearStackupPoints (AV, EP);
	//} // if

	// We had no luck with the stack up points, so go looking for the attached DPs
	if (!foundPoint)
	{
		player = mSquadManager.getWingmansPlayer (mSoldier);

		// If player is near one DP, we choose the other
		if (EP.mAssaultVolLinks [0] == AV)
		{
			if (VSizeHorizSq (EP.mDPLinks [0].Location - player.Location) < Square (Metres (1)))
			{
				//reachable [1] = int (pointReachable (EP.mDPLinks [1].Location));
				reachable [1] = 1;
				if (EP.mDPLinks [1].mOwner == None && reachable [1] != 0 && AcquireDominationPoint (EP.mDPLinks [1]))
				{
					mPlayerTracker.SetLocation (EP.mDPLinks [1].Location);
					mPlayerTracker.setRotation (Rotator ( EP.Location - EP.mDPLinks [1].Location ));
					foundPoint = true;
				} // if
			} // if
			else if (VSizeHorizSq (EP.mDPLinks [1].Location - player.Location) < Square (Metres (1)))
			{
				//reachable [0] = int (pointReachable (EP.mDPLinks [0].Location));
				reachable [0] = 1;
				if (EP.mDPLinks [0].mOwner == None && reachable [0] != 0 && AcquireDominationPoint (EP.mDPLinks [0]))
				{
					mPlayerTracker.SetLocation (EP.mDPLinks [0].Location);
					mPlayerTracker.setRotation (Rotator ( EP.Location - EP.mDPLinks [0].Location ));
					foundPoint = true;
				} // if
			} // if

			if (!foundpoint)
			{
				if (EP.mDPLinks [0].mOwner == None && reachable [0] != 0 && AcquireDominationPoint (EP.mDPLinks [0]))
				{
					mPlayerTracker.SetLocation (EP.mDPLinks [0].Location);
					mPlayerTracker.setRotation (Rotator ( EP.Location - EP.mDPLinks [0].Location ));
					foundPoint = true;
				} // if
				else if (EP.mDPLinks [1].mOwner == None && reachable [1] != 0 && AcquireDominationPoint (EP.mDPLinks [1]))
				{
					mPlayerTracker.SetLocation (EP.mDPLinks [1].Location);
					mPlayerTracker.setRotation (Rotator ( EP.Location - EP.mDPLinks [1].Location ));
					foundPoint = true;
				} // if
			} // if
		} // if
		else
		{
			if (VSizeHorizSq (EP.mDPLinks [2].Location - player.Location) < Square (Metres (1)))
			{
				//reachable [1] = int (pointReachable (EP.mDPLinks [3].Location));
				reachable [1] = 1;
				if (EP.mDPLinks [3].mOwner == None && reachable [1] != 0 && AcquireDominationPoint (EP.mDPLinks [3]))
				{
					mPlayerTracker.SetLocation (EP.mDPLinks [3].Location);
					mPlayerTracker.setRotation (Rotator ( EP.Location - EP.mDPLinks [3].Location ));
					foundPoint = true;
				} // if
			} // if
			else if (VSizeHorizSq (EP.mDPLinks [3].Location - player.Location) < Square (Metres (1)))
			{
				//reachable [0] = int (pointReachable (EP.mDPLinks [2].Location));
				reachable [0] = 1;
				if (EP.mDPLinks [2].mOwner == None && reachable [0] != 0 && AcquireDominationPoint (EP.mDPLinks [2]))
				{
					mPlayerTracker.SetLocation (EP.mDPLinks [2].Location);
					mPlayerTracker.setRotation (Rotator ( EP.Location - EP.mDPLinks [2].Location ));
					foundPoint = true;
				} // if
			} // if

			if (EP.mDPLinks [2].mOwner == None && reachable [0] != 0 && AcquireDominationPoint (EP.mDPLinks [2]))
			{
				mPlayerTracker.SetLocation (EP.mDPLinks [2].Location);
				mPlayerTracker.setRotation (Rotator ( EP.Location - EP.mDPLinks [2].Location ));
				foundPoint = true;
			} // if
			else if (EP.mDPLinks [3].mOwner == None && reachable [1] != 0 && AcquireDominationPoint (EP.mDPLinks [3]))
			{
				mPlayerTracker.SetLocation (EP.mDPLinks [3].Location);
				mPlayerTracker.setRotation (Rotator ( EP.Location - EP.mDPLinks [3].Location ));
				foundPoint = true;
			} // if
		} // else
	} // if

	// Find the nearest unoccupied DP to the EP if it's closer than 2 metres
	if (!foundPoint)
	{
		DP = AV.getClosestDominationPointToActor (EP, DPCF_OCCUPIED);
		if (DP != None &&
			VSizeSq (DP.Location - EP.Location) < Square (Metres (1.5)) &&
			//pointReachable (DP.Location) &&
			AcquireDominationPoint (DP))
		{
			mPlayerTracker.SetLocation (DP.Location);
			mPlayerTracker.setRotation (Rotator (normal (EP.Location - DP.Location)));
			foundPoint = true;
		} // if
	} // if

	// Last chance - simply find a wingman player tracking point
	if ( !foundPoint )
	{
		if ( FindPlayerTrackPoint() )
		{
			mPlayerTracker.SetLocation (mWingmanTrackPoint);
			mPlayerTracker.setRotation (Rotator (normal (EP.Location - mWingmanTrackPoint)));
			foundPoint = true;
		} // if
		else
		{
			StopMoving();
		}
	} // if

	// If we've been unable to find a point by any of these methods, give up
	if (!foundPoint)
	{
		LogHuman ("*** "$ mSoldier$ " unable to find wingman stackup point in " $AV$ " ***");
		mWingmanAssaultEP = None;
		return;
	} // if

	// Run if far from point. Charge if a really long way. Otherwise dawdle.
	dist = VSizeSq (mSoldier.Location - mPlayerTracker.Location);
	if (dist > square (metres (5)))
	{
		mSoldier.SetPace (PACE_Charging);
	} // if
	else if (dist > square (metres (2)))
	{
		mSoldier.SetPace (PACE_Running);
	} // if
	else
	{
		mSoldier.SetPace (PACE_Walking);
	} // else

	// Move to point unless we're already there
	if (mSoldier.ReachedDestination (mPlayerTracker) == false)
	{
		SetObjective (SASOBJ_MoveToLocation, mPlayerTracker);
	} // if
	else
	{
		if (mWingmanAssaultEP.hasValidStackup ())
		{
			mSoldier.PlayWeaponSpecificAnim ("Stand_Ported3", 1.0, 0.15,, true );
		} // if
		setFacingAtPoint (mPlayerTracker.Location, vector (mPlayerTracker.Rotation));

		SetWingmanStackPose ();
	} // else

	// Create the wingman's 'Invisible Friend' object that will help him through the assault
	if (mWingmanInvisibleFriend == None)
	{
		mWingmanInvisibleFriend = Spawn (class'SASMoveTarget');
	} // if
} // doWingmanStackup

///////////////////////////////////////////////////////////////////////////////
// DoWingmanAssault
//
// When the player changes assault volume, we follow him in
function DoWingmanAssault (SASAssaultVolume AV)
{
	local SASDominationPoint DP;

	// The player should be in an EP's assault radius so just double check that
	// our EP matches where we've been told to go
	if (mWingmanAssaultEP.mAssaultVolLinks [0] != AV && mWingmanAssaultEP.mAssaultVolLinks [1] != AV)
	{
		LogHuman ("doWingmanAssault - AV " $AV$ " not attached to assault EP " $mWingmanAssaultEP);
		return;
	} // if

	mWingmanAssaultVolume = AV;
	mWingmanLastAssaultEP = mWingmanAssaultEP;
	AV.resetClearFlags ();

	DP = SelectWingmanNextDP();
	if (mDominationPoint != DP && AcquireDominationPoint (DP))
	{
		ignoreEnemy (true);
		mNoReassessment = true;
		SetObjective (SASOBJ_MoveToFirstDP, None);
	} // if
	else
	{
		SetObjective (SASOBJ_Idle, None);
	} // else
} // doWingmanAssault

///////////////////////////////////////////////////////////////////////////////
// PlayerChangedAssaultVolumes
//
// 
function PlayerChangedAssaultVolumes (
	SASSoldier			aPlayer,
	SASAssaultVolume	aNewPlayerAV,
	SASAssaultVolume	aPrevPlayerAV )
{
	local int	i;
	local bool	bAssault;
	local name	curStateName;

	curStateName = GetStateName();
	if (	curStateName == 'Transition' ||
			curStateName == 'SteppingAside' ||
			curStateName == 'Climbing' ||
			curStateName == 'Scripting' )
	{
		return;
	}

	SetStackupMode( SASSTACK_None );

	if ( aNewPlayerAV.mLargeVolume )
	{
		mWingmanAssaultVolume	= None;
		mWingmanAssaultEP		= None;
		SetObjective( SASOBJ_Idle, None );
	}
	else
	{
		bAssault = true;

		// If any other squad members are alive in here, we don't assault
		for ( i = 0; i < mSquadManager.mNumAISquadMembers; i++ )
		{
			if (	mSquadManager.mAISquadMembers[i] != None &&
					mSquadManager.mAISquadMembers[i] != mSoldier &&
					mSquadManager.mAISquadMembers[i].Health > 0 &&
					!mSquadManager.mAISquadMembers[i].mbIsIncapacitated &&
					mSquadManager.mAISquadMembers[i].GetAssaultVolume() == aNewPlayerAV )
			{
				bAssault = false;
				break;
			} 
		} 

		if ( !bAssault )
		{
			mWingmanAssaultVolume	= None;
			mWingmanAssaultEP		= None;
			mWingmanLastGoEP		= None;
			SetObjective( SASOBJ_Idle, None );
		}
		else
		{
			// GP: Check that the current assault EP is the one that 
			// the player has just passed through. This is required as it can get out of synch
			// due to the EP setting function (WingmanMonitorPlayerPosition) being currently called on a timer.
			PreWingmanAssaultCheckAssaultEP( aPlayer, aNewPlayerAV, aPrevPlayerAV ); 
			DoWingmanAssault( aNewPlayerAV );
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// PreWingmanAssaultCheckAssaultEP
//
function PreWingmanAssaultCheckAssaultEP(
	SASSoldier			aPlayer,
	SASAssaultVolume	aNewPlayerAV,
	SASAssaultVolume	aPrevPlayerAV )
{
	local int			i,
						numEPs;
	local float			distSq,
						closestDistSq;
	local SASEntryPoint	testEP,
						closestEP;

	if ( aNewPlayerAV == None || aPrevPlayerAV == None )
	{
		return;
	}

	closestDistSq = Square( 99999.9 );

	// Find closest EP to the player which links the 2 volumes.
	numEPs = aNewPlayerAV.mEntryPoints.Length;
	for ( i = 0; i < numEPs; ++i )
	{
		testEP = aNewPlayerAV.mEntryPoints[i];
		if ( testEP != None && testEP.GetOtherAssaultVolume( aNewPlayerAV ) == aPrevPlayerAV )
		{
			distSq = VSizeSq( aPlayer.Location - testEP.Location );
			if ( distSq < closestDistSq )
			{
				closestEP = testEP;
			}
		}
	}

	mWingmanAssaultEP = closestEP;
}


///////////////////////////////////////////////////////////////////////////////
// NotifyClipEmpty
//
// Called at the point the current weapon empties its clip. Instigates correct
// action (pull secondary weapon, reload etc).
//
// Converted from AI controller version
function NotifyClipEmpty ()
{
	local SASWeapon	wpn, otherWpn;

	wpn = SASWeapon (mSoldier.Weapon);

	// If weapon is reloading or being put down, ignore
	if (wpn.mbIsReloading || wpn.isInState ('DownWeapon') || wpn.isInState ('Active'))
	{
		return;
	} // if

	// In combat or during room assault
	if (Enemy != None || (!mbIsWingman && mSquadManager.mBackupSquadMode == BSM_INTERIOR_ASSAULT))
	{
		// If primary has run out, switch to secondary if its loaded
		if (wpn.mCategory == WPNCAT_Primary)
		{
			otherWpn = mSASPawn.GetWeaponOfCategory (WPNCAT_Secondary);

			// If we have a loaded secondary, use it
			if (otherWpn != None && !otherWpn.NeedsToReload ())
			{
				mSASPawn.SelectWeapon (WPNCAT_Secondary);
			} // if

			// If not, reload our primary
			else
			{
				DoReloading ();
			} // else
		} // if
		else
		{
			otherWpn = mSASPawn.GetWeaponOfCategory (WPNCAT_Primary);

			// If we have a loaded primary, use it
			if (otherWpn != None && !otherWpn.NeedsToReload ())
			{
				mSASPawn.SelectWeapon (WPNCAT_Primary);
			} // if

			// If not, reload our primary
			else
			{
				DoReloading ();
			} // else
		} // if
	} // if

	// Out of combat
	else
	{
		// If primary weapon has ammo then reload, otherwise switch to secondary
		if (wpn.mCategory == WPNCAT_Primary)
		{
			if (wpn.AmmoType.AmmoAmount > 0)
			{
				DoReloading ();
			} // else
			else
			{
				mSASPawn.SelectWeapon (WPNCAT_Secondary);
			} // else
		} // if

		// If secondary, switch to primary if it has ammo, otherwise reload
		else
		{
			otherWpn = mSASPawn.GetWeaponOfCategory (WPNCAT_Primary);

			// If we have a loaded primary, use it
			if (otherWpn.AmmoType.AmmoAmount > 0)
			{
				mSASPawn.SelectWeapon (WPNCAT_Primary);
			} // if

			// If not, reload our secondary
			else
			{
				DoReloading ();
			} // else
		} // if
	} // else
} // NotifyClipEmpty

///////////////////////////////////////////////////////////////////////////////
// doReloading
//
// Base behaviour when need to reload weapon - just do it.
function doReloading (optional bool forceReload)
{
	if (IsIncapacitated ())
	{
		return;
	} // if

	if ( mSASPawn.Weapon != None && mSASPawn.Weapon.IsA ('SASGrenadeWeapon') == false)
	{
		// Try to swap to primary weapon if available.
		if ( (SASWeapon(mSASPawn.Weapon).mCategory == WPNCAT_Primary)
			|| (mSASPawn.GetWeaponOfCategory( WPNCAT_Primary ) != None)
			|| forceReload)
		{
			// GP: Shouldn't be needed - weapon is triggering this speech on enterring reloading state.
			//mSoldier.mVoice.PlaySpeech (mSoldier, SPEECH_SquadMagChange);
			mSASPawn.Weapon.Reload();
		}
		else
		{
			mSASPawn.SelectWeapon( WPNCAT_Primary );
		}
	}
} // doReloading

///////////////////////////////////////////////////////////////////////////////
// States

function bool inMovingState ()
{
	return false;
} // inMovingState

function GoGoGo (optional float pause)
{
	if (IsIncapacitated ())
	{
		return;
	} // if

	GotoState ('WaitingForAssault');
} // GoGoGo

function ChooseAction();
function wingmanChooseAction();
function backupChooseAction();
function SetStackUpFocalDirection();
function ReassessGoal();
function CheckMovementPace();
function ChooseTrackingPace();
function SelectInitialSweepDirection();
function SelectSweepAnim();
function bool UpdateSweep();
function BeginSweepStep();
function EndSweepStep();
function UpdateState();
function CheckAim();


///////////////////////////////////////////////////////////////////////////////
// STATE Idle
//
state Idle
{
	event EndState()
	{
		mGuardingEP = None;
		mReactingToSound = false;
	}

	event bool IsIdle()
	{
		return true;
	}

	event multiTimer (int timerID)
	{
		if (timerID == mIdleTimer)
		{
			ChooseAction ();
		} // if
		else
		{
			global.multiTimer (timerID);
		} // else

		// Check this is working - sometimes it doesn't :-/
		if (!IsMultiTimerActive (mIdleTimer))
		{
			setMultiTimer (mIdleTimer, 0.5, true);
		} // if
	}

	function WingmanChooseAction()
	{
		local SASDominationPoint	DP;
		local eRoomAssaultRole		roomAssaultRole;

		roomAssaultRole = mSquadManager.SoldierIsPartOfRoomAssault (mSoldier);
		//SetStackupMode (SASSTACK_None);

		// If there's a room assault going on in which we're not involved, stay out of the way
		if (	roomAssaultRole == ROOMASS_ASSAULT_PRIMARY ||
				roomAssaultRole == ROOMASS_ASSAULT_SECONDARY ||
				roomAssaultRole == ROOMASS_DOOROPEN )
		{
			if ( !isWingmanLargeVolumeTrackPointValid( Pawn.Location ) )
			{
				DoWingmanTrackPlayer();
				return;
			} 
		}
		// If we're involved as the door opener, move in to do our bit
		else if ( roomAssaultRole == ROOMASS_DOORBREACH )
		{
			DoDoorBreach();
			return;
		}
		// If we're assaulting a volume, what do we do next
		else if ( mWingmanAssaultVolume != None )
		{
			// If we haven't reached current DP then go there.
			if ( mDominationPoint != None && !mSoldier.ReachedDestination( mDominationPoint ) )
			{
				SetObjective( SASOBJ_MoveToDP, mPlayerTracker );
				return;
			}
			// If we are at DP but it isn't cleared, sweep it
			else if ( mDominationPoint != None && !mDominationPoint.mbCleared )
			{
				DoSweepDP();
				return;
			}
			// Otherwise we move to the next DP
			else
			{
				// Temporary behaviour
				DP = SelectWingmanNextDP();
				if ( DP == None )
				{
					mWingmanAssaultVolume	= None;
					mWingmanAssaultEP		= None;
					mWingmanLastGoEP		= None;

					DoDefaultStationaryBehaviour();
					CallRoomClear();
				}
				else if ( mDominationPoint != DP && AcquireDominationPoint( DP ) )
				{
					if ( !mSoldier.ReachedDestination( DP ) )
					{
						SetObjective( SASOBJ_MoveToDP, None );
					}
					else
					{
						DoSweepDP();
					}
					return;
				}
				else
				{
					DoDefaultStationaryBehaviour();
				} 
			} 
		}
		// If we're currently stacking up because the player is near an EP, continue to the correct point.
		else if ( mWingmanAssaultEP != None )
		{
			if ( !mSoldier.ReachedDestination( mPlayerTracker ) )
			{
				SetObjective( SASOBJ_MoveToLocation, mPlayerTracker );
			}
			else
			{
				if ( mSoldier.meStance != STANCE_Standing )
				{
					mSoldier.ChangeStanceImmediate( STANCE_Standing );
				}

				StopMoving();
				SetWingmanStackPose();

				SetFocus( mWingmanAssaultEP );

				// Only play audio if EP is a door
				if (	mWingmanAssaultEP != mWingmanLastGoEP &&
						mWingmanAssaultEP.HasValidStackup () &&
						mWingmanAssaultEP != mSquadManager.mAssaultEP )
				{
					mSoldier.mVoice.PlaySpeech( mSoldier, SPEECH_SquadGo );
					mWingmanLastGoEP = mWingmanAssaultEP;
				}
			}
			return;
		} // if

		else if (	!mSquadManager.mPlayerVolume.mLargeVolume && 
					mSoldier.GetAssaultVolume() != mSquadManager.mPlayerVolume )
		{
			// Relinquish DP otherwise we can't select it again, even though we own it
			RelinquishDominationPoint ();
			
			// If not in same AV as player then try to find a DP in other AV, but only if there is 
			// not an assault happening there.
			if ( mSquadManager.mPlayerVolume == mSquadManager.mAssaultVolume )
			{
				DP = None;
			}
			else
			{
				DP = mSquadManager.mPlayerVolume.GetClosestDominationPointToActor(
					mSquadManager.GetWingmansPlayer( mSoldier ), 
					DPCF_OCCUPIED );
			}

			if (	DP != None &&
					AcquireDominationPoint( DP ) )
			{
				DoMoveToDP( mDominationPoint );
				return;
			} 
			else
			{
				DoWingmanTrackPlayer();
				return;
			} 
		} 
		// If we already have a valid DP but haven't quite reached it then go there.
		else if (mDominationPoint != None)
		{
			if (!mSoldier.ReachedDestination (mDominationPoint))
			{
				SetObjective (SASOBJ_MoveToDP, None);
				return;
			} // if
			else if (mSquadManager.mPlayerVolume.mLargeVolume == true && !isWingmanLargeVolumeTrackPointValid (Pawn.Location))
			{
				DoWingmanTrackPlayer ();
				return;
			} // if
			else
			{
				DoDefaultStationaryBehaviour ();
				return;
			} 
		}
		// If our current position is invalid, find a new one and track to it
		else if (	mSquadManager.mPlayerVolume.mLargeVolume && 
					!IsWingmanLargeVolumeTrackPointValid( Pawn.Location ) )
		{
			DoWingmanTrackPlayer();
			return;
		} 
		// Otherwise take up position where we are
		else
		{
			// If not in same volume as player then 
			// If we're very close to a DP and we can acquire it, then do so
			if ( !mSquadManager.mPlayerVolume.mLargeVolume )
			{
				DP = mSoldier.GetAssaultVolume().GetClosestDominationPointToActor(
					mSoldier, 
					DPCF_OCCUPIED );
				DoMoveToDP( DP );
				return;
			}

			DoDefaultStationaryBehaviour();
		} 
	} 

	function BackupChooseAction()
	{
		local SASDominationPoint	DP;
		local SASSoldier			playerPawn;
		local vector				FollowWaitLoc;

		playerPawn = mSquadManager.GetClosestPlayerToOther (mSoldier);

		switch ( mSquadManager.mBackupSquadMode )
		{
			case BSM_INTERIOR_FOLLOW :
				DP = mSquadManager.getFollowWaitDP (mSoldier);
				if (DP != None && AcquireDominationPoint (DP))
				{
					// If we haven't reached the point then go there
					if (mSoldier.ReachedDestination (mDominationPoint) == false)
					{
						SetObjective (SASOBJ_MoveToDP, None);
						return;
					} // if

					// Otherwise guard the point
					else
					{
						doDefaultStationaryBehaviour ();

						// If we're inside, goto stackup two (firing anim but shrunk cylinder)
						SetStackupMode (SASSTACK_Two);
					} // else
				} // if
				else
				{
					mSquadManager.getFollowWaitPoint (mSoldier, FollowWaitLoc);
					mAssaultPoint.SetLocation (FollowWaitLoc);

					// If we haven't reached the point then go there
					if (mSoldier.ReachedDestination (mAssaultPoint) == false)
					{
						SetObjective (SASOBJ_MoveToLocation, mAssaultPoint);
						return;
					} // if

					// Otherwise guard the point
					else
					{
						doDefaultStationaryBehaviour ();

						// If we're inside, goto stackup two (firing anim but shrunk cylinder)
						SetStackupMode (SASSTACK_Two);
					} // else
				} // else
				break;

			case BSM_INTERIOR_BACKUP :
				DP = mSquadManager.getBackupSupportPoint (mSoldier);
				// If we haven't reached the point then go there
				doMoveToDP (DP);
				break;

			case BSM_INTERIOR_STACKUP :
				switch (mSquadManager.SoldierIsPartOfRoomAssault (mSoldier))
				{
					case ROOMASS_ASSAULT_PRIMARY :

						// It's possible that I've already made my DP before the second trooper gets there -
						// in which case I'll guard where I am
						if (mSquadManager.getAssaultTrooperStatus (mSoldier) != ATSTATUS_MOVETOFIRSTDP)
						{
							DoStackUp ();
						} // if
						else
						{
							DoGuard (1.0);
						} // else
						break;

					case ROOMASS_ASSAULT_SECONDARY :

						// It's far less likely that this will ever happen
						if (mSquadManager.getAssaultTrooperStatus (mSoldier) != ATSTATUS_MOVETOFIRSTDP)
						{
							doStackUp ();
						} // if
						else
						{
							doGuard (1.0);
						} // else
						break;

					case ROOMASS_DOORBREACH :
						doDoorBreach ();
						break;

					case ROOMASS_DOOROPEN :
						break;
				} // switch
				break;

			case BSM_INTERIOR_ASSAULT :
				mSquadManager.requestNextAction (mSoldier);
				break;

			case BSM_INTERIOR_GUARD :
				
				if (mDominationPoint != None)
				{
					doMoveToDP (mDominationPoint);
				} // if
				else
				{
					doDefaultStationaryBehaviour ();
				} // else

				doGuard (1.0);
				break;

			// This is what the old AI used to do with the backup squad
			case BSM_EXTERIOR :
				playerPawn = mSquadManager.GetClosestPlayerToOther (mSoldier);

				// If current DP is no good, get another one
				if (!IsDominationPointValid (playerPawn, Metres (mSquadManager.mPlayerSeparation)))
				{
					if (mNextExteriorCheck < getLevelTime ())
					{
						mNextExteriorCheck = getLevelTime () + 1;
						mSquadManager.SelectBackupSquadDP ();
						DP = mSquadManager.getBackupDP (mSoldier);
						doMoveToDP (DP);
						return;
					} // if
				} // if

				// If we already have a valid DP but haven't reached it then go there.
				if (mDominationPoint != None)
				{
					if (!mSoldier.ReachedDestination (mDominationPoint))
					{
						doMoveToDP (mDominationPoint);
						return;
					} // if
					else
					{
						if (mLastDPSwept != mDominationPoint)
						{
							DoSweepDP ();
							mLastDPSwept = mDominationPoint;
						} // if
						else
						{
							doDefaultStationaryBehaviour ();
						} // else
					} // else
				} // if
				break;
		} // switch
	} // backupChooseAction

	function ChooseAction()
	{
		local Actor	bestTgt;
		local bool	lineOfFire;

		mbOnOffensive = false;

		bestTgt = mSquadManager.SelectTarget( mSoldier );
		Focus = bestTgt;
		if (bestTgt != None && mbIgnoreEnemy == false)
		{
			checkForHostageStandoffAudio ();

			// If no line of fire in last test and target is same as last test and
			// both we and target are close to test positions then assume LoS will still be blocked.
			if (	(bestTgt == mLastLoFFailTarget) &&
					(mLastLoFFailTime > Level.TimeSeconds - 3.0) )
			{
				// If not at our DP and target is more than 2m away then ignore it for now.
				if (	(mDominationPoint != None) && 
						!mSoldier.ReachedDestination( mDominationPoint ) &&
						(VSizeSq( mSoldier.Location - bestTgt.Location ) > Square( 100.0 )) )
				{
					lineOfFire = false;
				}
				else if (	(VSizeSq( mSoldier.Location - mLastLoFFailPos) < 144) &&			// 144 = square of 12
							(VSizeSq( bestTgt.Location - mLastLoFFailTargetPos) < 144) )
				{
					lineOFFire = false;
				}
				else
				{
					lineOfFire = true;
				}
			} // if
			else
			{
				lineOfFire = true;
			} // else

			if ( mSquadManager.mBackupSquadMode == BSM_INTERIOR_ASSAULT && !lineOfFire && !mbIsWingman)
			{
				ignoreEnemy (true);
				mSquadManager.requestNextAction (mSoldier);
				return;
			} // if
			else if (!lineOfFire)
			{
				setEnemy (None);
			} // else if
			else
			{
				EndQuartering ();
				mbOnOffensive = true;
				SetObjective (SASOBJ_AttackEnemy, bestTgt);
				return;
			} // else
		} // if
		else
		{
			setEnemy (None);
		} // else

		CheckFocusTarget ();

		// Reset pitch angles for aiming
		//resetPitchAnimation	();

		if (mbIsWingman)
		{
			wingmanChooseAction ();
		} // if

		// Else ... not wingman
		else
		{
			backupChooseAction ();
		} // if
	} // ChooseAction

Begin:

	StopMoving();

	/*if ( mDominationPoint != None && mSoldier.ReachedDestination( mDominationPoint ) )
	{
		Sleep(1.0);
		DoSweepDP();
	}*/

	// Tell squad to update which EPs each soldier should guard.
	mSquadManager.UpdateSquadGuardingPoints();

	ChooseAction();
	setMultiTimer (mIdleTimer, 0.5, true);
	FinishRotation();

	BeginQuartering();

}


///////////////////////////////////////////////////////////////////////////////
// STATE WAIT
State Wait
{
	event bool IsIdle()
	{
		return true;
	}


Begin :
	StopMoving();
	FinishRotation();
} // State Wait

///////////////////////////////////////////////////////////////////////////////
// AssaultVolChange
//
// Event received when pawn changes assault volume if assault volume monitoring
// is enabled (by calling MonitorAssaultVolChange() ).
// AV change monitoring should only be enabled when needed (when enabled, the 
// pawn's current AV is tested every frame rather than only when requested).
event AssaultVolChange(
	SASAssaultVolume	aPrevAV )
{
	// Inform squad that I've just changed AV.
	mSquadManager.SquadMemberChangedAssaultVolumes( mSoldier, aPrevAV );

	// If we're one of the backup squad, call 'coming through' assuming we're in backup or follow
	// mode
	if (!mbIsWingman &&
		(mSquadManager.mBackupSquadMode == BSM_INTERIOR_FOLLOW ||
		 mSquadManager.mBackupSquadMode == BSM_INTERIOR_BACKUP) &&
		mSquadManager.getSquadShoutPermission ())
	{
		mSoldier.PlaySpeech (SPEECH_SquadMoving);
	} // if
}


///////////////////////////////////////////////////////////////////////////////
// STATE StackingUp
//
state StackingUp extends MovingState
{	
	ignores WeaponPointedAt;

	function bool IsStackingUp()
	{
		return true;
	}

	function bool inMovingState ()
	{
		return true;
	} // inMovingState

	event BeginState()
	{
		Super.BeginState();

		// Make sure timer not running at start.
		SetTimer( 0.0, false );
	}

	event EndState()
	{
		Super.EndState();

		// Stop per-frame checking of changes to pawn's assault volume. 
		MonitorAssaultVolChange( false );

		mSoldier.setPace (PACE_Running);
	}

	function SetStackUpFocalDirection()
	{
		local Rotator	stackUpRot;
		local Vector	stackUpDir;

		if ( mSquadManager.GetStackUpRotation( mSoldier, stackUpRot ) )
		{
			stackUpDir = Vector( stackUpRot );
		}
		else
		{
			stackUpDir = ChooseDirectionNotFacingWall( Vector( Rotation ) );
		}
		SetFocalPointFromDir( stackUpDir );
	}

Begin:

	Enable( 'Bump' );

	// Monitor changing assault volume.
	MonitorAssaultVolChange( true );

	if (VSizeSq (mSoldier.Location - mAssaultPoint.Location) > 160000)	// 160000 = 8 metres
	{
		mSoldier.setPace (PACE_Charging);
	} // if
	else
	{
		mSoldier.setPace (PACE_Running);
	} // else


	DoMoveToActor( 
		mCurrentObjective.TargetPoint,
		mSoldier.mePace, 
		STANCE_Standing,,,,
		false );

MTP_FinishedMove:

	// Stop bump timer.
	SetTimer( 0.0, false );

	// Set appropriate stackup pose
	if (mSquadManager.SoldierIsPartOfRoomAssault (mSoldier) == ROOMASS_ASSAULT_PRIMARY)
	{
		SetStackupMode (SASSTACK_One);
	} // if
	else if (mSquadManager.SoldierIsPartOfRoomAssault (mSoldier) == ROOMASS_ASSAULT_SECONDARY)
	{
		SetStackupMode (SASSTACK_Two);
	} // else
	mSoldier.ChangeAnimation();

	if ( !mbFailedMoveToPoint )
	{ 
		SetStackUpFocalDirection();
	}
	else
	{
		SetFocalPointFromDir( ChooseDirectionNotFacingWall( Vector( Rotation ) ) );
	}
	FinishRotation();

	// Tell squad manager that we've arrived
	if (!mbFailedMoveToPoint)
	{
//		mSoldier.PlaySpeech (SPEECH_SquadRadioCheck);
		mSquadManager.ReachedGoal (mSoldier);
//		mSoldier.setCollisionSize (mSoldier.collisionRadius / 2, mSoldier.collisionHeight);
		GotoState( 'WaitingForAssault' );
	} // if
	else
	{
		mSquadManager.FailedGoal (mSoldier);
		GotoState( 'Idle' );
	} // else

}

///////////////////////////////////////////////////////////////////////////////
// STATE WaitingForAssault
//
state WaitingForAssault extends Idle
{
	ignores WeaponPointedAt,
			SetFocus,
			SetFocalPoint,
			SetFocalPointFromDir,
			NotifyBump,
			ReactToGrenade,
			SeePlayer;

	function bool IsStackingUp()
	{
		return true;
	}

	function EndState ()
	{
		stopMultiTimer (mAssaultTimer);
		stopMultiTimer (mTargetCheckTimer);
	} // EndState

	function BeginState ()
	{
		mPaused = false;
	} // EndState

	event MultiTimer (int TimerIndex)
	{
		if (TimerIndex == mAssaultTimer)
		{
			GoGoGo ();
			StopMultiTimer (TimerIndex);
			mPaused = false;
		} // if
		else if (TimerIndex == mTargetCheckTimer)
		{
			// Use this update to see if 'go' has been sent yet
			if (mSquadManager.GoGoGoSent (mSoldier) > 0)
			{
				GoGoGo (mSquadManager.GoGoGoSent (mSoldier));
			} // if

			if (checkForTargets ())
			{
				stopMultiTimer (mTargetCheckTimer);		// Turn timer off
				return;
			} // if
		} // if
		else
		{
			global.MultiTimer (TimerIndex);
		} // else
	} // MultiTimer

	// This gets called once the door has been breached / opened
	function GoGoGo (optional float pause)
	{
		local SASDominationPoint goalDP;

		if (IsIncapacitated ())
		{
			return;
		} // if

		setMultiTimer (mIgnoreGrenadeTimer, 5.0, false);
		mbIgnoreGrenades = true;

		if (pause > 0)
		{
			if (!mPaused)
			{
				SetMultiTimer (mAssaultTimer, pause, false);
				mPaused = true;
			} // if
			return;
		} // if
		mPaused = false;

		if (mSquadManager.mAssaultEP == None)
		{
			return;
		} // if

		SetStackupMode (SASSTACK_None);

		// Ignore bumps for the next three seconds. Retain shrunken collision cylinder
		mSoldier.setCollisionSize (mSoldier.collisionRadius / 2, mSoldier.collisionHeight);
		ignoreDoorBumps (3);
		ignorePawnBumps (3);

		// TODO: Vol to assault should be one on opposite side to EP stacking up side. 
		if (mSquadManager.mAssaultVolume != None)
		{
			if (mSquadManager.SoldierIsPartOfRoomAssault (mSoldier) == ROOMASS_ASSAULT_PRIMARY)
			{
				goalDP = mSquadManager.mAssaultVolume.GetSecondClosestDominationPointToActor (mSquadManager.mAssaultEP, DPCF_OCCUPIED);
			} // if
			else
			{
				goalDP = mSquadManager.mAssaultVolume.GetClosestDominationPointToActor (mSquadManager.mAssaultEP, DPCF_OCCUPIED);
			} // else

			if ((goalDP != None) && (AcquireDominationPoint (goalDP)))
			{
				// Send wingman there at a charge, ignoring enemies and not reassessing our goal at all
				ignoreEnemy (true);
				mNoReassessment = true;
				SetObjective (SASOBJ_MoveToFirstDP, None);
				mSquadManager.notifyFirstDP (mSoldier, goalDP);
			} // if
		} // if

		mSquadManager.GoAcknowledge (mSoldier);
	} // GoGoGo

	function ChooseAction ()
	{
		// If assault has been abandoned, we'll find out here
		if (mSquadManager.mBackupSquadMode == BSM_INTERIOR_BACKUP ||
			mSquadManager.mBackupSquadMode == BSM_INTERIOR_FOLLOW)
		{
			SetObjective (SASOBJ_Idle, None);
		} // if
	} // ChooseAction

Begin :
	setMultiTimer (mTargetCheckTimer, 0.2, true);		// Turn timer on to check for targets
	mSoldier.ChangeAnimation ();
} // WaitingForAssault


///////////////////////////////////////////////////////////////////////////////
// STATE MovingToDominationPoint
//
state MovingToDominationPoint extends MovingState
{
	Ignores weaponPointedAt;

	event EndState()
	{
		Super.EndState();

		mSASPawn.SetPace( PACE_Running );

		// Stop per-frame checking of changes to pawn's assault volume. 
		MonitorAssaultVolChange( false );

		ignoreEnemy (false);

		stopMultiTimer (mMoveReassessTimer);
	}

	function bool inMovingState ()
	{
		return true;
	} // inMovingState

	function ReachedPathIntermediatePoint(
		Actor	aReachedPoint )
	{
		ReassessGoal();
		//SetTimer( 0.1, true );
		mTimerCounter = 0;
	}

	event multiTimer (int timerID)
	{
		switch (timerID)
		{
			case mMoveReassessTimer :
				mTimerCounter++;

				// Don't reassess every tick
				if (mTimerCounter == 10)
				{
					ReassessGoal();
					mTimerCounter = 0;
				} // if
				break;

			default :
				global.multiTimer (timerID);
		} // switch
	} // multiTimer

	// Reassess suitability of current target DP.
	function ReassessGoal()
	{
		local SASSoldier			playerPawn;
		local float					maxRange;
		local SASDominationPoint	newDP;
		local bool					cacheIgnoreEnemy;

		// Ensure target still alive
		CheckFocusTarget ();

		// In room assaults, don't reassess - go where we're told
		if (mbIgnoreEnemy)
		{
			return;
		} // if

		// If we've seen a target ...
		if (checkForTargets ( true ))
		{
			return;
		} // if

		// If we've been told to go here and not reassess for ourselves, go no further
		if (mNoReassessment)
		{
			return;
		} // if

		playerPawn = mSquadManager.GetClosestPlayerToOther( mSoldier );

		if ( mbOnOffensive )
		{
			maxRange = DP_MAX_PLAYER_RANGE_OFFENSIVE;
		}
		else
		{
			maxRange = DP_MAX_PLAYER_RANGE_DEFENSIVE;
		}

		if ( !IsDominationPointValid( playerPawn, maxRange ) )
		{
			mSquadManager.SelectBackupSquadDP ();
			newDP = mSquadManager.getBackupDP (mSoldier);
			if ( (newDP != None) && AcquireDominationPoint( newDP ) )
			{
				cacheIgnoreEnemy = mbIgnoreEnemy;
				SetObjective( SASOBJ_MoveToDP, None );
				ignoreEnemy (cacheIgnoreEnemy);
			}
		}

		// If we're within four feet of the player and we're supposed to be stacking up, shout go
		if (mbIsWingman &&
			mWingmanAssaultEP != mWingmanLastGoEP &&
			mWingmanAssaultEP.hasValidStackup () &&
			mWingmanAssaultEP != mSquadManager.mAssaultEP)
		{
			if (VSizeSq (PlayerPawn.Location - mSoldier.Location) < Square (64))
			{
				mSoldier.mVoice.PlaySpeech (mSoldier, SPEECH_SquadGo);
				mWingmanLastGoEP = mWingmanAssaultEP;
			} // if
		} // if
	}


	function CheckMovementPace()
	{
		local bool	bAssaulting;	
		local float	distSq;

		// Always charge to first DP in an assault.
		if ( GetObjective() ==  SASOBJ_MoveToFirstDP )
		{
			mSoldier.SetPace( PACE_Charging );
		}
		else
		{
			// If not assaulting and far from player then charge.
			if ( mbIsWingman )
			{
				bAssaulting = (mWingmanAssaultVolume != None);
			}
			else
			{
				bAssaulting = (mSquadManager.mBackupSquadMode == BSM_INTERIOR_ASSAULT);
			}

			distSq = VSizeSq( mSoldier.Location - mDominationPoint.Location );
			
			if ( !bAssaulting )
			{
				// Charge depending on dist to DP.
				if ( distSq > Square( 750.0 ) )
				{
					mSoldier.SetPace( PACE_Charging );
				}
				else
				{
					mSoldier.SetPace( PACE_Running );
				}
			}
			else
			{
				if ( distSq > Square( 75.0 ) )
				{
					mSoldier.SetPace( PACE_Running );
				}
				else
				{
					mSoldier.SetPace( PACE_Walking );
				}
			}
		}
	}

Begin:

	// Monitor changing assault volume.
	MonitorAssaultVolChange( true );

	setMultiTimer (mMoveReassessTimer, 0.1, true);
	mTimerCounter = 0;

	// If I'm in backup squad, set pace to charging if not assaulting a room
	// and at a large distance from the player.
	
	CheckMovementPace();
		
	if (target != None)
	{
		DoMoveToActor( 
			mDominationPoint,
			mSoldier.mePace,
			STANCE_Standing,
			Target);
	} // if

	// If we don't have a target them look towards the closest non-visible enemy
	else /*if (mSquadManager.SoldierIsPartOfRoomAssault (mSoldier) != ROOMASS_NONE)*/
	{
		DoMoveToActor( 
			mDominationPoint,
			mSoldier.mePace,
			STANCE_Standing,
			mSoldier.getClosestEnemyInVolume ());
	} // else

MTP_FinishedMove:

	// Turn off charging on reaching DP.
	mSASPawn.SetPace( PACE_Running );

	ignoreEnemy (false);
	if ( mbFailedMoveToPoint )
	{
		Sleep( 0.5 );
	} // if

	SetObjective( SASOBJ_Idle, None );
}


//---------------------------------------------------------------------------------
//
function setUnobstructedFacing ()
{
	CalculateUnobstructedFacing ();
	SetFocalPointFromDir( mLastFacing );
} // setUnobstructedFacing

//---------------------------------------------------------------------------------
// Returns TRUE if this point isn't near to any other squad members
function bool pointClearOfSquad (Vector position)
{
	local int i;
	local float threshold;

	threshold = Square (mSoldier.default.CollisionRadius * 2.2);

	for (i = 0; i < 4; i++)
	{
		if (mSquadManager.mAISquadMembers [i] != None && mSquadManager.mAISquadMembers [i] != mSoldier)
		{
			if (VSizeHorizSq (mSquadManager.mAISquadMembers [i].Location - position) < threshold)
			{
				return false;
			} // if
		} // if
	} // for

	return true;
} // pointClearOfSquad
//---------------------------------------------------------------------------------
function bool pointClearOfStackUps (Vector position)
{
	local float threshold;
	local SASAssaultVolume AV;
	local int side;

	if (mWingmanAvoidEP == None)
	{
		return true;
	} // if

	threshold = Square (mSoldier.default.CollisionRadius * 2.2);
	AV = mSoldier.getAssaultVolume ();

	// Ensure that this position doesn't overlap the stack-up points of the specified EP
	if (AV == mWingmanAvoidEP.mAssaultVolLinks [0])
	{
		side = 0;
	} // if
	else
	{
		side = 1;
	} // else

	// If stack-ups aren't valid, go no further
	if (!mWingmanAvoidEP.hasValidStackup ())
	{
		LogHuman ("EP " $mWingmanAvoidEP$ " has invalid stack up positions");
		return true;
	} // if

	// If distance from point to stackups is < threshold, can't use it
	if (VSizeHorizSq (mWingmanAvoidEP.mStackUpParams [side].Positions [0] - position) < threshold)
	{
		return false;
	} // if
	if (VSizeHorizSq (mWingmanAvoidEP.mStackUpParams [side].Positions [1] - position) < threshold)
	{
		return false;
	} // if

	return true;
} // pointClearOfStackUps
//---------------------------------------------------------------------------------
// Lots of checks to see if this point is valid for what we are trying to do
function bool pointUnobstructed (Vector position)
{
	if (!mSquadManager.mPlayerVolume.EncompassesPoint (position))
	{
		return false;
	} // if

	if (!pointClearOfStackUps (position))
	{
		return false;
	} // if

	if (!pointClearOfSquad (position))
	{
		return false;
	} // if

	//if (!pointClearOfOwnedDPs (position))
	//{
	//	return false;
	//} // if

	return true;
} // pointUnobstructed
//---------------------------------------------------------------------------------
//
// Check the suitability of a pair of points as wingman track points. Return 0 if
// neither, 1 if left point or 2 if right point is best
function int CheckTrackPointPair(
		Vector	aTestPoint1,
		Vector	aTestPoint2)
{
	local float		point1Dist;
	local float		point2Dist;
	local Vector	temp;
	local bool		swap;

	// Find closest of these two and make it p1
	point1Dist = VSizeSq( aTestPoint1 - Pawn.Location );
	point2Dist = VSizeSq( aTestPoint2 - Pawn.Location );

	swap = false;
	if (point2Dist < point1Dist)
	{
		temp = aTestPoint1;
		aTestPoint1 = aTestPoint2;
		aTestPoint2 = temp;
		swap = true;
	} // if

	// Start by checking the closer point. Check that it isn't near to an entry point and
	// that this soldier has a clear run to it
	if (!PointCloseToEntryPoint (aTestPoint1) &&
		pointUnobstructed (aTestPoint1) &&
		PointReachable (aTestPoint1))
	{
		if (swap)
			return 2;
		else
			return 1;
	} // if

	// If this point isn't any good, look at the further one.
	else
	{
		if (!PointCloseToEntryPoint (aTestPoint2) &&
			pointUnobstructed (aTestPoint2) &&
			PointReachable (aTestPoint2))
		{
			if (swap)
				return 1;
			else
				return 2;
		} // if
	} // else

	return 0;
} // CheckTrackPointPair

//---------------------------------------------------------------------------------
function bool FindTrackingOffsetLocation(
	Pawn	aPlayerPawn)
{
	local Vector	playerPos;
	local Rotator	testRotn;
	local Rotator	playerRotn;
	local Vector	testPoint1, testPoint2;
	local int		pointID;

	// Cache player location and rotation for easy access
	playerRotn			= aPlayerPawn.Rotation;
	playerRotn.Roll		= 0;
	playerRotn.Pitch	= 0;
	playerPos			= aPlayerPawn.Location;

	// Start by trying the points to the rear right and rear left of the player. Choose the closest
	// one of these we can reach.
	
	// Find point 1, rear right.
	testRotn = playerRotn;
	testRotn.Yaw += Degrees (135);
	testPoint1 = playerPos + (Vector (testRotn) * WINGMAN_TRACKING_DISTANCE);

	// Find point 2, rear left.
	testRotn = playerRotn;
	testRotn.Yaw -= Degrees (135);
	testPoint2 = playerPos + (Vector (testRotn) * WINGMAN_TRACKING_DISTANCE);

	pointID = CheckTrackPointPair (testPoint1, testPoint2);
	if (pointID == 1)
	{
		mWingmanTrackPoint = testPoint1;
		return true;
	} // if
	else if (pointID == 2)
	{
		mWingmanTrackPoint = testPoint2;
		return true;
	} // if

	// So our first choice points weren't any good - try directly to the left and right of the player.

	// Find point 1, right.
	testRotn = playerRotn;
	testRotn.Yaw += Degrees (90);
	testPoint1 = playerPos + (Vector (testRotn) * WINGMAN_TRACKING_DISTANCE);

	// Find point 2, left.
	testRotn = playerRotn;
	testRotn.Yaw -= Degrees (90);
	testPoint2 = playerPos + (Vector (testRotn) * WINGMAN_TRACKING_DISTANCE);

	pointID = CheckTrackPointPair (testPoint1, testPoint1);
	if (pointID == 1)
	{
		mWingmanTrackPoint = testPoint1;
		return true;
	} // if
	else if (pointID == 2)
	{
		mWingmanTrackPoint = testPoint2;
		return true;
	} // if

	// Not doing very well. Try directly behind.
	testRotn = playerRotn;
	testRotn.Yaw += Degrees (180);
	testPoint1 = playerPos + (Vector (testRotn) * WINGMAN_TRACKING_DISTANCE);

	if (!PointCloseToEntryPoint (testPoint1) && PointReachable( testPoint1 ))
	{
		mWingmanTrackPoint = testPoint1;
		return true;
	} // if

	// Almost last chance - try left and right in front of the player
	testRotn = playerRotn;
	testRotn.Yaw += Degrees (45);
	testPoint1 = playerPos + (Vector (testRotn) * WINGMAN_TRACKING_DISTANCE);

	// Find point 2, left.
	testRotn = playerRotn;
	testRotn.Yaw -= Degrees (45);
	testPoint2 = playerPos + (Vector (testRotn) * WINGMAN_TRACKING_DISTANCE);

	pointID = CheckTrackPointPair (testPoint1, testPoint1);
	if (pointID == 1)
	{
		mWingmanTrackPoint = testPoint1;
		return true;
	} // if
	else if (pointID == 2)
	{
		mWingmanTrackPoint = testPoint2;
		return true;
	} // if

	// This is absolutely the last chance - directly in front of the player. We don't like this one
	// because it obstructs the player's LoS but if this is the only point left ....
	testRotn = playerRotn;
	testPoint1 = playerPos + (Vector (testRotn) * WINGMAN_TRACKING_DISTANCE);

	if (!PointCloseToEntryPoint (testPoint1) && PointReachable (testPoint1))
	{
		mWingmanTrackPoint = testPoint1;
		return true;
	} // if

	return false;
} // FindTrackingOffsetLocation

//---------------------------------------------------------------------------------
function bool FindPlayerTrackPoint()
{
	local SASSoldier			playerPawn;
	local NavigationPoint		reachableNP;
	local SASDominationPoint	DP;

	playerPawn = mSquadManager.GetWingmansPlayer( mSoldier );
	if ( playerPawn == None )
	{
		return false;
	}

	// By default, tracking position threshold dist is zero.
	mWingmanTrackPointThreshold = 0.0;

	// If already have a DP and its valid for tracking then keep it.
	if (	mDominationPoint != None &&
			PointUnobstructed( DP.Location ) &&
			VSizeHorizSq( DP.Location - playerPawn.Location ) < Square( 500.0 ) )
	{
		mWingmanTrackPoint = DP.Location;
		return true;
	}

	// Give up any DP we already have.
	if ( mDominationPoint != None )
	{
		RelinquishDominationPoint();
		mDominationPoint = None;
	}

	// Look for closest DP to player - use if within tracking distance
	DP = playerPawn.GetAssaultVolume().GetClosestDominationPointToPosition(
		playerPawn.Location, 
		DPCF_OCCUPIED );

	if (	DP != None && 
			PointUnobstructed( DP.Location ) &&
			VSizeSq( DP.Location - playerPawn.Location ) < Square( 500.0 ) )
	{
		AcquireDominationPoint( DP );
		mWingmanTrackPoint = DP.Location;
		return true;
	} 

	// If we can't reach the player directly, then find path towards.
	if ( !ActorReachable( playerPawn, false, false ) )
	{
		// Try to find path directly towards player. If that fails, try to 
		// move to a navigation point close to the player.
		//
		if ( FindPathToward( playerPawn ) != None )
		{
			mWingmanTrackPoint = playerPawn.Location;
			mWingmanTrackPointThreshold = 64.0;
			return true;
		}
		else
		{
			reachableNP = GetClosestReachableNavTo( playerPawn );
			if (	reachableNP != None &&
					PointUnobstructed (reachableNP.Location))
			{
				mWingmanTrackPoint = reachableNP.Location;
				return true;
			}
		}
	} 

	// Player is directly reachable, try to find a suitable offset position.
	if ( !FindTrackingOffsetLocation( playerPawn ) )
	{
		// If we can't find one, use the DP we found earlier regardless of how far it is from the player
		if ( DP != None && PointUnobstructed( DP.Location ) )
		{
			AcquireDominationPoint( DP );
			mWingmanTrackPoint = DP.Location;
		}

		return true;
	}

	// If this point is very close to a DP, use the DP instead and mark the DP as ours
	DP = mSoldier.GetAssaultVolume().GetClosestDominationPointToPosition(
		mWingmanTrackPoint, 
		DPCF_OCCUPIED );
	if (	DP != None && 
			VSizeHorizSq( DP.Location - mWingmanTrackPoint ) < WINGMAN_DP_CAPTURE_THRESHOLD )
	{
		AcquireDominationPoint (DP);
	} 
	else
	{
		if (mDominationPoint != None)
		{
			RelinquishDominationPoint ();
			mDominationPoint = None;
		}
	} 
		
	return true;
}

///////////////////////////////////////////////////////////////////////////////
// STATE WingmanTrackPlayer
//
function doWingmanTrackPlayer (optional SASEntryPoint keepClear)
{
	// Only do this if the rest of the squad aren't stacking up on this EP
	if (mSquadManager.mBackupSquadMode == BSM_INTERIOR_STACKUP ||
		 mSquadManager.mBackupSquadMode == BSM_INTERIOR_ASSAULT)
	{
		mWingmanAvoidEP = mSquadManager.mAssaultEP;
	} // if
	else
	{
		mWingmanAvoidEP = keepClear;
	} // else

	// Clear our player tracking EP
	//mWingmanAssaultEP = None;
	//mWingmanAssaultVolume = None;
	SetStackupMode (SASSTACK_None);

	SetObjective (SASOBJ_WingmanTrackPlayer, None);
} // doWingmanTrackPlayer


state WingmanTrackPlayer extends MovingState
{
	function bool inMovingState ()
	{
		return true;
	} // inMovingState

	//---------------------------------------------------------------------------------
	// NotifyHitWall
	//
	event bool NotifyHitWall(
		vector	aHitNormal, 
		Actor	aWall )
	{
		// End tracking move on hitting wall.
		CompleteMove();
		return false;
	}

	//---------------------------------------------------------------------------------
	// weaponPointedAt
	//
	event weaponPointedAt (Pawn aWeaponOwner)
	{
		// Only take notice of this if we're stationary

		// Has DP
		if (mDominationPoint != None)
		{
			if (!mSoldier.ReachedDestination (mDominationPoint))
			{
				return;
			} // if
		} // if

		// Otherwise check player tracker location
		else
		{
			if (!mSoldier.ReachedDestination (mPlayerTracker))
			{
				return;
			} // if
		} // else

		Global.weaponPointedAt (aWeaponOwner);
	} // weaponPointedAt


	//---------------------------------------------------------------------------------
	// ChooseTrackingPace
	//
	function ChooseTrackingPace()
	{
		local SASSoldier	playerPawn;

		playerPawn = mSquadManager.GetWingmansPlayer( mSoldier );
		if ( playerPawn == None )
		{
			Pawn.SetPace( PACE_Walking );
			StopMoving();		
			return;
		}

		// Charge if really long way from player.
		if ( VSizeSq( Pawn.Location - playerPawn.Location ) > 102400 )	// (102400 = 20 feet)
		{
			Pawn.SetPace( PACE_Charging );
			return;
		} // if

		// Run if far from player.
		if ( VSizeSq( Pawn.Location - playerPawn.Location ) > 6400 )	// (6400 = 5 feet)
		{
			Pawn.SetPace( PACE_Running );
			return;
		} // if

		// Otherwise match player pace
		Pawn.SetPace (playerPawn.mePace);
	}

	//---------------------------------------------------------------------------------
	// Timer - use to re-evaluate situation
	//
	event Timer ()
	{
		ChooseTrackingPace();

		// Reassess where we are heading.
		if ( !isWingmanLargeVolumeTrackPointValid ( mPlayerTracker.Location ) )
		{
			// Restarting state to make wingman find new destination.
			GotoState( , '' );
		}
	}

	event bool NotifyBump(
		Actor	aBumped )
	{
		local SASPawn	bumpedPawn;

		bumpedPawn = SASPawn( aBumped );
		if ( bumpedPawn != None )
		{
			if ( bumpedPawn == mSquadManager.GetWingmansPlayer( mSoldier ) )
			{
				SetObjective( SASOBJ_Idle, None );
			}
		}

		return Super.NotifyBump( aBumped );
	}


Begin:

	// HACK - Should be using move to location functionality rather than use an actor object.
	if ( mPlayerTracker == None )
	{
		mPlayerTracker = Spawn( class'SASMoveTarget' );
	} // if

	
	// Seek tracking point.
	if (FindPlayerTrackPoint ())
	{
		ChooseTrackingPace ();

		// Set timer to reassess tracking location.
		SetTimer( 1.0, true );

		// Move to tracking point.
		if (mDominationPoint != None)
		{
			if (mSoldier.ReachedDestination (mDominationPoint) == false)
			{
				DoMoveToActor( mDominationPoint, Pawn.mePace, STANCE_Standing,,, mWingmanTrackPointThreshold );
			} // if
			else
			{
				Sleep( 0.0 );
				SetObjective( SASOBJ_Idle, None );
				Stop;
				//doDefaultStationaryBehaviour ();
				//BeginQuartering();
			} // else
		} // if
		else
		{
			mPlayerTracker.SetLocation ( mWingmanTrackPoint );
			if (mSoldier.ReachedDestination (mPlayerTracker) == false)
			{
				DoMoveToActor( mPlayerTracker, Pawn.mePace, STANCE_Standing,,, mWingmanTrackPointThreshold );
			} // if
			else
			{
				Sleep( 0.0 );
				SetObjective( SASOBJ_Idle, None );
				Stop;
			} // else
		} // else
	}
	else
	{
		StopMoving();
		Sleep( 0.5 );
		SetObjective( SASOBJ_Idle, None );
	} // else

MTP_FinishedMove:

	if (mbFailedMoveToPoint)
	{
		Sleep( 0.5 );
	} // if

	Sleep( 0.0 );
	SetObjective( SASOBJ_Idle, None );
} // STATE WingmanTrackPlayer


///////////////////////////////////////////////////////////////////////////////
// STATE Attacking
//
state Attacking
{
	ignores HearNoise,
			DoWingmanStackup;

	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	//
	event BeginState()
	{
		StopMultiTimer( mTimerReassess );
	}

	///////////////////////////////////////////////////////////////////////////////
	// EndState
	//
	function EndState()
	{
		SetTimer( 0.0, false );
		stopMultiTimer (mAttackTimer);

		if ( mSoldier != None )
		{
			mSoldier.mInterestItem = None;
			mSoldier.mInhibitHeadMovement = false;
		}

		StopMultiTimer( mTimerReassess );
	} // EndState


	///////////////////////////////////////////////////////////////////////////////
	// Timer
	//
	// Reassess location relative to player and switch to moving state if required.
	event Timer()
	{
		local SASSoldier			playerPawn;

		if (Enemy == None)
		{
			Target = None;
			SetObjective( SASOBJ_Idle, None );
			return;
		} // if

		checkForHostageStandoffAudio ();

		// GP: This doesnt work very well - all that happens is the wingman goes back into attacking as soon as he sees a
		// target again.
		if ( mbIsWingman )
		{
			playerPawn = mSquadManager.GetWingmansPlayer( mSoldier );
			
			if ( playerPawn != None )
			{
				if ( VSizeHorizSq( playerPawn.Location - Pawn.Location) > Square( WINGMAN_MAX_ATTACKING_DIST2D ) )
				{
					EndQuartering();
					doWingmanTrackPlayer ();
					return;
				}
			}
		}
	}

	event MultiTimer(
		int aTimerIdx )
	{
		local Actor	newTgt;
		switch ( aTimerIdx )
		{
		case mTimerReassess:
			if ( SASTerrorist(Target).mHostageTarget == None )
			{
				SetWeaponFireMode ('FIREMODE_Single');
				mWeaponFired = false;
				StartRepeatFiring (1);			// two rounds for double-tap - one at a time
				SetMultiTimer (mAttackTimer, mDoubleTapDelay, true);
				mbInDoubleTap = true;

				StopMultiTimer( mTimerReassess );
			}
			else
			{
				// Choose new best target.
				newTgt = mSquadManager.SelectTarget( mSoldier );
				if ( newTgt != Target )
				{
					SetObjective (SASOBJ_AttackEnemy, newTgt );
				}
			}
			break;

		default:
			Global.MultiTimer( aTimerIdx );
		}
	}


	event TargetLost()
	{
		if ( mSASPawn.IsAThreat (SASPawn (Enemy)))
		{
			Target = Enemy;
		} // if
		else
		{
			Target = None;
			SetObjective( SASOBJ_Idle, None );
		} // else
	} // TargetLost

	///////////////////////////////////////////////////////////////////////////////
	//
	// NotifyWeaponFired 
	function notifyWeaponFired ()
	{
		mWeaponFired = true;
	} // notifyWeaponFired

	///////////////////////////////////////////////////////////////////////////////
	// NotifyLineOfFireBlocked
	// 
	event NotifyLineOfFireBlocked ()
	{
		SetObjective (SASOBJ_Idle, None);
	} // if

Begin:

	// Set timer to reassess location relative to player.
	SetTimer( 0.5, true );

	// Ensure that this enemy is the prime focus of our attention
	//mSASPawn.setSpineTwist (0);
	mSASPawn.mInterestItem = Enemy;
	mSASPawn.mInterestAngle = 0;
	mSASPawn.mInhibitHeadMovement = true;
	Focus = Enemy;
	StopMoving ();

	// Start firing.
	Target = Enemy;

	// If this is a terrorist threatening a hostage or using one as a human shield, he's not valid as a
	// squad target
	if ((SASTerrorist (Target) != None && SASTerrorist (Target).mHostageTarget == None) ||
		SASTarget (Target) != None)
	{
		SetWeaponFireMode ('FIREMODE_Single');
		mWeaponFired = false;
		StartRepeatFiring (1);			// two rounds for double-tap - one at a time
		SetMultiTimer (mAttackTimer, mDoubleTapDelay, true);
		mbInDoubleTap = true;
	} // if
	else
	{
		SetMultiTimer( mTimerReassess, 0.25, true );
	}

	Enable ('EnemyNotVisible');
} // Attacking


//-----------------------------------------------------------------------------
//
// Door breaching state for taking out door hinges with Hatton round
//
// Start by getting into position and signalling to squad manager, then wait for "Go!"
// Once we've got the go signal, take out the door hinges using the shotgun and then
// revert to normal behaviour (idle state)
//
function bool doDoorBreach ()
{
	if (IsIncapacitated ())
	{
		LogHuman ("Incapacitated trooper " $mSoldier$ " ordered to do door breach");
		return false;
	} // if

	if (mSquadManager.mAssaultDoor != None)
	{
		SetObjective (SASOBJ_DoorBreach, mSquadManager.mAssaultDoor);
		if (calculateDoorBreachPosition () == false)
		{
			return false;
		} // if

		// If we're the wingman and currently involved in a room assault, cancel it
		if (mbIsWingman)
		{
			mWingmanAssaultVolume = None;
			mWingmanAssaultEP = None;
		} // if

		// Select our shotgun if necessary
		if (mSquadManager.mAssaultDoor.mbLocked)
		{
			if (mSASPawn.SelectWeapon (WPNCAT_Special) == false)
			{
				mSoldier.PlaySpeech (SPEECH_SquadAcknowledgeNo);
				return false;
			} // if
		} // if
		if (!mOrderAcknowledged)
		{
			mSASPawn.PlayDelayedSpeech( SPEECH_SquadAcknowledgeYes, false );
		} // if
		mOrderAcknowledged = true;
		return true;
	} // if
	
	mSoldier.PlaySpeech (SPEECH_SquadAcknowledgeNo);
	return false;
} // doDoorBreach

function bool calculateDoorBreachPosition ()
{
	//local vector p1, p2;
	//local SASDoorMover door;
	//local vector doorBoxMin, doorBoxMax;
	local SASEntryPoint EP;

	if (mCurrentObjective.ObjectiveType != SASOBJ_DoorBreach ||
		SASDoorMover (mCurrentObjective.TargetPoint) == None)
	{
		return false;
	} // if

	EP = mSquadManager.mAssaultEP;
	if (EP == None)
	{
		return false;
	} // if

	if (mSquadManager.mAssaultFromVolume == EP.mAssaultVolLinks [0])
	{
		if (EP.mBreachPosition [0].X == 0 && EP.mBreachPosition [0].Y == 0 && EP.mBreachPosition [0].Z == 0)
		{
			LogHuman ("EP " $EP$ " needs breach positions populating");
			return false;
		} // if
		mAssaultPoint.SetLocation (EP.mBreachPosition [0]);
	} // if
	else
	{
		if (EP.mBreachPosition [1].X == 0 && EP.mBreachPosition [1].Y == 0 && EP.mBreachPosition [1].Z == 0)
		{
			LogHuman ("EP " $EP$ " needs breach positions populating");
			return false;
		} // if
		mAssaultPoint.SetLocation (EP.mBreachPosition [1]);
	} // else

	return true;
} // calculateDoorBreachPosition

// AnimNotifyEvent
event FireShotgun ();

state BreachDoor extends MovingState
{
	ignores NotifyBump,
			NotifyPlayerAboutToBump,
			DoStepAside,
			ReactToGrenade,
			SeePlayer,
			WingmanMonitorPlayerPosition,
			PlayerChangedAssaultVolumes;

	function BeginState ()
	{
		Super.BeginState();

		mBreachFiring = false;
		mDoorShotCount = 0;
		mFireShotgunCount = 0;

		if ( !mSASPawn.SelectWeapon( WPNCAT_Special ) )
		{
			mSquadManager.FailedGoal( mSoldier );
		}
	} // BeginState

	function EndState ()
	{
		Super.EndState();

		StopMultiTimer (mAssaultTimer);
		setMultiTimer (mIgnoreGrenadeTimer, 5.0, false);
		mbIgnoreGrenades = true;

		if ( mSoldier != None )
		{
			mSoldier.EndPlayActionAnim(0.35);
		}
	}

	function bool inMovingState ()
	{
		return true;
	} // inMovingState

	// This is called when we're ready to shoot the door. Go into the special 3-shot door
	// animation, using notify triggers to fire the weapon.
	function GoGoGo (optional float pause)
	{
		if (IsIncapacitated ())
		{
			return;
		} // if

		if (mBreachFiring || mSquadManager.mbDoorIsOpen)
		{
			 return;
		} // if

		// Paranoia check - ensure anim has correct notify
		if (mSASPawn.hasAnimNotify ('Kneel_ShootDoor_Maruzen', 'FireShotgun') == false)
		{
			LogHuman ("ERROR - soldier " $Pawn$ " missing FireShotgun notify in ShootDoor anim");
		} // if

		ignoreEnemy (true);

		// If door is locked, blow it away
		if (mSquadManager.mAssaultDoor.mbLocked)
		{
			mSASPawn.EndPlayActionAnim (0.0);
			mSASPawn.PlayActionAnim ('Kneel_ShootDoor_Maruzen', 1.0, 0.15, false );
			mBreachFiring = true;

			// Hackety-hack. Reset door strength to default so that it blows after the third shot (otherwise doors
			// which are partially damaged could blow after 1/2 shots while we keep on firing - which looks odd)
			mSquadmanager.mAssaultDoor.resetHealth ();
		} // if

		// Otherwise simply open it
		else
		{
			mSquadManager.mAssaultDoor.Trigger( self, Pawn );
			if (mSquadManager.mAssaultDoor.mDoubleDoorLink != None)
			{
				mSquadManager.mAssaultDoor.mDoubleDoorLink.Trigger( self, Pawn );
			} // if

			mSquadManager.ReachedGoal (mSoldier);
			SetObjective (SASOBJ_Idle, None);
		} // else
	} // GoGoGo

	// When animation ends, set ourselves as Idle
	function AnimEnd (int channel)
	{
		if ((channel == ANIMCHANNEL_ACTION || Pawn.GetCurrentAnim (ANIMCHANNEL_ACTION) == 'None') && mBreachFiring == true)
		{
			mSoldier.SetStance (STANCE_Crouched);
			mSASPawn.EndPlayActionAnim (0.15);
			mBreachFiring = false;

			SetObjective (SASOBJ_WingmanTrackPlayer, None);
			mSquadManager.ReachedGoal (mSoldier);

			// Put shotgun away
			mSoldier.SelectWeapon (WPNCAT_Primary);
		} // if
		else
		{
			mSASPawn.AnimEnd ( channel );
		} // else
	} // AnimEnd

	// AnimNotifyEvent
	event FireShotgun ()
	{
		mFireShotgunCount++;
		Pawn.Weapon.Botfire (false);

		// This is needed to guarantee that the door is taken out - the three shots don't always hit
		SetMultiTimer (mAssaultTimer, 0.1, false);
	} // FireShotgun

	event MultiTimer (int TimerIndex)
	{
		if (TimerIndex == mAssaultTimer)
		{
			// How it happens I don't know, but sometimes we end up with too many anim events, so must defend against array out-of-bounds ...
			if (mDoorShotCount < 3)
			{
				mSquadManager.mAssaultDoor.TakeDamage (100, mSoldier, mSquadManager.mAssaultDoor.getHingePosition (eDoorHinge (mDoorShotCount)), vect (0, 0, 0), class'Impact', Pawn.Weapon);
				mDoorShotCount++;
				if (mSquadManager.mAssaultDoor.isAlive () == false)
				{
					mSquadManager.mbDoorIsOpen = true;
				} // if
			} // if
			StopMultiTimer (mAssaultTimer);
		} // if
		else
		{
			global.MultiTimer (TimerIndex);
		} // else
	} // Timer

Begin :
	EndQuartering ();

	if (VSizeSq (mSoldier.Location - mAssaultPoint.Location) > 160000)	// 160000 = 8 metres
	{
		mSoldier.setPace (PACE_Charging);
	} // if
	else
	{
		mSoldier.setPace (PACE_Running);
	} // else

	DoMoveToActor (
		mAssaultPoint,			// Goal actor to move to.
		mSoldier.mePace,		// Walking or running (defaults to running)
		STANCE_Standing,		// Stance (defaults to normal standing).
		mCurrentObjective.TargetPoint,		// Focal actor during move.
		,						// Focal point during move.
		,						// Destination offset
		true);					// If true, must be precise on reaching goal location.

MTP_FinishedMove:
	// Wait
	SetFocus (mCurrentObjective.TargetPoint);
	SetFocalPointFromDir (mCurrentObjective.TargetPoint.Location - mSASPawn.Location);
	FinishRotation ();

	// Make sure we have enough ammo for this function. If not, reload
	if (SASWeapon (mSoldier.Weapon).mNumInMag < 3)
	{
		DoReloading ();
		Sleep( mSoldier.Weapon.GetAnimDuration( 0 ) );
	} // if

	// Tell squad manager we're here
	if (!mbFailedMoveToPoint)
	{
//		mSoldier.PlaySpeech (SPEECH_SquadRadioCheck);
		mSquadManager.ReachedGoal (mSoldier);
	} // if
	else
	{
		mSquadManager.FailedGoal (mSoldier);
	} // else

	//StopMoving();
	Goto ('');
} // BreachDoor

///////////////////////////////////////////////////////////////////////////////
// STATE MoveToLocation
//
state MoveToLocation extends MovingState
{	
	ignores WeaponPointedAt;

	event BeginState()
	{
		Super.BeginState();

		// Make sure timer not running at start.
		SetTimer( 0.0, false );
	} // BeginState

	event EndState()
	{
		Super.EndState();

		mSoldier.SetPace( PACE_Running );

		// Stop per-frame checking of changes to pawn's assault volume. 
		MonitorAssaultVolChange( false );

		stopMultiTimer (mMoveReassessTimer);
	} // EndState

	function bool inMovingState ()
	{
		return true;
	} // inMovingState

	event multiTimer (int timerID)
	{
		switch (timerID)
		{
			default :
				global.multiTimer (timerID);
				break;
		} // switch
	} // multiTimer


	function CheckMovementPace()
	{
		local bool	bAssaulting;	
		local float	distSq;

		// Always charge to first DP in an assault.
		if ( GetObjective() ==  SASOBJ_MoveToFirstDP )
		{
			mSoldier.SetPace( PACE_Charging );
		}
		else
		{
			// If not assaulting and far from player then charge.
			if ( mbIsWingman )
			{
				bAssaulting = (mWingmanAssaultVolume != None);
			}
			else
			{
				bAssaulting = (mSquadManager.mBackupSquadMode == BSM_INTERIOR_ASSAULT);
			}
			
			distSq = VSizeSq( mSoldier.Location - mCurrentObjective.TargetPoint.Location );

			if ( !bAssaulting )
			{
				// Charge depending on dist to tgt loc.
				if ( distSq > Square( 750.0 ) )
				{
					mSoldier.SetPace( PACE_Charging );
				}
				else
				{
					mSoldier.SetPace( PACE_Running );
				}
			}
			else
			{
				if ( distSq > Square( 100.0 ) )
				{
					mSoldier.SetPace( PACE_Running );
				}
				else
				{
					mSoldier.SetPace( PACE_Walking );
				}
			}
		}
	}

Begin:

	Enable ('Bump');

	// Monitor changing assault volume.
	MonitorAssaultVolChange (true);

	CheckMovementPace();

	DoMoveToActor ( 
		mCurrentObjective.TargetPoint,
		Pawn.mePace, 
		STANCE_Standing,,,,
		true);	// Precise move required.

MTP_FinishedMove:

	// Stop bump timer.
	SetTimer (0.0, false);

	GotoState ('Idle');
} // State MoveToLocation

//-----------------------------------------------------------------------------
// STATE SweepDP
//
// Wait at DP and sweep the extremities of the DP arc, using the large turn
// anims (90? and 180?) if necessary. State is complete when the DP has
// been swept from side to side once

// doSweepDP
//
// For the moment, defaults to DoGuard until the SweepDP state is complete
function doSweepDP ()
{
	if (isIncapacitated ())
	{
		return;
	} // if

	if (mDominationPoint == None)
	{
		LogHuman ("doSweepDP called on " $mSoldier$ " with no DP");
		return;
	} // if

	if (mSoldier.ReachedDestination (mDominationPoint) == false)
	{
		LogHuman ("doSweepDP called on " $mSoldier$ " when not at DP");
		return;
	} // if

	GotoState ('SweepDP');

	ignoreEnemy (false);
} // doSweepDP

State SweepDP
{
	ignores WeaponPointedAt;

	event EndState()
	{
		if ( mSoldier != None )
		{
			// If exitting the state when still sweeping then tidy uo rootmotion.
			if (mSoldier.Physics == PHYS_RootMotion)
			{
				mSoldier.EndPlayActionAnim (0.1);
				mSoldier.SetPhysics (PHYS_Walking);
		
				EndSweepStep();
			}

			// Reenable spine twisting.
			mSoldier.bIgnoreSpine = false;

			mSoldier.bIgnoreRootMotionTranslation = false;

			SetFocalPointFromDir( Vector( mDominationPoint.Rotation ) );
		}
		
		bControlAnimations = false;

		StopMultiTimer( mTargetCheckTimer );
	}


	function SelectInitialSweepDirection()
	{
		local int deltaRot;

		deltaRot = mDominationPoint.Rotation.Yaw - mSoldier.Rotation.Yaw;
		deltaRot = deltaRot & 65535;

		// Is soldiers yaw to left or right of the DP facing?
		if ( deltaRot < 32768 )
		{
			mSweepDirection = -1;
		}
		else
		{
			mSweepDirection = 1;
		}

		// Does the soldier's current yaw lie within the arc of domination? If not then
		// treat this sweep direction as done and sweep back the other way.
		if ( deltaRot > 32767 )
		{
			deltaRot -= 65535;
		}
		if ( iAbs( deltaRot ) > mDominationPoint.mArcOfDomination )
		{
			mbSweptFirstArc = true;
			mSweepDirection *= -1;
			mbSweepShortestAngle = false;
		}
	}


	function SelectSweepAnim()
	{
		local int	currentFacing, 
					requiredFacing,
					delta;

		mSoldier.bIgnoreSpine = true;

		currentFacing = mSoldier.Rotation.Yaw;

		// Find required facing and clamp to +/-360 degrees
		requiredFacing = mDominationPoint.Rotation.Yaw + mDominationPoint.mArcOfDomination * mSweepDirection;
		if ( requiredFacing > 65535 )
		{
			requiredFacing -= 65535;
		} 
		else if ( requiredFacing < -65535 )
		{
			requiredFacing += 65535;
		}
		requiredFacing = requiredFacing & 65535;

		// Should we be sweeping by shortest route?
		if ( mbSweepShortestAngle )
		{
			delta = requiredFacing - currentFacing;
			delta = delta & 65535;

			if ( delta > 32767 )
			{
				delta -= 65535;
			}
		} 
		// Otherwise we go by the direction of the DP arc.
		else
		{
			if ( mSweepDirection == -1 )
			{
				if ( requiredFacing > currentFacing )
				{
					requiredFacing -= 65535;
				}
				delta = requiredFacing - currentFacing;
			} 
			else
			{
				if (requiredFacing < currentFacing)
				{
					requiredFacing += 65535;
				} 
				delta = requiredFacing - currentFacing;
			} 

			while (delta > 65535)
			{
				delta -= 65535;
			}
			while (delta < -65535)
			{
				delta += 65535;
			} 
		} 

		mSweepAnimRate = 1.0;
		if ( delta < DEGREES( -25 ) )
		{
			if ( delta < DEGREES( -150 ) )
			{
				mSweepAnim = mSoldier.GetWeaponSpecificAnimName ("Stand_Rot180CCW");
				mSweepAngle = DEGREES (-180);
			} 
			else if (delta < DEGREES (-75))
			{
				mSweepAnim = mSoldier.GetWeaponSpecificAnimName ("Stand_Rot90CCW");
				mSweepAngle = DEGREES (-90);
			} 
			else
			{
				mSweepAnim = mSoldier.GetWeaponSpecificAnimName ("Stand_Rot25CCW");
				mSweepAngle = DEGREES (-25);
				mSweepAnimRate = 1.25;
			} 
		}
		else if ( delta > DEGREES( 25 ) )
		{
			if (delta > DEGREES (150))
			{
				mSweepAnim = mSoldier.GetWeaponSpecificAnimName ("Stand_Rot180CW");
				mSweepAngle = DEGREES (180);
			} 
			else if (delta > DEGREES (75))
			{
				mSweepAnim = mSoldier.GetWeaponSpecificAnimName ("Stand_Rot90CW");
				mSweepAngle = DEGREES (90);
			} 
			else
			{
				mSweepAnim = mSoldier.GetWeaponSpecificAnimName ("Stand_Rot25CW");
				mSweepAngle = DEGREES (25);
				mSweepAnimRate = 1.25;
			} 
		}
		// Use spine rotation for the last few degrees
		else
		{
			mSweepAnim = 'None';
			mSoldier.bIgnoreSpine = false;
			mSoldier.SetSpineTwist( delta );
		} 
	}


	function bool UpdateSweep()
	{
		SelectSweepAnim();
		mbSweepShortestAngle = true;

		if ( mSweepAnim == 'None' )
		{
			// If we haven't already swept the first extremity of the arc then we need to do so. Change
			// the direction of sweep and redetermine what we should do
			if ( !mbSweptFirstArc )
			{
				mbSweptFirstArc = true;
				mSweepDirection *= -1;
				mbSweepShortestAngle = false;		// Force long way round if necessary
				UpdateSweep();
			} 
			else if ( !mbSweptSecondArc )
			{
				mbSweptSecondArc = true;
				mSweepDirection = 0;
				UpdateSweep();
			} 
			else
			{
				// Mark DP as cleared.
				mDominationPoint.mbCleared = true;

				// If we have an invisible friend, mark his DP as cleared
				if ( mWingmanIFDP != None )
				{
					mWingmanIFDP.mbCleared = true;
				}

				return false;
			}
		}

		return true;
	}


	function BeginSweepStep()
	{
		mSoldier.PlayActionAnim( mSweepAnim, ROTATION_ANIM_SPEED * mSweepAnimRate, 0.15, false, false, true );
		bIgnoreRootMotionVertical = true; 
	}


	function EndSweepStep()
	{
		if ( mSoldier.Physics == PHYS_RootMotion )
		{
			mSoldier.EndPlayRootMotionAnim(
				mSoldier.GetWeaponSpecificAnimName( "Stand_Sighted" ),
				mSweepAngle );
			FixCurrentFacing();
		}
	}

Begin:

	// Make sure we're stood up.
	if ( mSoldier.meStance != STANCE_Standing )
	{
		DoStanceTransition( STANCE_Standing, GetStateName() );
	}

	// Init sweep data.
	mbSweptFirstArc			= false;
	mbSweptSecondArc		= false;
	mbSweepShortestAngle	= true;

	// From the direction we're currently facing, determine which end of the DP's arc we should start
	SelectInitialSweepDirection();
	
	// Turn off all sorts of stuff that interferes with our turning code.
	mSoldier.bIgnoreSpine = true;
	FixCurrentFacing();
	bControlAnimations = true;
	mSoldier.bIgnoreRootMotionTranslation = true;

	// Loop, selecting anims until we've finished the sweep
	while ( UpdateSweep() )
	{
		if ( mSweepAnim != 'None' )
		{
			BeginSweepStep();
			FinishAnim( ANIMCHANNEL_Action );
			EndSweepStep();
			Sleep( 0.1 );

			// Check for targets at the end of each sweep anim.
			CheckForTargets();
		}
		else
		{
			// If no sweep anim then we are do spine twist instead - give it a chance to move.
			Sleep( 0.1 );
		}
	}

	// Return to idle.
	SetObjective( SASOBJ_Idle, None );
}

//-----------------------------------------------------------------------------
//
// If we suddenly find ourselves with a valid target, attack it
function bool checkForTargets (
	optional bool abIgnoreBlockedLofTgt )
{
	local Actor bestTgt;

	// Ignore if we're currently ignoring targets
	if (mbIgnoreEnemy)
	{
		Enemy = None;
		Target = None;
		return false;
	} // if

	// If we've seen a target ...
	bestTgt = mSquadManager.SelectTarget( mSoldier );
	if (bestTgt != None)
	{
		if (	abIgnoreBlockedLofTgt &&
				(bestTgt == mLastLoFFailTarget) &&
				(mLastLoFFailTime > Level.TimeSeconds - 3.0) )
		{
			if ( VSizeSq( mSoldier.Location - bestTgt.Location ) > Square( 100.0 ) )
			{
				Enemy = None;
				Target = None;
				return false;
			}
		}
		// Stop and fire
		SetObjective (SASOBJ_AttackEnemy, bestTgt);
		return true;
	} // if
	else
	{
		Enemy = None;
		Target = None;
	} // else

	return false;
} // checkForTargets

//-----------------------------------------------------------------------------
// STATE Guard
//
// Wait at current position (which should be a DP) for a fixed time period and
// quarter
Function doGuard (float time)
{
	if (isIncapacitated ())
	{
		return;
	} // if

	setMultiTimer (mDelayTimer, time, false);
	GotoState ('Guard');

	ignoreEnemy (false);
} // doGuard

state Guard
{
	function EndState ()
	{
		stopMultiTimer (mDelayTimer);
		stopMultiTimer (mTargetCheckTimer);
	} // if

	event MultiTimer (int timerIndex)
	{
		switch (timerIndex)
		{
		case mDelayTimer:
			GotoState ('Idle');
			break;
		
		case mTargetCheckTimer:
			CheckForTargets();
			break;

		default:
			Global.MultiTimer (timerIndex);
		} 
	}

Begin:

	StopMoving();
	BeginQuartering();

	if ( mDominationPoint != None && mSoldier.ReachedDestination( mDominationPoint ) )
	{
		if (mSquadManager.mBackupSquadMode == BSM_INTERIOR_ASSAULT)
		{
			doDefaultStationaryBehaviour (true);
		} // if
		else
		{
			doDefaultStationaryBehaviour ();
		} 
	} 
	else
	{
		SetFocalPointFromDir (ChooseDirectionNotFacingWall (Vector (Rotation)));
	} // else

	// Timer to check for targets
	setMultiTimer (mTargetCheckTimer, 0.2, true);
} // STATE Guard


//-----------------------------------------------------------------------------
// STATE ThreatenHostage
//
// Point gun at hostage, shout occasionally
function bool checkForHostage ()
{
	local SASHostage h;

	h = mSquadManager.getAssignedHostage (mSoldier);

	// If we can see a hostage we might want to threaten / shout at him
	if (h != None && mSoldier.pawnIsVisible (h))
	{
		SetObjective (SASOBJ_ThreatenHostage, h);
		return true;
	} // else if

	return false;
} // if

state ThreatenHostage
{
	event EndState()
	{
		StopMultiTimer( mTargetCheckTimer );
		StopMultiTimer( mHostageUpdateTimer );
	}

	function UpdateState()
	{
		// Exit every second, allows a full idle update cycle
		if ( Level.Timeseconds - mLastHostageUpdate > 1.0 )
		{
			SetObjective( SASOBJ_Idle, None );
			return;
		} 

		// Shout every 5-15 seconds if hostage not prone
		// Coordinate with squad manager to ensure we don't get too many shouts
		if (mAssignedHostage.meStance != STANCE_Prone && !mAssignedHostage.mbCaptured)
		{
			if ( Level.Timeseconds - mLastHostageShout > mMinHostageShoutInterval)
			{
				if (FRand () * (mMaxHostageShoutInterval - mMinHostageShoutInterval) < (Level.Timeseconds - mLastHostageShout - mMinHostageShoutInterval) &&
					mSquadManager.getSquadShoutPermission ())
				{
					mSoldier.mVoice.PlaySpeech (mSoldier, SPEECH_SquadHostageGetDown);
					mLastHostageShout = Level.Timeseconds;
				} // if
			} // if
		} // if

		checkAim ();
	} // updateState

	function CheckAim()
	{
		local float		blend;
		local Vector	diff;
		local name		angleAnim;
		local float		desiredAim;

		// Set our pitch parameters to point at target, who could be prone or kneeling
		if ( mAssignedHostage.meStance != STANCE_Standing )
		{
			// Get pitch angle from shoulder to target.
			diff = Pawn.GetBoneLocation( NECK_BONE ) - GetAIAimLocation( Target );  
			desiredAim = Atan( diff.Z, VSizeHoriz( diff ) ) * 32767 / PI;
			desiredAim = Clamp( desiredAim, -mSoldier.MAX_AIM_PITCH, mSoldier.MAX_AIM_PITCH );

			mSoldier.mDesiredAimPitch = int(desiredAim);

			angleAnim = mSoldier.GetAimWeaponAnimName( mSoldier.mDesiredAimPitch );
			blend = FLOAT( IAbs( desiredAim ) ) / mSoldier.MAX_AIM_PITCH;

			mSoldier.AnimBlendParams (ANIMCHANNEL_AIMING, blend, 0, 0, FIRING_BLENDBONE, true);
			mSoldier.LoopIfNeeded (angleAnim, 0.0, 0.0, ANIMCHANNEL_AIMING);
		}
		else
		{
			ResetPitchAnimation();
		} 
	} 


	event MultiTimer(
		int timerID )
	{
		switch ( timerID )
		{
			case mTargetCheckTimer:
				CheckForTargets();
				break;

			case mHostageUpdateTimer:
				UpdateState();
				break;

			default :
				Global.MultiTimer( timerID );
				break;
		} 
	} 

Begin:

	// Ensure hostage is valid and visible
	if ( (mAssignedHostage == None) || !mSoldier.PawnIsVisible( mAssignedHostage ) )
	{
		SetObjective (SASOBJ_Idle, None);
		Stop;
	} 

	SetMultiTimer( mTargetCheckTimer, 0.2, true );
	SetMultiTimer( mHostageUpdateTimer, 0.45, true );
	CheckAim();
	mLastHostageUpdate = Level.TimeSeconds;
	SetFocus( mAssignedHostage );
}


//-----------------------------------------------------------------------------
// If we can see terrorist and he has a 'human shield' hostage, we might shout
function checkForHostageStandoffAudio ()
{
	local SASTerrorist	terrorist;
	local SASGameInfo	gi;

	// Allowed to shout yet?
	if (	((Level.TimeSeconds - mLastTerroristShout) < RandRange( mMinTerroristShoutInterval, mMaxTerroristShoutInterval )) ||
			!mSquadManager.GetSquadShoutPermission() )
	{
		return;
	}
	
	// Can we see a hostage within 10m ?
	gi = SASGameInfo( Level.Game );
	foreach gi.RadiusSASPawns( class'SASTerrorist', terrorist, mSoldier.Location, 500 )
	{
		if (	(terrorist.mHostageTarget != None) && 
				mSoldier.PawnIsVisible( terrorist ) )
		{
			mSoldier.mVoice.PlaySpeech (mSoldier, SPEECH_SquadHostageStandoff);
			mLastTerroristShout = Level.TimeSeconds;
			break;
		}
	} 
} // checkForHostageStandoffAudio


//-----------------------------------------------------------------------------
// FUNCTION drawSightLineDebug
function drawSightLineDebug (Canvas c)
{
	local vector screenPos;
	local vector eyePosn;

	if (Focus == None)
	{
		return;
	} // if

	eyePosn = mSoldier.Location + mSoldier.EyePosition () + vect (0, 0, 12);
	screenPos = Level.GetLocalPlayerController ().Player.Console.WorldToScreen (eyePosn);

	// Must be in front of camera
	if (screenPos.Z >= 1.f)
	{
		c.SetDrawColor (0, 255, 100);
		c.SetPos (screenPos.x, screenPos.y);
		c.DrawText ("Pace " $mSoldier.mePace);
	} // if
} // drawSightLineDebug

//-----------------------------------------------------------------------------
// FUNCTION drawSightLineOverlay
function drawSightLineOverlay (SASHud h)
{
	local Color colour;

	if (mbIsWingman)
	{
		colour = class'Canvas'.Static.MakeColor (0, 255, 100);
	} // if
	else
	{
		colour = class'Canvas'.Static.MakeColor (255, 100, 100);
	} // else

	if (isInState ('StackingUp') || isInState ('MoveToLocation'))
	{
		h.Draw3DLine (mSoldier.Location, mCurrentObjective.TargetPoint.Location, colour);
		h.Draw3DCylinder (mCurrentObjective.TargetPoint.Location, vect (0, 0, 1), 16, 16, 8, colour);
	} // if

	if (isInState ('MovingToDominationPoint'))
	{
		h.Draw3DLine (mSoldier.Location, mDominationPoint.Location, colour);
		h.Draw3DCylinder (mDominationPoint.Location, vect (0, 0, 1), 16, 16, 8, colour);
	} // if

	if (Focus != None)
	{
		h.Draw3DLine (mSoldier.Location + mSoldier.EyePosition (), Focus.Location, class'Canvas'.Static.MakeColor (0,100,255));
	} // if
	else if (FocalPoint != vect (0, 0, 0))
	{
		h.Draw3DLine (mSoldier.Location + mSoldier.EyePosition (), FocalPoint, class'Canvas'.Static.MakeColor (0,200,200));
	} // else

	if (mReactingToSound)
	{
		colour = class'Canvas'.Static.MakeColor (255, 200, 50);
		h.Draw3DLine (mSoldier.Location, mSoundPoint, colour);
		h.Draw3DCylinder (mSoundPoint, vect (0, 0, 1), 16, 16, 8, colour);
	} // if

	h.drawRoute (mSoldier);
} // drawSightLineOverlay
//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mMinTorchDelay=0.5000000
    mMaxTorchDelay=1.2500000
    mMinDoubleTapPause=0.2000000
    mMaxDoubleTapPause=0.4000000
    mDoubleTapDelay=0.1500000
    mMinHostageShoutInterval=5.0000000
    mMaxHostageShoutInterval=15.0000000
    mMinTerroristShoutInterval=3.0000000
    mMaxTerroristShoutInterval=5.0000000
    mNoiseTimeout=7.0000000
    mType=2
}