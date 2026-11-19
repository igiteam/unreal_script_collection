class RB_PrismaticActor extends RB_ConstraintActor
    placeable
    hidecategories(lighting);

defaultproperties
{
    // Reference: RB_PrismaticSetup'Default__RB_PrismaticActor.MyPrismaticSetup'
    begin object name="MyPrismaticSetup" class=Class'RB_PrismaticSetup'
    end object
    ConstraintSetup=MyPrismaticSetup
    // Reference: SpriteComponent'Default__RB_PrismaticActor.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__RB_ConstraintActor.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'EngineResources.S_KPrismatic'
    end object
    Components[0]=Sprite
    // Reference: RB_ConstraintDrawComponent'Default__RB_PrismaticActor.MyConDrawComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: RB_ConstraintDrawComponent'Default__RB_ConstraintActor.MyConDrawComponent'
    begin object name="MyConDrawComponent"
    end object
    Components[1]=MyConDrawComponent
    // Reference: ArrowComponent'Default__RB_PrismaticActor.ArrowComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ArrowComponent0" class=Class'ArrowComponent'
        ArrowColor=(R=255,G=64,B=64,A=255)
    end object
    Components[2]=ArrowComponent0
}