class InCoverHasEnemyActivationService extends AxonFSMService;

var int SuppressionLevel;
var KynapseAIController Controller;
var export editinline AxonEnemyService EnemyService;
var export editinline AxonCoverService CoverService;
var export editinline KynapseCoverNode CoverNode;
var float fAtCoverDist;

function StartFSMService()
{
    GotoState('CheckForEnemy');
    //return;    
}

state CheckForEnemy extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        EnemyService.RegisterAxonActivationHasEnemy(OnHasEnemy, SuppressionLevel, mInstanceID);
        //return;        
    }

    function OnHasEnemy()
    {
        GotoState('CheckHasCover');
        //return;        
    }
    stop;    
}

state CheckHasCover extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        CoverService.RegisterActivationOnCoverMounted(OnCoverMounted, SuppressionLevel, mInstanceID);
        //return;        
    }

    function OnCoverMounted()
    {
        Finish();
        //return;        
    }
    stop;    
}

state wait extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        owningBrainState.RegisterAxonActivationTimer(0.2500000, TimerDone, SuppressionLevel, 'InCoverHasEnemy');
        //return;        
    }

    function TimerDone()
    {
        GotoState('CheckForEnemy');
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: KynapseCoverNode'Default__InCoverHasEnemyActivationService.CoverNode0'
    begin object name=CoverNode0 class=Class'EAKynapse.KynapseCoverNode'
    end object
    CoverNode=CoverNode0
    fAtCoverDist=100.0000000
}