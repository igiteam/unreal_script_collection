class SkyGameVehicle extends SVehicle
    abstract
    native
    nativereplication
    config(Game);

const SKYVEHICLE_UNSET_TEAM = 128;

struct native VehicleSeat
{
    var() Pawn StoragePawn;
    var() Vehicle SeatPawn;
    var deprecated class<SkyVehicleWeapon> GunClass;
    var SkyVehicleWeapon Gun;
    var() array<name> GunSocket;
    var() array<name> GunPivotPoints;
    var int BarrelIndex;
    var() string TurretVarPrefix;
    var name WeaponRotationName;
    var name FlashLocationName;
    var name FlashCountName;
    var name FiringModeName;
    var const Pointer WeaponRotationProperty;
    var const Pointer FlashLocationProperty;
    var const Pointer FlashCountProperty;
    var const Pointer FiringModeProperty;
    var Rotator LastWeaponRotation;
    var() array<name> TurretControls;
    var() name CameraTag;
    var() bool bCameraUseDriverMesh;
    var() Vector CameraBaseOffset;
    var() float CameraOffset;
    var() float CameraEyeHeight;
    var() float ViewPitchMin;
    var() float ViewPitchMax;
    var() bool bSeatVisible;
    var() name SeatBone;
    var() Vector SeatOffset;
    var() Rotator SeatRotation;
    var deprecated name SeatSocket;
    var deprecated class<SkyExplosionLight> MuzzleFlashLightClass;
    var export editinline deprecated SkyExplosionLight MuzzleFlashLight;
    var class<SkyExplosionLight> ImpactFlashLightClass;
    var() float DriverDamageMult;
    var export editinline AudioComponent SeatMotionAudio;
    var array<SkySkelControl_TurretConstrained> TurretControllers;

    structdefaultproperties
    {
        StoragePawn=none
        SeatPawn=none
        Gun=none
        GunSocket=none
        GunPivotPoints=none
        BarrelIndex=0
        TurretVarPrefix=""
        WeaponRotationName="None"
        FlashLocationName="None"
        FlashCountName="None"
        FiringModeName="None"
        WeaponRotationProperty=none
        FlashLocationProperty=none
        FlashCountProperty=none
        FiringModeProperty=none
        LastWeaponRotation=(Pitch=0,Yaw=0,Roll=0)
        TurretControls=none
        CameraTag="None"
        bCameraUseDriverMesh=false
        CameraBaseOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        CameraOffset=0.0000000
        CameraEyeHeight=0.0000000
        ViewPitchMin=0.0000000
        ViewPitchMax=0.0000000
        bSeatVisible=false
        SeatBone="None"
        SeatOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        SeatRotation=(Pitch=0,Yaw=0,Roll=0)
        ImpactFlashLightClass=none
        DriverDamageMult=0.0000000
        SeatMotionAudio=none
        TurretControllers=none
    }
};

struct native VehicleEffect
{
    var() array<name> EffectStartTags;
    var() array<name> EffectEndTags;
    var() ParticleSystem EffectTemplate;
    var() ParticleSystem PlayerEffectTemplate;
    var() name EffectSocket;
    var export editinline transient SkyParticleSystemComponent EffectRef;
    var() const export editinline ApexTurbulenceEmitterComponent TurbulenceEmitterInstance;

    structdefaultproperties
    {
        EffectStartTags=none
        EffectEndTags=none
        EffectTemplate=none
        PlayerEffectTemplate=none
        EffectSocket="None"
        EffectRef=none
        TurbulenceEmitterInstance=none
    }
};

struct native VehicleAnim
{
    var() name AnimTag;
    var() array<name> AnimSeqs;
    var() float AnimRate;
    var() bool bAnimLoopLastSeq;
    var() name AnimPlayerName;

    structdefaultproperties
    {
        AnimTag="None"
        AnimSeqs=none
        AnimRate=0.0000000
        bAnimLoopLastSeq=false
        AnimPlayerName="None"
    }
};

struct native FDamageMorphTargets
{
    var name MorphNodeName;
    var MorphNodeWeight MorphNode;
    var name LinkedMorphNodeName;
    var int LinkedMorphNodeIndex;
    var name AssociatedSkelControl;
    var name InfluenceBone;
    var int Health;
    var array<name> DamagePropNames;

    structdefaultproperties
    {
        MorphNodeName="None"
        MorphNode=none
        LinkedMorphNodeName="None"
        LinkedMorphNodeIndex=0
        AssociatedSkelControl="None"
        InfluenceBone="None"
        Health=0
        DamagePropNames=none
    }
};

struct native TimePosition
{
    var Vector Position;
    var float Time;

    structdefaultproperties
    {
        Position=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Time=0.0000000
    }
};

var(BlowUpRumble) ForceFeedbackWaveform BlowUpFFeedback;
var bool bDriverHoldsFlag;
var bool bCanCarryFlag;
var bool bTeamLocked;
var bool bEnteringUnlocks;
var bool bHasCustomEntryRadius;
var bool bKeyVehicle;
var bool bDefensive;
var bool bEjectPassengersWhenFlipped;
var bool bMustBeUpright;
var bool bStickDeflectionThrottle;
var bool bNeverReset;
var bool bEjectKilledBodies;
var bool bLightArmor;
var bool bShouldLeaveForCombat;
var bool bDrawHealthOnHUD;
var bool bDriverCastsShadow;
var transient bool bNonViolentDeath;
var bool bHomingTarget;
var repnotify bool bDeadVehicle;
var(Ragdoll) bool bBreakRagdollConstraints;
var bool bIsBurning;
var deprecated bool bIsScraping;
var bool bPostRenderTraceSucceeded;
var repnotify bool bPlayingSpawnEffect;
var bool bReducedFallingCollisionDamage;
var bool bUnlimitedCameraDistance;
var bool bRotateCameraUnderVehicle;
var bool bNoZSmoothing;
var bool bNoFollowJumpZ;
var bool bFixedCamZ;
var bool bCameraNeverHidesVehicle;
var bool bShowDamageDebug;
var bool bStealthVehicle;
var bool bIsDisabled;
var bool bNoZDamping;
var SoundCue VehicleLockedSound;
var transient PhysicalMaterial DrivingPhysicalMaterial;
var transient PhysicalMaterial DefaultPhysicalMaterial;
var float LastCheckUpsideDownTime;
var float FlippedCount;
var(Lighting) export editinline LightEnvironmentComponent LightEnvironment;
var repnotify byte Team;
var repnotify byte VehicleDamagePct;
var byte LastBarrelIndex;
var float VehicleLostTime;
var float PlayerStartTime;
var float RespawnTime;
var float InitialSpawnDelay;
var float LinkHealMult;
var float MaxDesireability;
var float ObjectiveGetOutDist;
var array<SoundCue> HornSounds;
var float LastHornTime;
var SoundCue LockedOnSound;
var class<DamageType> RanOverDamageType;
var float MinRunOverSpeed;
var SoundCue RanOverSound;
var int StolenAnnouncementIndex;
var SoundCue StolenSound;
var float LastRunOverWarningTime;
var float MinRunOverWarningAim;
var SkyGameVehicle NextVehicle;
var SkyVehicleFactory ParentFactory;
var SkyBotControllerBase Reservation;
var float ResetTime;
var const localized string VehiclePositionString;
var const localized string VehicleNameString;
var float TeamBeaconMaxDist;
var float TeamBeaconPlayerInfoMaxDist;
var float WaterDamage;
var float AccumulatedWaterDamage;
var class<DamageType> VehicleDrowningDamType;
var class<SkyExplosionLight> ExplosionLightClass;
var float MaxExplosionLightDistance;
var repnotify Rotator WeaponRotation;
var(Seats) array<VehicleSeat> Seats;
var int SeatMask;
var(Effects) array<VehicleEffect> VehicleEffects;
var(Effects) name TurbulenceGridSocket;
var(Effects) name TurbulenceGridBone;
var(Effects) const export editinline ApexTurbulenceGridComponent TurbulenceGridInstance;
var(Effects) array<VehicleAnim> VehicleAnims;
var array<FDamageMorphTargets> DamageMorphTargets;
var int DestroyedMorphCost;
var int ClientHealth;
var MaterialInstanceConstant DamageMaterialInstance;
var MaterialInstanceConstant TeamMaterials[2];
var float DamageSmokeThreshhold;
var float FireDamageThreshold;
var float FireDamagePerSec;
var float UpsideDownDamagePerSec;
var float AccruedFireDamage;
var class<DamageType> ExplosionDamageType;
var ViewShakeInfo ProximityShake;
var float ProximityShakeRadius;
var float MaxImpactEffectDistance;
var float MaxFireEffectDistance;
var(Ragdoll) SkeletalMesh RagdollMesh;
var(Ragdoll) PhysicsAsset RagdollAsset;
var Vector RagdollOffset;
var Rotator RagdollRotationOffset;
var float LastJumpOutCheck;
var(Effects) ParticleSystem ExplosionTemplate;
var(Effects) ParticleSystem BigExplosionTemplate;
var array<MaterialInstanceConstant> BurnOutMaterialInstances;
var float BurnOutTime;
var(Ragdoll) float RagdollLifespan;
var float ExplosionDamage;
var float ExplosionRadius;
var float ExplosionMomentum;
var(Sounds) SoundCue ExplosionSound;
var float LastDeathImpactTime;
var SoundCue LargeChunkImpactSound;
var SoundCue MediumChunkImpactSound;
var SoundCue SmallChunkImpactSound;
var float RemainingBurn;
var name BurnTimeParameterName;
var name BurnValueParameterName;
var const editconst export editinline deprecated AudioComponent ScrapeSound;
var const editconst export editinline deprecated AudioComponent TireAudioComp;
var deprecated array<MaterialSoundEffect> TireSoundList;
var deprecated name CurrentTireMaterial;
var Vector TeamBeaconOffset;
var float SpawnRadius;
var name DrivingAnim;
var SoundCue SpawnInSound;
var SoundCue SpawnOutSound;
var(Flag) Vector FlagOffset;
var(Flag) Rotator FlagRotation;
var(Flag) name FlagBone;
var Texture2D LockedTexture;
var MaterialInstanceConstant HUDMaterialInstance;
var Vector HUDLocation;
var float MapSize;
var float IconXStart;
var float IconYStart;
var float IconXWidth;
var float IconYWidth;
var float LastPostRenderTraceTime;
var ParticleSystem SpawnInTemplates[2];
var float SpawnInTime;
var SkyEmitter SpawnEffect;
var MaterialInterface BurnOutMaterial[2];
var float CollisionDamageMult;
var float LastCollisionDamageTime;
var float SeatCameraScale;
var float OldCamPosZ;
var float CameraSmoothingFactor;
var float DefaultFOV;
var array<TimePosition> OldPositions;
var float CameraLag;
var Vector CameraOffset;
var float LookForwardDist;
var float MinCameraDistSq;
var TakeHitInfo LastTakeHitInfo;
var float LastTakeHitTimeout;
var() float RestartTime;
var float TimeLastDisabled;
var array<name> HoverBoardAttachSockets;
var array<MaterialParticleEffect> WheelParticleEffects;

