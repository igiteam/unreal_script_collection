class EvilPostProcessManager extends Object within EvilLocalPlayer;

const FADE_STEP = 0.03;

var() float LightBloodScale;
var() float MediumBloodScale;
var() float MaxLightBlood;
var() float MaxMediumBlood;
var() float LightBloodTime;
var() float MediumBloodTime;
var protected array<Texture2D> MediumBloodTextures;
var MaterialInstanceConstant LBMaterialInstance;
var protected MaterialInstanceConstant MBMaterialInstance;
var protected MaterialInstanceConstant FMaterialInstance;
var protected MaterialInstanceConstant BBMaterialInstance;
var protected MaterialInstanceConstant CAMaterialInstance;
var protected MaterialInstanceConstant BWMaterialInstance;
var transient float LightBloodDelta;
var transient float MediumBloodDelta;
var transient float FadeDelta;
var transient float FadeMaxAlpha;
var transient float FadeMinAlpha;
var transient float LBPulseStartAlpha;
var transient float LBPulseMinAlpha;
var transient float LBPulseMaxAlpha;
var transient float LBPulseInTime;
var transient float LBPulseOutTime;
var transient float LBPulseMidTime;
var transient float LBPulseCurrTime;
var transient float BWDelta;
var transient float BWEndDepth;
var protected transient Color FadeColor;

function UberPostProcessEffect FindUberPostProcess()
{
    local int Idx;

    Idx = 0;
    J0x0B:

    // End:0x133 [Loop If]
    if(Idx < Outer.PlayerPostProcess.Effects.Length)
    {
        // End:0x125
        if((Outer.PlayerPostProcess.Effects[Idx] != none) && UberPostProcessEffect(Outer.PlayerPostProcess.Effects[Idx]) != none)
        {
            return UberPostProcessEffect(Outer.PlayerPostProcess.Effects[Idx]);
        }
        Idx++;
        // [Loop Continue]
        goto J0x0B;
    }
    return none;
    //return ReturnValue;    
}

function MaterialEffect InitEffect(out MaterialInstanceConstant MIC, name EffectName)
{
    local MaterialEffect MEffect;

    MEffect = none;
    // End:0x1A9
    if(MIC == none)
    {
        MEffect = MaterialEffect(Outer.PlayerPostProcess.FindPostProcessEffect(EffectName));
        // End:0x1A6
        if(MEffect != none)
        {
            // End:0x11E
            if((MaterialInstanceConstant(MEffect.Material) != none) && MEffect.Material.GetPackageName() == 'Transient')
            {
                MIC = MaterialInstanceConstant(MEffect.Material);                
            }
            else
            {
                MIC = new (MEffect) Class'Engine.MaterialInstanceConstant';
                MIC.SetParent(MEffect.Material);
                MEffect.Material = MIC;
            }            
        }        
    }
    else
    {
        MEffect = MaterialEffect(Outer.PlayerPostProcess.FindPostProcessEffect(EffectName));
        // End:0x20A
        if(MEffect == none)
        {
            return none;
        }
    }
    return MEffect;
    //return ReturnValue;    
}

function MaterialEffect ShowEffect(name EffectName, optional bool bEnable = true)
{
    local EvilPlayerController PC;
    local MaterialEffect MEffect;

    PC = EvilPlayerController(Outer.Actor);
    // End:0xF4
    if((PC != none) && PC.Player != none)
    {
        MEffect = MaterialEffect(Outer.PlayerPostProcess.FindPostProcessEffect(EffectName));
        // End:0xF4
        if(MEffect != none)
        {
            MEffect.bShowInGame = bEnable;
        }
    }
    return MEffect;
    //return ReturnValue;    
}

simulated function EnableBleachBypass(bool bEnable, optional float Opacity = 1.0000000)
{
    local MaterialEffect MEffect;

    MEffect = InitEffect(BBMaterialInstance, 'BleachBypass');
    // End:0x40
    if(MEffect == none)
    {
        return;
    }
    // End:0x147
    if(bEnable)
    {
        // End:0x92
        if(!MEffect.bShowInGame)
        {
            MEffect.bShowInGame = true;
        }
        BBMaterialInstance.SetScalarParameterValue('Opacity', Opacity);
        // End:0x117
        if(Class'Engine.WorldInfo'.static.IsConsoleBuild(1))
        {
            BBMaterialInstance.SetScalarParameterValue('Gamma', 1.7500000);            
        }
        else
        {
            BBMaterialInstance.SetScalarParameterValue('Gamma', 1.0000000);
        }        
    }
    else
    {
        MEffect.bShowInGame = false;
        BBMaterialInstance.SetScalarParameterValue('Opacity', 0.0000000);
    }
    //return;    
}

