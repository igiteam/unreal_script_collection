class PKAI_Sado_1gun_CloseUZI extends PKAI_Sado
    config(AI)
    hidecategories(Navigation);

defaultproperties
{
    DefaultCommand=Class'PKAICmd_Base_Sado_1gun_CloseUZI'
    EnemyDistance_Shoot=1000.0000000
    // Reference: EvilAIReactManager'Default__PKAI_Sado_1gun_CloseUZI.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAI_Sado.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
}