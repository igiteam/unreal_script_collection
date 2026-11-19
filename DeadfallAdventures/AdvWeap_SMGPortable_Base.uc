class AdvWeap_SMGPortable_Base extends AdvWeap_Pistol_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    EWeaponType=WeaponType.TYPE_Special
    ZoomedCrosshair=true
    bFastRepeater=true
    DefaultAmmoCount=200
    MaxAmmoCount=200
    MagazineAmmoCount=20
    MagazineMaxAmmoCount=20
    WeaponDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    WeaponSpread=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_SMGPortable_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    AmmoPickupString="SMG Portable Ammo"
    ReloadTime=2.5000000
    InventoryGroup=2
    ZoomedMeshTranslation=(X=0.0000000,Y=-5.0000000,Z=0.0000000)
    DOF_FocusDistance=60.0000000
    GroupWeight=0.5000000
    // Reference: AudioComponent'Default__AdvWeap_SMGPortable_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_SMGPortable_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    WeaponName="SMGPortable"
    PlayerViewOffset=(X=16.0000000,Y=6.0000000,Z=-6.0000000)
    PlayerRotationOffset=(Pitch=0,Yaw=-910,Roll=364)
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.5000000
    PutDownTime=0.5000000
    bInstantHit=true
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_SMGPortable_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    ItemName="SMG Portable"
    // Reference: SkeletalMeshComponent'Default__AdvWeap_SMGPortable_Base.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}