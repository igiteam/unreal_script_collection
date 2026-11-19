class AdvWeap_viking_Base extends AdvWeap_3PhaseReload_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

var() array<float> FireIntervalLast;
var(Animations) array<name> WeaponFireAnimLast;
var(Animations) array<name> ArmFireAnimLast;
var array<CameraAnim> FireCameraAnimLast;
var(Sounds) array<SoundCue> WeaponFireSndLast;
var transient bool WasEmptyBeforeReload;
var transient bool bAimedBeforeFiring;

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

simulated state WeaponEquipping
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        SkeletonFirstPersonMesh.SetEnableClothSimulation(true);
        //return;        
    }
    stop;    
}

simulated state WeaponPuttingDown
{
    simulated function EndState(name NextStateName)
    {
        SkeletonFirstPersonMesh.SetEnableClothSimulation(false);
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

simulated state WeaponFiring
{
    simulated function BeginState(name PreviousStateName)
    {
        local EvilPlayerController PC;

        // End:0xE6
        if(MagazineAmmoCount == 1)
        {
            WeaponFireAnim[int(CurrentFireMode)] = WeaponFireAnimLast[int(CurrentFireMode)];
            ArmFireAnim[int(CurrentFireMode)] = ArmFireAnimLast[int(CurrentFireMode)];
            FireInterval[int(CurrentFireMode)] = FireIntervalLast[int(CurrentFireMode)];
            FireCameraAnim[int(CurrentFireMode)] = FireCameraAnimLast[int(CurrentFireMode)];
            WeaponFireSnd[int(CurrentFireMode)] = WeaponFireSndLast[int(CurrentFireMode)];
        }
        PC = EvilPlayerController(EvilPawn(Owner).Controller);
        // End:0x1A2
        if(((int(CurrentFireMode) == int(0)) && PC != none) && int(ZoomedFireModeNum) < int(255))
        {
            bAimedBeforeFiring = true;
            EndZoom(PC);
            // End:0x1A2
            if(int(Role) < int(ROLE_Authority))
            {
                ServerEndZoom(PC);
            }
        }
        super.BeginState(PreviousStateName);
        //return;        
    }

    simulated event EndState(name NextStateName)
    {
        local EvilPlayerController PC;

        WeaponFireAnim = default.WeaponFireAnim;
        ArmFireAnim = default.ArmFireAnim;
        FireInterval = WeaponFireInterval;
        FireCameraAnim = default.FireCameraAnim;
        WeaponFireSnd = default.WeaponFireSnd;
        PC = EvilPlayerController(EvilPawn(Owner).Controller);
        // End:0x160
        if((((int(CurrentFireMode) == int(0)) && MagazineAmmoCount > 0) && PC != none) && (int(ZoomedFireModeNum) == int(255)) && bAimedBeforeFiring)
        {
            bAimedBeforeFiring = false;
            ZoomedFireModeNum = CurrentFireMode;
            StartZoom(PC, ZoomedFireModeNum);
            // End:0x160
            if(int(Role) < int(ROLE_Authority))
            {
                ServerStartZoom(PC, ZoomedFireModeNum);
            }
        }
        super.EndState(NextStateName);
        //return;        
    }

    simulated function BeginFire(byte FireModeNum)
    {
        // End:0x31
        if((int(CurrentFireMode) != int(0)) && CheckZoom(FireModeNum))
        {
            return;            
        }
        else
        {
            // End:0x8F
            if((int(FireModeNum) < bZoomedFireMode.Length) && int(bZoomedFireMode[int(FireModeNum)]) != int(0))
            {
                // End:0x8D
                if(int(ZoomedFireModeNum) < int(255))
                {
                    ZoomedFireModeNum = 255;
                }
                return;
            }
        }
        global.BeginFire(FireModeNum);
        // End:0xE4
        if(!HasShareAmmo(FireModeNum) && int(FireModeNum) == int(CurrentFireMode))
        {
            WeaponEmpty();
            return;
        }
        //return;        
    }
    stop;    
}

simulated state Active
{
    simulated function BeginFire(byte FireModeNum)
    {
        // End:0x64
        if(!WorldInfo.GRI.IsMultiplayerGame())
        {
            // End:0x61
            if(int(GetZoomedState()) != int(2))
            {
                super.BeginFire(FireModeNum);
            }            
        }
        else
        {
            super.BeginFire(FireModeNum);
        }
        //return;        
    }
    stop;    
}

simulated state ReloadState
{
    simulated function BeginState(name PreviousStateName)
    {
        bAimedBeforeFiring = false;
        // End:0x27
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
    FireIntervalLast[0]=0.5000000
    // Reference: AudioComponent'Default__AdvWeap_viking_Base.ReloadSoundLoopComp'
    begin object name=ReloadSoundLoopComp
    end object
    ReloadSoundLoop=ReloadSoundLoopComp
    // Reference: AudioComponent'Default__AdvWeap_viking_Base.ReloadSoundEndComp'
    begin object name=ReloadSoundEndComp
    end object
    ReloadSoundEnd=ReloadSoundEndComp
    WeaponStatMP_Damage=3
    WeaponStatMP_Firerate=1
    WeaponStatMP_Accuracy=6
    WeaponStatMP_Magazines=2
    WeaponStatMP_ReloadSpeed=9
    EWeaponType=WeaponType.TYPE_AutomaticRifle
    FlashlightBaseSpotlightOffset=(X=22.2944000,Y=-7.4958000,Z=-30.3964000)
    FlashlightBaseSpotlightRotOffset=(Pitch=-117,Yaw=341,Roll=318)
    FlashlightAimingSpotlightOffset=(X=-10.0000000,Y=-7.4491000,Z=-13.5861000)
    FlashlightAimingSpotlightRotOffset=(Pitch=-14,Yaw=-6,Roll=0)
    BothHandWeapon=true
    DefaultAmmoCount=60
    MaxAmmoCount=60
    MagazineAmmoCount=5
    MagazineMaxAmmoCount=5
    WeaponHitRange=1200.0000000
    WeaponDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    NumberOfShots=/* Array type was not detected. */
    WeaponSpread=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    MoveSpreadMultiplier=1.2000000
    SprintSpreadMultiplier=1.3000000
    JumpSpreadMultiplier=1.3000000
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_viking_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    AmmoPickupString="Viking Ammo"
    ReloadTime=0.7000000
    InventoryGroup=2
    ZoomedMeshTranslation=(X=-34.6417000,Y=-8.6814000,Z=0.8693000)
    ZoomedMeshRotation=(Pitch=-145,Yaw=354,Roll=-121)
    ZoomedMeshScale=2.0000000
    DOF_FocusDistance=60.0000000
    GroupWeight=0.2000000
    // Reference: AudioComponent'Default__AdvWeap_viking_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_viking_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    WeaponName="viking"
    PlayerViewOffset=(X=-1.0307000,Y=2.4522000,Z=-3.5681000)
    PlayerRotationOffset=(Pitch=-622,Yaw=-318,Roll=121)
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.4000000
    PutDownTime=0.3300000
    bInstantHit=true
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_viking_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    ItemName="Viking"
    // Reference: SkeletalMeshComponent'Default__AdvWeap_viking_Base.PickupMesh'
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