class AdvPostProcessManager extends EvilPostProcessManager within EvilLocalPlayer;

var protected MaterialInstanceConstant VignetteMaterialInstance;
var protected Vector2D VignetteScales;
var protected float VignetteAlpha;
var float VignetteFadeSpeed;
var MaterialEffect FlashME;
var MaterialInstanceConstant FullscreenFlash;
var float FlashAlpha;
var float FlashFadeSpeed;
var transient bool bPriorityFlash;
var protected MaterialInstanceConstant SelectiveDesaturationMaterialInstance;
var protected float SelectiveDesaturationAlpha;
var() float SelectiveDesaturationFadeSpeed;
var protected MaterialEffect ColourizationME;
var protected MaterialInstanceConstant ColourizationMIC;
var protected float ColourizationAlpha;
var() float ColourizationFadeSpeed;
var protected MaterialInstanceConstant HoarfrostMaterialInstance;
var protected Vector2D HoarfrostScales;
var protected float HoarfrostAlpha;
var float HoarfrostFadeSpeed;
var PostProcessSettings DeathPostProcessSettings;

simulated function EnableVignette(bool bEnable, optional float Scale = 5.0000000, optional float InFadeSpeed = 3.0000000)
{
    local MaterialEffect MEffect;
    local bool bUseFader;

    MEffect = InitEffect(VignetteMaterialInstance, 'Vignette');
    // End:0x49
    if(MEffect == none)
    {
        return;
    }
    bUseFader = InFadeSpeed != 0.0000000;
    // End:0x1C9
    if(bEnable)
    {
        // End:0xDB
        if(!MEffect.bShowInGame)
        {
            MEffect.bShowInGame = true;
            VignetteScales.X = 0.0000000;            
        }
        else
        {
            VignetteScales.X = GetRangeValueByPct(VignetteScales, Abs(VignetteAlpha));
        }
        // End:0x160
        if(bUseFader)
        {
            // End:0x14E
            if(VignetteAlpha < 0.0000000)
            {
                VignetteAlpha = -VignetteAlpha;                
            }
            else
            {
                VignetteAlpha = 0.0000000;
            }            
        }
        else
        {
            VignetteAlpha = 1.0000000;
            VignetteMaterialInstance.SetScalarParameterValue('Scale', Scale);
        }
        VignetteScales.Y = Scale;        
    }
    else
    {
        VignetteScales.Y = GetRangeValueByPct(VignetteScales, Abs(VignetteAlpha));
        VignetteScales.X = 0.0000000;
        // End:0x245
        if(bUseFader)
        {
            VignetteAlpha = -1.0000000;            
        }
        else
        {
            VignetteAlpha = 0.0000000;
            VignetteMaterialInstance.SetScalarParameterValue('Scale', 0.0000000);
            MEffect.bShowInGame = false;
        }
    }
    // End:0x2FB
    if(bUseFader)
    {
        VignetteFadeSpeed = InFadeSpeed;
        Outer.SetTimer(0.0300000, self, true, 'VignetteFader');
        VignetteFader();
    }
    //return;    
}

protected function VignetteFader()
{
    // End:0x11
    if(VignetteMaterialInstance == none)
    {
        return;
    }
    // End:0x9E
    if(VignetteAlpha < 0.0000000)
    {
        VignetteAlpha += (0.0300000 * VignetteFadeSpeed);
        // End:0x9B
        if(VignetteAlpha > 0.0000000)
        {
            VignetteAlpha = 0.0000000;
            Outer.ClearTimer(self, 'VignetteFader');
            EnableVignette(false,, 0.0000000);
        }        
    }
    else
    {
        VignetteAlpha += (0.0300000 * VignetteFadeSpeed);
        // End:0x104
        if(VignetteAlpha > 1.0000000)
        {
            VignetteAlpha = 1.0000000;
            Outer.ClearTimer(self, 'VignetteFader');
        }
    }
    VignetteMaterialInstance.SetScalarParameterValue('Scale', GetRangeValueByPct(VignetteScales, Abs(VignetteAlpha)));
    //return;    
}

