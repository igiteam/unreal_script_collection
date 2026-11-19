class SkyBTNode_Cond_DistanceFromEnemy extends SkyBTNode_Leaf_Condition
    native;

var(DistanceCondition) float DistanceValue;
var(DistanceCondition) SkyBTNode.BT_COMPARISON_OPERATOR Operator;
var(DistanceCondition) SkyBTNode.E_MeOrEnemy TargetSelection;
