class MOHAMountedGun extends MOHAPawn
    abstract
    native
    config(Game)
    hidecategories(Navigation,Eyes,Display,Camera,InThePlane)
    implements(OIROwnerInterface,SpawnInOIRInterface,OIRAttachmentPolicy,OIREventListener);

var export editinline StimulusComponent Stimulus;
var transient MOHAPawn Gunner;
var transient MOHAPawn ClaimedBy;
var transient Actor GunnerPrevBase;
var transient float fGunnerDeathRemountPenalty;
var transient float fGunnerDeathRemountTime;
var float fGunnerDeathAddPenalty;
var float fGunnerDeathPenaltyMultiplier;
var float fGunnerDeathPenaltyDecayMultiplier;
var float fMMGNotRenderedBonusMultiplier;
var Rotator InitialOrientation;
var private transient bool bIsClaimed;
var private transient bool bIsMounted;
var private transient bool bIsGunAttached;
var(MountedGun) float StimulusBroadcastTimeInSec;
var(MountedGun) float TimeBetweenMountsInSec;
var(MountedGun) float YawMaxInDegrees;
var(MountedGun) float YawMinInDegrees;
var class<AxonBrainState> TransplantBrainState;
var class<MOHAMountedGunWeapon> MountedWeaponClass;
var class<Controller> MountedGunControllerClass;
var MOHAMountedGunController MGController;
var MOHAMountedGunCSA MyCSA;
var(oir) AnimSet OIRAnimSet;
var(oir) AnimTree OIRAnimTree;
var(NPC) float NPCAimAtSpeed;
var(NPC) Vector2D NPCAimPitchRangeInDegs;
var(NPC) Vector2D NPCAimYawRangeInDegs;
var(NPC) Vector2D NPCAimRecenterThresholdInDegs;
var(MountedGun) bool bHideStand;
var(MountedGun) bool bDrawNPCAttachLocation;
var(MountedGun) bool bSpawnInOIR;
var bool bPlayedAID;
var transient KynapseDummyCoverNode MountedGunCoverNode;
var float SpawnOffset;
var name StimulusTemplate;
var name IdleStimulusTemplate;
var(MountedGun) float fMaxEngagementDistance;
var Rotator LaggedAimRotation;
var export editinline SkeletalMeshComponent EditorMesh;
//var delegate<OnRotationDone> __OnRotationDone__Delegate;

delegate OnRotationDone(Rotator NewRot)
{
    //return;    
}

// Export UMOHAMountedGun::execClaim(FFrame&, void* const)
native function bool Claim(MOHAPawn P);

// Export UMOHAMountedGun::execGetIsClaimed(FFrame&, void* const)
native function bool GetIsClaimed();

// Export UMOHAMountedGun::execGetIsMounted(FFrame&, void* const)
native function bool GetIsMounted();

// Export UMOHAMountedGun::execSpawnMountStimulus(FFrame&, void* const)
native function SpawnMountStimulus();

// Export UMOHAMountedGun::execGetPawnBody(FFrame&, void* const)
native function MOHAPawn GetPawnBody();

// Export UMOHAMountedGun::execDeg2Unreal(FFrame&, void* const)
native function int Deg2Unreal(float deg);

simulated function PostBeginPlay()
{
    local Inventory Inv;
    local Vector attachLoc, gunSocketLoc;

    super.PostBeginPlay();
    // End:0x1B
    if(Controller == none)
    {
        SpawnDefaultController();
    }
    CollisionComponent = Mesh;
    Inv = CreateInventory(MountedWeaponClass);
    // End:0x5C
    if(Weapon(Inv) != none)
    {
        SetActiveWeapon(Weapon(Inv));
    }
    SpawnAttachment(EALAWeapon(Inv));
    InitialOrientation = Rotation;
    YawMinInDegrees = Abs(YawMinInDegrees);
    // End:0xA7
    if(!bSpawnInOIR)
    {
        SetTimer(StimulusBroadcastTimeInSec, true, 'SpawnMountStimulus');
    }
    HideStand(bHideStand);
    SpawnCSA();
    InitNPCAimRanges();
    Mesh.GetSocketWorldLocationAndRotation('CoverAttach', attachLoc);
    MountedGunCoverNode.Setup(attachLoc, Rotation);
    // End:0x130
    if(!Class'MOHAUtilities'.static.IsEditorActive())
    {
        DetachComponent(EditorMesh);
        EditorMesh = none;
    }
    Mesh.ForceSkelUpdate();
    MOHAMountedGunWeapon(Weapon).FaceDefault();
    Mesh.GetSocketWorldLocationAndRotation('Weapon', gunSocketLoc);
    // End:0x1D1
    if(MOHASkeletalMeshComponent(CurrentWeaponAttachment.Mesh) != none)
    {
        MOHASkeletalMeshComponent(CurrentWeaponAttachment.Mesh).SetLockTranslationVector(gunSocketLoc);
        MOHASkeletalMeshComponent(CurrentWeaponAttachment.Mesh).ForceSkelUpdate();
    }
    //return;    
}

