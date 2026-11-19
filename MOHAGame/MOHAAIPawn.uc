class MOHAAIPawn extends CCPerformerPawn
    native
    config(Game)
    hidecategories(Navigation)
    implements(EditorLinkBehaviorInterface);

const WTI_SEMIAUTORIFLE = 0;
const WTI_SMG = 1;
const WTI_RIFLE = 2;
const WTI_OTHER = 3;
const DY_OFF = 0;
const DY_START = 1;
const DY_FINISH = 2;

enum FixedFire_Activity
{
    FIXED_FIRE_DEFAULT,             // 0
    FIXED_FIRE_MELEE,               // 1
    FIXED_FIRE_GRENADE,             // 2
    FIXED_FIRE_MAX                  // 3
};

struct native DetachableBodyPartInfo
{
    var float Probability;
    var name BoneName;
    var name SecondaryBoneName;
    var class<Actor> SpawnedBodyPartClass;
    var name BoneControlName;
    var StaticMesh SpawnedMesh;
    var SkelControlSingleBone BoneControl;
    var Vector MinSpawnVelocity;
    var Vector MaxSpawnVelocity;
    var float MinRotationRate;
    var float MaxRotationRate;
    var Rotator rRotCorrection;
    var bool bDetachOnExplosion;
    var SoundCue HitSound_PC;
    var SoundCue HitSound_NPC;
    var bool bCachedDetached;

    structdefaultproperties
    {
        Probability=0.0000000
        BoneName="None"
        SecondaryBoneName="None"
        SpawnedBodyPartClass=none
        BoneControlName="None"
        SpawnedMesh=none
        BoneControl=none
        MinSpawnVelocity=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        MaxSpawnVelocity=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        MinRotationRate=0.0000000
        MaxRotationRate=0.0000000
        rRotCorrection=(Pitch=0,Yaw=0,Roll=0)
        bDetachOnExplosion=false
        HitSound_PC=none
        HitSound_NPC=none
        bCachedDetached=false
    }
};

struct native GearMeshInfo
{
    var SkeletalMesh Mesh;

    structdefaultproperties
    {
        Mesh=none
    }
};

struct native HeadMeshInfo
{
    var float Freq;
    var SkeletalMesh Mesh;

    structdefaultproperties
    {
        Freq=0.0000000
        Mesh=none
    }
};

struct native OIRActivityPacket
{
    var OIROwnerInterface oirOwner;
    var name ActivityName;
    var name activityPose;
    var float TransitionRateScale;

    structdefaultproperties
    {
        oirOwner=none
        ActivityName="None"
        activityPose="None"
        TransitionRateScale=0.0000000
    }
};

struct native RestoredAnimTreeState
{
    var int BlendByOIRActiveChildIndex;
    var int BlendByEntryExitActiveChildIndex;
    var int BlendByActivityActiveChildIndex;

    structdefaultproperties
    {
        BlendByOIRActiveChildIndex=-1
        BlendByEntryExitActiveChildIndex=-1
        BlendByActivityActiveChildIndex=-1
    }
};

var private native const noexport Pointer VfTable_IEditorLinkBehaviorInterface;
var class<KynapseAIController> KynapseControllerClass;
var() bool bSpawnDefaultController;
var() ParticleSystem DeathParticleSystemTemplate;
var export editinline ParticleSystemComponent DeathParticleSystemComponent;
var export editinline MOHAGraph AccelGraph;
var export editinline MOHAGraph DesSpeedGraph;
var export editinline MOHAGraph VelocityGraph;
var export editinline MOHAGraph HeightGraph;
var() bool bDrawAccelGraph;
var() bool bDrawDesiredSpeedGraph;
var() bool bDrawVelocityGraph;
var(Debug) bool bDrawHeightGraph;
var() bool bDebugTakeNoDamage;
var() bool bIgnoreAffordance;
var() bool bInvincible;
var() bool bNoHitReactions;
var() bool bNoRagdoll;
var() float NPCtoNPCDamageMult;
var() bool bThrowDudGrenades;
var(AI_Leash) KynapseVolume LeashVolume;
var(AI_Leash) float fLeashRadius;
var(AI_Leash) Vector vLeashHome;
var export editinline OirInstance ActiveOIR;
var bool bIsShutdown;
var bool bApplyOIRPhysics;
var(Anim) bool bDrawAim;
var transient bool bIsRunningInPlace;
var transient float RunningInPlaceTimeElapsed;
var() name EyeSocketName;
var() Vector EyePosOffset;
var() bool bDrawEyePos;
var() Actor IdleCoverActor;
var(AI) float MeleeCombatRange;
var Vector GrenadeThrowVelocity;
var(Debug) bool bDebugHealth;
var(Damage) name HeadShotBone;
var(Damage) config float ExplosionMomentumRadiusMult;
var transient bool bHasNewOIR;
var transient bool bPendingHasNewOIR;
var Vector vFirstGotoSubgoalPos;
var bool bIsGagPawn;
var int PlayingDeathYellState;
var name CoverTestChannelName;
var export editinline StimulusComponent DeathStimulus;
var bool bKillNewlySpawnedImmune;
var() class<MOHAProj_Explosive> GrenadeProjectileClass;
var float ExitAnimBlendAngle;
var() name AimBoneName;
var() Vector vAimBoneOffset;
var MOHAPawn MeleeTargetPawn;
var bool bNPCImmune;
var(Wearables) config array<config HeadMeshInfo> RandomHeadMeshes;
var(Wearables) config array<config DetachableBodyPartInfo> DetachableBodyParts;
var(Wearables) config GearMeshInfo GearInfo;
var MOHAAIPawn.FixedFire_Activity FixedFireActivity;
var bool IsMeleeEnabled;
var transient OIRActivityPacket nextOIRActivityPacket;
var transient bool bInHomeStretch;
var(oir) bool m_bShowOIRDebug;
var() bool bDropPapers;
var transient Rotator AbsoluteAimRot;
var export editinline FixedFireOIRImpl FFImpl;
var export editinline MeleeOIRImpl MImpl;
var export editinline DeathOIRImpl DeathImpl;
var export editinline KynapseCoverNode NImpl;
var transient Vector vCurrentSubgoal;
var transient Vector vNextSubgoal;
var bool bDetachableGear;
var const RestoredAnimTreeState AnimTreeState;
var bool bLogMissingTransitions;
var array<string> MissingTransitions;
var float NPCBulletFilterPct;
var float fDisablePlayerCollisionTime;
var float fGTFODisablePlayerCollisionTime;
var float fHitreactionEnergyAdditionMin;
var float fHitreactionEnergyAdditionMax;
var float fHitreactionEnergyDistanceMin;
var float fHitreactionEnergyDistanceMax;
var float PawnDeathTime;
var() int MaxBodies;

// Export UMOHAAIPawn::execTickNative(FFrame&, void* const)
native function TickNative(float DeltaTime);

// Export UMOHAAIPawn::execEnsureDebugSupressedMissingTransitionsPopulated(FFrame&, void* const)
native final function EnsureDebugSupressedMissingTransitionsPopulated();

// Export UMOHAAIPawn::execAddDebugSupressedMissingTransition(FFrame&, void* const)
native final function AddDebugSupressedMissingTransition(name srcPose, name srcActivity, name dstPose, name dstActivity);

event AddAllDebugSupressedMissingTransitions()
{
    AddDebugSupressedMissingTransition('Crouch_Center', 'Grenade', 'Crouch_Center', 'Hide');
    AddDebugSupressedMissingTransition('Crouch_Center', 'Grenade', 'Crouch_Center', 'Reload');
    AddDebugSupressedMissingTransition('Crouch_Center', 'Hide', 'Crouch_Center', 'Grenade');
    AddDebugSupressedMissingTransition('Crouch_Center', 'Hide', 'Crouch_Center', 'Reload');
    AddDebugSupressedMissingTransition('Crouch_Center', 'Reload', 'Crouch_Center', 'Grenade');
    AddDebugSupressedMissingTransition('Crouch_Center', 'Reload', 'Crouch_Center', 'Hide');
    AddDebugSupressedMissingTransition('Crouch_Left', 'Grenade', 'Crouch_Left', 'Hide');
    AddDebugSupressedMissingTransition('Crouch_Left', 'Grenade', 'Crouch_Left', 'Reload');
    AddDebugSupressedMissingTransition('Crouch_Left', 'Hide', 'Crouch_Left', 'Grenade');
    AddDebugSupressedMissingTransition('Crouch_Left', 'Hide', 'Crouch_Left', 'Reload');
    AddDebugSupressedMissingTransition('Crouch_Left', 'Reload', 'Crouch_Left', 'Grenade');
    AddDebugSupressedMissingTransition('Crouch_Left', 'Reload', 'Crouch_Left', 'Hide');
    AddDebugSupressedMissingTransition('Crouch_Right', 'Grenade', 'Crouch_Right', 'Hide');
    AddDebugSupressedMissingTransition('Crouch_Right', 'Grenade', 'Crouch_Right', 'Reload');
    AddDebugSupressedMissingTransition('Crouch_Right', 'Hide', 'Crouch_Right', 'Grenade');
    AddDebugSupressedMissingTransition('Crouch_Right', 'Hide', 'Crouch_Right', 'Reload');
    AddDebugSupressedMissingTransition('Crouch_Right', 'Reload', 'Crouch_Right', 'Grenade');
    AddDebugSupressedMissingTransition('Crouch_Right', 'Reload', 'Crouch_Right', 'Hide');
    //return;    
}

function SetMeleeEnabled(bool bEnabled)
{
    IsMeleeEnabled = bEnabled;
    //return;    
}

function OnPathGenerationStart()
{
    Destroy();
    //return;    
}

// Export UMOHAAIPawn::execUpdateLeash(FFrame&, void* const)
native final function UpdateLeash();

// Export UMOHAAIPawn::execGetPawnViewLocationNative(FFrame&, void* const)
native final function Vector GetPawnViewLocationNative();

// Export UMOHAAIPawn::execGetViewRotationNative(FFrame&, void* const)
native final function Rotator GetViewRotationNative();

// Export UMOHAAIPawn::execGetAimFromLocation(FFrame&, void* const)
native final function Vector GetAimFromLocation(optional bool bUseWeaponBarrel);

// Export UMOHAAIPawn::execGetEyeSocketLocationRotation(FFrame&, void* const)
native final function GetEyeSocketLocationRotation(out Vector out_Location, out Rotator out_Rotation);

// Export UMOHAAIPawn::execIsArrivedAtOIR(FFrame&, void* const)
native function bool IsArrivedAtOIR();

// Export UMOHAAIPawn::execIsArrivedAtNextOIR(FFrame&, void* const)
native function bool IsArrivedAtNextOIR();

// Export UMOHAAIPawn::execCylinderDistCheck(FFrame&, void* const)
native function bool CylinderDistCheck(Vector pos, float Radius);

// Export UMOHAAIPawn::execGetBaseAimRotationNative(FFrame&, void* const)
native final function Rotator GetBaseAimRotationNative(Vector vAimFromLoc, optional bool forceAimAtFocus);

// Export UMOHAAIPawn::execGetWeaponStartTraceLocationNative(FFrame&, void* const)
native final function bool GetWeaponStartTraceLocationNative(out Vector vStartLoc, Weapon CurrentWeapon);

