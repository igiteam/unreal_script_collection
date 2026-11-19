class SkyItem_RocketPack extends SkyInventorySkeletal
    native;

enum RocketPackTags
{
    RTPT_BeginPlay,                 // 0
    RTPT_EndPlay,                   // 1
    RTPT_Activate,                  // 2
    RTPT_Deactivate,                // 3
    RTPT_ActivateBoost,             // 4
    RTPT_DeactivateBoost,           // 5
    RTPT_ActivateThrust,            // 6
    RTPT_DeactivateThrust,          // 7
    RTPT_ActivateGlide,             // 8
    RTPT_DeactivateGlide,           // 9
    RTPT_DoubleJumpBurst,           // 10
    RTPT_ActivateTurbo,             // 11
    RTPT_DeactivateTurbo,           // 12
    RTPT_ActivateTurboCritical,     // 13
    RTPT_DeactivateTurboCritical,   // 14
    RTPT_ActivateHijackHop,         // 15
    RTPT_DeactivateHijackHop,       // 16
    RTPT_StartHijackApproach,       // 17
    RTPT_EndHijackApproach,         // 18
    RTPT_Detonate,                  // 19
    RTPT_ActivateVertical,          // 20
    RTPT_DeactivateVertical,        // 21
    RTPT_ActivatePrepped,           // 22
    RTPT_DeactivatPrepped,          // 23
    RTPT_MAX                        // 24
};

struct native RocketPackEffect
{
    var() SkyItem_RocketPack.RocketPackTags StartTag;
    var() SkyItem_RocketPack.RocketPackTags EndTag;
    var() ParticleSystem Template;
    var() notforconsole const export editinline ApexTurbulenceEmitterComponent TurbulenceEmitterInstance;
    var() bool TurbulenceOverrideVelocity;
    var() float TurbulenceLinearVelocityMultipler;
    var() float TurbulenceLinearVelocityClamp;
    var() float TurbulenceAngularVelocityMultipler;
    var() float TurbulenceAngularVelocityClamp;
    var() name Socket;
    var() bool bUsePawnMesh;
    var() bool bOneShotEffect;
    var export editinline transient SkyParticleSystemComponent EffectRef;

    structdefaultproperties
    {
        StartTag=RTPT_BeginPlay
        EndTag=RTPT_BeginPlay
        Template=none
        TurbulenceEmitterInstance=none
        TurbulenceOverrideVelocity=false
        TurbulenceLinearVelocityMultipler=0.0000000
        TurbulenceLinearVelocityClamp=0.0000000
        TurbulenceAngularVelocityMultipler=0.0000000
        TurbulenceAngularVelocityClamp=0.0000000
        Socket="None"
        bUsePawnMesh=false
        bOneShotEffect=false
        EffectRef=none
    }
};

struct native RocketPackSound
{
    var() SkyItem_RocketPack.RocketPackTags StartTag;
    var() SkyItem_RocketPack.RocketPackTags EndTag;
    var() SoundCue SoundCue;
    var() float ParameterUpdateDelay;
    var() bool bPlayAfterDeactivate;
    var export editinline AudioComponent Component;

    structdefaultproperties
    {
        StartTag=RTPT_BeginPlay
        EndTag=RTPT_BeginPlay
        SoundCue=none
        ParameterUpdateDelay=0.0000000
        bPlayAfterDeactivate=false
        Component=none
    }
};

struct native RPPWMaterialRefEffect
{
    var() name MaterialType;
    var() ParticleSystem ParticleTemplate;

    structdefaultproperties
    {
        MaterialType="None"
        ParticleTemplate=none
    }
};

