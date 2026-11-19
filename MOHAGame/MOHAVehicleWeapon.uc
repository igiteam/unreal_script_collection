class MOHAVehicleWeapon extends EALASmallArms
    native
    config(Weapon)
    hidecategories(Navigation);

enum ETurretSoundState
{
    TURRET_SOUND_STATE_START,       // 0
    TURRET_SOUND_STATE_STOP,        // 1
    TURRET_SOUND_STATE_OFF,         // 2
    TURRET_SOUND_STATE_ON,          // 3
    TURRET_SOUND_STATE_MAX          // 4
};

var int hardPointIndex;
var MOHAVehicle owningVehicle;
var Rotator weaponSpawnRot;
var Vector weaponSpawnLoc;
var(Sounds) bool bHasTurretSounds;
var(Shake) config bool bShakeCameraOnFire;
var(Sounds) SoundCue YawSounds[ETurretSoundState];
var(Sounds) SoundCue PitchSounds[ETurretSoundState];
var export editinline AudioComponent YawMovementSound;
var export editinline AudioComponent PitchMovementSound;
var MOHAVehicleWeapon.ETurretSoundState YawMovementState;
var MOHAVehicleWeapon.ETurretSoundState PitchMovementState;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    YawMovementState = 2;
    PitchMovementState = 2;
    //return;    
}

simulated function Projectile ProjectileFire()
{
    local Projectile SpawnedProjectile;

    IncrementFlashCount();
    // End:0x48
    if((owningVehicle != none) && hardPointIndex != -1)
    {
        owningVehicle.GetHardPointLocationAndRotation(hardPointIndex, weaponSpawnLoc, weaponSpawnRot);
    }
    owningVehicle.OnWeaponFired(self);
    // End:0x8E
    if(int(Role) == int(ROLE_Authority))
    {
        SpawnedProjectile = SpawnProjectile(weaponSpawnLoc, vect(1.0000000, 0.0000000, 0.0000000));
    }
    return SpawnedProjectile;
    //return ReturnValue;    
}

simulated function SetTurretSoundState_Yaw(MOHAVehicleWeapon.ETurretSoundState NextTurretSoundState)
{
    YawMovementSound.__OnAudioFinished__Delegate = None;
    YawMovementSound.Stop();
    YawMovementState = NextTurretSoundState;
    // End:0x88
    if(YawSounds[int(YawMovementState)] != none)
    {
        YawMovementSound.SoundCue = YawSounds[int(YawMovementState)];
        YawMovementSound.__OnAudioFinished__Delegate = YawSoundFinished;
        YawMovementSound.Play();
    }
    //return;    
}

simulated function SetTurretSoundState_Pitch(MOHAVehicleWeapon.ETurretSoundState NextTurretSoundState)
{
    PitchMovementSound.__OnAudioFinished__Delegate = None;
    PitchMovementSound.Stop();
    PitchMovementState = NextTurretSoundState;
    // End:0x88
    if(PitchSounds[int(PitchMovementState)] != none)
    {
        PitchMovementSound.SoundCue = PitchSounds[int(PitchMovementState)];
        PitchMovementSound.__OnAudioFinished__Delegate = PitchSoundFinished;
        PitchMovementSound.Play();
    }
    //return;    
}

simulated function YawSoundFinished(AudioComponent AC)
{
    // End:0x1C
    if(int(YawMovementState) == int(0))
    {
        SetTurretSoundState_Yaw(3);
    }
    // End:0x38
    if(int(YawMovementState) == int(1))
    {
        SetTurretSoundState_Yaw(2);
    }
    //return;    
}

simulated function PitchSoundFinished(AudioComponent AC)
{
    // End:0x1C
    if(int(PitchMovementState) == int(0))
    {
        SetTurretSoundState_Pitch(3);
    }
    // End:0x38
    if(int(PitchMovementState) == int(1))
    {
        SetTurretSoundState_Pitch(2);
    }
    //return;    
}

