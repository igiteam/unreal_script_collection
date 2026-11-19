class SkyCameraTree extends SkyCameraNodeBlendBase
    native;

enum EAngleDiffDir
{
    EADD_None,                      // 0
    EADD_Pos,                       // 1
    EADD_Neg,                       // 2
    EADD_MAX                        // 3
};

enum EAutoPitchState
{
    EAPS_Idle,                      // 0
    EAPS_Waiting,                   // 1
    EAPS_Pitching,                  // 2
    EAPS_MAX                        // 3
};

struct native SPreviewMesh
{
    var() SkeletalMesh Mesh;
    var export editinline SkeletalMeshComponent MeshComponent;
    var() Vector Location;
    var() Rotator Rotation;
    var() name Anim;
    var() array<AnimSet> AnimSets;
    var() bool IgnoreRootMotion;
    var() float CollisionRadius;
    var() float CollisionHeight;

    structdefaultproperties
    {
        Mesh=none
        MeshComponent=none
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rotation=(Pitch=0,Yaw=0,Roll=0)
        Anim="None"
        AnimSets=none
        IgnoreRootMotion=false
        CollisionRadius=0.0000000
        CollisionHeight=0.0000000
    }
};

struct native SAlignControllerInfo
{
    var float TotalWeightStart;
    var float TotalWeight;
    var float TotalWeightPrev;
    var Rotator ConstraintRot;
    var bool bInitialized;
    var Quat ControllerRotStart;
    var SkyCameraTreeObject.EAlignControllerMode AlignControllerMode;
    var Rotator DeltaRotPrev;

    structdefaultproperties
    {
        TotalWeightStart=0.0000000
        TotalWeight=0.0000000
        TotalWeightPrev=0.0000000
        ConstraintRot=(Pitch=0,Yaw=0,Roll=0)
        bInitialized=false
        ControllerRotStart=(X=0.0000000,Y=0.0000000,Z=0.0000000,W=0.0000000)
        AlignControllerMode=EACM_None
        DeltaRotPrev=(Pitch=0,Yaw=0,Roll=0)
    }
};

struct native SAutoPitchInfo
{
    var SkyCameraTree.EAutoPitchState CurrState;
    var float WaitTime;
    var float WaitTimer;
    var float Time;
    var int MinAngle;
    var float StartTime;
    var int BeginPitch;
    var float Speed;

    structdefaultproperties
    {
        CurrState=EAPS_Idle
        WaitTime=0.0000000
        WaitTimer=0.0000000
        Time=0.0000000
        MinAngle=0
        StartTime=0.0000000
        BeginPitch=0
        Speed=0.0000000
    }
};

struct native SPreviousJointRotation
{
    var export editinline SkeletalMeshComponent SkelMesh;
    var name JointName;
    var Rotator Rotation;

    structdefaultproperties
    {
        SkelMesh=none
        JointName="None"
        Rotation=(Pitch=0,Yaw=0,Roll=0)
    }
};

struct native SCachedJointLocationAndRotation
{
    var QWord Frame;
    var export editinline SkeletalMeshComponent SkelMesh;
    var name JointName;
    var Vector Location;
    var Rotator Rotation;

    structdefaultproperties
    {
        Frame=none
        SkelMesh=none
        JointName="None"
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rotation=(Pitch=0,Yaw=0,Roll=0)
    }
};

struct native SAlignRotInfo
{
    var Quat Rot;
    var float Weight;

    structdefaultproperties
    {
        Rot=(X=0.0000000,Y=0.0000000,Z=0.0000000,W=0.0000000)
        Weight=0.0000000
    }
};

var editoronly array<SkyCameraTreeComment> EditorComments;
var transient bool bBeingEdited;
var editoronly bool bEditorUseSimCam;
var bool bPlayerInputAllowed;
var bool bAlignController;
var bool bAlignControllerAutoPitch;
var bool bIsBlending;
var bool bInterpolatingSlots;
var bool bInterpWaiting;
var const transient bool bTargetTransInProgress;
var const transient bool bWaitingForBlend;
var bool bInCoverLastFrame;
var bool bMantlingLastFrame;
var bool bLedgeJumpingLastFrame;
var bool bSwatTurningLastFrame;
var bool bSlidingLastFrame;
var() editoronly SPreviewMesh PreviewPlayer;
var() editoronly SPreviewMesh PreviewVehicle;
var() editoronly SPreviewMesh PreviewExternal;
var editoronly Rotator ControllerRot;
var() float AspectRatio;
var Vector PreviewCamPos;
var Rotator PreviewCamRot;
var Vector PreviewFloorPos;
var int PreviewFloorYaw;
var() float ZeroRollDegreesPerSec;
var float ZeroRollAnglePerSec;
var() float ZeroRollMinTime;
var Pawn CachedPawn;
var Pawn CachedDriver;
var array<SAlignControllerInfo> AlignControllerInfo;
var SAutoPitchInfo AutoPitchInfo;
var const transient Rotator PrevBlendingDelta;
var transient SkyPawn MostRecentMeleeTarget;
var transient Vehicle MostRecentHijackTarget;
var transient SkyCoverCameraActor MostRecentCoverCamera;
var Vector vMostRecentHijackTargetLoc;
var Rotator rMostRecentHijackTargetRot;
var Rotator rVerticalRotOffset;
var Rotator CurrCoverSlotRot;
var Rotator CurrCoverSlotModifiedRot;
var float fInterpAlpha;
var Rotator InterpSlotStartRot;
var float fInterpTime;
var float fInterpStartTime;
var Vector vMatineeCamStoredLoc;
var Rotator rMatineeCamStoredRot;
var float DefaultViewX;
var float DefaultViewY;
var float DefaultViewZoom;
var float fTargetTransTime;
var float fTargetTransTimer;
var float fTargetTransThreshold;
var() float fTargetTransTraceLength;
var() float fTargetTransMinTraceHitDistIn;
var() float fTargetTransMinTraceHitDistOut;
var Vector vTargetTransFocusLoc;
var transient array<SPreviousJointRotation> PreviousJointRotations;
var duplicatetransient native const array<SkyCameraNode> CamTickArray;
var duplicatetransient native const array<SkyCameraNodeView> CamViewNodes;
var duplicatetransient native const array<SkyCameraNodeBlendByFlightInput> CamFlightNodes;
var transient SCachedJointLocationAndRotation CachedJointLocationAndRotation;

// Export USkyCameraTree::execConvertCameraInfoToMatrix(FFrame&, void* const)
native final function Rotator ConvertCameraInfoToMatrix(out s_CameraTransformInfo CameraInfo, out Matrix newMatrix);

// Export USkyCameraTree::execStartTargetingTransition(FFrame&, void* const)
native function StartTargetingTransition(float fMinTraceHitDist);
