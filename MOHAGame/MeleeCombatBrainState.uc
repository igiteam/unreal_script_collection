class MeleeCombatBrainState extends AxonControllerBrainState;

var export editinline MOHAGotoService GotoService;
var export editinline AxonEnemyService EnemyService;
var export editinline AxonAnimService AnimService;
var export editinline AxonCoverService CoverService;
var export editinline AxonPointService PointService;
var export editinline MeleeCombatActivationService ActivationService;
var export editinline AwaitTargetDeathScriptEvent AwaitDeathEvent;
var export editinline EnemyWithinRadiusAxonScriptEvent EnemyWithinRadiusEvent;
var Vector MeleeDir;
var Pawn CurrentEnemy;
var bool bMeleeTarget;
var bool bPlayerTarget;
var bool bForceWaitForActivation;
var float fMaxPlayerDist;
var float fRange;
var float fBehindRange;
var float fStationaryRange;
var float fShortAngle;
var float fLongAngle;
var int iTraversalDepth;

function SubstateFollowDirectPath(delegate<AxonDelegate> callback, float distToTarget, float Speed, optional name instanceID = 'Default', optional name Key = 'stack')
{
    PushEventParamFloat('distToTarget', distToTarget);
    PushEventParamFloat('Speed', Speed);
    PushEventParamDelegate('arrived', callback);
    PushEventParamName('instance_id', instanceID);
    RegisterSubstateEvent('FollowDirectPath', Key);
    //return;    
}

function RegisterActivationEvents()
{
    ActivationService.fRange = fRange;
    ActivationService.fBehindRange = fBehindRange;
    ActivationService.fStationaryRange = fStationaryRange;
    ActivationService.fShortAngle = fShortAngle;
    ActivationService.fLongAngle = fLongAngle;
    ActivationService.iTraversalDepth = iTraversalDepth;
    ActivationService.PointService = PointService;
    ActivationService.EnemyService = EnemyService;
    ActivationService.Controller = Controller;
    ActivationService.SuppressionLevel = 10;
    ActivationService.bForceWaitForActivation = bForceWaitForActivation;
    ActivationService.Start(ActivationEventTripped, 'MeleeActivation');
    //return;    
}

function ActivationEventTripped()
{
    CurrentEnemy = ActivationService.CurrentEnemy;
    bMeleeTarget = ActivationService.bMeleeTarget;
    bPlayerTarget = false;
    ActivateBrain();
    //return;    
}

function StartBrain()
{
    local MOHAAIPawn MOHAAIPawn;

    EnemyService.ClearThreatAssessments();
    EnemyService.AddDistanceThreatAssessment();
    EnemyService.AddPlayerShotAtMeThreatAssessment();
    MOHAAIPawn = MOHAAIPawn(MOHAPawn(Controller.Pawn).GetPawnBody());
    MOHAAIPawn.SetMeleeEnabled(true);
    bForceWaitForActivation = false;
    super(AxonBrainState).StartBrain();
    SetSuppressionLevel(10);
    GotoState('InitializeOIR');
    //return;    
}

function ResumeBrain(AxonBrainState usurperState)
{
    FinishBrain();
    //return;    
}

function StandardFinish()
{
    local MOHAAIPawn MOHAAIPawn;

    MOHAAIPawn = MOHAAIPawn(MOHAPawn(Controller.Pawn).GetPawnBody());
    MOHAAIPawn.SetMeleeEnabled(false);
    GetOIR().bInUse = false;
    GetOIR().DetachMeleeOIR();
    // End:0xC3
    if((CurrentEnemy != none) && MOHAScriptAIController(CurrentEnemy.Controller) != none)
    {
        MOHAScriptAIController(CurrentEnemy.Controller).ABSS.TripNamedScriptEvent('MeleeFinished');
    }
    super(AxonBrainState).StandardFinish();
    //return;    
}

function MeleeOIRImpl GetOIR()
{
    local MOHAAIPawn MOHAAIPawn;

    MOHAAIPawn = MOHAAIPawn(MOHAPawn(Controller.Pawn).GetPawnBody());
    return MOHAAIPawn.MImpl;
    //return ReturnValue;    
}

function WaitATick()
{
    ClearEventMapEntry('Background');
    // End:0x3D
    if(bMeleeTarget)
    {
        RegisterAxonSubstateTimer(1.0000000, FinishBrain,, 'Background');        
    }
    else
    {
        GotoState('PostMelee');
    }
    //return;    
}

