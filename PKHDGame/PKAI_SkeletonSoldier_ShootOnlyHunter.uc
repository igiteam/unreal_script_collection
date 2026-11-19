class PKAI_SkeletonSoldier_ShootOnlyHunter extends PKAI_SkeletonSoldier
    config(AI)
    hidecategories(Navigation);

defaultproperties
{
    DefaultCommand=Class'PKAICmd_Base_SkeletonSoldier_ShootOnlyHunter'
    // Reference: EvilAIReactManager'Default__PKAI_SkeletonSoldier_ShootOnlyHunter.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAI_SkeletonSoldier.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
}