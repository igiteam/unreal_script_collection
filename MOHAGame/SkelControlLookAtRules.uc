class SkelControlLookAtRules extends SkelControlLOD
    native
    hidecategories(Object);

var() transient CCLookAtRuleBase LookAtRule;
var() int MaxTargets;
var() editconst transient array<editconst CCTarget> Targets;
var private transient bool bSelectedInEditor;
var() transient bool bSuspendLookAt;
var() transient bool bEditCurrentLookAt;
var() transient bool bVerbose;
var() transient bool bLogToCSV;
var private transient bool bLogToCSVPrev;
var() transient int EditIndex;
var transient int TargetIndex;
var transient name TargetId;
var() name PAControlName;
var export editinline transient CCPerformerNative Performer;
var private native const Pointer CSVFileHandle;

// Export USkelControlLookAtRules::execOpenCSVLog(FFrame&, void* const)
native final function OpenCSVLog();

// Export USkelControlLookAtRules::execCloseCSVLog(FFrame&, void* const)
native final function CloseCSVLog();

// Export USkelControlLookAtRules::execWriteCSVLog(FFrame&, void* const)
native final function WriteCSVLog(string Line);

function PostBeginPlay(CCPerformerNative InPerformer)
{
    LookAtRule = none;
    TargetIndex = -1;
    EditIndex = -1;
    bSelectedInEditor = false;
    bSuspendLookAt = false;
    bEditCurrentLookAt = false;
    bVerbose = false;
    Performer = InPerformer;
    bLogToCSV = false;
    bLogToCSVPrev = false;
    //return;    
}

defaultproperties
{
    MaxTargets=100
    EditIndex=-1
    TargetIndex=-1
    PAControlName="PA"
}