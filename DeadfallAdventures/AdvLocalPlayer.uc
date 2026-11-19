class AdvLocalPlayer extends EvilLocalPlayer within Engine
    transient
    native(Player)
    config(Game);

var bool bAchievementsMasksResetComplete;
var bool bCanShowStorageDeviceWarning;
var bool bPrimaryDeviceEjectedAtMenu;
var bool bPrimaryDeviceEjected;
var bool bWantsToSkipSaves;
var bool bHasSeenStartScreen;
var transient bool bPartyTypeUpdated;
var bool bIsFirstFrontEndLoad;
var bool bDisplayCredits;
var bool bWasPlayingWithParty;
var bool bAutoDisplayPostGameStats;
var transient bool bPartyTypeIsSystemLink;
var transient bool bPartyTypeIsLocal;
var transient bool bQuitRankedMatch;
var bool bIsInSessionStartupProcess;
var bool bIsReturningFromMP;
var bool bIsReturningFromSurvival;
var transient bool bNearDeathEnabled;
var bool bRestoreUsingGamepad;
var config bool bForceNoGamepadUI;
var transient float LastNearDeathIntensity;
var() protected transient PostProcessSettings NearDeathPostProcessSettings;
//var delegate<OnClosedCallback> __OnClosedCallback__Delegate;
//var delegate<OnDestroySessionComplete> __OnDestroySessionComplete__Delegate;

delegate OnClosedCallback(bool bIsRankedQuitter)
{
    //return;    
}

function AdvTypes.EPKPartyType GetCurrentPartyType()
{
    local OnlineSubsystem OnlineSub;
    local OnlineGameSettings PartySettings;
    local int PartyType;

    PartyType = 1;
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0xFE
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
    {
        PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
        // End:0xFE
        if(PartySettings != none)
        {
            PartySettings.GetStringSettingValue(88, PartyType);            
        }
    }
    return byte(PartyType);
    //return ReturnValue;    
}

delegate OnDestroySessionComplete(name SessionName, bool bWasSuccessful)
{
    //return;    
}

function DeleteSession(name SessionName, delegate<OnDestroySessionComplete> DestroyCompleteDelegate)
{
    local OnlineSubsystem OnlineSub;
    local OnlineGameSettings GameSettings;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x144
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        GameSettings = OnlineSub.GameInterface.GetGameSettings(SessionName);
        // End:0x144
        if(GameSettings != none)
        {
            OnlineSub.GameInterface.AddDestroyOnlineGameCompleteDelegate(DestroyCompleteDelegate);
            OnlineSub.GameInterface.DestroyOnlineGame(SessionName);
            return;
        }
    }
    OnDestroySessionComplete(SessionName, true);
    //return;    
}

simulated function OnIllegalPrimaryDeviceRemoveReturnToIS(optional bool ForceReturnToIS)
{
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;
    local AdvPlayerController PC;

    bHasSeenStartScreen = false;
    bIsFirstFrontEndLoad = true;
    PC = AdvPlayerController(Actor);
    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    UIManager.CloseAllUIMessageBoxes(self, 'StorageDeviceRemovalWithLoggedProfile');
    bPrimaryDeviceEjected = false;
    bPrimaryDeviceEjectedAtMenu = false;
    // End:0xD5
    if(ForceReturnToIS)
    {
        PC.ReturnToMainMenu(true);
    }
    ButtonAliases.AddItem('GenericAccept');    
    UIManager.ShowUIMessage('StorageError', "<Strings:ADVGame.MessageBoxErrorStrings.StorageDeviceUnavailableMenu_Title>", "<Strings:ADVGame.MessageBoxErrorStrings.NoPrimaryDeviceReturnToTitle_Message>", ButtonAliases, ((ForceReturnToIS) ?  : ), self,,,, false, false);
    //return;    
}

function InvalidatePersistentCacheAndReloadDataStores()
{
    //return;    
}

