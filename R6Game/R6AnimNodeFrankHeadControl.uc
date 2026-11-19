class R6AnimNodeFrankHeadControl extends AnimNodeBlendList
    native
    hidecategories(Object,Object,Object,Object);

struct FrankHeadControlParameters
{
    var Vector mBaseLookatPoint;
    var float mFieldOfVisionCenterAttraction;
    var float mBlinkFrequency;
    var float mSaccadeFrequency;
    var float mHeadSpeed;
    var float mEyeSpeed;
    var float mVerticalEyeOffset;
    var float mHeadDeepTranslation;
    var float mContextualHorizontalEyeOffset;
    var float mContextualHeadRoll;
    var float mContextualHeadLateralTranslation;
    var bool m_bHasFacial;

    structdefaultproperties
    {
        mBaseLookatPoint=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mFieldOfVisionCenterAttraction=0.0000000
        mBlinkFrequency=0.0000000
        mSaccadeFrequency=0.0000000
        mHeadSpeed=0.0000000
        mEyeSpeed=0.0000000
        mVerticalEyeOffset=0.0000000
        mHeadDeepTranslation=0.0000000
        mContextualHorizontalEyeOffset=0.0000000
        mContextualHeadRoll=0.0000000
        mContextualHeadLateralTranslation=0.0000000
        m_bHasFacial=false
    }
};

var FrankHeadControlParameters mParams;
var array<BoneAtom> mCurrentPose;
var array<BoneAtom> mPrevPose;
var array<BoneAtom> mPPrevPose;
var array<BoneAtom> mTargetPose;
var array<BoneAtom> mIntermediateTargetPose;
var array<BoneAtom> mPrevIntermediateTargetPose;
var array<BoneAtom> mTempGlobalPose;
var Vector mPrevBaseLookatPoint;
var Vector mSmoothedLookatPoint;
var Vector mPrevSmoothedLookatPoint;
var Vector mSaccadeLookatPoint;
var Vector mNetLookatPoint;
var Vector mPrevNetLookatPoint;
var float mHeadDirHorizontalNoise;
var float mPrevHeadDirHorizontalNoise;
var float mHeadDirVerticalNoise;
var float mPrevHeadDirVerticalNoise;
var float mHeadRollNoise;
var float mPrevHeadRollNoise;
var Vector mTargetGlobalHeadDir;
var float mHysteresisSide;
var float mHysteresisTransitionValue;
var float mPrevHysteresisTransitionValue;
var float mHeadLateralTranslation;
var float mHeadRoll;
var float mHorizontalEyeOffset;
var int mDemoMode;
var int mNbFramesSinceLastBlink;
var int mNbFramesSinceLastSaccade;
var float mEyebrowRise;
var float mPrevEyebrowRise;
var Vector mBetweenEyesPoint;
var float m_fTimeSinceSameLookat;
var float m_fMaxTimeSameLookat;
var float m_fRandomLookatTimeLeft;
var float m_fMaxLookatRandom;
var bool m_bIsSameLookat;
var Vector m_vPrevFocus;
var float m_RandomYawLimit;
var float m_RandomPitchLimit;
var() float m_fLimitsToClamp;
var() float m_fPlayerSpeedModifier;
var() float m_fWeight;
var() float m_fBlendInTime;
var() float m_fBlendOutTime;

defaultproperties
{
    m_fMaxTimeSameLookat=5.0000000
    m_fMaxLookatRandom=3.0000000
    m_RandomYawLimit=1.2000000
    m_RandomPitchLimit=0.6000000
    m_fLimitsToClamp=-0.0100000
    m_fPlayerSpeedModifier=1.5000000
    m_fWeight=1.0000000
    m_fBlendInTime=0.2700000
    m_fBlendOutTime=0.2000000
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}