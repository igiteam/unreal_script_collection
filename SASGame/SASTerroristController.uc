//=============================================================================
// SASTerroristController.uc
//
// AI controller for SASTerrorist pawns.
//=============================================================================

class SASTerroristController extends SASFighterController
	native;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

//-----------------------------------------------------------------------------
// Constants

const MAX_TERRORIST_THREATS					= 4;		// Max threats aware of at any one time.

const AGGRESSIVE_STATIONARY_RANGE			= 250.0;	// Range within which can go stationary when charging at enemy. 

const MAX_RETREAT_ASSAULTVOLS				= 4;		// Max number of assault volumes to move through while retreating.
const RELOADING_MIN_DIST_TO_THREAT			= 512.0;	// Min dist from cover to threat for CP selected for reloading.

const HOSTAGE_THREATEN_MIN_OFFSET_DIST		= 32.0;		// Min/Max offset distance from a hostage when threatening them.
const HOSTAGE_THREATEN_MAX_OFFSET_DIST		= 48.0;	

const SURPRISED_MAX_DIST					= 700.0;	// Distance below which terrorist may be surpirised by a threat sighting.

const MIN_TIME_BEFORE_DEACTIVATION			= 5.0;		// Min time before an attacking terrorist may be deactivate if still has threats.

const ACTINGDEAD_MIN_THREAT_DIST_TO_RECOVER	= 500.0;	// Min distance from closest threat below which will not try to recover from acting dead.

const RALLYING_REACT_TO_THREAT_NOISE_RANGE	= 1500.0;	// Max distance to a noise which we should react to when rallying. 

// Minimum cover that needs to be provided by a CP in a seek cover action.
const COVERSELECT_CoveredFromNone			= 0x0;
const COVERSELECT_CoveredFromAll			= 0x1;
const COVERSELECT_CoveredFromEnemy			= 0x2;
const COVERSELECT_CoveredFromNearbyThreats	= 0x4;
const COVERSELECT_CoveredFromAny			= 0x8;


//-----------------------------------------------------------------------------
// Enums

// List of high level objectives
enum ETerrObjective
{
	TERROBJ_None,

	// Idle states
	TERROBJ_BeginIdleObjectives,

		TERROBJ_Idle,
		TERROBJ_Patrolling,
		TERROBJ_CoverIdle,

	TERROBJ_EndIdleObjectives,

	TERROBJ_RallyingToPoint,

	// Captive states 
	TERROBJ_BeginCaptiveObjectives,

		TERROBJ_Surrendered,
		TERROBJ_OrderedDown,
		TERROBJ_Restrained,

	TERROBJ_EndCaptiveObjectives,

	// Alert states
	TERROBJ_BeginAlertObjectives,

		TERROBJ_AlertedNoEnemy,
		TERROBJ_Investigating,
		TERROBJ_ActingDead,
		TERROBJ_ThreatenHostage,
		TERROBJ_BeatingHostage,

	// Attacking states
	TERROBJ_BeginAttackObjectives,

		TERROBJ_AggressiveAttack,
		TERROBJ_Retreating,
		TERROBJ_AdvancingToCloserCover,
		TERROBJ_CoverCloseInFallback,

		// Grouped attacking states
		TERROBJ_BeginGroupedAttackObjectives,

			TERROBJ_CoverAttack,
			
		TERROBJ_EndGroupedAttackObjectives,

	TERROBJ_EndAttackObjectives,

	// Special case states
	TERROBJ_BeginSpecialCaseObjectives,
			
		TERROBJ_FixedStationary,

	TERROBJ_EndSpecialCaseObjectives,
	
	TERROBJ_EndAlertObjectives
};


// List of actions resulting from delayed reaction in 
// ascending priority order.
enum ETerrReactType
{
	TERRREACT_None,
	TERRREACT_SeenDeadBody,
	TERRREACT_EngageEnemy,
};


// Stimulus types 
enum EStimulusType
{
	STIMULUS_Sight,
	STIMULUS_Noise,
	STIMULUS_Damage,
	STIMULUS_Bump,
};


// 
enum ETargetSelectFrequency
{
	TSF_Never,
	TSF_Low,
	TSF_Med,
	TSF_High,
};
const TGTSELINTERVAL_Low	= 0.75;
const TGTSELINTERVAL_Med	= 1.25;
const TGTSELINTERVAL_High	= 2.0;


//-----------------------------------------------------------------------------
// Structs

// Structure to store a detected threat along with the time of detection.
struct native ThreatInfo
{
	var SASPawn				Pawn;						// Threat pawn
	var float				AcquiredTime;				// Time of initial detection
	var float				FirstSeenTime;				// Time of first seeing the threat
	var float				LastDetectedTime;			// Last time detected
	var float				LastSeenTime;				// Time of last sighting
	var vector				LastDetectedPos;			// Last position detected at
	var vector				LastSeenPos;				// Last position seen at
	var SASAssaultVolume	LastDetectedAV;				// AV within on last detection.
	var float				LastSeenByTime;				// Last time this threat saw me.
	var float				ThreatValue;				// Measure of how much of a threat this pawn is to us.
	var SASEntryPoint		FatalFunnelEP;				// Fatal funnel EP the threat pawn was seen in.

	// Data for threat ordering.
	var float				TargetSelectWeight;			// Threat weight for target selection.
	var int					NextTargetSelectIdx;		// Used for threat ordering during target selection.
};


// Delayed reaction data.
struct native TerroristReaction
{
	var	ETerrReactType			eReactType;	// Pending reaction type
	var Actor					ReactTo;	// Optional actor to react to
};


struct native SprayFireParams
{
	var float	mYawSpeed;
	var float	mTgtYawSpeed;
	var float	mYawPos;
	var float	mTgtYawPos;

	var float	mPitchSpeed;
	var float	mTgtPitchSpeed;
	var float	mPitchPos;
	var float	mTgtPitchPos;
};


//-----------------------------------------------------------------------------
// Member variables

var SASTerrorist			mTerrorist;					// Terrorist pawn possessed by this controller
var SASTerroristMgr			mTerroristMgr;				// Ptr to level terrorist mamager object.
var SASTerroristController	mNextTerroristController;	// Next link in terrorist managers linked list of terrorists.
var float					mLastAllyNoiseTime;			// Last time heard an ally noise.
var Actor					mCoverIdleFocalActor;		// 
var Vector					mCoverIdleFocalPoint;
var SASEntryPoint			mFocalEP;					// 

// Misc bools
var bool					mbHoldActingDead;			// If true should remian in acting dead state until script action tells us to recover.
var bool					mbHasFired;					// Set as soon as we fire first bullet
var bool					mbHasRetreated;				// Set to true after choosing retreat behaviour.

// Multi-timer indices
var int						mTimerReaction;				// Used for delayed reactions.
var int						mTimerIdleAnim;				// Used for triggering spot idle anims.
var int						mTimerAttacking;			// Used for various behaviour checks when in attacking states.

// Threat data
var const ThreatInfo		mThreats[MAX_TERRORIST_THREATS];	// Array of all threats aware of at any time
var const int				mNumThreats;						// Number of threats aware of at current time.
var const float				mLastThreatInfoPartialRefreshTime;	// Last level time when partial refresh of threats array was carried out
var const float				mLastThreatInfoFullRefreshTime;		// Last level time when full refresh of threats array was carried out
var const ETargetSelectFrequency	mTargetSelectFrequency;		// Frequency of reassessing the target to select during attacking states.
var const float				mNextTargetSelectTime;
var float					mSetEnemyTime;
var const float				mLastThreatValueRefreshTime;		// Last time the threat value of threats was assessed.
var const int				mFirstTargetSelectThreatIdx;		// Index into mThreats array of highest threat after threat ordering has taken place.
var const float				mLastTargetOrderingTime;			// Last time threats were ordered for targetting.
var float					mLastSeenThreatTime;				// Last time saw a threat.
var float					mLastThreatenedTime;				// Last time threatened (targetted) by an enemy that we are aware of. 
var float					mFirstThreatenedByPlayerTime;		// First time player pointed gun toward me.
var float					mLastThreatenedByPlayerTime;		// Last time player pointed gun toward me.
var	float					mLastNoiseReactTime;				// Last time made a behaviour check to a threat noise.

// Grouping parameters
var const SASTerroristGroup	mGroup;						// Our group
var const SASTerroristController	mNextInGroup;		// Ptr to next member in group's linked list.
var const int				mGroupUpdatePrimaryTag;		// Tag used to mark whether this terrorist has been dealt with in current terrorist grouping update phase.
var const int				mGroupUpdateSecondaryTag;	
var const int				mPotentialGroups;			// Flags marking potential groups to join - used by terrorist manager group assignment.  
var const float				mJoinedGroupTime;			// Time joined current group.
var const float				mCheckGroupContactTimer;	// Timer used to check if lost contact with group.
var const float				mGroupContactTimout;		// Timeout counter for losing group contact. 
var bool					mbWantsToChangeCover;		// Flag set when want to move to new covre but need to wait for group permission first.
var float					mRequestBackupTime;			// Flag set if moving to new cover/reloading and would like someone to provide backup.
var SASTerroristController	mProvidingBackupFor;		// A member of our group who we are providing backup for.

// Misc attacking params
var float					mAttackActivationTime;		// Time started attacking.
var ETerrObjective			meCurObjective;				// Current objective being carried out
var TerroristReaction		mReaction;					// Delayed reaction data
var SASPawn					mAlertedAlly;				
var Vector					mAlertedFocalPoint;
var bool					mbCanCoverPosAdjust;
var EFirePosAdjust			meCoverFireOffset;			// Index of CPs fire offset position to use.
var float					mCoverDesiredMoveTime;
var float					mCoverWaitingStartTime;
var bool					mbCheckCoverSightedResponse;
var int						mCoverAdjustIncrement;
var bool					mbReachedCoverAdjustPoint;
var float					mAttackStartTime;
var float					mAttackDesiredDuration;
var float					mEnemyFirstSeenTime;
var float					mFiringDelayEndTime;
var float					mLastCoverAttackTime;
var float					mLastEngageResponseTime;
var SASEntryPoint			mFatalFunnelEP;				// Entry point to shoot at when firing into fatal funnel.
var float					mFatalFunnelTimer;			// Countdown timer to control FF firing duration.
var Vector					mSuppressiveFirePoint;		// Point to fire at when laying down suppressive fire.
var float					mLastGrenadeThrowTime;		// Level time when last threw grenade.
var SASTerroristRallyPoint	mRallyPoint;				// Rally point to head to when called via script.
var float					mLastSurrenderCheckTime;
var float					mLastSurrenderFocusChangeTime;
var int						mSurrenderReaction;
var float					mSurrenderBreakoutGuardedTime;
var SprayFireParams			mSprayFireParams;
var bool					mbUseSpinoutAttack;
var float					mTryStandingCoverAttackStartTime;

// Patrolling/Idle data
var	SASPatrolPoint			mPatrolPoint;					// Current point walking to.
var SASPatrolPoint			mPrevPatrolPoint;				// Last point reached. 
var float					mIdleTime;						// Time to idleat current patrol point.
var name					mIdleAnim;						// Idle anim to play at current patrol point.

// Investigating data
var bool					mbWantsToInvestigate;			// True if made an investigate request to the terrorist manager and can potentially investigate. 
var SASPawn					mThreatInvestigating;			// Threat we are investigating
var NavigationPoint			mInvestigationPoint;			// Nav point to investigate.
var Vector					mLastInvestigateLocation;		// Location of last noise we are investigating.
var float					mInvestigateStartTime;			// Time started investigating.
var bool					mbInvestigateHangBack;			// Hang back in room adjascent to final investigating AV if true.				

// Retreat data
var SASEntryPoint			mRetreatNextEP;					// Immediate room entry/exit point to move to when in retreat state
var const SASAssaultVolume	mRetreatVolumeCache[MAX_RETREAT_ASSAULTVOLS];	// Cache of assault volumes travelled through
var const int				mNumRetreatVolumesTraversed;	// Number of assault volumes  passed through while retreating
var const float				mRetreatDistTravelled;			// Total distance travelled while retreating

// Hostage guarding.
var vector					mHostageShieldPos;				// Destination position to shield from threats behind hostage.
var int						mBeatingHostageInPlayerViewCtr;	// Counter of num beating hostage anims played in view of player. 
var array<int>				mHostageStandoffSpeechOrder;	// Order in which standoff speech samples are played.
var int						mHostageStandoffSpeechOrderIdx;	// Index in above array of next sample to play. 


//-----------------------------------------------------------------------------
// Native Functions

///////////////////////////////////////////////////////////////////////////////
// InitGlobalCoverParams
//
native(700) static final function InitGlobalCoverParams(
	class<SASTerroristGlobalAI>	aGlobAIParams );


///////////////////////////////////////////////////////////////////////////////
// UpdateThreatInfo
//
// Add pawn to mThreats list if not already added.
// Update last detection time. Update sighted data if abPawnSeen param is true.
// Function returns false if threat could not be added to list due to list
// being full (or because aOther is NULL or a dead pawn).
native(701) final function bool UpdateThreatInfo(
	SASPawn			aOther,					// Threat to update
	EStimulusType	aeDetectionStimulus );	// Stimulus tpye threat was detected with.


///////////////////////////////////////////////////////////////////////////////
// GetThreatIndex
//
// Returns index of threat 'aOther' in the mThreats array. If aOther is not
// in the array then returns -1.
native(702) final function int GetThreatIndex(
	SASPawn			aOther );


///////////////////////////////////////////////////////////////////////////////
// AwareOfThreat
//
// Returns true if specified pawn is in our list of threats.
native(703) final function bool AwareOfThreat(
	SASPawn			aOther );				// Threat pawn to check.


///////////////////////////////////////////////////////////////////////////////
// HasSeenThreat
//
// Returns true if specified pawn is in our list of threats and has been
// sighted.
native(704) final function bool HasSeenThreat(
	SASPawn			aOther );				// Threat pawn to check.


///////////////////////////////////////////////////////////////////////////////
// HasSightedThreats
//
// Returns true if controller has any threats that have been sighted.
native(705) final function bool HasSightedThreats();


///////////////////////////////////////////////////////////////////////////////
// IsThreatVisible
//
// Returns true if have line of sight to threat at aThreatIdx in mThreats array.
// If abUsePeripheralVision is true then threat must also be within visibility arc.
// Function often cheaper than doing a LineOfSight call as it first checks
// to see if threat was visible during last periodic CanSee check - if so then assumes
// can still see.
// If abSimpleLineOfSightTest is true then only does a single line trace check to
// the threats eye position rather than a full on check to various points on the 
// collision cylinder.
native(706) final function bool IsThreatVisible(
	int				aThreatIdx,
	optional bool	abUsePeripheralVision,
	optional bool	abSimpleLineOfSightTest );


///////////////////////////////////////////////////////////////////////////////
// IsAVisibleThreat
//
// Similar to IsThreatVisible but passes a pawn rather than an index into the
// mThreats array. Function assumes pawn is a threat but does not need to currently
// be in the threats array.
native(707) final function bool IsAVisibleThreat(
	SASPawn			aThreatPawn,
	optional bool	abUsePeripheralVision,
	optional bool	abSimpleLineOfSightTest );


native(708) final function bool HasVisibleThreatsInRange(
	float	aRange );



///////////////////////////////////////////////////////////////////////////////
// RemoveThreat
//
// Removes pawn from threat list. 
// NOT SAFE TO USE FROM WITHIN AN ITERATION OVER THE ARRAY DUE TO ARRAY 
// REORDERING.
native(709) final function RemoveThreat(
	SASPawn	aOther );			// Threat to remove from threat list.


///////////////////////////////////////////////////////////////////////////////
// GetClosestThreat
//
// Returns closest threat.
native(710) final function SASPawn GetClosestThreat(
	optional out float aClosestDistSq );	// Out: Closest threat dist squared


///////////////////////////////////////////////////////////////////////////////
// GetLastSeenThreatIdx
//
// Returns index in mThreats array of most recently seen threat. -1 if no threats
// seen.
native(711) final function int GetLastSeenThreatIdx();


///////////////////////////////////////////////////////////////////////////////
// ChooseIdleFocalPoint
//
native(712) final function ChooseIdleFocalPoint();


///////////////////////////////////////////////////////////////////////////////
// PredictEntryPointForHighestThreat
//
// Predict entry point into pawn's current AV that the highest threat will 
// enter through.
// Returns the index into the assault volumes mEntryPoints array (-1 if failed
// to find one).
native(713) final function int PredictEntryPointForHighestThreat();


///////////////////////////////////////////////////////////////////////////////
// CoverPointExposedToAnyThreats
//
// Returns True if current cover point is exposed to any pawns in our 
// threats array.
native(714) final function bool CoverPointExposedToAnyThreats(
	optional bool	bRecentlySeenOnly );


///////////////////////////////////////////////////////////////////////////////
// SelectTargetEnemy
//
// Returns the highest threat. If abMustBeVisible is true then only selects a visible
// threat. If abWithinVisibilityArc true then must be visible within sight arc. 
native(715) final function SASPawn SelectTargetEnemy(
	optional bool	abMustBeVisible,			// Default = false
	optional bool	abWithinVisibilityArc );	// Default = false


///////////////////////////////////////////////////////////////////////////////
// StartPeriodicTargetSelection
// 
native(716) final function StartPeriodicTargetSelection(
	ETargetSelectFrequency	aNewFrequency );


///////////////////////////////////////////////////////////////////////////////
// StopPeriodicTargetSelection
// 
native(717) final function StopPeriodicTargetSelection();


///////////////////////////////////////////////////////////////////////////////
// InitFiringAtEnemy
// 
// Init firing data when selecting new enemy.
// (e.g. whether to fire at fatal funnel, setting fire delay timer).
native(718) final function InitFiringAtEnemy();


///////////////////////////////////////////////////////////////////////////////
// CheckForEnemyWhileCoverIdle
// 
native(719) final function SASPawn CheckForEnemyWhileCoverIdle();


///////////////////////////////////////////////////////////////////////////////
// CanAttackFromCover
//
// Returns True if have line of fire at other pawn from one of the
// firing offsets of our current CP.
// Selected firing offset position and firing pose parameters are setup.
native(720) final function bool CanAttackFromCover( 
	SASPawn				aOther,					// Other pawn to check LoF to.
	out EFirePosAdjust	aSelectedFPA,			// Out: Selected firing step-out position.
	out int				aSelectedFiringPose,	// Out: Selected firing pose.
	optional bool		abNoUndisciplinedFiring );	// If true then will not consider undisciplined firing methods.


///////////////////////////////////////////////////////////////////////////////
// SelectEnemyWhileHidingAtCover
//
// Select a new enemy from the threats list which have line of sight to from 
// current CP. 
// Selected firing offset position and firing pose parameters are setup.
// Selected threat pawn is returned from function.
native(721) final function SASPawn SelectEnemyWhileHidingAtCover(
	out EFirePosAdjust	aSelectedFPA,				// Out: Selected firing step-out position
	out int				aSelectedFiringPose );		// Out: Selected firing pose 


///////////////////////////////////////////////////////////////////////////////
// ChooseRandomCoverFireOffset
//
// Choose a random firing offset at current cover point from those allowed at the CP.
native(722) final function EFirePosAdjust ChooseRandomCoverFireOffset();


///////////////////////////////////////////////////////////////////////////////
// GetCoverHideTime
//
// Get tiem to hide at cover before attacking.
native(723) final function float GetCoverHideTime();


///////////////////////////////////////////////////////////////////////////////
// QueryThrowGrenadeFromCover
//
// Check if should throw grenade from current cover point.
native(724) final function SASGrenadePoint QueryThrowGrenadeFromCover();


///////////////////////////////////////////////////////////////////////////////
// FindCoverPointToAdvanceOnEnemy
//
// Seeks a CP within aSeekRange which is suitable to close in on our current enemy.
// Optionally returns the first entry point on the route to the CP if there is one.
native(725) final function SASCoverPoint FindCoverPointToAdvanceOnEnemy(
	float					aSeekRange, 
	optional SASEntryPoint	aFirstEPOnRoute );


///////////////////////////////////////////////////////////////////////////////
// CheckChangeInvestigationPoint
//
native(726) final function bool CheckChangeInvestigationPoint(
	SASPawn	aDetectedThreat );


///////////////////////////////////////////////////////////////////////////////
// SeekCoverInAssaultVolume
//
// Find and acuire best cover point in the pawn's current assault volume.
// Returns true on success.
native(727) final function bool SeekCoverInAssaultVolume( 
	optional bool							abCanSelectCurrentCP,		// Default: True
	optional float							aMinDistToCover,			// Default: 0.0
	optional float							aMaxDistToCover,			// Default: SEEK_COVER_MAX_RANGE
	optional SASCoverPoint.ECoverSetting	aeMinCoverSetting,			// Default: COVER_None
	optional int							aCoverProvidedTypes,		// Default: COVERSELECT_CoveredFromNone
	optional SASAssaultVolume				aSeekAV );	// Optional override AV - Default: None


///////////////////////////////////////////////////////////////////////////////
// SeekCoverInRadius
//
// Find and acquire best cover point within radius of a specified point.
// Returns true on success.
native(728) final function bool SeekCoverInRadius(
	float									aSearchRange,		
	optional Vector							aSearchLocus,				// Default: Pawn.Location
	optional bool							abCanSelectCurrentCP,		// Default: True 
	optional float							aMinDistToCover,			// Default: 0.0		
	optional float							aMaxDistToCover,			// Default: SEEK_COVER_MAX_RANGE
	optional SASCoverPoint.ECoverSetting	aeMinCoverSetting,			// Default: COVER_None
	optional int							aCoverProvidedTypes );		// Default: COVERSELECT_CoveredFromNone


///////////////////////////////////////////////////////////////////////////////
// SeekCoverFromEntryPoint
//
// Find and acquire best cover point to guard an entrypoint.
// Returns true on success.
native(729) final function bool SeekCoverFromEntryPoint(
	int										aAVEntryPointIdx,
	optional float							aMaxDistToCover,			// Default: SEEK_COVER_MAX_RANGE
	optional SASCoverPoint.ECoverSetting	aeMinCoverSetting );		// Default: COVER_None


///////////////////////////////////////////////////////////////////////////////
// GetMaxCoverDist
//
// Returns the maximum distance to seek new cover in based on the distance 
// to known threats.
native(730) final function float GetMaxCoverDist();


///////////////////////////////////////////////////////////////////////////////
// PollShouldBeginAttackFromCover
//
// Fn to periodically check if should start attacking from current CP.
native(731) final function bool PollShouldBeginAttackFromCover();


///////////////////////////////////////////////////////////////////////////////
// PollShouldEndAttackFromCover
//
// Fn to periodically check if should stop attacking from current CP.
native(732) final function bool PollShouldEndAttackFromCover();


///////////////////////////////////////////////////////////////////////////////
// PollShouldMoveToNewCover
//
// Fn to periodically check if should seek new CP to move to.
native(733) final function bool PollShouldMoveToNewCover();


///////////////////////////////////////////////////////////////////////////////
// StartRetreat
//
// Init retreat data and look for first entry point from current assault
// volume to retreat toward. Returns false if can't find suitable entry point.
native(734) final function bool StartRetreat();


///////////////////////////////////////////////////////////////////////////////
// FindRetreatPoint
//
// Find next navpoint to move to during retreat state.
native(735) final function FindRetreatPoint();


///////////////////////////////////////////////////////////////////////////////
// UpdateInvestigationPoint
//
native(736) final function bool UpdateInvestigationPoint();


///////////////////////////////////////////////////////////////////////////////
// CheckSurrenderCriteria
//
// Check if criteria for surrendering have been met when exposed at a CP.
native(737) final function bool CheckSurrenderCriteria();


///////////////////////////////////////////////////////////////////////////////
// CheckSurrenderedUnguarded
//
// While surrendered, check to see if we have become unguarded by the squad.
native(738) final function bool CheckSurrenderedUnguarded();


///////////////////////////////////////////////////////////////////////////////
// SeekAggressiveMoveBackPoint
//
// Seek step back location to move to when too close to enemy.
native(739) final function Vector SeekAggressiveMoveBackPoint();


///////////////////////////////////////////////////////////////////////////////
// GetNextNoiseReactTime
//
// Get next level time which we can instigate a reaction to a noise from a 
// threat. React time is Lod based.
native(740) final function float GetNextNoiseReactTime( 
	SASPawn	aThreat );


///////////////////////////////////////////////////////////////////////////////
// CheckPlayWaitingAtCoverSpeech
//
native(741) final function bool CheckPlayWaitingAtCoverSpeech();

native(742) final function CheckUseSpinoutAttack();

native(743) final function Pawn SelectClosestPlayerEnemy();

native function MemTick();


//-----------------------------------------------------------------------------
// Exec Functions

//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DisplayDebug
//
// List important controller attributes on canvas
function DisplayDebug(
	Canvas		aCanvas,		// Canvas to render to 
	out float	aYL,			// Line spacing
	out float	aYPos )			// Current line y-position
{
	local int i;

	Super.DisplayDebug( aCanvas, aYL, aYPos );

	aCanvas.SetDrawColor( 255, 255, 255 );

	aCanvas.DrawText( "SASTerroristController:" );
	aYPos +=aYL;
	aCanvas.SetPos( 4, aYPos );

	if ( IsInState( 'Patrolling' ) || IsInState( 'PatrolIdle' ) )
	{
		aCanvas.DrawText( "PatrolPoint: "$mPatrolPoint$" MoveTarget: "$MoveTarget );
		aYPos += aYL;
	}

	aCanvas.SetPos( 32, aYPos );
	
	if ( mNumThreats > 0 )
	{
		aCanvas.DrawText( "Threats: " );
		aYPos += aYL;

		for ( i = 0; i < mNumThreats; ++i )
		{
			aCanvas.SetPos( 48, aYPos );
			aCanvas.DrawText( mThreats[i].Pawn );
			aYPos += aYL;
		}
	}
	else
	{
		aCanvas.DrawText( "Threats: None" );
		aYPos += aYL;
	}
	aCanvas.SetPos( 32, aYPos );

	if ( mGroup != None )
	{
		aCanvas.SetPos( 48, aYPos );
		aCanvas.DrawText( "Group = "$mGroup);
		aYPos += aYL;
	}

	aCanvas.SetPos( 32, aYPos );
}


///////////////////////////////////////////////////////////////////////////////
// PostBeginPlay
//
event PostBeginPlay()
{
	Super.PostBeginPlay();

	// Init multi-timers
	mTimerReaction		= AddMultiTimer();
	mTimerIdleAnim		= AddMultiTimer();
	mTimerAttacking		= AddMultiTimer();

    Level.Game.ChangeName( self, class'SASGameInfo'.Default.mDefaultTerroristName, true );
}


///////////////////////////////////////////////////////////////////////////////
// Possess
//
// Called by engine when controller possesses a pawn.
function Possess(
	Pawn	aPawn )		// Possessed pawn
{
	local SASGameInfo	gi;

	mTerrorist = SASTerrorist( aPawn );
	if ( mTerrorist == None )
	{
		warn( "SASTerrorist.Possess: Possessed pawn is not an SASTerrorist." );
		return;
	}

	// Cache ptr to terrorist manager.
	gi = SASGameInfo( Level.Game );
	if ( gi != None )
	{
		mTerroristMgr = gi.GetTerroristManager();

		// Only add self now if not bStartInactive.
		if ( !mTerrorist.bStartInactive )
		{
			mTerroristMgr.AddTerrorist( self );
		}
	}

	// Init sight flags to monitor threats, alert allies and dead bodies.
	SetSightFlags( SIGHT_Soldiers|SIGHT_AlertTerrorists|SIGHT_DeadBodies|SIGHT_MovingDoors );
	
	// Start off hearing all soldier noises, combat type noises from enemies and allies, alert terrorists and door noises.
	// NOTE: Friendly combat and alert terrorist voice flags will be turned off when in attacking state.
	SetHearingFlags( HEAR_Soldiers|HEAR_CombatEnemy|HEAR_CombatFriendly|HEAR_AlertTerroristVoices|HEAR_Doors );

	// By default terrorists will always step aside for other terrorists and soldiers. Also let 
	// hostages by in low priority states.
	SetStepAsidePawnTypes( PAWN_Terrorist|Pawn_Soldier, PAWN_Hostage );

	Super.Possess( aPawn );

	mTerrorist.SetPace( PACE_Walking );
}


///////////////////////////////////////////////////////////////////////////////
// EnterStartState
// 
// Choose an action to enter on becoming active in the level.
function EnterStartState()
{
	if ( mTerrorist.mbActDeadFromStart )
	{
		mTerrorist.PlayActingDead( true );
	}
	else if ( mTerrorist.mHostageTarget != None )
	{
		if ( mTerrorist.mbBeatHostageTarget )
		{
			DoBeatHostage();
		}
		else
		{
			DoThreatenHostage();
		}
	}
	else if ( mTerrorist.mIdleHidePointTag != 'None' )
	{
		DoHideIdle();
	}
	else if ( mTerrorist.mPatrolPointTag != 'None' )
	{
		DoPatrolling();
	}
	else if ( mTerrorist.mbFixedStationary )
	{
		DoFixedStationary();
	}
	else
	{
		DoIdle();
	}
}


///////////////////////////////////////////////////////////////////////////////
// Destroyed
// 
event Destroyed()
{
	// Tidy-up current objective - this should free up coverpoints/patrolpoints etc.
	SetCurrentObjective( TERROBJ_None );

	if ( mTerroristMgr != None )
	{
		mTerroristMgr.RemoveTerrorist( self );
	}

	if ( mGroup != None )
	{
		mGroup.RemoveMember( self );
	}

	Super.Destroyed();
}


///////////////////////////////////////////////////////////////////////////////
// AcquirePatrolPoint
// 
function bool AcquirePatrolPoint(
	SASPatrolPoint	aPP )
{
	if ( (aPP != None) && (aPP.mOwner == None) )
	{
		if ( aPP == mPatrolPoint )
		{
			return true;
		}

		if ( mPatrolPoint != None )
		{
			mPrevPatrolPoint = mPatrolPoint;
			RelinquishPatrolPoint();
		}

		aPP.Acquire( self );
		mPatrolPoint = aPP;

		return true;
	}

	return false;
}


///////////////////////////////////////////////////////////////////////////////
// RelinquishPatrolPoint
// 
function RelinquishPatrolPoint()
{
	if ( mPatrolPoint != None )
	{
		mPatrolPoint.Relinquish( self );
		mPatrolPoint = None;
	}
}


///////////////////////////////////////////////////////////////////////////////
// RelinquishCoverPoint
// 
event RelinquishCoverPoint()
{
	Super.RelinquishCoverPoint();

	mbWantsToChangeCover = false;
}


///////////////////////////////////////////////////////////////////////////////
// ReachedCover
// 
function ReachedCover()
{
	if ( mCoverReachedTime == -1.0 )
	{
		if ( mGroup != None )
		{
			mGroup.SendMessage( self, TGMSG_ReachedCover );

			mbWantsToChangeCover	= false;
			mRequestBackupTime		= -1.0;
			mProvidingBackupFor		= None;
		}
	}

	Super.ReachedCover();
}


///////////////////////////////////////////////////////////////////////////////
// DoCoverPositionAdjust
// 
event DoCoverPositionAdjust();


///////////////////////////////////////////////////////////////////////////////
// BeginCoverAttacking
// 
event BeginCoverAttacking();


///////////////////////////////////////////////////////////////////////////////
// SetEnemy
// 
function bool SetEnemy(
	Actor	aNewEnemy )
{
	if ( Super.SetEnemy( aNewEnemy ) )
	{
		mSetEnemyTime = Level.TimeSeconds;
		InitFiringAtEnemy();
		return true;
	}

	return false;
}


///////////////////////////////////////////////////////////////////////////////
// FocusOnEnemy
// 
function FocusOnEnemy()
{
	if ( mFatalFunnelEP != None )
	{
		SetFocus( mFatalFunnelEP );
	}
	else
	{
		SetFocus( Enemy );
	}
}


///////////////////////////////////////////////////////////////////////////////
// ClearFatalFunnelData
//
function ClearFatalFunnelData()
{
	mFatalFunnelEP = None;
	mFatalFunnelTimer = 0.0;
}


///////////////////////////////////////////////////////////////////////////////
// EndFatalFunnelFiring
//
event EndFatalFunnelFiring()
{
	ClearFatalFunnelData();

	if ( (Enemy != None) && TryingToFire() )
	{
		BeginBurstFireAt( Enemy );
	}
}


///////////////////////////////////////////////////////////////////////////////
// BeginBurstFireAt
//
// Fire a burst at actor aTarget.
function BeginBurstFireAt(
	Actor	aTarget )
{
	// Make sure we are holding a gun, not a grenade/knife etc.
	CheckGunSelected();
	
	// Try to set weapon to automatic - if not available will use single fire mode.
	SetWeaponFireMode( 'FIREMODE_Auto' );

	if ( mFatalFunnelEP != None )
	{
		Target = mFatalFunnelEP;
		StartBurstFiring( true );
		//StartBurstFiringAtPoint( mFatalFunnelEP.Location, true );	
	}
	else
	{
		Target = aTarget;
		StartBurstFiring(); 
	}
}


