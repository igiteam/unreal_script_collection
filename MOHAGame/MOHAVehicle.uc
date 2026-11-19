class MOHAVehicle extends SVehicle
    abstract
    native
    config(Game)
    hidecategories(Navigation);

enum EEngineSoundState
{
    ENGINE_SOUND_STATE_OFF,         // 0
    ENGINE_SOUND_STATE_CRUISE,      // 1
    ENGINE_SOUND_STATE_IDLE,        // 2
    ENGINE_SOUND_STATE_MAX          // 3
};

enum ETurnSoundState
{
    TURN_SOUND_STATE_OFF,           // 0
    TURN_SOUND_STATE_ON,            // 1
    TURN_SOUND_STATE_MAX            // 2
};

enum EVehicleActivity
{
    VEHICLE_ACTIVITY_IDLE,          // 0
    VEHICLE_ACTIVITY_FIRE,          // 1
    VEHICLE_ACTIVITY_MAX            // 2
};

struct native VehicleWeaponInfo
{
    var class<MOHAVehicleWeapon> WeaponClass;
    var MOHAVehicleWeapon Weapon;
    var WeaponAttachment WeaponAttachment;
    var name AttachSocket;
    var name YawControlName;
    var name PitchControlName;
    var name AimSocketName;
    var Rotator TurretMaxRotationRate;
    var Rotator TurretAccelerationRate;
    var Rotator CurrentRotation;
    var Rotator CurrentRotVelocity;
    var SkelControlSingleBone PitchControl;
    var SkelControlSingleBone YawControl;
    var Rotator MinRot;
    var Rotator MaxRot;
    var float fMaxEngagementDist_Player;
    var float fMaxEngagementDist_NPC;
    var bool bDestroyed;

    structdefaultproperties
    {
        WeaponClass=none
        Weapon=none
        WeaponAttachment=none
        AttachSocket="None"
        YawControlName="None"
        PitchControlName="None"
        AimSocketName="None"
        TurretMaxRotationRate=(Pitch=0,Yaw=0,Roll=0)
        TurretAccelerationRate=(Pitch=0,Yaw=0,Roll=0)
        CurrentRotation=(Pitch=0,Yaw=0,Roll=0)
        CurrentRotVelocity=(Pitch=0,Yaw=0,Roll=0)
        PitchControl=none
        YawControl=none
        MinRot=(Pitch=0,Yaw=0,Roll=0)
        MaxRot=(Pitch=0,Yaw=0,Roll=0)
        fMaxEngagementDist_Player=0.0000000
        fMaxEngagementDist_NPC=0.0000000
        bDestroyed=false
    }
};

struct native DestructibleVehiclePartInfo
{
    var SkeletalMesh Pristine_Mesh;
    var SkeletalMesh Destroyed_Mesh;
    var int iHealth;
    var array<name> DamageBoneNames;
    var name SocketName;
    var Vector vExtents;
    var ParticleSystem ExplosionParticleSystem;
    var export editinline ParticleSystemComponent ExplosionEmitter;
    var export editinline MOHASkeletalMeshComponent Mesh;
    var SoundCue DestructionSound;

    structdefaultproperties
    {
        Pristine_Mesh=none
        Destroyed_Mesh=none
        iHealth=0
        DamageBoneNames=none
        SocketName="None"
        vExtents=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        ExplosionParticleSystem=none
        ExplosionEmitter=none
        Mesh=none
        DestructionSound=none
    }
};

struct native DamageZoneModifiers
{
    var name SocketName;
    var Vector vExtents;
    var float fDamageMult;

    structdefaultproperties
    {
        SocketName="None"
        vExtents=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        fDamageMult=0.0000000
    }
};

var() config array<config VehicleWeaponInfo> WeaponsInfo;
var() config array<config DestructibleVehiclePartInfo> PartInfo;
var() config array<config DamageZoneModifiers> DamageZoneInfo;
var() array< class<DamageType> > MyDamageTypes;
var() config bool bSlowDownWhenTurning;
var() bool bDebugVehicles;
var() bool bDrawThrottleGraph;
var() bool bReversing;
var(Sounds) bool bUseCollBoxVolumeEmitter;
var bool bImmobile;
var bool bAddedVehicleToCompass;
var() config float MaxTurnSpeed;
var() config float fMaxSpeed;
var() ParticleSystem ExplosionParticleSystem;
var() name ExplosionSocketName;
var() PhysicsAsset DestroyedPhysicsAsset;
var SkeletalMesh DestroyedMesh;
var export editinline ParticleSystemComponent ExplosionEmitter;
var SoundCue DestructionSound;
var() ParticleSystem LowHealthParticleSystem;
var() name LowHealthSocketName;
var export editinline ParticleSystemComponent LowHealthEmitter;
var float fLowHealthThreshold;
var() MOHAVehicle.EVehicleActivity CurrentActivity;
var MOHAVehicle.EEngineSoundState CurrentEngineSoundState;
var MOHAVehicle.ETurnSoundState CurrentTurnSoundState;
var() MOHAIncludeClass.EPawnType PawnSide;
var() float FireAnimationTime;
var float PlaybackLength;
var export editinline MOHAGraph throttleGraph;
var() array< class<Inventory> > Inventory;
var float OldSteering;
var(Sounds) SoundCue EngineSoundCues[EEngineSoundState];
var(Sounds) float fMinEngineCruisePitchMult;
var(Sounds) float fMaxEngineCruisePitchMult;
var(Sounds) float fMinEngineIdlePitchMult;
var(Sounds) float fMaxEngineIdlePitchMult;
var(Sounds) float fEnginePitchChangeRate;
var(Sounds) float fIdleSpeedThreshold;
var MOHAOBBMovePoint CollBoxVolumeEmitter;
var export editinline AudioComponent TurnSound;
var int iEngineSoundCriteriaMetTicks;
var int iTurnSoundCriteriaMetTicks;
var float fLastYaw;
var(Shake) float fTurretFireShakeRadius;
var ViewShakeInfo TurretFireShake;
var float fLastTurretFireTime;
var float fCurrentEnginePitch;
var Rotator rRotDelayedZeroToHalfSecond;
var Rotator rRotDelayedHalfToOneSecond;
var float fLastRotDelayTime;

