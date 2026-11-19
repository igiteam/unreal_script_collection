class EvilAICmd_Base_ScriptedRouteMove extends EvilAICmd_Base_ScriptedMove within EvilAIController;

function Pushed()
{
    super(EvilAICmd_Base_Combat).Pushed();
    Outer.MoveAction = Outer.NewMoveAction;
    PushState('InRouteMove');
    //return;    
}

function Popped()
{
    Outer.ScriptedRouteIndex = 0;
    super.Popped();
    //return;    
}

state InRouteMove
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
    J0x00:
    // End:0x2E8 [Loop If]
    if((((Outer.Pawn != none) && Outer.ScriptedRoute != none) && Outer.ScriptedRouteIndex < Outer.ScriptedRoute.RouteList.Length) && Outer.ScriptedRouteIndex >= 0)
    {
        Outer.ScriptedMoveTarget = Outer.ScriptedRoute.RouteList[Outer.ScriptedRouteIndex].Actor;
        // End:0x185
        if(Outer.ScriptedMoveTarget != none)
        {
            PushState('InMove');
        }
        // End:0x2AF
        if((Outer.Pawn != none) && Outer.Pawn.ReachedDestination(Outer.ScriptedRoute.RouteList[Outer.ScriptedRouteIndex].Actor))
        {
            // End:0x28C
            if(Outer.bReverseScriptedRoute)
            {
                Outer.ScriptedRouteIndex--;                
            }
            else
            {
                Outer.ScriptedRouteIndex++;
            }            
        }
        else
        {
            Outer.ScriptedRoute = none;
            ExitWithFailure();
        }
        bCanOuterFastSpinUp = false;
        // [Loop Continue]
        goto J0x00;
    }
    // End:0x4DA
    if(((Outer.Pawn != none) && Outer.ScriptedRoute != none) && Outer.ScriptedRoute.RouteList.Length > 0)
    {
        switch(Outer.ScriptedRoute.RouteType)
        {
            // End:0x3BD
            case 0:
                ExitWithSuccess();
                // End:0x4D7
                break;
            // End:0x475
            case 1:
                Outer.bReverseScriptedRoute = !Outer.bReverseScriptedRoute;
                // End:0x448
                if(Outer.bReverseScriptedRoute)
                {
                    Outer.ScriptedRouteIndex--;                    
                }
                else
                {
                    Outer.ScriptedRouteIndex++;
                }
                goto 'Begin';
                // End:0x4D7
                break;
            // End:0x4A7
            case 2:
                Outer.ScriptedRouteIndex = 0;
                goto 'Begin';
                // End:0x4D7
                break;
            // End:0xFFFF
            default:
                Outer.ScriptedRoute = none;
                ExitWithFailure();
                // End:0x4D7
                break;
                break;
        }        
    }
    else
    {
        Outer.ScriptedRoute = none;
        ExitWithSuccess();
    }
    Outer.ScriptedRoute = none;
    ExitWithFailure();
    stop;        
}

state InMove
{
    ignores PushedState, PoppedState;

    function ExitWithSuccess()
    {
        PopState();
        //return;        
    }
    stop;    
}
