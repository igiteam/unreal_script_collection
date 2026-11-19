class SkyBTNode_Cond_CheckPhysics extends SkyBTNode_Leaf_Condition
    native;

var(CheckPhysics) Actor.EPhysics PhysicsType;
var(CheckPhysics) SkyBTNode.BT_COMPARISON_OPERATOR Operator;
var(CheckPhysics) SkyBTNode.E_MeOrEnemy TargetSelection;