simulated function EnableFlash(LinearColor Colour, optional float Overwrite = 0.2000000, optional float SolidColourBlend = 0.0000000, optional float VignetteScale = 3.0000000, optional float FadeSpeed = 3.3400000, optional float InitialAlpha = 1.0000000)
{
    // End:0x62
    if(FlashME == none)
    {
        FlashME = InitEffect(FullscreenFlash, 'FullscreenFlash');
    }
    // End:0x9B
    if((bPriorityFlash && FlashAlpha > 0.0000000) || FlashAlpha >= 1.0000000)
    {
        return;
    }
    FlashME.bShowInGame = true;
    FullscreenFlash.SetVectorParameterValue('Colour', Colour);
    FullscreenFlash.SetScalarParameterValue('Overwrite', Overwrite);
    FullscreenFlash.SetScalarParameterValue('SolidColourBlend', SolidColourBlend);
    FullscreenFlash.SetScalarParameterValue('VignetteScale', VignetteScale);
    FlashAlpha = InitialAlpha;
    FlashFadeSpeed = FadeSpeed;
    FullscreenFlash.SetScalarParameterValue('Opacity', FMin(1.0000000, FlashAlpha));
    Outer.SetTimer(0.0150000, self, true, 'UpdateFlash_T');
    //return;    
}

simulated function LastBreathFlash()
{
    // End:0x2E
    if(Outer.IsTimerActive(self, 'UpdateDeath_T'))
    {
        return;
    }
    bPriorityFlash = false;
    FlashAlpha = 0.0000000;
    EnableFlash(MakeLinearColor(0.5000000, 0.2000000, 0.1000000, 1.0000000), 1.0000000, 1.0000000,, 3.8000000);
    bPriorityFlash = true;
    //return;    
}

function UpdateFlash_T()
{
    // End:0x3A
    if(FullscreenFlash == none)
    {
        Outer.ClearTimer(self, 'UpdateFlash_T');
        return;
    }
    // End:0xF3
    if((FlashAlpha -= (0.0150000 * FlashFadeSpeed)) < 0.0000000)
    {
        Outer.ClearTimer(self, 'UpdateFlash_T');
        FullscreenFlash.SetScalarParameterValue('Opacity', 0.0000000);
        FlashME.bShowInGame = false;
        bPriorityFlash = false;
        FlashAlpha = 0.0000000;
        return;
    }
    FullscreenFlash.SetScalarParameterValue('Opacity', FMin(1.0000000, FlashAlpha));
    //return;    
}

static function bool IsZeroColor(LinearColor C)
{
    return ((((C.R * C.R) + (C.G * C.G)) + (C.B * C.B)) + (C.A * C.A)) == 0.0000000;
    //return ReturnValue;    
}

simulated function EnableSelectiveDesaturation(bool bEnable, optional LinearColor ExceptionColor, optional LinearColor Thresholds_ScaleBias, optional bool Fade = true)
{
    local MaterialEffect MEffect;

    MEffect = InitEffect(SelectiveDesaturationMaterialInstance, 'SelectiveDesaturation');
    // End:0x3E
    if(MEffect == none)
    {
        return;
    }
    // End:0x181
    if(bEnable)
    {
        // End:0x90
        if(!MEffect.bShowInGame)
        {
            MEffect.bShowInGame = true;
        }
        SelectiveDesaturationMaterialInstance.SetVectorParameterValue('ExceptionColor', ExceptionColor);
        // End:0x10A
        if(!IsZeroColor(Thresholds_ScaleBias))
        {
            SelectiveDesaturationMaterialInstance.SetVectorParameterValue('Thresholds_ScaleBias', Thresholds_ScaleBias);
        }
        // End:0x142
        if(Fade)
        {
            // End:0x13F
            if(SelectiveDesaturationAlpha < 0.0000000)
            {
                SelectiveDesaturationAlpha = -SelectiveDesaturationAlpha;
            }            
        }
        else
        {
            SelectiveDesaturationAlpha = 1.0000000;
            SelectiveDesaturationMaterialInstance.SetScalarParameterValue('Scale', 1.0000000);
        }        
    }
    else
    {
        // End:0x1B9
        if(Fade)
        {
            // End:0x1B6
            if(SelectiveDesaturationAlpha > 0.0000000)
            {
                SelectiveDesaturationAlpha = -SelectiveDesaturationAlpha;
            }            
        }
        else
        {
            SelectiveDesaturationAlpha = 0.0000000;
            SelectiveDesaturationMaterialInstance.SetScalarParameterValue('Scale', 0.0000000);
            MEffect.bShowInGame = false;
        }
    }
    // End:0x25C
    if(Fade)
    {
        Outer.SetTimer(0.0300000, self, true, 'SelectiveDesaturationFader');
        SelectiveDesaturationFader();
    }
    //return;    
}

