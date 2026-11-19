class RB_HingeActor extends RB_ConstraintActor
    native
    placeable
    hidecategories(lighting);

defaultproperties
{
    // Reference: RB_HingeSetup'Default__RB_HingeActor.MyHingeSetup'
    begin object name="MyHingeSetup" class=Class'RB_HingeSetup'
    end object
    ConstraintSetup=MyHingeSetup
    // Reference: SpriteComponent'Default__RB_HingeActor.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__RB_ConstraintActor.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'EngineResources.S_KHinge'
    end object
    Components[0]=Sprite
    // Reference: RB_ConstraintDrawComponent'Default__RB_HingeActor.MyConDrawComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: RB_ConstraintDrawComponent'Default__RB_ConstraintActor.MyConDrawComponent'
    begin object name="MyConDrawComponent"
    end object
    Components[1]=MyConDrawComponent
    // Reference: ArrowComponent'Default__RB_HingeActor.ArrowComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ArrowComponent0" class=Class'ArrowComponent'
        ArrowColor=(R=255,G=64,B=64,A=255)
    end object
    Components[2]=ArrowComponent0
}