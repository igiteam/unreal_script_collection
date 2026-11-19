/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAI extends GameAIController
	native(AI)
	dependson(GearPawn)
	dependson(GearTypes)
	dependson(GearSquad)
	dependson(Vehicle_Jack_Base)
	config(AI);

cpptext
{
	virtual void PreBeginPlay();

	virtual FGuid* GetGuid() { return &MyGuid; }

	virtual UBOOL ShouldCheckVisibilityOf(AController* C);
	virtual void AdjustHearingLocation(FVector &out_Location);

	virtual UBOOL IsPlayerOwner()
	{
		return FALSE;
	}

	virtual UBOOL WantsLedgeCheck();

	virtual FVector DesiredDirection()
	{
		return Pawn->Velocity;
	}

	virtual void    ModifyPawnVelocity( FLOAT DeltaTime );
	virtual void    GetFlockAvoidForce( FVector& AvoidForce );
	virtual void    GetFlockGroupForce( FVector& AvoidForce );
	virtual void    GetFlockMatchVelForce( FVector& AvoidForce );
	virtual void    GetFlockPathForce( FVector& PathForce );

	virtual void	UpdatePawnRotation();
	virtual void	ShowSelf(){/*SILENCE! (handled with async visiblity, see AIVisibilityManager)*/}
	virtual DWORD	SeePawn( APawn *Other, UBOOL bMaySkipChecks = TRUE );
	virtual void	ProcessSightCheckResult( APawn* Other, UBOOL bVisible, FVector& VisLoc );
	virtual UBOOL   CanHear(const FVector& NoiseLoc, FLOAT Loudness, AActor *Other);

	virtual void	RouteCache_Empty();
	virtual void	RouteCache_AddItem( ANavigationPoint* Nav );
	virtual void	RouteCache_InsertItem( ANavigationPoint* Nav, INT Idx );
	virtual void	RouteCache_RemoveItem( ANavigationPoint* Nav );
	virtual void	RouteCache_RemoveIndex( INT Index, INT Count );

	virtual void ClearCrossLevelPaths(ULevel *Level);


	UBOOL Tick( FLOAT DeltaTime, enum ELevelTick TickType );


	virtual void GetLookDir(FVector& LookDir);
	virtual FRotator SetRotationRate(FLOAT DeltaTime);
	virtual FLOAT GetRoadieRunRotationRateModifier(){ return 0.33f; }

	virtual UBOOL ShouldOffsetCorners() { return FALSE; }
	virtual UBOOL ShouldUsePathLanes() { return FALSE; }

	virtual void FailMove();

	virtual UBOOL ShouldIgnoreNavigationBlockingFor(const AActor* Other);

	// overrides of NavigationInterface
	virtual UBOOL CanCoverSlip(ACoverLink* Link, INT SlotIdx);
	// --

	virtual FLOAT GetMaxDropHeight();

	virtual void SetupPathfindingParams( FNavMeshPathParams& out_ParamCache );
	virtual void InitForPathfinding();
	virtual INT ExtraEdgeCostToAddWhenActive();
}

enum EPerceptionMood
{
	AIPM_None,
	AIPM_Normal,
	AIPM_Alert,
	AIPM_Unaware,
	AIPM_Oblivious,
};
var() EPerceptionMood PerceptionMood;

enum ECombatMood
{
	AICM_None,
	AICM_Normal,
	AICM_Passive,
	AICM_Aggressive,
	AICM_Ambush,
};
var() ECombatMood CombatMood;

enum EAIMoveMood
{
	AIMM_None,
	AIMM_Normal,
	AIMM_WithCover,
	AIMM_Fast,
};
var() EAIMoveMood MovementMood;


struct native LocalEnemyInfo
{
	/** Enemy is currently visible (within 2 secs of last actually seen) */
	var bool	bVisible;
	/** Enemy was seen last frame - no time buffer */
	var bool	bSeenLastFrame;

	/** Enemy pawn */
	var Pawn	Pawn;

	/** Time this enemy was initially marked  visible */
	var float	InitialVisibleTime;
	/** Last time enemy was actually seen */
	var float	LastVisibleTime;
	/** Used to set location info after an async visibility check */
	var Vector	AsyncVisibleLocation;

	/** Last time we failed to find a path to this enemy */
	var float	LastFailedPathTime;

	/** Rating this AI has given to the enemy (for sorting who he wants to attack) */
	var float	Rating;

	/** Used for Berserker */
	var byte	FootStepCount;
	var float	LastFootStepTime;
};
var array<LocalEnemyInfo> LocalEnemyList;

/** Chance AI should play an initial reaction animation when they first spot enemies - passed from AI factory */
var float	PlayIntialCombatReactionChance;

/** Factory that was used to create this AI */
var SeqAct_AIFactory SpawnFactory;

/** List of targets to shoot at */
var array<Actor>			TargetList;
/** List of targets to not shoot at */
var array<Actor>			ProhibitedTargetList;
/** Current turret this AI is using */
var Turret CurrentTurret;
/** Last turret this AI used */
var Turret LastTurret;
/** Should the AI ignore flanking when using the turret? */
var bool bIgnoreFlank;

/** The Siegebeast the AI is trying to enter */
var Vehicle_Siegebeast_Base CurrentSiegebeast;

/** Which seat we should take on the Siegebeast */
var int CurrentSiegebeastSeat;

/** The Silverback the AI is trying to enter */
var GearPawn_SilverbackBase CurrentSilverback;
/** Currently active Silverback Get Crate action */
var SeqAct_AISilverbackGetCrate SilverbackCrateAction;

/** Does the AI want a ledge check? */
var bool bWantsLedgeCheck;

/**
 * Last time we had contact with an enemy.  We use this to perhaps destroy ourselves
 * or teleport to the player (if we are an ai team mate).
 ***/
var float TimeLastHadContactWithEnemy;
/** Last time we threw a grenade */
var float LastGrenadeTime;
/** Multiplier to use grenades for this AI */
var config float GrenadeChanceScale;
/** chance to drop a grenade when going DBNO while grenades are equipped */
var config float GrenadeMartyrChance;
/** Amount of time it takes AI to aim current weapon */
var float WeaponAimDelay;


/** AI will skew towards enemies threatening these target */
var array<Actor>  ProtectTargetList;

/** If true, this AI is in cinematic mode */
var transient bool bCinematicMode;

/** Various enemy distances used in evaluating combat actions */
var config float EnemyDistance_Short;
var config float EnemyDistance_Medium;
var config float EnemyDistance_Long;
var config float EnemyDistance_Melee;
/** if this is non-zero we will roll the dice when inside this range and maybe charge our enemy and melee (useful for chainsaws! )*/
var config float EnemyDistance_MeleeCharge;
/** Distance limit for noticing grenade bounce */
var config float GrenAwarnessDistance;
var config float GrenAwarnessDelay;
/** maximum number of bursts to fire when firing from cover; if <= 0, do not use burst fire when firing from cover */
var int MaxFireFromCoverBursts;

var const config float FriendlyDistance_Medium;

/** Minimum amount of time to have seen enemy before getting bonus to select enemy */
var config float Response_MinEnemySeenTime;
var config float Response_MinEnemyHearTime;
var config float Response_MinEnemyHurtTime;
var config float Response_EnemyTooLongNoSeeTime;

var bool bAlwaysHear;

/** Actor we are retreating from */
var Actor	FearActor;
/** Location that we are fleeing from */
var Vector	FearLocation;
/** Actor we are shooting at */
var Actor	FireTarget;

//// SQUAD ACTION VARIABLES /////
/** Squad this AI should follow */
var GearSquad Squad;
/** AI doesn't actually occupy a position in the squad formation */
var bool	  bIgnoreSquadPosition;
/** Backup variable for temporarily altering squad membership. */
var transient protected Name SavedSquadName;

//// FLOCKING VARIABLES /////
/** Set to true if AI is using flocking movement */
var bool bUseFlockingMovement;
/** If true, flocking forces will zero out the Z component */
var() bool bOnlyPlanarFlocking;
/** Radius to keep flock members spaced apart */
var() config float FlockAvoidanceRadius;
/** Force to apply for avoiding other flock members */
var() config float AvoidOtherStrength;
/** Force to apply for staying with the flock */
var() config float GroupAttractionStrength;
/** How aggressively an agent matches the speed of its neighbors */
var() config float MatchVelStrength;
/** Force to apply toward next path destination when moving away from it */
var() config float FollowPathRadius;
/** Force to apply toward next path destination when moving away from it */
var() config float FollowPathStrength;
/** Flocking avoidance force used during last update */
var transient vector LastAvoidOtherForce;
/** Time of last update to flocking avoidance force */
var transient float LastAvoidForceUpdateTime;



/** Pct chance to try active reload */
var() config float	ActiveReloadAttemptPct;
/** Pct of sweet success for active reload */
var() config float	ActiveReloadSweetPct;
/** Pct of jam $ure for active reload */
var() config float ActiveReloadJamPct;
/** when wielding a weapon that does active cooling, whether the AI does so when not firing */
var() config bool bPerformActiveCooling;

/** Current move goal/point/focus */
var Actor	MoveGoal;
var BasedPosition MovePosition;
var Actor	MoveFocus;
/** Acceptable distance offset from the goal */
var float	MoveOffset;
/** Should we roadie run when moving? */
var bool bShouldRoadieRun;
/** Current step aside goal, for StepAside state */
var Pawn StepAsideGoal;
/** Distance to attempt to step aside when bumping into other players */
var const float MaxStepAsideDist;
/** Last time obstruction of path was detected */
var float LastObstructionTime;
/** Last time we researched for a destination after a delay */
var float LastDetourCheckTime;
/** Extra cost to add to nav points that are along my path (as route cache is filled) */
var float ExtraPathCost;
/** When continues into move state, should re-eval anchor/path */
var bool bReevaluatePath;
/** AI should not update route cache - flag to prevent cache from being changed when pathing is used to evaluate squad location */
var bool bSkipRouteCacheUpdates;
var float MaxPathLaneValue;
var float CurrentPathLaneValue;

/** Distance within which an intermediate goal is considered reached */
var const float IntermediatePointArrivalDist;
/** Was MoveGoal successfully reached */
var bool bReachedMoveGoal;
var bool bMoveGoalInterruptable;
/** Currently moving to a goal */
var bool bMovingToGoal;
/** Currently moving to cover */
var	bool bMovingToCover;
/** Currently moving along a route */
var bool bMovingToRoute;
var Route ActiveRoute;
/** Currently moving to tether */
var bool bMovingToTether;
/** Has reached tetehr? */
var bool bReachedTether;
/** Has a melee attack on the command stack */
var bool bDoingMeleeAttack;


/** Time at which we transitioned to the current action */
var float LastActionTransitionTime;
/** Next time flank combat action is allowed */
var float NextFlankAllowedTime;
/** Last time we took damage or were shot at */
var float LastShotAtTime;
/** Last world time that the freakout animation was played */
var	transient float	LastSecondaryActionTime;
/** Last time we started check for transition animation loop */
var	transient float	LastAnimTransitionTime;
/** Actor we are searching/moving toward */
var Actor	SearchTarget;
/** Point we want to search to */
var Vector	SearchPoint;
/** Time that last search cycle was started */
var float	SearchStartTime;
/** Time which we started peeking */
var float	LastPeekTime;

/** Damage received while in the current action */
var float DamageReceivedInAction;
/** Last time damage was evaluated during this action */
var float LastDamageReceivedTime;
/** Min time between damage received evaluations */
var config float MinDamageReceivedTime;
/** Chance AI will pull back into cover if shot while poping out */
var config float ChanceToCoverUnderFire;
/** Chance AI will evade away from danger (ie player aiming at them) */
var config float ChanceToEvade;
/** Chance AI will react to a grenade about to explode and evade */
var config float ChanceToEvadeGrenade;
/** Chance to play flank reaction animation before changing combat action */
var config float ChanceToBeSuprisedByFlank;
/** minimum amount of time between full body hit reactions (the ones that prevent performing actions) - <= 0.0 disables them */
var config float MinFullBodyHitReactionInterval;

/** Is the weapon allowed to fire? */
var bool bWeaponCanFire;
/** how many bursts should we fire? -1 means infinite */
var int DesiredBurstsToFire;

/** how close a missed shot needs to be for the AI to care about it */
var float AI_NearMissDistance;

// Base Accuracy values
/** World time that we selected this target to shoot at
	(only updates when target switches) */
var	float TargetAquisitionTime;

/** Accuracy: Standing */
var()	config float		AI_Base_Acc_Standing;
/** Accuracy: Blind firing */
var()	config float		AI_Base_Acc_BlindFire;
/** Accuracy modifier: targeting mode */
var()	config float		AI_Base_Acc_Target;

// Accuracy modifiers
/** Accuracy modifier: moving */
var()	config float		AI_mod_Acc_Move;
/** Accuracy modifier: enemy moving */
var()	config float		AI_mod_Acc_TargMove;
/** Accuracy modifier: evading (added on top of moving) */
var()	config float		AI_mod_Acc_Evade;
/** Accuracy modifier: Enemy has been visible a short amount of time */
var()	config float		AI_mod_Acc_BriefVisibility;
/** Accuracy modifier: Enemy has been aquired a short amount of time */
var()	config float		AI_mod_Acc_BriefAcquire;
/** accuracy modifier: enemy is holding a boomer shield or meat shield */
var() config float AI_mod_Acc_Shield;

// Accuracy Range Modifiers
var()	config float		AI_modrng_Short;
var()	config float		AI_modrng_Medium;
var()	config float		AI_modrng_Long;

/** Accuracy forced by SeqAct_AISetTarget */
var transient  float		ForcedAccuracy;

/** Is this AI allowed to land head shots? */
var()	config bool			bCanHeadshot;

/** Minimum distance between mantles */
var()	config float		MinDistBetweenMantles;
/** whether we should avoid mantling when idle (out of combat) */
var bool bAvoidIdleMantling;

/** is this AI allowed to execute DBNO enemies? */
var bool bCanExecute;
/** is this AI allowed to revive DBNO friendlies? */
var bool bCanRevive;
/** If true, the AI can move while DBNO */
var bool bAllowDBNOCrawl;
/** whether the AI should check for vehicles to drive in its main combat loop */
var bool bCheckForVehicles;


// TETHER
/** Actor/Position we are tethered to */
var BasedPosition TetherPosition;

/** Desired tether distance, which TetherDistance will set back to when valid */
var float DesiredTetherDistance;
/** Dynamic tether distance */
var float TetherDistance;
/** Time the tether should persist */
var float TetherPersistDuration;
/** Time at which the AI acquired the tether */
var transient float TetherAcquireTime;
/** Is this a dynamic (ie moving) tether? */
var bool bDynamicTether;
/** Latent move action, activate output upon reaching goal */
var SeqAct_AIMove MoveAction;
/** Are we currently moving to our squad leader? */
var bool bMovingToSquadLeader;
/** Squad leader positon when we last checked if we should move */
var Vector LastSquadLeaderPosition;
var float LastMoveToSquadLeaderTime;
/** Keep tether actor when moving back into Idle transition */
var bool bKeepTether;
/** Is the current tether actor our cover goal? */
var bool bTetherIsCoverGoal;
/** Should we teleport to the tether in case we fail to reach it? */
var bool bTeleportOnTetherFailure;
/** Is this a spawn tether that shouldn't be interrupted? */
var bool bSpawnerTetherInterruptable;

/** Transient flag set when the AI failed to find a firing line, and failed to find any other nearby cover */
var bool bFailedToFireFromCover;
var bool bFailedToFireFromOpen;
var bool bFailedToMoveToEnemy;

// FIRE TICKET VARIABLES
var bool	bUseFireTickets;

//debug
var(Debug) config bool bDrawAIDebug;
var(Debug) config bool bDrawAIDebug_Range;
var(Debug) config bool bDrawAIDebug_Enemy;

var Vector	Debug_ViewLoc;
var Vector	Debug_EnemyViewLoc;
Var Vector	Debug_LookDir;
var Rotator Debug_StepRot;
var BasedPosition	Debug_StepLoc;
var(Debug) float DebugSearchRadius;
var(Debug) Vector DebugSearchLocation;


/** Current emergence special move to use, specific to SubAction_Emerge */
var ESpecialMove EmergeSpecialMove;

/** Is the AI allowed to perform combat transitions? */
var bool bAllowCombatTransitions;

/** The distance a shot must be closer than to invoke the StumbleDown from being shot at close range SpecialMove**/
var config float StumbleDownFromCloseRangeShotDistance;

/** delay after a pawn goes down before the AI will consider executing it */
var config float ExecuteDelay;
/** delay after a pawn goes down before the AI will consider reviving it */
var config float ReviveDelay;

/** Actor used for cover searching via FindCover/FindSquadPosition */
var transient Actor		SearchGoalActor;
/** Helper var for searching for squad position */
var transient int		SearchIndex;

var ESpecialMove QueuedSpecialmove;
var Actor SpecialMoveAlignActor;

var GearPawn MyGearPawn;

/////// COMBAT ZONE VARIABLES ///////
/** Combat zone AI will consider itself in next tick
	Helps fix the issue of Anchors being changed multiple times in a single frame */
var CombatZone			PendingCombatZone;
/** Current combat zone the AI is acting within */
var CombatZone			CurrentCombatZone;

/** List of combat zones available for evaluation of this AI */
var array<CombatZone>	CombatZoneList;
/** AI is currently within a combatzone that is in it's list (TRUE if list is empty) */
var bool				bInValidCombatZone;

/////// COVER VARIABLES ///////
/** Have we reached the cover? */
var			bool			bReachedCover;
/** Should hide in cover */
var			bool			bTurtle;


/** when TRUE 'hasvalidtarget' will always return true */
var bool bForceHasValidTarget;

enum EAcquireCoverType
{
	ACT_None,			// No desire to move to new cover
	ACT_Immediate,		// Immediately seek new cover (ie cover has been flanked/can't fire on any enemies)
	ACT_DesireBetter,	// Try to find better cover than current (based on CoverRating)
};
/** Should the AI acquire new cover */
var	EAcquireCoverType	AcquireCover;



/** Default Combat Command we should move into when spotting an enemy */
var class<AICommand> DefaultCommand;
/** command we should use when we want to pursue and melee an enemy */
var class<AICmd_Base_Melee> MeleeCommand;

/** Reaction manager that keeps a list of reactions and channel subscriptions **/
var instanced AIReactionManager ReactionManager;
/** List of reactions to init right away (note these should be initialized via begin object in the default props).. this gives you a chance to change defaults on the reactions**/
var instanced array<AIReactCondition_Base> DefaultReactConditions;
/** List of classes of reactions to create and add, use this if you don't need to modify default props **/
var array< class<AIReactCondition_Base> > DefaultReactConditionClasses;

/** whether this AI is capable of melee attacks */
var bool bCanMelee;
/** whether this AI is primarily a melee attacker, and will melee if possible */
var bool bPreferMelee;
/** should we ignore stepasidefor calls? **/
var bool bIgnoreStepAside;
var float LastFailedToFindStepAsideLocation;
/** whether this controller should be destroyed if the Pawn we're possessing dies */
var bool bDestroyOnPawnDeath;
/** if we have nothing else to do, find the nearest enemy (even if the AI doesn't know about it!) and move there
 * used in e.g. Invasion to make sure the AI doesn't end up wandering in a corner of the map with no enemies
 */
var bool bIdleMoveToNearestEnemy;
/** if set, force this AI to be friendly to both Locust and Lambent teams regardless of its own team */
var bool bFriendlyToLocustAndLambent;


/** weapon a designer has forced us to use (mean old designers!) */
var Weapon ForcedWeapon;

/** GUID for checkpoint saved AIs so that references to them can be saved even though they will be recreated */
var Guid MyGuid;

/** if this is on, we will delete ourselves when we haven't been rendered, or seen any guys in a long time */
var bool bDeleteWhenStale;
/** amount of time since doing anything interesting we should delete ourselves */
var() float StaleTimeout;

/** base AI aim error for all weapons */
var config float BaseAimError;
/** range of interval between aiming updates */
var config vector2d AimUpdateInterval;

/** current offset from base Location of FireTarget for weapon aiming (includes aim error) */
var vector CurrentAimLocationOffset;
/** next time we will update CurrentAimLocationOffset */
var float NextAimUpdateTime;

/** modifier to rotation rate whenever not already modified by a special move */
var float RotationRateMultiplier;

/** multiplier to "basic" movement speed (no special move or roadie run) */
var float BasicMovementMultiplier;

/** bool indicating we're being forced to fire, and we shouldn't check LOS before firing */
var() bool bForceFire;

/** whether the AI should actually use the cover slip move or just fake it
 * by moving the correct amounts so that the reachspecs aren't unusable
 */
var bool bCanUseCoverSlipMove;

/** move action loaded from checkpoint, delayed application to wait for Kismet serialization */
var SeqAct_AIMove PendingCheckpointMoveAction;

/** TRUE if this AI is berzerk, meaning it will attack teammates (everyone is an enemy). */
var bool bBerzerk;


struct ReaverCheckpointData
{
	var bool bHasData;
	var string FlightPaths[16];
	var string InitialFlightPath;
	var float CurrentInterpTime;
	var int CurrentFlightIndex;
	var bool bAllowLanding;
	var name InitialFlightPathGroupName;
};

struct CheckpointRecord
{
	var Guid SavedGuid;
	var float PawnHealthPct;
	var string PawnClassName;
	var string RidableClassName; // when driving a GearPawnRidable_Base, the Pawn being driven
	var string PawnPathName; // used when Pawn at save time was a level placed actor
	var string MutatedClassName;
	var vector Location;
	var rotator Rotation;
	var string BasePathName;
	var byte TeamIndex;
	var string SquadName;
	var EPerceptionMood PerceptionMood;
	var ECombatMood CombatMood;
	var string SlotPathName;
	var int	   SlotIdx;
	var array<InventoryRecord> InventoryRecords;
	var bool bIsLeader;
	var bool bCanDBNO;
	var bool bForceShowInTaccom;
	var bool bAllowCombatTransitions;
	var string MoveActionPathName;
	var string SquadRoutePathName;
	var string MountedFaceFX[3];
	var string KismetAnimSets[2];
	var string KismetAnimTree;
	/** Reaver data has to be here because we don't support different CheckpointRecord struct for subclasses */
	var ReaverCheckpointData ReaverRecord;
	/** as above, for Jack */
	var EJackSpotlightSetting JackSpotlightSetting;
	var bool bJackSpotlightOn;
	var bool bJackHidden;
	/** same, for turrets */
	var string DrivenTurretPathName;
	var int PlayerSlotIndex; // index in GearGameSP_Base's PlayerSlots array, for managing playerpawn classes
	var string PlayerName; // name in PRI
	/** Stores the stage of the fight that the Tempest is in at checkpoint time */
	var int TempestStage;
};

// last time a move command was completed
var float LastMoveFinishTime;


/** true when we've triggered a banzai reaction already so don't do it any more! */
var bool bHasBanzaiReTriggers;

/** cached version of CommandList that's an AICommand (instead of GameAICommand) */
var AICommand CachedAICommandList;

native final function DumpPathConstraints();

/**
 * =========================
 * GENERAL NATIVE FUNCTIONS
 * =========================
 */

/**
 * PushCommand
 * pushes a new AI command on top of the command stack
 * @param NewCommand - command to place on top of stack
 */
native function PushCommand(GameAICommand NewCommand);

/**
 * PopCommand
 * will pop the passed command (and everything above it in the stack)
 * @param ToBePoppedCommand - the command to pop
 */
native function PopCommand(GameAICommand ToBePoppedCommand);

/** AbortCommand
* Aborts a command (and all of its children)
* @param AbortCmd - the command to abort (can be NULL, in which case AbortClass will be used to determine which command to abort
* @param AbortClass - not used unless AbortCmd is NULL, in which case the first command int he stack of class 'AbortClass' will be aborted (and all its children)
*/
native function bool AbortCommand( GameAICommand AbortCmd, optional class<GameAICommand> AbortClass );


native final function bool GetNavigationPointsNear( vector ChkLocation, float ChkDistance, out array<NavigationPoint> nodes );


protected function RecordDemoAILog( coerce string LogText )
{
	`if(`notdefined(FINAL_RELEASE))
	local GearDemoRecSpectator DemoSpec;

	// send the AI log output to the demo spectator so the AILog can be reconstructed from the demo playback
	foreach WorldInfo.AllControllers(class'GearDemoRecSpectator', DemoSpec)
	{
		DemoSpec.RecordAILog(self, LogText);
	}

	`endif
}

//debug
final function DebugLogRoute()
{
`if(`notdefined(FINAL_RELEASE))
	local int i;
	`AILog( "Print Route...", 'Route' );
	for( i = 0; i < RouteCache.Length; i++ )
	{
		`AILog( ">>> Route Idx"@i@RouteCache[i], 'Route' );
	}
	if( RouteCache.Length == 0 )
	{
		`AILog( ">>> Empty Route", 'Route' );
	}
`endif
}


/** Util for drawing debug text, which will wrap to a new column when it goes off the bottom of the screen */
function DrawDebugText(GearHUD_Base H, String Text)
{
	local float XL, YL;

	if( H.Canvas.CurY >= H.Canvas.SizeY * 0.95f )
	{
		H.Canvas.SetPos(H.Canvas.CurX + DebugTextMaxLen + 8.f, H.Canvas.SizeY * 0.05f);
		DebugTextMaxLen = 0.f;
	}

	H.Canvas.StrLen(Text, XL, YL);
	if( XL > DebugTextMaxLen )
	{
		DebugTextMaxLen = XL;
	}

	H.Canvas.DrawText(Text,,,,H.Text_NoClipShadowed);
}

simulated function DrawDebug( GearHUD_Base HUD, name Category, optional bool bSpecificDebug )
{
	local Texture2D Icon;
	local Gearpawn GP;
	local GearWeaponPawn GWP;
	local int i;
	local vector tmp;
	local rotator rot;
	local int CmdCnt;
	local Canvas Canvas;
	local GameAICommand Cmd;
	local String Text;
	local AICmdHistoryItem Item;

	HUD.Canvas.Font = class'Engine'.static.GetSmallFont();
	if( Category == 'Default')
	{
		Icon = Texture2D'EditorResources.S_NavP'; //@warning: will not exist on console due to cooking out of editor stuff
		DrawIconOverhead(HUD, Icon);

		// PURPLE
		DrawDebugLine( Pawn.GetPawnViewLocation(), GetFocalPoint(), 184, 152, 250 );
		if( Focus != None )
		{
			// ORANGE
			DrawDebugLine( Pawn.GetPawnViewLocation(), Focus.Location, 255, 128, 0 );
		}
	}

	if( bDrawAIDebug )
	{
		if( CommandList != None )
		{
			CommandList.DrawDebug( HUD, Category );
		}

		if( Category == 'Pathing' && Pawn.Anchor != None )
		{
			// RED
			DrawDebugLine( Pawn.Location, Pawn.Anchor.Location + vect(0,0,15), 255, 0, 0 );
		}

		if( Category == 'enemy' && Enemy != None )
		{
			DrawDebugLine( Pawn.GetPawnViewLocation() + vect(0,0,10), GetEnemyLocation(,LT_InterpVisibility), 255, 255, 128 );
		}

		if( Category == 'rotation' )
		{
			DebugDrawWorldRotation(HUD);
		}

/*
		if (FireTarget != None)
		{
			DrawDebugLine(MyGearPawn.GetWeaponStartTraceLocation(), MyGearPawn.GetWeaponStartTraceLocation() + vector(GetAdjustedAimFor(MyGearPawn.Weapon,MyGearPawn.GetWeaponStartTraceLocation())) * 1024.f, 255, 255, 0);
		}
*/
/*
		if( DebugSearchRadius > 0 )
		{
			if( SearchTarget != None )
			{
				// PURPLE
				DrawDebugLine( Pawn.Location, DebugSearchLocation, 184, 152, 250 );
				DrawDebugLine( DebugSearchLocation, SearchTarget.Location, 184, 152, 250 );
				DrawDebugCylinder( DebugSearchLocation, DebugSearchLocation, DebugSearchRadius, 10.f, 184, 152, 250 );
			}
			else
			if( SearchPoint != vect(0,0,0) )
			{
				// PURPLE
				DrawDebugLine( Pawn.Location, DebugSearchLocation, 184, 152, 250 );
				DrawDebugLine( DebugSearchLocation, SearchPoint, 184, 152, 250 );
				DrawDebugCylinder( DebugSearchLocation, DebugSearchLocation, DebugSearchRadius, 10.f, 184, 152, 250 );
			}
		}

*/
		if( Category == 'enemy' && !IsZero(Debug_ViewLoc)  )
		{
			// WHITE + COORD SYSTEM
			DrawDebugLine( Debug_ViewLoc, Debug_EnemyViewLoc, 255, 255, 255 );
			DrawDebugCoordinateSystem( Debug_ViewLoc, Rotator(Debug_LookDir), 64.f );

			DrawDebugBox( Debug_ViewLoc, vect(5,5,5), 0, 255, 0 );
			DrawDebugBox( Debug_EnemyViewLoc, vect(5,5,5), 255, 0, 0 );
			DrawDebugLine( Debug_ViewLoc, Debug_ViewLoc + Debug_LookDir * 255, 128, 52, 0 );
		}


		if( Category == 'squad')
		{
			if(GetSquadLeader() == self)
			{
				// I'm the leader, draw mine yellow
				DrawDebugCylinder(Pawn.Location,Pawn.Location,25.f,3,255,255,0);
			}

			if( !bIgnoreSquadPosition && !IsZero(GetSquadPosition()) && GetIdealSquadPosition(tmp))
			{
				// white line to ideal
				DrawDebugLine(Pawn.Location,tmp,255,255,255);
				// white at ideal
				DrawDebugCylinder(tmp,tmp,50.f,6,255,255,255);
				// grey line from ideal to actual
				DrawDebugLine(tmp,GetSquadPosition(),200,200,200);

			}

			DrawDebugCoordinateSystem(Squad.GetSquadCentroid(),rot(0,0,0),50.f);

		}


		if( Category == 'weapon' )
		{
			DrawDebugCylinder( Pawn.Location, Pawn.Location, EnemyDistance_Melee,	8, 255, 255, 255 );
			DrawDebugCylinder( Pawn.Location, Pawn.Location, EnemyDistance_Short,	8, 0,	255, 0	 );
			DrawDebugCylinder( Pawn.Location, Pawn.Location, EnemyDistance_Medium,	8, 0,	0,	 255 );
			DrawDebugCylinder( Pawn.Location, Pawn.Location, EnemyDistance_Long,	8, 255, 0,	 0	 );
		}

		if(Category == 'visibility')
		{
			GWP = GearWeaponPawn(Pawn);
			if( MyGearPawn != None && MyGearPawn.SightBoneName != '' )
			{
				Pawn.Mesh.GetSocketWorldLocationAndRotation(MyGearPawn.SightBoneName,tmp,rot,0);
			}
			else if( GWP != None )
			{
				rot = GWP.GetBaseAimRotation();
			}
			DrawDebugLine(Pawn.GetPawnViewLocation(),Pawn.GetPawnViewLocation()+vector(rot)*200.f,255,255,0 );
			foreach Squad.AllEnemies( class'GearPawn', GP )
			{
				if(IsEnemyVisible(GP))
				{
					DrawDebugLine(Pawn.GetPawnViewLocation(),GP.GetPhysicalFireStartLoc( vect(0.f,0.f,0.f) ),255,0,0);
				}
				else
				{
					DrawDebugLine(Pawn.GetPawnViewLocation(),GP.GetPhysicalFireStartLoc( vect(0.f,0.f,0.f) ),0,255,0);
				}
			}
		}

		if(Category == 'sightcone')
		{
			GWP = GearWeaponPawn(Pawn);
			if( MyGearPawn != None && MyGearPawn.SightBoneName != '' )
			{
				Pawn.Mesh.GetSocketWorldLocationAndRotation(MyGearPawn.SightBoneName,tmp,rot,0);
			}
			else if( GWP != None )
			{
				tmp = GWP.GetPawnViewLocation();
				rot = GWP.GetBaseAimRotation();
			}
			DrawDebugCone(tmp,vector(rot),Pawn.SightRadius,Acos(Pawn.PeripheralVision), Acos(Pawn.PeripheralVision),16,MakeColor(255,0,0,255));

		}

		if(Category == 'combatzones')
		{
			for(i=0; i<CombatZoneList.length;i++)
			{
				DrawDebugLine(Pawn.Location, CombatZoneList[i].BrushComponent.Bounds.Origin,255,0,0);
				DrawDebugBox(CombatZoneList[i].BrushComponent.Bounds.Origin,CombatZoneList[i].BrushComponent.Bounds.BoxExtent,255,0,0);
			}
		}

		if(Category == 'showleashed')
		{
			if(!AllowedToMove())
			{
				DrawDebugBox(Pawn.Location,pawn.GetCollisionExtent(),255,0,0);
			}
		}

		if(Category == 'destination' && NavigationHandle.GetPathCacheLength() > 0)
		{
			DrawDebugLine(Pawn.Location,BP2Vect(NavigationHandle.FinalDestination),255,255,0);
		}


		if(Category == 'movepoint' && NavigationHandle.GetPathCacheLength() > 0)
		{
			DrawDebugLine(Pawn.Location,BP2Vect(DestinationPosition),255,255,0);
		}

		// Draw list of commands down the side of the screen
		if( bSpecificDebug && Pawn != None )
		{
			Canvas = HUD.Canvas;
			Canvas.Font = class'Engine'.Static.GetTinyFont();
			Canvas.SetDrawColor(225, 0, 0, 255);
			Canvas.SetPos(Canvas.SizeX * 0.05f, Canvas.SizeY * 0.05f);

			DrawDebugText( HUD, String(self) );

			// WRITE OUT COMMAND STACK
			Canvas.SetDrawColor(255, 255, 255, 255);
			DrawDebugText( HUD, "************************************************************" );
			Canvas.SetDrawColor(0, 0, 255, 255);
			DrawDebugText( HUD, "COMMAND STACK" );
			foreach AllCommands( class'GameAICommand', Cmd )
			{
				if( Cmd.ChildCommand == None )
				{
					Canvas.SetDrawColor(225, 0, 0, 255);
				}
				else
				{
					Canvas.SetDrawColor(0, 255, 0, 255);
				}
				DrawDebugText( HUD, String(Cmd.Name) );
				Text = Cmd.GetDebugVerboseText();
				if( Len(Text) > 0 )
				{
					DrawDebugText( HUD, ".........."@Text );
				}
				CmdCnt++;
			}
			if( CmdCnt == 0 )
			{
				DrawDebugText( HUD, "NO COMMANDS ACTIVE" );
			}

			// WRITE OUT COMMAND HISTORY
			Canvas.SetDrawColor(255, 255, 255, 255);
			DrawDebugText( HUD, "************************************************************" );
			Canvas.SetDrawColor(0, 0, 255, 255);
			DrawDebugText( HUD, "COMMAND HISTORY (Count:"@CommandHistoryNum$")" );
			CmdCnt = 0;
			foreach CommandHistory( Item )
			{
				CmdCnt++;
				Canvas.SetDrawColor(255, 0, 0, 255);
				DrawDebugText( HUD, "Cmd"@CmdCnt$":"@String(Item.CmdClass)@"Time:"@Item.TimeStamp);
				if( Len(Item.VerboseString) > 0 )
				{
					Canvas.SetDrawColor(255, 64, 64, 255);
					DrawDebugText( HUD, ".............."@Item.VerboseString );
				}
			}
		}
	}
}


simulated function DrawIconOverhead(GearHUD_Base HUD, Texture2D Icon)
{
	local GearPC	PC;
	local Canvas	Canvas;
	local Vector	CameraLoc, ScreenLoc;
	local Rotator	CameraRot;
	local String	Str;
	local float		X, Y, HealthPct;
	local float     EnemyDist;

	PC = GearPC(HUD.PlayerOwner);
	Canvas = HUD.Canvas;
	Canvas.SetDrawColor(255,255,255);

	// project location onto the hud
	PC.GetPlayerViewPoint( CameraLoc, CameraRot );
	ScreenLoc = Canvas.Project( Pawn.Location + vect(0,0,1) * Pawn.GetCollisionHeight() * 1.5f );
	if (Icon != None)
	{
		Canvas.SetPos(ScreenLoc.X - Icon.SizeX / 2, ScreenLoc.Y - Icon.SizeY / 2);
		Canvas.DrawTexture(Icon, 1.f);
		X = ScreenLoc.X + Icon.SizeX/2 + 5;
		Y = ScreenLoc.Y - Icon.SizeY/2;
	}
	else
	{
		X = ScreenLoc.X;
		Y = ScreenLoc.Y;
	}

	Canvas.SetDrawColor(255,255,255);

	Canvas.SetPos( X, Y );
	Str = "#"$GetRightMost(self);
	if (GearPRI(PlayerReplicationInfo) != None)
	{
		Str = Str@GearPRI(PlayerReplicationInfo).SquadName;
		if( GetSquadLeader() == self )
		{
			Str = Str@"(L)";
		}
	}
	Canvas.DrawText( Str, TRUE );

	if( bDrawAIDebug )
	{
		if( Enemy != None )
		{
			EnemyDist = VSize(Pawn.Location - Enemy.Location);
		}

		Canvas.DrawText( (MyGearPawn != None ? String(MyGearPawn.SpecialMove) : "") @ GetActionString(), TRUE);
		Canvas.DrawText( PerceptionMood@CombatMood@MovementMood, TRUE );
		Canvas.DrawText( "Focus:" @ Focus @ "DistFromEnemy:" @ EnemyDist );
		Canvas.DrawText( "LastPathError"@NavigationHandle.LastPathError@"("$`timesince(NavigationHandle.LastPathFailTime)$")", TRUE );
	}

	if (CurrentTurret != None)
	{
		Canvas.DrawText("Turret:"@CurrentTurret,TRUE);
		Canvas.DrawText("FireTarget:"@FireTarget,TRUE);
	}

	AddExtraOverheadInfo( HUD );

	Canvas.SetDrawColor(0,255,0);
	HealthPct = GetHealthPercentage();
	Canvas.DrawTile(Texture2D'WhiteSquareTexture',64.f * HealthPct,4,0,0,2,2);
	Canvas.SetDrawColor(255,0,0);
	//Canvas.SetPos(Canvas.CurX + HealthPct * 64.f,Canvas.CurY);
	Canvas.DrawTile(Texture2D'WhiteSquareTexture',64.f * (1.f - HealthPct),4,0,0,2,2);

	Canvas.SetDrawColor(255,255,255);
}

