class GagNodeActivationService extends AxonFSMService;

var int SuppressionLevel;
var MOHAGagNode GagNode;
var KynapseAIController Controller;

function StartFSMService()
{
    GotoState('CheckForGagStimulus');
    //return;    
}

state CheckForGagStimulus extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        owningBrainState.RegisterAxonActivationStimulus('GagAlert', 'GagAlert', OnGagAlert, SuppressionLevel);
        //return;        
    }

    function OnGagAlert()
    {
        local name GagNodeName;
        local StimulusListenerSubscription lis;
        local StimulusSenderSubscription send;

        owningBrainState.GetCallbackParamListener('Listener', lis);
        owningBrainState.GetCallbackParamSender('Sender', send);
        // End:0x142
        if(send.Owner.GetStimuliSenderParamName('GagAlert', 'GagNode', GagNodeName))
        {
            GagNode = MOHAGagNode(send.Owner.Owner);
            // End:0x142
            if((GagNode != none) && !GagNode.GetInUse())
            {
                // End:0x13F
                if((GagNode.GagFilterPawn == MOHAAIPawn(Controller.Pawn)) || (GagNode.GagFilterPawn == none) && (Controller.TeamIndex == int(GagNode.GagPawnTeam)) || int(GagNode.GagPawnTeam) == int(2))
                {
                    GotoState('TryToUse');
                }                
            }
        }
        //return;        
    }
    stop;    
}

state TryToUse extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        // End:0x4C
        if(MOHAAIController(Controller).CanPerformGag())
        {
            // End:0x4C
            if(GagNode.Mount(MOHAAIPawn(Controller.Pawn)))
            {
                Finish();
                return;
            }
        }
        GotoState('CheckForGagStimulus');
        //return;        
    }
    stop;    
}
