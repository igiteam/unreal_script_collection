class AdvAI_Ally extends AdvAI_Covering
    config(AI)
    hidecategories(Navigation);

var config float MasterDistance_FollowInCombat;
var config float MasterDistance_FollowInCover;
var bool bExposedToEnemy;
var bool bUnderAttack;
var Vector LastMasterLocation;
var Vector LastLocationNextToMaster;

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
    Master = EvilPlayerController(GetALocalPlayerController());
    super(AdvAIController_Cover).Possess(NewPawn, bVehicleTransition);
    //return;    
}

function CheckCombatTransition()
{
    // End:0x27
    if((int(CurrentBehaviorMode) == int(1)) && !HasValidEnemy())
    {
        return;
    }
    super(EvilAIController).CheckCombatTransition();
    //return;    
}

function bool BlockCombatTransitions()
{
    // End:0x12
    if(bBlockCombatTransition)
    {
        return true;        
    }
    else
    {
        return super(AdvAIController_Cover).BlockCombatTransitions();
    }
    //return ReturnValue;    
}

function CheckFlocking()
{
    //return;    
}

function SetSpecialMoveGoal(Actor InGoal, optional float InGoalDistance = 0.0000000, optional bool bInUpdateGoal, optional bool bInForceWalk, optional bool bInShiftDestination = false, optional bool bInForceDirectMove)
{
    local EvilNavPoint NavPoint;

    NavPoint = EvilNavPoint(InGoal);
    // End:0x4F
    if(NavPoint != none)
    {
        ActualNavPoint = NavPoint;
    }
    super(EvilAIController).SetSpecialMoveGoal(InGoal, InGoalDistance, bInUpdateGoal, bInForceWalk, bInShiftDestination, bInForceDirectMove);
    //return;    
}

function EvilNavPoint GetNextNavPoint()
{
    local EvilNavPoint NavPoint;

    // End:0x12E
    if(((PrevNavPoint != none) && PrevNavPoint.NextNavPoint != none) && VSize(Master.MyEvilPawn.Location - PrevNavPoint.NextNavPoint.Location) < (VSize(MyEvilPawn.Location - PrevNavPoint.NextNavPoint.Location) + MasterDistance_Follow))
    {
        NavPoint = PrevNavPoint.NextNavPoint;
    }
    return NavPoint;
    //return ReturnValue;    
}

function NotifyMoveModeChanged(EvilTypesNative.EMoveMode InNewMode, EvilTypesNative.EMoveMode InOldMode)
{
    super(EvilAIController).NotifyMoveModeChanged(InNewMode, InOldMode);
    switch(InNewMode)
    {
        // End:0x5F
        case 1:
            LastWalkTimeToMaster = WorldInfo.TimeSeconds;
            // End:0x95
            break;
        // End:0x8F
        case 2:
            LastRunTimeToMaster = WorldInfo.TimeSeconds;
            // End:0x95
            break;
        // End:0xFFFF
        default:
            // End:0x95
            break;
            break;
    }
    //return;    
}

function EvadeAwayFromActor(Actor DangerActor, optional EvilPawn Attacker, optional bool bInCombatZones)
{
    //return;    
}

function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum)
{
    local TraceHitInfo HitInfo;
    local int EnemyIdx;

    // End:0x1BD
    if(InstigatedBy != none)
    {
        // End:0x1BD
        if(!IsFriendlyPawn(InstigatedBy.Pawn) && int(InstigatedBy.GetTeamNum()) != int(GetTeamNum()))
        {
            ReactionManager.IncomingDamage(InstigatedBy.Pawn, true, DamageType, HitInfo, InstigatedBy.Pawn.Location, Damage);
            ProcessStimulus(InstigatedBy.Pawn, 2);
            // End:0x1BD
            if(InstigatedBy.Pawn != none)
            {
                EnemyIdx = GetAIEnemyInfoIdx(InstigatedBy.Pawn);
                // End:0x1BD
                if(EnemyIdx != -1)
                {
                    EnemyInfoList[EnemyIdx].GivenDamageToMe += float(1);
                }
            }
        }
    }
    //return;    
}

function OnForceCover(SeqAct_ForceCover inAction)
{
    OnForceCover2(inAction);
    //return;    
}

