class MOHAPawn extends Pawn
    abstract
    native
    nativereplication
    config(Game)
    hidecategories(Navigation);

const FOOTGROUNDPOS_STEPDOWNHEIGHT = -150.0f;
const FOOTGROUNDPOS_STEPUPHEIGHT = 35.0f;

enum EHitLocation
{
    HitLoc_Head,                    // 0
    HitLoc_RArm,                    // 1
    HitLoc_LArm,                    // 2
    HitLoc_Torso,                   // 3
    HitLoc_Crotch,                  // 4
    HitLoc_LLeg,                    // 5
    HitLoc_RLeg,                    // 6
    HitLoc_MAX                      // 7
};

struct native FootGroundData
{
    var transient bool bLookedForFootControl;
    var transient bool bTraceHit;
    var transient Vector TraceWorldFootPos;
    var transient Vector TraceHitLocation;
    var transient Vector TraceHitNormal;
    var transient Vector FootGroundPos;
    var transient int FootBoneIdx;
    var transient SkelControlFootPlacement FootControl;

    structdefaultproperties
    {
        bLookedForFootControl=false
        bTraceHit=false
        TraceWorldFootPos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        TraceHitLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        TraceHitNormal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        FootGroundPos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        FootBoneIdx=0
        FootControl=none
    }
};

struct native transient BoneDamageInfo
{
    var init name BoneName;
    var init float DamageModifier;
    var init MOHAPawn.EHitLocation DamageLocation;

    structdefaultproperties
    {
        BoneName="None"
        DamageModifier=0.0000000
        DamageLocation=0
    }
};

var(Loadout) config array<config WeaponInfo> DefaultWeaponLoadout;
var(Loadout) config array<config AmmoInfo> DefaultAmmoLoadout;
var export editinline MOHAAirdropComponent AirdropComponent;
var MOHAParachuteActor AirdropParachuteMesh;
var ParachuteClothSimActor ParachuteClothSim;
var MOHAWindVolume AirdropTouchingWindVolumes[4];
var const int MaxTouchingWindVolumes;
var(InThePlane) name SocketName;
var(InThePlane) name RefBoneName;
var(InThePlane) name AnimName;
var(InThePlane) bool bBehindPlayer;
var bool bIsPlaying;
var(Debugging) bool bVerboseLogging;
var bool bSpectatable;
var bool bOneShotKill;
var bool bMeshAdj_Enabled;
var config bool DebugBoneDamage;
var(AI_Noise) bool bDrawNoiseRadius;
var() bool bDebugDrawBone;
var() bool bDebugWeaponBone;
var bool bDummyFiring;
var float fAnimRate;
var float fCurrentAnimTime;
var float fTimePaused;
var int nPushes;
var float fPlayerPushInterval;
var int nMaxPushes;
var int DesiredPosture;
var int PostureOverride;
var int PlayByPostureOverride;
var MOHAPlayerController CamController;
var MOHAIncludeClass.EPawnType PawnSide;
var float FootstepHeight;
var Emitter FootstepEmitter;
var export editinline array<export editinline AudioComponent> ImpactSoundComponents;
var int NextImpactSoundIndex;
var() int MaxImpactSoundCount;
var() name WeaponSocket;
var int m_iWeaponUpgradeStatus;
var class<WeaponAttachment> CurrentWeaponAttachmentClass;
var WeaponAttachment CurrentWeaponAttachment;
var int numHits;
var export editinline AxonScriptEventObserverComponent AxonObserver;
var export editinline DynamicLightEnvironmentComponent LightEnvComponent;
var PhysicalMaterial LastMaterialTouched;
var Vector LastFootstepLocation;
var(Footstep) config float MaxFootstepEffectDistance;
var transient int LastHitRigdBodyId;
var transient name LastHitRigdBodyBoneName;
var transient Vector LastHitDirection;
var transient class<DamageType> LastHitDamageType;
var transient float VelocityMagAtDeath;
var float FootGroundPos_StepDownMax;
var float MeshAdj_DesiredDelta;
var float MeshAdj_BlendTimeRemaining;
var float MeshAdj_BlendWeight;
var transient bool bMeshAdj_DynamicDisable;
var transient bool RagdollThrowActivated;
var transient FootGroundData LeftFootData;
var transient FootGroundData RightFootData;
var config array<config BoneDamageInfo> BoneDamageTuning;
var(AI_Noise) float fCrouchFootstepSoundRadius;
var(AI_Noise) float fNormalFootstepSoundRadius;
var(AI_Noise) float fSprintFootstepSoundRadius;
var(AI_Noise) float fLandFootstepSoundRadius;
var const transient float fCurrentNoiseRadius;
var(AI_Noise) float fNoiseRadiusDecayPerSecond;
var(Damage) config float RagdollThrowWeaponImpulseMultiplier;
var(Damage) config float RagdollThrowCheckDistance;
var(Damage) config int RagdollThrowPitch;
var(Damage) config float GeneralHitMomentumScalar;
var() name CurrentDebugBone;
var Actor dummyFireTarget;
var SoundCue MeleeImpactNPC;
var SoundCue MeleeImpactPC;
var class<MOHAParachuteActor> ParachuteClass;
var SkeletalMesh BodySkeletalMesh;
var(Wearables) SkeletalMesh HeadSkeletalMesh;
var(Wearables) SkeletalMesh GearSkeletalMesh;

