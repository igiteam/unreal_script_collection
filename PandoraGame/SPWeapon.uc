class SPWeapon extends GameWeapon
    abstract
    native
    config(Game);

struct native SPWeaponLockOn
{
    /** `define ADSLOG(t) Delay to wait after weapon has become equiped before requesting ADS info *********************************************************************** MACROS *********************************************************************** *********************************************************************** STRUCT DECLARATIONS *********************************************************************** Current Status */
    var() bool m_requested;
    /** `define ADSLOG(t) Delay to wait after weapon has become equiped before requesting ADS info *********************************************************************** MACROS *********************************************************************** *********************************************************************** STRUCT DECLARATIONS *********************************************************************** Current Status */
    var() Actor m_target;
    /** `define ADSLOG(t) Delay to wait after weapon has become equiped before requesting ADS info *********************************************************************** MACROS *********************************************************************** *********************************************************************** STRUCT DECLARATIONS *********************************************************************** Current Status */
    var() bool m_bLocked;
    /** `define ADSLOG(t) Delay to wait after weapon has become equiped before requesting ADS info *********************************************************************** MACROS *********************************************************************** *********************************************************************** STRUCT DECLARATIONS *********************************************************************** Current Status */
    var() float m_timeFirstPainted;
    /** `define ADSLOG(t) Delay to wait after weapon has become equiped before requesting ADS info *********************************************************************** MACROS *********************************************************************** *********************************************************************** STRUCT DECLARATIONS *********************************************************************** Current Status */
    var() float m_timeLastPainted;
    /** `define ADSLOG(t) Delay to wait after weapon has become equiped before requesting ADS info *********************************************************************** MACROS *********************************************************************** *********************************************************************** STRUCT DECLARATIONS *********************************************************************** Current Status */
    var() bool m_isAllowedToLock;
    /** `define ADSLOG(t) Delay to wait after weapon has become equiped before requesting ADS info *********************************************************************** MACROS *********************************************************************** *********************************************************************** STRUCT DECLARATIONS *********************************************************************** Current Status */
    var() float m_nextCanPaintTime;
    /** `define ADSLOG(t) Delay to wait after weapon has become equiped before requesting ADS info *********************************************************************** MACROS *********************************************************************** *********************************************************************** STRUCT DECLARATIONS *********************************************************************** Current Status */
    var() bool m_prevRequestedState;
    /** `define ADSLOG(t) Delay to wait after weapon has become equiped before requesting ADS info *********************************************************************** MACROS *********************************************************************** *********************************************************************** STRUCT DECLARATIONS *********************************************************************** Current Status */
    var() Actor m_prevTarget;
    /** `define ADSLOG(t) Delay to wait after weapon has become equiped before requesting ADS info *********************************************************************** MACROS *********************************************************************** *********************************************************************** STRUCT DECLARATIONS *********************************************************************** Current Status */
    var() bool m_prevLockedState;
    /** `define ADSLOG(t) Delay to wait after weapon has become equiped before requesting ADS info *********************************************************************** MACROS *********************************************************************** *********************************************************************** STRUCT DECLARATIONS *********************************************************************** Current Status */
    var() bool m_bChangedRequested;
    /** `define ADSLOG(t) Delay to wait after weapon has become equiped before requesting ADS info *********************************************************************** MACROS *********************************************************************** *********************************************************************** STRUCT DECLARATIONS *********************************************************************** Current Status */
    var() bool m_bChangedTarget;
    /** `define ADSLOG(t) Delay to wait after weapon has become equiped before requesting ADS info *********************************************************************** MACROS *********************************************************************** *********************************************************************** STRUCT DECLARATIONS *********************************************************************** Current Status */
    var() bool m_bChangedLock;
    /** `define ADSLOG(t) Delay to wait after weapon has become equiped before requesting ADS info *********************************************************************** MACROS *********************************************************************** *********************************************************************** STRUCT DECLARATIONS *********************************************************************** Current Status// Setup vars */
    var() float m_timeRequiredToLock;
    /** `define ADSLOG(t) Delay to wait after weapon has become equiped before requesting ADS info *********************************************************************** MACROS *********************************************************************** *********************************************************************** STRUCT DECLARATIONS *********************************************************************** Current Status// Setup vars */
    var() float m_timeTargetCanBeLostWithoutLoosingLock;
    /** `define ADSLOG(t) Delay to wait after weapon has become equiped before requesting ADS info *********************************************************************** MACROS *********************************************************************** *********************************************************************** STRUCT DECLARATIONS *********************************************************************** Current Status// Setup vars */
    var() float m_targetRadiusMultiplier;
    /** `define ADSLOG(t) Delay to wait after weapon has become equiped before requesting ADS info *********************************************************************** MACROS *********************************************************************** *********************************************************************** STRUCT DECLARATIONS *********************************************************************** Current Status// Setup vars */
    var() Actor m_owner;
    /** `define ADSLOG(t) Delay to wait after weapon has become equiped before requesting ADS info *********************************************************************** MACROS *********************************************************************** *********************************************************************** STRUCT DECLARATIONS *********************************************************************** Current Status// Setup vars */
    var() float m_range;

    structdefaultproperties
    {
        m_requested=false
        m_target=none
        m_bLocked=false
        m_timeFirstPainted=-1.0000000
        m_timeLastPainted=-1.0000000
        m_isAllowedToLock=true
        m_nextCanPaintTime=-1.0000000
        m_prevRequestedState=false
        m_prevTarget=none
        m_prevLockedState=false
        m_bChangedRequested=false
        m_bChangedTarget=false
        m_bChangedLock=false
        m_timeRequiredToLock=2.0000000
        m_timeTargetCanBeLostWithoutLoosingLock=1.0000000
        m_targetRadiusMultiplier=1.0000000
        m_owner=none
        m_range=15000.0000000
    }
};

struct native transient WeaponTraceCache
{
    var init float Time;
    var init Vector StartLoc;
    var init Vector EndLoc;
    var init ImpactInfo Impact;

    structdefaultproperties
    {
        Time=0.0000000
        StartLoc=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        EndLoc=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Impact=(HitActor=none,HitLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000),HitNormal=(X=0.0000000,Y=0.0000000,Z=0.0000000),RayDir=(X=0.0000000,Y=0.0000000,Z=0.0000000),HitInfo=(Material=none,PhysMaterial=none,Item=0,LevelIndex=0,BoneName="None",HitComponent=none))
    }
};

var bool IsLargeWeapon;
var bool IsMeleeWeapon;
var bool bForceReload;
var bool bDryFire;
var bool CanSuppress;
var bool bSemiAuto;
var bool m_bUsingUnlimitedAmmo;
var bool m_bIgnoreCollisions;
var bool bReloadInterrupted;
var bool bWeaponHasBeenFired;
var bool bIsNPCWeapon;
var bool m_bCanWeaponLookDownSite;
var bool bRequestReload;
var bool bInterruptRequested;
var bool m_bMuzzleSmokeEnabled;
var bool m_bUseMuzzleSmoke;
var bool m_bExplosionEnabled;
var bool m_bDisableMuzzleFlash;
var bool m_bDisableMuzzleSmoke;
var bool m_bUsingScope;
var bool bHudless;
var() databinding bool bAvailable;
var() databinding bool bPlayPickupSound;
var() databinding bool bBindDataStore;
var bool m_bPickupMessageAmmo;
var bool m_bFireAxeHit;
var bool m_bCanFire;
var bool m_bCollisionCheckEnabled;
var bool m_bIsPitchTurning;
var bool m_bIsViewTurning;
var bool m_bIsViewTransitioning;
var bool m_bIsPitchTransitioning;
var bool m_ForceFeedBackActive;
var bool m_bMarkedForDeath;
var transient bool IsProjectileFirePositionCached;
var bool m_bRocketsHomingForGenerators;
var bool m_bCanAutoSwapDueToNoAmmo;
var bool m_bAmBxScopedWeapon;
var bool m_bAmBxAllowedToFire;
var float DampValue;
var ThirdPersonWeaponSounds m_ThirdPersonWeaponSounds;
var int BulletsPerReloadCycle;
var int NumberOfReloadCycles;
var int AmmoCount;
var int MaxAmmoCount;
var int magazineSize;
var int ammoInMagazine;
var ParticleSystem MuzzleFlash;
var ParticleSystem MuzzleSmokeParticleSystem;
var SPEmitter MuzzleSmokeEmitter;
var ParticleSystem BarrelSmokeParticleSystem;
var export editinline PointLightComponent MuzzleLight;
var export editinline SpotLightComponent FlashLight;
var export editinline StaticMeshComponent ShellMesh;
var protected ParticleSystem MuzzleFlashParticleSystem;
var protected ParticleSystem ThirdPersonMuzzleFlashParticleSystem;
var private SPEmitter MuzzleFlashEmitter;
var SoundCue Sound_FireStart;
var SoundCue Sound_Fire;
var SoundCue Sound_FireEnd;
var SoundCue Sound_WeaponEmpty;
var export editinline AudioComponent Sound_Looping;
var const name WeaponIdleAnim;
var const name WeaponFireAnim;
var const name WeaponReloadAnim;
var const name WeaponCycleAnim;
var const name WeaponReloadFinishAnim;
var const name WeaponEquipAnim;
var const name WeaponUnequipAnim;
var const name PawnEquipAnim;
var const name PawnUnequipAnim;
var name WeapID;
var int ReloadCount;
var float LookDownFireInterval;
var float OldFireInterval;
var float LookDownSpreadValue;
var float OldSpreadValue;
var float m_SpeedScaler;
var float m_DamageValue;
var int m_ScopeFireBurst;
var const name AimNodeProfileName;
var(FOV) private float HeldByPlayerFOV;
var(FOV) private float LookDownSiteFOV;
var(FOV) private float NotHeldByPlayerFOV;
var(FOV) private float DestFOV;
var(FOV) private float CurrFOV;
var(FOV) private float FOVChangeRate;
var(FOV) private float WorldLookDownSiteFOV;
var(FOV) private float WorldDestFOV;
var(FOV) float WorldCurrFOV;
var(FOV) private float WorldFOVChangeRate;
var(FOV) private float PlayerSprintFOV;
var(FOV) private float WorldPlayerSprintFOV;
var() RecoilGroupData RecoilInfo;
var() SpreadGroupData SpreadInfo;
var() float LookDownSiteTransTime;
var() float SprintFOVTransTime;
var transient float LastShotTime;
var class<SPShellCasingPersistent> ShellCasingClass;
var ScreenShakeStruct shakeInfo;
var SPPhysicalMaterial DefaultMaterial;
var class<DamageType> MyDamageType;
var class<SPWeapon> NPCSPWeaponType;
var float Damage;
var() const editconst export editinline LightEnvironmentComponent LightEnvironment;
/** Weapon's infomation for PDA to display */
var() databinding Surface WeaponImage;
var() databinding int pickupTime;
var float showPickupMsgTime;
var float maxShowPickupMsgTime;
var string m_PickupMessageForAmmo;
var class<SPGrenadePersistent> BulletGrenadePersistentClass;
/** The class of the attachment to spawn */
var(Replication) class<SPWeaponAttachment> AttachmentClass;
var float m_SlomoSpeed;
var float m_SlomoDuration;
var float m_SlomoStartDelay;
var float m_ADSCameraRotationRate;
var float m_ADSCameraRotationRateDampened;
var float m_ADSCameraRotationRateUp;
var float m_ADSCameraRotationRateDampenedUp;
var float ADSFireInterval;
var const SPEquippedWeaponNode.SPWeaponType WeaponType;
var const array<AnimSet> FirstPersonPawnAnimSets;
var const array<AnimSet> ThirdPersonPawnAnimSets;
var class<Projectile> BulletProjectileClass;
var name MuzzleSocket;
var name AttachBoneName;
var name BarrelSmokeSocket;
var SPWeaponGamePadParams m_gamePad;
var Vector SavedTossVel;
var transient WeaponTraceCache m_TraceCache;
var transient Vector CachedProjectileFirePositionLoc;
var transient Vector CachedProjectileFirePositionDir;
var string PDAMessageUIScene;
var Material m_WeaponDOFMaterialEffect;
var config string DefaultAmBxEffectName;