protected function SelectiveDesaturationFader()
{
    // End:0x11
    if(SelectiveDesaturationMaterialInstance == none)
    {
        return;
    }
    // End:0x9B
    if(SelectiveDesaturationAlpha < 0.0000000)
    {
        SelectiveDesaturationAlpha += (0.0300000 * SelectiveDesaturationFadeSpeed);
        // End:0x98
        if(SelectiveDesaturationAlpha > 0.0000000)
        {
            SelectiveDesaturationAlpha = 0.0000000;
            Outer.ClearTimer(self, 'SelectiveDesaturationFader');
            EnableSelectiveDesaturation(false,,, false);
        }        
    }
    else
    {
        SelectiveDesaturationAlpha += (0.0300000 * SelectiveDesaturationFadeSpeed);
        // End:0x101
        if(SelectiveDesaturationAlpha > 1.0000000)
        {
            SelectiveDesaturationAlpha = 1.0000000;
            Outer.ClearTimer(self, 'SelectiveDesaturationFader');
        }
    }
    SelectiveDesaturationMaterialInstance.SetScalarParameterValue('Scale', Abs(SelectiveDesaturationAlpha));
    //return;    
}

simulated function EnableColourization(bool bEnable, optional float FadeSpeed = 3.0000000, optional float Power = 0.0000000, optional LinearColor Tint)
{
    // End:0x48
    if(ColourizationME == none)
    {
        ColourizationME = InitEffect(ColourizationMIC, 'Colourization');
    }
    // End:0x59
    if(ColourizationME == none)
    {
        return;
    }
    ColourizationFadeSpeed = FadeSpeed;
    // End:0x14B
    if(bEnable)
    {
        // End:0xBE
        if(!ColourizationME.bShowInGame)
        {
            ColourizationME.bShowInGame = true;
        }
        ColourizationMIC.SetScalarParameterValue('Power', Power);
        ColourizationMIC.SetVectorParameterValue('ColourTint', Tint);
        // End:0x148
        if(ColourizationAlpha < 0.0000000)
        {
            ColourizationAlpha = -ColourizationAlpha;
        }        
    }
    else
    {
        // End:0x176
        if(ColourizationAlpha > 0.0000000)
        {
            ColourizationAlpha = -ColourizationAlpha;            
        }
        else
        {
            // End:0x1D5
            if(ColourizationAlpha == 0.0000000)
            {
                ColourizationME.bShowInGame = false;
                Outer.ClearTimer(self, 'ColourizationFader');
                return;
            }
        }
    }
    Outer.SetTimer(0.0300000, self, true, 'ColourizationFader');
    ColourizationFader();
    //return;    
}

protected function ColourizationFader()
{
    // End:0x11
    if(ColourizationMIC == none)
    {
        return;
    }
    // End:0xAE
    if(ColourizationAlpha < 0.0000000)
    {
        ColourizationAlpha += (0.0300000 * ColourizationFadeSpeed);
        // End:0xAB
        if(ColourizationAlpha > 0.0000000)
        {
            ColourizationAlpha = 0.0000000;
            Outer.ClearTimer(self, 'ColourizationFader');
            ColourizationME.bShowInGame = true;
        }        
    }
    else
    {
        ColourizationAlpha += (0.0300000 * ColourizationFadeSpeed);
        // End:0x114
        if(ColourizationAlpha > 1.0000000)
        {
            ColourizationAlpha = 1.0000000;
            Outer.ClearTimer(self, 'ColourizationFader');
        }
    }
    ColourizationMIC.SetScalarParameterValue('Alpha', Abs(ColourizationAlpha));
    //return;    
}

