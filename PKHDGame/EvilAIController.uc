class EvilAIController extends GameAIController
    native(AI)
    config(AI)
    hidecategories(Navigation);

enum EPerceptionType
{
    PT_Sight,                       // 0
    PT_Heard,                       // 1
    PT_HurtBy,                      // 2
    PT_Force,                       // 3
    PT_SightPlayer,                 // 4
    PT_MAX                          // 5
};

struct native AICharacterInfo
{
    var EvilPawn Pawn;
    var EvilAIController Controller;
    var float LastHearMeTime;
    var EvilTypes.ESoundSetType LastHearMeSoundSetType;
    var float LastUpdateTime;
    var float UpdateInterval;
    var Vector KnownLocation;
    var Vector LastKnownVelocity;
    var float DistanceToEnemy;
    var float Rating;
    var bool bForceUpdate;
    var float LastSeenTime;
    var bool bInitialized;

    structdefaultproperties
    {
        Pawn=none
        Controller=none
        LastHearMeTime=0.0000000
        LastHearMeSoundSetType=ESoundSetType.SST_Invalid
        LastUpdateTime=0.0000000
        UpdateInterval=0.3000000
        KnownLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        LastKnownVelocity=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        DistanceToEnemy=0.0000000
        Rating=0.0000000
        bForceUpdate=false
        LastSeenTime=0.0000000
        bInitialized=false
    }
};

struct CheckpointRecord
{
    var Guid SavedGuid;
    var float PawnHealthPct;
    var string PawnClassName;
    var string RidableClassName;
    var string PawnPathName;
    var string MoveActionPathName;
    var Vector Location;
    var Rotator Rotation;
    var string BasePathName;
    var byte TeamIndex;
    var string PlayerName;
    var string SlotPathName;
    var int SlotIdx;
    var array<InventoryRecord> InventoryRecords;
    var bool bAllowCombatTransitions;
    var EvilTypes.EAggressionLevel AggressionLevel;
    var EvilTypes.EBehaviorMode BehaviorMode;
    var int HeadClothIndex;
    var int EquipmentClothIndex;
    var ReplicatedClothMaterial ClothMaterials[32];
    var ReplicatedClothInfo ClothesInfo[32];
    var ReplicatedClothMaterial ClothShield;
    var int BossStageId;

    structdefaultproperties
    {
        SavedGuid=(A=0,B=0,C=0,D=0)
        PawnHealthPct=0.0000000
        PawnClassName=""
        RidableClassName=""
        PawnPathName=""
        MoveActionPathName=""
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rotation=(Pitch=0,Yaw=0,Roll=0)
        BasePathName=""
        TeamIndex=0
        PlayerName=""
        SlotPathName=""
        SlotIdx=0
        InventoryRecords=none
        bAllowCombatTransitions=false
        AggressionLevel=EAggressionLevel.AL_None
        BehaviorMode=EBehaviorMode.BM_None
        HeadClothIndex=0
        EquipmentClothIndex=0
        ClothMaterials[0]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
        ClothMaterials[1]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
        ClothMaterials[2]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
        ClothMaterials[3]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
        ClothMaterials[4]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
        ClothMaterials[5]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
        ClothMaterials[6]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
        ClothMaterials[7]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
        ClothMaterials[8]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
        ClothMaterials[9]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
        ClothMaterials[10]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
        ClothMaterials[11]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
        ClothMaterials[12]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
        ClothMaterials[13]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
        ClothMaterials[14]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
        ClothMaterials[15]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
        ClothMaterials[16]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
        ClothMaterials[17]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
        ClothMaterials[18]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
        ClothMaterials[19]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
        ClothMaterials[20]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
        ClothMaterials[21]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
        ClothMaterials[22]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
        ClothMaterials[23]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
        ClothMaterials[24]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
        ClothMaterials[25]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
        ClothMaterials[26]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
        ClothMaterials[27]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
        ClothMaterials[28]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
        ClothMaterials[29]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
        ClothMaterials[30]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
        ClothMaterials[31]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
        ClothesInfo[0]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
        ClothesInfo[1]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
        ClothesInfo[2]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
        ClothesInfo[3]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
        ClothesInfo[4]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
        ClothesInfo[5]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
        ClothesInfo[6]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
        ClothesInfo[7]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
        ClothesInfo[8]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
        ClothesInfo[9]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
        ClothesInfo[10]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
        ClothesInfo[11]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
        ClothesInfo[12]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
        ClothesInfo[13]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
        ClothesInfo[14]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
        ClothesInfo[15]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
        ClothesInfo[16]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
        ClothesInfo[17]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
        ClothesInfo[18]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
        ClothesInfo[19]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
        ClothesInfo[20]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
        ClothesInfo[21]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
        ClothesInfo[22]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
        ClothesInfo[23]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
        ClothesInfo[24]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
        ClothesInfo[25]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
        ClothesInfo[26]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
        ClothesInfo[27]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
        ClothesInfo[28]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
        ClothesInfo[29]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
        ClothesInfo[30]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
        ClothesInfo[31]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
        ClothShield=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
        BossStageId=0
    }
};

var Guid MyGuid;
var SeqAct_AIMoveToActor PendingCheckpointMoveAction;
var SeqAct_AIMoveToActor MoveAction;
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
var bool bNotifiesInRange;
var bool bAllowCombatTransitions;
var bool bIgnoreStepAside;
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
var class<EvilAICmd_MoveToGoal> MoveCommand;
var class<EvilAICmd_Attack_Throw> ThrowCommand;
var class<EvilAICmd_Strafe> StrafeCommand;
var array<EvilStrafeData> StrafesData;
var int LastStrafeIndex;
var float LastStrafeTime;
var() config float EnemyDistance_Shoot;
var() config float EnemyDistance_Throw;
var() config float EnemyDistance_Melee;
var() config float EnemyDistance_MeleeCharge;
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
var float LastMeleeCommandTime;
var() config float TimeBetweenMeleeCommands;
var() config float TimeBetweenThrows;
var float LastThrowGrenadeTime;
var() config float BurstFireTimeout;
var() config float BurstFireSpreadTime;
var() config float BurstFireLag;
var array<AICharacterInfo> EnemyInfoList;
var AICharacterInfo LastActiveEnemyInfo;
var int LastActiveEnemyIndex;
var array<AICharacterInfo> FriendInfoList;
var EvilTypes.EBehaviorMode CurrentBehaviorMode;
var EvilTypes.EBehaviorMode LastBehaviorMode;
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
var name DebugActualState;
var name DebugOldState;
//var delegate<RateStrafe> __RateStrafe__Delegate;
//var delegate<ShouldBroadcastDelegate> __ShouldBroadcastDelegate__Delegate;

delegate float RateStrafe(EvilStrafeData StrafeData, const out array<EvilStrafeData> StrafeDataArray)
{
    //return ReturnValue;    
}

delegate bool ShouldBroadcastDelegate(EvilAIController Receiver, Pawn P, EvilAIController.EPerceptionType Pt, optional name EventName, optional float RadiusSq)
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
    return ((EvilAICommand(GetActiveCommand()) != none) ? EvilAICommand(GetActiveCommand()) : none);
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
    AutoAcquireEnemy();
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
    // End:0x1E3
    if(destActor != none)
    {
        ScriptedRoute = Route(destActor);
        // End:0xF8
        if(ScriptedRoute != none)
        {
            // End:0xB1
            if(ScriptedRoute.RouteList.Length == 0)
            {                
            }
            else
            {
                ScriptedRouteIndex = 0;
                // End:0xF5
                if(!IsInState('ScriptedRouteMove'))
                {
                    BeginCombatCommand(Class'EvilAICmd_Base_ScriptedRouteMove', "ScriptedRouteMove", true);
                }
            }            
        }
        else
        {
            ScriptedMoveTarget = destActor;
            // End:0x13F
            if(!IsInState('ScriptedMove'))
            {
                BeginCombatCommand(Class'EvilAICmd_Base_ScriptedMove', "ScriptedMove", true);
            }
        }
        ScriptedFocus = none;
        // End:0x1CC
        foreach Action.LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Look At")
        {
            ScriptedFocus = Actor(ObjVar.GetObjectValue());
            // End:0x1CB
            if(ScriptedFocus != none)
            {
                // End:0x1CC
                break;
            }            
        }        
        MoveAction = Action;        
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
    // End:0x38
    if(InAllowMove)
    {
        bOldMoveAroundWhenIdle = bMoveAroundWhenIdle;
        bMoveAroundWhenIdle = false;
    }
    bAllowCombatTransitions = false;
    // End:0x65
    if(InAbortCommandList)
    {
        AbortCommand(CommandList);
    }
    // End:0x91
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
    ThrowLocationShift.X = RandRange(-50.0000000, 50.0000000);
    ThrowLocationShift.Y = RandRange(-50.0000000, 50.0000000);
    ThrowLocation += (((Loc - ThrowLocation) * 0.3000000) + ThrowLocationShift);
    // End:0x1FB
    if(IsZero(SuggestedTossVelocity))
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
    // End:0x14C
    if((IsAiming()) && (ShotTarget != none) || ShotTargetActor != none)
    {
        // End:0x149
        if((MyEvilPawn.GetAimingTotalWeight() > 0.9000000) && (((HasValidEnemy()) && GetEnemyInfo().Pawn == ShotTarget) && GetEnemyInfo().DistanceToEnemy < EnemyDistance_Melee) || IsWeaponAimingAt(((ShotTargetActor != none) ? ShotTargetActor : ShotTarget), TargettedAimEpsilon))
        {
            ReactionManager.NudgeChannel(((ShotTargetActor != none) ? ShotTargetActor : ShotTarget), 'TargetAimed');
        }        
    }
    else
    {
        ReactionManager.NudgeChannel(self, 'AbortedAiming');
    }
    //return;    
}

