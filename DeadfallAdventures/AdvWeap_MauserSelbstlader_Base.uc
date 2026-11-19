class AdvWeap_MauserSelbstlader_Base extends AdvWeap_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    WeaponStatMP_Firerate=6
    WeaponStatMP_ReloadSpeed=6
    EWeaponType=WeaponType.TYPE_AutomaticRifle
    FlashlightBaseSpotlightOffset=(X=-13.9507000,Y=-25.7360000,Z=-11.7621000)
    FlashlightBaseSpotlightRotOffset=(Pitch=-714,Yaw=180,Roll=-1745)
    FlashlightAimingSpotlightOffset=(X=-14.2370000,Y=-17.3774000,Z=-14.4054000)
    FlashlightAimingSpotlightRotOffset=(Pitch=-657,Yaw=36,Roll=-403)
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
    ShotSpreadBackSpeed=9.0000000
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_MauserSelbstlader_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    AmmoPickupString="Selbstlader Ammo"
    ReloadTime=1.8330000
    InventoryGroup=2
    ZoomedMeshTranslation=(X=-37.1262000,Y=-15.7793000,Z=7.8183000)
    ZoomedMeshRotation=(Pitch=-47,Yaw=324,Roll=-425)
    ZoomedMeshScale=2.0000000
    DOF_FocusDistance=60.0000000
    GroupWeight=0.4500000
    // Reference: AudioComponent'Default__AdvWeap_MauserSelbstlader_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_MauserSelbstlader_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    RecoilDelta=400.0000000
    WeaponName="Mauser Selbstlader"
    PlayerViewOffset=(X=18.5308000,Y=11.8334000,Z=-6.9642000)
    PlayerRotationOffset=(Pitch=-534,Yaw=-323,Roll=454)
    CurrentRating=0.4500000
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.4000000
    PutDownTime=0.4000000
    bInstantHit=true
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_MauserSelbstlader_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.4500000
    ItemName="Selbstlader"
    MaxDesireability=0.4500000
    // Reference: SkeletalMeshComponent'Default__AdvWeap_MauserSelbstlader_Base.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}