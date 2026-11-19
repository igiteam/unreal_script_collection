class AdvAI_AllyAnimal extends AdvAIController
    config(AI)
    hidecategories(Navigation);

var config float MasterDistance_FollowInCombat;
var config float MasterDistance_FollowInCover;

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
    Master = EvilPlayerController(GetALocalPlayerController());
    super.Possess(NewPawn, bVehicleTransition);
    //return;    
}

function CheckCombatTransition()
{
    // End:0x11
    if(!HasValidEnemy())
    {
        return;
    }
    super(EvilAIController).CheckCombatTransition();
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

function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum)
{
    //return;    
}

auto state Idle
{
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
Begin:

    Sleep(0.1000000);
    CheckCombatTransition();
    // End:0x2B
    if(!bMoveAroundWhenIdle)
    {
        goto 'Begin';
    }
    // End:0x4D
    if(ActualNavPoint != none)
    {
        PrevNavPoint = ActualNavPoint;
    }
    ActualNavPoint = GetNextNavPoint();
    // End:0x12E
    if((ActualNavPoint != none) && !HasValidEnemy())
    {
        // End:0x12B
        if((PrevNavPoint != ActualNavPoint) && ActualNavPoint != none)
        {
            SetSpecialMoveGoal(ActualNavPoint, MyEvilPawn.GetCollisionRadius() * float(2));
            SetFocalPoint(Normal(Vector(ActualNavPoint.Rotation)) * float(100));
            ExecuteNavActions(ActualNavPoint);
        }        
    }
    else
    {
        // End:0x298
        if(((PrevNavPoint == none) || PrevNavPoint.NextNavPoint == none) && (VSizeSq(Master.MyEvilPawn.Location - MyEvilPawn.Location) > ((MasterDistance_Follow + (MyEvilPawn.GetCollisionRadius() * float(2))) ** float(2))) || !ClearSightToActor(Master.MyEvilPawn))
        {
            SetMoveGoal(Master.MyEvilPawn, FMax(0.0000000, MasterDistance_Follow - (MyEvilPawn.GetCollisionRadius() * float(2))), true);
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
    DefaultCommand=Class'AdvAICmd_Base_FriendlyAI'
    MeleeCommand=Class'EvilAICmd_Wolf_Melee'
    EnemyDistance_Melee=200.0000000
    EnemyDistance_MeleeCharge=500.0000000
    // Reference: EvilAIReactManager'Default__AdvAI_AllyAnimal.ReactionManager0'
    begin object name=ReactionManager0
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=/* Array type was not detected. */
    MasterDistance_Follow=300.0000000
    MasterDistance_FollowRun=600.0000000
    TimeBetweenWalkAndRun=1.0000000
}