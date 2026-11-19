class EvilWeap_Melee_PolarBearMelee extends EvilWeap_Melee_Base
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    ForceTossZ=1.0000000
    ForceTossZPhys=100.0000000
    bSelectable=true
    WeaponHitRange=400.0000000
    WeaponDamage=/* Array type was not detected. */
    // Reference: ForceFeedbackWaveform'Default__EvilWeap_Melee_PolarBearMelee.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    // Reference: AudioComponent'Default__EvilWeap_Melee_PolarBearMelee.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__EvilWeap_Melee_PolarBearMelee.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__EvilWeap_Melee_PolarBearMelee.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    // Reference: SkeletalMeshComponent'Default__EvilWeap_Melee_PolarBearMelee.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}