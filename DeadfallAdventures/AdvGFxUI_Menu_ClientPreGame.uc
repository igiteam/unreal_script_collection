class AdvGFxUI_Menu_ClientPreGame extends AdvGFxUI_Menu_Base
    config(UI);

const GS_USERNAME_MAXLENGTH = 15;
const GS_PASSWORD_MAXLENGTH = 30;
const GS_MESSAGE_MAXLENGTH = 255;
const GS_EMAIL_MAXLENGTH = 50;
const GS_CDKEY_PART_MAXLENGTH = 4;
const CONTEXT_GAME_MODE = 0x0000800B;
const CONTEXT_BOTSKILL = 30;
const CONTEXT_MAPNAME = 31;
const CONTEXT_PURESERVER = 36;
const CONTEXT_LOCKEDSERVER = 37;
const CONTEXT_VSBOTS = 38;
const CONTEXT_CAMPAIGN = 39;
const CONTEXT_FORCERESPAWN = 40;
const CONTEXT_ALLOWKEYBOARD = 41;
const CONTEXT_FULLSERVER = 42;
const CONTEXT_EMPTYSERVER = 43;
const CONTEXT_DEDICATEDSERVER = 44;
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
const CONTEXT_QUICKSEARCH_NO = 0;
const CONTEXT_QUICKSEARCH_YES = 1;
const CONTEXT_QUICKSEARCH_ANY = 2;
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
const PROPERTY_ROUNDSTOWIN = 0x100000FA;
const PROPERTY_SCOREFORWIN = 0x100000FB;
const PROPERTY_XPFORWIN = 0x100000FC;
const PROPERTY_ADVERTISEDMAPNAME = 0x100000FD;
const PROPERTY_LEADERBOARDRATING = 0x20000004;
const PROPERTY_EPICMUTATORS = 0x10000105;
const PROPERTY_CUSTOMMAPNAME = 0x40000001;
const PROPERTY_CUSTOMGAMEMODE = 0x40000002;
const PROPERTY_SERVERDESCRIPTION = 0x40000003;
const PROPERTY_CUSTOMMUTATORS = 0x40000004;
const PROPERTY_JIP_ALLOWED = 0x40000005;
const QUERY_DM = 0;
const QUERY_TDM = 1;
const QUERY_CTF = 2;
const QUERY_SV = 3;
const QUERY_CUSTOM = 4;
const QUERY_QUICK = 5;
const STATS_VIEW_DM_PLAYER_ALLTIME = 1;
const STATS_VIEW_DM_RANKED_ALLTIME = 2;
const STATS_VIEW_DM_WEAPONS_ALLTIME = 3;
const STATS_VIEW_DM_VEHICLES_ALLTIME = 4;
const STATS_VIEW_DM_VEHICLEWEAPONS_ALLTIME = 5;
const STATS_VIEW_DM_VEHICLES_RANKED_ALLTIME = 6;
const STATS_VIEW_DM_VEHICLEWEAPONS_RANKED_ALLTIME = 7;
const STATS_VIEW_DM_WEAPONS_RANKED_ALLTIME = 8;
const PROPERTY_PLAYLISTID = 0x1000000B;
const PROPERTY_DATACENTERID = 0x1000001F;
const PROPERTY_PLAYLISTMANAGERVERSION = 0x10000020;
const PROPERTY_GAMERLOCALE = 0x1000009E;
const PROPERTY_MATCHXPLEVEL = 0x1000009F;
const CONTEXT_GAME_MODE_VERSUS_LOADBALANCE1 = 13;
const CONTEXT_GAME_MODE_VERSUS_LOADBALANCE2 = 14;
const CONTEXT_GAME_MODE_VERSUS_LOADBALANCE3 = 15;
const CONTEXT_GAME_MODE_VERSUS_LOADBALANCE4 = 16;
const CONTEXT_GAME_MODE_VERSUS_LOADBALANCE5 = 17;
const CONTEXT_GAME_MODE_VERSUS_LOADBALANCE6 = 18;
const CONTEXT_GAME_MODE_VERSUS_LOADBALANCE7 = 19;
const CONTEXT_GAME_MODE_VERSUS_LOADBALANCE8 = 20;
const CONTEXT_PARTYSLOT_BLOCKED = 0;
const CONTEXT_PARTYSLOT_WANTS = 1;
const CONTEXT_PARTYSLOT_NEEDS = 2;
const CONTEXT_PARTYSLOT_ANY = 3;
const CONTEXT_PARTYSLOT_1 = 2;
const CONTEXT_PARTYSLOT_2 = 3;
const CONTEXT_PARTYSLOT_3 = 4;
const CONTEXT_PARTYSLOT_4 = 5;
const CONTEXT_PARTYSLOT_5 = 6;
const CONTEXT_MODULOSTEP = 12;
const CONTEXT_MODULOSTEP_MODULOSTEP = 0;
const CONTEXT_MODULOSTEP_MODULOSTEP_1 = 1;
const CONTEXT_MODULOSTEP_MODULOSTEP_2 = 2;
const CONTEXT_MODULOSTEP_MODULOSTEP_3 = 3;
const CONTEXT_MODULOSTEP_MODULOSTEP_4 = 4;
const CONTEXT_MODULOSTEP_MODULOSTEP_5 = 5;
const CONTEXT_MODULOSTEP_MODULOSTEP_6 = 6;
const CONTEXT_MODULOSTEP_MODULOSTEP_7 = 7;
const CONTEXT_MODULOSTEP_MODULOSTEP_8 = 8;
const CONTEXT_MODULOSTEP_MODULOSTEP_9 = 9;
const CONTEXT_MODULOSTEP_MODULOSTEP_ANY = 10;
const MAX_PLAYER_SLOTS = 16;

