class HasEnemyAndMountedGunActivationService extends AxonFSMService;

var int SuppressionLevel;
var export editinline AxonEnemyService EnemyService;
var export editinline OnMMGMountedAxonScriptEvent OnMMGEvent;
var MOHAScriptAIController Controller;

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
        OnMMGEvent.RegActivation(Controller, HasMountedGun, SuppressionLevel);
        //return;        
    }

    function HasMountedGun()
    {
        Finish();
        //return;        
    }

    function OnLostEnemy()
    {
        GotoState('CheckForEnemy');
        //return;        
    }
    stop;    
}
