class PKWeap_Melee_Templar extends EvilWeap_Melee_HumanMelee
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    WeaponHitRange=200.0000000
    WeaponDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    // Reference: ForceFeedbackWaveform'Default__PKWeap_Melee_Templar.ForceFeedbackWaveformShooting1'
    // Archetype: ForceFeedbackWaveform'EvilGame.Default__EvilWeap_Melee_HumanMelee.ForceFeedbackWaveformShooting1'
    begin object name="ForceFeedbackWaveformShooting1"
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    // Reference: AudioComponent'Default__PKWeap_Melee_Templar.ReloadSound'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ReloadSound'
    // Archetype: AudioComponent'EvilGame.Default__EvilWeap_Melee_HumanMelee.ReloadSound'
    begin object name="ReloadSound"
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__PKWeap_Melee_Templar.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'EvilGame.Default__EvilWeap_Melee_HumanMelee.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: UDKSkeletalMeshComponent'Default__PKWeap_Melee_Templar.FirstPersonMesh'
    // Archetype: UDKSkeletalMeshComponent'EvilGame.Default__EvilWeap_Melee_HumanMelee.FirstPersonMesh'
    begin object name="FirstPersonMesh"
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    // Reference: SkeletalMeshComponent'Default__PKWeap_Melee_Templar.PickupMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PickupMesh'
    // Archetype: SkeletalMeshComponent'EvilGame.Default__EvilWeap_Melee_HumanMelee.PickupMesh'
    begin object name="PickupMesh"
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}