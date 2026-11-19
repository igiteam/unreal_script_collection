//=============================================================================
// SASHostageController.uc
//=============================================================================

class SASHostageController extends SASAIController
	native;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

//-----------------------------------------------------------------------------
// Constants
//

const PLAYER_TRACKING_DISTANCE						= 150.0;
const PLAYER_MAX_TRACKING_DIST2D					= 250.0;
const PLAYER_MAX_TRACKING_DIST2D_LARGE				= 500.0;
const PLAYER_TRACKING_MAX_HEIGHT_DIFF				= 250.0;

const REACT_TO_PLAYER_SIGHTING_MAX_DIST_OTHER_AV	= 700.0;
const REACT_TO_PLAYER_SIGHTING_MAX_DIST_SAME_AV		= 1000.0;

const SPEAK_TO_PLAYER_MIN_RANGE						= 150.0;	// ~3m
const SPEAK_TO_PLAYER_CHECKING_INTERVAL				= 2.0;

const MAX_TERRORIST_IDENTS_PER_AV					= 2;


//-----------------------------------------------------------------------------
// Enums
//

// List of actions (states) hostages can be in.
enum EHostageAction
{
	HOSTAGEACTION_None,

	HOSTAGEACTION_MajorActionStart,

		HOSTAGEACTION_Unguarded,
		HOSTAGEACTION_Threatened,
		HOSTAGEACTION_TakingBeating,
		HOSTAGEACTION_Explosive,
		HOSTAGEACTION_TapedGun,
		HOSTAGEACTION_WettingSelf,
		HOSTAGEACTION_Stockholm,
		HOSTAGEACTION_Panicking,
		HOSTAGEACTION_OrderedDown,
		HOSTAGEACTION_Restrained,
		HOSTAGEACTION_Following,
		HOSTAGEACTION_Evacuate,
		
	HOSTAGEACTION_MajorActionEnd,

	HOSTAGEACTION_TransientActionStart,

		HOSTAGEACTION_TakeCover,
		HOSTAGEACTION_Flinch,
		HOSTAGEACTION_DiveToGround,
		HOSTAGEACTION_Cowering,
		HOSTAGEACTION_PunchedByPlayer,

	HOSTAGEACTION_TransientActionEnd,
};


// Reaction priority levels.
enum EHostageReactionPriority
{
	HOSTREACTPRIORITY_None,
	HOSTREACTPRIORITY_Low,
	HOSTREACTPRIORITY_Med,
	HOSTREACTPRIORITY_High,
};


// Responses to hearing gunfire
enum ENoiseReaction
{
	NOISEREACT_None,
	NOISEREACT_TakeCover,
	NOISEREACT_DiveToGround,
	NOISEREACT_Flinch,
};


enum EHostageOrder
{
	HOSTAGEORDER_GetDown,
	HOSTAGEORDER_Follow,
};


//-----------------------------------------------------------------------------
// Structs
//

// Structure describing a pending reaction.
struct native HostageReaction
{
	var	EHostageAction				eNextAction;	// Hostage action to move into
	var	EHostageReactionPriority	ePriority;		// Reaction priority level.
	var int							PAD;
};


//-----------------------------------------------------------------------------
// Member Vars
//

var SASHostage			mHostage;						// Reference to possessed hostage

var Actor				mSoundOrigin;					// Where a sound is coming from
var float				mLastIdleSpotAnimTime;			// Last idle spot anim level time
var SASEntryPoint		mPanicTargetEP;					// Current target destination EP when panicking.
var SASAssaultVolume	mPanicCurAV;
var SASAssaultVolume	mPanicPrevAV;
var float				mLastSeenThreatTime;
var SASSoldier			mFirstSeenSoldier;
var bool				mbStartedPanic;

// Hostage action control params.
var EHostageAction		meMajorAction;					// Current major action state (for returning to when completing non-major state).
var EHostageAction		meCurAction;					// Current action state
var HostageReaction		mReaction;						

// Multitimers.
var int					mTimerReaction;					// Index of reaction timer in multi-timer array

// Misc booleans
var bool				mbTakingCover;					// True if currently taking cover (and diving to ground).
var bool				mbAwareOfSquad;					// HACK: Flag if hostage has become aware of squad.
var bool				mbSpokenToPlayer;				// Set once the hostage has spoken to the player
var bool				mbSeenSoldier;				

// Gunfire reaction control params.
var float				mLastGunfireReactTime;	
var float				mNearbyGunFireCounter;
var float				mLastNearbyGunfireTime;
var float				mMinTimeBetweenFlinches;
var float				mFlinchMinTimeBetweenGunfire;

// Player following params.
var SASPawn				mFollowTarget;					// Who are we following ?
var SASMoveTarget		mActorTracker;					// Track object for following the target actor
var Vector				mActorTrackPoint;				// Used for actor tracking
var float				mActorTrackPointThreshold;		

// Wired with explosives params.
var bool				mbIdentWiredSelf;
var float				mIdentWiredByOtherTime;

// Guarded params.
var float				mEndGuardedTime;
var SASTerrorist		mPrevGuardingTerrorist;

// Evacuation params.
var SASEvacuationVolume	mEvacuationVolume;					//
var SASEvacuationPoint	mEvacuationPoint;				// Evac point to run to on evacuating.


//-----------------------------------------------------------------------------
// Native Functions
//

native final function ChoosePanicDestEP();

native final function PanicSeekCover(
	bool	abCheckForThreats );

native final function bool PanicLineOfSightToThreat();

native function MemTick ();

native final function bool FindPlayerTrackPoint();

//-----------------------------------------------------------------------------
// Exec Functions
//

//-----------------------------------------------------------------------------
// Functions
//

//-----------------------------------------------------------------------------
// PostBeginPlay
//
event PostBeginPlay()
{
	Super.PostBeginPlay();

	// Init multitimers.
	mTimerReaction	= AddMultiTimer();

	// Init speech timer to random interval for first call.
	SetMultiTimer ( mTimerSpeech, SPEAK_TO_PLAYER_CHECKING_INTERVAL * FRand(), false);

    Level.Game.ChangeName( self, class'SASGameInfo'.Default.mDefaultHostageName, true );
}


//-----------------------------------------------------------------------------
// Possess
//
// Called by engine when controller possesses a pawn.
function Possess(
	Pawn	aPawn )		// Possessed pawn
{
	mHostage = SASHostage( aPawn );
	if ( mHostage == None )
	{
		Warn( "SASHostage.Possess: Possessed pawn is not an SASHostage." );
		return;
	}

	// Hostages don't currently use sight detection.
	//SetSightFlags ( SIGHT_None );
	SetSightFlags( SIGHT_Soldiers );
	
	// Only interested in hearing combat type noises.
	SetHearingFlags( HEAR_CombatEnemy|HEAR_CombatFriendly );

	// Init flinch params.
	mFlinchMinTimeBetweenGunfire = RandRange( 
										mHostage.mFlinchMinTimeBetweenGunfire.Min,
										mHostage.mFlinchMinTimeBetweenGunfire.Max );
	mMinTimeBetweenFlinches = RandRange( 
									mHostage.mMinTimeBetweenFlinches.Min, 
									mHostage.mMinTimeBetweenFlinches.Max );

	// By default hostages will step aside for anyone.
	SetStepAsidePawnTypes( PAWN_All );

	Super.Possess ( aPawn );

	aPawn.SetPace( PACE_Running );
}


//-----------------------------------------------------------------------------
// EnterStartState
//
simulated function EnterStartState()
{
	// Init hostage's starting action.
	InitMajorAction();
}


//-----------------------------------------------------------------------------
// PawnDied
//
function PawnDied(
	Pawn	aDead )
{
	if ( aDead != mHostage )
	{
		return;
	}

	Super.PawnDied( aDead );
}


//-----------------------------------------------------------------------------
// MultiTimer
//
event MultiTimer(
	int	aTimerIdx )
{
	switch ( aTimerIdx )
	{
	case mTimerReaction:
		CompleteReaction();
		break;

	default:
		Super.MultiTimer( aTimerIdx );
	}
}


//-----------------------------------------------------------------------------
// BeginAction
//
// Set the current action and execute it.
function BeginAction(
	EHostageAction	aeNewAction )
{
	SetCurrentAction( aeNewAction );
	DoCurrentAction();
}


//-----------------------------------------------------------------------------
// InitMajorAction
//
// Determine the starting major action for the hostage and enter it.
function InitMajorAction()
{
	local EHostageAction	eAction;

	if ( mCoverPoint != None )
	{
		RelinquishCoverPoint();
	}

	if ( mHostage.mbExplosive )
	{
		eAction = HOSTAGEACTION_Explosive;
	}
	else if ( mHostage.mbGunTapedToHand )
	{
		eAction = HOSTAGEACTION_TapedGun;
	}
	else if ( mHostage.mbThreatened )
	{
		eAction = HOSTAGEACTION_Threatened;
	}
	else if (  mHostage.mbTakingBeating )
	{	
		eAction = HOSTAGEACTION_TakingBeating;
	}
	else
	{
		eAction = HOSTAGEACTION_Unguarded;
	}

	BeginAction( eAction );
}


//-----------------------------------------------------------------------------
// ResumeMajorAction
//
// Return to the current major action.
function ResumeMajorAction()
{
	// Always evac if we have somewhere to go.
	if ( mEvacuationPoint != None )
	{
		meMajorAction = HOSTAGEACTION_Evacuate;
	}

	SetCurrentAction( meMajorAction );
	DoCurrentAction();
}


//-----------------------------------------------------------------------------
// ClearTransientAction
//
function ClearTransientAction()
{
	meCurAction = meMajorAction;
}


//-----------------------------------------------------------------------------
// ResumeObjective
//
function ResumeObjective()
{
	if ( ResumeScripting() )
	{
		return;
	}

	ResumeMajorAction();
}


//-----------------------------------------------------------------------------
// SetCurrentAction
//
// Set the current action to execute. Also deals with leaving the current 
// action.
function SetCurrentAction(
	EHostageAction	aeNewAction )
{
	// TODO: Check new action validity (mbCaptured etc)

	if ( aeNewAction == meCurAction )
	{
		return;
	}

	EndCurrentAction();

	if ( aeNewAction == HOSTAGEACTION_Panicking )
	{
		mHostage.mbPanicking = true;
	}
	else
	{
		mHostage.mbPanicking = false;
	}

	// TODO: Check for relinquishing CP.

	// Update the major action if this is one.
	if ( IsAMajorAction( aeNewAction ) )
	{
		SetCurrentMajorAction( aeNewAction );
	}

	meCurAction = aeNewAction;
}


//-----------------------------------------------------------------------------
// EndCurrentAction
//
// Deal with any tidying up required for the current action before leaving it.
function EndCurrentAction()
{
}


function bool SetCurrentMajorAction(
	EHostageAction	aeActionType )
{
	if ( !IsAMajorAction( aeActionType ) )
	{
		return false;
	}

	// Set hostage order obey flags depending on new state.
	switch( aeActionType )
	{
	case HOSTAGEACTION_Unguarded:
	case HOSTAGEACTION_Following:
	case HOSTAGEACTION_WettingSelf:
	case HOSTAGEACTION_Stockholm:
	case HOSTAGEACTION_Evacuate:
		// Obey all orders in these states.
		mHostage.mbObeyOrderGetDown = true;
		mHostage.mbObeyOrderFollow = true;
		break;

	case HOSTAGEACTION_Threatened:
	case HOSTAGEACTION_TakingBeating:
	case HOSTAGEACTION_Explosive:
	case HOSTAGEACTION_Panicking:
	case HOSTAGEACTION_OrderedDown:
		// Obey no orderd in these states.
		mHostage.mbObeyOrderGetDown = false;
		mHostage.mbObeyOrderFollow = false;
		break;

	case HOSTAGEACTION_TapedGun:
		// Only obey get down.
		mHostage.mbObeyOrderGetDown = true;
		mHostage.mbObeyOrderFollow = false;
		break;

	case HOSTAGEACTION_Restrained:
		// Only obey follow.
		mHostage.mbObeyOrderGetDown = false;
		mHostage.mbObeyOrderFollow = true;
		break;

	default:
		mHostage.mbObeyOrderGetDown = false;
		mHostage.mbObeyOrderFollow = false;
		Warn( "Unhandled major action <"$aeActionType$"> in SASHostage.SetCurrentAction." );
	}

	// Hack to prevent first sighting reaction after enterring a major state 
	// which is not unguarded.
	if ( aeActionType != HOSTAGEACTION_Unguarded )
	{
		mbSeenSoldier = true;
	}

	meMajorAction = aeActionType;
	return true;
}


//-----------------------------------------------------------------------------
// IsAMajorAction
//
function bool IsAMajorAction(
	EHostageAction	aeActionType )
{
	if (	aeActionType > HOSTAGEACTION_MajorActionStart &&
			aeActionType < HOSTAGEACTION_MajorActionEnd )
	{
		return true;
	}

	return false;
}