///////////////////////////////////////////////////////////////////////////////
// ShouldDiscardClip
//
function bool ShouldDiscardClip()
{
	local SASWeapon	myWpn;
	
	if ( (Pawn.Weapon == None) || (mTerrorist.mDiscardNearEmptyClipChance == 0.0) )
	{
		return false;
	}

	if ( FRand() > mTerrorist.mDiscardNearEmptyClipChance )
	{
		return false;
	}

	myWpn = SASWeapon( Pawn.Weapon );
	if ( myWpn.mNumInMag <= myWpn.mDiscardMagThreshold )
	{
		return true;
	}

	return false;
}


///////////////////////////////////////////////////////////////////////////////
// NotifyWeaponFired
// 
function NotifyWeaponFired()
{
	Super.NotifyWeaponFired();
	mbHasFired = true;
}


///////////////////////////////////////////////////////////////////////////////
// IsIdleObjective
// 
event bool IsIdleObjective(
	ETerrObjective	aObjective )
{
	return ((aObjective > TERROBJ_BeginIdleObjectives)
		&& (aObjective < TERROBJ_EndIdleObjectives));
}


///////////////////////////////////////////////////////////////////////////////
// IsAttackingObjective
// 
event bool IsAttackingObjective(
	ETerrObjective	aObjective )
{
	return ((aObjective > TERROBJ_BeginAttackObjectives)
		&& (aObjective < TERROBJ_EndAttackObjectives));
}


///////////////////////////////////////////////////////////////////////////////
// IsGroupedAttackObjective
// 
event bool IsGroupedAttackObjective(
	ETerrObjective	aObjective )
{
	return (	(aObjective > TERROBJ_BeginGroupedAttackObjectives && 
					aObjective < TERROBJ_EndGroupedAttackObjectives) ||
				(aObjective == TERROBJ_AggressiveAttack) );	// TEMP
}


///////////////////////////////////////////////////////////////////////////////
// CanFillStickyCoverPoint
// 
event bool CanFillStickyCoverPoint(
	SASStickyCoverPoint	aOtherCP )
{
	if (	(mSASPawn == None) 
		||	!mSASPawn.mbIsCombatCapable		// Can't fight for some reason
		||	mTerrorist.mbSurrendered		// Surrendered
		||	mTerrorist.mbCaptured			// Cuffed
		||	mTerrorist.Health <= 0			// Dead
		||	mTerrorist.mbIsIncapacitated	// Incapacitated
		||	mTerrorist.mbStunned			// Stunned 
		||	mTerrorist.mbGassed				// Gassed
		||	mTerrorist.mbFixedStationary	// Static placed terrorist
		||	(mNumGrenadesDetected > 0) )	// Aware of grenades which might need avoiding.
	{
		return false;
	}

	switch ( meCurObjective )
	{
		// Can't go to CPs if at other sticky CP of equal or higher priority
	case TERROBJ_CoverAttack:
		if ( (mCoverPoint != None) 
			&& (SASStickyCoverPoint( mCoverPoint ) != None) 
			&& (SASStickyCoverPoint( mCoverPoint ).mPriority >= aOtherCP.mPriority) )
		{
			return false;
		}
		break;

		// Can never go to CPs in these states
	case TERROBJ_ActingDead:
	case TERROBJ_Retreating:
	case TERROBJ_RallyingToPoint:
	case TERROBJ_CoverCloseInFallback:
		return false;
	}

	return mbCanSee;
}


///////////////////////////////////////////////////////////////////////////////
// FillStickyCoverPoint
// 
event FillStickyCoverPoint(
	SASStickyCoverPoint	aStickyCP )
{
	if ( (aStickyCP != None) && AcquireCoverPoint( aStickyCP ) )
	{
		//DoCoverIdle();
		DoCoverAttack();
	}
}


///////////////////////////////////////////////////////////////////////////////
// CanSurrender
//
function bool CanSurrender()
{
	if (	(mTerrorist == None) ||	
			mTerrorist.mbSurrendered ||		// Already surrendered
			mTerrorist.mbCaptured ||		// Already cuffed
			mTerrorist.IsDead() ||			// Dead
			IsIncapacitated() ||			// Incapacitated
			mTerrorist.mbFixedStationary )	// Static placed terrorist 
	{
		return false;
	}

	switch ( meCurObjective )
	{
	case TERROBJ_Surrendered:
	case TERROBJ_OrderedDown:
	case TERROBJ_Restrained:
	case TERROBJ_ActingDead:
	case TERROBJ_FixedStationary:
		return false;
	}

	return true;
}


///////////////////////////////////////////////////////////////////////////////
// DoReloading
//
function DoReloading (optional bool forceReload)
{
	if (IsIncapacitated ())
	{
		return;
	} // if

	// Make sure to end fatal funnel shooting after reload.
	ClearFatalFunnelData();

	Pawn.Weapon.Reload();
}


///////////////////////////////////////////////////////////////////////////////
// ReactToThreat
// 
function ReactToThreat(
	SASPawn			aThreat,
	EStimulusType	aeDetectionStimulus,
	bool			abNoCallBackup )
{
	local bool	bOldAlert;

	if ( mTerrorist.mbIsIncapacitated )
	{
		return;
	}

	bOldAlert = mbIsAlert;
	SetAlert( true );

	// Update cached info on this threat.
	UpdateThreatInfo( aThreat, aeDetectionStimulus );

	// Can't do anything else if not able to fight.
	if ( mTerrorist.mbCaptured || mTerrorist.mbSurrendered || !mTerrorist.mbIsCombatCapable )
	{
		return;
	}

	// Choose to do somthing if don't currently have an enemy or in an idle state.
	if ( (Enemy == None) || IsIdleObjective( meCurObjective ) )
	{
		switch ( aeDetectionStimulus )
		{
		case STIMULUS_Sight:
		case STIMULUS_Bump:
		case STIMULUS_Damage:

			// Check if surprised by threat.
			if ( !bOldAlert && IsSurprisedBy( aThreat ) )
			{
				SetEnemy( aThreat );
				GotoState( 'Surprised' );
			}
			else
			{
				// Check if should call for backup.
				if ( !abNoCallBackup && ShouldCallBackup( aThreat ) )
				{
					SetEnemy( aThreat );
					GotoState( 'CallBackup' );
				}
				else
				{
					// Just engage the enemy after a reaction time.
					InitReaction( TERRREACT_EngageEnemy, aThreat );
				}
			}
			break;

		case STIMULUS_Noise:
			// Choose a relevant reaction to hearing a noise from a threat.
			ChooseThreateningNoiseReaction( aThreat, true );
			break;

		default:
			Warn( "Unhandled stimulus type <"$aeDetectionStimulus$" in ReactToThreat." );
		}
	} 
}


///////////////////////////////////////////////////////////////////////////////
// ChooseThreateningNoiseReaction
// 
function ChooseThreateningNoiseReaction(
	SASPawn			aThreat,
	bool			abConsiderInvestigation )
{
	local int	predictedEPIdx;

	// Only react to noises on a LoDed periodic time interval.
	if ( GetNextNoiseReactTime( aThreat ) > Level.TimeSeconds )
	{
		return;
	}

	// Don't react to noise threat while in a non-idle state and have an enemy.
	if ( (Enemy != None) && !IsIdleObjective( meCurObjective ) )
	{
		return;
	}

	// Is investigation allowed as a reaction?
	if (	abConsiderInvestigation &&
			(mTerrorist.mAlertAggressivePct > 0.0) &&
			(FRand() < mTerrorist.mAlertAggressivePct) )
	{
		// Request to investigate with the terrorist manager. If we are a 
		// suitable investigation candidate then the mbWantsToInvestigate flag will
		// be set. The terrorist manager will then choose terrorists to investigate 
		// from all potential candidates on the next Tick. Potential candidates which
		// aren't selected will receive the InvestigateRequestDenied event which will
		// in turn select an alternate reaction to the noise.
		mTerroristMgr.RequestInvestigate( self, aThreat );

		if ( mbWantsToInvestigate )
		{
			// This terrorist is a potential investigator, do nothing for now.
			return;
		}
	}

	// Randomly choose to retreat if this is first reaction to a threat noise.
	if (	(mLastNoiseReactTime == 0.0) &&
			(mTerrorist.mAlertRetreatPct > 0.0) && 
			(mTerroristMgr.mNumAttackingTerrorists < mTerroristMgr.MAX_ATTACKING_TERRORISTS) &&
			(FRand() < mTerrorist.mAlertRetreatPct) &&
			StartRetreat() )
	{
		// GPTODO: Need to have non-attacking and attacking retreat type. 
		// Move between the 2 as we move in and out of attack list.
		mTerroristMgr.RequestBeginAttack( self );
		DoRetreating();
	}
	// Else seek cover to wait at from predicted threat.
	// TODO: Global ChooseIdleCover fn. Reassess best cover to take based on info about all known threats.
	else 
	{
		// TODO: SeekCoverInRadius - need to base dist to move on threat dist/num AVs between.
		// Need to prevent entering AVs with known threats. - Give AV limit of one away.
		// Need to focus on thret location rather than CP dir.
		if ( aThreat.GetAssaultVolume() == mTerrorist.GetAssaultVolume() )
		{
			if ( SeekCoverInRadius( 500.0 ) )
			{
				DoCoverIdle();
			}
			else
			{
				ChooseIdleFocalPoint();
			}
		}
		else
		{
			// TODO: Don't reassess EP for threats more than certain dist / AV dist away.
			predictedEPIdx = PredictEntryPointFor( mSASPawn, aThreat );
			if ( SeekCoverFromEntryPoint( predictedEPIdx ) )
			{
				DoCoverIdle();
			}
			else
			{
				ChooseIdleFocalPoint();
			}
		}
	}

	mLastNoiseReactTime = Level.TimeSeconds;
}


///////////////////////////////////////////////////////////////////////////////
// CanInvestigate
//
event bool CanInvestigate()
{
	// Various conditions which would prevent investigation being allowed.
	if (	(mTerrorist == None) ||
			mTerrorist.IsDead() ||
			IsIncapacitated() ||
			mbHasRetreated ||
			!mTerrorist.mbIsCombatCapable ||
			mTerrorist.mbCaptured || 
			mTerrorist.mbSurrendered ||
			mTerrorist.mbFixedStationary ||
			(mNumGrenadesDetected > 0) )
	{
		return false;
	}

	// Only aggressive terrorists can investigate.
	if ( mTerrorist.mAlertAggressivePct == 0.0 )
	{
		return false;
	}

	// Can't leave sticky CPs to investigate.
	if ( mCoverPoint != None && SASStickyCoverPoint( mCoverPoint ) != None )
	{
		return false;
	}

	return true;
}


///////////////////////////////////////////////////////////////////////////////
// InvestigateRequestAccepted
//
event InvestigateRequestAccepted()
{
	mLastNoiseReactTime = Level.TimeSeconds;
	DoInvestigating();
}


///////////////////////////////////////////////////////////////////////////////
// InvestigateRequestDenied
//
event InvestigateRequestDenied()
{
	// Choose another reaction to threatening noise.
	ChooseThreateningNoiseReaction( mThreatInvestigating, false );
}


///////////////////////////////////////////////////////////////////////////////
// ReactToAlertFriendly
// 
function ReactToAlertFriendly(
	SASPawn			aFriendly,
	EStimulusType	aeDetectionStimulus )
{
	local SASPawn	enemyOfFriendly;

	if ( mTerrorist.mbCaptured || mTerrorist.mbSurrendered || !mTerrorist.mbIsCombatCapable )
	{
		return;
	}

	switch ( aeDetectionStimulus )
	{
	case STIMULUS_Sight:
		enemyOfFriendly = SASPawn( aFriendly.Controller.Enemy );
		if ( (enemyOfFriendly != None)
			&& mSASPawn.IsAThreat( enemyOfFriendly )
			&& mSASPawn.PawnIsVisible( enemyOfFriendly ) )
		{
			ReactToThreat( enemyOfFriendly, STIMULUS_Sight, false );
		}
		else
		{
			ReactToOtherAlert( aFriendly, enemyOfFriendly );
		}
		break;


	case STIMULUS_Noise:
		enemyOfFriendly = SASPawn( aFriendly.Controller.Enemy );
		if ( (enemyOfFriendly != None)
			&& mSASPawn.IsAThreat( enemyOfFriendly )
			&& mSASPawn.PawnIsVisible( enemyOfFriendly ) )
		{
			InitReaction( TERRREACT_EngageEnemy, enemyOfFriendly );
		}
		break;

	default:
		break;
	}
}


