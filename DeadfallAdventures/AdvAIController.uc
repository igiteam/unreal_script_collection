class AdvAIController extends EvilAIController
    native(AI)
    config(AI)
    hidecategories(Navigation);

struct CheckpointRecord
{
    var Guid SavedGuid;
    var Guid SavedPawnGuid;
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
    var EvilTypesNative.EBehaviorMode BehaviorMode;
    var int ScriptedRouteIndex;
    var ReplicatedClothInfo HeadClothInfo;
    var ReplicatedClothInfo EquipmentClothInfo;
    var ReplicatedClothMaterial ClothMaterials[32];
    var ReplicatedClothInfo ClothesInfo[32];
    var ReplicatedClothMaterial ClothShield;
    var int BossStageId;
    var string AIFactoryPathName;
    var bool bSpawnDone;
    var bool bCanTeleportToGoal;
    var bool bBlockCombatTransition;
    var bool bWasInForceCover;
    var string ForceCoverSequence;
    var bool bShouldRun2Cover;
    var bool bPawnCanPlayVO;
    var string GuardAreaActionPath;
    var array<string> CombatZones;
    var string ExploreActionPathName;
    var array<int> ExploreOrder;
    var int ExploreOrderElement;
    var array<AICharacterInfo> EnemyInfoList;

    structdefaultproperties
    {
        SavedGuid=(A=0,B=0,C=0,D=0)
        SavedPawnGuid=(A=0,B=0,C=0,D=0)
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
        ScriptedRouteIndex=0
        HeadClothInfo=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
        EquipmentClothInfo=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
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
        AIFactoryPathName=""
        bSpawnDone=false
        bCanTeleportToGoal=false
        bBlockCombatTransition=false
        bWasInForceCover=false
        ForceCoverSequence=""
        bShouldRun2Cover=false
        bPawnCanPlayVO=false
        GuardAreaActionPath=""
        CombatZones=none
        ExploreActionPathName=""
        ExploreOrder=none
        ExploreOrderElement=0
        EnemyInfoList=none
    }
};

var AdvPawn MyAdvPawn;
var SeqAct_AIExplorePOI ExploreAction;
var SeqAct_AIExplorePOI PendingCheckpointExploreAction;
var AdvAICmd_ExplorePOI ExploreCommand;
var SeqAct_ForceCover ForceCoverAction;
var SeqAct_ForceCover PendingCheckpointForceCoverAction;
var() config float FinishEnemiesModeDuration;
var() config float ChoosingEnenyToFinishDuration;
var bool bIsEnemyLocked;
var bool bKilledByTrap;
var bool bBlockCombatTransition;
var bool bUseUnstuckSearchStart;
var bool bExploreOrderReady;
var bool bShouldRun2Cover;
var array<AdvPlayerControllerMP> AssistingPlayers;
var AdvPlayerControllerMP TrapKiller;
var() config float CoverFromLightTime;
var float CoverFromLightStartTime;
var int AttackingSpidersCount;
var Vector UnstuckSearchStart;
var SeqAct_AIExplorePOI NewExploreAction;
var array<int> POIExploreOrder;
var int ElementInExploreOrder;
var array<AICharacterInfo> EnemyInfoToRestore;

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
    super.Possess(NewPawn, bVehicleTransition);
    bAILogging = true;
    bAILogToWindow = false;
    MyAdvPawn = AdvPawn(NewPawn);
    SetTimer(1.0000000, false, 'CheckFlocking');
    //return;    
}

function CheckFlocking()
{
    local AdvPawn P;
    local Vector DirToOtherPawn, AdjustDir;

    // End:0x24E
    if(InLatentExecution(503) && MyAdvPawn.IsAliveAndWell())
    {
        // End:0x24D
        foreach Pawn.VisibleActors(Class'AdvPawn', P, 200.0000000)
        {
            // End:0xB5
            if(P.bAdjustingVelocity || !P.IsAliveAndWell())
            {
                continue;                
            }
            DirToOtherPawn = Normal(Pawn.Location - P.Location);
            // End:0x24C
            if((Normal(Pawn.Velocity) Dot DirToOtherPawn) > 0.6000000)
            {
                AdjustDir = -Normal(DirToOtherPawn - ProjectOnTo(DirToOtherPawn, Vector(Pawn.Rotation)));
                AdjustDir = AdjustDir + (Normal(P.Velocity) * 0.5000000);
                // End:0x217
                if(NavigationHandle.PointCheck(Pawn.Location + (AdjustDir * float(120)), vect(20.0000000, 20.0000000, 150.0000000)))
                {
                    continue;                    
                }
                P.SetAdjustMoveVelocity(AdjustDir, 1.2000000, 100.0000000);
                // End:0x24D
                break;
            }            
        }        
    }
    SetTimer(RandRange(1.0000000, 3.0000000), false, GetFuncName());
    //return;    
}

function SetEnemy(Pawn InEnemy)
{
    // End:0x36
    if(bIsEnemyLocked && Enemy.IsAliveAndWell())
    {
        return;        
    }
    else
    {
        bIsEnemyLocked = false;
    }
    // End:0x5B
    if(InEnemy == Enemy)
    {
        return;
    }
    Enemy = InEnemy;
    //return;    
}

