class ParticleModuleTypeDataPathFollowing extends ParticleModuleTypeDataBase
    native
    editinlinenew
    collapsecategories;

enum EParticleWeaveMethod
{
    EPNone,                         // 0
    EPHorizontal,                   // 1
    EPVertical,                     // 2
    EPCircularClockwise,            // 3
    EPCircularCounterClockwise,     // 4
    EParticleWeaveMethod_MAX        // 5
};

/**  
 *The amount to spin the emitter instance (in complete rotations) at
 *  the given time.
 */
var(PathInfo) bool IsAnimus;
var(PathInfo) bool UseParticleSystemInnerRangeSpeed;
var(PathInfo) bool UseInitialParticleSpeed;
var(PathInfo) Vector SourceLocation;
var(PathInfo) Vector TargetLocation;
var(PathInfo) float BaseVelocity;
var(PathInfo) float SourceSphereSpawnRadius;
var(PathInfo) float TargetSphereSpawnRadius;
var(PathInfo) float EditorTargetDistance;
var(PathInfo) float ParticleSystemSpeed;
var(PathInfo) float InitialParticleSpeed;
var(PathInfo) float InitialParticleSpeedTimeLength;
/** vector that changes curve left or right (will be based off of the right vector of player **SourceControlPoint) */
var(ControlPoint) float SourceControlPointHorizontalVec;
/** vector that changes curve up and down (will be based off of the up vector of player **SourceControlPoint) */
var(ControlPoint) float SourceControlPointVerticalVec;
/** vector that changes curve left or right (will be based off of the right vector of player **TargetControlPoint) */
var(ControlPoint) float TargetControlPointHorizontalVec;
/** vector that changes curve up and down (will be based off of the up vector of player **TargetControlPoint) */
var(ControlPoint) float TargetControlPointVerticalVec;
/** which weave pattern will be used */
var(WeaveOptions) ParticleModuleTypeDataPathFollowing.EParticleWeaveMethod ParticleWeaveOptions;
/** horizontal weave vector (If applicable) */
var(WeaveOptions) Vector HorizontalWeaveVec;
/** vertical weave vector (If applicable) */
var(WeaveOptions) Vector VerticalWeaveVec;
/** horizontal weave speed (If applicable) */
var(WeaveOptions) float HorizontalWeaveSpeed;
/** vertical weave speed (If applicable) */
var(WeaveOptions) float VerticalWeaveSpeed;
/** circular weave speed (If applicable) */
var(WeaveOptions) float CircularWeaveSpeed;
/** randomized value for control points */
var(WeaveOptions) float SourceHorizontalControlPointRange;
/** randomized value for control points */
var(WeaveOptions) float SourceVerticalControlPointRange;
/** randomized value for control points */
var(WeaveOptions) float TargetHorizontalControlPointRange;
/** randomized value for control points */
var(WeaveOptions) float TargetVerticalControlPointRange;
