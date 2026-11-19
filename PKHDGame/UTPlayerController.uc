class UTPlayerController extends UDKPlayerController
    native(PC)
    config(Game)
    hidecategories(Navigation);

const GS_USERNAME_MAXLENGTH = 15;
const GS_PASSWORD_MAXLENGTH = 30;
const GS_MESSAGE_MAXLENGTH = 255;
const GS_EMAIL_MAXLENGTH = 50;
const GS_CDKEY_PART_MAXLENGTH = 4;
const CONTEXT_PRESENCE_MENUPRESENCE = 0;
const CONTEXT_GAME_MODE = 0x0000800B;
const CONTEXT_GAME_MODE_DM = 0;
const CONTEXT_GAME_MODE_CTF = 1;
const CONTEXT_GAME_MODE_WAR = 2;
const CONTEXT_GAME_MODE_VCTF = 3;
const CONTEXT_GAME_MODE_TDM = 4;
const CONTEXT_GAME_MODE_DUEL = 5;
const CONTEXT_GAME_MODE_CUSTOM = 6;
const CONTEXT_GAME_MODE_CAMPAIGN = 7;
const CONTEXT_BOTSKILL = 0;
const CONTEXT_MAPNAME = 1;
const CONTEXT_PURESERVER = 6;
const CONTEXT_LOCKEDSERVER = 7;
const CONTEXT_VSBOTS = 8;
const CONTEXT_CAMPAIGN = 9;
const CONTEXT_FORCERESPAWN = 10;
const CONTEXT_ALLOWKEYBOARD = 11;
const CONTEXT_FULLSERVER = 12;
const CONTEXT_EMPTYSERVER = 13;
const CONTEXT_DEDICATEDSERVER = 14;
const CONTEXT_MAPNAME_CUSTOM = 0;
const CONTEXT_BOTSKILL_NOVICE = 0;
const CONTEXT_BOTSKILL_AVERAGE = 1;
const CONTEXT_BOTSKILL_EXPERIENCED = 2;
const CONTEXT_BOTSKILL_SKILLED = 3;
const CONTEXT_BOTSKILL_ADEPT = 4;
const CONTEXT_BOTSKILL_MASTERFUL = 5;
const CONTEXT_BOTSKILL_INHUMAN = 6;
const CONTEXT_BOTSKILL_GODLIKE = 7;
const CONTEXT_GOALSCORE_5 = 0;
const CONTEXT_GOALSCORE_10 = 1;
const CONTEXT_GOALSCORE_15 = 2;
const CONTEXT_GOALSCORE_20 = 3;
const CONTEXT_GOALSCORE_30 = 4;
const CONTEXT_NUMBOTS = 0;
const CONTEXT_NUMBOTS_1 = 1;
const CONTEXT_NUMBOTS_2 = 2;
const CONTEXT_NUMBOTS_3 = 3;
const CONTEXT_NUMBOTS_4 = 4;
const CONTEXT_NUMBOTS_5 = 5;
const CONTEXT_NUMBOTS_6 = 6;
const CONTEXT_NUMBOTS_7 = 7;
const CONTEXT_NUMBOTS_8 = 8;
const CONTEXT_TIMELIMIT_5 = 0;
const CONTEXT_TIMELIMIT_10 = 1;
const CONTEXT_TIMELIMIT_15 = 2;
const CONTEXT_TIMELIMIT_20 = 3;
const CONTEXT_TIMELIMIT_30 = 4;
const CONTEXT_PURESERVER_NO = 0;
const CONTEXT_PURESERVER_YES = 1;
const CONTEXT_PURESERVER_ANY = 2;
const CONTEXT_LOCKEDSERVER_NO = 0;
const CONTEXT_LOCKEDSERVER_YES = 1;
const CONTEXT_CAMPAIGN_NO = 0;
const CONTEXT_CAMPAIGN_YES = 1;
const CONTEXT_FORCERESPAWN_NO = 0;
const CONTEXT_FORCERESPAWN_YES = 1;
const CONTEXT_ALLOWKEYBOARD_NO = 0;
const CONTEXT_ALLOWKEYBOARD_YES = 1;
const CONTEXT_ALLOWKEYBOARD_ANY = 2;
const CONTEXT_FULLSERVER_NO = 0;
const CONTEXT_FULLSERVER_YES = 1;
const CONTEXT_EMPTYSERVER_NO = 0;
const CONTEXT_EMPTYSERVER_YES = 1;
const CONTEXT_DEDICATEDSERVER_NO = 0;
const CONTEXT_DEDICATEDSERVER_YES = 1;
const CONTEXT_VSBOTS_NONE = 0;
const CONTEXT_VSBOTS_1_TO_2 = 1;
const CONTEXT_VSBOTS_1_TO_1 = 2;
const CONTEXT_VSBOTS_3_TO_2 = 3;
const CONTEXT_VSBOTS_2_TO_1 = 4;
const CONTEXT_VSBOTS_3_TO_1 = 5;
const CONTEXT_VSBOTS_4_TO_1 = 6;
const PROPERTY_NUMBOTS = 0x100000F7;
const PROPERTY_GOALSCORE = 0x100000F8;
const PROPERTY_TIMELIMIT = 0x100000F9;
const PROPERTY_LEADERBOARDRATING = 0x20000004;
const PROPERTY_EPICMUTATORS = 0x10000105;
const PROPERTY_CUSTOMMAPNAME = 0x40000001;
const PROPERTY_CUSTOMGAMEMODE = 0x40000002;
const PROPERTY_SERVERDESCRIPTION = 0x40000003;
const PROPERTY_CUSTOMMUTATORS = 0x40000004;
const QUERY_DM = 0;
const QUERY_TDM = 1;
const QUERY_CTF = 2;
const QUERY_VCTF = 3;
const QUERY_WAR = 4;
const QUERY_DUEL = 5;
const QUERY_CAMPAIGN = 6;
const STATS_VIEW_DM_PLAYER_ALLTIME = 1;
const STATS_VIEW_DM_RANKED_ALLTIME = 2;
const STATS_VIEW_DM_WEAPONS_ALLTIME = 3;
const STATS_VIEW_DM_VEHICLES_ALLTIME = 4;
const STATS_VIEW_DM_VEHICLEWEAPONS_ALLTIME = 5;
const STATS_VIEW_DM_VEHICLES_RANKED_ALLTIME = 6;
const STATS_VIEW_DM_VEHICLEWEAPONS_RANKED_ALLTIME = 7;
const STATS_VIEW_DM_WEAPONS_RANKED_ALLTIME = 8;

enum EUTVehicleControls
{
    UTVC_Simple,                    // 0
    UTVC_Normal,                    // 1
    UTVC_Advanced,                  // 2
    UTVC_MAX                        // 3
};

enum EPawnShadowMode
{
    SHADOW_None,                    // 0
    SHADOW_Self,                    // 1
    SHADOW_All,                     // 2
    SHADOW_MAX                      // 3
};

enum EWeaponHand
{
    HAND_Right,                     // 0
    HAND_Left,                      // 1
    HAND_Centered,                  // 2
    HAND_Hidden,                    // 3
    HAND_MAX                        // 4
};

enum EAutoObjectivePreference
{
    AOP_Disabled,                   // 0
    AOP_NoPreference,               // 1
    AOP_Attack,                     // 2
    AOP_Defend,                     // 3
    AOP_OrbRunner,                  // 4
    AOP_SpecialOps,                 // 5
    AOP_MAX                         // 6
};

struct native PostProcessInfo
{
    var float Shadows;
    var float MidTones;
    var float HighLights;
    var float Desaturation;

    structdefaultproperties
    {
        Shadows=0.0000000
        MidTones=0.0000000
        HighLights=0.0000000
        Desaturation=0.0000000
    }
};

var bool bLateComer;
var bool bIsTyping;
var globalconfig bool bAutoTaunt;
var globalconfig bool bUseVehicleRotationOnPossess;
var bool bRotateMinimap;
var bool bCameraOutOfWorld;
var globalconfig bool bFirstPersonWeaponsSelfShadow;
var bool bBehindView;
var bool bForceBehindView;
var bool bFreeCamera;
var globalconfig bool bNoTextToSpeechVoiceMessages;
var globalconfig bool bTextToSpeechTeamMessagesOnly;
var bool bCurrentCamAnimIsDamageShake;
var bool bCurrentCamAnimAffectsFOV;
var globalconfig bool bLandingShake;
var config bool bCenteredWeaponFire;
var transient bool bNonlinearZoomInterpolation;
var transient bool bQuittingToMainMenu;
var transient bool bDebugFreeCam;
var bool bJustFoundVehicle;
var config bool bNoCrosshair;
var config bool bSimpleCrosshair;
var bool bAlreadyReset;
var bool bServerMutedText;
var globalconfig bool bHideObjectivePaths;
var bool bCleanupInProgress;
var bool bCleanupComplete;
var byte IdentifiedTeam;
var globalconfig UTPlayerController.EPawnShadowMode PawnShadowMode;
var globalconfig UTPlayerController.EWeaponHand WeaponHandPreference;
var UTPlayerController.EWeaponHand WeaponHand;
var globalconfig UTPlayerController.EAutoObjectivePreference AutoObjectivePreference;
var UTPlayerController.EUTVehicleControls VehicleControlType;
var Vector DesiredLocation;
var UTAnnouncer Announcer;
var UTMusicManager MusicManager;
var float LastTauntAnimTime;
var float LastKickWarningTime;
var const localized string MsgPlayerNotFound;
var ForceFeedbackWaveform CameraShakeShortWaveForm;
var ForceFeedbackWaveform CameraShakeLongWaveForm;
var array<CameraAnim> DamageCameraAnim;
var float LastCameraTimeStamp;
var class<Camera> MatineeCameraClass;
var Actor CalcViewActor;
var Vector CalcViewActorLocation;
var Rotator CalcViewActorRotation;
var Vector CalcViewLocation;
var Rotator CalcViewRotation;
var float CalcEyeHeight;
var Vector CalcWalkBob;
var float LastWarningTime;
var float FOVLinearZoomRate;
var transient float FOVNonlinearZoomInterpSpeed;
var float ZoomRotationModifier;
var transient Rotator DebugFreeCamRot;
var float LastShowPathTime;
var Actor LastAutoObjective;
var float LastBullseyeTime;
var float LastUseTime;
var float OldMessageTime;
var float LastFriendlyFireTime;
var UTUIDataStore_StringAliasBindingsMap BoundEventsStringDataStore;
var float NextAdminCmdTime;
var globalconfig float OnFootDefaultFOV;
var float LastIncomingMessageTime;
var float LastCombatUpdateTime;
var float LastTeamChangeTime;
var string DisconnectCommand;

exec function Camera(name NewMode)
{
    // End:0x3C
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        ServerCamera(NewMode);
    }
    //return;    
}

reliable server function ServerThrowWeapon()
{
    // End:0x42
    if(Pawn.CanThrowWeapon())
    {
        Pawn.ThrowActiveWeapon();
    }
    //return;    
}

exec function SwitchHud()
{
    local class<HUD> NewHUDClass;

    NewHUDClass = WorldInfo.GRI.GameClass.default.HUDType;
    // End:0x7D
    if(EvilGFxHudWrapper(myHUD) == none)
    {
        NewHUDClass = Class'EvilGFxHudWrapper';
    }
    ClientSetHUD(NewHUDClass);
    //return;    
}

event InitInputSystem()
{
    local LocalPlayer LP;

    LP = LocalPlayer(Player);
    super(PlayerController).InitInputSystem();
    AddOnlineDelegates(true);
    CameraAnimPlayer = new (self) Class'Engine.CameraAnimInst';
    // End:0x7C
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        CharacterProcessingComplete();
    }
    // End:0xD5
    if((int(WorldInfo.NetMode) == int(NM_ListenServer)) && PlayerReplicationInfo != none)
    {
        PlayerReplicationInfo.IsInvalidName();
    }
    // End:0x118
    if(bDedicatedServerSpectator)
    {
        LP.ViewportClient.bDisableWorldRendering = true;
    }
    LP.RemoveAllPostProcessingChains();
    LP.InsertPostProcessingChain(LP.Outer.GetWorldPostProcessChain(), -1, true);
    //return;    
}

function PulseTeamColor()
{
    PulseTimer = default.PulseTimer;
    bPulseTeamColor = true;
    //return;    
}

reliable server function ServerSetCharacterClass(class<EvilFamilyInfoBase> CharClass)
{
    local EvilTeamInfo Team;
    local EvilPlayerReplicationInfo PRI;

    PRI = EvilPlayerReplicationInfo(PlayerReplicationInfo);
    PRI.CharClassInfo = CharClass;
    // End:0x139
    if(((int(WorldInfo.NetMode) == int(NM_Standalone)) || int(WorldInfo.NetMode) == int(NM_ListenServer)) && IsLocalPlayerController())
    {
        Team = EvilTeamInfo(PlayerReplicationInfo.Team);
        // End:0x139
        if(Team != none)
        {
            Team.Faction = PRI.CharClassInfo.default.Faction;
        }
    }
    //return;    
}

simulated function ClearStringAliasBindingMapCache()
{
    BoundEventsStringDataStore.ClearBoundKeyCache();
    //return;    
}

