class SkyBTNode_Cond_TargetVelocityHeading extends SkyBTNode_Leaf_Condition
    native;

enum TargetVelocityHeadingType
{
    TVHT_CurrentEnemy,              // 0
    TVHT_ClosestEnemy,              // 1
    TVHT_CurrentTestTarget,         // 2
    TVHT_MAX                        // 3
};

var(Facing) float ToleranceDegrees;
var(Facing) SkyBTNode_Cond_TargetVelocityHeading.TargetVelocityHeadingType HeadingTargetSelection;