simulated function EnableChromatic(bool bEnable, optional float Scale = 1.0000000)
{
    local MaterialEffect MEffect;

    MEffect = InitEffect(CAMaterialInstance, 'Chromatic');
    // End:0x40
    if(MEffect == none)
    {
        return;
    }
    // End:0xC6
    if(bEnable)
    {
        // End:0x92
        if(!MEffect.bShowInGame)
        {
            MEffect.bShowInGame = true;
        }
        CAMaterialInstance.SetScalarParameterValue('Scale', Scale);        
    }
    else
    {
        MEffect.bShowInGame = false;
        CAMaterialInstance.SetScalarParameterValue('Scale', 0.0000000);
    }
    //return;    
}

simulated function EnableBlueWarp(float Duration, optional LinearColor warpColor = MakeLinearColor(2.0000000, 2.0000000, 6.0000000, 1.0000000), optional float Scale = 0.5000000, optional float startDepth = 15.0000000, optional float endDepth = 1.0000000)
{
    local MaterialEffect MEffect;

    // End:0x6B
    if(Outer.IsTimerActive(self, 'UpdateBlueWarp_T'))
    {
        return;
    }
    MEffect = InitEffect(BWMaterialInstance, 'BlueWarp');
    // End:0xA2
    if(MEffect == none)
    {
        return;
    }
    // End:0xE7
    if(!MEffect.bShowInGame)
    {
        MEffect.bShowInGame = true;
    }
    BWMaterialInstance.SetVectorParameterValue('Color', warpColor);
    BWMaterialInstance.SetScalarParameterValue('DistortScale', Scale);
    BWMaterialInstance.SetScalarParameterValue('DepthFocus', startDepth);
    BWDelta = (startDepth - endDepth) / (Duration * float(33));
    BWEndDepth = endDepth;
    Outer.SetTimer(0.0300000, self, true, 'UpdateBlueWarp_T');
    //return;    
}

simulated function UpdateBlueWarp_T()
{
    local float val;

    BWMaterialInstance.GetScalarParameterValue('DepthFocus', val);
    val -= BWDelta;
    BWMaterialInstance.SetScalarParameterValue('DepthFocus', val);
    // End:0xCA
    if(val <= BWEndDepth)
    {
        ShowEffect('BlueWarp', false);
        Outer.ClearTimer(self, 'UpdateBlueWarp_T');
    }
    //return;    
}

simulated function EnableLightBlood(float fAlphaVal)
{
    local LinearColor Offset;
    local MaterialEffect MEffect;
    local float D;

    return;
    // End:0xBA
    if(((Outer.IsTimerActive(self, 'UpdateLightBloodPP_T') || Outer.IsTimerActive(self, 'FadeInLightBloodPP_T')) || Outer.IsTimerActive(self, 'FadeOutLightBloodPP_T')) || Outer.IsTimerActive(self, 'StartFadeOutLightBloodPP_T'))
    {
        return;
    }
    MEffect = InitEffect(LBMaterialInstance, 'LightBlood');
    // End:0x274
    if(MEffect != none)
    {
        Offset.R = 0.0000000;
        Offset.G = 0.0000000;
        D = FClamp(fAlphaVal * LightBloodScale, 0.0000000, MaxLightBlood);
        LightBloodDelta = D / (LightBloodTime + ((FRand() * LightBloodTime) * 0.2500000));
        LBMaterialInstance.SetScalarParameterValue('Opacity', D);
        LBMaterialInstance.SetScalarParameterValue('Angle', 0.0000000);
        LBMaterialInstance.SetVectorParameterValue('Offset', Offset);
        MEffect.bShowInGame = true;
        Outer.SetTimer(0.0300000, self, true, 'UpdateLightBloodPP_T');
    }
    //return;    
}

function UpdateLightBloodPP_T()
{
    local float Opacity;

    LBMaterialInstance.GetScalarParameterValue('Opacity', Opacity);
    Opacity -= LightBloodDelta;
    LBMaterialInstance.SetScalarParameterValue('Opacity', Opacity);
    // End:0xC4
    if(Opacity <= float(0))
    {
        Outer.ClearTimer(self, 'UpdateLightBloodPP_T');
        ShowEffect('LightBlood', false);
    }
    //return;    
}

