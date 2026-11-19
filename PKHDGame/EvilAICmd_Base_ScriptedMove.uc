class EvilAICmd_Base_ScriptedMove extends EvilAICmd_Base_Combat within EvilAIController;

var bool bAllowTransitions;

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

function bool ShouldReturnToIdle()
{
    return false;
    //return ReturnValue;    
}

state InMove
{
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
        // End:0xD1
        if(!bInteruptable)
        {
            Outer.ReactionManager.UnSuppressAll();
            bAllowTransitions = true;
        }
        // End:0x137
        foreach Outer.LatentActions(Action)
        {
            // End:0x136
            if(ClassIsChildOf(Action.Class, Class'SeqAct_AIGuardArea'))
            {
                bIsGuarding = true;
            }            
        }        
        // End:0x169
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
Begin:

    // End:0xFA
    if(VSizeSq(Outer.GetGoalLocation(Outer.ScriptedMoveTarget) - Outer.Pawn.Location) > ((Outer.Pawn.GetCollisionRadius() * float(2)) ** float(2)))
    {
        Outer.SetSpecialMoveGoal(Outer.ScriptedMoveTarget);
    }
    // End:0x233
    if((EvilNavPoint(Outer.ScriptedMoveTarget) != none) && EvilNavPoint(Outer.ScriptedMoveTarget).bCanSlowDown)
    {
        Outer.Focus = none;
        Outer.SetFocalPoint(Outer.MyEvilPawn.Location + (Normal(Vector(Outer.ScriptedMoveTarget.Rotation)) * float(100)));
        Outer.FinishRotation();
    }
    // End:0x24D
    if(ChildStatus != 'Success')
    {        
    }
    else
    {
        PushState('InActions');
    }
    J0x261:

    ExitWithSuccess();
    stop;                    
}

state InActions
{Begin:

    Outer.ExecuteNavActions(Outer.ScriptedMoveTarget);
    PopState();
    stop;                
}
