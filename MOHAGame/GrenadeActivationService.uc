class GrenadeActivationService extends AxonFSMService;

var int SuppressionLevel;
var float fleeRadius;
var Vector dangerPoint;
var Vector safePoint;
var Actor GrenadeActor;
var MOHAScriptAIController Controller;
var export editinline AxonFleeService FleeService;

function StartFSMService()
{
    GotoState('CheckForGrenade');
    //return;    
}

state CheckForGrenade extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        owningBrainState.RegisterAxonActivationStimulus('Grenade', 'Grenade', GrenadeNearby, SuppressionLevel);
        //return;        
    }

    function GrenadeNearby()
    {
        local Rotator Rot;
        local StimulusListenerSubscription lis;
        local StimulusSenderSubscription send;
        local name CCStimulusType;

        owningBrainState.GetCallbackParamListener('Listener', lis);
        owningBrainState.GetCallbackParamSender('Sender', send);
        fleeRadius = StimColSphere(lis.Listener.Collision).Radius + send.Sender.Radius;
        GrenadeActor = send.Owner.GetSpatialActor();
        send.Owner.GetSenderPosition(send, dangerPoint, Rot);
        // End:0x113
        if(!send.Owner.GetStimuliSenderParamName('Grenade', 'cc_stim_type', CCStimulusType))
        {
            CCStimulusType = 'Grenade';
        }
        FleeGrenadeBrainState(owningBrainState).CCStimulusType = CCStimulusType;
        GotoState('CheckNotSafe');
        //return;        
    }
    stop;    
}

state CheckNotSafe extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        FleeService.ActivationFlee(dangerPoint, fleeRadius, Safe, DestinationFound, SuppressionLevel);
        //return;        
    }

    function Safe()
    {
        GotoState('wait');
        //return;        
    }

    function DestinationFound()
    {
        safePoint = FleeService.GetDestination();
        // End:0x46
        if(Controller.IsPointLocked(safePoint, 100.0000000))
        {
            GotoState('wait');
            return;
        }
        AxonControllerBrainState(owningBrainState).Controller.FleeActor = GrenadeActor;
        Finish();
        //return;        
    }
    stop;    
}

state wait extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        owningBrainState.RegisterAxonActivationTimer(0.5000000, TimedOut, SuppressionLevel, 'GrenadeActivationTimer');
        //return;        
    }

    function TimedOut()
    {
        GotoState('CheckForGrenade');
        //return;        
    }
    stop;    
}
