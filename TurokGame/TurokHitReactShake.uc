class TurokHitReactShake extends TurokCameraModifier
    native
    hidecategories(Object);

var @NULL mSnapMotionCurve;
var @NULL mRecoverMotionCurve;
var float mRollAmp;
var float mYawAmp;
var float mPitchAmp;
var float mNeckLength;

// Export UTurokHitReactShake::execComputeNewRotation(FFrame&, void* const)
native function ComputeNewRotation(out @NULL RotationDelta);

// Export UTurokHitReactShake::execComputeNewTranslation(FFrame&, void* const)
native function ComputeNewTranslation(out @NULL TranslationDelta);

event ComputeNewRotationNonNative(out @NULL RotationDelta)
{
    local @NULL Amplitudes;

    Amplitudes = EvaluateRotation(PercentageComplete());
    RotationDelta.Yaw = int(Amplitudes.X * 182.0400000);
    RotationDelta.Pitch = int(Amplitudes.Y * 182.0400000);
    RotationDelta.Roll = int(Amplitudes.Z * 182.0400000);
    //return;    
}

event ComputeNewTranslationNonNative(out @NULL TranslationDelta)
{
    TranslationDelta.Y += (mNeckLength * Sin((mRollAmp * (EvaluateMotionCurve(PercentageComplete()))) * 0.0174533));
    TranslationDelta.Z -= (mNeckLength * (1.0000000 - Cos((mRollAmp * (EvaluateMotionCurve(PercentageComplete()))) * 0.0174533)));
    TranslationDelta.X = 0.0000000;
    //return;    
}

function InitReactShake(float RollAmp, float PitchAmp, float YawAmp)
{
    local array Points;

    Init();
    Points[0] = vect(0.0000000, 0.0000000, 0.0000000);
    Points[1] = vect(0.1000000, 1.0000000, 0.0000000);
    mSnapMotionCurve.Initialize(Points);
    Points[0] = vect(0.1000000, 1.0000000, 0.0000000);
    Points[1] = vect(0.6000000, 0.3500000, 0.0000000);
    Points[2] = vect(1.0000000, 0.0000000, 0.0000000);
    mRecoverMotionCurve.Initialize(Points);
    mRollAmp = RollAmp;
    mPitchAmp = PitchAmp;
    mYawAmp = YawAmp;
    //return;    
}

event float EvaluateMotionCurve(float Percentage)
{
    // End:0x2B
    if(Percentage >= 0.1000000)
    {
        return mRecoverMotionCurve.Evaluate(Percentage);        
    }
    else
    {
        return mSnapMotionCurve.Evaluate(Percentage);
    }
    //return ReturnValue;    
}

event @NULL EvaluateRotation(float Time)
{
    local @NULL Ret;

    Ret.X = mYawAmp * (EvaluateMotionCurve(Time));
    Ret.Y = mPitchAmp * (EvaluateMotionCurve(Time));
    Ret.Z = mRollAmp * (EvaluateMotionCurve(Time));
    return Ret;
    //return ReturnValue;    
}

function AddShakeDistance(float Distance)
{
    local float Skale;

    Skale = 1.0000000;
    Distance += (DistanceAt(PercentageComplete()));
    Skale = Distance / (DistanceAt(0.1000000));
    TotalTimeAlive = 0.1000000 * mLifeTime;
    mRollAmp *= Skale;
    mPitchAmp *= Skale;
    mYawAmp *= Skale;
    //return;    
}

function CapToDistance(float Distance)
{
    local float CurrentDistance;

    CurrentDistance = DistanceAt(PercentageComplete());
    // End:0x62
    if(CurrentDistance > Distance)
    {
        mYawAmp *= (Distance / CurrentDistance);
        mPitchAmp *= (Distance / CurrentDistance);
        mRollAmp *= (Distance / CurrentDistance);
    }
    //return;    
}

function float DistanceAt(float Time)
{
    return VSize(EvaluateRotation(Time));
    //return ReturnValue;    
}

defaultproperties
{
    // Reference: TurokCubicSpline'Default__TurokHitReactShake.SnapSpline'
    begin object name=SnapSpline class=Class'TurokEngine.TurokCubicSpline'
    end object
    mSnapMotionCurve=SnapSpline
    // Reference: TurokCubicSpline'Default__TurokHitReactShake.RecoverSpline'
    begin object name=RecoverSpline class=Class'TurokEngine.TurokCubicSpline'
    end object
    mRecoverMotionCurve=RecoverSpline
    mNeckLength=32.0000000
    mLifeTime=0.2500000
    mbDamper=false
    // Reference: TurokSmoothNoise'Default__TurokHitReactShake.RotNoise'
    begin object name=RotNoise
    end object
    mRotationNoise=RotNoise
    // Reference: TurokSmoothNoise'Default__TurokHitReactShake.TranNoise'
    begin object name=TranNoise
    end object
    mTranslationNoise=TranNoise
}