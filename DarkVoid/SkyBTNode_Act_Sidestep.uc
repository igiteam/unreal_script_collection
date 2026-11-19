class SkyBTNode_Act_Sidestep extends SkyBTNode_Leaf_Action
    native;

var(Sidestep) float MinSidestepDistance;
var(Sidestep) float MaxSidestepDistance;
var(Sidestep) float ProbabilityToPickNewSidestepDir;
var(Sidestep) SkyBTNode.E_MeOrEnemy TargetSelection;
var(Sidestep) SkyBTNode.E_LeftRight ForceDirection;
var int LastSelectedDirection;
