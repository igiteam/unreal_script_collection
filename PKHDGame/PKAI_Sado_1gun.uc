class PKAI_Sado_1gun extends PKAI_Sado
    config(AI)
    hidecategories(Navigation);

defaultproperties
{
    DefaultCommand=Class'PKAICmd_Base_Sado_1gun'
    // Reference: EvilAIReactManager'Default__PKAI_Sado_1gun.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAI_Sado.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
}