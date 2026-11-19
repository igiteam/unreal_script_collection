class AdvWeap_GEW06P_Base extends AdvWeap_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

var export editinline UDKSkeletalMeshComponent SkeletonFirstPersonMesh;
var() array<float> FireIntervalLast;
var(Animations) array<name> WeaponFireAnimLast;
var(Animations) array<name> ArmFireAnimLast;
var array<CameraAnim> FireCameraAnimLast;
var(Sounds) array<SoundCue> WeaponFireSndLast;
var transient bool bShowCrosshairZoom;
var MaterialInterface CrosshairZoomMat;

simulated function bool ShouldRefire()
{
    return false;
    //return ReturnValue;    
}

simulated function HandleFinishedFiring()
{
    StopFire(CurrentFireMode);
    super(EvilWeap_Base).HandleFinishedFiring();
    //return;    
}

simulated state WeaponFiring
{
    simulated function BeginFire(byte FireModeNum)
    {
        // End:0x18
        if(CheckZoom(FireModeNum))
        {
            return;
        }
        global.BeginFire(FireModeNum);
        // End:0x6D
        if(!HasShareAmmo(FireModeNum) && int(FireModeNum) == int(CurrentFireMode))
        {
            WeaponEmpty();
            return;
        }
        // End:0xC5
        if(((int(FireModeNum) == int(1)) || int(FireModeNum) != int(CurrentFireMode)) || MagazineAmmoCount < ShotCost[int(FireModeNum)])
        {
            return;
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    FireIntervalLast[0]=0.4100000
    bPurchasedWeaponDLC=false
    WeaponStatMP_Damage=8
    WeaponStatMP_Firerate=4
    WeaponStatMP_Accuracy=7
    WeaponStatMP_Magazines=4
    WeaponStatMP_ReloadSpeed=2
    EWeaponType=WeaponType.TYPE_Rifle
    FlashlightBaseSpotlightOffset=(X=-5.0000000,Y=-16.0000000,Z=-25.0000000)
    FlashlightBaseSpotlightRotOffset=(Pitch=-250,Yaw=700,Roll=0)
    FlashlightAimingSpotlightOffset=(X=-5.0000000,Y=-25.0000000,Z=-8.0000000)
    FlashlightAimingSpotlightRotOffset=(Pitch=-600,Yaw=700,Roll=0)
    BothHandWeapon=true
    DefaultAmmoCount=60
    MaxAmmoCount=60
    MagazineAmmoCount=5
    MagazineMaxAmmoCount=5
    WeaponHitRange=14000.0000000
    WeaponDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    WeaponCloseDamageDistance=100.0000000
    WeaponSpread=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    MoveSpreadMultiplier=1.1000000
    SprintSpreadMultiplier=1.2000000
    JumpSpreadMultiplier=1.5000000
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_GEW06P_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    AmmoPickupString="Gew06 P Ammo"
    ReloadTime=1.8330000
    InventoryGroup=2
    ZoomedMeshTranslation=(X=-37.1262000,Y=-15.7293000,Z=9.6683000)
    ZoomedMeshRotation=(Pitch=-452,Yaw=344,Roll=-425)
    ZoomedMeshScale=2.0000000
    DOF_FocusDistance=60.0000000
    GroupWeight=0.3500000
    // Reference: AudioComponent'Default__AdvWeap_GEW06P_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_GEW06P_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    WeaponName="GEW06 P"
    PlayerViewOffset=(X=18.5308000,Y=11.8334000,Z=-6.9642000)
    PlayerRotationOffset=(Pitch=-534,Yaw=-323,Roll=454)
    CurrentRating=0.3500000
    AimingHelpRadius=/* Array type was not detected. */
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.4000000
    PutDownTime=0.4000000
    bInstantHit=true
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_GEW06P_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.3500000
    ItemName="Gew06 P"
    MaxDesireability=0.3500000
    // Reference: SkeletalMeshComponent'Default__AdvWeap_GEW06P_Base.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}