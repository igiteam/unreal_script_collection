class SkyBTNode_Act_FindCover extends SkyBTNode_Leaf_Action
    native;

enum FindCoverOperation
{
    FCO_FindCoverOnly,              // 0
    FCO_FindCoverThenMoveTo,        // 1
    FCO_FindCoverMoveToAndEnter,    // 2
    FCO_MAX                         // 3
};

var(CoverSearch) float MinDistanceFromEnemy;
var(CoverSearch) float MaxDistanceFromEnemy;
var(CoverSearch) float MinDistanceFromBot;
var(CoverSearch) float MaxDistanceFromBot;
var(CoverSearch) SkyBot.EFindCoverSearchType SearchRatingType;
var(CoverSearch) SkyBTNode.E_MeOrEnemy CoverRelativeTo;
var(CoverSearch) SkyBot.BTTypeOfCover CoverTypePreference;
var(CoverUsage) SkyBTNode_Act_FindCover.FindCoverOperation FindCoverOp;
var(CoverSearch) bool bAllowCoverToBePastEnemyLocation;
var(CoverInvalidated) bool bAbortIfCoverInvalidated;
var(CoverSearch) Vector CoverCone_Direction;
var(CoverSearch) float CoverCone_Angle;
var transient CoverSlotMarker FoundCoverMarker;