// Export UMOHAAIPawn::execGetAimPosToShootMe(FFrame&, void* const)
native function Vector GetAimPosToShootMe();

// Export UMOHAAIPawn::execBodyHouseKeeping(FFrame&, void* const)
native function BodyHouseKeeping();

// Export UMOHAAIPawn::execCanRestorePlayerCollision(FFrame&, void* const)
native function bool CanRestorePlayerCollision();

// Export UMOHAAIPawn::execDropToFloor(FFrame&, void* const)
native function DropToFloor();

// Export UMOHAAIPawn::execUpdateFixedFireRotation(FFrame&, void* const)
native function UpdateFixedFireRotation(Vector vPosition);

// Export UMOHAAIPawn::execGetGroundPosition(FFrame&, void* const)
native function Vector GetGroundPosition(Vector StartLocation);

// Export UMOHAAIPawn::execIsPosInPathableSpace(FFrame&, void* const)
native function bool IsPosInPathableSpace(Vector CheckPos, KynapseAIController pKAIC, Vector DeltaMoveToPos);

// Export UMOHAAIPawn::execMeleeTrace(FFrame&, void* const)
native function Actor MeleeTrace(out Vector HitLocation, out Vector HitNormal, out TraceHitInfo HitInfo, Vector TraceEnd, Vector TraceStart, Vector TraceExtent);

event int GetWeaponTypeIndex()
{
    // End:0x29
    if(EALAWeapon(Weapon) != none)
    {
        return EALAWeapon(Weapon).GetWeaponTypeIndex();
    }
    return 3;
    //return ReturnValue;    
}

event OnOIREntryFinished()
{
    local OIREventListener Listener;

    // End:0x71
    if(NotEqual_InterfaceInterface(ActiveOIR.OIRParent, OIROwnerInterface(none)))
    {
        Listener = OIREventListener(ActiveOIR.GetObjFromInterface(ActiveOIR.OIRParent));
        // End:0x71
        if(NotEqual_InterfaceInterface(Listener, OIREventListener(none)))
        {
            Listener.OnEntryFinish();
        }
    }
    // End:0x90
    if(none != CCP)
    {
        CCP.SetBodyState_InOIR(true);
    }
    PlayByPostureOverride = 0;
    //return;    
}

function bool IsNewOIR(OIROwnerInterface oirIface)
{
    local OIRData nextOIR;
    local bool bAnimsChanged;

    // End:0x16
    if(EqualEqual_InterfaceInterface(oirIface, OIROwnerInterface(none)))
    {
        return false;
    }
    // End:0x35
    if(EqualEqual_InterfaceInterface(ActiveOIR.OIRParent, OIROwnerInterface(none)))
    {
        return true;
    }
    nextOIR = oirIface.GetOIRData();
    bAnimsChanged = (ActiveOIR.OIRAnimSet != nextOIR.OIRAnimSet) || ActiveOIR.OIRAnimTree != nextOIR.OIRAnimTree;
    return oirIface.IsDifferentOIR(ActiveOIR, bAnimsChanged);
    //return ReturnValue;    
}

event UseVaultExit(bool Val)
{
    // End:0xC0
    if(ActiveOIR != none)
    {
        ActiveOIR.bUseVaultExit = Val;
        PrintToAILog((("Setting ActiveOIR.bUseVaultExit to TRUE bHasNewOIR: " $ string(bHasNewOIR)) $ " bPendingHasNewOIR:") $ string(bPendingHasNewOIR));
        // End:0xC0
        if(Val)
        {
            ActiveOIR.OIRParent.GetAlternateExitFinalPosition(ActiveOIR.vAlternateExitFinalPosition);
        }
    }
    //return;    
}

event OnOIRExitBegin(bool Val)
{
    local OIREventListener Listener;

    // End:0x7A
    if(Val)
    {
        // End:0x7A
        if(NotEqual_InterfaceInterface(ActiveOIR.OIRParent, OIROwnerInterface(none)))
        {
            Listener = OIREventListener(ActiveOIR.GetObjFromInterface(ActiveOIR.OIRParent));
            // End:0x7A
            if(NotEqual_InterfaceInterface(Listener, OIREventListener(none)))
            {
                Listener.OnExitBegin();
            }
        }
    }
    // End:0x99
    if(none != CCP)
    {
        CCP.SetBodyState_InOIR(false);
    }
    //return;    
}

event OnOIRAttach()
{
    local OIREventListener Listener;

    // End:0x71
    if(NotEqual_InterfaceInterface(ActiveOIR.OIRParent, OIROwnerInterface(none)))
    {
        Listener = OIREventListener(ActiveOIR.GetObjFromInterface(ActiveOIR.OIRParent));
        // End:0x71
        if(NotEqual_InterfaceInterface(Listener, OIREventListener(none)))
        {
            Listener.OnAttach();
        }
    }
    //return;    
}

event OnOIRDetach()
{
    local OIREventListener Listener;

    // End:0x71
    if(NotEqual_InterfaceInterface(ActiveOIR.OIRParent, OIROwnerInterface(none)))
    {
        Listener = OIREventListener(ActiveOIR.GetObjFromInterface(ActiveOIR.OIRParent));
        // End:0x71
        if(NotEqual_InterfaceInterface(Listener, OIREventListener(none)))
        {
            Listener.OnDetach();
        }
    }
    //return;    
}

event bool OnPreAttachUpdateOIRRotation()
{
    local OIREventListener Listener;

    // End:0x72
    if(NotEqual_InterfaceInterface(ActiveOIR.OIRParent, OIROwnerInterface(none)))
    {
        Listener = OIREventListener(ActiveOIR.GetObjFromInterface(ActiveOIR.OIRParent));
        // End:0x72
        if(NotEqual_InterfaceInterface(Listener, OIREventListener(none)))
        {
            return Listener.OnPreAttachUpdateOIRRotation();
        }
    }
    return false;
    //return ReturnValue;    
}

event bool HasNewOIR()
{
    return IsNewOIR(nextOIRActivityPacket.oirOwner);
    //return ReturnValue;    
}

event PrintToAILog(string output)
{
    //return;    
}

event SetNextNavOIR()
{
    vFirstGotoSubgoalPos = NImpl.GetPosition();
    SetNextOIRData(NImpl, 'Hide', 'None', false);
    //return;    
}

function SetNextOIRData(Object oirOwner, name ActivityName, name activityPose, bool forceUseOIR, optional float TransitionRateScale = 1.0000000, optional bool bSetInPlace = false)
{
    local OIROwnerInterface oirIface;
    local Controller localController;

    // End:0x35
    if(Controller == none)
    {
        localController = Pawn(Owner).Controller;        
    }
    else
    {
        localController = Controller;
    }
    // DebugMode: 0
    assert(oirOwner != none);
    oirIface = OIROwnerInterface(oirOwner);
    // End:0x7F
    if((oirOwner == none) || EqualEqual_InterfaceInterface(oirIface, OIROwnerInterface(none)))
    {
        return;
    }
    nextOIRActivityPacket.oirOwner = oirIface;
    nextOIRActivityPacket.ActivityName = ActivityName;
    nextOIRActivityPacket.activityPose = activityPose;
    nextOIRActivityPacket.TransitionRateScale = TransitionRateScale;
    // End:0xFD
    if(bSetInPlace)
    {
        nextOIRActivityPacket.oirOwner.SetNextOIRInPlace();        
    }
    else
    {
        nextOIRActivityPacket.oirOwner.RegisteredAsNext();
    }
    // End:0x13A
    if(forceUseOIR)
    {
        ActiveOIR.bForceUseOIR = forceUseOIR;
    }
    // End:0x14A
    if(KynapseAIController(localController) != none)
    {
    }
    // End:0x271
    if(!ActiveOIR.bOIRInExit && !IsNewOIR(oirIface))
    {
        bPendingHasNewOIR = false;
        ActiveOIR.SetCurrentActivity(nextOIRActivityPacket.ActivityName, nextOIRActivityPacket.activityPose, nextOIRActivityPacket.TransitionRateScale);
        // End:0x1F1
        if(EqualEqual_InterfaceInterface(oirIface, OIROwnerInterface(FFImpl)))
        {
            FFImpl.Position = ActiveOIR.Location;
        }
        // End:0x26E
        if(oirIface.IsDifferentReference(ActiveOIR.OIRParent))
        {
            ActiveOIR.OIRParent.UpdateNewOIRReference(oirOwner);
            ActiveOIR.OIRParent = oirIface;
            oirIface.GetAlternateExitFinalPosition(ActiveOIR.vAlternateExitFinalPosition);
        }        
    }
    else
    {
        bInHomeStretch = false;
        bPendingHasNewOIR = true;
    }
    //return;    
}

function UpdateFixedFireOIR(Vector Position, optional float fYaw = -1.0000000)
{
    FFImpl.Position = Position;
    // End:0x3E
    if(fYaw < 0.0000000)
    {
        UpdateFixedFireRotation(Position);        
    }
    else
    {
        FFImpl.Rotation.Yaw = int(fYaw);
        FFImpl.Rotation.Pitch = 0;
        FFImpl.Rotation.Roll = 0;
    }
    //return;    
}

function SetNextFixedFireOIRData(Vector Position, name ActivityName, optional bool bSetInPlace = false)
{
    UpdateFixedFireOIR(Position);
    SetNextOIRData(FFImpl, ActivityName, 'None', false,, bSetInPlace);
    //return;    
}

function MeleeOIRImpl UpdateMeleeOIR(Vector Position, Rotator Rot)
{
    MImpl.Position = Position;
    MImpl.Rotation = Rot;
    MImpl.Rotation.Pitch = 0;
    MImpl.Rotation.Roll = 0;
    return MImpl;
    //return ReturnValue;    
}

function Vector GetPathablePosition()
{
    local Vector PathablePosition, TestOffset;

    PathablePosition = Location;
    // End:0x76
    if(ActiveOIR.OIRParent.IsA('NavigationOIRImpl') && ActiveOIR.bVaultExitUsed || ActiveOIR.bUseVaultExit)
    {
        ActiveOIR.OIRParent.GetAlternateExitFinalPosition(PathablePosition);
    }
    TestOffset = Vector(Rotation);
    TestOffset = Normal(TestOffset);
    // End:0xC7
    if(!IsPosInPathableSpace(PathablePosition, KynapseAIController(Controller), TestOffset))
    {
        PathablePosition = ActiveOIR.Location;
    }
    return PathablePosition;
    //return ReturnValue;    
}

event Vector GetSafeSubgoalPosition()
{
    local MOHAAIController MAIC;

    MAIC = MOHAAIController(Controller);
    // End:0x2B
    if(MAIC != none)
    {
        return MAIC.super(MOHAAIPawn).GetSafeSubgoalPosition();
    }
    return GetPawnBody().Location;
    //return ReturnValue;    
}

