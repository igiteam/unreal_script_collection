class SkyWeaponMounted extends SkySkeletalMeshActor
    native;

enum EFiringMode
{
    EFM_Normal,                     // 0
    EFM_Hijacking,                  // 1
    EFM_MAX                         // 2
};

enum EFiringState
{
    EFS_Idle,                       // 0
    EFS_Polling,                    // 1
    EFS_Charging,                   // 2
    EFS_Firing,                     // 3
    EFS_CoolingDown,                // 4
    EFS_MAX                         // 5
};

struct native LoopWeaponSound
{
    var() SoundCue Sound;
    var export editinline AudioComponent Component;

    structdefaultproperties
    {
        Sound=none
        Component=none
    }
};

var(Weapon) name ProjSocket;
var(Weapon) array<SkyProjectile> ProjArchetype;
var(Weapon) float WeaponRange;
var(Weapon) float Momentum;
var(Weapon) array<int> Damage;
var(Weapon) class<DamageType> DamageType;
var(Weapon) array<float> BurstFireInterval;
var(Weapon) array<float> ValidFiringAngle;
var(Weapon) array<float> SpreadYaw;
var(Weapon) array<float> SpreadPitch;
var(Weapon) array<float> ChargeUpTime;
var(Weapon) float HijackPollTime;
var(Weapon) float HijackBurstFireTime;
var(Weapon) float HijackCoolDownTime;
var(Effects) array<MaterialImpactEffect> ImpactEffects;
var(Effects) MaterialImpactEffect DefaultImpactEffect;
var(Effects) float MaxImpactEffectDistance;
var export editinline deprecated SkyExplosionLight MuzzleFlashLight;
var deprecated class<SkyExplosionLight> MuzzleFlashLightClass;
var(Effects) name MuzzleFlashSocket;
var(Effects) bool bMuzzleFlashPSCLoops;
var transient bool bIsFiring;
var transient bool bAllowFire;
var transient bool bHasAttemptedFiring;
var transient bool bIsCoolingDown;
var(Effects) ParticleSystem MuzzleFlashPSCTemplate;
var deprecated Color MuzzleFlashColor;
var(Effects) export editinline StaticMeshComponent MuzzleFlashMesh;
var(Effects) float MuzzleFlashDuration;
var(Effects) ParticleSystem ChargeUpTemplate;
var(Effects) name ChargeUpSocket;
var(Sounds) SoundCue WeaponFireSnd;
var(Sounds) array<LoopWeaponSound> WeaponChargeUpSnd;
var transient Vector TraceStartLoc;
var transient Vector TraceEndLoc;
var transient Vector TraceHitLoc;
var transient Rotator TraceDir;
var transient Actor Target;
var transient SkyWeaponMounted.EFiringMode FiringMode;
var transient SkyWeaponMounted.EFiringState FiringState;
var transient array<float> ValidFiringAngleCos;
var export editinline transient ParticleSystemComponent MuzzleFlashPSC;
var transient SkyEmitter ChargeUpEmitter;
var transient float ChargeUpTimer;
var transient float HijackPollTimer;
var transient float HijackBurstFireTimer;
var transient float HijackCoolDownTimer;
var transient float BurstFireIntervalTimer;
var transient name ValidGripId;

// Export USkyWeaponMounted::execSetUpMuzzleFlash(FFrame&, void* const)
native function SetUpMuzzleFlash();

// Export USkyWeaponMounted::execFireProjectile(FFrame&, void* const)
native function FireProjectile();

simulated function PostBeginPlay()
{
    ValidFiringAngleCos[0] = Cos((ValidFiringAngle[0] / 180.0000000) * 3.1415930);
    ValidFiringAngleCos[1] = Cos((ValidFiringAngle[1] / 180.0000000) * 3.1415930);
    SetUpMuzzleFlash();
    super.PostBeginPlay();
    CreateAudio();
    //return;    
}