protected simulated function RegisterCustomPlayerDataStores()
{
    local LocalPlayer LP;
    local DataStoreClient DataStoreManager;
    local class<UTUIDataStore_StringAliasBindingsMap> StringAliasBindingsMapDataStoreClass;

    LP = LocalPlayer(Player);
    super(PlayerController).RegisterCustomPlayerDataStores();
    // End:0x187
    if(LP != none)
    {
        DataStoreManager = Class'Engine.UIInteraction'.static.GetDataStoreClient();
        // End:0x187
        if(DataStoreManager != none)
        {
            BoundEventsStringDataStore = UTUIDataStore_StringAliasBindingsMap(DataStoreManager.FindDataStore('StringAliasBindings', LP));
            // End:0x187
            if(BoundEventsStringDataStore == none)
            {
                StringAliasBindingsMapDataStoreClass = class<UTUIDataStore_StringAliasBindingsMap>(DataStoreManager.FindDataStoreClass(Class'UTUIDataStore_StringAliasBindingsMap'));
                // End:0x184
                if(StringAliasBindingsMapDataStoreClass != none)
                {
                    BoundEventsStringDataStore = DataStoreManager.CreateDataStore(StringAliasBindingsMapDataStoreClass);
                    // End:0x184
                    if(BoundEventsStringDataStore != none)
                    {
                        // End:0x181
                        if(!DataStoreManager.RegisterDataStore(BoundEventsStringDataStore, LP))
                        {
                        }                        
                    }
                }                
            }
        }
    }
    //return;    
}

simulated function UnregisterPlayerDataStores()
{
    local LocalPlayer LP;
    local DataStoreClient DataStoreManager;

    LP = LocalPlayer(Player);
    // End:0xB0
    if(LP != none)
    {
        DataStoreManager = Class'Engine.UIInteraction'.static.GetDataStoreClient();
        // End:0xB0
        if(DataStoreManager != none)
        {
            // End:0xAD
            if(BoundEventsStringDataStore != none)
            {
                // End:0x9F
                if(!DataStoreManager.UnregisterDataStore(BoundEventsStringDataStore))
                {
                }
                BoundEventsStringDataStore = none;                
            }            
        }
    }
    super(PlayerController).UnregisterPlayerDataStores();
    //return;    
}

function AddOnlineDelegates(bool bRegisterVoice)
{
    // End:0xFD
    if((bRegisterVoice && int(WorldInfo.NetMode) == int(NM_Standalone)) && NotEqual_InterfaceInterface(VoiceInterface, OnlineVoiceInterface(none)))
    {
        VoiceInterface.RegisterLocalTalker(byte(LocalPlayer(Player).ControllerId));
        VoiceInterface.AddRecognitionCompleteDelegate(byte(LocalPlayer(Player).ControllerId), SpeechRecognitionComplete);
    }
    // End:0x452
    if(OnlineSub != none)
    {
        // End:0x2FD
        if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
        {
            OnlineSub.PlayerInterface.AddReadProfileSettingsCompleteDelegate(byte(LocalPlayer(Player).ControllerId), OnReadProfileSettingsComplete);
            OnlineSub.PlayerInterface.AddFriendInviteReceivedDelegate(byte(LocalPlayer(Player).ControllerId), OnFriendInviteReceived);
            OnlineSub.PlayerInterface.AddReceivedGameInviteDelegate(byte(LocalPlayer(Player).ControllerId), OnGameInviteReceived);
            OnlineSub.PlayerInterface.AddFriendMessageReceivedDelegate(byte(LocalPlayer(Player).ControllerId), OnFriendMessageReceived);
        }
        // End:0x452
        if(NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none)))
        {
            OnlineSub.SystemInterface.AddConnectionStatusChangeDelegate(OnConnectionStatusChange);
            OnlineSub.SystemInterface.AddLinkStatusChangeDelegate(OnLinkStatusChanged);
            // End:0x452
            if(OnlineSub.SystemInterface.IsControllerConnected(LocalPlayer(Player).ControllerId) == false)
            {
                OnControllerChanged(LocalPlayer(Player).ControllerId, false);
            }
        }
    }
    //return;    
}

event ClearOnlineDelegates()
{
    local LocalPlayer LP;

    super(PlayerController).ClearOnlineDelegates();
    LP = LocalPlayer(Player);
    // End:0x45C
    if((OnlineSub != none) && (int(Role) < int(ROLE_Authority)) || LP != none)
    {
        // End:0x39B
        if(LP != none)
        {
            // End:0x1CE
            if(NotEqual_InterfaceInterface(VoiceInterface, OnlineVoiceInterface(none)))
            {
                VoiceInterface.ClearRecognitionCompleteDelegate(byte(LP.ControllerId), SpeechRecognitionComplete);
                // End:0x1CE
                if(EqualEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)) || NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)) && OnlineSub.GameInterface.GetGameSettings('Game') == none)
                {
                    VoiceInterface.UnregisterLocalTalker(byte(LP.ControllerId));
                }
            }
            // End:0x39B
            if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
            {
                OnlineSub.PlayerInterface.ClearReadProfileSettingsCompleteDelegate(byte(LP.ControllerId), OnReadProfileSettingsComplete);
                OnlineSub.PlayerInterface.ClearFriendInviteReceivedDelegate(byte(LP.ControllerId), OnFriendInviteReceived);
                OnlineSub.PlayerInterface.ClearReceivedGameInviteDelegate(byte(LP.ControllerId), OnGameInviteReceived);
                OnlineSub.PlayerInterface.ClearFriendMessageReceivedDelegate(byte(LP.ControllerId), OnFriendMessageReceived);
            }
        }
        // End:0x45C
        if(NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none)))
        {
            OnlineSub.SystemInterface.ClearConnectionStatusChangeDelegate(OnConnectionStatusChange);
            OnlineSub.SystemInterface.ClearLinkStatusChangeDelegate(OnLinkStatusChanged);
        }
    }
    //return;    
}

function OnConnectionStatusChange(OnlineSubsystem.EOnlineServerConnectionStatus ConnectionStatus)
{
    local OnlineGameSettings GameSettings;
    local bool bInvalidConnectionStatus;

    // End:0x8F
    if(int(ConnectionStatus) == int(7))
    {
        SetFrontEndErrorMessage("<Strings:UTGameUI.Errors.DuplicateLogin_Title>", "<Strings:UTGameUI.Errors.DuplicateLogin_Message>");
        bInvalidConnectionStatus = true;        
    }
    else
    {
        // End:0x1E2
        if(int(WorldInfo.NetMode) != int(NM_Standalone))
        {
            GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
            // End:0x1E2
            if(GameSettings != none)
            {
                // End:0x1E2
                if(!GameSettings.bIsLanMatch)
                {
                    switch(ConnectionStatus)
                    {
                        // End:0x14B
                        case 2:
                        // End:0x150
                        case 3:
                        // End:0x155
                        case 4:
                        // End:0x15A
                        case 5:
                        // End:0x15F
                        case 6:
                        // End:0x1DF
                        case 0:
                            SetFrontEndErrorMessage("<Strings:UTGameUI.Errors.ConnectionLost_Title>", "<Strings:UTGameUI.Errors.ConnectionLost_Message>");
                            bInvalidConnectionStatus = true;
                            // End:0x1E2
                            break;
                        // End:0xFFFF
                        default:
                            break;
                    }
                }
                else
                {
                }/* !MISMATCHING REMOVE, tried If got Type:Else Position:0x1E2! */
            }
        }/* !MISMATCHING REMOVE, tried Else got Type:If Position:0x08F! */
        // End:0x1F9
        if(bInvalidConnectionStatus)
        {
            QuitToMainMenu();
        }
        //return;        
    }
}

function OnLinkStatusChanged(bool bConnected)
{
    local string ErrorDisplay;
    local UIDataStore_Registry Registry;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    // End:0x170
    if((!bConnected && WorldInfo != none) && WorldInfo.Game != none)
    {
        // End:0x170
        if(int(WorldInfo.NetMode) != int(NM_Standalone))
        {
            // End:0x170
            if(!Registry.GetData("FrontEndError_Display", ErrorDisplay) || int(ErrorDisplay) == 0)
            {
                SetFrontEndErrorMessage("<Strings:UTGameUI.Errors.Error_Title>", "<Strings:UTGameUI.Errors.NetworkLinkLost_Message>");
                QuitToMainMenu();
            }
        }
    }
    //return;    
}

function OnReadProfileSettingsComplete(byte LocalUserNum, bool bWasSuccessful)
{
    //return;    
}

function OnGameInviteReceived(byte LocalUserNum, string RequestingNick)
{
    //return;    
}

function OnFriendInviteReceived(byte LocalUserNum, UniqueNetId RequestingPlayer, string RequestingNick, string Message)
{
    //return;    
}

function OnFriendMessageReceived(byte LocalUserNum, UniqueNetId SendingPlayer, string SendingNick, string Message)
{
    //return;    
}

function NotifyInviteFailed()
{
    super(PlayerController).NotifyInviteFailed();
    SetFrontEndErrorMessage("<Strings:UTGameUI.Errors.UnableToJoinInvite_Title>", "<Strings:UTGameUI.Errors.UnableToJoinInvite_Message>");
    QuitToMainMenu();
    //return;    
}

function NotifyNotAllPlayersCanJoinInvite()
{
    super(PlayerController).NotifyNotAllPlayersCanJoinInvite();
    SetFrontEndErrorMessage("<Strings:UTGameUI.Errors.NotAllPlayersCanJoin_Title>", "<Strings:UTGameUI.Errors.NotAllPlayersCanJoin_Message>");
    QuitToMainMenu();
    //return;    
}

function NotifyNotEnoughSpaceInInvite()
{
    super(PlayerController).NotifyNotEnoughSpaceInInvite();
    SetFrontEndErrorMessage("<Strings:UTGameUI.Errors.NotEnoughInviteSpace_Title>", "<Strings:UTGameUI.Errors.NotEnoughInviteSpace_Message>");
    QuitToMainMenu();
    //return;    
}

reliable client simulated function ClientWasKicked()
{
    ClientSetProgressMessage(4, Localize("AccessControl", "KickedMsg", "Engine"));
    //return;    
}

static function SetFrontEndErrorMessage(string Title, string Message)
{
    local UIDataStore_Registry Registry;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    Registry.SetData("FrontEndError_Title", Title);
    Registry.SetData("FrontEndError_Message", Message);
    Registry.SetData("FrontEndError_Display", "1");
    //return;    
}

function QuitToMainMenu()
{
    bCleanupInProgress = true;
    bQuittingToMainMenu = true;
    // End:0x33
    if((CleanupOnlineSubsystemSession(true)) == false)
    {
        FinishQuitToMainMenu();
    }
    //return;    
}

function FinishQuitToMainMenu()
{
    Class'Engine.Engine'.static.StopMovie(true);
    bCleanupComplete = true;
    // End:0x68
    if(DisconnectCommand != "")
    {        
        ConsoleCommand(DisconnectCommand);
        DisconnectCommand = "";        
    }
    else
    {        
        ConsoleCommand("Disconnect");
    }
    //return;    
}

function bool CleanupOnlineSubsystemSession(bool bWasFromMenu)
{
    // End:0x13D
    if((((int(WorldInfo.NetMode) != int(NM_Standalone)) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none))) && OnlineSub.GameInterface.GetGameSettings('Game') != none)
    {
        OnlineSub.GameInterface.AddEndOnlineGameCompleteDelegate(OnEndOnlineGameComplete);
        OnlineSub.GameInterface.EndOnlineGame('Game');
        return true;
    }
    return false;
    //return ReturnValue;    
}

function OnEndOnlineGameComplete(name SessionName, bool bWasSuccessful)
{
    OnlineSub.GameInterface.ClearEndOnlineGameCompleteDelegate(OnEndOnlineGameComplete);
    // End:0xF0
    if(bQuittingToMainMenu)
    {
        OnlineSub.GameInterface.AddDestroyOnlineGameCompleteDelegate(OnDestroyOnlineGameComplete);
        // End:0xF0
        if(!OnlineSub.GameInterface.DestroyOnlineGame('Game'))
        {
            OnDestroyOnlineGameComplete('Game', true);
        }
    }
    //return;    
}

function OnDestroyOnlineGameComplete(name SessionName, bool bWasSuccessful)
{
    OnlineSub.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyOnlineGameComplete);
    FinishQuitToMainMenu();
    //return;    
}

reliable client simulated function ClientSetSpeechRecognitionObject(SpeechRecognition NewRecognitionData)
{
    // End:0x72
    if(NotEqual_InterfaceInterface(VoiceInterface, OnlineVoiceInterface(none)))
    {
        VoiceInterface.SetSpeechRecognitionObject(byte(LocalPlayer(Player).ControllerId), NewRecognitionData);
    }
    //return;    
}

function SpeechRecognitionComplete()
{
    local array<SpeechRecognizedWord> Words;
    local SpeechRecognizedWord ReplicatedWords[3];
    local int I;

    VoiceInterface.GetRecognitionResults(byte(LocalPlayer(Player).ControllerId), Words);
    // End:0xDF
    if(Words.Length > 0)
    {
        I = 0;
        J0x6D:

        // End:0xCC [Loop If]
        if((I < 3) && I < Words.Length)
        {
            ReplicatedWords[I] = Words[I];
            I++;
            // [Loop Continue]
            goto J0x6D;
        }
        ServerProcessSpeechRecognition(ReplicatedWords);
    }
    //return;    
}