function OnSetLeashParams(SeqAct_SetLeashParams inAct)
{
    local Controller localController;

    // End:0x0D
    if(Health <= 0)
    {
        return;
    }
    // End:0x41
    if((Controller == none) && Owner != none)
    {
        localController = Pawn(Owner).Controller;        
    }
    else
    {
        localController = Controller;
    }
    LeashVolume = inAct.LeashVolume;
    // End:0x8C
    if(inAct.fLeashRadius > -255.0000000)
    {
        fLeashRadius = inAct.fLeashRadius;
    }
    // End:0xBD
    if(inAct.LeashRadiusPosition != none)
    {
        vLeashHome = inAct.LeashRadiusPosition.Location;
    }
    // End:0xE4
    if((fLeashRadius > 0.0000000) || LeashVolume != none)
    {
        bIgnoreAffordance = true;        
    }
    else
    {
        bIgnoreAffordance = false;
    }
    UpdateLeash();
    // End:0x18A
    if(KynapseAIController(localController) != none)
    {
        KynapseAIController(localController).ABSS.TripNamedScriptEvent('FindCover');
        // End:0x15D
        if((fLeashRadius > 0.0000000) || LeashVolume != none)
        {
            KynapseAIController(localController).bIgnoreAffordance = true;            
        }
        else
        {
            KynapseAIController(localController).bIgnoreAffordance = false;
        }
        KynapseAIController(localController).UpdateKynapseParams();        
    }
    //return;    
}

function OnNPCImmune(SeqAct_NPCImmune inAct)
{
    bNPCImmune = inAct.bMakeImmune;
    //return;    
}

function OnSetIgnoreAffordance(SeqAct_SetIgnoreAffordance inAct)
{
    bIgnoreAffordance = inAct.bIgnoreAffordance;
    // End:0x5E
    if(KynapseAIController(Controller) != none)
    {
        KynapseAIController(Controller).bIgnoreAffordance = inAct.bIgnoreAffordance;
        KynapseAIController(Controller).UpdateKynapseParams();
    }
    //return;    
}

simulated event AddSelfToBeadList()
{
    local PlayerController PlayerController;

    // End:0x57
    foreach LocalPlayerControllers(PlayerController)
    {
        // End:0x56
        if((PlayerController != none) && MOHAHUD(PlayerController.myHUD) != none)
        {
            MOHAHUD(PlayerController.myHUD).AddCompassBead(self);
        }        
    }    
    //return;    
}

simulated event RemoveSelfFromBeadList()
{
    local PlayerController PlayerController;

    // End:0x4A
    foreach LocalPlayerControllers(PlayerController)
    {
        // End:0x49
        if(MOHAHUD(PlayerController.myHUD) != none)
        {
            MOHAHUD(PlayerController.myHUD).RemoveCompassBead(self);
        }        
    }    
    //return;    
}

simulated function PreBeginPlay()
{
    super(MOHAPawn).PreBeginPlay();
    BodySkeletalMesh = default.Mesh.SkeletalMesh;
    AssignChildrenMeshes();
    SetCompositeMesh();
    AttachComponent(Mesh);
    //return;    
}

simulated function PostBeginPlay()
{
    // End:0x32
    if(!bKillNewlySpawnedImmune && MOHAGameInfo(WorldInfo.Game).bKillNewlySpawnedPawns)
    {
        Destroy();
        return;
    }
    Mesh.RootMotionMode = 1;
    DeathImpl.Init(self);
    FFImpl.OwningPawn = self;
    MImpl.OwningPawn = self;
    nextOIRActivityPacket.oirOwner = none;
    nextOIRActivityPacket.ActivityName = 'None';
    nextOIRActivityPacket.activityPose = 'None';
    nextOIRActivityPacket.TransitionRateScale = 1.0000000;
    super.PostBeginPlay();
    SetPhysics(1);
    // End:0xEF
    if(!bStasisPooling)
    {
        InitDetachableBodyPartSkelControls();
    }
    SetupBot();
    InitFeetData();
    DropToFloor();
    //return;    
}

simulated event PostWakeup()
{
    InitDetachableBodyPartSkelControls();
    //return;    
}

simulated function InitDetachableBodyPartSkelControls()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x144 [Loop If]
    if(I < DetachableBodyParts.Length)
    {
        DetachableBodyParts[I].BoneControl = SkelControlSingleBone(Mesh.FindSkelControl(DetachableBodyParts[I].BoneControlName));
        // End:0x13A
        if(DetachableBodyParts[I].BoneControl != none)
        {
            DetachableBodyParts[I].BoneControl.bCanBeLOD = false;
            // End:0xD2
            if(DetachableBodyParts[I].bCachedDetached)
            {
                DetachableBodyParts[I].BoneControl.BoneScale = 0.0000000;                
            }
            else
            {
                DetachableBodyParts[I].BoneControl.BoneScale = 1.0000000;
            }
            DetachableBodyParts[I].BoneControl.ControlStrength = 1.0000000;
            DetachableBodyParts[I].BoneControl.SetSkelControlActive(true);
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated function AssignHeadMesh()
{
    local int I;
    local float rand_num;

    // End:0x92
    if(HeadSkeletalMesh == none)
    {
        rand_num = FRand();
        I = 0;
        J0x1A:

        // End:0x92 [Loop If]
        if(I < RandomHeadMeshes.Length)
        {
            rand_num -= RandomHeadMeshes[I].Freq;
            // End:0x88
            if((rand_num <= 0.0000000) || (I + 1) == RandomHeadMeshes.Length)
            {
                HeadSkeletalMesh = RandomHeadMeshes[I].Mesh;
                // [Explicit Break]
                goto J0x92;
            }
            I++;
            // [Loop Continue]
            goto J0x1A;
        }
    }
    J0x92:

    //return;    
}

simulated function AssignGearMesh()
{
    GearSkeletalMesh = GearInfo.Mesh;
    //return;    
}

simulated function AssignChildrenMeshes()
{
    AssignHeadMesh();
    AssignGearMesh();
    //return;    
}

simulated event StartCrouch(float HeightAdjust)
{
    local Vector Delta;

    super(Pawn).StartCrouch(HeightAdjust);
    // End:0x3F
    if(ActiveOIR.m_bPawnIsAttached)
    {
        SetCollisionSize(ActiveOIR.OIRCollideWorldRadius, default.CylinderComponent.CollisionHeight);        
    }
    else
    {
        Delta = vect(0.0000000, 0.0000000, 0.0000000);
        Delta.Z = -HeightAdjust;
        Move(Delta);
    }
    //return;    
}

simulated event Vector GetPawnViewLocation()
{
    return GetPawnViewLocationNative();
    //return ReturnValue;    
}

simulated event Rotator GetViewRotation()
{
    return GetViewRotationNative();
    //return ReturnValue;    
}

function AdjustDamage(out int inDamage, out Vector Momentum, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo)
{
    super(MOHAPawn).AdjustDamage(inDamage, Momentum, InstigatedBy, HitLocation, DamageType, HitInfo);
    Momentum = vect(0.0000000, 0.0000000, 0.0000000);
    //return;    
}

simulated function bool AdjustDamageHeadShot(out int inDamage, optional TraceHitInfo HitInfo)
{
    // End:0x5C
    if((HitInfo.BoneName != 'None') && Class'MOHAUtilities'.static.IsParentedByBone(Mesh, HitInfo.BoneName, HeadShotBone))
    {
        inDamage = Health;
        return true;
    }
    return false;
    //return ReturnValue;    
}

function LogMissingTransitions(Canvas Canvas)
{
    local int I;

    Canvas.SetPos(float(Canvas.SizeX / 20), float(Canvas.SizeY / 4));
    Canvas.SetDrawColor(byte(255), byte(255), byte(255), byte(255));
    Canvas.__NFUN_465__("Missing Transitions:");
    I = 0;
    J0x81:

    // End:0xB4 [Loop If]
    if(I < MissingTransitions.Length)
    {
        Canvas.__NFUN_465__(MissingTransitions[I]);
        I++;
        // [Loop Continue]
        goto J0x81;
    }
    //return;    
}

function DrawGuard(Canvas Canvas)
{
    local Vector pos;
    local Controller localController;

    // End:0x0D
    if(Health <= 0)
    {
        return;
    }
    // End:0x41
    if((Controller == none) && Owner != none)
    {
        localController = Pawn(Owner).Controller;        
    }
    else
    {
        localController = Controller;
    }
    // End:0x7A
    if((KynapseAIController(localController) != none) && KynapseAIController(localController).bIgnoreAffordance == false)
    {
        return;
    }
    pos = Canvas.Project(Location + ((GetCollisionHeight()) * vect(0.0000000, 0.0000000, 1.1000000)));
    Canvas.SetDrawColor(byte(255), 0, 0);
    Canvas.SetPos(pos.X, pos.Y);
    Canvas.__NFUN_465__("GUARD");
    // End:0x1DC
    if(LeashVolume != none)
    {
        // End:0x1B5
        if(LeashVolume.BrushComponent != none)
        {
            DrawDebugBox(LeashVolume.BrushComponent.Bounds.Origin, LeashVolume.BrushComponent.Bounds.BoxExtent, byte(255), byte(255), 0);
            DrawDebugLine(Location, LeashVolume.BrushComponent.Bounds.Origin, byte(255), byte(255), 0);            
        }
        else
        {
            DrawDebugLine(Location, LeashVolume.Location, byte(255), byte(255), 0);
        }        
    }
    else
    {
        // End:0x22E
        if(fLeashRadius > float(0))
        {
            DrawDebugCircle(vLeashHome, vect(0.0000000, 0.0000000, 1.0000000), fLeashRadius, 16, byte(255), byte(255), 0);
            DrawDebugLine(Location, vLeashHome, byte(255), byte(255), 0);
        }
    }
    //return;    
}

function SetupBot()
{
    // End:0x15
    if(Controller == none)
    {
        SpawnDefaultController();
    }
    AddDefaultInventory();
    ControllerSpecificInit();
    //return;    
}

function ControllerSpecificInit()
{
    local KynapseAIController kaic;

    // End:0x1C
    if(VSize(vLeashHome) < 0.0500000)
    {
        vLeashHome = Location;
    }
    UpdateLeash();
    kaic = KynapseAIController(Controller);
    // End:0x6E
    if(kaic != none)
    {
        kaic.IdleCoverActor = IdleCoverActor;
        kaic.fGrenadeGravityMultiplier = GrenadeProjectileClass.default.CustomGravityScale;
    }
    //return;    
}

function NotifyAttachedSpawnerOfDeath(optional bool bKilledByNPC = false)
{
    local editinline SpawneeComponent Comp;

    // End:0x42
    foreach ComponentList(Class'EAKynapse.SpawneeComponent', Comp)
    {
        Comp.Died(bKilledByNPC);
        Comp.OwningSpawner = none;        
    }    
    //return;    
}

function TossWeapon(Weapon Weap, optional Vector ForceVelocity)
{
    //return;    
}

function CleanupOnDeathOrDestroy(optional bool bKilledByNPC = false)
{
    local Controller localController;

    // End:0x39
    if((Controller == none) && Owner != none)
    {
        localController = Pawn(Owner).Controller;        
    }
    else
    {
        localController = Controller;
    }
    // End:0xDF
    if(localController != none)
    {
        // End:0x93
        if(MOHAAIController(localController).GetMountedGun() != none)
        {
            MOHAAIController(localController).GetMountedGun().GunnerDied();
        }
        KynapseAIController(localController).ABSS.TripNamedScriptEvent('PrePawnDied');
        KynapseAIController(localController).ABSS.TripNamedScriptEvent('PawnDied');
    }
    NotifyAttachedSpawnerOfDeath(bKilledByNPC);
    RemoveSelfFromBeadList();
    //return;    
}

simulated event Destroyed()
{
    CleanupOnDeathOrDestroy();
    super(MOHAPawn).Destroyed();
    //return;    
}

event EncroachedBy(Actor Other)
{
    //return;    
}

function CheckForForcedRagdoll(class<DamageType> DamageType, MOHAAIController C)
{
    // End:0x1A
    if(ClassIsChildOf(DamageType, Class'MOHAExplosiveDamageType'))
    {
        OnThrownRagdoll();
    }
    // End:0x27
    if(C == none)
    {
        return;
    }
    // End:0x6E
    if((C.GetCurrentCoverNode() != none) && C.GetCurrentCoverNode().IsReady())
    {
        RagdollThrowActivated = true;
    }
    //return;    
}

event bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    local bool retval;
    local MOHAAIPawn AIPawn;
    local MOHAPlayerPawn PPawn;
    local Controller localController;

    // End:0x27
    if(Controller == none)
    {
        localController = Pawn(Owner).Controller;        
    }
    else
    {
        localController = Controller;
    }
    // End:0x5F
    if(MOHAInventoryManager(InvManager) != none)
    {
        MOHAInventoryManager(InvManager).DropRandomPickup(Killer);
    }
    CheckForForcedRagdoll(DamageType, MOHAAIController(localController));
    CleanupOnDeathOrDestroy((Killer != none) && Killer.IsA('MOHAAIController'));
    // End:0x213
    if(localController.IsA('MOHAAIController'))
    {
        DeathStimulus = new (self) Class'EAKynapse.StimulusComponent';
        AttachComponent(DeathStimulus);
        DeathStimulus.SetProxyActor(self);
        DeathStimulus.AttachSender('TeamDeath', 'TeamDeath', Location, rot(0, 0, 0),, 0, true, true);
        DeathStimulus.PushStimuliSenderParamInt('TeamDeath', 'Team', MOHAAIController(localController).TeamIndex);
        DeathStimulus.AttachSender('BulletImpact', 'NearbyDeath', vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0),,, true);
        DeathStimulus.PushStimuliSenderParamFloat('BulletImpact', 'threat', 10.0000000);
        DeathStimulus.PushStimuliSenderParamInt('BulletImpact', 'Team', 1 - MOHAAIController(localController).TeamIndex);
        CreatePlayerKillStimulus(MOHAPlayerPawn(Killer.Pawn));
    }
    // End:0x3C6
    if(none != Killer)
    {
        AIPawn = MOHAAIPawn(Killer.Pawn);
        PPawn = MOHAPlayerPawn(Killer.Pawn);
        // End:0x306
        if(none != AIPawn)
        {
            BroadcastStimulus("MOHA_CC.Stimuli.KilledEnemy", AIPawn, 10000.0000000, AIPawn.CCP.Nationality);
            Class'Engine.JuiceSubsystem'.static.LevelEvent("Gameplay", "NPCDeath", "AI", int(self.CCP.Nationality), float(AIPawn.CCP.Nationality), "", HitLocation);            
        }
        else
        {
            // End:0x3C6
            if(none != PPawn)
            {
                // End:0x362
                if((localController != none) && MOHAAIController(localController) != none)
                {
                    MOHAPlayerController(PPawn.Controller).AddEngagedAffordance(MOHAAIController(localController).CurrentAffordanceNode);
                }
                NotifyPlayerStats(Killer, DamageType);
                Class'Engine.JuiceSubsystem'.static.LevelEvent("Gameplay", "NPCDeath", "Player", int(self.CCP.Nationality), 1.0000000, "", HitLocation);
            }
        }
    }
    SpawnDeathEffects(HitLocation);
    RemoveSelfFromBeadList();
    retval = super(MOHAPawn).Died(Killer, DamageType, HitLocation);
    // End:0x42C
    if(PlayingDeathYellState == 1)
    {
        OnCCStimulus("MOHA_CC.Stimuli.Death2", self);        
    }
    else
    {
        // End:0x462
        if(ClassIsChildOf(DamageType, Class'MOHAExplosiveDamageType'))
        {
            OnCCStimulus("MOHA_CC.Stimuli.Death3", self);            
        }
        else
        {
            OnCCStimulus("MOHA_CC.Stimuli.Death1", self);
        }
    }
    return retval;
    //return ReturnValue;    
}

