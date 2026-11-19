class PKAI_LabCommandosSniperMeat extends PKAI_LabCommandos
    config(AI)
    hidecategories(Navigation);

defaultproperties
{
    bWalkAreaWhenAttack=true
    EnemyDistance_Shoot=10000.0000000
    // Reference: EvilAIReactManager'Default__PKAI_LabCommandosSniperMeat.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAI_LabCommandos.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
}