simulated function AddExtraOverheadInfo( GearHUD_Base HUD );

/**
 * Draw 3D rotation information : Character name on top of head and rotation coordinate and cylinder
 */
final simulated function DebugDrawWorldRotation(GearHUD_Base HUD)
{
	local Vector	CameraLoc, ScreenLoc;
	local Rotator	CameraRot;
	local Canvas	Canvas;

	Canvas = HUD.Canvas;
	GearPC(HUD.PlayerOwner).GetPlayerViewPoint( CameraLoc, CameraRot );
	ScreenLoc = Canvas.Project( Pawn.Location + vect(0,0,1) * Pawn.GetCollisionHeight() * 1.5f );
	Canvas.SetDrawColor(255,255,255);

	// Draw character name
	Canvas.SetPos( ScreenLoc.X - 5, ScreenLoc.Y - 5 );
	// I'd like to get only right most of name without GearAI_ (=Len 7)
	Canvas.DrawText( "#"$Right(Class, Len(Class)-7)$":"$GetRightMost(self), TRUE );

	// when pawn and mesh is available and when rendered
	if ( GearPawn(Pawn)!=none )
	{
		GearPawn(Pawn).DrawDebugRotation();
	}
}

/**
 * Draw 2D Rotation Debug Text information on the Canvas at start of out_YPos
 * Canvas	: Canvas to draw
 * out_YPos	: Y start position, and update Y once you're done to the next position
 */
final simulated function DrawRotationText(Canvas Canvas, out float out_YPos)
{
	// termporary variables for easy tweaks of screen location
	local float CurX, CurY;

	if (MyGearPawn!=none)
	{
		// draw the name of character
		CurX = 5;
		CurY = Out_YPos;
		Canvas.SetPos(CurX, CurY);
		Canvas.SetDrawColor(255, 255, 255);
		Canvas.DrawText( "#"$Right(Class, Len(Class)-7)$":"$GetRightMost(self), TRUE );

		CurX = 130;
		CurY = Out_YPos;

		// draw rotation box with desired rotation information
		if (MyGearPawn.IsDesiredRotationLocked())
		{
			DrawBox(Canvas, CurX, CurY, MakeColor(255, 0, 0));
		}
		else if (MyGearPawn.IsDesiredRotationInUse())
		{
			DrawBox(Canvas, CurX, CurY, MakeColor(0, 0, 255));
		}
		else
		{
			DrawBox(Canvas, CurX, CurY, MakeColor(255, 255, 255));
		}

		// current pawn rotation
		DrawRotation(Canvas, CurX, CurY, MyGearPawn.Rotation.Yaw, MakeColor(255, 255, 255));

		// if precise rotation is true, then draw the precise yaw rotation
		if (MyGearPawn.SpecialMove != SM_None &&
			MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove].bReachPreciseRotation == TRUE)
		{
			DrawRotation(Canvas, CurX, CurY, MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove].PreciseRotation.Yaw, MakeColor(255, 0, 0));
		}
		// when it reached to destination, draw with white as we don't care much
		if ( !MyGearPawn.ReachedDesiredRotation() )
		{
			// if not, draw with color of green for rotation and red being desired rotation of pawn
			DrawRotation(Canvas, CurX, CurY, MyGearPawn.DesiredRotation.Yaw, MakeColor(0, 0, 255));
		}

		CurX += 40;

		// draw aim offset
		DrawBox(Canvas, CurX, CurY, MakeColor(255, 255, 255));
		// decided only draw AimOffset X of top down view
		DrawRotation(Canvas, CurX, CurY, MyGearPawn.AimOffsetPct.X * 16384, MakeColor(255, 0, 0));

		CurX += 40;

		// Draw mirror information
		Canvas.SetPos(CurX+8, CurY+8);
		if ( MyGearPawn.bIsMirrored )
		{
			if ( MyGearPawn.bDoingMirrorTransition )
			{
				Canvas.SetDrawColor(255, 200, 0);
			}
			else
			{
				Canvas.SetDrawColor(255, 0, 0);
			}
		}
		else
		{
			if ( MyGearPawn.bDoingMirrorTransition )
			{
				Canvas.SetDrawColor(0, 200, 255);
			}
			else
			{
				Canvas.SetDrawColor(0, 0, 255);
			}
		}

		Canvas.DrawTexture(Texture2D'WhiteSquareTexture',0.5f);

		// Finally draw the action string - which command AI is executing
		CurX += 40;
		Canvas.SetPos(CurX, CurY);
		Canvas.SetDrawColor(255, 255, 255);
		Canvas.DrawText( String(MyGearPawn.SpecialMove)@ GetActionString(), TRUE);

		Out_YPos += 40;
	}
}

/**
 * Draw box on the canvas with BoxColor starting from StartX and StartY (top left corner)
 * Canvas	: Canvas to draw
 * StartX	: Left start point to right
 * StartY	: Top start point to bottom
 * BoxColor	: Outline color of box
 */
final simulated function DrawBox(Canvas Canvas, float StartX, float StartY, color BoxColor)
{
	Canvas.SetPos(StartX, StartY);
	Canvas.SetDrawColor(BoxColor.R, BoxColor.G, BoxColor.B);
	Canvas.DrawBox(32, 32);
}

/**
 * Draw top down view of rotation (Rot) on the canvas with RotColor starting from StartX and StartY
 * Canvas	: Canvas to draw
 * StartX	: Left start point to right
 * StartY	: Top start point to bottom
 * Rot		: Unreal Unit of rotation value around one axis - to draw top down view
 * RotColor	: Color of line
 */
final simulated function DrawRotation(Canvas Canvas, float StartX, float StartY, int Rot, color RotColor)
{
	// assume our 2D coordinate for this rotation is from (-1, 1) on x, y
	// our base vector is x(0), y(1) - top center
	// we would like to rotate vector (0, 1) to the angle of Rot
	local float X, Y, CenterX, CenterY;

	// since  old X = 0, it cancels first part
	X = Sin(Rot*UnrRotToRad);
	Y = Cos(Rot*UnrRotToRad);
	CenterX = StartX + 16;
	CenterY = StartY + 16;

	// Y Flips as I assumed top is 1 and bottom is -1
	Canvas.Draw2DLine(CenterX, CenterY, CenterX + X*16, CenterY - Y*16, RotColor);
}

/**
 * Overridden in case anybody outside the AI refs this func.
 */
function bool IsInCombat( optional bool bForceCheck )
{
	return HasAnyEnemies();
}

/**
 * =======
 * STARTUP
 * =======
 */

event PostBeginPlay()
{
	Super.PostBeginPlay();
}

/**
 * Overridden for additional init.
 */