function SpawnAttachment(EALAWeapon Weap)
{
    CurrentWeaponAttachment = __NFUN_278__(Weap.AttachmentClass, self);
    CurrentWeaponAttachment.Instigator = self;
    // End:0x4C
    if(CurrentWeaponAttachment != none)
    {
        CurrentWeaponAttachment.AttachTo(self);
    }
    // End:0xB3
    if((none != Weap) && CurrentWeaponAttachment != none)
    {
        Weap.AttachmentChanged(CurrentWeaponAttachment);
        AttachNewWeaponMesh(Weap);
        // End:0xB3
        if(MOHAMountedGunWeapon(Weap) != none)
        {
            MOHAMountedGunWeapon(Weap).InitSkeletalControls();
        }
    }
    //return;    
}

function SpawnDefaultController()
{
    // End:0x3C
    if((Controller == none) && MountedGunControllerClass != none)
    {
        Controller = __NFUN_278__(MountedGunControllerClass);
        MGController = MOHAMountedGunController(Controller);
    }
    //return;    
}

function TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    //return;    
}

function TryPlayMMGAID()
{
    // End:0x0B
    if(bPlayedAID)
    {
        return;
    }
    // End:0x5D
    if(MOHAAxisAIPawn(Gunner) != none)
    {
        MOHAAxisAIPawn(Gunner).BroadcastStimulus("MOHA_CC.Stimuli.MG42", Gunner, 10000.0000000, 1);
        bPlayedAID = true;
    }
    //return;    
}

simulated function Rotator GetPostAdjustedAimFor(Weapon W, Vector StartFireLoc, Rotator DesiredAimRot, Rotator PostAdjustAimRot)
{
    local Rotator GoalAimRotation;
    local float AimLagStrength;

    // End:0x23
    if((Controller == none) || int(Role) < int(ROLE_Authority))
    {
        return PostAdjustAimRot;
    }
    // End:0x1CF
    if((Gunner != none) && Gunner.IsA('MOHAAIPawn'))
    {
        // End:0x7B
        if(LaggedAimRotation.Pitch == 0)
        {
            LaggedAimRotation.Pitch = GoalAimRotation.Pitch;
        }
        // End:0xAF
        if(LaggedAimRotation.Yaw == 0)
        {
            LaggedAimRotation.Yaw = GoalAimRotation.Yaw;
        }
        AimLagStrength = MOHAScriptAIController(Controller).fAimLagStrengthMMG;
        LaggedAimRotation.Pitch = Class'MOHAUtilities'.static.LagRot(DesiredAimRot.Pitch, LaggedAimRotation.Pitch, AimLagStrength, WorldInfo.DeltaSeconds);
        LaggedAimRotation.Yaw = Class'MOHAUtilities'.static.LagRot(DesiredAimRot.Yaw, LaggedAimRotation.Yaw, AimLagStrength, WorldInfo.DeltaSeconds);
        PostAdjustAimRot = W.AddSpread(LaggedAimRotation);
        GoalAimRotation = KynapseAIController(Controller).AccuracyMan.AdjustAim(W, StartFireLoc, LaggedAimRotation, PostAdjustAimRot);
        return GoalAimRotation;
    }
    return PostAdjustAimRot;
    //return ReturnValue;    
}

function ConsumeAmmo(EALAWeapon Weap, byte FireModeNum)
{
    //return;    
}