//-----------------------------------------------------------------------------
// DoCurrentAction
//
// Execute the current action.
function DoCurrentAction()
{
	// TODO: Check current action validity.
	// immediate threat means lack of compliance
	/*if ( mHostage.mbCaptured )
	{
		return;
	}*/

	switch( meCurAction )
	{
	case HOSTAGEACTION_Unguarded:
		GotoState( 'Unguarded' );
		break;
	
	case HOSTAGEACTION_Threatened:
		GotoState( 'Threatened' );
		break;
	
	case HOSTAGEACTION_TakingBeating:
		GotoState( 'TakingBeating' );
		break;
	
	case HOSTAGEACTION_Explosive:
		GotoState( 'WiredWithExplosives' );
		break;

	case HOSTAGEACTION_TapedGun:
		GotoState( 'TapedGun' );
		break;

	case HOSTAGEACTION_Following:
		// If follow target no longer valid then return to default unguarded idle state.
		if ( IsValidFollowTarget( mFollowTarget ) )
		{
			GotoState( 'Following' );
		}
		else
		{
			BeginAction( HOSTAGEACTION_Unguarded );
		}
		break;

	case HOSTAGEACTION_Evacuate:
		GotoState( 'Evacuate' );
		break;

	case HOSTAGEACTION_WettingSelf:
		GotoState( 'WettingSelf' );
		break;

	case HOSTAGEACTION_Panicking:
		GotoState( 'Panicking' );
		break;

	case HOSTAGEACTION_Stockholm:
		GotoState( 'Stockholm' );
		break;

	case HOSTAGEACTION_TakeCover:
		GotoState( 'CoverHiding' );
		break;

	case HOSTAGEACTION_Flinch:
		Warn( "DoCurrentAction: flinch is current action - should not happen." );
		BeginAction( meMajorAction );
		break;

	case HOSTAGEACTION_DiveToGround:
		GotoState( 'DiveToGround' );
		break;

	case HOSTAGEACTION_Cowering:
		GotoState( 'Cowering' );
		break;

	case HOSTAGEACTION_OrderedDown:
		GotoState( 'OrderedDown' );
		break;

	case HOSTAGEACTION_Restrained:
		GotoState( 'Restrained' );
		break;

	case HOSTAGEACTION_PunchedByPlayer:
		GotoState( 'PunchedByPlayer' );
		break;

	default:
		Warn( "SASHostage.DoCurrentAction called with invalid action <"$meCurAction$">" );
	}
}


//-----------------------------------------------------------------------------
// InitReaction
//
function InitReaction(
	EHostageAction				aeReaction,
	EHostageReactionPriority	aeReactionPriority,
	optional bool				abImmediate,
	optional bool				abSlowReaction )
{
	local float reactTime;

	if ( aeReactionPriority < mReaction.ePriority )
	{
		// Don't override a pending reaction of higher priority
		return;
	}

	// Check state to move into is a valid reaction state.
	if ( !ValidateReactionType( aeReaction ) )
	{
		Warn( "SASHostage.InitReaction: Tried to move into invalid action <"$aeReaction$">" );
		return;
	}

	mReaction.eNextAction	= aeReaction;
	mReaction.ePriority		= aeReactionPriority;

	if ( abImmediate )
	{
		reactTime = 0.0;
	}
	else
	{
		if ( abSlowReaction )
		{
			reactTime = RandRange( mHostage.mSlowReactionTime.Min, mHostage.mSlowReactionTime.Max );
		}
		else
		{
			reactTime = RandRange( mHostage.mReactionTime.Min, mHostage.mReactionTime.Max );
		}
	}

	if ( reactTime <= 0.0 )
	{
		CompleteReaction();
	}
	else
	{
		SetMultiTimer( mTimerReaction, reactTime, false );
	}
}


//-----------------------------------------------------------------------------
// ValidateReactionType
//
// Returns true if an action is one that it is valid to execute via the 
// delayed reaction mechanism.
function bool ValidateReactionType(
	EHostageAction	aeReactionType )
{
	switch ( aeReactionType )
	{
	case HOSTAGEACTION_TakeCover:
	case HOSTAGEACTION_Flinch:
		return true;

	case HOSTAGEACTION_Following:
		return mHostage.mbCaptured;

	case HOSTAGEACTION_WettingSelf:
	case HOSTAGEACTION_Stockholm:
	case HOSTAGEACTION_Panicking:
	case HOSTAGEACTION_DiveToGround:
	case HOSTAGEACTION_OrderedDown:
	case HOSTAGEACTION_Cowering:
		return !mHostage.mbCaptured;
	}

	return false;
}


//-----------------------------------------------------------------------------
// CompleteReaction
//
// Execuate the completed reaction.
function CompleteReaction()
{
	// Can't do any of this if incapacitated
	if ( IsIncapacitated() )
	{
		return;
	} 

	// GPHACK:
	if ( mReaction.eNextAction != HOSTAGEACTION_Flinch )
	{
		mbAwareOfSquad = true;
	}

	switch ( mReaction.eNextAction )
	{
	case HOSTAGEACTION_WettingSelf:
	case HOSTAGEACTION_Stockholm:
	case HOSTAGEACTION_Panicking:
	case HOSTAGEACTION_Cowering:
	case HOSTAGEACTION_OrderedDown:
		BeginAction( mReaction.eNextAction );
		break;

	case HOSTAGEACTION_TakeCover:
		if ( mCoverPoint != None )
		{
			BeginAction( HOSTAGEACTION_TakeCover );
			break;
		}
		// no break if don't have a CP for some reason.

	case HOSTAGEACTION_DiveToGround:
		BeginAction( HOSTAGEACTION_DiveToGround );
		break;

	case HOSTAGEACTION_Flinch:
		mHostage.PlayFlinch();
		break;

	case HOSTAGEACTION_Following:
		if ( StateCanBeOrdered() && mHostage.CanBeOrdered( HOSTAGEORDER_Follow ) )
		{
			OrderFollowPlayer( mFollowTarget, false );
		}
		break;

	default:
		Warn( "SASHostage.CompleteReaction: Invalid reaction type <"$mReaction.eNextAction$">" );
		break;
	}

	ClearReaction();
}


//-----------------------------------------------------------------------------
// ClearReaction
//
function ClearReaction()
{
	mReaction.eNextAction	= HOSTAGEACTION_None;
	mReaction.ePriority		= HOSTREACTPRIORITY_None;
}


//-----------------------------------------------------------------------------
// ShouldStepAsideFor
//
// Returns true if should enter stepping aside state for other actor.
function bool ShouldStepAsideFor(
	Actor			aOther,
	optional bool	abConsiderStationaryActors )
{
	// Don't step aside when prone - let everyone walk all over us
	if (mHostage.meStance == STANCE_Prone)
	{
		return false;
	}

	// Don't avoid other pawns when held captive.
	if ( (mHostage.mbThreatened || mHostage.mbTakingBeating) && Pawn(aOther) != None )
	{
		return false;
	}

	return Super.ShouldStepAsideFor( aOther );
}


//-----------------------------------------------------------------------------
// CanBeStunned
// 
function bool CanBeStunned()
{
	// Deal with major states where stunned not allowed.
	switch ( meMajorAction )
	{ 
	case HOSTAGEACTION_Explosive:
	case HOSTAGEACTION_OrderedDown:
	case HOSTAGEACTION_Restrained:
	case HOSTAGEACTION_WettingSelf:	// wetting self and stockholm not allowed because stunned state 
	case HOSTAGEACTION_Stockholm:	// doesn't currently cope with crouched hostages.
	case HOSTAGEACTION_Evacuate:
		return false;
	}

	// Deal with minor states where stunned not allowed
	if ( meCurAction != meMajorAction )
	{
		switch ( meCurAction )
		{
		case HOSTAGEACTION_DiveToGround:
		case HOSTAGEACTION_PunchedByPlayer:
			return false;
		}
	}

	return true;
}


//-----------------------------------------------------------------------------
// DoStunned
// 
function DoStunned(
	float	aStunTime )
{
	if ( IsIncapacitated() )
	{
		return;
	}

	if ( !CanBeStunned() )
	{
		return;
	}

	if ( aStunTime > 0.0 )
	{
		mSASPawn.mbStunned = true;
		if ( !IsInState( 'Stunned' ) )
		{
			mHostage.ChooseStunnedAnim();

			GotoState( 'Stunned' );
		}

		SetTimer( aStunTime, false );
	}
}


//-----------------------------------------------------------------------------
// CanBeGassed
// 
function bool CanBeGassed()
{
	// Deal with major states where stunned not allowed.
	switch ( meMajorAction )
	{ 
	case HOSTAGEACTION_Explosive:
	case HOSTAGEACTION_OrderedDown:
	case HOSTAGEACTION_Restrained:
	case HOSTAGEACTION_WettingSelf:	// wetting self and stockholm not allowed because gassed state 
	case HOSTAGEACTION_Stockholm:	// doesn't currently cope with crouched hostages.
	case HOSTAGEACTION_Evacuate:
		return false;
	}

	// Deal with minor states where stunned not allowed
	if ( meCurAction != meMajorAction )
	{
		switch ( meCurAction )
		{
		case HOSTAGEACTION_DiveToGround:
		case HOSTAGEACTION_PunchedByPlayer:
			return false;
		}
	}

	return true;

	return true;
}


//-----------------------------------------------------------------------------
// DoGassed
// 
function DoGassed(
	float	aGasDuration )
{
	if ( IsIncapacitated() )
	{
		return;
	}

	if ( !CanBeGassed() )
	{
		return;
	}

	if ( aGasDuration > 0.0 )
	{
		mSASPawn.mbGassed = true;
		StopMoving ();
		SetTimer( aGasDuration, false );
		
		if ( !IsInState( 'Gassed' ) )
		{
			GotoState( 'Gassed' );
		}
	}
}


//-----------------------------------------------------------------------------
// DoIncapacitated
//
function DoIncapacitated(
	optional Pawn causedBy )
{
	Disable( 'SeePlayer' );
	
	// TODO: leave current action.

	mHostage.mbPanicking = false;
	mHostage.mPanicChance = 0;

	Super.DoIncapacitated ();
}


//-----------------------------------------------------------------------------
// ChooseSquadSightingReaction
//
function EHostageAction ChooseSquadSightingReaction()
{
	return HOSTAGEACTION_None;
}

//-----------------------------------------------------------------------------
// ChooseSquadSightingReaction
//
function bool CanStockholm()
{
	local SASGameInfo		gi;
	local SASAssaultVolume	myAV;
	local SASPawn			other;

	gi = SASGameInfo( Level.Game );
	if ( gi != None )
	{
		myAV = mHostage.GetAssaultVolume();
		if ( myAV != None )
		{
			// Only stockholm if there are terrorists in sight / same AV.
			for ( other = gi.mLevelPawns; other != None; other = other.mNextPawn )
			{
				if ( other.mPawnType == PAWN_Terrorist )
				{
					if (	other.IsAlive() && 
							!other.mbIsIncapacitated &&
							(other.GetAssaultVolume() == myAV) &&
							(VSizeSq( other.Location - mHostage.Location ) < Square( 480.0 )) )
					{
						return true;
					}
				}
			}
		}
	}

	return false;
}


//-----------------------------------------------------------------------------
// SeePlayer
//
event SeePlayer(
	Pawn	aSeenPawn );


//-----------------------------------------------------------------------------
// HearNoise
//
event HearNoise(
	 float		aLoudness,				// Loudness level of noise (0.0->1.0)
	 Actor		aNoiseMaker,			// Instigator of the noise
	 ENoiseType aeNoiseType, 			// Type of noise
	 Vector		aNoiseLoc )				// Noise location
{
	local float				timeDiff;
	local SASPawn			heardSASPawn;
	local Actor				heardWpn;
	local ENoiseReaction	eResponse;
	local EHostageAction	eSquadFireReaction;

	// only certain types of noise freak us out
	if (	(aeNoiseType != NOISE_PawnHit) &&
			(aeNoiseType != NOISE_Gunfire) &&
			(aeNoiseType != NOISE_Explosion) &&
			(aeNoiseType != NOISE_Ricochet) )
	{
		return;
	}

	if ( mHostage.mbExplosive || mHostage.mbUnresponsive )
	{
		return;
	}

	switch ( aeNoiseType )
	{
	case NOISE_Explosion:
	case NOISE_Ricochet:
		heardWpn		= aNoiseMaker;
		mSoundOrigin	= aNoiseMaker;
		heardSASPawn	= SASPawn( heardWpn.Instigator );
		break;

	default:
		heardSASPawn	= SASPawn( aNoiseMaker );
		if ( heardSASPawn != None )
		{
			heardWpn = heardSASPawn.Weapon;
		}
		mSoundOrigin	= heardWpn;
	}

	// Only react to weapon generated noises.
	if ( heardWpn == None )
	{
		return;
	}

	// Update recent gunfire counter.
	if ( (aeNoiseType == NOISE_Gunfire) || (aeNoiseType == NOISE_Ricochet) )
	{
		// Gunfire by squad in same AV results in a 'first sighting squad' response.
		if (	!mbSeenSoldier &&
				(heardSASPawn != None) && 
				(heardSASPawn.mPawnType == PAWN_Soldier) )
		{
			if (	(mHostage.GetAssaultVolume() != None) && 
					(mHostage.GetAssaultVolume() == heardSASPawn.GetAssaultVolume()) )
			{
				eSquadFireReaction = ChooseSquadSightingReaction();
				if ( eSquadFireReaction != HOSTAGEACTION_None )
				{
					mbSeenSoldier = true;
					InitReaction( eSquadFireReaction, HOSTREACTPRIORITY_Med );
				}
			}
		}

		// First apply decay since last heard gun fire.
		timeDiff = Level.TimeSeconds - mLastNearbyGunfireTime;
		mNearbyGunFireCounter -= timeDiff * mHostage.mGunfireCounterDecayRate;
		mNearbyGunFireCounter = FMax( mNearbyGunFireCounter, 0.0 );

		// Increment counter.
		mNearbyGunFireCounter += 1.0f;
	}
	
	eResponse = GetNoiseReaction( heardWpn, aLoudness, aeNoiseType, aNoiseLoc );
	if ( eResponse != NOISEREACT_None )
	{
		mLastGunfireReactTime = Level.TimeSeconds;
	}

	// Update last heard shot time after determining reaction.
	if ( (aeNoiseType == NOISE_Gunfire) || (aeNoiseType == NOISE_Ricochet) )
	{
		mLastNearbyGunfireTime = Level.TimeSeconds;
	}

	// Can't dive to ground if handcuffed, take cover instead.
	if ( eResponse == NOISEREACT_DiveToGround && mHostage.mbCaptured )
	{
		eResponse = NOISEREACT_TakeCover;
	}

	switch ( eResponse )
	{
	case NOISEREACT_None:
		break;

	case NOISEREACT_Flinch:
		InitReaction( HOSTAGEACTION_Flinch, HOSTREACTPRIORITY_Low, true );
		break;

	case NOISEREACT_TakeCover:
		SeekClosestCoverAroundOther( mSASPawn, 750.0 );
		if ( mCoverPoint != None )
		{
			InitReaction( HOSTAGEACTION_TakeCover, HOSTREACTPRIORITY_Low );
			break;
		}
		// no break if failed to find CP.

	case NOISEREACT_DiveToGround:
		if ( !mHostage.mbCaptured )
		{
			InitReaction( HOSTAGEACTION_DiveToGround, HOSTREACTPRIORITY_Low );
		}
		break;

	default:
		break;
	}
}