simulated function CreatePlayerKillStimulus(MOHAPlayerPawn PP)
{
    local float killRange;
    local int stimulusIndex, MaxIndex;
    local name senderId;
    local float threatTime;

    // End:0x0D
    if(PP == none)
    {
        return;
    }
    killRange = VSize(Location - PP.Location);
    MaxIndex = Class'EAKynapse.AxonStimuliTableRegistrant'.static.GetNumPlayerKillSenders();
    stimulusIndex = int(killRange / 500.0000000);
    // End:0x71
    if(stimulusIndex > MaxIndex)
    {
        stimulusIndex = MaxIndex;
    }
    senderId = name("PlayerKill" $ string(stimulusIndex));
    threatTime = 5.0000000;
    // End:0xE2
    if(EALAWeapon(PP.Weapon) != none)
    {
        threatTime = EALAWeapon(PP.Weapon).GetPlayerShootThreatTime() + float(stimulusIndex);
    }
    DeathStimulus.AttachSender('PlayerKill', senderId, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0),,, true);
    DeathStimulus.PushStimuliSenderParamFloat('PlayerShoot', 'threatTime', threatTime);
    //return;    
}

simulated function float ApplyHitReactionScalar(Controller InstigatedBy, bool bKillingBlow)
{
    // End:0x0F
    if(bKillingBlow)
    {
        return 1.0000000;
    }
    // End:0x27
    if(InstigatedBy.bIsPlayer)
    {
        return 1.0000000;
    }
    // End:0x36
    if(IsMeleeEnabled)
    {
        return 0.0000000;
    }
    return 0.5000000;
    //return ReturnValue;    
}

simulated function OnThrownRagdoll()
{
    PlayingDeathYellState = 1;
    //return;    
}

function bool IsPlayingDeathYell()
{
    return PlayingDeathYellState > 0;
    //return ReturnValue;    
}

function OnLimpRagdollImpact()
{
    // End:0x3B
    if(PlayingDeathYellState == 1)
    {
        PlayingDeathYellState = 2;
        OnCCStimulus("MOHA_CC.Stimuli.DeathImpact", self);
    }
    //return;    
}

function GoLimpRagdoll()
{
    // End:0x26
    if(!bNoRagdoll)
    {
        MOHARagdollSkelComponent(Mesh).GoTerminalRagdoll(1);
    }
    //return;    
}

function NotifyPlayerStats(Controller Killer, class<DamageType> DamageType)
{
    local MOHAPlayerController PlayerController;
    local editinline MOHAPlayerStatsComponent playerStats;
    local class<MOHAExplosiveDamageType> ExplosiveDamage;

    PlayerController = MOHAPlayerController(Killer);
    // End:0x1D
    if(PlayerController == none)
    {
        return;
    }
    playerStats = PlayerController.playerStats;
    // End:0x3E
    if(playerStats == none)
    {
        return;
    }
    // End:0x86
    if(ClassIsChildOf(DamageType, Class'MOHAExplosiveDamageType'))
    {
        ExplosiveDamage = class<MOHAExplosiveDamageType>(DamageType);
        playerStats.OnExplosiveKill(ExplosiveDamage.default.WeaponType, ExplosiveDamage);
        return;
    }
    // End:0xFA
    if(ClassIsChildOf(DamageType, Class'MOHAMeleeDamageType'))
    {
        playerStats.OnMeleeKill(EALAWeapon(PlayerController.Pawn.Weapon).WeaponType, EALAWeapon(PlayerController.Pawn.Weapon).WeaponClass, DamageType);
        return;
    }
    MOHAPlayerController(Killer).OnWeaponHit(EALAWeapon(PlayerController.Pawn.Weapon).WeaponType, LastHitRigdBodyBoneName, self, DamageType, true);
    PraisePlayer(PlayerController);
    //return;    
}

function PraisePlayer(MOHAPlayerController PlayerController)
{
    local float praiseAIDpct;
    local bool bHeadShot;
    local Vector moveDir;

    bHeadShot = false;
    // End:0x45
    if(LastHitRigdBodyId == MOHARagdollSkelComponent(Mesh).GetRigidBodyID(HeadShotBone))
    {
        bHeadShot = true;
        praiseAIDpct = 0.1000000;        
    }
    else
    {
        praiseAIDpct = 0.0500000;
    }
    // End:0xA0
    if(VSize(Velocity) > 100.0000000)
    {
        praiseAIDpct *= 5.0000000;
        moveDir = Normal(Velocity);
        praiseAIDpct *= (float(2) - Abs(moveDir Dot Vector(PlayerController.Rotation)));
    }
    // End:0x123
    if(FRand() <= praiseAIDpct)
    {
        // End:0xF0
        if(bHeadShot)
        {
            BroadcastStimulus("MOHA_CC.Stimuli.PraisePlayerHeadShot", self, 10000.0000000, 1);            
        }
        else
        {
            BroadcastStimulus("MOHA_CC.Stimuli.PraiseForPlayer", self, 10000.0000000, 1);
        }
    }
    //return;    
}

function SpawnDeathEffects(Vector HitLocation)
{
    local Vector KludgeHitLocation, HitDirection;
    local MOHAExplodeEmitter DeathFXEmitter;

    HitDirection = Location - HitLocation;
    HitDirection.Z = 0.0000000;
    HitDirection = Normal(HitDirection);
    KludgeHitLocation = HitLocation + (HitDirection * 20.0000000);
    // End:0x8F
    if(DeathParticleSystemTemplate != none)
    {
        DeathFXEmitter = __NFUN_278__(Class'MOHAExplodeEmitter',,, KludgeHitLocation, Rotator(HitDirection));
        DeathFXEmitter.SetTemplate(DeathParticleSystemTemplate, true);
    }
    //return;    
}

function CCDamageResponse(int Damage, Controller InstigatedBy, Vector HitLocation)
{
    local float NewHealth, MaxHealth, HealthPct;
    local KynapseAIController localController;
    local CCStimulus CCS;

    // End:0x2C
    if(Controller == none)
    {
        localController = KynapseAIController(Pawn(Owner).Controller);        
    }
    else
    {
        localController = KynapseAIController(Controller);
    }
    // End:0x105
    if((InstigatedBy != none) && InstigatedBy.IsA('PlayerController'))
    {
        // End:0x105
        if(localController.TeamIndex == 0)
        {
            CCS.StimulusType = CCStimulusType(DynamicLoadObject("MOHA_CC.Stimuli.FriendlyFire", Class'CCStimulusType', false));
            CCS.SourceActor = self;
            CCS.bUseSourceLocation = true;
            CCS.SourceLocation = HitLocation;
            CCP.OnStimulus(CCS);
            return;
        }
    }
    NewHealth = float(Health - Damage);
    MaxHealth = float(Class'MOHAAIPawn'.default.Health);
    // End:0x153
    if(MaxHealth > 0.0010000)
    {
        HealthPct = NewHealth / MaxHealth;        
    }
    else
    {
        HealthPct = 0.0000000;
    }
    // End:0x1CC
    if((Damage != 0) && NewHealth > float(0))
    {
        // End:0x1AB
        if(HealthPct <= 0.4000000)
        {
            OnCCStimulus("MOHA_CC.Stimuli.Hit2", self);            
        }
        else
        {
            OnCCStimulus("MOHA_CC.Stimuli.Hit1", self);
        }
    }
    //return;    
}

