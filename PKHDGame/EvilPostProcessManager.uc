class EvilPostProcessManager extends Actor
    notplaceable
    hidecategories(Navigation);

struct PPParameters
{
    var float BloomScale;
    var float BloomThreshold;
    var Color BloomTint;
    var bool DofEnabled;
    var DOFEffect.EFocusType DofFocusType;
    var float DofBlurKernelSize;
    var float DofFalloffExponent;
    var float DofMinBlurAmount;
    var float DofMaxFarBlurAmount;
    var float DofMaxNearBlurAmount;
    var float DofFocusInnerRadius;
    var float DofFocusDistance;
    var Vector DofFocusPosition;
    var float SceneDesaturation;
    var Vector Scene_Colorize;

    structdefaultproperties
    {
        BloomScale=0.0000000
        BloomThreshold=1.0000000
        BloomTint=(R=255,G=255,B=255,A=0)
        DofEnabled=false
        DofFocusType=EFocusType.FOCUS_Distance
        DofBlurKernelSize=8.0000000
        DofFalloffExponent=4.0000000
        DofMinBlurAmount=1.0000000
        DofMaxFarBlurAmount=1.0000000
        DofMaxNearBlurAmount=0.0000000
        DofFocusInnerRadius=300.0000000
        DofFocusDistance=550.0000000
        DofFocusPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        SceneDesaturation=0.0000000
        Scene_Colorize=(X=1.0000000,Y=1.0000000,Z=1.0000000)
    }
};

struct PPParams_Internal
{
    var PPParameters P;
    var bool Enabled;
    var name Id;

    structdefaultproperties
    {
        P=(BloomScale=0.0000000,BloomThreshold=1.0000000,BloomTint=(R=255,G=255,B=255,A=0),DofEnabled=false,DofFocusType=EFocusType.FOCUS_Distance,DofBlurKernelSize=8.0000000,DofFalloffExponent=4.0000000,DofMinBlurAmount=1.0000000,DofMaxFarBlurAmount=1.0000000,DofMaxNearBlurAmount=0.0000000,DofFocusInnerRadius=300.0000000,DofFocusDistance=550.0000000,DofFocusPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000),SceneDesaturation=0.0000000,Scene_Colorize=(X=1.0000000,Y=1.0000000,Z=1.0000000))
        Enabled=false
        Id="None"
    }
};

var LocalPlayer LocalPlayer;
var() float LightBloodScale;
var() float MediumBloodScale;
var() float MaxLightBlood;
var() float MaxBarsDistort;
var() float MaxBarsAlpha;
var() float MaxMediumBlood;
var() float LightBloodTime;
var() float MediumBloodTime;
var() float BarsTime;
var() int BlurRadius;
var protected array<Texture2D> MediumBloodTextures;
var protected float OldLevelBloom;
var protected array<PPParams_Internal> Params;
var PPParameters UtilParam;
var protected MaterialInstanceConstant ScarMaterialInstance;
var protected MaterialInstanceConstant LBMaterialInstance;
var protected MaterialInstanceConstant MBMaterialInstance;
var protected MaterialInstanceConstant ABMaterialInstance;
var protected MaterialInstanceConstant FMaterialInstance;
var protected MaterialInstanceConstant HGMaterialInstance;
var protected MaterialInstanceConstant GBMaterialInstance;
var protected MaterialInstanceConstant IMaterialInstance;
var protected MaterialInstanceConstant BBMaterialInstance;
var protected MaterialInstanceConstant CAMaterialInstance;
var protected MaterialInstanceConstant BWMaterialInstance;
var protected MaterialInstanceConstant CSMaterialInstance;
var protected MaterialInstanceConstant PentMaterialInstance;
var PostProcessSettings TempPPS;
var transient float LightBloodDelta;
var transient float MediumBloodDelta;
var transient float BarsDelta;
var transient float FadeDelta;
var transient float FadeMaxAlpha;
var transient float FadeMinAlpha;
var transient float HexGridMaxOpacity;
var transient float GradientBarMaxOpacity;
var transient float LBPulseMinAlpha;
var transient float LBPulseMaxAlpha;
var transient float LBPulseInTime;
var transient float LBPulseOutTime;
var transient float LBPulseMidTime;
var transient float LBPulseCurrTime;
var transient float PentCurrTime;
var transient float PentFadeTime;
var transient float BWDelta;
var transient float BWEndDepth;
var protected transient PPParameters FadeParams;
var protected transient Color FadeColor;
var transient BlurEffect BEffect;
var bool LevelDofEnabled;
var DOFEffect.EFocusType LevelDofFocusType;
var float LevelDofBlurKernelSize;
var float LevelDofFalloffExponent;
var float LevelDofMinBlurAmount;
var float LevelDofMaxFarBlurAmount;
var float LevelDofMaxNearBlurAmount;
var float LevelDofFocusInnerRadius;
var float LevelDofFocusDistance;
var Vector LevelDofFocusPosition;

function Update(name Id, PPParameters P)
{
    local int Index;
    local PPParams_Internal pint;

    Index = Params.Find('Id', Id);
    // End:0x98
    if(Index != -1)
    {
        Params[Index].P = P;
        Params[Index].Enabled = true;        
    }
    else
    {
        // End:0xB2
        if(Params.Length == 0)
        {
            StoreDOFParams();
        }
        pint.P = P;
        pint.Id = Id;
        pint.Enabled = true;
        Params.AddItem(pint);
    }
    //return;    
}

function Deactivate(name Id)
{
    local int Index;

    Index = Params.Find('Id', Id);
    // End:0x6F
    if(Index != -1)
    {
        Params[Index].Enabled = false;
        RestoreDOFParams();
    }
    //return;    
}

