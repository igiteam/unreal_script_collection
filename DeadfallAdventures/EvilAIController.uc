class EvilAIController extends GameAIController
    native(AI)
    config(AI)
    hidecategories(Navigation);

struct native AICharacterInfo
{
    var EvilPawn Pawn;
    var EvilAIController Controller;
    var Guid PawnGuid;
    var bool bIsPlayer;
    var float LastHearMeTime;
    var EvilTypes.ESoundSetType LastHearMeSoundSetType;
    var float LastUpdateTime;
    var float UpdateInterval;
    var Vector KnownLocation;
    var Vector LastKnownVelocity;
    var float DistanceToEnemy;
    var float Rating;
    var bool bUpdateRating;
    var float LastSeenTime;
    var bool bInitialized;
    var float RatingModifier;
    var float GivenDamageToMe;

    structdefaultproperties
    {
        Pawn=none
        Controller=none
        PawnGuid=(A=0,B=0,C=0,D=0)
        bIsPlayer=false
        LastHearMeTime=0.0000000
        LastHearMeSoundSetType=ESoundSetType.SST_Invalid
        LastUpdateTime=0.0000000
        UpdateInterval=0.3000000
        KnownLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        LastKnownVelocity=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        DistanceToEnemy=0.0000000
        Rating=0.0000000
        bUpdateRating=false
        LastSeenTime=0.0000000
        bInitialized=false
        RatingModifier=0.5000000
        GivenDamageToMe=0.0000000
    }
};

struct native SStimulus
{
    var EvilPawn EP;
    var EvilTypes.EPerceptionType Pt;
    var name EventName;

    structdefaultproperties
    {
        EP=none
        Pt=EPerceptionType.PT_Sight
        EventName="None"
    }
};

var Guid MyGuid;
var SeqAct_AIMoveToActor PendingCheckpointMoveAction;
var SeqAct_AIMoveToActor MoveAction;
var SeqAct_AIMoveToActor NewMoveAction;
var EvilPawn MyEvilPawn;
var Actor MoveGoal;
var Vector MovePosition;
var Actor MoveFocus;
var float MoveOffset;
var bool bDoingMeleeAttack;
var bool bFireWhileMoving;
var bool bMoveToGoalByNavMesh_TryToUnstuck;
var bool bMoveToGoalByNavMesh_TryAlternativeLocation;
var bool bShouldStopFiringWithLag;
var bool bShouldOverrideMovingByFiring;
var bool bUseDynamicSearchExtent;
var bool bCanTeleportToGoal;
var bool bNotifiesInRange;
var bool bAllowCombatTransitions;
var bool bIgnoreStepAside;
var bool bIsCachedFireLineObstacleFarAway;
var bool bIsCachedFireLineObstacleDestroyPack;
var bool bLastFireLineCheckToEnemyResult;
var bool bEnemyAttachedToFireLineObstacle;
var bool bFailedToThrow;
var bool bShouldThrowWeapon;
var bool bMoveAroundWhenIdle;
var bool bOldMoveAroundWhenIdle;
var bool bMoveFailed;
var bool bLongFallLastTime;
var bool bReachedCover;
var bool bNavmeshFailForceDirectMove;
var transient float BurstTimeLeft;
var Actor ShotTargetActor;
var float TargettedAimEpsilon;
var float ProjectileAimHeightModifier;
var float RestDelayAfterShoot;
var Vector PossessLocation;
var Rotator PossessRotation;
var class<EvilAICmd_Base_Combat> DefaultCommand;
var class<EvilAICmd_Base_Melee> MeleeCommand;
var class<EvilAICmd_Base_Guard> GuardCommand;
var class<EvilAICmd_Base_Burning> BurningCommand;
var class<EvilAICmd_RideRailCar> RideCommand;
var class<EvilAICmd_MoveToGoal> MoveCommand;
var class<EvilAICmd_Attack_Throw> ThrowCommand;
var class<EvilAICmd_Strafe> StrafeCommand;
var() array<EvilStrafeData> StrafesData;
var int LastStrafeIndex;
var int LastCheckedStrafeIndex;
var int NumOfCheckedStrafesInRating;
var float LastStrafeTime;
var float DelayBetweenOppositeStrafes;
var float StrafeRatingThreshold;
var Pawn LastBumpedPawn;
var float LastBumpTime;
var() config float ShouldTeleportDistance;
var() config float EnemyDistance_Shoot;
var() config float EnemyDistance_Throw;
var() config float EnemyDistance_Melee;
var() config float EnemyDistance_MeleeCharge;
var() config float EnemyDistance_Finisher;
var() config float EnemyDistance_MinimalStrafeDistance;
var() config float DodgeChance;
var() config float EnemyDistance_HearFootSteps;
var() config float BeginAttackDistance_Covered;
var() config float BeginAttackDistance_Low;
var() config float BeginAttackDistance_Normal;
var() config float BeginAttackDistance_High;
var float BeginAttackDistance;
var float NotifiesInRangeRadius;
var float GuardRadius;
var float SenseDistanceThreshold;
var() config float SightSenseDistanceThreshold;
var config float SightRadius;
var float CustomSightRadius;
var float CustomHearRadius;
var export editinline EvilAIReactManager ReactionManager;
var export editinline array<export editinline EvilAIReactCondition> DefaultReactConditions;
var array< class<EvilAIReactCondition> > DefaultReactConditionClasses;
var Pawn StepAsideGoal;
var const float MaxStepAsideDist;
var EvilPlayerController Master;
var float LastFireTime;
var float FireTime;
var float FireDelay;
var() config float MaxTimeBetweenFireBurst;
var() config float MinTimeBetweenFireBurst;
var() config float TimeBetweenFireBurst;
var() float DelayBetweenFireLineCheckToEnemy;
var float LastFireLineCheckToEnemyTime;
var Actor CachedFireLineObstacle;
var Vector CachedFireLineToEnemyExtent;
var int EnemyFireLineRequests;
var int EnemyFireLineCachedRequests;
var float LastMeleeCommandTime;
var() config float TimeBetweenMeleeCommands;
var() config float TimeBetweenThrows;
var float LastThrowGrenadeTime;
var() config float BurstFireTimeout;
var() config float BurstFireSpreadTime;
var() config float BurstFireLag;
var() config float RequestHelpEnemyDistance;
var array<AICharacterInfo> EnemyInfoList;
var AICharacterInfo LastActiveEnemyInfo;
var int LastActiveEnemyIndex;
var array<AICharacterInfo> FriendInfoList;
var EvilTypesNative.EBehaviorMode CurrentBehaviorMode;
var EvilTypesNative.EBehaviorMode LastBehaviorMode;
var() config EvilTypes.EAggressionLevel DefaultAggressionLevel;
var EvilTypes.EAggressionLevel CurrentAggressionLevel;
var EvilTypes.EAggressionLevel LastAggressionLevel;
var byte TeamIndex;
var() config float LongDistanceChargeTimeout;
var int ExtraPathCost;
var EvilNavPoint ActualNavPoint;
var EvilNavPoint PrevNavPoint;
var EvilNavPoint NextNavPoint;
var() config float MasterDistance_Follow;
var() config float MasterDistance_FollowRun;
var() config float TimeBetweenWalkAndRun;
var float LastWalkTimeToMaster;
var float LastRunTimeToMaster;
var array<EvilCombatZone> CombatZones;
var array<SStimulus> CachedStimulus;
var name DebugActualState;
var name DebugOldState;
var() float LifeSpanWithoutPawn;
//var delegate<RateStrafe> __RateStrafe__Delegate;
//var delegate<ShouldBroadcastDelegate> __ShouldBroadcastDelegate__Delegate;

delegate float RateStrafe(EvilStrafeData StrafeData, const out array<EvilStrafeData> StrafeDataArray)
{
    //return ReturnValue;    
}

delegate bool ShouldBroadcastDelegate(EvilAIController Receiver, Pawn P, EvilTypes.EPerceptionType Pt, optional name EventName, optional float RadiusSq)
{
    //return ReturnValue;    
}

event MoveUnreachable(Vector AttemptedDest, Actor AttemptedTarget)
{
    //return;    
}

event SetTeam(int inTeamIdx)
{
    TeamIndex = byte(inTeamIdx);
    EvilGame(WorldInfo.Game).ChangeTeam(self, inTeamIdx, false);
    BroadcastStimulus(MyEvilPawn, 3, GetFuncName(),, ShouldBroadcastChangeTeam);
    //return;    
}

event MayFall(bool bFloor, Vector FloorNormal)
{
    // End:0xC8
    if(bFloor)
    {
        // End:0x7D
        if(FloorNormal.Z < MyEvilPawn.WalkableFloorZ)
        {
            // End:0x7A
            if(bLongFallLastTime)
            {
                MyEvilPawn.bCanJump = false;
            }            
        }
        else
        {
            bLongFallLastTime = false;
            MyEvilPawn.bCanJump = MyEvilPawn.default.bCanJump;
        }
    }
    //return;    
}

event LongFall()
{
    bLongFallLastTime = true;
    //return;    
}

function EvilAICommand GetActiveEvilCommand()
{
    local EvilAICommand ActiveCommand;

    ActiveCommand = EvilAICommand(GetActiveCommand());
    return ActiveCommand;
    //return ReturnValue;    
}

function ReadyToFire(Actor EventInstigator, EvilAIReactChannel OrigChannel)
{
    local EvilAICommand ActiveCommand;

    ActiveCommand = GetActiveEvilCommand();
    // End:0x54
    if(ActiveCommand != none)
    {
        ActiveCommand.ReadyToFire(EventInstigator, OrigChannel);
    }
    //return;    
}

simulated function MoveToGuardArea(SeqAct_AIMoveToActor Action)
{
    OnAIMoveToActor(Action);
    //return;    
}

simulated function MoveToCoverArea(SeqAct_AIMoveToActor Action)
{
    OnAIMoveToActor(Action);
    //return;    
}

simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
    super(Controller).OnToggleHidden(Action);
    // End:0x5A
    if(Action.InputLinks[0].bHasImpulse)
    {
        DisableAI(false, true, true);        
    }
    else
    {
        // End:0x9E
        if(Action.InputLinks[1].bHasImpulse)
        {
            EnableAI();            
        }
        else
        {
            ((Pawn.bHidden) ? DisableAI(false, true, true) : EnableAI());
        }
    }
    //return;    
}

function OnAISetMaster(SeqAct_AISetMaster Action)
{
    // End:0x3D
    if(Action.bClearMaster)
    {
        self.Master = none;        
    }
    else
    {
        self.Master = Action.Master;
    }
    //return;    
}

function OnAIMoveToCover(SeqAct_AIMoveToCover Action)
{
    MoveToCoverArea(Action);
    //return;    
}

function OnAIAcquireEnemy(SeqAct_AIAcquireEnemy Action)
{
    local Actor EnemyActor;
    local EvilPawn EnemyPawn;
    local int EnemyIndex;

    // End:0x2C
    if(Action.bAutoAcquireEnemy)
    {
        AutoAcquireEnemy();
    }
    // End:0x1E4
    foreach Action.Enemies(EnemyActor)
    {
        // End:0x1E3
        if(EnemyActor != none)
        {
            EnemyPawn = ((EvilAIController(EnemyActor) != none) ? EvilAIController(EnemyActor).MyEvilPawn : EvilPawn(EnemyActor));
            // End:0x11F
            if(EnemyPawn == none)
            {
                EnemyPawn = ((EvilPlayerController(EnemyActor) != none) ? EvilPlayerController(EnemyActor).MyEvilPawn : none);
            }
            // End:0x172
            if((EnemyPawn != none) && Action.bForceAddEnemy)
            {
                ProcessStimulus(EnemyPawn, 3, GetFuncName(), true);
            }
            EnemyIndex = GetAIEnemyInfoIdx(EnemyPawn);
            // End:0x1E3
            if(EnemyIndex >= 0)
            {
                EnemyInfoList[EnemyIndex].RatingModifier = Action.EnemyRatingModifier;
            }
        }        
    }    
    ClearLatentAction(Class'SeqAct_AIAcquireEnemy', false);
    //return;    
}

function OnAIGuardArea(SeqAct_AIGuardArea Action)
{
    local EvilAIReactCond_StopGuarding StopGuardingCondition;

    MoveToGuardArea(Action);
    StopGuardingCondition = new (self) Class'EvilAIReactCond_StopGuarding';
    StopGuardingCondition.GuardAttackThreshold = Action.GuardAttackThreshold;
    StopGuardingCondition.__OutputFunction__Delegate = EndGuardCommandWrapper;
    StopGuardingCondition.Initialize();
    GuardRadius = Action.GuardAreaRadius;
    EnemyDistance_Shoot = EnemyDistance_Shoot + Action.DistanceAttackRangeBonus;
    //return;    
}

function OnAIMoveToActor(SeqAct_AIMoveToActor Action)
{
    local Actor destActor;
    local SeqVar_Object ObjVar;

    ClearLatentAction(Class'Engine.SeqAct_AIMoveToActor', true, Action);
    destActor = Action.PickDestination(Pawn);
    NewMoveAction = Action;
    // End:0x1D8
    if(destActor != none)
    {
        ScriptedRoute = Route(destActor);
        // End:0x100
        if(ScriptedRoute != none)
        {
            // End:0xC4
            if(ScriptedRoute.RouteList.Length == 0)
            {                
            }
            else
            {
                // End:0xFD
                if(!IsInState('ScriptedRouteMove'))
                {
                    BeginCombatCommand(Class'EvilAICmd_Base_ScriptedRouteMove', "ScriptedRouteMove", true);
                }
            }            
        }
        else
        {
            ScriptedMoveTarget = destActor;
            // End:0x147
            if(!IsInState('ScriptedMove'))
            {
                BeginCombatCommand(Class'EvilAICmd_Base_ScriptedMove', "ScriptedMove", true);
            }
        }
        ScriptedFocus = none;
        // End:0x1D4
        foreach Action.LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Look At")
        {
            ScriptedFocus = Actor(ObjVar.GetObjectValue());
            // End:0x1D3
            if(ScriptedFocus != none)
            {
                // End:0x1D4
                break;
            }            
        }                
    }
    else
    {
        MoveAction = none;
    }
    //return;    
}

function ClearMoveAction()
{
    // End:0x30
    if(Pawn != none)
    {
        Pawn.bIsWalking = false;
    }
    MoveAction = none;
    //return;    
}

function SetUnstuckSeartStart(bool bUseUnstuck, optional Vector UnstuckLocation)
{
    //return;    
}

function OnInvulnerabilityToggle(SeqAct_InvulnerabilityToggle Action)
{
    // End:0x6C
    if(Action.bForceDisable && !Action.bForceEnable)
    {
        MyEvilPawn.bIsInvulnerable = false;        
    }
    else
    {
        // End:0xD8
        if(Action.bForceEnable && !Action.bForceDisable)
        {
            MyEvilPawn.bIsInvulnerable = true;            
        }
        else
        {
            MyEvilPawn.bIsInvulnerable = !MyEvilPawn.bIsInvulnerable;
        }
    }
    //return;    
}

function OnSetCombatZone(SeqAct_SetCombatZone Act)
{
    local EvilCombatZone ecz;
    local int I;

    CombatZones.Remove(0, CombatZones.Length);    
    I = 0;
    J0x21:

    // End:0x105 [Loop If]
    if(I < Act.VariableLinks[1].LinkedVariables.Length)
    {
        ecz = EvilCombatZone(SeqVar_Object(Act.VariableLinks[1].LinkedVariables[I]).GetObjectValue());
        // End:0xF7
        if(ecz != none)
        {
            CombatZones.AddItem(ecz);            
        }
        I++;
        // [Loop Continue]
        goto J0x21;
    }
    ClearLatentAction(Class'SeqAct_SetCombatZone', !MyEvilPawn.IsAliveAndWell());
    //return;    
}

function OnAIExecuteNavActions(SeqAct_AIExecuteNavActions Act)
{
    local Actor Goal;

    Goal = Actor(SeqVar_Object(Act.VariableLinks[1].LinkedVariables[0]).GetObjectValue());
    ExecuteNavActions(Goal);
    //return;    
}

function OnAIAbortMoveToActor(SeqAct_AIAbortMoveToActor Act)
{
    local SeqAct_Latent Action;

    // End:0x71
    foreach LatentActions(Action)
    {
        // End:0x70
        if(ClassIsChildOf(Action.Class, Class'SeqAct_AIGuardArea'))
        {
            ReactionManager.NudgeChannel(self, 'StopGuarding');            
            return;
        }        
    }    
    AbortMoveCommand();
    ClearLatentAction(Class'Engine.SeqAct_AIMoveToActor', ScriptedRoute == none);
    //return;    
}

function OnAIStartFireAt(SeqAct_AIStartFireAt Act)
{
    local Actor Target;

    Target = Actor(SeqVar_Object(Act.VariableLinks[1].LinkedVariables[0]).GetObjectValue());
    // End:0x9F
    if(Target != none)
    {
        Class'EvilAICmd_Base_ScriptedShooting'.static.FireAtTarget(self, Target);
    }
    //return;    
}

function OnAIStopFire(SeqAct_AIStopFire Act)
{
    local EvilAICommand Cmd;

    Cmd = self.GetActiveEvilCommand();
    // End:0x65
    if(Cmd.IsA('EvilAICmd_Base_ScriptedShooting'))
    {
        self.AbortCommand(Cmd);
    }
    //return;    
}

function DisableAI(bool InAllowMove, optional bool InSupressReactionManager = false, optional bool InAbortCommandList = true)
{
    // End:0x2C
    if(bAllowCombatTransitions)
    {
        bOldMoveAroundWhenIdle = bMoveAroundWhenIdle;
    }
    // End:0x45
    if(InAllowMove)
    {
        bMoveAroundWhenIdle = false;
    }
    bAllowCombatTransitions = false;
    // End:0x72
    if(InAbortCommandList)
    {
        AbortCommand(CommandList);
    }
    // End:0x9E
    if(InSupressReactionManager)
    {
        ReactionManager.SuppressAll();
    }
    //return;    
}

function EnableAI()
{
    bMoveAroundWhenIdle = bOldMoveAroundWhenIdle;
    bAllowCombatTransitions = true;
    ReactionManager.UnSuppressAll();
    //return;    
}

function OnAIToggle(SeqAct_AIToggle Action)
{
    local bool bAIEnabled;

    bAIEnabled = bAllowCombatTransitions;
    // End:0x65
    if(Action.bForceDisable)
    {
        DisableAI(Action.bDontMove);        
    }
    else
    {
        // End:0x94
        if(Action.bForceEnable)
        {
            EnableAI();            
        }
        else
        {
            // End:0xCF
            if(bAIEnabled)
            {
                DisableAI(Action.bDontMove);                
            }
            else
            {
                EnableAI();
            }
        }
    }
    // End:0x11F
    if(Action.bForceEnableVO)
    {
        MyEvilPawn.bCanPlayVO = true;        
    }
    else
    {
        // End:0x162
        if(Action.bForceDisableVO)
        {
            MyEvilPawn.bCanPlayVO = false;
        }
    }
    //return;    
}

function ThrowGrenade(Rotator Rot, optional out Vector SuggestedTossVelocity, optional name InGrenadeSocket = 'None')
{
    local Vector Loc, ThrowLocationShift;
    local name GrenadeSocket;
    local Vector ThrowLocation;

    GrenadeSocket = ((InGrenadeSocket == 'None') ? MyEvilPawn.GrenadeSocket : InGrenadeSocket);
    MyEvilPawn.Mesh.GetSocketWorldLocationAndRotation(GrenadeSocket, Loc,, 0);
    ThrowLocation = GetThrowLocation();
    ThrowLocationShift.X = RandRange(-100.0000000, 100.0000000);
    ThrowLocationShift.Y = RandRange(-100.0000000, 100.0000000);
    ThrowLocation += (((Loc - ThrowLocation) * 0.3000000) + ThrowLocationShift);
    // End:0x224
    if(IsZero(SuggestedTossVelocity) && int(MyEvilPawn.PawnAction) != 2)
    {
        SuggestTossVelocity(SuggestedTossVelocity, ThrowLocation, Loc, MyEvilPawn.GrenadeTossZ + RandRange(-0.1000000 * MyEvilPawn.GrenadeTossZ, 0.1000000 * MyEvilPawn.GrenadeTossZ),, 0.4000000,,,, false);
    }
    MyEvilPawn.ThrowGrenade(Rot, Loc, SuggestedTossVelocity);
    //return;    
}

function Vector GetThrowLocation()
{
    local Vector ThrowLocation;

    // End:0x4E
    if(EvilAICmd_Attack_Throw(GetActiveCommand()) != none)
    {
        ThrowLocation = EvilAICmd_Attack_Throw(GetActiveCommand()).ThrowLocation;        
    }
    else
    {
        ThrowLocation = GetEnemyInfo().KnownLocation;
    }
    return ThrowLocation;
    //return ReturnValue;    
}

simulated function OnStartThrow()
{
    // End:0x73
    if(MyEvilPawn.CanThrowWeapon() && bShouldThrowWeapon)
    {
        MyEvilPawn.ThrowInventory(MyEvilPawn.Weapon);        
    }
    else
    {
        // End:0x11B
        if(CanThrowGrenade())
        {
            ThrowGrenade(Pawn.Rotation);
            // End:0x118
            if((int(MyEvilPawn.CoverType) != int(0)) && !MyEvilPawn.bMovingToCover)
            {
                MyEvilPawn.PlayCoveredGrenadeAttackVoice();
            }            
        }
        else
        {
            OnAbortThrow();
        }
    }
    //return;    
}

