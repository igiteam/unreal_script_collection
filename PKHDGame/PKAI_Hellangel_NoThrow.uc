class PKAI_Hellangel_NoThrow extends PKAI_Hellangel
    config(AI)
    hidecategories(Navigation);

defaultproperties
{
    DefaultFarAttackPriority=0.0000000
    DefaultNearAttackPriority=1.0000000
    ThrowRangeMax=1500.0000000
    DefaultCommand=Class'PKAICmd_Base_Hellangel_NoThrow'
    // Reference: EvilAIReactManager'Default__PKAI_Hellangel_NoThrow.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAI_Hellangel.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
}