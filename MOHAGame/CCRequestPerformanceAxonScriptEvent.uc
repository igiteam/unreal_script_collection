class CCRequestPerformanceAxonScriptEvent extends AxonScriptEvent;

var KynapseAIController Controller;
var int PauseLevel;
//var delegate<PerformanceCB> __PerformanceCB__Delegate;

delegate PerformanceCB()
{
    //return;    
}

function Register(KynapseAIController C, delegate<PerformanceCB> callback, optional int Level = 0, optional name Key = 'stack')
{
    Controller = C;
    __PerformanceCB__Delegate = callback;
    PauseLevel = Level;
    RegisterSubstate(Key);
    //return;    
}

event Start()
{
    local CCPerformerPawn CCPPawn;

    CCPPawn = CCPerformerPawn(Controller.Pawn);
    // End:0x62
    if(CCPPawn != none)
    {
        CCPPawn.SetPauseLevel(PauseLevel);
        AttachToObserver(CCPPawn.AxonObserver, 'RequestBlockingPerformance', RequestPerformanceCallback);
    }
    //return;    
}

event Withdraw()
{
    local CCPerformerPawn CCPPawn;

    CCPPawn = CCPerformerPawn(Controller.Pawn);
    // End:0x37
    if(CCPPawn != none)
    {
        CCPPawn.ResetPauseLevel();
    }
    //return;    
}

function RequestPerformanceCallback(Actor Caller)
{
    PerformanceCB();
    //return;    
}
