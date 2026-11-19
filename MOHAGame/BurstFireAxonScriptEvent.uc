class BurstFireAxonScriptEvent extends AxonScriptEvent;

var BURST_TYPE BurstType;
var Actor FireTarget;
var MOHAScriptAIController Controller;
//var delegate<BurstDoneCB> __BurstDoneCB__Delegate;

delegate BurstDoneCB()
{
    //return;    
}

function RegisterBurstSubstate(MOHAScriptAIController C, BURST_TYPE BurstTypeIn, delegate<BurstDoneCB> callback, optional Actor Target = none, optional name Key = 'stack')
{
    Controller = C;
    BurstType = BurstTypeIn;
    FireTarget = Target;
    __BurstDoneCB__Delegate = callback;
    RegisterSubstate(Key);
    //return;    
}

event Start()
{
    local CCPerformerPawn CCPPawn;

    Controller.StartBurst(BurstType, BurstDone, FireTarget);
    CCPPawn = CCPerformerPawn(Controller.Pawn);
    // End:0x7D
    if((none != CCPPawn) && none != CCPPawn.CCP)
    {
        CCPPawn.CCP.SetBodyState_Firing(true);
    }
    //return;    
}

function BurstDone()
{
    BurstDoneCB();
    //return;    
}

event Withdraw()
{
    local CCPerformerPawn CCPPawn;

    Controller.CancelBurst(false);
    CCPPawn = CCPerformerPawn(Controller.Pawn);
    // End:0x6B
    if((none != CCPPawn) && none != CCPPawn.CCP)
    {
        CCPPawn.CCP.SetBodyState_Firing(false);
    }
    //return;    
}
