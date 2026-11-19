class EvilLocalPlayer extends LocalPlayer within Engine
    transient
    native(Player)
    config(Engine);

const EVIL_PPOVERRIDE_PRIORITY_LOWEST = 0;
const EVIL_PPOVERRIDE_PRIORITY_DEFAULT = 127;
const EVIL_PPOVERRIDE_PRIORITY_AIMING = 200;
const EVIL_PPOVERRIDE_PRIORITY_MENU = 250;
const EVIL_PPOVERRIDE_PRIORITY_HIGHEST = 255;

var const array<TimerData> Timers;
var float CustomTimeDilation;
var transient bool bDebug;
var() bool bKillFarDOFBlur;
var transient float LastSaveTime;
var class<EvilPostProcessManager> PPManagerClass;
var() protected EvilPostProcessManager PPManager;
var class<EvilPlayerHitEffects> HitEffectsClass;
var() protected EvilPlayerHitEffects PlayerHitEffects;
var() protected transient PostProcessSettings MenuPostProcessSettings;
var protected byte MenuPostprocessSemaphore;
var() protected transient PostProcessSettings AimPostProcessSettings;
var() protected transient PostProcessSettings KillFarDOFPostProcessSettings;

function EvilPostProcessManager GetPPManager()
{
    // End:0x27
    if(PPManager == none)
    {
        PPManager = new (self) PPManagerClass;
    }
    return PPManager;
    //return ReturnValue;    
}

function EvilPlayerHitEffects GetPlayerHitEffects()
{
    // End:0x27
    if(PlayerHitEffects == none)
    {
        PlayerHitEffects = new (self) HitEffectsClass;
    }
    return PlayerHitEffects;
    //return ReturnValue;    
}

// Export UEvilLocalPlayer::execSetTimer(FFrame&, void* const)
native final function SetTimer(float InRate, Object inObj, optional bool inbLoop, optional name inTimerFunc = 'Timer');

// Export UEvilLocalPlayer::execClearTimer(FFrame&, void* const)
native final function ClearTimer(Object inObj, optional name inTimerFunc = 'Timer');

// Export UEvilLocalPlayer::execClearAllTimers(FFrame&, void* const)
native final function ClearAllTimers(Object inObj);

// Export UEvilLocalPlayer::execPauseTimer(FFrame&, void* const)
native final function PauseTimer(bool bPause, Object inObj, optional name inTimerFunc = 'Timer');

// Export UEvilLocalPlayer::execIsTimerActive(FFrame&, void* const)
native final function bool IsTimerActive(Object inObj, optional name inTimerFunc = 'Timer');

// Export UEvilLocalPlayer::execGetTimerCount(FFrame&, void* const)
native final function float GetTimerCount(Object inObj, optional name inTimerFunc = 'Timer');

// Export UEvilLocalPlayer::execGetTimerRate(FFrame&, void* const)
native final function float GetTimerRate(Object inObj, optional name TimerFuncName = 'Timer');

final simulated function float GetRemainingTimeForTimer(Object inObj, optional name TimerFuncName = 'Timer')
{
    local float Count, Rate;

    Rate = GetTimerRate(inObj, TimerFuncName);
    // End:0x81
    if(Rate != -1.0000000)
    {
        Count = GetTimerCount(inObj, TimerFuncName);
        return Rate - Count;
    }
    return -1.0000000;
    //return ReturnValue;    
}

// Export UEvilLocalPlayer::execModifyTimerTimeDilation(FFrame&, void* const)
native final function ModifyTimerTimeDilation(Object inObj, const name TimerName, const float InTimerTimeDilation);

// Export UEvilLocalPlayer::execModifyTimerRate(FFrame&, void* const)
native final function ModifyTimerRate(Object inObj, const name TimerName, const float newRate);

// Export UEvilLocalPlayer::execResetTimerTimeDilation(FFrame&, void* const)
native final function ResetTimerTimeDilation(Object inObj, const name TimerName);