reliable server function ServerProcessSpeechRecognition(SpeechRecognizedWord ReplicatedWords[3])
{
    local array<SpeechRecognizedWord> Words;
    local int I;
    local EvilGame Game;

    Game = EvilGame(WorldInfo.Game);
    // End:0xE7
    if(Game != none)
    {
        I = 0;
        J0x4B:

        // End:0xBE [Loop If]
        if(I < 3)
        {
            // End:0xB0
            if(ReplicatedWords[I].WordText != "")
            {
                Words[Words.Length] = ReplicatedWords[I];
            }
            I++;
            // [Loop Continue]
            goto J0x4B;
        }
        Game.ProcessSpeechRecognition(self, Words);
    }
    //return;    
}

exec function ToggleSpeaking(bool bNowOn)
{
    local LocalPlayer LP;

    // End:0x1AD
    if(NotEqual_InterfaceInterface(VoiceInterface, OnlineVoiceInterface(none)))
    {
        LP = LocalPlayer(Player);
        // End:0x1AD
        if(LP != none)
        {
            // End:0x104
            if(bNowOn)
            {
                VoiceInterface.StartNetworkedVoice(byte(LP.ControllerId));
                // End:0x101
                if(int(WorldInfo.NetMode) != int(NM_Client))
                {
                    VoiceInterface.StartSpeechRecognition(byte(LP.ControllerId));
                }                
            }
            else
            {
                VoiceInterface.StopNetworkedVoice(byte(LP.ControllerId));
                // End:0x1AD
                if(int(WorldInfo.NetMode) != int(NM_Client))
                {
                    VoiceInterface.StopSpeechRecognition(byte(LP.ControllerId));
                }
            }
        }
    }
    //return;    
}

unreliable client simulated event ClientHearSound(SoundCue ASound, Actor SourceActor, Vector SourceLocation, bool bStopWhenOwnerDestroyed, optional bool bIsOccluded)
{
    local editinline AudioComponent AC;

    // End:0xA7
    if(SourceActor == none)
    {
        AC = GetPooledAudioComponent(ASound, SourceActor, bStopWhenOwnerDestroyed, true, SourceLocation);
        // End:0x5B
        if(AC == none)
        {
            return;
        }
        AC.bUseOwnerLocation = false;
        AC.Location = SourceLocation;        
    }
    else
    {
        // End:0x148
        if(((SourceActor == (GetViewTarget())) || SourceActor == self) || SourceActor == Pawn)
        {
            AC = GetPooledAudioComponent(ASound, none, bStopWhenOwnerDestroyed);
            // End:0x124
            if(AC == none)
            {
                return;
            }
            AC.bAllowSpatialization = false;            
        }
        else
        {
            AC = GetPooledAudioComponent(ASound, SourceActor, bStopWhenOwnerDestroyed);
            // End:0x18B
            if(AC == none)
            {
                return;
            }
            // End:0x213
            if(!IsZero(SourceLocation) && SourceLocation != SourceActor.Location)
            {
                AC.bUseOwnerLocation = false;
                AC.Location = SourceLocation;
            }
        }
    }
    // End:0x245
    if(bIsOccluded)
    {
        AC.VolumeMultiplier *= 0.5000000;
    }
    AC.Play();
    //return;    
}

function bool AimingHelp(bool bInstantHit)
{
    return bAimingHelp && (int(WorldInfo.NetMode) == int(NM_Standalone)) || UTGameReplicationInfo(WorldInfo.GRI).bStoryMode;
    //return ReturnValue;    
}

function float AimHelpModifier()
{
    local float AimingHelp;

    AimingHelp = ((FOVAngle < (DefaultFOV - float(8))) ? 0.5000000 : 0.7500000);
    // End:0xBA
    if(WorldInfo.Game.GameDifficulty > float(2))
    {
        AimingHelp *= (0.3300000 * (float(5) - WorldInfo.Game.GameDifficulty));
    }
    return AimingHelp;
    //return ReturnValue;    
}

function Rotator GetAdjustedAimFor(Weapon W, Vector StartFireLoc)
{
    local Vector FireDir, HitLocation, HitNormal;
    local Actor BestTarget, HitActor;
    local float bestAim, bestDist, MaxRange;
    local Rotator BaseAimRot;

    BaseAimRot = ((Pawn != none) ? Pawn.GetBaseAimRotation() : Rotation);
    FireDir = Vector(BaseAimRot);
    MaxRange = W.MaxRange();
    HitActor = Trace(HitLocation, HitNormal, StartFireLoc + (MaxRange * FireDir), StartFireLoc, true);
    // End:0x115
    if((HitActor != none) && HitActor.bProjTarget)
    {
        BestTarget = HitActor;        
    }
    else
    {
        // End:0x233
        if(((WorldInfo.Game != none) && WorldInfo.Game.NumBots > 0) || AimingHelp(true))
        {
            bestAim = 0.9500000;
            BestTarget = PickTarget(Class'Engine.Pawn', bestAim, bestDist, FireDir, StartFireLoc, MaxRange);
            // End:0x233
            if((W != none) && W.GetProjectileClass() == none)
            {
                InstantWarnTarget(BestTarget, W, Vector(BaseAimRot));
            }
        }
    }
    ShotTarget = Pawn(BestTarget);
    return BaseAimRot;
    //return ReturnValue;    
}

function bool FindVehicleToDrive()
{
    return (CheckVehicleToDrive(true)) != none;
    //return ReturnValue;    
}

function EvilVehicle_Base CheckPickedVehicle(EvilVehicle_Base V, bool bEnterVehicle)
{
    local EvilPlayerReplicationInfo PRI;

    // End:0x2A
    if((V == none) || !bEnterVehicle)
    {
        return V;
    }
    PRI = EvilPlayerReplicationInfo(PlayerReplicationInfo);
    // End:0x196
    if((PRI.bHasFlag && !V.bCanCarryFlag) && !V.bTeamLocked || WorldInfo.GRI.OnSameTeam(self, V))
    {
        // End:0x152
        if(V.bRequestedEntryWithFlag)
        {
            V.bRequestedEntryWithFlag = false;
            ClientSetRequestedEntryWithFlag(V, false, 0);            
        }
        else
        {
            V.bRequestedEntryWithFlag = true;
            ClientSetRequestedEntryWithFlag(V, true, 0);
            bJustFoundVehicle = true;
            return none;
        }
    }
    // End:0x1CB
    if(V.TryToDrive(Pawn))
    {
        return V;
    }
    bJustFoundVehicle = true;
    return none;
    //return ReturnValue;    
}

reliable client simulated function ClientSetRequestedEntryWithFlag(EvilVehicle_Base V, bool bNewValue, int MessageIndex)
{
    // End:0x2C
    if(bNewValue)
    {
        ReceiveLocalizedMessage(Class'UTVehicleCantCarryFlagMessage', MessageIndex);
    }
    // End:0x65
    if(V != none)
    {
        V.bRequestedEntryWithFlag = bNewValue;
    }
    //return;    
}

function EvilVehicle_Base CheckVehicleToDrive(bool bEnterVehicle)
{
    local EvilVehicle_Base V, PickedVehicle;
    local Vector ViewDir, HitLocation, HitNormal, ViewPoint;
    local Rotator ViewRotation;
    local Actor HitActor;
    local float CheckDist;

    bJustFoundVehicle = false;
    PickedVehicle = CheckPickedVehicle(EvilVehicle_Base(Pawn.Base), bEnterVehicle);
    // End:0x79
    if((PickedVehicle != none) || bJustFoundVehicle)
    {
        return PickedVehicle;
    }
    ViewPoint = Pawn.GetPawnViewLocation();
    ViewRotation = Rotation;
    CheckDist = Pawn.VehicleCheckRadius * VehicleCheckRadiusScaling;
    ViewDir = CheckDist * Vector(ViewRotation);
    HitActor = Trace(HitLocation, HitNormal, ViewPoint + ViewDir, ViewPoint, true,,, 8);
    PickedVehicle = CheckPickedVehicle(EvilVehicle_Base(HitActor), bEnterVehicle);
    // End:0x1A1
    if((PickedVehicle != none) || bJustFoundVehicle)
    {
        return PickedVehicle;
    }
    ViewRotation.Pitch = 0;
    ViewDir = CheckDist * Vector(ViewRotation);
    HitActor = Trace(HitLocation, HitNormal, ViewPoint + ViewDir, ViewPoint, true,,, 8);
    PickedVehicle = CheckPickedVehicle(EvilVehicle_Base(HitActor), bEnterVehicle);
    // End:0x278
    if((PickedVehicle != none) || bJustFoundVehicle)
    {
        return PickedVehicle;
    }
    ViewRotation.Pitch = -5000;
    ViewDir = CheckDist * Vector(ViewRotation);
    HitActor = Trace(HitLocation, HitNormal, ViewPoint + ViewDir, ViewPoint, true,,, 8);
    PickedVehicle = CheckPickedVehicle(EvilVehicle_Base(HitActor), bEnterVehicle);
    // End:0x353
    if((PickedVehicle != none) || bJustFoundVehicle)
    {
        return PickedVehicle;
    }
    // End:0x49E
    if(EvilGame(WorldInfo.Game) != none)
    {
        V = EvilGame(WorldInfo.Game).VehicleList;
        J0x3C6:

        // End:0x49E [Loop If]
        if(V != none)
        {
            // End:0x473
            if(V.bHasCustomEntryRadius && V.InCustomEntryRadius(Pawn))
            {
                V = CheckPickedVehicle(V, bEnterVehicle);
                // End:0x473
                if((V != none) || bJustFoundVehicle)
                {
                    return V;
                }
            }
            V = V.NextVehicle;
            // [Loop Continue]
            goto J0x3C6;
        }
    }
    return none;
    //return ReturnValue;    
}

exec function ToggleMinimap()
{
    bRotateMinimap = !bRotateMinimap;
    //return;    
}

exec function DropFlag()
{
    ServerDropFlag();
    //return;    
}

reliable server function ServerDropFlag()
{
    // End:0xB9
    if(UTPawn(Pawn) != none)
    {
        UTPawn(Pawn).DropFlag();
        // End:0xB9
        if(UTPawn(Pawn).bCanPickupInventory)
        {
            UTPawn(Pawn).bCanPickupInventory = false;
            SetTimer(0.2000000, false, 'EnableInventoryPickup', UTPawn(Pawn));
        }
    }
    //return;    
}

simulated function bool LandingShake()
{
    return bLandingShake;
    //return ReturnValue;    
}

simulated function PlayBeepSound()
{
    //return;    
}

event ReceiveWarning(Pawn shooter, float projSpeed, Vector FireDir)
{
    // End:0x35
    if((WorldInfo.TimeSeconds - LastWarningTime) < 1.0000000)
    {
        return;
    }
    LastWarningTime = WorldInfo.TimeSeconds;
    // End:0xBC
    if((shooter != none) && !WorldInfo.GRI.OnSameTeam(shooter, self))
    {
        ClientMusicEvent(0);
    }
    //return;    
}

function ReceiveProjectileWarning(Projectile Proj)
{
    // End:0x35
    if((WorldInfo.TimeSeconds - LastWarningTime) < 1.0000000)
    {
        return;
    }
    LastWarningTime = WorldInfo.TimeSeconds;
    // End:0x171
    if(((Proj.Instigator != none) && !WorldInfo.GRI.OnSameTeam(Proj.Instigator, self)) && Proj.Speed > float(0))
    {
        SetTimer(VSize(Proj.Location - Pawn.Location) / Proj.Speed, false, 'ProjectileWarningTimer');
    }
    //return;    
}

function ProjectileWarningTimer()
{
    ClientMusicEvent(0);
    //return;    
}

function PlayWinMessage(bool bWinner)
{
    //return;    
}

simulated function bool TriggerInteracted()
{
    local EvilGameObjective O, Best;
    local Vector ViewDir, PawnLoc2D, VLoc2D;
    local float NewDot, BestDot;

    // End:0x2F
    if(EvilGameObjective(Pawn.Base) != none)
    {
        return true;
    }
    // End:0x8B
    foreach Pawn.TouchingActors(Class'EvilGameObjective', O)
    {
        // End:0x8A
        if(O.UsedBy(Pawn))
        {            
            return true;
        }        
    }    
    ViewDir = Vector(Rotation);
    PawnLoc2D = Pawn.Location;
    PawnLoc2D.Z = 0.0000000;
    // End:0x258
    foreach Pawn.OverlappingActors(Class'EvilGameObjective', O, Pawn.VehicleCheckRadius)
    {
        // End:0x257
        if(O.bAllowRemoteUse)
        {
            VLoc2D = O.Location;
            VLoc2D.Z = 0.0000000;
            NewDot = Normal(VLoc2D - PawnLoc2D) Dot ViewDir;
            // End:0x257
            if(NewDot > BestDot)
            {
                // End:0x257
                if(FastTrace(O.Location, Pawn.Location))
                {
                    Best = O;
                    BestDot = NewDot;
                }
            }
        }        
    }    
    // End:0x297
    if((Best != none) && Best.UsedBy(Pawn))
    {
        return true;
    }
    return super(PlayerController).TriggerInteracted();
    //return ReturnValue;    
}

