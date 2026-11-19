class MOHAAnimBlendByActivity extends MOHAAnimActivityBase
    native
    hidecategories(Object,Object,Object);

enum EActivityIndices
{
    ACTIVITYNODE_TRANSITION,        // 0
    ACTIVITYNODE_DEATH,             // 1
    ACTIVITYNODE_MAX                // 2
};

struct native TransitionElement
{
    var() editinline AnimActivities.EOIRActivityName eSrcActivityName;
    var() editinline AnimActivities.EOIRActivityPose eSrcActivityPose;
    var() editinline name transitionAnim;
    var() editinline AnimActivities.EOIRActivityName eDstActivityName;
    var() editinline AnimActivities.EOIRActivityPose eDstActivityPose;
    var name srcActivityName;
    var name srcActivityPose;
    var name dstActivityName;
    var name dstActivityPose;

    structdefaultproperties
    {
        eSrcActivityName=0
        eSrcActivityPose=0
        transitionAnim="None"
        eDstActivityName=0
        eDstActivityPose=0
        srcActivityName="None"
        srcActivityPose="None"
        dstActivityName="None"
        dstActivityPose="None"
    }
};

struct native CorePoseMapping
{
    var() editinline AnimActivities.EOIRActivityName eReferenceActivityName;
    var() editinline AnimActivities.EOIRActivityPose eReferenceActivityPose;
    var() editinline AnimActivities.EOIRActivityName eDerivativeActivityName;
    var() editinline AnimActivities.EOIRActivityPose eDerivativeActivityPose;
    var name referenceActivityName;
    var name referenceActivityPose;
    var name derivativeActivityName;
    var name derivativeActivityPose;

    structdefaultproperties
    {
        eReferenceActivityName=0
        eReferenceActivityPose=0
        eDerivativeActivityName=0
        eDerivativeActivityPose=0
        referenceActivityName="None"
        referenceActivityPose="None"
        derivativeActivityName="None"
        derivativeActivityPose="None"
    }
};

struct native CorePose
{
    var() editinline AnimActivities.EOIRActivityName eCorePoseActivityName;
    var() editinline AnimActivities.EOIRActivityPose eCorePoseActivityPose;
    var int pad;

    structdefaultproperties
    {
        eCorePoseActivityName=0
        eCorePoseActivityPose=0
        pad=0
    }
};

struct native TransitionSequence
{
    var() editinline AnimActivities.EOIRActivityName eSequenceSrcActivityName;
    var() editinline AnimActivities.EOIRActivityPose eSequenceSrcActivityPose;
    var() editinline AnimActivities.EOIRActivityName eSequenceDstActivityName;
    var() editinline AnimActivities.EOIRActivityPose eSequenceDstActivityPose;
    var name srcActivityName;
    var name srcActivityPose;
    var name dstActivityName;
    var name dstActivityPose;
    var() editinline array<editinline CorePose> CorePoses;
    var editinline array<editinline int> TransitionElements;

    structdefaultproperties
    {
        eSequenceSrcActivityName=0
        eSequenceSrcActivityPose=0
        eSequenceDstActivityName=0
        eSequenceDstActivityPose=0
        srcActivityName="None"
        srcActivityPose="None"
        dstActivityName="None"
        dstActivityPose="None"
        CorePoses=none
        TransitionElements=none
    }
};

var() name DefaultActivity;
var transient int DefaultActivityIndex;
var transient name PrevActivityName;
var transient name PrevActivityPose;
var transient bool bForceSelectChild;
var() bool bActivitiesTranslateOIR;
var() float AimOffsetInfluenceLerpTime;
var() float TransitionBlendTime;
var() editinline array<editinline TransitionElement> TransitionList;
var() editinline array<editinline CorePoseMapping> CorePoseMappings;
var() editinline array<editinline TransitionSequence> TransitionSequences;
var array<int> SequenceTransition;

event OnBecomeRelevant()
{
    local MOHAAIPawn Pawn;

    // End:0x6A
    if((SkelComponent != none) && SkelComponent.Owner != none)
    {
        Pawn = MOHAAIPawn(SkelComponent.Owner);
        // End:0x6A
        if(Pawn != none)
        {
            Pawn.ActiveOIR.SetActivityNode(self);
            bForceSelectChild = true;
        }
    }
    //return;    
}

event OnSetActiveChild(int ChildIndex, float InBlendTime)
{
    local MOHAAIPawn Pawn;

    // End:0xF4
    if((SkelComponent != none) && SkelComponent.Owner != none)
    {
        Pawn = MOHAAIPawn(SkelComponent.Owner);
        // End:0xF4
        if(Pawn != none)
        {
            // End:0x6C
            if(ChildIndex != 0)
            {
                Pawn.ActiveOIR.CurrentActivityStarted();
            }
            // End:0xF4
            if(none != Pawn.CCP)
            {
                Pawn.CCP.SetBodyState_Activity(Pawn.ActiveOIR.OIRAnimTree.Name, Pawn.ActiveOIR.GetCurrentActivityName(), Pawn.ActiveOIR.GetCurrentActivityPose());
            }
        }
    }
    //return;    
}

defaultproperties
{
    AimOffsetInfluenceLerpTime=0.3000000
    TransitionBlendTime=0.3000000
    BlendTime=0.0000000
    Children=/* Array type was not detected. */
}