/* TPAIController - base NPC AI Controller for Turning Point */

//class TPAIController extends AIController
class TPAIController extends KynapseAIController
	dependson(TPSquad)
	dependson(TPAnimNodeBlendByCoverTransitionAction)
	dependson(TPTuneData)
	native
	config(Game);

//***********************************************************************
// INCLUDES
//***********************************************************************












 







































#linenumber 14























































































































 



#linenumber 15








#linenumber 16


//***********************************************************************
// Macros
//***********************************************************************






//`define MOVELOG(c) 

//`define AILOGD(l,c,t)


var const bool m_bUpdateSkelWhenNotRendered;
var const bool m_bIgnoreControllersWhenNotRendered;

//***********************************************************************
// enum Declarations
//***********************************************************************
enum EMoveGoalType
{
	emgtToActor,
	emgtToActorPlusWorldOffset,
	emgtToPoint
};

enum EHighLevelAiGoal
{
	HighLevelAiGoal_NONE,
	HighLevelAiGoal_MoveToAndDefendCoverGoal,		// added
	HighLevelAiGoal_AttackUsingCoverGroupGoal,		// added
	HighLevelAiGoal_MoveToActorGoal,				// added
	HighLevelAiGoal_NonKynapseMoveToActorGoal,		// Added
	HighLevelAiGoal_FreeAttackGoal,					// added
	HighLevelAiGoal_FollowActorGoal,				// added
	HighLevelAiGoal_MultiTierAttackUsingCoverGoal,  // added
	HighLevelAiGoal_AttackAsTerminatorGoal,			// added
	HighLevelAiGoal_BeASniperGoal,					// added
	HighLevelAiGoal_MantleCoverGoal				// added
}; 


enum eUniformResponse
{
	UniformResponse_Ignore,
	UniformResponse_Challenge,
	UniformResponse_Attack,
};

enum eBluffExpression
{
	Expression_Surprise,
	Expression_Contempt,
	Expression_Respect,
	Expression_Cowering
};

enum eMove2CoverStatus
{
	Move2CovStat_None,
	Move2CovStat_BuildingPath,
	Move2CovStat_PathBuiltWaitingToMove,
	Move2CovStat_NoPathBuiltWaitingToMove,        // not path before travel state
	Move2CovStat_FailedNoPath,  // not path after going to  travel state
	Move2CovStat_Moving,
	Move2CovStat_DoneTravelingAndTransitioningIntoCover,
	Move2CovStat_DoneMovingAtCover,
	Move2CovStat_FailedBlockedByPawn,
	Move2CovStat_FailedBlockedByActor,
	Move2CovStat_FailedFireFightEngageNeeded,
	Move2CovStat_FailedCQB_Needed,
	Move2CovStat_FailedEnemyBehindTurret,
	Move2CovStat_FailedEnemyMadeCoverInvalid,
	Move2CovStat_PausedGrenadeOut,			// I responded to gren and now I need re path and start over
	Move2CovStat_PausedUnknown				// somehow things went really bad and I need to start over
};

enum eUseFightingPositionStatus
{
	UseFightingPosition_None,
	UseFightingPosition_CurrentlyUsing,
	UseFightingPosition_FailedBecauseForgotIt,		// somehow the coer to use was invalidated
	UseFightingPosition_SucceededBecauseTimePassed,	// Sucssfully used the fighting positiong for the time told
	UseFightingPosition_FailedAngleToEnemy,			// The current enemy moved passed the point where the cover provided valid coverage
	UseFightingPosition_FailedNoLineOfFireToEnemy,	// The current enemy moved somewhere I can not get a good LOF on him
	UseFightingPosition_FailedDistanceToEnemy,		// The current enemy moved too close for the cover to be valid anymore
	UseFightingPosition_PausedEnemyIsAtCQB_Dist,	// The current enemy got so close that it is time to enter CQB
	UseFightingPosition_PausedGrenadeOut			// I responded to gren and now I need to get back to cover
};

enum eSniperType
{
	SniperType_PinPoint,
	SniperType_Track,
	SniperType_Zone
};

enum eMantleAction
{
	MantleAction_None,
	MantleAction_Vaulting,
	MantleAction_VaultMedium,
	MantleAction_VaultHigh,
	MantleAction_VaultMantling,
	MantleAction_MantlingLow,
	MantleAction_MantlingMedium,
	MantleAction_JumpDown
};

enum eJumpDownSubState
{
	JumpDown_None,
	JumpDown_Started,
	JumpDown_HorizontalOut,
	JumpDown_TransitionToVertical,
	JumpDown_VerticalFall,
	JumpDown_HitBottom,
	JumpDown_DeathFromAbove
};

enum eScriptedCoverBehavior
{
	ScriptedCoverBehavior_None,
	ScriptedCoverBehavior_WaveOn,
	ScriptedCoverBehavior_PeakUp,
	ScriptedCoverBehavior_PeakLeft,
	ScriptedCoverBehavior_PeakRight,
 	ScriptedCoverBehavior_StraightAhead

};

enum eResponseToGrenadeSubBehavior
{
	GrenResposeBeh_HaveNotChosenResponse,
	GrenResposeBeh_NotGoingToRespond,
	GrenResposeBeh_RunAway,
	GrenResposeBeh_Cower,
	GrenResposeBeh_JumpOverCover,
	GrenResposeBeh_ThrowBack
};

enum eThreatType
{
	ThreatType_None,
	ThreatType_Grenade
};

enum eRequiredMovementForEngagement // THE IRON CROSS THAT IS USED TO SLICE THE PIE
{
	RequiredMove4Engage_None,
	RequiredMove4Engage_Travel,
	RequiredMove4Engage_StepCloseLeft,
	RequiredMove4Engage_StepCloseRight,
	RequiredMove4Engage_StepCloseForward,
	RequiredMove4Engage_StepCloseBack,
	RequiredMove4Engage_StepLeft,
	RequiredMove4Engage_StepRight,
	RequiredMove4Engage_StepForward,
	RequiredMove4Engage_StepBack,
	RequiredMove4Engage_StepLongLeft,
	RequiredMove4Engage_StepLongRight,
	RequiredMove4Engage_StepLongForward,
	RequiredMove4Engage_StepLongBack,
	RequiredMove4Engage_StepFarLeft,
	RequiredMove4Engage_StepFarRight,
	RequiredMove4Engage_StepFarForward,
	RequiredMove4Engage_StepFarBack,
	RequiredMove4Engage_StandUp
};

enum eBlimpWarriorState
{
	BlimpWarriorState_NotInBlimp,
	BlimpWarriorState_Idle,
	BlimpWarriorState_Attack,
	BlimpWarriorState_Rappel,
	BlimpWarriorState_Gunner,
	BlimpWarriorState_Dying
};

enum eBlimpAttackSubState
{
	BlimpAttackSubState_NotAttackingAtAll,
	BlimpAttackSubState_StandingNotAttacking,
	BlimpAttackSubState_StandingAttacking,
	BlimpAttackSubState_CrouchingNotAttacking,
	BlimpAttackSubState_CrouchingAttacking,
	BlimpAttackSubState_TransitioningFromStandToCrouch,
	BlimpAttackSubState_TransitioningFromCrouchToStand,
	BlimpAttackSubState_StandingReload,
	BlimpAttackSubState_CrouchReload
};

// enum AB_Action {AB_Idle, AB_Attack, AB_Rappel, AB_Gunner};


//***********************************************************************
// struct Declarations
//***********************************************************************


struct native MoveGoalInfo
{
	var Actor goalActor;									/** Actor that represents this goal */
	var Controller goalController;							/** Controller for the actor that represents this goal */
	var bool bInterruptable;								/** Can this move be interrupted by enemy detection? */
	var bool bInterruptAndContinue;							/** Can this move be interrupted by enemy detection? and then continue moving when enemy is killed in a righteous manner*/
	var bool bReachable;									/** Is GoalActor known to be directly reachable? */
	var byte moveAttempts;									/** How many attempts have been made to reach this move target */
	var int maxBlockedPathAttempts;							/** number of times to try to path before timing out **/
	var Vector loc;											/** situationally dependent meaning based on movetype **/
	var EMoveGoalType movetype;								/** type of move to (to actor, to point, to actor plus offset) */
	var bool bKismetCommand;								/** This move goal was executed from a kismet command */
	var bool bTookBump;										/** Ran into something durring the Kynapse Part of the Latent State */
	var bool bTookHit;										/** Some one shot me durring the Kynapse Part of the Latent State */
	var bool m_bAllowedToWander;							/** Can the NPC wander while waiting for the Path to clear */
	var bool m_bAllowWaitingForPathToClear;					/** If the path is blocked when the move to actor goal starts can I wait some time to see if the path clears */
	var float m_TimeToWaitForPathToClear;					/** time to see if the path clears if negitive will wait forever */
	var float m_TimeStartedToWaitForPathToClear;

	var bool m_bAllowCheckForGoalBlocked;					/** Allow checking to see if the final destenation of the move if blocked by an pawn when I get close */
	var bool m_bGoalBlockedByPawn;							/** Is the destenation of the move blocked by a pawn that might move out of the way */
	var float m_UpdateTimeToCheckForPawnBlockingGoal;		/** Update time to see if the destenation is blocked by a pawn */
	var float m_DistenceAwayToWaitIfGoalBlocked;			/** The distance to approach the goal and wait for the blocking pawn the get the hell out of your way */
};

struct native RouteGoalInfo
{
	var Route GoalRoute;			/** Actual route actor containing move information */
	var int MoveDirection;			/** Current move direction (1 or -1), for ERT_Loop */
	var bool bInterruptable;		/** Is this route move interruptable? */
};

/**
 */
struct native InvalidatedMoveGoalInfo
{
	var Actor	m_InvalidGoal;			/** the invalidated goal */
	var int		m_SlotIdx;				/** the invalidated slot at the goal */
	var float	m_InvalidatedTime;		/** time this goal was invalidated - for time tracking */
};

struct native InvalidatedCQB_TargetInfo
{
	var Pawn	m_InvalidTarget;			/** the invalidated goal */
	var float	m_InvalidatedTime;		/** time this goal was invalidated - for time tracking */
};




/**
 * Contains all known information about the given player, updated as new
 * information is made available.
 */
struct native PlayerInfo
{
	var	Controller Player;				/** Player this data is associated with it */
	var bool bFriendly;					/** Are they friendly to us? */
	var bool bVisible;					/** Are they currently visible? */
	var float LastSeenTime;				/** Last time they were considered visible */
	var vector LastSeenLocation;		/** Last location they were seen at */
	var float PerceptionTimer;			/** Time remaining until we update PerceivedLocation with LastSeenLocation */
	var vector PerceivedLocation;		/** Currently perceived location, based on reaction times, etc */
	var float LastPerceivedTime;		/** Last time PerceptionTimer expired, used for aiming etc */
	//var bool bAudible;					/** Are they currently audible? */
	//var float LastHeardTime;			/** Last time they were considered audible */
	//var vector LastHeardLocation;		/** Last location they were heard at */
	var bool bPotentiallyVisible;		/** Are they currently potentially visible? */
	var float LastPotentiallySeenTime;	/** Last time they were considered potentially visible */
	//var bool bHostile;					//We consider this enemy hostile.
	var float LastSuccessfulBluffTime;
};


/**
 * Contains all the relevant information pertaining to a noise generation event.
 */
struct native NoiseInfo
{

	var Actor NoiseMaker;			/** Actor that generated the noise event */
	var float Loudness;				/** Loudness of the noise that was generated */
	var float HeardTime;			/** Time at which the noise event occured */
	var vector HeardLocation;		/** Location at which the noise event occured */
};

/**
 * Contains all the relevant information pertaining to a threat generation event.
 */
struct native ThreatInfo
{
	var Actor ThreatMaker;			/** Actor that generated the danger event: ie Grenade */
	var float ThreatLevel;			/** Threat Level of the Danger Event that was generated */
	var float AwarenessTime;		/** Time at which the danger event occured */
	var vector ThreatLocation;		/** Location at which the danger event occured */
	var eThreatType ThreatType;
};


/**
 */
struct native EnemyListInfo
{
    var int playerListIdx;
    var Controller enemy;
    var int numTargettedByMembers;
};


//========================================================================================================================================================
//========================================================================================================================================================
//============= AI STATE CHART BEHAVIOR DATA START =======================================================================================================
//========================================================================================================================================================
//========================================================================================================================================================
//========================================================================================================================================================

struct native SubCoverBehaviorInfo
{
	var() bool m_bAllowSubBehavior;
	var() float m_ChanceOfSubBehavior;
	var() float m_FrequencyOfChanceOfSubBehavior;	
	var() float m_MinDurationOfSubBehaviorPerOccurrence;
	var() float m_MaxDurationOfSubBehaviorPerOccurrence;
};

struct native ScriptedCoverBehaviorData
{
	var eScriptedCoverBehavior	m_Behavior;
	var float m_TimeToPerformInSec;
	var bool m_bOverRideNonScriptedDurations;
};

struct native DoPerformanceAtCoverData
{
	var CoverInfo	m_CoverToDoPerformaceAt;

	var Pawn		m_HeadTrackTarget;
	var Pawn		m_BodyFacingTarget;

	var float		m_AngleToStartTurning;

	var bool		m_bTurnGrappleOff;
	var bool		m_bDoingPerformanceAtCover;
	var bool		m_bViolateByAngle;
	var bool		m_bViolateByTakingHit;
};

/**
 * Contains all the relevant information pertaining to using a cover node and slot
 */
struct native CoverMovementBehaviorInfo
{
	var CoverInfo  m_ReservedGoToCover_Clamied;						// cover going to is claimed
	var CoverInfo  m_CurrentCover_Clamied;						// cover at is claimed
	var CoverInfo  m_PreviousCover_Not_Clamied;						// cover just left is not clamied

	var transient float m_lastCoverTime;				/** Time at which cover was entered */

	var bool m_bOccupingCoverSlot;						/** Has this agent/NPC Moved into a cover slot in a cover node, should be set to false to start and reset to false as soon as moved out of the cover slot*/
	//var vector	m_LocOfCurrentCoverSlot;

	var bool	m_bAllowUseOfCover;

	var float m_MaxDistanceAwayFromCoverForSnappingIn;  // If not at least this close will not snap into cover


	// cover timing attributes
	var float m_CurrentDurrationOfFiringBeforeHiding;
	var float m_CurrentDurationOfHidingBeforeFiring;
	var float m_CurrentDurationOfLookingForTargetBeforeEngageAttempt;

	var float m_DefaultDurrationOfFiringBeforeHiding;
	var float m_DefaultDurationOfHidingBeforeFiring;
	var float m_DefaultDurationOfLookingForTargetEngageAttempt;

	var float m_TimeStartedHidingSinceLastFiringState;	
	var float m_TimeStartedFiringSinceLastHidingState;
	var float m_TimeStartedLookingForTargetSinceLastEngageAttempt;
	
	var float m_TimeToUseCoverInSeconds;
	var float m_MinTimeToUseCoverInSeconds;
	var float m_MaxTimeToUseCoverInSeconds;
	//var float m_AmountOfTimeUsingCurrentCover;
	var float m_TimeStartedUsingCurrentCover;

	var CoverBehavior m_CoverState;
		
	var CoverTransitionAction m_CoverTransitionAction;	// What if any Transition state the NPC is in Needed for Animation tie in
	
	var array<ScriptedCoverBehaviorData>	m_QueueOfScriptedCoverBehaviors;
	var ScriptedCoverBehaviorData	m_CurrentScriptedCoverBehaviorData;
	var float m_TimeStartedPerformingCurrentCoverBehavior;
	var float m_TimeLastSubCoverBehaviorFinished;
	var bool m_bOverRideNonScriptedDurations;
	
	var float m_LastTimeRandomlyChooseCoverSide;

	var float			m_SpeedFactorBeforeCrouchWalkToCover;


	var bool			m_HasPathToCoverBeenBuilt;
	var bool			m_bTookHitWhileTraveling;

	var eMove2CoverStatus	m_Move2CoverStatus;

	// this are members for determining if a cover slot is valid to shoot at the enemy
	// should only be used right after a fn call that set the values at the next tick they may all be invalid
	var bool		m_bHasRateCoverLeftViewPoint;
	var vector		m_RateCoverLeftViewPoint;

	var bool		m_bHasRateCoverRightViewPoint;
	var vector		m_RateCoverRightViewPoint;

	var bool		m_bHasRateCoverUpViewPoint;
	var vector		m_RateCoverUpViewPoint;

	var bool		m_bHasRateCoverStraightViewPoint;
	var vector		m_RateCoverStraightViewPoint;

	var Rotator		m_RotAtStartOfTravel;

	var bool		m_bNotAbleToTransitionIntoCover;
	var bool		m_bTravelToCoverSlotTickLogicProcessedOnce;
	var bool		m_bCheckToSeeIfCoverIsStillValidDuringMoveToCover;
};

struct native CoverEngagementBehaviorInfo
{
	var CoverInfo  m_CurrentlyCoverToUseAsFightPos;				// Cover told to use may not be reserved ot clamied

	var CoverLink.ECoverAction m_CurrentCoverAction;	// the current cover action we are currently performing
	var CoverLink.ECoverAction m_PreviousCoverAction;	// the current cover action we just got done performing

	var bool	m_bUsingFightingPosition;

	var bool m_bContinueToUseUseFightingPosition;
			
	var bool	m_bBlindFire;

	var float			m_MinDistanceToPlayerInCover;	// This min distance the player can get before I get out of this cover position

	var eUseFightingPositionStatus	m_UseFightingPositionStatus;

	var float		m_ChanceToStepOutFromCoverToEngage;

	var bool		m_HaveFiredAtLeastOneRoundThisFireStateSubMove;

	var float		m_TimeStartedToWaitAfterLookFromCover;
	var float		m_TimeStartedLastCoverTransition;

	var bool		m_FirstSubBehaviorAtCover;

	var bool		m_bSlowRotRight; // if not right then left

	var bool		m_bCanRotateToTargetDuringTrans; // 
	var bool		m_bCanRotateToCoverSlotDuringTrans; // 

	var bool		m_bNeedToPlayOpenFieldTransToFiring; // 

	var float		m_LastTimeSearchedForValidTargetWhileLookingFromCover;

// 	var vector		m_EnemyPositionAtLastFindCover;
// 	var vector		m_PositionAtLastFindCover;

};


/**
 * Contains all the relevant information pertaining to using a cover node and slot
 */
struct native MoveToAndDefendCoverGoalInfo
{
	var CoverInfo		m_CoverToDefend;
	var CoverSlot		m_CoverSlotToDefend;

	
	var float			m_DurrationOfFiringBeforeHiding;
	var float			m_DurationOfHidingBeforeFiring;
	var float			m_DurationOfLookingForTargetBeforeEngageAttempt;
	
	var float			m_TimeToDefendInSeconds;

	var bool			m_bAllowWaitingForPathOrPositionToClear;
	var bool			m_bAllowWanderingWhileWaiting;
	var	float			m_TimeToWaitBetweenPathChecks;

	var int				m_NoOfTimesToCheckForPathToCover;
	var int				m_NoOfTimesPathHasBeenTried;

	var bool			m_bAllowAttackWhileWaitingForPathToClear;

	var bool			m_bTaskFailedWhenViolatedByDistenceToEnemy;
	var bool			m_bTaskFailedWhenViolatedByAngleToEnemy;

	var bool			m_bTaskFailedWhenPathCanNotBeFound;
	var bool			m_bTaskFailedWhenCoverCanNotBeClaimed;
};

/**
 * Contains all the relevant information pertaining to Mantling and Jumping
 */
struct native MantleGoalInfo
{
	var eMantleAction	m_MantleActionToPerform;

	var bool			m_bAllowWaitingForPathOrPositionToClear;
	var bool			m_bAllowWanderingWhileWaiting;
	var	float			m_TimeToWaitBetweenPathChecks;

	var int				m_NoOfTimesToCheckForPathToCover;
	var int				m_NoOfTimesPathHasBeenTried;

	var CoverInfo		m_PlaceToMantle;
	var bool			m_bAllowAttackWhileWaitingForPathToClear;

	var eJumpDownSubState m_JumpDownSubState;
	var float m_TimeJumpDownStarted;
	var float m_JumpDownHorizontalOutDuration;
	var float m_JumpDownMinVirticalDist;
	var float m_JumpDownSpeed;
};

struct native WanderInfo
{
	var bool			m_bAllowIdleWander;
	var float			m_DefaultIdleWanderTime;
	var float			m_TimeToWanderOrStandWaitingForPathOrPositionToClear;
	var float			m_ChanceToWander;
	var float			m_DefaultWanderSpeed;
	var float			m_CurrentGoalWanderSpeed;
	var float			m_TimeStartedToWanderOrStandBetweenChecksForPathToClear;
	var bool			m_bAllowAttackWhileWaitingForPathToClear;
};

/**
 * Contains all the relevant information pertaining to using a cover node and slot
 */
struct native AttackUsingCoverGoalInfo
{
	var CoverInfo		m_CurrentCoverToUse;
	var CoverGroup		m_CoverGroup;
	var Actor			m_TargetOfAttack;
	
	var float			m_DurrationOfFiringBeforeHiding;
	var float			m_DurationOfHidingBeforeFiring;
	var float			m_DurationOfLookingForTargetBeforeEngageAttempt;
	var bool			m_bUseCoverGroupToSlaughterMyCurrentEnemy;

	
	var float			m_MinTimeToUseCoverInSeconds;
	var float			m_MaxTimeToUseCoverInSeconds;

	var bool			m_bUseCoverGroupTimer;
	var float			m_AmountOfTimeToStayInCoverGroup;
	var float			m_TimeStartedInCoverGroup;

	var bool			m_bAllowWaitingForPathOrPositionToAnyValidCoverToClear;
	var bool			m_bAllowWanderingWhileWaitingForPathToAnyValidCover;
	var	float			m_TimeToWaitBetweenPathToAnyValidCoverChecks;

	var int				m_NoOfTimesToCheckForPathToAnyValidCover;
	var int				m_NoOfTimesPathToAnyValidCoverHasBeenTried;

	var bool			m_bAllowAttackWhileWaitingForPathToAnyValidCoverToClear;

	var bool			m_bTaskFailedWhenPathToAnyValidCoverCanNotBeFound;

};


/**
 * Contains all the relevant information pertaining to using a cover when the NPC
 * is interupted from its assigned task and needs to seek cover
 */
struct native FreeAttackGoalInfo
{
	var CoverInfo		m_FreeAttackCoverToSeek;

	var vector			m_AnchorLocForCoverSeeking;
	//var CoverSlot		m_CoverSlotToUse;	
		
	var float			m_DurrationOfFiringBeforeHiding;
	var float			m_DurationOfHidingBeforeFiring;
	var float			m_DurationOfLookingForTargetBeforeEngageAttempt;
	
	var float			m_TimeToUseCoverInSeconds;
	var float			m_DistanceToLookForCover;

	var bool			m_bContinueToFreeAttack;
		
	var bool m_bDisplayDistanceToLookForCover;
	var	color m_DisplayDistanceToLookForCoverColor;
};

/**
 * Contains all the relevant information pertaining to being a sniper
 */
struct native SniperInfo
{
	var eSniperType		m_SniperType;

	var Actor			m_SniperNest;
	var CoverInfo		m_CoverToUseAsNest;
	
	var Vector			m_TargetLoc;
	var Vector			m_VecToTarget;
	
	var array<Actor>	m_Track;
	var int				m_NextNodeOnTrack;
	var bool			m_bLoopTrack;
	var bool			m_bTrackingUp;
	
	var float			m_TimeToBeSniperInSeconds;
	var float			m_TimeStartedAsSniperInSeconds;
		
	var float			m_SearchRange;
	var float			m_SearchRateUUnitsPerSec;
	var float			m_MaxDirChangePerSec;	
	var Vector			m_DirOfScan;
	
	var float			m_TargetAcquireRange;
	
	var float			m_Accuracy;
	var float			m_PreviousAccuracy;
	var int				m_RateOfFirePerMin;
	
	var float			m_WaitTimeBetweenShots;
	var float			m_TimeOfLastShot;
	
	var float			m_TimeToWaitAfterLosingContact;
	var float			m_TimeLastContactLost;
	
	var bool m_bDisplaySniperAimRay;
	var	color m_DisplaySniperAimRaySearchingColor;
	var	color m_DisplaySniperAimRayAcquiredColor;

	var bool			m_bCurrentlySniping;

	var bool			m_bAllowWaitingForPathOrPositionToClear;
	var bool			m_bAllowWanderingWhileWaiting;
	var	float			m_TimeToWaitBetweenPathChecks;

	var int				m_NoOfTimesToCheckForPathToCover;
	var int				m_NoOfTimesPathHasBeenTried;

	var bool			m_bAllowAttackWhileWaitingForPathToClear;
};

/**
 * Contains all the relevant information pertaining to using multi tier engagement
 */
struct native MultiTierEngagementInfo
{
	var bool			m_bTookHitWhilePursuing;
	var bool			m_bSawEnemyWhilePursuing;
	var bool			m_bInteruptedWhileLookingForPath;
	var bool			m_bWasIableToGetToAValidPlaceToEngageMyTarget;
	var int				m_NumTimesTriedToPursueSameEnemy;
	var Pawn			m_LastEnemyTriedToPursue;
	var CoverInfo		m_CurrentCoverToUseForMTE;
	var float			m_WaitTimeBetweenTestsForValidWanderTarget;
	var float			m_LastTimeTestedForValidWanderTarget;
	var float			m_TimeToWanderWhileWaitingForTarget;
};

/**
 * Contains all the relevant information pertaining to throwing grenade behavior
 */
struct native GrenadeUseData
{
	var bool							m_bTaskAssignedToUseGrenade;
	var bool							m_bCanUseGrenades;
	var bool							m_bCalcUpperArcForAuto;
	var bool							m_bCalcUpperArcForTask;

	var bool							m_bAlwaysThrowAgainstPlayerCamper;

	var float							m_ChanceToUseGrenadeByOwnWill;
	var float							m_HowOfftenInSecsToCheckChanceToUseGrenade;
	var float							m_TimeToWaitAfterThrownGrenadeToTryAgain;

	var float							m_TimePassedSinceLastCheckChanceToUseGrenade;
	var float							m_TimePassedSinceLastThrownGrenade;
	var float							m_LastTimeDetermineIfGrenadeShouldBeThrownWasChecked;

	var int								m_MaxNumberOfGrenadesToThrow;
	var int								m_NumberOfGrenadesThrown;

	var float							m_NextFuesTime;

	var Actor							m_GrenadeTarget;
	var Vector							m_Current_ThrowForce;

	var eRequiredMovementForEngagement	m_MoveNeededThrowGrenade;
	var Vector							m_SpotToThrowGrenadeFrom;
	var Vector							m_ZBoundSpotToThrowGrenadeFrom;
	var Vector							m_SpotToThrowGrenadeAt;
	var Vector							m_CalculatedThrowVelocity;
	var bool							m_bHasThrowForceBeenCalculated;

	var bool							m_bThrowGrenadeEvenIfNoGoodArcBehavior;
	var bool							m_bThrowGrenadeEvenIfNoGoodArcTask;

	var	config color					m_DisplayGrenadeThrowArcFromHereToTargetColor;
	var	config color					m_DisplayGrenadeThrowArcFromHereToTargetLeftColor;
	var	config color					m_DisplayGrenadeThrowArcFromHereToTargetRightColor;
	var	config color					m_DisplayGrenadeThrowArcFromHereToTargetForwardColor;
	var	config color					m_DisplayGrenadeThrowArcFromHereToTargetBackColor;

	var	config color					m_DisplayGrenadeThrowArcFromLeftToTargetColor;
	var	config color					m_DisplayGrenadeThrowArcFromLeftToTargetLeftColor;
	var	config color					m_DisplayGrenadeThrowArcFromLeftToTargetRightColor;
	var	config color					m_DisplayGrenadeThrowArcFromLeftToTargetForwardColor;
	var	config color					m_DisplayGrenadeThrowArcFromLeftToTargetBackColor;

	var	config color					m_DisplayGrenadeThrowArcFromRightToTargetColor;
	var	config color					m_DisplayGrenadeThrowArcFromRightToTargetLeftColor;
	var	config color					m_DisplayGrenadeThrowArcFromRightToTargetRightColor;
	var	config color					m_DisplayGrenadeThrowArcFromRightToTargetForwardColor;
	var	config color					m_DisplayGrenadeThrowArcFromRightToTargetBackColor;

	var	config color					m_DisplayGrenadeThrowArcFromForwardToTargetColor;
	var	config color					m_DisplayGrenadeThrowArcFromForwardToTargetLeftColor;
	var	config color					m_DisplayGrenadeThrowArcFromForwardToTargetRightColor;
	var	config color					m_DisplayGrenadeThrowArcFromForwardToTargetForwardColor;
	var	config color					m_DisplayGrenadeThrowArcFromForwardToTargetBackColor;

	var	config color					m_DisplayGrenadeThrowArcFromBackToTargetColor;
	var	config color					m_DisplayGrenadeThrowArcFromBackToTargetLeftColor;
	var	config color					m_DisplayGrenadeThrowArcFromBackToTargetRightColor;
	var	config color					m_DisplayGrenadeThrowArcFromBackToTargetForwardColor;
	var	config color					m_DisplayGrenadeThrowArcFromBackToTargetBackColor;

	var float							m_TossSpeed;
	var float							m_BaseTossZ;
	var float							m_DesiredZPct;

	var bool							m_bUseAgainstCurrentEnemyForTask;

	var	float							m_TimeToSmokeForTask;
	var	bool							m_bUseSmokeGrenadeForTask;

	var bool							m_bCheckMinDistToTargetForTask;
	var bool							m_bCheckMaxDistToTargetForTask;
	var bool							m_bCheckMinDistToFriendlyForTask;
	var bool							m_bUseDynamicTacticalThrowingForTask;

	var float							m_MinDistToTargetForTask;
	var float							m_MaxDistToTargetForTask;
	var float							m_MinDistToFriendlyForTask;

	var bool							m_bThrowFromCover;
	var CoverLink.ECoverAction			m_CoverActionNeededToThrowGrenFromCover;
	var float							m_TimeGrenadeThrowAnimStarted;

	var bool							m_IsValidStateToThrowOrRespondToGrenadeOut;

	var SeqAct_AiThrowGrenadeAtActor	m_SeqActForTaskThrowRetry;
	var int								m_NumberOfTimesTriedToTaskThrow;

};

struct native DangerAwarenessData
{
	var float	m_GrenadeOutRangeOfInterest;
	var float	m_DangerAwarenessThreshold;	// max distance at which a DangerEvent(1.0) threat sound can be perceived
	var bool	m_bReactToGrenades;

	var float	m_TimeStartedInitialReactingToGrenadeOut;
	var float	m_ChanceToPerformInitialReactingToGrenadeOut;

	var float	m_ChanceToTurnTowardsGrenDuringInitialReactingToGrenadeOut;

	var bool	m_bReactToGrenadesByRunningAway;
	var float	m_ChanceOfReactingToGrenadesByRunningAway;
	var bool	m_bReactToGrenadesByJumpingOverCover;
	var float	m_ChanceOfReactingToGrenadesByJumpingOverCover;
	var bool	m_bReactToGrenadesByCowering;
	var float	m_ChanceOfReactingToGrenadesByCowering;
	var float	m_TimeReactingToGrenadesByCowering;
	var bool	m_bReactToGrenadesByThrowingBack;
	var float	m_ChanceOfReactingToGrenadesByThrowingBack;
	var float	m_RangeOfReactingToGrenadesByThrowingBack;
	var	vector	m_HotGrenTossBackThrowVelocity;
	var	float	m_HotGrenTossBackThrowForceFactor;
	var	float	m_HotGrenTossBackThrowZForce;
	var bool	m_PathBuiltToGrenade;
	var float	m_DistanceToGrenade;
	var float	m_RandDrawForReaction;
	var bool	m_bCanThrowThisGrenBack;
	var bool	m_bSimpleMovement;

	var float	 m_SpeedToRunAwayScale;
	var float	 m_SpeedScaleBeforeRunaway;


	var bool	m_bReactingToGrenadeOut;
	var bool	m_bRunningToGren;

	var bool	m_bShouldStartCQB;

	var bool	m_bCoverHasBeenClearedAndReserved;

	var eResponseToGrenadeSubBehavior m_ResponseToGrenadeSubBehavior;

	var	vector	m_HotGrenLastKnowLoc;
	var float	m_TimeStartedThrowBack;

	var CoverInfo		m_CoverToReserve;

	var PhysicsGrenade m_CurrentGrenToReactToo;
};


/**
 * Contains all the relevant information pertaining to throwing grenade behavior
 */
struct native CQB_Data
{
	var bool	 m_bAbleToMeleeAttacks;
	var float	 m_AdditionalMeleeRangeOfAttack; // used to be m_MeleeRangeOfAttack
	var int		 m_AdditionalMeleeAttackDamage;  // used to be m_MeleeAttackDamage
	var float	 m_AdditionalMeleeHitForce;  // used to be m_MeleeHitForce
	var float	 m_RangeToStartCQB_State;
	var float	 m_SpeedToChargeScale;
	var float	 m_MeleeWaitToFailTime;
	var float	 m_DelayBetweenStartOfMeleeStateAndTheAttackStart;
	var float	 m_OverridePercentOfMagToBlowThroughBeforeCharge;


	var float	m_TimeMeleeAttemptStarted;
	var bool	m_bHasBlownOneMagBeforeCharge;
	var int		m_NoOfRoundsShotBeforeCharge;
	var int		m_NoOfRoundsToShootBeforeCharge;
	var float	m_SpeedBeforeChargeScale;
	var bool	m_IamRegToCQBMyEnemy;

	var int		m_NoOfTimesFailedCQB_Charge;
	var int		m_NoOfTimesToFailCQB_ChargeBeforeReblowingMag;
	var int		m_NoOfTimesToFailCQB_ChargeBeforeGivingUp;

	var int		m_NoOfTimesWaitedForCheckForCQB;
	var int		m_NoOfTimesToWaitForAnotherOpertunityToCheckForCQB;

	var float	 m_TimeToWaitBetweenChecksToCQB;
	var float	 m_TimeToWaitBetweenChecksToCQBWhenRunningToTurret;
	var float	 m_TimeOfLastCheckToCQB;

	var Pawn		m_RegedCQB_Enemy_Pawn;

	var float		 m_HowOfftenInSecsToCheck_LOS_ForBlow;
	var float		 m_LastTimeForLOS_ForBlow;

	var bool	 m_bNotAllowedToEverNoMatterWhatDoMeleeAttack;

	var bool	m_bShouldContinueChargeBecauseCanStillFireAt;
	var float	m_TimeOfLastMeleeChargeFire;
};


//===========================================================================================================================
//=========== Following Behavior Data ======================================================================================
//===========================================================================================================================
// Following Actor if in Following State
struct native Follow_Data
{
	var Actor ActorToFollow;
	var private float m_CatchingUpDistance;
	var float m_FollowBandMaxRange;	// The Distance to let my target move away before I start to follow again.
	var float m_FollowBandMinRange;	// the distance away to be when I have stopped moving towards my follow target

	var bool m_bContinueToFollow; // Should the NPC should continue to follow that currently seltected actor

	var bool			m_bAllowWaitingForPathToTargetToClear;
	var bool			m_bAllowWanderingWhileWaiting;
	var	float			m_TimeToWaitBetweenPathChecks;

	var int				m_NoOfTimesToCheckForPathToTarget;
	var int				m_NoOfTimesPathHasBeenTried;

	var bool			m_bAllowAttackWhileWaitingForPathToClear;

	var bool			m_bTaskFailedWhenPathCanNotBeFound;

	var bool			m_FollowPathBuilt;
};


//===========================================================================================================================
//=========== Engagement Behavior Data ======================================================================================
//===========================================================================================================================
struct native SideStepLocationDynamicData
{
	var bool	m_bStepCloseForwardLineOfFireCheckValid;
	var bool	m_bStepForwardLineOfFireCheckValid;
	var bool	m_bStepLongForwardLineOfFireCheckValid;
	var bool	m_bStepFarForwardLineOfFireCheckValid;

	var bool	m_bStepCloseBackLineOfFireCheckValid;
	var bool	m_bStepBackLineOfFireCheckValid;
	var bool	m_bStepLongBackLineOfFireCheckValid;
	var bool	m_bStepFarBackLineOfFireCheckValid;

	var bool	m_bStepCloseLeftLineOfFireCheckValid;
	var bool	m_bStepLeftLineOfFireCheckValid;
	var bool	m_bStepLongLeftLineOfFireCheckValid;
	var bool	m_bStepFarLeftLineOfFireCheckValid;

	var bool	m_bStepCloseRightLineOfFireCheckValid;
	var bool	m_bStepRightLineOfFireCheckValid;
	var bool	m_bStepLongRightLineOfFireCheckValid;
	var bool	m_bStepFarRightLineOfFireCheckValid;

	var float	m_TimeStepCloseForwardLineOfFireCheckInvalidated;
	var float	m_TimeStepForwardLineOfFireCheckInvalidated;
	var float	m_TimeStepLongForwardLineOfFireCheckInvalidated;
	var float	m_TimeStepFarForwardLineOfFireCheckInvalidated;

	var float	m_TimeStepCloseBackLineOfFireCheckInvalidated;
	var float	m_TimeStepBackLineOfFireCheckInvalidated;
	var float	m_TimeStepLongBackLineOfFireCheckInvalidated;
	var float	m_TimeStepFarBackLineOfFireCheckInvalidated;

	var float	m_TimeStepCloseLeftLineOfFireCheckInvalidated;
	var float	m_TimeStepLeftLineOfFireCheckInvalidated;
	var float	m_TimeStepLongLeftLineOfFireCheckInvalidated;
	var float	m_TimeStepFarLeftLineOfFireCheckInvalidated;

	var float	m_TimeStepCloseRightLineOfFireCheckInvalidated;
	var float	m_TimeStepRightLineOfFireCheckInvalidated;
	var float	m_TimeStepLongRightLineOfFireCheckInvalidated;
	var float	m_TimeStepFarRightLineOfFireCheckInvalidated;
};

struct native SideStepLocationStaticData
{
	var float	m_StepCloseForwardLineOfFireCheckRange;
	var float	m_StepForwardLineOfFireCheckRange;
	var float	m_StepLongForwardLineOfFireCheckRange;
	var float	m_StepFarForwardLineOfFireCheckRange;

	var float	m_StepCloseBackLineOfFireCheckRange;
	var float	m_StepBackLineOfFireCheckRange;
	var float	m_StepLongBackLineOfFireCheckRange;
	var float	m_StepFarBackLineOfFireCheckRange;

	var float	m_StepCloseLeftLineOfFireCheckRange;
	var float	m_StepLeftLineOfFireCheckRange;
	var float	m_StepLongLeftLineOfFireCheckRange;
	var float	m_StepFarLeftLineOfFireCheckRange;

	var float	m_StepCloseRightLineOfFireCheckRange;
	var float	m_StepRightLineOfFireCheckRange;
	var float	m_StepLongRightLineOfFireCheckRange;
	var float	m_StepFarRightLineOfFireCheckRange;

	var float	m_HowOfftenToRevertInvalidatedTacStepLoc;
};

struct native Engagement_Tac_Data
{
	var float	m_TimeToWaitForWeaponBurstDelay;
	var float	m_TimeStartedWaitForWeaponBurstDelay;

	var bool	m_bWaitingForWeaponBurstDelayToEnd;
	var bool	m_bNeedToReloadAtNextOpertunity;

	var eRequiredMovementForEngagement m_MoveNeed2Kill;
	var float	m_LastTimeLOS_4_DefaultAttacksChecked;
	var float	m_LastTimeHadGoodLineOfFire;

	var float	m_TimeStartedToOpenFieldTacticallyEvadeFromCover;
	var float	m_LastTimeTestedIfGoingLow;

	var	bool	m_bScaredBackToCoverWhileSteppedOut;
	var int		m_NumOfTimeTiredToGetBackToCoverAfterStepOut;
	var Vector	m_RightSide;
	var Vector	m_SideStepTargetMoveLoc;
	var float	m_SideSlideFlip;
	var bool	m_bSideSteping;

	var bool	m_bTookHit;

	var bool	m_bShouldCrouchForFreeAttack;

	var bool	m_bHaveAlreadyTestedTacStepForThisReloadOrHitOrAimedAt;

	var bool	m_bAllowTacticalSteping;

	var bool	m_bKnowBeingAimedAt;

	var bool	m_bFireAtTargetReguardlessOfWhatItIs;

	var float	m_LastTimeKnewBeingAimedAt;
	var float	m_LastTimeTestedIfBeingAimedAt;

	var float	m_LastTimeKnewTookHit;

	var float	m_TimeReloadStarted;

	var float	m_LastTimeCrouched;

	var float	m_TimeStartedToWaitForToStandPostureChange;
	var float	m_TimeStartedToWaitForToCrouchPostureChange;

	var bool	m_bEngagingOnTheRun;
	var int		m_NoOfRoundsFiredThisBurst;

	var float	m_TimeSnappedIn;
	var float	m_TimeOfLastFire;

	var	config color m_DisplayTacticalStepAimRaysStrightAheadColor;

	var	config color m_DisplayTacticalStepAimRaysStandUpColor;

	var	config color m_DisplayTacticalStepAimRaysCloseForwardColor;
	var	config color m_DisplayTacticalStepAimRaysForwardColor;
	var	config color m_DisplayTacticalStepAimRaysLongForwardColor;
	var	config color m_DisplayTacticalStepAimRaysFarForwardColor;

	var	config color m_DisplayTacticalStepAimRaysCloseBackColor;
	var	config color m_DisplayTacticalStepAimRaysBackColor;
	var	config color m_DisplayTacticalStepAimRaysLongBackColor;
	var	config color m_DisplayTacticalStepAimRaysFarBackColor;

	var	config color m_DisplayTacticalStepAimRaysCloseLeftColor;
	var	config color m_DisplayTacticalStepAimRaysLeftColor;
	var	config color m_DisplayTacticalStepAimRaysLongLeftColor;
	var	config color m_DisplayTacticalStepAimRaysFarLeftColor;

	var	config color m_DisplayTacticalStepAimRaysCloseRightColor;
	var	config color m_DisplayTacticalStepAimRaysRightColor;
	var	config color m_DisplayTacticalStepAimRaysLongRightColor;
	var	config color m_DisplayTacticalStepAimRaysFarRightColor;
};


//========================================================================================================================================================
//========================================================================================================================================================
//============= AI STATE CHART BEHAVIOR DATA END =======================================================================================================
//========================================================================================================================================================
//========================================================================================================================================================
//========================================================================================================================================================


//***********************************************************************
// Variable Declarations
//***********************************************************************

// Aiming
//var                 AnimNodeAimOffset                           anode_AIM;

var EHighLevelAiGoal	m_HighLevelAiGoal;

var TPTuneData			m_TuneData;
var SkelControlLookAt	m_SkelControlLookAtForHeadTrack;
var vector				m_TargetEyePointForHeadTrack;
var vector				m_MyEyePointForHeadTrack;
var vector				m_TargetDirForHeadTrack;

// Movement
var MoveGoalInfo m_moveGoalInfo;			/** Current move goal used by MoveToGoal state */
var bool m_bDontClearMoveToTargetLatentAction;
var bool m_bMoveAborted;					/** Was the current move aborted? */
var bool m_bDelayingMove;					/** Are we delaying the current move for a half second? */
var Actor m_stepAsideGoal;					/** Current step aside goal, for StepAside state */
var vector m_stepAsideLocation;				/** Valid step aside location to go to */
var const float m_maxStepAsideDist;			/** Distance to attempt to step aside when bumping into other players */
var bool m_bNoStepAside;					/** Specifies whether we should step aside for other friendlies */
var RouteGoalInfo m_routeGOal;				/** Current route goal use by MoveAlongRoute state */
const INVALIDGOAL_DURATION = 10.0f;			/** Duration of how long a node can be invalid */
var array<InvalidatedMoveGoalInfo> m_invalidMoveGoals;		/** List of invalid move goals, generated by any failed attempts in any state */
var array<InvalidatedCQB_TargetInfo> m_invalidCQB_Targets;		/** List of invalid pawn to CQB target */

var float m_pursueMinRange;
var float m_pursueMaxRange;


// Coverpoints
var CoverMovementBehaviorInfo				m_CoverMoveData;
var CoverEngagementBehaviorInfo				m_CoverFightData;

var FreeAttackGoalInfo						m_FreeAttackGoalInfo;
var MoveToAndDefendCoverGoalInfo			m_MoveToAndDefendCoverGoalInfo;
var AttackUsingCoverGoalInfo				m_AttackUsingCoverGoalInfo;
var SniperInfo								m_SniperInfo;
var MultiTierEngagementInfo					m_MultiTierEngagementInfo;
var GrenadeUseData							m_GrenadeUseData;
var WanderInfo								m_WanderInfo;
var MantleGoalInfo							m_MantleGoalInfo;

var DangerAwarenessData						m_DangerAwarenessData;
var Engagement_Tac_Data						m_Engagement_Tac_Data;

var float									m_LastTimeAI_SwitchedPawnsPosture;

var SideStepLocationDynamicData					m_SliceThePieSideStepDynamicData;
var SideStepLocationDynamicData					m_HastyCoverDynamicData;
var SideStepLocationDynamicData					m_EvadeSideStepDynamicData;

var config SideStepLocationStaticData			m_SliceThePieSideStepStaticData;
var config SideStepLocationStaticData			m_HastyCoverStaticData;
var config SideStepLocationStaticData			m_EvadeSideStepStaticData;

var config float RateCover_FreeAttack_StandCorner;
var config float RateCover_FreeAttack_CrouchCorner;
var config float RateCover_FreeAttack_StandAtLow;
var config float RateCover_FreeAttack_OpenStand;
var config float RateCover_FreeAttack_OpenCrouch;

var config float RateCover_AUsCoG_StandCorner;
var config float RateCover_AUsCoG_CrouchCorner;
var config float RateCover_AUsCoG_StandAtLow;
var config float RateCover_AUsCoG_OpenStand;
var config float RateCover_AUsCoG_OpenCrouch;

var config float RateCover_FreeAttack_2FA_StandCorner;
var config float RateCover_FreeAttack_1FA_StandCorner;
var config float RateCover_FreeAttack_3FA_CrouchCorner;
var config float RateCover_FreeAttack_2FA_CrouchCorner;
var config float RateCover_FreeAttack_1FA_CrouchCorner;

var config float RateCover_AUsCoG_2FA_StandCorner;
var config float RateCover_AUsCoG_1FA_StandCorner;
var config float RateCover_AUsCoG_3FA_CrouchCorner;
var config float RateCover_AUsCoG_2FA_CrouchCorner;
var config float RateCover_AUsCoG_1FA_CrouchCorner;

var config int AILogBehaviorDetailLevel; // Zero is no info, 1 is State Switch Info, 2 In major engagement/Movement detail info, 3 is verbose engagement/Movement detail



//var int										m_IdOfCurrentThreat; // the id no of the current threat that the NPC is responding to		

var bool benemyFound;
var bool benemyHad;

var bool m_bGrappled;

// Turret stuff
var Turret	m_CurrentTurret;	// Our currently selected turret.
var Bool	m_bReachedTurret;	// Have we reached the turret?
var Bool	m_bCoolDown;		// Are we currently waiting for the MG to cool-down before firing again?
var Bool	m_bTurretOverrotated; // Updated each tick to indicate whether we can point the gun at our target

var(AI) Bool m_bTurretGunner; // Does this AI want to jump onto any available turret?
var float m_MaxDistanceAwayToLookForTurret;
var Turret  m_DesiredTurret;

var int	m_NoOfTimeTriedToMountTurret;


//Squad command
var ETPSquadCommands m_squadCommand;				/** Current squad command executing */
var ETPSquadCommandPriority m_squadCommandPriority;	/** The priority of the current squad command */


//Squad command DefendArea
var Volume m_defendAreaVolume;
var Trigger_Dynamic m_defendAreaDynamicVolume;
var ETPDefendAreaDestAssignment m_defendAreaDestAssignment;
var NavigationPoint m_defendAreaDestination;		/** Our destination/goal in the defend area*/
var bool m_bHasBeenInDefendArea;                    /** Keep track if we've been in the defend area or not */



// Force Firing
var float m_forcedFireDuration;
var int   m_forcedFireShotsLeft;
var bool   m_bForcedFire;


// Targeting
var(AI) vector AimErrorMax, AimErrorMin;		/** Range to skew aim */
var(AI) float AimLockonTime;					/** Amount of time it takes for aim to lock on to a moving target */
var(AI) float AimMaxAccuracyDistance;			/** Max distance to allow accurate aim (AimErrorMin) */
var(AI) float AimMinAccuracyDistance;			/** Max distance to allow accurate aim (AimErrorMin) */

var TPWeapon m_MyTpWeapon;
var TPPawn m_MyTpPawn;


var	int AcquisitionYawRate;
var vector TargetAimLocation; //the current point we are aiming at.
var bool bLookAtAimLocation; // If true, then look at the aim point; otherwise, continue normal head tracking.


// Turning
var bool m_bTurnComplete;					// used to track turning status
var bool m_bKeepFacing;						// keeps focus on the turn target after turn is finished

var DoPerformanceAtCoverData m_DoPerformanceAtCoverData;
var bool m_bIsWaitingForAnimToFinish;


// Sensory
//const SIGHT_DURATION = 10.f;				/** How long a player remains visible without new updates */
//const NOISE_DURATION = 15.f;				/** How long a player remains audible without new updates */
//const THREAT_DURATION = 20.f;				/** How long a Danger Event remains a Threat without new updates */

var array<PlayerInfo> m_playerList;			/** List of all known player */
var int m_enemyIdx;							/** Index into m_playerList of our currently selected enemy, -1 for no enemy */
//var array<NoiseInfo> m_recentNoise;			/** List of all recently heard noises */
var NoiseInfo			m_LastHeardNoise;

//var array<ThreatInfo> m_recentThreats;			/** List of all recently Threats Made Aware of */
var ThreatInfo			m_LastThreat;

var (AI)bool	m_bLogAudioAI_CueData;

// Indication to prevent pursuing enemy
var bool    bIsOnVehicle;


// Squad
var TPSquad m_squad;								/** The squad that we belong to */


// AI disability
var bool m_bAIDisabled;
var bool m_bIsWaitingForSceneFinish;


var Name StartStateName;

var string m_SubStateDebugInfoTag;

var Pawn PawnInLineOfFire;

var bool bEnemyAcquired;

var float m_maxHalfHorizontalHeadtrackAngle;
var float m_maxHalfVerticalHeadtrackAngle;

var TPPlayerController m_ThePlayerController;

// Blimp Stuff

var eBlimpWarriorState m_BlimpState;
var eBlimpAttackSubState m_BlimpAttackSubState;
var float m_LastTimeUpdatedBlimpBehavior;
var bool m_bNeedToSwitchBlimpPosture;


//===========================================================================================================================
//=========== Close Quaters Battle Data ======================================================================================
//===========================================================================================================================


// Melee and CQB  Values

var CQB_Data m_CQB_Data;


var Follow_Data m_Follow_Data;


// Mantle/Vault Variables
//var native EObstacle m_CurrentObstacle;
var bool             bSnapWall;
var transient bool   bHitWallPressedJump;
var transient vector LastHitWallNormal;
var transient bool   bHittingWall;
var transient float  JumpDistance;
var transient float  JumpDuration;
var float            Temp1;
var float            OrigZ;
var transient float  TotalTime;

// Shimmy variables
var SeqAct_ShimmyControl seqShimmyControl;
var vector               ShimmyDirection;
var float                ShimmyManualDistance;
var vector               PrevLocation;

// Parachuting rate of descentn
var vector               DescentVelocity;
var vector               DescentFocalPoint;

var enum RP_State {RP_Throw, RP_Descent, RP_Land} Rappel;

// Weapon Blend Node, for No Weapon and using a weapon
var AnimNodeBlend  anode_WeaponBlend;

var bool m_bHitTimeOut;
var bool m_bHitRestart;

var Actor			 ForcedLookAtTarget;

var bool m_bInBasicTakeHitState;

//***********************************************************************
// CPP Text
//***********************************************************************
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
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


//***********************************************************************
// Function Declarations
//***********************************************************************

function MoveToGoalTimerUpdate();
function MoveToGoalObstacleTimerUpdate();

final native noexport function bool CanFireAtNotFromCover(Pawn TargetPawn, optional bool bIgnoreRotation,  optional out Actor hitActor, optional vector chkLoc );
final native noexport function bool CanFireAtFromCover(Pawn TargetPawn, CoverInfo CoverFrom, optional out Actor hitActor );


final native noexport function eRequiredMovementForEngagement GetRequiredMovementForEngagement(	Pawn TargetPawn, 
																								vector RotVecToTest, 
																								out vector outMovementLoc,
																								bool bIgnoreForwardBack,
																								optional vector chkLoc );

final native noexport function eRequiredMovementForEngagement GetRequiredMovementForHastyCover(	Pawn TargetPawn, 
																								vector RotVecToTest, 
																								out vector outMovementLoc,
																								bool bIgnoreForwardBack,
																								optional vector chkLoc );

final native noexport function eRequiredMovementForEngagement GetRequiredMovementForTacEvasion(	Pawn TargetPawn, 
																								vector RotVecToTest, 
																								out vector outMovementLoc,
																								bool bIgnoreForwardBack,
																								optional vector chkLoc );


final native noexport function bool CanMeleeAttack(Pawn TargetPawn, optional out Actor hitActor, optional vector chkLoc );


native function bool CanFireAtEnemy(optional bool bNoEnemyValidation);
native noexport function bool HasValidEnemy(optional out int outNewEnemyIdx,
								optional out Controller outNewEnemyController,
								optional bool bDoNotMakeSureCurrentEnemyIsBest);

native noexport function bool CheckForEnemy(optional bool bTestOnly,  //test only don't acquire target...
							optional float maxDistance,
							optional out int outEnemyIdx,
							optional out Controller outEnemyController,
							optional out float outEnemyDist);

native final function bool IsValidPlayerIdx(int playerIdx);
native final function bool IsValidEnemyPawn(Pawn chkPawn, optional bool bNoListCheck);
native final function bool IsValidEnemyController(Controller chkController,
												optional bool bNoListCheck);
native function bool IsFriendly(Controller checkPlayer);
native function bool IsTargettable(Controller chkController);
native final function bool IsInPlayerList(Controller checkPlayer,
											out int playerIdx);
native final function int GetPlayerIdx(Controller chkPlayer);
native function bool GetEnemyList(out array<EnemyListInfo> enemyList);
native function Pawn GetBestEnemy(array<EnemyListInfo> enemyList,
                            float maxDistance,
                            out int outBestEnemyIdx,
                            out float outBestEnemyDist);
native function bool AcquireEnemy(int playerIdx, optional bool bForce,
									optional bool bTestOnly);
native function float RateEnemy(Controller inPlayer);

native function bool EnemyRecentlyVisible(optional bool bNoEnemyValidation);

native final function bool IsInvalidatedMoveGoal( int SlotIDNo, Actor chkGoal);
native final function bool IsInvalidatedCQB_Target( Pawn chkGoal);

native function bool EnemyBehind(FLOAT TestDistance, bool TestVisibility, bool TestPlayerOnly);
native function bool CurrentEnemyBehindTurret();


native function float GetDistenceLeftOnPath();

native function TPAILog(INT LogDetailLevel, Name logCategory, string logText);
//native final static function WorldInfo GetWorldInfo();

native function TestForEnemyNPCKnowingAboutBeingAimedAt( Pawn Aimer );
native function TestForFriendlyNPCKnowingAboutBeingAimedAt( Pawn Aimer );


native function SnapPawnInToCoverSlot( CoverInfo CoverToSnapTo, bool bCheckForValidAgainstEnemy );

final native function bool IsMyReservedCoverStillValidToMoveTo();


/* Chad ===============================================
* ::SetHotTossGrenadeThrowVelocity()
*
* Will set the Danger Awereness m_HotGrenTossBackThrowVelocity value to either the velocity to put it into the pickle barrel or a valid one right in the players path
*/
native function SetHotTossGrenadeThrowVelocity();

native final function GetMyTpWeapon();
native final function GetMyTpPawn();
native final function GetMyTuneData();

//***********************************************************************
// Functions/States
//***********************************************************************

// Not to C++
event bool PreventUpdatePawnRotation()
{
    if (IsInState('Grapple_v2'))
        return true;

    return false;
}

// function bool IsWaitingForAnimToFinish()
// {
//     return IsInState('WaitingForSceneAnimFinish') || IsInState('WaitingForPerformanceFinish');
// }
// Not to C++
function ConvertAimingAngleInfoByWeaponTypeToRuntimeFormat( AimingAngleInfoByWeaponType PersistentFormat, out AimingAngleInfoByWeaponTypeConverted RuntimeFormat )
{
	RuntimeFormat.m_MaxHalfHorizontalFiringAngleStandingInOpenInUU	= PersistentFormat.m_MaxHalfHorizontalFiringAngleStandingInOpenInDegrees *(65536.0/360.0);
	RuntimeFormat.m_MaxHalfVerticalFiringAngleStandingInOpenInUU	= PersistentFormat.m_MaxHalfVerticalFiringAngleStandingInOpenInDegrees *(65536.0/360.0);
	RuntimeFormat.m_MaxHalfHorizontalFiringAngleCrouchInOpenInUU	= PersistentFormat.m_MaxHalfHorizontalFiringAngleCrouchInOpenInDegrees *(65536.0/360.0);
	RuntimeFormat.m_MaxHalfVerticalFiringAngleCrouchInOpenInUU		= PersistentFormat.m_MaxHalfVerticalFiringAngleCrouchInOpenInDegrees *(65536.0/360.0);

	RuntimeFormat.m_MaxHalfHorizontalFiringAngleStandingAtCoverInUU = PersistentFormat.m_MaxHalfHorizontalFiringAngleStandingAtCoverInDegrees *(65536.0/360.0);
	RuntimeFormat.m_MaxHalfVerticalFiringAngleStandingAtCoverInUU	= PersistentFormat.m_MaxHalfVerticalFiringAngleStandingAtCoverInDegrees *(65536.0/360.0);
	RuntimeFormat.m_MaxHalfHorizontalFiringAngleCrouchAtCoverInUU	= PersistentFormat.m_MaxHalfHorizontalFiringAngleCrouchAtCoverInDegrees *(65536.0/360.0);
	RuntimeFormat.m_MaxHalfVerticalFiringAngleCrouchAtCoverInUU		= PersistentFormat.m_MaxHalfVerticalFiringAngleCrouchAtCoverInDegrees *(65536.0/360.0);

	//`log(" ChadAI - Pawn: " @ Pawn @ " ConvertAimingAngleInfoByWeaponTypeToRuntimeFormat m_MaxHalfHorizontalFiringAngleStandingInOpenInDegrees: " @ PersistentFormat.m_MaxHalfHorizontalFiringAngleStandingInOpenInDegrees @ " m_MaxHalfHorizontalFiringAngleStandingInOpenInUU: " @ RuntimeFormat.m_MaxHalfHorizontalFiringAngleStandingInOpenInUU @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
}

// Not to C++
function ConvertTuneDataAimDataToRuntimeData()
{
	//`log(" ChadAI - Pawn: " @ Pawn @ " ConvertTuneDataAimDataToRuntimeData called -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	ConvertAimingAngleInfoByWeaponTypeToRuntimeFormat( class'TPTuneManager'.static.Get().GetTuneData().AimingAngleData.m_AimingAngleInfoForSMGs, class'TPTuneManager'.static.Get().GetTuneData().m_AimingAngleDataConverted.m_AimingAngleInfoForSMGs );
	ConvertAimingAngleInfoByWeaponTypeToRuntimeFormat( class'TPTuneManager'.static.Get().GetTuneData().AimingAngleData.m_AimingAngleInfoForPistols, class'TPTuneManager'.static.Get().GetTuneData().m_AimingAngleDataConverted.m_AimingAngleInfoForPistols );
	ConvertAimingAngleInfoByWeaponTypeToRuntimeFormat( class'TPTuneManager'.static.Get().GetTuneData().AimingAngleData.m_AimingAngleInfoForRifles, class'TPTuneManager'.static.Get().GetTuneData().m_AimingAngleDataConverted.m_AimingAngleInfoForRifles );
	ConvertAimingAngleInfoByWeaponTypeToRuntimeFormat( class'TPTuneManager'.static.Get().GetTuneData().AimingAngleData.m_AimingAngleInfoForPanzers, class'TPTuneManager'.static.Get().GetTuneData().m_AimingAngleDataConverted.m_AimingAngleInfoForPanzers );
	ConvertAimingAngleInfoByWeaponTypeToRuntimeFormat( class'TPTuneManager'.static.Get().GetTuneData().AimingAngleData.m_AimingAngleInfoForGrenades, class'TPTuneManager'.static.Get().GetTuneData().m_AimingAngleDataConverted.m_AimingAngleInfoForGrenades );
	ConvertAimingAngleInfoByWeaponTypeToRuntimeFormat( class'TPTuneManager'.static.Get().GetTuneData().AimingAngleData.m_AimingAngleInfoForSniperRifles, class'TPTuneManager'.static.Get().GetTuneData().m_AimingAngleDataConverted.m_AimingAngleInfoForSniperRifles );
	ConvertAimingAngleInfoByWeaponTypeToRuntimeFormat( class'TPTuneManager'.static.Get().GetTuneData().AimingAngleData.m_AimingAngleInfoForUnclassified, class'TPTuneManager'.static.Get().GetTuneData().m_AimingAngleDataConverted.m_AimingAngleInfoForUnclassified );

	//`log(" ChadAI - Pawn: " @ Pawn @ " ConvertTuneDataAimDataToRuntimeData m_MaxHalfHorizontalFiringAngleStandingInOpenInDegrees: " @ `TuneData.AimingAngleData.m_AimingAngleInfoForSniperRifles.m_MaxHalfHorizontalFiringAngleStandingInOpenInDegrees @ " m_MaxHalfHorizontalFiringAngleStandingInOpenInUU: " @ `TuneData.m_AimingAngleDataConverted.m_AimingAngleInfoForSniperRifles.m_MaxHalfHorizontalFiringAngleStandingInOpenInUU @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	class'TPTuneManager'.static.Get().GetTuneData().m_AimingAngleDataConverted.m_MaxAngleOffHeadingForRunShotInUU	= class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_MaxAngleOffHeadingForRunShot *(65536.0/360.0);
	class'TPTuneManager'.static.Get().GetTuneData().m_AimingAngleDataConverted.m_MaxAngleOffHorizonForRunShotInUU	= class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_MaxAngleOffHorizonForRunShot *(65536.0/360.0);

	class'TPTuneManager'.static.Get().GetTuneData().m_AimingAngleDataConverted.m_MaxAngleToEnemyToTossBackTooInUU	= class'TPTuneManager'.static.Get().GetTuneData().GrenadeUseData.m_MaxAngleToEnemyToTossBackTooInDegrees *(65536.0/360.0);

	//`log(" ChadAI - Pawn: " @ Pawn @ " ConvertTuneDataAimDataToRuntimeData m_MaxAngleToEnemyToTossBackTooInDegrees: " @ `TuneData.GrenadeUseData.m_MaxAngleToEnemyToTossBackTooInDegrees @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	//`log(" ChadAI - Pawn: " @ Pawn @ " ConvertTuneDataAimDataToRuntimeData m_MaxAngleToEnemyToTossBackTooInUU: " @ `TuneData.m_AimingAngleDataConverted.m_MaxAngleToEnemyToTossBackTooInUU @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


	class'TPTuneManager'.static.Get().GetTuneData().m_AimingAnglesCoverted = true;
}



// Not to C++
event PostBeginPlay()
{
	Super.PostBeginPlay();

	RotationRate.Pitch = class'TPTuneManager'.static.Get().GetTuneData().StationaryRotRateData.pitchDegPerSec * 65536.0 / 360.0;
	RotationRate.Roll = class'TPTuneManager'.static.Get().GetTuneData().StationaryRotRateData.rollDegPerSec * 65536.0 / 360.0;
	RotationRate.Yaw = class'TPTuneManager'.static.Get().GetTuneData().StationaryRotRateData.yawDegPerSec * 65536.0 / 360.0;

	// covert the tune data into
	//`log(" ChadAI - Pawn: " @ Pawn @ " PostBeginPlay Aiming Angles Converted: " @ `TuneData.m_AimingAnglesCoverted @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	if( class'TPTuneManager'.static.Get().GetTuneData().m_AimingAnglesCoverted == false )
	{
		ConvertTuneDataAimDataToRuntimeData();
	}
// 	else
// 	{
// 		`TuneData.m_AimingAngleDataConverted.m_MaxAngleToEnemyToTossBackTooInUU	= `TuneData.GrenadeUseData.m_MaxAngleToEnemyToTossBackTooInDegrees *(65536.0/360.0);
// 	}

}

native function FindPlayerController();

//---------------------------------------------------------------------------
// Function:
// Description:	Makes our weapon start firing.
//---------------------------------------------------------------------------
// Not to C++ but can use the C++ one

function StartFiring()



{

	
		//`log(" ChadAI - Pawn: " @ Pawn @ " TPaiCon::StartFiring isdefined(FINAL_RELEASE) -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
 
	




		TP_AiStartFiring();

// 	if (Pawn != None &&
// 		Pawn.Weapon != None)
// 	{
// 		bFire = 1;
// 		Pawn.StartFire(0);
// 	}
}

native function final TP_AiStartFiring();

// Not to C++
function OnShimmyControl(SeqAct_ShimmyControl Action)
{
    if (seqShimmyControl != None)
        ;

    seqShimmyControl = Action;
}
// Not to C++
function OnAllowFall(SeqAct_AllowFall Action)
{
    if (Action.InputLinks[0].bHasImpulse)
        Pawn.bCanJump = true;
    else if (Action.InputLinks[1].bHasImpulse)
        Pawn.bCanJump = false;

}
// Not to C++
function OnJump(SeqAct_Jump inAction)
{
	local vector X, Y, Z;

	if (Pawn != none)
	{
		GetAxes(Pawn.Rotation, X, Y, Z);
		Pawn.bCanJump = true;
		//Pawn.bStopAtLedges=false;
		//Pawn.bCanWalkOffLedges=true;
		if (inAction.JumpForward)
			Pawn.Velocity = X * (Pawn.GroundSpeed * inAction.JumpMultiplier);
		else if (inAction.JumpBackward)
			Pawn.Velocity = X * (-Pawn.GroundSpeed * inAction.JumpMultiplier);
		else if (inAction.JumpRight)
			Pawn.Velocity = Y * (Pawn.GroundSpeed * inAction.JumpMultiplier);
		else if (inAction.JumpLeft)
			Pawn.Velocity = Y * (-Pawn.GroundSpeed * inAction.JumpMultiplier);
		Pawn.DoJump(true);
	}
}
// Not to C++
function OnFollowActor(SeqAct_FollowActor inAction)
{
	if (inAction.bStopFollowing)
	{
		m_Follow_Data.ActorToFollow = none;
		return;
	}

	if (inAction.FollowTarget != none )
	{

		m_Follow_Data.ActorToFollow = inAction.FollowTarget;
		m_Follow_Data.m_FollowBandMaxRange = inAction.m_FollowBandMaxRange;
		m_Follow_Data.m_FollowBandMinRange = inAction.m_FollowBandMinRange;

		m_Follow_Data.m_bAllowWaitingForPathToTargetToClear		= inAction.m_bAllowWaitingForPathToTargetToClear;
		m_Follow_Data.m_bAllowWanderingWhileWaiting				= inAction.m_bAllowWanderingWhileWaiting;
		m_Follow_Data.m_TimeToWaitBetweenPathChecks				= inAction.m_TimeToWaitBetweenPathChecks;
		m_Follow_Data.m_NoOfTimesToCheckForPathToTarget			= inAction.m_NoOfTimesToCheckForPathToTarget;
		m_Follow_Data.m_NoOfTimesPathHasBeenTried				= inAction.m_NoOfTimesPathHasBeenTried;
		m_Follow_Data.m_bAllowAttackWhileWaitingForPathToClear	= inAction.m_bAllowAttackWhileWaitingForPathToClear;
		m_Follow_Data.m_bTaskFailedWhenPathCanNotBeFound		= inAction.m_bTaskFailedWhenPathCanNotBeFound;

		
		if (m_Follow_Data.ActorToFollow.IsA('Controller'))
		{
			m_Follow_Data.ActorToFollow = Controller(m_Follow_Data.ActorToFollow).Pawn;
		}
		else
		{
			if (Pawn(inAction.FollowTarget) == Pawn)
				return;
		}
		if (!IsInState('FollowActorGoal') && !IsInState('Following'))
		{
			GotoState('FollowActorGoal');
		}
	}
}

// Not to C++
function OnStopFollowingActor(SeqAct_StopFollowingActor inAction)
{
	//`log(" ChadAI - TPAIController::OnStopFollowingActor Called for: " @ Pawn @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	KynapseClear();
	m_Follow_Data.m_bContinueToFollow = false;
}

// Not to C++
event OnSetSkeletalMesh(SeqAct_SetSkeletalMesh Action)
{
	if (Action.NewSkeletalMesh != None && Action.NewSkeletalMesh != Pawn.Mesh.SkeletalMesh)
	{
		Pawn.Mesh.SetSkeletalMesh(Action.NewSkeletalMesh);
		//ReplicatedMesh = Action.NewSkeletalMesh;
	}
}

// Not to C++, not used enough
function TestObstacle ( )
{
    local bool bAllowVault, bAllowMantle, bAllowShimmy;
    local int  Index;
	local TPPawn tpPawnRef;
    
	//`log(" ChadAI - TPAIController::TestObstacle Start -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	tpPawnRef = TPPawn(Pawn);

    if (tpPawnRef != None && TPPawn(Pawn).MovementVolumes.Length != 0)
    {
        Index = tpPawnRef.MovementVolumes.Length-1;
        bAllowVault  = tpPawnRef.MovementVolumes[Index].Movement.bAllowVault;
        bAllowMantle = tpPawnRef.MovementVolumes[Index].Movement.bAllowMantle;
        bAllowShimmy = tpPawnRef.MovementVolumes[Index].Movement.bAllowShimmy;
    }
    else
    {
	 	//`log(" ChadAI - TPAIController::TestObstacle End because TPPawn(Pawn).MovementVolumes.Length == 0 -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		
        return;
    }

    TotalTime    = 0;
    Temp1        = 0.29f; // @todo for MantlingHigh in PlayerTick

    //@todo CollisionExtent not used for now
    JumpDistance = 0;

    if (bAllowVault)
    {
	 	//`log(" ChadAI - TPAIController::TestObstacle bAllowVault-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		
	    tpPawnRef.Obstacle = tpPawnRef.TestVault(LastHitWallNormal, JumpDistance);
	}
	else
	{
	 	//`log(" ChadAI - TPAIController::TestObstacle Not bAllowVault-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	}	

	if (tpPawnRef.Obstacle == OB_Nothing && (bAllowMantle || bAllowShimmy))
		tpPawnRef.Obstacle = tpPawnRef.TestMantle (LastHitWallNormal, JumpDistance);
		
		
 	//`log(" ChadAI - TPAIController::TestObstacle TPPawn(Pawn).Obstacle: " @ TPPawn(Pawn).Obstacle @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		

    switch (tpPawnRef.Obstacle)
    {
        case OB_Vaultable:
			if (Pawn.Velocity.Z == 0 && bAllowVault)
				PushState ('Vaulting');
            else
                TPPawn(Pawn).Obstacle = OB_Nothing;
            break;
        case OB_VaultMantleable:
			if (Pawn.Velocity.Z == 0 && bAllowMantle)
                PushState  ('VaultMantling');
            else
				tpPawnRef.Obstacle = OB_Nothing;
            break;
		case OB_VaultableMedium:
			if (Pawn.Velocity.Z == 0 && bAllowVault)
			    PushState ('VaultMedium');
            else
                tpPawnRef.Obstacle = OB_Nothing;
            break;
		case OB_VaultableHigh:
			if (Pawn.Velocity.Z == 0 && bAllowVault)
    			PushState ('VaultHigh');
            else
                tpPawnRef.Obstacle = OB_Nothing;
            break;
		case OB_MantleableLow:
            if (bAllowMantle)
    	        PushState ('MantlingLow');
            break;
        case OB_MantleableMedium:
            if (bAllowMantle)
                PushState ('MantlingMedium');
            else
                tpPawnRef.Obstacle = OB_Nothing;
            break;
        case OB_Catchable:
            if (bAllowShimmy)
            {
                //Pawn.bCanJump = true;
		        //Pawn.DoJump(true);
                // So the hands line up with the surface that is being hung from
                JumpDistance -= 5; 
                DoCatch ();
            }
            else
            {
                tpPawnRef.Obstacle = OB_Nothing;
            }
            break;
        default:
            break;
    }
    
 	//`log(" ChadAI - TPAIController::TestObstacle End -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
   
}

//************************ - BEGIN SECTION - ****************************
// AI DISABIITY FUNCTIONS
//***********************************************************************



native final function TP_GotoState( name NewState, optional name Label, optional bool bForceEvents, optional bool bKeepStack );



native function ResetStates();

native function ClearYourMindFunc(	optional bool bDontResetSceneAnims, optional bool bNoAIMoveToActorLatentClear);


/**
 * Sets god mode based on the activated link.
 */
function OnToggleGodMode(SeqAct_ToggleGodMode inAction)
{
	Super.OnToggleGodMode(inAction);
	;
}

//-----------------------------------------------------------------------
// Function:
// Description:	Function to enable AI
//-----------------------------------------------------------------------
// Not to C++
function EnableAI(optional bool bDontResetSceneAnims)
{
	/* fix sliding guys
	ActivateKynapseBrain(true); // make it move
	*/

	//`AILOG(0, 'AI Disability', "Enabling AI");
	ClearYourMindFunc( bDontResetSceneAnims);
	m_bAIDisabled = false;
	m_bIsWaitingForSceneFinish = false;
	;
	EvaluateSituation();
}

//-----------------------------------------------------------------------
// Function:
// Description:	Function to softly enable AI.  This function assumes that
//				a 'hard' eneable AI was done beforehand.
//				Does not clear latent movement kismet action
//-----------------------------------------------------------------------
// Not to C++
function SoftEnableAI()
{
	/* fix sliding guys
	ActivateKynapseBrain(true); // make it move
	*/
	
	//`AILOG(0, 'AI Disability', "Softly Enabling AI");
	ClearYourMindFunc( false, true);
	m_bAIDisabled = false;
	m_bIsWaitingForSceneFinish = false;
	;
	EvaluateSituation();
}

//-----------------------------------------------------------------------
// Function:
// Description:	Function to disable AI
//-----------------------------------------------------------------------
// Not to C++
function DisableAI(optional bool bDontResetSceneAnims)
{
	/* fix sliding guys
	ActivateKynapseBrain(false); // make it not move
	*/
	;

	KynapseClear();
	
	//`AILOG(0, 'AI Disability', "Disabling AI");
	ClearYourMindFunc(bDontResetSceneAnims);
	m_bAIDisabled = true;
	m_bIsWaitingForSceneFinish = false;
	GotoState('AIDisabled');
}

//-----------------------------------------------------------------------
// Function:
// Description:	Function to softly disable AI.  This function assumes that
//				a 'hard' disable AI was done beforehand.
//				Does not clear latent movement kismet action
//-----------------------------------------------------------------------
native function SoftDisableAI();

//-----------------------------------------------------------------------
// Function:
// Description:	Function to wait for scene anims to finish
//-----------------------------------------------------------------------
// Not to C++
function WaitForSceneFinish()
{
    m_bIsWaitingForSceneFinish = true;
	if (!IsInState('WaitingForSceneAnimFinish'))
    {
        ;
	   ClearYourMindFunc(true);
	   GotoState('WaitingForSceneAnimFinish');
	}
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
// Not to C++
function SceneFinished()
{
    ;
    m_bIsWaitingForSceneFinish = false;

    if (m_bAIDisabled)
        DisableAI(true);
    else
        EnableAI( true);

	;
	EvaluateSituation();
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
// Not to C++
function bool IsWaitingForSceneToFinish()
{
	return m_bIsWaitingForSceneFinish;
}

native function WaitForPerformanceFinish();


//***********************************************************************
// AI DISABIITY FUNCTIONS
//************************ - END SECTION - ******************************
// Not to C++
function float GetDeathForceForRun()
{
	if( Pawn.currentMovementTypeIndex == MovementType_Sprint )
	{
		return class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_DeathForceFactor_Sprint;
	}
	else if( Pawn.currentMovementTypeIndex == MovementType_CrouchRun )
	{
		return class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_DeathForceFactor_CrouchRun;
	}

	return class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_DeathForceFactor_Run;
}
// Not to C++
final function KillTheTraveller( optional bool bFrontForce = true )
{
	local Vector			centerPos;
	local Vector			momentum;

	if( Pawn != None )
	{
		if( Pawn.Health <= 0 )
		{
			Pawn.Health = 1;
		}

		if( TPPawn(Pawn) != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
		{
			;

			//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " KillTheTraveller -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			centerPos = Pawn.Mesh.GetBoneLocation('JO_hip');

			Pawn.SetLocation(centerPos);

			TPPawn(Pawn).FreezeTime = 15.0;

			//Pawn.SetLocation( m_CoverMoveData.m_ReservedGoToCover_Clamied.Link.GetSlotLocation(m_CoverMoveData.m_ReservedGoToCover_Clamied.SlotIdx) );
			TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet = false;

			if( bFrontForce )
			{
				momentum = TPPawn(Pawn).m_DeadAndDoesNotKnowItYetMomentum;
			}
			else
			{
				momentum = TPPawn(Pawn).m_DeadAndDoesNotKnowItYetMomentum * -1.5;
			}

			TPPawn(Pawn).TakeDamage( Pawn.Health, TPPawn(Pawn).m_DeadAndDoesNotKnowItYetInstigatedBy,
														TPPawn(Pawn).m_DeadAndDoesNotKnowItYetHitlocation,
														momentum,
														TPPawn(Pawn).m_DeadAndDoesNotKnowItYetDamageType );

			if( Pawn != None && Pawn.Health != 0 )
			{
				;
			}
		}
	}
}

//************************ - BEGIN SECTION - ****************************
// PLAYER/ENEMY INFO FUNCTIONS
//***********************************************************************

//-----------------------------------------------------------------------
// Function:
// Description:	Evaluates all the players in our list, checking to
//				see if they are still visible/audible.
//-----------------------------------------------------------------------
native final function UpdatePlayerList();

//-----------------------------------------------------------------------
// Function:
// Description:	Called at a regular interval, used to cull out old noises.
//-----------------------------------------------------------------------
native final function UpdateRecentNoise();

//-----------------------------------------------------------------------
// Function:
// Description:	Called at a regular interval, used to cull out old noises.
//-----------------------------------------------------------------------
native final function UpdateRecentThreats();

// NOT USED ENOUGH TO BE WORTH GOING To C++
// function bool IsHostile( Controller checkPlayer )
// {
// 	local int idx;
// 	
// 	if( checkPlayer == None )
// 		return false;
// 	
// 	idx = GetPlayerIdx( checkPlayer );
// 	
// 	if( idx == -1 )
// 		return false;
// 		
// 	return m_playerList[idx].bHostile;
// }

//***********************************************************************
// PLAYER/ENEMY INFO FUNCTIONS
//************************ - END SECTION - ******************************





//************************ - BEGIN SECTION - ****************************
// SENSORY EVENTS/FUNCTIONS
//***********************************************************************
// Not to C++
event SeeMonster( Pawn Seen )
{
	//`log(Pawn @ "TPAIController::event SeeMonster" @ Seen);

	//Pawn.TriggerEventClass(class'SeqEvent_AISeeEnemy',Seen);
	SeePlayer(Seen);
}

// To C++
function Controller GetController(Pawn pTarget)
{
	if (pTarget == None)
		return None;
	if (pTarget.Controller != None)
		return pTarget.Controller;
	else if (pTarget.DrivenVehicle != None)
		return pTarget.DrivenVehicle.Controller;
	else
		return None;
}

native final function AddToPlayerList( Pawn NewPlayer );

//-----------------------------------------------------------------------
// Event:
// Description:	Called whenever another player is sighted, at which point
//				the player is added to the master list if not already added,
//				keeping track of the last known location and time.
//-----------------------------------------------------------------------
// To C++
event SeePlayer(Pawn Seen)
{
	local int playerIdx;
	local bool bNewEnemy;
	local TPPawn tpPawn;
	local Controller pController;
	local TPAIController spAI;
	local vector x, y, z;
	local CoverLink.ECoverType curCovType;
	local CoverLink.ECoverAction curCovAction;

	//`Log(Pawn@"TPAIController::Event SeePlayer "@Seen);
	pController = GetController(Seen);

	if (pController != None)
	{
		//`log(self @ "I see" @ Seen);
	
		if (!IsInPlayerList(pController,playerIdx))
		{
			// add the new entry
			playerIdx = m_playerList.Length;
			m_playerList.Length = playerIdx + 1;
			m_playerList[playerIdx].Player = pController;
			m_playerList[playerIdx].bFriendly = IsFriendly(pController);
			m_playerList[playerIdx].PerceivedLocation = Seen.Location;
			m_playerList[playerIdx].LastSeenTime = WorldInfo.TimeSeconds;
			m_playerList[playerIdx].LastSeenLocation = Seen.Location;
			bNewEnemy = true;
			;
			
			//`log(self @ "I see player" @ Seen @ "bFriendly=" @ IsFriendly(pController));
		}
		else
		{
			m_playerList[playerIdx].LastSeenTime = WorldInfo.TimeSeconds;
			tpPawn = TPPawn(Seen);
			// immediately update friendlies
			if (tpPawn == None ||
				m_playerList[playerIdx].bFriendly)
			{
				m_playerList[playerIdx].PerceivedLocation = Seen.Location;
				m_playerList[playerIdx].LastSeenLocation = Seen.Location;
			}
			else
			{
				curCovType = CT_None;
				curCovAction = CA_Default;
				spAI = TPAIController(pController);
				if (spAI != None)
				{
					curCovType = spAI.GetCurrentCoverType();
					curCovAction = spAI.GetCurrentCoverAction();
				}
				// update based only if they're not in cover
				if (curCovType == CT_None ||
					(curCovType != CT_None &&
					 curCovAction != CA_Default))
				{
					if (m_playerList[playerIdx].PerceptionTimer == 0.f)
					{
						m_playerList[playerIdx].PerceptionTimer = AimLockonTime;
					}
					m_playerList[playerIdx].LastSeenLocation = Seen.Location; //Mesh.GetBoneLocation('Neck');
					// adjust slightly if they are leaning (instead of just popping up)
					x = Normal(Pawn.Location-Seen.Location);
					z = vect(0,0,1);
					y = Normal(x cross z);
					if (curCovAction == CA_LeanLeft ||
						curCovAction == CA_StepLeft ||
						curCovAction == CA_PeekLeft ||
						curCovAction == CA_BlindLeft)
					{
						m_playerList[playerIdx].LastSeenLocation += y * 50.f; //SPAI TODO: adjust this properly!
					}
					else
					if (curCovAction == CA_LeanRight ||
						curCovAction == CA_StepRight ||
						curCovAction == CA_PeekRight ||
						curCovAction == CA_BlindRight)
					{
						m_playerList[playerIdx].LastSeenLocation -= y * 50.f; //SPAI TODO: adjust this properly!
					}
				}
			}
		}
		// update the entry
		m_playerList[playerIdx].bVisible = true;
		m_playerList[playerIdx].bPotentiallyVisible = true;
		m_playerList[playerIdx].LastPotentiallySeenTime =  WorldInfo.TimeSeconds;

		// notify if it's an enemy
		if (!m_playerList[playerIdx].bFriendly)
		{
			;

			// fire any see enemy events
			Pawn.TriggerEventClass(class'SeqEvent_AISeeEnemy',Seen);
			OnSeeEnemy(playerIdx,bNewEnemy);
		}
	}
}

//-----------------------------------------------------------------------
// Function:
// Description:	Called from SeePlayer when we encounter an enemy,
//				override when waiting for enemy selection.
//
//				@param	playerIdx - index to PlayerList of seen enemy
//
//				@param	bNewEnemy - true if this is the first time this
//									enemy has been sighted
//-----------------------------------------------------------------------
// Not to C++
function OnSeeEnemy(int playerIdx, bool bNewEnemy)
{
}

//-----------------------------------------------------------------------
// Function:
// Description:	Called from HearNoise when we hear something,
//				override when waiting for enemy selection.
//
//				@param	playerIdx - index to PlayerList of seen enemy
//
//-----------------------------------------------------------------------
// Not to C++
event OnHearEnemy(int playerIdx)
{
}

//***********************************************************************
// SENSORY EVENTS/FUNCTIONS
//************************ - END SECTION - ******************************


//************************ - BEGIN SECTION - ****************************
// COMBAT MANAGEMENT FUNCTIONS
//***********************************************************************

//Combat stuff should really be in soldier controller

native function bool ShouldIAttackEnemy(optional int enemyIdx=-1);

// To C++
function bool CanFireAtEnemyFrom(CoverInfo CoverFrom, optional bool bNoEnemyValidation)
{
//	local TPAIController spAI;
//	local Actor hitActor;
//	local vector hitL, hitN;
//	local vector enemyLoc;

	//`log(" ChadAI - Pawn" @ Pawn @ " CanFireAtEnemyFrom fn start --------------------------------------------------------------------------------------------" );


	if (!bNoEnemyValidation && !HasValidEnemy(,,true))
	{
		;
		//`log(" ChadAI - CanFireAtEnemyFrom CanFireAtEnemy THis is !bNoEnemyValidation && !HasValidEnemy(,,true) --------------------------------------------------------------------------------------------" );

		return false;
	}

	if( Enemy != None )
	{
		//`log(" ChadAI - Pawn" @ Pawn @ " CanFireAtEnemyFrom calling CanFireAtFromCover for enemy: " @ Enemy @ "--------------------------------------------------------------------------------------------" );

		if (CanFireAtFromCover(Enemy, CoverFrom ))
		{
			return true;
		}
	}
	else
	{
		;
	}

	return false;
}

native function ClearEnemy();

//-----------------------------------------------------------------------
// Function:
// Description:	If the NPC is doing any of the Mantle Behaviors and Notify Landed is called this can be called to see if there
// is a mantle finished event set to fire at first touch of the ground this is to facitly reactions to the landing of an NPC
//-----------------------------------------------------------------------
// Not to C++
function TestForMantleDoneEventWhenFirstTouchGround()
{
	
	//local CoverSlot slot;
	local int idx;
	local SeqEvent_AiMantleFinished doneEvt;	
	
	//`log(" ChadAI - Pawn "@Pawn @ " TestForMantleDoneEventWhenFirstTouchGround: Node:" @ m_MantleGoalInfo.m_PlaceToMantle.Link @ " Slot: " @ m_MantleGoalInfo.m_PlaceToMantle.SlotIdx @ " -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");

	if( Pawn != None && m_MantleGoalInfo.m_PlaceToMantle.Link != None )
	{
		for (idx = 0; idx < Pawn.GeneratedEvents.Length; idx++)
		{
			//`log(" ChadAI - Pawn "@Pawn @ " TestForMantleDoneEventWhenFirstTouchGround: - GeneratedEvents.Length[" @ idx @ "]:" @ Pawn.GeneratedEvents[idx] @ " -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");	
			doneEvt = SeqEvent_AiMantleFinished(Pawn.GeneratedEvents[Idx]);
			if (doneEvt != None)
			{	
				//`log(" ChadAI - Pawn "@Pawn @ " TestForMantleDoneEventWhenFirstTouchGround: - callin CheckIfCorrespondingCoverSlot -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
				;			
				doneEvt.CheckIfCorrespondingCoverSlotForFirstTouchOnGroundEvent( Pawn, Self, m_MantleGoalInfo.m_PlaceToMantle );
			}
		}
	}
}


// To C++
function CoverTransitionAction GetCoverTransitionNeededForChangeInFiringArc( CoverLink.ECoverAction OldAction, CoverLink.ECoverAction NewAction, ECoverType CoverTypeAt )
{
	if( OldAction != NewAction )
	{
		// separate by cover type
		if( CoverTypeAt == CT_MidLevel )
		{
			// if from up
			if( OldAction == CA_PopUp )
			{
				// if to left
				if( NewAction == CA_LeanLeft )
				{
					return CoverTransitionAction_TopToLeft;
				} // if to right
				else if( NewAction == CA_LeanRight )
				{
					return CoverTransitionAction_TopToRight;
				}
			}
			else if( OldAction == CA_LeanLeft )
			{
				// if to left
				if( NewAction == CA_PopUp )
				{
					return CoverTransitionAction_LeftToTop;
				} // if to right
				else if( NewAction == CA_LeanRight )
				{
					//return CoverTransitionAction_LeftToRight;
					return CoverTransitionAction_NotTransitioning;
				}
			}
			else if( OldAction == CA_LeanRight )
			{
				// if to left
				if( NewAction == CA_PopUp )
				{
					return CoverTransitionAction_RightToTop;
				} // if to right
				else if( NewAction == CA_LeanLeft )
				{
					//return CoverTransitionAction_RightToLeft;
					return CoverTransitionAction_NotTransitioning;
				}
			}
		}
		else if( CoverTypeAt == CT_Standing )
		{
			// not dealing with standing at this point
		}
	}

	return CoverTransitionAction_NotTransitioning;
}



//***********************************************************************
// COMBAT MANAGEMENT FUNCTIONS
//************************ - END SECTION - ******************************




//************************ - BEGIN SECTION - ****************************
// EVALUATION FUNCTIONS
//***********************************************************************

native function EvaluateSituation();

native function bool ShouldWanderInsteadOfStandAndLookStupidAndMakeTheGameLookBad();

native function bool DetermineIfGrenadeShouldBeAutoThrown();


// returns true if it is possible to tactically throw a grenade and false if not
native function bool DetermineGrenadeThrowVelocityAndTacStepLocation();


//-----------------------------------------------------------------------
// Function:
// Description:	Checks to see if one should pursue an enemy 
//-----------------------------------------------------------------------
native function bool ShouldIPursueEnemy();

//To be overridden 
function bool IsChallenging(Pawn chkEnemy)
{
	return false;
}

// Not to C++
function NotifyOpenFieldPostureSwitchingStateNowNotSwitching()
{
	//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " NotifyOpenFieldPostureSwitchingStateNowNotSwitching called -----------------------------------------------------------------------------------");

	if( Pawn != None)
	{
		Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_NotSwitching;

		//`log(" ChadAI - Pawn: " @ Pawn @ " NotifyOpenFieldPostureSwitchingStateNowNotSwitching before-		Pawn Loc1: " @  Pawn.Location @ " BoneLoc2 " @ Pawn.Mesh.GetBoneLocation('JO_hip') @ " BoneLoc3 " @ Pawn.Mesh.GetBoneLocation('JO_positionTracker') @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		//Pawn.SetLocation(Pawn.Mesh.GetBoneLocation('JO_hip'));
		//Pawn.SetLocation(Pawn.Mesh.GetBoneLocation('JO_positionTracker')); /*-
            //Pawn.FullHeight);*/

		//`log(" ChadAI - Pawn: " @ Pawn @ " NotifyOpenFieldPostureSwitchingStateNowNotSwitching after-		Pawn Loc1: " @  Pawn.Location @ " BoneLoc2 " @ Pawn.Mesh.GetBoneLocation('JO_hip') @ " BoneLoc3 " @ Pawn.Mesh.GetBoneLocation('JO_positionTracker') @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


		if( m_BlimpState != BlimpWarriorState_NotInBlimp )
		{
			if( m_BlimpAttackSubState == BlimpAttackSubState_TransitioningFromStandToCrouch )
			{
				m_BlimpAttackSubState = BlimpAttackSubState_CrouchingNotAttacking;
			}
			else
			{
				m_BlimpAttackSubState = BlimpAttackSubState_StandingNotAttacking;
			}
		}

		//`log(" ChadAI - Pawn: " @ Pawn @ " NotifyOpenFieldPostureSwitchingStateNowNotSwitching Pawn.m_OpenFieldPostureSwitchingState: " @ Pawn.m_OpenFieldPostureSwitchingState @ " -----------------------------------------------------------------------------------");
	}
}

function NotifyTransitionToCoverThatRotationToCoverCanStart()
{
	//`log(" ChadAI - Pawn: " @ Pawn @ " NotifyTransitionToCoverThatRotationToCoverCanStart Pawn.m_OpenFieldPostureSwitchingState: " @ Pawn.m_OpenFieldPostureSwitchingState @ " -----------------------------------------------------------------------------------");

	m_CoverFightData.m_bCanRotateToTargetDuringTrans = true;
	m_CoverFightData.m_bCanRotateToCoverSlotDuringTrans = false;
	Pawn.SetPhysics(PHYS_None);
}

function NotifyTransitionToCoverThatRotationToCoverShouldStop()
{
	m_CoverFightData.m_bCanRotateToTargetDuringTrans = false;
}


//***********************************************************************
// EVALUATION FUNCTIONS
//************************ - END SECTION - ******************************



//************************ - BEGIN SECTION - ****************************
// HITS/DEATH MANAGEMENT
//***********************************************************************
//-----------------------------------------------------------------------
// Function:
// Description:	Called from NotifyKilled below
//-----------------------------------------------------------------------
// Not to C++
function NotifyEnemyKilled()
{
	// attempt to find a new enemy
	//CheckForEnemy();
}

//-----------------------------------------------------------------------
// Function:
// Description:	Called whenever our Pawn receives damage via TakeDamage().
//				Redirects to SeePlayer(), registering the instigator as a
//				visible enemy.
//-----------------------------------------------------------------------
// Not to C++
function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
{
	Super.NotifyTakeHit(InstigatedBy,HitLocation,Damage,damageType,Momentum);
	if (InstigatedBy != None)
	{
		SeePlayer(InstigatedBy.Pawn);
	}
	//TP OUT AdjustUnderFireMeter(0.4f);
	
	
	//HITREACTIONS
	if( ShouldPerformHitReaction() )
	{
		if (Pawn != None && Damage > 0 && Pawn.Health > 0)
		{
			if (IsInState('TakeHit'))
			{
				GotoState('TakeHit','Restart', false, true);
			}
			else
			{
				PushState('TakeHit');
			}
		}
	}
	
}

// To C++
function bool ShouldPerformHitReaction()
{
	//Temporarily disallowing hit reactions at all times, makes guys teleport to cover.  Remove when we have the proper hit reaction animations.
	//return false;

	//Temporarily disallowing hit reactions when at cover.  Remove when we have the proper hit reaction animations.
	if ( IsAtCover(m_CoverMoveData.m_CurrentCover_Clamied, false) )
	{
		return false;
	}
		
	//Temporarily disallowing hit reactions when crouching.  Remove when we have the proper hit reaction animations.
	if( Pawn != None && Pawn.bIsCrouched )
	{
		return false;
	}

    if (IsInState('Parachuting') || IsInState('ParachutingBurstFireWait'))
        return false;

    if (IsInState('Rappelling'))
        return false;

	if( IsInState('Open_Field_Tactical_Evasion_From_Cover') )
	{
		return false;
	}

	if( IsInState('UseGrenadeAgainstEnemy') )
	{
		return false;
	}
		
	return true;
	
}

//-----------------------------------------------------------------------
// Function:
// Description:	Overridden to adjust the under fire meter.
//-----------------------------------------------------------------------
//TP OUT HIT/DEATH
//function NotifyNearMiss( Pawn shooter, Weapon ShootersWeapon, Vector ClosestPoint )
//{
//	if (!IsFriendly(shooter.Controller))
//	{
//		SeePlayer(shooter);
//		AdjustUnderFireMeter(0.2f);
//	}
//}


//***********************************************************************
// HIT/DEATH MANAGEMENT
//************************ - END SECTION - ******************************




//************************ - BEGIN SECTION - ****************************
// SQUAD MANAGEMENT FUNCTIONS
//***********************************************************************

//-----------------------------------------------------------------------
// Function:
// Description:	Sets this AI to the specified squad...
//-----------------------------------------------------------------------
// Not to C++
function SetSquad(TPSquad newSquad, optional bool bNoSquadRemove)
{
	if (!bNoSquadRemove && m_squad != None && m_squad != newSquad)
	{
		m_squad.RemoveSquadMember(self, true);
	}

	//sanity check!
	;
	m_squad = newSquad;
}


//-----------------------------------------------------------------------
// Function:
// Description:	Called by team when a new member is added to our squad.
//				NOTE: this is AI type dependent so override it if your
//				AI does not require this type of notification
//-----------------------------------------------------------------------
// Not to C++
function NotifyNewSquadMember(Controller newMember)
{
	local int playerIdx;
	// add them to the player list
	if (!IsInPlayerList(newMember,playerIdx))
	{
		;
		playerIdx = m_playerList.Length;
		m_playerList.Length = playerIdx + 1;
		m_playerList[playerIdx].Player = newMember;
		m_playerList[playerIdx].bFriendly = true;
	}
}


//-----------------------------------------------------------------------
// Function:
// Description:	Called by team when a squad member notices an enemy.
//				NOTE: this is AI type dependent so override it if your
//				AI does not require this type of notification
//-----------------------------------------------------------------------
// Not to C++
function NotifyEnemy(TPAIController notifier,Controller newEnemy)
{
	local int playerIdx;
	local bool bNewEnemy;
	if (!IsInPlayerList(newEnemy,playerIdx))
	{
		;
		// add them to the list
		playerIdx = m_playerList.Length;
		m_playerList.Length = playerIdx + 1;
		m_playerList[playerIdx].Player = newEnemy;
		m_playerList[playerIdx].bFriendly = false;
		
		//TP added - assume he is hostile?  maybe add this as a parameter
		//m_playerList[playerIdx].bHostile = true;
		
		bNewEnemy = true;

		;
	}
// 	else
// 	{
// 		//TP - still make him hostile
// 		playerIdx = GetPlayerIdx(newEnemy);
// 		
// 		`AILOG(2, 'Squad', "Notified of enemy from squad member: marking prev known enemy hostile"@notifier.GetPawnName(true)@newEnemy.GetPawnName(true));
// 		m_playerList[ playerIdx ].bHostile = true;
// 	}
		
	OnSeeEnemy(playerIdx,bNewEnemy);
}

//-----------------------------------------------------------------------
// Function:
// Description:	General purpose squad event handler.
//-----------------------------------------------------------------------
// Not to C++
function NotifySquadAIEvent(TPAIController notifier, Controller eventTarget, Name squadEvent)
{
	//`AILOG(0, 'Squad', "Received squad AI event"@squadEvent@"from"@notifier.GetPawnName(true));
}

//***********************************************************************
// SQUAD MANAGEMENT FUNCTIONS
//************************ - END SECTION - ******************************



//***********************************************************************
// DEFEND AREA FUNCTIONS
//************************ - END SECTION - ******************************



//************************ - BEGIN SECTION - ****************************
// PATHING FUNCTIONS
//***********************************************************************


//-----------------------------------------------------------------------
// Function:	 IsSomeJerkBlockingYourCover
// Description:  CHecks to see if another pawn is to close to this loc for the pawn to "snap in"
//					Desinged mostly for use going to cover but could be used anywhere.
//-----------------------------------------------------------------------
native function bool IsSomeJerkBlockingYourCover( vector SlotLoc );

//-----------------------------------------------------------------------
// Function:	 IsAFriendlyToCloseToThisLocation
// Description:  CHecks to see if another friendly pawn is within the passed in distance to the passed in point
//-----------------------------------------------------------------------
native function bool IsAFriendlyToCloseToThisLocation( vector TestLoc, float TestDist );

//-----------------------------------------------------------------------
// Function:	 PreserveRotation
// Description:  used to keep a pawn facing a current direction after its
//				 focus has been cleared
//-----------------------------------------------------------------------
native final function PreserveRotation();
// {
// 	if( Pawn != None )
// 	{
// 		FocalPoint = Pawn.Location + 500000*vector(Pawn.Rotation);
// 	}
// }

// Not to C++
final function bool HasValidMoveGoal()
{
	if (m_moveGoalInfo.moveType == emgtToActor || m_moveGoalInfo.moveType == emgtToActorPlusWorldOffset)
	{
// 		return (	m_moveGoalInfo.goalActor != None &&
// 					!IsInvalidatedMoveGoal(m_moveGoalInfo.bCoverSlotIdx, m_moveGoalInfo.goalActor)
// 				);

		return (	m_moveGoalInfo.goalActor != None );
	}
	else
	{
		return true;
	}
}


//-----------------------------------------------------------------------
// Function:	 IsAtMoveGoal
// Description:  are we at our move goal?
//-----------------------------------------------------------------------
// Not to C++
function bool IsAtMoveGoal()
{
	return false;
}

//-----------------------------------------------------------------------
// Function:	 IsMoving()
// Description:  Overridden by MoveToActorGoal state to indicate that it is
//				 moving to a goal
//-----------------------------------------------------------------------
// Not to C++
function bool IsMoving()
{
	return false;
}

// To C++
function InvalidateMoveGoal( Actor GoalToMakeInvalid, int SlotIDx /*Make Negitive if the Acotr to make invalid is not cover */)
{
	local int idx;
	local bool bFoundEntry;


	//`log(" ChadAI - InvalidateMoveGoal fn called GoalToMakeInvalid: " @ GoalToMakeInvalid @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
	//`AILOG(0, 'InvalidateMoveGoal', "- InvalidateMoveGoal GoalToMakeInvalid: " @ GoalToMakeInvalid);		

	//We only want to invalidate non-Pawn actors...
	if (GoalToMakeInvalid != None && Pawn(GoalToMakeInvalid) == None)
	{
		//`log(" ChadAI - InvalidateMoveGoal  GoalToMakeInvalid: " @ GoalToMakeInvalid @ " is not a pawn no of Invalid Goals: " @ m_invalidMoveGoals.Length @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
		// make sure it doesn't already exist in the list
		for (idx = 0; idx < m_invalidMoveGoals.Length && !bFoundEntry; idx++)
		{
			bFoundEntry = false;

			if( m_invalidMoveGoals[idx].m_InvalidGoal == GoalToMakeInvalid )
			{
				//`log(" ChadAI - InvalidateMoveGoal  GoalToMakeInvalid: " @ GoalToMakeInvalid @ " actor is all ready in list -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		

				if( TPCoverNode(GoalToMakeInvalid) != None )
				{
					//`log(" ChadAI - InvalidateMoveGoal  GoalToMakeInvalid: " @ GoalToMakeInvalid @ " is all ready in list and a TPCoverNode -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		

					if( m_invalidMoveGoals[idx].m_SlotIdx == SlotIDx )
					{
						//`log(" ChadAI - InvalidateMoveGoal  GoalToMakeInvalid: " @ GoalToMakeInvalid @ " this slot is all ready in list -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
						bFoundEntry = true;
						break;
					}
				}
				else
				{
					//`log(" ChadAI - InvalidateMoveGoal  GoalToMakeInvalid: " @ GoalToMakeInvalid @ " is all ready in list and NOT a TPCoverNode -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
					bFoundEntry = true;
					break;
				}
			}
		}

		// ok so it is not a pawn and we want to do special love to the goal if it is a cover node
		if( !bFoundEntry )
		{
			//`log(" ChadAI - InvalidateMoveGoal  GoalToMakeInvalid: " @ GoalToMakeInvalid @ " actor is NOT all ready in list -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		

			if( TPCoverNode(GoalToMakeInvalid) != None )
			{
				// it is a cover node
				//`log(" ChadAI - InvalidateMoveGoal  GoalToMakeInvalid: " @ GoalToMakeInvalid @ " actor is NOT all ready in list and is a cover node -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		

				m_invalidMoveGoals.Insert(m_invalidMoveGoals.Length, 1);
				idx = m_invalidMoveGoals.Length - 1;
				m_invalidMoveGoals[idx].m_InvalidGoal = GoalToMakeInvalid;
				m_invalidMoveGoals[idx].m_SlotIdx = SlotIDx;
				m_invalidMOveGoals[idx].m_InvalidatedTime = WorldInfo.TimeSeconds;

				;		

				
				//`log(self @ "Invalidated move goal"@m_moveGoalInfo.GoalActor @ " ---------------------------------------------------------------");

			}
			else
			{
				//`log(" ChadAI - InvalidateMoveGoal  GoalToMakeInvalid: " @ GoalToMakeInvalid @ " actor is NOT all ready in list and is NOT a cover node -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		

				m_invalidMoveGoals.Insert(m_invalidMoveGoals.Length, 1);
				idx = m_invalidMoveGoals.Length - 1;
				m_invalidMoveGoals[idx].m_InvalidGoal = m_moveGoalInfo.GoalActor;
				m_invalidMoveGoals[idx].m_SlotIdx = -1;
				m_invalidMOveGoals[idx].m_InvalidatedTime = WorldInfo.TimeSeconds;
				
				;		
			}
		}
		else
		{
			;		
			m_invalidMOveGoals[idx].m_InvalidatedTime = WorldInfo.TimeSeconds;
		}
	} // not a pawn

}

//-----------------------------------------------------------------------
// Function:
// Description: 
//-----------------------------------------------------------------------
// To C++
function InvalidateThisEvadeTacStepLocation( eRequiredMovementForEngagement TacMoveMentType )
{

	switch(TacMoveMentType)
	{
	case RequiredMove4Engage_StepCloseLeft:
		m_EvadeSideStepDynamicData.m_bStepCloseLeftLineOfFireCheckValid = false;
		m_EvadeSideStepDynamicData.m_TimeStepCloseLeftLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepCloseRight:
		m_EvadeSideStepDynamicData.m_bStepCloseRightLineOfFireCheckValid = false;
		m_EvadeSideStepDynamicData.m_TimeStepCloseRightLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepCloseForward:
		m_EvadeSideStepDynamicData.m_bStepCloseForwardLineOfFireCheckValid = false;
		m_EvadeSideStepDynamicData.m_TimeStepCloseForwardLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepCloseBack:
		m_EvadeSideStepDynamicData.m_bStepCloseBackLineOfFireCheckValid = false;
		m_EvadeSideStepDynamicData.m_TimeStepCloseBackLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepLeft:
		m_EvadeSideStepDynamicData.m_bStepLeftLineOfFireCheckValid = false;
		m_EvadeSideStepDynamicData.m_TimeStepLeftLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepRight:
		m_EvadeSideStepDynamicData.m_bStepRightLineOfFireCheckValid = false;
		m_EvadeSideStepDynamicData.m_TimeStepRightLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepForward:
		m_EvadeSideStepDynamicData.m_bStepForwardLineOfFireCheckValid = false;
		m_EvadeSideStepDynamicData.m_TimeStepForwardLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepBack:
		m_EvadeSideStepDynamicData.m_bStepBackLineOfFireCheckValid = false;
		m_EvadeSideStepDynamicData.m_TimeStepBackLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepLongLeft:
		m_EvadeSideStepDynamicData.m_bStepLongLeftLineOfFireCheckValid = false;
		m_EvadeSideStepDynamicData.m_TimeStepLongLeftLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepLongRight:
		m_EvadeSideStepDynamicData.m_bStepLongRightLineOfFireCheckValid = false;
		m_EvadeSideStepDynamicData.m_TimeStepLongRightLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepLongForward:
		m_EvadeSideStepDynamicData.m_bStepLongForwardLineOfFireCheckValid = false;
		m_EvadeSideStepDynamicData.m_TimeStepLongForwardLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepLongBack:
		m_EvadeSideStepDynamicData.m_bStepLongBackLineOfFireCheckValid = false;
		m_EvadeSideStepDynamicData.m_TimeStepLongBackLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepFarLeft:
		m_EvadeSideStepDynamicData.m_bStepFarLeftLineOfFireCheckValid = false;
		m_EvadeSideStepDynamicData.m_TimeStepFarLeftLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepFarRight:
		m_EvadeSideStepDynamicData.m_bStepFarRightLineOfFireCheckValid = false;
		m_EvadeSideStepDynamicData.m_TimeStepFarRightLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepFarForward:
		m_EvadeSideStepDynamicData.m_bStepFarForwardLineOfFireCheckValid = false;
		m_EvadeSideStepDynamicData.m_TimeStepFarForwardLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepFarBack:
		m_EvadeSideStepDynamicData.m_bStepFarBackLineOfFireCheckValid = false;
		m_EvadeSideStepDynamicData.m_TimeStepFarBackLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	};
}


//-----------------------------------------------------------------------
// Function:
// Description: 
//-----------------------------------------------------------------------
// To C++
function InvalidateThisHastyCoverTacStepLocation( eRequiredMovementForEngagement TacMoveMentType )
{

	switch(TacMoveMentType)
	{
	case RequiredMove4Engage_StepCloseLeft:
		m_HastyCoverDynamicData.m_bStepCloseLeftLineOfFireCheckValid = false;
		m_HastyCoverDynamicData.m_TimeStepCloseLeftLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepCloseRight:
		m_HastyCoverDynamicData.m_bStepCloseRightLineOfFireCheckValid = false;
		m_HastyCoverDynamicData.m_TimeStepCloseRightLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepCloseForward:
		m_HastyCoverDynamicData.m_bStepCloseForwardLineOfFireCheckValid = false;
		m_HastyCoverDynamicData.m_TimeStepCloseForwardLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepCloseBack:
		m_HastyCoverDynamicData.m_bStepCloseBackLineOfFireCheckValid = false;
		m_HastyCoverDynamicData.m_TimeStepCloseBackLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepLeft:
		m_HastyCoverDynamicData.m_bStepLeftLineOfFireCheckValid = false;
		m_HastyCoverDynamicData.m_TimeStepLeftLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepRight:
		m_HastyCoverDynamicData.m_bStepRightLineOfFireCheckValid = false;
		m_HastyCoverDynamicData.m_TimeStepRightLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepForward:
		m_HastyCoverDynamicData.m_bStepForwardLineOfFireCheckValid = false;
		m_HastyCoverDynamicData.m_TimeStepForwardLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepBack:
		m_HastyCoverDynamicData.m_bStepBackLineOfFireCheckValid = false;
		m_HastyCoverDynamicData.m_TimeStepBackLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepLongLeft:
		m_HastyCoverDynamicData.m_bStepLongLeftLineOfFireCheckValid = false;
		m_HastyCoverDynamicData.m_TimeStepLongLeftLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepLongRight:
		m_HastyCoverDynamicData.m_bStepLongRightLineOfFireCheckValid = false;
		m_HastyCoverDynamicData.m_TimeStepLongRightLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepLongForward:
		m_HastyCoverDynamicData.m_bStepLongForwardLineOfFireCheckValid = false;
		m_HastyCoverDynamicData.m_TimeStepLongForwardLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepLongBack:
		m_HastyCoverDynamicData.m_bStepLongBackLineOfFireCheckValid = false;
		m_HastyCoverDynamicData.m_TimeStepLongBackLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepFarLeft:
		m_HastyCoverDynamicData.m_bStepFarLeftLineOfFireCheckValid = false;
		m_HastyCoverDynamicData.m_TimeStepFarLeftLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepFarRight:
		m_HastyCoverDynamicData.m_bStepFarRightLineOfFireCheckValid = false;
		m_HastyCoverDynamicData.m_TimeStepFarRightLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepFarForward:
		m_HastyCoverDynamicData.m_bStepFarForwardLineOfFireCheckValid = false;
		m_HastyCoverDynamicData.m_TimeStepFarForwardLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepFarBack:
		m_HastyCoverDynamicData.m_bStepFarBackLineOfFireCheckValid = false;
		m_HastyCoverDynamicData.m_TimeStepFarBackLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	};
}


//-----------------------------------------------------------------------
// Function:
// Description: 
//-----------------------------------------------------------------------
// To C++
function InvalidateThisSliceThePieTacStepLocation( eRequiredMovementForEngagement TacMoveMentType )
{

	switch(TacMoveMentType)
	{
	case RequiredMove4Engage_StepCloseLeft:
		m_SliceThePieSideStepDynamicData.m_bStepCloseLeftLineOfFireCheckValid = false;
		m_SliceThePieSideStepDynamicData.m_TimeStepCloseLeftLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepCloseRight:
		m_SliceThePieSideStepDynamicData.m_bStepCloseRightLineOfFireCheckValid = false;
		m_SliceThePieSideStepDynamicData.m_TimeStepCloseRightLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepCloseForward:
		m_SliceThePieSideStepDynamicData.m_bStepCloseForwardLineOfFireCheckValid = false;
		m_SliceThePieSideStepDynamicData.m_TimeStepCloseForwardLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepCloseBack:
		m_SliceThePieSideStepDynamicData.m_bStepCloseBackLineOfFireCheckValid = false;
		m_SliceThePieSideStepDynamicData.m_TimeStepCloseBackLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepLeft:
		m_SliceThePieSideStepDynamicData.m_bStepLeftLineOfFireCheckValid = false;
		m_SliceThePieSideStepDynamicData.m_TimeStepLeftLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepRight:
		m_SliceThePieSideStepDynamicData.m_bStepRightLineOfFireCheckValid = false;
		m_SliceThePieSideStepDynamicData.m_TimeStepRightLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepForward:
		m_SliceThePieSideStepDynamicData.m_bStepForwardLineOfFireCheckValid = false;
		m_SliceThePieSideStepDynamicData.m_TimeStepForwardLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepBack:
		m_SliceThePieSideStepDynamicData.m_bStepBackLineOfFireCheckValid = false;
		m_SliceThePieSideStepDynamicData.m_TimeStepBackLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepLongLeft:
		m_SliceThePieSideStepDynamicData.m_bStepLongLeftLineOfFireCheckValid = false;
		m_SliceThePieSideStepDynamicData.m_TimeStepLongLeftLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepLongRight:
		m_SliceThePieSideStepDynamicData.m_bStepLongRightLineOfFireCheckValid = false;
		m_SliceThePieSideStepDynamicData.m_TimeStepLongRightLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepLongForward:
		m_SliceThePieSideStepDynamicData.m_bStepLongForwardLineOfFireCheckValid = false;
		m_SliceThePieSideStepDynamicData.m_TimeStepLongForwardLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepLongBack:
		m_SliceThePieSideStepDynamicData.m_bStepLongBackLineOfFireCheckValid = false;
		m_SliceThePieSideStepDynamicData.m_TimeStepLongBackLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepFarLeft:
		m_SliceThePieSideStepDynamicData.m_bStepFarLeftLineOfFireCheckValid = false;
		m_SliceThePieSideStepDynamicData.m_TimeStepFarLeftLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepFarRight:
		m_SliceThePieSideStepDynamicData.m_bStepFarRightLineOfFireCheckValid = false;
		m_SliceThePieSideStepDynamicData.m_TimeStepFarRightLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepFarForward:
		m_SliceThePieSideStepDynamicData.m_bStepFarForwardLineOfFireCheckValid = false;
		m_SliceThePieSideStepDynamicData.m_TimeStepFarForwardLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	case RequiredMove4Engage_StepFarBack:
		m_SliceThePieSideStepDynamicData.m_bStepFarBackLineOfFireCheckValid = false;
		m_SliceThePieSideStepDynamicData.m_TimeStepFarBackLineOfFireCheckInvalidated = WorldInfo.TimeSeconds;
		break;

	};
}

// To C++
final function UpdateEvadeTacStepInvalidateMovePosition()
{
		// FORAWARD

	if( !m_EvadeSideStepDynamicData.m_bStepCloseForwardLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_EvadeSideStepDynamicData.m_TimeStepCloseForwardLineOfFireCheckInvalidated) > m_EvadeSideStepStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_EvadeSideStepDynamicData.m_bStepCloseForwardLineOfFireCheckValid = true;
	}

	if( !m_EvadeSideStepDynamicData.m_bStepForwardLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_EvadeSideStepDynamicData.m_TimeStepForwardLineOfFireCheckInvalidated) > m_EvadeSideStepStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_EvadeSideStepDynamicData.m_bStepForwardLineOfFireCheckValid = true;
	}

	if( !m_EvadeSideStepDynamicData.m_bStepLongForwardLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_EvadeSideStepDynamicData.m_TimeStepLongForwardLineOfFireCheckInvalidated) > m_EvadeSideStepStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_EvadeSideStepDynamicData.m_bStepLongForwardLineOfFireCheckValid = true;
	}

	if( !m_EvadeSideStepDynamicData.m_bStepFarForwardLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_EvadeSideStepDynamicData.m_TimeStepFarForwardLineOfFireCheckInvalidated) > m_EvadeSideStepStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_EvadeSideStepDynamicData.m_bStepFarForwardLineOfFireCheckValid = true;
	}

	// Back

	if( !m_EvadeSideStepDynamicData.m_bStepCloseBackLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_EvadeSideStepDynamicData.m_TimeStepCloseBackLineOfFireCheckInvalidated) > m_EvadeSideStepStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_EvadeSideStepDynamicData.m_bStepCloseBackLineOfFireCheckValid = true;
	}

	if( !m_EvadeSideStepDynamicData.m_bStepBackLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_EvadeSideStepDynamicData.m_TimeStepBackLineOfFireCheckInvalidated) > m_EvadeSideStepStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_EvadeSideStepDynamicData.m_bStepBackLineOfFireCheckValid = true;
	}

	if( !m_EvadeSideStepDynamicData.m_bStepLongBackLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_EvadeSideStepDynamicData.m_TimeStepLongBackLineOfFireCheckInvalidated) > m_EvadeSideStepStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_EvadeSideStepDynamicData.m_bStepLongBackLineOfFireCheckValid = true;
	}

	if( !m_EvadeSideStepDynamicData.m_bStepFarBackLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_EvadeSideStepDynamicData.m_TimeStepFarBackLineOfFireCheckInvalidated) > m_EvadeSideStepStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_EvadeSideStepDynamicData.m_bStepFarBackLineOfFireCheckValid = true;
	}

	// Left

	if( !m_EvadeSideStepDynamicData.m_bStepCloseLeftLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_EvadeSideStepDynamicData.m_TimeStepCloseLeftLineOfFireCheckInvalidated) > m_EvadeSideStepStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_EvadeSideStepDynamicData.m_bStepCloseLeftLineOfFireCheckValid = true;
	}

	if( !m_EvadeSideStepDynamicData.m_bStepLeftLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_EvadeSideStepDynamicData.m_TimeStepLeftLineOfFireCheckInvalidated) > m_EvadeSideStepStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_EvadeSideStepDynamicData.m_bStepLeftLineOfFireCheckValid = true;
	}

	if( !m_EvadeSideStepDynamicData.m_bStepLongLeftLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_EvadeSideStepDynamicData.m_TimeStepLongLeftLineOfFireCheckInvalidated) > m_EvadeSideStepStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_EvadeSideStepDynamicData.m_bStepLongLeftLineOfFireCheckValid = true;
	}

	if( !m_EvadeSideStepDynamicData.m_bStepFarLeftLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_EvadeSideStepDynamicData.m_TimeStepFarLeftLineOfFireCheckInvalidated) > m_EvadeSideStepStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_EvadeSideStepDynamicData.m_bStepFarLeftLineOfFireCheckValid = true;
	}

	// Right

	if( !m_EvadeSideStepDynamicData.m_bStepCloseRightLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_EvadeSideStepDynamicData.m_TimeStepCloseRightLineOfFireCheckInvalidated) > m_EvadeSideStepStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_EvadeSideStepDynamicData.m_bStepCloseRightLineOfFireCheckValid = true;
	}

	if( !m_EvadeSideStepDynamicData.m_bStepRightLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_EvadeSideStepDynamicData.m_TimeStepRightLineOfFireCheckInvalidated) > m_EvadeSideStepStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_EvadeSideStepDynamicData.m_bStepRightLineOfFireCheckValid = true;
	}

	if( !m_EvadeSideStepDynamicData.m_bStepLongRightLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_EvadeSideStepDynamicData.m_TimeStepLongRightLineOfFireCheckInvalidated) > m_EvadeSideStepStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_EvadeSideStepDynamicData.m_bStepLongRightLineOfFireCheckValid = true;
	}

	if( !m_EvadeSideStepDynamicData.m_bStepFarRightLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_EvadeSideStepDynamicData.m_TimeStepFarRightLineOfFireCheckInvalidated) > m_EvadeSideStepStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_EvadeSideStepDynamicData.m_bStepFarRightLineOfFireCheckValid = true;
	}

}


// To C++
final function UpdateHastyCoverTacStepInvalidateMovePosition()
{
		// FORAWARD

	if( !m_HastyCoverDynamicData.m_bStepCloseForwardLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_HastyCoverDynamicData.m_TimeStepCloseForwardLineOfFireCheckInvalidated) > m_HastyCoverStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_HastyCoverDynamicData.m_bStepCloseForwardLineOfFireCheckValid = true;
	}

	if( !m_HastyCoverDynamicData.m_bStepForwardLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_HastyCoverDynamicData.m_TimeStepForwardLineOfFireCheckInvalidated) > m_HastyCoverStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_HastyCoverDynamicData.m_bStepForwardLineOfFireCheckValid = true;
	}

	if( !m_HastyCoverDynamicData.m_bStepLongForwardLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_HastyCoverDynamicData.m_TimeStepLongForwardLineOfFireCheckInvalidated) > m_HastyCoverStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_HastyCoverDynamicData.m_bStepLongForwardLineOfFireCheckValid = true;
	}

	if( !m_HastyCoverDynamicData.m_bStepFarForwardLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_HastyCoverDynamicData.m_TimeStepFarForwardLineOfFireCheckInvalidated) > m_HastyCoverStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_HastyCoverDynamicData.m_bStepFarForwardLineOfFireCheckValid = true;
	}

	// Back

	if( !m_HastyCoverDynamicData.m_bStepCloseBackLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_HastyCoverDynamicData.m_TimeStepCloseBackLineOfFireCheckInvalidated) > m_HastyCoverStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_HastyCoverDynamicData.m_bStepCloseBackLineOfFireCheckValid = true;
	}

	if( !m_HastyCoverDynamicData.m_bStepBackLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_HastyCoverDynamicData.m_TimeStepBackLineOfFireCheckInvalidated) > m_HastyCoverStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_HastyCoverDynamicData.m_bStepBackLineOfFireCheckValid = true;
	}

	if( !m_HastyCoverDynamicData.m_bStepLongBackLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_HastyCoverDynamicData.m_TimeStepLongBackLineOfFireCheckInvalidated) > m_HastyCoverStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_HastyCoverDynamicData.m_bStepLongBackLineOfFireCheckValid = true;
	}

	if( !m_HastyCoverDynamicData.m_bStepFarBackLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_HastyCoverDynamicData.m_TimeStepFarBackLineOfFireCheckInvalidated) > m_HastyCoverStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_HastyCoverDynamicData.m_bStepFarBackLineOfFireCheckValid = true;
	}

	// Left

	if( !m_HastyCoverDynamicData.m_bStepCloseLeftLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_HastyCoverDynamicData.m_TimeStepCloseLeftLineOfFireCheckInvalidated) > m_HastyCoverStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_HastyCoverDynamicData.m_bStepCloseLeftLineOfFireCheckValid = true;
	}

	if( !m_HastyCoverDynamicData.m_bStepLeftLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_HastyCoverDynamicData.m_TimeStepLeftLineOfFireCheckInvalidated) > m_HastyCoverStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_HastyCoverDynamicData.m_bStepLeftLineOfFireCheckValid = true;
	}

	if( !m_HastyCoverDynamicData.m_bStepLongLeftLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_HastyCoverDynamicData.m_TimeStepLongLeftLineOfFireCheckInvalidated) > m_HastyCoverStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_HastyCoverDynamicData.m_bStepLongLeftLineOfFireCheckValid = true;
	}

	if( !m_HastyCoverDynamicData.m_bStepFarLeftLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_HastyCoverDynamicData.m_TimeStepFarLeftLineOfFireCheckInvalidated) > m_HastyCoverStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_HastyCoverDynamicData.m_bStepFarLeftLineOfFireCheckValid = true;
	}

	// Right

	if( !m_HastyCoverDynamicData.m_bStepCloseRightLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_HastyCoverDynamicData.m_TimeStepCloseRightLineOfFireCheckInvalidated) > m_HastyCoverStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_HastyCoverDynamicData.m_bStepCloseRightLineOfFireCheckValid = true;
	}

	if( !m_HastyCoverDynamicData.m_bStepRightLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_HastyCoverDynamicData.m_TimeStepRightLineOfFireCheckInvalidated) > m_HastyCoverStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_HastyCoverDynamicData.m_bStepRightLineOfFireCheckValid = true;
	}

	if( !m_HastyCoverDynamicData.m_bStepLongRightLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_HastyCoverDynamicData.m_TimeStepLongRightLineOfFireCheckInvalidated) > m_HastyCoverStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_HastyCoverDynamicData.m_bStepLongRightLineOfFireCheckValid = true;
	}

	if( !m_HastyCoverDynamicData.m_bStepFarRightLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_HastyCoverDynamicData.m_TimeStepFarRightLineOfFireCheckInvalidated) > m_HastyCoverStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_HastyCoverDynamicData.m_bStepFarRightLineOfFireCheckValid = true;
	}

}



// To C++
final function UpdateSliceThePieTacStepInvalidateMovePosition()
{
		// FORAWARD

	if( !m_SliceThePieSideStepDynamicData.m_bStepCloseForwardLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_SliceThePieSideStepDynamicData.m_TimeStepCloseForwardLineOfFireCheckInvalidated) > m_SliceThePieSideStepStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_SliceThePieSideStepDynamicData.m_bStepCloseForwardLineOfFireCheckValid = true;
	}

	if( !m_SliceThePieSideStepDynamicData.m_bStepForwardLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_SliceThePieSideStepDynamicData.m_TimeStepForwardLineOfFireCheckInvalidated) > m_SliceThePieSideStepStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_SliceThePieSideStepDynamicData.m_bStepForwardLineOfFireCheckValid = true;
	}

	if( !m_SliceThePieSideStepDynamicData.m_bStepLongForwardLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_SliceThePieSideStepDynamicData.m_TimeStepLongForwardLineOfFireCheckInvalidated) > m_SliceThePieSideStepStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_SliceThePieSideStepDynamicData.m_bStepLongForwardLineOfFireCheckValid = true;
	}

	if( !m_SliceThePieSideStepDynamicData.m_bStepFarForwardLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_SliceThePieSideStepDynamicData.m_TimeStepFarForwardLineOfFireCheckInvalidated) > m_SliceThePieSideStepStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_SliceThePieSideStepDynamicData.m_bStepFarForwardLineOfFireCheckValid = true;
	}

	// Back

	if( !m_SliceThePieSideStepDynamicData.m_bStepCloseBackLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_SliceThePieSideStepDynamicData.m_TimeStepCloseBackLineOfFireCheckInvalidated) > m_SliceThePieSideStepStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_SliceThePieSideStepDynamicData.m_bStepCloseBackLineOfFireCheckValid = true;
	}

	if( !m_SliceThePieSideStepDynamicData.m_bStepBackLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_SliceThePieSideStepDynamicData.m_TimeStepBackLineOfFireCheckInvalidated) > m_SliceThePieSideStepStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_SliceThePieSideStepDynamicData.m_bStepBackLineOfFireCheckValid = true;
	}

	if( !m_SliceThePieSideStepDynamicData.m_bStepLongBackLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_SliceThePieSideStepDynamicData.m_TimeStepLongBackLineOfFireCheckInvalidated) > m_SliceThePieSideStepStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_SliceThePieSideStepDynamicData.m_bStepLongBackLineOfFireCheckValid = true;
	}

	if( !m_SliceThePieSideStepDynamicData.m_bStepFarBackLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_SliceThePieSideStepDynamicData.m_TimeStepFarBackLineOfFireCheckInvalidated) > m_SliceThePieSideStepStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_SliceThePieSideStepDynamicData.m_bStepFarBackLineOfFireCheckValid = true;
	}

	// Left

	if( !m_SliceThePieSideStepDynamicData.m_bStepCloseLeftLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_SliceThePieSideStepDynamicData.m_TimeStepCloseLeftLineOfFireCheckInvalidated) > m_SliceThePieSideStepStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_SliceThePieSideStepDynamicData.m_bStepCloseLeftLineOfFireCheckValid = true;
	}

	if( !m_SliceThePieSideStepDynamicData.m_bStepLeftLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_SliceThePieSideStepDynamicData.m_TimeStepLeftLineOfFireCheckInvalidated) > m_SliceThePieSideStepStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_SliceThePieSideStepDynamicData.m_bStepLeftLineOfFireCheckValid = true;
	}

	if( !m_SliceThePieSideStepDynamicData.m_bStepLongLeftLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_SliceThePieSideStepDynamicData.m_TimeStepLongLeftLineOfFireCheckInvalidated) > m_SliceThePieSideStepStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_SliceThePieSideStepDynamicData.m_bStepLongLeftLineOfFireCheckValid = true;
	}

	if( !m_SliceThePieSideStepDynamicData.m_bStepFarLeftLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_SliceThePieSideStepDynamicData.m_TimeStepFarLeftLineOfFireCheckInvalidated) > m_SliceThePieSideStepStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_SliceThePieSideStepDynamicData.m_bStepFarLeftLineOfFireCheckValid = true;
	}

	// Right
	if( !m_SliceThePieSideStepDynamicData.m_bStepCloseRightLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_SliceThePieSideStepDynamicData.m_TimeStepCloseRightLineOfFireCheckInvalidated) > m_SliceThePieSideStepStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_SliceThePieSideStepDynamicData.m_bStepCloseRightLineOfFireCheckValid = true;
	}

	if( !m_SliceThePieSideStepDynamicData.m_bStepRightLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_SliceThePieSideStepDynamicData.m_TimeStepRightLineOfFireCheckInvalidated) > m_SliceThePieSideStepStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_SliceThePieSideStepDynamicData.m_bStepRightLineOfFireCheckValid = true;
	}

	if( !m_SliceThePieSideStepDynamicData.m_bStepLongRightLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_SliceThePieSideStepDynamicData.m_TimeStepLongRightLineOfFireCheckInvalidated) > m_SliceThePieSideStepStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_SliceThePieSideStepDynamicData.m_bStepLongRightLineOfFireCheckValid = true;
	}

	if( !m_SliceThePieSideStepDynamicData.m_bStepFarRightLineOfFireCheckValid && 
		((WorldInfo.TimeSeconds -  m_SliceThePieSideStepDynamicData.m_TimeStepFarRightLineOfFireCheckInvalidated) > m_SliceThePieSideStepStaticData.m_HowOfftenToRevertInvalidatedTacStepLoc) )
	{
		m_SliceThePieSideStepDynamicData.m_bStepFarRightLineOfFireCheckValid = true;
	}

}

// Not to C++
final function UpdatePawnWatcher()
{
	//`log(" ChadAI - " @ Self @ " UpdatePawnWatcher At: " @ WorldInfo.TimeSeconds @ " My Pawn is: " @ Pawn @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		

	if( Pawn == None )
	{
		//`log(" ChadAI - " @ Self @ " UpdatePawnWatcher At: " @ WorldInfo.TimeSeconds @ " My Pawn Went Away HighLevelGoal: " @ m_HighLevelAiGoal @ " Sub State Tag: " @ m_SubStateDebugInfoTag @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
	}
}
 

//-----------------------------------------------------------------------
// Function:
// Description: Updates the timer for invalidated move goals...
//-----------------------------------------------------------------------
// To C++
final function UpdateTacticalEngagementData()
{
	UpdateSliceThePieTacStepInvalidateMovePosition();
	UpdateHastyCoverTacStepInvalidateMovePosition();
	UpdateEvadeTacStepInvalidateMovePosition();

	if( m_Engagement_Tac_Data.m_bKnowBeingAimedAt )
	{
		if( (WorldInfo.TimeSeconds -  m_Engagement_Tac_Data.m_LastTimeKnewBeingAimedAt ) >= class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_LengthOfTimeToKnowBeingAimedAt )
		{
			//`log(" ChadAI - Pawn " @ Pawn @ " m_bKnowBeingAimedAt and m_LengthOfTimeToKnowBeingAimedAt has passed so no longer know being aimed at -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
		
			m_Engagement_Tac_Data.m_bKnowBeingAimedAt = false;
			m_Engagement_Tac_Data.m_LastTimeKnewBeingAimedAt = -1.0;
		}
	}

	if( m_Engagement_Tac_Data.m_bTookHit )
	{
		if( (WorldInfo.TimeSeconds -  m_Engagement_Tac_Data.m_LastTimeKnewTookHit ) >= class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_LengthOfTimeToKnowTookHit )
		{
			//`log(" ChadAI - Pawn " @ Pawn @ " m_bKnowBeingAimedAt and m_LengthOfTimeToKnowBeingAimedAt has passed so no longer know being aimed at -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
		
			m_Engagement_Tac_Data.m_bTookHit = false;
			m_Engagement_Tac_Data.m_LastTimeKnewTookHit = -1.0;
		}
	}
}

//-----------------------------------------------------------------------
// Function:
// Description: Updates the timer for invalidated move goals...
//-----------------------------------------------------------------------
// To C++
final function UpdateInvalidatedMoveGoals()
{
	local int idx;

	//`log(" ChadAI - Pawn " @ Pawn @ " UpdateInvalidatedMoveGoals -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		

	for (idx = 0; idx < m_invalidMoveGoals.Length; idx++)
	{
		if (WorldInfo.TimeSeconds - m_invalidMoveGoals[idx].m_InvalidatedTime > INVALIDGOAL_DURATION)
		{
			m_invalidMoveGoals.Remove(idx--,1);
		}
	}

	for (idx = 0; idx < m_invalidCQB_Targets.Length; idx++)
	{
		if (WorldInfo.TimeSeconds - m_invalidCQB_Targets[idx].m_InvalidatedTime > INVALIDGOAL_DURATION)
		{
			m_invalidCQB_Targets.Remove(idx--,1);
		}
	}
}


//-----------------------------------------------------------------------
// Function: InvalidateMoveGoal( Pawn PawnToMakeInvalid )
// Description: Marks a Pawn as not able to enter CQB and try and Melee
//-----------------------------------------------------------------------
// To C++
function InvalidateCQB_Target( Pawn PawnToMakeInvalid )
{
	local int idx;
	local bool bFoundEntry;
	local InvalidatedCQB_TargetInfo newInfo;


	//`log(" ChadAI - Pawn " @ Pawn @ " InvalidateCQB_Target fn called PawnToMakeInvalid: " @ PawnToMakeInvalid @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
	;		

	//We only want to invalidate non-Pawn actors...
	if (PawnToMakeInvalid != None )
	{
		// make sure it doesn't already exist in the list
		for (idx = 0; idx < m_invalidCQB_Targets.Length && !bFoundEntry; idx++)
		{
			bFoundEntry = false;

			if( m_invalidCQB_Targets[idx].m_InvalidTarget == PawnToMakeInvalid )
			{
				//`log(" ChadAI - Pawn " @ Pawn @ " InvalidateCQB_Target  PawnToMakeInvalid: " @ PawnToMakeInvalid @ " Pawn is all ready in list -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
				bFoundEntry = true;
			}
		}

		// ok so it is not a pawn and we want to do special love to the goal if it is a cover node
		if( !bFoundEntry )
		{
			//`log(" ChadAI - Pawn " @ Pawn @ " InvalidateCQB_Target  PawnToMakeInvalid: " @ PawnToMakeInvalid @ " Pawn is NOT all ready in list -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
			//`log(" ChadAI - Pawn " @ Pawn @ " InvalidateCQB_Target  m_invalidCQB_Targets.Length: " @ m_invalidCQB_Targets.Length @ " Before Insert -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		

			newInfo.m_InvalidTarget = PawnToMakeInvalid;
			newInfo.m_InvalidatedTime = WorldInfo.TimeSeconds;

 			//idx = m_invalidCQB_Targets.Length;
// 			m_invalidCQB_Targets.Length = idx + 1;
			m_invalidCQB_Targets.AddItem(newInfo);

			//`log(" ChadAI - Pawn " @ Pawn @ " InvalidateCQB_Target  m_invalidCQB_Targets.Length: " @ m_invalidCQB_Targets.Length @ " After Insert -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
			
			;		
		}
		else
		{
			//`log(" ChadAI - Pawn " @ Pawn @ " InvalidateCQB_Target  PawnToMakeInvalid: " @ m_invalidCQB_Targets[idx].m_InvalidTarget @ " was already in the list so invalid time is updated -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		

			;		
			m_invalidCQB_Targets[idx].m_InvalidatedTime = WorldInfo.TimeSeconds;
		}
	} // not a pawn

}


//-----------------------------------------------------------------------
// Event:
// Description:
//-----------------------------------------------------------------------
// Not to C++
event bool NotifyBump(Actor Other, vector HitNormal)
{
	local Pawn bumpPawn;
	local Controller bumpController;
	
	bumpPawn = Pawn(Other);
	bumpController = GetController(bumpPawn);
	
	if (Pawn != None && bumpPawn != None && bumpController != None && 
		IsFriendly(bumpController))
	{
		;
		// try to step aside for them
		StepAsideFor(bumpPawn);
	}
	return Super.NotifyBump(Other,HitNormal);
}


//-----------------------------------------------------------------------
// Function:
// Description:	Returns true if we can step aside for the specified player.
//-----------------------------------------------------------------------
// To C++
function bool StepAsideFor(Pawn chkPawn)
{
	if (Pawn != None && chkPawn != None && !m_bNoStepAside && 
		!IsAtCover(m_CoverMoveData.m_CurrentCover_Clamied, false ) && !KynapseIsActive())
	{
		;
		if (chkPawn != m_stepAsideGoal)
		{
			m_stepAsideGoal = chkPawn;
			if (GetStateName() != 'StepAside')
			{
				;
				PushState('StepAside');
			}
			else
			{
				;
				GotoState('StepAside','Begin',true,true);
			}
		}
		return true;
	}
	return false;
}

//-----------------------------------------------------------------------
// Function:
// Description:	Pops off entries in the route cache until we hit a reachable
//				entry that we're not already at.
//
//				@return	the next entry in the route cache
//
//-----------------------------------------------------------------------
// Not to C++
final function Actor DecrementRouteCache()
{
	local int i, j;
	local Actor newRoute;
	// iterate through the current route cache
	for (i = 0; i < RouteCache.Length; i++)
	{
		if (RouteCache[i] == None)
		{
			// nothing left to check
			break;
		}
		// see if this point requires movement, and is reachable
		// SPAI TODO: If ActorReachable() fails for a point in the list, it is extremely likely that further points in the list
		// will also fail
		// So it might be better at that point to just nuke the routecache and bail out
		if (!Pawn.ReachedDestination(RouteCache[i]) && ActorReachable(RouteCache[i]))
		{
			newRoute = RouteCache[i];
			// set this as our new route cache entry
			for (j = 0; j < RouteCache.Length; j++)
			{
				RouteCache[j] = RouteCache[i];
				RouteCache[i] = None;
				i++;
				// see if there are any more entries to adjust
				if (i >= RouteCache.Length ||
					RouteCache[i] == None)
				{
					// all done
					break;
				}
			}
			break;
		}
		else
		{
			// clear this entry since it is invalid
			RouteCache[i] = None;
		}
	}
	return newRoute;
}



//-----------------------------------------------------------------------
// Function:
// Description: Resets movement stuff.
//				Optionally not reset any SeqAct_AIMoveToActor latent
//				Kismet actions
//-----------------------------------------------------------------------
native function ClearMove(optional bool bNoAIMoveToActorLatentClear);

//-----------------------------------------------------------------------
// Function:
// Description: Mostly called by ClearMove() to reset movement velocity.
//				Put in a function so that it can be overridden..
//-----------------------------------------------------------------------
native function ClearMoveVelocity();


//-----------------------------------------------------------------------
// Function:
// Description: Clears AIMoveToActor latent execution
//-----------------------------------------------------------------------
native function ClearAIMoveToActorLatentExecution();

native function StopFiring();


//-----------------------------------------------------------------------
// Function:	SetNonKynapseMoveGoal
// Description: sets where we want to move to and moves there
//-----------------------------------------------------------------------
// Not to C++
function SetNonKynapseMoveGoal(	Actor inGoalActor,
								Vector loc,
								EMoveGoalType moveType,
								bool inbInterruptable,		/** Can this move be interrupted by enemy detection? */
								bool inbInterruptAndContinue,		/** Can this move be interrupted by enemy detection and then go back to moving */
								int  inmaxBlockedPathAttempts, /** How many failures before giving up */
								bool bKismetCommand,		/** This move to goal was executed from Kismet */
								bool inAllowedToWander,
								bool inAllowWaitingForPathToClear,
								float inTimeToWaitForPathToClear,
								bool inAllowCheckForGoalBlocked,
								float inUpdateTimeToCheckForPawnBlockingGoal,
								float inDistenceAwayToWaitIfGoalBlocked,
								float inTimeToWanderOrStandBetweenChecksForPathToClear
					)
{
	if (moveType != emgtToPoint)
	{
		if (inGoalActor == None)
		{
			;
			m_bMoveAborted = true;
			return;
		}

		if (moveType == emgtToActor)
		{
			//`log("Loc set to Zero Because moveType == emgtToActor");
			loc.x = 0;
			loc.y = 0;
			loc.z = 0;
		}
	}

	m_moveGoalInfo.goalActor				= inGoalActor;
	if (Pawn(inGoalActor) != None)
		m_moveGoalInfo.goalController		= Pawn(inGoalActor).Controller;
	m_moveGoalInfo.bInterruptable			= inbInterruptable;
	m_moveGoalInfo.bInterruptAndContinue	= inbInterruptAndContinue;
	m_moveGoalInfo.maxBlockedPathAttempts	= inmaxBlockedPathAttempts;
	m_moveGoalInfo.moveType					= moveType;
	m_moveGoalInfo.loc						= loc;
	m_moveGoalInfo.bKismetCommand			= bKismetCommand;

	m_moveGoalInfo.m_bAllowedToWander						= inAllowedToWander;
	m_moveGoalInfo.m_bAllowWaitingForPathToClear			= inAllowWaitingForPathToClear;
	m_moveGoalInfo.m_TimeToWaitForPathToClear				= inTimeToWaitForPathToClear;
	m_moveGoalInfo.m_bAllowCheckForGoalBlocked				= inAllowCheckForGoalBlocked;
	m_moveGoalInfo.m_UpdateTimeToCheckForPawnBlockingGoal	= inUpdateTimeToCheckForPawnBlockingGoal;
	m_moveGoalInfo.m_DistenceAwayToWaitIfGOalBlocked		= inDistenceAwayToWaitIfGoalBlocked;
	m_WanderInfo.m_TimeToWanderOrStandWaitingForPathOrPositionToClear		= inTimeToWanderOrStandBetweenChecksForPathToClear;


	// reset the move attempts as well
	m_moveGoalInfo.moveAttempts = 0;	

	// TODO:  find a better solution for this.  experiment with push and pop to see what happens
	// if you pop twice in a function and such.  if things work how i hope they do, we could have a
	// function called GotoMoveToGoal which would allow various states to decide if they want to
	// push or goto
	GotoState('NonKynapseMoveToActorGoal','Begin',true,true);
}

//-----------------------------------------------------------------------
// Function:	SetMoveGoal
// Description: sets where we want to move to and moves there
//-----------------------------------------------------------------------
// Not to C++
function SetMoveGoal(	Actor inGoalActor,
						Vector loc,
						EMoveGoalType moveType,
						bool inbInterruptable,		/** Can this move be interrupted by enemy detection? */
						bool inbInterruptAndContinue,		/** Can this move be interrupted by enemy detection and then go back to moving */
						int  inmaxBlockedPathAttempts, /** How many failures before giving up */
						bool bKismetCommand,		/** This move to goal was executed from Kismet */
						bool inAllowedToWander,
						bool inAllowWaitingForPathToClear,
						float inTimeToWaitForPathToClear,
						bool inAllowCheckForGoalBlocked,
						float inUpdateTimeToCheckForPawnBlockingGoal,
						float inDistenceAwayToWaitIfGoalBlocked,
						float inTimeToWanderOrStandBetweenChecksForPathToClear
					)
{
	if (moveType != emgtToPoint)
	{
		if (inGoalActor == None)
		{
			;
			m_bMoveAborted = true;
			return;
		}

		if (moveType == emgtToActor)
		{
			//`log("Loc set to Zero Because moveType == emgtToActor");
			loc.x = 0;
			loc.y = 0;
			loc.z = 0;
		}
	}

	m_moveGoalInfo.goalActor				= inGoalActor;
	if (Pawn(inGoalActor) != None)
		m_moveGoalInfo.goalController		= Pawn(inGoalActor).Controller;
	m_moveGoalInfo.bInterruptable			= inbInterruptable;
	m_moveGoalInfo.bInterruptAndContinue	= inbInterruptAndContinue;
	m_moveGoalInfo.maxBlockedPathAttempts	= inmaxBlockedPathAttempts;
	m_moveGoalInfo.moveType					= moveType;
	m_moveGoalInfo.loc						= loc;
	m_moveGoalInfo.bKismetCommand			= bKismetCommand;

	m_moveGoalInfo.m_bAllowedToWander						= inAllowedToWander;
	m_moveGoalInfo.m_bAllowWaitingForPathToClear			= inAllowWaitingForPathToClear;
	m_moveGoalInfo.m_TimeToWaitForPathToClear				= inTimeToWaitForPathToClear;
	m_moveGoalInfo.m_bAllowCheckForGoalBlocked				= inAllowCheckForGoalBlocked;
	m_moveGoalInfo.m_UpdateTimeToCheckForPawnBlockingGoal	= inUpdateTimeToCheckForPawnBlockingGoal;
	m_moveGoalInfo.m_DistenceAwayToWaitIfGOalBlocked		= inDistenceAwayToWaitIfGoalBlocked;
	m_WanderInfo.m_TimeToWanderOrStandWaitingForPathOrPositionToClear		= inTimeToWanderOrStandBetweenChecksForPathToClear;


	// reset the move attempts as well
	m_moveGoalInfo.moveAttempts = 0;	

	// TODO:  find a better solution for this.  experiment with push and pop to see what happens
	// if you pop twice in a function and such.  if things work how i hope they do, we could have a
	// function called GotoMoveToGoal which would allow various states to decide if they want to
	// push or goto
	GotoState('MoveToActorGoal','Begin',true,true);
}

// Not to C++
function FinishedMoveToGoal()
{
	;

	if (TPPawn(Pawn) != None)
	{
		TPPawn(Pawn).FinishedMove(m_bMoveAborted);
	}

//	`log(self @ "FinishedMoveToGoal");
	PopState();
}


// Not to C++
function AbortMove( bool bInvalidateMoveGoal )
{
	;
	
	if( bInvalidateMoveGoal )
	{
		InvalidateMoveGoal(m_moveGoalInfo.goalActor, -1);
	}
	
	m_bMoveAborted = true;

	if (Pawn!=none && Pawn.Physics != PHYS_Falling)
	{
		Pawn.Velocity = vect(0,0,0);
		Pawn.Acceleration = vect(0,0,0);
	}
}


//***********************************************************************
// PATHING FUNCTIONS
//************************ - END SECTION - ******************************




//************************ - BEGIN SECTION - ****************************
// COVER FUNCTIONS
//***********************************************************************

//-----------------------------------------------------------------------
// Function:
// Description:	Controllers who wish to use cover should override this!
//-----------------------------------------------------------------------
// Not to C++
function bool CanUseCover()
{
	return false;
}


//-----------------------------------------------------------------------
// Function:
// Description:	Returns our current cover.
//-----------------------------------------------------------------------
// Not to C++
function CoverInfo GetCoverAt()
{
	//return None;
	return m_CoverMoveData.m_CurrentCover_Clamied;
}


//-----------------------------------------------------------------------
// Function:
// Description:	Returns true if a given cover is valid.
//-----------------------------------------------------------------------
native function bool IsValidCover(CoverInfo cover);

//-----------------------------------------------------------------------
// Function:
// Description:	Returns true if we have valid cover.
//-----------------------------------------------------------------------
native function bool HasValidCover();

//-----------------------------------------------------------------------
// Function:
// Description:	Returns true if we have valid reserved cover.
//-----------------------------------------------------------------------
native function bool HasValidReservedCover(optional bool bNoEnemyValidation);

//-----------------------------------------------------------------------
// Function:	 ClearCurrentCover
// Description:  clears the cover point we are current at
//-----------------------------------------------------------------------
native function ClearCurrentCover();

//-----------------------------------------------------------------------
// Function:	 SetAimAndHeadTrack
// Description:  enables/disables aim and head tracking
//-----------------------------------------------------------------------
// To C++
final function SetAimAndHeadTrack(optional bool enable=true)
{
	local SkelControlLookAt htrack;
	local TPPawn Driver;
	local Vehicle lVehicle;

	if( Pawn != None )
	{
		if (Pawn.IsA('Vehicle'))
		{
			lVehicle = Vehicle(Pawn);
			Driver = TPPawn(lVehicle.Driver);
			if (Driver != None)
			{
				Driver.bUseAimOffset = enable;
				htrack = SkelControlLookAt(Driver.Mesh.FindSkelControl('HeadTrack'));
				htrack.SetSkelControlActive(enable);
			}
		}
		else if (!Pawn.IsA('PlayerPawn'))
		{
			TPPawn(Pawn).bUseAimOffset = enable;
			htrack = SkelControlLookAt(Pawn.Mesh.FindSkelControl('HeadTrack'));
			htrack.SetSkelControlActive(enable);

			//if we're in gogglevision...
			if (Pawn.Weapon != None && Pawn.Weapon.IsA('G47Sniper') && TPGameInfo(WorldInfo.Game).bLastGoggleSetting == true)
			{
				TPWeapon(Pawn.Weapon).ToggleUVLight(enable);
			}
		}
	}
}


//-----------------------------------------------------------------------
// Function:	 ClearReservedCover
// Description:  clears the cover point we currently have reserved
//-----------------------------------------------------------------------
native function ClearReservedCover();

//-----------------------------------------------------------------------
// Function:	 IsAtCover
// Description:  true if we are currently at the specified cover point and in the
//				 cover state
//-----------------------------------------------------------------------
native function bool IsAtCover(CoverInfo coverPt, bool bClaimIfCloseEnough );

//-----------------------------------------------------------------------
// Function:	 ReserveCover - Implimentation of GoW Claim Cover starting on 2 Feb 2007
// Description:  reserves the cover point for ourselves for future use
//-----------------------------------------------------------------------
native function bool ReserveCover(CoverInfo NewCover);

//-----------------------------------------------------------------------
// Function:	 OccupyCover
// Description:  sets that we are at cover
//-----------------------------------------------------------------------
native function bool OccupyCover(CoverInfo CoverToOccupy);

//-----------------------------------------------------------------------
// Function:
// Description:	Quick, high level reject of cover nodes.
//				@return	true to indicate this cover is worth evaluating
//-----------------------------------------------------------------------
native function bool IsPotentialCover(CoverInfo chkNode);
												
//-----------------------------------------------------------------------
// Function:
// Description:	Gives a value of how much a cover point is in the direction of
//				of the loc to attack. 1.0 is in direct line 0.0 is 90 degrees off
//				and -1.0 is in the direct opposite direction
//-----------------------------------------------------------------------
native noexport function float GetCoversLineToAttackLocFactor(CoverInfo inNode, Actor AttackLoc);												
												
												
//-----------------------------------------------------------------------
// Function:
// Description:	Gives a value of how much a cover point's orientation is in the direction of
//				of the loc to attack. 1.0 is in direct line 0.0 is 90 degrees off
//				and -1.0 is in the direct opposite direction
//-----------------------------------------------------------------------
native noexport function float GetCoversDirectionToLineFoAttackFactor(CoverInfo inNode, Actor AttackLoc);

//-----------------------------------------------------------------------
// Function:
// Description:	Returns true if the AttackLoc is inside the fire sector dot product set in the cover node
//-----------------------------------------------------------------------
native noexport function bool IsEnemyOutSideOfCoversFireSector(CoverInfo inNode, Actor AttackLoc, out float XY_Dot /*This is an out Value*/);		


//-----------------------------------------------------------------------
// Function:
// Description:	Returns true if we are currently behind cover and not
//				peeking out.
//-----------------------------------------------------------------------
// To C++
function bool IsBehindCover()
{
	local CoverLink.ECoverAction covAction;
	covAction = GetCurrentCoverAction();

	return (IsAtCover(m_CoverMoveData.m_CurrentCover_Clamied, false ) &&
			GetCurrentCoverType() != CT_None &&
			(covAction == CA_Default ||
			 covAction == CA_BlindLeft ||
			 covAction == CA_BlindRight));
}


//-----------------------------------------------------------------------
// Function:
// Description:	Returns true if our enemy is currently behind BTW cover.
//-----------------------------------------------------------------------
native final function bool IsEnemyBehindCover(optional bool bNoEnemyValidation, optional bool bNoVisibilityCheck);


native function bool IsAngleToEnemyValidForThisCoverSlot( CoverInfo Cover2Test, optional out float XY_Dot );


native function ShiftPawnPositionBasedUponCoverAction( CoverInfo CoverUsing, ECoverAction CovAction, CoverBehavior CoverState );

native function SnapPawnPositionToGroundAtCover( CoverInfo CoverUsing, Vector PreSnapOffset, float VerticalShiftOffset );

// To C++
function HandleAtCoverCollisionChange( CoverInfo CoverAt )
{
	//`log(" ChadAI - HandleAtCoverCollisionChange fn called");

	if( CoverAt.Link != None && Pawn != None)
	{
		Pawn.SetPhysics(PHYS_None);
		//`log(" ChadAI - HandleAtCoverCollisionChange Type of Cover At: " @ CoverAt.Link.Slots[CoverAt.SlotIdx].CoverType );

		if( ( CoverAt.Link.Slots[CoverAt.SlotIdx].CoverType == CT_Standing  )  || 
			( CoverAt.Link.Slots[CoverAt.SlotIdx].CoverType == CT_MidLevel ) )
		{
			//`log(" ChadAI - HandleAtCoverCollisionChange setting Pawn.bCollideWorld=false and Pawn.SetPhysics(PHYS_None)");

			Pawn.bCollideWorld=false;
		}
	}
	else
	{
		//`log(" ChadAI - HandleAtCoverCollisionChange faled if( CoverAt.Link != None && Pawn != None)) - CoverAt.Link: " @ CoverAt.Link @ " Pawn: " @ Pawn );
	}
}

native function HandleLeftCoverCollisionChange( CoverInfo CoverLeaving );

//-----------------------------------------------------------------------
// Function:
// Description:	Teleports/snaps the pawn to the current cover
//-----------------------------------------------------------------------
// Not to C++
function SnapToCover( CoverInfo CoverToSnapTo, bool bCheckForValidAgainstEnemy )
{
	SnapPawnInToCoverSlot(CoverToSnapTo,bCheckForValidAgainstEnemy);	
}

//-----------------------------------------------------------------------
// Function:
// Description:	returns the current cover type
//-----------------------------------------------------------------------
native function CoverLink.ECoverType GetCurrentCoverType();

//-----------------------------------------------------------------------
// Function:
// Description:	returns the current action we are performing at cover
//-----------------------------------------------------------------------
native function CoverLink.ECoverAction GetCurrentCoverAction();

//-----------------------------------------------------------------------
// Function:
// Description:	Resets the current cover action to default.
//-----------------------------------------------------------------------
// Not to C++
function ResetCoverAction()
{
	//`log(" ChadAI - ResetCoverAction--------------------------------------------------------------------------------------------------------------------------");

	m_CoverFightData.m_CurrentCoverAction = CA_Default;
}

native function bool SetCoverAction( CoverInfo CoverToUse, bool bBlindFiring);

//-----------------------------------------------------------------------
// Function:
// Description:	Figures out the best location for checking visiblity from
//				the given cover node.
//				@param	chkNode - cover node to use as a base
//				@return vector indicating new viewpoint for visibility
//-----------------------------------------------------------------------
// To C++
final function vector GetCoverViewpoint(CoverInfo chkNode)
{
	local vector viewPt;
	
	if (TPCoverNode(chkNode.Link) != None)
	{
		viewPt = TPCoverNode(chkNode.Link).GetPeekViewPoint(chkNode.SlotIdx, self);
	}
	return viewPt;
}

//***********************************************************************
// COVER FUNCTIONS
//************************ - END SECTION - ******************************




//************************ - BEGIN SECTION - ****************************
// KISMET FUNCTIONS
//***********************************************************************


//-----------------------------------------------------------------------
// Function:	 OnAIWander
// Description:  Kismet action that tells us to move to a cover node
//-----------------------------------------------------------------------
// Not to C++
function OnAIWander(SeqAct_AIWander inAction)
{
	local array<Object> objVars;
	
	//`log(" ChadAI - OnAIWander:: called  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	//bMoved = false;
	//`AILOG(0, 'Move',"OnAIMoveToActor from Kismet Obj:"@inAction@"ObjName:"@inAction.ObjName@"ObjComment:"@inAction.ObjComment);

	// if routing we need to not clear latent actions on these moves
	inAction.GetObjectVars(objVars,"Node to Defend From");
		
	//`log(" ChadAI - Moving NPC: " @ Pawn.Name @ " to: " @ objVars[0].Name @ " Slot: " @ inAction.SlotToStartToDefendFrom @ "  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
		
	//m_MoveToAndDefendCoverGoalInfo.m_CoverToDefend.Link = TPCoverNode(objVars[0]);
	//m_MoveToAndDefendCoverGoalInfo.m_CoverToDefend.SlotIdx = inAction.SlotToStartToDefendFrom;

	//// abort any previous latent moves
	//if (!m_bDontClearMoveToTargetLatentAction)
	//{
	//	ClearLatentAction(class'SeqAct_AIMoveToActor',true,inAction);
	//}

	//// next check for a move to player
	//if (Actor(objVars[0]) != None)
	//{
	//	//`log(" ChadAI - Part2 - Setting state to MoveToAndDefendCoverGoal -s-s-s-s-s-s-s-s-s-s-s-s-s-s-s-ss-s--s-s");
	//	m_MoveToAndDefendCoverGoalInfo.m_TimeToDefendInSeconds = inAction.TimeToDefendInSeconds;
	//	m_MoveToAndDefendCoverGoalInfo.m_DurrationOfFiringBeforeHiding = inAction.DurationToFirePerCycle;
	//	m_MoveToAndDefendCoverGoalInfo.m_DurationOfHidingBeforeFiring = inAction.DurationToHidePerCycle;
	//	m_MoveToAndDefendCoverGoalInfo.m_DurationOfLookingForTargetBeforeEngageAttempt = inAction.DurationToLookForTargetBeforeEngageAttemptPerCycle;
	//			

	//	//Force the current state to end!
	//	GotoState('MoveToAndDefendCoverGoal');
	//}
	
	//`log(" ChadAI - OnAIUseFightingPosition:: call ENDED  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

}

// Not to C++
function OnAITurnToActor(SeqAct_AITurnToActor Action)
{
	local array<Object> ObjVars;
	local Actor DestActor;
	local Controller testController;
	local int Idx;

	// abort any previous latent moves
	ClearLatentAction(class'SeqAct_AITurnToActor',true,Action);
	// pick a destination
	Action.GetObjectVars(ObjVars,"Destination");

	for (Idx = 0; Idx < ObjVars.Length && DestActor == None; Idx++)
	{
		// use the first valid actor
		DestActor = Actor(ObjVars[Idx]);
	}

	if (DestActor != None)
	{
		testController = Controller(DestActor);
		if (testController != None)
		{
			Focus = testController.Pawn;
		}
		else
		{
			Focus = DestActor;
		}

		m_bKeepFacing = Action.m_bKeepFacingOverTime;
		PushState('ScriptedTurn');
	}
}

// Not to C++
function OnAIModifyMeleeData(SeqAct_AIModifyMeleeData Action)
{
	;
	//`log(" ChadAI - TPAIController::OnAIModifyMeleeData -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


	m_CQB_Data.m_AdditionalMeleeRangeOfAttack						= Action.m_AdditionalMeleeRangeOfAttack;
    m_CQB_Data.m_bAbleToMeleeAttacks								= Action.m_bAbleToMeleeAttacks;
    m_CQB_Data.m_bNotAllowedToEverNoMatterWhatDoMeleeAttack			= Action.m_bNotAllowedToEverNoMatterWhatDoMeleeAttack;
	m_CQB_Data.m_AdditionalMeleeAttackDamage						= Action.m_AdditionalMeleeAttackDamage;
	m_CQB_Data.m_AdditionalMeleeHitForce							= Action.m_AdditionalMeleeHitForce;
	m_CQB_Data.m_RangeToStartCQB_State								= Action.m_RangeToStartCQB_State;
	m_CQB_Data.m_SpeedToChargeScale									= Action.m_SpeedToChargeScale;
	m_CQB_Data.m_MeleeWaitToFailTime								= Action.m_MeleeWaitToFailTime;
	m_CQB_Data.m_OverridePercentOfMagToBlowThroughBeforeCharge		= Action.m_OverridePercentOfMagToBlowThroughBeforeCharge;
	m_CQB_Data.m_DelayBetweenStartOfMeleeStateAndTheAttackStart		= Action.m_DelayBetweenStartOfMeleeStateAndTheAttackStart;

	m_CoverFightData.m_MinDistanceToPlayerInCover					= Action.m_MinDistanceToPlayerInCover;
}

// Not to C++
function OnAIModifyGrenUseData(SeqAct_AIModifyGrenUseData Action)
{
	;
	//`log(" ChadAI - TPAIController::OnAIModifyGrenUseData -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


	m_GrenadeUseData.m_bCanUseGrenades									= Action.m_bCanUseGrenades;
	m_GrenadeUseData.m_bAlwaysThrowAgainstPlayerCamper									= Action.m_bAlwaysThrowAgainstPlayerCamper;
	m_GrenadeUseData.m_ChanceToUseGrenadeByOwnWill									= Action.m_ChanceToUseGrenadeByOwnWill;
	m_GrenadeUseData.m_HowOfftenInSecsToCheckChanceToUseGrenade									= Action.m_HowOfftenInSecsToCheckChanceToUseGrenade;
	m_GrenadeUseData.m_TimeToWaitAfterThrownGrenadeToTryAgain									= Action.m_TimeToWaitAfterThrownGrenadeToTryAgain;
	m_GrenadeUseData.m_MaxNumberOfGrenadesToThrow									= Action.m_MaxNumberOfGrenadesToThrow;
	m_GrenadeUseData.m_TossSpeed									= Action.m_TossSpeed;
	m_GrenadeUseData.m_BaseTossZ									= Action.m_BaseTossZ;
	m_GrenadeUseData.m_DesiredZPct									= Action.m_DesiredZPct;

}

//-----------------------------------------------------------------------
// Function:	OnAIMoveToActor
// Description: Kismet command to move an actor to a location
//				(mirroring Wargame functionality a little more)
//-----------------------------------------------------------------------
// Not to C++
function OnNonKynapseMoveToActor(SeqAct_NonKynapseMoveToActor inAction)
{
	local array<Object> objVars;
	local int idx;
	local bool bMoved;
	local Vector loc;

	Pawn.SetMovementType(inAction.MovementType);
	Pawn.SetMovementVariation(inAction.MovementVariation);

//    // Don't do anything if the target is immobile
//    if (Pawn.IsA('TPPawn')
//    {
//       if (TPPawn(Pawn).bImmobile)
//       {
//		    LastMoveToCall = inAction;
//            bMoved = false;
//            return;
//       }
//    }

	bMoved = false;
	//`AILOG(0, 'Move',"OnAIMoveToActor from Kismet Obj:"@inAction@"ObjName:"@inAction.ObjName@"ObjComment:"@inAction.ObjComment);

	// if routing we need to not clear latent actions on these moves
	inAction.GetObjectVars(objVars,"Destination");
	for (idx = 0; idx < objVars.Length && !bMoved; idx++)
	{
		if (Route(objVars[idx]) != None)
		{
			m_bDontClearMoveToTargetLatentAction=true;
		}
	}

	// abort any previous latent moves
	if (!m_bDontClearMoveToTargetLatentAction)
		ClearLatentAction(class'SeqAct_NonKynapseMoveToActor',true,inAction);

	// clear whatever we may have been doing
	//PopState(true);
	ResetStates();

	// find the destination
//	inAction.GetObjectVars(objVars,"Destination");
	for (idx = 0; idx < objVars.Length && !bMoved; idx++)
	{
//TP OUT ROUTES
		if( false )
//		if (Route(objVars[idx]) != None)
		{
//			//`AILOG(0, 'Move',"OnAIMoveToActor: Moving along route:"@objVars[idx]);
//			SetRouteGoal(Route(objVars[idx]),inAction.bInterruptable);
//			bMoved = true;
		}
		else
		// next check for a move to player
		if (Controller(objVars[idx]) != None &&
			Controller(objVars[idx]).Pawn != None)
		{
			//Force the current state to end!
			//GotoState('KismetMoveToActor');

			;
			//`log(" ChadAI - OnAIMoveToActor:SetMoveGoal moving to controlled pawn");
			SetNonKynapseMoveGoal(Controller(objVars[idx]).Pawn, 		//Actor inGoalActor
									loc,								//vector loc,
									emgtToActor,						//EMoveGoalType moveType,
									inAction.bInterruptable,			//optional bool inbInterruptable,	/** Can this move be interrupted by enemy detection? */
									inAction.bInterruptAndContinue,		
									inAction.maxBlockedPathAttempts,	
									true,								//optional bool bKismetCommand		/** This move to goal was executed from Kismet */
									inAction.m_bAllowedToWander,
									inAction.m_bAllowWaitingForPathToClear,
									inAction.m_TimeToWaitForPathToClear,
									inAction.m_bAllowCheckForGoalBlocked,
									inAction.m_UpdateTimeToCheckForPawnBlockingGoal,
									inAction.m_DistenceAwayToWaitIfGOalBlocked,
									inAction.m_TimeToWanderOrStandBetweenChecksForPathToClear
									);

			bMoved = true;
		}
		else if (Actor(objVars[idx]) != None)
		{			
			//Force the current state to end!
			//GotoState('KismetMoveToActor');

			//`AILOG(0, 'Move', "OnAIMoveToActor: moving to actor");
			//`log(" ChadAI - OnAIMoveToActor:SetMoveGoal moving to actor");
			SetNonKynapseMoveGoal(Actor(objVars[idx]), 		//Actor inGoalActor
						loc,								//vector loc,
						emgtToActor,						//EMoveGoalType moveType,
						inAction.bInterruptable,			//optional bool inbInterruptable,	/** Can this move be interrupted by enemy detection? */
						inAction.bInterruptAndContinue,		
						inAction.maxBlockedPathAttempts,	
						true,								//optional bool bKismetCommand		/** This move to goal was executed from Kismet */
						inAction.m_bAllowedToWander,
						inAction.m_bAllowWaitingForPathToClear,
						inAction.m_TimeToWaitForPathToClear,
						inAction.m_bAllowCheckForGoalBlocked,
						inAction.m_UpdateTimeToCheckForPawnBlockingGoal,
						inAction.m_DistenceAwayToWaitIfGOalBlocked,
						inAction.m_TimeToWanderOrStandBetweenChecksForPathToClear
						);


			bMoved = true;
		}
	}
}

//-----------------------------------------------------------------------
// Function:	OnAIMoveToActor
// Description: Kismet command to move an actor to a location
//				(mirroring Wargame functionality a little more)
//-----------------------------------------------------------------------
// Not to C++
function OnAIMoveToActor(SeqAct_AIMoveToActor inAction)
{
	local array<Object> objVars;
	local int idx;
	local bool bMoved;
	local Vector loc;

	Pawn.SetMovementType(inAction.MovementType);
	Pawn.SetMovementVariation(inAction.MovementVariation);

//    // Don't do anything if the target is immobile
//    if (Pawn.IsA('TPPawn')
//    {
//       if (TPPawn(Pawn).bImmobile)
//       {
//		    LastMoveToCall = inAction;
//            bMoved = false;
//            return;
//       }
//    }

	bMoved = false;
	//`AILOG(0, 'Move',"OnAIMoveToActor from Kismet Obj:"@inAction@"ObjName:"@inAction.ObjName@"ObjComment:"@inAction.ObjComment);

	// if routing we need to not clear latent actions on these moves
	inAction.GetObjectVars(objVars,"Destination");
	for (idx = 0; idx < objVars.Length && !bMoved; idx++)
	{
		if (Route(objVars[idx]) != None)
		{
			m_bDontClearMoveToTargetLatentAction=true;
		}
	}

	// abort any previous latent moves
	if (!m_bDontClearMoveToTargetLatentAction)
		ClearLatentAction(class'SeqAct_AIMoveToActor',true,inAction);

	// clear whatever we may have been doing
	//PopState(true);
	ResetStates();

	// find the destination
//	inAction.GetObjectVars(objVars,"Destination");
	for (idx = 0; idx < objVars.Length && !bMoved; idx++)
	{
//TP OUT ROUTES
		if( false )
//		if (Route(objVars[idx]) != None)
		{
//			//`AILOG(0, 'Move',"OnAIMoveToActor: Moving along route:"@objVars[idx]);
//			SetRouteGoal(Route(objVars[idx]),inAction.bInterruptable);
//			bMoved = true;
		}
		else
		// next check for a move to player
		if (Controller(objVars[idx]) != None &&
			Controller(objVars[idx]).Pawn != None)
		{
			//Force the current state to end!
			//GotoState('KismetMoveToActor');

			;
			//`log(" ChadAI - OnAIMoveToActor:SetMoveGoal moving to controlled pawn");
			SetMoveGoal(Controller(objVars[idx]).Pawn, 		//Actor inGoalActor
						loc,								//vector loc,
						emgtToActor,						//EMoveGoalType moveType,
						inAction.bInterruptable,			//optional bool inbInterruptable,	/** Can this move be interrupted by enemy detection? */
						inAction.bInterruptAndContinue,		
						inAction.maxBlockedPathAttempts,	
						true,								//optional bool bKismetCommand		/** This move to goal was executed from Kismet */
						inAction.m_bAllowedToWander,
						inAction.m_bAllowWaitingForPathToClear,
						inAction.m_TimeToWaitForPathToClear,
						inAction.m_bAllowCheckForGoalBlocked,
						inAction.m_UpdateTimeToCheckForPawnBlockingGoal,
						inAction.m_DistenceAwayToWaitIfGOalBlocked,
						inAction.m_TimeToWanderOrStandBetweenChecksForPathToClear
						);

			bMoved = true;
		}
		else if (Actor(objVars[idx]) != None)
		{			
			//Force the current state to end!
			//GotoState('KismetMoveToActor');

			//`AILOG(0, 'Move', "OnAIMoveToActor: moving to actor");
			//`log(" ChadAI - OnAIMoveToActor:SetMoveGoal moving to actor");
			SetMoveGoal(Actor(objVars[idx]), 		//Actor inGoalActor
						loc,								//vector loc,
						emgtToActor,						//EMoveGoalType moveType,
						inAction.bInterruptable,			//optional bool inbInterruptable,	/** Can this move be interrupted by enemy detection? */
						inAction.bInterruptAndContinue,		
						inAction.maxBlockedPathAttempts,	
						true,								//optional bool bKismetCommand		/** This move to goal was executed from Kismet */
						inAction.m_bAllowedToWander,
						inAction.m_bAllowWaitingForPathToClear,
						inAction.m_TimeToWaitForPathToClear,
						inAction.m_bAllowCheckForGoalBlocked,
						inAction.m_UpdateTimeToCheckForPawnBlockingGoal,
						inAction.m_DistenceAwayToWaitIfGOalBlocked,
						inAction.m_TimeToWanderOrStandBetweenChecksForPathToClear
						);


			bMoved = true;
		}
	}
}


//-----------------------------------------------------------------------
// Function:
// Description:	KISMET action to toggle AI
//-----------------------------------------------------------------------
// Not to C++
simulated function OnToggleAI(SeqAct_ToggleAI Action)
{
	local bool bDisable;

	if( m_bGrappled )
	{
		;
		return;
	}



	if (Action.InputLinks[0].bHasImpulse)
	{
		DoToggleAI(true);
	}
	else
	if (Action.InputLinks[1].bHasImpulse)
	{
		DoToggleAI(false);
	}
	else
	{
		bDisable = !m_bAIDisabled;

		DoToggleAI(!bDisable);
	}
}


//-----------------------------------------------------------------------
// Function:
// Description:	does the work for toggling AI
//-----------------------------------------------------------------------
// Not to C++
simulated function DoToggleAI(bool bEnable)
{
	if (bEnable && m_bAIDisabled)
	{
		EnableAI(FALSE);
	}
	else if (!bEnable && !m_bAIDisabled)
	{
		DisableAI();
	}
}

// Not to C++
simulated function OnAssignSquad(SeqAct_AssignSquad Action)
{
	AssignSquadFromSelector( Action.SquadType );
}
// Not to C++
event AssignSquadFromSelector( TPSquadSelector selector )
{
	local TPTeamInfo myTeam;
	local Name squadName;

	//run through the gauntlet of checks...
	if (selector == None)
	{
		;
		return;
	}

	myTeam = GetTeam();
	if (myTeam == None)
	{
		;
		return;
	}

	if (!selector.IsAssociatedWithTeam(myTeam))
	{
		//We are now allowing assignment to a new team squad
		//`LogError('KismetError',"AssignSquad cannot assign squad b/c"@GetPawnName(true)@" team:"@myTeam.GetHumanReadableName()@"is not associated with the selected squad type:"@selector);
		//return;
		
		;
		SetTeam( selector.TeamAssignment );
	}

	//Wheew, finally we can do our thing!...
	squadName = myTeam.GetPreDefinedSquadName(selector.GetSelectedSquadIdx());
	
	myTeam.AddToSquad(self, squadName);

}

//***********************************************************************
// KISMET FUNCTIONS
//************************ - END SECTION - ******************************


//************************ - BEGIN SECTION - ****************************
// MISC functions
//***********************************************************************
// Not to C++
function PickUpOfGrenadeThrowBack()
{
	;
}
// Not to C++
function ReleaseOfGrenadeThrowBack()
{
	;
}
// Not to C++
function EndThrowBackGrenade()
{
	;
}
// Not to C++
function DoneWithSupriseAnimation()
{
	;
}
// Not to C++
function TimeToSpawnGrenadeForThrow()
{
	;
}

native final function UpdateHeadtracking();

// Not to C++
function OnSetUniform(SeqAct_SetUniform action)
{
	TPPawn(Pawn).SetUniform( action.Uniform );
}

// Not to C++
function OnAIForceLookAt(SeqAct_AIForceLookAt action)
{
	local array<Object> ObjVars;
	local SkelControlLookAt htrack;
	action.GetObjectVars(ObjVars,"Thing To Target");

	if (ObjVars.Length > 0)
	{
		if (Controller(ObjVars[0]) != None)
		{
			ForcedLookAtTarget = Controller(ObjVars[0]).Pawn;
		}
		else
		{
			ForcedLookAtTarget = Actor(ObjVars[0]);
		}
	}
	else
	{
		ForcedLookAtTarget = None;
	}

	htrack = SkelControlLookAt(Pawn.Mesh.FindSkelControl('HeadTrack'));
	if (action.bEnabledByDefault)
		htrack.SetSkelControlStrength(1.0f, 0.5f);
	else
		htrack.SetSkelControlStrength(0.0f, 0.5f);
}

//-----------------------------------------------------------------------
// Function:	 GetTeam
// Description:	 Returns our currently assigned SPTeamInfo
//-----------------------------------------------------------------------
// Not to C++
final function TPTeamInfo GetTeam()
{
	return TPTeamInfo(PlayerReplicationInfo.Team);
}


//override this if you want an AI to pause after he finds a path to the enemy
// Not to C++
function float GetMoveDelayTime()
{
	return 0.0f;
}


//***********************************************************************
// MISC
//************************ - END SECTION - ******************************




//************************ - BEGIN SECTION - ****************************
// PUSHABLE STATES - States that are used to stack on top of current state
//***********************************************************************



state TakeHit
{
// Not to C++
	event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
	{
		//Hit anim finished, pop the state
		PopState();
	}

// Not to C++
	function EndState(Name nextStateName)
	{
		;					

		ClearState();
	}
// Not to C++
	event PoppedState()
	{
		;					

		ClearState();
	}
// Not to C++
    event PausedState()
	{
		;					

		ClearState();
	}
// Not to C++
	function ClearState()
	{
		;

		m_bInBasicTakeHitState = false;

		//Clean up
		ClearTimer('ClearHitTimeOut');
		ClearTimer('HitAnimTimeOut');
		
		m_bHitTimeOut = false;
	}


	//callback called by timer
	// Not to C++
	function ClearHitTimeOut()
	{
		m_bHitTimeOut = false;
	}

	//callback called by timer - this is a safety timeout, but OnAnimEnd should really be responsible for popping this state
	// Not to C++
	function HitAnimTimeOut()
	{
		PopState();
	}

// Not to C++
	function TakeHitStart(bool bRestart)
	{
		m_bInBasicTakeHitState = true;
		ClearMove();
		KynapseClear();

		//Set focal point to preserve our rotation
		FocalPoint = Pawn.Location + 512*vector(Pawn.Rotation);
	
	
		m_bHitTimeOut = true;
		m_bHitRestart = bRestart;
		
		SetTimer(0.2f,false,'ClearHitTimeOut');
		
		SetTimer(1.0f,false,'HitAnimTimeOut');
		
	}
	


Restart:
	if (m_bHitTimeOut == false)
	{
		TakeHitStart(true);
	}
	Goto('End');

Begin:
	m_SubStateDebugInfoTag="Begin";

	TakeHitStart(false);

End:

}

//-----------------------------------------------------------------------
// State:	StepAside
// Description: Generic step aside state for moving out of the way of
//				friendlies.
//-----------------------------------------------------------------------
state StepAside
{
	// Not to C++
	event bool NotifyBump(Actor Other, vector HitNormal)
	{
		if (Other != m_stepAsideGoal)
		{
			//SPAI TODO: look for another step aside location?
		}
		return false;
	}

	// Not to C++
	function bool StepAsideFor(Pawn chkPawn)
	{
		return true;
	}

	// Not to C++
	// can the pawn move in a straight line from Location to chkLoc
	function bool IsValidMoveLocation(vector chkLoc)
	{
		if (Pawn != None)
		{
			return KynapseCanGoStraight(chkLoc);
		}
		else
		{
			return false;
		}
	}

	// Not to C++
	function PoppedState()
	{
		m_stepAsideGoal = None;
	}

	//
	// Returns a location that best moves out of the way of StepAsideGoal.
	//
	// To C++
	function bool GetStepAsideLocation()
	{
		local vector Left;
		local vector Right;
		local vector Back;
		local vector BackLeft;
		local vector BackRight;
		local vector UpDir;
		local vector GoalFrontDir;
		local vector GoalRightDir;
		local vector DeltaFrontDir;
		local vector DeltaRightDir;
		local array<vector> Offsets;
		local int idx;

		if (Pawn != None && m_stepAsideGoal != None)
		{
			UpDir = vect(0.0, 0.0, 1.0);

			if (VSizeSq(m_stepAsideGoal.Velocity) > 0.0)
			{
				GoalFrontDir = Normal(m_stepAsideGoal.Velocity);
			}
			else
			{
				GoalFrontDir = Vector(m_stepAsideGoal.Rotation);
			}
			GoalRightDir = GoalFrontDir cross UpDir;

			DeltaFrontDir = Normal(m_stepAsideGoal.Location - Pawn.Location);
			DeltaRightDir = DeltaFrontDir cross UpDir;

			if (DeltaFrontDir dot GoalRightDir > 0.0)
			{	// step to the right
				Right = DeltaRightDir;
				Back = -DeltaFrontDir;
				BackRight = Right + Back;
				Offsets[Offsets.Length] = Right * m_maxStepAsideDist; // right
				Offsets[Offsets.Length] = BackRight * m_maxStepAsideDist; // back right
				Offsets[Offsets.Length] = Back * m_maxStepAsideDist; // back
				Offsets[Offsets.Length] = Right * m_maxStepAsideDist*0.5; // half right
				Offsets[Offsets.Length] = BackRight * m_maxStepAsideDist*0.5; // half back right
				Offsets[Offsets.Length] = Back * m_maxStepAsideDist*0.5; // half back
			}
			else
			{	// step to the left
				Left = -DeltaRightDir;
				Back = -DeltaFrontDir;
				BackLeft = Left + Back;
				Offsets[Offsets.Length] = Left * m_maxStepAsideDist; // left
				Offsets[Offsets.Length] = BackLeft * m_maxStepAsideDist; // back left
				Offsets[Offsets.Length] = Back * m_maxStepAsideDist; // back
				Offsets[Offsets.Length] = Left * m_maxStepAsideDist*0.5; // half left
				Offsets[Offsets.Length] = BackLeft * m_maxStepAsideDist*0.5; // half back left
				Offsets[Offsets.Length] = Back * m_maxStepAsideDist*0.5; // half back
			}
			for (idx = 0; idx < Offsets.Length; idx++)
			{
				if (IsValidMoveLocation(Pawn.Location + Offsets[idx]))
				{
					m_stepAsideLocation = Pawn.Location + Offsets[idx];
					;
					return true;
				}
			}
		}

		;
		return false;
	}

Begin:
	m_SubStateDebugInfoTag="Begin";

	HandleLeftCoverCollisionChange( m_CoverFightData.m_CurrentlyCoverToUseAsFightPos );

	if (Pawn != None && m_stepAsideGoal != None && GetStepAsideLocation())
	{
		//Pawn.SetMovementPhysics();
		//MoveTo(m_stepAsideLocation, Focus);
		MoveTo(m_stepAsideLocation, None);
	}
	else
	{
		;
		Sleep(1.f);
	}

	PopState();
}

//-----------------------------------------------------------------------
// State:		 Scripted Turn
// Description:  state to handle turning towards our Focus
//-----------------------------------------------------------------------
state ScriptedTurn
{
	// Not to C++
	function PoppedState()
	{
		ClearLatentAction(class'SeqAct_AITurnToActor', !m_bTurnComplete);

		if (!m_bKeepFacing)
		{
			PreserveRotation();
			Focus = None;
		}
	}

	// Not to C++
	function PushedState()
	{
		m_bTurnComplete = false;

		if (Pawn != None)
		{
			Pawn.SetPhysics(PHYS_Walking);
		}
	}

Begin:

	m_SubStateDebugInfoTag="Begin";

	if (Focus != None)
	{
		FinishRotation();
		;
		m_bTurnComplete = true;
	}
	else
	{
		;
	}

	PopState();
}


//-----------------------------------------------------------------------
// State:	NonKynapseMoveToActorGoal
// Description: sets where we want to move to and moves there
//-----------------------------------------------------------------------
state NonKynapseMoveToActorGoal
{
	ignores NotifyBump;

	// Not to C++
	function BeginState(Name PreviousStateName)
	{
		;

		m_HighLevelAiGoal = HighLevelAiGoal_NonKynapseMoveToActorGoal;

		m_bMoveAborted = false;
	}
// Not to C++
	function EndState(Name NextStateName)
	{

		;

		m_HighLevelAiGoal = HighLevelAiGoal_NONE;

		m_moveGoalInfo.bTookBump = false;
		m_moveGoalInfo.bTookHit  = false;

		m_moveGoalInfo.m_TimeStartedToWaitForPathToClear = -1.0;

	}
// Not to C++
	event PushedState()
	{
		;

		m_HighLevelAiGoal = HighLevelAiGoal_NonKynapseMoveToActorGoal;
	}
// Not to C++
    event PoppedState()
	{
		;

		m_HighLevelAiGoal = HighLevelAiGoal_NONE;
		
		m_moveGoalInfo.bTookBump = false;
		m_moveGoalInfo.bTookHit  = false;

		m_moveGoalInfo.m_TimeStartedToWaitForPathToClear = -1.0;

	}
// Not to C++
	event ContinuedState()
	{
		;

		if (Pawn != none)
		{
            //Pawn.SetMovementPhysics();
        }
	}
// Not to C++
    event PausedState()
	{
		;

		//CAVEAT: It is up to the pushing state to determine
		//whether to do a ClearMove().
	}

// Not to C++
	event Tick( float DeltaTime )
	{
		//`log(" ChadAI - TPAIController::NonKynapseMoveToActorGoal::Tick -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		//`log(" ChadAI - TPAIController::NonKynapseMoveToActorGoal::Tick:: Pawn.Location " @ Pawn.Location @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		
		if( m_moveGoalInfo.bInterruptable && DetermineIfShouldStartCQB_Tick( WorldInfo.TimeSeconds ) )
		{
			StopThisBot();
			PushState('CloseQuartersBattleAttack');
		}

		/*if( Enemy != None )
		{
			Focus = Enemy;
		}
		else
		{*/
		Focus = m_moveGoalInfo.goalActor;

		Target = m_moveGoalInfo.goalActor;

		UpdateHeadtracking();
		//}
		Super.Tick(DeltaTime);
	
	}

// Not to C++
	function OnSeeEnemy(int playerIdx, bool bNewEnemy)
	{
		//`log(" ChadAI - " @ self @ "NonKynapseMoveToActorGoal::OnSeeEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		if( m_moveGoalInfo.bInterruptable ) //Set from Kismet
		{
			//`log(" ChadAI - " @ self @ "NonKynapseMoveToActorGoal::OnSeeEnemy move is Interruptable so CheckForEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

			// acquire as a new enemy and evaluate the situation
			if (CheckForEnemy(false) && ShouldIAttackEnemy() )
			{
				;
				//`log(" ChadAI - " @ self @ "NonKynapseMoveToActorGoal::OnSeeEnemy I am aborting my scripted move because I found an enemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

				AbortMove(false);
				ClearMove();
			
				;
				EvaluateSituation();
			}
		}
		else if( m_moveGoalInfo.bInterruptAndContinue )
		{
			if (CheckForEnemy(false) && ShouldIAttackEnemy() )
			{
				;
				//`log(" ChadAI - " @ self @ "NonKynapseMoveToActorGoal::OnSeeEnemy I am pauseing my scripted move because I found an enemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

				m_MultiTierEngagementInfo.m_bSawEnemyWhilePursuing = true;

				//KynapseClear();
			}
		}
		else
		{
			CheckForEnemy(false);
		}
	}
	// Not to C++
	event OnHearEnemy(int playerIdx)
	{
		//`log(" ChadAI - SENSING - " @ self @ "NonKynapseMoveToActorGoal::OnHearEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		if( m_moveGoalInfo.bInterruptable ) //Set from Kismet
		{
			//`log(" ChadAI - SENSING - " @ self @ "MoveToActorGoal::OnHearEnemy move is Interruptable so CheckForEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

			// acquire as a new enemy and evaluate the situation
			if (CheckForEnemy(false) && ShouldIAttackEnemy() )
			{
				;
				//`log(" ChadAI - SENSING - " @ self @ "MoveToActorGoal::OnHearEnemy I am aborting my scripted move because I found an enemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

				AbortMove(false);
				ClearMove();

				;
				EvaluateSituation();
			}
		}
		else if( m_moveGoalInfo.bInterruptAndContinue )
		{
			if (CheckForEnemy(false) && ShouldIAttackEnemy() )
			{
				;
				//`log(" ChadAI - " @ self @ "MoveToActorGoal::OnHearEnemy I am pauseing my scripted move because I found an enemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

				m_MultiTierEngagementInfo.m_bSawEnemyWhilePursuing = true;

				//KynapseClear();
			}
		}
		else
		{
			CheckForEnemy(false);
		}
	}

Begin:

	m_SubStateDebugInfoTag="Begin";

	if (Pawn!=none)
	{
		//Pawn.SetMovementPhysics();
	}

	m_HighLevelAiGoal = HighLevelAiGoal_NonKynapseMoveToActorGoal;

	//`log(" ChadAI - TPAIController NonKynapseMoveToActorGoal State Begin --------------------------------------------------------------------------------------------");
Restart:
	//`log(" ChadAI - TPAIController NonKynapseMoveToActorGoal State Restart --------------------------------------------------------------------------------------------");

	m_bMoveAborted = false;
	m_bDelayingMove = false;
	m_moveGoalInfo.m_TimeStartedToWaitForPathToClear = -1.0;

MoveLoop:

	m_moveGoalInfo.bTookBump = false;
	m_moveGoalInfo.bTookHit  = false;

	;

	if (m_moveGoalInfo.moveAttempts++ > m_moveGoalInfo.maxBlockedPathAttempts && m_moveGoalInfo.maxBlockedPathAttempts != 0)
	{
//AbortMove:

		//`log(" ChadAI - Pawn: " @ Pawn @" TPAIController MoveToActorGoal State AbortMove --------------------------------------------------------------------------------------------");
		;

		;

		Goto('AbortMove');
				
	}
	else if ( (m_moveGoalInfo.moveAttempts == (m_moveGoalInfo.maxBlockedPathAttempts - 2 ) ) && (m_moveGoalInfo.maxBlockedPathAttempts > 2) && m_moveGoalInfo.m_bAllowWaitingForPathToClear)
	{
		//`log(" ChadAI - Pawnl " @Pawn @" TPAIController MoveToActorGoal State last chace before AbortMove to wonder a bit and then see if path clears up time: " @ WorldInfo.TimeSeconds @ " --------------------------------------------------------------------------------------------");
		;
		
		// if just started to wait
		if( m_moveGoalInfo.m_TimeStartedToWaitForPathToClear < 0.0f )
		{
			m_moveGoalInfo.m_TimeStartedToWaitForPathToClear = WorldInfo.TimeSeconds;
			//`log(" ChadAI - Pawnl " @Pawn @" TPAIController MoveToActorGoal Start Waiting For Path to Clear: " @ WorldInfo.TimeSeconds @ " --------------------------------------------------------------------------------------------");

		}

		if( m_moveGoalInfo.m_TimeToWaitForPathToClear < 0.0f || ( WorldInfo.TimeSeconds - m_moveGoalInfo.m_TimeStartedToWaitForPathToClear <  m_moveGoalInfo.m_TimeToWaitForPathToClear ) )
		{
			if( m_moveGoalInfo.bInterruptAndContinue || m_moveGoalInfo.bInterruptable )
			{
				m_WanderInfo.m_bAllowAttackWhileWaitingForPathToClear = true;
			}
			else
			{
				m_WanderInfo.m_bAllowAttackWhileWaitingForPathToClear = false;
			}

			if( m_moveGoalInfo.m_bAllowedToWander && m_WanderInfo.m_bAllowIdleWander )
			{
				PushState('WanderAround');
			}
			else
			{
				PushState('StandWaitingForPathToClear');
			}

			;

			if( m_MultiTierEngagementInfo.m_bSawEnemyWhilePursuing )
			{
				//`log(" ChadAI - " @ Pawn @ "NonKynapseMoveToActorGoal:: Back from Wander and I saw someone while wandering -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

				if( m_moveGoalInfo.bInterruptable ) //Set from Kismet
				{
					//`log(" ChadAI - " @ Pawn @ "NonKynapseMoveToActorGoal:: Back from Wander and I saw someone while wandering and bInterruptable sp Eval Sit-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
					;
					Goto('AbortMove');
				}
				else if( m_moveGoalInfo.bInterruptAndContinue )
				{
					//`log(" ChadAI - " @ Pawn @ "NonKynapseMoveToActorGoal:: Back from Wander and I saw someone while wandering and bInterruptAndContinue so attack -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

					m_moveGoalInfo.m_TimeStartedToWaitForPathToClear = -1.0;
					PushState('Open_Field_Attack');

					m_moveGoalInfo.moveAttempts = 0;
				}
				else
				{
					//`log(" ChadAI - " @ Pawn @ "NonKynapseMoveToActorGoal:: Back from Wander and I saw someone while wandering but not interuptible so let check path again -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
					// Danger could cause endless loop if wander see the enemy again and pops putting us right back here
					m_moveGoalInfo.moveAttempts = m_moveGoalInfo.moveAttempts - 2;
				}
			}
			else
			{
				//`log(" ChadAI - " @ Pawn @ "NonKynapseMoveToActorGoal:: Back from Wander and I did not see anyone while wandering check path one more time-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
			}

		}
		else
		{
			//`log(" ChadAI - " @ Pawn @ "NonKynapseMoveToActorGoal:: No More Time Wander or wait so check path one more time-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
		}

		//AbortMove(true);
	}
	else if (HasValidMoveGoal())
	{
		m_MultiTierEngagementInfo.m_bSawEnemyWhilePursuing = false;
		if (m_moveGoalInfo.goalActor.IsA('KynapseGamePawn'))
		{
			//`MOVELOG(0,"gotoward" @ m_moveGoalInfo.goalActor);
			;

			//`log(" ChadAI - Pawn: " @ Pawn @" TPAIController MoveToActorGoal KynapseGoTowardFindPath to: " @ m_moveGoalInfo.goalActor @ " --------------------------------------------------------------------------------------------");
			MoveTo(m_moveGoalInfo.goalController.Pawn.Location);
			StopThisBot();

			if( Pawn != None )
			{
				if( VSizeSq(Pawn.Location - m_moveGoalInfo.goalController.Pawn.Location) <= 40000 )
				{
					Goto('FinishedMoveToGoal');
				}
				else
				{
					;
				}
			}
		}
		else
		{
			;
			//`log(" ChadAI - Pawn: " @ Pawn @"  TPAIController MoveToActorGoal KynapseGoToFindPath to: " @ m_moveGoalInfo.goalActor.Location @ " --------------------------------------------------------------------------------------------");
			MoveTo(m_moveGoalInfo.goalActor.Location);
			StopThisBot();

			if( Pawn != None )
			{
				if( VSizeSq(Pawn.Location - m_moveGoalInfo.goalActor.Location) <= 40000 )
				{
					Goto('FinishedMoveToGoal');
				}
				else
				{
					;
				}
			}
		}

		// if close to target end movement if not try again


		Goto('FinishedMoveToGoal');
	}

	Goto('MoveLoop');

FinishedMoveToGoal:

	;

	if (TPPawn(Pawn) != None)
	{
		TPPawn(Pawn).FinishedMove(m_bMoveAborted);
	}

//	`log(self @ "FinishedMoveToGoal");

	m_moveGoalInfo.m_TimeStartedToWaitForPathToClear = -1.0;

	ClearLatentAction(class'SeqAct_NonKynapseMoveToActor',false);

	Sleep(0.0);

	;

	//`log(" ChadAI - TPAIController NonKynapseMoveToActorGoal after ClearLatentAction No other task is kismet so let eval sit --------------------------------------------------------------------------------------------");

	EvaluateSituation();
	//PopState();

AbortMove:

	//`log(self @ "AbortMove:");
		
	m_bMoveAborted = true;

	ClearLatentAction(class'SeqAct_NonKynapseMoveToActor',true);

	Sleep(0.0);

	;

	//`log(" ChadAI - TPAIController NonKynapseMoveToActorGoal after ClearLatentAction No other task is kismet so let eval sit --------------------------------------------------------------------------------------------");

	EvaluateSituation();
}


//-----------------------------------------------------------------------
// State:	MoveToActorGoal
// Description: sets where we want to move to and moves there
//-----------------------------------------------------------------------
state MoveToActorGoal
{
	ignores NotifyBump;
// Not to C++
	function BeginState(Name PreviousStateName)
	{
		;

		m_HighLevelAiGoal = HighLevelAiGoal_MoveToActorGoal;

		m_bMoveAborted = false;
		SetTimers();
	}
// Not to C++
	function EndState(Name NextStateName)
	{

		;

		m_HighLevelAiGoal = HighLevelAiGoal_NONE;

		KynapseClear();
		
		ClearMove();
		ClearTimers();

		m_moveGoalInfo.bTookBump = false;
		m_moveGoalInfo.bTookHit  = false;

		m_moveGoalInfo.m_TimeStartedToWaitForPathToClear = -1.0;

		if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
		{
			KillTheTraveller();
			PopState();
		}

	}
// Not to C++
	event PushedState()
	{
		;

		m_HighLevelAiGoal = HighLevelAiGoal_MoveToActorGoal;

		SetTimers();
	}
// Not to C++
    event PoppedState()
	{
		;

		m_HighLevelAiGoal = HighLevelAiGoal_NONE;
		
		KynapseClear();
		
		ClearMove();
		ClearTimers();

		m_moveGoalInfo.bTookBump = false;
		m_moveGoalInfo.bTookHit  = false;

		m_moveGoalInfo.m_TimeStartedToWaitForPathToClear = -1.0;

		if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
		{
			KillTheTraveller();
			PopState();
		}

	}
// Not to C++
	event ContinuedState()
	{
		;

		SetTimers();
		if (Pawn != none)
		{
            //Pawn.SetMovementPhysics();
        }
		//GotoState(GetStateName(),'Restart',false,true);
	}
// Not to C++
    event PausedState()
	{
		;

		ClearTimers();

		//CAVEAT: It is up to the pushing state to determine
		//whether to do a ClearMove().
	}
// Not to C++
	function SetTimers()
	{
		SetTimer(RandRange(0.1f, 0.3f),true,'MoveToGoalTimerUpdate');
		SetTimer(RandRange(0.1f, 0.3f),true,'MoveToGoalObstacleTimerUpdate');
	}
// Not to C++
	function ClearTimers()
	{
		ClearTimer('MoveToGoalTimerUpdate');
		ClearTimer('MoveToGoalObstacleTimerUpdate');
	}
// Not to C++
	function bool IsMoving()
	{
		return true;
	}
// Not to C++
	event Tick( float DeltaTime )
	{
		//`log(" ChadAI - TPAIController::MoveToActorGoal::Tick -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		//`log(" ChadAI - TPAIController::MoveToActorGoal::Tick:: Pawn.Location " @ Pawn.Location @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		
		if( m_moveGoalInfo.bInterruptable && DetermineIfShouldStartCQB_Tick( WorldInfo.TimeSeconds ) )
		{
			PushState('CloseQuartersBattleAttack');
		}

		/*if( Enemy != None )
		{
			Focus = Enemy;
		}
		else
		{*/
		Focus = m_moveGoalInfo.goalActor;

		Target = m_moveGoalInfo.goalActor;

		UpdateHeadtracking();
		//}
		Super.Tick(DeltaTime);
	
	}

// Not to C++
	function OnSeeEnemy(int playerIdx, bool bNewEnemy)
	{
		//`log(" ChadAI - " @ self @ "MoveToActorGoal::OnSeeEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		if( m_moveGoalInfo.bInterruptable ) //Set from Kismet
		{
			//`log(" ChadAI - " @ self @ "MoveToActorGoal::OnSeeEnemy move is Interruptable so CheckForEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

			// acquire as a new enemy and evaluate the situation
			if (CheckForEnemy(false) && ShouldIAttackEnemy() )
			{
				;
				//`log(" ChadAI - " @ self @ "MoveToActorGoal::OnSeeEnemy I am aborting my scripted move because I found an enemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

				AbortMove(false);
				ClearMove();
			
				;
				EvaluateSituation();
			}
		}
		else if( m_moveGoalInfo.bInterruptAndContinue )
		{
			if (CheckForEnemy(false) && ShouldIAttackEnemy() )
			{
				;
				//`log(" ChadAI - " @ self @ "MoveToActorGoal::OnSeeEnemy I am pauseing my scripted move because I found an enemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

				m_MultiTierEngagementInfo.m_bSawEnemyWhilePursuing = true;

				KynapseClear();
			}
		}
		else
		{
			CheckForEnemy(false);
		}
	}
	// Not to C++
	event OnHearEnemy(int playerIdx)
	{
		//`log(" ChadAI - SENSING - " @ self @ "MoveToActorGoal::OnHearEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		if( m_moveGoalInfo.bInterruptable ) //Set from Kismet
		{
			//`log(" ChadAI - SENSING - " @ self @ "MoveToActorGoal::OnHearEnemy move is Interruptable so CheckForEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

			// acquire as a new enemy and evaluate the situation
			if (CheckForEnemy(false) && ShouldIAttackEnemy() )
			{
				;
				//`log(" ChadAI - SENSING - " @ self @ "MoveToActorGoal::OnHearEnemy I am aborting my scripted move because I found an enemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

				AbortMove(false);
				ClearMove();

				;
				EvaluateSituation();
			}
		}
		else if( m_moveGoalInfo.bInterruptAndContinue )
		{
			if (CheckForEnemy(false) && ShouldIAttackEnemy() )
			{
				;
				//`log(" ChadAI - " @ self @ "MoveToActorGoal::OnHearEnemy I am pauseing my scripted move because I found an enemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

				m_MultiTierEngagementInfo.m_bSawEnemyWhilePursuing = true;

				KynapseClear();
			}
		}
		else
		{
			CheckForEnemy(false);
		}
	}

// Not to C++
	function OnAIMoveToActor(SeqAct_AIMoveToActor inAction)
	{
		;
		m_bDontClearMoveToTargetLatentAction = true;
		super.OnAIMoveToActor(inAction);
	}
// Not to C++
	function bool IsAtMoveGoal()
	{
		;
		if (m_moveGoalInfo.moveType == emgtToPoint)
		{
			return (TPPawn(Pawn)).ReachedDestinationPointOrActor(m_moveGoalInfo.loc, None);
		}
		else
		{
			return (TPPawn(Pawn)).ReachedDestinationPointOrActor(m_moveGoalInfo.loc, m_moveGoalInfo.goalActor);
		}
	}
// Not to C++
	function bool IsPawnAtMoveGoal(Pawn thePawn)
	{
		local TPPawn tpPawn;
		;
		tpPawn = TPPawn(thePawn);
		if (m_moveGoalInfo.moveType == emgtToPoint)
		{
			if (tpPawn != None)
			{
				return tpPawn.ReachedDestinationPointOrActor(m_moveGoalInfo.loc, None);
			}
			else
			{
				;
				return false;
			}
		}
		else
		{
			if (tpPawn != None)
				return tpPawn.ReachedDestinationPointOrActor(m_moveGoalInfo.loc, m_moveGoalInfo.goalActor);
			else
				return thePawn.ReachedDestination(m_moveGoalInfo.GoalActor);
		}
	}
// Not to C++
	function bool IsGoalDirectlyReachable()
	{
		if (m_moveGoalInfo.moveType == emgtToPoint)
		{
//			`log(self @ "IsGoalDirectlyReachable: testing point" @ m_moveGoalInfo.loc);
			return PointReachable(m_moveGoalInfo.loc);
		}
		else if (m_moveGoalInfo.moveType == emgtToActor)
		{
//			`log(self @ "IsGoalDirectlyReachable: testing actor" @ m_moveGoalInfo.goalActor);
			if (TPGameInfo(WorldInfo.Game).bKynapseEnabled)
			{
				return PointReachable(m_moveGoalInfo.goalActor.Location);//ActorReachable(m_moveGoalInfo.goalActor);
			}
			else
			{
				return ActorReachable(m_moveGoalInfo.goalActor);
			}
		}
		else
		{
//			`log(self @ "IsGoalDirectlyReachable: testing actor plus offset" @ m_moveGoalInfo.goalActor @ m_moveGoalInfo.loc);
			return PointReachable(m_moveGoalInfo.GoalActor.Location + m_moveGoalInfo.loc);
		}
	}
// Not to C++
	function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " MoveToActor::NotifyTakeHit  Pawn.Health: " @ Pawn.Health @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		//local Vector			centerPos;
		if( Pawn.Health < 1 )
		{
			if( !TPPawn(Pawn).m_bNeedsToPlowIn )
			{
				;
				
				Pawn.Health = 100;
				TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet = true;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetInstigatedBy = InstigatedBy;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetHitlocation = HitLocation;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetMomentum = Vector(Pawn.Rotation) * GetDeathForceForRun() ;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetDamageType = damageType;
				TPPawn(Pawn).m_bNeedsToPlowIn = true;

				KynapseClear();
			}
		}
	}


	//Per state overridable movegoal validation function
	// Not to C++
	function bool ValidateMoveGoal()
	{
		return true;
	}

	//Per state overridable move target validation function
	// Not to C++
	function bool ValidateMoveTarget()
	{
        return true;
	}
// Not to C++
	function float GetMoveStepAsideDelayTime()
	{
		return (RandRange(3.0f,8.0f));
	}
// Not to C++
	function RestartMove()
	{
		GotoState(GetStateName(), 'Restart', false, true);
	}

Begin:

	m_SubStateDebugInfoTag="Begin";

// 	if (Pawn!=none)
// 	{
// 		//Pawn.SetMovementPhysics();
// 	}

	m_HighLevelAiGoal = HighLevelAiGoal_MoveToActorGoal;

	//`log(" ChadAI - TPAIController MoveToActorGoal State Begin --------------------------------------------------------------------------------------------");
Restart:
	//`log(" ChadAI - TPAIController MoveToActorGoal State Restart --------------------------------------------------------------------------------------------");

	m_bMoveAborted = false;
	m_bDelayingMove = false;
	m_moveGoalInfo.m_TimeStartedToWaitForPathToClear = -1.0;

MoveLoop:

	m_moveGoalInfo.bTookBump = false;
	m_moveGoalInfo.bTookHit  = false;

	;

	if (m_moveGoalInfo.moveAttempts++ > m_moveGoalInfo.maxBlockedPathAttempts && m_moveGoalInfo.maxBlockedPathAttempts != 0)
	{
//AbortMove:

		//`log(" ChadAI - Pawn: " @ Pawn @" TPAIController MoveToActorGoal State AbortMove --------------------------------------------------------------------------------------------");
		;

		;

		Goto('AbortMove');
				
	}
	else if ( (m_moveGoalInfo.moveAttempts == (m_moveGoalInfo.maxBlockedPathAttempts - 2 ) ) && (m_moveGoalInfo.maxBlockedPathAttempts > 2) && m_moveGoalInfo.m_bAllowWaitingForPathToClear)
	{
		//`log(" ChadAI - Pawnl " @Pawn @" TPAIController MoveToActorGoal State last chace before AbortMove to wonder a bit and then see if path clears up time: " @ WorldInfo.TimeSeconds @ " --------------------------------------------------------------------------------------------");
		;
		
		// if just started to wait
		if( m_moveGoalInfo.m_TimeStartedToWaitForPathToClear < 0.0f )
		{
			m_moveGoalInfo.m_TimeStartedToWaitForPathToClear = WorldInfo.TimeSeconds;
			//`log(" ChadAI - Pawnl " @Pawn @" TPAIController MoveToActorGoal Start Waiting For Path to Clear: " @ WorldInfo.TimeSeconds @ " --------------------------------------------------------------------------------------------");

		}

		if( m_moveGoalInfo.m_TimeToWaitForPathToClear < 0.0f || ( WorldInfo.TimeSeconds - m_moveGoalInfo.m_TimeStartedToWaitForPathToClear <  m_moveGoalInfo.m_TimeToWaitForPathToClear ) )
		{
			//m_WanderInfo.m_TimeToWanderOrStandWaitingForPathOrPositionToClear = m_moveGoalInfo.m_TimeToWanderOrStandBetweenChecksForPathToClear;

			if( m_moveGoalInfo.bInterruptAndContinue || m_moveGoalInfo.bInterruptable )
			{
				m_WanderInfo.m_bAllowAttackWhileWaitingForPathToClear = true;
			}
			else
			{
				m_WanderInfo.m_bAllowAttackWhileWaitingForPathToClear = false;
			}

			if( m_moveGoalInfo.m_bAllowedToWander && m_WanderInfo.m_bAllowIdleWander )
			{
				PushState('WanderAround');
			}
			else
			{
				PushState('StandWaitingForPathToClear');
			}

			;

			if( m_MultiTierEngagementInfo.m_bSawEnemyWhilePursuing )
			{
				//`log(" ChadAI - " @ Pawn @ "MoveToActorGoal:: Back from Wander and I saw someone while wandering -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

				if( m_moveGoalInfo.bInterruptable ) //Set from Kismet
				{
					//`log(" ChadAI - " @ Pawn @ "MoveToActorGoal:: Back from Wander and I saw someone while wandering and bInterruptable sp Eval Sit-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
					;
					Goto('AbortMove');
				}
				else if( m_moveGoalInfo.bInterruptAndContinue )
				{
					//`log(" ChadAI - " @ Pawn @ "MoveToActorGoal:: Back from Wander and I saw someone while wandering and bInterruptAndContinue so attack -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

					m_moveGoalInfo.m_TimeStartedToWaitForPathToClear = -1.0;
					PushState('Open_Field_Attack');

					m_moveGoalInfo.moveAttempts = 0;
				}
				else
				{
					//`log(" ChadAI - " @ Pawn @ "MoveToActorGoal:: Back from Wander and I saw someone while wandering but not interuptible so let check path again -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
					// Danger could cause endless loop if wander see the enemy again and pops putting us right back here
					m_moveGoalInfo.moveAttempts = m_moveGoalInfo.moveAttempts - 2;
				}
			}
			else
			{
				//`log(" ChadAI - " @ Pawn @ "MoveToActorGoal:: Back from Wander and I did not see anyone while wandering check path one more time-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
			}

		}
		else
		{
			//`log(" ChadAI - " @ Pawn @ "MoveToActorGoal:: No More Time Wander or wait so check path one more time-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
		}

		//AbortMove(true);
	}
	else if (HasValidMoveGoal())
	{

		//`log(" ChadAI - TPAIController MoveToActorGoal State MoveLoop --------------------------------------------------------------------------------------------");

		if (TPGameInfo(WorldInfo.Game).bKynapseEnabled)
		{
			// *** kynapse way ***
			//ValidateMovegoal();
			
			//MoveTimer = 30000;
			if (m_moveGoalInfo.goalActor.IsA('KynapseGamePawn'))
			{
				//`MOVELOG(0,"gotoward" @ m_moveGoalInfo.goalActor);
				;

				//`log(" ChadAI - Pawn: " @ Pawn @" TPAIController MoveToActorGoal KynapseGoTowardFindPath to: " @ m_moveGoalInfo.goalActor @ " --------------------------------------------------------------------------------------------");
				KynapseGoTowardFindPath(m_moveGoalInfo.goalController, 200);
			}
			else
			{
				;
				//`log(" ChadAI - Pawn: " @ Pawn @"  TPAIController MoveToActorGoal KynapseGoToFindPath to: " @ m_moveGoalInfo.goalActor.Location @ " --------------------------------------------------------------------------------------------");
				KynapseGoToFindPath(m_moveGoalInfo.goalActor.Location);
			}

			//`log(" ChadAI - Pawn: " @ Pawn @" TPAIController MoveToActorGoal Back from finding path --------------------------------------------------------------------------------------------");


			if( m_moveGoalInfo.bTookBump || m_moveGoalInfo.bTookHit )//m_MultiTierEngagementInfo.m_bInteruptedWhileLookingForPath )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ "MoveToActorGoal:Main Loop m_moveGoalInfo.bTookBump || m_moveGoalInfo.bTookHit so look for path again -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				;
			}
			else if ( KynapseFoundPath() )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ "MoveToActorGoal: KynapseFoundPath so KynapseFollowPath-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


				if( m_CoverMoveData.m_CurrentCover_Clamied.Link != None )
				{
					ClearCurrentCover();
				}

				m_MultiTierEngagementInfo.m_bSawEnemyWhilePursuing = false;
				KynapseFollowPath(); // follow the found path

				if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
				{
					KillTheTraveller();
					PopState();
				}

				//`log(" ChadAI - Pawn: " @ Pawn @ "MoveToActorGoal: Back from KynapseFollowPath-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				if( m_moveGoalInfo.bTookBump || m_moveGoalInfo.bTookHit )
				{
					//`log(" ChadAI - Pawn: " @ Pawn @ "MoveToActorGoal:Main Loop m_moveGoalInfo.bTookBump || m_moveGoalInfo.bTookHit while moving so move again -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					m_moveGoalInfo.moveAttempts--;
				}
				else if( KynapseHasArrived() )
				{
					//`log(" ChadAI - Pawn: " @ Pawn @ "MoveToActorGoal: Back from KynapseHasArrived-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

					Goto('FinishedMoveToGoal');
				}
				else if(  m_moveGoalInfo.bInterruptAndContinue )
				{
					//`log(" ChadAI - " @ Pawn @ "MoveToActorGoal:: Back from KynapseFollowPath and I saw someone while moving and bInterruptAndContinue so attack -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
					PushState('Open_Field_Attack');
					m_moveGoalInfo.moveAttempts = 0;
					//`log(" ChadAI - " @ Pawn @ "MoveToActorGoal:: Back from AttackWhileWaitingForPathToClear so restart the move loop Move attempts: " @ m_moveGoalInfo.moveAttempts @ " -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

				}
				else
				{
					//`log(" ChadAI - Pawn: " @ Pawn @ "MoveToActorGoal: Back from KynapseHas NOT Arrived try a couple more times then wander for a bit -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				}

			}
			else
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ "MoveToActorGoal:Main Loop did not find path so sleep a little bit then handle not having a path at the top of the loop -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				//InvalidateMoveGoal( m_moveGoalInfo.goalActor, -1 );
	
				Sleep(0.5);
			}

		}
		else
		{
			;
		}
	}

	Goto('MoveLoop');

FinishedMoveToGoal:

	;

	if (TPPawn(Pawn) != None)
	{
		TPPawn(Pawn).FinishedMove(m_bMoveAborted);
	}

//	`log(self @ "FinishedMoveToGoal");

	m_moveGoalInfo.m_TimeStartedToWaitForPathToClear = -1.0;

	ClearLatentAction(class'SeqAct_AIMoveToActor',false);

	Sleep(0.0);

	;

	//`log(" ChadAI - TPAIController MoveToActorGoal after ClearLatentAction No other task is kismet so let eval sit --------------------------------------------------------------------------------------------");

	EvaluateSituation();
	//PopState();

AbortMove:

	//`log(self @ "AbortMove:");
		
	m_bMoveAborted = true;

	ClearLatentAction(class'SeqAct_AIMoveToActor',true);

	Sleep(0.0);

	;

	//`log(" ChadAI - TPAIController MoveToActorGoal after ClearLatentAction No other task is kismet so let eval sit --------------------------------------------------------------------------------------------");

	EvaluateSituation();
}


// Mantle/Vault States
// Not to C++
event bool NotifyLanded(vector HitNormal, actor Wall)
{
	// Vaulting shouldn't actually leave its state until we're safely on the ground.
	if (IsInState('VaultMedium') || IsInState('VaultHigh'))
	{
		PopState();
	}
	
	if (TPPawn(Pawn).Obstacle == OB_Falling)
	{
		TPPawn(Pawn).Obstacle=OB_Landed;
		PushState('VaultLanding');
	}
	return false;
}

state VaultLanding
{
// Not to C++
	function BeginState(Name PreviousStateName)
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;
	}
// Not to C++
	event PushedState()
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;
	}
// Not to C++
	event PausedState()
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = True;
	}
// Not to C++
	event ContinuedState()
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

	}
// Not to C++
	event PoppedState()
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

	}
	// Not to C++
	function EndState(Name NextStateName)
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;
	}
// Not to C++
	function NotifyWeaponFired(Weapon W, byte FireMode)
	{
		StopFiring();
		//`log(" ChadAI - VaultLanding::NotifyWeaponFired  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");        
	}

	function float GetDeathForceForRun()
	{
		return 0;
	}

// Not to C++
	function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
	{
		if( Pawn.Health < 1 )
		{
			if( !TPPawn(Pawn).m_bNeedsToPlowIn )
			{
				;
				
				Pawn.Health = 100;
				TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet = true;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetInstigatedBy = InstigatedBy;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetHitlocation = HitLocation;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetMomentum = Vector(Pawn.Rotation) * GetDeathForceForRun() ;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetDamageType = damageType;
				TPPawn(Pawn).m_bNeedsToPlowIn = true;
			}
		}
	}

	event Tick( float DeltaTime )
	{
		if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
		{
			KillTheTraveller();
		}

		if( m_MantleGoalInfo.m_PlaceToMantle.Link != None )
		{
			DesiredRotation = m_MantleGoalInfo.m_PlaceToMantle.Link.GetSlotRotation( m_MantleGoalInfo.m_PlaceToMantle.SlotIdx ) ;
			DesiredRotation.Pitch = 0;
			Pawn.DesiredRotation = DesiredRotation;
			Pawn.SetRotation( DesiredRotation );
		}
	}

// Not to C++
	event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {

		//`log(" ChadAI - Pawn: " @ Pawn @ " VaultLanding::OnAnimEnd  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		

		if( Pawn != None )
		{
			Pawn.SetPhysics(PHYS_Walking);
			TPPawn(Pawn).Obstacle=OB_Nothing;
		}
        PopState();
    }
}

state VaultMedium
{
    ignores NotifyBump;
// Not to C++
    function PushedState()
    {
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;
		if( Pawn != None )
		{
			Pawn.bCanJump = true;
			TPPawn(Pawn).StopMovement ( );
			TPPawn(Pawn).Obstacle=OB_VaultableMedium;
			Pawn.Mesh.RootMotionMode=RMM_Translate;
			Pawn.SetPhysics (PHYS_None);
			Pawn.bCollideWorld=false;
			Pawn.Mesh.bUpdateSkelWhenNotRendered=true;
		}
		// The time it takes for player to put his hands on wall
        // in this anim - hardcoded for now
        JumpDuration = 0.5f;
        OrigZ = 0;
    }
// Not to C++
	event PoppedState()
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

	}
	// Not to C++
	function EndState(Name NextStateName)
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;
	}
// Not to C++
    event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {
		if( Pawn != None )
		{
			Pawn.SetPhysics(PHYS_Falling);
			Pawn.bCollideWorld = true;
			TPPawn(Pawn).Obstacle=OB_Falling;
			Pawn.Mesh.bUpdateSkelWhenNotRendered=false;
		}
//        PopState();
    }
// Not to C++
	function NotifyWeaponFired(Weapon W, byte FireMode)
    {
		// do nothing for now
		//`log(" ChadAI - TPAIController::VaultMedium::NotifyWeaponFired  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		

		if( m_Engagement_Tac_Data.m_bEngagingOnTheRun )
		{
			m_Engagement_Tac_Data.m_NoOfRoundsFiredThisBurst++;
		}

		StopFiring();
	}
	function float GetDeathForceForRun()
	{
		return 0;
	}

// Not to C++
	function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
	{
		if( Pawn.Health < 1 )
		{
			if( !TPPawn(Pawn).m_bNeedsToPlowIn )
			{
				;
				
				Pawn.Health = 100;
				TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet = true;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetInstigatedBy = InstigatedBy;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetHitlocation = HitLocation;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetMomentum = Vector(Pawn.Rotation) * GetDeathForceForRun() ;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetDamageType = damageType;
				TPPawn(Pawn).m_bNeedsToPlowIn = true;
			}
		}
	}
    // Not to C++
    event Tick( float DeltaTime )
    {

		if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
		{
			KillTheTraveller();
		}

		// DW - This code was causing the enemies to waft down gently when the animation
		// ends and removing it didn't SEEM to break anything... anyway, if we need it
		// back then we'll need to have it stop when OnAnimEnd occurs.
 /*       local float PrevNewLocation;
        local float Percentage;
        local vector NewLocation;

		TPPawn(Pawn).StopMovement ( );

		TotalTime += DeltaTime;

		NewLocation = Pawn.Location;
	
	    PrevNewLocation = OrigZ;
		Percentage = fclamp (TotalTime/JumpDuration, 0, 1);
        
        NewLocation.Z = Percentage*JumpDistance;
	    OrigZ = NewLocation.Z;
		NewLocation.Z = NewLocation.Z - PrevNewLocation;

        NewLocation.Z = Pawn.Location.Z + NewLocation.Z;
	        
	    Pawn.SetLocation (NewLocation);*/
	}
}

state VaultHigh
{
    ignores NotifyBump;
// Not to C++
    function PushedState()
    {
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		if( Pawn != None )
		{
			Pawn.bCanJump = true;
			TPPawn(Pawn).StopMovement ( );
			TPPawn(Pawn).Obstacle=OB_VaultableHigh;
			Pawn.Mesh.RootMotionMode=RMM_Translate;
			Pawn.SetPhysics (PHYS_None);
			Pawn.bCollideWorld=false;
			Pawn.Mesh.bUpdateSkelWhenNotRendered=true;
		}
		// The time it takes for player to put his hands on wall
        // in this anim - hardcoded for now
        JumpDuration = 0.5f;
        OrigZ = 0;
    }
// Not to C++
	event PoppedState()
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

	}
	// Not to C++
	function EndState(Name NextStateName)
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;
	}
// Not to C++
    event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {
		if( Pawn != None )
		{
			Pawn.SetPhysics(PHYS_Falling);
			Pawn.bCollideWorld = true;
			TPPawn(Pawn).Obstacle=OB_Falling;
			Pawn.Mesh.bUpdateSkelWhenNotRendered=false;
		}
//        PopState();
    }
// Not to C++
	function NotifyWeaponFired(Weapon W, byte FireMode)
    {
		// do nothing for now
		//`log(" ChadAI - TPAIController::VaultHigh::NotifyWeaponFired  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		

		if( m_Engagement_Tac_Data.m_bEngagingOnTheRun )
		{
			m_Engagement_Tac_Data.m_NoOfRoundsFiredThisBurst++;
		}

		StopFiring();
	}

	function float GetDeathForceForRun()
	{
		return 0;
	}

// Not to C++
	function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
	{
		if( Pawn.Health < 1 )
		{
			if( !TPPawn(Pawn).m_bNeedsToPlowIn )
			{
				;
				
				Pawn.Health = 100;
				TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet = true;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetInstigatedBy = InstigatedBy;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetHitlocation = HitLocation;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetMomentum = Vector(Pawn.Rotation) * GetDeathForceForRun() ;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetDamageType = damageType;
				TPPawn(Pawn).m_bNeedsToPlowIn = true;
			}
		}
	}
    // Not to C++
    event Tick( float DeltaTime )
    {
		if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
		{
			KillTheTraveller();
		}
		// DW - This code was causing the enemies to waft down gently when the animation
		// ends and removing it didn't SEEM to break anything... anyway, if we need it
		// back then we'll need to have it stop when OnAnimEnd occurs.
/*        local float PrevNewLocation;
        local float Percentage;
        local vector NewLocation;

		TPPawn(Pawn).StopMovement ( );

		TotalTime += DeltaTime;

		NewLocation = Pawn.Location;

        PrevNewLocation = OrigZ;

        Percentage = fclamp (TotalTime/JumpDuration, 0, 1);
		    
		NewLocation.Z = Percentage*JumpDistance;
	    OrigZ = NewLocation.Z;
        NewLocation.Z = NewLocation.Z - PrevNewLocation;

		NewLocation.Z = Pawn.Location.Z + NewLocation.Z;

		Pawn.SetLocation (NewLocation);*/
    }
}

// Mantle/Vault States
state MantlingLow
{
    ignores NotifyBump;
// Not to C++
    function PushedState()
    {
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		if( Pawn != None )
		{
			Pawn.bCanJump = true;
			TPPawn(Pawn).StopMovement ( );
			TPPawn(Pawn).Obstacle=OB_MantleableLow;
			Pawn.Mesh.RootMotionMode=RMM_Translate;
			Pawn.SetPhysics (PHYS_None);
			Pawn.bCollideWorld=false;
			Pawn.Mesh.bUpdateSkelWhenNotRendered=true;
			Pawn.SetLocation (Pawn.Location + 20*LastHitWallNormal);
		}
		// 0.25f is time it takes for player to put his hands on wall
        // in this anim - hardcoded for now
        JumpDuration = 0.5f;
        OrigZ = 0;
    }
// Not to C++
	event PoppedState()
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

	}
	// Not to C++
	function EndState(Name NextStateName)
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;
	}
// Not to C++
    event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {
		if( Pawn != None )
		{
			Pawn.SetPhysics(PHYS_Falling);
			Pawn.bCollideWorld = true;
			TPPawn(Pawn).Obstacle=OB_Nothing;
			Pawn.Mesh.bUpdateSkelWhenNotRendered=false;
		}
        PopState();
    }
// Not to C++
	function NotifyWeaponFired(Weapon W, byte FireMode)
    {
		// do nothing for now
		//`log(" ChadAI - TPAIController::MantlingLow::NotifyWeaponFired  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		

		if( m_Engagement_Tac_Data.m_bEngagingOnTheRun )
		{
			m_Engagement_Tac_Data.m_NoOfRoundsFiredThisBurst++;
		}

		StopFiring();
	}

	function float GetDeathForceForRun()
	{
		return 0;
	}

// Not to C++
	function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
	{
		if( Pawn.Health < 1 )
		{
			if( !TPPawn(Pawn).m_bNeedsToPlowIn )
			{
				;
				
				Pawn.Health = 100;
				TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet = true;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetInstigatedBy = InstigatedBy;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetHitlocation = HitLocation;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetMomentum = Vector(Pawn.Rotation) * GetDeathForceForRun() ;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetDamageType = damageType;
				TPPawn(Pawn).m_bNeedsToPlowIn = true;
			}
		}
	}
    // To C++
    event Tick( float DeltaTime )
    {
        local float PrevNewLocation;
        local float Percentage;
        local vector NewLocation;

		if( Pawn != None )
		{
			if( TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
			{
				KillTheTraveller();
				PopState();
			}

			TPPawn(Pawn).StopMovement ( );

			TotalTime += DeltaTime;

			NewLocation = Pawn.Location;

			PrevNewLocation = OrigZ;
			Percentage = fclamp (TotalTime/JumpDuration, 0, 1);
	        
			NewLocation.Z = Percentage*JumpDistance;
			OrigZ = NewLocation.Z;
			NewLocation.Z = NewLocation.Z - PrevNewLocation;

			NewLocation.Z = Pawn.Location.Z + NewLocation.Z;

			Pawn.SetLocation (NewLocation);
		}
    }
}

state MantlingMedium
{
    ignores NotifyBump;
// Not to C++
    function PushedState()
    {
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		if( Pawn != None )
		{
			Pawn.bCanJump = true;
			TPPawn(Pawn).StopMovement ( );
			TPPawn(Pawn).Obstacle=OB_MantleableMedium;
			Pawn.Mesh.RootMotionMode=RMM_Translate;
			Pawn.SetPhysics (PHYS_None);
			Pawn.bCollideWorld=false;
			JumpDuration = 0.3f;
			Pawn.Mesh.bUpdateSkelWhenNotRendered=true;
			OrigZ = 0;
			Pawn.SetLocation (Pawn.Location + 20*LastHitWallNormal);
		}
    }
// Not to C++
	event PoppedState()
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

	}
	// Not to C++
	function EndState(Name NextStateName)
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;
	}
// Not to C++
    event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {
		if( Pawn != None )
		{
			Pawn.SetPhysics(PHYS_Falling);
			Pawn.bCollideWorld = true;
			TPPawn(Pawn).Obstacle=OB_Nothing;
			Pawn.Mesh.bUpdateSkelWhenNotRendered=false;
		}
        PopState();
    }
// Not to C++
	function NotifyWeaponFired(Weapon W, byte FireMode)
    {
		// do nothing for now
		//`log(" ChadAI - TPAIController::MantlingMedium::NotifyWeaponFired  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		

		if( m_Engagement_Tac_Data.m_bEngagingOnTheRun )
		{
			m_Engagement_Tac_Data.m_NoOfRoundsFiredThisBurst++;
		}

		StopFiring();
	}

	function float GetDeathForceForRun()
	{
		return class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_DeathForceFactor_MeleeCharge;
	}

// Not to C++
	function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
	{
		if( Pawn.Health < 1 )
		{
			if( !TPPawn(Pawn).m_bNeedsToPlowIn )
			{
				;
				
				Pawn.Health = 100;
				TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet = true;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetInstigatedBy = InstigatedBy;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetHitlocation = HitLocation;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetMomentum = Vector(Pawn.Rotation) * GetDeathForceForRun() ;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetDamageType = damageType;
				TPPawn(Pawn).m_bNeedsToPlowIn = true;
			}
		}
	}

	// To C++
    event Tick( float DeltaTime )
    {
        local float PrevNewLocation;
        local float Percentage;
        local vector NewLocation;

		if( Pawn != None )
		{
			if( TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
			{
				KillTheTraveller();
				PopState();
			}

			TPPawn(Pawn).StopMovement ( );

			TotalTime += DeltaTime;

			NewLocation = Pawn.Location;

			PrevNewLocation = OrigZ;
	 
			Percentage = fclamp (TotalTime/JumpDuration, 0, 1);
		    
			NewLocation.Z = Percentage*JumpDistance;
			OrigZ = NewLocation.Z;
			NewLocation.Z = NewLocation.Z - PrevNewLocation;

			NewLocation.Z = Pawn.Location.Z + NewLocation.Z;

			Pawn.SetLocation (NewLocation);
		}
    }
}

state Vaulting
{
    ignores NotifyBump;
// Not to C++
    function PushedState()
    {
        //local vector Loc;  // Commented out to remove warning ENGrb
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		if( Pawn != None )
		{
			Pawn.bCanJump = true;
			TPPawn(Pawn).Obstacle=OB_Vaultable;
			Pawn.Mesh.RootMotionMode=RMM_Translate;
			Pawn.SetPhysics (PHYS_None);
			Pawn.Mesh.bUpdateSkelWhenNotRendered=true;
			Pawn.bCollideWorld = false;

			// The time it takes for player to put his hands on wall
			// in this anim - hardcoded for now
			JumpDuration = 0.5f;

			// @hack for preventing hitting the vaulting wall (animation issue?)
			Pawn.SetLocation (Pawn.Location + 20*LastHitWallNormal + vect(0,0,5));

			OrigZ = 0;
		}
    }

	function float GetDeathForceForRun()
	{
		return 0;
	}

// Not to C++
	function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
	{
		if( Pawn.Health < 1 )
		{
			if( !TPPawn(Pawn).m_bNeedsToPlowIn )
			{
				;
				
				Pawn.Health = 100;
				TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet = true;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetInstigatedBy = InstigatedBy;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetHitlocation = HitLocation;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetMomentum = Vector(Pawn.Rotation) * GetDeathForceForRun() ;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetDamageType = damageType;
				TPPawn(Pawn).m_bNeedsToPlowIn = true;
			}
		}
	}

	event Tick( float DeltaTime )
	{
		if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
		{
			KillTheTraveller();
		}
	}


// Not to C++
	function NotifyWeaponFired(Weapon W, byte FireMode)
    {
		// do nothing for now
		//`log(" ChadAI - TPAIController::Vaulting::NotifyWeaponFired  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		

		if( m_Engagement_Tac_Data.m_bEngagingOnTheRun )
		{
			m_Engagement_Tac_Data.m_NoOfRoundsFiredThisBurst++;
		}

		StopFiring();
	}
// Not to C++
    event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {
		if( Pawn != None )
		{
			Pawn.SetPhysics(PHYS_Falling);
			Pawn.bCollideWorld = true;
			TPPawn(Pawn).Obstacle=OB_Nothing;
			Pawn.Mesh.bUpdateSkelWhenNotRendered=false;
			PopState();
		}
    }
// Not to C++
	function BeginState(Name PreviousStateName)
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

	}
	// Not to C++
	event PausedState()
	{
		;
		if( Pawn != None )
		{
			Pawn.SetPhysics(PHYS_Falling);
			Pawn.bCollideWorld = true;
			TPPawn(Pawn).Obstacle=OB_Nothing;
			Pawn.Mesh.bUpdateSkelWhenNotRendered=false;
		}
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

	}
// Not to C++
	event ContinuedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;


// 		Pawn.bCanJump = true;
//         TPPawn(Pawn).Obstacle=OB_Vaultable;
//         Pawn.Mesh.RootMotionMode=RMM_Translate;
//         Pawn.SetPhysics (PHYS_None);
// 		Pawn.Mesh.bUpdateSkelWhenNotRendered=true;

	}
	// Not to C++
	function EndState(Name NextStateName)
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;


		if( Pawn != None )
		{
			Pawn.SetPhysics(PHYS_Falling);
			Pawn.bCollideWorld = true;
			TPPawn(Pawn).Obstacle=OB_Nothing;
			Pawn.Mesh.bUpdateSkelWhenNotRendered=false;
		}
	}
// Not to C++
	event PoppedState()
	{
		;
		//`log(" ChadAI - Pawn " @ Pawn @ " Vaulting:: PoppedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		if( Pawn != None )
		{
			Pawn.SetPhysics(PHYS_Falling);
			Pawn.bCollideWorld = true;
			TPPawn(Pawn).Obstacle=OB_Nothing;
			Pawn.Mesh.bUpdateSkelWhenNotRendered=false;
		}
	}

}


state VaultMantling
{
    ignores NotifyBump;
// Not to C++
    function PushedState ()
    {
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		if( Pawn != None )
		{
			TPPawn(Pawn).StopMovement ( );
			TPPawn(Pawn).Obstacle=OB_VaultMantleable;
			Pawn.bCanJump = true;
			Pawn.Mesh.RootMotionMode=RMM_Translate;
			Pawn.SetPhysics (PHYS_None);
			Pawn.bCollideWorld=false;
			JumpDuration = 0.25f;
			Pawn.Mesh.bUpdateSkelWhenNotRendered=true;
			OrigZ = 0;
		}
    }
// Not to C++
	event PoppedState()
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

	}
	// Not to C++
	function EndState(Name NextStateName)
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;
	}
// Not to C++
    event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {
		if( Pawn != None )
		{
			Pawn.SetPhysics(PHYS_Walking);
			Pawn.bCollideWorld = true;
			TPPawn(Pawn).Obstacle=OB_Nothing;
			Pawn.Mesh.bUpdateSkelWhenNotRendered=false;
			PopState();
		}
    }
// Not to C++
	function NotifyWeaponFired(Weapon W, byte FireMode)
    {
		// do nothing for now
		//`log(" ChadAI - TPAIController::VaultMantling::NotifyWeaponFired  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		

		if( m_Engagement_Tac_Data.m_bEngagingOnTheRun )
		{
			m_Engagement_Tac_Data.m_NoOfRoundsFiredThisBurst++;
		}

		StopFiring();
	}
// Not to C++

	function float GetDeathForceForRun()
	{
		return 0;
	}

// Not to C++
	function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
	{
		if( Pawn.Health < 1 )
		{
			if( !TPPawn(Pawn).m_bNeedsToPlowIn )
			{
				;
				
				Pawn.Health = 100;
				TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet = true;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetInstigatedBy = InstigatedBy;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetHitlocation = HitLocation;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetMomentum = Vector(Pawn.Rotation) * GetDeathForceForRun() ;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetDamageType = damageType;
				TPPawn(Pawn).m_bNeedsToPlowIn = true;
			}
		}
	}

	// To C++
    event Tick( float DeltaTime )
    {
        local float PrevNewLocation;
        local float Percentage;
        local vector NewLocation;

		if( Pawn != None )
		{
			if( TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
			{
				KillTheTraveller();
				PopState();
			}

			TPPawn(Pawn).StopMovement ( );

			TotalTime += DeltaTime;

			NewLocation = Pawn.Location;

			PrevNewLocation = OrigZ;
			Percentage = fclamp (TotalTime/JumpDuration, 0, 1);
	        
			NewLocation.Z = Percentage*JumpDistance;
			OrigZ = NewLocation.Z;
			NewLocation.Z = NewLocation.Z - PrevNewLocation;

			NewLocation.Z = Pawn.Location.Z + NewLocation.Z;

			Pawn.SetLocation (NewLocation);
		}
    }
}
// Not to C++
function JumpOffDone()
{
}
// Not to C++
function JumpLandDone()
{
}

state JumpDown
{
    //ignores NotifyBump;


	//-----------------------------------------------------------------------
	// Event:
	// Description:
	//-----------------------------------------------------------------------
	// To C++
	event bool NotifyBump(Actor Other, vector HitNormal)
	{
		local Pawn bumpPawn;
		local Controller bumpController;
		local vector groundBoundedLoc;
		local vector GroundNormal;
		local vector AirNormal;
		
		bumpPawn = Pawn(Other);
		bumpController = GetController(bumpPawn);


		;

		//`log(" ChadAI - JumpDown NotifyBump- Hit: " @ Other @ " m_JumpDownSubState: " @ m_MantleGoalInfo.m_JumpDownSubState @ " pawn.loc: " @ Pawn.Location @ " ( WorldInfo.TimeSeconds - m_TimeJumpDownStarted ): " @ ( WorldInfo.TimeSeconds - m_MantleGoalInfo.m_TimeJumpDownStarted ) @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

		if (Pawn != None && bumpPawn != None && bumpController != None && m_MantleGoalInfo.m_JumpDownSubState != JumpDown_HitBottom )
		{
			;
			// try to step aside for them
			//StepAsideFor(bumpPawn);
			groundBoundedLoc = Pawn.Location;
			groundBoundedLoc.Z = Other.Location.Z;
			GroundNormal = Normal(Other.Location - groundBoundedLoc);
			AirNormal = Normal(Pawn.Location - Other.Location);

			//`log(" ChadAI - NotifyBump " @ Other @ " Other.Location: " @ Other.Location @ " groundBoundedLoc: " @ groundBoundedLoc @ " GroundNormal: " @ GroundNormal @ " -!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-! ");

			if( Other != Pawn )
			{
				// magic jump down knockback force
				Other.TakeDamage(300, Self, Other.Location, GroundNormal * 75000.0f , class'TPDamageTypeImpactGrenade');
				Pawn.TakeDamage(1, Pawn(Other).Controller, Pawn.Location, AirNormal * 55000.0f , class'TPDamageTypeImpactGrenade');
			}

			m_MantleGoalInfo.m_JumpDownSubState = JumpDown_DeathFromAbove;
		}
		//return Super.NotifyBump(Other,HitNormal);

		return false;
	}

	// To C++
	function DeathFromAbove()
	{
		//local PlayerPawn P;
		local TPPawn P;
		local vector groundBoundedLoc;
		local vector LNormal;

		//`log(" ChadAI - DeathFromAbove: Time: " @ WorldInfo.TimeSeconds @ "!");

		// This is what turns the Animation Off

		if( TPPawn(Pawn) != None )
		{
			groundBoundedLoc = Pawn.Location;
			ForEach VisibleCollidingActors(class'TPPawn', P, Pawn.CylinderComponent.CollisionRadius * 8, Pawn.Location, true)
			{
				if( P != Pawn )
				{
					groundBoundedLoc.Z = P.Location.Z;
					LNormal = Normal(P.Location - groundBoundedLoc);

					//`log(" ChadAI - DeathFromAbove: VisibleCollidingActorsL " @ P @ " P.Location: " @ P.Location @ " groundBoundedLoc: " @ groundBoundedLoc @ " LNormal: " @ LNormal @ " -!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-! ");


				//if( VSizeSq(groundBoundedLoc - P.Location) < 4096.0 
				//if  (LNormal dot vector(Pawn.Rotation) > 0.5)
																// magic jump down knockback force
					P.TakeDamage(100, Self, P.Location, LNormal * 55000.0f , class'TPDamageTypeImpactGrenade');
				}

			}
		}
	}

	// Not to C++
	function BeginState(Name PreviousStateName)
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;
        //Rappel=RP_Throw;
        //TPPawn(Pawn).PlaySceneAnimation('bb0024a_ground_mobile_stand_alert_intofastropestylea', 1);
	}

	// Not to C++
    function PushedState()
    {
   		//`log(" ChadAI - Rappelling::JumpDown called for Pawn: " @ Pawn @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
 		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

        //Pawn.bCollideWorld=true;
        //Rappel=RP_Throw;
        //TPPawn(Pawn).PlaySceneAnimation('bb0024a_ground_mobile_stand_alert_intofastropestylea', 1);
    }
	
	// Not to C++
	event PausedState()
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;


	}

	// Not to C++
	event ContinuedState()
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

	}


	// Not to C++
	event PoppedState()
	{
		;
		if( Pawn != None )
		{
			Pawn.bCollideWorld=true;
			TPPawn(Pawn).Obstacle=OB_Nothing;
			StopThisBot();
			Pawn.Mesh.bUpdateSkelWhenNotRendered=false;
		}
		else
		{
			//`log(" ChadAI - Con: " @ Self @ " PoppedState Has no Pawn *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
		}

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

	}
	
	// Not to C++
	function EndState(Name NextStateName)
	{
		;
		if( Pawn != None )
		{
			Pawn.bCollideWorld=true;
			TPPawn(Pawn).Obstacle=OB_Nothing;
			StopThisBot();
			Pawn.Mesh.bUpdateSkelWhenNotRendered=false;
		}
		else
		{
			//`log(" ChadAI - Con: " @ Self @ " EndState Has no Pawn *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
		}

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

	}

	function float GetDeathForceForRun()
	{
		return 0;
	}

	// Not to C++
	function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " JumpDown::NotifyTakeHit  for DamageL " @ Damage @ " With Health: " @ Pawn.Health @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		//Super.NotifyTakeHit(InstigatedBy,HitLocation,Damage,damageType,Momentum);		

		//`log(" ChadAI - Pawn: " @ Pawn @ " JumpDown::NotifyTakeHit after Super Call Health: " @ Pawn.Health @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		if( Pawn != None )
		{
			if( Pawn.Health < 1  )
			{
				//`AILog(2, 'JumpDown',"NotifyTakeHit  for DamageL " @ Damage @ " With Health: " @ Pawn.Health @ " So turning phycics back to normal" );
				//`log(" ChadAI - Pawn: " @ Pawn @ " NotifyTakeHit from: " @ InstigatedBy.Pawn @ " for DamageL " @ Damage @ " With Health: " @ Pawn.Health @ " So turning phycics back to normal -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

				Pawn.bCollideWorld=true;
				TPPawn(Pawn).Obstacle=OB_Nothing;
				//StopThisBot();
				Pawn.Mesh.bUpdateSkelWhenNotRendered=false;

				if( !TPPawn(Pawn).m_bNeedsToPlowIn )
			{
					;
					
					Pawn.Health = 100;
					TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet = true;
					TPPawn(Pawn).m_DeadAndDoesNotKnowItYetInstigatedBy = InstigatedBy;
					TPPawn(Pawn).m_DeadAndDoesNotKnowItYetHitlocation = HitLocation;
					TPPawn(Pawn).m_DeadAndDoesNotKnowItYetMomentum = Vector(Pawn.Rotation) * GetDeathForceForRun() ;
					TPPawn(Pawn).m_DeadAndDoesNotKnowItYetDamageType = damageType;
					TPPawn(Pawn).m_bNeedsToPlowIn = true;
				}
			}
		}
		else
		{
			//`log(" ChadAI - Con: " @ Self @ " NotifyTakeHit Has no Pawn *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
		}

	}
	// Not to C++

	function NotifyWeaponFired(Weapon W, byte FireMode)
    {
		// do nothing for now
		//`log(" ChadAI - TPAIController::JumpDown::NotifyWeaponFired  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		

		if( m_Engagement_Tac_Data.m_bEngagingOnTheRun )
		{
			m_Engagement_Tac_Data.m_NoOfRoundsFiredThisBurst++;
		}

		StopFiring();
	}
    
    // Not to C++
	function JumpOffDone()
	{
		//`log(" ChadAI - JumpDown JumpOffDone- m_JumpDownSubState: " @ m_MantleGoalInfo.m_JumpDownSubState @ " pawn.loc: " @ Pawn.Location @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

		if( m_MantleGoalInfo.m_JumpDownSubState == JumpDown_HorizontalOut )
		{
			//`log(" ChadAI - JumpDown JumpOffDone switching to JumpDown_TransitionToVertical- m_JumpDownSubState: " @ m_MantleGoalInfo.m_JumpDownSubState @ " pawn.loc: " @ Pawn.Location @ " ( WorldInfo.TimeSeconds - m_TimeJumpDownStarted ): " @ ( WorldInfo.TimeSeconds - m_MantleGoalInfo.m_TimeJumpDownStarted ) @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

			;

			m_MantleGoalInfo.m_JumpDownSubState = JumpDown_TransitionToVertical;
		}
		else
		{
			//`log(" ChadAI - JumpDown JumpOffDone- not switching to JumpDown_TransitionToVertical - m_JumpDownSubState: " @ m_MantleGoalInfo.m_JumpDownSubState @ " pawn.loc: " @ Pawn.Location @ " ( WorldInfo.TimeSeconds - m_TimeJumpDownStarted ): " @ ( WorldInfo.TimeSeconds - m_MantleGoalInfo.m_TimeJumpDownStarted ) @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
		}
		//m_TimeJumpDownStarted = WorldInfo.TimeSeconds;
	}
// Not to C++
	function JumpLandDone()
	{
		//`log(" ChadAI - JumpDown JumpLandDone- m_JumpDownSubState: " @ m_MantleGoalInfo.m_JumpDownSubState @ " pawn.loc: " @ Pawn.Location @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
		;

		m_MantleGoalInfo.m_JumpDownSubState = JumpDown_None;
	}

// 	function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
// 	{
// 		Pawn.Velocity = vect(0,0,0);
// //		Pawn.SetPhysics(PHYS_Falling);
// //		Pawn.bCollideWorld=true;
// 
// 		Super.NotifyTakeHit(InstigatedBy,HitLocation,Damage,damageType,Momentum);		
// 	}
	// Not to C++

    event bool NotifyLanded(vector HitNormal, actor Wall)
    {
		local vector slotLoc;
		;

		slotLoc = m_MantleGoalInfo.m_PlaceToMantle.Link.GetSlotLocation( m_MantleGoalInfo.m_PlaceToMantle.SlotIdx );

		// if not still jumping off and enough time has passed or is all ready falling the hit bottom
		// if travelled down far enough check to see if done
		if( Pawn != None && ( (slotLoc.Z - Pawn.Location.Z ) > m_MantleGoalInfo.m_JumpDownMinVirticalDist ) )
		{
			if( (( WorldInfo.TimeSeconds - m_MantleGoalInfo.m_TimeJumpDownStarted ) > m_MantleGoalInfo.m_JumpDownHorizontalOutDuration ) || m_MantleGoalInfo.m_JumpDownSubState == JumpDown_VerticalFall ) 
			{
				//`log(" ChadAI - JumpDown NotifyLanded- switch to JumpDown_HitBottom - m_JumpDownSubState: " @ m_MantleGoalInfo.m_JumpDownSubState @ " pawn.loc: " @ Pawn.Location @ " ( WorldInfo.TimeSeconds - m_TimeJumpDownStarted ): " @ ( WorldInfo.TimeSeconds - m_TimeJumpDownStarted ) @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

				;
				m_MantleGoalInfo.m_JumpDownSubState = JumpDown_HitBottom;
				TestForMantleDoneEventWhenFirstTouchGround();
			}
			else
			{
				//`log(" ChadAI - JumpDown NotifyLanded- DO NOT switch to JumpDown_HitBottom - m_JumpDownSubState: " @ m_MantleGoalInfo.m_JumpDownSubState @ " pawn.loc: " @ Pawn.Location @ " ( WorldInfo.TimeSeconds - m_TimeJumpDownStarted ): " @ ( WorldInfo.TimeSeconds - m_TimeJumpDownStarted ) @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

				;
			}
		}
		else
		{
			;	
		}
		//Pawn.Velocity = vect(0,0,0);

        return true;
    }

	// To C++
    function Tick (float DeltaTime)
    {	
		//local rotator slotRot;
   		//`log(" ChadAI - JumpDown m_TimeFallingFromJump: " @ m_TimeFallingFromJump @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
   		//`log(" ChadAI - JumpDown m_JumpDownSubState: " @ m_JumpDownSubState @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

		if( Pawn != None )
		{	
			if( TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
			{
				KillTheTraveller();
				PopState();
			}

			DesiredRotation = m_MantleGoalInfo.m_PlaceToMantle.Link.GetSlotRotation( m_MantleGoalInfo.m_PlaceToMantle.SlotIdx );
			//DesiredRotation = slotRot;
			DesiredRotation.Pitch = 0;
			Pawn.DesiredRotation = DesiredRotation;
			Pawn.SetRotation( DesiredRotation );

			if( m_MantleGoalInfo.m_JumpDownSubState == JumpDown_VerticalFall )
			{
				super.Tick(DeltaTime);
			}
		}
    }

begin:

	m_SubStateDebugInfoTag="Begin";

	if( Pawn == None )
	{
		PopState();
	}

	KynapseClear();

	DesiredRotation = m_MantleGoalInfo.m_PlaceToMantle.Link.GetSlotRotation( m_MantleGoalInfo.m_PlaceToMantle.SlotIdx );
	DesiredRotation.Pitch = 0;

	if( Pawn != None )
	{
		TPPawn(Pawn).DesiredRotation = DesiredRotation;
		Pawn.SetRotation( DesiredRotation );


		FinishRotation();

		// preserve the new orientation and stop turning
		PreserveRotation();

		Pawn.Mesh.RootMotionMode=RMM_Translate;
		Pawn.Mesh.RootMotionRotationMode=RMRM_RotateActor;
		Pawn.Mesh.bUpdateSkelWhenNotRendered=true;
		TPPawn(Pawn).Obstacle=OB_JumpOff;
		Pawn.SetPhysics(PHYS_Falling);

		m_MantleGoalInfo.m_JumpDownSubState = JumpDown_Started;

		m_MantleGoalInfo.m_TimeJumpDownStarted = WorldInfo.TimeSeconds;

		Pawn.bCollideWorld=false;
	}

	
JumpDownLoop:

	//`log(" ChadAI - JumpDownLoop m_JumpDownSubState: " @ m_MantleGoalInfo.m_JumpDownSubState @ " pawn.loc: " @ Pawn.Location @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	if( Pawn != None )
	{
		if( m_MantleGoalInfo.m_JumpDownSubState == JumpDown_Started )
		{
			m_MantleGoalInfo.m_JumpDownSubState = JumpDown_HorizontalOut;
		}
		else if( m_MantleGoalInfo.m_JumpDownSubState == JumpDown_HorizontalOut )
		{
			Goto('JumpingOut');
		}
		else if( m_MantleGoalInfo.m_JumpDownSubState == JumpDown_TransitionToVertical )
		{
	   		Goto('TranistionToVertical');
		}
		else if( m_MantleGoalInfo.m_JumpDownSubState == JumpDown_VerticalFall )
		{
			Goto('Falling');
		}
		else if( m_MantleGoalInfo.m_JumpDownSubState == JumpDown_HitBottom )
		{
			Goto('Landed');
		}
		else if( m_MantleGoalInfo.m_JumpDownSubState == JumpDown_None)
		{
			Goto('Done');
		}
		else if( m_MantleGoalInfo.m_JumpDownSubState == JumpDown_DeathFromAbove )
		{
			Goto('DeathFromAbove');
		}

	}

	Goto('JumpDownLoop');

	// To C++
JumpingOut:

	if( ( WorldInfo.TimeSeconds - m_MantleGoalInfo.m_TimeJumpDownStarted ) < m_MantleGoalInfo.m_JumpDownHorizontalOutDuration )
	{
		Pawn.Velocity = vect(30,0,0);
//					DesiredRotation = m_MantleGoalInfo.m_PlaceToMantle.Link.GetSlotRotation( m_MantleGoalInfo.m_PlaceToMantle.SlotIdx ) ;
//					Pawn.SetRotation( DesiredRotation );
	}
	else
	{
		m_MantleGoalInfo.m_JumpDownSpeed = ( WorldInfo.TimeSeconds - m_MantleGoalInfo.m_TimeJumpDownStarted ) - m_MantleGoalInfo.m_JumpDownHorizontalOutDuration;
		if (m_MantleGoalInfo.m_JumpDownSpeed > 1.0f)
		{
			m_MantleGoalInfo.m_JumpDownSpeed = 1.0f;
		}
		Pawn.Velocity.x = 0.0f;
		Pawn.Velocity.y = 0;
		Pawn.Velocity.z = -400.0f * m_MantleGoalInfo.m_JumpDownSpeed;
	}

	//`log(" ChadAI - JumpingOut Time In Jump: " @ ( WorldInfo.TimeSeconds - m_TimeJumpDownStarted )  @ " Time for Horz Out: " @ m_MantleGoalInfo.m_JumpDownHorizontalOutDuration @ " Pawn.Location : " @ Pawn.Location @ " Pawn.Vel: " @ Pawn.Velocity @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );


	Sleep(0.0);
	Goto('JumpDownLoop');

TranistionToVertical:

	if ( ( WorldInfo.TimeSeconds - m_MantleGoalInfo.m_TimeJumpDownStarted ) < m_MantleGoalInfo.m_JumpDownHorizontalOutDuration )
	{
		Pawn.Velocity = vect(0,0,-400);
//					DesiredRotation = m_MantleGoalInfo.m_PlaceToMantle.Link.GetSlotRotation( m_MantleGoalInfo.m_PlaceToMantle.SlotIdx );
//					Pawn.SetRotation( DesiredRotation );
	}
	else
	{
		;

		m_MantleGoalInfo.m_JumpDownSubState = JumpDown_VerticalFall;
		TPPawn(Pawn).Obstacle = OB_JumpDown;
		//Pawn.bCollideWorld=true;
	}

	//`log(" ChadAI - TranistionToVertical Time In Jump: " @ ( WorldInfo.TimeSeconds - m_MantleGoalInfo.m_TimeJumpDownStarted )  @ " Pawn.Location : " @ Pawn.Location @ " Pawn.Vel: " @ Pawn.Velocity @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );


	Sleep(0.0);
	Goto('JumpDownLoop');


Falling:

	//`log(" ChadAI - Falling Time In Jump: " @ ( WorldInfo.TimeSeconds - m_MantleGoalInfo.m_TimeJumpDownStarted )  @ " Pawn.Location : " @ Pawn.Location @ " Pawn.Vel: " @ Pawn.Velocity @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	if( Pawn != None && 
		( (m_MantleGoalInfo.m_PlaceToMantle.Link.GetSlotLocation( m_MantleGoalInfo.m_PlaceToMantle.SlotIdx ).Z - Pawn.Location.Z ) > m_MantleGoalInfo.m_JumpDownMinVirticalDist ) && 
		Pawn.bCollideWorld == false )
	{
		;

		Pawn.bCollideWorld=true;
	}

	Sleep(0.0);
	Goto('JumpDownLoop');


Landed:

	//`log(" ChadAI - Landed Time In Jump: " @ ( WorldInfo.TimeSeconds - m_TimeJumpDownStarted )  @ " Pawn.Location : " @ Pawn.Location @ " Pawn.Vel: " @ Pawn.Velocity @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	StopThisBot();

	DesiredRotation = m_MantleGoalInfo.m_PlaceToMantle.Link.GetSlotRotation( m_MantleGoalInfo.m_PlaceToMantle.SlotIdx );
	DesiredRotation.Pitch = 0.0;
	Pawn.DesiredRotation = DesiredRotation;
	Pawn.SetRotation( DesiredRotation );

	TPPawn(Pawn).Obstacle=OB_JumpLand;
	Pawn.Mesh.bUpdateSkelWhenNotRendered=false;

	Sleep(0.0);
	Goto('JumpDownLoop');


Done:

	//`log(" ChadAI - Done: with jump Time In Jump: " @ ( WorldInfo.TimeSeconds - m_TimeJumpDownStarted )  @ " Pawn.Location : " @ Pawn.Location @ " Pawn.Vel: " @ Pawn.Velocity @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	if( m_MantleGoalInfo.m_JumpDownSubState != JumpDown_DeathFromAbove )
	{
		;
		PopState();
	}

DeathFromAbove:

	DeathFromAbove();

	m_MantleGoalInfo.m_JumpDownSubState = JumpDown_TransitionToVertical;
	//m_TimeJumpDownStarted = WorldInfo.TimeSeconds;
	Goto('JumpDownLoop');
}

// Not to C++
event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    if (SeqNode.AnimSeqName == 'bb0005k_air_mobile_stand_alert_catch')
    {
        if (TPPawn(Pawn).Obstacle == OB_Catchable)
            PushState ('Hanging');
    }
}
// Not to C++
function DoCatch ( )
{
    TPPawn(Pawn).SnapToWall (-LastHitWallNormal, JumpDistance);

    TPPawn(Pawn).StopMovement();
    Pawn.SetPhysics(PHYS_None);
    TPPawn(Pawn).Obstacle = OB_Catchable;
    
    Pawn.bCollideWorld=false;
}

state Hanging
{
	// Not to C++
    function PushedState ()
    {
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

        Pawn.SetPhysics(PHYS_None);
        Pawn.bCollideWorld=false;
        Pawn.Mesh.RootMotionMode=RMM_Translate;

        TPPawn(Pawn).Obstacle = OB_Hangable;
        Pawn.Mesh.bUpdateSkelWhenNotRendered=true;

        PrevLocation = Pawn.Location;
        TotalTime    = 0;
    }
// Not to C++
    event PoppedState()
    {
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;
        Pawn.Mesh.bUpdateSkelWhenNotRendered=false;
        ClearLatentAction(class'SeqAct_ShimmyControl',false);        
    }
// Not to C++
    event OnAnimEnd (AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {

        if (SeqNode.AnimSeqName == 'bb0005n_air_mobile_stand_alert_shimmyright')
        {
            TPPawn(Pawn).Shimmy = SH_None;
            TPPawn(Pawn).ShimmyToggle=true;
            seqShimmyControl.TotalDistance += VSize(Pawn.Location-PrevLocation);
            PrevLocation = Pawn.Location;
        }
        else if (SeqNode.AnimSeqName == 'bb0005h_air_mobile_stand_alert_mantle_climbhighwall')
        //else if (SeqNode.AnimSeqName == 'bb0005h_air_mobile_stand_alert_mantleclimbhighwall')
        {
            Pawn.SetPhysics (PHYS_Falling);
            Pawn.bCollideWorld = true;
            TPPawn(Pawn).Obstacle=OB_Nothing;

            ClearLatentAction(class'SeqAct_ShimmyControl',false);

            PopState ( );
        }
        else if (SeqNode.AnimSeqName == 'bb0005o_air_mobile_stand_alert_shimmyleft')
        {
            TPPawn(Pawn).Shimmy = SH_None;
            TPPawn(Pawn).ShimmyToggle=true;
            seqShimmyControl.TotalDistance += VSize(Pawn.Location-PrevLocation);
            PrevLocation = Pawn.Location;
        }
        else if (SeqNode.AnimSeqName == 'bb0005p_air_mobile_stand_alert_shimmy90right')
        {
            TPPawn(Pawn).Shimmy = SH_None;
            TPPawn(Pawn).ShimmyToggle=true;
            TPPawn(Pawn).SnapToWall (ShimmyDirection, 0);
            bSnapWall = true;
        }
        else if (SeqNode.AnimSeqName == 'bb0005q_air_mobile_stand_alert_shimmy90left')
        {
            TPPawn(Pawn).Shimmy = SH_None;
            TPPawn(Pawn).ShimmyToggle=true;
            TPPawn(Pawn).SnapToWall (ShimmyDirection, 0);
            bSnapWall = true;
        }
        else if (SeqNode.AnimSeqName == 'bb0005r_air_mobile_stand_alert_shimmy270right')
        {
            TPPawn(Pawn).Shimmy = SH_None;
            TPPawn(Pawn).ShimmyToggle=true;
            TPPawn(Pawn).SnapToWall (ShimmyDirection, 0);
            bSnapWall = true;

        }
        else if (SeqNode.AnimSeqName == 'bb0005s_air_mobile_position_state_shimmy270left')
        {
            TPPawn(Pawn).Shimmy = SH_None;
            TPPawn(Pawn).ShimmyToggle=true;
            TPPawn(Pawn).SnapToWall (ShimmyDirection, 0);
            bSnapWall = true;
        }
        else if (SeqNode.AnimSeqName == 'bb0008l_ground_mobile_position_alert_ladderjumpland')
        //else if (SeqNode.AnimSeqName == 'bb0005t_ground_mobile_stand_alert_mantlejumpland')
        {
            TPPawn(Pawn).Obstacle=OB_Nothing;
            ClearLatentAction(class'SeqAct_ShimmyControl',false);
            Pawn.SetPhysics(PHYS_Falling);
            PopState();
        }
        else if (SeqNode.AnimSeqName == 'bb0005i_air_mobile_stand_alert_jumpoff')
        {
            Pawn.SetPhysics(PHYS_Falling);
            Pawn.bCollideWorld = true;
            TPPawn(Pawn).Obstacle=OB_Falling;
        }
    }
// Not to C++
    event bool NotifyLanded(vector HitNormal, actor Wall)
    {
        TPPawn(Pawn).Obstacle=OB_Nothing;
        PopState();
        return false;
    }
// Not to C++
    function Tick (float DeltaTime)
    {
        local vector NewLocation;
        local float  Percentage;

        if (seqShimmyControl != None && 
            seqShimmyControl.TotalDistance >= seqShimmyControl.Action[seqShimmyControl.CurrentIndex].Distance)
        {
            seqShimmyControl.CurrentIndex++;
            seqShimmyControl.TotalDistance = 0;
            if (seqShimmyControl.CurrentIndex == seqShimmyControl.Action.Length)
            {
                ClearLatentAction(class'SeqAct_ShimmyControl',false);
                seqShimmyControl = None;
            }
        }

        if (seqShimmyControl != None && TPPawn(Pawn).Shimmy == SH_None)
        {
            switch (seqShimmyControl.Action[seqShimmyControl.CurrentIndex].Shimmy)
            {
                case SA_Left:
                    TPPawn(Pawn).Shimmy = TPPawn(Pawn).TestShimmyDirection
                        (-1, ShimmyDirection, ShimmyManualDistance);
                    break;
                case SA_Right:
                    TPPawn(Pawn).Shimmy = TPPawn(Pawn).TestShimmyDirection
                        (1, ShimmyDirection, ShimmyManualDistance);
                    break;
                case SA_PullUp:
                    if (TPPawn(Pawn).TestClimbUp())
                    {
                        TPPawn(Pawn).Obstacle = OB_Climbable;
                    }
                    else
                    {
                        ;
                    }
                    break;
                case SA_Drop:
                    TPPawn(Pawn).Obstacle = OB_Dropping;
                    break;
                default:
                    break;
            }
        }

        if (ShimmyManualDistance == 0)
            Pawn.Mesh.RootMotionMode=RMM_Translate;
        else
            Pawn.Mesh.RootMotionMode=RMM_Ignore;

        if (TPPawn(Pawn).Shimmy != SH_None && ShimmyManualDistance > 1.0f)
        {
            TotalTime += DeltaTime;
            Percentage = fclamp (TotalTime/1.0f, 0, 1); // 1.0 is length of animation
            NewLocation = PrevLocation + (ShimmyDirection * (ShimmyManualDistance) * Percentage);
            Pawn.SetLocation(NewLocation);

            //Pawn.Velocity = ShimmyDirection * (ShimmyManualDistance);
        }
    }

}

// Not to C++
event bool NotifyHitWall(vector HitNormal, actor Wall)
{
	Pawn.bCanJump = false;
	bHittingWall = true;

	bHitWallPressedJump = true;

    LastHitWallNormal = HitNormal;
	
	return false;
}

// NOT USE
final function bool CurrentEnemyBehindCover()
{
	local vector slotLocation;
	local vector chkFwd;

	local vector deltaVecToEnemy;
	local float distTimesCosAngle;


	if (Pawn == None || Enemy == None || m_CoverMoveData.m_ReservedGoToCover_Clamied.Link == None )
	{
		return FALSE;
	}

	slotLocation = m_CoverMoveData.m_ReservedGoToCover_Clamied.Link.GetSlotLocation(m_CoverMoveData.m_ReservedGoToCover_Clamied.SlotIdx);
	chkFwd = Vector(m_CoverMoveData.m_ReservedGoToCover_Clamied.Link.GetSlotRotation(m_CoverMoveData.m_ReservedGoToCover_Clamied.SlotIdx));
	// FLOAT TestDistSq = TestDistance * TestDistance;

	deltaVecToEnemy = Enemy.Location - slotLocation;

	distTimesCosAngle = chkFwd dot deltaVecToEnemy;

	//FLOAT distTimesCosAngle = chkFwd | delta;

	if (distTimesCosAngle < 0)
	{
		return TRUE;
	}

	return FALSE;
}

native final function bool IsItValidForMeToStartCQB_Attack();


// function for checking if the NPC is valid for and in rage to start CQB
// this version does not have a time to wait between checks and should be called from latent areas of states
native final function bool DetermineIfShouldStartCQBForGoingToTurret_Latent();

// function for checking if the NPC is valid for and in rage to start CQB
// this version does have a time to wait between checks and should be called from tick fns or other areas of code
// that get called offten
native final function bool DetermineIfShouldStartCQBForGoingToTurret_Tick();

// function for checking if the NPC is valid for and in rage to start CQB
// this version does have a time to wait between checks and should be called from tick fns or other areas of code
// that get called offten
native final function bool DetermineIfShouldStartCQB_Tick( float CurrentGameTime );

// function for checking if the NPC is valid for and in rage to start CQB
// this version does not have a time to wait between checks and should be called from latent areas of states
native final function bool DetermineIfShouldStartCQB_Latent( float CurrentGameTime );

//---------------------------------------------------------------------------
// Function:
// Description:	Returns true if our weapon is currently reloading.
//---------------------------------------------------------------------------
// NOT To C++ check wepaon state instead
function bool IsReloading()
{
	local TPWeapon weap;
	local TPPawn tpPawn;
	if (Pawn != None)
	{
		tpPawn = TPPawn(Pawn);
		weap = TPWeapon(Pawn.Weapon);
	}
	return (weap != None &&
			Pawn != None &&
			tpPawn != None &&
			tpPawn.IsReloading());
}

//-----------------------------------------------------------------------
// Function:
// Description:	Checks to see if it's okay to fire or if not see if there is a
// tactical positon movement (side step) that can be done to allow firing
//-----------------------------------------------------------------------
// To C++
function bool ShouldIFireTactical()
{
	// don't shoot during grapples fix. DK
	if (Enemy != None && Enemy.Controller != None 
		&& TPPlayerController(Enemy.Controller) != None 
		&& TPPlayerController(Enemy.Controller).IsGrappling())
	{
		;
		return false;
	}
	
	if (IsReloading())
	{
		;
		return false;
	}


	// Added to make sure that Kynapse controlled pawns dont fire when they are facing away - RB
	if (TPGameInfo(WorldInfo.Game).bKynapseEnabled)
	{
		if( Enemy != None )
		{

			if( Enemy != None && m_Engagement_Tac_Data.m_bAllowTacticalSteping )
			{
				m_Engagement_Tac_Data.m_MoveNeed2Kill = GetRequiredMovementForEngagement(	Enemy,
																							Vector(Pawn.Rotation), 
																							m_Engagement_Tac_Data.m_SideStepTargetMoveLoc,
																							false);
				if( m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_Travel )
				{
					;
					//`log(" ChadAI - Pawn: " @ Pawn @ " ShouldIFireTactical Current enemy " @ Enemy @ " can be tactically enaged -move needed to Kill: " @ m_Engagement_Tac_Data.m_MoveNeed2Kill @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
					return true;
				}
				else
				{
					//`log(" ChadAI - Pawn: " @ Pawn @ " ShouldIFireTactical Current enemy " @ Enemy @ " can NOT!!!! be tactically enaged -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
					return false;
				}
			}
			else if (!CanFireAtNotFromCover(Enemy))
			{
				return false;
			}
		}
		else
		{
			;
			return false;
		}
	}

	return true;
}

//-----------------------------------------------------------------------
// State:		FollowActorGoal
// Description:
//-----------------------------------------------------------------------
state FollowActorGoal
{
	// Not to C++
	function BeginState(Name PreviousStateName)
	{
		;

		m_HighLevelAiGoal = HighLevelAiGoal_FollowActorGoal;

		//`log(" ChadAI - TPAIController::FollowActorGoal::BeginState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
	}
	
	// Not to C++
	event PausedState()
	{
		;

		//`log(" ChadAI - TPAIController::FollowActorGoal::PausedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	}

	// Not to C++
	event PoppedState()
	{
		;

		m_HighLevelAiGoal = HighLevelAiGoal_NONE;


		//`log(" ChadAI - TPAIController::FollowActorGoal::PausedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	}

	// Not to C++
	event ContinuedState()
	{
		;

		m_HighLevelAiGoal = HighLevelAiGoal_FollowActorGoal;

		StopFiring();

		//`log(" ChadAI - TPAIController::FollowActorGoal::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}
	// Not to C++
	function EndState(Name NextStateName)
	{
		;

		m_HighLevelAiGoal = HighLevelAiGoal_NONE;

		//`log(" ChadAI - TPAIController::FollowActorGoal::EndState -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}
	// Not to C++
	function AccomplishedGoal()
	{
		//`log(" ChadAI - TPAIController::FollowActorGoal::AccomplishedGoal() -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		m_CoverFightData.m_bUsingFightingPosition = false;

		ClearLatentAction(class'SeqAct_FollowActor',false);
	}

	// Not to C++
	function FailedGoal()
	{
		//`log(" ChadAI - TPAIController::FollowActorGoal::FailedGoal() -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		m_CoverFightData.m_bUsingFightingPosition = false;

		ClearLatentAction(class'SeqAct_FollowActor',true);
	}
	
	// Not to C++
	event Tick( float DeltaTime )
	{
		//`log(" ChadAI - TPAIController::FollowActorGoal::Tick -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		//UpdateAimInTheOpen(FALSE);;
		UpdateHeadtracking();
		Super.Tick(DeltaTime);	
	}


Begin:

	m_SubStateDebugInfoTag="Begin";

	//`log(" ChadAI - TPAIController::FollowActorGoal::Begin -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	m_Follow_Data.m_bContinueToFollow = true;

	m_HighLevelAiGoal = HighLevelAiGoal_FollowActorGoal;


FollowActorGoalLoop:

	if( !m_Follow_Data.m_bContinueToFollow )
	{
		;

		AccomplishedGoal();
		Goto('DoneFollowing');

	}
	else if(		 m_Follow_Data.ActorToFollow == None || 
					(TPPawn(m_Follow_Data.ActorToFollow).Controller) == None || 
					(TPPawn(m_Follow_Data.ActorToFollow).Controller).IsInState('Dead'))
	{
		//`log(" ChadAI - FollowActorGoal::FollowActorGoalLoop Goal Has Been Accomplished  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

		;

		FailedGoal();

		Goto('DoneFollowing');

		//`log(" ChadAI - FollowActorGoal::FollowActorGoalLoop Goal Has Been Accomplished  GotoState('Idle') *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );		

	}
	else if( VSizeSq( m_Follow_Data.ActorToFollow.Location - Pawn.Location ) > ( m_Follow_Data.m_FollowBandMaxRange * m_Follow_Data.m_FollowBandMaxRange ) )
	{
		;

		Goto('NeedToMoveSubState');
	}
	else if( DetermineIfGrenadeShouldBeAutoThrown() )
	{
		;

		PushState('UseGrenadeAgainstEnemy');
	}
	else if( Enemy != None && ShouldIAttackEnemy() )
	{

		if( ShouldIPursueEnemy() )
		{
			;

			if( m_Engagement_Tac_Data.m_bAllowTacticalSteping && ShouldIFireTactical() )
			{
				Goto('NeedToAttackSubState');
			}
			else
			{
				//Goto('NeedToPursueSubState');
				Sleep(1.0);
			}
		}
		else
		{
			;

			Goto('NeedToAttackSubState');
		}
	}
	else
	{
		;

		Goto('NeedToBeWaitSubState');
	}

	Goto('FollowActorGoalLoop');



NeedToBeWaitSubState:

	PushState('StandWaitingToFollow');
	Goto('FollowActorGoalLoop');

NeedToMoveSubState:

	m_Follow_Data.m_NoOfTimesPathHasBeenTried++;

	KynapseGoTowardFindPath( Pawn(m_Follow_Data.ActorToFollow).Controller, m_Follow_Data.m_FollowBandMinRange);

	if ( KynapseFoundPath() )
	{
		;
		m_Follow_Data.m_FollowPathBuilt = true;
		//`log(" ChadAI - Pawn " @ Pawn @ " FollowActorGoalLoop Found Path to: " @ m_Follow_Data.ActorToFollow @ " so go to follow state *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
		PushState('Following');

	}
	else
	{
		;

		if( m_Follow_Data.m_bAllowWaitingForPathToTargetToClear )
		{
			if( (m_Follow_Data.m_NoOfTimesToCheckForPathToTarget < 0 ) || ( m_Follow_Data.m_NoOfTimesPathHasBeenTried < m_Follow_Data.m_NoOfTimesToCheckForPathToTarget ) )
			{

				m_WanderInfo.m_TimeToWanderOrStandWaitingForPathOrPositionToClear = m_Follow_Data.m_TimeToWaitBetweenPathChecks;

				m_WanderInfo.m_bAllowAttackWhileWaitingForPathToClear = m_Follow_Data.m_bAllowAttackWhileWaitingForPathToClear;

				if( m_Follow_Data.m_bAllowWanderingWhileWaiting && m_WanderInfo.m_bAllowIdleWander )
				{
					PushState('WanderAround');			
				}
				else
				{
					PushState('StandWaitingForPathToClear');
				}
			}
			else
			{
				;

				FailedGoal();
				Goto('DoneFollowing');
			}
		}
		else
		{
			;

			FailedGoal();
			Goto('DoneFollowing');
		}
	}

	Sleep(0.0);

	Goto('FollowActorGoalLoop');

NeedToAttackSubState:

	PushState('Attack_While_Following');
	Goto('FollowActorGoalLoop');

// NeedToPursueSubState:
// 
// 	PushState('PursueEnemy');
// 	Goto('FollowActorGoalLoop');


DoneFollowing:

	Sleep(0.0);

	EvaluateSituation();

}

// Following State
state Following
{
ignores /*SeePlayer,  CHAD REMOVED HearNoise,*/ Bump, EvaluateSituation;
// Not to C++
	event PausedState()
	{
		;

		//`log(" ChadAI - TPAIController::FollowActorGoal::PausedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	}

	// Not to C++
	event PoppedState()
	{
		;

		TPPawn(Pawn).SetMovementType( MovementType_Default );
		TPPawn(Pawn).SetMovementVariation( MovementVariation_A );
		bHunting=false;
		KynapseClear();

		//`log(" ChadAI - TPAIController::FollowActorGoal::PausedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	}

	// Not to C++
	event ContinuedState()
	{
		;

		StopFiring();

		//`log(" ChadAI - TPAIController::FollowActorGoal::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}
	// Not to C++
	function EndState(Name NextStateName)
	{
		;

		TPPawn(Pawn).SetMovementType( MovementType_Default );
		TPPawn(Pawn).SetMovementVariation( MovementVariation_A );
		bHunting=false;
		KynapseClear();

		//`log(" ChadAI - TPAIController::FollowActorGoal::EndState -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}

	// Not to C++
	function PushedState()
	{
		;

		if (Pawn != None)
		{
			//Pawn.SetMovementPhysics();
			bHunting=true;
		}
	}

// Not to C++
	event Tick( float DeltaTime )
	{
		if (anode_WeaponBlend != none)
		{
			if (Pawn.Weapon == none)
				anode_WeaponBlend.SetBlendTarget(1.0, 0.2);
			else
				anode_WeaponBlend.SetBlendTarget(0.0, 0.2);
		}

		if ( PlayerPawn(m_Follow_Data.ActorToFollow) != none && ( VSizeSq(m_Follow_Data.ActorToFollow.Location-Pawn.Location) > ( m_Follow_Data.m_CatchingUpDistance *  m_Follow_Data.m_CatchingUpDistance ) ) )
		{
			Pawn.GroundSpeed = PlayerPawn(m_Follow_Data.ActorToFollow).SprintGroundSpeed;
		}
		else
		{
			TPPawn(Pawn).SetMovementType( MovementType_Default );
			TPPawn(Pawn).SetMovementVariation( MovementVariation_A );
		}

// 		if (bHittingWall)
// 			TestObstacle();
// 		bHittingWall = false;
	
		UpdateHeadTracking();

		if( DetermineIfShouldStartCQB_Tick( WorldInfo.TimeSeconds ) )
		{
			//`log(" ChadAI - TPSoldierAIController::FollowActorGoal::Tick:: EnemyIsInRange  m_RangeToStartCQB_State -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			KynapseClear();
			//PushState('CloseQuartersBattleAttack');
		}

	}


Begin:

	m_SubStateDebugInfoTag="Begin";

	//m_FollowBandMaxRange=500
	//m_FollowBandMinRange=300
	
FollowingLoop:

	if( m_Follow_Data.m_FollowPathBuilt )
	{

		KynapseFollowPath(); // follow the found path 

		//`log(" ChadAI - Pawn: " @ Pawn @ "FollowActorGoalLoop: Back from KynapseFollowPath-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}

	PopState();
}


//***********************************************************************
// PUSHABLE STATES
//************************ - END SECTION - ******************************





//************************ - BEGIN SECTION - ****************************
// AI STATES
//***********************************************************************

// Not to C++
event GetStartState(TPPawn thePawn)
{
	StartStateName = thePawn.GetStartStateName();
}




auto state WaitingForPawn
{
	// THIS FUNCTION IS CALLED WHEN THE PAWN IS POSSESSED BY THIS CONTROLLER
	// PUT ANY ONE-TIME INITIALIZATION CODE HERE
	// Not to C++
	function Possess(Pawn aPawn, bool bVehicleTransition)
	{
		local TPPawn tpPawn;

		Super.Possess(aPawn, bVehicleTransition);


		tpPawn = TPPawn(aPawn);

	
		if (tpPawn != None)
		{
			//`AILOG(0, 'Possess',"Possessing pawn");
			;

		
		
			//Set mesh flags for optimization
			tpPawn.Mesh.bUpdateSkelWhenNotRendered=m_bUpdateSkelWhenNotRendered;
			tpPawn.Mesh.bIgnoreControllersWhenNotRendered=m_bIgnoreControllersWhenNotRendered;
		
		
			GetStartState(tpPawn);
			
			
			if( WorldInfo.Game.IsA('TPSinglePlayerGameInfo')) //single player game type
			{
				if (tpPawn.TeamAssignment != TPTEAM_UNKNOWN)
				{
					//`log(self @ "setting team to " @ tppawn.teamassignment);
					
					SetTeam(tpPawn.TeamAssignment);
				}
			}
			
			tppawn.SetUniform( tppawn.Uniform ); //sets up the rank icon
			
		}

		// startup any logic timers
		SetTimer(5.f,true,'UpdateRecentNoise');
		SetTimer(0.2f,true,'UpdatePlayerList');
//		SetTimer(0.5f,true,'UpdateUnderFireMeter');
		SetTimer(1.0f,true,'UpdateInvalidatedMoveGoals');
		SetTimer(0.2f,true,'UpdateTacticalEngagementData');
		//SetTimer(0.1,true,'UpdatePawnWatcher');

//		if (tpPawn != None && tpPawn.bDisableTakeDamageOnStart)
//			bGodMode = true;

		if (tpPawn != None && tpPawn.bDisableAIOnStart)
		{
			DisableAI(true);
		}
		else
		{
			;

			EvaluateSituation(); // and transition to idle state
		}
	
		if( anode_WeaponBlend == none)
		{
			anode_WeaponBlend = AnimNodeBlend(Pawn.Mesh.Animations.FindAnimNode('WeaponBlend'));
			if(anode_WeaponBlend == none)
			{
				;
			}
		}
	}

}


state AIDisabled
{
	// Not to C++
	function BeginState(Name PreviousStateName)
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;
		//`log(" ChadAI - AIDisabled::BeginState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
	}
	
	// Not to C++
	event PausedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;
		//`log(" ChadAI - TAIDisabled::PausedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	}

	// Not to C++
	event ContinuedState()
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;
		//`log(" ChadAI - AIDisabled::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}

// Not to C++
	event PoppedState()
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;
		//`log(" ChadAI - AIDisabled::PoppedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}
	
	// Not to C++
	function EndState(Name NextStateName)
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;
		//`log(" ChadAI - AIDisabled::EndState -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}

	// Not to C++
    function NotifyWeaponFired(Weapon W, byte FireMode)
    {
		// do nothing for now
		//`log(" ChadAI - AIDisabled::NotifyWeaponFired  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
		if( m_Engagement_Tac_Data.m_bEngagingOnTheRun )
		{
			m_Engagement_Tac_Data.m_NoOfRoundsFiredThisBurst++;
		}
	}
}

// Not to C++
function OnDoPerformanceAtCover(SeqAct_DoPerformanceAtCover inAction)
{
	local array<Object> objVars;
// 	//`log(" ChadAI - NPC: " @ Pawn.Name @ " OnDoPerformanceAtCover using cover: " @ objVars[0].Name @ "  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	// if routing we need to not clear latent actions on these moves
	inAction.GetObjectVars(objVars,"Cover To Be At");
		
	//`log(" ChadAI - NPC: " @ Pawn.Name @ " using cover group: " @ objVars[0].Name @ "  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
		
	m_DoPerformanceAtCoverData.m_CoverToDoPerformaceAt.Link = TPCoverNode(objVars[0]);
	m_DoPerformanceAtCoverData.m_CoverToDoPerformaceAt.SlotIdx = inAction.m_SlotToPerformAt;

	//`log(" ChadAI - NPC: " @ Pawn @ " OnDoPerformanceAtCover using cover: " @ m_DoPerformanceAtCoverData.m_CoverToDoPerformaceAt.Link @ " slot: " @ m_DoPerformanceAtCoverData.m_CoverToDoPerformaceAt.SlotIdx @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
	
	inAction.GetObjectVars(objVars,"Look at This");
		
	//`log(" ChadAI - NPC: " @ Pawn @ " OnDoPerformanceAtCover Look at: " @ objVars[1] @ "  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	if( objVars[1].IsA('Controller') )
	{
		//`log(" ChadAI - " @ objVars[1].Name @ " is a controller  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

		m_DoPerformanceAtCoverData.m_HeadTrackTarget = Controller(objVars[1]).Pawn;
	}
	else if( objVars[1].IsA('Pawn') )
	{
		//`log(" ChadAI - " @ objVars[1].Name @ " is NOT a controller  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );	
		
		m_DoPerformanceAtCoverData.m_HeadTrackTarget = Pawn(objVars[1]);
	}
	else
	{
		m_DoPerformanceAtCoverData.m_HeadTrackTarget = None;
	}

	//`log(" ChadAI - NPC: " @ Pawn @ " OnDoPerformanceAtCover Look at this Pawn: " @ m_DoPerformanceAtCoverData.m_HeadTrackTarget @ "  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );


	inAction.GetObjectVars(objVars,"Face This");
		
	//`log(" ChadAI - NPC: " @ Pawn @ " OnDoPerformanceAtCover Face This: " @ objVars[2] @ "  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	if( objVars[2].IsA('Controller') )
	{
		//`log(" ChadAI - " @ objVars[2].Name @ " is a controller  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

		m_DoPerformanceAtCoverData.m_BodyFacingTarget = Controller(objVars[2]).Pawn;
	}
	else if( objVars[2].IsA('Pawn') )
	{
		//`log(" ChadAI - " @ objVars[2].Name @ " is NOT a controller  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );	
		
		m_DoPerformanceAtCoverData.m_BodyFacingTarget = Pawn(objVars[2]);
	}
	else
	{
		m_DoPerformanceAtCoverData.m_BodyFacingTarget = None;
	}

	//`log(" ChadAI - NPC: " @ Pawn @ " OnDoPerformanceAtCover Face This Pawn: " @ m_DoPerformanceAtCoverData.m_BodyFacingTarget @ "  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );


	//m_DoPerformanceAtCoverData.m_BodyFacingTarget= Pawn(objVars[2]);

		
	m_DoPerformanceAtCoverData.m_bDoingPerformanceAtCover		= true;
	m_DoPerformanceAtCoverData.m_bTurnGrappleOff				= inAction.m_bTurnGrappleOff;
	m_DoPerformanceAtCoverData.m_bViolateByAngle = inAction.m_bViolateByAngle;
	m_DoPerformanceAtCoverData.m_bViolateByTakingHit = inAction.m_bViolateByTakingHit;
}

// Not to C++
function OnEndPerformanceAtCover(SeqAct_EndPerformanceAtCover inAction)
{

	if( m_bGrappled )
	{
		;
		return;
	}

 	//`log(" ChadAI - NPC: " @ Pawn.Name @ " OnEndPerformanceAtCover  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	if( m_DoPerformanceAtCoverData.m_HeadTrackTarget != None )
	{
		ForcedLookAtTarget = None;

// 		htrack = SkelControlLookAt(Pawn.Mesh.FindSkelControl('HeadTrack'));
// 
// 		htrack.SetSkelControlStrength(1.0f, 0.5f);
	}

	if( m_DoPerformanceAtCoverData.m_bTurnGrappleOff && WehrmachtPawn(Pawn) != None )
	{
		WehrmachtPawn(Pawn).bCannotGrapple       = true;
		WehrmachtPawn(Pawn).bAlwaysBreaksGrapple = false;
	}


	m_DoPerformanceAtCoverData.m_CoverToDoPerformaceAt.Link = None;
	m_DoPerformanceAtCoverData.m_CoverToDoPerformaceAt.SlotIdx = -1;
		
	m_DoPerformanceAtCoverData.m_HeadTrackTarget= None;
		
	m_DoPerformanceAtCoverData.m_BodyFacingTarget= None;

		
	m_DoPerformanceAtCoverData.m_bDoingPerformanceAtCover		= false;
	m_DoPerformanceAtCoverData.m_bTurnGrappleOff				= false;
	m_DoPerformanceAtCoverData.m_bViolateByAngle				= false;
	m_DoPerformanceAtCoverData.m_bViolateByTakingHit			= false;
}

// Not to C++
function ThrowEventForCoverViolated( CoverInfo CoverViolated )
{
	local SeqEvent_CoverViolated atEvt;
	local int idx;

	for (idx = 0; idx < Pawn.GeneratedEvents.Length; idx++)
	{
		 //`log(" ChadAI - ThrowEventForCoverViolated - GeneratedEvents.Length[" @ idx @ "]:" @ Pawn.GeneratedEvents[idx] @ " -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");	
		atEvt = SeqEvent_CoverViolated(Pawn.GeneratedEvents[Idx]);
		if (atEvt != None)
		{	
			//`log(" ChadAI - ThrowEventForCoverViolated - callin CheckIfCorrespondingCoverSlot -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
			
			atEvt.CheckIfCorrespondingCoverSlot( Pawn, Self, CoverViolated );
			//atEvt.HandleDamage(self, InstigatedBy, DamageType, BaseDamage);
		}
	}	
}

state WaitingForSceneAnimFinish
{
	ignores NotifyBump;
	
	// Not to C++
	function NotifyWeaponFired(Weapon W, byte FireMode)
	{
		//override to do nothing
	}
	
	// Not to C++
	function BeginState(Name PreviousStateName)
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		//Set the mesh render flags for scenes
		//These are set here so they happen both during scenes and matinee.  Should probably move to a better place.
		m_bIsWaitingForAnimToFinish = true;
		if( Pawn != None )
		{
			Pawn.Mesh.bUpdateSkelWhenNotRendered=true;
			Pawn.Mesh.bIgnoreControllersWhenNotRendered=false;
		}
	}

	// Not to C++
	function EndState(Name NextStateName)
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		m_bIsWaitingForAnimToFinish = false;
		if (Pawn != None)
		{
			//Set the mesh render flags for gameplay
			Pawn.Mesh.bUpdateSkelWhenNotRendered=m_bUpdateSkelWhenNotRendered;
			Pawn.Mesh.bIgnoreControllersWhenNotRendered=m_bIgnoreControllersWhenNotRendered;
		}
	}

// Not to C++
    function PushedState()
    {
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		m_bIsWaitingForAnimToFinish = true;
    }

	// Not to C++
    function PoppedState()
    {
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		m_bIsWaitingForAnimToFinish = false;
		if (Pawn != None)
		{
			//Set the mesh render flags for gameplay
			Pawn.Mesh.bUpdateSkelWhenNotRendered=m_bUpdateSkelWhenNotRendered;
			Pawn.Mesh.bIgnoreControllersWhenNotRendered=m_bIgnoreControllersWhenNotRendered;
		}    
	}

	// Not to C++
	function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " WaitingForSceneAnimFinish::NotifyTakeHit m_bViolateByTakingHit: " @ m_DoPerformanceAtCoverData.m_bViolateByTakingHit @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		if( m_DoPerformanceAtCoverData.m_bViolateByTakingHit )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " WaitingForSceneAnimFinish::NotifyTakeHit Post Cover Viloated Event-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
			ThrowEventForCoverViolated(m_DoPerformanceAtCoverData.m_CoverToDoPerformaceAt);
		}

		Super.NotifyTakeHit(InstigatedBy,HitLocation,Damage,damageType,Momentum);		
	}
	
	// Not to C++
	event Tick( float DeltaTime )
	{
		//`log(" ChadAI - NPC: " @ Pawn @ " WaitingForSceneAnimFinish Tick:  m_bViolateByAngle: " @ m_DoPerformanceAtCoverData.m_bViolateByAngle @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
	
		local float xyDot;
		UpdateHeadtracking();

		if (anode_WeaponBlend != none)
		{
			if (Pawn.Weapon == none)
				anode_WeaponBlend.SetBlendTarget(1.0, 0.2);
			else
				anode_WeaponBlend.SetBlendTarget(0.0, 0.2);
		}

		if( m_DoPerformanceAtCoverData.m_bDoingPerformanceAtCover && m_DoPerformanceAtCoverData.m_bViolateByAngle )
		{
			//`log(" ChadAI - NPC: " @ Pawn @ " WaitingForSceneAnimFinish Tick:  test m_bViolateByAngle *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

			//if( !IsAngleToEnemyValidForThisCoverSlot( m_DoPerformanceAtCoverData.m_CoverToDoPerformaceAt ) )
			if( IsEnemyOutSideOfCoversFireSector(m_DoPerformanceAtCoverData.m_CoverToDoPerformaceAt, m_DoPerformanceAtCoverData.m_BodyFacingTarget, xyDot) )
			{
				//`log(" ChadAI - Snapped to Cover - "@Pawn @ " SceneAnim Violated by enemy being out side of angle Node: " @ m_DoPerformanceAtCoverData.m_CoverToDoPerformaceAt.Link @ " slot: " @m_DoPerformanceAtCoverData.m_CoverToDoPerformaceAt.SlotIdx @"-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
				ThrowEventForCoverViolated(m_DoPerformanceAtCoverData.m_CoverToDoPerformaceAt);
			}

		}
		//Super.Tick(DeltaTime);

		// check cover angle if needed
	}

	// Not to C++
	function HandleBeingAtCover()
	{
		local SkelControlLookAt htrack;

		//`log(" ChadAI - NPC: " @ Pawn @ " WaitingForSceneAnimFinish HandleBeingAtCover:  Perform at cover: " @ m_DoPerformanceAtCoverData.m_bDoingPerformanceAtCover @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

		if( m_DoPerformanceAtCoverData.m_bDoingPerformanceAtCover )
		{
			//`log(" ChadAI - NPC: " @ Pawn @ " WaitingForSceneAnimFinish begin:  m_HeadTrackTarget: " @ m_DoPerformanceAtCoverData.m_HeadTrackTarget @ " Turn Grap Off: " @ m_DoPerformanceAtCoverData.m_bTurnGrappleOff @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

			if( m_DoPerformanceAtCoverData.m_HeadTrackTarget != None )
			{
				ForcedLookAtTarget = m_DoPerformanceAtCoverData.m_HeadTrackTarget;

				htrack = SkelControlLookAt(Pawn.Mesh.FindSkelControl('HeadTrack'));

				htrack.SetSkelControlStrength(1.0f, 0.5f);
			}

			if( m_DoPerformanceAtCoverData.m_bTurnGrappleOff && WehrmachtPawn(Pawn) != None )
			{
				WehrmachtPawn(Pawn).bCannotGrapple       = true;
				WehrmachtPawn(Pawn).bAlwaysBreaksGrapple = false;
			}

			SnapToCover( m_DoPerformanceAtCoverData.m_CoverToDoPerformaceAt, false );

			Enemy = m_DoPerformanceAtCoverData.m_BodyFacingTarget;

			m_enemyIdx = GetPlayerIdx(Enemy.Controller);

			;
		}
	}

begin:

	m_SubStateDebugInfoTag="Begin";

	//`log(" ChadAI - NPC: " @ Pawn @ " WaitingForSceneAnimFinish begin:  Perform at cover: " @ m_DoPerformanceAtCoverData.m_bDoingPerformanceAtCover @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	if( m_DoPerformanceAtCoverData.m_bDoingPerformanceAtCover )
	{
		HandleBeingAtCover();
	}

}


//should this event be in actor?
// Not to C++
native function OnPerformanceEnd(optional TPPerformance pNode);


state Parachuting
{
	// Not to C++
    function BeginState(Name PrevState)
    {
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;
        //Pawn.SetPhysics(PHYS_Flying);
		Pawn.SetPhysics(PHYS_None);
        JumpDistance = MinHitWall; // variable reuse
        MinHitWall = 1.0;          // for NotifyHitWall event when pawn is in PHYS_Flying
        bIsOnVehicle = true;       // parachute is vehicle in this case
		SetTimer(0.2f, true, 'CheckForGround');
    }

	// Not to C++
    function EndState (Name NextState)
    {
		// Hack in destroying parachute for now until we get the cloth working
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;
		if (Pawn != none)
		{
			//TPPawn(Pawn).MyParachute.Destroy();
            ParachuteMesh_Persistent(TPPawn(Pawn).MyParachute).Collapse();
			TPPawn(Pawn).MyParachute = none;
			Pawn.SetBase(none);
		    MinHitWall = JumpDistance;
			ClearYourMindFunc();
			bIsOnVehicle = false;
		}
    }

	// Not to C++
    event bool NotifyHitWall(vector HitNormal, actor Wall)
    {
        Pawn.SetPhysics(PHYS_Falling);
        return false;
    }

	// Not to C++
    event bool NotifyLanded (vector HitNormal, actor Wall)
    {
		//`log(" ChadAI - TPAIController::function NotifyLanded() GotoState('Idle') -----------------------------------------------------------------------------------");

		EvaluateSituation();

        return false;
    }

	// Not to C++
    function Tick (float DeltaTime)
    {
        FocalPoint = (20*DescentFocalPoint) + Pawn.Location;

        UpdateHeadtracking();

        ClearMove();
        //Pawn.Velocity = DescentVelocity;
    }

	// Not to C++
	function CheckForGround()
	{
		if (Pawn != none)
		{
			if (Pawn.Physics != PHYS_Falling && !FastTrace(Pawn.Location + vect(0,0,-150), Pawn.Location))
			{
				Pawn.SetPhysics(PHYS_Falling);
				ClearTimer('CheckForGround');
			}
		}
	}
}


final function bool ShouldIChangePostureInBlimpAfterTakingHit()
{
	local float chanceToSwitch;

	chanceToSwitch = RandRange(0.0, 1.0);

	//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " ShouldIChangePostureInBlimpAfterTakingHit - chanceToSwitch: " @ chanceToSwitch @ " and rate: " @ TPAssaultBlimp_Persistent(TPPawn(Pawn).Blimp).m_NPCChanceToSwitchPosturesWhenHit @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	if( chanceToSwitch<= TPAssaultBlimp_Persistent(TPPawn(Pawn).Blimp).m_NPCChanceToSwitchPosturesWhenHit )
	{
		return true;
	}

	return false;
}

function NotifyTakeHitWhileRidingInBlimp(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
{
	//`log(" ChadAI - Pawn: " @ Pawn @ " Ride_Blimp_Attack::NotifyTakeHitWhileRidingInBlimp -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	


	//`log(" ChadAI - Pawn: " @ Pawn @ " NotifyTakeHitWhileRidingInBlimp set to true Pawn.Health: " @ Pawn.Health @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

	if( Pawn != None )
	{
		if( Pawn.Health < 1 )
		{
			if( !TPPawn(Pawn).m_bNeedsToPlowIn )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " NotifyTakeHitWhileRidingInBlimp set to true Pawn.Health: " @ Pawn.Health @ " and this one will kill me but transitioning into cover so not going to die quite yet-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

				//`AILog(2, 'NotifyTakeHitWhileRidingInBlimp',"NotifyTakeHit " and this one will kill me but transitioning into cover so not going to die quite yet" );
				
				Pawn.Health = 100;
				TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet = true;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetInstigatedBy = InstigatedBy;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetHitlocation = HitLocation;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetMomentum = Vector(Pawn.Rotation) * GetDeathForceForRun() ;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetDamageType = damageType;
				TPPawn(Pawn).m_bNeedsToPlowIn = true;
				return;
			}
		}
		else
		{
			// chance to change posture
			if( m_BlimpState != BlimpWarriorState_Rappel && ShouldIChangePostureInBlimpAfterTakingHit() )
			{
				StopFiring();
				m_bNeedToSwitchBlimpPosture = true;

				if( m_BlimpAttackSubState == BlimpAttackSubState_CrouchingNotAttacking ||
					m_BlimpAttackSubState == BlimpAttackSubState_CrouchingAttacking ||
					m_BlimpAttackSubState == BlimpAttackSubState_CrouchReload)
				{
					m_BlimpAttackSubState = BlimpAttackSubState_TransitioningFromCrouchToStand; //BlimpAttackSubState_CrouchingAttacking;
				}
				else if( m_BlimpAttackSubState == BlimpAttackSubState_StandingNotAttacking ||
						m_BlimpAttackSubState == BlimpAttackSubState_StandingAttacking ||
						m_BlimpAttackSubState == BlimpAttackSubState_StandingReload)
				{
					m_BlimpAttackSubState = BlimpAttackSubState_TransitioningFromStandToCrouch;
				}

			}
		}
	}

	//`log(" ChadAI - Pawn: " @ Pawn @ " NotifyTakeHitWhileRidingInBlimp END - m_BlimpAttackSubState: " @ m_BlimpAttackSubState  @" -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

	//`log(" ChadAI - Pawn: " @ Pawn @ " NotifyTakeHitWhileRidingInBlimp; " @ InstigatedBy.Pawn @ " for DamageL " @ Damage @ " With Health: " @ Pawn.Health @ " Pawn.bIsCrouched: " @ Pawn.bIsCrouched @ " m_OpenFieldPostureSwitchingState: " @ Pawn.m_OpenFieldPostureSwitchingState @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
}

state Rappelling
{

	// Not to C++
	function BeginState(Name PreviousStateName)
	{
		 local int i;
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;
		//`log(" ChadAI - Rappelling::BeginState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		m_BlimpState = BlimpWarriorState_Rappel;

   		//`log(" ChadAI - Rappelling::PushedState called for Pawn: " @ Pawn @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
		 m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;
		if( Pawn != None )
		{
			Pawn.Mesh.RootMotionMode=RMM_Translate;
			Pawn.Mesh.RootMotionRotationMode=RMRM_RotateActor;
			Pawn.Mesh.bUpdateSkelWhenNotRendered=true;
			Pawn.SetPhysics(PHYS_None);
			Pawn.bCollideWorld=false;
			Rappel=RP_Throw;

			i = rand(2);
			if (i == 0)
				TPPawn(Pawn).PlaySceneAnimation('bb0024a_ground_mobile_stand_alert_intofastropestylea', 1);
			else
				TPPawn(Pawn).PlaySceneAnimation('bb0024d_ground_mobile_stand_alert_intofastropestyleb', 1);

			TPAssaultBlimp_Persistent(TPPawn(Pawn).Blimp).NotifyRappel(WehrmachtPawn(Pawn));
		}
	}
	
	// Not to C++
	event PausedState()
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		m_BlimpState = BlimpWarriorState_NotInBlimp;
		//`log(" ChadAI - Rappelling::PausedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	}

	// Not to C++
	event ContinuedState()
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		m_BlimpState = BlimpWarriorState_NotInBlimp;
		//`log(" ChadAI - Rappelling::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}
	
	// Not to C++
	function EndState(Name NextStateName)
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;
		m_BlimpState = BlimpWarriorState_NotInBlimp;

		if( Pawn != None )
		{
			Pawn.SetPhysics(PHYS_Walking);
			Pawn.Mesh.RootMotionMode=RMM_Ignore;
			Pawn.Mesh.RootMotionRotationMode=RMRM_Ignore;
			TPPawn(Pawn).FinishSceneAnimation();
			bIsOnVehicle=false;
			Pawn.Mesh.bUpdateSkelWhenNotRendered=false;
			Pawn.SetCollision(true, true);
	        	        
			//`log(" ChadAI - Rappelling::PoppedState calling SeqEvent_RappelFinished for Pawn: " @ Pawn @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
			Pawn.TriggerEventClass(class'SeqEvent_RappelFinished', Pawn);
		}
	}

	// Not to C++
	function NotifyWeaponFired(Weapon W, byte FireMode)
    {
		// do nothing for now
		//`log(" ChadAI - Rappelling::NotifyWeaponFired  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		

		if( m_Engagement_Tac_Data.m_bEngagingOnTheRun )
		{
			m_Engagement_Tac_Data.m_NoOfRoundsFiredThisBurst++;
		}

		StopFiring();
	}


	// Not to C++
    function PushedState()
    {
        local int i;
		;

		m_BlimpState = BlimpWarriorState_Rappel;

   		//`log(" ChadAI - Rappelling::PushedState called for Pawn: " @ Pawn @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
		 m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;
		if( Pawn != None )
		{
			Pawn.Mesh.RootMotionMode=RMM_Translate;
			Pawn.Mesh.RootMotionRotationMode=RMRM_RotateActor;
			Pawn.Mesh.bUpdateSkelWhenNotRendered=true;
			Pawn.SetPhysics(PHYS_None);
			Pawn.bCollideWorld=false;
			Rappel=RP_Throw;

			i = rand(2);
			if (i == 0)
				TPPawn(Pawn).PlaySceneAnimation('bb0024a_ground_mobile_stand_alert_intofastropestylea', 1);
			else
				TPPawn(Pawn).PlaySceneAnimation('bb0024d_ground_mobile_stand_alert_intofastropestyleb', 1);

			TPAssaultBlimp_Persistent(TPPawn(Pawn).Blimp).NotifyRappel(WehrmachtPawn(Pawn));
		}
    }

	// Not to C++
    function PoppedState()
    {
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		m_BlimpState = BlimpWarriorState_NotInBlimp;

		if( Pawn != None )
		{
			Pawn.SetPhysics(PHYS_Walking);
			Pawn.Mesh.RootMotionMode=RMM_Ignore;
			Pawn.Mesh.RootMotionRotationMode=RMRM_Ignore;
			TPPawn(Pawn).FinishSceneAnimation();
			bIsOnVehicle=false;
			Pawn.Mesh.bUpdateSkelWhenNotRendered=false;
			Pawn.SetCollision(true, true);
	        
			//ChangeKynapseEntityToActiveEntity();
			/* should not use, causes sliding
			ActivateKynapseBrain(true);
			*/
	        
			//`log(" ChadAI - Rappelling::PoppedState calling SeqEvent_RappelFinished for Pawn: " @ Pawn @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
			Pawn.TriggerEventClass(class'SeqEvent_RappelFinished', Pawn);
		}

		;
    }

	// Not to C++
    event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {
        local int i;

		if( Pawn != None )
		{

			if (SeqNode.AnimSeqName == 'bb0024a_ground_mobile_stand_alert_intofastropestylea' || 
				SeqNode.AnimSeqName == 'bb0024d_ground_mobile_stand_alert_intofastropestyleb')
			{
				i = rand(2);
				if (i == 0)
					TPPawn(Pawn).PlaySceneAnimation('bb0024b_ground_mobile_stand_alert_fastropedroploop', 0);
				else
					TPPawn(Pawn).PlaySceneAnimation('bb0024e_ground_mobile_stand_alert_fastropestylebloop', 0);
				Rappel=RP_Descent;
				Pawn.bCollideWorld=true;
				Pawn.SetPhysics(PHYS_Falling);

				TPAssaultBlimp_Persistent(TPPawn(Pawn).Blimp).NotifyDescent(WehrmachtPawn(Pawn));
			}

			if (SeqNode.AnimSeqName == 'bb0024c_ground_mobile_stand_alert_fastropeland' || 
				SeqNode.AnimSeqName == 'bb0024f_ground_mobile_stand_alert_fastropestylebland')
			{
				PopState();

				// if still here eval sit
				EvaluateSituation();
			}
		}
    }

	// Not to C++
    event bool NotifyLanded(vector HitNormal, actor Wall)
    {
        local int i;

		if( Pawn != None )
		{

			i = rand(2);
			if (i == 0)
				TPPawn(Pawn).PlaySceneAnimation('bb0024c_ground_mobile_stand_alert_fastropeland', 1);
			else
				TPPawn(Pawn).PlaySceneAnimation('bb0024f_ground_mobile_stand_alert_fastropestylebland', 1);

			TPAssaultBlimp_Persistent(TPPawn(Pawn).Blimp).NotifyLand(WehrmachtPawn(Pawn));
		}

        return false;
    }

	function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Rappelling NotifyTakeHit - InstigatedBy: " @ InstigatedBy @ "  Damage: " @ Damage @ " -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		if( Rappel==RP_Throw )
		{
			NotifyTakeHitWhileRidingInBlimp(InstigatedBy, HitLocation, Damage, damageType, Momentum);
		}
	}

	// Not to C++
    event Tick (float DeltaTime)
    {
        if (Rappel == RP_Descent && Pawn != None )
        {
            //TPPawn(Pawn).StopMovement();
            //ClearMove();
            Pawn.Velocity = vect(0,0,-500);
        }

		if (Rappel == RP_Throw && Pawn != None )
        {
			if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
			{
				if( RandRange(0.0,1.0) <= TPAssaultBlimp_Persistent(TPPawn(Pawn).Blimp).m_NPCChanceToEjectBackWardsWhenKilled )
				{
					KillTheTraveller(false);
				}
				else
				{
					KillTheTraveller(true);
				}
				PopState();
			}
		}
    }
}



state WaitingForPerformanceFinish
{
	ignores NotifyBump;

	// Not to C++
	function BeginState(Name PreviousStateName)
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;
		//`log(" ChadAI - WaitingForPerformanceFinish::BeginState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
		m_bIsWaitingForAnimToFinish = true;
	}
	
	// Not to C++
	event PausedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		//`log(" ChadAI - WaitingForPerformanceFinish::PausedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	}

	// Not to C++
	event ContinuedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		//`log(" ChadAI - WaitingForPerformanceFinish::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}


	// Not to C++
	event PoppedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;
		m_bIsWaitingForAnimToFinish = false;
		//`log(" ChadAI - WaitingForPerformanceFinish::PoppedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}
	
	function EndState(Name NextStateName)
	{
		;
		m_bIsWaitingForAnimToFinish = false;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		//`log(" ChadAI - WaitingForPerformanceFinish::EndState -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}

	// Not to C++
    function NotifyWeaponFired(Weapon W, byte FireMode)
    {
		// do nothing for now
		//`log(" ChadAI - WaitingForPerformanceFinish::NotifyWeaponFired  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
		if( m_Engagement_Tac_Data.m_bEngagingOnTheRun )
		{
			m_Engagement_Tac_Data.m_NoOfRoundsFiredThisBurst++;
		}
	}

	// Not to C++
    function PushedState()
    {
		;
		m_bIsWaitingForAnimToFinish = true;
    }
	

// 	event OnPerformanceEnd(optional TPPerformance pNode)
// 	{
// 		if( Pawn != None )
// 		{
// 			TPPawn(Pawn).FinishPerformance();
// 			
// 			//restore weapon blend node 
// 			anode_WeaponBlend = AnimNodeBlend(Pawn.Mesh.Animations.FindAnimNode('WeaponBlend'));
// 		}
// 
// 		`AILOG(2, 'WaitingForPerformanceFinish', "OnPerformanceEnd: so EvaluateSituation");
// 		
// 		EvaluateSituation();
// 	}

	// To C++
    event Tick (float DeltaTime)
    {
        local vector PawnToPlayer;
        local vector OrthoH, OrthoV;
        local float  temp;

		if (ForcedLookAtTarget != None)
		{
			;
			UpdateHeadTracking();
		}

        if (bIsOnVehicle && Pawn != None )
        {
			FindPlayerController();

            if (m_ThePlayerController != None && m_ThePlayerController.Pawn != None )
            {
                PawnToPlayer= Normal(m_ThePlayerController.Pawn.Location - Pawn.Location);
                
                // Calculate right vector
                OrthoH   = vector(Pawn.Rotation);
                temp     = OrthoH.X;
                OrthoH.X = -OrthoH.Y;
                OrthoH.Y = temp;

                // Up vector is always the same in our case
                OrthoV   = vect(0,0,1);

                Pawn.AimOffset.X = PawnToPlayer dot OrthoH;
                Pawn.AimOffset.Y = PawnToPlayer dot OrthoV;
            }
        }
    }

}

native function UpdateAimInTheOpen(bool bInVechile);


native final function SetAimToStrightAhead();


state StandWaitingForPathToClear
{

	// Not to C++
	function BeginState(Name PreviousStateName)
	{
		;
	}
	
	// Not to C++
	function EndState(Name NextStateName)
	{
		;

		m_WanderInfo.m_TimeStartedToWanderOrStandBetweenChecksForPathToClear = -1.0;
	}

	// Not to C++
    event PoppedState()
	{
		;

		m_WanderInfo.m_TimeStartedToWanderOrStandBetweenChecksForPathToClear = -1.0;
	}


	// Not to C++
	event PausedState()
	{
		;
	}

	// Not to C++
	event ContinuedState()
	{
		;
	}

	// Not to C++
	function OnSeeEnemy(int playerIdx, bool bNewEnemy)
	{
	
		//`log(" ChadAI - " @ self @ "StandWaitingForPathToClear::OnSeeEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
	
		// acquire as a new enemy and evaluate the situation
		if (CheckForEnemy(false) )
		{
		
			//`log(" ChadAI - " @ self @ "StandWaitingForPathToClear::OnSeeEnemy I am EvaluateSituation because I found an enemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
			;
			//EvaluateSituation();
			//log(self @ "My new enemy is" @ Enemy);
		}
	}
	
	// Not to C++
	event OnHearEnemy(int playerIdx)
	{
		//`log(" ChadAI - " @ self @ "StandWaitingForPathToClear::OnHearEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		
		if (CheckForEnemy(false) )
		{
			//`log(" ChadAI - " @ self @ "StandWaitingForPathToClear::OnHearEnemy I am EvaluateSituation because I found an enemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
			;
			//EvaluateSituation();
			//log(self @ "My new enemy is" @ Enemy);
		}		
	}	

	// Not to C++
	event Tick( float DeltaTime )
	{
		UpdateAimInTheOpen(FALSE);;
		UpdateHeadtracking();

		if (anode_WeaponBlend != none)
		{
			if (Pawn == none || Pawn.Weapon == none)
				anode_WeaponBlend.SetBlendTarget(1.0, 0.2);
			else
				anode_WeaponBlend.SetBlendTarget(0.0, 0.2);
		}

		Super.Tick(DeltaTime);
	}

Begin:

	m_SubStateDebugInfoTag="Begin";

	//`log(" ChadAI - " @ Pawn @ "StandWaitingForPathToClear:: Begin Time: " @ WorldInfo.TimeSeconds @ " -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

	if( m_CoverMoveData.m_CurrentCover_Clamied.Link != None )
	{
		ClearCurrentCover();
	}

	;

	m_WanderInfo.m_TimeStartedToWanderOrStandBetweenChecksForPathToClear = WorldInfo.TimeSeconds;

	while( true )
	{
		if( (WorldInfo.TimeSeconds - m_WanderInfo.m_TimeStartedToWanderOrStandBetweenChecksForPathToClear) > m_WanderInfo.m_TimeToWanderOrStandWaitingForPathOrPositionToClear )
		{
			;
			PopState();
		}
	
		if (m_WanderInfo.m_bAllowAttackWhileWaitingForPathToClear && CheckForEnemy(true) && ShouldIAttackEnemy() )
		{
			;

			PushState('Open_Field_Attack');
		}
	
		sleep(0.0);
	}
}

state StandWaitingToFollow
{

	// Not to C++
	function BeginState(Name PreviousStateName)
	{
		;
	}
	
	// Not to C++
	function EndState(Name NextStateName)
	{
		;
	}
// Not to C++
    event PoppedState()
	{
		;
	}
// Not to C++
    event PushedState()
	{
		;
	}

// Not to C++
	event PausedState()
	{
		;
	}
// Not to C++
	event ContinuedState()
	{
		;
	}

	// Not to C++
	function OnSeeEnemy(int playerIdx, bool bNewEnemy)
	{
	
		//`log(" ChadAI - " @ self @ "StandWaitingToFollow::OnSeeEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
	
		// acquire as a new enemy and evaluate the situation
		if (CheckForEnemy(false) )
		{
		
			//`log(" ChadAI - " @ self @ "StandWaitingToFollow::OnSeeEnemy I am EvaluateSituation because I found an enemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
			;
			//EvaluateSituation();
			//log(self @ "My new enemy is" @ Enemy);
		}
	}
	
	// Not to C++
	event OnHearEnemy(int playerIdx)
	{
		//`log(" ChadAI - " @ self @ "StandWaitingToFollow::OnHearEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		
		if (CheckForEnemy(false) )
		{
			//`log(" ChadAI - " @ self @ "StandWaitingToFollow::OnHearEnemy I am EvaluateSituation because I found an enemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
			;
			//EvaluateSituation();
			//log(self @ "My new enemy is" @ Enemy);
		}		
	}	

	// Not to C++
	event Tick( float DeltaTime )
	{
		UpdateAimInTheOpen(FALSE);;
		UpdateHeadtracking();

		if (anode_WeaponBlend != none)
		{
			if (Pawn == none || Pawn.Weapon == none)
				anode_WeaponBlend.SetBlendTarget(1.0, 0.2);
			else
				anode_WeaponBlend.SetBlendTarget(0.0, 0.2);
		}
		Super.Tick(DeltaTime);
	}

Begin:

	m_SubStateDebugInfoTag="Begin";

	//`log(" ChadAI - " @ Pawn @ "StandWaitingToFollow:: Begin Time: " @ WorldInfo.TimeSeconds @ " -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");


	while( true )
	{

		if(		 m_Follow_Data.ActorToFollow == None || 
				(TPPawn(m_Follow_Data.ActorToFollow).Controller) == None || 
				!m_Follow_Data.m_bContinueToFollow || 
				(TPPawn(m_Follow_Data.ActorToFollow).Controller).IsInState('Dead'))
		{
			;

			PopState();
		}
		else if( VSizeSq( m_Follow_Data.ActorToFollow.Location - Pawn.Location ) > ( m_Follow_Data.m_FollowBandMaxRange * m_Follow_Data.m_FollowBandMaxRange ) )
		{
			;

			PopState();
		}
		else if( Enemy != None )
		{
			;

			PopState();
		}
	
		sleep(0.0);
	}
}


state Idle
{
	// Not to C++
	function BeginState(Name PreviousStateName)
	{
		// clear any left-overs
		ClearEnemy();
	}


	// Not to C++
	event Tick( float DeltaTime )
	{
		UpdateHeadtracking();
		
		if (anode_WeaponBlend != none)
		{
			if (Pawn.Weapon == none)
				anode_WeaponBlend.SetBlendTarget(1.0, 0.2);
			else
				anode_WeaponBlend.SetBlendTarget(0.0, 0.2);
		}
		//Super.Tick(DeltaTime);
	}

Begin:

	m_SubStateDebugInfoTag="Begin";

	while( true )
	{
		StopFiring();
		sleep(0.0);
	}

}

native final function bool TestForValidPursueTarget();
native final function PursueEnemyTickLogic();


state PursueEnemy
{
	ignores NotifyBump;

	// Not to C++
	function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " PursueEnemy::NotifyTakeHit m_bTookHitWhilePursuing set to true -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		m_MultiTierEngagementInfo.m_bTookHitWhilePursuing = true;

		Super.NotifyTakeHit(InstigatedBy,HitLocation,Damage,damageType,Momentum);		
	}

	// Not to C++
	event PoppedState()
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " PursueEnemy::PoppedState -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		;
		KynapseClear();
		m_Engagement_Tac_Data.m_bSideSteping = false;

		if (Pawn != None)
		{
			Pawn.SetMovementType( MovementType_Default );

			Pawn.MaxDesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
			Pawn.DesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
		}
	}

	// Not to C++
	event PausedState()
	{
		;
		//`log(" ChadAI - Pawn: " @ Pawn @ " PursueEnemy::PausedState and m_bInteruptedWhileLookingForPath -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		m_MultiTierEngagementInfo.m_bInteruptedWhileLookingForPath = true;
	}

	// Not to C++
	function OnSeeEnemy(int playerIdx, bool bNewEnemy)
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " PursueEnemy::OnSeeEnemy -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		CheckForEnemy(false);

		if (!HasValidEnemy())
		{
			;
			KynapseClear();
			//PopState();
		}
		else if (!m_Engagement_Tac_Data.m_bSideSteping)
		{
			// We check for Tac Step in the case of LOS to Enemy but not LOF.

			if( m_Engagement_Tac_Data.m_bAllowTacticalSteping )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " PursueEnemy::OnSeeEnemy Testing For Tac move against curent enemy " @ Enemy @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

				m_Engagement_Tac_Data.m_MoveNeed2Kill = GetRequiredMovementForEngagement(	Enemy,
																							Vector(Pawn.Rotation), 
																							m_Engagement_Tac_Data.m_SideStepTargetMoveLoc,
																							false);


				if( m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_Travel )
				{
					;
					//`log(" ChadAI - Pawn: " @ Pawn @ " PursueEnemy::OnSeeEnemy enemy " @ Enemy @ "can be tactically enaged so end pursue for now move needed to Kill: " @ m_Engagement_Tac_Data.m_MoveNeed2Kill @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
					
					m_MultiTierEngagementInfo.m_bSawEnemyWhilePursuing = true;

					if( m_Engagement_Tac_Data.m_MoveNeed2Kill == RequiredMove4Engage_None )
					{
						;

						m_Engagement_Tac_Data.m_bSideSteping = false;
					}
					else
					{
						;

						m_Engagement_Tac_Data.m_bSideSteping = true;
					}

					// may not want to clear just pause movement by turning brain off
					KynapseClear();
				}
			}
			else
			{
				m_MultiTierEngagementInfo.m_bSawEnemyWhilePursuing = true;
				;

				// Only stop pursuing if has both LOS and LOF
 				if( CanFireAtNotFromCover(Enemy, true) )
				{
					KynapseClear();

				}
			}

			//PopState();
		}

	}


	// Not to C++
	function EndState(Name NextStateName)
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " TPAIController::PursueEnemy::EndState  NextStateName: " @ NextStateName @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		;
		m_Engagement_Tac_Data.m_bSideSteping = false;
		KynapseClear();

		if (Pawn != None)
		{
			Pawn.SetMovementType( MovementType_Default );

			Pawn.MaxDesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
			Pawn.DesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
		}
	}

	// Not to C++
	event ContinuedState()
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " TPAIController::PursueEnemy::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		;
	
	}


	// To C++
	event Tick( float DeltaTime )
	{
		PursueEnemyTickLogic();

		UpdateAimInTheOpen(FALSE);;
		UpdateHeadtracking();
		Super.Tick(DeltaTime);
	}



Begin:

	m_SubStateDebugInfoTag="Begin";

	//`log(" ChadAI - Pawn: " @ Pawn @ " PursueEnemy:KynapseGoToward moving to Enemy: " @ Enemy @ "  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	
	m_CQB_Data.m_NoOfTimesWaitedForCheckForCQB = 0;
	m_MultiTierEngagementInfo.m_bTookHitWhilePursuing = false;
	m_MultiTierEngagementInfo.m_bSawEnemyWhilePursuing = false;

	//m_MultiTierEngagementInfo.m_LastEnemyTriedToPursue = Enemy;

   ClearCurrentCover(); // just in case

PursueEnemyLoop:

	m_Engagement_Tac_Data.m_bSideSteping = false;

	//`log(" ChadAI - Pawn: " @ Pawn @ " PursueEnemy:KynapseGoToward moving to Enemy: " @ Enemy @ "  TOP OF THE LOOP -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	if( m_MultiTierEngagementInfo.m_LastEnemyTriedToPursue == Enemy )
	{
		m_MultiTierEngagementInfo.m_NumTimesTriedToPursueSameEnemy = m_MultiTierEngagementInfo.m_NumTimesTriedToPursueSameEnemy + 1;
	}
	else
	{
		m_MultiTierEngagementInfo.m_LastEnemyTriedToPursue = Enemy;
		m_MultiTierEngagementInfo.m_NumTimesTriedToPursueSameEnemy = 1;
	}

	// new hottness
	m_MultiTierEngagementInfo.m_bInteruptedWhileLookingForPath = false;

	if( Enemy != None )
	{
		KynapseGoTowardFindPath(Enemy.Controller, 250);
	}
	else
	{
		;
		Goto('EndPursue');
	}

	if( m_MultiTierEngagementInfo.m_bInteruptedWhileLookingForPath )
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ "PursueEnemy:Main Loop m_bInteruptedWhileLookingForPath so look for path again -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	}
	else if ( KynapseFoundPath() )
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ "PursueEnemy: KynapseFoundPath so KynapseFollowPath-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		if (Pawn.bIsCrouched)
		{
			m_SubStateDebugInfoTag="Pursue UnCrouching";

			m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange = WorldInfo.TimeSeconds;
			if( Pawn != None && TPPawn(Pawn) != none )
			{
				Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_GoingToStanding;
			}

			// OpenFieldPostureSwitchingState_GoingToCrouching
			while(	(Pawn.bIsCrouched && Pawn != None && TPPawn(Pawn) != none) ||
					(Pawn != None && TPPawn(Pawn) != none && Pawn.m_OpenFieldPostureSwitchingState != OpenFieldPostureSwitchingState_NotSwitching ) )
			{
				Pawn.UnCrouch();
				Sleep(0.0);
				if( !Pawn.bIsCrouched && ( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange) >= 
											class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_MaxTimeToWaitForToStandPostureChangeToFinish ) )
				{
					;
					Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_NotSwitching;
					break;
				}
			}		
		}

		m_SubStateDebugInfoTag="Pursue Moving";


		KynapseFollowPath(); // follow the found path 

		//`log(" ChadAI - Pawn: " @ Pawn @ "PursueEnemy: back from KynapseFollowPath Enemy: " @ Enemy @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


		if( Enemy == None )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " PursueEnemy:back from KynapseFollowPath No More Enemy so need to end purse -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			;

			Goto('EndPursue');
		}
 
		//`log(" ChadAI - Pawn: " @ Pawn @ "PursueEnemy: KynapseFollowPathcompletted so lets see of arrived m_NumTimesTriedToPursueSameEnemy: " @ m_MultiTierEngagementInfo.m_NumTimesTriedToPursueSameEnemy @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		if( m_MultiTierEngagementInfo.m_bSawEnemyWhilePursuing )
		{

			if( m_Engagement_Tac_Data.m_bAllowTacticalSteping &&
				m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_Travel &&
				m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_None )
			{
				m_Engagement_Tac_Data.m_bSideSteping = true;

				;

				//`log(" ChadAI - Pawn: " @ Pawn @ " PursueEnemy:back from KynapseFollowPath and need to side step -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				
				Goto('SideStep');
			}

			;

			m_Engagement_Tac_Data.m_bSideSteping = false;

			Goto('EndPursue');

			m_MultiTierEngagementInfo.m_bSawEnemyWhilePursuing = false;

			// if still here need to purse again

			//`log(" ChadAI - Pawn: " @ Pawn @ "PursueEnemy: still here after EvaluateSituation so still needs to purse -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


		}
		else if( DetermineIfShouldStartCQB_Latent( WorldInfo.TimeSeconds ) ) // add a flag so I do not have to do this
		{
			PushState('CloseQuartersBattleAttack');
		}
		else if ( KynapseHasArrived() )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ "PursueEnemy: KynapseFollowPathcompletted and KynapseHasArrived so EvaluateSituation -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			;
			Goto('EndPursue');
			// if still here need to purse again
			//`log(" ChadAI - Pawn: " @ Pawn @ "PursueEnemy: still here after EvaluateSituation so still needs to purse -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		}
		else if( m_MultiTierEngagementInfo.m_NumTimesTriedToPursueSameEnemy >= 8 )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ "PursueEnemy: have not arrived and pursued the same guy to many time so lets wander around a little -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			//Pawn.DesiredSpeed = 0.5;
			//KynapseWander(20.0f); 
			
			m_MultiTierEngagementInfo.m_bSawEnemyWhilePursuing = false;

			if( Enemy == None )
			{
				;
				Goto('EndPursue');;
			}

			;

			m_WanderInfo.m_TimeToWanderOrStandWaitingForPathOrPositionToClear = m_MultiTierEngagementInfo.m_TimeToWanderWhileWaitingForTarget;
			m_WanderInfo.m_bAllowAttackWhileWaitingForPathToClear = true;
			
			
			if( m_WanderInfo.m_bAllowIdleWander )
			{
				PushState('WanderAround');
			}
			else
			{
				PushState('StandWaitingForPathToClear');
			}

			//`log(" ChadAI - Pawn: " @ Pawn @ "PursueEnemy: back from wander -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			if( m_MultiTierEngagementInfo.m_bSawEnemyWhilePursuing )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ "PursueEnemy: back from wander and saw enemy with good LOS so lets kill this guy -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				
				if( Enemy != None )
				{
					;
				}
				else
				{
					;
				}

				Goto('EndPursue');
			}
			else
			{
				if( Enemy != None )
				{
					;
				}
				else
				{
					;
					Goto('EndPursue');
				}

			}

		}
		else
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ "PursueEnemy: have not arrived so let try pursing again -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		}

	} // end kynapse found path
	else
	{
		//`warn(" ChadAI - Pawn: " @ Pawn @ " PursueEnemy:Kynapse failed to find a path to Enemy: " @ Enemy @ " so try going to Multi tier engagement stuff-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		if( Enemy == None )
		{
			;
			Goto('EndPursue');
		}

		if( CanFireAtNotFromCover(Enemy, true) )
		{
			//`log(" ChadAI - PursueEnemy Can Fire At");
			//`log("PursueEnemy Did not move far enough but has LOS so attacking-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
			;
			Goto('EndPursue');
		}
		else
		{
			//`log(" ChadAI - PursueEnemy Can NOT Fire At try to find cover to go to to shoot from");
			//`warn("PursueEnemy Kynapse failed to find a path and Does not have LOS so going to try Multi Tier Attack -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
			;

			//make DCWH not crash
			Sleep(0.0);
			PushState('MultiTierAttackUsingCoverGoal');
			
			//sleep(5.0);
		}
	}
	Goto('PursueEnemyLoop');

	//`log(" ChadAI - Pawn: " @ Pawn @ " PursueEnemy No More Enemy so poping state -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

EndPursue:

	m_Engagement_Tac_Data.m_bSideSteping = false;

	if( m_HighLevelAiGoal != HighLevelAiGoal_NONE )
	{
		PopState();
	}

	EvaluateSituation();

	Goto('Begin');

SideStep:

	//`log(" ChadAI - Pawn: " @ Pawn @ " PursueEnemy-SideStep build path to side step -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	/* FIX_STEP: test the new KynapseCanGoStraight function
	// would really like to know path length to test against instead
	//KynapseGoToFindPath( m_Engagement_Tac_Data.m_SideStepTargetMoveLoc );
	//if ( KynapseFoundPath() )
	*/
	if ( KynapseCanGoStraight( m_Engagement_Tac_Data.m_SideStepTargetMoveLoc ) )
	{

		m_SubStateDebugInfoTag="Slice The Pie";

		if( Enemy == None )
		{
			Target = None;
			;
			Goto('EndPursue');
		}

		//`log(" ChadAI - Pawn: " @ Pawn @ " PursueEnemy-SideStep found path to side step so start stepping -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		;

		Target = Enemy;

		Focus = Target;

		DesiredRotation = rotator(Focus.Location - Pawn.Location);
		DesiredRotation.Pitch = 0;

		
			TP_AiStartFiring();
		



		KynapseClear();

		Pawn.SetMovementType(MovementType_Default);

		Pawn.MaxDesiredSpeed	=	class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_SliceThePieTacStepSpeedFactor;
		Pawn.DesiredSpeed		=	class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_SliceThePieTacStepSpeedFactor;


		MoveTo(m_Engagement_Tac_Data.m_SideStepTargetMoveLoc, Enemy);

		if( Enemy == None )
		{
			;
			Goto('EndPursue');
		}

		//Pawn.Velocity = vect(0,0,0); // MoveTo affects velocity & acceleration
		StopThisBot(); // MoveTo affects velocity & acceleration
		//KynapseClear();

		if (Pawn != None)
		{
			Pawn.SetMovementType( MovementType_Default );

			Pawn.MaxDesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
			Pawn.DesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
		}



		m_Engagement_Tac_Data.m_MoveNeed2Kill = GetRequiredMovementForEngagement(	Enemy,
																					Vector(Pawn.Rotation), 
																					m_Engagement_Tac_Data.m_SideStepTargetMoveLoc,
																					false);


		if( Enemy != None && 
			m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_Travel &&
			m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_None )
		{
			;

			Goto('SideStep');
		}

		m_Engagement_Tac_Data.m_bSideSteping = false;
		//`log(" ChadAI - Pawn: " @ Pawn @ " PursueEnemy - SideStep back from MoveTo we made it and return to attack -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		Goto('EndPursue');
	}

	if( Enemy == None )
	{
		;
		Goto('EndPursue');
	}

	//`log(" ChadAI - Pawn: " @ Pawn @ " PursueEnemy-SideStep did not find path to side step so back to loop -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	;

	InvalidateThisSliceThePieTacStepLocation(m_Engagement_Tac_Data.m_MoveNeed2Kill);

	m_Engagement_Tac_Data.m_MoveNeed2Kill = GetRequiredMovementForEngagement(	Enemy,
																				Vector(Pawn.Rotation), 
																				m_Engagement_Tac_Data.m_SideStepTargetMoveLoc,
																				false);


	if( Enemy != None && 
		m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_Travel &&
		m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_None )
	{
		;
		Goto('SideStep');
	}

	m_Engagement_Tac_Data.m_bSideSteping = false;
	Goto('EndPursue');
}

native final function bool TestForValidWanderTarget();
native final function bool TestForValidAttackFromCoverTarget();

state WanderAround
{
	ignores NotifyBump;


	// Not to C++
    function NotifyWeaponFired(Weapon W, byte FireMode)
    {
		StopFiring();
    }

	// Not to C++
	function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " WanderAround::NotifyTakeHit m_bTookHitWhilePursuing set to true -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		m_MultiTierEngagementInfo.m_bTookHitWhilePursuing = true;

		if( IsValidEnemyController(InstigatedBy, TRUE) )
		{
			//`log(" ChadAI - SENSING - Pawn: " @Pawn@" WanderAround::NotifyTakeHit InstigatedBy: " @ InstigatedBy.Pawn @ " and is an Enemy Duh so test for LOS -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");		
			if( CanFireAtNotFromCover( InstigatedBy.Pawn, true ) )
			{
				;
				//`log(" ChadAI - SENSING - Pawn: " @Pawn@" WanderAround::NotifyTakeHit InstigatedBy: " @ InstigatedBy.Pawn @ " and is an Enemy and has LOS so make current enemy and end wander -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");		
				Enemy = InstigatedBy.Pawn;
				m_enemyIdx = GetPlayerIdx(Enemy.Controller);
				m_MultiTierEngagementInfo.m_bSawEnemyWhilePursuing = true;
			}
			else
			{
				;

				//`log(" ChadAI - SENSING - Pawn: " @Pawn@" WanderAround::NotifyTakeHit InstigatedBy: " @ InstigatedBy.Pawn @ " and is an Enemy but does not have LOS so end wander and freak out -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");		
			}
		}

		KynapseClear();

		Super.NotifyTakeHit(InstigatedBy,HitLocation,Damage,damageType,Momentum);		
	}

	// Not to C++
	event PoppedState()
	{
		;

		m_WanderInfo.m_TimeStartedToWanderOrStandBetweenChecksForPathToClear = -1.0;

		if( Pawn != None )
		{
			Pawn.DesiredSpeed = 1.0;
			Pawn.MaxDesiredSpeed	= 1.0;
		}

		m_WanderInfo.m_bAllowAttackWhileWaitingForPathToClear = false;


		m_WanderInfo.m_CurrentGoalWanderSpeed = m_WanderInfo.m_DefaultWanderSpeed;
		m_WanderInfo.m_TimeToWanderOrStandWaitingForPathOrPositionToClear = -1.0;

		KynapseClear();

		//`log(" ChadAI - Pawn: " @ Pawn @ " WanderAround::PoppedState -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	}

	// Not to C++
	function EndState(Name NextStateName)
	{

		;

		m_WanderInfo.m_TimeStartedToWanderOrStandBetweenChecksForPathToClear = -1.0;

		if( Pawn != None )
		{
			Pawn.DesiredSpeed = 1.0;
			Pawn.MaxDesiredSpeed	= 1.0;
		}

		m_WanderInfo.m_bAllowAttackWhileWaitingForPathToClear = false;

		m_WanderInfo.m_CurrentGoalWanderSpeed = m_WanderInfo.m_DefaultWanderSpeed;
		m_WanderInfo.m_TimeToWanderOrStandWaitingForPathOrPositionToClear = -1.0;

		KynapseClear();

	}

	// Not to C++
	event PausedState()
	{
		;

		if( Pawn != None )
		{
			Pawn.DesiredSpeed = 1.0;
			Pawn.MaxDesiredSpeed	= 1.0;
		}
		//`log(" ChadAI - Pawn: " @ Pawn @ " WanderAround::PausedState -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	}

	// Not to C++
	function OnSeeEnemy(int playerIdx, bool bNewEnemy)
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " WanderAround::OnSeeEnemy bNewEnemy: " @ bNewEnemy @ " Time: " @ WorldInfo.TimeSeconds @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		CheckForEnemy(false);
		
		if ( Enemy != None )
		{
			if ( !m_Engagement_Tac_Data.m_bSideSteping )
			{
				m_Engagement_Tac_Data.m_MoveNeed2Kill = GetRequiredMovementForEngagement(	Enemy,	
																							Vector(Pawn.Rotation), 
																							m_Engagement_Tac_Data.m_SideStepTargetMoveLoc,
																							false);

				if( m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_Travel )
				{
					;
					//`log(" ChadAI - Pawn: " @ Pawn @ " WanderAround::OnSeeEnemy enemy can be tactically enaged so end wander for now move needed to Kill: " @ m_Engagement_Tac_Data.m_MoveNeed2Kill @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
					
					m_MultiTierEngagementInfo.m_bSawEnemyWhilePursuing = true;

					KynapseClear();
				}
				else
				{
					;
				}
				//PopState();
			}
			else
			{
				;
			}
		}
		else
		{
			;
		}
	}
	
	// Not to C++
	// is only called when the heared player in a new enemy
	event OnHearEnemy(int playerIdx)
	{
		//`log(" ChadAI - SENSING - " @ self @ "WanderAround::OnHearEnemy Time: " @ WorldInfo.TimeSeconds @ "-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
		
		CheckForEnemy(false);
		if ( Enemy != None )
		{
			if ( !m_Engagement_Tac_Data.m_bSideSteping )
			{
				m_Engagement_Tac_Data.m_MoveNeed2Kill = GetRequiredMovementForEngagement(	Enemy,
																							Vector(Pawn.Rotation), 
																							m_Engagement_Tac_Data.m_SideStepTargetMoveLoc,
																							false );

				if( m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_Travel )
				{
					;
					//`log(" ChadAI - Pawn: " @ Pawn @ " WanderAround::OnSeeEnemy enemy can be tactically enaged so end wander for now move needed to Kill: " @ m_Engagement_Tac_Data.m_MoveNeed2Kill @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
					
					m_MultiTierEngagementInfo.m_bSawEnemyWhilePursuing = true;

					KynapseClear();
				}
				else
				{
					;
				}
				//PopState();
			}
			else
			{
				;
			}

		}
		else
		{
			;
		}
		
	}


	// Not to C++
	event ContinuedState()
	{
		;

		//`log(" ChadAI - Pawn: " @ Pawn @ " TPAIController::WanderAround::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		StopFiring();	
	}

	// To C++
	event Tick( float DeltaTime )
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " TPAIController::WanderAround::Tick   -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		if ( !m_Engagement_Tac_Data.m_bSideSteping )
		{
			if( TestForValidWanderTarget() )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " TPAIController::WanderAround::Tick   TestForValidWanderTarget = true -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
				;
				m_MultiTierEngagementInfo.m_bSawEnemyWhilePursuing = true;
				KynapseClear();
			}
		}

		if( Self.IsA('TPSoldierAIController') )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " TPAIController::WanderAround::Tick   Self.IsA('TPSoldierAIController') so UpdateAim-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

			if( Enemy != None && m_Engagement_Tac_Data.m_bSideSteping )
			{
				TPSoldierAIController(Self).UpdateAimInTheOpen(FALSE);;
			}
		}
		UpdateHeadtracking();

		if (anode_WeaponBlend != none)
		{
			if (Pawn.Weapon == none)
				anode_WeaponBlend.SetBlendTarget(1.0, 0.2);
			else
				anode_WeaponBlend.SetBlendTarget(0.0, 0.2);
		}

		Super.Tick(DeltaTime);
	}

Begin:

	m_SubStateDebugInfoTag="Begin";

	//`log(" ChadAI - Pawn: " @ Pawn @ " WanderAround::Begin -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	if (Pawn.bIsCrouched)
	{
		m_SubStateDebugInfoTag="Wander UnCrouching";


		m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange = WorldInfo.TimeSeconds;

		if( Pawn != None && TPPawn(Pawn) != none )
		{
			Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_GoingToStanding;
		}

		// OpenFieldPostureSwitchingState_GoingToCrouching
		while(	(Pawn.bIsCrouched && Pawn != None && TPPawn(Pawn) != none) ||
				(Pawn != None && TPPawn(Pawn) != none && Pawn.m_OpenFieldPostureSwitchingState != OpenFieldPostureSwitchingState_NotSwitching ) )
		{
			Pawn.UnCrouch();
			Sleep(0.0);

			if( !Pawn.bIsCrouched && ( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange) >= 
										class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_MaxTimeToWaitForToStandPostureChangeToFinish ) )
			{
				;
				Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_NotSwitching;
				break;
			}
		}		
	}

   m_Engagement_Tac_Data.m_bSideSteping = false;

   ClearCurrentCover();

   SetAimAndHeadTrack();

	m_CQB_Data.m_NoOfTimesWaitedForCheckForCQB = 0;
	m_MultiTierEngagementInfo.m_bTookHitWhilePursuing = false;
	m_MultiTierEngagementInfo.m_bSawEnemyWhilePursuing = false;

	//m_MultiTierEngagementInfo.m_LastEnemyTriedToPursue = Enemy;

	StopFiring();

	while(true)
	{
		if( Enemy == None )
		{
			Pawn.DesiredSpeed = m_WanderInfo.m_CurrentGoalWanderSpeed;
			Pawn.MaxDesiredSpeed	= m_WanderInfo.m_CurrentGoalWanderSpeed;
		}

		//if( m_moveGoalInfo.m_TimeStartedToWaitForPathToClear > 0.0f )
		if( m_WanderInfo.m_TimeToWanderOrStandWaitingForPathOrPositionToClear > 0.0f )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " start KynapseWander for: " @ m_WanderInfo.m_TimeToWanderOrStandWaitingForPathOrPositionToClear @ " :: Because waiting for path or psotion to clear -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			m_WanderInfo.m_TimeStartedToWanderOrStandBetweenChecksForPathToClear = WorldInfo.TimeSeconds;

			KynapseWander(m_WanderInfo.m_TimeToWanderOrStandWaitingForPathOrPositionToClear);
		}
		else
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " start KynapseWander:: NOT Because of waiting for a path. wander time: " @ m_WanderInfo.m_DefaultIdleWanderTime @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			KynapseWander(m_WanderInfo.m_DefaultIdleWanderTime);
		}

		Pawn.DesiredSpeed = 1.0;
		Pawn.MaxDesiredSpeed	= 1.0;


		;
		
		if( m_WanderInfo.m_bAllowAttackWhileWaitingForPathToClear && (m_MultiTierEngagementInfo.m_bSawEnemyWhilePursuing || m_MultiTierEngagementInfo.m_bTookHitWhilePursuing) )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " WanderAround::Begin m_bSawEnemyWhilePursuing so popping state -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			if( m_MultiTierEngagementInfo.m_bSawEnemyWhilePursuing && m_MultiTierEngagementInfo.m_bTookHitWhilePursuing )
			{
				;
			}	
			else if( m_MultiTierEngagementInfo.m_bSawEnemyWhilePursuing )
			{
				;
			}
			else
			{
				;
			}

			// check to see if can tackical move and is needed before returning to parent state

			if( m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_Travel &&
				m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_None )
			{
				m_Engagement_Tac_Data.m_bSideSteping = true;

				;

				//`log(" ChadAI - Pawn: " @ Pawn @ " WanderAround:back from KynapseFollowPath and need to side step -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				
				Goto('SideStep');
			}

			if( m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_Travel )
			{
				;
				Goto('EndWander');
			}
		}
		else if( m_WanderInfo.m_TimeToWanderOrStandWaitingForPathOrPositionToClear > 0.0f )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " WanderAround::Begin back from KynapseWander and wandering because because waiting for path or position to clear and all wander time has passed so lets go back and see if we have a path -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			;
			Goto('EndWander');
		}

		Sleep(0.0f);
	}


SideStep:

	if ( KynapseCanGoStraight( m_Engagement_Tac_Data.m_SideStepTargetMoveLoc ) )
	{
		m_SubStateDebugInfoTag="Slice The Pie";

		//`log(" ChadAI - Pawn: " @ Pawn @ " WanderAround-SideStep found path to side step so start stepping -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		;

		Target = Enemy;

		Focus = Target;

		DesiredRotation = rotator(Focus.Location - Pawn.Location);
		DesiredRotation.Pitch = 0;

		
			TP_AiStartFiring();
		





		Pawn.SetMovementType(MovementType_Default);

		Pawn.MaxDesiredSpeed	=	class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_SliceThePieTacStepSpeedFactor;
		Pawn.DesiredSpeed		=	class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_SliceThePieTacStepSpeedFactor;

		KynapseClear();
		MoveTo(m_Engagement_Tac_Data.m_SideStepTargetMoveLoc, Enemy);

		//Pawn.Velocity = vect(0,0,0); // MoveTo affects velocity & acceleration
		StopThisBot(); // MoveTo affects velocity & acceleration
		//KynapseClear();


		if (Pawn != None)
		{
			Pawn.SetMovementType( MovementType_Default );

			Pawn.MaxDesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
			Pawn.DesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
		}


		m_Engagement_Tac_Data.m_MoveNeed2Kill = GetRequiredMovementForEngagement(	Enemy,
																					Vector(Pawn.Rotation), 
																					m_Engagement_Tac_Data.m_SideStepTargetMoveLoc,
																					false );


		if( Enemy != None && 
			m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_Travel &&
			m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_None )
		{
			;

			Goto('SideStep');
		}

		m_Engagement_Tac_Data.m_bSideSteping = false;
		//`log(" ChadAI - Pawn: " @ Pawn @ " WanderAround - SideStep back from MoveTo we made it and return to attack -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		Goto('EndWander');
	}

	;

	InvalidateThisSliceThePieTacStepLocation(m_Engagement_Tac_Data.m_MoveNeed2Kill);

	m_Engagement_Tac_Data.m_MoveNeed2Kill = GetRequiredMovementForEngagement(	Enemy,
																				Vector(Pawn.Rotation), 
																				m_Engagement_Tac_Data.m_SideStepTargetMoveLoc,
																				false);


	if( Enemy != None && 
		m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_Travel &&
		m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_None )
	{
		;
		Goto('SideStep');
	}

	m_Engagement_Tac_Data.m_bSideSteping = false;
	Goto('EndWander');

	//Goto('Begin');

EndWander:

	if( m_HighLevelAiGoal != HighLevelAiGoal_NONE )
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " In Wander Loop and I either saw someone or got shot, Goal: " @ m_HighLevelAiGoal @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		;

		PopState();
	}


	// if still here
	;

	EvaluateSituation();

	Sleep(0.0);

	Goto('Begin');

}


native final function bool EnemyIsInRange( float range );

//-----------------------------------------------------------------------
// State:
// Description:	the inevitable state of any AI
//				called from PawnDied() function
//-----------------------------------------------------------------------

state Dead
{
Begin:
	m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;
	m_SubStateDebugInfoTag="Begin";
	// nuke ourselves
	Destroy();
}

// Not to C++
simulated function Destroyed()
{
	// clear cover
	ClearReservedCover();
	ClearCurrentCover();
	// remove ourself from the squad
	SetSquad(None);

	Super.Destroyed();
}


//***********************************************************************
// AI STATES
//************************ - END SECTION - ******************************