function SetAndLockEnemy(Pawn InEnemy)
{
    SetEnemy(InEnemy);
    bIsEnemyLocked = true;
    //return;    
}

function UnlockEnemy()
{
    bIsEnemyLocked = false;
    //return;    
}

function DoFinisherAttack(optional Pawn NewEnemy)
{
    // End:0x4F
    if(NewEnemy != none)
    {
        SetEnemy(NewEnemy);
        Class'AdvAICmd_Attack_Finisher'.static.Finish(self, NewEnemy);        
    }
    else
    {
        Class'AdvAICmd_Attack_Finisher'.static.Finish(self);
    }
    //return;    
}

simulated function StartFinisherAttack()
{
    // End:0x2E
    if(MyAdvPawn != none)
    {
        MyAdvPawn.StartFinisherAttack();
    }
    //return;    
}

function SetUnstuckSeartStart(bool bUseUnstuck, optional Vector UnstuckLocation)
{
    bUseUnstuckSearchStart = bUseUnstuck;
    UnstuckSearchStart = ((bUseUnstuck) ? UnstuckLocation : vect(0.0000000, 0.0000000, 0.0000000));
    //return;    
}

function OnAISetTeam(SeqAct_AISetTeam Action)
{
    self.SetTeam(int(Action.AIType));
    // End:0xD5
    if((self.Focus != none) && int(EvilPawn(self.Focus).MyEvilAI.TeamIndex) == int(self.TeamIndex))
    {
        self.Focus = none;
    }
    //return;    
}

function AddAttackingSpider(Pawn spider)
{
    // End:0x26
    if(AttackingSpidersCount == 0)
    {
        InvalidateCoverAction();
        InvalidateCover();
    }
    AttackingSpidersCount++;
    //return;    
}

function RemoveAttackingSpider()
{
    // End:0x33
    if(AttackingSpidersCount > 0)
    {
        AttackingSpidersCount--;
        // End:0x33
        if(AttackingSpidersCount == 0)
        {
            EnableAI();
        }
    }
    //return;    
}

function int GetSpidersAttackingCount()
{
    return AttackingSpidersCount;
    //return ReturnValue;    
}

function StartExplorePOI()
{
    // End:0x59
    if(ExploreAction.bActiveExploring)
    {
        AbortCommand(CommandList);
        ClearLatentAction(Class'Engine.SeqAct_AIMoveToActor', true);
        GotoState('Explore');
    }
    //return;    
}

function FinishExplorePOI()
{
    //return;    
}

function OnAIExplorePOI(SeqAct_AIExplorePOI Action)
{
    ExploreAction = Action;
    // End:0xA7
    if((Action != none) && Action.bActiveExploring)
    {
        // End:0x9D
        if(Action.StartExploreDelay > 0.0000000)
        {
            SetTimer(Action.StartExploreDelay, false, 'StartExplorePOI', self);            
        }
        else
        {
            StartExplorePOI();
        }
    }
    //return;    
}

function OnAINudgePlayerMovedForward(SeqAct_AINudgePlayerMovedForward Action)
{
    ReactionManager.NudgeChannel(MyEvilPawn, 'PlayerMovedForward');
    //return;    
}

function ExecuteNavActions(Actor InGoal)
{
    local EvilNavPointInterface INavPoint;
    local array<EvilNavPointAction> NavActions;
    local bool bWaitAtThisPoint;
    local SeqAct_Latent Action;
    local bool bIgnoreDistance;

    // End:0x188
    foreach LatentActions(Action)
    {
        // End:0x187
        if(SeqAct_AIMoveToActor(Action) != none)
        {
            bWaitAtThisPoint = SeqAct_AIMoveToActor(Action).bWaitAtEachPoint;
            bIgnoreDistance = SeqAct_AIMoveToActor(Action).bIgnoreDistance;
            // End:0x187
            if(SeqAct_AIMoveToActor(Action).bWaitAtLastPoint || SeqAct_AIMoveToActor(Action).bWaitAtEachPoint)
            {
                // End:0x184
                if(((ScriptedRoute != none) && ScriptedRouteIndex == (ScriptedRoute.RouteList.Length - 1)) || (ScriptedRoute == none) && ScriptedMoveTarget != none)
                {
                    SeqAct_AIMoveToActor(Action).AtLastPoint();
                    bWaitAtThisPoint = true;
                }
                // [Explicit Continue]
                goto J0x188;
            }
        }        
    }
    J0x188:
    
    // End:0x1C3
    if(bWaitAtThisPoint)
    {
        Class'AdvAICmd_WaitForPlayer'.static.ExecuteWaiting(self, bIgnoreDistance);        
    }
    else
    {
        INavPoint = EvilNavPointInterface(InGoal);
        // End:0x281
        if(NotEqual_InterfaceInterface(INavPoint, EvilNavPointInterface(none)))
        {
            NavActions = INavPoint.GetNavPointActions();
            MyEvilPawn.RollbackLimitedMoveMode();
            // End:0x281
            if(NavActions.Length > 0)
            {
                Class'EvilGame.EvilAICmd_NavAction'.static.ExecuteActions(self, NavActions);
            }
        }
    }
    //return;    
}

