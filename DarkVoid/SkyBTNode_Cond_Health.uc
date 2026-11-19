class SkyBTNode_Cond_Health extends SkyBTNode_Leaf_Condition
    native;

var(HealthCondition) float HealthPercent;
var(HealthCondition) SkyBTNode.E_MeOrEnemy HealthSource;
var(HealthCondition) SkyBTNode.BT_COMPARISON_OPERATOR Operator;