var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject HostStatusMC;
var GFxObject MapInfoMC;
var GFxObject TitleTF;
var GFxObject SubtitleTF;
var GFxClikWidget BackBtn;
var GFxClikWidget ClassBtn;
var GFxClikWidget SkipBtn;
var GFxClikWidget SkinBtn;
var GFxClikWidget MuteBtn;
var GFxClikWidget KickBtn;
var GFxClikWidget MapImage;
var GFxObject PartyLeaderStatusTF;
var GFxObject PlayersTF;
var const localized string TitleString;
var const localized string WaitForHostString;
var const localized string PartyLeaderStatusString;
var const localized string MapName;
var const localized string Players;
var string GameType;
var string HostName;
var GFxObject PlayerSlots[16];
var transient AdvPartyGRI GRI;
var bool bInitializedGRI;
var GFxObject VoteMC;

function bool Start(optional bool StartPaused = false)
{
    local int I;

    // End:0x68
    if(AdvLocalPlayer(GetLP()).bRestoreUsingGamepad)
    {
        GetPC().PlayerInput.bUsingGamepad = true;
    }
    super.Start(StartPaused);
    Advance(0.0000000);
    ButtonsMC = MenuMC.GetObject("buttons");
    TitleMC = MenuMC.GetObject("title");
    HostStatusMC = ButtonsMC.GetObject("hostStatusMC");
    MapInfoMC = ButtonsMC.GetObject("mapInfoMC");
    TitleTF = TitleMC.GetObject("textField");
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    ClassBtn = GFxClikWidget(ButtonsMC.GetObject("class_btn", Class'GFxUI.GFxClikWidget'));
    SkipBtn = GFxClikWidget(ButtonsMC.GetObject("skip_btn", Class'GFxUI.GFxClikWidget'));
    SkinBtn = GFxClikWidget(ButtonsMC.GetObject("skin_btn", Class'GFxUI.GFxClikWidget'));
    MuteBtn = GFxClikWidget(ButtonsMC.GetObject("mute_btn", Class'GFxUI.GFxClikWidget'));
    KickBtn = GFxClikWidget(ButtonsMC.GetObject("kick_btn", Class'GFxUI.GFxClikWidget'));
    MapImage = GFxClikWidget(ButtonsMC.GetObject("mapgfx", Class'GFxUI.GFxClikWidget'));
    PlayersTF = HostStatusMC.GetObject("playersnumber").GetObject("textField");
    PartyLeaderStatusTF = ButtonsMC.GetObject("timetostart").GetObject("textField");
    SubtitleTF = ButtonsMC.GetObject("subtitleTF");
    VoteMC = ButtonsMC.GetObject("votekickMC");
    VoteMC.SetVisible(false);
    MapInfoMC.SetVisible(false);
    I = 0;
    J0x4DE:

    // End:0x5FA [Loop If]
    if(I < 16)
    {
        PlayerSlots[I] = ButtonsMC.GetObject("playersMC").GetObject("player" $ string(I + 1));
        GFxClikWidget(PlayerSlots[I].GetObject("playerbtn", Class'GFxUI.GFxClikWidget')).SetBool("visible", false);
        PlayerSlots[I].SetVisible(false);
        I++;
        // [Loop Continue]
        goto J0x4DE;
    }
    TitleTF.SetText(TitleString);
    SkipBtn.SetString("label", " ");
    SkipBtn.SetBool("visible", false);
    ClassBtn.SetBool("visible", false);
    ClassBtn.SetString("label", Class'AdvGFxUI_Menu_MultiMenu'.default.SettingsString);
    SkinBtn.SetString("label", Class'AdvGFxUI_Menu_MultiMenu'.default.SkinString);
    SkinBtn.SetBool("focused", true);
    MuteBtn.SetBool("visible", false);
    KickBtn.SetBool("visible", false);
    BackBtn.SetString("label", back);
    // End:0x865
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        BackBtn.SetBool("visible", false);
    }
    PlayersTF.SetText(WaitForHostString);
    PartyLeaderStatusTF.SetText(PartyLeaderStatusString);
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    InitializeGRI();
    return true;
    //return ReturnValue;    
}

