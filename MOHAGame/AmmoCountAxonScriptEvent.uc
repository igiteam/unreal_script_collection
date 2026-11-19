class AmmoCountAxonScriptEvent extends AxonScriptEvent;

var KynapseAIController Controller;
var MOHAPawn Pawn;
var int AmmoCount;
var int ShotsFired;
var bool bIsRegistered;
//var delegate<ReachedAmmoCountCB> __ReachedAmmoCountCB__Delegate;

delegate ReachedAmmoCountCB()
{
    //return;    
}

function bool IsRegistered()
{
    return bIsRegistered;
    //return ReturnValue;    
}

function RegisterAmmoCountSubstate(KynapseAIController C, delegate<ReachedAmmoCountCB> callback, int Ammo, MOHAPawn A, optional name Key = 'stack')
{
    Controller = C;
    Pawn = A;
    AmmoCount = Ammo;
    __ReachedAmmoCountCB__Delegate = callback;
    RegisterSubstate(Key);
    bIsRegistered = true;
    //return;    
}

function ResetShotsFired()
{
    ShotsFired = 0;
    //return;    
}

event Start()
{
    // End:0x38
    if(Pawn != none)
    {
        ShotsFired = 0;
        AttachToObserver(Pawn.AxonObserver, 'NotifyWeaponFired', ShotFiredCallback);
    }
    //return;    
}

event Withdraw()
{
    bIsRegistered = false;
    __ReachedAmmoCountCB__Delegate = None;
    //return;    
}

event Tick(float DeltaTime)
{
    // End:0x1E
    if(ShotsFired >= AmmoCount)
    {
        ReachedAmmoCountCB();
    }
    //return;    
}

function ShotFiredCallback(Actor Caller)
{
    AccumShotsFired();
    //return;    
}

function AccumShotsFired()
{
    ShotsFired++;
    //return;    
}