//-----------------------------------------------------------------------------
// GetNoiseReaction
//
function ENoiseReaction GetNoiseReaction(
	Actor		aNoiseMaker,
	float		aLoudness,
	ENoiseType	aeNoiseType,
	Vector		aNoiseLoc )
{
	// Only react to certain noise types.
	switch( aeNoiseType )
	{
	case NOISE_Gunfire:
	case NOISE_Ricochet:
	case NOISE_PawnHit:
		return GetGunFireReaction( aNoiseMaker, aLoudness, aNoiseLoc );

	case NOISE_Explosion:
		return GetExplosionReaction( aNoiseMaker, aLoudness, aNoiseLoc );
	}

	return NOISEREACT_None;
}


//-----------------------------------------------------------------------------
// AllowNoiseReaction
//
function bool AllowNoiseReaction( 
	ENoiseReaction	aeRectionType )
{
	// By default no noise reactions - individual states handle which reactions
	// are allowed.
	return false;
}


//-----------------------------------------------------------------------------
// GetGunFireReaction
//
function ENoiseReaction GetGunFireReaction(
	Actor		aInstigator,
	float		aLoudness,
	Vector		aNoiseLoc )
{
	local float	noiseDistSq,
				flinchChance;

	// Never react for noises below certain threshold
	noiseDistSq = VSizeSq( mHostage.Location - aNoiseLoc );

	// Check if hostage should flinch
	if ( noiseDistSq < Square( mHostage.mNearbyGunfireDist.Min ) )
	{
		flinchChance = 1.0;
	}
	else if ( noiseDistSq < Square( mHostage.mNearbyGunfireDist.Max ) )	
	{
		flinchChance = mHostage.mNearbyGunfireFlinchChance;
	}
	else
	{
		flinchChance = mHostage.mDistantGunfireFlinchChance;
	}

	// Check for taking cover/diving to ground.

	// Only do this after seeing a soldier.
	if ( mbSeenSoldier )
	{
		if (	AllowNoiseReaction( NOISEREACT_TakeCover ) &&
				(	(flinchChance > 0.0) && 
					(noiseDistSq <= Square( mHostage.mGunfireTakeCoverMaxDist )) ) )
		{
			if ( mNearbyGunFireCounter >= RandRange( 
												mHostage.mSustainedGunfireToTakeCover.Min,
												mHostage.mSustainedGunfireToTakeCover.Max ) )
			{
				return NOISEREACT_TakeCover;
			}
		}
	}

	// Only flinch for noises within range.
	if (	AllowNoiseReaction( NOISEREACT_Flinch) &&
			(noiseDistSq < Square( mHostage.mGunfireFlinchMaxDist )) &&
			(FRand() <= flinchChance) &&
			((Level.TimeSeconds - mLastNearbyGunfireTime) > mFlinchMinTimeBetweenGunfire) && 
			((Level.TimeSeconds - mLastGunfireReactTime) > mMinTimeBetweenFlinches ) )
	{
		mFlinchMinTimeBetweenGunfire = RandRange( 
											mHostage.mFlinchMinTimeBetweenGunfire.Min,
											mHostage.mFlinchMinTimeBetweenGunfire.Max );

		mMinTimeBetweenFlinches = RandRange( 
										mHostage.mMinTimeBetweenFlinches.Min, 
										mHostage.mMinTimeBetweenFlinches.Max );

		return NOISEREACT_Flinch;
	}

	return NOISEREACT_None;
}


//-----------------------------------------------------------------------------
// GetExplosionReaction
//
function ENoiseReaction GetExplosionReaction(
	Actor		aInstigator,
	float		aLoudness,
	Vector		aNoiseLoc )
{
	local float	noiseDistSq;

	// Never react for noises below certain threshold
	noiseDistSq = VSizeSq( mHostage.Location - aNoiseLoc );

	// Check for taking cover/diving to ground.
	// Only do this after seeing a soldier.
	if ( mbSeenSoldier )
	{
		if (	AllowNoiseReaction( NOISEREACT_DiveToGround ) &&
				(noiseDistSq <= Square( mHostage.mExplosionDiveToGroundMaxDist )) )
		{
			return NOISEREACT_DiveToGround;
		}
	}

	// Only flinch for noises within range.
	if (	AllowNoiseReaction( NOISEREACT_Flinch ) &&
			(noiseDistSq < Square( mHostage.mExplosionFlinchMaxDist )) )
	{
		return NOISEREACT_Flinch;
	}

	return NOISEREACT_None;
}


//-----------------------------------------------------------------------------
// DamageAttitudeTo
//
// Called on taking damage to instigate a response.
function DamageAttitudeTo(
	Pawn	aOther,			// Pawn that damaged us (eg. Pawn that fired the weapon)
	float	aDamage )		// Damage amount
{
	local SASPawn		damageInstigator;
	local SASHostage	otherHostage;

	if ( !mbCanFeelDamage )
	{
		return;
	}

	damageInstigator = SASPawn( aOther );
	if ( (aDamage > 0.0) && (damageInstigator != None) )
	{
		// Inform other hostages in range and line of sight that hostage has been hit.
		foreach mHostage.GetGame().LineOfSightSASPawns( class'SASHostage', otherHostage, mHostage, 1000.0 )
		{
			if ( (otherHostage.Controller != None) && (otherHostage.Controller.mType == CONTROLLER_AIHostage) )
			{
				SASHostageController( otherHostage.Controller ).NotifyOtherHostageHurt( mHostage, damageInstigator );
			}
		}
	}
}


//-----------------------------------------------------------------------------
// NotifyOtherHostageHurt
//
function NotifyOtherHostageHurt(
   SASHostage	aOtherHostage,
   SASPawn		aDamager );


//-----------------------------------------------------------------------------
// OrderHostagesDown
//
static function OrderHostagesDown(
	SASPawn		aCommander )
{
	local SASHostage		hostage;
	local SASAssaultVolume	commandersAV;

	// Ignore all but the player
	if (SASPlayerController (aCommander.Controller) == None)
	{
		return;
	} // if

	// Only react if the player is in our volume
	commandersAV = aCommander.GetAssaultVolume();
	if ( commandersAV == None )
	{
		return;
	}

	foreach aCommander.GetGame().RadiusSASPawns( class'SASHostage', hostage, aCommander.Location, 1000.0 )
	{
		if ( (hostage.Controller != None) 
			&& (hostage.Controller.mType == CONTROLLER_AIHostage)
			&& ( hostage.GetAssaultVolume() == commandersAV ) )
		{
			SASHostageController( hostage.Controller ).PlayerOrder( HOSTAGEORDER_GetDown, aCommander );
		}
	}
}


//-----------------------------------------------------------------------------
// StartThreatened
//
function StartThreatened()
{
	BeginAction( HOSTAGEACTION_Threatened );
}


//-----------------------------------------------------------------------------
// StartTakeBeating
//
function StartTakeBeating()
{
	BeginAction( HOSTAGEACTION_TakingBeating );
}


//-----------------------------------------------------------------------------
// EndGuardedByTerrorist
//
function EndGuardedByTerrorist()
{
	// For global version of the function, just ensure that the major action
	// is set to unguarded. This fn is overwritten in the TakingBeating/Treatened states
	// to leave the state immediately.
	if ( meMajorAction == HOSTAGEACTION_Threatened || meMajorAction == HOSTAGEACTION_TakingBeating )
	{
		SetCurrentMajorAction( HOSTAGEACTION_Unguarded );

		mEndGuardedTime = Level.TimeSeconds;
		mPrevGuardingTerrorist = mHostage.mGuardingTerrorist;

		CheckPlayEndGuardedThanks();
	}
}


//-----------------------------------------------------------------------------
// CheckPlayEndGuardedThanks
//
function CheckPlayEndGuardedThanks()
{
	if (	(mPrevGuardingTerrorist != None) && 
			(!mPrevGuardingTerrorist.IsAlive() || mPrevGuardingTerrorist.mbIsIncapacitated) &&
			((Level.TimeSeconds - mEndGuardedTime) < 2.0) )
	{
		mHostage.PlaySpeech( SPEECH_HostageThanks );

		mEndGuardedTime = 0.0;
		mPrevGuardingTerrorist = None;
	}
}


//-----------------------------------------------------------------------------
// NotifyKilled
// 
// Called whenver any pawn dies. 
function NotifyKilled(
	Controller	aKiller,
	Controller	aKilled,
	Pawn		aOther )
{
	Super.NotifyKilled( aKiller, aKilled, aOther );

	if (	(aOther != None) && 
			(aOther == mPrevGuardingTerrorist) )
	{
		CheckPlayEndGuardedThanks();
	} 
}


//-----------------------------------------------------------------------------
// NotifyKilled
// 
// Called whenver any pawn is incapacitated. 
function NotifyIncapacitated( 
	Pawn	aIncapacitated )
{
	Super.NotifyIncapacitated( aIncapacitated );

	if (	(aIncapacitated != None) && 
			(aIncapacitated == mPrevGuardingTerrorist) )
	{
		CheckPlayEndGuardedThanks();
	} 
}


//-----------------------------------------------------------------------------
// StateCanBeOrdered
//
function bool StateCanBeOrdered()
{
	return true;
}


//-----------------------------------------------------------------------------
// PlayerOrder
//
function PlayerOrder(
	EHostageOrder	aeOrder,
	SASPawn			aOrderedBy,
	optional int	aOrderInt )
{
	local bool	bDelayed;

	mbAwareOfSquad = true;

	// Immediate threat means lack of compliance.
	if (	!StateCanBeOrdered() || 
			!mHostage.CanBeOrdered( aeOrder ) ||
			IsIncapacitated() || 
			mHostage.IsDead() )
	{
		return;
	}

	// Stop scripting if we are.
	if ( mScriptInterface.mScript != None )
	{
		LeaveScripting();
	}

	switch ( aeOrder )
	{
	case HOSTAGEORDER_GetDown:
		bDelayed = (aOrderInt == 1);
		OrderGetDown( bDelayed );
		break;

	case HOSTAGEORDER_Follow:
		bDelayed = (aOrderInt == 1);
		OrderFollowPlayer( aOrderedBy, bDelayed );
		break;
	}
}


//-----------------------------------------------------------------------------
// OrderGetDown
//
// Reaction to being shouted at by player.
private function OrderGetDown(
	bool bDelayed )
{
	// If ordered down from taking beating action then stop taking beating. 
	if ( meMajorAction == HOSTAGEACTION_TakingBeating )
	{
		if ( mHostage.mGuardingTerrorist != None )
		{
			mHostage.mGuardingTerrorist.StopBeatingHostage( mHostage );
		}
		mHostage.EndGuardedByTerrorist();
	}

	if ( bDelayed )
	{
		InitReaction( HOSTAGEACTION_OrderedDown, HOSTREACTPRIORITY_High, false, true );
	}
	else
	{
		BeginAction( HOSTAGEACTION_OrderedDown );
	}
}


//-----------------------------------------------------------------------------
// OrderFollowPlayer
//
private function OrderFollowPlayer(
	SASPawn	aNewFollowTarget,		// Target to follow - 'None' cancels the follow order
	bool	abDelayed )		
{
	if (IsIncapacitated () || mHostage.IsDead ())
	{
		return;
	}

	if ( aNewFollowTarget == None)
	{
		if ( meMajorAction == HOSTAGEACTION_Following )
		{
			// Either hide at cover or goto unguarded state.
			SeekClosestCoverAroundOther( mFollowTarget, PLAYER_MAX_TRACKING_DIST2D_LARGE, 1000.0 );
			if ( mCoverPoint != None )
			{
				BeginAction( HOSTAGEACTION_TakeCover );
			}
			else
			{
				BeginAction( HOSTAGEACTION_Unguarded );
			}
		}

		mFollowTarget = None;
		
		return;
	}

	if ( !IsValidFollowTarget( aNewFollowTarget ) )
	{
		mFollowTarget = None;
		
		// Return to default idle behaviour.
		BeginAction( HOSTAGEACTION_Unguarded );
		return;
	}

	// Check to see we're not already following this target
	if ( IsInState( 'Following' ) )
	{
		if (target == mFollowTarget)
		{
			return;
		}
	} 

	mFollowTarget = aNewFollowTarget;

	if ( abDelayed )
	{
		InitReaction( HOSTAGEACTION_Following, HOSTREACTPRIORITY_High, false, true );
	}
	else
	{
		BeginAction( HOSTAGEACTION_Following );
	}
}


//-----------------------------------------------------------------------------
// NotifyStartedCuffing
//
function NotifyStartedCuffing()
{
	mHostage.mbCuffingStarted = true;
}


//-----------------------------------------------------------------------------
// NotifyCaptured
//
function NotifyCaptured()
{
	SetCurrentMajorAction( HOSTAGEACTION_Restrained );
}


