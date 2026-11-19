class SkyBTNode_Act_MoveTowardDisturbance extends SkyBTNode_Leaf_Action
    native;

enum MTDisturbanceType
{
    MTD_ClosestDisturbance,         // 0
    MTD_MostRecentDisturbance,      // 1
    MTD_MAX                         // 2
};

var(Investigate) float DistanceFromTarget;
var(Investigate) SkyBTNode_Act_MoveTowardDisturbance.MTDisturbanceType DisturbanceType;
var transient Vector DisturbanceLocation;
var transient int DisturbanceID;