replication
{
    // Pos:0x000
    if(true
        AmmoCount, ammoInMagazine;
}

// Export USPWeapon::execkmskdebug(FFrame&, void* const)
native static function kmskdebug();

// Export USPWeapon::execGetVectorWorldSpace(FFrame&, void* const)
native static function GetVectorWorldSpace(Actor inActor, Vector InVector, out Vector OutVector);

// Export USPWeapon::execRequestLock(FFrame&, void* const)
native static function RequestLock(out SPWeaponLockOn lock, bool request);

// Export USPWeapon::execAttemptLock(FFrame&, void* const)
native static function AttemptLock(Vector traceLineStart, Vector traceLineDir, out SPWeaponLockOn lock, float TimeSeconds);

// Export USPWeapon::execReleaseLock(FFrame&, void* const)
native static function ReleaseLock(out SPWeaponLockOn lock, float TimeSeconds);

// Export USPWeapon::execUpdateStateChanges(FFrame&, void* const)
native static function UpdateStateChanges(out SPWeaponLockOn lock);

// Export USPWeapon::execStaticGetMuzzleLocFromOffset(FFrame&, void* const)
native static simulated function bool StaticGetMuzzleLocFromOffset(MeshComponent theMesh, Vector localOffset, out Vector Loc, optional out Rotator Rot);

// Export USPWeapon::execGetMuzzleLocAndRotFromFireOffset(FFrame&, void* const)
native simulated function bool GetMuzzleLocAndRotFromFireOffset(out Vector Loc, out Rotator Rot);

// Export USPWeapon::execGetMuzzleLocFromFireOffset(FFrame&, void* const)
native simulated function Vector GetMuzzleLocFromFireOffset();

// Export USPWeapon::execHandleImpactSound(FFrame&, void* const)
native static function HandleImpactSound(SPPhysicalMaterial PhysMat, class<DamageType> theDamageType, Actor dummyActor, Vector soundPos);

// Export USPWeapon::execHandleReflectedImpactSound(FFrame&, void* const)
native static function HandleReflectedImpactSound(SPPhysicalMaterial PhysMat, class<DamageType> theDamageType, Actor dummyActor, Vector soundPos);

// Export USPWeapon::execHandleReflectedImpactDecal(FFrame&, void* const)
native static function HandleReflectedImpactDecal(SPPhysicalMaterial PhysMat, class<DamageType> theDamageType, ImpactInfo Impact, optional ImpactDecalInfo DefaultDecal);

// Export USPWeapon::execHandleImpactDecal(FFrame&, void* const)
native static function HandleImpactDecal(SPPhysicalMaterial PhysMat, class<DamageType> theDamageType, ImpactInfo Impact, optional ImpactDecalInfo DefaultDecal);

// Export USPWeapon::execHandleImpactLight(FFrame&, void* const)
native static function Light HandleImpactLight(SPPhysicalMaterial PhysMat, class<DamageType> theDamageType, ImpactInfo Impact);

// Export USPWeapon::execHandleReflectedImpactParticles(FFrame&, void* const)
native static function HandleReflectedImpactParticles(SPPhysicalMaterial PhysMat, class<DamageType> theDamageType, ImpactInfo Impact, optional ImpactParticlesInfo DefaultParticles);

// Export USPWeapon::execHandleImpactParticles(FFrame&, void* const)
native static function HandleImpactParticles(SPPhysicalMaterial PhysMat, class<DamageType> theDamageType, ImpactInfo Impact, optional ImpactParticlesInfo DefaultParticles);

// Export USPWeapon::execHandleHurtRadius(FFrame&, void* const)
native static function HandleHurtRadius(SPPhysicalMaterial PhysMat, class<DamageType> theDamageType, ImpactInfo Impact);

// Export USPWeapon::execLinePlaneIntersection(FFrame&, void* const)
native static function bool LinePlaneIntersection(Vector point1, Vector point2, Vector PlaneOrigin, Vector PlaneNormal, out Vector Intersection);

// Export USPWeapon::execGetProjectileFirePositionNoSpread(FFrame&, void* const)
native final function GetProjectileFirePositionNoSpread(out Vector out_ProjLoc, out Vector out_ProjDir);

function WeaponIsDown()
{
    //return;    
}

simulated function RefireCheckTimer()
{
    //return;    
}

function WeaponEquipped()
{
    //return;    
}

simulated function CycleAmmo()
{
    //return;    
}

simulated function bool InterruptReload()
{
    //return ReturnValue;    
}

simulated function ForceInterruptReload()
{
    //return;    
}

function ReloadFinished()
{
    //return;    
}

simulated function SPCustomFire(bool bFakeFire)
{
    //return;    
}

// Export USPWeapon::execAreShellCasingsEnabled(FFrame&, void* const)
native function bool AreShellCasingsEnabled();

// Export USPWeapon::execSPProjectileFire(FFrame&, void* const)
native function Projectile SPProjectileFire(bool bUseFakeFire);

// Export USPWeapon::execIsRapidFireMode(FFrame&, void* const)
native function bool IsRapidFireMode(int FireMode);

simulated function EnterADS()
{
    //return;    
}

simulated function ExitADS()
{
    //return;    
}

reliable server function ServerInterruptReloadRequest()
{
    ScriptTrace();
    //return;    
}

reliable server function ServerForceInterruptReload()
{
    ScriptTrace();
    //return;    
}

simulated function bool CanViewAccelerationWhenFiring()
{
    // End:0x1F
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        return false;        
    }
    else
    {
        return true;
    }
    //return ReturnValue;    
}

simulated function PandoraPlayerController GetPandoraPlayerController()
{
    local Pawn PawnOwner;

    PawnOwner = Pawn(Owner);
    return (((PawnOwner != none) && PawnOwner.Controller != none) ? PandoraPlayerController(PawnOwner.Controller) : none);
    //return ReturnValue;    
}

simulated function bool CanFire()
{
    local PandoraPlayerController PPC;

    PPC = GetPandoraPlayerController();
    // End:0x36
    if((PPC != none) && PPC.IsSprinting())
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

simulated function StartFire(byte FireModeNum)
{
    // End:0x18
    if(CanFire())
    {
        super(Weapon).StartFire(FireModeNum);
    }
    //return;    
}

reliable server function ServerStartFire(byte FireModeNum)
{
    // End:0x18
    if(CanFire())
    {
        super(Weapon).ServerStartFire(FireModeNum);
    }
    //return;    
}

simulated function float GetFireInterval(byte FireModeNum)
{
    // End:0x34
    if((IsLookingDownSight()) && !bIsNPCWeapon)
    {
        return ((ADSFireInterval > float(0)) ? ADSFireInterval : 0.0100000);
    }
    return ((FireInterval[int(FireModeNum)] > float(0)) ? FireInterval[int(FireModeNum)] : 0.0100000);
    //return ReturnValue;    
}

function DBG_MsgW(string Str)
{
    local PlayerController PC;

    // End:0x4D
    foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x4C
        if(PC.Pawn != none)
        {
            PC.Pawn.ClientMessage(Str);
        }        
    }    
    //return;    
}

simulated function class<Projectile> GetProjectileClass()
{
    return StaticGetProjectileClass();
    //return ReturnValue;    
}

static simulated function class<Projectile> StaticGetProjectileClass()
{
    return default.BulletProjectileClass;
    //return ReturnValue;    
}

simulated event AnimNotify_FireAmmunition(optional bool bUseFakeFire)
{
    // End:0x2B
    if((Pawn(Owner) != none) && Pawn(Owner).bLogWeaponNet)
    {
    }
    SPFireAmmunition(bUseFakeFire);
    // End:0x76
    if(((SPWeaponRapidFirePersistant(self) == none) && Owner != none) && SPSkeletalMeshActorMAT(Owner) != none)
    {
        PlayFireEffects(CurrentFireMode);
    }
    //return;    
}

simulated event AnimNotify_CycleAmmo()
{
    // End:0x2A
    if((Pawn(Owner) != none) && Pawn(Owner).bLogWeaponNet)
    {
    }
    CycleAmmo();
    //return;    
}

simulated function GetSPWeaponGamePadParams(out SPWeaponGamePadParams Params)
{
    //return;    
}

simulated function GetMPWeaponSpreadParams(out SPWeaponGamePadParams Params)
{
    //return;    
}

function SetPickupMessageForAmmo(string msgString)
{
    bAvailable = true;
    showPickupMsgTime = 0.0000000;
    m_bPickupMessageAmmo = true;
    m_PickupMessageForAmmo = msgString;
    //return;    
}

simulated function bool IsOwnerLocallyControlled()
{
    local Pawn pOwnerPawn;

    pOwnerPawn = Pawn(Owner);
    // End:0x1D
    if(pOwnerPawn == none)
    {
        return false;
    }
    return pOwnerPawn.IsLocallyControlled();
    //return ReturnValue;    
}

simulated function UpdateCurrFOV(float DeltaTime)
{
    CurrFOV += (FOVChangeRate * DeltaTime);
    // End:0x3C
    if((FOVChangeRate > float(0)) && CurrFOV > DestFOV)
    {
        CurrFOV = DestFOV;
    }
    // End:0x65
    if((FOVChangeRate < float(0)) && CurrFOV < DestFOV)
    {
        CurrFOV = DestFOV;
    }
    WorldCurrFOV += (WorldFOVChangeRate * DeltaTime);
    // End:0xA1
    if((WorldFOVChangeRate > float(0)) && WorldCurrFOV > WorldDestFOV)
    {
        WorldCurrFOV = WorldDestFOV;
    }
    // End:0xCA
    if((WorldFOVChangeRate < float(0)) && WorldCurrFOV < WorldDestFOV)
    {
        WorldCurrFOV = WorldDestFOV;
    }
    //return;    
}

simulated function Tick(float DeltaTime)
{
    UpdateCurrFOV(DeltaTime);
    // End:0x2E
    if(IsOwnerLocallyControlled())
    {
        ClientTick(DeltaTime);        
    }
    else
    {
        RemoteTick(DeltaTime);
    }
    IsProjectileFirePositionCached = false;
    super(Actor).Tick(DeltaTime);
    //return;    
}

function RemoteTick(float DeltaTime)
{
    local editinline SPSkeletalMeshComponent myMesh;

    myMesh = SPSkeletalMeshComponent(Mesh);
    // End:0x34
    if(myMesh != none)
    {
        myMesh.SetFOV(0.0000000);
    }
    //return;    
}

simulated function ClientTick(float DeltaTime)
{
    UpdateHUD(DeltaTime);
    UpdateMeshFOV(DeltaTime);
    //return;    
}

simulated function UpdateMeshFOV(float DeltaTime)
{
    local editinline SPSkeletalMeshComponent parentMesh, myMesh;
    local PlayerPawn PlayerOwner;
    local PandoraPlayerController pandoraPlayaController;
    local float overrideFOV, weaponFOV, pawnFOV, CameraFOV;

    PlayerOwner = PlayerPawn(Owner);
    // End:0x34
    if((PlayerOwner == none) || PlayerOwner.Weapon != self)
    {
        return;
    }
    myMesh = SPSkeletalMeshComponent(Mesh);
    parentMesh = SPSkeletalMeshComponent(PlayerOwner.Mesh);
    pandoraPlayaController = PandoraPlayerController(PlayerOwner.Controller);
    // End:0xC7
    if((ShouldOverrideFOV()) && pandoraPlayaController.GetOverrideFOV(overrideFOV))
    {
        CameraFOV = overrideFOV;
        pawnFOV = overrideFOV;
        weaponFOV = overrideFOV;        
    }
    else
    {
        CameraFOV = WorldCurrFOV;
        // End:0x104
        if(!PlayerOwner.IsFirstPerson())
        {
            pawnFOV = WorldCurrFOV;
            weaponFOV = WorldCurrFOV;            
        }
        else
        {
            pawnFOV = CurrFOV;
            weaponFOV = CurrFOV;
        }
    }
    // End:0x13E
    if(parentMesh != none)
    {
        parentMesh.SetFOV(pawnFOV);
    }
    // End:0x15D
    if(myMesh != none)
    {
        SetWeaponFOV(myMesh, weaponFOV);
    }
    SafeSetFOV(CameraFOV);
    //return;    
}

simulated function UpdateHUD(float DeltaTime)
{
    local PlayerPawn PlayerOwner;

    PlayerOwner = PlayerPawn(Owner);
    // End:0x1D
    if(PlayerOwner == none)
    {
        return;
    }
    // End:0x56
    if(bAvailable && showPickupMsgTime < maxShowPickupMsgTime)
    {
        // End:0x56
        if(showPickupMsgTime <= 0.0010000)
        {
            PlaySound(SoundCue'S_Wpn_P9mm.Foley.P9mm_DryFire_Cue');
        }
    }
    showPickupMsgTime += DeltaTime;
    // End:0xA0
    if((showPickupMsgTime >= maxShowPickupMsgTime) && bAvailable)
    {
        PlayerOwner.playerHud.bShowPickupWeaponMessage = false;
        bAvailable = false;
    }
    //return;    
}

simulated function bool ShouldOverrideFOV()
{
    local PlayerPawn PlayerOwner;
    local PandoraPlayerController pandoraPlayaController;

    PlayerOwner = PlayerPawn(Owner);
    // End:0x1D
    if(PlayerOwner != none)
    {
        return false;
    }
    pandoraPlayaController = PandoraPlayerController(PlayerOwner.Controller);
    // End:0x44
    if(pandoraPlayaController != none)
    {
        return false;
    }
    // End:0x72
    if(!pandoraPlayaController.m_bLockWeaponFOVtoWorld)
    {
        // End:0x72
        if(PlayerOwner.IsFirstPerson())
        {
            return false;
        }
    }
    return true;
    //return ReturnValue;    
}

simulated function SafeSetFOV(float newFOV)
{
    local PandoraPlayerCamera thePlayerCamera;
    local TViewTarget TheViewTarget;
    local Actor theCameraActor;

    thePlayerCamera = GetPlayerCamera();
    // End:0x1D
    if(thePlayerCamera == none)
    {
        return;
    }
    TheViewTarget = thePlayerCamera.ViewTarget;
    theCameraActor = TheViewTarget.Target;
    // End:0xB2
    if((theCameraActor == none) || (PlayerPawn(theCameraActor) != none) && (thePlayerCamera != none) && thePlayerCamera.GetCameraStyle() != 'FreeCam')
    {
        thePlayerCamera.SetFOV(newFOV);        
    }
    else
    {
        thePlayerCamera.SetFOV(0.0000000);
    }
    //return;    
}

static function class<SPWeapon> ByClassGetNPCWeaponClass(class<SPWeapon> SPWeaponType)
{
    return SPWeaponType.default.NPCSPWeaponType;
    //return ReturnValue;    
}

static function name GetWeaponName(class<SPWeapon> SPWeaponType)
{
    return SPWeaponType.default.WeapID;
    //return ReturnValue;    
}

function class<SPWeapon> GetNPCWeaponClass()
{
    return NPCSPWeaponType;
    //return ReturnValue;    
}

function class<SPWeapon> GetBaseNonNPCClass()
{
    return none;
    //return ReturnValue;    
}

function AddAmmoFromOtherWeapon(SPWeapon otherWeapon)
{
    // End:0x24
    if(otherWeapon != none)
    {
        AddAmmo(otherWeapon.AmmoCount);
    }
    //return;    
}

function AddAmmoFromPickup(int newAmmoCount)
{
    // End:0x2F
    if(newAmmoCount > magazineSize)
    {
        ammoInMagazine = magazineSize;
        AmmoCount = newAmmoCount - magazineSize;        
    }
    else
    {
        // End:0x4F
        if((magazineSize - newAmmoCount) == 0)
        {
            ammoInMagazine = newAmmoCount;            
        }
        else
        {
            ammoInMagazine = magazineSize - newAmmoCount;
        }
        AmmoCount = 0;
    }
    //return;    
}

function AddAmmoFromDroppedPickup(int newAmmoCount, int magazineCount)
{
    AmmoCount = newAmmoCount;
    ammoInMagazine = magazineCount;
    // End:0x5D
    if(PandoraPlayerController(Pawn(Owner).Controller) != none)
    {
        PandoraPlayerController(Pawn(Owner).Controller).ClientPickupWeapons();
    }
    //return;    
}

