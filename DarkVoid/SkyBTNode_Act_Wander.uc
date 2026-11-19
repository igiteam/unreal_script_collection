class SkyBTNode_Act_Wander extends SkyBTNode_Leaf_Action
    native;

enum WanderDir
{
    W_Forward,                      // 0
    W_Sideways,                     // 1
    W_Backward,                     // 2
    W_MAX                           // 3
};

var(WanderProbabilities) float WanderDirProbability;
var(WanderProbabilities) SkyBTNode_Act_Wander.WanderDir WanderDirection;
var(Wander) bool bCompleteOnReachedNode;
var(Wander) bool bSkipRecentlyVisitedNodes;
var(WanderProbabilities) bool bPreferSkyJumpPaths;
var(Wander) float MinWanderDistance;
var(Wander) float MaxWanderDistance;
var(WanderProbabilities) float JumpProbability;
var(WanderProbabilities) float MantleProbability;
var(WanderProbabilities) float FlyProbability;
var transient NavigationPoint LastExploredNodes[4];
var transient int ExploredNodeIdx;
