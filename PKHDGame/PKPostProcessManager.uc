class PKPostProcessManager extends EvilPostProcessManager
    hidecategories(Navigation);

var MaterialEffect FlashME;
var MaterialInstanceConstant FullscreenFlash;
var float FlashAlpha;
var float FlashFadeSpeed;
var transient bool bWhiteFlash;
var MaterialEffect DemonVisionME;
var MaterialInstanceConstant DemonVisionMIC;
var MaterialEffect WeaponModifierME;
var MaterialInstanceConstant WeaponModifierMIC;
var float WeaponModifierOpacity;
var MaterialEffect GhostME;
var MaterialInstanceConstant GhostMIC;
var MaterialEffect BurnME;
var MaterialInstanceConstant BurnMIC;
var float BurnDistortionAlpha;
var float BurnSootAlpha;
var MaterialEffect ElectroME;
var MaterialInstanceConstant ElectroMIC;
var float ElectroAlpha;
var transient array<PostProcessChain> OldPPChain;
var PostProcessSettings MenuPostProcessSettings;
var PostProcessSettings DeathPostProcessSettings;
var byte MenuPostprocessSemaphore;

function Reset()
{
    // End:0x1A
    if(OldPPChain.Length > 0)
    {
        PopChainOverride();
    }
    super.Reset();
    DemonVisionME = none;
    DemonVisionMIC = none;
    FlashME = none;
    FullscreenFlash = none;
    WeaponModifierME = none;
    WeaponModifierMIC = none;
    GhostME = none;
    GhostMIC = none;
    BurnME = none;
    BurnMIC = none;
    ElectroME = none;
    ElectroMIC = none;
    // End:0xD5
    if(int(MenuPostprocessSemaphore) > int(0))
    {
        SetMenuOverride(false);
        MenuPostprocessSemaphore = 0;
    }
    //return;    
}

simulated function PushChainOverride(PostProcessChain OverrideChain)
{
    // End:0x1C
    if(OldPPChain.Length > 0)
    {
        ScriptTrace();
        return;
    }
    FlashME = none;
    FullscreenFlash = none;
    LocalPlayer.ClearPostProcessSettingsOverride(0.0000000);
    OldPPChain = LocalPlayer.PlayerPostProcessChains;
    LocalPlayer.RemoveAllPostProcessingChains();
    LocalPlayer.InsertPostProcessingChain(OverrideChain, -1, true);
    //return;    
}

simulated function PopChainOverride()
{
    local int I;

    // End:0x1C
    if(OldPPChain.Length < 1)
    {
        ScriptTrace();
        return;
    }
    LocalPlayer.RemoveAllPostProcessingChains();
    I = 0;
    J0x46:

    // End:0xA4 [Loop If]
    if(I < OldPPChain.Length)
    {
        LocalPlayer.InsertPostProcessingChain(OldPPChain[I], -1, true);
        ++I;
        // [Loop Continue]
        goto J0x46;
    }
    OldPPChain.Length = 0;
    Reset();
    FlashME = none;
    FullscreenFlash = none;
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
    if((bWhiteFlash && FlashAlpha > 0.0000000) || FlashAlpha >= 1.0000000)
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
    Owner.SetTimer(0.0300000, true, 'UpdateFlash_T', self);
    //return;    
}

simulated function PickupFlash()
{
    EnableFlash(MakeLinearColor(0.3094180, 0.3992970, 1.0000000, 1.0000000), 0.1000000,, 2.0000000);
    //return;    
}

simulated function SecretAreaFlash()
{
    EnableFlash(MakeLinearColor(0.3094180, 0.3992970, 1.0000000, 1.0000000), 0.1000000,, 2.0000000,, 5.0000000);
    //return;    
}

simulated function DemonTransitionFlash()
{
    bWhiteFlash = false;
    FlashAlpha = 0.0000000;
    EnableFlash(MakeLinearColor(1.0000000, 1.0000000, 1.0000000, 1.0000000), 1.0000000, 1.0000000);
    bWhiteFlash = true;
    //return;    
}

