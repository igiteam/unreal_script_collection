class ScriptGotoBrainState extends AxonControllerBrainState;

var export editinline MOHAGotoService GotoService;
var Vector GotoDest;
var float fMoveSpeed;

function RegisterActivationEvents()
{
    RegisterAxonActivationNamedScriptEventListener('scriptgoto', ActivationEventTripped, 15);
    //return;    
}

function ActivationEventTripped()
{
    // End:0x35
    if(GetCallbackParamVector('Destination', GotoDest))
    {
        GetCallbackParamFloat('MoveSpeed', fMoveSpeed);
        ActivateBrain();
    }
    //return;    
}

function StartBrain()
{
    super(AxonBrainState).StartBrain();
    SetSuppressionLevel(15);
    GotoState('Goto');
    //return;    
}

function BrainEnded(bool bAborted, bool bFailed)
{
    FinishBrain();
    // End:0x2E
    if(!bAborted)
    {
        Controller.FinishAIMoveToActor(bFailed);
    }
    //return;    
}

state Goto extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        RegisterAxonNamedScriptEventListener('gotoaborted', Abort);
        GotoService.SubstateGotoOIR(arrived, GotoDest,, 'Aim',, fMoveSpeed);
        //return;        
    }

    function arrived()
    {
        local bool failed;

        failed = false;
        // End:0x26
        if(GotoService.GetMoveFailed())
        {
            failed = true;
        }
        BrainEnded(false, failed);
        //return;        
    }

    function Abort()
    {
        BrainEnded(true, false);
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: MOHAGotoService'Default__ScriptGotoBrainState.GotoFNCService0'
    begin object name=GotoFNCService0 class=Class'MOHAGotoService'
    end object
    GotoService=GotoFNCService0
    fMoveSpeed=500.0000000
    EventServices=/* Array type was not detected. */
}