function OnForceCover2(SeqAct_ForceCover inAction, optional bool bForceStartForceCoverAction = false)
{
    local CoverInfo CoverInfoToForce;
    local AdvAICmd_ForceCover ForceCoverCommand;
    local bool bDontPushCommand;

    ForceCoverCommand = FindCommandOfClass(Class'AdvAICmd_ForceCover');
    ForceCoverAction = inAction;
    // End:0x13F
    if(ForceCoverCommand != none)
    {
        // End:0xE6
        if(inAction.CoverToForce == ForceCoverCommand.CoverInfoToForce.Link)
        {
            ForceCoverCommand.bFireFromCover = inAction.bFireFromCover;
            bDontPushCommand = true;            
        }
        else
        {
            AbortCommand(ForceCoverCommand);
            // End:0x133
            if(inAction.bInvalidateCover)
            {
                InvalidateCoverAction();
                InvalidateCover();
            }
            bDontPushCommand = false;
        }
    }
    // End:0x257
    if((inAction.InputLinks[0].bHasImpulse || bForceStartForceCoverAction) && !bDontPushCommand)
    {
        // End:0x1B6
        if(int(CurrentBehaviorMode) < int(3))
        {
            ChangeBehaviorMode(3);
        }
        CoverInfoToForce.Link = inAction.CoverToForce;
        CoverInfoToForce.SlotIdx = 0;
        Class'AdvAICmd_ForceCover'.static.ForceCover(self, CoverInfoToForce, inAction.bFireFromCover);
    }
    //return;    
}

function bool IsCoveringForced()
{
    local AdvAICmd_ForceCover ForceCoverCommand;

    ForceCoverCommand = FindCommandOfClass(Class'AdvAICmd_ForceCover');
    return super(EvilAIController).IsCoveringForced() || ForceCoverCommand != none;
    //return ReturnValue;    
}

function bool EvaluateCover(EvilTypes.ECoverSearchType Type, Actor GoalActor, out CoverInfo out_Cover, optional float Radius = 2000.0000000, optional bool bOverrideSearchStartLocation, optional Vector SearchStartLocation)
{
    return super(AdvAIController_Cover).EvaluateCover(5, GoalActor, out_Cover, Radius);
    //return ReturnValue;    
}

function float GetShootingPriority()
{
    return 1.0000000;
    //return ReturnValue;    
}

function Vector GetLocationNearToPlayer()
{
    local array<Vector> ValidPositions;
    local Vector PlayerLocation;
    local int LocationsCount, LocationIndex;

    LocationsCount = 5;
    PlayerLocation = Master.MyEvilPawn.Location + (Normal(Pawn.Location - Master.MyEvilPawn.Location) * ((MasterDistance_Follow * 0.5000000) - MyEvilPawn.GetCollisionRadius()));
    ValidPositions.Remove(0, ValidPositions.Length);    
    NavigationHandle.GetValidPositionsForBox(PlayerLocation, MasterDistance_Follow, MyEvilPawn.GetCollisionExtent(), false, ValidPositions, LocationsCount, MyEvilPawn.GetCollisionRadius());
    LocationIndex = Rand(LocationsCount);
    // End:0x23C
    if(AdvAI_NPCJennifer(self) != none)
    {
        DrawDebugBox(ValidPositions[1], vect(5.0000000, 5.0000000, 5.0000000), 255, 0, 255, true);
        DrawDebugLine(Pawn.Location, ValidPositions[LocationIndex], 255, 0, 255, true);
        DrawDebugString(ValidPositions[LocationIndex], "Loc " @ string(ValidPositions[LocationIndex]));        
    }
    else
    {
        DrawDebugBox(ValidPositions[0], vect(5.0000000, 5.0000000, 5.0000000), 0, 0, 255, true);
        DrawDebugLine(Pawn.Location, ValidPositions[LocationIndex], 0, 0, 255, true);
        DrawDebugString(ValidPositions[LocationIndex], "Loc " @ string(ValidPositions[LocationIndex]));
    }
    return ValidPositions[LocationIndex];
    //return ReturnValue;    
}

function bool MasterMoved()
{
    return VSizeSq(LastMasterLocation - Master.Pawn.Location) > ((Master.MyEvilPawn.GetCollisionRadius() * float(2)) ** float(2));
    //return ReturnValue;    
}

function bool MovedFromMaster()
{
    return VSizeSq(LastLocationNextToMaster - Pawn.Location) > ((Master.MyEvilPawn.GetCollisionRadius() * float(2)) ** float(2));
    //return ReturnValue;    
}

