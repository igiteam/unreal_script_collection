class EvilAI_ZombieNavMesh extends EvilAIController
    config(AI)
    hidecategories(Navigation);

simulated event PostBeginPlay()
{
    super(Controller).PostBeginPlay();
    //return;    
}

event Possess(Pawn inPawn, bool bVehicleTransition)
{
    super.Possess(inPawn, bVehicleTransition);
    //return;    
}

function BeginMeleeCommand(Pawn TargetPawn, coerce optional string Reason)
{
    //return;    
}

function UpdateEnemy(Pawn InEnemy)
{
    //return;    
}

function bool NotifyBump(Actor Other, Vector HitNormal)
{
    return false;
    //return ReturnValue;    
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
    return ((((((((((((((((((((((((((GetHumanReadableName()) @ "\nState A/P:") @ string(DebugActualState)) @ "/") @ string(DebugOldState)) @ "\n") @ string(Pawn.GetStateName())) @ "CL:") @ CommandListStack) @ "Phys") @ string(Pawn.Physics)) @ "\nRMM") @ string(Pawn.Mesh.RootMotionMode)) @ "\nMoveTimer") @ string(MoveTimer)) @ "\nVelocity:") @ string(Pawn.Velocity)) @ "(length:") @ string(VSize(Pawn.Velocity))) $ ")\nAccel:") @ string(Pawn.Acceleration)) @ "(length:") @ string(VSize(Pawn.Acceleration))) $ ")\nEnemy") @ string(Enemy)) @ "\nBase") @ string(Pawn.Base);
    //return ReturnValue;    
}

simulated function GoGoGo(optional bool OnlyRotate = false)
{
    local EvilCoverLink DestCover;

    // End:0x30
    if(IsTimerActive('DelayedDestroyGoal'))
    {
        ClearTimer('DelayedDestroyGoal');
    }
    // End:0x5D
    if(FindCommandOfClass(Class'EvilAICmd_MoveToGoal') != none)
    {
        AbortCommand(CommandList);
    }
    // End:0x95
    if(OnlyRotate)
    {
        Focus = MyEvilPawn.Goal;        
    }
    else
    {
        // End:0x13A
        foreach AllActors(Class'EvilCoverLink', DestCover)
        {
            // End:0x139
            if(VSize(DestCover.Location - MyEvilPawn.Goal.Location) < float(150))
            {
                SetSpecialMoveGoal(DestCover);
                SetTimer(0.5000000, true, 'DelayedDestroyGoal');                
                return;
            }            
        }        
        SetMoveGoal(MyEvilPawn.Goal);
        SetTimer(0.5000000, true, 'DelayedDestroyGoal');
    }
    //return;    
}

function DelayedDestroyGoal()
{
    // End:0x8F
    if((CommandList == none) || FindCommandOfClass(Class'EvilAICmd_MoveToGoal') == none)
    {
        // End:0x8F
        if(MyEvilPawn.Goal != none)
        {
            MyEvilPawn.Goal.Destroy();
            ClearTimer('DelayedDestroyGoal');
        }
    }
    //return;    
}

auto state Idle
{Begin:

    Sleep(1.0000000);
    goto 'Begin';
    stop;        
}

defaultproperties
{
    // Reference: EvilAIReactManager'Default__EvilAI_ZombieNavMesh.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__EvilAIController.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
    // Reference: EvilAIReactCond_Stumble'Default__EvilAI_ZombieNavMesh.RunFail0'
    // Archetype: EvilAIReactCond_Stumble'Default__EvilAIController.RunFail0'
    begin object name="RunFail0"
    end object
    DefaultReactConditions[0]=RunFail0
}