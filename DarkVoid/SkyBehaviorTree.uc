class SkyBehaviorTree extends SkyBTNode_Blend
    native
    config(AI);

struct native VariablePair
{
    var init string VarName;
    var float VarValue;

    structdefaultproperties
    {
        VarName=""
        VarValue=0.0000000
    }
};

var(BehaviorTreeDebugging) config bool bEnableDebugging;
var editoronly transient bool bBeingEdited;
var transient bool bRequiresReindex;
var transient bool bRequiresExternalEventApplyNextTick;
var transient FileWriter BTDebugFile;
var transient SkyBot OwnerController;
var transient Pawn OwnerPawn;
var transient Actor BTTestTarget;
var editoronly array<SkyBTComment> EditorComments;
var editoronly float DefaultViewX;
var editoronly float DefaultViewY;
var editoronly float DefaultViewZoom;
var int Debug_TreeUID;
var private transient array<SkyBTNode_Leaf> ScheduledTasks;
var init private transient array<init string> LockedResources;
var private transient array<VariablePair> MetaVariables;

// Export USkyBehaviorTree::execStartup(FFrame&, void* const)
native final function Startup();

// Export USkyBehaviorTree::execShutDown(FFrame&, void* const)
native final function ShutDown();