simulated function OnStartThrowAlt()
{
    // End:0x73
    if(MyEvilPawn.CanThrowWeaponAlt() && bShouldThrowWeapon)
    {
        MyEvilPawn.ThrowInventory(MyEvilPawn.WeaponLeft,, true);        
    }
    else
    {
        // End:0x11B
        if(CanThrowGrenade())
        {
            ThrowGrenade(Pawn.Rotation);
            // End:0x118
            if((int(MyEvilPawn.CoverType) != int(0)) && !MyEvilPawn.bMovingToCover)
            {
                MyEvilPawn.PlayCoveredGrenadeAttackVoice();
            }            
        }
        else
        {
            OnAbortThrow();
        }
    }
    //return;    
}

simulated function OnAbortThrow()
{
    ReactionManager.NudgeChannel(self, 'AbortedThrowing');
    //return;    
}

simulated function OnStopThrow()
{
    ReactionManager.NudgeChannel(self, 'StoppedThrowing');
    //return;    
}

simulated function OnStartFire()
{
    //return;    
}

simulated function OnStartFireAlt()
{
    //return;    
}

simulated function OnStopFireWithLag()
{
    // End:0x19
    if(IsFiring())
    {
        bShouldStopFiringWithLag = true;
    }
    //return;    
}

simulated function OnStopFire()
{
    // End:0xB1
    if((IsFiring()) && (MyEvilPawn.WeaponLeft == none) || !MyEvilPawn.WeaponLeft.IsFiring())
    {
        LastFireTime = WorldInfo.TimeSeconds;
        BurstTimeLeft = 0.0000000;
        bShouldStopFiringWithLag = false;
    }
    ReactionManager.NudgeChannel(self, 'StoppedShooting');
    //return;    
}

simulated function OnStopFireAlt()
{
    // End:0x8B
    if((IsFiring()) && !MyEvilPawn.Weapon.IsFiring())
    {
        LastFireTime = WorldInfo.TimeSeconds;
        BurstTimeLeft = 0.0000000;
        bShouldStopFiringWithLag = false;
    }
    ReactionManager.NudgeChannel(self, 'StoppedShooting');
    //return;    
}

function TickAim(float DeltaTime)
{
    // End:0x1AC
    if(((IsAiming()) && (ShotTarget != none) || ShotTargetActor != none) && int(MyEvilPawn.CurrentAimZone) != int(0))
    {
        // End:0x1A9
        if(((MyEvilPawn.GetAimingTotalWeight() > 0.9000000) || MyEvilPawn.bDisableIK) && (((HasValidEnemy()) && GetEnemyInfo().Pawn == ShotTarget) && GetEnemyInfo().DistanceToEnemy < EnemyDistance_Melee) || IsWeaponAimingAt(((ShotTargetActor != none) ? ShotTargetActor : ShotTarget), TargettedAimEpsilon))
        {
            // End:0x1A9
            if(ClearFireLineToEnemy())
            {
                ReactionManager.NudgeChannel(((ShotTargetActor != none) ? ShotTargetActor : ShotTarget), 'TargetAimed');
            }
        }        
    }
    else
    {
        MyEvilPawn.StopAim();
    }
    //return;    
}

function TickFire(float DeltaTime)
{
    // End:0x108
    if(!IsTransitioning() && (int(MyEvilPawn.CoverType) == int(0)) || int(MyEvilPawn.CoverAction) != int(0))
    {
        BurstTimeLeft -= (DeltaTime * ((((int(MyEvilPawn.CoverType) != int(0)) && !bShouldStopFiringWithLag) && !MyEvilPawn.IsBlindFiring(MyEvilPawn.CoverAction)) ? 0.2000000 : 1.0000000));        
    }
    else
    {
        FireTime = 0.0000000;
        FireDelay = DeltaTime + 0.1000000;
    }
    // End:0x1F3
    if((((BurstTimeLeft <= 0.0000000) || !HasValidEnemy() && ShotTargetActor == none) || EvilWeap_Base(MyEvilPawn.Weapon).IsReloading()) || int(MyEvilPawn.PawnAction) == 5)
    {
        MyEvilPawn.OnStopFire();        
    }
    else
    {
        // End:0x2F7
        if(!MyEvilPawn.IsFiring() || FireTime <= 0.0000000)
        {
            // End:0x299
            if(FireDelay > 0.0000000)
            {
                FireDelay -= DeltaTime;
                // End:0x296
                if(MyEvilPawn.IsFiring())
                {
                    MyEvilPawn.StopFire(0);
                }                
            }
            else
            {
                MyEvilPawn.StartFire(0);
                FireTime = BurstTimeLeft;
                FireDelay = BurstFireLag;
                BurstTimeLeft += BurstFireLag;
            }            
        }
        else
        {
            // End:0x31E
            if(FireTime > 0.0000000)
            {
                FireTime -= DeltaTime;
            }
        }
    }
    // End:0x398
    if(bShouldStopFiringWithLag)
    {
        // End:0x38C
        if(BurstTimeLeft > BurstFireLag)
        {
            BurstTimeLeft = BurstFireLag * ((int(MyEvilPawn.CoverType) != int(0)) ? 0.2000000 : 1.0000000);
        }
        bShouldStopFiringWithLag = false;
    }
    //return;    
}

function NotifyOnFireLine(EvilPawn Attacker, EvilPawn AttackerEnemy)
{
    //return;    
}

// Export UEvilAIController::execIsBoxOnNavMesh(FFrame&, void* const)
native function bool IsBoxOnNavMesh(Vector PointToCheck, Vector ExtendToCheck);

// Export UEvilAIController::execIsValidPointInDir(FFrame&, void* const)
native function IsValidPointInDir(out Vector Loc, Vector Dir, int Dim, Vector Extent, out array<Vector> out_ValidPositions);

// Export UEvilAIController::execGetValidPositionsNearLocation(FFrame&, void* const)
native function GetValidPositionsNearLocation(Vector Loc, Vector Extent, out array<Vector> out_ValidPositions);

