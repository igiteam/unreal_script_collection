class AdvWeap_MP34_Base extends AdvWeap_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    WeaponStatMP_Damage=4
    WeaponStatMP_Firerate=6
    WeaponStatMP_Accuracy=7
    WeaponStatMP_Magazines=6
    WeaponStatMP_ReloadSpeed=3
    EWeaponType=WeaponType.TYPE_SMG
    FlashlightBaseSpotlightOffset=(X=4.6008000,Y=-11.9138000,Z=-23.7903000)
    FlashlightBaseSpotlightRotOffset=(Pitch=-41,Yaw=227,Roll=0)
    FlashlightAimingSpotlightOffset=(X=2.5049000,Y=-7.1293000,Z=-15.3679000)
    FlashlightAimingSpotlightRotOffset=(Pitch=-184,Yaw=-40,Roll=0)
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
    ShotSpreadBackSpeed=7.0000000
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_MP34_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    AmmoPickupString="MP-34 Ammo"
    ReloadTime=2.6660000
    InventoryGroup=2
    ZoomedTargetFOV=55.0000000
    ZoomedMeshTranslation=(X=-25.3822000,Y=-8.3977000,Z=0.7473000)
    ZoomedMeshRotation=(Pitch=37,Yaw=329,Roll=676)
    ZoomedMeshScale=2.0000000
    DOF_FocusDistance=60.0000000
    GroupWeight=0.3000000
    // Reference: AudioComponent'Default__AdvWeap_MP34_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_MP34_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    RecoilDelta=150.0000000
    WeaponName="MP34"
    PlayerViewOffset=(X=0.0000000,Y=3.0624000,Z=-1.4311000)
    PlayerRotationOffset=(Pitch=-654,Yaw=-273,Roll=-546)
    CurrentRating=0.3500000
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.6000000
    PutDownTime=0.6000000
    bInstantHit=true
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_MP34_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.3000000
    ItemName="MP-34"
    MaxDesireability=0.3000000
    // Reference: SkeletalMeshComponent'Default__AdvWeap_MP34_Base.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}