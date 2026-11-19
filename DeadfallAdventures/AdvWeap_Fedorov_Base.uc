class AdvWeap_Fedorov_Base extends AdvWeap_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    WeaponStatMP_Damage=6
    WeaponStatMP_ReloadSpeed=2
    WeaponStatMP_RunFriendly=4
    EWeaponType=WeaponType.TYPE_AutomaticRifle
    FlashlightBaseSpotlightOffset=(X=-15.4304000,Y=-25.7407000,Z=-10.7080000)
    FlashlightBaseSpotlightRotOffset=(Pitch=-191,Yaw=515,Roll=0)
    FlashlightAimingSpotlightOffset=(X=-12.3680000,Y=-17.1287000,Z=-12.6102000)
    FlashlightAimingSpotlightRotOffset=(Pitch=-203,Yaw=-5,Roll=0)
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
    ShotSpreadModifier=0.0800000
    ShotSpreadBackSpeed=7.0000000
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_Fedorov_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    AmmoPickupString="Fedorov Ammo"
    ReloadTime=2.8750000
    InventoryGroup=2
    ZoomedTargetFOV=50.0000000
    ZoomedRate=120.0000000
    ZoomingTranslationRate=13.0000000
    ZoomedMeshTranslation=(X=-36.0759000,Y=-17.9458000,Z=7.4682000)
    ZoomedMeshRotation=(Pitch=-127,Yaw=534,Roll=-271)
    ZoomedMeshScale=2.0000000
    ZoomedSpreadMult=0.1000000
    DOF_FocusDistance=60.0000000
    GroupWeight=0.4500000
    // Reference: AudioComponent'Default__AdvWeap_Fedorov_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_Fedorov_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    BackForceVector=(X=-2.4000000,Y=0.4400000,Z=0.0000000)
    BackForceMax=(X=15.0000000,Y=1.0000000,Z=3.0000000)
    RecoilDelta=50.0000000
    WeaponName="Fedorov"
    CrouchAnimTime=0.8000000
    StandUpAnimTime=1.2000000
    SprintStartAnimTime=0.9000000
    SprintAnimTime=0.7000000
    PlayerViewOffset=(X=18.5308000,Y=11.8334000,Z=-6.9642000)
    PlayerRotationOffset=(Pitch=-534,Yaw=-508,Roll=454)
    CurrentRating=0.4500000
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=1.0000000
    PutDownTime=0.4000000
    bInstantHit=true
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_Fedorov_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.4500000
    ItemName="Fedorov"
    MaxDesireability=0.4500000
    // Reference: SkeletalMeshComponent'Default__AdvWeap_Fedorov_Base.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}