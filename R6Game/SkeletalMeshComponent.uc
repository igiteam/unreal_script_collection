class SkeletalMeshComponent extends MeshComponent
    native
    editinlinenew
    collapsecategories
    noexport
    hidecategories(Object);

enum ERootMotionMode
{
    RMM_Translate,                  // 0
    RMM_Velocity,                   // 1
    RMM_MAX                         // 2
};

struct BloodStain
{
    var Matrix Matrix;
    var Vector Normal;
    var float Size;

    structdefaultproperties
    {
        Matrix=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000))
        Normal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Size=0.0000000
    }
};

struct ActiveMorph
{
    var MorphTarget Target;
    var float Weight;

    structdefaultproperties
    {
        Target=none
        Weight=0.0000000
    }
};

struct Attachment
{
    var() export editinline ActorComponent Component;
    var() name BoneName;
    var() Vector RelativeLocation;
    var() Rotator RelativeRotation;
    var() Vector RelativeScale;

    structdefaultproperties
    {
        Component=none
        BoneName="None"
        RelativeLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        RelativeRotation=(Pitch=0,Yaw=0,Roll=0)
        RelativeScale=(X=1.0000000,Y=1.0000000,Z=1.0000000)
    }
};

var transient array<BloodStain> m_BloodStains;
var() SkeletalMesh SkeletalMesh;
var() const AnimNode AnimTreeTemplate;
var transient AnimNode Animations;
var() PhysicsAsset PhysicsAsset;
var export editinline transient PhysicsAssetInstance PhysicsAssetInstance;
var() float PhysicsWeight;
var native const transient Pointer MeshObject;
var native const transient Pointer cachedMTMeshObject[2];
var native const transient SkeletalMesh cacheMTSkeletalMesh[2];
var Vector m_vCachedLitSpecialOrigin[2];
var() Color WireframeColor;
var native const transient array<Matrix> SpaceBases;
var bool m_bUseHumanIK;
var bool m_bEnableHumanIK;
var native const transient array<Matrix> LocalSpaceBases;
var transient Pointer m_pTwoBoneIKSolver;
var int m_iLastUpdateTick;
var bool m_bCanIssueNotifies;
var() const export editinline SkeletalMeshComponent ParentAnimComponent;
var native const transient array<int> ParentBoneMap;
var() array<AnimSet> AnimSets;
var() array<MorphTargetSet> MorphSets;
var array<ActiveMorph> ActiveMorphs;
var() const array<Attachment> Attachments;
var const transient array<byte> SkelControlIndex;
var const transient int m_iCurrentLODLevel;
var const transient int m_iCurrentLODLevelTick;
var const transient int m_iCurrentLODLevelCacheTick;
var const transient int m_iPreviousLODLevel;
var const transient int m_iMTCachedLODLevel[2];
var const transient int m_iForcedLODLevel;
var int bForceRefpose;
var int bDisplayBones;
var int bHideSkin;
var int bForceRawOffset;
var int bIgnoreControllers;
var int bTransformFromAnimParent;
var transient int m_iInitAnimStatus;
var const int bUseSingleBodyPhysics;
var bool bUpdateSkelWhenNotRendered;
var bool bIgnoreControllersWhenNotRendered;
var bool bForceDiscardRootMotion;
var Material LimitMaterial;
var Vector RootMotionDelta;
var() SkeletalMeshComponent.ERootMotionMode RootMotionMode;
var transient int m_iDeltaYaw;
var transient bool m_bRootRotateYaw;
var transient bool m_bOldRootRotateYaw;
var transient bool m_bIsInRootMotion;
var transient bool m_bDoRootMotionAccel;
var transient bool m_bAnimTreeInitialized;
var transient bool m_bNotTickedLastFrame;
var array<name> m_DebugSequences;
var bool m_bDebugSequences;
var bool m_bFrozen;
var bool m_bInitAttachmentRBPhys;
var array<Matrix> m_RagdollRecord;
var Map_Mirror m_AnimSequenceMap;

// Export USkeletalMeshComponent::execAttachComponent(FFrame&, void* const)
native final function AttachComponent(ActorComponent Component, name BoneName, optional Vector RelativeLocation, optional Rotator RelativeRotation, optional Vector RelativeScale);

// Export USkeletalMeshComponent::execDetachComponent(FFrame&, void* const)
native final function DetachComponent(ActorComponent Component);