//-----------------------------------------------------------------------------
// ReactToGrenade
//
// Overriding function to make grenade reaction dependant on our current
// major state.
event ReactToGrenade(
	SASGrenadeProjectile	aGrenade )
{
	local bool bReact;

	switch ( meMajorAction )
	{
	case HOSTAGEACTION_Unguarded:
	case HOSTAGEACTION_TapedGun:
	case HOSTAGEACTION_WettingSelf:
	case HOSTAGEACTION_Stockholm:
	case HOSTAGEACTION_Following:
	case HOSTAGEACTION_Evacuate:
		// React as normal.
		bReact = true;
		break;

	case HOSTAGEACTION_Threatened:
		// Run away from explosive grenades, take the rest like a man.
		if ( AwareOfGrenadesOfType( GRENADECAT_Explosive ) )
		{
			bReact = true;
		}
		break;
	
	case HOSTAGEACTION_TakingBeating:
		// Reacts by diving to ground.
		break;

	case HOSTAGEACTION_Explosive:
		// Can't do anything - just sit still and hope for the best!
		break;

	case HOSTAGEACTION_Panicking:
		// In too much of a cufuffle to notice.
		break;
	
	case HOSTAGEACTION_OrderedDown:
	case HOSTAGEACTION_Restrained:
		// ???
		break;

	default:
		Warn( "Unrecognised hostage major action <"$meMajorAction$"> when reacting to grenades." );
	}

	if ( bReact )
	{
		SetCurrentMajorAction( HOSTAGEACTION_Unguarded );
		Super.ReactToGrenade( aGrenade );
	}
}


//-----------------------------------------------------------------------------
// IsValidFollowTarget
//
function bool IsValidFollowTarget(
	SASPawn	aTarget )
{
	if (	(aTarget != None) &&
			aTarget.IsAlive() &&
			!aTarget.mbIsIncapacitated )
	{
		return true;
	}

	return false;
}


//-----------------------------------------------------------------------------
// IsOrderedDown
//
simulated event bool IsOrderedDown()
{
	return false;
}


//-----------------------------------------------------------------------------
// PlayerChangedAssaultVolumes
//
static function PlayerChangedAssaultVolumes(
	SASSoldier			aPlayer,
	SASAssaultVolume	aPrevAV )
{
	local SASGameInfo	gi;
	local SASSoldier	soldier;
	local SASHostage	hostage,
						potentials[4];
	local int			i,
						numPotentials,
						numSpeakers,
						randIdx;
	local float			randNum;

	if ( aPrevAV == None )
	{
		return;
	}
	
	gi = aPlayer.GetGame();
	if ( (aPlayer.Level.TimeSeconds - gi.mLastHostageDontLeaveMeTime) > 10.0 )
	{
		// Are there any other player controlled squad members in the prev AV?
		foreach gi.AllSASPawns( class'SASSoldier', soldier )
		{
			if ( (soldier.Controller != None) 
				&& (soldier.Controller.mType == CONTROLLER_Player)
				&& (soldier.GetAssaultVolume() == aPrevAV) )
			{
				// Yes, another player is in previous AV.
				return;
			}
		}

		foreach gi.AllSASPawns( class'SASHostage', hostage )
		{
			if (	(hostage.Controller != None) && 
					(hostage.Controller.mType == CONTROLLER_AIHostage) &&
					(hostage.Health > 0) &&
					!hostage.mbIsIncapacitated &&
					SASHostageController( hostage.Controller ).mbAwareOfSquad &&
					(hostage.GetAssaultVolume() == aPrevAV) )
			{
				switch ( SASHostageController( hostage.Controller ).meMajorAction )
				{
				// Don't play speech in these major states.
				case HOSTAGEACTION_Threatened:
				case HOSTAGEACTION_TakingBeating:
				case HOSTAGEACTION_TapedGun:
				case HOSTAGEACTION_Panicking:
				case HOSTAGEACTION_Following:
				case HOSTAGEACTION_Evacuate:
					break;

				default:
					potentials[numPotentials] = hostage;
					numPotentials++;
					if ( numPotentials == 4 )
					{
						break;
					}
				}
			}
		}

		if ( numPotentials > 0 )
		{
			randNum = FRand();
			if ( randNum > 0.8 )
			{
				numSpeakers = 3;
			}
			else if ( randNum > 0.6 )
			{
				numSpeakers = 2;
			}
			else
			{
				numSpeakers = 1;
			}
			numSpeakers = Min( numSpeakers, numPotentials );

			for ( i = 0; i < numSpeakers; ++i )
			{
				randIdx = Rand( numPotentials );
				potentials[randIdx].PlayDelayedSpeech( SPEECH_HostageDontLeaveMe, true );
				
				if ( randIdx < numPotentials-1 )
				{
					potentials[randIdx] = potentials[numPotentials-1];
				}
				numPotentials--;
			}
	
			gi.mLastHostageDontLeaveMeTime = aPlayer.Level.TimeSeconds;
		}
	}
}


//-----------------------------------------------------------------------------
// UpdateSightTarget
//
// Look for nearest terrorist or SAS
//::function UpdateSightTarget()
//::{
//::	local SASFighter	other,
//::						closest;
//::	local float			distSq,
//::						closestDistSq;
//::
//::	if ( mHostage == None )
//::	{
//::		return;
//::	}
//::
//::	// Look at the nearest SAS or terrorist
//::	foreach SASGameInfo( Level.Game ).LineOfSightSASPawns( class'SASFighter', other, mHostage, 1000.0 )
//::	{
//::		if ( (other.mPawnType != PAWN_Scripted) && other.IsAlive() && !other.mbIsIncapacitated )
//::		{
//::			distSq = VSizeSq( Location - other.Location );
//::			if ( (closest == None) || (distSq < closestDistSq) )
//::			{
//::				closest = other;
//::				closestDistSq = distSq;
//::			}
//::		}
//::	}
//::
//::	mHostage.mInterestItem = closest;
//::}


///////////////////////////////////////////////////////////////////////////////
// DoPunchedByPlayer
//
// Reaction to being punched by player.
function DoPunchedByPlayer(
	SASPawn aHitBy )
{
	// Play get down speech when soldier hits a hostage.
	if ( aHitBy.mPawnType == PAWN_Soldier )
	{
		aHitBy.PlaySpeech( SPEECH_SquadHostageGetDown );
	}

	// Stop scripting if we are.
	if ( mScriptInterface.mScript != None )
	{
		LeaveScripting();
	}

	SetCurrentMajorAction( HOSTAGEACTION_OrderedDown );
	BeginAction( HOSTAGEACTION_PunchedByPlayer );
} 


///////////////////////////////////////////////////////////////////////////////
// ExplosiveDisarmed
//
function ExplosiveDisarmed();


///////////////////////////////////////////////////////////////////////////////
// EnterredEvacuationVolume
//
function EnterredEvacuationVolume(
	SASEvacuationVolume	aVol )
{
	if (	!mHostage.mbCaptured ||
			(mEvacuationVolume != None) ||
			!mHostage.IsAlive() ||
			mHostage.mbIsIncapacitated )
	{
		return;
	}

	mEvacuationVolume = aVol;
	SeekEvacuationPoint();
	
	BeginAction( HOSTAGEACTION_Evacuate );
}


//-----------------------------------------------------------------------------
// SeekEvacuationPoint
//
function SeekEvacuationPoint()
{
	local int					evacPtIdx,
								numEvacPts;
	local float					pathCost, 
								bestPathCost;
	local SASEvacuationPoint	evacPt, 
								best;

	mEvacuationPoint = None;

	if ( (mHostage == None) || (mEvacuationVolume == None) )
	{
		return;
	}

	numEvacPts = mEvacuationVolume.mEvacPoints.Length;
	for ( evacPtIdx = 0; evacPtIdx < numEvacPts; ++evacPtIdx )
	{
		evacPt = mEvacuationVolume.mEvacPoints[evacPtIdx];
		if ( evacPt != None )
		{
			pathCost = mHostage.GetPathCost( mHostage, evacPt );
			if ( pathCost != -1.0f )
			{
				if ( (best == None) || (pathCost < bestPathCost) )
				{
					best = evacPt;
					bestPathCost = pathCost;
				}
			}
		}
	}

	if ( best != None )
	{
		mEvacuationPoint = best;
	}
}


//-----------------------------------------------------------------------------
// IsFollowTrackPointValid
//
function bool IsFollowTrackPointValid(
	Vector			aTrackingPos )
{
	local float		maxTrackingDist,
					heightDiff,
					distSq;
	local Vector	ofs;
	
	if ( !IsValidFollowTarget( mFollowTarget ) )
	{
		return false;
	}

	// If follow target is within an evac volume then must try to get close.
	if ( mFollowTarget.IsTouchingActorOfType( 'SASEvacuationVolume' ) )
	{
		maxTrackingDist = 64;
	}
	else
	{
		maxTrackingDist = PLAYER_MAX_TRACKING_DIST2D_LARGE;
	}

	// Check distance of tracking point from player.
	ofs = aTrackingPos - mFollowTarget.Location;
	heightDiff = ofs.Z;
	ofs.Z = 0.0;

	distSq = VSizeHorizSq( ofs );
	if ( distSq > Square( maxTrackingDist ) )
	{
		return false;
	}

	if ( Abs( heightDiff ) > PLAYER_TRACKING_MAX_HEIGHT_DIFF )
	{
		return false;
	}

	return true;
}

//-----------------------------------------------------------------------------
// States
//

function EPawnSpeech ChoosePlayerSightingSpeech();
function PlayThreatenedSpeech();
function bool InDeactivationRangeOfPlayer();
function HaveAnAccident();
function DoReachedEvacPoint();


// Inheriting Transition state to ignore/override functions.
state Transition
{
	ignores	SeePlayer,
			HearNoise,
			NotifyBump,
			NotifyPlayerAboutToBump,
			PlayerOrder,
			ServerDoPunchedByPlayer,
			CheckCanBePunched;

	// No orders during transition.
	function bool StateCanBeOrdered()
	{
		return false;
	}

	function ENoiseReaction GetNoiseReaction( 
		Actor		aNoiseMaker, 
		float		aLoudness,
		ENoiseType	aNoiseType,
		Vector		aNoiseLoc )
	{
		// Don't react to further gun fire while transitioning.
		return NOISEREACT_None;
	}
}

//-----------------------------------------------------------------------------
// STATE Unguarded
//
// Default 'idle' state.
state Unguarded
{
	//-----------------------------------------------------------------------------
	// AllowNoiseReaction
	//
	function bool AllowNoiseReaction( 
		ENoiseReaction	aeReactionType )
	{
		// Can't dive to ground when cuffed.
		if ( aeReactionType == NOISEREACT_DiveToGround && mHostage.mbCaptured )
		{
			return false;
		}
		return true;
	}

	//-----------------------------------------------------------------------------
	// BeginState
	//
	event BeginState()
	{
		if ( mHostage.mbThreatened )
		{
			BeginAction( HOSTAGEACTION_Threatened );
			return;
		}
		if ( mHostage.mbTakingBeating )
		{
			BeginAction( HOSTAGEACTION_TakingBeating );
			return;
		}

		Enable( 'SeePlayer' );
	}	


	//-----------------------------------------------------------------------------
	// SeePlayer
	//
	event SeePlayer(
		Pawn	aSeenPawn )
	{
		local EPawnSpeech		ePlayerSightingSpeech;
		local EHostageAction	squadSightingReaction;

		if ( mbSeenSoldier )
		{
			Disable( 'SeePlayer' );
			return;
		}

		if ( mHostage.mbUnresponsive )
		{
			return;
		}

		// If sighting a soldier then choose a reaction behaviour.
		if ( aSeenPawn.mPawnType == PAWN_Soldier )
		{
			mFirstSeenSoldier = SASSoldier( aSeenPawn );
			mbSeenSoldier = true;
			Disable( 'SeePlayer' );

			squadSightingReaction = ChooseSquadSightingReaction();
			if ( squadSightingReaction != HOSTAGEACTION_None )
			{
				InitReaction( squadSightingReaction, HOSTREACTPRIORITY_Med );
			}
			else
			{
				ePlayerSightingSpeech = ChoosePlayerSightingSpeech();
				if ( ePlayerSightingSpeech != SPEECH_None )
				{
					mHostage.PlayDelayedSpeech( ePlayerSightingSpeech, false );
				}
			}
		}
	}


	//-----------------------------------------------------------------------------
	// ChooseSquadSightingReaction
	//
	function EHostageAction ChooseSquadSightingReaction()
	{
		local float	scale,
					randVal;
		local bool	bCanStockholm;

		bCanStockholm = CanStockholm();
		if ( !bCanStockholm )
		{
			scale = mHostage.mPanicChance + mHostage.mWetSelfChance;
		}
		else
		{
			scale = 1.0;
		}

		randVal = FRand() * scale;
		if ( randVal < mHostage.mPanicChance )
		{
			return HOSTAGEACTION_Panicking;
		}
		randVal -= mHostage.mPanicChance;

		if ( randVal < mHostage.mWetSelfChance )
		{
			return HOSTAGEACTION_WettingSelf;
		}
	
		if ( bCanStockholm && (mHostage.mStockholmChance > 0.0) )
		{
			return HOSTAGEACTION_Stockholm;
		}

		return HOSTAGEACTION_None;
	}


	//-----------------------------------------------------------------------------
	// ChoosePlayerSightingSpeech
	//
	function EPawnSpeech ChoosePlayerSightingSpeech()
	{
		local SASHostage		otherHostage;
		local SASTerrorist		terrorist;
		local SASGameInfo		gi;
		local SASAssaultVolume	myAV;

		gi = mHostage.GetGame();
		myAV = mHostage.GetAssaultVolume();
		if ( gi == None && myAV == None )
		{
			return SPEECH_HostageHelpUnguarded;
		}

		// Any wired hostages in the room?
		if ( FRand() < mHostage.mWiredHostageIdentChance )
		{
			foreach gi.AssaultVolumeSASPawns( class'SASHostage', otherHostage, myAV )
			{
				if (	otherHostage.IsAlive() && 
						otherHostage.mbExplosive &&
						(otherHostage.Controller.mType == CONTROLLER_AIHostage) &&
						(SASHostageController( otherHostage.Controller ).mIdentWiredByOtherTime == 0.0) )
				{
					SASHostageController( otherHostage.Controller ).mIdentWiredByOtherTime = Level.TimeSeconds;
					return SPEECH_HostageBombWarnOther;
				}
			}
		}

		if (	(myAV.mNumTerroristIdents < MAX_TERRORIST_IDENTS_PER_AV) &&
				(FRand() < mHostage.mTerroristIdentChance) )
		{
			// Any terrorists in the room?
			foreach gi.AssaultVolumeSASPawns( class'SASTerrorist', terrorist, myAV )
			{
				if ( terrorist.IsAlive() && !terrorist.mbIsIncapacitated )
				{
					myAV.mNumTerroristIdents++;
					return SPEECH_HostageIdentTerrorist;
				}
			}
		}
		
		return SPEECH_HostageHelpUnguarded;
	}	


Begin:

	StopMoving();

	// Transition to standing if not already doing so.
	if ( Pawn.meStance != STANCE_Standing )
	{
		DoStanceTransition( STANCE_Standing, GetStateName(),, RandRange( 0.85, 1.15 ) );
	}

	SetFocalPointFromDir( ChooseDirectionNotFacingWall( Vector(Pawn.Rotation) ) );
}


