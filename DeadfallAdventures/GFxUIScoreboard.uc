class GFxUIScoreboard extends UTGFxTweenableMoviePlayer
    config(UI);

struct ScoreEntry
{
    var string PlayerName;
    var int PlayerScore;
    var int PlayerDeaths;
    var bool bHasFlag;

    structdefaultproperties
    {
        PlayerName=""
        PlayerScore=0
        PlayerDeaths=0
        bHasFlag=false
    }
};

struct ScoreboardState
{
    var int RemainingTime;
    var int RedScore;
    var int BlueScore;
    var string PlayerName;
    var byte PlayerPlace;
    var float PlayerScore;
    var int PlayerDeaths;

    structdefaultproperties
    {
        RemainingTime=0
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

    structdefaultproperties
    {
        MovieClip=none
        InnerMovieClip=none
        DeathsTF=none
        ScoreTF=none
        NameTF=none
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
var GFxObject BlueHeaderMC;
var GFxObject BlueScoreTF;
var GFxObject BlueTitleTF;
var GFxObject RedHeaderMC;
var GFxObject RedScoreTF;
var GFxObject RedTitleTF;
var GFxObject FooterMC;
var GFxObject FooterItemMC;
var byte RedTeamIndex;
var byte BlueTeamIndex;
var GFxObject PlayerRow;
var bool bPlayerRowTween;
var bool bTeamGame;
var bool bInitialized;
var ScoreEntry RedEntries[12];
var ScoreEntry BlueEntries[12];
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

function bool Start(optional bool StartPaused = false)
{
    super(GFxMoviePlayer).Start();
    Advance(0.0000000);
    // End:0x38
    if(!bInitialized)
    {
        ConfigScoreboard();
    }
    Draw();
    return true;
    //return ReturnValue;    
}

function PlayOpenAnimation()
{
    TitleMC.GotoAndPlay("open");
    FooterMC.GotoAndPlay("open");
    OverlayMC.GotoAndPlay("open");
    //return;    
}

function PlayCloseAnimation()
{
    TitleMC.GotoAndPlay("close");
    FooterMC.GotoAndPlay("close");
    OverlayMC.GotoAndPlay("close");
    //return;    
}

function ConfigScoreboard()
{
    local PlayerController PC;

    RootMC = GetVariableObject("_root");
    ScoreboardMC = RootMC.GetObject("scoreboard");
    RootMC.SetFloat("_xscale", 95.0000000);
    RootMC.SetFloat("_yscale", 95.0000000);
    RootMC.SetFloat("_y", RootMC.GetFloat("_y") + float(25));
    PC = GetPC();
    // End:0x19A
    if(PC != none)
    {
        ScoreboardMC.GotoAndStop("dm");
        OverlayMC = ScoreboardMC.GetObject("dm");
        RedTeamMC = ScoreboardMC.GetObject("dm");
    }
    TitleMC = ScoreboardMC.GetObject("title");
    TimeMC = TitleMC.GetObject("time");
    Title_TitleGMC = TitleMC.GetObject("title_g");
    TimeTF = TimeMC.GetObject("textField");
    TitleTF = Title_TitleGMC.GetObject("textField");
    FooterMC = ScoreboardMC.GetObject("footer");
    FooterItemMC = FooterMC.GetObject("footer_item");
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
    Footer_PlaceLabelTF.SetText("YOUR PLACEMENT");
    Footer_ScoreLabelTF.SetText("SCORE");
    Footer_DeathsLabelTF.SetText("DEATHS");
    SetupRedTeam();
    // End:0x55F
    if(bTeamGame)
    {
        SetupBlueTeam();
    }
    FloatScoreboardAnimationX(true);
    FloatScoreboardAnimationY(true);
    bInitialized = true;
    //return;    
}

function SetupBlueTeam()
{
    local byte I;
    local ScoreRow sr;
    local ASDisplayInfo DI;

    I = 0;
    J0x0C:

    // End:0x366 [Loop If]
    if(int(I) < int(12))
    {
        BlueItems[int(I)] = sr;
        BlueItems[int(I)].MovieClip = BlueTeamMC.GetObject("item" $ string(int(I) + int(1)));
        BlueItems[int(I)].MovieClip.SetFloat("_z", 200.0000000);
        DI = BlueItems[int(I)].MovieClip.GetDisplayInfo();
        DI.Alpha = 50.0000000;
        BlueItems[int(I)].MovieClip.SetDisplayInfo(DI);
        BlueItems[int(I)].InnerMovieClip = BlueItems[int(I)].MovieClip.GetObject("item_g");
        BlueItems[int(I)].DeathsTF = BlueItems[int(I)].InnerMovieClip.GetObject("deaths");
        BlueItems[int(I)].ScoreTF = BlueItems[int(I)].InnerMovieClip.GetObject("score");
        BlueItems[int(I)].NameTF = BlueItems[int(I)].InnerMovieClip.GetObject("name");
        I++;
        // [Loop Continue]
        goto J0x0C;
    }
    BlueHeaderMC = BlueTeamMC.GetObject("header");
    BlueHeaderMC.GetObject("header1").SetFloat("_z", 200.0000000);
    BlueScoreTF = BlueHeaderMC.GetObject("score").GetObject("textField");
    BlueTitleTF = BlueHeaderMC.GetObject("title").GetObject("textField");
    //return;    
}

function SetupRedTeam()
{
    local byte I;
    local ScoreRow sr;
    local ASDisplayInfo DI;

    I = 0;
    J0x0C:

    // End:0x366 [Loop If]
    if(int(I) < int(12))
    {
        RedItems[int(I)] = sr;
        RedItems[int(I)].MovieClip = RedTeamMC.GetObject("item" $ string(int(I) + int(1)));
        RedItems[int(I)].MovieClip.SetFloat("_z", 200.0000000);
        DI = RedItems[int(I)].MovieClip.GetDisplayInfo();
        DI.Alpha = 50.0000000;
        RedItems[int(I)].MovieClip.SetDisplayInfo(DI);
        RedItems[int(I)].InnerMovieClip = RedItems[int(I)].MovieClip.GetObject("item_g");
        RedItems[int(I)].DeathsTF = RedItems[int(I)].InnerMovieClip.GetObject("deaths");
        RedItems[int(I)].ScoreTF = RedItems[int(I)].InnerMovieClip.GetObject("score");
        RedItems[int(I)].NameTF = RedItems[int(I)].InnerMovieClip.GetObject("name");
        I++;
        // [Loop Continue]
        goto J0x0C;
    }
    RedHeaderMC = RedTeamMC.GetObject("header");
    RedHeaderMC.GetObject("header1").SetFloat("_z", 200.0000000);
    RedScoreTF = RedHeaderMC.GetObject("score").GetObject("textField");
    RedTitleTF = RedHeaderMC.GetObject("title").GetObject("textField");
    //return;    
}

function Draw()
{
    local UTGameReplicationInfo GRI;
    local PlayerController PC;

    PC = GetPC();
    // End:0x69
    if(PC != none)
    {
        GRI = UTGameReplicationInfo(PC.WorldInfo.GRI);
    }
    RedTitleTF.SetText(Caps("<Strings:UTGameUI.JoinGame.Players>"));
    // End:0x138
    if(GRI != none)
    {
        TitleTF.SetText(GRI.GameClass.default.GameName);
        UpdateHeaders(GRI);
        UpdatePreviousState(GRI);
    }
    //return;    
}

function UpdatePRILists(UTGameReplicationInfo GRI)
{
    local int I, redPlayers, bluePlayers;
    local EvilPlayerReplicationInfo PRI;
    local GFxObject NewPlayerRow;

    redPlayers = 0;
    bluePlayers = 0;
    I = 0;
    J0x21:

    // End:0x31B [Loop If]
    if(I < GRI.PRIArray.Length)
    {
        PRI = EvilPlayerReplicationInfo(GRI.PRIArray[I]);
        // End:0x30D
        if((PRI != none) && IsValidScoreboardPlayer(PRI))
        {
            NewPlayerRow = none;
            // End:0x1D1
            if((PRI.Team == none) || PRI.Team.TeamIndex == int(RedTeamIndex))
            {
                // End:0x1CE
                if(!PRI.bOnlySpectator && redPlayers < 12)
                {
                    NewPlayerRow = RedItems[redPlayers].MovieClip;
                    UpdateRow(RedItems[redPlayers], RedEntries[redPlayers], PRI);
                    redPlayers++;
                }                
            }
            else
            {
                // End:0x29A
                if((PRI.Team.TeamIndex == int(BlueTeamIndex)) && bluePlayers < 12)
                {
                    NewPlayerRow = BlueItems[bluePlayers].MovieClip;
                    UpdateRow(BlueItems[bluePlayers], BlueEntries[bluePlayers], PRI);
                    bluePlayers++;
                }
            }
            // End:0x30D
            if(PRI.IsLocalPlayerPRI())
            {
                // End:0x2E6
                if(PlayerRow != NewPlayerRow)
                {
                    SetPlayerRow(NewPlayerRow);
                }
                UpdateFooter(GRI, PRI, byte(I));
            }
        }
        I++;
        // [Loop Continue]
        goto J0x21;
    }
    I = redPlayers;
    J0x32E:

    // End:0x3BF [Loop If]
    if(I < 12)
    {
        // End:0x3B1
        if(RedEntries[I].PlayerName != "")
        {
            RedEntries[I].PlayerName = "";
            ClearRow(RedItems[I]);
        }
        I++;
        // [Loop Continue]
        goto J0x32E;
    }
    I = bluePlayers;
    J0x3D2:

    // End:0x463 [Loop If]
    if(I < 12)
    {
        // End:0x455
        if(BlueEntries[I].PlayerName != "")
        {
            BlueEntries[I].PlayerName = "";
            ClearRow(BlueItems[I]);
        }
        I++;
        // [Loop Continue]
        goto J0x3D2;
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
    //return;    
}

function UpdateRow(ScoreRow ThisRow, out ScoreEntry ThisEntry, EvilPlayerReplicationInfo ThisPRI)
{
    local ASDisplayInfo displayInfo;
    local bool bUpdateItemRenderer;
    local string NameAndFlagText;
    local array<ASValue> args;

    bUpdateItemRenderer = false;
    // End:0x383
    if((ThisPRI.PlayerName != ThisEntry.PlayerName) || ThisPRI.bHasFlag != ThisEntry.bHasFlag)
    {
        // End:0x26A
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
        // End:0x2CC
        if(ThisPRI.bHasFlag)
        {            
            NameAndFlagText $= "<img src=\"flag_noglow\">&nbsp;";
        }        
        NameAndFlagText $= ThisPRI.PlayerName;
        ThisEntry.PlayerName = ThisPRI.PlayerName;
        ThisEntry.bHasFlag = ThisPRI.bHasFlag;
        bUpdateItemRenderer = true;
    }
    // End:0x40D
    if(ThisPRI.Score != float(ThisEntry.PlayerScore))
    {
        ThisEntry.PlayerScore = int(ThisPRI.Score);
        bUpdateItemRenderer = true;
    }
    // End:0x493
    if(ThisPRI.Deaths != ThisEntry.PlayerDeaths)
    {
        ThisEntry.PlayerDeaths = ThisPRI.Deaths;
        bUpdateItemRenderer = true;
    }
    // End:0x60D
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
    local UTGameReplicationInfo GRI;

    GRI = UTGameReplicationInfo(GetPC().WorldInfo.GRI);
    // End:0x8F
    if(GRI != none)
    {
        UpdatePRILists(GRI);
        UpdateHeaders(GRI);
        UpdatePreviousState(GRI);
    }
    super.Tick(DeltaTime);
    //return;    
}

function SetPlayerRow(GFxObject UpdatedPlayerRow)
{
    // End:0x92
    if(PlayerRow != none)
    {
        ClearsTweensOnMovieClip(PlayerRow);
        PlayerRow.SetFloat("_z", 200.0000000);
        PlayerRow.GetObject("item_g").GotoAndStop("default");
    }
    PlayerRow = UpdatedPlayerRow;
    // End:0x10D
    if(PlayerRow != none)
    {
        TweenPlayerRow(UpdatedPlayerRow);
        PlayerRow.GetObject("item_g").GotoAndStop("player");
    }
    //return;    
}

function UpdatePreviousState(UTGameReplicationInfo GRI)
{
    PreviousState.RemainingTime = GRI.RemainingTime;
    // End:0x104
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

function UpdateHeaders(UTGameReplicationInfo GRI)
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
    //return;    
}

function UpdateFooter(UTGameReplicationInfo GRI, EvilPlayerReplicationInfo LocalPlayerPRI, optional byte PRIIndex)
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
        // End:0x108
        if((GRI.Teams[int(RedTeamIndex)].Score > GRI.Teams[int(BlueTeamIndex)].Score) && int(PlayerTeamIndex) == int(RedTeamIndex))
        {
            PlayerRelRank = 1;            
        }
        else
        {
            PlayerRelRank = 2;
        }
    }
    // End:0x16D
    if(int(PreviousState.PlayerPlace) != int(PlayerRelRank))
    {
        Footer_PlaceTF.SetText(string(PlayerRelRank));
    }
    // End:0x1EE
    if(PreviousState.PlayerScore != LocalPlayerPRI.Score)
    {
        Footer_ScoreTF.SetText(string(int(LocalPlayerPRI.Score)));
    }
    // End:0x26B
    if(PreviousState.PlayerName != LocalPlayerPRI.PlayerName)
    {
        Footer_NameTF.SetText(LocalPlayerPRI.PlayerName);
    }
    // End:0x2EA
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
    return "" @ Class'UTHUD'.static.FormatTime(PRI.WorldInfo.GRI.ElapsedTime);
    //return ReturnValue;    
}

defaultproperties
{
    BlueTeamIndex=1
}