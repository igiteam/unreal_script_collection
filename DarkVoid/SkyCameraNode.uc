class SkyCameraNode extends SkyCameraTreeObject
    abstract
    native;

var transient array<SkyCameraNodeBlendBase> ParentNodes;
var() name NodeName;
var bool bNodeTickStatus;
var() bool bSkipTickWhenBlendingOut;
var const transient bool bRelevant;
var const float NodeTotalWeight;
var const transient float TotalWeightAccumulator;
var const float NodeTotalOffsetWeight;
var const transient float TotalOffsetWeightAccumulator;
var int DrawWidth;
var int DrawHeight;
var int NodePosX;
var int NodePosY;
var int OutDrawY;
var const transient float PrevNodeTotalWeight;

event OnInit()
{
    //return;    
}

event OnCeaseRelevant()
{
    //return;    
}

// Export USkyCameraNode::execFindCameraNode(FFrame&, void* const)
native final function SkyCameraNode FindCameraNode(name InNodeName);

// Export USkyCameraNode::execFindCameraNodes(FFrame&, void* const)
native final function FindCameraNodes(class<SkyCameraNode> NodeType, out array<SkyCameraNode> out_Nodes);
