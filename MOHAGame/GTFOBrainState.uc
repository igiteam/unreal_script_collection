class GTFOBrainState extends AxonControllerBrainState;

var Vector vDest;
var export editinline AxonPointService PointService;
var export editinline AxonCoverService CoverService;
var export editinline MOHAGotoService GotoService;
var export editinline GTFOActivationService ActivationService;
var export editinline AxonAnimService AnimService;
var int ForceActivatedGTFO;

function RegisterActivationEvents()
{
    ActivationService.PointService = PointService;
    ActivationService.SuppressionLevel = 14;
    ActivationService.Controller = Controller;
    ActivationService.Start(ActivationEventTripped);
    //return;    
}

function ActivationEventTripped()
{
    vDest = ActivationService.vDestPoint;
    ForceActivatedGTFO = ActivationService.ForceActivate;
    ActivateBrain();
    //return;    
}

function StartBrain()
{
    super(AxonBrainState).StartBrain();
    Controller.OnStartGTFO();
    SetSuppressionLevel(14);
    // End:0x55
    if((ForceActivatedGTFO == 1) && Controller.IsMountedInCover())
    {
        GotoState('PreHide');        
    }
    else
    {
        GotoState('RunToUnBlockingPoint');
    }
    //return;    
}

function StandardFinish()
{
    Controller.OnEndGTFO();
    super(AxonBrainState).StandardFinish();
    //return;    
}

function ResumeBrain(AxonBrainState usurperState)
{
    FinishBrain();
    //return;    
}

state PreHide extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        AnimService.SetActivityStartCallback(HideComplete);
        AnimService.RegisterAnimationEvent('Hide', None, Controller.GetCurrentCoverNode(),,, Controller.fCoverHideTransitionSpeedMultiplier * 1.5000000, 'Crouch_Center');
        //return;        
    }

    function HideComplete()
    {
        GotoState('RunToUnBlockingPoint');
        //return;        
    }
    stop;    
}

state RunToUnBlockingPoint extends AxonBaseBookshelfState
{
    event ChildBeginState(name PreviousStateName)
    {
        CoverService.ClearCover(25000);
        GotoService.SubstateGotoOIR(AtDest, vDest,, 'Aim',, Controller.fMoveSpeed);
        Controller.LockPoint(GetBotLocation(), 10.0000000, ActivationService.BlockedEnt);
        //return;        
    }

    function AtDest()
    {
        FinishBrain();
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: AxonPointService'Default__GTFOBrainState.PointService0'
    begin object name=PointService0 class=Class'EAKynapse.AxonPointService'
    end object
    PointService=PointService0
    // Reference: MOHACoverService'Default__GTFOBrainState.CoverService0'
    begin object name=CoverService0 class=Class'MOHACoverService'
    end object
    CoverService=CoverService0
    // Reference: MOHAGotoService'Default__GTFOBrainState.GotoService0'
    begin object name=GotoService0 class=Class'MOHAGotoService'
    end object
    GotoService=GotoService0
    // Reference: GTFOActivationService'Default__GTFOBrainState.ActivationService0'
    begin object name=ActivationService0 class=Class'GTFOActivationService'
    end object
    ActivationService=ActivationService0
    // Reference: AxonAnimService'Default__GTFOBrainState.AnimService0'
    begin object name=AnimService0 class=Class'AxonAnimService'
    end object
    AnimService=AnimService0
    EventServices=/* Array type was not detected. */
}