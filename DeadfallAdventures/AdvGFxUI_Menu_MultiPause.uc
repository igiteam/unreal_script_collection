class AdvGFxUI_Menu_MultiPause extends AdvGFxUI_PauseMenu
    config(UI);

var GFxObject ButtonsMC;
var GFxObject MenuMC;
var GFxObject TimeNumberTF;
var GFxObject AdvScoreTF;
var GFxObject MercScoreTF;
var const localized string ChangeClassStr;
var const localized string ChangeTeamStr;
var const localized string OptionsStr;
var const localized string ExitStr;
var const localized string TitleStr;
var const localized string ScoreLimitStr;
var const localized string TimeRemainingStr;
var const localized string AdvStr;
var const localized string MercStr;
var const localized string MiddleStr;
var const localized string Middle2Str;
var const localized string TeamChangeHeader;
var const localized string TeamChangeSuccess;
var const localized string TeamChangeFailure;
var GFxObject UILoader;
var GFxClikWidget ChangeClassBtn;
var GFxClikWidget ChangeTeamBtn;
var GFxClikWidget OptionsBtn;
var GFxClikWidget MuteBtn;
var GFxClikWidget KickBtn;
var GFxClikWidget ExitBtn;
var string MapImage;
var bool bOpenClassSelectionMenuOnClose;
var int LastRemainingTime;
var int LastTeamScore[2];
var GameReplicationInfo GRI;

function PlayOpenAnimation()
{
    local EvilLocalPlayer ELP;
    local WorldInfo WI;

    MenuMC.GotoAndPlay("open");
    // End:0x114
    if(!bIsMenuPPOverrideOn)
    {
        ELP = EvilLocalPlayer(GetLP());
        WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
        // End:0x114
        if(ELP != none)
        {
            ELP.SetMenuOverride(true, 0.4000000, (WI.Game != none) && WI.Game.bPauseable);
            bIsMenuPPOverrideOn = true;
        }
    }
    //return;    
}

function PlayCloseAnimation()
{
    local EvilLocalPlayer ELP;
    local WorldInfo WI;

    // End:0x0F
    if(bIsPlayingCloseAnimation)
    {
        return;
    }
    bIsPlayingCloseAnimation = true;
    MenuMC.GotoAndPlay("close");
    // End:0x13F
    if(!bTemporarilyHidden && bIsMenuPPOverrideOn)
    {
        ELP = EvilLocalPlayer(GetLP());
        WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
        // End:0x13F
        if(ELP != none)
        {
            ELP.SetMenuOverride(false, 0.4000000, (WI.Game != none) && WI.Game.bPauseable);
            bIsMenuPPOverrideOn = false;
        }
    }
    //return;    
}