var transient SkyPawn PlayerOwner;
var export editinline transient SkeletalMeshComponent OwnerMesh;
var transient name AttachSocket;
var() float JumpZModifier;
var() float UpwardBoost;
var() float UpwardBoostAccel;
var() float TerminalVelocityGlide;
var() float TerminalVelocityFastGlide;
var() float GlideHorzVelocityMax;
var() float GlideHorzVelocityDecelRate;
var() float GlideVertVelocityDecelRate;
var() float GlideAirControl;
var() float BoostAirControl;
var() float GlideAirSpeed;
var() float BoostAirSpeed;
var() float HoldJumpToGlideTime;
var() bool bAllowBoost;
var() bool bAllowDoubleJump;
var() bool bAllowThrust;
var bool bHasDoubleJump;
var(PropWash) bool bUsePropWash;
var transient bool bTickMatEffectManager;
var() float DelayBeforeBoost;
var(Fuel) int NumActivationsPerAirborne;
var int CountActivationsPerAirborne;
var(Fuel) float MaxFuel;
var(Fuel) float FuelPerAirborne;
var float CurrentFuel;
var(Fuel) float FuelPerSecondThrust;
var(Fuel) float FuelPerSecondTurbo;
var(Fuel) float FuelPerSecondHover;
var(Fuel) float FuelPerSecondBoost;
var() SkyAirVehicle_RocketPackThrust RocketPackThrustVehicleArchetype;
var SkyAirVehicle_RocketPackThrust StoredRocketPackThrustVehicle;
var(Sound) float FlybySoundCheckTime;
var(Sound) float FlybySoundCheckDistance;
var(Sound) editconst export editinline AudioComponent FlybySound;
var float FlybySoundLastCheck;
var(JumpAbility) float MaxFallSpeed;
var(JumpAbility) float MaxFallSpeedDeath;
var(JumpAbility) float FallingDamage;
var(Effects) name TurbulenceGridSocket;
var(Effects) name TurbulenceGridBone;
var(Effects) notforconsole const export editinline ApexTurbulenceGridComponent TurbulenceGridInstance;
var(Effects) array<RocketPackEffect> RocketPackEffects;
var(Sound) array<RocketPackSound> RocketPackSounds;
var float CurrentSoundParameterUpdateDelay;
var(PropWash) name PropWashTraceSocket;
var(PropWash) float TraceDistance;
var(PropWash) array<RPPWMaterialRefEffect> PropWashEffects;
var(PropWash) RPPWMaterialRefEffect DefaultPropWashEffect;
var export editinline ParticleSystemComponent PropWashPSC;
var(Effects) int RocketPackMaterialIndex;
var MaterialInstanceConstant RocketPackMaterialInst;
var(Effects) export editinline SkyMaterialEffectManager MaterialEffectManager;
var(Sound) name SoundContextType;
var transient int PrevCoverOrientation;
var float MaxTimeBeforeSoundsUpdate;
var transient float TimeBeforeSoundsUpdate;
var(Checkpoint) name RocketPackThrustVehicleName;

simulated event PostBeginPlay()
{
    super(Actor).PostBeginPlay();
    InitializeEffects();
    RocketPackPlayTag(0);
    CurrentFuel = MaxFuel;
    // End:0x46
    if(OwnerMesh != none)
    {
        AttachTo(OwnerMesh, AttachSocket);
    }
    // End:0xA9
    if((Pawn(Owner) != none) && PlayerController(Pawn(Owner).Controller) != none)
    {
        UpdateSecrets(PlayerController(Pawn(Owner).Controller).GetSecretIndex());
    }
    //return;    
}

simulated function UpdateSecrets(int Index)
{
    // End:0x2B
    if(Index >= 0)
    {
        // End:0x2B
        if(Mesh != none)
        {
            Mesh.UseAlternateMaterial(Index);
        }
    }
    //return;    
}

event Destroyed()
{
    local int I;

    RocketPackPlayTag(1);
    StopAllAudio();
    StoredRocketPackThrustVehicle.Destroy();
    // End:0x57
    if(TurbulenceGridInstance != none)
    {
        Mesh.DetachComponent(TurbulenceGridInstance);
        TurbulenceGridInstance.TermComponentRBPhys();
    }
    I = 0;
    J0x5E:

    // End:0x134 [Loop If]
    if(I < RocketPackEffects.Length)
    {
        // End:0x12A
        if(RocketPackEffects[I].TurbulenceEmitterInstance != none)
        {
            // End:0xDF
            if(RocketPackEffects[I].TurbulenceEmitterInstance.ApexForceFieldComponent != none)
            {
                RocketPackEffects[I].TurbulenceEmitterInstance.ApexForceFieldComponent.TermComponentRBPhys();
            }
            Mesh.DetachComponent(RocketPackEffects[I].TurbulenceEmitterInstance);
            RocketPackEffects[I].TurbulenceEmitterInstance.TermComponentRBPhys();
        }
        I++;
        // [Loop Continue]
        goto J0x5E;
    }
    super(Inventory).Destroyed();
    //return;    
}

