class HuntEnemyActivationService extends AxonFSMService;

var int SuppressionLevel;
var float EnemySeeTimeoutMS;
var KynapseAIController Controller;
var export editinline AxonEnemyService EnemyService;
var Vector LastKnownPosition;

function StartFSMService()
{
    GotoState('CheckLostEnemy');
    //return;    
}

state CheckLostEnemy extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        EnemyService.RegisterAxonActivationLostPlayerEnemy(OnLostEnemy, SuppressionLevel, mInstanceID);
        //return;        
    }

    function OnLostEnemy()
    {
        GotoState('FindLastKnownPosition');
        //return;        
    }
    stop;    
}

state FindLastKnownPosition extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        EnemyService.GetActivationLKP(OnGetLKP, SuppressionLevel);
        //return;        
    }

    function OnGetLKP()
    {
        LastKnownPosition = EnemyService.GetGetLKPResult();
        Finish();
        //return;        
    }
    stop;    
}

defaultproperties
{
    EnemySeeTimeoutMS=5000.0000000
}