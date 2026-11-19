class PKAI_Preacher extends PKAIController
    config(AI)
    hidecategories(Navigation);

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
    super.Possess(NewPawn, bVehicleTransition);
    AutoAcquireEnemy();
    SetAttackBehavior();
    //return;    
}

function OnToggleGodMode(SeqAct_ToggleGodMode inAction)
{
    super(Controller).OnToggleGodMode(inAction);
    MyPKPawn.SetImmortalMaterial(!bGodMode);
    //return;    
}

defaultproperties
{
    bMoveToGoalByNavMesh_TryToUnstuck=false
    bIgnoreStepAside=true
    DefaultCommand=Class'PKAICmd_Base_Preacher'
    MeleeCommand=none
    EnemyDistance_Melee=300.0000000
    // Reference: EvilAIReactManager'Default__PKAI_Preacher.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAIController.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=none
    DefaultReactConditionClasses=none
}