function ModifyDamage(out int Damage)
{
    // End:0x24
    if(bUnderAttack)
    {
        Damage = Damage * 100;
    }
    //return;    
}

function bool IsExposedToEnemy(Pawn CheckedEnemy)
{
    local float val, Distance;

    // End:0x218
    if(CheckedEnemy.IsAliveAndWell() && AdvPawn(CheckedEnemy).MyAdvAI.Enemy == Pawn)
    {
        val = Normal(Vector(Cover.Link.GetSlotRotation(Cover.SlotIdx))) Dot Normal(CheckedEnemy.Location - Cover.Link.GetSlotLocation(Cover.SlotIdx));
        Distance = VSizeSq(CheckedEnemy.Location - Cover.Link.GetSlotLocation(Cover.SlotIdx));
        // End:0x213
        if((val < 0.7800000) && Distance > float(100 * 100))
        {
            // End:0x20E
            if(Enemy != CheckedEnemy)
            {
                SetEnemy(CheckedEnemy);
            }
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

function bool IsUnderAttack()
{
    local AdvAIController AdvController;
    local float Distance, Angle;
    local int Damage, EnemyIdx;

    // End:0x326
    foreach WorldInfo.AllControllers(Class'AdvAIController', AdvController)
    {
        // End:0x325
        if(((AdvController != Outer) && AdvController.Pawn.IsAliveAndWell()) && AdvController.Enemy == Pawn)
        {
            Angle = Normal(Vector(Cover.Link.GetSlotRotation(Cover.SlotIdx))) Dot Normal(AdvController.Pawn.Location - Cover.Link.GetSlotLocation(Cover.SlotIdx));
            Distance = VSizeSq(AdvController.Pawn.Location - Cover.Link.GetSlotLocation(Cover.SlotIdx));
            // End:0x325
            if((Distance < float(500 * 500)) || Angle < 0.7800000)
            {
                EnemyIdx = GetAIEnemyInfoIdx(AdvController.Pawn);
                Damage = int(EnemyInfoList[EnemyIdx].GivenDamageToMe);
                // End:0x322
                if(Damage > 1)
                {
                    // End:0x31F
                    if(Enemy != AdvController.Pawn)
                    {
                        SetEnemy(AdvController.Pawn);
                    }                    
                    return true;
                }
                // End:0x325
                continue;
            }
        }        
    }    
    return false;
    //return ReturnValue;    
}

function NotifyKilled(Controller Killer, Controller Killed, Pawn KilledPawn, class<DamageType> damageTyp)
{
    // End:0x6B
    if(Killed.bIsPlayer)
    {
        MyEvilPawn.FadeOutAllDialogSounds();
        MyEvilPawn.ClearTimer('PlayRequestHelp');
    }
    super(EvilAIController).NotifyKilled(Killer, Killed, KilledPawn, damageTyp);
    //return;    
}

function bool CanPlayKilledEnemy(Controller Killer, Controller Killed, Pawn KilledPawn, class<DamageType> damageTyp)
{
    return ((super(EvilAIController).CanPlayKilledEnemy(Killer, Killed, KilledPawn, damageTyp) && Master != none) && Master.MyEvilPawn != none) && Master.MyEvilPawn.IsAliveAndWell();
    //return ReturnValue;    
}

function bool CanPlayRequestHelp()
{
    return ((super(EvilAIController).CanPlayRequestHelp() && Master != none) && Master.MyEvilPawn != none) && Master.MyEvilPawn.IsAliveAndWell();
    //return ReturnValue;    
}

function bool CanClaimCover(CoverLink CoverLink)
{
    // End:0x47
    if((EvilCoverLink(CoverLink) != none) && EvilCoverLink(CoverLink).bEnemyPawnsOnly)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function bool ShouldTeleportToGoal(optional Vector GoalLocation)
{
    local float PathDistance;

    // End:0x12
    if(!bCanTeleportToGoal)
    {
        return false;
    }
    // End:0x49
    if(MoveGoal != none)
    {
        GoalLocation = MoveGoal.Location;
    }
    // End:0xA4
    if((MoveGoal == none) || (MoveGoal != Master) && MoveGoal != Master.MyEvilPawn)
    {
        return false;        
    }
    else
    {
        // End:0xB3
        if(ExposedToPlayer())
        {
            return false;
        }
    }
    // End:0x133
    if((NavigationHandle != none) && NavigationHandle.GetPathCacheLength() > 0)
    {
        PathDistance = NavigationHandle.CalculatePathDistance(GoalLocation);
        return PathDistance > ShouldTeleportDistance;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

function bool CanEngageMelee()
{
    return ((super(EvilAIController).CanEngageMelee() && Enemy != none) && int(Enemy.Physics) != int(10)) && (EvilPawn(Enemy) == none) || int(EvilPawn(Enemy).PawnAction) != 13;
    //return ReturnValue;    
}

function bool CanMeleeAttack()
{
    return ((super(AdvAIController_Cover).CanMeleeAttack() && Enemy != none) && int(Enemy.Physics) != int(10)) && (EvilPawn(Enemy) == none) || int(EvilPawn(Enemy).PawnAction) != 13;
    //return ReturnValue;    
}

auto state Idle
{
    function bool ShouldBeInIdle()
    {
        return false;
        //return ReturnValue;        
    }

    event BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        //return;        
    }

    event ContinuedState()
    {
        super(Object).ContinuedState();
        //return;        
    }

    function bool StayAlerted()
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

    Sleep(0.1000000);
    // End:0x60
    if(((int(CurrentBehaviorMode) == int(2)) || (int(CurrentBehaviorMode) == int(3)) && !bBlockCombatTransition) && !StayAlerted())
    {
        ChangeBehaviorMode(1);
    }
    CheckCombatTransition();
    // End:0x83
    if(!bMoveAroundWhenIdle)
    {
        goto 'Begin';
    }
    // End:0xA5
    if(ActualNavPoint != none)
    {
        PrevNavPoint = ActualNavPoint;
    }
    ActualNavPoint = GetNextNavPoint();
    // End:0x186
    if((ActualNavPoint != none) && !HasValidEnemy())
    {
        // End:0x183
        if((PrevNavPoint != ActualNavPoint) && ActualNavPoint != none)
        {
            SetSpecialMoveGoal(ActualNavPoint, MyEvilPawn.GetCollisionRadius() * float(2));
            SetFocalPoint(Normal(Vector(ActualNavPoint.Rotation)) * float(100));
            ExecuteNavActions(ActualNavPoint);
        }        
    }
    else
    {
        // End:0x3AA
        if((((((PrevNavPoint == none) || PrevNavPoint.NextNavPoint == none) && Master != none) && Master.MyEvilPawn != none) && (VSizeSq(Master.MyEvilPawn.Location - MyEvilPawn.Location) > ((MasterDistance_Follow + (MyEvilPawn.GetCollisionRadius() * float(2))) ** float(2))) || !ClearSightToActor(Master.MyEvilPawn)) && (MasterMoved()) || MovedFromMaster())
        {
            SetMoveGoal(Master.MyEvilPawn, FMax(0.0000000, MasterDistance_Follow - (MyEvilPawn.GetCollisionRadius() * float(2))), true);
            LastMasterLocation = Master.Pawn.Location;
            LastLocationNextToMaster = Pawn.Location;
            Focus = none;
        }
    }
    Sleep(RandRange(1.0000000, 2.0000000));
    goto 'Begin';
    stop;                    
}

defaultproperties
{
    MasterDistance_FollowInCombat=600.0000000
    MasterDistance_FollowInCover=100.0000000
    bMoveAroundWhenIdle=true
    DefaultCommand=Class'AdvAICmd_Base_CoverNPC'
    ShouldTeleportDistance=1000.0000000
    EnemyDistance_Shoot=3000.0000000
    EnemyDistance_Throw=1500.0000000
    EnemyDistance_Melee=200.0000000
    EnemyDistance_MeleeCharge=300.0000000
    EnemyDistance_MinimalStrafeDistance=1500.0000000
    EnemyDistance_HearFootSteps=1000.0000000
    SightRadius=6000.0000000
    // Reference: EvilAIReactManager'Default__AdvAI_Ally.ReactionManager0'
    begin object name=ReactionManager0
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=/* Array type was not detected. */
    MaxTimeBetweenFireBurst=2.5000000
    MinTimeBetweenFireBurst=2.0000000
    TimeBetweenThrows=16.0000000
    BurstFireTimeout=3.0000000
    BurstFireSpreadTime=1.0000000
    DefaultAggressionLevel=EAggressionLevel.AL_Covered
    MasterDistance_Follow=300.0000000
    MasterDistance_FollowRun=600.0000000
    TimeBetweenWalkAndRun=1.0000000
}