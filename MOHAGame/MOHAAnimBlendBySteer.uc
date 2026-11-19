class MOHAAnimBlendBySteer extends MOHAAnimBlendArray
    native
    hidecategories(Object,Object);

var(BlendPreview) float MatchDistance;
var transient int CycleIterations;
var transient float AvgRootMotionSpeed;
var(BlendPreview) transient float DesiredSpeed;

defaultproperties
{
    MatchDistance=1000.0000000
    DesiredSpeed=415.0000000
    AnimInfo[0]=-1.0000000
    AnimInfo[1]=-1.0000000
    Children=/* Array type was not detected. */
}