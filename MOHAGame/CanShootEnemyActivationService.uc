class CanShootEnemyActivationService extends AxonFSMService;

var int SuppressionLevel;
var MOHAScriptAIController Controller;
var export editinline AxonEnemyService EnemyService;
var export editinline AxonCoverService CoverService;
var Pawn Enemy;

function StartFSMService()
{
    GotoState('CheckForCover');
    //return;    
}

function OnCoverMounted()
{
    GotoState('CheckForCover');
    //return;    
}

state CheckForCover extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        CoverService.RegisterActivationOnCoverUnmounted(CoverUnmounted, SuppressionLevel, mInstanceID);
        //return;        
    }

    function CoverUnmounted()
    {
        GotoState('CheckForEnemy');
        //return;        
    }
    stop;    
}

state CheckForEnemy extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        CoverService.RegisterActivationOnCoverMounted(OnCoverMounted, SuppressionLevel, mInstanceID);
        EnemyService.RegisterAxonActivationHasEnemy(OnHasEnemy, SuppressionLevel, mInstanceID);
        //return;        
    }

    function OnHasEnemy()
    {
        Enemy = EnemyService.GetHasEnemyResult();
        // End:0x35
        if(Enemy != none)
        {
            GotoState('CheckCanShoot');            
        }
        else
        {
            GotoState('wait');
        }
        //return;        
    }
    stop;    
}

state wait extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        owningBrainState.RegisterAxonActivationTimer(0.5000000, TimedOut, SuppressionLevel, mInstanceID);
        //return;        
    }

    function TimedOut()
    {
        GotoState('CheckForCover');
        //return;        
    }
    stop;    
}

state CheckCanShoot extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        CoverService.RegisterActivationOnCoverMounted(OnCoverMounted, SuppressionLevel, mInstanceID);
        EnemyService.ActivationOnCanSeeEnemy(OnCanSeeEnemy, SuppressionLevel, mInstanceID);
        //return;        
    }

    function OnCanSeeEnemy()
    {
        // End:0x27
        if(Controller.IsInIdleLocomotion())
        {
            GotoState('WaitForCover');            
        }
        else
        {
            Finish();
        }
        //return;        
    }
    stop;    
}

state WaitForCover extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        CoverService.RegisterActivationOnCoverMounted(OnCoverMounted, SuppressionLevel, mInstanceID);
        EnemyService.RegisterAxonActivationLostEnemy(OnLostEnemy, SuppressionLevel, mInstanceID);
        owningBrainState.RegisterAxonActivationTimer(2.0000000, TimedOut, SuppressionLevel, mInstanceID);
        owningBrainState.OwningBSS.PushNamedScriptEventParamFloat('FindCoverByTime', 'FindTime', 2.0000000);
        owningBrainState.TriggerAxonNamedScriptEvent('FindCoverByTime');
        //return;        
    }

    function OnLostEnemy()
    {
        GotoState('CheckForEnemy');
        //return;        
    }

    function TimedOut()
    {
        GotoState('CheckCanShootPostFindCover');
        //return;        
    }
    stop;    
}

state CheckCanShootPostFindCover extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        CoverService.RegisterActivationOnCoverMounted(OnCoverMounted, SuppressionLevel, mInstanceID);
        EnemyService.ActivationOnCanSeeEnemy(OnCanSeeEnemy, SuppressionLevel, mInstanceID);
        //return;        
    }

    function OnCanSeeEnemy()
    {
        Finish();
        //return;        
    }
    stop;    
}
