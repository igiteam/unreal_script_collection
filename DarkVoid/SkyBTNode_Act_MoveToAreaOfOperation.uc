class SkyBTNode_Act_MoveToAreaOfOperation extends SkyBTNode_Leaf_Action
    native;

var transient float Dummy;
var(MoveToAO) SkyBTNode.E_MeOrEnemy TargetSelection;
var(MoveToAO) float MoveDistance;
var NavigationPoint ClosestAOPoint;
