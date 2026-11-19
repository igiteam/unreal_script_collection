class TurokSeqAct_CinematicPostProcess extends SeqAct_Latent
    native
    hidecategories(Object);

struct native DOFSettings
{
    var() float FalloffExponent;
    var() float BlurKernelSize;
    var() float MaxNearBlurAmount;
    var() float MaxFarBlurAmount;
    var() float FocusInnerRadius;
    var() float FocusDistance;

    structdefaultproperties
    {
        FalloffExponent=2.0000000
        BlurKernelSize=8.0000000
        MaxNearBlurAmount=0.0000000
        MaxFarBlurAmount=0.6000000
        FocusInnerRadius=2000.0000000
        FocusDistance=4000.0000000
    }
};

struct native BloomSettings
{
    var() float BlurKernelSize;
    var() float BloomScale;

    structdefaultproperties
    {
        BlurKernelSize=8.0000000
        BloomScale=0.5000000
    }
};

struct native MaterialSettings
{
    var bool bShowInGame;
    var() @NULL Material;

    structdefaultproperties
    {
        bShowInGame=false
        Material=none
    }
};

struct native ColorCubeSettings
{
    var() @NULL Texture;
    var() float BlendValue;

    structdefaultproperties
    {
        Texture=none
        BlendValue=0.0000000
    }
};

struct native FogSettings
{
    var() float StartDistance;
    var() float EndDistance;
    var() float StartDensity;
    var() float EndDensity;
    var() @NULL Color;

    structdefaultproperties
    {
        StartDistance=0.0000000
        EndDistance=0.0000000
        StartDensity=0.0000000
        EndDensity=0.0000000
        Color=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000)
    }
};

struct native MotionBlurSettings
{
    var() float MaxVelocity;
    var() float Amount;
    var() float Scalar;
    var() float CameraRotationThreshold;
    var() float CameraTranslationThreshold;

    structdefaultproperties
    {
        MaxVelocity=0.0000000
        Amount=0.0000000
        Scalar=0.0000000
        CameraRotationThreshold=0.0000000
        CameraTranslationThreshold=0.0000000
    }
};

struct native ToneMapSettings
{
    var() float AvgLum;
    var() float Spd;
    var() float LumMin;
    var() float LumMax;
    var() float Contrast;
    var() float WhiteSqd;
    var() float PctChange;

    structdefaultproperties
    {
        AvgLum=0.0000000
        Spd=0.0000000
        LumMin=0.0000000
        LumMax=0.0000000
        Contrast=0.0000000
        WhiteSqd=0.0000000
        PctChange=0.0000000
    }
};

struct native VignetteSettings
{
    var() float Strength;
    var() @NULL Texture;

    structdefaultproperties
    {
        Strength=0.0000000
        Texture=none
    }
};

var() bool mbUseDOF;
var() bool mbUseBloom;
var() bool mbUseMaterial;
var() bool mbUseColorCubeSlot0;
var() bool mbUseColorCubeSlot1;
var() bool mbUseFog;
var() bool mbUseMotionBlur;
var() bool mbUseToneMap;
var() bool mbUseVignette;
var() bool mbUseNearClipPlane;
var bool mbStoredUseFog;
var bool mbStoredUseMotionBlur;
var bool mbStoredUseToneMap;
var() @NULL mDOFSettings;
var() @NULL mBloomSettings;
var() @NULL mMaterialSettings;
var() @NULL mColorCubeSettingsSlot0;
var() @NULL mColorCubeSettingsSlot1;
var() @NULL mFogSettings;
var() @NULL mMotionBlurSettings;
var() @NULL mToneMapSettings;
var() @NULL mVignetteSettings;
var() float mNearClipPlane;
var() float mSetLerpTime;
var() float mRestoreLerpTime;
var name mMaterialEffectName;
var @NULL mMaterialEffect;
var @NULL mStoredDOFSettings;
var @NULL mStoredBloomSettings;
var @NULL mStoredMaterialSettings;
var @NULL mStoredColorCubeSettingsSlot0;
var @NULL mStoredColorCubeSettingsSlot1;
var @NULL mStoredFogSettings;
var @NULL mStoredMotionBlurSettings;
var @NULL mStoredToneMapSettings;
var @NULL mStoredVignetteSettings;
var float mStoredNearClipPlane;

event @NULL GetMaterialEffect(@NULL Controller)
{
    return MaterialEffect(LocalPlayer(Controller.Player).WorkingPlayerPostProcess.FindPostProcessEffect(mMaterialEffectName));
    //return ReturnValue;    
}

defaultproperties
{
    mDOFSettings=(FalloffExponent=2.0000000,BlurKernelSize=8.0000000,MaxNearBlurAmount=0.0000000,MaxFarBlurAmount=0.6000000,FocusInnerRadius=2000.0000000,FocusDistance=4000.0000000)
    mBloomSettings=(BlurKernelSize=8.0000000,BloomScale=0.5000000)
    mFogSettings=(StartDistance=0.0000000,EndDistance=0.0000000,StartDensity=0.0000000,EndDensity=0.0000000,Color=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000))
    mNearClipPlane=5.0000000
    mMaterialEffectName="CinemaMaterial"
    mStoredDOFSettings=(FalloffExponent=2.0000000,BlurKernelSize=8.0000000,MaxNearBlurAmount=0.0000000,MaxFarBlurAmount=0.6000000,FocusInnerRadius=2000.0000000,FocusDistance=4000.0000000)
    mStoredBloomSettings=(BlurKernelSize=8.0000000,BloomScale=0.5000000)
    mStoredFogSettings=(StartDistance=0.0000000,EndDistance=0.0000000,StartDensity=0.0000000,EndDensity=0.0000000,Color=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000))
    InputLinks[0]=(LinkDesc="Set",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Restore",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    OutputLinks[0]=(Links=none,LinkDesc="Finished",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    ObjName="Cinematic Post Process"
    ObjCategory="Turok Cinema"
}