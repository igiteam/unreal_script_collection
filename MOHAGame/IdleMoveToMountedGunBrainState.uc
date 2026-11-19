class IdleMoveToMountedGunBrainState extends AxonControllerBrainState;

var MOHAMountedGun MountedGun;
var export editinline MOHAGotoService GotoService;
var export editinline AxonAnimService AnimService;
var export editinline AxonEnemyService EnemyService;
var export editinline NoEnemyAndNoMountedGunActivationService ActivationService;
var export editinline OnMMGUnMountedAxonScriptEvent OnMMGEvent;
var export editinline OnMMGMountedAxonScriptEvent OnMMGMountedEvent;
var bool bShortCircuit;

function RegisterActivationEvents()
{
    ActivationService.Controller = Controller;
    ActivationService.EnemyService = EnemyService;
    ActivationService.OnMMGEvent = OnMMGEvent;
    ActivationService.OnMMGMountedEvent = OnMMGMountedEvent;
    ActivationService.SuppressionLevel = 2;
    ActivationService.StimulusTemplate = 'IdleMG42';
    ActivationService.Start(ActivationEventTripped, 'IdleMoveToMountedGunActiviation');
    //return;    
}

function ActivationEventTripped()
{
    bShortCircuit = ActivationService.bShortCircuit;
    MountedGun = ActivationService.MountedGun;
    ActivateBrain();
    //return;    
}

function StartBrain()
{
    super(AxonBrainState).StartBrain();
    SetSuppressionLevel(2);
    // End:0x28
    if(bShortCircuit)
    {
        GotoState('SinkState');        
    }
    else
    {
        // End:0x4F
        if(Controller.IsMountedInCover())
        {
            GotoState('PreHide');            
        }
        else
        {
            GotoState('StartMoveToMountedGun');
        }
    }
    //return;    
}

function FinishBrain()
{
    MountedGun.ClearClaim();
    super(AxonBrainState).FinishBrain();
    //return;    
}

function StandardFinish()
{
    Controller.fMaxEngageDist = Controller.Class.default.fMaxEngageDist;
    Controller.fMaxEngagePenaltyDist = Controller.Class.default.fMaxEngagePenaltyDist;
    super(AxonBrainState).StandardFinish();
    //return;    
}

function ResumeBrain(AxonBrainState usurperState)
{
    FinishBrain();
    //return;    
}

function PlayerOverrideClaim()
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
        GotoState('StartMoveToMountedGun');
        //return;        
    }
    stop;    
}

state StartMoveToMountedGun extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        RegisterAxonNamedScriptEventListener('PlayerOverrideClaim', PlayerOverrideClaim, 'Background');
        GotoState('RunToMountedGun');
        //return;        
    }
    stop;    
}

state RunToMountedGun extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        MOHAPawn(Controller.Pawn).DesiredPosture = GotoService.GetRandDesiredPosture();
        GotoService.SubstateGotoOIR(ArrivedAtMountedGun,, MountedGun, 'Aim',, Controller.fMoveSpeed);
        //return;        
    }

    function ArrivedAtMountedGun()
    {
        // End:0x4E
        if((GotoService.GetMoveFailed() || MountedGun == none) || !MountedGun.IsClaimedBy(Controller))
        {
            FinishBrain();
            return;
        }
        GotoState('Mount');
        //return;        
    }
    stop;    
}

state Mount extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        AnimService.RegisterAnimationEvent('Aim', AnimDone, MountedGun);
        //return;        
    }

    function AnimDone()
    {
        GotoState('SinkState');
        //return;        
    }
    stop;    
}

state SinkState extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        Controller.fMaxEngageDist = MountedGun.fMaxEngagementDistance;
        Controller.fMaxEngagePenaltyDist = MountedGun.fMaxEngagementDistance;
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: MOHAGotoService'Default__IdleMoveToMountedGunBrainState.GotoService0'
    begin object name=GotoService0 class=Class'MOHAGotoService'
    end object
    GotoService=GotoService0
    // Reference: AxonAnimService'Default__IdleMoveToMountedGunBrainState.AnimService0'
    begin object name=AnimService0 class=Class'AxonAnimService'
    end object
    AnimService=AnimService0
    // Reference: AxonEnemyService'Default__IdleMoveToMountedGunBrainState.EnemyService0'
    begin object name=EnemyService0 class=Class'AxonEnemyService'
    end object
    EnemyService=EnemyService0
    // Reference: NoEnemyAndNoMountedGunActivationService'Default__IdleMoveToMountedGunBrainState.ActivationService0'
    begin object name=ActivationService0 class=Class'NoEnemyAndNoMountedGunActivationService'
    end object
    ActivationService=ActivationService0
    // Reference: OnMMGUnMountedAxonScriptEvent'Default__IdleMoveToMountedGunBrainState.OnMMGEvent0'
    begin object name=OnMMGEvent0 class=Class'OnMMGUnMountedAxonScriptEvent'
    end object
    OnMMGEvent=OnMMGEvent0
    // Reference: OnMMGMountedAxonScriptEvent'Default__IdleMoveToMountedGunBrainState.OnMMGMountedEvent0'
    begin object name=OnMMGMountedEvent0 class=Class'OnMMGMountedAxonScriptEvent'
    end object
    OnMMGMountedEvent=OnMMGMountedEvent0
    EventServices=/* Array type was not detected. */
    AxonScriptEvents=/* Array type was not detected. */
}