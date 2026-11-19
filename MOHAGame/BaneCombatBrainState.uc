class BaneCombatBrainState extends OpenCombatBrainState;

var export editinline EnemyWithinFiringArcAxonScriptEvent EnemyWithinFiringArcEvent;
var() float fShootMoveSpeed;
var() float fMinNewShootPointDistFromOldPos;
var name RunName;
var name NoFireRunName;

function RegisterParentSubstateEvents()
{
    EnemyService.ClearThreatAssessments();
    EnemyService.AddDistanceThreatAssessment();
    EnemyService.AddPlayerShotAtMeThreatAssessment();
    EnemyService.AddCoverBlowerThreatAssessment();
    //return;    
}

function RegisterFindShootPointConstraints()
{
    local Vector vPos;
    local float fDist;

    PointService.ClearPointConstraints(instanceID);
    PointService.PushPointDistanceEnvelopeConstraint(fMinNewShootPointDistFromOldPos, 50000.0000000, fMinNewShootPointDistFromOldPos * 2.0000000, 50000.0000000, GetBotLocation(), 1500.0000000, true, instanceID);
    // End:0x10B
    if(GetEnemyLocation(vPos))
    {
        fDist = VSize(vPos - (GetBotLocation()));
        fDist = FMin(fDist * 0.7500000, Controller.fMaxEngageDist);
        PointService.PushPointDistanceEnvelopeConstraint(Controller.fMinEngageDist, fDist, Controller.fMinEngagePenaltyDist, FMin(Controller.fMaxEngagePenaltyDist, fDist * 0.6000000), vPos, 10000.0000000, true, instanceID);
    }
    PointService.PushWithinLeashConstraint(instanceID);
    PointService.PushWithinTacaffPointConstraint(PointService.fTacaffFriendlyPenalty, PointService.fTacaffNeutralPenalty, PointService.fTacaffEnemyPenalty, instanceID);
    PointService.PushWithinTacaffPointConstraint(,,, instanceID);
    PointService.PushPointClaimedConstraint(, instanceID);
    PointService.PushShootPointConstraint(none, false, instanceID);
    //return;    
}

state Aim
{
    function PlayerShotNear()
    {
        SetPlayerShotAtThreat();
        GotoState('FindShootPoint');
        //return;        
    }
    stop;    
}

state AimWait
{
    function PlayerShotNear()
    {
        SetPlayerShotAtThreat();
        GotoState('FindShootPoint');
        //return;        
    }
    stop;    
}

state Fire
{
    function ChildBeginState(name PreviousStateName)
    {
        RegisterAxonSubstateStimulus('Grenade', 'Grenade', GrenadeNearby);
        BurstFireEvent.RegisterBurstSubstate(Controller, Controller.GetMMGBurst(), BurstDone, Controller.Focus);
        EnemyService.SubstateNoLongerSeeEnemy(NoLongerSeeEnemy, 2500, instanceID);
        EnemyService.SubstateLostEnemy(CombatLostEnemy, instanceID);
        ConditionalRegisterReloadEvent();
        //return;        
    }

    function GrenadeNearby()
    {
        GotoState('FindShootPoint');
        //return;        
    }

    function BurstDone()
    {
        CurrentBursts++;
        // End:0x37
        if(CurrentBursts >= Controller.MaxOpenCombatBursts)
        {
            CurrentBursts = 0;
            GotoState('FindShootPoint');            
        }
        else
        {
            GotoState('WaitBetweenBursts');
        }
        //return;        
    }

    function PlayerShotNear()
    {
        SetPlayerShotAtThreat();
        GotoState('FindShootPoint');
        //return;        
    }
    stop;    
}

state RunToPoint
{
    function ChildBeginState(name PreviousStateName)
    {
        EnemyWithinFiringArcEvent.RegisterCheckOutsideFiringArc(Controller, BurstDone);
        BurstFireEvent.RegisterBurstSubstate(Controller, Controller.GetWildBurst(), BurstDone, Controller.Focus);
        EnemyService.SubstateLostEnemy(BurstDone);
        PreValidateRunToPoint();
        MOHAPawn(Controller.Pawn).DesiredPosture = GotoService.GetDesiredPosture(2);
        Controller.bAimAtFocus = true;
        GotoService.SubstateGotoOIR(ArrivedAtPoint, RunPosition,, 'Aim',, fShootMoveSpeed,, instanceID);
        //return;        
    }

    function BurstDone()
    {
        GotoState('NoFireRunToPoint');
        //return;        
    }
    stop;    
}