function CalculateWithinClosePlayerDist()
{
    // End:0x37
    if(VSize(CurrentEnemy.Location - GetBot().Location) < fMaxPlayerDist)
    {
        bMeleeTarget = true;
    }
    //return;    
}

function Dummy()
{
    //return;    
}

state InitializeOIR extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        local MeleeOIRImpl MOIR;
        local MOHAAIPawn MOHAAIPawn;
        local MOHAPawn TargetPawn;

        MOHAAIPawn = MOHAAIPawn(MOHAPawn(Controller.Pawn).GetPawnBody());
        CoverService.ClearCover();
        MeleeDir = Normal(CurrentEnemy.Location - Controller.Pawn.Location);
        TargetPawn = MOHAPawn(CurrentEnemy);
        AwaitDeathEvent.Register(TargetPawn, WaitATick, 'Background');
        RegisterAxonNamedScriptEventListener('MeleeFinished', WaitATick, 'Background');
        MOIR = MOHAAIPawn.UpdateMeleeOIR(TargetPawn.Location, Rotator(MeleeDir));
        MOIR.AttachMeleeOIR(TargetPawn);
        MOIR.bInUse = true;
        // End:0x152
        if(CurrentEnemy.Controller.bIsPlayer)
        {
            bPlayerTarget = true;
            CalculateWithinClosePlayerDist();
        }
        // End:0x1F2
        if(!bMeleeTarget && MOHAScriptAIController(TargetPawn.Controller) != none)
        {
            MOHAScriptAIController(TargetPawn.Controller).ABSS.PushNamedScriptEventParamName('MeleeTarget', 'Attacker', GetBot().Name);
            MOHAScriptAIController(TargetPawn.Controller).ABSS.TripNamedScriptEvent('MeleeTarget');
        }
        GotoState('RunToEnemy');
        //return;        
    }
    stop;    
}

state RunToEnemy extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        local MOHAPawn TargetPawn;
        local MeleeOIRImpl MOIR;
        local float fRunSpeed;

        TargetPawn = MOHAPawn(CurrentEnemy);
        MOIR = GetOIR();
        fRunSpeed = Controller.fSprintSpeed;
        MOHAAIPawn(GetBot()).NPCtoNPCDamageMult = 1.0000000;
        // End:0xA7
        if(bMeleeTarget)
        {
            // End:0x99
            if(bPlayerTarget)
            {
                EnemyWithinRadiusEvent.RegisterCheckNotWithinRadius(Controller, fMaxPlayerDist, EnemyRanAway);
                fRunSpeed = 100.0000000;                
            }
            else
            {
                fRunSpeed = 0.0000000;
            }            
        }
        else
        {
            Controller.SendCCStimulus("MeleeCharge");
        }
        Controller.CoverPathObjectPenaltyMult = 0.0000000;
        GotoService.SubstateGotoOIR(GotoServiceDone,, MOIR,,, fRunSpeed,,, TargetPawn.Controller);
        RegisterAxonNamedScriptEventListener('MeleeStrike', MeleeStrike);
        //return;        
    }

    function EnemyRanAway()
    {
        GotoState('wait');
        //return;        
    }

    function GotoServiceDone()
    {
        // End:0x19
        if(GotoService.GetMoveFailed() == true)
        {
        }
        GotoState('wait');
        //return;        
    }

    function MeleeStrike()
    {
        GotoState('wait');
        //return;        
    }

    function ChildEndState(name NextStateName)
    {
        MOHAAIPawn(GetBot()).NPCtoNPCDamageMult = MOHAAIPawn(GetBot()).default.NPCtoNPCDamageMult;
        Controller.CoverPathObjectPenaltyMult = Controller.default.CoverPathObjectPenaltyMult;
        //return;        
    }
    stop;    
}

