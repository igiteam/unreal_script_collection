class SkyBot extends SkyAIController
    native
    config(AI);

enum ReactionType
{
    ReactionType_Invalid,           // 0
    ReactionType_EnemySpotted,      // 1
    ReactionType_Alarmed,           // 2
    ReactionType_PostKillEnemy,     // 3
    ReactionType_Evade,             // 4
    ReactionType_HeardNoise,        // 5
    ReactionType_SearchArea,        // 6
    ReactionType_LostEnemy,         // 7
    ReactionType_StartleSurprised,  // 8
    ReactionType_Dodge,             // 9
    ReactionType_MAX                // 10
};

enum TauntAudioType
{
    Taunt_Chasing,                  // 0
    Taunt_Cover,                    // 1
    Taunt_Raging,                   // 2
    Taunt_Fallback,                 // 3
    Taunt_Runaway,                  // 4
    Taunt_MAX                       // 5
};

enum EFindCoverSearchType
{
    FindCover_Towards,              // 0
    FindCover_Away,                 // 1
    FindCover_Near,                 // 2
    FindCover_MAX                   // 3
};

enum BTTypeOfCover
{
    BTC_Any,                        // 0
    BTC_AnyHorizontal,              // 1
    BTC_HorizontalStanding,         // 2
    BTC_HorizontalMidlevel,         // 3
    BTC_AnyVertical,                // 4
    BTC_VerticalUp,                 // 5
    BTC_VerticalDown,               // 6
    BTC_MAX                         // 7
};

struct native ReactionSet
{
    var() SkyBot.ReactionType ReactionType;
    var() array<ReactionAnimDatum> ThePossibleAnims;

    structdefaultproperties
    {
        ReactionType=ReactionType_Invalid
        ThePossibleAnims=none
    }
};

struct native SkyBotBurstFireStruct
{
    var() float MinTimeBetweenFiringBursts;
    var() float MaxTimeBetweenFiringBursts;
    var() float MinDurationOfFiringBurst;
    var() float MaxDurationOfFiringBurst;

    structdefaultproperties
    {
        MinTimeBetweenFiringBursts=0.0000000
        MaxTimeBetweenFiringBursts=0.0000000
        MinDurationOfFiringBurst=0.0000000
        MaxDurationOfFiringBurst=0.0000000
    }
};

var bool AnimDatumUpdatedFlag;
var(Perception) protected bool bCanSee;
var(Perception) protected bool bCanHear;
var(Perception) protected bool bCanFeelPain;
var protected transient bool bIsFirstShotOfBurstRound;
var protected transient bool bAdjustedAim_LastLineCheck_AimForHead;
var(Combat) protected bool bMustAcquireFireTicketBeforeAttack;
var(CoverUse) protected bool bProhibitPassingEnemy;
var(CoverUse) protected bool bRespectAreaOfOperation;
var protected transient bool bFailedProbabilityForTaunt;
var transient bool bOverrideReachSpecCost;
var(Pathfinding) protected bool bApplyAreaOfOperationPathWeighting;
var(Pathfinding) bool bSquadMemberAvoidanceDisabled;
var(MovementSpeed) protected bool bUseInterpolatedMovementSpeed;
var protected transient bool bMovingToGoal;
var protected transient bool bMovingToPoint;
var protected transient bool bReachedMoveGoal;
var protected transient bool bReevaluatePath;
var protected transient bool bPreparingNewMove;
var protected transient bool bSkipPathing;
var protected transient bool bPartialPathing;
var transient bool bVisualDebugCoverSearch;
var transient bool bWantsToTarget;
var protected transient bool bEnteringCover;
var protected transient bool bExitingCover;
var protected transient bool bSwatTurning;
var protected transient bool bExitCoverWithSlip;
var protected transient bool bExitCoverWithDive;
var protected transient bool bExitCoverWithMantle;
var protected transient bool bIsPlayingReaction;
var protected transient bool bUseSpecifiedReaction;
var protected transient bool bIsPlayingSpecialMove;
var protected transient bool bScriptedMoveInterruptable;
var protected transient bool bFrozenWasBurstFiring;
var transient bool bAllowFrozenFacingUpdate;
var transient bool bInitiatedSkyJumpPath;
var transient SkyMemory BotMemory;
var transient SkyBehaviorTree BehaviorTree;
var(Brain) SkyBrain BrainArchetype;
var(BehaviorTree) SkyBehaviorTree BehaviorTreeTemplate;
var transient SkySquadInfo BotSquad;
var(Accuracy) protected float Base_Standing;
var(Accuracy) protected float Base_StandingTargeting;
var(Accuracy) protected float Base_CoverTargeting;
var(Accuracy) protected float Base_CoverBlindFiring;
var(Accuracy) protected float Modifier_Moving;
var(Accuracy) protected float Modifier_TargetMoving;
var(Accuracy) protected float Modifier_TargetSprinting;
var(Accuracy) protected float Modifier_TargetNotInCoverMin;
var(Accuracy) protected float Modifier_TargetNotInCoverMinTime;
var(Accuracy) protected float Modifier_TargetNotInCoverMax;
var(Accuracy) protected float Modifier_TargetNotInCoverMaxTime;
var(Accuracy) protected float Modifier_TargetInteracting;
var(Accuracy) protected float Modifier_TargetIsMeleeInteracting;
var(Accuracy) protected float Modifier_GameDifficultyEasy;
var(Accuracy) protected float Modifier_GameDifficultyNormal;
var(Accuracy) protected float Modifier_GameDifficultyHard;
var(Accuracy) protected float ModifierRange_Short;
var(Accuracy) protected float ModifierRange_Medium;
var(Accuracy) protected float ModifierRange_Long;
var(Accuracy) protected float Modifier_FirstBurstRound;
var(Accuracy) protected float Modifier_TargetHovering;
var(Accuracy) float AdjustedAim_LineCheckInterval;
var protected transient Rotator LastBurstShotAimRot;
var protected transient float AdjustedAim_LastLineCheckTime;
var(Combat) protected float EnemyDistance_Short;
var(Combat) protected float EnemyDistance_Medium;
var(Combat) protected float EnemyDistance_Long;
var(BurstFire) protected SkyBotBurstFireStruct BurstFireSettingsNoCover;
var(BurstFire) protected SkyBotBurstFireStruct BurstFireSettingsHorizCover;
var(BurstFire) protected SkyBotBurstFireStruct BurstFireSettingsVertUpCover;
var(BurstFire) protected SkyBotBurstFireStruct BurstFireSettingsVertDownCover;
var(BurstFire) protected SkyBotBurstFireStruct BurstFireSettingsRaging;
var(FriendlyFire) protected float FriendlyFireCosAngle;
var(CoverUse) protected float MinCoverDistanceFromRefActor;
var(CoverUse) protected float MaxCoverDistanceFromRefActor;
var(CoverUse) protected float MinCoverDistanceFromMe;
var(CoverUse) protected float MaxCoverDistanceFromMe;
var(CoverUse) protected Vector ValidCoverConeDirection;
var(CoverUse) protected float ValidCoverConeAngle;
var(CoverUse) protected float CheckCoverExposedToEnemiesSeenInLastXSeconds;
var(CoverUse) protected float TimeoutWaitingForCoverToBeUnoccupied;
var(CoverUse) protected float SquadmateCoverRange;
var(Audio) protected float MinIntervalFromLastTauntAudio;
var(Audio) protected float TauntProbabilityWhenAnotherBotIsTaunting;
var(Audio) protected SoundCue TauntBank;
var protected transient float LastTryTaunt;
var(Fleeing) protected float MaxFleeDistanceFromRefActor;
var(Fleeing) protected float MinFleeDistanceFromRefActor;
var(Fleeing) protected float MinFleeDistanceFromMe;
var(Team) protected byte TeamNumber;
var transient SkyBotControllerBase.EBurstFireState BurstFireState;
var transient SkyBot.BTTypeOfCover CoverTypePreference;
var(Reactions) protected array<ReactionSet> ReactionSets;
var(Pathfinding) protected int MaxRetriesMoveToward;
var protected transient int NumRetriesMoveToward;
var(Pathfinding) protected float MinDistanceToForceRepath;
var(Pathfinding) protected float SquadMemberAvoidanceDistance;
var protected transient Vector LastAvoidanceDir;
var(Pathfinding) protected float SquadMemberAvoidanceWeight;
var(MovementSpeed) protected float InterpolateMoveSpeedMin;
var(MovementSpeed) protected float InterpolateMoveSpeedMax;
var(MovementSpeed) protected float InterpolateMoveSpeedMinDist;
var(MovementSpeed) protected float InterpolateMoveSpeedMaxDist;
var(Squad) protected float SharedSquadPerceiveDistance;
var(Death) protected float TaintDeathLocationAmount;
var protected transient Actor FireTarget;
var transient int InternalBurstStreamCounter;
var transient SkyBotBurstFireStruct BurstFireInfo;
var protected transient float LastMoveCompleted;
var protected float AcceptableEndPointRadius;
var protected transient Actor MoveGoal;
var protected transient Vector MovePoint;
var protected transient Actor MoveFocus;
var protected transient float MoveOffset;
var protected transient float MovementTimeout;
var protected transient Actor CoverReferenceActor;
var protected transient CoverInfo ClaimedCover;
var protected transient CoverSlotMarker CoverToEnter;
var protected transient Actor FleeFromReferenceActor;
var protected transient Actor FlankingRefActor;
var protected transient float FlankingAvoidTargetRadius;
var protected transient float FlankingMaxRadius;
var protected transient float FlankingBehindTargetAngle;
var protected transient int ReactionSetIdx;
var protected transient int ReactionAnimIdx;
var protected transient ReactionAnimDatum SpecifiedRAD;
var protected transient name SpecialMove;
var protected transient name InteractorSpecialMove;
var protected transient name VehicleSpecialMove;
var protected transient Route SelectedRoute;
var protected transient Actor LastRouteReachedPoint;
var protected transient SkySeqAct_AIUseCover KismetCoverAction;
var protected transient int FrozenRefCount;
var transient float LastUpdatePawnRotationTime;
var transient Pawn CurrentEnemy;
var transient int BrainFreezeRefCount;
var(Scripted) Actor KismetScriptedTarget;
var(Scripted) Actor KismetScriptedFireTarget;
var int NumMoveRequestsIgnored;

function Actor GetFireTarget()
{
    return FireTarget;
    //return ReturnValue;    
}

event SeePlayer(Pawn Seen)
{
    super(Controller).SeePlayer(Seen);
    // End:0x50
    if((SkyPawn(Seen) != none) && SkyPawn(Seen).bMedusa)
    {
        Pawn.KilledBy(Seen);
        return;
    }
    // End:0x77
    if(bCanSee)
    {
        HandleSeePlayer(Seen);
        DistributeSeePlayer(Seen);
    }
    //return;    
}

// Export USkyBot::execHandleSeePlayer(FFrame&, void* const)
native function HandleSeePlayer(Pawn Seen);

// Export USkyBot::execDistributeSeePlayer(FFrame&, void* const)
native function DistributeSeePlayer(Pawn Seen);

event SeeMonster(Pawn Seen)
{
    super(Controller).SeeMonster(Seen);
    // End:0x32
    if(bCanSee)
    {
        HandleSeeMonster(Seen);
        DistributeSeeMonster(Seen);
    }
    //return;    
}

// Export USkyBot::execHandleSeeMonster(FFrame&, void* const)
native function HandleSeeMonster(Pawn Seen);

// Export USkyBot::execDistributeSeeMonster(FFrame&, void* const)
native function DistributeSeeMonster(Pawn Seen);

event HearNoise(float Loudness, Actor NoiseMaker, optional name NoiseType)
{
    super(Controller).HearNoise(Loudness, NoiseMaker, NoiseType);
    // End:0x51
    if(bCanHear)
    {
        HandleHearNoise(Loudness, NoiseMaker, NoiseType);
        DistributeHearNoise(Loudness, NoiseMaker, NoiseType);
    }
    //return;    
}

// Export USkyBot::execHandleHearNoise(FFrame&, void* const)
native function HandleHearNoise(float Loudness, Actor NoiseMaker, optional name NoiseType);

// Export USkyBot::execDistributeHearNoise(FFrame&, void* const)
native function DistributeHearNoise(float Loudness, Actor NoiseMaker, optional name NoiseType);

function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum)
{
    super(Controller).NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
    // End:0x6E
    if(bCanFeelPain)
    {
        HandleTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
        DistributeTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
    }
    //return;    
}

// Export USkyBot::execHandleTakeHit(FFrame&, void* const)
native function HandleTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum);

// Export USkyBot::execDistributeTakeHit(FFrame&, void* const)
native function DistributeTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum);

simulated event GetPlayerViewPoint(out Vector out_Location, out Rotator out_Rotation)
{
    // End:0x23
    if(Pawn != none)
    {
        out_Location = Pawn.Location;        
    }
    else
    {
        out_Location = Location;
    }
    out_Rotation = Rotation;
    //return;    
}

// Export USkyBot::execSetBehaviorTreeTemplate(FFrame&, void* const)
native final function SetBehaviorTreeTemplate(SkyBehaviorTree NewTemplate);

// Export USkyBot::execDeleteBehaviorTree(FFrame&, void* const)
native final function DeleteBehaviorTree();

// Export USkyBot::execFireExternalEvent(FFrame&, void* const)
native final function bool FireExternalEvent(string EventName);

// Export USkyBot::execAssignVariable(FFrame&, void* const)
native final function bool AssignVariable(string VarName, bool bIsGlobal, float NewValue);

function PostBeginPlay()
{
    super.PostBeginPlay();
    BotMemory = new (self) Class'SkyMemory';
    BotMemory.OwnerController = self;
    //return;    
}

function Possess(Pawn aPawn, bool bVehicleTransition)
{
    local bool bOnGround;
    local SkyPawn SP;

    super.Possess(aPawn, bVehicleTransition);
    bOnGround = Pawn.CheckForGround();
    SP = SkyPawn(aPawn);
    // End:0xD6
    if(Pawn.bCanFly && !bOnGround)
    {
        // End:0xA2
        if((SkyPawn(Pawn) != none) && SkyPawn(Pawn).CanRocketPack())
        {
            SkyPawn(Pawn).StartRocketPack();            
        }
        else
        {
            // End:0xD3
            if((SP == none) || !SP.bUseDefaultPhysics)
            {
                Pawn.SetPhysics(4);
            }
        }        
    }
    else
    {
        // End:0x122
        if((SP == none) || !SP.bUseDefaultPhysics)
        {
            // End:0x113
            if(bOnGround)
            {
                Pawn.SetPhysics(1);                
            }
            else
            {
                Pawn.SetPhysics(2);
            }
        }
    }
    SkyGame(WorldInfo.Game).AddDefaultInventory(Pawn);
    Pawn.MaxDesiredSpeed = 0.5000000;
    //return;    
}

