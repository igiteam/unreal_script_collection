class PKAI_Hellangel extends PKAIController
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
    DefaultFarAttackPriority=0.7000000
    DefaultNearAttackPriority=0.3000000
    ThrowRangeMax=1000.0000000
    ThrowRangeMin=400.0000000
    bMoveToGoalByNavMesh_TryToUnstuck=false
    bIgnoreStepAside=true
    DefaultCommand=Class'PKAICmd_Base_Hellangel'
    MeleeCommand=none
    EnemyDistance_Shoot=1000.0000000
    EnemyDistance_Melee=200.0000000
    EnemyDistance_MeleeCharge=400.0000000
    // Reference: EvilAIReactManager'Default__PKAI_Hellangel.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAIController.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=none
    DefaultReactConditionClasses=none
}