simulated function EnableLightBloodPulse(float fMinAlpha, float fMaxAlpha, float fInTime, float fMidTime, float fOutTime, optional float MaxTime = 10.0000000)
{
    local LinearColor Offset;
    local MaterialEffect MEffect;
    local bool bActivePulseFadeIn, bActivePulseFadeOut, bActivePulseSustain;

    // End:0x37
    if(Outer.IsTimerActive(self, 'UpdateLightBloodPP_T'))
    {
        return;
    }
    MEffect = InitEffect(LBMaterialInstance, 'LightBlood');
    // End:0x43C
    if(MEffect != none)
    {
        bActivePulseFadeIn = Outer.IsTimerActive(self, 'FadeInLightBloodPP_T');
        bActivePulseFadeOut = Outer.IsTimerActive(self, 'FadeOutLightBloodPP_T');
        bActivePulseSustain = Outer.IsTimerActive(self, 'StartFadeOutLightBloodPP_T');
        // End:0x24B
        if((!bActivePulseFadeIn && !bActivePulseFadeOut) && !bActivePulseSustain)
        {
            Offset.R = 0.0000000;
            Offset.G = 0.0000000;
            LBMaterialInstance.SetScalarParameterValue('Angle', float(Rand(2)) * 3.1415930);
            LBMaterialInstance.SetVectorParameterValue('Offset', Offset);
            LBPulseStartAlpha = fMinAlpha;
            LBMaterialInstance.SetScalarParameterValue('Opacity', LBPulseStartAlpha);
            MEffect.bShowInGame = true;            
        }
        else
        {
            LBMaterialInstance.GetScalarParameterValue('Opacity', LBPulseStartAlpha);
            // End:0x2B2
            if(bActivePulseFadeIn)
            {
                Outer.ClearTimer(self, 'FadeInLightBloodPP_T');
            }
            // End:0x2E8
            if(bActivePulseSustain)
            {
                Outer.ClearTimer(self, 'StartFadeOutLightBloodPP_T');
            }
            // End:0x31E
            if(bActivePulseFadeOut)
            {
                Outer.ClearTimer(self, 'FadeOutLightBloodPP_T');
            }
        }
        LBPulseMinAlpha = fMinAlpha;
        LBPulseMaxAlpha = fMaxAlpha;
        LBPulseInTime = fInTime;
        LBPulseOutTime = fOutTime;
        LBPulseMidTime = fMidTime;
        LBPulseCurrTime = Outer.Actor.WorldInfo.TimeSeconds;
        Outer.SetTimer(0.0300000, self, true, 'FadeInLightBloodPP_T');
        Outer.SetTimer(LBPulseInTime + LBPulseMidTime, self, false, 'StartFadeOutLightBloodPP_T');
    }
    //return;    
}

function StartFadeOutLightBloodPP_T()
{
    Outer.ClearTimer(self, 'FadeInLightBloodPP_T');
    LBPulseCurrTime = Outer.Actor.WorldInfo.TimeSeconds;
    Outer.SetTimer(0.0300000, self, true, 'FadeOutLightBloodPP_T');
    //return;    
}

function FadeInLightBloodPP_T()
{
    local float Opacity, itp;

    // End:0xD1
    if((Outer.Actor.WorldInfo.TimeSeconds - LBPulseCurrTime) >= LBPulseInTime)
    {
        Opacity = LBPulseMaxAlpha;
        LBMaterialInstance.SetScalarParameterValue('Opacity', Opacity);
        Outer.ClearTimer(self, 'FadeInLightBloodPP_T');        
    }
    else
    {
        itp = FClamp((Outer.Actor.WorldInfo.TimeSeconds - LBPulseCurrTime) / LBPulseInTime, 0.0000000, 1.0000000);
        Opacity = Lerp(LBPulseStartAlpha, LBPulseMaxAlpha, itp);
        LBMaterialInstance.SetScalarParameterValue('Opacity', Opacity);
    }
    //return;    
}

function FadeOutLightBloodPP_T()
{
    local float Opacity, itp;

    // End:0xE5
    if((Outer.Actor.WorldInfo.TimeSeconds - LBPulseCurrTime) >= LBPulseOutTime)
    {
        Opacity = LBPulseMinAlpha;
        LBMaterialInstance.SetScalarParameterValue('Opacity', Opacity);
        Outer.ClearTimer(self, 'FadeOutLightBloodPP_T');
        ShowEffect('LightBlood', false);        
    }
    else
    {
        itp = FClamp((Outer.Actor.WorldInfo.TimeSeconds - LBPulseCurrTime) / LBPulseOutTime, 0.0000000, 1.0000000);
        Opacity = Lerp(LBPulseMaxAlpha, LBPulseMinAlpha, itp);
        LBMaterialInstance.SetScalarParameterValue('Opacity', Opacity);
    }
    //return;    
}

