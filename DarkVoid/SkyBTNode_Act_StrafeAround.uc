class SkyBTNode_Act_StrafeAround extends SkyBTNode_Leaf_Action
    native;

var(Strafe) float MinStrafingDistance;
var(Strafe) float MaxStrafingDistance;
var(Strafe) float MinKeepAwayDistance;
var(Strafe) float MaxKeepAwayDistance;
var(Strafe) float ProbabilityToPickNewStrafeDir;
var(Strafe) SkyBTNode.E_MeOrEnemy TargetSelection;
var(Strafe) SkyBTNode.E_LeftRight ForceDirection;
var int LastSelectedDirection;
