class ScriptPlayGagBrainState extends AxonControllerBrainState;

var export editinline AxonAnimService AnimService;
var name GagActivityName;
var MOHAGagNode GagNode;
var bool bLastActivity;

function RegisterActivationEvents()
{
    RegisterAxonActivationNamedScriptEventListener('scriptplaygag', ActivationEventTripped, 18);
    //return;    
}

function ActivationEventTripped()
{
    // End:0x21
    if(GetCallbackParamName('GagActivityName', GagActivityName))
    {
        ActivateBrain();
    }
    //return;    
}

function StartBrain()
{
    super(AxonBrainState).StartBrain();
    GagNode = Controller.GetGagNode();
    SetSuppressionLevel(18);
    GotoState('StartGagActivity');
    //return;    
}

function ActivityDone(bool bSuccess)
{
    // End:0x51
    if(GagNode != none)
    {
        // End:0x2A
        if(GagNode.bLastActivity)
        {
            FinishBrain();            
        }
        else
        {
            GotoState('wait');
        }
        GagNode.GagActivityDone(bSuccess);
    }
    //return;    
}

function OnPlayerShot()
{
    ActivityDone(false);
    FinishBrain();
    //return;    
}

function StandardFinish()
{
    super(AxonBrainState).StandardFinish();
    Controller.ClearGagNode();
    //return;    
}

state StartGagActivity extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        RegisterAxonNamedScriptEventListener('scriptabortplaygag', GagActivityFailed);
        RegisterAxonNamedScriptEventListener('scriptplaygag', NewGagActivity);
        // End:0x82
        if((GagNode != none) && !GagNode.bIgnorePlayerShoot)
        {
            RegisterAxonSubstateStimulus('PlayerShoot', 'PlayerShoot', OnPlayerShot);
        }
        PushEventStack();
        GotoState('PlayGagActivity');
        //return;        
    }

    function GagActivityFinished()
    {
        ActivityDone(true);
        //return;        
    }

    function GagActivityFailed()
    {
        ActivityDone(false);
        //return;        
    }

    function NewGagActivity()
    {
        // End:0x25
        if(GetCallbackParamName('GagActivityName', GagActivityName))
        {
            GotoState('PlayGagActivity',, true);
        }
        //return;        
    }
    stop;    
}

state PlayGagActivity extends StartGagActivity
{
    function ChildBeginState(name PreviousStateName)
    {
        AnimService.SetFallbackCallback(GagActivityFailed);
        AnimService.RegisterAnimationEvent(GagActivityName, GagActivityFinished, Controller.GetGagNode(), true);
        //return;        
    }
    stop;    
}

state wait extends StartGagActivity
{
    function ChildBeginState(name PreviousStateName)
    {
        RegisterAxonSubstateTimer(1.0000000, TimedOut);
        //return;        
    }

    function TimedOut()
    {
        FinishBrain();
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: AxonAnimService'Default__ScriptPlayGagBrainState.AxonAnimService0'
    begin object name=AxonAnimService0 class=Class'AxonAnimService'
    end object
    AnimService=AxonAnimService0
    EventServices=/* Array type was not detected. */
}