// Export USkeletalMeshComponent::execAttachComponentToSocket(FFrame&, void* const)
native final function AttachComponentToSocket(ActorComponent Component, name SocketName);

// Export USkeletalMeshComponent::execAttachComponentSocketToSocket(FFrame&, void* const)
native final function AttachComponentSocketToSocket(SkeletalMeshComponent HisComponent, name HisSocketName, name MySocketName);

// Export USkeletalMeshComponent::execAttachComponentSocket(FFrame&, void* const)
native final function AttachComponentSocket(SkeletalMeshComponent HisComponent, name HisSocketName, name MyBone);

// Export USkeletalMeshComponent::execDeleteAnimTree(FFrame&, void* const)
native final function DeleteAnimTree();

// Export USkeletalMeshComponent::execGetSocketWorldLocationAndRotation(FFrame&, void* const)
native final function bool GetSocketWorldLocationAndRotation(name InSocketName, out Vector OutLocation, optional out Rotator OutRotation);

// Export USkeletalMeshComponent::execGetSocketByName(FFrame&, void* const)
native final function SkeletalMeshSocket GetSocketByName(name InSocketName);

// Export USkeletalMeshComponent::execFindComponentAttachedToBone(FFrame&, void* const)
native final function ActorComponent FindComponentAttachedToBone(name InBoneName);

// Export USkeletalMeshComponent::execIsComponentAttached(FFrame&, void* const)
native final function bool IsComponentAttached(ActorComponent Component);

// Export USkeletalMeshComponent::execSetSkeletalMesh(FFrame&, void* const)
native final simulated function SetSkeletalMesh(SkeletalMesh NewMesh);

// Export USkeletalMeshComponent::execFindAnimSequence(FFrame&, void* const)
native final function AnimSequence FindAnimSequence(name AnimSeqName);

final function float GetAnimRateByDuration(name AnimSeqName, float Duration)
{
    local AnimSequence AnimSeq;

    AnimSeq = FindAnimSequence(AnimSeqName);
    // End:0x22
    if(AnimSeq == none)
    {
        return 1.0000000;
    }
    return AnimSeq.SequenceLength / Duration;
    return;
}

// Export USkeletalMeshComponent::execFindMorphTarget(FFrame&, void* const)
native final function MorphTarget FindMorphTarget(name MorphTargetName);

// Export USkeletalMeshComponent::execFindSkelControl(FFrame&, void* const)
native final function SkelControlBase FindSkelControl(name InControlName);

// Export USkeletalMeshComponent::execFindMorphNode(FFrame&, void* const)
native final function MorphNodeBase FindMorphNode(name InNodeName);

// Export USkeletalMeshComponent::execDrawAnimDebug(FFrame&, void* const)
native final function DrawAnimDebug(Canvas Canvas, name StartingPoint, int iOffsetX, int iOffsetY, bool m_bAnimDebugRelevantOnly);

// Export USkeletalMeshComponent::execGetBoneQuaternion(FFrame&, void* const)
native final function Quat GetBoneQuaternion(name BoneName, optional int Space);

// Export USkeletalMeshComponent::execGetBoneLocation(FFrame&, void* const)
native final function Vector GetBoneLocation(name BoneName, optional int Space);

// Export USkeletalMeshComponent::execSetAnimTreeTemplate(FFrame&, void* const)
native final function SetAnimTreeTemplate(AnimNode NewTemplate);

// Export USkeletalMeshComponent::execSetParentAnimComponent(FFrame&, void* const)
native final function SetParentAnimComponent(SkeletalMeshComponent NewParentAnimComp);

// Export USkeletalMeshComponent::execUpdateParentBoneMap(FFrame&, void* const)
native final function UpdateParentBoneMap();

// Export USkeletalMeshComponent::execInitSkelControls(FFrame&, void* const)
native final function InitSkelControls();

// Export USkeletalMeshComponent::execFindConstraintIndex(FFrame&, void* const)
native final function int FindConstraintIndex(name ConstraintName);

// Export USkeletalMeshComponent::execFindConstraintBoneName(FFrame&, void* const)
native final function name FindConstraintBoneName(int constraintIndex);

// Export USkeletalMeshComponent::execForceSkelUpdate(FFrame&, void* const)
native final function ForceSkelUpdate();

// Export USkeletalMeshComponent::execBeginPlayInitAnimTree(FFrame&, void* const)
native final function BeginPlayInitAnimTree();
