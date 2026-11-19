class CCAwaitPerformanceAxonScriptEvent extends AxonScriptEvent;

var KynapseAIController Controller;
//var delegate<PerformanceCB> __PerformanceCB__Delegate;

delegate PerformanceCB()
{
    //return;    
}

function Register(KynapseAIController C, delegate<PerformanceCB> callback, optional name Key = 'stack')
{
    Controller = C;
    __PerformanceCB__Delegate = callback;
    RegisterSubstate(Key);
    //return;    
}

event Start()
{
    local CCPerformerPawn CCPPawn;

    CCPPawn = CCPerformerPawn(Controller.Pawn);
    // End:0x4A
    if(CCPPawn != none)
    {
        AttachToObserver(CCPPawn.AxonObserver, 'FinishBlockingPerformance', FinishPerformanceCallback);
    }
    //return;    
}

event Withdraw()
{
    local CCPerformerPawn CCPPawn;

    CCPPawn = CCPerformerPawn(Controller.Pawn);
    // End:0x86
    if((CCPPawn != none) && CCPPawn.CCP.PerformanceState != none)
    {
        DetachFromObserver(CCPPawn.AxonObserver, 'FinishBlockingPerformance');
        CCPPawn.CCP.PerformanceState.StopPerformance();
    }
    GotoState('None');
    //return;    
}

function FinishPerformanceCallback(Actor Caller)
{
    PerformanceCB();
    //return;    
}
