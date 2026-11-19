class PKAI_Giant_Ambient extends PKAIController
    config(AI)
    hidecategories(Navigation);

function bool NotifyBump(Actor Other, Vector HitNormal)
{
    //return ReturnValue;    
}

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
    super.Possess(NewPawn, bVehicleTransition);
    //return;    
}

defaultproperties
{
    bMoveToGoalByNavMesh_TryToUnstuck=false
    bIgnoreStepAside=true
    DefaultCommand=Class'PKAICmd_Base_Zombie'
    MeleeCommand=none
    // Reference: EvilAIReactManager'Default__PKAI_Giant_Ambient.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAIController.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=none
    DefaultReactConditionClasses=none
}