function bool Start(optional bool StartPaused = false)
{
    local int I;
    local string MapName;
    local GFxObject MultiplayerMC, GameModeMC, TitleMC, TextField, StaticticsMC, ScoreTF,
	    TimeTF, ScoreNumberTF, MiddleMC, Middle2MC, CenterMC,
	    AdvMC, MercMC, AdvScoreMC, MercScoreMC, MapNameMC;

    local array<UDKUIResourceDataProvider> ProviderList;
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;

    super(GFxMoviePlayer).Start();
    Advance(0.0000000);
    GRI = GetPC().WorldInfo.GRI;
    RootMC = GetVariableObject("_root");
    MenuMC = RootMC.GetObject("menu");
    ButtonsMC = MenuMC.GetObject("buttons");
    CenterMC = MenuMC.GetObject("centerMC");
    TitleMC = MenuMC.GetObject("titleMC");
    MultiplayerMC = TitleMC.GetObject("multiplayerMC");
    GameModeMC = TitleMC.GetObject("gamemodeMC");
    TextField = MultiplayerMC.GetObject("textField");
    TextField.SetText(TitleStr);
    TextField = GameModeMC.GetObject("textField");
    TextField.SetText(Class'AdvGFxUI_Menu_MultiServers'.static.GetLocalizedGameType(string(GRI.GameClass.default.Class)));
    KursorMC = RootMC.GetObject("kursor");
    // End:0x382
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        KursorMC.SetVisible(false);
        bIgnoreMouseInput = true;        
    }
    else
    {
        KursorMC.SetVisible(EvilGFxHudWrapper(GetPC().myHUD).bShowCursor);
        bIgnoreMouseInput = !EvilGFxHudWrapper(GetPC().myHUD).bShowCursor;
    }
    StaticticsMC = MenuMC.GetObject("statisticsMC");
    ScoreTF = StaticticsMC.GetObject("scoreTF");
    TimeTF = StaticticsMC.GetObject("timeTF");
    ScoreNumberTF = StaticticsMC.GetObject("scorenumbersTF");
    TimeNumberTF = StaticticsMC.GetObject("timenumbersTF");
    ScoreTF.SetText(ScoreLimitStr);
    TimeTF.SetText(TimeRemainingStr);
    ScoreNumberTF.SetText(string(GRI.GoalScore));
    TimeNumberTF.SetText(Class'AdvGFxUI_Scoreboard'.static.FormatTime(GRI.RemainingTime));
    AdvMC = CenterMC.GetObject("adventurersMC");
    MercMC = CenterMC.GetObject("merceneriesMC");
    AdvScoreMC = CenterMC.GetObject("merceneriesScoreMC");
    MercScoreMC = CenterMC.GetObject("adventurersScoreMC");
    MiddleMC = CenterMC.GetObject("middleMC");
    Middle2MC = CenterMC.GetObject("middle2MC");
    // End:0x844
    if(class<AdvGameCTFBase>(GRI.GameClass) != none)
    {
        LastTeamScore[0] = AdvTeamInfo(GRI.Teams[0]).CapturedFlags;
        LastTeamScore[1] = AdvTeamInfo(GRI.Teams[1]).CapturedFlags;        
    }
    else
    {
        LastTeamScore[0] = int(GRI.Teams[0].Score);
        LastTeamScore[1] = int(GRI.Teams[1].Score);
    }
    ChangeClassBtn = GFxClikWidget(ButtonsMC.GetObject("changeclass_btn", Class'GFxUI.GFxClikWidget'));
    ChangeTeamBtn = GFxClikWidget(ButtonsMC.GetObject("changeteam_btn", Class'GFxUI.GFxClikWidget'));
    OptionsBtn = GFxClikWidget(ButtonsMC.GetObject("options_btn", Class'GFxUI.GFxClikWidget'));
    MuteBtn = GFxClikWidget(ButtonsMC.GetObject("mute_btn", Class'GFxUI.GFxClikWidget'));
    KickBtn = GFxClikWidget(ButtonsMC.GetObject("kick_btn", Class'GFxUI.GFxClikWidget'));
    ExitBtn = GFxClikWidget(ButtonsMC.GetObject("exit_btn", Class'GFxUI.GFxClikWidget'));
    KickBtn.SetBool("visible", false);
    // End:0xB9D
    if((AdvGRI(GRI) != none) && AdvGRI(GRI).IsPrivateCustomGame())
    {
        // End:0xB71
        if(int(GRI.Role) == int(ROLE_Authority))
        {
            MuteBtn.SetString("label", "<Strings:ADVGame.AdvGFxUI_Menu_PartyWindow.KickPlayer>");            
        }
        else
        {
            MuteBtn.SetBool("visible", false);
        }        
    }
    else
    {
        MuteBtn.SetString("label", "<Strings:ADVGame.AdvGFxUI_Menu_PartyWindow.VoteKickPlayer>");
    }
    ChangeClassBtn.SetString("label", ChangeClassStr);
    ChangeTeamBtn.SetString("label", ChangeTeamStr);
    OptionsBtn.SetString("label", OptionsStr);
    ExitBtn.SetString("label", Class'AdvGFxUI_Menu_MultiClassSelection'.default.ReturnToMenu);
    // End:0xD2C
    if(class<AdvGameSurvivalBase>(GRI.GameClass) != none)
    {
        ChangeClassBtn.SetBool("disabled", true);
    }
    // End:0x10E0
    if(class<AdvGameTeamDeathmatchBase>(GRI.GameClass) != none)
    {
        TextField = AdvMC.GetObject("textField");
        TextField.SetText(AdvStr);
        TextField = MercMC.GetObject("textField");
        TextField.SetText(MercStr);
        AdvScoreTF = AdvScoreMC.GetObject("textField");
        MercScoreTF = MercScoreMC.GetObject("textField");
        // End:0xF6F
        if(class<AdvGameCTFBase>(GRI.GameClass) != none)
        {
            AdvScoreTF.SetText(string(AdvTeamInfo(GRI.Teams[0]).CapturedFlags));
            MercScoreTF.SetText(string(AdvTeamInfo(GRI.Teams[1]).CapturedFlags));            
        }
        else
        {
            AdvScoreTF.SetText(string(int(GRI.Teams[0].Score)));
            MercScoreTF.SetText(string(int(GRI.Teams[1].Score)));
        }
        TextField = MiddleMC.GetObject("textField");
        TextField.SetText(MiddleStr);
        TextField = Middle2MC.GetObject("textField");
        TextField.SetText(Middle2Str);        
    }
    else
    {
        AdvMC.SetVisible(false);
        MercMC.SetVisible(false);
        AdvScoreMC.SetVisible(false);
        MercScoreMC.SetVisible(false);
        MiddleMC.SetVisible(false);
        Middle2MC.SetVisible(false);
        ChangeTeamBtn.SetBool("disabled", true);
    }
    // End:0x125C
    if(GetPC().WorldInfo.IsConsoleBuild(1) && AdvGRI(GetPC().WorldInfo.GRI).IsMultiplayerGame())
    {
    }
    ResetCaptureKeys();
    MapImage = "";
    Class'EvilGame.UTUIDataStore_MenuItems'.static.GetAllResourceDataProviders(Class'EvilGame.UTUIDataProvider_MapInfo', ProviderList);
    I = 0;
    J0x12AE:

    // End:0x13D8 [Loop If]
    if(I < ProviderList.Length)
    {
        // End:0x13CA
        if(GetPC().WorldInfo.GetMapName(true) == UTUIDataProvider_MapInfo(ProviderList[I]).MapName)
        {
            MapImage = UTUIDataProvider_MapInfo(ProviderList[I]).PreviewImageMarkup;
            MapName = Class'AdvGFxUI_Menu_MultiHost'.static.ConvertFriendlyNameToReadable(UTUIDataProvider_MapInfo(ProviderList[I]).FriendlyName);
            // [Explicit Break]
            goto J0x13D8;
        }
        I++;
        // [Loop Continue]
        goto J0x12AE;
    }
    J0x13D8:

    // End:0x140B
    if(MapImage == "")
    {
        MapImage = "UDKFrontEnd.gm_map_none";
    }
    UILoader = GFxClikWidget(CenterMC.GetObject("UILoader", Class'GFxUI.GFxClikWidget'));
    UILoader.SetBool("visible", true);
    UILoader.SetString("source", "img://" $ MapImage);
    MapNameMC = CenterMC.GetObject("mapnameMC");
    TextField = MapNameMC.GetObject("textField");
    TextField.SetText(MapName);
    // End:0x15C3
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        InitializeFooter();
        UpdateFooter();
    }
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x1695
    if(OnlineSub != none)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        // End:0x1695
        if(NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
        {
            PlayerInterface.AddWriteProfileSettingsCompleteDelegate(byte(GetLP().ControllerId), OnProfileWriteComplete);
        }
    }
    AdvGFxHudWrapper(GetPC().myHUD).SetVisible(false);
    return true;
    //return ReturnValue;    
}