function OnFinishEnemies(SeqAct_FinishEnemies Action)
{
    FinishEnemies();
    //return;    
}

event Tick(float DeltaTime)
{
    // End:0x12F
    if(MyEvilPawn != none)
    {
        // End:0x12F
        if((((((Master != none) && Master.Pawn != none) && Master.MyEvilPawn != none) && Master.MyEvilPawn.IsSprinting) && int(MyEvilPawn.CurrentMoveMode) == int(2)) != MyEvilPawn.IsSprinting)
        {
            MyEvilPawn.SetSprint(!MyEvilPawn.IsSprinting);
        }
    }
    super.Tick(DeltaTime);
    //return;    
}

function FinishEnemies()
{
    DefaultCommand = Class'AdvAICmd_FinishEnemies';
    BeginCombatCommand(DefaultCommand, "FinishEnemies");
    //return;    
}

event UnPossess()
{
    super.UnPossess();
    MyAdvPawn = none;
    //return;    
}

function OnTeleportAroundGoal(SeqAct_TeleportAroundGoal Action)
{
    local Vector GoalLocation;
    local EvilAICmd_Base_ScriptedRouteMove CurScriptedRouteMoveCommand;
    local EvilAICmd_Base_ScriptedMove CurScriptedMoveCommand;
    local Actor GoalActor;

    // End:0x190
    if(Action.TeleportGoal != none)
    {
        // End:0xC2
        if(AdvPawn(Action.TeleportGoal) != none)
        {
            GoalLocation = AdvPawn(Action.TeleportGoal).Location;
            GoalActor = Action.TeleportGoal;            
        }
        else
        {
            // End:0x190
            if(Controller(Action.TeleportGoal) != none)
            {
                GoalLocation = Controller(Action.TeleportGoal).Pawn.Location;
                GoalActor = Controller(Action.TeleportGoal).Pawn;
            }
        }
    }
    CurScriptedMoveCommand = EvilAICmd_Base_ScriptedMove(CommandList);
    CurScriptedRouteMoveCommand = EvilAICmd_Base_ScriptedRouteMove(CommandList);
    // End:0x1EE
    if(CurScriptedMoveCommand != none)
    {
        AbortCommand(CurScriptedMoveCommand);        
    }
    else
    {
        // End:0x211
        if(CurScriptedRouteMoveCommand != none)
        {
            AbortCommand(CurScriptedRouteMoveCommand);
        }
    }
    // End:0x234
    if(ExploreAction != none)
    {
        ClearTimer('StartExplorePOI');
    }
    ClearLatentAction(Class'Engine.SeqAct_Latent', true);
    TeleportToGoal(GoalLocation, GoalActor);
    //return;    
}

