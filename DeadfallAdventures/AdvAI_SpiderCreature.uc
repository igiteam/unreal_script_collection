class AdvAI_SpiderCreature extends EvilAI_Creature
    hidecategories(Navigation);

var() Vector TempDest;
var Vector nextlocation;
var float DesiredOffset;
var bool bIsMoveTargetReachable;

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
    super.Possess(NewPawn, bVehicleTransition);
    //return;    
}

function bool IsFriendly(Controller OtherAI)
{
    return (OtherAI.IsA('EvilAI_Creature') || ClassIsChildOf(OtherAI.Class, Class'AdvAI_Ally')) || ClassIsChildOf(OtherAI.Class, Class'EvilGame.EvilAI_Creature');
    //return ReturnValue;    
}

function MoveToActor(Actor DestinationActor, float DesiredOff)
{
    // End:0x1B
    if(IsInState('ScriptedMove'))
    {
        PopState(true);
    }
    ScriptedMoveTarget = DestinationActor;
    DesiredOffset = DesiredOff;
    PushState('ScriptedMove');
    //return;    
}

function string GetDebugString()
{
    return ((((GetHumanReadableName()) @ "\n") $ string(MyCreaturePawn.GetStateName())) @ "\nRootMotionMode: ") @ string(Pawn.Mesh.RootMotionMode);
    //return ReturnValue;    
}

auto state Idle
{Begin:

    stop;                
}

state ScriptedMove
{
    event Tick(float DeltaTime)
    {
        super(Actor).Tick(DeltaTime);
        global.Tick(DeltaTime);
        //return;        
    }

    function bool FindNavMeshPath()
    {
        NavigationHandle.PathConstraintList = none;
        NavigationHandle.PathGoalList = none;
        Class'Engine.NavMeshPath_Toward'.static.TowardGoal(NavigationHandle, ScriptedMoveTarget);
        Class'Engine.NavMeshGoal_At'.static.AtActor(NavigationHandle, ScriptedMoveTarget);
        return NavigationHandle.FindPath();
        //return ReturnValue;        
    }
Begin:

    NavigationHandle.SetFinalDestination(ScriptedMoveTarget.Location);
    // End:0x94
    if(!NavigationHandle.ActorReachable(ScriptedMoveTarget))
    {
        bIsMoveTargetReachable = false;
        // End:0x86
        if(FindNavMeshPath())
        {            
        }
        else
        {
            ScriptedMoveTarget = none;
        }        
    }
    else
    {
        bIsMoveTargetReachable = true;
        MoveTo(ScriptedMoveTarget.Location, ScriptedFocus, DesiredOffset);
    }
    J0xD4:

    // End:0x22A [Loop If]
    if(((Pawn != none) && ScriptedMoveTarget != none) && !Pawn.ReachedDestination(ScriptedMoveTarget))
    {
        // End:0x185
        if(NavigationHandle.ActorReachable(ScriptedMoveTarget))
        {
            MoveTo(ScriptedMoveTarget.Location, ScriptedFocus, DesiredOffset);            
        }
        else
        {
            // End:0x1A4
            if(bIsMoveTargetReachable)
            {
                Sleep(0.1000000);
                goto 'Begin';
            }
            // End:0x224
            if(NavigationHandle.GetNextMoveLocation(TempDest, 50.0000000))
            {
                // End:0x221
                if(!NavigationHandle.SuggestMovePreparation(TempDest, self))
                {
                    MoveTo(TempDest, ScriptedMoveTarget, DesiredOffset);
                }                
            }
            else
            {
                // [Explicit Break]
                goto J0x22A;
            }
        }
        // [Loop Continue]
        goto J0xD4;
    }
    J0x22A:

    Pawn.ZeroMovementVariables();
    PopState();
    stop;                
}