function OnIllegalPrimaryDeviceRemove()
{
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;
    local ADVMenuPC PC;

    bHasSeenStartScreen = false;
    bIsFirstFrontEndLoad = true;
    PC = ADVMenuPC(Actor);
    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    UIManager.CloseAllUIMessageBoxes(self, 'StorageDeviceRemovalWithLoggedProfile');
    InvalidatePersistentCacheAndReloadDataStores();
    // End:0x105
    if(bPrimaryDeviceEjectedAtMenu && int(PC.WorldInfo.NetMode) != int(NM_Client))
    {
        PC.RestartFrontEnd();
    }
    bPrimaryDeviceEjected = false;
    bPrimaryDeviceEjectedAtMenu = false;
    ButtonAliases.AddItem('GenericAccept');    
    UIManager.ShowUIMessage('StorageError', "<Strings:ADVGame.MessageBoxErrorStrings.StorageDeviceUnavailableMenu_Title>", "<Strings:ADVGame.MessageBoxErrorStrings.NoPrimaryDeviceReturnToTitle_Message>", ButtonAliases, ((int(PC.WorldInfo.NetMode) == int(NM_Client)) ?  : ), self,,,, false, false);
    //return;    
}

function bool OnStorageDeviceChange_CloseAllMsgBoxes(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local AdvUIManager UIManager;

    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    UIManager.CloseAllUIMessageBoxes(self, 'StorageDeviceRemovalWithLoggedProfile');
    return true;
    //return ReturnValue;    
}

function bool OnStorageDeviceChange_CloseAllMsgBoxesAndReturnToIS(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local AdvPlayerController PC;
    local AdvUIManager UIManager;

    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    UIManager.CloseAllUIMessageBoxes(self, 'StorageDeviceRemovalWithLoggedProfile');
    PC = AdvPlayerController(Actor);
    PC.ReturnToMainMenu(true);
    return true;
    //return ReturnValue;    
}

event string GetNickname()
{
    local string PlayerName;

    PlayerName = super(LocalPlayer).GetNickname();
    // End:0x5C
    if(PlayerName == "")
    {
        PlayerName = Class'EvilGame.EvilGame'.default.DefaultPlayerName @ string(ControllerId + 1);
    }
    return PlayerName;
    //return ReturnValue;    
}