function int AddAmmo(int Amount)
{
    // End:0x47
    if(PandoraPlayerController(Pawn(Owner).Controller) != none)
    {
        PandoraPlayerController(Pawn(Owner).Controller).ClientPickupWeapons();
    }
    AmmoCount = Clamp(AmmoCount + Amount, 0, MaxAmmoCount);
    return AmmoCount;
    //return ReturnValue;    
}

function Vector GetParentVelocity()
{
    // End:0x1C
    if(Owner == none)
    {
        return vect(0.0000000, 0.0000000, 0.0000000);        
    }
    else
    {
        return Pawn(Owner).Velocity;
    }
    //return ReturnValue;    
}

function bool NotReadyToFire(byte FireModeNum)
{
    return false;
    //return ReturnValue;    
}

simulated function PlayFiringAnim()
{
    local editinline SkeletalMeshComponent SkelMesh;
    local AnimNodeSequence playingAnim;
    local bool bPlaying;

    // End:0x18
    if(Pawn(Owner).bLogWeaponNet)
    {
    }
    // End:0xDF
    if((GetWeaponFireAnim()) != 'None')
    {
        bPlaying = false;
        SkelMesh = SkeletalMeshComponent(Mesh);
        // End:0xAD
        if(SkelMesh != none)
        {
            playingAnim = AnimNodeSequence(SkelMesh.Animations);
            // End:0xAD
            if(playingAnim != none)
            {
                // End:0xAD
                if(playingAnim.AnimSeqName == (GetWeaponFireAnim()))
                {
                    bPlaying = playingAnim.bPlaying;
                }
            }
        }
        // End:0xDF
        if(bSemiAuto || !bPlaying)
        {
            PlayAnimationOnWeapon(GetWeaponFireAnim(), !bSemiAuto);
        }
    }
    //return;    
}

static simulated function class<SPWeapon> GetWeaponClass(Actor Weap)
{
    local SPWeapon theWeapon;
    local SPWeaponAttachment WeaponAttach;

    theWeapon = SPWeapon(Weap);
    // End:0x2E
    if(theWeapon != none)
    {
        return theWeapon.Class;        
    }
    else
    {
        WeaponAttach = SPWeaponAttachment(Weap);
        // End:0x59
        if(WeaponAttach != none)
        {
            return WeaponAttach.WeaponClass;
        }
    }
    return none;
    //return ReturnValue;    
}

simulated event PostBeginPlay()
{
    super(Actor).PostBeginPlay();
    GetThirdPersonWeaponSounds(WorldInfo, Class, m_ThirdPersonWeaponSounds);
    GetSPWeaponGamePadParams(m_gamePad);
    //return;    
}

static simulated function GetThirdPersonWeaponSounds(WorldInfo theWorldInfo, class<SPWeapon> WeaponClass, out ThirdPersonWeaponSounds Sounds)
{
    local class<PandoraGameInfo> GameClass;

    // End:0x6F
    if((theWorldInfo != none) && theWorldInfo.GRI != none)
    {
        GameClass = class<PandoraGameInfo>(theWorldInfo.GRI.GameClass);
        // End:0x6F
        if(GameClass != none)
        {
            GameClass.static.GetThirdPersonWeaponSounds(WeaponClass, Sounds);
        }
    }
    //return;    
}

simulated function PlayFiringSound()
{
    // End:0x28
    if(Instigator == none)
    {
        Owner.PlaySound(Sound_Fire, true, true,,, true);        
    }
    else
    {
        PlayLocalSound(Sound_Fire);
    }
    StaticWeaponPlaySound(m_ThirdPersonWeaponSounds.FireSound, self);
    //return;    
}

simulated function PlayWeaponEmptySound()
{
    // End:0x28
    if(Instigator == none)
    {
        Owner.PlaySound(Sound_WeaponEmpty, true, true,,, true);        
    }
    else
    {
        PlayLocalSound(Sound_WeaponEmpty);
    }
    //return;    
}

simulated function PlayFireEndSound()
{
    // End:0x28
    if(Instigator == none)
    {
        Owner.PlaySound(Sound_Fire, true, true,,, true);        
    }
    else
    {
        PlayLocalSound(Sound_FireEnd);
    }
    StaticWeaponPlaySound(m_ThirdPersonWeaponSounds.FireEndSound, self);
    //return;    
}

static simulated function StaticWeaponPlaySound(SoundCue Sound, Actor Weap)
{
    local SPPawn thePawn;

    // End:0x1A
    if((Sound == none) || Weap == none)
    {
        return;
    }
    thePawn = SPPawn(Weap.Instigator);
    // End:0x41
    if(thePawn == none)
    {
        return;
    }
    thePawn.PlayRemoteSound(Sound);
    //return;    
}

simulated function PlayLocalSound(SoundCue Sound)
{
    local SPPawn thePawn;

    thePawn = SPPawn(Instigator);
    // End:0x1D
    if(thePawn == none)
    {
        return;
    }
    thePawn.PlayLocalSound(Sound);
    //return;    
}

simulated function SpawnMuzzleFlash(byte FireModeNum, Vector pos, Rotator Rot)
{
    local Pawn OwnerPawn;
    local editinline SkeletalMeshComponent skMesh;
    local ParticleSystem MuzzleFlashParticleSystemToUse;
    local SPSkeletalMeshActorMAT Ant;

    skMesh = SkeletalMeshComponent(Mesh);
    OwnerPawn = Pawn(Owner);
    Ant = SPSkeletalMeshActorMAT(Owner);
    // End:0x4A
    if((OwnerPawn == none) && Ant == none)
    {
        return;
    }
    // End:0x6A
    if((OwnerPawn != none) && OwnerPawn.bLogWeaponNet)
    {
    }
    // End:0x75
    if(m_bDisableMuzzleFlash)
    {
        return;
    }
    // End:0xAB
    if(Mesh.Owner.LastRenderTime < (WorldInfo.TimeSeconds - 1.0000000))
    {
        return;
    }
    // End:0xC6
    if(IsOwnerLocallyControlled())
    {
        MuzzleFlashParticleSystemToUse = MuzzleFlashParticleSystem;        
    }
    else
    {
        // End:0xD1
        if(ThirdPersonMuzzleFlashParticleSystem == none)
        {
        }
        MuzzleFlashParticleSystemToUse = ThirdPersonMuzzleFlashParticleSystem;
    }
    MuzzleFlashEmitter = Spawn(Class'SPEmitterSpawnable',,, pos, Rot);
    // End:0x301
    if(MuzzleFlashEmitter != none)
    {
        // End:0x161
        if(skMesh != none)
        {
            MuzzleFlashEmitter.SetOwner(skMesh.Owner);
            MuzzleFlashEmitter.SetBase(skMesh.Owner,, skMesh, MuzzleSocket, true);            
        }
        else
        {
            // End:0x1E9
            if(OwnerPawn != none)
            {
                MuzzleFlashEmitter.SetHardAttach(true);
                MuzzleFlashEmitter.SetOwner(OwnerPawn.Mesh.Owner);
                MuzzleFlashEmitter.SetBase(OwnerPawn.Mesh.Owner,, OwnerPawn.Mesh, AttachBoneName, true);                
            }
            else
            {
                // End:0x246
                if(Ant != none)
                {
                    MuzzleFlashEmitter.SetHardAttach(true);
                    MuzzleFlashEmitter.SetOwner(Ant);
                    MuzzleFlashEmitter.SetBase(Ant,, Ant.SkeletalMeshComponent, AttachBoneName, true);
                }
            }
        }
        MuzzleFlashEmitter.SetTemplate(MuzzleFlashParticleSystemToUse, false);
        MuzzleFlashEmitter.bDestroyOnSystemFinish = true;
        MuzzleFlashEmitter.ParticleSystemComponent.SecondsBeforeInactive = 0.0000000;
        MuzzleFlashEmitter.ParticleSystemComponent.ActivateSystem();
        // End:0x2EC
        if((OwnerPawn != none) && OwnerPawn.IsFirstPerson())
        {
            MuzzleFlashEmitter.ParticleSystemComponent.SetDepthPriorityGroup(2);
        }
        MuzzleFlashEmitter.bKillDuringLevelTransition = true;        
    }
    SetupMuzzleLight();
    //return;    
}

simulated function SpawnBarrelSmoke()
{
    local Pawn OwnerPawn;
    local editinline SkeletalMeshComponent skMesh;
    local Vector vPos;
    local Rotator rRot;
    local SPEmitter SmokeEmitter;
    local int Jdx;

    // End:0x1C
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        return;
    }
    // End:0x27
    if(m_bDisableMuzzleSmoke)
    {
        return;
    }
    skMesh = SkeletalMeshComponent(Mesh);
    OwnerPawn = Pawn(Owner);
    // End:0x5F
    if((OwnerPawn == none) || bIsNPCWeapon)
    {
        return;
    }
    GetBarrelSmokeLocAndRot(vPos, rRot);
    SmokeEmitter = Spawn(Class'SPEmitterSpawnable',,, vPos, rRot);
    // End:0x1BB
    if(SmokeEmitter != none)
    {
        // End:0x1BB
        if(skMesh != none)
        {
            SmokeEmitter.SetTemplate(BarrelSmokeParticleSystem, true);
            SmokeEmitter.bDestroyOnSystemFinish = true;
            SmokeEmitter.ParticleSystemComponent.SecondsBeforeInactive = 0.0000000;
            SmokeEmitter.ParticleSystemComponent.ActivateSystem();
            Jdx = 0;
            J0x117:

            // End:0x169 [Loop If]
            if(Jdx < SmokeEmitter.ParticleSystemComponent.EmitterInstances.Length)
            {
                SmokeEmitter.ParticleSystemComponent.SetKillOnCompleted(Jdx, true);
                Jdx++;
                // [Loop Continue]
                goto J0x117;
            }
            // End:0x1A9
            if((OwnerPawn != none) && OwnerPawn.IsFirstPerson())
            {
                SmokeEmitter.ParticleSystemComponent.SetDepthPriorityGroup(2);
            }
            SmokeEmitter.bKillDuringLevelTransition = true;
        }
    }
    //return;    
}

simulated function SetupMuzzleLight()
{
    // End:0x67
    if(MuzzleLight != none)
    {
        MuzzleLight.SetEnabled(true);
        MuzzleLight.SetLightProperties(GetMuzzleLightValue(), MuzzleLight.LightColor, MuzzleLight.Function);
        SetTimer(0.0100000, true, 'FadeMuzzleLight');
    }
    //return;    
}

simulated function TurnOffMuzzleLight()
{
    // End:0x1E
    if(MuzzleLight != none)
    {
        SetTimer(0.0100000, true, 'FadeMuzzleLight');
    }
    //return;    
}

simulated function SpawnShellCasing(bool bOverride)
{
    local SPShellCasingPersistent shell;
    local Vector vPos;
    local Rotator rRot;
    local Vector vEmitSocket, vRight;
    local Rotator rEmitRot;

    // End:0x0D
    if(ShellCasingClass == none)
    {
        return;
    }
    // End:0x1F
    if((AreShellCasingsEnabled()) == false)
    {
        return;
    }
    // End:0x31
    if((DisableShellCasingsForADS()) == true)
    {
        return;
    }
    // End:0x3C
    if(bIsNPCWeapon)
    {
        return;
    }
    // End:0x5A
    if(!CanSpawnNormalShellCasing() && !bOverride)
    {
        return;
    }
    // End:0x9F
    if((Mesh.Owner.LastRenderTime < (WorldInfo.TimeSeconds - 1.0000000)) && CanSpawnNormalShellCasing())
    {
        return;
    }
    // End:0xCF
    if(SPSkeletalMeshComponent(Mesh).GetSocketWorldLocationAndRotation('shell', vPos, rRot) == false)
    {
        return;
    }
    // End:0xFF
    if(SPSkeletalMeshComponent(Mesh).GetSocketWorldLocationAndRotation('emit', vEmitSocket, rEmitRot) == false)
    {
        return;
    }
    shell = Spawn(ShellCasingClass,,, vPos, rRot);
    // End:0x1BE
    if(shell != none)
    {
        vEmitSocket -= vPos;
        vEmitSocket = Normal(vEmitSocket);
        vRight = vEmitSocket Cross vect(0.0000000, 0.0000000, -1.0000000);
        shell.Init(vEmitSocket, vRight, CurrFOV);
        shell.Velocity = shell.Velocity + (GetParentVelocity());
        shell.bKillDuringLevelTransition = true;
    }
    //return;    
}

simulated function FadeMuzzleLight()
{
    local float Brightness;

    // End:0xCA
    if(MuzzleLight != none)
    {
        Brightness = MuzzleLight.Brightness;
        // End:0x76
        if(Brightness > 0.2000000)
        {
            Brightness -= (GetMuzzleLightFadeSpeed());
            MuzzleLight.SetLightProperties(Brightness, MuzzleLight.LightColor, MuzzleLight.Function);            
        }
        else
        {
            MuzzleLight.SetLightProperties(0.0000000, MuzzleLight.LightColor, MuzzleLight.Function);
            MuzzleLight.SetEnabled(false);
            ClearTimer('FadeMuzzleLight');
        }
    }
    //return;    
}

simulated function PlayAnimationOnWeapon(name Sequence, optional bool bLooping = false)
{
    local editinline SkeletalMeshComponent SkelMesh;
    local AnimNodeSequence playingAnim;

    // End:0x1D
    if(Pawn(Owner).bLogWeaponNet)
    {
    }
    // End:0x39
    if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
    {
        return;
    }
    SkelMesh = SkeletalMeshComponent(Mesh);
    // End:0x6E
    if(SkelMesh == none)
    {
        // End:0x6C
        if(Pawn(Owner).bLogWeaponNet)
        {
        }
        return;
    }
    playingAnim = AnimNodeSequence(SkelMesh.Animations);
    // End:0xAD
    if(playingAnim == none)
    {
        // End:0xAB
        if(Pawn(Owner).bLogWeaponNet)
        {
        }
        return;
    }
    playingAnim.SetAnim(Sequence);
    playingAnim.PlayAnim(bLooping, 1.0000000);
    // End:0x125
    if(AnimNodeSequence(SkelMesh.Animations).AnimSeq == none)
    {
        // End:0x123
        if(Pawn(Owner).bLogWeaponNet)
        {
        }
        return;
    }
    //return;    
}

