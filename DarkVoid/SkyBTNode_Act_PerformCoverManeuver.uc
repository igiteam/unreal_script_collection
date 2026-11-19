class SkyBTNode_Act_PerformCoverManeuver extends SkyBTNode_Leaf_Action
    native;

enum CoverManeuverType
{
    CMT_PlainExit,                  // 0
    CMT_DiveRoll,                   // 1
    CMT_Slip,                       // 2
    CMT_Mantle,                     // 3
    CMT_SwatTurn,                   // 4
    CMT_MAX                         // 5
};

var(CoverManeuver) bool bFallbackToExit;
var(CoverManeuver) SkyBTNode_Act_PerformCoverManeuver.CoverManeuverType MoveType;