function TurnOffLightBlood()
{
    LBPulseMinAlpha = 0.0000000;
    LBPulseMaxAlpha = 0.0000000;
    LBPulseInTime = 0.0000000;
    LBPulseOutTime = 0.0000000;
    LBPulseMidTime = 0.0000000;
    Outer.ClearTimer(self, 'FadeInLightBloodPP_T');
    Outer.ClearTimer(self, 'FadeOutLightBloodPP_T');
    Outer.ClearTimer(self, 'StartFadeOutLightBloodPP_T');
    ShowEffect('LightBlood', false);
    LBMaterialInstance = none;
    //return;    
}

function bool PulseEffectsActive()
{
    return Outer.IsTimerActive(self, 'FadeInLightBloodPP_T') || Outer.IsTimerActive(self, 'FadeOutLightBloodPP_T');
    //return ReturnValue;    
}

simulated function EnableMediumBlood(float fAlphaVal, optional int iTextureIndex = Rand(MediumBloodTextures.Length))
{
    local LinearColor Offset;
    local MaterialEffect MEffect;
    local float D;

    MEffect = InitEffect(MBMaterialInstance, 'MediumBlood');
    // End:0x254
    if(MEffect != none)
    {
        Offset.R = (10.0500000 * FRand()) - 5.0250000;
        Offset.G = (10.0500000 * FRand()) - 5.0250000;
        D = FClamp(fAlphaVal * MediumBloodScale, 0.0000000, MaxMediumBlood);
        MediumBloodDelta = D / (MediumBloodTime + ((FRand() * MediumBloodTime) * 0.2500000));
        MBMaterialInstance.SetScalarParameterValue('Opacity', D);
        MBMaterialInstance.SetScalarParameterValue('Angle', (FRand() * float(2)) * 3.1415930);
        MBMaterialInstance.SetVectorParameterValue('Offset', Offset);
        MBMaterialInstance.SetTextureParameterValue('BloodTexture', MediumBloodTextures[iTextureIndex]);
        MEffect.bShowInGame = true;
        Outer.SetTimer(0.0000000, self, true, 'UpdateMediumBloodPP_T');
        Outer.SetTimer(0.0300000, self, true, 'UpdateMediumBloodPP_T');
    }
    //return;    
}

function UpdateMediumBloodPP_T()
{
    local float Opacity;

    MBMaterialInstance.GetScalarParameterValue('Opacity', Opacity);
    Opacity -= MediumBloodDelta;
    MBMaterialInstance.SetScalarParameterValue('Opacity', Opacity);
    // End:0xC4
    if(Opacity <= float(0))
    {
        Outer.ClearTimer(self, 'UpdateMediumBloodPP_T');
        ShowEffect('MediumBlood', false);
    }
    //return;    
}

simulated function EnableFade(LinearColor fadeCol, float FadeTime, optional bool bFadeOutBlack = false, optional float fadeMaxA = 1.0000000, optional float fadeMinA = 0.0000000)
{
    local MaterialEffect MEffect;

    // End:0x45
    if(Outer.IsTimerActive(self, 'UpdateFade_T'))
    {
        return;
    }
    // End:0xC3
    if(Outer.IsTimerActive(self, 'UpdateUnFade_T'))
    {
        Outer.ClearTimer(self, 'UpdateUnFade_T');
        Outer.ClearTimer(self, 'StopUnFade_T');
    }
    MEffect = InitEffect(FMaterialInstance, 'FadeMask');
    // End:0x290
    if(MEffect != none)
    {
        FadeMaxAlpha = fadeMaxA;
        FadeMinAlpha = fadeMinA;
        FMaterialInstance.SetVectorParameterValue('Color', fadeCol);
        // End:0x1BC
        if(FadeTime > float(0))
        {
            FadeDelta = (1.0000000 / FadeTime) * (1.0000000 / 30.0000000);
            FMaterialInstance.SetScalarParameterValue('Alpha', fadeMinA);            
        }
        else
        {
            FadeDelta = 0.0000000;
            FMaterialInstance.SetScalarParameterValue('Alpha', fadeMaxA);
        }
        MEffect.bShowInGame = true;
        // End:0x25D
        if(FadeTime > float(0))
        {
            Outer.SetTimer(0.0300000, self, true, 'UpdateFade_T');
        }
        Outer.SetTimer(FadeTime, self, false, 'StopFade_T');
    }
    //return;    
}

