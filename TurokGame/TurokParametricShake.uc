class TurokParametricShake extends TurokCameraModifier
    native
    hidecategories(Object);

var() export editinline @NULL mShakeComponent;

// Export UTurokParametricShake::execComputeNewRotation(FFrame&, void* const)
native function ComputeNewRotation(out @NULL RotationDelta);

// Export UTurokParametricShake::execComputeNewTranslation(FFrame&, void* const)
native function ComputeNewTranslation(out @NULL TranslationDelta);

function SetShakeComponent(@NULL sc)
{
    mShakeComponent.mParams = sc.mParams;
    //return;    
}

function PlayShake(@NULL Component, float Duration)
{
    TotalTimeAlive = 0.0000000;
    mLifeTime = Duration;
    SetShakeComponent(Component);
    mTranslationDampen = Component.mParams.mTranslationDampen;
    mRotationDampen = Component.mParams.mRotationDampen;
    mRotationNoise.mMax = Component.mParams.mRotNoiseMax;
    mRotationNoise.mMin = Component.mParams.mRotNoiseMin;
    mTranslationNoise.mMax = Component.mParams.mTranNoiseMax;
    mTranslationNoise.mMin = Component.mParams.mTranNoiseMin;
    mRotationNoise.BuildCurve();
    mTranslationNoise.BuildCurve();
    EnableModifier();
    //return;    
}

defaultproperties
{
    // Reference: TurokParametricShakeComponent'Default__TurokParametricShake.Shakey'
    begin object name=Shakey class=Class'TurokParametricShakeComponent'
    end object
    mShakeComponent=Shakey
    // Reference: TurokSmoothNoise'Default__TurokParametricShake.RotNoise'
    begin object name=RotNoise
    end object
    mRotationNoise=RotNoise
    // Reference: TurokSmoothNoise'Default__TurokParametricShake.TranNoise'
    begin object name=TranNoise
    end object
    mTranslationNoise=TranNoise
}