simulated function CreateAudio()
{
    local int I;

    I = 0;
    J0x07:

    // End:0xE3 [Loop If]
    if(I < WeaponChargeUpSnd.Length)
    {
        // End:0xD9
        if(WeaponChargeUpSnd[I].Sound != none)
        {
            WeaponChargeUpSnd[I].Component = new (self) Class'Engine.AudioComponent';
            WeaponChargeUpSnd[I].Component.bStopWhenOwnerDestroyed = true;
            WeaponChargeUpSnd[I].Component.SoundCue = WeaponChargeUpSnd[I].Sound;
            SkyPawn(Owner).AttachComponent(WeaponChargeUpSnd[I].Component);
        }
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local Canvas Canvas;

    // End:0x21C
    if(HUD.ShouldDisplayDebug('AI') || HUD.ShouldDisplayDebug('Gangs'))
    {
        Canvas = HUD.Canvas;
        Canvas.DrawColor.B = 255;
        Canvas.DrawText("Target: " $ string(Target), false);
        out_YPos += out_YL;
        Canvas.DrawText("FiringMode: " $ string(FiringMode), false);
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.DrawText("bIsFiring: " $ string(bIsFiring), false);
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.DrawText("StartDelayedWeaponFire: " $ string(IsTimerActive('StartDelayedWeaponFire')), false);
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        // End:0x21C
        if(HUD.ShouldDisplayDebug('Gangs'))
        {
            Canvas.DrawText("Gang: " $ string(GangName), false);
            out_YPos += out_YL;
            Canvas.SetPos(4.0000000, out_YPos);
        }
    }
    //return;    
}

// Export USkyWeaponMounted::execStartWeaponFire(FFrame&, void* const)
native function StartWeaponFire();

// Export USkyWeaponMounted::execEndWeaponFire(FFrame&, void* const)
native function EndWeaponFire();

// Export USkyWeaponMounted::execDebugStartWeaponFire(FFrame&, void* const)
native function DebugStartWeaponFire();

// Export USkyWeaponMounted::execDebugEndWeaponFire(FFrame&, void* const)
native function DebugEndWeaponFire();

// Export USkyWeaponMounted::execCanHitTarget(FFrame&, void* const)
native function bool CanHitTarget();

// Export USkyWeaponMounted::execProjectileFire(FFrame&, void* const)
native simulated function Projectile ProjectileFire();

// Export USkyWeaponMounted::execCreateProjectile(FFrame&, void* const)
native simulated function Projectile CreateProjectile(class<Projectile> SpawnClass, optional Actor SpawnOwner, optional name SpawnTag, optional Vector SpawnLocation, optional Rotator SpawnRotation, optional Actor ActorTemplate, optional bool bNoCollisionFail);

// Export USkyWeaponMounted::execCalcWeaponFire(FFrame&, void* const)
native simulated function ImpactInfo CalcWeaponFire(Vector StartTrace, Vector EndTrace, optional out array<ImpactInfo> ImpactList);

simulated event SetTarget(Actor NewTarget)
{
    Target = NewTarget;
    //return;    
}

// Export USkyWeaponMounted::execSetFiringMode(FFrame&, void* const)
native simulated function SetFiringMode(SkyWeaponMounted.EFiringMode NewFiringMode);

// Export USkyWeaponMounted::execAddSpread(FFrame&, void* const)
native simulated function Rotator AddSpread(Rotator BaseAim);

// Export USkyWeaponMounted::execGenerateParametricSpread(FFrame&, void* const)
native function Rotator GenerateParametricSpread(Rotator BaseAim, float YawParam, float PitchParam);

// Export USkyWeaponMounted::execMuzzleFlashTimer(FFrame&, void* const)
native simulated function MuzzleFlashTimer();

simulated event CauseMuzzleFlash()
{
    // End:0x51
    if(MuzzleFlashPSC != none)
    {
        // End:0x51
        if(!bMuzzleFlashPSCLoops || MuzzleFlashPSC.bWasDeactivated)
        {
            MuzzleFlashPSC.SetTemplate(MuzzleFlashPSCTemplate);
            MuzzleFlashPSC.ActivateSystem();
        }
    }
    // End:0x6D
    if(MuzzleFlashMesh != none)
    {
        MuzzleFlashMesh.SetHidden(false);
    }
    SetTimer(MuzzleFlashDuration, false, 'MuzzleFlashTimer');
    //return;    
}

// Export USkyWeaponMounted::execStopMuzzleFlash(FFrame&, void* const)
native simulated function StopMuzzleFlash();