exec function PlayVehicleHorn()
{
    local EvilVehicle_Base V;

    V = EvilVehicle_Base(Pawn);
    // End:0xB8
    if(((V != none) && V.Health > 0) && (WorldInfo.TimeSeconds - LastTauntAnimTime) > 0.3000000)
    {
        ServerPlayVehicleHorn();
        LastTauntAnimTime = WorldInfo.TimeSeconds;
    }
    //return;    
}

unreliable server function ServerPlayVehicleHorn()
{
    local EvilVehicle_Base V;

    V = EvilVehicle_Base(Pawn);
    // End:0x70
    if((V != none) && V.Health > 0)
    {
        V.PlayHorn();
    }
    //return;    
}

exec function Taunt(int TauntIndex)
{
    local EvilVehicle_Base UTV;
    local EvilPawn UTP;

    UTP = EvilPawn(Pawn);
    // End:0x87
    if(UTP == none)
    {
        UTV = EvilVehicle_Base(Pawn);
        // End:0x87
        if(UTV != none)
        {
            UTP = EvilPawn(UTV.Driver);
        }
    }
    // End:0x149
    if(UTP != none)
    {
        switch(TauntIndex)
        {
            // End:0xDD
            case 0:
                UTP.PlayEmote('TauntA', -1);
                // End:0x149
                break;
            // End:0x111
            case 1:
                UTP.PlayEmote('TauntB', -1);
                // End:0x149
                break;
            // End:0x146
            case 2:
                UTP.PlayEmote('TauntC', -1);
                // End:0x149
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        //return;        
    }
}

function Typing(bool bTyping)
{
    bIsTyping = bTyping;
    //return;    
}

simulated event Destroyed()
{
    // End:0x57
    if(LocalPlayer(Player) != none)
    {
        LocalPlayer(Player).ViewportClient.bDisableWorldRendering = false;
    }
    super(PlayerController).Destroyed();
    // End:0x88
    if(Announcer != none)
    {
        Announcer.Destroy();
    }
    // End:0xAF
    if(MusicManager != none)
    {
        MusicManager.Destroy();
    }
    //return;    
}

function OnControllerChanged(int ControllerId, bool bIsConnected)
{
    local LocalPlayer LocPlayer;

    super(PlayerController).OnControllerChanged(ControllerId, bIsConnected);
    LocPlayer = LocalPlayer(Player);
    // End:0x10F
    if(WorldInfo.IsConsoleBuild() && (WorldInfo.Game == none) || !WorldInfo.Game.IsAutomatedPerfTesting())
    {
        // End:0x10F
        if((LocPlayer != none) && LocPlayer.ControllerId == ControllerId)
        {
            bIsControllerConnected = bIsConnected;
        }
    }
    //return;    
}

event SoakPause(Pawn P)
{
    SetViewTarget(P);
    SetPause(true);
    bBehindView = true;
    myHUD.bShowDebugInfo = true;
    //return;    
}

function DrawHUD(HUD H)
{
    // End:0x52
    if(bDedicatedServerSpectator && !H.bShowScores)
    {
        H.ShowScores();
    }
    // End:0xD6
    if((Pawn != none) && EvilWeap_Base(Pawn.Weapon) != none)
    {
        EvilWeap_Base(Pawn.Weapon).ActiveRenderOverlays(H);
    }
    //return;    
}

event KickWarning()
{
    // End:0x72
    if((WorldInfo.TimeSeconds - LastKickWarningTime) > 0.5000000)
    {
        ReceiveLocalizedMessage(Class'UTIdleKickWarningMessage', 0, none, none, self);
        LastKickWarningTime = WorldInfo.TimeSeconds;
    }
    //return;    
}

function CheckJumpOrDuck()
{
    // End:0x11
    if(Pawn == none)
    {
        return;
    }
    // End:0xA9
    if(bDoubleJump && bUpdating || (UTPawn(Pawn) != none) && UTPawn(Pawn).CanDoubleJump())
    {
        UTPawn(Pawn).DoDoubleJump(bUpdating);        
    }
    else
    {
        // End:0xDF
        if(bPressedJump)
        {
            Pawn.DoJump(bUpdating);
        }
    }
    // End:0x15C
    if((int(Pawn.Physics) != int(2)) && Pawn.bCanCrouch)
    {
        Pawn.ShouldCrouch(int(bDuck) != int(0));
    }
    //return;    
}

exec function FOV(float F)
{
    // End:0xA6
    if(((F >= 40.0000000) || int(WorldInfo.NetMode) == int(NM_Standalone)) || PlayerReplicationInfo.bOnlySpectator)
    {
        OnFootDefaultFOV = FClamp(F, 40.0000000, 120.0000000);
        // End:0xA3
        if(Vehicle(Pawn) == none)
        {
            FixFOV();
        }
        SaveConfig();
    }
    //return;    
}

function FixFOV()
{
    // End:0x21
    if(OnFootDefaultFOV < float(40))
    {
        OnFootDefaultFOV = 90.0000000;
    }
    OnFootDefaultFOV = FClamp(OnFootDefaultFOV, 40.0000000, 120.0000000);
    FOVAngle = OnFootDefaultFOV;
    DesiredFOV = OnFootDefaultFOV;
    DefaultFOV = OnFootDefaultFOV;
    //return;    
}

function Restart(bool bVehicleTransition)
{
    super(PlayerController).Restart(bVehicleTransition);
    // End:0x36
    if(!bVehicleTransition)
    {
        SetTimer(0.1000000, false, 'CheckAutoObjective');
    }
    //return;    
}

reliable client simulated function ClientRestart(Pawn NewPawn)
{
    local EvilVehicle_Base V;

    super(PlayerController).ClientRestart(NewPawn);
    ServerPlayerPreferences(WeaponHandPreference, bAutoTaunt, bCenteredWeaponFire, AutoObjectivePreference, VehicleControlType);
    // End:0x1B4
    if(NewPawn != none)
    {
        V = EvilVehicle_Base(NewPawn);
        // End:0xDD
        if((V == none) && NewPawn.IsA('UTWeaponPawn'))
        {
            V = EvilVehicle_Base(NewPawn.GetVehicleBase());
        }
        // End:0x13D
        if(V != none)
        {
            DefaultFOV = V.DefaultFOV;
            DesiredFOV = DefaultFOV;
            FOVAngle = DesiredFOV;            
        }
        else
        {
            FixFOV();
        }
        // End:0x1B1
        if((NewPawn.Weapon != none) && !NewPawn.Weapon.HasAnyAmmo())
        {
            SwitchToBestWeapon();
        }        
    }
    else
    {
        FixFOV();
    }
    //return;    
}

function SetViewTarget(Actor NewViewTarget, optional ViewTargetTransitionParams TransitionParams)
{
    local EvilVehicle_Base V;
    local Pawn P;
    local UTPlayerController.EPawnShadowMode AdjustedShadowMode;

    ClearCameraEffect();
    // End:0x4D
    if(UTPawn(ViewTarget) != none)
    {
        UTPawn(ViewTarget).AdjustPPEffects(self, true);
    }
    super(PlayerController).SetViewTarget(NewViewTarget, TransitionParams);
    // End:0xAB
    if(UTPawn(ViewTarget) != none)
    {
        UTPawn(ViewTarget).AdjustPPEffects(self, false);
    }
    // End:0xFD
    if(ViewTarget.CustomTimeDilation < 1.0000000)
    {        
        ConsoleCommand("SETSOUNDMODE Slow", false);        
    }
    else
    {        
        ConsoleCommand("SETSOUNDMODE Default", false);
    }
    // End:0x3B7
    if(IsLocalPlayerController())
    {
        // End:0x165
        if(Class'Engine.Engine'.static.IsSplitScreen())
        {
            AdjustedShadowMode = 0;            
        }
        else
        {
            V = EvilVehicle_Base(ViewTarget);
            // End:0x1E5
            if((V == none) && Pawn(ViewTarget) != none)
            {
                V = EvilVehicle_Base(Pawn(ViewTarget).GetVehicleBase());
            }
            // End:0x269
            if((((int(PawnShadowMode) > int(0)) && V != none) && V.bDropDetailWhenDriving) && int(WorldInfo.GetDetailMode()) < int(1))
            {
                AdjustedShadowMode = 1;                
            }
            else
            {
                AdjustedShadowMode = PawnShadowMode;
            }
        }
        // End:0x3B6
        foreach WorldInfo.AllPawns(Class'Engine.Pawn', P)
        {
            // End:0x335
            if(EvilPawn(P) != none)
            {
                EvilPawn(P).UpdateShadowSettings((int(AdjustedShadowMode) == int(2)) || (int(AdjustedShadowMode) == int(1)) && ViewTarget == P);
                // End:0x3B5
                continue;
            }
            // End:0x3B5
            if(EvilVehicle_Base(P) != none)
            {
                EvilVehicle_Base(P).UpdateShadowSettings((int(AdjustedShadowMode) == int(2)) || (int(AdjustedShadowMode) == int(1)) && ViewTarget == P);
            }            
        }        
    }
    //return;    
}

function CheckAutoObjective(bool bOnlyNotifyDifferent)
{
    local Actor ObjectiveActor;

    // End:0xB5
    if((Pawn != none) && PlayerReplicationInfo != none)
    {
        ObjectiveActor = EvilGame(WorldInfo.Game).GetAutoObjectiveFor(self);
        // End:0x97
        if(ObjectiveActor != none)
        {
            SetAutoObjective(ObjectiveActor, bOnlyNotifyDifferent);            
        }
        else
        {
            LastAutoObjective = none;
            ClientSetAutoObjective(LastAutoObjective);
        }
    }
    //return;    
}

function SetAutoObjective(Actor ObjectiveActor, bool bOnlyNotifyDifferent)
{
    local EvilGameObjective DesiredObjective;
    local int I;

    DesiredObjective = EvilGameObjective(ObjectiveActor);
    // End:0x71
    if(DesiredObjective != none)
    {
        ObjectiveActor = DesiredObjective.GetAutoObjectiveActor(self);
        DesiredObjective = EvilGameObjective(ObjectiveActor);
    }
    // End:0x228
    if((ObjectiveActor != LastAutoObjective) || !bOnlyNotifyDifferent)
    {
        LastAutoObjective = ObjectiveActor;
        ClientSetAutoObjective(LastAutoObjective);
        // End:0x228
        if((WorldInfo.TimeSeconds - LastShowPathTime) > 0.5000000)
        {
            LastShowPathTime = WorldInfo.TimeSeconds;
            // End:0x1DD
            if(DesiredObjective != none)
            {
                I = 0;
                J0x134:

                // End:0x1DD [Loop If]
                if(I < DesiredObjective.ShootSpots.Length)
                {
                    // End:0x1CF
                    if(DesiredObjective.ShootSpots[I] != none)
                    {
                        DesiredObjective.ShootSpots[I].bTransientEndPoint = true;
                    }
                    I++;
                    // [Loop Continue]
                    goto J0x134;
                }
            }
            // End:0x228
            if(FindPathToward(LastAutoObjective) != none)
            {
                Spawn(Class'UTWillowWhisp', self,, Pawn.Location);
            }
        }
    }
    //return;    
}

reliable client simulated function ClientSetAutoObjective(Actor NewAutoObjective)
{
    LastAutoObjective = NewAutoObjective;
    ReceiveLocalizedMessage(Class'UTObjectiveAnnouncement', int(AutoObjectivePreference),,, LastAutoObjective);
    //return;    
}

event Possess(Pawn inPawn, bool bVehicleTransition)
{
    super(PlayerController).Possess(inPawn, bVehicleTransition);
    // End:0x9E
    if(bVehicleTransition)
    {
        // End:0x9E
        if((int(WorldInfo.NetMode) == int(NM_Client)) || int(WorldInfo.NetMode) == int(NM_Standalone))
        {
            WorldInfo.ForceGarbageCollection();
        }
    }
    //return;    
}

function AcknowledgePossession(Pawn P)
{
    local Rotator NewViewRotation;

    super(PlayerController).AcknowledgePossession(P);
    // End:0x101
    if(LocalPlayer(Player) != none)
    {
        ClientEndZoom();
        // End:0xC8
        if((bUseVehicleRotationOnPossess && Vehicle(P) != none) && UTWeaponPawn(P) == none)
        {
            NewViewRotation = P.Rotation;
            NewViewRotation.Roll = 0;
            SetRotation(NewViewRotation);
        }
        ServerPlayerPreferences(WeaponHandPreference, bAutoTaunt, bCenteredWeaponFire, AutoObjectivePreference, VehicleControlType);
    }
    //return;    
}

simulated event ReceivedPlayer()
{
    super(PlayerController).ReceivedPlayer();
    // End:0x5E
    if(LocalPlayer(Player) != none)
    {
        ServerPlayerPreferences(WeaponHandPreference, bAutoTaunt, bCenteredWeaponFire, AutoObjectivePreference, VehicleControlType);        
    }
    else
    {
        AutoObjectivePreference = 0;
    }
    //return;    
}

reliable server function ServerPlayerPreferences(UTPlayerController.EWeaponHand NewWeaponHand, bool bNewAutoTaunt, bool bNewCenteredWeaponFire, UTPlayerController.EAutoObjectivePreference NewAutoObjectivePreference, UTPlayerController.EUTVehicleControls NewVehicleControls)
{
    ServerSetHand(NewWeaponHand);
    ServerSetAutoTaunt(bNewAutoTaunt);
    bCenteredWeaponFire = bNewCenteredWeaponFire;
    VehicleControlType = NewVehicleControls;
    // End:0x88
    if(int(AutoObjectivePreference) != int(NewAutoObjectivePreference))
    {
        AutoObjectivePreference = NewAutoObjectivePreference;
        CheckAutoObjective(false);
    }
    //return;    
}

reliable server function ServerSetHand(UTPlayerController.EWeaponHand NewWeaponHand)
{
    WeaponHand = NewWeaponHand;
    //return;    
}

function SetHand(UTPlayerController.EWeaponHand NewWeaponHand)
{
    WeaponHandPreference = NewWeaponHand;
    WeaponHand = WeaponHandPreference;
    SaveConfig();
    ServerSetHand(NewWeaponHand);
    //return;    
}

event ResetCameraMode()
{
    //return;    
}

function bool UsingFirstPersonCamera()
{
    return !bBehindView;
    //return ReturnValue;    
}

reliable server function ServerSetAutoTaunt(bool Value)
{
    bAutoTaunt = Value;
    //return;    
}

exec function SetAutoTaunt(bool Value)
{
    default.bAutoTaunt = Value;
    StaticSaveConfig();
    bAutoTaunt = Value;
    ServerSetAutoTaunt(Value);
    //return;    
}

exec function ToggleScreenShotMode()
{
    // End:0xCA
    if(UTHUDBase(myHUD).bCrosshairShow)
    {
        UTHUDBase(myHUD).bCrosshairShow = false;
        SetHand(3);
        myHUD.bShowHUD = false;
        // End:0xC7
        if(UTPawn(Pawn) != none)
        {
            UTPawn(Pawn).TeamBeaconMaxDist = 0.0000000;
        }        
    }
    else
    {
        UTHUDBase(myHUD).bCrosshairShow = true;
        SetHand(0);
        myHUD.bShowHUD = true;
        // End:0x188
        if(UTPawn(Pawn) != none)
        {
            UTPawn(Pawn).TeamBeaconMaxDist = UTPawn(Pawn).default.TeamBeaconMaxDist;
        }
    }
    //return;    
}

reliable client simulated function PlayStartupMessage(byte StartupStage)
{
    //return;    
}

function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum)
{
    local int iDam;

    super(PlayerController).NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
    iDam = Clamp(Damage, 0, 250);
    // End:0xC5
    if(((iDam > 0) || bGodMode) && Pawn != none)
    {
        ClientPlayTakeHit(HitLocation - Pawn.Location, byte(iDam), DamageType);
    }
    //return;    
}

