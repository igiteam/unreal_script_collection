class PKAI_Boss_Reaper extends PKAIController
    config(AI)
    hidecategories(Navigation);

var int Stage;
var PKPawn_Boss_Reaper_Base MyReaperPawn;

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
    super.Possess(NewPawn, bVehicleTransition);
    AutoAcquireEnemy();
    SetAttackBehavior();
    MyReaperPawn = PKPawn_Boss_Reaper_Base(NewPawn);
    //return;    
}

defaultproperties
{
    DefaultCommand=Class'PKAICmd_Base_Reaper'
    MeleeCommand=none
    GuardCommand=none
    StrafeCommand=none
    // Reference: EvilAIReactManager'Default__PKAI_Boss_Reaper.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAIController.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=/* Array type was not detected. */
}