function UpdateFlash_T()
{
    // End:0x3A
    if(FullscreenFlash == none)
    {
        Owner.ClearTimer('UpdateFlash_T', self);
        return;
    }
    // End:0xF3
    if((FlashAlpha -= (0.0300000 * FlashFadeSpeed)) < 0.0000000)
    {
        Owner.ClearTimer('UpdateFlash_T', self);
        FullscreenFlash.SetScalarParameterValue('Opacity', 0.0000000);
        FlashME.bShowInGame = false;
        bWhiteFlash = false;
        FlashAlpha = 0.0000000;
        return;
    }
    FullscreenFlash.SetScalarParameterValue('Opacity', FMin(1.0000000, FlashAlpha));
    //return;    
}

simulated function EnableDemonVision()
{
    // End:0x35
    if(DemonVisionME == none)
    {
        DemonVisionME = InitEffect(DemonVisionMIC, 'DemonVision');
    }
    DemonVisionMIC.SetTextureParameterValue('HighlightMask', EvilPlayerController(Owner).HighlightMaskTexture);
    //return;    
}

simulated function UpdateDemonWarp(float RefireCount, float RefireRate)
{
    local float F;

    // End:0x43
    if(RefireCount < 0.0000000)
    {
        DemonVisionMIC.SetScalarParameterValue('WarpScale', 0.0000000);        
    }
    else
    {
        F = 1.0000000 - (RefireCount / RefireRate);
        DemonVisionMIC.SetScalarParameterValue('WarpScale', F * F);
        DemonVisionMIC.SetScalarParameterValue('WarpPhaseShift', WorldInfo.AudioTimeSeconds - RefireCount);
    }
    //return;    
}

simulated function SetWeaponModifier(bool bEnabled)
{
    // End:0x35
    if(WeaponModifierME == none)
    {
        WeaponModifierME = InitEffect(WeaponModifierMIC, 'WeaponModifier');
    }
    // End:0xCE
    if(bEnabled)
    {
        WeaponModifierME.bShowInGame = true;
        WeaponModifierOpacity = 0.0000000;
        WeaponModifierMIC.SetScalarParameterValue('Opacity', WeaponModifierOpacity);
        Owner.SetTimer(0.0300000, true, 'UpdateWeaponModifier_T', self);        
    }
    else
    {
        // End:0x118
        if((WeaponModifierOpacity == 0.0000000) || Owner.GetTimerRate('UpdateWeaponModifier_T', self) < 0.0000000)
        {
            return;
        }
        WeaponModifierOpacity = -WeaponModifierOpacity;
    }
    //return;    
}

simulated function UpdateWeaponModifier_T()
{
    // End:0x25
    if(WeaponModifierMIC == none)
    {
        ClearTimer('UpdateWeaponModifier_T', self);
        return;
    }
    // End:0x78
    if(WeaponModifierOpacity >= 0.0000000)
    {
        // End:0x75
        if((WeaponModifierOpacity += 0.1000000) > 1.0000000)
        {
            WeaponModifierOpacity = 1.0000000;
            ClearTimer('UpdateWeaponModifier_T', self);
        }        
    }
    else
    {
        // End:0xD6
        if((WeaponModifierOpacity += 0.1000000) > 0.0000000)
        {
            WeaponModifierOpacity = 0.0000000;
            WeaponModifierME.bShowInGame = false;
            ClearTimer('UpdateWeaponModifier_T', self);
        }
    }
    WeaponModifierMIC.SetScalarParameterValue('Opacity', Abs(WeaponModifierOpacity));
    //return;    
}

simulated function EnableGhost()
{
    // End:0x35
    if(GhostME == none)
    {
        GhostME = InitEffect(GhostMIC, 'Ghost');
    }
    GhostMIC.SetTextureParameterValue('HighlightMask', EvilPlayerController(Owner).HighlightMaskTexture);
    //return;    
}

simulated function EnableBurn()
{
    // End:0x35
    if(BurnME == none)
    {
        BurnME = InitEffect(BurnMIC, 'Burn');
    }
    BurnME.bShowInGame = true;
    // End:0x81
    if(BurnDistortionAlpha < 0.0000000)
    {
        BurnDistortionAlpha = -BurnDistortionAlpha;        
    }
    else
    {
        BurnDistortionAlpha = 0.0010000;
    }
    // End:0xF0
    if(!Owner.IsTimerActive('UpdateBurn_T', self))
    {
        Owner.SetTimer(0.0300000, true, 'UpdateBurn_T', self);
        UpdateBurn_T();
    }
    //return;    
}

