class AnimNodeTransition extends SkyAnimNodeSequence
    native
    editinlinenew;

var bool bInTransition;
var bool bEditMode;
var bool bLoopTransition;
var bool bLoopToAnim;
var bool OriginalbSetRootMotionMode;
var() bool bDisableTransitions;
var() bool bUseGroundSpeedScale;
var int TransitionState;
var float BlendSequenceWeight;
var float BlendTimeToGo;
var transient AnimTransition Transition;
var int InputLockState;
var AnimNodeSequence.ERootBoneAxis OriginalRootBoneOption[3];
var AnimNodeSequence.ERootRotationOption OriginalRootRotationOption[3];
var SkeletalMeshComponent.ERootMotionMode OriginalRootMotionMode;
var SkeletalMeshComponent.ERootMotionRotationMode OriginalRootMotionRotationMode;
var() int Group;
