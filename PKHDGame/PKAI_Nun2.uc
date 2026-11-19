class PKAI_Nun2 extends PKAI_Nun
    config(AI)
    hidecategories(Navigation);

simulated function OnStartThrow()
{
    MyPKPawn.OnStartFire();
    //return;    
}

defaultproperties
{
    MinDelayBetweenThrow=10.0000000
    ThrowRangeMin=600.0000000
    DefaultCommand=Class'PKAICmd_Base_Nun2'
    // Reference: EvilAIReactManager'Default__PKAI_Nun2.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAI_Nun.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
}