replication
{
    // Pos:0x000
    if(bNetDirty
        SeatMask, Team, 
        VehicleDamagePct, WeaponRotation, 
        bDeadVehicle, bIsDisabled, 
        bPlayingSpawnEffect, bTeamLocked;

    // Pos:0x006
    if(bNetDirty && WorldInfo.TimeSeconds < LastTakeHitTimeout
        LastTakeHitInfo;
}

// Export USkyGameVehicle::execSeatFlashLocation(FFrame&, void* const)
native simulated function Vector SeatFlashLocation(int SeatIndex, optional Vector NewLoc, optional bool bReadValue);

// Export USkyGameVehicle::execSeatFlashCount(FFrame&, void* const)
native simulated function byte SeatFlashCount(int SeatIndex, optional byte NewCount, optional bool bReadValue);

// Export USkyGameVehicle::execSeatFiringMode(FFrame&, void* const)
native simulated function byte SeatFiringMode(int SeatIndex, optional byte NewFireMode, optional bool bReadValue);

// Export USkyGameVehicle::execForceWeaponRotation(FFrame&, void* const)
native simulated function ForceWeaponRotation(int SeatIndex, Rotator NewRotation);

// Export USkyGameVehicle::execGetSeatPivotPoint(FFrame&, void* const)
native simulated function Vector GetSeatPivotPoint(int SeatIndex);

// Export USkyGameVehicle::execGetBarrelIndex(FFrame&, void* const)
native simulated function int GetBarrelIndex(int SeatIndex);

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    ClientHealth = Health;
    FireDamageThreshold *= float(Health);
    // End:0x87
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x7A
        if(!bDeleteMe && SkyGame(WorldInfo.Game) != none)
        {
            SkyGame(WorldInfo.Game).RegisterVehicle(self);
        }
        InitializeSeats();        
    }
    else
    {
        // End:0xA7
        if(Seats.Length > 0)
        {
            Seats[0].SeatPawn = self;
        }
    }
    PreCacheSeatNames();
    InitializeTurrets();
    InitializeEffects();
    InitializeMorphs();
    // End:0x158
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        // End:0x132
        if(int(Class'SkyPlayerControllerBase'.default.PawnShadowMode) == int(0))
        {
            // End:0x132
            if(Mesh != none)
            {
                Mesh.CastShadow = false;
                Mesh.bCastDynamicShadow = false;
            }
        }
        // End:0x158
        if(DamageMaterialInstance == none)
        {
            DamageMaterialInstance = Mesh.CreateAndSetMaterialInstanceConstant(0);
        }
    }
    VehicleEvent('Created');
    //return;    
}

simulated function SetInputs(float InForward, float InStrafe, float InUp)
{
    Throttle = InForward;
    Steering = InStrafe;
    Rise = InUp;
    //return;    
}

simulated function float GetChargePower()
{
    //return ReturnValue;    
}

simulated exec function PlaySpawnEffect()
{
    local ParticleSystem SpawnTemplate;
    local SkyGameReplicationInfo GRI;

    SpawnTemplate = ((int(Team) < 2) ? SpawnInTemplates[int(Team)] : SpawnInTemplates[0]);
    // End:0x12D
    if(SpawnTemplate != none)
    {
        bPlayingSpawnEffect = true;
        SetHidden(true);
        SetPhysics(0);
        // End:0x11A
        if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
        {
            GRI = SkyGameReplicationInfo(WorldInfo.GRI);
            // End:0xBD
            if(GRI.SOP != none)
            {
                SpawnEffect = GRI.SOP.CreateEmitter(SpawnTemplate, self);                
            }
            else
            {
                SpawnEffect = Spawn(Class'SkyEmitter', self);
                SpawnEffect.SetTemplate(SpawnTemplate, false);
            }
            SpawnEffect.SetBase(self);
            // End:0x11A
            if(SpawnInSound != none)
            {
                PlaySound(SpawnInSound);
            }
        }
        SetTimer(SpawnInTime, false, 'StopSpawnEffect');
    }
    //return;    
}

simulated function StopSpawnEffect()
{
    // End:0x18
    if(SpawnEffect != none)
    {
        SpawnEffect.Destroy();
    }
    SetHidden(false);
    bPlayingSpawnEffect = false;
    SetPhysics(10);
    ClearTimer('StopSpawnEffect');
    //return;    
}

event SelfDestruct()
{
    //return;    
}

simulated function SetHUDLocation(Vector NewHUDLocation)
{
    HUDLocation = NewHUDLocation;
    //return;    
}

event JumpOutCheck()
{
    //return;    
}

event bool ContinueOnFoot()
{
    local SkyBotControllerBase B;

    // End:0x0E
    if(bKeyVehicle)
    {
        return false;        
    }
    else
    {
        VehicleLostTime = WorldInfo.TimeSeconds + float(12);
        B = SkyBotControllerBase(Controller);
        // End:0xC0
        if(B != none)
        {
            // End:0xA7
            if((B.RouteCache.Length > 0) && B.RouteCache[0] != none)
            {
                B.DirectionHint = Normal(B.RouteCache[0].Location - Location);
            }
            B.LeaveVehicle();
            return true;            
        }
        else
        {
            return super(Vehicle).ContinueOnFoot();
        }
    }
    //return ReturnValue;    
}

function bool FastVehicle()
{
    return false;
    //return ReturnValue;    
}

