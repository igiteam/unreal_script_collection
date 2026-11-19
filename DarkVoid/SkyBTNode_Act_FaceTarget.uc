class SkyBTNode_Act_FaceTarget extends SkyBTNode_Leaf_Action
    native;

enum FaceTargetType
{
    FTT_CurrentEnemy,               // 0
    FTT_ClosestEnemy,               // 1
    FTT_ClosestDisturbance,         // 2
    FTT_MostRecentDisturbance,      // 3
    FTT_CurrentTestTarget,          // 4
    FTT_ScriptedTarget,             // 5
    FTT_ScriptedFireTarget,         // 6
    FTT_ClosestDestructibleCoverToMe,// 7
    FTT_ClosestDestructibleCoverToCurrentEnemy,// 8
    FTT_MAX                         // 9
};

var(Facing) float MaxOffsetAngleFromFacing;
var transient float AcosForDot;
var(Facing) bool bAlignPawnRotation;
var(Facing) SkyBTNode_Act_FaceTarget.FaceTargetType FaceTargetSelection;