unreliable client simulated function ClientPlayTakeHit(Vector HitLoc, byte Damage, class<DamageType> DamageType)
{
    DamageShake(int(Damage), DamageType);
    HitLoc += Pawn.Location;
    // End:0xA4
    if(UTHUD(myHUD) != none)
    {
        UTHUD(myHUD).DisplayHit(HitLoc, int(Damage), DamageType);
    }
    //return;    
}

unreliable server function ServerUse()
{
    // End:0x7D
    if((LastUseTime == WorldInfo.TimeSeconds) || (Vehicle(Pawn) != none) && (WorldInfo.TimeSeconds - LastUseTime) < 1.0000000)
    {
        return;
    }
    LastUseTime = WorldInfo.TimeSeconds;
    PerformedUseAction();
    //return;    
}

exec function Use()
{
    // End:0x1E
    if(int(Role) < int(ROLE_Authority))
    {
        PerformedUseAction();
    }
    ServerUse();
    //return;    
}

simulated function bool PerformedUseAction()
{
    local EvilCarriedObject Flag;

    bJustFoundVehicle = false;
    // End:0x47
    if((Pawn != none) && Pawn.IsInState('FeigningDeath'))
    {
        return true;        
    }
    else
    {
        // End:0xC5
        if((Pawn != none) && Vehicle(Pawn) == none)
        {
            // End:0xC4
            foreach Pawn.TouchingActors(Class'EvilCarriedObject', Flag)
            {
                // End:0xC3
                if(Flag.FlagUse(self))
                {                    
                    return true;
                }                
            }            
        }
        // End:0x116
        if(int(Pawn.Physics) == int(4))
        {
            UTPawn(Pawn).StopFlying();
        }
        return super(PlayerController).PerformedUseAction();
    }
    //return ReturnValue;    
}

function ClearDoubleClick()
{
    // End:0x33
    if(PlayerInput != none)
    {
        PlayerInput.DoubleClickTimer = 0.0000000;
    }
    //return;    
}

function ServerSpectate()
{
    GotoState('Spectating');
    //return;    
}

function ShowScoreboard()
{
    //return;    
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local Canvas Canvas;

    Canvas = HUD.Canvas;
    Canvas.SetDrawColor(255, 255, 255, 255);
    Canvas.DrawText((((((("CONTROLLER " $ (GetItemName(string(self)))) $ " Physics ") $ (GetPhysicsName())) $ " Pawn ") $ (GetItemName(string(Pawn)))) $ " Yaw ") $ string(Rotation.Yaw));
    out_YPos += out_YL;
    Canvas.SetPos(4.0000000, out_YPos);
    // End:0x235
    if(Pawn == none)
    {
        // End:0x191
        if(PlayerReplicationInfo == none)
        {
            Canvas.DrawText("NO PLAYERREPLICATIONINFO", false);            
        }
        else
        {
            PlayerReplicationInfo.DisplayDebug(HUD, out_YL, out_YPos);
        }
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        super(Actor).DisplayDebug(HUD, out_YL, out_YPos);        
    }
    else
    {
        // End:0x38E
        if(HUD.ShouldDisplayDebug('AI'))
        {
            // End:0x2EE
            if(Enemy != none)
            {
                Canvas.DrawText(((((" STATE: " $ string(GetStateName())) $ " Timer: ") $ string(GetTimerCount())) $ " Enemy ") $ Enemy.GetHumanReadableName(), false);                
            }
            else
            {
                Canvas.DrawText((((" STATE: " $ string(GetStateName())) $ " Timer: ") $ string(GetTimerCount())) $ " NO Enemy ", false);
            }
            out_YPos += out_YL;
            Canvas.SetPos(4.0000000, out_YPos);
        }
    }
    // End:0x404
    if((PlayerCamera != none) && HUD.ShouldDisplayDebug('Camera'))
    {
        PlayerCamera.DisplayDebug(HUD, out_YL, out_YPos);
    }
    //return;    
}

function Reset()
{
    super(PlayerController).Reset();
    // End:0x31
    if(PlayerCamera != none)
    {
        PlayerCamera.Destroy();
    }
    //return;    
}

reliable client simulated function ClientReset()
{
    local EvilGameObjective O;

    super(PlayerController).ClientReset();
    // End:0x31
    if(PlayerCamera != none)
    {
        PlayerCamera.Destroy();
    }
    // End:0x85
    foreach WorldInfo.AllNavigationPoints(Class'EvilGameObjective', O)
    {
        O.ClientReset();        
    }    
    //return;    
}

exec function BehindView()
{
    // End:0x3F
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        SetBehindView(!bBehindView);
    }
    //return;    
}

function SetBehindView(bool bNewBehindView)
{
    bBehindView = bNewBehindView;
    // End:0x30
    if(!bBehindView)
    {
        bFreeCamera = false;
    }
    // End:0x5F
    if(LocalPlayer(Player) == none)
    {
        ClientSetBehindView(bNewBehindView);        
    }
    else
    {
        // End:0xA9
        if(UTPawn(ViewTarget) != none)
        {
            UTPawn(ViewTarget).SetThirdPersonCamera(bNewBehindView);
        }
    }
    LastCameraTimeStamp = WorldInfo.TimeSeconds - 1.0000000;
    //return;    
}

reliable client simulated function ClientSetBehindView(bool bNewBehindView)
{
    // End:0x2C
    if(LocalPlayer(Player) != none)
    {
        SetBehindView(bNewBehindView);
    }
    LastCameraTimeStamp = WorldInfo.TimeSeconds - 1.0000000;
    //return;    
}

function SetCameraMode(name NewCamMode)
{
    bDebugFreeCam = false;
    // End:0x31
    if(PlayerCamera != none)
    {
        super(PlayerController).SetCameraMode(NewCamMode);        
    }
    else
    {
        // End:0x65
        if(NewCamMode == 'ThirdPerson')
        {
            // End:0x62
            if(!bBehindView)
            {
                SetBehindView(true);
            }            
        }
        else
        {
            // End:0xB8
            if(NewCamMode == 'FreeCam')
            {
                // End:0x96
                if(!bBehindView)
                {
                    SetBehindView(true);
                }
                bDebugFreeCam = true;
                DebugFreeCamRot = Rotation;                
            }
            else
            {
                // End:0xD0
                if(bBehindView)
                {
                    SetBehindView(false);
                }
            }
        }
    }
    //return;    
}

function SpawnCamera()
{
    local Actor OldViewTarget;

    PlayerCamera = Spawn(MatineeCameraClass, self);
    // End:0x91
    if(PlayerCamera != none)
    {
        OldViewTarget = ViewTarget;
        PlayerCamera.InitializeFor(self);
        PlayerCamera.SetViewTarget(OldViewTarget);        
    }
    //return;    
}

simulated event GetPlayerViewPoint(out Vector POVLocation, out Rotator POVRotation)
{
    local float DeltaTime;
    local UTPawn P;

    P = ((IsLocalPlayerController()) ? UTPawn(CalcViewActor) : none);
    DeltaTime = WorldInfo.TimeSeconds - LastCameraTimeStamp;
    LastCameraTimeStamp = WorldInfo.TimeSeconds;
    // End:0xE1
    if(CameraActor(ViewTarget) != none)
    {
        // End:0xC2
        if(PlayerCamera == none)
        {
            ResetCameraMode();
            SpawnCamera();
        }
        super(PlayerController).GetPlayerViewPoint(POVLocation, POVRotation);        
    }
    else
    {
        // End:0x113
        if(PlayerCamera != none)
        {
            PlayerCamera.Destroy();
            PlayerCamera = none;
        }
        // End:0x282
        if(ViewTarget != none)
        {
            POVRotation = Rotation;
            // End:0x21C
            if(((PlayerReplicationInfo != none) && PlayerReplicationInfo.bOnlySpectator) && EvilVehicle_Base(ViewTarget) != none)
            {
                EvilVehicle_Base(ViewTarget).bSpectatedView = true;
                ViewTarget.CalcCamera(DeltaTime, POVLocation, POVRotation, FOVAngle);
                EvilVehicle_Base(ViewTarget).bSpectatedView = false;                
            }
            else
            {
                ViewTarget.CalcCamera(DeltaTime, POVLocation, POVRotation, FOVAngle);
            }
            // End:0x27F
            if(bFreeCamera)
            {
                POVRotation = Rotation;
            }            
        }
        else
        {
            CalcCamera(DeltaTime, POVLocation, POVRotation, FOVAngle);
            return;
        }
    }
    POVRotation = Normalize(POVRotation + ShakeRot);
    POVLocation += (ShakeOffset >> Rotation);
    // End:0x345
    if(CameraEffect != none)
    {
        CameraEffect.UpdateLocation(POVLocation, POVRotation, GetFOVAngle());
    }
    CalcViewActor = ViewTarget;
    CalcViewActorLocation = ViewTarget.Location;
    CalcViewActorRotation = ViewTarget.Rotation;
    CalcViewLocation = POVLocation;
    CalcViewRotation = POVRotation;
    // End:0x42D
    if(P != none)
    {
        CalcEyeHeight = P.EyeHeight;
        CalcWalkBob = P.WalkBob;
    }
    //return;    
}

unreliable client simulated function ClientMusicEvent(int EventIndex)
{
    // End:0x37
    if(MusicManager != none)
    {
        MusicManager.MusicEvent(EventIndex);
    }
    //return;    
}

function bool AlreadyInActionMusic()
{
    return ((MusicManager != none) ? MusicManager.AlreadyInActionMusic() : true);
    //return ReturnValue;    
}

exec function Music(int EventIndex)
{
    MusicManager.MusicEvent(EventIndex);
    //return;    
}

reliable client simulated function ClientPlayAnnouncement(class<UTLocalMessage> InMessageClass, int MessageIndex, optional PlayerReplicationInfo PRI, optional Object OptionalObject)
{
    PlayAnnouncement(InMessageClass, MessageIndex, PRI, OptionalObject);
    //return;    
}

function PlayAnnouncement(class<UTLocalMessage> InMessageClass, int MessageIndex, optional PlayerReplicationInfo PRI, optional Object OptionalObject)
{
    // End:0xAA
    if(((WorldInfo.GRI == none) || Announcer == none) || (UTGameReplicationInfo(WorldInfo.GRI) != none) && UTGameReplicationInfo(WorldInfo.GRI).bAnnouncementsDisabled)
    {
        return;
    }
    Announcer.PlayAnnouncement(InMessageClass, MessageIndex, PRI, OptionalObject);
    //return;    
}

function DamageShake(int Damage, class<DamageType> DamageType)
{
    //return;    
}

