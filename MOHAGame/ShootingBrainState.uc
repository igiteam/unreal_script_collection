class ShootingBrainState extends AxonControllerBrainState;

var() float fWaitTime;
var export editinline BurstFireAxonScriptEvent BurstFireEvent;

function StartBrain()
{
    super(AxonBrainState).StartBrain();
    GotoState('StartShooting');
    //return;    
}

function SuspendBrain(AxonBrainState usurperState)
{
    super(AxonBrainState).SuspendBrain(usurperState);
    Controller.CancelBurst();
    //return;    
}

state StartShooting extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        BurstFireEvent.RegisterBurstSubstate(Controller, Controller.GetVeryLongBurst(), BurstDone, none);
        //return;        
    }

    function BurstDone()
    {
        GotoState('wait');
        //return;        
    }
    stop;    
}

state wait extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        RegisterAxonSubstateTimer(fWaitTime, TimerDone);
        //return;        
    }

    function TimerDone()
    {
        GotoState('StartShooting');
        //return;        
    }
    stop;    
}

defaultproperties
{
    fWaitTime=2.0000000
    // Reference: BurstFireAxonScriptEvent'Default__ShootingBrainState.BurstFireEvent0'
    begin object name=BurstFireEvent0 class=Class'BurstFireAxonScriptEvent'
    end object
    BurstFireEvent=BurstFireEvent0
    AxonScriptEvents=/* Array type was not detected. */
}