//-----------------------------------------------------------------------------
// STATE CaptiveState
//
state CaptiveState
{
	ignores ServerDoPunchedByPlayer,
			CheckCanBePunched,
			PlayerOrder,
			NotifyBump,
			NotifyPlayerAboutToBump,
			DoStepAside,
			CanStepAside,
			StartThreatened;

	//-----------------------------------------------------------------------------
	// StateCanBeOrdered
	//
	function bool StateCanBeOrdered()
	{
		return false;
	}
			
	//-----------------------------------------------------------------------------
	// EndGuardedByTerrorist
	//
	function EndGuardedByTerrorist()
	{
		mEndGuardedTime = Level.TimeSeconds;
		mPrevGuardingTerrorist = mHostage.mGuardingTerrorist;

		CheckPlayEndGuardedThanks();
		
		BeginAction( HOSTAGEACTION_Unguarded );
	}
}


//-----------------------------------------------------------------------------
// STATE Threatened
//
// State while being threatened by a terrorist.
state Threatened extends CaptiveState
{
	//-----------------------------------------------------------------------------
	// BeginState
	//
	event BeginState()
	{
		if ( !mHostage.mbThreatened )
		{
			BeginAction( HOSTAGEACTION_Unguarded );
			return;
		}

		StopMultiTimer( mTimerSpeech );
	}


	//-----------------------------------------------------------------------------
	// MultiTimer
	//
	event MultiTimer(
		int	aTimerIdx )
	{
		switch ( aTimerIdx )
		{
		case mTimerSpeech:
			PlayThreatenedSpeech();
			SetMultiTimer( mTimerSpeech, RandRange( mHostage.mGuardedSpeechTime.Min, mHostage.mGuardedSpeechTime.Max ), false );
			break;

		default:
			Global.MultiTimer( aTimerIdx );
		}
	}


	//-----------------------------------------------------------------------------
	// PlayThreatenedSpeech
	//
	function PlayThreatenedSpeech()
	{
		local SASSoldier	soldier;
		local EPawnSpeech	eSelectedSpeech;
		local SASGameInfo	gi;

		eSelectedSpeech = SPEECH_None;

		gi = mHostage.GetGame();
		if ( gi != None )
		{
			// Randomly play stockholm message if can see a player.
			if ( FRand() < mHostage.mThreatenedStockholmChance )
			{
				foreach gi.RadiusSASPawns( class'SASSoldier', soldier, mHostage.Location, mHostage.SightRadius )
				{
					if (	(soldier.Controller.mType == CONTROLLER_Player) &&
							soldier.IsAlive() && 
							!soldier.mbIsIncapacitated &&
							CanSee( soldier ) )
					{
						eSelectedSpeech = SPEECH_HostageStockholm;
						break;			
					}
				}
			}

			// Randomly play plead for help message.
			if (	(eSelectedSpeech == SPEECH_None) &&
					(FRand() < mHostage.mThreatenedPleadForHelpChance) )
			{	
				eSelectedSpeech = SPEECH_HostageStockholm;
			}
		}

		// If no other speech type selected, play a whimper sound.
		if ( eSelectedSpeech == SPEECH_None )
		{
			eSelectedSpeech = SPEECH_HostageWhimper;
		}
		
		mHostage.PlaySpeech( eSelectedSpeech );
	}


	//-----------------------------------------------------------------------------
	// AllowNoiseReaction
	//
	function bool AllowNoiseReaction( 
		ENoiseReaction	aeRectionType )
	{
		// Only allow flinching in threatened mode
		if ( aeRectionType == NOISEREACT_Flinch )
		{
			return true;
		}

		return false;
	}


Begin:

	StopMoving();

	// Transition to standing if not already doing so.
	if ( mHostage.meStance != STANCE_Standing )
	{
		DoStanceTransition( STANCE_Standing, GetStateName() );
	}
	else
	{
		mHostage.AnimateStandToCaptive();
	}

	// Start timer for playing screams/whimpers. 
	SetMultiTimer( mTimerSpeech, RandRange( mHostage.mGuardedSpeechTime.Min, mHostage.mGuardedSpeechTime.Max ), false ); 
}


//-----------------------------------------------------------------------------
// Whack
//
function bool Whack(
	name	aTerroristHitAnim )
{
	return false;
}


//-----------------------------------------------------------------------------
// STATE TakingBeating
//
// State while taking a beating from a terrorist.
state TakingBeating extends CaptiveState
{
	ignores NotifyBump,
			NotifyPlayerAboutToBump,
			DoStepAside,
			CanStepAside,
			StartTakeBeating;

	//-----------------------------------------------------------------------------
	// BeginState
	//
	event BeginState()
	{
		if ( !mHostage.mbTakingBeating )
		{
			BeginAction( HOSTAGEACTION_Unguarded );
		}

		SetTimer( 0.0, false );
	}


	//-----------------------------------------------------------------------------
	// EndState
	//
	event EndState()
	{
		Super.EndState();
		mHostage.EndPlayActionAnim( 0.2 );
	}


	//-----------------------------------------------------------------------------
	// Timer
	//
	event Timer()
	{
		if ( VSizeHorizSq( mHostage.Location - mHostage.mGuardingTerrorist.Location ) < Square( 250.0 ) )
		{
			SetFocus( mHostage.mGuardingTerrorist );
		}
		else
		{
			FixCurrentFacing();
		}
	}


	//-----------------------------------------------------------------------------
	// MultiTimer
	//
	event MultiTimer(
		int	aTimerIdx )
	{
		switch ( aTimerIdx )
		{
		case mTimerSpeech:
			mHostage.PlaySpeech( SPEECH_HostageWhimper );
			SetMultiTimer( mTimerSpeech, RandRange( mHostage.mGuardedSpeechTime.Min, mHostage.mGuardedSpeechTime.Max ), false );
			break;

		default:
			Global.MultiTimer( aTimerIdx );
		}
	}


	//-----------------------------------------------------------------------------
	// Whack
	//
	function bool Whack(
		name	aTerroristHitAnim )
	{
		local name	anim;

		anim = mHostage.GetBeatenReactionAnim( aTerroristHitAnim );
		if ( anim != 'None' )
		{
			FixCurrentFacing();
			mHostage.PlayActionAnim( anim, 1.0, 0.2, true );
			return true;
		}

		return false;
	}

Begin:

	FixCurrentFacing();
	StopMoving();

	// First make sure hostage is in correct stance required by the guarding terrorist.
	if ( mHostage.mGuardingTerrorist.mbBeatKneelingHostage )
	{
		if ( mHostage.meStance != STANCE_Crouched )
		{
			DoStanceTransition( STANCE_Crouched, GetStateName() );
		}
	}
	else if ( mHostage.meStance != STANCE_Standing )
	{
		DoStanceTransition( STANCE_Standing, GetStateName() );
	}

	// Set timer for reassessing focus.
	SetTimer( 0.5, true );

	// Start timer for playing screams/whimpers. 
	SetMultiTimer( mTimerSpeech, RandRange( mHostage.mGuardedSpeechTime.Min, mHostage.mGuardedSpeechTime.Max ), false ); 
}


//-----------------------------------------------------------------------------
// STATE WiredWithExplosives
//
state WiredWithExplosives
{
	ignores NotifyBump,
			NotifyPlayerAboutToBump,
			DoStepAside,
			CanStepAside,
			ServerDoPunchedByPlayer,
			CheckCanBePunched;

	//-----------------------------------------------------------------------------
	// StateCanBeOrdered
	//
	function bool StateCanBeOrdered()
	{
		return false;
	}


	//-----------------------------------------------------------------------------
	// BeginState
	//
	event BeginState()
	{
		Enable( 'SeePlayer' );
	}


	//-----------------------------------------------------------------------------
	// SeePlayer
	//
	// Used for triggering warning speech.
	event SeePlayer(
		Pawn	aSeenPawn )
	{
		local float	distSq;

		if ( mbIdentWiredSelf )
		{
			Disable( 'SeePlayer' );
			return;
		}

		// Only speak to players.
		if (	(aSeenPawn.mPawnType == PAWN_Soldier) &&
				(aSeenPawn.Controller.mType == CONTROLLER_Player) )
		{
			// Only speak if someone else has not just done so on my behalf.
			if (	(mIdentWiredByOtherTime == 0.0) ||
					((Level.TimeSeconds - mIdentWiredByOtherTime) > 3.0) )
			{
				distSq = VSizeSq( mHostage.Location - aSeenPawn.Location );
				if ( distSq < Square( mHostage.mExplosiveWarnMaxDist ) )
				{
					mHostage.PlaySpeech( SPEECH_HostageBombWarnSelf );
					mbIdentWiredSelf = true;
					Disable( 'SeePlayer' );
				}				
			}
		}
	}


	//-----------------------------------------------------------------------------
	// ExplosiveDisarmed
	//
	function ExplosiveDisarmed()
	{
		mHostage.PlaySpeech( SPEECH_HostageThanks );
		BeginAction( HOSTAGEACTION_Unguarded );
	}


Begin:

	StopMoving();
	mHostage.ChangeStanceImmediate( STANCE_Crouched );
}


//-----------------------------------------------------------------------------
// STATE TapedGun
//
state TapedGun extends MovingState
{
	//-----------------------------------------------------------------------------
	// BeginState
	//
	event BeginState()
	{
		Enable( 'SeePlayer' );
		SetTimer( 0.0, false );
		StopMultiTimer( mTimerSpeech );
	}


	//-----------------------------------------------------------------------------
	// EndState
	//
	event EndState()
	{
		Enable( 'SeePlayer' );
		StopMoving();
	}


	//-----------------------------------------------------------------------------
	// Timer
	//
	event Timer()
	{
		if ( InDeactivationRangeOfPlayer() ) 
		{
			mHostage.mbGunTapedToHand = false;
			StopMoving();
			BeginAction( HOSTAGEACTION_Unguarded );
			return;
		}

		// TODO: Check if can see player - if not seen for a certain time then stop moving.
		
		SetTimer( 0.5, false );
	}


	//-----------------------------------------------------------------------------
	// MultiTimer
	//
	event MultiTimer(
		int	aTimerIdx )
	{
		switch( aTimerIdx )
		{
		case mTimerSpeech:
			mHostage.PlaySpeech( SPEECH_HostageDontShootMe );
			SetMultiTimer( 
				mTimerSpeech, 
				RandRange( 
						mHostage.mGunTapedToHandSpeechInterval.Min,
						mHostage.mGunTapedToHandSpeechInterval.Max ), 
				false );
			break;

		default:
			Global.MultiTimer( aTimerIdx );
			break;
		}
	}


	//-----------------------------------------------------------------------------
	// AllowNoiseReaction
	//
	function bool AllowNoiseReaction( 
		ENoiseReaction	aeRectionType )
	{
		// Only allow flinching.
		if ( aeRectionType == NOISEREACT_Flinch )
		{
			return true;
		}

		return false;
	}


	//-----------------------------------------------------------------------------
	// InDeactivationRangeOfPlayer
	//
	function bool InDeactivationRangeOfPlayer()
	{
		local float	dist;

		// Check horizontal range.
		dist = VSizeHorizSq( mHostage.Location - Target.Location );
		if ( dist > Square( mHostage.mGunTapedToHandDeactivationRange ) )
		{
			return false;
		}

		// Check approximately at same vertical level.
		dist = Abs( mHostage.Location.Z - Target.Location.Z );
		if ( dist > (mHostage.Default.CollisionHeight * 2.5 ) )
		{
			return false;
		}

		return true;
	}	


	//-----------------------------------------------------------------------------
	// SeePlayer
	//
	event SeePlayer( 
		Pawn	aSeenPawn )
	{
		local SASSoldier	soldier,
							otherSoldier,
							closestPlayerPawn,
							runToPawn;
		local float			distSq,
							closestDistSq;
		local SASGameInfo	gi;

		if ( aSeenPawn.mPawnType == PAWN_Soldier )
		{
			soldier = SASSoldier( aSeenPawn );

			if ( soldier.Controller.mType != CONTROLLER_Player )
			{
				// For non-player soldiers, can run toward them if they are in same AV.
				if ( soldier.GetAssaultVolume() == mHostage.GetAssaultVolume() )
				{
					gi = mHostage.GetGame();
					if ( gi != None )
					{
						// If there is a player controlled soldier nearby and in same AV then run at him instead. 
						closestDistSq = Square( 250.0 );				
						foreach gi.AssaultVolumeSASPawns( class'SASSoldier', otherSoldier, soldier.GetAssaultVolume() )
						{
							if ( otherSoldier.Controller.mType == CONTROLLER_Player )
							{
								distSq = VSizeSq( otherSoldier.Location - soldier.Location );
								if ( distSq < closestDistSq ) 
								{
									closestPlayerPawn = otherSoldier;
									closestDistSq = distSq;
								}
							}
						}

						if ( closestPlayerPawn != None )
						{
							runToPawn = closestPlayerPawn;
						}
						else
						{
							runToPawn = soldier;
						}
					}
				}
			}
			else
			{
				// Seen pawn is a player.
				runToPawn = soldier;
			}

			if ( runToPawn != None )
			{
				Disable( 'SeePlayer' );
				Target = aSeenPawn;
				GotoState( , 'RunAtPlayer' );
			}
		}
	}


	//-----------------------------------------------------------------------------
	// NotifyObstructedDuringMove
	//
	event bool NotifyObstructedDuringMove(
		SASPawn	aObstructedBy )
	{
		// Just end state.
		mHostage.mbGunTapedToHand = false;
		StopMoving();
		BeginAction( HOSTAGEACTION_Unguarded );
		return true;
	}


	//-----------------------------------------------------------------------------
	// NotifyGoalLocationIsBlocked
	//
	function bool NotifyGoalLocationIsBlocked(
		SASPawn	aObstructor )
	{
		return NotifyObstructedDuringMove( aObstructor );
	}


	// TODO: Deal with leaving this state and reenterring - need to remember if started running at player.
	// Need to handle stoppping and starting speech timer.

Begin:

	StopMoving();
	
	// Transition to standing if not already doing so.
	if ( mHostage.meStance != STANCE_Standing )
	{
		DoStanceTransition( STANCE_Standing, GetStateName() );
	}
	Stop;

RunAtPlayer:

	// Set timer to play 'don't shoot' speech.
	SetMultiTimer( 
		mTimerSpeech, 
		RandRange( 
			mHostage.mGunTapedToHandInitialSpeechDelay.Min,
			mHostage.mGunTapedToHandInitialSpeechDelay.Max ),
		false );

	// Set time to assess if in player range.
	SetTimer( RandRange( 0.5, 0.65 ), false );

	// Run at player.
	DoMoveToActor( Target, PACE_Running,,,, 32.0 );

MTP_FinishedMove:

	if ( !InDeactivationRangeOfPlayer() )
	{
		StopMoving();
		Enable( 'SeePlayer' );
	}
}



