class SmallArmsAttachment extends WeaponAttachment
    abstract
    config(Weapon)
    notplaceable
    hidecategories(Navigation);

struct WeaponSockets
{
    var name BarrelTip;
    var name ShellEject;

    structdefaultproperties
    {
        BarrelTip="None"
        ShellEject="None"
    }
};

var(Tuning_MuzzleFlash) config ParticleSystemInfo MuzzleFlashParticleSystemTemplate;
var(Tuning_MuzzleFlash) config ParticleSystemInfo NPCMuzzleFlashParticleSystemTemplate;
var(Tuning_MuzzleFlash) config ParticleSystemInfo MuzzleSmokeParticleSystemTemplate;
var(Tuning_ShellEject) config ParticleSystemInfo EjectionPortSmokeParticleSystemTemplate;
var export editinline ParticleSystemComponent MuzzleFlashPSComponent;
var(Tuning_MuzzleFlash) Color MuzzleFlashColor;
var export editinline ParticleSystemComponent MuzzleSmokePSComponent;
var export editinline ParticleSystemComponent EjectionPortSmokePSComponent;
var export editinline ParticleSystemComponent HitspangPSComponent;
var ParticleSystem LastParticleTemplate;
var WeaponSockets CurrentWeaponSockets;
var config float BulletSpeed;
var config float MaxLength;
var config float MinLength;
var config ParticleSystemInfo BeamTemplate[2];
var config ParticleSystemInfo NPCBeamTemplate[2];
var export editinline ParticleSystemComponent BeamEmitter[2];
var name BeamSockets[2];
var name StartPointParamName;
var name EndPointParamName;
var(Tuning_Tracer) config int TracerFrequency;
var(Tuning_Tracer) byte CreateTracers[2];
var(Tuning_Sounds) MOHAPhysicalMaterialProperty.EImpactType ShellImpactType;
var int TracerCount[2];
var bool bTracerTargetPt;
var bool bUseShellProjectiles;
var bool bStartedBurstRemote;
var(Tuning_ShellEject) StaticMesh EjectedShellProjectileMesh;
var(Tuning_ShellEject) name ShellEjectionSocket;
var(Tuning_ShellEject) name ShellEjectionSocket_Player;
var(Tuning_ShellEject) name ShellEjectionSocket_NPC;
var(Tuning_ShellEject) config float MaxEjectSpeed;
var(Tuning_ShellEject) config float MinEjectSpeed;
var(Tuning_ShellEject) config float ShellEjectSpinAmount;
var(Tuning_ShellEject) config float ShellCustomGravityScale;
var(Tuning_ShellEject) config float ShellLifeSpan;
var(Tuning_ShellEject) config float ShellTrajectoryRandomness;
var(Tuning_ShellEject) config ParticleSystemInfo ShellEjectParticleTemplate;
var(Tuning_ShellEject) config ParticleSystemInfo NPCShellEjectParticleTemplate;
var export editinline ParticleSystemComponent ShellEjectPSComponent;
var(Tuning_VFX) int ShotsNeededForBarrelSmoke;
var int ShotsFiredThisBurstCount;
var(Tuning_VFX) config float HitSpangCullDist;
var(Tuning_VFX) config float MuzzleSmokeCullDistance;
var export editinline ParticleSystemComponent NPCScopeGlintPSComponent;
var(Tuning_ScopeGlint) config name NPCScopeGlintSocket;
var(Tuning_ScopeGlint) config ParticleSystemInfo NPCScopeGlintParticleSystemTemplate;
var(Tuning_Sounds) export editinline AudioComponent WeaponIronsightsFireSound;
var(Tuning_Sounds) array<SoundCue> LoopingWeaponFiringSoundCues;
var(Tuning_Sounds) export editinline AudioComponent LoopingWeaponFiringSound;
var(Tuning_Sounds) export editinline AudioComponent LoopingWeaponIronsightsFiringSound;
var(Tuning_Sounds) array<SoundCue> WeaponReportSoundCues;
var(Tuning_Sounds) export editinline AudioComponent WeaponReportSound;
var(Tuning_Sounds) export editinline AudioComponent WeaponIronsightsReportSound;
var(Tuning_Sounds) export editinline AudioComponent WeaponAlternateFireSound;
var(Tuning_Sounds) export editinline AudioComponent WeaponAlternateFireIronsightSound;
var(Tuning_Sounds) SoundCue WeaponAlternateFireSoundCue_NPC;
var(Tuning_Sounds) config float ShellImpactSoundDelay;
var export editinline array<export editinline AudioComponent> ShellImpactSoundComponents;
var int NextShellImpactSoundIndex;
var() int MaxShellImpactSoundCount;
var int CurrentShellImpactCallback;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    InitHitspangPSC(HitspangPSComponent);
    LoopingWeaponFiringSoundCues.Length = TotalSoundSets + 1;
    WeaponReportSoundCues.Length = TotalSoundSets + 1;
    //return;    
}

