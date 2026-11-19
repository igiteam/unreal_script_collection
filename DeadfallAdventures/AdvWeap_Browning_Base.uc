class AdvWeap_Browning_Base extends AdvWeap_3PhaseReload_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

var transient bool WasEmptyBeforeReload;

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
    // End:0x271
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
        WasEmptyBeforeReload = false;
    }
    //return;    
}

simulated state ReloadState
{
    simulated function BeginState(name PreviousStateName)
    {
        // End:0x1B
        if(MagazineAmmoCount == 0)
        {
            WasEmptyBeforeReload = true;
        }
        super.BeginState(PreviousStateName);
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        WasEmptyBeforeReload = false;
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

simulated state SprintReloadState
{
    simulated event PushedState()
    {
        // End:0x1B
        if(MagazineAmmoCount == 0)
        {
            WasEmptyBeforeReload = true;
        }
        super(Object).PushedState();
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: AudioComponent'Default__AdvWeap_Browning_Base.ReloadSoundLoopComp'
    begin object name=ReloadSoundLoopComp
    end object
    ReloadSoundLoop=ReloadSoundLoopComp
    // Reference: AudioComponent'Default__AdvWeap_Browning_Base.ReloadSoundEndComp'
    begin object name=ReloadSoundEndComp
    end object
    ReloadSoundEnd=ReloadSoundEndComp
    bPurchasedWeaponDLC=false
    WeaponStatMP_Damage=1
    WeaponStatMP_Firerate=3
    WeaponStatMP_Magazines=2
    WeaponStatMP_ReloadSpeed=1
    EWeaponType=WeaponType.TYPE_AutomaticRifle
    FlashlightBaseSpotlightOffset=(X=5.8530000,Y=-8.7253000,Z=-30.0511000)
    FlashlightBaseSpotlightRotOffset=(Pitch=114,Yaw=-52,Roll=0)
    FlashlightAimingSpotlightOffset=(X=5.1285000,Y=-5.4816000,Z=-20.8087000)
    FlashlightAimingSpotlightRotOffset=(Pitch=-37,Yaw=6,Roll=0)
    BothHandWeapon=true
    DefaultAmmoCount=30
    MaxAmmoCount=30
    MagazineAmmoCount=5
    MagazineMaxAmmoCount=5
    WeaponHitRange=1200.0000000
    WeaponDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    WeaponCloseDamageMaxMultiplier=2.0000000
    WeaponCloseDamageDistance=100.0000000
    NumberOfShots=/* Array type was not detected. */
    WeaponSpread=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    ShotSpreadModifier=0.0900000
    ShotSpreadBackSpeed=1.0000000
    MoveSpreadMultiplier=1.1000000
    SprintSpreadMultiplier=1.2000000
    JumpSpreadMultiplier=1.5000000
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_Browning_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    AmmoPickupString="FN Auto-5 Shells"
    ReloadTime=0.8000000
    InventoryGroup=2
    ZoomedRate=120.0000000
    ZoomingTranslationRate=13.0000000
    ZoomedMeshTranslation=(X=-24.9452000,Y=-4.4913000,Z=1.9195000)
    ZoomedMeshRotation=(Pitch=-48,Yaw=-1,Roll=573)
    ZoomedMeshScale=2.0000000
    ZoomedSpreadMult=1.0000000
    DOF_FocusDistance=60.0000000
    GroupWeight=0.6000000
    // Reference: AudioComponent'Default__AdvWeap_Browning_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_Browning_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    RecoilDelta=100.0000000
    WeaponName="Browning"
    CrouchAnimTime=1.0420000
    StandUpAnimTime=1.0420000
    SprintStartAnimTime=1.2080000
    SprintAnimTime=0.7000000
    PlayerViewOffset=(X=-1.0307000,Y=0.7371000,Z=0.1326000)
    PlayerRotationOffset=(Pitch=-837,Yaw=-13,Roll=-431)
    CurrentRating=0.6000000
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.3700000
    PutDownTime=0.3700000
    bInstantHit=true
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_Browning_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.6000000
    ItemName="FN Auto-5"
    MaxDesireability=0.6000000
    // Reference: SkeletalMeshComponent'Default__AdvWeap_Browning_Base.PickupMesh'
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