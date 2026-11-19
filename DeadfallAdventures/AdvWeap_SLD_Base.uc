class AdvWeap_SLD_Base extends AdvWeap_Pistol_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

simulated function HandleFinishedFiring()
{
    StopFire(CurrentFireMode);
    super(EvilWeap_Base).HandleFinishedFiring();
    //return;    
}

defaultproperties
{
    WeaponStatMP_Damage=4
    WeaponStatMP_Firerate=3
    WeaponStatMP_Accuracy=3
    WeaponStatMP_Magazines=2
    WeaponStatMP_ReloadSpeed=7
    EWeaponType=WeaponType.TYPE_AutomaticPistol
    DefaultAmmoCount=15
    MaxAmmoCount=15
    MaxAmmoCountSurvivalMultiplier=1.0000000
    MagazineAmmoCount=2
    MagazineMaxAmmoCount=2
    WeaponHitRange=1100.0000000
    WeaponDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    WeaponCloseDamageMaxMultiplier=2.0000000
    WeaponCloseDamageDistance=100.0000000
    NumberOfShots=/* Array type was not detected. */
    WeaponSpread=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    ShotSpreadBackSpeed=1.0000000
    MoveSpreadMultiplier=1.1000000
    SprintSpreadMultiplier=1.2000000
    JumpSpreadMultiplier=1.5000000
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_SLD_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    AmmoPickupString="SLD Shells"
    ReloadTime=1.7000000
    InventoryGroup=1
    ZoomedRate=120.0000000
    ZoomingTranslationRate=13.0000000
    ZoomedMeshTranslation=(X=-6.2599000,Y=-11.7406000,Z=13.9290000)
    ZoomedMeshRotation=(Pitch=-319,Yaw=964,Roll=-2915)
    ZoomedMeshScale=1.7963000
    ZoomedSpreadMult=1.0000000
    DOF_FocusDistance=60.0000000
    GroupWeight=0.5000000
    // Reference: AudioComponent'Default__AdvWeap_SLD_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_SLD_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    RecoilDelta=100.0000000
    WeaponName="SLD"
    CrouchAnimTime=1.0420000
    StandUpAnimTime=1.0420000
    SprintAnimTime=1.0000000
    PlayerViewOffset=(X=31.0690000,Y=19.2592000,Z=-23.9566000)
    PlayerRotationOffset=(Pitch=-242,Yaw=-567,Roll=-1376)
    CurrentRating=0.3000000
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.3300000
    PutDownTime=0.3300000
    bInstantHit=true
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_SLD_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    ItemName="SLD"
    // Reference: SkeletalMeshComponent'Default__AdvWeap_SLD_Base.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}