simulated function UpdateTurretSounds(bool bYawChanged, bool bPitchChanged, Rotator rTargetDelta)
{
    // End:0x0D
    if(!bHasTurretSounds)
    {
        return;
    }
    // End:0x71
    if((bYawChanged && int(YawMovementState) == int(2)) && Abs(float(rTargetDelta.Yaw)) > float(182))
    {
        // End:0x62
        if(YawSounds[0] != none)
        {
            SetTurretSoundState_Yaw(0);            
        }
        else
        {
            SetTurretSoundState_Yaw(3);
        }        
    }
    else
    {
        // End:0xC8
        if((!bYawChanged && int(YawMovementState) != int(2)) && int(YawMovementState) != int(1))
        {
            // End:0xBC
            if(YawSounds[1] != none)
            {
                SetTurretSoundState_Yaw(1);                
            }
            else
            {
                SetTurretSoundState_Yaw(2);
            }
        }
    }
    // End:0x12C
    if((bPitchChanged && int(PitchMovementState) == int(2)) && Abs(float(rTargetDelta.Pitch)) > float(182))
    {
        // End:0x11D
        if(PitchSounds[0] != none)
        {
            SetTurretSoundState_Pitch(0);            
        }
        else
        {
            SetTurretSoundState_Pitch(3);
        }        
    }
    else
    {
        // End:0x183
        if((!bPitchChanged && int(PitchMovementState) != int(2)) && int(PitchMovementState) != int(1))
        {
            // End:0x177
            if(PitchSounds[1] != none)
            {
                SetTurretSoundState_Pitch(1);                
            }
            else
            {
                SetTurretSoundState_Pitch(2);
            }
        }
    }
    //return;    
}

defaultproperties
{
    hardPointIndex=-1
    // Reference: AudioComponent'Default__MOHAVehicleWeapon.TurretYawSound'
    begin object name=TurretYawSound class=Class'Engine.AudioComponent'
    end object
    YawMovementSound=TurretYawSound
    // Reference: AudioComponent'Default__MOHAVehicleWeapon.TurretPitchSound'
    begin object name=TurretPitchSound class=Class'Engine.AudioComponent'
    end object
    PitchMovementSound=TurretPitchSound
    // Reference: WeaponAccuracyComponent'Default__MOHAVehicleWeapon.WeaponAccuracy'
    begin object name=WeaponAccuracy
    end object
    AccuracyComponent=WeaponAccuracy
    // Reference: WeaponAccuracyComponent'Default__MOHAVehicleWeapon.IronsightsWeaponAccuracy'
    begin object name=IronsightsWeaponAccuracy
    end object
    IronsightsAccuracyComponent=IronsightsWeaponAccuracy
    // Reference: WeaponKickComponent'Default__MOHAVehicleWeapon.WeaponKick'
    begin object name=WeaponKick
    end object
    KickComponent=WeaponKick
    // Reference: WeaponKickComponent'Default__MOHAVehicleWeapon.IronsightsWeaponKick'
    begin object name=IronsightsWeaponKick
    end object
    IronsightsKickComponent=IronsightsWeaponKick
    // Reference: WhizSenderComponent'Default__MOHAVehicleWeapon.whiz'
    begin object name=whiz
    end object
    WhizComponent=whiz
    RequiresAmmo[0]=false
    RequiresAmmo[1]=true
    RequiresAmmo[2]=false
    FiringStatesArray=/* Array type was not detected. */
    // Reference: MOHASkeletalMeshComponent'Default__MOHAVehicleWeapon.PickupMesh'
    begin object name=PickupMesh
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=WeaponAccuracy
    Components[1]=IronsightsWeaponAccuracy
    Components[2]=WeaponKick
    Components[3]=IronsightsWeaponKick
    Components[4]=TurretYawSound
    Components[5]=TurretPitchSound
}