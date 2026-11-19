class PKGFxUI_Scoreboard extends PKGfxMoviePlayer
    config(UI);

struct ScoreEntry
{
    var string PlayerName;
    var int PlayerScore;
    var int PlayerDeaths;
    var int PlayerPing;
    var bool bHasFlag;
    var bool bReady;
    var bool bTalking;
    var bool bMuted;

    structdefaultproperties
    {
        PlayerName=""
        PlayerScore=0
        PlayerDeaths=0
        PlayerPing=-1
        bHasFlag=false
        bReady=false
        bTalking=false
        bMuted=false
    }
};

struct ScoreboardState
{
    var int RemainingTime;
    var int ScoreLimit;
    var int RedScore;
    var int BlueScore;
    var string PlayerName;
    var byte PlayerPlace;
    var float PlayerScore;
    var int PlayerDeaths;

    structdefaultproperties
    {
        RemainingTime=0
        ScoreLimit=0
        RedScore=0
        BlueScore=0
        PlayerName=""
        PlayerPlace=0
        PlayerScore=0.0000000
        PlayerDeaths=0
    }
};

struct ScoreRow
{
    var GFxObject MovieClip;
    var GFxObject InnerMovieClip;
    var GFxObject DeathsTF;
    var GFxObject ScoreTF;
    var GFxObject NameTF;
    var GFxObject PingTF;
    var GFxObject ReadyMC;
    var GFxObject SpeakerMC;

    structdefaultproperties
    {
        MovieClip=none
        InnerMovieClip=none
        DeathsTF=none
        ScoreTF=none
        NameTF=none
        PingTF=none
        ReadyMC=none
        SpeakerMC=none
    }
};

var GFxObject RootMC;
var GFxObject ScoreboardMC;
var GFxObject OverlayMC;
var GFxObject TitleMC;
var GFxObject BlueTeamMC;
var GFxObject RedTeamMC;
var GFxObject TimeMC;
var GFxObject TimeTF;
var GFxObject Title_TitleGMC;
var GFxObject TitleTF;
var GFxObject TitleGMC;
var GFxObject ScoreLimitMC;
var GFxObject ScoreLimitTF;
var GFxObject ScoreLimitN;
var GFxObject BlueHeaderMC;
var GFxObject BlueScoreTF;
var GFxObject BlueTitleTF;
var GFxObject RedHeaderMC;
var GFxObject RedScoreTF;
var GFxObject RedTitleTF;
var GFxObject BlueHeaderInfoMC;
var GFxObject BlueHeaderInfoPlayerTF;
var GFxObject BlueHeaderInfoScoreTF;
var GFxObject BlueHeaderInfoDeathTF;
var GFxObject BlueHeaderInfoPingTF;
var GFxObject RedHeaderInfoMC;
var GFxObject RedHeaderInfoPlayerTF;
var GFxObject RedHeaderInfoScoreTF;
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
var bool bInitialized;
var ScoreEntry RedEntries[12];
var ScoreEntry BlueEntries[4];
var ScoreboardState PreviousState;
var array<ScoreRow> BlueItems;
var array<ScoreRow> RedItems;
var transient int NameCnt;
var GFxObject Footer_NameTF;
var GFxObject Footer_PlaceLabelTF;
var GFxObject Footer_PlaceTF;
var GFxObject Footer_ScoreLabelTF;
var GFxObject Footer_ScoreTF;
var GFxObject Footer_DeathsLabelTF;
var GFxObject Footer_DeathsTF;
var const localized string ScoreLimitText;
var const localized string PlacementText;
var const localized string ScoreText;
var const localized string Deaths;
var const localized string Ping;
var const localized string Player;
var const localized string Players;
var const localized string RedTeamText;
var const localized string BlueTeamText;

