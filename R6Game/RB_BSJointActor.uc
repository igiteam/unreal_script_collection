class RB_BSJointActor extends RB_ConstraintActor
    native
    placeable
    hidecategories(lighting);

defaultproperties
{
    // Reference: RB_BSJointSetup'Default__RB_BSJointActor.MyBSJointSetup'
    begin object name="MyBSJointSetup" class=Class'RB_BSJointSetup'
    end object
    ConstraintSetup=MyBSJointSetup
    // Reference: SpriteComponent'Default__RB_BSJointActor.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__RB_ConstraintActor.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'EngineResources.S_KBSJoint'
    end object
    Components[0]=Sprite
    // Reference: RB_ConstraintDrawComponent'Default__RB_BSJointActor.MyConDrawComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: RB_ConstraintDrawComponent'Default__RB_ConstraintActor.MyConDrawComponent'
    begin object name="MyConDrawComponent"
    end object
    Components[1]=MyConDrawComponent
}