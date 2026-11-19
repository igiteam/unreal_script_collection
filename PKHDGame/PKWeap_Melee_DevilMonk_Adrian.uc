class PKWeap_Melee_DevilMonk_Adrian extends PKWeap_Melee_DevilMonk
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    WeaponHitRange=180.0000000
    WeaponDamage=/* Array type was not detected. */
    // Reference: ForceFeedbackWaveform'Default__PKWeap_Melee_DevilMonk_Adrian.ForceFeedbackWaveformShooting1'
    // Archetype: ForceFeedbackWaveform'Default__PKWeap_Melee_DevilMonk.ForceFeedbackWaveformShooting1'
    begin object name="ForceFeedbackWaveformShooting1"
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    // Reference: AudioComponent'Default__PKWeap_Melee_DevilMonk_Adrian.ReloadSound'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ReloadSound'
    // Archetype: AudioComponent'Default__PKWeap_Melee_DevilMonk.ReloadSound'
    begin object name="ReloadSound"
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__PKWeap_Melee_DevilMonk_Adrian.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PKWeap_Melee_DevilMonk.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: UDKSkeletalMeshComponent'Default__PKWeap_Melee_DevilMonk_Adrian.FirstPersonMesh'
    // Archetype: UDKSkeletalMeshComponent'Default__PKWeap_Melee_DevilMonk.FirstPersonMesh'
    begin object name="FirstPersonMesh"
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    // Reference: SkeletalMeshComponent'Default__PKWeap_Melee_DevilMonk_Adrian.PickupMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PickupMesh'
    // Archetype: SkeletalMeshComponent'Default__PKWeap_Melee_DevilMonk.PickupMesh'
    begin object name="PickupMesh"
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}