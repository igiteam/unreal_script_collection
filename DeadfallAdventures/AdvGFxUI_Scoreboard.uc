class AdvGFxUI_Scoreboard extends AdvGfxMoviePlayer
    config(UI);

struct ScoreEntry
{
    var AdvPRI PRI;
    var string PlayerName;
    var int PlayerLevel;
    var int PlayerScore;
    var int PlayerKills;
    var int PlayerAssists;
    var int PlayerDeaths;
    var int PlayerPing;
    var bool bIsAlive;
    var bool bHasFlag;
    var bool bReady;
    var bool bTalking;
    var bool bMuted;
    var bool bHasDevastator;
    var bool bHasMummy;

    structdefaultproperties
    {
        PRI=none
        PlayerName=""
        PlayerLevel=-1
        PlayerScore=0
        PlayerKills=0
        PlayerAssists=0
        PlayerDeaths=0
        PlayerPing=-1
        bIsAlive=false
        bHasFlag=false
        bReady=false
        bTalking=true
        bMuted=false
        bHasDevastator=false
        bHasMummy=false
    }
};

struct ScoreboardState
{
    var int RemainingTime;
    var int RedScore;
    var int BlueScore;
    var string PlayerName;
    var byte PlayerPlace;
    var int PlayerLevel;
    var float PlayerScore;
    var int PlayerKills;
    var int PlayerAssists;
    var int PlayerDeaths;

    structdefaultproperties
    {
        RemainingTime=0
        RedScore=0
        BlueScore=0
        PlayerName=""
        PlayerPlace=0
        PlayerLevel=0
        PlayerScore=0.0000000
        PlayerKills=0
        PlayerAssists=0
        PlayerDeaths=0
    }
};

struct ScoreRow
{
    var GFxObject MovieClip;
    var GFxObject InnerMovieClip;
    var GFxObject LevelTF;
    var GFxObject LevelMC;
    var GFxObject DeathsTF;
    var GFxObject KillsTF;
    var GFxObject AssistsTF;
    var GFxObject ScoreTF;
    var GFxObject NameTF;
    var GFxObject PingMC;
    var GFxObject ReadyMC;
    var GFxObject SpeakerMC;
    var GFxClikWidget Button;

    structdefaultproperties
    {
        MovieClip=none
        InnerMovieClip=none
        LevelTF=none
        LevelMC=none
        DeathsTF=none
        KillsTF=none
        AssistsTF=none
        ScoreTF=none
        NameTF=none
        PingMC=none
        ReadyMC=none
        SpeakerMC=none
        Button=none
    }
};

