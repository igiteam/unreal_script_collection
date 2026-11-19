class OutOfCoverPerformanceActivationService extends AxonFSMService;

var MOHAScriptAIController Controller;
var int SuppressionLevel;
var export editinline AxonEnemyService EnemyService;
var export editinline AxonCoverService CoverService;
var Pawn Shooter;

function StartFSMService()
{
    GotoState('CheckCoverUnmounted');
    //return;    
}

function CheckSniperFireStimulus(delegate<AxonDelegate> callback)
{
    local name sniperStimulusID;

    // End:0x2B
    if(Controller.GetTeamIndex() == 0)
    {
        sniperStimulusID = 'AxisSniperFire';        
    }
    else
    {
        sniperStimulusID = 'AlliedSniperFire';
    }
    owningBrainState.RegisterAxonActivationStimulus('SniperFire', sniperStimulusID, callback, SuppressionLevel);
    //return;    
}

function StartFromSniperEnemy(bool checkFocus)
{
    local name shooterName;
    local StimulusSenderSubscription send;

    owningBrainState.GetCallbackParamSender('Sender', send);
    // End:0xC5
    if(send.Owner.GetStimuliSenderParamName('SniperFire', 'Shooter', shooterName))
    {
        Shooter = Pawn(send.Owner.GetObjectFromName(shooterName));
        // End:0xC5
        if((Shooter != none) && Shooter.Controller != none)
        {
            // End:0xC5
            if(!checkFocus || Shooter != Controller.Focus)
            {
                Finish();
            }
        }
    }
    //return;    
}

function OnCoverMounted()
{
    GotoState('CheckCoverUnmounted');
    //return;    
}

state CheckCoverUnmounted extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        CoverService.RegisterActivationOnCoverUnmounted(OnCoverUnMounted, SuppressionLevel, Name);
        //return;        
    }

    function OnCoverUnMounted()
    {
        GotoState('CheckForSniperFireOrEnemy');
        //return;        
    }
    stop;    
}

state CheckForSniperFireOrEnemy extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        CoverService.RegisterActivationOnCoverMounted(OnCoverMounted, SuppressionLevel, Name);
        EnemyService.RegisterAxonActivationHasEnemy(OnHasEnemy, SuppressionLevel, Name);
        CheckSniperFireStimulus(HasSniperEnemy);
        //return;        
    }

    function OnHasEnemy()
    {
        GotoState('CheckForSniperFire');
        //return;        
    }

    function HasSniperEnemy()
    {
        StartFromSniperEnemy(false);
        //return;        
    }
    stop;    
}

state CheckForSniperFire extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        CoverService.RegisterActivationOnCoverMounted(OnCoverMounted, SuppressionLevel, Name);
        EnemyService.RegisterAxonActivationLostEnemy(OnLostEnemy, SuppressionLevel, Name);
        CheckSniperFireStimulus(HasSniperEnemy);
        RegisterTimer();
        //return;        
    }

    function RegisterTimer()
    {
        owningBrainState.RegisterAxonActivationTimer(0.1000000, TimerDone, SuppressionLevel);
        //return;        
    }

    function TimerDone()
    {
        GotoState('CheckForSniperFirePostTimer');
        //return;        
    }

    function OnLostEnemy()
    {
        GotoState('CheckForSniperFireOrEnemy');
        //return;        
    }

    function HasSniperEnemy()
    {
        StartFromSniperEnemy(false);
        //return;        
    }
    stop;    
}

state CheckForSniperFirePostTimer extends CheckForSniperFire
{
    function HasSniperEnemy()
    {
        StartFromSniperEnemy(true);
        //return;        
    }
    stop;    
}
