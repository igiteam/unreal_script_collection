class EvilWeap_Melee_GermanSoldierMelee extends EvilWeap_Melee_HumanMelee
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    AimDot=-1.0000000
    WeaponHitRange=300.0000000
    WeaponDamage[0]=250.0000000
    WeaponDamage[1]=0.0000000
    // Reference: ForceFeedbackWaveform'Default__EvilWeap_Melee_GermanSoldierMelee.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    AttachmentClass=Class'EvilAttachment_Weap_Melee_GermanSoldierMelee'
    // Reference: AudioComponent'Default__EvilWeap_Melee_GermanSoldierMelee.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__EvilWeap_Melee_GermanSoldierMelee.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    InstantHitDamageTypes=/* Array type was not detected. */
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__EvilWeap_Melee_GermanSoldierMelee.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    // Reference: SkeletalMeshComponent'Default__EvilWeap_Melee_GermanSoldierMelee.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}