function StopViewShaking()
{
    // End:0x2F
    if(CameraAnimPlayer != none)
    {
        CameraAnimPlayer.Stop();
    }
    //return;    
}

function PlayCameraAnim(CameraAnim AnimToPlay, optional float Scale = 1.0000000, optional float Rate = 1.0000000, optional float BlendInTime, optional float BlendOutTime, optional bool bLoop, optional bool bIsDamageShake)
{
    local Camera MatineeAnimatedCam;

    bCurrentCamAnimAffectsFOV = false;
    MatineeAnimatedCam = PlayerCamera;
    // End:0xA0
    if(MatineeAnimatedCam != none)
    {
        MatineeAnimatedCam.PlayCameraAnim(AnimToPlay, Rate, Scale, BlendInTime, BlendOutTime, bLoop, false);        
    }
    else
    {
        // End:0x130
        if(CameraAnimPlayer != none)
        {
            CamOverridePostProcess = Class'Engine.CameraActor'.default.CamOverridePostProcess;
            CameraAnimPlayer.Play(AnimToPlay, self, Rate, Scale, BlendInTime, BlendOutTime, bLoop, false);
        }
    }
    // End:0x1CC
    if((!bIsDamageShake && !bLoop) && int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        // End:0x1B8
        if(AnimToPlay.AnimLength <= float(1))
        {
            ClientPlayForceFeedbackWaveform(CameraShakeShortWaveForm);            
        }
        else
        {
            ClientPlayForceFeedbackWaveform(CameraShakeLongWaveForm);
        }
    }
    bCurrentCamAnimIsDamageShake = bIsDamageShake;
    //return;    
}

function StopCameraAnim(optional bool bImmediate)
{
    // End:0x39
    if(CameraAnimPlayer != none)
    {
        CameraAnimPlayer.Stop(bImmediate);
    }
    //return;    
}

function SetCameraAnimStrength(float NewStrength)
{
    // End:0x37
    if(CameraAnimPlayer != none)
    {
        CameraAnimPlayer.BasePlayScale = NewStrength;
    }
    //return;    
}

unreliable client simulated event ClientPlayCameraAnim(CameraAnim AnimToPlay, optional float Scale = 1.0000000, optional float Rate = 1.0000000, optional float BlendInTime, optional float BlendOutTime, optional bool bLoop, optional bool bRandomStartTime, optional Camera.ECameraAnimPlaySpace Space = 0, optional Rotator CustomPlaySpace)
{
    PlayCameraAnim(AnimToPlay, Scale, Rate, BlendInTime, BlendOutTime, bLoop);
    //return;    
}

reliable client simulated event ClientStopCameraAnim(CameraAnim AnimToStop)
{
    StopCameraAnim(true);
    //return;    
}

function OnPlayCameraAnim(UTSeqAct_PlayCameraAnim inAction)
{
    ClientPlayCameraAnim(inAction.AnimToPlay, inAction.IntensityScale, inAction.Rate, inAction.BlendInTime, inAction.BlendOutTime);
    //return;    
}

function OnStopCameraAnim(UTSeqAct_StopCameraAnim inAction)
{
    ClientStopCameraAnim(CameraAnimPlayer.CamAnim);
    //return;    
}

function ViewShake(float DeltaTime)
{
    // End:0x89
    if((CameraAnimPlayer != none) && !CameraAnimPlayer.bFinished)
    {
        CamOverridePostProcess = Class'Engine.CameraActor'.default.CamOverridePostProcess;
        CameraAnimPlayer.AdvanceAnim(DeltaTime, false);        
    }
    else
    {
        ShakeOffset = vect(0.0000000, 0.0000000, 0.0000000);
        ShakeRot = rot(0, 0, 0);
    }
    //return;    
}

simulated exec function ToggleMelee()
{
    // End:0xD2
    if(((Pawn != none) && Pawn.Weapon != none) && Vehicle(Pawn) == none)
    {
        // End:0xC6
        if(Pawn.Weapon.bMeleeWeapon)
        {
            EvilInventoryManager(Pawn.InvManager).SwitchToPreviousWeapon();            
        }
        else
        {
            SwitchWeapon(1);
        }
    }
    //return;    
}

simulated exec function ToggleTranslocator()
{
    // End:0x2C
    if((Pawn != none) && !IsMoveInputIgnored())
    {
        SwitchWeapon(0);
    }
    //return;    
}

function CallServerMove(SavedMove NewMove, Vector ClientLoc, byte ClientRoll, int View, SavedMove OldMove)
{
    local Vector BuildAccel;
    local byte OldAccelX, OldAccelY, OldAccelZ;

    // End:0x14B
    if(OldMove != none)
    {
        BuildAccel = (0.0500000 * OldMove.Acceleration) + vect(0.5000000, 0.5000000, 0.5000000);
        OldAccelX = byte(CompressAccel(int(BuildAccel.X)));
        OldAccelY = byte(CompressAccel(int(BuildAccel.Y)));
        OldAccelZ = byte(CompressAccel(int(BuildAccel.Z)));
        OldServerMove(OldMove.TimeStamp, OldAccelX, OldAccelY, OldAccelZ, OldMove.CompressedFlags());
    }
    // End:0x2BA
    if(PendingMove != none)
    {
        DualServerMove(PendingMove.TimeStamp, PendingMove.Acceleration * float(10), PendingMove.CompressedFlags(), ((PendingMove.Rotation.Yaw & 65535) << 16) + (PendingMove.Rotation.Pitch & 65535), NewMove.TimeStamp, NewMove.Acceleration * float(10), ClientLoc, NewMove.CompressedFlags(), ClientRoll, View);        
    }
    else
    {
        // End:0x3A6
        if((((NewMove.Acceleration * float(10)) == vect(0.0000000, 0.0000000, 0.0000000)) && int(NewMove.DoubleClickMove) == int(0)) && !NewMove.bDoubleJump)
        {
            ShortServerMove(NewMove.TimeStamp, ClientLoc, NewMove.CompressedFlags(), ClientRoll, View);            
        }
        else
        {
            ServerMove(NewMove.TimeStamp, NewMove.Acceleration * float(10), ClientLoc, NewMove.CompressedFlags(), ClientRoll, View);
        }
    }
    //return;    
}

unreliable server function ShortServerMove(float TimeStamp, Vector ClientLoc, byte NewFlags, byte ClientRoll, int View)
{
    ServerMove(TimeStamp, vect(0.0000000, 0.0000000, 0.0000000), ClientLoc, NewFlags, ClientRoll, View);
    //return;    
}

unreliable client simulated function LongClientAdjustPosition(float TimeStamp, name NewState, Actor.EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, Actor NewBase, float NewFloorX, float NewFloorY, float NewFloorZ)
{
    local UTPawn P;
    local Vector OldPos, NewPos;

    P = UTPawn(Pawn);
    // End:0x8E
    if(((P == none) || P.Mesh == none) || P.Mesh.SkeletalMesh == none)
    {
        return;
    }
    // End:0xDB
    if(P != none)
    {
        OldPos = P.Mesh.GetPosition();
    }
    super(PlayerController).LongClientAdjustPosition(TimeStamp, NewState, newPhysics, NewLocX, NewLocY, NewLocZ, NewVelX, NewVelY, NewVelZ, NewBase, NewFloorX, NewFloorY, NewFloorZ);
    // End:0x27F
    if(((P != none) && P.bFeigningDeath) && int(P.Physics) == int(10))
    {
        NewPos = P.Mesh.GetPosition();
        // End:0x27F
        if(VSizeSq(NewPos - OldPos) > 16.0000000)
        {
            P.Mesh.SetRBPosition(P.Mesh.GetPosition());
        }
    }
    //return;    
}

function ViewNextBot()
{
    // End:0x2E
    if(CheatManager != none)
    {
        CheatManager.ViewBot();
    }
    //return;    
}

exec function SwitchWeapon(byte T)
{
    // End:0x4C
    if(UTPawn(Pawn) != none)
    {
        UTPawn(Pawn).SwitchWeapon(T);        
    }
    else
    {
        // End:0x95
        if(UDKVehicleBase(Pawn) != none)
        {
            UDKVehicleBase(Pawn).SwitchWeapon(T);
        }
    }
    //return;    
}

unreliable server function ServerViewSelf(optional ViewTargetTransitionParams TransitionParams)
{
    local Rotator POVRotation;
    local Vector POVLocation;

    GetPlayerViewPoint(POVLocation, POVRotation);
    SetLocation(POVLocation);
    SetRotation(POVRotation);
    SetBehindView(false);
    SetViewTarget(self, TransitionParams);
    //return;    
}

exec function ViewPlayerByName(string PlayerName)
{
    //return;    
}

