class SPPerformance extends SPAnimNodeSequence
    native;

enum ExitAction
{
    Through,                        // 0
    Branch,                         // 1
    Restart,                        // 2
    End,                            // 3
    ExitAction_MAX                  // 4
};

struct native RotTransInfo
{
    /** This structure groups information about rotation and translation for each animation. */
    var() AnimNodeSequence.ERootBoneAxis TranslateX;
    /** This structure groups information about rotation and translation for each animation. */
    var() AnimNodeSequence.ERootBoneAxis TranslateY;
    /** This structure groups information about rotation and translation for each animation. */
    var() AnimNodeSequence.ERootBoneAxis TranslateZ;
    /** This structure groups information about rotation and translation for each animation. */
    var() AnimNodeSequence.ERootBoneAxis RotationYaw;
    /** This structure groups information about rotation and translation for each animation. */
    var() AnimNodeSequence.ERootBoneAxis RotationPitch;
    /** This structure groups information about rotation and translation for each animation. */
    var() AnimNodeSequence.ERootBoneAxis RotationRoll;

    structdefaultproperties
    {
        TranslateX=RBA_Default
        TranslateY=RBA_Default
        TranslateZ=RBA_Default
        RotationYaw=RBA_Default
        RotationPitch=RBA_Default
        RotationRoll=RBA_Default
    }
};

struct native PerformanceAnimInfo
{
    /** Character class. */
    var() class<SPPawn> Class;
    /** Animation we play. */
    var() name animation;
    /** Rotation and Translation flags. */
    var() RotTransInfo rotTransExtract;

    structdefaultproperties
    {
        Class=none
        animation="None"
        rotTransExtract=(TranslateX=RBA_Default,TranslateY=RBA_Default,TranslateZ=RBA_Default,RotationYaw=RBA_Default,RotationPitch=RBA_Default,RotationRoll=RBA_Default)
    }
};

struct native PerformanceBranchInfo
{
    /** The label we could branch to. */
    var() string Label;
    /** The percentage chance we will take this branch. */
    var() int Percent;

    structdefaultproperties
    {
        Label=""
        Percent=0
    }
};

struct native PerformaceState
{
    /** This struct contains information about which animation to play, how many times to play it, the percentage chance to play it, and what to do afterwards */
    var() string Label;
    /** This struct contains information about which animation to play, how many times to play it, the percentage chance to play it, and what to do afterwards */
    var() name animation;
    /** This struct contains information about which animation to play, how many times to play it, the percentage chance to play it, and what to do afterwards */
    var() array<PerformanceAnimInfo> Animations;
    /** This struct contains information about which animation to play, how many times to play it, the percentage chance to play it, and what to do afterwards */
    var() RotTransInfo rotTransExtract;
    /** This struct contains information about which animation to play, how many times to play it, the percentage chance to play it, and what to do afterwards */
    var() int Percent;
    /** This struct contains information about which animation to play, how many times to play it, the percentage chance to play it, and what to do afterwards */
    var() int minLoopCount;
    /** This struct contains information about which animation to play, how many times to play it, the percentage chance to play it, and what to do afterwards */
    var() int maxLoopCount;
    /** This struct contains information about which animation to play, how many times to play it, the percentage chance to play it, and what to do afterwards */
    var() SPPerformance.ExitAction ExitAction;
    /** This struct contains information about which animation to play, how many times to play it, the percentage chance to play it, and what to do afterwards */
    var() array<PerformanceBranchInfo> branchInfo;

    structdefaultproperties
    {
        Label=""
        animation="None"
        Animations=none
        rotTransExtract=(TranslateX=RBA_Default,TranslateY=RBA_Default,TranslateZ=RBA_Default,RotationYaw=RBA_Default,RotationPitch=RBA_Default,RotationRoll=RBA_Default)
        Percent=0
        minLoopCount=0
        maxLoopCount=0
        ExitAction=Through
        branchInfo=none
    }
};

struct native PerformanceInfo
{
    /** Alternate character class. */
    var() class<SPPawn> Class;
    /** ID used to synchronize this PNode with another. */
    var() int interPNodeID;
    /** List of conditions that must be met through LogicModifiers for this performance to execute */
    var() deprecated array<string> Conditions;
    /** List of conditions that must be met through LogicModifiers for this performance to execute */
    var() array<int> EvaluatorConditions;
    /** Just a friendly name for this performance. */
    var() string Description;
    /** Array of all states. */
    var() array<PerformaceState> States;

    structdefaultproperties
    {
        Class=none
        interPNodeID=-1
        EvaluatorConditions=none
        Description=""
        States=none
    }
};

/** The list of all performances */
var() array<PerformanceInfo> performances;
/** The name displayed above node in anim tree. */
var() string nodeDisplayName;
/** Just change this to run the validation routine. Variables to help animators copy data. */
var() bool changeToValidate;
/** Change this in the editor to copy the states. Variables to keep track of the progress used in the cpp file. */
var() transient bool copyPerformanceExecute;
var transient bool running;
var transient bool hitEnd;
/** The performance we want to copy from. */
var() transient int copyPerformanceFrom;
/** The performance we want to copy to. */
var() transient int copyPerformanceTo;
var transient int currState;
var transient int loopsToDo;
var transient int completedLoops;
var transient int interPNodeID;
var transient int currPerformance;

// Export USPPerformance::execSetInterPNodeID(FFrame&, void* const)
native final function SetInterPNodeID(int Id);