//-----------------------------------------------------------------------------
// STATE WettingSelf
//
state WettingSelf
{
	ignores SeePlayer,
			NotifyBump,
			NotifyPlayerAboutToBump,
			DoStepAside,
			CanStepAside;

	//-----------------------------------------------------------------------------
	// EndState
	//
	event EndState()
	{
		if ( mHostage != None )
		{
			mHostage.mbWettingSelf = false;
			mHostage.EndPlayActionAnim( 0.25 );
			mHostage.ChangeAnimation();

			// Stop the wee pool growing.
			if ( mHostage.mPoolOfWee != None )
			{
				mHostage.mPoolOfWee.mEndScale = mHostage.mPoolOfWee.DrawScale;
				mHostage.mPoolOfWee = None;
			}

			// Stop the dripping.
			if ( mHostage.mWeeWeeDrip != None )
			{
				mHostage.mWeeWeeDrip.Destroy();
				mHostage.mWeeWeeDrip = None;
			}
		}
	}


	//-----------------------------------------------------------------------------
	// HaveAnAccident
	//
	function HaveAnAccident()
	{
		local Actor		hitActor;
		local Vector	groundLoc,
						groundNormal,
						startTrace,
						endTrace;

		// Force wetting self anim to start. 
		mHostage.mbWettingSelf = true;
		mHostage.ChangeAnimation();

		// Init the particles
		mHostage.mWeeWeeDrip = Spawn( class'SASWeeWeeDrip' );
		if ( mHostage.mWeeWeeDrip != None )
		{
			// Attach to pelvis.
			mHostage.AttachToBone( mHostage.mWeeWeeDrip, PELVIS_BONE );
		}

		// Find where to spawn the pool.
		startTrace = mHostage.Location;
		endTrace = startTrace;
		endTrace.Z -= mHostage.CollisionHeight + 16.0;
		hitActor = mHostage.Trace( 
			groundLoc,
			groundNormal,
			endTrace,
			mHostage.Location );

		if ( hitActor != None )
		{
			// Init the pool
			groundLoc.Z += 4.0;
			mHostage.mPoolOfWee = Spawn( class'SASWeeWeePool',,, groundLoc, Rotator( vect(0,0,-1) ) );
		}

		// Set timer to trigger whimpering.
		SetTimer( RandRange( 0.2, 0.4 ), false );
	}


	//-----------------------------------------------------------------------------
	// Timer
	//
	event Timer()
	{
		local float				duration;
		local Sound				whimperSound;
		local SASHostageVoice	myVoice;

		if ( mHostage != None )
		{
			// GP: Should be using PlaySpeech but that means we don't know which sample is selected
			// and hence can't get the sample duration which is needed for resetting this timer event.
			
			//mHostage.PlaySpeech( SPEECH_HostageWhimper );
			
			myVoice = SASHostageVoice( mHostage.mVoice );
			if ( (myVoice != None) && (myVoice.mWhimperSounds.Length > 0) )
			{
				whimperSound = myVoice.mWhimperSounds[Rand( myVoice.mWhimperSounds.Length )];

				mHostage.PlaySound( 
					whimperSound,
					SLOT_Talk,			
					1.0,
					true,
					myVoice.mSpeechRadius,	
					1.0,	
					true );
				
				// Set timer to trigger at end of current whimper.
				duration = GetSoundDuration( whimperSound );
				SetTimer( duration + RandRange( 1.5, 2.5 ), false );
			}
		}
	}


	//-----------------------------------------------------------------------------
	// AllowNoiseReaction
	//
	function bool AllowNoiseReaction( 
		ENoiseReaction	aeReactionType )
	{
		// Only allow flinching.
		if ( aeReactionType == NOISEREACT_Flinch )
		{
			return true;
		}
		return false;
	}


	//-----------------------------------------------------------------------------
	// RequestUnobstructAction
	//
	function bool RequestUnobstructAction(
		Pawn	aObstructing )
	{
		// Go to dive to ground state which will then stop us being an obstruction.
		SetCurrentMajorAction( HOSTAGEACTION_Unguarded );
		BeginAction( HOSTAGEACTION_DiveToGround );
		return true;
	}


Begin:

	// Fix facing direction.
	FixCurrentFacing();

	// Transition to crouched stance if not currently in it.
	if ( mHostage.meStance != STANCE_Crouched )
	{
		DoStanceTransition( STANCE_Crouched, GetStateName(),, RandRange( 0.85, 1.2 ) );
	}

	HaveAnAccident();
}


//-----------------------------------------------------------------------------
// STATE Stockholm
//
state Stockholm
{
	ignores SeePlayer,
			NotifyBump,
			NotifyPlayerAboutToBump,
			DoStepAside,
			CanStepAside;

	//-----------------------------------------------------------------------------
	// BeginState
	//
	event BeginState()
	{
		StopMultiTimer( mTimerSpeech );
	}

	//-----------------------------------------------------------------------------
	// EndState
	//
	event EndState()
	{
		StopMultiTimer( mTimerSpeech );
	}

	//-----------------------------------------------------------------------------
	// AllowNoiseReaction
	//
	function bool AllowNoiseReaction( 
		ENoiseReaction	aeReactionType )
	{
		// Only allow flinching.
		if ( aeReactionType == NOISEREACT_Flinch )
		{
			return true;
		}
		return false;
	}


	//-----------------------------------------------------------------------------
	// MultiTimer
	//
	event MultiTimer(
		int	aTimerIdx )
	{
		switch( aTimerIdx )
		{
		case mTimerSpeech:
			if ( CanStockholm() )
			{
				mHostage.PlayDelayedSpeech( SPEECH_HostageStockholm, false );
			}
			break;
		}
	}


	//-----------------------------------------------------------------------------
	// RequestUnobstructAction
	//
	function bool RequestUnobstructAction(
		Pawn	aObstructing )
	{
		// Go to dive to ground state which will then stop us being an obstruction.
		SetCurrentMajorAction( HOSTAGEACTION_Unguarded );
		BeginAction( HOSTAGEACTION_DiveToGround );
		return true;
	}

Begin:

	SetFocus( mFirstSeenSoldier );
	FinishRotation( 3640 );
	FixCurrentFacing();

	// Set timer to play stockholm speech after a delay.
	if ( mHostage.mVoice != None ) 
	{
		SetMultiTimer( 
			mTimerSpeech, 
			RandRange( 
				SASHostageVoice( mHostage.mVoice ).mStockholmDelay.Min,
				SASHostageVoice( mHostage.mVoice ).mStockholmDelay.Max ), 
			false );
	}

	// Transition to crouched stance if not currently in it.
	if ( mHostage.meStance != STANCE_Crouched )
	{
		DoStanceTransition( STANCE_Crouched, GetStateName(),, RandRange( 0.85, 1.2 ) );
	}
}


//-----------------------------------------------------------------------------
// STATE SteppingAside
//
state SteppingAside
{
	ignores SeePlayer,
			PlayerOrder;

	function bool ShouldStepAsideFor(
		Actor			aOther,
		optional bool	abConsiderStationaryActors )
	{
		if ( meMajorAction == HOSTAGEACTION_Panicking )
		{
			return false;
		}

		return Super.ShouldStepAsideFor( aOther, abConsiderStationaryActors );
	}
}


//-----------------------------------------------------------------------------
// STATE Panicking
//
state Panicking extends MovingState
{
	ignores SeePlayer,
			PlayerOrder;


	//-----------------------------------------------------------------------------
	// StateCanBeOrdered
	//
	function bool StateCanBeOrdered()
	{
		return false;
	}
	

	//-----------------------------------------------------------------------------
	// BeginState
	//
	event BeginState()
	{
		Super.BeginState();

		RelinquishCoverPoint();
		SetTimer( 0.0, false );
		StopMultiTimer( mTimerSpeech );
	}


	//-----------------------------------------------------------------------------
	// EndState
	//
	event EndState()
	{
		Super.EndState();

		StopMoving();

		if ( mHostage != None )
		{
			//mHostage.EndPlayActionAnim( 0.4 );
		}

		SetTimer( 0.0, false );
		StopMultiTimer( mTimerSpeech );
	}


	//-----------------------------------------------------------------------------
	// Timer
	//
	// Used for less frequent check for seeing threats in same AV.
	event Timer()
	{
		if ( PanicLineOfSightToThreat() )
		{
			mLastSeenThreatTime = Level.TimeSeconds;
			SetTimer( RandRange( 2.0, 3.0 ), false );
		}
		else
		{
			if ( mLastSeenThreatTime < (Level.TimeSeconds - mHostage.mPanicTimeout) )
			{
				PanicSeekCover( false );
				if ( mCoverPoint != None )
				{
					GotoState( , 'UpdateDest' );
				}
				else
				{
					// Try again later.
					SetTimer( RandRange( 2.0, 3.0 ), false );
				}
			}
		}
	}


	//-----------------------------------------------------------------------------
	// MultiTimer
	//
	event MultiTimer(
		int	aTimerIdx )
	{
		switch( aTimerIdx )
		{
		case mTimerSpeech:
			mHostage.PlaySpeech( SPEECH_HostagePanic );
			SetMultiTimer( 
				mTimerSpeech, 
				RandRange( mHostage.mPanicSpeechInterval.Min, mHostage.mPanicSpeechInterval.Max ),
				false );
			break;

		default:
			Global.MultiTimer( aTimerIdx );
		}
	}


	//-----------------------------------------------------------------------------
	// NotifyObstructedDuringMove
	//
	event bool NotifyObstructedDuringMove(
		SASPawn	aObstructedBy )
	{
		// Seek CP to move to else just get down here. 
		//SetCurrentMajorAction( HOSTAGEACTION_Unguarded );
		//BeginAction( HOSTAGEACTION_TakeCover );
		return true;
	}

	//-----------------------------------------------------------------------------
	// NotifyGoalLocationIsBlocked
	//
	function bool NotifyGoalLocationIsBlocked(
		SASPawn	aObstructor )
	{
		return NotifyObstructedDuringMove( aObstructor );
	}


Begin:

	// Choose random EP to run toward
	if ( !mbStartedPanic )
	{
		mbStartedPanic = true;

		mPanicTargetEP = None;
		mPanicCurAV = None;
		mPanicPrevAV = None;

		// Note time we started the state.
		mLastSeenThreatTime = Level.TimeSeconds;

		// Set multitimer for playing speech.
		SetMultiTimer( mTimerSpeech, RandRange( 0.2, 1.0 ), false );

	}
	else
	{
		// Set multitimer for playing speech.
		SetMultiTimer( mTimerSpeech, RandRange( mHostage.mPanicSpeechInterval.Min, mHostage.mPanicSpeechInterval.Max ), false );	
	}
	
	// Set timer to check for sighting of threats.
	SetTimer( RandRange( 2.0, 3.0 ), false );
	
	// Play panic animation.
	mHostage.PlayPanic( false );

	if ( (mPanicTargetEP != None) || (mCoverPoint != None) )
	{
		Goto( 'MoveToTargetPoint' );
	}

UpdateDest:

	if ( mCoverPoint == None )
	{
		ChoosePanicDestEP();
		if ( mPanicTargetEP == None )
		{
			mbStartedPanic = false;
			BeginAction( HOSTAGEACTION_Unguarded );
			Stop;
		}
	}

MoveToTargetPoint:
	
	if ( mCoverPoint != None )
	{
		DoMoveToActor( mCoverPoint, PACE_Running );
	}
	else
	{
		DoMoveToActor( mPanicTargetEP, PACE_Running );
	}

MTP_FinishedMove:

	if ( mCoverPoint != None )
	{
		// If failed to reach CP, relinquish it and resume panic run around.
		if ( !mHostage.ReachedDestination( mCoverPoint ) )
		{
			RelinquishCoverPoint();
			Goto( 'UpdateDest' );
		}

		mbStartedPanic = false;
		SetCurrentMajorAction( HOSTAGEACTION_Unguarded );
		BeginAction( HOSTAGEACTION_TakeCover );
		Stop;
	}
	else if ( !mHostage.ReachedDestination( mPanicTargetEP ) )
	{
		// GPTODO: Consider other EPs if this is not the only one.

		StopMoving();
		Sleep( 0.5 );
		Goto( 'MoveToTargetPoint' );
	}

	// Find next EP in next AV.
	mPanicPrevAV = mPanicCurAV;
	mPanicCurAV = mPanicTargetEP.GetOtherAssaultVolume( mPanicCurAV );

	// Reached EP, if there are no threats in the next AV then seek cover, else keep going.
	PanicSeekCover( true );
	Goto( 'UpdateDest' );
}