function DeactivateAll()
{
    Params.Remove(0, Params.Length);
    Reset();
    LocalPlayer.ClearPostProcessSettingsOverride(0.7500000);
    //return;    
}

function PushParams()
{
    TempPPS = WorldInfo.DefaultPostProcessSettings;
    UtilParam.BloomScale = TempPPS.Bloom_Scale;
    UtilParam.BloomTint = TempPPS.Bloom_Tint;
    UtilParam.BloomThreshold = TempPPS.Bloom_Threshold;
    UtilParam.SceneDesaturation = TempPPS.Scene_Desaturation;
    UtilParam.Scene_Colorize = TempPPS.Scene_Colorize;
    //return;    
}

function PopParams()
{
    // End:0x159
    if(LocalPlayer != none)
    {
        TempPPS.Bloom_Scale = UtilParam.BloomScale;
        TempPPS.Bloom_Tint = UtilParam.BloomTint;
        TempPPS.Bloom_Threshold = UtilParam.BloomThreshold;
        TempPPS.Scene_Desaturation = UtilParam.SceneDesaturation;
        TempPPS.Scene_Colorize = UtilParam.Scene_Colorize;
        LocalPlayer.OverridePostProcessSettings(TempPPS, 0.0100000);
    }
    //return;    
}

simulated event Tick(float DeltaTime)
{
    local PPParams_Internal P;
    local bool anydof;

    // End:0x65
    if((CameraActor(PlayerController(Owner).ViewTarget) != none) || PlayerController(Owner).bCinematicMode)
    {
        return;
    }
    // End:0x77
    if(Params.Length == 0)
    {
        return;
    }
    LocalPlayer = LocalPlayer(EvilPlayerController(Owner).Player);
    // End:0xE38
    if(LocalPlayer != none)
    {
        TempPPS = WorldInfo.DefaultPostProcessSettings;
        TempPPS.bOverride_Bloom_Scale = true;
        TempPPS.bOverride_Bloom_Threshold = true;
        TempPPS.bOverride_Bloom_Tint = true;
        TempPPS.bOverride_Scene_Colorize = true;
        TempPPS.bOverride_EnableDOF = !Class'Engine.Engine'.static.IsSplitScreen();
        anydof = false;
        // End:0x74F
        foreach Params(P)
        {
            // End:0x1EC
            if(!P.Enabled)
            {
                continue;                
            }
            else
            {
                // End:0x22B
                if(P.P.DofEnabled)
                {
                    anydof = true;
                }
                // End:0x2C7
                if(P.P.BloomScale > TempPPS.Bloom_Scale)
                {
                    TempPPS.Bloom_Scale = P.P.BloomScale;
                }
                // End:0x363
                if(P.P.BloomThreshold < TempPPS.Bloom_Threshold)
                {
                    TempPPS.Bloom_Threshold = P.P.BloomThreshold;
                }
                TempPPS.Bloom_Tint = P.P.BloomTint;
                // End:0x6B6
                if(anydof)
                {
                    TempPPS.bEnableDOF = P.P.DofEnabled;
                    TempPPS.DOF_FocusType = P.P.DofFocusType;
                    TempPPS.DOF_BlurKernelSize = P.P.DofBlurKernelSize;
                    TempPPS.DOF_FalloffExponent = P.P.DofFalloffExponent;
                    TempPPS.DOF_MinBlurAmount = P.P.DofMinBlurAmount;
                    TempPPS.DOF_MaxFarBlurAmount = P.P.DofMaxFarBlurAmount;
                    TempPPS.DOF_MaxNearBlurAmount = P.P.DofMaxNearBlurAmount;
                    TempPPS.DOF_FocusInnerRadius = P.P.DofFocusInnerRadius;
                    TempPPS.DOF_FocusDistance = P.P.DofFocusDistance;
                    TempPPS.DOF_FocusPosition = P.P.DofFocusPosition;
                }
                TempPPS.Scene_Desaturation = P.P.SceneDesaturation;
                TempPPS.Scene_Colorize = P.P.Scene_Colorize;                
            }
        }        
        TempPPS.bOverride_DOF_FocusType = anydof;
        TempPPS.bOverride_DOF_FocusDistance = anydof;
        TempPPS.bOverride_DOF_MinBlurAmount = anydof;
        TempPPS.bOverride_DOF_MaxNearBlurAmount = anydof;
        TempPPS.bOverride_DOF_MaxFarBlurAmount = anydof;
        TempPPS.bOverride_DOF_BlurKernelSize = anydof;
        TempPPS.bOverride_DOF_FocusInnerRadius = anydof;
        TempPPS.bOverride_DOF_FocusPosition = anydof;
        LocalPlayer.OverridePostProcessSettings(TempPPS, 0.1000000);
        // End:0xE38
        if(Params.Length > 0)
        {
            // End:0xE38
            if(!CheckPPVolumes(anydof))
            {
                // End:0xBE8
                if(anydof)
                {
                    WorldInfo.DefaultPostProcessSettings.bEnableDOF = true;
                    WorldInfo.DefaultPostProcessSettings.DOF_FocusType = TempPPS.DOF_FocusType;
                    WorldInfo.DefaultPostProcessSettings.DOF_BlurKernelSize = TempPPS.DOF_BlurKernelSize;
                    WorldInfo.DefaultPostProcessSettings.DOF_FalloffExponent = TempPPS.DOF_FalloffExponent;
                    WorldInfo.DefaultPostProcessSettings.DOF_MinBlurAmount = TempPPS.DOF_MinBlurAmount;
                    WorldInfo.DefaultPostProcessSettings.DOF_MaxFarBlurAmount = TempPPS.DOF_MaxFarBlurAmount;
                    WorldInfo.DefaultPostProcessSettings.DOF_MaxNearBlurAmount = TempPPS.DOF_MaxNearBlurAmount;
                    WorldInfo.DefaultPostProcessSettings.DOF_FocusInnerRadius = TempPPS.DOF_FocusInnerRadius;
                    WorldInfo.DefaultPostProcessSettings.DOF_FocusDistance = TempPPS.DOF_FocusDistance;
                    WorldInfo.DefaultPostProcessSettings.DOF_FocusPosition = TempPPS.DOF_FocusPosition;                    
                }
                else
                {
                    WorldInfo.DefaultPostProcessSettings.bEnableDOF = LevelDofEnabled;
                    WorldInfo.DefaultPostProcessSettings.DOF_FocusType = LevelDofFocusType;
                    WorldInfo.DefaultPostProcessSettings.DOF_BlurKernelSize = LevelDofBlurKernelSize;
                    WorldInfo.DefaultPostProcessSettings.DOF_FalloffExponent = LevelDofFalloffExponent;
                    WorldInfo.DefaultPostProcessSettings.DOF_MinBlurAmount = LevelDofMinBlurAmount;
                    WorldInfo.DefaultPostProcessSettings.DOF_MaxFarBlurAmount = LevelDofMaxFarBlurAmount;
                    WorldInfo.DefaultPostProcessSettings.DOF_MaxNearBlurAmount = LevelDofMaxNearBlurAmount;
                    WorldInfo.DefaultPostProcessSettings.DOF_FocusInnerRadius = LevelDofFocusInnerRadius;
                    WorldInfo.DefaultPostProcessSettings.DOF_FocusDistance = LevelDofFocusDistance;
                    WorldInfo.DefaultPostProcessSettings.DOF_FocusPosition = LevelDofFocusPosition;
                }
            }
        }
    }
    //return;    
}