simulated function InitializeEffects()
{
    local int I, E;

    // End:0x1C
    if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
    {
        return;
    }
    // End:0x8F
    if(false && TurbulenceGridInstance != none)
    {
        // End:0x5D
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
    J0x96:

    // End:0x339 [Loop If]
    if(I < VehicleEffects.Length)
    {
        // End:0x32F
        if((VehicleEffects[I].PlayerEffectTemplate != none) || VehicleEffects[I].EffectTemplate != none)
        {
            VehicleEffects[I].EffectRef = new (self) Class'SkyParticleSystemComponent';
            VehicleEffects[I].EffectRef.SetTickGroup(TickGroup);
            VehicleEffects[I].EffectRef.bUpdateComponentInTick = true;
            VehicleEffects[I].EffectRef.bSkyPoolActive = false;
            VehicleEffects[I].EffectRef.bAutoActivate = false;
            E = 0;
            J0x197:

            // End:0x212 [Loop If]
            if(E < VehicleEffects[I].EffectStartTags.Length)
            {
                // End:0x208
                if(VehicleEffects[I].EffectStartTags[E] == 'BeginPlay')
                {
                    VehicleEffects[I].EffectRef.bAutoActivate = true;
                    // [Explicit Break]
                    goto J0x212;
                }
                E++;
                // [Loop Continue]
                goto J0x197;
            }
            J0x212:

            Mesh.AttachComponentToSocket(VehicleEffects[I].EffectRef, VehicleEffects[I].EffectSocket);
            // End:0x2D2
            if(false && VehicleEffects[I].TurbulenceEmitterInstance != none)
            {
                Mesh.AttachComponentToSocket(VehicleEffects[I].TurbulenceEmitterInstance, VehicleEffects[I].EffectSocket);
                VehicleEffects[I].TurbulenceEmitterInstance.InitComponentRBPhys(true);
            }
            VehicleEffects[I].EffectRef.DynamicLightSKMesh = Mesh;
            VehicleEffects[I].EffectRef.DynamicLightSocket = VehicleEffects[I].EffectSocket;
        }
        I++;
        // [Loop Continue]
        goto J0x96;
    }
    //return;    
}

// Export USkyGameVehicle::execSetVehicleEffectParms(FFrame&, void* const)
native simulated function SetVehicleEffectParms(name TriggerName, ParticleSystemComponent PSC);

// Export USkyGameVehicle::execTriggerVehicleEffect(FFrame&, void* const)
native simulated function TriggerVehicleEffect(name EventTag);

// Export USkyGameVehicle::execPlayVehicleAnimation(FFrame&, void* const)
native simulated function PlayVehicleAnimation(name EventTag);

// Export USkyGameVehicle::execVehicleEvent(FFrame&, void* const)
native simulated function VehicleEvent(name EventTag);

simulated function EntryAnnouncement(Controller C)
{
    super(Vehicle).EntryAnnouncement(C);
    // End:0x1D
    if(int(Role) < int(ROLE_Authority))
    {
        return;
    }
    // End:0xB9
    if(int(Team) != int(C.GetTeamNum()))
    {
        // End:0x7C
        if((int(Team) != int(255)) && PlayerController(C) != none)
        {
            // End:0x7C
            if(StolenSound != none)
            {
                PlaySound(StolenSound);
            }
        }
        // End:0xB9
        if(int(C.GetTeamNum()) != int(255))
        {
            SetTeamNum(C.GetTeamNum());
        }
    }
    //return;    
}

function bool FindAutoExit(Pawn ExitingDriver)
{
    local Vector X, Y, Z;
    local float PlaceDist;

    GetAxes(Rotation, X, Y, Z);
    Y *= float(-1);
    // End:0x62
    if(ExitRadius == float(0))
    {
        ExitRadius = CylinderComponent.CollisionRadius + (float(2) * ExitingDriver.GetCollisionRadius());
    }
    PlaceDist = ExitRadius + ExitingDriver.GetCollisionRadius();
    // End:0xDD
    if(SkyBotControllerBase(ExitingDriver.Controller) != none)
    {
        // End:0xDD
        if((SkyBotControllerBase(ExitingDriver.Controller).GetDirectionHint() Dot Y) < float(0))
        {
            Y *= float(-1);
        }
    }
    // End:0x134
    if(VSize(Velocity) > MinCrushSpeed)
    {
        // End:0x110
        if((Velocity Dot X) < float(0))
        {
            X *= float(-1);
        }
        // End:0x134
        if((Velocity Dot Y) > MinCrushSpeed)
        {
            Y *= float(-1);
        }
    }
    // End:0x16A
    if(TryExitPos(ExitingDriver, ((GetTargetLocation(none)) + ExitOffset) + (PlaceDist * Y), false))
    {
        return true;
    }
    // End:0x1A0
    if(TryExitPos(ExitingDriver, ((GetTargetLocation(none)) + ExitOffset) - (PlaceDist * Y), false))
    {
        return true;
    }
    // End:0x1D6
    if(TryExitPos(ExitingDriver, ((GetTargetLocation(none)) + ExitOffset) - (PlaceDist * X), false))
    {
        return true;
    }
    // End:0x20C
    if(TryExitPos(ExitingDriver, ((GetTargetLocation(none)) + ExitOffset) + (PlaceDist * X), false))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

event RanInto(Actor Other)
{
    local Vector Momentum;
    local float Speed;
    local Controller InstigatorController;

    // End:0x51
    if((((Pawn(Other) == none) || Vehicle(Other) != none) || Other == Instigator) || int(Other.Role) != int(ROLE_Authority))
    {
        return;
    }
    Speed = VSize(Velocity);
    // End:0x196
    if(Speed > MinRunOverSpeed)
    {
        Momentum = (Velocity * 0.2500000) * Pawn(Other).Mass;
        // End:0xB0
        if(RanOverSound != none)
        {
            PlaySound(RanOverSound);
        }
        // End:0x11B
        if(WorldInfo.GRI.OnSameTeam(self, Other))
        {
            Momentum += (((Speed * 0.2500000) * Pawn(Other).Mass) * Normal(Velocity Cross vect(0.0000000, 0.0000000, 1.0000000)));            
        }
        else
        {
            // End:0x134
            if(Controller != none)
            {
                InstigatorController = Controller;                
            }
            else
            {
                // End:0x154
                if(Instigator != none)
                {
                    InstigatorController = Instigator.Controller;
                }
            }
            Other.TakeDamage(int(Speed * 0.0750000), InstigatorController, Other.Location, Momentum, RanOverDamageType);
        }
    }
    //return;    
}

event TakeWaterDamage(float DeltaTime)
{
    local int ImpartedWaterDamage;

    AccumulatedWaterDamage += (WaterDamage * DeltaTime);
    // End:0x68
    if(AccumulatedWaterDamage > float(1))
    {
        ImpartedWaterDamage = int(AccumulatedWaterDamage);
        AccumulatedWaterDamage -= float(ImpartedWaterDamage);
        TakeDamage(ImpartedWaterDamage, Controller, Location, vect(0.0000000, 0.0000000, 0.0000000), VehicleDrowningDamType);
    }
    //return;    
}

function DriverRadiusDamage(float DamageAmount, float DamageRadius, Controller EventInstigator, class<DamageType> DamageType, float Momentum, Vector HitLocation, Actor DamageCauser)
{
    local int I;

    // End:0x32
    if(bDriverIsVisible)
    {
        super(Vehicle).DriverRadiusDamage(DamageAmount, DamageRadius, EventInstigator, DamageType, Momentum, HitLocation, DamageCauser);
    }
    I = 1;
    J0x39:

    // End:0xBF [Loop If]
    if(I < Seats.Length)
    {
        // End:0xB5
        if(Seats[I].SeatPawn.bDriverIsVisible)
        {
            Seats[I].SeatPawn.DriverRadiusDamage(DamageAmount, DamageRadius, EventInstigator, DamageType, Momentum, HitLocation, DamageCauser);
        }
        I++;
        // [Loop Continue]
        goto J0x39;
    }
    //return;    
}

simulated function Destroyed()
{
    local SkyGameVehicle V, Prev;
    local int I;

    I = 1;
    J0x07:

    // End:0x5B [Loop If]
    if(I < Seats.Length)
    {
        // End:0x51
        if(Seats[I].SeatPawn != none)
        {
            Seats[I].SeatPawn.Destroy();
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    // End:0x7B
    if(ParentFactory != none)
    {
        ParentFactory.VehicleDestroyed(self);
    }
    // End:0x191
    if(SkyGame(WorldInfo.Game) != none)
    {
        // End:0xE0
        if(SkyGame(WorldInfo.Game).VehicleList == self)
        {
            SkyGame(WorldInfo.Game).VehicleList = NextVehicle;            
        }
        else
        {
            Prev = SkyGame(WorldInfo.Game).VehicleList;
            // End:0x191
            if(Prev != none)
            {
                V = SkyGame(WorldInfo.Game).VehicleList.NextVehicle;
                J0x13D:

                // End:0x191 [Loop If]
                if(V != none)
                {
                    // End:0x16E
                    if(V == self)
                    {
                        Prev.NextVehicle = NextVehicle;
                        // [Explicit Break]
                        goto J0x191;                        
                    }
                    else
                    {
                        Prev = V;
                    }
                    V = V.NextVehicle;
                    // [Loop Continue]
                    goto J0x13D;
                }
            }
        }
    }
    J0x191:

    super.Destroyed();
    //return;    
}

simulated function DisableVehicle()
{
    local int seatIdx;

    bIsDisabled = true;
    // End:0x7F
    if(bDriving)
    {
        DriverLeave(true);
        seatIdx = 0;
        J0x23:

        // End:0x7F [Loop If]
        if(seatIdx < Seats.Length)
        {
            // End:0x75
            if(Seats[seatIdx].SeatPawn != none)
            {
                Seats[seatIdx].SeatPawn.DriverLeave(true);
            }
            ++seatIdx;
            // [Loop Continue]
            goto J0x23;
        }
    }
    ClearTimer('Enable');
    SetTimer(RestartTime, false, 'EnableVehicle');
    //return;    
}

simulated function EnableVehicle()
{
    bIsDisabled = false;
    // End:0x1B
    if(bDriving)
    {
        VehiclePlayEnterSound();
    }
    //return;    
}

event TakeFireDamage()
{
    local int CurrentDamage;

    CurrentDamage = int(AccruedFireDamage);
    AccruedFireDamage -= float(CurrentDamage);
    TakeDamage(CurrentDamage, Controller, Location, vect(0.0000000, 0.0000000, 0.0000000), ExplosionDamageType);
    //return;    
}

simulated function int GetSeatIndexFromPrefix(string Prefix)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x47 [Loop If]
    if(I < Seats.Length)
    {
        // End:0x3D
        if(Seats[I].TurretVarPrefix ~= Prefix)
        {
            return I;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    //return ReturnValue;    
}

simulated event ReplicatedEvent(name VarName)
{
    local string VarString;
    local int SeatIndex;

    // End:0x44
    if(VarName == 'bPlayingSpawnEffect')
    {
        // End:0x37
        if(bPlayingSpawnEffect)
        {
            // End:0x34
            if(int(Team) != 128)
            {
                PlaySpawnEffect();
            }            
        }
        else
        {
            StopSpawnEffect();
        }        
    }
    else
    {
        // End:0x77
        if(VarName == 'Team')
        {
            TeamChanged();
            // End:0x74
            if(bPlayingSpawnEffect)
            {
                PlaySpawnEffect();
            }            
        }
        else
        {
            // End:0x97
            if(VarName == 'VehicleDamagePct')
            {
                CheckVehicleDamage();                
            }
            else
            {
                // End:0xB7
                if(VarName == 'bDeadVehicle')
                {
                    BlowupVehicle();                    
                }
                else
                {
                    VarString = "" $ string(VarName);
                    // End:0x176
                    if(Right(VarString, 10) ~= "flashcount")
                    {
                        SeatIndex = GetSeatIndexFromPrefix(Left(VarString, Len(VarString) - 10));
                        // End:0x173
                        if(SeatIndex >= 0)
                        {
                            Seats[SeatIndex].BarrelIndex++;
                            // End:0x163
                            if(int(SeatFlashCount(SeatIndex,, true)) > int(0))
                            {
                                VehicleWeaponFired(true, vect(0.0000000, 0.0000000, 0.0000000), SeatIndex);                                
                            }
                            else
                            {
                                VehicleWeaponStoppedFiring(true, SeatIndex);
                            }
                        }                        
                    }
                    else
                    {
                        // End:0x228
                        if(Right(VarString, 13) ~= "flashlocation")
                        {
                            SeatIndex = GetSeatIndexFromPrefix(Left(VarString, Len(VarString) - 13));
                            // End:0x225
                            if(SeatIndex >= 0)
                            {
                                Seats[SeatIndex].BarrelIndex++;
                                // End:0x215
                                if(!IsZero(SeatFlashLocation(SeatIndex,, true)))
                                {
                                    VehicleWeaponFired(true, SeatFlashLocation(SeatIndex,, true), SeatIndex);                                    
                                }
                                else
                                {
                                    VehicleWeaponStoppedFiring(true, SeatIndex);
                                }
                            }                            
                        }
                        else
                        {
                            super(Vehicle).ReplicatedEvent(VarName);
                        }
                    }
                }
            }
        }
    }
    //return;    
}

function bool HasOccupiedTurret()
{
    local int I;

    I = 1;
    J0x07:

    // End:0x49 [Loop If]
    if(I < Seats.Length)
    {
        // End:0x3F
        if(Seats[I].SeatPawn.Controller != none)
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

simulated function DrivingStatusChanged()
{
    // End:0x2C
    if(bDriving)
    {
        // End:0x29
        if(DrivingPhysicalMaterial != none)
        {
            Mesh.SetPhysMaterialOverride(DrivingPhysicalMaterial);
        }        
    }
    else
    {
        // End:0x4C
        if(DefaultPhysicalMaterial != none)
        {
            Mesh.SetPhysMaterialOverride(DefaultPhysicalMaterial);
        }
    }
    // End:0x6F
    if(bDriving && !bIsDisabled)
    {
        VehiclePlayEnterSound();        
    }
    else
    {
        // End:0x84
        if(Health > 0)
        {
            VehiclePlayExitSound();
        }
    }
    bBlocksNavigation = !bDriving;
    // End:0x117
    if(((bDriving && int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && ProximityShakeRadius > 0.0000000) && (ProximityShake.OffsetTime > 1.0000000) || ProximityShake.RotTime > 1.0000000)
    {
        SetTimer(0.5000000, true, 'ProximityShakeTimer');        
    }
    else
    {
        ClearTimer('ProximityShakeTimer');
    }
    //return;    
}

simulated function ProximityShakeTimer()
{
    local PlayerController PC;
    local bool bIsWeaponPawn;
    local ViewShakeInfo NewViewShake;
    local int I;
    local float ShakeMag;

    // End:0x18A
    if(!IsZero(Velocity))
    {
        // End:0x189
        foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
        {
            // End:0x188
            if((PC.IsA('SkyPlayerController') && PC.Pawn != none) && int(PC.Pawn.Physics) == int(1))
            {
                I = 0;
                J0x7C:

                // End:0xD5 [Loop If]
                if((I < Seats.Length) && !bIsWeaponPawn)
                {
                    // End:0xCB
                    if(Seats[I].SeatPawn == PC.Pawn)
                    {
                        bIsWeaponPawn = true;
                    }
                    I++;
                    // [Loop Continue]
                    goto J0x7C;
                }
                // End:0x188
                if(!bIsWeaponPawn)
                {
                    ShakeMag = FClamp(1.0000000 - (VSize(Location - PC.Pawn.Location) / ProximityShakeRadius), 0.0000000, 1.0000000);
                    // End:0x188
                    if(ShakeMag > 0.0000000)
                    {
                        NewViewShake = ProximityShake;
                        NewViewShake.OffsetMag *= ShakeMag;
                        NewViewShake.RotMag *= ShakeMag;
                        SkyPlayerController(PC).ShakeView(NewViewShake);
                    }
                }
            }            
        }        
    }
    //return;    
}

function bool SeatAvailable(int SeatIndex)
{
    return Seats[SeatIndex].SeatPawn.Controller == none;
    //return ReturnValue;    
}

function bool AnySeatAvailable()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x49 [Loop If]
    if(I < Seats.Length)
    {
        // End:0x3F
        if(Seats[I].SeatPawn.Controller == none)
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

simulated function int GetSeatIndexForController(Controller ControllerToMove)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x79 [Loop If]
    if(I < Seats.Length)
    {
        // End:0x6F
        if((Seats[I].SeatPawn.Controller != none) && Seats[I].SeatPawn.Controller == ControllerToMove)
        {
            return I;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    //return ReturnValue;    
}

function Controller GetControllerForSeatIndex(int SeatIndex)
{
    return Seats[SeatIndex].SeatPawn.Controller;
    //return ReturnValue;    
}

function AdjacentSeat(int Direction, Controller C)
{
    local int NewSeat;

    NewSeat = (GetSeatIndexForController(C)) + Direction;
    // End:0x39
    if(NewSeat < 0)
    {
        NewSeat = Seats.Length - 1;        
    }
    else
    {
        // End:0x50
        if(NewSeat == Seats.Length)
        {
            NewSeat = 0;
        }
    }
    ServerChangeSeat(NewSeat);
    //return;    
}

reliable server function ServerChangeSeat(int RequestedSeat)
{
    ChangeSeat(Controller, RequestedSeat);
    //return;    
}

function bool HasPriority(Controller first, Controller Second)
{
    // End:0x38
    if(((first != Second) && PlayerController(first) != none) && PlayerController(Second) == none)
    {
        return true;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

function bool ChangeSeat(Controller ControllerToMove, int RequestedSeat)
{
    local int OldSeatIndex;
    local Pawn OldPawn, BumpPawn;
    local Controller BumpController;

    // End:0x12
    if(RequestedSeat >= Seats.Length)
    {
        return false;
    }
    OldSeatIndex = GetSeatIndexForController(ControllerToMove);
    // End:0x38
    if(OldSeatIndex == -1)
    {
        return false;
    }
    // End:0x12D
    if(!SeatAvailable(RequestedSeat))
    {
        BumpController = GetControllerForSeatIndex(RequestedSeat);
        // End:0x6E
        if(BumpController == none)
        {
            return false;
        }
        // End:0x89
        if(!HasPriority(ControllerToMove, BumpController))
        {
            return false;
        }
        // End:0x12D
        if(BumpController != none)
        {
            BumpPawn = Seats[RequestedSeat].StoragePawn;
            Seats[RequestedSeat].SeatPawn.DriverLeave(true);
            // End:0x12D
            if(RequestedSeat == 0)
            {
                // End:0x107
                if(BumpController.RouteGoal == self)
                {
                    BumpController.RouteGoal = none;
                }
                // End:0x12D
                if(BumpController.MoveTarget == self)
                {
                    BumpController.MoveTarget = none;
                }
            }
        }
    }
    OldPawn = Seats[OldSeatIndex].StoragePawn;
    Seats[OldSeatIndex].SeatPawn.DriverLeave(true);
    // End:0x1C6
    if(OldSeatIndex == 0)
    {
        // End:0x1A0
        if(ControllerToMove.RouteGoal == self)
        {
            ControllerToMove.RouteGoal = none;
        }
        // End:0x1C6
        if(ControllerToMove.MoveTarget == self)
        {
            ControllerToMove.MoveTarget = none;
        }
    }
    // End:0x1E3
    if(RequestedSeat == 0)
    {
        DriverEnter(OldPawn);        
    }
    else
    {
        PassengerEnter(OldPawn, RequestedSeat);
    }
    // End:0x233
    if(BumpPawn != none)
    {
        // End:0x21F
        if(OldSeatIndex == 0)
        {
            DriverEnter(BumpPawn);            
        }
        else
        {
            PassengerEnter(BumpPawn, OldSeatIndex);
        }
    }
    return true;
    //return ReturnValue;    
}

simulated event TornOff()
{
    //return;    
}

event bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    local SkyCarriedObject Flag;
    local int I;

    // End:0x15B
    if(super(Vehicle).Died(Killer, DamageType, HitLocation))
    {
        // End:0x38
        if(Killer != none)
        {
            Instigator = Killer.Pawn;
        }
        // End:0x52
        if(DamageType == Class'SkyDmgType_HazardVolume')
        {
            bNonViolentDeath = true;            
        }
        else
        {
            bNonViolentDeath = false;
        }
        HitDamageType = DamageType;
        TakeHitLocation = HitLocation;
        // End:0x9E
        if(SkyPlayerController(Killer) != none)
        {
            SkyPlayerController(Killer).StartRumble(BlowUpFFeedback);
        }
        BlowupVehicle();
        VehicleEvent('EngineStop');
        I = 1;
        J0xC2:

        // End:0x12C [Loop If]
        if(I < Seats.Length)
        {
            // End:0x122
            if(Seats[I].SeatPawn != none)
            {
                Seats[I].SeatPawn.Died(Killer, DamageType, HitLocation);
            }
            I++;
            // [Loop Continue]
            goto J0xC2;
        }
        // End:0x14E
        foreach BasedActors(Class'SkyCarriedObject', Flag)
        {
            Flag.SetBase(none);            
        }        
        NotifyVehicleFactoryOfDeath();
        return true;
    }
    return false;
    //return ReturnValue;    
}

function NotifyVehicleFactoryOfDeath()
{
    // End:0x27
    if(ParentFactory != none)
    {
        ParentFactory.VehicleDestroyed(self);
        ParentFactory = none;
    }
    //return;    
}

simulated function BlowupVehicle()
{
    bCanBeBaseForPawns = false;
    LinkHealMult = 0.0000000;
    GotoState('DyingVehicle');
    AddVelocity(TearOffMomentum, TakeHitLocation, HitDamageType);
    bDeadVehicle = true;
    //return;    
}

function bool InCustomEntryRadius(Pawn P)
{
    return false;
    //return ReturnValue;    
}

function VehicleLocked(Pawn P)
{
    P.PlaySound(VehicleLockedSound, true);
    //return;    
}

simulated function PostRenderFor(PlayerController PC, Canvas Canvas, Vector CameraPosition, Vector CameraDir)
{
    local float TextXL, YL, Dist, ScaledDist, HealthY, XScale;

    local Vector ScreenLoc, HitNormal, HitLocation, ViewPosition, CrossDir;

    local Actor HitActor;
    local Rotator ViewRotation;
    local Color TextColor;
    local string ScreenName;
    local bool bShowLocked;

    // End:0x1D
    if((CameraDir Dot (Location - CameraPosition)) <= float(0))
    {
        return;
    }
    // End:0x73
    if((((WorldInfo.GRI == none) || PC.ViewTarget == none) || PC == Controller) || PC.ViewTarget == self)
    {
        return;
    }
    bShowLocked = bIsDisabled || ((bTeamLocked && PlayerReplicationInfo == none) && !bStealthVehicle) && int(Team) != int(255);
    // End:0x10F
    if(!WorldInfo.GRI.OnSameTeam(self, PC))
    {
        // End:0x10C
        if(!bShowLocked && !PC.PlayerReplicationInfo.bOnlySpectator)
        {
        }        
    }
    else
    {
        bShowLocked = false;
    }
    PC.GetPlayerViewPoint(ViewPosition, ViewRotation);
    Dist = VSize(ViewPosition - Location);
    ScaledDist = TeamBeaconMaxDist * FClamp(0.0100000 * (GetCollisionRadius()), 1.0000000, 3.0000000);
    // End:0x18A
    if(PlayerReplicationInfo == none)
    {
        ScaledDist *= 0.2500000;
    }
    // End:0x25F
    if((PC.LODDistanceFactor * Dist) > ScaledDist)
    {
        // End:0x1B3
        if(bShowLocked)
        {
        }
        ScreenLoc = Canvas.Project(Location);
        // End:0x25C
        if((Abs(ScreenLoc.X - (0.5000000 * Canvas.ClipX)) > (0.0500000 * Canvas.ClipX)) || Abs(ScreenLoc.Y - (0.5000000 * Canvas.ClipY)) > (0.0500000 * Canvas.ClipY))
        {
            return;
        }        
    }
    else
    {
        ScreenLoc = Canvas.Project(((bShowLocked) ? Location : Location + TeamBeaconOffset));
    }
    // End:0x311
    if((((ScreenLoc.X < float(0)) || ScreenLoc.X >= Canvas.ClipX) || ScreenLoc.Y < float(0)) || ScreenLoc.Y >= Canvas.ClipY)
    {
        return;
    }
    // End:0x46C
    if((WorldInfo.TimeSeconds - LastPostRenderTraceTime) > 0.5000000)
    {
        LastPostRenderTraceTime = WorldInfo.TimeSeconds + (0.2000000 * FRand());
        bPostRenderTraceSucceeded = FastTrace(Location, ViewPosition);
        // End:0x46C
        if(!bPostRenderTraceSucceeded)
        {
            // End:0x37D
            if(bShowLocked)
            {
                return;
            }
            bPostRenderTraceSucceeded = FastTrace(Location + ((GetCollisionHeight()) * vect(0.0000000, 0.0000000, 1.0000000)), ViewPosition);
            // End:0x46C
            if(!bPostRenderTraceSucceeded)
            {
                CrossDir = Normal(vect(0.0000000, 0.0000000, 1.0000000) Cross (Location - ViewPosition));
                bPostRenderTraceSucceeded = FastTrace((Location + ((GetCollisionHeight()) * vect(0.0000000, 0.0000000, 1.0000000))) + (CylinderComponent.CollisionRadius * CrossDir), ViewPosition) || FastTrace((Location + ((GetCollisionHeight()) * vect(0.0000000, 0.0000000, 1.0000000))) - (CylinderComponent.CollisionRadius * CrossDir), ViewPosition);
            }
        }
    }
    // End:0x479
    if(!bPostRenderTraceSucceeded)
    {
        return;
    }
    // End:0x545
    if(bShowLocked)
    {
        HitActor = Trace(HitLocation, HitNormal, Location, ViewPosition, true);
        // End:0x4B5
        if(SkyGameVehicle(HitActor) != none)
        {
            return;
        }
        XScale = FClamp(((2.0000000 * TeamBeaconPlayerInfoMaxDist) - Dist) / (float(2) * TeamBeaconPlayerInfoMaxDist), 0.5500000, 1.0000000);
        XScale = XScale * XScale;
        Canvas.SetPos(ScreenLoc.X - (float(16) * XScale), ScreenLoc.Y - (float(16) * XScale));
        return;
    }
    // End:0x59A
    if(PlayerReplicationInfo == none)
    {
        HealthY = ((8.0000000 * Canvas.ClipX) / float(1024)) * (float(1) + (float(2) * Square((TeamBeaconPlayerInfoMaxDist - Dist) / TeamBeaconPlayerInfoMaxDist)));        
    }
    else
    {
        // End:0x5DE
        if(Dist > TeamBeaconPlayerInfoMaxDist)
        {
            HealthY = ((Canvas.ClipX * float(16)) * TeamBeaconPlayerInfoMaxDist) / (Dist * float(1024));            
        }
        else
        {
            HealthY = ((16.0000000 * Canvas.ClipX) / float(1024)) * (float(1) + (float(2) * Square((TeamBeaconPlayerInfoMaxDist - Dist) / TeamBeaconPlayerInfoMaxDist)));
        }
    }
    // End:0x684
    if((PlayerReplicationInfo != none) && Dist < TeamBeaconPlayerInfoMaxDist)
    {
        ScreenName = PlayerReplicationInfo.PlayerName;
        Canvas.StrLen(ScreenName, TextXL, YL);
        HealthY *= 0.5000000;        
    }
    // End:0x728
    if((PlayerReplicationInfo != none) && Dist < TeamBeaconPlayerInfoMaxDist)
    {
        Canvas.DrawColor = TextColor;
        Canvas.SetPos(ScreenLoc.X - (0.5000000 * TextXL), (ScreenLoc.Y - (1.2000000 * YL)) - (1.4000000 * HealthY));
        Canvas.DrawTextClipped(ScreenName, true);
    }
    // End:0x747
    if((PlayerReplicationInfo != none) && Dist < TeamBeaconPlayerInfoMaxDist)
    {        
    }
    //return;    
}

event SetTeamNum(byte T)
{
    // End:0x28
    if(int(T) != int(Team))
    {
        Team = T;
        TeamChanged();
    }
    //return;    
}

simulated function TeamChanged()
{
    // End:0x81
    if((TeamMaterials[1] != none) && TeamMaterials[0] != none)
    {
        // End:0x58
        if(int(Team) == int(1))
        {
            Mesh.SetMaterial(0, TeamMaterials[1]);
            DamageMaterialInstance = TeamMaterials[1];            
        }
        else
        {
            Mesh.SetMaterial(0, TeamMaterials[0]);
            DamageMaterialInstance = TeamMaterials[0];
        }
    }
    UpdateDamageMaterial();
    //return;    
}

function SendLockOnMessage(int Switch)
{
    local int I;

    I = 0;
    J0x07:

    // End:0xAB [Loop If]
    if(I < Seats.Length)
    {
        // End:0xA1
        if((PlayerController(Seats[I].SeatPawn.Controller) != none) && Seats[I].SeatPawn.IsLocallyControlled())
        {
            PlayerController(Seats[I].SeatPawn.Controller).ClientPlaySound(LockedOnSound);
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function bool TooCloseToAttack(Actor Other)
{
    return false;
    //return ReturnValue;    
}

function PlayHorn(int HornIndex)
{
    // End:0x54
    if((((WorldInfo.TimeSeconds - LastHornTime) > 3.0000000) && HornIndex >= 0) && HornIndex < HornSounds.Length)
    {
        LastHornTime = WorldInfo.TimeSeconds;
    }
    //return;    
}

function UpdateControllerOnPossess(bool bVehicleTransition)
{
    //return;    
}

simulated function int NumPassengers()
{
    local int I, num;

    I = 0;
    J0x07:

    // End:0x4E [Loop If]
    if(I < Seats.Length)
    {
        // End:0x44
        if(Seats[I].SeatPawn.Controller != none)
        {
            num++;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return num;
    //return ReturnValue;    
}

function SkyGameVehicle GetMoveTargetFor(Pawn P)
{
    return self;
    //return ReturnValue;    
}

function HandleEnteringFlag()
{
    local SkyPlayerController PC;

    // End:0x47
    if(PlayerReplicationInfo.bHasFlag)
    {
        // End:0x3C
        if(!bCanCarryFlag)
        {
            PC = SkyPlayerController(Controller);
            // End:0x39
            if(PC != none)
            {
            }            
        }
        else
        {
            // End:0x47
            if(!bDriverHoldsFlag)
            {
            }
        }
    }
    //return;    
}

function bool SuperDriverEnter(Pawn P)
{
    local Controller C;
    local bool bUsingBT;
    local SkyPawn SP;
    local SkyAIController myBot;

    // End:0x22
    if(SkyBot(P.Controller) != none)
    {
        bUsingBT = true;
    }
    Driver = P;
    Driver.StartDriving(self);
    // End:0x60
    if(Driver.Health <= 0)
    {
        Driver = none;
        return false;
    }
    SetDriving(true);
    // End:0xB9
    if(bUsingBT == false)
    {
        C = P.Controller;
        C.UnPossess();
        C.Possess(self, true);        
    }
    else
    {
        SP = SkyPawn(P);
        // End:0x1C3
        if(((SP != none) && SP.StoredRocketPackThrustController != none) && SP.RocketPackThrustVehicle != none)
        {
            SP.StoredRocketPackThrustController.Possess(self, true);
            SP.StoredRocketPackThrustController.bTakeoffOnStartup = true;
            Controller.PopState();
            SkyBotControllerPilot(Controller).Squad.SetEnemy(SkyBotControllerPilot(Controller), SkyBot(SP.Controller).CurrentEnemy);
            Controller.Focus = SP.Controller.Focus;
        }
    }
    SetTeamNum(C.GetTeamNum());
    // End:0x281
    foreach WorldInfo.AllControllers(Class'SkyAIController', myBot)
    {
        // End:0x256
        if((SkyBotControllerBase(myBot) != none) && SkyBotControllerBase(myBot).Squad != none)
        {
            SkyBotControllerBase(myBot).Squad.HandleEnemySwitchedPawn(Driver, self);
            // End:0x280
            continue;
        }
        // End:0x266
        if(SkyBotControllerBase(myBot) != none)
        {
        }
        myBot.HandleEnemySwitchedPawn(Driver, self);        
    }    
    Driver.SetOwner(self);
    // End:0x2B9
    if(PlayerController(C) != none)
    {
        PlayerController(C).GotoState(LandMovementState);
    }
    WorldInfo.Game.DriverEnteredVehicle(self, P);
    return true;
    //return ReturnValue;    
}

function bool DriverEnter(Pawn P)
{
    P.StopFiring();
    // End:0x7B
    if(Seats[0].Gun != none)
    {
        // End:0x55
        if(SkyPlayerController(Controller) != none)
        {
            SkyPlayerController(Controller).ClientStopZoom();
        }
        InvManager.SetCurrentWeapon(Seats[0].Gun);
    }
    Instigator = self;
    // End:0x98
    if(!SuperDriverEnter(P))
    {
        return false;
    }
    VehicleEvent('Occupied');
    HandleEnteringFlag();
    SetSeatStoragePawn(0, P);
    // End:0xE0
    if(PlayerController(Controller) != none)
    {
        VehicleLostTime = 0.0000000;
    }
    StuckCount = 0;
    ResetTime = WorldInfo.TimeSeconds - float(1);
    return true;
    //return ReturnValue;    
}

simulated event HoldGameObject(SkyCarriedObject GameObj)
{
    local SkyPawnBase P;

    // End:0x40
    if(bDriverHoldsFlag)
    {
        P = SkyPawnBase(Driver);
        // End:0x3D
        if(P != none)
        {
            P.HoldGameObject(GameObj);
        }        
    }
    else
    {
        AttachFlag(GameObj, Driver);
    }
    //return;    
}

simulated function AttachFlag(SkyCarriedObject FlagActor, Pawn NewDriver)
{
    // End:0x9F
    if(FlagActor != none)
    {
        // End:0x5C
        if(FlagBone == 'None')
        {
            FlagActor.BaseBoneName = 'None';
            FlagActor.BaseSkelComponent = none;
            FlagActor.SetBase(self);            
        }
        else
        {
            FlagActor.SetBase(self,, Mesh, FlagBone);
        }
        FlagActor.SetRelativeRotation(FlagRotation);
        FlagActor.SetRelativeLocation(FlagOffset);
    }
    //return;    
}

exec function FlagX(float F)
{
    FlagOffset.X = F;
    //return;    
}

exec function FlagY(float F)
{
    FlagOffset.Y = F;
    //return;    
}

exec function FlagZ(float F)
{
    FlagOffset.Z = F;
    //return;    
}

simulated function DriverLeft()
{
    local float Dist;

    super(Vehicle).DriverLeft();
    // End:0x49
    if((((int(WorldInfo.NetMode) == int(NM_Client)) || bNeverReset) || ParentFactory == none) || Occupied())
    {
        return;
    }
    Dist = VSize(Location - ParentFactory.Location);
    // End:0xD7
    if((Dist >= float(2000)) && (Dist > float(5000)) || !FastTrace(ParentFactory.Location, Location))
    {
        ResetTime = WorldInfo.TimeSeconds + ((bKeyVehicle) ? 15.0000000 : 30.0000000);
    }
    //return;    
}

function int GetFirstAvailableSeat()
{
    local int I;

    I = 1;
    J0x07:

    // End:0x39 [Loop If]
    if(I < Seats.Length)
    {
        // End:0x2F
        if(SeatAvailable(I))
        {
            return I;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    //return ReturnValue;    
}

function bool PassengerEnter(Pawn P, int SeatIndex)
{
    // End:0x4A
    if(WorldInfo.Game.bTeamGame && !WorldInfo.GRI.OnSameTeam(P, self))
    {
        return false;
    }
    // End:0x69
    if((SeatIndex <= 0) || SeatIndex >= Seats.Length)
    {
        return false;
    }
    // End:0xC8
    if(SkyPlayerController(Seats[SeatIndex].SeatPawn.Controller) != none)
    {
        SkyPlayerController(Seats[SeatIndex].SeatPawn.Controller).ClientStopZoom();
    }
    // End:0xF9
    if(!Seats[SeatIndex].SeatPawn.DriverEnter(P))
    {
        return false;
    }
    HandleEnteringFlag();
    SetSeatStoragePawn(SeatIndex, P);
    return true;
    //return ReturnValue;    
}

event bool SuperDriverLeave(bool bForceLeave)
{
    local Controller C, MyNewC;
    local bool bUsingBT;
    local SkyAIController myBot;
    local SkyBot BotController;

    // End:0x18
    if(int(Role) < int(ROLE_Authority))
    {
        ScriptTrace();
        return false;
    }
    // End:0x50
    if(!bForceLeave && !WorldInfo.Game.CanLeaveVehicle(self, Driver))
    {
        return false;
    }
    // End:0x5D
    if(Controller == none)
    {
        return false;
    }
    BotController = SkyBot(Driver.Controller);
    // End:0x8A
    if(BotController != none)
    {
        bUsingBT = true;
    }
    // End:0xC9
    if(Driver != none)
    {
        Driver.SetHardAttach(false);
        Driver.bCollideWorld = true;
        Driver.SetCollision(true, true);
    }
    SetDriving(false);
    C = Controller;
    // End:0x105
    if(C.RouteGoal == self)
    {
        C.RouteGoal = none;
    }
    // End:0x12B
    if(C.MoveTarget == self)
    {
        C.MoveTarget = none;
    }
    Controller.UnPossess();
    // End:0x449
    if((Driver != none) && Driver.Health > 0)
    {
        // End:0x221
        if(bUsingBT == false)
        {
            // End:0x1F2
            if((SkyBotControllerPilot(C) != none) && Driver.Controller == none)
            {
                C.Destroy();
                MyNewC = Spawn(Class'SkyBot');
                // End:0x1EF
                if(MyNewC != none)
                {
                    Driver.SetOwner(MyNewC);
                    MyNewC.Possess(Driver, false);
                }                
            }
            else
            {
                Driver.SetOwner(C);
                C.Possess(Driver, true);
            }            
        }
        else
        {
            // End:0x393
            if(SkyBotControllerPilot(C) != none)
            {
                SkyBotControllerPilot(C).PushState('Frozen');
                // End:0x306
                if(Pawn(C.Enemy) != none)
                {
                    // End:0x306
                    if((BotController.BotMemory != none) && !BotController.BotMemory.IsIgnoring(Pawn(C.Enemy)))
                    {
                        BotController.CurrentEnemy = Pawn(C.Enemy);
                        BotController.BotMemory.GiveGodSightFor(BotController.CurrentEnemy, 1.0000000);
                    }
                }
                // End:0x344
                if(C.Focus != none)
                {
                    Driver.Controller.Focus = C.Focus;
                }
                Driver.Controller.SetRotation(C.Rotation);
                Driver.Controller.DesiredRotation = C.Rotation;
            }
        }
        // End:0x433
        foreach WorldInfo.AllControllers(Class'SkyAIController', myBot)
        {
            // End:0x408
            if((SkyBotControllerBase(myBot) != none) && SkyBotControllerBase(myBot).Squad != none)
            {
                SkyBotControllerBase(myBot).Squad.HandleEnemySwitchedPawn(self, Driver);
                // End:0x432
                continue;
            }
            // End:0x418
            if(SkyBotControllerBase(myBot) != none)
            {
            }
            myBot.HandleEnemySwitchedPawn(self, Driver);            
        }        
        Driver.StopDriving(self);
    }
    // End:0x45F
    if(C == Controller)
    {
        Controller = none;
    }
    WorldInfo.Game.DriverLeftVehicle(self, Driver);
    DriverLeft();
    return true;
    //return ReturnValue;    
}

event bool DriverLeave(bool bForceLeave)
{
    local bool bResult;
    local Pawn OldDriver;

    OldDriver = Driver;
    bResult = SuperDriverLeave(bForceLeave);
    // End:0x42
    if(bResult)
    {
        SetSeatStoragePawn(0, none);
        Instigator = OldDriver;
    }
    return bResult;
    //return ReturnValue;    
}

function PassengerLeave(int SeatIndex)
{
    SetSeatStoragePawn(SeatIndex, none);
    //return;    
}

event CheckReset()
{
    local Controller C;

    // End:0x31
    if(bKeyVehicle && !Occupied())
    {
        Died(none, Class'Engine.DamageType', Location);
        return;
    }
    // End:0x5A
    if(Occupied())
    {
        ResetTime = WorldInfo.TimeSeconds - float(1);
        return;
    }
    // End:0x176
    foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
    {
        // End:0x175
        if((((C.Pawn != none) && WorldInfo.GRI.OnSameTeam(C, self)) && VSize(Location - C.Pawn.Location) < float(2500)) && FastTrace(C.Pawn.Location + (C.Pawn.GetCollisionHeight() * vect(0.0000000, 0.0000000, 1.0000000)), Location + ((GetCollisionHeight()) * vect(0.0000000, 0.0000000, 1.0000000))))
        {
            ResetTime = WorldInfo.TimeSeconds + float(10);            
            return;
        }        
    }    
    // End:0x1AE
    if(ParentFactory != none)
    {
        ParentFactory.ChildVehicle = none;
        ParentFactory.SpawnVehicle();
        ParentFactory = none;
    }
    Destroy();
    //return;    
}

function bool Occupied()
{
    local int I;

    // End:0x0D
    if(Controller != none)
    {
        return true;
    }
    I = 0;
    J0x14:

    // End:0x44 [Loop If]
    if(I < Seats.Length)
    {
        // End:0x3A
        if(!SeatAvailable(I))
        {
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x14;
    }
    return false;
    //return ReturnValue;    
}

function bool OpenPositionFor(Pawn P)
{
    local int I;

    // End:0xF9
    if(((((SkyGame(WorldInfo.Game).JustStarted(20.0000000) && Reservation != none) && Reservation != P.Controller) && Reservation.RouteGoal == self) && Reservation.Pawn != none) && VSize(Reservation.Pawn.Location - Location) <= VSize(P.Location - Location))
    {
        I = 0;
        J0xC9:

        // End:0xF7 [Loop If]
        if(I < Seats.Length)
        {
            // End:0xED
            if(SeatAvailable(I))
            {
                return true;
            }
            I++;
            // [Loop Continue]
            goto J0xC9;
        }
        return false;
    }
    // End:0x106
    if(Controller == none)
    {
        return true;
    }
    // End:0x135
    if(!WorldInfo.GRI.OnSameTeam(Controller, P))
    {
        return false;
    }
    I = 0;
    J0x13C:

    // End:0x16A [Loop If]
    if(I < Seats.Length)
    {
        // End:0x160
        if(SeatAvailable(I))
        {
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x13C;
    }
    return false;
    //return ReturnValue;    
}

simulated function byte GetTeamNum()
{
    local byte Result;

    Result = super(Pawn).GetTeamNum();
    // End:0x22
    if(int(Result) == int(255))
    {
        return Team;
    }
    return Result;
    //return ReturnValue;    
}

function float BotDesireability(Actor S, int TeamIndex, Actor Objective)
{
    local bool bSameTeam;
    local PlayerController P;

    bSameTeam = (int(Team) == TeamIndex) || int(Team) == 128;
    // End:0xB0
    if(bSameTeam)
    {
        // End:0xB0
        if(!bKeyVehicle && WorldInfo.TimeSeconds < PlayerStartTime)
        {
            // End:0x6B
            foreach LocalPlayerControllers(Class'Engine.PlayerController', P)
            {
                // End:0x6B
                break;                
            }            
            // End:0xB0
            if((P == none) || (P.Pawn != none) && Vehicle(P.Pawn) == none)
            {
                return 0.0000000;
            }
        }
    }
    // End:0xEC
    if((!bKeyVehicle && !bStationary) && WorldInfo.TimeSeconds < VehicleLostTime)
    {
        return 0.0000000;        
    }
    else
    {
        // End:0x126
        if(((Health <= 0) || !AnySeatAvailable()) || bTeamLocked && !bSameTeam)
        {
            return 0.0000000;
        }
    }
    // End:0x135
    if(bKeyVehicle)
    {
        return 100.0000000;
    }
    return (MaxDesireability * 0.5000000) + ((MaxDesireability * 0.5000000) * (float(Health) / float(default.Health)));
    //return ReturnValue;    
}

function float ReservationCostMultiplier(Pawn P)
{
    // End:0x1F
    if(Reservation == P.Controller)
    {
        return 1.0000000;
    }
    // End:0xB5
    if(((SkyGame(WorldInfo.Game).JustStarted(20.0000000) && Reservation != none) && Reservation.Pawn != none) && VSize(Reservation.Pawn.Location - Location) <= VSize(P.Location - Location))
    {
        return 0.0000000;
    }
    // End:0xDD
    if((Reservation == none) || Reservation.Pawn == none)
    {
        return 1.0000000;
    }
    // End:0x11C
    if((Reservation.MoveTarget == self) && Reservation.InLatentExecution(Reservation.503))
    {
        return 0.0000000;
    }
    return 0.2500000;
    //return ReturnValue;    
}

function bool ChangedReservation(Pawn P)
{
    // End:0xDE
    if((SkyGame(WorldInfo.Game).JustStarted(20.0000000) && Reservation != none) && Reservation != P.Controller)
    {
        // End:0xC2
        if(((Reservation.RouteGoal == self) && Reservation.Pawn != none) && VSize(Reservation.Pawn.Location - Location) <= VSize(P.Location - Location))
        {
            return true;
        }
        Reservation = SkyBotControllerBase(P.Controller);
        return false;
    }
    return false;
    //return ReturnValue;    
}

function bool SpokenFor(Controller C)
{
    local SkyBotControllerBase B;

    // End:0x0D
    if(Reservation == none)
    {
        return false;
    }
    // End:0x47
    if((Reservation.Pawn == none) || Vehicle(Reservation.Pawn) != none)
    {
        Reservation = none;
        return false;
    }
    // End:0xA2
    if(((Reservation.RouteGoal != self) && Reservation.MoveTarget != self) || !Reservation.InLatentExecution(Reservation.503))
    {
        Reservation = none;
        return false;
    }
    // End:0xD1
    if(!WorldInfo.GRI.OnSameTeam(Reservation, C))
    {
        return false;
    }
    B = SkyBotControllerBase(C);
    // End:0xEE
    if(B == none)
    {
        return true;
    }
    // End:0x11B
    if(Seats.Length > 0)
    {
        return B.Squad != Reservation.Squad;
    }
    // End:0x191
    if(SkyGame(WorldInfo.Game).JustStarted(20.0000000))
    {
        // End:0x191
        if(VSize(Reservation.Pawn.Location - Location) > VSize(C.Pawn.Location - Location))
        {
            return false;
        }
    }
    return true;
    //return ReturnValue;    
}

simulated function bool StopsProjectile(Projectile P)
{
    // End:0x17
    if(P.Instigator == self)
    {
        return false;
    }
    return ((P.Instigator == none) || P.Instigator.Base != self) || !P.Instigator.IsA('SkyWeaponPawn');
    //return ReturnValue;    
}

function SetReservation(Controller C)
{
    // End:0x24
    if(!SpokenFor(C))
    {
        Reservation = SkyBotControllerBase(C);
    }
    //return;    
}

function bool TeamLink(int TeamNum)
{
    return ((LinkHealMult > float(0)) && int(Team) == TeamNum) && Health > 0;
    //return ReturnValue;    
}

simulated function bool AllowLinkThroughOwnedActor(Actor OwnedActor)
{
    //return ReturnValue;    
}

function bool HealDamage(int Amount, Controller Healer, class<DamageType> DamageType)
{
    // End:0x2B
    if(PlayerController(Healer) != none)
    {
        PlayerStartTime = WorldInfo.TimeSeconds + float(3);
    }
    // End:0x8A
    if(((((Health <= 0) || Health >= default.Health) || Amount <= 0) || Healer == none) || !TeamLink(int(Healer.GetTeamNum())))
    {
        return false;
    }
    Amount = Min(int(float(Amount) * LinkHealMult), default.Health - Health);
    Health += Amount;
    ApplyMorphHeal(Amount);
    // End:0x105
    if((ResetTime - WorldInfo.TimeSeconds) < 10.0000000)
    {
        ResetTime = WorldInfo.TimeSeconds + 10.0000000;
    }
    VehicleDamagePct = byte(int(255.0000000 * (float(Health) / float(default.Health))));
    CheckVehicleDamage();
    return true;
    //return ReturnValue;    
}

function StartLinkedEffect()
{
    local MaterialInstanceConstant mic;
    local LinearColor Red, Blue;

    Red = MakeLinearColor(4.0000000, 0.1000000, 0.0000000, 1.0000000);
    Blue = MakeLinearColor(0.0000000, 1.0000000, 4.0000000, 1.0000000);
    mic = MaterialInstanceConstant(Mesh.Materials[0]);
    // End:0xBE
    if(mic != none)
    {
        // End:0x9C
        if(int(Team) == int(1))
        {
            mic.SetVectorParameterValue('Veh_OverlayColor', Blue);            
        }
        else
        {
            mic.SetVectorParameterValue('Veh_OverlayColor', Red);
        }
    }
    //return;    
}

function StopLinkedEffect()
{
    local MaterialInstanceConstant mic;
    local LinearColor Black;

    Black = MakeLinearColor(0.0000000, 0.0000000, 0.0000000, 1.0000000);
    mic = MaterialInstanceConstant(Mesh.Materials[0]);
    // End:0x69
    if(mic != none)
    {
        mic.SetVectorParameterValue('Veh_OverlayColor', Black);
    }
    //return;    
}

// Export USkyGameVehicle::execPlayHit(FFrame&, void* const)
native function PlayHit(float Damage, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, Vector Momentum, TraceHitInfo HitInfo, optional Actor DamageCauser);

// Export USkyGameVehicle::execPlayTakeHitEffects(FFrame&, void* const)
native simulated function PlayTakeHitEffects();

// Export USkyGameVehicle::execTakeDamage(FFrame&, void* const)
native simulated function TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);

// Export USkyGameVehicle::execTakeDamageInStateDyingVehicle(FFrame&, void* const)
native simulated function TakeDamageInStateDyingVehicle(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);

function bool IsArtillery()
{
    return false;
    //return ReturnValue;    
}

function bool ImportantVehicle()
{
    return false;
    //return ReturnValue;    
}

function InitializeSeats()
{
    //return;    
}

simulated function PreCacheSeatNames()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x11C [Loop If]
    if(I < Seats.Length)
    {
        Seats[I].WeaponRotationName = name(Seats[I].TurretVarPrefix $ "WeaponRotation");
        Seats[I].FlashLocationName = name(Seats[I].TurretVarPrefix $ "FlashLocation");
        Seats[I].FlashCountName = name(Seats[I].TurretVarPrefix $ "FlashCount");
        Seats[I].FiringModeName = name(Seats[I].TurretVarPrefix $ "FiringMode");
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated function InitializeTurrets()
{
    local int Seat, I;
    local SkySkelControl_TurretConstrained Turret;

    // End:0x0E
    if(Mesh == none)
    {        
    }
    else
    {
        Seat = 0;
        J0x15:

        // End:0xDA [Loop If]
        if(Seat < Seats.Length)
        {
            I = 0;
            J0x2C:

            // End:0xD0 [Loop If]
            if(I < Seats[Seat].TurretControls.Length)
            {
                Turret = SkySkelControl_TurretConstrained(Mesh.FindSkelControl(Seats[Seat].TurretControls[I]));
                // End:0xC6
                if(Turret != none)
                {
                    Turret.AssociatedSeatIndex = Seat;
                    Seats[Seat].TurretControllers[I] = Turret;
                }
                ++I;
                // [Loop Continue]
                goto J0x2C;
            }
            ++Seat;
            // [Loop Continue]
            goto J0x15;
        }
    }
    //return;    
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
    super(Vehicle).PossessedBy(C, bVehicleTransition);
    // End:0x4C
    if(Seats[0].Gun != none)
    {
        Seats[0].Gun.ClientWeaponSet(false);
    }
    //return;    
}

// Export USkyGameVehicle::execSetFiringMode(FFrame&, void* const)
native simulated function SetFiringMode(byte FiringModeNum);

simulated function ClearFlashCount(Weapon Who)
{
    local SkyVehicleWeapon VWeap;

    VWeap = SkyVehicleWeapon(Who);
    // End:0x50
    if(VWeap != none)
    {
        VehicleAdjustFlashCount(VWeap.SeatIndex, SeatFiringMode(VWeap.SeatIndex,, true), true);
    }
    //return;    
}

// Export USkyGameVehicle::execIncrementFlashCount(FFrame&, void* const)
native simulated function IncrementFlashCount(Weapon Who, byte FireModeNum);

// Export USkyGameVehicle::execSetFlashLocation(FFrame&, void* const)
native function SetFlashLocation(Weapon Who, byte FireModeNum, Vector NewLoc);

// Export USkyGameVehicle::execGetBarrelLocationAndRotation(FFrame&, void* const)
native simulated function GetBarrelLocationAndRotation(int SeatIndex, out Vector SocketLocation, optional out Rotator SocketRotation);

// Export USkyGameVehicle::execGetEffectLocation(FFrame&, void* const)
native simulated function Vector GetEffectLocation(int SeatIndex);

// Export USkyGameVehicle::execGetPhysicalFireStartLoc(FFrame&, void* const)
native simulated function Vector GetPhysicalFireStartLoc(SkyWeaponBase ForWeapon);

simulated function bool OverrideBeginFire(byte FireModeNum)
{
    //return ReturnValue;    
}

simulated function bool OverrideEndFire(byte FireModeNum)
{
    //return ReturnValue;    
}

simulated function GetWeaponViewAxes(SkyWeaponBase WhichWeapon, out Vector XAxis, out Vector YAxis, out Vector ZAxis)
{
    GetAxes(Controller.Rotation, XAxis, YAxis, ZAxis);
    //return;    
}

// Export USkyGameVehicle::execWeaponFired(FFrame&, void* const)
native simulated function WeaponFired(bool bViaReplication, optional Weapon Weap, optional ImpactInfo Impact);

// Export USkyGameVehicle::execVehicleWeaponFired(FFrame&, void* const)
native simulated function VehicleWeaponFired(bool bViaReplication, Vector HitLocation, int SeatIndex);

// Export USkyGameVehicle::execWeaponStoppedFiring(FFrame&, void* const)
native simulated function WeaponStoppedFiring(bool bViaReplication, optional Weapon Weap);

// Export USkyGameVehicle::execVehicleWeaponStoppedFiring(FFrame&, void* const)
native simulated function VehicleWeaponStoppedFiring(bool bViaReplication, int SeatIndex);

// Export USkyGameVehicle::execGetWeaponAim(FFrame&, void* const)
native function Rotator GetWeaponAim(SkyVehicleWeapon VWeapon);

// Export USkyGameVehicle::execVehicleWeaponFireEffects(FFrame&, void* const)
native simulated function VehicleWeaponFireEffects(Vector HitLocation, int SeatIndex);

simulated function Actor FindWeaponHitNormal(out Vector HitLocation, out Vector HitNormal, Vector End, Vector Start, out TraceHitInfo HitInfo)
{
    return Trace(HitLocation, HitNormal, End, Start, true,, HitInfo, 1);
    //return ReturnValue;    
}

simulated function Emitter SpawnImpactEmitter(Vector HitLocation, Vector HitNormal, MaterialImpactEffect ImpactEffect)
{
    local SkyEmitter E;
    local SkyGameReplicationInfo GRI;

    GRI = SkyGameReplicationInfo(WorldInfo.GRI);
    // End:0x6F
    if(GRI.SOP != none)
    {
        E = GRI.SOP.CreateEmitter(ImpactEffect.ParticleTemplate, self, HitLocation, Rotator(HitNormal));        
    }
    else
    {
        E = Spawn(Class'SkyEmitter', self,, HitLocation, Rotator(HitNormal));
        E.SetTemplate(ImpactEffect.ParticleTemplate, true);
    }
    return E;
    //return ReturnValue;    
}

// Export USkyGameVehicle::execVehicleAdjustFlashCount(FFrame&, void* const)
native simulated function VehicleAdjustFlashCount(int SeatIndex, byte FireModeNum, optional bool bClear);

// Export USkyGameVehicle::execVehicleAdjustFlashLocation(FFrame&, void* const)
native simulated function VehicleAdjustFlashLocation(int SeatIndex, byte FireModeNum, Vector NewLocation, optional bool bClear);

exec function FixedView(string VisibleMeshes)
{
    //return;    
}

simulated function MaybeBreak(optional name BoneName)
{
    local int ConstraintIndex;
    local Vector HitLocation, OutDir;

    // End:0x1D
    if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
    {
        return;
    }
    // End:0x19E
    if((bBreakRagdollConstraints && Mesh != none) && Mesh.PhysicsAssetInstance != none)
    {
        // End:0x7B
        if(BoneName != 'None')
        {
            ConstraintIndex = Mesh.FindConstraintIndex(BoneName);            
        }
        else
        {
            ConstraintIndex = Rand(Mesh.PhysicsAssetInstance.Constraints.Length);
            BoneName = Mesh.FindConstraintBoneName(ConstraintIndex);
        }
        // End:0x19E
        if((ConstraintIndex >= 0) && !Mesh.PhysicsAssetInstance.Constraints[ConstraintIndex].bTerminated)
        {
            HitLocation = Mesh.PhysicsAssetInstance.Constraints[ConstraintIndex].GetConstraintLocation();
            OutDir = Normal(HitLocation - Location);
            Mesh.PhysicsAssetInstance.Constraints[ConstraintIndex].TermConstraint();
            // End:0x19E
            if(BoneName != 'None')
            {
                Mesh.AddImpulse(OutDir * float(500), HitLocation, BoneName);
            }
        }
    }
    //return;    
}

simulated function StartBurnOut()
{
    // End:0x1B
    if(SpawnOutSound != none)
    {
        PlaySound(SpawnOutSound, true);
    }
    bIsBurning = true;
    //return;    
}

simulated function SetBurnOut()
{
    local int I, NumElements;
    local bool bLocalViewer;
    local PlayerController PC;

    // End:0x0F
    if(LifeSpan != float(0))
    {
        return;
    }
    // End:0x74
    if(RagdollMesh != none)
    {
        // End:0x4E
        foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
        {
            // End:0x4D
            if(PC.ViewTarget == self)
            {
                bLocalViewer = true;
                // End:0x4E
                break;
            }            
        }        
        LifeSpan = ((bLocalViewer) ? 1.5000000 * RagdollLifespan : RagdollLifespan);        
    }
    else
    {
        LifeSpan = 3.0000000;
    }
    // End:0xBE
    if(BurnOutMaterial[int(GetTeamNum())] != none)
    {
        Mesh.SetMaterial(0, BurnOutMaterial[int(GetTeamNum())]);
    }
    NumElements = Mesh.GetNumElements();
    I = 0;
    J0xDF:

    // End:0x11D [Loop If]
    if(I < NumElements)
    {
        BurnOutMaterialInstances[I] = Mesh.CreateAndSetMaterialInstanceConstant(I);
        I++;
        // [Loop Continue]
        goto J0xDF;
    }
    SetTimer(LifeSpan - BurnOutTime, false, 'StartBurnOut');
    //return;    
}

simulated function bool ShouldSpawnExplosionLight(Vector HitLocation, Vector HitNormal)
{
    local PlayerController P;
    local float Dist;

    // End:0xC1
    foreach LocalPlayerControllers(Class'Engine.PlayerController', P)
    {
        Dist = VSize(P.ViewTarget.Location - Location);
        // End:0xC0
        if(((P.Pawn == Instigator) || Dist < ExplosionLightClass.default.Radius) || (Dist < MaxExplosionLightDistance) && (Vector(P.Rotation) Dot (Location - P.ViewTarget.Location)) > float(0))
        {            
            return true;
        }        
    }    
    return false;
    //return ReturnValue;    
}

simulated event AddVelocity(Vector NewVelocity, Vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo)
{
    local Vector VelDir;
    local int I, NumPieces;

    // End:0x2E
    if(GetStateName() != 'DyingVehicle')
    {
        super.AddVelocity(NewVelocity, HitLocation, DamageType, HitInfo);
        return;
    }
    // End:0x223
    if(!IsZero(NewVelocity))
    {
        // End:0x87
        if(Location.Z > WorldInfo.StallZ)
        {
            NewVelocity.Z = FMin(NewVelocity.Z, 0.0000000);
        }
        VelDir = Normal(NewVelocity);
        NewVelocity = (DamageType.default.VehicleMomentumScaling * DamageType.default.KDamageImpulse) * VelDir;
        // End:0x207
        if((RagdollMesh != none) && int(WorldInfo.NetMode) != int(NM_DedicatedServer))
        {
            CheckHitInfo(HitInfo, Mesh, VelDir, HitLocation);
            // End:0x13A
            if(HitInfo.BoneName != 'None')
            {
                MaybeBreak(HitInfo.BoneName);
            }
            // End:0x1BC
            if(DamageType.default.bKRadialImpulse)
            {
                NumPieces = int(float(Mesh.PhysicsAssetInstance.Constraints.Length) * FMin((-2.0000000 * float(Health)) / float(default.Health), 1.0000000));
                I = 0;
                J0x198:

                // End:0x1BC [Loop If]
                if(I < NumPieces)
                {
                    MaybeBreak();
                    I++;
                    // [Loop Continue]
                    goto J0x198;
                }
            }
            // End:0x207
            if(HitInfo.BoneName != 'None')
            {
                Mesh.AddImpulse(NewVelocity, HitLocation, HitInfo.BoneName);
                return;
            }
        }
        Mesh.AddImpulse(NewVelocity, HitLocation);
    }
    //return;    
}

simulated function StopVehicleSounds()
{
    local int seatIdx;

    super.StopVehicleSounds();
    seatIdx = 0;
    J0x0D:

    // End:0x64 [Loop If]
    if(seatIdx < Seats.Length)
    {
        // End:0x5A
        if(Seats[seatIdx].SeatMotionAudio != none)
        {
            Seats[seatIdx].SeatMotionAudio.Stop();
        }
        ++seatIdx;
        // [Loop Continue]
        goto J0x0D;
    }
    //return;    
}

simulated function SwitchToRagDoll()
{
    local Vector X, Y, Z;
    local int I;
    local Rotator RagdollRotation;

    // End:0x190
    if((RagdollMesh != none) && RagdollAsset != none)
    {
        I = 0;
        J0x1F:

        // End:0xAE [Loop If]
        if(I < Attached.Length)
        {
            // End:0xA4
            if(((Attached[I] != none) && Attached[I].BaseSkelComponent == Mesh) && Attached[I].BaseBoneName != 'None')
            {
                Attached[I].SetBase(self);
                I--;
            }
            I++;
            // [Loop Continue]
            goto J0x1F;
        }
        GetAxes(Rotation, X, Y, Z);
        RagdollRotation = Rotation + RagdollRotationOffset;
        InitVehicleRagdoll(RagdollMesh, RagdollAsset, ((RagdollOffset.X * X) + (RagdollOffset.Y * Y)) + (RagdollOffset.Z * Z), false);
        Mesh.SetRBRotation(RagdollRotation);
        I = 0;
        J0x152:

        // End:0x190 [Loop If]
        if(I < Mesh.Materials.Length)
        {
            Mesh.SetMaterial(I, none);
            I++;
            // [Loop Continue]
            goto J0x152;
        }
    }
    //return;    
}

// Export USkyGameVehicle::execCheckVehicleDamage(FFrame&, void* const)
native simulated function CheckVehicleDamage();

simulated function SitDriver(SkyPawnBase UTP, int SeatIndex)
{
    // End:0x51
    if(Seats[SeatIndex].SeatBone != 'None')
    {
        UTP.SetBase(self,, Mesh, Seats[SeatIndex].SeatBone);        
    }
    else
    {
        UTP.SetBase(self);
    }
    UTP.SetHardAttach(true);
    // End:0x170
    if(Seats[SeatIndex].bSeatVisible)
    {
        // End:0xED
        if((UTP.Mesh != none) && Mesh != none)
        {
            UTP.Mesh.SetShadowParent(Mesh);
            UTP.Mesh.SetLightEnvironment(LightEnvironment);
        }
        UTP.SetMeshVisibility(true);
        UTP.SetRelativeLocation(Seats[SeatIndex].SeatOffset);
        UTP.SetRelativeRotation(Seats[SeatIndex].SeatRotation);
        UTP.Mesh.SetCullDistance(5000.0000000);        
    }
    else
    {
        UTP.SetHidden(true);
    }
    //return;    
}

simulated function DetachDriver(Pawn P)
{
    local SkyPawnBase UTP;

    super(Vehicle).DetachDriver(P);
    UTP = SkyPawnBase(P);
    // End:0x6B
    if(UTP != none)
    {
        UTP.SetWeaponAttachmentVisibility(true);
        // End:0x6B
        if(UTP.Mesh != none)
        {
            UTP.Mesh.SetBlockRigidBody(true);
        }
    }
    //return;    
}

simulated function string GetHumanReadableName()
{
    // End:0x1B
    if(VehicleNameString == "")
    {
        return "" $ string(Class);        
    }
    else
    {
        return VehicleNameString;
    }
    //return ReturnValue;    
}

event OnPropertyChange(name PropName)
{
    local int I;

    I = 0;
    J0x07:

    // End:0xA9 [Loop If]
    if(I < Seats.Length)
    {
        // End:0x9F
        if(Seats[I].bSeatVisible)
        {
            Seats[I].StoragePawn.SetRelativeLocation(Seats[I].SeatOffset);
            Seats[I].StoragePawn.SetRelativeRotation(Seats[I].SeatRotation);
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated function int GetHealth(int SeatIndex)
{
    return Health;
    //return ReturnValue;    
}

function float GetCollisionDamageModifier(const out array<RigidBodyContactInfo> ContactInfos)
{
    local float Angle;
    local Vector X, Y, Z;

    // End:0x6F
    if(bReducedFallingCollisionDamage)
    {
        GetAxes(Rotation, X, Y, Z);
        Angle = ContactInfos[0].ContactNormal Dot Z;
        return ((Angle < 0.0000000) ? Square(CollisionDamageMult * (1.0000000 + Angle)) : Square(CollisionDamageMult));        
    }
    else
    {
        return Square(CollisionDamageMult);
    }
    //return ReturnValue;    
}

simulated event RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, const out CollisionImpactData Collision, int ContactIndex)
{
    local int Damage;
    local Controller InstigatorController;

    // End:0x120
    if(Health > 0)
    {
        // End:0x120
        if(LastCollisionDamageTime != WorldInfo.TimeSeconds)
        {
            super.RigidBodyCollision(HitComponent, OtherComponent, Collision, ContactIndex);
            Damage = int(VSizeSq(Mesh.GetRootBodyInstance().PreviousVelocity) * (GetCollisionDamageModifier(Collision.ContactInfos)));
            // End:0x120
            if(Damage > 1)
            {
                // End:0xA6
                if(Controller != none)
                {
                    InstigatorController = Controller;                    
                }
                else
                {
                    // End:0xC6
                    if(Instigator != none)
                    {
                        InstigatorController = Instigator.Controller;
                    }
                }
                TakeDamage(Damage, InstigatorController, Collision.ContactInfos[0].ContactPosition, vect(0.0000000, 0.0000000, 0.0000000), Class'SkyDmgType_Collision');
                LastCollisionDamageTime = WorldInfo.TimeSeconds;
            }
        }
    }
    //return;    
}

simulated function InitializeMorphs()
{
    local int I, J;

    I = 0;
    J0x07:

    // End:0xD1 [Loop If]
    if(I < DamageMorphTargets.Length)
    {
        DamageMorphTargets[I].MorphNode = MorphNodeWeight(Mesh.FindMorphNode(DamageMorphTargets[I].MorphNodeName));
        J = 0;
        J0x60:

        // End:0xC7 [Loop If]
        if(J < DamageMorphTargets.Length)
        {
            // End:0xBD
            if(DamageMorphTargets[J].LinkedMorphNodeName == DamageMorphTargets[I].MorphNodeName)
            {
                DamageMorphTargets[J].LinkedMorphNodeIndex = I;
            }
            J++;
            // [Loop Continue]
            goto J0x60;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

// Export USkyGameVehicle::execUpdateDamageMaterial(FFrame&, void* const)
native simulated function UpdateDamageMaterial();

// Export USkyGameVehicle::execApplyMorphDamage(FFrame&, void* const)
native function ApplyMorphDamage(Vector HitLocation, int Damage, Vector Momentum);

simulated event ReceivedHealthChange()
{
    local int Diff;

    Diff = Health - ClientHealth;
    // End:0x2F
    if(Diff > 0)
    {
        ApplyMorphHeal(Diff);        
    }
    else
    {
        ApplyRandomMorphDamage(Diff);
    }
    ClientHealth = Health;
    //return;    
}

simulated event ApplyMorphHeal(int Amount)
{
    local int Individual, Total, Remaining, I;
    local float Weight;

    // End:0x8A
    if(Health >= default.Health)
    {
        I = 0;
        J0x16:

        // End:0x87 [Loop If]
        if(I < DamageMorphTargets.Length)
        {
            DamageMorphTargets[I].Health = default.DamageMorphTargets[I].Health;
            DamageMorphTargets[I].MorphNode.SetNodeWeight(0.0000000);
            I++;
            // [Loop Continue]
            goto J0x16;
        }        
    }
    else
    {
        I = 0;
        J0x91:

        // End:0xF9 [Loop If]
        if(I < DamageMorphTargets.Length)
        {
            // End:0xEF
            if(DamageMorphTargets[I].Health < default.DamageMorphTargets[I].Health)
            {
                Total += default.DamageMorphTargets[I].Health;
            }
            I++;
            // [Loop Continue]
            goto J0x91;
        }
        // End:0x2C1
        if((Amount > 0) && Total > 0)
        {
            Remaining = Amount;
            I = 0;
            J0x123:

            // End:0x1C8 [Loop If]
            if(I < DamageMorphTargets.Length)
            {
                Individual = Min(default.DamageMorphTargets[I].Health - DamageMorphTargets[I].Health, int((float(Amount) * float(default.DamageMorphTargets[I].Health)) / float(Total)));
                DamageMorphTargets[I].Health += Individual;
                Remaining -= Individual;
                I++;
                // [Loop Continue]
                goto J0x123;
            }
            I = 0;
            J0x1CF:

            // End:0x2C1 [Loop If]
            if(I < DamageMorphTargets.Length)
            {
                // End:0x24E
                if(Remaining > 0)
                {
                    Individual = Min(Remaining, default.DamageMorphTargets[I].Health - DamageMorphTargets[I].Health);
                    DamageMorphTargets[I].Health += Individual;
                    Remaining -= Individual;
                }
                Weight = 1.0000000 - (float(DamageMorphTargets[I].Health) / float(default.DamageMorphTargets[I].Health));
                DamageMorphTargets[I].MorphNode.SetNodeWeight(Weight);
                I++;
                // [Loop Continue]
                goto J0x1CF;
            }
        }
    }
    UpdateDamageMaterial();
    //return;    
}

simulated event ApplyRandomMorphDamage(int Amount)
{
    local int Min, minindex, I;
    local float Weight;

    J0x00:
    // End:0x193 [Loop If]
    if(Amount > 0)
    {
        minindex = -1;
        I = 0;
        J0x1D:

        // End:0xBC [Loop If]
        if(I < DamageMorphTargets.Length)
        {
            // End:0xB2
            if(DamageMorphTargets[I].Health == default.DamageMorphTargets[I].Health)
            {
                // End:0xB2
                if((minindex < 0) || default.DamageMorphTargets[I].Health < Min)
                {
                    Min = default.DamageMorphTargets[I].Health;
                    minindex = I;
                }
            }
            I++;
            // [Loop Continue]
            goto J0x1D;
        }
        // End:0x18D
        if(minindex >= 0)
        {
            // End:0xFD
            if(Min < Amount)
            {
                DamageMorphTargets[minindex].Health = 0;
                Amount -= Min;                
            }
            else
            {
                DamageMorphTargets[minindex].Health -= Amount;
                Amount = 0;
            }
            Weight = 1.0000000 - (float(DamageMorphTargets[minindex].Health) / float(default.DamageMorphTargets[minindex].Health));
            DamageMorphTargets[minindex].MorphNode.SetNodeWeight(Weight);            
        }
        else
        {
            // [Explicit Break]
            goto J0x193;
        }
        // [Loop Continue]
        goto J0x00;
    }
    J0x193:

    UpdateDamageMaterial();
    //return;    
}

exec function SetMorphTarget(string Cmd)
{
    local string C, V;
    local MorphNodeWeight MN;

    C = Left(Cmd, InStr(Cmd, "="));
    V = Mid(Cmd, InStr(Cmd, "=") + 1);
    MN = MorphNodeWeight(Mesh.FindMorphNode(name(C)));
    // End:0x7C
    if(MN != none)
    {
        MN.SetNodeWeight(float(V));
    }
    UpdateDamageMaterial();
    //return;    
}

simulated event MorphTargetDestroyed(int MorphNodeIndex)
{
    //return;    
}

simulated function GetSVehicleDebug(out array<string> DebugInfo)
{
    super.GetSVehicleDebug(DebugInfo);
    DebugInfo[DebugInfo.Length] = "";
    //return;    
}

function OnExitVehicle(SkySeqAct_ExitVehicle Action)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x8B [Loop If]
    if(I < Seats.Length)
    {
        // End:0x81
        if((Seats[I].SeatPawn != none) && Seats[I].SeatPawn.Driver != none)
        {
            Seats[I].SeatPawn.DriverLeave(true);
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated exec function DamageDebug()
{
    bShowDamageDebug = !bShowDamageDebug;
    //return;    
}

simulated exec function DamageDamage(int Index)
{
    DamageMorphTargets[Index].Health = 0;
    //return;    
}

function SetShieldActive(int SeatIndex, bool bActive)
{
    //return;    
}

function SetSeatStoragePawn(int SeatIndex, Pawn PawnToSit)
{
    local int Mask;

    Seats[SeatIndex].StoragePawn = PawnToSit;
    Mask = 1 << SeatIndex;
    // End:0x4A
    if(PawnToSit != none)
    {
        SeatMask = SeatMask | Mask;        
    }
    else
    {
        // End:0x6E
        if((SeatMask & Mask) > 0)
        {
            SeatMask = SeatMask ^ Mask;
        }
    }
    //return;    
}

simulated state DyingVehicle
{
    ignores BreathTimer, FellOutOfWorld, PlayFiring, PlayWeaponSwitch, PlayNextAnimation, BaseChange, 
	    Landed, Died, PostRenderFor, BlowupVehicle;

    simulated function InitialVehicleExplosion()
    {
        local SkyEmitter ProjExplosion;
        local editinline SkyExplosionLight L;
        local SkyGameReplicationInfo GRI;

        // End:0x116
        if(EffectIsRelevant(Location, false))
        {
            GRI = SkyGameReplicationInfo(WorldInfo.GRI);
            // End:0x6E
            if(GRI.SOP != none)
            {
                ProjExplosion = GRI.SOP.CreateEmitter(BigExplosionTemplate, self);                
            }
            else
            {
                ProjExplosion = Spawn(Class'SkyEmitter', self);
                ProjExplosion.SetTemplate(BigExplosionTemplate, true);
            }
            // End:0x116
            if(ProjExplosion != none)
            {
                // End:0x116
                if(((ExplosionLightClass != none) && !WorldInfo.bDropDetail) && ShouldSpawnExplosionLight(Location, vect(0.0000000, 0.0000000, 1.0000000)))
                {
                    L = new (Outer) ExplosionLightClass;
                    ProjExplosion.AttachComponent(L);
                }
            }
        }
        // End:0x131
        if(ExplosionSound != none)
        {
            PlaySound(ExplosionSound, true);
        }
        HurtRadius(ExplosionDamage, ExplosionRadius, 0.0000000, Class'SkyDmgType_LargeExplosives', ExplosionMomentum, Location);
        //return;        
    }
    stop;    
}