replication
{
    // Pos:0x000
    if(bNetInitial
        m_iWeaponUpgradeStatus;
}

// Export UMOHAPawn::execNoiseRadius(FFrame&, void* const)
native final function NoiseRadius(float fNewRadius);

// Export UMOHAPawn::execGetCurrentNoiseRadius(FFrame&, void* const)
native function float GetCurrentNoiseRadius();

// Export UMOHAPawn::execDoAirdropPendulumViewRotation(FFrame&, void* const)
native function Rotator DoAirdropPendulumViewRotation(Rotator in_rotation, out Rotator delta_clamped);

// Export UMOHAPawn::execCalculateParachuteOrientation(FFrame&, void* const)
native function Rotator CalculateParachuteOrientation(Rotator ownerRotation);

// Export UMOHAPawn::execGetPawnBody(FFrame&, void* const)
native function MOHAPawn GetPawnBody();

// Export UMOHAPawn::execGetAimPosToShootMe(FFrame&, void* const)
native function Vector GetAimPosToShootMe();

// Export UMOHAPawn::execIsTeammate(FFrame&, void* const)
native simulated function bool IsTeammate(Pawn OtherPawn);

// Export UMOHAPawn::execGetTeamIndex(FFrame&, void* const)
native simulated function int GetTeamIndex();

// Export UMOHAPawn::execInitFeetData(FFrame&, void* const)
native final function InitFeetData();

// Export UMOHAPawn::execSetCompositeMesh(FFrame&, void* const)
native function SetCompositeMesh();

function OnPathGenerationStart()
{
    SetCollision(false, false, false);
    //return;    
}

function OnPathGenerationFinish()
{
    SetCollision(true, true, false);
    //return;    
}

event bool ShouldHandsLock()
{
    local float dist;

    // End:0x1A
    if((Mesh == none) || CurrentWeaponAttachment == none)
    {
        return false;
    }
    dist = VSize(Mesh.GetBoneLocation('LeftHand') - CurrentWeaponAttachment.GetLeftHandPosition());
    // End:0x60
    if(dist > float(10))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

simulated event int GetWeaponType()
{
    return ((EALAWeapon(Weapon) != none) ? int(EALAWeapon(Weapon).WeaponType) : 0);
    //return ReturnValue;    
}

event Landed(Vector HitNormal, Actor FloorActor)
{
    // End:0x1B
    if(AirdropParachuteMesh != none)
    {
        AirdropParachuteMesh.SetBase(none);
    }
    super.Landed(HitNormal, FloorActor);
    //return;    
}

event OnSpawnParachuteAndAttach(SequenceAction Other)
{
    InitializeAirdropState();
    //return;    
}

simulated function InitializeAirdropState()
{
    // End:0x09
    if(bVerboseLogging)
    {
    }
    // End:0xAC
    if(none != AirdropComponent)
    {
        // End:0x44
        if(MOHAPlayerController(Controller) != none)
        {
            MOHAPlayerController(Controller).SpawnParachute();
            SetPhysics(11);            
        }
        else
        {
            SetPhysics(2);
        }
        // End:0x9F
        if(AirdropParachuteMesh == none)
        {
            AirdropParachuteMesh = __NFUN_278__(ParachuteClass);
            // End:0x73
            if(AirdropParachuteMesh == none)
            {
            }
            AirdropParachuteMesh.GotoState('UnInitializedState');
            AirdropParachuteMesh.Initialize(self);
        }
        InitializeAirdropComponent();        
    }
    else
    {
        // End:0xB5
        if(bVerboseLogging)
        {
        }
    }
    //return;    
}

simulated function bool IsTouchingWindVolume()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x30 [Loop If]
    if(I < 4)
    {
        // End:0x26
        if(AirdropTouchingWindVolumes[I] != none)
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

simulated function StartWindVolumeSound()
{
    //return;    
}

simulated function StopWindVolumeSound()
{
    //return;    
}

simulated event UpdateWindVolumeSound(float NewVolume)
{
    //return;    
}

simulated event TouchedWindVolume(MOHAWindVolume Other)
{
    local int I;

    // End:0x19
    if(!IsTouchingWindVolume())
    {
        StartWindVolumeSound();
    }
    I = 0;
    J0x20:

    // End:0x5B [Loop If]
    if(I < 4)
    {
        // End:0x51
        if(AirdropTouchingWindVolumes[I] == none)
        {
            AirdropTouchingWindVolumes[I] = Other;
            // [Explicit Break]
            goto J0x5B;
        }
        I++;
        // [Loop Continue]
        goto J0x20;
    }
    J0x5B:

    //return;    
}

simulated event UntouchedWindVolume(MOHAWindVolume Other)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x42 [Loop If]
    if(I < 4)
    {
        // End:0x38
        if(AirdropTouchingWindVolumes[I] == Other)
        {
            AirdropTouchingWindVolumes[I] = none;
            // [Explicit Break]
            goto J0x42;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    J0x42:

    // End:0x5B
    if(!IsTouchingWindVolume())
    {
        StopWindVolumeSound();
    }
    //return;    
}

simulated function InitializeAirdropComponent()
{
    // End:0x09
    if(bVerboseLogging)
    {
    }
    AirdropComponent.InitializeAirdropComponent();
    //return;    
}

function SetITPParameters(float fNewPushTime, int fNewNumPushes)
{
    fPlayerPushInterval = fNewPushTime;
    nMaxPushes = fNewNumPushes;
    //return;    
}

event float GetITPAnimatonLength(SkeletalMeshComponent in_Mesh)
{
    // End:0x25
    if(in_Mesh != none)
    {
        return MOHASkeletalMeshComponent(in_Mesh).GetAnimLength(AnimName);
    }
    return -1.0000000;
    //return ReturnValue;    
}

event float GetITPAnimationNormalizedPosition(SkeletalMeshComponent in_Mesh)
{
    // End:0x29
    if(in_Mesh != none)
    {
        return MOHASkeletalMeshComponent(in_Mesh).GetAnimNormalizedPosition(AnimName);
    }
    return -1.0000000;
    //return ReturnValue;    
}

event float GetITPAnimationCurrentTime(SkeletalMeshComponent in_Mesh)
{
    // End:0x2E
    if(MOHASkeletalMeshComponent(in_Mesh) != none)
    {
        return MOHASkeletalMeshComponent(in_Mesh).GetAnimCurrentTime(AnimName);
    }
    return -1.0000000;
    //return ReturnValue;    
}

function SetAnimRate(float DesiredAnimRate)
{
    fAnimRate = DesiredAnimRate;
    //return;    
}

function PlayAnimation()
{
    // End:0x34
    if(Mesh != none)
    {
        MOHASkeletalMeshComponent(Mesh).PlayAnimAtRate(AnimName, fAnimRate, fCurrentAnimTime, false, false);
    }
    //return;    
}

function StartAnimation()
{
    bIsPlaying = true;
    SetAnimRate(1.0000000);
    PlayAnimation();
    //return;    
}

function StopAnimation()
{
    bIsPlaying = false;
    SetAnimRate(0.0000000);
    fCurrentAnimTime = GetITPAnimationCurrentTime(Mesh);
    PlayAnimation();
    //return;    
}

function ConsumeAmmo(EALAWeapon Weap, byte FireModeNum)
{
    Weap.SubtractAmmo(1, FireModeNum);
    //return;    
}

function bool BotFire(bool bFinished)
{
    // End:0x16
    if(bFinished)
    {
        StopFiring();        
    }
    else
    {
        StartFire(ChooseFireMode());
    }
    return true;
    //return ReturnValue;    
}

simulated function Rotator GetPostAdjustedAimFor(Weapon W, Vector StartFireLoc, Rotator DesiredAimRot, Rotator PostAdjustAimRot)
{
    return PostAdjustAimRot;
    //return ReturnValue;    
}

simulated function SetRootMotion(int mode)
{
    local SkeletalMeshComponent.ERootMotionMode rm_mode;

    rm_mode = 2;
    switch(mode)
    {
        // End:0x1E
        case 1:
            rm_mode = 0;
            // End:0x41
            break;
        // End:0x2E
        case 2:
            rm_mode = 1;
            // End:0x41
            break;
        // End:0x3E
        case 3:
            rm_mode = 3;
            // End:0x41
            break;
        // End:0xFFFF
        default:
            break;
    }
    Mesh.RootMotionMode = rm_mode;
    Mesh.bForceDiscardRootMotion = true;
    Mesh.bRootMotionModeChangeNotify = false;
    bForceMaxAccel = false;
    // End:0x88
    if(bVerboseLogging)
    {
    }
    //return;    
}

simulated function Vector GetWeaponStartTraceLocation(optional Weapon CurrentWeapon)
{
    return super.GetWeaponStartTraceLocation(CurrentWeapon);
    //return ReturnValue;    
}

function SetUnSpectatable()
{
    bSpectatable = false;
    //return;    
}

simulated function MOHAIncludeClass.EPawnType GetPawnType()
{
    return PawnSide;
    //return ReturnValue;    
}

simulated event PlayImpactEffects(MOHAPhysicalMaterialProperty.EImpactType ImpactType, name BoneName)
{
    //return;    
}

simulated event PlayImpact(MOHAPhysicalMaterialProperty.EImpactType ImpactType, Vector HitLocation, Vector HitNormal, Actor HitActor, PhysicalMaterial PhysMaterial, optional float VolumeScale = 1.0000000)
{
    local DecalLifetimeData LifetimeData;
    local MaterialInstance DecalMaterial;
    local float DecalWidth, DecalHeight;
    local ParticleSystem ParticleTemplate;
    local SoundCue ImpactSound;
    local editinline AudioComponent AudioPlayer;
    local MOHAIncludeClass.EPawnType PawnType;

    PawnType = PawnSide;
    // End:0x4D
    if(!IsLocallyControlled())
    {
        // End:0x4D
        if(int(PawnType) == int(0))
        {
            PawnType = ((int(GetTeamNum()) == 1) ? 2 : 1);
        }
    }
    ImpactSound = Class'MOHAPhysicalMaterialProperty'.static.GetImpactSound(PhysMaterial, ImpactType, PawnType);
    DecalMaterial = Class'MOHAPhysicalMaterialProperty'.static.GetDecal(PhysMaterial, ImpactType, PawnType, DecalWidth, DecalHeight);
    ParticleTemplate = Class'MOHAPhysicalMaterialProperty'.static.GetParticleSystem(PhysMaterial, ImpactType, PawnType);
    // End:0x1C7
    if(ImpactSound != none)
    {
        // End:0xFA
        if(ImpactSoundComponents.Length <= NextImpactSoundIndex)
        {
            ImpactSoundComponents.Length = ImpactSoundComponents.Length + 1;
        }
        AudioPlayer = ImpactSoundComponents[NextImpactSoundIndex];
        // End:0x125
        if(AudioPlayer != none)
        {
            AudioPlayer.Stop();
        }
        AudioPlayer = self.CreateAudioComponent(ImpactSound, false, true);
        // End:0x1C7
        if(AudioPlayer != none)
        {
            ImpactSoundComponents[NextImpactSoundIndex] = AudioPlayer;
            NextImpactSoundIndex++;
            // End:0x178
            if(NextImpactSoundIndex >= MaxImpactSoundCount)
            {
                NextImpactSoundIndex = 0;
            }
            AudioPlayer.bUseOwnerLocation = false;
            AudioPlayer.Location = HitLocation;
            AudioPlayer.bAutoDestroy = true;
            AudioPlayer.FadeIn(0.0000000, VolumeScale);
        }
    }
    // End:0x248
    if((DecalMaterial != none) && HitActor != none)
    {
        LifetimeData = new (HitActor.Outer) Class'Engine.DecalLifetimeDataAge';
        HitActor.AddDecal(DecalMaterial, HitLocation, Rotator(-HitNormal), 0.0000000, DecalWidth, DecalHeight, 10.0000000, false, none, LifetimeData, false, false, name("None"));
    }
    // End:0x2DC
    if(((ParticleTemplate != none) && FootstepEmitter != none) && EffectIsRelevant(HitLocation, false, MaxFootstepEffectDistance, ParticleTemplate))
    {
        FootstepEmitter.SetLocation(HitLocation);
        FootstepEmitter.SetRotation(Rotator(HitNormal) + Rotation);
        FootstepEmitter.SetTemplate(ParticleTemplate);
        FootstepEmitter.ParticleSystemComponent.ActivateSystem();
    }
    //return;    
}

function bool ShouldPlayImpactParticleEffect(MOHAPhysicalMaterialProperty.EImpactType ImpactType)
{
    return true;
    //return ReturnValue;    
}

simulated function PlayFootstep(MOHAPhysicalMaterialProperty.EImpactType ImpactType, optional Vector StartTrace)
{
    local TraceHitInfo HitInfo;
    local Vector HitLocation, HitNormal, EndTrace;
    local Actor HitActor;
    local PhysicalMaterial FootstepMaterial;

    // End:0xD2
    if(int(Physics) == int(9))
    {
        // End:0x58
        if(int(WorldInfo.NetMode) == int(NM_Standalone))
        {
            // End:0x3C
            if(MOHALadderVolume(OnLadder) == none)
            {
                return;
            }
            FootstepMaterial = MOHALadderVolume(OnLadder).PhysMaterial;            
        }
        else
        {
            // End:0x66
            if(MOHAMultiplayerPawn(self) == none)
            {
                return;
            }
            // End:0xA7
            if(IsLocallyControlled() && MOHAMultiplayerPawn(self).OnLadderMP != none)
            {
                FootstepMaterial = MOHAMultiplayerPawn(self).OnLadderMP.PhysMaterial;                
            }
            else
            {
                return;
            }
        }
        HitLocation = Location - (vect(0.0000000, 0.0000000, 1.0000000) * (GetCollisionHeight()));        
    }
    else
    {
        // End:0x126
        if(((StartTrace.X == float(0)) && StartTrace.Y == float(0)) && StartTrace.Z == float(0))
        {
            StartTrace = Location;
        }
        // End:0x144
        if(false == (EffectIsRelevant(StartTrace, false, MaxFootstepEffectDistance)))
        {
            return;
        }
        EndTrace = StartTrace;
        EndTrace.Z = Location.Z - FootstepHeight;
        HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace,,, HitInfo);
        // End:0x1A7
        if(HitActor == none)
        {
            return;
        }
        FootstepMaterial = HitInfo.PhysMaterial;
    }
    LastMaterialTouched = FootstepMaterial;
    LastFootstepLocation = HitLocation;
    AIFootstepNoise(ImpactType);
    PlayImpact(ImpactType, HitLocation, HitNormal, HitActor, FootstepMaterial);
    //return;    
}

function AIFootstepNoise(MOHAPhysicalMaterialProperty.EImpactType ImpactType)
{
    local float soundRadius;

    switch(ImpactType)
    {
        // End:0x0C
        case 2:
        // End:0x11
        case 4:
        // End:0x16
        case 5:
        // End:0x1B
        case 8:
        // End:0x2E
        case 9:
            soundRadius = fNormalFootstepSoundRadius;
            // End:0x7F
            break;
        // End:0x33
        case 10:
        // End:0x46
        case 11:
            soundRadius = fCrouchFootstepSoundRadius;
            // End:0x7F
            break;
        // End:0x59
        case 3:
            soundRadius = fSprintFootstepSoundRadius;
            // End:0x7F
            break;
        // End:0x5E
        case 6:
        // End:0x71
        case 7:
            soundRadius = fLandFootstepSoundRadius;
            // End:0x7F
            break;
        // End:0xFFFF
        default:
            soundRadius = 0.0000000;
            break;
    }
    NoiseRadius(soundRadius);
    //return;    
}

simulated function PlayWeaponSwitch(Weapon OldWeapon, Weapon NewWeapon)
{
    // End:0x28
    if(OldWeapon != none)
    {
        Mesh.DetachComponent(OldWeapon.Mesh);
    }
    AttachNewWeapon();
    //return;    
}

simulated function AttachNewWeapon()
{
    // End:0x5D
    if((Weapon != none) && Weapon.Mesh != none)
    {
        Mesh.AttachComponentToSocket(Weapon.Mesh, WeaponSocket);
        Weapon.Mesh.SetDepthPriorityGroup(1);
    }
    //return;    
}

event OnOIREntryFinished()
{
    //return;    
}

function Tick(float DeltaTime)
{
    //return;    
}

exec function DrawBone(name BoneName, optional bool bWeaponBone)
{
    CurrentDebugBone = BoneName;
    bDebugWeaponBone = bWeaponBone;
    bDebugDrawBone = !bDebugDrawBone;
    //return;    
}

simulated function RefreshBone()
{
    local Vector vBoneLocation, vX, vY, vZ;

    // End:0x43
    if(!bDebugWeaponBone)
    {
        vBoneLocation = GetBoneLocation(CurrentDebugBone);
        GetAxes(GetBoneRotation(CurrentDebugBone), vX, vY, vZ);        
    }
    else
    {
        // End:0xC7
        if((Weapon != none) && Weapon.Mesh != none)
        {
            vBoneLocation = MOHASkeletalMeshComponent(Weapon.Mesh).GetBoneLocation(CurrentDebugBone);
            GetAxes(QuatToRotator(MOHASkeletalMeshComponent(Weapon.Mesh).GetBoneQuaternion(CurrentDebugBone)), vX, vY, vZ);
        }
    }
    DrawDebugLine(vBoneLocation - (vX * 10.0000000), vBoneLocation + (vX * 10.0000000), byte(255), 0, 0, false);
    DrawDebugLine(vBoneLocation - (vY * 10.0000000), vBoneLocation + (vY * 10.0000000), 0, byte(255), 0, false);
    DrawDebugLine(vBoneLocation - (vZ * 10.0000000), vBoneLocation + (vZ * 10.0000000), 0, 0, byte(255), false);
    //return;    
}

simulated function Vector GetBoneLocation(name BoneName)
{
    return ((Mesh != none) ? Mesh.super(MOHAPawn).GetBoneLocation(BoneName) : vect(0.0000000, 0.0000000, 0.0000000));
    //return ReturnValue;    
}

simulated function Rotator GetBoneRotation(name BoneName)
{
    return ((Mesh != none) ? QuatToRotator(Mesh.GetBoneQuaternion(BoneName)) : rot(0, 0, 0));
    //return ReturnValue;    
}

simulated event StartUsingMountedGun(MOHAMountedGun MG)
{
    //return;    
}

simulated event StopUsingMountedGun(MOHAMountedGun MG)
{
    //return;    
}

simulated function PreBeginPlay()
{
    super.PreBeginPlay();
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x96
    if(Controller != none)
    {
        FootstepEmitter = __NFUN_278__(Class'MOHAExplodeEmitter', self);
        FootstepEmitter.bDestroyOnSystemFinish = false;
        FootstepEmitter.ParticleSystemComponent.DeactivateSystem();
        FootstepEmitter.LifeSpan = 0.0000000;
        ImpactSoundComponents.Length = MaxImpactSoundCount;
        // End:0x96
        if(MOHAPlayerController(Controller) != none)
        {
            MOHAPlayerController(Controller).ServerActiveWeaponPostBegin();
        }
    }
    //return;    
}

simulated function SwitchWeapon(byte NewGroup)
{
    // End:0x09
    if(bVerboseLogging)
    {
    }
    InvManager.NextWeapon();
    //return;    
}

simulated function PlayDying(class<DamageType> DamageType, Vector HitLoc)
{
    super.PlayDying(DamageType, HitLoc);
    SetTimer(LifeSpan, false, 'SetUnSpectatable');
    //return;    
}

function PlayTakeHit(Vector HitLoc, int Damage, class<DamageType> DamageType)
{
    //return;    
}

simulated function CleanUpAudioComponents()
{
    local int I;
    local editinline AudioComponent AudioComp;

    I = 0;
    J0x07:

    // End:0x6F [Loop If]
    if(I < ImpactSoundComponents.Length)
    {
        AudioComp = ImpactSoundComponents[I];
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
    ImpactSoundComponents.Length = 0;
    //return;    
}

simulated event Destroyed()
{
    // End:0x1E
    if(CurrentWeaponAttachment != none)
    {
        CurrentWeaponAttachment.Destroy();
        CurrentWeaponAttachment = none;
    }
    // End:0x4E
    if(FootstepEmitter != none)
    {
        FootstepEmitter.bDestroyOnSystemFinish = true;
        FootstepEmitter.LifeSpan = 0.1000000;
    }
    CleanUpAudioComponents();
    super.Destroyed();
    //return;    
}

event StreamOutCleanup()
{
    CleanUpAudioComponents();
    super(Actor).StreamOutCleanup();
    //return;    
}

function AdjustDamage(out int inDamage, out Vector Momentum, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo)
{
    local class<MOHADamageType> MOHADamageType;

    MOHADamageType = class<MOHADamageType>(DamageType);
    // End:0x24
    if(bDummyFiring == true)
    {
        inDamage = 0;
    }
    // End:0x61
    if(MOHADamageType != none)
    {
        MOHADamageType.static.AdjustDamage(self, inDamage, Momentum, InstigatedBy, HitLocation, DamageType, HitInfo);
    }
    //return;    
}

function AdjustDamageForHitBone(out int inDamage, TraceHitInfo HitInfo, out MOHAPawn.EHitLocation LastHitLocation)
{
    local int I;
    local name BonePos;

    BonePos = HitInfo.BoneName;
    J0x15:

    // End:0xE0 [Loop If]
    if(BonePos != 'None')
    {
        // End:0x31
        if(DebugBoneDamage)
        {
        }
        I = 0;
        J0x38:

        // End:0xC3 [Loop If]
        if(I < BoneDamageTuning.Length)
        {
            // End:0xB9
            if(BonePos == BoneDamageTuning[I].BoneName)
            {
                // End:0x70
                if(DebugBoneDamage)
                {
                }
                inDamage *= BoneDamageTuning[I].DamageModifier;
                LastHitLocation = BoneDamageTuning[I].DamageLocation;
                BonePos = 'None';
                // [Explicit Break]
                goto J0xC3;
            }
            I++;
            // [Loop Continue]
            goto J0x38;
        }
        J0xC3:

        BonePos = Mesh.GetParentBone(BonePos);
        // [Loop Continue]
        goto J0x15;
    }
    //return;    
}

function TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local editinline MOHARagdollSkelComponent RagdollSkelComponent;

    LastHitRigdBodyId = -1;
    RagdollSkelComponent = MOHARagdollSkelComponent(Mesh);
    // End:0x65
    if(RagdollSkelComponent != none)
    {
        LastHitRigdBodyId = RagdollSkelComponent.GetRigidBodyID(HitInfo.BoneName);
        LastHitRigdBodyBoneName = HitInfo.BoneName;
    }
    LastHitDirection = Momentum;
    LastHitDamageType = DamageType;
    numHits = Clamp(numHits + 1, 0, 2);
    super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    //return;    
}

simulated function bool ShouldUseHitReactions(class<DamageType> DamageType)
{
    return false == ClassIsChildOf(DamageType, Class'MOHAExplosiveDamageType');
    //return ReturnValue;    
}

simulated function PreDamage_ImpartHitMomentum(Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Controller InstigatedBy)
{
    ImpartHitMomentum(HitLocation, Momentum, DamageType, HitInfo, 0, InstigatedBy);
    //return;    
}

simulated function PostDamage_ImpartHitMomentum(Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional int AdjustedDamage, optional Controller InstigatedBy)
{
    ImpartHitMomentum(HitLocation, Momentum, DamageType, HitInfo, AdjustedDamage, InstigatedBy);
    //return;    
}

simulated function ImpartHitMomentum(Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional int AdjustedDamage, optional Controller InstigatedBy)
{
    local Rotator ThrowRotation;
    local float MagnitudeModifier;
    local class<MOHADamageType> mohaDamType;
    local bool bKillingBlow;
    local float finalMagnitudeScalar;

    bKillingBlow = false;
    // End:0x196
    if(ShouldUseHitReactions(DamageType))
    {
        // End:0xEC
        if((AdjustedDamage > 0) && AdjustedDamage >= Health)
        {
            bKillingBlow = true;
            mohaDamType = class<MOHADamageType>(DamageType);
            MagnitudeModifier = 1.0000000;
            // End:0xEC
            if((mohaDamType != none) && mohaDamType.static.HasCustomKillingBlowMomentumMultiplier(self, InstigatedBy, Momentum, MagnitudeModifier))
            {
                OnThrownRagdoll();
                RagdollThrowActivated = true;
                Momentum = Momentum * MagnitudeModifier;
                ThrowRotation = Rotator(Momentum);
                ThrowRotation.Pitch += RagdollThrowPitch;
                Momentum = VSize(Momentum) * Vector(ThrowRotation);
            }
        }
        // End:0x196
        if(((AdjustedDamage > 0) || InstigatedBy == none) || InstigatedBy.bIsPlayer)
        {
            Momentum *= GeneralHitMomentumScalar;
            // End:0x196
            if(MOHARagdollSkelComponent(Mesh) != none)
            {
                finalMagnitudeScalar = ApplyHitReactionScalar(InstigatedBy, bKillingBlow);
                // End:0x196
                if(finalMagnitudeScalar > 0.0000000)
                {
                    Momentum *= finalMagnitudeScalar;
                    MOHARagdollSkelComponent(Mesh).AddRagdollImpulse(HitLocation, Momentum, DamageType, HitInfo);
                }
            }
        }
    }
    //return;    
}

simulated function float ApplyHitReactionScalar(Controller InstigatedBy, bool bKillingBlow)
{
    return 1.0000000;
    //return ReturnValue;    
}

simulated function OnThrownRagdoll()
{
    //return;    
}

simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    local Vector HitLocation, HitNormal, CamDir;
    local Rotator facingRot;
    local Vector FacingDir, camOrigin;

    // End:0x198
    if(CamController != none)
    {
        camOrigin = Location;
        camOrigin.Z = (Location.Z + Mesh.SkeletalMesh.Origin.Z) + CamController.CamUpOffset;
        facingRot = Rotation;
        facingRot.Pitch = 0;
        facingRot.Roll = 0;
        FacingDir = Vector(facingRot);
        camOrigin += (FacingDir * CamController.CamForwardOffset);
        out_CamRot.Yaw = Rotation.Yaw + CamController.Rotation.Yaw;
        out_CamRot.Pitch = CamController.Rotation.Pitch;
        CamDir = Vector(out_CamRot);
        out_CamLoc = camOrigin - (CamDir * CamController.CamDistance);
        // End:0x186
        if(Trace(HitLocation, HitNormal, out_CamLoc, camOrigin, false, vect(12.0000000, 12.0000000, 12.0000000)) != none)
        {
            out_CamLoc = HitLocation;
        }
        Mesh.SetOwnerNoSee(false);
        return true;
    }
    Mesh.SetOwnerNoSee(Mesh.default.bOwnerNoSee);
    return false;
    //return ReturnValue;    
}

simulated function WeaponFired(bool bViaReplication, optional Vector HitLocation)
{
    super.WeaponFired(bViaReplication, HitLocation);
    // End:0x40
    if((CurrentWeaponAttachment != none) && bViaReplication)
    {
        CurrentWeaponAttachment.PlayRemoteEffects(HitLocation);
    }
    //return;    
}

function bool GetLocalPlayer(out MOHAPlayerPawn LocalPlayer)
{
    local MOHAPlayerController P;

    // End:0x46
    foreach DynamicActors(Class'MOHAPlayerController', P)
    {
        // End:0x45
        if(NetConnection(P.Player) == none)
        {
            LocalPlayer = MOHAPlayerPawn(P.Pawn);            
            return true;
        }        
    }    
    return false;
    //return ReturnValue;    
}

simulated function WeaponAttachmentChanged()
{
    // End:0x32
    if((EALAWeapon(Weapon) == none) || EALAWeapon(Weapon).ProcessWeaponAttachmentChanged() == false)
    {
        return;
    }
    // End:0x3B
    if(bVerboseLogging)
    {
    }
    // End:0xFD
    if((CurrentWeaponAttachment == none) || CurrentWeaponAttachment.Class != CurrentWeaponAttachmentClass)
    {
        // End:0xA5
        if(CurrentWeaponAttachment != none)
        {
            CurrentWeaponAttachment.DetachFrom(Mesh);
            // End:0xA5
            if(CurrentWeaponAttachment.DestroyWhenDetatched())
            {
                CurrentWeaponAttachment.Destroy();
            }
        }
        // End:0xD7
        if(CurrentWeaponAttachmentClass != none)
        {
            CurrentWeaponAttachment = __NFUN_278__(CurrentWeaponAttachmentClass, self);
            CurrentWeaponAttachment.Instigator = self;            
        }
        else
        {
            CurrentWeaponAttachment = none;
        }
        // End:0xFD
        if(CurrentWeaponAttachment != none)
        {
            CurrentWeaponAttachment.AttachTo(self);
        }
    }
    // End:0x150
    if((CurrentWeaponAttachment != none) && CurrentWeaponAttachment.IsA('SmallArmsAttachment'))
    {
        SmallArmsAttachment(CurrentWeaponAttachment).bUseShellProjectiles = SmallArmsAttachment(CurrentWeaponAttachment).bUseShellProjectiles && false;
    }
    // End:0x194
    if((none != Weapon) && CurrentWeaponAttachment != none)
    {
        EALAWeapon(Weapon).AttachmentChanged(CurrentWeaponAttachment);
        AttachNewWeaponMesh(Weapon);
    }
    //return;    
}

simulated function AttachNewWeaponMesh(Weapon NewWeapon)
{
    //return;    
}

event bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    // End:0x1F
    if(CurrentWeaponAttachment != none)
    {
        CurrentWeaponAttachment.StopFiring(true);
    }
    AxonObserver.NotifyObservers('Died');
    // End:0x6A
    if(class<MOHADamageType>(DamageType) != none)
    {
        class<MOHADamageType>(DamageType).static.OnKilledPawn(self, Killer, HitLocation);
    }
    return super.Died(Killer, DamageType, HitLocation);
    //return ReturnValue;    
}

event bool AnimNotifyHurtRadius(Vector HurtOrigin, float DamageAmount, float DamageRadius, float DamageMomentum, class<DamageType> DamageType, bool bDrawDebugSphere)
{
    // End:0x24
    if(bDrawDebugSphere)
    {
        DrawDebugSphere(HurtOrigin, DamageRadius, 16, 0, 0, byte(255), true);
    }
    return HurtRadius(DamageAmount, DamageRadius, DamageType, DamageMomentum, HurtOrigin);
    //return ReturnValue;    
}

event bool AnimNotifyHurtMelee(Vector HurtOrigin)
{
    local ImpactInfo MeleeImpactInfo;
    local bool bMeleeHit;
    local float NPCToNPCDamage, MagnitudeScalar, MaxMagnitudeScalar, TargetSpeed, TargetMaxSpeed;

    local int MagnitudeYaw;
    local Rotator MagnitudeRot;
    local Vector MagnitudeVec;
    local MOHAAIPawn MeleeTarget;

    // End:0x0D
    if(Health <= 0)
    {
        return false;
    }
    bMeleeHit = false;
    MOHAAIPawn(self).PerformMelee(MeleeImpactInfo);
    bMeleeHit = MeleeImpactInfo.HitActor != none;
    // End:0x2DF
    if(bMeleeHit)
    {
        MeleeTarget = MOHAAIPawn(MeleeImpactInfo.HitActor);
        // End:0x246
        if(MeleeTarget != none)
        {
            NPCToNPCDamage = float(MeleeTarget.AdjustCloseRangeDamageFor(Controller, 100, MeleeTarget.default.Health));
            MaxMagnitudeScalar = 5000.0000000;
            MagnitudeScalar = MaxMagnitudeScalar;
            TargetSpeed = VSize(MeleeImpactInfo.HitActor.Velocity);
            TargetMaxSpeed = MeleeTarget.KynapseControllerClass.default.fSprintSpeed;
            MagnitudeScalar = MagnitudeScalar * ((TargetMaxSpeed - TargetSpeed) / TargetMaxSpeed);
            MagnitudeScalar = FClamp(MagnitudeScalar, 0.0000000, MaxMagnitudeScalar);
            // End:0x174
            if(Rand(2) == 0)
            {
                MagnitudeYaw = int(Lerp(16384.0000000, 0.0000000, MagnitudeScalar / MaxMagnitudeScalar));
                // End:0x171
                if(Rand(2) == 0)
                {
                    MagnitudeYaw *= float(-1);
                }                
            }
            else
            {
                MagnitudeYaw = 0;
                // End:0x196
                if(MagnitudeScalar == 0.0000000)
                {
                    MaxMagnitudeScalar *= 1.5000000;
                }
            }
            MagnitudeVec = MeleeImpactInfo.RayDir;
            MagnitudeRot = Rotator(MagnitudeVec);
            MagnitudeRot.Yaw += MagnitudeYaw;
            MagnitudeVec = Vector(MagnitudeRot);
            PlaySound(MeleeImpactNPC);
            MeleeImpactInfo.HitActor.TakeDamage(int(NPCToNPCDamage), Controller, MeleeImpactInfo.HitLocation, MaxMagnitudeScalar * MagnitudeVec, Class'MOHAMeleeDamageType', MeleeImpactInfo.HitInfo);            
        }
        else
        {
            PlaySound(MeleeImpactPC);
            MeleeImpactInfo.HitActor.TakeDamage(int(EALAWeapon(Controller.Pawn.Weapon).GetMeleeDamage()), Controller, MeleeImpactInfo.HitLocation, float(1000) * MeleeImpactInfo.RayDir, Class'MOHAMeleeDamageType', MeleeImpactInfo.HitInfo);
        }
    }
    return bMeleeHit;
    //return ReturnValue;    
}

function MeleeFinished()
{
    // End:0x36
    if(KynapseAIController(Controller) != none)
    {
        KynapseAIController(Controller).ABSS.TripNamedScriptEvent('MeleeStrike');
    }
    //return;    
}

simulated function UpdateUpgradeStatus(int iWeaponClass, int iUpgradeLevel)
{
    m_iWeaponUpgradeStatus = m_iWeaponUpgradeStatus & ~3 << (iWeaponClass * 2);
    m_iWeaponUpgradeStatus = m_iWeaponUpgradeStatus | (iUpgradeLevel << (iWeaponClass * 2));
    //return;    
}

simulated function SetWeaponClass(class<WeaponAttachment> AttachmentClass)
{
    CurrentWeaponAttachmentClass = AttachmentClass;
    //return;    
}

simulated function int GetUpgradeStatus(int WeaponClass)
{
    return ((m_iWeaponUpgradeStatus >> (WeaponClass * 2)) & 3) - 1;
    //return ReturnValue;    
}

function ReturnToSpawner()
{
    //return;    
}

function bool KillMeImHere()
{
    //return ReturnValue;    
}

event bool HasHelmet()
{
    return false;
    //return ReturnValue;    
}

function bool ShouldFireWeaponAttachment()
{
    return true;
    //return ReturnValue;    
}

function SetDummyFiring(bool newVal)
{
    bDummyFiring = newVal;
    //return;    
}

function OnDummyFire(SeqAct_DummyFire Action)
{
    local float fBurstTime;

    SetDummyFiring(true);
    BotFire(false);
    // End:0x3E
    if(Action.targetActor != none)
    {
        dummyFireTarget = Action.targetActor;
    }
    fBurstTime = Action.burstTime;
    // End:0xD8
    if(fBurstTime <= 0.0000000)
    {
        // End:0xBE
        if(EALASmallArms(Weapon) != none)
        {
            fBurstTime = ((EALASmallArms(Weapon).RefireCheckTime != 0.0000000) ? EALASmallArms(Weapon).RefireCheckTime : EALASmallArms(Weapon).FireInterval[0]);
        }
        // End:0xD8
        if(fBurstTime <= 0.0000000)
        {
            fBurstTime = 0.1000000;
        }
    }
    SetTimer(fBurstTime, false, 'DummyFireStop');
    //return;    
}

function DummyFireStop()
{
    BotFire(true);
    SetDummyFiring(false);
    //return;    
}

defaultproperties
{
    MaxTouchingWindVolumes=4
    fPlayerPushInterval=1.5000000
    nMaxPushes=2
    PawnSide=1
    FootstepHeight=165.0000000
    MaxImpactSoundCount=10
    WeaponSocket="Weapon"
    // Reference: AxonScriptEventObserverComponent'Default__MOHAPawn.AxonObserver0'
    begin object name=AxonObserver0 class=Class'EAKynapse.AxonScriptEventObserverComponent'
    end object
    AxonObserver=AxonObserver0
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAPawn.MyLightEnvironment'
    begin object name=MyLightEnvironment class=Class'Engine.DynamicLightEnvironmentComponent'
    end object
    LightEnvComponent=MyLightEnvironment
    MaxFootstepEffectDistance=5000.0000000
    FootGroundPos_StepDownMax=-150.0000000
    fCrouchFootstepSoundRadius=100.0000000
    fNormalFootstepSoundRadius=500.0000000
    fSprintFootstepSoundRadius=1500.0000000
    fLandFootstepSoundRadius=1500.0000000
    fNoiseRadiusDecayPerSecond=1000.0000000
    RagdollThrowWeaponImpulseMultiplier=10.0000000
    RagdollThrowCheckDistance=150.0000000
    RagdollThrowPitch=5461
    GeneralHitMomentumScalar=1.0000000
    MeleeImpactNPC=SoundCue'Aud_GCm_FakeWAV.Clothing_And_Gear.Mvmt_MeleeImpact_NPC_Default'
    MeleeImpactPC=SoundCue'Aud_GCm_FakeWAV.Clothing_And_Gear.Mvmt_MeleeImpact_PC_Hit'
    ParachuteClass=Class'MOHAParachuteActor'
    MaxFallSpeed=1600.0000000
    // Reference: CylinderComponent'Default__MOHAPawn.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__MOHAPawn.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    // Reference: ArrowComponent'Default__MOHAPawn.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=MyLightEnvironment
    Components[4]=AxonObserver0
    CollisionComponent=CollisionCylinder
}