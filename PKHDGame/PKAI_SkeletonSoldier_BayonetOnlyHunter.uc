class PKAI_SkeletonSoldier_BayonetOnlyHunter extends PKAI_SkeletonSoldier
    config(AI)
    hidecategories(Navigation);

defaultproperties
{
    DefaultCommand=Class'PKAICmd_Base_SkeletonSoldier_BayonetOnlyHunter'
    // Reference: EvilAIReactManager'Default__PKAI_SkeletonSoldier_BayonetOnlyHunter.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAI_SkeletonSoldier.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
}