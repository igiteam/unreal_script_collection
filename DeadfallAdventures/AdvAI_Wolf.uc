class AdvAI_Wolf extends EvilAIController
    config(AI)
    hidecategories(Navigation);

function bool NotifyBump(Actor Other, Vector HitNormal)
{
    //return ReturnValue;    
}

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
    super.Possess(NewPawn, bVehicleTransition);
    AutoAcquireEnemy();
    SetAttackBehavior(Enemy);
    //return;    
}

function bool CanMeleeAttack()
{
    return super.CanMeleeAttack();
    //return ReturnValue;    
}

defaultproperties
{
    bMoveToGoalByNavMesh_TryToUnstuck=false
    bIgnoreStepAside=true
    DefaultCommand=Class'AdvAICmd_Base_Animal'
    MeleeCommand=Class'EvilAICmd_Wolf_Melee'
    // Reference: EvilAIReactManager'Default__AdvAI_Wolf.ReactionManager0'
    begin object name=ReactionManager0
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=/* Array type was not detected. */
}