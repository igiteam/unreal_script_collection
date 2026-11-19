class SeqAct_ANTSMoveToPath extends SeqAct_AIMoveToActor
    native;

struct native FloatOverride
{
    /** INCLUDES MACROS STRUCT DECLARATIONS */
    var() bool bOverride;
    /** INCLUDES MACROS STRUCT DECLARATIONS */
    var(OverrideValue) float Value;

    structdefaultproperties
    {
        bOverride=false
        Value=0.0000000
    }
};

/** VARIABLE DECLARATIONS */
var(ANTS) EnableOverride bKillAtEndOfPath;
var(ANTSPathInfo) array<Actor> pathPoints;
var(ANTSPathInfo) EnableOverride bLoopPath;
var(ANTSPathInfo) EnableOverride bUsePathOffset;
var(ANTSPathInfo) EnableOverride bFollowPathHeight;
var(ANTSPathInfo) EnableOverride bFollowPathPitch;
var(ANTSPathInfo) EnableOverride bFollowPathRoll;
var(ANTSPathInfo) EnableOverride bForceGroundHeightChecks;
var(ANTSPathInfo) FloatOverride moveSpeedFPS;
var(ANTSPathInfo) FloatOverride moveSpeedFPSVariance;
var(ANTSPathInfo) FloatOverride fSmoothHandleFactor;
var(ANTSPathInfo) FloatOverride fCheckGroundHeightInterval;
