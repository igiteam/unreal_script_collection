class EvilAICmd_Base_ScriptedMove extends EvilAICmd_Base_Combat within EvilAIController;

var bool bAllowTransitions;
var bool bForceDirectMove;
var name ResumedFromCommandName;

function bool AllowTransitionTo(class<GameAICommand> AttemptCommand)
{
    return bAllowTransitions;
    //return ReturnValue;    
}

function ExitWithFailure()
{
    PopState(true);
    super(EvilAICommand).ExitWithFailure();
    //return;    
}

function ExitWithSuccess()
{
    PopState(true);
    super(EvilAICommand).ExitWithSuccess();
    //return;    
}

function Pushed()
{
    super.Pushed();
    Outer.MoveAction = Outer.NewMoveAction;
    bForceDirectMove = (Outer.MoveAction != none) && Outer.MoveAction.bForceDirectMove;
    PushState('InMove');
    //return;    
}

function Popped()
{
    super.Popped();
    Outer.ClearMoveAction();
    Outer.MyEvilPawn.RollbackLimitedMoveMode();
    //return;    
}

function bool CheckTransition(out class<EvilAICmd_Base_Combat> out_NewCommand, out string out_Reason)
{
    return false;
    //return ReturnValue;    
}

function bool ShouldBeInIdle()
{
    return false;
    //return ReturnValue;    
}

state InMove
{
    function Resumed(name OldCommandName)
    {
        super(GameAICommand).Resumed(OldCommandName);
        ResumedFromCommandName = OldCommandName;
        //return;        
    }

    event PushedState()
    {
        local bool bInteruptable;
        local SeqAct_Latent Action;

        // End:0x81
        foreach Outer.LatentActions(Action)
        {
            // End:0x80
            if((SeqAct_AIMoveToActor(Action) != none) && SeqAct_AIMoveToActor(Action).bInterruptable)
            {
                bInteruptable = true;                
            }
            else
            {                
            }
        }        
        // End:0xD4
        if(!bInteruptable)
        {
            bAllowTransitions = false;
            Outer.ReactionManager.SuppressAll();            
        }
        else
        {
            Outer.ReactionManager.NudgeChannel(Outer, 'UnBlockAbortMovingOnEnemyCloseAndVisible');
            bAllowTransitions = true;
        }
        //return;        
    }

    event PoppedState()
    {
        local SeqAct_Latent Action;
        local bool bIsGuarding, bInteruptable;

        // End:0x81
        foreach Outer.LatentActions(Action)
        {
            // End:0x80
            if((SeqAct_AIMoveToActor(Action) != none) && SeqAct_AIMoveToActor(Action).bInterruptable)
            {
                bInteruptable = true;                
            }
            else
            {                
            }
        }        
        // End:0xD4
        if(!bInteruptable)
        {
            Outer.ReactionManager.UnSuppressAll();
            bAllowTransitions = true;            
        }
        else
        {
            Outer.ReactionManager.NudgeChannel(Outer, 'BlockAbortMovingOnEnemyCloseAndVisible');
        }
        // End:0x180
        foreach Outer.LatentActions(Action)
        {
            // End:0x17F
            if(ClassIsChildOf(Action.Class, Class'SeqAct_AIGuardArea'))
            {
                bIsGuarding = true;
            }            
        }        
        // End:0x1B2
        if(bIsGuarding)
        {
            Outer.BeginGuardCommand(none);            
        }
        else
        {
            Outer.ClearLatentAction(Class'Engine.SeqAct_AIMoveToActor', Outer.ScriptedMoveTarget == none);
        }
        Outer.ScriptedMoveTarget = none;
        Outer.CheckCombatTransition();
        //return;        
    }
MoveTo:

    ResumedFromCommandName = 'None';
    // End:0x19A
    if((VSizeSq(Outer.GetGoalLocation(Outer.ScriptedMoveTarget) - Outer.Pawn.Location) > ((Outer.Pawn.GetCollisionRadius() * float(2)) ** float(2))) || NotEqual_InterfaceInterface(EvilNavPointInterface(Outer.ScriptedMoveTarget), EvilNavPointInterface(none)) && EvilNavPointInterface(Outer.ScriptedMoveTarget).UsePreciseDestination())
    {
        Outer.SetSpecialMoveGoal(Outer.ScriptedMoveTarget,,,,, bForceDirectMove);
    }
    // End:0x2D3
    if((EvilNavPoint(Outer.ScriptedMoveTarget) != none) && EvilNavPoint(Outer.ScriptedMoveTarget).bCanSlowDown)
    {
        Outer.Focus = none;
        Outer.SetFocalPoint(Outer.MyEvilPawn.Location + (Normal(Vector(Outer.ScriptedMoveTarget.Rotation)) * float(100)));
        Outer.FinishRotation();
    }
    // End:0x448
    if((ChildStatus != 'None') && !((ChildStatus == 'Success') && ((ResumedFromCommandName == 'AdvAICmd_MoveToGoal') || ResumedFromCommandName == 'EvilAICmd_MoveToGoal') || ResumedFromCommandName == 'AdvAICmd_MoveToCover') && Outer.Pawn.ReachedDestination(Outer.ScriptedMoveTarget) || Outer.Pawn.ReachedPoint(Outer.GetGoalLocation(Outer.ScriptedMoveTarget), none))
    {
        Outer.Sleep(0.5000000);
        goto 'MoveTo';        
    }
    else
    {
        PushState('InActions');
    }
    J0x45C:

    ExitWithSuccess();
    stop;        
}

state InActions
{Begin:

    Outer.ExecuteNavActions(Outer.ScriptedMoveTarget);
    PopState();
    stop;                
}