// Export UEvilLocalPlayer::execAddPostProcessSettingsOverride(FFrame&, void* const)
native final simulated function AddPostProcessSettingsOverride(name Id, PostProcessSettings OverrideSettings, optional float BlendInTime, optional byte Priority = 127, optional bool bReplaceIfExists = false);

// Export UEvilLocalPlayer::execRemovePostProcessSettingsOverride(FFrame&, void* const)
native final simulated function RemovePostProcessSettingsOverride(name Id, optional float BlendOutTime);

// Export UEvilLocalPlayer::execIsPostProcessSettingsOverrideActive(FFrame&, void* const)
native final simulated function bool IsPostProcessSettingsOverrideActive(name Id);

simulated function SetMenuOverride(bool bNewEnabled, optional float FadeTime = 0.0000000, optional bool bAllPlayers)
{
    local EvilPlayerController PC;

    // End:0xBD
    if(bAllPlayers)
    {
        // End:0xBA
        foreach Actor.LocalPlayerControllers(Class'EvilPlayerController', PC)
        {
            // End:0xB9
            if(PC.GetELP() != none)
            {
                PC.GetELP().SetMenuOverride(bNewEnabled, FadeTime, false);
            }            
        }        
        return;
    }
    // End:0x1CB
    if(bNewEnabled)
    {
        // End:0xE2
        if(int(++MenuPostprocessSemaphore) > int(1))
        {
            return;
        }
        MenuPostProcessSettings.Bloom_InterpolationDuration = FadeTime;
        MenuPostProcessSettings.DOF_InterpolationDuration = FadeTime;
        MenuPostProcessSettings.MotionBlur_InterpolationDuration = FadeTime;
        MenuPostProcessSettings.Scene_InterpolationDuration = FadeTime;
        MenuPostProcessSettings.RimShader_InterpolationDuration = FadeTime;
        AddPostProcessSettingsOverride('Menu', MenuPostProcessSettings, FadeTime, 250);        
    }
    else
    {
        // End:0x213
        if(int(MenuPostprocessSemaphore) > int(0))
        {
            // End:0x1F7
            if(int(--MenuPostprocessSemaphore) > int(0))
            {
                return;
            }
            RemovePostProcessSettingsOverride('Menu', FadeTime);
        }
    }
    //return;    
}

simulated function SetAimOverride(float FocusDistance, float FocusInnerRadius, float BlendTime)
{
    // End:0x5D
    if(FocusDistance == 0.0000000)
    {
        RemovePostProcessSettingsOverride('Aim', BlendTime);
        // End:0x5A
        if(bKillFarDOFBlur)
        {
            SetTimer(BlendTime, self, false, 'DisableKillFarDOF');
        }        
    }
    else
    {
        // End:0xAC
        if(bKillFarDOFBlur)
        {
            ClearTimer(self, 'DisableKillFarDOF');
            AddPostProcessSettingsOverride('KillFarDOF', KillFarDOFPostProcessSettings, 0.0000000, byte(int(200) - int(1)));
        }
        AimPostProcessSettings.DOF_InterpolationDuration = 0.0000000;
        AimPostProcessSettings.DOF_FocusDistance = FocusDistance;
        AimPostProcessSettings.DOF_FocusInnerRadius = FocusInnerRadius;
        AddPostProcessSettingsOverride('Aim', AimPostProcessSettings, BlendTime, 200);
    }
    //return;    
}

simulated function DisableKillFarDOF()
{
    RemovePostProcessSettingsOverride('KillFarDOF', 0.0000000);
    //return;    
}