function bool CheckPPVolumes(bool anydof)
{
    local PostProcessVolume V, finalV;
    local Pawn PlayerPawn;
    local float Priority;

    PlayerPawn = PlayerController(Owner).Pawn;
    Priority = -1000.0000000;
    // End:0x77
    if((PlayerPawn == none) || !PlayerPawn.IsAliveAndWell())
    {
        return false;
    }
    // End:0x149
    foreach AllActors(Class'Engine.PostProcessVolume', V)
    {
        // End:0x148
        if((V.bEnabled && V.Encompasses(PlayerPawn)) && Priority < V.Priority)
        {
            Priority = V.Priority;
            finalV = V;
        }        
    }    
    // End:0x6B3
    if(Priority != float(-1000))
    {
        // End:0x461
        if(anydof)
        {
            finalV.Settings.bEnableDOF = true;
            finalV.Settings.DOF_FocusType = TempPPS.DOF_FocusType;
            finalV.Settings.DOF_BlurKernelSize = TempPPS.DOF_BlurKernelSize;
            finalV.Settings.DOF_FalloffExponent = TempPPS.DOF_FalloffExponent;
            finalV.Settings.DOF_MinBlurAmount = TempPPS.DOF_MinBlurAmount;
            finalV.Settings.DOF_MaxFarBlurAmount = TempPPS.DOF_MaxFarBlurAmount;
            finalV.Settings.DOF_MaxNearBlurAmount = TempPPS.DOF_MaxNearBlurAmount;
            finalV.Settings.DOF_FocusInnerRadius = TempPPS.DOF_FocusInnerRadius;
            finalV.Settings.DOF_FocusDistance = TempPPS.DOF_FocusDistance;
            finalV.Settings.DOF_FocusPosition = TempPPS.DOF_FocusPosition;            
        }
        else
        {
            finalV.Settings.bEnableDOF = LevelDofEnabled;
            finalV.Settings.DOF_FocusType = LevelDofFocusType;
            finalV.Settings.DOF_BlurKernelSize = LevelDofBlurKernelSize;
            finalV.Settings.DOF_FalloffExponent = LevelDofFalloffExponent;
            finalV.Settings.DOF_MinBlurAmount = LevelDofMinBlurAmount;
            finalV.Settings.DOF_MaxFarBlurAmount = LevelDofMaxFarBlurAmount;
            finalV.Settings.DOF_MaxNearBlurAmount = LevelDofMaxNearBlurAmount;
            finalV.Settings.DOF_FocusInnerRadius = LevelDofFocusInnerRadius;
            finalV.Settings.DOF_FocusDistance = LevelDofFocusDistance;
            finalV.Settings.DOF_FocusPosition = LevelDofFocusPosition;
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

function SetLevelBloom(float Scale)
{
    local PostProcessVolume V, finalV;
    local Pawn PlayerPawn;
    local float Priority;

    PlayerPawn = PlayerController(Owner).Pawn;
    Priority = -1000.0000000;
    // End:0x66
    if(!PlayerPawn.IsAliveAndWell())
    {
        return;
    }
    // End:0x138
    foreach AllActors(Class'Engine.PostProcessVolume', V)
    {
        // End:0x137
        if((V.bEnabled && V.Encompasses(PlayerPawn)) && Priority < V.Priority)
        {
            Priority = V.Priority;
            finalV = V;
        }        
    }    
    // End:0x18C
    if(Priority != float(-1000))
    {
        finalV.Settings.Bloom_Scale = Scale;        
    }
    else
    {
        WorldInfo.DefaultPostProcessSettings.Bloom_Scale = Scale;
    }
    //return;    
}

function RestoreLevelBloom()
{
    local PostProcessVolume V, finalV;
    local Pawn PlayerPawn;
    local float Priority;

    PlayerPawn = PlayerController(Owner).Pawn;
    Priority = -1000.0000000;
    // End:0x66
    if(!PlayerPawn.IsAliveAndWell())
    {
        return;
    }
    // End:0x138
    foreach AllActors(Class'Engine.PostProcessVolume', V)
    {
        // End:0x137
        if((V.bEnabled && V.Encompasses(PlayerPawn)) && Priority < V.Priority)
        {
            Priority = V.Priority;
            finalV = V;
        }        
    }    
    // End:0x18C
    if(Priority != float(-1000))
    {
        finalV.Settings.Bloom_Scale = OldLevelBloom;        
    }
    else
    {
        WorldInfo.DefaultPostProcessSettings.Bloom_Scale = OldLevelBloom;
    }
    //return;    
}

function MaterialEffect InitEffect(out MaterialInstanceConstant MIC, name EffectName)
{
    local MaterialEffect MEffect;

    MEffect = none;
    // End:0x1BA
    if((MIC == none) && LocalPlayer != none)
    {
        MEffect = MaterialEffect(LocalPlayer.PlayerPostProcess.FindPostProcessEffect(EffectName));
        // End:0x1B7
        if(MEffect != none)
        {
            // End:0x12F
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
        // End:0x22A
        if(LocalPlayer != none)
        {
            MEffect = MaterialEffect(LocalPlayer.PlayerPostProcess.FindPostProcessEffect(EffectName));
            // End:0x22A
            if(MEffect == none)
            {
                return none;
            }
        }
    }
    return MEffect;
    //return ReturnValue;    
}

function MaterialEffect ShowEffect(name EffectName, optional bool bEnable = true)
{
    local EvilPlayerController PC;
    local MaterialEffect MEffect;

    PC = EvilPlayerController(Owner);
    // End:0xDF
    if((PC != none) && PC.Player != none)
    {
        MEffect = MaterialEffect(LocalPlayer.PlayerPostProcess.FindPostProcessEffect(EffectName));
        // End:0xDF
        if(MEffect != none)
        {
            MEffect.bShowInGame = bEnable;
        }
    }
    return MEffect;
    //return ReturnValue;    
}

simulated function EnableCellShader(bool bEnable)
{
    local MaterialEffect MEffect;

    MEffect = InitEffect(CSMaterialInstance, 'CellShade');
    // End:0x37
    if(MEffect == none)
    {
        return;
    }
    // End:0x8C
    if(bEnable)
    {
        // End:0x89
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

    // End:0x56
    if(IsTimerActive('UpdateBlueWarp_T'))
    {
        return;
    }
    MEffect = InitEffect(BWMaterialInstance, 'BlueWarp');
    // End:0x8D
    if(MEffect == none)
    {
        return;
    }
    // End:0xD2
    if(!MEffect.bShowInGame)
    {
        MEffect.bShowInGame = true;
    }
    BWMaterialInstance.SetVectorParameterValue('Color', warpColor);
    BWMaterialInstance.SetScalarParameterValue('DistortScale', Scale);
    BWMaterialInstance.SetScalarParameterValue('DepthFocus', startDepth);
    BWDelta = (startDepth - endDepth) / (Duration * float(33));
    BWEndDepth = endDepth;
    SetTimer(0.0300000, true, 'UpdateBlueWarp_T');
    //return;    
}

simulated function UpdateBlueWarp_T()
{
    local float val;

    BWMaterialInstance.GetScalarParameterValue('DepthFocus', val);
    val -= BWDelta;
    BWMaterialInstance.SetScalarParameterValue('DepthFocus', val);
    // End:0xB5
    if(val <= BWEndDepth)
    {
        ShowEffect('BlueWarp', false);
        ClearTimer('UpdateBlueWarp_T');
    }
    //return;    
}

simulated function EnableScar(bool bEnable)
{
    local LinearColor Offset;
    local MaterialEffect MEffect;

    MEffect = InitEffect(ScarMaterialInstance, 'Scar');
    // End:0x37
    if(MEffect == none)
    {
        return;
    }
    // End:0x198
    if(bEnable && MEffect.bShowInGame == false)
    {
        Offset.R = (0.2500000 * FRand()) - 0.1250000;
        Offset.G = (0.2500000 * FRand()) - 0.1250000;
        ScarMaterialInstance.SetScalarParameterValue('Opacity', 1.0000000);
        ScarMaterialInstance.SetScalarParameterValue('Angle', ((FRand() * float(2)) * 3.1415930) - 3.1415930);
        ScarMaterialInstance.SetVectorParameterValue('Offset', Offset);
        MEffect.bShowInGame = true;
        SetTimer(0.0300000, true, 'UpdateScarPP_T');        
    }
    else
    {
        MEffect.bShowInGame = false;
    }
    //return;    
}

function UpdateScarPP_T()
{
    local float Opacity;

    ScarMaterialInstance.GetScalarParameterValue('Opacity', Opacity);
    Opacity -= 0.0350000;
    ScarMaterialInstance.SetScalarParameterValue('Opacity', Opacity);
    // End:0xAB
    if(Opacity <= float(0))
    {
        ClearTimer('UpdateScarPP_T');
        ShowEffect('Scar', false);
    }
    //return;    
}

simulated function EnableLightBlood(float fAlphaVal)
{
    local LinearColor Offset;
    local MaterialEffect MEffect;
    local float D;

    return;
    // End:0x4D
    if((IsTimerActive('UpdateLightBloodPP_T') || IsTimerActive('FadeInLightBloodPP_T')) || IsTimerActive('FadeOutLightBloodPP_T'))
    {
        return;
    }
    MEffect = InitEffect(LBMaterialInstance, 'LightBlood');
    // End:0x1EB
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
        SetTimer(0.0600000, true, 'UpdateLightBloodPP_T');
    }
    //return;    
}

function UpdateLightBloodPP_T()
{
    local float Opacity;

    LBMaterialInstance.GetScalarParameterValue('Opacity', Opacity);
    Opacity -= LightBloodDelta;
    LBMaterialInstance.SetScalarParameterValue('Opacity', Opacity);
    // End:0xAF
    if(Opacity <= float(0))
    {
        ClearTimer('UpdateLightBloodPP_T');
        ShowEffect('LightBlood', false);
    }
    //return;    
}

simulated function EnableLightBloodPulse(float fMinAlpha, float fMaxAlpha, float fInTime, float fMidTime, float fOutTime, optional float MaxTime = 10.0000000)
{
    local LinearColor Offset;
    local MaterialEffect MEffect;

    MEffect = InitEffect(LBMaterialInstance, 'LightBlood');
    // End:0x293
    if(MEffect != none)
    {
        // End:0x248
        if((!IsTimerActive('FadeInLightBloodPP_T') && !IsTimerActive('FadeOutLightBloodPP_T')) && !IsTimerActive('StartFadeOutLightBloodPP_T'))
        {
            Offset.R = 0.0000000;
            Offset.G = 0.0000000;
            LBPulseMinAlpha = fMinAlpha;
            LBPulseMaxAlpha = fMaxAlpha;
            LBPulseInTime = fInTime;
            LBPulseOutTime = fOutTime;
            LBPulseMidTime = fMidTime;
            LBPulseCurrTime = WorldInfo.TimeSeconds;
            LBMaterialInstance.SetScalarParameterValue('Angle', float(Rand(2)) * 3.1415930);
            LBMaterialInstance.SetVectorParameterValue('Offset', Offset);
            LBMaterialInstance.SetScalarParameterValue('Opacity', LBPulseMinAlpha);
            MEffect.bShowInGame = true;
            SetTimer(0.0600000, true, 'FadeInLightBloodPP_T');
            SetTimer(LBPulseInTime + LBPulseMidTime, false, 'StartFadeOutLightBloodPP_T');            
        }
        else
        {
            // End:0x262
            if(IsTimerActive('FadeInLightBloodPP_T'))
            {                
            }
            else
            {
                // End:0x27C
                if(IsTimerActive('StartFadeOutLightBloodPP_T'))
                {                    
                }
                else
                {
                    // End:0x293
                    if(IsTimerActive('FadeOutLightBloodPP_T'))
                    {
                    }
                }
            }
        }
    }
    //return;    
}

function StartFadeOutLightBloodPP_T()
{
    ClearTimer('FadeInLightBloodPP_T');
    LBPulseCurrTime = WorldInfo.TimeSeconds;
    SetTimer(0.0600000, true, 'FadeOutLightBloodPP_T');
    //return;    
}

function FadeInLightBloodPP_T()
{
    local float Opacity, itp;

    // End:0x92
    if((WorldInfo.TimeSeconds - LBPulseCurrTime) >= LBPulseInTime)
    {
        Opacity = LBPulseMaxAlpha;
        LBMaterialInstance.SetScalarParameterValue('Opacity', Opacity);
        ClearTimer('FadeInLightBloodPP_T');        
    }
    else
    {
        itp = FClamp((WorldInfo.TimeSeconds - LBPulseCurrTime) / LBPulseInTime, 0.0000000, 1.0000000);
        Opacity = Lerp(LBPulseMinAlpha, LBPulseMaxAlpha, itp);
        LBMaterialInstance.SetScalarParameterValue('Opacity', Opacity);
    }
    LBMaterialInstance.GetScalarParameterValue('Opacity', Opacity);
    //return;    
}

function FadeOutLightBloodPP_T()
{
    local float Opacity, itp;

    // End:0xA6
    if((WorldInfo.TimeSeconds - LBPulseCurrTime) >= LBPulseOutTime)
    {
        Opacity = LBPulseMinAlpha;
        LBMaterialInstance.SetScalarParameterValue('Opacity', Opacity);
        ClearTimer('FadeOutLightBloodPP_T');
        ShowEffect('LightBlood', false);        
    }
    else
    {
        itp = FClamp((WorldInfo.TimeSeconds - LBPulseCurrTime) / LBPulseOutTime, 0.0000000, 1.0000000);
        Opacity = Lerp(LBPulseMaxAlpha, LBPulseMinAlpha, itp);
        LBMaterialInstance.SetScalarParameterValue('Opacity', Opacity);
    }
    LBMaterialInstance.GetScalarParameterValue('Opacity', Opacity);
    //return;    
}

function TurnOffLightBlood()
{
    LBPulseMinAlpha = 0.0000000;
    LBPulseMaxAlpha = 0.0000000;
    LBPulseInTime = 0.0000000;
    LBPulseOutTime = 0.0000000;
    LBPulseMidTime = 0.0000000;
    ClearTimer('FadeInLightBloodPP_T');
    ClearTimer('FadeOutLightBloodPP_T');
    ClearTimer('StartFadeOutLightBloodPP_T');
    ShowEffect('LightBlood', false);
    LBMaterialInstance = none;
    //return;    
}

function bool PulseEffectsActive()
{
    return IsTimerActive('FadeInLightBloodPP_T') || IsTimerActive('FadeOutLightBloodPP_T');
    //return ReturnValue;    
}

simulated function EnableMediumBlood(float fAlphaVal, optional int iTextureIndex = 0)
{
    local LinearColor Offset;
    local MaterialEffect MEffect;
    local float D;

    // End:0x1E
    if(IsTimerActive('UpdateMediumBloodPP_T'))
    {
        return;
    }
    MEffect = InitEffect(MBMaterialInstance, 'MediumBlood');
    // End:0x217
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
        SetTimer(0.0600000, true, 'UpdateMediumBloodPP_T');
    }
    //return;    
}

function UpdateMediumBloodPP_T()
{
    local float Opacity;

    MBMaterialInstance.GetScalarParameterValue('Opacity', Opacity);
    Opacity -= MediumBloodDelta;
    MBMaterialInstance.SetScalarParameterValue('Opacity', Opacity);
    // End:0xAF
    if(Opacity <= float(0))
    {
        ClearTimer('UpdateMediumBloodPP_T');
        ShowEffect('MediumBlood', false);
    }
    //return;    
}

simulated function EnableBars(float fDistortScale, float fSpeed)
{
    local LinearColor Offset;
    local MaterialEffect MEffect;
    local float D, oldA, oldD;

    // End:0x19
    if(IsTimerActive('UpdateBarsPP_T'))
    {
        return;
    }
    MEffect = InitEffect(ABMaterialInstance, 'Bars');
    // End:0x283
    if(MEffect != none)
    {
        Offset.R = 0.0000000;
        Offset.G = fSpeed;
        ABMaterialInstance.GetScalarParameterValue('distort', oldD);
        ABMaterialInstance.GetScalarParameterValue('Opacity', oldA);
        D = FClamp((0.5000000 * oldA) + (fDistortScale * float(10)), 0.0000000, MaxBarsAlpha);
        BarsDelta = D / (BarsTime + ((FRand() * BarsTime) * 0.2500000));
        ABMaterialInstance.SetScalarParameterValue('distort', FClamp((0.5000000 * oldD) + (fDistortScale * float(2)), 0.0000000, MaxBarsDistort));
        ABMaterialInstance.SetScalarParameterValue('Opacity', D);
        ABMaterialInstance.SetScalarParameterValue('Angle', 0.0000000);
        ABMaterialInstance.SetVectorParameterValue('Offset', Offset);
        MEffect.bShowInGame = true;
        SetTimer(0.0600000, true, 'UpdateBarsPP_T');
    }
    //return;    
}

function UpdateBarsPP_T()
{
    local float Opacity, distort;

    ABMaterialInstance.GetScalarParameterValue('Opacity', Opacity);
    Opacity -= BarsDelta;
    ABMaterialInstance.SetScalarParameterValue('Opacity', Opacity);
    ABMaterialInstance.GetScalarParameterValue('distort', distort);
    distort -= (BarsDelta * float(2));
    ABMaterialInstance.SetScalarParameterValue('distort', distort);
    // End:0x12B
    if(Opacity <= float(0))
    {
        ClearTimer('UpdateBarsPP_T');
        ShowEffect('Bars', false);
    }
    //return;    
}

simulated function EnableBlur(float StartRadius, float Duration)
{
    local EvilPlayerController PC;

    // End:0x19
    if(IsTimerActive('UpdateBlur_T'))
    {
        return;
    }
    BEffect = none;
    PC = EvilPlayerController(Owner);
    // End:0x154
    if((PC != none) && PC.Player != none)
    {
        BEffect = BlurEffect(LocalPlayer.PlayerPostProcess.FindPostProcessEffect('Blur'));
        // End:0x154
        if(BEffect != none)
        {
            BEffect.bShowInGame = true;
            BEffect.BlurKernelSize = 1;
            BlurRadius = int(StartRadius);
            SetTimer(0.2000000, true, 'UpdateBlur_T');
            SetTimer(Duration, false, 'StopBlur_T');
        }
    }
    //return;    
}

function UpdateBlur_T()
{
    // End:0x6C
    if(BEffect.BlurKernelSize < BlurRadius)
    {
        BEffect.BlurKernelSize = BEffect.BlurKernelSize + 1;
    }
    //return;    
}

function StopBlur_T()
{
    ClearTimer('UpdateBlur_T');
    //return;    
}

simulated function EnableFade(LinearColor fadeCol, float FadeTime, optional bool bFadeOutBlack = false, optional float fadeMaxA = 1.0000000, optional float fadeMinA = 0.0000000)
{
    local MaterialEffect MEffect;

    // End:0x30
    if(IsTimerActive('UpdateFade_T'))
    {
        return;
    }
    // End:0x6F
    if(IsTimerActive('UpdateUnFade_T'))
    {
        ClearTimer('UpdateUnFade_T');
        ClearTimer('StopUnFade_T');
    }
    MEffect = InitEffect(FMaterialInstance, 'FadeMask');
    // End:0x204
    if(MEffect != none)
    {
        FadeMaxAlpha = fadeMaxA;
        FadeMinAlpha = fadeMinA;
        FMaterialInstance.SetVectorParameterValue('Color', fadeCol);
        // End:0x168
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
        // End:0x1ED
        if(FadeTime > float(0))
        {
            SetTimer(0.0300000, true, 'UpdateFade_T');
        }
        SetTimer(FadeTime, false, 'StopFade_T');
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
    SetTimer(0.0300000, true, 'UpdateFadeOutBlack_T');
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
    ClearTimer('UpdateFade_T');
    //return;    
}

simulated function Unfade(float FadeTime)
{
    local MaterialEffect MEffect;
    local float oldA;

    // End:0x19
    if(IsTimerActive('UpdateUnFade_T'))
    {
        return;
    }
    // End:0x58
    if(IsTimerActive('UpdateFade_T'))
    {
        ClearTimer('UpdateFade_T');
        ClearTimer('StopFade_T');
    }
    MEffect = InitEffect(FMaterialInstance, 'FadeMask');
    // End:0x12D
    if(MEffect != none)
    {
        FMaterialInstance.GetScalarParameterValue('Alpha', oldA);
        FadeDelta = oldA / (FadeTime * float(33));
        MEffect.bShowInGame = true;
        SetTimer(0.0300000, true, 'UpdateUnFade_T');
        SetTimer(FadeTime, false, 'StopUnFade_T');
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
    Deactivate('FadePP');
    ClearTimer('UpdateUnFade_T');
    //return;    
}

simulated function EnableImpulse(optional float Duration = 1.0000000)
{
    // End:0x3A
    if((ShowEffect('Shake2', true)) != none)
    {
        SetTimer(Duration, false, 'FinishImpulse_T');
    }
    //return;    
}

function FinishImpulse_T()
{
    ShowEffect('Shake2', false);
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

    ScarMaterialInstance = none;
    LBMaterialInstance = none;
    MBMaterialInstance = none;
    ABMaterialInstance = none;
    FMaterialInstance = none;
    HGMaterialInstance = none;
    GBMaterialInstance = none;
    IMaterialInstance = none;
    BBMaterialInstance = none;
    CAMaterialInstance = none;
    BWMaterialInstance = none;
    CSMaterialInstance = none;
    PentMaterialInstance = none;
    ClearAllTimers();
    I = 0;
    J0xA5:

    // End:0x175 [Loop If]
    if(I < LocalPlayer.PlayerPostProcess.Effects.Length)
    {
        Meff = LocalPlayer.PlayerPostProcess.Effects[I];
        // End:0x167
        if(MaterialEffect(Meff) != none)
        {
            Meff.bShowInGame = false;
        }
        ++I;
        // [Loop Continue]
        goto J0xA5;
    }
    //return;    
}

function StoreDOFParams()
{
    LevelDofEnabled = WorldInfo.DefaultPostProcessSettings.bEnableDOF;
    LevelDofFocusType = WorldInfo.DefaultPostProcessSettings.DOF_FocusType;
    LevelDofBlurKernelSize = WorldInfo.DefaultPostProcessSettings.DOF_BlurKernelSize;
    LevelDofFalloffExponent = WorldInfo.DefaultPostProcessSettings.DOF_FalloffExponent;
    LevelDofMinBlurAmount = ((LevelDofEnabled) ? WorldInfo.DefaultPostProcessSettings.DOF_MinBlurAmount : 0.0000000);
    LevelDofMaxFarBlurAmount = ((LevelDofEnabled) ? WorldInfo.DefaultPostProcessSettings.DOF_MaxFarBlurAmount : 0.0000000);
    LevelDofMaxNearBlurAmount = ((LevelDofEnabled) ? WorldInfo.DefaultPostProcessSettings.DOF_MaxNearBlurAmount : 0.0000000);
    LevelDofFocusInnerRadius = WorldInfo.DefaultPostProcessSettings.DOF_FocusInnerRadius;
    LevelDofFocusDistance = WorldInfo.DefaultPostProcessSettings.DOF_FocusDistance;
    LevelDofFocusPosition = WorldInfo.DefaultPostProcessSettings.DOF_FocusPosition;
    //return;    
}

function RestoreDOFParams()
{
    WorldInfo.DefaultPostProcessSettings.bEnableDOF = LevelDofEnabled;
    WorldInfo.DefaultPostProcessSettings.DOF_FocusType = LevelDofFocusType;
    WorldInfo.DefaultPostProcessSettings.DOF_BlurKernelSize = LevelDofBlurKernelSize;
    WorldInfo.DefaultPostProcessSettings.DOF_FalloffExponent = LevelDofFalloffExponent;
    WorldInfo.DefaultPostProcessSettings.DOF_MinBlurAmount = LevelDofMinBlurAmount;
    WorldInfo.DefaultPostProcessSettings.DOF_MaxFarBlurAmount = LevelDofMaxFarBlurAmount;
    WorldInfo.DefaultPostProcessSettings.DOF_MaxNearBlurAmount = LevelDofMaxNearBlurAmount;
    WorldInfo.DefaultPostProcessSettings.DOF_FocusInnerRadius = LevelDofFocusInnerRadius;
    WorldInfo.DefaultPostProcessSettings.DOF_FocusDistance = LevelDofFocusDistance;
    WorldInfo.DefaultPostProcessSettings.DOF_FocusPosition = LevelDofFocusPosition;
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    //return;    
}

defaultproperties
{
    LightBloodScale=50.0000000
    MediumBloodScale=25.5000000
    MaxLightBlood=15.0000000
    MaxBarsDistort=2.2500000
    MaxBarsAlpha=1.2500000
    MaxMediumBlood=20.0000000
    LightBloodTime=40.0000000
    MediumBloodTime=25.0000000
    BarsTime=12.0000000
    MediumBloodTextures[0]=Texture2D'PP_Textures.strzalka_krew'
    MediumBloodTextures[1]=Texture2D'PP_Textures.strzalka_krew1'
    UtilParam=(BloomScale=0.0000000,BloomThreshold=1.0000000,BloomTint=(R=255,G=255,B=255,A=0),DofEnabled=false,DofFocusType=EFocusType.FOCUS_Distance,DofBlurKernelSize=8.0000000,DofFalloffExponent=4.0000000,DofMinBlurAmount=1.0000000,DofMaxFarBlurAmount=1.0000000,DofMaxNearBlurAmount=0.0000000,DofFocusInnerRadius=300.0000000,DofFocusDistance=550.0000000,DofFocusPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000),SceneDesaturation=0.0000000,Scene_Colorize=(X=1.0000000,Y=1.0000000,Z=1.0000000))
    TempPPS=(bOverride_EnableBloom=true,bOverride_EnableDOF=true,bOverride_EnableMotionBlur=true,bOverride_EnableSceneEffect=true,bOverride_AllowAmbientOcclusion=true,bOverride_OverrideRimShaderColor=true,bOverride_Bloom_Scale=true,bOverride_Bloom_Threshold=true,bOverride_Bloom_Tint=true,bOverride_Bloom_ScreenBlendThreshold=true,bOverride_Bloom_InterpolationDuration=true,bOverride_DOF_FalloffExponent=true,bOverride_DOF_BlurKernelSize=true,bOverride_DOF_BlurBloomKernelSize=true,bOverride_DOF_MaxNearBlurAmount=true,bOverride_DOF_MinBlurAmount=false,bOverride_DOF_MaxFarBlurAmount=true,bOverride_DOF_FocusType=true,bOverride_DOF_FocusInnerRadius=true,bOverride_DOF_FocusDistance=true,bOverride_DOF_FocusPosition=true,bOverride_DOF_InterpolationDuration=true,bOverride_DOF_BokehTexture=false,bOverride_MotionBlur_MaxVelocity=false,bOverride_MotionBlur_Amount=false,bOverride_MotionBlur_FullMotionBlur=false,bOverride_MotionBlur_CameraRotationThreshold=false,bOverride_MotionBlur_CameraTranslationThreshold=false,bOverride_MotionBlur_InterpolationDuration=false,bOverride_Scene_Desaturation=true,bOverride_Scene_Colorize=false,bOverride_Scene_TonemapperScale=false,bOverride_Scene_ImageGrainScale=false,bOverride_Scene_HighLights=true,bOverride_Scene_MidTones=true,bOverride_Scene_Shadows=true,bOverride_Scene_InterpolationDuration=true,bOverride_Scene_ColorGradingLUT=false,bOverride_RimShader_Color=true,bOverride_RimShader_InterpolationDuration=true,bOverride_MobileColorGrading=false,bEnableBloom=true,bEnableDOF=false,bEnableMotionBlur=true,bEnableSceneEffect=true,bAllowAmbientOcclusion=true,bOverrideRimShaderColor=false,Bloom_Scale=1.0000000,Bloom_Threshold=1.0000000,Bloom_Tint=(R=255,G=255,B=255,A=0),Bloom_ScreenBlendThreshold=10.0000000,Bloom_InterpolationDuration=1.0000000,DOF_BlurBloomKernelSize=16.0000000,DOF_FalloffExponent=4.0000000,DOF_BlurKernelSize=16.0000000,DOF_MaxNearBlurAmount=1.0000000,DOF_MinBlurAmount=0.0000000,DOF_MaxFarBlurAmount=1.0000000,DOF_FocusType=EFocusType.FOCUS_Distance,DOF_FocusInnerRadius=2000.0000000,DOF_FocusDistance=0.0000000,DOF_FocusPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000),DOF_InterpolationDuration=1.0000000,DOF_BokehTexture=none,MotionBlur_MaxVelocity=1.0000000,MotionBlur_Amount=0.5000000,MotionBlur_FullMotionBlur=true,MotionBlur_CameraRotationThreshold=45.0000000,MotionBlur_CameraTranslationThreshold=10000.0000000,MotionBlur_InterpolationDuration=1.0000000,Scene_Desaturation=0.0000000,Scene_Colorize=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_TonemapperScale=1.0000000,Scene_ImageGrainScale=0.0000000,Scene_HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000),Scene_InterpolationDuration=1.0000000,RimShader_Color=(R=0.4704400,G=0.5859730,B=0.8277260,A=1.0000000),RimShader_InterpolationDuration=1.0000000,ColorGrading_LookupTable=none,ColorGradingLUT=(LUTTextures=none,LUTWeights=none),MobileColorGrading=(TransitionTime=1.0000000,Blend=0.0000000,Desaturation=0.0000000,HighLights=(R=0.7000000,G=0.7000000,B=0.7000000,A=1.0000000),MidTones=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000),Shadows=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000)),MobilePostProcess=(bOverride_Mobile_BlurAmount=false,bOverride_Mobile_TransitionTime=false,bOverride_Mobile_Bloom_Scale=false,bOverride_Mobile_Bloom_Threshold=false,bOverride_Mobile_Bloom_Tint=false,bOverride_Mobile_DOF_Distance=false,bOverride_Mobile_DOF_MinRange=false,bOverride_Mobile_DOF_MaxRange=false,bOverride_Mobile_DOF_NearBlurFactor=false,bOverride_Mobile_DOF_FarBlurFactor=false,Mobile_BlurAmount=16.0000000,Mobile_TransitionTime=1.0000000,Mobile_Bloom_Scale=6.0000000,Mobile_Bloom_Threshold=0.5000000,Mobile_Bloom_Tint=(R=1.0000000,G=1.0000000,B=1.0000000,A=1.0000000),Mobile_DOF_Distance=1500.0000000,Mobile_DOF_MinRange=600.0000000,Mobile_DOF_MaxRange=1200.0000000,Mobile_DOF_NearBlurFactor=1.0000000,Mobile_DOF_FarBlurFactor=1.0000000))
    FadeParams=(BloomScale=0.0000000,BloomThreshold=1.0000000,BloomTint=(R=255,G=255,B=255,A=0),DofEnabled=false,DofFocusType=EFocusType.FOCUS_Distance,DofBlurKernelSize=8.0000000,DofFalloffExponent=4.0000000,DofMinBlurAmount=1.0000000,DofMaxFarBlurAmount=1.0000000,DofMaxNearBlurAmount=0.0000000,DofFocusInnerRadius=300.0000000,DofFocusDistance=550.0000000,DofFocusPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000),SceneDesaturation=0.0000000,Scene_Colorize=(X=1.0000000,Y=1.0000000,Z=1.0000000))
    CollisionType=ECollisionType.COLLIDE_CustomDefault
}