var GFxObject RootMC;
var GFxObject ScoreboardMC;
var GFxObject OverlayMC;
var GFxObject TitleMC;
var GFxObject BlueTeamMC;
var GFxObject RedTeamMC;
var GFxObject RoundScoreMC;
var GFxObject TimeMC;
var GFxObject TimeLabelTF;
var GFxObject TimeTF;
var GFxObject Title_TitleGMC;
var GFxObject TitleTF;
var GFxObject TitleGMC;
var GFxObject RoundsTeam1MC;
var GFxObject RoundsTeam2MC;
var GFxObject RoundsScore1MC;
var GFxObject RoundsScore2MC;
var GFxObject ScoreLimitMC;
var GFxObject ScorelimitTF;
var GFxObject ScoreLimitN;
var GFxObject MaxRoundsMC;
var GFxObject MaxRoundsTF;
var GFxObject BlueHeaderMC;
var GFxObject BlueScoreTF;
var GFxObject BlueTitleTF;
var GFxObject RedHeaderMC;
var GFxObject RedScoreTF;
var GFxObject RedTitleTF;
var GFxObject BlueHeaderInfoMC;
var GFxObject BlueHeaderInfoPlayerTF;
var GFxObject BlueHeaderInfoScoreTF;
var GFxObject BlueHeaderInfoKillsTF;
var GFxObject BlueHeaderInfoAssistsTF;
var GFxObject BlueHeaderInfoDeathTF;
var GFxObject BlueHeaderInfoPingTF;
var GFxObject RedHeaderInfoMC;
var GFxObject RedHeaderInfoPlayerTF;
var GFxObject RedHeaderInfoScoreTF;
var GFxObject RedHeaderInfoKillsTF;
var GFxObject RedHeaderInfoAssistsTF;
var GFxObject RedHeaderInfoDeathTF;
var GFxObject RedHeaderInfoPingTF;
var GFxObject FooterMC;
var GFxObject FooterItemMC;
var GFxObject FooterItemTF;
var byte RedTeamIndex;
var byte BlueTeamIndex;
var GFxObject PlayerRow;
var bool bPlayerRowTween;
var bool bTeamGame;
var bool CurrentSelectedSlotIsRed;
var bool bInitialized;
var bool bInitialFocusSet;
var ScoreEntry RedEntries[16];
var ScoreEntry BlueEntries[8];
var int CurrentSelectedSlot;
var ScoreboardState PreviousState;
var array<ScoreRow> BlueItems;
var array<ScoreRow> RedItems;
var transient int NameCnt;
var GFxObject Footer_NameTF;
var GFxObject Footer_LevelTF;
var GFxObject Footer_LevelMC;
var GFxObject Footer_PlaceLabelTF;
var GFxObject Footer_PlaceTF;
var GFxObject Footer_ScoreLabelTF;
var GFxObject Footer_ScoreTF;
var GFxObject Footer_DeathsLabelTF;
var GFxObject Footer_DeathsTF;
var GFxObject Footer_KillsLabelTF;
var GFxObject Footer_KillsTF;
var GFxObject Footer_AssistsLabelTF;
var GFxObject Footer_AssistsTF;
var GFxObject Footer_Buttons;
var const localized string TimeLeft;
var const localized string ScoreLimitText;
var const localized string PlacementText;
var const localized string ScoreText;
var const localized string Kills;
var const localized string Assists;
var const localized string Deaths;
var const localized string Ping;
var const localized string Player;
var const localized string Players;
var const localized string RedTeamText;
var const localized string RedTeamShortText;
var const localized string BlueTeamText;
var const localized string BlueTeamShortText;
var const localized string BlueTeamRoundsText;
var const localized string RedTeamRoundsText;
var const localized string WinningText;
var const localized string LosingText;
var const localized string DrawText;
var const localized string MaxRoundsString;

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    local WorldInfo WI;
    local AdvPRI TargetPRI;

    // End:0x73
    if((AdvUIManager(Class'Engine.UIManager'.static.GetUIManager()) != none) && AdvUIManager(Class'Engine.UIManager'.static.GetUIManager()).IsAnyUIMessageActive())
    {
        return true;
    }
    // End:0xB8
    if((int(InputEvent) == int(2)) && !Class'AdvFrontEnd'.static.IsDirectionalInput(ButtonName))
    {
        return true;
    }
    // End:0x123
    if(GetPC().WorldInfo.IsConsoleBuild(0) && !Class'AdvFrontEnd'.static.IsGamepadKey(ButtonName))
    {
        return true;
    }
    WI = Class'Engine.Engine'.static.GetCurrentWorldInfo();
    // End:0x1CC
    if(((GetLP().ControllerId == ControllerId) && ButtonName == 'XboxTypeS_A') && int(InputEvent) == int(0))
    {
        // End:0x1CC
        if(WI.Game != none)
        {
        }
    }
    // End:0x20C
    if(CurrentSelectedSlotIsRed)
    {
        TargetPRI = RedEntries[CurrentSelectedSlot].PRI;        
    }
    else
    {
        TargetPRI = BlueEntries[CurrentSelectedSlot].PRI;
    }
    // End:0x44E
    if(GetPC().WorldInfo.IsConsoleBuild(0) && TargetPRI != none)
    {
        // End:0x44E
        if(((int(InputEvent) == int(0)) && ControllerId == GetLP().ControllerId) && Class'Engine.UIInteraction'.static.IsLoggedIn(GetLP().ControllerId))
        {
            // End:0x44E
            if((ButtonName == 'XboxTypeS_RightShoulder') || ButtonName == 'RightMouseButton')
            {
                // End:0x3DE
                if(Class'AdvGFxUI_Menu_PartyMenu'.static.CanVoteKickPlayer(TargetPRI) && GetPC().PlayerReplicationInfo != TargetPRI)
                {
                    Class'AdvGFxUI_Menu_PartyMenu'.static.VoteKickPlayer(TargetPRI, GetLP(), OnVoteKick_Confirmed);                    
                }
                else
                {
                    // End:0x44C
                    if(Class'AdvGFxUI_Menu_PartyMenu'.static.CanKickPlayer(TargetPRI))
                    {
                        Class'AdvGFxUI_Menu_PartyMenu'.static.KickPlayer(TargetPRI, GetLP(), OnKick_Confirmed);
                    }
                }
                return true;
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function bool Start(optional bool StartPaused = false)
{
    super(GFxMoviePlayer).Start();
    Advance(0.0000000);
    bInitialized = false;
    bInitialFocusSet = false;
    RootMC = GetVariableObject("_root");
    ScoreboardMC = RootMC.GetObject("scoreboard");
    RootMC.SetFloat("_xscale", 95.0000000);
    RootMC.SetFloat("_yscale", 95.0000000);
    TitleMC = ScoreboardMC.GetObject("title");
    MaxRoundsMC = TitleMC.GetObject("maxroundsMC");
    MaxRoundsTF = MaxRoundsMC.GetObject("maxroundsTF");
    Title_TitleGMC = TitleMC.GetObject("title_g");
    TitleTF = Title_TitleGMC.GetObject("textField");
    TimeMC = TitleMC.GetObject("time");
    TimeLabelTF = TimeMC.GetObject("label");
    TimeLabelTF.SetText(TimeLeft);
    TimeTF = TimeMC.GetObject("textField");
    ScoreLimitMC = TitleMC.GetObject("scorelimit");
    ScorelimitTF = ScoreLimitMC.GetObject("textField");
    ScoreLimitN = ScoreLimitMC.GetObject("limit");
    FooterMC = ScoreboardMC.GetObject("footer");
    FooterItemMC = FooterMC.GetObject("footer_item");
    FooterItemTF = FooterItemMC.GetObject("pressCos");
    Footer_Buttons = FooterItemMC.GetObject("buttons");
    PreviousState.PlayerLevel = -1;
    PreviousState.PlayerKills = -1;
    PreviousState.PlayerAssists = -1;
    PreviousState.PlayerDeaths = -1;
    PreviousState.PlayerScore = -1.0000000;
    PreviousState.PlayerPlace = 255;
    ConfigScoreboard();
    Draw();
    return true;
    //return ReturnValue;    
}

function PlayOpenAnimation()
{
    TitleMC.GotoAndPlay("open");
    FooterMC.GotoAndPlay("open");
    OverlayMC.GotoAndPlay("open");
    TrackChat(true);
    //return;    
}

function PlayCloseAnimation()
{
    TitleMC.GotoAndPlay("close");
    FooterMC.GotoAndPlay("close");
    OverlayMC.GotoAndPlay("close");
    //return;    
}

event OnClose()
{
    super(GFxMoviePlayer).OnClose();
    TrackChat(false);
    //return;    
}

function TrackChat(bool bTrack)
{
    // End:0x13A
    if((GetPC().OnlineSub != none) && NotEqual_InterfaceInterface(GetPC().OnlineSub.VoiceInterface, OnlineVoiceInterface(none)))
    {
        // End:0xDE
        if(bTrack)
        {
            GetPC().OnlineSub.VoiceInterface.AddPlayerTalkingDelegate(OnPlayerTalking);            
        }
        else
        {
            GetPC().OnlineSub.VoiceInterface.ClearPlayerTalkingDelegate(OnPlayerTalking);
        }
    }
    //return;    
}

function OnPlayerTalking(UniqueNetId TalkingPlayer, bool bIsTalking)
{
    local AdvPRI TalkerPRI;

    TalkerPRI = ResolveUniqueNetID(TalkingPlayer);
    // End:0xA9
    if(TalkerPRI != none)
    {
        TalkerPRI.bIsTalking = bIsTalking;
        TalkerPRI.LastTalkTime = Class'Engine.WorldInfo'.static.GetWorldInfo().RealTimeSeconds;
    }
    //return;    
}

function AdvPRI ResolveUniqueNetID(UniqueNetId TestID)
{
    local AdvGRI GRI;
    local int I;

    GRI = AdvGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    // End:0x150
    if(GRI != none)
    {
        I = 0;
        J0x61:

        // End:0x150 [Loop If]
        if(I < GRI.PRIArray.Length)
        {
            // End:0x142
            if((GRI.PRIArray[I] != none) && GRI.PRIArray[I].UniqueId == TestID)
            {
                return AdvPRI(GRI.PRIArray[I]);
            }
            I++;
            // [Loop Continue]
            goto J0x61;
        }
    }
    return none;
    //return ReturnValue;    
}

function ConfigScoreboard()
{
    local AdvGRI GRI;
    local PlayerController PC;

    PC = GetPC();
    // End:0x31D
    if(PC != none)
    {
        GRI = AdvGRI(PC.WorldInfo.GRI);
        // End:0x2F0
        if(GRI != none)
        {
            bTeamGame = GRI.IsTeamMultiPlayerGame();
            // End:0x1A6
            if(bTeamGame)
            {
                ScoreboardMC.GotoAndStop("tdm");
                OverlayMC = ScoreboardMC.GetObject("team");
                BlueTeamMC = OverlayMC.GetObject("blue_team");
                RedTeamMC = OverlayMC.GetObject("red_team");
                RoundScoreMC = OverlayMC.GetObject("scoreTeamMC");                
            }
            else
            {
                ScoreboardMC.GotoAndStop("dm");
                OverlayMC = ScoreboardMC.GetObject("dm");
                RedTeamMC = ScoreboardMC.GetObject("dm");
                RoundScoreMC = ScoreboardMC.GetObject("team").GetObject("scoreTeamMC");
            }
            TitleTF.SetText(Class'AdvGFxUI_Menu_MultiServers'.static.GetLocalizedGameType(string(GRI.GameClass.default.Class)));            
        }
        else
        {
            TitleTF.SetText("      ");
            return;
        }        
    }
    else
    {
        return;
    }
    SetupRedTeam();
    // End:0x417
    if(((class<AdvGameLastMenStandingBase>(GRI.GameClass) == none) && class<AdvGameCTFBase>(GRI.GameClass) == none) && !GRI.IsSurvivalGame())
    {
        ScorelimitTF.SetText(ScoreLimitText);
        ScoreLimitN.SetText(string(GRI.GoalScore));        
    }
    else
    {
        ScorelimitTF.SetText("");
        ScoreLimitN.SetText("");
    }
    // End:0x47F
    if(bTeamGame)
    {
        SetupBlueTeam();
        SetupRoundsInfo();        
    }
    else
    {
        MaxRoundsTF.SetVisible(false);
    }
    // End:0x4E6
    if(((PC != none) && GRI != none) && !bInitialized)
    {
        PlayOpenAnimation();
        bInitialized = true;
    }
    //return;    
}

function SetupRoundsInfo()
{
    local GFxObject BlueRoundScoreTF, BlueRoundTitleTF, RedRoundScoreTF, RedRoundTitleTF;
    local AdvGRI GRI;

    GRI = AdvGRI(GetPC().WorldInfo.GRI);
    BlueRoundScoreTF = BlueHeaderMC.GetObject("score").GetObject("textField");
    BlueRoundTitleTF = BlueHeaderMC.GetObject("title").GetObject("textField");
    RedRoundScoreTF = RedHeaderMC.GetObject("score").GetObject("textField");
    RedRoundTitleTF = RedHeaderMC.GetObject("title").GetObject("textField");
    // End:0x49A
    if(GRI.RoundsToWin > 1)
    {
        // End:0x2A1
        if((class<AdvGameLastMenStandingBase>(GRI.GameClass) != none) || class<AdvGameCTFBase>(GRI.GameClass) != none)
        {
            ScorelimitTF.SetText(MaxRoundsString);
            ScoreLimitN.SetText(string(GRI.RoundsToWin));
            MaxRoundsTF.SetText("");            
        }
        else
        {
            MaxRoundsTF.SetText((MaxRoundsString @ " ") @ string(GRI.RoundsToWin));
        }
        BlueRoundScoreTF.SetVisible(true);
        BlueRoundTitleTF.SetVisible(true);
        RedRoundScoreTF.SetVisible(true);
        RedRoundTitleTF.SetVisible(true);
        BlueRoundScoreTF.SetText(string(AdvTeamInfo(GRI.Teams[int(BlueTeamIndex)]).RoundScore));
        BlueRoundTitleTF.SetText(BlueTeamRoundsText);
        RedRoundScoreTF.SetText(string(AdvTeamInfo(GRI.Teams[int(RedTeamIndex)]).RoundScore));
        RedRoundTitleTF.SetText(RedTeamRoundsText);        
    }
    else
    {
        MaxRoundsTF.SetVisible(false);
        BlueRoundScoreTF.SetVisible(false);
        BlueRoundTitleTF.SetVisible(false);
        RedRoundScoreTF.SetVisible(false);
        RedRoundTitleTF.SetVisible(false);
        BlueHeaderMC.GetObject("header1").SetVisible(false);
        RedHeaderMC.GetObject("header1").SetVisible(false);
    }
    //return;    
}

function SetupBlueTeam()
{
    local byte I;
    local ScoreRow sr;
    local ASDisplayInfo DI;
    local AdvGRI GRI;

    GRI = AdvGRI(GetPC().WorldInfo.GRI);
    I = 0;
    J0x53:

    // End:0x970 [Loop If]
    if(int(I) < int(8))
    {
        BlueItems[int(I)] = sr;
        BlueItems[int(I)].MovieClip = BlueTeamMC.GetObject("item" $ string(int(I) + int(1)));
        // End:0x11A
        if(BlueItems[int(I)].MovieClip == none)
        {
            return;
        }
        DI = BlueItems[int(I)].MovieClip.GetDisplayInfo();
        DI.Alpha = 100.0000000;
        BlueItems[int(I)].MovieClip.SetDisplayInfo(DI);
        BlueItems[int(I)].InnerMovieClip = BlueItems[int(I)].MovieClip.GetObject("item_g");
        // End:0x26C
        if(BlueItems[int(I)].InnerMovieClip == none)
        {            
        }
        else
        {
            BlueItems[int(I)].LevelTF = BlueItems[int(I)].InnerMovieClip.GetObject("levelMC").GetObject("levelTF");
            BlueItems[int(I)].LevelMC = BlueItems[int(I)].InnerMovieClip.GetObject("levelMC").GetObject("UILoader");
            BlueItems[int(I)].KillsTF = BlueItems[int(I)].InnerMovieClip.GetObject("kills");
            BlueItems[int(I)].AssistsTF = BlueItems[int(I)].InnerMovieClip.GetObject("assists");
            BlueItems[int(I)].DeathsTF = BlueItems[int(I)].InnerMovieClip.GetObject("deaths");
            BlueItems[int(I)].ScoreTF = BlueItems[int(I)].InnerMovieClip.GetObject("score");
            BlueItems[int(I)].NameTF = BlueItems[int(I)].InnerMovieClip.GetObject("name");
            BlueItems[int(I)].PingMC = BlueItems[int(I)].InnerMovieClip.GetObject("pingMC");
            BlueItems[int(I)].ReadyMC = BlueItems[int(I)].InnerMovieClip.GetObject("ready");
            BlueItems[int(I)].SpeakerMC = BlueItems[int(I)].InnerMovieClip.GetObject("speaker");
            // End:0x818
            if(Class'Core.Object'.static.GetLanguage() ~= "JPN")
            {
                BlueItems[int(I)].NameTF.SetInt("_width", 640);
                BlueItems[int(I)].NameTF.SetFloat("_xscale", 75.0000000);
                BlueItems[int(I)].NameTF.SetFloat("_yscale", 75.0000000);
            }
            BlueItems[int(I)].Button = GFxClikWidget(BlueItems[int(I)].InnerMovieClip.GetObject("Button", Class'GFxUI.GFxClikWidget'));
            // End:0x91D
            if(!GetPC().WorldInfo.IsConsoleBuild(0))
            {
                BlueItems[int(I)].Button.SetBool("visible", false);
            }
            BlueItems[int(I)].NameTF.SetBool("html", true);
        }
        I++;
        // [Loop Continue]
        goto J0x53;
    }
    BlueHeaderMC = BlueTeamMC.GetObject("header");
    BlueHeaderInfoMC = BlueHeaderMC.GetObject("headerinfo");
    BlueHeaderInfoPlayerTF = BlueHeaderInfoMC.GetObject("playername").GetObject("textField");
    BlueHeaderInfoScoreTF = BlueHeaderInfoMC.GetObject("playerscore").GetObject("textField");
    BlueHeaderInfoKillsTF = BlueHeaderInfoMC.GetObject("playerkills").GetObject("textField");
    BlueHeaderInfoAssistsTF = BlueHeaderInfoMC.GetObject("playerassists").GetObject("textField");
    BlueHeaderInfoDeathTF = BlueHeaderInfoMC.GetObject("playerdeaths").GetObject("textField");
    BlueHeaderInfoPingTF = BlueHeaderInfoMC.GetObject("playerping").GetObject("textField");
    BlueHeaderInfoPlayerTF.SetText(Player);
    BlueHeaderInfoScoreTF.SetText(ScoreText);
    BlueHeaderInfoKillsTF.SetText(Kills);
    BlueHeaderInfoAssistsTF.SetText(Assists);
    BlueHeaderInfoDeathTF.SetText(Deaths);
    BlueHeaderInfoPingTF.SetText(Ping);
    RoundScoreMC.SetVisible(true);
    RoundsTeam2MC = RoundScoreMC.GetObject("scoreTeam2MC");
    RoundsScore2MC = RoundScoreMC.GetObject("scoreNumber2MC");
    BlueTitleTF = RoundsTeam2MC.GetObject("textField");
    BlueScoreTF = RoundsScore2MC.GetObject("textField");
    BlueTitleTF.SetText(BlueTeamText);
    // End:0xEA4
    if(class<AdvGameCTFBase>(GRI.GameClass) != none)
    {
        BlueScoreTF.SetText(string(AdvTeamInfo(GRI.Teams[int(BlueTeamIndex)]).CapturedFlags));        
    }
    else
    {
        BlueScoreTF.SetText(string(int(GRI.Teams[int(BlueTeamIndex)].Score)));
    }
    //return;    
}

function SetupRedTeam()
{
    local byte I, imax;
    local ScoreRow sr;
    local ASDisplayInfo DI;
    local AdvGRI GRI;

    GRI = AdvGRI(GetPC().WorldInfo.GRI);
    imax = ((bTeamGame) ? 8 : 16);
    I = 0;
    J0x70:

    // End:0xA24 [Loop If]
    if(int(I) < int(imax))
    {
        RedItems[int(I)] = sr;
        RedItems[int(I)].MovieClip = RedTeamMC.GetObject("item" $ string(int(I) + int(1)));
        // End:0x13E
        if(RedItems[int(I)].MovieClip == none)
        {
            return;
        }
        DI = RedItems[int(I)].MovieClip.GetDisplayInfo();
        DI.Alpha = 100.0000000;
        RedItems[int(I)].MovieClip.SetDisplayInfo(DI);
        RedItems[int(I)].InnerMovieClip = RedItems[int(I)].MovieClip.GetObject("item_g");
        // End:0x290
        if(RedItems[int(I)].InnerMovieClip == none)
        {            
        }
        else
        {
            RedItems[int(I)].LevelTF = RedItems[int(I)].InnerMovieClip.GetObject("levelMC").GetObject("levelTF");
            RedItems[int(I)].LevelMC = RedItems[int(I)].InnerMovieClip.GetObject("levelMC").GetObject("UILoader");
            RedItems[int(I)].KillsTF = RedItems[int(I)].InnerMovieClip.GetObject("kills");
            RedItems[int(I)].AssistsTF = RedItems[int(I)].InnerMovieClip.GetObject("assists");
            RedItems[int(I)].DeathsTF = RedItems[int(I)].InnerMovieClip.GetObject("deaths");
            RedItems[int(I)].ScoreTF = RedItems[int(I)].InnerMovieClip.GetObject("score");
            RedItems[int(I)].NameTF = RedItems[int(I)].InnerMovieClip.GetObject("name");
            RedItems[int(I)].PingMC = RedItems[int(I)].InnerMovieClip.GetObject("pingMC");
            RedItems[int(I)].ReadyMC = RedItems[int(I)].InnerMovieClip.GetObject("ready");
            RedItems[int(I)].SpeakerMC = RedItems[int(I)].InnerMovieClip.GetObject("speaker");
            // End:0x8CC
            if(Class'Core.Object'.static.GetLanguage() ~= "JPN")
            {
                RedItems[int(I)].NameTF.SetInt("_y", -7);
                RedItems[int(I)].NameTF.SetInt("_width", 640);
                RedItems[int(I)].NameTF.SetInt("_height", 50);
                RedItems[int(I)].NameTF.SetFloat("_xscale", 75.0000000);
                RedItems[int(I)].NameTF.SetFloat("_yscale", 75.0000000);
            }
            RedItems[int(I)].Button = GFxClikWidget(RedItems[int(I)].InnerMovieClip.GetObject("Button", Class'GFxUI.GFxClikWidget'));
            // End:0x9D1
            if(!GetPC().WorldInfo.IsConsoleBuild(0))
            {
                RedItems[int(I)].Button.SetBool("visible", false);
            }
            RedItems[int(I)].NameTF.SetBool("html", true);
        }
        I++;
        // [Loop Continue]
        goto J0x70;
    }
    RedHeaderMC = RedTeamMC.GetObject("header");
    RedHeaderInfoMC = RedHeaderMC.GetObject("headerinfo");
    RedHeaderInfoPlayerTF = RedHeaderInfoMC.GetObject("playername").GetObject("textField");
    RedHeaderInfoScoreTF = RedHeaderInfoMC.GetObject("playerscore").GetObject("textField");
    RedHeaderInfoKillsTF = RedHeaderInfoMC.GetObject("playerkills").GetObject("textField");
    RedHeaderInfoAssistsTF = RedHeaderInfoMC.GetObject("playerassists").GetObject("textField");
    RedHeaderInfoDeathTF = RedHeaderInfoMC.GetObject("playerdeaths").GetObject("textField");
    RedHeaderInfoPingTF = RedHeaderInfoMC.GetObject("playerping").GetObject("textField");
    RedHeaderInfoPlayerTF.SetText(Player);
    RedHeaderInfoScoreTF.SetText(ScoreText);
    RedHeaderInfoKillsTF.SetText(Kills);
    RedHeaderInfoAssistsTF.SetText(Assists);
    RedHeaderInfoDeathTF.SetText(Deaths);
    RedHeaderInfoPingTF.SetText(Ping);
    // End:0xFCB
    if(bTeamGame)
    {
        RoundScoreMC.SetVisible(true);
        RoundsTeam1MC = RoundScoreMC.GetObject("scoreTeam1MC");
        RoundsScore1MC = RoundScoreMC.GetObject("scoreNumber1MC");
        RedTitleTF = RoundsTeam1MC.GetObject("textField");
        RedScoreTF = RoundsScore1MC.GetObject("textField");
        RedTitleTF.SetText(RedTeamText);
        // End:0xF65
        if(class<AdvGameCTFBase>(GRI.GameClass) != none)
        {
            RedScoreTF.SetText(string(AdvTeamInfo(GRI.Teams[int(RedTeamIndex)]).CapturedFlags));            
        }
        else
        {
            RedScoreTF.SetText(string(int(GRI.Teams[int(RedTeamIndex)].Score)));
        }        
    }
    else
    {
        RoundScoreMC.SetVisible(false);
    }
    //return;    
}

function Draw()
{
    //return;    
}

function UpdatePRILists(AdvGRI GRI)
{
    local int I, redPlayers, bluePlayers, maxRedPlayers;
    local AdvPRI PRI;
    local GFxObject NewPlayerRow;

    // End:0x11
    if(!bInitialized)
    {
        return;
    }
    redPlayers = 0;
    bluePlayers = 0;
    maxRedPlayers = ((bTeamGame) ? 8 : 16);
    I = 0;
    J0x4F:

    // End:0x39B [Loop If]
    if(I < GRI.PRIArray.Length)
    {
        PRI = AdvPRI(GRI.PRIArray[I]);
        // End:0x38D
        if((PRI != none) && IsValidScoreboardPlayer(PRI))
        {
            NewPlayerRow = none;
            // End:0x221
            if(!bTeamGame || PRI.Team.TeamIndex == int(RedTeamIndex))
            {
                // End:0x21E
                if(!PRI.bOnlySpectator && redPlayers < maxRedPlayers)
                {
                    NewPlayerRow = RedItems[redPlayers].MovieClip;
                    UpdateRow(RedItems[redPlayers], RedEntries[redPlayers], PRI);
                    RedEntries[redPlayers].PRI = PRI;
                    redPlayers++;
                }                
            }
            else
            {
                // End:0x31A
                if((PRI.Team.TeamIndex == int(BlueTeamIndex)) && bluePlayers < 8)
                {
                    NewPlayerRow = BlueItems[bluePlayers].MovieClip;
                    UpdateRow(BlueItems[bluePlayers], BlueEntries[bluePlayers], PRI);
                    BlueEntries[bluePlayers].PRI = PRI;
                    bluePlayers++;
                }
            }
            // End:0x38D
            if(PRI.IsLocalPlayerPRI())
            {
                // End:0x366
                if(PlayerRow != NewPlayerRow)
                {
                    SetPlayerRow(NewPlayerRow);
                }
                UpdatePlayerFooter(GRI, PRI, byte(I));
            }
        }
        I++;
        // [Loop Continue]
        goto J0x4F;
    }
    I = redPlayers;
    J0x3AE:

    // End:0x46D [Loop If]
    if(I < maxRedPlayers)
    {
        RedEntries[I].PlayerName = "";
        RedEntries[I].PlayerPing = -1;
        RedEntries[I].PRI = none;
        ClearRow(RedItems[I]);
        I++;
        // [Loop Continue]
        goto J0x3AE;
    }
    // End:0x545
    if(bTeamGame)
    {
        I = bluePlayers;
        J0x48D:

        // End:0x545 [Loop If]
        if(I < 8)
        {
            BlueEntries[I].PlayerName = "";
            BlueEntries[I].PlayerPing = -1;
            BlueEntries[I].PRI = none;
            ClearRow(BlueItems[I]);
            I++;
            // [Loop Continue]
            goto J0x48D;
        }
    }
    //return;    
}

function ClearRow(ScoreRow ThisRow)
{
    local ASDisplayInfo displayInfo;

    displayInfo = ThisRow.MovieClip.GetDisplayInfo();
    displayInfo.Alpha = 60.0000000;
    ThisRow.MovieClip.SetDisplayInfo(displayInfo);
    ThisRow.LevelTF.SetText("");
    ThisRow.LevelMC.SetString("source", "img://UI_AdvCommon.Textures.Blank");
    ThisRow.ScoreTF.SetText("");
    ThisRow.KillsTF.SetText("");
    ThisRow.AssistsTF.SetText("");
    ThisRow.DeathsTF.SetText("");
    ThisRow.NameTF.SetString("htmlText", "");
    ThisRow.PingMC.SetVisible(false);
    ThisRow.ReadyMC.SetVisible(false);
    ThisRow.SpeakerMC.SetVisible(false);
    ThisRow.Button.SetBool("visible", false);
    //return;    
}

function UpdateRow(ScoreRow ThisRow, out ScoreEntry ThisEntry, AdvPRI ThisPRI)
{
    local ASDisplayInfo displayInfo;
    local bool bUpdateItemRenderer;
    local string NameAndFlagText;
    local array<ASValue> args;

    bUpdateItemRenderer = false;
    // End:0x3C8
    if(ThisPRI.PlayerName != ThisEntry.PlayerName)
    {
        // End:0x381
        if(ThisEntry.PlayerName == "")
        {
            displayInfo = ThisRow.MovieClip.GetDisplayInfo();
            displayInfo.Alpha = 60.0000000;
            ThisRow.MovieClip.SetDisplayInfo(displayInfo);
            ThisRow.ScoreTF.SetText(string(int(ThisPRI.Score)));
            ThisEntry.PlayerScore = int(ThisPRI.Score);
            ThisRow.KillsTF.SetText(string(ThisPRI.Kills));
            ThisEntry.PlayerKills = ThisPRI.Kills;
            ThisRow.AssistsTF.SetText(string(ThisPRI.Assists));
            ThisEntry.PlayerAssists = ThisPRI.Assists;
            ThisRow.DeathsTF.SetText(string(ThisPRI.Deaths));
            ThisEntry.PlayerDeaths = ThisPRI.Deaths;
            ThisEntry.bMuted = false;
            ThisEntry.bTalking = true;
        }
        ThisEntry.PlayerName = ThisPRI.PlayerName;
        bUpdateItemRenderer = true;
    }
    // End:0x452
    if(ThisPRI.Score != float(ThisEntry.PlayerScore))
    {
        ThisEntry.PlayerScore = int(ThisPRI.Score);
        bUpdateItemRenderer = true;
    }
    // End:0x4D8
    if(ThisPRI.Kills != ThisEntry.PlayerKills)
    {
        ThisEntry.PlayerKills = ThisPRI.Kills;
        bUpdateItemRenderer = true;
    }
    // End:0x55E
    if(ThisPRI.Assists != ThisEntry.PlayerAssists)
    {
        ThisEntry.PlayerAssists = ThisPRI.Assists;
        bUpdateItemRenderer = true;
    }
    // End:0x5E4
    if(ThisPRI.Deaths != ThisEntry.PlayerDeaths)
    {
        ThisEntry.PlayerDeaths = ThisPRI.Deaths;
        bUpdateItemRenderer = true;
    }
    // End:0x9E3
    if((((bUpdateItemRenderer || ThisPRI.bIsAlive != ThisEntry.bIsAlive) || ThisPRI.bHasFlag != ThisEntry.bHasFlag) || ThisPRI.bIsDevastator != ThisEntry.bHasDevastator) || ThisPRI.bIsMummy != ThisEntry.bHasMummy)
    {
        NameAndFlagText = "";
        ThisEntry.bIsAlive = ThisPRI.bIsAlive;
        // End:0x797
        if(!ThisPRI.bIsAlive)
        {            
            NameAndFlagText $= "<font color='#9C9C9C'>";
        }
        ThisEntry.bHasFlag = ThisPRI.bHasFlag;
        // End:0x82A
        if(ThisPRI.bHasFlag)
        {            
            NameAndFlagText $= "<img src=\"flag_noglow\">&nbsp;";
        }
        ThisEntry.bHasDevastator = ThisPRI.bIsDevastator;
        // End:0x8C3
        if(ThisPRI.bIsDevastator)
        {            
            NameAndFlagText $= "<img src=\"t_armagedon_small\">&nbsp;";
        }
        ThisEntry.bHasMummy = ThisPRI.bIsMummy;
        // End:0x958
        if(ThisPRI.bIsMummy)
        {            
            NameAndFlagText $= "<img src=\"t_mummy_small\">&nbsp;";
        }        
        NameAndFlagText $= (SanitizeForHTML(ThisPRI.PlayerName));
        // End:0x9D7
        if(!ThisPRI.bIsAlive)
        {            
            NameAndFlagText $= "</font>";
        }
        bUpdateItemRenderer = true;
    }
    // End:0xAF6
    if(ThisPRI.bReadyToPlay != ThisEntry.bReady)
    {
        // End:0xA82
        if(ThisPRI.bReadyToPlay)
        {
            ThisRow.ReadyMC.GotoAndStop("ready");            
        }
        else
        {
            ThisRow.ReadyMC.GotoAndStop("not");
        }
        ThisEntry.bReady = ThisPRI.bReadyToPlay;
    }
    // End:0xCA2
    if(int(ThisPRI.Ping) != ThisEntry.PlayerPing)
    {
        ThisRow.PingMC.SetVisible(true);
        // End:0xBCE
        if((int(ThisPRI.Ping) * int(4)) > 200)
        {
            ThisRow.PingMC.GotoAndStopI(3);            
        }
        else
        {
            // End:0xC32
            if((int(ThisPRI.Ping) * int(4)) > 100)
            {
                ThisRow.PingMC.GotoAndStopI(2);                
            }
            else
            {
                ThisRow.PingMC.GotoAndStopI(1);
            }
        }
        ThisEntry.PlayerPing = int(ThisPRI.Ping);
    }
    // End:0xE16
    if(ThisPRI.PlayerLevel != ThisEntry.PlayerLevel)
    {
        ThisRow.LevelTF.SetText(string(ThisPRI.PlayerLevel));
        ThisRow.LevelMC.SetString("source", "img://" $ Class'AdvClassInfo_MP_Base'.default.RankIconPath[Clamp(ThisPRI.PlayerLevel - 1, 0, Class'AdvClassInfo_MP_Base'.default.RankIconPath.Length)]);
        ThisEntry.PlayerLevel = ThisPRI.PlayerLevel;
    }
    ThisRow.ReadyMC.SetVisible(false);
    // End:0xF42
    if(PlayerIsMuted(ThisPRI.UniqueId))
    {
        // End:0xF3F
        if(!ThisEntry.bMuted)
        {
            ThisRow.SpeakerMC.SetVisible(true);
            ThisRow.SpeakerMC.GotoAndStop("mute");
            ThisEntry.bMuted = true;
            ThisEntry.bTalking = false;
        }        
    }
    else
    {
        // End:0xFEE
        if(ThisEntry.bMuted)
        {
            ThisRow.SpeakerMC.GotoAndStop("active");
            ThisRow.SpeakerMC.SetVisible(false);
            ThisEntry.bMuted = false;
        }
        // End:0x10D1
        if(Class'AdvUIManager'.static.GetChatIconOpacity(ThisPRI) > 0.5000000)
        {
            // End:0x10CE
            if(!ThisEntry.bTalking)
            {
                ThisRow.SpeakerMC.SetVisible(true);
                ThisRow.SpeakerMC.GotoAndStop("active");
                ThisEntry.bTalking = true;
            }            
        }
        else
        {
            // End:0x1143
            if(ThisEntry.bTalking)
            {
                ThisRow.SpeakerMC.SetVisible(false);
                ThisEntry.bTalking = false;
            }
        }
    }
    // End:0x13D5
    if(bUpdateItemRenderer)
    {
        ThisRow.KillsTF.SetText(string(ThisEntry.PlayerKills));
        ThisRow.AssistsTF.SetText(string(ThisEntry.PlayerAssists));
        args.Length = 0;
        ThisRow.InnerMovieClip.SetString("PlayerName", NameAndFlagText);
        ThisRow.InnerMovieClip.SetString("PlayerScore", string(ThisEntry.PlayerScore));
        ThisRow.InnerMovieClip.SetString("PlayerDeaths", string(ThisEntry.PlayerDeaths));        
        ThisRow.InnerMovieClip.Invoke("UpdateAfterStateChange", args);
        // End:0x13D5
        if(GetPC().WorldInfo.IsConsoleBuild(0))
        {
            ThisRow.Button.SetBool("visible", true);
        }
    }
    //return;    
}

function Tick(float DeltaTime)
{
    local AdvGRI GRI;
    local AdvPRI TargetPRI;

    ConfigScoreboard();
    GRI = AdvGRI(GetPC().WorldInfo.GRI);
    // End:0x99
    if(GRI != none)
    {
        UpdatePRILists(GRI);
        UpdateHeaders(GRI);
        UpdatePreviousState(GRI);
    }
    // End:0xD9
    if(CurrentSelectedSlotIsRed)
    {
        TargetPRI = RedEntries[CurrentSelectedSlot].PRI;        
    }
    else
    {
        TargetPRI = BlueEntries[CurrentSelectedSlot].PRI;
    }
    // End:0x167
    if(GetPC().WorldInfo.IsConsoleBuild(0) && TargetPRI != none)
    {
        FooterUpdate(TargetPRI);
    }
    super(UTGFxTweenableMoviePlayer).Tick(DeltaTime);
    //return;    
}

final function bool PlayerIsMuted(UniqueNetId NetId)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInt;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0xCB
    if(OnlineSub != none)
    {
        PlayerInt = OnlineSub.PlayerInterface;
        // End:0xCB
        if(NotEqual_InterfaceInterface(PlayerInt, OnlinePlayerInterface(none)))
        {
            return PlayerInt.IsMuted(byte(GetLP().ControllerId), NetId);
        }
    }
    return false;
    //return ReturnValue;    
}

function SetPlayerRow(GFxObject UpdatedPlayerRow)
{
    // End:0x56
    if(PlayerRow != none)
    {
        PlayerRow.GetObject("item_g").GotoAndStop("default");
    }
    PlayerRow = UpdatedPlayerRow;
    // End:0x151
    if(PlayerRow != none)
    {
        PlayerRow.GetObject("item_g").GotoAndStop("player");
        // End:0x151
        if(!bInitialFocusSet)
        {
            GFxClikWidget(PlayerRow.GetObject("item_g").GetObject("Button", Class'GFxUI.GFxClikWidget')).SetBool("focused", true);
            bInitialFocusSet = true;
        }
    }
    //return;    
}

function UpdatePreviousState(AdvGRI GRI)
{
    // End:0x60
    if(GRI.IsSurvivalGame())
    {
        PreviousState.RemainingTime = GRI.TimerToLastMummy;        
    }
    else
    {
        PreviousState.RemainingTime = ((GRI.TimeLimit != 0) ? GRI.RemainingTime : GRI.ElapsedTime);
    }
    // End:0x2A2
    if(bTeamGame)
    {
        // End:0x1E6
        if(class<AdvGameCTFBase>(GRI.GameClass) != none)
        {
            PreviousState.RedScore = AdvTeamInfo(GRI.Teams[int(RedTeamIndex)]).CapturedFlags;
            PreviousState.BlueScore = AdvTeamInfo(GRI.Teams[int(BlueTeamIndex)]).CapturedFlags;            
        }
        else
        {
            PreviousState.RedScore = int(GRI.Teams[int(RedTeamIndex)].Score);
            PreviousState.BlueScore = int(GRI.Teams[int(BlueTeamIndex)].Score);
        }
    }
    //return;    
}

static function string FormatTime(int Seconds)
{
    local int Hours, Mins;
    local string NewTimeString;

    Hours = Seconds / 3600;
    Seconds -= (Hours * 3600);
    Mins = Seconds / 60;
    Seconds -= (Mins * 60);
    // End:0xAF
    if(Hours > 0)
    {
        NewTimeString = ((Hours > 9) ? string(Hours) : "0" $ string(Hours)) $ ":";
    }
    NewTimeString = (NewTimeString $ ((Mins > 9) ? string(Mins) : "0" $ string(Mins))) $ ":";
    NewTimeString = NewTimeString $ ((Seconds > 9) ? string(Seconds) : "0" $ string(Seconds));
    return NewTimeString;
    //return ReturnValue;    
}

function UpdateHeaders(AdvGRI GRI)
{
    // End:0x2CB
    if(bTeamGame)
    {
        // End:0x16C
        if(float(PreviousState.RedScore) != GRI.Teams[int(RedTeamIndex)].Score)
        {
            // End:0x109
            if(class<AdvGameCTFBase>(GRI.GameClass) != none)
            {
                RedScoreTF.SetText(string(AdvTeamInfo(GRI.Teams[int(RedTeamIndex)]).CapturedFlags));                
            }
            else
            {
                RedScoreTF.SetText(string(int(GRI.Teams[int(RedTeamIndex)].Score)));
            }
        }
        // End:0x2CB
        if(float(PreviousState.BlueScore) != GRI.Teams[int(BlueTeamIndex)].Score)
        {
            // End:0x268
            if(class<AdvGameCTFBase>(GRI.GameClass) != none)
            {
                BlueScoreTF.SetText(string(AdvTeamInfo(GRI.Teams[int(BlueTeamIndex)]).CapturedFlags));                
            }
            else
            {
                BlueScoreTF.SetText(string(int(GRI.Teams[int(BlueTeamIndex)].Score)));
            }
        }
    }
    // End:0x519
    if(GRI.IsSurvivalGame())
    {
        // End:0x44B
        if(GRI.TimerToLastMummy > 0)
        {
            // End:0x448
            if(PreviousState.RemainingTime != GRI.TimerToLastMummy)
            {
                TimeTF.SetText(FormatTime(GRI.TimerToLastMummy));
                // End:0x41F
                if(GRI.TimerToLastMummyTitleLocKey != "")
                {
                    TimeLabelTF.SetText(Localize("CustomTimers", GRI.TimerToLastMummyTitleLocKey, "ADVGame"));                    
                }
                else
                {
                    TimeLabelTF.SetText(TimeLeft);
                }
            }            
        }
        else
        {
            TimeTF.SetText("");
            // End:0x4F4
            if(GRI.TimerToLastMummyExpiredLocKey != "")
            {
                TimeLabelTF.SetText(Localize("CustomTimers", GRI.TimerToLastMummyExpiredLocKey, "ADVGame"));                
            }
            else
            {
                TimeLabelTF.SetText("");
            }
        }        
    }
    else
    {
        // End:0x69A
        if(((GRI.TimeLimit != 0) && PreviousState.RemainingTime != GRI.RemainingTime) || (GRI.TimeLimit == 0) && PreviousState.RemainingTime != GRI.ElapsedTime)
        {
            TimeTF.SetText(FormatTime(((GRI.TimeLimit != 0) ? GRI.RemainingTime : GRI.ElapsedTime)));
            TimeLabelTF.SetText(TimeLeft);
        }
    }
    //return;    
}

function UpdatePlayerFooter(AdvGRI GRI, AdvPRI LocalPlayerPRI, optional byte PRIIndex)
{
    local byte PlayerRelRank, PlayerTeamIndex;
    local float ScoreDiff;

    // End:0x30
    if(!bTeamGame)
    {
        PlayerRelRank = byte(int(PRIIndex) + int(1));        
    }
    else
    {
        PlayerTeamIndex = LocalPlayerPRI.GetTeamNum();
        ScoreDiff = ((int(PlayerTeamIndex) == int(RedTeamIndex)) ? GRI.Teams[int(RedTeamIndex)].Score - GRI.Teams[int(BlueTeamIndex)].Score : GRI.Teams[int(BlueTeamIndex)].Score - GRI.Teams[int(RedTeamIndex)].Score);
        // End:0x1A2
        if(ScoreDiff >= 0.0000000)
        {
            PlayerRelRank = 1;            
        }
        else
        {
            PlayerRelRank = 2;
        }
    }
    PreviousState.PlayerName = LocalPlayerPRI.PlayerName;
    PreviousState.PlayerLevel = LocalPlayerPRI.PlayerLevel;
    PreviousState.PlayerScore = float(int(LocalPlayerPRI.Score));
    PreviousState.PlayerKills = LocalPlayerPRI.Kills;
    PreviousState.PlayerAssists = LocalPlayerPRI.Assists;
    PreviousState.PlayerDeaths = LocalPlayerPRI.Deaths;
    PreviousState.PlayerPlace = PlayerRelRank;
    //return;    
}

function FloatScoreboardAnimationX(bool Direction)
{
    // End:0x4D
    if(Direction)
    {
        TweenTo(ScoreboardMC, 5.0000000, "_xrotation", 4.0000000, 2, "FloatScoreboard1");        
    }
    else
    {
        TweenTo(ScoreboardMC, 5.0000000, "_xrotation", -4.0000000, 2, "FloatScoreboard2");
    }
    //return;    
}

function FloatScoreboardAnimationY(bool Direction)
{
    // End:0x4D
    if(Direction)
    {
        TweenTo(ScoreboardMC, 7.0000000, "_yrotation", 7.0000000, 2, "FloatScoreboard3");        
    }
    else
    {
        TweenTo(ScoreboardMC, 7.0000000, "_yrotation", -7.0000000, 2, "FloatScoreboard4");
    }
    //return;    
}

function TweenPlayerRow(GFxObject RowMC)
{
    // End:0x43
    if(bPlayerRowTween)
    {
        TweenTo(RowMC, 1.5000000, "_z", -450.0000000, 2, "TweenPlayerRow");        
    }
    else
    {
        TweenTo(RowMC, 1.5000000, "_z", 0.0000000, 2, "TweenPlayerRow");
    }
    bPlayerRowTween = !bPlayerRowTween;
    //return;    
}

function ProcessTweenCallback(string Callback, GFxObject TargetMC)
{
    switch(Callback)
    {
        // End:0x3C
        case "TweenPlayerRow":
            TweenPlayerRow(TargetMC);
            // End:0xCE
            break;
        // End:0x5F
        case "FloatScoreboard1":
            FloatScoreboardAnimationX(false);
            // End:0xCE
            break;
        // End:0x82
        case "FloatScoreboard2":
            FloatScoreboardAnimationX(true);
            // End:0xCE
            break;
        // End:0xA5
        case "FloatScoreboard3":
            FloatScoreboardAnimationY(false);
            // End:0xCE
            break;
        // End:0xC8
        case "FloatScoreboard4":
            FloatScoreboardAnimationY(true);
            // End:0xCE
            break;
        // End:0xFFFF
        default:
            // End:0xCE
            break;
            break;
    }
    //return;    
}

function bool IsValidScoreboardPlayer(AdvPRI PRI)
{
    // End:0x123
    if(PRI.bIsTournamentSpectator || (!PRI.bIsInactive && int(PRI.WorldInfo.NetMode) != int(NM_Client)) && (PRI.Owner == none) || (PlayerController(PRI.Owner) != none) && PlayerController(PRI.Owner).Player == none)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function string GetTimeOnline(AdvPRI PRI)
{
    return "" @ Class'EvilGame.UTHUD'.static.FormatTime(PRI.WorldInfo.GRI.ElapsedTime);
    //return ReturnValue;    
}

function UpdateFooterStatusText(string InText)
{
    FooterItemTF.SetText(InText);
    //return;    
}

function UpdateButtonsFooter(optional bool bClear = false, optional bool bShowNextLeveButton)
{
    local array<name> ButtonAliases;
    local AdvGRI GRI;
    local AdvTypes.EMultiGameMode GameMode;

    // End:0x41
    if(bClear)
    {
        Footer_Buttons.SetString("htmlText", "");
        return;
    }
    GRI = AdvGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    // End:0x262
    if(GRI != none)
    {
        // End:0x141
        if(bShowNextLeveButton)
        {
            ButtonAliases.Length = 0;
            ButtonAliases.AddItem('GenericContinue');            
            Footer_Buttons.SetBool("html", true);
            Footer_Buttons.SetString("htmlText", Class'AdvGFxUI_Menu_Footer'.static.GetStringForFooterUpdateFromArray(ButtonAliases));            
        }
        else
        {
            GameMode = GRI.GetMultiGameMode(GRI.GameClass);
            ButtonAliases.Length = 0;
            // End:0x1EA
            if((int(GameMode) == int(2)) || int(GameMode) == int(1))
            {
                ButtonAliases.AddItem('SwitchTeams');                
                ButtonAliases.AddItem('ReadyNotReady');                
            }
            Footer_Buttons.SetBool("html", true);
            Footer_Buttons.SetString("htmlText", Class'AdvGFxUI_Menu_Footer'.static.GetStringForFooterUpdateFromArray(ButtonAliases));
        }
    }
    //return;    
}

function FooterUpdate(AdvPRI PRI)
{
    local array<name> ButtonAliases;

    ButtonAliases.Length = 0;
    // End:0x165
    if((GetPC().WorldInfo.IsConsoleBuild(0) && PRI != none) && Class'Engine.UIInteraction'.static.IsLoggedIn(GetLP().ControllerId))
    {
        ButtonAliases.AddItem('GenericSelect');        
        // End:0x124
        if(Class'AdvGFxUI_Menu_PartyMenu'.static.CanVoteKickPlayer(PRI) && GetPC().PlayerReplicationInfo != PRI)
        {
            ButtonAliases.AddItem('VoteKickPlayer');                        
        }
        else
        {
            // End:0x165
            if(Class'AdvGFxUI_Menu_PartyMenu'.static.CanKickPlayer(PRI))
            {
                ButtonAliases.AddItem('KickPlayer');                
            }
        }
    }
    FooterUpdateInternal(ButtonAliases);
    //return;    
}

function FooterUpdateInternal(array<name> ButtonAliases)
{
    local int I;
    local array<name> TempButtonAliases, TempButtonAliasesBottom;

    FooterItemTF.SetText(" ");
    Footer_Buttons.SetText(" ");
    I = 0;
    J0x51:

    // End:0xCA [Loop If]
    if(I < ButtonAliases.Length)
    {
        // End:0x9C
        if(I < 2)
        {
            TempButtonAliases.AddItem(ButtonAliases[I]);                        
        }
        else
        {
            TempButtonAliasesBottom.AddItem(ButtonAliases[I]);            
        }
        I++;
        // [Loop Continue]
        goto J0x51;
    }
    FooterItemTF.SetBool("html", true);
    FooterItemTF.SetString("htmlText", Class'AdvGFxUI_Menu_Footer'.static.GetStringForFooterUpdateFromArray(TempButtonAliases));
    Footer_Buttons.SetBool("html", true);
    Footer_Buttons.SetString("htmlText", Class'AdvGFxUI_Menu_Footer'.static.GetStringForFooterUpdateFromArray(TempButtonAliasesBottom));
    //return;    
}

static function string SanitizeForHTML(string In)
{
    local string Out, Char;
    local int I;

    I = 0;
    J0x0B:

    // End:0x141 [Loop If]
    if(I < Len(In))
    {
        Char = Mid(In, I, 1);
        switch(Char)
        {
            // End:0x7C
            case "\"":                
                Out $= "&quot;";
                // End:0x133
                break;
            // End:0xA2
            case "'":                
                Out $= "&apos;";
                // End:0x133
                break;
            // End:0xC7
            case "&":                
                Out $= "&amp;";
                // End:0x133
                break;
            // End:0xEB
            case "<":                
                Out $= "&lt;";
                // End:0x133
                break;
            // End:0x10F
            case ">":                
                Out $= "&gt;";
                // End:0x133
                break;
            // End:0xFFFF
            default:                
                Out $= Char;
                // End:0x133
                break;
                break;
        }
        ++I;
        // [Loop Continue]
        goto J0x0B;
    }
    return Out;
    //return ReturnValue;    
}

function OnItemRed(int Index)
{
    // End:0xCA
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        // End:0xCA
        if(RedEntries[Index].PRI != none)
        {
            Class'AdvGFxUI_Menu_PartyMenu'.static.ShowGamerCardFor(RedEntries[Index].PRI, GetLP().ControllerId);
        }
    }
    //return;    
}

function OverItemRed(int Index)
{
    CurrentSelectedSlotIsRed = true;
    CurrentSelectedSlot = Index;
    FooterUpdate(RedEntries[Index].PRI);
    //return;    
}

function OnItemBlue(int Index)
{
    // End:0xCA
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        // End:0xCA
        if(BlueEntries[Index].PRI != none)
        {
            Class'AdvGFxUI_Menu_PartyMenu'.static.ShowGamerCardFor(BlueEntries[Index].PRI, GetLP().ControllerId);
        }
    }
    //return;    
}

function OverItemBlue(int Index)
{
    CurrentSelectedSlotIsRed = false;
    CurrentSelectedSlot = Index;
    FooterUpdate(BlueEntries[Index].PRI);
    //return;    
}

function bool OnVoteKick_Confirmed(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local AdvPRI PRI;

    // End:0x40
    if(CurrentSelectedSlotIsRed)
    {
        PRI = RedEntries[CurrentSelectedSlot].PRI;        
    }
    else
    {
        PRI = BlueEntries[CurrentSelectedSlot].PRI;
    }
    // End:0xE8
    if((PRI != none) && SelectedInputAlias == 'AcceptKick')
    {
        Class'AdvGFxUI_Menu_PartyMenu'.static.VoteKickPlayerSubmit(PRI, AdvPRI(GetPC().PlayerReplicationInfo));
    }
    return true;
    //return ReturnValue;    
}

function bool OnKick_Confirmed(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local AdvPRI PRI;

    // End:0x40
    if(CurrentSelectedSlotIsRed)
    {
        PRI = RedEntries[CurrentSelectedSlot].PRI;        
    }
    else
    {
        PRI = BlueEntries[CurrentSelectedSlot].PRI;
    }
    // End:0xC0
    if((PRI != none) && SelectedInputAlias == 'AcceptKick')
    {
        Class'AdvGFxUI_Menu_PartyMenu'.static.KickPlayerSubmit(PRI);
    }
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    BlueTeamIndex=1
    RedEntries[0]=(PRI=none,PlayerName="",PlayerLevel=-1,PlayerScore=0,PlayerKills=0,PlayerAssists=0,PlayerDeaths=0,PlayerPing=-1,bIsAlive=false,bHasFlag=false,bReady=false,bTalking=true,bMuted=false,bHasDevastator=false,bHasMummy=false)
    RedEntries[1]=(PRI=none,PlayerName="",PlayerLevel=-1,PlayerScore=0,PlayerKills=0,PlayerAssists=0,PlayerDeaths=0,PlayerPing=-1,bIsAlive=false,bHasFlag=false,bReady=false,bTalking=true,bMuted=false,bHasDevastator=false,bHasMummy=false)
    RedEntries[2]=(PRI=none,PlayerName="",PlayerLevel=-1,PlayerScore=0,PlayerKills=0,PlayerAssists=0,PlayerDeaths=0,PlayerPing=-1,bIsAlive=false,bHasFlag=false,bReady=false,bTalking=true,bMuted=false,bHasDevastator=false,bHasMummy=false)
    RedEntries[3]=(PRI=none,PlayerName="",PlayerLevel=-1,PlayerScore=0,PlayerKills=0,PlayerAssists=0,PlayerDeaths=0,PlayerPing=-1,bIsAlive=false,bHasFlag=false,bReady=false,bTalking=true,bMuted=false,bHasDevastator=false,bHasMummy=false)
    RedEntries[4]=(PRI=none,PlayerName="",PlayerLevel=-1,PlayerScore=0,PlayerKills=0,PlayerAssists=0,PlayerDeaths=0,PlayerPing=-1,bIsAlive=false,bHasFlag=false,bReady=false,bTalking=true,bMuted=false,bHasDevastator=false,bHasMummy=false)
    RedEntries[5]=(PRI=none,PlayerName="",PlayerLevel=-1,PlayerScore=0,PlayerKills=0,PlayerAssists=0,PlayerDeaths=0,PlayerPing=-1,bIsAlive=false,bHasFlag=false,bReady=false,bTalking=true,bMuted=false,bHasDevastator=false,bHasMummy=false)
    RedEntries[6]=(PRI=none,PlayerName="",PlayerLevel=-1,PlayerScore=0,PlayerKills=0,PlayerAssists=0,PlayerDeaths=0,PlayerPing=-1,bIsAlive=false,bHasFlag=false,bReady=false,bTalking=true,bMuted=false,bHasDevastator=false,bHasMummy=false)
    RedEntries[7]=(PRI=none,PlayerName="",PlayerLevel=-1,PlayerScore=0,PlayerKills=0,PlayerAssists=0,PlayerDeaths=0,PlayerPing=-1,bIsAlive=false,bHasFlag=false,bReady=false,bTalking=true,bMuted=false,bHasDevastator=false,bHasMummy=false)
    RedEntries[8]=(PRI=none,PlayerName="",PlayerLevel=-1,PlayerScore=0,PlayerKills=0,PlayerAssists=0,PlayerDeaths=0,PlayerPing=-1,bIsAlive=false,bHasFlag=false,bReady=false,bTalking=true,bMuted=false,bHasDevastator=false,bHasMummy=false)
    RedEntries[9]=(PRI=none,PlayerName="",PlayerLevel=-1,PlayerScore=0,PlayerKills=0,PlayerAssists=0,PlayerDeaths=0,PlayerPing=-1,bIsAlive=false,bHasFlag=false,bReady=false,bTalking=true,bMuted=false,bHasDevastator=false,bHasMummy=false)
    RedEntries[10]=(PRI=none,PlayerName="",PlayerLevel=-1,PlayerScore=0,PlayerKills=0,PlayerAssists=0,PlayerDeaths=0,PlayerPing=-1,bIsAlive=false,bHasFlag=false,bReady=false,bTalking=true,bMuted=false,bHasDevastator=false,bHasMummy=false)
    RedEntries[11]=(PRI=none,PlayerName="",PlayerLevel=-1,PlayerScore=0,PlayerKills=0,PlayerAssists=0,PlayerDeaths=0,PlayerPing=-1,bIsAlive=false,bHasFlag=false,bReady=false,bTalking=true,bMuted=false,bHasDevastator=false,bHasMummy=false)
    RedEntries[12]=(PRI=none,PlayerName="",PlayerLevel=-1,PlayerScore=0,PlayerKills=0,PlayerAssists=0,PlayerDeaths=0,PlayerPing=-1,bIsAlive=false,bHasFlag=false,bReady=false,bTalking=true,bMuted=false,bHasDevastator=false,bHasMummy=false)
    RedEntries[13]=(PRI=none,PlayerName="",PlayerLevel=-1,PlayerScore=0,PlayerKills=0,PlayerAssists=0,PlayerDeaths=0,PlayerPing=-1,bIsAlive=false,bHasFlag=false,bReady=false,bTalking=true,bMuted=false,bHasDevastator=false,bHasMummy=false)
    RedEntries[14]=(PRI=none,PlayerName="",PlayerLevel=-1,PlayerScore=0,PlayerKills=0,PlayerAssists=0,PlayerDeaths=0,PlayerPing=-1,bIsAlive=false,bHasFlag=false,bReady=false,bTalking=true,bMuted=false,bHasDevastator=false,bHasMummy=false)
    RedEntries[15]=(PRI=none,PlayerName="",PlayerLevel=-1,PlayerScore=0,PlayerKills=0,PlayerAssists=0,PlayerDeaths=0,PlayerPing=-1,bIsAlive=false,bHasFlag=false,bReady=false,bTalking=true,bMuted=false,bHasDevastator=false,bHasMummy=false)
    BlueEntries[0]=(PRI=none,PlayerName="",PlayerLevel=-1,PlayerScore=0,PlayerKills=0,PlayerAssists=0,PlayerDeaths=0,PlayerPing=-1,bIsAlive=false,bHasFlag=false,bReady=false,bTalking=true,bMuted=false,bHasDevastator=false,bHasMummy=false)
    BlueEntries[1]=(PRI=none,PlayerName="",PlayerLevel=-1,PlayerScore=0,PlayerKills=0,PlayerAssists=0,PlayerDeaths=0,PlayerPing=-1,bIsAlive=false,bHasFlag=false,bReady=false,bTalking=true,bMuted=false,bHasDevastator=false,bHasMummy=false)
    BlueEntries[2]=(PRI=none,PlayerName="",PlayerLevel=-1,PlayerScore=0,PlayerKills=0,PlayerAssists=0,PlayerDeaths=0,PlayerPing=-1,bIsAlive=false,bHasFlag=false,bReady=false,bTalking=true,bMuted=false,bHasDevastator=false,bHasMummy=false)
    BlueEntries[3]=(PRI=none,PlayerName="",PlayerLevel=-1,PlayerScore=0,PlayerKills=0,PlayerAssists=0,PlayerDeaths=0,PlayerPing=-1,bIsAlive=false,bHasFlag=false,bReady=false,bTalking=true,bMuted=false,bHasDevastator=false,bHasMummy=false)
    BlueEntries[4]=(PRI=none,PlayerName="",PlayerLevel=-1,PlayerScore=0,PlayerKills=0,PlayerAssists=0,PlayerDeaths=0,PlayerPing=-1,bIsAlive=false,bHasFlag=false,bReady=false,bTalking=true,bMuted=false,bHasDevastator=false,bHasMummy=false)
    BlueEntries[5]=(PRI=none,PlayerName="",PlayerLevel=-1,PlayerScore=0,PlayerKills=0,PlayerAssists=0,PlayerDeaths=0,PlayerPing=-1,bIsAlive=false,bHasFlag=false,bReady=false,bTalking=true,bMuted=false,bHasDevastator=false,bHasMummy=false)
    BlueEntries[6]=(PRI=none,PlayerName="",PlayerLevel=-1,PlayerScore=0,PlayerKills=0,PlayerAssists=0,PlayerDeaths=0,PlayerPing=-1,bIsAlive=false,bHasFlag=false,bReady=false,bTalking=true,bMuted=false,bHasDevastator=false,bHasMummy=false)
    BlueEntries[7]=(PRI=none,PlayerName="",PlayerLevel=-1,PlayerScore=0,PlayerKills=0,PlayerAssists=0,PlayerDeaths=0,PlayerPing=-1,bIsAlive=false,bHasFlag=false,bReady=false,bTalking=true,bMuted=false,bHasDevastator=false,bHasMummy=false)
    TimeLeft="Time Left"
    ScoreLimitText="Score Limit"
    PlacementText="Your Placement"
    ScoreText="Score"
    Kills="Kills"
    Assists="Assists"
    Deaths="Deaths"
    Ping="Ping"
    Player="Player"
    Players="Players"
    RedTeamText="Mercenaries"
    RedTeamShortText="MRC"
    BlueTeamText="Adventurers"
    BlueTeamShortText="ADV"
    BlueTeamRoundsText="Rounds for Adventurers"
    RedTeamRoundsText="Rounds for Mercenaries"
    WinningText="Winning"
    LosingText="Losing"
    DrawText="Draw"
    MaxRoundsString="Rounds to win"
    MovieInfoPath="UI_AdvMultiplayerInGame.AdvScoreboard"
}