class EvilAICmd_NavAction extends EvilAICommand within EvilAIController;

var array<EvilNavPointAction> NavPointActions;
var EvilNavPointAction CurrentNavPointAction;
var EvilNavPointAction TempNavPointAction;

static function bool ExecuteActions(EvilAIController AI, array<EvilNavPointAction> InNavPointActions)
{
    local EvilAICmd_NavAction Cmd;

    // End:0xA7
    if((AI != none) && AI.MyEvilPawn != none)
    {
        Cmd = new (AI) Class'EvilAICmd_NavAction';
        Cmd.NavPointActions = InNavPointActions;
        AI.PushCommand(Cmd);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function Pushed()
{
    super.Pushed();
    // End:0x2B
    if(NavPointActions.Length > 0)
    {
        GotoState('SwitchAction');        
    }
    else
    {
        ExitWithFailure();
    }
    //return;    
}

function Popped()
{
    super(GameAICommand).Popped();
    // End:0x5C
    if((CurrentNavPointAction != none) && CurrentNavPointAction.IsNavActionActive())
    {
        CurrentNavPointAction.OnNavActionAbort();
    }
    //return;    
}

state SwitchAction
{Begin:

    // End:0x8C
    foreach NavPointActions(TempNavPointAction)
    {
        // End:0x81
        if(TempNavPointAction.InitNavAction(Outer.MyEvilPawn))
        {
            CurrentNavPointAction = TempNavPointAction;
            PushState('inAction');            
        }
        else
        {
            ExitWithFailure();
        }        
    }    
    ExitWithSuccess();
    stop;                    
}

state inAction
{Begin:

    CurrentNavPointAction.StartNavAction();
    J0x1F:

    Outer.Sleep(0.1000000);
    // End:0x1F
    if(!(!CurrentNavPointAction.IsNavActionActive()))
        goto J0x1F;
    CurrentNavPointAction.OnNavActionFinish();
    // End:0xB5
    if(CurrentNavPointAction.Status != 'Success')
    {
        ExitWithFailure();
    }
    PopState();
    stop;                
}
