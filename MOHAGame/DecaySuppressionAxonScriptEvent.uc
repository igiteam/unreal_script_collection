class DecaySuppressionAxonScriptEvent extends AxonScriptEvent;

var MOHAScriptAIController Controller;
var MOHAPawn EnemyPawn;
var bool bOnlyCheckDeath;
//var delegate<AboveThreshholdCB> __AboveThreshholdCB__Delegate;
//var delegate<BelowSafeCB> __BelowSafeCB__Delegate;

delegate AboveThreshholdCB()
{
    //return;    
}

delegate BelowSafeCB()
{
    //return;    
}

function Register(KynapseAIController C, optional MOHAPawn A = none, optional bool bOnlyDeath = false, optional name Key = 'stack')
{
    Controller = MOHAScriptAIController(C);
    EnemyPawn = A;
    bOnlyCheckDeath = bOnlyDeath;
    RegisterSubstate(Key);
    //return;    
}

event Start()
{
    // End:0x62
    if(EnemyPawn != none)
    {
        // End:0x3C
        if(!bOnlyCheckDeath)
        {
            AttachToObserver(EnemyPawn.AxonObserver, 'Reload', ReloadCallback);
        }
        AttachToObserver(EnemyPawn.AxonObserver, 'Died', TargetDiedCallback);
    }
    //return;    
}

event Withdraw()
{
    __AboveThreshholdCB__Delegate = None;
    __BelowSafeCB__Delegate = None;
    //return;    
}

event Tick(float DeltaTime)
{
    // End:0x25
    if(Controller.IsSuppressed())
    {
        AboveThreshholdCB();
    }
    Controller.AddSuppression(0.0000000 - (Controller.fSuppressionDecayRate * DeltaTime));
    // End:0x84
    if(Controller.SuppressionMeter < Controller.fSuppressionSafe)
    {
        BelowSafeCB();
    }
    //return;    
}

function ReloadCallback(Actor Caller)
{
    ResetSuppression();
    //return;    
}

function TargetDiedCallback(Actor Caller)
{
    ResetSuppression();
    Controller.SendCCStimulus("SavedFromSuppression");
    //return;    
}

function ResetSuppression()
{
    Controller.AddSuppression(-10.0000000);
    //return;    
}
