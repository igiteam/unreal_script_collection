class SkyBTNode_Cond_IsInCover extends SkyBTNode_Leaf_Condition
    native;

var(Cover) SkyBTNode.E_MeOrEnemy TargetSelection;
var(Cover) SkyBot.BTTypeOfCover CoverType;
var(Cover) bool bCheckTypeOfCover;
var(Cover) bool bCheckOnlyIfCoverIsClaimed;