simulated function Vector GetWeaponStartTraceLocation(optional Weapon CurrentWeapon)
{
    local Vector socketLoc;

    // End:0x31
    if((Gunner != none) && Gunner.IsA('MOHAPlayerPawn'))
    {
        return super.GetWeaponStartTraceLocation(CurrentWeapon);
    }
    MOHAMountedGunWeapon(Weapon).WeaponSkeletalMesh.GetSocketWorldLocationAndRotation('Barrel', socketLoc);
    return socketLoc;
    //return ReturnValue;    
}

simulated event Destroyed()
{
    // End:0x1E
    if(Gunner != none)
    {
        Gunner.Destroy();
        Gunner = none;
    }
    // End:0x3C
    if(MyCSA != none)
    {
        MyCSA.Destroy();
        MyCSA = none;
    }
    super.Destroyed();
    //return;    
}

function SetMovementPhysics()
{
    return;
    //return;    
}

function TossWeapon(Weapon Weap, optional Vector ForceVelocity)
{
    //return;    
}

simulated function FaceRotation(Rotator NewRotation, float DeltaTime)
{
    // End:0x32
    if(MOHAMountedGunWeapon(Weapon) != none)
    {
        MOHAMountedGunWeapon(Weapon).FaceRotation(NewRotation, DeltaTime);
    }
    //return;    
}

simulated function StartReload(byte FireModeNum)
{
    // End:0x41
    if((Weapon != none) && Weapon.IsA('EALASmallArms'))
    {
        EALASmallArms(Weapon).StartReload(FireModeNum);
    }
    //return;    
}

function Rotator LimitViewYawRotation(Rotator ViewRotation)
{
    local int OrientedMin, OrientedMax;

    OrientedMin = InitialOrientation.Yaw - (Deg2Unreal(YawMinInDegrees));
    OrientedMax = InitialOrientation.Yaw + (Deg2Unreal(YawMaxInDegrees));
    // End:0x7D
    if(ViewRotation.Yaw < OrientedMin)
    {
        ViewRotation.Yaw = OrientedMin;        
    }
    else
    {
        // End:0xAB
        if(ViewRotation.Yaw > OrientedMax)
        {
            ViewRotation.Yaw = OrientedMax;
        }
    }
    return ViewRotation;
    //return ReturnValue;    
}

function class<AxonBrainState> GetTransplantBrainState()
{
    return TransplantBrainState;
    //return ReturnValue;    
}

function GunnerDied()
{
    UnMountGun(true);
    //return;    
}

function ReturnToCenter(float DeltaTime)
{
    // End:0x2D
    if(MOHAMountedGunWeapon(Weapon) != none)
    {
        MOHAMountedGunWeapon(Weapon).ReturnToCenter(DeltaTime);
    }
    //return;    
}

function SpawnCSA()
{
    local Vector TransformedOffset;
    local Rotator Rot;

    Mesh.GetSocketWorldLocationAndRotation('CSAOffset', TransformedOffset, Rot);
    MyCSA = __NFUN_278__(Class'MOHAMountedGunCSA', self,, TransformedOffset);
    MyCSA.MountedGun = self;
    MyCSA.SetBase(self);
    MyCSA.SetHardAttach(true);
    //return;    
}

function InitNPCAimRanges()
{
    // End:0x2D
    if(NPCAimPitchRangeInDegs.X > float(0))
    {
        NPCAimPitchRangeInDegs.X *= -1.0000000;
    }
    // End:0x5A
    if(NPCAimYawRangeInDegs.X > float(0))
    {
        NPCAimYawRangeInDegs.X *= -1.0000000;
    }
    // End:0x87
    if(NPCAimRecenterThresholdInDegs.X > float(0))
    {
        NPCAimRecenterThresholdInDegs.X *= -1.0000000;
    }
    //return;    
}

