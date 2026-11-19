class PKDO_Alastor_Base extends PKDestructibleObject
    abstract
    hidecategories(Navigation);

defaultproperties
{
    bLimitDamageTypes=true
    // Reference: AudioComponent'Default__PKDO_Alastor_Base.AmbientSoundComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'AmbientSoundComponent0'
    // Archetype: AudioComponent'Default__PKDestructibleObject.AmbientSoundComponent0'
    begin object name="AmbientSoundComponent0"
    end object
    AmbientSoundComponent=AmbientSoundComponent0
    VulnerableToDamageType=/* Array type was not detected. */
    // Reference: DynamicLightEnvironmentComponent'Default__PKDO_Alastor_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PKDestructibleObject.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: DynamicLightEnvironmentComponent'Default__PKDO_Alastor_Base.MyLightEnvironment2'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment2'
    // Archetype: DynamicLightEnvironmentComponent'Default__PKDestructibleObject.MyLightEnvironment2'
    begin object name="MyLightEnvironment2"
    end object
    LightEnvironmentToUseForActorSpawnParams=MyLightEnvironment2
}