reliable client simulated exec function ClientSetWeaponDPG(Scene.ESceneDepthPriorityGroup DPG_Group)
{
    // End:0x57
    if(Mesh != none)
    {
        Mesh.SetDepthPriorityGroup(DPG_Group);
        // End:0x45
        if(int(DPG_Group) == int(2))
        {
            Mesh.bAllowAmbientOcclusion = false;            
        }
        else
        {
            Mesh.bAllowAmbientOcclusion = true;
        }
    }
    //return;    
}

reliable client simulated exec function DetermineDPG()
{
    local Scene.ESceneDepthPriorityGroup DPG_Group;
    local PlayerPawn P;

    P = PlayerPawn(Owner);
    // End:0x3F
    if((P != none) && P.IsFirstPerson())
    {
        DPG_Group = 2;        
    }
    else
    {
        DPG_Group = 1;
    }
    ClientSetWeaponDPG(DPG_Group);
    //return;    
}

simulated function AttachWeapon(SkeletalMeshComponent parentMesh, name BoneName)
{
    local editinline SkeletalMeshComponent skMesh;

    // End:0x6D
    if(Mesh != none)
    {
        Mesh.SetHidden(false);
        Mesh.SetShadowParent(parentMesh);
        Mesh.SetLightEnvironment(parentMesh.LightEnvironment);
        parentMesh.AttachComponent(Mesh, BoneName);
    }
    DetermineDestFOV(0.0000000);
    skMesh = SkeletalMeshComponent(Mesh);
    // End:0xC2
    if((MuzzleLight != none) && skMesh != none)
    {
        skMesh.AttachComponentToSocket(MuzzleLight, 'emit');
    }
    // End:0xCD
    if(FlashLight != none)
    {
    }
    // End:0x144
    if(PlayerPawn(Owner) != none)
    {
        DetermineDPG();
        // End:0x141
        if((int(WorldInfo.NetMode) == int(NM_ListenServer)) && !PlayerPawn(Owner).IsLocallyControlled())
        {
            Mesh.SetDepthPriorityGroup(1);
            Mesh.bAllowAmbientOcclusion = true;
        }        
    }
    else
    {
        ClientSetWeaponDPG(1);
    }
    // End:0x190
    if((int(Role) == int(ROLE_Authority)) && SPPawn(Instigator) != none)
    {
        SPPawn(Instigator).SetWeaponAttachmentClass(AttachmentClass);
    }
    HandleNoLookDownSite();
    // End:0x1C4
    if(SPPawn(Instigator) != none)
    {
        SPPawn(Instigator).AddWeaponAnimations(Class);
    }
    //return;    
}

