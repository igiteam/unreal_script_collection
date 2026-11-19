class SkelControlLookAt extends SkelControlBase
    native
    hidecategories(Object);

var(LookAt) Vector TargetLocation;
var(LookAt) SkelControlBase.EBoneControlSpace TargetLocationSpace;
var(LookAt) Object.EAxis LookAtAxis;
var(LookAt) Object.EAxis UpAxis;
var(LookAt) name TargetSpaceBoneName;
var(LookAt) bool bInvertLookAtAxis;
var(LookAt) bool bDefineUpAxis;
var(LookAt) bool bInvertUpAxis;
var(Limit) bool bEnableLimit;
var(Limit) bool bLimitBasedOnRefPose;
var(Limit) bool bDisableBeyondLimit;
var(Limit) bool bShowLimit;
var bool bOutOfReach;
var(LookAt) float TargetLocationInterpSpeed;
var Vector DesiredTargetLocation;
var Vector LimitLookDir;
var(Limit) float MaxAngle;
var(Limit) float DeadZoneAngle;
var(LookAt) float m_fTimeBeforeEnabling;
var Vector vForceDirection;
var Vector vRealTargetLocation;
var float m_fTimeSinceLastDisabled;

simulated function InterpolateTargetLocation(float DeltaTime)
{
    TargetLocation = VInterpTo(TargetLocation, DesiredTargetLocation, TargetLocationInterpSpeed, DeltaTime);
    return;
}

defaultproperties
{
    LookAtAxis=1
    UpAxis=4
    bLimitBasedOnRefPose=true
    bShowLimit=true
    TargetLocationInterpSpeed=10.0000000
    m_fTimeBeforeEnabling=3.0000000
    m_fTimeSinceLastDisabled=3.0000000
}