function UpdateFooter()
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericSelect');    
    ButtonAliases.AddItem('GenericBack');    
    footer.FooterUpdate(ButtonAliases);
    //return;    
}

function InitializeFooter()
{
    // End:0x71
    if(footer == none)
    {
        footer = new Class'AdvGFxUI_Menu_Footer';
        footer.SetPriority(70);
        footer.Init(GetLP());
    }
    //return;    
}

function OnChangeClassBtn(EventData ev)
{
    bOpenClassSelectionMenuOnClose = true;
    PlayCloseAnimation();
    //return;    
}

function OnOptionsBtn(EventData ev)
{
    bOpenOptionsOnClose = true;
    bTemporarilyHidden = true;
    PlayCloseAnimation();
    //return;    
}

function OnExitBtn(EventData ev)
{
    local array<name> ButtonAliases;
    local string Header, Message;

    ButtonAliases.AddItem('GenericYes');    
    ButtonAliases.AddItem('GenericNo');    
    // End:0xA5
    if(int(GRI.Role) != int(ROLE_Authority))
    {
        Header = "ReturnToMainMenu_Header";
        Message = "ReturnToMainMenu_LeaderMessage";        
    }
    else
    {
        Header = "ReturnToMainMenu_Header";
        Message = "ReturnToMainMenu_Message";
    }
    Class'AdvUIManager'.static.ShowUIMessage('PauseOptionConfirm', Localize("MessageBoxStrings", Header, "ADVGame"), Localize("MessageBoxStrings", Message, "ADVGame"), ButtonAliases, OnExitOptionSelected, GetLP(),,,, false,,, true);
    //return;    
}