function UpdateBurn_T()
{
    // End:0x3A
    if(BurnMIC == none)
    {
        Owner.ClearTimer('UpdateBurn_T', self);
        return;
    }
    // End:0xC2
    if(BurnDistortionAlpha > 0.0000000)
    {
        // End:0x76
        if((BurnDistortionAlpha += 0.1000000) >= 3.0000000)
        {
            BurnDistortionAlpha = -3.0000000;
        }
        // End:0xBF
        if((BurnDistortionAlpha > 1.0000000) || BurnSootAlpha > 0.0000000)
        {
            BurnSootAlpha = FMin(BurnSootAlpha + 0.0500000, 2.0000000);
        }        
    }
    else
    {
        // End:0xEB
        if((BurnDistortionAlpha += 0.0500000) >= 0.0000000)
        {
            BurnDistortionAlpha = 0.0000000;
        }
        // End:0x11F
        if(BurnDistortionAlpha >= -1.0000000)
        {
            BurnSootAlpha = FMax(BurnSootAlpha - 0.0250000, 0.0000000);
        }
        // End:0x17E
        if(BurnSootAlpha == 0.0000000)
        {
            Owner.ClearTimer('UpdateBurn_T', self);
            BurnME.bShowInGame = false;
            return;
        }
    }
    BurnMIC.SetScalarParameterValue('Distortion', FMin(1.0000000, Abs(BurnDistortionAlpha)));
    BurnMIC.SetScalarParameterValue('Soot', FMin(1.0000000, BurnSootAlpha));
    //return;    
}

simulated function EnableElectrocution()
{
    // End:0x35
    if(ElectroME == none)
    {
        ElectroME = InitEffect(ElectroMIC, 'Electrocution');
    }
    ElectroME.bShowInGame = true;
    ElectroAlpha = 1.0000000;
    Owner.SetTimer(0.0300000, true, 'UpdateElectro_T', self);
    UpdateElectro_T();
    //return;    
}

function UpdateElectro_T()
{
    // End:0x3A
    if(ElectroMIC == none)
    {
        Owner.ClearTimer('UpdateElectro_T', self);
        return;
    }
    // End:0xCD
    if((ElectroAlpha -= 0.0300000) < 0.0000000)
    {
        Owner.ClearTimer('UpdateElectro_T', self);
        ElectroMIC.SetScalarParameterValue('Opacity', 0.0000000);
        ElectroME.bShowInGame = false;
        return;
    }
    ElectroMIC.SetScalarParameterValue('Opacity', ElectroAlpha);
    //return;    
}

simulated function SetMenuOverride(bool bNewEnabled, optional float FadeTime = 0.0000000, optional bool bAllPlayers)
{
    local PKPlayerController PC;

    // End:0x8C
    if(bAllPlayers)
    {
        // End:0x89
        foreach LocalPlayerControllers(Class'PKPlayerController', PC)
        {
            PKPostProcessManager(PC.GetPPManager()).SetMenuOverride(bNewEnabled, FadeTime, false);            
        }        
        return;
    }
    // End:0x1A3
    if(bNewEnabled)
    {
        // End:0xB1
        if(int(++MenuPostprocessSemaphore) > int(1))
        {
            return;
        }
        MenuPostProcessSettings.Bloom_InterpolationDuration = FadeTime;
        MenuPostProcessSettings.DOF_InterpolationDuration = FadeTime;
        MenuPostProcessSettings.MotionBlur_InterpolationDuration = FadeTime;
        MenuPostProcessSettings.Scene_InterpolationDuration = FadeTime;
        MenuPostProcessSettings.RimShader_InterpolationDuration = FadeTime;
        LocalPlayer.OverridePostProcessSettings(MenuPostProcessSettings, FadeTime);        
    }
    else
    {
        // End:0x1F7
        if(int(MenuPostprocessSemaphore) > int(0))
        {
            // End:0x1CF
            if(int(--MenuPostprocessSemaphore) > int(0))
            {
                return;
            }
            LocalPlayer.ClearPostProcessSettingsOverride(FadeTime);
        }
    }
    //return;    
}