function bool MountGun(MOHAPawn P)
{
    local Controller C;
    local MOHAAIPawn AIPawn;

    AIPawn = MOHAAIPawn(P);
    // End:0x148
    if((AIPawn != none) && !bIsMounted)
    {
        AttachToNPC(AIPawn);
        Gunner = AIPawn;
        Gunner.CurrentWeaponAttachment.Mesh.SetHidden(true);
        Gunner.StartUsingMountedGun(self);
        C = Gunner.Controller;
        // End:0x127
        if(C != none)
        {
            MGController.UnPossess();
            C.UnPossess();
            Gunner.SetOwner(self);
            C.Possess(self, true);
            MOHAAIController(C).SetMountedGun(self);
            // End:0x127
            if(MOHAAIController(C).TeamIndex == 0)
            {
                fGunnerDeathRemountTime = 0.0000000;
                fGunnerDeathRemountPenalty = 0.0000000;
            }
        }
        SetTimer(0.0000000, false, 'ClearClaim');
        SetIsMounted(true);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool UnMountGun(optional bool bGunnerDied = false)
{
    local Controller C;

    // End:0x114
    if(((Gunner != none) && Gunner.IsA('MOHAAIPawn')) && bIsMounted)
    {
        Gunner.CurrentWeaponAttachment.Mesh.SetHidden(false);
        DetachFromNPC(MOHAAIPawn(Gunner));
        Gunner.StopUsingMountedGun(self);
        C = Controller;
        // End:0xFF
        if(C != none)
        {
            C.UnPossess();
            Gunner.SetOwner(C);
            C.Possess(Gunner, true);
            MOHAAIController(C).SetMountedGun(none);
            MGController.Possess(self, true);
        }
        ResetMG(bGunnerDied);
        return true;        
    }
    else
    {
        // End:0x15C
        if((ClaimedBy != none) && ClaimedBy.IsA('MOHAAIPawn'))
        {
            DetachFromNPC(MOHAAIPawn(ClaimedBy));
            ResetMG(bGunnerDied);
        }
    }
    return false;
    //return ReturnValue;    
}

function AttachToNPC(MOHAAIPawn AIPawn)
{
    local editinline MOHASkeletalMeshComponent mySkelComp;

    // End:0x107
    if((AIPawn != none) && !bIsGunAttached)
    {
        AIPawn.Mesh.AttachComponentToSocket(CurrentWeaponAttachment.Mesh, 'LeftProp');
        MOHAMountedGunWeapon(Weapon).FaceNull();
        MOHAMountedGunWeapon(Weapon).EnableSkelControls(false);
        Weapon.Activate();
        bIsGunAttached = true;
        SmallArmsAttachment(CurrentWeaponAttachment).UpdateVFXAttachments();
        Attachment_MountedWeapon(CurrentWeaponAttachment).bMountedByNPCPawn = true;
        mySkelComp = MOHASkeletalMeshComponent(CurrentWeaponAttachment.Mesh);
        // End:0xF6
        if(mySkelComp != none)
        {
            mySkelComp.bForceNoTick = false;
        }
        CurrentWeaponAttachment.UniversalLODCategory = 16;
    }
    //return;    
}

function DetachFromNPC(MOHAAIPawn AIPawn)
{
    local editinline MOHASkeletalMeshComponent mySkelComp;

    // End:0xD4
    if((AIPawn != none) && bIsGunAttached)
    {
        Mesh.AttachComponentToSocket(CurrentWeaponAttachment.Mesh, 'Weapon');
        MOHAMountedGunWeapon(Weapon).EnableSkelControls(true);
        MOHAMountedGunWeapon(Weapon).FaceDefault();
        bIsGunAttached = false;
        Attachment_MountedWeapon(CurrentWeaponAttachment).bMountedByNPCPawn = false;
        mySkelComp = MOHASkeletalMeshComponent(CurrentWeaponAttachment.Mesh);
        // End:0xC0
        if(mySkelComp != none)
        {
            mySkelComp.bForceNoTick = true;
        }
        CurrentWeaponAttachment.UniversalLODCategory = default.UniversalLODCategory;
    }
    //return;    
}

function Vector GetWeaponAttachmentLocation()
{
    local Vector vPos;
    local Rotator rRot;

    Mesh.GetSocketWorldLocationAndRotation('Weapon', vPos, rRot);
    return vPos;
    //return ReturnValue;    
}

function PlayerOverride()
{
    // End:0x6B
    if(((ClaimedBy != none) && ClaimedBy.Controller != none) && KynapseAIController(ClaimedBy.Controller) != none)
    {
        KynapseAIController(ClaimedBy.Controller).ABSS.TripNamedScriptEvent('PlayerOverrideClaim');
    }
    //return;    
}

function EnablePlayerUse(MOHAPlayerPawn GunUser)
{
    local Attachment_MountedWeapon MGAttachment;
    local editinline MOHASkeletalMeshComponent mySkelComp;

    MGAttachment = Attachment_MountedWeapon(CurrentWeaponAttachment);
    // End:0x46
    if(MGAttachment != none)
    {
        MGAttachment.SwitchToPlayerMesh(GunUser);
        MGAttachment.UpdateVFXAttachments();
    }
    mySkelComp = MOHASkeletalMeshComponent(Mesh);
    // End:0x72
    if(mySkelComp != none)
    {
        mySkelComp.bForceNoTick = false;
    }
    //return;    
}

function DisablePlayerUse()
{
    local Attachment_MountedWeapon MGAttachment;
    local editinline MOHASkeletalMeshComponent mySkelComp;

    MGAttachment = Attachment_MountedWeapon(CurrentWeaponAttachment);
    // End:0x2E
    if(MGAttachment != none)
    {
        MGAttachment.SwitchToNPCMesh();
    }
    mySkelComp = MOHASkeletalMeshComponent(Mesh);
    // End:0x5A
    if(mySkelComp != none)
    {
        mySkelComp.bForceNoTick = true;
    }
    MOHAMountedGunWeapon(Weapon).FaceDefault();
    //return;    
}

function HideStand(bool Hide)
{
    Mesh.SetHidden(Hide);
    //return;    
}

function SetIsClaimed(bool claimed)
{
    bIsClaimed = claimed;
    //return;    
}

function SetIsMounted(bool mounted)
{
    bIsMounted = mounted;
    //return;    
}

function ClearClaim()
{
    ClaimedBy = none;
    bIsClaimed = false;
    //return;    
}

function bool GetIsGunAttached()
{
    return bIsGunAttached;
    //return ReturnValue;    
}

function ApplyDeathPenalty()
{
    fGunnerDeathRemountPenalty += fGunnerDeathAddPenalty;
    fGunnerDeathRemountPenalty *= fGunnerDeathPenaltyMultiplier;
    fGunnerDeathRemountTime = fGunnerDeathRemountPenalty;
    //return;    
}

function ResetMG(optional bool bGunnerDied = false)
{
    local float resetTime;

    SetIsMounted(false);
    resetTime = TimeBetweenMountsInSec;
    // End:0x60
    if((Gunner != none) && Gunner.IsA('MOHAPlayerPawn'))
    {
        fGunnerDeathRemountTime = 0.0000000;
        fGunnerDeathRemountPenalty = 0.0000000;
        resetTime = 0.1000000;
    }
    // End:0x7E
    if(bGunnerDied)
    {
        ApplyDeathPenalty();
        resetTime = 0.1000000;
    }
    // End:0xDA
    if(((ClaimedBy != none) && ClaimedBy.IsA('MOHAAIPawn')) && ClaimedBy.Controller != none)
    {
        MOHAAIController(ClaimedBy.Controller).SetMountedGun(none);
    }
    SetTimer(resetTime, false, 'ClearClaim');
    Gunner = none;
    //return;    
}

function bool IsClaimedBy(KynapseAIController C)
{
    // End:0x1A
    if((ClaimedBy == none) || C == none)
    {
        return false;
    }
    // End:0x40
    if(ClaimedBy.Controller == none)
    {
        return KynapseAIController(Controller) == C;
    }
    return KynapseAIController(ClaimedBy.Controller) == C;
    //return ReturnValue;    
}

function bool IsMountedBy(KynapseAIController C)
{
    // End:0x1A
    if((Gunner == none) || C == none)
    {
        return false;
    }
    return KynapseAIController(Gunner.Controller) == C;
    //return ReturnValue;    
}

function KynapseDummyCoverNode GetCoverNode()
{
    return MountedGunCoverNode;
    //return ReturnValue;    
}

function Vector GetAttachLocation()
{
    local Vector attachPos;

    Mesh.GetSocketWorldLocationAndRotation('oirAttach', attachPos);
    return attachPos;
    //return ReturnValue;    
}

function SetOnRotationDone(delegate<OnRotationDone> cb)
{
    __OnRotationDone__Delegate = cb;
    //return;    
}

function float GetArrivedAtRadius()
{
    return 50.0000000;
    //return ReturnValue;    
}

function OIRData GetOIRData()
{
    local OIRData oir;

    Mesh.GetSocketWorldLocationAndRotation('oirAttach', oir.OIRPosition, oir.OIRRotation);
    oir.OIRAnimSet = OIRAnimSet;
    oir.OIRAnimTree = OIRAnimTree;
    oir.OIRCollideWorldRadius = 10.0000000;
    return oir;
    //return ReturnValue;    
}

function name GetActivityPose(name InName)
{
    return 'None';
    //return ReturnValue;    
}

function bool IsDifferentOIR(Object AOIR, bool bAnimsChanged)
{
    // End:0x0B
    if(bAnimsChanged)
    {
        return true;
    }
    return NotEqual_InterfaceInterface(OirInstance(AOIR).OIRParent, OIROwnerInterface(self));
    //return ReturnValue;    
}

function bool GetAlternateExitFinalPosition(out Vector pos)
{
    return false;
    //return ReturnValue;    
}

function bool IsDifferentReference(OIROwnerInterface prevOIR)
{
    return NotEqual_InterfaceInterface(OIROwnerInterface(self), prevOIR);
    //return ReturnValue;    
}

function bool ShouldAttach()
{
    return true;
    //return ReturnValue;    
}

function bool ShouldCollideWorld()
{
    return true;
    //return ReturnValue;    
}

function GetAttachData(out Actor out_Actor, optional out SkeletalMeshComponent out_SkelMesh, optional out name out_AttachName)
{
    out_Actor = self;
    out_SkelMesh = Mesh;
    out_AttachName = 'oirAttach';
    //return;    
}

function SkeletalMeshComponent.ERootMotionMode GetRootMotionMode()
{
    return 0;
    //return ReturnValue;    
}

function bool UseOIRPhysics()
{
    return true;
    //return ReturnValue;    
}

function class<AxonBrainState> GetSpawnTransplantBrain()
{
    return Class'MountedGunCombatBrainState';
    //return ReturnValue;    
}

function Actor SpawnOIRPawn(class<Pawn> PawnClass)
{
    local OIRData oir;

    // End:0xA9
    if(bSpawnInOIR)
    {
        oir = GetOIRData();
        Gunner = MOHAAIPawn(__NFUN_278__(PawnClass, self,, oir.OIRPosition + (vect(0.0000000, 0.0000000, 1.0000000) * SpawnOffset), oir.OIRRotation));
        Claim(Gunner);
        KynapseAIController(Gunner.Controller).SetNextOIRData(self, GetInitialActivity(), false);
        return Gunner;
    }
    return none;
    //return ReturnValue;    
}

simulated function OnSpawnOIRPawn(SeqAct_SpawnOIRPawn Action)
{
    Action.ReportSpawned(SpawnOIRPawn(Action.SpawnOIRPawnClass));
    //return;    
}

function InitBrainState(AxonBrainState Abs)
{
    // End:0x25
    if(MountedGunCombatBrainState(Abs) != none)
    {
        MountedGunCombatBrainState(Abs).MountedGun = self;
    }
    //return;    
}

function name GetInitialActivity()
{
    return 'Aim';
    //return ReturnValue;    
}

function ReturnToSpawner()
{
    local MOHAPawn oldGunner;

    oldGunner = Gunner;
    UnMountGun();
    oldGunner.ReturnToSpawner();
    //return;    
}

function bool KillMeImHere()
{
    local MOHAPawn oldGunner;

    oldGunner = Gunner;
    UnMountGun();
    return oldGunner.KillMeImHere();
    //return ReturnValue;    
}

function bool ShouldFireWeaponAttachment()
{
    // End:0x1F
    if(Gunner != none)
    {
        return Gunner.ShouldFireWeaponAttachment();
    }
    return true;
    //return ReturnValue;    
}

function OnEntryFinish()
{
    MountGun(ClaimedBy);
    // End:0x50
    if(bSpawnInOIR)
    {
        MOHAAIController(Controller).ABSS.AddTransplantBrainState(GetSpawnTransplantBrain(), InitBrainState, true);        
    }
    else
    {
        ClaimedBy.SetRotation(Rotation);
    }
    //return;    
}

function OnExitBegin()
{
    UnMountGun();
    //return;    
}

function OnAttach()
{
    //return;    
}

function OnDetach()
{
    //return;    
}

function bool OnPreAttachUpdateOIRRotation()
{
    return false;
    //return ReturnValue;    
}

function OnDummyFire(SeqAct_DummyFire Action)
{
    // End:0x16
    if(Gunner != none)
    {
        super.OnDummyFire(Action);
    }
    //return;    
}

event StreamOutCleanup()
{
    UnMountGun();
    // End:0x22
    if(Controller != none)
    {
        Controller.Destroy();
    }
    // End:0x39
    if(InvManager != none)
    {
        InvManager.Destroy();
    }
    super.StreamOutCleanup();
    //return;    
}

function UpdateNewOIRReference(Object newOIR)
{
    //return;    
}

function SetNextOIRInPlace()
{
    //return;    
}

function RegisteredAsNext()
{
    //return;    
}

function SetOIRData(out OIRData oir)
{
    //return;    
}

function SetAttachData(out Actor out_Actor, optional out SkeletalMeshComponent out_SkelMesh, optional out name out_AttachName)
{
    //return;    
}

event NPCLeavingOIR(Pawn P)
{
    //return;    
}

simulated function OnExitOIR(SeqAct_ExitOIR Action)
{
    //return;    
}

function int GetHeightPostureOverride(name ActivityPoseName)
{
    return 0;
    //return ReturnValue;    
}

defaultproperties
{
    // Reference: StimulusComponent'Default__MOHAMountedGun.Stimulus0'
    begin object name=Stimulus0 class=Class'EAKynapse.StimulusComponent'
    end object
    Stimulus=Stimulus0
    fGunnerDeathAddPenalty=4.0000000
    fGunnerDeathPenaltyMultiplier=2.0000000
    fGunnerDeathPenaltyDecayMultiplier=0.3300000
    fMMGNotRenderedBonusMultiplier=2.0000000
    StimulusBroadcastTimeInSec=1.2000000
    TimeBetweenMountsInSec=5.0000000
    YawMaxInDegrees=90.0000000
    YawMinInDegrees=90.0000000
    TransplantBrainState=Class'MountedGunCombatBrainState'
    MountedGunControllerClass=Class'MOHAMountedGunController'
    OIRAnimSet=AnimSet'Anim_AI_MMGAnimSet.AnimSet'
    OIRAnimTree=AnimTree'Anim_AI_MMG.Human'
    NPCAimAtSpeed=5.0000000
    NPCAimPitchRangeInDegs=(X=40.0000000,Y=40.0000000)
    NPCAimYawRangeInDegs=(X=45.0000000,Y=45.0000000)
    NPCAimRecenterThresholdInDegs=(X=45.0000000,Y=45.0000000)
    fMaxEngagementDistance=5000.0000000
    // Reference: SkeletalMeshComponent'Default__MOHAMountedGun.InEditorMesh'
    begin object name=InEditorMesh class=Class'Engine.SkeletalMeshComponent'
        HiddenGame=true
    end object
    EditorMesh=InEditorMesh
    // Reference: AxonScriptEventObserverComponent'Default__MOHAMountedGun.AxonObserver0'
    begin object name=AxonObserver0
    end object
    AxonObserver=AxonObserver0
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAMountedGun.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvComponent=MyLightEnvironment
    bCanBeBaseForPawns=true
    BaseEyeHeight=120.0000000
    LandMovementState="PlayerMountedGunning"
    // Reference: MOHASkeletalMeshComponent'Default__MOHAMountedGun.StandComponent'
    begin object name=StandComponent class=Class'MOHASkeletalMeshComponent'
        bForceNoTick=true
        LightingChannels=(bInitialized=true,Characters_Weapons_Vehicles=true)
    end object
    Mesh=StandComponent
    // Reference: CylinderComponent'Default__MOHAMountedGun.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    InventoryManagerClass=Class'MOHAInventoryManager'
    // Reference: SpriteComponent'Default__MOHAMountedGun.Sprite'
    begin object name=Sprite
        HiddenEditor=true
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    // Reference: ArrowComponent'Default__MOHAMountedGun.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=MyLightEnvironment
    Components[4]=AxonObserver0
    Components[5]=Stimulus0
    Components[6]=InEditorMesh
    Components[7]=StandComponent
    ActorType=12
    UniversalLODMethod=5
    CollisionComponent=CollisionCylinder
    UniversalLOD_MaximumDeltaTime=2.0000000
}