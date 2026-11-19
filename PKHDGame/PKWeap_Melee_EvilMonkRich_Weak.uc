class PKWeap_Melee_EvilMonkRich_Weak extends PKWeap_Melee_EvilMonkRich
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    // Reference: ForceFeedbackWaveform'Default__PKWeap_Melee_EvilMonkRich_Weak.ForceFeedbackWaveformShooting1'
    // Archetype: ForceFeedbackWaveform'Default__PKWeap_Melee_EvilMonkRich.ForceFeedbackWaveformShooting1'
    begin object name="ForceFeedbackWaveformShooting1"
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    // Reference: AudioComponent'Default__PKWeap_Melee_EvilMonkRich_Weak.ReloadSound'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ReloadSound'
    // Archetype: AudioComponent'Default__PKWeap_Melee_EvilMonkRich.ReloadSound'
    begin object name="ReloadSound"
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__PKWeap_Melee_EvilMonkRich_Weak.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PKWeap_Melee_EvilMonkRich.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: UDKSkeletalMeshComponent'Default__PKWeap_Melee_EvilMonkRich_Weak.FirstPersonMesh'
    // Archetype: UDKSkeletalMeshComponent'Default__PKWeap_Melee_EvilMonkRich.FirstPersonMesh'
    begin object name="FirstPersonMesh"
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    // Reference: SkeletalMeshComponent'Default__PKWeap_Melee_EvilMonkRich_Weak.PickupMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PickupMesh'
    // Archetype: SkeletalMeshComponent'Default__PKWeap_Melee_EvilMonkRich.PickupMesh'
    begin object name="PickupMesh"
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}