function bool OnExitOptionSelected(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local AdvPlayerController PC;

    // End:0x5D
    if(SelectedInputAlias == 'GenericYes')
    {
        PC = AdvPlayerController(GetPC());
        PC.ExitFromMPGame();
        PlayCloseAnimation();
    }
    return true;
    //return ReturnValue;    
}

function OnChangeTeamBtn(EventData ev)
{
    // End:0x56
    if(class<AdvGameTeamDeathmatchBase>(GRI.GameClass) != none)
    {
        AdvPlayerControllerMP(GetPC()).SubtleChangeTeam();
    }
    //return;    
}

function ShowChangeTeamMessage(bool ChangeSuccessful)
{
    local array<name> ButtonAliases;

    // End:0x8C
    if(ChangeSuccessful)
    {
        ButtonAliases.AddItem('GenericContinue');        
        Class'AdvUIManager'.static.ShowUIMessage('PauseOptionConfirm', TeamChangeHeader, TeamChangeSuccess, ButtonAliases, OnTeamChangeOptionSelected1, GetLP(),,,, false,,, true);        
    }
    else
    {
        ButtonAliases.AddItem('GenericContinue');        
        Class'AdvUIManager'.static.ShowUIMessage('PauseOptionConfirm', TeamChangeHeader, TeamChangeFailure, ButtonAliases, OnTeamChangeOptionSelected2, GetLP(),,,, false,,, true);
    }
    //return;    
}

function bool OnTeamChangeOptionSelected1(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    AdvPlayerControllerMP(GetPC()).AdvHudWrapper.SetVisibilityForPause(false);
    PlayCloseAnimation();
    return true;
    //return ReturnValue;    
}

function bool OnTeamChangeOptionSelected2(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    return true;
    //return ReturnValue;    
}

function OnMuteBtn(EventData ev)
{
    // End:0x55
    if((AdvGRI(GRI) != none) && AdvGRI(GRI).IsPrivateCustomGame())
    {
        ShowPlayersMenu(0, 2);        
    }
    else
    {
        ShowPlayersMenu(0, 1);
    }
    //return;    
}

function OnKickBtn(EventData ev)
{
    //return;    
}

function OnBack(EventData ev)
{
    AdvPlayerControllerMP(GetPC()).AdvHudWrapper.SetVisibilityForPause(false);
    PlayCloseAnimation();
    //return;    
}

function Tick(float DeltaTime)
{
    UILoader.SetString("source", "img://" $ MapImage);
    // End:0x113
    if(GRI.TimeLimit != 0)
    {
        // End:0x110
        if(LastRemainingTime != GRI.RemainingTime)
        {
            LastRemainingTime = GRI.RemainingTime;
            TimeNumberTF.SetText(Class'AdvGFxUI_Scoreboard'.static.FormatTime(GRI.RemainingTime));
        }        
    }
    else
    {
        TimeNumberTF.SetText("---");
    }
    // End:0x431
    if(class<AdvGameTeamDeathmatchBase>(GRI.GameClass) != none)
    {
        // End:0x2F1
        if(class<AdvGameCTFBase>(GRI.GameClass) != none)
        {
            // End:0x240
            if(LastTeamScore[0] != AdvTeamInfo(GRI.Teams[0]).CapturedFlags)
            {
                AdvScoreTF.SetText(string(AdvTeamInfo(GRI.Teams[0]).CapturedFlags));
            }
            // End:0x2EE
            if(LastTeamScore[1] != AdvTeamInfo(GRI.Teams[1]).CapturedFlags)
            {
                MercScoreTF.SetText(string(AdvTeamInfo(GRI.Teams[1]).CapturedFlags));
            }            
        }
        else
        {
            // End:0x391
            if(LastTeamScore[0] != int(GRI.Teams[0].Score))
            {
                AdvScoreTF.SetText(string(int(GRI.Teams[0].Score)));
            }
            // End:0x431
            if(LastTeamScore[1] != int(GRI.Teams[1].Score))
            {
                MercScoreTF.SetText(string(int(GRI.Teams[1].Score)));
            }
        }
    }
    super.Tick(DeltaTime);
    //return;    
}

