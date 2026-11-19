class DeathBrainState extends AxonControllerBrainState;

var export editinline AxonAnimService AnimService;
var() float DiedDestroyDelay;

function StartBrain()
{
    super(AxonBrainState).StartBrain();
    SetSuppressionLevel(19);
    GotoState('Dying');
    //return;    
}

function FinishBrain()
{
    //return;    
}

function SuspendBrain(AxonBrainState usurperState)
{
    super(AxonBrainState).SuspendBrain(usurperState);
    //return;    
}

function RegisterActivationEvents()
{
    RegisterAxonActivationNamedScriptEventListener('PawnDied', Die, 19);
    //return;    
}

function Die()
{
    ActivateBrain();
    //return;    
}

state Dying extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        AnimService.RegisterAnimationEvent('Death', None, MOHAAIPawn(Controller.Pawn).DeathImpl.GetOIRForDeath(), false, true);
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: AxonAnimService'Default__DeathBrainState.AnimService0'
    begin object name=AnimService0 class=Class'AxonAnimService'
    end object
    AnimService=AnimService0
    DiedDestroyDelay=5.0000000
    EventServices=/* Array type was not detected. */
}