function PawnDied(Pawn inPawn)
{
    local SkyGame GameInfo;

    GameInfo = SkyGame(WorldInfo.Game);
    GameInfo.ReturnMoveTicket(self);
    UnClaimCover();
    // End:0x56
    if(BotSquad != none)
    {
        BotSquad.NotifyKilled(self, inPawn);
    }
    // End:0x77
    if(BehaviorTree != none)
    {
        BehaviorTree.ShutDown();
        DeleteBehaviorTree();
    }
    // End:0xE7
    if(((TaintDeathLocationAmount > 0.0000000) && inPawn != none) && inPawn.Anchor != none)
    {
        inPawn.Anchor.FearCost = int(TaintDeathLocationAmount);
        WorldInfo.Game.bDoFearCostFallOff = true;
    }
    super.PawnDied(inPawn);
    Destroy();
    //return;    
}

event Destroyed()
{
    local SkyPawn P;
    local SkyGame GameInfo;

    GameInfo = SkyGame(WorldInfo.Game);
    GameInfo.ReturnMoveTicket(self);
    // End:0x4C
    if(BehaviorTree != none)
    {
        BehaviorTree.ShutDown();
        DeleteBehaviorTree();
    }
    // End:0x7D
    foreach WorldInfo.AllPawns(Class'SkyPawn', P)
    {
        P.ReleaseFireTicket(self);        
    }    
    super.Destroyed();
    //return;    
}

event BrainFreeze(bool bFreeze)
{
    // End:0x13
    if(bFreeze)
    {
        BrainFreezeRefCount++;        
    }
    else
    {
        BrainFreezeRefCount--;
        // End:0x2C
        if(BrainFreezeRefCount < 0)
        {
            BrainFreezeRefCount = 0;
        }
    }
    //return;    
}

simulated function SetSensoryPerception(bool bNewCanSee, bool bNewCanHear, bool bNewCanFeelPain)
{
    bCanSee = bNewCanSee;
    bCanHear = bNewCanHear;
    bCanFeelPain = bNewCanFeelPain;
    //return;    
}

simulated function HandleEnemySwitchedPawn(Pawn OldPawn, Pawn NewPawn)
{
    local SightMemory OldSM;

    OldSM = BotMemory.GetMemoryOf(OldPawn);
    // End:0x37
    if(OldSM.PawnSeen != OldPawn)
    {
        return;
    }
    // End:0x7F
    if(OldSM.bIgnoring && OldSM.bIgnoreWasSetByKismet)
    {
        BotMemory.SetIgnorePawn(NewPawn, true, -1.0000000, false);
        return;
    }
    BotMemory.SetIgnorePawn(OldPawn, true, -1.0000000, false);
    BotMemory.HandleSeenPawn(NewPawn);
    BotMemory.SetIgnorePawn(NewPawn, false, -1.0000000, false);
    // End:0xEA
    if(CurrentEnemy == OldPawn)
    {
        CurrentEnemy = NewPawn;
    }
    // End:0x104
    if(FireTarget == OldPawn)
    {
        FireTarget = NewPawn;
    }
    // End:0x11E
    if(MoveFocus == OldPawn)
    {
        MoveFocus = NewPawn;
    }
    // End:0x138
    if(KismetScriptedTarget == OldPawn)
    {
        KismetScriptedTarget = NewPawn;
    }
    // End:0x152
    if(KismetScriptedFireTarget == OldPawn)
    {
        KismetScriptedFireTarget = NewPawn;
    }
    super.HandleEnemySwitchedPawn(OldPawn, NewPawn);
    //return;    
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local Vector ScreenLoc, FocusLoc, ToBotVect;
    local string AOIds, DeadStatus, MoveStatus;
    local int nAOIdx;

    super.DisplayDebug(HUD, out_YL, out_YPos);
    ToBotVect = Normal(Pawn.Location - HUD.PlayerOwner.PlayerCamera.Location);
    // End:0x89
    if((ToBotVect Dot Vector(HUD.PlayerOwner.PlayerCamera.Rotation)) < 0.7500000)
    {
        return;
    }
    HUD.Canvas.SetPos(4.0000000, out_YPos);
    // End:0x4F9
    if(Pawn != none)
    {
        Pawn.DrawDebugCoordinateSystem(Pawn.Location + vect(0.0000000, 0.0000000, 100.0000000), Pawn.Rotation, 60.0000000);
        FocusLoc = HUD.Canvas.Project(Pawn.Location + vect(0.0000000, 0.0000000, 100.0000000));
        HUD.Canvas.SetPos(FocusLoc.X, FocusLoc.Y);
        HUD.Canvas.DrawTextClipped("Pawn");
        Pawn.DrawDebugCoordinateSystem(Pawn.Location + vect(0.0000000, 0.0000000, 160.0000000), Rotation, 60.0000000);
        FocusLoc = HUD.Canvas.Project(Pawn.Location + vect(0.0000000, 0.0000000, 160.0000000));
        HUD.Canvas.SetPos(FocusLoc.X, FocusLoc.Y);
        HUD.Canvas.DrawTextClipped("Controller");
        DrawDebugLine(Pawn.Location + vect(0.0000000, 0.0000000, 175.0000000), (Pawn.Location + vect(0.0000000, 0.0000000, 175.0000000)) + (Vector(DesiredRotation) * 100.0000000), 255, 255, 255);
        FocusLoc = HUD.Canvas.Project((Pawn.Location + vect(0.0000000, 0.0000000, 175.0000000)) + (Vector(DesiredRotation) * 100.0000000));
        HUD.Canvas.SetPos(FocusLoc.X, FocusLoc.Y);
        HUD.Canvas.DrawTextClipped("DesiredCont");
        // End:0x3FE
        if(((SkyPawn(Pawn) != none) && SkyPawn(Pawn).bAutomoveRotateToTarget) && SkyPawn(Pawn).AutomoveTarget != none)
        {
            DrawDebugLine(Pawn.Location, SkyPawn(Pawn).AutomoveTarget.Location, 255, 0, 255);
        }
        // End:0x4F9
        if(VSize(LastAvoidanceDir) > float(0))
        {
            FocusLoc = HUD.Canvas.Project(Pawn.Location + (LastAvoidanceDir * 150.0000000));
            Pawn.DrawDebugLine(Pawn.Location, Pawn.Location + (LastAvoidanceDir * 150.0000000), 0, 0, 255);
            HUD.Canvas.SetPos(FocusLoc.X, FocusLoc.Y);
            HUD.Canvas.DrawTextClipped("AvoidanceDirection");
        }
    }
    HUD.Canvas.SetDrawColor(255, 255, 255);
    // End:0x5E8
    if(Focus != none)
    {
        FocusLoc = HUD.Canvas.Project(Focus.Location);
        HUD.Canvas.SetPos(FocusLoc.X, FocusLoc.Y);
        HUD.Canvas.DrawTextClipped(string(Focus.Name));
        DrawDebugLine(Pawn.Location, Focus.Location, 255, 255, 0);
    }
    FocusLoc = HUD.Canvas.Project(GetFocalPoint());
    HUD.Canvas.SetPos(FocusLoc.X, FocusLoc.Y);
    HUD.Canvas.DrawTextClipped("Focal Point");
    DrawDebugLine(Pawn.Location, GetFocalPoint(), 0, 255, 255);
    ScreenLoc = HUD.Canvas.Project(Pawn.Location);
    ScreenLoc.X += float(50);
    HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
    HUD.Canvas.DrawTextClipped((((("Pawn:" @ string(Pawn.Name)) @ "(Team:") @ string(GetTeamNum())) $ ") Controller:") @ string(Name));
    ScreenLoc.Y += out_YL;
    HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
    HUD.Canvas.DrawTextClipped("Enemy:" @ string(CurrentEnemy));
    ScreenLoc.Y += out_YL;
    HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
    HUD.Canvas.DrawTextClipped("CurrentState:" @ string(GetStateName()));
    ScreenLoc.Y += out_YL;
    HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
    HUD.Canvas.DrawTextClipped("BurstFireState:" @ string(GetEnum(Enum'SkyBotControllerBase.EBurstFireState', int(BurstFireState))));
    // End:0xA11
    if(bAdjusting)
    {
        HUD.Canvas.SetDrawColor(100, 255, 50);
        FocusLoc = HUD.Canvas.Project(GetAdjustLocation());
        HUD.Canvas.SetPos(FocusLoc.X, FocusLoc.Y);
        HUD.Canvas.DrawTextClipped("AdjustingTo");
        DrawDebugLine(Pawn.Location, GetAdjustLocation(), 100, 255, 50);
        HUD.Canvas.SetDrawColor(255, 255, 255);
    }
    // End:0xAED
    if(BrainFreezeRefCount > 0)
    {
        HUD.Canvas.SetDrawColor(255, 0, 0);
        ScreenLoc.Y += out_YL;
        HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
        HUD.Canvas.DrawTextClipped("BrainFrozen RefCount:" @ string(BrainFreezeRefCount));
        HUD.Canvas.SetDrawColor(255, 255, 255);
    }
    // End:0xBFC
    if((IsMoveInputLocked()) || (SkySkelMeshComponent(Pawn.Mesh) != none) && SkySkelMeshComponent(Pawn.Mesh).LockInputCounter > 0)
    {
        HUD.Canvas.SetDrawColor(0, 255, 0);
        ScreenLoc.Y += out_YL;
        HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
        HUD.Canvas.DrawTextClipped("Input LOCKED!");
        HUD.Canvas.SetDrawColor(255, 255, 255);
    }
    MoveStatus = "MoveTimer:" $ string(MoveTimer);
    // End:0xCCA
    if(RouteCache.Length > 0)
    {
        ScreenLoc.Y += out_YL;
        HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
        HUD.Canvas.DrawTextClipped(((("Pathing:" @ string(RouteCache.Length)) @ "Next:") @ string(RouteCache[0])) @ MoveStatus);
        DrawDebugLogRoute();        
    }
    else
    {
        ScreenLoc.Y += out_YL;
        HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
        HUD.Canvas.DrawTextClipped("Not pathing" @ MoveStatus);
    }
    // End:0x102B
    if(BotSquad != none)
    {
        HUD.Canvas.SetDrawColor(255, 200, 255);
        ScreenLoc.Y += out_YL;
        HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
        // End:0xE1E
        if(IsSquadLeader())
        {
            HUD.Canvas.DrawTextClipped(("Squad:" @ string(BotSquad.SquadName)) @ "-- *LEADER*");            
        }
        else
        {
            DeadStatus = "";
            // End:0xE9A
            if(BotSquad.SquadLeader != none)
            {
                DeadStatus = (((BotSquad.SquadLeader.Pawn != none) && BotSquad.SquadLeader.Pawn.Health > 0) ? "" : "*IS DEAD*");
            }
            HUD.Canvas.DrawTextClipped(((("Squad:" @ string(BotSquad.SquadName)) @ "-- Leader=") $ string(BotSquad.SquadLeader)) @ DeadStatus);
        }
        // End:0xF20
        if(BotSquad.AreasOfOperation.Length <= 0)
        {
            AOIds = "NONE";            
        }
        else
        {
            AOIds = "";
            nAOIdx = 0;
            J0xF2F:

            // End:0xF77 [Loop If]
            if(nAOIdx < BotSquad.AreasOfOperation.Length)
            {
                AOIds = AOIds @ string(BotSquad.AreasOfOperation[nAOIdx]);
                ++nAOIdx;
                // [Loop Continue]
                goto J0xF2F;
            }
        }
        ScreenLoc.Y += out_YL;
        HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
        HUD.Canvas.DrawText(("AreaOfOperation = {" @ AOIds) @ "}", false);
        HUD.Canvas.SetDrawColor(255, 255, 255);        
    }
    else
    {
        ScreenLoc.Y += out_YL;
        HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
        HUD.Canvas.DrawTextClipped("-- No SQUAD --");
    }
    // End:0x117A
    if(bDebug)
    {
        ScreenLoc.Y += out_YL;
        HUD.Canvas.SetDrawColor(255, 50, 50);
        HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
        HUD.Canvas.DrawText("CURRENT DEBUG TARGET", false);
        HUD.Canvas.SetDrawColor(255, 255, 255);
    }
    // End:0x11BD
    if(HUD.ShouldDisplayDebug('Memory'))
    {
        BotMemory.DisplayDebug(HUD, out_YL, out_YPos);
    }
    // End:0x1203
    if(HUD.ShouldDisplayDebug('behtree') && BehaviorTree != none)
    {
        DisplayDebugBehTree(HUD, out_YL, out_YPos);
    }
    // End:0x12D9
    if(((Pawn != none) && Pawn.GangName != 'None') && HUD.ShouldDisplayDebug('Gangs'))
    {
        ScreenLoc.Y += out_YL;
        HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
        HUD.Canvas.DrawText("Gang: " $ string(Pawn.GangName));
    }
    ScreenLoc.Y += out_YL;
    HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
    HUD.Canvas.DrawText("Move Requests Ignored: " $ string(NumMoveRequestsIgnored));
    //return;    
}

