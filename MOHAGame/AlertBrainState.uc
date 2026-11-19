class AlertBrainState extends AxonControllerBrainState;

var Pawn Shooter;
var export editinline AxonCoverService CoverService;
var export editinline MOHAGotoService GotoService;
var export editinline AxonAnimService AnimService;
var KynapseCoverNode newCoverNode;

function RegisterActivationEvents()
{
    RegisterAxonActivationStimulus('Gunshot', 'Gunshot', ActivationEventTripped, 3);
    //return;    
}

function ActivationEventTripped()
{
    local name shooterName;
    local StimulusListenerSubscription lis;
    local StimulusSenderSubscription send;

    GetCallbackParamListener('Listener', lis);
    GetCallbackParamSender('Sender', send);
    // End:0xAF
    if(send.Owner.GetStimuliSenderParamName('Gunshot', 'Shooter', shooterName))
    {
        Shooter = Pawn(send.Owner.GetObjectFromName(shooterName));
        // End:0xAF
        if((Shooter != none) && Shooter.Controller != none)
        {
            ActivateBrain();
        }
    }
    //return;    
}

function StartBrain()
{
    super(AxonBrainState).StartBrain();
    SetSuppressionLevel(3);
    GotoState('SearchForThreat');
    //return;    
}

function ResumeBrain(AxonBrainState usurperState)
{
    FinishBrain();
    //return;    
}

state SearchForThreat extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        CoverService.ClearCoverConstraints();
        CoverService.PushCanShootOverrideTarget(Shooter.Controller);
        CoverService.PushCanShootCoverConstraint();
        CoverService.PushWithinAffordanceCoverConstraint();
        CoverService.SubstateFindCover(30, 250, Controller.Pawn.Location, FoundCover);
        //return;        
    }

    function FoundCover()
    {
        CoverService.OnFindCoverCallback();
        // End:0x39
        if(CoverService.GetNumNodesFound() <= 0)
        {
            FinishBrain();            
        }
        else
        {
            newCoverNode = CoverService.GetCoverNode(0);
            GotoState('TryClaimCover');
        }
        //return;        
    }
    stop;    
}

state TryClaimCover extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        CoverService.ClaimCover(newCoverNode.GetId(), ClaimResult);
        //return;        
    }

    function ClaimResult()
    {
        // End:0x29
        if(!CoverService.GetClaimResult())
        {
            GotoState('SearchForThreat');            
        }
        else
        {
            GotoState('MoveToThreat');
        }
        //return;        
    }
    stop;    
}

state MoveToThreat extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        MOHAPawn(Controller.Pawn).DesiredPosture = GotoService.GetRandDesiredPosture();
        GotoService.SubstateGotoOIR(ArrivedAtCover,, newCoverNode, 'Hide',, 500.0000000);
        //return;        
    }

    function ArrivedAtCover()
    {
        // End:0x3E
        if(GotoService.GetMoveFailed())
        {
            CoverService.ClearCover(3000);
            GotoState('SearchForThreat');
            return;
        }
        FinishBrain();
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: MOHACoverService'Default__AlertBrainState.CoverService0'
    begin object name=CoverService0 class=Class'MOHACoverService'
    end object
    CoverService=CoverService0
    // Reference: MOHAGotoService'Default__AlertBrainState.GotoService0'
    begin object name=GotoService0 class=Class'MOHAGotoService'
    end object
    GotoService=GotoService0
    // Reference: AxonAnimService'Default__AlertBrainState.AnimService0'
    begin object name=AnimService0 class=Class'AxonAnimService'
    end object
    AnimService=AnimService0
    EventServices=/* Array type was not detected. */
}