simulated function bool ShouldUseHitReactions(class<DamageType> DamageType)
{
    local MOHAAIController localController;

    localController = MOHAAIController(((Controller == none) ? Pawn(Owner).Controller : Controller));
    // End:0x5B
    if(!bNoHitReactions && localController.AiLod_IsAwake)
    {
        return super(MOHAPawn).ShouldUseHitReactions(DamageType);
    }
    return false;
    //return ReturnValue;    
}

function TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local int AdjustedDamage;
    local Vector AdjustedMomentum;

    // End:0xCF
    if(!bInvincible)
    {
        AdjustedDamage = Damage;
        AdjustedMomentum = Momentum;
        AdjustDamage(AdjustedDamage, AdjustedMomentum, InstigatedBy, HitLocation, DamageType, HitInfo);
        PostDamage_ImpartHitMomentum(HitLocation, Momentum, DamageType, HitInfo, AdjustedDamage, InstigatedBy);
        CCDamageResponse(AdjustedDamage, InstigatedBy, HitLocation);
        // End:0xCF
        if(!bDebugTakeNoDamage)
        {
            OnTakeDamage(Damage);
            super(MOHAPawn).TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
        }
    }
    // End:0xFB
    if(bDetachableGear)
    {
        CheckForDetachedBodyPart(HitInfo.BoneName, InstigatedBy, DamageType);
    }
    // End:0x12A
    if((bDebugHealth && InstigatedBy != none) && InstigatedBy.IsA('MOHAPlayerController'))
    {
    }
    //return;    
}

simulated function PreDamage_ImpartHitMomentum(Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Controller InstigatedBy)
{
    //return;    
}

simulated function TakeRadiusDamage(Controller InstigatedBy, float BaseDamage, float DamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser)
{
    local float ColRadius, ColHeight, damageScale, dist;
    local Vector Dir;
    local Controller localController;
    local int AdjustedDamage;
    local Vector AdjustedMomentum;

    GetBoundingCylinder(ColRadius, ColHeight);
    Dir = Location - HurtOrigin;
    dist = VSize(Dir);
    Dir = Normal(Dir);
    // End:0x57
    if(bFullDamage)
    {
        damageScale = 1.0000000;        
    }
    else
    {
        dist = FClamp(dist - ColRadius, 0.0000000, DamageRadius);
        damageScale = 1.0000000 - (dist / DamageRadius);
    }
    // End:0x209
    if(damageScale > 0.0000000)
    {
        // End:0xC4
        if(Controller == none)
        {
            localController = Pawn(Owner).Controller;            
        }
        else
        {
            localController = Controller;
        }
        // End:0x1AD
        if((!bNoHitReactions && MOHAAIController(localController).AiLod_IsAwake) && ClassIsChildOf(DamageType, Class'MOHAExplosiveDamageType'))
        {
            AdjustedDamage = int(damageScale * BaseDamage);
            AdjustedMomentum = (damageScale * Momentum) * Dir;
            AdjustDamage(AdjustedDamage, AdjustedMomentum, InstigatedBy, HurtOrigin, DamageType);
            // End:0x1AD
            if((AdjustedDamage > 0) && AdjustedDamage >= Health)
            {
                MOHARagdollSkelComponent(Mesh).AddRagdollRadialImpulse(HurtOrigin, Momentum, DamageType, DamageRadius * ExplosionMomentumRadiusMult, !bFullDamage);
            }
        }
        TakeDamage(int(damageScale * BaseDamage), InstigatedBy, Location - ((0.5000000 * (ColHeight + ColRadius)) * Dir), (damageScale * Momentum) * Dir, DamageType,, DamageCauser);
    }
    //return;    
}

