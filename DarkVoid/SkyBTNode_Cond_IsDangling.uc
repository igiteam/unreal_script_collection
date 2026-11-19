class SkyBTNode_Cond_IsDangling extends SkyBTNode_Leaf_Condition
    native;

enum E_DanglingCheckType
{
    DCT_ANY,                        // 0
    DCT_GRIP_DANGLING,              // 1
    DCT_COVER_DANGLING,             // 2
    DCT_MAX                         // 3
};

var(Dangling) SkyBTNode.E_MeOrEnemy TargetSelection;
var(Dangling) SkyBTNode_Cond_IsDangling.E_DanglingCheckType CheckType;