simulated function CleanUpAudioComponents()
{
    local int I;
    local editinline AudioComponent AudioComp;

    I = 0;
    J0x07:

    // End:0x6F [Loop If]
    if(I < ShellImpactSoundComponents.Length)
    {
        AudioComp = ShellImpactSoundComponents[I];
        // End:0x65
        if(AudioComp != none)
        {
            AudioComp.bAutoDestroy = true;
            // End:0x65
            if(AudioComp.bFinished)
            {
                AudioComp.Stop();
            }
        }
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    ShellImpactSoundComponents.Length = 0;
    super.CleanUpAudioComponents();
    //return;    
}

simulated event Destroyed()
{
    CleanUpAudioComponents();
    super.Destroyed();
    //return;    
}

simulated event StreamOutCleanup()
{
    CleanUpAudioComponents();
    super.StreamOutCleanup();
    //return;    
}

simulated function InitHitspangPSC(out ParticleSystemComponent HS_PSC)
{
    HS_PSC = new (Outer) Class'Engine.ParticleSystemComponent';
    HS_PSC.DeactivateSystem();
    HS_PSC.SetAbsolute(true, true, true);
    HS_PSC.SetScale(1.0000000);
    AttachComponent(HS_PSC);
    //return;    
}

simulated function AssignSoundSetIndex()
{
    super.AssignSoundSetIndex();
    // End:0x44
    if((((OwnerIsLocalPlayer()) == false) && WeaponAlternateFireSoundCue_NPC != none) && WeaponAlternateFireSound != none)
    {
        WeaponAlternateFireSound.SoundCue = WeaponAlternateFireSoundCue_NPC;
    }
    // End:0x76
    if(WeaponReportSound == none)
    {
        WeaponReportSound = WorldInfo.CreateAudioComponent(WeaponReportSoundCues[SoundSetIndex], false, false);        
    }
    else
    {
        WeaponReportSound.SoundCue = WeaponReportSoundCues[SoundSetIndex];
    }
    // End:0xFF
    if((LoopingWeaponFiringSoundCues.Length > SoundSetIndex) && LoopingWeaponFiringSoundCues[SoundSetIndex] != none)
    {
        // End:0xE5
        if(LoopingWeaponFiringSound == none)
        {
            LoopingWeaponFiringSound = WorldInfo.CreateAudioComponent(LoopingWeaponFiringSoundCues[SoundSetIndex], false, false);            
        }
        else
        {
            LoopingWeaponFiringSound.SoundCue = LoopingWeaponFiringSoundCues[SoundSetIndex];
        }
    }
    // End:0x291
    if((CurrentWeaponSockets.BarrelTip != 'None') && Mesh != none)
    {
        // End:0x15C
        if(WeaponIronsightsFireSound != none)
        {
            SkeletalMeshComponent(Mesh).AttachComponentToSocket(WeaponIronsightsFireSound, CurrentWeaponSockets.BarrelTip);
        }
        // End:0x18F
        if(WeaponReportSound != none)
        {
            SkeletalMeshComponent(Mesh).AttachComponentToSocket(WeaponReportSound, CurrentWeaponSockets.BarrelTip);
        }
        // End:0x1C2
        if(WeaponIronsightsReportSound != none)
        {
            SkeletalMeshComponent(Mesh).AttachComponentToSocket(WeaponIronsightsReportSound, CurrentWeaponSockets.BarrelTip);
        }
        // End:0x1F5
        if(WeaponAlternateFireSound != none)
        {
            SkeletalMeshComponent(Mesh).AttachComponentToSocket(WeaponAlternateFireSound, CurrentWeaponSockets.BarrelTip);
        }
        // End:0x228
        if(WeaponAlternateFireIronsightSound != none)
        {
            SkeletalMeshComponent(Mesh).AttachComponentToSocket(WeaponAlternateFireIronsightSound, CurrentWeaponSockets.BarrelTip);
        }
        // End:0x25B
        if(none != LoopingWeaponFiringSound)
        {
            SkeletalMeshComponent(Mesh).AttachComponentToSocket(LoopingWeaponFiringSound, CurrentWeaponSockets.BarrelTip);
        }
        // End:0x28E
        if(LoopingWeaponIronsightsFiringSound != none)
        {
            SkeletalMeshComponent(Mesh).AttachComponentToSocket(LoopingWeaponIronsightsFiringSound, CurrentWeaponSockets.BarrelTip);
        }        
    }
    else
    {
        // End:0x2A7
        if(WeaponIronsightsFireSound != none)
        {
            AttachComponent(WeaponIronsightsFireSound);
        }
        // End:0x2BD
        if(WeaponReportSound != none)
        {
            AttachComponent(WeaponReportSound);
        }
        // End:0x2D3
        if(WeaponIronsightsReportSound != none)
        {
            AttachComponent(WeaponIronsightsReportSound);
        }
        // End:0x2E9
        if(WeaponAlternateFireSound != none)
        {
            AttachComponent(WeaponAlternateFireSound);
        }
        // End:0x2FF
        if(WeaponAlternateFireIronsightSound != none)
        {
            AttachComponent(WeaponAlternateFireIronsightSound);
        }
        // End:0x315
        if(none != LoopingWeaponFiringSound)
        {
            AttachComponent(LoopingWeaponFiringSound);
        }
        // End:0x32B
        if(LoopingWeaponIronsightsFiringSound != none)
        {
            AttachComponent(LoopingWeaponIronsightsFiringSound);
        }
    }
    //return;    
}

simulated function AttachVisualEffects()
{
    local editinline SkeletalMeshComponent SkelMesh;

    super.AttachVisualEffects();
    SkelMesh = SkeletalMeshComponent(Mesh);
    // End:0x67
    if(SkelMesh != none)
    {
        UpdateVFXAttachments();
        AttachTracers();
        AttachMuzzleSmoke();
        AttachEjectionPortSmoke();
        AttachShellParticles();
        AttachMuzzleFlash();
        AttachScopeGlint();
    }
    //return;    
}

simulated function UpdateVFXAttachments()
{
    // End:0x53
    if(Mesh != none)
    {
        CurrentWeaponSockets.BarrelTip = GetBarrelSocketName(SkeletalMeshComponent(Mesh));
        CurrentWeaponSockets.ShellEject = GetShellEjectSocketName(SkeletalMeshComponent(Mesh));
    }
    //return;    
}

simulated function bool GetBarrelLocation(out Vector pos, out Rotator Rot, optional name name_of_socket)
{
    local name SocketName;

    // End:0x2C
    if('None' == name_of_socket)
    {
        SocketName = CurrentWeaponSockets.BarrelTip;        
    }
    else
    {
        SocketName = name_of_socket;
    }
    // End:0x59
    if((none == Mesh) || 'None' == SocketName)
    {
        return false;
    }
    SkeletalMeshComponent(Mesh).GetSocketWorldLocationAndRotation(SocketName, pos, Rot);
    return true;
    //return ReturnValue;    
}

simulated function AttachMuzzleFlash()
{
    local bool bFirstPerson;

    // End:0x13A
    if((MuzzleFlashParticleSystemTemplate.PSystem != none) || NPCMuzzleFlashParticleSystemTemplate.PSystem != none)
    {
        // End:0x4C
        if(MuzzleFlashParticleSystemTemplate.PSystem == none)
        {
            bFirstPerson = false;            
        }
        else
        {
            // End:0x6C
            if(NPCMuzzleFlashParticleSystemTemplate.PSystem == none)
            {
                bFirstPerson = true;                
            }
            else
            {
                bFirstPerson = OwnerIsLocalPlayer();
            }
        }
        // End:0xA7
        if(MuzzleFlashPSComponent == none)
        {
            MuzzleFlashPSComponent = new (Outer) Class'Engine.ParticleSystemComponent';
            AttachComponent(MuzzleFlashPSComponent);
        }
        MuzzleFlashPSComponent.SetAbsolute(true, true, true);
        MuzzleFlashPSComponent.SetScale(1.0000000);
        MuzzleFlashPSComponent.SetDepthPriorityGroup(((bFirstPerson) ? 2 : 1));
        MuzzleFlashPSComponent.SetTemplate(((bFirstPerson) ? MuzzleFlashParticleSystemTemplate.PSystem : NPCMuzzleFlashParticleSystemTemplate.PSystem));
        MuzzleFlashPSComponent.DeactivateSystem();
    }
    //return;    
}

simulated function ParticleSystemComponent GetMuzzleFlashPSC()
{
    return MuzzleFlashPSComponent;
    //return ReturnValue;    
}

simulated function ParticleSystemComponent GetShellEjectPSC()
{
    return ShellEjectPSComponent;
    //return ReturnValue;    
}

simulated function name GetShellEjectSocketName(SkeletalMeshComponent SMC_Mesh)
{
    local bool bPawnIsPlayer;

    // End:0xA4
    if(none != SMC_Mesh)
    {
        bPawnIsPlayer = OwnerIsLocalPlayer();
        // End:0x5C
        if((bPawnIsPlayer && ShellEjectionSocket_Player != 'None') && SMC_Mesh.GetSocketByName(ShellEjectionSocket_Player) != none)
        {
            return ShellEjectionSocket_Player;
        }
        // End:0x9E
        if((!bPawnIsPlayer && ShellEjectionSocket_NPC != 'None') && SMC_Mesh.GetSocketByName(ShellEjectionSocket_NPC) != none)
        {
            return ShellEjectionSocket_NPC;
        }
        return ShellEjectionSocket;
    }
    return 'None';
    //return ReturnValue;    
}

simulated function AttachShellParticles()
{
    local bool bFirstPerson;

    // End:0x13A
    if((ShellEjectParticleTemplate.PSystem != none) || NPCShellEjectParticleTemplate.PSystem != none)
    {
        // End:0x4C
        if(ShellEjectParticleTemplate.PSystem == none)
        {
            bFirstPerson = false;            
        }
        else
        {
            // End:0x6C
            if(NPCShellEjectParticleTemplate.PSystem == none)
            {
                bFirstPerson = true;                
            }
            else
            {
                bFirstPerson = OwnerIsLocalPlayer();
            }
        }
        // End:0xA7
        if(ShellEjectPSComponent == none)
        {
            ShellEjectPSComponent = new (Outer) Class'Engine.ParticleSystemComponent';
            AttachComponent(ShellEjectPSComponent);
        }
        ShellEjectPSComponent.SetAbsolute(true, true, true);
        ShellEjectPSComponent.SetScale(1.0000000);
        ShellEjectPSComponent.SetDepthPriorityGroup(((bFirstPerson) ? 2 : 1));
        ShellEjectPSComponent.SetTemplate(((bFirstPerson) ? ShellEjectParticleTemplate.PSystem : NPCShellEjectParticleTemplate.PSystem));
        ShellEjectPSComponent.DeactivateSystem();
    }
    //return;    
}

simulated function bool GetShellEjectionLocation(out Vector pos, out Rotator Rot, optional name name_of_socket)
{
    local name SocketName;

    // End:0x2C
    if('None' == name_of_socket)
    {
        SocketName = CurrentWeaponSockets.ShellEject;        
    }
    else
    {
        SocketName = name_of_socket;
    }
    // End:0x59
    if((none == Mesh) || 'None' == SocketName)
    {
        return false;
    }
    SkeletalMeshComponent(Mesh).GetSocketWorldLocationAndRotation(SocketName, pos, Rot);
    return true;
    //return ReturnValue;    
}

simulated function EjectShell()
{
    local name CallbackFunction;

    // End:0x16
    if(bUseShellProjectiles)
    {
        CreateProjectileShell();        
    }
    else
    {
        StartShellEjectParticles();
    }
    CallbackFunction = name(string('PlayShellImactSound_') $ string(CurrentShellImpactCallback));
    CurrentShellImpactCallback++;
    // End:0x59
    if(CurrentShellImpactCallback >= MaxShellImpactSoundCount)
    {
        CurrentShellImpactCallback = 0;
    }
    // End:0x7B
    if(false == IsTimerActive(CallbackFunction))
    {
        SetTimer(ShellImpactSoundDelay, false, CallbackFunction);
    }
    //return;    
}

function PlayShellImactSound()
{
    PlayShellImpactSound();
    //return;    
}

function PlayShellImactSound_1()
{
    PlayShellImpactSound();
    //return;    
}

function PlayShellImactSound_2()
{
    PlayShellImpactSound();
    //return;    
}

function PlayShellImactSound_3()
{
    PlayShellImpactSound();
    //return;    
}

function PlayShellImpactSound()
{
    local SoundCue ImpactSound;
    local MOHAIncludeClass.EPawnType EPawnType;
    local editinline AudioComponent AudioPlayer;

    EPawnType = ((OwnerIsLocalPlayer()) ? 0 : 1);
    ImpactSound = Class'MOHAPhysicalMaterialProperty'.static.GetImpactSound(MOHAPawn(Instigator).LastMaterialTouched, ShellImpactType, EPawnType);
    // End:0x14A
    if(none != ImpactSound)
    {
        // End:0x7A
        if(ShellImpactSoundComponents.Length <= NextShellImpactSoundIndex)
        {
            ShellImpactSoundComponents.Length = ShellImpactSoundComponents.Length + 1;
        }
        AudioPlayer = ShellImpactSoundComponents[NextShellImpactSoundIndex];
        // End:0xA5
        if(AudioPlayer != none)
        {
            AudioPlayer.Stop();
        }
        AudioPlayer = self.CreateAudioComponent(ImpactSound, false, true);
        ShellImpactSoundComponents[NextShellImpactSoundIndex] = AudioPlayer;
        NextShellImpactSoundIndex++;
        // End:0xED
        if(NextShellImpactSoundIndex >= MaxShellImpactSoundCount)
        {
            NextShellImpactSoundIndex = 0;
        }
        AudioPlayer.bUseOwnerLocation = false;
        AudioPlayer.Location = MOHAPawn(Instigator).LastFootstepLocation;
        AudioPlayer.bAutoDestroy = true;
        AudioPlayer.FadeIn(0.0000000, 1.0000000);
    }
    //return;    
}

simulated function CreateProjectileShell()
{
    local MOHAShellProjectile ProjectileInstance;
    local Vector socketLoc;
    local Rotator socketRot;
    local Vector vShellDirection, X, Y, Z;

    // End:0x0D
    if(none == EjectedShellProjectileMesh)
    {
        return;
    }
    // End:0x2A
    if(false == (GetShellEjectionLocation(socketLoc, socketRot)))
    {
        return;
    }
    GetAxes(socketRot, X, Y, Z);
    ProjectileInstance = __NFUN_278__(Class'MOHAShellProjectile', self,, socketLoc, Rotator(Y));
    // End:0x81
    if((ProjectileInstance == none) && ProjectileInstance.ProjectileMesh != none)
    {
        return;
    }
    ProjectileInstance.ProjectileMesh.SetStaticMesh(EjectedShellProjectileMesh);
    ProjectileInstance.LifeSpan = ShellLifeSpan;
    ProjectileInstance.Speed = MinEjectSpeed + (FRand() * (MaxEjectSpeed - MinEjectSpeed));
    ProjectileInstance.RandSpin(ShellEjectSpinAmount);
    RandomizeRotator(socketRot, ShellTrajectoryRandomness);
    ProjectileInstance.CustomGravityScale = ShellCustomGravityScale;
    vShellDirection = Vector(socketRot);
    ProjectileInstance.Init(vShellDirection);
    //return;    
}

simulated function RandomizeRotator(out Rotator Rot, float randomness)
{
    local Rotator rRandom;

    rRandom = RotRand();
    rRandom = Normalize(rRandom);
    rRandom *= randomness;
    Rot += rRandom;
    Rot = Normalize(Rot);
    //return;    
}

simulated function StartShellEjectParticles()
{
    local Vector socketLoc;
    local Rotator socketRot;

    // End:0x84
    if((ShellEjectPSComponent != none) && Mesh != none)
    {
        SkeletalMeshComponent(Mesh).GetSocketWorldLocationAndRotation(CurrentWeaponSockets.ShellEject, socketLoc, socketRot);
        ShellEjectPSComponent.SetTranslation(socketLoc);
        ShellEjectPSComponent.SetRotation(socketRot);
        ShellEjectPSComponent.ActivateSystem();
    }
    //return;    
}

simulated function WeaponFired()
{
    super.WeaponFired();
    ShotsFiredThisBurstCount += 1;
    //return;    
}

simulated function PlayRemoteEffects(Vector HitLocation)
{
    super.PlayRemoteEffects(HitLocation);
    UpdateTracerData(HitLocation, Instigator.FiringMode);
    // End:0x57
    if(!bStartedBurstRemote)
    {
        StartFiring(IsBurstModeRemote());
        bStartedBurstRemote = true;
        ShotsFiredThisBurstCount += 1;
    }
    SetTimer(WeaponClass.default.FireInterval[int(Instigator.FiringMode)] * 1.5000000, false, 'BurstOver');
    //return;    
}

simulated function bool IsBurstModeRemote()
{
    return WeaponClass.default.FiringStatesArray[int(Instigator.FiringMode)] == 'WeaponBurstFire';
    //return ReturnValue;    
}

simulated function BurstOver()
{
    StopFiring(IsBurstModeRemote());
    bStartedBurstRemote = false;
    ShotsFiredThisBurstCount = 0;
    //return;    
}

simulated function UpdateTracerData(Vector HitLocation, byte FireMode)
{
    // End:0x17
    if(int(CreateTracers[int(FireMode)]) == 0)
    {
        return;
    }
    // End:0x67
    if(((UseIronsightingEffect()) && EALASmallArms(Instigator.Weapon) != none) && EALASmallArms(Instigator.Weapon).IsScopeEnabled())
    {
        return;
    }
    // End:0xC1
    if(TracerFrequency != 0)
    {
        // End:0xB2
        if(TracerCount[int(FireMode)] >= (TracerFrequency - 1))
        {
            TracerCount[int(FireMode)] = 0;
            TurnOnTracer(HitLocation, FireMode);            
        }
        else
        {
            TracerCount[int(FireMode)]++;
        }
    }
    //return;    
}

simulated function PlayImpactEffectsWithImpactInfo(ImpactInfo Impact, optional int ImpactType, optional class<DamageType> DamageType)
{
    super.PlayImpactEffectsWithImpactInfo(Impact, ImpactType, DamageType);
    KickoffHitSpang(Impact, ImpactType);
    //return;    
}

simulated function KickoffHitSpang(ImpactInfo Impact, int ImpactType)
{
    CreateHitSpangEffect(HitspangPSComponent, Impact, ImpactType);
    //return;    
}

simulated function CreateHitSpangEffect(out ParticleSystemComponent HS_PSC, out ImpactInfo Impact, int ImpactType)
{
    local Pawn HitPawn;
    local ParticleSystem ParticleTemplate;

    // End:0x1DA
    if(Impact.HitActor != none)
    {
        // End:0x3D
        if(false == (EffectIsRelevant(Impact.HitLocation, false, HitSpangCullDist)))
        {
            return;
        }
        HitPawn = MOHAAIPawn(Impact.HitActor);
        // End:0xB4
        if(HitPawn != none)
        {
            // End:0xB1
            if(HitPawn.Health > 1)
            {
                ParticleTemplate = Class'MOHAPhysicalMaterialProperty'.static.GetParticleSystem(Impact.HitInfo.PhysMaterial, byte(ImpactType), 0);
            }            
        }
        else
        {
            HitPawn = MOHAPlayerPawn(Impact.HitActor);
            // End:0xDB
            if(HitPawn != none)
            {
                return;
            }
            ParticleTemplate = Class'MOHAPhysicalMaterialProperty'.static.GetParticleSystem(Impact.HitInfo.PhysMaterial, byte(ImpactType), 0);
        }
        // End:0x1DA
        if(((ParticleTemplate != none) && HS_PSC != none) && EffectIsRelevant(Impact.HitLocation, false, HitSpangCullDist, ParticleTemplate))
        {
            HS_PSC.SetTranslation(Impact.HitLocation);
            HS_PSC.SetRotation(Rotator(Impact.HitNormal));
            // End:0x1C0
            if(LastParticleTemplate != ParticleTemplate)
            {
                HS_PSC.SetTemplate(ParticleTemplate);
            }
            HS_PSC.ActivateSystem();
            LastParticleTemplate = ParticleTemplate;
        }
    }
    //return;    
}

simulated function StartMuzzleFlash()
{
    local Vector socketLoc;
    local Rotator socketRot;

    // End:0x84
    if((none != MuzzleFlashPSComponent) && Mesh != none)
    {
        SkeletalMeshComponent(Mesh).GetSocketWorldLocationAndRotation(CurrentWeaponSockets.BarrelTip, socketLoc, socketRot);
        MuzzleFlashPSComponent.SetTranslation(socketLoc);
        MuzzleFlashPSComponent.SetRotation(socketRot);
        MuzzleFlashPSComponent.ActivateSystem();
    }
    //return;    
}

simulated function StartFiring(bool bIsBurstMode)
{
    ShotsFiredThisBurstCount = 0;
    // End:0x1D
    if(true == bIsBurstMode)
    {
        StartLoopingSound();
    }
    super.StartFiring(bIsBurstMode);
    //return;    
}

simulated function StopFiring(bool bIsBurstMode)
{
    // End:0x56
    if((ShotsNeededForBarrelSmoke <= ShotsFiredThisBurstCount) && MuzzleSmokePSComponent != none)
    {
        // End:0x56
        if(EffectIsRelevant(Location, false, MuzzleSmokeCullDistance, MuzzleSmokePSComponent.Template))
        {
            PlayMuzzleSmokeVFX();
            PlayEjectionPortSmokeVFX();
        }
    }
    // End:0x6C
    if(true == bIsBurstMode)
    {
        StopLoopingSound();
    }
    PlayWeaponReportSound();
    super.StopFiring(bIsBurstMode);
    //return;    
}

simulated function StartLoopingSound()
{
    // End:0x42
    if(((UseIronsightingEffect()) && LoopingWeaponIronsightsFiringSound != none) && LoopingWeaponIronsightsFiringSound.SoundCue != none)
    {
        LoopingWeaponIronsightsFiringSound.Play();        
    }
    else
    {
        // End:0x5C
        if(LoopingWeaponFiringSound != none)
        {
            LoopingWeaponFiringSound.Play();
        }
    }
    //return;    
}

simulated function StopLoopingSound()
{
    // End:0x2C
    if(LoopingWeaponIronsightsFiringSound != none)
    {
        // End:0x2C
        if(LoopingWeaponIronsightsFiringSound.bWasPlaying)
        {
            LoopingWeaponIronsightsFiringSound.Stop();
        }
    }
    // End:0x58
    if(LoopingWeaponFiringSound != none)
    {
        // End:0x58
        if(LoopingWeaponFiringSound.bWasPlaying)
        {
            LoopingWeaponFiringSound.Stop();
        }
    }
    //return;    
}

simulated function WeaponIsEmpty()
{
    PlayWeaponDryFireSound();
    super.WeaponIsEmpty();
    //return;    
}

simulated function PlayWeaponDryFireSound()
{
    local bool bFirstPerson;

    // End:0xA5
    if((WeaponDryFireSnd != none) || WeaponDryFireSnd_NPC != none)
    {
        // End:0x2E
        if(WeaponDryFireSnd == none)
        {
            bFirstPerson = false;            
        }
        else
        {
            // End:0x44
            if(WeaponDryFireSnd_NPC == none)
            {
                bFirstPerson = true;                
            }
            else
            {
                bFirstPerson = Instigator.IsFirstPerson() && Instigator.IsLocallyControlled();
            }
        }
        WeaponDryFireSound.SoundCue = ((bFirstPerson) ? WeaponDryFireSnd : WeaponDryFireSnd_NPC);
        WeaponDryFireSound.Play();
    }
    //return;    
}

simulated function PlayOneShotFireSound()
{
    // End:0x41
    if((((UseIronsightingEffect()) == true) && (UseAlternateFireEffect()) == true) && WeaponAlternateFireIronsightSound != none)
    {
        WeaponAlternateFireIronsightSound.Play();        
    }
    else
    {
        // End:0x84
        if(((UseIronsightingEffect()) == true) && WeaponIronsightsFireSound != none)
        {
            // End:0x81
            if(WeaponIronsightsFireSound.SoundCue != none)
            {
                WeaponIronsightsFireSound.Play();
            }            
        }
        else
        {
            // End:0xC2
            if(((UseAlternateFireEffect()) == true) && WeaponAlternateFireSound != none)
            {
                WeaponAlternateFireSound.Stop();
                WeaponAlternateFireSound.Play();                
            }
            else
            {
                // End:0xDC
                if(WeaponFireAudio != none)
                {
                    WeaponFireAudio.Play();
                }
            }
        }
    }
    //return;    
}

simulated function PlayWeaponReportSound()
{
    // End:0x51
    if(((UseIronsightingEffect()) && WeaponIronsightsReportSound != none) && WeaponIronsightsReportSound.SoundCue != none)
    {
        WeaponIronsightsReportSound.Stop();
        WeaponIronsightsReportSound.Play();        
    }
    else
    {
        // End:0x7A
        if(WeaponReportSound != none)
        {
            WeaponReportSound.Stop();
            WeaponReportSound.Play();
        }
    }
    //return;    
}

simulated function PlayMuzzleSmokeVFX()
{
    local Vector socketLoc;
    local Rotator socketRot;

    // End:0x77
    if(none != MuzzleSmokePSComponent)
    {
        SkeletalMeshComponent(Mesh).GetSocketWorldLocationAndRotation(CurrentWeaponSockets.BarrelTip, socketLoc, socketRot);
        MuzzleSmokePSComponent.SetTranslation(socketLoc);
        MuzzleSmokePSComponent.SetRotation(socketRot);
        MuzzleSmokePSComponent.ActivateSystem();
    }
    //return;    
}

simulated function PlayEjectionPortSmokeVFX()
{
    local Vector socketLoc;
    local Rotator socketRot;

    // End:0x77
    if(none != EjectionPortSmokePSComponent)
    {
        SkeletalMeshComponent(Mesh).GetSocketWorldLocationAndRotation(CurrentWeaponSockets.ShellEject, socketLoc, socketRot);
        EjectionPortSmokePSComponent.SetTranslation(socketLoc);
        EjectionPortSmokePSComponent.SetRotation(socketRot);
        EjectionPortSmokePSComponent.ActivateSystem();
    }
    //return;    
}

simulated function AttachMuzzleSmoke()
{
    // End:0xBC
    if(MuzzleSmokeParticleSystemTemplate.PSystem != none)
    {
        // End:0x3F
        if(MuzzleSmokePSComponent == none)
        {
            MuzzleSmokePSComponent = new (Outer) Class'Engine.ParticleSystemComponent';
            AttachComponent(MuzzleSmokePSComponent);
        }
        MuzzleSmokePSComponent.SetAbsolute(true, true, true);
        MuzzleSmokePSComponent.SetScale(1.0000000);
        MuzzleSmokePSComponent.SetDepthPriorityGroup(((OwnerIsLocalPlayer()) ? 2 : 1));
        MuzzleSmokePSComponent.SetTemplate(MuzzleSmokeParticleSystemTemplate.PSystem);
        MuzzleSmokePSComponent.DeactivateSystem();
    }
    //return;    
}

simulated function AttachEjectionPortSmoke()
{
    // End:0xBC
    if(EjectionPortSmokeParticleSystemTemplate.PSystem != none)
    {
        // End:0x3F
        if(EjectionPortSmokePSComponent == none)
        {
            EjectionPortSmokePSComponent = new (Outer) Class'Engine.ParticleSystemComponent';
            AttachComponent(EjectionPortSmokePSComponent);
        }
        EjectionPortSmokePSComponent.SetAbsolute(true, true, true);
        EjectionPortSmokePSComponent.SetScale(1.0000000);
        EjectionPortSmokePSComponent.SetDepthPriorityGroup(((OwnerIsLocalPlayer()) ? 2 : 1));
        EjectionPortSmokePSComponent.SetTemplate(EjectionPortSmokeParticleSystemTemplate.PSystem);
        EjectionPortSmokePSComponent.DeactivateSystem();
    }
    //return;    
}

simulated function AttachTracers()
{
    local int I;
    local bool bFirstPerson;

    // End:0x20A
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        I = 0;
        J0x20:

        // End:0x20A [Loop If]
        if(I < 2)
        {
            // End:0x200
            if((BeamTemplate[I].PSystem != none) || NPCBeamTemplate[I].PSystem != none)
            {
                // End:0x8A
                if(BeamTemplate[I].PSystem == none)
                {
                    bFirstPerson = false;                    
                }
                else
                {
                    // End:0xB0
                    if(NPCBeamTemplate[I].PSystem == none)
                    {
                        bFirstPerson = true;                        
                    }
                    else
                    {
                        bFirstPerson = OwnerIsLocalPlayer();
                    }
                }
                // End:0xFD
                if(BeamEmitter[I] == none)
                {
                    BeamEmitter[I] = new (Outer) Class'Engine.ParticleSystemComponent';
                    AttachComponent(BeamEmitter[I]);
                }
                BeamEmitter[I].SetDepthPriorityGroup(1);
                BeamEmitter[I].SetTemplate(((bFirstPerson) ? BeamTemplate[I].PSystem : NPCBeamTemplate[I].PSystem));
                BeamEmitter[I].SetAbsolute(true, true, true);
                BeamEmitter[I].SetScale(1.0000000);
                BeamEmitter[I].DeactivateSystem();
                // End:0x1C1
                if(bTracerForceTargetPoint)
                {
                    bTracerTargetPt = true;                    
                }
                else
                {
                    // End:0x1D5
                    if(bTracerForceBarrel)
                    {
                        bTracerTargetPt = false;                        
                    }
                    else
                    {
                        bTracerTargetPt = bFirstPerson;
                    }
                }
                BeamEmitter[I].__OnSystemFinished__Delegate = TracerParticleSystemFinished;
            }
            I++;
            // [Loop Continue]
            goto J0x20;
        }
    }
    //return;    
}