///////////////////////////////////////////////////////////////////////////////
// SeePlayer
// 
event SeePlayer(
	Pawn	aSeen )
{
	local SASPawn					seenSASPawn;
	local SASTerroristController	otherTC;

	// Don't respond to sightings when in captured state. 
	// GPTODO: Set sight flags to None so won't receive sighting events.
	if ( mSASPawn.mbCaptured )
	{
		return;
	}

	// If seen pawn is a threat then set it as our next target and wait for a 
	// reaction time before responding.
	seenSASPawn = SASPawn( aSeen );

	if ( seenSASPawn != None )
	{
		if ( mSASPawn.IsAThreat( seenSASPawn ) )
		{
			ReactToThreat( seenSASPawn, STIMULUS_Sight, false );
		}
		else
		{
			// Have we sighted an alert terrorist?
			if ( (seenSASPawn.Controller != None)
				&& (seenSASPawn.Controller.mType == CONTROLLER_AITerrorist) )
			{
				otherTC = SASTerroristController( seenSASPawn.Controller );
				if ( otherTC.mbIsAlert )
				{
					SeeAlertTerrorist( otherTC );
				}
			}
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// SeeAlertTerrorist
// 
function SeeAlertTerrorist(
	SASTerroristController	aOtherTC )
{
	if ( Enemy != None )
	{
		return;
	}

	if ( aOtherTC != None )
	{
		// If seen terrorist has been hit since the previous sight check time then assume we saw them
		// being hit.
		if ( (aOtherTC.mLastEnemyHitBy != None) 
			&& ((Level.TimeSeconds - aOtherTC.mLastEnemyHitByTime) < AIFIGHTER_ALERT_SIGHT_FRIENDLY_INTERVAL_MAX) )
		{
			if ( VSizeSq( mLastEnemyHitBy.Location - mSASPawn.Location ) < Square( 250.0 ) )
			{
				ReactToThreat( mLastEnemyHitBy, STIMULUS_Sight, false );
			}
			else
			{
				ReactToAlertFriendly( aOtherTC.mSASPawn, STIMULUS_Sight );
			}
		}
		else
		{
			ReactToAlertFriendly( aOtherTC.mSASPawn, STIMULUS_Sight );
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// SeeMovingDoor
// 
event SeeMovingDoor(
	Mover	aDoor )
{
	local SASPawn	moveInstigator;

	// If door movement instigated by a threat...
	if ( aDoor.Instigator == None )
	{
		return;
	}

	moveInstigator = SASPawn( aDoor.Instigator );
	if ( moveInstigator == None )
	{
		return;
	}

	if ( mSASPawn.IsAThreat( moveInstigator ) )
	{
		// GPTODO: Treating this event as a sighting of the instigator is not exactly desired.
		// However, if its not a sighting then the terrorist may do investigate behaviour when 
		// it should really just take cover from the door location and wait a while first.
		// Need some way of flagging that we know that the threat is not visible but probably about to become visible
		// so we instiagte the correct response (ie dont investigate immediately).
		ReactToThreat( moveInstigator, STIMULUS_Sight, false );
	}
}


///////////////////////////////////////////////////////////////////////////////
// HearNoise
// 
// Noises terrorists are interested in:
// 1) General (non-combat) noises from threats.
// 2) Doors opened by threats.
// 3) Combat noises from threats.
// 4) Combat noises from enemy when we are not alert.
// 5) Alert voice noises from allies when we are not alert.
event HearNoise(
	 float			aLoudness,					// Loudness level of noise (0.0->1.0)
	 Actor			aNoiseInstigator,			// Noise making actor
	 ENoiseType		aeNoiseType, 				// Type of noise
	 Vector			aNoiseLoc )					// Noise Location
{
	local SASPawn	heardSASPawn;

	// Don't respond to noises when in captured state. 
	// GPTODO: Set hearing flags to None so won't receive hearing events.
	if ( mSASPawn.mbCaptured )
	{
		return;
	}

	// If heard pawn is an enemy then set it as our next target and 
	// wait for a reaction time before responding.
	if ( aeNoiseType == NOISE_Door )
	{
		if ( aNoiseInstigator.Instigator != None )
		{
			heardSASPawn = SASPawn( aNoiseInstigator.Instigator );
		}
	}
	else
	{
		heardSASPawn = SASPawn( aNoiseInstigator );
	}

	if ( heardSASPawn != None )
	{
		if ( mSASPawn.IsAThreat( heardSASPawn ) )
		{
			ReactToThreat( heardSASPawn, STIMULUS_Noise, false );
		}
		else if ( mSASPawn.IsFriendly( heardSASPawn ) )
		{
			if ( Enemy == None )
			{
				// Have we heard an alert terrorist?
				if ( (heardSASPawn.Controller != None)
					&& (SASTerroristController( heardSASPawn.Controller ) != None)
					&& SASTerroristController( heardSASPawn.Controller ).mbIsAlert )
				{
					ReactToAlertFriendly( heardSASPawn, STIMULUS_Noise );
				}
			}
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// SeeDeadBody
// 
event SeeDeadBody(
	SASPawn	aDeadBody )
{
	if ( mSASPawn.mbCaptured )
	{
		return;
	}

	if ( !mbIsAlert )
	{
		SetAlert( true );
		InitReaction( TERRREACT_SeenDeadBody, aDeadBody );
	}
}


///////////////////////////////////////////////////////////////////////////////
// NotifyBump
// 
event bool NotifyBump(
	Actor	aOther )
{
	local SASPawn	bumpedPawn;
	
	bumpedPawn = SASPawn( aOther );
	if ( bumpedPawn != None )
	{
		if ( !mTerrorist.mbCaptured && !mTerrorist.mbSurrendered )
		{
			// Detect being bumped by a threat. 
			
			if ( (bumpedPawn != None) && mSASPawn.IsAThreat( bumpedPawn ) )
			{
				ReactToThreat( bumpedPawn, STIMULUS_Bump, true );
			}

			// Have we bumped into an AI soldier?
			if (	(bumpedPawn.mPawnType == PAWN_Soldier) &&
					(bumpedPawn.Controller != None) && 
					(bumpedPawn.Controller.mType == CONTROLLER_AISoldier) )
			{
				// If bumped pawn is charging then go into StaggerBack state. 
				if (	(bumpedPawn.mePace == PACE_Charging) &&
						(bumpedPawn.Acceleration != Vect(0,0,0)) )
				{
					DoStaggerBackward( bumpedPawn );
					SASSoldierController( bumpedPawn.Controller ).ChargeBumpedTerrorist( mTerrorist );
				}
			}
		}
	}

	return Super(SASAIController).NotifyBump( aOther );
}


///////////////////////////////////////////////////////////////////////////////
// DamageAttitudeTo
// 
// Called on taking damage to instigate a response.
function DamageAttitudeTo(
	Pawn	aDamageInstigator,			// Pawn that damaged us (eg. Pawn that fired the weapon) 
	float	aDamage )					// Damage amount
{
	local SASPawn	sasDamager;

	if ( mTerrorist.mbCaptured || mTerrorist.mbSurrendered )
	{
		return;
	}

	Super.DamageAttitudeTo( aDamageInstigator, aDamage );

	// If damager pawn is an enemy then set it as our next target and 
	// wait for a reaction time before responding.
	// TODO: Response due to friendly fire.
	sasDamager = SASPawn( aDamageInstigator );
	if ( (sasDamager != None) && mSASPawn.IsAThreat( sasDamager ) )
	{
		SetAlert( true );
		ReactToThreat( sasDamager, STIMULUS_Damage, true );
	}
}


///////////////////////////////////////////////////////////////////////////////
// AlertedToThreatByOther
//
function AlertedToThreatByOther(
	SASTerroristController aAlerter )
{
	local float	distSq;
	local Pawn	closestThreatToOther;

	if ( !mbCanSee && !mbCanHear )
	{
		return;
	}

	if ( aAlerter.Enemy != None )
	{
		closestThreatToOther = SASPawn (aAlerter.Enemy);
	}
	else
	{
		closestThreatToOther = aAlerter.GetClosestThreat();
		if ( closestThreatToOther == None )
		{
			return;
		}
	}
	
	distSq = VSizeSq( aAlerter.Pawn.Location - Pawn.Location );
	if ( distSq < Square( 500.0 ) && (aAlerter.mSASPawn.GetAssaultVolume() == mSASPawn.GetAssaultVolume()) )
	{
		ReactToThreat( SASPawn( closestThreatToOther ), STIMULUS_Sight, true );
	}
	else
	{
		ReactToThreat( SASPawn( closestThreatToOther ), STIMULUS_Noise, true );
	}
}


///////////////////////////////////////////////////////////////////////////////
// ReactToOtherAlert
//
// GPTODO: React by - taking cover or moving toward/following alerted ally.
function ReactToOtherAlert( 
	SASPawn	aAlerted, 
	SASPawn	aInstigator )
{
	local float		distSqToAlerted;
	local Vector	vecSelfToAlerted;
	local Vector	vecAlertedToInstigator;
	local Vector	hitNormal, hitLocation;
	local Vector	startTrace, endTrace, backDir;
	local Actor		hitActor;

	if ( mSASPawn.mbCaptured )
	{
		Warn( Pawn$" asked to react to detecting other alert terrorist when captured." );
		return;
	}

	mAlertedAlly = None;

	// TEMP HACK.
	if ( aInstigator == None )
	{
		return;
	}

	// If instigator on other side of pawn to us then move toward hit pawn location.

	vecSelfToAlerted = aAlerted.Location - mTerrorist.Location;
	distSqToAlerted = VSizeSq( vecSelfToAlerted );
	
	if ( distSqToAlerted > 250.0 )
	{
		vecAlertedToInstigator = aInstigator.Location - aAlerted.Location;
		
		if ( (vecSelfToAlerted Dot vecAlertedToInstigator) > 0.0 )
		{
			// Instigator on opposite side of alerted pawn, move toward alerted
			// to try to see instigator.
			mAlertedAlly = aAlerted;
		}		
	}

	// Get point to turn toward to search for instigator
	backDir = Normal( aInstigator.Location - aAlerted.Location );

	startTrace = aAlerted.Location;
	endTrace = aAlerted.Location + (backDir * 1000.0);
	hitActor = mTerrorist.Trace( hitLocation, hitNormal, endTrace, startTrace, false,,, true );
	if ( hitActor != None )
	{
		mAlertedFocalPoint = hitLocation;
	}
	else
	{
		mAlertedFocalPoint = endTrace;
	}

	//DoAlertNoEnemy();
}


///////////////////////////////////////////////////////////////////////////////
// EnemyNotBestTarget
//
// Event recieved during periodic threat reassessment to notify us that our 
// current enemy is not the best target to select.
// Best target is passed as parameter.
event EnemyNotBestTarget(
	SASPawn	aBestTarget );


///////////////////////////////////////////////////////////////////////////////
// InitSuppressiveFiring
//
function InitSuppressiveFiring(
	Vector	aFiringLoc )
{
	if ( mTerrorist.mSuppressiveFireDuration.Min > 0.0 )
	{
		mSuppressiveFirePoint = aFiringLoc; 

		SetFocalPoint( aFiringLoc );

		SetTimer(
			RandRange( 
				mTerrorist.mSuppressiveFireDuration.Min, 
				mTerrorist.mSuppressiveFireDuration.Max ), 
			false );
	}
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

	// Check if should shout grenade alert.
	if ( mTerroristMgr.CheckGrenadeShout( aGrenade ) )
	{
		mTerrorist.PlaySpeech( SPEECH_TerrGrenade );

		AlertFriendliesOfGrenade( aGrenade );
	}

	// Stop guarding hostage when reacting to grenades.
	mTerrorist.mHostageTarget.EndGuardedByTerrorist();
	mTerrorist.mHostageTarget = None;

	Super.ReactToGrenade( aGrenade );
}


///////////////////////////////////////////////////////////////////////////////
// GotoAtGrenadeCoverState
//
// Function to instigate AI controller type specific specific state on reaching a
// grenade retreat point.
function GotoAtGrenadeCoverState()
{
	GotoState( 'DefendGrenadeRetreatPoint' );
}


///////////////////////////////////////////////////////////////////////////////
// MultiTimer
// 
// Event that gets called when one of the controllers multi-timers triggers.
event MultiTimer(
	int	aTimerIndex )	// Index of timer
{
	switch ( aTimerIndex )
	{
	case mTimerReaction:
		CompleteReaction();
		break;

	default:
		Super.MultiTimer( aTimerIndex );
	}
}


///////////////////////////////////////////////////////////////////////////////
// ActivateAttack
// 
event ActivateAttack()
{
	// Reset time of last successful hit.
	mLastHitEnemyTime = 0.0;
	mAttackActivationTime = Level.TimeSeconds;
}


///////////////////////////////////////////////////////////////////////////////
// DeactivateAttack
// 
event DeactivateAttack()
{
	if ( mGroup != None )
	{
		mGroup.RemoveMember( self );
	}

	// GPTODO: Pull back from attacking to safe position.
}


///////////////////////////////////////////////////////////////////////////////
// EngageThreat
// 
// Determine response to a detected threat according to situation.
function bool EngageThreat(
	Pawn	aThreatPawn )
{
	local bool			bTriedFindingCover,
						bNoRetreat;
	local float			diceRoll;

	if (	IsIncapacitated() ||
			mTerrorist.mbCaptured ||
			mTerrorist.mbSurrendered ||
			!mTerrorist.mbIsCombatCapable )
	{
		return false;
	} 

	if ( mLastEngageResponseTime > (Level.TimeSeconds - 0.5) )
	{
		return false;
	}
	mLastEngageResponseTime = Level.TimeSeconds;

	// GPTODO: Call  this before enterring EngageThreat fn. Do fallback action if can't attack.
	if ( !mTerroristMgr.RequestBeginAttack( self ) )
	{
		DoIdle();		// _DI find safe cover away from threats.
		return false;
	}

	if ( aThreatPawn != Enemy )
	{
		mTerrorist.AcquiredNewTarget();
	}

	SetEnemy( aThreatPawn ); 

	// Don't change from cover objective if havn't reached our CP yet.
	if (	(meCurObjective == TERROBJ_CoverAttack) && 
			((mCoverPoint != None) && mTerrorist.ReachedDestination( mCoverPoint )) )
	{
		return false;
	}

	diceRoll = FRand();

	// If currently investigating then cannot choose retreat reaction.
	if ( meCurObjective == TERROBJ_Investigating )
	{
		if ( mTerrorist.mAlertRetreatPct > 0.0 )
		{
			diceRoll *= (1.0 - mTerrorist.mAlertRetreatPct);
			bNoRetreat = true;
		}
	}

	// If at cover and it provides cover from threat then stay there.
	if (	(mTerrorist.mAlertCoverPct > 0.0) && 
			(mCoverPoint != None) &&
			//(mCoverPoint.meCoverSetting > COVER_None) &&
			(mTerrorist.ReachedDestination( mCoverPoint )) &&
			!CoverPointExposedTo( SASPawn( Enemy ) ) )
	{
		StartCoverAttack( true );
		return true;
	}

	// Choose aggressive attack?
	if ( (mTerrorist.mAlertAggressivePct > 0.0)
		&& (diceRoll <= mTerrorist.mAlertAggressivePct) )
	{
		StartAggressiveAttack( true );
		return true;
	}

	// Choose cover attack?
	diceRoll -= mTerrorist.mAlertAggressivePct;
	if ( (mTerrorist.mAlertCoverPct > 0.0) 
		&& (diceRoll <= mTerrorist.mAlertCoverPct) )
	{
		if ( SeekCoverInAssaultVolume() )
		{
			StartCoverAttack( true );
			return true;
		}

		bTriedFindingCover = true;
	}

	// Try to retreat.
	if ( (mTerrorist.mAlertRetreatPct > 0.0) && !bNoRetreat && StartRetreat() )
	{
		DoRetreating();
		return true;
	}
	// Can't retreat, so falback to try to find cover if not already tried.
	else if ( !bTriedFindingCover 
		&& (mTerrorist.mAlertCoverPct > 0.0) 
		&& SeekCoverInAssaultVolume() )
	{
		StartCoverAttack( true );
		return true;
	}

	// Do aggressive if allowed, else shoot from stationary and keep trying
	// to find cover/retreat.
	StartAggressiveAttack( true );
	return true;
}


///////////////////////////////////////////////////////////////////////////////
// InitReaction
// 
function InitReaction(
	ETerrReactType			aeReactType,
	optional SASPawn		aReactingTo )
{
	local float	reactTime;

	if ( mTerrorist == None )
	{
		return;
	}

	// Dont override a pending reaction of equal or higher priority.
	// (Reaction type enum is in ascending priority order).
	if ( aeReactType <= mReaction.eReactType )
	{
		return;
	}

	mReaction.eReactType	= aeReactType;
	mReaction.ReactTo		= aReactingTo;

	// Set delay time.
	reactTime = RandRange( mTerrorist.mReactionTime.Min, mTerrorist.mReactionTime.Max );
	if ( reactTime == 0.0 )
	{	
		CompleteReaction();
	}
	else
	{
		SetMultiTimer( mTimerReaction, reactTime, false );
	}
}


///////////////////////////////////////////////////////////////////////////////
// ClearReaction
// 
function ClearReaction()
{
	mReaction.eReactType	= TERRREACT_None;
	mReaction.ReactTo		= None;

	// Stop reaction delay timer.
	StopMultiTimer( mTimerReaction );
}


///////////////////////////////////////////////////////////////////////////////
// CompleteReaction
// 
function CompleteReaction()
{
	if (IsIncapacitated ())
	{
		return;
	} // if

	switch ( mReaction.eReactType )
	{
	case TERRREACT_EngageEnemy:
		if ( mReaction.ReactTo != None )
		{
			EngageThreat( SASPawn( mReaction.ReactTo ) );
		}
		break;

	case TERRREACT_SeenDeadBody:
		if ( !mbIsAlert )
		{
			if ( SeekCoverInAssaultVolume() )
			{
				DoCoverIdle();
			}
		}
		break;
	}

	ClearReaction();
}


///////////////////////////////////////////////////////////////////////////////
// NotifyKilled
// 
// Called whenver any pawn dies. 
function NotifyKilled(
	Controller	aKiller,
	Controller	aKilled,
	Pawn		aOther )
{
	local SASPawn	otherSASPawn;

	Super.NotifyKilled( aKiller, aKilled, aOther );

	otherSASPawn = SASPawn( aOther );
	if ( otherSASPawn == None )
	{
		return;
	}

	// Update the threats list if it contains this pawn.
	RemoveThreat( otherSASPawn );
}


///////////////////////////////////////////////////////////////////////////////
// NotifyIncapacitated
//
// Called whenver any pawn is incapacitated. 
function NotifyIncapacitated(
	Pawn	aIncapacitated )
{
	local SASPawn	otherSASPawn;

	Super.NotifyIncapacitated( aIncapacitated );

	otherSASPawn = SASPawn( aIncapacitated );
	if ( otherSASPawn == None )
	{
		return;
	}

	// Update the threats list if it contains this pawn.
	RemoveThreat( otherSASPawn );
}


///////////////////////////////////////////////////////////////////////////////
// NotifyOtherChangedSide
//
// Called when a pawn is made to change sides via scripting system.
function NotifyOtherChangedSide(
	SASPawn		aOther )
{
	// If aOther is in threats list and is no longer valid then remove.
	if ( !mTerrorist.IsAThreat( aOther ) )
	{
		RemoveThreat( aOther );
	}

	if ( Enemy == aOther )
	{
		Enemy = None;
		//ReassessSituation();
	}
}


///////////////////////////////////////////////////////////////////////////////
// GetSpecialCrouchAnim
//
function name GetSpecialCrouchAnim() 
{ 
	local int lastSeenThreatIdx;

	lastSeenThreatIdx = GetLastSeenThreatIdx();

	// If have a sighted threat and not trying to fire and at cover then duck if necessary.
	if (	(lastSeenThreatIdx >= 0) &&
			!TryingToFire() &&
			(mCoverPoint != None) && 
			(mCoverPoint.meCoverSetting > COVER_Low) &&
			(mCoverReachedTime != -1.0 ) &&
			mCoverPoint.mbDuckWhenCrouched &&
			(GetStateName() != 'CoverAttackingExposed') )
	{
		if ( SASWeapon( mTerrorist.Weapon ).me3PAnimSet != WPN3P_Sig )
		{
			return 'Kneel_Hide_AK47';
		}
		else
		{	
			return 'Kneel_Hide_Sig';
		} 
	}

	return 'None';
}


///////////////////////////////////////////////////////////////////////////////
// CanBeScripted
//
// Used to check we are in a suitable state to run a script.
function bool CanBeScripted()
{
	if ( !Super.CanBeScripted() )
	{
		return false; 
	}

	if ( mTerrorist.mbCaptured || mTerrorist.mbSurrendered )
	{
		return false;
	}

	return true;
}


///////////////////////////////////////////////////////////////////////////////
// HandleChangeToScripting
//
// Called just before switching to scripting state to allow controller to 
// do anything it need to ready itself for scripting (e.g. Store state to return
// to after script has completed).
function HandleChangeToScripting()
{
	
}


///////////////////////////////////////////////////////////////////////////////
// GroupPermissionToChangeCover
//
// Event received when group says terrorist can move to new cover.
// Returns true if move to new cover takes place.
event bool GroupPermissionToChangeCover()
{
	// Just reset the 'wants to move' flag. Overidden versions of the
	// event will handle actually moving.
	mbWantsToChangeCover = false;

	return false;
}


///////////////////////////////////////////////////////////////////////////////
// GroupRequestProvideBackupFireFor
//
event bool GroupRequestProvideBackupFireFor(
	SASTerroristController	aOther )
{
	return false;
}


///////////////////////////////////////////////////////////////////////////////
// LeaveScripting
//
// Called when leaving scripting state to allow controller to switch to correct
// follow-on action.
function LeaveScripting()
{
	Super.LeaveScripting();

	DoCurrentObjective();
}


///////////////////////////////////////////////////////////////////////////////
// SetCurrentObjective
//
function SetCurrentObjective(
	ETerrObjective	aeNextObjective )
{
	// ECM BIG HACK...
	mScriptInterface.mScript = None;
	DisableAllSenses( false );

	if ( aeNextObjective == meCurObjective)
	{
		return;
	}

	// Tidy up current objective.
	LeaveCurrentObjective();

	// Remove from attack group if moving from grouped attack to non-grouped attack objective.
	if ( mGroup != None )
	{
		if ( IsGroupedAttackObjective( meCurObjective ) && !IsGroupedAttackObjective( aeNextObjective ) )
		{
			mGroup.RemoveMember( self );	
		}
	}

	// Tell terrorist mgr we are no longer in attacking state.
	if ( IsAttackingObjective( meCurObjective ) && !IsAttackingObjective( aeNextObjective ) )
	{
		mTerroristMgr.EndingAttack( self );
	}

	// Release current CP if not needed in next state
	if ( !ObjectiveUsesCoverPoint( aeNextObjective ) )
	{
		RelinquishCoverPoint();
	}

	meCurObjective = aeNextObjective;
}


///////////////////////////////////////////////////////////////////////////////
// LeaveCurrentObjective
//
// Deal with any tidying up needed when exitting current objective.
function LeaveCurrentObjective()
{
	switch( meCurObjective )
	{
	case TERROBJ_Patrolling:
		RelinquishPatrolPoint();
		break;

	case TERROBJ_Investigating:
		mTerroristMgr.EndInvestigating( self );
		break;

	case TERROBJ_ThreatenHostage:
	case TERROBJ_BeatingHostage:
		if ( mTerrorist.mHostageTarget != None )
		{
			mTerrorist.mHostageTarget.EndGuardedByTerrorist();
			mTerrorist.mHostageTarget = None;
		}
		break;
	}
}


///////////////////////////////////////////////////////////////////////////////
// ObjectiveUsesCoverPoint
//
function bool ObjectiveUsesCoverPoint(
	ETerrObjective	aeObjective )
{
	switch ( aeObjective )
	{
	case TERROBJ_CoverIdle:
	case TERROBJ_CoverAttack:
	case TERROBJ_ActingDead:
		return true;
	}

	return false;
}


///////////////////////////////////////////////////////////////////////////////
// ResumeObjective
//
function ResumeObjective()
{
	DoCurrentObjective();
}


///////////////////////////////////////////////////////////////////////////////
// DoCurrentObjective
//
function DoCurrentObjective()
{
	// Can't do any of this if incapacitated
	if (IsIncapacitated ())
	{
		if ( GetStateName() != 'Incapacitated' )
		{
			SetCurrentObjective( TERROBJ_None );
			GotoState( 'Incapacitated' );
		}
		return;
	} // if

	if ( ResumeScripting() )
	{
		return;
	}

	switch ( meCurObjective )
	{
	case TERROBJ_Idle:
		DoIdle();
		break;

	case TERROBJ_Patrolling:
		DoPatrolling();
		break;

	case TERROBJ_CoverIdle:
		DoCoverIdle();
		break;

	case TERROBJ_RallyingToPoint:
		DoMoveToRallyPoint();
		break;

	case TERROBJ_Surrendered:
		DoSurrender();
		break;

	case TERROBJ_OrderedDown:
		if ( !DoOrderedDown() )
		{
			DoIdle();	// _DI check if can attack, else find cover.
		}
		break;

	case TERROBJ_Restrained:
		DoRestrained();
		break;

	case TERROBJ_AlertedNoEnemy: 
		DoAlertNoEnemy();
		break;

	case TERROBJ_Investigating:
		DoInvestigating();
		break;

	case TERROBJ_ActingDead:
		DoActingDead( mbHoldActingDead );
		break;

	case TERROBJ_ThreatenHostage:
		DoThreatenHostage();
		break;

	case TERROBJ_BeatingHostage:
		DoBeatHostage();
		break;
			
	case TERROBJ_AggressiveAttack:
		DoAggressiveAttack();
		break;

	case TERROBJ_Retreating:
		DoRetreating();
		break;

	case TERROBJ_AdvancingToCloserCover:
		DoAdvanceToCloserCover();
		break;

	case TERROBJ_CoverCloseInFallback:
		DoCoverCloseInFallback();
		break;

	case TERROBJ_CoverAttack:
		if ( SeekCoverInAssaultVolume() )
		{
			DoCoverAttack();
		}
		else
		{	
			// HACK
			// What to do depends on if we are alert or have enemy.
			DoIdle();		// _DI check can attack, else find cover in adjascent else idle.
		}
		break;

	case TERROBJ_FixedStationary: 
		DoFixedStationary();
		break;

	default:
		Warn( "Current objective "$meCurObjective$" invalid.");
		DoIdle();			// _DI check can attack, else find cover in adjascent else idle.
		break;
	}
}


//-----------------------------------------------------------------------------
// State change intermediary functions


///////////////////////////////////////////////////////////////////////////////
// DoIdle
// 
function DoIdle()
{
	Enemy = None;

	if (IsIncapacitated ())
	{
		return;
	}

	if ( mSASPawn.mbCaptured )
	{
		DoSurrender();
	}

	SetCurrentObjective( TERROBJ_Idle );
	GotoState( 'Idle' );
}


///////////////////////////////////////////////////////////////////////////////
// DoPatrolling
// 
function DoPatrolling()
{
	SetCurrentObjective( TERROBJ_Patrolling );
	GotoState( 'Patrolling' );
}


///////////////////////////////////////////////////////////////////////////////
// DoPatrolIdle
// 
function DoPatrolIdle(
	float			aIdleTime, 
	optional name	aIdleAnim )
{
	mIdleTime = aIdleTime;
	mIdleAnim = aIdleAnim;

	if (IsIncapacitated ())
	{
		return;
	} // if

	SetCurrentObjective( TERROBJ_Patrolling );
	GotoState( 'PatrolIdle' );
}


///////////////////////////////////////////////////////////////////////////////
// DoHideIdle
// 
function DoHideIdle()
{
	if (IsIncapacitated ())
	{
		return;
	} // if

	SetCurrentObjective( TERROBJ_Idle );
	GotoState( 'HideIdle' ); 
}


///////////////////////////////////////////////////////////////////////////////
// DoAlertNoEnemy
//
function DoAlertNoEnemy()
{
	if (IsIncapacitated ())
	{
		return;
	} // if

	SetCurrentObjective( TERROBJ_AlertedNoEnemy );
	GotoState( 'AlertedNoEnemy' );
}	


///////////////////////////////////////////////////////////////////////////////
// DoInvestigating
//
function DoInvestigating()
{
	if (IsIncapacitated ())
	{
		return;
	}

	if ( mTerroristMgr.StartInvestigating( self ) )
	{	
		if ( meCurObjective != TERROBJ_Investigating )
		{
			mSASPawn.PlayDelayedSpeech( SPEECH_TerrAggressiveNoThreat, false );

			// Decide whether to investigate right into investigation AV or hang back in adjascent AV.
			if ( FRand() < (mTerrorist.mAlertAggressivePct / (mTerrorist.mAlertAggressivePct + mTerrorist.mAlertCoverPct)) )
			{
				mbInvestigateHangBack = true;
			}
			else
			{
				mbInvestigateHangBack = false;
			}
		}

		if ( meCurObjective != TERROBJ_Investigating )
		{
			mInvestigateStartTime = Level.TimeSeconds;
		}

		SetCurrentObjective( TERROBJ_Investigating );
		GotoState( 'Investigating' );		
	}
}


///////////////////////////////////////////////////////////////////////////////
// ShouldCallBackup
//
// Returns true if we should go into CallBackup state before engaging a newly
// detected threat. 
function bool ShouldCallBackup(
	SASPawn		aDetectedThreat )		// Newly detected threat.
{
	local SASTerrorist				other;
	local SASTerroristController	otherController;

	if (IsIncapacitated ())
	{
		return false;
	} // if

	// Prevent too many backup calls close together. 
	// GPTODO: This restriction may mean nearby terrorists are not alerted until combat begins since
	// the call backup noise is used to wake them up. We'll see...
	if ( (Level.TimeSeconds - mTerroristMgr.mLastCallForBackupTime) < mTerroristMgr.MIN_TIME_BETWEEN_TERRORIST_CALL_BACKUP )
	{
		return false;
	}

	// Don't call for backup if anyone nearby has already seen the threat.
	// GPTODO: Or if anyone has seen a threat nearby to this threat (to prevent backup calls for 
	// successive sightings of each member of the squad).
	foreach mSASPawn.GetGame().RadiusSASPawns( class'SASTerrorist', other, mSASPawn.Location, 1000.0 )
	{
		if ( (other != Pawn) && (other.Controller != None) )
		{
			otherController = SASTerroristController( other.Controller );
			if ( otherController != None )
			{
				if ( otherController.HasSeenThreat( aDetectedThreat ) )
				{
					return false;
				}
			}
		}
	}

	return true;
}


///////////////////////////////////////////////////////////////////////////////
// StartCoverIdle
// 
function StartCoverIdle( 
	optional SASEntryPoint	aGuardingEP,
	optional bool			abPlaySpeech )
{
	Enemy = None;

	if ( abPlaySpeech )
	{
		mSASPawn.PlayDelayedSpeech( SPEECH_TerrCoverNoThreat, false );
	}

	mFocalEP = aGuardingEP;
	DoCoverIdle();
}


///////////////////////////////////////////////////////////////////////////////
// DoCoverIdle
// 
function DoCoverIdle()
{
	if ( IsIncapacitated() )
	{
		return;
	}

	SetCurrentObjective( TERROBJ_CoverIdle );
	GotoState( 'CoverIdle' );
}


///////////////////////////////////////////////////////////////////////////////
// StartAggressiveAttack
// 
function StartAggressiveAttack( 
	bool	abPlaySpeech )
{
	if ( abPlaySpeech )
	{
		mSASPawn.PlaySpeech( SPEECH_TerrAggressiveSeenThreat );
	}
	
	DoAggressiveAttack();
}


///////////////////////////////////////////////////////////////////////////////
// DoAggressiveAttack
// 
function DoAggressiveAttack(
	optional name	aStateLabel )
{
	if (IsIncapacitated ())
	{
		return;
	} // if

	SetCurrentObjective( TERROBJ_AggressiveAttack );
	GotoState( 'AggressiveAttack', aStateLabel );
}


///////////////////////////////////////////////////////////////////////////////
// StartCoverAttack
// 
function StartCoverAttack(
	bool	abPlaySpeech )
{
	if ( abPlaySpeech )
	{
		mSASPawn.PlayDelayedSpeech( SPEECH_TerrCoverSeenThreat, false );
	}

	DoCoverAttack();
}

///////////////////////////////////////////////////////////////////////////////
// DoCoverAttack
// 
function DoCoverAttack()
{
	if (IsIncapacitated ())
	{
		return;
	} // if

	SetCurrentObjective( TERROBJ_CoverAttack );
	GotoState( 'MovingToCover' );
}


///////////////////////////////////////////////////////////////////////////////
// DoCoverCloseInFallback
// 
function DoCoverCloseInFallback()
{
	SetCurrentObjective( TERROBJ_CoverCloseInFallback );
	GotoState( 'CoverCloseInFallback' );
}


///////////////////////////////////////////////////////////////////////////////
// DoAdvanceToCloserCover
// 
function DoAdvanceToCloserCover()
{
	if (IsIncapacitated ())
	{
		return;
	} // if

	SetCurrentObjective( TERROBJ_AdvancingToCloserCover );
	GotoState( 'AdvancingToCloserCover' );
}


///////////////////////////////////////////////////////////////////////////////
// DoRetreating
// 
function DoRetreating()
{
	if (IsIncapacitated ())
	{
		return;
	} // if

	if ( meCurObjective != TERROBJ_Retreating )
	{
		mSASPawn.PlayDelayedSpeech( SPEECH_TerrRetreat, false );
	}

	// Flag that we have chosen to retreat - this stops us trying to investigate in the future.
	mbHasRetreated = true;

	SetCurrentObjective( TERROBJ_Retreating );
	GotoState( 'Retreating' );
}


///////////////////////////////////////////////////////////////////////////////
// DoActingDead
// 
function DoActingDead(
	bool abStayDown )
{
	if (IsIncapacitated ())
	{
		return;
	} // if

	StopMoving();
	ClearReaction();

	SetCurrentObjective( TERROBJ_ActingDead );
	mbHoldActingDead = abStayDown;
	GotoState( 'ActingDead' );
}


///////////////////////////////////////////////////////////////////////////////
// EndActingDead
//
// Overridden in ActingDead state to force pawn out of acting dead state.
function bool EndActingDead(
	bool abRecoverToIdle )
{
	return false;
}


///////////////////////////////////////////////////////////////////////////////
// DoFixedStationary
//
function DoFixedStationary()
{
	if (IsIncapacitated ())
	{
		return;
	}

	SetCurrentObjective( TERROBJ_FixedStationary );
	GotoState( 'FixedStationary' );
}

///////////////////////////////////////////////////////////////////////////////
// DoThreatenHostage
//
function DoThreatenHostage()
{
	if (IsIncapacitated ())
	{
		return;
	} 

	if ( mTerrorist.mHostageTarget != None )
	{
		SetCurrentObjective( TERROBJ_ThreatenHostage );

		mTerrorist.mHostageTarget.StartThreatenedByTerrorist ( mTerrorist );
		GotoState( 'ThreateningHostage' );
	}
	else
	{
		// _DI check can attack, else find cover else idle.
		DoIdle();
	}
}


///////////////////////////////////////////////////////////////////////////////
// StopThreateningHostage
//
function StopThreateningHostage()
{
	if ( meCurObjective == TERROBJ_ThreatenHostage )
	{
		mTerrorist.mHostageTarget.EndGuardedByTerrorist();
		mTerrorist.mHostageTarget = None;

		// _DI check can attack, else find cover in adjascent else idle.
		DoIdle();
	}
}


///////////////////////////////////////////////////////////////////////////////
// DoBeatHostage
//
function DoBeatHostage()
{
	if (IsIncapacitated ())
	{
		return;
	} 

	if ( mTerrorist.mHostageTarget != None )
	{
		SetCurrentObjective( TERROBJ_BeatingHostage );

		mTerrorist.mHostageTarget.StartTakeBeatingFromTerrorist( mTerrorist );
		GotoState( 'BeatingHostage' );
	}
	else
	{
		// _DI check can attack, else find cover in adjascent else idle.
		DoIdle();
	}
}


///////////////////////////////////////////////////////////////////////////////
// StopBeatingHostage
//
function StopBeatingHostage()
{
	if ( meCurObjective == TERROBJ_BeatingHostage )
	{
		mTerrorist.mHostageTarget.EndGuardedByTerrorist();
		mTerrorist.mHostageTarget = None;

		// _DI check can attack, else find cover in adjascent else idle.
		DoIdle();
	}
}


///////////////////////////////////////////////////////////////////////////////
// Surrender
// 
function DoSurrender()
{	
	if ( IsIncapacitated() )
	{
		return;
	}

	// Prevent acting dead from occuring in the future.
	mTerrorist.mActDeadChance = 0.0;

	// If not already surrendered...
	if ( !mTerrorist.mbSurrendered )
	{
		//mSASPawn.PlayDelayedSpeech( SPEECH_TerrSurrender, false );

		mSurrenderBreakoutGuardedTime = 0.0;
		mTerrorist.mbPlayedSurrendering = false;

		// Random chance of breaking out of surrendered behaviour if have a weapon available.
		if ( FRand() < mTerrorist.mSurrenderBreakoutGuardedChance )
		{
			// Check weapon availability. - must have a primary and secondary weapon available since one
			// of them will get dropped during surrender state.
			if (	(mTerrorist.GetWeaponOfCategory( WPNCAT_Primary ) != None) &&
					(mTerrorist.GetWeaponOfCategory( WPNCAT_Secondary ) != None) )
			{
				mSurrenderBreakoutGuardedTime = 
						Level.TimeSeconds + 
						RandRange(
							mTerrorist.mSurrenderBreakoutGuardedTime.Min,
							mTerrorist.mSurrenderBreakoutGuardedTime.Max );
			}

			// Don't let this happen again.
			mTerrorist.mSurrenderBreakoutGuardedChance = 0.0;
		}
	}

	// Notify objectives system, set captured flag.
	mTerrorist.Surrender( true );

	SetCurrentObjective( TERROBJ_Surrendered );
	GotoState( 'Surrendered' );
}


///////////////////////////////////////////////////////////////////////////////
// DoOrderedDown
// 
function bool DoOrderedDown()
{
	// Don't be ordered down if not surrendered.
	if ( !mTerrorist.mbSurrendered )
	{
		Warn( "Terrorist "$Pawn$" ordered down when not surrendered." );
		return false;
	}

	if ( IsInState( 'Transition' ) )
	{
		return false;
	}

	// Ignore if already captured (cuffed).
	if ( mTerrorist.mbCaptured )
	{
		return false;
	}

	if (IsIncapacitated ())
	{
		return false;
	} // if

	// Ensure we are not still holding onto a weapon.
	if ( mSASPawn.Weapon != None )
	{
		mSASPawn.DropWeapon();
		mSASPawn.Weapon = None;
	}

	SetCurrentObjective( TERROBJ_OrderedDown );
	GotoState( 'OrderedDown' );
	return true;
}


///////////////////////////////////////////////////////////////////////////////
// DoRestrained
// 
function DoRestrained()
{
	GotoState( 'Restrained' );
}


///////////////////////////////////////////////////////////////////////////////
// DoIncapacitated
//
// Reaction to being seriously hurt - to the extent that we can't do anything.
function DoIncapacitated(
	Pawn	aInstigator )
{
	local int shooterCount;

	if (IsIncapacitated ())
	{
		return;
	} // if

	ClearReaction();
	
	if ( mTerrorist.mVoice != None )
	{
		mTerrorist.mVoice.ClearDelayedSpeechFor( mTerrorist );
	}

	if (	!mTerrorist.mbFixedStationary && 
			(FRand() < mTerrorist.mActDeadChance) && 
			(mTerrorist.Weapon != None) )
	{
		// Must have at least 2 firing weapons available to act dead. 
		// (current weapon + 1 backup in case current weapon is dropped during cuffing).
		if ( mSASPawn.GetWeaponOfCategory( WPNCAT_Primary ) != None )
		{
			shooterCount++;
		}
		if ( mSASPawn.GetWeaponOfCategory( WPNCAT_Secondary ) != None )
		{
			shooterCount++;
		}
		if ( mSASPawn.GetWeaponOfCategory( WPNCAT_Special ) != None )
		{
			shooterCount++;
		}

		if ( shooterCount > 1 )
		{
			mTerrorist.PlayActingDead( false );
			return;
		}
	}
	
	SetCurrentObjective( TERROBJ_None );
	
	if ( mTerroristMgr != None )
	{
		mTerroristMgr.RemoveTerrorist( self );
	}

	Super.DoIncapacitated( aInstigator );
}


///////////////////////////////////////////////////////////////////////////////
// DoStunned
// 
function DoStunned(
	float	aStunTime )
{
	if (IsIncapacitated ())
	{
		return;
	} // if

	if ( aStunTime > 0.0 )
	{
		mSASPawn.mbStunned = true;
		if ( !IsInState( 'Stunned' ) )
		{
			StopMoving();
			StopRepeatFiring();

			mTerrorist.ChooseStunnedAnim();

			GotoState( 'Stunned' );
		}

		SetTimer( aStunTime, false );
	}
}


///////////////////////////////////////////////////////////////////////////////
// IsSurprisedBy
// 
// Currently just a range check to see how close the other pawn is. 
// Fn assumes aOther is an enemy and we currently have the potential to be 
// surpirised.
// TODO: 
// 1) Randomise chance of surprise.
// 2) Vary chance of surprise/max triggering dist on an alertness level.
function bool IsSurprisedBy(
	Pawn	aOther )
{
	local Vector	vecToOther;

	vecToOther = aOther.Location - Pawn.Location;
	if ( VSizeSq( vecToOther ) < Square( SURPRISED_MAX_DIST ) )
	{
		return true;
	}

	return false;
}


///////////////////////////////////////////////////////////////////////////////
// DoSprayFire
// 
function DoSprayFire()
{
	if (IsIncapacitated ())
	{
		return;
	} // if

	//SetCurrentObjective( TERROBJ_SprayFire );
	GotoState( 'SprayingFire' );
}


///////////////////////////////////////////////////////////////////////////////
// CallToRallyPoint
// 
function CallToRallyPoint(
	SASTerroristRallyPoint	aRallyPoint )
{
	local int	threatIdx;

	// Captured, dead or incapacitated terrorists can't be called!
	if ( (mSASPawn == None) 
		|| mSASPawn.mbCaptured
		|| mTerrorist.mbSurrendered
		|| mSASPawn.IsDead() 
		|| IsIncapacitated()
		|| mTerrorist.mbFixedStationary )
	{
		return;
	}

	// If in attacking state and recently seen a threat then ignore call to rally point.
	if ( IsAttackingObjective( meCurObjective ) )
	{
		threatIdx = GetLastSeenThreatIdx();
		if ( (threatIdx >= 0) &&
			 ((Level.TimeSeconds - mThreats[threatIdx].LastSeenTime) < 2.0) )
		{
			// Only if threat is nearby.
			if ( VSizeSq( mThreats[threatIdx].Pawn.Location - Pawn.Location ) < Square( 1500.0 ) )
			{
				return;
			}
		}
	}

	mRallyPoint	= aRallyPoint;
	DoMoveToRallyPoint();
}


///////////////////////////////////////////////////////////////////////////////
// DoMoveToRallyPoint
// 
function DoMoveToRallyPoint()
{
	if ( mRallyPoint == None )
	{
		Warn( "Called DoMoveToRallyPoint() with no rally point set." );
		// _DI check can attack, else find cover in adjascent else idle.
		DoIdle();
		return;
	}

	SetCurrentObjective( TERROBJ_RallyingToPoint );
	GotoState( 'MovingToRallyPoint' );
}


///////////////////////////////////////////////////////////////////////////////
// DoStaggerBackward
// 
function bool DoStaggerBackward(
	SASPawn	aHitPawn )
{
	local Vector	vecToHitPawn;

	// Not if prone!
	if ( mTerrorist.meStance != STANCE_Prone )
	{
		// Only stagger backwards if bumped from ahead.
		vecToHitPawn = aHitPawn.Location - mTerrorist.Location;
		vecToHitPawn.Z = 0.0;
		if ( (vecToHitPawn Dot mTerrorist.YawDirection()) > 0.0 ) 
		{
			GotoState( 'StaggeringBackward' );
			return true;
		}
	}

	return false;
}


///////////////////////////////////////////////////////////////////////////////
// DoPunchedByPlayer
//
function DoPunchedByPlayer(
	SASPawn	aHitBy )
{
	if ( mTerrorist.meStance == STANCE_Standing && FRand() > 0.3 )
	{
		if ( DoStaggerBackward( aHitBy ) )
		{
			return;
		}
	}
	
	Super.DoPunchedByPlayer( aHitBy );
}


//-----------------------------------------------------------------------------
// States

function bool CanAttackWhileSteppingAside();
function InitUnalertIdle();
function bool IsPlayingSpotAnim();
function SetSpotAnimTimer();
function SetChangeFacingTimer();
function PlaySpotAnim();
function ChangeFacing();
function CheckThreats();
function GetNextPatrolPoint();
function DoPatrolPointReachedAction();
function bool InRangeOfRallyPoint();
function FinishCallBackup();
function bool CallBackupInRange();
function MonitorSteppingBack( 
	bool	abMonitor );
function bool CheckStepBackFromEnemy();
function bool IsTooCloseToEnemy();
function Actor GetChargingDest();
function Actor GetMovingFocus();
function CheckGoStationary();
function bool ChooseNextCoverPoint();
function bool InRangeOfChargingDest();
function ChooseCoverExposedReaction(
	SASPawn	aThreat );
function ESASPace ChooseMovePace();
function ESASStance	ChooseMoveStance();
function Vector GetMovingFocalPoint();
function bool CheckThrowGrenade();
function bool SelectEnemyAndAttack();
function DoCoverPointReachedAction();
function CheckIfExposed();
function CheckTargets();
function EndCoverAttack();
function SelectTarget();
function Actor ChooseMovingFocus();
function ChooseEnemy( optional bool abExcludeCurrent );
function bool GetNextCoverPoint();
function ChooseSurrenderReaction();
function ChooseSurrenderedFacing();
function bool CanRecoverFromActingDead();
function bool CheckPlayingAnimFromActingDead(
	bool abAnimEnd );
function StopSprayFiring();
function StartSprayFiring();
function InitStandoffSpeech();
function CheckPlayStandoffSpeech();
function GetBestShieldedPosition();
function BeatHostage();



///////////////////////////////////////////////////////////////////////////////
// STATE SteppingAside
// 
state SteppingAside
{
	ignores ReactToAlertFriendly,
			CanInvestigate;

	event BeginState()
	{
		Super.BeginState();

		// Activate timed threat assessment at low frequency.
		if ( CanAttackWhileSteppingAside() )
		{
			StartPeriodicTargetSelection( TSF_Low );
		}
	}

	///////////////////////////////////////////////////////////////////////////////
	// EndState
	// 
	event EndState()
	{
		Super.EndState();

		// Deactivate timed threat reassessment.
		StopPeriodicTargetSelection();

		StopRepeatFiring();
	}


	///////////////////////////////////////////////////////////////////////////////
	// CanAttackWhileSteppingAside
	// 
	function bool CanAttackWhileSteppingAside()
	{
		// Don't try to attack if incapable of doing so.
		if ( mTerrorist.mbCaptured || mTerrorist.mbSurrendered || !mTerrorist.mbIsCombatCapable )
		{
			return false;
		}

		// Don't attack while guarding a hostage.
		if ( mTerrorist.mHostageTarget != None )
		{
			return false;
		}

		return true;
	}


	///////////////////////////////////////////////////////////////////////////////
	// EnemyNotBestTarget
	// 
	event EnemyNotBestTarget(
		SASPawn	aBestTarget )
	{
		if ( CanAttackWhileSteppingAside() )
		{
			SetEnemy( aBestTarget );
			BeginBurstFireAt( Enemy );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// ReactToThreat
	// 
	event ReactToThreat(
		SASPawn			aThreat,
		EStimulusType	aeDetectionStimulus,
		bool			abNoCallBackup )
	{
		UpdateThreatInfo( aThreat, aeDetectionStimulus );

		if ( !CanAttackWhileSteppingAside() )
		{
			return;
		}

		switch ( aeDetectionStimulus )
		{
		case STIMULUS_Sight:
		case STIMULUS_Bump:
		case STIMULUS_Damage:
			if ( Enemy == None )
			{
				SetEnemy( aThreat );
			}

			if ( Focus != Enemy )
			{
				FocusOnEnemy();
			}
			break;

		case STIMULUS_Noise:
			if ( Enemy == None )
			{
				if ( CanSeePawn( aThreat, true ) )
				{
					SetEnemy( aThreat );
				}
			}
			break;

		default:
			Warn( "Unhandled stimulus type <"$aeDetectionStimulus$" in SteppingAside.ReactToThreat." );
		}

		// Make sure trying to fire if have enemy.
		if ( (Enemy != None) && (!TryingToFire() || (Target != Enemy)) )
		{
			BeginBurstFireAt( Enemy );
		} 
	}

Begin:

	// If capable of attacking while stepping aside then do so.
	if ( (Enemy != None) && (mTerrorist.Weapon != None) && CanAttackWhileSteppingAside() )
	{
		FocusOnEnemy();
		BeginBurstFireAt( Enemy );
	}

	Goto( 'StartSteppingAside' );
}


///////////////////////////////////////////////////////////////////////////////
// StaggeringBackward
// 
state StaggeringBackward
{
	ignores HearNoise,
			NotifyBump,
			DoStunned,
			DoGassed,
			ReactToGrenade,
			WeaponPointedAt,
			NotifyPlayerAboutToBump,
			CanStepAside,
			DoStepAside,
			DoStaggerBackward,
			ServerDoPunchedByPlayer,
			ReactToAlertFriendly,
			CanInvestigate,
			CheckCanBePunched;


	///////////////////////////////////////////////////////////////////////////////
	// EndState
	// 
	event EndState()
	{	
		bControlAnimations = false;

		if ( mTerrorist != None )
		{
			mTerrorist.EndStaggerBackwardAnim();
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// ReactToThreat
	// 
	event ReactToThreat(
		SASPawn			aThreat,
		EStimulusType	aeDetectionStimulus,
		bool			abNoCallBackup )
	{
		// Just update our threat info while in this state.
		UpdateThreatInfo( aThreat, aeDetectionStimulus );
	}


Begin:

	StopMoving();
	StopRepeatFiring();

	mTerrorist.PlaySpeech( SPEECH_GenHit, true );

	//Fix facing direction.
	FixCurrentFacing();

	// Stand up if not already. No time to play transition anim, just get stright up.
	mTerrorist.ChangeStanceImmediate( STANCE_Standing );

	// Play stagger back anim with root motion physics and wait for it to complete.
	bControlAnimations = true;
	mTerrorist.PlayStaggerBackwardAnim();
	FinishAnim( ANIMCHANNEL_ACTION );
	bControlAnimations = false;
	mTerrorist.EndStaggerBackwardAnim();

	// Return to normal AI.
	ResumeObjective();
}


///////////////////////////////////////////////////////////////////////////////
// STATE Idle
// 
state Idle
{
	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	// 
	event BeginState()
	{
		Enable( 'SeePlayer' );
		Enable( 'HearNoise' );

		Enemy = None;
		mTerrorist.SetPhysics( PHYS_Walking );
		mTerrorist.ChangeAnimation();

		if ( !mbIsAlert )
		{
			InitUnalertIdle();
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndState
	// 
	event EndState()
	{
		StopMultiTimer( mTimerIdleAnim );
		SetTimer( 0.0, false );
	}


	///////////////////////////////////////////////////////////////////////////////
	// InitUnalertIdle
	//
	function InitUnalertIdle()
	{
		// Set time to next spot anim.
		if ( mTerrorist.mIdleSpotAnims.Length > 0 )
		{
			SetSpotAnimTimer();
		}
		else
		{
			StopMultiTimer( mTimerIdleAnim );
		}

		// Set time to next facing direction change.
		if ( mTerrorist.mIdleChangeDirPeriod.Min > 0.0 )
		{
			SetChangeFacingTimer();
		}
		else
		{
			SetTimer( 0.0, false);
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// Timer
	// 
	event Timer()
	{
		ChangeFacing();
	}


	///////////////////////////////////////////////////////////////////////////////
	// MultiTimer
	// 
	event MultiTimer(
		int	aTimerIdx )
	{
		switch ( aTimerIdx )
		{
		case mTimerIdleAnim:
			PlaySpotAnim();
			StopMultiTimer( mTimerIdleAnim );
			break;

		default:
			Global.MultiTimer( aTimerIdx );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// AnimEnd
	// 
	event AnimEnd(
		int	aChannel )
	{
		local int	i;
		local int	numSpotAnims;
		local name	anim;
		local float	frame, rate;
		
		// If ended anim is a spot anim then set the timer to wait till
		// the next one to play.
		if ( aChannel == 0 )
		{
			numSpotAnims = mTerrorist.mIdleSpotAnims.Length;
			if ( numSpotAnims > 0 )
			{
				Pawn.GetAnimParams( 0, anim, frame, rate );

				for ( i = 0; i < numSpotAnims; ++i )
				{
					if ( mTerrorist.mIdleSpotAnims[i] == anim )
					{
						SetSpotAnimTimer();
						break;
					}
				}
			}
		}

		Pawn.AnimEnd( aChannel );
	}


	///////////////////////////////////////////////////////////////////////////////
	// IsPlayingSpotAnim
	// 
	function bool IsPlayingSpotAnim()
	{
		local int	i;
		local int	numSpotAnims;
		local name	anim;
		local float	frame, rate;

		if ( Pawn.IsAnimating() )
		{
			numSpotAnims = mTerrorist.mIdleSpotAnims.Length;
			if ( numSpotAnims > 0 )
			{
				Pawn.GetAnimParams( 0, anim, frame, rate );

				for ( i = 0; i < numSpotAnims; ++i )
				{
					if ( mTerrorist.mIdleSpotAnims[i] == anim )
					{
						return true;
					}
				}
			}
		}

		return false;
	}


	///////////////////////////////////////////////////////////////////////////////
	// SetSpotAnimTimer
	// 
	// Sets time to wait until next spot anim is played.
	function SetSpotAnimTimer()
	{
		local float time;

		time = RandRange(
			mTerrorist.mIdleSpotAnimSpacing.Min,
			mTerrorist.mIdleSpotAnimSpacing.Max );
		SetMultiTimer( mTimerIdleAnim, time, false );
	}


	///////////////////////////////////////////////////////////////////////////////
	// SetChangeFacingTimer
	// 
	// Sets time to wait until next pawn direction change.
	function SetChangeFacingTimer()
	{
		local float time;

		time = RandRange(
			mTerrorist.mIdleChangeDirPeriod.Min,
			mTerrorist.mIdleChangeDirPeriod.Max );
		SetTimer( time, false );
	}


	///////////////////////////////////////////////////////////////////////////////
	// PlaySpotAnim
	// 
	function PlaySpotAnim()
	{
		local name	anim;

		// Check pawn is not currently rotating, otherwise wait a bit longer
		// before trying to play anim.
		if ( Pawn.DesiredRotation.Yaw != Pawn.Rotation.Yaw )
		{
			SetMultiTimer( mTimerIdleAnim, Min( 2.0, mTerrorist.mIdleSpotAnimSpacing.Max ), false );
			return;
		}

		if ( IsPlayingSpotAnim() )
		{
			return;
		}

		if ( mTerrorist.mIdleSpotAnims.Length > 0 )
		{
			anim = mTerrorist.mIdleSpotAnims[Rand( mTerrorist.mIdleSpotAnims.Length )];
			mTerrorist.PlayAnim( anim, 1.0, 0.2 );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// ChangeFacing
	// 
	// Rotate Pawn to random facing direction.
	function ChangeFacing()
	{
		local vector	dir;

		// Check not currently playing spot idle anim, otherwise wait a bit longer
		// before trying to rotate.
		if ( IsPlayingSpotAnim() )
		{
			SetTimer( Min( 2.0, mTerrorist.mIdleChangeDirPeriod.Max ), false );
			return;
		}

		// Select new random direction
		dir.X = (FRand() * 2.0) - 1.0;
		dir.X = FClamp( dir.X, -1.0, 1.0 );
		dir.Y = Sqrt( 1.0 - (dir.X*dir.X) );
		if ( FRand() > 0.5 )
		{
			dir.Y = -dir.Y;
		}

		dir = ChooseDirectionNotFacingWall( dir );

		SetFocalPointFromDir( dir );

		SetChangeFacingTimer();
	}


Begin:

	StopMoving();
	StopRepeatFiring();

	ChooseIdleFocalPoint();
}


///////////////////////////////////////////////////////////////////////////////
// STATE PatrolIdle
// 
// Idle state when waiting at a patrol point.
state PatrolIdle
{
	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	// 
	event BeginState()
	{
		Enable( 'SeePlayer' );
		Enable( 'HearNoise' );

		Enemy = None;
		mTerrorist.SetPhysics( PHYS_Walking );
		mTerrorist.SetPace( PACE_Walking );
		StopMoving();
		StopRepeatFiring();
		mTerrorist.ChangeAnimation();

		// Set time before patrollinbg if the terrorist has a patrol network tag
		if ( mTerrorist.mPatrolPointTag != 'None' )
		{
			if( mIdleTime < 0.0 )
			{
				mIdleTime = 0.0;
			}

			SetTimer( mIdleTime, false ); 
		}
	}

	///////////////////////////////////////////////////////////////////////////////
	// Timer
	// 
	event Timer()
	{
		GotoState( 'Patrolling' );
	}
}


///////////////////////////////////////////////////////////////////////////////
// STATE HideIdle
// 
// Idle state when placed at level start hiding point.
state HideIdle
{
	event BeginState()
	{
		Enemy = None;
		mTerrorist.SetPhysics( PHYS_Walking );
		StopMoving();
		StopRepeatFiring();
		mTerrorist.ChangeStanceImmediate( mTerrorist.mIdleHideStance );
	}
}


///////////////////////////////////////////////////////////////////////////////
// STATE CoverIdle
// 
// Wait idle at a designated CP.
state CoverIdle extends MovingState
{
	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	//
	event BeginState()
	{
		Super.BeginState();

		Enemy = None;
		StopRepeatFiring();
		StopMoving();
		if ( mCoverPoint == None )
		{
			// _DI check for other cover else idle.
			DoIdle();
		}

		SetTimer( 0.0, false );
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
	// Timer
	//
	event Timer()
	{
		CheckThreats();
	}


	///////////////////////////////////////////////////////////////////////////////
	// CheckThreats
	//
	function CheckThreats()
	{
		local Pawn	tgtThreat;

		tgtThreat = CheckForEnemyWhileCoverIdle();
		if ( tgtThreat != None )
		{
			EngageThreat( tgtThreat );
		}
	}

	event bool NotifyObstructedDuringMove(
		SASPawn	aObstructor )
	{
		if ( Super.NotifyObstructedDuringMove( aObstructor ) )
		{
			return true;
		}

		// GPTODO: Stop, periodically seek alternative cover which can be reached.
		GotoState( , 'AtCover' );
	}

	function bool NotifyGoalLocationIsBlocked(
		SASPawn	aObstructor )
	{
		GotoState( , 'AtCover' );
		return true;
	}
	

Begin:

	StopRepeatFiring();
	DoMoveToActor( mCoverPoint );

MTP_FinishedMove:

	if ( !mTerrorist.ReachedDestination( mCoverPoint, true ) )
	{
		Sleep( 0.5 );
		Goto( 'Begin' );
	}

AtCover:

	ChooseIdleFocalPoint();
	FinishRotation();

Wait:

	StopMoving();

	// Take CP stance.
	if ( mTerrorist.meStance != mCoverPoint.meStance )
	{
		DoStanceTransition( mCoverPoint.meStance, GetStateName(), 'Wait' );
	}

	// Set timer to check for threats to attack.
	SetTimer( 0.5, true );
}


///////////////////////////////////////////////////////////////////////////////
// STATE FixedStationary
//
state FixedStationary
{
	ignores	CanStepAside,
			DoStepAside,
			SeeGrenade,
			ReactToGrenade,
			DoSurrender,
			CallToRallyPoint,
			DoStunned,
			DoIncapacitated,
			DoStaggerBackward,
			ReactToAlertFriendly,
			CanInvestigate,
			EngageThreat,
			ShouldCallBackup,
			IsSurprisedBy;


	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	//
	event BeginState()
	{
		// Activate timed threat assessment at low frequency.
		StartPeriodicTargetSelection( TSF_Low );
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndState
	// 
	event EndState()
	{
		// Deactivate timed threat assessment.
		StopPeriodicTargetSelection();
	}


	///////////////////////////////////////////////////////////////////////////////
	// EnemyNotBestTarget
	// 
	event EnemyNotBestTarget(
		SASPawn	aBestTarget )
	{
		SetEnemy( aBestTarget );
		BeginBurstFireAt( Enemy );
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyBump
	// 
	event bool NotifyBump(
		Actor	aBumped )
	{
		local SASPawn	bumpedPawn;

		bumpedPawn = SASPawn( aBumped );
		if ( (bumpedPawn != None) && mSASPawn.IsAThreat( bumpedPawn ) )
		{
			ReactToThreat( bumpedPawn, STIMULUS_Bump, true );
		}

		return false;
	}


	///////////////////////////////////////////////////////////////////////////////
	// ReactToThreat
	// 
	function ReactToThreat(
		SASPawn			aThreat,
		EStimulusType	aeDetectionStimulus,
		bool			abNoCallBackup )
	{
		UpdateThreatInfo( aThreat, aeDetectionStimulus );

		switch ( aeDetectionStimulus )
		{
		case STIMULUS_Sight:
		case STIMULUS_Bump:
			if ( Enemy == None )
			{
				SetEnemy( aThreat );
				GotoState( , 'BeginAttack' );
			}
			break;

		case STIMULUS_Damage:
		case STIMULUS_Noise:
			SetFocalPoint( aThreat.Location );
			break;

		default:
			Warn( "Unhandled stimulus type <"$aeDetectionStimulus$" in SteppingAside.ReactToThreat." );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// TargetLost
	// 
	event TargetLost()
	{
		local SASPawn	nextTarget;

		// Select best threat to target.
		nextTarget = SelectTargetEnemy();
		if ( nextTarget != None )
		{
			SetEnemy( nextTarget );
			Target = Enemy;
		}
		else
		{
			Enemy	= None;
			Target	= None;
			Focus	= None;
			GotoState( , 'Waiting' );
		}
	}


Begin:

	// Set stationary stance.
	mTerrorist.ChangeStanceImmediate( mTerrorist.mIdleHideStance );
	mTerrorist.ChangeAnimation();

Waiting:

	StopRepeatFiring();
	Stop;
	
BeginAttack:

	if ( Enemy == None )
	{
		Goto( 'Waiting' );
	}

	BeginBurstFireAt( Enemy );
}


///////////////////////////////////////////////////////////////////////////////
// STATE Patrolling
// 
state Patrolling extends MovingState
{
	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	// 
	function BeginState()
	{
		Super.BeginState();

		Enable( 'SeePlayer' );
		Enable( 'HearNoise' );

		Enemy = None;	
		StopRepeatFiring();
		mTerrorist.SetPace( PACE_Walking );
	}


	///////////////////////////////////////////////////////////////////////////////
	// GetNextPatrolPoint
	// 
	// If we do not currently have a patrol point then selects the nearest. Else
	// selects at random a point linked to the current patrol point.
	function GetNextPatrolPoint()
	{
		local SASPatrolPoint	pp, closest;
		local vector			vecToPt;
		local float				distSq, closestDistSq;

		if ( mTerrorist == None )
		{
			return;
		}

		// If we already have a patrol point, choose one that's linked to it.
		if ( mPatrolPoint != None )
		{
			pp = mPatrolPoint.OwnerGetNextPoint();
			if ( pp != None) 
			{
				AcquirePatrolPoint( pp );
			}
			else
			{
				RelinquishPatrolPoint();
			}
			//mPatrolPoint.OwnerGetNextPoint();
		}
		else
		{
			if ( mTerrorist.mPatrolPointTag != 'None' )
			{
				// Find the nearest patrol point to the pawn
				foreach AllActors ( class'SASPatrolPoint', pp, mTerrorist.mPatrolPointTag )
				{
					if ( pp.mOwner == None ) 
					{
						vecToPt = pp.Location - mTerrorist.Location;
						vecToPt.z = 0;
						distSq = VSizeSq( vecToPt );

						if ( (closest == None) || (distSq < closestDistSq) )
						{
							closest = pp;
							closestDistSq = distSq;
						}
					}
				}

				if ( closest != None )
				{
					AcquirePatrolPoint( closest );
					//closest.Take( self );
				}
			}
		}
	}


	///////////////////////////////////////////////////////////////////////////
	// DoPatrolPointReachedAction
	// 
	function DoPatrolPointReachedAction()
	{
		local float	idleTime;

		if ( mPatrolPoint.ReachedPlayScript() )
		{
			return;
		}

		idleTime = mPatrolPoint.ReachedGetIdleTime();
		if ( idleTime > 0.0 )
		{
			DoPatrolIdle( idleTime, mPatrolPoint.mIdleAnim );
		}
	}


Begin:

ChoosePatrolPoint:

	// Choose next patrol point.
	GetNextPatrolPoint();

MoveToPatrolPoint:

	if ( mPatrolPoint != None )
	{
		DoMoveToActor( mPatrolPoint, PACE_Walking );
	}
	else
	{
		// Wait a short while then see if we can move on later.
		DoPatrolIdle( 1.0 );
	}

MTP_FinishedMove:

	if ( mbFailedMoveToPoint )
	{
		Sleep( 0.5 );
		Goto( 'MoveToPatrolPoint' );
	}

	// Face desired direction
	if ( mPatrolPoint.mbFaceDirection )
	{
		SetFocus( mPatrolPoint );
		FinishRotation();
	}
	else
	{
		// Maintain current facing direction.
		FixCurrentFacing();
	}

	DoPatrolPointReachedAction();

	Goto( 'ChoosePatrolPoint' );
}


///////////////////////////////////////////////////////////////////////////////
// STATE AlertedNoEnemy
//
state AlertedNoEnemy extends MovingState
{
	ignores EnemyNotVisible;

	event BeginState()
	{
		Super.BeginState();

		Enable( 'SeePlayer' );
		Enable( 'HearNoise' );
	}

	event EndState()
	{
		Super.EndState();

		SetTimer( 0.0, false );
	}

	event Timer()
	{
		local float distSqToAlly;
	
		if ( mAlertedAlly == None )
		{
			CompleteMove();
		}
		else
		{
			distSqToAlly = VSizeSq( mTerrorist.Location - mAlertedAlly.Location );

			if ( distSqToAlly < 100.0 )
			{
				CompleteMove();
			}
		}
	}

	event bool NotifyObstructedDuringMove(
		SASPawn aObstructor )
	{
		// If blocked then stop.
		GotoState( , 'MTP_FinishedMove' );
		return true;
	}

	function bool NotifyGoalLocationIsBlocked(
		SASPawn aObstructor )
	{
		return NotifyObstructedDuringMove( aObstructor );
	}

Begin:

	SetTimer( 0.25, true );
	DoMoveToActor( mAlertedAlly );

MTP_FinishedMove:

	SetTimer( 0.0, false );
	if ( (mAlertedAlly != None)
		&& (mAlertedAlly.Controller != None)
		&& (mAlertedAlly.Controller.Focus != None) 
		&& (mAlertedAlly.Controller.Focus == mAlertedAlly.Controller.Enemy) )
	{
		SetFocus( mAlertedAlly.Controller.Enemy );
	}
	else
	{
		SetFocalPoint( mAlertedFocalPoint );
	}
}


///////////////////////////////////////////////////////////////////////////////
// STATE Surprised
//
state Surprised
{
	ignores EnemyNotVisible,
			ReactToAlertFriendly,
			CanInvestigate;

	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	// 
	event BeginState()
	{
		// Apply surprised accuracy modifier to pawn.
		mSASPawn.Surprised();
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndState
	// 
	event EndState()
	{
		mSASPawn.EndPlayActionAnim( 0.15 );
	}
		
Begin:

	StopMoving();

	mSASPawn.PlayFlinch();
	FinishAnim( ANIMCHANNEL_ACTION );

	if ( ShouldCallBackup( SASPawn( Enemy ) ) )
	{
		GotoState( 'CallBackup' );
	}
	else
	{
		EngageThreat( SASPawn( Enemy ) );
	}
}


///////////////////////////////////////////////////////////////////////////////
// STATE MovingToRallyPoint
//
state MovingToRallyPoint extends MovingState
{
	ignores CanInvestigate;

	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	//
	event BeginState()
	{
		Super.BeginState();

		// Ensure this timer is not running.
		StopMultiTimer( mTimerReassess );
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndState
	//
	event EndState()
	{
		Super.EndState();

		// Ensure this timer is not running.
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
			// Check if we have reached the rally point yet.
			if ( InRangeOfRallyPoint() )
			{
				GotoState( , 'TakeCover' );
			}
			break;

		default:
			Global.MultiTimer( aTimerIdx );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// InRangeOfRallyPoint
	//
	// Returns true if pawn is within horizontal and vertical range of the target
	// rally point.
	function bool InRangeOfRallyPoint()
	{
		local float	dist;

		// Check horizontal range.
		dist = VSizeHorizSq( Pawn.Location - mRallyPoint.Location );
		if ( dist > Square( mRallyPoint.CollisionRadius ) )
		{
			// Out of horizontal range.
			return false;
		}

		// In range horizontally. Are we on same floor level as point?
		dist = Pawn.Location.Z - mRallyPoint.Location.Z;
		if ( Abs( dist ) > (Pawn.Default.CollisionHeight + mRallyPoint.CollisionHeight) )
		{
			// Out of vertical range.
			return false;
		}

		return true;
	}


	///////////////////////////////////////////////////////////////////////////////
	// ReactToThreat
	// 
	function ReactToThreat(
		SASPawn			aThreat,
		EStimulusType	aeDetectionStimulus,
		bool			abNoCallBackup )
	{
		local float	threatRangeSq;

		switch ( aeDetectionStimulus )
		{
		case STIMULUS_Sight:
		case STIMULUS_Bump:
		case STIMULUS_Damage:
			// React to these stimuli as normal - switch to default attacking behaviour.
			Global.ReactToThreat( aThreat, aeDetectionStimulus, abNoCallBackup );
			break;

		case STIMULUS_Noise:
			// Only react to noises if we have LoS to threat and within range. And if that is 
			// the case then treat noise detection as a sighting.
			
			threatRangeSq = VSizeSq( Pawn.Location - aThreat.Location );

			if (	(threatRangeSq < Square( RALLYING_REACT_TO_THREAT_NOISE_RANGE )) && 
					CanSeePawn( aThreat ) )
			{
				Global.ReactToThreat( aThreat, STIMULUS_Sight, abNoCallBackup );
			}
			break;

		default:
			Warn( "Unrecognised stimulus type <"$aeDetectionStimulus$"> sent to MovingToRallyPoint.ReactToThreat fn." );
		}
	}

Begin:

	Enemy = None;
	StopMoving();

	// Avoid all terrorists which have been called to move at exactly the same time.
	Sleep( RandRange( 0.3, 0.8 ) );

	// If already in rally range then jump to finding a CP to take up.
	if ( InRangeOfRallyPoint() )
	{
		Goto( 'TakeCover' );
	}

	// Set timer to reassess if we have reached rally point range yet.
	SetMultiTimer( mTimerReassess, 0.5, true );

	DoMoveToActor( mRallyPoint );

MTP_FinishedMove:

	 if ( !InRangeOfRallyPoint() )
	 {
		 Sleep( 1.0 );
		 Goto( 'Begin' );
	 }

TakeCover:

	if ( SeekCoverInRadius(
			mRallyPoint.CollisionRadius,
			mRallyPoint.Location ) )
	{
		StartCoverIdle();
		Stop;
	}

	// _DI check can attack, else find cover in adjascent else idle.
	DoIdle();
}


///////////////////////////////////////////////////////////////////////////////
// STATE CallBackup
//
state CallBackup
{
	ignores EnemyNotVisible,
			ReactToAlertFriendly,
			CanInvestigate;

	///////////////////////////////////////////////////////////////////////////////
	// EndState
	// 
	event EndState()
	{
		mSASPawn.EndPlayActionAnim( 0.15 );
	}


	///////////////////////////////////////////////////////////////////////////////
	// FinishCallBackup
	// 
	function FinishCallBackup()
	{
		if ( !EngageThreat( SASPawn (Enemy) ) )
		{
			Enemy = None;
			// _DI shouldn't be needed - EngageThreat should always do something.
			DoIdle();
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// ReactToThreat
	// 
	event ReactToThreat(
		SASPawn			aThreat,
		EStimulusType	aeDetectionStimulus,
		bool			abNoCallBackup )
	{
		UpdateThreatInfo( aThreat, aeDetectionStimulus );
	}


	///////////////////////////////////////////////////////////////////////////////
	// DamageAttitudeTo
	// 
	// Break out of state if hit.
	function DamageAttitudeTo(
		Pawn	aOther,			// Pawn that damaged us (eg. Pawn that fired the weapon) 
		float	aDamage )		// Damage amount
	{
		Global.DamageAttitudeTo( aOther, aDamage );

		if ( aDamage > 0 )
		{
			FinishCallBackup();
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// CallBackupInRange
	// 
	function bool CallBackupInRange()
	{
		local bool						bAlliesInRange;
		local bool						bPlayCallAnim;
		local int						i;
		local float						distSq, closestDistSq;
		local SASTerrorist				other;
		local SASTerrorist				visibleAlly;
		local SASTerroristController	otherController;

		// Only randomly do this.
		if ( FRand() > 0.67 )
		{
			return false;
		}

		// Anim playing probability depends on distance to recently visible threats.
		bPlayCallAnim = true;
		for ( i = 0; i < mNumThreats; ++i )
		{
			if ( (mThreats[i].Pawn != None) && (mThreats[i].LastSeenTime > Level.TimeSeconds - 2.0) )
			{
				distSq = VSizeSq( mSASPawn.Location - mThreats[i].Pawn.Location );
				if ( distSq < Square( 400.0 ) )
				{
					bPlayCallAnim = false;
					break;
				}
			}
		}

		foreach mSASPawn.GetGame().RadiusSASPawns( 
			class'SASTerrorist', 
			other,
			mSASPawn.Location, 
			1000.0 )
		{
			otherController = SASTerroristController( other.Controller );

			if (	(otherController != None) &&
					(other != Pawn) && 
					(other.Health > 0) && 
					!other.mbIsIncapacitated &&
					(otherController.mbCanSee || otherController.mbCanHear) &&
					mSASPawn.IsFriendly( other ) )
			{
				bAlliesInRange = true;
				break;
			}
		}

		if ( !bAlliesInRange )
		{
			return false;
		}

		foreach mSASPawn.GetGame().RadiusSASPawns( 
			class'SASTerrorist', 
			other,
			mSASPawn.Location, 
			1000.0 )
		{
			otherController = SASTerroristController( other.Controller );

			// Alert all live terrorists in range.
			if (	(otherController != None) &&
					(other != Pawn) &&
					(other.Health > 0) &&
					!other.mbIsIncapacitated &&
					(otherController.mbCanSee || otherController.mbCanHear) )
			{
				otherController.AlertedToThreatByOther( self );

				// Signal to closest ally terrorist.
				if (	bPlayCallAnim && 
						mSASPawn.IsFriendly( other ) )
				{
					// Don't signal to allies very close.
					distSq = VSizeSq( mSASPawn.Location - other.Location );
					if (	distSq > Square( 375.0 ) &&
							mSASPawn.PawnIsVisible( other ) )
					{
						if ( (visibleAlly == None) || (distSq < closestDistSq) )
						{
							visibleAlly = other;
							closestDistSq = distSq;
						}
					}
				}
			}	
		}

		if ( visibleAlly != None )
		{
			return mTerrorist.PlayCallingAnim( visibleAlly );
		}

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
			return;
		}

		Pawn.AnimEnd( aChannel );
	}

Begin:

	mTerroristMgr.mLastCallForBackupTime = Level.TimeSeconds;

	// Play call backup sound.
	mTerrorist.PlaySpeech( SPEECH_TerrCallBackup );

	if ( CallBackupInRange() )
	{
		StopMoving();
		FinishAnim( ANIMCHANNEL_ACTION );
	}
	else
	{
		// Just engage the enemy after a reaction time.
		InitReaction( TERRREACT_EngageEnemy, SASPawn( Enemy ) );
	}

	FinishCallBackup();
}


///////////////////////////////////////////////////////////////////////////////
// STATE ChargeAtEnemyState
//
// Base state of AggressiveAttack and CoverCloseInFallback states.
state ChargeAtEnemyState extends MovingState
{
	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	// 
	event BeginState()
	{
		Super.BeginState();

		// Reset this - it's used for backing away from enemy in this state. 
		mStepAsidePoint = vect(0,0,0);

		// Stop timer responsible for backing away from enemy check. 
		MonitorSteppingBack( false );
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndState
	// 
	event EndState()
	{
		Super.EndState();

		// Stop timer responsible for backing away from enemy check. 
		MonitorSteppingBack( false );
	}


	///////////////////////////////////////////////////////////////////////////////
	// MultiTimer
	// 
	function MultiTimer(
		int	aTimerIdx )
	{
		switch ( aTimerIdx )
		{
		case mTimerReassess:
			if ( !CheckStepBackFromEnemy() )
			{
				SetMultiTimer( mTimerReassess, RandRange( 0.5, 0.75 ), false );
			}
			break;

		default:
			Global.MultiTimer( aTimerIdx );
			break;
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// MonitorSteppingBack
	// 
	function MonitorSteppingBack( 
		bool	abMonitor )
	{
		if ( abMonitor )
		{
			if ( mMultiTimers[mTimerReassess].Interval == 0.0 )
			{
				SetMultiTimer( mTimerReassess, RandRange( 0.5, 0.75 ), false );
			}
		}
		else
		{
			StopMultiTimer( mTimerReassess );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// CheckStepBackFromEnemy
	// 
	function bool CheckStepBackFromEnemy()
	{
		if ( TryingToFire() && mbHasLineOfFire && IsTooCloseToEnemy() )
		{
			mStepAsidePoint = SeekAggressiveMoveBackPoint();
			if ( mStepAsidePoint != vect(0,0,0) )
			{
				GotoState( , 'MoveBack' );
				return true;
			}
		}

		return false;
	}


	///////////////////////////////////////////////////////////////////////////////
	// IsTooCloseToEnemy
	// 
	function bool IsTooCloseToEnemy()
	{
		if ( Enemy == None )
		{
			return false;
		}

		if ( VSizeHorizSq( mTerrorist.Location - Enemy.Location ) < 
				Square( mTerrorist.CollisionRadius + Enemy.CollisionRadius + 32.0 ) )
		{
			return true;
		}

		return false;
	}


	///////////////////////////////////////////////////////////////////////////////
	// GetChargingFocus
	// 
	function Actor GetChargingDest()
	{
		if ( mFatalFunnelEP != None )
		{
			return mFatalFunnelEP;
		}

		return Enemy;
	}


	///////////////////////////////////////////////////////////////////////////////
	// GetMovingFocus
	// 
	function Actor GetMovingFocus()
	{
		if ( mFatalFunnelEP != None )
		{
			return mFatalFunnelEP;
		}

		return Enemy;
	}


	// Go here when decided to step back a bit from our target.
MoveBack:

	RelinquishCoverPoint();
	StopMultiTimer( mTimerReassess );
	DoMoveToPoint( mStepAsidePoint,,, GetMovingFocus() );
}


///////////////////////////////////////////////////////////////////////////////
// STATE AggressiveAttack
//
state AggressiveAttack extends ChargeAtEnemyState
{
	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	// 
	event BeginState()
	{
		Super.BeginState();

		// Stop timer.
		SetTimer( 0.0, false );

		// HACK. Need to free cover taken when reloading. Should be done via
		// SetCurrentObjective fn. with a cover reloading objective.
		RelinquishCoverPoint();

		// If aggressive percentage chance is zero then we are in this state as a fallback. 
		// Set timer to reassess correct behaviour.
		if ( (mTerrorist != None) && (mTerrorist.mAlertAggressivePct == 0.0) )
		{
			SetMultiTimer( mTimerAttacking, RandRange( 2.0, 3.0 ), true );
		}
		else
		{
			StopMultiTimer( mTimerAttacking );
		}

		// Activate timed threat assessment.
		StartPeriodicTargetSelection( TSF_High );
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndState
	// 
	event EndState()
	{
		Super.EndState();
				
		SetTimer( 0.0, false );
		StopRepeatFiring();

		StopMultiTimer( mTimerAttacking );
		mSASPawn.mInterestItem = None;

		// Deactivate timed threat reassessment.
		StopPeriodicTargetSelection();
	}


	///////////////////////////////////////////////////////////////////////////////
	// Timer
	// 
	event Timer()
	{
		// Retry to find an enemy/cover point to advance on.
		GotoState( , 'AdvanceOnEnemy' );
	}


	///////////////////////////////////////////////////////////////////////////////
	// MultiTimer
	// 
	event MultiTimer(
		int	aTimerIndex )
	{
		switch ( aTimerIndex )
		{
		case mTimerAttacking:
			// This timer used to reassess if we can switch to a preferred attacking
			// behaviour for this terrorist if should not really be in aggressive mode.
			if ( Enemy != None )
			{
				EngageThreat( SASPawn( Enemy ) ); 
			}
			break;

		default:
			Super.MultiTimer( aTimerIndex );
			break;
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// CheckGoStationary
	// 
	function CheckGoStationary()
	{
		// If moving and within aggressive stationary attack range then stop moving.
		// But not if we are moving to the step aside point (used here for backing away from enemy).
		if (	((mTerrorist.Velocity != vect(0,0,0)) || (mTerrorist.Acceleration != vect(0,0,0))) &&
				((mGoalActor != None) || (mGoalLocation == vect(0,0,0)) || (mGoalLocation != mStepAsidePoint)) &&
				InRangeOfChargingDest() )
		{
			GotoState( , 'StationaryAttack' );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// EnemyNotVisible
	// 
	event EnemyNotVisible()
	{
		// When not moving CP->CP should charge at enemy when not visible.
		if ( mCoverPoint == None )
		{
			if ( mFatalFunnelEP != None )
			{
				Disable( 'EnemyNotVisible' );
				GotoState( , 'ChargeAtEnemy' );
			}
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyWeaponFired
	//
	function NotifyWeaponFired()
	{
		Global.NotifyWeaponFired();

		// On firing weapon we know we've gota line of sight to the enemy, so if 
		// not moving to a CP should check if we are in stationary firing distance.
		if ( mCoverPoint == None )
		{
			CheckGoStationary();
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyLineOfFireAcquired
	//
	event NotifyLineOfFireAcquired()
	{
		// Check if we are in stationary firing range on aquiring LoF.
		if ( mCoverPoint == None )
		{
			CheckGoStationary();
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyLineOfFireBlocked
	// 
	event NotifyLineOfFireBlocked()
	{
		// If line of fire blocked when not at/moving to cover then charge at enemy 
		// until visible.
		if ( mCoverPoint == None )
		{
			StopRepeatFiring();
			GotoState( , 'ChargeAtEnemy' );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// ReactToThreat
	// 
	event ReactToThreat(
		SASPawn			aThreat,
		EStimulusType	aeDetectionStimulus,
		bool			abNoCallBackup )
	{
		UpdateThreatInfo( aThreat, aeDetectionStimulus );

		switch ( aeDetectionStimulus )
		{
		case STIMULUS_Sight:
		case STIMULUS_Bump:
			// Spotted enemy while not at or moving to a CP? 
			if ( (aThreat == Enemy) && (mCoverPoint == None) )
			{
				Enable( 'EnemyNotVisible' );

				// Make sure trying to fire.
				if ( mFatalFunnelEP == None )
				{
					SetFocus( Enemy );
				}
				BeginBurstFireAt( Enemy );
			} 
			break;

		case STIMULUS_Noise:
		case STIMULUS_Damage:
			// These will be handled if significant in the periodic target selction routine.
			break;

		default:
			Warn( "Unhandled stimulus type <"$aeDetectionStimulus$" in AggressiveAttack.ReactToThreat." );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// EnemyNotBestTarget
	// 
	event EnemyNotBestTarget(
		SASPawn	aBestTarget )
	{
		SetEnemy( aBestTarget );
		DoAggressiveAttack();
	}


	///////////////////////////////////////////////////////////////////////////////
	// TargetLost
	// 
	event TargetLost()
	{
		local Pawn	nextTarget;

		nextTarget = SelectTargetEnemy();
		if ( nextTarget != None )
		{
			SetEnemy( nextTarget );
			Target = Enemy;
			DoAggressiveAttack();
			mTerrorist.mInterestItem = Target;
		}
		else
		{
			if ( (Enemy != None) && mSASPawn.IsAThreat( Enemy ) )
			{
				DoAggressiveAttack();
				mTerrorist.mInterestItem = Target;
			}
			else
			{
				// _DI find cover else idle.
				Enemy = None;
				DoIdle();
				mTerrorist.mInterestItem = None;
			}
		} 
	}


	///////////////////////////////////////////////////////////////////////////////
	// DoReloading
	// 
	function DoReloading(
		optional bool bForceReload )
	{
		if ( SeekCoverInRadius( RELOADING_MIN_DIST_TO_THREAT ) )		// TODO: Change this - incorrect macro used!!! 
		{
			GotoState( 'CoverReloading' );
		}
		else
		{
			StopRepeatFiring();
			Pawn.Weapon.Reload();
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// WeaponReadyToFire
	// 
	function WeaponReadyToFire()
	{
		GotoState( , 'AdvanceOnEnemy' );
	}


	///////////////////////////////////////////////////////////////////////////////
	// ChooseNextCoverPoint
	// 
	function bool ChooseNextCoverPoint()
	{
		local SASCoverPoint	nextCP;

		// First choose which threat to target.
		SetEnemy( SelectTargetEnemy() );
		if ( Enemy == None )
		{
			return false;
		}

		nextCP = FindCoverPointToAdvanceOnEnemy( 500.0 );

		// Try to acquire chosen CP.
		if ( (nextCP != None) && AcquireCoverPoint( nextCP ) )
		{
			return true;
		}
		else
		{
			// Failed to acquire CP, need to charge at enemy. 
			RelinquishCoverPoint();
			return false;
		}		
	}


	///////////////////////////////////////////////////////////////////////////////
	// InRangeOfChargingDest
	// 
	function bool InRangeOfChargingDest()
	{
		local Actor	dest;

		dest = GetChargingDest();

		if (	(dest != None) && 
				(VSizeSq( dest.Location - mTerrorist.Location ) < Square( AGGRESSIVE_STATIONARY_RANGE )) )
		{
			return true;
		}

		return false;
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndFatalFunnelFiring
	// 
	event EndFatalFunnelFiring()
	{
		Global.EndFatalFunnelFiring();

		if ( mCoverPoint == None )
		{
			GotoState( , 'ChargeAtEnemy' );
		}
	}


Begin:

// Start here when trying to advance CP->CP toward enemy (not charging directly at).
AdvanceOnEnemy:

	mStepAsidePoint = vect(0,0,0);

	FocusOnEnemy();

	// Make sure firing.
	BeginBurstFireAt( Enemy );

	// Find cover point to move toward to advance on enemy.
	if ( ChooseNextCoverPoint() )
	{
		// Turn off timer which is used to retry to find cover when currently don't have any.
		SetTimer( 0.0, false );

		MonitorSteppingBack( false );

		// Move to new CP.
		DoMoveToActor( mCoverPoint,,, GetMovingFocus() );
	}
	else
	{
		Goto( 'CheckChargeAtEnemy' );
	}

	Stop;

CheckChargeAtEnemy:

	// Check if already in range of charging dest before proceeding.
	if ( InRangeOfChargingDest() )
	{
		Goto( 'StationaryAttack' );
	}

// Start here when charging directly at enemy (not CP->CP advance).
ChargeAtEnemy:

	// Failed to find cover. Set timer to seek again later.
	SetTimer( 5.0, false );

	MonitorSteppingBack( true );

	DoMoveToActor( GetChargingDest(),,, GetMovingFocus() );

MTP_FinishedMove:

	mStepAsidePoint = vect(0,0,0);

	if ( (mCoverPoint != None) && mSASPawn.ReachedDestination( mCoverPoint, true ) )
	{
		if ( mTerrorist.PlayStanceTransitionAnim( mCoverPoint.meFireStance, true ) )
		{
			mTerrorist.ChangeStanceImmediate( mCoverPoint.meFireStance );
			FinishAnim( ANIMCHANNEL_ACTION );
			mTerrorist.ChangeAnimation();
		}
		else
		{
			mTerrorist.ChangeStanceImmediate( mCoverPoint.meFireStance );
		}
		Sleep( RandRange( 0.8, 1.2 ) );

		// Try to move further in on enemy.
		Goto( 'AdvanceOnEnemy' );
	}
	else
	{
		if ( mCoverPoint == None )
		{
			MonitorSteppingBack( true );
			SetTimer( 5.0, false );
		}
		else
		{
			// Not at cover, set timer to re-seek suitable cover to advance on enemy.
			SetTimer( 0.5, false );
		}
	}

	Stop;

StationaryAttack:

	mStepAsidePoint = vect(0,0,0);
	StopMoving();
	MonitorSteppingBack( true );

	FocusOnEnemy();
	BeginBurstFireAt( Enemy );
}


///////////////////////////////////////////////////////////////////////////////
// STATE CoverReloading
//
// Temp state for terrorists in aggressive mode to take cover on reloading.
// Will not be needed when aggressive attack is updated to move between cover
// positions anyway.
state CoverReloading extends AggressiveAttack
{
	ignores DamageAttitudeTo,
			ReactToAlertFriendly,
			CanInvestigate;

	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	//
	event BeginState()
	{
		Enable( 'SeePlayer' );
		Disable( 'EnemyNotVisible' );
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndState
	//
	event EndState()
	{
		SetTimer( 0.0, false );
	}


	///////////////////////////////////////////////////////////////////////////////
	// ReactToThreat
	//
	function ReactToThreat( 
		SASPawn			aThreat,
		EStimulusType	aeDetectionStimulus,
		bool			abNoCallBackup )
	{
		UpdateThreatInfo( aThreat, aeDetectionStimulus );
	}


	///////////////////////////////////////////////////////////////////////////////
	// EnemyNotVisible
	//
	event EnemyNotVisible()
	{
		SetFocalPoint( LastSeenPos );
	}


	///////////////////////////////////////////////////////////////////////////////
	// WeaponReadyToFire
	//
	function WeaponReadyToFire()
	{
		local Pawn newEnemy;

		newEnemy = SelectTargetEnemy();
		if ( newEnemy != None )
		{
			SetEnemy( newEnemy );
			StartAggressiveAttack( false );
		}
	}

	event bool NotifyObstructedDuringMove(
		SASPawn aObstructor )
	{
		// If blocked then stop and reload immediately.
		GotoState( , 'MTP_FinishedMove' );
		return true;
	}

	function bool NotifyGoalLocationIsBlocked(
		SASPawn aObstructor )
	{
		return NotifyObstructedDuringMove( aObstructor );
	}

Begin:

	DoMoveToActor( mCoverPoint );

MTP_FinishedMove:

	if ( (Enemy != None ) && CanSeePawn( SASPawn( Enemy ) ) )
	{
		SetFocus( Enemy );
	}
	else
	{
		SetFocalPoint( LastSeenPos );
	}

	Enable( 'EnemyNotVisible' );

	StopMoving();
	if ( Pawn.Weapon != None )
	{
		Pawn.Weapon.Reload();
	}	
}


///////////////////////////////////////////////////////////////////////////////
// STATE CoverState
//
// Base state for all cover sub-states.
state CoverState extends MovingState
{
	///////////////////////////////////////////////////////////////////////////////
	// ReactToThreat
	//
	function ReactToThreat( 
		SASPawn			aThreat,
		EStimulusType	aeDetectionStimulus,
		bool			abNoCallBackup )
	{
		local bool	bExposedToThreat;

		UpdateThreatInfo( aThreat, aeDetectionStimulus );

		switch ( aeDetectionStimulus )
		{
		case STIMULUS_Sight:
			bExposedToThreat = CoverPointExposedTo( aThreat );

			if ( bExposedToThreat )
			{
				ChooseCoverExposedReaction( aThreat );
			}
			else if ( Enemy == None )
			{
				SetEnemy( aThreat );
			}

			if ( aThreat == Enemy )
			{
				// If waiting at cover (and not doing spinout attack) then face our target.
				if ( (mCoverPoint != None) && mSASPawn.ReachedDestination( mCoverPoint )  )
				{
					if ( (GetStateName() == 'CoverWaiting') && !mbUseSpinoutAttack )
					{
						if ( mFatalFunnelEP == None )
						{
							SetFocus( Enemy );
						}
					}
				}
			}
			break;

		case STIMULUS_Noise:
			// If can see then react appropriately (same as a sighting).

			break;

		default:
			break;
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// ChooseCoverExposedReaction
	//
	function ChooseCoverExposedReaction(
		SASPawn	aThreat )
	{
		local bool bCanSurender;

		if ( mTerrorist.mSurrenderWhenCorneredChance > 0.0 )
		{
			if ( FRand() < mTerrorist.mSurrenderWhenCorneredChance )
			{
				bCanSurender = true;
			}

			// Only have one chance to surrender.
			mTerrorist.mSurrenderWhenCorneredChance = 0.0;
					
			if ( bCanSurender && CheckSurrenderCriteria() )
			{
				// Only surrender if alternate cover not available.
				if (	(mCoverReachedTime != -1.0) &&
						(Level.TimeSeconds > (mCoverReachedTime + mTerrorist.mMinTimeAtCoverPoint)) &&
						SeekCoverInAssaultVolume( false,, GetMaxCoverDist(),, COVERSELECT_CoveredFromAll ) )
				{
					DoCoverAttack();
					return;
				}
				
				// Only surrender if we are in a suitable location for going prone. 
				// Else a following ordered down/captured anim will look bad. 
				if ( FindDirectionToGoProne() )
				{
					DoSurrender();
					return;
				}
			}
		}


		// If don't currently have a target, this threat is our target or not exposed to 
		// our current target then make this threat our target.
		if (	(mCoverReachedTime != -1.0) &&
				((Enemy == None) || (aThreat == Enemy) || !CoverPointExposedTo( SASPawn( Enemy ) )) )
		{
			if ( aThreat != Enemy )
			{
				SetEnemy( aThreat );
			}

			// Don't react yet if reloading.
			if ( mTerrorist.Weapon.NeedsToReload() )
			{
				return;
			}

			// Try to seek better cover if spent min time at this CP. 
			if ( Level.TimeSeconds > (mCoverReachedTime + mTerrorist.mMinTimeAtCoverPoint) )
			{
				if ( SeekCoverInAssaultVolume( false,, GetMaxCoverDist(),, COVERSELECT_CoveredFromAll ) )
				{
					DoCoverAttack();
				}
				else
				{
					// Failed to find new CP, just defend this one.
					if ( !IsInState( 'CoverAttackingExposed' ) )
					{
						GotoState( 'CoverAttackingExposed' );
					}
				}
			}
			else
			{
				// Have not spent min time at this CP, defend it.
				if ( GetStateName() != 'CoverAttackingExposed' )
				{
					GotoState( 'CoverAttackingExposed' );
				}
			}
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// MultiTimer
	//
	event MultiTimer(
		int	aTimerIdx )
	{
		Global.MultiTimer( aTimerIdx );
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyLineOfFireBlocked
	//
	event NotifyLineOfFireBlocked()
	{
		// Have I seen enemy in the max sighting test interval?
		if ( LastSeenTime < (Level.TimeSeconds - AIFIGHTER_SIGHT_THREAT_INTERVAL_MAX) )
		{
			// Can't currently see enemy. 

			// Stay at cover if its good or for a short time after last seeing enemy.
			if (	//(mCoverPoint.meCoverSetting > COVER_Low) ||
					(LastSeenTime > (Level.TimeSeconds - (AIFIGHTER_SIGHT_THREAT_INTERVAL_MAX + 3.0))) )
			{
				return;
			}
		}

		// If crouched, try to stand to gain LoF. (Not if at spinout point or using undisciplined firing).
		if (	(mTerrorist.meStance == STANCE_Crouched) && 
				!mbUseSpinoutAttack &&
				(mTerrorist.mFiringPose == FIRINGPOSE_Normal) )
		{
			mTryStandingCoverAttackStartTime = Level.TimeSeconds;
			GotoState( , 'TryStandingLineOfFire' );
		}
		else if ( mTryStandingCoverAttackStartTime > Level.TimeSeconds - 1.2 )
		{
			return;
		}
		// Else seek different cover.
		else if ( SeekCoverInAssaultVolume( false,, GetMaxCoverDist(),, COVERSELECT_CoveredFromEnemy ) )
		{
			DoCoverAttack();
		}
		// Else move in on target.
		else
		{	
			DoCoverCloseInFallback();
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// DoReloading
	// 
	// Called when our current weapon needs reloading. Respond by returning to
	// cover.
	function DoReloading(
		optional bool abForceReload )
	{
		GotoState( 'MovingToCover', 'Begin' );
	}


	///////////////////////////////////////////////////////////////////////////////
	// GroupPermissionToChangeCover
	//
	// Event received when group says terrorist can move to new cover.
	// Returns true if move to new cover takes place.
	event bool GroupPermissionToChangeCover()
	{
		Global.GroupPermissionToChangeCover();

		// Don't move if reloading.
		if ( mTerrorist.Weapon.NeedsToReload() )
		{
			return false;
		}

		// Seek different cover.
		if ( SeekCoverInAssaultVolume( false, 150.0, GetMaxCoverDist() ) )
		{
			DoCoverAttack();
			return true;
		}

		return false;
	}


	///////////////////////////////////////////////////////////////////////////////
	// GroupRequestProvideBackupFireFor
	//
	event bool GroupRequestProvideBackupFireFor(
		SASTerroristController	aOther )
	{
		mProvidingBackupFor = aOther;
		return true;
	}


TryStandingLineOfFire:

	Warn( "Error: CoverState.TryStandingLineOfFire label reached - should only call inherited state versions." );
}


///////////////////////////////////////////////////////////////////////////////
// STATE MovingToCover
//
state MovingToCover extends CoverState
{
	ignores ReactToAlertFriendly;

	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	// 
	event BeginState()
	{
		Super.BeginState();

		// Must have chosen cover point to move to before enterring state
		if ( mCoverPoint == None )
		{
			Warn( "SASTerrorist <"$Pawn$"> in MovingToCover state without a cover point. Switching to aggressive mode." );
			StartAggressiveAttack( false );
		}

		// Tell group we are moving to new cover.
		if ( mGroup != None && (mCoverReachedTime == -1.0) )
		{
			mGroup.SendMessage( self, TGMSG_Moving );
		}

		// Activate timed threat assessment at medium frequency.
		StartPeriodicTargetSelection( TSF_Med );
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndState
	// 
	event EndState()
	{
		Super.EndState();

		// Deactivate timed threat reassessment.
		StopPeriodicTargetSelection();
	}


	///////////////////////////////////////////////////////////////////////////////
	// EnemyNotBestTarget
	// 
	event EnemyNotBestTarget(
		SASPawn	aBestTarget )
	{
		SetEnemy( aBestTarget );
		BeginBurstFireAt( Enemy );
	}


	///////////////////////////////////////////////////////////////////////////////
	// MultiTimer
	// 
	/*event MultiTimer(
		int	aTimerIdx )
	{
		switch ( aTimerIdx )
		{
		case mTimerReassess:
			// Check current CP validity.
			ReassessGoalCoverPoint();
			break;

		default:
			Super.MultiTimer( aTimerIdx );
			break;
		}
	}*/


	///////////////////////////////////////////////////////////////////////////////
	// ReassessGoalCoverPoint
	// 
/*	function ReassessGoalCoverPoint()
	{
		// Do what "move from current cover test does"

		local SASCoverPoint	oldCP;

		oldCP = mCoverPoint;

		GetCoverInAss(
			FMax(getcoverdist, disttocurrcover),
			COVER_Low,
			
	}*/

	
	///////////////////////////////////////////////////////////////////////////////
	// ChooseMovePace
	// 
	// Choose the pace to use to move to the coverpoint.
	function ESASPace ChooseMovePace()
	{
		local float	distSq;

		// TODO: Use path dist.
		distSq = VSizeSq( Pawn.Location - mCoverPoint.Location );
		if ( distSq > Square( 250.0 ) )
		{
			return PACE_Charging;
		}

		return PACE_Running;
	}


	///////////////////////////////////////////////////////////////////////////////
	// TargetLost
	// 
	// Lost the taregt was trying to fire at.
	event TargetLost()
	{
		local SASPawn	nextEnemy;

		nextEnemy = SelectTargetEnemy( true );
		if ( nextEnemy != None )
		{
			SetEnemy( nextEnemy );
			Target = Enemy;
			mTerrorist.mInterestItem = Target;
		}
		else
		{
			Pawn.SetPace( ChooseMovePace() );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyLineOfFireBlocked
	// 
	// Event received when line of fire to current target has been blocked for
	// longer than MAX_BLOCKED_LOF_TIME.
	event NotifyLineOfFireBlocked()
	{
		Enemy = None;
		Target = None;
		StopRepeatFiring();

		Pawn.SetPace( ChooseMovePace() );
	}


	///////////////////////////////////////////////////////////////////////////////
	// ReactToThreat
	//
	function ReactToThreat( 
		SASPawn			aThreat,
		EStimulusType	aeDetectionStimulus,
		bool			abNoCallBackup )
	{
		UpdateThreatInfo( aThreat, aeDetectionStimulus );

		// Don't select threat as enemy if already have an enemy or fatal funnel is still active.
		if ( (Enemy != None) || (mFatalFunnelEP != None) )
		{
			return;
		}

		switch( aeDetectionStimulus )
		{
		case STIMULUS_Sight:
		case STIMULUS_Bump:
			SetEnemy( aThreat );
			BeginBurstFireAt( Enemy );
			break;

		case STIMULUS_Noise:
		case STIMULUS_Damage:
			if ( CanSeePawn( aThreat, true ) )
			{
				SetEnemy( aThreat );
				BeginBurstFireAt( Enemy );
			}
			break;

		default:
			Warn( "Unhandled stimulus type <"$aeDetectionStimulus$" in MovingToCover.ReactToThreat." );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// DoReloading
	// 
	// Called when our current weapon needs reloading.
	function DoReloading(
		optional bool abForceReload )
	{
		// Call global version to avoid calling CoverState version which is used
		// to start a return to cover action.
		Global.DoReloading( abForceReload );
	}

	
	///////////////////////////////////////////////////////////////////////////////
	// WeaponReadyToFire
	// 
	function WeaponReadyToFire()
	{
		local SASPawn	newEnemy;

		newEnemy = SelectTargetEnemy( true );
		if ( newEnemy != None )
		{
			SetEnemy( newEnemy );
			BeginBurstFireAt( Enemy );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// ChooseMoveStance
	// 
	// Choose the stance to use to move to the coverpoint. If currently crouching 
	// and CP is a crouch point and nearby then stay in crouched stance. 
	function ESASStance	ChooseMoveStance()
	{
		local float	distSq;

		// If crouching and cover point stance is crouching and within crouch movement range
		// of point then do crouch movement.
		if ( (Pawn.meStance == STANCE_Crouched) && (mCoverPoint.meStance == STANCE_Crouched) )
		{
			// GPTODO: What if path distance is much larger than direct dist? Rather an expensive check
			// to get the path dist. Maybe can get away with assuming the path dist is small if we are
			// in the same AV as the coverpoint.
			// GP: Further thoughts: Could make this decision later after the path has been calculated for 
			// the move at which point the route distance is available. Would need additional boolean 
			// parameter to DoMoveToActor to specify if should try crouched move  if possible.

			distSq = VSizeSq( Pawn.Location - mCoverPoint.Location );
			if ( distSq < Square( 100.0f ) )
			{
				return STANCE_Crouched;
			}
		}

		return STANCE_Standing;
	}


	///////////////////////////////////////////////////////////////////////////////
	// ReachedCover
	// 
	function ReachedCover()
	{
		if ( mCoverReachedTime == -1.0 )
		{
			mCoverDesiredMoveTime = 
				RandRange( mTerrorist.mCoverMoveTime.Min, mTerrorist.mCoverMoveTime.Max ); 
		}

		Global.ReachedCover();	
	}


	///////////////////////////////////////////////////////////////////////////////
	// GetMovingFocalPoint
	// 
	function Vector GetMovingFocalPoint()
	{
		if ( mCoverReachedTime == -1.0 )
		{
			// Have yet to initially reach the CP, return zero vector. 
			return vect(0,0,0);
		}
		else 
		{
			CheckUseSpinoutAttack();
			if ( mbUseSpinoutAttack )
			{
				// For spinout points face backward.
				return -mCoverPoint.mDirection2D;
			}
		}
		
		// Face CP direction.
		return mCoverPoint.mDirection2D;
	}


Begin:

	if ( Pawn.ReachedDestination( mCoverPoint, true ) )
	{
		Goto( 'ReachedCover' );
	}

	// Try to burst fire while moving. 
	if ( (mCoverReachedTime == -1.0) && (Enemy != None) )
	{
		BeginBurstFireAt( Enemy );
	}

	DoMoveToActor( 
		mCoverPoint, 
		ChooseMovePace(), 
		ChooseMoveStance(),
		,
		GetMovingFocalPoint() );

MTP_FinishedMove:

	if ( !Pawn.ReachedDestination( mCoverPoint, true ) )
	{
		// Can't move to cover for some reason, switch to aggressive attack.
		Warn( "SASTerrorist in MovingToCover state couldnt get to cover point. Switching to aggressive mode." );
		Sleep( 0.0 );
		StartAggressiveAttack( false );
		Stop;
	}

ReachedCover:

	GotoState( 'CoverWaiting' );
}


///////////////////////////////////////////////////////////////////////////////
// STATE CoverWaiting
//
state CoverWaiting extends CoverState
{
	ignores ReactToAlertFriendly;

	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	// 
	event BeginState()
	{
		Super.BeginState();

		// Stop all timers used in this state.
		SetTimer( 0.0, false );
		StopMultiTimer( mTimerAttacking );
		StopMultiTimer( mTimerReassess );
			
		// Must have chosen cover point to move to before enterring state
		if ( mCoverPoint == None )
		{
			Warn( "SASTerrorist in CoverWaiting state without a cover point. Switching to aggressive mode." );
			StartAggressiveAttack( false );
		}

		// Check we've actually reached our CP.
		// GP: 	mCoverReachedTime sometimes isn't getting set even when reaching cover - needs investigating.
		/*if ( mCoverReachedTime == -1.0f )
		{
			GotoState( 'MovingToCover' );
		}*/

		// If at a spinout point then should check if can use it as one. Can't do so if threats are too
		// close unless we are already lined up for an attack.
		CheckUseSpinoutAttack();

		Enable( 'SeePlayer' );

		// Don't need to see enemy if attacking from a spinout point or using 
		// undisciplined fire mode.
		if (	mbUseSpinoutAttack || 
				mCoverPoint.mbCanFireRoundCover || 
				mCoverPoint.mbCanFireOverCover )
		{
			Disable( 'EnemyNotVisible' );
		}
		else
		{
			Enable( 'EnemyNotVisible' );
		}

		if ( mbUseSpinoutAttack )
		{
			mSASPawn.bIgnoreSpine = true;
		}
	
		// Shouldn't have a target grenade point on enterring state.
		mGrenadePoint = None;

		// Reset cover position adjustment data.
		mbCheckCoverSightedResponse = true;
		mCoverAdjustIncrement = 0;
		mbReachedCoverAdjustPoint = false;

		SetMultiTimer( mTimerSpeech, RandRange( 5.0, 14.0 ), false );
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndState
	// 
	event EndState()
	{
		Super.EndState();

		// Turn off timers that have been used in this state.
		SetTimer( 0.0, false );
		StopMultiTimer( mTimerReassess );
		StopMultiTimer( mTimerAttacking );
		StopMultiTimer( mTimerSpeech );

		// Reenable spine rotation if switched of (on spinout points).
		if ( mSASPawn != None )
		{
			mSASPawn.bIgnoreSpine = false;
		}

		mbCheckCoverSightedResponse = false;
	}


	///////////////////////////////////////////////////////////////////////////////
	// DoCoverPositionAdjust
	// 
	event DoCoverPositionAdjust()
	{
		if ( mbCanCoverPosAdjust )
		{
			GotoState( , 'AdjustPos' );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// CheckThrowGrenade
	// 
	// Check if should attack by throwing grenade.
	function bool CheckThrowGrenade()
	{
		mGrenadePoint = QueryThrowGrenadeFromCover();
		if ( mGrenadePoint != None )
		{
			GotoState( 'MovingToGrenadeThrowLocation' );
			return true;
		}

		return false;
	}


	///////////////////////////////////////////////////////////////////////////////
	// SelectEnemyAndAttack
	// 
	function bool SelectEnemyAndAttack()
	{
		local Pawn				newEnemy;
		local EFirePosAdjust	eSelectedFPA;
		local int				selectedFiringPose;

		// Select an enemy to attack and fire point to attack from
		newEnemy = SelectEnemyWhileHidingAtCover( eSelectedFPA, selectedFiringPose );
		if ( newEnemy != None )
		{
			SetEnemy( newEnemy ); 
			meCoverFireOffset = eSelectedFPA;
			mSASPawn.SetFiringPose( selectedFiringPose );

			if ( (selectedFiringPose & FIRINGPOSE_Spinout) != 0x0 )
			{
				GotoState( 'CoverAttackingSpinout' );
			}
			else
			{
				GotoState( 'CoverAttackingNormal' );
			}
			return true;
		}
		
		return false;
	}


	///////////////////////////////////////////////////////////////////////////////
	// BeginCoverAttacking
	// 
	// Choose to throw grenade or start firing at an enemy.
	event BeginCoverAttacking()
	{	
		// Should throw grenade?
		if ( !CheckThrowGrenade() )
		{
			if ( IsHoldingGun() )
			{
				// Try to select ana enemy to attack.
				SelectEnemyAndAttack();
			}
			else if ( !PendingWeaponIsGun() )
			{
				// Not holding gun, if one's not in process of being selected then select now. 
				SwitchToBestWeapon();
			}
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyHitWall
	// 
	// Used to detect when to stop moving when adjusting hide position. 
	event bool NotifyHitWall(
		Vector	aHitNormal, 
		Actor	aWall )
	{
		StopMoving();
		mbReachedCoverAdjustPoint = true;

		return false;
	}


	///////////////////////////////////////////////////////////////////////////////
	// Timer
	// 
	event Timer()
	{
		// Timeout this state to cover idle if not attacked for a while.
		DoCoverIdle();
	}

	///////////////////////////////////////////////////////////////////////////////
	// MultiTimer
	// 
	event MultiTimer(
		int	aTimerIdx )
	{
		local int i;
		local bool bSeenThreat;
			
		switch ( aTimerIdx )
		{
		case mTimerReassess:

			// Hack, hack hack.
			// Should remove this 'advancing' stuff.
			if ( (mNumThreats > 0) && (SASStickyCoverPoint( mCoverPoint ) == None) )
			{
				for ( i = 0; i < mNumThreats; ++i )
				{
					if ( mThreats[i].Pawn != None && mThreats[i].FirstSeenTime > 0.0 )
					{
						bSeenThreat = true;
						break;
					}
				}

				if ( bSeenThreat )
				{
					DoAdvanceToCloserCover();
				}
			}
			break;

		case mTimerAttacking:
			// Check if should start attacking.
			if ( PollShouldBeginAttackFromCover() )
			{
				BeginCoverAttacking();
			}
			// Else check if should try to move.
			// TODO: Check for better cover nearby, not just any cover nearby.
			else if (	PollShouldMoveToNewCover() && 
						SeekCoverInAssaultVolume( false, 150.0, GetMaxCoverDist(), COVER_Medium ) )
			{
				DoCoverAttack();
			}
			else
			{
				// If in spinout mode then check it's still valid.
				if ( mbUseSpinoutAttack )
				{
					CheckUseSpinoutAttack();
					if ( !mbUseSpinoutAttack )
					{
						mSASPawn.bIgnoreSpine = false;

						if ( Enemy != None )
						{
							// Face target enemy/fatal funnel
							FocusOnEnemy();
						}
						else
						{
							// Face CP direction.
							SetFocalPointFromDir( mCoverPoint.mDirection2D );
						}
					}
				}

				// Radomize the timer interval so that the order in which terrorists receive
				// this event will vary.
				SetMultiTimer( mTimerAttacking, RandRange( 0.25, 0.35 ), true );
			}
			break;

		case mTimerSpeech:
			// Check for playing general 'attacking from cover' speech.
			if ( CheckPlayWaitingAtCoverSpeech() )
			{
				mTerrorist.PlaySpeech( SPEECH_TerrCoverSeenThreat );
				SetMultiTimer( mTimerSpeech, RandRange( 10.0, 14.0 ), false );	
			}
			else
			{
				SetMultiTimer( mTimerSpeech, RandRange( 5.0, 14.0 ), false );
			}
			break;

		default:
			Super.MultiTimer( aTimerIdx );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// GroupRequestProvideBackupFireFor
	//
	event bool GroupRequestProvideBackupFireFor(
		SASTerroristController	aOther )
	{
		Super.GroupRequestProvideBackupFireFor( aOther );

		// Try to begin attack immediately
		BeginCoverAttacking();

		return true;
	}


	///////////////////////////////////////////////////////////////////////////////
	// EnemyNotVisible
	// 
	event EnemyNotVisible()
	{
		if ( mFatalFunnelEP == None )
		{
			SetFocalPoint( LastSeenPos );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// DamageAttitudeTo
	// 
	// Called on taking damage to instigate a response.
	function DamageAttitudeTo(
		Pawn	aOther,			// Pawn that damaged us (eg. Pawn that fired the weapon) 
		float	aDamage )		// Damage amount
	{
		local SASPawn			otherSASPawn;
		local EFirePosAdjust	eSelectedFPA;
		local int				selectedFiringPose;

		Super(SASFighterController).DamageAttitudeTo( aOther, aDamage );

		// If damager pawn is an enemy then set it as our next target and 
		// wait for a reaction time before responding.
		// TODO: Response due to friendly fire.
		otherSASPawn = SASPawn( aOther );
		if ( (aDamage > 0) && (otherSASPawn != None) && mSASPawn.IsAThreat( otherSASPawn ) )
		{
			UpdateThreatInfo( otherSASPawn, STIMULUS_Damage );
		
			if ( CanAttackFromCover( otherSASPawn, eSelectedFPA, selectedFiringPose ) )
			{
				SetEnemy( aOther );
				meCoverFireOffset = eSelectedFPA;
				mSASPawn.SetFiringPose( selectedFiringPose );
				GotoState( 'CoverAttackingNormal' );
			}
			else
			{
				// HACK - need global reassess function which works from all states

				// Try to find new cover
				if ( SeekCoverInAssaultVolume( false, 150.0, GetMaxCoverDist() ) )
				{
					DoCoverAttack();
				}
				else
				{
					// Failed, go aggressive.

					// HACK: Give me a small aggressive pct chance - this will stop the 
					// terrorist trying to stop going aggressive and seeking cover again.
					if ( mTerrorist.mAlertAggressivePct == 0.0 )
					{
						mTerrorist.mAlertAggressivePct = 0.001;
					}
					StartAggressiveAttack( true );
				}
			}
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// WeaponReadyToFire
	// 
	function WeaponReadyToFire()
	{
		// If exposed and can see an enemy then start attacking as soon as weapon ready.
		CheckIfExposed();
	}


	///////////////////////////////////////////////////////////////////////////////
	// DoCoverPointReachedAction
	// 
	function DoCoverPointReachedAction()
	{
		mCoverPoint.ReachedPlayScript();
	}


	///////////////////////////////////////////////////////////////////////////////
	// CheckIfExposed
	// 
	function CheckIfExposed()
	{
		local Pawn	newEnemy;

		if ( CoverPointExposedToAnyThreats( true ) )
		{
			newEnemy = SelectTargetEnemy( true );
			if ( newEnemy != None )
			{
				SetEnemy( newEnemy );
				GotoState( 'CoverAttackingExposed' );
			}
		}
	}


Begin:

	Target = None;
	mCoverWaitingStartTime	= Level.TimeSeconds;

	// Don't allow cover position adjustment until ready.
	mbCanCoverPosAdjust = false;

	// If ready to fire and exposed then defend CP immediately.
	if ( IsHoldingGun() && !Pawn.Weapon.NeedsToReload() )
	{
		// This will move into defending state if exposed on enterring this state. 
		CheckIfExposed();

		// If not already attacked and not at a spinout point then try to attack immediately.
		if ( !mbAttackedFromCover && !mbUseSpinoutAttack )
		{
			BeginCoverAttacking();
		}
	}

	// Do a stance transition if required.
	if ( mTerrorist.meStance != mCoverPoint.meStance )
	{
		DoStanceTransition( mCoverPoint.meStance, GetStateName(), 'Hiding', 1.5 );
	}

Hiding:

	// Go into cover point stance
	mTerrorist.ChangeStanceImmediate( mCoverPoint.meStance );

	// Set time before moving from cover if we fail to attack.
	SetMultiTimer( mTimerReassess, RandRange( 7.0, 10.0 ), true );

	// Set timer to go idle again if fail to attack.
	SetTimer( 15.0, false );
	
	if ( mbUseSpinoutAttack && !CoverPointExposedToAnyThreats() )
	{
		// Back to CP direction.
		SetFocalPointFromDir( -mCoverPoint.mDirection2D );
	}
	else if ( Enemy != None )
	{
		// Face target enemy/fatal funnel
		FocusOnEnemy();
	}
	else
	{
		// Face CP direction.
		SetFocalPointFromDir( mCoverPoint.mDirection2D );
	}

	if ( NeedToTurnToFace( FocalPoint ) )
	{
		FinishRotation();
	}

	if ( !IsHoldingGun() )
	{
		SwitchToBestWeapon();
	}
	else
	{
		// Reload weapon if needed. Wait for reloaded event before trying to fight again.
		if ( (Pawn.Weapon != None) && 
			(Pawn.Weapon.NeedsToReload() || ShouldDiscardClip()) )
		{
			Pawn.Weapon.Reload();
		}
		else
		{
			if ( mCoverPoint.meCoverSetting == COVER_None )
			{
				BeginCoverAttacking();
			}
		}
	}

	// Set time before next attack
	// TODO: Next attack depends on:
	// 1) Pawns cover aggression level
	// 2) Whether being fired at
	//		a) Return fire if cp coverage is low
	//		b) Wait longer before returning fire if cp coverage is high
	SetMultiTimer( mTimerAttacking, RandRange( 0.25, 0.35 ), true );

	// Can now CP pos adjust.
	mbCanCoverPosAdjust = true;

	Stop;

AdjustPos:

	mbReachedCoverAdjustPoint = false;
	MoveTo( mCoverPoint.GetCoverAdjustPos( mCoverAdjustIncrement ), Focus, FocalPoint,, true );
	StopMoving();
	mbReachedCoverAdjustPoint = true;
}


///////////////////////////////////////////////////////////////////////////////
// STATE MovingToGrenadeThrowLocation
//
state MovingToGrenadeThrowLocation extends MovingState
{
	event BeginState()
	{
		Super.BeginState();

		if ( mGrenadePoint == None )
		{
			GotoState( 'MovingToCover' );
		}

		mbAttackedFromCover = true;
	}

Begin:

	mSASPawn.SelectGrenadeWeapon( GRENADECAT_Explosive );

MoveToFireOffset:

	meCoverFireOffset = ChooseRandomCoverFireOffset();
	switch ( meCoverFireOffset )
	{
	case FPA_Centre:
		
		if ( mSASPawn.PlayStanceTransitionAnim( mCoverPoint.meFireStance, true ) )
		{
			mTerrorist.ChangeStanceImmediate( mCoverPoint.meFireStance );
			FinishAnim( ANIMCHANNEL_ACTION );
			mTerrorist.ChangeAnimation();
		}
		else
		{
			mTerrorist.ChangeStanceImmediate( mCoverPoint.meFireStance );
		}
		break;

	default:
		// Move to fire offset position.
		DoMoveToPoint( 
			mCoverPoint.GetFiringLocation( meCoverFireOffset ), 
			PACE_Running, 
			mCoverPoint.meFireStance,
			mGrenadePoint,
			,
			true );	// Precise move required.
		break;
	}
	
MTP_FinishedMove:

	if ( mSASPawn.ReachedPoint( mCoverPoint.GetFiringLocation( meCoverFireOffset ), true ) )
	{
		StopMoving();
		DoThrowGrenade( GRENADECAT_Explosive, mGrenadePoint, 'MovingToCover', '' );
	}

	// If failed for some reason , then return to cover.
	GotoState( 'MovingToCover' );
}


///////////////////////////////////////////////////////////////////////////////
// STATE CoverAttackingExposed
//
// State to attack threats which we are exposed to when at cover.
// TODO: Need to do respond in differnt ways to being exposed - fire at enemy, 
// try to find new cover, reassess engage response.
state CoverAttackingExposed extends CoverState
{
	ignores ReactToAlertFriendly;

	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	// 
	event BeginState()
	{
		Super.BeginState();

		// Must have chosen cover point to move to before enterring state
		if (mCoverPoint == None)
		{
			Warn( "SASTerrorist in CoverAttackingExposed state without a cover point. Switching to aggressive mode." );
			StartAggressiveAttack( true );
		}

		Enable( 'SeePlayer' );
		Enable( 'EnemyNotVisible' );

		mbAttackedFromCover = true;
	}

	///////////////////////////////////////////////////////////////////////////////
	// EndState
	// 
	event EndState()
	{
		Super.EndState();

		// Stop firing.
		StopRepeatFiring();

		// Store last time we attacked from cover.
		mLastCoverAttackTime = Level.TimeSeconds;
	}


	///////////////////////////////////////////////////////////////////////////////
	// CheckTargets
	// 
	// Find best target to attack from CP
	function CheckTargets()
	{
		local Pawn	newEnemy;

		newEnemy = SelectTargetEnemy( true );
		if ( newEnemy != None )
		{
			SetEnemy( newEnemy );
		}
		else
		{
			GotoState( 'CoverWaiting' );
		}

		Target = Enemy;
		mTerrorist.mInterestItem = Target;
	}


	///////////////////////////////////////////////////////////////////////////////
	// EnemyNotVisible
	// 
	// Called when lose sight of current Enemy. 
	event EnemyNotVisible()
	{
		// Try to find new target from threats list.
		CheckTargets();
	}

	///////////////////////////////////////////////////////////////////////////////
	// Timer
	// 
	event Timer()
	{			
		if ( CoverPointExposedToAnyThreats() )
		{
			if (	(mCoverReachedTime != -1.0) && 
					(Level.TimeSeconds > (mCoverReachedTime + mTerrorist.mMinTimeAtCoverPoint)) )
			{
				if ( SeekCoverInAssaultVolume( false,, GetMaxCoverDist(),, COVERSELECT_CoveredFromAll ) )
				{
					DoCoverAttack();
				}
			}
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// TargetLost
	// 
	event TargetLost()
	{
		CheckTargets();
	}


Begin:

	StopMoving();

	// Face target
	FocusOnEnemy();

	Enable( 'EnemyNotVisible' );

	// Start firing.
	BeginBurstFireAt( Enemy );
	
	// Set timer to reassess if exposed to threats.
	SetTimer( 1.0, true );
	Stop;

	// Called when can't get LoF from crouched stance.
TryStandingLineOfFire:

	if ( mTerrorist.PlayStanceTransitionAnim( STANCE_Standing, true ) )
	{
		mTerrorist.ChangeStanceImmediate( STANCE_Standing );
		FinishAnim( ANIMCHANNEL_ACTION );
		mTerrorist.ChangeAnimation();
	}
	else
	{
		mTerrorist.ChangeStanceImmediate( STANCE_Standing );
	}
}


///////////////////////////////////////////////////////////////////////////////
// STATE CoverAttackingState
//
// Parent state for all attacking from cover states.
state CoverAttackingState extends CoverState
{
	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	//
	event BeginState()
	{
		Super.BeginState();

		// Check remaining ammmo in clip - if less than weapon's discard clip amount
		// then terrorist chose not to reload at cover when it should have - this means
		// terrorist should fire empty when clip runs out.
		if ( SASWeapon( Pawn.Weapon ).mNumInMag <= SASWeapon( Pawn.Weapon ).mDiscardMagThreshold )
		{
			EnableFiringEmpty( true );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndState
	//
	event EndState()
	{
		Super.EndState();

		// Disable abiltiy to fire empty rounds.
		EnableFiringEmpty( false );

		// Stop end attack checking timer.
		StopMultiTimer( mTimerAttacking );
	}


	///////////////////////////////////////////////////////////////////////////////
	// MultiTimer
	//
	event MultiTimer(
		int	aTimerIdx )
	{
		switch ( aTimerIdx )
		{
		case mTimerAttacking:
			if ( PollShouldEndAttackFromCover() )
			{
				EndCoverAttack();
				StopMultiTimer( mTimerAttacking );
			}
			else
			{
				// At zero cover CPs, monitor time to move to new CP.
				// TODO: Seek better cover not just any other cover.
				if (	(mCoverPoint.meCoverSetting == COVER_None) && 
						PollShouldMoveToNewCover() &&
						SeekCoverInAssaultVolume( false, 150.0, GetMaxCoverDist(), COVER_Low ) )
				{
					DoCoverAttack();
				}
				else
				{
					// Radomize the timer interval so that the order in which terrorists receive
					// this event will vary.
					SetMultiTimer( mTimerAttacking, RandRange( 0.25, 0.35 ), true );
				}
			}
			break;

		default:
			Global.MultiTimer( aTimerIdx );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyBurstFired
	//
	// Event recieved on completion of a burst of fire. Returns true if firing
	// should continue.
	event bool NotifyBurstFired()
	{
		// If desired attacking time has passed then return to cover.
		if (	(mCoverPoint.meCoverSetting != COVER_None) &&
				((mCoverPoint.meStance != mCoverPoint.meFireStance) || (meCoverFireOffset != FPA_Centre)) &&
				((Level.TimeSeconds - mAttackStartTime) > mAttackDesiredDuration) )
		{
			EndCoverAttack();
			return false;
		}

		// Continue attacking.
		return true;
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndCoverAttack
	//
	// Function which chooses what to do on completion of a cover attack. Inherited by
	// derived states.
	function EndCoverAttack()
	{
		Warn( "CoverAttackingState.EndCoverAttack called - should only call derived state versions of this function." );
	}
}


///////////////////////////////////////////////////////////////////////////////
// STATE CoverAttackingNormal
//
state CoverAttackingNormal extends CoverAttackingState
{
	ignores ReactToAlertFriendly;

	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	// 
	event BeginState()
	{
		Super.BeginState();

		// Must have chosen cover point to move to before enterring state
		if ( mCoverPoint == None )
		{
			Warn( "SASTerrorist in CoverHide state without a cover point. Switching to aggressive mode." );
			StartAggressiveAttack( false );
		}

		Disable( 'EnemyNotVisible' );
		Enable( 'SeePlayer' );

		Target		= Enemy; 
		MoveTarget	= None;

		mbAttackedFromCover = true;

		// Activate timed threat assessment at medium frequency.
		// But not if undisciplined firing.
		if ( mTerrorist.mFiringPose == FIRINGPOSE_Normal )
		{
			StartPeriodicTargetSelection( TSF_Med );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndState
	// 
	event EndState()
	{
		Super.EndState();

		// Stop firing.
		StopRepeatFiring();

		mSASPawn.SetFiringPose( FIRINGPOSE_Normal );

		// Store last time we attacked from cover.
		mLastCoverAttackTime = Level.TimeSeconds;

		// Dectivate timed threat assessment at medium frequency.
		StopPeriodicTargetSelection();
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndCoverAttack
	// 
	function EndCoverAttack()
	{
		GotoState( 'MovingToCover' );
	}


	///////////////////////////////////////////////////////////////////////////////
	// EnemyNotBestTarget
	// 
	event EnemyNotBestTarget(
		SASPawn	aBestTarget )
	{
		if ( mTerrorist.mFiringPose == FIRINGPOSE_Normal )
		{
			SetEnemy( aBestTarget );
			BeginBurstFireAt( Enemy );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// SelectTarget
	// 
	// Search for new target to attack from threats list.
	function SelectTarget()
	{
		local Pawn	newEnemy;

		newEnemy = SelectTargetEnemy( true );
		if ( newEnemy != None )
		{
			SetEnemy( newEnemy );
		}

		Target = Enemy;
		mTerrorist.mInterestItem = Target;
	}


	///////////////////////////////////////////////////////////////////////////////
	// EnemyNotVisible
	// 
	// Called when lose sight of current Enemy. 
	event EnemyNotVisible()
	{
		local Pawn	prevEnemy;

		prevEnemy = SASPawn (Enemy);

		// Try to find new target from threats list.
		SelectTarget();

		if ( Enemy == prevEnemy )
		{
			// Go into supressive fire mode.
			GotoState( 'CoverSuppressiveFiring' );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// Timer
	// 
	event Timer()
	{ 
		GotoState( 'MovingToCover' );
	}


	///////////////////////////////////////////////////////////////////////////////
	// TargetLost
	// 
	event TargetLost()
	{
		SelectTarget();
	}


	///////////////////////////////////////////////////////////////////////////////
	// ChooseMovingFocus
	// 
	function Actor ChooseMovingFocus()
	{
		if ( mFatalFunnelEP != None )
		{
			return mFatalFunnelEP;
		}

		return Enemy;
	}


Begin:

	StopRepeatFiring();

MoveToFireOffset:

	switch ( meCoverFireOffset )
	{
	case FPA_Centre:

		StopMoving();

		if ( mTerrorist.mFiringPose != FIRINGPOSE_Normal )
		{
			// Always use cover pose when firing undisciplined.
			if ( mSASPawn.PlayStanceTransitionAnim( mCoverPoint.meStance, true ) )
			{
				mTerrorist.ChangeStanceImmediate( mCoverPoint.meStance );
				FinishAnim( ANIMCHANNEL_ACTION );
				mTerrorist.ChangeAnimation();
			}
			else
			{
				mTerrorist.ChangeStanceImmediate( mCoverPoint.meStance );
			}
		}
		else
		{
			if ( mTerrorist.PlayStanceTransitionAnim( mCoverPoint.meFireStance, true ) )
			{
				mTerrorist.ChangeStanceImmediate( mCoverPoint.meFireStance );
				FinishAnim( ANIMCHANNEL_ACTION );
				mTerrorist.ChangeAnimation();
			}
			else
			{
				mTerrorist.ChangeStanceImmediate( mCoverPoint.meFireStance );
			}
		}
		break;

	default:
		// Move to fire offset position.
		DoMoveToPoint( 
			mCoverPoint.GetFiringLocation( meCoverFireOffset ), 
			PACE_Running, 
			mCoverPoint.meFireStance,
			ChooseMovingFocus(),
			,			// Focal point
			true );		// Precise move required.
		break;
	}
	

MTP_FinishedMove:

	StopMoving();

	if ( mTerrorist.mFiringPose == FIRINGPOSE_Normal )
	{
		FocusOnEnemy();
		Enable( 'EnemyNotVisible' );
	}
	else
	{
		SetFocalPointFromDir( mCoverPoint.mDirection2D );
		FinishRotation();

		if ( mTerrorist.AnimateToUndisciplinedFiring() )
		{
			FinishAnim( ANIMCHANNEL_ACTION );
		}
	}

	mAttackStartTime = Level.TimeSeconds;

	// Set time before returning to cover. Note won't be used while attacking from a COVER_None point
	// or a point where the firing stance == hiding stance and the firing position == hiding position.
	// *** Unless *** Don't have any recently seen threats.
	mAttackDesiredDuration = RandRange( 2.5, 3.5 );

	// Set timer to reassess behaviour.
	SetMultiTimer( mTimerAttacking, RandRange( 0.25, 0.35 ), true );

	// Start firing.
	if ( mTerrorist.mFiringPose == FIRINGPOSE_Normal )
	{
		BeginBurstFireAt( Enemy );
	}
	else
	{
		// TODO - Line of fire checking if can see along line of fire (if can see 
		// through object we are firing around.)
		CheckGunSelected();
		SetWeaponFireMode( 'FIREMODE_Auto' );
		StartRepeatFiringAtPoint( FocalPoint,,, true/* no line of fire checking??? */ );
	}

	Stop;


	// Called when can't get LoF from crouched stance.
TryStandingLineOfFire:

	if ( mTerrorist.PlayStanceTransitionAnim( STANCE_Standing, true ) )
	{
		mTerrorist.ChangeStanceImmediate( STANCE_Standing );
		FinishAnim( ANIMCHANNEL_ACTION );
		mTerrorist.ChangeAnimation();
	}
	else
	{
		mTerrorist.ChangeStanceImmediate( STANCE_Standing );
	}
}


///////////////////////////////////////////////////////////////////////////////
// STATE CoverAttackingSpinout
//
state CoverAttackingSpinout extends CoverAttackingState
{
	ignores NotifyBump,
			NotifyPlayerAboutToBump,
			DoStaggerBackward,
			ReactToAlertFriendly;

	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	// 
	event BeginState()
	{
		Super.BeginState();

		SetTimer( 0.0, false );
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndState
	// 
	event EndState()
	{
		Super.EndState();

		SetTimer( 0.0, false );

		bControlAnimations = false;

		if ( mTerrorist != None )
		{
			mTerrorist.SetFiringPose( FIRINGPOSE_Normal );

			if ( mTerrorist.Physics == PHYS_RootMotion )
			{
				mTerrorist.EndCoverSpinoutAnim();
			}

			// Make sure spine twist reenabled
			mTerrorist.bIgnoreSpine = false;
			mTerrorist.bDisableTurnAnims = false; 

			mTerrorist.ChangeAnimation();
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// ReactToThreat
	//
	function ReactToThreat( 
		SASPawn			aThreat,
		EStimulusType	aeDetectionStimulus,
		bool			abNoCallBackup )
	{
		// If in process of spining out the just record threat otherwise react as normal.
		if ( mTerrorist.Physics == PHYS_RootMotion )
		{
			UpdateThreatInfo( aThreat, aeDetectionStimulus );
		}
		else
		{
			Super.ReactToThreat( aThreat, aeDetectionStimulus, abNoCallBackup );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndCoverAttack
	// 
	function EndCoverAttack()
	{
		GotoState( , 'ReturnToCover' );
	}


	///////////////////////////////////////////////////////////////////////////////
	// Timer
	// 
	event Timer()
	{
		EndCoverAttack();
	}


	///////////////////////////////////////////////////////////////////////////////
	// AnimEnd
	// 
	event AnimEnd(
		int	aChannel )
	{
		if ( aChannel == 0 && TryingToFire() )
		{
			mTerrorist.PlaySpinoutFiringPose();
		}
		else
		{
			mTerrorist.AnimEnd( aChannel );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyClipEmpty
	// 
	function NotifyClipEmpty()
	{
		GotoState( , 'ReturnToCover' );
	}


	///////////////////////////////////////////////////////////////////////////////
	// DoReloading
	// 
	// Called when our current weapon needs reloading. Respond by returning to
	// cover.
	function DoReloading(
		optional bool bForceReload)
	{
		GotoState( , 'ReturnToCover' );
	}


Begin:

	StopMoving();

	// Make sure we are at correct starting rotation angle before spining out.
	SetFocalPointFromDir( -mCoverPoint.mDirection2D );
	
	// Disable spine twist when spinning out.
	mSASPawn.bIgnoreSpine = true;

	// Mkae sure we start on the CP - might have moved in CoverWaiting state to avoid being sighted.
	if ( !mTerrorist.ReachedDestination( mCoverPoint, true ) )
	{
		MoveToward( 
			mCoverPoint, 
			None, 
			FocalPoint,
			,
			,
			,
			true );
	}

	SetFocalPointFromDir( -mCoverPoint.mDirection2D );
	FinishRotation( 600 );

	bControlAnimations = true;

	mTerrorist.bDisableTurnAnims = true; 
	mTerrorist.PlayCoverSpinoutAnim();
	FinishAnim( ANIMCHANNEL_Action );
	mTerrorist.EndCoverSpinoutAnim();
	FixCurrentFacing();

	switch ( mTerrorist.mFiringPose )
	{
	case FIRINGPOSE_SpinoutLeftSquat:
	case FIRINGPOSE_SpinoutRightSquat:
		mTerrorist.ChangeStanceImmediate( STANCE_Crouched );
		break;
	}

	mTerrorist.PlaySpinoutFiringPose();
	
	mAttackStartTime = Level.TimeSeconds;
	mAttackDesiredDuration = RandRange( 1.5, 2.5 );

	Enable( 'EnemyNotVisible' );

	// Reenable spine twist after finishing spinout
	mSASPawn.bIgnoreSpine = false;

	// Start firing.
	CheckGunSelected();
	SetWeaponFireMode( 'FIREMODE_Auto' );
	Target = Enemy;
	StartRepeatFiring();

	// Set time before returning to cover.
	SetMultiTimer( mTimerAttacking, RandRange( 0.25, 0.35 ), true );
	Stop;

ReturnToCover:

	StopRepeatFiring();
	StopMultiTimer( mTimerAttacking );

	// Check if spinout attacking is still valid. If not then use cover point as non-spinout point.
	CheckUseSpinoutAttack();
	if ( mbUseSpinoutAttack )
	{
		// Face correct direction before steping back in to cover.
		// GPTODO - Should not rotate pawn while attacking - just rotate spine to aim
		// so that pawn can step straight back into cover.
		
		// Disable spine twist for return spin.
		mSASPawn.bIgnoreSpine = true;
		SetFocalPointFromDir( mCoverPoint.mDirection2D );
		FinishRotation();
		mTerrorist.PlaySpinoutFiringPose();

		bControlAnimations = true;
		mTerrorist.PlayCoverSpinoutReturnAnim();
		FinishAnim( ANIMCHANNEL_Action );
		bControlAnimations = false;
		mTerrorist.EndCoverSpinoutReturnAnim();
		FixCurrentFacing();
		if ( mTerrorist.meStance != STANCE_Standing )
		{
			mTerrorist.ChangeStanceImmediate( STANCE_Standing );
		}
	}

	GotoState( 'MovingToCover' );
}

///////////////////////////////////////////////////////////////////////////////
// STATE CoverSuppressiveFiring
//
state CoverSuppressiveFiring extends CoverState
{
	ignores EnemyNotVisible;

	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	//
	event BeginState()
	{
		Super.BeginState();

		Enable( 'SeePlayer' );
		Enable( 'HearNoise' );
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndState
	//
	event EndState()
	{
		Super.EndState();

		StopRepeatFiring();
		SetTimer( 0.0, false );
	}


	///////////////////////////////////////////////////////////////////////////////
	// Timer
	//
	event Timer()
	{
		// Return to cover when timer expires.
		GotoState( 'MovingToCover' );
	}

	///////////////////////////////////////////////////////////////////////////////
	// NotifyLineOfFireBlocked
	//
	// Don't do anything when LoF blocked when suppressive firing.
	event NotifyLineOfFireBlocked();


Begin:

	InitSuppressiveFiring( LastSeenPos );
	Enemy = None;

	StopMoving();

	// Start firing.
	CheckGunSelected();
	SetWeaponFireMode( 'FIREMODE_Auto' );
	StartRepeatFiringAtPoint( mSuppressiveFirePoint );
}


///////////////////////////////////////////////////////////////////////////////
// CoverCloseInFallback
//
state CoverCloseInFallback extends ChargeAtEnemyState
{
	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	//
	event BeginState()
	{
		Super.BeginState();

		Enable( 'SeePlayer' );
		Enable( 'HearNoise' );

		// Activate timed threat assessment at medium frequency.
		StartPeriodicTargetSelection( TSF_Med );
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndState
	//
	event EndState()
	{
		Super.EndState();

		StopRepeatFiring();

		// Dectivate timed threat assessment at medium frequency.
		StopPeriodicTargetSelection();
	}


	///////////////////////////////////////////////////////////////////////////////
	// ReactToThreat
	//
	function ReactToThreat( 
		SASPawn			aThreat,
		EStimulusType	aeDetectionStimulus,
		bool			abNoCallBackup )
	{
		UpdateThreatInfo( aThreat, aeDetectionStimulus );

		if ( (aeDetectionStimulus == STIMULUS_Sight) && (aThreat == Enemy) )
		{
			// Start trying to fire at enemy. Note: When notified of getting line
			// of fire then will stop moving.
			BeginBurstFireAt( Enemy );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// CheckGoStationary
	//
	function CheckGoStationary()
	{
		// Don't go stationary if moving to the step aside point (used here for backing away from enemy).
		if ( (mGoalActor != None) || (mGoalLocation == vect(0,0,0)) || (mGoalLocation != mStepAsidePoint) )
		{
			GotoState( , 'StationaryAttack' );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyWeaponFired
	//
	function NotifyWeaponFired()
	{
		Global.NotifyWeaponFired();

		CheckGoStationary();
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyLineOfFireAcquired
	// 
	event NotifyLineOfFireAcquired()
	{
		CheckGoStationary();
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyLineOfFireBlocked
	// 
	event NotifyLineOfFireBlocked()
	{
		StopRepeatFiring();
		GotoState( , 'CloseIn' );
	}


	///////////////////////////////////////////////////////////////////////////////
	// DoReloading
	// 
	function DoReloading (optional bool forceReload)
	{
		if ( SeekCoverInRadius( RELOADING_MIN_DIST_TO_THREAT ) )	// TODO: Change this - incorrect macro used!!!
		{
			DoCoverAttack();
		}
		else
		{
			StopMoving();
			StopRepeatFiring();
			Pawn.Weapon.Reload();
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// WeaponReadyToFire
	// 
	function WeaponReadyToFire()
	{
		BeginBurstFireAt( Enemy );
	}
	

	///////////////////////////////////////////////////////////////////////////////
	// ChooseEnemy
	// 
	function ChooseEnemy(
		optional bool abExcludeCurrent )
	{
		local int		i;
		local SASPawn	closest;
		local float		distSq, closestDistSq;

		for ( i = 0; i < mNumThreats; ++i )
		{
			if ( mThreats[i].Pawn != None )
			{
				distSq = VSizeSq( mThreats[i].Pawn.Location - mTerrorist.Location );

				// Bias towards keeping current enemy
				if ( mThreats[i].Pawn == Enemy )
				{
					distSq *= 0.5625;//0.75^2
				}

				if ( (closest == None) || (distSq < closestDistSq) )
				{
					closest = mThreats[i].Pawn;
					closestDistSq = distSq;
				}
			}
		}

		if ( (Closest == None) && (Closest != Enemy) )
		{
			SetEnemy( Closest );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// TargetLost
	// 
	event TargetLost()
	{
		ChooseEnemy();
		if ( Enemy != None )
		{
			Target = Enemy;
			GotoState( , 'CloseIn' );
		}
		else
		{
			// _DI find cover else idle.
			DoIdle();
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndFatalFunnelFiring
	// 
	event EndFatalFunnelFiring()
	{
		Global.EndFatalFunnelFiring();

		GotoState( , 'StationaryAttack' );
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyBurstFired
	//
	// Event recieved on completion of a burst of fire. Returns true if firing
	// should continue.
	event bool NotifyBurstFired()
	{
		if ( FRand() < 0.5 )
		{
			// Try to find nearby cover to move to at end of burst.
			if ( SeekCoverInAssaultVolume( ,, FMin( 250.0, GetMaxCoverDist() ), COVER_Low ) )
			{
				// Move to nearby CP.
				DoCoverAttack();
				return false;
			}
		}
	
		// Continue attacking.
		return true;
	}


Begin:

	MonitorSteppingBack( true );
	
CloseIn:

	DoMoveToActor( GetChargingDest(),,, GetMovingFocus() );
	Stop;

MTP_FinishedMove:

	mStepAsidePoint = vect(0,0,0);

	if ( mbFailedMoveToPoint )
	{
		DoCoverAttack();
	}

	// Need to turn on stepping back monitoring again as it is turned off if the
	// move we just carried out was a step back.
	MonitorSteppingBack( true );
	Stop;

StationaryAttack:

	StopMoving();
	BeginBurstFireAt( Enemy );

	// Make sure step bac kmonitoring is on.
	MonitorSteppingBack( true );
}



///////////////////////////////////////////////////////////////////////////////
// STATE AdvancingToCloserCover
//
state AdvancingToCloserCover extends MovingState
{
	ignores EnemyNotVisible;

	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	//
	event BeginState()
	{
		Super.BeginState();

		Enable( 'SeePlayer' );
		Enable( 'HearNoise' );
	}


	///////////////////////////////////////////////////////////////////////////////
	// ReactToThreat
	//
	function ReactToThreat( 
		SASPawn			aThreat,
		EStimulusType	aeDetectionStimulus,
		bool			abNoCallBackup )
	{
		UpdateThreatInfo( aThreat, aeDetectionStimulus );

		switch ( aeDetectionStimulus )
		{
		case STIMULUS_Sight:
			// Hack: Prevent returning to last CP by setting current CP to last one
			// and excluding picking same CP in seeking cover.
			AcquireCoverPoint( mPrevCoverPoint );
			if ( SeekCoverInAssaultVolume( false,,,, COVERSELECT_CoveredFromAll ) )
			{
				StartCoverAttack( true );
			}
			else
			{
				RelinquishCoverPoint();
				StartAggressiveAttack( false );
				// Failed to find new cover, try to retake prev cover.
				//if ( (mPrevCoverPoint != None) && AcquireCoverPoint( mPrevCoverPoint ) )
				//{
				//	DoCoverAttack();
				//}
			}
			break;

		default:
			break;
		}
	}
	
	/*event HearNoise(
		float		aLoudness,		
		Actor		aNoiseMaker,
		ENoiseType	aeNoiseType )
	{
		local SASPawn	aNoiseMakerSASPawn;

		aNoiseMakerSASPawn = SASPawn( aNoiseMaker );
		if ( (aNoiseMakerSASPawn != None) 
			&& mTerrorist.IsAThreat( aNoiseMakerSASPawn ) 
			&& CanSeePawn( aNoiseMakerSASPawn ) )
		{
			UpdateThreatInfo( aNoiseMakerSASPawn, STIMULUS_Noise );
			ReactToDetected();
		}
	}*/

	function ChooseEnemy(
		optional bool abExcludeCurrent )
	{
		local int		i;
		local SASPawn	closest;
		local float		distSq, closestDistSq;

		for ( i = 0; i < mNumThreats; ++i )
		{
			if ( mThreats[i].Pawn != None )
			{
				distSq = VSizeSq( mThreats[i].Pawn.Location - mTerrorist.Location );

				// Bias towards keeping current enemy
				if ( mThreats[i].Pawn == Enemy )
				{
					distSq *= 0.5625;//0.75^2
				}

				if ( (closest == None) || (distSq < closestDistSq) )
				{
					closest = mThreats[i].Pawn;
					closestDistSq = distSq;
				}
			}
		}

		if ( (Closest == None) && (Closest != Enemy) )
		{
			SetEnemy( Closest );
		}
	}

Begin:

	// Select target enemy to move to
	ChooseEnemy();

Advancing:

	if ( Enemy != None )
	{
		DoMoveToActor( Enemy );
	}

MTP_FinishedMove:

	DoIdle();
}


///////////////////////////////////////////////////////////////////////////////
// STATE Retreating
//
state Retreating extends MovingState
{
	ignores CanInvestigate;

	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	// 
	event BeginState()
	{
		Super.BeginState();

		Enable( 'SeePlayer' );
		Disable( 'EnemyNotVisible' );

		// Activate timed threat reassessment.
		StartPeriodicTargetSelection( TSF_Low );
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndState
	// 
	event EndState()
	{
		Super.EndState();

		// Deactivate timed threat reassessment.
		StopPeriodicTargetSelection();
	}


	///////////////////////////////////////////////////////////////////////////////
	// MultiTimer
	// 
	event MultiTimer(
		int aTimerIdx )
	{
		Global.MultiTimer( aTimerIdx );
	}


	///////////////////////////////////////////////////////////////////////////////
	// EnemyNotBestTarget
	// 
	event EnemyNotBestTarget(
		SASPawn	aBestTarget )
	{
		SetEnemy( aBestTarget );
		BeginBurstFireAt( Enemy );
	}


	///////////////////////////////////////////////////////////////////////////////
	// TargetLost
	// 
	event TargetLost()
	{
		local SASPawn	nextEnemy;

		nextEnemy = SelectTargetEnemy( true );
		if ( nextEnemy != None )
		{
			SetEnemy( nextEnemy );
			Target = Enemy;
			mTerrorist.mInterestItem = Target;
		}
		
		Target = Enemy;
		mTerrorist.mInterestItem = Target;
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyLineOfFireBlocked
	// 
	// Event received when line of fireto current target has been blocked for
	// longer than MAX_BLOCKED_LOF_TIME.
	event NotifyLineOfFireBlocked()
	{
		Enemy = None;
		Target = None;
		StopRepeatFiring();

		Pawn.SetPace( PACE_Charging );
	}


	///////////////////////////////////////////////////////////////////////////////
	// ReactToThreat
	//
	function ReactToThreat( 
		SASPawn			aThreat,
		EStimulusType	aeDetectionStimulus,
		bool			abNoCallBackup )
	{
		UpdateThreatInfo( aThreat, aeDetectionStimulus );

		// Don't select a new enemy if already have one or fatal funnel is still active.
		if ( (Enemy != None) || (mFatalFunnelEP != None) )
		{
			return;
		}

		switch( aeDetectionStimulus )
		{
		case STIMULUS_Sight:
		case STIMULUS_Bump:
			SetEnemy( aThreat );
			BeginBurstFireAt( Enemy );
			break;

		case STIMULUS_Noise:
		case STIMULUS_Damage:
			if ( CanSeePawn( aThreat, true ) )
			{
				SetEnemy( aThreat );
				BeginBurstFireAt( Enemy );
			}
			break;

		default:
			Warn( "Unhandled stimulus type <"$aeDetectionStimulus$" in Retreating.ReactToThreat." );
		}
	}

Begin:

	// Reset enemy if currently have a fatal funnel.
	if ( mFatalFunnelEP != None )
	{
		Enemy = None;
	}

MoveToRetreatPoint:

	if ( mRetreatNextEP != None )
	{
		if ( Enemy == None )
		{
			Pawn.SetPace( PACE_Charging );
		}
		else
		{
			Pawn.SetPace( PACE_Running );
			BeginBurstFireAt( Enemy );
		}
		DoMoveToActor( mRetreatNextEP, Pawn.mePace );
	}
	else
	{
		Goto( 'End' );
	}

MTP_FinishedMove:

	FindRetreatPoint();
	Goto( 'MoveToRetreatPoint' );

End:

	if (	(mNumRetreatVolumesTraversed > 0) && 
			SeekCoverInAssaultVolume( ,,,,, mRetreatVolumeCache[mNumRetreatVolumesTraversed-1] ) )
	{
		StartCoverAttack( false );
		Stop;
	}
	else if ( SeekCoverInRadius( 1000.0f ) )
	{
		StartCoverAttack( false );
		Stop;
	}

	// Fallback - do idle and wait for a behaviour switch.
	// TODO: At least try to face the direction expexting the enemy to come from.
	Enemy = None;
	// _DI check can attack, else find cover else idle.
	DoIdle();
}


///////////////////////////////////////////////////////////////////////////////
// STATE RetreatFromGrenades
// 
// Extends SASAIController.RetreatFromGrenades state. 
state RetreatFromGrenades
{
	ignores SeePlayer,
			HearNoise,
			DamageAttitudeTo,
			ReactToAlertFriendly;

	///////////////////////////////////////////////////////////////////////////////
	// ReactToThreat
	// 
	event ReactToThreat(
		SASPawn			aThreat,
		EStimulusType	aeDetectionStimulus,
		bool			abNoCallBackup )
	{
		// Just update the detected threat info while retreating.
		UpdateThreatInfo( aThreat, aeDetectionStimulus );

		// TODO: Sighting of a threat in front of direction moving should result in firing.
		// Should stop firing whe nthreat moves out of direction moving.
	}
}


///////////////////////////////////////////////////////////////////////////////
// STATE DefendGrenadeRetreatPoint
//
state DefendGrenadeRetreatPoint extends GrenadeAvoidanceState
{
	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	// 
	event BeginState()
	{
		Super.BeginState();

		mTerrorist.bPeripheralVisionCheat = true;
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndState
	// 
	event EndState()
	{
		Super.EndState();

		if ( mTerrorist != None )
		{
			mTerrorist.bPeripheralVisionCheat = false;
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// ReactToThreat
	// 
	event ReactToThreat(
		SASPawn			aThreat,
		EStimulusType	aeDetectionStimulus,
		bool			abNoCallBackup )
	{
		// Just update the detected threat info while retreating.
		UpdateThreatInfo( aThreat, aeDetectionStimulus );

		// Don't select a new enemy if already have one or fatal funnel is still active.
		/*if ( (Enemy != None) || (mFatalFunnelEP != None) )
		{
			return;
		}

		switch( aeDetectionStimulus )
		{
		case STIMULUS_Sight:
		case STIMULUS_Bump:
			SetEnemy( aThreat );
			BeginBurstFireAt( Enemy );
			break;

		case STIMULUS_Noise:
		case STIMULUS_Damage:
			if ( CanSeePawn( aThreat, true ) )
			{
				SetEnemy( aThreat );
				BeginBurstFireAt( Enemy );
			}
			break;

		default:
			Warn( "Unhandled stimulus type <"$aeDetectionStimulus$" in DefendGrenadeRetreatPoint.ReactToThreat." );
		}*/

		if ( aeDetectionStimulus == STIMULUS_Sight )
		{
			if (	(Enemy == None) ||
					(!mbHasLineOfFire && PointIsInAcquisitionAngle( Enemy.Location )) )
			{
				SetEnemy( aThreat );
			}

			if ( (Enemy != None) && !TryingToFire() )
			{
				BeginBurstFireAt( Enemy );
			}
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyLineOfFireBlocked
	// 
	/*event NotifyLineOfFireBlocked()
	{
		StopRepeatFiring();
	}*/


	///////////////////////////////////////////////////////////////////////////////
	// EnemyNotVisible
	// 
	event EnemyNotVisible()
	{
		Enemy = None;
	}

Begin:

	Enemy = None;
	Enable( 'EnemyNotVisible' );
}



///////////////////////////////////////////////////////////////////////////////
// STATE Investigating
//
state Investigating extends MovingState
{
	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	//
	event BeginState()
	{
		Super.BeginState();

		Enemy = None;

		if ( mInvestigationPoint == None )
		{
			Warn( Pawn$" enterred Investigating state without an investigation point." );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// GetNextCoverPoint
	//
	// Search for a cover point to move toward in the direction of the path to the
	// investigation point.
	function bool GetNextCoverPoint()
	{
		local SASCoverPoint nextCP;
		local SASEntryPoint	nextFocalEP;

		nextCP = FindCoverPointOnRouteTo( mInvestigationPoint, 500.0, nextFocalEP );
		if ( nextCP != None && AcquireCoverPoint( nextCP ) )
		{
			mFocalEP = nextFocalEP;
			return true;
		}

		return false;
	}


	///////////////////////////////////////////////////////////////////////////////
	// ReachedPathIntermediatePoint
	//
	// Callback to notify we've reached an intermediate nav point on the path 
	// to the current goal.
	function ReachedPathIntermediatePoint(
		Actor	aPoint )
	{
		local SASAssaultVolume	myAV;

		if ( Enemy != None )
		{
			return;
		}

		// If not currently moving to a cover point, search for one to move to.
		if ( mCoverPoint == None )
		{
			if ( GetNextCoverPoint() )
			{
				DoMoveToActor( mCoverPoint );
			}
		}
		
		myAV = mSASPawn.GetAssaultVolume();
		if ( myAV != None )
		{
			// Mark current AV last investigated time.
			myAV.mLastTerroristInvestigateTime = Level.TimeSeconds;

			if (	mbInvestigateHangBack && 
					(myAV.GetSharedEntryPoint( SASAssaultVolume( mInvestigationPoint.AssaultVolPtr ) ) != None) )
			{
				// Don't keep current CP if it's not in our AV
				if ( (mCoverPoint != None) && (mCoverPoint.mAssaultVol != myAV) )
				{
					RelinquishCoverPoint();
				}

				if ( (mCoverPoint != None) || SeekCoverInAssaultVolume() ) 
				{
					DoCoverIdle();
				}
			}
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// ReactToThreat
	//
	function ReactToThreat(
		SASPawn			aThreat,
		EStimulusType	aeDetectionStimulus,
		bool			abNoCallBackup )
	{
		UpdateThreatInfo( aThreat, aeDetectionStimulus );

		if ( Enemy != None )
		{
			return;
		}

		switch( aeDetectionStimulus )
		{
		case STIMULUS_Sight:
		case STIMULUS_Bump:
		case STIMULUS_Damage:
			// On first threat sighting, stop and fire briefly before choosing a 
			// normal attacking state.
			SetEnemy( aThreat );
			GotoState( , 'Attack' );
			break;

		case STIMULUS_Noise:
			// Periodically check to see if we should change our investigation destination due to this noise.
			if ( mLastNoiseReactTime < (Level.TimeSeconds - 0.5) )
			{
				mLastNoiseReactTime = Level.TimeSeconds;
				if ( CheckChangeInvestigationPoint( aThreat ) )
				{
					// If not at a cover point then start moving to new investigation point.
					if ( (mCoverPoint == None) || !Pawn.ReachedDestination( mCoverPoint ) )
					{
						GotoState( , 'MovingToInvestigationPoint' );
					}
				}
			}
			break;

		default:
			Warn( "Unhandled stimulus type <"$aeDetectionStimulus$" in Investigating.ReactToThreat." );
			break;
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// EnemyNotVisible
	//
	event EnemyNotVisible()
	{
		// If cannot select a visible target, move to a normal attacking state.
		
	}


Begin:

	mFocalEP = None;

MovingToInvestigationPoint:

	Enemy = None;

	// Search for best CP in range which is has shorter path dist to goal than 
	// current CP. Take our path to CP into account too.
	if ( GetNextCoverPoint() )
	{
		DoMoveToActor( mCoverPoint, PACE_Running );
	}
	else
	{
		DoMoveToActor( mInvestigationPoint, PACE_Running );
	}

	
MTP_FinishedMove: 

	if ( mCoverPoint != None && Pawn.ReachedDestination( mCoverPoint ) )
	{
		// Mark last time this CP was used during investigation.
		mCoverPoint.mLastTerroristInvestigateTime = Level.TimeSeconds;
			
		if ( mFocalEP != None )
		{
			SetFocus( mFocalEP );
		}
		else
		{
			if ( LineOfSightTo( mInvestigationPoint ) )
			{
				SetFocus( mInvestigationPoint );
			}
			else
			{
				SetFocalPointFromDir( mCoverPoint.YawDirection() );
			}
		}

		// If meant to hang back from final investigation room and is now in adjascnet room then
		// stop here and wait at CP.
		if (	mbInvestigateHangBack && 
				(mTerrorist.GetAssaultVolume().GetSharedEntryPoint( SASAssaultVolume( mInvestigationPoint.AssaultVolPtr ) ) != None) )
		{
			DoCoverIdle();
		}
		else
		{
			if ( mTerrorist.PlayStanceTransitionAnim( mCoverPoint.meFireStance, true ) )
			{
				mTerrorist.ChangeStanceImmediate( mCoverPoint.meFireStance );
				FinishAnim( ANIMCHANNEL_ACTION );
				mTerrorist.ChangeAnimation();
			}
			else
			{
				mTerrorist.ChangeStanceImmediate( mCoverPoint.meFireStance );
			}
			Sleep( 1.5 + (FRand() * 1.0) );
		}
	}

	if ( !Pawn.ReachedDestination( mInvestigationPoint ) )
	{
		if ( LineOfSightTo( mInvestigationPoint ) )
		{
			Goto( 'AtInvestigationPoint' );
		}

		Sleep( 0.2 );
		Goto( 'MovingToInvestigationPoint' );
	}


AtInvestigationPoint:

	// If:
	// 1) Spent more than 30s investigating OR
	// 2) Can't find suitable next point to investigate.
	// Then choose neraby CP to take up position at.
	if ( ((Level.TimeSeconds - mInvestigateStartTime) > 30.0)
		|| !UpdateInvestigationPoint() )
	{
		// TEMP
		// _DI find cover else idle.
		DoIdle();
		//GetFinalCoverPoint();
	}

	Sleep( 0.0 );
	Goto( 'MovingToInvestigationPoint' );
	
Attack:

	StopMoving();
	FocusOnEnemy();
	Sleep( RandRange( mTerrorist.mReactionTime.Min, mTerrorist.mReactionTime.Max ) );
	Enable( 'EnemyNotVisible' );
	BeginBurstFireAt( Enemy );
	Sleep( RandRange( 1.0, 1.8 ) );

TryToEngage:

	if ( EngageThreat( SASPawn( Enemy ) ) )
	{
		Stop;
	}
	DoIdle();
}

function bool BreakoutEngageThreat( Pawn	aThreat );

///////////////////////////////////////////////////////////////////////////////
// STATE SurrenderBase
//
state SurrenderBase
{
	///////////////////////////////////////////////////////////////////////////////
	// ReactToThreat
	//
	function ReactToThreat( 
		SASPawn			aThreat,
		EStimulusType	aeDetectionStimulus,
		bool			abNoCallBackup )
	{
		// Just update info on threat.
		UpdateThreatInfo( aThreat, aeDetectionStimulus );
	}

	function bool EngageThreat(
		Pawn	aThreat )
	{
		return false;
	}

	function bool BreakoutEngageThreat( Pawn	aThreat )
	{
		return Global.EngageThreat( aThreat );
	}

	function ReactToOtherAlert(
		SASPawn	aAlerted, 
		SASPawn	aInstigator );
}

///////////////////////////////////////////////////////////////////////////////
// STATE Surrendered
//
state Surrendered extends SurrenderBase
{
	ignores DoSurrender, 
			EnemyNotVisible,
			DamageAttitudeTo,
			DoStaggerBackward,
			WeaponPointedAt,
			NotifyPlayerAboutToBump,
			ReactToAlertFriendly,
			CanInvestigate;

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
	event EndState()
	{
		StopMultiTimer( mTimerReassess );

		if ( mTerrorist != None )
		{
			mTerrorist.bDisableTurnAnims = false;
			mTerrorist.bIgnoreSpine = false;

			// Make sure surrendering/surrender breakout anim not playing.
			if ( mTerrorist.Physics == PHYS_RootMotion )
			{
				mTerrorist.EndSurrenderingAnim( true );
			}
			else
			{
				mTerrorist.EndPlayActionAnim( 0.2 );
			}
			mTerrorist.mbPlayedSurrendering = true;

			// Can only play stationary surrender anim if we reenter the state.
			mSurrenderReaction = mTerrorist.SURRENDERREACTION_Stationary;

			// IF exiting this state when not surrendered, captured, or incapacitated and is alive
			// then make sure we are marked as combat capable.
			if (	!mTerrorist.mbSurrendered && 
					!mTerrorist.mbCaptured &&
					!IsIncapacitated() && 
					mTerrorist.IsAlive() )
			{
				mTerrorist.SetCombatCapable( true );
			}
		}
	}

	
	///////////////////////////////////////////////////////////////////////////////
	// NotifyBump
	//
	event bool NotifyBump(
		Actor	aOther )
	{
		local SASPawn	aOtherPawn;

		if ( mTerrorist.mbPlayedSurrendering && Physics == PHYS_Walking )
		{
			// If bumping a soldier then turn to face them.
			if ( (SASSoldier( aOther ) != None) && (Level.TimeSeconds - mLastSurrenderFocusChangeTime > 2.0) )
			{
				SetFocalPoint( aOther.Location );
				mLastSurrenderFocusChangeTime = Level.TimeSeconds;
			}
		}

		// If bumped by a player then set timer to pull weapon if they don't order me
		// down quickly. 

		// Ignore the bump until anfter have initially dropped weapon that was holding
		// when surrendering.
		if ( mTerrorist.Weapon != None )
		{
			return Global.NotifyBump( aOther );
		}

		// Don't react while doing root motion or if already set timer to react.
		if (	(mTerrorist.Physics != PHYS_RootMotion) &&
				mTerrorist.mbPlayedSurrendering &&
				(mSurrenderBreakoutGuardedTime == 0.0) )
		{
			// Check other is a player.
			aOtherPawn = SASPawn( aOther );
			if (	aOtherPawn != None && 
					aOtherPawn.Controller != None &&
					aOtherPawn.Controller.mType == CONTROLLER_Player )
			{
				// Check weapon availability.
				if (	(mTerrorist.GetWeaponOfCategory( WPNCAT_Primary ) != None) ||
						(mTerrorist.GetWeaponOfCategory( WPNCAT_Secondary ) != None) )
				{
					mSurrenderBreakoutGuardedTime = Level.TimeSeconds + 2.0;
				}
			}
		}

		return Global.NotifyBump( aOther );
	}


	///////////////////////////////////////////////////////////////////////////////
	// MultiTimer
	//
	event MultiTimer(
		int aTimerIdx )
	{
		switch ( aTimerIdx )
		{
		case mTimerReassess:

			if ( mTerrorist.Physics != PHYS_RootMotion )
			{
				// Check we really have a weapon to attack with.
				if (	(mTerrorist.GetWeaponOfCategory( WPNCAT_Primary ) == None) &&
						(mTerrorist.GetWeaponOfCategory( WPNCAT_Secondary ) == None) )
				{
					StopMultiTimer( mTimerReassess );
					return;
				}

				// If level time has passed the guarded breakout time then stop surrendering.
				if (	(mSurrenderBreakoutGuardedTime > 0.0) && 
						(Level.TimeSeconds > mSurrenderBreakoutGuardedTime) )
				{
					GotoState( , 'Breakout' );
				}

				// If no-ones guarding me then can stop surrendering.
				else if ( CheckSurrenderedUnguarded() )
				{
					GotoState( , 'Breakout' );
				}
			}
			break;

		default:
			Global.MultiTimer( aTimerIdx );
			break;
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// AnimNotifySetWeapon
	// 
	event AnimNotifySetWeapon()
	{
		local SASWeapon	nextWpn;

		if ( mTerrorist.Weapon == None )
		{
			nextWpn = mTerrorist.GetWeaponOfCategory( WPNCAT_Primary );
			if ( nextWpn == None )
			{
				nextWpn = mTerrorist.GetWeaponOfCategory( WPNCAT_Secondary );
			}

			if ( nextWpn != None )
			{
				mTerrorist.PendingWeapon = nextWpn; 
				mTerrorist.ChangedWeaponImmediate();
				mTerrorist.ChangeAnimation();
				mTerrorist.SetCombatCapable( true );
			}
			else
			{
				SwitchToBestWeapon();
			}
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// ChooseSurrenderReaction
	// 
	function ChooseSurrenderReaction()
	{
		local bool		bCanDoLargeStepBack;
		local Vector	hitLocation,
						hitNormal,
						endTrace,
						startTrace,
						extent;
		local Actor		hitActor;

		// Already chosen?
		if ( mSurrenderReaction != mTerrorist.SURRENDERREACTION_None )
		{
			return;
		}

		// If crouched or don't have a weapon (surrendering because right arm shot) 
		// then do stationary surrender.
		if ( mSASPawn.meStance != STANCE_Standing || mTerrorist.Weapon == None )
		{
			mSurrenderReaction = mTerrorist.SURRENDERREACTION_Stationary;
			return;
		}

		// Only allow large stagger backward if line of sight threats are in front of me.
		bCanDoLargeStepBack = true;

		// Do basic line check to see how far we can step backward.
		startTrace = mTerrorist.Location;
		endTrace = Vector(mTerrorist.Rotation) * -48.0;
		extent.X = mTerrorist.CollisionRadius;
		extent.Y = mTerrorist.CollisionRadius;
		extent.Z = mTerrorist.CollisionHeight;
		hitActor = mTerrorist.Trace( 
			hitLocation, 
			hitNormal, 
			endTrace, 
			startTrace, 
			false,
			extent,
			, 
			false );
		if ( hitActor == None )
		{
			mSurrenderReaction = mTerrorist.SURRENDERREACTION_StaggerBackLarge;
		}
		else
		{
			mSurrenderReaction = mTerrorist.SURRENDERREACTION_StaggerBackSmall;
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// ChooseSurrenderedFacing
	// 
	function ChooseSurrenderedFacing()
	{
		local Vector		focalDir;
		local SASSoldier	soldier,
							closestVisibleSoldier;
		local float			distSq,
							closestDistSq;

		// Choose direction to face from the following:
		// 1) Nearby visible soldier
		// 2) Away from walls.

		closestDistSq = 999999999.9;
		foreach SASGameInfo( Level.Game ).RadiusSASPawns( 
			class'SASSoldier', 
			soldier, 
			mTerrorist.Location, 
			1000.0 )
		{
			if ( soldier.Health > 0 && !soldier.mbIsIncapacitated )
			{
				distSq = VSizeSq( mTerrorist.Location - soldier.Location );
				if ( distSq < closestDistSq )
				{

					if ( FastTrace( 
							mTerrorist.Location+mTerrorist.EyePosition(),
							soldier.Location+soldier.EyePosition() ) )
					{
						closestVisibleSoldier = soldier;
						closestDistSq = distSq;
					}
				}
			}
		}

		if ( closestVisibleSoldier != None )
		{
			focalDir = Normal( closestVisibleSoldier.Location - mTerrorist.Location );
		}
		else 
		{
			// If no visible nearby soldiers to look at then just try to avoid looking
			// at a wall.
			focalDir = ChooseDirectionNotFacingWall( mTerrorist.YawDirection() );
		}

		SetFocalPointFromDir( focalDir );
	}


Begin:

	StopMoving();
	StopRepeatFiring();
	ClearReaction();

	// Fix rotation direction.
	FixCurrentFacing();
	//mTerrorist.bDisableTurnAnims = true;
	mTerrorist.bIgnoreSpine = true;

	// Choose surrender reaction (stand still or stagger back).
	ChooseSurrenderReaction();

	if ( mSASPawn.meStance != STANCE_Standing )
	{
		DoStanceTransition( STANCE_Standing, GetStateName(),, 1.5 );
	}

	// Play to surrendered anim.
	mTerrorist.ChangeAnimation();
	if ( !mTerrorist.mbPlayedSurrendering )
	{
		Sleep(0.01);
		mSASPawn.PlayDelayedSpeech( SPEECH_TerrSurrender, false );
		mTerrorist.PlaySurrenderingAnim( mSurrenderReaction );
		FinishAnim( ANIMCHANNEL_ACTION );
		mTerrorist.EndSurrenderingAnim( false );
		mTerrorist.mbPlayedSurrendering = true;
	}
	
	// Make sure weapon gets dropped (should happen via anim notify during
	// transition to surrendered anim).
	if ( mTerrorist.Weapon != None )
	{
		mTerrorist.DropWeapon();
	}

	// Set timer to check for becoming unguarded while surrendered.
	SetMultiTimer( mTimerReassess, 1.5, true );

	// Set a direction to face when surrendered.
	ChooseSurrenderedFacing();

	Stop;


Breakout:

	StopMultiTimer( mTimerReassess );

	// Unsurrender but stay combat incapable for now to prevent being instantly killed by AI squad.
	mTerrorist.Surrender( false );
	mTerrorist.SetCombatCapable( false );

	// Update the base anim to be unsurrendered.
	mTerrorist.ChangeAnimation();
	//mTerrorist.bDisableTurnAnims = false;

	// Play breakout anim.
	if ( mTerrorist.meStance == STANCE_Standing )
	{
		mTerrorist.PlaySurrenderBreakout();
		FinishAnim( ANIMCHANNEL_ACTION );
	}

	// Choose weapon and ready it immediately (skip weapon select phase).
	// Should have happened by anim notify in surrender breakout anim.
	if ( mTerrorist.Weapon == None )
	{
		AnimNotifySetWeapon();
	}

	Enemy = SelectTargetEnemy();
	if ( Enemy == None )
	{
		Enemy = SelectClosestPlayerEnemy();
	}
	if ( Enemy != None )
	{
		mTerrorist.mAlertAggressivePct = 1.0;
		mTerrorist.mAlertCoverPct = 0.0;
		mTerrorist.mAlertRetreatPct = 0.0;
		if ( BreakoutEngageThreat( SASPawn (Enemy) ) )
		{
			Stop;
		}
		
		SetFocus( Enemy );
	}

	// _DI check can attack, else find cover else idle.
	Enemy = None;
	DoIdle();
}



///////////////////////////////////////////////////////////////////////////////
// STATE OrderedDown
//
state OrderedDown extends SurrenderBase
{
	ignores DoSurrender,
			DoOrderedDown,
			EnemyNotVisible,
			DamageAttitudeTo,
			DoStaggerBackward,
			DoStunned,
			DoGassed,
			ReactToGrenade,
			WeaponPointedAt,
			NotifyPlayerAboutToBump,
			CanStepAside,
			DoStepAside,
			ServerDoPunchedByPlayer,
			ReactToAlertFriendly,
			CanInvestigate;


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
	event EndState()
	{
		StopMultiTimer( mTimerReassess );

		if ( mTerrorist != None )
		{
			mTerrorist.bIgnoreSpine = false;
			mTerrorist.bDisableTurnAnims = false;

			// Turn on collision blocking.
			mTerrorist.SetNonZeroExtentTraces( true );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// MultiTimer
	//
	event MultiTimer(
		int aTimerIdx )
	{
		switch ( aTimerIdx )
		{
		case mTimerReassess:
			// If no-ones guarding me then can stop surrendering. Don't try to get up when 
			// somebody stood on me!
			if (	!mTerrorist.mbCuffingStarted && 
					CheckSurrenderedUnguarded() &&
					!mTerrorist.IsEncroachedByOtherPawn() )
			{
				// Check we really have a weapon to attack with.
				if (	(mTerrorist.GetWeaponOfCategory( WPNCAT_Primary ) == None) &&
						(mTerrorist.GetWeaponOfCategory( WPNCAT_Secondary ) == None) )
				{
					StopMultiTimer( mTimerReassess );
					return;
				}

				GotoState( , 'Breakout' );
			}
			break;

		default:
			Global.MultiTimer( aTimerIdx );
			break;
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyStartedCuffing
	//
	function NotifyStartedCuffing()
	{
		if ( !mTerrorist.mbCuffingStarted )
		{
			mTerrorist.mbCuffingStarted = true;
			mTerrorist.PlayCuffingAnim();
			mTerrorist.ChangeAnimation();
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyStoppedCuffing
	//
	function NotifyStoppedCuffing()
	{
		if ( !mTerrorist.mbCaptured && mTerrorist.mbCuffingStarted )
		{
			mTerrorist.mbCuffingStarted = false;
			
			mTerrorist.PlayCuffingStopped();
			mTerrorist.ChangeAnimation();
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyCaptured
	//
	function NotifyCaptured()
	{
		DoRestrained();
	}


Begin:

	StopMoving();
		
	// If not already ordered down and actually got down then do it.
	if ( mTerrorist.meStance != STANCE_Prone )
	{
		// Try to find good direction to go prone.
		FindDirectionToGoProne();
		SetFocalPointFromDir( mProneFocalDir );

		// No turn anims for turn when surrendered - disable turn anim playing.
		mTerrorist.bDisableTurnAnims = true;

		mTerrorist.bIgnoreSpine = true;
		FinishRotation();
		mTerrorist.bIgnoreSpine = false;

		DoStanceTransition( STANCE_Prone, GetStateName() );
	}

	FixCurrentFacing();
	mTerrorist.bDisableTurnAnims = false;

	// Turn off collision blocking while prone.
	mTerrorist.SetNonZeroExtentTraces( false );

	// Set timer to check for becoming unguarded while surrendered.
	SetMultiTimer( mTimerReassess, 1.5, true );

	Stop;

Breakout:

	StopMultiTimer( mTimerReassess );

	mTerrorist.Surrender( false );

	// Turn on collision blocking.
	mTerrorist.SetNonZeroExtentTraces( true );

	mTerrorist.ChangeStanceImmediate( STANCE_Standing );
	mTerrorist.ChangeAnimation();
	mTerrorist.bDisableTurnAnims = false;

	// Choose weapon.
	if ( mTerrorist.Weapon == None )
	{
		SwitchToBestWeapon();
	}

	Enemy = SelectTargetEnemy();
	if ( Enemy == None )
	{
		Enemy = SelectClosestPlayerEnemy();
	}
	if ( Enemy != None )
	{
		mTerrorist.mAlertAggressivePct = 1.0;
		mTerrorist.mAlertCoverPct = 0.0;
		mTerrorist.mAlertRetreatPct = 0.0;
		if ( BreakoutEngageThreat( SASPawn (Enemy) ) )
		{
			Stop;
		}
		
		SetFocus( Enemy );
	}

	// _DI check can attack, else find cover else idle.
	Enemy = None;
	DoIdle();
}


///////////////////////////////////////////////////////////////////////////////
// STATE Restrained
//
state Restrained
{
	ignores DoSurrender,
			SeePlayer, 
			HearNoise, 
			ReactToThreat,
			EnemyNotVisible,
			DamageAttitudeTo,
			DoStaggerBackward,
			DoStunned,
			DoGassed,
			ReactToGrenade,
			WeaponPointedAt,
			NotifyPlayerAboutToBump,
			CanStepAside,
			DoStepAside,
			ServerDoPunchedByPlayer,
			ReactToAlertFriendly,
			CanInvestigate;

	event EndState()
	{
		if ( mTerrorist != None )
		{
			// Turn on collision blocking on leaving state.
			mTerrorist.SetNonZeroExtentTraces( true );
		}
	}

	function bool EngageThreat(
		Pawn	aThreat )
	{
		return false;
	}

	function ReactToOtherAlert(
		SASPawn	aAlerted, 
		SASPawn	aInstigator );

Begin:

	// If not already ordered down and actually got down then do it.
	if ( mTerrorist.meStance != STANCE_Prone )
	{
		// Try to find good direction to go prone.
		FindDirectionToGoProne();
		SetFocalPointFromDir( mProneFocalDir );

		// No turn anims for turn when surrendered - disable turn anim playing.
		mTerrorist.bDisableTurnAnims = true;

		mTerrorist.bIgnoreSpine = true;
		FinishRotation();
		mTerrorist.bIgnoreSpine = false;

		mTerrorist.bDisableTurnAnims = false;

		DoStanceTransition( STANCE_Prone, GetStateName() );
	}

	// Turn off collision blocking while prone.
	mTerrorist.SetNonZeroExtentTraces( false );
}


///////////////////////////////////////////////////////////////////////////////
// STATE Incapacitated
//
// Extended to deal with handcuffing incap terrorists.
state Incapacitated
{
	ignores SeePlayer,
			SeeDeadBody,
			HearNoise, 
			SeeGrenade,
			NotifyBump,
			NotifyPlayerAboutToBump,
			EnemyNotVisible,
			Trigger,
			HitWall,
			HeadVolumeChange,
			PhysicsVolumeChange,
			Falling,
			DamageAttitudeTo;


	///////////////////////////////////////////////////////////////////////////////
	// NotifyStartedCuffing
	//
	function NotifyStartedCuffing()
	{
		if ( !mTerrorist.mbCuffingStarted )
		{
			mTerrorist.mbCuffingStarted = true;
		
			// Drop a weapon if holding one.
			if ( mTerrorist.Weapon != None )
			{
				mTerrorist.DropWeapon();
			}

			mTerrorist.PlayCuffingAnim();
			mTerrorist.ChangeAnimation();
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyStoppedCuffing
	//
	function NotifyStoppedCuffing()
	{
		if ( !mTerrorist.mbCaptured && mTerrorist.mbCuffingStarted )
		{
			mTerrorist.mbCuffingStarted = false;
			mSASPawn.PlayCuffingStopped();
			mSASPawn.ChangeAnimation();
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyCaptured
	//
	function NotifyCaptured()
	{
		DoRestrained();
	}
}


///////////////////////////////////////////////////////////////////////////////
// STATE ActingDead
//
state ActingDead
{
	ignores EnemyNotVisible,
			DamageAttitudeTo,
			AlertedToGrenade,
			ReactToGrenade,
			ReactToAlertFriendly,
			ReactToOtherAlert,
			NotifyBump,
			CanStepAside,
			DoStaggerBackward,
			CanInvestigate,
			DoGassed,
			DoStunned;

	function DoIncapacitated(
		Pawn	aInstigator );


	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	// 
	event BeginState()
	{
		// Goto incapacitated if there is no chance of recovering.
		if ( !CanRecoverFromActingDead() )
		{
			Global.DoIncapacitated( None );
			return;
		}

		// Flag pawn as no longer being combat able - stops enemy attacking me.
		mTerrorist.SetCombatCapable( false );

		MoveTarget	= None;
		Enemy		= None;

		Disable ( 'SeePlayer' );
		Disable ( 'HearNoise' );

		StopRepeatFiring();

		SetTimer( 0.0, false );
		StopMultiTimer( mTimerReassess );
		StopMultiTimer( mTimerSpeech );
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndState
	// 
	function EndState()
	{
		if ( mTerrorist != None )
		{
			// Flag me as being combat capable again.
			if ( mTerrorist.Health > 0 && !IsIncapacitated() )
			{
				mTerrorist.SetCombatCapable( true );
			}

			// Only allow aggressive attack mode after acting dead
			mTerrorist.mAlertAggressivePct = 1.0;
			mTerrorist.mAlertCoverPct = 0.0;
			mTerrorist.mAlertRetreatPct = 0.0;

			if ( !mTerrorist.mbCaptured )
			{
				// Keep the acting dead flag on when captured as this is used
				// to play the correct anims (the incap cuffed anims).
				mTerrorist.mbActingDead = false;

				mTerrorist.EndPlayActionAnim( 0.15 );
			}
			mTerrorist.bIgnoreSpine = false;
			mTerrorist.bDisableTurnAnims = false;

			// Restore off collision tests with other pawns
			mTerrorist.SetNonZeroExtentTraces( true );
		}

		mbHoldActingDead = false;

		SetTimer( 0.0, false );
		StopMultiTimer( mTimerReassess );
		StopMultiTimer( mTimerSpeech );

		Enable( 'SeePlayer' );
		Enable( 'HearNoise' );
	}


	///////////////////////////////////////////////////////////////////////////////
	// CanRecoverFromActingDead
	//
	// Checks if able to recover.
	function bool CanRecoverFromActingDead()
	{
		// Can only recover if have a weapon to attack with.
		if (	mSASPawn.GetWeaponOfCategory( WPNCAT_Primary ) != None ||
				mSASPawn.GetWeaponOfCategory( WPNCAT_Secondary ) != None ||
				mSASPawn.GetWeaponOfCategory( WPNCAT_Special ) != None )
		{
			return true;
		}

		return false;
	}


	///////////////////////////////////////////////////////////////////////////////
	// ReactToThreat
	//
	function ReactToThreat( 
		SASPawn			aThreat,
		EStimulusType	aeDetectionStimulus,
		bool			abNoCallBackup )
	{
		// Just update info on threat.
		UpdateThreatInfo( aThreat, aeDetectionStimulus );

		// If placed in level in act dead state then wake up on enemy sighting.
		if ( mbHoldActingDead && (aeDetectionStimulus == STIMULUS_Sight) )
		{
			GotoState( , 'ActDeadSleep' );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// Timer
	//
	event Timer()
	{
		// Try to recover. If not poosible right now then wait a short while longer.
		if ( !EndActingDead( false ) )
		{
			SetTimer( 1.0, false );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndActingDead
	//
	// Force pawn out of acting dead state.
	function bool EndActingDead(
		bool abRecoverToIdle )
	{
		// Can only recover if not being cuffed/captured.
		if ( !mTerrorist.mbCuffingStarted && !mTerrorist.mbCaptured )
		{
			// Can only recover if have a weapon.
			if ( CanRecoverFromActingDead() )
			{
				// Also can't get up yet if encroached by other pawn.
				if ( !mTerrorist.IsEncroachedByOtherPawn() )
				{
					mbHoldActingDead = false;
					mTerrorist.mbActingDead = false;
					CheckPlayingAnimFromActingDead( true );
					GotoState( , 'Recover' );
					return true;
				}
			}
			else
			{
				Global.DoIncapacitated( None );
			}
		}

		return false;
	}


	///////////////////////////////////////////////////////////////////////////////
	// MultiTimer
	// 
	event MultiTimer(
		int aTimerIdx )
	{
		switch (aTimerIdx)
		{
			case mTimerReassess:
				SetMultiTimer( mTimerReassess, RandRange(mSASPawn.mMinIncapTimer, mSASPawn.mMaxIncapTimer), true );
				mSASPawn.PlaySpeech( SPEECH_GenIncapacitated );
				break;

			case mTimerSpeech:
				mTerrorist.PlaySpeech( SPEECH_TerrAggressiveSeenThreat );
				break;

			default:
				Global.MultiTimer( aTimerIdx );
				break;
		} 
	} 


	///////////////////////////////////////////////////////////////////////////////
	// CheckPlayingAnimFromActingDead
	//
	function bool CheckPlayingAnimFromActingDead(
		bool abAnimEnd )
	{
		local name	curAnim;
		local float	frame,
					rate;

		mSASPawn.GetAnimParams( ANIMCHANNEL_Action, curAnim, frame, rate );
		if ( curAnim != mTerrorist.GetTransitionFromActingDeadAnim() )
		{
			mSASPawn.AnimateFromActingDead();
			return true;
		}
	
		return !abAnimEnd;
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyStartedCuffing
	//
	function NotifyStartedCuffing()
	{
		// Ensure this flag is set as it stops the recovery animn from getting played.
		mTerrorist.mbActingDead = true;

		if ( !mTerrorist.mbCuffingStarted )
		{
			mTerrorist.mbCuffingStarted = true;
		
			mTerrorist.PlayCuffingAnim();
			mTerrorist.ChangeAnimation();

			// Drop a weapon if holding one.
			if ( mTerrorist.Weapon != None )
			{
				mTerrorist.DropWeapon();
			}
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyStoppedCuffing
	//
	function NotifyStoppedCuffing()
	{
		if ( !mTerrorist.mbCaptured && mTerrorist.mbCuffingStarted )
		{
			mTerrorist.mbCuffingStarted = false;
			mSASPawn.PlayCuffingStopped();
			mSASPawn.ChangeAnimation();

			// Switch to incap state if no longer have a weapon to attack with.
			if ( !CanRecoverFromActingDead() )
			{
				Global.DoIncapacitated( None );
			}
			else
			{
				GotoState( , 'ActDeadSleep' );
			}
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyCaptured
	//
	function NotifyCaptured()
	{
		DoRestrained();
	}

Begin:

	mTerrorist.mbActingDead = true;
	mTerrorist.mbActingDeadCanBeCuffed = false;

	StopMoving();

	// Maintain current rotation.
	if ( mTerrorist.meStance != STANCE_Prone )
	{
		FindDirectionToGoProne();
		SetFocalPointFromDir( mProneFocalDir );
	}
	else
	{
		FixCurrentFacing();
	}
	mTerrorist.bIgnoreSpine = true;
	mTerrorist.bDisableTurnAnims = true;

	if ( !mTerrorist.mbActDeadFromStart )
	{
		if ( mTerrorist.AnimateToIncapacitated() )
		{
			mSASPawn.ZeroMovementChannelBlendAlpha();
			FinishAnim( ANIMCHANNEL_Action );
		}

		// Set up timer for screaming sounds
		SetMultiTimer( mTimerReassess, RandRange( mSASPawn.mMinIncapTimer, mSASPawn.mMaxIncapTimer ), true );
	}

	mTerrorist.mbActingDeadCanBeCuffed = true;
	mTerrorist.ChangeStanceImmediate( STANCE_Prone );
	mSASPawn.StopAnimating( true );
	mTerrorist.ChangeAnimation( true );

	Sleep( 0.1 );

	// Disable off collision tests with other pawns before changing stance
	mSASPawn.SetNonZeroExtentTraces( false );

	if ( mbHoldActingDead )
	{
		Stop;
	}

ActDeadSleep:

	mbHoldActingDead = false;
	
	SetTimer( 
		RandRange( 
				mTerrorist.mActDeadSleepTime.Min,
				mTerrorist.mActDeadSleepTime.Max ),
		false );			

	Stop;

Recover:

	// Restore off collision tests with other pawns
	mTerrorist.SetNonZeroExtentTraces( true );

	// Can no longer be cuffed.
	mTerrorist.mbActingDeadCanBeCuffed = false;

	if ( CheckPlayingAnimFromActingDead( false ) )
	{
		FinishAnim( ANIMCHANNEL_Action );
	}

	mTerrorist.ChangeStanceImmediate( STANCE_Crouched );
	Enemy = None;
	mTerrorist.SetCombatCapable( true );
	
	// Choose enemy to attack.
	SetEnemy( SelectTargetEnemy() );
	if ( Enemy != None )
	{
		if ( EngageThreat( SASPawn (Enemy) ) )
		{
			Stop;
		}
	}

	// _DI check can attack, else find cover else idle.
	Enemy = None;
	DoIdle();
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
			ReactToGrenade,
			DoStaggerBackward,
			ReactToAlertFriendly,
			CanInvestigate;

	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	// 
	event BeginState()
	{
		local float	fireDuration;

		Super.BeginState();

		ClearReaction();

		if ( mSASPawn.meStunnedAnimType == STUNANIM_SprayingFire )
		{
			mTerrorist.mbSprayFiring = true;

			fireDuration = RandRange( 
				mTerrorist.mStunnedSprayFireDuration.Min, 
				mTerrorist.mStunnedSprayFireDuration.Max );

			CheckGunSelected();
			SetWeaponFireMode( 'FIREMODE_Auto' );
			StartRepeatFiringAtPoint( Pawn.Location + Vector(Pawn.Rotation) * 1000.0,, fireDuration, true );
		}
		else
		{
			StopSprayFiring();
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndState
	// 
	event EndState()
	{
		Super.EndState();

		StopSprayFiring();
	}


	///////////////////////////////////////////////////////////////////////////////
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


	///////////////////////////////////////////////////////////////////////////////
	// CanHeadlessChicken
	//
	function bool CanHeadlessChicken()
	{
		if ( !Super.CanHeadlessChicken() )
		{
			return false;
		}

		switch ( meCurObjective )
		{
		case TERROBJ_ThreatenHostage:
		case TERROBJ_BeatingHostage:
			return false;
		}

		return true;
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyClipEmpty
	// 
	function NotifyClipEmpty()
	{
		StopSprayFiring();
	}


	///////////////////////////////////////////////////////////////////////////////
	// DoReloading
	// 
	function DoReloading(
		optional bool forceReload )
	{
		StopSprayFiring();
	}


	///////////////////////////////////////////////////////////////////////////////
	// StopSprayFiring
	// 
	function StopSprayFiring()
	{
		mTerrorist.mbSprayFiring = false;
		StopRepeatFiring();
	}
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
			CanStepAside,
			DoStaggerBackward,
			ReactToAlertFriendly,
			CanInvestigate;

	///////////////////////////////////////////////////////////////////////////////
	// CanHeadlessChicken
	//
	function bool CanHeadlessChicken()
	{
		if ( !Super.CanHeadlessChicken() )
		{
			return false;
		}
			
		switch ( meCurObjective )
		{
		case TERROBJ_ThreatenHostage:
		case TERROBJ_BeatingHostage:
			return false;
		}

		return true;
	}
}


///////////////////////////////////////////////////////////////////////////////
// STATE SprayingFire
//
state SprayingFire
{
	ignores SeePlayer, 
			HearNoise, 
			EnemyNotVisible,
			DamageAttitudeTo;

	event BeginState()
	{
		Enemy = None;

		// Maintain current direction
		FixCurrentFacing();

		StartSprayFiring();
	}

	event EndState()
	{
		StopSprayFiring();
	}

	function StartSprayFiring()
	{
		mTerrorist.mbSprayFiring = true;
		Enable( 'Tick' );

		SetWeaponFireMode( 'FIREMODE_Auto' );

		mSprayFireParams.mYawPos = 0.0;
		mSprayFireParams.mYawSpeed = 0.0;

		mSprayFireParams.mTgtYawPos = (0.75 + (FRand() * 0.25));
		if ( FRand() < 0.5 )
		{
			mSprayFireParams.mTgtYawPos = -mSprayFireParams.mTgtYawPos;
		}

		mSprayFireParams.mPitchPos = 0.0;
		mSprayFireParams.mPitchSpeed = 0.0;

		mSprayFireParams.mTgtPitchPos = (0.75 + (FRand() * 0.25));
		if ( FRand() < 0.5 )
		{
			mSprayFireParams.mTgtPitchPos = -mSprayFireParams.mTgtPitchPos;
		}
	}

	function StopSprayFiring()
	{
		mTerrorist.mbSprayFiring = false;
		mTerrorist.StopPlayFiring();
		Disable( 'Tick' );
	}

	function DoReloading(optional bool forceReload)
	{
		StopSprayFiring();	
		Pawn.Weapon.Reload();
	}

	function WeaponReadyToFire()
	{
		StartSprayFiring();
	}

	event Tick(
		float	aDeltaSeconds )
	{
		// Update target yaw speed
		mSprayFireParams.mTgtYawSpeed = (FRand() * 0.5) + 0.5;
		if ( mSprayFireParams.mTgtYawPos < mSprayFireParams.mYawPos )
		{
			mSprayFireParams.mTgtYawSpeed *= -1.0;
		}

		// Update yaw speed
		if ( mSprayFireParams.mYawSpeed < mSprayFireParams.mTgtYawSpeed )
		{
			mSprayFireParams.mYawSpeed += 4 * aDeltaSeconds;
			mSprayFireParams.mYawSpeed = FMin( mSprayFireParams.mYawSpeed, mSprayFireParams.mTgtYawSpeed );
		}
		else
		{
			mSprayFireParams.mYawSpeed -= 4 * aDeltaSeconds;
			mSprayFireParams.mYawSpeed = FMax( mSprayFireParams.mYawSpeed, mSprayFireParams.mTgtYawSpeed );
		}

		// Update yaw pos
		mSprayFireParams.mYawPos += mSprayFireParams.mYawSpeed * aDeltaSeconds;

		// Check if reached tgt yaw pos 
		if ( mSprayFireParams.mTgtYawPos > 0.0 )
		{
			if ( mSprayFireParams.mYawPos > mSprayFireParams.mTgtYawPos )
			{
				mSprayFireParams.mTgtYawPos = -0.5 - (FRand() * 0.5);
			}
		}
		else
		{
			if ( mSprayFireParams.mYawPos < mSprayFireParams.mTgtYawPos )
			{
				mSprayFireParams.mTgtYawPos = 0.5 + (FRand() * 0.5);
			}
		}
		mSprayFireParams.mYawPos = FClamp( mSprayFireParams.mYawPos, -1.0, 1.0 );


		// Update target pitch speed
		mSprayFireParams.mTgtPitchSpeed = (FRand() * 0.5) + 0.5;
		if ( mSprayFireParams.mTgtPitchPos < mSprayFireParams.mPitchPos )
		{
			mSprayFireParams.mTgtPitchSpeed *= -1.0;
		}

		// Update yaw speed
		if ( mSprayFireParams.mPitchSpeed < mSprayFireParams.mTgtPitchSpeed )
		{
			mSprayFireParams.mPitchSpeed += 4 * aDeltaSeconds;
			mSprayFireParams.mPitchSpeed = FMin( mSprayFireParams.mPitchSpeed, mSprayFireParams.mTgtPitchSpeed );
		}
		else
		{
			mSprayFireParams.mPitchSpeed -= 4 * aDeltaSeconds;
			mSprayFireParams.mPitchSpeed = FMax( mSprayFireParams.mPitchSpeed, mSprayFireParams.mTgtPitchSpeed );
		}

		// Update yaw pos
		mSprayFireParams.mPitchPos += mSprayFireParams.mPitchSpeed * aDeltaSeconds;

		// Check if reached tgt yaw pos 
		if ( mSprayFireParams.mTgtPitchPos > 0.0 )
		{
			if ( mSprayFireParams.mPitchPos > mSprayFireParams.mTgtPitchPos )
			{
				mSprayFireParams.mTgtPitchPos = -0.5 - (FRand() * 0.5);
			}
		}
		else
		{
			if ( mSprayFireParams.mPitchPos < mSprayFireParams.mTgtPitchPos )
			{
				mSprayFireParams.mTgtPitchPos = 0.5 + (FRand() * 0.5);
			}
		}
		mSprayFireParams.mPitchPos = FClamp( mSprayFireParams.mPitchPos, -1.0, 1.0 );
	
		mTerrorist.PlaySprayFiring( 
			mSprayFireParams.mYawPos, 
			mSprayFireParams.mPitchPos,
			1.0 /*SASWeapon( Pawn.Weapon ).mSingleFireAnimRate*/ );

		if ( !Pawn.Weapon.IsFiring() )
		{
			mTerrorist.Weapon.BotFire( false );
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// STATE GuardingHostageState
// 
state GuardingHostageState extends MovingState
{
	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	// 
	event BeginState()
	{
		if ( mTerrorist.mHostageTarget == None )
		{
			// _DI check can attack, else find cover else idle.
			DoIdle();
		}

		StopMultiTimer( mTimerSpeech );
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndState
	// 
	event EndState()
	{
		Super.EndState();

		mSASPawn.StopAiming();
		Pawn.ChangeAnimation();

		StopMultiTimer( mTimerSpeech );
	}


	///////////////////////////////////////////////////////////////////////////////
	// MultiTimer
	// 
	event MultiTimer(
		int	aTimerIdx )
	{
		switch( aTimerIdx )
		{
		case mTimerSpeech:
			CheckPlayStandoffSpeech();
			break;

		default:
			Global.MultiTimer( aTimerIdx );
			break;
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// InitStandoffSpeech
	// 
	function InitStandoffSpeech()
	{
		local int	i,
					numSamples,
					randIdx;

		// Initialise speech order.
		mHostageStandoffSpeechOrder.Length = 0; 
		mHostageStandoffSpeechOrderIdx = 0;
		if ( mTerrorist.mVoice != None )
		{
			numSamples = SASTerroristVoice( mTerrorist.mVoice ).mHostageStandoffSounds.Length;
			for ( i = 0; i < numSamples; ++i )
			{
				if ( i == 0 )
				{
					randIdx = 0;
				}
				else
				{
					randIdx = Rand( mHostageStandoffSpeechOrder.Length + 1 ); 
				}
				mHostageStandoffSpeechOrder.Insert( randIdx, 1 );
				mHostageStandoffSpeechOrder[randIdx] = i;
			}
		}

		SetMultiTimer( mTimerSpeech, RandRange( 2.0, 3.5 ), false );
	}

	
	///////////////////////////////////////////////////////////////////////////////
	// CheckPlayStandoffSpeech
	// 
	function CheckPlayStandoffSpeech()
	{	
		local int	soundIdx;
		local float duration;

		if ( mHostageStandoffSpeechOrder.Length > 0 )
		{
			// Check there are visible threats in range.
			if ( HasVisibleThreatsInRange( mTerrorist.mHostageStandoffSpeechRange ) )
			{
				soundIdx = mHostageStandoffSpeechOrder[mHostageStandoffSpeechOrderIdx];

				mTerrorist.PlaySpeech( 
							SPEECH_TerrHostageStandoff, 
							true, 
							soundIdx+1 );

				// Increment speech order array index.
				mHostageStandoffSpeechOrderIdx = (mHostageStandoffSpeechOrderIdx+1) 
													% mHostageStandoffSpeechOrder.Length; 

				// Don't play next speech until this sample duration plus a bit.
				duration = GetSoundDuration( 
					SASTerroristVoice( mTerrorist.mVoice ).mHostageStandoffSounds[soundIdx] );
				duration += RandRange( 3.0, 5.0 );
				SetMultiTimer( mTimerSpeech, duration, false );
			}
			else
			{
				// No visible threats in range, check again later.
				SetMultiTimer( mTimerSpeech, RandRange( 1.2, 2.4 ), false );
			}
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// CanInvestigate
	// 
	event bool CanInvestigate()
	{
		return false;
	}


	///////////////////////////////////////////////////////////////////////////////
	// ReactToThreat
	//
	function ReactToThreat( 
		SASPawn			aThreat,
		EStimulusType	aeDetectionStimulus,
		bool			abNoCallBackup )
	{
		UpdateThreatInfo( aThreat, aeDetectionStimulus );
	}


	///////////////////////////////////////////////////////////////////////////////
	// ReactToGrenade
	//
	event ReactToGrenade(
		SASGrenadeProjectile	aGrenade )
	{
		// Stop guarding hostage when reacting to grenades.
		mTerrorist.mHostageTarget.EndGuardedByTerrorist();
		mTerrorist.mHostageTarget = None;

		Global.ReactToGrenade( aGrenade );
	}


	///////////////////////////////////////////////////////////////////////////////
	// DamageAttitudeTo
	// 
	// Called on taking damage to instigate a response.
	function DamageAttitudeTo(
		Pawn	aOther,			// Pawn that damaged us (eg. Pawn that fired the weapon) 
		float	aDamage )		// Damage amount
	{
		local SASPawn	aOtherSASPawn;

		Super(SASFighterController).DamageAttitudeTo( aOther, aDamage );

		// If damager pawn is an enemy then set it as our next target and 
		// wait for a reaction time before responding.
		// TODO: Response due to friendly fire.
		aOtherSASPawn = SASPawn( aOther );
		if ( /*(aDamage > 0) &&*/ (aOtherSASPawn != None) && mTerrorist.IsAThreat( aOtherSASPawn ) )
		{
			UpdateThreatInfo( aOtherSASPawn, STIMULUS_Damage );
			InitReaction( TERRREACT_EngageEnemy, aOtherSASPawn );
			CompleteReaction();
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// TargetLost
	// 
	event TargetLost()
	{
		if ( mTerrorist.mHostageTarget != None 
			&& mTerrorist.mHostageTarget.Health > 0 )
		{
			Target = mTerrorist.mHostageTarget;
		}
		else
		{
			// _DI check can attack, else find cover else idle.
			DoIdle();
		}
		mTerrorist.mInterestItem = Target;
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyKilled
	// 
	// Check if killed pawn is the hostage we are threatening.
	function NotifyKilled(
		Controller	aKiller,
		Controller	aKilled,
		Pawn		aOther )
	{
		Global.NotifyKilled( aKiller, aKilled, aOther );

		if ( aOther == mTerrorist.mHostageTarget )
		{
			// Leave state - goto idle for now 'til AI overhaul done.
			// _DI check can attack, else find cover else idle.
			DoIdle();
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyWeaponFired
	// 
	function NotifyWeaponFired()
	{
		local SASHostage	hostage;
		local Vector		momentum;
		local SASAmmo		wpnAmmoType;
		local float			momentumMagnitude;

		Global.NotifyWeaponFired();

		// If target is our guarded hostage then kill them.
		if ( mTerrorist.Weapon != None && Target == mTerrorist.mHostageTarget )
		{		
			hostage = mTerrorist.mHostageTarget;
			wpnAmmoType = SASAmmo( mTerrorist.Weapon.AmmoType );
				
			momentumMagnitude = wpnAmmoType.MaxDamage;
			if ( momentumMagnitude == 0 )
			{
				momentumMagnitude = wpnAmmoType.Damage;
			}
			momentumMagnitude = Max( momentumMagnitude, 10 );
			momentum = hostage.Location - mTerrorist.Location;
			momentum = Normal( momentum ) * momentumMagnitude;

			hostage.TakeDamage( 
				hostage.Health+1, 
				mTerrorist, 
				hostage.Location,
				momentum,
				wpnAmmoType.MyDamageType,
				mTerrorist.Weapon );
		}
	}

	function DoGassed( float duration )
	{
		// Stop guarding hostage when getting gassed.
		mTerrorist.mHostageTarget.EndGuardedByTerrorist();
		mTerrorist.mHostageTarget = None;

		Super.DoGassed( duration );
	}

	function DoStunned( float duration )
	{
		// Stop guarding hostage when getting stunned.
		mTerrorist.mHostageTarget.EndGuardedByTerrorist();
		mTerrorist.mHostageTarget = None;

		Super.DoStunned( duration );
	}
}


///////////////////////////////////////////////////////////////////////////////
// STATE ThreateningHostage
//
state ThreateningHostage extends GuardingHostageState
{
	ignores HearNoise, 
			EnemyNotVisible,
			ReactToAlertFriendly,
			DoStaggerBackward;

	///////////////////////////////////////////////////////////////////////////////
	// EndState
	// 
	event EndState()
	{
		Super.EndState();
		StopRepeatFiring();
	}


	///////////////////////////////////////////////////////////////////////////////
	// NotifyBump
	// 
	event bool NotifyBump(
		Actor	aOther )
	{
		// TODO: If circling hostage, sleep and then try to move again.

		return false;
	}


	///////////////////////////////////////////////////////////////////////////////
	// Timer
	// 
	// Use timer to check if threats have come too close - if so then shoot hostage.
	event Timer()
	{
		if ( HasVisibleThreatsInRange( mTerrorist.mHostageKillRangeFromThreat ) )
		{
			SetTimer( 0.0, false );
			GotoState( , 'KillHostage' );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// GetBestShieldedPosition
	// 
	// Updates the position which besat shileds from the enemy behind the hostage.
	function GetBestShieldedPosition()
	{
		local int		i;
		local int		numThreats;
		local float		dist;
		local float		weight;
		local float		tmp, dp, cosAng, sinAng;
		local Vector	dirShield;
		local Vector	accumDir;
		local Vector	dirHosToTerr;
		local Vector	cp;

		// First check to see if any of our detected threats are the player - primarily
		// shield against player if within range.
		for ( i = 0; i < mNumThreats; ++i )
		{
			if ( (mThreats[i].Pawn != None) 
				&& (mThreats[i].Pawn.Controller != None) 
				&& (mThreats[i].Pawn.Controller.mType == CONTROLLER_Player) )
			{
				if ( (VSizeSq( mTerrorist.mHostageTarget.Location - mThreats[i].Pawn.Location ) < Square(480.0))
					&& mSASPawn.PawnIsVisible( mThreats[i].Pawn ) )
				{
					dirShield = Normal( mTerrorist.mHostageTarget.Location - mThreats[i].Pawn.Location );
					numThreats = 1;
					break;
				}
			}
		}

		// If numThreats not equal to 0 then we have chosen to shield against player only.
		if ( numThreats == 0 )
		{
			for ( i = 0; i < mNumThreats; ++i )
			{
				if ( (VSizeSq( mTerrorist.mHostageTarget.Location - mThreats[i].Pawn.Location ) < Square(480.0))
					&& mSASPawn.PawnIsVisible( mThreats[i].Pawn ) )
				{
					dirShield = mTerrorist.mHostageTarget.Location - mThreats[i].Pawn.Location;
					dist = VSize( dirShield );
					dirShield /= dist;
					
					// Weight dir by closeness of enemy
					weight = FClamp( dist / 1000.0, 0.0, 1.0 );
					weight = 1.0 - weight;
					dirShield *= weight;

					accumDir += dirShield;
					numThreats++;
				}
			}

			if ( VSizeSq( accumDir ) > 0 )
			{
				dirShield = Normal( accumDir );
			}
			else
			{
				mHostageShieldPos = mTerrorist.Location;
				return;
			}
		}

		// Now have direction vector from hostage which we need to line up with.
		
		dirHosToTerr = Normal( mTerrorist.Location - mTerrorist.mHostageTarget.Location );

		dp = dirHosToTerr Dot dirShield;

		if ( dp < 0.7071 /*cos(45)*/ )
		{
			cosAng = 0.7071;
			sinAng = 0.7071;

			// Rotate left or right?
			cp = dirHosToTerr Cross dirShield;
			if ( cp.Z < 0.0 )
			{
				// Rotate right
				sinAng = -sinAng;
			}

			// Clamp tgt dir to 45deg from current dir.
			tmp = dirShield.X;
			dirShield.X = cosAng * dirShield.X	- sinAng * dirShield.Y; 
			dirShield.Y = sinAng * tmp			+ cosAng * dirShield.Y;
		}
		
		mHostageShieldPos = mTerrorist.mHostageTarget.Location + (dirShield * 60.0);
	}

Begin:

	CheckGunSelected();

MoveToHostage:

	DoMoveToActor( mTerrorist.mHostageTarget,,,,, 24.0 );

MTP_FinishedMove:

	// Face hostage
	SetFocus( mTerrorist.mHostageTarget );
	FinishRotation();

	// Aim at hostages head.
	// GP: Aiming not currently working when not firing/trying to fire.
	mSASPawn.mbAiming = true;
	Target = mTerrorist.mHostageTarget;
	mTargetBone = 'Bip01 Head';

	mSASPawn.SetPace( PACE_Walking );

	// Set timer to assess whether to kill hostage.
	SetTimer( 0.5, true );

	// Start timer for playing standoff speech.
	InitStandoffSpeech();

UsingHostageAsShield:

	GetBestShieldedPosition();
	MoveTo( mHostageShieldPos, mTerrorist.mHostageTarget,, Pawn.mePace );
	Sleep( 0.0 );
	Goto( 'UsingHostageAsShield' );
	Stop;

KillHostage:

	// Start firing.
	Target =  mTerrorist.mHostageTarget;
	SetWeaponFireMode( 'FIREMODE_Auto' );
	StartRepeatFiring();
	Stop;
}


///////////////////////////////////////////////////////////////////////////////
// STATE BeatingHostage
// 
state BeatingHostage extends GuardingHostageState
{
	ignores HearNoise, 
			EnemyNotVisible,
			ReactToAlertFriendly,
			DoStaggerBackward;

	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	// 
	event BeginState()
	{
		SetTimer( 0.0, false );
		StopMultiTimer( mTimerReassess );

		Super.BeginState();
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndState
	// 
	event EndState()
	{
		Super.EndState();
		mTerrorist.EndPlayActionAnim( 0.3 );
		
		SetTimer( 0.0, false );
		StopMultiTimer( mTimerReassess );
	}


	///////////////////////////////////////////////////////////////////////////////
	// Timer
	// 
	event Timer()
	{
		local bool		bKillHostage;
		local SASPawn	closestThreat;

		if ( mBeatingHostageInPlayerViewCtr > 0 )
		{
			mBeatingHostageInPlayerViewCtr = mBeatingHostageInPlayerViewCtr+1;

			if (	(mBeatingHostageInPlayerViewCtr > 3) ||
					((mBeatingHostageInPlayerViewCtr > 2) && (FRand() > mTerrorist.mBeatHostageTwiceChance)) )
			{
				bKillHostage = true;
			}
			else
			{
				closestThreat = GetClosestThreat();
				if (	(closestThreat != None) && 
						(VSizeSq( closestThreat.Location - Pawn.Location ) < Square( mTerrorist.mBeatHostageTwiceMinDist )) )
				{
					bKillHostage = true;
				}
			}

			if ( bKillHostage )
			{
				GotoState( , 'KillHostage' );
				return;
			}
		}

		GotoState( , 'ApplyBeating' );
	}


	///////////////////////////////////////////////////////////////////////////////
	// MultiTimer
	// 
	// Used to check if squad is too close.
	event MultiTimer(
		int	aTimerIdx )
	{
		switch ( aTimerIdx )
		{
		case mTimerReassess:
			if ( HasVisibleThreatsInRange( mTerrorist.mHostageKillRangeFromThreat ) )
			{
				// Turn off kill delay time when kill instigated by player getting too close.
				mTerrorist.mHostageBeatingKillDelay.Min = 0.0f;
				mTerrorist.mHostageBeatingKillDelay.Max = 0.0f;
				GotoState( , 'KillHostage' );
			}
			break;

		default:
			Global.MultiTimer( aTimerIdx );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// AnimEnd
	// 
	event AnimEnd(
		int	aChannel )
	{
		if ( aChannel == ANIMCHANNEL_Action )
		{
			mTerrorist.EndPlayActionAnim( 0.3 );
		}
		else
		{
			mSASPawn.AnimEnd( aChannel );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// BeatHostage
	// 
	function BeatHostage()
	{
		local name	hitAnim;
		local float	duration;
		local name	hostageState;

		// Be sure we are facing hostage first.

		hostageState = mTerrorist.mHostageTarget.Controller.GetStateName();
		if ( hostageState == 'TakingBeating' )
		{
			// Choose random beating anim.
			hitAnim = mTerrorist.ChooseBeatHostageAnim();
			if ( hitAnim != 'None' )
			{
				// Tell hostage to play the equivalent being hit anim.
				if ( SASHostageController( mTerrorist.mHostageTarget.Controller ).Whack( hitAnim ) )
				{ 
					mTerrorist.PlayActionAnim( hitAnim, 1.0, 0.2, true );

					// Set timer to duration of the hostages animation. Use this to trigger next hit.
					duration = mTerrorist.mHostageTarget.GetAnimDuration( ANIMCHANNEL_Action );
					SetTimer( duration, false );
				}
				else
				{
					GotoState( , 'KillHostage' );
				}
			}
		}
		else
		{
			GotoState( , 'ApplyBeating' );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// SeenByPlayer
	//
	function SeenByPlayer(
		Pawn	aPlayerPawn )
	{
		if ( mBeatingHostageInPlayerViewCtr == 0 )
		{
			mBeatingHostageInPlayerViewCtr = 1;
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// RequestWeaponPose
	//
	// Returns the weapon pose the pawn should be using. 
	function EWpnHoldingPose RequestWeaponPose()
	{
		return WPNPOSE_PortedLow;
	}


Begin:

	Target = None;
	CheckGunSelected();

MoveToHostage:

	// Set timer to check for squad getting too close.
	SetMultiTimer( mTimerReassess, 0.25, true );

	DoMoveToActor( mTerrorist.mHostageTarget,,,,, 20.0 );

MTP_FinishedMove:

	// TODO: Check move succeeded

	// Face hostage
	SetFocus( mTerrorist.mHostageTarget );
	FinishRotation();

	InitStandoffSpeech();

	mTerrorist.mbAiming = false;

ApplyBeating:

	Sleep( RandRange( mTerrorist.mHostageBeatingInterval.Min, mTerrorist.mHostageBeatingInterval.Max ) );
	BeatHostage();
	Stop;

KillHostage:

	SetTimer( 0.0, false );
	StopMultiTimer( mTimerReassess );
	StopMultiTimer( mTimerSpeech );

	Sleep( RandRange( mTerrorist.mHostageBeatingKillDelay.Min, mTerrorist.mHostageBeatingKillDelay.Max ) ); 

KillHostageNoDelay:

	// Start firing.
	mTerrorist.mbAiming = true;
	Target =  mTerrorist.mHostageTarget;
	SetWeaponFireMode( 'FIREMODE_Auto' );
	StartRepeatFiring();
	Stop;
}


function StartScripting()
{
	// If the script is latent (takes time to complete) then clear the current reaction.
	if ( mScriptInterface.mScript.mbLatent )
	{
		Enemy = None;
		ClearReaction();
	}

	Super.StartScripting();
}



state Scripting
{
	ignores DoStaggerBackward;

	event BeginState()
	{
		Super.BeginState();

		SetMultiTimer( mTimerReassess, 0.33, true );
	}

	event EndState()
	{
		Super.EndState();

		StopMultiTimer( mTimerReassess );
	}

	///////////////////////////////////////////////////////////////////////////////
	// SeePlayer
	// 
	event SeePlayer(
		Pawn	aSeenPlayer )
	{
		local SASPawn	seenSASPawn;

		// If seen pawn is an enemy then set it as our next target and 
		// wait for a reaction time before responding.
		seenSASPawn = SASPawn( aSeenPlayer );
		if ( (seenSASPawn != None) && mTerrorist.IsAThreat( seenSASPawn ) )
		{
			UpdateThreatInfo( seenSASPawn, STIMULUS_Sight );

			if ( !mScriptInterface.mbEngageWhileScripting )
			{
				InitReaction( TERRREACT_EngageEnemy, seenSASPawn );
			}
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// HearNoise
	// 
	event HearNoise(
		float		aLoudness,		
		Actor		aNoiseMaker,		
		ENoiseType	aeNoiseType,
		Vector		aNoiseLoc )
	{
		local SASPawn	noiseMakerSASPawn;

		if ( !mScriptInterface.mbEngageWhileScripting )
		{
			Global.HearNoise( aLoudness, aNoiseMaker, aeNoiseType, aNoiseLoc );
			return;
		}

		// Add to threats list if is enemy and have line of sight to it.
		noiseMakerSASPawn = SASPawn( aNoiseMaker );
		if (	(noiseMakerSASPawn != None) && 
				mTerrorist.IsAThreat( noiseMakerSASPawn ) && 
				CanSeePawn( noiseMakerSASPawn ) )
		{
			UpdateThreatInfo( noiseMakerSASPawn, STIMULUS_Noise );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// DamageAttitudeTo
	// 
	function DamageAttitudeTo(
		Pawn	aOther,
		float	aDamage )
	{
		local SASPawn	otherSASPawn;

		if ( !mScriptInterface.mbEngageWhileScripting )
		{
			Global.DamageAttitudeTo( aOther, aDamage );
			return;
		}

		otherSASPawn = SASPawn( aOther );
		if ( (otherSASPawn != None) 
			&& mTerrorist.IsAThreat( otherSASPawn ) )
		{
			UpdateThreatInfo( otherSASPawn, STIMULUS_Damage );
		}
	}

	
	///////////////////////////////////////////////////////////////////////////////
	// NotifyBump
	// 
	event bool NotifyBump(
		Actor	aOther )
	{
		local SASPawn	bumpedPawn;

		if ( mbCanSee || mbCanFeelDamage )
		{
			return Global.NotifyBump( aOther );
		}

		bumpedPawn = SASPawn( aOther );
		if ( (bumpedPawn != None) && mSASPawn.IsAThreat( bumpedPawn ) )
		{
			UpdateThreatInfo( bumpedPawn, STIMULUS_Bump ); 
		}

		return Super(SASAIController).NotifyBump( aOther );
	}

	function ChooseEnemy(
		optional bool abExcludeCurrent )
	{
		local int	i;
		local Pawn	closest;
		local float	distSq, closestDistSq;

		if ( !abExcludeCurrent && (Enemy != None) )
		{
			if ( CanSeePawn( SASPawn( Enemy ) ) )
			{
				return;
			}
		}

		for ( i = 0; i < mNumThreats; ++i )
		{
			if ( (mThreats[i].Pawn != None) && (mThreats[i].Pawn != Enemy) )
			{
				distSq = VSizeSq( mThreats[i].Pawn.Location - mTerrorist.Location ); 
				if ( (closest == None) || (distSq < closestDistSq) )
				{
					if ( IsThreatVisible( i ) )
					{
						closest = mThreats[i].Pawn;
						closestDistSq = distSq;
					}
				}
			}
		}

		if ( closest != None )
		{
			SetEnemy( closest );
		}
	}

	event EnemyNotVisible()
	{
		ChooseEnemy( true );
	}


	event MultiTimer(
		int	aTimerIdx )
	{	
		switch ( aTimerIdx )
		{
		case mTimerReassess:
			if ( mScriptInterface.mbEngageWhileScripting )
			{
				ChooseEnemy( false );
			}
			break;

		default:
			Super.MultiTimer( aTimerIdx );
		}
	}
}


//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mType=3
}