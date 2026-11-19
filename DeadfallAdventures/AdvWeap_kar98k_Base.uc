class AdvWeap_kar98k_Base extends AdvWeap_3PhaseReload_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

var() array<float> FireIntervalLast;
var(Animations) array<name> WeaponFireAnimLast;
var(Animations) array<name> ArmFireAnimLast;
var array<CameraAnim> FireCameraAnimLast;
var(Sounds) array<SoundCue> WeaponFireSndLast;
var(Sounds) array<SoundCue> WeaponFireSnd1pLast;

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

simulated event OnReloadEnding(bool bInterrupted)
{
    local EvilPlayerController PC;
    local EvilPawn P;

    P = EvilPawn(Owner);
    PC = EvilPlayerController(P.Controller);
    // End:0x265
    if(P != none)
    {
        // End:0xA7
        if(bInterrupted)
        {
            ReloadSoundLoop.Stop();
            ReloadSoundLoop.DetachFromAny();
        }
        // End:0xFD
        if((PC != none) && ReloadEndCameraAnim != none)
        {
            PC.PlayCameraAnim(ReloadEndCameraAnim,,, 0.2000000, 0.2000000);
        }
        P.AttachComponent(ReloadSoundEnd);
        // End:0x16F
        if(EvilPawn(Owner).IsLocallyControlled())
        {
            ReloadSoundEnd.Play();
        }
        PlayWeaponAnim('WeaponReload_3', 0.0000000, ReloadAnimBlendTimes.BlendIn, ReloadAnimBlendTimes.BlendOut);
        // End:0x224
        if(ArmsAnimSet != none)
        {
            PlayArmAnim('WeaponReload_3', 0.0000000, ReloadAnimBlendTimes.BlendIn, ReloadAnimBlendTimes.BlendOut);
        }
        SetTimer(SkeletonFirstPersonMesh.GetAnimLength('WeaponReload_3') / DefaultAnimSpeed, false, 'ReloadTimer');
    }
    //return;    
}

simulated state WeaponFiring
{
    simulated function BeginState(name PreviousStateName)
    {
        // End:0x111
        if(MagazineAmmoCount == 1)
        {
            WeaponFireAnim[int(CurrentFireMode)] = WeaponFireAnimLast[int(CurrentFireMode)];
            ArmFireAnim[int(CurrentFireMode)] = ArmFireAnimLast[int(CurrentFireMode)];
            FireInterval[int(CurrentFireMode)] = FireIntervalLast[int(CurrentFireMode)];
            FireCameraAnim[int(CurrentFireMode)] = FireCameraAnimLast[int(CurrentFireMode)];
            WeaponFireSnd[int(CurrentFireMode)] = WeaponFireSndLast[int(CurrentFireMode)];
            WeaponFireSnd1p[int(CurrentFireMode)] = WeaponFireSnd1pLast[int(CurrentFireMode)];
        }
        super.BeginState(PreviousStateName);
        //return;        
    }

    simulated event EndState(name NextStateName)
    {
        WeaponFireAnim = default.WeaponFireAnim;
        ArmFireAnim = default.ArmFireAnim;
        FireInterval = WeaponFireInterval;
        FireCameraAnim = default.FireCameraAnim;
        WeaponFireSnd = default.WeaponFireSnd;
        WeaponFireSnd1p = default.WeaponFireSnd1p;
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

defaultproperties
{
    FireIntervalLast[0]=0.5400000
    // Reference: AudioComponent'Default__AdvWeap_kar98k_Base.ReloadSoundLoopComp'
    begin object name=ReloadSoundLoopComp
    end object
    ReloadSoundLoop=ReloadSoundLoopComp
    // Reference: AudioComponent'Default__AdvWeap_kar98k_Base.ReloadSoundEndComp'
    begin object name=ReloadSoundEndComp
    end object
    ReloadSoundEnd=ReloadSoundEndComp
    WeaponStatMP_Damage=9
    WeaponStatMP_Firerate=1
    WeaponStatMP_Accuracy=7
    WeaponStatMP_Magazines=3
    WeaponStatMP_ReloadSpeed=8
    EWeaponType=WeaponType.TYPE_Rifle
    FlashlightBaseSpotlightOffset=(X=-13.3632000,Y=-23.2472000,Z=-9.8438000)
    FlashlightBaseSpotlightRotOffset=(Pitch=-502,Yaw=503,Roll=0)
    FlashlightAimingSpotlightOffset=(X=-13.1805000,Y=-17.5729000,Z=-9.3842000)
    FlashlightAimingSpotlightRotOffset=(Pitch=-248,Yaw=-14,Roll=0)
    BothHandWeapon=true
    DefaultAmmoCount=40
    MaxAmmoCount=40
    MagazineAmmoCount=5
    MagazineMaxAmmoCount=5
    WeaponHitRange=18000.0000000
    WeaponDamage=/* Array type was not detected. */
    ArmsDamageMultiplier=1.0000000
    WeaponMomentum=/* Array type was not detected. */
    WeaponSpread=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    MoveSpreadMultiplier=1.1000000
    SprintSpreadMultiplier=1.2000000
    JumpSpreadMultiplier=1.5000000
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_kar98k_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    AmmoPickupString="kar98k Ammo"
    ReloadTime=0.8000000
    InventoryGroup=2
    ZoomedTargetFOV=55.0000000
    ZoomedRate=120.0000000
    ZoomingTranslationRate=13.0000000
    ZoomedMeshTranslation=(X=-38.9761000,Y=-17.3793000,Z=9.9519000)
    ZoomedMeshRotation=(Pitch=-340,Yaw=536,Roll=-412)
    ZoomedMeshScale=2.0000000
    ZoomedSpreadMult=0.0100000
    DOF_FocusDistance=60.0000000
    GroupWeight=0.3500000
    // Reference: AudioComponent'Default__AdvWeap_kar98k_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_kar98k_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    WeaponName="KAR98k"
    CrouchAnimTime=1.0420000
    StandUpAnimTime=1.0420000
    SprintStartAnimTime=1.2080000
    SprintAnimTime=0.7000000
    PlayerViewOffset=(X=18.5308000,Y=11.8334000,Z=-6.9642000)
    PlayerRotationOffset=(Pitch=-534,Yaw=-508,Roll=454)
    CurrentRating=0.3500000
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=1.0420000
    PutDownTime=0.4000000
    bInstantHit=true
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_kar98k_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.3500000
    ItemName="kar98k"
    MaxDesireability=0.3500000
    // Reference: SkeletalMeshComponent'Default__AdvWeap_kar98k_Base.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
    Components[2]=ReloadSoundLoopComp
    Components[3]=ReloadSoundEndComp
}