simulated function TracerParticleSystemFinished(ParticleSystemComponent PSC)
{
    PSC.SetHidden(true);
    //return;    
}

simulated function TurnOnTracer(Vector FlashLocation, byte FireMode)
{
    local Vector vLoc;
    local Rotator rRot;

    BeamSockets[0] = CurrentWeaponSockets.BarrelTip;
    // End:0xE9
    if(SkeletalMeshComponent(Mesh).GetSocketWorldLocationAndRotation(BeamSockets[0], vLoc, rRot))
    {
        BeamEmitter[0].SetTranslation(vLoc);
        // End:0x88
        if(bTracerTargetPt)
        {
            BeamEmitter[0].SetRotation(Rotator(FlashLocation - vLoc));            
        }
        else
        {
            BeamEmitter[0].SetRotation(rRot);
        }
        BeamEmitter[0].SetTracerParams(vLoc, FlashLocation, BulletSpeed);
        BeamEmitter[0].SetHidden(false);
        BeamEmitter[0].ActivateSystem();
    }
    //return;    
}

simulated function AttachScopeGlint()
{
    local bool bFirstPerson;

    bFirstPerson = OwnerIsLocalPlayer();
    // End:0xC6
    if(!bFirstPerson && NPCScopeGlintParticleSystemTemplate.PSystem != none)
    {
        // End:0x70
        if(NPCScopeGlintPSComponent == none)
        {
            NPCScopeGlintPSComponent = new (Outer) Class'Engine.ParticleSystemComponent';
            SkeletalMeshComponent(Mesh).AttachComponentToSocket(NPCScopeGlintPSComponent, NPCScopeGlintSocket);
        }
        NPCScopeGlintPSComponent.SetScale(1.0000000);
        NPCScopeGlintPSComponent.SetDepthPriorityGroup(1);
        NPCScopeGlintPSComponent.SetTemplate(NPCScopeGlintParticleSystemTemplate.PSystem);
        NPCScopeGlintPSComponent.DeactivateSystem();
    }
    //return;    
}