function bool IsPointOnNavMesh(Vector Point)
{
    local Vector PointToCheck, LowerPointToCheck, ExtendToCheck;

    PointToCheck = Point;
    LowerPointToCheck = Point - ((vect(0.0000000, 0.0000000, 1.0000000) * Abs(MyEvilPawn.GetCollisionExtent().Z)) * 0.4000000);
    ExtendToCheck = MyEvilPawn.GetCollisionExtent();
    ExtendToCheck.X = 10.0000000;
    ExtendToCheck.Y = 10.0000000;
    // End:0x124
    if((IsBoxOnNavMesh(PointToCheck, ExtendToCheck)) || IsBoxOnNavMesh(LowerPointToCheck, ExtendToCheck))
    {
        return true;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

function bool IsAiming()
{
    return (MyEvilPawn != none) && MyEvilPawn.IsAiming();
    //return ReturnValue;    
}

function bool IsFiringAtPlayer()
{
    return (IsInFiringState()) && ShotTarget.IsPlayerOwned();
    //return ReturnValue;    
}

function bool IsInFiringState()
{
    local EvilAICommand ActiveCommand;

    ActiveCommand = GetActiveEvilCommand();
    return ((IsFiring()) || int(MyEvilPawn.PawnAction) == 11) || (ActiveCommand != none) && ActiveCommand.bFiringCommand;
    //return ReturnValue;    
}

function bool IsFiring()
{
    return (MyEvilPawn.IsFiring() || int(MyEvilPawn.PawnAction) == 11) || BurstTimeLeft > 0.0000000;
    //return ReturnValue;    
}

function NotifyEndOfPawnAction(byte LastMove)
{
    // End:0x4E
    if((int(LastMove) == 1) || int(LastMove) == 2)
    {
        ReactionManager.NudgeChannel(self, 'ForceThrowDown');
    }
    //return;    
}

function string GetDebugString()
{
    local string CommandListStack;

    // End:0x31
    if(DebugActualState != GetStateName())
    {
        DebugOldState = DebugActualState;
        DebugActualState = GetStateName();
    }
    CommandListStack = ((CommandList != none) ? CommandList.GetDumpString() : "none");
    return (((((((((((((((((((((((((((((((((((((GetHumanReadableName()) @ "\nState A/P:") @ string(DebugActualState)) @ "/") @ string(DebugOldState)) @ "\n") @ string(Pawn.GetStateName())) @ "CL:") @ CommandListStack) @ "\nHealth:") @ string(Pawn.Health)) $ "/") $ string(Pawn.HealthMax)) @ "Phys") @ string(Pawn.Physics)) @ "\nRMM") @ string(Pawn.Mesh.RootMotionMode)) @ "\nFocus:") @ string(Focus)) @ "\nMoveTimer") @ string(MoveTimer)) @ "\nVelocity:") @ string(Pawn.Velocity)) @ "VelSize") @ string(VSize(Pawn.Velocity))) @ "\nAcceleration:") @ string(Pawn.Acceleration)) @ "\nEnemy") @ string(Enemy)) @ "\nMaster") @ string(Master)) @ "\nBase") @ string(Pawn.Base)) @ "\nBehaviorMode: ") @ string(CurrentBehaviorMode)) @ ((Enemy != none) ? "\nEnemy Rating" @ string(GetEnemyInfo().Rating) : "")) @ "\nTeam #:") @ string(GetTeamNum());
    //return ReturnValue;    
}

function string GetGameplayDebugString()
{
    local string CommandListStack;

    CommandListStack = ((CommandList != none) ? CommandList.GetDumpString() : "none");
    return ((((((((((((GetHumanReadableName()) @ "\nCommandState:") @ CommandListStack) @ "\nAgression:") @ string(CurrentAggressionLevel)) @ "\nPAction") @ string(MyEvilPawn.PawnAction)) @ "\nEnemy") @ string(Enemy)) @ "See") @ string(CanSee(Enemy))) @ "\nLatentAction0") @ ((LatentActions.Length > 0) ? string(LatentActions[0]) @ string(((SeqAct_AIMoveToActor(LatentActions[0]) != none) ? SeqAct_AIMoveToActor(LatentActions[0]).bInterruptable : false)) : "none");
    //return ReturnValue;    
}

protected function SeeEnemyAI()
{
    local Pawn P;

    // End:0x86
    foreach Pawn.VisibleActors(Class'Engine.Pawn', P)
    {
        // End:0x6E
        if((P == Pawn) || P.IsPlayerPawn())
        {
            continue;            
        }
        ProcessStimulus(P, 0);        
    }    
    //return;    
}

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
    super(Controller).Possess(NewPawn, bVehicleTransition);
    MyEvilPawn = EvilPawn(NewPawn);
    PossessLocation = NewPawn.Location;
    PossessRotation = NewPawn.Rotation;
    MyEvilPawn.SightRadius = SightRadius;
    bOldMoveAroundWhenIdle = bMoveAroundWhenIdle;
    LifeSpanWithoutPawn = default.LifeSpanWithoutPawn;
    UpdateAim(0.0000000);
    // End:0x136
    if(!bVehicleTransition)
    {
        ReactionManager.Wipe();
        ReactionManager.Initialize();
    }
    // End:0x195
    if(CanThrowAttack())
    {
        ReactionManager.NudgeChannel(self, 'UnBlockCheckFireLine');
        ReactionManager.NudgeChannel(self, 'UnBlockThrowing');
    }
    ChangeBehaviorMode(1);
    // End:0x1C8
    if(int(DefaultAggressionLevel) != int(0))
    {
        ChangeAgrressionLevel(DefaultAggressionLevel);
    }
    // End:0x245
    if(WorldInfo.GRI.IsMultiplayerGame())
    {
        SetTeam(int(WorldInfo.Game.PickTeam(255, self)));        
    }
    else
    {
        SetTeam(int(TeamIndex));
    }
    //return;    
}

event UnPossess()
{
    super(Controller).UnPossess();
    MyEvilPawn = none;
    //return;    
}

event Tick(float DeltaTime)
{
    super(Actor).Tick(DeltaTime);
    // End:0xAF
    if(MyEvilPawn != none)
    {
        // End:0x84
        if(MyEvilPawn.bSpawnDone)
        {
            // End:0x64
            if(IsFiring())
            {
                TickFire(DeltaTime);
            }
            // End:0x84
            if(IsAiming())
            {
                TickAim(DeltaTime);
            }
        }
        ReactionManager.Poll(DeltaTime);        
    }
    else
    {
        LifeSpanWithoutPawn -= DeltaTime;
        // End:0xD9
        if(LifeSpanWithoutPawn <= 0.0000000)
        {
            Destroy();
        }
    }
    //return;    
}

function bool CheckIfNotOnNavmesh()
{
    return NavigationHandle.PointCheck(Pawn.Location, vect(30.0000000, 30.0000000, 100.0000000));
    //return ReturnValue;    
}

function bool ClearFireLineToActor(Actor A, optional Vector Start, optional bool bOverrideStartPoint = false, optional out Actor Obstacle, optional Vector InExtent, optional bool bIgnoreFarAwayObstacles, optional bool bIgnoreDestroyPacks, optional bool bOverrideEndPoint, optional Vector EndPoint)
{
    local bool bFireLineClear;
    local array<ImpactInfo> ImpactList;
    local ImpactInfo CurrentImpactInfo;
    local bool bActorAttached;

    // End:0x43
    if(!bOverrideEndPoint)
    {
        EndPoint = A.Location;
    }
    // End:0xB4
    if(bOverrideStartPoint)
    {        
        MyEvilPawn.Weapon.CalcWeaponFire(Start, EndPoint, ImpactList, InExtent);        
    }
    else
    {        
        MyEvilPawn.Weapon.CalcWeaponFire(Pawn.GetWeaponStartTraceLocation(), EndPoint, ImpactList, InExtent);
    }
    bFireLineClear = true;
    // End:0x2C0
    foreach ImpactList(CurrentImpactInfo)
    {
        Obstacle = CurrentImpactInfo.HitActor;
        // End:0x2BF
        if(ActorIsObstacle(Obstacle, A))
        {
            bActorAttached = IsActorAttachedToObstacle(A, Obstacle);
            // End:0x1D7
            if(bActorAttached)
            {
                bFireLineClear = true;
                // [Explicit Continue]
                goto J0x2C0;
            }
            // End:0x1F8
            if(!bIgnoreFarAwayObstacles)
            {
                bFireLineClear = false;
                goto J0x2C0;                
            }
            else
            {
                // End:0x2BF
                if((!bIgnoreDestroyPacks || EvilDestroyPackBase(Obstacle) == none) && (VSizeSq(CurrentImpactInfo.HitLocation - Pawn.Location) < ((EnemyDistance_Shoot / float(2)) ** float(2))) || VSizeSq(CurrentImpactInfo.HitLocation - EndPoint) > 1600.0000000)
                {
                    bFireLineClear = false;
                    // [Explicit Continue]
                    goto J0x2C0;
                }
            }
        }        
    }
    J0x2C0:
    
    return bFireLineClear;
    //return ReturnValue;    
}

function bool IsActorAttachedToObstacle(Actor A, Actor Obstacle)
{
    local bool bResult;
    local EvilPawn AttachedPawn;

    // End:0x75
    if(EvilRailCar_Base(Obstacle) != none)
    {
        // End:0x74
        foreach EvilRailCar_Base(Obstacle).AttachedPawnList(AttachedPawn)
        {
            // End:0x73
            if(AttachedPawn == A)
            {
                bResult = true;                
            }
            else
            {                
            }
        }        
    }
    return bResult;
    //return ReturnValue;    
}

function bool ActorIsObstacle(Actor PotentialObstacle, Actor IgnoredActor)
{
    return ((PotentialObstacle != none) && PotentialObstacle != IgnoredActor) && EvilAIBlockingVolume(PotentialObstacle) == none;
    //return ReturnValue;    
}

function bool ClearFireLineToEnemy(optional out Actor Obstacle, optional bool bIgnoreFarAwayObstacles, optional bool bIgnoreDestroyPacks, optional Vector InExtent = vect(1.0000000, 1.0000000, 1.0000000))
{
    local bool bResult;

    // End:0xD9
    if(((WorldInfo.TimeSeconds - LastFireLineCheckToEnemyTime) < DelayBetweenFireLineCheckToEnemy) && ((CachedFireLineObstacle == none) || bIgnoreFarAwayObstacles && bIsCachedFireLineObstacleFarAway) || bIgnoreDestroyPacks && EvilDestroyPackBase(CachedFireLineObstacle) != none)
    {
        Obstacle = CachedFireLineObstacle;
        bResult = bLastFireLineCheckToEnemyResult;
        EnemyFireLineCachedRequests++;        
    }
    else
    {
        LastFireLineCheckToEnemyTime = WorldInfo.TimeSeconds;
        CachedFireLineToEnemyExtent = InExtent;
        bLastFireLineCheckToEnemyResult = ClearFireLineToActor(Enemy,,, Obstacle, InExtent, bIgnoreFarAwayObstacles, bIgnoreDestroyPacks);
        bResult = bLastFireLineCheckToEnemyResult;
        CachedFireLineObstacle = Obstacle;
        // End:0x1C8
        if(bResult && Obstacle != none)
        {
            bIsCachedFireLineObstacleFarAway = bIgnoreFarAwayObstacles && !bIgnoreDestroyPacks;
        }
        EnemyFireLineRequests++;
    }
    return bResult;
    //return ReturnValue;    
}

function bool ClearSightToActor(Actor A, optional Vector Start, optional bool bOverrideStartPoint = false, optional out Actor Obstacle, optional out Vector hl, optional Vector InExtent = vect(0.0000000, 0.0000000, 0.0000000))
{
    local Vector hn;

    // End:0xCA
    if(bOverrideStartPoint)
    {
        Obstacle = MyEvilPawn.Trace(hl, hn, A.Location, Start, true, ((VSizeSq(InExtent) > float(0)) ? InExtent : Pawn.GetCollisionExtent() / float(2)));        
    }
    else
    {
        Obstacle = MyEvilPawn.Trace(hl, hn, A.Location, Pawn.Location, true, ((VSizeSq(InExtent) > float(0)) ? InExtent : Pawn.GetCollisionExtent() / float(2)));
    }
    return Obstacle == A;
    //return ReturnValue;    
}

function bool HasCombatZones(optional bool bShouldBeEnabled = true)
{
    local bool bResult;
    local EvilCombatZone CombatZone;

    // End:0x7B
    if(CombatZones.Length > 0)
    {
        // End:0x6F
        if(bShouldBeEnabled)
        {
            // End:0x6B
            foreach CombatZones(CombatZone)
            {
                // End:0x6A
                if(CombatZone.bEnabled)
                {
                    bResult = true;                    
                }
                else
                {                    
                }
            }                        
        }
        else
        {
            bResult = true;
        }
    }
    return bResult;
    //return ReturnValue;    
}

function bool IsLocationInCombatZones(Vector InLocation)
{
    local EvilCombatZone CombatZone;
    local bool bResult;

    // End:0x87
    if(CombatZones.Length > 0)
    {
        // End:0x86
        foreach CombatZones(CombatZone)
        {
            // End:0x85
            if(CombatZone.bEnabled && CombatZone.EncompassesPoint(InLocation))
            {
                bResult = true;                
            }
            else
            {                
            }
        }        
    }
    return bResult;
    //return ReturnValue;    
}

function EvadeAwayFromPoint(Vector DangerPoint, optional EvilPawn Attacker, optional bool bInCombatZones)
{
    SetMovePoint(GetBestEvadeLocation(EnemyDistance_Shoot, DangerPoint));
    //return;    
}

function EvadeAwayFromActor(Actor DangerActor, optional EvilPawn Attacker, optional bool bInCombatZones)
{
    EvadeAwayFromPoint(DangerActor.Location, Attacker, bInCombatZones);
    //return;    
}

function bool CanEvade()
{
    return false;
    //return ReturnValue;    
}

function Vector GetBestEvadeLocation(float Radius, Vector InDangerPoint, optional bool bShouldSeeDanger, optional bool bInCombatZones)
{
    local array<Vector> PositionList;
    local int I, BestEpsilonIndex;
    local float BestEpsilon, Epsilon;
    local Vector P;
    local EvilCombatZone ecz;
    local bool bInCombatZone;

    // End:0x54
    if(Radius < (Pawn.GetCollisionRadius() * float(2)))
    {
        return Pawn.Location;
    }
    Class'Engine.NavigationHandle'.static.GetValidPositionsForBox(Pawn.Location, Radius, Pawn.GetCollisionExtent(), true, PositionList, -1,, vect(30.0000000, 30.0000000, 30.0000000));
    // End:0x20D
    foreach PositionList(P, I)
    {
        Epsilon = VSizeSq(P - InDangerPoint);
        // End:0x196
        if(bInCombatZones)
        {
            bInCombatZone = true;
            // End:0x182
            foreach CombatZones(ecz)
            {
                // End:0x181
                if(!ecz.EncompassesPoint(P))
                {
                    bInCombatZone = false;                    
                }
                else
                {                    
                }
            }            
            // End:0x196
            if(!bInCombatZone)
            {
                continue;
                // [Explicit Continue]
                goto J0x20D;
            }
        }
        // End:0x1CF
        if(bShouldSeeDanger)
        {
            // End:0x1CF
            if(FastTrace(InDangerPoint, P))
            {
                Epsilon *= float(4);                
            }
        }
        // End:0x20C
        if(Epsilon > BestEpsilon)
        {
            BestEpsilon = Epsilon;
            BestEpsilonIndex = I;
        }        
    }
    J0x20D:
    
    return ((PositionList.Length > 0) ? PositionList[BestEpsilonIndex] : MyEvilPawn.Location);
    //return ReturnValue;    
}

function bool ClearSightToEnemy(optional out Actor Obstacle)
{
    return ClearSightToActor(Enemy,,, Obstacle);
    //return ReturnValue;    
}

function EvilTypes.ESpinUpQueryResult CanFastSpinUp(int YawDelta, float DistanceSq)
{
    // End:0x5B
    if(((CommandList != none) && EvilAICmd_Base_Combat(CommandList) != none) && !EvilAICmd_Base_Combat(CommandList).bCanOuterFastSpinUp)
    {
        return 3;
    }
    return MyEvilPawn.CanFastSpinUp(YawDelta, DistanceSq);
    //return ReturnValue;    
}

function bool CanEngageCharge()
{
    return MyEvilPawn.CanEngageCharge();
    //return ReturnValue;    
}

function bool CanStartBurnBehaviour()
{
    return ((BurningCommand != none) && EvilAICmd_Jump(CommandList) == none) && EvilAICmd_Base_Burning(CommandList) == none;
    //return ReturnValue;    
}

function bool CanMeleeAttack()
{
    return (((WorldInfo.TimeSeconds - LastMeleeCommandTime) > TimeBetweenMeleeCommands) && !IsFiring()) && int(MyEvilPawn.CoverType) == int(0);
    //return ReturnValue;    
}

function bool CanThrowAttack()
{
    return MyEvilPawn.CanThrowWeapon();
    //return ReturnValue;    
}

function bool CanThrowGrenade()
{
    return MyEvilPawn.CanThrowGrenade();
    //return ReturnValue;    
}

function bool CanEngageMelee()
{
    return MyEvilPawn.CanEngageMelee();
    //return ReturnValue;    
}

function bool CanLongDistanceCharge()
{
    return MyEvilPawn.CanLongDistanceCharge();
    //return ReturnValue;    
}

function bool CanStrafe(Vector Point)
{
    return MyEvilPawn.CanStrafe(Point) && NavigationHandle.PointReachable(Point);
    //return ReturnValue;    
}

function bool IgnoreNotifies()
{
    // End:0x22
    if((Pawn == none) || !bAllowCombatTransitions)
    {
        return true;
    }
    // End:0x57
    if((CommandList != none) && CommandList.ShouldIgnoreNotifies())
    {
        return true;
    }
    // End:0xE4
    if((MyEvilPawn != none) && MyEvilPawn.IsDoingAPawnAction())
    {
        // End:0xE4
        if(MyEvilPawn.PawnActions[int(MyEvilPawn.PawnAction)].bDisableAI)
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function bool IsFriendlyPawn(Pawn TestPawn)
{
    local bool bResult;

    // End:0x5A
    if(TestPawn.Controller != none)
    {
        bResult = IsFriendly(TestPawn.Controller);        
    }
    else
    {
        // End:0xC6
        if(TestPawn.DrivenVehicle != none)
        {
            bResult = IsFriendly(TestPawn.DrivenVehicle.Controller);
        }
    }
    return bResult;
    //return ReturnValue;    
}

function bool IsFriendly(Controller TestController)
{
    local bool bResult;

    bResult = (((TestController == none) || TestController.Pawn == none) || !TestController.Pawn.IsAliveAndWell()) || (MyEvilPawn != none) && MyEvilPawn.IsSameTeam(TestController.Pawn);
    return bResult;
    //return ReturnValue;    
}

function RevalidateEnemies()
{
    // End:0x23
    if(CommandList != none)
    {
        AbortCommand(CommandList);
    }
    SetEnemy(none);
    EnemyInfoList.Remove(0, EnemyInfoList.Length);    
    FriendInfoList.Remove(0, FriendInfoList.Length);    
    //return;    
}

function ReceiveStimulus(Pawn Source, Pawn P, EvilTypes.EPerceptionType Pt, optional name EventName)
{
    ProcessStimulus(P, Pt, EventName);
    //return;    
}

function BroadcastStimulus(Pawn P, EvilTypes.EPerceptionType Pt, optional name EventName, optional float Radius, optional delegate<ShouldBroadcastDelegate> ShouldBroad = ShouldBroadcast)
{
    local AIDirectorBase AIDirInst;
    local EvilAIController C;
    local float RadiusSq;

    AIDirInst = EvilGame(WorldInfo.Game).AIDirectorInstance;
    RadiusSq = Radius * Radius;
    // End:0x1FB
    foreach WorldInfo.AllControllers(Class'EvilAIController', C)
    {
        // End:0x1FA
        if(ShouldBroadcastDelegate(C, P, Pt, EventName, RadiusSq))
        {
            // End:0x1BE
            if(((AIDirInst != none) && AIDirInst.AIBroadcastManager != none) && AIDirInst.AIBroadcastManager.IsActive())
            {
                AIDirInst.AIBroadcastManager.AddToStimulusQueue(P, Pawn, C, 3, EventName);
                // End:0x1FA
                continue;
            }
            C.ReceiveStimulus(Pawn, P, 3, EventName);
        }        
    }    
    //return;    
}

function bool ProcessStimulus(Pawn P, EvilTypes.EPerceptionType Pt, optional name EventName, optional bool bForceProcessCachedStimulus)
{
    local EvilPlayerController PC;
    local int PawnListIndex;
    local EvilPawn EP;
    local bool bIsFriend;
    local float PawnsDistanceSq;
    local SStimulus NewStimulus, StoredStimulus;
    local bool bAlreadyStored;

    // End:0x62
    if(P.IsA('Vehicle'))
    {
        EP = EvilPawn(Vehicle(P).Driver);        
    }
    else
    {
        EP = EvilPawn(P);
    }
    // End:0xC4
    if(((P == none) || EP == none) || P.bAmbientCreature)
    {
        return false;
    }
    PC = EvilPlayerController(EP.Controller);
    // End:0x170
    if((PC == none) && EP.DrivenVehicle != none)
    {
        PC = EvilPlayerController(EP.DrivenVehicle.Controller);
    }
    // End:0x1CB
    if(((PC != none) && PC.IsDead()) || !EP.IsAliveAndWell())
    {
        return false;
    }
    PawnsDistanceSq = VSizeSq(P.Location - MyEvilPawn.Location);
    // End:0x30E
    if((!EP.CanBeAttacked(MyEvilPawn) || (((CustomSightRadius > 0.0000000) && int(Pt) != int(2)) && int(Pt) != int(1)) && PawnsDistanceSq > (CustomSightRadius * CustomSightRadius)) || (((CustomHearRadius > 0.0000000) && int(Pt) != int(2)) && int(Pt) != int(0)) && PawnsDistanceSq > (CustomHearRadius * CustomHearRadius))
    {
        return false;
    }
    PawnListIndex = GetAIEnemyInfoIdx(EP);
    // End:0x3D2
    if(PawnListIndex >= 0)
    {
        // End:0x3C3
        if((int(Pt) == int(1)) && EnemyInfoList[PawnListIndex].LastSeenTime < (WorldInfo.TimeSeconds + EnemyInfoList[PawnListIndex].UpdateInterval))
        {
            return false;
        }
        bIsFriend = false;        
    }
    else
    {
        PawnListIndex = GetAIFriendInfoIdx(EP);
        // End:0x40F
        if(PawnListIndex >= 0)
        {
            return false;
            bIsFriend = true;            
        }
        else
        {
            bIsFriend = IsFriendly(((PC != none) ? PC : EP.Controller));
        }
    }
    // End:0x565
    if(((PawnListIndex >= 0) && EventName == 'SetTeam') && bIsFriend != (IsFriendly(((PC != none) ? PC : EP.Controller))))
    {
        // End:0x519
        if(bIsFriend)
        {
            FriendInfoList.Remove(PawnListIndex, 1);            
            PawnListIndex = AddEnemy(EP);            
        }
        else
        {
            EnemyInfoList.Remove(PawnListIndex, 1);            
            PawnListIndex = AddFriend(EP);
        }
        bIsFriend = !bIsFriend;        
    }
    else
    {
        // End:0x5B3
        if(PawnListIndex < 0)
        {
            PawnListIndex = ((bIsFriend) ? AddFriend(EP) : AddEnemy(EP));
        }
    }
    // End:0x5C8
    if(PawnListIndex == -1)
    {
        return false;
    }
    // End:0x619
    if(bIsFriend)
    {
        GetAIEnemyInfoIdx(EP);
        UpdateFriendlyCharacterInfo(EP, Pt, EventName, PawnListIndex);        
    }
    else
    {
        GetAIFriendInfoIdx(EP);
        UpdateEnemyCharacterInfo(EP, Pt, EventName, PawnListIndex);
        CheckForRequestHelpFromEnemy(PawnListIndex);
    }
    NewStimulus.EventName = EventName;
    NewStimulus.EP = EP;
    NewStimulus.Pt = Pt;
    bAlreadyStored = false;
    // End:0x7FD
    foreach CachedStimulus(StoredStimulus)
    {
        // End:0x7FC
        if(((StoredStimulus.EP == NewStimulus.EP) && int(StoredStimulus.Pt) == int(NewStimulus.Pt)) && (StoredStimulus.EventName == NewStimulus.EventName) || NewStimulus.EventName == 'AlertedByPawn')
        {
            bAlreadyStored = true;            
        }
        else
        {            
        }
    }    
    // End:0x823
    if(!bAlreadyStored)
    {
        CachedStimulus.AddItem(NewStimulus);        
    }
    // End:0x878
    if(bNotifiesInRange && EventName != 'AlertedByPawn')
    {
        BroadcastStimulus(EP, Pt, 'AlertedByPawn', NotifiesInRangeRadius);
    }
    // End:0x892
    if(bForceProcessCachedStimulus)
    {
        ProcessCachedStimulus();        
    }
    else
    {
        // End:0x8BE
        if(!IsTimerActive('ProcessCachedStimulus'))
        {
            SetTimer(0.5000000, false, 'ProcessCachedStimulus');
        }
    }
    return false;
    //return ReturnValue;    
}

function ProcessCachedStimulus()
{
    local SStimulus stimulus;
    local bool bIsFriend;
    local int PawnListIndex;
    local bool bUpdateTarget, bIgnoredSimulus;
    local int I;

    I = CachedStimulus.Length - 1;
    J0x17:

    // End:0x3E0 [Loop If]
    if(I >= 0)
    {
        stimulus = CachedStimulus[I];
        // End:0x7D
        if(stimulus.EP == none)
        {
            CachedStimulus.Remove(I, 1);                        
        }
        else
        {
            PawnListIndex = GetAIEnemyInfoIdx(stimulus.EP);
            // End:0xCB
            if(PawnListIndex >= 0)
            {
                bIsFriend = false;                
            }
            else
            {
                PawnListIndex = GetAIFriendInfoIdx(stimulus.EP);
                bIsFriend = true;
            }
            // End:0x1A4
            if(int(stimulus.Pt) == int(0))
            {
                // End:0x1A1
                if(stimulus.EP.IsHumanControlled())
                {
                    ReactionManager.NudgePerceptionChannel(stimulus.EP, 4);
                }                
            }
            else
            {
                // End:0x23E
                if(int(stimulus.Pt) == int(1))
                {
                    // End:0x23E
                    if(stimulus.EP.IsHumanControlled())
                    {
                        ReactionManager.NudgePerceptionChannel(stimulus.EP, 5);
                    }
                }
            }
            // End:0x38B
            if(!bIsFriend)
            {
                ReactionManager.NudgePerceptionChannel(stimulus.EP, stimulus.Pt);
                // End:0x37F
                if(!IgnoreNotifies())
                {
                    // End:0x361
                    if(((int(stimulus.Pt) == int(3)) || int(stimulus.Pt) == int(0)) || int(stimulus.Pt) == int(1))
                    {
                        NoticedEnemy(stimulus.EP);
                        bUpdateTarget = true;                        
                    }
                    else
                    {
                        // End:0x37C
                        if(!IsAttacking())
                        {
                            bUpdateTarget = true;
                        }
                    }                    
                }
                else
                {
                    bIgnoredSimulus = true;
                }
            }
            MyEvilPawn.TriggerEventClass(Class'SeqEvent_SeeEvilEnemy', stimulus.EP);
        }
        --I;
        // [Loop Continue]
        goto J0x17;
    }
    // End:0x3F7
    if(bUpdateTarget)
    {
        SelectTarget();
    }
    // End:0x41F
    if(!bIgnoredSimulus)
    {
        CachedStimulus.Remove(0, CachedStimulus.Length);                
    }
    else
    {
        SetTimer(0.5000000, false, 'ProcessCachedStimulus');
    }
    //return;    
}

function ChangeBehaviorMode(EvilTypesNative.EBehaviorMode InNewMode)
{
    // End:0x61
    if(CanChangeBehaviorMode(InNewMode, CurrentBehaviorMode))
    {
        LastBehaviorMode = CurrentBehaviorMode;
        CurrentBehaviorMode = InNewMode;
        BehaviorModeChanged(CurrentBehaviorMode, LastBehaviorMode);
    }
    //return;    
}

function bool CanChangeBehaviorMode(EvilTypesNative.EBehaviorMode InNewMode, EvilTypesNative.EBehaviorMode InOldMode)
{
    // End:0x1D
    if(int(InNewMode) == int(InOldMode))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function BehaviorModeChanged(EvilTypesNative.EBehaviorMode InNewMode, EvilTypesNative.EBehaviorMode InOldMode)
{
    ReactionManager.BehaviorModeChanged(InNewMode, InOldMode);
    // End:0x6B
    if(int(InNewMode) == int(1))
    {
        // End:0x68
        if(CommandList != none)
        {
            AbortCommand(CommandList);
        }        
    }
    else
    {
        // End:0xCE
        if((int(InNewMode) == int(2)) || int(InNewMode) == int(3))
        {
            BeginCombatCommand(DefaultCommand, "BehaviorModeChanged to" @ string(InNewMode));
        }
    }
    // End:0x10E
    if(MyEvilPawn != none)
    {
        MyEvilPawn.NotifyBehaviorModeChanged(InNewMode, InOldMode);
    }
    //return;    
}

function OnChangeAggressionLevel(SeqAct_ChangeAggressionLevel Action)
{
    ChangeAgrressionLevel(Action.AggressionLevel);
    //return;    
}

function ChangeAgrressionLevel(EvilTypes.EAggressionLevel InNewLevel)
{
    // End:0x61
    if(CanChangeAgrressionLevel(InNewLevel, CurrentAggressionLevel))
    {
        LastAggressionLevel = CurrentAggressionLevel;
        CurrentAggressionLevel = InNewLevel;
        AgrressionLevelChanged(CurrentAggressionLevel, LastAggressionLevel);
    }
    //return;    
}

function bool CanChangeAgrressionLevel(EvilTypes.EAggressionLevel InNewLevel, EvilTypes.EAggressionLevel InOldLevel)
{
    // End:0x1D
    if(int(InNewLevel) == int(InOldLevel))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

event ReachedPreciseDestination()
{
    // End:0x51
    if((CommandList != none) && EvilAICommand(CommandList) != none)
    {
        EvilAICommand(CommandList).ReachedPreciseDestination();
    }
    //return;    
}

function AgrressionLevelChanged(EvilTypes.EAggressionLevel InNewLevel, EvilTypes.EAggressionLevel InOldLevel)
{
    switch(InNewLevel)
    {
        // End:0x2E
        case 1:
            BeginAttackDistance = BeginAttackDistance_Covered;
            // End:0x82
            break;
        // End:0x49
        case 2:
            BeginAttackDistance = BeginAttackDistance_Low;
            // End:0x82
            break;
        // End:0x64
        case 3:
            BeginAttackDistance = BeginAttackDistance_Normal;
            // End:0x82
            break;
        // End:0x7F
        case 4:
            BeginAttackDistance = BeginAttackDistance_High;
            // End:0x82
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0xE5
    if((CommandList != none) && EvilAICommand(CommandList) != none)
    {
        EvilAICommand(CommandList).AgrressionLevelChanged(InNewLevel, InOldLevel);
    }
    //return;    
}

function BeginRun2Cover(CoverInfo InCoverGoal)
{
    //return;    
}

function BeginAiming(optional float MinAimTime, optional bool InAimToThrow)
{
    // End:0x7F
    if((FindCommandOfClass(Class'EvilAICmd_Aim') == none) && GetActiveEvilCommand().AllowTransitionTo(Class'EvilAICmd_Aim'))
    {
        Class'EvilAICmd_Aim'.static.AimEnemy(self, MinAimTime, InAimToThrow);        
    }
    else
    {
        ReactionManager.NudgeChannel(self, 'AbortedAiming');
    }
    //return;    
}

function PawnDied(Pawn inPawn)
{
    InvalidateCoverAction();
    InvalidateCover();
    super(Controller).PawnDied(inPawn);
    //return;    
}

function PeekFromCover()
{
    //return;    
}

function FireFromCover()
{
    //return;    
}

function BeginFireFromOpenWrapper(Actor EventInstigator, EvilAIReactChannel OrigChannel)
{
    FireFromOpen();
    //return;    
}

function FireFromOpen(optional int InBursts = 1, optional float InBurstDelay = 3.0000000, optional bool bAllowFireWhileMoving = true)
{
    MyEvilPawn.StartShootAttack();
    //return;    
}

function SetAttackBehaviorWrapper(Actor EventInstigator, EvilAIReactChannel OrigChannel)
{
    SetAttackBehavior(Pawn(EventInstigator), EvilAIReactChan_Damage(OrigChannel));
    //return;    
}

function SetAttackBehavior(Pawn InEnemy, optional EvilAIReactChan_Damage DamageChannel)
{
    // End:0x43
    if(int(CurrentBehaviorMode) < int(3))
    {
        ChangeBehaviorMode(3);
        // End:0x43
        if(InEnemy != none)
        {
            SetEnemy(InEnemy);
        }
    }
    //return;    
}

function BeginLongDistanceChargeWrapper(Actor EventInstigator, EvilAIReactChannel OrigChannel)
{
    BeginLongDistanceCharge(Pawn(EventInstigator), string(OrigChannel.ChannelName));
    //return;    
}

function BeginLongDistanceCharge(Pawn TargetPawn, coerce optional string Reason)
{
    MyEvilPawn.StartLongDistanceCharge();
    // End:0x4B
    if(IsTimerActive('OnLongDistanceChargeStop'))
    {
        ClearTimer('OnLongDistanceChargeStop');
    }
    SetTimer(LongDistanceChargeTimeout, false, 'OnLongDistanceChargeStop');
    //return;    
}

function OnLongDistanceChargeAbort()
{
    MyEvilPawn.StopLongDinstanceCharge();
    // End:0x4A
    if(IsTimerActive('OnLongDistanceChargeStop'))
    {
        ClearTimer('OnLongDistanceChargeStop');
    }
    ReactionManager.NudgeChannel(self, 'LongDistanceChargeAborted');
    //return;    
}

function OnLongDistanceChargeStop()
{
    MyEvilPawn.StopLongDinstanceCharge();
    // End:0x4A
    if(IsTimerActive('OnLongDistanceChargeStop'))
    {
        ClearTimer('OnLongDistanceChargeStop');
    }
    ReactionManager.NudgeChannel(self, 'LongDistanceChargeStopped');
    //return;    
}

function bool IsLongDistanceChargeActive()
{
    return MyEvilPawn.IsLongDistanceChargeActive();
    //return ReturnValue;    
}

function BeginMeleeCommandWrapper(Actor EventInstigator, EvilAIReactChannel OrigChannel)
{
    BeginMeleeCommand(Pawn(EventInstigator), string(OrigChannel.ChannelName));
    //return;    
}

function BeginMeleeCommand(Pawn TargetPawn, coerce optional string Reason)
{
    // End:0x62
    if(EvilAICmd_Base_Melee(CommandList) == none)
    {
        // End:0x3B
        if(TargetPawn != none)
        {
            SetEnemy(TargetPawn);
        }
        BeginCombatCommand(MeleeCommand, "BeginMeleeCommand");
    }
    //return;    
}

function BeginGuardCommand(Pawn TargetPawn, coerce optional string Reason)
{
    // End:0x62
    if(EvilAICmd_Base_Guard(CommandList) == none)
    {
        // End:0x3B
        if(TargetPawn != none)
        {
            SetEnemy(TargetPawn);
        }
        BeginCombatCommand(GuardCommand, "BeginGuardCommand");
    }
    //return;    
}

function EndGuardCommandWrapper(Actor EventInstigator, EvilAIReactChannel OrigChannel)
{
    EndGuardCommand(Pawn(EventInstigator), string(OrigChannel.ChannelName));
    //return;    
}

function EndGuardCommand(Pawn TargetPawn, coerce optional string Reason)
{
    // End:0x42
    if(EvilAICmd_Base_Guard(CommandList) != none)
    {
        ClearLatentAction(Class'SeqAct_AIGuardArea');
        AbortCommand(CommandList);
    }
    //return;    
}

function ThrowAttack()
{
    // End:0x6A
    if((FindCommandOfClass(Class'EvilAICmd_Attack_Throw') == none) && GetActiveEvilCommand().AllowTransitionTo(Class'EvilAICmd_Attack_Throw'))
    {
        ThrowCommand.static.Throw(self);        
    }
    else
    {
        ReactionManager.NudgeChannel(self, 'AbortedThrowing');
    }
    //return;    
}

function BeginThrowWrapper(Actor EventInstigator, EvilAIReactChannel OrigChannel)
{
    // End:0x39
    if(OrigChannel.ChannelName != 'ForceThrowDown')
    {
        ThrowAttack();        
    }
    else
    {
        // End:0xCC
        if(MyEvilPawn.Weapon.CanThrow())
        {
            MyEvilPawn.ThrowInventory(MyEvilPawn.Weapon, MyEvilPawn.Velocity);
        }
    }
    //return;    
}

function AbortMovingOnEnemyCloseAndVisibleWrapper(Actor EventInstigator, EvilAIReactChannel OrigChannel)
{
    // End:0x48
    if(OrigChannel.ChannelName != 'BlockAbortMovingOnEnemyCloseAndVisible')
    {
        AbortMovingOnEnemyCloseAndVisible(EvilPawn(EventInstigator));
    }
    //return;    
}

function AbortMovingOnEnemyCloseAndVisible(EvilPawn SeenPawn)
{
    local bool bInteruptable;
    local SeqAct_Latent Action;
    local float EnemyDistanceThreshold;

    bInteruptable = true;
    // End:0x118
    foreach LatentActions(Action)
    {
        // End:0x117
        if(SeqAct_AIMoveToActor(Action) != none)
        {
            bInteruptable = bInteruptable && SeqAct_AIMoveToActor(Action).bInterruptable;
            // End:0x114
            if((SeqAct_AIMoveToActor(Action).EnemyInterruptDistanceThreshold > float(0)) && EnemyDistanceThreshold > SeqAct_AIMoveToActor(Action).EnemyInterruptDistanceThreshold)
            {
                EnemyDistanceThreshold = SeqAct_AIMoveToActor(Action).EnemyInterruptDistanceThreshold;
            }            
        }
        else
        {            
        }
    }    
    // End:0x238
    if((((((SeenPawn != none) && InLatentExecution(501) || InLatentExecution(503)) && !MyEvilPawn.IsSameTeam(SeenPawn)) && bInteruptable) && (EnemyDistanceThreshold <= 0.0000000) || GetEnemyInfo(SeenPawn).DistanceToEnemy < EnemyDistanceThreshold) && AbortMoving())
    {
        BeginCombatCommand(GetDefaultCommand(), "AbortMovingOnEnemyCloseAndVisible");
        ClearLatentAction(Class'Engine.SeqAct_Latent', true);        
    }
    else
    {
        ReactionManager.NudgeChannel(self, 'UnBlockAbortMovingOnEnemyCloseAndVisible');
    }
    //return;    
}

function bool AbortMoving()
{
    local EvilAICommand Cmd;

    Cmd = GetActiveEvilCommand();
    // End:0x5C
    if((EvilAICmd_MoveToEnemy(Cmd) != none) || EvilAICmd_MoveToGoal(Cmd) != none)
    {
        AbortCommand(Cmd);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function AbortCoveringWrapper(Actor EventInstigator, EvilAIReactChannel OrigChannel)
{
    AbortCovering(Pawn(EventInstigator), string(OrigChannel.ChannelName));
    //return;    
}

function AbortCovering(Pawn TargetPawn, coerce optional string Reason)
{
    //return;    
}

function BeginCombatCommand(class<EvilAICmd_Base_Combat> CmdClass, coerce optional string Reason, optional bool bForced)
{
    local class<EvilAICmd_Base_Combat> CurClass;
    local EvilAICmd_Base_Combat CurCommand;

    // End:0x6D
    if(CommandList != none)
    {
        CurCommand = EvilAICmd_Base_Combat(CommandList);
        // End:0x6D
        if(CurCommand != none)
        {
            CurClass = EvilAICmd_Base_Combat(CommandList).Class;
        }
    }
    // End:0xCB
    if(!bForced)
    {
        // End:0x8D
        if(!bAllowCombatTransitions)
        {
            return;
        }
        // End:0xCB
        if(CommandList != none)
        {
            // End:0xCB
            if(!CommandList.AllowTransitionTo(CmdClass))
            {
                return;
            }
        }
    }
    // End:0xEC
    if(CurClass != CmdClass)
    {
        ClearCoverGoal();
    }
    AbortCommand(CommandList);
    // End:0x170
    if(CmdClass != none)
    {
        // End:0x14D
        if((CmdClass != Class'EvilAICmd_Base_ScriptedMove') && CmdClass != Class'EvilAICmd_Base_ScriptedRouteMove')
        {
            GotoState('Combat');
        }
        CmdClass.static.InitCommand(self);        
    }
    else
    {
        GotoState('Auto');
    }
    //return;    
}

function class<EvilAICmd_Base_Combat> GetDefaultCommand()
{
    return DefaultCommand;
    //return ReturnValue;    
}

function bool ShouldBeInIdle()
{
    return (!HasAnyEnemies() && LatentActions.Length <= 0) && !((CommandList != none) && EvilAICommand(CommandList) != none) && !EvilAICommand(CommandList).ShouldBeInIdle();
    //return ReturnValue;    
}

function CheckTimedCombatTransition()
{
    local EvilAICmd_Base_Combat CurCombatCommand;
    local class<EvilAICmd_Base_Combat> NewCommand;
    local bool bCanDoTransition;
    local string Reason;

    CurCombatCommand = EvilAICmd_Base_Combat(CommandList);
    // End:0x2D
    if(CurCombatCommand == none)
    {
        return;
    }
    MyEvilPawn.PlayAttackAmbientVoice();
    SetTimer(CurCombatCommand.GetTransitionCheckTime(), false, 'CheckTimedCombatTransition');
    // End:0x88
    if(IgnoreTimeTransitions())
    {
        return;
    }
    bCanDoTransition = !BlockCombatTransitions();
    // End:0x10C
    if(bCanDoTransition)
    {
        // End:0x10C
        if(CurCombatCommand.CheckTransition(NewCommand, Reason))
        {
            BeginCombatCommand(NewCommand, Reason);
            ChangeBehaviorMode(1);            
        }
    }
    //return;    
}

function bool BlockCombatTransitions()
{
    local EvilAICmd_Base_Combat CurCombatCommand;
    local AICharacterInfo EnemyInfo;

    // End:0x2F
    if(((Pawn == none) || IsDead()) || IgnoreNotifies())
    {
        return false;
    }
    // End:0x69
    if(ShouldBeInIdle())
    {
        // End:0x67
        if(CommandList != none)
        {
            BeginCombatCommand(none, "ShouldBeInIdle");
        }
        return true;
    }
    CurCombatCommand = EvilAICmd_Base_Combat(CommandList);
    // End:0x96
    if(CurCombatCommand == none)
    {
        return false;
    }
    EnemyInfo = GetEnemyInfo();
    // End:0x175
    if((((CanEngageMelee()) && EnemyInfo.Pawn != none) && EnemyInfo.DistanceToEnemy < EnemyDistance_MeleeCharge) && !CommandList.IsA('EvilAICmd_Base_Melee'))
    {
        ReactionManager.NudgeChannel(EnemyInfo.Pawn, 'EnemyWithinMeleeChargeDistance');
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CheckCombatTransition()
{
    local bool bCanDoTransition;
    local EvilAICmd_Base_Combat CurCombatCommand;
    local class<EvilAICmd_Base_Combat> NewCommand;
    local string Reason;

    bCanDoTransition = !BlockCombatTransitions();
    // End:0x116
    if(bCanDoTransition)
    {
        CurCombatCommand = EvilAICmd_Base_Combat(CommandList);
        // End:0xB3
        if((CurCombatCommand != none) && CurCombatCommand.CheckTransition(NewCommand, Reason))
        {
            BeginCombatCommand(NewCommand, "CheckCombatTransition");            
        }
        else
        {
            // End:0x116
            if(CurCombatCommand == none)
            {
                NewCommand = GetDefaultCommand();
                // End:0xE7
                if(NewCommand == none)
                {
                    return;
                }
                BeginCombatCommand(NewCommand, "Default Command Specified");
            }
        }
    }
    //return;    
}

function bool IgnoreTimeTransitions()
{
    // End:0x20
    if((CommandList == none) || IsDead())
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function DoDodge()
{
    // End:0x48
    if(MyEvilPawn.AST_GetAnimCount(89) > 0)
    {
        Class'EvilAICmd_Dodge'.static.Dodge(self);
    }
    //return;    
}

function DoMeleeAttack(optional Pawn NewEnemy)
{
    // End:0x23
    if(NewEnemy != none)
    {
        SetEnemy(NewEnemy);
    }
    Class'EvilAICmd_Attack_Melee'.static.Melee(self);
    //return;    
}

function bool CheckFireLineFromStrafePoint(Vector StrafePoint)
{
    // End:0x69
    if((ShotTarget == none) || ClearFireLineToActor(ShotTarget, StrafePoint, true,,, true, true, true, GetAimLocation(ShotTarget, MyEvilPawn.RequestedAimZone)))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function float RateStrafeByFlankEnemy(EvilStrafeData StrafeData, const out array<EvilStrafeData> StrafeDataArray)
{
    local EvilAIController EvilController;
    local float PerpDotStrafe, OpRatingSum, Rating;
    local int FriendlyCount;
    local Vector FriendlyFireLine, FireLine, PerpVect, Proj;
    local float StrafeDistanceSq;
    local Vector PredictedFriendPosition;
    local int I;

    StrafeDistanceSq = VSizeSq(MyEvilPawn.Location - StrafeData.StrafePoint);
    Rating = 1.0000000;
    I = 0;
    J0x62:

    // End:0x3A5 [Loop If]
    if(I < FriendInfoList.Length)
    {
        EvilController = FriendInfoList[I].Controller;
        // End:0x397
        if((EvilController != none) && EvilController.Enemy != none)
        {
            // End:0x1D9
            if(EvilController.InLatentExecution(503) || EvilController.InLatentExecution(501))
            {
                PredictedFriendPosition = EvilController.GetDestinationPosition();
                // End:0x1D6
                if(PredictedFriendPosition == EvilController.Enemy.Location)
                {
                    PredictedFriendPosition = EvilController.MyEvilPawn.Location;
                }                
            }
            else
            {
                PredictedFriendPosition = EvilController.MyEvilPawn.Location;
            }
            FireLine = EvilController.Enemy.Location - MyEvilPawn.Location;
            FriendlyFireLine = EvilController.Enemy.Location - PredictedFriendPosition;
            Proj = ProjectOnTo(FireLine, FriendlyFireLine);
            PerpVect = FireLine - Proj;
            PerpDotStrafe = Normal(PerpVect) Dot Normal(StrafeData.StrafePoint - MyEvilPawn.Location);
            OpRatingSum += FClamp(PerpDotStrafe * (StrafeDistanceSq / (VSizeSq(PerpVect) + 1.0000000)), -1.0000000, 1.0000000);
            FriendlyCount++;
        }
        I++;
        // [Loop Continue]
        goto J0x62;
    }
    // End:0x3E9
    if(FriendlyCount > 0)
    {
        Rating -= FPctByRange(OpRatingSum / float(FriendlyCount), -1.0000000, 1.0000000);
    }
    return Rating;
    //return ReturnValue;    
}

function float OnRateStrafeByFlankEnemy(EvilStrafeData StrafeData, const out array<EvilStrafeData> StrafeDataArray)
{
    local float StrafeSumRating, StrafeRating, StrafeFlankRating;

    StrafeRating = OnRateStrafe(StrafeData, StrafeDataArray);
    StrafeFlankRating = RateStrafeByFlankEnemy(StrafeData, StrafeDataArray);
    StrafeSumRating = (StrafeRating * StrafeFlankRating) * StrafeFlankRating;
    return StrafeSumRating;
    //return ReturnValue;    
}

function float GetClearFireLineEnemy(bool bClearFireLine)
{
    // End:0x16
    if(bClearFireLine)
    {
        return 1.0000000;        
    }
    else
    {
        return 0.1000000;
    }
    //return ReturnValue;    
}

function float GetEnemyReachableStrafeModifier(bool bReachable)
{
    // End:0x16
    if(bReachable)
    {
        return 1.0000000;        
    }
    else
    {
        return 0.9000000;
    }
    //return ReturnValue;    
}

function bool IsStrafesOppositeDirection(EvilTypesNative.EStrafeDirection Direction1, EvilTypesNative.EStrafeDirection Direction2, optional bool bOnlyLeftRight)
{
    local bool bOpposite;

    switch(Direction1)
    {
        // End:0x4D
        case 5:
            // End:0x4A
            if((int(Direction2) == int(4)) && !bOnlyLeftRight)
            {
                bOpposite = true;
            }
            // End:0xD9
            break;
        // End:0x86
        case 4:
            // End:0x83
            if((int(Direction2) == int(5)) && !bOnlyLeftRight)
            {
                bOpposite = true;
            }
            // End:0xD9
            break;
        // End:0xAE
        case 3:
            // End:0xAB
            if(int(Direction2) == int(2))
            {
                bOpposite = true;
            }
            // End:0xD9
            break;
        // End:0xD6
        case 2:
            // End:0xD3
            if(int(Direction2) == int(3))
            {
                bOpposite = true;
            }
            // End:0xD9
            break;
        // End:0xFFFF
        default:
            break;
    }
    return bOpposite;
    //return ReturnValue;    
}

function float OnRateSideStrafes(EvilStrafeData StrafeData, const out array<EvilStrafeData> StrafeDataArray)
{
    switch(StrafeData.StrafeDirection)
    {
        // End:0x2B
        case 2:
        // End:0x50
        case 3:
            return OnRateStrafe(StrafeData, StrafeDataArray);
            // End:0x53
            break;
        // End:0xFFFF
        default:
            break;
    }
    return -1.0000000;
    //return ReturnValue;    
}

function float OnRateStrafe(EvilStrafeData StrafeData, const out array<EvilStrafeData> StrafeDataArray)
{
    local float Rating, StrafeToEnemyDistanceSq, HitPanicTime;
    local bool bInPanic;

    // End:0x26
    if(StrafeData.bDisabled)
    {
        return 0.0000000;
    }
    // End:0x4E
    if(!StrafeData.bValidMoveToStrafePoint)
    {
        return 0.0000000;
    }
    // End:0xD9
    if((StrafeData.StrafeDelay > 0.0000000) && WorldInfo.TimeSeconds < (StrafeData.LastStrafeTime + StrafeData.StrafeDelay))
    {
        return 0.0000000;
    }
    Rating = StrafeData.DefaultRating;
    Rating *= (GetEnemyReachableStrafeModifier(StrafeData.bEnemyReachable));
    Rating *= (GetClearFireLineEnemy(StrafeData.bClearFireLine));
    StrafeToEnemyDistanceSq = ((Enemy != none) ? VSizeSq(Enemy.Location - StrafeData.StrafePoint) : 0.0000000);
    HitPanicTime = 5.0000000;
    bInPanic = (WorldInfo.TimeSeconds - MyEvilPawn.LastHitTime) <= HitPanicTime;
    // End:0x4B5
    if((((int(CurrentAggressionLevel) < int(3)) || MyEvilPawn.IsReloading()) || bInPanic) || GetEnemyInfo().DistanceToEnemy < (EnemyDistance_MinimalStrafeDistance * 1.2000000))
    {
        Rating *= (1.0000000 - FMin(1.0000000 - FMin(0.1000000, HitPanicTime / (((WorldInfo.TimeSeconds - MyEvilPawn.LastHitTime) + 0.0010000) * 10.0000000)), ((Enemy != none) ? (StrafeData.StrafeDistance ** float(2)) / (StrafeToEnemyDistanceSq + 1.0000000) : 0.0000000)));
        Rating *= ((Enemy != none) ? FMax(((Enemy.IsFiring() || bInPanic) ? 1.0000000 : 0.0200000), Enemy.Velocity Dot Normal(StrafeData.StrafePoint - MyEvilPawn.Location)) : 1.0000000);
        Rating *= ((Enemy != none) ? ((Normal(Vector(Enemy.Rotation)) Dot Normal(GetEnemyInfo().KnownLocation - StrafeData.StrafePoint)) + 1.0000000) * 0.5000000 : 1.0000000);        
    }
    else
    {
        Rating *= FMin(1.0000000, ((Enemy != none) ? ((MyEvilPawn.GetCollisionRadius() ** float(2)) / (StrafeToEnemyDistanceSq + 1.0000000)) + 0.0100000 : 0.0000000));
    }
    // End:0x66D
    if(LastStrafeIndex > -1)
    {
        Rating *= ((((IsStrafesOppositeDirection(StrafeData.StrafeDirection, StrafeDataArray[LastStrafeIndex].StrafeDirection)) || ((StrafeDataArray[LastStrafeIndex].StrafeDistance <= 100.0000000) && StrafeData.StrafeDistance <= 100.0000000) && StrafeData.StrafeDistance > 1.0000000) && WorldInfo.TimeSeconds <= (StrafeDataArray[LastStrafeIndex].LastStrafeTime + DelayBetweenOppositeStrafes)) ? 0.0000000 : 1.0000000);
    }
    return Rating;
    //return ReturnValue;    
}

function CalculateStrafePointsRating(optional out array<EvilStrafeData> InStrafesDate, optional delegate<RateStrafe> RateStrafeDelegate = OnRateStrafe, optional Actor InFocus, optional float StrafeDistance = 100.0000000)
{
    local int I, StrafesToCheck;

    // End:0x4B2
    if((HasValidEnemy()) && InStrafesDate.Length > 0)
    {
        I = 0;
        J0x4A:

        // End:0x9C [Loop If]
        if(I < InStrafesDate.Length)
        {
            InStrafesDate[I].Rating = 0.0000000;
            I++;
            // [Loop Continue]
            goto J0x4A;
        }
        LastCheckedStrafeIndex++;
        StrafesToCheck = NumOfCheckedStrafesInRating;
        J0xBA:

        // End:0x49F [Loop If]
        if(StrafesToCheck > 0)
        {
            I = LastCheckedStrafeIndex++ % InStrafesDate.Length;
            // End:0x2FF
            if(int(InStrafesDate[I].StrafeDirection) != int(0))
            {
                // End:0x1E6
                if(VSizeSq(InStrafesDate[I].CustomStrafeDelta) > 0.0000000)
                {
                    InStrafesDate[I].StrafePoint = MyEvilPawn.Location + TransformVectorByRotation(MyEvilPawn.Rotation, InStrafesDate[I].CustomStrafeDelta);                    
                }
                else
                {
                    InStrafesDate[I].StrafePoint = GetStrafePointByDirection(InStrafesDate[I].StrafeDirection, ((InStrafesDate[I].StrafeDistance > 0.0000000) ? InStrafesDate[I].StrafeDistance : StrafeDistance), RandRange(-InStrafesDate[I].RandomAngleOffset, InStrafesDate[I].RandomAngleOffset), InFocus);
                }
            }
            InStrafesDate[I].bValidMoveToStrafePoint = CheckStrafePointReachability(InStrafesDate[I].StrafePoint);
            InStrafesDate[I].bClearFireLine = CheckFireLineFromStrafePoint(InStrafesDate[I].StrafePoint);
            InStrafesDate[I].bEnemyReachable = NavigationHandle.PointReachable(Enemy.Location, InStrafesDate[I].StrafePoint, true);
            InStrafesDate[I].Rating = RateStrafe(InStrafesDate[I], InStrafesDate);
            StrafesToCheck--;
            // [Loop Continue]
            goto J0xBA;
        }
        LastCheckedStrafeIndex = I;
    }
    return;
    //return;    
}

function EvilStrafeData MakeStrafePoint(Vector InPosition, float InRating)
{
    local EvilStrafeData StrafeData;

    StrafeData.DefaultRating = InRating;
    StrafeData.StrafePoint = InPosition;
    return StrafeData;
    //return ReturnValue;    
}

function bool DoStrafeByDirections(optional delegate<RateStrafe> RateStrafeDelegate = OnRateStrafe, optional Actor InFocus, optional float StrafeDistance = 500.0000000)
{
    local int BestIndex;

    BestIndex = GetBestStrafeByDirectionIndex(RateStrafeDelegate, InFocus, StrafeDistance);
    // End:0x121
    if((BestIndex >= 0) && DoStrafe(StrafesData[BestIndex].StrafePoint, true, InFocus))
    {
        StrafesData[BestIndex].Count++;
        StrafesData[BestIndex].LastStrafeTime = WorldInfo.TimeSeconds;
        LastStrafeIndex = BestIndex;
        return true;        
    }
    else
    {
        return false;
    }
    return false;
    //return ReturnValue;    
}

function bool DoCustomStrafe(out array<EvilStrafeData> InStrafeData, optional delegate<RateStrafe> RateStrafeDelegate = OnRateStrafe, optional Actor InFocus, optional float StrafeDistance = 500.0000000)
{
    local int BestIndex;

    BestIndex = GetBestStrafeIndex(InStrafeData, RateStrafeDelegate, InFocus, StrafeDistance);
    // End:0xAA
    if(BestIndex >= 0)
    {
        DrawDebugBox(InStrafeData[BestIndex].StrafePoint, vect(30.0000000, 30.0000000, 30.0000000), 255, 255, 0, true);
    }
    // End:0x1C1
    if((BestIndex >= 0) && DoStrafe(InStrafeData[BestIndex].StrafePoint, true, InFocus))
    {
        InStrafeData[BestIndex].Count++;
        InStrafeData[BestIndex].LastStrafeTime = WorldInfo.TimeSeconds;
        LastStrafeIndex = BestIndex;
        DrawDebugBox(InStrafeData[BestIndex].StrafePoint, vect(20.0000000, 20.0000000, 20.0000000), 255, 0, 0, true);
        return true;        
    }
    else
    {
        return false;
    }
    return false;
    //return ReturnValue;    
}

function int GetBestStrafeByDirectionIndex(optional delegate<RateStrafe> RateStrafeDelegate = OnRateStrafe, optional Actor InFocus, optional float StrafeDistance = 500.0000000)
{
    return GetBestStrafeIndex(StrafesData, RateStrafeDelegate, InFocus, StrafeDistance);
    //return ReturnValue;    
}

function int GetBestStrafeIndex(out array<EvilStrafeData> InStrafeData, optional delegate<RateStrafe> RateStrafeDelegate = OnRateStrafe, optional Actor InFocus, optional float StrafeDistance = 500.0000000)
{
    local EvilStrafeData StrafeDataElement;
    local float BestRating;
    local int I;
    local array<int> BestRatingIndexes;
    local int BestIndex;

    BestIndex = -1;
    BestRating = StrafeRatingThreshold;
    // End:0x5B
    if(InStrafeData.Length == 0)
    {
        return BestIndex;
    }
    CalculateStrafePointsRating(InStrafeData, RateStrafeDelegate, InFocus, StrafeDistance);
    // End:0x17A
    foreach InStrafeData(StrafeDataElement, I)
    {
        // End:0x127
        if(StrafeDataElement.Rating > BestRating)
        {
            BestRatingIndexes.Remove(0, BestRatingIndexes.Length);            
            BestRating = StrafeDataElement.Rating;
            BestRatingIndexes.AddItem(I);                        
        }
        else
        {
            // End:0x179
            if((BestRatingIndexes.Length > 0) && StrafeDataElement.Rating == BestRating)
            {
                BestRatingIndexes.AddItem(I);                
            }
        }        
    }    
    // End:0x1AB
    if(BestRatingIndexes.Length > 0)
    {
        BestIndex = BestRatingIndexes[Rand(BestRatingIndexes.Length)];
    }
    return BestIndex;
    //return ReturnValue;    
}

function bool CheckStrafePointReachability(Vector StrafePoint)
{
    // End:0x59
    if((!HasCombatZones() || IsLocationInCombatZones(StrafePoint)) && NavigationHandle.PointReachable(StrafePoint))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function Vector GetStrafePointByAngle(float StrafeAngle, float StrafeDistance, optional float StrafeAngleOffset, optional Actor InFocus)
{
    local Vector Z, StrafeDir, StrafePoint;
    local Rotator StrafeBaseRotation, StrafeRotation;

    // End:0x3C
    if(InFocus == none)
    {
        StrafeBaseRotation = MyEvilPawn.Rotation;        
    }
    else
    {
        StrafeBaseRotation = Rotator(Normal(InFocus.Location - MyEvilPawn.Location));
    }
    Z = GetRotatorAxis(StrafeBaseRotation, 2);
    StrafeRotation = QuatToRotator(QuatFromAxisAndAngle(Z, StrafeAngle + RandRange(-StrafeAngleOffset, StrafeAngleOffset))) + StrafeBaseRotation;
    StrafeDir = Normal(Vector(StrafeRotation));
    StrafePoint = MyEvilPawn.Location + (StrafeDir * StrafeDistance);
    return StrafePoint;
    //return ReturnValue;    
}

function Vector GetStrafePointByDirection(EvilTypesNative.EStrafeDirection StrafeDirection, float StrafeDistance, optional float StrafeAngleOffset, optional Actor InFocus)
{
    local Vector StrafePoint;

    switch(StrafeDirection)
    {
        // End:0x62
        case 1:
            StrafePoint = GetStrafePointByAngle(RandRange(-3.1415930, 3.1415930), StrafeDistance, StrafeAngleOffset, InFocus);
            // End:0x160
            break;
        // End:0xA5
        case 2:
            StrafePoint = GetStrafePointByAngle(-0.5000000 * 3.1415930, StrafeDistance, StrafeAngleOffset, InFocus);
            // End:0x160
            break;
        // End:0xE8
        case 3:
            StrafePoint = GetStrafePointByAngle(0.5000000 * 3.1415930, StrafeDistance, StrafeAngleOffset, InFocus);
            // End:0x160
            break;
        // End:0x124
        case 4:
            StrafePoint = GetStrafePointByAngle(3.1415930, StrafeDistance, StrafeAngleOffset, InFocus);
            // End:0x160
            break;
        // End:0x15D
        case 5:
            StrafePoint = GetStrafePointByAngle(0.0000000, StrafeDistance, StrafeAngleOffset, InFocus);
        // End:0xFFFF
        default:
            break;
    }
    return StrafePoint;
    //return ReturnValue;    
}

function bool DoStrafeByAngle(float StrafeAngle, float StrafeDistance, optional float StrafeAngleOffset)
{
    local Vector StrafePoint;

    StrafePoint = GetStrafePointByAngle(StrafeAngle, StrafeDistance, StrafeAngleOffset);
    return (CanStrafe(StrafePoint)) && DoStrafe(StrafePoint, true);
    //return ReturnValue;    
}

function bool DoStrafeByDirection(EvilTypesNative.EStrafeDirection StrafeDirection, float StrafeDistance, optional float StrafeAngleOffset, optional Actor InFocus)
{
    local Vector StrafePoint;

    StrafePoint = GetStrafePointByDirection(StrafeDirection, StrafeDistance, StrafeAngleOffset, InFocus);
    return DoStrafe(StrafePoint, true, InFocus);
    //return ReturnValue;    
}

function bool DoStrafe(optional Vector StrafePoint, optional bool bOverrideStrafePoint, optional Actor InFocus)
{
    local bool bResult;

    InvalidateCoverAction();
    InvalidateCover();
    // End:0x3C
    if(InFocus != none)
    {
        Focus = InFocus;
    }
    // End:0x87
    if(!bOverrideStrafePoint && !StrafeCommand.static.GetStrafePoint(self, StrafePoint))
    {
        bResult = false;
    }
    // End:0xC0
    if(StrafeCommand.static.Strafe(self, false, StrafePoint))
    {
        bResult = true;
    }
    // End:0xE0
    if(bResult)
    {
        StrafeRatingThreshold = default.StrafeRatingThreshold;
    }
    return bResult;
    //return ReturnValue;    
}

function DoChargeAttack(optional Pawn NewEnemy)
{
    // End:0x23
    if(NewEnemy != none)
    {
        SetEnemy(NewEnemy);
    }
    Class'EvilAICmd_Attack_Charge'.static.Charge(self);
    //return;    
}

function Rotator GetAdjustedAimRotation(Vector EndPoint, Vector StartPoint)
{
    local Vector Vel, RealEndPoint;
    local class<EvilProjectile_Base> EvilProjClass;
    local float Spread;

    // End:0xE1
    if((MyEvilPawn.Weapon != none) && int(MyEvilPawn.Weapon.WeaponFireTypes[int(MyEvilPawn.Weapon.CurrentFireMode)]) == int(1))
    {
        EvilProjClass = class<EvilProjectile_Base>(MyEvilPawn.Weapon.GetProjectileClass());
    }
    // End:0x363
    if(EvilProjClass != none)
    {
        Spread = MyEvilPawn.Weapon.Spread[int(MyEvilPawn.Weapon.CurrentFireMode)];
        RealEndPoint = EndPoint - (((vect(0.0000000, 0.0000000, 1.0000000) * ProjectileAimHeightModifier) * MyEvilPawn.GetCollisionHeight()) - (vect(0.0000000, 0.0000000, 0.0000000) * MyEvilPawn.GetCollisionRadius()));
        RealEndPoint = RealEndPoint - ((vect(0.0000000, 0.0000000, 1.0000000) * RandRange(-Spread, Spread)) * MyEvilPawn.GetCollisionHeight());
        RealEndPoint = RealEndPoint - ((vect(0.0000000, 1.0000000, 0.0000000) * RandRange(-Spread, Spread)) * MyEvilPawn.GetCollisionRadius());
        CalculateMinSpeedTrajectory(Vel, RealEndPoint, StartPoint, EvilProjClass.default.MaxSpeed, EvilProjClass.default.Speed,, EvilProjClass.default.TerminalVelocity, EvilProjClass.default.CustomGravityScaling * (GetGravityZ()), true);
        return Rotator(Normal(Vel));        
    }
    else
    {
        return Rotator(Normal(EndPoint - StartPoint));
    }
    //return ReturnValue;    
}

function Rotator GetAimRotation(out EvilTypes.EAimZone InAimZone, optional Actor InTarget)
{
    local Rotator RetAimRotation, DeltaRot;
    local Vector StartTraceLocation;

    // End:0x35
    if(Pawn(InTarget) != none)
    {
        ShotTarget = Pawn(InTarget);
    }
    // End:0x6C
    if(ShotTarget != none)
    {
        ShotTargetActor = ShotTarget.DrivenVehicle;
    }
    // End:0xDF
    if(int(InAimZone) != int(0))
    {
        // End:0x9E
        if(ShotTargetActor != none)
        {
            InAimZone = 1;            
        }
        else
        {
            // End:0xDF
            if((ShotTarget == none) || !ShotTarget.IsAliveAndWell())
            {
                InAimZone = 0;
            }
        }
    }
    // End:0x3CE
    if(((int(MyEvilPawn.PawnAction) == 0) || MyEvilPawn.PawnActions[int(MyEvilPawn.PawnAction)] == none) || !MyEvilPawn.PawnActions[int(MyEvilPawn.PawnAction)].AimOffsetOverride(DeltaRot))
    {
        StartTraceLocation = MyEvilPawn.GetWeaponStartTraceLocation();
        // End:0x280
        if(!MyEvilPawn.IsInCover())
        {
            StartTraceLocation -= ((Normal(Vector(MyEvilPawn.GetAdjustedAimFor(MyEvilPawn.Weapon, vect(0.0000000, 0.0000000, 0.0000000)))) * MyEvilPawn.GetCollisionRadius()) * 2.0000000);
        }
        switch(InAimZone)
        {
            // End:0x2C3
            case 0:
                RetAimRotation = MyEvilPawn.Rotation;
                // End:0x3CB
                break;
            // End:0x335
            case 1:
                RetAimRotation = GetAdjustedAimRotation(((ShotTargetActor != none) ? ShotTargetActor.Location : ShotTarget.Location), StartTraceLocation);
                // End:0x3CB
                break;
            // End:0x398
            case 2:
                RetAimRotation = GetAdjustedAimRotation(ShotTarget.Mesh.GetBoneLocation('Head', 0), StartTraceLocation);
                // End:0x3CB
                break;
            // End:0x3C8
            case 3:
                RetAimRotation = MyEvilPawn.AimRotation;
                // End:0x3CB
                break;
            // End:0xFFFF
            default:
                break;
        }        
    }
    else
    {
        RetAimRotation = Normalize(RetAimRotation + DeltaRot);
    }
    return RetAimRotation;
    //return ReturnValue;    
}

function float GetMaxAimAngle()
{
    // End:0x28
    if(MyEvilPawn.IsRidingRailCar())
    {
        return 360.0000000;
    }
    switch(MyEvilPawn.CurrentMoveMode)
    {
        // End:0x55
        case 3:
        // End:0x63
        case 2:
            return 30.0000000;
            // End:0x66
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0xAF
    if(MyEvilPawn.IsBlindFiring(MyEvilPawn.CoverAction))
    {
        return 0.0000000;        
    }
    else
    {
        return 90.0000000;
    }
    //return ReturnValue;    
}

function UpdateAim(float DeltaTime, optional EvilTypes.EAimZone InAimZone = 0)
{
    local EvilTypes.EAimZone SavedAimZone;
    local int YawDelta;

    SavedAimZone = MyEvilPawn.CurrentAimZone;
    MyEvilPawn.AimRotation = GetAimRotation(InAimZone);
    // End:0xE8
    if((!MyEvilPawn.IsInCover() && HasValidEnemy()) && (WorldInfo.TimeSeconds - GetEnemyInfo().LastSeenTime) > float(1))
    {
        InAimZone = 3;
    }
    // End:0x220
    if(((((ShotTarget == none) && ShotTargetActor == none) || int(InAimZone) == int(0)) || Abs(RDiff(MyEvilPawn.AimRotation, MyEvilPawn.Rotation)) > (GetMaxAimAngle())) || MyEvilPawn.FullBodyAnimSlot.bIsPlayingCustomAnim && !MyEvilPawn.bAimWhenFullBodySlotAnim)
    {
        // End:0x214
        if(IsFiring())
        {
            // End:0x211
            if(!bShouldStopFiringWithLag)
            {
                MyEvilPawn.OnStopFireWithLag();
            }            
        }
        else
        {
            InAimZone = 0;
        }
    }
    MyEvilPawn.AimRotation = GetAimRotation(InAimZone);
    MyEvilPawn.CurrentAimZone = InAimZone;
    YawDelta = Rotator(GetRotatorAxis(MyEvilPawn.AimRotation, 0)).Yaw - Rotator(GetRotatorAxis(MyEvilPawn.Rotation, 0)).Yaw;
    // End:0x448
    if(((MyEvilPawn.IsRidingRailCar() && !IsTransitioning()) && !IsFiring()) && int(MyEvilPawn.PawnAction) == 0)
    {
        // End:0x3DE
        if((YawDelta < 15000) && YawDelta > -15000)
        {
            // End:0x3DB
            if(!MyEvilPawn.bIsMirrored)
            {
                MyEvilPawn.SetMirroredSide(true);
            }            
        }
        else
        {
            // End:0x448
            if((YawDelta > 17384) || YawDelta < -17384)
            {
                // End:0x448
                if(MyEvilPawn.bIsMirrored)
                {
                    MyEvilPawn.SetMirroredSide(false);
                }
            }
        }
    }
    // End:0x4CB
    if(int(SavedAimZone) != int(MyEvilPawn.CurrentAimZone))
    {
        ReactionManager.NudgeChannel(self, GetEnum(Enum'EvilTypes.EAimZone', int(MyEvilPawn.CurrentAimZone)));
    }
    //return;    
}

simulated function StartThrowAttack()
{
    // End:0x2E
    if(MyEvilPawn != none)
    {
        MyEvilPawn.StartThrowAttack();
    }
    //return;    
}

simulated function bool StartDodge()
{
    // End:0x31
    if(MyEvilPawn != none)
    {
        return MyEvilPawn.TryStartDodge(0);
    }
    return false;
    //return ReturnValue;    
}

simulated function StartMeleeAttack()
{
    // End:0x2E
    if(MyEvilPawn != none)
    {
        MyEvilPawn.StartMeleeAttack();
    }
    //return;    
}

simulated function StartChargeAttack()
{
    // End:0x2E
    if(MyEvilPawn != none)
    {
        MyEvilPawn.StartChargeAttack();
    }
    //return;    
}

simulated function StartShootAttack()
{
    // End:0x2E
    if(MyEvilPawn != none)
    {
        MyEvilPawn.StartShootAttack();
    }
    //return;    
}

simulated function StopShootAttack()
{
    // End:0x2E
    if(MyEvilPawn != none)
    {
        MyEvilPawn.StopShootAttack();
    }
    //return;    
}

simulated function StartAimToThrow()
{
    //return;    
}

simulated function OnStartAim()
{
    //return;    
}

simulated function OnStopAim()
{
    ReactionManager.NudgeChannel(self, 'AbortedAiming');
    //return;    
}

function NotifyStopBurn()
{
    //return;    
}

function NotifyStartBurn(float InTotalTime, float InDamageInterval, float InFDamageAmount)
{
    // End:0x2D
    if(CanStartBurnBehaviour())
    {
        BeginCombatCommand(BurningCommand, string(GetFuncName()), true);
    }
    // End:0x50
    if(InFDamageAmount > 0.0000000)
    {
        InvalidateCover();        
    }
    else
    {
        InvalidateCoverAction();
    }
    //return;    
}

simulated function NotifyFaceFXAudioFinished(AudioComponent AC)
{
    local AICharacterInfo TempFriendInfo, FriendInfo;
    local int I;

    // End:0xBA
    foreach FriendInfoList(TempFriendInfo)
    {
        // End:0xB9
        if((int(TempFriendInfo.LastHearMeSoundSetType) != int(0)) && (int(FriendInfo.LastHearMeSoundSetType) == int(0)) || TempFriendInfo.LastHearMeTime > FriendInfo.LastHearMeTime)
        {
            FriendInfo = TempFriendInfo;
        }        
    }    
    // End:0x11F
    if(int(FriendInfo.LastHearMeSoundSetType) != int(0))
    {
        MyEvilPawn.PlaySoundFromArchetypeByChance(FriendInfo.LastHearMeSoundSetType, true);
    }
    // End:0x168
    foreach FriendInfoList(TempFriendInfo, I)
    {
        FriendInfoList[I].LastHearMeSoundSetType = 0;        
    }    
    //return;    
}

function NoticedEnemy(Pawn InEnemy)
{
    // End:0x52
    if(Enemy == none)
    {
        // End:0x2F
        if(int(CurrentBehaviorMode) == int(1))
        {
            ChangeBehaviorMode(2);
        }
        MyEvilPawn.PlaySoundFromArchetypeByChance(4);
    }
    CheckCombatTransition();
    //return;    
}

function bool IsAttacking()
{
    return ((EvilAICmd_Base_Melee(CommandList) != none) || IsFiring()) || IsAiming();
    //return ReturnValue;    
}

function NotifyMoveModeChanged(EvilTypesNative.EMoveMode InNewMode, EvilTypesNative.EMoveMode InOldMode)
{
    // End:0x7D
    if((IsFiring()) || IsAiming())
    {
        MyEvilPawn.ToggleAimingAnimMode(((!IsInState('Combat') && Enemy == none) && ShotTarget == none) && ShotTargetActor == none);
    }
    switch(InNewMode)
    {
        // End:0x98
        case 0:
            // End:0xAB
            break;
        // End:0xA0
        case 1:
            // End:0xAB
            break;
        // End:0xA8
        case 2:
            // End:0xAB
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

function WarnProjExplode(Projectile Proj)
{
    ReactionManager.NudgeChannel(Proj, 'WarnProjExplode');
    super(Controller).WarnProjExplode(Proj);
    //return;    
}

simulated event NotifyProjectileFire(Projectile Proj)
{
    //return;    
}

simulated event NotifyProjectileExplode(Projectile Proj)
{
    //return;    
}

function NotifyKilled(Controller Killer, Controller Killed, Pawn KilledPawn, class<DamageType> damageTyp)
{
    super(Controller).NotifyKilled(Killer, Killed, KilledPawn, damageTyp);
    // End:0x83
    if(CanPlayKilledEnemy(Killer, Killed, KilledPawn, damageTyp))
    {
        MyEvilPawn.PlayKilledEnemy(1.0000000);
    }
    // End:0xEB
    if(Killed.bIsPlayer)
    {
        ReactionManager.NudgeChannel(Killed.Pawn, 'PlayerKilled');
    }
    GetAIEnemyInfoIdx(none);
    //return;    
}

function bool CanPlayKilledEnemy(Controller Killer, Controller Killed, Pawn KilledPawn, class<DamageType> damageTyp)
{
    return Killer == self;
    //return ReturnValue;    
}

function NotifyFullBodyHit(Controller InstigatedBy)
{
    //return;    
}

function NotifyDoMeleeDamageHit()
{
    MyEvilPawn.PlayMeleeAttackHitSound();
    //return;    
}

function NotifyDoMeleeDamageMissed()
{
    //return;    
}

function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum)
{
    local TraceHitInfo HitInfo;
    local int EnemyIdx;

    // End:0x246
    if(InstigatedBy != none)
    {
        // End:0x1FF
        if(!IsFriendlyPawn(InstigatedBy.Pawn) && int(InstigatedBy.GetTeamNum()) != int(GetTeamNum()))
        {
            super(Controller).NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
            ReactionManager.IncomingDamage(InstigatedBy.Pawn, true, DamageType, HitInfo, InstigatedBy.Pawn.Location, Damage);
            ProcessStimulus(InstigatedBy.Pawn, 2);
            // End:0x1FC
            if(InstigatedBy.Pawn != none)
            {
                EnemyIdx = GetAIEnemyInfoIdx(InstigatedBy.Pawn);
                // End:0x1FC
                if(EnemyIdx != -1)
                {
                    EnemyInfoList[EnemyIdx].GivenDamageToMe += float(Damage);
                }
            }            
        }
        else
        {
            // End:0x246
            if(int(InstigatedBy.GetTeamNum()) == int(MyEvilPawn.GetTeamNum()))
            {
            }
        }
    }
    //return;    
}

event HearNoise(float Loudness, Actor NoiseMaker, optional name NoiseType)
{
    local EvilPawn Heard;

    super(Controller).HearNoise(Loudness, NoiseMaker, NoiseType);
    // End:0x72
    if(EvilAIController(NoiseMaker) != none)
    {
        Heard = EvilAIController(NoiseMaker).MyEvilPawn;        
    }
    else
    {
        // End:0xA9
        if(EvilPawn(NoiseMaker) != none)
        {
            Heard = EvilPawn(NoiseMaker);            
        }
        else
        {
            // End:0x10A
            if(EvilPawn(NoiseMaker.Owner) != none)
            {
                Heard = EvilPawn(NoiseMaker.Owner);                
            }
            else
            {
                // End:0x168
                if(EvilPawn(NoiseMaker.Instigator) != none)
                {
                    Heard = EvilPawn(NoiseMaker.Instigator);
                }
            }
        }
    }
    // End:0x1C0
    if((Heard != none) && CanHearPawn(Heard, Loudness, NoiseType))
    {
        ProcessStimulus(Heard, 1, NoiseType);
    }
    //return;    
}

function bool CanHearPawn(Pawn Heard, float Loudness, name NoiseType)
{
    local float DistSq;
    local int HearReplyFlag;
    local EvilTypes.ESoundSetType SoundSetType;
    local EvilSoundSetNoiseInfo SoundSetNoiseInfo;

    DistSq = VSizeSq(Pawn.Location - Heard.Location);
    // End:0x88
    if(NoiseType == 'NOISETYPE_FootStep')
    {
        // End:0x85
        if(DistSq > (EnemyDistance_HearFootSteps * EnemyDistance_HearFootSteps))
        {
            return false;
        }        
    }
    else
    {
        // End:0x19B
        if(MyEvilPawn.GetSoundSetTypeFromString(NoiseType, SoundSetType, HearReplyFlag))
        {
            MyEvilPawn.SoundGroupClass.static.GetSoundSetNoiseInfo(MyEvilPawn, SoundSetType, ((HearReplyFlag > -1) ? true : false), SoundSetNoiseInfo);
            // End:0x19B
            if((SoundSetNoiseInfo.Range > float(0)) && DistSq > (SoundSetNoiseInfo.Range * SoundSetNoiseInfo.Range))
            {
                return false;
            }
        }
    }
    return true;
    //return ReturnValue;    
}

function float ModifyGameIntensity()
{
    local AICharacterInfo EnemyInfo;
    local float Modifier;

    Modifier = 1.0000000;
    // End:0x5C
    if(GetCurrentEnemyInfo(EnemyInfo))
    {
        // End:0x5C
        if(EnemyInfo.DistanceToEnemy < float(500))
        {
            Modifier = 1.5000000;
        }
    }
    return Modifier;
    //return ReturnValue;    
}

simulated function bool IsWeaponAimingAt(Actor ATarget, float Epsilon)
{
    local Vector Loc;
    local Rotator Rot;
    local Vector l1, l2;
    local Rotator r1, r2;

    GetPlayerViewPoint(Loc, Rot);
    // End:0x84
    if(VSizeSq(ATarget.Location - MyEvilPawn.GetWeaponStartTraceLocation()) < MyEvilPawn.GetCollisionRadius())
    {
        return true;
    }
    r1 = MyEvilPawn.GetAdjustedAimFor(MyEvilPawn.Weapon, vect(0.0000000, 0.0000000, 0.0000000));
    r2 = Rotator(ATarget.Location - MyEvilPawn.GetWeaponStartTraceLocation());
    r1.Pitch = 0;
    r2.Pitch = 0;
    r1.Roll = 0;
    r2.Roll = 0;
    l1 = Vector(r1);
    l2 = Vector(r2);
    return (l1 Dot l2) >= Epsilon;
    //return ReturnValue;    
}

function bool IsTransitioning()
{
    return false;
    //return ReturnValue;    
}

function bool IsPawnOnTheSameCourse(EvilPawn EP, float Epsilon, optional out float oEpsilon)
{
    oEpsilon = Normal(EP.Velocity) Dot Normal(EP.Location - MyEvilPawn.Location);
    return oEpsilon >= Epsilon;
    //return ReturnValue;    
}

simulated function bool IsAimingAtPoint(Vector Target, float Epsilon, optional out float oEpsilon)
{
    local Vector Loc;
    local Rotator Rot;

    GetPlayerViewPoint(Loc, Rot);
    oEpsilon = Normal(Target - Loc) Dot Vector(Rot);
    return oEpsilon >= Epsilon;
    //return ReturnValue;    
}

function bool IsCoverExposedToAnEnemy(CoverInfo TestCover, optional Pawn TestEnemy, optional out float out_ExposedScale, optional out float out_MajorExposedScale, optional bool bCountRangedAttackAsMajor = false)
{
    local int I;
    local float ExposedScale;
    local Vector TestCoverSlotLocation, TestCoverSlotRotationNormal;

    TestCoverSlotLocation = TestCover.Link.GetSlotLocation(TestCover.SlotIdx);
    TestCoverSlotRotationNormal = Normal(Vector(TestCover.Link.GetSlotRotation(TestCover.SlotIdx)));
    out_ExposedScale = -1.0000000;
    // End:0x29E
    if(EnemyInfoList.Length > 0)
    {
        I = 0;
        J0xE8:

        // End:0x29B [Loop If]
        if(I < EnemyInfoList.Length)
        {
            // End:0x28D
            if(((TestEnemy == none) && EnemyInfoList[I].Pawn != none) || (TestEnemy != none) && EnemyInfoList[I].Pawn == TestEnemy)
            {
                ExposedScale = TestCoverSlotRotationNormal Dot Normal(TestCoverSlotLocation - EnemyInfoList[I].KnownLocation);
                // End:0x263
                if((Enemy == EnemyInfoList[I].Pawn) || bCountRangedAttackAsMajor && EnemyInfoList[I].Pawn.HasRangedAttack())
                {
                    out_MajorExposedScale = ExposedScale;
                }
                // End:0x28D
                if(ExposedScale > out_ExposedScale)
                {
                    out_ExposedScale = ExposedScale;
                }
            }
            I++;
            // [Loop Continue]
            goto J0xE8;
        }        
    }
    else
    {
        return false;
    }
    return out_MajorExposedScale > -0.5000000;
    //return ReturnValue;    
}

function float GetPawnSpotChance(Pawn Seen)
{
    local float SpotChance;

    SpotChance = FClamp(1.0000000 - FPctByRange(VSizeSq(Seen.Location - MyEvilPawn.Location), SightSenseDistanceThreshold * SightSenseDistanceThreshold, MyEvilPawn.SightRadius * MyEvilPawn.SightRadius), 0.0000000, 1.0000000) ** float(100);
    return SpotChance;
    //return ReturnValue;    
}

event SeeMonster(Pawn Seen)
{
    // End:0x4A
    if((Enemy == Seen) || FRand() < (GetPawnSpotChance(Seen)))
    {
        ProcessStimulus(Seen, 0);
    }
    //return;    
}

event SeePlayer(Pawn Seen)
{
    super(Controller).SeePlayer(Seen);
    // End:0x60
    if((Enemy == Seen) || FRand() < (GetPawnSpotChance(Seen)))
    {
        ProcessStimulus(Seen, 0);        
    }
    //return;    
}

function HandleExecuteTest(Actor EventInstigator, EvilAIReactChannel OrigChannel)
{
    //return;    
}

function BeginStumbleWrapper(Actor EventInstigator, EvilAIReactChannel OrigChannel)
{
    BeginStumble();
    //return;    
}

function BeginStumble()
{
    MyEvilPawn.bShouldBeginStumble = true;
    //return;    
}

function AutoAcquireEnemy()
{
    local Controller PotentialEnemy;

    // End:0xBA
    foreach WorldInfo.AllControllers(Class'Engine.Controller', PotentialEnemy)
    {
        // End:0xB9
        if((PotentialEnemy != self) && PotentialEnemy.Pawn != none)
        {
            // End:0xB9
            if(!IsFriendly(PotentialEnemy))
            {
                ProcessStimulus(PotentialEnemy.Pawn, 3, GetFuncName());
                // End:0xB9
                continue;
            }
        }        
    }    
    //return;    
}

function bool HasValidEnemy()
{
    local bool bResult;

    bResult = ((Enemy != none) && (EvilPawn(Enemy) == none) || !EvilPawn(Enemy).bIsWounded) && !IsFriendlyPawn(Enemy);
    return bResult;
    //return ReturnValue;    
}

function bool HasValidTarget(optional Actor TestTarget)
{
    // End:0x23
    if(TestTarget == none)
    {
        TestTarget = ShotTarget;
    }
    // End:0x34
    if(TestTarget == none)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function bool SelectTarget()
{
    // End:0x23
    if(SelectEnemy())
    {
        ShotTarget = Enemy;        
    }
    else
    {
        ShotTarget = none;
    }
    return ShotTarget != none;
    //return ReturnValue;    
}

function bool SelectEnemy()
{
    local AICharacterInfo EI;
    local Pawn Selected;
    local float EnemyRating, TempRating;
    local int Index;

    // End:0x1ED
    foreach EnemyInfoList(EI)
    {
        // End:0x1EC
        if(EI.Pawn != none)
        {
            // End:0x176
            if(EI.bUpdateRating)
            {
                TempRating = GetEnemyRating(EI.Pawn, EI.DistanceToEnemy);
                TempRating = TempRating * EI.RatingModifier;
                EI.Rating = FMin(TempRating, 1.0000000);
                Index = GetAIEnemyInfoIdx(EI.Pawn);
                EnemyInfoList[Index].Rating = EI.Rating;
            }
            // End:0x1EC
            if(EI.Rating > EnemyRating)
            {
                Selected = EI.Pawn;
                EnemyRating = EI.Rating;
            }
        }        
    }    
    // End:0x213
    if(Selected != none)
    {
        SetEnemy(Selected);        
    }
    else
    {
        SetEnemy(none);
    }
    return HasValidEnemy();
    //return ReturnValue;    
}

final function bool HasAnyEnemies()
{
    return EnemyInfoList.Length > 0;
    //return ReturnValue;    
}

function SetEnemy(Pawn InEnemy)
{
    // End:0x19
    if(InEnemy == Enemy)
    {
        return;
    }
    Enemy = InEnemy;
    //return;    
}

function int AddFriend(Pawn InFriend)
{
    local int Idx;
    local AICharacterInfo NewFriendInfo;

    Idx = GetAIFriendInfoIdx(InFriend);
    // End:0xC9
    if((Idx == -1) && MyEvilPawn != InFriend)
    {
        NewFriendInfo.Pawn = EvilPawn(InFriend);
        NewFriendInfo.LastSeenTime = WorldInfo.TimeSeconds;
        FriendInfoList.AddItem(NewFriendInfo);        
    }
    return Idx;
    //return ReturnValue;    
}

function int AddEnemy(Pawn InEnemy)
{
    local int Idx;
    local AICharacterInfo NewEnemyInfo;

    Idx = GetAIEnemyInfoIdx(InEnemy);
    // End:0xD5
    if(Idx == -1)
    {
        NewEnemyInfo.Pawn = EvilPawn(InEnemy);
        NewEnemyInfo.LastSeenTime = WorldInfo.TimeSeconds;
        EnemyInfoList.AddItem(NewEnemyInfo);        
        ProcessStimulus(InEnemy, 3, 'AddEnemy');
        return -1;
    }
    return Idx;
    //return ReturnValue;    
}

function int GetAIFriendInfoIdx(Pawn InFriend)
{
    local int Idx;

    Idx = 0;
    J0x0B:

    // End:0x10E [Loop If]
    if(Idx < FriendInfoList.Length)
    {
        // End:0xC2
        if((FriendInfoList[Idx].Pawn == none) || !FriendInfoList[Idx].Pawn.IsAliveAndWell())
        {
            FriendInfoList.Remove(Idx--, 1);            
            // End:0xBF
            if(FriendInfoList.Length > 0)
            {
                goto J0x100;                
            }
            else
            {
                // [Explicit Break]
                goto J0x10E;
            }
        }
        // End:0x100
        if(FriendInfoList[Idx].Pawn == InFriend)
        {
            return Idx;
        }
        J0x100:

        ++Idx;
        // [Loop Continue]
        goto J0x0B;
    }
    J0x10E:

    return -1;
    //return ReturnValue;    
}

function int GetAIEnemyInfoIdx(Pawn InEnemy)
{
    local int Idx;

    Idx = 0;
    J0x0B:

    // End:0x14D [Loop If]
    if(Idx < EnemyInfoList.Length)
    {
        // End:0x101
        if((EnemyInfoList[Idx].Pawn == none) || !EnemyInfoList[Idx].Pawn.IsAliveAndWell())
        {
            // End:0xD1
            if(Enemy == EnemyInfoList[Idx].Pawn)
            {
                SetEnemy(none);
            }
            EnemyInfoList.Remove(Idx--, 1);            
            // End:0xFE
            if(EnemyInfoList.Length > 0)
            {
                goto J0x13F;                
            }
            else
            {
                // [Explicit Break]
                goto J0x14D;
            }
        }
        // End:0x13F
        if(EnemyInfoList[Idx].Pawn == InEnemy)
        {
            return Idx;
        }
        J0x13F:

        ++Idx;
        // [Loop Continue]
        goto J0x0B;
    }
    J0x14D:

    return -1;
    //return ReturnValue;    
}

function AICharacterInfo GetEnemyInfo(optional Pawn InEnemy)
{
    local int Idx;
    local AICharacterInfo EnemyInfo;

    // End:0x32
    if(InEnemy == none)
    {
        // End:0x32
        if(Enemy != none)
        {
            InEnemy = Enemy;
        }
    }
    Idx = LastActiveEnemyIndex;
    // End:0xC1
    if(((Idx < 0) || Idx >= EnemyInfoList.Length) || EnemyInfoList[Idx].Pawn != InEnemy)
    {
        Idx = GetAIEnemyInfoIdx(InEnemy);
    }
    // End:0x117
    if(Idx > -1)
    {
        EnemyInfo = EnemyInfoList[Idx];
        LastActiveEnemyInfo = EnemyInfo;
        LastActiveEnemyIndex = Idx;
    }
    return EnemyInfo;
    //return ReturnValue;    
}

function bool GetCurrentEnemyInfo(out AICharacterInfo OutInfo)
{
    local int Idx;

    // End:0x11
    if(Enemy == none)
    {
        return false;
    }
    Idx = LastActiveEnemyIndex;
    // End:0xA0
    if(((Idx < 0) || Idx >= EnemyInfoList.Length) || EnemyInfoList[Idx].Pawn != Enemy)
    {
        Idx = GetAIEnemyInfoIdx(Enemy);
    }
    // End:0xB5
    if(Idx == -1)
    {
        return false;
    }
    OutInfo = EnemyInfoList[Idx];
    LastActiveEnemyInfo = OutInfo;
    LastActiveEnemyIndex = Idx;
    return true;
    //return ReturnValue;    
}

function UpdateEnemyCharacterInfo(Pawn P, EvilTypes.EPerceptionType Pt, name EventName, int PawnListIndex)
{
    // End:0x19
    if(P == MyEvilPawn)
    {
        return;
    }
    switch(Pt)
    {
        // End:0x76
        case 0:
            EnemyInfoList[PawnListIndex].LastSeenTime = WorldInfo.TimeSeconds;
        // End:0x7B
        case 2:
        // End:0x80
        case 3:
        // End:0xC3
        case 1:
            UpdateEnemyInfo(PawnListIndex, P, P.GetPawnViewLocation());
            // End:0xC6
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

function UpdateFriendlyCharacterInfo(Pawn P, EvilTypes.EPerceptionType Pt, name EventName, int PawnListIndex)
{
    local EvilTypes.ESoundSetType HearSoundSetType;
    local int HearReplyFlag;

    // End:0x19
    if(P == MyEvilPawn)
    {
        return;
    }
    switch(Pt)
    {
        // End:0xC6
        case 1:
            // End:0xC3
            if(MyEvilPawn.GetSoundSetTypeFromString(EventName, HearSoundSetType, HearReplyFlag) && HearReplyFlag < 0)
            {
                UpdateFriendInfo(PawnListIndex, P, P.GetPawnViewLocation(), HearSoundSetType);
            }
            // End:0xC9
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

function GetFriendsLocations(out array<Vector> FriendsLocations)
{
    local EvilAIController EAI;

    // End:0x75
    foreach WorldInfo.AllControllers(Class'EvilAIController', EAI)
    {
        FriendsLocations.AddItem(EAI.MyEvilPawn.Location);                
    }    
    //return;    
}

function UpdateFriendInfo(int FriendIdx, Pawn InFriend, Vector InViewLocation, optional EvilTypes.ESoundSetType InHearMeType)
{
    FriendInfoList[FriendIdx].Pawn = EvilPawn(InFriend);
    FriendInfoList[FriendIdx].KnownLocation = InViewLocation;
    // End:0xF3
    if(int(InHearMeType) != int(0))
    {
        FriendInfoList[FriendIdx].LastHearMeSoundSetType = InHearMeType;
        FriendInfoList[FriendIdx].LastHearMeTime = WorldInfo.TimeSeconds;
    }
    //return;    
}

function RestoreEnemyInfo()
{
    //return;    
}

function UpdateEnemyInfo(int EnemyIdx, Pawn InEnemy, Vector InViewLocation)
{
    EnemyInfoList[EnemyIdx].Pawn = ((Vehicle(InEnemy) != none) ? EvilPawn(Vehicle(InEnemy).Driver) : EvilPawn(InEnemy));
    EnemyInfoList[EnemyIdx].KnownLocation = InViewLocation;
    EnemyInfoList[EnemyIdx].DistanceToEnemy = VSize(Pawn.Location - InViewLocation);
    EnemyInfoList[EnemyIdx].LastUpdateTime = WorldInfo.TimeSeconds;
    EnemyInfoList[EnemyIdx].bInitialized = true;
    // End:0x27B
    if(EnemyInfoList[EnemyIdx].Pawn != none)
    {
        EnemyInfoList[EnemyIdx].Controller = EvilAIController(InEnemy.Controller);
        EnemyInfoList[EnemyIdx].LastKnownVelocity = EnemyInfoList[EnemyIdx].Pawn.Velocity;
        EnemyInfoList[EnemyIdx].bUpdateRating = true;        
    }
    else
    {
        EnemyInfoList[EnemyIdx].Controller = none;
        EnemyInfoList[EnemyIdx].LastKnownVelocity = vect(0.0000000, 0.0000000, 0.0000000);
        EnemyInfoList[EnemyIdx].Rating = 0.0000000;
        EnemyInfoList[EnemyIdx].bUpdateRating = false;
    }
    //return;    
}

function bool HasEnemyWithinDistance(float Distance, optional out Pawn OutEnemy, optional float MinimalDistance, optional bool bAnyEnemy = true)
{
    local AICharacterInfo EI;
    local float DistanceToEnemySq;

    // End:0x133
    foreach EnemyInfoList(EI)
    {
        // End:0x132
        if(EI.Pawn != none)
        {
            DistanceToEnemySq = VSizeSq(EI.Pawn.Location - Pawn.Location);
            // End:0x132
            if((DistanceToEnemySq < (Distance * Distance)) && DistanceToEnemySq > (MinimalDistance * MinimalDistance))
            {
                OutEnemy = EI.Pawn;
                // End:0x132
                if(bAnyEnemy || OutEnemy == Enemy)
                {                    
                    return true;
                }
            }
        }        
    }    
    return false;
    //return ReturnValue;    
}

function bool HasFriendWithinDistance(float Distance, optional out Pawn OutFriend, optional float MinimalDistance)
{
    local AICharacterInfo FI;
    local float DistanceToEnemySq;

    // End:0x108
    foreach FriendInfoList(FI)
    {
        // End:0x107
        if(FI.Pawn != none)
        {
            DistanceToEnemySq = VSizeSq(FI.Pawn.Location - Pawn.Location);
            // End:0x107
            if((DistanceToEnemySq < (Distance * Distance)) && DistanceToEnemySq > (MinimalDistance * MinimalDistance))
            {
                OutFriend = FI.Pawn;                
                return true;
            }
        }        
    }    
    return false;
    //return ReturnValue;    
}

function Vector GetGoalLocation(Actor InGoal)
{
    // End:0x46
    if(CoverLink(InGoal) != none)
    {
        return CoverLink(InGoal).GetSlotLocation(0);        
    }
    else
    {
        return InGoal.Location;
    }
    //return ReturnValue;    
}

final function SetEnemyMoveGoal(optional float InGoalDistance = 0.0000000, optional bool bInUpdateGoal, optional bool bInForceWalk, optional bool bInShiftDestination = false, optional float InTimedOut = -1.0000000, optional bool bInStopWhenSeeEnemy = false, optional bool bInDontChangeFocusOnMove)
{
    Class'EvilAICmd_MoveToEnemy'.static.MoveToEnemy(self, InGoalDistance, bInShiftDestination, InTimedOut, bInUpdateGoal, bInForceWalk, bInStopWhenSeeEnemy, bInDontChangeFocusOnMove);
    //return;    
}

function SetSpecialMoveGoal(Actor InGoal, optional float InGoalDistance = 0.0000000, optional bool bInUpdateGoal, optional bool bInForceWalk, optional bool bInShiftDestination = false, optional bool bInForceDirectMove)
{
    local EvilNavPointInterface INavPoint;
    local EvilTypesNative.EMoveMode MoveMode;
    local CoverInfo CovToNavPoint;
    local float CoverRadius;

    INavPoint = EvilNavPointInterface(InGoal);
    MoveMode = ((EqualEqual_InterfaceInterface(INavPoint, EvilNavPointInterface(none))) ? MyEvilPawn.SupremeMoveMode : INavPoint.GetMoveMode());
    MyEvilPawn.ForceLimitedMoveMode(MoveMode);
    // End:0x11E
    if(EqualEqual_InterfaceInterface(INavPoint, EvilNavPointInterface(none)))
    {
        SetMoveGoal(InGoal, InGoalDistance, bInUpdateGoal, bInForceWalk, bInShiftDestination);        
    }
    else
    {
        CoverRadius = INavPoint.GetCoverRadius();
        // End:0x1FC
        if(CoverRadius > 0.0000000)
        {
            // End:0x1FC
            if(EvaluateCover(2, Enemy, CovToNavPoint, CoverRadius, true, InGoal.Location))
            {
                InGoal = CovToNavPoint.Link;
                INavPoint = EvilNavPointInterface(InGoal);
                ScriptedMoveTarget = InGoal;                
            }
        }
        switch(INavPoint.GetMoveToGoalMode())
        {
            // End:0x273
            case 0:
                SetMoveGoal(InGoal, InGoalDistance, bInUpdateGoal, bInForceWalk, bInShiftDestination,, bInForceDirectMove);
                // End:0x2B6
                break;
            // End:0x2B3
            case 1:
                // End:0x2B0
                if(CoverLink(InGoal) != none)
                {
                    SetCoverLinkGoal(CoverLink(InGoal));                    
                }
                // End:0x2B6
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    //return;    
}

function ExecuteNavActions(Actor InGoal)
{
    local EvilNavPointInterface INavPoint;
    local array<EvilNavPointAction> NavActions;

    INavPoint = EvilNavPointInterface(InGoal);
    // End:0xBE
    if(NotEqual_InterfaceInterface(INavPoint, EvilNavPointInterface(none)))
    {
        NavActions = INavPoint.GetNavPointActions();
        MyEvilPawn.RollbackLimitedMoveMode();
        // End:0xBE
        if(NavActions.Length > 0)
        {
            Class'EvilAICmd_NavAction'.static.ExecuteActions(self, NavActions);
        }
    }
    //return;    
}

function SetCoverLinkGoal(CoverLink NewCoverLinkGoal, optional bool bIsValidCache)
{
    local CoverInfo covinf;

    covinf.Link = NewCoverLinkGoal;
    covinf.SlotIdx = 0;
    SetCoverGoal(covinf);
    //return;    
}

function SetCoverSlotGoal(CoverLink NewCoverLinkGoal, int SlotIdx)
{
    SetMovePoint(NewCoverLinkGoal.GetSlotLocation(SlotIdx));
    //return;    
}

function SetCoverGoal(CoverInfo NewCoverGoal, optional bool bIsValidCache)
{
    SetMoveGoal(NewCoverGoal.Link);
    //return;    
}

function bool ShouldStopOnMoveToGoalPause()
{
    return true;
    //return ReturnValue;    
}

final function SetMoveGoal(Actor InGoal, optional float InGoalDistance = 0.0000000, optional bool bInUpdateGoal, optional bool bInForceWalk, optional bool bInShiftDestination = false, optional bool bInDontChangeFocusOnMove, optional bool bInForceDirectMove)
{
    MoveGoal = InGoal;
    MovePosition = vect(0.0000000, 0.0000000, 0.0000000);
    MoveOffset = InGoalDistance;
    // End:0xC2
    if(MoveCommand != none)
    {
        MoveCommand.static.MoveToGoal(self, InGoal, InGoalDistance, bInUpdateGoal, bInForceWalk, bInShiftDestination, bInDontChangeFocusOnMove, bInForceDirectMove);
    }
    //return;    
}

final function SetMoveGoal_NonNavmesh(Actor InGoal, optional float InGoalDistance = 0.0000000, optional bool bInUpdateGoal, optional bool bInForceWalk, optional bool bInShiftDestination = false)
{
    MoveGoal = InGoal;
    MovePosition = vect(0.0000000, 0.0000000, 0.0000000);
    MoveOffset = InGoalDistance;
    Class'EvilAICmd_MoveToGoal_NonNavmesh'.static.MoveToGoal(self, InGoal, InGoalDistance, bInUpdateGoal, bInForceWalk, bInShiftDestination);
    //return;    
}

final function SetMovePoint(Vector InMovePoint, optional float InGoalDistance = 30.0000000, optional bool bInForceWalk)
{
    MoveGoal = none;
    MovePosition = InMovePoint;
    MoveOffset = InGoalDistance;
    // End:0x87
    if(MoveCommand != none)
    {
        MoveCommand.static.MoveToPoint(self, InMovePoint, InGoalDistance, bInForceWalk);
    }
    //return;    
}

final function SetMovePoint_NonNavmesh(Vector InMovePoint, optional float InGoalDistance = 30.0000000, optional bool bInForceWalk)
{
    MoveGoal = none;
    MovePosition = InMovePoint;
    MoveOffset = InGoalDistance;
    Class'EvilAICmd_MoveToGoal_NonNavmesh'.static.MoveToPoint(self, InMovePoint, InGoalDistance, bInForceWalk);
    //return;    
}

function bool GetUnstuckLocation(float Radius, out Vector OutLocation, Vector GoalLocation, out int Index, optional bool terate, optional bool bTraceDestLocation = false, optional bool bClosestToGoalLocation = false, optional float MinRadius = -1.0000000, optional bool bMustBeReachableFromStartPos)
{
    local int Idx, StartIdx, traceIdx;
    local array<Vector> Position;
    local Vector HitLocation, HitNormal;
    local Actor HitActor;
    local float bestDist;
    local bool bResult;

    // End:0x59
    if(MinRadius == float(-1))
    {
        MinRadius = Pawn.GetCollisionRadius() * float(2);
    }
    Class'Engine.NavigationHandle'.static.GetValidPositionsForBox(Pawn.Location, Radius, Pawn.GetCollisionExtent() + NavMeshPath_SearchExtent_Modifier, bMustBeReachableFromStartPos, Position, 15, MinRadius);
    // End:0xFA
    if(Position.Length <= 0)
    {
        return false;
    }
    // End:0x122
    if(!bClosestToGoalLocation)
    {
        StartIdx = Rand(Position.Length);        
    }
    Idx = 0;
    J0x12D:

    // End:0x3A1 [Loop If]
    if(Idx < Position.Length)
    {
        // End:0x25D
        if(bTraceDestLocation)
        {
            traceIdx = ((bClosestToGoalLocation) ? Idx : StartIdx);
            HitActor = Pawn.Trace(HitLocation, HitNormal, Position[traceIdx], Pawn.Location, true, Pawn.GetCollisionExtent());
            // End:0x25D
            if(((HitActor != none) && HitActor != Pawn) && HitActor != Pawn.Base)
            {
                // [Explicit Continue]
                goto J0x393;
            }
        }
        // End:0x2F5
        if(bClosestToGoalLocation)
        {
            // End:0x2F2
            if(!bResult || VSizeSq(Position[Idx] - GoalLocation) < bestDist)
            {
                OutLocation = Position[Idx];
                bestDist = VSizeSq(OutLocation - GoalLocation);
                bResult = true;
            }            
        }
        else
        {
            // End:0x371
            if(VSizeSq(MyEvilPawn.Location - GoalLocation) > VSizeSq(Position[StartIdx] - GoalLocation))
            {
                OutLocation = Position[StartIdx];
                bResult = true;
                // [Explicit Break]
                goto J0x3A1;
            }
            StartIdx = (StartIdx + 1) % Position.Length;
        }
        J0x393:

        ++Idx;
        // [Loop Continue]
        goto J0x12D;
    }
    J0x3A1:

    // End:0x3AE
    if(bResult)
    {
    }
    return bResult;
    //return ReturnValue;    
}

function bool GetNearGoalLocation(float Radius, Vector goalloc, out Vector nloc)
{
    local array<Vector> Position;

    Class'Engine.NavigationHandle'.static.GetValidPositionsForBox(goalloc, Radius, Pawn.GetCollisionExtent(), false, Position, 8, Pawn.GetCollisionRadius() * float(2), vect(30.0000000, 30.0000000, 30.0000000));
    // End:0xC0
    if(Position.Length > 0)
    {
        nloc = Position[Rand(Position.Length)];
        return true;
    }
    return false;
    //return ReturnValue;    
}

function Vector GetShootLocation(float Radius, Actor Target, optional float MinRadius, optional bool bInCombatZones)
{
    local array<Vector> PositionList;
    local int I, BestEpsilonIndex;
    local float BestEpsilon, Epsilon;
    local Vector P;
    local EvilCombatZone ecz;
    local bool bInCombatZone;

    // End:0x54
    if(Radius < (Pawn.GetCollisionRadius() * float(2)))
    {
        return Pawn.Location;
    }
    Class'Engine.NavigationHandle'.static.GetValidPositionsForBox(Target.Location, Radius, Pawn.GetCollisionExtent(), false, PositionList, -1, MinRadius, vect(30.0000000, 30.0000000, 30.0000000));
    // End:0x28A
    foreach PositionList(P, I)
    {
        Epsilon = VSizeSq(P - MyEvilPawn.Location);
        // End:0x1B3
        if(bInCombatZones)
        {
            bInCombatZone = true;
            // End:0x19F
            foreach CombatZones(ecz)
            {
                // End:0x19E
                if(!ecz.EncompassesPoint(P))
                {
                    bInCombatZone = false;                    
                }
                else
                {                    
                }
            }            
            // End:0x1B3
            if(!bInCombatZone)
            {
                continue;
                // [Explicit Continue]
                goto J0x28A;
            }
        }
        // End:0x205
        if(Epsilon > Square(MyEvilPawn.GetCollisionRadius() * float(8)))
        {
            Epsilon = 1.0000000 / Epsilon;            
        }
        else
        {
            Epsilon = 0.0000000;
        }
        // End:0x24C
        if(ClearFireLineToActor(Target, P, true,,, false, true))
        {
            Epsilon *= float(4);            
        }
        // End:0x289
        if(Epsilon > BestEpsilon)
        {
            BestEpsilon = Epsilon;
            BestEpsilonIndex = I;
        }        
    }
    J0x28A:
    
    return PositionList[BestEpsilonIndex];
    //return ReturnValue;    
}

function Vector GetRandomLocation(float Radius, optional bool bOverrideStartLocation, optional Vector StartLocation)
{
    local array<Vector> Position;
    local int I, BestEpsilonIndex;
    local float BestEpsilon, Epsilon;
    local Vector P;

    // End:0x54
    if(Radius < (Pawn.GetCollisionRadius() * float(2)))
    {
        return Pawn.Location;
    }
    Class'Engine.NavigationHandle'.static.GetValidPositionsForBox(((bOverrideStartLocation) ? StartLocation : Pawn.Location), Radius, Pawn.GetCollisionExtent(), true, Position, 5, FMin(Radius, EnemyDistance_MeleeCharge * float(2)), vect(30.0000000, 30.0000000, 30.0000000));
    Epsilon = VSizeSq(Pawn.Location - PossessLocation);
    // End:0x1E9
    if(Epsilon < (Radius ** float(2)))
    {
        // End:0x1E5
        foreach Position(P, I)
        {
            // End:0x1A7
            if(IsAimingAtPoint(P, 0.9700000, Epsilon))
            {                
                return P;                
            }
            else
            {
                // End:0x1E4
                if(Epsilon > BestEpsilon)
                {
                    BestEpsilon = Epsilon;
                    BestEpsilonIndex = I;
                }
            }            
        }                
    }
    else
    {
        BestEpsilon = 1000000000.0000000;
        // End:0x275
        foreach Position(P, I)
        {
            Epsilon = VSizeSq(P - PossessLocation);
            // End:0x274
            if(Epsilon < BestEpsilon)
            {
                BestEpsilon = Epsilon;
                BestEpsilonIndex = I;
            }            
        }        
    }
    // End:0x29D
    if(Position.Length > 0)
    {
        return Position[BestEpsilonIndex];        
    }
    else
    {
        return Pawn.Location;
    }
    //return ReturnValue;    
}

function Vector GetAimLocation(Actor AimTarget, EvilTypes.EAimZone AimZone)
{
    local Vector AimLoc;
    local Pawn TargetPawn;

    // End:0x22
    if(AimTarget == none)
    {
        AimTarget = ShotTarget;
    }
    TargetPawn = Pawn(AimTarget);
    // End:0xB0
    if(TargetPawn != none)
    {
        switch(AimZone)
        {
            // End:0x85
            case 1:
                AimLoc = GetTargetEnemyLocation(TargetPawn);
                // End:0xAD
                break;
            // End:0xAA
            case 2:
                AimLoc = GetTargetEnemyHeadLocation(TargetPawn);
                // End:0xAD
                break;
            // End:0xFFFF
            default:
                break;
        }        
    }
    else
    {
        AimLoc = AimTarget.Location;
    }
    return AimLoc;
    //return ReturnValue;    
}

function GetTargetEnemy(out Pawn TargetEnemy)
{
    // End:0x64
    if(TargetEnemy == none)
    {
        // End:0x34
        if(ShotTarget != none)
        {
            TargetEnemy = ShotTarget;            
        }
        else
        {
            // End:0x59
            if(Enemy != none)
            {
                TargetEnemy = Enemy;                
            }
            else
            {
                TargetEnemy = none;
            }
        }
    }
    //return;    
}

function Vector GetTargetEnemyHeadLocation(optional Pawn TargetEnemy)
{
    GetTargetEnemy(TargetEnemy);
    return TargetEnemy.Mesh.GetBoneLocation('Head', 0);
    //return ReturnValue;    
}

function Vector GetTargetEnemyLocation(optional Pawn TargetEnemy)
{
    GetTargetEnemy(TargetEnemy);
    return TargetEnemy.Location;
    //return ReturnValue;    
}

function ReturnToIdle()
{
    AbortCommand(CommandList);
    //return;    
}

function EnableNonePCSightNotifiers(bool InEnable)
{
    ClearTimer('SeeEnemyAI');
    // End:0x34
    if(InEnable)
    {
        SetTimer(0.6000000, true, 'SeeEnemyAI');
    }
    //return;    
}

function NotifySpawnCompleted(EvilTypes.EAIFactoryEvent EventType)
{
    ReactionManager.NudgeChannel(self, 'SpawnCompleted');
    CheckCombatTransition();
    //return;    
}

simulated event OnBeginAnimControl(InterpGroup InInterpGroup)
{
    // End:0x34
    if(MyEvilPawn != none)
    {
        MyEvilPawn.ServerDoPawnAction(20);
    }
    //return;    
}

simulated event OnFinishAnimControl(InterpGroup InInterpGroup)
{
    // End:0x2F
    if(MyEvilPawn != none)
    {
        MyEvilPawn.EndPawnAction();
    }
    //return;    
}

function float GetEnemyRating(EvilPawn EnemyP, float Distance)
{
    local float Rating;

    Rating = GetBaseEnemyRating(EnemyP, Distance);
    AdjustEnemyRating(Rating, EnemyP);
    EnemyP.AdjustMyEnemyRatingFor(self, Rating);
    return Rating;
    //return ReturnValue;    
}

function AdjustEnemyRating(out float out_Rating, EvilPawn EnemyPawn)
{
    local EvilAICommand Cmd;

    Cmd = EvilAICommand(CommandList);
    // End:0x5C
    if(Cmd != none)
    {
        Cmd.AdjustEnemyRating(out_Rating, EnemyPawn);
    }
    //return;    
}

function float GetBaseEnemyRating(EvilPawn EnemyP, float Distance)
{
    local float AbsDistZ, Rating;
    local AICharacterInfo EnemyInfo;
    local float TempModifier;

    // End:0x36
    if(!EnemyP.IsAliveAndWell())
    {
        Rating = 0.0000000;        
    }
    else
    {
        Rating = 1.0000000;
    }
    AbsDistZ = Abs(EnemyP.Location.Z - MyEvilPawn.Location.Z);
    EnemyInfo = GetEnemyInfo(EnemyP);
    TempModifier = (FMax(EnemyDistance_Melee, MyEvilPawn.GetCollisionRadius()) / (Distance + 1.0000000)) * ((MyEvilPawn.HasRangedAttack() || AbsDistZ <= MyEvilPawn.MaxStepHeight) ? 1.0000000 : MyEvilPawn.MaxStepHeight / AbsDistZ);
    Rating *= TempModifier;
    TempModifier = (((WorldInfo.TimeSeconds - EnemyInfo.LastUpdateTime) <= EnemyInfo.UpdateInterval) ? 1.0000000 : float(1) / ((WorldInfo.TimeSeconds - EnemyInfo.LastUpdateTime) + 1.0000000));
    Rating *= TempModifier;
    // End:0x305
    if(MyEvilPawn.HasRangedAttack())
    {
        Rating *= (((int(EnemyP.CoverType) != int(0)) && int(EnemyP.CoverAction) == int(0)) ? 0.5000000 : 1.0000000);
    }
    Rating *= ((EnemyInfo.GivenDamageToMe > 0.0000000) ? 1.2000000 : 1.0000000);
    Rating *= ((EnemyInfo.Pawn.bIsWounded) ? 0.0100000 : 1.0000000);
    Rating *= ((Enemy == EnemyP) ? 1.0000000 : 0.9000000);
    return Rating;
    //return ReturnValue;    
}

function float GetMoveTimeOutDuration(Vector Dest, optional bool bIsGoalUpdating)
{
    local float Dist, GroundSpeed;

    // End:0x16
    if(Pawn == none)
    {
        return 5.0000000;
    }
    GroundSpeed = Pawn.GroundSpeed;
    Dist = VSize(Pawn.Location - Dest);
    // End:0xE9
    if(Pawn.bIsWalking || int(MyEvilPawn.CurrentMoveMode) <= int(1))
    {
        GroundSpeed *= Pawn.WalkingPct;
    }
    return FMax(1.0000000, 3.0000000 * (Dist / GroundSpeed));
    //return ReturnValue;    
}

simulated function byte GetTeamNum()
{
    // End:0x6F
    if(MyEvilPawn != none)
    {
        // End:0x69
        if(MyEvilPawn.AITeamInfo != none)
        {
            return byte(MyEvilPawn.AITeamInfo.TeamIndex);
        }
        return 255;        
    }
    else
    {
        return super(Controller).GetTeamNum();
    }
    //return ReturnValue;    
}

function InvalidateCoverAction()
{
    //return;    
}

function InvalidateCover(optional bool bUnclaimOnly, optional bool bDontClearCoverGoal, optional bool bDontClearClaimedGoal)
{
    //return;    
}

function ClearCoverGoal()
{
    //return;    
}

function PlayerStepAside(Pawn PlayerPawn, Vector HitNormal)
{
    //return;    
}

function bool NotifyBump(Actor Other, Vector HitNormal)
{
    local Pawn bumpPawn;
    local EvilPawn bumpEvilPawn;
    local bool bStimResult;

    // End:0x0F
    if(IgnoreNotifies())
    {
        return false;
    }
    bumpPawn = Pawn(Other);
    // End:0x47E
    if(bumpPawn != none)
    {
        // End:0x5B
        if(MoveGoal == Other)
        {
            AbortMoving();
        }
        // End:0xA9
        if((bumpPawn == LastBumpedPawn) && (WorldInfo.TimeSeconds - LastBumpTime) < 1.0000000)
        {
            return false;
        }
        LastBumpedPawn = bumpPawn;
        LastBumpTime = WorldInfo.TimeSeconds;
        bumpEvilPawn = EvilPawn(Other);
        // End:0x3EA
        if(IsFriendlyPawn(bumpPawn))
        {
            // End:0x223
            if((((((EvilSpawnPoint(MoveGoal) != none) || EvilNavPoint(MoveGoal) != none) || MyEvilPawn.bMovingToCover && EvilAICmd_Base_ScriptedMove(CommandList) != none) && Pawn(Other) != none) && Pawn(Other).IsPlayerPawn()) && IsZero(Pawn(Other).Velocity))
            {
                PlayerStepAside(Pawn(Other), HitNormal);
                return false;
            }
            // End:0x371
            if(((!IsZero(bumpPawn.Velocity) && IsZero(Pawn.Velocity)) && !(((bumpEvilPawn != none) && bumpEvilPawn.MyEvilAI != none) && !bumpEvilPawn.MyEvilAI.CanStepAside()) && bumpEvilPawn.MyEvilAI.StepAsideGoal != Pawn) && !(Pawn(Other) != none) && Pawn(Other).IsPlayerPawn())
            {
                return false;
            }
            // End:0x3E7
            if((Pawn.Base != bumpPawn) && bumpPawn.Base != Pawn)
            {
                StepAsideFor(bumpPawn, HitNormal);
            }            
        }
        else
        {
            bStimResult = ProcessStimulus(bumpEvilPawn, 3, 'NotifyBump');
            // End:0x47E
            if(!bDoingMeleeAttack)
            {
                // End:0x474
                if((((bumpEvilPawn != none) && CanEngageMelee()) && bStimResult) && !IsFiring())
                {
                    DoMeleeAttack(bumpEvilPawn);
                }
                BlockCombatTransitions();
            }
        }
    }
    return super(Controller).NotifyBump(Other, HitNormal);
    //return ReturnValue;    
}

singular event bool StepAsideFor(Pawn ChkPawn, Vector HitNormal)
{
    local bool bResult, bStepAside, bDelayStep;
    local EvilAIController AI;
    local EvilPawn ChkEP;

    ChkEP = EvilPawn(ChkPawn);
    // End:0x2CE
    if(CanStepAside())
    {
        bResult = true;
        bStepAside = true;
        // End:0x123
        if(((((ChkEP != none) && ChkEP.IsInCover()) && !ChkEP.IsPlayerPawn()) && MoveGoal != none) && VSize2D(MoveGoal.GetDestination(self) - ChkEP.Location) < (256.0000000 * 256.0000000))
        {
            bResult = true;
            bStepAside = false;            
        }
        else
        {
            AI = EvilAIController(ChkPawn.Controller);
            // End:0x1A9
            if((AI != none) && AI.StepAsideGoal == Pawn)
            {
                bResult = true;
                bStepAside = false;
            }
            // End:0x25E
            if(!IsZero(Pawn.Velocity) && (Pawn.Velocity Dot ChkPawn.Velocity) > 0.0000000)
            {
                bDelayStep = ShouldDelayStepAside(ChkPawn);
                // End:0x25E
                if(!bDelayStep)
                {
                    bResult = true;
                    bStepAside = false;
                }
            }
        }
        // End:0x2CB
        if(bStepAside && StepAsideGoal != ChkPawn)
        {
            bResult = Class'EvilAICmd_StepAside'.static.StepAside(self, ChkPawn, bDelayStep, HitNormal);
        }        
    }
    return bResult;
    //return ReturnValue;    
}

function bool CanStepAside()
{
    local GameAICommand ActiveCommand;

    ActiveCommand = GetActiveCommand();
    return (!bIgnoreStepAside && (ActiveCommand == none) || !ActiveCommand.bIgnoreStepAside) && (MyEvilPawn == none) || !MyEvilPawn.IsDoingAPawnAction();
    //return ReturnValue;    
}

function bool NeedReload()
{
    return (EvilWeap_Base(MyEvilPawn.Weapon) != none) && EvilWeap_Base(MyEvilPawn.Weapon).DesireAmmo(true) > 0.8000000;
    //return ReturnValue;    
}

function bool ShouldStartShootAttack()
{
    local float ShootingPriority;
    local bool bResult;
    local AIDirectorBase AIDirInst;

    AIDirInst = EvilGame(WorldInfo.Game).AIDirectorInstance;
    ShootingPriority = GetShootingPriority();
    bResult = (ShootingPriority >= 1.0000000) || !AIDirInst.ReachedShootingIntensity(self) && FRand() < ShootingPriority;
    // End:0xF8
    if(bResult)
    {
        AIDirInst.LastStartShootTime = WorldInfo.TimeSeconds;
    }
    return bResult;
    //return ReturnValue;    
}

function bool ShouldStartThrowAttack()
{
    return !EvilGame(WorldInfo.Game).AIDirectorInstance.ReachedThrowingIntensity(self);
    //return ReturnValue;    
}

function bool ShouldThrowGrenade()
{
    return ((((((ShouldStartThrowAttack()) && CanThrowGrenade()) && HasEnemyWithinDistance(EnemyDistance_Throw,, EnemyDistance_MinimalStrafeDistance * 1.8000000, false)) && SelectTarget()) && !IsAnyFriendsInRadius(MyEvilPawn.GrenadeProjectile.default.ExplosionArchetype.DamageRadius * 2.0000000, true, Enemy.Location)) && int(MyEvilPawn.CurrentAimZone) != int(0)) && bFailedToThrow || (WorldInfo.TimeSeconds - LastThrowGrenadeTime) > TimeBetweenThrows;
    //return ReturnValue;    
}

function bool IsAnyFriendsInRadius(float Radius, optional bool bOverrideSearchLocation, optional Vector InSearchLocation)
{
    local Vector SearchLocation;
    local AICharacterInfo FriendInfo;
    local bool bResult;

    SearchLocation = ((bOverrideSearchLocation) ? InSearchLocation : MyEvilPawn.Location);
    // End:0xC0
    foreach FriendInfoList(FriendInfo)
    {
        // End:0xBF
        if(VSizeSq(FriendInfo.Pawn.Location - SearchLocation) < (Radius * Radius))
        {
            bResult = true;            
        }
        else
        {            
        }
    }    
    return bResult;
    //return ReturnValue;    
}

function bool ShouldBroadcast(EvilAIController Receiver, Pawn P, EvilTypes.EPerceptionType Pt, optional name EventName, optional float RadiusSq)
{
    return ((((Receiver != self) && Receiver.Pawn != none) && IsFriendlyPawn(Receiver.Pawn)) && Receiver.Pawn != P) && (RadiusSq <= 0.0000000) || VSizeSq(Receiver.Pawn.Location - Pawn.Location) < RadiusSq;
    //return ReturnValue;    
}

function bool ShouldBroadcastChangeTeam(EvilAIController Receiver, Pawn P, EvilTypes.EPerceptionType Pt, optional name EventName, optional float RadiusSq)
{
    return (ShouldBroadcast(Receiver, P, Pt, EventName, RadiusSq)) && (Receiver.GetAIEnemyInfoIdx(P) >= 0) || Receiver.GetAIFriendInfoIdx(P) >= 0;
    //return ReturnValue;    
}

function bool ShouldDelayStepAside(Pawn GoalPawn)
{
    local float VelDotVel, GoalDotVel;
    local Vector VectToGoal, VelDir;

    // End:0x13B
    if(!IsZero(Pawn.Velocity) && !IsZero(GoalPawn.Velocity))
    {
        VelDir = Normal(Pawn.Velocity);
        VelDotVel = Normal(GoalPawn.Velocity) Dot VelDir;
        // End:0x13B
        if(VelDotVel > 0.3000000)
        {
            VectToGoal = Normal(GoalPawn.Location - Pawn.Location);
            GoalDotVel = VectToGoal Dot VelDir;
            // End:0x13B
            if(GoalDotVel > float(0))
            {
                return true;
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function bool EvaluateCover(EvilTypes.ECoverSearchType Type, Actor GoalActor, out CoverInfo out_Cover, optional float Radius = 2000.0000000, optional bool bOverrideSearchStartLocation, optional Vector SearchStartLocation)
{
    return false;
    //return ReturnValue;    
}

function float GetShootingPriority()
{
    local float ShootingPriority;
    local AIDirectorBase AIDirInst;

    // End:0x15
    if(!HasValidEnemy())
    {
        return 0.0000000;
    }
    ShootingPriority = FMin(1.0000000, (FMax(1000.0000000, EnemyDistance_Shoot) * ((MyEvilPawn.IsInCover()) ? 1.0000000 : 1.8000000)) / GetEnemyInfo().DistanceToEnemy);
    ShootingPriority *= ((MyEvilPawn.IsReloading()) ? 0.0000000 : 1.0000000);
    AIDirInst = EvilGame(WorldInfo.Game).AIDirectorInstance;
    // End:0x14D
    if(AIDirInst != none)
    {
        ShootingPriority *= ((AIDirInst.IsDelayBetweenShootersAchieved()) ? 1.0000000 : 0.0010000);
    }
    return ShootingPriority;
    //return ReturnValue;    
}

function bool ShouldTeleportToGoal(optional Vector GoalLocation)
{
    return bCanTeleportToGoal;
    //return ReturnValue;    
}

function bool TeleportToGoal(optional Vector GoalLocation, optional Actor GoalActor)
{
    local Vector TeleportLocation;

    // End:0x82
    if(IsZero(GoalLocation))
    {
        // End:0x4B
        if(GoalActor != none)
        {
            GoalLocation = GoalActor.Location;            
        }
        else
        {
            // End:0x82
            if(MoveGoal != none)
            {
                GoalLocation = MoveGoal.Location;
            }
        }
    }
    // End:0xEF
    if(GetTeleportLocation(TeleportLocation, GoalActor, GoalLocation))
    {
        InvalidateCoverAction();
        InvalidateCover();
        // End:0xEA
        if(Pawn.SetLocation(TeleportLocation))
        {
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
    //return ReturnValue;    
}

function bool GetTeleportLocation(out Vector TeleportLocation, optional Actor GoalActor, optional Vector GoalLocation)
{
    local int I;
    local array<Vector> TeleportLocations;
    local float Radius;
    local PlayerController PC;
    local bool bExposedToPlayer;

    // End:0x82
    if(IsZero(GoalLocation))
    {
        // End:0x4B
        if(GoalActor != none)
        {
            GoalLocation = GoalActor.Location;            
        }
        else
        {
            // End:0x82
            if(MoveGoal != none)
            {
                GoalLocation = MoveGoal.Location;
            }
        }
    }
    Radius = MyEvilPawn.PawnBlockerRadius();
    // End:0xF9
    if(EvilPawn(GoalActor) != none)
    {
        Radius += EvilPawn(GoalActor).PawnBlockerRadius();        
    }
    else
    {
        // End:0x144
        if(EvilPawn(MoveGoal) != none)
        {
            Radius += EvilPawn(MoveGoal).PawnBlockerRadius();
        }
    }
    Class'Engine.NavigationHandle'.static.GetValidPositionsForBox(GoalLocation, MasterDistance_Follow, Pawn.GetCollisionExtent(), false, TeleportLocations, 25, Radius);
    // End:0x314
    if(TeleportLocations.Length > 0)
    {
        I = 0;
        J0x1C5:

        // End:0x300 [Loop If]
        if(I < TeleportLocations.Length)
        {
            bExposedToPlayer = false;
            // End:0x2C1
            foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
            {
                // End:0x2C0
                if(PC.CanSeeByPoints(PC.Pawn.Location, TeleportLocations[I], PC.Pawn.Rotation))
                {
                    bExposedToPlayer = true;
                    // End:0x2C1
                    break;
                }                
            }            
            // End:0x2D2
            if(bExposedToPlayer)
            {                
            }
            else
            {
                TeleportLocation = TeleportLocations[I];
                // [Explicit Break]
                goto J0x300;
            }
            ++I;
            // [Loop Continue]
            goto J0x1C5;
        }
        J0x300:

        // End:0x30F
        if(bExposedToPlayer)
        {
            return false;
        }
        return true;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

function bool ExposedToPlayer()
{
    local PlayerController PC;

    // End:0x5C
    foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x5B
        if(PC.CanSee(Pawn))
        {            
            return true;
        }        
    }    
    return false;
    //return ReturnValue;    
}

function AbortMoveCommand()
{
    local EvilAICmd_Base_ScriptedRouteMove CurScriptedRouteMoveCommand;
    local EvilAICmd_Base_ScriptedMove CurScriptedMoveCommand;

    CurScriptedMoveCommand = EvilAICmd_Base_ScriptedMove(CommandList);
    CurScriptedRouteMoveCommand = EvilAICmd_Base_ScriptedRouteMove(CommandList);
    // End:0x5E
    if(CurScriptedMoveCommand != none)
    {
        AbortCommand(CurScriptedMoveCommand);        
    }
    else
    {
        // End:0x81
        if(CurScriptedRouteMoveCommand != none)
        {
            AbortCommand(CurScriptedRouteMoveCommand);
        }
    }
    //return;    
}

function bool CheckForRequestHelpFromEnemy(int PawnListIndex)
{
    local bool bResult;

    // End:0x1E0
    if(((((int(MyEvilPawn.PawnAction) == 0) || int(MyEvilPawn.PawnAction) == 12) || int(MyEvilPawn.PawnAction) == 11) && int(MyEvilPawn.CurrentMoveMode) < int(2)) && (WorldInfo.TimeSeconds - EnemyInfoList[PawnListIndex].LastSeenTime) < 0.1000000)
    {
        // End:0x1E0
        if(((EnemyInfoList[PawnListIndex].DistanceToEnemy < RequestHelpEnemyDistance) && EnemyInfoList[PawnListIndex].Controller != none) && EnemyInfoList[PawnListIndex].Controller.Enemy == Pawn)
        {
            bResult = (CanPlayRequestHelp()) && MyEvilPawn.PlayRequestHelp(0.5000000);
        }
    }
    return bResult;
    //return ReturnValue;    
}

function bool CanPlayRequestHelp()
{
    return true;
    //return ReturnValue;    
}

function ModifyDamage(out int Damage)
{
    //return;    
}

function bool IsCoveringForced()
{
    return (MoveAction != none) && !MoveAction.bInterruptable;
    //return ReturnValue;    
}

function bool IsGoalCollidingWithOtherPawns(Vector GoalLocation, float Radius)
{
    local EvilPawn P;
    local bool bResult;

    // End:0x89
    foreach CollidingActors(Class'EvilPawn', P, Radius, GoalLocation)
    {
        // End:0x88
        if(((P != none) && P != MyEvilPawn) && P.IsAliveAndWell())
        {
            bResult = true;
            // End:0x89
            break;
        }        
    }    
    return bResult;
    //return ReturnValue;    
}

event Destroyed()
{
    super.Destroyed();
    //return;    
}

auto state Idle
{Begin:

    Sleep(0.1000000);
    // End:0x8A
    if(MyEvilPawn != none)
    {
        CheckCombatTransition();
        // End:0x73
        if(bMoveAroundWhenIdle)
        {
            SetMovePoint(GetRandomLocation(SenseDistanceThreshold), Pawn.GetCollisionRadius() * float(2), true);
        }
        Sleep(RandRange(1.0000000, 2.0000000));
    }
    goto 'Begin';
    stop;                
}

state ScriptedRouteMove
{Begin:

    BeginCombatCommand(Class'EvilAICmd_Base_ScriptedRouteMove', "ScritpedRouteMove", true);
    PopState();
    stop;        
}

state ScriptedMove
{Begin:

    BeginCombatCommand(Class'EvilAICmd_Base_ScriptedMove', "ScriptedMove", true);
    PopState();
    stop;            
}

defaultproperties
{
    bFireWhileMoving=true
    bMoveToGoalByNavMesh_TryToUnstuck=true
    bAllowCombatTransitions=true
    TargettedAimEpsilon=0.9500000
    ProjectileAimHeightModifier=1.0000000
    RestDelayAfterShoot=-1.0000000
    MeleeCommand=Class'EvilAICmd_Base_Melee'
    GuardCommand=Class'EvilAICmd_Base_Guard'
    RideCommand=Class'EvilAICmd_RideRailCar'
    MoveCommand=Class'EvilAICmd_MoveToGoal'
    ThrowCommand=Class'EvilAICmd_Attack_Throw'
    StrafeCommand=Class'EvilAICmd_Strafe'
    StrafesData[0]=(StrafeDirection=EStrafeDirection.SD_Left,StrafeDistance=100.0000000,DefaultRating=0.4000000,StrafeDelay=0.0000000,StrafePoint=(X=0.0000000,Y=0.0000000,Z=0.0000000),RandomAngleOffset=0.0000000,bClearFireLine=false,bEnemyReachable=false,Rating=0.0000000,bValidMoveToStrafePoint=false,Count=0,CustomStrafeDelta=(X=0.0000000,Y=0.0000000,Z=0.0000000),bDisabled=false,LastStrafeTime=0.0000000,AnimIndex=-1)
    StrafesData[1]=(StrafeDirection=EStrafeDirection.SD_Right,StrafeDistance=100.0000000,DefaultRating=0.4000000,StrafeDelay=0.0000000,StrafePoint=(X=0.0000000,Y=0.0000000,Z=0.0000000),RandomAngleOffset=0.0000000,bClearFireLine=false,bEnemyReachable=false,Rating=0.0000000,bValidMoveToStrafePoint=false,Count=0,CustomStrafeDelta=(X=0.0000000,Y=0.0000000,Z=0.0000000),bDisabled=false,LastStrafeTime=0.0000000,AnimIndex=-1)
    StrafesData[2]=(StrafeDirection=EStrafeDirection.SD_Back,StrafeDistance=100.0000000,DefaultRating=0.0500000,StrafeDelay=0.0000000,StrafePoint=(X=0.0000000,Y=0.0000000,Z=0.0000000),RandomAngleOffset=0.0000000,bClearFireLine=false,bEnemyReachable=false,Rating=0.0000000,bValidMoveToStrafePoint=false,Count=0,CustomStrafeDelta=(X=0.0000000,Y=0.0000000,Z=0.0000000),bDisabled=false,LastStrafeTime=0.0000000,AnimIndex=-1)
    StrafesData[3]=(StrafeDirection=EStrafeDirection.SD_Forward,StrafeDistance=100.0000000,DefaultRating=0.5000000,StrafeDelay=0.0000000,StrafePoint=(X=0.0000000,Y=0.0000000,Z=0.0000000),RandomAngleOffset=0.0000000,bClearFireLine=false,bEnemyReachable=false,Rating=0.0000000,bValidMoveToStrafePoint=false,Count=0,CustomStrafeDelta=(X=0.0000000,Y=0.0000000,Z=0.0000000),bDisabled=false,LastStrafeTime=0.0000000,AnimIndex=-1)
    StrafesData[4]=(StrafeDirection=EStrafeDirection.SD_Left,StrafeDistance=300.0000000,DefaultRating=0.4000000,StrafeDelay=0.0000000,StrafePoint=(X=0.0000000,Y=0.0000000,Z=0.0000000),RandomAngleOffset=0.0000000,bClearFireLine=false,bEnemyReachable=false,Rating=0.0000000,bValidMoveToStrafePoint=false,Count=0,CustomStrafeDelta=(X=0.0000000,Y=0.0000000,Z=0.0000000),bDisabled=false,LastStrafeTime=0.0000000,AnimIndex=-1)
    StrafesData[5]=(StrafeDirection=EStrafeDirection.SD_Right,StrafeDistance=300.0000000,DefaultRating=0.4000000,StrafeDelay=0.0000000,StrafePoint=(X=0.0000000,Y=0.0000000,Z=0.0000000),RandomAngleOffset=0.0000000,bClearFireLine=false,bEnemyReachable=false,Rating=0.0000000,bValidMoveToStrafePoint=false,Count=0,CustomStrafeDelta=(X=0.0000000,Y=0.0000000,Z=0.0000000),bDisabled=false,LastStrafeTime=0.0000000,AnimIndex=-1)
    StrafesData[6]=(StrafeDirection=EStrafeDirection.SD_Back,StrafeDistance=300.0000000,DefaultRating=0.0500000,StrafeDelay=0.0000000,StrafePoint=(X=0.0000000,Y=0.0000000,Z=0.0000000),RandomAngleOffset=0.0000000,bClearFireLine=false,bEnemyReachable=false,Rating=0.0000000,bValidMoveToStrafePoint=false,Count=0,CustomStrafeDelta=(X=0.0000000,Y=0.0000000,Z=0.0000000),bDisabled=false,LastStrafeTime=0.0000000,AnimIndex=-1)
    StrafesData[7]=(StrafeDirection=EStrafeDirection.SD_Forward,StrafeDistance=300.0000000,DefaultRating=0.5000000,StrafeDelay=0.0000000,StrafePoint=(X=0.0000000,Y=0.0000000,Z=0.0000000),RandomAngleOffset=0.0000000,bClearFireLine=false,bEnemyReachable=false,Rating=0.0000000,bValidMoveToStrafePoint=false,Count=0,CustomStrafeDelta=(X=0.0000000,Y=0.0000000,Z=0.0000000),bDisabled=false,LastStrafeTime=0.0000000,AnimIndex=-1)
    LastCheckedStrafeIndex=-1
    NumOfCheckedStrafesInRating=4
    DelayBetweenOppositeStrafes=2.0000000
    StrafeRatingThreshold=0.0010000
    EnemyDistance_Melee=130.0000000
    EnemyDistance_MeleeCharge=270.0000000
    EnemyDistance_MinimalStrafeDistance=200.0000000
    EnemyDistance_HearFootSteps=2000.0000000
    SenseDistanceThreshold=2000.0000000
    SightSenseDistanceThreshold=1500.0000000
    SightRadius=3000.0000000
    // Reference: EvilAIReactManager'Default__EvilAIController.ReactionManager0'
    begin object name=ReactionManager0 class=Class'EvilAIReactManager'
    end object
    ReactionManager=ReactionManager0
    // Reference: EvilAIReactCond_EnemyCanBeMeleed'Default__EvilAIController.EnemyCanBeMeleed0'
    begin object name=EnemyCanBeMeleed0 class=Class'EvilAIReactCond_EnemyCanBeMeleed'
    end object
    DefaultReactConditions[0]=EnemyCanBeMeleed0
    // Reference: EvilAIReactCond_EnemyCloseAndVisible'Default__EvilAIController.EnemyCloseAndVisible0'
    begin object name=EnemyCloseAndVisible0 class=Class'EvilAIReactCond_EnemyCloseAndVisible'
    end object
    DefaultReactConditions[1]=EnemyCloseAndVisible0
    // Reference: EvilAIReactCond_EnemyCloseToThrowLine'Default__EvilAIController.EnemyCloseToThrowLine0'
    begin object name=EnemyCloseToThrowLine0 class=Class'EvilAIReactCond_EnemyCloseToThrowLine'
    end object
    DefaultReactConditions[2]=EnemyCloseToThrowLine0
    // Reference: EvilAIReactCond_CanLongDistanceCharge'Default__EvilAIController.LongDistanceCharge0'
    begin object name=LongDistanceCharge0 class=Class'EvilAIReactCond_CanLongDistanceCharge'
    end object
    DefaultReactConditions[3]=LongDistanceCharge0
    // Reference: EvilAIReactCond_GenericCallDelegate'Default__EvilAIController.BehaviorAttack0'
    begin object name=BehaviorAttack0 class=Class'EvilAIReactCond_GenericCallDelegate'
    end object
    DefaultReactConditions[4]=BehaviorAttack0
    // Reference: EvilAIReactCond_Stumble'Default__EvilAIController.RunFail0'
    begin object name=RunFail0 class=Class'EvilAIReactCond_Stumble'
    end object
    DefaultReactConditions[5]=RunFail0
    // Reference: EvilAIReactCond_CanAimEnemy'Default__EvilAIController.ReadyToFire0'
    begin object name=ReadyToFire0 class=Class'EvilAIReactCond_CanAimEnemy'
    end object
    DefaultReactConditions[6]=ReadyToFire0
    // Reference: EvilAIReactCond_GenericCallDelegate'Default__EvilAIController.AbortMovingOnEnemyCloseAndVisible0'
    begin object name=AbortMovingOnEnemyCloseAndVisible0 class=Class'EvilAIReactCond_GenericCallDelegate'
    end object
    DefaultReactConditions[7]=AbortMovingOnEnemyCloseAndVisible0
    // Reference: EvilAIReactCond_CanThrowAtEnemy'Default__EvilAIController.Throw0'
    begin object name=Throw0 class=Class'EvilAIReactCond_CanThrowAtEnemy'
    end object
    DefaultReactConditions[8]=Throw0
    DefaultReactConditionClasses[0]=Class'EvilAIReactCond_EnemyInAttackRange'
    DefaultReactConditionClasses[1]=Class'EvilAIReactCond_Grenade'
    MaxStepAsideDist=100.0000000
    DelayBetweenFireLineCheckToEnemy=0.6000000
    TimeBetweenMeleeCommands=2.0000000
    LastActiveEnemyInfo=(Pawn=none,Controller=none,PawnGuid=(A=0,B=0,C=0,D=0),bIsPlayer=false,LastHearMeTime=0.0000000,LastHearMeSoundSetType=ESoundSetType.SST_Invalid,LastUpdateTime=0.0000000,UpdateInterval=0.3000000,KnownLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000),LastKnownVelocity=(X=0.0000000,Y=0.0000000,Z=0.0000000),DistanceToEnemy=0.0000000,Rating=0.0000000,bUpdateRating=false,LastSeenTime=0.0000000,bInitialized=false,RatingModifier=0.5000000,GivenDamageToMe=0.0000000)
    LastActiveEnemyIndex=-1
    ExtraPathCost=20
    LifeSpanWithoutPawn=5.0000000
    MaxMoveTowardPawnTargetTime=2.0000000
    NavMeshPath_SearchExtent_Modifier=(X=0.0000000,Y=0.0000000,Z=-10.0000000)
}