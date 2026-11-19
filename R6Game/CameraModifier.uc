class CameraModifier extends Object
    abstract
    native;

var bool bDisabled;
var bool bPendingDisable;
var(Debug) bool bDebug;
var Camera CameraOwner;

function Shake(class<DamageType> DamageType, float fStrengthRatio)
{
    return;
}

function CustomShake(float fCustomShakeDuration, float fCustomShakeRollFreq, float fCustomShakePitchFreq, float fCustomShakeYawFreq, int iCustomShakeRollAmp, int iCustomShakePitchAmp, int iCustomShakeYawAmp, SInterpParams CustomShakeInterpParams, bool bCustomShakeInverted)
{
    return;
}

function PerlinNoiseShake(float fShakeDuration, float fPitchShakeScale, int iPitchShakeAmplitude, float fYawShakeScale, int iYawShakeAmplitude, float fRollShakeScale, int iRollShakeAmplitude, float fLocXShakeScale, float fLocXShakeAmplitude, float fLocYShakeScale, float fLocYShakeAmplitude, float fLocZShakeScale, float fLocZShakeAmplitude, SInterpParams ShakeInterpParams, bool bShakeInverted)
{
    return;
}

function Init()
{
    return;
}

function bool ModifyCamera(Camera Camera, float DeltaTime, out TPOV OutPOV)
{
    return;
}

function bool AddCameraModifier(Camera Camera)
{
    CameraOwner = Camera;
    Camera.ModifierList[Camera.ModifierList.Length] = self;
    return true;
    return;
}

function bool RemoveCameraModifier(Camera Camera)
{
    local int ModifierIdx;

    ModifierIdx = 0;
    J0x07:

    // End:0x5B [Loop If]
    if(ModifierIdx < Camera.ModifierList.Length)
    {
        // End:0x51
        if(Camera.ModifierList[ModifierIdx] == self)
        {
            Camera.ModifierList.Remove(ModifierIdx, 1);
            return true;
        }
        ModifierIdx++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    return;
}

simulated function bool IsDisabled()
{
    return bDisabled;
    return;
}

function DisableModifier()
{
    bDisabled = true;
    bPendingDisable = false;
    return;
}

function EnableModifier()
{
    bDisabled = false;
    bPendingDisable = false;
    return;
}

function ToggleModifier()
{
    // End:0x13
    if(bDisabled)
    {
        EnableModifier();        
    }
    else
    {
        DisableModifier();
    }
    return;
}

// Export UCameraModifier::execProcessViewRotation(FFrame&, void* const)
native simulated function bool ProcessViewRotation(float DeltaTime, Actor ViewTarget, out Rotator rViewRotation, out Rotator rDeltaRot);
