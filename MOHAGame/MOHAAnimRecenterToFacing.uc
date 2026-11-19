class MOHAAnimRecenterToFacing extends MOHAAnimActivityBase
    native
    hidecategories(Object,Object,Object);

enum eChildNum
{
    CHILD_DEFAULT,                  // 0
    CHILD_TURN_LEFT,                // 1
    CHILD_TURN_RIGHT,               // 2
    CHILD_MAX                       // 3
};

var transient MOHA_NPCAiming AimOffsetNode;
var transient bool bIsRecentering;
var() float RecenterStrideDeltaYawDeg;
var() float RecenterRotationRateYaw;
var() float RecenterLeftThresholdYawDeg;
var() float RecenterRightThresholdYawDeg;

event OnInit()
{
    super(AnimNode).OnInit();
    AimOffsetNode = MOHA_NPCAiming(Children[0].Anim);
    SetActiveChild(0, 0.0000000);
    bIsRecentering = false;
    //return;    
}

defaultproperties
{
    RecenterStrideDeltaYawDeg=90.0000000
    RecenterRotationRateYaw=45000.0000000
    RecenterLeftThresholdYawDeg=30.0000000
    RecenterRightThresholdYawDeg=-60.0000000
    BlendTime=0.1000000
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}