simulated function EnableDeath()
{
    local LinearColor Colour;

    bPriorityFlash = false;
    Outer.ClearTimer(self, 'UpdateFlash_T');
    // End:0x6A
    if(FlashME == none)
    {
        FlashME = InitEffect(FullscreenFlash, 'FullscreenFlash');
    }
    FlashME.bShowInGame = true;
    Colour = MakeLinearColor(0.7000000, 0.0000000, 0.0000000, 1.0000000);
    FullscreenFlash.SetVectorParameterValue('Colour', Colour);
    FullscreenFlash.SetScalarParameterValue('Overwrite', 0.1500000);
    FullscreenFlash.SetScalarParameterValue('SolidColourBlend', 0.0300000);
    FullscreenFlash.SetScalarParameterValue('VignetteScale', 3.0000000);
    FlashAlpha = 0.0000000;
    FlashFadeSpeed = 0.4000000;
    FullscreenFlash.SetScalarParameterValue('Opacity', 0.0000000);
    bPriorityFlash = true;
    Outer.SetTimer(0.0300000, self, true, 'UpdateDeath_T');
    DeathPostProcessSettings.DOF_InterpolationDuration = 0.5000000;
    /* Statement decompilation error: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
        
    */

    /*@Error*/;
}

function UpdateDeath_T()
{
    // End:0x3A
    if(FullscreenFlash == none)
    {
        Outer.ClearTimer(self, 'UpdateDeath_T');
        return;
    }
    // End:0xC6
    if((FlashAlpha += (0.0300000 * FlashFadeSpeed)) >= 1.0000000)
    {
        Outer.ClearTimer(self, 'UpdateDeath_T');
        FullscreenFlash.SetScalarParameterValue('Opacity', 1.0000000);
        FlashAlpha = 0.0000000;
        return;
    }
    FullscreenFlash.SetScalarParameterValue('Opacity', FMin(1.0000000, FlashAlpha));
    //return;    
}

function Reset()
{
    local bool bHoarfrostWasEnabled;

    bHoarfrostWasEnabled = MaterialEffect(Outer.PlayerPostProcess.FindPostProcessEffect('Hoarfrost')).bShowInGame;
    super.Reset();
    VignetteMaterialInstance = none;
    FullscreenFlash = none;
    SelectiveDesaturationMaterialInstance = none;
    ColourizationMIC = none;
    FlashME = none;
    ColourizationME = none;
    // End:0xD0
    if(!bHoarfrostWasEnabled)
    {
        HoarfrostMaterialInstance = none;        
    }
    else
    {
        MaterialEffect(Outer.PlayerPostProcess.FindPostProcessEffect('Hoarfrost')).bShowInGame = true;
        Outer.SetTimer(0.0300000, self, true, 'HoarfrostFader');
    }
    //return;    
}

simulated function EnableCustomHUDEffect(bool bEnable, optional MaterialInterface OverlayMat)
{
    local MaterialEffect MEffect;

    MEffect = MaterialEffect(Outer.PlayerPostProcess.FindPostProcessEffect('CustomHUDEffect'));
    // End:0x62
    if(MEffect == none)
    {
        return;
    }
    // End:0xDF
    if(bEnable)
    {
        MEffect.Material = OverlayMat;
        // End:0xDC
        if(!MEffect.bShowInGame)
        {
            MEffect.bShowInGame = true;
        }        
    }
    else
    {
        MEffect.bShowInGame = false;
    }
    //return;    
}

