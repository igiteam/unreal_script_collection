class SkyBTNode_Cond_IsInteracting extends SkyBTNode_Leaf_Condition
    native;

enum E_InteractionCheckType
{
    ICT_ANY,                        // 0
    ICT_MOVING_TO_GRIP_POINT,       // 1
    ICT_MOVING_BETWEEN_GRIP_POINTS, // 2
    ICT_MOVING_FROM_GRIP_POINT,     // 3
    ICT_INTERACTING_WITH_GRIP_POINT,// 4
    ICT_MAX                         // 5
};

var(Interacting) SkyBTNode.E_MeOrEnemy TargetSelection;
var(Interacting) SkyBTNode_Cond_IsInteracting.E_InteractionCheckType InteractionCheckType;