event Possess(Pawn NewPawn, bool bVehicleTransition)
{
	local GearGameSP_Base SPGame;

	Super.Possess(NewPawn, bVehicleTransition);
	if( Pawn != None )
	{
		//debug
		`AILog(GetFuncName()@NewPawn);

		if (Vehicle(NewPawn) == None)
		{
			// transition to default state in case we were dead where the normal TransitionTo() is ignored (as long as it's a normal pawn)
			GotoState('');
		}

		MyGearPawn = GearPawn(NewPawn);

		// set initial physics
		if (MyGearPawn == None || (MyGearPawn.SpecialMove != SM_ZiplineIdle && Vehicle_RatTruck_Base(MyGearPawn.Base) == None))
		{
			Pawn.SetMovementPhysics();
		}
		if (!bVehicleTransition)
		{
			// make sure the player defaults are established
			WorldInfo.Game.SetPlayerDefaults(Pawn);
		}

		// Adjust settings by weapon
		NotifyChangedWeapon( None, Pawn.Weapon );

		if( MyGearPawn != None )
		{
			MyGearPawn.bDoWalk2IdleTransitions	= FALSE;
			MyGearPawn.bAllowSpeedInterpolation = !WorldInfo.GRI.IsMultiplayerGame();
			SetTimer( 1.0, true, nameof(SetIsInCombat) );
		}

		// Transition to the idle state
		BeginCombatCommand( None, "Possessed" );

		// Added to allow AI to fall off ledges
		Pawn.bCanJump = true;
		// Prevent AI from trying to crouch while pathing/moving
		Pawn.bCanCrouch = false;

		// spin up the reactions!
		if(!bVehicleTransition)
		{
			ReactionManager.Wipe();
			ReactionManager.Initialize();
		}

		SPGame = GearGameSP_Base(WorldInfo.Game);
		if (SPGame != None)
		{
			// hardcode potential co-op Pawns to never be stale
			if (SPGame.PlayerSlots.Find('Owner', self) != INDEX_NONE)
			{
				bDeleteWhenStale = false;
			}

			// if we're in Arcade mode, set up scoring values
			if (MyGearPawn != None && GearGameSP_Arcade(SPGame) != None)
			{
				GearPRI(PlayerReplicationInfo).ScaleScoringValues(float(MyGearPawn.ArcadeBasePointValue) / SPGame.PointsFor_DamagePct);
			}
		}

		// if we're allowed to, start the timer checking to see if we've done something interesting recently
		SetEnableDeleteWhenStale(bDeleteWhenStale);

		// make sure we re-equip a weapon when getting out of a vehicle
		if (bVehicleTransition)
		{
			SelectWeapon();
		}
	}
}

/** called on a timer to update bIsInCombat on our GearPawn */
function SetIsInCombat()
{
	local GearPC PC;
	local bool bNowInCombat;

	if (MyGearPawn != None)
	{
		// AI guys count as always in combat, unless have a human squadleader (in that case match human)
		PC = GearPC(GetSquadLeader());
		bNowInCombat = (PC == None || PC.IsInCombat());
		// avoid setting bNetDirty to true unnecessarily
		if (MyGearPawn.bIsInCombat != bNowInCombat)
		{
			MyGearPawn.bIsInCombat = bNowInCombat;
		}
	}
}

function SetEnableDeleteWhenStale(bool bAmIExpendable)
{
	//`log(self@GetFuncName());
	bDeleteWhenStale = bAmIExpendable;

	// always run the timer so we can do things based off of staleness even when we're not allowed to delete
	SetTimer( StaleTimeout,FALSE,nameof(ConditionalDeleteWhenStale) );
}


final function float GetMinDistanceToAnyEnemy()
{
	local Pawn P;
	local float MinDist;
	local float CurDist;
	MinDist =-1;
	foreach Squad.AllEnemies(class'Pawn',P)
	{
		CurDist = VSizeSq(P.Location - Pawn.Location);
		if(CurDist < MinDist || MinDist < 0)
		{
			MinDist = CurDist;
		}
	}

	if(MinDist >= 0)
	{
		MinDist = sqrt(MinDist);
	}
	return MinDist;
}

final function float GetMinDistanceToAnyPlayer()
{
	local PlayerController PC;
	local float MinRange;
	local float CurRange;

	MinRange = -1.f;
	if(Pawn == none)
	{
		return -1.f;
	}

	ForEach WorldInfo.AllControllers(class'PlayerController', PC)
	{
		if ( PC != none && PC.ViewTarget != None )
		{
			CurRange = VSizeSq(PC.ViewTarget.Location - Pawn.Location);
			if(CurRange < MinRange || MinRange < 0.f)
			{
				MinRange = CurRange;
			}
		}
	}

	return sqrt(MinRange);
}

/** called by timer, will check every StaleTimeout seconds to see if we should delete ourselves */
function ConditionalDeleteWhenStale()
{
	//`log(self@GetFuncName()@bDeleteWhenStale);
	if(Pawn == none)
	{
		// easy one..
		CleanupBoringDude();
	}
	else
	{
		// if we've been rendered recently
		if (WorldInfo.TimeSeconds - Pawn.LastRenderTime < StaleTimeout)
		{
			//`log(GetFuncName()@"Not deleting cuz we were rendered"@`TimeSince(Pawn.LastRenderTime)@"seconds ago.");
			// being rendered is interesting
			NotifyDidSomethingInteresting(Pawn.LastRenderTime);
		}
		// make sure they're not near a player just in case
		else
		if(GetMinDistanceToAnyPlayer() > 2048.0f)
		{
			// notify stale returns false if it does not handle the staleness
			if(!NotifyStale())
			{
				// throw up a warning since this dude is costing cycles and not doing anything
				`if(`notdefined(FINAL_RELEASE))
					if(ShouldPrintStaleWarning())
					{
						MessagePlayer(pawn@self@"at"@Pawn.Location@"has not done anything interesting in at least"@StaleTimeout@"seconds, but I'm not allowed to delete him!");
						`log(pawn@self@"at"@Pawn.Location@"has not done anything interesting in at least"@StaleTimeout@"seconds, but I'm not allowed to delete him!");
					}
				`endif
				NotifyDidSomethingInteresting();
			}

		}
		else
		{
			// if we got here it means we haven't been rendered in a while, as well as not having done something in a long time.. but we're near the player.  So! Pretend we did somethign interesting half the staletimout
			// ago so that we get checks more often
			//`log(GetFuncName()@"Not deleting cuz we were too close to the player!");
			NotifyDidSomethingInteresting(WorldInfo.TimeSeconds - (StaleTimeout*0.5f));
		}
	}
}

function bool ShouldPrintStaleWarning()
{
	return TRUE;
}

function CleanupBoringDude()
{
	local Vehicle Vehicle;

	Vehicle = Vehicle(Pawn);
	if(Vehicle != none)
	{
		Vehicle.DriverLeave(TRUE);
	}

	if( Pawn != none )
	{
		Pawn.Destroy();
	}
	Destroy();
}

function bool NotifyStale()
{
	if ((Squad != none && Squad.bPlayerSquad) || !bDeleteWhenStale)
	{
		// if we're in horde, banzai
		if (GearGameHorde_Base(WorldInfo.Game) != None)
		{
			`AILog("We're stale! banzaaiii!");
			BanzaiAttack();
			// we handled by going banzai
			return true;
		}
	}
	else
	{
		`if(`notdefined(FINAL_RELEASE))
			`log("STALE AI DELETION WARNING:"@pawn@"("$self$") has not done anything useful in "$StaleTimeout$" seconds.. he is being DELETED!");
		`endif
		`AILog("END OF THE ROAD!!!!!!!!!!!  Destroying this dude because he was boring.. HE BORES ME!");
		// if not, fair game biznatches!  delete the sucker
		CleanupBoringDude();

		// indicate we handled the staleness successfuly
		return true;
	}

	return false;
}

/**
 * ========
 * STIMULUS
 * ========
 */

/**
 * Called once a new enemy is encountered.
 *
 * @see: SeePlayer(), HearNoise(), TakeDamage()
 */
final event NoticedEnemy(Pawn NewEnemy)
{
	//debug
	`AILog(GetFuncName()@NewEnemy@CombatMood);

	if( CombatMood != AICM_Ambush )
	{
		// If no enemy yet, select one
		if( Enemy == None )
		{
			SelectTarget();
			// check weapon switch if this is the first enemy we've encountered
			if (Enemy != None && !IsMeleeRange(Enemy.Location))
			{
				SelectWeapon();
			}
		}

		// tell battle monitor what's going on
		if (GearGameSP_Base(WorldInfo.Game) != None || GearGameSiege_Base(WorldInfo.Game) != None)
		{
			GearGame(WorldInfo.Game).BattleMonitor.NotifyEnemyNoticed(Pawn, NewEnemy);
		}

		CheckCombatTransition();

		ReactionManager.NudgeChannel(NewEnemy,'NoticedEnemy');
	}
}

/** AI should ignore notifications that would alter behavior - ie. seeing/hearing enemies, getting shot, etc */
native function bool IgnoreNotifies() const;

/**
 * Overridden to check for a new enemy, insert them in the enemy list and fire off an event.
 */
native event SeePlayer( Pawn Seen );

function bool CanSeePawn( Pawn Seen )
{
	return TRUE;
}

function bool IsPawnVisibleViaTrace( Pawn PawnToCheck )
{
	local Vector TestLocation;
	local Rotator Rot;

	Rot = Pawn.Rotation;
	TestLocation = PawnToCheck.GetPawnViewLocation();
	Rot = Rotator(GetEnemyLocation(PawnToCheck, LT_InterpVisibility) - Pawn.Location);

	return CanSeePawn(PawnToCheck) && CanSeeByPoints( Pawn.GetWeaponStartTraceLocation(), TestLocation, Rot );
}

/**
 * Overridden to check for a new enemy, insert them in the enemy list and fire off an event.
 */
event HearNoise(float Loudness, Actor NoiseMaker, optional Name NoiseType)
{
	local Pawn Heard;

	if (Controller(NoiseMaker) != None)
	{
		Heard = Controller(NoiseMaker).Pawn;
	}
	else if (NoiseMaker != None)
	{
		Heard = NoiseMaker.Instigator;
	}

	if (Heard != None && Heard != Pawn)
	{
		// If already knew about enemy
		if (!IsFriendlyPawn(Heard) && CanHearPawn(Heard, Loudness, NoiseType))
		{
			ProcessStimulus(Heard, PT_Heard, NoiseType);
		}
	}
}

function bool CanHearPawn( Pawn Heard, float Loudness, Name NoiseType )
{
	local float Dist;

	if (NoiseType == 'NOISETYPE_FootStep')
	{
		// reduced hearing radius for footsteps
		Dist = VSize(Pawn.Location - Heard.Location);
		if (Dist > 512.0 * Loudness)
		{
			return FALSE;
		}
	}

	return TRUE;
}

event NotifyEnemyBecameVisible( Pawn VisibleEnemy, float TimeSinceLastVisible )
{
	if( CachedAICommandList != None )
	{
		CachedAICommandList.NotifyEnemyBecameVisible( VisibleEnemy );
	}

	// if we haven't seen this guy in a while, trigger a gud
	if(TimeSinceLastVisible > 3.0f)
	{
		GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_FoundTarget, Pawn);
	}
}
event NotifyLostEnemyVisibility( Pawn LostEnemy )
{
	ReactionManager.NudgeChannel(LostEnemy,'LostEnemyVisibility');
}
event NotifyEnemyHeard( Pawn HeardEnemy, Name NoiseType )
{
	//debug
	`AILog( GetFuncName()@HeardEnemy@NoiseType@HeardEnemy.Health@(WorldInfo.TimeSeconds -HeardEnemy.SpawnTime), 'Enemy' );

	if( CombatMood == AICM_Ambush )
	{
		// ignore sounds from spawning pawns
		if (WorldInfo.TimeSeconds - HeardEnemy.SpawnTime < 1.0f)
		{
			return;
		}
		SetCombatMood( AICM_Normal );
	}
}
event NotifyEnemySeen( Pawn SeenEnemy );
function NotifyEnemyUsingMeatShield( GearPawn MSEnemy );

function bool ShouldNoticeFriendKilled(Controller KilledC, Pawn KilledP)
{
	local float Dist;

	if( Pawn == none || KilledP == none )
	{
		return false;
	}
	Dist = VSize(KilledP.Location - Pawn.Location);
	return (Dist < 512.0 || (Dist < 1024.0 && NavigationHandle.PointReachable(KilledP.Location)));
}

/**
 * Called when someone dies by the GameInfo, splits out into the appropriate notification.
 */
function NotifyKilled( Controller Killer, Controller Killed, Pawn KilledPawn, class<DamageType> damageType )
{
	if (KilledPawn == Pawn)
	{
		return;
	}

	if (IsFriendly(Killed) && ShouldNoticeFriendKilled(Killed, KilledPawn))
	{
		// if not ignoring notifications, record the hit
		if (Killer != None && Killer.Pawn != None && !IgnoreNotifies())
		{
			ProcessStimulus(Killer.Pawn, PT_HurtBy, GetFuncName());
		}
	}
	else
	{
		// Notify squad of killed pawn
		if (Squad != None)
		{
			Squad.RemoveEnemy(KilledPawn);
		}

		if (KilledPawn == FireTarget || KilledPawn == Enemy)
		{
			TargetList.RemoveItem(KilledPawn);
			SelectTarget();
		}

		if (!HasValidTarget())
		{
			StopFiring();
		}
	}

	CheckInterruptCombatTransitions();
}

/** called shortly after a GearPawn goes DBNO */
final function NotifyWaitingForRevive(Controller Killer, Controller Killed, Pawn KilledPawn)
{
	local GearAI KilledGAI;

	if (KilledPawn == Pawn)
	{
		return;
	}

	if (IsFriendly(Killed))
	{
		//`log(self@GetFuncName()@"Friendly! DBNO?"@KilledGP.IsDBNO()@IgnoreNotifies() );

		KilledGAI = GearAI(Killed);
		// nudge friendly DBNO channel (only for friendlies who are NOT in our squad, intra-squad notifcations are handled elsewhere)
		if (KilledGAI != none && KilledGAI.Squad != Squad)
		{
			ReactionManager.NudgeChannel(GearPawn(KilledPawn), 'FriendlyDBNO');
		}

		// if not ignoring notifications, record the hit
		if (Killer != None && Killer.Pawn != None && !IgnoreNotifies())
		{
			ProcessStimulus(Killer.Pawn, PT_HurtBy, GetFuncName());
		}
	}
	else
	{
		// Notify squad of DBNO pawn
		if (Squad != None)
		{
			Squad.NotifyEnemyDBNO(GearPawn(KilledPawn));
		}

		if (KilledPawn == Enemy)
		{
			SelectTarget();
		}

		if (!HasValidTarget())
		{
			StopFiring();
		}
	}

	CheckInterruptCombatTransitions();
}

/** notification that the given Pawn has exited DBNO, either because it was revived or because it was killed
 * May be called for enemy and friendly Pawns, but is not called for the AI that controls DBNOPawn
 */
final function NotifyLeftDBNO(GearPawn DBNOPawn)
{
	local GameAICommand Cmd;
	local AICmd_Execute ExecuteCmd;
	local AICmd_Revive ReviveCmd;
	local AICmd_Kidnap KidnapCmd;

	// abort any execute/revive commands targeting the passed in Pawn
	for (Cmd = CommandList; Cmd != None; Cmd = Cmd.ChildCommand)
	{
		ExecuteCmd = AICmd_Execute(Cmd);
		if (ExecuteCmd != None && ExecuteCmd.ExecuteTarget == DBNOPawn && ExecuteCmd.ChildCommand != None)
		{
			AbortCommand(ExecuteCmd);
			break;
		}
		else
		{
			ReviveCmd = AICmd_Revive(Cmd);
			if (ReviveCmd != None && ReviveCmd.ReviveTarget == DBNOPawn && ReviveCmd.ChildCommand != None)
			{
				AbortCommand(ReviveCmd);
				break;
			}
			else
			{
				KidnapCmd = AICmd_Kidnap(Cmd);
				if (KidnapCmd != None && KidnapCmd.KidnapTarget == DBNOPawn && KidnapCmd.ChildCommand != None)
				{
					AbortCommand(KidnapCmd);
					break;
				}
			}
		}
	}
}

/**
* Called when a DroppedPickup is spawned
*/
function NotifyDroppedPickup( GearDroppedPickup Pickup );


/* epic ===============================================
* ::CheckNearMiss
*
* Check if bullet went close by my pawn.
*
* =====================================================
*/
function CheckNearMiss(Pawn Shooter, GearWeapon GearWeap, const out ImpactInfo Impact, class<DamageType> InDamageType)
{
	local FLOAT		NearMissDist;
	local Vector	ClosestPoint;

	//MessagePlayer(GetFuncName()@InDamageType);
	//	`AILog(GetFuncName()@Shooter@IgnoreNotifies());

	if( IgnoreNotifies() )
	{
		return;
	}

	// Find closest distance to segment bullet travelled.
	NearMissDist = PointDistToSegment(MyGearPawn.Location, Impact.StartTrace, Impact.HitLocation, ClosestPoint);

	// If we're beyond max distance check, bail out
	if( NearMissDist > AI_NearMissDistance )
	{
		return;
	}

	LastShotAtTime = WorldInfo.TimeSeconds;

	// Let our Pawn know we got a near miss.
	if( MyGearPawn != None )
	{
		MyGearPawn.RegisterNearHitMiss(Impact, InDamageType);
	}

	// track the damage (small pct for near misses)
	ReceivedDamage( GearWeap.GetFireModeDamage(ClosestPoint) * 0.25f, Shooter, FALSE );
	ReactionManager.IncomingDamage(Shooter, FALSE, class<GearDamageType>(InDamageType));
}

function bool ReceivedDamage( int Damage, Pawn DamageInstigator, optional bool bDirectDamage, optional class<DamageType> damageType, optional TraceHitInfo HitInfo )
{
	//debug
	`AILog(GetFuncName()@DamageInstigator@Damage@bDirectDamage, 'Damage' );

	DamageReceivedInAction += Damage;

	ProcessStimulus( DamageInstigator, PT_HurtBy, GetFuncName() );

	if (WorldInfo.TimeSeconds - LastDamageReceivedTime > MinDamageReceivedTime)
	{
		LastDamageReceivedTime = WorldInfo.TimeSeconds;
	}

	return FALSE;
}

/**
 * GearAINotifyTakeHit takes more parameters than NotifyTakeHit.  It has the locational damage
 * and hit info in addition to the normal NotifyTakeHit parameters.
 **/
function GearAINotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> DamageType, vector Momentum, const out TraceHitInfo HitInfo)
{
	if (InstigatedBy != None && !IsFriendlyPawn(InstigatedBy.Pawn))
	{
		//debug
		`AILog(GetFuncName() @ InstigatedBy @ Damage @ DamageType @ IgnoreNotifies(), 'Damage');

		// notify the reaction manager of the incoming hit regardless
		ReactionManager.IncomingDamage(InstigatedBy.Pawn, true, class<GearDamageType>(DamageType), HitInfo, GetEnemyLocation(InstigatedBy.Pawn), Damage);

		// if not ignoring notifications, record the hit
		if (!IgnoreNotifies())
		{
			// record the hit
			LastShotAtTime = WorldInfo.TimeSeconds;

			// track the damage
			ReceivedDamage(Damage, InstigatedBy.Pawn, true, DamageType, HitInfo);
		}
	}
}

/** Deprecated.  Use GearAINotifyTakeHit **/
function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
{
	`log( "NotifyTakeHit has been deprecated for GearAIs.  Please use GearAINotifyTakeHit" );
	ScriptTrace();
}

function NotifyProjLanded( Projectile Proj )
{
	if( MyGearPawn == None || MyGearPawn.IsDoingASpecialMove() || IsFriendlyPawn(Proj.Instigator) )
		return;

	//debug
	`AILog( GetFuncName()@Proj@Proj.Instigator@IgnoreNotifies() );

	// Count bounce as enemy notification
	LastShotAtTime = WorldInfo.TimeSeconds;

	ProcessStimulus( Proj.Instigator, PT_HurtBy, 'NotifyProjLanded' );
}

final function ReactToGrenade()
{
}

simulated function OnDestroy(SeqAct_Destroy Action)
{
	if (Pawn != None)
	{
		Pawn.OnDestroy(Action);
	}
	Super.OnDestroy(Action);
}

/**
 *	Projectiles warn AI just before they are going to explode
 */
function WarnProjExplode( Projectile Proj )
{
	ReactionManager.NudgeChannel(Proj,'WarnProjExplode');
}

function ReceiveProjectileWarning( Projectile Proj )
{
	WarnProjExplode( Proj );
}

/** called when this AI is the target of a weapon that is charging up, but has not yet fired (e.g. Torque Bow) */
function ReceiveChargeTargetWarning(Pawn Shooter);

/** Hammer of Dawn is targeting */
function NotifyHODThreat( Pawn Shooter, Vector TargetingLocation )
{
	if( Pawn == None ||
		IsFriendlyPawn(Shooter) )
	{
		return;
	}

	if( MyGearPawn != None &&
		MyGearPawn.IsDoingASpecialMove() )
	{
		return;
	}

	// Make sure we have shooter as enemy
	ProcessStimulus( Shooter, PT_HurtBy, 'NotifyHODThreat' );
}

/** When special move is started */
function NotifyStartOfSpecialMove( GearPawn.ESpecialMove NewMove );

/** When special move is complete allow movement to continue */
function NotifyEndOfSpecialMove( GearPawn.ESpecialMove LastMove )
{
	//debug
	`AILog( GetFuncName()@LastMove@GetStateName()@MoveTarget@Pawn.Physics, 'Move' );

	if( LastMove == GSM_LeapToCeiling ||
		LastMove == GSM_DropFromCeiling )
	{
		if( MyGearPawn != None )
		{
			// Set new anchor
			MyGearPawn.SetAnchor( NavigationPoint(MoveTarget) );
		}
		// Clear move target
		while(  RouteCache.Length > 0 &&
				RouteCache[0] == MyGearPawn.Anchor )
		{
			RouteCache_RemoveIndex( 0 );
		}
		MoveTarget = None;
	}
}

function bool NotifyBump( Actor Other, vector HitNormal )
{
	local Pawn bumpPawn;
	local GearPawn WP;
	local bool bStimResult;
	local AICmd_MoveToGoal_Mesh ActiveMoveCmd;

	//debug
//	`AILog(GetFuncName()@Other);

	ActiveMoveCmd = AICmd_MoveToGoal_Mesh(GetActiveCommand());
	if (ActiveMoveCmd != None && MoveGoal == Other)
	{
		`AILog("Popping Move To Goal command early because bumped into MoveGoal");
		ActiveMoveCmd.Status = 'Success';
		PopCommand(ActiveMoveCmd);
	}

	if( IgnoreNotifies() )
	{
		return FALSE;
	}

	bumpPawn = Pawn(Other);
	if( bumpPawn != None )
	{
		WP = GearPawn(Other);
		if( IsFriendlyPawn( bumpPawn ) )
		{
			// revive friendly if we bump into it
			if (WP != None && WP.IsDBNO())
			{
				GoReviveTeammate(WP);
			}
			// Prevent reaver from trying to step aside of driver/gunner
			else if( Pawn.Base != bumpPawn && !IsZero(bumpPawn.Velocity) &&
					 bumpPawn.Base != Pawn &&
					 bumpPawn != CurrentTurret &&
					 bumpPawn != LastTurret &&
					 !bIgnoreStepAside )
			{
				//debug
				`AILog(GetFuncName()@Other);

				// try to step aside for them
				StepAsideFor( bumpPawn );
			}
		}
		else
		{
			bStimResult = ProcessStimulus( WP, PT_Force, 'NotifyBump' );
			if( !bDoingMeleeAttack )
			{
				//debug
				`AILog(GetFuncName()@Other);

				if( WP != None &&
					IsValidMeleeTarget( WP ) &&
					CanEngageMelee() &&
					bStimResult)
				{
					DoMeleeAttack( WP );
				}
				// execute enemy if we bump into it
				else if (WP != None && WP.IsDBNO())
				{
					GoExecuteEnemy(WP);
				}
				else
				{
					// Potentially switch to melee
					ForceUpdateOfEnemies();
					CheckInterruptCombatTransitions();
				}
			}
		}
	}

	return super.NotifyBump( Other, HitNormal );
}

function DoMeleeAttack(optional Pawn NewEnemy, optional Actor InTarget)
{
	if (CachedAICommandList == None || CachedAICommandList.IsAllowedToFireWeapon())
	{
		if (NewEnemy != None)
		{
			SetEnemy(NewEnemy);
		}

		class'AICmd_Attack_Melee'.static.Melee(self, InTarget);
	}
}

function PawnDied(Pawn InPawn)
{
	local GearPawn WP;

	//debug
	`AILog(GetFuncName()@InPawn);

	if( InPawn == Pawn )
	{
		if (MyGearPawn != None)
		{
			// catch a special case when killed mid spawn
			MyGearPawn.bSpawning = FALSE;
		}

		RouteCache_Empty();

		if( Squad != None )
		{
			foreach Squad.AllEnemies( class'GearPawn', WP )
			{
				WP.ReleaseFireTicket( self );
			}
			Squad.UnregisterSquadMember( self );
		}
	}

	super.PawnDied( InPawn );

	// if this is a singleplayer game then destroy the controller
	if (bDestroyOnPawnDeath)
	{
		Destroy();
	}
}





/**
 * ====================
 *	SQUAD FUNCTIONS
 * ====================
 */
function OnChangeSquad( SeqAct_ChangeSquad Action )
{
	//debug
	`AILog( GetFuncName()@Action.SquadName );

	NotifyDidSomethingInteresting();
	SetSquadName( Action.SquadName, Action.bSquadLeader );
}

function OnAISquadController( SeqAct_AISquadController inAction )
{
	if( Squad != None )
	{
		//debug
		`AILog( GetFuncName()@Squad.SquadName@inAction.FormationType@inAction.SquadRoute.Length );

		NotifyDidSomethingInteresting();
		Squad.OnAISquadController( inAction );
	}
}

function NotifySquadLeaderChanged();

final function Name GetSquadName()
{
	return Squad != None ? Squad.SquadName : 'None';
}

event SetSquadName( Name NewSquadName, optional bool bLeader )
{
	local GearPRI PRI;
	local GearTeamInfo Team;
	local bool bNewName;

	PRI = GearPRI(PlayerReplicationInfo);

	if( PRI != None )
	{
		// Only update squad name if names are different (Alpha == Player)
		bNewName = (NewSquadName != PRI.SquadName);
		if( bNewName &&
			((NewSquadName == 'Alpha'  && PRI.SquadName == 'Player') ||
			 (NewSquadName == 'Player' && PRI.SquadName == 'Alpha')) )
		{
			bNewName = FALSE;
		}
		if( bLeader )
		{
			bNewName = TRUE;
		}

		if( bNewName )
		{
			//debug
			`AILog( GetFuncName()@PRI.SquadName@NewSquadName@bLeader );

			if( Squad != None )
			{
				Squad.UnregisterSquadMember(self);
			}

			// ask the team to join the new squad formation
			Team = GearTeamInfo(Pawn.GetTeam());
			if( Team != None )
			{
				Team.JoinSquad(NewSquadName, self, bLeader);
			}
		}
	}
}

final function Controller GetSquadLeader()
{
	if( Squad != None )
	{
		return Squad.Leader;
	}
	return None;
}

final function Actor GetSquadLeaderPosition()
{
	if( Squad != None )
	{
		return Squad.GetSquadLeaderPosition();
	}
	return None;
}

final function Vector GetSquadLeaderLocation()
{
	if( Squad != None )
	{
		return Squad.GetSquadLeaderLocation();
	}
	return vect(0,0,0);
}

final function Vector GetSquadPosition()
{
	if( Squad != None && Squad.Formation != None )
	{
		return Squad.Formation.GetPosition( self );
	}

	// debug
	`AILog("GetSquadPosition returning NONE because Squad or Squad.Formation was none");
	return vect(0,0,0);
}

final function bool GetIdealSquadPosition( out Vector out_IdealPos )
{
	if( Squad != None && Squad.Formation != None )
	{
		return Squad.Formation.GetCurrentIdealPosition( self, out_IdealPos );
	}
	return FALSE;
}

// checks to see if our current ideal position is overlapping another one in this squad
final function bool DoesIdealSquadPosOverlapAnother()
{
	if( Squad != None && Squad.Formation != None )
	{
		return Squad.Formation.DoesIdealSquadPosOverlapAnother( self );
	}
	return FALSE;
}

final function protected bool IsSquadLeaderInCover()
{
	local GearPawn WP;
	if( GetSquadLeader() != None )
	{
		WP = GearPawn(GetSquadLeader().Pawn);
		return (WP != None && WP.CurrentLink != None && WP.CoverType != CT_None);
	}
	return FALSE;
}

final function bool HasSquadLeader()
{
	local Controller Leader;

	Leader = GetSquadLeader();
	return (Leader != None && Leader.Pawn != None && (Leader.Pawn != Pawn || Squad.bPlayerSquad));
}

final function bool IsSquadLeader()
{
	local Controller Leader;

	Leader = GetSquadLeader();
	return (Leader != None && Leader.Pawn != None && Leader.Pawn == Pawn);
}

/** will return TRUE if we are already in a cover slot from one of our restricted cover links */
function bool AtSlotFromRestrictedLink()
{
	return false;
}

/** will return true if we have been given restricted cover links to use */
function bool HasRestrictedCoverLinks();

/**
* Should the AI move to the squad?
*/
function bool ShouldMoveToSquad( optional bool bSkipLastPositionCheck, optional Vector TestLocation )
{
	local float				CheckDist;
	local Vector			LeaderPos, IdealPos;
	local Vector			FormationPos;
	local bool				bValidIdeal, bInCombat, bAtRestrictedLink;
	local GearGRI GRI;
	local bool bValidFormationPos;

	`AILog(GetFuncName()@bSkipLastPositionCheck);
	if ( Pawn == None ||
		 ClassIsChildOf( Pawn.Class, class'GearVehicle' ) ||
		(Pawn.Base != None &&  ClassIsChildOf( Pawn.Base.Class, class'InterpActor_GearBasePlatform' )) )
	{
		`AILog("Skipping move to squad because pawn was none or Pawn.Base was an interp actor or vehicle"@Pawn@Pawn.Base);
		return FALSE;
	}

	// Don't move to squad if already given an action or no squad leader to move to
	if( MoveAction != None || IsTethered() || !HasSquadLeader() )
	{
		//debug
		`AILog("Shouldn't move to squad, move action:"@MoveAction@"tether:"@PrintTetherInfo()@"squad formation:"@GetSquadName()@HasSquadLeader()@GetSquadLeader()@"combatmood"@CombatMood);

		return FALSE;
	}

	if( IsZero(TestLocation) )
	{
		TestLocation = Pawn.Location;
	}

	LeaderPos	 = GetSquadLeaderLocation();
	FormationPos = GetSquadPosition();
	bValidIdeal  = GetIdealSquadPosition( IdealPos );


	// if we're in coop, and this is a player squad we need to check all the time since squad pos might move from either player moving
	GRI = GearGRI(WorldInfo.GRI);
	if (GRI != None && GRI.IsActuallyPlayingCoop() && Squad.bPlayerSquad && Squad.SquadRoute != none)
	{
		bSkipLastPositionCheck = true;
	}

	bValidFormationPos = !IsZero(FormationPos);
	if( !bValidFormationPos )
	{
		LastSquadLeaderPosition = vect(0,0,0);
	}

	if( !bValidFormationPos || (!bSkipLastPositionCheck && VSize(LeaderPos-LastSquadLeaderPosition) < 128.f) )
	{
		//debug
		`AILog( "Skip moving to squad"@`showvar(bValidFormationPos)@`showvar(FormationPos)@GetSquadLeader()@`showvar(LastSquadLeaderPosition)@`showvar(LeaderPos)@`showvar(TestLocation)@VSize(LeaderPos-LastSquadLeaderPosition));

		return FALSE;
	}

	bInCombat = HasAnyEnemies();

	bAtRestrictedLink = AtSlotFromRestrictedLink();

	if( bAtRestrictedLink )
	{
		`AILog("Skipping squad move because we're at a slot in our restricted cover link list already");

		return FALSE;
	}

	// If in combat and leader is within combat zones OR
	// Not in combat and AI is in cover
	if( bInCombat && IsWithinCombatZone( LeaderPos ) )
	{
		// figure out the check distance
		CheckDist = GetTetherToLeaderDist();

		// if we're not in range of the leader already
		if ( VSize(TestLocation - FormationPos) > CheckDist ||
			// don't do height check if we're in cover because we could be in a valid covernode that's not at the same Z as the formation nav
			(Abs( TestLocation.Z - FormationPos.Z ) > 128.f && !IsAtCover()) )
		{
			//debug
			`AILog("COMBAT - Not in range of squad, formation nav:"@FormationPos@"leader location"@GetSquadLeaderPosition()@VSize(TestLocation - LeaderPos)@VSize(TestLocation - FormationPos)@CheckDist@"At restricted link?"@bAtRestrictedLink);

			return TRUE;
		}
		else if(!bAtRestrictedLink && HasRestrictedCoverLinks())
		{
			`AILog("COMBAT - I'm in range of my squad, but I have restricted cover links, and I'm not at them.. moving to restricted link!");
			return TRUE;
		}
		else
		{
			`AILog("COMBAT In range of squad!"@CheckDist@VSize(TestLocation - FormationPos)@IsAtCover()@FormationPos);
		}
	}
	else
	// if we're not in range of the leader already
	if( !bInCombat &&
		((!Pawn.ReachedPoint( FormationPos, None ) &&
			(!bValidIdeal || !Pawn.ReachedPoint( IdealPos, Pawn.Anchor ))) ||
		Abs( TestLocation.Z - FormationPos.Z) > 128.f) )
	{
		//debug
		`AILog("NON COMBAT - Not in range of squad, formation nav:"@FormationPos@"leader location"@GetSquadLeaderPosition()@VSize(TestLocation-FormationPos)@"Ideal"@IdealPos@VSize(TestLocation-IdealPos) );

		return TRUE;
	}
	else
	{
		`AILog("In range of leader:"@GetSquadLeader()@VSize(TestLocation - LeaderPos)@IsWithinCombatZone(LeaderPos));
	}

	return FALSE;
}

function float GetTetherToLeaderDist()
{
	local float Dist;

	// keep tight on the squad
	Dist = 512.0;

	// increased for combat
	if (HasAnyEnemies())
	{
		Dist = 1024.0;
		// and scaled if we're in a separate combat mood
		if (CombatMood == AICM_Aggressive)
		{
			Dist *= 1.5;
		}
	}
	else if (MyGearPawn != None && MyGearPawn.IsInCover())
	{
		Dist *= 1.5;
	}

	// if we're in our assigned combat zone, and so is our leader scale up distance a lot
	if (CombatZoneList.length > 0 && IsWithinCombatZone(MyGearPawn.Location) && IsWithinCombatZone(GetSquadLeaderLocation()))
	{
		Dist *= 3.0;
	}

	return Dist;
}

final function bool IsCloseToSquadLeader(vector ChkLoc)
{
	return (GetSquadLeader() == None ||
		GetSquadLeader().Pawn == None ||
		VSize(ChkLoc - GetSquadLeader().Pawn.Location) <= GetTetherToLeaderDist());
}

final native function bool ProcessStimulus( Pawn E, EPerceptionType Type, Name EventName );



/**
 * ================
 * COMBAT FUNCTIONS
 * ================
 */

/** @return whether the AI should get infinite ammo for the passed in weapon */
function bool WantsInfiniteAmmoFor(GearWeapon Wpn)
{
	// If it's not grenades
	return (GearWeap_GrenadeBase(Wpn) == None);
}

function bool WantsInfiniteMagazineSize(GearWeapon Wpn)
{
	return FALSE;
}

function NotifyChangedWeapon( Weapon PrevWeapon, Weapon NewWeapon )
{
	local GearWeapon Wpn;
	if (NewWeapon != PrevWeapon)
	{
		//debug
		`AILog( GetFuncName()@PrevWeapon@NewWeapon );

		Wpn = GearWeapon(NewWeapon);
		if( Wpn != None )
		{
			WeaponAimDelay = Wpn.GetAIAimDelay();
			SetupEnemyDistances(Wpn);

			// set infinite ammo if desired
			if (WantsInfiniteAmmoFor(Wpn))
			{
				//debug
				`AILog( "Infinite ammo for"@Wpn );

				Wpn.SetInfiniteSpareAmmo();
			}
			if( WantsInfiniteMagazineSize( Wpn ) )
			{
				//debug
				`AILog( "Infinite mag size for"@Wpn );

				Wpn.SetInfiniteMagazineSize();
			}
		}
	}
}

/**
 * Figures out the AI enemy distances based on the current weapon and
 * the current combat mood.
 */
function SetupEnemyDistances(optional GearWeapon Wpn)
{
	local float MoodScale;
	local GearMutator GMut;

	if (CombatMood == AICM_Aggressive)
	{
		MoodScale = 0.5f;
	}
	else if (CombatMood == AICM_Passive)
	{
		MoodScale = 1.5f;
	}
	else
	{
		MoodScale = 1.f;
	}
	if (Wpn == None)
	{
		Wpn = GearWeapon(Pawn.Weapon);
	}
	if( Wpn != None )
	{
		EnemyDistance_Short		= Wpn.Range_Short * MoodScale;
		EnemyDistance_Medium	= Wpn.Range_Medium * MoodScale;
		EnemyDistance_Long		= Wpn.Range_Long * MoodScale;
		// don't scale melee by mood as that will more than likely break melee checks
		EnemyDistance_Melee		= Wpn.Range_Melee;
		EnemyDistance_MeleeCharge = Wpn.Range_MeleeCharge;
	}

	// allow mutator opportunity to override
	GMut = GearGame(WorldInfo.Game).GetBaseGearMutator();
	if (GMut != None)
	{
		GMut.ModifyAIEnemyDistances(self);
	}

	`AILog(GetFuncName()@Wpn);
	`AILog("- Long:"@EnemyDistance_Long);
	`AILog("- Medium:"@EnemyDistance_Medium);
	`AILog("- Short:"@EnemyDistance_Short);
	`AILog("- Melee:"@EnemyDistance_Melee);
	`AILog("- MeleeCharge:"@EnemyDistance_MeleeCharge);
}

function OnAISetupEnemyRange( SeqAct_AISetupEnemyRange inAction )
{
	if( inAction.EnemyDistance_Short >= 0 )
	{
		EnemyDistance_Short	= inAction.EnemyDistance_Short;
	}

	if( inAction.EnemyDistance_Medium >= 0 )
	{
		EnemyDistance_Medium = inAction.EnemyDistance_Medium;
	}

	if( inAction.EnemyDistance_Long >= 0 )
	{
		EnemyDistance_Long = inAction.EnemyDistance_Long;
	}

	if( inAction.EnemyDistance_Melee >= 0 )
	{
		EnemyDistance_Melee = inAction.EnemyDistance_Melee;
	}

	if( inAction.EnemyDistance_MeleeCharge >= 0 )
	{
		EnemyDistance_MeleeCharge = inAction.EnemyDistance_MeleeCharge;
	}
}

final event float GetDistanceFromSquadLeader(vector TestLocation)
{
	if( GetSquadLeader() != None )
	{
		return VSize(TestLocation - GetSquadLeaderLocation());
	}

	return 0.f;
}

/**
 * Returns our current health percentage.
 */
simulated final function float GetHealthPercentage()
{
	local Vehicle V;
	local Pawn P;

	P = Pawn;
	V = Vehicle(Pawn);
	if( V != None )
	{
		P = V.Driver;
	}

	if( P == None )
	{
		return 1.f;
	}
	else
	if( GearPawn(P) != None)
	{
		return (P.Health/float(GearPawn(P).DefaultHealth));
	}
	else
	{
		return (P.Health/float(P.HealthMax));
	}
}

/** Selects a target from the TargetList or selects an enemy normally */
function bool SelectTarget()
{
	local Controller C;
	local Actor		 OldTarget;
	local bool		 bResult;

	//debug
	`AILog("Looking for new target, current:"@FireTarget@HasValidTarget()@TargetList.Length, 'Enemy' );

	if( HasValidTarget() && CachedAICommandList != None && !CachedAICommandList.ShouldSelectTarget() )
	{
		return FALSE;
	}

	// Store old target
	OldTarget = FireTarget;

	// If there are targets to consider
	if( TargetList.Length > 0 )
	{
		// Randomly select one
		// @todo - sort on distance
		do
		{
			FireTarget = TargetList[Rand(TargetList.Length)];
			if (FireTarget == None || FireTarget.bDeleteMe || (Pawn(FireTarget) != None && FireTarget.bTearOff))
			{
				// target is dead, remove it
				TargetList.RemoveItem(FireTarget);
				FireTarget = None;
			}
		} until (FireTarget != None || TargetList.length == 0);

		// If target is a controller, set as pawn
		C = Controller(FireTarget);
		if (C != None)
		{
			FireTarget = C.Pawn;
		}

		bResult = (FireTarget != None);
	}

	// Otherwise, select enemy normally
	if( !bResult )
	{
		if( SelectEnemy() )
		{
			// Set target as enemy
			FireTarget	= Enemy;
			bResult		= TRUE;
		}
		else
		{
			// Otherwise, couldn't find enemy either

			// Clear fire target
			FireTarget = None;
		}
	}
	else
	{
		SetEnemy( Pawn(FireTarget) );
	}


	// If target changed
	if( OldTarget != FireTarget )
	{
		// Update acquisition time
		TargetAquisitionTime = WorldInfo.TimeSeconds;
	}
	ShotTarget = Pawn(FireTarget);

	//debug
	`AILog("- selected new target?"@bResult@FireTarget@(FireTarget == Enemy ? "(enemy)" : ""), 'Enemy' );

	// Nothing to shoot at
	return bResult;
}

final function bool IsTooLongSinceEnemySeen(Pawn EnemyPawn)
{
	return (Response_EnemyTooLongNoSeeTime > 0.0 && TimeSinceLastSeenEnemy(EnemyPawn) > Response_EnemyTooLongNoSeeTime);
}

function int GetNumEnemies()
{
	return (Squad != None ? Squad.GetNumEnemies() : 0);
}

final function CoverInfo GetEnemyCover( Pawn TestPawn )
{
	local CoverInfo Info;
	if( Squad != None )
	{
		Info = Squad.GetEnemyCover( TestPawn );
	}
	return Info;
}

/**
* Tells this AI to acquire all other enemy controllers.
*/
event AutoAcquireEnemy()
{
	local Controller PotentialEnemy;

	//debug
	`AILog(GetFuncName());

	foreach WorldInfo.AllControllers(class'Controller', PotentialEnemy)
	{
		if (PotentialEnemy != self && PotentialEnemy.Pawn != None)
		{
			if (!IsFriendly(PotentialEnemy))
			{
				`AILog("- adding enemy"@PotentialEnemy);
				ProcessStimulus( PotentialEnemy.Pawn, PT_Force, GetFuncName() );
			}
			else
			{
				`AILog("- skipping friend"@PotentialEnemy);
			}
		}
	}
}

/**
*	Tells AI enemies to this AI about the new existence
*/
event AutoNotifyEnemy()
{
	local GearAI AI;

	//debug
	`AILog( GetFuncName() );

	foreach WorldInfo.AllControllers( class'GearAI', AI )
	{
		if( AI != self && !IsFriendly( AI ) )
		{
			//debug
			`AILog( "-- Tell"@AI@"that I exist" );

			AI.ProcessStimulus( Pawn, PT_Force, GetFuncName() );
		}
		else
		{
			//debug
			`AILog( "-- skip friend"@AI );
		}
	}
}

/**
 * Adds enemies to the LocalEnemyList if the list is missing any enemies that are in the squad's enemy list and removes any
 * enemies from the squad list that have timed out or are prohibited to be an enemy
 */
function SyncEnemyLists()
{
	local Pawn P;
	local int Idx;

	if (Squad != None)
	{
		// Loop through the squad's enemy list and add any enemies to the local enemy
		// list that is not in there
		foreach Squad.AllEnemies(class'Pawn', P, self)
		{
			// Remove an enemy who the squad hasn't seen for some period of time
			if (Response_EnemyTooLongNoSeeTime > 0.0 && `TimeSince(Squad.GetEnemyLastSeenTime(P)) > Response_EnemyTooLongNoSeeTime)
			{
				//`log( `location@"REMOVE ENEMY"@P@`TimeSince(Squad.GetEnemyLastSeenTime(P))@Response_EnemyTooLongNoSeeTime );

				Squad.RemoveEnemy(P);
				continue;
			}

			// Don't select prohibited enemies
			if (ProhibitedTargetList.Find(P) >= 0)
			{
				Idx = LocalEnemyList.Find('Pawn', P);
				if ( Idx != INDEX_NONE)
				{
					LocalEnemyList.Remove(Idx,1);
				}

				continue;
			}

			// Find the pawn in the local list
			if (LocalEnemyList.Find('Pawn', P) == INDEX_NONE)
			{
				// Couldn't find the enemy in the local list so add it
				Idx = LocalEnemyList.length;
				LocalEnemyList.length = LocalEnemyList.length + 1;
				LocalEnemyList[Idx].Pawn = P;
			}
		}
	}

	for( Idx = 0; Idx < LocalEnemyList.Length; Idx++ )
	{
		if( LocalEnemyList[Idx].Pawn == None )
		{
			LocalEnemyList.Remove( Idx, 1 );
			Idx--;
		}
	}
}

/** @return base enemy rating, before visibility/cover/threat/etc modifiers */
function float GetBaseEnemyRating(Pawn EnemyP, float Distance)
{
	// Initial rating based on distance - longer = weaker rating
	if (Distance < EnemyDistance_Melee)
	{
		return 2.5;
	}
	else if (Distance < EnemyDistance_Short)
	{
		return 1.5;
	}
	else if (Distance < EnemyDistance_Medium)
	{
		return 1.0;
	}
	else
	{
		return 0.5;
	}
}

/** Rates all of the enemies in the LocalEnemyList and sorts them from highest to lowest */
protected function RateAndSortLocalEnemyList()
{
	local int EnemyIdx;
	local GearPawn EnemyGP;
	local float RatingToAdjust;
	local float Distance, DistanceToProtectionTarget;
	local Vector EnemyLocation;
	local bool bVisible;
	local CoverInfo EnemyCover;
	local Pawn EnemyP;
	local int ProtectIdx, BestProtectIdx;
	local float BestProtectRating, ProtectRating;

	// Loop through the local enemy list and rate each enemy for sorting
	for (EnemyIdx = 0; EnemyIdx < LocalEnemyList.length; EnemyIdx++)
	{
		EnemyP = LocalEnemyList[EnemyIdx].Pawn;

		EnemyGP = GearPawn(EnemyP);
		//debug
		`AILog("Rate:"@EnemyP, 'Enemy');

		if( !EnemyP.IsValidEnemyTargetFor( PlayerReplicationInfo, TRUE ) )
		{
			`AILog("    >>> Not a valid enemy target", 'Enemy');
			LocalEnemyList[EnemyIdx].Rating = -1;
			continue;
		}

		EnemyLocation = GetEnemyLocation(EnemyP);
		Distance = VSize(EnemyLocation - Pawn.Location);

		if (EnemyGP != None &&
			EnemyGP.IsDBNO())
		{
			// if we or a squadmate might execute the enemy, then ignore it
			if (Squad.IsTryingToExecute(EnemyGP))
			{
				`AILog("    >>> Ignore DBNO enemy that we want to execute", 'Enemy');
				LocalEnemyList[EnemyIdx].Rating = -1;
				continue;
			}
			// otherwise if we can't finish them from this range, then only if there's no one else
			else if (Distance > 256.0 &&
					 !GearGame(WorldInfo.Game).CanBeShotFromAfarAndKilledWhileDownButNotOut(EnemyGP, Pawn, None) )
			{
				`AILog("    >>> Enemy is DBNO and out of execution range but no other choice evaluated yet", 'Enemy');
				LocalEnemyList[EnemyIdx].Rating = 0;
				continue;
			}
			else if (!CanExecutePawn(EnemyGP))
			{
				`AILog("    >>> Enemy is DBNO and we are not allowed to execute", 'Enemy');
				LocalEnemyList[EnemyIdx].Rating = 0;
				continue;
			}
		}

		LocalEnemyList[EnemyIdx].Rating = GetBaseEnemyRating(EnemyP, Distance);

		// Add a boost to enemies that are near targets we want to protect
		BestProtectIdx = -1;
		for( ProtectIdx = 0; ProtectIdx < ProtectTargetList.Length; ProtectIdx++ )
		{
			if( ProtectTargetList[ProtectIdx] != None )
			{
				DistanceToProtectionTarget = VSize(EnemyLocation - ProtectTargetList[ProtectIdx].Location);
				ProtectRating = GetBaseEnemyRating(EnemyP, DistanceToProtectionTarget);
				if( ProtectRating > BestProtectRating )
				{
					BestProtectRating = ProtectRating;
					BestProtectIdx = ProtectIdx;
				}
			}

			// Only consider the enemy location vs the target they are threatening most
			if( BestProtectIdx >= 0 )
			{
				LocalEnemyList[EnemyIdx].Rating *= BestProtectRating;
			}
		}

		// apply human-player biases
		if (EnemyP.IsHumanControlled())
		{
			if (bBerzerk)
			{
				// bias against human players if berserk
				LocalEnemyList[EnemyIdx].Rating *= 0.1;
			}
			else if (GetDifficultyLevel() > DL_Casual)
			{
				// bias players unless casual
				LocalEnemyList[EnemyIdx].Rating *= 1.5f;
				if (EnemyGP != None &&
					EnemyGP.IsDoingSpecialMove(SM_RoadieRun))
				{
					LocalEnemyList[EnemyIdx].Rating *= 1.5f;
				}
			}
		}

		// prefer not changing targets while firing, or at all if we're melee focused
		if (EnemyP == FireTarget &&
			IsFiringWeapon())
		{
			LocalEnemyList[EnemyIdx].Rating *= 1.5;
		}
		else if (bPreferMelee && EnemyP == Enemy)
		{
			LocalEnemyList[EnemyIdx].Rating *= 1.5;
		}
		`AILog( "    >>> Init ="@LocalEnemyList[EnemyIdx].Rating, 'Enemy' );

		// Apply further factors only if not in melee, or we're a melee-primary AI
		if (bPreferMelee || !IsMeleeRange(EnemyLocation))
		{
			// Bonus if this is the last guy we were hit by
			// and it is our current enemy or our current enemy is not shooting at us
			if ( Pawn.LastHitBy == EnemyP.Controller && !bBerzerk &&
				(Enemy == None || Enemy == EnemyP || Enemy.Controller == None || Enemy.Controller.Enemy != Pawn) )
			{
				LocalEnemyList[EnemyIdx].Rating *= 1.5f;
			}

			`AILog( "    >>> LastHitBy ="@LocalEnemyList[EnemyIdx].Rating, 'Enemy' );

			// Penalty if enemy is not visible
			bVisible = IsEnemyVisible(EnemyP);
			if (!bVisible)
			{
				LocalEnemyList[EnemyIdx].Rating *= 0.5f;
			}
			`AILog( "    >>> Visibility ="@LocalEnemyList[EnemyIdx].Rating, 'Enemy' );

			// avoid shooting at dudes on different path networks if possible
			// (Can only trust non human pawn anchors)
			/* @FIXME navmesh
			if (!EnemyP.IsHumanControlled() &&
				EnemyP.Anchor != None &&
				Pawn.Anchor != None &&
				Pawn.Anchor.NetworkID != EnemyP.Anchor.NetworkID)
			{
				LocalEnemyList[EnemyIdx].Rating *= 0.75f;
			}
			`AILog( "    >>> Anchor ="@LocalEnemyList[EnemyIdx].Rating, 'Enemy' );
			*/

			// Bonus if enemy is not in cover
			if (EnemyGP != None &&
				!GetPlayerCover(EnemyGP, EnemyCover, FALSE))
			{
				LocalEnemyList[EnemyIdx].Rating *= 1.5f;
			}
			`AILog( "    >>> Cover ="@LocalEnemyList[EnemyIdx].Rating, 'Enemy' );

			// bonus vs vehicles and ridables (they're more threatening)
			if (Vehicle(EnemyP) != None || GearPawnRidable_Base(EnemyGP) != None)
			{
				LocalEnemyList[EnemyIdx].Rating *= 1.5f;
			}

			// If can't get fire ticket - severely cripple this enemy
			if (EnemyGP != None &&
				!CanClaimFireTicket(EnemyGP))
			{
				LocalEnemyList[EnemyIdx].Rating *= 0.05f;
			}
			`AILog( "    >>> FireTicket ="@LocalEnemyList[EnemyIdx].Rating, 'Enemy' );

			if (IsTooLongSinceEnemySeen(LocalEnemyList[EnemyIdx].Pawn) ||
				FailedPathToEnemyRecently(LocalEnemyList[EnemyIdx].Pawn))
			{
				LocalEnemyList[EnemyIdx].Rating *= 0.1f;
			}
			`AILog( "    >>> Too Long ="@LocalEnemyList[EnemyIdx].Rating, 'Enemy' );

			if( !WorldInfo.GRI.IsMultiplayerGame() && EnemyGP != None && EnemyGP.SpottedByTeam[GetTeamNum()] != 0 )
			{
				LocalEnemyList[EnemyIdx].Rating *= 1.5f;
			}
			`AILog( "    >>> Spotted? ="@LocalEnemyList[EnemyIdx].Rating, 'Enemy' );

			// Allow the rating to get adjusted based on AI/Command logic
			RatingToAdjust = LocalEnemyList[EnemyIdx].Rating;
			AdjustEnemyRating(RatingToAdjust, EnemyP);
			LocalEnemyList[EnemyIdx].Rating = RatingToAdjust;
			`AILog( "    >>> Adjust Rating ="@LocalEnemyList[EnemyIdx].Rating, 'Enemy' );
		}

		`AILog( "    >>> Final ="@LocalEnemyList[EnemyIdx].Rating, 'Enemy' );
	}

	// Sort the list
	SortLocalEnemyListByRating();
}

/**
 * Sorts the enemy list by rating, native because the script overhead of sorting
 * is way more expensive than the sorting of a list
 */
native final function SortLocalEnemyListByRating();

/**
 * Synchronizes the LocalEnemyList to the squad enemy list, rates the LocalEnemyList and sorts it,
 * then sets the highest rated enemy if one exists
 */
function bool SelectEnemy()
{
	// Early out if we don't have a pawn
	if (Pawn == None)
	{
		return FALSE;
	}

	`AILog( "SELECT ENEMY..."@Squad@Squad.EnemyList.Length, 'Enemy' );

	// Early out if we have an enemy and already eval'd this frame
	if (HasValidEnemy() &&
		WorldInfo.TimeSeconds - TargetAquisitionTime < 0.1f)
	{
		`AILog( "Aborting enemy selection, already have one from this frame" );
		return TRUE;
	}

	// Sync up the squad and local enemy lists
	SyncEnemyLists();

	// Rate and sort the LocalEnemyList
	RateAndSortLocalEnemyList();

	// Set the enemy and log it if we have one to set
	if( LocalEnemyList.length > 0 &&
		LocalEnemyList[0].Rating >= 0.f )
	{
		`AILog("SELECTED"@LocalEnemyList[0].Pawn@LocalEnemyList[0].Rating, 'Enemy' );
		SetEnemy(LocalEnemyList[0].Pawn);
	}
	// Set the enemy to none if there wasn't one to set
	else
	{
		SetEnemy(None);
	}

	// Return whether we selected a valid enemy or not
	return HasValidEnemy();
}

/** Allow the current command to adjust the rating of the enemy */
function AdjustEnemyRating(out float out_Rating, Pawn EnemyPawn)
{
	if (CachedAICommandList != None)
	{
		CachedAICommandList.AdjustEnemyRating(out_Rating, EnemyPawn);
	}
}

function SetEnemy( Pawn NewEnemy )
{
	// If enemy is changing
	if( NewEnemy != Enemy )
	{
		//debug
		`AILog( GetFuncName()@Enemy@"to"@NewEnemy );

		// Make sure we clear our tickets from enemy when we release him
		ReleaseFireTicket();
	}

	// Assign new enemy
	Enemy = NewEnemy;
}

final function bool ClaimFireTicket( optional bool bAll )
{
	local GearPawn WP;

	if( bUseFireTickets )
	{
		// If no enemy or enemy is in forced target list - always accept
		if( Enemy == None ||
			TargetList.Find( Enemy ) >= 0 ||
			TargetList.Find( Enemy.Controller ) >= 0 )
		{
			return TRUE;
		}

		WP = GearPawn(Enemy);
		if( WP != None )
		{
			// if they aren't where I think they are then don't claim the ticket
			if (VSize(WP.Location - GetEnemyLocation(WP)) > 64.f)
			{
				`AILog("Skipping fire ticket claim since they aren't near last known position");
				return TRUE;
			}
			// if they aren't in cover, then claim the ticket
			if (WP.CoverType == CT_None)
			{
				`AILog("Skipping fire ticket claim since they aren't in cover");
				return TRUE;
			}
			// if they are in our face, then claim the ticket
			if (VSize(WP.Location - Pawn.Location) <= EnemyDistance_Short)
			{
				`AILog("Skipping fire ticket claim since they are short range");
				return TRUE;
			}
			// otherwise attempt to claim a ticket
			return WP.ClaimFireTicket( self, bAll );
		}
	}

	return TRUE;
}

final function bool CanClaimFireTicket( GearPawn EnemyWP )
{
	if( bUseFireTickets )
	{
		if( EnemyWP != None )
		{
			return EnemyWP.ClaimFireTicket( self, FALSE, TRUE );
		}
	}

	return TRUE;
}

final function bool ReleaseFireTicket()
{
	local GearPawn WP;

	WP = GearPawn(Enemy);
	if( WP != None )
	{
		WP.ReleaseFireTicket( self );
	}

	return TRUE;
}

/**
 * Returns TRUE if the player is on our team.
 */
final native function bool IsFriendlyPawn(Pawn TestPlayer) const;

function native bool IsFriendly( Controller TestPlayer ) const;


/**
 * Returns TRUE if any known enemies are around.
 */
function bool HasAnyEnemies()
{
	return (Squad != None && Squad.EnemyList.Length > 0);
}

/**
 * returns TRUE if any known enemies are visible at the moment
 */
final function bool HasVisibleEnemies()
{
	local int i;
	for(i=0;i<Squad.EnemyList.Length;i++)
	{
		if(HasValidEnemy(Squad.EnemyList[i].Pawn) && IsEnemyVisible(Squad.EnemyList[i].Pawn))
		{
			return true;
		}
	}

	return false;
}
/**
 * Returns TRUE if we have a valid enemy targeted.
 */
final function bool HasValidEnemy( optional Pawn TestEnemy )
{
	if( TestEnemy == None )
	{
		TestEnemy = Enemy;
	}

	if(  TestEnemy == None ||
		!TestEnemy.IsValidEnemyTargetFor( PlayerReplicationInfo, TRUE ) )
	{
		return FALSE;
	}

	return TRUE;
}

final function native bool HasValidTarget( optional Actor TestTarget );

/**
 * @param WP - the enemy to test
 * @param bSkipZCheck (optional) - if set, skip Z axis location check (used when considering charging distance enemies)
 * @return whether the target is valid for melee attacks
 */
function bool IsValidMeleeTarget(GearPawn WP, optional bool bSkipZCheck)
{
	local bool bValidSoFar;
	local vector HitLoc;
	local vector Extent;
	local float HitLocThresh;

	if (WP == None || WP.bTearOff || (Squad != None && Squad.IsTryingToExecute(WP)))
	{
		return FALSE;
	}

	if( !WP.IsValidEnemyTargetFor( PlayerReplicationInfo, TRUE ) )
	{
		return FALSE;
	}

	//@hack: avoid chainsawing tickers
	if (Pawn.Weapon != None && Pawn.Weapon.Class == class'GearWeap_AssaultRifle' && WP.IsA('GearPawn_LocustTickerBase'))
	{
		return false;
	}
	// in SP, don't allow if would melee execute a COG when our delay time hasn't expired
	if ( GearGameSP_Base(WorldInfo.Game) != None && WP.IsDBNO() && WP.GetTeamNum() == 0 &&
		`TimeSince(WP.TimeStampEnteredRevivingState) >= ExecuteDelay )
	{
		return false;
	}

	// if they are valid, and
	// on the same z level roughly, and
	// either not on the network or something same network, and
	// they can be melee'd and
	// we haven't failed to find a path to them recently
	bValidSoFar = ( WP != None &&
			(bSkipZCheck || Abs(WP.Location.Z - Pawn.Location.Z) <= 64.0) &&
			(IsMeleeRange(WP.Location) || !FailedPathToEnemyRecently(WP)) &&
			!WP.ShouldOtherEvadeMeInsteadOfMeleeing(MyGearPawn));

	if( bValidSoFar )
	{
		Extent = vect(1,1,1);
		HitLocThresh = WP.GetCollisionRadius()+12.f;
		HitLocThresh*=1.414f;
		HitLocThresh*=HitLocThresh;

		if( NavigationHandle.ObstacleLineCheck(WP.Location,Pawn.Location,Extent,HitLoc)	||
			(VSizeSq2D(HitLoc-WP.Location) < HitLocThresh))
		{

			return true;
		}
	}

	return false;
}

/**
 *	Check enemy list to see if we have failed to move to this enemy recently
 */
final function bool FailedPathToEnemyRecently( Pawn TestEnemy )
{
	local int EnemyIdx;

	EnemyIdx = LocalEnemyList.Find( 'Pawn', TestEnemy );
	if( EnemyIdx >= 0 && WorldInfo.TimeSeconds - LocalEnemyList[EnemyIdx].LastFailedPathTime <= 5.f )
	{
		return TRUE;
	}

	return FALSE;
}

final function SetFailedPathToEnemy( Pawn TestEnemy, optional float Offset )
{
	local int EnemyIdx;

	EnemyIdx = LocalEnemyList.Find( 'Pawn', TestEnemy );
	if( EnemyIdx >= 0 )
	{
		//debug
		`AILog( GetFuncName()@TestEnemy@Offset@WorldInfo.TimeSeconds - Offset@`showvar(NavigationHandle.LastPathError) );

		LocalEnemyList[EnemyIdx].LastFailedPathTime = WorldInfo.TimeSeconds - Offset;
	}

	HandleFailedPathFind(TestEnemy);
}

function HandleFailedPathFind(Actor MoveToActor)
{
	local interface_AIMoveFailed MoveFailInterface;
	`AILog(GetFuncName()@`showvar(MoveToActor));
	if( NavigationHandle.LastPathError == PATHERROR_STARTPOLYNOTFOUND )
	{
		class'AICmd_MoveToMesh'.static.MoveToMesh( self );
	}

	MoveFailInterface = Interface_AIMoveFailed(MoveToActor);
	if( MoveFailInterface != none )
	{
		MoveFailInterface.AIFailedToPathToMe(self);
	}
}

/**
 * Returns TRUE if any known enemies are within the specified distance.
 *
 * @param	Distance	    Distance to check within
 * @param	out_enemyPawn	If set, returns the closest enemy within the specified distance
 * @param	bExact	        If set, use the exact location as opposed to what the AI believes
 */
native final function bool HasEnemyWithinDistance( float Distance, optional out Pawn out_EnemyPawn, optional bool bExact );

native final function bool ShouldCheckToSeeEnemy( Pawn E, out vector LineChkStart, out vector LineChkEnd );

/**
 *	Force perfect update of all enemy info
 */
final function ForceUpdateOfEnemies()
{
	local Pawn P;

	if( Squad != None )
	{
		foreach Squad.AllEnemies( class'Pawn', P )
		{
			ProcessStimulus( P, PT_Force, GetFuncName() );
		}
	}
}

final function float TimeSinceLastSeenEnemy(Pawn EnemyPawn, optional bool bUnseenIfNotFound)
{
	local int EnemyIdx;

	EnemyIdx = LocalEnemyList.Find( 'Pawn', EnemyPawn );
	if( EnemyIdx >= 0 )
	{
		return WorldInfo.TimeSeconds - LocalEnemyList[EnemyIdx].LastVisibleTime;
	}
	return (bUnseenIfNotFound ? 100000.f : 0.f);
}

final function float GetEnemyVisibleDuration( Pawn EnemyPawn )
{
	local int EnemyIdx;

	EnemyIdx = LocalEnemyList.Find( 'Pawn', EnemyPawn );
	if( EnemyIdx >= 0 )
	{
		return (LocalEnemyList[EnemyIdx].LastVisibleTime-LocalEnemyList[EnemyIdx].InitialVisibleTime);
	}
	return 0.f;
}

native final function Vector GetFireTargetLocation( optional GearSquad.ELocationType LT );
native final function vector GetEnemyLocation( optional Pawn TestPawn, optional GearSquad.ELocationType LT );

final native function bool IsMeleeRange( Vector TestLocation );

final native function bool IsEnemyVisible( Pawn EnemyPawn );

final function bool IsShortRange(vector TestLocation)
{
	return (VSize(TestLocation - Pawn.Location) <= EnemyDistance_Short);
}

final function bool IsMediumRange(vector TestLocation)
{
	return (VSize(TestLocation - Pawn.Location) <= EnemyDistance_Medium);
}

final function bool IsLongRange(vector TestLocation)
{
	return (VSize(TestLocation - Pawn.Location) <= EnemyDistance_Long);
}

/**
 * Returns the nearest enemy distance to a point.
 */
final function float GetNearEnemyDistance(vector Point, optional out Pawn out_NearEnemy, optional bool bExactLocation )
{
	local float Distance, NearestDistance;
	local Pawn	P;

	// init
	NearestDistance = 99999.f;
	out_NearEnemy	= None;

	if( Squad != None )
	{
		foreach Squad.AllEnemies( class'Pawn', P )
		{
			// test distance
			if( bExactLocation )
			{
				Distance = VSize(P.Location - Point);
			}
			else
			{
				Distance = VSize(GetEnemyLocation( P ) - Point);
			}

			if( Distance <= NearestDistance )
			{
				out_NearEnemy = P;
				NearestDistance = Distance;
			}
		}
	}

	return NearestDistance;
}

/**
 * Returns TRUE if we are under heavy fire.
 */
final function bool IsUnderHeavyFire()
{
	return (WorldInfo.TimeSeconds - LastShotAtTime < 0.6f);
}

final function ClearCombatZones()
{
	//debug
	`AILog( GetFuncName() );

	CombatZoneList.Length = 0;
}

event SetPendingCombatZone( CombatZone NewCZ )
{
	//debug
	`AILog( GetFuncName()@PendingCombatZone@NewCZ, 'Cover' );

	PendingCombatZone = NewCZ;
}
event SetCurrentCombatZone( CombatZone NewCZ )
{
	CurrentCombatZone = NewCZ;
}

/** Retrieve information about given pawn's cover */
final native function bool GetPlayerCover( GearPawn ChkPlayer, out CoverInfo out_Cover, optional bool bCanGuess );
/** Is the specified cover exposed to enemy fire? */
native final function bool IsCoverExposedToAnEnemy( CoverInfo TestCover, optional Pawn TestEnemy, optional out float out_ExposedScale );
/**
 * Returns TRUE if no combat zones assigned, or test cover is
 * in one of the zones
 */
final native function bool IsCoverWithinCombatZone( CoverInfo TestCover );
/**
 * Returns TRUE if no combat zones assigned, or test point is
 * in one of the zones
 */
final native function bool IsWithinCombatZone( Vector TestLocation );

final function bool IsEnemyWithinCombatZone( Actor InEnemy )
{
	local CoverInfo EnemyCover;
	local GearPawn GP;

	GP = GearPawn(InEnemy);
	// if we have a combat zone assigned make sure the enemy is within our combat zone before charging
	if(CombatZoneList.length > 0)
	{
		// check the enemy's cover first (to avoid doing an encompasses check on all combat zones)
		if(GP == none || !GP.IsInCover() || !GetPlayerCover(GP,EnemyCover,false))
		{
			if( !IsWithinCombatZone(InEnemy.Location) )
			{
				return false;
			}
		}
		else
		{
			// don't charge dudes who aren't in our combat zone
			if( !IsCoverWithinCombatZone(EnemyCover) )
			{
				return false;
			}
		}

	}

	return true;
}

/**
 *	It is valid to move directly to the given target
 *	Actor is reachable... children override for added checks
 */
function bool IsValidDirectMoveGoal( Actor A )
{
	if( NavigationHandle.ActorReachable(A)  )
	{
		return TRUE;
	}
	return FALSE;
}

/* 
 * Returns TRUE if any visible enemy around
 */
function bool IsAnyEnemyVisible()
{
	local int EnemyIdx;

	for ( EnemyIdx = 0; EnemyIdx < LocalEnemyList.Length; ++EnemyIdx )
	{
		if (LocalEnemyList[EnemyIdx].bVisible)
		{
			return TRUE;
		}
	}

	return FALSE;
}

/**
 * ===========
 * IDLE STATES
 * ===========
 */
function HandleIdleBoredom()
{
}

final function Pawn GetClosestEnemy()
{
	local Pawn P, Best;
	local float Dist, BestDist;

	BestDist = 1000000.0;
	foreach WorldInfo.AllPawns(class'Pawn', P)
	{
		if (!WorldInfo.GRI.OnSameTeam(P, self) && P.Controller != None && (P.Health > 0 || (GearPawn(P) != None && GearPawn(P).IsDBNO())))
		{
			Dist = VSize(P.Location - Pawn.Location);
			if (Dist < BestDist)
			{
				Best = P;
				BestDist = Dist;
			}
		}
	}
	return Best;
}
/** sets a move goal to the nearest enemy target. This uses the WorldInfo's PawnList, *NOT* the enemy list.
 * this is used for e.g. Invasion to keep the AI from getting lost in some unoccupied corner of the map
 */
function MoveToNearestEnemy()
{
	local Pawn Best;

	Best = GetClosestEnemy();
	if(Best != none)
	{
		SetMoveGoal(Best,, true, EnemyDistance_Short,,,,,TRUE);
	}
}

state Action_Idle `DEBUGSTATE
{
	function BeginState(Name PreviousStateName)
	{
		Super.BeginState( PreviousStateName );

		if( !IsAlert() && !HasAnyEnemies() )
		{
			InvalidateCover();	// Remove any cover setup
		}
		StopFiring();
		if(Pawn!=none)
		{
			Pawn.ZeroMovementVariables();
		}
	}

	function ContinuedState()
	{
		Super.ContinuedState();

		if( Pawn != None )
		{
			Pawn.ZeroMovementVariables();
			// if not in any combat
			if( !IsAlert() )
			{
				InvalidateCover();	// remove cover
			}
			StopFiring();
		}
	}

Begin:
	//debug
	`AILog( "BEGIN TAG"@PrintTetherInfo()@ShouldMoveToSquad(), 'State' );

	// make sure we have a squad
	if (Squad == None)
	{
		SetSquadName('Alpha');
	}

	// Select our weapon
	if( SelectWeapon() )
	{
		`AILog("Selected weapon");
		Sleep( 0.25f );
	}

	// check to see if someone needs reviving
	CheckReviveOrExecute(768.f);

	// check for a tether
	if( (Pawn != None) && !IsWithinTether( Pawn.Location ) )
	{
		`AILog("Not within tether, moving("$TetherDistance$")"@PrintTetherInfo()@(bReachedTether && NavigationPoint(GetTetherActor())!=None)@VSize2D(Pawn.Location - GetTetherLocation())@abs(Pawn.Location.Z - GetTetherLocation().Z));
		// Move to tether
		class'AICmd_MoveToTether'.static.MoveToTether( self, GetTetherLocation(), GetTetherActor() );
	}
	else
	// If we have enemies
	if( HasAnyEnemies() )
	{
		// Try to notice one which will put us into combat
		CheckNoticedEnemy();
		Sleep(1.f);
	}
	else
	if( IsSquadLeader() && Squad.SquadRoute != None )
	{
		// if this isn't the player squad, just run straight to the end of the route
		//`AILog("I'm the squad leader! Squad.bPlayerSquad: "$Squad.bPlayerSquad@Squad.GetSquadLeaderPosition());
		if(!Squad.bPlayerSquad)
		{
			SetRouteMoveGoal( Squad.SquadRoute );
		}
		else if(ShouldMoveToSquad()) // otherwise we need to move up with the player, so call getsquadleaderposition
		{
			SetMoveGoal(Squad.GetSquadLeaderPosition());
			if(bReachedMoveGoal)
			{
				LastSquadLeaderPosition = MoveGoal.Location;
			}
		}
		else
		{
			Sleep(2.0f);
		}
	}
	else
	// otherwise if we have no enemies but do have a squad
	if ( ShouldMoveToSquad() )
	{
MoveToSquad:
		//debug
		`AILog("Moving to squad...");

		// then move to the squad
		MoveToSquadPosition();

		// If no tether actor to clear
		if( bFailedToMoveToEnemy )
		{
			// Sleep to prevent recursive craziness
			Sleep( 2.f );
		}

		// If we shouldn't keep the tether
		if( !bKeepTether )
		{
			// Clear the tether so that we always update to a new one
			ClearTether();
		}
		bKeepTether = FALSE;

		// check to see if we should immediately move again
		if (!HasAnyEnemies() &&
			ShouldMoveToSquad())
		{
			//debug
			`AILog("Continuing move to squad");
			Sleep(0.1);

			Goto('MoveToSquad');
		}
		else
		{
			`AILog("Not continuing move to squad?"@HasAnyEnemies()@ShouldMoveToSquad());
		}
		Sleep(0.25f);
	}
	else if (bIdleMoveToNearestEnemy)
	{
		MoveToNearestEnemy();
		Sleep(1.0);
	}
	else
	{
		`AILog("Shouldn't move to squad, sleeping"@PrintTetherInfo()@MoveAction);
		Sleep(1.f);
	}
	Goto('Begin');
}

function OnAISetMood( SeqAct_AISetMood inAction )
{
	`AILog(GetFuncName()@self@inAction.PerceptionMood@inAction.CombatMood@inAction.MoveMood);
	NotifyDidSomethingInteresting();
	if( inAction.PerceptionMood != AIPM_None )
	{
		SetPerceptionMood( inAction.PerceptionMood, inAction.UnawareSightRadius );
	}
	if( inAction.CombatMood != AICM_None )
	{
		SetCombatMood( inAction.CombatMood );
	}
	if( inAction.MoveMood != AIMM_None )
	{
		SetMovementMood( inAction.MoveMood );
	}
}

final event SetPerceptionMood( EPerceptionMood NewMood, optional float UnawareSightRadius = -1.f )
{
	if( PerceptionMood != NewMood )
	{
		if( PerceptionMood == AIPM_Unaware || PerceptionMood == AIPM_Oblivious )
		{
			// If was unaware, and now is not... no walking
			Pawn.SetWalking( FALSE );
		}

		PerceptionMood = NewMood;

		Pawn.Alertness		  = Pawn.default.Alertness;
		Pawn.SightRadius	  = Pawn.default.SightRadius;
		Pawn.PeripheralVision = Pawn.default.PeripheralVision;
		Pawn.HearingThreshold = Pawn.default.HearingThreshold;

		Response_MinEnemySeenTime = default.Response_MinEnemySeenTime;
		Response_MinEnemyHearTime = default.Response_MinEnemyHearTime;

		// If unaware, decrease hearing and sight
		if( PerceptionMood == AIPM_Unaware )
		{
			Pawn.Alertness				= -0.5f;
			Pawn.SightRadius			=  (UnawareSightRadius < 0) ? 2048.f : UnawareSightRadius;
			Pawn.PeripheralVision		=  0.5f;
			Response_MinEnemySeenTime	= 2.f;
		}
		else
		if( PerceptionMood == AIPM_Oblivious )
		{
			Pawn.Alertness		  = -1.f;
			Pawn.HearingThreshold =  0.f;
			Pawn.SightRadius	  =  0.f;

		}
		else
		if( PerceptionMood == AIPM_Alert )
		{
			Pawn.Alertness	= 0.5f;
		}
	}
}

final event SetMovementMood( EAIMoveMood NewMood )
{
	if( MovementMood != NewMood )
	{
		MovementMood = NewMood;
	}
}

final function bool IsAlert()
{
	return (PerceptionMood == AIPM_Alert  ||
			CombatMood == AICM_Ambush ||
			`TimeSince(TimeLastHadContactWithEnemy) < 15.f ||
			IsSquadLeaderInCover() ||
			HasAnyEnemies());
}

final protected function CheckNoticedEnemy()
{
	local Pawn EnemyPawn;

	if( Squad != None )
	{
		foreach Squad.AllEnemies( class'Pawn', EnemyPawn )
		{
			NoticedEnemy( EnemyPawn );
			break;
		}
	}
}

function GoDBNO( Rotator AimRot )
{
	// Set pawn rotation based on how AI was aiming (ie 360 aiming, stops them from flipping around)

	SetDesiredRotation( AimRot );

	AbortCombatCommands();
	BeginCombatCommand( class'AICmd_DBNO', "Shot down in a blaze of glory!", TRUE );
}

/** called when our Pawn gets revived (@see GearPawn::DoRevival()) */
function PawnWasRevived()
{
	local AICmd_DBNO DBNOCmd;

	// find and remove the DBNO command
	DBNOCmd = FindCommandOfClass(class'AICmd_DBNO');
	if (DBNOCmd != None)
	{
		DBNOCmd.PawnWasRevived();
	}
}

/**
 *	Pass DBNO notification to squad for possible action
 */
final private function NotifySquadDBNO()
{
	if( Squad != None )
	{
		Squad.NotifyMemberDBNO( GearPawn(Pawn) );
	}
}

/**
 * Hook to handle AI doing a scripted special move.
 */
function HandleScriptedSpecialMove(ESpecialMove InSpecialMove, Actor InAlignActor,
										 optional GearPawn InInteractionPawn, optional int InSpecialMoveFlags,
										 optional vector InAlignOffset )
{
	local AICmd_PrepareSpecialMove PSM;
	`AILog(GetFuncName()@InSpecialMove@InAlignActor);
	QueuedSpecialMove = SM_None;

	PSM = AICmd_PrepareSpecialMove(GetActiveCommand());

	// If we're already doing the special move, update the flags
	if ( MyGearPawn.SpecialMove == InSpecialMove )
	{
		MyGearPawn.DoSpecialMove(InSpecialMove, TRUE, InInteractionPawn, InSpecialMoveFlags);
	}
	// Abort other special moves
	else if (PSM != none)
	{
		MyGearPawn.EndSpecialMove();
		AbortCommand(PSM);
	}
	if (InSpecialMove == SM_None)
	{
		MyGearPawn.EndSpecialMove();
	}
	else
	{
		QueuedSpecialMove = InSpecialMove;
		SpecialMoveAlignActor = InAlignActor;
		class'AICmd_PrepareSpecialMove'.static.PrepareSpecialMove(self, InInteractionPawn, InSpecialMoveFlags, InAlignOffset);
	}
}


function bool IsTransitioning()
{
	// Fail safe check to prevent getting stuck in transitioning loop
	if (WorldInfo.TimeSeconds - LastAnimTransitionTime > 1.5f)
	{
		return FALSE;
	}

	if( MyGearPawn != None )
	{
		//debug
		`AILog( GetFuncName()@MyGearPawn.bWantsToBeMirrored@MyGearPawn.bIsMirrored@MyGearPawn.DoingAnimationTransition() , 'Loop' );

		if( MyGearPawn.bWantsToBeMirrored != MyGearPawn.bIsMirrored )
		{
			return TRUE;
		}

		if( MyGearPawn.DoingAnimationTransition() )
		{
			return TRUE;
		}
	}

	return FALSE;
}

function ReceiveEvent(Name eventName)
{
	local AICmd_WaitingForEvent WaitCmd;
	local GameAICommand Cmd;

	for (Cmd = CommandList; Cmd != None; Cmd = Cmd.ChildCommand)
	{
		WaitCmd = AICmd_WaitingForEvent(Cmd);
		if (WaitCmd != None)
		{
			WaitCmd.ReceiveEvent(eventName);
		}
	}
}

/**
 * =============
 * COMBAT STATES
 * =============
 */

/** @return whether we should exit combat and return to the idle state, generally because we don't have any more enemies */
function bool ShouldReturnToIdle()
{
	return (Vehicle(Pawn) == None && !bMovingToGoal && !HasAnyEnemies());
}

/**
 * Check for an interrupt transition, can override any normal transition.
 */
function bool CheckInterruptCombatTransitions()
{
	local Pawn EnemyPawn;
	local GearPawn EnemyGP;
	local AICommand_Base_Combat	CurCommand;
	local float meleecheckdist;

	// If dead, DBNO, ignoring notifies don't bother
	if (Pawn == None || IsDead() || (MyGearPawn != None && MyGearPawn.IsDBNO()) || IgnoreNotifies())
	{
		return FALSE;
	}

	// check that our enemy is still valid
	if (Enemy != None && Enemy.Controller == None)
	{
		if (Enemy.DrivenVehicle != None)
		{
			SetEnemy(Enemy.DrivenVehicle);
		}
		else
		{
			SetEnemy(None);
		}
	}

	// If not in combat then don't bother
	CurCommand = AICommand_Base_Combat(CommandList);
	if( CurCommand == None )
	{
		return FALSE;
	}

	//debug
	`AILog( GetFuncName()@CommandList@bMovingToGoal@bReachedMoveGoal@MoveGoal@BP2Vect( MovePosition )@HasAnyEnemies(), 'Combat' );

	// see if we should discard our meat shield
	if ( MyGearPawn != None && MyGearPawn.IsAKidnapper() && WorldInfo.TimeSeconds - LastShotAtTime > 2.0 && !IsFiringWeapon() &&
		MyGearPawn.InteractionPawn != None && MyGearPawn.InteractionPawn.CanBeSpecialMeleeAttacked(MyGearPawn) )
	{
		`AILog("Get rid of meat shield" @ MyGearPawn.InteractionPawn);
		MyGearPawn.DoSpecialMove(SM_Kidnapper_Execution, true, MyGearPawn.InteractionPawn);
	}

	if (AICommand_Base_Combat(CommandList) != None && ShouldReturnToIdle())
	{
		BeginCombatCommand( None, "No Enemies" );
		return TRUE;
	}
	// when holding a meat shield we only melee off of Bump() notifications, since we're too slow to try to chase
	else if (MyGearPawn == None || !MyGearPawn.IsAKidnapper())
	{
		meleecheckdist = Max(EnemyDistance_Melee, EnemyDistance_MeleeCharge);
`if(`notdefined(FINAL_RELEASE))
		//debug
		`AILog( "-- check melee target"@CanEngageMelee()@HasEnemyWithinDistance(meleecheckdist, EnemyPawn, TRUE)@HasEnemyWithinDistance(meleecheckdist, EnemyPawn, FALSE)@meleecheckdist, 'Melee');
		//debug
		if (EnemyPawn != None)
		{
			`AILog( "Valid?"@EnemyPawn@IsValidMeleeTarget(GearPawn(EnemyPawn)), 'Melee' );
		}
`endif

		if ( CanEngageMelee() &&
			HasEnemyWithinDistance(meleecheckdist, EnemyPawn, true) &&		// Actually has an enemy in range
			HasEnemyWithinDistance(meleecheckdist, EnemyPawn, false) &&	// Thinks an enemy is in range
			IsValidMeleeTarget(GearPawn(EnemyPawn), true) &&
			// avoid enemies directly above and below
			Abs(Normal(EnemyPawn.Location - Location).Z) < 0.7 )
		{
			// return true even if we already have a valid melee in progress so that
			// a still valid melee command doesn't get clobbered early by the default combat command
			if (!CommandList.IsA('AICmd_Base_Melee'))
			{
				//BeginMeleeCommand( EnemyPawn, "Enemy within melee distance --"@EnemyDistance_Melee  );
				ReactionManager.NudgeChannel(EnemyPawn,'EnemyWithinMeleeDistance');
			}
			return TRUE;
		}
		else if (CommandList != None && GetActiveCommand().IsA('AICmd_Attack_Melee') && !CanEngageMelee())
		{
			// the act of performing a melee attack causes CanEngageMelee() to return false,
			// so if we got to that point, let the command terminate itself
			return true;
		}
		else if (MyGearPawn != None)
		{
			EnemyGP = GearPawn(EnemyPawn);
			if ( EnemyGP != None && EnemyGP.ShouldOtherEvadeMeInsteadOfMeleeing(MyGearPawn) && CanEvade(true) &&
				HasEnemyWithinDistance(EnemyDistance_Melee, EnemyPawn, true) )
			{
				EvadeAwayFromPoint(EnemyGP.Location);
			}
		}
	}
	// want a smaller value here since this isn't path dist and we want to make sure AI doesn't divert too much
	return CheckReviveOrExecute(GetReviveOrExecuteInterruptDist());
}

/** @return the distance at which we may interrupt an action to revive a teammate or execute an enemy */
function float GetReviveOrExecuteInterruptDist()
{
	return 1200.f;
}

/** Timer called function for initial check after combat action transition */
final function InitialCheckTimedCombatTransition()
{
	CheckTimedCombatTransition();
}

/**
 * Check for a timer based transition, may interrupt any current behavior.
 */
final function CheckTimedCombatTransition()
{
	local class<AICommand> NewCommand;
	local string Reason;
	local bool bTransition;
	local AICommand_Base_Combat	CurCommand;

	// Set timer to check normally
	CurCommand = AICommand_Base_Combat(CommandList);
	if( CurCommand == None )
	{
		return;
	}
	SetTimer( CurCommand.GetTransitionCheckTime(), FALSE, nameof(CheckTimedCombatTransition) );

	if( IgnoreTimeTransitions() )
	{
		return;
	}

	//debug
	`AILog(GetFuncName()@CommandList);

	// if no interrupt transition occurs
	bTransition = !CheckInterruptCombatTransitions();
	if( bTransition )
	{
		if( CurCommand.TimedTransitionCheck( NewCommand, Reason ) )
		{
			BeginCombatCommand( NewCommand, Reason );
		}
	}
}

/**
 * Check for a combat transition, called once the current behavior has completed.
 */
function CheckCombatTransition()
{
	local class<AICommand> NewCommand;
	local string Reason;
	local bool bTransition;
	local AICommand_Base_Combat CurCommand;

	if (Pawn == None || !bAllowCombatTransitions || IsDead() || (MyGearPawn != None && MyGearPawn.IsDBNO()))
	{
		return;
	}

	// don't allow interruptions for scripted moves
	if( !MoveIsInterruptable() && (bMovingToGoal || bMovingToCover))
	{
		//debug
		`AILog(GetFuncName()@"prevented by moveaction:"@MoveAction@"tether:"@PrintTetherInfo()@bMovingToGoal);
		return;
	}

	//debug
	`AILog( GetFuncName()@CommandList, 'Combat' );

	// First check for interrupt transitions
	bTransition = !CheckInterruptCombatTransitions();
	// If no interrupt occurred
	if( bTransition )
	{
		CurCommand = AICommand_Base_Combat(CommandList);
		if( CurCommand != None &&
			CurCommand.CheckTransition( NewCommand, Reason ) )
		{
			BeginCombatCommand( NewCommand, Reason );
		}
		else
		if( CurCommand == None && (CommandList == none || CommandList.Class != DefaultCommand))
		{
			NewCommand = GetDefaultCommand();
			if(NewCommand == none)
			{
				`log("WARNING! "$self$" has no default command specified!");
				return;
			}

			BeginCombatCommand(NewCommand, "No Command Specified");
		}
	}
}

function class<AICommand> GetDefaultCommand()
{
	return DefaultCommand;
}

/** Skip checking for timed combat action transitions */
function bool IgnoreTimeTransitions()
{
	//debug
	`AILog(GetFuncName()@"tether:"@PrintTetherInfo()@"move action:"@MoveAction@"spawner tether interruptable:"@bSpawnerTetherInterruptable);

	if( bPreparingMove ||
		CachedAICommandList == None ||
		CachedAICommandList.ShouldIgnoreTimeTransitions() ||
		!MoveIsInterruptable() ||
		IsInState('WaitingForEvent') ||
		IsDead() )
	{
		//debug
		`AILog("- ignoring time transitions");

		return TRUE;
	}

	if( IsReloading() ||
		IsSwitchingWeapons() )
	{
		return TRUE;
	}

	if( MyGearPawn != None &&
		MyGearPawn.IsDBNO() )
	{
		return TRUE;
	}

	return FALSE;
}


/**
 *	Checks that current move (if there is one) is interruptable
 */
final function bool MoveIsInterruptable(optional bool bForce)
{
	local bool bIsTetherUnbreakable;
	//`AILog(GetFuncName()@PrintTetherInfo()@ActiveRoute@bSpawnerTetherInterruptable@MoveAction@bForce);
	// If moving because of spawner and not interruptable

	bIsTetherUnbreakable = (IsTethered() && !bForce);
	if( (bIsTetherUnbreakable || ActiveRoute != none) && !bSpawnerTetherInterruptable )
	{
		return FALSE;
	}

	// If moving because of scripted sequence and not interruptable
	if( MoveAction != None && !MoveAction.bInterruptable )
	{
		return FALSE;
	}

	return TRUE;
}

/**
 * returns true if we're allowed to move (checks move action's tether distance 0 == don't move)
 */
final function bool AllowedToMove()
{
	return (MoveAction == None || MoveAction.TetherDistance != 0.0 || MoveIsInterruptable());
}

final function PlaySoundOnPlayer( SoundCue InSoundCue )
{
	local PlayerController PC;

	if( InSoundCue == None )
	{
		return;
	}

	foreach LocalPlayerControllers(class'PlayerController', PC)
	{
		if( PC != None &&
			PC.Pawn != None )
		{
			PC.Pawn.PlaySound( InSoundCue );
		}
	}
}

final function MessagePlayer( coerce String Msg )
{
	Pawn.MessagePlayer( Msg );
}

function OnAIToggleCombat(SeqAct_AIToggleCombat Action)
{
	local AICommand_Base_Combat	CurCommand;

	NotifyDidSomethingInteresting();
	if( Action.InputLinks[0].bHasImpulse )
	{
		bAllowCombatTransitions = TRUE;
	}
	else
	if( Action.InputLinks[1].bHasImpulse )
	{
		bAllowCombatTransitions = FALSE;
	}
	else
	{
		bAllowCombatTransitions = !bAllowCombatTransitions;
	}

	//debug
	`AILog( GetFuncName()@bAllowCombatTransitions );

	if( !bAllowCombatTransitions )
	{
		CurCommand = AICommand_Base_Combat(CommandList);
		if( CurCommand != None )
		{
			BeginCombatCommand( None, "Combat Transitions Disabled", TRUE );
			StopFiring();
		}
	}
	// If combat transitions were just enabled and we are in the Rat Truck, setup AI command again
	else if( Pawn != None && Vehicle_RatTruck_Base(Pawn.Base) != None )
	{
		Vehicle_RatTruck_Base(Pawn.Base).SetupAssaultRifleAI(self);
	}
}

function BanzaiAttack()
{
	GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_TransToKamikazeAI, Pawn);
	`AILog("Aborting command stack because we're going to banzai!");
	InvalidateCover();
	AbortCommand(CommandList);
	class'AICmd_Attack_Banzai'.static.Attack(self);
}

final function OnAIForceSwitchWeapon(SeqAct_AIForceSwitchWeapon Action)
{
	Local Weapon		Weap;

	NotifyDidSomethingInteresting();
	if(Action.bGoBackToNormalWeaponSelection)
	{
		ForcedWeapon = none;
		SelectWeapon();
		return;
	}

	Weap = Weapon(Pawn.FindInventoryType(Action.ForcedWeaponType));
	if( Weap == None )
	{
		Weap = Weapon(Pawn.CreateInventory( Action.ForcedWeaponType ));
	}
	ForcedWeapon = Weap;
	SelectWeapon();
}

function OnAIForceBanzaiCharge(SeqAct_AIForceBanzaiCharge Action)
{
	NotifyDidSomethingInteresting();
	if( Action.bMelee )
	{
		if(Action.MeleeTarget != none)
		{
			class'AICmd_Melee_Forced'.static.ForceMelee(self,Action.MeleeTarget);
		}
	}
	else
	{
		BanzaiAttack();
	}
}

final function UpdateMoods()
{
	// If in combat...
	if( AICommand_Base_Combat(CommandList) != None )
	{
		// Change moods if necessary
		if(	PerceptionMood == AIPM_Unaware   ||
			PerceptionMood == AIPM_Oblivious )
		{
			SetPerceptionMood( AIPM_Normal );
		}
	}
}


function BeginCombatCommand(class<AICommand> CmdClass, optional coerce string Reason, optional bool bForced)
{
	local class<AICommand_Base_Combat> CurClass;
	local AICommand_Base_Combat	CurCommand;
	local gearPC GPC;

	//debug
	`AILog( GetFuncName()@CmdClass@"("$CommandList$") --"@Reason@bForced );

	if (!IsAlert())
	{
		// beginning combat
		GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_EnteredCombat, Pawn);
	}

	if( CommandList != None )
	{
		CurCommand = AICommand_Base_Combat(CommandList);
		if( CurCommand != None )
		{
			CurClass = AICommand_Base_Combat(CommandList).Class;
		}
	}

	if( !bForced )
	{
		if( CmdClass != None && !bAllowCombatTransitions )
		{
			//debug
			`AILog( "Not allowing combat transition due to scripting" );
			return;
		}

		if( CommandList != None && !CommandList.AllowTransitionTo( CmdClass ) )
		{
			//debug
			`AILog( "Current command stack rejected transiton" );
`if(`notdefined(FINAL_RELEASE))
			DumpCommandStack();
`endif

			return;
		}
	}

	if( CurClass != CmdClass )
	{
		// Clear all cover goal info
		// (Absolutely necessary so special move code knows it will need to adjust to a slot first)
		ClearCoverGoal();
	}

	if( CmdClass != None && CmdClass != CurClass )
	{
		//debug
		`AILog("Transitioning to:"@CmdClass@"from:"@CurClass@"-- Reason"@Reason );
		`AILog("[TRANSITION]"@GetRightMost(CurClass)$"->"$GetRightMost(CmdClass)$":"@Reason );

		// tell guds
//		NewCombatAction.static.TriggerTransitionGUDSEvent(Pawn);

		LastActionTransitionTime = WorldInfo.TimeSeconds;
		// reset the damage counter
		DamageReceivedInAction = 0;
		StopFiring();
	}

	// If going from no combat to combat
	if( CurClass == None && CmdClass != None )
	{
		// If spawned by a factory
		if( SpawnFactory != None )
		{
			// Activate the "Entered Combat" output
			SpawnFactory.NotifyCombatEntered();
			// If locust team... set to Alert when enter combat
			if( GetTeamNum() == 1 )
			{
				SetPerceptionMood( AIPM_Alert );
			}
		}
		if(bDrawAIDebug)
		{
			foreach LocalPlayerControllers(class'GearPC', GPC)
			{
				if(GPC.DebugAICategories.Find('enteredcombat')>-1)
				{
					`log("DebugAI EnteredCombat: "@Pawn@Self@Pawn.Location@" just entered combat("@CmdClass@")!!");
					DrawDebugLine(GPC.Pawn.Location,Pawn.Location,255,255,0,TRUE);
					DrawDebugCoordinateSystem(Pawn.Location,Pawn.Rotation,100.f,TRUE);
					MessagePlayer("DebugAI EnteredCombat: "@Pawn@Self@Pawn.Location@" just entered combat("@CmdClass@")!!");
					break;
				}
			}
		}
	}

	if( CommandList != None )
	{
		AbortCommand( CommandList );
	}

	if( CmdClass != None )
	{
		CmdClass.static.InitCommand( self );

		// Update moods by timer to allow chance for flanked reactions/etc w/ Moods when it happened
		SetTimer( 0.1, FALSE, nameof(UpdateMoods) );
	}
	else
	{
		// see if we should discard our meat shield
		if ( MyGearPawn != None && MyGearPawn.IsAKidnapper() &&
			MyGearPawn.InteractionPawn != None && MyGearPawn.InteractionPawn.CanBeSpecialMeleeAttacked(MyGearPawn) )
		{
			`AILog("Get rid of meat shield" @ MyGearPawn.InteractionPawn);
			MyGearPawn.DoSpecialMove(SM_Kidnapper_Execution, true, MyGearPawn.InteractionPawn);
		}

		LastSquadLeaderPosition = vect(0,0,0);
		GotoState( 'Action_Idle', 'Begin' );
	}
}

function BeginMeleeCommandWrapper( Actor Inst, AIReactChannel OriginatingChannel )
{
	BeginMeleeCommand(Pawn(Inst),OriginatingChannel.ChannelName);
}

function BeginMeleeCommand( Pawn TargetPawn, optional coerce String Reason )
{
	local bool bSavedAllowCombatTransitions;

	if (AICmd_Base_Melee(CommandList) == None)
	{
		if (TargetPawn != None)
		{
			// force an update of this enemy's known info
			// but prevent ProcessStimulus() from recursively triggering a combat transition
			bSavedAllowCombatTransitions = bAllowCombatTransitions;
			bAllowCombatTransitions = false;
			ProcessStimulus( TargetPawn, PT_Force, 'BeginMeleeCommand' );
			bAllowCombatTransitions = bSavedAllowCombatTransitions;

			SetEnemy( TargetPawn );
		}

		BeginCombatCommand(MeleeCommand, Reason);
	}
}

event MoveUnreachable( Vector AttemptedDest, Actor AttemptedTarget )
{
	//debug
	`AILog(GetFuncName()@AttemptedDest@AttemptedTarget, 'Move');

	if( CachedAICommandList != None )
	{
		CachedAICommandList.MoveUnreachable( AttemptedDest, AttemptedTarget );
	}
}

event bool HandlePathObstruction( Actor BlockedBy )
{
	local Pawn BlockPawn;

	//debug
	`AILog( GetFuncName()@BlockedBy@`TimeSince(LastObstructionTime), 'Move' );

	LastObstructionTime = WorldInfo.TimeSeconds;
	BlockPawn = Pawn(BlockedBy);
	if( BlockPawn != None)
	{
		if( !IsFriendlyPawn( BlockPawn ) )
		{
			if( (CommandList == None || !CommandList.IsA( 'AICmd_Base_Melee' )) &&
				CanEngageMelee() &&
				IsValidMeleeTarget(GearPawn(BlockPawn)) )
			{
				// Smack him :)
				BeginMeleeCommand( BlockPawn, "Enemy obstructing path:"@BlockPawn );
			}

			return TRUE;
		}

		// Ignore obstructions from guys riding me
		if( BlockPawn.Base == Pawn ||
			Pawn.Base == BlockPawn )
		{
			return TRUE;
		}
	}

	if( CachedAICommandList != None )
	{
		return CachedAICommandList.HandlePathObstruction( BlockedBy );
	}
}
// Interface_navigationhandle - called when path edge is deleted that this controller is using
event NotifyPathChanged()
{
	ForcePauseAndRepath(none);
}

/** will cause AI to pause for a a bit and sets ReevaluatePath to true so if the AI is moving it will re-path */
event ForcePauseAndRepath( Actor InInstigator )
{
	`AILog(GetFuncName()@InInstigator);
	bReevaluatePath=true;
	NotifyNeedRepath();
	class'AICmd_Pause'.static.Pause(self,0.25);
}

function NotifyNeedRepath()
{
	if( CachedAICommandList != None )
	{
		CachedAICommandList.NotifyNeedRepath();
	}
}

function FireFromOpen(optional int InBursts = 1, optional bool bAllowFireWhileMoving=true)
{
	class'AICmd_Attack_FireFromOpen'.static.FireFromOpen(self, InBursts, bAllowFireWhileMoving);
}
function float AboutToFireFromOpen()
{
	local float Result;

	if (MyGearPawn != None && MyGearPawn.MyGearWeapon != None)
	{
		// FireFromOpen command already waits a minimum of 0.5, so subtract that
		Result = MyGearPawn.MyGearWeapon.GetAIAimDelay() - 0.5;
		MyGearPawn.SetWeaponAlert(Result);
	}

	return Result;
}

/** @return whether this AI's top command is one in which the AI is firing without moving (e.g. FireFromOpen/Cover) */
final function bool IsStationaryFiring()
{
	local AICommand TopCommand;

	TopCommand = AICommand(GetActiveCommand());
	return (TopCommand != None && TopCommand.bIsStationaryFiringCommand);
}

/** @return how long the AI should wait after choosing a cover action but before actually executing it
 * effectively, this is the reaction time between an opportunity to fire becoming available
 * and the AI acting on that opportunity
 */
function float GetPreFireFromCoverDelay()
{
	return 1.0;
}

/** @return how long the AI should wait after successfully firing from cover before considering other actions */
function float GetPostFireFromCoverDelay()
{
	return 1.0;
}

function NotifyFireLineBlocked()
{
	//debug
	`AILog(GetFuncName()@FireTarget@Enemy);

	bFailedToFireFromOpen  = TRUE;
	bFailedToFireFromCover = TRUE;
}

/**
 * Tether set from spawner when dealing with unique characters.
 */
final event SpawnerSetTether(Actor NewTether, optional bool bInterruptable)
{
	local Route RG;

	// Check if AI is shut down because of special move.
	if( MyGearPawn != None && MyGearPawn.SpecialMove != SM_None && MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove].bDisableAI )
	{
		return;
	}

	//debug
	`AILog(GetFuncName()@NewTether@bInterruptable);

	ClearMovementInfo( TRUE );
	bSpawnerTetherInterruptable = bInterruptable;

	RG = Route(NewTether);
	if( RG != None )
	{
		// set the route goal
		SetRouteMoveGoal( RG,,bInterruptable );
	}
	else
	{
		SetTether(NewTether.Location, NewTether,,,, bInterruptable);
		// make sure we make it there no matter what
		bTeleportOnTetherFailure = TRUE;
	}
}

protected function AbortCombatCommands()
{
	local AICommand_Base_Combat CurCommand;
	CurCommand = AICommand_Base_Combat(CommandList);
	if( CurCommand != None )
	{
		BeginCombatCommand( None, "Aborting combat commands", TRUE );
	}
}

protected function AbortMovementCommands()
{
	AbortCommand(None, class'AICmd_MoveToSquadLeader');
	AbortCommand(None, class'AICmd_MoveToRoute');
	AbortCommand(None, class'AICmd_MoveToEnemy');
	AbortCommand(None, class'AICmd_MoveToTether');
	AbortCommand(None, class'AICmd_MoveToCover');
	AbortCommand(None, class'AICmd_Move_SlotToSlot' );
	AbortCommand(None, class'AICmd_MoveToGoal_Mesh');
	AbortCommand(None, class'GameAICmd_Hover_MoveToGoal_Mesh');
}

function ClearMovementInfo(optional bool bSkipCombatZones = true)
{
	//debug
	`AILog( GetFuncName()@bSkipCombatZones );

	AbortMovementCommands();

	// clear any previous assignments
	MoveTarget  = None;
	ClearTether();

	// pick the first valid focus target
	ClearMoveAction();

	if( !bSkipCombatZones )
	{
		ClearCombatZones();
	}
}

function ClearMoveAction()
{
	`AILog(GetFUncName());
	if( Pawn != None )
	{
		Pawn.bIsWalking = FALSE;
	}
	bShouldRoadieRun = FALSE;

	MoveAction = None;
}

/** @return whether the AI wants to roadie run to join up with its leader
 * @note: this is a desireability test (do I want to do this?) NOT a functionality test (am I capable of doing this?)
 * the latter will be checked by MoveToGoal calling ShouldRoadieRun()
 */
function bool WantsToRoadieRunToLeader()
{
	return (HasAnyEnemies() || (GearPC(GetSquadLeader()) != None && GearPC(GetSquadLeader()).IsDoingSpecialMove(SM_RoadieRun)));
}


function bool ShouldRoadieRun()
{
	local bool bCanRoadieRun;
	local bool bCZRoadieRun;

	if( MyGearPawn == None )
	{
		return FALSE;
	}

	if( WalkVolume(MyGearPawn.PhysicsVolume) != None && WalkVolume(MyGearPawn.PhysicsVolume).bActive )
	{
		return FALSE;
	}

	// if we're capable of roadie running, and we're in a roadie run combat zone.. run run run!
	if ( CurrentCombatZone != None && CurrentCombatZone.MovementModeOverride == EMO_Fast &&
		(MyGearPawn.bCanRoadieRun || MyGearPawn.bCanBeForcedToRoadieRun) )
	{
		bCZRoadieRun = TRUE;
	}

	// if we're allowed to override bCanRoadieRun, or we can always roadie run
	bCanRoadieRun = MyGearPawn.bCanRoadieRun || (MyGearPawn.bCanBeForcedToRoadieRun && MoveAction != none && MoveAction.MovementStyle == EMS_Fast);

	if ( (bCZRoadieRun || bShouldRoadieRun || MovementMood == AIMM_Fast) && !MyGearPawn.bIsWalking && bCanRoadieRun && !MyGearPawn.bIsConversing &&
		!MyGearPawn.IsDBNO() && !MyGearPawn.IsCarryingAHeavyWeapon() && !MyGearPawn.IsAKidnapper() &&
		 (MyGearPawn.MyGearWeapon == None || MyGearPawn.MyGearWeapon.bAllowsRoadieRunning) )
	{
		if( bCZRoadieRun || MyGearPawn.IsInCover() ||
			MovementMood == AIMM_Fast ||
			MyGearPawn.IsDoingSpecialMove(SM_RoadieRunStab) ||
			(MoveTarget != None && VSizeSq(MoveTarget.Location - Pawn.Location) > 65536.0) ||
			//@FIXME: temp hack, need to update this for navmesh
			(NavigationHandle != None && NavigationHandle.CalculatePathDistance() > 256.0) )
		{
			return TRUE;
		}
	}

	return FALSE;
}

/**
 * Whether the AI wants to throw a grenade or not
 */
function bool WantsToThrowGrenade(GearWeap_GrenadeBase GrenadeWeap)
{
	local bool bAttackingKidnapper;
	local GearPC PC;
	local float DistEnemyToPlayer;

	// Don't throw damaging grenades when target is standing next to a friendly player
	// Looks dumb and is annoying to have friendly explosions around you
	if( GrenadeWeap.WeaponID != WC_SmokeGrenade && GetTeamNum() == TEAM_COG && Enemy != None && GearGameSP_Base(WorldInfo.Game) != None )
	{
		foreach WorldInfo.AllControllers( class'GearPC', PC )
		{
			if( PC.Pawn == None )
			{
				continue;
			}

			DistEnemyToPlayer = VSizeSq( Enemy.Location - PC.Pawn.Location );
			if( DistEnemyToPlayer < 65536.f ) /** 256^2 */
			{
				return FALSE;
			}
		}
	}


	if( `TimeSince(LastGrenadeTime) > GrenadeWeap.AI_TimeTweenGrenade && Enemy.Health > 100)
	{
		bAttackingKidnapper = (GearPawn(Enemy) != None && GearPawn(Enemy).IsAKidnapper());
		return (bAttackingKidnapper || IsAtCover());
	}
	else
	{
		return false;
	}
}

/** Stub functions */
function InvalidateCover( optional bool bUnclaimOnly, optional bool bFast );
function ClearCoverGoal();
event bool SetCombatMood(ECombatMood NewMood,optional Pawn MoodInstigator);
event bool IsAtCover();

function bool IsTetherOccupied(Actor Tether)
{
	local Pawn P, TetherPawn;
	local float Rad,Height;

	// If the tether is a Pawn or Controller, grab the Pawn
	TetherPawn = Pawn(Tether);
	if( TetherPawn == None && Controller(Tether) != None )
	{
		TetherPawn = Controller(Tether).Pawn;
	}

	Tether.GetBoundingCylinder(Rad,Height);

	// If Tether has no bounding cylinder, don't use 0 because it will cause us to return true if any pawns exist
	foreach WorldInfo.AllPawns(class'Pawn', P, Tether.Location, FMax(Rad, 0.01))
	{
		if( P != TetherPawn && P != MyGearPawn && P.Controller != none && P.Health > 0)
		{
			return true;
		}
	}

	return false;
}

/**
 * Handle scripted AI movement, figures out what the right thing to do is
 * based on the move targets.
 *
 *@warning: called by checkpoint code as well - assumes InputLinks are not checked and that the variables don't significantly change!
 */
function OnAIMove(SeqAct_AIMove Action)
{
	local Route RG;
	local CombatZone CZ;
	local bool bHasMove, bAllowMove;
	local int Idx;

	//debug
	`AILog("!! Received new move action"@Action@Action.TetherDistance);

	NotifyDidSomethingInteresting();

	if( MyGearPawn != none && MyGearPawn.IsAHostage() )
	{
		`AILog("IGNORING MOVE ORDER BECAUSE I'M A HOSTAGE!!!!!!!!!!!!!");
		return;
	}

	if( MyGearPawn != None && MyGearPawn.IsDBNO() )
	{
		// force the AI to get up
		BeginCombatCommand( None, "New move action" );
	}

	ClearMovementInfo(!Action.bClearCombatZonesOnAssign);

	// add the focus targets for look ats while moving (and possibly shooting)
	for( Idx = 0; Idx < Action.FocusTarget.Length; Idx++ )
	{
		if( Action.FocusTarget[Idx] != None )
		{
			Focus = Action.FocusTarget[Idx];
		}
	}

	`AILog("Setting move action to "@Action);
	// keep a reference to this action so the output can be activated later
	MoveAction = Action;

	if( MoveAction.MovementMood != AIMM_None )
	{
		SetMovementMood( MoveAction.MovementMood );
	}

	// check to see if we should allow the move based on the interruptable flag
	// - move if not allowed to interrupt, or not in combat
	bAllowMove = (!MoveAction.bInterruptable || !HasAnyEnemies());
	if( Action.MoveTargets.Length > 0)
	{
		`AILog(GetFuncName()@"AllowMove?"@bAllowMove@Action.MoveTargets.Length@Action.MoveTargets[0]);
	}
	else
	{
		`AILog(GetFuncName()@"AllowMove?"@bAllowMove@Action.MoveTargets.Length@"none");
	}


	// iterate through the move targets looking for valid move targets
	// NOTE: keep iterating through multiple in the case of multiple combat zone assignments
	for( Idx = 0; Idx < Action.MoveTargets.Length; Idx++ )
	{
		if( CoverGroup(Action.MoveTargets[Idx]) != None )
		{
			MessagePlayer( "COVERGROUPS ARE OBSOLETE - PLEASE REPLACE WITH COMBATZONES"@Action@Action.MoveTargets[Idx] );
			continue;
		}

		if( Action.MoveTargets[Idx] != None )
		{
			// Combat Zones can be assigned even if we can't move now
			CZ = CombatZone(Action.MoveTargets[Idx]);
			if( CZ != None )
			{
				//debug
				`AILog( "- adding combat zone:"@CZ );

				CombatZoneList[CombatZoneList.Length] = CZ;
			}
			else
			if( Interface_AIMoveOverride(Action.MoveTargets[Idx]) != None &&
				Interface_AIMoveOverride(Action.MoveTargets[Idx]).DoMoveOverride(self, Action) )
			{
				`AILog("- Move overridden by"@Action.MoveTargets[Idx]);
				bHasMove = TRUE;
			}
			else
			if( GameplayRoute(Action.MoveTargets[Idx]) != None )
			{
				if( Squad != None )
				{
					//debug
					`AILog( "- assign squad route"@Action.MoveTargets[Idx]@"for"@Squad.SquadName );

					Squad.SetSquadRoute( GameplayRoute(Action.MoveTargets[Idx]) );
				}
			}
			else
			// only check other types of move targets if we're allowed to actually move
			if( bAllowMove && !bHasMove )
			{
				RG = Route(Action.MoveTargets[Idx]);
				if (RG != None)
				{
					//debug
					`AILog("- setting route goal:"@RG);

					// set the route goal
					SetRouteMoveGoal( RG, Action.RouteDirection, Action.bInterruptable );
					// note that we have a move already
					bHasMove = TRUE;
				}
				// If this MoveTarget is not in AvailableTethers for this action, add it
				else if( Action.AvailableTethers.Find(Action.MoveTargets[Idx]) == INDEX_NONE )
				{
					Action.AvailableTethers.AddItem(Action.MoveTargets[Idx]);
				}
			}
			else
			{
				//debug
				`AILog( "Skip move input"@Action.MoveTargets[Idx]@"allow?"@bAllowMove@MoveAction.bInterruptable@HasAnyEnemies() );
			}
		}
	}

	// if we don't have a move yet, loop through our general tether list and pick one that is not occupied
	if( !bHasMove )
	{
		`AILog("no move yet.. find tether dest");

		// Sanity check for LastUsedTetherIdx
		if( Action.LastUsedTetherIdx < 0 || Action.LastUsedTetherIdx >= Action.AvailableTethers.length )
		{
			Action.LastUsedTetherIdx = 0;
		}

		// Start by looking at the AvailableTether after the last one that was used
		Idx = Action.LastUsedTetherIdx + 1;
		if( Idx >= Action.AvailableTethers.length )
		{
			Idx = 0;
		}

		while( Idx < Action.AvailableTethers.length )
		{
			// If we don't have any more tethers to check, use this one even if it's occupied
			if( !IsTetherOccupied(Action.AvailableTethers[Idx]) || Idx == Action.LastUsedTetherIdx )
			{
				`AILog("- setting tether:"@Action.AvailableTethers[Idx]);

				Action.LastUsedTetherIdx = Idx;
				SetTether( Action.AvailableTethers[Idx].Location, Action.AvailableTethers[Idx], Action.TetherDistance,,, MoveAction.bInterruptable );
				bHasMove = TRUE;
				break;
			}

			// Check next tether
			++Idx;
			if( Idx >= Action.AvailableTethers.length )
			{
				Idx = 0;
			}
		}
	}
	`AILog("HasMove Yet?"@bHasMove);

	// Sort after updates have been made
	SortCombatZones();

	// if a move wasn't issued (only assigned combat zones)
	if( !bHasMove )
	{
		if( bAllowMove && CombatZoneList.Length != 0 )
		{
			// then move to the zone
			if(!MoveToCombatZone() )
			{
				`AILog("Move to combat zone failed, clearing move action");
				ClearMoveAction();
			}
		}
		else
		{
			//debug
			`AILog("- clearing move action, since it's a combat zone assignment during combat");

			// already in combat, so clear the move action
			MoveAction.ReachedGoal( self );
			ClearMoveAction();
			// and tell the AI to look for cover soon
			AcquireCover = ACT_DesireBetter;
		}
	}
}

final function OnAIAbortMoveToActor( SeqAct_AIAbortMoveToActor Action )
{
	NotifyDidSomethingInteresting();
	AbortMovementCommands();
	ClearMovementInfo();
}

final function SortCombatZones()
{
	local CombatZone Zone, Other;
	local int		 ZoneIdx, HiIdx, Idx;
	local float		 HiPri, CurPri;

	for( Idx = 0; Idx < CombatZoneList.Length; Idx++ )
	{
		HiPri = 0.f;
		// Search for the highest priority zone
		for( ZoneIdx = 0; ZoneIdx < CombatZoneList.Length; ZoneIdx++ )
		{
			Zone = CombatZoneList[ZoneIdx];
			CurPri  = Zone.GetPriority( self );
			if( CurPri >= HiPri )
			{
				HiPri = CurPri;
				HiIdx = ZoneIdx;
			}
		}

		// Swap the hi priority with the current
		Other = CombatZoneList[Idx];
		CombatZoneList[Idx]	  = CombatZoneList[HiIdx];
		CombatZoneList[HiIdx] = Other;
	}

	//debug
	`AILog( GetFuncName()@"hi->lo", 'CombatZone' );
	for( Idx = 0; Idx < CombatZoneList.Length; Idx++ )
	{
		`AILog( ">>>>"@Idx@CombatZoneList[Idx]@CombatZoneList[Idx].ZoneName@CombatZoneList[Idx].GetPriority(self), 'CombatZone' );
	}
}

function bool GetMoveToCombatZoneLocation( out Vector out_Dest )
{
	class'NavMeshPath_AvoidFireFromCover'.static.AvoidFireFromCover( NavigationHandle);
	class'NavMeshPath_WithinCombatZone'.static.WithinCombatZone(NavigationHandle);
	class'NavMeshPath_Toward'.static.TowardPoint(NavigationHandle,CombatzoneList[0].ZoneCenter);
	class'NavMeshGoal_InCombatZone'.static.InCombatZone(NavigationHandle,self);
	class'NavMeshGoal_PolyEncompassesAI'.static.MakeSureAIFits(NavigationHandle);

	if( NavigationHandle.FindPath() )
	{
		out_Dest = NavigationHandle.PathCache_GetGoalPoint();
		return TRUE;
	}

	return FALSE;
}

event bool MoveToCombatZone()
{
	local Vector Dest;

	`AILog(GetFuncName()@CombatZoneList.length@CommandList);

	ClearMoveAction();

	if( GetMoveToCombatZoneLocation( Dest ) )
	{
		`AILog("Found path to combat zone.. moving");
		SetMovePoint( Dest,, FALSE,, TRUE );
		return TRUE;
	}
	else
	{
		//debug
		`AILog( "Failed to move to combat zone" );

		MoveAction = None;
	}

	return FALSE;
}


// used to add path constraints that we want on all the time.. for cover searches as well as normal path searches
function AddBasePathConstraints(bool bIsCoverSearch)
{
 	local vector LastMantleLoc;

 	// don't bother avoiding fire if we have a shield (meat or metal) - that's what we picked it up for
 	if (GetDifficultyLevel() > DL_Casual && (MyGearPawn == None || (!MyGearPawn.IsAKidnapper() && MyGearPawn.EquippedShield == None)))
 	{
 		class'NavMeshPath_AvoidFireFromCover'.static.AvoidFireFromCover(NavigationHandle);
 	}
// 	class'Path_AvoidanceVolumes'.static.AvoidThoseVolumes( Pawn );
	// keep from mantling too often
 	//	-don't pass lastmantle loc if we haven't mantled for a long time (e.g. we've been sitting in one spot next to our last mantle for a while)
 	if( MyGearPawn != None && `TimeSince(MyGearPawn.LastmantleTime) < 5.0)
 	{
 		LastMantleLoc = MyGearPawn.LastMantleLocation;
	}
 	class'NavMeshPath_MinDistBetweenSpecsOfType'.static.EnforceMinDist(NavigationHandle, MinDistBetweenMantles, NAVEDGE_Mantle, LastMantleLoc);
}

event bool GeneratePathTo( Actor Goal, optional float WithinDistance, optional bool bAllowPartialPath )
{
	if( NavigationHandle == None )
		return FALSE;

	AddBasePathConstraints(false);

	class'NavMeshPath_Toward'.static.TowardGoal( NavigationHandle, Goal );
	class'NavMeshGoal_At'.static.AtActor( NavigationHandle, Goal, WithinDistance, bAllowPartialPath );

	return NavigationHandle.FindPath();
}

// will move the destination around if it's too close to an obstacle and set out_Goal to moved loc
function bool GeneratePathToValidatedLocation( out Vector out_Goal, optional float WithinDistance, optional bool bAllowPartialPath )
{
	if( !NavigationHandle.ComputeValidFinalDestination(out_Goal) )
	{
		`AILog("Could not path to"@out_Goal@"it's too close to a wall, or outside the mesh!");
		return false;
	}

	return GeneratePathToLocation(out_Goal,WithinDistance,bAllowPartialPath);

}
event bool GeneratePathToLocation( Vector Goal, optional float WithinDistance, optional bool bAllowPartialPath )
{
	if( NavigationHandle == None )
	{
		return FALSE;
	}

	AddBasePathConstraints(false);

	class'NavMeshPath_Toward'.static.TowardPoint( NavigationHandle, Goal );
	class'NavMeshGoal_At'.static.AtLocation( NavigationHandle, Goal, WithinDistance, bAllowPartialPath );

	return NavigationHandle.FindPath();
}

/** Hack to get around const Anchor var */
native function AssignAnchor( Pawn P, NavigationPoint NewAnchor );

/** Find formation in squad near leader by walking the path network */
final function ComputeSquadFormationPositions(Controller Leader)
{
	local Actor LeaderPos;

	if (Leader == None || Leader.Pawn == None)
	{
		//debug
		`AILog( "No leader, no squad position updates" );
		return;
	}

	LeaderPos  = Squad.GetSquadLeaderPosition();
	if (LeaderPos != None)
	{
		// Clear out positions in the squad formation
		Squad.Formation.ClearPositions(LeaderPos);

		Leader.bOverrideSearchStart = TRUE;
		Leader.OverrideSearchStart = LeaderPos.Location;

		if (Leader.NavigationHandle.FindPylon())
		{
			class'NavMeshPath_WithinTraversalDist'.static.DontExceedMaxDist(Leader.NavigationHandle, GetTetherToLeaderDist() * 3.0, false);
			class'NavMeshGoal_SquadFormation'.static.SquadFormation(Leader.NavigationHandle, self, Squad.Formation);

			Leader.NavigationHandle.bSkipRouteCacheUpdates = true;
			Leader.NavigationHandle.FindPath();
			Leader.NavigationHandle.bSkipRouteCacheUpdates = false;
		}

		Leader.bOverrideSearchStart = FALSE;
	}
}

final function SetAcquireCover(EAcquireCoverType NewACT, optional coerce string Reason)
{
	if(!AllowedToMove())
	{
		`AILog(GetFuncName()@"Ignored because we are not currently allowed to move! (AllowedToMove() returned false)");
		return;
	}
	if (AcquireCover < NewACT || NewACT == ACT_None)
	{
		//debug
		`AILog( GetFuncName()@AcquireCover@"to"@NewACT@"--"@Reason );

		AcquireCover = NewACT;
	}
}

final native event bool IsTethered();
final native event Vector GetTetherLocation();
final native event Actor GetTetherActor();
final native event SetTetherInfo( Vector Pos, optional Actor BaseActor );
final native event ClearTether();
final event String PrintTetherInfo()
{
	return ""$GetTetherActor()$"["$GetTetherLocation()$"]";
}

/**
 * Sets the tether.
 */
function bool SetTether( Vector NewTetherLocation, Actor NewTetherActor, optional float NewTetherDistance, optional bool NewbDynamicTether, optional float NewTetherPersistDuration, optional bool bInteruptable, optional bool bIsValidCache )
{
	//debug
	`AILog( GetFuncName()@"NewTether:"@NewTetherLocation@NewTetherActor@"NewTetherDistance:"@NewTetherDistance@"NewbDynamicTether:"@NewbDynamicTether@"NewTetherPersistDuration:"@NewTetherPersistDuration@"bInteruptable:"@bInteruptable@"bIsValidCache:"@bIsValidCache );

	return class'AICmd_MoveToTether'.static.MoveToTether( self, NewTetherLocation, NewTetherActor, NewTetherDistance, NewbDynamicTether, NewTetherPersistDuration, bInteruptable, bIsValidCache );
}

/**
 * Returns TRUE if no using a tether, or point is within the tether.
 */
final native function bool IsWithinTether(vector TestPoint);

/** called on successful arrival at our tether */
function NotifyReachedTether(Actor ReachedTetherActor);
function float GetTetherMoveOffset(Actor TetherTarget)
{
	return 0.f;
}

final event SetMoveGoal( Actor NewMoveGoal, optional Actor NewMoveFocus,
						optional bool bInterruptable, optional float OffsetDist,
						optional bool bIsValidCache, optional bool bInCanPathfind = true,
						optional bool bForce, optional bool bAllowedToFire=true,
						optional bool bAllowPartialPath )
{
	`AILog(GetFuncName()@NewMoveGoal@NewMoveFocus@bInterruptable@OffsetDist@bIsValidCache@bInCanPathfind@bAllowedToFire@bAllowPartialPath, 'Move');
	if (NewMoveGoal != None)
	{
		if (NewMoveGoal != None && (MoveIsInterruptable(bForce) || !bInterruptable))
		{
			bReachedMoveGoal = false;
			bMoveGoalInterruptable = bInterruptable; //@FIXME: doesn't support stacking!
			MoveOffset = OffsetDist; //@FIXME: doesn't support stacking!
			class'AICmd_MoveToGoal_Mesh'.static.MoveToGoal(self, NewMoveGoal.GetDestination(self), NewMoveGoal, NewMoveFocus, bIsValidCache, bInCanPathfind, bAllowedToFire, bAllowPartialPath);
		}
		else if (NewMoveGoal != None)
		{
			`AILog(GetFuncName() @"!! -- ignoring movegoal because I already have a moveaction, which is non-interruptable, and the new movegoal IS interruptable.. trumped");
		}
	}
}

final function NotifySquadMembersLeaderMoveChanged()
{
	local GearAI	AI;
	local AICommand Cmd;

	`AIlog(GetFuncname()@Squad.Leader);
	if( Squad != None )
	{
		Squad.Formation.UpdatePositions();
		foreach Squad.AllMembers( class'GearAI', AI )
		{
			Cmd = AI.FindCommandOfClass( class'AICmd_MoveToSquadLeader' );
			if( Cmd != None )
			{
				AI.AbortCommand( Cmd );
			}
		}
	}
}

function SetMovePoint( vector NewMovePoint, optional Actor NewMoveFocus,
						 optional bool bInterruptable, optional float OffsetDist,
						 optional bool bIsValidCache, optional bool bAllowedToFire=TRUE,
						 optional bool bAllowPartialPath, optional bool bInCanPathfind = true )
{
	//debug
	`AILog( GetFuncName()@NewMovePoint@NewMoveFocus@bInterruptable@bAllowedToFire@`showvar(bAllowPartialPath) );

	bReachedMoveGoal = FALSE;
	bMoveGoalInterruptable = bInterruptable; //@FIXME: doesn't support stacking!
	MoveOffset = OffsetDist; //@FIXME: doesn't support stacking!

	if (!IsZero(NewMovePoint))
	{
		class'AICmd_MoveToGoal_Mesh'.static.MoveToGoal(self, NewMovePoint, None, NewMoveFocus, bIsValidCache, bInCanPathfind, bAllowedToFire, bAllowPartialPath);
	}
}

function SetRouteMoveGoal( Route NewRouteMoveGoal, optional ERouteDirection NewRouteDirection, optional bool bInterruptable = TRUE )
{
	//debug
	`AILog( "- setting route goal:"@NewRouteMoveGoal@NewRouteDirection );

	class'AICmd_MoveToRoute'.static.MoveToRoute( self, NewRouteMoveGoal, NewRouteDirection, bInterruptable );
}

/**
 * Start moving toward my current enemy
 * @param bCompleteMove - move all the way to my enemy
 * @param GoalDistance - how close to get to the enemy (only valid of bCompleteMove is TRUE)
 * @param AbandonDIstance - if enemy gets this far from us we should abandon the move
 * @param bAllowedToFire - self explanitory
 * @param bAlwaysFaceEnemy - if TRUE will always rotate toward enemy even while pathing in different directions
 */
final function SetEnemyMoveGoal(optional bool bCompleteMove,
								optional float GoalDistance=0.f,
								optional float AbandonDistance=0.f,
								optional bool bAllowedToFire=true,
								optional bool bAlwaysFaceEnemy=false)
{
	//debug
	`AILog( "- setting enemy goal Dist:"@GoalDistance@"bCompleteMove?"@bCompleteMove@"bAllowedToFire?"@bAllowedToFire);

	class'AICmd_MoveToEnemy'.static.MoveToEnemy( self, bCompleteMove, GoalDistance, AbandonDistance, bAllowedToFire, (bAlwaysFaceEnemy) ? Enemy: none );
}

final function MoveToSquadPosition()
{
	if( !class'AICmd_MoveToSquadLeader'.static.MoveToSquadLeader( self ) )
	{
		//debug
		`AILog( "ERROR: No leader for squad"@GetFuncName() );
		bFailedToMoveToEnemy = TRUE;
	}
}


/**
 * Culls out any paths beyond the specified distance.
 */
final function Actor LimitRouteCacheDistance(float MaxDist)
{
	local int Idx;
	local float Dist;
	local Actor LastAnchor;
	LastAnchor = Pawn;
	for (Idx = 0; Idx < RouteCache.Length; Idx++)
	{
		Dist += VSize(LastAnchor.Location - RouteCache[Idx].Location);
		LastAnchor = RouteCache[Idx];
		// if this puts beyond the distance
		if( Dist >= MaxDist )
		{
			// then remove the rest
			Idx++;
			RouteCache_RemoveIndex(Idx, RouteCache.Length - Idx);
			break;
		}
	}
	return LastAnchor;
}

/**
 * Calculates the total distance in the current route cache.
 */
final native function float GetRouteCacheDistance();

final function bool IsRoadieRunning()
{
	return (MyGearPawn != None && (MyGearPawn.IsDoingSpecialMove(SM_RoadieRun) || MyGearPawn.IsDoingSpecialMove(SM_CoverRun) || MyGearPawn.IsDoingSpecialMove(SM_RoadieRunStab)));
}

function bool AllowedToDoLeadInLeadOutWalk()
{
	return !IsInCombat()
		&& (CombatMood == AICM_None || CombatMood == AICM_Normal || CombatMood == AICM_Passive)
		&& (MoveAction == none || ( MoveAction.MovementStyle != EMS_Fast))
		&& MovementMood != AIMM_WithCover
		&& MovementMood != AIMM_Fast;
}


function float GetMoveTimeOutDuration(vector dest, bool bDoingLeadInOutWalk)
{
	local float dist;
	local float GroundSpeed;

	if(Pawn == none)
	{
		return 5.f;
	}

	GroundSpeed = Pawn.GroundSpeed;
	if(MyGearPawn != none)
	{
		GroundSpeed = MyGearPawn.DefaultGroundSpeed;
	}

	Dist = VSize(Pawn.Location - Dest);
	if (MyGearPawn != None && MyGearPawn.bIsCrawling)
	{
		GroundSpeed *= 0.33; // approximate guess since it's root motion
	}
	else if (Pawn.bIsWalking || bDoingLeadInOutWalk)
	{
		GroundSpeed *= Pawn.WalkingPct;
	}
	//`log("Dist: "@dist@"speed:"@GroundSpeed@"duration:"@Max(0.5f,2.0f * Dist / GroundSpeed)@pawn.bIsWalking@bDoingLeadInOutWalk);
	return FMax(0.5f,2.0f * (Dist / GroundSpeed));
}

final function TimedAbortMove()
{
	//debug
	`AILog( GetFuncName() );

	ClearMovementInfo( TRUE );
}

final function NavigationPoint GetLiftCenterExitHack()
{
	local array<NavigationPoint> NavList;
	local int Idx;
	local NavigationPoint BestNav;
	class'NavigationPoint'.static.GetAllNavInRadius(Pawn,Pawn.Location,384.f,NavList);
	// try to pick a reachable one
	for (Idx = 0; Idx < NavList.Length; Idx++)
	{
		if (LiftCenter(NavList[Idx]) == None && LiftExit(NavList[Idx]) == None && (ActorReachable(NavList[Idx]) || PointReachable(NavList[Idx].Location)))
		{
			BestNav = NavList[Idx];
		}
	}
	if (BestNav == None)
	{
		// pick the closest
		for (Idx = 0; Idx < NavList.Length; Idx++)
		{
			if (LiftCenter(NavList[Idx]) == None && LiftExit(NavList[Idx]) == None && Abs(NavList[Idx].Location.Z - Pawn.Location.Z) < 128.f)
			{
				/*
				if (BestNav == None ||
					VSize(BestNav.Location - Pawn.Location) > VSize(NavList[Idx].Location - Pawn.Location))
				{
					BestNav = NavList[Idx];
				}
				*/
			}
		}
	}
	return BestNav;
}

function bool CanTeleportToFriendlyOnPathFailure()
{
	return FALSE;
}

final function FailedToFindFallbackAnchor()
{
	// Haven't actually gotten a pawn yet
	if( Pawn == None )
		return;

	if( MoveAction != None && IsTethered() )
	{
		//debug
		`AILog(GetFuncName()@"attempting to teleport to tether actor");

		Pawn.SetLocation(GetTetherLocation() + vect(0,0,32));
		Pawn.SetMovementPhysics();
	}
	else
	if( CurrentTurret != None )
	{
		//debug
		`AILog( GetFuncName()@"attempting to teleport to turret entry location" );

		Pawn.SetLocation( CurrentTurret.GetEntryLocation() + vect(0,0,32) );
		Pawn.SetMovementPhysics();
	}
	else
	if (CanTeleportToFriendlyOnPathFailure())
	{
		//debug
		`AILog(GetFuncName()@"attempting to teleport to a friendly");

		if (!AttemptToTeleportToFriendly())
		{
			`AILog("- failed teleport, destroying");
			`Warn(self@"destroying because off of path network and can't find friendly to teleport to");
`if(`notdefined(FINAL_RELEASE))
			WorldInfo.Game.Broadcast(self,self@"destroying because off of path network and can't find friendly to teleport to");
`endif
			Destroy();
		}
	}
	else
	{
		//debug
		`AILog("destroying because off of path network and can't/won't find friendly to teleport to");
		`Warn(self@"destroying because off of path network and can't/won't find friendly to teleport to");

		GearPawn(Pawn).ScriptedDeath();
	}
}

function bool AttemptToTeleportToFriendly()
{
	local GearAI AI;
	local NavigationPoint ResNav;
	`AILog(GetFuncName());
	foreach WorldInfo.AllControllers(class'GearAI',AI)
	{
		if (AI != self &&
			AI.Pawn != None &&
			IsFriendly(AI))
		{
			ResNav = class'NavigationPoint'.static.GetNearestNavToActor(AI.Pawn,,,256.f);
			if(ResNav != none && TeleportToLocation(Resnav.Location,Pawn.Rotation))
			{
				`if(`notdefined(FINAL_RELEASE))
					`AILog("Teleporting to friendly"@AI);
					WorldInfo.Game.Broadcast(self,self@"was stuck off the path network, teleported to friendly:"@AI);
				`endif
				return TRUE;
			}
		}
	}
	return FALSE;
}

event bool TeleportToLocation(vector NewLoc, rotator NewRot, optional bool bCancelCombat = TRUE, optional bool bCancelMovement = TRUE )
{
	//debug
	`AILog( GetFuncName()@bCancelCombat@bCancelMovement@NewLoc );
	//DrawDebugLine(Pawn.Location,NewLoc,255,0,0,TRUE);
	//DrawDebugCoordinateSystem(NewLoc,rot(0,0,0),100.f,TRUE);

	NewLoc.Z += 32.f;
	if (Pawn != None &&
		Pawn.SetLocation(NewLoc))
	{
		if( Pawn.Physics == PHYS_RigidBody )
		{
			Pawn.Mesh.SetRBPosition( NewLoc );
		}

		RouteCache_Empty();

		if( bCancelMovement )
		{
			ClearMovementInfo(FALSE);
		}

		InvalidateCover();

		if( bCancelCombat && CommandList != None )
		{
			BeginCombatCommand( None, "Teleported" );
		}
		Pawn.SetRotation(NewRot);
		Pawn.SetMovementPhysics();
		Pawn.ZeroMovementVariables();
		return TRUE;
	}

	//debug
	`AILog( "TELEPORT FAILED?!" );

	return FALSE;
}

function EndOfMeleeAttackNotification();

function bool CanEngageMelee()
{
	if( MyGearPawn != None && !IsDead() && MoveIsInterruptable() )
	{
		return MyGearPawn.CanEngageMelee();
	}
	else
	{
		`AILog("Can't engage melee, dead:"@IsDead()@"interruptable?"@MoveIsInterruptable(), 'Melee' );
	}

	return FALSE;
}

/**
 * Scripting hook to move this AI to a specific actor.
 */
function OnAIMoveToActor( SeqAct_AIMoveToActor inAction )
{
	local array<Object> objVars, lookVars;
	local int Idx;

	//debug
	`AILog( "Received latent move action", 'Scripted' );

	NotifyDidSomethingInteresting();
	MyGearPawn.DoRevival(MyGearPawn);

	// abort any previous latent moves
	ClearLatentAction( class'SeqAct_AIMoveToActor', TRUE, inAction );
	ClearMoveAction();

	// find the destination
	inAction.GetObjectVars(objVars,"Destination");
	inAction.GetObjectVars(lookVars,"Look At");

	for( Idx = 0; Idx < objVars.Length; Idx++ )
	{
		// Kill cover claim b/c we are going to move away from it
		if( Actor(ObjVars[Idx]) != None )
		{
			InvalidateCover();
		}

		if (Controller(objVars[Idx]) != None &&
			Controller(objVars[Idx]).Pawn != None)
		{
			//debug
			`AILog("Moving to player:"@objVars[Idx],'Scripted');

			SetMoveGoal( Controller(objVars[Idx]).Pawn, None, inAction.bInterruptable, Pawn.GetCollisionRadius() );
			break;
		}
		else
		if (Actor(objVars[Idx]) != None)
		{
			//debug
			`AILog("Moving to actor:"@objVars[Idx],'Scripted');

			SetMoveGoal( Actor(objVars[Idx]), (lookVars.Length > 0) ? Actor(lookVars[0]) : None, inAction.bInterruptable );
			break;
		}
	}
}

/**
 * Overridden to redirect to pawn, since teleporting the controller
 * would be useless.
 */
simulated function OnTeleport(SeqAct_Teleport Action)
{
	//debug
	`AILog(GetFuncName() @ Action);

	// If we we are on a turret, get off
	if( Turret(Pawn) != None )
	{
		Turret(Pawn).DriverLeave(true);
	}

	NotifyDidSomethingInteresting();
	// Clear cover
	InvalidateCover();

	ClearMovementInfo(false);

	// Transition to Idle
	BeginCombatCommand(None, "Kismet Teleport");

	// Clear route list
	RouteCache_Empty();

	Pawn.ZeroMovementVariables();

	if (Action != None)
	{
		// Actually do the teleport
		Super.OnTeleport(Action);
	}

	SetFocalPoint(Pawn.Location + vector(Pawn.Rotation) * 1000.0);
}

simulated function OnToggleCinematicMode( SeqAct_ToggleCinematicMode Action )
{
	NotifyDidSomethingInteresting();
	//debug
	`AIlog( GetFuncName()@Action );

	if( !bCinematicMode &&
			(Action.InputLinks[0].bHasImpulse ||
			 Action.InputLinks[2].bHasImpulse) )
	{
		bCinematicMode = true;
		if( Action.bDisableMovement )
		{
			AbortMovementCommands();
			class'AICmd_WaitingForEvent'.static.Wait(self, 'OnToggleCinematicMode');
		}

		if (Action.bHidePlayer)
		{
			Pawn.SetHidden(TRUE);
		}

		if( MyGearPawn != None )
		{
			MyGearPawn.DoRevival(MyGearPawn);
		}
	}
	else
	if( bCinematicMode &&
			(Action.InputLinks[1].bHasImpulse ||
			 Action.InputLinks[2].bHasImpulse) )
	{
		bCinematicMode = false;
		if( Action.bDisableMovement )
		{
			ReceiveEvent('OnToggleCinematicMode');
		}
		Pawn.SetHidden(FALSE);
	}

	if( Pawn != None )
	{
		Pawn.SetCinematicMode( Pawn.bHidden );
	}
}

/**
 * Handles switching the player in/out of matinee mode.
 * This isn't same as Cinematic Mode.
 * Cinematic mode does hide hud or destroy all extra weapons for preparation
 * This one makes player to go matinee mode - disabling inputs
 * This doesn't just for matinee mode, but any special animation mode that you'd like to have this controller on
 */
function OnToggleMatineeMode(SeqAct_ToggleMatineeMode Action)
{
	NotifyDidSomethingInteresting();

	if (MyGearPawn==none)
	{
		`log( GetFuncName()@": MyGearPawn == none." );
		return;
	}

	MyGearPawn.OnToggleMatineeMode(Action);
}

simulated function TurnOnBehavior(bool bBehaviorOn)
{
	if (bBehaviorOn)
	{
		AbortCommand( None, class'AICmd_MatineeMode' );
	}
	else
	{
		class'AICmd_MatineeMode'.static.GotoCinematic( self , TRUE/*Action.TakeDamage*/ );
	}
}
/** get the difficulty/intelligence level to use for this AI */
final function EDifficultyLevel GetDifficultyLevel()
{
	return GearPRI(PlayerReplicationInfo).Difficulty.default.DifficultyLevel;
}

/**
 * ======
 * FIRING
 * ======
 */

/** @return how many bursts to fire while we're moving around, or < 0 to fire for the entire duration of the move */
function int GetNumBurstsToFireWhileMoving()
{
	return 1;
}

/** timer function called when we need to stop firing and then start again next frame */
final function DeferredStartFire()
{
	bFire = 1;
	bWeaponCanFire = true;
}

/**
 * Notify the weapon that it should begin firing when appropriate.
 */
event StartFiring(optional int InBurstsToFire = -1)
{
	//debug
	`AILog(GetFuncName() @ `showvar(bWeaponCanFire), 'Weapon');

	NotifyDidSomethingInteresting();

	// if we're already firing, stop briefly then start again so weapon params get set up correctly
	if (bFire == 1 && bWeaponCanFire)
	{
		StopFiring();
		SetTimer(0.01, false, nameof(DeferredStartFire));
	}
	else
	{
		bFire = 1;
		bWeaponCanFire = true;
	}

	// always set desired bursts to fire
	DesiredBurstsToFire = InBurstsToFire;
}

/**
 * Stops the weapon from firing anymore and prevents it from refiring until StartFiring() is called again.
 */
function StopFiring()
{
	//debug
	`AILog( GetFuncName(), 'Weapon' );

	bWeaponCanFire = FALSE;
	bFire = 0;
	bAltFire = 0;
	ClearTimer('StartFiring');
}

function StartMeleeAttack()
{
	NotifyDidSomethingInteresting();
	if( MyGearPawn != None )
	{
		bWeaponCanFire = TRUE;
		MyGearPawn.StartMeleeAttack();
	}
}

final function StopMeleeAttack()
{
	if( MyGearPawn != None )
	{
		bWeaponCanFire = FALSE;
		MyGearPawn.StopMeleeAttack();
	}
}

function bool IsFiringWeapon()
{
	local GearWeapon Weap;

	if( HasAnyEnemies() && HasValidTarget() && Pawn != None )
	{
		Weap = GearWeapon(Pawn.Weapon);
		if( Weap != None )
		{
			return (Weap.IsFiring() || Weap.IsInState('SpinningUp'));
		}
	}
	return FALSE;
}

/** @return whether the AI is currently mounting a heavy weapon */
final function bool IsMountingWeapon()
{
	local GearWeap_HeavyBase HeavyWeapon;

	HeavyWeapon = GearWeap_HeavyBase(Pawn.Weapon);
	return (HeavyWeapon != None && HeavyWeapon.IsBeingMounted());
}

/** @return rotator yaw units away from our desired aim rotation we can be and still fire our weapon */
function int GetCanFireFacingThreshold()
{
	// when using a suppressive weapon, allow spraying bullets as we rotate to track the target
	// when not, wait until we're reasonably close to our desired rotation (~1 degree)
	return IsUsingSuppressiveWeapon() ? 65536 : 182;
}
/**
 *	Tells if AI is able to fire the weapon or not
 */
function bool CanFireWeapon( Weapon Wpn, byte FireModeNum )
{
	local GearPawn GP;
	local GearWeapon GW;
	local int YawDiff;
	local float DistSqToFireTarget;

	if(Pawn == none)
	{
		return false;
	}

	// always allow reloading
	if (FireModeNum == class'GearWeapon'.const.RELOAD_FIREMODE)
	{
		return true;
	}
	// If AI doesn't want to fire - fail
	if( !bWeaponCanFire )
	{
		//debug
		`AILog( GetFuncName()@"Fail - AI doesn't want to fire", 'Weapon' );

		return FALSE;
	}
	// If pawn can't fire weapon - fail
	if( MyGearPawn != None && !MyGearPawn.CanFireWeapon() )
	{
		//debug
		`AILog( GetFuncName()@"Fail - pawn can't fire weapon", 'Weapon' );

		return FALSE;
	}
	// If active commands prevent firing - fail
	if( CachedAICommandList != None && !CachedAICommandList.IsAllowedToFireWeapon() )
	{
		//debug
		`AILog( GetFuncName()@"Fail - active commands prevent firing", 'Weapon' );

		return FALSE;
	}
	// If playing transition animations - fail
	if (MyGearPawn != None && (MyGearPawn.MyGearWeapon == None || !MyGearPawn.MyGearWeapon.bNoAnimDelayFiring) && IsTransitioning())
	{
		//debug
		`AILog( GetFuncName()@"Fail - playing transition animations", 'Weapon' );

		return FALSE;
	}
	if (FireModeNum != class'GearWeapon'.const.MELEE_ATTACK_FIREMODE)
	{
		// If AI has nothing to shoot at - fail
		if( FireTarget == None )
		{
			//debug
			`AILog( GetFuncName()@"Fail - AI has nothing to shoot at", 'Weapon' );

			return FALSE;
		}
		GP = GearPawn(FireTarget);
		if ( GP != None && GP.IsDBNO(,true) && VSize(GP.Location - Pawn.Location) > 256.0 &&
			!GearGame(WorldInfo.Game).CanBeShotFromAfarAndKilledWhileDownButNotOut(GP, Pawn, None) &&
			(MyGearPawn == None || MyGearPawn.MyGearWeapon == None || !MyGearPawn.MyGearWeapon.bIgnoresExecutionRules) )
		{
			`AILog(GetFuncName() @ "Fail - Would not harm DBNO enemy",'Weapon');
			return false;
		}

		if( GP != none && !GP.IsDBNO() && GP.Health <= 0)
		{
			`AILog(GetFuncName() @ "Fail - firetarget is dead",'Weapon');
			return false;
		}
		// if we have yet to rotate, fail unless using a suppressive weapon we can spray as we turn
		if (GearVehicle(Pawn) == None && GearWeaponPawn(Pawn) == None)
		{
			//@todo: use ReachedDesiredRotation() instead?
			if (Turret(Pawn) != None)
			{
				YawDiff = rotator(GetFocalPoint() - Turret(Pawn).GetPhysicalFireStartLoc(vect(0,0,0))).Yaw - GetPawnAimYaw();
			}
			else if (MyGearPawn != None && (MyGearPawn.IsInCover() || GearVehicleBase(MyGearPawn.Base) != None || GearPawnRidable_Base(MyGearPawn.Base) != None))
			{
				YawDiff = rotator(GetFocalPoint() - MyGearPawn.GetAimOffsetOrigin()).Yaw - GetPawnAimYaw();
			}
			else
			{
				YawDiff = rotator(GetFocalPoint() - Pawn.Location).Yaw - GetPawnAimYaw();
			}
			YawDiff = YawDiff & 65535;
			if (YawDiff > 32767)
			{
				YawDiff = Abs(YawDiff - 65536);
			}
			if (YawDiff > GetCanFireFacingThreshold())
			{
				`AILog(GetFuncName() @ "Fail - not facing target", 'Weapon');
				return false;
			}
		}
		// If fire line is blocked - fail
		if( !bForceFire && !IsFireLineClear() )
		{
			//debug
			`AILog( GetFuncName()@"Fail - fire line is blocked", 'Weapon' );

			return FALSE;
		}

		if( !WorldInfo.GRI.IsMultiplayerGame() )
		{
			GW = GearWeapon(Wpn);
			if( GW != None && GW.bMustBeInRangeToFire )
			{
				DistSqToFireTarget = VSizeSq(Pawn.Location-FireTarget.Location);
				if( DistSqToFireTarget > EnemyDistance_Long * EnemyDistance_Long )
				{
					return FALSE;
				}
			}
		}
	}

	return TRUE;
}

event bool IsFireLineClear()
{
	if(Pawn == none)
	{
		return false;
	}

	return (!IsFriendlyBlockingFireLine() && CanFireAt(FireTarget, Pawn.GetWeaponStartTraceLocation()));
}

/**
 *	Returns TRUE if a friendly pawn is blocking our fire line
 */
final function bool IsFriendlyBlockingFireLine()
{
	local Controller C;
	local Vector FireLine, FireStart, VectToFriendly;
	local float	 FireLineWidth, DistFromLine;
	local GearPawn P;

	if( Pawn == None )
	{
		return FALSE;
	}

	if ( FireTarget == None )
	{
		FireTarget = Enemy;
	}
	if ( FireTarget == None )
	{
		return FALSE;
	}

	FireStart = Pawn.GetWeaponStartTraceLocation();
	FireLine  = Normal(FireTarget.Location-FireStart);
	FireLineWidth = 48.f;

	//@note: use of team check here instead of IsFriendly() is intentional; in cases where the Locust and Lambent may fight together
	//	(e.g. Horde) we still want them to have a disregard for the safety of the other
	foreach WorldInfo.AllControllers( class'Controller', C )
	{
		if( C != self &&
			C.Pawn != None &&
			C.Pawn.Health > 0 &&
			WorldInfo.GRI.OnSameTeam(C, self) &&
			C.Pawn.Base != Pawn &&
			C.Pawn != Pawn.Base )
		{
			P = GearPawn(C.Pawn);
			if( (P != None) && (P.IsDBNO() || P.IsAHostage()))
			{
				continue;
			}

			VectToFriendly = Normal( C.Pawn.Location - FireStart );
			if( (VectToFriendly DOT FireLine) > 0.f )
			{
				DistFromLine = FMin( PointDistToLine( C.Pawn.GetPawnViewLocation(), FireLine, FireStart ),
					PointDistToLine( C.Pawn.Location, FireLine, FireStart ) );
				if( DistFromLine < FireLineWidth &&
					VSizeSq(C.Pawn.Location - Pawn.Location) < VSizeSq(FireTarget.Location - Pawn.Location))
				{
					//debug
					`AILog( C.Pawn@"Blocking"@Pawn @DistFromLine@FireLineWidth, 'WeaponFiring' );

					return TRUE;
				}
			}
		}
	}

	return FALSE;
}

function bool ShouldAutoReload()
{
	return (MyGearPawn == None || !MyGearPawn.bWantsToMelee);
}

/** called when about to or already firing a weapon to check if we should do a blind fire action */
final function bool CheckBlindFire()
{
	// see if we should transition to blindfiring
	if( MyGearPawn != None && MyGearPawn.IsInCover() && MyGearPawn.CoverAction == CA_Default && !MyGearPawn.bDoing360Aiming && MyGearPawn.bCanBlindFire )
	{
		if (MyGearPawn.CurrentLink.Slots[MyGearPawn.CurrentSlotIdx].bCanPopUp && MyGearPawn.CoverType == CT_MidLevel)
		{
			MyGearPawn.SetCoverAction(CA_BlindUp);
			return true;
		}
		else if (MyGearPawn.CurrentLink.Slots[MyGearPawn.CurrentSlotIdx].bLeanLeft)
		{
			MyGearPawn.SetCoverAction(CA_BlindLeft);
			return true;
		}
		else if (MyGearPawn.CurrentLink.Slots[MyGearPawn.CurrentSlotIdx].bLeanRight)
		{
			MyGearPawn.SetCoverAction(CA_BlindRight);
			return true;
		}
		else
		{
			return false;
		}
	}
	else
	{
		return false;
	}
}

function NotifyWeaponFired( Weapon W, byte FireMode )
{
	CheckBlindFire();

	if( GearWeap_GrenadeBase(W) != None )
	{
		// record the last time a grenade was thrown so that the AI doesn't spam them
		LastGrenadeTime = WorldInfo.TimeSeconds;
	}
}


final function bool IsUsingSuppressiveWeapon()
{
	local GearWeapon Wpn;

	if (Pawn != None)
	{
		Wpn = GearWeapon(Pawn.Weapon);
	}
	return (Wpn != None && Wpn.IsSuppressive());
}

/** @return whether the specified line hits a deployed shield. Used with some weapon checks where we don't want to hit
 * most dynamic Actors but do want to hit shields.
 */
final function bool IsBlockedByDeployedShield(vector StartTrace, vector EndTrace)
{
	local int i;
	local GearGame Game;
	local vector HitLocation, HitNormal;

	Game = GearGame(WorldInfo.Game);
	for (i = 0; i < Game.DeployedShields.length; i++)
	{
		if (Game.DeployedShields[i] != None)
		{
			if (TraceComponent(HitLocation, HitNormal, Game.DeployedShields[i].ShieldMeshComp, EndTrace, StartTrace))
			{
				return true;
			}
		}
		else
		{
			Game.DeployedShields.Remove(i--, 0);
		}
	}

	return false;
}

/**
 * Returns TRUE if we can fire at the specified player,
 * either directly or at their current cover position.
 */
final event bool CanFireAt( Actor ChkTarget, Vector ViewPt, optional bool bUseRotation, optional GearWeapon weap )
{
	local Vector TestLocation;
	local Pawn	 TestPawn;
	local GearPawn TestGP;
	local Rotator Rot;
	local float Height,Rad;

	if(Pawn == none)
	{
		return false;
	}

	if( ChkTarget == None )
	{
		return FALSE;
	}

	// Make sure this pawn is a valid fire target
	TestGP = GearPawn(ChkTarget);
	if( TestGP != None && TestGP.bInvalidFireTarget )
	{
		return FALSE;
	}

	TestPawn = Pawn(ChkTarget);
	if( TestPawn != None )
	{
		TestLocation = GetAimLocation( ViewPt, FALSE, ChkTarget );
	}
	else
	{
		TestLocation = ChkTarget.Location;

		ChkTarget.GetBoundingCylinder(Rad,Height);
		if(ChkTarget.bCollideActors)
		{
			// pull back a bit so we don't collide with the object itself and think we can't see it
			TestLocation += Normal(ViewPt - ChkTarget.Location) * Rad * 1.5f;
		}

	}

	if( bUseRotation )
	{
		Rot = Pawn.Rotation;
	}
	else
	{
		Rot = Rotator(TestLocation-ViewPt);
	}

	if(Weap == none)
	{
		Weap = GearWeapon(Pawn.Weapon);
	}
	return (Weap != None) ? Weap.CanHit(ViewPt, TestLocation, Rot) : CanSeeByPoints(ViewPt, TestLocation, Rot);
}

/** assuming the passed in target is visible, figure out the best location on it to target
 * by world tracing to various desireable points
 * this is primarily for enemies in cover, where the best location to shoot depends on
 * how exposed the enemy is to us, their current cover action, etc
 * @return best location to fire our weapon at
 */
final function vector GetBestAimLocationForVisibleTarget(vector StartLoc, Pawn TargetPawn)
{
	local vector TestLocs[4], SideDir, Center, Offset, HitLocation, HitNormal;
	local int TestNum, i;
	local bool bSniping;
	local GearPawn TargetGP;
	local byte MissedTurretLoc[4];

	// when in a turret, redirect to driver since he's shootable
	if (Turret(TargetPawn) != None && Turret(TargetPawn).Driver != None)
	{
		TargetPawn = Turret(TargetPawn).Driver;
	}

	// add head first if sniping or if enemy has a shield (since almost everywhere else will be covered)
	TargetGP = GearPawn(TargetPawn);
	if ( bCanHeadShot && TargetGP != None && TargetGP.HeadBoneNames.length > 0 &&
		(MyGearPawn == None || MyGearPawn.bIsTargeting || MyGearPawn.IsInCover()) &&
		( TargetGP.IsAKidnapper() || TargetGP.IsCarryingShield() ||
			(MyGearPawn != None && MyGearPawn.MyGearWeapon != None && MyGearPawn.MyGearWeapon.bSniping) ) )
	{
		bSniping = true;
		TestLocs[TestNum++] = TargetGP.Mesh.GetBoneLocation(TargetGP.HeadBoneNames[0]);
	}

	// center/chest
	if (TargetGP != None && !TargetGP.IsDBNO() && TargetGP.TorsoBoneName != '')
	{
		Center = TargetGP.Mesh.GetBoneLocation(TargetGP.TorsoBoneName);
		TestLocs[TestNum++] = Center;
	}
	else if (TargetGP == None)
	{
		Offset.Z = TargetPawn.GetCollisionHeight() * 0.45f;
		Center = TargetPawn.Location + Offset;
		TestLocs[TestNum++] = Center;
	}
	else
	{
		Center = TargetPawn.Location;
	}

	// sides
	SideDir = (Normal(TargetPawn.Location - StartLoc) Cross vect(0,0,1)) * TargetPawn.GetCollisionRadius();
	if (TargetGP != None)
	{
		TestLocs[TestNum++] = TargetGP.Mesh.GetClosestCollidingBoneLocation(Center + SideDir, true, false);
		TestLocs[TestNum++] = TargetGP.Mesh.GetClosestCollidingBoneLocation(Center - SideDir, true, false);
	}
	else
	{
		TestLocs[TestNum++] = TargetPawn.Location + SideDir;
		TestLocs[TestNum++] = TargetPawn.Location - SideDir;
	}

	// add head last if not sniping
	if (!bSniping && TargetGP != None && TargetGP.HeadBoneNames.length > 0)
	{
		TestLocs[TestNum++] = TargetGP.Mesh.GetBoneLocation(TargetGP.HeadBoneNames[0]);
	}

	// if we should lead target, move all locations by the target's predicted movement in the time it will take the projectile to travel there
	if (!IsZero(TargetPawn.Velocity) && GearWeapon(Pawn.Weapon) != None && GearWeapon(Pawn.Weapon).bLeadTarget)
	{
		Offset = Pawn.Weapon.WeaponProjectiles[0].static.StaticGetTimeToLocation(TargetPawn.Location, StartLoc, self) * TargetPawn.Velocity;
		if (Trace(HitLocation, HitNormal, TargetPawn.Location + Offset, TargetPawn.Location, false) != None)
		{
			Offset = HitLocation - TargetPawn.Location;
		}
		for (i = 0; i < TestNum; i++)
		{
			TestLocs[i] += Offset;
		}
	}

	// if in an indestructible vehicle with exposed driver, prioritize shot locations that hit the driver
	if (TargetPawn.DrivenVehicle != None && !TargetPawn.DrivenVehicle.bCanBeDamaged && TargetPawn.bCollideActors)
	{
		for (i = 0; i < TestNum; i++)
		{
			if (!TraceComponent(HitLocation, HitNormal, TargetPawn.DrivenVehicle.Mesh, TestLocs[i], StartLoc,,, true))
			{
				MissedTurretLoc[i] = 1;
				if (FastTrace(TestLocs[i], StartLoc,, true))
				{
					return TestLocs[i];
				}
			}
		}

		// only check locations that have MissedTurretLoc[i] = 0, otherwise we already know FastTrace() failed
		for (i = 0; i < TestNum; i++)
		{
			if (MissedTurretLoc[i] == 0 && FastTrace(TestLocs[i], StartLoc,, true))
			{
				return TestLocs[i];
			}
		}
	}
	else
	{
		for (i = 0; i < TestNum; i++)
		{
			if (FastTrace(TestLocs[i], StartLoc,, true))
			{
				return TestLocs[i];
			}
		}
	}


	return GetEnemyLocation(TargetPawn);
}

/** figures out where the AI should aim to hit its target
 * @param StartLoc - where the weapon fire comes from
 * @param bActuallyFiring - set when this function is being called as part of actually firing a shot (not just visual stuff)
 * @return target vector
 */
event vector GetAimLocation(vector StartLoc, optional bool bActuallyFiring, optional Actor AimTarget )
{
	local vector AimLoc, Diff, SlotLoc, TestLoc;
	local GearPawn GP;
	local Pawn TargetPawn;
	local CoverInfo KnownEnemyCover;
	local GearWeapon MyGearWeap;
	local ECoverAction GuessCoverAction;

	if (AimTarget == None)
	{
		AimTarget = FireTarget;
	}

	TargetPawn = Pawn(AimTarget);
	if (TargetPawn == None)
	{
		if (Interface_AIAimLocationOverride(AimTarget) == None || !Interface_AIAimLocationOverride(AimTarget).OverrideAimLocation(AimLoc, StartLoc, self))
		{
			AimLoc = AimTarget.Location;
		}
	}
	else
	{
		GP = GearPawn(TargetPawn);
		// if we are actually firing at a visible enemy, do more expensive test for best target location
		if (bActuallyFiring && TimeSinceLastSeenEnemy(TargetPawn, true) < 1.0)
		{
			if ( Interface_AIAimLocationOverride(TargetPawn) == None ||
				!Interface_AIAimLocationOverride(TargetPawn).OverrideAimLocation(AimLoc, StartLoc, self) )
			{
				AimLoc = GetBestAimLocationForVisibleTarget(StartLoc, TargetPawn);
			}
		}
		else
		{
			// if we are targeting an enemy that is in cover relative to us, we need to shoot at a likely popup/lean location instead of their actual location,
			// even if a squadmate has visibility to their exact loc, because we can't actually target that location
			KnownEnemyCover = Squad.GetEnemyCover(TargetPawn);
			if (KnownEnemyCover.Link != None)
			{
				// very slight cheat here: assume the AI saw the last time the enemy poked their head out
				if (GP.PreviousCoverAction != CA_Default)
				{
					GuessCoverAction = GP.PreviousCoverAction;
				}
				else if (KnownEnemyCover.Link.Slots[KnownEnemyCover.SlotIdx].bCanPopUp)
				{
					GuessCoverAction = CA_PopUp;
				}
				else if (KnownEnemyCover.Link.Slots[KnownEnemyCover.SlotIdx].bLeanLeft)
				{
					GuessCoverAction = CA_LeanLeft;
				}
				else if (KnownEnemyCover.Link.Slots[KnownEnemyCover.SlotIdx].bLeanRight)
				{
					GuessCoverAction = CA_LeanRight;
				}
				// else GuessCoverAction = CA_Default implied by zero init

				if (GuessCoverAction != CA_Default)
				{
					AimLoc = KnownEnemyCover.Link.GetSlotViewPoint(KnownEnemyCover.SlotIdx, KnownEnemyCover.Link.Slots[KnownEnemyCover.SlotIdx].CoverType, GuessCoverAction);
				}
				else
				{
					AimLoc = GetEnemyLocation(TargetPawn);
				}
			}
			else
			{
				AimLoc = GetEnemyLocation(TargetPawn);
			}
		}
	}

	if (GP != None)
	{
		MyGearWeap = GearWeapon(Pawn.Weapon);
		// aim down a little further against DBNO enemies
		if (GP.IsDBNO())
		{
			AimLoc.Z = FMin(AimLoc.Z, GP.Location.Z - 20.0);
		}
		else if ( (!GP.IsInCover() || GP.FindCoverType() != CT_MidLevel) &&
				 MyGearWeap != None && MyGearWeap.bHose )
		{
			AimLoc.Z -= GP.GetCollisionHeight() * 0.5f;
		}
		// if the AI is shooting at an enemy hiding in cover, nudge the aim location a little towards
		// the enemy's real location so they're more likely to get some shots hitting the cover
		else if ( bActuallyFiring && GP.IsInCover() && GP.CoverAction == CA_Default &&
			(TimeSinceLastSeenEnemy(TargetPawn, true) >= 1.0 || WorldInfo.TimeSeconds - GP.LastCoverActionTime <= 1.0) &&
			GP.IsProtectedByCover(Normal(AimLoc - StartLoc)) )
		{
			KnownEnemyCover = Squad.GetEnemyCover(GP);
			if (KnownEnemyCover.Link != None)
			{
				Diff = GP.Location - AimLoc;
				if (KnownEnemyCover.Link.Slots[KnownEnemyCover.SlotIdx].CoverType == CT_MidLevel)
				{
					AimLoc.Z += Diff.Z * 0.4;
				}
				else
				{
					SlotLoc = KnownEnemyCover.Link.GetSlotLocation(KnownEnemyCover.SlotIdx);
					Diff = AimLoc - SlotLoc;
					Diff.Z = 0.0;
					Diff = Normal(Diff) * RandRange(17.0, 21.0); // approx dist to edge of most cover from edge slot
					AimLoc.X = SlotLoc.X + Diff.X;
					AimLoc.Y = SlotLoc.Y + Diff.Y;
				}
			}
		}
		// if we should consider splash damage and the enemy is not in cover, aim at feet instead
		else if (MyGearWeap != None && MyGearWeap.bRecommendSplashDamage && GetEnemyCover(GP).Link == None)
		{
			KnownEnemyCover = Squad.GetEnemyCover(GP);
			TestLoc = AimLoc;
			TestLoc.Z -= GP.GetCollisionHeight() * 0.85;

			if (FastTrace(TestLoc, StartLoc,, true))
			{
				AimLoc = TestLoc;
			}
		}
		else if (bActuallyFiring && MyGearWeap != None && TimeSinceLastSeenEnemy(TargetPawn, true) > 0.5)
		{
			MyGearWeap.AdjustAIAimLocWhenCantSeeEnemy(AimLoc);
		}
	}
	return AimLoc;
}

function rotator GetAdjustedAimFor(Weapon W, vector StartFireLoc)
{
	if(CachedAICommandList != None)
	{
		return CachedAICommandList.GetAdjustedAimFor(W, StartFireLoc);
	}

	return DefaultGetAdjustedAimFor(W, StartFireLoc);
}

/** @return the aim error for shooting at our current FireTarget in degrees of yaw */
event float GetAimError(vector TargetLocation)
{
	local float AimError, InaccuracyPct, Pct, TargetDist;
	local GearWeapon Wpn;
	local GearPawn EnemyPawn;
	local GearMapSpecificInfo MapInfo;

	AimError = BaseAimError;
	// look for a weapon specific modifier
	Wpn = GearWeapon(Pawn.Weapon);
	if (Wpn != None)
	{
		AimError += Wpn.AdditionalAimError;
	}
	// if we can't really see the enemy due to fog or whatever, increase error
	MapInfo = GearMapSpecificInfo(WorldInfo.GetMapInfo());
	TargetDist = VSize(TargetLocation - Pawn.Location);
	if (MapInfo != None && MapInfo.VisibilityModifier < 1.0 && TargetDist > Pawn.SightRadius * 0.75 * MapInfo.VisibilityModifier)
	{
		AimError *= (TargetDist > Pawn.SightRadius * MapInfo.VisibilityModifier) ? 4.0 : 2.0;
	}

	if (ForcedAccuracy > 0.0)
	{
		InaccuracyPct = 1.0 - ForcedAccuracy;
	}
	else
	{
		EnemyPawn = GearPawn(FireTarget);

		// Assume standing accuracy to start
		InaccuracyPct = AI_Base_Acc_Standing;
		if (MyGearPawn != None && MyGearPawn.CoverType != CT_None)
		{
			// If AI has been in cover for a bit, assume they are targeting
			if (WorldInfo.TimeSeconds - MyGearPawn.LastCoverTime > 1.0)
			{
				InaccuracyPct = AI_Base_Acc_Target;
			}
			// Check for blind firing
			else if (MyGearPawn.CoverAction == CA_BlindLeft || MyGearPawn.CoverAction == CA_BlindRight)
			{
				InaccuracyPct = AI_Base_Acc_BlindFire;
			}
		}

		//debug
		`AILog("Base Inaccuracy"@InaccuracyPct, 'Accuracy');

		// Movement
		if (VSize(Pawn.Velocity) > 0.0)
		{
			InaccuracyPct += AI_mod_Acc_Move;
		}

		//debug
		`AILog("After Move Inaccuracy"@InaccuracyPct, 'Accuracy');

		// Evade
		if (EnemyPawn != None)
		{
			InaccuracyPct += EnemyPawn.GetAIAccuracyModWhenTargetingMe(self);

			if (EnemyPawn.IsEvading())
			{
				InaccuracyPct += AI_mod_Acc_Evade;
			}
			else if ((EnemyPawn.bIsTargeting && EnemyPawn.IsCarryingShield()) || EnemyPawn.IsAKidnapper())
			{
				InaccuracyPct += AI_mod_Acc_Shield;
			}
			InaccuracyPct += AI_mod_Acc_TargMove * (VSize(EnemyPawn.Velocity) / EnemyPawn.DefaultGroundSpeed);
		}
		else if (VSize(FireTarget.Velocity) > 0.0)
		{
			InaccuracyPct += AI_mod_Acc_TargMove;
		}

		//debug
		`AILog("After Targ Evade/Move Inaccuracy"@InaccuracyPct, 'Accuracy');

		// If enemy was acquired recently, more inaccurate
		Pct = FClamp(1.0 - ((WorldInfo.TimeSeconds - TargetAquisitionTime) / Response_MinEnemySeenTime), 0.0, 1.0);
		InaccuracyPct += AI_mod_Acc_BriefAcquire * Pct;

		//debug
		`AILog("After Acquire Inaccuracy"@InaccuracyPct, 'Accuracy');

		// If enemy is visible
		if (EnemyPawn != None && IsEnemyVisible(EnemyPawn))
		{
			// If enemy has been visible only a short time, more inaccurate

			Pct = FClamp(1.0 - (GetEnemyVisibleDuration(EnemyPawn) / Response_MinEnemySeenTime), 0.0, 1.0);
			InaccuracyPct += AI_mod_Acc_BriefVisibility * Pct;

			//debug
			`AILog( "After Visibile Inaccuracy"@InaccuracyPct, 'Accuracy' );
		}

		// Modify inaccuracy by range
		if (IsShortRange(TargetLocation))
		{
			InaccuracyPct += AI_modrng_Short;
		}
		else if (IsMediumRange(TargetLocation) || (Wpn != None && Wpn.bSniping && IsZero(Pawn.Velocity)))
		{
			InaccuracyPct += AI_modrng_Medium;
		}
		else
		{
			InaccuracyPct += AI_modrng_Long;
		}

		//debug
		`AILog("After Range Inaccuracy"@InaccuracyPct, 'Accuracy');
	}

	// Clamp final pct
	InaccuracyPct = FClamp(InaccuracyPct, 0.0, 1.0);

	AimError *= InaccuracyPct;

	return RandRange(-AimError, AimError);
}

/** @return the yaw component of the rotation the Pawn is actually aiming - NOT what the AI wants, what the Pawn's weapon is physically rotated to */
final function int GetPawnAimYaw()
{
	if( GearVehicleBase(Pawn) != None || GearWeaponPawn(Pawn) != None )
	{
		`Warn("Should not call this function when in a GearVehicle");
		return 0;
	}
	else if (Turret(Pawn) != None)
	{
		// turrets keep track of their aim through AimDir which is applied to bones on the mesh
		return Turret(Pawn).AimDir.Yaw;
	}
	else
	{
		// when in cover, this is done through AimOffset, not Pawn.Rotation
		return Pawn.Rotation.Yaw + 16384 * MyGearPawn.AimOffsetPct.X;
	}
}

/**
 * Figure out current aim error and return fire rotation.
 */
function rotator DefaultGetAdjustedAimFor(Weapon W, vector StartFireLoc)
{
	local rotator AimRot;

	AimRot = rotator(GetFocalPoint() - StartFireLoc);
	// GearVehicles do their own clamping
	if (GearVehicleBase(Pawn) == None)
	{
		// clamp to direction Pawn is actually looking
		AimRot.Yaw = GetPawnAimYaw();
	}

	// Calc final rotation
	if (GearWeapon(W) != None)
	{
		GearWeapon(W).OverrideAIAimRotation(AimRot, StartFireLoc, GetFocalPoint());
	}

	return AimRot;
}

/**
 * Overridden to look at enemy if currently in a combat situation.
 */
simulated event GetPlayerViewPoint(out vector out_Location, out Rotator out_rotation)
{
	local vector X, Y, Z;

	// default values
	out_Location = Pawn.GetPawnViewLocation();
	out_Rotation = Pawn.Rotation;

	if( CurrentTurret != None && Pawn != None )
	{
		out_Location	= CurrentTurret.GetPhysicalFireStartLoc( vect(0,0,0) );
		out_Rotation	= CurrentTurret.AimDir;
	}
	// if we should aim at our target
	else if( HasValidTarget() && (Focus == FireTarget || !bMovingToGoal) )
	{
		out_Rotation = rotator(GetFireTargetLocation(LT_InterpVisibility) - Pawn.Location);

		// Small adjustment to help with CA_LeanLeft/Right
		if( MyGearPawn != None &&
			MyGearPawn.CoverType != CT_None)
		{
			if( MyGearPawn.CoverAction == CA_LeanLeft || MyGearPawn.CoverAction == CA_BlindLeft )
			{
				GetAxes(out_Rotation,X,Y,Z);
				out_Location = out_Location - Y * 32.f;
			}
			else if( MyGearPawn.CoverAction == CA_LeanRight || MyGearPawn.CoverAction == CA_BlindRight )
			{
				GetAxes(out_Rotation,X,Y,Z);
				out_Location = out_Location + Y * 32.f;
			}
			else if( MyGearPawn.CoverAction == CA_BlindUp )
			{
				out_Location.Z +=  32.f;
			}
		}
	}
}

/**
 * =========
 * RELOADING
 * =========
 */

/**
 * Returns true if our weapon is currently reloading.
 */
final function bool IsReloading()
{
	return MyGearPawn != None && MyGearPawn.IsReloadingWeapon();
}

///////////////////////////////
////// WEAPON SELECTION ///////
///////////////////////////////
final function bool SelectWeapon(optional bool bForceADifferentWeapon)
{
	local Weapon W;
	local GearInventoryManager InvManager;

	if ( Pawn == None || Pawn.InvManager == None ||
		(MyGearPawn != None && MyGearPawn.IsDoingASpecialMove() && !MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove].bCanFireWeapon) )
	{
		return false;
	}

	// if we've been supplied with a forced weapon, use that
	if (ForcedWeapon == none)
	{
		// force pistol if we have a shield
		if (MyGearPawn != None && (MyGearPawn.IsAKidnapper() || MyGearPawn.IsCarryingShield() || MyGearPawn.IsDoingSpecialMove(SM_ZiplineIdle)))
		{
			InvManager = GearInventoryManager(Pawn.InvManager);
			if (InvManager != None)
			{
				W = Weapon(InvManager.GetInventoryInSlot(EASlot_Holster));
				// allow switching to a different weapon (and thus discarding shield) if we're out of pistol ammo
				if (W != None && MyGearPawn.IsCarryingShield() && !W.HasAnyAmmo())
				{
					W = None;
				}
			}
		}
		if (W == None)
		{
			// Don't do weapon switches if we can't use in combat
			if( !bAllowCombatTransitions )
			{
				return false;
			}

			W = Pawn.InvManager.GetBestWeapon(bForceADifferentWeapon);
		}
	}
	else
	{
		W = ForcedWeapon;
	}

	//debug
	`AILog(GetFuncName() @ Pawn.Weapon @ W, 'Weapon');

	if (W != None && W != Pawn.Weapon)
	{
		StopFiring();
		Pawn.InvManager.SetCurrentWeapon(W);
		return true;
	}

	return false;
}

final function bool IsSwitchingWeapons()
{
	return (MyGearPawn != None && MyGearPawn.bSwitchingWeapons);
}

function bool AllowWeaponInInventory(class<GearWeapon> NewWeaponClass)
{
	return TRUE;
}

///////////////////////////////
/////// SPECIAL MOVES /////////
///////////////////////////////

final function DictateSpecialMove( ESpecialMove TheSpecialMove, optional GearPawn InInteractionPawn)
{
	//debug
	`AILog( GetFuncName()@TheSpecialMove@InInteractionPawn );

	// Set InteractionPawn
	MyGearPawn.InteractionPawn = InInteractionPawn;

	// Pull out of cover when we become a victim
	if( TheSpecialMove == SM_ChainSawVictim )
	{
		InvalidateCover();
	}

	Pawn.SetDesiredRotation (Pawn.Rotation); // or whichever way you want him to face

	if( TheSpecialMove == SM_ChainSawVictim )
	{
		class'AICmd_React_ChainSawVictim'.static.InitCommand( self );
	}
	else
	{
		MyGearPawn.DoSpecialMove( TheSpecialMove, TRUE );
	}

}

/**
 *	Makes AI evade way from a specific danger point
 *	Use a point so we can evade away from many things
 *		ie Grenades, Berserker charge, etc.
 */
final function EvadeAwayFromPoint( Vector DangerPoint, optional Pawn Attacker, optional ESpecialMove EvadeDir )
{
	if( CanEvade() )
	{
		if( EvadeDir == SM_None )
		{
			EvadeDir = GetBestEvadeDir( DangerPoint, Attacker );
		}

		DoEvade( EvadeDir, TRUE );
	}
}

final function EvadeTowardpath()
{
	local actor EvadeToward;
	local vector evadept;
	EvadeToward = MoveGoal;
	if(RouteCache.length > 0 && RouteCache[0] != none)
	{
		EvadeToward=RouteCache[0];
	}

	evadept = Pawn.Location;
	if(EvadeToward != none)
	{
		evadept = Pawn.Location + (Pawn.Location - EvadeToward.Location);
	}

	EvadeAwayFromPoint(evadept);

}

/**
 *	Pick best direction to evade
 */
final function ESpecialMove GetBestEvadeDir( Vector DangerPoint, optional Pawn Shooter )
{
	local Vector X, Y, Z, VectToDanger;
	local bool bLeftOpen, bRightOpen, bFrontOpen, bBackOpen;
	local float DotX, DotY, DistLeftSq, DistRightSq, CheckHeight;
	local vector ProjectedLoc;
	local vector Offset;
	local Actor EvadeToward;
	local GearPawn TestGearPawn;

	// redirect if on a turret so we can exit it and evade at the same time
	TestGearPawn = MyGearPawn;
	if (TestGearPawn == None && Turret(Pawn) != None)
	{
		TestGearPawn = GearPawn(Turret(Pawn).Driver);
	}
	if (TestGearPawn == None)
	{
		return SM_None;
	}

	// Figure out which directions we can evade
	GetAxes( Pawn.Rotation, X, Y, Z );
	Offset = Y * 256.0f;
	CheckHeight = (Pawn.GetCollisionHeight() * 0.5) + Pawn.MaxStepHeight;
	bRightOpen = TestGearPawn.VerifySMHasBeenInstanced(SM_EvadeRt) && FastTrace( Pawn.Location + Offset, Pawn.Location ) && !FastTrace(Pawn.Location + Offset + (vect(0,0,-1) * CheckHeight),Pawn.Location + Offset,Pawn.GetCollisionExtent()*0.5f);
	bLeftOpen  = TestGearPawn.VerifySMHasBeenInstanced(SM_EvadeLt) && FastTrace( Pawn.Location - Offset, Pawn.Location ) && !FastTrace(Pawn.Location - Offset + (vect(0,0,-1) * CheckHeight),Pawn.Location - Offset,Pawn.GetCollisionExtent()*0.5f);

	// If evading away from a shooter
	// Only want to evade left or right
	if( Shooter != None )
	{
		// If we can only go one way... do that
		if( bRightOpen && !bLeftOpen )
		{
			return SM_EvadeRt;
		}
		else if( !bRightOpen && bLeftOpen )
		{
			return SM_EvadeLt;
		}
		// Otherwise, if we can swing both ways :)
		else if( bRightOpen && bLeftOpen )
		{
			// if both directions are open and we have a move goal, try to evade in the direction of the movegoal
			EvadeToward = MoveGoal;
			if(RouteCache.length > 0 && RouteCache[0] != none)
			{
				EvadeToward=RouteCache[0];
			}
			if(EvadeToward != none)
			{
				ProjectedLoc = Pawn.Location + Offset;
				DistRightSq = VSizeSq2D(ProjectedLoc - EvadeToward.Location);
				ProjectedLoc = Pawn.Location - Offset;
				DistLeftSq = VSizeSq2D(ProjectedLoc - EvadeToward.Location);
				if( DistRightSq < DistLeftSq )
				{
					return SM_EvadeRt;
				}
				else
				{
					return SM_EvadeLt;
				}
			}
			// Evade away from shooter rotation
			else if ((vector(Shooter.Rotation) DOT Y) > 0.f)
			{
				return SM_EvadeLt;
			}
			else
			{
				return SM_EvadeRt;
			}
		}
	}
	// Otherwise, evading from a point
	else
	{
		Offset = X * 256.f;
		// don't allow evading forward off a turret, since that will go nowhere
		bFrontOpen = Turret(Pawn) == None && TestGearPawn.VerifySMHasBeenInstanced(SM_EvadeFwd) && FastTrace(Pawn.Location + Offset, Pawn.Location) && !FastTrace(Pawn.Location + Offset + (vect(0,0,-1) * CheckHeight),Pawn.Location + Offset,Pawn.GetCollisionExtent()*0.5f);
		bBackOpen = TestGearPawn.VerifySMHasBeenInstanced(SM_EvadeFwd) && FastTrace(Pawn.Location - Offset, Pawn.Location) && !FastTrace(Pawn.Location - Offset + (vect(0,0,-1) * CheckHeight),Pawn.Location - Offset,Pawn.GetCollisionExtent()*0.5f);


		// Get Dots to the point
		VectToDanger = Normal(DangerPoint-Pawn.Location);
		DotX = X DOT VectToDanger;
		DotY = Y DOT VectToDanger;

		// If dot is mostly forward or backward
		if( DotX >= 0.7071 ||
			DotX <= -0.7071 )
		{
			// If can evade back and should
			if( bBackOpen && DotX >= 0.7071 )
			{
				// Evade back
				return SM_EvadeBwd;
			}
			// Otherwise, if can evade forward and should
			else if( bFrontOpen && DotX <= -0.7071 )
			{
				return SM_EvadeFwd;
			}
			// Otherwise, if can evade right and should OR
			// Wants to evade left but can't
			else if (bRightOpen && (DotY < 0.0 || (DotY >= 0.0 && !bLeftOpen)))
			{
				// Evade right
				return SM_EvadeRt;
			}
			// Otherwise, if can evade left and should OR
			// Wants to evade right but can't
			else if (bLeftOpen && (DotY >= 0.0 || (DotY < 0.0 && !bRightOpen)))
			{
				return SM_EvadeLt;
			}
		}
		else
		{
			// If can evade left and should
			if( bLeftOpen && DotY >= 0.7071 )
			{
				// Evade left
				return SM_EvadeLt;
			}
			// Otherwise, if can evade right and should
			else if( bRightOpen && DotY <= -0.7071 )
			{
				// Evade right
				return SM_EvadeRt;
			}
			// Otherwise, if can evade forward and should OR
			// Wants to evade back but can't
			else if (bFrontOpen && (DotX < 0.0 || (DotX >= 0.0 && !bBackOpen)))
			{
				// Evade forward
				return SM_EvadeFwd;
			}
			// Otherwise, if can evade back and should OR
			// Wants to evade forward but can't
			else if (bBackOpen && (DotX >= 0.0 || (DotX < 0.0 && !bFrontOpen)))
			{
				return SM_EvadeBwd;
			}
		}
	}

	// Can't evade either way
	return SM_None;
}

native function bool CanEvade( optional bool bCheckChanceToEvade, optional float InChanceToEvade = -1.f, optional float ChanceToEvadeScale = 1.f );

event float GetEvadeChanceScale()
{
	if (GetTeamNum() == 1)
	{
		return class'DifficultySettings'.static.GetLowestPlayerDifficultyLevel(WorldInfo).default.EnemyEvadeChanceScale;
	}
	return 1.f;
}

function DoEvade(ESpecialMove EvadeDir, optional bool bClearActionDamage)
{
	local float Delay;

	//debug
	`AILog(GetFuncName() @ EvadeDir @ Pawn.Physics @ Pawn.Anchor);

	if (EvadeDir != SM_None && CanEvade())
	{
		if (bClearActionDamage)
		{
			DamageReceivedInAction = 0;
		}

		if (MyGearPawn != None && MyGearPawn.MyGearWeapon != None)
		{
			Delay = MyGearPawn.MyGearWeapon.AIDelayBeforeEvade(self);
		}
		class'AICmd_Move_Evade'.static.Evade(self, EvadeDir, Delay);
	}
}

function NotifyStumbleAction( ESpecialMove Action )
{
	//debug
	`AILog( GetFuncName()@Action );

	if( MyGearPawn != None &&
		MyGearPawn.IsDBNO() )
	{
		return;
	}

	if( Action == SM_StumbleGetUp )
	{
		class'AICmd_React_StumbleGetUp'.static.InitCommand( self );
	}
	else
	if( Action == SM_StumbleGoDown )
	{
		class'AICmd_React_StumbleDown'.static.StumbleDown( self, 0 );
	}
	else
	if( Action == SM_StumbleGoDownFromCloseRangeShot )
	{
		class'AICmd_React_StumbleDown'.static.StumbleDown( self, 1 );
	}
	else
	if( Action == SM_StumbleFromMelee )
	{
		class'AICmd_React_StumbleFromMelee'.static.InitCommand( self );
	}
	else
	if( Action == SM_StumbleBackOutOfCover )
	{
		class'AICmd_React_StumbleBack'.static.InitCommand( self );
	}
}

function NotifyKnockDownStart();

function GoReviveTeammate( GearPawn GP )
{
	//debug
	`AILog( GetFuncName()@GP@CanRevivePawn( GP ) );

	if( CanRevivePawn( GP ) )
	{
		class'AICmd_Revive'.static.Revive( self, GP );
	}
/*	else
	{
		`AILog("..."@bCanRevive@MyGearPawn@GP.bCanRecoverFromDBNO@GP.IsDBNO());
		`AILog("..."@`TimeSince(GP.TimeStampEnteredRevivingState)@ReviveDelay@GP.IsHumanControlled());
		`AILog("..."@Pawn.IsSameTeam(GP)@GP.IsInPainVolume()@MyGearPawn.IsDBNO()@IsDead()@GP.IsAHostage()@MyGearPawn.IsAKidnapper());
		`AILog("..."@AllowedToMove()@MoveIsInterruptable()@MoveAction@MoveAction.TetherDistance);
	}*/
}

function bool CanRevivePawn(GearPawn GP, optional bool bIgnoreDBNOCheck)
{
	local GearPawn TestGP;

	// use driver if on a turret, since we potentially can get out to revive people
	TestGP = MyGearPawn;
	if (TestGP == None && Turret(Pawn) != None)
	{
		TestGP = GearPawn(Turret(Pawn).Driver);
	}

	if (  bCanRevive &&
		TestGP != None &&
		!bTeleportOnTetherFailure &&
		GP.bCanRecoverFromDBNO &&
		(bIgnoreDBNOCheck || GP.IsDBNO(true)) &&
		(`TimeSince(GP.TimeStampEnteredRevivingState) >= ReviveDelay || GP.IsHumanControlled()) &&
		GP != Pawn &&
		Pawn.IsSameTeam(GP) &&
		!GP.IsInPainVolume() &&
		!TestGP.IsDBNO() &&
		!TestGP.IsAHostage() &&
		!IsDead() &&
		!GP.IsAHostage() &&
		!TestGP.IsAKidnapper() &&
		CachedAICommandList.ShouldAllowRevive(GP) &&
		(AllowedToMove() || VSize(GP.Location - Pawn.Location) < class'GSM_ReviveTeammate'.default.ReviveSearchRadius + GP.GetCollisionRadius()) )
	{
		return TRUE;
	}

`if(`notdefined(FINAL_RELEASE))
	if( TestGP != None && GP.IsHumanControlled() && GP.IsDBNO() && (!AllowedToMove() || GP.bCanRecoverFromDBNO) )
	{
		if (MoveAction != None)
		{
			MessagePlayer( TestGP@"Trying to revive"@GP@GP.bCanRecoverFromDBNO@"but not allowed..."@MoveIsInterruptable()@MoveAction@MoveAction.TetherDistance );
			`warn( TestGP@"Can't revive player because not allowed to move"@GP@GP.bCanRecoverFromDBNO@"but not allowed..."@MoveIsInterruptable()@MoveAction@MoveAction.TetherDistance  );
			ScriptTrace();
		}
	}
`endif

	return FALSE;
}

function GoExecuteEnemy( GearPawn GP )
{
	//debug
	`AILog( GetFuncName()@GP );

	if( CanExecutePawn( GP ) )
	{
		ReactionManager.NudgeChannel(GP,'HaveEnemyToExecute');
	}
}

function HandleExecuteReactionAndPushExecuteCommand(Actor Inst, AIReactChannel OrigChan)
{
	class'AICmd_Execute'.static.Execute( self, GearPawn(Inst) );
}

function bool CanExecutePawn( GearPawn GP )
{
	local GearPawn TestGP;

	// use driver if on a turret, since we potentially can get out to revive people
	TestGP = MyGearPawn;
	if (TestGP == None && Turret(Pawn) != None)
	{
		TestGP = GearPawn(Turret(Pawn).Driver);
	}

	if ( bCanExecute && TestGP != None &&
		GP != Pawn &&
		GP.IsDBNO(true) &&
		WorldInfo.TimeSeconds - GP.TimeStampEnteredRevivingState >= ExecuteDelay &&
		!Pawn.IsSameTeam( GP ) &&
		!TestGP.IsDBNO() &&
		!GP.IsInPainVolume() &&
		!IsDead() &&
		!TestGP.IsAKidnapper() &&
		!TestGP.IsAHostage() &&
		( GP.CanBeSpecialMeleeAttacked(TestGP) ||
			(TestGP.SpecialMoveClasses[SM_Kidnapper] != None && GearPawn_Infantry(GP) != None && GP.CanBeAHostage()) ) &&
		( WorldInfo.GRI.IsMultiplayerGame() || GP.GetTeamNum() != TEAM_COG || !GP.bCanRechargeHealth ||
			(GP.IsHumanControlled() &&
			 GearPRI(GP.PlayerReplicationInfo).Difficulty.default.bHumanCOGCanBeExecuted &&
			 GP.GetMinDistToAnyHumanSquadMate() > GearPRI(GP.PlayerReplicationInfo).Difficulty.default.DistFromHumanSquadMatesBeforeEligibleForExecution
			 )
		)  &&
		IsEnemyWithinCombatZone(GP) &&
		!GP.IsNearATeammate()
	  )
	{
		return true;
	}
	else
	{
		return false;
	}
}

final function bool IsInKantusSquad(Pawn E)
{
	local GearPawn GP;
	local GearAI_Kantus Kantus;
	GP = GearPawn(E);

	if(GP == none || GP.MyGearAI == none)
	{
		return false;
	}

	foreach GP.MyGearAI.Squad.AllMembers(class'GearAI_Kantus',Kantus)
	{
		if(Kantus != none)
		{
			return true;
		}
	}

	return false;
}

/** checks if we should revive or execute any nearby DBNO pawns and if so pushes the appropriate command */
function bool CheckReviveOrExecute(float CheckDist)
{
	local GearPawn P;
	local GearTeamInfo Team;
	local int i;
	local float Dist;

	if( FindCommandOfClass( class'AICmd_Execute' ) == None &&
		FindCommandOfClass( class'AICmd_Revive'  ) == None )
	{
		// check for enemies to execute
		if (bCanExecute && Squad != None)
		{
			foreach Squad.AllEnemies(class'GearPawn', P)
			{
				Dist = VSize(GetEnemyLocation(P) - Pawn.Location);
				if( P.IsDBNO() && Dist < CheckDist &&
					!Squad.IsTryingToExecute(P) )
				{
					`AILog("Execute enemy:" @ P);
					GoExecuteEnemy(P);
					return true;
				}
			}
		}

		// check for friendlies to revive
		if (bCanRevive)
		{
			Team = GearTeamInfo(PlayerReplicationInfo.Team);
			if (Team != None)
			{
				for (i = 0; i < Team.TeamMembers.length; i++)
				{
					P = GearPawn(Team.TeamMembers[i].Pawn);
					if ( P != None && P.IsDBNO() )
					{
						Dist = VSize(P.Location-Pawn.Location);
						if( Dist < CheckDist &&
							// give normal squad revival code extra time
							(`TimeSince(P.TimeStampEnteredRevivingState) >= ReviveDelay + 0.5 || P.IsHumanControlled()) &&
							!Squad.IsTryingToRevive(P) && !IsInKantusSquad(P) &&
							// Give the active command a chance to prevent reviving of this pawn
							(CachedAICommandList == None || CachedAICommandList.ShouldAllowRevive(P)) )
						{
							`AILog("Revive teammate:" @ P);
							GoReviveTeammate(P);
							return true;
						}
					}
				}
			}
		}
	}

	return false;
}

function NotifyFlankedByEnemy( ESpecialMove SM );

function DoEmerge(ESpecialMove InEmergeSpecialMove)
{
	EmergeSpecialMove = inEmergeSpecialMove;
	class'AICmd_Emerge'.static.InitCommand(self);
}

final private function bool IsInTheWay(Pawn ChkPawn, vector ChkLoc)
{
	local vector Extent, HitLoc, HitNorm;
	local Pawn HitPawn;
	Pawn.GetBoundingCylinder(Extent.X,Extent.Z);
	Extent.Y = Extent.X;
	Extent *= 0.75f;
	foreach Pawn.TraceActors(class'Pawn',HitPawn,HitLoc,HitNorm,ChkLoc,Pawn.Location,Extent)
	{
		if (HitPawn == ChkPawn)
		{
			return TRUE;
		}
	}
	return FALSE;
}

singular event bool StepAsideFor(Pawn ChkPawn)
{
	local bool bResult, bStepAside, bDelayStep;
	local GearAI AI;
	local GearPawn ChkGP;
	local GearPawn_Infantry ChkGP_I;
	local GameAICommand ActiveCommand;

	ActiveCommand = GetActiveCommand();

	`AILog(GetFuncName()@ChkPawn@`showvar(bIgnoreStepAside));
	if ( !bIgnoreStepAside && !Pawn.bStationary &&
		 `TimeSince( LastFailedToFindStepAsideLocation ) > 1.f &&
		(ActiveCommand == None || !ActiveCommand.bIgnoreStepAside) &&
		(MyGearPawn == None || (!MyGearPawn.IsDoingASpecialMove() && !MyGearPawn.IsDBNO())) )
	{

		// step aside for players
		bResult		= TRUE;
		bStepAside	= TRUE;

		ChkGP = GearPawn(ChkPawn);
		ChkGP_I = GearPawn_Infantry(ChkPawn);

		// don't step aside for AIs in cover if they're close to our destination
		if(ChkGP != None &&
			ChkGP.IsInCover() &&
			( !ChkGP.IsHumanControlled() ||
			   (ChkGP_I != none && ChkGP_I.bNavMeshRegistered) ) &&
			MoveGoal != none &&
			VSize2D(MoveGoal.GetDestination(self) - ChkGP.Location) < 256.0f * 256.0f)
		{
			bResult = TRUE;
			bStepAside = FALSE;
		}
		else
		{
			// if we're dealing with another AI
			AI = GearAI(ChkPawn.Controller);
			if( AI != None && (AI.StepAsideGoal == Pawn  || ( bMovingToSquadLeader && !AI.bMovingToSquadLeader )))
			{
				//debug
				`AILog("- other AI is stepping aside for us already, or they were moving to their squad position and we were not");

				bResult = TRUE;
				bStepAside = FALSE;
			}
			// if we're in cover and they're not don't step aside
			else if(AI != NONE && IsAtCover() && !AI.IsAtCover())
			{
				bResult = TRUE;
				bStepAside= FALSE;
			}

			// If we are moving
			if( !ChkPawn.IsHumanControlled() && !IsZero(Pawn.Velocity) && (Pawn.Velocity DOT ChkPawn.Velocity) > 0.f )
			{
				bDelayStep = ShouldDelayStepAside(ChkPawn);
				if( !bDelayStep )
				{
					//debug
					`AILog( "- moving in the same direction as pawn we bumped" );

					bResult = TRUE;
					bStepAside = FALSE;
				}
			}
		}

		if( bStepAside && StepAsideGoal != ChkPawn )
		{
			// note: don't need to abort existing instances because stepaside is set bReplaceActiveSameClassInstance=true
			bResult = class'AICmd_StepAside'.static.StepAside( self, ChkPawn, bDelayStep );
		}
	}

	return bResult;
}


function bool ShouldDelayStepAside( Pawn GoalPawn )
{
	local float VelDotVel, GoalDotVel;
	local Vector VectToGoal, VelDir;

	if( !IsZero(Pawn.Velocity) && !IsZero(GoalPawn.Velocity) )
	{
		// If moving in the same direction as pawn we bumped
		VelDir = Normal(Pawn.Velocity);
		VelDotVel = Normal(GoalPawn.Velocity) DOT VelDir;
		if( VelDotVel > 0.3 )
		{
			// If pawn we bumped is in front of us already
			VectToGoal = Normal(GoalPawn.Location - Pawn.Location);
			GoalDotVel = VectToGoal DOT VelDir;
			if( GoalDotVel > 0 )
			{
				// Just delay movement
				return TRUE;
			}
		}
	}

	return FALSE;
}

/**
 * Copies game data to the new controller.
 */
function CopyTo( GearAI NewController )
{
	// copy enemy selection
	NewController.SetEnemy( Enemy );

	// share the log
	NewController.AILogFile = AILogFile;
	// clear the ref otherwise we'll destroy it
	AILogFile.SetOwner(NewController);
}


/**
 * Changes any references from the old controller to the new one.
 */
function ReplaceRefs(Controller OldController, Controller NewController)
{
}

/************************************************************************************
 * Pawn To Pawn Interactions
 **********************************************************************************/


final protected function bool HasValidBase()
{
	if (Pawn != None)
	{
		if (Pawn.Base == None || Pawn.Base.bDeleteMe)
		{
			Pawn.FindBase();
		}
		return (Pawn.Base != None && !Pawn.Base.bDeleteMe);
	}
	return FALSE;
}

event CurrentLevelUnloaded()
{
	`AILog("Current level unloaded");
	if (HasValidBase())
	{
		`AILog("- not destroying because we found a valid base");
	}
	else
	{
		`Warn(self@"destroyed because level was unloaded");
		WorldInfo.Game.Broadcast(self,self@"destroying because off of path network and can't find friendly to teleport to");
		if (Pawn != None)
		{
			Pawn.Destroy();
		}
		Destroy();
	}
}

function NotifyStartDriving(Vehicle V)
{
	if (Turret(V) == None && GearWeaponPawn(V) == None)
	{
		class'AICmd_WaitingForEvent'.static.Wait(self, V.Name);
	}
}

function NotifyStopDriving(Vehicle V)
{
	if (Turret(V) == None && GearWeaponPawn(V) == None)
	{
		ReceiveEvent(V.Name);
	}
}

/**
 * Handler for SeqAct_AILookAt
 */
function OnAILookAt(SeqAct_AILookAt InAction)
{
	local Controller LookTarg;

	//debug
	`AILog( GetFuncName()@InAction.FocusTarget );

	NotifyDidSomethingInteresting();
	Focus = InAction.FocusTarget;
	// if we're told to look at a controller, try to look at its pawn instead
	if(InAction.FocusTarget != none)
	{
		LookTarg = Controller(InAction.FocusTarget);
		if(LookTarg != none && LookTarg.Pawn != none)
		{
			Focus = LookTarg.Pawn;
		}
	}
}

protected function FireAtForcedTarget()
{
	Focus = FireTarget;
	StartFiring();
}

protected function StopForceFiring()
{
	SelectTarget();
	StopFiring();
	bForceFire=false;
	ForcedAccuracy = -1.f;
}
/**
 * Handler for SeqAct_AISetTarget which combines both focus and fire target selection.
 */
function OnAISetTarget(SeqAct_AISetTarget InAction)
{
    local Actor NewTarget;
    local Pawn NewEnemy;
	local Actor FinalTarget;
    `AILog(GetFuncName()@"override?"@InAction.bOverwriteExisting@"force fire?"@InAction.bForceFireAtTarget@"fire even with no los?"@InAction.bForceFireEvenWhenNoLOS);

	NotifyDidSomethingInteresting();

	if( InAction.InputLinks[0].bHasImpulse )
	{
		// Set the accuracy for firing at the set target
		ForcedAccuracy = InAction.ForcedAccuracy;

		// clear the existing list if specified
		if (InAction.bOverwriteExisting)
		{
			FireTarget = none;
			TargetList.Length = 0;
		}
		// copy the targets
		foreach InAction.FocusTargets(NewTarget)
		{
			TargetList.AddItem(GetFinalTarget(NewTarget));
			// check to see if this is a potential enemy
			NewEnemy = Pawn(NewTarget);
			if( NewEnemy != None && !IsFriendlyPawn(NewEnemy) && NewEnemy.IsValidEnemyTargetFor( PlayerReplicationInfo, FALSE ) )
			{
				// add/update them so that the AI knows to react
				ProcessStimulus( NewEnemy, PT_Force, 'OnAISetTarget' );
			}
		}
		// start shooting if necessary
		if (InAction.bForceFireAtTarget || HasAnyEnemies())
		{
			//debug
			`AILog( "... Fire at Targets"@TargetList.length );

			if (SelectTarget())
			{
				Focus = FireTarget;

				//debug
				`AILog( "Got Target"@FireTarget@Focus@HasAnyEnemies()@IsInCombat() );

				if(HasAnyEnemies())
				{
					CheckCombatTransition();
				}
				else
				if (!IsInCombat())
				{
					FireAtForcedTarget();
				}

				bForceFire = InAction.bForceFireEvenWhenNoLOS;
			}
			else
			{
				Focus = None;
			}
		}
		else
		{
			// look at the first target
			if( TargetList.Length > 0 )
			{
				Focus = TargetList[0];
			}
			else
			{
				Focus = None;
			}

			bForceFire = false;
			// if we're not in combat and bForceFireTarget is off, stop shooting
			if( !InAction.bForceFireAtTarget && !IsInCombat() )
			{
				StopForceFiring();
			}

			if(Focus != none)
			{
				MyGearpawn.SetTargetingMode(TRUE);
			}
			else
			{
				SetFocalPoint( Pawn.Location + 512*vector(Pawn.Rotation), TRUE );
				MyGearpawn.SetTargetingMode(FALSE);
			}
		}
	}
	else
	// Prohibit list
	if( InAction.InputLinks[1].bHasImpulse )
	{
		if( InAction.bOverwriteExisting )
		{
			ProhibitedTargetList.Length = 0;
		}

		// copy the targets
		foreach InAction.FocusTargets(NewTarget)
		{
			FinalTarget=GetFinalTarget(NewTarget);
			ProhibitedTargetList.AddItem(FinalTarget);
			TargetList.RemoveItem(NewTarget);
			if( NewTarget == Enemy )
			{
				SetEnemy( None );
				CheckCombatTransition();
			}
			else if (NewTarget == FireTarget)
			{
				FireTarget = None;
			}
		}
	}
}



/**
 * Handler for SeqAct_AIProtectTarget which tells AI to prefer to target enemies that are threatening our target
 */
function OnAIProtectTarget( SeqAct_AIProtectTarget InAction )
{
	local Actor NewTarget;

    `AILog(GetFuncName()@"override?"@InAction.bOverwriteExisting);

	NotifyDidSomethingInteresting();

	if( InAction.InputLinks[0].bHasImpulse )
	{
		// clear the existing list if specified
		if( InAction.bOverwriteExisting )
		{
			ProtectTargetList.Length = 0;
		}

		// copy the targets
		foreach InAction.ProtectTargets(NewTarget)
		{
			NewTarget = GetFinalTarget(NewTarget);
			if( NewTarget != Pawn )
			{
				ProtectTargetList.AddItem( NewTarget );
			}
		}
	}
}

function bool ShouldSaveForCheckpoint()
{
	return (MyGearPawn == None || !MyGearPawn.IsAHostage());
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
	local InventoryRecord InvRecord;
	local GearWeapon Weapon;
	local Vehicle_Reaver_Base Reaver;
	local int i;
	local Vehicle_Jack_Base Jack;
	local Pawn InvHolder;
	local GearPawn AnimPawn;

	Record.SavedGuid = MyGuid;
	Record.PlayerSlotIndex = GearGameSP_Base(WorldInfo.Game).PlayerSlots.Find('Owner', self);
	Record.PlayerName = PlayerReplicationInfo.PlayerName;
	if (Pawn != None)
	{
		Record.PawnHealthPct = float(Pawn.Health) / float(Pawn.HealthMax);
		if (MyGearPawn != None)
		{
			if (GearPawnRidable_Base(Pawn) != None)
			{
				Record.PawnClassName = PathName(GearPawnRidable_Base(Pawn).Driver.Class);
				Record.RidableClassName = PathName(Pawn.Class);
			}
			else
			{
				Record.PawnClassName = PathName(Pawn.Class);
			}

			if (MyGearPawn.MutatedClass != None)
			{
				Record.MutatedClassName = PathName(MyGearPawn.MutatedClass);
			}
			Record.bCanDBNO = MyGearPawn.bCanDBNO;
			AnimPawn = (GearPawnRidable_Base(MyGearPawn) != None) ? GearPawnRidable_Base(MyGearPawn).Driver : MyGearPawn;
			if (AnimPawn.Mesh != None && AnimPawn.Mesh.SkeletalMesh != None && AnimPawn.Mesh.SkeletalMesh.FaceFXAsset != None)
			{
				for (i = 0; i < ArrayCount(AnimPawn.ReplicatedFaceFXAnimSets); i++)
				{
					Record.MountedFaceFX[i] = PathName(AnimPawn.ReplicatedFaceFXAnimSets[i]);
				}
			}
			for (i = 0; i < ArrayCount(AnimPawn.KismetAnimSets); i++)
			{
				Record.KismetAnimSets[i] = PathName(AnimPawn.KismetAnimSets[i]);
			}
			Record.KismetAnimTree = PathName(AnimPawn.ReplicatedKismetAnimTree);
		}
		else if (Vehicle_Reaver_Base(Pawn) != None || Vehicle_Jack_Base(Pawn) != None)
		{
			Record.PawnClassName = PathName(Pawn.Class);
		}
		else if( Vehicle(Pawn) != None && Vehicle(Pawn).Driver != None )
		{
			Record.PawnClassName = PathName(Vehicle(Pawn).Driver.Class);
			Record.PawnPathName = PathName((GearWeaponPawn(Pawn) != None) ? Pawn.GetVehicleBase() : Pawn);
		}
		// if the AI is in the middle of a mantle, record the Pawn as back at the start
		// otherwise we might get stuck on top of the cover on checkpoint load
		if (MyGearPawn != None && MyGearPawn.IsDoingSpecialMove(SM_MidLvlJumpOver))
		{
			Record.Location = BP2Vect(GSM_MantleOverCoverBase(MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove]).MantleStartLoc);
		}
		else
		{
			Record.Location = Pawn.Location;
		}
		Record.Rotation = Pawn.Rotation;
		if (Pawn.Base != None && Pawn.Base.bNoDelete && !Pawn.Base.bStatic && !Pawn.Base.bWorldGeometry)
		{
			Record.BasePathName = PathName(Pawn.Base);
		}
		// create records for each inventory item
		if (GearPawnRidable_Base(Pawn) != None)
		{
			InvHolder = GearPawnRidable_Base(Pawn).Driver;
		}
		else if (Vehicle(Pawn) != None)
		{
			InvHolder = Vehicle(Pawn).Driver;
		}
		else
		{
			InvHolder = Pawn;
		}
		foreach InvHolder.InvManager.InventoryActors(class'GearWeapon', Weapon)
		{
			Weapon.CreateCheckpointRecord(InvRecord);
			Record.InventoryRecords.AddItem(InvRecord);
		}
		if (MyGearPawn != None)
		{
			// if we are in cover save the current cover slot
			if (MyGearPawn.CurrentLink != None)
			{
				Record.SlotPathName = PathName(MyGearPawn.CurrentLink);
				Record.SlotIdx = MyGearPawn.CurrentSlotIdx;
			}
		}
		else
		{
			// record reaver data if needed
			Reaver = Vehicle_Reaver_Base(Pawn);
			if (Reaver != None && Reaver.Physics == PHYS_Interpolating)
			{
				Record.ReaverRecord.bHasData = true;
				for (i = 0; i < 16; i++)
				{
					Record.ReaverRecord.FlightPaths[i] = PathName(Reaver.FlightPaths[i]);
				}
				Record.ReaverRecord.InitialFlightPath = PathName(Reaver.InitialFlightPath);
				Record.ReaverRecord.InitialFlightPathGroupName = Reaver.InitialFlightPathGroupName;
				Record.ReaverRecord.CurrentInterpTime = Reaver.CurrentInterpTime;
				Record.ReaverRecord.CurrentFlightIndex = Reaver.CurrentFlightIndex;
				Record.ReaverRecord.bAllowLanding = Reaver.bAllowLanding;
			}
			// record Jack data if needed
			Jack = Vehicle_Jack_Base(Pawn);
			if (Jack != None)
			{
				Record.bJackHidden = Jack.bHidden;
				Record.JackSpotlightSetting = Jack.SpotlightSetting;
				Record.bJackSpotlightOn = Jack.bSpotlightOn;
			}
		}
	}
	else
	{
		Record.Location = Location;
		Record.Rotation = Rotation;
	}
	Record.TeamIndex = GetTeamNum();
	Record.SquadName = string(GearPRI(PlayerReplicationInfo).SquadName);
	Record.PerceptionMood = PerceptionMood;
	Record.CombatMood = CombatMood;
	Record.bIsLeader = IsSquadLeader();
	Record.bForceShowInTaccom = GearPRI(PlayerReplicationInfo).bForceShowInTaccom;
	Record.bAllowCombatTransitions = bAllowCombatTransitions;
	Record.MoveActionPathName = PathName(MoveAction);
	if (Squad != None && Squad.SquadRoute != None)
	{
		Record.SquadRoutePathName = PathName(Squad.SquadRoute);
	}
}

function ApplyCheckpointTeamChanges(const out CheckpointRecord Record)
{
	WorldInfo.Game.ChangeTeam(self, Record.TeamIndex, false);
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
	local InventoryRecord InvRecord;
	local Inventory InvItem;
	local class<Inventory> InvClass;
	local Pawn NewPawn;
	local class<Pawn> PawnClass;
	local Vehicle V;
	local Vehicle_Reaver_Base Reaver;
	local int i;
	local FaceFXAnimSet FaceFXAnim;
	local Vehicle_Jack_Base Jack;
	local class<GearPawnRidable_Base> RidableClass;
	local GearPawnRidable_Base Ridable;
	local CoverLink Link;
	local int SlotIdx;
	local GearDestructibleObject GDO;

	MyGuid = Record.SavedGuid;
	bAllowCombatTransitions = Record.bAllowCombatTransitions;
	// eliminate our existing pawn
	if (Pawn != None)
	{
		Pawn.LifeSpan = 0.1;
		UnPossess();
	}

	if (Record.PawnClassName != "")
	{
		PawnClass = class<Pawn>(FindObject(Record.PawnClassName, class'Class'));
`if(`notdefined(FINAL_RELEASE))
		if (PawnClass == None)
		{
			`Warn("Failed to find PawnClass" @ Record.PawnClassName);
		}
`endif
	}
	if (Record.PlayerSlotIndex != INDEX_NONE)
	{
		GearGameSP_Base(WorldInfo.Game).PlayerSlots[Record.PlayerSlotIndex].Owner = self;
		if (class<GearPawn>(PawnClass) != None)
		{
			GearGameSP_Base(WorldInfo.Game).PlayerSlots[Record.PlayerSlotIndex].PawnClass = class<GearPawn>(PawnClass);
		}
	}
	if (PawnClass != None)
	{
		NewPawn = Spawn(PawnClass,,, Record.Location, Record.Rotation,, true);
`if(`notdefined(FINAL_RELEASE))
		if (NewPawn == None)
		{
			`Warn("Failed to spawn pawn of class" @ PawnClass);
		}
`endif
		// team change needs to be before possess because difficulty scaling happens from
		// SetPlayerDefaults(), called through Possess(), and it checks what team we're on
		ApplyCheckpointTeamChanges(Record);

		Possess(NewPawn, false);
		if (Pawn != None)
		{
			if (Vehicle(Pawn) == None)
			{
				// discard any current inventory
				Pawn.InvManager.DiscardInventory();
				// create any recorded inventory items
				foreach Record.InventoryRecords(InvRecord)
				{
					InvClass = class<Inventory>(FindObject(InvRecord.InventoryClassPath, class'Class'));
					if (InvClass == None)
					{
						`Warn("Failed to find class" @ InvRecord.InventoryClassPath @ "in memory");
					}
					else
					{
						InvItem = Pawn.InvManager.Spawn(InvClass);
						if (InvItem == None)
						{
							`Warn("Couldn't spawn inventory of class" @ InvClass);
						}
						else
						{
							if (GearWeapon(InvItem) != None)
							{
								GearWeapon(InvItem).ApplyCheckpointRecord(InvRecord);
							}
							Pawn.InvManager.AddInventory(InvItem, !InvRecord.bIsActiveWeapon);
						}
					}
				}
			}
			if (Record.PawnPathName != "")
			{
				V = Vehicle(FindObject(Record.PawnPathName, class'Vehicle'));
				if (V != None)
				{
					if (Turret(V) != None)
					{
						CurrentTurret = Turret(V); // use special turret code to take over
					}
					else
					{
						V.TryToDrive(Pawn);
					}
				}
			}
			if (Record.BasePathName != "")
			{
				Pawn.SetBase(Actor(FindObject(Record.BasePathName, class'Actor')));
			}
			Pawn.Health = Record.PawnHealthPct * Pawn.HealthMax;
			if (Pawn.Health < Pawn.HealthMax && MyGearPawn != None)
			{
				MyGearPawn.ResetHealthRecharge();
			}
			SetSquadName(name(Record.SquadName), Record.bIsLeader);
			GearPRI(PlayerReplicationInfo).bForceShowInTaccom = Record.bForceShowInTaccom;
			SetPerceptionMood(Record.PerceptionMood);
			CombatMood = Record.CombatMood; // don't use SetCombatMood() as that has side effects we don't want here
			// clear the state stack
			GotoState('Action_Idle', 'Begin');
			CheckCombatTransition();
			if (Record.MutatedClassName != "")
			{
				class<GearPawn>(FindObject(Record.MutatedClassName, class'Class')).static.MutatePawn(MyGearPawn);
			}
			// reacquire cover if it was saved
			if (Record.SlotPathName != "")
			{
				Link = CoverLink(FindObject(Record.SlotPathName, class'CoverLink'));
				SlotIdx = Record.SlotIdx;
				SetTether( Link.GetSlotLocation(SlotIdx), Link );
			}
			if (MyGearPawn != None)
			{
				MyGearPawn.bCanDBNO = Record.bCanDBNO;
				if (MyGearPawn.Mesh != None && MyGearPawn.Mesh.SkeletalMesh != None && MyGearPawn.Mesh.SkeletalMesh.FaceFXAsset != None)
				{
					for (i = 0; i < ArrayCount(Record.MountedFaceFX); i++)
					{
						FaceFXAnim = FaceFXAnimSet(FindObject(Record.MountedFaceFX[i], class'FaceFXAnimSet'));
						if (FaceFXAnim != None)
						{
							MyGearPawn.Mesh.SkeletalMesh.FaceFXAsset.MountFaceFXAnimSet(FaceFXAnim);
							MyGearPawn.ReplicatedFaceFXAnimSets[i] = FaceFXAnim;
						}
					}
				}

				MyGearPawn.ReplicatedKismetAnimTree = AnimTree(FindObject(Record.KismetAnimTree, class'AnimTree'));
				if( MyGearPawn.ReplicatedKismetAnimTree != None )
				{
					MyGearPawn.Mesh.SetAnimTreeTemplate( MyGearPawn.ReplicatedKismetAnimTree );
				}

				for (i = 0; i < ArrayCount(MyGearPawn.KismetAnimSets); i++)
				{
					MyGearPawn.KismetAnimSets[i] = AnimSet(FindObject(Record.KismetAnimSets[i], class'AnimSet'));
				}
				MyGearPawn.UpdateAnimSetList();
				// make sure we equipped a weapon
				if (MyGearPawn.Weapon != None)
				{
					SelectWeapon();
				}
				if (Record.RidableClassName != "")
				{
					RidableClass = class<GearPawnRidable_Base>(FindObject(Record.RidableClassName, class'Class'));
					if (RidableClass != None)
					{
						Ridable = Spawn(RidableClass,,, Record.Location, Record.Rotation,, true);
						if (Ridable != None)
						{
							Ridable.SetDriver(MyGearPawn, self);
						}
					}
				}
			}
			else
			{
				// apply reaver data if needed
				Reaver = Vehicle_Reaver_Base(Pawn);
				if (Reaver != None && Record.ReaverRecord.bHasData)
				{
					for (i = 0; i < 16; i++)
					{
						Reaver.FlightPaths[i] = InterpData(FindObject(Record.ReaverRecord.FlightPaths[i], class'InterpData'));
					}
					Reaver.InitialFlightPath = InterpData(FindObject(Record.ReaverRecord.InitialFlightPath, class'InterpData'));
					Reaver.InitialFlightPathGroupName = Record.ReaverRecord.InitialFlightPathGroupName;
					Reaver.CurrentInterpTime = Record.ReaverRecord.CurrentInterpTime;
					Reaver.CurrentFlightIndex = Record.ReaverRecord.CurrentFlightIndex;
					Reaver.bAllowLanding = Record.ReaverRecord.bAllowLanding;
				}
				// apply Jack data if needed
				Jack = Vehicle_Jack_Base(Pawn);
				if (Jack != None)
				{
					if (Record.bJackHidden)
					{
						Jack.HideJack(false);
					}
					else
					{
						Jack.ShowJack();
						Jack.FinishedCloaking(false, true);
					}
					Jack.SpotlightSetting = Record.JackSpotlightSetting;
					Jack.UpdateJackSpotlightSetting();
					Jack.SetSpotLightState(Record.bJackSpotlightOn);
				}
			}
			if (Squad != None && Record.SquadRoutePathName != "")
			{
				Squad.SetSquadRoute(GameplayRoute(FindObject(Record.SquadRoutePathName, class'GameplayRoute')));
			}
			if (Record.MoveActionPathName != "")
			{
				PendingCheckpointMoveAction = SeqAct_AIMove(FindObject(Record.MoveActionPathName, class'SeqAct_AIMove'));
			}

			// Shut down any overlapping GDOs, in case we were standing on a destroyed one when the checkpoint was saved
			foreach Pawn.OverlappingActors(class'GearDestructibleObject', GDO, Pawn.GetCollisionRadius())
			{
				GDO.ShutDownObject();
			}
		}
	}
	// last because pawn class overrides by default
	PlayerReplicationInfo.PlayerName = Record.PlayerName;
}

function TriggerAttackGUDS()
{
	local GearPawn GP;

	GP = GearPawn(Pawn);
	if ( (GP != None) && !GP.IsAHostage() )
	{
		GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_Attack, Pawn);
	}
}

function OnAIThrowGrenade(SeqAct_AIThrowGrenade InAction)
{
	NotifyDidSomethingInteresting();
	class'AICmd_ScriptedThrowGrenade'.static.InitCommandUserActor(self, InAction.FireTarget);
}

// default is to return distance to revive target, the AI with the lowest rating will be chosen to actually do the revive
function float GetReviveRatingFor(GearPawn Other)
{
	return VSize(Other.Location - Pawn.Location);

}

function bool ShouldAllowWalk()
{
	return true;
}

/** resets the 'did something interesting' timer (optionally can pass when we did something interesting to not reset the timer to the full time (e.g. we just foudn otu we were rendered 5 seconds ago, check again in StaleTimout -5 seconds)*/
final native function NotifyDidSomethingInteresting(optional float TimeOfInterestingThing=-1.f);

/** Given the target, return the actual actor we should be shooting at (ie controller -> pawn, or turret -> driver) */
final native function Actor GetFinalTarget( Actor Targ ) const;

//flip on stale checks for AIs whose anchor just got streamed out
event NotifyAnchorBeingStreamedOut()
{
	// don't stream out COG so Dom and friends don't die and break the game if they fall behind
	if (GetTeamNum() != 0)
	{
		`log(self@MyGearPawn@"My Anchor was just streamed out, enabling stale checks!");
		StaleTimeout = 15.0f; // shortened timeout
		SetEnableDeleteWhenStale(TRUE);
	}
}

// called to get this AI to move out of the way of an incoming player mantling on top of him
function VacateMantleDestination(GearPawn IncomingMantler)
{
	`AILog(GetFuncname()@"moving away for incoming player mantling"@IncomingMantler);
	InvalidateCover(,TRUE);
	StepAsideFor(IncomingMantler);
}

simulated function SetBerzerk(bool bNewBerzerk)
{
	bBerzerk = bNewBerzerk;

	if (bBerzerk)
	{
		// backup current squad
		if (SavedSquadName == '')
		{
			SavedSquadName = GetSquadName();
		}

		// put into his own squad
		SetSquadName(Name);

		// look around for enemies
		AutoAcquireEnemy();
	}
	else
	{
		// restore original squad
		SetSquadName(SavedSquadName);
		SavedSquadName = '';
	}

	// definitions of "enemy" and "friendly" have changed, re-choose enemy
	SetEnemy(None);
	SelectEnemy();
}

/**
 * Initiated when this AI begins traversal of an edge associated with a ladder
 */
function bool UseLadder(Trigger_LadderInteraction Ladder)
{
	`AILog(GetFuncName()@"using ladder"@ladder@`showvar(Ladder.IsTopOfLadder()));
	return class'AICmd_Move_ClimbLadder'.static.ClimbLadder( self, Ladder );
}

event bool LeapToDest(JumpPoint Start, Actor End, vector CachedVelocity)
{
	return class'AICmd_Move_Leap'.static.Leap( self, Start, End, CachedVelocity );
}

event bool CanUseJumpLink(JumpLink Link)
{
	return false;
}

event bool JumpLinkToDest(JumpLink Link, vector Start, vector End)
{
	return class'AICmd_Move_JumpLink'.static.Leap( self, Link, Start, End );
}

function vector CalcJumpVelocity(const out vector LeapEnd, const out vector LeapStart)
{
	local vector JumpVelocity;
	local float OldGroundSpeed;

	// Temporarily set GroundSpeed
	OldGroundSpeed = MyGearPawn.GroundSpeed;
	MyGearPawn.GroundSpeed = MyGearPawn.JumpSpeedXY;

	if( MyGearPawn.SuggestJumpVelocity(JumpVelocity, LeapEnd, LeapStart, true) )
	{
		MyGearPawn.GroundSpeed = OldGroundSpeed;
		if( LeapEnd.Z > LeapStart.Z )
		{
			// Give a small boost to upward jumps
			JumpVelocity.Z += 75.f;
		}
		JumpVelocity.Z = FClamp(JumpVelocity.Z, MyGearPawn.MinJumpSpeedZ, MyGearPawn.JumpZ);
		return JumpVelocity;
	}

	MyGearPawn.GroundSpeed = OldGroundSpeed;
	return vect(0,0,0);
}

/**
 *	Called from movetogoal to notify us that the AI is starting a move
 */
function StartingMovement();

/**
 *	called from movetogoal to notify us that the AI has stopped moving
 */
function StoppingMovement();

/**
 *  called when this AI is in the way of a cover slot the player is trying to enter
 *  @param Player - the player that we are currently blocking
 */
function VacateCoverForPlayer(GearPC Player)
{
	StepAsideFor(Player.Pawn);
}

event bool NotifyHitWall(vector HitNormal, Actor Wall)
{
	// bit hacky but don't want the expense of being general since there's currently just this one case
	if (Wall.bWorldGeometry && AICmd_Attack_PlantGrenade(GetActiveCommand()) != None)
	{
		MoveTimer = -1.0;
		return true;
	}
	else
	{
		return false;
	}
}

/**
 * called when a path fails to perform necessary logging tasks
 */
function LogPathFailure_Internal(Actor ActorPathTarget, coerce string reason)
{
`if(`notdefined(FINAL_RELEASE))
	local int Key;
	local vector dest;
	//local vector offset;

	if(ActorPathTarget != none)
	{
		dest=ActorPathTarget.Location;
	}
	else
	{
		dest=BP2Vect(NavigationHandle.FinalDestination);
	}

	// record stat for failure
	`RecordAIPathFailEvent(self,reason,dest);

	Key = int(WorldInfo.TimeSeconds);
	`AILog("("$Key$")Logging AI path failure!"@reason);
`endif
// 	`log("PATHFAIL("$Key$"):"@self@"FAILED to path! - Location:"@Pawn.Location@"DestActor:"@ActorPathTarget@BP2Vect(NavigationHandle.FinalDestination));
// 	`log("PATHFAIL("$Key$"):"@reason);
//
// 	DrawDebugLine(Pawn.Location,dest,255,0,0,TRUE);
// 	DrawDebugCoordinateSystem(dest,rot(0,0,0),50.f,TRUE);
//
// 	DrawDebugBox(Pawn.Location,vect(10,10,10),255,0,0,TRUE);
// 	offset.z = randRange(0,10);
// 	DrawDebugString(Pawn.Location+offset,Key);
}

defaultproperties
{
	TimeLastHadContactWithEnemy=-99999999

	bIsPlayer=true
	LastShotAtTime=-99999.f
	RotationRate=(Pitch=50000,Yaw=50000,Roll=50000)
	MaxStepAsideDist=90.f
	bUseFireTickets=true
	bCanExecute=true
	bCanRevive=true
	bAllowDBNOCrawl=true
	bCheckForVehicles=true
	AI_NearMissDistance=200.0

	IntermediatePointArrivalDist=20.f

	bForceDemoRelevant=true // so we can record AI debug info into demos

	// No need to see friendly controllers
	bSeeFriendly=false

	bAllowCombatTransitions=true
	bKillDuringLevelTransition=true
	bSpawnerTetherInterruptable=true
	ExtraPathCost=125
	bDestroyOnPawnDeath=true
	bCanUseCoverSlipMove=true
	bAvoidIdleMantling=true
	bCanMelee=true

	InUseNodeCostMultiplier=10.0

	PerceptionMood=AIPM_Normal
	CombatMood=AICM_Normal

	/// *** Begin Reactions ***
	DefaultReactConditionClasses.Add(class'AIReactCond_MeatShield')
	DefaultReactConditionClasses.Add(class'AIReactCond_NewEnemy')
	DefaultReactConditionClasses.Add(class'AIReactCond_HOD')
	DefaultReactConditionClasses.Add(class'AIReactCond_SurpriseEnemyLoc')
	DefaultReactConditionClasses.Add(class'AIReactCond_Grenade')
	DefaultReactConditionClasses.Add(class'AIReactCond_Stumble')
	//DefaultReactConditionClasses.Add(class'AIReactCond_HeadDamage') // nothing seems to be using this
	DefaultReactConditionClasses.Add(class'AIReactCond_Targeted')
	DefaultReactConditionClasses.Add(class'AIReactCond_EnteredAvoidanceZone')

	// Flanked (off by default)
	//Begin Object Class=AIReactCond_Flanked Name=Flanked0
	//	bSuppressed=true
	//End Object
	//DefaultReactConditions.Add(Flanked0)

	// melee reaction
	Begin Object Class=AIReactCond_EnemyCanBeMeleed Name=EnemyInMeleeRangeReaction0
		OutputFunction=BeginMeleeCommandWrapper
	End Object
	DefaultReactConditions.Add(EnemyInMeleeRangeReaction0)

	// execute enemy
	Begin Object Class=AIReactCond_GenericCallDelegate Name=ExecutEnemyReaction0
		AutoSubscribeChannels(0)=HaveEnemyToExecute
		OutputFunction=HandleExecuteReactionAndPushExecuteCommand
	End Object
	DefaultReactConditions.Add(ExecutEnemyReaction0)

	Begin Object Class=AIReactionmanager Name=ReactionManager0
	End Object
	ReactionManager=ReactionManager0
	/// *** End Reactions ***

	StaleTimeout=30.0
	SightCounterInterval=0.5

	ForcedAccuracy=-1.f

	RotationRateMultiplier=0.5
	BasicMovementMultiplier=1.0

	MeleeCommand=class'AICmd_Base_Melee'

	bOnlyPlanarFlocking=true

	MaxFireFromCoverBursts=3
}
