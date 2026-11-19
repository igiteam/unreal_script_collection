class TurokFEMultiplayerScreen extends TurokUISceneController
    abstract
    native
    implements(TurokLobbyFrontEndInterface);

const kUnlimited = 0;
const kUnlimitedString = "UNLIMITED";
const T_MultiplayerLobby = 1765766536;
const M_StartGame = -874201586;
const M_FindGame = -127783084;
const M_Ready = -1527556801;
const M_NotReady = -846060552;
const M_GameMode = 246944170;
const M_GameType = 451667218;
const M_Ranked = 1996533597;
const M_Unranked = 351939398;
const M_MatchType = 1361792883;
const M_ChangeMatchType = 1732531469;
const M_Playlist = -2124636806;
const M_Map = -1785377899;
const M_WeaponSet = 1991252249;
const M_Time = 1192249572;
const M_Score = -219719900;
const M_Lives = 1973906332;
const M_AdvancedOptionsMP = -464077805;
const M_SavePreset = 747322614;
const M_Difficulty = 1691131612;
const M_TeamLives = 153229020;

struct native BackgroundTextureSet
{
    var int Id;
    var @NULL BG_0;
    var @NULL BG_0_1;
    var @NULL BG_1;
    var @NULL BG_1_1;
    var @NULL BG_2;
    var @NULL BG_2_1;
    var @NULL BG_3;
    var @NULL BG_3_1;

    structdefaultproperties
    {
        Id=0
        BG_0=none
        BG_0_1=none
        BG_1=none
        BG_1_1=none
        BG_2=none
        BG_2_1=none
        BG_3=none
        BG_3_1=none
    }
};

var private native const noexport @NULL VfTable_ITurokLobbyFrontEndInterface;
var array mGameModeTextureSets;
var array mMapTextureSets;
var @NULL BG_0;
var @NULL BG_0_1;
var @NULL BG_1;
var @NULL BG_1_1;
var @NULL BG_2;
var @NULL BG_2_1;
var @NULL BG_3;
var @NULL BG_3_1;
var protected @NULL mTurokTextImage1;
var protected @NULL mTurokTextImage2;
var protected @NULL mBackground;
var protected @NULL mFEAudio;
var protected bool mBlockInput;
var protected int mNumPendingLoads;
var protected float mFEMultiplayerMusicVolume;

// Export UTurokFEMultiplayerScreen::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

// Export UTurokFEMultiplayerScreen::execSetLobbyInterface(FFrame&, void* const)
native function SetLobbyInterface();

// Export UTurokFEMultiplayerScreen::execClearLobbyInterface(FFrame&, void* const)
native function ClearLobbyInterface();

// Export UTurokFEMultiplayerScreen::execOnLobbyEvent(FFrame&, void* const)
native function OnLobbyEvent(@NULL Event);

// Export UTurokFEMultiplayerScreen::execOnSearchSettingsChanged(FFrame&, void* const)
native function OnSearchSettingsChanged();

// Export UTurokFEMultiplayerScreen::execOnPlayersChanged(FFrame&, void* const)
native function OnPlayersChanged();

// Export UTurokFEMultiplayerScreen::execOnGameSettingsChanged(FFrame&, void* const)
native function OnGameSettingsChanged();

// Export UTurokFEMultiplayerScreen::execOnGameDestroyed(FFrame&, void* const)
native function OnGameDestroyed(byte Reason);

// Export UTurokFEMultiplayerScreen::execOnPartyDestroyed(FFrame&, void* const)
native function OnPartyDestroyed(byte Reason);

// Export UTurokFEMultiplayerScreen::execOnPartyMigrationStarted(FFrame&, void* const)
native function OnPartyMigrationStarted();

// Export UTurokFEMultiplayerScreen::execOnPartyMigrationCompleted(FFrame&, void* const)
native function OnPartyMigrationCompleted(bool bSuccess, @NULL NewHost);

// Export UTurokFEMultiplayerScreen::execOnGameMigrationStarted(FFrame&, void* const)
native function OnGameMigrationStarted();

// Export UTurokFEMultiplayerScreen::execOnGameMigrationCompleted(FFrame&, void* const)
native function OnGameMigrationCompleted(bool bSuccess, @NULL NewHost);

// Export UTurokFEMultiplayerScreen::execValueToString(FFrame&, void* const)
native static final function string ValueToString(int Value, bool useUnlimited);

event SCInitialized()
{
    local class<Class> FEAudioClass;

    SetLobbyInterface();
    FEAudioClass = class<TurokFEAudio>(DynamicLoadObject("TurokEngine.TurokFEAudio", Class'Core.Class'));
    // End:0x56
    if(FEAudioClass != none)
    {
        mFEAudio = new (self) FEAudioClass;
    }
    //return;    
}