simulated function EnableHoarfrost(bool bEnable, float Scale, optional float InFadeSpeed = 3.0000000)
{
    local MaterialEffect MEffect;
    local bool bUseFader;

    MEffect = InitEffect(HoarfrostMaterialInstance, 'Hoarfrost');
    // End:0x40
    if(MEffect == none)
    {
        return;
    }
    bUseFader = InFadeSpeed != 0.0000000;
    // End:0x1C0
    if(bEnable)
    {
        // End:0xD2
        if(!MEffect.bShowInGame)
        {
            MEffect.bShowInGame = true;
            HoarfrostScales.X = 0.0000000;            
        }
        else
        {
            HoarfrostScales.X = GetRangeValueByPct(HoarfrostScales, Abs(HoarfrostAlpha));
        }
        // End:0x157
        if(bUseFader)
        {
            // End:0x145
            if(HoarfrostAlpha < 0.0000000)
            {
                HoarfrostAlpha = -HoarfrostAlpha;                
            }
            else
            {
                HoarfrostAlpha = 0.0000000;
            }            
        }
        else
        {
            HoarfrostAlpha = 1.0000000;
            HoarfrostMaterialInstance.SetScalarParameterValue('Scale', Scale);
        }
        HoarfrostScales.Y = Scale;        
    }
    else
    {
        HoarfrostScales.Y = GetRangeValueByPct(HoarfrostScales, Abs(HoarfrostAlpha));
        HoarfrostScales.X = 0.0000000;
        // End:0x23C
        if(bUseFader)
        {
            HoarfrostAlpha = -1.0000000;            
        }
        else
        {
            HoarfrostAlpha = 0.0000000;
            HoarfrostMaterialInstance.SetScalarParameterValue('Scale', 0.0000000);
            MEffect.bShowInGame = false;
        }
    }
    // End:0x2F2
    if(bUseFader)
    {
        HoarfrostFadeSpeed = InFadeSpeed;
        Outer.SetTimer(0.0300000, self, true, 'HoarfrostFader');
        HoarfrostFader();
    }
    //return;    
}

protected function HoarfrostFader()
{
    // End:0x11
    if(HoarfrostMaterialInstance == none)
    {
        return;
    }
    // End:0xA2
    if(HoarfrostAlpha < 0.0000000)
    {
        HoarfrostAlpha += (0.0300000 * HoarfrostFadeSpeed);
        // End:0x9F
        if(HoarfrostAlpha > 0.0000000)
        {
            HoarfrostAlpha = 0.0000000;
            Outer.ClearTimer(self, 'HoarfrostFader');
            EnableHoarfrost(false, 0.0000000, 0.0000000);
        }        
    }
    else
    {
        HoarfrostAlpha += (0.0300000 * HoarfrostFadeSpeed);
        // End:0x108
        if(HoarfrostAlpha > 1.0000000)
        {
            HoarfrostAlpha = 1.0000000;
            Outer.ClearTimer(self, 'HoarfrostFader');
        }
    }
    HoarfrostMaterialInstance.SetScalarParameterValue('Scale', GetRangeValueByPct(HoarfrostScales, Abs(HoarfrostAlpha)));
    //return;    
}

