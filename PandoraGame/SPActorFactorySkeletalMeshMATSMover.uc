class SPActorFactorySkeletalMeshMATSMover extends SPActorFactorySkeletalMeshMAT
    native
    config(Editor)
    editinlinenew
    collapsecategories;

var() bool bStartOnPath;
var() bool bKillAtEndOfPath;
var(PathInfo) bool bLoopPath;
var(PathInfo) bool bUsePathOffset;
var(PathInfo) bool bFollowPathHeight;
var(PathInfo) bool bFollowPathPitch;
var(PathInfo) bool bFollowPathRoll;
var(PathInfo) bool bForceGroundHeightChecks;
/** ** Disables all animation if mesh is not visible. Only use if you dont need anim notifies. */
var(Optimization) bool SpUpdateAnimTreeWhenNotRendered;
var(PathInfo) array<Actor> pathPoints;
var(PathInfo) Route pathRoute;
var(PathInfo) float moveSpeedFPS;
var(PathInfo) float moveSpeedFPSVariance;
var(PathInfo) float fSmoothHandleFactor;
var(PathInfo) float fCheckGroundHeightInterval;
/** ** If not zero, it reduces animation playback rate by this scale for objects in the far distance. */
var(Optimization) float SpAnimLodScaleForVisible;
/** ** If not zero, it reduces animation playback rate by this scale for objects offscreen. */
var(Optimization) float SpAnimLodScaleForInvisible;