function TickFire(float DeltaTime)
{
    local Actor Obstacle;
    local EvilPawn EvilPawnOstacle;

    BurstTimeLeft -= DeltaTime;
    // End:0x9C
    if(((BurstTimeLeft <= 0.0000000) || !HasValidEnemy()) || EvilWeap_Base(MyEvilPawn.Weapon).IsReloading())
    {
        MyEvilPawn.OnStopFire();        
    }
    else
    {
        // End:0x179
        if(!MyEvilPawn.IsFiring() || FireTime <= 0.0000000)
        {
            // End:0x142
            if(FireDelay > 0.0000000)
            {
                FireDelay -= DeltaTime;
                // End:0x13F
                if(MyEvilPawn.IsFiring())
                {
                    MyEvilPawn.StopFire(0);
                }                
            }
            else
            {
                MyEvilPawn.StartFire(0);
                FireTime = BurstTimeLeft;
            }            
        }
        else
        {
            // End:0x1A0
            if(FireTime > 0.0000000)
            {
                FireTime -= DeltaTime;
            }
        }
    }
    // End:0x1E3
    if(bShouldStopFiringWithLag)
    {
        // End:0x1D7
        if(BurstTimeLeft > BurstFireLag)
        {
            BurstTimeLeft = BurstFireLag;
        }
        bShouldStopFiringWithLag = false;
    }
    // End:0x2CA
    if(!ClearFireLineToActor(ShotTarget,,, Obstacle))
    {
        EvilPawnOstacle = EvilPawn(Obstacle);
        // End:0x2CA
        if((EvilPawnOstacle != none) && EvilPawnOstacle.MyEvilAI != none)
        {
            MyEvilPawn.OnStopFire();
            EvilPawnOstacle.MyEvilAI.NotifyOnFireLine(MyEvilPawn, EvilPawn(Enemy));
        }
    }
    //return;    
}

function NotifyOnFireLine(EvilPawn Attacker, EvilPawn AttackerEnemy)
{
    // End:0xA2
    if(((Attacker.IsSameTeam(MyEvilPawn) && !Attacker.bMovingToCover) && !Attacker.IsInCover()) && int(Attacker.CurrentMoveMode) <= int(1))
    {
    }
    //return;    
}

function bool IsPointOnNavMesh(Vector Point)
{
    return !NavigationHandle.PointCheck(Point - ((vect(0.0000000, 0.0000000, 1.0000000) * Abs(MyEvilPawn.GetCollisionExtent().Z)) * 0.4000000), MyEvilPawn.GetCollisionExtent());
    //return ReturnValue;    
}

function bool IsAiming()
{
    return MyEvilPawn.IsAiming();
    //return ReturnValue;    
}

function bool IsFiring()
{
    return MyEvilPawn.IsFiring() || BurstTimeLeft > 0.0000000;
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
    return (((((((((((((((((((((((((((((((((((GetHumanReadableName()) @ "\nState A/P:") @ string(DebugActualState)) @ "/") @ string(DebugOldState)) @ "\n") @ string(Pawn.GetStateName())) @ "CL:") @ CommandListStack) @ "\nHealth:") @ string(Pawn.Health)) $ "/") $ string(Pawn.HealthMax)) @ "Phys") @ string(Pawn.Physics)) @ "\nRMM") @ string(Pawn.Mesh.RootMotionMode)) @ "\nFocus:") @ string(Focus)) @ "\nMoveTimer") @ string(MoveTimer)) @ "\nVelocity:") @ string(Pawn.Velocity)) @ "VelSize") @ string(VSize(Pawn.Velocity))) @ "\nAcceleration:") @ string(Pawn.Acceleration)) @ "\nEnemy") @ string(Enemy)) @ "Master") @ string(Master)) @ "\nBase") @ string(Pawn.Base)) @ ((Enemy != none) ? "\nEnemy Dist" @ string(VSize(Enemy.Location - Pawn.Location)) : "")) @ "\nTeam #:") @ string(GetTeamNum());
    //return ReturnValue;    
}

protected function SeeEnemyAI()
{
    local Pawn P;

    // End:0x85
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
    // End:0xFE
    if(!bVehicleTransition)
    {
        ReactionManager.Wipe();
        ReactionManager.Initialize();
    }
    // End:0x15D
    if(CanThrowAttack())
    {
        ReactionManager.NudgeChannel(self, 'UnBlockCheckFireLine');
        ReactionManager.NudgeChannel(self, 'UnBlockThrowing');
    }
    ChangeBehaviorMode(1);
    // End:0x1E6
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
    // End:0x33
    if(IsFiring())
    {
        TickFire(DeltaTime);
    }
    // End:0x53
    if(IsAiming())
    {
        TickAim(DeltaTime);
    }
    ReactionManager.Poll(DeltaTime);
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
    // End:0x26D
    foreach ImpactList(CurrentImpactInfo)
    {
        Obstacle = CurrentImpactInfo.HitActor;
        // End:0x26C
        if(((Obstacle != none) && Obstacle != A) && EvilAIBlockingVolume(Obstacle) == none)
        {
            // End:0x1D8
            if(!bIgnoreFarAwayObstacles)
            {
                bFireLineClear = false;
                goto J0x26D;                
            }
            else
            {
                // End:0x26C
                if((!bIgnoreDestroyPacks || EvilDestroyPackBase(Obstacle) == none) && VSizeSq(Obstacle.Location - Pawn.Location) < ((EnemyDistance_Shoot / float(2)) ** float(2)))
                {
                    bFireLineClear = false;
                    // [Explicit Continue]
                    goto J0x26D;
                }
            }
        }        
    }
    J0x26D:
    
    return bFireLineClear;
    //return ReturnValue;    
}

function bool ClearFireLineToEnemy(optional out Actor Obstacle, optional bool bIgnoreFarAwayObstacles, optional bool bIgnoreDestroyPacks, optional Vector InExtent = vect(1.0000000, 1.0000000, 1.0000000))
{
    return ClearFireLineToActor(Enemy,,, Obstacle, InExtent, bIgnoreFarAwayObstacles, bIgnoreDestroyPacks);
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
    
    return PositionList[BestEpsilonIndex];
    //return ReturnValue;    
}

function bool ClearSightToEnemy(optional out Actor Obstacle)
{
    return ClearSightToActor(Enemy,,, Obstacle);
    //return ReturnValue;    
}

function bool CanFastSpinUp(int YawDelta)
{
    return (((CommandList == none) || EvilAICmd_Base_Combat(CommandList) == none) || EvilAICmd_Base_Combat(CommandList).bCanOuterFastSpinUp) && MyEvilPawn.CanFastSpinUp();
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
    return ((WorldInfo.TimeSeconds - LastMeleeCommandTime) > TimeBetweenMeleeCommands) && !IsFiring();
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
    // End:0x50
    if(TestPawn.Controller != none)
    {
        return IsFriendly(TestPawn.Controller);        
    }
    else
    {
        // End:0xB2
        if(TestPawn.DrivenVehicle != none)
        {
            return IsFriendly(TestPawn.DrivenVehicle.Controller);
        }
    }
    return true;
    //return ReturnValue;    
}