defaultproperties
{
    CustomTimeDilation=1.0000000
    PPManagerClass=Class'EvilPostProcessManager'
    HitEffectsClass=Class'EvilPlayerHitEffects'
    MenuPostProcessSettings=(bOverride_EnableBloom=true,bOverride_EnableDOF=true,bOverride_EnableMotionBlur=true,bOverride_EnableSceneEffect=true,bOverride_AllowAmbientOcclusion=true,bOverride_OverrideRimShaderColor=true,bOverride_Bloom_Scale=true,bOverride_Bloom_Threshold=true,bOverride_Bloom_Tint=true,bOverride_Bloom_ScreenBlendThreshold=true,bOverride_Bloom_InterpolationDuration=true,bOverride_DOF_FalloffExponent=true,bOverride_DOF_BlurKernelSize=true,bOverride_DOF_BlurBloomKernelSize=true,bOverride_DOF_MaxNearBlurAmount=true,bOverride_DOF_MinBlurAmount=false,bOverride_DOF_MaxFarBlurAmount=true,bOverride_DOF_FocusType=true,bOverride_DOF_FocusInnerRadius=true,bOverride_DOF_FocusDistance=true,bOverride_DOF_FocusPosition=true,bOverride_DOF_InterpolationDuration=true,bOverride_DOF_BokehTexture=false,bOverride_MotionBlur_MaxVelocity=false,bOverride_MotionBlur_Amount=false,bOverride_MotionBlur_FullMotionBlur=false,bOverride_MotionBlur_CameraRotationThreshold=false,bOverride_MotionBlur_CameraTranslationThreshold=false,bOverride_MotionBlur_InterpolationDuration=false,bOverride_Scene_Desaturation=true,bOverride_Scene_Colorize=false,bOverride_Scene_TonemapperScale=false,bOverride_Scene_ImageGrainScale=false,bOverride_Scene_HighLights=true,bOverride_Scene_MidTones=true,bOverride_Scene_Shadows=true,bOverride_Scene_InterpolationDuration=true,bOverride_Scene_ColorGradingLUT=false,bOverride_RimShader_Color=true,bOverride_RimShader_InterpolationDuration=true,bOverride_MobileColorGrading=false,bEnableBloom=true,bEnableDOF=false,bEnableMotionBlur=true,bEnableSceneEffect=true,bAllowAmbientOcclusion=true,bOverrideRimShaderColor=false,Bloom_Scale=1.0000000,Bloom_Threshold=1.0000000,Bloom_Tint=(R=255,G=255,B=255,A=0),Bloom_ScreenBlendThreshold=10.0000000,Bloom_InterpolationDuration=1.0000000,DOF_BlurBloomKernelSize=16.0000000,DOF_FalloffExponent=4.0000000,DOF_BlurKernelSize=16.0000000,DOF_MaxNearBlurAmount=1.0000000,DOF_MinBlurAmount=0.0000000,DOF_MaxFarBlurAmount=1.0000000,DOF_FocusType=EFocusType.FOCUS_Distance,DOF_FocusInnerRadius=2000.0000000,DOF_FocusDistance=0.0000000,DOF_FocusPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000),DOF_InterpolationDuration=1.0000000,DOF_BokehTexture=none,MotionBlur_MaxVelocity=1.0000000,MotionBlur_Amount=0.5000000,MotionBlur_FullMotionBlur=true,MotionBlur_CameraRotationThreshold=45.0000000,MotionBlur_CameraTranslationThreshold=10000.0000000,MotionBlur_InterpolationDuration=1.0000000,Scene_Desaturation=0.0000000,Scene_Colorize=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_TonemapperScale=1.0000000,Scene_ImageGrainScale=0.0000000,Scene_HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000),Scene_InterpolationDuration=1.0000000,RimShader_Color=(R=0.4704400,G=0.5859730,B=0.8277260,A=1.0000000),RimShader_InterpolationDuration=1.0000000,ColorGrading_LookupTable=none,ColorGradingLUT=(LUTTextures=none,LUTWeights=none),MobileColorGrading=(TransitionTime=1.0000000,Blend=0.0000000,Desaturation=0.0000000,HighLights=(R=0.7000000,G=0.7000000,B=0.7000000,A=1.0000000),MidTones=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000),Shadows=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000)),MobilePostProcess=(bOverride_Mobile_BlurAmount=false,bOverride_Mobile_TransitionTime=false,bOverride_Mobile_Bloom_Scale=false,bOverride_Mobile_Bloom_Threshold=false,bOverride_Mobile_Bloom_Tint=false,bOverride_Mobile_DOF_Distance=false,bOverride_Mobile_DOF_MinRange=false,bOverride_Mobile_DOF_MaxRange=false,bOverride_Mobile_DOF_NearBlurFactor=false,bOverride_Mobile_DOF_FarBlurFactor=false,Mobile_BlurAmount=16.0000000,Mobile_TransitionTime=1.0000000,Mobile_Bloom_Scale=6.0000000,Mobile_Bloom_Threshold=0.5000000,Mobile_Bloom_Tint=(R=1.0000000,G=1.0000000,B=1.0000000,A=1.0000000),Mobile_DOF_Distance=1500.0000000,Mobile_DOF_MinRange=600.0000000,Mobile_DOF_MaxRange=1200.0000000,Mobile_DOF_NearBlurFactor=1.0000000,Mobile_DOF_FarBlurFactor=1.0000000))
    AimPostProcessSettings=(bOverride_EnableBloom=false,bOverride_EnableDOF=false,bOverride_EnableMotionBlur=false,bOverride_EnableSceneEffect=false,bOverride_AllowAmbientOcclusion=false,bOverride_OverrideRimShaderColor=false,bOverride_Bloom_Scale=false,bOverride_Bloom_Threshold=false,bOverride_Bloom_Tint=false,bOverride_Bloom_ScreenBlendThreshold=false,bOverride_Bloom_InterpolationDuration=false,bOverride_DOF_FalloffExponent=false,bOverride_DOF_BlurKernelSize=false,bOverride_DOF_BlurBloomKernelSize=false,bOverride_DOF_MaxNearBlurAmount=false,bOverride_DOF_MinBlurAmount=false,bOverride_DOF_MaxFarBlurAmount=false,bOverride_DOF_FocusType=false,bOverride_DOF_FocusInnerRadius=false,bOverride_DOF_FocusDistance=false,bOverride_DOF_FocusPosition=false,bOverride_DOF_InterpolationDuration=false,bOverride_DOF_BokehTexture=false,bOverride_MotionBlur_MaxVelocity=false,bOverride_MotionBlur_Amount=false,bOverride_MotionBlur_FullMotionBlur=false,bOverride_MotionBlur_CameraRotationThreshold=false,bOverride_MotionBlur_CameraTranslationThreshold=false,bOverride_MotionBlur_InterpolationDuration=false,bOverride_Scene_Desaturation=false,bOverride_Scene_Colorize=false,bOverride_Scene_TonemapperScale=false,bOverride_Scene_ImageGrainScale=false,bOverride_Scene_HighLights=false,bOverride_Scene_MidTones=false,bOverride_Scene_Shadows=false,bOverride_Scene_InterpolationDuration=false,bOverride_Scene_ColorGradingLUT=false,bOverride_RimShader_Color=false,bOverride_RimShader_InterpolationDuration=false,bOverride_MobileColorGrading=false,bEnableBloom=true,bEnableDOF=false,bEnableMotionBlur=true,bEnableSceneEffect=true,bAllowAmbientOcclusion=true,bOverrideRimShaderColor=false,Bloom_Scale=1.0000000,Bloom_Threshold=1.0000000,Bloom_Tint=(R=255,G=255,B=255,A=0),Bloom_ScreenBlendThreshold=10.0000000,Bloom_InterpolationDuration=1.0000000,DOF_BlurBloomKernelSize=16.0000000,DOF_FalloffExponent=4.0000000,DOF_BlurKernelSize=16.0000000,DOF_MaxNearBlurAmount=1.0000000,DOF_MinBlurAmount=0.0000000,DOF_MaxFarBlurAmount=1.0000000,DOF_FocusType=EFocusType.FOCUS_Distance,DOF_FocusInnerRadius=2000.0000000,DOF_FocusDistance=0.0000000,DOF_FocusPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000),DOF_InterpolationDuration=1.0000000,DOF_BokehTexture=none,MotionBlur_MaxVelocity=1.0000000,MotionBlur_Amount=0.5000000,MotionBlur_FullMotionBlur=true,MotionBlur_CameraRotationThreshold=45.0000000,MotionBlur_CameraTranslationThreshold=10000.0000000,MotionBlur_InterpolationDuration=1.0000000,Scene_Desaturation=0.0000000,Scene_Colorize=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_TonemapperScale=1.0000000,Scene_ImageGrainScale=0.0000000,Scene_HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000),Scene_InterpolationDuration=1.0000000,RimShader_Color=(R=0.4704400,G=0.5859730,B=0.8277260,A=1.0000000),RimShader_InterpolationDuration=1.0000000,ColorGrading_LookupTable=none,ColorGradingLUT=(LUTTextures=none,LUTWeights=none),MobileColorGrading=(TransitionTime=1.0000000,Blend=0.0000000,Desaturation=0.0000000,HighLights=(R=0.7000000,G=0.7000000,B=0.7000000,A=1.0000000),MidTones=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000),Shadows=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000)),MobilePostProcess=(bOverride_Mobile_BlurAmount=false,bOverride_Mobile_TransitionTime=false,bOverride_Mobile_Bloom_Scale=false,bOverride_Mobile_Bloom_Threshold=false,bOverride_Mobile_Bloom_Tint=false,bOverride_Mobile_DOF_Distance=false,bOverride_Mobile_DOF_MinRange=false,bOverride_Mobile_DOF_MaxRange=false,bOverride_Mobile_DOF_NearBlurFactor=false,bOverride_Mobile_DOF_FarBlurFactor=false,Mobile_BlurAmount=16.0000000,Mobile_TransitionTime=1.0000000,Mobile_Bloom_Scale=6.0000000,Mobile_Bloom_Threshold=0.5000000,Mobile_Bloom_Tint=(R=1.0000000,G=1.0000000,B=1.0000000,A=1.0000000),Mobile_DOF_Distance=1500.0000000,Mobile_DOF_MinRange=600.0000000,Mobile_DOF_MaxRange=1200.0000000,Mobile_DOF_NearBlurFactor=1.0000000,Mobile_DOF_FarBlurFactor=1.0000000))
    KillFarDOFPostProcessSettings=(bOverride_EnableBloom=false,bOverride_EnableDOF=true,bOverride_EnableMotionBlur=false,bOverride_EnableSceneEffect=false,bOverride_AllowAmbientOcclusion=false,bOverride_OverrideRimShaderColor=false,bOverride_Bloom_Scale=false,bOverride_Bloom_Threshold=false,bOverride_Bloom_Tint=false,bOverride_Bloom_ScreenBlendThreshold=false,bOverride_Bloom_InterpolationDuration=false,bOverride_DOF_FalloffExponent=false,bOverride_DOF_BlurKernelSize=false,bOverride_DOF_BlurBloomKernelSize=false,bOverride_DOF_MaxNearBlurAmount=false,bOverride_DOF_MinBlurAmount=false,bOverride_DOF_MaxFarBlurAmount=true,bOverride_DOF_FocusType=false,bOverride_DOF_FocusInnerRadius=false,bOverride_DOF_FocusDistance=false,bOverride_DOF_FocusPosition=false,bOverride_DOF_InterpolationDuration=true,bOverride_DOF_BokehTexture=false,bOverride_MotionBlur_MaxVelocity=false,bOverride_MotionBlur_Amount=false,bOverride_MotionBlur_FullMotionBlur=false,bOverride_MotionBlur_CameraRotationThreshold=false,bOverride_MotionBlur_CameraTranslationThreshold=false,bOverride_MotionBlur_InterpolationDuration=false,bOverride_Scene_Desaturation=false,bOverride_Scene_Colorize=false,bOverride_Scene_TonemapperScale=false,bOverride_Scene_ImageGrainScale=false,bOverride_Scene_HighLights=false,bOverride_Scene_MidTones=false,bOverride_Scene_Shadows=false,bOverride_Scene_InterpolationDuration=false,bOverride_Scene_ColorGradingLUT=false,bOverride_RimShader_Color=false,bOverride_RimShader_InterpolationDuration=false,bOverride_MobileColorGrading=false,bEnableBloom=true,bEnableDOF=true,bEnableMotionBlur=true,bEnableSceneEffect=true,bAllowAmbientOcclusion=true,bOverrideRimShaderColor=false,Bloom_Scale=1.0000000,Bloom_Threshold=1.0000000,Bloom_Tint=(R=255,G=255,B=255,A=0),Bloom_ScreenBlendThreshold=10.0000000,Bloom_InterpolationDuration=1.0000000,DOF_BlurBloomKernelSize=16.0000000,DOF_FalloffExponent=4.0000000,DOF_BlurKernelSize=16.0000000,DOF_MaxNearBlurAmount=1.0000000,DOF_MinBlurAmount=0.0000000,DOF_MaxFarBlurAmount=0.0000000,DOF_FocusType=EFocusType.FOCUS_Distance,DOF_FocusInnerRadius=2000.0000000,DOF_FocusDistance=0.0000000,DOF_FocusPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000),DOF_InterpolationDuration=0.0000000,DOF_BokehTexture=none,MotionBlur_MaxVelocity=1.0000000,MotionBlur_Amount=0.5000000,MotionBlur_FullMotionBlur=true,MotionBlur_CameraRotationThreshold=45.0000000,MotionBlur_CameraTranslationThreshold=10000.0000000,MotionBlur_InterpolationDuration=1.0000000,Scene_Desaturation=0.0000000,Scene_Colorize=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_TonemapperScale=1.0000000,Scene_ImageGrainScale=0.0000000,Scene_HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000),Scene_InterpolationDuration=1.0000000,RimShader_Color=(R=0.4704400,G=0.5859730,B=0.8277260,A=1.0000000),RimShader_InterpolationDuration=1.0000000,ColorGrading_LookupTable=none,ColorGradingLUT=(LUTTextures=none,LUTWeights=none),MobileColorGrading=(TransitionTime=1.0000000,Blend=0.0000000,Desaturation=0.0000000,HighLights=(R=0.7000000,G=0.7000000,B=0.7000000,A=1.0000000),MidTones=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000),Shadows=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000)),MobilePostProcess=(bOverride_Mobile_BlurAmount=false,bOverride_Mobile_TransitionTime=false,bOverride_Mobile_Bloom_Scale=false,bOverride_Mobile_Bloom_Threshold=false,bOverride_Mobile_Bloom_Tint=false,bOverride_Mobile_DOF_Distance=false,bOverride_Mobile_DOF_MinRange=false,bOverride_Mobile_DOF_MaxRange=false,bOverride_Mobile_DOF_NearBlurFactor=false,bOverride_Mobile_DOF_FarBlurFactor=false,Mobile_BlurAmount=16.0000000,Mobile_TransitionTime=1.0000000,Mobile_Bloom_Scale=6.0000000,Mobile_Bloom_Threshold=0.5000000,Mobile_Bloom_Tint=(R=1.0000000,G=1.0000000,B=1.0000000,A=1.0000000),Mobile_DOF_Distance=1500.0000000,Mobile_DOF_MinRange=600.0000000,Mobile_DOF_MaxRange=1200.0000000,Mobile_DOF_NearBlurFactor=1.0000000,Mobile_DOF_FarBlurFactor=1.0000000))
}