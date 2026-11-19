class NoCoverNoEnemyActivationService extends AxonFSMService;

var export editinline AxonEnemyService EnemyService;
var export editinline AxonCoverService CoverService;
var int SuppressionLevel;

function StartFSMService()
{
    GotoState('WaitForCoverUnMounted');
    //return;    
}

state WaitForCoverUnMounted extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        CoverService.RegisterActivationOnCoverUnmounted(OnCoverUnMounted, SuppressionLevel, mInstanceID);
        //return;        
    }

    function OnCoverUnMounted()
    {
        GotoState('WaitForNoEnemy');
        //return;        
    }
    stop;    
}

state WaitForNoEnemy extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        CoverService.RegisterActivationOnCoverMounted(OnCoverMounted, SuppressionLevel, mInstanceID);
        EnemyService.RegisterAxonActivationLostEnemy(OnNoEnemy, SuppressionLevel, mInstanceID);
        EnemyService.RegisterAxonActivationNoLongerSeeEnemy(OnNoEnemy, SuppressionLevel, 2500, mInstanceID);
        //return;        
    }

    function OnCoverMounted()
    {
        GotoState('WaitForCoverUnMounted');
        //return;        
    }

    function OnNoEnemy()
    {
        Finish();
        //return;        
    }
    stop;    
}