function Update(name Id, PPParameters P)
{
    local PostProcessSettings BloomPPOverride;

    // End:0x36
    if(Id != 'ExploBloom')
    {
        super.Update(Id, P);        
    }
    else
    {
        BloomPPOverride.bOverride_Bloom_InterpolationDuration = true;
        BloomPPOverride.bOverride_Bloom_Scale = true;
        BloomPPOverride.bOverride_Bloom_Threshold = true;
        BloomPPOverride.bOverride_Bloom_Tint = true;
        BloomPPOverride.bOverride_EnableBloom = true;
        BloomPPOverride.bEnableBloom = true;
        BloomPPOverride.Bloom_InterpolationDuration = 0.0000000;
        BloomPPOverride.Bloom_Scale = P.BloomScale * 0.1000000;
        BloomPPOverride.Bloom_Tint = P.BloomTint;
        BloomPPOverride.Bloom_Threshold = P.BloomThreshold;
        LocalPlayer.OverridePostProcessSettings(BloomPPOverride, 0.0000000);
        LocalPlayer.ClearPostProcessSettingsOverride(0.6000000);
    }
    //return;    
}

function Deactivate(name Id)
{
    // End:0x2A
    if(Id != 'ExploBloom')
    {
        super.Deactivate(Id);
    }
    //return;    
}

simulated function EnableDeath()
{
    local LinearColor Colour;

    // End:0x35
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
    Owner.ClearTimer('UpdateFlash_T', self);
    Owner.SetTimer(0.0300000, true, 'UpdateDeath_T', self);
    DeathPostProcessSettings.DOF_InterpolationDuration = 0.5000000;
    LocalPlayer.OverridePostProcessSettings(DeathPostProcessSettings, DeathPostProcessSettings.DOF_InterpolationDuration);
    //return;    
}

function UpdateDeath_T()
{
    // End:0x3A
    if(FullscreenFlash == none)
    {
        Owner.ClearTimer('UpdateDeath_T', self);
        return;
    }
    // End:0xC6
    if((FlashAlpha += (0.0300000 * FlashFadeSpeed)) >= 1.0000000)
    {
        Owner.ClearTimer('UpdateDeath_T', self);
        FullscreenFlash.SetScalarParameterValue('Opacity', 1.0000000);
        FlashAlpha = 0.0000000;
        return;
    }
    FullscreenFlash.SetScalarParameterValue('Opacity', FMin(1.0000000, FlashAlpha));
    //return;    
}

simulated function EnablePentagramPP(bool bEnable, optional float FadeTime = 4.0000000)
{
    local MaterialEffect MEffect;

    MEffect = InitEffect(PentMaterialInstance, 'PentagramPP');
    // End:0x40
    if(MEffect == none)
    {
        return;
    }
    // End:0x124
    if(bEnable)
    {
        // End:0x121
        if(!MEffect.bShowInGame)
        {
            MEffect.bShowInGame = true;
            PentCurrTime = WorldInfo.TimeSeconds;
            PentFadeTime = FadeTime;
            PentMaterialInstance.SetScalarParameterValue('Opacity', 0.0000000);
            ClearTimer('FadeOutPentPP_T');
            SetTimer(0.0600000, true, 'FadeInPentPP_T');
        }        
    }
    else
    {
        MEffect.bShowInGame = true;
        SetTimer(0.0600000, true, 'FadeOutPentPP_T');
        ClearTimer('FadeInPentPP_T');
    }
    //return;    
}

function FadeInPentPP_T()
{
    local float itp;

    // End:0xBC
    if((WorldInfo.TimeSeconds - PentCurrTime) < PentFadeTime)
    {
        itp = FClamp((WorldInfo.TimeSeconds - PentCurrTime) / PentFadeTime, 0.0000000, 1.0000000);
        PentMaterialInstance.SetScalarParameterValue('Opacity', 1.0000000 - itp);        
    }
    else
    {
        PentMaterialInstance.SetScalarParameterValue('Opacity', 0.0000000);
        ClearTimer('FadeInPentPP_T');
    }
    //return;    
}

