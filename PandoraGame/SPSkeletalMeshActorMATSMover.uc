class SPSkeletalMeshActorMATSMover extends SPSkeletalMeshActorMAT
    native;

/** INCLUDES MACROS STRUCT DECLARATIONS VARIABLE DECLARATIONS */
var() bool bStartOnPath;
var() bool bKillAtEndOfPath;
var(PathInfo) bool bLoopPath;
var(PathInfo) bool bUsePathOffset;
var(PathInfo) bool bFollowPathHeight;
var(PathInfo) bool bFollowPathPitch;
var(PathInfo) bool bFollowPathRoll;
var(PathInfo) bool bForceGroundHeightChecks;
var bool bFollowPath;
var(PathInfo) array<Actor> pathPoints;
var(PathInfo) Route pathRoute;
var(PathInfo) float moveSpeedFPS;
var(PathInfo) float moveSpeedFPSVariance;
var(PathInfo) float fSmoothHandleFactor;
var(PathInfo) float fCheckGroundHeightInterval;
var Vector pathOffset;
var float fT;
var float lastfTLen;
var float fGH0;
var float fGH1;
var float fRandGHCheckOffsetTime;
var Matrix matBezier;
var Matrix matBezierTangent;
var Rotator prevRotation;
var Rotator spAngularVelocity;

// Export USPSkeletalMeshActorMATSMover::execStartMoveOnPath(FFrame&, void* const)
native function bool StartMoveOnPath();

// Export USPSkeletalMeshActorMATSMover::execEndMoveOnPath(FFrame&, void* const)
native function bool EndMoveOnPath(bool bArrivedAtEndOfPath, optional SeqAct_ANTSMoveToPath currAction);

function PostBeginPlay()
{
    super.PostBeginPlay();
    prevRotation = Rotation;
    //return;    
}

function OnANTSMoveToPath(SeqAct_ANTSMoveToPath Action)
{
    local int Idx;
    local Actor destActor;
    local SeqVar_Object ObjVar;

    EndMoveOnPath(false, Action);
    // End:0x68
    foreach Action.LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Destination")
    {
        destActor = Actor(ObjVar.GetObjectValue());
        // End:0x67
        if(destActor != none)
        {
            // End:0x68
            break;
        }        
    }    
    // End:0xD4
    if(destActor != none)
    {
        pathRoute = Route(destActor);
        // End:0xA8
        if(pathRoute != none)
        {
            // End:0xA5
            if(pathRoute.RouteList.Length == 0)
            {
            }            
        }
        else
        {
            Idx = pathPoints.Length;
            pathPoints.Length = Idx + 1;
            pathPoints[Idx] = destActor;
        }
    }
    // End:0x118
    if((pathRoute == none) && pathPoints.Length == 0)
    {
        // End:0x118
        if(Action.pathPoints.Length > 0)
        {
            pathPoints = Action.pathPoints;
        }
    }
    // End:0x134
    if((pathRoute == none) && pathPoints.Length == 0)
    {        
    }
    else
    {
        // End:0x177
        if(Action.bKillAtEndOfPath.bOverride == true)
        {
            bKillAtEndOfPath = Action.bKillAtEndOfPath.Enable;
        }
        // End:0x1BA
        if(Action.bLoopPath.bOverride == true)
        {
            bLoopPath = Action.bLoopPath.Enable;
        }
        // End:0x1FD
        if(Action.bUsePathOffset.bOverride == true)
        {
            bUsePathOffset = Action.bUsePathOffset.Enable;
        }
        // End:0x240
        if(Action.bFollowPathHeight.bOverride == true)
        {
            bFollowPathHeight = Action.bFollowPathHeight.Enable;
        }
        // End:0x283
        if(Action.bFollowPathPitch.bOverride == true)
        {
            bFollowPathPitch = Action.bFollowPathPitch.Enable;
        }
        // End:0x2C6
        if(Action.bFollowPathRoll.bOverride == true)
        {
            bFollowPathRoll = Action.bFollowPathRoll.Enable;
        }
        // End:0x309
        if(Action.bForceGroundHeightChecks.bOverride == true)
        {
            bForceGroundHeightChecks = Action.bForceGroundHeightChecks.Enable;
        }
        // End:0x34A
        if(Action.moveSpeedFPS.bOverride == true)
        {
            moveSpeedFPS = Action.moveSpeedFPS.Value;
        }
        // End:0x38B
        if(Action.moveSpeedFPSVariance.bOverride == true)
        {
            moveSpeedFPSVariance = Action.moveSpeedFPSVariance.Value;
        }
        // End:0x3CC
        if(Action.fSmoothHandleFactor.bOverride == true)
        {
            fSmoothHandleFactor = Action.fSmoothHandleFactor.Value;
        }
        // End:0x40D
        if(Action.fCheckGroundHeightInterval.bOverride == true)
        {
            fCheckGroundHeightInterval = Action.fCheckGroundHeightInterval.Value;
        }
        // End:0x41D
        if((StartMoveOnPath()) == false)
        {
        }
    }
    //return;    
}