simulated function DisplayDebugBehTree(HUD HUD, out float out_YL, out float out_YPos)
{
    local Canvas pCanvas;
    local SkyBTNode pNode;

    pNode = BehaviorTree;
    // End:0x2CD
    if(pNode != none)
    {
        pCanvas = HUD.Canvas;
        pCanvas.SetPos(pCanvas.CurX, pCanvas.CurY + float(25));
        pCanvas.DrawTextClipped(("Current BehaviorTree: (" $ string(BehaviorTreeTemplate)) $ ")");
        switch(BehaviorTree.LastStatus)
        {
            // End:0xC8
            case 4:
                DrawBehTreeNode(pNode, pCanvas);
                // End:0x2CD
                break;
            // End:0x170
            case 2:
                pCanvas.SetDrawColor(255, 128, 128);
                pCanvas.SetPos(pCanvas.CurX, pCanvas.CurY + float(15));
                pCanvas.DrawTextClipped(((string(pNode.Class.Name) @ "[") $ string(pNode.NodeName)) $ "] - FAILED");
                // End:0x2CD
                break;
            // End:0x221
            case 3:
                pCanvas.SetDrawColor(255, 0, 0);
                pCanvas.SetPos(pCanvas.CurX, pCanvas.CurY + float(15));
                pCanvas.DrawTextClipped(((string(pNode.Class.Name) @ "[") $ string(pNode.NodeName)) $ "] - FAILED ABNORMAL");
                // End:0x2CD
                break;
            // End:0x2CA
            case 1:
                pCanvas.SetDrawColor(0, 255, 0);
                pCanvas.SetPos(pCanvas.CurX, pCanvas.CurY + float(15));
                pCanvas.DrawTextClipped(((string(pNode.Class.Name) @ "[") $ string(pNode.NodeName)) $ "] - SUCCESS");
                // End:0x2CD
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        //return;        
    }
}

simulated function DrawBehTreeNode(SkyBTNode pNode, Canvas pCanvas)
{
    local SkyBTNode_Leaf pLeafNode;
    local SkyBTNode_Blend pInteriorNode;
    local string NodeName;
    local int I;

    // End:0x53
    if(pCanvas.CurY > float(pCanvas.SizeY - 35))
    {
        pCanvas.SetPos(pCanvas.CurX + float(80), 5.0000000);
    }
    pLeafNode = SkyBTNode_Leaf(pNode);
    pInteriorNode = SkyBTNode_Blend(pNode);
    NodeName = ((string(pNode.Class.Name) @ "[") $ string(pNode.NodeName)) $ "]";
    // End:0x281
    if((pNode != none) && int(pNode.LastStatus) == int(4))
    {
        // End:0x20C
        if(pInteriorNode != none)
        {
            pCanvas.SetDrawColor(255, 255, 255);
            pCanvas.SetPos(pCanvas.CurX, pCanvas.CurY + float(15));
            pCanvas.DrawTextClipped(NodeName);
            pCanvas.SetPos(pCanvas.CurX + float(10), pCanvas.CurY);
            I = 0;
            J0x182:

            // End:0x1D5 [Loop If]
            if(I < pInteriorNode.Children.Length)
            {
                DrawBehTreeNode(pInteriorNode.Children[I].BTNode, pCanvas);
                ++I;
                // [Loop Continue]
                goto J0x182;
            }
            pCanvas.SetPos(pCanvas.CurX - float(10), pCanvas.CurY);            
        }
        else
        {
            // End:0x281
            if(pLeafNode != none)
            {
                pCanvas.SetDrawColor(0, 255, 0);
                pCanvas.SetPos(pCanvas.CurX - float(2), pCanvas.CurY + float(15));
                pCanvas.DrawTextClipped(NodeName);
            }
        }
    }
    //return;    
}

simulated function OnGodSight(SkySeqAct_GodSight GSAction)
{
    local int Idx;
    local Pawn NewTarget;
    local array<Pawn> GSTargets;
    local Controller C;

    // End:0xB1
    if(GSAction.GodSightTargets.Length > 0)
    {
        Idx = 0;
        J0x1D:

        // End:0xAE [Loop If]
        if(Idx < GSAction.GodSightTargets.Length)
        {
            NewTarget = Pawn(GSAction.GodSightTargets[Idx]);
            // End:0x8C
            if(NewTarget == none)
            {
                NewTarget = Controller(GSAction.GodSightTargets[Idx]).Pawn;
            }
            // End:0xA4
            if(NewTarget != none)
            {
                GSTargets.AddItem(NewTarget);
            }
            ++Idx;
            // [Loop Continue]
            goto J0x1D;
        }        
    }
    else
    {
        // End:0x10D
        foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
        {
            // End:0x10C
            if(int(C.GetTeamNum()) != int(GetTeamNum()))
            {
                GSTargets.AddItem(C.Pawn);
            }            
        }        
    }
    Idx = 0;
    J0x115:

    // End:0x18A [Loop If]
    if(Idx < GSTargets.Length)
    {
        // End:0x165
        if(GSAction.bGodSight)
        {
            BotMemory.GiveGodSightFor(GSTargets[Idx], GSAction.GodSightDuration);
            // [Explicit Continue]
            goto J0x180;
        }
        BotMemory.CancelGodSightFor(GSTargets[Idx]);
        J0x180:

        ++Idx;
        // [Loop Continue]
        goto J0x115;
    }
    //return;    
}

simulated function OnIgnorePawn(SkySeqAct_IgnorePawn inAction)
{
    local int Idx;
    local Pawn NewTarget;
    local array<Pawn> IgnoreTargets;

    // End:0x19
    if(inAction.IgnoreTargets.Length == 0)
    {        
    }
    else
    {
        Idx = 0;
        J0x20:

        // End:0x1C2 [Loop If]
        if(Idx < inAction.IgnoreTargets.Length)
        {
            // End:0x85
            if(inAction.IgnoreTargets[Idx].IsA('Pawn'))
            {
                NewTarget = Pawn(inAction.IgnoreTargets[Idx]);                
            }
            else
            {
                // End:0xDA
                if(inAction.IgnoreTargets[Idx].IsA('Controller'))
                {
                    NewTarget = Controller(inAction.IgnoreTargets[Idx]).Pawn;                    
                }
                else
                {
                    // End:0x12C
                    if(inAction.IgnoreTargets[Idx].IsA('SkyVehicleFactory'))
                    {
                        NewTarget = SkyVehicleFactory(inAction.IgnoreTargets[Idx]).ChildVehicle;
                    }
                }
            }
            // End:0x1B8
            if(NewTarget != none)
            {
                IgnoreTargets.AddItem(NewTarget);
                // End:0x18C
                if((Vehicle(NewTarget) != none) && Vehicle(NewTarget).Driver != none)
                {
                    IgnoreTargets.AddItem(Vehicle(NewTarget).Driver);
                }
                // End:0x1B8
                if(NewTarget.DrivenVehicle != none)
                {
                    IgnoreTargets.AddItem(NewTarget.DrivenVehicle);
                }
            }
            ++Idx;
            // [Loop Continue]
            goto J0x20;
        }
        Idx = 0;
        J0x1C9:

        // End:0x21E [Loop If]
        if(Idx < IgnoreTargets.Length)
        {
            BotMemory.SetIgnorePawn(IgnoreTargets[Idx], inAction.bIgnoreTarget, inAction.IgnoreDuration, true);
            ++Idx;
            // [Loop Continue]
            goto J0x1C9;
        }
    }
    //return;    
}

// Export USkyBot::execGetTeamNum(FFrame&, void* const)
native simulated function byte GetTeamNum();

event bool CheckValidMelee(SkyInteractor theTarget)
{
    local SkyPawn_MaxValenti Player;

    Player = SkyPawn_MaxValenti(theTarget);
    // End:0x1D
    if(Player == none)
    {
        return false;
    }
    // End:0x55
    if(Player.PrimaryWSM != none)
    {
        // End:0x55
        if(Player.PrimaryWSM.IsTransitioning())
        {
            return false;
        }
    }
    // End:0x94
    if(!IsPlayingReaction())
    {
        // End:0x94
        if(WorldInfo.TimeSeconds >= SkyGame(WorldInfo.Game).BotNextAvailableMeleeTime)
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

event SetTeam(int inTeamIdx)
{
    TeamNumber = byte(inTeamIdx);
    //return;    
}

// Export USkyBot::execGetAdjustedAimFor(FFrame&, void* const)
native function Rotator GetAdjustedAimFor(Weapon W, Vector StartFireLoc);

protected function GetBurstFireInfo(out SkyBotBurstFireStruct burstInfo)
{
    // End:0x19
    if(!IsInCover())
    {
        burstInfo = BurstFireSettingsNoCover;        
    }
    else
    {
        // End:0x4B
        if(int(SkyPawnCoverUser(Pawn).GetCoverOrientation()) == int(0))
        {
            burstInfo = BurstFireSettingsHorizCover;            
        }
        else
        {
            // End:0x7D
            if(int(SkyPawnCoverUser(Pawn).GetCoverOrientation()) == int(1))
            {
                burstInfo = BurstFireSettingsVertUpCover;                
            }
            else
            {
                // End:0xAC
                if(int(SkyPawnCoverUser(Pawn).GetCoverOrientation()) == int(2))
                {
                    burstInfo = BurstFireSettingsVertDownCover;
                }
            }
        }
    }
    //return;    
}

protected function BurstFireReady()
{
    BurstFireState = 0;
    // End:0x1F
    if(!FireWeaponAt(FireTarget))
    {        
    }
    else
    {
        bIsFirstShotOfBurstRound = true;
    }
    //return;    
}

protected function BurstFireEnd()
{
    local float pauseDuration;
    local SkyPawn TargetSP;

    TargetSP = SkyPawn(FireTarget);
    // End:0x2B
    if(TargetSP == none)
    {
        TargetSP = SkyPawn(CurrentEnemy);
    }
    // End:0x52
    if(bMustAcquireFireTicketBeforeAttack && TargetSP != none)
    {
        TargetSP.ReleaseFireTicket(self);
    }
    GetBurstFireInfo(BurstFireInfo);
    pauseDuration = Lerp(BurstFireInfo.MinTimeBetweenFiringBursts, BurstFireInfo.MaxTimeBetweenFiringBursts, FRand());
    SetTimer(pauseDuration, false, 'BurstFireReady');
    BurstFireState = 2;
    StopFiring();
    //return;    
}

function bool CanAttack(Actor Other)
{
    local float DistFromOtherSq;

    // End:0xB8
    if(((Other != none) && Pawn != none) && SkyWeapon(Pawn.Weapon) != none)
    {
        DistFromOtherSq = VSizeSq(Other.Location - Pawn.Location);
        // End:0xB8
        if((DistFromOtherSq < Square(SkyWeapon(Pawn.Weapon).BotWeaponUseMinRange)) || DistFromOtherSq > Square(SkyWeapon(Pawn.Weapon).BotWeaponUseRange))
        {
            return false;
        }
    }
    return Pawn.CanAttack(Other);
    //return ReturnValue;    
}

protected function bool FireWeaponAtHelper(Actor TargetActor)
{
    local bool bFireSuccess, bNeedToTurn, bCanAttack;

    // End:0x30
    if((SkyPawn(TargetActor) != none) && SkyPawn(TargetActor).IsHijacking())
    {
        return false;
    }
    // End:0x42
    if(!LockFocusOn(TargetActor))
    {
        return false;
    }
    // End:0x4F
    if(Focus == none)
    {
        return false;
    }
    // End:0x8B
    if((Pawn.Weapon != none) && !Pawn.Weapon.HasAnyAmmo())
    {
        return false;
    }
    // End:0xAA
    if(BotMemory.IsFriendlyInLineOfFire(TargetActor, FriendlyFireCosAngle))
    {
        return false;
    }
    // End:0x194
    if(!Pawn.IsFiring())
    {
        bNeedToTurn = Pawn.NeedToTurn(TargetActor.Location);
        bCanAttack = CanAttack(TargetActor);
        // End:0x191
        if((((Pawn.Weapon != none) && Pawn.Weapon.bMeleeWeapon) || int(Pawn.Physics) == int(7)) || !bNeedToTurn && bCanAttack)
        {
            bFireSuccess = Pawn.BotFire(false);
            return bFireSuccess;            
        }        
    }
    else
    {
        // End:0x1CC
        if(!TargetActor.bDeleteMe)
        {
            bFireSuccess = Pawn.BotFire(false);
            return bFireSuccess;
        }
    }
    return false;
    //return ReturnValue;    
}

// Export USkyBot::execAdjustMarkerRating(FFrame&, void* const)
protected native final function AdjustMarkerRating(CoverSlotMarker Marker, float BestRating, optional out float Rating);

// Export USkyBot::execIsValidCover(FFrame&, void* const)
protected native final function bool IsValidCover(const out CoverInfo TestCover);

// Export USkyBot::execGetPawnCover(FFrame&, void* const)
protected native final function bool GetPawnCover(Pawn PawnToCheck, out CoverInfo PawnCover, optional bool bCanGuess);

// Export USkyBot::execIsCoverExposedToAnEnemy(FFrame&, void* const)
protected native final function bool IsCoverExposedToAnEnemy(CoverInfo TestCover, optional Pawn TestEnemy, optional bool bActualLocation, optional float ExtrapolatePositionTime);

// Export USkyBot::execIsCoverExposedToAnyKnownEnemy(FFrame&, void* const)
protected native final function bool IsCoverExposedToAnyKnownEnemy(CoverInfo TestCover, optional bool bActualLocation, optional float ExtrapolatePositionTime);

// Export USkyBot::execIsInASquad(FFrame&, void* const)
native final function bool IsInASquad();

// Export USkyBot::execIsSquadLeader(FFrame&, void* const)
native final function bool IsSquadLeader();

// Export USkyBot::execSquadHasChanged(FFrame&, void* const)
native final function SquadHasChanged(SkySquadInfo NewSquad);

// Export USkyBot::execSquadAOHasChanged(FFrame&, void* const)
native final function SquadAOHasChanged();

// Export USkyBot::execGetLastKnownLocationOfEnemy(FFrame&, void* const)
native final function Vector GetLastKnownLocationOfEnemy();

// Export USkyBot::execFindCover(FFrame&, void* const)
native final function bool FindCover(SkyBot.EFindCoverSearchType SearchType, Actor GoalActor, out CoverInfo FoundCover);

// Export USkyBot::execFindClosestDestructibleCover(FFrame&, void* const)
native final function CoverSlotMarker FindClosestDestructibleCover(const out Vector SearchLocation, float SearchRadius);

// Export USkyBot::execSetFindCoverDistances(FFrame&, void* const)
native final function SetFindCoverDistances(float MinCoverDistFromEnemy, float MaxCoverDistFromEnemy, float MinCoverDistFromMe, float MaxCoverDistFromMe);

// Export USkyBot::execRestoreDefaultCoverDistances(FFrame&, void* const)
native final function RestoreDefaultCoverDistances();

// Export USkyBot::execSetProhibitPassingEnemyForCover(FFrame&, void* const)
native final function SetProhibitPassingEnemyForCover(bool bProhibitPassing);

// Export USkyBot::execSetValidCoverCone(FFrame&, void* const)
native final function SetValidCoverCone(Vector ConeDir, float ConeAngle);

// Export USkyBot::execRestoreDefaultValidCoverCone(FFrame&, void* const)
native final function RestoreDefaultValidCoverCone();

// Export USkyBot::execSetRespectAreaOfOperation(FFrame&, void* const)
native final function SetRespectAreaOfOperation(bool bRespect);

// Export USkyBot::execFindFleeFrom(FFrame&, void* const)
native final function NavigationPoint FindFleeFrom(Actor FleeFrom);

// Export USkyBot::execSetFleeDistances(FFrame&, void* const)
native final function SetFleeDistances(float MinFleeFromThem, float MaxFleeFromThem, float MinDistFromMe);

// Export USkyBot::execRestoreDefaultFleeDistances(FFrame&, void* const)
native final function RestoreDefaultFleeDistances();

// Export USkyBot::execFindFlankingRoute(FFrame&, void* const)
native final function NavigationPoint FindFlankingRoute(Actor ToFlank, float AvoidTargetRadius, float MaxFlankingRadius, float GetBehindTargetAngle);

// Export USkyBot::execIsInCover(FFrame&, void* const)
native final function bool IsInCover();

// Export USkyBot::execGetCoverNormal(FFrame&, void* const)
native final function Vector GetCoverNormal();

final event bool ClaimCover(CoverInfo CoverToClaim)
{
    local bool bResult;

    bResult = false;
    // End:0x70
    if(IsValidCover(CoverToClaim))
    {
        // End:0x1F
        if(UnClaimCover())
        {
        }
        bResult = CoverToClaim.Link.Claim(Pawn, CoverToClaim.SlotIdx);
        // End:0x6D
        if(bResult)
        {
            ClaimedCover = CoverToClaim;            
        }        
    }
    return bResult;
    //return ReturnValue;    
}

final event bool UnClaimCover()
{
    // End:0x76
    if(ClaimedCover.Link != none)
    {
        // End:0x4C
        if(!ClaimedCover.Link.UnClaim(Pawn, ClaimedCover.SlotIdx, true))
        {
        }
        ClaimedCover.Link = none;
        ClaimedCover.SlotIdx = -1;
        return true;
    }
    return false;
    //return ReturnValue;    
}

// Export USkyBot::execGetClaimedCoverMarker(FFrame&, void* const)
native final function CoverSlotMarker GetClaimedCoverMarker();

final event bool FindAndClaimCover(Actor CoverFrom)
{
    local CoverInfo FindCoverInfo;

    // End:0x21
    if(FindCover(0, CoverFrom, FindCoverInfo))
    {
        return ClaimCover(FindCoverInfo);
    }
    return false;
    //return ReturnValue;    
}

final event bool TakeCover(optional CoverSlotMarker CoverToTake, optional bool bSkipValidateCover)
{
    // End:0x0D
    if(IsInCover())
    {
        return false;
    }
    // End:0x18
    if(IsDoingCoverManeuver())
    {
        return false;
    }
    // End:0x28
    if(IsMovingToGoal())
    {
        AbortMove();
    }
    // End:0x37
    if(IsScriptedMoving())
    {
        AbortScriptedMove();
    }
    // End:0x51
    if(IsFiring() || IsBurstFiring())
    {
        StopAllFiring();
    }
    // End:0x90
    if(CoverToTake == none)
    {
        CoverToTake = CoverSlotMarker(MoveGoal);
        // End:0x90
        if(CoverToTake == none)
        {
            CoverToTake = GetClaimedCoverMarker();
            // End:0x90
            if(CoverToTake == none)
            {
                return false;
            }
        }
    }
    // End:0xD9
    if((!bSkipValidateCover && CoverToTake != Pawn.Anchor) && !InRange(CoverToTake.Location, 200.0000000))
    {
        return false;
    }
    CoverToEnter = CoverToTake;
    PushState('Behavior_EnterCover');
    return true;
    //return ReturnValue;    
}

// Export USkyBot::execExitCover(FFrame&, void* const)
native final function bool ExitCover();

// Export USkyBot::execAtEdgeOfCover(FFrame&, void* const)
native final function bool AtEdgeOfCover();

// Export USkyBot::execCanDiveOutOfCover(FFrame&, void* const)
native final function bool CanDiveOutOfCover();

// Export USkyBot::execCanSlipOutOfCover(FFrame&, void* const)
native final function bool CanSlipOutOfCover();

// Export USkyBot::execCanMantleOverCover(FFrame&, void* const)
native final function bool CanMantleOverCover();

// Export USkyBot::execDiveOutOfCover(FFrame&, void* const)
native final function bool DiveOutOfCover();

// Export USkyBot::execSlipOutOfCover(FFrame&, void* const)
native final function bool SlipOutOfCover();

// Export USkyBot::execMantleOverCover(FFrame&, void* const)
native final function bool MantleOverCover();

final event bool CanSwatTurn()
{
    local CoverReference STRef;
    local CoverInfo STInfo;

    // End:0x7E
    if(SkyPawnCoverUser(Pawn).super(SkyBot).CanSwatTurn(STRef, true))
    {
        STInfo.Link = CoverLink(NavigationPoint(STRef.Actor));
        STInfo.SlotIdx = STRef.SlotIdx;
        // End:0x7E
        if(!IsCoverExposedToAnyKnownEnemy(STInfo))
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

final event bool SwatTurn()
{
    // End:0x0D
    if(!IsInCover())
    {
        return false;
    }
    // End:0x18
    if(IsDoingCoverManeuver())
    {
        return false;
    }
    PushState('Behavior_SwatTurn');
    return true;
    //return ReturnValue;    
}

// Export USkyBot::execIsEnteringCover(FFrame&, void* const)
native final function bool IsEnteringCover();

// Export USkyBot::execIsExitingCover(FFrame&, void* const)
native final function bool IsExitingCover();

// Export USkyBot::execIsSwatTurning(FFrame&, void* const)
native final function bool IsSwatTurning();

// Export USkyBot::execIsDoingCoverManeuver(FFrame&, void* const)
native final function bool IsDoingCoverManeuver();

// Export USkyBot::execIsInCoverNotIdle(FFrame&, void* const)
native final function bool IsInCoverNotIdle();

// Export USkyBot::execIsClaimedCoverExposed(FFrame&, void* const)
native final function bool IsClaimedCoverExposed(bool bCheatEnemyLocation);

// Export USkyBot::execSelectBestCoverAction(FFrame&, void* const)
native final function CoverLink.ECoverAction SelectBestCoverAction(optional Pawn ActionTarget);

// Export USkyBot::execSetCoverAction(FFrame&, void* const)
native final function bool SetCoverAction(CoverLink.ECoverAction Action);

// Export USkyBot::execGetCoverAction(FFrame&, void* const)
native final function CoverLink.ECoverAction GetCoverAction();

// Export USkyBot::execApplyBestCoverAction(FFrame&, void* const)
native final function bool ApplyBestCoverAction();

// Export USkyBot::execFindTurret(FFrame&, void* const)
native final function bool FindTurret(float MinDist, float MaxDist, Actor RelativeTo, float MinDistFromActor, float MaxDistFromActor, out NavigationPoint TurretPoint);

// Export USkyBot::execFindDangerObjectNearby(FFrame&, void* const)
native final function Actor FindDangerObjectNearby(optional float Range);

function bool FireWeaponAt(Actor TargetActor)
{
    local bool Success;
    local float burstDuration;
    local SkyPawn TargetSP;
    local SkyWeapon SW;
    local int I;

    // End:0x17
    if(TargetActor == none)
    {
        StopFiring();
        return false;
    }
    // End:0xB4
    if(((((((SkyPawn(TargetActor) != none) && SkyPawn(TargetActor).bGoingIntervehicular) || IsPlayingReaction()) || IsDoingCoverManeuver()) || CannotInterruptMove()) || IsSecondaryWeaponDrawn()) || IsInCover() && !bWantsToTarget)
    {
        StopFiring();
        ClearTimer('BurstFireEnd');
        SetTimer(0.5000000, false, 'BurstFireReady');
        return false;
    }
    TargetSP = SkyPawn(TargetActor);
    // End:0x123
    if((bMustAcquireFireTicketBeforeAttack && TargetSP != none) && !TargetSP.ClaimFireTicket(self, false, false))
    {
        StopFiring();
        ClearTimer('BurstFireEnd');
        SetTimer(0.5000000, false, 'BurstFireReady');
        return false;
    }
    FireTarget = TargetActor;
    SW = SkyWeapon(Pawn.Weapon);
    // End:0x1A2
    if((Pawn != none) && SW != none)
    {
        I = 0;
        J0x167:

        // End:0x1A2 [Loop If]
        if(I < SW.bAutoAim.Length)
        {
            SW.bAutoAim[I] = false;
            ++I;
            // [Loop Continue]
            goto J0x167;
        }
    }
    // End:0x1BD
    if(int(BurstFireState) == int(1))
    {
        Success = true;        
    }
    else
    {
        StopFiring();
        GetBurstFireInfo(BurstFireInfo);
        burstDuration = Lerp(BurstFireInfo.MinDurationOfFiringBurst, BurstFireInfo.MaxDurationOfFiringBurst, FRand());
        SetTimer(burstDuration, false, 'BurstFireEnd');
        ClearTimer('BurstFireReady');
        Success = FireWeaponAtHelper(TargetActor);
        // End:0x26A
        if(!Success)
        {
            ClearTimer('BurstFireEnd');
            SetTimer(0.5000000, false, 'BurstFireReady');            
        }
        else
        {
            InternalBurstStreamCounter++;
            BurstFireState = 1;
            // End:0x29E
            if(SkyPawn(TargetActor) != none)
            {
                SkyPawn(TargetActor).FiredUpon();
            }
        }
    }
    return Success;
    //return ReturnValue;    
}

final event bool StartBurstFiring(Actor TargetActor)
{
    return FireWeaponAt(TargetActor);
    //return ReturnValue;    
}

final event bool StartContinuousFiring()
{
    local SkyPawn TargetSP;

    TargetSP = SkyPawn(FireTarget);
    // End:0x2B
    if(TargetSP == none)
    {
        TargetSP = SkyPawn(CurrentEnemy);
    }
    // End:0x7A
    if((bMustAcquireFireTicketBeforeAttack && TargetSP != none) && !TargetSP.ClaimFireTicket(self, false, false))
    {
        StopFiring();
        SetTimer(0.5000000, false, 'StartContinuousFiring');
        return false;
    }
    Pawn.BotFire(false);
    return true;
    //return ReturnValue;    
}

// Export USkyBot::execIsFiring(FFrame&, void* const)
native final function bool IsFiring();

// Export USkyBot::execIsBurstFiring(FFrame&, void* const)
native final function bool IsBurstFiring();

final event StopAllFiring()
{
    local SkyPawn TargetSP, MySP;
    local int Idx, NumAuxWeaps;

    // End:0x09
    if(IsBurstFiring())
    {
    }
    TargetSP = SkyPawn(FireTarget);
    // End:0x34
    if(TargetSP == none)
    {
        TargetSP = SkyPawn(CurrentEnemy);
    }
    // End:0x5B
    if(bMustAcquireFireTicketBeforeAttack && TargetSP != none)
    {
        TargetSP.ReleaseFireTicket(self);
    }
    bFire = 0;
    // End:0x82
    if(Pawn != none)
    {
        Pawn.StopFiring();
    }
    ClearTimer('BurstFireReady');
    ClearTimer('BurstFireEnd');
    BurstFireState = 0;
    NumAuxWeaps = 0;
    MySP = SkyPawn(Pawn);
    // End:0xE2
    if(MySP != none)
    {
        NumAuxWeaps = MySP.AuxWeapons.Length;
    }
    Idx = 0;
    J0xE9:

    // End:0x137 [Loop If]
    if(Idx < NumAuxWeaps)
    {
        // End:0x12D
        if(MySP.IsAuxWeaponFiring(Idx))
        {
            MySP.StopAuxWeaponFire(Idx);
        }
        ++Idx;
        // [Loop Continue]
        goto J0xE9;
    }
    //return;    
}

final event bool DrawSecondaryWeapon(optional float AutoThrowTimer)
{
    local SkyPawn SP;

    // End:0x1B
    if(IsFiring() || IsBurstFiring())
    {
        StopAllFiring();
    }
    // End:0x26
    if(IsSecondaryWeaponDrawn())
    {
        return true;
    }
    SP = SkyPawn(Pawn);
    // End:0x8E
    if(CanUseSecondaryWeapon())
    {
        SP.StartSecondaryItemFire(SP.ChooseFireMode());
        // End:0x89
        if(AutoThrowTimer > 0.0000000)
        {
            SetTimer(AutoThrowTimer, false, 'ReleaseSecondaryWeapon');
        }
        return true;        
    }
    else
    {
        SP.SecondaryWSM.TryHolster();
    }
    return false;
    //return ReturnValue;    
}

final event float GetSecondaryWeaponThrowTime()
{
    local SkySecondaryItem SI;

    SI = SkySecondaryItem(SkyPawn(Pawn).SecondaryWeapon);
    // End:0x4F
    if(SI != none)
    {
        return SI.BotMinHoldBeforeUseSec + (FRand() * SI.BotHoldBeforeUseRandSec);
    }
    return -1.0000000;
    //return ReturnValue;    
}

final event bool CanUseSecondaryWeapon()
{
    local SkyPawn SP;
    local float DistFromOtherSq;
    local Actor AttackingTarget;

    SP = SkyPawn(Pawn);
    AttackingTarget = FireTarget;
    // End:0x31
    if(AttackingTarget == none)
    {
        AttackingTarget = CurrentEnemy;
    }
    // End:0xE9
    if(((AttackingTarget != none) && SP != none) && SkyWeapon(SP.SecondaryWeapon) != none)
    {
        DistFromOtherSq = VSizeSq(AttackingTarget.Location - Pawn.Location);
        // End:0xE9
        if((DistFromOtherSq < Square(SkyWeapon(SP.SecondaryWeapon).BotWeaponUseMinRange)) || DistFromOtherSq > Square(SkyWeapon(SP.SecondaryWeapon).BotWeaponUseRange))
        {
            return false;
        }
    }
    return (SP != none) && SP.CanSecondaryItemFire();
    //return ReturnValue;    
}

final event bool IsSecondaryWeaponDrawn()
{
    return (SkyPawn(Pawn) != none) && SkyPawn(Pawn).UsingSecondaryItem();
    //return ReturnValue;    
}

final event bool ReleaseSecondaryWeapon(optional Actor AttackTarget)
{
    local SkyItem_Dynamite SI;
    local SkyPawn SP;

    SP = SkyPawn(Pawn);
    // End:0xF6
    if(IsSecondaryWeaponDrawn())
    {
        // End:0x30
        if(AttackTarget == none)
        {
            AttackTarget = CurrentEnemy;
        }
        SI = SkyItem_Dynamite(SP.SecondaryWeapon);
        // End:0xC1
        if(((AttackTarget != none) && SI != none) && SI.HeldItem != none)
        {
            SkyProj_SecondaryItem(SI.HeldItem).StartingVelocity = 0.9000000 * VSize(AttackTarget.Location - SP.Location);
        }
        SP.ReleaseSecondaryItem();
        SP.SecondaryWSM.TryHolster();
        return true;
    }
    return false;
    //return ReturnValue;    
}

function GetSecondaryThrowableDirSpeed(out Vector AimDir, out Vector ExtraVel)
{
    local Actor Target;
    local float UpFactor;

    Target = FireTarget;
    // End:0x21
    if(Target == none)
    {
        Target = CurrentEnemy;
    }
    // End:0x16D
    if(Target != none)
    {
        AimDir = Normal(Target.Location - Pawn.Location);
        ExtraVel = vect(0.0000000, 0.0000000, 0.0000000);
        // End:0x10A
        if(Target.Location.Z > (Pawn.Location.Z + Pawn.CylinderComponent.CollisionHeight))
        {
            ExtraVel.Z += ((Target.Location.Z - Pawn.Location.Z) * 2.0000000);
        }
        UpFactor = VSize2D(Target.Location - Pawn.Location) / 1000.0000000;
        // End:0x16A
        if(UpFactor > 1.0000000)
        {
            ExtraVel.Z += (300.0000000 * UpFactor);
        }        
    }
    else
    {
        AimDir = Vector(DesiredRotation);
        ExtraVel = vect(0.0000000, 0.0000000, 0.0000000);
    }
    //return;    
}

// Export USkyBot::execInRange(FFrame&, void* const)
native final function bool InRange(Vector TestLocation, float Range);

// Export USkyBot::execInShortRange(FFrame&, void* const)
native final function bool InShortRange(Vector TestLocation);

// Export USkyBot::execInMediumRange(FFrame&, void* const)
native final function bool InMediumRange(Vector TestLocation);

// Export USkyBot::execInLongRange(FFrame&, void* const)
native final function bool InLongRange(Vector TestLocation);

// Export USkyBot::execIsUsingAreaOfOperation(FFrame&, void* const)
native final function bool IsUsingAreaOfOperation();

// Export USkyBot::execIsTargetInsideAreaOfOperation(FFrame&, void* const)
native final function bool IsTargetInsideAreaOfOperation(Actor TestTarget);

// Export USkyBot::execSetAreaOfOperationPathWeighting(FFrame&, void* const)
native final function SetAreaOfOperationPathWeighting(bool bEnable);

// Export USkyBot::execIsPathingCompletedForAreaOfOperation(FFrame&, void* const)
native final function bool IsPathingCompletedForAreaOfOperation();

function OnAIAbortMoveToActor(SeqAct_AIAbortMoveToActor Action)
{
    super(AIController).OnAIAbortMoveToActor(Action);
    //return;    
}

function OnAIMoveToActor(SeqAct_AIMoveToActor Action)
{
    local SeqVar_Object ObjVar;
    local Route NewRoute;

    // End:0x0F
    if(IsScriptedMoving())
    {
        AbortScriptedMove();
    }
    // End:0x72
    foreach Action.LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Destination")
    {
        NewRoute = Route(ObjVar.GetObjectValue());
        // End:0x71
        if(NewRoute != none)
        {
            SelectedRoute = NewRoute;
            // End:0x72
            break;
        }        
    }    
    bScriptedMoveInterruptable = Action.bInterruptable;
    // End:0xAD
    if(!bScriptedMoveInterruptable && BrainFreezeRefCount == 0)
    {
        BrainFreeze(true);
    }
    // End:0xCC
    if(Action.bDisableFocusLock)
    {
        UnlockFocus();
        StopAllFiring();
    }
    super(AIController).OnAIMoveToActor(Action);
    //return;    
}

event AIFactoryMoveTo(Actor destActor, optional bool bMoveInterruptable, optional Actor FactoryMoveFocus)
{
    local Route NewRoute;

    // End:0x11
    if(IsScriptedMoving())
    {
        AbortScriptedMove();
    }
    NewRoute = Route(destActor);
    // End:0x37
    if(NewRoute != none)
    {
        SelectedRoute = NewRoute;
    }
    bScriptedMoveInterruptable = bMoveInterruptable;
    // End:0x67
    if(!bScriptedMoveInterruptable && BrainFreezeRefCount == 0)
    {
        BrainFreeze(true);
    }
    super.AIFactoryMoveTo(destActor, bMoveInterruptable, FactoryMoveFocus);
    //return;    
}

function NotifyScriptedMoveComplete()
{
    // End:0x23
    if(!bScriptedMoveInterruptable && BrainFreezeRefCount > 0)
    {
        BrainFreeze(false);
    }
    //return;    
}

// Export USkyBot::execModifyLeaderPacingParams(FFrame&, void* const)
native final function ModifyLeaderPacingParams(float InnerRadius, float OuterRadius, float InnerRadiusSpeed, float OuterRadiusMinSpeed, float OuterRadiusMaxSpeed, float AbsoluteMinSpeed, float AbsoluteMinSpeedDistance);

final event bool IsScriptedMoving()
{
    return IsInState('ScriptedMove', true) || IsInState('ScriptedRouteMove', true);
    //return ReturnValue;    
}

final event AbortScriptedMove()
{
    // End:0x6B
    if(IsScriptedMoving())
    {
        ClearLatentAction(Class'Engine.SeqAct_AIMoveToActor', true);
        ScriptedRoute = none;
        ScriptedMoveTarget = none;
        ScriptedFocus = none;
        NotifyScriptedMoveComplete();
        // End:0x5D
        if(Pawn != none)
        {
            Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        }
        GotoState('Behavior_Base');
    }
    //return;    
}

final event bool ResumePatrol()
{
    // End:0x46
    if((SkyPawn_Archon(Pawn) != none) && SkyPawn_Archon(Pawn).IsVerticalTransitioning() || SkyPawn_Archon(Pawn).IsJumping())
    {
        return false;
    }
    // End:0x7F
    if(SelectedRoute != none)
    {
        // End:0x60
        if(IsScriptedMoving())
        {
            AbortScriptedMove();
        }
        // End:0x70
        if(IsMovingToGoal())
        {
            AbortMove(true);
        }
        AIFactoryMoveTo(SelectedRoute, true);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function NotifyReachedRoutePoint(Actor RoutePoint)
{
    // End:0x56
    if(LastRouteReachedPoint != RoutePoint)
    {
        // End:0x56
        if((SkyNavigationPoint(RoutePoint) != none) && SkyNavigationPoint(RoutePoint).bShouldInvestigateWhenPatrollingThisNode)
        {
            FireExternalEvent("InvestigateRoutePoint");
        }
    }
    LastRouteReachedPoint = RoutePoint;
    //return;    
}

function OnAIUseCover(SkySeqAct_AIUseCover Action)
{
    local CoverInfo ClaimThisCover;
    local Pawn CoverFocus;
    local SeqVar_Object ObjVar;

    // End:0x15C
    if(((Action.TargetCoverLink != none) && Action.TargetSlotIdx >= 0) && Action.TargetSlotIdx < Action.TargetCoverLink.Slots.Length)
    {
        ClaimThisCover.Link = Action.TargetCoverLink;
        ClaimThisCover.SlotIdx = Action.TargetSlotIdx;
        // End:0xAE
        if(!ClaimCover(ClaimThisCover))
        {
            return;
        }
        CoverFocus = none;
        // End:0x10E
        foreach Action.LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Engage Enemy")
        {
            CoverFocus = Pawn(ObjVar.GetObjectValue());
            // End:0x10D
            if(CoverFocus != none)
            {
                // End:0x10E
                break;
            }            
        }        
        // End:0x128
        if(CoverFocus != none)
        {
            CurrentEnemy = CoverFocus;            
        }
        else
        {
            CurrentEnemy = none;
        }
        // End:0x15C
        if(!IsInState('Behavior_ScriptedCover', true))
        {
            KismetCoverAction = Action;
            GotoState('Behavior_ScriptedCover');
            return;
        }
    }
    // End:0x182
    if(IsInState('Behavior_ScriptedCover', true))
    {
        GotoState('Behavior_ScriptedCover', 'BailOnCover');
    }
    //return;    
}

function OnAIStartFireAt(SkySeqAct_AIStartFireAt FireAction)
{
    local SeqVar_Object ObjVar;
    local Actor NewTarget;

    // End:0x54
    foreach FireAction.LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Fire At")
    {
        NewTarget = Actor(ObjVar.GetObjectValue());
        // End:0x53
        if(NewTarget != none)
        {
            // End:0x54
            break;
        }        
    }    
    // End:0xA3
    if(NewTarget != none)
    {
        // End:0x92
        if(NewTarget.IsA('Controller'))
        {
            NewTarget = Controller(NewTarget).Pawn;
        }
        UnlockFocus();
        LockFocusOn(NewTarget);
    }
    // End:0xDF
    if((int(FireAction.ForcedFireMode) == int(1)) || int(FireAction.ForcedFireMode) == int(3))
    {
        StartTargeting();
    }
    // End:0x124
    if((int(FireAction.ForcedFireMode) == int(0)) || int(FireAction.ForcedFireMode) == int(1))
    {
        FireWeaponAt(NewTarget);
    }
    //return;    
}

function OnAIStopFire(SkySeqAct_AIStopFire FireAction)
{
    StopTargeting();
    UnlockFocus();
    StopAllFiring();
    //return;    
}

// Export USkyBot::execSetMovementSpeedControls(FFrame&, void* const)
native final function SetMovementSpeedControls(bool bUseInterpolatedSpeed, optional float MinSpeed, optional float MaxSpeed, optional float MinDist, optional float MaxDist);

// Export USkyBot::execCannotInterruptMove(FFrame&, void* const)
native final function bool CannotInterruptMove();

final event SetMoveGoal(Actor NewMoveGoal, optional Actor NewMoveFocus, optional float OffsetDist, optional bool bSkipPathfinding, optional bool bAllowPartialPaths)
{
    local SkyGame GameInfo;

    GameInfo = SkyGame(WorldInfo.Game);
    // End:0x29
    if(CannotInterruptMove())
    {
        return;
    }
    // End:0x34
    if(IsDoingCoverManeuver())
    {
        return;
    }
    // End:0x43
    if(IsPlayingReaction())
    {
        CancelReaction();
    }
    // End:0x52
    if(IsScriptedMoving())
    {
        AbortScriptedMove();
    }
    // End:0x62
    if(IsMovingToGoal())
    {
        AbortMove(true);
    }
    // End:0x8C
    if(Controller(NewMoveGoal) != none)
    {
        NewMoveGoal = Controller(NewMoveGoal).Pawn;
    }
    MoveGoal = NewMoveGoal;
    MovePoint = vect(0.0000000, 0.0000000, 0.0000000);
    MoveFocus = NewMoveFocus;
    // End:0xF9
    if(OffsetDist > 0.0000000)
    {
        MoveOffset = float(Max(int(OffsetDist), int(float(2) * Pawn.CylinderComponent.CollisionRadius)));        
    }
    else
    {
        MoveOffset = 0.0000000;
    }
    bSkipPathing = bSkipPathfinding;
    bPartialPathing = bAllowPartialPaths;
    // End:0x13C
    if(bPartialPathing)
    {
        Pawn.PathSearchType = 2;        
    }
    else
    {
        Pawn.PathSearchType = Pawn(Pawn.ObjectArchetype).PathSearchType;
    }
    bReachedMoveGoal = false;
    bMovingToPoint = false;
    // End:0x1BA
    if(NewMoveGoal != none)
    {
        // End:0x1B3
        if(GameInfo.CanBotMove(self))
        {
            NumMoveRequestsIgnored = 0;
            PushState('Behavior_MoveToGoal');            
        }
        else
        {
            NumMoveRequestsIgnored++;
        }
    }
    //return;    
}

final event SetMovePoint(Vector NewMovePoint, optional Actor NewMoveFocus, optional float OffsetDist, optional bool bSkipPathfinding, optional bool bAllowPartialPaths)
{
    local SkyGame GameInfo;

    GameInfo = SkyGame(WorldInfo.Game);
    // End:0x29
    if(CannotInterruptMove())
    {
        return;
    }
    // End:0x4D
    if((Pawn != none) && Pawn.MovingLevel != none)
    {
        return;
    }
    // End:0x58
    if(IsDoingCoverManeuver())
    {
        return;
    }
    // End:0x67
    if(IsPlayingReaction())
    {
        CancelReaction();
    }
    // End:0x76
    if(IsScriptedMoving())
    {
        AbortScriptedMove();
    }
    // End:0x86
    if(IsMovingToGoal())
    {
        AbortMove(true);
    }
    MoveGoal = none;
    MovePoint = NewMovePoint;
    MoveFocus = NewMoveFocus;
    // End:0xE7
    if(OffsetDist > 0.0000000)
    {
        MoveOffset = float(Max(int(OffsetDist), int(float(2) * Pawn.CylinderComponent.CollisionRadius)));        
    }
    else
    {
        MoveOffset = 0.0000000;
    }
    bSkipPathing = bSkipPathfinding;
    bPartialPathing = bAllowPartialPaths;
    // End:0x12A
    if(bPartialPathing)
    {
        Pawn.PathSearchType = 2;        
    }
    else
    {
        Pawn.PathSearchType = Pawn(Pawn.ObjectArchetype).PathSearchType;
    }
    bReachedMoveGoal = false;
    bMovingToPoint = true;
    // End:0x196
    if(GameInfo.CanBotMove(self))
    {
        NumMoveRequestsIgnored = 0;
        PushState('Behavior_MoveToGoal');        
    }
    else
    {
        NumMoveRequestsIgnored++;
    }
    //return;    
}

// Export USkyBot::execGetMoveFocus(FFrame&, void* const)
native final function Actor GetMoveFocus();

// Export USkyBot::execIsMovingToGoal(FFrame&, void* const)
native final function bool IsMovingToGoal();

// Export USkyBot::execHasReachedGoal(FFrame&, void* const)
native final function bool HasReachedGoal();

// Export USkyBot::execGetLastMoveCompletedTime(FFrame&, void* const)
native final function float GetLastMoveCompletedTime();

final event AbortMove(optional bool bPreparingToStartANewMove)
{
    // End:0x0C
    if(CannotInterruptMove())
    {
        return;
    }
    // End:0x34
    if(GetStateName() == 'Behavior_MoveToGoal')
    {
        bPreparingNewMove = bPreparingToStartANewMove;
        PopState();        
    }
    else
    {
        // End:0x86
        if(!bPreparingToStartANewMove && Pawn != none)
        {
            Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
            Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        }
    }
    //return;    
}

// Export USkyBot::execLookAt(FFrame&, void* const)
native final function LookAt(Vector LookAtLoc);

// Export USkyBot::execLockFocusOn(FFrame&, void* const)
native final function bool LockFocusOn(Actor NewFocus);

// Export USkyBot::execUnlockFocus(FFrame&, void* const)
native final function bool UnlockFocus();

// Export USkyBot::execIsFocusLocked(FFrame&, void* const)
native final function bool IsFocusLocked();

// Export USkyBot::execDrawPrimaryWeapon(FFrame&, void* const)
native final function DrawPrimaryWeapon(optional bool bImmediately);

// Export USkyBot::execHolsterPrimaryWeapon(FFrame&, void* const)
native final function HolsterPrimaryWeapon(optional bool bImmediately);

final event StartTargeting()
{
    local Vector ForceAimOverride;

    // End:0xC3
    if((SkyPawnCoverUser(Pawn) != none) && SkyPawnCoverUser(Pawn).IsInCover())
    {
        // End:0xA6
        if(SkyPawnCoverUser(Pawn).CanTargetFromCover())
        {
            // End:0x89
            if(!bWantsToTarget)
            {
                ForceAimOverride = Normal(GetFocalPoint() - Pawn.Location);
                DesiredRotation = Rotator(ForceAimOverride);
                SetRotation(DesiredRotation);
            }
            SkyPawn(Pawn).SetTargeting(true);            
        }
        else
        {
            SkyPawn(Pawn).SetTargeting(false);
        }        
    }
    else
    {
        SkyPawn(Pawn).SetTargeting(true);
    }
    bWantsToTarget = true;
    //return;    
}

final event StopTargeting()
{
    // End:0x34
    if((SkyPawnCoverUser(Pawn) != none) && SkyPawnCoverUser(Pawn).IsInCover())
    {
        StopAllFiring();
    }
    SkyPawn(Pawn).SetTargeting(false);
    bWantsToTarget = false;
    //return;    
}

// Export USkyBot::execIsTargeting(FFrame&, void* const)
native final function bool IsTargeting();

// Export USkyBot::execPlayCustomAnimDatum(FFrame&, void* const)
native final function bool PlayCustomAnimDatum(out InteractionAnimInfo AnimDatum, optional bool bOverride);

// Export USkyBot::execStopCustomAnim(FFrame&, void* const)
native final function StopCustomAnim(optional float BlendOutTime);

// Export USkyBot::execIsPlayingCustomAnim(FFrame&, void* const)
native final function bool IsPlayingCustomAnim();

final event bool PlayReaction(SkyBot.ReactionType ReactionFor)
{
    // End:0x12
    if(int(ReactionFor) == int(0))
    {
        return false;
    }
    // End:0x1D
    if(IsDoingCoverManeuver())
    {
        return false;
    }
    // End:0x49
    if((SkyPawnBase(Pawn) != none) && SkyPawnBase(Pawn).bFeigningDeath)
    {
        return false;
    }
    // End:0x54
    if(IsPlayingReaction())
    {
        return false;
    }
    // End:0x64
    if(IsMovingToGoal())
    {
        AbortMove();
    }
    // End:0x73
    if(IsScriptedMoving())
    {
        AbortScriptedMove();
    }
    // End:0x8D
    if(IsFiring() || IsBurstFiring())
    {
        StopAllFiring();
    }
    bUseSpecifiedReaction = false;
    ReactionSetIdx = 0;
    J0x9C:

    // End:0x10C [Loop If]
    if(ReactionSetIdx < ReactionSets.Length)
    {
        // End:0x102
        if(int(ReactionSets[ReactionSetIdx].ReactionType) == int(ReactionFor))
        {
            // End:0xF0
            if(ReactionSets[ReactionSetIdx].ThePossibleAnims.Length == 0)
            {
                // [Explicit Continue]
                goto J0x102;
            }
            PushState('Behavior_PlayReaction');
            return true;
        }
        J0x102:

        ++ReactionSetIdx;
        // [Loop Continue]
        goto J0x9C;
    }
    return false;
    //return ReturnValue;    
}

final event bool PlayFixedReaction(ReactionAnimDatum RAD)
{
    // End:0x0B
    if(IsDoingCoverManeuver())
    {
        return false;
    }
    // End:0x37
    if((SkyPawnBase(Pawn) != none) && SkyPawnBase(Pawn).bFeigningDeath)
    {
        return false;
    }
    // End:0x42
    if(IsPlayingReaction())
    {
        return false;
    }
    // End:0x52
    if(IsMovingToGoal())
    {
        AbortMove();
    }
    // End:0x61
    if(IsScriptedMoving())
    {
        AbortScriptedMove();
    }
    bUseSpecifiedReaction = true;
    SpecifiedRAD = RAD;
    PushState('Behavior_PlayReaction');
    return true;
    //return ReturnValue;    
}

final event bool CancelReaction()
{
    // End:0x12
    if(bIsPlayingReaction)
    {
        PopState();
        return true;
    }
    return false;
    //return ReturnValue;    
}

// Export USkyBot::execIsPlayingReaction(FFrame&, void* const)
native final function bool IsPlayingReaction();

// Export USkyBot::execAttemptTaunt(FFrame&, void* const)
native final function bool AttemptTaunt(SkyBot.TauntAudioType TauntType);

final event bool PlaySpecialMove(name newSpecialMove, name newInteractorSpecialMove, name newVehicleSpecialMove)
{
    // End:0x0B
    if(IsDoingCoverManeuver())
    {
        return false;
    }
    // End:0x7B
    if((((int(Pawn.Physics) != int(1)) && int(Pawn.Physics) != int(8)) && int(Pawn.Physics) != int(4)) && int(Pawn.Physics) != int(0))
    {
        return false;
    }
    // End:0xA7
    if((SkyPawnBase(Pawn) != none) && SkyPawnBase(Pawn).bFeigningDeath)
    {
        return false;
    }
    // End:0xB6
    if(IsPlayingReaction())
    {
        CancelReaction();
    }
    // End:0xC1
    if(IsPlayingSpecialMove())
    {
        return false;
    }
    // End:0xD1
    if(IsMovingToGoal())
    {
        AbortMove();
    }
    // End:0xE0
    if(IsScriptedMoving())
    {
        AbortScriptedMove();
    }
    SpecialMove = newSpecialMove;
    InteractorSpecialMove = newInteractorSpecialMove;
    VehicleSpecialMove = newVehicleSpecialMove;
    PushState('Behavior_PlaySpecialMove');
    return true;
    //return ReturnValue;    
}

final event bool CancelSpecialMove()
{
    // End:0x12
    if(bIsPlayingSpecialMove)
    {
        PopState();
        return true;
    }
    return false;
    //return ReturnValue;    
}

// Export USkyBot::execIsPlayingSpecialMove(FFrame&, void* const)
native final function bool IsPlayingSpecialMove();

protected final function DebugLogRoute()
{
    //return;    
}

protected final function DrawDebugLogRoute()
{
    //return;    
}

protected final function float GetRouteCacheDistance()
{
    local float Distance;
    local int Idx;
    local Actor LastAnchor;

    LastAnchor = Pawn;
    Idx = 0;
    J0x12:

    // End:0x7D [Loop If]
    if(Idx < RouteCache.Length)
    {
        // End:0x73
        if(RouteCache[Idx] != none)
        {
            Distance += VSize(LastAnchor.Location - RouteCache[Idx].Location);
            LastAnchor = RouteCache[Idx];
        }
        Idx++;
        // [Loop Continue]
        goto J0x12;
    }
    return Distance;
    //return ReturnValue;    
}

function ReenableBumps()
{
    Enable('NotifyBump');
    //return;    
}

function ReenableHitWall()
{
    Enable('NotifyHitWall');
    //return;    
}

// Export USkyBot::execHasValidPath(FFrame&, void* const)
native final function bool HasValidPath(optional Actor TestTarget);

// Export USkyBot::execCannotProceedToNavpoint(FFrame&, void* const)
native final function bool CannotProceedToNavpoint(Actor NextWaypoint);

function OnAIFreeze(SkySeqAct_AIFreeze FreezeAction)
{
    // End:0x72
    if(FreezeAction.InputLinks[0].bHasImpulse)
    {
        bAllowFrozenFacingUpdate = FreezeAction.bAllowFacingUpdates;
        Freeze(true, FreezeAction.bAllowWeaponFiring);
        Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);        
    }
    else
    {
        FreezeAction.ScriptLog(string(self) @ "received unfreeze request while not frozen.");
        Freeze(false);
    }
    //return;    
}

// Export USkyBot::execIsFrozen(FFrame&, void* const)
native final function bool IsFrozen();

// Export USkyBot::execIsBrainFrozen(FFrame&, void* const)
native final function bool IsBrainFrozen();

event Freeze(bool bFreeze, optional bool bAllowFiring)
{
    // End:0x48
    if(bFreeze)
    {
        FrozenRefCount = 1;
        // End:0x35
        if(bAllowFiring)
        {
            PushState('Frozen', 'AllowFiring');            
        }
        else
        {
            PushState('Frozen');
        }        
    }
    else
    {
        FrozenRefCount = 0;
    }
    //return;    
}

function Actor FastFindPathTo(Vector aPoint, optional int MaxPathLength, optional bool bReturnPartial)
{
    local Actor ret;
    local bool WasJumpCapable, DisablingJumpCapable;

    // End:0xC3
    if((CurrentEnemy != none) && (((CurrentEnemy.Base == none) || SkyPawn(CurrentEnemy).IsGripping()) || CurrentEnemy.Base.IsA('SkyPawn_Archon')) || (SkyPawn(CurrentEnemy) != none) && SkyPawn(CurrentEnemy).IsInVerticalSpace())
    {
        DisablingJumpCapable = true;
        WasJumpCapable = Pawn.bJumpCapable;
        Pawn.bJumpCapable = false;
    }
    ret = FindPathTo(aPoint, MaxPathLength, bReturnPartial);
    // End:0xFC
    if(DisablingJumpCapable)
    {
        Pawn.bJumpCapable = WasJumpCapable;
    }
    return ret;
    //return ReturnValue;    
}

auto state Behavior_Base
{
    function RestoreMoveFlags()
    {
        // End:0x25
        if(SkyPawnCoverUser(Pawn) != none)
        {
            SkyPawnCoverUser(Pawn).ResetTempPathingFlags();
        }
        bEnteringCover = false;
        bExitingCover = false;
        bExitCoverWithDive = false;
        bExitCoverWithSlip = false;
        bExitCoverWithMantle = false;
        //return;        
    }

    function ContinuedState()
    {
        super(Object).ContinuedState();
        RestoreMoveFlags();
        //return;        
    }

    function BeginState(name PrevStateName)
    {
        super(Object).BeginState(PrevStateName);
        RestoreMoveFlags();
        //return;        
    }
Begin:

    // End:0x49
    if((BehaviorTreeTemplate != none) && BehaviorTree == none)
    {
        J0x18:

        // End:0x2E [Loop If]
        if(Pawn == none)
        {
            Sleep(0.2000000);
            // [Loop Continue]
            goto J0x18;
        }
        SetBehaviorTreeTemplate(BehaviorTreeTemplate);
        BehaviorTree.Startup();
    }
PostInit:


    Sleep(1.0000000);
    goto 'PostInit';
    stop;                    
}

state Behavior_ScriptedCover
{
    function BeginState(name PrevStateName)
    {
        super(Object).BeginState(PrevStateName);
        BrainFreeze(true);
        //return;        
    }

    function EndState(name NextStateName)
    {
        // End:0x10
        if(IsMovingToGoal())
        {
            AbortMove();
        }
        // End:0x1F
        if(IsInCover())
        {
            ExitCover();
        }
        UnClaimCover();
        BrainFreeze(false);
        super(Object).EndState(NextStateName);
        //return;        
    }
Begin:

    // End:0x16
    if(CurrentEnemy != none)
    {
        LockFocusOn(CurrentEnemy);
    }
MoveToCover:


    // End:0x38
    if(KismetCoverAction.bEnableShooting)
    {
        FireWeaponAt(CurrentEnemy);
    }
    SetMoveGoal(GetClaimedCoverMarker());
    // End:0x6E
    if(!HasReachedGoal())
    {
        ClearLatentAction(Class'SkySeqAct_AIUseCover', true);
        GotoState('Behavior_Base');
    }
    // End:0xA7
    if(!IsInCover())
    {
        TakeCover();
        // End:0xA7
        if(!IsInCover())
        {
            ClearLatentAction(Class'SkySeqAct_AIUseCover', true);
            GotoState('Behavior_Base');
        }
    }
    ClearLatentAction(Class'SkySeqAct_AIUseCover', false);
InCover:


    // End:0xCD
    if(CurrentEnemy != none)
    {
        LockFocusOn(CurrentEnemy);        
    }
    else
    {
        UnlockFocus();
    }
    // End:0x17B
    if(KismetCoverAction.bEnableShooting)
    {
        // End:0xF7
        if(!IsTargeting())
        {
            StartTargeting();
        }
        // End:0x149
        if(((CurrentEnemy != none) && CurrentEnemy.Health > 0) && !CurrentEnemy.bDeleteMe)
        {
            // End:0x146
            if(!IsBurstFiring())
            {
                StartBurstFiring(CurrentEnemy);
            }            
        }
        else
        {
            CurrentEnemy = BotMemory.GetBiggestThreatEnemy(false);
            // End:0x17B
            if(CurrentEnemy != (GetFireTarget()))
            {
                StopAllFiring();
            }
        }
    }
    Sleep(0.2500000);
    goto 'InCover';
BailOnCover:


    StopTargeting();
    StopAllFiring();
    ExitCover();
    ClearLatentAction(Class'SkySeqAct_AIUseCover', false);
    GotoState('Behavior_Base');
    stop;        
}

state Behavior_MoveToGoal
{
    final function StartingMove(bool bDirectMove)
    {
        // End:0x25
        if(SkyPawnCoverUser(Pawn) != none)
        {
            SkyPawnCoverUser(Pawn).ResetTempPathingFlags();
        }
        // End:0x38
        if(bDirectMove)
        {
            RouteCache_Empty();
        }
        //return;        
    }

    function PushedState()
    {
        local SkyGame GameInfo;

        GameInfo = SkyGame(WorldInfo.Game);
        GameInfo.TakeMoveTicket(self);
        super(Object).PushedState();
        bMovingToGoal = true;
        bReevaluatePath = !HasValidPath();
        //return;        
    }

    function bool ShouldWaitToMoveToward(Actor CurrentTarget)
    {
        local CoverSlotMarker CSM;

        CSM = CoverSlotMarker(CurrentTarget);
        // End:0x99
        if(CSM != none)
        {
            // End:0x99
            if((int(CSM.OwningSlot.Link.CoverOrientation) != int(0)) && !CSM.OwningSlot.Link.IsValidClaim(Pawn, CSM.OwningSlot.SlotIdx))
            {
                return true;
            }
        }
        return false;
        //return ReturnValue;        
    }

    function PoppedState()
    {
        local SkyPawn SP;
        local SkyGame GameInfo;

        GameInfo = SkyGame(WorldInfo.Game);
        GameInfo.ReturnMoveTicket(self);
        super(Object).PoppedState();
        ClearLatentAction(Class'Engine.SeqAct_AIMoveToActor', !bReachedMoveGoal);
        LastMoveCompleted = WorldInfo.TimeSeconds;
        // End:0x76
        if(bInitiatedSkyJumpPath)
        {
            bInitiatedSkyJumpPath = false;
            BrainFreeze(false);
        }
        // End:0xF3
        if((Pawn != none) && !bPreparingNewMove)
        {
            Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
            SP = SkyPawn(Pawn);
            // End:0xF3
            if((SP != none) && SP.IsRocketPacking())
            {
                SP.GotoRocketPackGlide();
            }
        }
        MoveTarget = none;
        MoveFocus = none;
        // End:0x1B0
        if((ClaimedCover.Link != SkyPawnCoverUser(Pawn).CurrentLink) || ClaimedCover.SlotIdx != SkyPawnCoverUser(Pawn).CurrentSlotIdx)
        {
            UnClaimCover();
            ClaimedCover.Link = SkyPawnCoverUser(Pawn).CurrentLink;
            ClaimedCover.SlotIdx = SkyPawnCoverUser(Pawn).CurrentSlotIdx;
            ClaimCover(ClaimedCover);
        }
        bMovingToGoal = false;
        //return;        
    }

    function ContinuedState()
    {
        local NavigationPoint BestAnchor;
        local float Dist;
        local bool bNeedsRepath;

        super(Object).ContinuedState();
        // End:0x184
        if((bReevaluatePath && Pawn != none) && MoveGoal != none)
        {
            // End:0x113
            if(!Pawn.ValidAnchor() && RouteCache.Length <= 0)
            {
                BestAnchor = Pawn.GetBestAnchor(Pawn, Pawn.Location, true, false, Dist);
                // End:0xEF
                if(BestAnchor == none)
                {
                    BestAnchor = Class'Engine.NavigationPoint'.static.GetNearestNavToActor(Pawn);
                    // End:0xEF
                    if((BestAnchor != none) && BestAnchor.IsUsableAnchorFor(Pawn))
                    {
                        Pawn.SetLocation(BestAnchor.Location);
                    }
                }
                // End:0x113
                if(BestAnchor != none)
                {
                    Pawn.SetAnchor(BestAnchor);
                }
            }
            // End:0x184
            if(MoveGoal != none)
            {
                bNeedsRepath = !HasValidPath();
                // End:0x141
                if(bNeedsRepath)
                {
                    RouteCache_Empty();
                }
                bReevaluatePath = false;
                // End:0x184
                if((!bSkipPathing && bNeedsRepath) && !ActorReachable(MoveGoal))
                {
                    FindPathToward(MoveGoal,,, bPartialPathing);
                    DebugLogRoute();
                }
            }
        }
        //return;        
    }

    function bool AdjustAround(Pawn Other)
    {
        local Vector VelDir, OtherDir, SideDir, HitLocation, HitNormal;

        local bool bIsInVertical;

        bIsInVertical = SkyPawn(Pawn).IsInVerticalSpace();
        // End:0x5B
        if(!InLatentExecution(503) || bIsInVertical)
        {
            // End:0x59
            if(bIsInVertical && SkyPawn_MaxValenti(Other) != none)
            {
                PopState();
            }
            return false;
        }
        VelDir = Normal(GetDestinationPosition() - Pawn.Location);
        VelDir.Z = 0.0000000;
        OtherDir = Other.Location - Pawn.Location;
        OtherDir.Z = 0.0000000;
        OtherDir = Normal(OtherDir);
        // End:0x1E8
        if((VelDir Dot OtherDir) > 0.3000000)
        {
            bAdjusting = true;
            SideDir.X = VelDir.Y;
            SideDir.Y = -1.0000000 * VelDir.X;
            // End:0x164
            if((SideDir Dot OtherDir) > 0.0000000)
            {
                SideDir *= float(-1);
            }
            SetAdjustLocation(Pawn.Location + ((3.0000000 * Other.GetCollisionRadius()) * ((0.5000000 * VelDir) + SideDir)), true);
            // End:0x1E6
            if(Trace(HitLocation, HitNormal, GetAdjustLocation(), Pawn.Location, false) != none)
            {
                SetAdjustLocation(HitLocation, true);
            }
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    event bool NotifyHitWall(Vector HitNormal, Actor Wall)
    {
        local Vector VelDir;

        // End:0x2C
        if(!InLatentExecution(503) || SkyPawn(Pawn).IsInVerticalSpace())
        {
            return false;
        }
        // End:0x122
        if(int(Pawn.Physics) == int(4))
        {
            Disable('NotifyHitWall');
            SetTimer(1.0000000, false, 'ReenableHitWall');
            VelDir = Normal(GetDestinationPosition() - Pawn.Location);
            // End:0xD7
            if((VelDir Dot HitNormal) <= -0.8000000)
            {
                SetAdjustLocation(Pawn.Location + ((-3.0000000 * Pawn.GetCollisionRadius()) * VelDir), true);                
            }
            else
            {
                SetAdjustLocation(Pawn.Location + ((-3.0000000 * Pawn.GetCollisionRadius()) * ((VelDir * 0.2500000) + HitNormal)), true);
            }
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    event bool NotifyBump(Actor Other, Vector HitNormal)
    {
        Disable('NotifyBump');
        SetTimer(1.0000000, false, 'ReenableBumps');
        // End:0x2F
        if(MoveTarget == Other)
        {
            return false;
        }
        // End:0x53
        if(Pawn(Other) != none)
        {
            AdjustAround(Pawn(Other));
        }
        return false;
        //return ReturnValue;        
    }

    event bool HandlePathObstruction(Actor BlockedBy)
    {
        local Pawn BlockPawn;

        BlockPawn = Pawn(BlockedBy);
        // End:0x63
        if(((BlockPawn != none) && BlockPawn != MoveGoal) && SkyVehicle(BlockPawn) == none)
        {
            // End:0x63
            if(BlockPawn.ReachedDestination(MoveGoal))
            {
                PopState();
                return true;
            }
        }
        return false;
        //return ReturnValue;        
    }

    protected final function bool CanSkipToNextNavPoint(Actor NextTarget)
    {
        local NavigationPoint NavPt;
        local ReachSpec NextSpec;
        local CoverSlotMarker CSM;

        CSM = CoverSlotMarker(NextTarget);
        // End:0x66
        if(CSM != none)
        {
            // End:0x4C
            if(int(CSM.OwningSlot.Link.CoverOrientation) != int(0))
            {
                return false;
            }
            // End:0x66
            if(SkyPawn(Pawn).IsInVerticalSpace())
            {
                return false;
            }
        }
        // End:0x7F
        if(bSkipPathing || RouteCache.Length <= 1)
        {
            return false;
        }
        // End:0xA9
        if((NextTarget == Pawn.Anchor) && ActorReachable(RouteCache[1]))
        {
            return true;
        }
        NavPt = NavigationPoint(NextTarget);
        // End:0x127
        if(NavPt != none)
        {
            NextSpec = NavPt.GetReachSpecTo(RouteCache[1]);
            // End:0x127
            if((NextSpec != none) && NextSpec.CheckIsOnPath(Pawn.Location, Pawn.GetCollisionRadius()))
            {
                return true;
            }
        }
        return false;
        //return ReturnValue;        
    }

    protected final function bool ReachedCoverSlotInteriorNode(NavigationPoint TestNode)
    {
        local SkyCoverSlotMarker CSM;

        CSM = SkyCoverSlotMarker(TestNode);
        // End:0x9C
        if((((CSM != none) && CSM.OwningSlot.SlotIdx > 0) && CSM.OwningSlot.SlotIdx < (CSM.OwningSlot.Link.Slots.Length - 1)) && IsCurrentlyUsedCover(CSM))
        {
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    protected final function bool GetNextMoveTarget(out Actor CurrentMoveTarget)
    {
        local bool bDone;
        local Actor OldMoveTarget;
        local int SanityCheck;

        OldMoveTarget = CurrentMoveTarget;
        SanityCheck = 0;
        J0x12:

        // End:0xFD [Loop If]
        if(((!bDone && RouteCache.Length > 0) && RouteCache[0] != none) && ++SanityCheck < 50)
        {
            // End:0xF7
            if(Pawn.ReachedDestination(RouteCache[0]) || ReachedCoverSlotInteriorNode(RouteCache[0]))
            {
                // End:0xAD
                if(bInitiatedSkyJumpPath)
                {
                    // End:0xAD
                    if(!RouteCache[0].bNotBased)
                    {
                        bInitiatedSkyJumpPath = false;
                        BrainFreeze(false);
                    }
                }
                // End:0xCD
                if(RouteCache[0] == MoveGoal)
                {
                    bDone = true;
                    CurrentMoveTarget = none;
                }
                Pawn.SetAnchor(RouteCache[0]);
                RouteCache_RemoveIndex(0);                
            }
            else
            {
                // [Explicit Break]
                goto J0xFD;
            }
            // [Loop Continue]
            goto J0x12;
        }
        J0xFD:

        // End:0x12B
        if(!bDone)
        {
            // End:0x124
            if(RouteCache.Length > 0)
            {
                CurrentMoveTarget = RouteCache[0];                
            }
            else
            {
                CurrentMoveTarget = none;
            }
        }
        // End:0x15B
        if(!bInitiatedSkyJumpPath && SkyJumpNode(CurrentMoveTarget) != none)
        {
            bInitiatedSkyJumpPath = true;
            BrainFreeze(true);
        }
        return OldMoveTarget != CurrentMoveTarget;
        //return ReturnValue;        
    }

    function bool IsCurrentlyUsedCover(CoverSlotMarker GoalMarker)
    {
        local SkyPawnCoverUser SPCU;

        SPCU = SkyPawnCoverUser(Pawn);
        // End:0x92
        if(SPCU != none)
        {
            // End:0x92
            if(((SPCU.CurrentLink != none) && SPCU.CurrentLink == GoalMarker.OwningSlot.Link) && SPCU.CurrentSlotIdx == GoalMarker.OwningSlot.SlotIdx)
            {
                return true;
            }
        }
        return false;
        //return ReturnValue;        
    }

    function bool IsAtMoveGoal()
    {
        local bool retval;

        // End:0x0E
        if(bReachedMoveGoal == true)
        {
            return true;
        }
        // End:0x36
        if(IsPathingCompletedForAreaOfOperation())
        {
            Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
            return true;
        }
        // End:0x108
        if(MoveGoal != none)
        {
            // End:0x86
            if(MoveOffset > 0.0000000)
            {
                retval = VSizeSq(MoveGoal.Location - Pawn.Location) <= Square(MoveOffset);
            }
            // End:0xBE
            if(!retval && CoverSlotMarker(MoveGoal) != none)
            {
                retval = IsCurrentlyUsedCover(CoverSlotMarker(MoveGoal));
            }
            // End:0xFE
            if(!retval)
            {
                retval = Pawn.ReachedDestination(MoveGoal) || ReachedCoverSlotInteriorNode(NavigationPoint(MoveGoal));
            }
            return retval;            
        }
        else
        {
            // End:0x17F
            if(bMovingToPoint)
            {
                // End:0x14C
                if(MoveOffset > 0.0000000)
                {
                    retval = VSizeSq(MovePoint - Pawn.Location) <= Square(MoveOffset);
                }
                // End:0x178
                if(!retval)
                {
                    retval = Pawn.ReachedPoint(MovePoint, none);
                }
                return retval;
            }
        }
        return false;
        //return ReturnValue;        
    }

    event MoveUnreachable(Vector AttemptedDest, Actor AttemptedTarget)
    {
        MovePoint = Pawn.Location;
        //return;        
    }
CheckMove:

    // End:0x0E
    if(MoveGoal != none)
    {        
    }
    // End:0x2D
    if(IsAtMoveGoal())
    {
        bReachedMoveGoal = true;
        goto 'ReachedGoal';
    }
Begin:


    // End:0x3B
    if(MoveGoal != none)
    {        
    }
    MoveTarget = none;
    bReachedMoveGoal = false;
    // End:0x17D
    if(MoveGoal != none)
    {
        // End:0x11A
        if(bSkipPathing || ActorReachable(MoveGoal))
        {
            StartingMove(true);
            NumRetriesMoveToward = 0;
            J0x79:

            // End:0x8D [Loop If]
            if(IsInCoverNotIdle())
            {
                Sleep(0.1000000);
                // [Loop Continue]
                goto J0x79;
            }
            MoveTarget = MoveGoal;
            // End:0xB8
            if(!IsPathingCompletedForAreaOfOperation())
            {
                MoveToward(MoveTarget, GetMoveFocus(), MoveOffset);
            }
            // End:0xE4
            if(!IsAtMoveGoal() && ++NumRetriesMoveToward > MaxRetriesMoveToward)
            {
                goto 'End';
            }
            // End:0x79
            if(!((IsAtMoveGoal()) || !bSkipPathing && !ActorReachable(MoveGoal)))
                goto J0x79;
            goto 'CheckMove';            
        }
        else
        {
            // End:0x158
            if((RouteCache.Length <= 0) || bReevaluatePath)
            {
                MoveTarget = FindPathToward(MoveGoal,,, bPartialPathing);
                bReevaluatePath = false;
                DebugLogRoute();                
            }
            else
            {
                DebugLogRoute();
                MoveTarget = ((RouteCache.Length > 0) ? RouteCache[0] : none);
            }
        }        
    }
    else
    {
        // End:0x2A0
        if(bMovingToPoint)
        {
            // End:0x23A
            if(bSkipPathing || PointReachable(MovePoint))
            {
                StartingMove(true);
                NumRetriesMoveToward = 0;
                J0x1AA:

                // End:0x1BE [Loop If]
                if(IsInCoverNotIdle())
                {
                    Sleep(0.1000000);
                    // [Loop Continue]
                    goto J0x1AA;
                }
                // End:0x1D8
                if(!IsPathingCompletedForAreaOfOperation())
                {
                    MoveTo(MovePoint, GetMoveFocus());
                }
                // End:0x204
                if(!IsAtMoveGoal() && ++NumRetriesMoveToward > MaxRetriesMoveToward)
                {
                    goto 'End';
                }
                // End:0x1AA
                if(!((IsAtMoveGoal()) || !bSkipPathing && !PointReachable(MovePoint)))
                    goto J0x1AA;
                goto 'CheckMove';                
            }
            else
            {
                // End:0x27E
                if((RouteCache.Length <= 0) || bReevaluatePath)
                {
                    MoveTarget = FastFindPathTo(MovePoint,, bPartialPathing);
                    bReevaluatePath = false;
                    DebugLogRoute();                    
                }
                else
                {
                    DebugLogRoute();
                    MoveTarget = ((RouteCache.Length > 0) ? RouteCache[0] : none);
                }
            }
        }
    }
    // End:0x495
    if(MoveTarget != none)
    {
        // End:0x2B9
        if(MoveGoal != none)
        {            
        }
        else
        {
            // End:0x2C2
            if(bMovingToPoint)
            {
            }
        }
        GetNextMoveTarget(MoveTarget);
        // End:0x2FF
        if((MoveTarget != none) && CanSkipToNextNavPoint(MoveTarget))
        {
            RouteCache_RemoveIndex(0);
            GetNextMoveTarget(MoveTarget);
        }
        // End:0x31D
        if(MoveTarget == none)
        {
            bReevaluatePath = true;
            Sleep(0.2500000);            
        }
        else
        {
            StartingMove(false);
            NumRetriesMoveToward = 0;
            J0x32B:

            // End:0x492 [Loop If]
            if(!IsAtMoveGoal() && MoveTarget != none)
            {
                // End:0x3D8
                if((ShouldWaitToMoveToward(MoveTarget)) || CannotProceedToNavpoint(MoveTarget))
                {
                    Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
                    Sleep(0.2500000);
                    // End:0x3D5
                    if(TimeoutWaitingForCoverToBeUnoccupied >= 0.0000000)
                    {
                        MovementTimeout += 0.2500000;
                        // End:0x3D5
                        if(MovementTimeout >= TimeoutWaitingForCoverToBeUnoccupied)
                        {
                            MovementTimeout = 0.0000000;
                            bReevaluatePath = true;
                            goto 'Begin';
                        }
                    }                    
                }
                else
                {
                    MovementTimeout = 0.0000000;
                    J0x3E3:

                    // End:0x3F7 [Loop If]
                    if(IsInCoverNotIdle())
                    {
                        Sleep(0.1000000);
                        // [Loop Continue]
                        goto J0x3E3;
                    }
                    // End:0x42D
                    if(!IsPathingCompletedForAreaOfOperation())
                    {
                        MoveToward(MoveTarget, GetMoveFocus(), ((MoveTarget == MoveGoal) ? MoveOffset : 0.0000000));
                    }
                    // End:0x453
                    if(IsAtMoveGoal())
                    {
                        bReachedMoveGoal = true;
                        MoveTarget = none;
                        goto 'ReachedGoal';
                    }
                    // End:0x48F
                    if(!GetNextMoveTarget(MoveTarget))
                    {
                        DebugLogRoute();
                        // End:0x48C
                        if(++NumRetriesMoveToward > MaxRetriesMoveToward)
                        {
                            bReevaluatePath = true;
                            goto 'Begin';
                        }                        
                    }
                }
                // [Loop Continue]
                goto J0x32B;
            }
        }        
    }
    else
    {
        // End:0x4CD
        if(!IsAtMoveGoal())
        {
            // End:0x4B2
            if(MoveGoal != none)
            {                
            }
            else
            {
                // End:0x4BB
                if(bMovingToPoint)
                {
                }
            }
            Sleep(0.2500000);
            goto 'End';
        }
    }
    Sleep(0.0100000);
    goto 'CheckMove';
ReachedGoal:


    // End:0x4ED
    if(MoveGoal != none)
    {        
    }
    bReachedMoveGoal = true;
End:


    RouteCache_Empty();
    PopState();
    stop;        
}

state Behavior_EnterCover
{
    function bool FireWeaponAt(Actor inActor)
    {
        return false;
        //return ReturnValue;        
    }

    function bool CanAttack(Actor Other)
    {
        return false;
        //return ReturnValue;        
    }

    simulated event NotifyEnterCoverFinished()
    {
        // End:0xAF
        if((ClaimedCover.Link != SkyPawnCoverUser(Pawn).CurrentLink) || ClaimedCover.SlotIdx != SkyPawnCoverUser(Pawn).CurrentSlotIdx)
        {
            UnClaimCover();
            ClaimedCover.Link = SkyPawnCoverUser(Pawn).CurrentLink;
            ClaimedCover.SlotIdx = SkyPawnCoverUser(Pawn).CurrentSlotIdx;
            ClaimCover(ClaimedCover);
        }
        PopState();
        //return;        
    }

    function PushedState()
    {
        super(Object).PushedState();
        bEnteringCover = true;
        //return;        
    }

    function PoppedState()
    {
        super(Object).PoppedState();
        bEnteringCover = false;
        //return;        
    }
    J0x00:
    // End:0x36 [Loop If]
    if(SkyPawn(Pawn).IgnoreInputForTransition() || IsMoveInputLocked())
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x00;
    }
    // End:0x93
    if(!IsInCover() && CoverToEnter != none)
    {
        SkyPawnCoverUser(Pawn).PerformAcquireCover(SkyPawnCoverUser(Pawn).CoverInfoToCovPosInfo(CoverToEnter.OwningSlot));        
    }
    else
    {
        NotifyEnterCoverFinished();
    }
    Sleep(5.0000000);
    NotifyEnterCoverFinished();
    stop;                    
}

state Behavior_ExitCover
{
    function bool FireWeaponAt(Actor inActor)
    {
        return false;
        //return ReturnValue;        
    }

    function bool CanAttack(Actor Other)
    {
        return false;
        //return ReturnValue;        
    }

    simulated event NotifyExitCoverFinished()
    {
        ClaimedCover.Link = none;
        ClaimedCover.SlotIdx = -1;
        PopState();
        //return;        
    }

    function PushedState()
    {
        super(Object).PushedState();
        // End:0x18
        if(!IsInCover())
        {
            PopState();
        }
        Pawn.SetAnchor(GetClaimedCoverMarker());
        bExitingCover = true;
        //return;        
    }

    function PoppedState()
    {
        super(Object).PoppedState();
        bExitingCover = false;
        bExitCoverWithDive = false;
        bExitCoverWithSlip = false;
        bExitCoverWithMantle = false;
        bForceDesiredRotation = false;
        //return;        
    }
    J0x00:
    // End:0x36 [Loop If]
    if(SkyPawn(Pawn).IgnoreInputForTransition() || IsMoveInputLocked())
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x00;
    }
    SkyPawnCoverUser(Pawn).PerformReleaseCover();
    Sleep(5.0000000);
PlanB:


    // End:0x79
    if(IsInCover())
    {
        SkyPawnCoverUser(Pawn).ExitCover();
    }
    NotifyExitCoverFinished();
    stop;                    
}

state Behavior_SwatTurn
{
    function bool FireWeaponAt(Actor inActor)
    {
        return false;
        //return ReturnValue;        
    }

    function bool CanAttack(Actor Other)
    {
        return false;
        //return ReturnValue;        
    }

    function PushedState()
    {
        local CoverReference STRef;

        super(Object).PushedState();
        // End:0x18
        if(!IsInCover())
        {
            PopState();
        }
        // End:0x3F
        if(!SkyPawnCoverUser(Pawn).CanSwatTurn(STRef, true))
        {
            PopState();
        }
        SkyPawnCoverUser(Pawn).PerformSwatTurn(STRef);
        bSwatTurning = true;
        //return;        
    }

    function PoppedState()
    {
        super(Object).PoppedState();
        bSwatTurning = false;
        //return;        
    }
    J0x00:
    // End:0x36 [Loop If]
    if(SkyPawn(Pawn).IgnoreInputForTransition() || IsMoveInputLocked())
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x00;
    }
    J0x36:

    // End:0x83 [Loop If]
    if(SkyPawnCoverUser(Pawn).IsSwatTurning() || int(SkyPawnCoverUser(Pawn).GetCoverState()) == int(24))
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x36;
    }
    ClaimedCover.Link = SkyPawnCoverUser(Pawn).CurrentLink;
    ClaimedCover.SlotIdx = SkyPawnCoverUser(Pawn).CurrentSlotIdx;
    PopState();
    stop;                
}

state Behavior_PlayReaction
{
    function PushedState()
    {
        local ReactionAnimDatum RAD;
        local bool bFoundValidAnim;

        super(Object).PushedState();
        bFoundValidAnim = true;
        // End:0x25
        if(bUseSpecifiedReaction)
        {
            RAD = SpecifiedRAD;            
        }
        else
        {
            ReactionAnimIdx = Rand(ReactionSets[ReactionSetIdx].ThePossibleAnims.Length);
            // End:0x11B
            if(!SkyPawn(Pawn).VerifyCanPerform(ReactionSets[ReactionSetIdx].ThePossibleAnims[ReactionAnimIdx]))
            {
                bFoundValidAnim = false;
                // End:0x11B
                if(ReactionSets[ReactionSetIdx].ThePossibleAnims.Length > 1)
                {
                    // End:0xB1
                    if(ReactionAnimIdx != 0)
                    {
                        ReactionAnimIdx = 0;
                    }
                    J0xB1:

                    // End:0x11B [Loop If]
                    if(ReactionAnimIdx < ReactionSets[ReactionSetIdx].ThePossibleAnims.Length)
                    {
                        // End:0x111
                        if(SkyPawn(Pawn).VerifyCanPerform(ReactionSets[ReactionSetIdx].ThePossibleAnims[ReactionAnimIdx]))
                        {
                            bFoundValidAnim = true;
                            // [Explicit Break]
                            goto J0x11B;
                        }
                        ++ReactionAnimIdx;
                        // [Loop Continue]
                        goto J0xB1;
                    }
                }
            }
            J0x11B:

            // End:0x146
            if(bFoundValidAnim)
            {
                RAD = ReactionSets[ReactionSetIdx].ThePossibleAnims[ReactionAnimIdx];
            }
        }
        // End:0x179
        if(bFoundValidAnim)
        {
            // End:0x176
            if(PlayCustomAnimDatum(RAD.AnimDatum))
            {
                bIsPlayingReaction = true;
                return;                
            }            
        }
        PopState();
        //return;        
    }

    function PoppedState()
    {
        // End:0x14
        if(IsPlayingCustomAnim())
        {
            StopCustomAnim(0.0000000);
        }
        bIsPlayingReaction = false;
        super(Object).PoppedState();
        //return;        
    }
    J0x00:
    // End:0x14 [Loop If]
    if(IsPlayingCustomAnim())
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x00;
    }
    PopState();
    stop;                    
}

state Behavior_PlaySpecialMove
{
    function PushedState()
    {
        local int I;

        super(Object).PushedState();
        bIsPlayingSpecialMove = true;
        Pawn.SetCurrentActiveSpecialManeuver(SpecialMove);
        // End:0xA5
        if(SkyPawn_Boss(Pawn) != none)
        {
            I = 0;
            J0x3E:

            // End:0xA5 [Loop If]
            if(I < SkyPawn_Boss(Pawn).ActorsGrippingMe.Length)
            {
                Pawn(SkyPawn_Boss(Pawn).ActorsGrippingMe[I].Gripper).SetCurrentActiveSpecialManeuver(InteractorSpecialMove);
                ++I;
                // [Loop Continue]
                goto J0x3E;
            }
        }
        SkyPawn(Pawn).DrivenVehicle.SetCurrentActiveSpecialManeuver(VehicleSpecialMove);
        //return;        
    }

    function PoppedState()
    {
        // End:0x26
        if(IsPlayingSpecialMove())
        {
            Pawn.SetCurrentActiveSpecialManeuver('None');
        }
        bIsPlayingSpecialMove = false;
        super(Object).PoppedState();
        //return;        
    }
    J0x00:
    // End:0x14 [Loop If]
    if(IsPlayingSpecialMove())
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x00;
    }
    PopState();
    stop;                    
}

state Frozen
{
    event Freeze(bool bFreeze, optional bool bAllowFiring)
    {
        // End:0x14
        if(bFreeze)
        {
            ++FrozenRefCount;            
        }
        else
        {
            --FrozenRefCount;
            // End:0x34
            if(FrozenRefCount <= 0)
            {
                FrozenRefCount = 0;
                PopState();
            }
        }
        //return;        
    }

    function OnAIFreeze(SkySeqAct_AIFreeze FreezeAction)
    {
        // End:0x2F
        if(FreezeAction.InputLinks[1].bHasImpulse)
        {
            Freeze(false);            
        }
        else
        {
            FreezeAction.ScriptLog(string(self) @ "received a freeze request while already frozen.");
            Freeze(true);
        }
        //return;        
    }

    function PushedState()
    {
        super(Object).PushedState();
        BrainFreeze(true);
        // End:0x23
        if(FrozenRefCount == 0)
        {
            FrozenRefCount = 1;
        }
        //return;        
    }

    function PoppedState()
    {
        BrainFreeze(false);
        // End:0x33
        if(bFrozenWasBurstFiring && !IsBurstFiring())
        {
            bFrozenWasBurstFiring = false;
            BurstFireReady();
        }
        bAllowFrozenFacingUpdate = false;
        super(Object).PoppedState();
        //return;        
    }
Begin:

    bFrozenWasBurstFiring = IsBurstFiring();
    StopAllFiring();
    goto 'BusyWait';
AllowFiring:


    goto 'BusyWait';
BusyWait:


    Sleep(0.2500000);
    goto 'BusyWait';
InputLocked:


    // End:0x76
    if(SkyPawn(Pawn).IgnoreInputForTransition() || IsMoveInputLocked())
    {
        Sleep(0.1000000);
        goto 'InputLocked';
    }
    --FrozenRefCount;
    // End:0x92
    if(FrozenRefCount > 0)
    {
        goto 'Begin';
    }
    PopState();
    stop;            
}