unreliable server function ServerViewPlayerByName(string PlayerName)
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x17A [Loop If]
    if(I < WorldInfo.GRI.PRIArray.Length)
    {
        // End:0x16C
        if(WorldInfo.GRI.PRIArray[I].PlayerName ~= PlayerName)
        {
            // End:0x16A
            if(WorldInfo.Game.CanSpectate(self, WorldInfo.GRI.PRIArray[I]))
            {
                SetViewTarget(WorldInfo.GRI.PRIArray[I]);
            }
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    ClientMessage(MsgPlayerNotFound);
    //return;    
}

exec function ViewObjective()
{
    ServerViewObjective();
    //return;    
}

unreliable server function ServerViewObjective()
{
    // End:0x96
    if((EvilGame(WorldInfo.Game) != none) && int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        EvilGame(WorldInfo.Game).ViewObjective(self);
    }
    //return;    
}

exec function PrevWeapon()
{
    // End:0x37
    if((Vehicle(Pawn) != none) || Pawn == none)
    {
        AdjustCameraScale(true);        
    }
    else
    {
        // End:0x68
        if(!Pawn.IsInState('FeigningDeath'))
        {
            super(PlayerController).PrevWeapon();
        }
    }
    //return;    
}

exec function NextWeapon()
{
    // End:0x37
    if((Vehicle(Pawn) != none) || Pawn == none)
    {
        AdjustCameraScale(false);        
    }
    else
    {
        // End:0x68
        if(!Pawn.IsInState('FeigningDeath'))
        {
            super(PlayerController).NextWeapon();
        }
    }
    //return;    
}

exec function AdjustCameraScale(bool bIn)
{
    // End:0x4D
    if(EvilPawn(ViewTarget) != none)
    {
        EvilPawn(ViewTarget).AdjustCameraScale(bIn);        
    }
    else
    {
        // End:0x97
        if(EvilVehicle_Base(ViewTarget) != none)
        {
            EvilVehicle_Base(ViewTarget).AdjustCameraScale(bIn);
        }
    }
    //return;    
}

function ShowMidGameMenu(optional name TabTag, optional bool bEnableInput)
{
    local UTGameReplicationInfo GRI;

    GRI = UTGameReplicationInfo(WorldInfo.GRI);
    // End:0x75
    if(GRI != none)
    {
        GRI.ShowMidGameMenu(self, TabTag, bEnableInput);
    }
    //return;    
}

reliable client simulated function ClientGameEnded(Actor EndGameFocus, bool bIsWinner)
{
    // End:0x1C
    if(EndGameFocus == none)
    {
        ServerVerifyViewTarget();        
    }
    else
    {
        SetViewTarget(EndGameFocus);
    }
    // End:0x79
    if((PlayerReplicationInfo != none) && !PlayerReplicationInfo.bOnlySpectator)
    {
        PlayWinMessage(bIsWinner);
    }
    ClientEndZoom();
    GotoState('RoundEnded');
    SetBehindView(true);
    //return;    
}

function RoundHasEnded(optional Actor EndRoundFocus)
{
    SetViewTarget(EndRoundFocus);
    ClientRoundEnded(EndRoundFocus);
    GotoState('RoundEnded');
    //return;    
}

reliable client simulated function ClientRoundEnded(Actor EndRoundFocus)
{
    // End:0x1C
    if(EndRoundFocus == none)
    {
        ServerVerifyViewTarget();        
    }
    else
    {
        SetViewTarget(EndRoundFocus);
    }
    ClientEndZoom();
    GotoState('RoundEnded');
    SetBehindView(true);
    //return;    
}

function CheckBulletWhip(SoundCue BulletWhip, Vector FireLocation, Vector FireDir, Vector HitLocation)
{
    local Vector PlayerDir;
    local float Dist, PawnDist;

    // End:0x17C
    if(ViewTarget != none)
    {
        PlayerDir = ViewTarget.Location - FireLocation;
        Dist = PlayerDir Dot FireDir;
        // End:0x17C
        if((Dist > float(0)) && (FireDir Dot (HitLocation - ViewTarget.Location)) > float(0))
        {
            PawnDist = VSize(PlayerDir);
            // End:0x17C
            if((Square(PawnDist) - Square(Dist)) < float(40000))
            {
                // End:0x17C
                if(FastTrace(ViewTarget.Location + (Class'UTPawn'.default.BaseEyeHeight * vect(0.0000000, 0.0000000, 1.0000000)), FireLocation + (Dist * FireDir)))
                {
                    PlaySound(BulletWhip, true,,, HitLocation);
                }
            }
        }
    }
    //return;    
}

function PawnDied(Pawn P)
{
    LastAutoObjective = none;
    super(PlayerController).PawnDied(P);
    ClientPawnDied();
    //return;    
}

reliable client simulated function ClientPawnDied()
{
    bDuck = 0;
    EndZoom();
    //return;    
}

exec function BasePath(byte Num)
{
    // End:0x37
    if(PlayerReplicationInfo.Team != none)
    {
        ServerShowPathToBase(Num);
    }
    //return;    
}

reliable server function ServerShowPathToBase(byte TeamNum)
{
    // End:0xB5
    if((Pawn != none) && (WorldInfo.TimeSeconds - LastShowPathTime) > 0.5000000)
    {
        LastShowPathTime = WorldInfo.TimeSeconds;
        EvilGame(WorldInfo.Game).ShowPathTo(self, int(TeamNum));
    }
    //return;    
}

exec function BecomeActive()
{
    // End:0x2C
    if(PlayerReplicationInfo.bOnlySpectator)
    {
        ServerBecomeActivePlayer();
    }
    //return;    
}

reliable server function ServerBecomeActivePlayer()
{
    local EvilGame Game;

    Game = EvilGame(WorldInfo.Game);
    // End:0x310
    if((((PlayerReplicationInfo.bOnlySpectator && !WorldInfo.IsInSeamlessTravel()) && HasClientLoadedCurrentWorld()) && Game != none) && Game.AllowBecomeActivePlayer(self))
    {
        SetBehindView(false);
        FixFOV();
        ServerViewSelf();
        PlayerReplicationInfo.bOnlySpectator = false;
        Game.NumSpectators--;
        Game.NumPlayers++;
        PlayerReplicationInfo.Reset();
        BroadcastLocalizedMessage(Game.GameMessageClass, 1, PlayerReplicationInfo);
        // End:0x1F9
        if(Game.bTeamGame)
        {
            Game.ChangeTeam(self, int(Game.PickTeam(0, none)), false);
        }
        // End:0x2E4
        if(!Game.bDelayedStart)
        {
            Game.bRestartLevel = false;
            // End:0x282
            if(Game.bWaitingToStartMatch)
            {
                Game.StartMatch();                
            }
            else
            {
                Game.RestartPlayer(self);
            }
            Game.bRestartLevel = Game.default.bRestartLevel;            
        }
        else
        {
            GotoState('PlayerWaiting');
            ClientGotoState('PlayerWaiting');
        }
        ClientBecameActivePlayer();
    }
    //return;    
}

reliable client simulated function ClientBecameActivePlayer()
{
    UpdateURL("SpectatorOnly", "", false);
    //return;    
}

exec function FlushDebug()
{
    FlushPersistentDebugLines();
    //return;    
}

function OnUpdatePropertyFOVAngle()
{
    bCurrentCamAnimAffectsFOV = true;
    FOVAngle = DesiredFOV + (FOVAngle - 90.0000000);
    //return;    
}

function AdjustFOV(float DeltaTime)
{
    local float DeltaFOV;

    // End:0x147
    if((FOVAngle != DesiredFOV) && !bCurrentCamAnimAffectsFOV || CameraAnimPlayer.bFinished)
    {
        // End:0x94
        if(bNonlinearZoomInterpolation)
        {
            FOVAngle = FInterpTo(FOVAngle, DesiredFOV, DeltaTime, FOVNonlinearZoomInterpSpeed);            
        }
        else
        {
            // End:0x134
            if(FOVLinearZoomRate > 0.0000000)
            {
                DeltaFOV = FOVLinearZoomRate * DeltaTime;
                // End:0x108
                if(FOVAngle > DesiredFOV)
                {
                    FOVAngle = FMax(DesiredFOV, FOVAngle - DeltaFOV);                    
                }
                else
                {
                    FOVAngle = FMin(DesiredFOV, FOVAngle + DeltaFOV);
                }                
            }
            else
            {
                FOVAngle = DesiredFOV;
            }
        }
    }
    //return;    
}

simulated function StartZoom(float NewDesiredFOV, float NewZoomRate)
{
    FOVLinearZoomRate = NewZoomRate;
    DesiredFOV = NewDesiredFOV;
    bNonlinearZoomInterpolation = false;
    FOVNonlinearZoomInterpSpeed = 0.0000000;
    //return;    
}

simulated function StartZoomNonlinear(float NewDesiredFOV, float NewZoomInterpSpeed)
{
    DesiredFOV = NewDesiredFOV;
    FOVNonlinearZoomInterpSpeed = NewZoomInterpSpeed;
    bNonlinearZoomInterpolation = true;
    FOVLinearZoomRate = 0.0000000;
    //return;    
}

simulated function StopZoom()
{
    DesiredFOV = FOVAngle;
    FOVLinearZoomRate = 0.0000000;
    //return;    
}

simulated function EndZoom()
{
    DesiredFOV = DefaultFOV;
    FOVAngle = DefaultFOV;
    FOVLinearZoomRate = 0.0000000;
    FOVNonlinearZoomInterpSpeed = 0.0000000;
    //return;    
}

simulated function EndZoomNonlinear(float ZoomInterpSpeed)
{
    DesiredFOV = DefaultFOV;
    FOVNonlinearZoomInterpSpeed = ZoomInterpSpeed;
    bNonlinearZoomInterpolation = true;
    FOVLinearZoomRate = 0.0000000;
    //return;    
}

reliable client simulated function ClientEndZoom()
{
    EndZoom();
    //return;    
}

function UpdateRotation(float DeltaTime)
{
    local Rotator DeltaRot;

    // End:0xAF
    if(bDebugFreeCam)
    {
        DeltaRot.Yaw = int(PlayerInput.aTurn);
        DeltaRot.Pitch = int(PlayerInput.aLookUp);
        ProcessViewRotation(DeltaTime, DebugFreeCamRot, DeltaRot);        
    }
    else
    {
        super(PlayerController).UpdateRotation(DeltaTime);
    }
    //return;    
}

exec function GetPlayerLoc()
{
    //return;    
}

function CharacterProcessingComplete()
{
    local LocalPlayer LP;

    LP = LocalPlayer(Player);
    // End:0xF4
    if(LP != none)
    {
        // End:0xF4
        if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none))) && !OnlineSub.SystemInterface.IsControllerConnected(LP.ControllerId))
        {
            OnControllerChanged(LP.ControllerId, false);
        }
    }
    //return;    
}

function bool CanRestartPlayer()
{
    return super(PlayerController).CanRestartPlayer();
    //return ReturnValue;    
}

function SendMessage(PlayerReplicationInfo Recipient, name MessageType, float Wait, optional class<DamageType> DamageType)
{
    // End:0x9E
    if((((MessageType == 'Taunt') && Recipient != none) && UTPlayerController(Recipient.Owner) != none) && !UTPlayerController(Recipient.Owner).bAutoTaunt)
    {
        return;
    }
    EvilPlayerReplicationInfo(PlayerReplicationInfo).VoiceClass.static.SendVoiceMessage(self, Recipient, MessageType, DamageType);
    //return;    
}

unreliable client simulated function ReceiveBotVoiceMessage(EvilPlayerReplicationInfo SenderPRI, int MessageIndex, Object LocationObject)
{
    // End:0x68
    if(SenderPRI.VoiceClass != none)
    {
        ReceiveLocalizedMessage(SenderPRI.VoiceClass, MessageIndex, SenderPRI,, LocationObject);
    }
    //return;    
}

reliable server function ServerSetNetSpeed(int NewSpeed)
{
    // End:0x97
    if((WorldInfo.Game != none) && int(WorldInfo.NetMode) == int(NM_ListenServer))
    {
        NewSpeed = Min(NewSpeed, WorldInfo.Game.AdjustedNetSpeed);
    }
    SetNetSpeed(NewSpeed);
    //return;    
}

function BullseyeMessage()
{
    // End:0xA3
    if((WorldInfo.TimeSeconds - LastBullseyeTime) > 2.0000000)
    {
        ReceiveLocalizedMessage(Class'UTWeaponKillRewardMessage', 1);
        LastBullseyeTime = WorldInfo.TimeSeconds;
        EvilPlayerReplicationInfo(PlayerReplicationInfo).IncrementEventStat('EVENT_BULLSEYE');
    }
    //return;    
}

reliable server function ServerChangeTeam(int N)
{
    // End:0xB2
    if((WorldInfo.TimeSeconds > (LastTeamChangeTime + 1.0000000)) && !UTGameReplicationInfo(WorldInfo.GRI).bStoryMode)
    {
        LastTeamChangeTime = WorldInfo.TimeSeconds;
        super(PlayerController).ServerChangeTeam(N);
    }
    //return;    
}

event GetSeamlessTravelActorList(bool bToEntry, out array<Actor> ActorList)
{
    ShowScoreboard();
    super(PlayerController).GetSeamlessTravelActorList(bToEntry, ActorList);
    //return;    
}

reliable server function ServerKickBan(string PlayerToKick, bool bBan)
{
    // End:0xF0
    if(PlayerReplicationInfo.bAdmin || LocalPlayer(Player) != none)
    {
        // End:0x9E
        if(bBan)
        {
            WorldInfo.Game.AccessControl.KickBan(PlayerToKick);            
        }
        else
        {
            WorldInfo.Game.AccessControl.Kick(PlayerToKick);
        }
    }
    //return;    
}

unreliable server function ServerSay(string msg)
{
    // End:0x22
    if(!bServerMutedText)
    {
        super(PlayerController).ServerSay(msg);
    }
    //return;    
}

unreliable server function ServerTeamSay(string msg)
{
    // End:0x22
    if(!bServerMutedText)
    {
        super(PlayerController).ServerTeamSay(msg);
    }
    //return;    
}

function bool AdminCmdOk()
{
    // End:0x45
    if((int(WorldInfo.NetMode) == int(NM_ListenServer)) && LocalPlayer(Player) != none)
    {
        return true;
    }
    // End:0x73
    if(WorldInfo.TimeSeconds < NextAdminCmdTime)
    {
        return false;
    }
    NextAdminCmdTime = WorldInfo.TimeSeconds + 5.0000000;
    return true;
    //return ReturnValue;    
}

exec function AdminLogin(string Password)
{
    // End:0x32
    if((Password != "") && AdminCmdOk())
    {
        ServerAdminLogin(Password);
    }
    //return;    
}

reliable server function ServerAdminLogin(string Password)
{
    // End:0xE8
    if((WorldInfo.Game.AccessControl != none) && AdminCmdOk())
    {
        // End:0xE8
        if(WorldInfo.Game.AccessControl.AdminLogin(self, Password))
        {
            WorldInfo.Game.AccessControl.AdminEntered(self);
        }
    }
    //return;    
}

exec function AdminLogout()
{
    // End:0x17
    if(AdminCmdOk())
    {
        ServerAdminLogOut();
    }
    //return;    
}

reliable server function ServerAdminLogOut()
{
    // End:0xD0
    if(WorldInfo.Game.AccessControl != none)
    {
        // End:0xD0
        if(WorldInfo.Game.AccessControl.AdminLogout(self))
        {
            WorldInfo.Game.AccessControl.AdminExited(self);
        }
    }
    //return;    
}

exec function Admin(string CommandLine)
{
    // End:0x35
    if(PlayerReplicationInfo.bAdmin)
    {
        ServerAdmin(CommandLine);
    }
    //return;    
}

reliable server function ServerAdmin(string CommandLine)
{
    local string Result;

    // End:0x65
    if(PlayerReplicationInfo.bAdmin)
    {
        Result = ConsoleCommand(CommandLine);
        // End:0x65
        if(Result != "")
        {
            ClientMessage(Result);
        }
    }
    //return;    
}

exec function AdminKickBan(string S)
{
    // End:0x36
    if(PlayerReplicationInfo.bAdmin)
    {
        ServerKickBan(S, true);
    }
    //return;    
}

exec function AdminKick(string S)
{
    // End:0x36
    if(PlayerReplicationInfo.bAdmin)
    {
        ServerKickBan(S, false);
    }
    //return;    
}

exec function AdminPlayerList()
{
    local PlayerReplicationInfo PRI;

    // End:0xEC
    if(PlayerReplicationInfo.bAdmin)
    {
        ClientMessage("Player List:");
        // End:0xEB
        foreach DynamicActors(Class'Engine.PlayerReplicationInfo', PRI)
        {
            ClientMessage(((((string(PRI.PlayerID) $ ".") @ PRI.PlayerName) @ "Ping:") @ string(int((float(PRI.Ping) / 250.0000000) * 1000.0000000))) $ "ms)");            
        }        
    }
    //return;    
}

exec function AdminRestartMap()
{
    // End:0x2C
    if(PlayerReplicationInfo.bAdmin)
    {
        ServerRestartMap();
    }
    //return;    
}

reliable server function ServerRestartMap()
{
    // End:0x4D
    if(PlayerReplicationInfo.bAdmin)
    {
        WorldInfo.ServerTravel("?restart", false);
    }
    //return;    
}

exec function AdminChangeMap(string URL)
{
    // End:0x35
    if(PlayerReplicationInfo.bAdmin)
    {
        ServerChangeMap(URL);
    }
    //return;    
}

reliable server function ServerChangeMap(string URL)
{
    // End:0x4C
    if(PlayerReplicationInfo.bAdmin)
    {
        WorldInfo.ServerTravel(URL);
    }
    //return;    
}