//-----------------------------------------------------------------------------
// STATE CoverHiding
//
state CoverHiding extends MovingState
{
	event BeginState()
	{
		Super.BeginState();

		mbTakingCover = true;
		SetTimer( 0.0, false );
	}

	event EndState()
	{
		Super.EndState();

		RelinquishCoverPoint();

		SetTimer( 0.0, false );
	}

	event AnimEnd(
		int	aChannel )
	{
		if ( aChannel == 0 && !mbTakingCover )
		{
			GotoState( , 'Unhiding' );
		}
		
		Pawn.AnimEnd( aChannel );
	}

	function Timer()
	{
		mbTakingCover = false;
	}

	function ENoiseReaction GetNoiseReaction( 
		Actor		aNoiseMaker, 
		float		aLoudness,
		ENoiseType	aNoiseType,
		Vector		aNoiseLoc )
	{
		// Reset timer if required.
		/*if ( Pawn.ReachedDestination( mCoverPoint ) )
		{
			SetTimer( RandRange( mHostage.mTimeInCover.Min, mHostage.mTimeInCover.Max ), false );
			mbTakingCover = true;
		}*/

		return Global.GetNoiseReaction( 
			aNoiseMaker, 
			aLoudness,
			aNoiseType,
			aNoiseLoc );
	}


	//-----------------------------------------------------------------------------
	// AllowNoiseReaction
	//
	// Only allow flinching.
	function bool AllowNoiseReaction( 
		ENoiseReaction	aeRectionType )
	{
		if ( aeRectionType == NOISEREACT_Flinch )
		{
			return true;
		}
		return false;
	}


	//-----------------------------------------------------------------------------
	// NotifyObstructedDuringMove
	//
	event bool NotifyObstructedDuringMove(
		SASPawn	aObstructedBy )
	{
		// Someones standing on my CP - lets just get down now.
		GotoState( , 'Hiding' );		
		return true;
	}


	//-----------------------------------------------------------------------------
	// NotifyGoalLocationIsBlocked
	//
	function bool NotifyGoalLocationIsBlocked(
		SASPawn	aObstructor )
	{
		// Someones standing on my CP - lets just get down now.
		GotoState( , 'Hiding' );
		return true;
	}


	//-----------------------------------------------------------------------------
	// RequestUnobstructAction
	//
	function bool RequestUnobstructAction(
		Pawn	aObstructing )
	{
		// Go to unguarded state which will then allow us to do avoidance out of 
		// the way of who we are obstructing.
		BeginAction( HOSTAGEACTION_Unguarded );
		return true;
	}


Begin:

	if ( Pawn.ReachedDestination( mCoverPoint ) )
	{
		Goto( 'Hiding' );
	}

	DoMoveToActor( mCoverPoint, PACE_Running );

MTP_FinishedMove:

	// If failed to reach cover then dive to ground.
	if ( !Pawn.ReachedDestination( mCoverPoint ) )
	{
		// Not if handcuffed.
		if ( !mHostage.mbCaptured )
		{
			BeginAction( HOSTAGEACTION_DiveToGround );
			Stop;
		}
	}

Hiding:

	StopMoving();

	// Fix facing direction.
	FixCurrentFacing();
	SetFocalPointFromDir( Vector(mCoverPoint.Rotation) );
	FinishRotation();

	// Crouch (and animate to crouched if required)
	if ( mSASPawn.meStance == STANCE_Standing )
	{
		mSASPawn.AnimateStandToCrouch( 2.0 );
	}
	mSASPawn.ChangeStanceImmediate( STANCE_Crouched );
	
	// Set timer to check for leaving cover.
	//SetTimer( RandRange( mHostage.mTimeInCover.Min, mHostage.mTimeInCover.Max ), false );
	Stop;

Unhiding:

	ResumeMajorAction();
}


//-----------------------------------------------------------------------------
// STATE DiveToGround
//
state DiveToGround
{
	ignores NotifyBump,
			NotifyPlayerAboutToBump,
			DoStepAside,
			CanStepAside,
			ServerDoPunchedByPlayer,
			CheckCanBePunched,
			ReactToGrenade;

	function ENoiseReaction GetNoiseReaction( 
		Actor		aNoiseMaker, 
		float		aLoudness,
		ENoiseType	aNoiseType,
		Vector		aNoiseLoc )
	{
		// Reset timer if required.
		if ( Pawn.ReachedDestination( mCoverPoint ) )
		{
			SetTimer( RandRange( mHostage.mTimeInCover.Min, mHostage.mTimeInCover.Max ), false );
			mbTakingCover = true;
		}
		
		return NOISEREACT_None;
	}


	//-----------------------------------------------------------------------------
	// NotifyStartedCuffing
	//
	function NotifyStartedCuffing()
	{
		mHostage.mbCuffingStarted = true;
		BeginAction( HOSTAGEACTION_OrderedDown );
	}

	event BeginState()
	{
		// Should not be in this state if handcuffed.
		if ( mHostage.mbCaptured )
		{
			BeginAction( HOSTAGEACTION_Unguarded );
			return;
		}

		mbTakingCover = true;
		SetTimer( 0.0, false );
	}

	event EndState()
	{
		mbTakingCover = false;
		SetTimer( 0.0, false );

		if ( mHostage != None )
		{
			mHostage.mbReadyToBeCuffed = false;

			mHostage.bIgnoreSpine = false;
			mHostage.SetNonZeroExtentTraces( true );
		}
	}

	function Timer()
	{
		// Don't exit this state when there are grenades about.
		if ( mNumGrenadesDetected > 0 )
		{
			SetTimer( RandRange( mHostage.mTimeInCover.Min, mHostage.mTimeInCover.Max ), false );
			mbTakingCover = true;
		}
		else
		{
			mbTakingCover = false;
		}
	}

	event AnimEnd( 
		int	aChannel )
	{
		// When anim loop has completed and no longer taking cover then stand up again.
		if ( aChannel == 0 && !mbTakingCover )
		{
			GotoState( , 'StandUp' );
		}
	
		Pawn.AnimEnd( aChannel );
	}

Begin:

	// Play dive to ground anim if required.
	if ( mHostage.meStance != STANCE_Prone )
	{
		// Try to find good direction to go prone.
		FindDirectionToGoProne();
		SetFocalPointFromDir( mProneFocalDir );
		mHostage.bIgnoreSpine = true;
		FinishRotation();
		mHostage.bIgnoreSpine = false;

		mHostage.PlayDiveToGround();
		mHostage.SetNonZeroExtentTraces( false );
		mHostage.ChangeStanceImmediate( STANCE_Prone );
		FinishAnim( ANIMCHANNEL_Action );
		mHostage.ChangeAnimation();
	}
	else
	{
		// Fix facing direction.
		FixCurrentFacing();
	}

	mHostage.mbReadyToBeCuffed = true;

	// Set timer to check for getting up.
	SetTimer( RandRange( mHostage.mTimeInCover.Min, mHostage.mTimeInCover.Max ), false );

	Stop;

EndDiveToGround:

	ResumeMajorAction();
}


//-----------------------------------------------------------------------------
// STATE Cowering
//
state Cowering
{
	event BeginState()
	{
		if ( !mHostage.mbCowering )
		{
			mHostage.mbCowering = true;
			mHostage.ChangeAnimation();
		}
	}

	event EndState()
	{
		if ( mHostage.mbCowering )
		{
			mHostage.mbCowering = false;
			mHostage.ChangeAnimation();
		}
	}

Begin:

	// Transition to crouched stance if not currently in it.
	if ( mHostage.meStance != STANCE_Crouched )
	{
		DoStanceTransition( STANCE_Crouched, GetStateName(),, RandRange( 0.85, 1.2 ) );
	}

	// Make hostage switch to cowering base anim immediately.
	mHostage.ChangeAnimation();
}


//-----------------------------------------------------------------------------
// STATE OrderedDown
//
state OrderedDown
{
	ignores ServerDoPunchedByPlayer,
			CheckCanBePunched;

	//-----------------------------------------------------------------------------
	// IsOrderedDown
	//
	simulated event bool IsOrderedDown()
	{
		return true;
	}


	//-----------------------------------------------------------------------------
	// BeginState
	//
	event BeginState()
	{
		if ( mHostage.mbCaptured )
		{
			BeginAction( HOSTAGEACTION_Restrained );
		}
	}


	//-----------------------------------------------------------------------------
	// EndState
	//
	event EndState()
	{
		if ( mHostage != None )
		{
			mHostage.mbReadyToBeCuffed = false;

			mHostage.bIgnoreSpine = false;
			mHostage.bDisableTurnAnims = false;

			// Turn on collision blocking.
			mHostage.SetNonZeroExtentTraces( true );
		}
	}


	//-----------------------------------------------------------------------------
	// NotifyStartedCuffing
	//
	function NotifyStartedCuffing()
	{
		if ( !mHostage.mbCuffingStarted )
		{
			mHostage.mbCuffingStarted = true;
			mHostage.PlayCuffingAnim();
			mHostage.ChangeAnimation();
		}
	}


	//-----------------------------------------------------------------------------
	// NotifyStoppedCuffing
	//
	function NotifyStoppedCuffing()
	{
		if ( !mHostage.mbCaptured && mHostage.mbCuffingStarted )
		{
			mHostage.mbCuffingStarted = false;

			mHostage.PlayCuffingStopped();
			mHostage.ChangeAnimation();
		}
	}


	//-----------------------------------------------------------------------------
	// NotifyCaptured
	//
	function NotifyCaptured()
	{
		BeginAction( HOSTAGEACTION_Restrained );
	}


	//-----------------------------------------------------------------------------
	// GetNoiseReaction
	//
	function ENoiseReaction GetNoiseReaction( 
		Actor		aNoiseMaker, 
		float		aLoudness,
		ENoiseType	aNoiseType,
		Vector		aNoiseLoc )
	{
		// Don't react to gun fire when ordered down.
		return NOISEREACT_None;
	}


	//-----------------------------------------------------------------------------
	// AllowNoiseReaction
	//
	function bool AllowNoiseReaction( 
		ENoiseReaction	aeReactionType )
	{
		return false;
	}


	//-----------------------------------------------------------------------------
	// StateCanBeOrdered
	//
	function bool StateCanBeOrdered()
	{
		return false;
	}


Begin:

	StopMoving();

	// If entering this state when already started cuffing then make sure cuffing anims are playing.
	if ( mHostage.mbCuffingStarted )
	{
		mHostage.mbReadyToBeCuffed = true;
		mHostage.PlayCuffingAnim();
		mHostage.ChangeAnimation();
	}	
	// If not already ordered down and actually got down then do it.
	else if ( mHostage.meStance != STANCE_Prone )
	{
		// Try to find good direction to go prone.
		FindDirectionToGoProne();
		SetFocalPointFromDir( mProneFocalDir );

		// No turn anims for turn when crouched - disable turn anim playing.
		if ( mHostage.meStance == STANCE_Crouched )
		{
			mHostage.bDisableTurnAnims = true;
		}

		mHostage.bIgnoreSpine = true;
		FinishRotation();
		mHostage.bIgnoreSpine = false;

		mHostage.bDisableTurnAnims = false;

		DoStanceTransition( STANCE_Prone, GetStateName() );
	}

	mHostage.mbReadyToBeCuffed = true;

	FixCurrentFacing();

	// Turn off collision blocking while prone.
	mHostage.SetNonZeroExtentTraces( false );
}


//-----------------------------------------------------------------------------
// STATE Restrained
//
state Restrained
{
	//-----------------------------------------------------------------------------
	// EndState
	//
	event EndState()
	{
		if ( mHostage != None )
		{
			mHostage.bIgnoreSpine = false;
			mHostage.bDisableTurnAnims = false;

			// Turn on collision blocking.
			mHostage.SetNonZeroExtentTraces( true );
		}
	}

Begin:

	// If not already ordered down and actually got down then do it.
	if ( mHostage.meStance != STANCE_Prone )
	{
		// Try to find good direction to go prone.
		FindDirectionToGoProne();
		SetFocalPointFromDir( mProneFocalDir );

		// No turn anims for turn when surrendered - disable turn anim playing.
		mHostage.bDisableTurnAnims = true;

		mHostage.bIgnoreSpine = true;
		FinishRotation();
		mHostage.bIgnoreSpine = false;

		mHostage.bDisableTurnAnims = false;

		DoStanceTransition( STANCE_Prone, GetStateName(),, RandRange( 1.25, 1.6 ) );
	}

	// Turn off collision blocking while prone.
	mHostage.SetNonZeroExtentTraces( false );
}


