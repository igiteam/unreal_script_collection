class SkyCameraNodeBlendByNearestTarget extends SkyCameraNodeBlendList
    native;

enum ECameraBlendByNearestTarget
{
    CamBlendByNearestTarget_Off,    // 0
    CamBlendByNearestTarget_On,     // 1
    CamBlendByNearestTarget_MAX     // 2
};

var transient bool bPickNewTarget;
var transient bool bForceInit;
var transient int LastActiveChild;
var transient Rotator InitialCamRot;
var transient Rotator InitialConstraintToCamRot;
var transient float InitialActiveWeight;
