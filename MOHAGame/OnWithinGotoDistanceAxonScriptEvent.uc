class OnWithinGotoDistanceAxonScriptEvent extends AxonScriptEvent;

var MOHAScriptAIController Controller;
var float fMinimumGotoDistance;
//var delegate<WithinGotoDistanceCB> __WithinGotoDistanceCB__Delegate;

delegate WithinGotoDistanceCB()
{
    //return;    
}

function Register(MOHAScriptAIController C, float MinDist, delegate<WithinGotoDistanceCB> callback, optional name Key = 'stack')
{
    Controller = C;
    __WithinGotoDistanceCB__Delegate = callback;
    fMinimumGotoDistance = MinDist;
    RegisterSubstate(Key);
    //return;    
}

event Tick(float DeltaTime)
{
    // End:0x41
    if((Controller.fGotoDistanceRemaining > 0.0000000) && Controller.fGotoDistanceRemaining <= fMinimumGotoDistance)
    {
        WithinGotoDistanceCB();
    }
    //return;    
}
