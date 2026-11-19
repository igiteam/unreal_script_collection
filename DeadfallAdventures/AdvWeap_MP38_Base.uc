class AdvWeap_MP38_Base extends AdvWeap_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    WeaponStatMP_Damage=4
    WeaponStatMP_Firerate=7
    WeaponStatMP_Accuracy=7
    WeaponStatMP_Magazines=6
    WeaponStatMP_ReloadSpeed=7
    EWeaponType=WeaponType.TYPE_SMG
    FlashlightBaseSpotlightOffset=(X=-11.4944000,Y=-15.7475000,Z=-22.1023000)
    FlashlightBaseSpotlightRotOffset=(Pitch=-301,Yaw=444,Roll=0)
    FlashlightAimingSpotlightOffset=(X=-15.6199000,Y=-10.0834000,Z=-17.7011000)
    FlashlightAimingSpotlightRotOffset=(Pitch=-111,Yaw=45,Roll=0)
    BothHandWeapon=true
    bFastRepeater=true
    DefaultAmmoCount=160
    MaxAmmoCount=160
    MagazineAmmoCount=32
    MagazineMaxAmmoCount=32
    WeaponHitRange=4000.0000000
    WeaponDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    WeaponSpread=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    ShotSpreadModifier=0.0800000
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_MP38_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    AmmoPickupString="MP-38 Ammo"
    ReloadTime=2.3670000
    InventoryGroup=2
    ZoomedRate=120.0000000
    ZoomingTranslationRate=13.0000000
    ZoomedMeshTranslation=(X=-28.8317000,Y=-14.1938000,Z=1.3536000)
    ZoomedMeshRotation=(Pitch=-212,Yaw=109,Roll=-341)
    ZoomedMeshScale=2.0000000
    ZoomedSpreadMult=0.1000000
    DOF_FocusDistance=60.0000000
    GroupWeight=0.4500000
    // Reference: AudioComponent'Default__AdvWeap_MP38_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_MP38_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    BackForceVector=(X=-2.4000000,Y=0.4400000,Z=0.0000000)
    BackForceMax=(X=15.0000000,Y=1.0000000,Z=3.0000000)
    RecoilDelta=40.0000000
    WeaponName="MP38"
    CrouchAnimTime=0.8000000
    StandUpAnimTime=1.2000000
    SprintStartAnimTime=0.9000000
    SprintAnimTime=0.7000000
    PlayerViewOffset=(X=18.5308000,Y=8.9512000,Z=-4.2415000)
    PlayerRotationOffset=(Pitch=-534,Yaw=-138,Roll=454)
    CurrentRating=0.4500000
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.4000000
    PutDownTime=0.4000000
    bInstantHit=true
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_MP38_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.4500000
    ItemName="MP-38"
    MaxDesireability=0.4500000
    // Reference: SkeletalMeshComponent'Default__AdvWeap_MP38_Base.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}