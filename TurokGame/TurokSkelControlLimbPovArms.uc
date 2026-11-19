class TurokSkelControlLimbPovArms extends SkelControlLimb
    native
    hidecategories(Object);

var(PovArm) bool mbLeftArm;

defaultproperties
{
    mbLeftArm=true
    EffectorLocationSpace=1
    JointTargetLocationSpace=5
    BoneAxis=2
    JointAxis=1
    EffectorSpaceBoneName="jt_Root_C"
    JointTargetSpaceBoneName="jt_Elbow_L"
}