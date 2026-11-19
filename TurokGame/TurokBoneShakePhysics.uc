class TurokBoneShakePhysics extends Object
    native;

var int mBoneIndex;
var @NULL mPosition;
var @NULL mVelocity;
var @NULL mTargetPos;
var export editinline @NULL mSkelComp;
var() @NULL mBoneLocalOffset;
var() name mBoneName;
var() float mFirmness;
var() float mDamping;
var() float mMaxDistance;
var() float mXMax;
var() float mXMin;
var() float mYMax;
var() float mYMin;
var() float mZMax;
var() float mZMin;
var() float mResetDistance;
var private float mTimeStep;

// Export UTurokBoneShakePhysics::execUpdate(FFrame&, void* const)
native simulated function Update(float DeltaSeconds);

defaultproperties
{
    mBoneIndex=-1
    mFirmness=40.0000000
    mDamping=0.8000000
    mMaxDistance=100.0000000
    mXMax=5000.0000000
    mXMin=-5000.0000000
    mYMax=5000.0000000
    mYMin=-5000.0000000
    mZMax=5000.0000000
    mZMin=-5000.0000000
    mResetDistance=500.0000000
}