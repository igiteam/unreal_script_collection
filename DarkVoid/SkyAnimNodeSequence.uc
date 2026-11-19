class SkyAnimNodeSequence extends AnimNodeSequence
    native
    editinlinenew;

struct native SkyAnimNotifyEvent
{
    var() editinline AnimNotify Notify;
    var() name Comment;

    structdefaultproperties
    {
        Notify=none
        Comment="None"
    }
};

struct native SkyAnimSynchRegistration
{
    var name Id;
    var SkyAnimNodeSequence Node;

    structdefaultproperties
    {
        Id="None"
        Node=none
    }
};

var() editinline array<editinline SkyAnimNotifyEvent> PreNotifies;
var() editinline array<editinline SkyAnimNotifyEvent> PostNotifies;
var() bool bSetRootMotionMode;
var() bool bFireNotifiesOnBlendReversal;
var transient bool bUseAdvanceOverrideTime;
var transient bool bFiredEarlyEndAnim;
var() bool bFireAnimEndEarly;
var() bool bUseSequenceStartTime;
var() bool bMirrorSequence;
var() SkeletalMeshComponent.ERootMotionMode RootMotionMode;
var() SkeletalMeshComponent.ERootMotionRotationMode RootMotionRotationMode;
var transient SkeletalMeshComponent.ERootMotionMode PrevRootMotionMode;
var transient array<SkyAnimNotify_Reversible> NotifiesToReverse;
var transient float NodeTotalWeightPrev;
var transient float NodeTotalWeightDeltaPrev;
var transient float AdvanceOverrideTime;
var() float EarlyEndAnimTime;
var() float SequenceStartTime;
var() name SynchId;
var transient float SynchTime;

// Export USkyAnimNodeSequence::execOnEndAnimNotify(FFrame&, void* const)
native function OnEndAnimNotify();

// Export USkyAnimNodeSequence::execPlayAnim(FFrame&, void* const)
native function PlayAnim(optional bool bLoop = false, optional float InRate = 1.0000000, optional float StartTime = 0.0000000);

// Export USkyAnimNodeSequence::execIsNodeMirrored(FFrame&, void* const)
native function bool IsNodeMirrored();
