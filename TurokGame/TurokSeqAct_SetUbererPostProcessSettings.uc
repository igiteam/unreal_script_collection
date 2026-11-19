class TurokSeqAct_SetUbererPostProcessSettings extends SequenceAction
    hidecategories(Object);

struct OptionalBool
{
    var() bool bUse;
    var() bool Value;

    structdefaultproperties
    {
        bUse=false
        Value=false
    }
};

struct OptionalFloat
{
    var() bool bUse;
    var() float Value;

    structdefaultproperties
    {
        bUse=false
        Value=0.0000000
    }
};

struct OptionalColor
{
    var() bool bUse;
    var() @NULL Value;

    structdefaultproperties
    {
        bUse=false
        Value=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000)
    }
};

struct OptionalTexture2D
{
    var() bool bUse;
    var() @NULL Value;

    structdefaultproperties
    {
        bUse=false
        Value=none
    }
};

struct UPPSColorCube
{
    var() @NULL ColorCube_Blend0;
    var() @NULL ColorCube_Blend1;
    var() @NULL ColorCube_Texture0;
    var() @NULL ColorCube_Texture1;

    structdefaultproperties
    {
        ColorCube_Blend0=(bUse=false,Value=0.0000000)
        ColorCube_Blend1=(bUse=false,Value=0.0000000)
        ColorCube_Texture0=(bUse=false,Value=none)
        ColorCube_Texture1=(bUse=false,Value=none)
    }
};

struct UPPSDOFAndBloom
{
    var() @NULL DOFAndBloom_Enable;
    var() @NULL DOF_FocusDistance;
    var() @NULL DOF_FocusInnerRadius;
    var() @NULL DOF_FalloffExponent;
    var() @NULL DOF_BlurKernelSize;
    var() @NULL DOF_MaxNearBlurAmount;
    var() @NULL DOF_MaxFarBlurAmount;
    var() @NULL Bloom_Scale;

    structdefaultproperties
    {
        DOFAndBloom_Enable=(bUse=false,Value=false)
        DOF_FocusDistance=(bUse=false,Value=0.0000000)
        DOF_FocusInnerRadius=(bUse=false,Value=0.0000000)
        DOF_FalloffExponent=(bUse=false,Value=0.0000000)
        DOF_BlurKernelSize=(bUse=false,Value=0.0000000)
        DOF_MaxNearBlurAmount=(bUse=false,Value=0.0000000)
        DOF_MaxFarBlurAmount=(bUse=false,Value=0.0000000)
        Bloom_Scale=(bUse=false,Value=0.0000000)
    }
};

struct UPPSFilter
{
    var() @NULL Filter_Color;

    structdefaultproperties
    {
        Filter_Color=(bUse=false,Value=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000))
    }
};

struct UPPSFog
{
    var() @NULL Fog_Enable;
    var() @NULL Fog_StartDistance;
    var() @NULL Fog_EndDistance;
    var() @NULL Fog_StartDensity;
    var() @NULL Fog_EndDensity;
    var() @NULL Fog_Color;

    structdefaultproperties
    {
        Fog_Enable=(bUse=false,Value=false)
        Fog_StartDistance=(bUse=false,Value=0.0000000)
        Fog_EndDistance=(bUse=false,Value=0.0000000)
        Fog_StartDensity=(bUse=false,Value=0.0000000)
        Fog_EndDensity=(bUse=false,Value=0.0000000)
        Fog_Color=(bUse=false,Value=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000))
    }
};

struct UPPSMotionBlur
{
    var() @NULL MotionBlur_Enable;
    var() @NULL MotionBlur_MaxVelocity;
    var() @NULL MotionBlur_Amount;
    var() @NULL MotionBlur_Scalar;
    var() @NULL MotionBlur_CameraRotationThreshold;
    var() @NULL MotionBlur_CameraTranslationThreshold;

    structdefaultproperties
    {
        MotionBlur_Enable=(bUse=false,Value=false)
        MotionBlur_MaxVelocity=(bUse=false,Value=0.0000000)
        MotionBlur_Amount=(bUse=false,Value=0.0000000)
        MotionBlur_Scalar=(bUse=false,Value=0.0000000)
        MotionBlur_CameraRotationThreshold=(bUse=false,Value=0.0000000)
        MotionBlur_CameraTranslationThreshold=(bUse=false,Value=0.0000000)
    }
};

struct UPPSToneMap
{
    var() @NULL ToneMap_Enable;
    var() @NULL TI_AvgLum;
    var() @NULL TI_Spd;
    var() @NULL TI_LumMin;
    var() @NULL TI_LumMax;
    var() @NULL TI_Contrast;
    var() @NULL TI_WhiteSqd;
    var() @NULL TI_PctChange;

