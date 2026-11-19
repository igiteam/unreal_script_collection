class PKAI_BreakBoy extends PKAI_Boy
    config(AI)
    hidecategories(Navigation);

defaultproperties
{
    JumpDistanceMinus=-400.0000000
    EnemyDistance_Melee=200.0000000
    // Reference: EvilAIReactManager'Default__PKAI_BreakBoy.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAI_Boy.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
}