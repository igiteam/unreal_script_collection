class TurokSeqAct_CameraShake extends SequenceAction
    hidecategories(Object);

enum EShakePresets
{
    ESP_Small,                      // 0
    ESP_Medium,                     // 1
    ESP_Large,                      // 2
    ESP_EarthQuake,                 // 3
    ESP_Vibrator,                   // 4
    ESP_Jostle,                     // 5
    ESP_JostleA,                    // 6
    ESP_Custom,                     // 7
    ESP_MAX                         // 8
};

var() byte mShakeType;
var() export editinline @NULL mCurveParams;
var export editinline array mPresets;
var() bool mbDamper;
var() bool mbTranslationNoise;
var() bool mbRotationNoise;
var(Noise) export editinline @NULL mRotationNoise;
var(Noise) export editinline @NULL mTranslationNoise;
var() float mTranslationDampen;
var() float mRotationDampen;

function FillOutParametricShake(out @NULL S)
{
    // End:0xB4
    if(int(mShakeType) == int(7))
    {
        S.mShakeComponent.mParams = mCurveParams.mParams;
        S.mLifeTime = mCurveParams.mParams.mLifeTime;
        S.mTranslationDampen = mTranslationDampen;
        S.mRotationDampen = mRotationDampen;
        S.mbTranslationNoise = mbTranslationNoise;
        S.mbRotationNoise = mbRotationNoise;        
    }
    else
    {
        S.mShakeComponent.mParams = mPresets[int(mShakeType)].mParams;
        S.mLifeTime = mPresets[int(mShakeType)].mParams.mLifeTime;
        S.mTranslationDampen = mPresets[int(mShakeType)].mParams.mTranslationDampen;
        S.mRotationDampen = mPresets[int(mShakeType)].mParams.mRotationDampen;
        S.mRotationNoise.mMax = mPresets[int(mShakeType)].mParams.mRotNoiseMax;
        S.mRotationNoise.mMin = mPresets[int(mShakeType)].mParams.mRotNoiseMin;
        S.mTranslationNoise.mMax = mPresets[int(mShakeType)].mParams.mTranNoiseMax;
        S.mTranslationNoise.mMin = mPresets[int(mShakeType)].mParams.mTranNoiseMin;
        S.mRotationNoise.BuildCurve();
        S.mTranslationNoise.BuildCurve();
    }
    S.mbDamper = mbDamper;
    //return;    
}

defaultproperties
{
    // Reference: TurokParametricShakeComponent'Default__TurokSeqAct_CameraShake.ShakeComponent'
    begin object name=ShakeComponent class=Class'TurokParametricShakeComponent'
    end object
    mCurveParams=ShakeComponent
    mPresets=/* Array type was not detected. */
    mbDamper=true
    mbTranslationNoise=true
    mbRotationNoise=true
    // Reference: TurokSmoothNoise'Default__TurokSeqAct_CameraShake.RotNoise'
    begin object name=RotNoise class=Class'TurokEngine.TurokSmoothNoise'
        mMax=1.4000000
        mMin=0.5000000
        mNumSamplePoints=10
    end object
    mRotationNoise=RotNoise
    // Reference: TurokSmoothNoise'Default__TurokSeqAct_CameraShake.TranNoise'
    begin object name=TranNoise class=Class'TurokEngine.TurokSmoothNoise'
        mMin=0.4000000
        mNumSamplePoints=10
    end object
    mTranslationNoise=TranNoise
    mTranslationDampen=0.7500000
    mRotationDampen=0.7500000
    ObjName="Camera Shake"
    ObjCategory="Turok Cinema"
}