defaultproperties
{
    SelectiveDesaturationFadeSpeed=3.0000000
    DeathPostProcessSettings=(bOverride_EnableBloom=false,bOverride_EnableDOF=true,bOverride_EnableMotionBlur=false,bOverride_EnableSceneEffect=false,bOverride_AllowAmbientOcclusion=false,bOverride_OverrideRimShaderColor=false,bOverride_Bloom_Scale=false,bOverride_Bloom_Threshold=false,bOverride_Bloom_Tint=false,bOverride_Bloom_ScreenBlendThreshold=false,bOverride_Bloom_InterpolationDuration=false,bOverride_DOF_FalloffExponent=false,bOverride_DOF_BlurKernelSize=false,bOverride_DOF_BlurBloomKernelSize=false,bOverride_DOF_MaxNearBlurAmount=true,bOverride_DOF_MinBlurAmount=false,bOverride_DOF_MaxFarBlurAmount=true,bOverride_DOF_FocusType=false,bOverride_DOF_FocusInnerRadius=true,bOverride_DOF_FocusDistance=false,bOverride_DOF_FocusPosition=false,bOverride_DOF_InterpolationDuration=true,bOverride_DOF_BokehTexture=false,bOverride_MotionBlur_MaxVelocity=false,bOverride_MotionBlur_Amount=false,bOverride_MotionBlur_FullMotionBlur=false,bOverride_MotionBlur_CameraRotationThreshold=false,bOverride_MotionBlur_CameraTranslationThreshold=false,bOverride_MotionBlur_InterpolationDuration=false,bOverride_Scene_Desaturation=false,bOverride_Scene_Colorize=false,bOverride_Scene_TonemapperScale=false,bOverride_Scene_ImageGrainScale=false,bOverride_Scene_HighLights=true,bOverride_Scene_MidTones=true,bOverride_Scene_Shadows=false,bOverride_Scene_InterpolationDuration=true,bOverride_Scene_ColorGradingLUT=false,bOverride_RimShader_Color=true,bOverride_RimShader_InterpolationDuration=true,bOverride_MobileColorGrading=false,bEnableBloom=false,bEnableDOF=true,bEnableMotionBlur=false,bEnableSceneEffect=false,bAllowAmbientOcclusion=true,bOverrideRimShaderColor=false,Bloom_Scale=1.0000000,Bloom_Threshold=1.0000000,Bloom_Tint=(R=255,G=255,B=255,A=0),Bloom_ScreenBlendThreshold=10.0000000,Bloom_InterpolationDuration=1.0000000,DOF_BlurBloomKernelSize=16.0000000,DOF_FalloffExponent=4.0000000,DOF_BlurKernelSize=16.0000000,DOF_MaxNearBlurAmount=1.0000000,DOF_MinBlurAmount=0.5000000,DOF_MaxFarBlurAmount=1.0000000,DOF_FocusType=EFocusType.FOCUS_Distance,DOF_FocusInnerRadius=0.0000000,DOF_FocusDistance=0.0000000,DOF_FocusPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000),DOF_InterpolationDuration=0.0000000,DOF_BokehTexture=none,MotionBlur_MaxVelocity=1.0000000,MotionBlur_Amount=0.5000000,MotionBlur_FullMotionBlur=true,MotionBlur_CameraRotationThreshold=45.0000000,MotionBlur_CameraTranslationThreshold=10000.0000000,MotionBlur_InterpolationDuration=1.0000000,Scene_Desaturation=0.3000000,Scene_Colorize=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_TonemapperScale=1.0000000,Scene_ImageGrainScale=0.0000000,Scene_HighLights=(X=2.5000000,Y=2.5000000,Z=2.5000000),Scene_MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_Shadows=(X=0.1500000,Y=0.2000000,Z=0.2000000),Scene_InterpolationDuration=1.0000000,RimShader_Color=(R=0.4704400,G=0.5859730,B=0.8277260,A=1.0000000),RimShader_InterpolationDuration=1.0000000,ColorGrading_LookupTable=none,ColorGradingLUT=(LUTTextures=none,LUTWeights=none),MobileColorGrading=(TransitionTime=1.0000000,Blend=0.0000000,Desaturation=0.0000000,HighLights=(R=0.7000000,G=0.7000000,B=0.7000000,A=1.0000000),MidTones=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000),Shadows=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000)),MobilePostProcess=(bOverride_Mobile_BlurAmount=false,bOverride_Mobile_TransitionTime=false,bOverride_Mobile_Bloom_Scale=false,bOverride_Mobile_Bloom_Threshold=false,bOverride_Mobile_Bloom_Tint=false,bOverride_Mobile_DOF_Distance=false,bOverride_Mobile_DOF_MinRange=false,bOverride_Mobile_DOF_MaxRange=false,bOverride_Mobile_DOF_NearBlurFactor=false,bOverride_Mobile_DOF_FarBlurFactor=false,Mobile_BlurAmount=16.0000000,Mobile_TransitionTime=1.0000000,Mobile_Bloom_Scale=6.0000000,Mobile_Bloom_Threshold=0.5000000,Mobile_Bloom_Tint=(R=1.0000000,G=1.0000000,B=1.0000000,A=1.0000000),Mobile_DOF_Distance=1500.0000000,Mobile_DOF_MinRange=600.0000000,Mobile_DOF_MaxRange=1200.0000000,Mobile_DOF_NearBlurFactor=1.0000000,Mobile_DOF_FarBlurFactor=1.0000000))
}