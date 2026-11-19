class EvilWeap_Melee_ZimmermanMelee extends EvilWeap_Melee_HumanMelee
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    WeaponDamage[0]=666.0000000
    WeaponDamage[1]=0.0000000
    WeaponMomentum[0]=100.0000000
    WeaponMomentum[1]=100.0000000
    // Reference: ForceFeedbackWaveform'Default__EvilWeap_Melee_ZimmermanMelee.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    // Reference: AudioComponent'Default__EvilWeap_Melee_ZimmermanMelee.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__EvilWeap_Melee_ZimmermanMelee.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__EvilWeap_Melee_ZimmermanMelee.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    // Reference: SkeletalMeshComponent'Default__EvilWeap_Melee_ZimmermanMelee.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}