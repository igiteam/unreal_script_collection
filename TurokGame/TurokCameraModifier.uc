class TurokCameraModifier extends CameraModifier
    native
    hidecategories(Object);

enum EPlayMode
{
    EPM_Once,                       // 0
    EPM_Looping,                    // 1
    EPM_Continuous,                 // 2
    EPM_MAX                         // 3
};

var float TotalTimeAlive;
var() float mLifeTime;
var() bool mbDamper;
var() bool mbTranslationNoise;
var() bool mbRotationNoise;
var() byte mPlayMode;
var(Noise) export editinline @NULL mRotationNoise;
var(Noise) export editinline @NULL mTranslationNoise;
var() float mTranslationDampen;
var() float mRotationDampen;
var @NULL RotationCache;
var @NULL TranslationCache;

// Export UTurokCameraModifier::execDampenShake(FFrame&, void* const)
native function DampenShake(out @NULL Rotation, out @NULL Translation);

// Export UTurokCameraModifier::execComputeNewRotation(FFrame&, void* const)
native function ComputeNewRotation(out @NULL RotationDelta);

// Export UTurokCameraModifier::execComputeNewTranslation(FFrame&, void* const)
native function ComputeNewTranslation(out @NULL TranslationDelta);

// Export UTurokCameraModifier::execPercentageComplete(FFrame&, void* const)
native function float PercentageComplete();

// Export UTurokCameraModifier::execComputeShakeValue(FFrame&, void* const)
native function float ComputeShakeValue(float Amp, float Freq);

// Export UTurokCameraModifier::execModifyCamera(FFrame&, void* const)
native function bool ModifyCamera(@NULL Camera, float DeltaTime, out @NULL OutPOV);

// Export UTurokCameraModifier::execUpdateTime(FFrame&, void* const)
native function UpdateTime(float DeltaTime);

// Export UTurokCameraModifier::execIsDone(FFrame&, void* const)
native function bool IsDone();

// Export UTurokCameraModifier::execComputeDamper(FFrame&, void* const)
native function float ComputeDamper();

event RemoveModifier()
{
    // End:0x21
    if(CameraOwner != none)
    {
        RemoveCameraModifier(CameraOwner);
        CameraOwner = none;
    }
    //return;    
}

function Init()
{
    super.Init();
    mRotationNoise.BuildCurve();
    mTranslationNoise.BuildCurve();
    TotalTimeAlive = 0.0000000;
    //return;    
}

function bool AddCameraModifier(@NULL Camera)
{
    return super.AddCameraModifier(Camera);
    //return ReturnValue;    
}

function EnableModifier()
{
    super.EnableModifier();
    //return;    
}

static function bool IsAttached(@NULL Cam, class<Class> CamClass, optional out @NULL Modifier)
{
    local int I;

    I = 0;
    J0x08:

    // End:0x73 [Loop If]
    if(I < Cam.ModifierList.Length)
    {
        // End:0x69
        if(Cam.ModifierList[I].Class == CamClass)
        {
            Modifier = TurokCameraModifier(Cam.ModifierList[I]);
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x08;
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    mLifeTime=1.2500000
    mbDamper=true
    mbTranslationNoise=true
    mbRotationNoise=true
    // Reference: TurokSmoothNoise'Default__TurokCameraModifier.RotNoise'
    begin object name=RotNoise class=Class'TurokEngine.TurokSmoothNoise'
        mMax=1.4000000
        mMin=0.5000000
    end object
    mRotationNoise=RotNoise
    // Reference: TurokSmoothNoise'Default__TurokCameraModifier.TranNoise'
    begin object name=TranNoise class=Class'TurokEngine.TurokSmoothNoise'
        mMax=1.4000000
        mMin=0.5000000
    end object
    mTranslationNoise=TranNoise
    mTranslationDampen=0.5000000
    mRotationDampen=0.5000000
}