function bool NotifyBump(Actor Other, Vector HitNormal)
{
    // End:0x80
    if(!ClassIsChildOf(Other.Class, Class'EvilGame.EvilCreature') && !ClassIsChildOf(Other.Class, Class'EvilGame.EvilAI_Creature'))
    {
        return super.NotifyBump(Other, HitNormal);        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

function bool ShouldStopLevitating()
{
    return false;
    //return ReturnValue;    
}

function bool CanThrowGrenade()
{
    return ((Enemy != none) && !ClassIsChildOf(Enemy.Class, Class'AdvAI_Ally')) && MyEvilPawn.CanThrowGrenade();
    //return ReturnValue;    
}

function NotifyFinisherStart()
{
    //return;    
}

function NotifyFinisherEnd()
{
    //return;    
}

function bool CanClaimCover(CoverLink CoverLink)
{
    // End:0x47
    if((EvilCoverLink(CoverLink) != none) && EvilCoverLink(CoverLink).bFriendlyPawnsOnly)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function HandleEndOfCombat()
{
    //return;    
}

function OnToggleCombatAction(SeqAct_ToggleCombatAction inAction)
{
    // End:0x66
    if(inAction.InputLinks[0].bHasImpulse)
    {
        AbortCommand(CommandList);
        ChangeBehaviorMode(2);
        bBlockCombatTransition = true;        
    }
    else
    {
        // End:0xC2
        if(inAction.InputLinks[1].bHasImpulse)
        {
            InvalidateCover();
            bBlockCombatTransition = false;
            ChangeBehaviorMode(1);
        }
    }
    //return;    
}

function int GetEnemyCountForPawn(Pawn EnemyPawn)
{
    local int EnemyCount;
    local AdvAIController AdvController;

    // End:0xB6
    foreach WorldInfo.AllControllers(Class'AdvAIController', AdvController)
    {
        // End:0xB5
        if(((AdvController != self) && AdvController.Pawn.IsAliveAndWell()) && AdvController.Enemy == EnemyPawn)
        {
            EnemyCount++;
        }        
    }    
    return EnemyCount;
    //return ReturnValue;    
}

function OnWaitForPlayer(SeqAct_WaitForPlayer inAction)
{
    Class'AdvAICmd_WaitForPlayer'.static.ExecuteWaiting(self, true);
    //return;    
}

function OnToggleTeleportToGoal(SeqAct_ToggleTeleportToGoal inAction)
{
    // End:0x46
    if(inAction.InputLinks[0].bHasImpulse)
    {
        bCanTeleportToGoal = true;        
    }
    else
    {
        // End:0x8C
        if(inAction.InputLinks[1].bHasImpulse)
        {
            bCanTeleportToGoal = false;            
        }
        else
        {
            bCanTeleportToGoal = !bCanTeleportToGoal;
        }
    }
    //return;    
}

function OnForceCover(SeqAct_ForceCover inAction)
{
    // End:0x10
    if(AdvAI_Ally(self) == none)
    {
    }
    //return;    
}

function OnForceCover2(SeqAct_ForceCover inAction, optional bool bForceStartForceCoverAction = false)
{
    //return;    
}

function bool HasValidEnemy()
{
    local bool bResult;

    bResult = super.HasValidEnemy() && ((EvilPawn(Enemy) == none) || int(MyEvilPawn.PawnAction) != 60) || int(EvilPawn(Enemy).PawnAction) != 61;
    return bResult;
    //return ReturnValue;    
}

function PlayerStepAside(Pawn PlayerPawn, Vector HitNormal)
{
    local Vector NewPlayerLocation;
    local AdvPlayerController PC;
    local float StepAsideDistance;

    PC = AdvPlayerController(AdvPlayerPawn(PlayerPawn).GetPlayerController());
    StepAsideDistance = 50.0000000;
    NewPlayerLocation = PlayerPawn.Location + (Normal(Vector(Pawn.Rotation) Cross vect(0.0000000, 0.0000000, -1.0000000)) * StepAsideDistance);
    // End:0x2E1
    if(!IsPointOnNavMesh(NewPlayerLocation))
    {
        NewPlayerLocation = PlayerPawn.Location + (Normal(Vector(Pawn.Rotation) Cross vect(0.0000000, 0.0000000, 1.0000000)) * StepAsideDistance);
        // End:0x2E1
        if(!IsPointOnNavMesh(NewPlayerLocation))
        {
            NewPlayerLocation = PlayerPawn.Location + (Normal(Vector(Pawn.Rotation)) * -StepAsideDistance);
            // End:0x2E1
            if(!IsPointOnNavMesh(NewPlayerLocation))
            {
                NewPlayerLocation = PlayerPawn.Location + (Normal(HitNormal Cross vect(0.0000000, 0.0000000, -1.0000000)) * StepAsideDistance);
                // End:0x2E1
                if(!IsPointOnNavMesh(NewPlayerLocation))
                {
                    NewPlayerLocation = PlayerPawn.Location + (Normal(HitNormal Cross vect(0.0000000, 0.0000000, 1.0000000)) * StepAsideDistance);
                    // End:0x2E1
                    if(!IsPointOnNavMesh(NewPlayerLocation))
                    {
                        NewPlayerLocation = PlayerPawn.Location + (Normal(HitNormal) * -StepAsideDistance);
                        // End:0x2E1
                        if(!IsPointOnNavMesh(NewPlayerLocation))
                        {
                            return;
                        }
                    }
                }
            }
        }
    }
    // End:0x318
    if(PC != none)
    {
        PC.MoveSmoothTo(NewPlayerLocation);
    }
    //return;    
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
    // End:0x5C1
    if(Pawn != none)
    {
        Record.PawnHealthPct = float(Pawn.Health) / float(Pawn.HealthMax);
        // End:0x170
        if(MyEvilPawn != none)
        {
            Record.SavedPawnGuid = MyEvilPawn.PawnGuid;
            Record.PawnClassName = PathName(Pawn.Class);            
        }
        else
        {
            // End:0x1B7
            if((Vehicle(Pawn) != none) && Vehicle(Pawn).Driver != none)
            {
            }
        }
        Record.Location = Pawn.Location;
        Record.Rotation = Pawn.Rotation;
        // End:0x345
        if((((Pawn.Base != none) && Pawn.Base.bNoDelete) && !Pawn.Base.bStatic) && !Pawn.Base.bWorldGeometry)
        {
            Record.BasePathName = PathName(Pawn.Base);
        }
        // End:0x391
        if(Vehicle(Pawn) != none)
        {
            InvHolder = Vehicle(Pawn).Driver;            
        }
        else
        {
            InvHolder = Pawn;
        }
        // End:0x461
        foreach InvHolder.InvManager.InventoryActors(Class'EvilGame.EvilWeap_Base', Weapon)
        {
            // End:0x460
            if(Weapon.ShouldSaveForCheckpoint())
            {
                Weapon.CreateCheckpointRecord(InvRecord);
                Record.InventoryRecords.AddItem(InvRecord);                
            }            
        }        
        // End:0x5BE
        if(MyEvilPawn != none)
        {
            // End:0x515
            if(MyEvilPawn.CurrentLink != none)
            {
                Record.SlotPathName = PathName(MyEvilPawn.CurrentLink);
                Record.SlotIdx = MyEvilPawn.CurrentSlotIdx;
            }
            Record.bSpawnDone = MyEvilPawn.bSpawnDone;
            // End:0x5BE
            if(MyEvilPawn.AIFactory != none)
            {
                Record.AIFactoryPathName = PathName(MyEvilPawn.AIFactory);                
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
    CreateCheckpointRecordForExploration(Record);
    CreateCheckpointRecordEnemyInfoList(Record);
    Record.ScriptedRouteIndex = ScriptedRouteIndex;
    Record.AggressionLevel = CurrentAggressionLevel;
    Record.BehaviorMode = CurrentBehaviorMode;
    Record.bCanTeleportToGoal = bCanTeleportToGoal;
    CreateCheckPointRecordForPawnClothes(Record);
    Record.bBlockCombatTransition = bBlockCombatTransition;
    // End:0x800
    if((FindCommandOfClass(Class'AdvAICmd_ForceCover') != none) && ForceCoverAction != none)
    {
        Record.bWasInForceCover = true;
        Record.ForceCoverSequence = PathName(ForceCoverAction);
    }
    Record.bShouldRun2Cover = bShouldRun2Cover;
    CreateCheckpointRecordForGuardArea(Record);
    CreateCheckpointRecordForSetCombatZone(Record);
    Record.bPawnCanPlayVO = MyEvilPawn.bCanPlayVO;
    //return;    
}

function CreateCheckPointRecordForPawnClothes(out CheckpointRecord Record)
{
    local int I;

    Record.HeadClothInfo = MyEvilPawn.ReplicatedHeadClothInfo;
    Record.EquipmentClothInfo = MyEvilPawn.ReplicatedEquipmentClothInfo;
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

function CreateCheckpointRecordForGuardArea(out CheckpointRecord Record)
{
    local SeqAct_Latent Action;

    // End:0x75
    foreach LatentActions(Action)
    {
        // End:0x74
        if(ClassIsChildOf(Action.Class, Class'EvilGame.SeqAct_AIGuardArea'))
        {
            Record.GuardAreaActionPath = PathName(Action);
        }        
    }    
    //return;    
}

function ApplyCheckpointGuardArea(const out CheckpointRecord Record)
{
    local SeqAct_AIGuardArea guardAreaAction;

    // End:0x9D
    if(Record.GuardAreaActionPath != "")
    {
        guardAreaAction = SeqAct_AIGuardArea(FindObject(Record.GuardAreaActionPath, Class'EvilGame.SeqAct_AIGuardArea'));
        // End:0x9D
        if(guardAreaAction != none)
        {
            LatentActions.AddItem(guardAreaAction);            
            OnAIGuardArea(guardAreaAction);
        }
    }
    //return;    
}

function CreateCheckpointRecordForSetCombatZone(out CheckpointRecord Record)
{
    local EvilCombatZone CombatZone;

    // End:0x4B
    foreach CombatZones(CombatZone)
    {
        Record.CombatZones.AddItem(PathName(CombatZone));                
    }    
    //return;    
}

function ApplyCheckpointRecordForSetCombatZone(const out CheckpointRecord Record)
{
    local EvilCombatZone CombatZone;
    local string strSavedCombatZone;

    // End:0x7F
    foreach Record.CombatZones(strSavedCombatZone)
    {
        CombatZone = EvilCombatZone(FindObject(strSavedCombatZone, Class'EvilGame.EvilCombatZone'));
        // End:0x7E
        if(CombatZone != none)
        {
            CombatZones.AddItem(CombatZone);            
        }        
    }    
    //return;    
}

function CreateCheckpointRecordForExploration(out CheckpointRecord Record)
{
    local int OrderIndex;

    // End:0x42
    if(NewExploreAction != none)
    {
        Record.ExploreActionPathName = PathName(NewExploreAction);        
    }
    else
    {
        // End:0xE9
        if(ExploreAction != none)
        {
            Record.ExploreActionPathName = PathName(ExploreAction);
            // End:0xC2
            foreach POIExploreOrder(OrderIndex)
            {
                Record.ExploreOrder.AddItem(OrderIndex);                                
            }            
            Record.ExploreOrderElement = ElementInExploreOrder;
        }
    }
    //return;    
}

function ApplyCheckpointRecordForExploration(const out CheckpointRecord Record)
{
    local int OrderIndex;

    // End:0xE5
    if(Record.ExploreActionPathName != "")
    {
        PendingCheckpointExploreAction = SeqAct_AIExplorePOI(FindObject(Record.ExploreActionPathName, Class'SeqAct_AIExplorePOI'));
        // End:0xA6
        foreach Record.ExploreOrder(OrderIndex)
        {
            POIExploreOrder.AddItem(OrderIndex);                        
        }        
        ElementInExploreOrder = Record.ExploreOrderElement;
        bExploreOrderReady = POIExploreOrder.Length > 0;
    }
    //return;    
}

function CreateCheckpointRecordEnemyInfoList(out CheckpointRecord Record)
{
    local AICharacterInfo EnemyInfo;

    // End:0x62
    if(Record.EnemyInfoList.Length > 0)
    {
        Record.EnemyInfoList.Remove(0, Record.EnemyInfoList.Length - 1);        
    }
    // End:0x17D
    foreach EnemyInfoList(EnemyInfo)
    {
        EnemyInfo.PawnGuid = EnemyInfo.Pawn.PawnGuid;
        EnemyInfo.Pawn = none;
        EnemyInfo.Controller = none;
        EnemyInfo.bIsPlayer = EnemyInfo.Pawn.IsPlayerPawn();
        Record.EnemyInfoList.AddItem(EnemyInfo);                
    }    
    //return;    
}

function ApplyCheckpointRecordEnemyInfoList(const out CheckpointRecord Record)
{
    local AICharacterInfo EnemyInfo;

    // End:0x29
    if(EnemyInfoToRestore.Length > 0)
    {
        EnemyInfoToRestore.Remove(0, EnemyInfoToRestore.Length - 1);        
    }
    // End:0x6A
    foreach Record.EnemyInfoList(EnemyInfo)
    {
        EnemyInfoToRestore.AddItem(EnemyInfo);                
    }    
    //return;    
}

function ApplyCheckPointDressUpPawn(const out CheckpointRecord Record)
{
    local int I;

    // End:0x94
    if(int(Record.HeadClothInfo.ClothIndex) != int(255))
    {
        MyEvilPawn.ReplicatedHeadClothInfo = Record.HeadClothInfo;
        MyEvilPawn.DressUpHead();
    }
    MyEvilPawn.ReplicatedEquipmentClothInfo = Record.EquipmentClothInfo;
    MyEvilPawn.ReplicatedClothShield = Record.ClothShield;
    I = 0;
    J0x115:

    // End:0x1D1 [Loop If]
    if(I < 32)
    {
        MyEvilPawn.ReplicatedClothMaterials[I] = Record.ClothMaterials[I];
        MyEvilPawn.ReplicatedClothesInfo[I] = Record.ClothesInfo[I];
        I++;
        // [Loop Continue]
        goto J0x115;
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
    local EvilPawn EP;

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
    // End:0xA3B
    if(PawnClass != none)
    {
        NewPawn = Spawn(PawnClass,,, Record.Location, Record.Rotation,, true);
        ApplyCheckpointTeamChanges(Record);
        EP = EvilPawn(NewPawn);
        // End:0x20E
        if(EP != none)
        {
            EP.bSpawnDone = Record.bSpawnDone;
            EP.PawnGuid = Record.SavedPawnGuid;
        }
        Possess(NewPawn, false);
        // End:0xA38
        if(Pawn != none)
        {
            // End:0x414
            if(Vehicle(Pawn) == none)
            {
                ApplyCheckPointDressUpPawn(Record);
                Pawn.InvManager.DiscardInventory();
                // End:0x413
                foreach Record.InventoryRecords(InvRecord)
                {
                    InvClass = class<Inventory>(FindObject(InvRecord.InventoryClassPath, Class'Core.Class'));
                    // End:0x30E
                    if(InvClass == none)
                    {                        
                    }
                    else
                    {
                        InvItem = Pawn.InvManager.Spawn(InvClass);
                        // End:0x36D
                        if(InvItem == none)
                        {                            
                        }
                        else
                        {
                            // End:0x3B6
                            if(EvilWeap_Base(InvItem) != none)
                            {
                                EvilWeap_Base(InvItem).ApplyCheckpointRecord(InvRecord);
                            }
                            Pawn.InvManager.AddInventory(InvItem, !InvRecord.bIsActiveWeapon);
                        }
                    }                    
                }                
            }
            // End:0x48A
            if(Record.BasePathName != "")
            {
                Pawn.SetBase(Actor(FindObject(Record.BasePathName, Class'Engine.Actor')));
            }
            Pawn.Health = int(Record.PawnHealthPct * float(Pawn.HealthMax));
            bBlockCombatTransition = Record.bBlockCombatTransition;
            bShouldRun2Cover = Record.bShouldRun2Cover;
            MyEvilPawn.bCanPlayVO = Record.bPawnCanPlayVO;
            ApplyCheckpointRecordEnemyInfoList(Record);
            ChangeAgrressionLevel(Record.AggressionLevel);
            ChangeBehaviorMode(Record.BehaviorMode);
            // End:0x662
            if(EP != none)
            {
                EP.AIFactory = SeqAct_AIFactory(FindObject(Record.AIFactoryPathName, Class'EvilGame.SeqAct_AIFactory'));
                // End:0x662
                if(EP.AIFactory == none)
                {                    
                }
            }
            ApplyCheckpointRecordForSetCombatZone(Record);
            // End:0x782
            if(((EP != none) && EP.AIFactory != none) && !EP.bSpawnDone)
            {
                // End:0x75E
                if(EP.AIFactory.SpawnMethod != none)
                {
                    EP.AIFactory.SpawnMethod.PostCreateActor(EP);                    
                }
                else
                {
                    EP.SpawnCompleted(0);
                }                
            }
            else
            {
                GotoState('Idle', 'Begin');
                CheckCombatTransition();
            }
            // End:0x867
            if(Record.SlotPathName != "")
            {
                RecCoverInfo.Link = CoverLink(FindObject(Record.SlotPathName, Class'Engine.CoverLink'));
                RecCoverInfo.SlotIdx = Record.SlotIdx;
                SetCoverGoal(RecCoverInfo);
            }
            // End:0x8EB
            if(Record.bWasInForceCover)
            {
                ForceCoverAction = SeqAct_ForceCover(FindObject(Record.ForceCoverSequence, Class'Engine.SequenceAction'));
                // End:0x8EB
                if(ForceCoverAction != none)
                {
                    PendingCheckpointForceCoverAction = ForceCoverAction;
                }
            }
            // End:0x924
            if(Record.ExploreActionPathName != "")
            {
                ApplyCheckpointRecordForExploration(Record);                
            }
            else
            {
                // End:0x989
                if(Record.MoveActionPathName != "")
                {
                    PendingCheckpointMoveAction = SeqAct_AIMoveToActor(FindObject(Record.MoveActionPathName, Class'Engine.SeqAct_AIMoveToActor'));
                }
                ScriptedRouteIndex = Record.ScriptedRouteIndex;
            }
            // End:0xA24
            foreach Pawn.OverlappingActors(Class'EvilGame.EvilDestructibleObject', GDO, Pawn.GetCollisionRadius())
            {
                GDO.ShutDownObject();                
            }            
            ApplyCheckpointGuardArea(Record);
        }        
    }
    else
    {
        Destroy();
        return;
    }
    bCanTeleportToGoal = Record.bCanTeleportToGoal;
    // End:0xAB2
    if(PlayerReplicationInfo != none)
    {
        PlayerReplicationInfo.PlayerName = Record.PlayerName;
    }
    //return;    
}

function RestoreEnemyInfo()
{
    local AICharacterInfo EnemyInfo;
    local EvilPawn EnemyPawn;
    local AdvPlayerController PlayerController;
    local int EnemyIndex;
    local Pawn EnemyToRestore;

    // End:0x52A
    foreach EnemyInfoToRestore(EnemyInfo)
    {
        // End:0x9B
        if(EnemyInfo.bIsPlayer)
        {
            // End:0x97
            foreach WorldInfo.AllControllers(Class'AdvPlayerController', PlayerController)
            {
                EnemyToRestore = PlayerController.Pawn;
                // End:0x97
                break;                
            }                        
        }
        else
        {
            // End:0x12E
            foreach WorldInfo.AllPawns(Class'EvilGame.EvilPawn', EnemyPawn)
            {
                // End:0x12D
                if(EnemyPawn.PawnGuid == EnemyInfo.PawnGuid)
                {
                    EnemyToRestore = EnemyPawn;
                    // End:0x12E
                    break;
                }                
            }            
        }
        // End:0x529
        if(EnemyToRestore != none)
        {
            ProcessStimulus(EnemyToRestore, 3, GetFuncName(), true);
            EnemyIndex = GetAIEnemyInfoIdx(EnemyToRestore);
            EnemyInfoList[EnemyIndex].RatingModifier = EnemyInfo.RatingModifier;
            EnemyInfoList[EnemyIndex].LastHearMeTime = EnemyInfo.LastHearMeTime;
            EnemyInfoList[EnemyIndex].LastHearMeSoundSetType = EnemyInfo.LastHearMeSoundSetType;
            EnemyInfoList[EnemyIndex].LastUpdateTime = EnemyInfo.LastUpdateTime;
            EnemyInfoList[EnemyIndex].UpdateInterval = EnemyInfo.UpdateInterval;
            EnemyInfoList[EnemyIndex].KnownLocation = EnemyInfo.KnownLocation;
            EnemyInfoList[EnemyIndex].LastKnownVelocity = EnemyInfo.LastKnownVelocity;
            EnemyInfoList[EnemyIndex].DistanceToEnemy = EnemyInfo.DistanceToEnemy;
            EnemyInfoList[EnemyIndex].Rating = EnemyInfo.Rating;
            EnemyInfoList[EnemyIndex].bUpdateRating = EnemyInfo.bUpdateRating;
            EnemyInfoList[EnemyIndex].LastSeenTime = EnemyInfo.LastSeenTime;
            EnemyInfoList[EnemyIndex].bInitialized = EnemyInfo.bInitialized;
            EnemyInfoList[EnemyIndex].RatingModifier = EnemyInfo.RatingModifier;
            EnemyInfoList[EnemyIndex].GivenDamageToMe = EnemyInfo.GivenDamageToMe;
        }        
    }    
    //return;    
}

event Destroyed()
{
    ForceCoverAction = none;
    ExploreAction = none;
    super.Destroyed();
    //return;    
}

state Idle
{
    event BeginState(name PreviousStateName)
    {
        // End:0x7A
        if(PreviousStateName == 'Combat')
        {
            InvalidateCover();
            // End:0x44
            if(int(CurrentBehaviorMode) != int(1))
            {
                ChangeBehaviorMode(1);
            }
            ShotTarget = none;
            Enemy = none;
            MyAdvPawn.ToggleAimingAnimMode(true);
        }
        //return;        
    }
    stop;    
}

state Combat
{
    function StartExplorePOI()
    {
        // End:0x2D
        if(!HasValidEnemy() && !bBlockCombatTransition)
        {
            global.StartExplorePOI();            
        }
        //return;        
    }

    function OnAIExplorePOI(SeqAct_AIExplorePOI Action)
    {
        // End:0x42
        if(!HasValidEnemy() && !bBlockCombatTransition)
        {
            ChangeBehaviorMode(1);
            global.OnAIExplorePOI(Action);            
        }
        //return;        
    }

    function OnToggleCombatAction(SeqAct_ToggleCombatAction inAction)
    {
        // End:0x5C
        if(inAction.InputLinks[1].bHasImpulse)
        {
            InvalidateCover();
            bBlockCombatTransition = false;
            ChangeBehaviorMode(1);
        }
        //return;        
    }

    function OnTeleportAroundGoal(SeqAct_TeleportAroundGoal Action)
    {
        InvalidateCoverAction();
        InvalidateCover();
        global.OnTeleportAroundGoal(Action);
        //return;        
    }

    function bool InfoListHasEnemy()
    {
        local AICharacterInfo EI;

        // End:0x12
        if(EnemyInfoList.Length <= 0)
        {
            return false;
        }
        // End:0x53
        foreach EnemyInfoList(EI)
        {
            // End:0x52
            if(EI.Rating > 0.0000000)
            {                
                return true;
            }            
        }        
        return false;
        //return ReturnValue;        
    }
Begin:

    // End:0x40
    if(bBlockCombatTransition)
    {
        BeginCombatCommand(DefaultCommand, "BlockCombatTransition is true");
    }
    // End:0x7C
    if(!HasValidEnemy() && !InfoListHasEnemy())
    {
        SetEnemy(none);
        GotoState('Idle');        
    }
    else
    {
        // End:0x98
        if(MyEvilPawn != none)
        {
            CheckCombatTransition();            
        }
        else
        {
            GotoState('Idle');
        }
    }
    Sleep(0.5000000);
    goto 'Begin';
    stop;                
}

state Explore
{
    function StartExplorePOI()
    {
        SetTimer(0.2000000, false, 'StartExplorePOI', self);
        //return;        
    }

    function OnAIExplorePOI(SeqAct_AIExplorePOI Action)
    {
        // End:0x5B
        if(Action.InputLinks[1].bHasImpulse)
        {
            // End:0x58
            if(Action == ExploreAction)
            {
                StopExplore();
            }            
        }
        else
        {
            // End:0xC9
            if(Action.InputLinks[0].bHasImpulse)
            {
                // End:0xAC
                if(Action == ExploreAction)
                {                    
                }
                else
                {
                    StopExplore();
                    NewExploreAction = Action;
                }
            }
        }
        //return;        
    }

    function StopExplore()
    {
        // End:0x77
        if(ExploreAction.bFinishImmediately)
        {
            ExploreCommand.FinishWhenReady();
            AbortCommand(ExploreCommand);
            ExploreAction.StopAction();            
        }
        else
        {
            // End:0xCE
            if(ExploreAction.FinishExploreDelay > 0.0000000)
            {
                SetTimer(ExploreAction.FinishExploreDelay, false, 'FinishExplorePOI', self);                
            }
            else
            {
                FinishExplorePOI();
            }
        }
        //return;        
    }

    function OnTeleportAroundGoal(SeqAct_TeleportAroundGoal Action)
    {
        ExploreCommand.FinishWhenReady();
        AbortCommand(ExploreCommand);
        ExploreAction.StopAction();
        global.OnTeleportAroundGoal(Action);
        //return;        
    }

    function FinishExplorePOI()
    {
        ExploreCommand.FinishWhenReady();
        //return;        
    }
Begin:

    Class'AdvAICmd_ExplorePOI'.static.ExecuteExplore(self, ExploreAction.POIToExplore, false, ExploreAction);
    ExploreAction = none;
    ExploreCommand = none;
    // End:0x8B
    if(NewExploreAction != none)
    {
        global.OnAIExplorePOI(NewExploreAction);
        NewExploreAction = none;
    }
    GotoState('Idle');
    stop;            
}

defaultproperties
{
    CoverFromLightStartTime=-1.0000000
    MoveCommand=Class'AdvAICmd_MoveToGoal'
    ThrowCommand=Class'AdvAICmd_Attack_Throw'
    // Reference: EvilAIReactManager'Default__AdvAIController.ReactionManager0'
    begin object name=ReactionManager0
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=/* Array type was not detected. */
}