class MOHAAnimBlendByAngle extends AnimNodeBlendList
    native
    hidecategories(Object,Object,Object);

var float AngleDegrees;
var bool bAngleIsSet;

// Export UMOHAAnimBlendByAngle::execSetAngle(FFrame&, void* const)
native function SetAngle(float NewAngleDegrees);
