class SkyBTNode_Act_SetDangle extends SkyBTNode_Leaf_Action
    native;

enum E_DangleSelection
{
    DS_Me,                          // 0
    DS_PawnsGrippingMe,             // 1
    DS_CurrentTestTarget,           // 2
    DS_MAX                          // 3
};

var() GripDangleInfo GripDangleData;
var() SkyBTNode_Act_SetDangle.E_DangleSelection TargetSelection;
