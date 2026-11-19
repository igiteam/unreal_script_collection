class NoEnemyAndNoMountedGunActivationService extends AxonFSMService;

var int SuppressionLevel;
var export editinline AxonEnemyService EnemyService;
var export editinline OnMMGUnMountedAxonScriptEvent OnMMGEvent;
var export editinline OnMMGMountedAxonScriptEvent OnMMGMountedEvent;
var MOHAMountedGun MountedGun;
var name StimulusTemplate;
var bool bShortCircuit;
var MOHAScriptAIController Controller;

function StartFSMService()
{
    bShortCircuit = false;
    GotoState('wait');
    //return;    
}

function OnHasEnemy()
{
    GotoState('CheckLostEnemy');
    //return;    
}

function HasMountedGun()
{
    bShortCircuit = true;
    MountedGun = MOHAMountedGun(Controller.Pawn);
    Finish();
    //return;    
}

state CheckLostEnemy extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        EnemyService.RegisterAxonActivationLostEnemy(OnLostEnemy, SuppressionLevel, mInstanceID);
        //return;        
    }

    function OnLostEnemy()
    {
        GotoState('CheckNoMountedGun');
        //return;        
    }
    stop;    
}

state CheckNoMountedGun extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        EnemyService.RegisterAxonActivationHasEnemy(OnHasEnemy, SuppressionLevel, mInstanceID);
        OnMMGEvent.RegActivation(Controller, NoMountedGun, SuppressionLevel);
        OnMMGMountedEvent.RegActivation(Controller, HasMountedGun, SuppressionLevel);
        //return;        
    }

    function NoMountedGun()
    {
        GotoState('CheckForMountedGun');
        //return;        
    }
    stop;    
}

state CheckForMountedGun extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        EnemyService.RegisterAxonActivationHasEnemy(OnHasEnemy, SuppressionLevel, mInstanceID);
        owningBrainState.RegisterAxonActivationStimulus(mInstanceID, StimulusTemplate, FoundMountedGun, SuppressionLevel);
        OnMMGMountedEvent.RegActivation(Controller, HasMountedGun, SuppressionLevel);
        //return;        
    }

    function FoundMountedGun()
    {
        local name MGName;
        local StimulusListenerSubscription lis;
        local StimulusSenderSubscription send;
        local int Dummy;

        owningBrainState.GetCallbackParamListener('Listener', lis);
        owningBrainState.GetCallbackParamSender('Sender', send);
        // End:0x81
        if((Controller.TeamIndex == 1) && send.Owner.GetStimuliSenderParamInt(StimulusTemplate, 'DeathPenalty', Dummy))
        {
            return;
        }
        // End:0x12F
        if(send.Owner.GetStimuliSenderParamName(StimulusTemplate, 'gun', MGName))
        {
            MountedGun = MOHAMountedGun(send.Owner.Owner);
            // End:0x12F
            if((MountedGun != none) && !MountedGun.GetIsClaimed())
            {
                // End:0x12F
                if(Controller.IsWithinLeash(true, MountedGun.GetAttachLocation(), true))
                {
                    GotoState('TryToClaim');
                    return;
                }
            }
        }
        GotoState('wait');
        //return;        
    }
    stop;    
}

state wait extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        MountedGun = none;
        owningBrainState.RegisterAxonActivationTimer(2.0000000, TimerDone, SuppressionLevel, mInstanceID);
        //return;        
    }

    function TimerDone()
    {
        GotoState('CheckLostEnemy');
        //return;        
    }
    stop;    
}

state TryToClaim extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        local bool Result, bMGAlreadyClaimed;

        bMGAlreadyClaimed = MountedGun.GetIsClaimed();
        // End:0x80
        if(!bMGAlreadyClaimed || MountedGun.IsClaimedBy(Controller))
        {
            Result = MountedGun.Claim(MOHAPawn(Controller.Pawn));
            // End:0x80
            if(Result)
            {
                Finish();
                return;
            }
        }
        GotoState('wait');
        //return;        
    }
    stop;    
}
