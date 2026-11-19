class MoveToGagNodeBrainState extends AxonControllerBrainState;

var MOHAGagNode GagNode;
var export editinline MOHAGotoService GotoService;
var export editinline AxonAnimService AnimService;
var export editinline GagNodeActivationService ActivationService;

function RegisterActivationEvents()
{
    ActivationService.Controller = Controller;
    ActivationService.SuppressionLevel = 18;
    ActivationService.Start(ActivationEventTripped, 'MoveToGagNode');
    //return;    
}

function ActivationEventTripped()
{
    GagNode = ActivationService.GagNode;
    ActivateBrain();
    //return;    
}

function StartBrain()
{
    super(AxonBrainState).StartBrain();
    SetSuppressionLevel(18);
    GotoState('StartMoveToGagNode');
    //return;    
}

function FinishBrain()
{
    super(AxonBrainState).FinishBrain();
    //return;    
}

state StartMoveToGagNode extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        PushEventStack();
        GotoService.ClearPathConstraints();
        GotoState('RunToGagNode');
        //return;        
    }

    function ArrivedAtGagNode()
    {
        // End:0x2C
        if(GotoService.GetMoveFailed())
        {
            Controller.ClearGagNode();            
        }
        else
        {
            // End:0x4F
            if(GagNode != none)
            {
                Controller.UseGagNode(GagNode);
            }
        }
        FinishBrain();
        //return;        
    }
    stop;    
}

state RunToGagNode extends StartMoveToGagNode
{
    function ChildBeginState(name PreviousStateName)
    {
        MOHAPawn(Controller.Pawn).DesiredPosture = GotoService.GetRandDesiredPosture();
        GotoService.SubstateGotoOIR(ArrivedAtGagNode,, GagNode,,, Controller.fMoveSpeed);
        super.ChildBeginState(PreviousStateName);
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: MOHAGotoService'Default__MoveToGagNodeBrainState.GotoService0'
    begin object name=GotoService0 class=Class'MOHAGotoService'
    end object
    GotoService=GotoService0
    // Reference: AxonAnimService'Default__MoveToGagNodeBrainState.AnimService0'
    begin object name=AnimService0 class=Class'AxonAnimService'
    end object
    AnimService=AnimService0
    // Reference: GagNodeActivationService'Default__MoveToGagNodeBrainState.ActivationService0'
    begin object name=ActivationService0 class=Class'GagNodeActivationService'
    end object
    ActivationService=ActivationService0
    EventServices=/* Array type was not detected. */
}