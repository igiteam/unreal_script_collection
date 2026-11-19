class PKAI_LabCommandosNoGrenades extends PKAI_LabCommandos
    config(AI)
    hidecategories(Navigation);

defaultproperties
{
    DefaultCommand=Class'PKAICmd_Base_LabCommandosNoGrenades'
    // Reference: EvilAIReactManager'Default__PKAI_LabCommandosNoGrenades.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAI_LabCommandos.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
}