exec function AdminForceVoiceMute(string TargetPlayer)
{
    // End:0x35
    if(PlayerReplicationInfo.bAdmin)
    {
        ServerForceVoiceMute(TargetPlayer);
    }
    //return;    
}

reliable server function ServerForceVoiceMute(string TargetPlayer)
{
    local PlayerController PC, TargetPlayerPC;

    // End:0x170
    if(PlayerReplicationInfo.bAdmin)
    {
        TargetPlayerPC = UTPlayerController(WorldInfo.Game.AccessControl.GetControllerFromString(TargetPlayer));
        // End:0x170
        if(TargetPlayerPC != none)
        {
            ClientMessage("Muting (Voice):" @ TargetPlayerPC.PlayerReplicationInfo.PlayerName);
            // End:0x16F
            foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
            {
                PC.ServerMutePlayer(TargetPlayerPC.PlayerReplicationInfo.UniqueId);                
            }            
        }
    }
    //return;    
}

exec function AdminForceVoiceUnMute(string TargetPlayer)
{
    // End:0x35
    if(PlayerReplicationInfo.bAdmin)
    {
        ServerForceVoiceUnMute(TargetPlayer);
    }
    //return;    
}

reliable server function ServerForceVoiceUnMute(string TargetPlayer)
{
    local PlayerController PC, TargetPlayerPC;

    // End:0x172
    if(PlayerReplicationInfo.bAdmin)
    {
        TargetPlayerPC = UTPlayerController(WorldInfo.Game.AccessControl.GetControllerFromString(TargetPlayer));
        ClientMessage("UnMuting (Voice):" @ TargetPlayerPC.PlayerReplicationInfo.PlayerName);
        // End:0x172
        if(TargetPlayerPC != none)
        {
            // End:0x171
            foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
            {
                PC.ServerUnmutePlayer(TargetPlayerPC.PlayerReplicationInfo.UniqueId);                
            }            
        }
    }
    //return;    
}

exec function AdminForceTextMute(string TargetPlayer)
{
    // End:0x35
    if(PlayerReplicationInfo.bAdmin)
    {
        ServerForceTextMute(TargetPlayer);
    }
    //return;    
}

reliable server function ServerForceTextMute(string TargetPlayer)
{
    local UTPlayerController TargetPlayerPC;

    // End:0x108
    if(PlayerReplicationInfo.bAdmin)
    {
        TargetPlayerPC = UTPlayerController(WorldInfo.Game.AccessControl.GetControllerFromString(TargetPlayer));
        // End:0x108
        if(TargetPlayerPC != none)
        {
            ClientMessage("Muting (Text):" @ TargetPlayerPC.PlayerReplicationInfo.PlayerName);
            TargetPlayerPC.bServerMutedText = true;
        }
    }
    //return;    
}

exec function AdminForceTextUnMute(string TargetPlayer)
{
    // End:0x35
    if(PlayerReplicationInfo.bAdmin)
    {
        ServerForceTextUnMute(TargetPlayer);
    }
    //return;    
}

reliable server function ServerForceTextUnMute(string TargetPlayer)
{
    local UTPlayerController TargetPlayerPC;

    // End:0x10A
    if(PlayerReplicationInfo.bAdmin)
    {
        TargetPlayerPC = UTPlayerController(WorldInfo.Game.AccessControl.GetControllerFromString(TargetPlayer));
        // End:0x10A
        if(TargetPlayerPC != none)
        {
            ClientMessage("UnMuting (Text):" @ TargetPlayerPC.PlayerReplicationInfo.PlayerName);
            TargetPlayerPC.bServerMutedText = false;
        }
    }
    //return;    
}

exec function Disconnect()
{
    QuitToMainMenu();
    //return;    
}

event bool NotifyDisconnect(string Command)
{
    // End:0x3F
    if((Right(Command, 6) ~= " force") || InStr(Command, " force ", true, true) != -1)
    {
        return false;
    }
    // End:0x6B
    if(!bCleanupInProgress)
    {
        DisconnectCommand = Command;
        QuitToMainMenu();
    }
    return bCleanupInProgress && !bCleanupComplete;
    //return ReturnValue;    
}

state PlayerWalking
{
    ignores SeePlayer, HearNoise, Bump;

    event bool NotifyLanded(Vector HitNormal, Actor FloorActor)
    {
        // End:0x2D
        if(int(DoubleClickDir) == int(5))
        {
            DoubleClickDir = 6;
            ClearDoubleClick();            
        }
        else
        {
            DoubleClickDir = 0;
        }
        // End:0x5A
        if(global.NotifyLanded(HitNormal, FloorActor))
        {
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    function ProcessMove(float DeltaTime, Vector newAccel, Actor.EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        // End:0x4E
        if((int(DoubleClickMove) == int(5)) && int(Pawn.Physics) == int(2))
        {
            DoubleClickDir = 5;            
        }
        else
        {
            // End:0xB8
            if((int(DoubleClickMove) != int(0)) && int(DoubleClickMove) < int(5))
            {
                // End:0xB8
                if(UTPawn(Pawn).Dodge(DoubleClickMove))
                {
                    DoubleClickDir = 5;
                }
            }
        }
        super.ProcessMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
        //return;        
    }

    function PlayerMove(float DeltaTime)
    {
        GroundPitch = 0;
        super.PlayerMove(DeltaTime);
        //return;        
    }
    stop;    
}

state PlayerFlying
{
    ignores SeePlayer, HearNoise, Bump;

    function PlayerMove(float DeltaTime)
    {
        super.PlayerMove(DeltaTime);
        CheckJumpOrDuck();
        //return;        
    }
    stop;    
}

state Dead
{
    ignores SeePlayer, HearNoise, KilledBy, NextWeapon, PrevWeapon, SwitchWeapon, 
	    ToggleMelee;

    exec function StartFire(optional byte FireModeNum)
    {
        // End:0x49
        if(bFrozen)
        {
            // End:0x47
            if(!IsTimerActive() || GetTimerCount() > MinRespawnDelay)
            {
                bFrozen = false;
            }
            return;
        }
        // End:0x78
        if(PlayerReplicationInfo.bOutOfLives)
        {
            ServerSpectate();            
        }
        else
        {
            super.StartFire(FireModeNum);
        }
        //return;        
    }

    function Timer()
    {
        // End:0x11
        if(!bFrozen)
        {
            return;
        }
        // End:0x85
        if((int(WorldInfo.NetMode) == int(NM_Client)) || int(WorldInfo.NetMode) == int(NM_Standalone))
        {
            WorldInfo.ForceGarbageCollection();
        }
        bFrozen = false;
        bUsePhysicsRotation = false;
        bPressedJump = false;
        //return;        
    }

    reliable client simulated event ClientSetViewTarget(Actor A, optional ViewTargetTransitionParams TransitionParams)
    {
        // End:0x1C
        if(A == none)
        {
            ServerVerifyViewTarget();
            return;
        }
        // End:0x2D
        if(A == self)
        {
            return;
        }
        SetViewTarget(A, TransitionParams);
        //return;        
    }

    function DoForcedRespawn()
    {
        // End:0x39
        if(PlayerReplicationInfo.bOnlySpectator)
        {
            ClearTimer('DoForcedRespawn');            
        }
        else
        {
            ServerRestartPlayer();
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        bUsePhysicsRotation = false;
        super.EndState(NextStateName);
        SetBehindView(false);
        StopViewShaking();
        ClearTimer('DoForcedRespawn');
        //return;        
    }
Begin:

    Sleep(5.0000000);
    // End:0x6E
    if(((ViewTarget == none) || ViewTarget == self) || VSize(ViewTarget.Velocity) < 1.0000000)
    {
        Sleep(1.0000000);
        // End:0x6B
        if(myHUD != none)
        {
        }        
    }
    else
    {
        goto 'Begin';
    }
    stop;                
}

state WaitingForPawn
{
    ignores SwitchWeapon;

    simulated event FellOutOfWorld(class<DamageType> dmgType)
    {
        bCameraOutOfWorld = true;
        //return;        
    }

    function ProcessMove(float DeltaTime, Vector newAccel, Actor.EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        local Vector OldLocation;

        OldLocation = Location;
        super(BaseSpectating).ProcessMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
        // End:0x66
        if(bCameraOutOfWorld)
        {
            bCameraOutOfWorld = false;
            SetLocation(OldLocation);
        }
        //return;        
    }

    simulated event GetPlayerViewPoint(out Vector out_Location, out Rotator out_Rotation)
    {
        // End:0x38
        if(PlayerCamera == none)
        {
            out_Location = Location;
            out_Rotation = BlendedTargetViewRotation;            
        }
        else
        {
            global.GetPlayerViewPoint(out_Location, out_Rotation);
        }
        //return;        
    }
    stop;    
}

state Spectating
{
    ignores SwitchWeapon;

    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        // End:0x96
        if((WorldInfo.Game != none) && WorldInfo.Game.IsAutomatedPerfTesting())
        {
            SetTimer(5.0000000, false, 'SetServerViewNextPlayer');
            SetTimer(30.0000000, true, 'ServerViewNextPlayer');
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        ClearTimer('ServerViewNextPlayer');
        //return;        
    }

    function SetServerViewNextPlayer()
    {
        ServerViewNextPlayer();
        //return;        
    }

    simulated event FellOutOfWorld(class<DamageType> dmgType)
    {
        bCameraOutOfWorld = true;
        //return;        
    }

    function ProcessMove(float DeltaTime, Vector newAccel, Actor.EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        local Vector OldLocation;

        OldLocation = Location;
        super(BaseSpectating).ProcessMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
        // End:0x66
        if(bCameraOutOfWorld)
        {
            bCameraOutOfWorld = false;
            SetLocation(OldLocation);
        }
        //return;        
    }

    exec function ViewPlayerByName(string PlayerName)
    {
        ServerViewPlayerByName(PlayerName);
        //return;        
    }

    exec function BehindView()
    {
        bForceBehindView = !bForceBehindView;
        //return;        
    }

    exec function PrevWeapon()
    {
        ServerViewPrevPlayer();
        //return;        
    }

    exec function NextWeapon()
    {
        ServerViewNextPlayer();
        //return;        
    }

    exec function StartFire(optional byte FireModeNum)
    {
        ServerViewObjective();
        //return;        
    }

    unreliable server function ServerViewObjective()
    {
        // End:0x6B
        if(EvilGame(WorldInfo.Game) != none)
        {
            EvilGame(WorldInfo.Game).ViewObjective(self);
        }
        //return;        
    }

    exec function StartAltFire(optional byte FireModeNum)
    {
        ServerViewSelf();
        //return;        
    }

    simulated event GetPlayerViewPoint(out Vector out_Location, out Rotator out_Rotation)
    {
        // End:0x6B
        if((WorldInfo.Game != none) && WorldInfo.Game.IsAutomatedPerfTesting())
        {
            SetBehindView(false);            
        }
        else
        {
            // End:0xB2
            if((bBehindView != bForceBehindView) && UTPawn(ViewTarget) != none)
            {
                SetBehindView(bForceBehindView);
            }
        }
        global.GetPlayerViewPoint(out_Location, out_Rotation);
        //return;        
    }
    stop;    
}

state InQueue extends Spectating
{
    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        PlayerReplicationInfo.bIsSpectator = true;
        //return;        
    }

    function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        SetBehindView(false);
        //return;        
    }
    stop;    
}

defaultproperties
{
    bUseVehicleRotationOnPossess=true
    bFirstPersonWeaponsSelfShadow=true
    bForceBehindView=true
    bLandingShake=true
    IdentifiedTeam=255
    PawnShadowMode=EPawnShadowMode.SHADOW_All
    AutoObjectivePreference=EAutoObjectivePreference.AOP_NoPreference
    LastKickWarningTime=-1000.0000000
    // Reference: ForceFeedbackWaveform'Default__UTPlayerController.ForceFeedbackWaveform7'
    begin object name="ForceFeedbackWaveform7" class=Class'Engine.ForceFeedbackWaveform'
        Samples=/* Array type was not detected. */
    end object
    CameraShakeShortWaveForm=ForceFeedbackWaveform7
    // Reference: ForceFeedbackWaveform'Default__UTPlayerController.ForceFeedbackWaveform8'
    begin object name="ForceFeedbackWaveform8" class=Class'Engine.ForceFeedbackWaveform'
        Samples=/* Array type was not detected. */
    end object
    CameraShakeLongWaveForm=ForceFeedbackWaveform8
    MatineeCameraClass=Class'Engine.Camera'
    ZoomRotationModifier=0.5000000
    OldMessageTime=-100.0000000
    OnFootDefaultFOV=95.0000000
    LastTeamChangeTime=-1000.0000000
    VehicleCheckRadiusScaling=1.0000000
    PulseTimer=5.0000000
    CameraClass=none
    bCheckSoundOcclusion=true
    FOVAngle=90.0000000
    DesiredFOV=90.0000000
    DefaultFOV=90.0000000
    CheatClass=Class'EvilCheatManager'
    InputClass=Class'UTPlayerInput'
    // Reference: CylinderComponent'Default__UTPlayerController.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'UDKBase.Default__UDKPlayerController.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    MinRespawnDelay=1.5000000
    Components[0]=CollisionCylinder
    CollisionComponent=CollisionCylinder
}