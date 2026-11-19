class MOHAAnimScaleRateByDesiredSpeed extends AnimNodeScalePlayRate
    native
    hidecategories(Object,Object,Object,Object);

var transient AnimNodeSequence SpeedBasisAnim;
var() name SpeedBasisAnimName;
var() float BaseSpeed;
var const transient float AvgRootMotionSpeed;
var const transient float AvgRootMotionSpeedRecip;
var(ScalePreview) transient float DesiredSpeed;

defaultproperties
{
    BaseSpeed=415.0000000
    DesiredSpeed=100.0000000
}