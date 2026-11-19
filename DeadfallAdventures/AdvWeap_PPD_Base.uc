class AdvWeap_PPD_Base extends AdvWeap_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    WeaponStatMP_Damage=2
    WeaponStatMP_Firerate=9
    WeaponStatMP_Accuracy=7
    WeaponStatMP_Magazines=7
    WeaponStatMP_ReloadSpeed=3
    EWeaponType=WeaponType.TYPE_SMG
    FlashlightBaseSpotlightOffset=(X=-10.0000000,Y=-11.0000000,Z=-30.0000000)
    FlashlightBaseSpotlightRotOffset=(Pitch=-800,Yaw=850,Roll=0)
    FlashlightAimingSpotlightOffset=(X=-10.0000000,Y=-11.0000000,Z=-14.0000000)
    FlashlightAimingSpotlightRotOffset=(Pitch=-150,Yaw=100,Roll=0)
    BothHandWeapon=true
    bFastRepeater=true
    DefaultAmmoCount=360
    MaxAmmoCount=360
    MagazineAmmoCount=36
    MagazineMaxAmmoCount=36
    WeaponDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    WeaponSpread=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    ShotSpreadBackSpeed=1.0000000
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_PPD_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    AmmoPickupString="PPD Ammo"
    ReloadTime=2.6000000
    InventoryGroup=2
    ZoomedMeshTranslation=(X=-9.3428000,Y=-6.1049000,Z=-0.6410000)
    ZoomedMeshRotation=(Pitch=-18,Yaw=118,Roll=-461)
    ZoomedMeshScale=2.0000000
    DOF_FocusDistance=60.0000000
    GroupWeight=0.4500000
    // Reference: AudioComponent'Default__AdvWeap_PPD_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_PPD_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    RecoilDelta=300.0000000
    WeaponName="PPD"
    PlayerViewOffset=(X=28.0103000,Y=3.1968000,Z=-3.3511000)
    PlayerRotationOffset=(Pitch=-859,Yaw=-108,Roll=454)
    CurrentRating=0.4500000
    UpgradeModifier_BonusMagazines=1
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.4000000
    PutDownTime=0.4000000
    bInstantHit=true
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_PPD_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.4500000
    ItemName="PPD"
    MaxDesireability=0.4500000
    // Reference: SkeletalMeshComponent'Default__AdvWeap_PPD_Base.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}