class SeqAct_SpExecActionList extends SeqAct_Latent
    native;

/** INCLUDES MACROS STRUCT DECLARATIONS VARIABLE DECLARATIONS */
var() bool bWaitforActionsToFinish;
var() export editinline SPDGenericActionList ActionList;
var Actor MyActor;
var transient float ProcessId;

simulated event SPDProcessManager GetSPDProcessManager()
{
    local SPDProcessManager ProcessManager;

    ProcessManager = none;
    // End:0x31
    if(MyActor != none)
    {
        ProcessManager = Class'SPDProcessManager'.static.Get(MyActor);
    }
    return ProcessManager;
    //return ReturnValue;    
}