simulated function PostBeginPlay()
{
    local MOHAVehicleDriverPawn VehicleDriver;

    super.PostBeginPlay();
    ApplyConfigVariables();
    // End:0x25
    if(Controller == none)
    {
        SpawnDefaultController();
    }
    SetPhysics(2);
    InitWeapons();
    InitDestructibleParts();
    VehicleDriver = __NFUN_278__(Class'MOHAVehicleDriverPawn',,, self.Location, self.Rotation);
    DriverEnter(VehicleDriver);
    CurrentEngineSoundState = 0;
    // End:0xCA
    if(bUseCollBoxVolumeEmitter)
    {
        CollBoxVolumeEmitter = __NFUN_278__(Class'MOHAOBBMovePoint',,, self.Location, self.Rotation);
        CollBoxVolumeEmitter.SetBase(self);
        CollBoxVolumeEmitter.SetHardAttach(true);
    }
    //return;    
}

simulated function ToggleCompassStatus(bool bAddToCompass)
{
    local PlayerController PlayerController;

    // End:0x8D
    foreach LocalPlayerControllers(PlayerController)
    {
        // End:0x8C
        if((PlayerController != none) && MOHAHUD(PlayerController.myHUD) != none)
        {
            bAddedVehicleToCompass = true;
            // End:0x6A
            if(bAddToCompass)
            {
                MOHAHUD(PlayerController.myHUD).AddCompassBead(self);
                // End:0x8C
                continue;
            }
            MOHAHUD(PlayerController.myHUD).RemoveCompassBead(self);
        }        
    }    
    //return;    
}

simulated function ApplyConfigVariables()
{
    MaxSpeed = fMaxSpeed;
    //return;    
}

function TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local int iPreviousHealth;

    iPreviousHealth = Health;
    // End:0xC2
    if(Class'MOHAUtilities'.static.MatchingDamageType(MyDamageTypes, DamageType))
    {
        Damage *= (GetDamageZoneMult(DamageCauser));
        // End:0x5D
        if(DamageType == Class'MOHACompBDamageType')
        {
            Damage = Health;
        }
        super(Vehicle).TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
        CheckForDestroyedPart(Damage, HitInfo.BoneName, DamageType, InstigatedBy, DamageCauser);
        CheckForLowHealthVFX(iPreviousHealth);
    }
    //return;    
}