simulated function CheckForDetachedBodyPart(name DamagedBoneName, Controller InstigatedBy, class<DamageType> DamageType)
{
    local int I;
    local bool bMatchingBoneName, bExplosiveDetach, bInstigatedByPlayer;

    I = 0;
    J0x07:

    // End:0x262 [Loop If]
    if(I < DetachableBodyParts.Length)
    {
        bMatchingBoneName = (DamagedBoneName != 'None') && (DetachableBodyParts[I].BoneName == DamagedBoneName) || DetachableBodyParts[I].SecondaryBoneName == DamagedBoneName;
        bExplosiveDetach = ClassIsChildOf(DamageType, Class'MOHAExplosiveDamageType') && DetachableBodyParts[I].bDetachOnExplosion;
        // End:0x258
        if(((bMatchingBoneName || bExplosiveDetach) && DetachableBodyParts[I].BoneControl != none) && DetachableBodyParts[I].BoneControl.BoneScale != float(0))
        {
            // End:0x16A
            if(DetachableBodyParts[I].Probability >= FRand())
            {
                DetachableBodyParts[I].BoneControl.BoneScale = 0.0000000;
                DetachableBodyParts[I].bCachedDetached = true;
                SpawnDetachedBodyPart(DetachableBodyParts[I], InstigatedBy);
            }
            // End:0x258
            if((bMatchingBoneName && InstigatedBy != none) && DetachableBodyParts[I].Probability > 0.0000000)
            {
                bInstigatedByPlayer = (InstigatedBy != none) && InstigatedBy.IsA('PlayerController');
                // End:0x211
                if(bInstigatedByPlayer && DetachableBodyParts[I].HitSound_PC != none)
                {
                    PlaySound(DetachableBodyParts[I].HitSound_PC);
                    // [Explicit Continue]
                    goto J0x258;
                }
                // End:0x258
                if(!bInstigatedByPlayer && DetachableBodyParts[I].HitSound_NPC != none)
                {
                    PlaySound(DetachableBodyParts[I].HitSound_NPC);
                }
            }
        }
        J0x258:

        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated function SpawnDetachedBodyPart(DetachableBodyPartInfo BodyPartInfo, Controller InstigatedBy)
{
    local Actor DetachedBodyPartActor;
    local Rotator rSpawnRot;
    local Vector vPawnToBodyPart, vSpawnPos, vSpawnVelocity, vRotationAxis, X, Y,
	    Z;

    local MOHADetachedBodyPart DetachedBodyPart;
    local class<Actor> DetachedBodyPartClass;
    local float fRotationRate;

    DetachedBodyPartClass = BodyPartInfo.SpawnedBodyPartClass;
    fRotationRate = Lerp(BodyPartInfo.MinRotationRate, BodyPartInfo.MinRotationRate, FRand());
    vSpawnVelocity = VLerp(BodyPartInfo.MinSpawnVelocity, BodyPartInfo.MaxSpawnVelocity, FRand());
    rSpawnRot = Normalize(QuatToRotator(Mesh.GetBoneQuaternion(BodyPartInfo.BoneName)) + BodyPartInfo.rRotCorrection);
    vSpawnPos = Mesh.GetBoneLocation(BodyPartInfo.BoneName);
    DetachedBodyPartActor = __NFUN_278__(DetachedBodyPartClass, self,, vSpawnPos, rSpawnRot);
    // End:0x2FA
    if(((BodyPartInfo.SpawnedMesh != none) && DetachedBodyPartActor != none) && DetachedBodyPartActor.IsA('MOHADetachedBodyPart'))
    {
        DetachedBodyPart = MOHADetachedBodyPart(DetachedBodyPartActor);
        DetachedBodyPart.Mesh.SetStaticMesh(BodyPartInfo.SpawnedMesh);
        // End:0x1A7
        if((InstigatedBy != none) && InstigatedBy.Pawn != none)
        {
            vPawnToBodyPart = vSpawnPos - InstigatedBy.Pawn.Location;            
        }
        else
        {
            vPawnToBodyPart = vect(1.0000000, 0.0000000, 0.0000000);
        }
        vRotationAxis = Normal(vPawnToBodyPart);
        Class'MOHAUtilities'.static.AssignVector(vRotationAxis, -vRotationAxis.Y, vRotationAxis.X, 0.0000000);
        GetAxes(Rotator(vPawnToBodyPart), X, Y, Z);
        DetachedBodyPart.Velocity = ((Velocity + (vSpawnVelocity.X * X)) + (vSpawnVelocity.Y * Y)) + (vSpawnVelocity.Z * Z);
        DetachedBodyPart.Mesh.SetRBLinearVelocity(DetachedBodyPart.Velocity, false);
        DetachedBodyPart.Mesh.SetMaxRBAngularVelocity(fRotationRate);
        DetachedBodyPart.Mesh.SetRBAngularVelocity(vRotationAxis * fRotationRate, false);
        DetachedBodyPart.Mesh.WakeRigidBody();
    }
    //return;    
}

simulated function bool IsBodyPartAttached(name BodyPartBoneName)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x81 [Loop If]
    if(I < DetachableBodyParts.Length)
    {
        // End:0x77
        if((DetachableBodyParts[I].BoneName == BodyPartBoneName) && DetachableBodyParts[I].BoneControl != none)
        {
            return DetachableBodyParts[I].BoneControl.BoneScale != float(0);
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return true;
    //return ReturnValue;    
}

event bool HasHelmet()
{
    return IsBodyPartAttached('Helmet');
    //return ReturnValue;    
}

simulated function Tick(float DeltaTime)
{
    TickNative(DeltaTime);
    super(MOHAPawn).Tick(DeltaTime);
    //return;    
}

function DrawFFDebug()
{
    local Vector startDrawPos;

    startDrawPos = Location + vect(0.0000000, 0.0000000, -70.0000000);
    DrawDebugCoordinateSystem(startDrawPos, GetBaseAimRotationNative(MOHAAIController(Controller).GetPathablePosition()), 100.0000000);
    startDrawPos = startDrawPos + vect(0.0000000, 0.0000000, 35.0000000);
    DrawDebugCoordinateSystem(startDrawPos, Rotation, 100.0000000);
    //return;    
}

simulated event StartUsingMountedGun(MOHAMountedGun MG)
{
    local Controller localController;

    // End:0x27
    if(Controller == none)
    {
        localController = Pawn(Owner).Controller;        
    }
    else
    {
        localController = Controller;
    }
    KynapseAIController(localController).CancelBurst(false);
    //return;    
}

simulated event StopUsingMountedGun(MOHAMountedGun MG)
{
    local Controller localController;

    // End:0x27
    if(Controller == none)
    {
        localController = Pawn(Owner).Controller;        
    }
    else
    {
        localController = Controller;
    }
    KynapseAIController(localController).CancelBurst(false);
    //return;    
}

function SpawnDefaultController()
{
    // End:0x13
    if(bSpawnDefaultController)
    {
        SpawnKynapseAIController();
    }
    //return;    
}

function SpawnKynapseAIController()
{
    // End:0x0D
    if(Controller != none)
    {
        return;
    }
    // End:0x47
    if(KynapseControllerClass != none)
    {
        Controller = __NFUN_278__(KynapseControllerClass);
        KynapseAIController(Controller).bIgnoreAffordance = bIgnoreAffordance;
    }
    // End:0x67
    if(Controller != none)
    {
        Controller.Possess(self, false);
    }
    //return;    
}

event SetupActiveOIR()
{
    local OIRData oir;
    local int OIRManagerIndex;

    // DebugMode: 0
    assert(NotEqual_InterfaceInterface(nextOIRActivityPacket.oirOwner, OIROwnerInterface(none)));
    oir = nextOIRActivityPacket.oirOwner.GetOIRData();
    // End:0xB2
    if(bHasNewOIR)
    {
        // End:0xAF
        if(ActiveOIR.UseOIRPhysics() && EqualEqual_InterfaceInterface(nextOIRActivityPacket.oirOwner, OIROwnerInterface(FFImpl)))
        {
            oir.OIRPosition = GetGroundPosition(oir.OIRPosition);
        }        
    }
    else
    {
        oir.OIRPosition = ActiveOIR.Location;
        // End:0x10F
        if(EqualEqual_InterfaceInterface(nextOIRActivityPacket.oirOwner, OIROwnerInterface(FFImpl)))
        {
            FFImpl.Position = ActiveOIR.Location;
        }
    }
    ActiveOIR.Update(oir, nextOIRActivityPacket.oirOwner);
    ActiveOIR.SetCurrentActivity(nextOIRActivityPacket.ActivityName, nextOIRActivityPacket.activityPose, nextOIRActivityPacket.TransitionRateScale);
    // End:0x202
    if(Controller != none)
    {
        ActiveOIR.SetActivityDone(MOHAAIController(Controller).ActivityFinished);
        ActiveOIR.SetActivityFailed(MOHAAIController(Controller).OnActivityFailed);
        ActiveOIR.SetActivityStarted(MOHAAIController(Controller).ActivityStarted);        
    }
    else
    {
        // End:0x2D5
        if((Pawn(Owner) != none) && Pawn(Owner).Controller != none)
        {
            ActiveOIR.SetActivityDone(MOHAAIController(Pawn(Owner).Controller).ActivityFinished);
            ActiveOIR.SetActivityFailed(MOHAAIController(Pawn(Owner).Controller).OnActivityFailed);
            ActiveOIR.SetActivityStarted(MOHAAIController(Pawn(Owner).Controller).ActivityStarted);
        }
    }
    ActiveOIR.m_fEntryLength = 0.0000000;
    // End:0x319
    if(!ActiveOIR.bForceUseOIR)
    {
        ActiveOIR.DesiredOIREntry = ActiveOIR.1;        
    }
    else
    {
        ActiveOIR.DesiredOIREntry = ActiveOIR.0;
    }
    PlayByPostureOverride = ActiveOIR.OIRParent.GetHeightPostureOverride(ActiveOIR.GetCurrentActivityPose());
    OIRManagerIndex = ActiveOIR.m_OIRManagerNode.ConnectOIR();
    ActiveOIR.m_fEntryLength = ActiveOIR.m_OIRManagerNode.GetOIRDesiredEntryDistance(OIRManagerIndex);
    ActiveOIR.LockedBy = self;
    bPendingHasNewOIR = false;
    bHasNewOIR = false;
    //return;    
}

event GetNextOIRLocationAndRadius(out Vector oirLocation, out float oirRadius)
{
    // End:0x73
    if(NotEqual_InterfaceInterface(nextOIRActivityPacket.oirOwner, OIROwnerInterface(none)))
    {
        oirLocation = nextOIRActivityPacket.oirOwner.GetOIRData().OIRPosition;
        oirRadius = nextOIRActivityPacket.oirOwner.GetArrivedAtRadius();        
    }
    else
    {
        oirLocation = vect(0.0000000, 0.0000000, 0.0000000);
        oirRadius = -1.0000000;
    }
    //return;    
}

event ClearOIRParent()
{
    ActiveOIR.OIRParent = none;
    //return;    
}

function AddDefaultInventory()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x66 [Loop If]
    if(I < DefaultWeaponLoadout.Length)
    {
        // End:0x5C
        if(FindInventoryType(DefaultWeaponLoadout[I].WeaponClass) == none)
        {
            CreateInventory(DefaultWeaponLoadout[I].WeaponClass, I > 0);
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function ConsumeAmmo(EALAWeapon Weap, byte FireModeNum)
{
    //return;    
}

simulated function Rotator GetPostAdjustedAimFor(Weapon W, Vector StartFireLoc, Rotator DesiredAimRot, Rotator PostAdjustAimRot)
{
    // End:0x23
    if((Controller == none) || int(Role) < int(ROLE_Authority))
    {
        return PostAdjustAimRot;
    }
    return KynapseAIController(Controller).GetPostAdjustedAimFor(W, StartFireLoc, DesiredAimRot, PostAdjustAimRot);
    //return ReturnValue;    
}

simulated function Rotator GetRotBoneToBone(SkeletalMeshComponent fromMesh, name fromBone, SkeletalMeshComponent toMesh, name toBone)
{
    return Rotator(Normal(fromMesh.GetBoneLocation(fromBone) - toMesh.GetBoneLocation(toBone)));
    //return ReturnValue;    
}

singular simulated function Rotator GetBaseAimRotation()
{
    return GetBaseAimRotationNative(GetAimFromLocation());
    //return ReturnValue;    
}

simulated function Vector GetWeaponStartTraceLocation(optional Weapon CurrentWeapon)
{
    local Vector vPos;

    // End:0x22
    if(!GetWeaponStartTraceLocationNative(vPos, CurrentWeapon))
    {
        return super(MOHAPawn).GetWeaponStartTraceLocation(CurrentWeapon);
    }
    return vPos;
    //return ReturnValue;    
}

function bool BotFire(bool bFinished)
{
    super(MOHAPawn).BotFire(bFinished);
    return true;
    //return ReturnValue;    
}

simulated event PlayImpactEffects(MOHAPhysicalMaterialProperty.EImpactType ImpactType, name BoneName)
{
    // End:0x26
    if(BoneName == 'None')
    {
        PlayFootstep(ImpactType);        
    }
    else
    {
        PlayFootstep(ImpactType, Mesh.GetBoneLocation(BoneName));
    }
    //return;    
}

simulated function StepWalk_NPC()
{
    PlayFootstep(2);
    //return;    
}

simulated function StepSprint_NPC()
{
    PlayFootstep(3);
    //return;    
}

simulated function StepStop_NPC()
{
    PlayFootstep(4);
    //return;    
}

simulated function StepPivot_NPC()
{
    PlayFootstep(5);
    //return;    
}

simulated function StepJump_NPC()
{
    PlayFootstep(6);
    //return;    
}

simulated function StepLand_NPC()
{
    PlayFootstep(7);
    //return;    
}

simulated function StepStairUp_NPC()
{
    PlayFootstep(8);
    //return;    
}

simulated function StepStairDown_NPC()
{
    PlayFootstep(9);
    //return;    
}

simulated function CrouchWalk_NPC()
{
    PlayFootstep(10);
    //return;    
}

simulated function Crawl_NPC()
{
    PlayFootstep(11);
    //return;    
}

simulated function ClimbLadderFeet()
{
    PlayFootstep(12);
    //return;    
}

simulated function BodyFallSml()
{
    PlayFootstep(14);
    //return;    
}

simulated function BodyFallMed()
{
    PlayFootstep(15);
    //return;    
}

simulated function BodyFallHard()
{
    PlayFootstep(16);
    //return;    
}

simulated function HandThump()
{
    PlayFootstep(17);
    //return;    
}

simulated function LegThump()
{
    PlayFootstep(18);
    //return;    
}

simulated function HelmetThump()
{
    PlayFootstep(19);
    //return;    
}

simulated function Vector GetGrenadeThrowPosition(name ThrowingHandBoneName)
{
    local KynapseAIController kaic;

    kaic = KynapseAIController(Controller);
    // End:0x88
    if(kaic != none)
    {
        // End:0x88
        if((kaic.GetCurrentCoverNode() != none) && kaic.GetCurrentCoverNode().IsReady())
        {
            return kaic.GetCurrentCoverNode().GetShootPosition() + kaic.vGrenadeSpawnOffset;
        }
    }
    return Mesh.GetBoneLocation(ThrowingHandBoneName);
    //return ReturnValue;    
}

simulated function float GetGrenadeFuse()
{
    local KynapseAIController kaic;

    kaic = KynapseAIController(Controller);
    // End:0x3E
    if(kaic != none)
    {
        return RandRange(kaic.fDesiredGrenadeFuseTimeMin, kaic.fDesiredGrenadeFuseTimeMax);
    }
    return 5.0000000;
    //return ReturnValue;    
}

simulated function ThrowGrenade(name ThrowingHandBoneName)
{
    local Projectile SpawnedProjectile;
    local MOHAProj_Explosive SpawnedExplosive;
    local Vector vSpawnLoc, vTargetDir;
    local float fFuse;

    // End:0x1B7
    if(int(Role) == int(ROLE_Authority))
    {
        vSpawnLoc = GetGrenadeThrowPosition(ThrowingHandBoneName);
        vTargetDir = GrenadeThrowVelocity;
        SpawnedProjectile = __NFUN_278__(GrenadeProjectileClass,,, vSpawnLoc);
        // End:0x1B7
        if(SpawnedProjectile != none)
        {
            MOHAProj_Explosive(SpawnedProjectile).bounceDamping = 0.3000000;
            SpawnedProjectile.SetCollision(false, false, false);
            SpawnedProjectile.Speed = VSize(GrenadeThrowVelocity);
            SpawnedProjectile.RotationRate.Pitch = 125000;
            SpawnedProjectile.Init(Normal(vTargetDir));
            fFuse = GetGrenadeFuse();
            SpawnedProjectile.SetTimer(fFuse);
            // End:0x123
            if(bThrowDudGrenades)
            {
                SpawnedExplosive = MOHAProj_Explosive(SpawnedProjectile);
                // End:0x123
                if(none != SpawnedExplosive)
                {
                    SpawnedExplosive.bDud = true;
                }
            }
            MOHAAIController(Controller).Stimulus.AttachSender('GrenadeThrown', 'GrenadeThrown', vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0),, 0, true);
            MOHAAIController(Controller).Stimulus.PushStimuliSenderParamInt('GrenadeThrown', 'Team', MOHAAIController(Controller).TeamIndex);
        }
    }
    //return;    
}

function GetMeleeTarget(out ImpactInfo out_HitImpact, float Range)
{
    local MOHAPawn PotentialTarget, BestTarget;
    local Vector vForward, HitLocation, HitNormal;
    local TraceHitInfo HitInfo;
    local float rangeSq;
    local Vector vSource, vEnd;

    rangeSq = Range * Range;
    vForward = Vector(Rotation);
    // End:0xDC
    foreach WorldInfo.AllPawns(Class'MOHAPawn', PotentialTarget)
    {
        // End:0x4C
        if(PotentialTarget == none)
        {
            continue;            
        }
        // End:0x62
        if(IsTeammate(PotentialTarget))
        {
            continue;            
        }
        // End:0x8C
        if((vForward Dot (PotentialTarget.Location - Location)) < -0.5000000)
        {
            continue;            
        }
        // End:0xB5
        if(VSizeSq(PotentialTarget.Location - Location) > rangeSq)
        {
            continue;            
        }
        BestTarget = PotentialTarget;
        // End:0xDB
        if(PotentialTarget == Controller.Focus)
        {
            // End:0xDC
            break;
        }        
    }    
    // End:0x272
    if(BestTarget != none)
    {
        vSource = Mesh.GetBoneLocation('Neck');
        vEnd = BestTarget.Mesh.GetBoneLocation('Neck');
        out_HitImpact.HitActor = MeleeTrace(HitLocation, HitNormal, HitInfo, vEnd, vSource, vect(0.0000000, 0.0000000, 0.0000000));
        out_HitImpact.HitLocation = HitLocation;
        out_HitImpact.HitNormal = HitNormal;
        out_HitImpact.RayDir = Normal((BestTarget.Location - vect(0.0000000, 0.0000000, 30.0000000)) - Location);
        out_HitImpact.HitInfo = HitInfo;
        // End:0x272
        if(out_HitImpact.HitActor != BestTarget)
        {
            // End:0x221
            if(MOHAAIPawn(BestTarget) == none)
            {
                out_HitImpact.HitActor = none;                
            }
            else
            {
                out_HitImpact.HitActor = BestTarget;
                out_HitImpact.HitLocation = Location;
                out_HitImpact.HitNormal = Normal(Location - BestTarget.Location);
            }
        }
    }
    return;
    //return;    
}

simulated function bool PerformMelee(out ImpactInfo out_HitImpact)
{
    GetMeleeTarget(out_HitImpact, 250.0000000);
    return out_HitImpact.HitActor != none;
    //return ReturnValue;    
}

function AttachMountedGun()
{
    local Controller localController;

    // End:0x2C
    if(Controller == none)
    {
        localController = KynapseAIController(Pawn(Owner).Controller);        
    }
    else
    {
        localController = KynapseAIController(Controller);
    }
    // End:0x81
    if(MOHAAIController(localController).GetMountedGun() != none)
    {
        MOHAAIController(localController).GetMountedGun().AttachToNPC(self);
    }
    //return;    
}

function DetachMountedGun()
{
    local Controller localController;

    // End:0x2C
    if(Controller == none)
    {
        localController = KynapseAIController(Pawn(Owner).Controller);        
    }
    else
    {
        localController = KynapseAIController(Controller);
    }
    // End:0x81
    if(MOHAAIController(localController).GetMountedGun() != none)
    {
        MOHAAIController(localController).GetMountedGun().DetachFromNPC(self);
    }
    //return;    
}

function OnSetAIPawnParams(SeqAct_SetAIPawnParams Action)
{
    bInvincible = Action.bInvincible;
    bNoHitReactions = Action.bNoHitReactions;
    bNoRagdoll = Action.bNoRagdoll;
    NPCtoNPCDamageMult = Action.NPCtoNPCDamageMult;
    bIgnoreAffordance = Action.bIgnoreAffordance;
    // End:0xB4
    if(KynapseAIController(Controller) != none)
    {
        KynapseAIController(Controller).bIgnoreAffordance = Action.bIgnoreAffordance;
        KynapseAIController(Controller).UpdateKynapseParams();
    }
    //return;    
}

function bool IsEngagedInOIR()
{
    return ((none != ActiveOIR) && ActiveOIR.m_bPawnIsAttached) && ActiveOIR.m_ActivityNode.NodeTotalWeight == 1.0000000;
    //return ReturnValue;    
}

function bool IsEngagedInStationaryOIR()
{
    return (IsEngagedInOIR()) && !ActiveOIR.OIRParent.IsA('MeleeOIRImpl');
    //return ReturnValue;    
}

function EnableLightEnvironment(bool bEnabled)
{
    // End:0x25
    if(bEnabled)
    {
        Mesh.SetLightEnvironment(self.LightEnvComponent);        
    }
    else
    {
        Mesh.SetLightEnvironment(none);
    }
    //return;    
}

function ReturnToSpawner()
{
    bStasis = true;
    // End:0x55
    if(!IsTimerActive('DeSpawn') && Class'MOHAUtilities'.static.GetAiLodIsLong(self) == false)
    {
        bStasis = false;
        SetTimer(0.0010000,, 'DeSpawn');
    }
    //return;    
}

function DeSpawn()
{
    local editinline SpawneeComponent Comp;

    // End:0x2B
    foreach ComponentList(Class'EAKynapse.SpawneeComponent', Comp)
    {
        Comp.DeSpawn(self);
        // End:0x2B
        break;        
    }    
    Destroy();
    //return;    
}

function bool KillMeImHere()
{
    bStasis = true;
    // End:0x57
    if(!IsTimerActive('DelayedKill') && Class'MOHAUtilities'.static.GetAiLodIsLong(self) == false)
    {
        bStasis = false;
        SetTimer(0.0010000,, 'DelayedKill');
        return true;
    }
    return false;
    //return ReturnValue;    
}

function DelayedKill()
{
    Died(none, Class'Engine.DmgType_Suicided', Location);
    //return;    
}

function TranslateCollisionForVaultOver()
{
    CylinderComponent.SetAbsolute(true, true);
    CylinderComponent.SetTranslation(ActiveOIR.vAlternateExitFinalPosition);
    //return;    
}

event ReturnCollisionAfterVaultOver()
{
    CylinderComponent.SetAbsolute(false, false);
    CylinderComponent.SetTranslation(vect(0.0000000, 0.0000000, 0.0000000));
    //return;    
}

function bool ShouldFireWeaponAttachment()
{
    local MOHAScriptAIController localController;

    // End:0x37
    if(Controller == none)
    {
        // End:0x34
        if(Owner != none)
        {
            localController = MOHAScriptAIController(Pawn(Owner).Controller);
        }        
    }
    else
    {
        localController = MOHAScriptAIController(Controller);
    }
    // End:0x54
    if(localController == none)
    {
        return true;
    }
    return localController.ShouldFireWeaponAttachment();
    //return ReturnValue;    
}

function OnTakeDamage(int inDamage)
{
    local MOHAScriptAIController localController;

    // End:0x37
    if(Controller == none)
    {
        // End:0x34
        if(Owner != none)
        {
            localController = MOHAScriptAIController(Pawn(Owner).Controller);
        }        
    }
    else
    {
        localController = MOHAScriptAIController(Controller);
    }
    // End:0x54
    if(localController == none)
    {
        return;
    }
    localController.OnTakeDamage(inDamage);
    //return;    
}

function bool IsProvidingCoveringFire()
{
    local MOHAScriptAIController localController;

    // End:0x37
    if(Controller == none)
    {
        // End:0x34
        if(Owner != none)
        {
            localController = MOHAScriptAIController(Pawn(Owner).Controller);
        }        
    }
    else
    {
        localController = MOHAScriptAIController(Controller);
    }
    // End:0x54
    if(localController == none)
    {
        return false;
    }
    return localController.bProvidingCoveringFire;
    //return ReturnValue;    
}

function PlayMeleeStimulus()
{
    OnCCStimulus("MOHA_CC.Stimuli.MeleeStrike", self);
    //return;    
}

function OnCCPerformanceStarted(CCPerformance2 Performance, float performanceDuration)
{
    local MOHAScriptAIController localController;

    // End:0x37
    if(Controller == none)
    {
        // End:0x34
        if(Owner != none)
        {
            localController = MOHAScriptAIController(Pawn(Owner).Controller);
        }        
    }
    else
    {
        localController = MOHAScriptAIController(Controller);
    }
    // End:0x54
    if(localController == none)
    {
        return;
    }
    localController.OnCCPerformanceStarted(Performance, performanceDuration);
    //return;    
}

function ResetAimLag()
{
    //return;    
}

function int AdjustCloseRangeDamageFor(Controller InstigatedBy, int actual_damage, int adjusted_damage)
{
    return adjusted_damage;
    //return ReturnValue;    
}

function NPCPreReload()
{
    // End:0x1E
    if(CurrentWeaponAttachment != none)
    {
        CurrentWeaponAttachment.NPCPreReload();
    }
    //return;    
}

function OnStartGTFO()
{
    ClearTimer('RestorePlayerCollision');
    fGTFODisablePlayerCollisionTime = WorldInfo.TimeSeconds;
    //return;    
}

function OnEndGTFO()
{
    RegisterRestorePlayerCollisionTimer();
    //return;    
}

function RegisterRestorePlayerCollisionTimer()
{
    SetTimer(0.5000000, false, 'RestorePlayerCollision',, true);
    //return;    
}

event OnPlayerNoLongerBlockedBy()
{
    // End:0x1F
    if(!IsTimerActive('RestorePlayerCollision'))
    {
        RegisterRestorePlayerCollisionTimer();
    }
    //return;    
}

function RestorePlayerCollision()
{
    // End:0x26
    if(CanRestorePlayerCollision())
    {
        fGTFODisablePlayerCollisionTime = -1.0000000;
        fDisablePlayerCollisionTime = -1.0000000;        
    }
    else
    {
        RegisterRestorePlayerCollisionTimer();
    }
    //return;    
}

event StreamOutCleanup()
{
    // End:0x17
    if(Controller != none)
    {
        Controller.Destroy();
    }
    Destroy();
    //return;    
}

function bool IsMovementInterruptable()
{
    // End:0x36
    if((int(ActiveOIR.m_eOIRState) == int(0)) || int(ActiveOIR.m_eOIRState) == int(1))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

state Dying
{
    function BeginState(name PreviousStateName)
    {
        local int I;

        // End:0x32
        if(bTearOff && int(WorldInfo.NetMode) == int(NM_DedicatedServer))
        {
            LifeSpan = 2.0000000;            
        }
        else
        {
            // End:0x58
            if(MOHAAIController(Controller).AiLod_IsAwake)
            {
                SetTimer(5.0000000, false);                
            }
            else
            {
                SetTimer(0.0100000, false);
            }
        }
        VelocityMagAtDeath = VSize(Velocity);
        // End:0x86
        if(int(Physics) != int(10))
        {
            SetPhysics(2);
        }
        SetCollision(true, false);
        ActiveOIR.SetActivityDone(None);
        ActiveOIR.SetActivityStarted(None);
        Controller.PawnDied(self);
        I = 0;
        J0xDF:

        // End:0x123 [Loop If]
        if(I < Attached.Length)
        {
            // End:0x119
            if(Attached[I] != none)
            {
                Attached[I].PawnBaseDied();
            }
            I++;
            // [Loop Continue]
            goto J0xDF;
        }
        GoTerminalRagdoll();
        BodyHouseKeeping();
        //return;        
    }

    function GoTerminalRagdoll()
    {
        local SkeletalMeshSocket wpnSocket;
        local editinline ActorComponent wpnComponent;
        local class<MOHADamageType> mohaDamType;

        // End:0x92
        if(!bNoRagdoll)
        {
            mohaDamType = class<MOHADamageType>(LastHitDamageType);
            // End:0x77
            if((RagdollThrowActivated || (mohaDamType != none) && mohaDamType.default.bKillShouldCauseLimpRagdoll) || ActiveOIR.bVaultExitUsed)
            {
                MOHARagdollSkelComponent(Mesh).GoTerminalRagdoll(1);                
            }
            else
            {
                MOHARagdollSkelComponent(Mesh).GoTerminalRagdoll(2);
            }
        }
        wpnSocket = Mesh.GetSocketByName('Weapon');
        // End:0xFD
        if(wpnSocket != none)
        {
            wpnComponent = Mesh.FindComponentAttachedToBone(wpnSocket.BoneName);
            // End:0xFD
            if(wpnComponent != none)
            {
                Mesh.DetachComponent(wpnComponent);
            }
        }
        //return;        
    }

    function NotifyDeathRagdoll()
    {
        // End:0x26
        if(!bNoRagdoll)
        {
            MOHARagdollSkelComponent(Mesh).GoTerminalRagdoll(1);
        }
        //return;        
    }

    function NotifyLocoRagdollLimp()
    {
        // End:0x26
        if(!bNoRagdoll)
        {
            MOHARagdollSkelComponent(Mesh).GoTerminalRagdoll(1, false);
        }
        //return;        
    }

    event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
    {
        super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
        // End:0x57
        if(bDetachableGear)
        {
            CheckForDetachedBodyPart(HitInfo.BoneName, EventInstigator, DamageType);
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    KynapseControllerClass=Class'MOHAAxisAIController'
    bSpawnDefaultController=true
    DeathParticleSystemTemplate=ParticleSystem'HUS_VFX_bloodHit.plaster_part'
    NPCtoNPCDamageMult=0.3000000
    fLeashRadius=-1.0000000
    // Reference: OirInstance'Default__MOHAAIPawn.ActiveOirInstance'
    begin object name=ActiveOirInstance class=Class'OirInstance'
    end object
    ActiveOIR=ActiveOirInstance
    bApplyOIRPhysics=true
    EyeSocketName="Eye"
    MeleeCombatRange=500.0000000
    HeadShotBone="Neck1"
    ExplosionMomentumRadiusMult=2.2000000
    CoverTestChannelName="CoverTest"
    GrenadeProjectileClass=Class'MOHAProj_Explosive'
    AimBoneName="Spine"
    vAimBoneOffset=(X=0.0000000,Y=0.0000000,Z=45.0000000)
    RandomHeadMeshes[0]=(Freq=0.1250000,Mesh=SkeletalMesh'GCm_Chr_Head_DE_Andre.SkeletalMesh.DE_Andre_Head_Rigged')
    RandomHeadMeshes[1]=(Freq=0.1250000,Mesh=SkeletalMesh'GCm_Chr_Head_DE_Lutz.SkeletalMesh.DE_Lutz_Head_Rigged')
    RandomHeadMeshes[2]=(Freq=0.1250000,Mesh=SkeletalMesh'GCm_Chr_Head_DE_Simon.SkeletalMesh.DE_Simon_Head_Rigged')
    RandomHeadMeshes[3]=(Freq=0.1250000,Mesh=SkeletalMesh'GCm_Chr_Head_IT_Jason.SkeletalMesh.IT_Jason_Head_Rigged')
    RandomHeadMeshes[4]=(Freq=0.1250000,Mesh=SkeletalMesh'GCm_Chr_Head_US_Peter.SkeletalMesh.US_Peter_Head_Rigged')
    RandomHeadMeshes[5]=(Freq=0.1250000,Mesh=SkeletalMesh'GCm_Chr_Head_DE_Rob.SkeletalMesh.DE_Rob_Head_Rigged')
    RandomHeadMeshes[6]=(Freq=0.1250000,Mesh=SkeletalMesh'GCm_Chr_Head_DE_Mike.SkeletalMesh.DE_Mike_Head_Rigged')
    RandomHeadMeshes[7]=(Freq=0.1250000,Mesh=SkeletalMesh'GCm_Chr_Head_DE_Ben.SkeletalMesh.DE_Ben_Head_Rigged')
    DetachableBodyParts[0]=(Probability=0.3300000,BoneName="Helmet",SecondaryBoneName="Neck1",SpawnedBodyPartClass=Class'MOHADetachedHelmet',BoneControlName="HelmetControl",SpawnedMesh=StaticMesh'GCm_Chr_Helmets.StaticMesh.IT_Blackshirt_Helmet',BoneControl=none,MinSpawnVelocity=(X=300.0000000,Y=-25.0000000,Z=200.0000000),MaxSpawnVelocity=(X=450.0000000,Y=25.0000000,Z=400.0000000),MinRotationRate=50.0000000,MaxRotationRate=75.0000000,rRotCorrection=(Pitch=0,Yaw=16384,Roll=-16384),bDetachOnExplosion=true,HitSound_PC=SoundCue'Aud_GCm_FakeWAV.Bullets.Projimpact_Bullet_Helmet',HitSound_NPC=SoundCue'Aud_GCm_FakeWAV.Bullets.Projimpact_Bullet_Helmet_NPC',bCachedDetached=false)
    // Reference: FixedFireOIRImpl'Default__MOHAAIPawn.FFoirImpl'
    begin object name=FFoirImpl class=Class'FixedFireOIRImpl'
    end object
    FFImpl=FFoirImpl
    // Reference: MeleeOIRImpl'Default__MOHAAIPawn.MeleeOIRImpl'
    begin object name=MeleeOIRImpl class=Class'MeleeOIRImpl'
    end object
    MImpl=MeleeOIRImpl
    // Reference: DeathOIRImpl'Default__MOHAAIPawn.DeathOIRImpl'
    begin object name=DeathOIRImpl class=Class'DeathOIRImpl'
    end object
    DeathImpl=DeathOIRImpl
    // Reference: NavigationOIRImpl'Default__MOHAAIPawn.NavOIRImpl'
    begin object name=NavOIRImpl class=Class'NavigationOIRImpl'
    end object
    NImpl=NavOIRImpl
    bDetachableGear=true
    AnimTreeState=(BlendByOIRActiveChildIndex=-1,BlendByEntryExitActiveChildIndex=-1,BlendByActivityActiveChildIndex=-1)
    NPCBulletFilterPct=0.5000000
    fHitreactionEnergyAdditionMin=0.1000000
    fHitreactionEnergyAdditionMax=0.4000000
    fHitreactionEnergyDistanceMin=100.0000000
    fHitreactionEnergyDistanceMax=1500.0000000
    MaxBodies=10
    // Reference: CCPerformerForAI'Default__MOHAAIPawn.MyCCP'
    begin object name=MyCCP
    end object
    CCP=MyCCP
    // Reference: AudioComponent'Default__MOHAAIPawn.MyFaceFXAudioComponent'
    begin object name=MyFaceFXAudioComponent
    end object
    FaceFXAudioComponent=MyFaceFXAudioComponent
    bMeshAdj_Enabled=true
    PawnSide=2
    // Reference: AxonScriptEventObserverComponent'Default__MOHAAIPawn.AxonObserver0'
    begin object name=AxonObserver0
    end object
    AxonObserver=AxonObserver0
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAAIPawn.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvComponent=MyLightEnvironment
    BoneDamageTuning[0]=(BoneName="LeftFoot",DamageModifier=0.5000000,DamageLocation=5)
    BoneDamageTuning[1]=(BoneName="LeftUpLeg",DamageModifier=0.7500000,DamageLocation=5)
    BoneDamageTuning[2]=(BoneName="RightFoot",DamageModifier=0.5000000,DamageLocation=6)
    BoneDamageTuning[3]=(BoneName="RightUpLeg",DamageModifier=0.7500000,DamageLocation=6)
    BoneDamageTuning[4]=(BoneName="Hips",DamageModifier=1.2500000,DamageLocation=4)
    BoneDamageTuning[5]=(BoneName="LeftHand",DamageModifier=0.7500000,DamageLocation=2)
    BoneDamageTuning[6]=(BoneName="LeftArm",DamageModifier=0.7500000,DamageLocation=2)
    BoneDamageTuning[7]=(BoneName="RightHand",DamageModifier=0.7500000,DamageLocation=1)
    BoneDamageTuning[8]=(BoneName="RightArm",DamageModifier=0.7500000,DamageLocation=1)
    BoneDamageTuning[9]=(BoneName="Spine",DamageModifier=1.0000000,DamageLocation=3)
    BoneDamageTuning[10]=(BoneName="Neck",DamageModifier=4.0000000,DamageLocation=0)
    bCanCrouch=true
    DesiredSpeed=0.0000000
    AccelRate=1000.0000000
    // Reference: MOHARagdollSkelComponent'Default__MOHAAIPawn.AvatorPawnSkeletalMeshComponent'
    begin object name=AvatorPawnSkeletalMeshComponent class=Class'MOHARagdollSkelComponent'
        audioImpactHandlerAsset=MOHARagdollAudioAsset'ragdollaudio.collisionaudio'
        AnimTreeTemplate=AnimTree'Anim_AI_Human.AnimTree.Human_AnimTree_Rifle'
        PhysicsAsset=PhysicsAsset'Anim_AI_Ragdoll.Physics.IT_Blackshirt_Rigged_Physics_Test'
        AnimSets[0]=AnimSet'Anim_AI_HumanAnimSet.AnimSet.Human_Rifle'
        AnimSets[1]=AnimSet'Anim_AI_MeleeAnimSet.AnimSet.MeleeAnimSet_Rifle'
        bUpdateSkelWhenNotRendered=true
        bForceDiscardRootMotion=true
        RootMotionMode=1
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAAIPawn.MyLightEnvironment'
        LightingChannels=(bInitialized=true,Characters_Weapons_Vehicles=true)
        CollideActors=true
        BlockZeroExtent=true
        BlockRigidBody=true
        RBChannel=2
        RBCollideWithChannels=(Default=true,Pawn=true)
        PhysMaterialOverride=PhysicalMaterial'GCm_PhysMaterials.Character'
    end object
    Mesh=AvatorPawnSkeletalMeshComponent
    // Reference: MOHACylinderComponent'Default__MOHAAIPawn.MOHACollisionCylinder'
    begin object name=MOHACollisionCylinder class=Class'MOHACylinderComponent'
        CustomCollisionRadius=39.5000000
        CollisionHeight=96.0000000
        CollisionRadius=39.5000000
        CollideActors=true
        BlockZeroExtent=false
    end object
    CylinderComponent=MOHACollisionCylinder
    InventoryManagerClass=Class'MOHAInventoryManager'
    // Reference: SpriteComponent'Default__MOHAAIPawn.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: ArrowComponent'Default__MOHAAIPawn.Arrow'
    begin object name=Arrow
    end object
    Components[1]=Arrow
    Components[2]=MyLightEnvironment
    Components[3]=AxonObserver0
    Components[4]=MyFaceFXAudioComponent
    Components[5]=MyCCP
    Components[6]=MOHACollisionCylinder
    // Reference: MOHAAIPawnRenderingComponent'Default__MOHAAIPawn.RenderComp0'
    begin object name=RenderComp0 class=Class'MOHAAIPawnRenderingComponent'
    end object
    Components[7]=RenderComp0
    ActorType=6
    bStasisPooling=true
    bStasis=true
    bCollideWorld=false
    CollisionComponent=MOHACollisionCylinder
}