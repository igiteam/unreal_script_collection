class LODStatusScriptEvent extends LodExemptAxonScriptEvent;

var KynapseAIController Controller;
var bool bAwakeLastFrame;
//var delegate<LODJustWentToSleepCB> __LODJustWentToSleepCB__Delegate;

delegate LODJustWentToSleepCB()
{
    //return;    
}

function RegisterLODStatusChangeEvent(KynapseAIController C, delegate<LODJustWentToSleepCB> wenttosleepCallback, optional name Key = 'stack')
{
    Controller = C;
    __LODJustWentToSleepCB__Delegate = wenttosleepCallback;
    RegisterSubstate(Key);
    //return;    
}

event Start()
{
    // End:0x4D
    if(MOHAPawn(Controller.Pawn) != none)
    {
        AttachToObserver(MOHAPawn(Controller.Pawn).AxonObserver, 'EnteredStasis', OnEnteredStasis);
    }
    //return;    
}

event Withdraw()
{
    __LODJustWentToSleepCB__Delegate = None;
    //return;    
}

function OnEnteredStasis(Actor Caller)
{
    LODJustWentToSleepCB();
    //return;    
}