function bool IsFriendly(Controller TestController)
{
    return (((TestController == none) || TestController.Pawn == none) || !TestController.Pawn.IsAliveAndWell()) || (MyEvilPawn != none) && MyEvilPawn.IsSameTeam(TestController.Pawn);
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

function ReceiveStimulus(Pawn Source, Pawn P, EvilAIController.EPerceptionType Pt, optional name EventName)
{
    ProcessStimulus(P, Pt, EventName);
    //return;    
}

function BroadcastStimulus(Pawn P, EvilAIController.EPerceptionType Pt, optional name EventName, optional float Radius, optional delegate<ShouldBroadcastDelegate> ShouldBroad = ShouldBroadcast)
{
    local EvilAIController C;
    local float RadiusSq;

    RadiusSq = Radius * Radius;
    // End:0xE9
    foreach WorldInfo.AllControllers(Class'EvilAIController', C)
    {
        // End:0xE8
        if(ShouldBroadcastDelegate(C, P, Pt, EventName, RadiusSq))
        {
            C.ReceiveStimulus(Pawn, P, 3, EventName);
        }        
    }    
    //return;    
}

function bool ProcessStimulus(Pawn P, EvilAIController.EPerceptionType Pt, optional name EventName)
{
    local EvilPlayerController PC;
    local int PawnListIndex;
    local EvilPawn EP;
    local bool bIsFriend;

    // End:0x61
    if(P.IsA('Vehicle'))
    {
        EP = EvilPawn(Vehicle(P).Driver);        
    }
    else
    {
        EP = EvilPawn(P);
    }
    // End:0xC3
    if(((P == none) || EP == none) || P.bAmbientCreature)
    {
        return false;
    }
    PC = EvilPlayerController(EP.Controller);
    // End:0x16F
    if((PC == none) && EP.DrivenVehicle != none)
    {
        PC = EvilPlayerController(EP.DrivenVehicle.Controller);
    }
    // End:0x1CA
    if(((PC != none) && PC.IsDead()) || !EP.IsAliveAndWell())
    {
        return false;
    }
    // End:0x27F
    if(!EP.CanBeAttacked(MyEvilPawn) || ((CustomSightRadius > 0.0000000) && int(Pt) != int(2)) && VSizeSq(P.Location - MyEvilPawn.Location) > (CustomSightRadius * CustomSightRadius))
    {
        return false;
    }
    PawnListIndex = GetAIEnemyInfoIdx(EP);
    // End:0x2BA
    if(PawnListIndex >= 0)
    {
        bIsFriend = false;        
    }
    else
    {
        PawnListIndex = GetAIFriendInfoIdx(EP);
        // End:0x2F5
        if(PawnListIndex >= 0)
        {
            bIsFriend = true;            
        }
        else
        {
            bIsFriend = IsFriendly(EP.Controller);
        }
    }
    // End:0x3DA
    if(((EventName == 'SetTeam') && PawnListIndex >= 0) && bIsFriend != (IsFriendly(EP.Controller)))
    {
        // End:0x3AE
        if(bIsFriend)
        {
            FriendInfoList.Remove(PawnListIndex, 1);            
        }
        else
        {
            EnemyInfoList.Remove(PawnListIndex, 1);
        }
        bIsFriend = !bIsFriend;
    }
    PawnListIndex = ((bIsFriend) ? AddFriend(EP) : AddEnemy(EP));
    // End:0x42E
    if(PawnListIndex == -1)
    {
        return false;
    }
    // End:0x48F
    if(int(Pt) == int(0))
    {
        // End:0x48F
        if(EP.IsHumanControlled())
        {
            ReactionManager.NudgePerceptionChannel(EP, 4);
        }
    }
    // End:0x4E0
    if(bIsFriend)
    {
        GetAIEnemyInfoIdx(EP);
        UpdateFriendlyCharacterInfo(EP, Pt, EventName, PawnListIndex);        
    }
    else
    {
        GetAIFriendInfoIdx(EP);
        ReactionManager.NudgePerceptionChannel(EP, Pt);
        UpdateEnemyCharacterInfo(EP, Pt, EventName, PawnListIndex);
    }
    // End:0x609
    if(!IgnoreNotifies() && !bIsFriend)
    {
        // End:0x59C
        if(int(Pt) == int(0))
        {
            NotifyEnemySeen(EP);            
        }
        else
        {
            // End:0x5CC
            if(int(Pt) == int(1))
            {
                NotifyEnemyHeard(EP, EventName);
            }
        }
        // End:0x5F6
        if(int(Pt) == int(3))
        {
            NoticedEnemy(EP);            
        }
        else
        {
            UpdateEnemy(EP);
        }
    }
    // End:0x65E
    if(bNotifiesInRange && EventName != 'AlertedByPawn')
    {
        BroadcastStimulus(EP, Pt, 'AlertedByPawn', NotifiesInRangeRadius);
    }
    return false;
    //return ReturnValue;    
}

function ChangeBehaviorMode(EvilTypes.EBehaviorMode InNewMode)
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

function bool CanChangeBehaviorMode(EvilTypes.EBehaviorMode InNewMode, EvilTypes.EBehaviorMode InOldMode)
{
    // End:0x1D
    if(int(InNewMode) == int(InOldMode))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function BehaviorModeChanged(EvilTypes.EBehaviorMode InNewMode, EvilTypes.EBehaviorMode InOldMode)
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
        // End:0xAA
        if((int(InNewMode) == int(2)) || int(InNewMode) == int(3))
        {
            BeginCombatCommand(DefaultCommand);
        }
    }
    // End:0xEA
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
    SetAttackBehavior();
    //return;    
}