event SCTick(float DeltaTime)
{
    //return;    
}

event SCCleanUpOnExit()
{
    mFEAudio = none;
    SceneClient = none;
    BG_0 = none;
    BG_0_1 = none;
    BG_1 = none;
    BG_1_1 = none;
    BG_2 = none;
    BG_2_1 = none;
    BG_3 = none;
    BG_3_1 = none;
    ClearLobbyInterface();
    Class'Engine.TurokOnlineDashboard'.static.Instance().EndBusyTask();
    //return;    
}

event bool SCInputKey_Multiplayer(int ControllerId, name Key, byte Event, float AmountDepressed)
{
    // End:0x0B
    if(mBlockInput)
    {
        return true;
    }
    // End:0x82
    if(int(Event) == int(0))
    {
        switch(Key)
        {
            // End:0x43
            case 'XboxTypeS_Back':
                // End:0x43
                if(Class'Engine.Engine'.static.IsPS3())
                {
                    // End:0x82
                    break;
                }
            // End:0x4F
            case 'XboxTypeS_B':
            // End:0x5B
            case 'MouseXButton1':
            // End:0x67
            case 'BackSpace':
            // End:0x7F
            case 'Escape':
                GoBackScreen();
                return true;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        return false;
        //return ReturnValue;        
    }
}

function SetupIntroAnim(@NULL obj)
{
    local @NULL temp_color, script;

    // End:0x33
    if(obj.IsA('UILabel'))
    {
        temp_color = UILabel(obj).mFontColor;        
    }
    else
    {
        temp_color.R = byte(255);
        temp_color.G = byte(255);
        temp_color.B = byte(255);
    }
    temp_color.A = 0;
    script = Class'TurokEngine.TurokUI'.static.AddScript(obj, "intro");
    // End:0x102
    if(script != none)
    {
        script.AddColorKey(0.0000000, temp_color);
        temp_color.A = byte(255);
        script.AddColorKey(0.1000000, temp_color);
    }
    //return;    
}

function SetupExitAnim(@NULL obj)
{
    local @NULL temp_color, script;

    // End:0x33
    if(obj.IsA('UILabel'))
    {
        temp_color = UILabel(obj).mFontColor;        
    }
    else
    {
        temp_color.R = byte(255);
        temp_color.G = byte(255);
        temp_color.B = byte(255);
    }
    temp_color.A = byte(255);
    script = Class'TurokEngine.TurokUI'.static.AddScript(obj, "exit");
    // End:0x101
    if(script != none)
    {
        script.AddColorKey(0.0000000, temp_color);
        temp_color.A = 0;
        script.AddColorKey(0.1000000, temp_color);
    }
    //return;    
}

// Export UTurokFEMultiplayerScreen::execRefreshGameSettings(FFrame&, void* const)
protected native function RefreshGameSettings();

// Export UTurokFEMultiplayerScreen::execRefreshPlayerInfo(FFrame&, void* const)
protected native function RefreshPlayerInfo();

// Export UTurokFEMultiplayerScreen::execGoBackScreen(FFrame&, void* const)
protected native function GoBackScreen();

// Export UTurokFEMultiplayerScreen::execShowGamercard(FFrame&, void* const)
protected native function ShowGamercard(const @NULL Player);

// Export UTurokFEMultiplayerScreen::execShowPlayerFeedbackUI(FFrame&, void* const)
protected native function ShowPlayerFeedbackUI(const @NULL UniqueId);

// Export UTurokFEMultiplayerScreen::execHasValidGameSession(FFrame&, void* const)
protected native function bool HasValidGameSession();

// Export UTurokFEMultiplayerScreen::execGetMatchTypeHash(FFrame&, void* const)
protected native function int GetMatchTypeHash();

// Export UTurokFEMultiplayerScreen::execSetBackground(FFrame&, void* const)
protected native function bool SetBackground();

// Export UTurokFEMultiplayerScreen::execOnLoadImagesComplete(FFrame&, void* const)
protected native function OnLoadImagesComplete();

// Export UTurokFEMultiplayerScreen::execHasImageLoadsPending(FFrame&, void* const)
protected native function bool HasImageLoadsPending();

// Export UTurokFEMultiplayerScreen::execLoadBegin(FFrame&, void* const)
protected native function LoadBegin();

// Export UTurokFEMultiplayerScreen::execLoadEnd(FFrame&, void* const)
protected native function LoadEnd();

defaultproperties
{
    mFEMultiplayerMusicVolume=0.5000000
}