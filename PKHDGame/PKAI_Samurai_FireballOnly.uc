class PKAI_Samurai_FireballOnly extends PKAI_Samurai
    config(AI)
    hidecategories(Navigation);

defaultproperties
{
    DefaultCommand=Class'PKAICmd_Base_Samurai_FireballOnly'
    // Reference: EvilAIReactManager'Default__PKAI_Samurai_FireballOnly.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAI_Samurai.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
}