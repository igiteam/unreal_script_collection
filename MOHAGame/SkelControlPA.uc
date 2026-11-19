class SkelControlPA extends SkelControlLOD
    native
    hidecategories(Object);

struct native CCPATarget
{
    var() name Id;
    var() Vector Position;
    var() float Weight;

    structdefaultproperties
    {
        Id="Undefined"
        Position=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Weight=1.0000000
    }
};

var() CCRig Rig;
var private transient array<SkelControlPALookAt> RigBoneControls;
var() private editconst transient CCAttitude Attitude;
var() transient CCAttitude NextAttitude;
var private transient CCAttitude SrcAttitude;
var private transient CCAttitude DstAttitude;
var private transient CCAttitude BlendAttitude;
var private transient CCAttitude DefaultAttitude;
var() transient bool bVerbose;
var(LookAt) transient bool bAddRandomTargets;
var(LookAt) private transient bool bClearTargets;
var(LookAt) transient bool bSuspendLookAt;
var(LookAt) transient bool bEditCurrentLookAt;
var private transient bool bBlinkRegisterDeclared;
var() transient bool bSimulateInGameBehavior;
var(LookAt) int NumRandomTargets;
var(LookAt) float RandomTargetDistance;
var(LookAt) transient array<CCPATarget> Targets;
var private transient int TargetIndex;
var(LookAt) transient int EditIndex;
var private transient name TargetId;
var private transient float LookatDuration;
var private transient float TurnSpeedVariance;
var private transient float Blink;
var private transient float BlinkIntervalStart;
var private transient float BlinkIntervalEnd;
var private transient float BlinkBreakPeriod;
var transient float AttitudeStartTime;
var private transient float TargetStartTime;
var transient float GlobalClock;
var() transient CCPerformanceSet2.ERestrictionLevel RestrictionLevel;
var transient Vector ViewDirection;

function PostBeginPlay()
{
    NextAttitude = none;
    bVerbose = false;
    bAddRandomTargets = false;
    TargetIndex = -1;
    EditIndex = -1;
    bClearTargets = false;
    bSuspendLookAt = false;
    bEditCurrentLookAt = true;
    Blink = 0.0000000;
    BlinkIntervalStart = 0.0000000;
    BlinkIntervalEnd = 0.0000000;
    BlinkBreakPeriod = 1.0000000;
    bBlinkRegisterDeclared = false;
    TargetStartTime = 0.0000000;
    GlobalClock = 0.0000000;
    bSimulateInGameBehavior = false;
    RestrictionLevel = 0;
    //return;    
}

event LA()
{
    //return;    
}

function int GetCurrentTargetIndex()
{
    local int Index;

    Index = 0;
    J0x07:

    // End:0x46 [Loop If]
    if(Index < Targets.Length)
    {
        // End:0x3C
        if(Targets[Index].Id == TargetId)
        {
            return Index;
        }
        Index++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    //return ReturnValue;    
}

function SetRestrictionLevel(CCPerformanceSet2.ERestrictionLevel Level)
{
    RestrictionLevel = Level;
    //return;    
}

defaultproperties
{
    DefaultAttitude=CCAttitude'MOHA_CC_PA.Attitudes.Default'
    bEditCurrentLookAt=true
    NumRandomTargets=10
    RandomTargetDistance=100.0000000
    TargetIndex=-1
    EditIndex=-1
    BlinkBreakPeriod=1.0000000
}