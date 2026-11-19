class SkyBTNode_Act_Flee extends SkyBTNode_Leaf_Action
    native;

enum FleeFromTargetType
{
    FFT_CurrentEnemy,               // 0
    FFT_ClosestEnemy,               // 1
    FFT_ClosestDangerItem,          // 2
    FFT_CurrentTestTarget,          // 3
    FFT_ClosestDisturbance,         // 4
    FFT_MostRecentDisturbance,      // 5
    FFT_MAX                         // 6
};

var(FleeFrom) float MinDistanceFromTarget;
var(FleeFrom) float MaxDistanceFromTarget;
var(FleeFrom) float MinDistanceFromMe;
var(FleeFrom) SkyBTNode_Act_Flee.FleeFromTargetType FleeFromTarget;
var(FleeFrom) float DangerRange;
var transient Actor FleeFromActor;
