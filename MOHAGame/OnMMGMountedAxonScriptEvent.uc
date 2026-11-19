class OnMMGMountedAxonScriptEvent extends AxonScriptEvent;

var MOHAScriptAIController Controller;
//var delegate<MMGMountedCB> __MMGMountedCB__Delegate;

delegate MMGMountedCB()
{
    //return;    
}

function Register(MOHAScriptAIController C, delegate<MMGMountedCB> callback, optional name Key = 'stack')
{
    Controller = C;
    __MMGMountedCB__Delegate = callback;
    RegisterSubstate(Key);
    //return;    
}

function RegActivation(MOHAScriptAIController C, delegate<MMGMountedCB> callback, optional int Level = 0)
{
    Controller = C;
    __MMGMountedCB__Delegate = callback;
    RegisterActivation(Level);
    //return;    
}

event Tick(float DeltaTime)
{
    // End:0x28
    if(MOHAMountedGun(Controller.Pawn) != none)
    {
        MMGMountedCB();
    }
    //return;    
}