function bool Start(optional bool StartPaused = false)
{
    super(GFxMoviePlayer).Start();
    Advance(0.0000000);
    bInitialized = false;
    RootMC = GetVariableObject("_root");
    ScoreboardMC = RootMC.GetObject("scoreboard");
    RootMC.SetFloat("_xscale", 95.0000000);
    RootMC.SetFloat("_yscale", 95.0000000);
    TitleMC = ScoreboardMC.GetObject("title");
    TimeMC = TitleMC.GetObject("time");
    Title_TitleGMC = TitleMC.GetObject("title_g");
    TimeTF = TimeMC.GetObject("textField");
    TitleTF = Title_TitleGMC.GetObject("textField");
    ScoreLimitMC = TitleMC.GetObject("scorelimit");
    ScoreLimitTF = ScoreLimitMC.GetObject("textField");
    ScoreLimitN = ScoreLimitMC.GetObject("limit");
    FooterMC = ScoreboardMC.GetObject("footer");
    FooterItemMC = FooterMC.GetObject("footer_item");
    FooterItemTF = FooterItemMC.GetObject("pressCos");
    Footer_NameTF = FooterItemMC.GetObject("name");
    Footer_PlaceLabelTF = FooterItemMC.GetObject("tplace");
    Footer_PlaceTF = FooterItemMC.GetObject("place");
    Footer_ScoreLabelTF = FooterItemMC.GetObject("tscore");
    Footer_ScoreTF = FooterItemMC.GetObject("score");
    Footer_DeathsLabelTF = FooterItemMC.GetObject("tdeaths");
    Footer_DeathsTF = FooterItemMC.GetObject("deaths");
    PreviousState.PlayerDeaths = -1;
    PreviousState.PlayerScore = -1.0000000;
    PreviousState.PlayerPlace = 255;
    Footer_PlaceLabelTF.SetText(PlacementText);
    Footer_ScoreLabelTF.SetText(ScoreText);
    Footer_DeathsLabelTF.SetText(Deaths);
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
    local PainPRI TalkerPRI;

    TalkerPRI = ResolveUniqueNetID(TalkingPlayer);
    // End:0xA9
    if(TalkerPRI != none)
    {
        TalkerPRI.bIsTalking = bIsTalking;
        TalkerPRI.LastTalkTime = Class'Engine.WorldInfo'.static.GetWorldInfo().RealTimeSeconds;
    }
    //return;    
}

