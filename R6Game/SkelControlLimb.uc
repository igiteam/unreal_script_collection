class SkelControlLimb extends SkelControlBase
    native
    hidecategories(Object);

var(Effector) Vector EffectorLocation;
var(Effector) SkelControlBase.EBoneControlSpace EffectorLocationSpace;
var(Joint) SkelControlBase.EBoneControlSpace JointTargetLocationSpace;
var(Limb) Object.EAxis BoneAxis;
var(Limb) Object.EAxis JointAxis;
var(Effector) name EffectorSpaceBoneName;
var(Joint) Vector JointTargetLocation;
var(Joint) name JointTargetSpaceBoneName;
var(Limb) bool bInvertBoneAxis;
var(Limb) bool bInvertJointAxis;
var(Limb) bool bMaintainEffectorRelRot;

defaultproperties
{
    BoneAxis=1
    JointAxis=2
}