function UpdateFooter()
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericBack');    
    AddNATStatus(ButtonAliases);
    Frontend.footer.FooterUpdate(ButtonAliases);
    //return;    
}

function InitializeGRI()
{
    GRI = AdvPartyGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    // End:0x1C9
    if(GRI != none)
    {
        GRI.__OnMatchMakingStateChanged__Delegate = MatchMakingStateChanged;
        bInitializedGRI = true;
        // End:0x143
        if(!GRI.bSurvival)
        {
            ClassBtn.SetBool("visible", true);
            SubtitleTF.SetText(Localize("AdvGFxUI_Menu_MultiMenuGametype", "TitleString", "ADVGame"));            
        }
        else
        {
            SubtitleTF.SetText(Localize("AdvGFxUI_Menu_MultiSurvival", "TitleString", "ADVGame"));
        }
        PartyLeaderStatusTF.SetText(PartyLeaderStatusString);
    }
    //return;    
}

function Tick(float DeltaTime)
{
    // End:0x19
    if(!bInitializedGRI)
    {
        InitializeGRI();
    }
    super.Tick(DeltaTime);
    //return;    
}

function OnMute(EventData ev)
{
    //return;    
}

function OnKick(EventData ev)
{
    //return;    
}

function OnBack(EventData ev)
{
    OnLeaveGame();
    //return;    
}

function OnSkipBtn(EventData ev)
{
    //return;    
}

function OnSkin(EventData ev)
{
    Action = "skin";
    PlayCloseAnimation();
    //return;    
}

function OnClassBtn(EventData ev)
{
    Action = "settings";
    PlayCloseAnimation();
    //return;    
}

function bool ReturnToMultiMenu(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    Frontend.OpenMultiMenuGametypeScreen();
    Frontend.CloseGameSearchScreen();
    return true;
    //return ReturnValue;    
}

