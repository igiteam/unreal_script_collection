class TurokSkelControlLimb extends SkelControlLimb
    native
    hidecategories(Object);

var(PullVector) bool mbComputePullVector;
var(IKOffset) bool mbUseIKOffsetFromAuxBone;
var(IKOffset) name mIKOffsetBone;
var transient float mLODDisableDisplayFactor;

defaultproperties
{
    mbComputePullVector=true
    mbUseIKOffsetFromAuxBone=true
    mIKOffsetBone="jt_Aux2_C"
    EffectorLocationSpace=2
    JointTargetLocationSpace=2
    BoneAxis=2
    JointAxis=1
    bInvertBoneAxis=true
    bInvertJointAxis=true
    ControlStrength=0.0000000
    StrengthTarget=0.0000000
}