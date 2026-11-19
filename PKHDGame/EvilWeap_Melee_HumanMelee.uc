class EvilWeap_Melee_HumanMelee extends EvilWeap_Melee_Base
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    // Reference: ForceFeedbackWaveform'Default__EvilWeap_Melee_HumanMelee.ForceFeedbackWaveformShooting1'
    // Archetype: ForceFeedbackWaveform'Default__EvilWeap_Melee_Base.ForceFeedbackWaveformShooting1'
    begin object name="ForceFeedbackWaveformShooting1"
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    // Reference: AudioComponent'Default__EvilWeap_Melee_HumanMelee.ReloadSound'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ReloadSound'
    // Archetype: AudioComponent'Default__EvilWeap_Melee_Base.ReloadSound'
    begin object name="ReloadSound"
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__EvilWeap_Melee_HumanMelee.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__EvilWeap_Melee_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: UDKSkeletalMeshComponent'Default__EvilWeap_Melee_HumanMelee.FirstPersonMesh'
    // Archetype: UDKSkeletalMeshComponent'Default__EvilWeap_Melee_Base.FirstPersonMesh'
    begin object name="FirstPersonMesh"
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    // Reference: SkeletalMeshComponent'Default__EvilWeap_Melee_HumanMelee.PickupMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PickupMesh'
    // Archetype: SkeletalMeshComponent'Default__EvilWeap_Melee_Base.PickupMesh'
    begin object name="PickupMesh"
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}