class SkyBTNode extends Object
    abstract
    native;

enum BT_STATUS
{
    BTSTATUS_INIT,                  // 0
    BTSTATUS_SUCCESS,               // 1
    BTSTATUS_FAILED_CLEANLY,        // 2
    BTSTATUS_FAILED_UNEXPECTED,     // 3
    BTSTATUS_RUNNING,               // 4
    BTSTATUS_MAX                    // 5
};

enum BT_COMPARISON_OPERATOR
{
    BT_EQUAL,                       // 0
    BT_GREATER_THAN,                // 1
    BT_LESS_THAN,                   // 2
    BT_GREATER_OR_EQUAL,            // 3
    BT_LESS_OR_EQUAL,               // 4
    BT_NOT_EQUAL,                   // 5
    BT_MAX                          // 6
};

enum E_MeOrEnemy
{
    MOE_CurrentEnemy,               // 0
    MOE_ClosestEnemy,               // 1
    MOE_GrippingEnemy,              // 2
    MOE_Me,                         // 3
    MOE_CurrentTestTarget,          // 4
    MOE_ScriptedTarget,             // 5
    MOE_ScriptedFireTarget,         // 6
    MOE_CurrentFireTarget,          // 7
    MOE_SquadLeader,                // 8
    MOE_ClosestDestructibleCoverToMe,// 9
    MOE_ClosestDestructibleCoverToCurrentEnemy,// 10
    MOE_MainPlayerCharacter,        // 11
    MOE_MAX                         // 12
};

enum E_LeftRight
{
    ELR_None,                       // 0
    ELR_Left,                       // 1
    ELR_Right,                      // 2
    ELR_MAX                         // 3
};

var protected SkyBehaviorTree BehaviorTree;
var SkyBTNode_Blend ParentNode;
var() name NodeName;
var SkyBTNode.BT_STATUS LastStatus;
var editoronly transient SkyBTNode.BT_STATUS DebugStatus;
var() editconst int DebugNodeID;
var editoronly int DrawWidth;
var editoronly int DrawHeight;
var editoronly int NodePosX;
var editoronly int NodePosY;
var editoronly int OutDrawY;
var(Editor) editoronly Color DrawNodeColor;

// Export USkyBTNode::execFindBTNode(FFrame&, void* const)
native final function SkyBTNode FindBTNode(name InNodeName);

// Export USkyBTNode::execFindBTNodes(FFrame&, void* const)
native final function FindBTNodes(class<SkyBTNode> NodeType, out array<SkyBTNode> out_Nodes);
