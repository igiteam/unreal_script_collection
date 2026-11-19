class AdvWeap_Roth_Base extends AdvWeap_Pistol_Base
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
    WeaponStatMP_Damage=3
    WeaponStatMP_Accuracy=6
    WeaponStatMP_Magazines=6
    WeaponStatMP_ReloadSpeed=4
    EWeaponType=WeaponType.TYPE_Pistol
    DisplayDotCrosshair=true
    ZoomedCrosshair=true
    DefaultAmmoCount=30
    MaxAmmoCount=30
    MaxAmmoCountSurvivalMultiplier=1.0000000
    MagazineAmmoCount=10
    MagazineMaxAmmoCount=10
    WeaponHitRange=3500.0000000
    WeaponDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    WeaponSpread=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    ShotSpreadModifier=0.0900000
    ShotSpreadBackSpeed=8.0000000
    MoveSpreadMultiplier=1.1000000
    SprintSpreadMultiplier=1.2000000
    JumpSpreadMultiplier=1.5000000
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_Roth_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    AmmoPickupString="M1907 Ammo"
    ReloadTime=2.1000000
    InventoryGroup=1
    ZoomedMeshTranslation=(X=-5.0000000,Y=-6.2642000,Z=2.5943000)
    ZoomedMeshRotation=(Pitch=-305,Yaw=79,Roll=0)
    ZoomedMeshScale=1.3498000
    DOF_FocusDistance=60.0000000
    GroupWeight=0.2100000
    // Reference: AudioComponent'Default__AdvWeap_Roth_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_Roth_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    WeaponName="Roth"
    PlayerViewOffset=(X=45.7889000,Y=7.4669000,Z=-9.9400000)
    PlayerRotationOffset=(Pitch=-226,Yaw=-735,Roll=152)
    CurrentRating=0.2100000
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.3300000
    PutDownTime=0.3300000
    bInstantHit=true
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_Roth_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.2100000
    ItemName="M1907"
    MaxDesireability=0.2100000
    // Reference: SkeletalMeshComponent'Default__AdvWeap_Roth_Base.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}