function UpdateJetPositions()
{
    local Vector GridAttachedLocation, JetAttachedLocation;
    local int I;

    // End:0x31
    if(TurbulenceGridSocket != 'None')
    {
        Mesh.GetSocketWorldLocationAndRotation(TurbulenceGridSocket, GridAttachedLocation);        
    }
    else
    {
        GridAttachedLocation = Mesh.GetBoneLocation(TurbulenceGridBone);
    }
    I = 0;
    J0x54:

    // End:0x10C [Loop If]
    if(I < TurbulenceGridInstance.Jets.Length)
    {
        // End:0x102
        if(TurbulenceGridInstance.Jets[I].Socket != 'None')
        {
            // End:0x102
            if(Mesh.GetSocketWorldLocationAndRotation(TurbulenceGridInstance.Jets[I].Socket, JetAttachedLocation))
            {
                TurbulenceGridInstance.Jets[I].Position = JetAttachedLocation - GridAttachedLocation;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x54;
    }
    //return;    
}

event Tick(float DeltaTime)
{
    local SkyPawnCoverUser SPCU;
    local int CurrCoverOrientation;

    super(Actor).Tick(DeltaTime);
    // End:0x3A
    if(bTickMatEffectManager && MaterialEffectManager != none)
    {
        MaterialEffectManager.UpdateParams(DeltaTime);
    }
    SPCU = SkyPawnCoverUser(PlayerOwner);
    // End:0xDE
    if(SPCU != none)
    {
        CurrCoverOrientation = int(SPCU.GetCoverOrientation());
        // End:0xAF
        if(((CurrCoverOrientation == 1) && PrevCoverOrientation != 1) && !SPCU.bEnteringByPlatformGrab)
        {
            RocketPackPlayTag(20);            
        }
        else
        {
            // End:0xD3
            if((CurrCoverOrientation != 1) && PrevCoverOrientation == 1)
            {
                RocketPackPlayTag(21);
            }
        }
        PrevCoverOrientation = CurrCoverOrientation;
    }
    // End:0xF3
    if(TurbulenceGridInstance != none)
    {
        UpdateJetPositions();
    }
    //return;    
}

simulated function InitializeEffects()
{
    local int I;
    local editinline SkyParticleSystemComponent RocketPSysComp;

    // End:0x1C
    if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
    {
        return;
    }
    // End:0x89
    if(TurbulenceGridInstance != none)
    {
        // End:0x57
        if(TurbulenceGridSocket != 'None')
        {
            Mesh.AttachComponentToSocket(TurbulenceGridInstance, TurbulenceGridSocket);            
        }
        else
        {
            Mesh.AttachComponent(TurbulenceGridInstance, TurbulenceGridBone);
        }
        TurbulenceGridInstance.InitComponentRBPhys(true);
    }
    I = 0;
    J0x90:

    // End:0x2D4 [Loop If]
    if(I < RocketPackEffects.Length)
    {
        // End:0x2CA
        if(!RocketPackEffects[I].bOneShotEffect)
        {
            RocketPSysComp = new (self) Class'SkyParticleSystemComponent';
            // End:0xFD
            if(RocketPSysComp != none)
            {
                RocketPSysComp.SetTemplate(RocketPackEffects[I].Template);
            }
            RocketPSysComp.DeactivateSystem();
            RocketPSysComp.bAutoActivate = false;
            // End:0x166
            if(!RocketPackEffects[I].bUsePawnMesh)
            {
                Mesh.AttachComponentToSocket(RocketPSysComp, RocketPackEffects[I].Socket);
            }
            // End:0x29C
            if(RocketPackEffects[I].TurbulenceEmitterInstance != none)
            {
                // End:0x29C
                if(!RocketPackEffects[I].bUsePawnMesh)
                {
                    Mesh.AttachComponentToSocket(RocketPackEffects[I].TurbulenceEmitterInstance, RocketPackEffects[I].Socket);
                    RocketPackEffects[I].TurbulenceEmitterInstance.InitComponentRBPhys(true);
                    // End:0x29C
                    if(RocketPackEffects[I].TurbulenceEmitterInstance.ApexForceFieldComponent != none)
                    {
                        Mesh.AttachComponentToSocket(RocketPackEffects[I].TurbulenceEmitterInstance.ApexForceFieldComponent, RocketPackEffects[I].Socket);
                        RocketPackEffects[I].TurbulenceEmitterInstance.ApexForceFieldComponent.InitComponentRBPhys(true);
                    }
                }
            }
            RocketPSysComp.bSkyPoolActive = false;
            RocketPackEffects[I].EffectRef = RocketPSysComp;
        }
        I++;
        // [Loop Continue]
        goto J0x90;
    }
    I = 0;
    J0x2DB:

    // End:0x369 [Loop If]
    if(I < RocketPackSounds.Length)
    {
        // End:0x35F
        if(RocketPackSounds[I].SoundCue != none)
        {
            RocketPackSounds[I].Component = new (self) Class'Engine.AudioComponent';
            RocketPackSounds[I].Component.SoundCue = RocketPackSounds[I].SoundCue;
        }
        ++I;
        // [Loop Continue]
        goto J0x2DB;
    }
    RocketPackMaterialInst = new (Outer) Class'Engine.MaterialInstanceConstant';
    RocketPackMaterialInst.SetParent(Mesh.GetMaterial(RocketPackMaterialIndex));
    Mesh.SetMaterial(RocketPackMaterialIndex, RocketPackMaterialInst);
    // End:0x406
    if(MaterialEffectManager != none)
    {
        MaterialEffectManager.MaterialInstances.AddItem(RocketPackMaterialInst);
        bTickMatEffectManager = true;
        MaterialEffectManager.Initialize();
    }
    //return;    
}

simulated function StopAllAudio()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x7C [Loop If]
    if(I < RocketPackSounds.Length)
    {
        // End:0x72
        if((RocketPackSounds[I].Component != none) && !RocketPackSounds[I].bPlayAfterDeactivate)
        {
            RocketPackSounds[I].Component.Stop();
        }
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function GivenTo(Pawn thisPawn, optional bool bDoNotActivate)
{
    local int I;

    super(Inventory).GivenTo(thisPawn, bDoNotActivate);
    PlayerOwner = SkyPawn(thisPawn);
    I = 0;
    J0x29:

    // End:0x12E [Loop If]
    if(I < RocketPackEffects.Length)
    {
        // End:0x124
        if(RocketPackEffects[I].bUsePawnMesh == true)
        {
            PlayerOwner.Mesh.AttachComponentToSocket(RocketPackEffects[I].EffectRef, RocketPackEffects[I].Socket);
            // End:0x124
            if(RocketPackEffects[I].TurbulenceEmitterInstance != none)
            {
                PlayerOwner.Mesh.AttachComponentToSocket(RocketPackEffects[I].TurbulenceEmitterInstance, RocketPackEffects[I].Socket);
                RocketPackEffects[I].TurbulenceEmitterInstance.InitComponentRBPhys(true);
            }
        }
        I++;
        // [Loop Continue]
        goto J0x29;
    }
    //return;    
}

simulated event AttachTo(SkeletalMeshComponent MeshCpnt, optional name SocketName)
{
    OwnerMesh = MeshCpnt;
    AttachSocket = SocketName;
    Mesh.SetLightEnvironment(MeshCpnt.LightEnvironment);
    Mesh.SetShadowParent(MeshCpnt);
    Mesh.SetHasPhysicsAssetInstance(true);
    AttachSounds();
    //return;    
}

simulated event DetachFrom()
{
    AttachSocket = 'None';
    Mesh.SetShadowParent(none);
    OwnerMesh = none;
    //return;    
}

// Export USkyItem_RocketPack::execAttachSounds(FFrame&, void* const)
native function AttachSounds();

// Export USkyItem_RocketPack::execUpdateSoundParameters(FFrame&, void* const)
native function UpdateSoundParameters(float Steering, float Rise, float Speed);

simulated event RocketPackPlayTag(SkyItem_RocketPack.RocketPackTags playtag)
{
    local int I;
    local Emitter OneShotEffect;
    local SkyGameReplicationInfo GRI;

    // End:0xFE
    if(MaterialEffectManager != none)
    {
        // End:0x34
        if(int(playtag) == int(6))
        {
            MaterialEffectManager.ActivateEffect(5);            
        }
        else
        {
            // End:0x5D
            if(int(playtag) == int(7))
            {
                MaterialEffectManager.ActivateEffect(6);                
            }
            else
            {
                // End:0x86
                if(int(playtag) == int(8))
                {
                    MaterialEffectManager.ActivateEffect(7);                    
                }
                else
                {
                    // End:0xAF
                    if(int(playtag) == int(9))
                    {
                        MaterialEffectManager.ActivateEffect(8);                        
                    }
                    else
                    {
                        // End:0xD8
                        if(int(playtag) == int(15))
                        {
                            MaterialEffectManager.ActivateEffect(9);                            
                        }
                        else
                        {
                            // End:0xFE
                            if(int(playtag) == int(16))
                            {
                                MaterialEffectManager.ActivateEffect(10);
                            }
                        }
                    }
                }
            }
        }
    }
    I = 0;
    J0x105:

    // End:0x43F [Loop If]
    if(I < RocketPackEffects.Length)
    {
        // End:0x391
        if(int(RocketPackEffects[I].StartTag) == int(playtag))
        {
            // End:0x29E
            if(!RocketPackEffects[I].bOneShotEffect)
            {
                // End:0x214
                if(RocketPackEffects[I].TurbulenceOverrideVelocity && TurbulenceGridInstance != none)
                {
                    TurbulenceGridInstance.LinearVelocityMultiplier = RocketPackEffects[I].TurbulenceLinearVelocityMultipler;
                    TurbulenceGridInstance.LinearVelocityClamp = RocketPackEffects[I].TurbulenceLinearVelocityClamp;
                    TurbulenceGridInstance.AngularVelocityMultiplier = RocketPackEffects[I].TurbulenceAngularVelocityMultipler;
                    TurbulenceGridInstance.AngularVelocityClamp = RocketPackEffects[I].TurbulenceAngularVelocityClamp;
                }
                // End:0x256
                if(RocketPackEffects[I].TurbulenceEmitterInstance != none)
                {
                    RocketPackEffects[I].TurbulenceEmitterInstance.SetEnabled(true);
                }
                RocketPackEffects[I].EffectRef.ActivateSystem();
                RocketPackEffects[I].EffectRef.bSkyPoolActive = true;                
            }
            else
            {
                GRI = SkyGameReplicationInfo(WorldInfo.GRI);
                // End:0x325
                if(GRI.SOP != none)
                {
                    OneShotEffect = GRI.SOP.CreateEmitter(RocketPackEffects[I].Template, self, PlayerOwner.Location, Rotator(vect(0.0000000, 0.0000000, 1.0000000)));                    
                }
                else
                {
                    OneShotEffect = Spawn(Class'SkyEmitter', self,, PlayerOwner.Location, Rotator(vect(0.0000000, 0.0000000, 1.0000000)));
                    // End:0x38E
                    if(OneShotEffect != none)
                    {
                        OneShotEffect.SetTemplate(RocketPackEffects[I].Template, true);
                    }
                }
            }
            // [Explicit Continue]
            goto J0x435;
        }
        // End:0x435
        if(int(RocketPackEffects[I].EndTag) == int(playtag))
        {
            // End:0x435
            if(RocketPackEffects[I].bOneShotEffect == false)
            {
                // End:0x414
                if(RocketPackEffects[I].TurbulenceEmitterInstance != none)
                {
                    RocketPackEffects[I].TurbulenceEmitterInstance.SetEnabled(false);
                }
                RocketPackEffects[I].EffectRef.DeactivateSystem();
            }
        }
        J0x435:

        I++;
        // [Loop Continue]
        goto J0x105;
    }
    I = 0;
    J0x446:

    // End:0x545 [Loop If]
    if(I < RocketPackSounds.Length)
    {
        // End:0x4D8
        if((int(RocketPackSounds[I].StartTag) == int(playtag)) && RocketPackSounds[I].Component != none)
        {
            RocketPackSounds[I].Component.Play();
            CurrentSoundParameterUpdateDelay = RocketPackSounds[I].ParameterUpdateDelay;
            // [Explicit Continue]
            goto J0x53B;
        }
        // End:0x53B
        if((int(RocketPackSounds[I].EndTag) == int(playtag)) && RocketPackSounds[I].Component != none)
        {
            RocketPackSounds[I].Component.Stop();
        }
        J0x53B:

        I++;
        // [Loop Continue]
        goto J0x446;
    }
    //return;    
}

simulated event TurboActivated()
{
    RocketPackPlayTag(11);
    //return;    
}

simulated event TurboDeactivated()
{
    RocketPackPlayTag(12);
    //return;    
}

simulated event TurboCritical()
{
    RocketPackPlayTag(13);
    //return;    
}

simulated event TurboStabilized()
{
    RocketPackPlayTag(14);
    //return;    
}

simulated event DetonateRocketPack()
{
    RocketPackPlayTag(19);
    //return;    
}

simulated function Activate()
{
    GotoState('Active');
    //return;    
}

simulated event Deactivate()
{
    //return;    
}

simulated function OnLand()
{
    // End:0x13
    if(!bHasDoubleJump)
    {
        bHasDoubleJump = true;
    }
    CountActivationsPerAirborne = 0;
    // End:0x32
    if(FuelPerAirborne > float(0))
    {
        CurrentFuel = FuelPerAirborne;
    }
    //return;    
}

auto state Inactive
{
    simulated function BeginState(name PreviousStateName)
    {
        SetHidden(false);
        // End:0x2C
        if(OwnerMesh != none)
        {
            OwnerMesh.AttachComponentToSocket(Mesh, AttachSocket);
        }
        //return;        
    }
    stop;    
}

simulated state Active
{
    simulated event Deactivate()
    {
        StopAllAudio();
        GotoState('Inactive');
        //return;        
    }
    stop;    
}
