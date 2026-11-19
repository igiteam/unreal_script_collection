class PKAI_TestZombie extends PKAI_ZombieSoldier
    config(AI)
    hidecategories(Navigation);

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
    super(PKAIController).Possess(NewPawn, bVehicleTransition);
    //return;    
}

function bool ShouldReturnToIdle()
{
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    DefaultCommand=Class'PKAICmd_TestZombie'
    // Reference: EvilAIReactManager'Default__PKAI_TestZombie.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAI_ZombieSoldier.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
}