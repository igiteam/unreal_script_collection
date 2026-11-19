class RB_PulleyJointActor extends RB_ConstraintActor
    placeable
    hidecategories(lighting);

defaultproperties
{
    // Reference: RB_PulleyJointSetup'Default__RB_PulleyJointActor.MyPulleyJointSetup'
    begin object name="MyPulleyJointSetup" class=Class'RB_PulleyJointSetup'
    end object
    ConstraintSetup=MyPulleyJointSetup
    // Reference: SpriteComponent'Default__RB_PulleyJointActor.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__RB_ConstraintActor.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'EngineResources.S_KBSJoint'
    end object
    Components[0]=Sprite
    // Reference: RB_ConstraintDrawComponent'Default__RB_PulleyJointActor.MyConDrawComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: RB_ConstraintDrawComponent'Default__RB_ConstraintActor.MyConDrawComponent'
    begin object name="MyConDrawComponent"
    end object
    Components[1]=MyConDrawComponent
}