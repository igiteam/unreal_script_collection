class PKAI_Hellangel_NotMoveableThrower extends PKAI_Hellangel
    config(AI)
    hidecategories(Navigation);

defaultproperties
{
    DefaultCommand=Class'PKAICmd_Base_Hellangel_NotMoveableThrower'
    MoveCommand=none
    EnemyDistance_Shoot=5000.0000000
    // Reference: EvilAIReactManager'Default__PKAI_Hellangel_NotMoveableThrower.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAI_Hellangel.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
}