function OnCloseAnimationComplete()
{
    local float X, Y;
    local AdvGFxHudWrapperMP HUDWrapper;

    HUDWrapper = AdvGFxHudWrapperMP(GetPC().myHUD);
    // End:0x24D
    if(bOpenClassSelectionMenuOnClose)
    {
        bOpenClassSelectionMenuOnClose = false;
        // End:0x107
        if(HUDWrapper.AdvClassSelectionMenuMovie == none)
        {
            HUDWrapper.AdvClassSelectionMenuMovie = new Class'AdvGFxUI_Menu_MultiClassSelection';
            HUDWrapper.AdvClassSelectionMenuMovie.SetTimingMode(1);
            HUDWrapper.AdvClassSelectionMenuMovie.ParentMenu = self;
        }
        // End:0x24A
        if(HUDWrapper.AdvClassSelectionMenuMovie != none)
        {
            HUDWrapper.AdvClassSelectionMenuMovie.bIsMenuPPOverrideOn = bIsMenuPPOverrideOn;
            HUDWrapper.AdvClassSelectionMenuMovie.ActivatePauseScene(GetLP());
            KursorMC.GetPosition(X, Y);
            HUDWrapper.AdvClassSelectionMenuMovie.KursorMC.SetPosition(X, Y);
            Close(false);
            ToggleHostPausedMessages(false);
        }        
    }
    else
    {
        // End:0x396
        if(bOpenOptionsOnClose)
        {
            bOpenOptionsOnClose = false;
            // End:0x2CE
            if(OptionsMenu == none)
            {
                OptionsMenu = new Class'AdvGFxUI_Menu_OptionsMenu';
                OptionsMenu.SetPriority(69);
                OptionsMenu.ParentMenu = self;
            }
            // End:0x393
            if(OptionsMenu != none)
            {
                OptionsMenu.Init(GetLP());
                KursorMC.GetPosition(X, Y);
                OptionsMenu.KursorMC.SetPosition(X, Y);
                Close(false);
                ToggleHostPausedMessages(false);
            }            
        }
        else
        {
            // End:0x3D1
            if(bTemporarilyHidden)
            {
                HUDWrapper.SetVisible(true);
                Close(false);                
            }
            else
            {
                HUDWrapper.SetVisible(true);
                Close(false);
            }
        }
    }
    //return;    
}

event OnClose()
{
    local EvilLocalPlayer ELP;
    local WorldInfo WI;

    super.OnClose();
    // End:0x108
    if(!bTemporarilyHidden && bIsMenuPPOverrideOn)
    {
        ELP = EvilLocalPlayer(GetLP());
        WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
        // End:0x108
        if(ELP != none)
        {
            ELP.SetMenuOverride(false, 0.0000000, (WI.Game != none) && WI.Game.bPauseable);
            bIsMenuPPOverrideOn = false;
        }
    }
    //return;    
}

defaultproperties
{
    ChangeClassStr="Change Class"
    ChangeTeamStr="Change Team"
    OptionsStr="Options"
    ExitStr="Exit"
    TitleStr="Multiplayer Pause Menu"
    ScoreLimitStr="Score Limit"
    TimeRemainingStr="Remaining Time"
    AdvStr="Adventurers"
    MercStr="Mercenaries"
    MiddleStr="vs"
    Middle2Str="-"
    TeamChangeHeader="Team change"
    TeamChangeSuccess="You will be moved to another team"
    TeamChangeFailure="You can't change team at the moment"
    MovieInfoPath="UI_AdvMultiplayerInGame.AdvMultiPause"
    MovieInfo=none
    bPauseGameWhileActive=false
}