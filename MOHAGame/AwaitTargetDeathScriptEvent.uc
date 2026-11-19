class AwaitTargetDeathScriptEvent extends AxonScriptEvent;

var MOHAPawn Target;
//var delegate<TargetDiedCB> __TargetDiedCB__Delegate;

delegate TargetDiedCB()
{
    //return;    
}

function Register(MOHAPawn MyTarget, delegate<TargetDiedCB> callback, optional name Key = 'stack')
{
    // End:0x1A
    if(MyTarget == none)
    {
        return;
    }
    Target = MyTarget;
    __TargetDiedCB__Delegate = callback;
    RegisterSubstate(Key);
    //return;    
}

event Start()
{
    AttachToObserver(Target.AxonObserver, 'Died', OnTargetDied);
    //return;    
}

function OnTargetDied(Actor Caller)
{
    TargetDiedCB();
    //return;    
}
