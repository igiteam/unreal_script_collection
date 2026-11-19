class PKAI_Banshee_NoMoveScreamer extends PKAI_Banshee
    config(AI)
    hidecategories(Navigation);

defaultproperties
{
    DefaultCommand=Class'PKAICmd_Base_Banshee_NoMoveScreamer'
    // Reference: EvilAIReactManager'Default__PKAI_Banshee_NoMoveScreamer.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAI_Banshee.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
}