class AdvWeap_Suomi_Base extends AdvWeap_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    bPurchasedWeaponDLC=false
    WeaponStatMP_Damage=3
    WeaponStatMP_Firerate=9
    WeaponStatMP_Accuracy=8
    WeaponStatMP_Magazines=9
    WeaponStatMP_ReloadSpeed=3
    EWeaponType=WeaponType.TYPE_SMG
    FlashlightBaseSpotlightOffset=(X=-20.0787000,Y=-12.8267000,Z=-23.3171000)
    FlashlightBaseSpotlightRotOffset=(Pitch=-165,Yaw=158,Roll=67)
    FlashlightAimingSpotlightOffset=(X=-27.2673000,Y=-8.5472000,Z=-18.1762000)
    FlashlightAimingSpotlightRotOffset=(Pitch=-382,Yaw=53,Roll=67)
    BothHandWeapon=true
    bFastRepeater=true
    DefaultAmmoCount=160
    MaxAmmoCount=160
    MagazineAmmoCount=40
    MagazineMaxAmmoCount=40
    WeaponHitRange=4000.0000000
    WeaponDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    WeaponCloseDamageMaxMultiplier=2.0000000
    WeaponCloseDamageDistance=100.0000000
    WeaponSpread=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    ShotSpreadModifier=0.1000000
    ShotSpreadBackSpeed=5.0000000
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_Suomi_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    AmmoPickupString="Suomi Ammo"
    ReloadTime=2.6000000
    InventoryGroup=2
    ZoomedRate=120.0000000
    ZoomingTranslationRate=13.0000000
    ZoomedMeshTranslation=(X=-9.3428000,Y=-6.5381000,Z=-0.7202000)
    ZoomedMeshRotation=(Pitch=83,Yaw=102,Roll=-461)
    ZoomedMeshScale=2.0000000
    ZoomedSpreadMult=0.8000000
    DOF_FocusDistance=60.0000000
    GroupWeight=0.4500000
    // Reference: AudioComponent'Default__AdvWeap_Suomi_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_Suomi_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    BackForceVector=(X=-2.4000000,Y=0.4400000,Z=0.0000000)
    BackForceMax=(X=15.0000000,Y=1.0000000,Z=3.0000000)
    RecoilDelta=40.0000000
    RecoilMax=2000.0000000
    WeaponName="Suomi"
    CrouchAnimTime=1.0420000
    StandUpAnimTime=1.0420000
    SprintStartAnimTime=1.2080000
    SprintAnimTime=0.7000000
    PlayerViewOffset=(X=28.0103000,Y=3.1968000,Z=-3.3511000)
    PlayerRotationOffset=(Pitch=-859,Yaw=-108,Roll=454)
    CurrentRating=0.4500000
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=1.0420000
    PutDownTime=0.4000000
    bInstantHit=true
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_Suomi_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.4500000
    ItemName="Suomi"
    MaxDesireability=0.4500000
    // Reference: SkeletalMeshComponent'Default__AdvWeap_Suomi_Base.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}