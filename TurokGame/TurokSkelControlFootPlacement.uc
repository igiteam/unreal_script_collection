class TurokSkelControlFootPlacement extends SkelControlFootPlacement
    native
    hidecategories(Object,Effector);

var transient bool mbPerformIK;
var transient bool mbCorrectOrientation;
var transient array mBoneIndexLookup;
var transient int mFootIndex;
var transient int mToe0Index;
var transient int mToe1Index;
var native const @NULL mIKOffsets;
var transient @NULL mFootPlantPos;
var transient @NULL mToePlantPos0;
var transient @NULL mToePlantPos1;
var transient @NULL mFootNormal;
var transient float mHeightAdjustment;
var transient int mNumberOfChildBones;
var transient float mUpdateDelta;
var transient @NULL mDeltaFootOrient;
var transient float mLODSimpleDisplayFactor;
var transient float mLODDisableDisplayFactor;

defaultproperties
{
    mFootIndex=-1
    mDeltaFootOrient=(X=0.0000000,Y=0.0000000,Z=0.0000000,W=1.0000000)
    FootOffset=7.5000000
    FootUpAxis=2
    MaxUpAdjustment=30.0000000
    MaxDownAdjustment=20.0000000
    JointTargetLocationSpace=2
    BoneAxis=2
    JointAxis=1
    bInvertBoneAxis=true
    ControlStrength=0.0000000
}