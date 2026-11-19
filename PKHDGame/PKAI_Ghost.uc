class PKAI_Ghost extends PKAIController
    config(AI)
    hidecategories(Navigation);

function bool NotifyBump(Actor Other, Vector HitNormal)
{
    return true;
    //return ReturnValue;    
}

simulated function StartMeleeAttack()
{
    //return;    
}

function bool HasValidEnemy()
{
    return super.HasValidEnemy() || Enemy != none;
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
    bMoveToGoalByNavMesh_TryToUnstuck=false
    bIgnoreStepAside=true
    DefaultCommand=Class'PKAICmd_Base_Ghost'
    MeleeCommand=none
    EnemyDistance_Melee=500.0000000
    // Reference: EvilAIReactManager'Default__PKAI_Ghost.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAIController.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=none
    DefaultReactConditionClasses=none
}