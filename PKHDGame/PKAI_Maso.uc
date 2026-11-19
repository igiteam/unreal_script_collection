class PKAI_Maso extends PKAIController
    config(AI)
    hidecategories(Navigation);

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
    super.Possess(NewPawn, bVehicleTransition);
    AutoAcquireEnemy();
    SetAttackBehavior();
    //return;    
}

defaultproperties
{
    ChangePosAfterFireChance=0.2000000
    ThrowRangeMin=600.0000000
    bMoveToGoalByNavMesh_TryToUnstuck=false
    bIgnoreStepAside=true
    DefaultCommand=Class'PKAICmd_Base_Maso'
    MeleeCommand=none
    EnemyDistance_Shoot=3000.0000000
    EnemyDistance_Throw=1500.0000000
    EnemyDistance_Melee=300.0000000
    EnemyDistance_MeleeCharge=200.0000000
    // Reference: EvilAIReactManager'Default__PKAI_Maso.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAIController.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=none
    DefaultReactConditionClasses=none
    MaxTimeBetweenFireBurst=0.2000000
    MinTimeBetweenFireBurst=0.1000000
    TimeBetweenThrows=8.0000000
    BurstFireTimeout=1.0000000
    BurstFireSpreadTime=0.5000000
    BurstFireLag=0.5000000
}