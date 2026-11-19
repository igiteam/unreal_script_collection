class OnMMGUnMountedAxonScriptEvent extends AxonScriptEvent;

var MOHAScriptAIController Controller;
//var delegate<MMGUnMountedCB> __MMGUnMountedCB__Delegate;

delegate MMGUnMountedCB()
{
    //return;    
}

function Register(MOHAScriptAIController C, delegate<MMGUnMountedCB> callback, optional name Key = 'stack')
{
    Controller = C;
    __MMGUnMountedCB__Delegate = callback;
    RegisterSubstate(Key);
    //return;    
}

function RegActivation(MOHAScriptAIController C, delegate<MMGUnMountedCB> callback, optional int Level = 0)
{
    Controller = C;
    __MMGUnMountedCB__Delegate = callback;
    RegisterActivation(Level);
    //return;    
}

event Tick(float DeltaTime)
{
    // End:0x28
    if(MOHAMountedGun(Controller.Pawn) == none)
    {
        MMGUnMountedCB();
    }
    //return;    
}
