class SkyBTNode_Cond_CanSee extends SkyBTNode_Leaf_Condition
    native;

enum WhoSeesWhom
{
    WSW_CanISeeCurrentEnemy,        // 0
    WSW_CanCurrentEnemySeeMe,       // 1
    WSW_CanISeeCurrentTestTarget,   // 2
    WSW_CanCurrentTestTargetSeeMe,  // 3
    WSW_MAX                         // 4
};

var(Visibility) SkyBTNode_Cond_CanSee.WhoSeesWhom WhichTest;
var(Visibility) bool bResetCurrentEnemyIfLost;
