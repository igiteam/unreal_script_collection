class PKAI_ZombieSoldier_RunOnlyHunter extends PKAI_ZombieSoldier
    config(AI)
    hidecategories(Navigation);

defaultproperties
{
    bAlwaysSee=true
    // Reference: EvilAIReactManager'Default__PKAI_ZombieSoldier_RunOnlyHunter.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAI_ZombieSoldier.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
}