class PKAI_Samurai_NoFireball extends PKAI_Samurai
    config(AI)
    hidecategories(Navigation);

defaultproperties
{
    DefaultCommand=Class'PKAICmd_Base_Samurai_NoFireball'
    // Reference: EvilAIReactManager'Default__PKAI_Samurai_NoFireball.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAI_Samurai.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
}