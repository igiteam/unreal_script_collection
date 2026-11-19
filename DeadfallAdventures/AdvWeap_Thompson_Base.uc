class AdvWeap_Thompson_Base extends AdvWeap_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    WeaponStatMP_Firerate=6
    WeaponStatMP_Accuracy=7
    WeaponStatMP_Magazines=8
    WeaponStatMP_ReloadSpeed=3
    EWeaponType=WeaponType.TYPE_SMG
    FlashlightBaseSpotlightOffset=(X=-39.2016000,Y=-27.3277000,Z=-22.1828000)
    FlashlightBaseSpotlightRotOffset=(Pitch=-120,Yaw=180,Roll=0)
    FlashlightAimingSpotlightOffset=(X=-39.2016000,Y=-20.8103000,Z=-26.0618000)
    FlashlightAimingSpotlightRotOffset=(Pitch=-71,Yaw=-20,Roll=0)
    BothHandWeapon=true
    bFastRepeater=true
    DefaultAmmoCount=150
    MaxAmmoCount=150
    MagazineAmmoCount=50
    MagazineMaxAmmoCount=50
    WeaponHitRange=4000.0000000
    WeaponDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    WeaponSpread=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    ShotSpreadModifier=0.2000000
    ShotSpreadBackSpeed=5.0000000
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_Thompson_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    AmmoPickupString="Thompson Ammo"
    ReloadTime=2.5000000
    InventoryGroup=2
    ZoomedRate=120.0000000
    ZoomingTranslationRate=13.0000000
    ZoomedMeshTranslation=(X=-28.2660000,Y=-12.2709000,Z=6.8295000)
    ZoomedMeshRotation=(Pitch=-125,Yaw=223,Roll=305)
    ZoomedMeshScale=2.0000000
    ZoomedSpreadMult=0.6000000
    DOF_FocusDistance=60.0000000
    GroupWeight=0.5500000
    // Reference: AudioComponent'Default__AdvWeap_Thompson_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_Thompson_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    BackForceVector=(X=-2.4000000,Y=0.4400000,Z=0.0000000)
    BackForceMax=(X=15.0000000,Y=1.0000000,Z=3.0000000)
    RecoilDelta=20.0000000
    RecoilMax=2000.0000000
    WeaponName="Thompson"
    CrouchAnimTime=1.0420000
    StandUpAnimTime=1.0420000
    SprintStartAnimTime=1.2080000
    SprintAnimTime=0.7000000
    PlayerViewOffset=(X=43.6278000,Y=7.0205000,Z=-4.3915000)
    PlayerRotationOffset=(Pitch=-729,Yaw=-238,Roll=-234)
    CurrentRating=0.5500000
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.4000000
    PutDownTime=0.4000000
    bInstantHit=true
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_Thompson_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.5500000
    ItemName="Thompson"
    MaxDesireability=0.5500000
    // Reference: SkeletalMeshComponent'Default__AdvWeap_Thompson_Base.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}