function FadeOutPentPP_T()
{
    local float itp;

    // End:0xB5
    if((WorldInfo.TimeSeconds - PentCurrTime) < PentFadeTime)
    {
        itp = FClamp((WorldInfo.TimeSeconds - PentCurrTime) / PentFadeTime, 0.0000000, 1.0000000);
        PentMaterialInstance.SetScalarParameterValue('Opacity', itp);        
    }
    else
    {
        PentMaterialInstance.SetScalarParameterValue('Opacity', 1.0000000);
        ShowEffect('PentPP', false);
        ClearTimer('FadeOutPentPP_T');
    }
    //return;    
}

simulated function EnableBleachBypass(bool bEnable, optional float Opacity = 1.0000000)
{
    super.EnableBleachBypass(bEnable, Opacity);
    // End:0x87
    if(bEnable)
    {
        Owner.SetTimer(5.0000000, false, 'BleachBypassWatchdog', self);
        Owner.ClearTimer('BleachBypassFader_T', self);        
    }
    else
    {
        Owner.ClearTimer('BleachBypassWatchdog', self);
        Owner.ClearTimer('BleachBypassFader_T', self);
    }
    //return;    
}

simulated function BleachBypassWatchdog()
{
    Owner.SetTimer(0.0300000, true, 'BleachBypassFader_T', self);
    //return;    
}

simulated function BleachBypassFader_T()
{
    local float Opacity;
    local int ParamIndex;

    // End:0x3A
    if(BBMaterialInstance == none)
    {
        Owner.ClearTimer('BleachBypassFader_T', self);
        return;
    }
    ParamIndex = BBMaterialInstance.ScalarParameterValues.Find('ParameterName', 'Opacity');
    // End:0xB6
    if(ParamIndex == -1)
    {
        Owner.ClearTimer('BleachBypassFader_T', self);
        return;
    }
    Opacity = BBMaterialInstance.ScalarParameterValues[ParamIndex].ParameterValue;
    Opacity -= 0.0600000;
    // End:0x12D
    if(Opacity <= 0.0000000)
    {
        EnableBleachBypass(false);        
    }
    else
    {
        BBMaterialInstance.SetScalarParameterValue('Opacity', Opacity);
    }
    //return;    
}