function OnCloseAnimationComplete()
{
    local bool bTransitionResult;

    switch(Action)
    {
        // End:0x98
        case "skin":
            // End:0x6B
            if(GRI.bSurvival)
            {
                bTransitionResult = Frontend.OpenSurvivalSkinScreen();                
            }
            else
            {
                bTransitionResult = Frontend.OpenMultiPlayerSkinScreen();
            }
            // End:0xD8
            break;
        // End:0xD2
        case "settings":
            bTransitionResult = Frontend.OpenMultiPlayerSettingsScreen();
            // End:0xD8
            break;
        // End:0xFFFF
        default:
            // End:0xD8
            break;
            break;
    }
    // End:0x10E
    if(bTransitionResult)
    {
        AdvFrontEndParty(Frontend).CloseClientLobbyScreen(true);
    }
    Action = "";
    //return;    
}

function OnLeaveGame()
{
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('AcceptLeave');    
    ButtonAliases.AddItem('CancelStay');    
    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    UIManager.ShowUIMessage('ConfirmQuit', "<Strings:ADVGame.MessageBoxStrings.LeavePartyLobby_Title>", "<Strings:ADVGame.MessageBoxStrings.LeavePartyLobby_MemberMessage>", ButtonAliases, OnLeaveLobby_Confirmed, GetLP());
    //return;    
}

function bool OnLeaveLobby_Confirmed(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0x4A
    if(SelectedInputAlias == 'AcceptLeave')
    {
        LeaveMatch();
        AdvFrontEndParty(Frontend).CloseClientLobbyScreen();
    }
    return true;
    //return ReturnValue;    
}

function LeaveMatch()
{
    local AdvPlayerController PC;

    PC = AdvPlayerController(GetPC());
    // End:0xA7
    if(int(PC.WorldInfo.NetMode) != int(NM_Client))
    {
        PC.WorldInfo.Game.TellClientsToReturnToPartyHost();        
    }
    else
    {
        PC.ClientReturnToMainMenu(false);
    }
    //return;    
}

function MatchMakingStateChanged()
{
    local string PartyLeaderStatus;

    switch(GRI.MatchmakingState)
    {
        // End:0x7C
        case 2:
            PartyLeaderStatus = Localize("LoadingScreenMessages", "PreparingSearchMessage", "ADVGame");
            // End:0x2F0
            break;
        // End:0xD4
        case 3:
            PartyLeaderStatus = Localize("LoadingScreenMessages", "SearchBestDedicatedMessage", "ADVGame");
            // End:0x2F0
            break;
        // End:0x12B
        case 4:
            PartyLeaderStatus = Localize("LoadingScreenMessages", "SearchAnyDedicatedMessage", "ADVGame");
            // End:0x2F0
            break;
        // End:0x184
        case 5:
            PartyLeaderStatus = Localize("LoadingScreenMessages", "SearchEmptyDedicatedMessage", "ADVGame");
            // End:0x2F0
            break;
        // End:0x1D8
        case 6:
            PartyLeaderStatus = Localize("LoadingScreenMessages", "SearchBestPartyMessage", "ADVGame");
            // End:0x2F0
            break;
        // End:0x22B
        case 7:
            PartyLeaderStatus = Localize("LoadingScreenMessages", "SearchAnyPartyMessage", "ADVGame");
            // End:0x2F0
            break;
        // End:0x281
        case 8:
            PartyLeaderStatus = Localize("LoadingScreenMessages", "ConnectingToMatchMessage", "ADVGame");
            // End:0x2F0
            break;
        // End:0x2D7
        case 9:
            PartyLeaderStatus = Localize("LoadingScreenMessages", "ConnectingToLobbyMessage", "ADVGame");
            // End:0x2F0
            break;
        // End:0xFFFF
        default:
            PartyLeaderStatus = PartyLeaderStatusString;
            // End:0x2F0
            break;
            break;
    }
    PlayersTF.SetText(PartyLeaderStatus);
    //return;    
}

defaultproperties
{
    TitleString="Party lobby"
    WaitForHostString="Choosing a game mode..."
    PartyLeaderStatusString="Party leader status:"
    bCanOpenPartyMenu=true
    bDisplayPartyWindow=true
    MovieInfoPath="UI_AdvUI.AdvGameSearch"
}