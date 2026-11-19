class AdvWeap_Bergman_Base extends AdvWeap_Pistol_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

simulated function bool ShouldRefire()
{
    return super(AdvWeap_Base).ShouldRefire();
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
    WeaponStatMP_Damage=1
    WeaponStatMP_Firerate=9
    WeaponStatMP_Accuracy=7
    WeaponStatMP_ReloadSpeed=6
    EWeaponType=WeaponType.TYPE_AutomaticPistol
    ZoomedCrosshair=true
    bFastRepeater=true
    DefaultAmmoCount=30
    MaxAmmoCount=40
    MaxAmmoCountSurvivalMultiplier=1.0000000
    MagazineAmmoCount=10
    MagazineMaxAmmoCount=10
    WeaponHitRange=3500.0000000
    WeaponDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    WeaponSpread=/* Array type was not detected. */
    ShotSpreadModifier=0.0900000
    ShotSpreadBackSpeed=5.0000000
    MoveSpreadMultiplier=1.1000000
    SprintSpreadMultiplier=1.2000000
    JumpSpreadMultiplier=1.5000000
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_Bergman_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    AmmoPickupString="Mars Ammo"
    ReloadTime=1.9000000
    InventoryGroup=1
    ZoomedRate=120.0000000
    ZoomingTranslationRate=13.0000000
    ZoomedMeshTranslation=(X=-5.0000000,Y=-7.2796000,Z=-0.0477000)
    ZoomedMeshRotation=(Pitch=-275,Yaw=149,Roll=0)
    ZoomedMeshScale=1.4988000
    DOF_FocusDistance=60.0000000
    GroupWeight=0.3000000
    // Reference: AudioComponent'Default__AdvWeap_Bergman_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_Bergman_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    RecoilDelta=450.0000000
    RecoilMax=500.0000000
    WeaponName="Bergman"
    CrouchAnimTime=1.0420000
    StandUpAnimTime=1.0420000
    SprintAnimTime=1.0000000
    PlayerViewOffset=(X=33.5292000,Y=9.7070000,Z=-7.6999000)
    PlayerRotationOffset=(Pitch=-41,Yaw=-735,Roll=152)
    CurrentRating=0.3000000
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.3300000
    PutDownTime=0.3300000
    bInstantHit=true
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_Bergman_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.3000000
    ItemName="Mars"
    MaxDesireability=0.3000000
    // Reference: SkeletalMeshComponent'Default__AdvWeap_Bergman_Base.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}