function SetAttackBehavior()
{
    // End:0x20
    if(int(CurrentBehaviorMode) < int(3))
    {
        ChangeBehaviorMode(3);
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

    // End:0x6C
    foreach LatentActions(Action)
    {
        // End:0x6B
        if((SeqAct_AIMoveToActor(Action) != none) && SeqAct_AIMoveToActor(Action).bInterruptable)
        {
            bInteruptable = true;            
        }
        else
        {            
        }
    }    
    // End:0xCC
    if((((SeenPawn != none) && !MyEvilPawn.IsSameTeam(SeenPawn)) && bInteruptable) && AbortMoving())
    {        
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
    // End:0x132
    if(CmdClass != none)
    {
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

function bool ShouldReturnToIdle()
{
    return (!HasAnyEnemies() && LatentActions.Length <= 0) && !((CommandList != none) && EvilAICommand(CommandList) != none) && !EvilAICommand(CommandList).ShouldReturnToIdle();
    //return ReturnValue;    
}

function CheckTimedCombatTransition()
{
    local EvilAICmd_Base_Combat CurCombatCommand;
    local class<EvilAICmd_Base_Combat> NewCommand;
    local bool bTransition;
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
    bTransition = !CheckInterruptCombatTransitions();
    // End:0xFD
    if(bTransition)
    {
        // End:0xFD
        if(CurCombatCommand.CheckTransition(NewCommand, Reason))
        {
            BeginCombatCommand(NewCommand, Reason);
        }
    }
    //return;    
}

function bool CheckInterruptCombatTransitions()
{
    local EvilAICmd_Base_Combat CurCombatCommand;
    local Pawn EnemyPawn;

    // End:0x2F
    if(((Pawn == none) || IsDead()) || IgnoreNotifies())
    {
        return false;
    }
    CurCombatCommand = EvilAICmd_Base_Combat(CommandList);
    // End:0x5C
    if(CurCombatCommand == none)
    {
        return false;
    }
    // End:0x8B
    if(ShouldReturnToIdle())
    {
        BeginCombatCommand(none, "ShouldReturnToIdle");
        return true;
    }
    // End:0x114
    if(((CanEngageMelee()) && HasEnemyWithinDistance(EnemyDistance_MeleeCharge, EnemyPawn)) && !CommandList.IsA('EvilAICmd_Base_Melee'))
    {
        ReactionManager.NudgeChannel(EnemyPawn, 'EnemyWithinMeleeChargeDistance');
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CheckCombatTransition()
{
    local bool bTransition;
    local EvilAICmd_Base_Combat CurCombatCommand;
    local class<EvilAICmd_Base_Combat> NewCommand;
    local string Reason;

    bTransition = !CheckInterruptCombatTransitions();
    // End:0x108
    if(bTransition)
    {
        CurCombatCommand = EvilAICmd_Base_Combat(CommandList);
        // End:0xA5
        if((CurCombatCommand != none) && CurCombatCommand.CheckTransition(NewCommand, Reason))
        {
            BeginCombatCommand(NewCommand, Reason);            
        }
        else
        {
            // End:0x108
            if(CurCombatCommand == none)
            {
                NewCommand = GetDefaultCommand();
                // End:0xD9
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
    // End:0x39
    if((ShotTarget == none) || ClearFireLineToActor(ShotTarget, StrafePoint, true))
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

    StrafeDistanceSq = VSizeSq(MyEvilPawn.Location - StrafeData.StrafePoint);
    Rating = 1.0000000;
    // End:0x291
    foreach WorldInfo.AllControllers(Class'EvilAIController', EvilController)
    {
        // End:0x290
        if(((EvilController != self) && EvilController.IsFriendly(self)) && EvilController.Enemy != none)
        {
            FireLine = EvilController.Enemy.Location - MyEvilPawn.Location;
            FriendlyFireLine = EvilController.Enemy.Location - EvilController.MyEvilPawn.Location;
            Proj = ProjectOnTo(FireLine, FriendlyFireLine);
            PerpVect = FireLine - Proj;
            PerpDotStrafe = Normal(PerpVect) Dot Normal(StrafeData.StrafePoint - MyEvilPawn.Location);
            OpRatingSum += FClamp(PerpDotStrafe * (StrafeDistanceSq / (VSizeSq(PerpVect) + 1.0000000)), -1.0000000, 1.0000000);
            FriendlyCount++;
        }        
    }    
    // End:0x2D6
    if(FriendlyCount > 0)
    {
        Rating -= FPctByRange(OpRatingSum / float(FriendlyCount), -1.0000000, 1.0000000);
    }
    return Rating;
    //return ReturnValue;    
}

function float OnRateStrafeByFlankEnemy(EvilStrafeData StrafeData, const out array<EvilStrafeData> StrafeDataArray)
{
    return (OnRateStrafe(StrafeData, StrafeDataArray)) * (RateStrafeByFlankEnemy(StrafeData, StrafeDataArray));
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
    local float Rating, StrafeToEnemyDistanceSq;

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
    Rating *= ((StrafeData.bEnemyReachable) ? 1.0000000 : 0.9000000);
    StrafeToEnemyDistanceSq = ((Enemy != none) ? VSizeSq(Enemy.Location - StrafeData.StrafePoint) : 0.0000000);
    // End:0x233
    if((int(CurrentAggressionLevel) < int(3)) || StrafeToEnemyDistanceSq < Square(EnemyDistance_MinimalStrafeDistance))
    {
        Rating *= (1.0000000 - FMin(0.9000000, ((Enemy != none) ? ((MyEvilPawn.GetCollisionRadius() ** float(2)) / (StrafeToEnemyDistanceSq + 1.0000000)) + 0.1000000 : 0.0000000)));        
    }
    else
    {
        Rating *= FMin(1.0000000, ((Enemy != none) ? ((MyEvilPawn.GetCollisionRadius() ** float(2)) / (StrafeToEnemyDistanceSq + 1.0000000)) + 0.1000000 : 0.0000000));
    }
    Rating *= ((((IsStrafesOppositeDirection(StrafeData.StrafeDirection, StrafeDataArray[LastStrafeIndex].StrafeDirection)) || (StrafeDataArray[LastStrafeIndex].StrafeDistance <= 100.0000000) && StrafeData.StrafeDistance <= 100.0000000) && WorldInfo.TimeSeconds <= (StrafeDataArray[LastStrafeIndex].LastStrafeTime + 2.0000000)) ? 0.0000000 : 1.0000000);
    return Rating;
    //return ReturnValue;    
}

function CalculateStrafePointsRating(optional out array<EvilStrafeData> InStrafesDate, optional delegate<RateStrafe> RateStrafeDelegate = OnRateStrafe, optional Actor InFocus, optional float StrafeDistance = 100.0000000)
{
    local int I;

    I = 0;
    J0x2B:

    // End:0x3F8 [Loop If]
    if(I < InStrafesDate.Length)
    {
        // End:0x258
        if(int(InStrafesDate[I].StrafeDirection) != int(0))
        {
            // End:0x13F
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
        I++;
        // [Loop Continue]
        goto J0x2B;
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
    // End:0x48
    if(InStrafeData.Length == 0)
    {
        return BestIndex;
    }
    CalculateStrafePointsRating(InStrafeData, RateStrafeDelegate, InFocus, StrafeDistance);
    // End:0x167
    foreach InStrafeData(StrafeDataElement, I)
    {
        // End:0x114
        if(StrafeDataElement.Rating > BestRating)
        {
            BestRatingIndexes.Remove(0, BestRatingIndexes.Length);
            BestRating = StrafeDataElement.Rating;
            BestRatingIndexes.AddItem(I);            
        }
        else
        {
            // End:0x166
            if((BestRatingIndexes.Length > 0) && StrafeDataElement.Rating == BestRating)
            {
                BestRatingIndexes.AddItem(I);
            }
        }        
    }    
    // End:0x198
    if(BestRatingIndexes.Length > 0)
    {
        BestIndex = BestRatingIndexes[Rand(BestRatingIndexes.Length)];
    }
    return BestIndex;
    //return ReturnValue;    
}

function bool CheckStrafePointReachability(Vector StrafePoint)
{
    // End:0x2F
    if(NavigationHandle.PointReachable(StrafePoint))
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
    InvalidateCoverAction();
    InvalidateCover();
    // End:0x3C
    if(InFocus != none)
    {
        Focus = InFocus;
    }
    // End:0x7D
    if(!bOverrideStrafePoint && !StrafeCommand.static.GetStrafePoint(self, StrafePoint))
    {
        return false;
    }
    // End:0xAC
    if(StrafeCommand.static.Strafe(self, false, StrafePoint))
    {
        return true;
    }
    return false;
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

function Rotator GetAimRotation(EvilTypes.EAimZone InAimZone, optional Actor InTarget)
{
    local Rotator RetAimRotation, DeltaRot;

    // End:0x35
    if(Pawn(InTarget) != none)
    {
        ShotTarget = Pawn(InTarget);
    }
    // End:0x82
    if(int(InAimZone) != int(0))
    {
        // End:0x67
        if(ShotTargetActor != none)
        {
            InAimZone = 1;            
        }
        else
        {
            // End:0x82
            if(ShotTarget == none)
            {
                InAimZone = 0;
            }
        }
    }
    // End:0x2CC
    if(((int(MyEvilPawn.PawnAction) == 0) || MyEvilPawn.PawnActions[int(MyEvilPawn.PawnAction)] == none) || !MyEvilPawn.PawnActions[int(MyEvilPawn.PawnAction)].AimOffsetOverride(DeltaRot))
    {
        switch(InAimZone)
        {
            // End:0x197
            case 0:
                RetAimRotation = MyEvilPawn.Rotation;
                // End:0x2C9
                break;
            // End:0x21E
            case 1:
                RetAimRotation = GetAdjustedAimRotation(((ShotTargetActor != none) ? ShotTargetActor.Location : ShotTarget.Location), MyEvilPawn.Location);
                // End:0x2C9
                break;
            // End:0x296
            case 2:
                RetAimRotation = GetAdjustedAimRotation(ShotTarget.Mesh.GetBoneLocation('Head', 0), MyEvilPawn.Location);
                // End:0x2C9
                break;
            // End:0x2C6
            case 3:
                RetAimRotation = MyEvilPawn.AimRotation;
                // End:0x2C9
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
    switch(MyEvilPawn.CurrentMoveMode)
    {
        // End:0x2D
        case 3:
        // End:0x3B
        case 2:
            return 30.0000000;
            // End:0x3E
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0x87
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
    MyEvilPawn.AimRotation = GetAimRotation(InAimZone);
    // End:0xC0
    if((!MyEvilPawn.IsInCover() && HasValidEnemy()) && (WorldInfo.TimeSeconds - GetEnemyInfo().LastSeenTime) > float(1))
    {
        InAimZone = 3;
    }
    // End:0x1F8
    if(((((ShotTarget == none) && ShotTargetActor == none) || int(InAimZone) == int(0)) || Abs(RDiff(MyEvilPawn.AimRotation, MyEvilPawn.Rotation)) > (GetMaxAimAngle())) || MyEvilPawn.FullBodyAnimSlot.bIsPlayingCustomAnim && !MyEvilPawn.bAimWhenFullBodySlotAnim)
    {
        // End:0x1EC
        if(IsFiring())
        {
            // End:0x1E9
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

function NotifyEnemySeen(Pawn InEnemy)
{
    // End:0x2D
    if(Enemy == none)
    {
        ProcessStimulus(InEnemy, 3, 'Seen new enemy');
    }
    //return;    
}

function NotifyEnemyHeard(Pawn InEnemy, name NoiseType)
{
    // End:0x2D
    if(Enemy == none)
    {
        ProcessStimulus(InEnemy, 3, 'Heard new enemy');
    }
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
    InvalidateCoverAction();
    InvalidateCover();
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
    // End:0x5C
    if(Enemy == none)
    {
        // End:0x2F
        if(int(CurrentBehaviorMode) == int(1))
        {
            ChangeBehaviorMode(2);
        }
        MyEvilPawn.PlaySoundFromArchetypeByChance(4);
        SelectEnemy();
    }
    MyEvilPawn.TriggerEventClass(Class'SeqEvent_SeeEvilEnemy', InEnemy);
    SelectTarget();
    CheckCombatTransition();
    //return;    
}

function bool IsAttacking()
{
    return ((EvilAICmd_Base_Melee(CommandList) != none) || IsFiring()) || IsAiming();
    //return ReturnValue;    
}

function UpdateEnemy(Pawn InEnemy)
{
    // End:0x19
    if(!IsAttacking())
    {
        SelectTarget();
    }
    //return;    
}

function NotifyMoveModeChanged(EvilTypesNative.EMoveMode InNewMode, EvilTypesNative.EMoveMode InOldMode)
{
    // End:0x3C
    if((IsFiring()) || IsAiming())
    {
        MyEvilPawn.ToggleAimingAnimMode();
    }
    switch(InNewMode)
    {
        // End:0x57
        case 0:
            // End:0x6A
            break;
        // End:0x5F
        case 1:
            // End:0x6A
            break;
        // End:0x67
        case 2:
            // End:0x6A
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
    // End:0x96
    if(Killed.bIsPlayer)
    {
        ReactionManager.NudgeChannel(Killed.Pawn, 'PlayerKilled');
    }
    GetAIEnemyInfoIdx(none);
    //return;    
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

    // End:0x1A9
    if(InstigatedBy != none)
    {
        // End:0x162
        if(!IsFriendlyPawn(InstigatedBy.Pawn) && int(InstigatedBy.GetTeamNum()) != int(GetTeamNum()))
        {
            super(Controller).NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
            ReactionManager.IncomingDamage(InstigatedBy.Pawn, true, DamageType, HitInfo, InstigatedBy.Pawn.Location, Damage);
            ProcessStimulus(InstigatedBy.Pawn, 2);            
        }
        else
        {
            // End:0x1A9
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
            // End:0x107
            if(EvilPawn(NoiseMaker.Owner) != none)
            {
                Heard = EvilPawn(NoiseMaker.Owner);
            }
        }
    }
    // End:0x15E
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
    // End:0xCF
    if((NoiseType == 'NOISETYPE_FootStep') || (EvilPawn(Heard) != none) && EvilPawn(Heard).IsInStealthMode())
    {
        // End:0xCC
        if(DistSq > (EnemyDistance_HearFootSteps * EnemyDistance_HearFootSteps))
        {
            return false;
        }        
    }
    else
    {
        // End:0x1E2
        if(MyEvilPawn.GetSoundSetTypeFromString(NoiseType, SoundSetType, HearReplyFlag))
        {
            MyEvilPawn.SoundGroupClass.static.GetSoundSetNoiseInfo(MyEvilPawn, SoundSetType, ((HearReplyFlag > -1) ? true : false), SoundSetNoiseInfo);
            // End:0x1E2
            if((SoundSetNoiseInfo.Range > 0) && DistSq > float(SoundSetNoiseInfo.Range * SoundSetNoiseInfo.Range))
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

function bool IsCoverExposedToAnEnemy(CoverInfo TestCover, optional Pawn TestEnemy, optional out float out_ExposedScale)
{
    return true;
    //return ReturnValue;    
}

function float GetPawnSpotChance(Pawn Seen)
{
    return FClamp(1.0000000 - FPctByRange(VSizeSq(Seen.Location - MyEvilPawn.Location), SightSenseDistanceThreshold * SightSenseDistanceThreshold, MyEvilPawn.SightRadius * MyEvilPawn.SightRadius), 0.0000000, 1.0000000) ** float(3);
    //return ReturnValue;    
}

event SeeMonster(Pawn Seen)
{
    // End:0x49
    if((Enemy == Seen) || FRand() < (GetPawnSpotChance(Seen)))
    {
        ProcessStimulus(Seen, 0);
    }
    //return;    
}

event SeePlayer(Pawn Seen)
{
    super(Controller).SeePlayer(Seen);
    // End:0x5F
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

    // End:0xB9
    foreach WorldInfo.AllControllers(Class'Engine.Controller', PotentialEnemy)
    {
        // End:0xB8
        if((PotentialEnemy != self) && PotentialEnemy.Pawn != none)
        {
            // End:0xB8
            if(!IsFriendly(PotentialEnemy))
            {
                ProcessStimulus(PotentialEnemy.Pawn, 3, GetFuncName());
                // End:0xB8
                continue;
            }
        }        
    }    
    //return;    
}

function bool HasValidEnemy()
{
    return (Enemy != none) && !IsFriendlyPawn(Enemy);
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
    local float EnemyRating;

    // End:0xB2
    foreach EnemyInfoList(EI)
    {
        // End:0xB1
        if((EI.Pawn != none) && EI.Rating > EnemyRating)
        {
            Selected = EI.Pawn;
            EnemyRating = EI.Rating;
        }        
    }    
    // End:0xD8
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
    // End:0xD4
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

    // End:0x10E [Loop If]
    if(Idx < EnemyInfoList.Length)
    {
        // End:0xC2
        if((EnemyInfoList[Idx].Pawn == none) || !EnemyInfoList[Idx].Pawn.IsAliveAndWell())
        {
            EnemyInfoList.Remove(Idx--, 1);
            // End:0xBF
            if(EnemyInfoList.Length > 0)
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
        if(EnemyInfoList[Idx].Pawn == InEnemy)
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

function UpdateEnemyCharacterInfo(Pawn P, EvilAIController.EPerceptionType Pt, name EventName, int PawnListIndex)
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
        // End:0xBE
        case 3:
            UpdateEnemyInfo(PawnListIndex, P, P.GetPawnViewLocation());
            // End:0x104
            break;
        // End:0x101
        case 1:
            UpdateEnemyInfo(PawnListIndex, P, P.GetPawnViewLocation());
            // End:0x104
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

function UpdateFriendlyCharacterInfo(Pawn P, EvilAIController.EPerceptionType Pt, name EventName, int PawnListIndex)
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

function UpdateEnemyInfo(int EnemyIdx, Pawn InEnemy, Vector InViewLocation)
{
    EnemyInfoList[EnemyIdx].Pawn = EvilPawn(InEnemy);
    EnemyInfoList[EnemyIdx].KnownLocation = InViewLocation;
    EnemyInfoList[EnemyIdx].DistanceToEnemy = VSize(Pawn.Location - InViewLocation);
    EnemyInfoList[EnemyIdx].LastUpdateTime = WorldInfo.TimeSeconds;
    EnemyInfoList[EnemyIdx].bInitialized = true;
    // End:0x285
    if(EnemyInfoList[EnemyIdx].Pawn != none)
    {
        EnemyInfoList[EnemyIdx].Controller = EvilAIController(InEnemy.Controller);
        EnemyInfoList[EnemyIdx].LastKnownVelocity = EnemyInfoList[EnemyIdx].Pawn.Velocity;
        EnemyInfoList[EnemyIdx].Rating = GetEnemyRating(EnemyInfoList[EnemyIdx].Pawn, EnemyInfoList[EnemyIdx].DistanceToEnemy);        
    }
    else
    {
        EnemyInfoList[EnemyIdx].Controller = none;
        EnemyInfoList[EnemyIdx].LastKnownVelocity = vect(0.0000000, 0.0000000, 0.0000000);
        EnemyInfoList[EnemyIdx].Rating = 0.0000000;
    }
    //return;    
}

function bool HasEnemyWithinDistance(float Distance, optional out Pawn OutEnemy, optional float MinimalDistance)
{
    local AICharacterInfo EI;
    local float DistanceToEnemySq;

    // End:0x108
    foreach EnemyInfoList(EI)
    {
        // End:0x107
        if(EI.Pawn != none)
        {
            DistanceToEnemySq = VSizeSq(EI.Pawn.Location - Pawn.Location);
            // End:0x107
            if((DistanceToEnemySq < (Distance * Distance)) && DistanceToEnemySq > (MinimalDistance * MinimalDistance))
            {
                OutEnemy = EI.Pawn;                
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

final function SetEnemyMoveGoal(optional float InGoalDistance = 0.0000000, optional bool bInUpdateGoal, optional bool bInForceWalk, optional bool bInShiftDestination = false, optional float InTimedOut = -1.0000000, optional bool bInStopWhenSeeEnemy = false)
{
    Class'EvilAICmd_MoveToEnemy'.static.MoveToEnemy(self, InGoalDistance, bInShiftDestination, InTimedOut, bInUpdateGoal, bInForceWalk, bInStopWhenSeeEnemy);
    //return;    
}

function SetSpecialMoveGoal(Actor InGoal, optional float InGoalDistance = 0.0000000, optional bool bInUpdateGoal, optional bool bInForceWalk, optional bool bInShiftDestination = false)
{
    local EvilNavPointInterface INavPoint;
    local EvilTypesNative.EMoveMode MoveMode;

    INavPoint = EvilNavPointInterface(InGoal);
    MoveMode = ((EqualEqual_InterfaceInterface(INavPoint, EvilNavPointInterface(none))) ? MyEvilPawn.SupremeMoveMode : INavPoint.GetMoveMode());
    MyEvilPawn.ForceLimitedMoveMode(MoveMode);
    // End:0x11B
    if(EqualEqual_InterfaceInterface(INavPoint, EvilNavPointInterface(none)))
    {
        SetMoveGoal(InGoal, InGoalDistance, bInUpdateGoal, bInForceWalk, bInShiftDestination);        
    }
    else
    {
        switch(INavPoint.GetMoveToGoalMode())
        {
            // End:0x187
            case 0:
                SetMoveGoal(InGoal, InGoalDistance, bInUpdateGoal, bInForceWalk, bInShiftDestination);
                // End:0x1CA
                break;
            // End:0x1C7
            case 1:
                // End:0x1C4
                if(CoverLink(InGoal) != none)
                {
                    SetCoverLinkGoal(CoverLink(InGoal));                    
                }
                // End:0x1CA
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

final function SetMoveGoal(Actor InGoal, optional float InGoalDistance = 0.0000000, optional bool bInUpdateGoal, optional bool bInForceWalk, optional bool bInShiftDestination = false)
{
    MoveGoal = InGoal;
    MovePosition = vect(0.0000000, 0.0000000, 0.0000000);
    MoveOffset = InGoalDistance;
    // End:0xAC
    if(MoveCommand != none)
    {
        MoveCommand.static.MoveToGoal(self, InGoal, InGoalDistance, bInUpdateGoal, bInForceWalk, bInShiftDestination);
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
    // End:0x86
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

function bool GetUnstuckLocation(float Radius, out Vector OutLocation, Vector GoalLocation, optional bool bTraceDestLocation = false, optional float MinRadius = -1.0000000, optional bool bMustBeReachableFromStartPos)
{
    local int Idx, StartIdx;
    local array<Vector> Position;
    local Vector HitLocation, HitNormal;
    local Actor HitActor;
    local float bestDist;
    local bool bResult;

    // End:0x53
    if(MinRadius == float(-1))
    {
        MinRadius = Pawn.GetCollisionRadius() * float(2);
    }
    Class'Engine.NavigationHandle'.static.GetValidPositionsForBox(Pawn.Location, Radius, Pawn.GetCollisionExtent() + NavMeshPath_SearchExtent_Modifier, bMustBeReachableFromStartPos, Position, 5, MinRadius);
    // End:0xF4
    if(Position.Length <= 0)
    {
        return false;
    }
    // End:0x1BF
    if(!bTraceDestLocation)
    {
        Idx = 0;
        J0x10E:

        // End:0x1BC [Loop If]
        if(Idx < Position.Length)
        {
            // End:0x1AE
            if(!bResult || VSizeSq(Position[Idx] - GoalLocation) < bestDist)
            {
                OutLocation = Position[Idx];
                bestDist = VSizeSq(OutLocation - GoalLocation);
                bResult = true;
            }
            ++Idx;
            // [Loop Continue]
            goto J0x10E;
        }        
    }
    else
    {
        StartIdx = Rand(Position.Length);
        Idx = 0;
        J0x1E0:

        // End:0x370 [Loop If]
        if(Idx < Position.Length)
        {
            HitActor = Pawn.Trace(HitLocation, HitNormal, Position[StartIdx], Pawn.Location, true, Pawn.GetCollisionExtent());
            // End:0x340
            if(HitActor == none)
            {
                // End:0x2BA
                if(!bResult)
                {
                    OutLocation = Position[StartIdx];
                }
                bResult = true;
                // End:0x2DD
                if(FRand() < 0.1000000)
                {
                    return bResult;
                }
                // End:0x340
                if(VSizeSq(MyEvilPawn.Location - GoalLocation) > VSizeSq(OutLocation - GoalLocation))
                {
                    OutLocation = Position[StartIdx];
                }
            }
            StartIdx = (StartIdx + 1) % Position.Length;
            ++Idx;
            // [Loop Continue]
            goto J0x1E0;
        }
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

function float GetBaseEnemyRating(Pawn EnemyP, float Distance)
{
    local float AbsDistZ;

    AbsDistZ = Abs(EnemyP.Location.Z - MyEvilPawn.Location.Z);
    return (FMax(EnemyDistance_Melee, MyEvilPawn.GetCollisionRadius()) / (Distance + 1.0000000)) * ((AbsDistZ <= MyEvilPawn.MaxStepHeight) ? 1.0000000 : MyEvilPawn.MaxStepHeight / AbsDistZ);
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

function bool NotifyBump(Actor Other, Vector HitNormal)
{
    local Pawn bumpPawn;
    local EvilPawn WP;
    local bool bStimResult;
    local EvilAICmd_MoveToGoal ActiveMoveCmd;

    // End:0x0F
    if(IgnoreNotifies())
    {
        return false;
    }
    bumpPawn = Pawn(Other);
    // End:0x209
    if(bumpPawn != none)
    {
        ActiveMoveCmd = EvilAICmd_MoveToGoal(GetActiveCommand());
        // End:0xBA
        if((ActiveMoveCmd != none) && MoveGoal == bumpPawn)
        {
            ActiveMoveCmd.Status = 'Success';
            PopCommand(ActiveMoveCmd);
        }
        WP = EvilPawn(Other);
        // End:0x15C
        if(IsFriendlyPawn(bumpPawn))
        {
            // End:0x159
            if((Pawn.Base != bumpPawn) && bumpPawn.Base != Pawn)
            {
                StepAsideFor(bumpPawn);
            }            
        }
        else
        {
            bStimResult = ProcessStimulus(WP, 3, 'NotifyBump');
            // End:0x209
            if(!bDoingMeleeAttack)
            {
                // End:0x1FF
                if(((((WP != none) && CanEngageMelee()) && !IsFriendlyPawn(WP)) && bStimResult) && !IsFiring())
                {
                    DoMeleeAttack(WP);
                }
                CheckInterruptCombatTransitions();
            }
        }
    }
    return super(Controller).NotifyBump(Other, HitNormal);
    //return ReturnValue;    
}

singular event bool StepAsideFor(Pawn ChkPawn)
{
    local bool bResult, bStepAside, bDelayStep;
    local EvilAIController AI;
    local EvilPawn ChkEP;

    // End:0x323
    if(!bIgnoreStepAside && (MyEvilPawn == none) || !MyEvilPawn.IsDoingAPawnAction())
    {
        bResult = true;
        bStepAside = true;
        ChkEP = EvilPawn(ChkPawn);
        // End:0x15D
        if(((((ChkEP != none) && ChkEP.IsInCover()) && !ChkEP.IsHumanControlled()) && MoveGoal != none) && VSize2D(MoveGoal.GetDestination(self) - ChkEP.Location) < (256.0000000 * 256.0000000))
        {
            bResult = true;
            bStepAside = false;            
        }
        else
        {
            AI = EvilAIController(ChkPawn.Controller);
            // End:0x1E3
            if((AI != none) && AI.StepAsideGoal == Pawn)
            {
                bResult = true;
                bStepAside = false;
            }
            // End:0x2BF
            if((!ChkPawn.IsHumanControlled() && !IsZero(Pawn.Velocity)) && (Pawn.Velocity Dot ChkPawn.Velocity) > 0.0000000)
            {
                bDelayStep = ShouldDelayStepAside(ChkPawn);
                // End:0x2BF
                if(!bDelayStep)
                {
                    bResult = true;
                    bStepAside = false;
                }
            }
        }
        // End:0x323
        if(bStepAside && StepAsideGoal != ChkPawn)
        {
            bResult = Class'EvilAICmd_StepAside'.static.StepAside(self, ChkPawn, bDelayStep);
        }
    }
    return bResult;
    //return ReturnValue;    
}

function bool NeedReload()
{
    return (EvilWeap_Base(MyEvilPawn.Weapon) != none) && EvilWeap_Base(MyEvilPawn.Weapon).DesireAmmo(true) > 0.8000000;
    //return ReturnValue;    
}

function bool ShouldStartShootAttack()
{
    return !EvilGame(WorldInfo.Game).AIDirectorInstance.ReachedShootingIntensity(self);
    //return ReturnValue;    
}

function bool ShouldBroadcast(EvilAIController Receiver, Pawn P, EvilAIController.EPerceptionType Pt, optional name EventName, optional float RadiusSq)
{
    return ((Receiver != self) && Receiver.Pawn != none) && (RadiusSq <= 0.0000000) || VSizeSq(Receiver.Pawn.Location - Pawn.Location) < RadiusSq;
    //return ReturnValue;    
}

function bool ShouldBroadcastChangeTeam(EvilAIController Receiver, Pawn P, EvilAIController.EPerceptionType Pt, optional name EventName, optional float RadiusSq)
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

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    local InventoryRecord InvRecord;
    local EvilWeap_Base Weapon;
    local Pawn InvHolder;

    Record.SavedGuid = MyGuid;
    // End:0x70
    if(PlayerReplicationInfo != none)
    {
        Record.PlayerName = PlayerReplicationInfo.PlayerName;
    }
    // End:0x4DD
    if(Pawn != none)
    {
        Record.PawnHealthPct = float(Pawn.Health) / float(Pawn.HealthMax);
        // End:0x135
        if(MyEvilPawn != none)
        {
            Record.PawnClassName = PathName(Pawn.Class);            
        }
        else
        {
            // End:0x17C
            if((Vehicle(Pawn) != none) && Vehicle(Pawn).Driver != none)
            {
            }
        }
        Record.Location = Pawn.Location;
        Record.Rotation = Pawn.Rotation;
        // End:0x30A
        if((((Pawn.Base != none) && Pawn.Base.bNoDelete) && !Pawn.Base.bStatic) && !Pawn.Base.bWorldGeometry)
        {
            Record.BasePathName = PathName(Pawn.Base);
        }
        // End:0x356
        if(Vehicle(Pawn) != none)
        {
            InvHolder = Vehicle(Pawn).Driver;            
        }
        else
        {
            InvHolder = Pawn;
        }
        // End:0x426
        foreach InvHolder.InvManager.InventoryActors(Class'EvilWeap_Base', Weapon)
        {
            // End:0x425
            if(Weapon.ShouldSaveForCheckpoint())
            {
                Weapon.CreateCheckpointRecord(InvRecord);
                Record.InventoryRecords.AddItem(InvRecord);
            }            
        }        
        // End:0x4DA
        if(MyEvilPawn != none)
        {
            // End:0x4DA
            if(MyEvilPawn.CurrentLink != none)
            {
                Record.SlotPathName = PathName(MyEvilPawn.CurrentLink);
                Record.SlotIdx = MyEvilPawn.CurrentSlotIdx;
            }
        }        
    }
    else
    {
        Record.Location = Location;
        Record.Rotation = Rotation;
    }
    Record.TeamIndex = GetTeamNum();
    Record.bAllowCombatTransitions = bAllowCombatTransitions;
    Record.MoveActionPathName = PathName(MoveAction);
    Record.AggressionLevel = CurrentAggressionLevel;
    Record.BehaviorMode = CurrentBehaviorMode;
    CreateCheckPointRecordForPawnClothes(Record);
    //return;    
}

function CreateCheckPointRecordForPawnClothes(out CheckpointRecord Record)
{
    local int I;

    Record.HeadClothIndex = MyEvilPawn.ReplicatedHeadClothIndex;
    Record.EquipmentClothIndex = MyEvilPawn.ReplicatedEquipmentClothIndex;
    Record.ClothShield = MyEvilPawn.ReplicatedClothShield;
    I = 0;
    J0xBC:

    // End:0x178 [Loop If]
    if(I < 32)
    {
        Record.ClothMaterials[I] = MyEvilPawn.ReplicatedClothMaterials[I];
        Record.ClothesInfo[I] = MyEvilPawn.ReplicatedClothesInfo[I];
        I++;
        // [Loop Continue]
        goto J0xBC;
    }
    //return;    
}

function ApplyCheckPointDressUpPawn(const out CheckpointRecord Record)
{
    local int I;

    // End:0x80
    if(Record.HeadClothIndex != -1)
    {
        MyEvilPawn.ReplicatedHeadClothIndex = Record.HeadClothIndex;
        MyEvilPawn.DressUpHead();
    }
    MyEvilPawn.ReplicatedEquipmentClothIndex = Record.EquipmentClothIndex;
    MyEvilPawn.ReplicatedClothShield = Record.ClothShield;
    I = 0;
    J0x101:

    // End:0x1BD [Loop If]
    if(I < 32)
    {
        MyEvilPawn.ReplicatedClothMaterials[I] = Record.ClothMaterials[I];
        MyEvilPawn.ReplicatedClothesInfo[I] = Record.ClothesInfo[I];
        I++;
        // [Loop Continue]
        goto J0x101;
    }
    MyEvilPawn.DressUpClient();
    //return;    
}

function ApplyCheckpointTeamChanges(const out CheckpointRecord Record)
{
    SetTeam(int(Record.TeamIndex));
    //return;    
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    local InventoryRecord InvRecord;
    local Inventory InvItem;
    local class<Inventory> InvClass;
    local Pawn NewPawn;
    local class<Pawn> PawnClass;
    local CoverInfo RecCoverInfo;
    local EvilDestructibleObject GDO;

    MyGuid = Record.SavedGuid;
    bAllowCombatTransitions = Record.bAllowCombatTransitions;
    // End:0x8B
    if(Pawn != none)
    {
        Pawn.LifeSpan = 0.1000000;
        UnPossess();
    }
    // End:0xF0
    if(Record.PawnClassName != "")
    {
        PawnClass = class<Pawn>(FindObject(Record.PawnClassName, Class'Core.Class'));
    }
    // End:0x65C
    if(PawnClass != none)
    {
        NewPawn = Spawn(PawnClass,,, Record.Location, Record.Rotation,, true);
        ApplyCheckpointTeamChanges(Record);
        Possess(NewPawn, false);
        // End:0x65C
        if(Pawn != none)
        {
            // End:0x371
            if(Vehicle(Pawn) == none)
            {
                ApplyCheckPointDressUpPawn(Record);
                Pawn.InvManager.DiscardInventory();
                // End:0x370
                foreach Record.InventoryRecords(InvRecord)
                {
                    InvClass = class<Inventory>(FindObject(InvRecord.InventoryClassPath, Class'Core.Class'));
                    // End:0x26B
                    if(InvClass == none)
                    {                        
                    }
                    else
                    {
                        InvItem = Pawn.InvManager.Spawn(InvClass);
                        // End:0x2CA
                        if(InvItem == none)
                        {                            
                        }
                        else
                        {
                            // End:0x313
                            if(EvilWeap_Base(InvItem) != none)
                            {
                                EvilWeap_Base(InvItem).ApplyCheckpointRecord(InvRecord);
                            }
                            Pawn.InvManager.AddInventory(InvItem, !InvRecord.bIsActiveWeapon);
                        }
                    }                    
                }                
            }
            // End:0x3E7
            if(Record.BasePathName != "")
            {
                Pawn.SetBase(Actor(FindObject(Record.BasePathName, Class'Engine.Actor')));
            }
            Pawn.Health = int(Record.PawnHealthPct * float(Pawn.HealthMax));
            ChangeAgrressionLevel(Record.AggressionLevel);
            ChangeBehaviorMode(Record.BehaviorMode);
            GotoState('Idle', 'Begin');
            AutoAcquireEnemy();
            CheckCombatTransition();
            // End:0x581
            if(Record.SlotPathName != "")
            {
                RecCoverInfo.Link = CoverLink(FindObject(Record.SlotPathName, Class'Engine.CoverLink'));
                RecCoverInfo.SlotIdx = Record.SlotIdx;
                SetCoverGoal(RecCoverInfo);
            }
            // End:0x5E6
            if(Record.MoveActionPathName != "")
            {
                PendingCheckpointMoveAction = SeqAct_AIMoveToActor(FindObject(Record.MoveActionPathName, Class'Engine.SeqAct_AIMoveToActor'));
            }
            // End:0x65B
            foreach Pawn.OverlappingActors(Class'EvilDestructibleObject', GDO, Pawn.GetCollisionRadius())
            {
                GDO.ShutDownObject();                
            }            
        }
    }
    // End:0x6A6
    if(PlayerReplicationInfo != none)
    {
        PlayerReplicationInfo.PlayerName = Record.PlayerName;
    }
    //return;    
}

auto state Idle
{Begin:

    Sleep(0.1000000);
    CheckCombatTransition();
    // End:0x64
    if(bMoveAroundWhenIdle)
    {
        SetMovePoint(GetRandomLocation(SenseDistanceThreshold), Pawn.GetCollisionRadius() * float(2), true);
    }
    Sleep(RandRange(1.0000000, 2.0000000));
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
    MoveCommand=Class'EvilAICmd_MoveToGoal'
    ThrowCommand=Class'EvilAICmd_Attack_Throw'
    StrafeCommand=Class'EvilAICmd_Strafe'
    StrafesData[0]=(StrafeDirection=EStrafeDirection.SD_Left,StrafeDistance=100.0000000,DefaultRating=0.5000000,StrafeDelay=0.0000000,StrafePoint=(X=0.0000000,Y=0.0000000,Z=0.0000000),RandomAngleOffset=0.0000000,bClearFireLine=false,bEnemyReachable=false,Rating=0.0000000,bValidMoveToStrafePoint=false,Count=0,CustomStrafeDelta=(X=0.0000000,Y=0.0000000,Z=0.0000000),bDisabled=false,LastStrafeTime=0.0000000)
    StrafesData[1]=(StrafeDirection=EStrafeDirection.SD_Right,StrafeDistance=100.0000000,DefaultRating=0.5000000,StrafeDelay=0.0000000,StrafePoint=(X=0.0000000,Y=0.0000000,Z=0.0000000),RandomAngleOffset=0.0000000,bClearFireLine=false,bEnemyReachable=false,Rating=0.0000000,bValidMoveToStrafePoint=false,Count=0,CustomStrafeDelta=(X=0.0000000,Y=0.0000000,Z=0.0000000),bDisabled=false,LastStrafeTime=0.0000000)
    StrafesData[2]=(StrafeDirection=EStrafeDirection.SD_Back,StrafeDistance=100.0000000,DefaultRating=0.5000000,StrafeDelay=0.0000000,StrafePoint=(X=0.0000000,Y=0.0000000,Z=0.0000000),RandomAngleOffset=0.0000000,bClearFireLine=false,bEnemyReachable=false,Rating=0.0000000,bValidMoveToStrafePoint=false,Count=0,CustomStrafeDelta=(X=0.0000000,Y=0.0000000,Z=0.0000000),bDisabled=false,LastStrafeTime=0.0000000)
    StrafesData[3]=(StrafeDirection=EStrafeDirection.SD_Forward,StrafeDistance=100.0000000,DefaultRating=0.5010000,StrafeDelay=0.0000000,StrafePoint=(X=0.0000000,Y=0.0000000,Z=0.0000000),RandomAngleOffset=0.0000000,bClearFireLine=false,bEnemyReachable=false,Rating=0.0000000,bValidMoveToStrafePoint=false,Count=0,CustomStrafeDelta=(X=0.0000000,Y=0.0000000,Z=0.0000000),bDisabled=false,LastStrafeTime=0.0000000)
    StrafesData[4]=(StrafeDirection=EStrafeDirection.SD_Left,StrafeDistance=300.0000000,DefaultRating=0.5000000,StrafeDelay=0.0000000,StrafePoint=(X=0.0000000,Y=0.0000000,Z=0.0000000),RandomAngleOffset=0.0000000,bClearFireLine=false,bEnemyReachable=false,Rating=0.0000000,bValidMoveToStrafePoint=false,Count=0,CustomStrafeDelta=(X=0.0000000,Y=0.0000000,Z=0.0000000),bDisabled=false,LastStrafeTime=0.0000000)
    StrafesData[5]=(StrafeDirection=EStrafeDirection.SD_Right,StrafeDistance=300.0000000,DefaultRating=0.5000000,StrafeDelay=0.0000000,StrafePoint=(X=0.0000000,Y=0.0000000,Z=0.0000000),RandomAngleOffset=0.0000000,bClearFireLine=false,bEnemyReachable=false,Rating=0.0000000,bValidMoveToStrafePoint=false,Count=0,CustomStrafeDelta=(X=0.0000000,Y=0.0000000,Z=0.0000000),bDisabled=false,LastStrafeTime=0.0000000)
    StrafesData[6]=(StrafeDirection=EStrafeDirection.SD_Back,StrafeDistance=300.0000000,DefaultRating=0.5000000,StrafeDelay=0.0000000,StrafePoint=(X=0.0000000,Y=0.0000000,Z=0.0000000),RandomAngleOffset=0.0000000,bClearFireLine=false,bEnemyReachable=false,Rating=0.0000000,bValidMoveToStrafePoint=false,Count=0,CustomStrafeDelta=(X=0.0000000,Y=0.0000000,Z=0.0000000),bDisabled=false,LastStrafeTime=0.0000000)
    StrafesData[7]=(StrafeDirection=EStrafeDirection.SD_Forward,StrafeDistance=300.0000000,DefaultRating=0.5010000,StrafeDelay=0.0000000,StrafePoint=(X=0.0000000,Y=0.0000000,Z=0.0000000),RandomAngleOffset=0.0000000,bClearFireLine=false,bEnemyReachable=false,Rating=0.0000000,bValidMoveToStrafePoint=false,Count=0,CustomStrafeDelta=(X=0.0000000,Y=0.0000000,Z=0.0000000),bDisabled=false,LastStrafeTime=0.0000000)
    EnemyDistance_Melee=130.0000000
    EnemyDistance_MeleeCharge=270.0000000
    EnemyDistance_MinimalStrafeDistance=200.0000000
    EnemyDistance_HearFootSteps=2000.0000000
    SenseDistanceThreshold=2000.0000000
    SightSenseDistanceThreshold=1500.0000000
    SightRadius=3000.0000000
    // Reference: EvilAIReactManager'Default__EvilAIController.ReactionManager0'
    begin object name="ReactionManager0" class=Class'EvilAIReactManager'
    end object
    ReactionManager=ReactionManager0
    // Reference: EvilAIReactCond_EnemyCanBeMeleed'Default__EvilAIController.EnemyCanBeMeleed0'
    begin object name="EnemyCanBeMeleed0" class=Class'EvilAIReactCond_EnemyCanBeMeleed'
        OutputFunction=Default__EvilAIController.BeginMeleeCommandWrapper
    end object
    DefaultReactConditions[0]=EnemyCanBeMeleed0
    // Reference: EvilAIReactCond_EnemyCloseAndVisible'Default__EvilAIController.EnemyCloseAndVisible0'
    begin object name="EnemyCloseAndVisible0" class=Class'EvilAIReactCond_EnemyCloseAndVisible'
        DistanceThreshold=5000.0000000
    end object
    DefaultReactConditions[1]=EnemyCloseAndVisible0
    // Reference: EvilAIReactCond_CanLongDistanceCharge'Default__EvilAIController.LongDistanceCharge0'
    begin object name="LongDistanceCharge0" class=Class'EvilAIReactCond_CanLongDistanceCharge'
        MinTimeBetweenOutputsSeconds=5.0000000
        OutputFunction=Default__EvilAIController.BeginLongDistanceChargeWrapper
        bBlockAfterOutput=true
        AutoSubscribedChannels[0]="EnemyCloseAndVisible"
        AutoSubscribedUnBlockingChannels[0]="LongDistanceChargeStopped"
        AutoSubscribedUnBlockingChannels[1]="LongDistanceChargeAborted"
    end object
    DefaultReactConditions[2]=LongDistanceCharge0
    // Reference: EvilAIReactCond_GenericCallDelegate'Default__EvilAIController.BehaviorAttack0'
    begin object name="BehaviorAttack0" class=Class'EvilAIReactCond_GenericCallDelegate'
        OutputFunction=Default__EvilAIController.SetAttackBehaviorWrapper
        bOneTimeOnly=true
        AutoSubscribedChannels[0]="Damage"
        AutoSubscribedChannels[1]="EnemyWithinMeleeChargeDistance"
        AutoSubscribedChannels[2]="Timer"
        TimerInterval=1.0000000
        TimerStartInverval=0.5000000
        TimerMode=EReactTimerMode.ERTM_Random
        SuppressingBehaviors[0]=.BM_Relaxed
    end object
    DefaultReactConditions[3]=BehaviorAttack0
    // Reference: EvilAIReactCond_Stumble'Default__EvilAIController.RunFail0'
    begin object name="RunFail0" class=Class'EvilAIReactCond_Stumble'
        CallChance=0.0200000
        MinTimeBetweenOutputsSeconds=40.0000000
        OutputFunction=Default__EvilAIController.BeginStumbleWrapper
        AutoSubscribedChannels[0]="Timer"
        TimerInterval=1.0000000
    end object
    DefaultReactConditions[4]=RunFail0
    // Reference: EvilAIReactCond_CanAimEnemy'Default__EvilAIController.ReadyToFire0'
    begin object name="ReadyToFire0" class=Class'EvilAIReactCond_CanAimEnemy'
        OutputFunction=Default__EvilAIController.ReadyToFire
        AutoSubscribedChannels[0]="EnemyCloseToFireLine"
        AutoSubscribedChannels[1]="EnemyCloseToThrowLine"
        AutoSubscribedUnBlockingChannels[0]="TargetAimed"
        AutoSubscribedUnBlockingChannels[1]="TargetAimedToThrow"
        AutoSubscribedUnBlockingChannels[2]="AbortedAiming"
        SuppressingBehaviors[0]=.BM_Relaxed
        SuppressingBehaviors[1]=.BM_Alerted
    end object
    DefaultReactConditions[5]=ReadyToFire0
    // Reference: EvilAIReactCond_GenericCallDelegate'Default__EvilAIController.AbortMovingOnEnemyCloseAndVisible0'
    begin object name="AbortMovingOnEnemyCloseAndVisible0" class=Class'EvilAIReactCond_GenericCallDelegate'
        MinTimeBetweenOutputsSeconds=0.0000000
        ActivationDelay=0.8000000
        OutputFunction=Default__EvilAIController.AbortMovingOnEnemyCloseAndVisibleWrapper
        bBlockAfterOutput=true
        bBlockOnInit=true
        AutoSubscribedChannels[0]="EnemyCloseAndVisible"
        AutoSubscribedChannels[1]="BlockAbortMovingOnEnemyCloseAndVisible"
        AutoSubscribedUnBlockingChannels[0]="UnBlockAbortMovingOnEnemyCloseAndVisible"
    end object
    DefaultReactConditions[6]=AbortMovingOnEnemyCloseAndVisible0
    DefaultReactConditionClasses[0]=Class'EvilAIReactCond_EnemyInAttackRange'
    DefaultReactConditionClasses[1]=Class'EvilAIReactCond_Grenade'
    MaxStepAsideDist=100.0000000
    TimeBetweenMeleeCommands=2.0000000
    LastActiveEnemyInfo=(Pawn=none,Controller=none,LastHearMeTime=0.0000000,LastHearMeSoundSetType=ESoundSetType.SST_Invalid,LastUpdateTime=0.0000000,UpdateInterval=0.3000000,KnownLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000),LastKnownVelocity=(X=0.0000000,Y=0.0000000,Z=0.0000000),DistanceToEnemy=0.0000000,Rating=0.0000000,bForceUpdate=false,LastSeenTime=0.0000000,bInitialized=false)
    LastActiveEnemyIndex=-1
    ExtraPathCost=20
    MaxMoveTowardPawnTargetTime=2.0000000
    NavMeshPath_SearchExtent_Modifier=(X=-5.0000000,Y=-5.0000000,Z=-15.0000000)
}