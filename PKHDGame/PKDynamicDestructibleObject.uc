class PKDynamicDestructibleObject extends EvilDynamicDestructibleObject
    hidecategories(Navigation);

defaultproperties
{
    // Reference: StaticMeshComponent'Default__PKDynamicDestructibleObject.StaticMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'StaticMeshComponent0'
    // Archetype: StaticMeshComponent'EvilGame.Default__EvilDynamicDestructibleObject.StaticMeshComponent0'
    begin object name="StaticMeshComponent0"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__PKDynamicDestructibleObject.MyLightEnvironment'
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: SkeletalMeshComponent'Default__PKDynamicDestructibleObject.SkeletalMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'SkeletalMeshComponent0'
    // Archetype: SkeletalMeshComponent'EvilGame.Default__EvilDynamicDestructibleObject.SkeletalMeshComponent0'
    begin object name="SkeletalMeshComponent0"
        // Reference: AnimNodeSequence'Default__PKDynamicDestructibleObject.SkeletalMeshComponent0.AnimNodeSeq0'
        // Archetype: AnimNodeSequence'EvilGame.Default__EvilDynamicDestructibleObject.AnimNodeSeq0'
        begin object name="AnimNodeSeq0"
        end object
        Animations=AnimNodeSeq0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__PKDynamicDestructibleObject.MyLightEnvironment'
    end object
    SkeletalMeshComponent=SkeletalMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__PKDynamicDestructibleObject.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'EvilGame.Default__EvilDynamicDestructibleObject.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: RB_RadialImpulseComponent'Default__PKDynamicDestructibleObject.ImpulseComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ImpulseComponent0'
    // Archetype: RB_RadialImpulseComponent'EvilGame.Default__EvilDynamicDestructibleObject.ImpulseComponent0'
    begin object name="ImpulseComponent0"
        ReplacementPrimitive=none
    end object
    RadialImpulseComponent=ImpulseComponent0
    // Reference: SpriteComponent'Default__PKDynamicDestructibleObject.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'Sprite'
    // Archetype: SpriteComponent'EvilGame.Default__EvilDynamicDestructibleObject.Sprite'
    begin object name="Sprite"
        ReplacementPrimitive=none
    end object
    Components[0]=Sprite
    Components[1]=MyLightEnvironment
    Components[2]=SkeletalMeshComponent0
    Components[3]=StaticMeshComponent0
    CollisionComponent=StaticMeshComponent0
}