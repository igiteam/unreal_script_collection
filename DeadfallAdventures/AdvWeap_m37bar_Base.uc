class AdvWeap_m37bar_Base extends AdvWeap_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    WeaponStatMP_Damage=6
    WeaponStatMP_ReloadSpeed=2
    EWeaponType=WeaponType.TYPE_HMG
    FlashlightBaseSpotlightOffset=(X=5.3885000,Y=-13.9994000,Z=-27.8476000)
    FlashlightBaseSpotlightRotOffset=(Pitch=-133,Yaw=455,Roll=0)
    FlashlightAimingSpotlightOffset=(X=0.0000000,Y=-16.7570000,Z=-15.3781000)
    FlashlightAimingSpotlightRotOffset=(Pitch=-89,Yaw=-19,Roll=0)
    BothHandWeapon=true
    bFastRepeater=true
    DefaultAmmoCount=150
    MaxAmmoCount=150
    MagazineAmmoCount=30
    MagazineMaxAmmoCount=30
    WeaponDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    WeaponSpread=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_m37bar_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    AmmoPickupString="m37 bar Ammo"
    ReloadTime=2.8750000
    InventoryGroup=2
    ZoomedTargetFOV=50.0000000
    ZoomedMeshTranslation=(X=-36.0759000,Y=-17.9458000,Z=7.4682000)
    ZoomedMeshRotation=(Pitch=-127,Yaw=534,Roll=-271)
    ZoomedMeshScale=2.0000000
    DOF_FocusDistance=60.0000000
    GroupWeight=0.4500000
    // Reference: AudioComponent'Default__AdvWeap_m37bar_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_m37bar_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    WeaponName="M37Bar"
    PlayerViewOffset=(X=18.5308000,Y=11.8334000,Z=-6.9642000)
    PlayerRotationOffset=(Pitch=-534,Yaw=-508,Roll=454)
    CurrentRating=0.4500000
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.4000000
    PutDownTime=0.4000000
    bInstantHit=true
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_m37bar_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.4500000
    ItemName="m37 bar"
    MaxDesireability=0.4500000
    // Reference: SkeletalMeshComponent'Default__AdvWeap_m37bar_Base.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}