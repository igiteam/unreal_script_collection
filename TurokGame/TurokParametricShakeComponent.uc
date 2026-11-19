class TurokParametricShakeComponent extends Component
    native
    collapsecategories
    hidecategories(Object,ActorComponent);

struct native ShakeParams
{
    var(Rotation) float mRollAmplitude;
    var(Rotation) float mRollFrequency;
    var(Rotation) float mPitchAmplitude;
    var(Rotation) float mPitchFrequency;
    var(Rotation) float mYawAmplitude;
    var(Rotation) float mYawFrequency;
    var(Translation) float mXAmplitude;
    var(Translation) float mXFrequency;
    var(Translation) float mYAmplitude;
    var(Translation) float mYFrequency;
    var(Translation) float mZAmplitude;
    var(Translation) float mZFrequency;
    var(Time) float mLifeTime;
    var float mRotationDampen;
    var float mTranslationDampen;
    var float mRotNoiseMax;
    var float mRotNoiseMin;
    var float mTranNoiseMax;
    var float mTranNoiseMin;

    structdefaultproperties
    {
        mRollAmplitude=4.0000000
        mRollFrequency=5.0000000
        mPitchAmplitude=4.0000000
        mPitchFrequency=7.0000000
        mYawAmplitude=6.0000000
        mYawFrequency=10.0000000
        mXAmplitude=2.0000000
        mXFrequency=2.0000000
        mYAmplitude=2.0000000
        mYFrequency=2.0000000
        mZAmplitude=5.0000000
        mZFrequency=1.0000000
        mLifeTime=1.2500000
        mRotationDampen=0.7500000
        mTranslationDampen=0.7500000
        mRotNoiseMax=1.0000000
        mRotNoiseMin=0.4000000
        mTranNoiseMax=1.0000000
        mTranNoiseMin=0.4000000
    }
};

var(ShakeParams) @NULL mParams;

defaultproperties
{
    mParams=(mRollAmplitude=4.0000000,mRollFrequency=5.0000000,mPitchAmplitude=4.0000000,mPitchFrequency=7.0000000,mYawAmplitude=6.0000000,mYawFrequency=10.0000000,mXAmplitude=2.0000000,mXFrequency=2.0000000,mYAmplitude=2.0000000,mYFrequency=2.0000000,mZAmplitude=5.0000000,mZFrequency=1.0000000,mLifeTime=1.2500000,mRotationDampen=0.7500000,mTranslationDampen=0.7500000,mRotNoiseMax=1.0000000,mRotNoiseMin=0.4000000,mTranNoiseMax=1.0000000,mTranNoiseMin=0.4000000)
}