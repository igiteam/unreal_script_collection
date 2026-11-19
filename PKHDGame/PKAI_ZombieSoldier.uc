class PKAI_ZombieSoldier extends PKAIController
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
    bMoveToGoalByNavMesh_TryToUnstuck=false
    bIgnoreStepAside=true
    DefaultCommand=Class'PKAICmd_Base_Zombie'
    MeleeCommand=none
    EnemyDistance_Melee=250.0000000
    EnemyDistance_MeleeCharge=400.0000000
    // Reference: EvilAIReactManager'Default__PKAI_ZombieSoldier.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAIController.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=none
    DefaultReactConditionClasses=none
}