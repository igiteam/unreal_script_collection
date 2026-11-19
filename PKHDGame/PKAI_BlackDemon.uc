class PKAI_BlackDemon extends PKAIController
    config(AI)
    hidecategories(Navigation);

var PKPawn_BlackDemon_Base MyPKPawn_BlackDemon;

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
    super.Possess(NewPawn, bVehicleTransition);
    AutoAcquireEnemy();
    SetAttackBehavior();
    // End:0x5C
    if(MyPKPawn != none)
    {
        MyPKPawn_BlackDemon = PKPawn_BlackDemon_Base(MyPKPawn);
    }
    //return;    
}

defaultproperties
{
    MinDelayBetweenThrow=4.0000000
    bMoveToGoalByNavMesh_TryToUnstuck=false
    bIgnoreStepAside=true
    DefaultCommand=Class'PKAICmd_Base_BlackDemon'
    MeleeCommand=none
    EnemyDistance_Melee=250.0000000
    // Reference: EvilAIReactManager'Default__PKAI_BlackDemon.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAIController.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=none
    DefaultReactConditionClasses=none
    TimeBetweenThrows=8.0000000
}