    structdefaultproperties
    {
        ToneMap_Enable=(bUse=false,Value=false)
        TI_AvgLum=(bUse=false,Value=0.0000000)
        TI_Spd=(bUse=false,Value=0.0000000)
        TI_LumMin=(bUse=false,Value=0.0000000)
        TI_LumMax=(bUse=false,Value=0.0000000)
        TI_Contrast=(bUse=false,Value=0.0000000)
        TI_WhiteSqd=(bUse=false,Value=0.0000000)
        TI_PctChange=(bUse=false,Value=0.0000000)
    }
};

struct UPPSVignette
{
    var() @NULL Vignette_Strength;
    var() @NULL Vignette_Texture;

    structdefaultproperties
    {
        Vignette_Strength=(bUse=false,Value=0.0000000)
        Vignette_Texture=(bUse=false,Value=none)
    }
};

var() @NULL mColorCube;
var() @NULL mDOFAndBloom;
var() @NULL mFilter;
var() @NULL mFog;
var() @NULL mMotionBlur;
var() @NULL mToneMap;
var() @NULL mVignette;
var() float mLerpTime;

event Activated()
{
    local @NULL tppm;

    tppm = Class'Engine.Engine'.static.GetEngine().GetTurokPostProcessManager();
    // End:0xB7E
    if(tppm != none)
    {
        tppm.BeginSettings();
        // End:0x88
        if(mColorCube.ColorCube_Blend0.bUse)
        {
            tppm.SetFloatNative(36, mColorCube.ColorCube_Blend0.Value);
        }
        // End:0xD3
        if(mColorCube.ColorCube_Blend1.bUse)
        {
            tppm.SetFloatNative(37, mColorCube.ColorCube_Blend1.Value);
        }
        // End:0x11D
        if(mColorCube.ColorCube_Texture0.bUse)
        {
            tppm.SetColorCubeTexture(0, mColorCube.ColorCube_Texture0.Value);
        }
        // End:0x167
        if(mColorCube.ColorCube_Texture1.bUse)
        {
            tppm.SetColorCubeTexture(1, mColorCube.ColorCube_Texture1.Value);
        }
        // End:0x1B3
        if(mDOFAndBloom.DOFAndBloom_Enable.bUse)
        {
            tppm.SetBoolNative(2, mDOFAndBloom.DOFAndBloom_Enable.Value);
        }
        // End:0x1FE
        if(mDOFAndBloom.DOF_FocusDistance.bUse)
        {
            tppm.SetFloatNative(6, mDOFAndBloom.DOF_FocusDistance.Value);
        }
        // End:0x249
        if(mDOFAndBloom.DOF_FocusInnerRadius.bUse)
        {
            tppm.SetFloatNative(7, mDOFAndBloom.DOF_FocusInnerRadius.Value);
        }
        // End:0x294
        if(mDOFAndBloom.DOF_FalloffExponent.bUse)
        {
            tppm.SetFloatNative(8, mDOFAndBloom.DOF_FalloffExponent.Value);
        }
        // End:0x2DF
        if(mDOFAndBloom.DOF_BlurKernelSize.bUse)
        {
            tppm.SetFloatNative(9, mDOFAndBloom.DOF_BlurKernelSize.Value);
        }
        // End:0x32A
        if(mDOFAndBloom.DOF_MaxNearBlurAmount.bUse)
        {
            tppm.SetFloatNative(10, mDOFAndBloom.DOF_MaxNearBlurAmount.Value);
        }
        // End:0x375
        if(mDOFAndBloom.DOF_MaxFarBlurAmount.bUse)
        {
            tppm.SetFloatNative(11, mDOFAndBloom.DOF_MaxFarBlurAmount.Value);
        }
        // End:0x3C0
        if(mDOFAndBloom.Bloom_Scale.bUse)
        {
            tppm.SetFloatNative(18, mDOFAndBloom.Bloom_Scale.Value);
        }
        // End:0x45B
        if(mFilter.Filter_Color.bUse)
        {
            tppm.SetColorNative(44, mFilter.Filter_Color.Value.R, mFilter.Filter_Color.Value.G, mFilter.Filter_Color.Value.B);
        }
        // End:0x4A7
        if(mFog.Fog_Enable.bUse)
        {
            tppm.SetBoolNative(1, mFog.Fog_Enable.Value);
        }
        // End:0x4F2
        if(mFog.Fog_StartDistance.bUse)
        {
            tppm.SetFloatNative(24, mFog.Fog_StartDistance.Value);
        }
        // End:0x53D
        if(mFog.Fog_EndDistance.bUse)
        {
            tppm.SetFloatNative(25, mFog.Fog_EndDistance.Value);
        }
        // End:0x588
        if(mFog.Fog_StartDensity.bUse)
        {
            tppm.SetFloatNative(26, mFog.Fog_StartDensity.Value);
        }
        // End:0x5D3
        if(mFog.Fog_EndDensity.bUse)
        {
            tppm.SetFloatNative(27, mFog.Fog_EndDensity.Value);
        }
        // End:0x66E
        if(mFog.Fog_Color.bUse)
        {
            tppm.SetColorNative(43, mFog.Fog_Color.Value.R, mFog.Fog_Color.Value.G, mFog.Fog_Color.Value.B);
        }
        // End:0x6BA
        if(mMotionBlur.MotionBlur_Enable.bUse)
        {
            tppm.SetBoolNative(0, mMotionBlur.MotionBlur_Enable.Value);
        }
        // End:0x705
        if(mMotionBlur.MotionBlur_MaxVelocity.bUse)
        {
            tppm.SetFloatNative(19, mMotionBlur.MotionBlur_MaxVelocity.Value);
        }
        // End:0x750
        if(mMotionBlur.MotionBlur_Amount.bUse)
        {
            tppm.SetFloatNative(20, mMotionBlur.MotionBlur_Amount.Value);
        }
        // End:0x79B
        if(mMotionBlur.MotionBlur_Scalar.bUse)
        {
            tppm.SetFloatNative(21, mMotionBlur.MotionBlur_Scalar.Value);
        }
        // End:0x7E6
        if(mMotionBlur.MotionBlur_CameraRotationThreshold.bUse)
        {
            tppm.SetFloatNative(22, mMotionBlur.MotionBlur_CameraRotationThreshold.Value);
        }
        // End:0x831
        if(mMotionBlur.MotionBlur_CameraTranslationThreshold.bUse)
        {
            tppm.SetFloatNative(23, mMotionBlur.MotionBlur_CameraTranslationThreshold.Value);
        }
        // End:0x87D
        if(mToneMap.ToneMap_Enable.bUse)
        {
            tppm.SetBoolNative(4, mToneMap.ToneMap_Enable.Value);
        }
        // End:0x8C8
        if(mToneMap.TI_AvgLum.bUse)
        {
            tppm.SetFloatNative(29, mToneMap.TI_AvgLum.Value);
        }
        // End:0x913
        if(mToneMap.TI_Spd.bUse)
        {
            tppm.SetFloatNative(30, mToneMap.TI_Spd.Value);
        }
        // End:0x95E
        if(mToneMap.TI_LumMin.bUse)
        {
            tppm.SetFloatNative(31, mToneMap.TI_LumMin.Value);
        }
        // End:0x9A9
        if(mToneMap.TI_LumMax.bUse)
        {
            tppm.SetFloatNative(32, mToneMap.TI_LumMax.Value);
        }
        // End:0x9F4
        if(mToneMap.TI_Contrast.bUse)
        {
            tppm.SetFloatNative(33, mToneMap.TI_Contrast.Value);
        }
        // End:0xA3F
        if(mToneMap.TI_WhiteSqd.bUse)
        {
            tppm.SetFloatNative(34, mToneMap.TI_WhiteSqd.Value);
        }
        // End:0xA8A
        if(mToneMap.TI_PctChange.bUse)
        {
            tppm.SetFloatNative(35, mToneMap.TI_PctChange.Value);
        }
        // End:0xAD5
        if(mVignette.Vignette_Strength.bUse)
        {
            tppm.SetFloatNative(28, mVignette.Vignette_Strength.Value);
        }
        // End:0xB1E
        if(mVignette.Vignette_Texture.bUse)
        {
            tppm.SetVignetteTexture(mVignette.Vignette_Texture.Value);
        }
        // End:0xB52
        if(InputLinks[0].bHasImpulse == true)
        {
            tppm.EndSettings(mLerpTime);            
        }
        else
        {
            tppm.EndSettings(0.0000000);
        }
        tppm.StoreKismetSettings();
    }
    //return;    
}

defaultproperties
{
    mFilter=(Filter_Color=(bUse=false,Value=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000)))
    mFog=(Fog_Enable=(bUse=false,Value=false),Fog_StartDistance=(bUse=false,Value=0.0000000),Fog_EndDistance=(bUse=false,Value=0.0000000),Fog_StartDensity=(bUse=false,Value=0.0000000),Fog_EndDensity=(bUse=false,Value=0.0000000),Fog_Color=(bUse=false,Value=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000)))
    InputLinks[0]=(LinkDesc="In",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="No Lerp",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    VariableLinks=none
    ObjName="Set Post Process Settings"
    ObjCategory="Turok Rendering"
}