//-----------------------------------------------------------------------------
// STATE Following
//
// Follow specified actor (generally the player).
state Following extends MovingState
{
	ignores NotifyHitWall;

	
	event BeginState()
	{
		Super.BeginState();
		mHostage.mbIsFollowing = true;
	}

	event EndState()
	{
		Super.EndState();
		if ( mHostage != None )
		{
			mHostage.mbIsFollowing = false;
		}
	}

	//-----------------------------------------------------------------------------
	// AllowNoiseReaction
	//
	function bool AllowNoiseReaction( 
		ENoiseReaction	aeReactionType )
	{
		// Only allow flinching.
		if ( aeReactionType == NOISEREACT_Flinch )
		{
			return true;
		}
		return false;
	}


	//-----------------------------------------------------------------------------
	// NotifyCompletedMove
	//
	function NotifyCompletedMove()
	{
		// Reassess where we are heading.
		if ( !mbFailedMoveToPoint && !IsFollowTrackPointValid( mActorTracker.Location ) )
		{
			// Restarting state to make hostage find new destination.
			GotoState( , '' );
		}
	}	


	//-----------------------------------------------------------------------------
	// Timer
	//
	// Used to periodically reassess suitability of current follow destination.
	event Timer()
	{
		// Reassess where we are heading.
		if ( !IsFollowTrackPointValid( mActorTracker.Location ) )
		{
			// Restarting state to make hostage find new destination.
			GotoState( , '' );
		}
		// If we're there, face player
		else if (mHostage.ReachedDestination (mActorTracker))
		{
			SetFocus( mFollowTarget );
		}
	}

	//-----------------------------------------------------------------------------
	// NotifyBump
	//
	event bool NotifyBump(
		Actor	aBumped )
	{
		local SASHostage	otherHostage;

		otherHostage = SASHostage( aBumped );
		if ( otherHostage != None )
		{
			// Always try to step aside if we've bumped into someone who is in a step-aside chain which end with
			// a player or door.
			if ( SASHostageController( otherHostage.Controller ).IsInState( 'SteppingAside' ) )
			{
				if ( SASHostageController( otherHostage.Controller ).StepAsideChainEndsInPlayerOrMover( 0 ) )
				{
					return Super.NotifyBump( aBumped );
				}
			}

			// Don't step aside for another hostage if also following and in follow range.
			if (	SASHostageController( otherHostage.Controller ).meMajorAction == HOSTAGEACTION_Following &&
					SASHostageController( otherHostage.Controller ).IsFollowTrackPointValid( otherHostage.Location ) )
			{
				// If I'm in follow range then stop moving.
				if ( IsFollowTrackPointValid( mHostage.Location ) )
				{
					SetFocus( mFollowTarget );
					mActorTracker.SetLocation( mHostage.Location );
					StopMoving();
				}
				return true;
			}

			if ( otherHostage.Controller.IsInState( 'Following' ) || otherHostage.Controller.IsInState( 'SteppingAside' ) )
			{
				if (	mHostage.IsStationary() &&
						SASHostageController( otherHostage.Controller ).meMajorAction == HOSTAGEACTION_Following &&
						!SASHostageController( otherHostage.Controller ).IsFollowTrackPointValid( otherHostage.Location ) )
				{	
					// Start moving again.
					GotoState( , '' );
				}
			}
		}

		return Super.NotifyBump( aBumped );
	}

	//-----------------------------------------------------------------------------
	// NotifyObstructedDuringMove
	//
	event bool NotifyObstructedDuringMove(
		SASPawn	aObstructedBy )
	{
		// If in follow range just stop else need to find alternate path.
		if ( IsFollowTrackPointValid( mHostage.Location ) )
		{
			mActorTracker.SetLocation( mHostage.Location );
			SetFocus( mFollowTarget );
			StopMoving();
		}
		else
		{
			mbFailedMoveToPoint = true;
			GotoState( , 'MTP_FinishedMove' );
		}
		return true;
	}

	//-----------------------------------------------------------------------------
	// NotifyGoalLocationIsBlocked
	//
	function bool NotifyGoalLocationIsBlocked(
		SASPawn	aObstructor )
	{
		return NotifyObstructedDuringMove( aObstructor );
	}

Begin:

	// Stand up first.
	if ( mHostage.meStance != STANCE_Standing )
	{
		DoStanceTransition( STANCE_Standing, GetStateName(),, RandRange( 0.75, 1.25 ) );
	}

	// Ensure we face target actor
	SetFocus( mFollowTarget );

	// HACK - Should be using move to location functionality rather than use an actor object.
	if ( mActorTracker == None )
	{
		mActorTracker = Spawn (class'SASMoveTarget');
	} // if


	if ( !IsValidFollowTarget( mFollowTarget ) )
	{
		StopMoving();
		Sleep( RandRange( 1.0, 1.5 ) );
		Goto ('Begin');
	}
	// Seek tracking point.
	else if ( FindPlayerTrackPoint() )
	{
		// Set timer to reassess tracking location.
		SetTimer( RandRange( 0.8, 1.2 ), true );

		// Move to tracking point.
		mActorTracker.SetLocation( mActorTrackPoint );
		DoMoveToActor( mActorTracker, PACE_Running,,,, mActorTrackPointThreshold );
	}
	else
	{
		Sleep( RandRange( 1.0, 1.5 ) );
		Goto ('Begin');
	}

MTP_FinishedMove:

	StopMoving();
	SetFocus( mFollowTarget );
	if ( mbFailedMoveToPoint )
	{
		Sleep( RandRange( 1.0, 1.5 ) );
		Goto( 'Begin' );
	}
}


//-----------------------------------------------------------------------------
// STATE PunchedByPlayer
//
state PunchedByPlayer
{
	ignores NotifyBump,
			NotifyPlayerAboutToBump,
			DoStepAside,
			CanStepAside,
			SeePlayer,
			HearNoise,
			ServerDoPunchedByPlayer,
			CheckCanBePunched;

	event EndState()
	{
		if ( mHostage != None )
		{
			mHostage.EndPunchedAnim();
			mHostage.bIgnoreSpine = false;
		}
	}

Begin:

	StopMoving();

	// Sound effect.
	mHostage.PlaySpeech( SPEECH_GenHit, true );

	// Try to find good direction to go prone.
	FindDirectionToGoProne();
	SetFocalPointFromDir( mProneFocalDir );
	mHostage.bIgnoreSpine = true;

	if ( mHostage.PlayPunchedAnim() )
	{
		mHostage.ChangeStanceImmediate( STANCE_Prone );
		FinishAnim( ANIMCHANNEL_Action );
	}
	else
	{
		mHostage.ChangeStanceImmediate( STANCE_Prone );
	}

	FinishRotation();

	// Go to ordered down state after punch.
	BeginAction( HOSTAGEACTION_OrderedDown );
}


//-----------------------------------------------------------------------------
// STATE Stunned
//
state Stunned
{
	ignores SeePlayer, 
			HearNoise,
			DamageAttitudeTo;

	//-----------------------------------------------------------------------------
	// GetNoiseReaction
	//
	function ENoiseReaction GetNoiseReaction( 
		Actor		aNoiseMaker, 
		float		aLoudness,
		ENoiseType	aNoiseType,
		Vector		aNoiseLoc )
	{
		// Don't react to gun fire.
		return NOISEREACT_None;
	}


	//-----------------------------------------------------------------------------
	// StateCanBeOrdered
	//
	function bool StateCanBeOrdered()
	{
		// No orders during state.
		return false;
	}


	//-----------------------------------------------------------------------------
	// BeginState
	// 
	event BeginState()
	{
		Super.BeginState();

		// Clear current action if its not a major action.
		ClearTransientAction();
	}


	//-----------------------------------------------------------------------------
	// MultiTimer
	//
	/*event MultiTimer(
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
	}*/


	//-----------------------------------------------------------------------------
	// CanHeadlessChicken
	//
	function bool CanHeadlessChicken()
	{
		if ( !Super.CanHeadlessChicken() )
		{
			return false;
		}

		// First check for major states which don't allow us to move.
		switch ( meMajorAction )
		{
		// Can move in these major states.
		case HOSTAGEACTION_Unguarded:
		case HOSTAGEACTION_TapedGun:
		case HOSTAGEACTION_Panicking:
		case HOSTAGEACTION_Following:
			break;

		// Can't move in any other states.
		default:
			return false;
		}

		if ( meCurAction != meMajorAction )
		{
			switch( meCurAction )
			{
			// Can move in these minor states.
			case HOSTAGEACTION_TakeCover:
				break;

			// Can't move in any other states.
			default:
				return false;
			}
		}

		return true;
	}
}


//-----------------------------------------------------------------------------
// STATE Gassed
//
state Gassed
{
	ignores SeePlayer, 
			HearNoise, 
			DamageAttitudeTo;

	//-----------------------------------------------------------------------------
	// GetNoiseReaction
	//
	function ENoiseReaction GetNoiseReaction( 
		Actor		aNoiseMaker, 
		float		aLoudness,
		ENoiseType	aNoiseType,
		Vector		aNoiseLoc )
	{
		// Don't react to gun fire.
		return NOISEREACT_None;
	}


	//-----------------------------------------------------------------------------
	// StateCanBeOrdered
	//
	function bool StateCanBeOrdered()
	{
		// No orders during state.
		return false;
	}


	//-----------------------------------------------------------------------------
	// BeginState
	//
	event BeginState()
	{
		ClearTransientAction();

		Super.BeginState();
	}


	//-----------------------------------------------------------------------------
	// CanHeadlessChicken
	//
	function bool CanHeadlessChicken()
	{
		if ( !Super.CanHeadlessChicken() )
		{
			return false;
		}

		// First check for major states which don't allow us to move.
		switch ( meMajorAction )
		{
		// Can move in these major states.
		case HOSTAGEACTION_Unguarded:
		case HOSTAGEACTION_TapedGun:
		case HOSTAGEACTION_Panicking:
		case HOSTAGEACTION_Following:
			break;

		// Can't move in any other states.
		default:
			return false;
		}

		if ( meCurAction != meMajorAction )
		{
			switch( meCurAction )
			{
			// Can move in these minor states.
			case HOSTAGEACTION_TakeCover:
				break;

			// Can't move in any other states.
			default:
				return false;
			}
		}

		return true;
	}
}


//-----------------------------------------------------------------------------
// STATE RetreatFromGrenades
//
// Extends SASAIController state.
state RetreatFromGrenades
{
	ignores ReactToGrenade,
			SeePlayer,
			HearNoise,
			DamageAttitudeTo;

	function ENoiseReaction GetNoiseReaction( 
		Actor		aNoiseMaker, 
		float		aLoudness,
		ENoiseType	aNoiseType,
		Vector		aNoiseLoc )
	{
		// Don't react to gun fire.
		return NOISEREACT_None;
	}

	function bool StateCanBeOrdered()
	{
		// No orders during state.
		return false;
	}

	//-----------------------------------------------------------------------------
	// NotifyObstructedDuringMove
	//
	event bool NotifyObstructedDuringMove(
		SASPawn	aObstructedBy )
	{
		// Seek alternate path avoiding obstructing pawns.
		if ( FindUnobstructedPath() )
		{
			GotoState( , 'MTP_PostUpdateDest' );
		}
		else
		{
			// Oh dear... just have to get on the ground and pray.
			GotoState( , 'Blocked' );
		}

		return true;
	}

	//-----------------------------------------------------------------------------
	// NotifyGoalLocationIsBlocked
	//
	function bool NotifyGoalLocationIsBlocked(
		SASPawn	aObstructor )
	{
		// Oh dear... just have to get on the ground and pray.
		GotoState( , 'Blocked' );
		return true;
	}

Blocked:

	if ( mHostage.mbCaptured )
	{
		// Can only crouch down when cuffed.
		//SetCurrentMajorAction( HOSTAGEACTION_Unguarded );
		//BeginAction( HOSTAGEACTION_DiveToGround );
	}
	else
	{
		// Go prone.
		SetCurrentMajorAction( HOSTAGEACTION_Unguarded );
		BeginAction( HOSTAGEACTION_DiveToGround );
	}
}


//-----------------------------------------------------------------------------
// STATE Evacuate
//
state Evacuate extends MovingState
{
	ignores	EnterredEvacuationVolume,
			SeePlayer,
			HearNoise,
			DoStunned,
			DoGassed,
			PlayerOrder;

	//-----------------------------------------------------------------------------
	// StateCanBeOrdered
	//
	function bool StateCanBeOrdered()
	{
		return false;
	}


	//-----------------------------------------------------------------------------
	// DoReachedEvacPoint
	//
	function DoReachedEvacPoint()
	{
		mHostage.Evacuated();
		Pawn.Destroy();
	}


	//-----------------------------------------------------------------------------
	// NotifyGoalLocationIsBlocked
	//
	function bool NotifyGoalLocationIsBlocked(
		SASPawn	aObstructor )
	{
		// We are close enough - treat as evacualted.
		DoReachedEvacPoint();
		return true;
	}

Begin:

	DoMoveToActor( mEvacuationPoint, PACE_Running );

MTP_FinishedMove:

	if ( mHostage.ReachedDestination( mEvacuationPoint ) )
	{
		DoReachedEvacPoint();
	}
	else
	{
		Sleep( 1.0 );
		SeekEvacuationPoint();
		Goto( 'Begin' );
	}
}


//-----------------------------------------------------------------------------
// STATE Scripting
//
state Scripting
{
	ignores SeePlayer,
			PlayerOrder;

	function bool StateCanBeOrdered()
	{
		return false;
	}

	function BeginState ()
	{
		Super.BeginState();
		ClearReaction();
		mbSeenSoldier = true;	// Stop first sighting reaction if scripting.
	}
}


//-----------------------------------------------------------------------------
function drawSightLineOverlay (SASHud h)
{
	local Color colour;

	colour = class'Canvas'.Static.MakeColor (255, 200, 50);

	if (isInState ('Following'))
	{
		h.Draw3DLine (mHostage.Location, mActorTracker.Location, colour);
		h.Draw3DCylinder (mActorTracker.Location, vect (0, 0, 1), 16, 16, 8, colour);
	} // if
} // drawSightLineOverlay
//-----------------------------------------------------------------------------
// Default properties
//

// Decompiled with UE Explorer.
defaultproperties
{
    mType=4
}