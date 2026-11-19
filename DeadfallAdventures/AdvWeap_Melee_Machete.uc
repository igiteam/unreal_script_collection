class AdvWeap_Melee_Machete extends EvilWeap_Melee_Base
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    bIsSwitchableAsMelee=true
    bIgnoreAimDot=true
    LockerAmmoCount=99
    WeaponDamage=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    FireCameraAnim=/* Array type was not detected. */
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_Melee_Machete.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    InventoryGroup=20
    AttachmentClass=Class'AdvAttachment_Weap_Melee_Machete'
    ArmsAnimSet=AnimSet'sk_wp_machete_01.Anim.as_wp_machete_hands'
    // Reference: AudioComponent'Default__AdvWeap_Melee_Machete.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    WeaponFireSnd=/* Array type was not detected. */
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_Melee_Machete.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    AmmoCount=99
    InstantHitDamageTypes=/* Array type was not detected. */
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_Melee_Machete.FirstPersonMesh'
    begin object name=FirstPersonMesh
        SkeletalMesh=SkeletalMesh'sk_wp_machete_01.Mesh.sk_wp_machete_01'
        Animations=AnimNodeSequence'Default__AdvWeap_Melee_Machete.MeshSequenceA'
        AnimSets[0]=AnimSet'sk_wp_machete_01.Anim.as_wp_machete_01'
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    // Reference: SkeletalMeshComponent'Default__AdvWeap_Melee_Machete.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}