function float GetDamageZoneMult(Actor DamageCauser)
{
    local float fDamageMult;
    local Vector vZoneOrigin, vExplosionToZone_WS, vExplosionToZone_AS;
    local int I;

    fDamageMult = 1.0000000;
    // End:0x29
    if((DamageCauser == none) || Mesh == none)
    {
        return fDamageMult;
    }
    I = 0;
    J0x30:

    // End:0x174 [Loop If]
    if(I < DamageZoneInfo.Length)
    {
        // End:0x16A
        if(Mesh.GetSocketWorldLocationAndRotation(DamageZoneInfo[I].SocketName, vZoneOrigin))
        {
            vExplosionToZone_WS = DamageCauser.Location - vZoneOrigin;
            vExplosionToZone_AS = Class'MOHAUtilities'.static.InverseRotateVector(vExplosionToZone_WS, Rotation);
            // End:0x16A
            if(((Abs(vExplosionToZone_AS.X) < DamageZoneInfo[I].vExtents.X) && Abs(vExplosionToZone_AS.Y) < DamageZoneInfo[I].vExtents.Y) && Abs(vExplosionToZone_AS.Z) < DamageZoneInfo[I].vExtents.Z)
            {
                fDamageMult *= DamageZoneInfo[I].fDamageMult;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x30;
    }
    return fDamageMult;
    //return ReturnValue;    
}

function CheckForLowHealthVFX(int iPreviousHealth)
{
    local float fHealthPct_Begin, fHealthPct_End;

    // End:0x1A
    if((LowHealthParticleSystem == none) || Health <= 0)
    {
        return;
    }
    fHealthPct_Begin = float(iPreviousHealth) / float(default.Health);
    fHealthPct_End = float(Health) / float(default.Health);
    // End:0xB6
    if((fHealthPct_End <= fLowHealthThreshold) && fHealthPct_Begin > fLowHealthThreshold)
    {
        LowHealthEmitter = new (Outer) Class'Engine.ParticleSystemComponent';
        LowHealthEmitter.SetTemplate(LowHealthParticleSystem);
        Mesh.AttachComponentToSocket(LowHealthEmitter, LowHealthSocketName);
        LowHealthEmitter.ActivateSystem();
    }
    //return;    
}

function AdjustDamage(out int inDamage, out Vector Momentum, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo)
{
    super(Pawn).AdjustDamage(inDamage, Momentum, InstigatedBy, HitLocation, DamageType, HitInfo);
    // End:0x3F
    if(DamageType == Class'MOHACompBDamageType')
    {
        inDamage = default.Health;
    }
    //return;    
}

function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    // End:0x18E
    if(super.Died(Killer, DamageType, HitLocation))
    {
        DestroyAllParts();
        // End:0x7D
        if(ExplosionParticleSystem != none)
        {
            ExplosionEmitter = new (Outer) Class'Engine.ParticleSystemComponent';
            ExplosionEmitter.SetTemplate(ExplosionParticleSystem);
            Mesh.AttachComponentToSocket(ExplosionEmitter, ExplosionSocketName);
            ExplosionEmitter.ActivateSystem();
        }
        // End:0xC1
        if(DestructionSound != none)
        {
            // End:0xB2
            if(CollBoxVolumeEmitter != none)
            {
                PlaySound(DestructionSound,,,, CollBoxVolumeEmitter.Location);                
            }
            else
            {
                PlaySound(DestructionSound);
            }
        }
        // End:0xDB
        if(LowHealthEmitter != none)
        {
            LowHealthEmitter.DeactivateSystem();
        }
        // End:0xFB
        if(DestroyedMesh != none)
        {
            Mesh.SetSkeletalMesh(DestroyedMesh);
        }
        // End:0x11A
        if(DestroyedPhysicsAsset != none)
        {
            Mesh.SetPhysicsAsset(DestroyedPhysicsAsset);
        }
        ToggleCompassStatus(false);
        // End:0x182
        if(MOHAPlayerController(Killer) != none)
        {
            MOHAPlayerController(Killer).OnWeaponHit(EALAWeapon(Killer.Pawn.Weapon).WeaponType, 'None', self, DamageType, true);
        }
        DestroyWeapons();
        return true;
    }
    return false;
    //return ReturnValue;    
}

function DisableTank()
{
    SetHealth(0);
    DestroyAllParts();
    // End:0x70
    if(ExplosionParticleSystem != none)
    {
        ExplosionEmitter = new (Outer) Class'Engine.ParticleSystemComponent';
        ExplosionEmitter.SetTemplate(ExplosionParticleSystem);
        Mesh.AttachComponentToSocket(ExplosionEmitter, ExplosionSocketName);
        ExplosionEmitter.ActivateSystem();
    }
    // End:0x90
    if(DestroyedMesh != none)
    {
        Mesh.SetSkeletalMesh(DestroyedMesh);
    }
    // End:0xAF
    if(DestroyedPhysicsAsset != none)
    {
        Mesh.SetPhysicsAsset(DestroyedPhysicsAsset);
    }
    ToggleCompassStatus(false);
    DestroyWeapons();
    SetDriving(false);
    bDriving = false;
    //return;    
}

function OnSetVehicleTargetingMode(SeqAct_SetVehicleTargetingMode Action)
{
    local MOHAVehicleController VehicleController;
    local SeqVar_Object ObjVar;
    local Actor WeaponTarget;

    VehicleController = MOHAVehicleController(Controller);
    // End:0xD7
    if(VehicleController != none)
    {
        // End:0x73
        foreach Action.LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Weapon Target")
        {
            WeaponTarget = Actor(ObjVar.GetObjectValue());
            // End:0x72
            if(WeaponTarget != none)
            {
                // End:0x73
                break;
            }            
        }        
        VehicleController.SetTargetingMode(int(Action.VehicleWeaponType), Action.TargetingMode, WeaponTarget, Action.bStopWhenEngagingVisiblePlayer, Action.bDontFire, Action.bTurnTowardsPlayerWhenStopped);
    }
    //return;    
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    // End:0x28
    if(Action.InputLinks[1].bHasImpulse)
    {
        DisableTank();
    }
    //return;    
}

simulated function InitWeapons()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x1E3 [Loop If]
    if(I < WeaponsInfo.Length)
    {
        WeaponsInfo[I].Weapon = MOHAVehicleWeapon(InvManager.CreateInventory(WeaponsInfo[I].WeaponClass));
        // End:0x1D9
        if(WeaponsInfo[I].Weapon != none)
        {
            WeaponsInfo[I].Weapon.GiveTo(self);
            WeaponsInfo[I].Weapon.SetBase(self);
            WeaponsInfo[I].Weapon.hardPointIndex = I;
            WeaponsInfo[I].Weapon.owningVehicle = self;
            WeaponsInfo[I].PitchControl = SkelControlSingleBone(Mesh.FindSkelControl(WeaponsInfo[I].PitchControlName));
            WeaponsInfo[I].YawControl = SkelControlSingleBone(Mesh.FindSkelControl(WeaponsInfo[I].YawControlName));
            // End:0x1D9
            if(WeaponsInfo[I].Weapon.AttachmentClass != none)
            {
                WeaponsInfo[I].WeaponAttachment = __NFUN_278__(WeaponsInfo[I].Weapon.AttachmentClass, self);
            }
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated function WeaponAttachment GetWeaponAttachment(EALAWeapon EALAWeap)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x56 [Loop If]
    if(I < WeaponsInfo.Length)
    {
        // End:0x4C
        if(WeaponsInfo[I].Weapon == EALAWeap)
        {
            return WeaponsInfo[I].WeaponAttachment;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return none;
    //return ReturnValue;    
}

simulated function UpdateWeaponControls(int I, float fTargetYaw, float fTargetPitch, float DeltaTime, out float fCurrentYaw, out float fCurrentPitch)
{
    local Rotator rTargetDelta, rDeltaRot, rInitialRot;
    local float fYawAcceleration, fPitchAcceleration, fDesiredYawVelocity, fDesiredPitchVelocity, fVehicleYawSpeed, fYawSign,
	    fPitchSign;

    // End:0x28
    if((I > WeaponsInfo.Length) || !WeaponEnabled(I))
    {
        return;
    }
    ClampTargetRotation(I, fTargetYaw, fTargetPitch);
    rInitialRot = WeaponsInfo[I].CurrentRotation;
    rTargetDelta.Yaw = NormalizeRotAxis(int(fTargetYaw - float(WeaponsInfo[I].CurrentRotation.Yaw)));
    rTargetDelta.Pitch = NormalizeRotAxis(int(fTargetPitch - float(WeaponsInfo[I].CurrentRotation.Pitch)));
    fYawSign = ((rTargetDelta.Yaw > 0) ? 1.0000000 : -1.0000000);
    fPitchSign = ((rTargetDelta.Pitch > 0) ? 1.0000000 : -1.0000000);
    fVehicleYawSpeed = float(NormalizeRotAxis(Rotation.Yaw - rRotDelayedHalfToOneSecond.Yaw)) / ((WorldInfo.TimeSeconds - fLastRotDelayTime) + 0.5000000);
    fDesiredYawVelocity = FClamp((Sqrt(Abs((2.0000000 * float(rTargetDelta.Yaw)) * float(WeaponsInfo[I].TurretAccelerationRate.Yaw))) * fYawSign) - fVehicleYawSpeed, float(-WeaponsInfo[I].TurretMaxRotationRate.Yaw), float(WeaponsInfo[I].TurretMaxRotationRate.Yaw));
    fDesiredPitchVelocity = FClamp(Sqrt(Abs((2.0000000 * float(rTargetDelta.Pitch)) * float(WeaponsInfo[I].TurretAccelerationRate.Pitch))) * fPitchSign, float(-WeaponsInfo[I].TurretMaxRotationRate.Pitch), float(WeaponsInfo[I].TurretMaxRotationRate.Pitch));
    fYawAcceleration = float(((fDesiredYawVelocity > float(WeaponsInfo[I].CurrentRotVelocity.Yaw)) ? WeaponsInfo[I].TurretAccelerationRate.Yaw : -WeaponsInfo[I].TurretAccelerationRate.Yaw));
    fPitchAcceleration = float(((fDesiredPitchVelocity > float(WeaponsInfo[I].CurrentRotVelocity.Pitch)) ? WeaponsInfo[I].TurretAccelerationRate.Pitch : -WeaponsInfo[I].TurretAccelerationRate.Pitch));
    WeaponsInfo[I].CurrentRotVelocity.Yaw = int(FClamp(float(WeaponsInfo[I].CurrentRotVelocity.Yaw) + (fYawAcceleration * DeltaTime), -Abs(fDesiredYawVelocity), Abs(fDesiredYawVelocity)));
    WeaponsInfo[I].CurrentRotVelocity.Pitch = int(FClamp(float(WeaponsInfo[I].CurrentRotVelocity.Pitch) + (fPitchAcceleration * DeltaTime), -Abs(fDesiredPitchVelocity), Abs(fDesiredPitchVelocity)));
    rDeltaRot.Yaw = Clamp(int(float(WeaponsInfo[I].CurrentRotVelocity.Yaw) * DeltaTime), int(-Abs(float(rTargetDelta.Yaw))), int(Abs(float(rTargetDelta.Yaw))));
    rDeltaRot.Pitch = Clamp(int(float(WeaponsInfo[I].CurrentRotVelocity.Pitch) * DeltaTime), int(-Abs(float(rTargetDelta.Pitch))), int(Abs(float(rTargetDelta.Pitch))));
    WeaponsInfo[I].CurrentRotation.Yaw = NormalizeRotAxis(WeaponsInfo[I].CurrentRotation.Yaw + rDeltaRot.Yaw);
    WeaponsInfo[I].CurrentRotation.Pitch = NormalizeRotAxis(WeaponsInfo[I].CurrentRotation.Pitch + rDeltaRot.Pitch);
    // End:0x68D
    if(WeaponsInfo[I].YawControl == WeaponsInfo[I].PitchControl)
    {
        WeaponsInfo[I].YawControl.BoneRotation = GetControlRotation(float(WeaponsInfo[I].CurrentRotation.Pitch), float(WeaponsInfo[I].CurrentRotation.Yaw), 0.0000000, WeaponsInfo[I].YawControl.BoneRotationSpace);        
    }
    else
    {
        WeaponsInfo[I].YawControl.BoneRotation = GetControlRotation(0.0000000, float(WeaponsInfo[I].CurrentRotation.Yaw), 0.0000000, WeaponsInfo[I].YawControl.BoneRotationSpace);
        WeaponsInfo[I].PitchControl.BoneRotation = GetControlRotation(float(WeaponsInfo[I].CurrentRotation.Pitch), 0.0000000, 0.0000000, WeaponsInfo[I].PitchControl.BoneRotationSpace);
    }
    WeaponsInfo[I].Weapon.UpdateTurretSounds(WeaponsInfo[I].CurrentRotation.Yaw != rInitialRot.Yaw, WeaponsInfo[I].CurrentRotation.Pitch != rInitialRot.Pitch, rTargetDelta);
    fCurrentYaw = float(WeaponsInfo[I].CurrentRotation.Yaw);
    fCurrentPitch = float(WeaponsInfo[I].CurrentRotation.Pitch);
    //return;    
}

simulated function Rotator GetControlRotation(float fPitch, float fYaw, float fRoll, SkelControlBase.EBoneControlSpace EBoneSpace)
{
    local Rotator rRot;

    // End:0x3E
    if(int(EBoneSpace) == int(3))
    {
        Class'MOHAUtilities'.static.AssignRotator(rRot, fYaw, -fRoll, -fPitch);        
    }
    else
    {
        Class'MOHAUtilities'.static.AssignRotator(rRot, fPitch, fYaw, fRoll);
    }
    return rRot;
    //return ReturnValue;    
}

simulated function ClampTargetRotation(int I, out float fTargetYaw, out float fTargetPitch)
{
    // End:0x12
    if(I > WeaponsInfo.Length)
    {
        return;
    }
    fTargetYaw = float(NormalizeRotAxis(int(fTargetYaw)));
    fTargetPitch = float(NormalizeRotAxis(int(fTargetPitch)));
    fTargetYaw = FClamp(fTargetYaw, float(WeaponsInfo[I].MinRot.Yaw), float(WeaponsInfo[I].MaxRot.Yaw));
    fTargetPitch = FClamp(fTargetPitch, float(WeaponsInfo[I].MinRot.Pitch), float(WeaponsInfo[I].MaxRot.Pitch));
    //return;    
}

simulated function bool WeaponSupportsRotation(int I, Rotator rRot)
{
    local float fYaw, fPitch;

    // End:0x12
    if(I > WeaponsInfo.Length)
    {
        return false;
    }
    fYaw = float(NormalizeRotAxis(rRot.Yaw));
    fPitch = float(NormalizeRotAxis(rRot.Pitch));
    return (((fYaw > float(WeaponsInfo[I].MinRot.Yaw)) && fYaw < float(WeaponsInfo[I].MaxRot.Yaw)) && fPitch > float(WeaponsInfo[I].MinRot.Pitch)) && fPitch < float(WeaponsInfo[I].MaxRot.Pitch);
    //return ReturnValue;    
}

simulated function float GetWeaponEngagementDist(int I, bool bIsPlayer)
{
    // End:0x16
    if(I > WeaponsInfo.Length)
    {
        return 0.0000000;
    }
    return ((bIsPlayer) ? WeaponsInfo[I].fMaxEngagementDist_Player : WeaponsInfo[I].fMaxEngagementDist_NPC);
    //return ReturnValue;    
}

simulated function bool GetAimSocketPos(int iWeaponIndex, out Vector vAimSocketPos)
{
    // End:0x3C
    if(WeaponsInfo.Length > iWeaponIndex)
    {
        Mesh.GetSocketWorldLocationAndRotation(WeaponsInfo[iWeaponIndex].AimSocketName, vAimSocketPos);
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function int GetNumWeapons()
{
    return WeaponsInfo.Length;
    //return ReturnValue;    
}

simulated function bool WeaponEnabled(int I)
{
    return (Health > 0) && !WeaponsInfo[I].bDestroyed;
    //return ReturnValue;    
}

simulated function FireWeapon(int iWeaponIndex)
{
    // End:0x86
    if(WeaponsInfo.Length > iWeaponIndex)
    {
        // End:0x61
        if(WeaponsInfo[iWeaponIndex].Weapon.GetStateName() == 'Inactive')
        {
            WeaponsInfo[iWeaponIndex].Weapon.GotoState('Active');
        }
        WeaponsInfo[iWeaponIndex].Weapon.StartFire(0);
    }
    //return;    
}

simulated function OnWeaponFired(MOHAVehicleWeapon Weap)
{
    GotoState('Fire');
    // End:0x2A
    if(Weap.bShakeCameraOnFire)
    {
        TurretFireCameraShake();
    }
    //return;    
}

simulated function StopFiringWeapon(int iWeaponIndex)
{
    // End:0x78
    if(WeaponsInfo.Length > iWeaponIndex)
    {
        // End:0x78
        if((WeaponsInfo[iWeaponIndex].Weapon != none) && WeaponsInfo[iWeaponIndex].Weapon.IsFiring())
        {
            WeaponsInfo[iWeaponIndex].Weapon.StopFire(0);
        }
    }
    //return;    
}

function GetHardPointLocationAndRotation(int Index, out Vector hardPointLocation, out Rotator hardPointRotation)
{
    // End:0x3E
    if(Index < WeaponsInfo.Length)
    {
        Mesh.GetSocketWorldLocationAndRotation(WeaponsInfo[Index].AttachSocket, hardPointLocation, hardPointRotation);
    }
    //return;    
}

function Vector GetWeaponLocation(int Index)
{
    local Vector vWeapPos;

    Mesh.GetSocketWorldLocationAndRotation(WeaponsInfo[Index].AttachSocket, vWeapPos);
    return vWeapPos;
    //return ReturnValue;    
}

simulated function InitDestructibleParts()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x56 [Loop If]
    if(I < PartInfo.Length)
    {
        PartInfo[I].Mesh.SetSkeletalMesh(PartInfo[I].Pristine_Mesh);
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function CheckForDestroyedPart(int Damage, name DamagedBoneName, class<DamageType> DamageType, Controller InstigatedBy, Actor DamageCauser)
{
    local int I;
    local bool bMatchingDamageType;
    local Vector vPartOrigin, vExplosionToPart_WS, vExplosionToPart_AS;

    // End:0x106
    if(!ClassIsChildOf(DamageType, Class'MOHAExplosiveDamageType'))
    {
        I = 0;
        J0x19:

        // End:0x103 [Loop If]
        if(I < PartInfo.Length)
        {
            // End:0x40
            if(!PartCanBeIndividuallyDestroyed(I))
            {
                // [Explicit Continue]
                goto J0xF9;
            }
            bMatchingDamageType = Class'MOHAUtilities'.static.MatchingDamageType(MyDamageTypes, DamageType);
            // End:0xF9
            if((bMatchingDamageType && MatchingBoneName(PartInfo[I].DamageBoneNames, DamagedBoneName)) && PartInfo[I].iHealth > 0)
            {
                PartInfo[I].iHealth -= Damage;
                // End:0xF9
                if(PartInfo[I].iHealth <= 0)
                {
                    DestroyPart(I);
                }
            }
            J0xF9:

            I++;
            // [Loop Continue]
            goto J0x19;
        }        
    }
    else
    {
        // End:0x29D
        if(DamageCauser != none)
        {
            I = 0;
            J0x118:

            // End:0x29D [Loop If]
            if(I < PartInfo.Length)
            {
                // End:0x13F
                if(!PartCanBeIndividuallyDestroyed(I))
                {
                    // [Explicit Continue]
                    goto J0x293;
                }
                // End:0x293
                if(Mesh.GetSocketWorldLocationAndRotation(PartInfo[I].SocketName, vPartOrigin))
                {
                    vExplosionToPart_WS = DamageCauser.Location - vPartOrigin;
                    vExplosionToPart_AS = Class'MOHAUtilities'.static.InverseRotateVector(vExplosionToPart_WS, Rotation);
                    // End:0x293
                    if(((Abs(vExplosionToPart_AS.X) < PartInfo[I].vExtents.X) && Abs(vExplosionToPart_AS.Y) < PartInfo[I].vExtents.Y) && Abs(vExplosionToPart_AS.Z) < PartInfo[I].vExtents.Z)
                    {
                        PartInfo[I].iHealth -= Damage;
                        // End:0x293
                        if(PartInfo[I].iHealth <= 0)
                        {
                            DestroyPart(I);
                        }
                    }
                }
                J0x293:

                I++;
                // [Loop Continue]
                goto J0x118;
            }
        }
    }
    //return;    
}

function bool PartCanBeIndividuallyDestroyed(int iPart)
{
    return true;
    //return ReturnValue;    
}

function bool MatchingBoneName(array<name> BoneNames, name DamagedBoneName)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x38 [Loop If]
    if(I < BoneNames.Length)
    {
        // End:0x2E
        if(BoneNames[I] == DamagedBoneName)
        {
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    //return ReturnValue;    
}

function DestroyAllParts()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x30 [Loop If]
    if(I < PartInfo.Length)
    {
        DestroyPart(I);
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function DestroyPart(int I)
{
    PartInfo[I].iHealth = 0;
    PartInfo[I].Mesh.SetSkeletalMesh(PartInfo[I].Destroyed_Mesh);
    // End:0x117
    if(PartInfo[I].ExplosionParticleSystem != none)
    {
        PartInfo[I].ExplosionEmitter = new (Outer) Class'Engine.ParticleSystemComponent';
        PartInfo[I].ExplosionEmitter.SetTemplate(PartInfo[I].ExplosionParticleSystem);
        Mesh.AttachComponentToSocket(PartInfo[I].ExplosionEmitter, PartInfo[I].SocketName);
        PartInfo[I].ExplosionEmitter.ActivateSystem();
    }
    // End:0x18B
    if(PartInfo[I].DestructionSound != none)
    {
        // End:0x16C
        if(CollBoxVolumeEmitter != none)
        {
            PlaySound(PartInfo[I].DestructionSound,,,, CollBoxVolumeEmitter.Location);            
        }
        else
        {
            PlaySound(PartInfo[I].DestructionSound);
        }
    }
    //return;    
}

function bool CanEnterVehicle(Pawn P)
{
    // End:0x0E
    if(bImmobile)
    {
        return false;        
    }
    else
    {
        return super(Vehicle).CanEnterVehicle(P);
    }
    //return ReturnValue;    
}

simulated function Tick(float DeltaTime)
{
    super(Actor).Tick(DeltaTime);
    UpdateEngineSound(DeltaTime);
    UpdateTurnSound(DeltaTime);
    // End:0x4C
    if(!bAddedVehicleToCompass && Health > 0)
    {
        ToggleCompassStatus(true);
    }
    //return;    
}

simulated function SetEngineSoundState(MOHAVehicle.EEngineSoundState NextEngineSoundState)
{
    // End:0x15
    if(int(CurrentEngineSoundState) == int(NextEngineSoundState))
    {
        return;
    }
    CurrentEngineSoundState = NextEngineSoundState;
    EngineSound.Stop();
    // End:0x6D
    if(EngineSoundCues[int(CurrentEngineSoundState)] != none)
    {
        EngineSound.SoundCue = EngineSoundCues[int(CurrentEngineSoundState)];
        EngineSound.Play();
    }
    //return;    
}

simulated function SetTurnSoundState(MOHAVehicle.ETurnSoundState NextTurnSoundState)
{
    // End:0x15
    if(int(CurrentTurnSoundState) == int(NextTurnSoundState))
    {
        return;
    }
    CurrentTurnSoundState = NextTurnSoundState;
    // End:0x42
    if(int(CurrentTurnSoundState) == int(1))
    {
        TurnSound.Play();        
    }
    else
    {
        TurnSound.Stop();
    }
    //return;    
}

simulated function StartEngineSound()
{
    SetEngineSoundState(2);
    ClearTimer('StartEngineSound');
    ClearTimer('StopEngineSound');
    //return;    
}

simulated function StopEngineSound()
{
    SetEngineSoundState(0);
    ClearTimer('StartEngineSound');
    ClearTimer('StopEngineSound');
    //return;    
}

simulated function UpdateEngineSound(float DeltaTime)
{
    local float fDesiredEnginePitch, fPerc;
    local MOHAVehicle.EEngineSoundState eDesiredState;

    // End:0x12
    if(int(CurrentEngineSoundState) <= int(0))
    {
        return;
    }
    // End:0x2E
    if(VSize(Velocity) < fIdleSpeedThreshold)
    {
        eDesiredState = 2;        
    }
    else
    {
        eDesiredState = 1;
    }
    // End:0x53
    if(int(eDesiredState) != int(CurrentEngineSoundState))
    {
        iEngineSoundCriteriaMetTicks++;        
    }
    else
    {
        iEngineSoundCriteriaMetTicks = 0;
    }
    // End:0x7C
    if(iEngineSoundCriteriaMetTicks >= 5)
    {
        iEngineSoundCriteriaMetTicks = 0;
        SetEngineSoundState(eDesiredState);
    }
    fDesiredEnginePitch = 1.0000000;
    // End:0xDA
    if(int(CurrentEngineSoundState) == int(1))
    {
        fPerc = FClamp(VSize(Velocity) / fMaxSpeed, 0.0000000, 1.0000000);
        fDesiredEnginePitch = fMinEngineCruisePitchMult + ((fMaxEngineCruisePitchMult - fMinEngineCruisePitchMult) * fPerc);        
    }
    else
    {
        // End:0x117
        if(int(CurrentEngineSoundState) == int(2))
        {
            fPerc = Abs(Throttle);
            fDesiredEnginePitch = fMinEngineIdlePitchMult + ((fMaxEngineIdlePitchMult - fMinEngineIdlePitchMult) * fPerc);
        }
    }
    fCurrentEnginePitch = Class'MOHAUtilities'.static.LagValue_Constant(fCurrentEnginePitch, fDesiredEnginePitch, fEnginePitchChangeRate, DeltaTime);
    EngineSound.PitchMultiplier = fCurrentEnginePitch;
    // End:0x180
    if(CollBoxVolumeEmitter != none)
    {
        EngineSound.Location = CollBoxVolumeEmitter.Location;
    }
    //return;    
}

simulated function UpdateTurnSound(float fDeltaTime)
{
    local float fRotationRate;
    local MOHAVehicle.ETurnSoundState eDesiredState;

    fRotationRate = ((fDeltaTime > 0.0000000) ? Abs(float(Rotation.Yaw) - fLastYaw) / fDeltaTime : 0.0000000);
    fLastYaw = float(Rotation.Yaw);
    eDesiredState = (((Abs(fRotationRate) > 300.0000000) && VSize(Velocity) < 20.0000000) ? 1 : 0);
    // End:0xA1
    if(int(eDesiredState) != int(CurrentTurnSoundState))
    {
        iTurnSoundCriteriaMetTicks++;        
    }
    else
    {
        iTurnSoundCriteriaMetTicks = 0;
    }
    // End:0xCA
    if(iTurnSoundCriteriaMetTicks >= 3)
    {
        iTurnSoundCriteriaMetTicks = 0;
        SetTurnSoundState(eDesiredState);
    }
    // End:0xF2
    if(CollBoxVolumeEmitter != none)
    {
        TurnSound.Location = CollBoxVolumeEmitter.Location;
    }
    //return;    
}

simulated function GetMatchingWeaponInfo(Weapon W, out Vector vPos, out Rotator rRot)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x5B [Loop If]
    if(I < WeaponsInfo.Length)
    {
        // End:0x51
        if(WeaponsInfo[I].Weapon == W)
        {
            GetHardPointLocationAndRotation(I, vPos, rRot);
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated function Vector GetWeaponStartTraceLocation(optional Weapon CurrentWeapon)
{
    local Vector vPos;
    local Rotator rRot;

    GetMatchingWeaponInfo(CurrentWeapon, vPos, rRot);
    return vPos;
    //return ReturnValue;    
}

simulated function Rotator GetAdjustedAimFor(Weapon W, Vector StartFireLoc)
{
    local Vector vPos;
    local Rotator rRot;

    GetMatchingWeaponInfo(W, vPos, rRot);
    return rRot;
    //return ReturnValue;    
}

simulated function SetImmobile(bool bIsImmobile)
{
    bImmobile = bIsImmobile;
    // End:0x20
    if(bImmobile)
    {
        StopEngineSoundTimed();
    }
    //return;    
}

simulated function TurretFireCameraShake()
{
    local PlayerController PC;
    local float fShakeMag;
    local ViewShakeInfo NewViewShake;

    // End:0x105
    foreach LocalPlayerControllers(PC)
    {
        // End:0x104
        if(((MOHAPlayerController(PC) != none) && PC.Pawn != none) && int(PC.Pawn.Physics) == int(1))
        {
            fShakeMag = FClamp(1.0000000 - (VSize(Location - PC.Pawn.Location) / fTurretFireShakeRadius), 0.0000000, 1.0000000);
            // End:0x104
            if(fShakeMag > 0.0000000)
            {
                NewViewShake = TurretFireShake;
                NewViewShake.OffsetMag *= fShakeMag;
                NewViewShake.RotMag *= fShakeMag;
                MOHAPlayerPawn(PC.Pawn).ShakeView(NewViewShake);
            }
        }        
    }    
    //return;    
}

event StreamOutCleanup()
{
    DestroySpawnedActors();
    //return;    
}

simulated event Destroyed()
{
    super.Destroyed();
    DestroySpawnedActors();
    //return;    
}

function DestroySpawnedActors()
{
    // End:0x17
    if(Driver != none)
    {
        Driver.Destroy();
    }
    // End:0x2E
    if(Controller != none)
    {
        Controller.Destroy();
    }
    // End:0x45
    if(CollBoxVolumeEmitter != none)
    {
        CollBoxVolumeEmitter.Destroy();
    }
    DestroyWeapons();
    //return;    
}

function DestroyWeapons()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x8F [Loop If]
    if(I < WeaponsInfo.Length)
    {
        // End:0x4E
        if(WeaponsInfo[I].Weapon != none)
        {
            WeaponsInfo[I].Weapon.Destroy();
        }
        // End:0x85
        if(WeaponsInfo[I].WeaponAttachment != none)
        {
            WeaponsInfo[I].WeaponAttachment.Destroy();
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

auto state Idle
{
    function BeginState(name PreviousStateName)
    {
        CurrentActivity = 0;
        PlaybackLength = 0.0000000;
        //return;        
    }
    stop;    
}

state Fire
{
    function BeginState(name PreviousStateName)
    {
        CurrentActivity = 1;
        PlaybackLength = FireAnimationTime;
        SetTimer(PlaybackLength, true, 'DoneFiring');
        //return;        
    }

    function DoneFiring()
    {
        GotoState('Idle');
        //return;        
    }
    stop;    
}

defaultproperties
{
    MyDamageTypes[0]=Class'MOHADamageType'
    bSlowDownWhenTurning=true
    bUseCollBoxVolumeEmitter=true
    MaxTurnSpeed=100.0000000
    fMaxSpeed=160.0000000
    PawnSide=2
    FireAnimationTime=4.0000000
    // Reference: MOHAGraph'Default__MOHAVehicle.ThrottleGraph0'
    begin object name=ThrottleGraph0 class=Class'MOHAGraph'
    end object
    throttleGraph=ThrottleGraph0
    EngineSoundCues[1]=SoundCue'Aud_GCm_FakeWAV.Vehicles.Veh_Panzer_Move_LP'
    EngineSoundCues[2]=SoundCue'Aud_GCm_FakeWAV.Vehicles.Veh_Panzer_Idle_LP'
    fMinEngineCruisePitchMult=0.8000000
    fMaxEngineCruisePitchMult=1.0000000
    fMinEngineIdlePitchMult=1.0000000
    fMaxEngineIdlePitchMult=1.2000000
    fEnginePitchChangeRate=0.5000000
    fIdleSpeedThreshold=25.0000000
    // Reference: AudioComponent'Default__MOHAVehicle.VehicleTurnSound'
    begin object name=VehicleTurnSound class=Class'Engine.AudioComponent'
        SoundCue=SoundCue'Aud_GCm_FakeWAV.Vehicles.Veh_Panzer_Rotate_LP'
        bUseOwnerLocation=false
    end object
    TurnSound=VehicleTurnSound
    fTurretFireShakeRadius=4000.0000000
    TurretFireShake=(OffsetMag=(X=2.5000000,Y=0.0000000,Z=8.0000000),OffsetRate=(X=10.0000000,Y=10.0000000,Z=10.0000000),OffsetTime=4.0000000,RotMag=(X=0.0000000,Y=0.0000000,Z=0.0000000),RotRate=(X=0.0000000,Y=0.0000000,Z=0.0000000),RotTime=0.0000000,bDecayRotOverTime=false,bDecayOffsetOverTime=true,OffsetStartTime=0.0000000,RotStartTime=0.0000000)
    // Reference: RB_StayUprightSetup'Default__MOHAVehicle.MyStayUprightSetup'
    begin object name=MyStayUprightSetup
    end object
    StayUprightConstraintSetup=MyStayUprightSetup
    // Reference: RB_ConstraintInstance'Default__MOHAVehicle.MyStayUprightConstraintInstance'
    begin object name=MyStayUprightConstraintInstance
    end object
    StayUprightConstraintInstance=MyStayUprightConstraintInstance
    // Reference: AudioComponent'Default__MOHAVehicle.VehicleEngineSound'
    begin object name=VehicleEngineSound class=Class'Engine.AudioComponent'
        SoundCue=SoundCue'Aud_GCm_FakeWAV.Vehicles.Veh_Panzer_Move_LP'
        bUseOwnerLocation=false
    end object
    EngineSound=VehicleEngineSound
    PathSearchType=2
    Health=1500
    ControllerClass=Class'MOHAVehicleController'
    // Reference: SkeletalMeshComponent'Default__MOHAVehicle.SVehicleMesh'
    begin object name=SVehicleMesh
        bUpdateSkelWhenNotRendered=true
    end object
    Mesh=SVehicleMesh
    // Reference: CylinderComponent'Default__MOHAVehicle.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    InventoryManagerClass=Class'MOHAInventoryManager'
    Components[0]=CollisionCylinder
    Components[1]=SVehicleMesh
    Components[2]=VehicleEngineSound
    Components[3]=VehicleTurnSound
    ActorType=29
    CollisionComponent=SVehicleMesh
    SupportedEvents=/* Array type was not detected. */
}