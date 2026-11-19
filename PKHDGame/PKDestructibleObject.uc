class PKDestructibleObject extends EvilDestructibleObject
    hidecategories(Navigation);

defaultproperties
{
    // Reference: AudioComponent'Default__PKDestructibleObject.AmbientSoundComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'AmbientSoundComponent0'
    // Archetype: AudioComponent'EvilGame.Default__EvilDestructibleObject.AmbientSoundComponent0'
    begin object name="AmbientSoundComponent0"
    end object
    AmbientSoundComponent=AmbientSoundComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__PKDestructibleObject.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'EvilGame.Default__EvilDestructibleObject.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: DynamicLightEnvironmentComponent'Default__PKDestructibleObject.MyLightEnvironment2'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment2'
    // Archetype: DynamicLightEnvironmentComponent'EvilGame.Default__EvilDestructibleObject.MyLightEnvironment2'
    begin object name="MyLightEnvironment2"
    end object
    LightEnvironmentToUseForActorSpawnParams=MyLightEnvironment2
}