state wait extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        local MOHAAIPawn MOHAAIPawn;

        // End:0x3F
        if((!bPlayerTarget || MOHAPlayerPawn(CurrentEnemy) == none) || CurrentEnemy.Health <= 0)
        {
            FinishBrain();
            return;
        }
        Controller.SetPlayerShotAtMeThreatTime(5.0000000);
        RegisterAxonSubstateTimer(0.5000000, FinishBrain,, 'ReEngage');
        CalculateWithinClosePlayerDist();
        MOHAAIPawn = MOHAAIPawn(MOHAPawn(Controller.Pawn).GetPawnBody());
        // End:0x135
        if(Controller.PathableCanGo(MOHAAIPawn.Location, CurrentEnemy.Location))
        {
            MeleeDir = Normal(CurrentEnemy.Location - Controller.Pawn.Location);
            MOHAAIPawn.UpdateMeleeOIR(CurrentEnemy.Location, Rotator(MeleeDir));
        }
        // End:0x199
        if((Controller.TeamIndex == 1) && (FRand() * 100.0000000) >= Controller.fMeleeAggressivenessPct)
        {
            bForceWaitForActivation = true;
            RegisterAxonSubstateStimulus('PlayerPresenceMeleeRange', 'PlayerPresenceMeleeRange', RepeatMelee);            
        }
        else
        {
            GotoState('TryRepeatMelee');
        }
        //return;        
    }

    function RepeatMelee()
    {
        GotoState('TryRepeatMelee');
        //return;        
    }
    stop;    
}

state TryRepeatMelee extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        PointService.SubstateDirectPath(LongAttack, 0.0000000, fRange, 0.0000000, fBehindRange, fStationaryRange, fShortAngle, iTraversalDepth, true);
        //return;        
    }

    function LongAttack()
    {
        ClearEventMapEntry('ReEngage');
        GotoState('RunToEnemy');
        //return;        
    }
    stop;    
}

state PostMelee extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        local Vector vDest;

        // End:0x42
        if(!FindRunaheadPoint(400.0000000, vDest))
        {
            // End:0x42
            if(!FindRunaheadPoint(200.0000000, vDest))
            {
                vDest = GetBotLocation();
            }
        }
        GotoService.SubstateGotoOIR(GotoServiceDone, vDest,, 'Aim',, Controller.fSprintSpeed);
        //return;        
    }

    function GotoServiceDone()
    {
        FinishBrain();
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: MOHAGotoService'Default__MeleeCombatBrainState.GotoFNCService0'
    begin object name=GotoFNCService0 class=Class'MOHAGotoService'
    end object
    GotoService=GotoFNCService0
    // Reference: AxonEnemyService'Default__MeleeCombatBrainState.EnemyService0'
    begin object name=EnemyService0 class=Class'AxonEnemyService'
    end object
    EnemyService=EnemyService0
    // Reference: AxonAnimService'Default__MeleeCombatBrainState.AnimService0'
    begin object name=AnimService0 class=Class'AxonAnimService'
    end object
    AnimService=AnimService0
    // Reference: MOHACoverService'Default__MeleeCombatBrainState.CoverService0'
    begin object name=CoverService0 class=Class'MOHACoverService'
    end object
    CoverService=CoverService0
    // Reference: AxonPointService'Default__MeleeCombatBrainState.PointService0'
    begin object name=PointService0 class=Class'EAKynapse.AxonPointService'
    end object
    PointService=PointService0
    // Reference: MeleeCombatActivationService'Default__MeleeCombatBrainState.ActivationService0'
    begin object name=ActivationService0 class=Class'MeleeCombatActivationService'
    end object
    ActivationService=ActivationService0
    // Reference: AwaitTargetDeathScriptEvent'Default__MeleeCombatBrainState.AwaitDeathEvent0'
    begin object name=AwaitDeathEvent0 class=Class'AwaitTargetDeathScriptEvent'
    end object
    AwaitDeathEvent=AwaitDeathEvent0
    // Reference: EnemyWithinRadiusAxonScriptEvent'Default__MeleeCombatBrainState.EnemyWithinRadiusEvent0'
    begin object name=EnemyWithinRadiusEvent0 class=Class'EnemyWithinRadiusAxonScriptEvent'
    end object
    EnemyWithinRadiusEvent=EnemyWithinRadiusEvent0
    fMaxPlayerDist=150.0000000
    fRange=400.0000000
    fBehindRange=200.0000000
    fStationaryRange=400.0000000
    fShortAngle=120.0000000
    fLongAngle=180.0000000
    iTraversalDepth=4
    EventServices=/* Array type was not detected. */
    AxonScriptEvents=/* Array type was not detected. */
}