class PKAI_Samurai extends PKAIController
    config(AI)
    hidecategories(Navigation);

function Vector GetThrowExtent()
{
    return vect(25.0000000, 25.0000000, 25.0000000);
    //return ReturnValue;    
}

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
    ChangePosAfterFireChance=0.8000000
    ThrowRangeMin=400.0000000
    bMoveToGoalByNavMesh_TryToUnstuck=false
    bIgnoreStepAside=true
    DefaultCommand=Class'PKAICmd_Base_Samurai'
    MeleeCommand=none
    EnemyDistance_Shoot=3000.0000000
    // Reference: EvilAIReactManager'Default__PKAI_Samurai.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAIController.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=none
    DefaultReactConditionClasses=none
}