function SetupGameSession()
{
    local EvilGame Game;
    local OnlineGameSettings GameSettings;

    Game = EvilGame(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
    // End:0x58
    if(Game == none)
    {
        return;
    }
    // End:0x8F
    if(EqualEqual_InterfaceInterface(Game.GameInterface, OnlineGameInterface(none)))
    {
        return;
    }
    bIsInSessionStartupProcess = true;
    GameSettings = Game.GameInterface.GetGameSettings('Party');
    // End:0x179
    if(GameSettings != none)
    {
        Game.GameInterface.AddDestroyOnlineGameCompleteDelegate(OnDestroyPartyGameComplete);
        Game.GameInterface.DestroyOnlineGame('Party');        
    }
    else
    {
        OnDestroyPartyGameComplete('Party', false);
    }
    //return;    
}

function OnDestroyPartyGameComplete(name SessionName, bool bWasSuccessful)
{
    local EvilGame Game;

    Game = EvilGame(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
    Game.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyPartyGameComplete);
    Game.GameInterface.AddCreateOnlineGameCompleteDelegate(OnSingleGameCreated);
    OnSingleGameCreated('Game', false);
    return;
    //return;    
}

function OnSingleGameCreated(name SessionName, bool bWasSuccessful)
{
    local AdvGameSP SPGame;

    SPGame = AdvGameSP(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
    SPGame.GameInterface.ClearCreateOnlineGameCompleteDelegate(OnSingleGameCreated);
    // End:0xD8
    if(bWasSuccessful)
    {
        SPGame.GameInterface.StartOnlineGame('Game');
    }
    SPGame.UpdateRichPresence();
    bIsInSessionStartupProcess = false;
    SPGame.SessionStartupFinished(bWasSuccessful);
    //return;    
}

simulated function SetNearDeathOverride(bool bNewEnabled, optional float Intensity, optional float FadeTime = 0.1600000)
{
    // End:0x123
    if(bNewEnabled)
    {
        NearDeathPostProcessSettings.Scene_InterpolationDuration = 0.0000000;
        NearDeathPostProcessSettings.Scene_Desaturation = LastNearDeathIntensity;
        AddPostProcessSettingsOverride('NearDeathClamp', NearDeathPostProcessSettings, 0.0000000, byte(int(127) - int(1)), true);
        NearDeathPostProcessSettings.Scene_InterpolationDuration = FadeTime;
        NearDeathPostProcessSettings.Scene_Desaturation = Intensity;
        AddPostProcessSettingsOverride('NearDeath', NearDeathPostProcessSettings, FadeTime, 127, true);
        LastNearDeathIntensity = Intensity;
        bNearDeathEnabled = true;        
    }
    else
    {
        // End:0x17F
        if(bNearDeathEnabled)
        {
            RemovePostProcessSettingsOverride('NearDeathClamp', 0.0000000);
            RemovePostProcessSettingsOverride('NearDeath', FadeTime);
            LastNearDeathIntensity = 0.0000000;
            bNearDeathEnabled = false;
        }
    }
    //return;    
}

simulated function SetCanShowStorageDeviceWarning(bool bShow)
{
    bCanShowStorageDeviceWarning = bShow;
    //return;    
}

function ProcessClientAuthEndSessionRequest(Player ServerConnection)
{
    // End:0x37
    if(Actor != none)
    {
        AdvPlayerController(Actor).ExitFromMPGame();
    }
    super(LocalPlayer).ProcessClientAuthEndSessionRequest(ServerConnection);
    //return;    
}

defaultproperties
{
    bCanShowStorageDeviceWarning=true
    bIsFirstFrontEndLoad=true
    NearDeathPostProcessSettings=(bOverride_EnableBloom=false,bOverride_EnableDOF=false,bOverride_EnableMotionBlur=false,bOverride_EnableSceneEffect=true,bOverride_AllowAmbientOcclusion=false,bOverride_OverrideRimShaderColor=false,bOverride_Bloom_Scale=false,bOverride_Bloom_Threshold=false,bOverride_Bloom_Tint=false,bOverride_Bloom_ScreenBlendThreshold=false,bOverride_Bloom_InterpolationDuration=false,bOverride_DOF_FalloffExponent=false,bOverride_DOF_BlurKernelSize=false,bOverride_DOF_BlurBloomKernelSize=false,bOverride_DOF_MaxNearBlurAmount=true,bOverride_DOF_MinBlurAmount=false,bOverride_DOF_MaxFarBlurAmount=true,bOverride_DOF_FocusType=false,bOverride_DOF_FocusInnerRadius=true,bOverride_DOF_FocusDistance=false,bOverride_DOF_FocusPosition=false,bOverride_DOF_InterpolationDuration=true,bOverride_DOF_BokehTexture=false,bOverride_MotionBlur_MaxVelocity=false,bOverride_MotionBlur_Amount=false,bOverride_MotionBlur_FullMotionBlur=false,bOverride_MotionBlur_CameraRotationThreshold=false,bOverride_MotionBlur_CameraTranslationThreshold=false,bOverride_MotionBlur_InterpolationDuration=false,bOverride_Scene_Desaturation=true,bOverride_Scene_Colorize=false,bOverride_Scene_TonemapperScale=false,bOverride_Scene_ImageGrainScale=false,bOverride_Scene_HighLights=false,bOverride_Scene_MidTones=true,bOverride_Scene_Shadows=false,bOverride_Scene_InterpolationDuration=true,bOverride_Scene_ColorGradingLUT=false,bOverride_RimShader_Color=true,bOverride_RimShader_InterpolationDuration=true,bOverride_MobileColorGrading=false,bEnableBloom=true,bEnableDOF=false,bEnableMotionBlur=true,bEnableSceneEffect=true,bAllowAmbientOcclusion=true,bOverrideRimShaderColor=false,Bloom_Scale=1.0000000,Bloom_Threshold=1.0000000,Bloom_Tint=(R=255,G=255,B=255,A=0),Bloom_ScreenBlendThreshold=10.0000000,Bloom_InterpolationDuration=1.0000000,DOF_BlurBloomKernelSize=16.0000000,DOF_FalloffExponent=4.0000000,DOF_BlurKernelSize=16.0000000,DOF_MaxNearBlurAmount=1.0000000,DOF_MinBlurAmount=0.0000000,DOF_MaxFarBlurAmount=1.0000000,DOF_FocusType=EFocusType.FOCUS_Distance,DOF_FocusInnerRadius=2000.0000000,DOF_FocusDistance=0.0000000,DOF_FocusPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000),DOF_InterpolationDuration=1.0000000,DOF_BokehTexture=none,MotionBlur_MaxVelocity=1.0000000,MotionBlur_Amount=0.5000000,MotionBlur_FullMotionBlur=true,MotionBlur_CameraRotationThreshold=45.0000000,MotionBlur_CameraTranslationThreshold=10000.0000000,MotionBlur_InterpolationDuration=1.0000000,Scene_Desaturation=1.0000000,Scene_Colorize=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_TonemapperScale=1.0000000,Scene_ImageGrainScale=0.0000000,Scene_HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000),Scene_InterpolationDuration=0.2500000,RimShader_Color=(R=0.4704400,G=0.5859730,B=0.8277260,A=1.0000000),RimShader_InterpolationDuration=1.0000000,ColorGrading_LookupTable=none,ColorGradingLUT=(LUTTextures=none,LUTWeights=none),MobileColorGrading=(TransitionTime=1.0000000,Blend=0.0000000,Desaturation=0.0000000,HighLights=(R=0.7000000,G=0.7000000,B=0.7000000,A=1.0000000),MidTones=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000),Shadows=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000)),MobilePostProcess=(bOverride_Mobile_BlurAmount=false,bOverride_Mobile_TransitionTime=false,bOverride_Mobile_Bloom_Scale=false,bOverride_Mobile_Bloom_Threshold=false,bOverride_Mobile_Bloom_Tint=false,bOverride_Mobile_DOF_Distance=false,bOverride_Mobile_DOF_MinRange=false,bOverride_Mobile_DOF_MaxRange=false,bOverride_Mobile_DOF_NearBlurFactor=false,bOverride_Mobile_DOF_FarBlurFactor=false,Mobile_BlurAmount=16.0000000,Mobile_TransitionTime=1.0000000,Mobile_Bloom_Scale=6.0000000,Mobile_Bloom_Threshold=0.5000000,Mobile_Bloom_Tint=(R=1.0000000,G=1.0000000,B=1.0000000,A=1.0000000),Mobile_DOF_Distance=1500.0000000,Mobile_DOF_MinRange=600.0000000,Mobile_DOF_MaxRange=1200.0000000,Mobile_DOF_NearBlurFactor=1.0000000,Mobile_DOF_FarBlurFactor=1.0000000))
    bKillFarDOFBlur=true
    PPManagerClass=Class'AdvPostProcessManager'
    HitEffectsClass=Class'AdvPlayerHitEffects'
    MenuPostProcessSettings=(bOverride_EnableBloom=false,bOverride_EnableMotionBlur=false,bOverride_AllowAmbientOcclusion=false,bOverride_OverrideRimShaderColor=false,bOverride_Bloom_Scale=false,bOverride_Bloom_Threshold=false,bOverride_Bloom_Tint=false,bOverride_Bloom_ScreenBlendThreshold=false,bOverride_Bloom_InterpolationDuration=false,bOverride_DOF_FalloffExponent=false,bOverride_DOF_BlurKernelSize=false,bOverride_DOF_BlurBloomKernelSize=false,bOverride_DOF_FocusType=false,bOverride_DOF_FocusDistance=false,bOverride_DOF_FocusPosition=false,bOverride_Scene_Desaturation=false,bOverride_Scene_Shadows=false,bEnableBloom=false,bEnableDOF=true,bEnableMotionBlur=false,DOF_MinBlurAmount=1.0000000,DOF_FocusInnerRadius=0.0000000,DOF_InterpolationDuration=0.0000000,Scene_Desaturation=1.0000000,Scene_HighLights=(X=2.5000000,Y=2.5000000,Z=2.5000000),Scene_Shadows=(X=0.1500000,Y=0.2000000,Z=0.2000000))
    AimPostProcessSettings=(bOverride_EnableDOF=true,bOverride_DOF_FalloffExponent=true,bOverride_DOF_BlurKernelSize=true,bOverride_DOF_BlurBloomKernelSize=true,bOverride_DOF_MaxNearBlurAmount=true,bOverride_DOF_MinBlurAmount=true,bOverride_DOF_MaxFarBlurAmount=true,bOverride_DOF_FocusType=true,bOverride_DOF_FocusInnerRadius=true,bOverride_DOF_FocusDistance=true,bOverride_DOF_FocusPosition=true,bOverride_DOF_InterpolationDuration=true,bEnableDOF=true,DOF_MaxFarBlurAmount=0.0000000)
}