simulated function StartScopeGlint()
{
    // End:0x2A
    if(NPCScopeGlintPSComponent != none)
    {
        NPCScopeGlintPSComponent.ActivateSystem();
        NPCScopeGlintPSComponent.SetHidden(false);
    }
    //return;    
}

simulated function StopScopeGlint()
{
    // End:0x2A
    if(NPCScopeGlintPSComponent != none)
    {
        NPCScopeGlintPSComponent.DeactivateSystem();
        NPCScopeGlintPSComponent.SetHidden(true);
    }
    //return;    
}

defaultproperties
{
    CurrentWeaponSockets=(BarrelTip="Barrel",ShellEject="ShellEject")
    BulletSpeed=9000.0000000
    MaxLength=2500.0000000
    MinLength=100.0000000
    BeamSockets="Barrel"
    StartPointParamName="BeamStart"
    EndPointParamName="BeamEnd"
    TracerFrequency=10
    CreateTracers=1
    ShellImpactType=21
    bTracerTargetPt=true
    ShellEjectionSocket="ShellEject"
    ShellEjectionSocket_Player="ShellEject_Player"
    ShellEjectionSocket_NPC="ShellEject_NPC"
    MaxEjectSpeed=100.0000000
    MinEjectSpeed=200.0000000
    ShellEjectSpinAmount=1000000.0000000
    ShellCustomGravityScale=1.0000000
    ShellLifeSpan=1.0000000
    ShellTrajectoryRandomness=0.1000000
    ShotsNeededForBarrelSmoke=2
    HitSpangCullDist=5000.0000000
    MuzzleSmokeCullDistance=2000.0000000
    ShellImpactSoundDelay=0.5000000
    MaxShellImpactSoundCount=4
    // Reference: MOHASkeletalMeshComponent'Default__SmallArmsAttachment.WeaponMeshComponent'
    begin object name=WeaponMeshComponent
    end object
    Mesh=WeaponMeshComponent
    ThirdPersonMesh=WeaponMeshComponent
    // Reference: WeaponFlashDLight'Default__SmallArmsAttachment.WeaponMuzzleFlashDLight'
    begin object name=WeaponMuzzleFlashDLight class=Class'WeaponFlashDLight'
        Brightness=3.0000000
        LightingChannels=(Characters_Weapons_Vehicles=true)
    end object
    MuzzleFlashDLight=WeaponMuzzleFlashDLight
    MuzzleFlashLightColor=(R=254,G=237,B=180,A=255)
    // Reference: AudioComponent'Default__SmallArmsAttachment.DryFireSound'
    begin object name=DryFireSound class=Class'Engine.AudioComponent'
    end object
    WeaponDryFireSound=DryFireSound
    Components[0]=WeaponMeshComponent
    // Reference: SpriteComponent'Default__SmallArmsAttachment.Sprite'
    begin object name=Sprite
    end object
    Components[1]=Sprite
    Components[2]=WeaponMuzzleFlashDLight
    Components[3]=DryFireSound
}