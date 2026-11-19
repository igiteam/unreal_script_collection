class VehicleMountedGunCombatBrainState extends MountedGunCombatBrainState;

function RegisterActivationEvents()
{
    //return;    
}

function RegisterParentSubstateEvents()
{
    EnemyService.ClearThreatAssessments();
    EnemyService.AddDistanceThreatAssessment();
    EnemyService.AddPlayerShotAtMeThreatAssessment();
    EnemyService.AddWithinFiringArcThreatAssessment(Controller.fMMGHalfAngleFiringArcDeg);
    //return;    
}

function ResumeBrain(AxonBrainState usurperState)
{
    DestroyTransplantBrain();
    //return;    
}

function RegisterCombatLostEnemy()
{
    //return;    
}

function CombatLostEnemy()
{
    //return;    
}

function MountedGunInvalid()
{
    //return;    
}

function InitStartCombat()
{
    GotoState('StartAim');
    //return;    
}

function InitializeMountedGun()
{
    //return;    
}

state StartAim extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        AnimService.RegisterAnimationEvent('Aim', AimAnimDone, MountedGun);
        //return;        
    }

    function AimAnimDone()
    {
        GotoState('CheckForEnemy');
        //return;        
    }
    stop;    
}

state CheckForEnemy extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        EnemyService.SubstateHasEnemy(HasEnemy);
        //return;        
    }

    function HasEnemy()
    {
        GotoState('Aim');
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: EnemyWithinFiringArcAxonScriptEvent'Default__VehicleMountedGunCombatBrainState.EnemyWithinFiringArcEvent0'
    begin object name=EnemyWithinFiringArcEvent0
    end object
    EnemyWithinFiringArcEvent=EnemyWithinFiringArcEvent0
    ActivationService=none
    OnMMGEvent=none
    // Reference: AxonEnemyService'Default__VehicleMountedGunCombatBrainState.FireEnemyService0'
    begin object name=FireEnemyService0
    end object
    EnemyService=FireEnemyService0
    // Reference: MOHACoverService'Default__VehicleMountedGunCombatBrainState.CoverService0'
    begin object name=CoverService0
    end object
    CoverService=CoverService0
    // Reference: AxonAnimService'Default__VehicleMountedGunCombatBrainState.AnimService0'
    begin object name=AnimService0
    end object
    AnimService=AnimService0
    // Reference: BurstFireAxonScriptEvent'Default__VehicleMountedGunCombatBrainState.BurstFireEvent0'
    begin object name=BurstFireEvent0
    end object
    BurstFireEvent=BurstFireEvent0
    // Reference: DecaySuppressionAxonScriptEvent'Default__VehicleMountedGunCombatBrainState.DecaySuppressionEvent0'
    begin object name=DecaySuppressionEvent0
    end object
    DecaySuppressionEvent=DecaySuppressionEvent0
    // Reference: AmmoCountAxonScriptEvent'Default__VehicleMountedGunCombatBrainState.AmmoCountEvent0'
    begin object name=AmmoCountEvent0
    end object
    AmmoCountEvent=AmmoCountEvent0
    // Reference: CCRequestPerformanceAxonScriptEvent'Default__VehicleMountedGunCombatBrainState.CCRequestEvent0'
    begin object name=CCRequestEvent0
    end object
    CCRequestEvent=CCRequestEvent0
    // Reference: CCAwaitPerformanceAxonScriptEvent'Default__VehicleMountedGunCombatBrainState.CCAwaitEvent0'
    begin object name=CCAwaitEvent0
    end object
    CCAwaitEvent=CCAwaitEvent0
    iSuppressionLevel=18
    EventServices=/* Array type was not detected. */
    AxonScriptEvents=/* Array type was not detected. */
}