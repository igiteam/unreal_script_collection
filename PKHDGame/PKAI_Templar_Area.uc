class PKAI_Templar_Area extends PKAI_Templar
    config(AI)
    hidecategories(Navigation);

defaultproperties
{
    bWalkAreaWhenAttack=true
    DelayBetweenAttacks=2.5000000
    ChangePosAfterFireChance=0.6000000
    EnemyDistance_Shoot=9000.0000000
    // Reference: EvilAIReactManager'Default__PKAI_Templar_Area.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAI_Templar.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
}