class PKAI_Sado_1gun_Area extends PKAI_Sado
    config(AI)
    hidecategories(Navigation);

defaultproperties
{
    bWalkAreaWhenAttack=true
    bWalkAreaRandom=true
    DefaultCommand=Class'PKAICmd_Base_Sado_1gun_Area'
    // Reference: EvilAIReactManager'Default__PKAI_Sado_1gun_Area.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAI_Sado.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
}