class PKAI_Amputee extends PKAIController
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
    DelayBetweenAttacks=2.0000000
    JumpDistanceMinus=200.0000000
    bMoveToGoalByNavMesh_TryToUnstuck=false
    bIgnoreStepAside=true
    DefaultCommand=Class'PKAICmd_Base_Amputee'
    MeleeCommand=none
    EnemyDistance_Melee=150.0000000
    EnemyDistance_MeleeCharge=800.0000000
    // Reference: EvilAIReactManager'Default__PKAI_Amputee.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAIController.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=none
    DefaultReactConditionClasses=none
}