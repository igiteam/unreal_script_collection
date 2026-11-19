class SPPathNode extends PathNode
    native;

struct native PoseClassMatch
{
    var() class<SPPawn> classType;
    var() name PoseName;

    structdefaultproperties
    {
        classType=none
        PoseName="None"
    }
};

struct native WallForcedPath
{
    var NavReference NavRef;
    var name AnimationName;

    structdefaultproperties
    {
        NavRef=none
        AnimationName="None"
    }
};

struct native WallForcedPathInfo
{
    var ActorReference ActorRef;
    var name AnimationName;

    structdefaultproperties
    {
        ActorRef=none
        AnimationName="None"
    }
};

var bool m_bDisallowGriffonLanding;
var() bool m_bScoutForcedPaths;
var bool bControlledByWallHelper;
var transient bool bBeingObservedByWallPathReport;
var() float m_maxNeighborhoodDistance;
var() float m_maxNeighborhoodFullLOSDistance;
var() float m_maxNeighborhoodPartialLOSDistance;
var() float m_maxNeighborhoodNoLOSDistance;
var() float m_maxNeighborhoodNoLOSIntermediateDistance;
/** this is required on the base class since we need to control how normal ground path nodes connect to wall path nodes */
var(WallProperties) array<SPWallPathNodeProperty> WallPathProperties;
var(WallProperties) array<PoseClassMatch> ForcedIncomingPoses;
var(WallProperties) array<PoseClassMatch> ForcedOutgoingPoses;
var(WallProperties) array<PoseClassMatch> ExcludedIncomingPoses;
var(WallProperties) array<PoseClassMatch> ExcludedOutgoingPoses;
var deprecated array<WallForcedPath> WallForcedPaths;
var deprecated array<WallForcedPath> WallProscribedPaths;
var array<WallForcedPathInfo> WallForcedPathList;
var array<WallForcedPathInfo> WallProscribedPathList;
var Vector lastAutoPositionLocation;
var SPPathNode PairedHelperNode;
var editoronly SPWallPathPlacementHelper HelperNode;
var transient Vector KyLoc;
var int KyVertexIDs[8];

event bool SuggestMovePreparation(Pawn Pawn)
{
    // End:0x32
    if(Pawn.IsA('SPPawn'))
    {
        SPPawn(Pawn).PrepareForNavPoint(self);
    }
    return true;
    //return ReturnValue;    
}