state NoFireRunToPoint extends RunToPoint
{
    function ChildBeginState(name PreviousStateName)
    {
        PreValidateRunToPoint();
        GotoService.SubstateGotoOIR(ArrivedAtPoint, RunPosition,, 'Aim',, Controller.fMoveSpeed,, instanceID,, 'Goto');
        EnemyService.SubstateOnCanSeeEnemy(CanSeeEnemy, Name);
        Controller.fAimLagStrengthMMG = -1.0000000;
        MOHAPawn(Controller.Pawn).DesiredPosture = GotoService.GetDesiredPosture(2);
        Controller.bAimAtFocus = false;
        //return;        
    }

    function ChildEndState(name NextStateName)
    {
        Controller.bAimAtFocus = true;
        Controller.fAimLagStrengthMMG = Controller.default.fAimLagStrengthMMG;
        ClearEventMapEntry('Goto');
        //return;        
    }

    function CanSeeEnemy()
    {
        PopEventStack();
        PushEventStack();
        EnemyWithinFiringArcEvent.RegisterCheckInsideFiringArc(Controller, CanFire);
        EnemyService.SubstateNoLongerSeeEnemy(CantSee);
        //return;        
    }

    function CanFire()
    {
        PopEventStack();
        GotoState('RunToPoint');
        //return;        
    }

    function CantSee()
    {
        PopEventStack();
        PushEventStack();
        EnemyService.SubstateOnCanSeeEnemy(CanSeeEnemy, Name);
        //return;        
    }
    stop;    
}

state FindShootPoint
{
    function TraversalFailed()
    {
        local Vector vEnemyPos;

        // End:0x20
        if((GetEnemyLocation(vEnemyPos)) == false)
        {
            vEnemyPos = PreHidePosition;
        }
        RunPosition = vEnemyPos;
        GotoState('RunToPoint');
        //return;        
    }
    stop;    
}

state Reload
{
    function PlayerShotNear()
    {
        SetPlayerShotAtThreat();
        GotoState('FindShootPoint');
        //return;        
    }
    stop;    
}

state WaitBetweenBursts
{
    function PlayerShotNear()
    {
        SetPlayerShotAtThreat();
        GotoState('FindShootPoint');
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: EnemyWithinFiringArcAxonScriptEvent'Default__BaneCombatBrainState.EnemyWithinFiringArcEvent0'
    begin object name=EnemyWithinFiringArcEvent0 class=Class'EnemyWithinFiringArcAxonScriptEvent'
        fEncroachedDistanceMax=1000.0000000
    end object
    EnemyWithinFiringArcEvent=EnemyWithinFiringArcEvent0
    fShootMoveSpeed=150.0000000
    fMinNewShootPointDistFromOldPos=450.0000000
    RunName="RunToPoint"
    NoFireRunName="NoFireRunToPoint"
    // Reference: CanShootEnemyActivationService'Default__BaneCombatBrainState.ActivationService0'
    begin object name=ActivationService0
    end object
    ActivationService=ActivationService0
    // Reference: AxonPointService'Default__BaneCombatBrainState.PointService0'
    begin object name=PointService0
    end object
    PointService=PointService0
    // Reference: MOHAGotoService'Default__BaneCombatBrainState.GotoFNCService0'
    begin object name=GotoFNCService0
    end object
    GotoService=GotoFNCService0
    // Reference: LODStatusScriptEvent'Default__BaneCombatBrainState.LODStatusEvent0'
    begin object name=LODStatusEvent0
    end object
    LODStatusEvent=LODStatusEvent0
    iMaxTraversalEdges=256
    iShootPointsToFind=5
    // Reference: AxonEnemyService'Default__BaneCombatBrainState.FireEnemyService0'
    begin object name=FireEnemyService0
    end object
    EnemyService=FireEnemyService0
    // Reference: MOHACoverService'Default__BaneCombatBrainState.CoverService0'
    begin object name=CoverService0
    end object
    CoverService=CoverService0
    // Reference: AxonAnimService'Default__BaneCombatBrainState.AnimService0'
    begin object name=AnimService0
    end object
    AnimService=AnimService0
    // Reference: BurstFireAxonScriptEvent'Default__BaneCombatBrainState.BurstFireEvent0'
    begin object name=BurstFireEvent0
    end object
    BurstFireEvent=BurstFireEvent0
    // Reference: DecaySuppressionAxonScriptEvent'Default__BaneCombatBrainState.DecaySuppressionEvent0'
    begin object name=DecaySuppressionEvent0
    end object
    DecaySuppressionEvent=DecaySuppressionEvent0
    // Reference: AmmoCountAxonScriptEvent'Default__BaneCombatBrainState.AmmoCountEvent0'
    begin object name=AmmoCountEvent0
    end object
    AmmoCountEvent=AmmoCountEvent0
    // Reference: CCRequestPerformanceAxonScriptEvent'Default__BaneCombatBrainState.CCRequestEvent0'
    begin object name=CCRequestEvent0
    end object
    CCRequestEvent=CCRequestEvent0
    // Reference: CCAwaitPerformanceAxonScriptEvent'Default__BaneCombatBrainState.CCAwaitEvent0'
    begin object name=CCAwaitEvent0
    end object
    CCAwaitEvent=CCAwaitEvent0
    instanceID="BaneCombat"
    EventServices=/* Array type was not detected. */
    AxonScriptEvents=/* Array type was not detected. */
}