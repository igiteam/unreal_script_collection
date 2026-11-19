class PKAI_Girl extends PKAIController
    config(AI)
    hidecategories(Navigation);

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
    super.Possess(NewPawn, bVehicleTransition);
    AutoAcquireEnemy();
    SetAttackBehavior();
    //return;    
}

function bool NotifyBump(Actor Other, Vector HitNormal)
{
    // End:0xBD
    if(((PKPawn(Other) != none) && PKPawn(Other) == Enemy) && FRand() < 0.1000000)
    {
        // End:0xBD
        if(!MyPKPawn.IsTimerActive('OnScreamAttackEnd', MyPKPawn))
        {
            MyPKPawn.SetTimer(RandRange(0.1000000, 0.5000000), false, 'OnScreamAttackEnd', MyPKPawn);
        }
    }
    return super.NotifyBump(Other, HitNormal);
    //return ReturnValue;    
}

function bool CanThrowGrenade()
{
    return !MyPKPawn.RepHitEffectParams.bStarted;
    //return ReturnValue;    
}

defaultproperties
{
    MinDelayBetweenThrow=5.0000000
    ThrowRangeMax=1000.0000000
    ThrowRangeMin=300.0000000
    bMoveToGoalByNavMesh_TryToUnstuck=false
    bIgnoreStepAside=true
    DefaultCommand=Class'PKAICmd_Base_Girl'
    MeleeCommand=none
    EnemyDistance_Melee=150.0000000
    // Reference: EvilAIReactManager'Default__PKAI_Girl.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAIController.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=none
    DefaultReactConditionClasses=none
}