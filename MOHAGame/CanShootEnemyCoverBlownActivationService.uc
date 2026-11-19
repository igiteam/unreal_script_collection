class CanShootEnemyCoverBlownActivationService extends AxonFSMService;

var int SuppressionLevel;
var MOHAScriptAIController Controller;
var export editinline AxonEnemyService EnemyService;
var export editinline AxonCoverService CoverService;
var Pawn Enemy;

function StartFSMService()
{
    GotoState('CheckCoverMounted');
    //return;    
}

function OnCoverUnMounted()
{
    GotoState('CheckCoverMounted');
    //return;    
}

function PushCoverBlownConstraints()
{
    CoverService.PushBasicAggressorCoverBlownConstraints(Controller, mInstanceID);
    //return;    
}

function ForceCoverBlown()
{
    //return;    
}

state CheckCoverMounted extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        owningBrainState.RegisterAxonActivationNamedScriptEventListener('ForceCoverBlownCombat', ForceCoverBlown, SuppressionLevel);
        CoverService.RegisterActivationOnCoverMounted(OnCoverMounted, SuppressionLevel, mInstanceID);
        //return;        
    }

    function OnCoverMounted()
    {
        GotoState('CheckCoverBlown');
        //return;        
    }

    function ForceCoverBlown()
    {
        GotoState('CheckForEnemyOutOfCover');
        //return;        
    }
    stop;    
}

state CheckCoverBlown extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        CoverService.RegisterAxonActivationCoverBlown(OnCoverBlown, SuppressionLevel,, mInstanceID);
        CoverService.RegisterActivationOnCoverUnmounted(OnCoverUnMounted, SuppressionLevel, mInstanceID);
        PushCoverBlownConstraints();
        //return;        
    }

    function OnCoverBlown()
    {
        GotoState('CheckForEnemy');
        //return;        
    }
    stop;    
}

state wait extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        owningBrainState.RegisterAxonActivationTimer(1.0000000, TimerDone, SuppressionLevel, mInstanceID);
        //return;        
    }

    function TimerDone()
    {
        GotoState('CheckCoverMounted');
        //return;        
    }
    stop;    
}

state CheckForEnemy extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        CoverService.RegisterActivationOnCoverUnmounted(OnCoverUnMounted, SuppressionLevel, mInstanceID);
        EnemyService.RegisterAxonActivationHasEnemy(OnHasEnemy, SuppressionLevel, mInstanceID);
        //return;        
    }

    function OnHasEnemy()
    {
        Enemy = EnemyService.GetHasEnemyResult();
        // End:0x2D
        if(Enemy != none)
        {
            Finish();            
        }
        else
        {
            GotoState('wait');
        }
        //return;        
    }
    stop;    
}

state CheckForEnemyOutOfCover extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        EnemyService.RegisterAxonActivationHasEnemy(OnHasEnemy, SuppressionLevel, mInstanceID);
        //return;        
    }

    function OnHasEnemy()
    {
        Enemy = EnemyService.GetHasEnemyResult();
        // End:0x2D
        if(Enemy != none)
        {
            Finish();            
        }
        else
        {
            GotoState('CheckCoverMounted');
        }
        //return;        
    }
    stop;    
}
