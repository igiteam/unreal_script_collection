class FleeGrenadeBrainState extends AxonControllerBrainState;

var Vector safePoint;
var Actor GrenadeActor;
var name CCStimulusType;
var export editinline AxonAnimService AnimService;
var export editinline AxonEnemyService EnemyService;
var export editinline AxonCoverService CoverService;
var export editinline AxonFleeService FleeService;
var export editinline MOHAGotoService GotoService;
var export editinline GrenadeActivationService ActivationService;
var export editinline BurstFireAxonScriptEvent BurstFireEvent;
var int iNumPostFleeBurstsFired;

function RegisterActivationEvents()
{
    ActivationService.Controller = Controller;
    ActivationService.FleeService = FleeService;
    ActivationService.SuppressionLevel = 17;
    ActivationService.Start(ActivationEventTripped);
    //return;    
}

function ActivationEventTripped()
{
    safePoint = ActivationService.safePoint;
    GrenadeActor = ActivationService.GrenadeActor;
    ActivateBrain();
    //return;    
}

function StartBrain()
{
    super(AxonBrainState).StartBrain();
    Controller.SendCCStimulus(string(CCStimulusType), GrenadeActor);
    SetSuppressionLevel(17);
    // End:0x54
    if(Controller.IsMountedInCover())
    {
        GotoState('PreHide');        
    }
    else
    {
        GotoState('Flee');
    }
    //return;    
}

function ResumeBrain(AxonBrainState usurperState)
{
    FinishBrain();
    //return;    
}

function StandardFinish()
{
    super(AxonBrainState).StandardFinish();
    Controller.FleeActor = none;
    Controller.bAimAtFocus = true;
    iNumPostFleeBurstsFired = 0;
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
        GotoState('Flee');
        //return;        
    }
    stop;    
}

state ChilloutPostGrenadeFlee extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        EnemyService.SubstateNoLongerSeeEnemy(NoLongerSeeEnemy, 2000,, 'bg');
        EnemyService.SubstateLostEnemy(NoLongerSeeEnemy,, 'bg');
        Controller.bAimAtFocus = true;
        MOHAAIPawn(GetBot()).UpdateFixedFireOIR(GetBotLocation());
        PushEventStack();
        AnimService.RegisterAnimationEvent('Aim', AimAnimDone, MOHAAIPawn(GetBot()).FFImpl);
        //return;        
    }

    function AimAnimDone()
    {
        PopEventStack();
        AnimService.RegisterAnimationEvent('Aim', None, MOHAAIPawn(GetBot()).FFImpl);
        BurstDone();
        //return;        
    }

    function BurstDone()
    {
        PopEventStack();
        // End:0x30
        if(iNumPostFleeBurstsFired++ >= Controller.iPostGrenadeFleeBursts)
        {
            GotoState('ReloadAfterChillout');
            return;
        }
        PushEventStack();
        BurstFireEvent.RegisterBurstSubstate(Controller, Controller.GetCoverFireBurst(), BurstDone, Controller.Focus);
        //return;        
    }

    function ChildEndState(name NextStateName)
    {
        PopEventStack();
        ClearEventMapEntry('bg');
        //return;        
    }

    function NoLongerSeeEnemy()
    {
        FinishBrain();
        //return;        
    }
    stop;    
}

state ReloadAfterChillout extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        Controller.NPCPreReload();
        MOHAAIPawn(GetBot()).UpdateFixedFireOIR(GetBotLocation());
        AnimService.SetFallbackCallback(ReloadFailed);
        AnimService.RegisterAnimationEvent('Reload', ReloadDone, MOHAAIPawn(GetBot()).FFImpl);
        Controller.SendCCStimulus("Reload");
        //return;        
    }

    function ReloadFailed()
    {
        RegisterAxonSubstateTimer(1.0000000, ReloadDone);
        //return;        
    }

    function ReloadDone()
    {
        FinishBrain();
        //return;        
    }
    stop;    
}

state Flee extends AxonBaseBookshelfState
{
    event ChildBeginState(name PreviousStateName)
    {
        CoverService.ClearCover(5000);
        Controller.bAimAtFocus = false;
        Controller.CoverPathObjectPenaltyMult = 0.0000000;
        MOHAPawn(Controller.Pawn).GetPawnBody().DesiredPosture = GotoService.GetDesiredPosture(3);
        GotoService.SubstateGotoOIR(Safe, safePoint,, 'Aim',, Controller.fSprintSpeed);
        //return;        
    }

    function Safe()
    {
        // End:0x4E
        if((Controller.Focus == none) || Controller.IsPointLocked(GetBot().Location, 50.0000000))
        {
            FinishBrain();            
        }
        else
        {
            GotoState('ChilloutPostGrenadeFlee');
        }
        //return;        
    }

    function ChildEndState(name NextStateName)
    {
        Controller.CoverPathObjectPenaltyMult = Controller.default.CoverPathObjectPenaltyMult;
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: AxonAnimService'Default__FleeGrenadeBrainState.AnimService0'
    begin object name=AnimService0 class=Class'AxonAnimService'
    end object
    AnimService=AnimService0
    // Reference: AxonEnemyService'Default__FleeGrenadeBrainState.EnemyService0'
    begin object name=EnemyService0 class=Class'AxonEnemyService'
    end object
    EnemyService=EnemyService0
    // Reference: MOHACoverService'Default__FleeGrenadeBrainState.CoverService0'
    begin object name=CoverService0 class=Class'MOHACoverService'
    end object
    CoverService=CoverService0
    // Reference: AxonFleeService'Default__FleeGrenadeBrainState.FleeService0'
    begin object name=FleeService0 class=Class'EAKynapse.AxonFleeService'
    end object
    FleeService=FleeService0
    // Reference: MOHAGotoService'Default__FleeGrenadeBrainState.GotoService0'
    begin object name=GotoService0 class=Class'MOHAGotoService'
    end object
    GotoService=GotoService0
    // Reference: GrenadeActivationService'Default__FleeGrenadeBrainState.ActivationService0'
    begin object name=ActivationService0 class=Class'GrenadeActivationService'
    end object
    ActivationService=ActivationService0
    // Reference: BurstFireAxonScriptEvent'Default__FleeGrenadeBrainState.BurstFireEvent0'
    begin object name=BurstFireEvent0 class=Class'BurstFireAxonScriptEvent'
    end object
    BurstFireEvent=BurstFireEvent0
    EventServices=/* Array type was not detected. */
    AxonScriptEvents=/* Array type was not detected. */
}