function bool IsPlayerMesh(SkeletalMeshComponent parentMesh)
{
    local Pawn asPawn;

    asPawn = Pawn(parentMesh.Owner);
    // End:0x2C
    if(PlayerPawn(asPawn) != none)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function bool IsLookingDownSight()
{
    local PandoraPlayerCamera thePlayerCamera;
    local PlayerPawn thePlayerPawn;

    thePlayerCamera = GetPlayerCamera();
    // End:0x51
    if(thePlayerCamera != none)
    {
        thePlayerPawn = PlayerPawn(Owner);
        // End:0x51
        if((thePlayerPawn != none) && thePlayerPawn.GetIsFullyLookingDownSite())
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

simulated function SetDestFOV(float newWeaponFOV, float newWorldFOV, float Time)
{
    local PandoraPlayerCamera thePlayerCamera;

    // End:0x80
    if(newWorldFOV <= float(0))
    {
        thePlayerCamera = GetPlayerCamera();
        // End:0x75
        if(thePlayerCamera != none)
        {
            // End:0x58
            if(thePlayerCamera.GetCameraStyle() == 'LookDownSite')
            {
                newWorldFOV = WorldLookDownSiteFOV;                
            }
            else
            {
                newWorldFOV = thePlayerCamera.GetDefaultFOV();
            }            
        }
        else
        {
            newWorldFOV = 75.0000000;
        }
    }
    // End:0xD2
    if(Time == float(0))
    {
        DestFOV = newWeaponFOV;
        CurrFOV = DestFOV;
        FOVChangeRate = 0.0000000;
        WorldDestFOV = newWorldFOV;
        WorldCurrFOV = WorldDestFOV;
        WorldFOVChangeRate = 0.0000000;        
    }
    else
    {
        FOVChangeRate = (newWeaponFOV - CurrFOV) / Time;
        DestFOV = newWeaponFOV;
        WorldFOVChangeRate = (newWorldFOV - WorldCurrFOV) / Time;
        WorldDestFOV = newWorldFOV;
    }
    //return;    
}

simulated function DetermineDestFOV(float Time)
{
    local PandoraPlayerCamera thePlayerCamera;
    local editinline SkeletalMeshComponent parentMesh;

    // End:0x1C
    if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
    {
        return;
    }
    // End:0x46
    if(Pawn(Owner) != none)
    {
        parentMesh = Pawn(Owner).Mesh;
    }
    // End:0x16B
    if(((((Pawn(Owner) != none) && parentMesh != none) && SPSkeletalMeshComponent(parentMesh) != none) && SPSkeletalMeshComponent(Mesh) != none) && PlayerPawn(parentMesh.Owner) != none)
    {
        thePlayerCamera = GetPlayerCamera();
        // End:0xF5
        if(PlayerPawn(parentMesh.Owner).HasKnife())
        {
            SetDestFOV(0.0000000, -1.0000000, 0.0000000);            
        }
        else
        {
            // End:0x14F
            if(((thePlayerCamera != none) && thePlayerCamera.GetCameraStyle() == 'LookDownSite') && HasLookDownSiteSocket())
            {
                SetDestFOV(LookDownSiteFOV, WorldLookDownSiteFOV, Time);                
            }
            else
            {
                SetDestFOV(HeldByPlayerFOV, -1.0000000, Time);
            }
        }        
    }
    else
    {
        SetDestFOV(0.0000000, -1.0000000, 0.0000000);
    }
    //return;    
}

simulated function DetermineSprintFOV(float Time)
{
    local editinline SkeletalMeshComponent parentMesh;
    local editinline SPSkeletalMeshComponent myMesh;

    // End:0x1C
    if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
    {
        return;
    }
    parentMesh = Pawn(Owner).Mesh;
    myMesh = SPSkeletalMeshComponent(Mesh);
    // End:0x9B
    if(((SPSkeletalMeshComponent(parentMesh) != none) && myMesh != none) && PlayerPawn(parentMesh.Owner) != none)
    {
        SetDestFOV(PlayerSprintFOV, WorldPlayerSprintFOV, Time);        
    }
    else
    {
        SetDestFOV(0.0000000, -1.0000000, 0.0000000);
    }
    //return;    
}

function HandleNoLookDownSite()
{
    local PandoraPlayerCamera thePlayerCamera;

    thePlayerCamera = GetPlayerCamera();
    // End:0x6C
    if(thePlayerCamera != none)
    {
        // End:0x6C
        if((thePlayerCamera.GetCameraStyle() == 'LookDownSite') && !HasLookDownSiteSocket())
        {
            thePlayerCamera.SetCameraStyle('FirstPerson');
        }
    }
    //return;    
}

simulated function PandoraPlayerCamera GetPlayerCamera()
{
    local PlayerPawn thePlayerPawn;
    local PandoraPlayerController thePlayerController;
    local PandoraPlayerCamera thePlayerCamera;

    // End:0x99
    if(Owner != none)
    {
        thePlayerPawn = PlayerPawn(Owner);
        // End:0x99
        if((thePlayerPawn != none) && thePlayerPawn.Controller != none)
        {
            thePlayerController = PandoraPlayerController(thePlayerPawn.Controller);
            // End:0x99
            if((thePlayerController != none) && thePlayerController.PlayerCamera != none)
            {
                thePlayerCamera = PandoraPlayerCamera(thePlayerController.PlayerCamera);
                return thePlayerCamera;
            }
        }
    }
    return none;
    //return ReturnValue;    
}

simulated function DetachWeapon()
{
    local editinline SkeletalMeshComponent parentMesh;
    local SPPawn P;
    local Pawn PawnOwner;

    // End:0x11
    if(!IsActiveWeapon())
    {
        return;
    }
    HandleWeaponDisengage();
    PawnOwner = Pawn(Owner);
    // End:0xC0
    if(PawnOwner != none)
    {
        parentMesh = PawnOwner.Mesh;
        // End:0xC0
        if(parentMesh != none)
        {
            // End:0xC0
            if((PawnOwner.Weapon != none) && PawnOwner.Weapon == self)
            {
                // End:0xAB
                if(SPSkeletalMeshComponent(parentMesh) != none)
                {
                    SetDestFOV(NotHeldByPlayerFOV, -1.0000000, 0.0000000);
                }
                parentMesh.DetachComponent(Mesh);
            }
        }
    }
    // End:0x12C
    if(Mesh != none)
    {
        Mesh.SetShadowParent(none);
        Mesh.SetLightEnvironment(LightEnvironment);
        Mesh.SetTickGroup(0);
        // End:0x12C
        if(SPSkeletalMeshComponent(Mesh) != none)
        {
            SetDestFOV(NotHeldByPlayerFOV, -1.0000000, 0.0000000);
        }
    }
    // End:0x161
    if(MuzzleLight != none)
    {
        // End:0x161
        if(SPSkeletalMeshComponent(Mesh) != none)
        {
            SkeletalMeshComponent(Mesh).DetachComponent(MuzzleLight);
        }
    }
    P = SPPawn(Instigator);
    // End:0x1F9
    if(P != none)
    {
        // End:0x1E4
        if((int(Role) == int(ROLE_Authority)) && P.GetWeaponAttachmentClass() == AttachmentClass)
        {
            P.SetWeaponAttachmentClass(none);
            // End:0x1E4
            if(Instigator.IsLocallyControlled())
            {
                P.WeaponAttachmentChanged();
            }
        }
        P.RemoveWeaponAnimations(Class);
    }
    //return;    
}

k2override function TransferAmmoFromReserveToMagazine(int AmountToReload)
{
    AmountToReload = Min(Min(AmountToReload, AmmoCount), magazineSize - ammoInMagazine);
    // End:0x37
    if(!bIsNPCWeapon)
    {
        AmmoCount -= AmountToReload;
    }
    ammoInMagazine += AmountToReload;
    //return;    
}

function ConsumeAmmo(byte FireModeNum, optional int Amount = 1)
{
    local PandoraPlayerController PandoraPC;
    local PlayerController PC;

    // End:0x17
    if(Amount < 1)
    {
        Amount = 1;
    }
    // End:0x39
    foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x38
        if(PC != none)
        {
            // End:0x39
            break;
        }        
    }    
    PandoraPC = PandoraPlayerController(PC);
    // End:0x6F
    if((PandoraPC != none) && PandoraPC.bUnlimitedWeaponsAndAmmo)
    {
        return;        
    }
    else
    {
        // End:0xA5
        if((ammoInMagazine > 0) && !m_bUsingUnlimitedAmmo)
        {
            ammoInMagazine -= Amount;
            // End:0xA5
            if(ammoInMagazine < 0)
            {
                ammoInMagazine = 0;
            }
        }
    }
    //return;    
}

simulated function bool HasAmmo(byte FireModeNum, optional int Amount)
{
    return ammoInMagazine > 0;
    //return ReturnValue;    
}

simulated function int AvailableAmmoInMagazine(byte FireModeNum)
{
    return ammoInMagazine;
    //return ReturnValue;    
}

simulated function bool HasAnyAmmo()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x34 [Loop If]
    if(I < 10)
    {
        // End:0x2A
        if(HasAmmo(byte(I)))
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

simulated function bool NeedToReload()
{
    return !HasAmmo(CurrentFireMode) || bForceReload;
    //return ReturnValue;    
}

simulated function bool MagazineFull()
{
    return ammoInMagazine == magazineSize;
    //return ReturnValue;    
}

simulated function bool CanReload()
{
    return (AmmoCount > 0) && !IsInState('WeaponFiring');
    //return ReturnValue;    
}

simulated function ForceReload()
{
    // End:0x11
    if(!CanReload())
    {
        return;
    }
    bForceReload = true;
    //return;    
}

static function AudioComponent HandleEffectLoopSound(SPPhysicalMaterial PhysMat, class<DamageType> theDamageType, Actor dummyActor, Vector soundPos, out SoundCue EndSound)
{
    // End:0x20
    if(PhysMat == none)
    {
        PhysMat = Class'SPWeapon'.default.DefaultMaterial;
    }
    return PhysMat.PlayEffectLoopSound(theDamageType, dummyActor, soundPos, EndSound);
    //return ReturnValue;    
}

simulated function TimeWeaponEquipping()
{
    // End:0x18
    if(Pawn(Owner).bLogWeaponNet)
    {
    }
    AttachWeaponTo(Instigator.Mesh);
    // End:0x53
    if(Instigator.IsFirstPerson())
    {
        PlayWeaponEquip();
    }
    SetTimer(EquipTime, false, 'WeaponEquipped');
    //return;    
}

reliable server function ToServerWeaponEquip()
{
    local PlayerPawn P;

    P = PlayerPawn(Owner);
    // End:0x2D
    if(P != none)
    {
        P.bInEquip = true;
    }
    //return;    
}

simulated function PlayWeaponEquip()
{
    local PlayerPawn P;
    local PandoraPlayerController PC;

    P = PlayerPawn(Owner);
    PC = PandoraPlayerController(P.Controller);
    // End:0x3D
    if(P.bLogWeaponNet)
    {
    }
    // End:0x6A
    if((GetWeaponEquipAnim()) != 'None')
    {
        PlayAnimationOnWeapon(GetWeaponEquipAnim());
    }
    // End:0x8E
    if(int(P.Role) == int(ROLE_AutonomousProxy))
    {
        ToServerWeaponEquip();
    }
    P.bInEquip = true;
    PC.ResetLookDownSiteState();
    //return;    
}

simulated function TimeWeaponPutDown()
{
    // End:0x18
    if(Pawn(Owner).bLogWeaponNet)
    {
    }
    // End:0x4B
    if(Instigator.IsFirstPerson() || PlayerPawn(Instigator) != none)
    {
        PlayWeaponPutDown();
    }
    super(Weapon).TimeWeaponPutDown();
    //return;    
}

simulated function PlayWeaponPutDown()
{
    local PlayerPawn P;
    local PandoraPlayerController PC;

    // End:0x18
    if(Pawn(Owner).bLogWeaponNet)
    {
    }
    // End:0x96
    if((GetWeaponUnequipAnim()) != 'None')
    {
        P = PlayerPawn(Owner);
        PC = PandoraPlayerController(P.Controller);
        PlayAnimationOnWeapon(GetWeaponUnequipAnim());
        P.bInUnequip = true;
        PC.ResetLookDownSiteState();
    }
    //return;    
}

function SetReloading(bool IsReloading)
{
    local HumanPawn P;

    P = HumanPawn(Owner);
    P.bInReload = IsReloading;
    //return;    
}

simulated function Vector GetPhysicalFireStartLoc(optional Vector AimDir)
{
    // End:0x2D
    if((Instigator != none) && Instigator.IsHumanControlled())
    {
        return super(Weapon).GetPhysicalFireStartLoc(AimDir);
    }
    return GetMuzzleLoc();
    //return ReturnValue;    
}

simulated event Vector MyGetPhysicalFireStartLoc(optional Vector AimDir)
{
    return GetPhysicalFireStartLoc(AimDir);
    //return ReturnValue;    
}

simulated function SPInstantFire(bool bUseFakeFire)
{
    local Vector StartTrace, EndTrace;
    local array<ImpactInfo> ImpactList;
    local int Idx;
    local ImpactInfo RealImpact;

    // End:0x29
    if(Instigator != none)
    {
        StartTrace = Instigator.GetWeaponStartTraceLocation();        
    }
    else
    {
        StartTrace = GetMuzzleLoc();
    }
    EndTrace = StartTrace + (Vector(GetAdjustedAim(StartTrace)) * (GetTraceRange()));
    // End:0x8D
    if(!bUseFakeFire)
    {
        RealImpact = CalcWeaponFire(StartTrace, EndTrace, ImpactList);
    }
    // End:0xB7
    if(int(Role) == int(ROLE_Authority))
    {
        SetFlashLocation(RealImpact.HitLocation);
    }
    // End:0xFD
    if(!bUseFakeFire)
    {
        Idx = 0;
        J0xC9:

        // End:0xFD [Loop If]
        if(Idx < ImpactList.Length)
        {
            ProcessInstantHit(CurrentFireMode, ImpactList[Idx]);
            Idx++;
            // [Loop Continue]
            goto J0xC9;
        }
    }
    //return;    
}

simulated event ImpactInfo MyCalcWeaponFire(Vector StartTrace, Vector EndTrace, optional out array<ImpactInfo> ImpactList)
{
    return CalcWeaponFire(StartTrace, EndTrace, ImpactList);
    //return ReturnValue;    
}

simulated event GetProjectileFirePosition(out Vector out_ProjLoc, out Vector out_ProjDir)
{
    // End:0x24
    if(IsProjectileFirePositionCached == true)
    {
        out_ProjLoc = CachedProjectileFirePositionLoc;
        out_ProjDir = CachedProjectileFirePositionDir;
        return;
    }
    GetProjectileFirePositionNoSpread(out_ProjLoc, out_ProjDir);
    SpreadCalculate();
    // End:0x64
    if(ApplySpreadToBulletWhenShot())
    {
        out_ProjDir = Vector(AddSpread(Rotator(out_ProjDir)));
    }
    CachedProjectileFirePositionLoc = out_ProjLoc;
    CachedProjectileFirePositionDir = out_ProjDir;
    IsProjectileFirePositionCached = true;
    //return;    
}

simulated function bool ApplySpreadToBulletWhenShot()
{
    return true;
    //return ReturnValue;    
}

final event MoveEmitSocket(Rotator emitSocketRot, out Vector emitSocketPos)
{
    local Vector intersectionPoint, LineStart, lineDirection, LineEnd, PlaneOrigin, PlaneDirection;

    PlaneDirection = Vector(Instigator.CylinderComponent.GetRotation());
    PlaneOrigin = Instigator.CylinderComponent.GetPosition() + ((PlaneDirection * Instigator.CylinderComponent.CollisionRadius) * 0.8500000);
    LineStart = emitSocketPos;
    lineDirection = -Vector(emitSocketRot);
    LineEnd = LineStart + (lineDirection * float(300));
    // End:0xD1
    if(LinePlaneIntersection(LineStart, LineEnd, PlaneOrigin, PlaneDirection, intersectionPoint))
    {
        emitSocketPos = intersectionPoint;
    }
    //return;    
}

simulated event GetProjectileFirePositionNPC(out Vector out_ProjLoc, out Vector out_ProjDir)
{
    local Vector StartTrace, EndTrace;
    local ImpactInfo TestImpact, SecondaryImpact;
    local Rotator muzzleRotation;

    // End:0x2E
    if(Instigator == none)
    {
        GetMuzzleLocAndRot(out_ProjLoc, muzzleRotation);
        out_ProjDir = Vector(muzzleRotation);
        return;
    }
    StartTrace = Instigator.GetWeaponStartTraceLocation();
    out_ProjDir = Vector(GetAdjustedAim(StartTrace));
    out_ProjLoc = GetPhysicalFireStartLoc(out_ProjDir);
    // End:0x1D2
    if(StartTrace != out_ProjLoc)
    {
        EndTrace = StartTrace + (out_ProjDir * (GetTraceRange()));
        // End:0xF4
        if(!GetTraceCache(StartTrace, EndTrace, TestImpact))
        {
            TestImpact = CalcWeaponFire(StartTrace, EndTrace);
            SetTraceCache(StartTrace, EndTrace, TestImpact);
        }
        SecondaryImpact = CalcWeaponFire(TestImpact.HitLocation, out_ProjLoc);
        out_ProjLoc = GetMuzzleLoc();
        // End:0x1B0
        if(SecondaryImpact.HitActor != none)
        {
            // End:0x173
            if(SecondaryImpact.HitActor != TestImpact.HitActor)
            {
                out_ProjLoc = StartTrace;                
            }
            else
            {
                // End:0x1B0
                if(VSizeSq(SecondaryImpact.HitLocation - TestImpact.HitLocation) > 100.0000000)
                {
                    out_ProjLoc = StartTrace;
                }
            }
        }
        out_ProjDir = Normal(TestImpact.HitLocation - out_ProjLoc);        
    }
    //return;    
}

simulated event Projectile SpawnProjectile(Vector ProjLoc, Vector ProjDir, bool bUseFakeFire, optional bool bSpawnSimulated)
{
    local Actor TheActor;
    local Projectile theProj;
    local Rotator theRotation;

    theRotation = Rotator(ProjDir);
    TheActor = WorldInfo.MyActorPool.GetActorFromPool(GetProjectileClass(), 'None', ProjLoc, theRotation, none, true, false, self, Instigator, false, 0, bSpawnSimulated);
    theProj = Projectile(TheActor);
    // End:0xCF
    if(theProj != none)
    {
        theProj.Init(ProjDir);
        // End:0xAE
        if(bUseFakeFire)
        {
            theProj.SetCollision(false, false);
        }
        // End:0xCF
        if(Instigator != none)
        {
            SPPawn(Instigator).ShotsPerSec++;
        }
    }
    return theProj;
    //return ReturnValue;    
}

static simulated function Projectile StaticSpawnProjectile(Actor SpawnOwner, class<Projectile> InProjectileClass, Vector ProjLoc, Vector ProjDir, bool bUseFakeFire, optional bool bSpawnSimulated)
{
    local Projectile SpawnedProjectile;

    SpawnedProjectile = SpawnOwner.Spawn(InProjectileClass, SpawnOwner,, ProjLoc,,, true,, bSpawnSimulated);
    // End:0x85
    if((SpawnedProjectile != none) && !SpawnedProjectile.bDeleteMe)
    {
        SpawnedProjectile.Init(ProjDir);
        // End:0x85
        if(bUseFakeFire)
        {
            SpawnedProjectile.SetCollision(false, false);
        }
    }
    return SpawnedProjectile;
    //return ReturnValue;    
}

simulated function BaseFireAmmunition(optional bool bUseFakeFire, optional int ammoToConsume)
{
    // End:0x14
    if(ammoToConsume < 1)
    {
        ammoToConsume = 1;
    }
    ConsumeAmmo(CurrentFireMode, ammoToConsume);
    // End:0x48
    if(!IsRapidFireMode(int(CurrentFireMode)))
    {
        PlayFiringSound();
    }
    switch(WeaponFireTypes[int(CurrentFireMode)])
    {
        // End:0x70
        case 0:
            SPInstantFire(bUseFakeFire);
            // End:0xB4
            break;
        // End:0x88
        case 1:
            SPProjectileFire(bUseFakeFire);
            // End:0xB4
            break;
        // End:0xB1
        case 2:
            // End:0xA4
            if(bUseFakeFire)
            {
                SPCustomFire(true);                
            }
            else
            {
                CustomFire();
            }
            // End:0xB4
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0x104
    if((Instigator != none) && AIController(Instigator.Controller) != none)
    {
        AIController(Instigator.Controller).NotifyWeaponFired(self, CurrentFireMode);
    }
    //return;    
}

simulated function SPFireSetupRecoilEffect()
{
    local PandoraPlayerController spPlaya;
    local PlayerPawn playaPawn;
    local ScreenShakeStruct modShakeInfo;
    local float camShakeMod;

    // End:0x19A
    if(Owner != none)
    {
        playaPawn = PlayerPawn(Owner);
        // End:0x19A
        if((playaPawn != none) && playaPawn.Controller != none)
        {
            spPlaya = PandoraPlayerController(playaPawn.Controller);
            // End:0x19A
            if(spPlaya != none)
            {
                modShakeInfo = shakeInfo;
                camShakeMod = 1.0000000;
                // End:0xD4
                if(playaPawn.bIsCrouched)
                {
                    // End:0xBB
                    if(playaPawn.GetIsFullyLookingDownSite())
                    {
                        camShakeMod = RecoilInfo.CrouchedDownSiteShakeScale;                        
                    }
                    else
                    {
                        camShakeMod = RecoilInfo.CrouchedShakeScale;
                    }                    
                }
                else
                {
                    // End:0x101
                    if(playaPawn.GetIsFullyLookingDownSite())
                    {
                        camShakeMod = RecoilInfo.DownSiteShakeScale;
                    }
                }
                // End:0x185
                if(camShakeMod > 0.0001000)
                {
                    modShakeInfo.TimeDuration *= camShakeMod;
                    modShakeInfo.RotAmplitude *= camShakeMod;
                    modShakeInfo.LocAmplitude *= camShakeMod;
                    modShakeInfo.FOVAmplitude *= camShakeMod;
                    spPlaya.PlayCameraShake(modShakeInfo);
                }
                spPlaya.HandleRecoilEffect(self);
            }
        }
    }
    //return;    
}

simulated function SPFireAmmunition(optional bool bUseFakeFire)
{
    // End:0x2B
    if((Pawn(Owner) != none) && Pawn(Owner).bLogWeaponNet)
    {
    }
    // End:0x61
    if((Owner != none) && SPPawn(Owner) != none)
    {
        SPPawn(Owner).WeaponJustFired();
    }
    // End:0x81
    if(!IsRapidFireMode(int(CurrentFireMode)))
    {
        SPFireSetupRecoilEffect();
    }
    BaseFireAmmunition(bUseFakeFire);
    //return;    
}

simulated function FireAmmunition()
{
    SPFireAmmunition(false);
    //return;    
}

simulated event Rotator MyGetAdjustedAim(Vector StartFireLoc)
{
    return GetAdjustedAim(StartFireLoc);
    //return ReturnValue;    
}

simulated function Rotator GetAdjustedAim(Vector StartFireLoc)
{
    local Rotator R;
    local PlayerPawn thePlayerPawn;
    local Vector assistLoc, assistDeltaLoc, shotAtDir;
    local Actor targetActor;
    local PandoraPlayerInput thePlayerInput;
    local float shotAssistRange, ShotAssistDisableRadius, targetProjDist;
    local int shotAssistRangeInRotatorUnits;
    local Rotator assistDeltaRotator, assistRotator;

    // End:0x25
    if(Instigator == none)
    {
        GetMuzzleLocAndRot(assistLoc, assistRotator);
        return assistRotator;
    }
    thePlayerPawn = PlayerPawn(Owner);
    R = Instigator.GetAdjustedAimFor(self, StartFireLoc);
    // End:0x22C
    if((thePlayerPawn != none) && thePlayerPawn.Weapon == self)
    {
        thePlayerInput = PandoraPlayerInput(PlayerController(thePlayerPawn.Controller).PlayerInput);
        // End:0x222
        if(thePlayerInput != none)
        {
            thePlayerInput.GetShotAssistInfo(targetActor, assistLoc, shotAssistRange, ShotAssistDisableRadius);
            // End:0x222
            if((targetActor != none) && shotAssistRange != 0.0000000)
            {
                assistDeltaLoc = assistLoc - StartFireLoc;
                assistRotator = Rotator(assistDeltaLoc);
                assistDeltaRotator = Normalize(assistRotator - R);
                shotAtDir = Normal(Vector(R));
                targetProjDist = assistDeltaLoc Dot shotAtDir;
                assistDeltaLoc = assistDeltaLoc - (shotAtDir * targetProjDist);
                assistDeltaLoc.Z = 0.0000000;
                targetProjDist = VSize(assistDeltaLoc);
                // End:0x222
                if(targetProjDist >= ShotAssistDisableRadius)
                {
                    shotAssistRangeInRotatorUnits = int(shotAssistRange * (65536.0000000 / 360.0000000));
                    assistDeltaRotator.Yaw = Clamp(assistDeltaRotator.Yaw, -shotAssistRangeInRotatorUnits, shotAssistRangeInRotatorUnits);
                    assistDeltaRotator.Pitch = Clamp(assistDeltaRotator.Pitch, -shotAssistRangeInRotatorUnits, shotAssistRangeInRotatorUnits);
                    R = R + assistDeltaRotator;                    
                }
            }
        }
        SpreadCalculate();
    }
    return AddSpread(R);
    //return ReturnValue;    
}

simulated function class<SPGrenadePersistent> GetGrenadePersistentClass()
{
    return BulletGrenadePersistentClass;
    //return ReturnValue;    
}

simulated function float SpreadCalculate()
{
    local SpreadData currSpreadData;
    local float speedEpsilon, interpVal;

    speedEpsilon = 0.0010000;
    // End:0x20B
    if((PlayerPawn(Owner) != none) && PandoraPlayerController(PlayerPawn(Owner).Controller) != none)
    {
        // End:0x9E
        if(PlayerPawn(Owner).GetIsFullyLookingDownSite() && WorldInfo.TimeSeconds > (LastShotTime + SpreadInfo.FirstShotMinDeltaTime))
        {
            currSpreadData = SpreadInfo.FirstShotDownSite;            
        }
        else
        {
            // End:0x104
            if(Pawn(Owner).bIsCrouched)
            {
                // End:0xEB
                if(PlayerPawn(Owner).GetIsFullyLookingDownSite())
                {
                    currSpreadData = SpreadInfo.CrouchedDownSite;                    
                }
                else
                {
                    currSpreadData = SpreadInfo.Crouched;
                }                
            }
            else
            {
                // End:0x139
                if(PlayerPawn(Owner).GetIsFullyLookingDownSite())
                {
                    currSpreadData = SpreadInfo.DownSite;                    
                }
                else
                {
                    currSpreadData = SpreadInfo.Normal;
                }
            }
        }
        // End:0x1ED
        if(VSize(Pawn(Owner).Velocity) > speedEpsilon)
        {
            interpVal = VSize(Pawn(Owner).Velocity) / PlayerPawn(Owner).playerForwardSpeed;
            Spread[int(CurrentFireMode)] = currSpreadData.StoppedSpreadValue + ((currSpreadData.FullSpeedSpreadValue - currSpreadData.StoppedSpreadValue) * interpVal);            
        }
        else
        {
            Spread[int(CurrentFireMode)] = currSpreadData.StoppedSpreadValue;
        }
    }
    return Spread[int(CurrentFireMode)];
    //return ReturnValue;    
}

simulated function PlayFireEffects(byte FireModeNum, optional Vector HitLocation)
{
    local Vector Loc, Dir;
    local Rotator rotDir;

    // End:0x62
    if(bIsNPCWeapon && Instigator != none)
    {
        Loc = Instigator.GetWeaponStartTraceLocation();
        rotDir = Instigator.GetAdjustedAimFor(self, Loc);
        Dir = Vector(rotDir);        
    }
    else
    {
        GetProjectileFirePosition(Loc, Dir);
        rotDir = Rotator(Dir);
    }
    SpawnMuzzleFlash(FireModeNum, Loc, rotDir);
    SpawnBarrelSmoke();
    // End:0xF8
    if(IsOwnerLocallyControlled())
    {
        SpawnShellCasing(false);
        StartForceFeedBackEffect();
        // End:0xF8
        if(int(WorldInfo.NetMode) == int(NM_Client))
        {
            SpawnProjectile(Loc, Dir, false, true);
        }
    }
    //return;    
}

simulated function Projectile ProjectileFire()
{
    return none;
    //return ReturnValue;    
}

simulated function ActiveRenderOverlays(HUD H)
{
    local string S;
    local float XL, YL;

    // End:0x116
    if(!bIsNPCWeapon)
    {
        H.Canvas.Font = Class'Engine.Engine'.static.GetMediumFont();
        H.Canvas.SetDrawColor(255, 255, 255, 255);
        S = "Ammo:" @ string(ammoInMagazine);
        H.Canvas.StrLen(S, XL, YL);
        H.Canvas.SetPos(float(H.Canvas.SizeX - H.OverscanX) - XL, float(H.Canvas.SizeY - H.OverscanY) - YL);
    }
    //return;    
}

simulated function DetachWeaponFrom(SkeletalMeshComponent MeshCpnt)
{
    MeshCpnt.DetachComponent(Mesh);
    //return;    
}

simulated function HandleWeaponDisengage()
{
    local PlayerPawn OwnerPawn;
    local PandoraPlayerController PC;

    OwnerPawn = PlayerPawn(Owner);
    // End:0x81
    if(OwnerPawn != none)
    {
        // End:0x81
        if(OwnerPawn.Controller != none)
        {
            // End:0x81
            if(OwnerPawn.GetIsPartiallyLookingDownSite())
            {
                PC = PandoraPlayerController(OwnerPawn.Controller);
                // End:0x81
                if(PC != none)
                {
                    PC.DoUnLookDownSite(true);
                }
            }
        }
    }
    //return;    
}

simulated function Destroyed()
{
    HandleWeaponDisengage();
    DestroyMuzzleSmoke();
    DestroyMuzzleFlashEmitter();
    super(Weapon).Destroyed();
    //return;    
}

function PlayCycleAnim()
{
    PlayAnimationOnWeapon(GetWeaponCycleAnim(), true);
    //return;    
}

function PlayReloadFinishAnim()
{
    PlayAnimationOnWeapon(GetWeaponReloadFinishAnim());
    //return;    
}

simulated function bool ShouldRefire()
{
    // End:0x0B
    if(bSemiAuto)
    {
        return false;
    }
    return super(Weapon).ShouldRefire();
    //return ReturnValue;    
}

simulated function bool HasLookDownSiteSocket()
{
    local Vector dummyLoc;
    local Rotator dummyRot;

    // End:0x0D
    if(Mesh == none)
    {
        return false;
    }
    // End:0x1F
    if(SkeletalMeshComponent(Mesh) == none)
    {
        return false;
    }
    // End:0x4F
    if(SkeletalMeshComponent(Mesh).GetSocketWorldLocationAndRotation('LookDownSite', dummyLoc, dummyRot) == false)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

simulated function ParticleCollision(ImpactInfo Impact)
{
    //return;    
}

function ParticleMoved(Vector oldPos, Vector NewPos, float DeltaTime)
{
    //return;    
}

simulated function Rotator AddSpread(Rotator BaseAim)
{
    local Vector X, Y, Z;
    local float CurrentSpread, RandY, RandZ;
    local SoldierPawn Pawn;

    // End:0x16
    if((IsEquippable()) == false)
    {
        return BaseAim;
    }
    CurrentSpread = Spread[int(CurrentFireMode)];
    // End:0x3F
    if(CurrentSpread ~= float(0))
    {
        return BaseAim;        
    }
    else
    {
        Pawn = SoldierPawn(Owner);
        // End:0x7B
        if((Pawn != none) && Pawn.bIsCrouched)
        {
            CurrentSpread *= 0.5000000;
        }
        GetAxes(BaseAim, X, Y, Z);
        RandY = FRand() - 0.5000000;
        RandZ = Sqrt(0.5000000 - Square(RandY)) * (FRand() - 0.5000000);
        return Rotator((X + ((RandY * CurrentSpread) * Y)) + ((RandZ * CurrentSpread) * Z));
    }
    //return ReturnValue;    
}

simulated function float GetCurrWorldFOV()
{
    return WorldCurrFOV;
    //return ReturnValue;    
}

simulated function float GetCurrFOV()
{
    return CurrFOV;
    //return ReturnValue;    
}

simulated function Actor GetAimAtActor()
{
    local Vector StartTrace, EndTrace, AimLoc;
    local Rotator AimRot;
    local ImpactInfo TestImpact;

    // End:0x5E
    if(Instigator != none)
    {
        StartTrace = Instigator.GetWeaponStartTraceLocation();
        EndTrace = StartTrace + (Vector(Instigator.GetAdjustedAimFor(self, StartTrace)) * (GetTraceRange()));        
    }
    else
    {
        StartTrace = GetMuzzleLoc();
        GetMuzzleLocAndRot(AimLoc, AimRot);
        EndTrace = StartTrace + (Vector(AimRot) * (GetTraceRange()));
    }
    // End:0xF4
    if(!GetTraceCache(StartTrace, EndTrace, TestImpact))
    {
        TestImpact = CalcWeaponFire(StartTrace, EndTrace);
        SetTraceCache(StartTrace, EndTrace, TestImpact);
    }
    return TestImpact.HitActor;
    //return ReturnValue;    
}

function ReloadBullets()
{
    //return;    
}

function ExplodeRocketFromTrigger()
{
    //return;    
}

simulated function bool GetTraceCache(Vector StartLoc, Vector EndLoc, out ImpactInfo Impact)
{
    // End:0x91
    if((WorldInfo.TimeSeconds - m_TraceCache.Time) <= 0.1000000)
    {
        // End:0x91
        if(VSizeSq(m_TraceCache.StartLoc - StartLoc) <= 0.0000000)
        {
            // End:0x91
            if(VSizeSq(m_TraceCache.EndLoc - EndLoc) <= 0.0000000)
            {
                Impact = m_TraceCache.Impact;
                return true;
            }
        }
    }
    return false;
    //return ReturnValue;    
}

simulated function SetTraceCache(Vector StartLoc, Vector EndLoc, out ImpactInfo Impact)
{
    m_TraceCache.Time = WorldInfo.TimeSeconds;
    m_TraceCache.StartLoc = StartLoc;
    m_TraceCache.EndLoc = EndLoc;
    m_TraceCache.Impact = Impact;
    //return;    
}

simulated function DoReloadOnController()
{
    // End:0x5C
    if((Pawn(Owner) != none) && PandoraPlayerController(Pawn(Owner).Controller) != none)
    {
        PandoraPlayerController(Pawn(Owner).Controller).ServerDoReload();        
    }
    else
    {
        GotoState('Reloading');
    }
    //return;    
}

function SetLookDownFireInterval(float fireIntervalChange)
{
    //return;    
}

function SetSpread(float spreadChange)
{
    //return;    
}

simulated function SetScopeEnabled(bool usingScope)
{
    m_bUsingScope = usingScope;
    //return;    
}

simulated function SetMuzzleFlashDisabled(bool muzzleFlashValue)
{
    m_bDisableMuzzleFlash = muzzleFlashValue;
    //return;    
}

simulated function DisableMuzzleSmoke(bool muzzleSmokeValue)
{
    m_bDisableMuzzleSmoke = muzzleSmokeValue;
    //return;    
}

simulated function EnableSuperFireAttackSystem()
{
    //return;    
}

simulated function DisableSuperFireAttackSystem()
{
    //return;    
}

simulated event SetADSCameraRotationValues(out Vector pos)
{
    local Vector emitVec;
    local Rotator emitRot;
    local Vector cameraVec;
    local Rotator cameraRot;
    local Vector directionVec, forwardVec, upVec;
    local float SideShiftSpeed;
    local Pawn thePawn;
    local PandoraPlayerController pController;

    thePawn = Pawn(Owner);
    // End:0x55
    if(thePawn != none)
    {
        pController = PandoraPlayerController(thePawn.Controller);
        // End:0x55
        if(pController != none)
        {
            // End:0x55
            if(pController.IsPaused())
            {
                return;
            }
        }
    }
    // End:0x66
    if(!IsUsingADSCameraTurnValue())
    {
        return;
    }
    // End:0x96
    if(SkeletalMeshComponent(Mesh).GetSocketWorldLocationAndRotation('emit', emitVec, emitRot) == false)
    {
        return;
    }
    thePawn = Pawn(Owner);
    // End:0xE8
    if(Class'PandoraPlayerCamera'.static.IsThirdPerson(thePawn))
    {
        Class'PandoraPlayerCamera'.static.GetFirstPersonBaseInfoFromConstants(thePawn, cameraVec, cameraRot);        
    }
    else
    {
        thePawn.Mesh.GetSocketWorldLocationAndRotation('cameraLoc', cameraVec, cameraRot);
    }
    upVec = vect(0.0000000, 0.0000000, 1.0000000);
    forwardVec = Normal(emitVec - cameraVec);
    directionVec = forwardVec Cross upVec;
    upVec = directionVec Cross forwardVec;
    // End:0x180
    if(IsLookingDownSight())
    {
        SideShiftSpeed = GetADSSideShiftSpeed();        
    }
    else
    {
        SideShiftSpeed = GetSideShiftSpeed();
    }
    // End:0x1A5
    if(m_bIsViewTurning)
    {
        SideShiftSpeed *= 2.0000000;
    }
    // End:0x1BA
    if(m_bIsViewTransitioning)
    {
        SideShiftSpeed *= 8.0000000;
    }
    // End:0x1F2
    if(m_ADSCameraRotationRateDampened < m_ADSCameraRotationRate)
    {
        m_ADSCameraRotationRateDampened += SideShiftSpeed;
        // End:0x1EF
        if(m_ADSCameraRotationRateDampened > m_ADSCameraRotationRate)
        {
            m_ADSCameraRotationRateDampened = m_ADSCameraRotationRate;
        }        
    }
    else
    {
        // End:0x22A
        if(m_ADSCameraRotationRateDampened > m_ADSCameraRotationRate)
        {
            m_ADSCameraRotationRateDampened -= SideShiftSpeed;
            // End:0x227
            if(m_ADSCameraRotationRateDampened < m_ADSCameraRotationRate)
            {
                m_ADSCameraRotationRateDampened = m_ADSCameraRotationRate;
            }            
        }
        else
        {
            m_bIsViewTransitioning = false;
        }
    }
    directionVec *= -m_ADSCameraRotationRateDampened;
    pos += directionVec;
    pos += (SetADSCameraRotationValuesUp(pos, upVec));
    //return;    
}

simulated function Vector SetADSCameraRotationValuesUp(Vector pos, Vector upVec)
{
    local float UpShiftSpeed;

    // End:0x20
    if(IsLookingDownSight())
    {
        UpShiftSpeed = GetADSSideShiftSpeed();        
    }
    else
    {
        UpShiftSpeed = GetSideShiftSpeed();
    }
    // End:0x45
    if(m_bIsPitchTurning)
    {
        UpShiftSpeed *= 2.0000000;
    }
    // End:0x5A
    if(m_bIsPitchTransitioning)
    {
        UpShiftSpeed *= 8.0000000;
    }
    // End:0x92
    if(m_ADSCameraRotationRateDampenedUp < m_ADSCameraRotationRateUp)
    {
        m_ADSCameraRotationRateDampenedUp += UpShiftSpeed;
        // End:0x8F
        if(m_ADSCameraRotationRateDampenedUp > m_ADSCameraRotationRateUp)
        {
            m_ADSCameraRotationRateDampenedUp = m_ADSCameraRotationRateUp;
        }        
    }
    else
    {
        // End:0xCA
        if(m_ADSCameraRotationRateDampenedUp > m_ADSCameraRotationRateUp)
        {
            m_ADSCameraRotationRateDampenedUp -= UpShiftSpeed;
            // End:0xC7
            if(m_ADSCameraRotationRateDampenedUp < m_ADSCameraRotationRateUp)
            {
                m_ADSCameraRotationRateDampenedUp = m_ADSCameraRotationRateUp;
            }            
        }
        else
        {
            m_bIsPitchTransitioning = false;
        }
    }
    upVec *= -m_ADSCameraRotationRateDampenedUp;
    return upVec;
    //return ReturnValue;    
}

simulated function SetADSCameraTurnValue(float aTurn, bool bDisable)
{
    m_bIsViewTurning = false;
    // End:0x26
    if(bDisable && !m_bIsViewTransitioning)
    {
        m_bIsViewTransitioning = true;
    }
    // End:0x64
    if(IsLookingDownSight())
    {
        // End:0x4A
        if(aTurn == 0.0000000)
        {
            m_bIsViewTurning = true;
        }
        m_ADSCameraRotationRate = aTurn * (GetADSSideShiftRange());        
    }
    else
    {
        // End:0x7B
        if(aTurn == 0.0000000)
        {
            m_bIsViewTurning = true;
        }
        m_ADSCameraRotationRate = aTurn * (GetSideShiftRange());
    }
    //return;    
}

simulated function SetADSCameraLookValue(float aLook, bool bDisable)
{
    m_bIsPitchTurning = false;
    // End:0x26
    if(bDisable && !m_bIsPitchTransitioning)
    {
        m_bIsPitchTransitioning = true;
    }
    // End:0x64
    if(IsLookingDownSight())
    {
        // End:0x4A
        if(aLook == 0.0000000)
        {
            m_bIsPitchTurning = true;
        }
        m_ADSCameraRotationRateUp = aLook * (GetADSUpShiftRange());        
    }
    else
    {
        // End:0x7B
        if(aLook == 0.0000000)
        {
            m_bIsPitchTurning = true;
        }
        m_ADSCameraRotationRateUp = aLook * (GetUpShiftRange());
    }
    //return;    
}

simulated function bool IsUsingADSCameraTurnValue()
{
    return false;
    //return ReturnValue;    
}

simulated function float GetADSCameraLookValue()
{
    return m_ADSCameraRotationRateUp;
    //return ReturnValue;    
}

simulated function float GetADSCameraTurnValue()
{
    return m_ADSCameraRotationRate;
    //return ReturnValue;    
}

simulated function float GetADSCameraLookValueDampened()
{
    return m_ADSCameraRotationRateDampenedUp;
    //return ReturnValue;    
}

simulated function float GetADSCameraTurnValueDampened()
{
    return m_ADSCameraRotationRateDampened;
    //return ReturnValue;    
}

simulated function float GetADSSideShiftRange()
{
    return 2.0000000;
    //return ReturnValue;    
}

simulated function float GetADSSideShiftSpeed()
{
    return 0.0100000;
    //return ReturnValue;    
}

simulated function float GetADSUpShiftRange()
{
    return 2.0000000;
    //return ReturnValue;    
}

simulated function float GetADSUpShiftSpeed()
{
    return 0.0100000;
    //return ReturnValue;    
}

simulated function float GetSideShiftRange()
{
    return 2.0000000;
    //return ReturnValue;    
}

simulated function float GetSideShiftSpeed()
{
    return 0.0100000;
    //return ReturnValue;    
}

simulated function float GetUpShiftRange()
{
    return 2.0000000;
    //return ReturnValue;    
}

simulated function float GetUpShiftSpeed()
{
    return 0.0100000;
    //return ReturnValue;    
}

simulated event Vector GetMuzzleLoc()
{
    local Vector Loc;
    local Rotator Rot;

    // End:0x1D
    if(GetMuzzleLocAndRot(Loc, Rot))
    {
        return Loc;
    }
    return Location;
    //return ReturnValue;    
}

simulated event bool GetMuzzleLocAndRot(out Vector Loc, out Rotator Rot)
{
    // End:0x1E
    if(StaticGetMuzzleLoc(Mesh, Loc, Rot))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated event bool GetBarrelSmokeLocAndRot(out Vector Loc, out Rotator Rot)
{
    // End:0x1E
    if(StaticGetBarrelSmokeLoc(Mesh, Loc, Rot))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated event Vector GetMuzzleLocFromPawn()
{
    local Vector Loc;
    local Rotator Rot;

    // End:0x1D
    if(GetMuzzleLocAndRotFromPawn(Loc, Rot))
    {
        return Loc;
    }
    return Location;
    //return ReturnValue;    
}

simulated event bool GetMuzzleLocAndRotFromPawn(out Vector Loc, out Rotator Rot)
{
    local Pawn thePawn;

    thePawn = Pawn(Owner);
    // End:0x43
    if(thePawn != none)
    {
        // End:0x43
        if(StaticGetMuzzleLoc(thePawn.Mesh, Loc, Rot))
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

static simulated event bool StaticGetMuzzleLoc(MeshComponent theMesh, out Vector Loc, optional out Rotator Rot)
{
    local editinline SkeletalMeshComponent skMesh;

    skMesh = SkeletalMeshComponent(theMesh);
    // End:0x48
    if(skMesh != none)
    {
        // End:0x43
        if(!skMesh.GetSocketWorldLocationAndRotation(default.MuzzleSocket, Loc, Rot))
        {            
        }
        else
        {
            return true;
        }        
    }
    return false;
    //return ReturnValue;    
}

static simulated event bool StaticGetBarrelSmokeLoc(MeshComponent theMesh, out Vector Loc, optional out Rotator Rot)
{
    local editinline SkeletalMeshComponent skMesh;

    skMesh = SkeletalMeshComponent(theMesh);
    // End:0x48
    if(skMesh != none)
    {
        // End:0x43
        if(!skMesh.GetSocketWorldLocationAndRotation(default.BarrelSmokeSocket, Loc, Rot))
        {            
        }
        else
        {
            return true;
        }        
    }
    return false;
    //return ReturnValue;    
}

simulated function int GetMaxMolotovCount()
{
    return 0;
    //return ReturnValue;    
}

simulated function int GetMaxGrenadeCount()
{
    return 0;
    //return ReturnValue;    
}

simulated function int GetMaxTaserGrenadeCount()
{
    return 0;
    //return ReturnValue;    
}

simulated function int GetMaxFlareCount()
{
    return 0;
    //return ReturnValue;    
}

simulated function int GetMaxGrenadeCanCarry()
{
    return 0;
    //return ReturnValue;    
}

function SetBulletGenerator(bool Value)
{
    m_bUsingUnlimitedAmmo = Value;
    //return;    
}

simulated function bool HasMuzzleFlashEmitter()
{
    // End:0x0D
    if(MuzzleFlashEmitter == none)
    {
        return false;
    }
    // End:0x22
    if(MuzzleFlashEmitter.bDeleteMe)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

simulated function HideMuzzleFlashEmitter(bool bHide)
{
    // End:0x21
    if(MuzzleFlashEmitter != none)
    {
        MuzzleFlashEmitter.SetHidden(bHide);
    }
    // End:0x39
    if(!bHide)
    {
        SetupMuzzleLight();        
    }
    else
    {
        TurnOffMuzzleLight();
    }
    //return;    
}

simulated function DestroyMuzzleFlashEmitter()
{
    // End:0x1F
    if(MuzzleFlashEmitter != none)
    {
        MuzzleFlashEmitter.Destroy();
        MuzzleFlashEmitter = none;
    }
    //return;    
}

simulated function StartForceFeedBackEffect()
{
    local PandoraPlayerController PPC;

    // End:0x0B
    if(m_ForceFeedBackActive)
    {
        return;
    }
    PPC = GetPandoraPlayerController();
    // End:0x5E
    if((PPC != none) && m_gamePad.Fire_ForceFeedbackWaveform != none)
    {
        PPC.ClientPlayForceFeedbackWaveform(m_gamePad.Fire_ForceFeedbackWaveform);
    }
    m_ForceFeedBackActive = true;
    //return;    
}

simulated function StopForceFeedBackEffect()
{
    local PandoraPlayerController PPC;

    PPC = GetPandoraPlayerController();
    // End:0x76
    if(((PPC != none) && m_gamePad.Fire_ForceFeedbackWaveform != none) && m_gamePad.Fire_ForceFeedbackWaveform.bIsLooping == true)
    {
        PPC.ClientStopForceFeedbackWaveform(m_gamePad.Fire_ForceFeedbackWaveform);
    }
    m_ForceFeedBackActive = false;
    //return;    
}

simulated function EndFire(byte FireModeNum)
{
    super(Weapon).EndFire(FireModeNum);
    StopForceFeedBackEffect();
    //return;    
}

function MarkForDeath(Vector TossVel)
{
    SavedTossVel = TossVel;
    m_bMarkedForDeath = true;
    //return;    
}

simulated function float GetHeldByPlayerFOV()
{
    return HeldByPlayerFOV;
    //return ReturnValue;    
}

simulated function float GetLookDownSiteFOV()
{
    return LookDownSiteFOV;
    //return ReturnValue;    
}

simulated function float GetCurrentFOV()
{
    return CurrFOV;
    //return ReturnValue;    
}

simulated function SetWeaponFOV(SPSkeletalMeshComponent myMesh, float weaponFOV)
{
    myMesh.SetFOV(weaponFOV);
    //return;    
}

simulated function SetMuzzleFlashFOV(float FOV)
{
    // End:0x2E
    if(MuzzleFlashEmitter != none)
    {
        MuzzleFlashEmitter.ParticleSystemComponent.SetFOV(FOV);
    }
    //return;    
}

reliable client simulated function ClientGivenTo(Pawn NewOwner, bool bDoNotActivate)
{
    super(Inventory).ClientGivenTo(NewOwner, bDoNotActivate);
    bAvailable = true;
    //return;    
}

function AnnouncePickup(Pawn Other)
{
    local PandoraGameInfo PGI;

    super(Inventory).AnnouncePickup(Other);
    PGI = PandoraGameInfo(WorldInfo.Game);
    // End:0x73
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        // End:0x73
        if((PGI != none) && PDAMessageUIScene != "")
        {
            PGI.UnlockPDAMessage(3, PDAMessageUIScene);
        }
    }
    //return;    
}

simulated function name GetWeaponIdleAnim()
{
    local SPPawn theOwner;

    theOwner = SPPawn(Owner);
    // End:0x3D
    if((theOwner == none) || theOwner.UseFirstPersonAnims())
    {
        return WeaponIdleAnim;        
    }
    else
    {
        return WeaponIdleAnim;
    }
    //return ReturnValue;    
}

simulated function name GetWeaponFireAnim()
{
    return WeaponFireAnim;
    //return ReturnValue;    
}

simulated function name GetWeaponReloadAnim()
{
    local SPPawn theOwner;

    theOwner = SPPawn(Owner);
    // End:0x3D
    if((theOwner == none) || theOwner.UseFirstPersonAnims())
    {
        return WeaponReloadAnim;        
    }
    else
    {
        return WeaponIdleAnim;
    }
    //return ReturnValue;    
}

simulated function name GetWeaponCycleAnim()
{
    return WeaponCycleAnim;
    //return ReturnValue;    
}

simulated function name GetWeaponReloadFinishAnim()
{
    return WeaponReloadFinishAnim;
    //return ReturnValue;    
}

simulated function name GetWeaponEquipAnim()
{
    return WeaponEquipAnim;
    //return ReturnValue;    
}

simulated function name GetWeaponUnequipAnim()
{
    return WeaponUnequipAnim;
    //return ReturnValue;    
}

simulated function bool DisableShellCasingsForADS()
{
    return false;
    //return ReturnValue;    
}

simulated function DestroyMuzzleSmoke()
{
    // End:0x1F
    if(MuzzleSmokeEmitter != none)
    {
        MuzzleSmokeEmitter.Destroy();
        MuzzleSmokeEmitter = none;
    }
    //return;    
}

simulated function ClearPendingFire(int FireMode)
{
    local editinline SkeletalMeshComponent skMesh;
    local PlayerPawn ownerPlayerPawn;
    local Vector Loc;
    local Rotator rotDir;

    // End:0x16
    if(m_bDisableMuzzleSmoke)
    {
        super(Weapon).ClearPendingFire(FireMode);
        return;
    }
    // End:0x75
    if(((AmmoCount == 0) && ammoInMagazine == 0) && m_bCanAutoSwapDueToNoAmmo)
    {
        ownerPlayerPawn = PlayerPawn(Owner);
        // End:0x75
        if(ownerPlayerPawn != none)
        {
            super(Weapon).ClearPendingFire(FireMode);
            ownerPlayerPawn.SwapWeaponsDueToNoAmmo();
            return;
        }
    }
    // End:0x8D
    if(!m_bUseMuzzleSmoke)
    {
        super(Weapon).ClearPendingFire(FireMode);
        return;
    }
    // End:0xA5
    if(!m_bMuzzleSmokeEnabled)
    {
        super(Weapon).ClearPendingFire(FireMode);
        return;
    }
    // End:0xCA
    if(MuzzleSmokeEmitter != none)
    {
        ClearTimer('DestroyMuzzleSmoke');
        DestroyMuzzleSmoke();
    }
    skMesh = SkeletalMeshComponent(Mesh);
    GetMuzzleLocAndRot(Loc, rotDir);
    // End:0x203
    if(skMesh != none)
    {
        MuzzleSmokeEmitter = Spawn(Class'SPEmitterSpawnable',,, Loc, rotDir);
        // End:0x203
        if(MuzzleSmokeEmitter != none)
        {
            MuzzleSmokeEmitter.SetTemplate(MuzzleSmokeParticleSystem);
            MuzzleSmokeEmitter.bDestroyOnSystemFinish = true;
            MuzzleSmokeEmitter.ParticleSystemComponent.SecondsBeforeInactive = 0.0000000;
            MuzzleSmokeEmitter.ParticleSystemComponent.ActivateSystem();
            MuzzleSmokeEmitter.SetBase(skMesh.Owner,, skMesh, MuzzleSocket, true);
            MuzzleSmokeEmitter.SetOwner(skMesh.Owner);
            MuzzleSmokeEmitter.bKillDuringLevelTransition = true;
            SetTimer(2.0000000, false, 'DestroyMuzzleSmoke');
            m_bMuzzleSmokeEnabled = false;
        }
    }
    super(Weapon).ClearPendingFire(FireMode);
    //return;    
}

simulated function bool HideReticleInAds()
{
    return true;
    //return ReturnValue;    
}

simulated function CleanupPreMapChange()
{
    m_TraceCache.Impact.HitActor = none;
    m_TraceCache.Impact.HitInfo.Material = none;
    m_TraceCache.Impact.HitInfo.PhysMaterial = none;
    m_TraceCache.Impact.HitInfo.HitComponent = none;
    //return;    
}

simulated function bool CanSpawnNormalShellCasing()
{
    return true;
    //return ReturnValue;    
}

simulated function float GetMuzzleLightValue()
{
    return 1.0000000;
    //return ReturnValue;    
}

simulated function bool CanWeaponLookDownSite()
{
    return m_bCanWeaponLookDownSite;
    //return ReturnValue;    
}

simulated function float GetMuzzleLightFadeSpeed()
{
    return 0.2000000;
    //return ReturnValue;    
}

simulated function float GetReticleSpreadScale()
{
    return 1.0000000;
    //return ReturnValue;    
}

simulated event bool IsReloading()
{
    return IsInState('Reloading');
    //return ReturnValue;    
}

simulated function StopFire(byte FireModeNum)
{
    StopAmbxEffectForThisTypeOfWeaponFire(DefaultAmBxEffectName);
    super(Weapon).StopFire(FireModeNum);
    //return;    
}

reliable client simulated function PlayAmbxEffectForThisTypeOfWeaponFire(string AmBxWeaponType)
{
    // End:0xF1
    if(!IsReloading() && ammoInMagazine != 0)
    {
        // End:0xF1
        if(((((((Owner != none) && Pawn(Owner) != none) && Pawn(Owner).Controller != none) && PandoraPlayerController(Pawn(Owner).Controller) != none) && PandoraPlayerController(Pawn(Owner).Controller).DoesThePlayerWantToUseAmBx()) && !IsInState('WeaponEquipping')) && m_bAmBxAllowedToFire)
        {
            PandoraPlayerController(Pawn(Owner).Controller).PlayAmBxScript(AmBxWeaponType, 50);
        }
    }
    //return;    
}

reliable client simulated function StopAmbxEffectForThisTypeOfWeaponFire(string AmBxWeaponType)
{
    // End:0xC1
    if((((((Owner != none) && Pawn(Owner) != none) && Pawn(Owner).Controller != none) && PandoraPlayerController(Pawn(Owner).Controller) != none) && PandoraPlayerController(Pawn(Owner).Controller).DoesThePlayerWantToUseAmBx()) && !bSemiAuto)
    {
        PandoraPlayerController(Pawn(Owner).Controller).StopAmBxScript(AmBxWeaponType);
    }
    //return;    
}

simulated state Active
{
    simulated function BeginState(name PreviousStateName)
    {
        local int I;

        // End:0x18
        if(Pawn(Owner).bLogWeaponNet)
        {
        }
        // End:0x45
        if((GetWeaponIdleAnim()) != 'None')
        {
            PlayAnimationOnWeapon(GetWeaponIdleAnim(), true);
        }
        // End:0xDE
        if(!bReloadInterrupted)
        {
            // End:0x66
            if(bWeaponPutDown)
            {
                PutDownWeapon();                
            }
            else
            {
                // End:0x8D
                if(NeedToReload())
                {
                    // End:0x8A
                    if(CanReload())
                    {
                        DoReloadOnController();
                    }                    
                }
                else
                {
                    I = 0;
                    J0x94:

                    // End:0xDE [Loop If]
                    if(I < InvManager.PendingFire.Length)
                    {
                        // End:0xD4
                        if(PendingFire(I))
                        {
                            BeginFire(byte(I));
                            // [Explicit Break]
                            goto J0xDE;
                        }
                        I++;
                        // [Loop Continue]
                        goto J0x94;
                    }
                }
            }
        }
        J0xDE:

        bReloadInterrupted = false;
        //return;        
    }

    simulated function BeginFire(byte FireModeNum)
    {
        local PlayerPawn thePlayerPawn;

        thePlayerPawn = PlayerPawn(Owner);
        // End:0x28
        if(Pawn(Owner).bLogWeaponNet)
        {
        }
        // End:0x59
        if(thePlayerPawn != none)
        {
            thePlayerPawn.MegaDisableAnimusActivities();
            thePlayerPawn.m_eGrenadeState = 0;
        }
        // End:0x115
        if(!bDeleteMe && Instigator != none)
        {
            global.BeginFire(FireModeNum);
            // End:0xDB
            if(!HasAmmo(FireModeNum))
            {
                // End:0xB9
                if(CanReload())
                {
                    PlayWeaponEmptySound();
                    DoReloadOnController();                    
                }
                else
                {
                    // End:0xD8
                    if(thePlayerPawn != none)
                    {
                        thePlayerPawn.SwapWeaponsDueToNoAmmo();
                    }
                }                
            }
            else
            {
                // End:0x115
                if(PendingFire(int(FireModeNum)))
                {
                    PlayAmbxEffectForThisTypeOfWeaponFire(DefaultAmBxEffectName);
                    m_bMuzzleSmokeEnabled = true;
                    SendToFiringState(FireModeNum);
                }
            }
        }
        //return;        
    }
    stop;    
}

simulated state Reloading
{
    simulated function int RoundUpToMultiple(int Number, int Multiple)
    {
        // End:0x25
        if(Multiple > 0)
        {
            return (Number + (Multiple - 1)) / Multiple;            
        }
        else
        {
            return 1;
        }
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local HumanPawn P;

        // End:0x18
        if(Pawn(Owner).bLogWeaponNet)
        {
        }
        bInterruptRequested = false;
        ReloadCount = 0;
        NumberOfReloadCycles = RoundUpToMultiple(Min(AmmoCount, magazineSize - ammoInMagazine), BulletsPerReloadCycle);
        // End:0x69
        if(PlayerPawn(Owner) == none)
        {
            ForceEndFire();
        }
        // End:0x7B
        if(StillFiring(CurrentFireMode))
        {
        }
        // End:0xA8
        if((GetWeaponReloadAnim()) != 'None')
        {
            PlayAnimationOnWeapon(GetWeaponReloadAnim());
        }
        P = HumanPawn(Owner);
        // End:0xFF
        if(P != none)
        {
            bRequestReload = true;
            // End:0xEB
            if(int(Role) > int(ROLE_AutonomousProxy))
            {
                SetReloading(bRequestReload);
            }
            P.ReloadStart();
        }
        // End:0x11D
        if(Owner != none)
        {
            Owner.MakeNoise(1.0000000);
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        local HumanPawn P;

        bRequestReload = false;
        P = HumanPawn(Owner);
        // End:0x58
        if(P != none)
        {
            // End:0x43
            if(int(Role) > int(ROLE_AutonomousProxy))
            {
                SetReloading(bRequestReload);
            }
            P.TellReloadFinished(self);
        }
        //return;        
    }

    simulated function CycleAmmo()
    {
        local int AmountToReload;

        // End:0x0D
        if(ReloadCount > 1)
        {
            return;
        }
        --NumberOfReloadCycles;
        // End:0x61
        if(!MagazineFull() && CanReload())
        {
            AmountToReload = Min(magazineSize - ammoInMagazine, Min(AmmoCount, BulletsPerReloadCycle));
            TransferAmmoFromReserveToMagazine(AmountToReload);
        }
        // End:0xA5
        if((((NumberOfReloadCycles <= 0) || !CanReload()) || bInterruptRequested) || bWeaponPutDown)
        {
            ReloadCount = 2;
            PlayReloadFinishAnim();
        }
        //return;        
    }

    simulated function ReloadFinished()
    {
        local int AmountToReload;

        AmountToReload = Min(magazineSize - ammoInMagazine, Min(AmmoCount, magazineSize));
        TransferAmmoFromReserveToMagazine(AmountToReload);
        GotoState('Active');
        //return;        
    }

    simulated function StartFire(byte FireModeNum)
    {
        // End:0x1C
        if(InterruptReload())
        {
            global.StartFire(FireModeNum);
        }
        //return;        
    }

    reliable server function ServerStartFire(byte FireModeNum)
    {
        // End:0x1C
        if(InterruptReload())
        {
            global.ServerStartFire(FireModeNum);
        }
        //return;        
    }

    reliable server function ServerInterruptReloadRequest()
    {
        bInterruptRequested = true;
        //return;        
    }

    simulated function InterruptReloadRequest()
    {
        // End:0x24
        if(int(WorldInfo.NetMode) == int(NM_Client))
        {
            ServerInterruptReloadRequest();
        }
        bInterruptRequested = true;
        //return;        
    }

    simulated function bool InterruptReload()
    {
        // End:0x26
        if(NeedToReload())
        {
            // End:0x26
            if(CanReload())
            {
                InterruptReloadRequest();
                return false;
            }
        }
        ForceInterruptReload();
        return true;
        //return ReturnValue;        
    }

    reliable server function ServerForceInterruptReload()
    {
        local PlayerPawn P;

        P = PlayerPawn(Owner);
        bReloadInterrupted = true;
        // End:0x58
        if(P != none)
        {
            // End:0x44
            if(P.IsReloadFromAnimationFinished())
            {
                ReloadFinished();
            }
            P.ResetReloadFromAnimationValue();
        }
        GotoState('Active');
        //return;        
    }

    simulated function ForceInterruptReload()
    {
        local PlayerPawn P;

        P = PlayerPawn(Owner);
        // End:0x34
        if(int(WorldInfo.NetMode) == int(NM_Client))
        {
            ServerForceInterruptReload();
        }
        bReloadInterrupted = true;
        // End:0x7C
        if(P != none)
        {
            // End:0x68
            if(P.IsReloadFromAnimationFinished())
            {
                ReloadFinished();
            }
            P.ResetReloadFromAnimationValue();
        }
        GotoState('Active');
        //return;        
    }
    stop;    
}

simulated state WeaponPuttingDown
{
    simulated function WeaponIsDown()
    {
        ClearTimer('WeaponIsDown');
        super.WeaponIsDown();
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        local HumanPawn P;

        P = HumanPawn(Owner);
        // End:0x2D
        if(P != none)
        {
            P.bInUnequip = false;
        }
        // End:0x4A
        if(IsTimerActive('WeaponIsDown'))
        {
            WeaponIsDown();
        }
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

simulated state WeaponEquipping
{
    simulated function EndState(name NextStateName)
    {
        local HumanPawn P;

        P = HumanPawn(Owner);
        // End:0x2D
        if(P != none)
        {
            P.bInEquip = false;
        }
        bWeaponHasBeenFired = false;
        bReloadInterrupted = false;
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

simulated state WeaponFiring
{
    simulated event bool IsFiring()
    {
        return true;
        //return ReturnValue;        
    }

    simulated function RefireCheckTimer()
    {
        // End:0x15
        if(bWeaponPutDown)
        {
            PutDownWeapon();
            return;
        }
        // End:0x2E
        if(ShouldRefire())
        {
            PlayFiringAnim();
            return;
        }
        // End:0x6B
        if(!bSemiAuto)
        {
            // End:0x4F
            if(bDryFire)
            {
                PlayWeaponEmptySound();                
            }
            else
            {
                // End:0x6B
                if(StillFiring(CurrentFireMode))
                {
                    bDryFire = true;
                    return;
                }
            }
        }
        StopFire(CurrentFireMode);
        GotoState('Active');
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local PandoraPlayerController PPC;
        local Pawn OwnerPawn;
        local PlayerPawn ownerPlayerPawn;

        OwnerPawn = Pawn(Owner);
        // End:0x30
        if((OwnerPawn != none) && OwnerPawn.bLogWeaponNet)
        {
        }
        ownerPlayerPawn = PlayerPawn(Owner);
        // End:0x5D
        if(ownerPlayerPawn != none)
        {
            ownerPlayerPawn.m_bADSResetWeaponFire = true;
        }
        PlayFiringAnim();
        // End:0x8C
        if(!bIsNPCWeapon && bSemiAuto)
        {
            TimeWeaponFiring(CurrentFireMode);
        }
        // End:0x12E
        if(int(WorldInfo.NetMode) != int(NM_Standalone))
        {
            // End:0x12B
            if(WorldInfo.GRI.bIsArbitrated)
            {
                // End:0x12B
                if(!bWeaponHasBeenFired && int(Role) == int(ROLE_Authority))
                {
                    bWeaponHasBeenFired = true;
                    PPC = PandoraPlayerController(Pawn(Owner).Controller);
                    // End:0x12B
                    if(PPC != none)
                    {
                        PPC.ClientNewWeaponFiredAchievement(WeaponType);
                    }
                }
            }            
        }
        else
        {
            // End:0x184
            if(!bWeaponHasBeenFired)
            {
                bWeaponHasBeenFired = true;
                PPC = PandoraPlayerController(Pawn(Owner).Controller);
                // End:0x184
                if(PPC != none)
                {
                    PPC.SinglePlayerNewWeaponFiredAchievement(WeaponType);
                }
            }
        }
        Sound_Looping = none;
        // End:0x207
        if(Sound_FireStart != none)
        {
            // End:0x1C4
            if(Owner != none)
            {
                Sound_Looping = Owner.CreateAudioComponent(Sound_FireStart, false, true);                
            }
            else
            {
                Sound_Looping = CreateAudioComponent(Sound_FireStart, false, true);
            }
            // End:0x207
            if(Sound_Looping != none)
            {
                Sound_Looping.bAutoDestroy = true;
                Sound_Looping.Play();
            }
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x22
        if(Sound_Looping != none)
        {
            Sound_Looping.Stop();
            Sound_Looping = none;
        }
        PlayFireEndSound();
        // End:0x4B
        if(!HasAmmo(CurrentFireMode))
        {
            WeaponEmpty();
        }
        bDryFire = false;
        ClearFlashCount();
        ClearTimer('RefireCheckTimer');
        //return;        
    }
    stop;    
}
