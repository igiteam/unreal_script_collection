class SkelControlWheel extends SkelControlSingleBone
    native
    hidecategories(Object,Translation,Rotation);

var(Wheel) transient float WheelDisplacement;
var(Wheel) float WheelMaxRenderDisplacement;
var(Wheel) transient float WheelRoll;
var(Wheel) Object.EAxis WheelRollAxis;
var(Wheel) Object.EAxis WheelSteeringAxis;
var(Wheel) transient float WheelSteering;
var(Wheel) bool bInvertWheelRoll;
var(Wheel) bool bInvertWheelSteering;

defaultproperties
{
    WheelMaxRenderDisplacement=50.0000000
    WheelRollAxis=1
    WheelSteeringAxis=4
    bAddTranslation=true
    bApplyRotation=true
    bAddRotation=true
    BoneTranslationSpace=4
    BoneRotationSpace=4
}