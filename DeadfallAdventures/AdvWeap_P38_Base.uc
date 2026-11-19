class AdvWeap_P38_Base extends AdvWeap_Pistol_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

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
    bPurchasedWeaponDLC=false
    WeaponStatMP_Damage=3
    WeaponStatMP_Accuracy=6
    WeaponStatMP_Magazines=8
    WeaponStatMP_ReloadSpeed=6
    EWeaponType=WeaponType.TYPE_Pistol
    DisplayDotCrosshair=true
    ZoomedCrosshair=true
    SupportAlternateReload=true
    DefaultAmmoCount=27
    MaxAmmoCount=27
    MaxAmmoCountSurvivalMultiplier=1.0000000
    MagazineAmmoCount=9
    MagazineMaxAmmoCount=9
    WeaponHitRange=3500.0000000
    WeaponDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    WeaponSpread=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    ShotSpreadModifier=0.0900000
    ShotSpreadBackSpeed=5.0000000
    MoveSpreadMultiplier=1.1000000
    SprintSpreadMultiplier=1.2000000
    JumpSpreadMultiplier=1.5000000
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_P38_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    AmmoPickupString="P-38 Ammo"
    ReloadTime=1.8000000
    InventoryGroup=1
    ZoomedMeshTranslation=(X=-5.6250000,Y=-7.7697000,Z=3.9248000)
    ZoomedMeshRotation=(Pitch=-360,Yaw=-36,Roll=0)
    ZoomedMeshScale=1.5689000
    DOF_FocusDistance=60.0000000
    GroupWeight=0.2000000
    // Reference: AudioComponent'Default__AdvWeap_P38_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_P38_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    WeaponName="P38"
    PlayerViewOffset=(X=33.5292000,Y=9.7070000,Z=-7.6999000)
    PlayerRotationOffset=(Pitch=-41,Yaw=-735,Roll=152)
    CurrentRating=0.2000000
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.3300000
    PutDownTime=0.3300000
    bInstantHit=true
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_P38_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.2000000
    ItemName="P-38"
    MaxDesireability=0.2000000
    // Reference: SkeletalMeshComponent'Default__AdvWeap_P38_Base.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}