function PainPRI ResolveUniqueNetID(UniqueNetId TestID)
{
    local PainGRI GRI;
    local int I;

    GRI = PainGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
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
                return PainPRI(GRI.PRIArray[I]);
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
    local PainGRI GRI;
    local PlayerController PC;

    PC = GetPC();
    // End:0x292
    if(PC != none)
    {
        GRI = PainGRI(PC.WorldInfo.GRI);
        // End:0x265
        if(GRI != none)
        {
            bTeamGame = GRI.IsTeamMultiPlayerGame();
            // End:0x16F
            if(bTeamGame)
            {
                ScoreboardMC.GotoAndStop("tdm");
                OverlayMC = ScoreboardMC.GetObject("team");
                BlueTeamMC = OverlayMC.GetObject("blue_team");
                RedTeamMC = OverlayMC.GetObject("red_team");                
            }
            else
            {
                ScoreboardMC.GotoAndStop("dm");
                OverlayMC = ScoreboardMC.GetObject("dm");
                RedTeamMC = ScoreboardMC.GetObject("dm");
            }
            TitleTF.SetText(Class'PKGFxUI_Menu_MultiServers'.static.GetLocalizedGameType(string(GRI.GameClass.default.Class)));            
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
    // End:0x2B5
    if(bTeamGame)
    {
        SetupBlueTeam();
    }
    ScoreLimitTF.SetText(ScoreLimitText);
    // End:0x325
    if(((PC != none) && GRI != none) && !bInitialized)
    {
        PlayOpenAnimation();
        bInitialized = true;
    }
    //return;    
}

function SetupBlueTeam()
{
    local byte I;
    local ScoreRow sr;
    local ASDisplayInfo DI;

    I = 0;
    J0x0C:

    // End:0x552 [Loop If]
    if(int(I) < int(4))
    {
        BlueItems[int(I)] = sr;
        BlueItems[int(I)].MovieClip = BlueTeamMC.GetObject("item" $ string(int(I) + int(1)));
        // End:0xD3
        if(BlueItems[int(I)].MovieClip == none)
        {
            return;
        }
        DI = BlueItems[int(I)].MovieClip.GetDisplayInfo();
        DI.Alpha = 50.0000000;
        BlueItems[int(I)].MovieClip.SetDisplayInfo(DI);
        BlueItems[int(I)].InnerMovieClip = BlueItems[int(I)].MovieClip.GetObject("item_g");
        // End:0x225
        if(BlueItems[int(I)].InnerMovieClip == none)
        {            
        }
        else
        {
            BlueItems[int(I)].DeathsTF = BlueItems[int(I)].InnerMovieClip.GetObject("deaths");
            BlueItems[int(I)].ScoreTF = BlueItems[int(I)].InnerMovieClip.GetObject("score");
            BlueItems[int(I)].NameTF = BlueItems[int(I)].InnerMovieClip.GetObject("name");
            BlueItems[int(I)].PingTF = BlueItems[int(I)].InnerMovieClip.GetObject("ping");
            BlueItems[int(I)].ReadyMC = BlueItems[int(I)].InnerMovieClip.GetObject("ready");
            BlueItems[int(I)].SpeakerMC = BlueItems[int(I)].InnerMovieClip.GetObject("speaker");
            BlueItems[int(I)].SpeakerMC.SetVisible(false);
            BlueItems[int(I)].NameTF.SetBool("html", true);
        }
        I++;
        // [Loop Continue]
        goto J0x0C;
    }
    BlueHeaderMC = BlueTeamMC.GetObject("header");
    BlueScoreTF = BlueHeaderMC.GetObject("score").GetObject("textField");
    BlueTitleTF = BlueHeaderMC.GetObject("title").GetObject("textField");
    BlueHeaderInfoMC = BlueHeaderMC.GetObject("headerinfo");
    BlueHeaderInfoPlayerTF = BlueHeaderInfoMC.GetObject("playername").GetObject("textField");
    BlueHeaderInfoScoreTF = BlueHeaderInfoMC.GetObject("playerkills").GetObject("textField");
    BlueHeaderInfoDeathTF = BlueHeaderInfoMC.GetObject("playerdeaths").GetObject("textField");
    BlueHeaderInfoPingTF = BlueHeaderInfoMC.GetObject("playerping").GetObject("textField");
    BlueHeaderInfoPlayerTF.SetText(Player);
    BlueHeaderInfoScoreTF.SetText(ScoreText);
    BlueHeaderInfoDeathTF.SetText(Deaths);
    BlueHeaderInfoPingTF.SetText(Ping);
    BlueTitleTF.SetText(BlueTeamText);
    //return;    
}

function SetupRedTeam()
{
    local byte I, imax;
    local ScoreRow sr;
    local ASDisplayInfo DI;

    imax = ((bTeamGame) ? 4 : 12);
    I = 0;
    J0x29:

    // End:0x576 [Loop If]
    if(int(I) < int(imax))
    {
        RedItems[int(I)] = sr;
        RedItems[int(I)].MovieClip = RedTeamMC.GetObject("item" $ string(int(I) + int(1)));
        // End:0xF7
        if(RedItems[int(I)].MovieClip == none)
        {
            return;
        }
        DI = RedItems[int(I)].MovieClip.GetDisplayInfo();
        DI.Alpha = 50.0000000;
        RedItems[int(I)].MovieClip.SetDisplayInfo(DI);
        RedItems[int(I)].InnerMovieClip = RedItems[int(I)].MovieClip.GetObject("item_g");
        // End:0x249
        if(RedItems[int(I)].InnerMovieClip == none)
        {            
        }
        else
        {
            RedItems[int(I)].DeathsTF = RedItems[int(I)].InnerMovieClip.GetObject("deaths");
            RedItems[int(I)].ScoreTF = RedItems[int(I)].InnerMovieClip.GetObject("score");
            RedItems[int(I)].NameTF = RedItems[int(I)].InnerMovieClip.GetObject("name");
            RedItems[int(I)].PingTF = RedItems[int(I)].InnerMovieClip.GetObject("ping");
            RedItems[int(I)].ReadyMC = RedItems[int(I)].InnerMovieClip.GetObject("ready");
            RedItems[int(I)].SpeakerMC = RedItems[int(I)].InnerMovieClip.GetObject("speaker");
            RedItems[int(I)].SpeakerMC.SetVisible(false);
            RedItems[int(I)].NameTF.SetBool("html", true);
        }
        I++;
        // [Loop Continue]
        goto J0x29;
    }
    RedHeaderMC = RedTeamMC.GetObject("header");
    RedTitleTF = RedHeaderMC.GetObject("title").GetObject("textField");
    RedHeaderInfoMC = RedHeaderMC.GetObject("headerinfo");
    RedHeaderInfoPlayerTF = RedHeaderInfoMC.GetObject("playername").GetObject("textField");
    RedHeaderInfoScoreTF = RedHeaderInfoMC.GetObject("playerkills").GetObject("textField");
    RedHeaderInfoDeathTF = RedHeaderInfoMC.GetObject("playerdeaths").GetObject("textField");
    RedHeaderInfoPingTF = RedHeaderInfoMC.GetObject("playerping").GetObject("textField");
    RedHeaderInfoPlayerTF.SetText(Player);
    RedHeaderInfoScoreTF.SetText(ScoreText);
    RedHeaderInfoDeathTF.SetText(Deaths);
    RedHeaderInfoPingTF.SetText(Ping);
    // End:0x873
    if(!bTeamGame)
    {
        RedTitleTF.SetText(Players);        
    }
    else
    {
        RedScoreTF = RedHeaderMC.GetObject("score").GetObject("textField");
        RedTitleTF.SetText(RedTeamText);
    }
    //return;    
}

function Draw()
{
    //return;    
}

function UpdatePRILists(PainGRI GRI)
{
    local int I, redPlayers, bluePlayers, maxRedPlayers;
    local EvilPlayerReplicationInfo PRI;
    local GFxObject NewPlayerRow;

    // End:0x11
    if(!bInitialized)
    {
        return;
    }
    redPlayers = 0;
    bluePlayers = 0;
    maxRedPlayers = ((bTeamGame) ? 4 : 12);
    I = 0;
    J0x4F:

    // End:0x33B [Loop If]
    if(I < GRI.PRIArray.Length)
    {
        PRI = EvilPlayerReplicationInfo(GRI.PRIArray[I]);
        // End:0x32D
        if((PRI != none) && IsValidScoreboardPlayer(PRI))
        {
            NewPlayerRow = none;
            // End:0x1F1
            if(!bTeamGame || PRI.Team.TeamIndex == int(RedTeamIndex))
            {
                // End:0x1EE
                if(!PRI.bOnlySpectator && redPlayers < maxRedPlayers)
                {
                    NewPlayerRow = RedItems[redPlayers].MovieClip;
                    UpdateRow(RedItems[redPlayers], RedEntries[redPlayers], PRI);
                    redPlayers++;
                }                
            }
            else
            {
                // End:0x2BA
                if((PRI.Team.TeamIndex == int(BlueTeamIndex)) && bluePlayers < 4)
                {
                    NewPlayerRow = BlueItems[bluePlayers].MovieClip;
                    UpdateRow(BlueItems[bluePlayers], BlueEntries[bluePlayers], PRI);
                    bluePlayers++;
                }
            }
            // End:0x32D
            if(PRI.IsLocalPlayerPRI())
            {
                // End:0x306
                if(PlayerRow != NewPlayerRow)
                {
                    SetPlayerRow(NewPlayerRow);
                }
                UpdateFooter(GRI, PRI, byte(I));
            }
        }
        I++;
        // [Loop Continue]
        goto J0x4F;
    }
    I = redPlayers;
    J0x34E:

    // End:0x412 [Loop If]
    if(I < maxRedPlayers)
    {
        // End:0x404
        if(RedEntries[I].PlayerName != "")
        {
            RedEntries[I].PlayerName = "";
            RedEntries[I].PlayerPing = -1;
            ClearRow(RedItems[I]);
        }
        I++;
        // [Loop Continue]
        goto J0x34E;
    }
    I = bluePlayers;
    J0x425:

    // End:0x4E2 [Loop If]
    if(I < 4)
    {
        // End:0x4D4
        if(BlueEntries[I].PlayerName != "")
        {
            BlueEntries[I].PlayerName = "";
            BlueEntries[I].PlayerPing = -1;
            ClearRow(BlueItems[I]);
        }
        I++;
        // [Loop Continue]
        goto J0x425;
    }
    //return;    
}

function ClearRow(ScoreRow ThisRow)
{
    local ASDisplayInfo displayInfo;

    displayInfo = ThisRow.MovieClip.GetDisplayInfo();
    displayInfo.Alpha = 50.0000000;
    ThisRow.MovieClip.SetDisplayInfo(displayInfo);
    ThisRow.ScoreTF.SetText("");
    ThisRow.DeathsTF.SetText("");
    ThisRow.NameTF.SetString("htmlText", "");
    ThisRow.PingTF.SetText("");
    ThisRow.ReadyMC.SetVisible(false);
    ThisRow.SpeakerMC.SetVisible(false);
    //return;    
}

function UpdateRow(ScoreRow ThisRow, out ScoreEntry ThisEntry, EvilPlayerReplicationInfo ThisPRI)
{
    local ASDisplayInfo displayInfo;
    local bool bUpdateItemRenderer;
    local string NameAndFlagText;
    local array<ASValue> args;
    local PainGRI GRI;

    GRI = PainGRI(GetPC().WorldInfo.GRI);
    bUpdateItemRenderer = false;
    // End:0x3CA
    if((ThisPRI.PlayerName != ThisEntry.PlayerName) || ThisPRI.bHasFlag != ThisEntry.bHasFlag)
    {
        // End:0x2B1
        if(ThisEntry.PlayerName == "")
        {
            displayInfo = ThisRow.MovieClip.GetDisplayInfo();
            displayInfo.Alpha = 100.0000000;
            ThisRow.MovieClip.SetDisplayInfo(displayInfo);
            ThisRow.ScoreTF.SetText(string(int(ThisPRI.Score)));
            ThisEntry.PlayerScore = int(ThisPRI.Score);
            ThisRow.DeathsTF.SetText(string(ThisPRI.Deaths));
            ThisEntry.PlayerDeaths = ThisPRI.Deaths;
        }
        NameAndFlagText = "";
        // End:0x313
        if(ThisPRI.bHasFlag)
        {            
            NameAndFlagText $= "<img src=\"flag_noglow\">&nbsp;";
        }        
        NameAndFlagText $= ThisPRI.PlayerName;
        ThisEntry.PlayerName = ThisPRI.PlayerName;
        ThisEntry.bHasFlag = ThisPRI.bHasFlag;
        bUpdateItemRenderer = true;
    }
    // End:0x47C
    if(ThisPRI.Score != float(ThisEntry.PlayerScore))
    {
        NameAndFlagText = ThisPRI.PlayerName;
        ThisEntry.PlayerScore = int(ThisPRI.Score);
        bUpdateItemRenderer = true;
    }
    // End:0x52A
    if(ThisPRI.Deaths != ThisEntry.PlayerDeaths)
    {
        NameAndFlagText = ThisPRI.PlayerName;
        ThisEntry.PlayerDeaths = ThisPRI.Deaths;
        bUpdateItemRenderer = true;
    }
    // End:0x63D
    if(ThisPRI.bReadyToPlay != ThisEntry.bReady)
    {
        // End:0x5C9
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
    // End:0x716
    if(int(ThisPRI.Ping) != ThisEntry.PlayerPing)
    {
        ThisRow.PingTF.SetText(string(int(ThisPRI.Ping) * int(4)));
        ThisEntry.PlayerPing = int(ThisPRI.Ping);
    }
    // End:0x76E
    if(GRI.bMatchHasBegun)
    {
        ThisRow.ReadyMC.SetVisible(false);        
    }
    else
    {
        ThisRow.ReadyMC.SetVisible(true);
    }
    // End:0x87B
    if(PlayerIsMuted(ThisPRI.UniqueId))
    {
        // End:0x878
        if(!ThisEntry.bMuted)
        {
            ThisRow.SpeakerMC.SetVisible(true);
            ThisRow.SpeakerMC.GotoAndStop("mute");
            ThisEntry.bMuted = true;
        }        
    }
    else
    {
        ThisEntry.bMuted = false;
        // End:0x986
        if(Class'PKUIManager'.static.GetChatIconOpacity(PainPRI(ThisPRI)) > 0.5000000)
        {
            // End:0x983
            if(!ThisEntry.bTalking)
            {
                ThisRow.SpeakerMC.SetVisible(true);
                ThisRow.SpeakerMC.GotoAndStop("active");
                ThisEntry.bTalking = true;
            }            
        }
        else
        {
            // End:0x9F8
            if(ThisEntry.bTalking)
            {
                ThisRow.SpeakerMC.SetVisible(false);
                ThisEntry.bTalking = false;
            }
        }
    }
    // End:0xB72
    if(bUpdateItemRenderer)
    {
        args.Length = 0;
        ThisRow.InnerMovieClip.SetString("PlayerName", NameAndFlagText);
        ThisRow.InnerMovieClip.SetString("PlayerScore", string(ThisEntry.PlayerScore));
        ThisRow.InnerMovieClip.SetString("PlayerDeaths", string(ThisEntry.PlayerDeaths));        
        ThisRow.InnerMovieClip.Invoke("UpdateAfterStateChange", args);
    }
    //return;    
}

function Tick(float DeltaTime)
{
    local PainGRI GRI;

    ConfigScoreboard();
    GRI = PainGRI(GetPC().WorldInfo.GRI);
    // End:0x99
    if(GRI != none)
    {
        UpdatePRILists(GRI);
        UpdateHeaders(GRI);
        UpdatePreviousState(GRI);
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
    // End:0xBE
    if(PlayerRow != none)
    {
        PlayerRow.GetObject("item_g").GotoAndStop("player");
    }
    //return;    
}

function UpdatePreviousState(PainGRI GRI)
{
    PreviousState.RemainingTime = GRI.RemainingTime;
    PreviousState.ScoreLimit = GRI.GoalScore;
    // End:0x13F
    if(bTeamGame)
    {
        PreviousState.RedScore = int(GRI.Teams[int(RedTeamIndex)].Score);
        PreviousState.BlueScore = int(GRI.Teams[int(BlueTeamIndex)].Score);
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

function UpdateHeaders(PainGRI GRI)
{
    // End:0x1A5
    if(bTeamGame)
    {
        // End:0xD9
        if(float(PreviousState.RedScore) != GRI.Teams[int(RedTeamIndex)].Score)
        {
            RedScoreTF.SetText(string(Min(int(GRI.Teams[int(RedTeamIndex)].Score), 9999)));
        }
        // End:0x1A5
        if(float(PreviousState.BlueScore) != GRI.Teams[int(BlueTeamIndex)].Score)
        {
            BlueScoreTF.SetText(string(Min(int(GRI.Teams[int(BlueTeamIndex)].Score), 9999)));
        }
    }
    // End:0x270
    if(GRI.RemainingTime != PreviousState.RemainingTime)
    {
        TimeTF.SetText(FormatTime(((GRI.TimeLimit != 0) ? GRI.RemainingTime : GRI.ElapsedTime)));
    }
    // End:0x2EF
    if(GRI.GoalScore != PreviousState.ScoreLimit)
    {
        ScoreLimitN.SetText(string(GRI.GoalScore));
    }
    //return;    
}

function UpdateFooter(PainGRI GRI, EvilPlayerReplicationInfo LocalPlayerPRI, optional byte PRIIndex)
{
    local byte PlayerRelRank, PlayerTeamIndex;

    // End:0x30
    if(!bTeamGame)
    {
        PlayerRelRank = byte(int(PRIIndex) + int(1));        
    }
    else
    {
        PlayerTeamIndex = LocalPlayerPRI.GetTeamNum();
        // End:0x18D
        if(((GRI.Teams[int(RedTeamIndex)].Score > GRI.Teams[int(BlueTeamIndex)].Score) && int(PlayerTeamIndex) == int(RedTeamIndex)) || GRI.Teams[int(RedTeamIndex)].Score == GRI.Teams[int(BlueTeamIndex)].Score)
        {
            PlayerRelRank = 1;            
        }
        else
        {
            PlayerRelRank = 2;
        }
    }
    // End:0x1F2
    if(int(PreviousState.PlayerPlace) != int(PlayerRelRank))
    {
        Footer_PlaceTF.SetText(string(PlayerRelRank));
    }
    // End:0x273
    if(PreviousState.PlayerScore != LocalPlayerPRI.Score)
    {
        Footer_ScoreTF.SetText(string(int(LocalPlayerPRI.Score)));
    }
    // End:0x2F0
    if(PreviousState.PlayerName != LocalPlayerPRI.PlayerName)
    {
        Footer_NameTF.SetText(LocalPlayerPRI.PlayerName);
    }
    // End:0x36F
    if(PreviousState.PlayerDeaths != LocalPlayerPRI.Deaths)
    {
        Footer_DeathsTF.SetText(string(LocalPlayerPRI.Deaths));
    }
    PreviousState.PlayerName = LocalPlayerPRI.PlayerName;
    PreviousState.PlayerScore = float(int(LocalPlayerPRI.Score));
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

function bool IsValidScoreboardPlayer(EvilPlayerReplicationInfo PRI)
{
    // End:0xFF
    if((!PRI.bIsInactive && int(PRI.WorldInfo.NetMode) != int(NM_Client)) && (PRI.Owner == none) || (PlayerController(PRI.Owner) != none) && PlayerController(PRI.Owner).Player == none)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function string GetTimeOnline(EvilPlayerReplicationInfo PRI)
{
    return "" @ Class'EvilGame.UTHUD'.static.FormatTime(PRI.WorldInfo.GRI.ElapsedTime);
    //return ReturnValue;    
}

defaultproperties
{
    BlueTeamIndex=1
    RedEntries[0]=(PlayerName="",PlayerScore=0,PlayerDeaths=0,PlayerPing=-1,bHasFlag=false,bReady=false,bTalking=false,bMuted=false)
    RedEntries[1]=(PlayerName="",PlayerScore=0,PlayerDeaths=0,PlayerPing=-1,bHasFlag=false,bReady=false,bTalking=false,bMuted=false)
    RedEntries[2]=(PlayerName="",PlayerScore=0,PlayerDeaths=0,PlayerPing=-1,bHasFlag=false,bReady=false,bTalking=false,bMuted=false)
    RedEntries[3]=(PlayerName="",PlayerScore=0,PlayerDeaths=0,PlayerPing=-1,bHasFlag=false,bReady=false,bTalking=false,bMuted=false)
    RedEntries[4]=(PlayerName="",PlayerScore=0,PlayerDeaths=0,PlayerPing=-1,bHasFlag=false,bReady=false,bTalking=false,bMuted=false)
    RedEntries[5]=(PlayerName="",PlayerScore=0,PlayerDeaths=0,PlayerPing=-1,bHasFlag=false,bReady=false,bTalking=false,bMuted=false)
    RedEntries[6]=(PlayerName="",PlayerScore=0,PlayerDeaths=0,PlayerPing=-1,bHasFlag=false,bReady=false,bTalking=false,bMuted=false)
    RedEntries[7]=(PlayerName="",PlayerScore=0,PlayerDeaths=0,PlayerPing=-1,bHasFlag=false,bReady=false,bTalking=false,bMuted=false)
    RedEntries[8]=(PlayerName="",PlayerScore=0,PlayerDeaths=0,PlayerPing=-1,bHasFlag=false,bReady=false,bTalking=false,bMuted=false)
    RedEntries[9]=(PlayerName="",PlayerScore=0,PlayerDeaths=0,PlayerPing=-1,bHasFlag=false,bReady=false,bTalking=false,bMuted=false)
    RedEntries[10]=(PlayerName="",PlayerScore=0,PlayerDeaths=0,PlayerPing=-1,bHasFlag=false,bReady=false,bTalking=false,bMuted=false)
    RedEntries[11]=(PlayerName="",PlayerScore=0,PlayerDeaths=0,PlayerPing=-1,bHasFlag=false,bReady=false,bTalking=false,bMuted=false)
    BlueEntries[0]=(PlayerName="",PlayerScore=0,PlayerDeaths=0,PlayerPing=-1,bHasFlag=false,bReady=false,bTalking=false,bMuted=false)
    BlueEntries[1]=(PlayerName="",PlayerScore=0,PlayerDeaths=0,PlayerPing=-1,bHasFlag=false,bReady=false,bTalking=false,bMuted=false)
    BlueEntries[2]=(PlayerName="",PlayerScore=0,PlayerDeaths=0,PlayerPing=-1,bHasFlag=false,bReady=false,bTalking=false,bMuted=false)
    BlueEntries[3]=(PlayerName="",PlayerScore=0,PlayerDeaths=0,PlayerPing=-1,bHasFlag=false,bReady=false,bTalking=false,bMuted=false)
    ScoreLimitText="Score Limit"
    PlacementText="Your Placement"
    ScoreText="Score"
    Deaths="Deaths"
    Ping="Ping"
    Player="Player"
    Players="Players"
    RedTeamText="Red Team"
    BlueTeamText="Blue Team"
    MovieInfo=SwfMovie'PKHD_UI.PKscoreboard'
}