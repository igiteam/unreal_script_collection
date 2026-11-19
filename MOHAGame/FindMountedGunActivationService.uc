class FindMountedGunActivationService extends AxonFSMService;

var int SuppressionLevel;
var export editinline AxonEnemyService EnemyService;
var export editinline AxonCoverService CoverService;
var export editinline OnMMGUnMountedAxonScriptEvent OnMMGEvent;
var MOHAMountedGun MountedGun;
var name StimulusTemplate;
var MOHAScriptAIController Controller;

function StartFSMService()
{
    GotoState('CheckHasEnemy');
    //return;    
}

function OnLostEnemy()
{
    GotoState('CheckHasEnemy');
    //return;    
}

function Abort()
{
    // End:0x0D
    if(MountedGun == none)
    {
        return;
    }
    // End:0x53
    if(MountedGun.GetIsClaimed() && MountedGun.IsClaimedBy(Controller))
    {
        MountedGun.ClearClaim();
    }
    //return;    
}

state CheckHasEnemy extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        EnemyService.RegisterAxonActivationHasEnemy(OnHasEnemy, SuppressionLevel, mInstanceID);
        //return;        
    }

    function OnHasEnemy()
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
        EnemyService.RegisterAxonActivationLostEnemy(OnLostEnemy, SuppressionLevel, mInstanceID);
        OnMMGEvent.RegActivation(Controller, NoMountedGun, SuppressionLevel);
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
        EnemyService.RegisterAxonActivationLostEnemy(OnLostEnemy, SuppressionLevel, mInstanceID);
        owningBrainState.RegisterAxonActivationStimulus(mInstanceID, StimulusTemplate, FoundMountedGun, SuppressionLevel);
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
        // End:0x178
        if(send.Owner.GetStimuliSenderParamName(StimulusTemplate, 'gun', MGName))
        {
            MountedGun = MOHAMountedGun(send.Owner.Owner);
            // End:0x178
            if(((MountedGun != none) && !MountedGun.GetIsClaimed()) && !MountedGun.GetIsMounted())
            {
                // End:0x178
                if(Controller.IsWithinLeash(true, MountedGun.GetAttachLocation()) && !Controller.IsPointLocked(MountedGun.GetAttachLocation(), 50.0000000))
                {
                    GotoState('TryToClaim');
                    return;
                }
            }
        }
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
        GotoState('CheckHasEnemy');
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
        // End:0x88
        if(!bMGAlreadyClaimed || MountedGun.IsClaimedBy(Controller))
        {
            Result = MountedGun.Claim(MOHAPawn(Controller.Pawn));
            // End:0x88
            if(Result)
            {
                GotoState('ValidateSafe');
                return;
            }
        }
        GotoState('wait');
        //return;        
    }
    stop;    
}

state ValidateSafe extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        CoverService.RegisterAxonActivationCoverBlown(BadMMG, SuppressionLevel,, mInstanceID);
        CoverService.PushFlankingAggressorCoverBlownContraints(Controller, Controller.fMMGHalfAngleFiringArcDeg, false, mInstanceID);
        CoverService.PushShootAtLeastOneCoverConstraint("CoverBlown", mInstanceID);
        CoverService.IsCoverValidActivation(CoverValidResult, MountedGun.GetCoverNode(), SuppressionLevel, mInstanceID);
        //return;        
    }

    function CoverValidResult()
    {
        // End:0x1E
        if(CoverService.GetIsCoverValidResult())
        {
            Finish();
            return;
        }
        MountedGun.ClearClaim();
        GotoState('CheckForMountedGun');
        //return;        
    }
    stop;    
}
