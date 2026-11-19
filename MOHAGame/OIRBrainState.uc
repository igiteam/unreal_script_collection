class OIRBrainState extends AxonControllerBrainState;

var export editinline Object OIROwningObject;
var export editinline SpawnInOIRImpl SImpl;
var export editinline AxonAnimService AnimService;
var int iSuppressionLevel;
var float fDepartureDelay;

function ResumeBrain(AxonBrainState usurperState)
{
    DestroyTransplantBrain();
    //return;    
}

function DestroyTransplantBrain()
{
    MOHAOIRPawn(GetBot()).bNoRagdoll = false;
    super(AxonBrainState).DestroyTransplantBrain();
    //return;    
}

function StartBrain()
{
    super(AxonBrainState).StartBrain();
    MOHAOIRPawn(GetBot()).bNoRagdoll = true;
    SetSuppressionLevel(iSuppressionLevel);
    GotoState('Working');
    //return;    
}

function DelayDeparture()
{
    RegisterAxonSubstateTimer(FRand() * fDepartureDelay, LeaveOIR);
    //return;    
}

function LeaveOIR()
{
    SpawnInOIRInterface(OIROwningObject).NPCLeavingOIR(Controller.Pawn);
    DestroyTransplantBrain();
    MOHAOIRPawn(Controller.Pawn).ResumeAffordance();
    //return;    
}

state Working extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        AnimService.RegisterAnimationEvent(SpawnInOIRInterface(OIROwningObject).GetInitialActivity(), None, SImpl);
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: AxonAnimService'Default__OIRBrainState.AnimService0'
    begin object name=AnimService0 class=Class'AxonAnimService'
    end object
    AnimService=AnimService0
    iSuppressionLevel=18
    fDepartureDelay=2.0000000
    EventServices=/* Array type was not detected. */
}