defaultproperties
{
    MenuPostProcessSettings=(bOverride_EnableBloom=false,bOverride_EnableDOF=true,bOverride_EnableMotionBlur=false,bOverride_EnableSceneEffect=true,bOverride_AllowAmbientOcclusion=false,bOverride_OverrideRimShaderColor=false,bOverride_Bloom_Scale=false,bOverride_Bloom_Threshold=false,bOverride_Bloom_Tint=false,bOverride_Bloom_ScreenBlendThreshold=false,bOverride_Bloom_InterpolationDuration=false,bOverride_DOF_FalloffExponent=false,bOverride_DOF_BlurKernelSize=false,bOverride_DOF_BlurBloomKernelSize=false,bOverride_DOF_MaxNearBlurAmount=true,bOverride_DOF_MinBlurAmount=false,bOverride_DOF_MaxFarBlurAmount=true,bOverride_DOF_FocusType=false,bOverride_DOF_FocusInnerRadius=true,bOverride_DOF_FocusDistance=false,bOverride_DOF_FocusPosition=false,bOverride_DOF_InterpolationDuration=true,bOverride_DOF_BokehTexture=false,bOverride_MotionBlur_MaxVelocity=false,bOverride_MotionBlur_Amount=false,bOverride_MotionBlur_FullMotionBlur=false,bOverride_MotionBlur_CameraRotationThreshold=false,bOverride_MotionBlur_CameraTranslationThreshold=false,bOverride_MotionBlur_InterpolationDuration=false,bOverride_Scene_Desaturation=false,bOverride_Scene_Colorize=false,bOverride_Scene_TonemapperScale=false,bOverride_Scene_ImageGrainScale=false,bOverride_Scene_HighLights=true,bOverride_Scene_MidTones=true,bOverride_Scene_Shadows=false,bOverride_Scene_InterpolationDuration=true,bOverride_Scene_ColorGradingLUT=false,bOverride_RimShader_Color=true,bOverride_RimShader_InterpolationDuration=true,bOverride_MobileColorGrading=false,bEnableBloom=false,bEnableDOF=true,bEnableMotionBlur=false,bEnableSceneEffect=true,bAllowAmbientOcclusion=true,bOverrideRimShaderColor=false,Bloom_Scale=1.0000000,Bloom_Threshold=1.0000000,Bloom_Tint=(R=255,G=255,B=255,A=0),Bloom_ScreenBlendThreshold=10.0000000,Bloom_InterpolationDuration=1.0000000,DOF_BlurBloomKernelSize=16.0000000,DOF_FalloffExponent=4.0000000,DOF_BlurKernelSize=16.0000000,DOF_MaxNearBlurAmount=1.0000000,DOF_MinBlurAmount=1.0000000,DOF_MaxFarBlurAmount=1.0000000,DOF_FocusType=EFocusType.FOCUS_Distance,DOF_FocusInnerRadius=0.0000000,DOF_FocusDistance=0.0000000,DOF_FocusPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000),DOF_InterpolationDuration=0.0000000,DOF_BokehTexture=none,MotionBlur_MaxVelocity=1.0000000,MotionBlur_Amount=0.5000000,MotionBlur_FullMotionBlur=true,MotionBlur_CameraRotationThreshold=45.0000000,MotionBlur_CameraTranslationThreshold=10000.0000000,MotionBlur_InterpolationDuration=1.0000000,Scene_Desaturation=1.0000000,Scene_Colorize=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_TonemapperScale=1.0000000,Scene_ImageGrainScale=0.0000000,Scene_HighLights=(X=2.5000000,Y=2.5000000,Z=2.5000000),Scene_MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_Shadows=(X=0.1500000,Y=0.2000000,Z=0.2000000),Scene_InterpolationDuration=1.0000000,RimShader_Color=(R=0.4704400,G=0.5859730,B=0.8277260,A=1.0000000),RimShader_InterpolationDuration=1.0000000,ColorGrading_LookupTable=none,ColorGradingLUT=(LUTTextures=none,LUTWeights=none),MobileColorGrading=(TransitionTime=1.0000000,Blend=0.0000000,Desaturation=0.0000000,HighLights=(R=0.7000000,G=0.7000000,B=0.7000000,A=1.0000000),MidTones=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000),Shadows=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000)),MobilePostProcess=(bOverride_Mobile_BlurAmount=false,bOverride_Mobile_TransitionTime=false,bOverride_Mobile_Bloom_Scale=false,bOverride_Mobile_Bloom_Threshold=false,bOverride_Mobile_Bloom_Tint=false,bOverride_Mobile_DOF_Distance=false,bOverride_Mobile_DOF_MinRange=false,bOverride_Mobile_DOF_MaxRange=false,bOverride_Mobile_DOF_NearBlurFactor=false,bOverride_Mobile_DOF_FarBlurFactor=false,Mobile_BlurAmount=16.0000000,Mobile_TransitionTime=1.0000000,Mobile_Bloom_Scale=6.0000000,Mobile_Bloom_Threshold=0.5000000,Mobile_Bloom_Tint=(R=1.0000000,G=1.0000000,B=1.0000000,A=1.0000000),Mobile_DOF_Distance=1500.0000000,Mobile_DOF_MinRange=600.0000000,Mobile_DOF_MaxRange=1200.0000000,Mobile_DOF_NearBlurFactor=1.0000000,Mobile_DOF_FarBlurFactor=1.0000000))
    DeathPostProcessSettings=(bOverride_EnableBloom=false,bOverride_EnableDOF=true,bOverride_EnableMotionBlur=false,bOverride_EnableSceneEffect=false,bOverride_AllowAmbientOcclusion=false,bOverride_OverrideRimShaderColor=false,bOverride_Bloom_Scale=false,bOverride_Bloom_Threshold=false,bOverride_Bloom_Tint=false,bOverride_Bloom_ScreenBlendThreshold=false,bOverride_Bloom_InterpolationDuration=false,bOverride_DOF_FalloffExponent=false,bOverride_DOF_BlurKernelSize=false,bOverride_DOF_BlurBloomKernelSize=false,bOverride_DOF_MaxNearBlurAmount=true,bOverride_DOF_MinBlurAmount=false,bOverride_DOF_MaxFarBlurAmount=true,bOverride_DOF_FocusType=false,bOverride_DOF_FocusInnerRadius=true,bOverride_DOF_FocusDistance=false,bOverride_DOF_FocusPosition=false,bOverride_DOF_InterpolationDuration=true,bOverride_DOF_BokehTexture=false,bOverride_MotionBlur_MaxVelocity=false,bOverride_MotionBlur_Amount=false,bOverride_MotionBlur_FullMotionBlur=false,bOverride_MotionBlur_CameraRotationThreshold=false,bOverride_MotionBlur_CameraTranslationThreshold=false,bOverride_MotionBlur_InterpolationDuration=false,bOverride_Scene_Desaturation=false,bOverride_Scene_Colorize=false,bOverride_Scene_TonemapperScale=false,bOverride_Scene_ImageGrainScale=false,bOverride_Scene_HighLights=true,bOverride_Scene_MidTones=true,bOverride_Scene_Shadows=false,bOverride_Scene_InterpolationDuration=true,bOverride_Scene_ColorGradingLUT=false,bOverride_RimShader_Color=true,bOverride_RimShader_InterpolationDuration=true,bOverride_MobileColorGrading=false,bEnableBloom=false,bEnableDOF=true,bEnableMotionBlur=false,bEnableSceneEffect=false,bAllowAmbientOcclusion=true,bOverrideRimShaderColor=false,Bloom_Scale=1.0000000,Bloom_Threshold=1.0000000,Bloom_Tint=(R=255,G=255,B=255,A=0),Bloom_ScreenBlendThreshold=10.0000000,Bloom_InterpolationDuration=1.0000000,DOF_BlurBloomKernelSize=16.0000000,DOF_FalloffExponent=4.0000000,DOF_BlurKernelSize=16.0000000,DOF_MaxNearBlurAmount=1.0000000,DOF_MinBlurAmount=0.5000000,DOF_MaxFarBlurAmount=1.0000000,DOF_FocusType=EFocusType.FOCUS_Distance,DOF_FocusInnerRadius=0.0000000,DOF_FocusDistance=0.0000000,DOF_FocusPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000),DOF_InterpolationDuration=0.0000000,DOF_BokehTexture=none,MotionBlur_MaxVelocity=1.0000000,MotionBlur_Amount=0.5000000,MotionBlur_FullMotionBlur=true,MotionBlur_CameraRotationThreshold=45.0000000,MotionBlur_CameraTranslationThreshold=10000.0000000,MotionBlur_InterpolationDuration=1.0000000,Scene_Desaturation=0.3000000,Scene_Colorize=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_TonemapperScale=1.0000000,Scene_ImageGrainScale=0.0000000,Scene_HighLights=(X=2.5000000,Y=2.5000000,Z=2.5000000),Scene_MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_Shadows=(X=0.1500000,Y=0.2000000,Z=0.2000000),Scene_InterpolationDuration=1.0000000,RimShader_Color=(R=0.4704400,G=0.5859730,B=0.8277260,A=1.0000000),RimShader_InterpolationDuration=1.0000000,ColorGrading_LookupTable=none,ColorGradingLUT=(LUTTextures=none,LUTWeights=none),MobileColorGrading=(TransitionTime=1.0000000,Blend=0.0000000,Desaturation=0.0000000,HighLights=(R=0.7000000,G=0.7000000,B=0.7000000,A=1.0000000),MidTones=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000),Shadows=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000)),MobilePostProcess=(bOverride_Mobile_BlurAmount=false,bOverride_Mobile_TransitionTime=false,bOverride_Mobile_Bloom_Scale=false,bOverride_Mobile_Bloom_Threshold=false,bOverride_Mobile_Bloom_Tint=false,bOverride_Mobile_DOF_Distance=false,bOverride_Mobile_DOF_MinRange=false,bOverride_Mobile_DOF_MaxRange=false,bOverride_Mobile_DOF_NearBlurFactor=false,bOverride_Mobile_DOF_FarBlurFactor=false,Mobile_BlurAmount=16.0000000,Mobile_TransitionTime=1.0000000,Mobile_Bloom_Scale=6.0000000,Mobile_Bloom_Threshold=0.5000000,Mobile_Bloom_Tint=(R=1.0000000,G=1.0000000,B=1.0000000,A=1.0000000),Mobile_DOF_Distance=1500.0000000,Mobile_DOF_MinRange=600.0000000,Mobile_DOF_MaxRange=1200.0000000,Mobile_DOF_NearBlurFactor=1.0000000,Mobile_DOF_FarBlurFactor=1.0000000))
}