function UpdateFade_T()
{
    local float oldA;

    FMaterialInstance.GetScalarParameterValue('Alpha', oldA);
    oldA += FadeDelta;
    oldA = FClamp(oldA, FadeMinAlpha, FadeMaxAlpha);
    FMaterialInstance.SetScalarParameterValue('Alpha', oldA);
    //return;    
}

function StartFadeOutBlack_T()
{
    FadeDelta = 0.0000000;
    Outer.SetTimer(0.0300000, self, true, 'UpdateFadeOutBlack_T');
    //return;    
}

function UpdateFadeOutBlack_T()
{
    local Color tmpC;
    local LinearColor Col;

    FMaterialInstance.GetVectorParameterValue('Color', Col);
    tmpC = LinearColorToColor(Col);
    tmpC = LerpColor(tmpC, MakeColor(0, 0, 0, 0), FadeDelta);
    Col = ColorToLinearColor(tmpC);
    FMaterialInstance.SetVectorParameterValue('Color', Col);
    FadeDelta += 0.0075000;
    //return;    
}

function StopFade_T()
{
    Outer.ClearTimer(self, 'UpdateFade_T');
    //return;    
}

simulated function Unfade(float FadeTime)
{
    local MaterialEffect MEffect;
    local float oldA;

    // End:0x2E
    if(Outer.IsTimerActive(self, 'UpdateUnFade_T'))
    {
        return;
    }
    // End:0xAC
    if(Outer.IsTimerActive(self, 'UpdateFade_T'))
    {
        Outer.ClearTimer(self, 'UpdateFade_T');
        Outer.ClearTimer(self, 'StopFade_T');
    }
    MEffect = InitEffect(FMaterialInstance, 'FadeMask');
    // End:0x1B9
    if(MEffect != none)
    {
        FMaterialInstance.GetScalarParameterValue('Alpha', oldA);
        FadeDelta = oldA / (FadeTime * float(33));
        MEffect.bShowInGame = true;
        Outer.SetTimer(0.0300000, self, true, 'UpdateUnFade_T');
        Outer.SetTimer(FadeTime, self, false, 'StopUnFade_T');
    }
    //return;    
}

function UpdateUnFade_T()
{
    local float oldA;

    FMaterialInstance.GetScalarParameterValue('Alpha', oldA);
    oldA -= FadeDelta;
    FMaterialInstance.SetScalarParameterValue('Alpha', oldA);
    //return;    
}

function StopUnFade_T()
{
    ShowEffect('FadeMask', false);
    Outer.ClearTimer(self, 'UpdateUnFade_T');
    //return;    
}

static final function Color LinearColorToColor(LinearColor OldColor)
{
    return MakeColor(byte(OldColor.R * 255.0000000), byte(OldColor.G * 255.0000000), byte(OldColor.B * 255.0000000), byte(OldColor.A * 255.0000000));
    //return ReturnValue;    
}

function Reset()
{
    local int I;
    local PostProcessEffect Meff;

    LBMaterialInstance = none;
    MBMaterialInstance = none;
    BBMaterialInstance = none;
    CAMaterialInstance = none;
    BWMaterialInstance = none;
    Outer.ClearAllTimers(self);
    I = 0;
    J0x62:

    // End:0x132 [Loop If]
    if(I < Outer.PlayerPostProcess.Effects.Length)
    {
        Meff = Outer.PlayerPostProcess.Effects[I];
        // End:0x124
        if(MaterialEffect(Meff) != none)
        {
            Meff.bShowInGame = false;
        }
        ++I;
        // [Loop Continue]
        goto J0x62;
    }
    Outer.ClearPostProcessSettingsOverride(0.0000000);
    //return;    
}

defaultproperties
{
    LightBloodScale=50.0000000
    MediumBloodScale=12.7500000
    MaxLightBlood=15.0000000
    MaxMediumBlood=20.0000000
    LightBloodTime=40.0000000
    MediumBloodTime=200.0000000
    MediumBloodTextures[0]=Texture2D'PP_Resources.Textures.strzalka_krew'
    MediumBloodTextures[1]=Texture2D'PP_Resources.Textures.strzalka_krew1'
}